using System;
using System.Diagnostics;
using System.Threading;
using Microsoft.Kinect;

class Program
{
    const int OscPort = 7400;
    const double ConsoleRedrawIntervalMs = 250; // throttle console redraw to ~4 Hz

    // The live status block redraws in place below the startup banner, so the
    // banner (OSC target, IsAvailable) stays readable instead of being
    // overwritten every frame.
    const int AvailabilityRow = 6;
    const int StatusTop = 8;

    static KinectSensor sensor;
    static BodyFrameReader bodyReader;
    static Body[] bodies;
    static OscSender osc;

    static JointType[] allJointTypes;
    static string[] jointAddresses; // indexed by (int)JointType, e.g. "/mb/handright"

    static readonly Stopwatch redrawStopwatch = Stopwatch.StartNew();
    static readonly Stopwatch sinceLastFrame = Stopwatch.StartNew();
    static Timer frameWatchdog;
    static volatile bool running = true;
    static volatile bool shutdownDone;

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

        BuildJointTables();

        osc = new OscSender(OscPort, ipOverride);
        Console.WriteLine("OSC target: " + osc.TargetAddress + ":" + osc.TargetPort + "  (wired Ethernet only)");

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
                Console.ReadLine();
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

            // Watchdog: "no body tracked" and "no frames arriving at all" look
            // identical on screen, but they are completely different problems.
            // Say which one it is.
            frameWatchdog = new Timer(CheckFrameFlow, null, 5000, 5000);

            Console.ReadLine();

            Shutdown();
        }
        catch (Exception ex)
        {
            Console.WriteLine("ERROR: " + ex);
            Console.ReadLine();
            Shutdown();
        }
    }

    /// <summary>
    /// Reports when the sensor stops delivering frames entirely, which is a
    /// different fault from "a person is not in view" but looks the same.
    /// The usual cause is a Kinect left in a bad state after a client was
    /// hard-killed without calling sensor.Close(); the cure is a physical
    /// unplug/replug of the sensor's USB and power.
    /// </summary>
    static void CheckFrameFlow(object state)
    {
        if (sensor == null)
            return;

        double idleSeconds = sinceLastFrame.Elapsed.TotalSeconds;
        if (idleSeconds < 5)
            return;

        TrySetCursor(0, AvailabilityRow);
        WritePadded(string.Format(
            "NO FRAMES for {0:F0}s. IsOpen={1} IsAvailable={2}",
            idleSeconds, sensor.IsOpen, sensor.IsAvailable), 70);
        WritePadded("  -> The sensor is not streaming. Unplug the Kinect USB and its", 70);
        WritePadded("     power adapter, wait 5s, plug back in, then restart this app.", 70);
    }

    static void Sensor_IsAvailableChanged(object sender, IsAvailableChangedEventArgs e)
    {
        TrySetCursor(0, AvailabilityRow);
        WritePadded("Sensor IsAvailable -> " + e.IsAvailable, 60);
    }

    static void Console_CancelKeyPress(object sender, ConsoleCancelEventArgs e)
    {
        // Handle the shutdown ourselves instead of letting the process die
        // mid-frame - disposes the Kinect reader/sensor and the OSC socket
        // cleanly.
        e.Cancel = true;
        running = false;
        Shutdown();
        Environment.Exit(0);
    }

    static void Shutdown()
    {
        if (shutdownDone)
            return;
        shutdownDone = true;

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
    /// Precomputes the JointType list and their "/mb/<lowercase name>" OSC
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
        using (var frame = e.FrameReference.AcquireFrame())
        {
            if (frame == null)
                return;

            sinceLastFrame.Restart();

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

            osc.BeginBundle();

            if (trackedBody == null)
            {
                osc.AddTrackedMessage(false);
                osc.Send();
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
                osc.AddMessage(jointAddresses[(int)jt], pos.X, pos.Y, pos.Z, (float)(int)joint.TrackingState);
            }
            osc.AddTrackedMessage(true);
            osc.Send();

            DrawTrackedStatus(trackedBody);
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

        TrySetCursor(0, StatusTop);
        WritePadded("No body tracked", 60);
        for (int i = 0; i < 4; i++)
            WritePadded(string.Empty, 60);
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

        TrySetCursor(0, StatusTop);
        WritePadded("Body tracked!", 60);
        WritePadded(string.Format("Head      : X={0:F3} Y={1:F3} Z={2:F3}", head.X, head.Y, head.Z), 60);
        WritePadded(string.Format("HandRight : X={0:F3} Y={1:F3} Z={2:F3}", handRight.X, handRight.Y, handRight.Z), 60);
        WritePadded(string.Format("HandLeft  : X={0:F3} Y={1:F3} Z={2:F3}", handLeft.X, handLeft.Y, handLeft.Z), 60);
        WritePadded(string.Format("SpineBase : X={0:F3} Y={1:F3} Z={2:F3}", spineBase.X, spineBase.Y, spineBase.Z), 60);
    }

    static void TrySetCursor(int left, int top)
    {
        try { Console.SetCursorPosition(left, top); }
        catch { /* not a real console (e.g. redirected output) - ignore */ }
    }

    static void WritePadded(string s, int width)
    {
        Console.WriteLine(s.Length >= width ? s : s.PadRight(width));
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

        double t = 0;
        const double dt = 1.0 / 30.0; // matches Kinect's ~30 Hz body frame rate

        while (running)
        {
            osc.BeginBundle();

            for (int i = 0; i < allJointTypes.Length; i++)
            {
                JointType jt = allJointTypes[i];
                int idx = (int)jt;
                float phase = (float)(t + idx * 0.1);
                float x = (float)(Math.Sin(phase) * 0.5);
                float y = (float)(Math.Cos(phase) * 0.5 + 1.0);
                float z = (float)(2.0 + Math.Sin(phase * 0.5) * 0.3);
                osc.AddMessage(jointAddresses[idx], x, y, z, (float)(int)TrackingState.Tracked);
            }
            osc.AddTrackedMessage(true);
            osc.Send();

            DrawTestStatus(t);

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
