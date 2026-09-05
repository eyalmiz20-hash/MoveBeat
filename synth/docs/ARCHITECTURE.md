# MoveBeat Synth — Architecture (Max 9 patch + generated Max for Live device, no RNBO)

The MoveBeat synth is a virtual-analog subtractive synthesizer built around the
Moog transistor-ladder filter we derived and verified in Chapter 3. It is a
**Max 9 patch** built with **plain `gen~` + stock Max/MSP objects** — no RNBO.
The DSP heart (oscillators + Moog filter) lives in `gen~`; everything around it
(polyphony, envelopes, LFO, glide, MIDI, UI) is built from standard Max objects
that save normally with a full Max 9 license.

> ### ⚠️ 2026-09-05: this document used to say "no Ableton, no Max for Live"
>
> **That is no longer true, and the reversal is deliberate.** The project's
> deliverable is now **one saved Ableton Live Set**, and both halves ship as Max
> for Live devices. See the Ableton section of the repo-root `CLAUDE.md`, and
> `ZONES.md` for the zone/scene layer that only exists inside Live.
>
> What has **not** changed is everything else in this document: the parameter
> list, the ranges, the DSP rationale, the `gen~`-only-for-the-filter argument.
> The instrument is the same instrument. Only its packaging changed.

### The patch is the source; the device is generated from it

`MoveBeatSynth.maxpat` remains the file you edit and the file the verification
harness reads. `synth/docs/verification/build_devices.py` derives
`MoveBeatSynth.amxd` from it, applying exactly two substitutions:

| standalone patch | generated device |
|---|---|
| `notein` | `midiin` → `midiparse` → `unpack 0 0` |
| `ezdac~` | `plugout~` |

The on-screen `kslider` survives untouched, so the device is still playable
from the keyboard inside its Max editor.

**Never edit the `.amxd` in Live and save.** It forks from the patch silently,
and the verification scripts keep reading the patch — which is precisely how
`build/MoveBeat_ableton_ves.amxd` became a divergent copy. Structural edits go
in the `.maxpat`; Ableton is for playing.

> **Why no RNBO:** RNBO is a separate paid add-on used mainly for one-click
> export to VST/AU/Web. We don't own it and don't need it now. A full Max 9
> license already lets us save `gen~` patchers, and later gives two RNBO-free
> paths to a standalone product: **Build Application** (Max → standalone app)
> and **gen~ Export Code** (gen~ → C++ → plugin/app). So dropping RNBO costs us
> nothing today and keeps the future open.

> **On Ableton / Max for Live — superseded 2026-09-05.** This box used to argue
> that a host DAW was unnecessary. The instrument-level claim still holds: every
> object used below (`poly~`, `thispoly~`, `adsr~`, `cycle~`, `line~`/`curve~`,
> `mtof~`, `dial`, `umenu`, `toggle`) is a stock Max/MSP object, and the patch
> still runs standalone in Max with no host. Nothing here *needs* Live.
>
> What changed is the **project's goal**, not the synth's requirements. The
> deliverable became a Live Set because the piece needs song structure — scenes
> as sections, loops, a dancer launching them — and that is Live's job, not a
> synth's. M4L "only wraps a normal Max patch inside Live's plugin format", as
> this box always said; we now do exactly that, and it costs two object
> substitutions. See `build_devices.py`.
>
> **Verified end to end in Live on 2026-09-05:** the device loads, `poly~` finds
> `mb_voice` through Max's search path, a MIDI clip plays it, and three mapping
> slots drove three separate parameters audibly at once.

A guiding rule shapes every decision: **the synth is a complete, standalone
instrument that needs no camera.** It is played by MIDI (notes, velocity) and
every parameter is a named control. The Kinect/camera layer is purely optional
— when present it just writes to those same parameters over OSC. Nothing in the
audio engine depends on it.

## Signal chain (per voice)

```
MIDI note ─► pitch (mtof~) ─► [glide: line~] ─┐
                                              ▼
        OSC 1 (saw/sq/tri/sin, anti-aliased) ┐
        OSC 2 (detuned, same shapes)         ├─► mix ─► drive ─► MOOG LADDER ─► ×VCA ─► out
        SUB   (square, −1 octave)            ┘         (all inside gen~)   ▲         ▲
                                                          filter cutoff  ┘   amp   ┘
                                     (filter adsr~ + LFO cycle~ + keytrack)  (amp adsr~)
```

The oscillators, drive and Moog ladder filter are the `gen~` object
(`movebeat_core.genexpr`) — unchanged from before. Everything else is stock
Max: `adsr~` envelopes, `cycle~` LFO, `line~`/`curve~` glide, `poly~` for
polyphony, `notein`/`mtof~` for MIDI, `dial`/`umenu`/`toggle` for the UI, and
`dac~` for audio out.

## The filter (the heart) — unchanged

Four one-pole ZDF/TPT low-pass stages in series (4 × 6 dB = 24 dB/oct) with one
inverted, saturated feedback loop around the chain. The verified math, exactly
as written in `moog_ladder.genexpr`:

```
g = tan(π·Fc/Fs)      G = g/(1+g)
v = G·(x − s)   y = v + s   s = y + v        (per stage, ×4)
U = tanh(x − k·y4)    k ∈ [0,4]   (k = 4 → self-oscillation)
```

`gen~` is required here (and only here) because the Moog ladder needs
**single-sample feedback** (`y(n−1)` every sample). Stock MSP objects process in
64-sample blocks and force a one-block delay in any feedback loop, which
destroys the resonance. `gen~`'s `History` gives the exact one-sample delay the
math requires. This is the sole reason a full Max 9 license is needed.

## How the pieces fit (standalone, no-host structure)

Two patchers:

**1. The main patcher (`MoveBeat.maxpat`)** — the top-level, standalone patch:

- `notein` → MIDI note number + velocity, from whatever MIDI source is
  selected in Max's own MIDI Setup (a real controller, or a virtual/IAC MIDI
  bus). A `kslider` (on-screen keyboard) can substitute for a controller
  during testing.
- A `poly~ movebeat_voice 8` object hosts the polyphonic voices. MIDI notes are
  distributed to voices by `poly~` (note/voice allocation + voice stealing).
- All UI controls (`dial`/`umenu`/`toggle`) send their values as messages into
  `poly~`, which broadcasts them to every voice's `gen~` parameters (a message
  with no voice target reaches all voices).
- Voice outputs sum inside `poly~` → `dac~` (audio out, driven directly by
  Max's DSP engine — no host track needed). An `ezdac~` (which has a built-in
  on/off toggle) is the simplest way to start/stop audio while testing, since
  a bare Max patch has no host transport to turn DSP on automatically.
- The `mono`/`poly` toggle sets the voice-allocation behaviour (see below).

**2. The voice patcher (`movebeat_voice.maxpat`)** — one polyphonic voice,
instantiated N times by `poly~`. Contains:

- `thispoly~` for voice management (mutes the voice when its envelope finishes,
  so `poly~` can reuse it).
- pitch path: note number → `line~` (glide) → `mtof~` → `gen~` inlet 1.
- gate: velocity > 0 → triggers `adsr~` (amp) and a second `adsr~` (filter).
- cutoff modulation sum: `cutoff` + filterEnv×amount + LFO×depth + keytrack →
  `gen~` inlet 2 (clamped to 20–18000 Hz).
- `gen~ movebeat_core` — the DSP core.
- amp VCA: `gen~` output × amp-`adsr~` → `out~ 1`.

The gen~ core is identical in every voice; per-voice envelopes/glide live in the
voice patcher, so each note gets independent articulation — standard `poly~`
behaviour.

## Mono / Poly (UI switch)

A single `toggle` chooses voicing:

- **Poly** — `poly~` runs all 8 voices; new notes take free voices and steal the
  oldest when full. Play chords.
- **Mono** — notes are forced to a single voice with legato + glide (last-note
  priority). This is the classic Moog behaviour and the best mode for the
  filter's self-oscillating drones and for continuous camera control.

Implementation: the toggle switches `poly~` note distribution between all-voices
and one-voice, and enables the `line~` glide time in mono. The gen~ core is
identical in both modes.

## Parameters (UI now, camera/OSC later)

Every sound parameter is a `gen~` `Param` inside `movebeat_core.genexpr`, set by
sending a `name value` message to `gen~`. In the patch a `dial`/`umenu` drives
each one; the camera later sends the *same* parameter names over OSC into the
same message path. One list, two drivers.

| Parameter        | Range            | UI control      | Likely camera source (future) |
|------------------|------------------|-----------------|-------------------------------|
| `cutoff`         | 20–18000 Hz      | dial            | hand height (Y)               |
| `resonance`      | 0–4              | dial            | hand distance / spread        |
| `drive`          | 0–1              | dial            | torso lean                    |
| `osc1wave`/`osc2wave` | saw/sq/tri/sin | umenu        | —                             |
| `osc1level`/`osc2level`/`sublevel` | 0–1 | dials     | —                             |
| `detune`         | −24…+24 st       | dial            | —                             |
| `pw`             | 0.05–0.95        | dial            | hand rotation                 |
| `ampA/D/S/R`     | env times/level  | dials (→ `adsr~`) | —                           |
| `filtA/D/S/R` + `filtEnvAmt` | env + amount | dials (→ `adsr~`) | —                     |
| `lfoRate`/`lfoDepth`/`lfoDest` | —      | dials/umenu (→ `cycle~`) | body sway           |
| `glide`          | 0–1 s            | dial (→ `line~`) | —                            |
| `mono` (toggle)  | 0/1              | toggle          | —                             |
| `outgain`        | 0–1              | dial            | overall movement energy       |

Camera path (later): Kinect → MoveBeat (C#) → OSC (`/movebeat/cutoff` …) →
`udpreceive` + CNMAT `OSC-route` in the patch → same parameter messages. No
change to the engine.

## The two-device split (current structure)

The synth and the camera are now **two separate Max patches** that talk over OSC, rather than
one patch with the camera wired directly into the engine. `synth/docs/MAPPING.md` is the
contract between them and the reference for anything mapping-related.

- **`synth/instrument/MoveBeatSynth.maxpat`** — the instrument. MIDI/keyboard in, audio out,
  every parameter on a panel. Contains no camera code and needs no controller to be playable.
  Optional control arrives as normalised 0–1 OSC on port 7500.
- **`synth/controller/MoveBeatController.maxpat`** — movement in, 0–1 features out. Reads the
  Kinect stream from the PC on port 7400, or its own built-in mock body when no camera is
  present, and sends `/movebeat/<param>` to the synth.

The controller sends **fractions, not Hz**: the synth owns its own parameter ranges. That is
what lets a future MoveNet/webcam controller drive this synth without either side changing.

`synth/build/` still holds the original single-patch version. It works and is deliberately
left in place; nothing in the new structure depends on it, and the two share no files.

## File layout

```
MoveBeat/synth/
  dsp/
    moog_ladder.genexpr     ← standalone filter (thesis reference + reuse)
    movebeat_core.genexpr   ← full audio engine (osc + drive + filter)  [unchanged]
  docs/
    ARCHITECTURE.md         ← this file
    MAPPING.md              ← movement → CC/OSC → parameter contract; tuning guide
    verification/           ← Python proof the DSP is correct/stable
  instrument/               ← THE SYNTH DEVICE
    MoveBeatSynth.maxpat    ← open this to play
    mb_voice.maxpat         ← one poly~ voice (loaded by name, not opened directly)
  controller/               ← THE MOVEMENT DEVICE
    MoveBeatController.maxpat  ← live Kinect OSC + mock body + feature mapping
  build/                    ← ORIGINAL single-patch version, still working, untouched
    BUILD_GUIDE.md          ← step-by-step: gen~ + poly~ in standalone Max 9
    MoveBeat.maxpat         ← the original combined patcher
    movebeat_voice.maxpat   ← the original poly~ voice patcher
```

> The voice patcher is deliberately **renamed** in the new device (`mb_voice` rather than
> `movebeat_voice`). `poly~` resolves voice patchers by name through Max's search path, so
> reusing the old name would have made every edit to the new voice silently change the old
> patch too — and two files with the same basename in one search path are ambiguous to Max.

> Note: `build/MoveBeat_ableton_ves.amxd` predates all of this. It is **not** the
> device the project ships — that one is generated by `build_devices.py` from
> `MoveBeatSynth.maxpat`. The old file is a hand-edited near-copy of the
> *pre-split* patch carrying its own drifted parameter state, and it references
> `movebeat_voice` rather than `mb_voice`. Treat it as history; it is the
> cautionary example for why devices are generated and never hand-edited.

## Build order

1. gen~ core DSP — **done** (`moog_ladder.genexpr`, `movebeat_core.genexpr`).
2. Python verification of the DSP — **done** (`docs/verification/`).
3. In Max 9: build the voice patcher (`movebeat_voice.maxpat`) around `gen~`, then
   the main patcher (`MoveBeat.maxpat`) with `poly~`, MIDI, UI and the mono/poly
   toggle, and save both — follow `build/BUILD_GUIDE.md`.
4. Later (optional, RNBO-free): camera via OSC; and turning the patch into a
   standalone app/plugin via Max **Build Application** or **gen~ Export Code**.

## Future: turning this into a standalone app/plugin (still without RNBO)

- **Build Application** — full Max 9 exports the patch (including `gen~`) to a
  standalone Mac/Windows app that runs with no Max license or runtime needed
  by the end user. No RNBO.
- **gen~ Export Code** — full Max 9 exports the filter as C++; compile into a
  VST/AU or any app (e.g. via JUCE). No RNBO. Most portable — you own the code.
- **Reimplement the DSP** — the algorithm is documented and Python-verified, so
  it can be rebuilt in any language, independent of Max entirely.
