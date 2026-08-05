# MoveBeat Synth — Build Guide (gen~ + poly~ standalone Max 9 patch, no Ableton, no M4L, no RNBO)

This guide turns the already-verified DSP core (`dsp/moog_ladder.genexpr`,
`dsp/movebeat_core.genexpr`, both confirmed correct in
`docs/verification/VERIFICATION_REPORT.md`) into a playable instrument using
**only plain `gen~` and stock Max/MSP objects, running directly in Max 9 with
no host application**. It assumes a full Max 9 license and nothing else —
no Ableton Live, no Max for Live, no RNBO.

> **No Ableton, no M4L, no RNBO anywhere in this build.** We bought Max 9
> standalone. A full Max license saves `gen~` patchers normally, runs `poly~`
> polyphony natively, and takes MIDI straight from Max's own MIDI Setup (or
> from an on-screen `kslider` for testing without a controller) — none of
> that requires a host DAW. Audio leaves the patch through plain `dac~`, not
> `plugout~`. Every object used below (`poly~`, `thispoly~`, `adsr~`,
> `cycle~`, `line~`/`curve~`, `mtof~`, `notein`, `dial`, `umenu`, `toggle`,
> `dac~`, etc.) is a stock Max/MSP object documented at docs.cycling74.com.
> See `docs/ARCHITECTURE.md` for the full rationale and the "why gen~ only
> for the filter" explanation (the Moog ladder needs single-sample feedback,
> which only `gen~`'s `History` operator provides inside stock Max).

Work happens in this repo's `MoveBeat/synth/build/` folder so the Max
project, the two patchers, and the docs that describe them sit together.
Wherever an object's exact message/attribute name matters, this guide uses
the name as documented on `docs.cycling74.com/reference/`; where a detail is
a UI workflow rather than an object (menu wording, panel layout), it is
described by function so it stays correct across small Max version
differences.

> A stray `build/MoveBeat.amxd` may still exist from an earlier Ableton/M4L
> plan — it is just the empty default Max for Live Instrument template with
> nothing built inside it. It's no longer part of this build; the
> deliverable described below is `MoveBeat.maxpat`, a plain patch. You can
> ignore or delete the `.amxd` once `MoveBeat.maxpat` exists.

## 1. Overview: two patchers, one gen~ core

The synth is built from two Max patchers plus the existing DSP file:

- **`MoveBeat.maxpat`** — the main, top-level patch. Holds `notein` (MIDI in),
  a `poly~ movebeat_voice 8` object (the polyphonic voice manager), every
  `dial`/`umenu`/`toggle` in the UI, the mono/poly toggle, and `dac~`/`ezdac~`
  (audio out). Nothing in this patcher processes audio directly except
  summing what `poly~` returns.
- **`movebeat_voice.maxpat`** — the voice patcher, loaded and instantiated 8
  times by `poly~`. Holds `thispoly~` (voice management), the pitch/glide
  path, the gate and both `adsr~` envelopes, the LFO (`cycle~`), the
  cutoff-modulation summing math, the `gen~ movebeat_core` object itself,
  and the final VCA multiply into `out~`.
- **`dsp/movebeat_core.genexpr`** — unchanged. The oscillators, drive stage
  and Moog ladder filter, loaded into the `gen~` object inside the voice
  patcher. This is the *only* piece of the signal path that runs inside
  `gen~`; everything else (envelopes, LFO, glide, MIDI, mixing voices, UI)
  is stock Max/MSP, exactly as `docs/ARCHITECTURE.md` specifies.

Build order: voice patcher first (it has no dependency on the main patch),
then the main patcher that wraps it in `poly~`.

## 2. Create the Max Project and the main patcher

1. Open Max 9 and choose **File → New Project**, saving the project as
   `MoveBeat.maxproj` in `MoveBeat/synth/build/`. A Max Project keeps
   `MoveBeat.maxpat`, `movebeat_voice.maxpat`, and any support files
   (including a copy of, or search-path reference to,
   `movebeat_core.genexpr`) together and easy to find.
2. Add `MoveBeat/synth/dsp/` to the project (or to Max's file preferences
   search path) so `movebeat_core.genexpr` is found automatically by name
   when `gen~` loads it later — no need to duplicate the DSP file into
   `build/`.
3. In the project, choose **File → New Patcher** and save it as
   `MoveBeat.maxpat` in `build/`. This is a plain patch, not a Max for Live
   device — there is no template scaffolding to accept or discard, you're
   starting from a blank window.
4. Add an `ezdac~` object early on (it has a built-in on/off toggle and VU
   meters) so you can start/stop audio and see levels while you build —
   a bare Max patch has no host transport to turn DSP on automatically, so
   this replaces that role. You can swap it for a plain `dac~` later if you
   want a cleaner final UI (in that case, add a separate `toggle` wired to
   the global `dsp` message, e.g. via `startwindow`/`dspstate~`, to turn
   audio on/off).
5. Make sure Max is receiving MIDI: open **Options → MIDI Setup** (or the
   MIDI Status window) and confirm your controller is listed and enabled.
   If you don't have a MIDI controller handy, add a `kslider` (on-screen
   piano keyboard) to the patch for testing — its output is a `[note
   velocity]` pair, exactly what `notein` would otherwise supply, so
   wherever this guide says "from `notein`" you can substitute `kslider`
   output.
6. Keep `MoveBeat.maxpat` open while you build — Max recompiles and re-runs
   DSP live every time you edit and the patch is unlocked/locked again,
   which becomes the fast iteration loop for the rest of this guide.

## 3. Build the voice patcher: gen~ core, inlets/outlets, thispoly~

Create a new patcher, save it as `movebeat_voice.maxpat` in `build/`. This
patcher is never opened directly by the user — `poly~` loads it by filename
(section 6). A patcher loaded by `poly~` communicates with the outside world
through `in`/`in~` objects (inputs) and `out`/`out~` objects (outputs); the
number of inlets/outlets `poly~` shows on its own box is set by the highest
numbered `in`/`in~`/`out`/`out~` object found inside.

1. Add `in 1` — this is the reserved inlet `poly~` uses to deliver
   voice-allocated note data (see section 4; `poly~`'s `note`/`midinote`
   messages route to "the first `in` object of the first instance", per the
   `poly~` reference). Its output is a `[note velocity]` list.
2. Add `in 2` — a second message inlet used only for **parameter
   broadcasts** from the UI (section 7): messages like `cutoff 800` or
   `ampA 5` arrive here.
3. Add `gen~ movebeat_core` (no `movebeat_core.genexpr` extension in the
   argument — `gen~` resolves `.genexpr`/`.gendsp` files by name via the
   search path set up in section 2). Alternative: open the empty `gen~`
   object's codebox (double-click) and paste the contents of
   `movebeat_core.genexpr` directly in — functionally identical, useful if
   you want the DSP embedded in the patcher rather than referencing an
   external file. Confirm the object shows 2 signal inlets (matching the
   file's `in1`/`in2` usage) and 1 signal outlet (`out1`).
4. Add `thispoly~` somewhere in the patcher (its position doesn't matter for
   audio routing — it exists purely to talk to the containing `poly~`). Per
   the `thispoly~` reference: placed inside a patcher loaded by `poly~`, it
   sends/receives the "busy" and "mute" state that `poly~` uses for voice
   allocation and voice stealing. Section 5 wires its signal inlet to the
   amp envelope so a voice frees itself automatically when its envelope
   finishes.
5. Add `out~ 1` for the final audio output (wired up in section 5).

The rest of this patcher (sections 4–5) fills in the path from `in 1`/`in 2`
to `gen~`'s two signal inlets and from `gen~`'s output to `out~ 1`.

## 4. MIDI, pitch, glide and gate inside the voice

`movebeat_core.genexpr`'s header states `in1 = pitch, in Hz` and `in2 =
filter cutoff modulation, in Hz` — the DSP core takes no MIDI and has no
built-in envelope; both are built here in stock Max around it.

1. **Getting note data in.** In the main patcher, `notein` (or `kslider`,
   see section 2.5) produces MIDI note number and velocity (section 6 wires
   this to `poly~`). `poly~` distributes each note-on/note-off to a voice
   using its `midinote` message — send `midinote <note> <velocity>` into
   `poly~`'s left inlet. Per the `poly~` reference: if the velocity is
   non-zero, the pair is routed to the first available (non-busy) instance;
   if the velocity is 0 (a note-off), it is automatically routed back to
   whichever instance is already playing that same pitch. This means
   note-off tracking is automatic — you do not need to build your own
   note/voice lookup table. Inside the voice patcher, `in 1` outputs this
   `[note velocity]` list.
2. **Splitting the list.** Feed `in 1` into `unpack 0 0` (or `unpack i i`)
   to separate `note` (left outlet) from `velocity` (right outlet).
3. **Glide.** Feed the raw MIDI note number into a `line~` (linear ramp) or
   `curve~` (exponential-curve ramp) object, sending it a `[note glide-ms]`
   list (pack the note value with the current glide time in ms, driven by
   the `glide` parameter from section 7) so the object ramps smoothly from
   the previous note to the new one over the glide time. Smoothing at this
   stage — on the *linear* MIDI note-number scale, before Hz conversion —
   is deliberate: smoothing an already-converted Hz value glides unevenly
   across octaves, while smoothing the note number and converting last
   gives a constant "time per semitone" feel, matching how analog/MIDI
   synth portamento is normally implemented.
4. **Note → Hz.** Feed the (glide-smoothed) note-number signal into
   `mtof~`, the signal-rate MIDI-to-frequency converter, and patch its
   output directly into `gen~`'s signal inlet 1 (pitch in Hz, matching the
   DSP core's documented `in1`).
5. **Gate.** The velocity value from step 2 is the gate and also the
   envelope's trigger amplitude: `adsr~` (used twice in section 5) treats
   any non-zero value received in its trigger inlet as "start attack, ramp
   toward this amplitude", and a 0 as "note-off, start release" (per the
   `adsr~` reference). So scale velocity 0–127 to a 0–1 gain (divide by
   127) and send that value straight into both `adsr~` objects' trigger
   inlets — no separate boolean gate signal is needed, and this makes the
   envelope naturally velocity-sensitive.
6. **Voice-free notification.** `thispoly~`'s signal inlet sets the voice's
   "busy" state automatically: a non-zero incoming signal marks the voice
   busy, and it drops back to not-busy only once that signal is truly
   silent (per the `thispoly~` reference). Wire the amp envelope's audio
   output (section 5) into `thispoly~`'s inlet, so the voice self-reports
   "free" the instant its amplitude envelope finishes — `poly~` can then
   reuse it for a new note without stealing an audibly active voice first.

## 5. Envelopes, LFO, keytrack and the VCA

Two independent `adsr~` envelopes live in the voice patcher, both driven by
the velocity/gate signal from section 4:

**Amp envelope (VCA).**

1. Add an `adsr~` object. Its four stage parameters map to the exposed
   dials `ampA` (attack, ms), `ampD` (decay, ms), `ampS` (sustain, 0–1
   gain), `ampR` (release, ms) — set via named messages into `adsr~` (e.g.
   `attack 20`, `sustain 0.7`); check the Inspector/help patcher for the
   exact message names in your Max version, since `adsr~` also accepts a
   plain argument list in a fixed order.
2. Send the scaled 0–1 velocity from section 4 into `adsr~`'s trigger
   inlet.
3. Multiply `gen~`'s audio outlet (`out1`, the finished filtered signal) by
   this `adsr~`'s output — a plain `*~` — to form the VCA. Send the result
   to `out~ 1`.
4. Also send this same `adsr~` output into `thispoly~`'s inlet (section
   4.6), so voice-freeing tracks the actual audible envelope tail.

**Filter envelope + LFO + keytrack, summed into `gen~` inlet 2.**

`movebeat_core.genexpr`'s filter section reads `fcin = (in2 > 0.) ? in2 :
cutoff` — if inlet 2 carries a non-zero signal, it **replaces** the internal
`cutoff` Param entirely, rather than adding to it. So the summed signal
patched into inlet 2 must itself include the base cutoff value, not just the
modulation:

1. A second `adsr~` (filter envelope), triggered by the same velocity/gate
   signal, exposed as `filtA`/`filtD`/`filtS`/`filtR`.
2. An `filtEnvAmt` dial (Hz) whose value, converted to a signal with `sig~`,
   multiplies (`*~`) the filter `adsr~`'s 0–1 output into a Hz offset.
3. An LFO: `cycle~` running at sub-audio rate, its frequency set by an
   `lfoRate` dial (Hz, e.g. 0.05–20 via a message into `cycle~`'s frequency
   inlet or a `sig~ → cycle~` signal-rate connection). Its bipolar (−1..1)
   output is scaled by `lfoDepth` (Hz, via `sig~`+`*~`) the same way as the
   filter envelope.
4. Keytrack: multiply the note-number (or the `mtof~` Hz value) by a
   keytrack amount so higher notes open the filter proportionally —
   standard analog-synth behavior. (If you don't expose a dedicated
   keytrack dial yet, a fixed internal amount, or 0, is a reasonable
   starting point — it is not in `ARCHITECTURE.md`'s table as a UI control.)
5. Convert the base `cutoff` dial value to a signal with `sig~` and sum
   everything with `+~`: `cutoff-signal + filtEnvAmt*envOut + lfoDepth*lfoOut
   + keytrackAmt*note`. Clamp the result to 20–18000 Hz (e.g. with
   `clip~ 20 18000`) before patching it into `gen~`'s signal inlet 2. The
   `gen~` code re-clamps internally too, so this external clamp is a
   headroom safety net, not a strict requirement.

Because inlet 2 is now always driven with a non-zero, base-inclusive signal,
the internal `cutoff` Param effectively becomes a fallback default (used
only if inlet 2 is ever disconnected, e.g. for a quick A/B test). This is
exactly the two-driver relationship `ARCHITECTURE.md` and the `.genexpr`
header describe: **plain control** → send `cutoff <value>` as a `gen~`
Param message (see section 7) when inlet 2 is unpatched; **full modulation**
→ patch the summed envelope+LFO+keytrack+base signal into inlet 2, which is
what this build does by default.

Both `adsr~` objects, the LFO, and the summing math are per-voice — they
live inside the same `movebeat_voice.maxpat` instantiated 8× by `poly~`, so
every simultaneously-held note gets fully independent envelopes and LFO
phase, which is standard `poly~` behavior (each instance is a fully separate
patcher with its own state).

## 6. Wrap it in poly~ in the main patcher

Back in `MoveBeat.maxpat`:

1. Add `poly~ movebeat_voice 8` — the patcher-name argument
   (`movebeat_voice`, matching `movebeat_voice.maxpat` in the search path)
   and the instance count (`8`, matching `ARCHITECTURE.md`'s 8-voice
   polyphony) are both ordinary `poly~` arguments. `poly~` will show two
   inlets (matching `in 1`/`in 2` in the voice patcher) and one signal
   outlet (matching `out~ 1`).
2. From `notein` (or `kslider`), take note number and velocity, pack them as
   `midinote <note> <velocity>` (e.g. with a `pak`/`pack` object prefixed by
   a `midinote` message via `prepend midinote`), and send that into
   `poly~`'s left inlet (inlet 1 → the voice patcher's `in 1`).
3. `poly~`'s own voice allocation and stealing then apply automatically: by
   default `poly~` sends `note`/`midinote` data to "the first instance that
   has not marked itself busy" (per the reference), cycling through the
   least-recently-used voice once `legacynotemode` is off (the modern
   default). To allow voice stealing once all 8 are busy — so a 9th
   simultaneous note doesn't simply drop — set `poly~`'s `steal` attribute
   to 1 (or send it the message `steal 1`); this is the "voice-stealing"
   `ARCHITECTURE.md` calls for.
4. `poly~`'s signal outlet already sums all 8 voices' `out~ 1` outputs
   (per the reference: "signals sent to the inlet of `out~` objects in each
   patcher instance are mixed ... and appear at the corresponding outlet of
   the `poly~` object"). Patch that outlet straight into `ezdac~`/`dac~`
   (stereo: duplicate to both inlets, or pan/widen as desired).
5. At load time (a `loadbang`), send `poly~` the message `target 0`. The
   `target` attribute controls which instance receives *non-allocation*
   messages arriving at `poly~`'s inlets (everything except `note`/
   `midinote`), and `target 0` explicitly means "send to all instances" —
   this is what makes the parameter-broadcast path in section 7 work
   without having to prefix every dial message with a target number.

## 7. Driving gen~ Params from the UI (parameter broadcast)

A `gen~` `Param` is set by sending it a plain Max message of the form
`<paramname> <value>` — the object matches the message's first element
against its declared `Param` names and updates that one (this is documented
`gen~` behavior: messages sent to the object's message-capable inlet are
matched by name against Params declared inside the Gen patcher).
`movebeat_core.genexpr` declares: `osc1wave`, `osc2wave`, `osc1level`,
`osc2level`, `sublevel`, `detune`, `pw`, `cutoff`, `resonance`, `drive`,
`rescomp`, `outgain`.

Wiring, for every dial/menu/toggle in the main patcher:

1. Each `dial`/`umenu`/`toggle` outputs a plain number. Put a
   `prepend <paramname>` object (or a message box `<paramname> $1`) right
   after it, turning e.g. a dial's `800` into the message `cutoff 800`.
2. Send that message into `poly~`'s **second** inlet (inlet 2 → the voice
   patcher's `in 2`), which — because `target` was set to `0` in section
   6.5 — broadcasts to all 8 voices at once, so every voice's `gen~` and
   every voice's stock objects update together.
3. Inside the voice patcher (extending section 3), route `in 2`'s incoming
   messages two ways with a `route` object:
   - Names that belong to the **stock envelope/LFO/glide objects**
     (`ampA`/`ampD`/`ampS`/`ampR`, `filtA`/`filtD`/`filtS`/`filtR`,
     `filtEnvAmt`, `lfoRate`, `lfoDepth`, `glide`) are matched by `route`
     and sent to the corresponding `adsr~`/`cycle~`/`line~`/`sig~` object
     built in sections 4–5.
   - Everything else — the twelve `gen~` Param names listed above — falls
     through `route`'s right ("no match") outlet and is forwarded directly,
     unmodified, into `gen~`'s message inlet, exactly matching the `<name>
     <value>` format `gen~` expects.

Parameter → control mapping (from `docs/ARCHITECTURE.md`):

| Parameter | Range | UI control | Destination |
|---|---|---|---|
| `osc1wave` / `osc2wave` | 0–3 (saw/sq/tri/sin) | `umenu` | `gen~` Param |
| `osc1level` / `osc2level` / `sublevel` | 0–1 | `dial` | `gen~` Param |
| `detune` | −24…+24 st | `dial` | `gen~` Param |
| `pw` | 0.05–0.95 | `dial` | `gen~` Param |
| `cutoff` | 20–18000 Hz | `dial` | `gen~` Param (fallback) **and** base term of the inlet-2 sum (section 5) |
| `resonance` | 0–4 | `dial` | `gen~` Param |
| `drive` | 0–1 | `dial` | `gen~` Param |
| `rescomp` | 0–1 | `dial` (optional bonus) | `gen~` Param |
| `outgain` | 0–1 | `dial` | `gen~` Param |
| `ampA`/`ampD`/`ampS`/`ampR` | env times/level | `dial` | amp `adsr~` |
| `filtA`/`filtD`/`filtS`/`filtR` | env times/level | `dial` | filter `adsr~` |
| `filtEnvAmt` | Hz amount | `dial` | inlet-2 sum |
| `lfoRate` | Hz | `dial` | `cycle~` frequency |
| `lfoDepth` | Hz amount | `dial` | inlet-2 sum |
| `glide` | 0–1 s | `dial` | `line~`/`curve~` ramp time |
| `mono` | 0/1 | `toggle` | voice-allocation mode (section 8) |

Set each `dial`/`umenu`'s range (min/max, step count for menus) in its
Inspector to match this table so the on-screen values read correctly — e.g.
`cutoff` 20–18000, `resonance` 0–4, `pw` 0.05–0.95, `detune` −24..+24.

## 8. Mono/Poly toggle

A single `toggle` (`mono` in the table above) switches voicing:

- **Poly** (toggle off): the default behavior from section 6 — `poly~`
  allocates each new note to the next free voice (via `midinote`) and, with
  `steal 1` set, reuses the oldest busy voice once all 8 are full. This
  gives true chords.
- **Mono** (toggle on): force every note onto a single voice with glide and
  last-note priority, the classic analog-mono behavior `ARCHITECTURE.md`
  specifies (best for the filter's self-oscillating drones and continuous
  camera control later).

Implementation:

1. Keep a small note-priority stack in the main patcher (outside `poly~`)
   — a common stock-object pattern for last-note priority is a `zl stack`
   fed by each incoming note-on and popped on note-off, so releasing the
   most recently played note falls back to the previous held note.
2. When `mono` is on, instead of sending `midinote` (which lets `poly~`
   auto-allocate across all 8 voices), send `target 1` once, then send the
   raw `[note velocity]` pair directly to `poly~`'s left inlet — this
   forces every note to instance 1 regardless of `poly~`'s normal
   allocation, since `target` overrides which instance receives non-
   allocation-message traffic.
3. When `mono` is off, send `target 0` again (restoring the parameter
   broadcast from section 6.5/7) and go back to sending `midinote` so
   `poly~`'s automatic allocation and stealing resume.
4. Drive the `glide` dial's effective ramp time from the toggle too (e.g.
   force it non-zero, or scale it by the toggle's state) so mono mode
   always glides between the last-priority notes, while poly mode's
   negligible glide effect (each fresh voice starts unslewed) stays as-is.
5. Document whichever exact stack/priority implementation you build with a
   comment object directly in the patch, since this is the one piece of
   the signal path with real implementation freedom (`ARCHITECTURE.md`
   only specifies the required *behavior*: mono ⇒ 1 voice + glide +
   last-note priority, not the exact stock-object recipe).

## 9. Presentation-view UI and presets

1. Lay out every `dial`/`umenu`/`toggle` from section 7's table in the
   patch's Presentation view (View → Presentation, a core Max feature
   available in any patch, not just Max for Live devices), grouped to match
   the signal chain in `ARCHITECTURE.md` (oscillators, filter, amp envelope,
   filter envelope, LFO/glide, mono/poly, output) so the UI reads like the
   block diagram. Lock the patch (Presentation Mode) when playing so the UI
   behaves like a finished instrument front panel rather than an editable
   patch.
2. For in-patch preset recall, add a `pattr` object per parameter (or a
   single `pattrstorage` bound to all of them) — the standard Max mechanism
   for bundling a whole parameter set into one saved/recallable state, and
   `pattrstorage`'s own UI can save/recall named presets without any host
   involved.
3. Sanity-check the mono/poly toggle and every dial by ear before moving
   on: play a chord (poly should sound polyphonic), hold and release notes
   near max polyphony (voices should steal without hanging), and sweep
   `cutoff` while a note sustains (should audibly track through the
   inlet-2 sum built in section 5, not just jump via the Param fallback).

## 10. Save the patch

1. Save `movebeat_voice.maxpat` (Cmd/Ctrl+S).
2. Save `MoveBeat.maxpat` (Cmd/Ctrl+S). A full Max 9 license saves `gen~`
   content (embedded codebox or referenced `.genexpr` file) and `poly~`
   subpatchers normally — nothing needs to be frozen or exported just to
   have a working, saveable, reloadable patch. This is the deliverable file
   referenced in `ARCHITECTURE.md`'s file layout.
3. **Build Application (optional, for sharing/standalone use).** When
   you're happy with the patch and want to hand it to someone without a Max
   license, or run it without opening Max at all, use Max's Project window
   (**Manage Project → Build Collective/Application → Application**) or
   **File → Build Collective/Application...** to export the whole patch,
   including `gen~` and `poly~` content, as a standalone Mac/Windows
   `.app`/`.exe`. This is purely a distribution convenience — it is not
   required for you to build, save, reload, or keep developing the patch
   locally.

## 11. FUTURE (optional) — camera/OSC and further productization

Nothing below is required for the synth to work as a MIDI instrument. Both
items are explicitly RNBO-free and host-free, matching `ARCHITECTURE.md`'s
stated future path.

**Camera control via OSC.** In the main patcher (outside `poly~`), add a
`udpreceive` object on a chosen port to receive raw OSC packets from the
MoveBeat (C#) Kinect bridge. Max has no built-in OSC parser, so install the
CNMAT OSC package (via Max's Package Manager), which provides `OSC-route`
for parsing an incoming OSC-formatted list and routing it by address
pattern (e.g. `/movebeat/cutoff`, `/movebeat/resonance`, `/movebeat/drive`,
`/movebeat/outgain`, matching the "likely camera source" column in
`ARCHITECTURE.md`'s table). Feed each matched value into the exact same
`prepend <paramname>` → `poly~` inlet 2 path built in section 7 — camera and
UI control land on the same parameter messages, so either can drive the
synth at any moment with no special-casing anywhere in the signal path.

**Standalone product, still without RNBO.** Two Max-native export paths
turn this same patch into a product on their own:

- **Build Application** — as in section 10.3, exports a standalone
  Mac/Windows `.app`/`.exe` that runs without a Max license or the Max
  runtime installed.
- **gen~ Export Code** — sending `gen~` the `exportcode` message (or using
  its Export sidebar/attributes) exports the oscillator+filter core as C++
  source, licensed for export use by Cycling '74, which can be compiled
  into a VST/AU or any custom app (e.g. via JUCE). This is the most
  portable path since you end up owning plain C++ source with no Max
  dependency at all.
- **Reimplement the DSP** — the algorithm is documented and
  Python-verified (`docs/verification/`), so it can also be rebuilt from
  scratch in any language, independent of Max entirely, if that's ever
  preferable to either export path.

No iPad target is part of this plan.
