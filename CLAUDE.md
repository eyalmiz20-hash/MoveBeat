# MoveBeat

Final thesis project: movement to sound. A Kinect v2 tracks a body; the coordinates drive a virtual-analog synthesizer.

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

Broadcast means no IP configuration. Both machines must be on the same subnet. `--ip <addr>` overrides it if broadcast is ever blocked.

### Testing without hardware
`MoveBeat.exe --test` streams synthetic sine-wave joint data for all 25 joints, so the network path can be verified with no Kinect attached. Use it to separate "is my OSC correct" from "is the Kinect working".

## The auto-updater — and its one sharp edge

`tools/sync-loop.ps1` polls `origin/main` every 30s (via a cheap `git ls-remote` SHA check). When the remote moves it: kills `MoveBeat.exe` → waits → `git reset --hard origin/main` → rebuilds → relaunches.

**Kill before build is mandatory** — a running exe holds a lock on its own output file and the build fails with MSB3021.

> ⚠️ **The PC is a mirror, not a workspace.** `git reset --hard origin/main` **destroys uncommitted changes to tracked files** the moment anything is pushed from the Mac. Untracked new files survive (there is deliberately no `git clean`), but a modified tracked file does not.
>
> **If you edit code on the Windows machine, commit and push it before anything lands on `origin/main`.** Don't leave work sitting uncommitted here.

Other files: `run-hidden.vbs` launches the poller with no console flash (`-WindowStyle Hidden` still flashes; `WScript.Shell.Run …, 0` doesn't). `install-task.ps1` / `uninstall-task.ps1` manage the scheduled task — **note `install-task.ps1` currently requires admin and fails without it.**

When relaunching the app from a hidden parent, use `Start-Process` **without** `-NoNewWindow` — otherwise the child inherits the hidden console, all output vanishes, and `Console.SetCursorPosition` throws.

## Layout

```
MoveBeat/          C# Kinect capture app (Windows)
  Program.cs         frame handler, console status, --test mode
  OscSender.cs       OSC encoder + UDP broadcast
synth/             Max 9 synth (Mac)
  dsp/*.genexpr      gen~ core: oscillators, drive, Moog ladder filter
  docs/              ARCHITECTURE.md — parameter list and design rationale
  build/             .maxpat patchers
tools/             auto-updater scripts (Windows)
```

`synth/docs/ARCHITECTURE.md` is the reference for the synth's parameter names (`cutoff`, `resonance`, `drive`, `pw`, `outgain`…) and the suggested movement→parameter mappings. Read it before touching anything in `synth/`.
