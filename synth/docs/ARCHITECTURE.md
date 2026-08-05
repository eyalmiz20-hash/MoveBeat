# MoveBeat Synth — Architecture (standalone Max 9, no Ableton, no M4L, no RNBO)

The MoveBeat synth is a virtual-analog subtractive synthesizer built around the
Moog transistor-ladder filter we derived and verified in Chapter 3. It is a
**standalone Max 9 patch** built with **plain `gen~` + stock Max/MSP objects**
— no Ableton Live, no Max for Live, no RNBO. The DSP heart (oscillators + Moog
filter) lives in `gen~`; everything around it (polyphony, envelopes, LFO,
glide, MIDI, UI) is built from standard Max objects that save normally with a
full Max 9 license and run directly inside Max, with no host application
required.

> **Why no RNBO:** RNBO is a separate paid add-on used mainly for one-click
> export to VST/AU/Web. We don't own it and don't need it now. A full Max 9
> license already lets us save `gen~` patchers, and later gives two RNBO-free
> paths to a standalone product: **Build Application** (Max → standalone app)
> and **gen~ Export Code** (gen~ → C++ → plugin/app). So dropping RNBO costs us
> nothing today and keeps the future open.

> **Why no Ableton / Max for Live:** we bought Max 9 standalone, not Live or
> the M4L add-on. Nothing in this design needs a host DAW — Max 9 on its own
> can take MIDI input (from a real controller via Max's own MIDI Setup, or
> from an on-screen `kslider` for quick testing), run DSP through `dac~`, and
> export a finished `.app`/`.exe` when done. Every object used below (`poly~`,
> `thispoly~`, `adsr~`, `cycle~`, `line~`/`curve~`, `mtof~`, `notein`, `dial`,
> `umenu`, `toggle`, `dac~`, etc.) is a stock Max/MSP object, not something
> M4L adds — M4L only wraps a normal Max patch inside Live's plugin format,
> which we are deliberately not doing.

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

## File layout

```
MoveBeat/synth/
  dsp/
    moog_ladder.genexpr     ← standalone filter (thesis reference + reuse)
    movebeat_core.genexpr   ← full audio engine (osc + drive + filter)  [unchanged]
  docs/
    ARCHITECTURE.md         ← this file
    verification/           ← Python proof the DSP is correct/stable
  build/
    BUILD_GUIDE.md          ← step-by-step: gen~ + poly~ in standalone Max 9
    MoveBeat.maxpat         ← the main patcher (built in Max 9)
    movebeat_voice.maxpat   ← the poly~ voice patcher (built in Max 9)
```

> Note: an earlier `build/MoveBeat.amxd` (an empty Max for Live Instrument
> template) predates this decision and is no longer part of the build — the
> deliverable is `MoveBeat.maxpat`, a plain standalone patch.

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
