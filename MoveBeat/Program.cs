using System;
using System.Diagnostics;
using System.IO;
using System.Threading;
using Microsoft.Kinect;

class Program
{
    const int OscPort = 7400;
    const double ConsoleRedrawIntervalMs = 250; // throttle console redraw to ~4 Hz

    // The live status block redraws in place below the startup banner, so the
    // banner (OSC target, IsAvailable) stays readable instead of being
    // overwritten every frame.
    //
    // These rows are MEASURED after the banner is printed, not hardcoded.
    // They used to be constants (6 and 8) and that was wrong in two ways:
    //   - the watchdog writes a 3-line message starting at the availability
    //     row, so its last line landed exactly on the first line of the status
    //     block and the two redraws fought each other every 5 seconds;
    //   - the whole layout shifted down by 5 rows whenever the "no wired
    //     Ethernet" warning printed, putting every write in the wrong place.
    // Either one makes the screen churn in a way that reads as "the app keeps
    // restarting" when the process has in fact been up the whole time.
    const int AvailabilityRows = 4; // 1 line for IsAvailable + up to 3 for the watchdog
    static int availabilityRow = 6;
    static int statusTop = 10;

    static KinectSensor sensor;
    static BodyFrameReader bodyReader;
    static Body[] bodies;
    static OscSender osc;

    static JointType[] allJointTypes;
    static string[] jointAddresses; // indexed by (int)JointType, e.g. "/mb/handright"

    static readonly Stopwatch redrawStopwatch = Stopwatch.StartNew();
    static readonly Stopwatch sinceLastFrame = Stopwatch.StartNew();
    static readonly Stopwatch uptime = Stopwatch.StartNew();
    static Timer frameWatchdog;
    static volatile bool running = true;
    static volatile bool shutdownDone;
    static bool streamStalled;

    // Three different threads draw to the console - the Kinect frame thread,
    // the Kinect availability event, and the watchdog timer. "Set the cursor,
    // then write" is not atomic, so without this lock they interleave and the
    // display becomes garbage that looks like corruption.
    static readonly object consoleLock = new object();

    static long framesReceived;
    static long consecutiveSendFailures;
    static long totalSendFailures;

    static void Main(string[] args)
    {
        bool testMode = false;
        string ipOverride = null;

        for (int i = 0; i < args.Length; i++)
        {
            if (string.Equals(args[i], "--test", StringComparison.OrdinalIgnoreCase))
            {
                testMode = true;
            }
            else if (string.Equals(args[i], "--ip", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
            {
                ipOverride = args[++i];
            }
        }

        // Install these before anything else can throw. Without them a single
        // transient exception on ANY background thread (a Kinect frame
        // callback, the watchdog timer) terminates the process silently, with
        // nothing written down anywhere - which is indistinguishable from
        // "the app crashed for no reason".
        AppDomain.CurrentDomain.UnhandledException += CurrentDomain_UnhandledException;
        AppDomain.CurrentDomain.ProcessExit += CurrentDomain_ProcessExit;

        Log("--------------------------------------------------------------");
        Log(string.Format("MoveBeat starting. PID={0} testMode={1} ipOverride={2}",
            Process.GetCurrentProcess().Id, testMode, ipOverride ?? "(auto)"));

        BuildJointTables();

        osc = new OscSender(OscPort, ipOverride);
        Console.WriteLine("OSC target: " + osc.TargetAddress + ":" + osc.TargetPort + "  (wired Ethernet only)");
        Log("OSC target: " + osc.TargetAddress + ":" + osc.TargetPort);

        // Hitting the 255.255.255.255 fallback means no usable wired interface
        // was found - almost always an unplugged or unconfigured LAN cable.
        // Say so loudly: otherwise the app looks perfectly healthy while
        // nothing ever reaches the Mac.
        if (ipOverride == null && osc.TargetAddress.Equals(System.Net.IPAddress.Broadcast))
        {
            Console.WriteLine();
            Console.WriteLine("  WARNING: no wired Ethernet interface found - falling back to 255.255.255.255.");
            Console.WriteLine("  Check the LAN cable. Wi-Fi is intentionally not used for the OSC stream.");
            Console.WriteLine("  Override with:  MoveBeat.exe --ip <address>");
            Console.WriteLine();
            Log("WARNING: no wired Ethernet interface found - using 255.255.255.255.");
        }

        Console.CancelKeyPress += Console_CancelKeyPress;

        if (testMode)
        {
            RunTestMode();
            return;
        }

        Console.WriteLine("Starting Kinect body test...");

        try
        {
            sensor = KinectSensor.GetDefault();

            if (sensor == null)
            {
                Console.WriteLine("Kinect not found");
                Log("Kinect not found (KinectSensor.GetDefault() returned null).");
                WaitForExitKey();
                Shutdown();
                return;
            }

            bodyReader = sensor.BodyFrameSource.OpenReader();
            bodyReader.FrameArrived += BodyReader_FrameArrived;

            // IsAvailable is the useful diagnostic when frames arrive but no
            // body is ever tracked: the sensor can be open and delivering
            // empty frames while not actually streaming (USB bandwidth or
            // power problems). Report it at startup and on every change.
            sensor.IsAvailableChanged += Sensor_IsAvailableChanged;

            sensor.Open();

            Console.WriteLine("Kinect opened. IsOpen=" + sensor.IsOpen + " IsAvailable=" + sensor.IsAvailable);
            Console.WriteLine("(IsAvailable can take a second to become True after opening.)");
            Console.WriteLine("Stand 2-3 m in front of the Kinect, fully in view...");
            Console.WriteLine("Press ENTER to exit (or Ctrl+C)...");
            Console.WriteLine();

            Log("Kinect opened. IsOpen=" + sensor.IsOpen + " IsAvailable=" + sensor.IsAvailable);

            // Measure where the banner actually ended, then reserve the
            // availability/watchdog block so the status block below it can
            // never be overwritten. See the comment on AvailabilityRows.
            lock (consoleLock)
            {
                try { availabilityRow = Console.CursorTop; }
                catch { availabilityRow = 6; }
                statusTop = availabilityRow + AvailabilityRows;
            }

            // Watchdog: "no body tracked" and "no frames arriving at all" look
            // identical on screen, but they are completely different problems.
            // Say which one it is.
            frameWatchdog = new Timer(CheckFrameFlow, null, 5000, 5000);

            WaitForExitKey();

            Shutdown();
        }
        catch (Exception ex)
        {
            Console.WriteLine("ERROR: " + ex);
            Log("FATAL during startup: " + ex);
            WaitForExitKey();
            Shutdown();
        }
    }

    /// <summary>
    /// Blocks until the user presses ENTER.
    ///
    /// Console.ReadLine() returns null instead of blocking when stdin is not a
    /// real console - which is exactly what happens when this app is launched
    /// with redirected output (Start-Process -RedirectStandardOutput leaves
    /// stdin as the null device). The old code called ReadLine() directly, so
    /// in that situation the app fell straight through to Shutdown() and
    /// exited within milliseconds of starting. Relaunch it in any kind of loop
    /// and the result is a process that appears to crash and restart forever,
    /// while the sensor is perfectly healthy.
    ///
    /// Staying alive is the right behaviour here: this app's job is to stream,
    /// and having no keyboard attached is not a reason to stop.
    /// </summary>
    static void WaitForExitKey()
    {
        if (Console.ReadLine() != null)
            return;

        Console.WriteLine();
        Console.WriteLine("  stdin is not interactive (output is redirected?) - ENTER cannot be read.");
        Console.WriteLine("  Staying alive and streaming. Press Ctrl+C or close this window to exit.");
        Log("stdin is not interactive - ignoring ENTER-to-exit and continuing to stream.");

        while (running)
            Thread.Sleep(500);
    }

    /// <summary>
    /// Reports when the sensor stops delivering frames entirely, which is a
    /// different fault from "a person is not in view" but looks the same.
    /// The usual cause is a Kinect left in a bad state after a client was
    /// hard-killed without calling sensor.Close(); the cure is a physical
    /// unplug/replug of the sensor's USB and power.
    ///
    /// Only state CHANGES are logged, so the log shows exactly when the stream
    /// stopped and when it came back. A sensor that drops and re-enumerates
    /// every few seconds is then obvious at a glance, instead of hiding behind
    /// an on-screen message that appears and disappears.
    /// </summary>
    static void CheckFrameFlow(object state)
    {
        try
        {
            // Snapshot: Shutdown() sets the field to null, and the old code
            // null-checked the field and then dereferenced it again, so a
            // shutdown landing between the two threw NullReferenceException on
            // a threadpool thread - an unhandled exception, i.e. process death.
            KinectSensor s = sensor;
            if (s == null || shutdownDone)
                return;

            double idleSeconds = sinceLastFrame.Elapsed.TotalSeconds;

            if (idleSeconds < 5)
            {
                if (streamStalled)
                {
                    streamStalled = false;
                    Log(string.Format("Frames RESUMED after a stall. framesReceived={0}", Interlocked.Read(ref framesReceived)));
                    lock (consoleLock)
                    {
                        TrySetCursor(0, availabilityRow);
                        WritePadded("Sensor streaming. IsOpen=" + s.IsOpen + " IsAvailable=" + s.IsAvailable, 70);
                        WritePadded(string.Empty, 70);
                        WritePadded(string.Empty, 70);
                    }
                }
                return;
            }

            if (!streamStalled)
            {
                streamStalled = true;
                Log(string.Format("NO FRAMES for {0:F0}s. IsOpen={1} IsAvailable={2} framesReceived={3}",
                    idleSeconds, s.IsOpen, s.IsAvailable, Interlocked.Read(ref framesReceived)));
            }

            lock (consoleLock)
            {
                TrySetCursor(0, availabilityRow);
                WritePadded(string.Format(
                    "NO FRAMES for {0:F0}s. IsOpen={1} IsAvailable={2}",
                    idleSeconds, s.IsOpen, s.IsAvailable), 70);
                WritePadded("  -> The sensor is not streaming. Unplug the Kinect USB and its", 70);
                WritePadded("     power adapter, wait 5s, plug back in, then restart this app.", 70);
            }
        }
        catch (Exception ex)
        {
            // A watchdog is a diagnostic. It must never be the thing that
            // takes the process down.
            Log("Watchdog error (ignored): " + ex.Message);
        }
    }

    static void Sensor_IsAvailableChanged(object sender, IsAvailableChangedEventArgs e)
    {
        // Timestamped in the log, so a sensor that flaps between available and
        // unavailable every few seconds is visible as a series of transitions.
        // This is the single measurement that separates "the sensor keeps
        // dropping" from "the process keeps restarting".
        Log("Sensor IsAvailable -> " + e.IsAvailable + "  (uptime " + uptime.Elapsed.TotalSeconds.ToString("F1") + "s)");

        lock (consoleLock)
        {
            TrySetCursor(0, availabilityRow);
            WritePadded("Sensor IsAvailable -> " + e.IsAvailable, 70);
        }
    }

    static void Console_CancelKeyPress(object sender, ConsoleCancelEventArgs e)
    {
        // Handle the shutdown ourselves instead of letting the process die
        // mid-frame - disposes the Kinect reader/sensor and the OSC socket
        // cleanly.
        e.Cancel = true;
        Log("Ctrl+C - shutting down.");
        running = false;
        Shutdown();
        Environment.Exit(0);
    }

    static void CurrentDomain_UnhandledException(object sender, UnhandledExceptionEventArgs e)
    {
        Log("UNHANDLED EXCEPTION (process is terminating): " + e.ExceptionObject);
        try { Shutdown(); } catch { }
    }

    static void CurrentDomain_ProcessExit(object sender, EventArgs e)
    {
        Log(string.Format("MoveBeat exiting. uptime={0:F1}s framesReceived={1} sendFailures={2}",
            uptime.Elapsed.TotalSeconds, Interlocked.Read(ref framesReceived), Interlocked.Read(ref totalSendFailures)));
        try { Shutdown(); } catch { }
    }

    static void Shutdown()
    {
        if (shutdownDone)
            return;
        shutdownDone = true;

        // Stop the watchdog FIRST. It reads the sensor, and everything below
        // this line is busy tearing the sensor down.
        try
        {
            if (frameWatchdog != null)
            {
                frameWatchdog.Dispose();
                frameWatchdog = null;
            }
        }
        catch { /* best-effort cleanup */ }

        try
        {
            if (bodyReader != null)
            {
                bodyReader.FrameArrived -= BodyReader_FrameArrived;
                bodyReader.Dispose();
                bodyReader = null;
            }
        }
        catch { /* best-effort cleanup */ }

        try
        {
            if (sensor != null)
            {
                sensor.IsAvailableChanged -= Sensor_IsAvailableChanged;
                sensor.Close();
                sensor = null;
            }
        }
        catch { /* best-effort cleanup */ }

        try
        {
            if (osc != null)
            {
                osc.Dispose();
                osc = null;
            }
        }
        catch { /* best-effort cleanup */ }
    }

    /// <summary>
    /// Precomputes the JointType list and their "/mb/&lt;lowercase name&gt;" OSC
    /// addresses once at startup, so the per-frame path never allocates or
    /// concatenates strings and never touches LINQ.
    /// </summary>
    static void BuildJointTables()
    {
        allJointTypes = (JointType[])Enum.GetValues(typeof(JointType));

        int maxIndex = 0;
        for (int i = 0; i < allJointTypes.Length; i++)
            if ((int)allJointTypes[i] > maxIndex)
                maxIndex = (int)allJointTypes[i];

        jointAddresses = new string[maxIndex + 1];
        for (int i = 0; i < allJointTypes.Length; i++)
        {
            JointType jt = allJointTypes[i];
            jointAddresses[(int)jt] = "/mb/" + jt.ToString().ToLowerInvariant();
        }
    }

    static void BodyReader_FrameArrived(object sender, BodyFrameArrivedEventArgs e)
    {
        // This runs on a Kinect-owned thread 30 times a second. An exception
        // escaping from here is an unhandled exception on a background thread,
        // which on .NET Framework terminates the process immediately. A single
        // dropped UDP packet or one late frame must not be able to do that.
        try
        {
            using (var frame = e.FrameReference.AcquireFrame())
            {
                if (frame == null)
                    return;

                sinceLastFrame.Restart();
                Interlocked.Increment(ref framesReceived);

                if (bodies == null)
                    bodies = new Body[frame.BodyCount];

                frame.GetAndRefreshBodyData(bodies);

                // Plain loop instead of LINQ FirstOrDefault - this runs 30x/second.
                Body trackedBody = null;
                for (int i = 0; i < bodies.Length; i++)
                {
                    if (bodies[i] != null && bodies[i].IsTracked)
                    {
                        trackedBody = bodies[i];
                        break;
                    }
                }

                OscSender sender_ = osc;
                if (sender_ == null)
                    return; // shutting down

                sender_.BeginBundle();

                if (trackedBody == null)
                {
                    sender_.AddTrackedMessage(false);
                    SafeSend(sender_);
                    DrawNoBodyStatus();
                    return;
                }

                // Send all 25 joints, raw - no mapping/smoothing/filtering here.
                // All musical interpretation happens on the Mac, in Max.
                for (int i = 0; i < allJointTypes.Length; i++)
                {
                    JointType jt = allJointTypes[i];
                    Joint joint = trackedBody.Joints[jt];
                    var pos = joint.Position;
                    sender_.AddMessage(jointAddresses[(int)jt], pos.X, pos.Y, pos.Z, (float)(int)joint.TrackingState);
                }
                sender_.AddTrackedMessage(true);
                SafeSend(sender_);

                DrawTrackedStatus(trackedBody);
            }
        }
        catch (Exception ex)
        {
            Log("Frame handler error (ignored, continuing): " + ex.Message);
        }
    }

    /// <summary>
    /// Sends the built bundle, absorbing the transient network faults that a
    /// UDP broadcast can raise.
    ///
    /// SendTo throws SocketException when the interface goes down mid-stream -
    /// an Ethernet cable knocked out, an adapter power-cycling, the LAN
    /// briefly unreachable. Unhandled, in a 30 Hz callback, that killed the
    /// process. The stream is a best-effort control signal: dropping packets
    /// while the cable is out and carrying on when it returns is the correct
    /// behaviour, and is exactly what the Max side already tolerates.
    /// </summary>
    static void SafeSend(OscSender sender_)
    {
        try
        {
            sender_.Send();

            if (Interlocked.Read(ref consecutiveSendFailures) > 0)
            {
                Log("OSC sending recovered after " + Interlocked.Read(ref consecutiveSendFailures) + " consecutive failures.");
                Interlocked.Exchange(ref consecutiveSendFailures, 0);
            }
        }
        catch (Exception ex)
        {
            long n = Interlocked.Increment(ref consecutiveSendFailures);
            Interlocked.Increment(ref totalSendFailures);

            // Log the first failure and then only occasionally - at 30 Hz a
            // line per failure would fill the disk during a cable-out.
            if (n == 1 || n % 300 == 0)
                Log(string.Format("OSC send failed ({0} in a row, {1} total): {2}",
                    n, Interlocked.Read(ref totalSendFailures), ex.Message));
        }
    }

    // ---------------- throttled console status (~4 Hz) ----------------
    // Console.Clear() used to run 30x/second here - expensive, flickery on
    // a weak machine, and throws IOException if stdout isn't a real
    // console. This overwrites fixed-width, space-padded lines in place
    // instead, throttled via a Stopwatch.

    static void DrawNoBodyStatus()
    {
        if (redrawStopwatch.Elapsed.TotalMilliseconds < ConsoleRedrawIntervalMs)
            return;
        redrawStopwatch.Restart();

        lock (consoleLock)
        {
            TrySetCursor(0, statusTop);
            WritePadded("No body tracked", 60);
            for (int i = 0; i < 4; i++)
                WritePadded(string.Empty, 60);
        }
    }

    static void DrawTrackedStatus(Body body)
    {
        if (redrawStopwatch.Elapsed.TotalMilliseconds < ConsoleRedrawIntervalMs)
            return;
        redrawStopwatch.Restart();

        var head = body.Joints[JointType.Head].Position;
        var handRight = body.Joints[JointType.HandRight].Position;
        var handLeft = body.Joints[JointType.HandLeft].Position;
        var spineBase = body.Joints[JointType.SpineBase].Position;

        lock (consoleLock)
        {
            TrySetCursor(0, statusTop);
            WritePadded("Body tracked!", 60);
            WritePadded(string.Format("Head      : X={0:F3} Y={1:F3} Z={2:F3}", head.X, head.Y, head.Z), 60);
            WritePadded(string.Format("HandRight : X={0:F3} Y={1:F3} Z={2:F3}", handRight.X, handRight.Y, handRight.Z), 60);
            WritePadded(string.Format("HandLeft  : X={0:F3} Y={1:F3} Z={2:F3}", handLeft.X, handLeft.Y, handLeft.Z), 60);
            WritePadded(string.Format("SpineBase : X={0:F3} Y={1:F3} Z={2:F3}", spineBase.X, spineBase.Y, spineBase.Z), 60);
        }
    }

    static void TrySetCursor(int left, int top)
    {
        try { Console.SetCursorPosition(left, top); }
        catch { /* not a real console (e.g. redirected output) - ignore */ }
    }

    static void WritePadded(string s, int width)
    {
        try { Console.WriteLine(s.Length >= width ? s : s.PadRight(width)); }
        catch { /* console gone - never let drawing kill the stream */ }
    }

    // ---------------- log file ----------------
    // The app had no log at all, so "it crashed" left nothing behind to look
    // at and every diagnosis was guesswork. Lands next to the auto-updater's
    // log, in tools/logs/ (already gitignored).

    static readonly object logLock = new object();
    static string logPath = ResolveLogPath();
    const long MaxLogBytes = 2 * 1024 * 1024;

    static string ResolveLogPath()
    {
        try
        {
            string baseDir = AppDomain.CurrentDomain.BaseDirectory;
            // bin\Debug\net48 -> up four levels is the repo root.
            string dir = Path.GetFullPath(Path.Combine(baseDir, "..", "..", "..", "..", "tools", "logs"));
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir);
            return Path.Combine(dir, "movebeat.log");
        }
        catch
        {
            try { return Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "movebeat.log"); }
            catch { return null; }
        }
    }

    static void Log(string message)
    {
        if (logPath == null)
            return;

        try
        {
            lock (logLock)
            {
                File.AppendAllText(logPath,
                    string.Format("[{0}] {1}{2}", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff"), message, Environment.NewLine));

                var info = new FileInfo(logPath);
                if (info.Exists && info.Length > MaxLogBytes)
                {
                    string[] lines = File.ReadAllLines(logPath);
                    int keep = Math.Max(1, lines.Length / 2);
                    string[] tail = new string[keep];
                    Array.Copy(lines, lines.Length - keep, tail, 0, keep);
                    File.WriteAllLines(logPath, tail);
                }
            }
        }
        catch
        {
            // Logging is a diagnostic aid. It must never take the app down.
        }
    }

    // ---------------- --test mode: synthetic Kinect-free verification ----------------
    // Streams sine-wave joint values for all 25 joints so the OSC/network
    // path can be verified end-to-end (through to udpreceive in Max) without
    // a Kinect plugged in.

    static void RunTestMode()
    {
        Console.WriteLine("Running in --test mode: streaming synthetic sine-wave joint data (no Kinect required).");
        Console.WriteLine("Press Ctrl+C to exit.");
        Console.WriteLine();
        Log("Running in --test mode.");

        double t = 0;
        const double dt = 1.0 / 30.0; // matches Kinect's ~30 Hz body frame rate

        while (running)
        {
            try
            {
                OscSender sender_ = osc;
                if (sender_ == null)
                    break;

                sender_.BeginBundle();

                for (int i = 0; i < allJointTypes.Length; i++)
                {
                    JointType jt = allJointTypes[i];
                    int idx = (int)jt;
                    float phase = (float)(t + idx * 0.1);
                    float x = (float)(Math.Sin(phase) * 0.5);
                    float y = (float)(Math.Cos(phase) * 0.5 + 1.0);
                    float z = (float)(2.0 + Math.Sin(phase * 0.5) * 0.3);
                    sender_.AddMessage(jointAddresses[idx], x, y, z, (float)(int)TrackingState.Tracked);
                }
                sender_.AddTrackedMessage(true);
                SafeSend(sender_);

                DrawTestStatus(t);
            }
            catch (Exception ex)
            {
                Log("Test-mode error (ignored, continuing): " + ex.Message);
            }

            t += dt;
            Thread.Sleep(33);
        }
    }

    static void DrawTestStatus(double t)
    {
        if (redrawStopwatch.Elapsed.TotalMilliseconds < ConsoleRedrawIntervalMs)
            return;
        redrawStopwatch.Restart();

        Console.WriteLine(string.Format(
            "[test] t={0:F2}s  sending {1} joints -> {2}:{3}",
            t, allJointTypes.Length, osc.TargetAddress, osc.TargetPort));
    }
}
