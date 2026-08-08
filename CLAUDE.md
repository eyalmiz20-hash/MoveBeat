# MoveBeat

Final thesis project: movement to sound. A Kinect v2 tracks a body; the coordinates drive a virtual-analog synthesizer.

## Current status (as of 2026-08-08)

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
| Max side split into two devices | **Done** — synth device + controller device, see below |
| Synth device | **Working on macOS standalone.** Plays from MIDI/keyboard with no camera; all 24 parameters on a panel |
| Controller device | **Working.** Both input paths verified on the Mac: live Kinect OSC, and a built-in mock body |
| Movement → sound mapping | **Working end to end**, verified by UDP capture. Four features live |
| Verified on the real PC + Kinect | **Not yet** — the last open step |

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

## The Max side is two devices (2026-08-08)

The Max side used to be one patch with the camera wired straight into the engine. It is now **two independent devices that talk over OSC**, so the instrument and the movement layer can be developed, tested and replaced separately.

| Device | File | Role |
|---|---|---|
| **Synth** | `synth/instrument/MoveBeatSynth.maxpat` | The instrument. MIDI/keyboard in, audio out. **No camera code of any kind.** Runs on macOS alone. |
| **Controller** | `synth/controller/MoveBeatController.maxpat` | Movement in, normalised 0–1 features out. Reads the Kinect stream, or its own mock body. |

`synth/instrument/mb_voice.maxpat` is the third file — one `poly~` voice. It is only separate because `poly~` requires its voice patcher to be its own file; it is never opened directly.

**`synth/docs/MAPPING.md` is the reference for everything mapping-related.** Read it before changing any movement→sound behaviour.

### Why this split, given there was never a Windows-only Max object

Worth recording, because it is a natural assumption and it is wrong: **the Max patches contain no Windows-only objects and never did.** There is no `dp.kinect2`, no `jit.*`, nothing platform-specific. The Kinect is read by the C# app on the PC; the Max side has always been stock `udpreceive` + `route`, which loads fine on macOS.

So the split is **not** a platform-compatibility fix. It buys three things:

1. The synth can be developed and played on the Mac with no camera, no PC and no network.
2. The mapping can be tested against a mock body that behaves identically to a real one.
3. Any controller speaking the protocol can drive the synth — which is what makes the planned MoveNet/webcam controller a drop-in addition rather than a rewrite.

### The controller sends fractions, not Hz

The controller reports *how high the hand is*, as a number between 0 and 1. The synth decides that this means 179 Hz or 4.4 kHz. **Parameter ranges are a property of the instrument, so they live in the instrument.**

This is why tuning is deliberately split across two places, and knowing which is which saves a lot of hunting:

- **How much movement counts as "full"** → the controller, in `[p mb_features]`. These are the `[scale]` objects.
- **What a 0–1 value means in Hz** → the synth, in `[p mb_ctrl_in]`.

### Testing on the Mac with no camera

`MoveBeatController.maxpat` has an input-source menu at the top left: **LIVE** (real Kinect on port 7400) or **MOCK**. Mock gives five sliders for manual poses plus an auto-motion generator that emits complete joint messages at the Kinect's real ~30 Hz.

The mock is built to be trustworthy, not merely convenient: it emits exactly **one message per joint per frame**, the same shape and rate as the PC. Both paths were measured and produce **identical feature ranges** (cutoff 0.1333–0.8667, resonance 0.0714–0.7857). A mock that behaves differently from the thing it stands in for is worse than no mock.

### The original patch is still there

`synth/build/` holds the pre-split single-patch version. It works, it is deliberately untouched, and the two share no files — so both can be run and compared. **Do not delete it until the split version is confirmed on the PC with a real Kinect.**

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

## The OSC contract, hop 1: PC → Mac (port 7400)

There are now **two** OSC contracts in this project. This is the first — Kinect to controller, across the LAN. The second, controller to synth, is below. Both are APIs: an address change breaks the other side silently.

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

## The OSC contract, hop 2: controller → synth (port 7500, localhost)

Both devices run on the Mac, so this hop never leaves the machine. Five addresses, **each carrying exactly one float in 0.0–1.0**:

| Movement feature | Joints used | OSC address | Synth parameter |
|---|---|---|---|
| Right-hand height | `handright.y` | `/movebeat/cutoff` | `cutoff` |
| Distance between the hands | `handright.x` − `handleft.x` | `/movebeat/resonance` | `resonance` |
| Torso lean | `spineshoulder.z` − `spinebase.z` | `/movebeat/drive` | `drive` |
| Right-hand vertical speed | mean \|Δ`handright.y`\| over 8 frames | `/movebeat/outgain` | `outgain` |
| Body present | `/mb/tracked` | `/movebeat/gate` | indicator only, so far |

Every joint is gated on `trackingState == 2`, so inferred or lost joints never reach the synth — the last good value simply holds.

The synth's ranges, applied in `[p mb_ctrl_in]`: `cutoff` 100–8000 Hz on an **exponential** curve (`100 · 80^x`, so equal hand movement gives equal musical intervals), `resonance` 0–3.5, `drive` and `outgain` 0–1.

`/movebeat/gate` currently only lights an indicator. **Open decision:** when tracking is lost, every parameter freezes at its last value and the synth drones on unchanged. Whether it should mute, fade or freeze is a musical choice, so nothing is wired to it yet.

### Why OSC and not MIDI CC

Worth writing up, because MIDI CC is the obvious first instinct for "controller drives synth".

**The hard reason:** the Kinect and the synth are on two different computers. MIDI does not cross Ethernet without RTP-MIDI, which on Windows means installing a third-party driver — and **this account is not an administrator**. OSC over UDP already works and is byte-verified.

**The soft reason:** standard MIDI CC is 7-bit, 128 steps. Across a 100–8000 Hz exponential cutoff sweep each step is about a 3.6% frequency jump, audible as stepping on a slow sweep even with smoothing. OSC carries a 32-bit float, so the question does not arise. If CC is ever wanted for a hardware controller, add `[ctlin]` alongside `[udpreceive]` and scale by 1/127 — everything downstream already expects 0–1 — and prefer 14-bit CC for `cutoff`.

### Smoothing — two mechanisms, because there are two kinds of parameter

The camera stream is 30 Hz. Sent raw, that steps audibly. The two routes need different fixes:

- **`cutoff` is a signal** inside the voice. The original `[sig~ 800]` jumped at block boundaries; it is now a `[line~]` fed by `[pack 0. 25]`, ramping each value over 25 ms at signal rate.
- **`resonance`, `drive`, `outgain` are `gen~` Params**, set by message. **`gen~` does not interpolate Param changes** — this is the non-obvious part. They are ramped at control rate in `[p mb_ctrl_in]` with `[pack 0. 25]` → `[line 0. 5]`: a 25 ms ramp emitted every 5 ms.

Measured result: a 30 Hz input becomes a ~151 Hz parameter stream whose largest single step is 0.25% of the observed range.

If `outgain` ever still clicks on a very fast move, the fix is to pin the Param at 1.0 and do the gain with a `[line~]`-driven `[*~]` in the voice — outside `gen~`, leaving the verified DSP core untouched.

## Two Max traps that cost real debugging time

Both were found on 2026-08-08 while building the split, and both are the kind that produce a patch which loads cleanly and looks right.

### Max numbers subpatcher inlets/outlets by X position, not creation order

An `inlet`/`outlet` object's index comes from its **on-screen X coordinate**, not from where it appears in the file or the order it was made. Lay them out in a different left-to-right order than you intend and Max silently renumbers them; the parent then connects to the wrong ones **with no error in the Max console**.

This swapped `cutoff`↔`resonance` and `drive`↔`outgain` inside `[p mb_features]`. Everything loaded, and the values looked entirely plausible — they were simply arriving on the wrong addresses. It was only caught by capturing the device's UDP output and noticing the *ranges* belonged to the wrong parameters.

**When editing `.maxpat` JSON, always check that inlet/outlet order matches ascending X.**

### Verify Max patches by capturing their UDP output

The same rule already stated for the Windows app applies to the Max side, for a different reason: reading a patch does not tell you what it does, and the GUI does not show mis-wiring like the above. Bind a socket to the port, decode, and check the value *ranges* against what the maths predicts.

Two practical notes from doing this:

- **Max restores previously-open patches after a hard kill.** A stale test copy silently re-opened and streamed to the same port alongside the new one, producing an interleaved mess of two value streams that looked like a logic bug. Delete scratch patches, don't just close them.
- A synthetic Kinect replay is easy and worth having: build the same bundle `OscSender.cs` builds — 25 joints plus `/mb/tracked` — and send it to 7400 at 30 Hz. It comes out at exactly **1144 bytes**, which is a free check that your replay matches the real contract.

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
synth/             Max 9 (Mac) — two devices + shared DSP
  instrument/        THE SYNTH DEVICE
    MoveBeatSynth.maxpat     open this to play; no camera code
    mb_voice.maxpat          one poly~ voice (loaded by name, never opened directly)
  controller/        THE MOVEMENT DEVICE
    MoveBeatController.maxpat  live Kinect OSC + mock body + feature mapping
  dsp/*.genexpr      gen~ core: oscillators, drive, Moog ladder filter
  docs/              ARCHITECTURE.md — parameter list and design rationale
                     MAPPING.md     — movement→parameter contract, tuning guide
  build/             PRE-SPLIT single-patch version. Still works, untouched.
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

`synth/docs/ARCHITECTURE.md` is the reference for the synth's parameter names (`cutoff`, `resonance`, `drive`, `pw`, `outgain`…) and the DSP design rationale. `synth/docs/MAPPING.md` is the reference for the movement→parameter contract and for where to tune what. **Read both before touching anything in `synth/`.**

## Known issues / open decisions

- **Not yet verified on the real PC with a real Kinect.** Everything on the Mac side is measured and working, including a synthetic replay of the PC's exact packet format, but the split has not run against live hardware.
- **`/movebeat/gate` does nothing but light an indicator.** On loss of tracking the sound freezes and drones. Needs a musical decision — mute, fade, or hold.
- **`synth/build/MoveBeat_ableton_ves.amxd` is a divergent fork**, not an export: a near-copy of the old patch with `notein`→`midiin` and `plugout~` added, carrying its own drifted parameter state. It also contradicts `ARCHITECTURE.md` and `BUILD_GUIDE.md`, which both state Ableton and Max for Live are deliberately out of scope. Decide whether to delete it or rebuild it properly from the new synth device.
- **Fixed 2026-08-08:** the old `[p mb_mapping]` had a dangling right-hand-X gate, so `resonance` computed `abs(0 − lefthand.x)` and tracked one hand's distance from centre rather than the spread between the hands. Fixed in the old patch too, not only in the new controller.
