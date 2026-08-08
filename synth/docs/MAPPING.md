# MoveBeat — Movement → Sound Mapping

This is the contract between the two Max devices. Both hops below are **cross-machine or
cross-device APIs**: changing an address or a value range silently changes the sound with no
error anywhere and no compile step to catch it. Treat this file as the spec, and change the
patches and this document in the same commit.

## The two devices

```
   WINDOWS PC                              MAC
┌───────────────┐                 ┌──────────────────────────┐   ┌────────────────────┐
│  Kinect v2    │                 │ MoveBeatController.maxpat│   │ MoveBeatSynth.maxpat│
│      ↓        │   OSC /mb/…     │                          │   │                     │
│  MoveBeat.exe │ ──UDP 7400──►   │  joints → 0..1 features  │   │  0..1 → parameters  │
│    (C#)       │   wired LAN     │            ↓             │   │         ↓           │
└───────────────┘                 │      OSC /movebeat/…     │──►│   poly~ → gen~ → 🔊 │
                                  └──────────────────────────┘   └────────────────────┘
                                         UDP 7500, localhost
```

The synth contains **no camera code of any kind**. It is a complete instrument on its own:
it plays from MIDI or its on-screen keyboard, every parameter has a control on its panel, and
it runs on macOS with nothing attached. The controller is optional, and any device that speaks
hop 2 below can replace it — which is what keeps the planned MoveNet/webcam controller a
drop-in addition rather than a rewrite.

## Hop 1 — Kinect → controller (port 7400)

**Unchanged, and must stay unchanged.** Defined by `MoveBeat/OscSender.cs` and documented in
`CLAUDE.md`. One OSC bundle per body frame, 26 messages: `/mb/<lowercase JointType> x y z
trackingState` for all 25 joints, plus `/mb/tracked` carrying 0 or 1. `trackingState` is
0 = NotTracked, 1 = Inferred, 2 = Tracked.

The controller consumes only six of the 25 joints and ignores the rest. Received by
`[p mb_osc_in]`, the only camera-facing subpatch in the Max side of this repo.

## Hop 2 — controller → synth (port 7500, localhost)

Five addresses. **Every payload is a single float, normalised 0.0–1.0.**

| Movement feature | Joints used | OSC address | Synth parameter |
|---|---|---|---|
| Right-hand height | `handright.y` | `/movebeat/cutoff` | `cutoff` |
| Distance between the hands | `handright.x` − `handleft.x` | `/movebeat/resonance` | `resonance` |
| Torso lean | `spineshoulder.z` − `spinebase.z` | `/movebeat/drive` | `drive` |
| Right-hand vertical speed | mean \|Δ`handright.y`\| over 8 frames | `/movebeat/outgain` | `outgain` |
| Body present | `/mb/tracked` | `/movebeat/gate` | indicator (see below) |

Every joint is gated on `trackingState == 2`, so inferred or lost joints never reach the synth
— the last good value simply holds.

### Why 0–1 and not Hz

The controller does not know what a cutoff frequency is. It reports *how high the hand is*,
as a fraction; the synth decides that this means 179 Hz or 4.4 kHz. This split is deliberate:

- Parameter ranges are a property of the instrument, so they live in the instrument.
- A different controller — MoveNet, a webcam, a hardware box — only has to emit 0–1 on these
  five addresses. It needs to know nothing about Moog ladder filters.
- 0–1 is the same shape as a MIDI CC divided by 127, so moving to CC later is a multiply.

## Where to tune what

Two halves, in two places, on purpose.

**How much movement counts as "full"** lives in the controller, in `[p mb_features]`. These are
the `[scale]` objects:

| Feature | Object | Meaning |
|---|---|---|
| Hand height | `scale -0.5 1. 0. 1.` | −0.5 m is the bottom of the range, +1.0 m the top |
| Hand spread | `scale 0. 1.4 0. 1.` | hands together = 0, 1.4 m apart = full |
| Torso lean | `scale 0. 0.35 0. 1.` | 0.35 m of shoulder-vs-hip depth = full |
| Hand speed | `scale 0. 0.06 0. 1.` | 0.06 m per frame (≈1.8 m/s) = full |

**What the synth does with a 0–1 value** lives in the synth, in `[p mb_ctrl_in]`:

| Parameter | Range | Curve |
|---|---|---|
| `cutoff` | 100 – 8000 Hz | exponential, `100 · 80^x` — equal hand movement gives equal musical intervals |
| `resonance` | 0 – 3.5 | linear (the gen~ Param allows up to 4; 4 self-oscillates) |
| `drive` | 0 – 1 | linear |
| `outgain` | 0 – 1 | linear |

`/movebeat/gate` currently drives an indicator toggle on the synth panel only. It exists so the
synth can react to losing the body — muting, freezing, or fading — but choosing that behaviour
is a musical decision, so nothing is wired to it yet.

## Smoothing

The camera stream is 30 Hz. Sent raw, that steps audibly on any continuous parameter. Two
different mechanisms handle it, because the parameters travel by two different routes:

**`cutoff` is a signal** inside the voice. `mb_voice.maxpat` replaces the original
`[sig~ 800]` — which jumps at block boundaries — with a `[line~]` fed by `[pack 0. 25]`, so
every cutoff message ramps over 25 ms at signal rate.

**`resonance`, `drive` and `outgain` are `gen~` Params**, set by message. gen~ does **not**
interpolate Param changes, so these are interpolated at control rate in `[p mb_ctrl_in]` with
`[pack 0. 25]` → `[line 0. 5]`: a 25 ms ramp emitted every 5 ms. Measured on the mock body,
that turns the 30 Hz input into a ~151 Hz parameter stream whose largest single step is 0.25%
of the observed range.

If `outgain` ever still clicks on a very fast move, the fix is to pin the Param at 1.0 and do
the gain with a `[line~]`-driven `[*~]` in the voice — outside `gen~`, leaving the verified
DSP core untouched.

## Resolution — why OSC rather than MIDI CC

The project brief allowed MIDI CC. It is not used, for one hard reason and one soft one.

**Hard:** the Kinect and the synth are on two different computers. MIDI does not cross
Ethernet without RTP-MIDI, which on Windows means installing a third-party driver, and
`CLAUDE.md` records that the Windows account is not an administrator. OSC over UDP already
works and is byte-verified.

**Soft:** standard CC is 7-bit — 128 steps. Across a 100–8000 Hz exponential cutoff sweep each
step is about a 3.6% frequency jump, which is audible as stepping on a slow sweep even with
smoothing. OSC carries a 32-bit float, so the resolution question does not arise.

If MIDI CC is ever needed anyway — to drive the synth from a hardware controller, say — add
`[ctlin]` alongside `[udpreceive]` in `[p mb_ctrl_in]` and scale by `1/127`. Everything
downstream is already expecting 0–1. For a hardware sweep of `cutoff`, prefer 14-bit CC
(a coarse CC paired with CC+32 as the fine byte, 16384 steps) over 7-bit.

## Running it

Both devices open in Max 9 on the Mac.

1. Open `synth/instrument/MoveBeatSynth.maxpat` and click the `ezdac~` speaker to start audio.
   Play the on-screen keyboard — it should sound with no controller running at all.
2. Open `synth/controller/MoveBeatController.maxpat`.
3. Pick an input source from the menu at the top left:
   - **LIVE** — receives the real Kinect stream on port 7400. The Mac must be on the wired
     `192.168.0.x` LAN, not Wi-Fi, or nothing arrives (see `CLAUDE.md`).
   - **MOCK** — no camera needed. Drag the five sliders to fake a body, and the auto-motion
     generator emits complete joint messages at the Kinect's real ~30 Hz so the smoothing and
     the feature maths see a realistic stream.
4. The four number boxes on the controller show the normalised features actually leaving the
   device. The synth panel shows the last parameter it received.

To watch the wire without Max, bind a UDP socket to 7500 and decode — the same technique
`CLAUDE.md` recommends for the PC app, and the one used to verify this mapping.

## Files

| File | Role |
|---|---|
| `synth/instrument/MoveBeatSynth.maxpat` | the synth device — open this to play |
| `synth/instrument/mb_voice.maxpat` | one `poly~` voice; loaded by name, not opened directly |
| `synth/controller/MoveBeatController.maxpat` | the movement device, including the mock body |
| `synth/dsp/movebeat_core.genexpr` | the verified DSP core, embedded in the voice's `gen~` |
| `synth/build/` | the original single-patch version — still works, deliberately untouched |
