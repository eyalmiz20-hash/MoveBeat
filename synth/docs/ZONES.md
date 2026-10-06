# MoveBeat — Zones (movement → Ableton Live)

This is the specification for the **zone layer**: three regions of space, nine mappable cells,
and the rules that turn a dancing body into Live controls. It was designed in full before any
code was written, and this document is the agreement.

`MAPPING.md` is the older contract — the six-slot matrix that drives the synth's own parameters
over OSC. The zone layer sits **beside** it, not instead of it, and answers a different question:
not "how does movement shape the sound", but "how does movement drive the Live Set".

> **This document reversed a previously documented decision, and the reversal is now complete.**
> `ARCHITECTURE.md` and `BUILD_GUIDE.md` used to state that Ableton and Max for Live were
> deliberately out of scope — true when the synth was a standalone macOS instrument. **Both were
> updated 2026-09-05**, and `synth/build/MoveBeat_ableton_ves.amxd` was resolved: it stays as
> history, never used, as the cautionary example for why devices are generated and never
> hand-edited.
>
> **Both halves became Max for Live devices on 2026-09-05 and were verified playing inside Live** —
> generated from the `.maxpat` sources by `synth/docs/verification/build_devices.py`. So the
> Live-side pieces below are no longer blocked on "M4L does not exist yet."

## Where this runs

Everything in this document lives on the **Mac**, inside Max for Live, inside Live.

The Windows PC is untouched. It still reads the Kinect, still encodes the same OSC bundle, still
broadcasts to port 7400. **Hop 1 is frozen and byte-verified — nothing here changes it.**
`[udpreceive 7400]` works identically inside an `.amxd`.

The governing rule from `CLAUDE.md` still holds: the weak machine does as little as possible, and
every musical decision happens on the Mac where it can be re-tuned live while sound is playing.

### One device, not two

The zone layer lives **inside `MoveBeatController`**, as subpatchers — not as a separate device.

The decision below (a hand in a zone freezes its slot) means the two layers must talk. Splitting
them into separate devices would mean inventing a new inter-device contract to carry one boolean
per hand, which is absurd for the benefit. They also both need the same body-relative coordinate
computation, and two copies of that would drift.

The one argument for splitting — room in Live's device strip — is answered by the floating window
instead (see *Form factor* below).

## Relationship to the six-slot matrix

The two layers read the same joint stream and do different jobs. Neither replaces the other.

```
joint stream (7400)
   |
   +--> 6 slots  --OSC 7500-->  synth parameters      the sound
   |
   +--> 9 cells  --LOM------->  effects + scenes      the Live Set
```

Feet leaving zone logic entirely is a bonus here: they drive the synth and nothing else, so they
can never fire anything by accident.

### A hand inside a zone freezes its slot

Right hand is mapped to `cutoff` by its slot. You reach right to grab an effect fader — and
without this rule `cutoff` sweeps to its extreme on the way there. **Every effect gesture would
smear the synth.**

So: **a hand entering any zone freezes its own slot at its last value**, and it resumes tracking
when the hand leaves. Predictable, and it keeps the two layers from fighting over one limb.

This is the same freeze-on-loss behaviour the tracking gate already uses; only the condition is
new.

## Form factor

Live's device strip is a fixed height of roughly 168 px. Neither device fits it as it stands:

| Device | Presentation mode today |
|---|---|
| `MoveBeatSynth` | exists — 58 objects, 930 x 453 px |
| `MoveBeatController` | **does not exist** — zero objects in presentation |

So both need the same treatment: **a compact strip in Live, plus a floating window** opened from
it holding the full panel. Nine cells, their ranges, and the calibration view cannot live in a
strip under any layout.

The controller is the easier of the two despite having nothing: there is no existing layout to
dismantle, so it can be built for the final form directly.

## The body layer — `[p mb_body]` (built)

Everything in this document is defined against body-relative coordinates, and this is where they
come from. It reads the same joint stream as `mb_sources`, **in parallel, without touching it** —
the verified six-slot path still works in absolute sensor metres and is unchanged.

```
                     handleft  handright  head  spinebase  spineshoulder  trigger
                         |         |        |       |           |           |
   mb_osc_in / mock  ----+---------+--------+-------+-----------+-----------+
                         |
                    [p mb_body]  ->  one list per frame
```

Every position is `(joint - spinebase) / spineLength`. That single choice is what makes zone
boundaries independent of where the performer stands, how tall they are, and how far they are
from the sensor.

### Output contract

One list per frame, read with `zl nth` (position 1 is the trigger dummy — the same idiom
`mb_sources` uses):

| `zl nth` | Value | Units |
|---|---|---|
| 2, 3, 4 | left hand X, Y, Z | body lengths, relative to spinebase |
| 5, 6, 7 | right hand X, Y, Z | body lengths |
| 8 | hand spread | body lengths, 3-D distance between hands |
| 9 | head Y | body lengths — **the ABOVE/side boundary** |
| 10 | body scale | metres (spine length; diagnostics and display) |
| 11 | valid | 1 = body present and all five joints truly tracked |

A hand is in the ABOVE zone when `nth 6 > nth 9` (right) or `nth 3 > nth 9` (left), plus the
hysteresis margin. That comparison is the whole head-height rule.

### Two details that stop it breaking

**The scale is clamped and smoothed.** Spine length is clamped to 0.25–0.7 m and gently filtered.
Unsmoothed it is a divisor with sensor noise in it, and a jump in the divisor would lurch every
mapped parameter at once. Cold start reads at the 0.25 floor and settles over about two seconds —
harmless, since nothing is performing then.

**Every divide is self-guarding.** Each `expr` clamps the divisor with
`(($f3 > 0.2) * $f3 + ($f3 <= 0.2) * 0.5)` rather than relying on a `loadbang` to seed it. This
is the pattern `[p mb_slot]` already uses, and it exists because `loadbang` does not re-fire when
Max re-instantiates objects during editing — the failure that once silently killed the entire
device.

### Verified

`synth/docs/verification/verify_body.py` loads the `.maxpat`, walks the real object graph inside
the subpatcher, and replays it with Max's own message semantics — outlets right-to-left, inlet 0
hot except `gate`. It tests the wiring that exists, so a mis-wired patchline fails it. Run it
from the repo root.

| Test | Result |
|---|---|
| Identical pose at 2.5 m and 3.5 m gives identical coordinates | **PASS** — difference 0.000000 |
| Hand at chest reads below head; hand overhead reads above | **PASS** |
| Spread separates narrow from wide, and is distance-invariant | **PASS** |
| Scale converges on true spine length (0.50 m and 0.62 m) | **PASS** |
| `valid` drops on an inferred joint and on `/mb/tracked` = 0 | **PASS** |
| Cold start with no scale yet produces finite values | **PASS** |

**Not yet run in Max against the live stream.** Structure and arithmetic are verified; the device
has not been opened with a real body in front of the sensor.

## The zone layer — `[p mb_zones]` (built)

Consumes the `mb_body` list, decides which of the nine cells is active, and holds all of the
timing. **No Live objects** — the whole subpatch is testable on the Mac against the mock body.

### Output contract

| Outlet | Carries |
|---|---|
| 0 | nine flags: `abvL abvR abvB  lftL lftR lftB  rgtL rgtR rgtB` (`zl nth 1..9`) |
| 1 | hand-busy pair `L R` — drives the freeze rule on the six-slot matrix |
| 2 | fire-armed, 0/1 |

### The constants, in one place — and that place is now a file

Since **2026-10-06** every number below lives in
`synth/docs/verification/zone_constants.py`, with the reasoning for each beside it. Nothing
else holds a copy: `tune_zones.py` writes them into `[p mb_zones]`, `build_cells.py` bakes the
spans into the cells, and both verification suites assert against the same file.
`verify_zones.py` TEST 0 reads the thresholds back out of the patch and fails if they disagree,
so a forgotten rebuild is loud rather than silent.

| | Enter | Leave | Commit |
|---|---|---|---|
| ABOVE | `head.y + 0.15` | `head.y + 0.00` | **200 ms** |
| SIDE | `\|x\| > 0.75` | `\|x\| > 0.60` | **60 ms** |

Both in body lengths, so they mean the same thing for any performer at any distance. Fire
re-arms 1000 ms after tracking returns.

**The side figures were 1.15 / 1.00 with a 200 ms commit until 2026-10-06.** They changed on the
first report from a performer rather than from a model, and the report was specific: entering a
side zone needed the arm almost horizontal, the knob then travelled only about **0.3** of its
range because the old span chased 1.79 body lengths — a locked-out arm — and the entry felt late.

| What changed | From | To | Why |
|---|---|---|---|
| side enter | 1.15 | **0.75** | the zone itself starts closer in: 16–29° of arm elevation rather than 31–63°, and still clear of a hand hanging at rest (~0.36) |
| side leave | 1.00 | **0.60** | the same 0.15 hysteresis band, moved with it |
| side commit | 200 ms | **60 ms** | ABOVE keeps 200 ms because the scene stepper lives there and a wrong answer skips a section of the piece. A side cell only moves a knob, so it is not worth 200 ms of latency |

### The commit delay is per zone now, and the timer restarts

Worth stating precisely, because it bounds what the shorter side commit can cost. The delay is
re-armed on **every** change of hand count, not started once: so a two-hand entry whose hands land
within 60 ms of each other still never flashes the one-hand cell. Land further apart and the
one-hand cell does go live, for as long as the gap between the hands — and a FADER keeps whatever
it reached. The attack envelope is what makes that survivable rather than ruinous; see below.

### Order inside a frame is load-bearing

`unpack` fires right-to-left, and the graph depends on it: `valid` lands first, then `head.y`,
then each hand's Y (which decides ABOVE), then its X (which decides the sides, masked by ABOVE).
The left hand is last, so every combination downstream is hot on a left-hand value and sees a
fully-settled frame. **Reordering the output list would break this silently** — the flags would
lag by a frame with nothing in the Max console.

> **A bug worth recording, because it looked like correct code.** Each hand's zone test first
> had a `[change]` after it, to avoid re-sending an unchanged state. That is wrong here: the
> combinations are hot on *one* hand's value, so filtering out "no change" meant the right hand
> going up never recomputed anything. Five of nine tests failed. **A state that other logic is
> hot on must re-propagate every frame, even when it has not changed.**

### Verified

`synth/docs/verification/verify_zones.py` replays both real graphs chained together, with a
virtual millisecond clock for `[del]`. **11/11 PASS:**

| Test | Result |
|---|---|
| The patch's own thresholds and delays match `zone_constants.py` | PASS |
| Rest pose activates nothing | PASS |
| One hand up commits at ~200 ms in ABOVE, nothing before | PASS |
| Raising both hands never flashes the one-hand cell | PASS |
| Hand up **and** far left reads ABOVE, never LEFT | PASS |
| Side zone latches, and holds through the hysteresis band | PASS |
| 40 frames of jitter across the threshold → 1 output change | PASS |
| **A side zone commits in 60 ms, not 200** | PASS |
| Losing the body releases every flag | PASS |
| Fire stays blocked for 1 s after tracking returns | PASS |
| Hand-busy pair tracks both hands correctly | PASS |

Every position those tests use is computed from `zone_constants.py` rather than written as a
literal. That is not tidiness: the old suite carried its own copy of 1.15, so it would have passed
unchanged against a patch tuned to anything at all.

**Not yet run in Max.** Structure and behaviour are verified against the real object graph; the
device has not been opened with a live body in front of the sensor.

### Not yet wired: the freeze rule

`mb_zones` emits the hand-busy pair, but **nothing consumes it yet.** Gating the two hand slots
in the six-slot matrix means editing the verified path, and that is deliberately left as its own
step rather than bundled with new work.

## The three zones

```
        ┌─────────────── ABOVE HEAD ───────────────┐
        │                                          │
┌───────┴──────┬──────────────────────┬────────────┴──────┐
│              │                      │                   │
│  LEFT        │   (dance / solo)     │           RIGHT   │
│              │                      │                   │
└──────────────┴──────────────────────┴───────────────────┘
                  Feet: no zones, ever.
```

Feet never enter zone logic. They remain available to the six-slot matrix for continuous synth
control, but they fire nothing and switch nothing.

### The head is the boundary — and this is not arbitrary

**A hand above head height is in the ABOVE zone, regardless of where it is horizontally. A hand
below head height can only be in a side zone.**

Without this rule a hand raised diagonally satisfies "above" *and* "left" simultaneously, and
reaching up-left for an effect would advance the song. That is the one error in this whole
design with no recovery: you cannot un-skip a section in front of an audience.

The rule costs nothing, removes the overlap entirely, and puts the boundary somewhere the
performer can always feel — on their own body.

## The nine cells

Each zone splits by hand state, giving nine independent mappings:

|            | LEFT HAND        | RIGHT HAND       | TWO HANDS            |
|------------|------------------|------------------|----------------------|
| **ABOVE**  | FADER / SWITCH   | FADER / SWITCH   | **FIRE — scene step** |
| **LEFT**   | FADER / SWITCH   | FADER / SWITCH   | FADER / SWITCH       |
| **RIGHT**  | FADER / SWITCH   | FADER / SWITCH   | FADER / SWITCH       |

**Eight cells control parameters. One cell advances the song.** That asymmetry is the whole
design, and it is why this is buildable: eight cells are one subpatcher instantiated eight times,
exactly as `[p mb_slot]` already is six times in the controller.

The structure divides cleanly:

- **ABOVE × two hands → the structure of the piece.**
- **Everything else → the sound of the piece.**

## The three modes

| Mode | Behaviour | On leaving the zone |
|---|---|---|
| **FADER** | Continuous. Movement inside the zone sweeps the parameter. | **Holds** the last value. |
| **SWITCH** | Momentary. In the zone = on. | **Off** — glided, not stepped, since 2026-10-06. |
| **FIRE** | Discrete. Each entry advances the scene stepper. | Nothing. |

Entering any zone is a **glide, not a step** — see *The attack envelope* under Timing.

The asymmetry between FADER and SWITCH is deliberate and coherent: a fader's value is a position
you *set*, a switch is something you *hold*.

### FADER sources

Each FADER cell picks what drives it:

| Source | Meaning |
|---|---|
| `X` / `Y` / `Z` | position along one axis, body-relative |
| `SPREAD` | distance between the hands |

`SPREAD` is the natural default for any **two-hands** cell — opening and closing the arms is a
far more dance-like fader than either hand's absolute position.

### ~~FADER pickup — mandatory, not optional~~ — removed 2026-09-22, and replaced 2026-10-06

~~A fader holds its value when the hand leaves. The next time the hand returns it will be somewhere
arbitrary, and without protection **the parameter jumps.** So the parameter does not move until the
incoming movement **crosses** the held value — exactly Live's own `Pickup` takeover mode.~~

**Pickup was removed** because it latched cells dead: leaving a side zone drags the fader to
exactly 0.00, and "crosses the held value" is then true for no value at all, so the cell died
after one use. CLAUDE.md records the episode.

**But the problem it was there to solve was real,** and removing pickup left it unsolved — the
knob stepped to its new position in one frame on every entry. **The attack envelope (2026-10-06)
is the answer that works:** instead of refusing to move until the movement catches up, the cell
*crossfades* from where the knob was to where the movement says it should be, over `ATTACK` ms.
See **The attack envelope** under Timing. It has no degenerate case, because it is arithmetic over
time rather than a condition that can be true of nothing.

### SWITCH — map the wet, not the bypass

A momentary switch on a device's **on/off** is a hard bypass. Releasing it cuts a reverb or delay
tail dead, mid-decay.

**For anything with a tail, map the SWITCH to the device's Dry/Wet instead of its activator.**
Same gesture, same mapping mechanism, no amputated tail. Hard bypass remains correct for
distortion, filters, and anything without a tail — both routes stay available, and the choice is
per effect.

## The MAP button

**The MAP button behaves exactly like MIDI/Key mapping in Live.**

```
press MAP  →  click something in Live  →  the cell controls it
```

The cell is a controller. It does not know what it is bound to, and nothing in the controller
names a parameter, a device, or a clip. This is what makes the device generic: **it has no
knowledge of the MoveBeat synth, of the Live Set's structure, or of the piece.** It converts
movement into control. Everything else is a click.

That is also what makes it reusable beyond this one performance — and worth building properly
rather than hard-wiring one song.

### Two acquisition paths behind one button

| Mode | LOM mechanism | What you click |
|---|---|---|
| FADER / SWITCH | a **parameter** — `live.remote~` | the knob, fader or button |
| FIRE | a **function call** — `call fire` | a Scene Launch button |

Different code paths, one interaction. The user never sees the difference.

> **Read the reference implementation before writing this.** The MAP button is a standard Max for
> Live idiom, not an invention — Max for Live Essentials (LFO, Envelope Follower, Expression
> Control) ships with Live Suite, and those devices are open and editable. Open one and read how
> it acquires and holds a parameter rather than guessing at `live.remote~`'s contract.
>
> This is the same principle `CLAUDE.md` already applies to `BodyBasics-D2D.exe` on the Kinect
> side: when a working reference exists on disk, read it.

## Input range — the answer to the original complaint

Every FADER cell bounds its **input** span:

```
     raw movement                 your bound              the knob
  ├────────────────────┤      ├─────────┤            ├──────────────┤
 -1m                 +1m      0.2     0.6            0              1
                                ▲       ▲
                                └───────┘  this small movement
                                           sweeps the full knob
```

This is the direct answer to the requirement the whole design started from: *"I shouldn't have to
move my whole leg through space to reach peak movement."* Narrow the input span and a small,
comfortable gesture covers the parameter's full travel.

### ~~Set it by moving, not by typing~~ — there is no SET RANGE button

**Reversed by the build, 2026-09-22.** The zone already fixes how much movement is available, so
the span is **baked into each cell** and there is nothing to calibrate. One fewer control on a
window that had no room for it.

What that costs is written down honestly: the baked span has to be *right*, and nothing on screen
says when it is not. **It was not right.** A cell whose span reaches further than the arm actually
goes normalises to a fraction of 0..1, the knob travels part way and stops, and the only symptom is
"it feels like it is not working". That is precisely what was reported on 2026-10-06, measured at
about **0.3** of the knob's travel.

**The spans as built**, from `zone_constants.py` (body lengths; `lo` is the zone edge, `hi` is as
far as the gesture goes):

| zone | X | Y | Z | SPREAD |
|---|---|---|---|---|
| ABOVE | −1.79 … 1.79 | **1.60 … 2.40** | −1.00 … 1.00 | 1.00 … 3.00 |
| LEFT | **−0.75 … −1.35** | −0.20 … 1.30 | −0.50 … 0.50 | 0.20 … 1.60 |
| RIGHT | **0.75 … 1.35** | −0.20 … 1.30 | −0.50 … 0.50 | 0.20 … 1.60 |

All four side axes changed, not only the one that was reported, because three of them were ABOVE's
figures copied across and **every one of those three was outside the side zone itself**:

- **Y was 1.60 … 2.40** — above the head. A hand that high is in ABOVE by the head rule, so a side
  cell set to Y could never leave the bottom of its span. Dead, silently.
- **SPREAD was 1.00 … 3.00** — two arms opened wide. Both hands are on the *same* side in a side
  zone, so they are never that far apart. `lftB` and `rgtB` **default** to SPREAD, so both two-hand
  side cells were dead on arrival.
- **Z was −1.00 … 1.00** — a full body length of depth, from an arm already committed sideways.

`verify_cells.py` TEST 12 now checks **all four axes of every cell** against the zone that switches
it on, and that a side cell's X span starts *exactly* on the entry threshold so there is no step at
the edge. It was proven to fail on the old numbers.

**ABOVE is deliberately unchanged.** It was not what was reported, and its Y span — the axis anyone
actually uses there — does start at the zone edge. Its X, Z and SPREAD carry the same optimism the
sides did and are the obvious next thing to measure against a dancer.

### The range is stored body-relative

Recorded spans are relative to the body (offset from `spinebase`, normalised by body scale), not
absolute in sensor space. Otherwise half a step sideways destroys the calibration.

This is the same reason the zone boundaries themselves are body-relative, and it is what makes
the whole layer work at any reasonable distance, for any performer.

### There are two ranges, and only one of them is built here

| Range | Where it lives | What it limits |
|---|---|---|
| **Input** | the cell, in this device | how much movement counts as "full" |
| **Output** | the mapping's own Min/Max, in Live | how far the parameter may travel |

Live's mapping already provides the output range. Building a second one here would duplicate it —
exactly the kind of drifting duplicate contract `MAPPING.md` warns about. **Use Live's.**

## The scene stepper

The single FIRE cell — **ABOVE × two hands**.

```
   Session View                        each two-hand raise
  ┌──────────────────┐                 advances one scene
  │  1  intro        │  ◄─────┐
  │  2  verse        │        │
  │  3  chorus       │        │  wraps
  │  ...             │        │
  │  8  outro        │  ──────┘
  └──────────────────┘
```

The current scene loops until the next raise. Reaching the end and raising again returns to the
first scene — so **"restart the piece" is not a separate binding, it is the same one wrapping.**
One of the nine cells stays free as a result.

### ⚠ A scene is a SESSION VIEW ROW — and the grid has to have clips in it

Decoded out of the presentation Set on 2026-10-06: **8 scenes, 88 clip slots, not one clip.** The
song was in the **Arrangement**. The stepper walked all 8 scenes, found every one empty, fired
nothing — exactly as specified and verified — and said nothing, so it looked broken.

This is the premise rather than a detail: **the stepper fires Session scenes.** Live keeps empty
scene rows below the filled ones, which is what lets the piece's length be discovered rather than
configured; a song built in the Arrangement has no scenes to fire at all. And `getcount scenes`
answering **8 when 3 are filled is correct** — the five empty rows are what `is_empty` skips.

Since 2026-10-06 a raise that finds nothing playable writes **`no clips`** into the scene readout
and a sentence into the Max console. Nothing about the walk changed; the silence was the bug. That
is the third time in this project that correct behaviour with no feedback cost real hours — the
mock-`valid` trap and the BODY lamp are the others — and the rule it keeps writing is
**every refusal needs a voice.**

### ⚠ It did not work until 2026-10-06 — `getcount` is a `live.path` method

Reported from Live: **with three scenes, every raise fired the first scene and the song never
advanced.** The build asked `live.object` for `getcount scenes`. There is no such method on
`live.object`; it belongs to **`live.path`**, and Max's refpage states the reply precisely — *"Sends
a `count` message to the right outlet, containing the name of the child and its number of entries"*,
i.e. `count scenes 3` out of **outlet 2**. Live answered nothing, and nothing reached the patch to
say so.

What turned a missing answer into a wrong behaviour rather than no behaviour: **Max's `%` returns 0
for a modulo by zero instead of erroring.** With no count, every candidate was `(k + current) % 0`
= 0 — the first scene, every time. Both halves are now guarded: the modulo carries the no-ternary
zero guard, and `[uzi 0]` means a count that never arrives tries **no** candidates, so the failure
would be an obviously dead stepper instead of a plausible-looking wrong one.

A second bug surfaced while making the test stub honest: the scene ids were read off `live.path`
**outlet 1**, which fires only when the id *changes*. Asking about the same scene twice in a row got
one answer and the second query died silently — invisible with three scenes, **every raise with
one playable scene.** Both reads moved to outlet 0, which answers every `path` message.

> **The reference was on disk, and it was not a device.** CLAUDE.md's rule is "read the reference
> implementation that is already installed". All 139 shipped devices were scanned and **not one uses
> `getcount`** — so the usual reference could not settle it. Max's own refpages could, and did:
> `/Applications/Max.app/Contents/Resources/C74/docs/refpages/m4l-ref/live.path.maxref.xml`. When no
> shipped device uses an API message, that is the signal to go and read, not licence to guess.

### It configures itself

Two decisions already made combine into something better than either:

- **Empty cells are skipped.**
- Live always leaves trailing empty scenes below the ones you filled.

Read the scene list from Live and skip the empty ones, and the stepper **discovers on its own
that the piece is eight sections long.** The number is never configured, never typed, and never
goes stale. Add a ninth section in Live and it is simply there.

> **Never bake in positional numbers.** Resolve by name and by live query, not by index. This
> project has already been bitten three times by numeric contracts that break silently — the OSC
> address table, subpatcher inlets numbered by X position, and the OSC string padding. A
> hardcoded `tracks 3` belongs to the same family: reorder a track and the wrong thing fires,
> with no error anywhere.

### The lockout is musical, not a timer

**A scene cannot advance again until the scene just fired has actually begun playing.** Live
reports this; observe it rather than guessing a millisecond value.

With Global Quantization at 1 bar this gives roughly a full bar of immunity. Lower and raise your
arms quickly and it simply does not count. An accidental double-advance skips an entire section
of the piece in front of an audience, and there is no way back from that — so this guard is worth
more than any other in the document.

## Timing

### The hand-count commit delay

Both hands never enter a zone in the same millisecond. Without a delay, every two-hand raise
fires the one-hand binding on its way.

```
first hand enters  →  do not act
                   →  wait  (200 ms in ABOVE, 60 ms in a side zone)
                   →  count hands in the zone
                   →  1 → that hand's cell    2 → the two-hands cell
```

**Global Quantization makes this free — for the stepper.** Live waits for the next downbeat
regardless, so 200 ms of decision latency before a scene fires is inaudible.

**It is not free for a FADER**, and this document already said so: *"FADER cells have no firing
moment and so need no commit delay; they simply track."* The build ignored that and applied one
delay to all three zones, and a performer felt it immediately — a hand sweeping a filter answered
about a fifth of a second late. **Since 2026-10-06 the delay is per zone:** 200 ms where a wrong
answer advances the song, 60 ms where it moves a knob.

Not zero, because the two-hand side cells (`lftB`, `rgtB`) still need disambiguating, and because
the delay re-arms on every change of hand count — so 60 ms covers any two-hand entry whose hands
land within 60 ms of each other, which is most of them.

### The attack envelope — the glide into a zone

Added **2026-10-06**, on a performer's report: entering a zone *stepped* the parameter, and the
step was audible.

Each cell now crossfades rather than jumping:

```
out = held + env * (target - held)

    held     frozen at whatever the knob had the instant the zone flag changed
    target   the live movement value, FROM..TO as before
    env      0 → 1 over ATTACK ms, on a smoothstep curve
```

`env` runs on its own 20 ms clock (`[line]`, the control-rate `[line~]`), **not** on the frame
rate — a frame-driven envelope stalls the moment frames stop, and in `MOCK - sliders only` frames
stop every time the mouse does. Smoothstep rather than a straight line because a linear ramp has a
corner where it starts and another where it arrives, and both are audible on a filter cutoff.

After the attack `env` is 1 and the output **is** the movement value, bit for bit. **This shapes
the entry, never the tracking.**

`ATTACK` is one control on the mapping window, global to all eight cells, default **250 ms**. It is
the only global control the layer has: an attack time is a feel parameter, no arithmetic settles
it, and baking it in would mean a rebuild and a re-drag into Live per attempt. **`ATTACK 0`
restores the previous instant behaviour exactly**, and a test asserts that it does.

One mechanism, four things it buys:

| | |
|---|---|
| entry | the knob arrives instead of jumping — what was asked for |
| a SWITCH leaving | the release is the same curve in the other direction, so a Dry/Wet switch no longer clicks |
| a FADER leaving | `held` and `target` are set to the same value, so the crossfade has nothing to cross and the output is provably flat |
| the 60 ms side commit | a one-hand cell that flashes for two frames during a two-hand entry slips its knob about **15%** of the way instead of jumping the whole way. Measured, in `verify_cells.py` TEST 19, against the same flash with the envelope switched off |

### Hysteresis and dwell

Every zone boundary is a Schmitt trigger: enter at the boundary, leave only after retreating by a
margin. Plus a minimum dwell before a FIRE cell counts an entry at all. A joint resting on a
boundary at 30 Hz must not chatter.

## Loss of tracking

When the body is lost — the performer steps out of frame, or walks off for a drink of water:

| | |
|---|---|
| **Switches** | released |
| **Faders** | frozen at their last value |
| **FIRE** | blocked |
| **Clips already playing** | keep playing, untouched |

The music continues. Nothing lurches, nothing turns off, nothing advances.

**And on return, FIRE stays blocked for a short grace period** — around a second. Otherwise
walking back into frame through a side zone would advance the song. Pickup handles the faders on
return, so nothing jumps.

This finally answers the `/movebeat/gate` question left open since the beginning: the gate does
not mute and does not fade. It **releases, freezes and blocks.**

> **This is the acceptance test.** Start a session, walk out of frame, wait, walk back in through
> a side zone. The loops must still be playing, no effect may have latched on, no parameter may
> have jumped, and the song must not have advanced. It exercises every rule above at once.

## Distance and framing

Kinect v2 has a fixed **70° × 60°** field of view and — unlike v1 — **no tilt motor.** It is
aimed by hand.

| Distance | Visible width | Visible height |
|---|---|---|
| 2.0 m | 2.8 m | 2.3 m |
| 2.5 m | 3.5 m | 2.9 m |
| 3.0 m | 4.2 m | 3.5 m |

Two constraints fight each other: raised hands reach about 2.2 m and must stay in frame, while
the feet must also stay in frame for full-body tracking. Raising the sensor helps the first and
hurts the second. They balance at a sensor height of roughly **1.15 m**, with the performer at
**2.0 m** — and allowing room to actually move, **2.5–3.0 m** is the working distance.

### But do not measure with a tape

Two reasons the numbers above matter less than they look:

1. **Everything here is body-relative.** "Hand above head" is `handY > headY` — distance-free.
   "Hand at the left extreme" is a fraction of your own reach — distance-free. The only remaining
   requirement is that your extremes stay inside the frustum.

2. **The controller can just tell you.** The Kinect reports `trackingState` per joint, and a
   joint outside the frustum stops reading `2`. So a calibration mode — stand where you will
   dance, hit `CALIBRATE`, reach to every extreme — can flag in red exactly which joint left the
   frame, and record your true reach at the same time.

That gives the warning ("your hands leave frame when raised — step back") and the range
calibration in one pass, and it works for any performer in any room.

`DepthBasics-D2D.exe` on the PC remains the ground truth for what the sensor is actually pointed
at. Per `CLAUDE.md`: check framing and distance **first**, before suspecting code.

## A performance risk in the capture app

Found while working through the "walked away" scenario. `MoveBeat/Program.cs` selects the body
like this:

```csharp
for (int i = 0; i < bodies.Length; i++)
    if (bodies[i] != null && bodies[i].IsTracked)
    { trackedBody = bodies[i]; break; }   // the first one found
```

Kinect v2 tracks **up to six bodies**, and the body index is neither stable nor ordered by
anything meaningful. **Someone walking behind the performer can take over the stream mid-piece** —
or claim the slot while the performer is briefly out of frame.

This has never shown up because testing has been one person alone in a room. In performance it is
exactly what will happen.

The fix belongs on the PC, and that is consistent with the governing rule: *musical* computation
must not live on the weak machine, but "which body is the subject" is a capture question, not a
musical one. The rule: **lock onto a body and hold it until genuinely lost; when re-selecting,
prefer the one nearest the centre.** It does not touch the OSC contract.

## What this replaces, and what it might retire

The zone layer makes the controller a **generic movement control surface for Live**. That has a
consequence worth stating plainly, because it was not the goal and fell out anyway:

If the synth becomes a Max for Live device with `live.*` parameters, then the synth is simply
another plugin the MAP button can point at — including from the six-slot matrix. In that world
the hop-2 OSC contract (`/movebeat/<name>` on port 7500, and the 24-row range table behind it) is
no longer needed: LOM parameters carry their own ranges.

**That is not a reason to do it now.** Hop 2 is built and verified, it works unchanged inside an
`.amxd`, and replacing verified work in the same breath as writing new work is how a project
loses the ability to tell which half is broken. Convert the devices first, get the chain running
inside Live, and revisit this afterwards.

## Still open

- **The side numbers are better, not measured.** 0.75 / 0.60 and a 0.75 … 1.35 span were chosen
  from the one real report there has been, plus anatomy. The model predicted the old spans wasted
  about a third of the knob's travel; the performer measured two thirds — so **the model is not to
  be trusted to two decimal places, and the dancer is.** One line in
  `synth/docs/verification/zone_constants.py`, then the three rebuild commands at the top of it.
- **ABOVE's X, Z and SPREAD spans have not been revisited.** Same class of problem as the side
  ones that were just fixed; nobody has reported it because nobody has used those axes there yet.
- **What `ATTACK` should actually be.** 250 ms is a starting point. It trades against the 60 ms
  side commit: a longer attack makes a brief flash cost less and makes a deliberate entry feel
  slower. Both are on screen, so this is now tuneable while dancing rather than at build time.
- **What one hand above the head maps to in practice.** The cells exist and take any parameter;
  which effect goes there is a musical choice, not a build decision.
- **Whether the synth's parameters migrate from OSC to `live.remote~`.** Deferred deliberately —
  see above. The prize is that a danced performance becomes recordable and editable as Live
  automation, which is a real argument for eventually doing it.
- ~~`ARCHITECTURE.md` and `BUILD_GUIDE.md` still say Ableton is out of scope, and
  `MoveBeat_ableton_ves.amxd` is an unresolved divergent fork.~~ **Both closed 2026-09-05.**
