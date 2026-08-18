# MoveBeat — Movement → Sound Mapping

This is the contract between the two Max devices. Both hops are **cross-machine or cross-device
APIs**: changing an address or a range silently changes the sound with no error anywhere and no
compile step to catch it. Treat this file as the spec, and change the patches and this document
in the same commit.

## The two devices

```
   WINDOWS PC                              MAC
┌───────────────┐                 ┌──────────────────────────┐   ┌─────────────────────┐
│  Kinect v2    │                 │ MoveBeatController.maxpat│   │ MoveBeatSynth.maxpat│
│      ↓        │   OSC /mb/…     │                          │   │                     │
│  MoveBeat.exe │ ──UDP 7400──►   │  joints → mapping matrix │   │  parameters → sound │
│    (C#)       │   wired LAN     │            ↓             │   │         ↓           │
└───────────────┘                 │      OSC /movebeat/…     │──►│   poly~ → gen~ → 🔊 │
                                  └──────────────────────────┘   └─────────────────────┘
                                         UDP 7500, localhost
```

The synth contains **no camera code of any kind.** It plays from MIDI or its on-screen keyboard,
every parameter has a control on its panel, and it runs on macOS with nothing attached.

## Hop 1 — Kinect → controller (port 7400)

**Unchanged, and must stay unchanged.** Defined by `MoveBeat/OscSender.cs`. One OSC bundle per
body frame, 26 messages: `/mb/<lowercase JointType> x y z trackingState` for all 25 joints, plus
`/mb/tracked` carrying 0 or 1. `trackingState` is 0 = NotTracked, 1 = Inferred, 2 = Tracked.

The controller consumes **eight** of the 25 joints: the six body parts below plus `spinebase` and
`spineshoulder` for torso lean. Received by `[p mb_osc_in]`, the only camera-facing subpatch.

`/mb/tracked` is the **last message in every bundle**, so the controller uses its arrival as the
"frame complete" trigger that emits one set of mappings per frame.

## The mapping matrix (the controller's panel)

Six slots, one per body part. Each row reads:

> **BODY PART** → *source* → **synth parameter** → *min* / *max* / *curve* → live value

| Slot | Body part | Kinect joint |
|---|---|---|
| 0 | **HAND L** | `handleft` |
| 1 | **HAND R** | `handright` |
| 2 | **FOOT L** | `footleft` |
| 3 | **FOOT R** | `footright` |
| 4 | **HEAD** | `head` |
| 5 | **TORSO** | `spinemid` |

### What each slot chooses

**Source** — one of six, all normalised to 0–1 inside `[p mb_sources]`:

| Source | Meaning | Counts as "full" at |
|---|---|---|
| `X` | side to side | -1 … 1 m |
| `Y` | height | -1 … 1.5 m |
| `Z` | distance from sensor | 1 … 4 m |
| `SPEED` | 3-D speed, mean \|Δp\| over 8 frames | 0.06 m/frame (≈1.8 m/s) |
| `SPREAD` | distance between the hands | 0 … 1.4 m |
| `LEAN` | torso lean, `spineshoulder.z` − `spinebase.z` | 0 … 0.35 m |

`SPREAD` and `LEAN` are whole-body features, so they read the same from any slot.

**Destination** — any of the synth's 24 parameters, or `- off -` to silence the slot.

**Min / max — the range lock.** The parameter is confined to this band: full movement sweeps
from *min* to *max* and can never leave it. Picking a destination loads that parameter's full
range as the default, which you then narrow. This is the answer to "I want the filter to move,
but never get so dark it disappears".

**Curve** — `LIN` maps movement to the value proportionally. `EXP` is geometric, so equal
movement gives equal musical intervals; it is the right choice for anything measured in Hz and
is loaded automatically for `cutoff` and `lfoRate`. `EXP` needs a strictly positive min; if min
is 0 or below the slot falls back to linear rather than producing nonsense.

## Hop 2 — controller → synth (port 7500, localhost)

One address per parameter, `/movebeat/<name>`, each carrying **one float in the parameter's own
units** — Hz, milliseconds, semitones — plus `/movebeat/gate` carrying 0 or 1 for body-present.

> ### ⚠️ This changed. The wire used to carry 0–1.
>
> Earlier versions sent a normalised 0–1 fraction and let the synth decide what it meant, so
> that parameter ranges lived only in the instrument. The range lock broke that: a lock is
> written in native units (500–2000 Hz), so **something** had to know them. Keeping the old
> split would have meant a 24-row range table in the controller *and* a matching one in the
> synth, which is exactly the kind of duplicate contract that drifts silently.
>
> So the scaling moved to the controller and there is now one source of truth. The synth still
> **clamps** every incoming value to that parameter's legal range — an instrument should not let
> a mis-set controller drive its DSP out of bounds — but it no longer scales.
>
> The cost is that a replacement controller (the planned MoveNet/webcam one) now has to emit
> native units. That is a real cost, accepted deliberately: `[p mb_ctrl_in]` is the only thing
> it has to agree with, and the table below is the whole specification.

### The 24 parameters, their legal ranges, and the default curve

These bounds come from the `Param` declarations in `synth/dsp/movebeat_core.genexpr` and from
the voice's own controls. They are the clamp in `[p mb_ctrl_in]` and the defaults the controller
loads when you pick a destination.

| Parameter | Min | Max | Curve |
|---|---|---|---|
| `cutoff` | 20 | 18000 | EXP |
| `resonance` | 0 | 4 | LIN |
| `drive` | 0 | 1 | LIN |
| `rescomp` | 0 | 1 | LIN |
| `outgain` | 0 | 1 | LIN |
| `osc1level` | 0 | 1 | LIN |
| `osc2level` | 0 | 1 | LIN |
| `sublevel` | 0 | 1 | LIN |
| `detune` | -24 | 24 | LIN |
| `pw` | 0.05 | 0.95 | LIN |
| `osc1wave` | 0 | 3 | LIN |
| `osc2wave` | 0 | 3 | LIN |
| `lfoRate` | 0.01 | 20 | EXP |
| `lfoDepth` | 0 | 5000 | LIN |
| `filtEnvAmt` | 0 | 8000 | LIN |
| `glide` | 0 | 2000 | LIN |
| `ampA` | 0 | 2000 | LIN |
| `ampD` | 0 | 2000 | LIN |
| `ampS` | 0 | 1 | LIN |
| `ampR` | 0 | 4000 | LIN |
| `filtA` | 0 | 2000 | LIN |
| `filtD` | 0 | 2000 | LIN |
| `filtS` | 0 | 1 | LIN |
| `filtR` | 0 | 4000 | LIN |

`cutoff` reaches the DSP as a signal through the voice's `[line~]`; the other 23 arrive as
messages. `osc1wave` and `osc2wave` are rounded to whole numbers (0 saw, 1 square, 2 triangle,
3 sine).

### Tracking gate

Every joint is gated on `trackingState == 2`, so inferred or lost joints never reach the synth —
the last good value simply holds. `/movebeat/gate` still only lights an indicator on the synth
panel. **Open decision:** on loss of tracking the sound freezes and drones. Whether it should
mute, fade or hold is a musical choice, so nothing is wired to it yet.

## Where to tune what

Two halves, in two places, on purpose.

**How much movement counts as "full"** lives in the controller, in `[p mb_sources]` — the
`[scale]` objects, one per axis per body part, listed in the source table above. Change these
when the performer's range of motion or the room changes.

**How far the parameter may travel** is the min/max on the slot row, live, while sound is
playing. That is the knob you actually perform with.

## Smoothing

The camera stream is 30 Hz. Sent raw it steps audibly. Two mechanisms, because the parameters
travel by two routes:

**`cutoff` is a signal** inside the voice — `[line~]` fed by `[pack 0. 25]`, ramping every value
over 25 ms at signal rate.

**Everything else is a message**, and `gen~` does **not** interpolate `Param` changes. They are
ramped at control rate in `[p mb_ctrl_in]` with `[pack 0. 25]` → `[line 0. 5]`: a 25 ms ramp
emitted every 5 ms.

## Testing on the Mac with no camera

The input-source menu at the top left picks **LIVE** (real Kinect on 7400) or **MOCK**. Mock
gives one slider per body part plus an auto-motion generator that emits complete joint messages
for all eight joints at the Kinect's real ~30 Hz, frame trigger last — the same shape and order
as the PC.

> **`[p mb_osc_in]`'s gate is `[gate 1 1]` — open by default.** It used to default closed and
> rely on `loadbang` to open it, which meant that editing the patch in Max (which re-instantiates
> objects without re-firing `loadbang`) silently killed the whole device: no LIVE, no MOCK, no
> output, nothing in the Max console. Keep the `1 1`.

## Resolution — why OSC rather than MIDI CC

**Hard:** the Kinect and the synth are on two different computers. MIDI does not cross Ethernet
without RTP-MIDI, which on Windows means a third-party driver, and the Windows account is not an
administrator. OSC over UDP already works and is byte-verified.

**Soft:** standard CC is 7-bit — 128 steps. Across a 20–18000 Hz exponential cutoff sweep each
step is a large frequency jump, audible as stepping on a slow sweep even with smoothing. OSC
carries a 32-bit float.

## Verifying it

Reading a patch does not tell you what it does. Bind a UDP socket to 7500 and decode — the same
technique `CLAUDE.md` recommends for the PC app.

> **The listener must bind before Max does.** Max's `udpreceive` takes the loopback unicast
> stream, and a second socket co-bound with `SO_REUSEPORT` afterwards receives **nothing** — it
> reads as "the controller is sending nothing at all" when the controller is perfectly healthy.
> Start the listener first, or close the synth while measuring. Broadcast traffic on 7400 does
> not have this problem: every bound socket gets a copy.

## Files

| File | Role |
|---|---|
| `synth/instrument/MoveBeatSynth.maxpat` | the synth device — open this to play |
| `synth/instrument/mb_voice.maxpat` | one `poly~` voice; loaded by name, not opened directly |
| `synth/controller/MoveBeatController.maxpat` | the movement device: matrix, sources, mock body |
| `synth/dsp/movebeat_core.genexpr` | the verified DSP core, embedded in the voice's `gen~` |
| `synth/build/` | the original single-patch version — still works, deliberately untouched |
