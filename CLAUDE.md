# MoveBeat

Final thesis project: movement to sound. A Kinect v2 tracks a body; the coordinates drive a virtual-analog synthesizer.

## Current status (as of 2026-08-05)

| Piece | State |
|---|---|
| Repo moved out of OneDrive to `C:\dev\MoveBeat` | Done |
| Build via `dotnet` | Working, green |
| OSC encoder | **Verified byte-exact** against a captured packet (1144/1144 bytes consumed) |
| Kinect capture | Sensor opens, frames arrive at ~26–32 Hz |
| Ethernet-only targeting | Verified sending from `192.168.0.101` → `192.168.0.255` |
| Git auto-updater | Verified end to end (pull → build → relaunch) |
| Logon auto-start | Verified from a cold start |
| Skeletal tracking | **Working** — see note below |
| Max patch (`udpreceive`) | **Receiver built** — `[p mb_udp_in]` in `MoveBeat.maxpat`, verified receiving on the Mac. Mapping subpatch not built yet |

### Skeletal tracking — resolved (it was distance)

The long "no body is ever tracked" mystery had nothing to do with software or hardware: **nobody was standing in the sensor's tracking range during the tests.** Kinect v2 needs roughly **2–3 m with the whole body in view** — it will not track someone sitting at the keyboard half a metre away. With a person at proper distance, bodies track and joint coordinates stream normally.

Keep this in mind for every future "no data" report: check framing/distance *first* (`DepthBasics-D2D.exe` shows what the sensor actually sees), before suspecting code.

## The two machines — read this first

This project runs across two computers, and **which machine you are on changes what you should do.**

| | **Mac** | **Windows laptop** |
|---|---|---|
| Role | Runs the Max 9 synth | Runs the Kinect v2 sensor |
| Power | **Strong** | **Weak** |
| Owns | `synth/` — Max patches, `gen~` DSP | `MoveBeat/` — C# capture app, `tools/` |
| Development | All development happens here | Receives pushes automatically |

**Governing design rule: the weak machine does as little as possible.** The PC reads joints, encodes them, and sends one UDP packet per frame. That is all. It performs **no** mapping, smoothing, filtering, or scaling. Every musical decision happens on the Mac, in Max.

This is not just about CPU. It means the movement→sound mapping can be re-tuned live in Max, while sound is playing, forever — without rebuilding or touching the PC. **If you find yourself adding per-frame computation to the C# side, you are on the wrong machine.**

## Repo location (Windows)

The live repo is **`C:\dev\MoveBeat`**.

There is an old copy at `C:\Users\elad1\OneDrive\Desktop\MoveBeat`. It is **dead — do not use it.** The repo was moved out of OneDrive deliberately: OneDrive's Files On-Demand sync engine races the build's writes to `bin\`/`obj\`, causing intermittent file-lock build failures, and it can dehydrate a DLL out from under a running process. Never move this repo back under `OneDrive\`.

## Building (Windows)

```powershell
& "C:\Program Files\dotnet\dotnet.exe" build "C:\dev\MoveBeat\MoveBeat\MoveBeat.csproj" -c Debug
```

- **There is no Visual Studio and no `MSBuild.exe` on this machine.** `vswhere` returns empty. The only MSBuild on disk is legacy .NET Framework 4.0, which cannot build an SDK-style csproj. Use `dotnet`.
- The project targets `net48` and the 4.8 targeting pack is **not** installed — the .NET 8 SDK substitutes the cached `Microsoft.NETFramework.ReferenceAssemblies` NuGet package. This works, including offline. Don't try to "fix" the missing pack.
- Output is `MoveBeat\bin\Debug\net48\MoveBeat.exe`. **Never add `-r win-x64`** — it inserts a RID subfolder and breaks every path in `tools/`.
- `Microsoft.Kinect.dll` is referenced by absolute `HintPath` into the Kinect SDK v2 install.

## Windows environment constraints

- **Windows PowerShell 5.1 only.** No `pwsh`. `&&`, `||`, and ternary are parse errors — use `;` and `if ($?) { }`.
- **Execution policy is effectively Restricted.** Any `.ps1` must be launched with `-ExecutionPolicy Bypass`.
- **This account is not an administrator.** `Register-ScheduledTask` fails with Access Denied. Installing SDKs needs a UAC prompt.
- **It's a laptop with a battery.** Anything registered in Task Scheduler must set `-AllowStartIfOnBatteries -DontStopIfGoingOnBatteries`, or it silently dies when unplugged.

## The OSC contract

`MoveBeat/OscSender.cs` is a hand-written OSC 1.0 encoder (no library — it writes into one reused buffer with zero allocation per frame, which matters in a 30 Hz hot path on a weak machine).

Each body frame sends **one UDP datagram** to the subnet-directed broadcast address on port **7400**, containing an OSC **bundle** of 26 messages:

| Address | Type tag | Payload |
|---|---|---|
| `/mb/<lowercase JointType>` × 25 | `,ffff` | `x  y  z  trackingState` |
| `/mb/tracked` | `,i` | `1` if a body is tracked, else `0` |

Joint addresses derive from the `JointType` enum, e.g. `/mb/head`, `/mb/handright`, `/mb/spinebase`. `trackingState` is 0 = NotTracked, 1 = Inferred, 2 = Tracked.

A bundle (not 25 separate packets) is deliberate: one `sendto()` per frame is cheap, and Max's `udpreceive` unpacks a bundle into separate messages, so the Max side routes them with stock `route /mb/head` — no CNMAT externals needed.

Packet is ~1144 bytes, safely under the 1472-byte non-fragmenting UDP limit. **If you add joints or fields, re-check that budget.**

**This is a cross-machine contract.** Changing an address or type tag silently breaks the Max patch on the other computer, with no compile error anywhere. Treat it as an API.

### Wired Ethernet only — deliberate

The PC sits on two routable subnets at once: **Ethernet `192.168.0.x`** and **Wi-Fi `192.168.8.x`**. `ResolveBroadcastAddress()` accepts **only wired Ethernet** interfaces and ignores Wi-Fi entirely, so the destination is deterministic. The LAN cable is the lower-latency, non-contended path, which matters for a 30 Hz control stream driving a synth.

**The Mac must be on the `192.168.0.x` LAN**, not Wi-Fi, or it receives nothing.

Link-local/APIPA addresses (`169.254.0.0/16`) are skipped — this machine reports three of them from Bluetooth and virtual adapters, and an unplugged Ethernet port self-assigns one too. Falling through to `255.255.255.255` means no usable wired interface was found; the app prints a loud warning in that case rather than appearing healthy while streaming nowhere. `--ip <addr>` overrides everything.

### Testing without hardware
`MoveBeat.exe --test` streams synthetic sine-wave joint data for all 25 joints, so the network path can be verified with no Kinect attached. Use it to separate "is my OSC correct" from "is the Kinect working".

### ⚠️ Testing trap: never redirect this app's stdout

`Start-Process -RedirectStandardOutput` leaves **stdin as the null device**, so `Console.ReadLine()` returns instantly and the app **exits within milliseconds** — long before the sensor finishes coming up. This produces a completely false reading: `IsAvailable=False`, no frames, no status lines. It cost a whole debugging detour that concluded the sensor was wedged when it was fine.

**To observe the app's behaviour, capture its UDP output instead** — bind a socket to port 7400 and decode the packets. That measures the real thing and disturbs nothing.

## The auto-updater — and its one sharp edge

`tools/sync-loop.ps1` polls `origin/main` every 30s (via a cheap `git ls-remote` SHA check). When the remote moves it: kills `MoveBeat.exe` → waits → `git reset --hard origin/main` → rebuilds → relaunches.

**Kill before build is mandatory** — a running exe holds a lock on its own output file and the build fails with MSB3021.

> ⚠️ **The PC is a mirror, not a workspace.** `git reset --hard origin/main` **destroys uncommitted changes to tracked files** the moment anything is pushed from the Mac. Untracked new files survive (there is deliberately no `git clean`), but a modified tracked file does not.
>
> **If you edit code on the Windows machine, commit and push it before anything lands on `origin/main`.** Don't leave work sitting uncommitted here.

Other files: `run-hidden.vbs` launches the poller with no console flash (`-WindowStyle Hidden` still flashes; `WScript.Shell.Run …, 0` doesn't). `install-task.ps1` / `uninstall-task.ps1` manage the scheduled task — **note `install-task.ps1` requires admin and fails without it.** Use `install-startup.ps1` instead.

## Kinect app auto-start

`tools/kinect-autostart.ps1` launches `MoveBeat.exe` and Body Basics (Microsoft's live skeleton viewer) at every logon. Installed by `install-kinect-autostart.ps1` as a second Startup-folder shortcut, independent of the auto-updater. Which apps start is the `$Apps` list at the top of the script — change it on the Mac and the auto-updater delivers it.

**It waits for the sensor before launching anything.** At logon `KinectMonitor` is still starting and the sensor is still enumerating on USB; anything launched immediately loses that race and reports "Kinect not found". Keep that wait if you modify the script.

**Kinect Studio is deliberately NOT auto-started.** It connects to the sensor service and can gate or replace the live feed for every other client — when it did auto-start here it had a recorded `.xef` file loaded, which makes "why is my app getting no data" needlessly hard to diagnose. Open it by hand when recording or playback is actually wanted.

Logs to `tools/logs/kinect-autostart.log`.

## Kinect SDK diagnostic apps

Under `C:\Program Files\Microsoft SDKs\Kinect\v2.0_1409\`:

| App | Use |
|---|---|
| `bin\BodyBasics-D2D.exe` | Microsoft's skeleton tracker. **The reference implementation** — if it tracks and this repo doesn't, the bug is here. |
| `bin\DepthBasics-D2D.exe` | Raw depth image — shows what the sensor is actually pointed at. |
| `bin\InfraredBasics-D2D.exe` | Raw IR image. |
| `Tools\ConfigurationVerifier\KinectV2ConfigurationVerifier.exe` | USB bandwidth / controller compatibility checks. |
| `Tools\KinectStudio\KStudio.exe` | Record/playback. Can gate the live feed — open deliberately, close when done. |

Kinect v2 multiplexes through the KinectMonitor service, so several apps can read the sensor simultaneously — Body Basics and `MoveBeat.exe` coexist fine.

### Sensor diagnostics built into the app

- `MoveBeat.exe` prints `IsOpen`/`IsAvailable` at startup and logs every `IsAvailableChanged` transition.
- A **frame watchdog** reports `NO FRAMES for Ns` after 5 seconds of silence. This distinguishes the two faults that look identical on screen: "nobody is in view" versus "the sensor is not streaming at all".
- **Read those values from the app's own visible window, not from redirected output** — see the testing trap above.

### Never hard-kill the app

`Stop-Process -Force` is a hard `TerminateProcess`: `sensor.Close()` never runs, so KinectMonitor keeps holding the sensor handle. Doing this repeatedly can leave the sensor unusable until it is physically replugged. `sync-loop.ps1` calls `CloseMainWindow()` first and only forces after an 8s timeout — keep that behaviour.

### The KinectMonitor service cannot be restarted here

`Restart-Service KinectMonitor` fails without admin. The per-session `KinectService` and `KStudioHostService` processes *can* be killed by this user and respawn on demand, but doing so did not clear a stuck sensor. Physical replug (USB **and** power adapter) is the real recovery.

When relaunching the app from a hidden parent, use `Start-Process` **without** `-NoNewWindow` — otherwise the child inherits the hidden console, all output vanishes, and `Console.SetCursorPosition` throws.

## Layout

```
MoveBeat/          C# Kinect capture app (Windows)
  Program.cs         frame handler, console status, watchdog, --test mode
  OscSender.cs       OSC encoder + wired-Ethernet UDP broadcast
synth/             Max 9 synth (Mac)
  dsp/*.genexpr      gen~ core: oscillators, drive, Moog ladder filter
  docs/              ARCHITECTURE.md — parameter list and design rationale
  build/             .maxpat patchers
tools/             Windows automation
  sync-loop.ps1              git poller: pull, build, relaunch
  run-hidden.vbs             no-flash launcher for the poller
  install-startup.ps1        installs the poller at logon (no admin)
  uninstall-startup.ps1
  kinect-autostart.ps1       waits for the sensor, launches the Kinect apps
  run-kinect-autostart.vbs   no-flash launcher for the above
  install-kinect-autostart.ps1
  uninstall-kinect-autostart.ps1
  install-task.ps1           Task Scheduler variant — REQUIRES ADMIN, fails here
  uninstall-task.ps1
  logs/                      sync.log, kinect-autostart.log (gitignored)
```

Two Startup-folder shortcuts are installed, independent of each other:
`MoveBeatAutoUpdate.lnk` (git poller) and `MoveBeatKinectApps.lnk` (Kinect apps).

`synth/docs/ARCHITECTURE.md` is the reference for the synth's parameter names (`cutoff`, `resonance`, `drive`, `pw`, `outgain`…) and the suggested movement→parameter mappings. Read it before touching anything in `synth/`.
