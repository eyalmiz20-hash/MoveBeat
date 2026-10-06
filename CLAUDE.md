# MoveBeat

Final thesis project: movement to sound. A Kinect v2 tracks a body; the coordinates drive a virtual-analog synthesizer.

---

## The project book — section 3.3.6 was rewritten 2026-10-06

**The three reversals are now IN the book and the SET RANGE control is gone from the text.**
The device and the chapter agree again, so there is no standing warning to give at the start of
a session any more. What the chapter gained, and why, is kept in "FINISHING THE BOOK" below —
the reasoning is worth keeping even though the writing is done. **Still outstanding there: the
five screenshots and the three Chapter 4 entries.**

---

## ▶ 2026-10-06 (evening) — THE JITTER AND THE CLICKS — written up for the chapter

**Status: the user ran it in Live and reports everything working.** Two faults were found and
fixed in one session, on two different machines, and the session is worth a chapter of its own
because **almost all of the work was ruling things out, and the thing that was finally wrong was
invisible to a test suite that printed 99/99.** The headings below are a chapter skeleton; the
detail for each lives in the sections further down this file and is cross-referenced.

### 1. What was reported

Two complaints, a few hours apart, and treating them as one problem would have been a mistake:

| Reported | What it turned out to be |
|---|---|
| "a bit of jitter in the packet transfer which ruins the flow of the composition" | **not the packet transfer at all** — a ramp inside the mapper that was shorter than the gap between camera frames |
| "audio clicks and bops" | the capture app changing which *body* it was following, mid-performance |

**Jitter and a click are different faults.** A click is a discontinuity; jitter is an uneven rate.
Keeping them apart is what made both findable. The performer's two sentences were the only
symptom data available, and each pointed at a different machine.

### 2. The method: measure the artefact, and say what the measurement does NOT settle

Three Sonnet research agents ran in parallel — Max/M4L timing from the installed refpages, a
graph-walk of the controller's per-frame hot path, and a measurement protocol — while the live
system was decoded directly: Live's own `Log.txt`, the `.als`, Live's `Preferences.cfg`, and the
4 MB `.maxpat` JSON. **Not one conclusion below came from reasoning about what the code should do.**

Two of the three agents had to be overruled, which is itself worth writing down:

- One proposed `udpreceive @defer 1` as "the low-risk fix for jitter", quoting the refpage
  correctly — *"especially in Max for Live, this can reduce the chances of audio glitches and
  dropouts."* **That sentence is about glitches, not about timing**, and deferring moves the
  mapping onto the low-priority queue, which is throttled and contends with GUI redraw. It could
  plausibly make jitter *worse*. **Not applied.** Still unapplied, and still a legitimate A/B.
- Another proposed toggling Live's "Scheduler in Audio Interrupt" and re-measuring. **That
  experiment cannot be run**: in M4L, Overdrive and SIAI are always on, the signal vector is
  hardcoded at 64, and none of it is changeable (Cycling '74 staff, confirmed three ways). The
  first agent had already established this. **An agent's report is evidence, not a verdict** —
  the same rule this file already states about reference implementations.

### 3. What measurement RULED OUT — which was nearly everything

This is the most useful table in the session, because every row was a plausible theory that cost
nothing to kill:

| Suspected | Verdict | The measurement |
|---|---|---|
| Too much per-frame work in the mapper | **exonerated** | ~386 object evaluations per frame ≈ 10–12k/s. Max's own docs put the risky regime 2–3 orders of magnitude higher |
| Live dropping or starving events | **exonerated** | Live's `Log.txt`, every run that day: **zero failures** in every bucket, including `Max Remote Automation Events` 0/5041 |
| Audio buffer too large | **exonerated** | 128 samples / 44.1 kHz, 6.05 ms round trip; and M4L's vector is fixed at 64 (~1.45 ms) regardless — far finer than a 33 ms frame |
| Max's scheduler settings | **not tunable** | there is no preference to fix inside a device |
| Two devices fighting over a port | **exonerated for this Set** | the `.als` has exactly one controller and one synth |
| CPU contention from a heavy Set | **exonerated** | Vital and UADx Ravel Grand Piano are both loaded, and Live still recorded no failures |

**The chapter's point: "make it more efficient" was the wrong request, and the measurements said
so before any code changed.** The mapper was never short of CPU. The fault was in *timing*.

### 4. A wrong turn, recorded — the obvious optimisation was worse

The synth's 24 parameters are real Live device parameters, so the obvious move was to delete the
localhost UDP hop and drive them from the controller with `live.remote~` — the mechanism the eight
zone cells already use. **It was proposed, then withdrawn after reading the patch**, for two
reasons that only the artefact could give:

- `[p mb_ctrl_in]` feeds `[poly~ mb_voice 8]` **directly**, bypassing the 24 `live.numbox`
  parameters entirely. The "optimisation" would have *added* a Live-parameter hop where the value
  already goes straight to the DSP.
- `live.remote~` **seizes** a parameter — *"a parameter is disabled in Live while it is controlled
  by a live.remote~."* All six mapped knobs would have frozen on the synth panel.

**The faster-looking path was the slower one, and it cost a feature.** Worth a paragraph: an
architecture diagram tells you what connects to what, not which way the data actually goes.

### 5. Fault one — the jitter was a flat spot, and it was one number

A cell sends `[pack 0. 20]` → `[line~]` → `[live.remote~]`: every frame hands `line~` a target
**and a time to get there in**. The camera delivers a frame every **31–38 ms** (26–32 Hz). The ramp
was **20 ms**, so it *arrived* and then **sat flat for 11–18 ms**.

So the output was a staircase with a ramped riser and **a flat tread whose length wobbled by about
a third, in step with the camera**. At constant arm speed the parameter still moved unevenly. That
is the whole fault. Fixed by `OUTPUT_RAMP_MS = 40.0` in `zone_constants.py` — just past the 38 ms
worst case, so consecutive ramps overlap and no flat spot remains.

**A side effect worth a sentence in the chapter: overlapping ramps CONVERGE rather than land.**
Each frame re-aims the ramp before it finishes, so the output approaches the target geometrically
instead of hitting it — which is exactly what removes the steps, and which forced two existing
tests to be rewritten to assert convergence *and* exact landing once frames stop.

### 6. Fault two — the suite could not see the thing that was wrong (the FIFTH instance)

`verify_cells.py` modelled `[line~]` as a **pass-through**: it took the ramp target and dropped the
ramp *time*. Consequences, none of which appeared as a failing test:

- the suite could never see the output ramp, so **"99/99" was never evidence about smoothness** —
  the property most of the zone layer exists to provide
- the ramp length was **unguarded at any value**
- it **certified a false claim** — "ATTACK 0 restores the previous instant behaviour exactly" was
  an artefact of the pass-through; the device never did it

**This is the fifth instance of the same failure mode in this project and the first in the model of
MAX rather than of Live**, which retires the fourth instance's comfortable conclusion. The rule now
reads: *the weak point is every boundary the model simplifies in order to be a model, and a comment
admitting the simplification is not a mitigation.* Full write-up under "A FIFTH TIME" below.

**The order of work is the lesson: the measurement was fixed first, before the device.** Only then
could the fix be demonstrated at all.

### 7. Fault three — the clicks: losing the body was guarded, swapping it was not

`Program.cs` took the first tracked body in the array and broke out of the loop. Kinect v2 fills
that array by an index that is **neither stable nor meaningfully ordered**, so the moment anything
else tracks — a reflection, someone walking behind the performer — the stream can change body
between frames.

**The asymmetry is the finding, and it generalises past this project:** losing the body was already
carefully guarded (`/mb/tracked 0`, faders hold, switches release), while *swapping* the body was
not guarded at all — `/mb/tracked` stays 1 throughout, so the receiver cannot tell and faithfully
maps the discontinuity. **A guard that covers the obvious failure can make its neighbour invisible.**
Fixed by locking onto a `TrackingId`, preferring the body nearest the sensor's centre line when
re-choosing. This file had predicted it in the known-issues list and left it unfixed.

### 8. The C# got its first test, ever — and the test improved the code

`Program.cs` only builds on the PC (net48, `Microsoft.Kinect.dll` by absolute path), so it had
never had a test of any kind. But the body-selection rule depends on nothing except the array of
bodies — so the Kinect API surface it touches was **stubbed on the Mac** and the **real frame
handler** driven through it. `tools/mac/verify-body-lock/run.sh`, **6/6**.

Two things the chapter should say about it:

- **It found a structural fault.** The lock release sat *after* the `osc == null` shutdown check,
  so who the app followed depended on the state of the socket. Writing the test is what exposed it.
- **It is kept out of `MoveBeat/` deliberately.** `MoveBeat.csproj` globs `**/*.cs`, so the stub
  would collide with the real Kinect types and the test would be a second entry point: the PC
  build would fail, and the auto-updater with it. **A test that breaks the build it protects is
  worse than no test.**

### 9. Both new tests were proven able to fail

The project's own standard, and this session produced the two cleanest examples in it:

| Test | Proven to fail by | What it printed |
|---|---|---|
| the ramp is live for the whole worst-case frame gap | reverting to the old 20 ms | **`moving 20 of 38 ms`** — the flat spot, measured |
| a newcomer may not steal the stream | removing the lock lookup | `following 9` instead of `7` — the pop, on demand |

**`moving 20 of 38 ms` is the single best figure the session produced** — it is the fault stated as
a number, from a test, and it is the sixth screenshot this file already asks for.

### 10. The numbers, for the chapter

99/99 → **105/105** cell tests · **6/6** on the PC's body lock, from zero · ~386 object evaluations
per frame ≈ 10–12k/s (exonerated) · ramp 20 ms → **40 ms** against a 31–38 ms frame gap · frame
interval varies **±10%** · flat tread was **11–18 ms**, i.e. up to **47% of every frame** ·
8 cells changed, **0 patchlines** · 3 agents, 2 overruled · **zero** Live event-buffer failures

### 11. What was deliberately NOT done, and why — this belongs in Chapter 4

Stating the costed, declined work is stronger than listing what was built:

- **`mb_sources` computes all 26 `scale`/`clip` branches every frame** regardless of which ≤6 are
  selected; each slot's `pow()` runs *before* its gate; a SWITCH still pays the whole FADER chain.
  All real. All declined: `mb_sources` and `mb_slot` have **zero test coverage and no generator**,
  so any change is a hand-edit of 4 MB of JSON in the busiest code — to buy CPU already measured as
  not the problem.
- **`[change]` on the hand-busy pair**, which re-emits every frame ungated. The one place `[change]`
  is provably safe here — and still declined, because `build_zone_layer.py` is not idempotent and
  cannot be re-run, so there is no regeneration path.
- **Joint-coordinate smoothing**, for the residual sensor noise. Belongs on the Mac by the
  weak-machine rule; the 40 ms ramp already low-passes the zone path.
- **`udpreceive @defer 1`** — see §2.

### 12. Five things worth saying in the chapter

1. **"Make it faster" was the wrong diagnosis, and measurement said so before any code changed.**
   The mapper had CPU to spare by two orders of magnitude. The fault was one ramp being shorter
   than the interval it had to cover.
2. **Fix the instrument before the thing it measures.** The ramp could not be shown to be wrong
   until the harness stopped pretending ramps were instantaneous. Five instances now say the same.
3. **A guard can hide its own neighbour.** Loss of tracking was handled with care; the body
   *changing identity* was not handled at all, and the careful guard is part of why nobody looked.
4. **The obvious optimisation was slower and cost a feature** — and only the artefact said so.
5. **A test proven able to fail is worth more than a green suite**, and both of this session's
   produce a number you can print: `moving 20 of 38 ms`, and `following 9 instead of 7`.

---

## ▶ THE USER'S PLAN FROM HERE (agreed 2026-09-22, end of session)

1. **Test the whole zone layer in Live.** Nothing in it has been watched running.
2. **Build the Live Set for the presentation** — music production, the user's own work.
3. **Finish the book.**

Everything below serves those three, in order.

## ▶ THE LIVE TEST — mostly done now, but read what is still unconfirmed

> **2026-10-06, evening — the user ran it in Live and reports everything working.** That retires
> the old banner here ("nothing in the zone layer has ever been watched running"), which was true
> until this date. The jitter the performer reported is gone after the ramp fix (`OUTPUT_RAMP_MS`,
> see the chapter section at the top of this file), and the clicks after the body lock on the PC.
>
> **Be precise about what that does and does not cover**, because "everything works" is a
> performer's report on the things they exercised, not a sweep of the checklist below. Still
> **never confirmed end to end**, and still worth walking through:
>
> | | |
> |---|---|
> | **a mapping surviving save → close → reopen** | step 8 below. Never confirmed, and `ATTACK` is a new Live parameter that has to come back with them |
> | **the stepper walking a whole piece** | step 9. One advance was seen, then the lockout stuck; the fix is tested and was not watched running. Do it with the transport **stopped** as well as running |
> | **the acceptance test from ZONES.md** | step 10. Walk out of frame, wait, walk back in through a side zone |
> | **side zones latching while standing still** | step 6. The risk swapped direction when `SIDE_ENTER` moved to 0.75 and nobody has stood still in front of it for long |
> | **ABOVE's X, Z and SPREAD spans** | never revisited, same class of error as the side spans that were wrong until 2026-10-06 |

It was proven against a model of Max and a stubbed Live Set first. **Expect the remaining items to
find things; that is what they are for.**

### Before you start

| | |
|---|---|
| Re-drag `MoveBeatController.amxd` | Live uses its own imported copy. The single most likely reason a change appears to do nothing |
| `Input` → **MOCK - sliders only** | A freshly dragged device resets this to **LIVE**, and in LIVE with no camera `valid` is 0 and **nothing can move** |
| **The BODY lamp must be lit** | Bottom row of the device panel. Dark = no body = nothing will happen, however far you drag |
| Global Quantization → **1 Bar** | The stepper's lockout is about a bar of immunity at this setting. The Set already reads 1 Bar |
| **Clips in the SESSION grid** | Scenes are Session View rows. The saved Set has 8 scenes and **no clips** — its song is in the Arrangement, so the stepper has nothing it may fire. It now says `no clips` when that is the case |
| **Only one `MoveBeatSynth` in the Set** | The saved Set has two (`1-MoveBeatSynth`, `5-MoveBeatSynth`). `udpreceive 7500` cannot bind twice and the second fails silently |

### The order to test in

1. **A cell, end to end.** Open `ZONE MAPPING`. Press `MAP` on LEFT SIDE × L hand, click a knob
   on an audio effect. The name appears in the cell *and* in the device panel's bottom row, and
   the button releases itself. Drag `left hand X` left: the lamp lights at **−0.75 body lengths**
   and the readout runs 0.00 → 1.00 by **−1.35**, with the knob following.
2. **The two things 2026-10-06 changed — check these first, they are what was asked for.**
   - **The zone starts closer in and the whole knob is usable.** The readout must reach a clean
     1.00 at a comfortable arm position, not only at full stretch. If it still tops out partway,
     the span is still too optimistic: lower `SPANS['LEFT'][0][1]` in `zone_constants.py` and
     re-run the three commands. That is the one number to turn.
   - **`ATTACK` (bottom of the mapping window, 250 ms).** Set it to 0 and the knob snaps on entry —
     the old behaviour. Put it back and it glides in. Try 600 ms for an obvious one, then settle.
3. **FROM / TO.** Set 20 and 60. The knob must never leave that band.
4. **Leave and return.** Drag out of the zone — the knob holds, and keeps holding. Drag back — it
   glides to the new position over `ATTACK` rather than jumping. (There is no pickup; it was
   removed 2026-09-22 and the attack envelope replaced what it was for.)
5. **SWITCH.** Same two ends: TO in the zone, FROM on leaving — both glided now, which is the
   point of mapping it to a Dry/Wet rather than a bypass.
6. **A side zone must not latch while you stand still.** The new risk, and the opposite of the old
   one: 0.75 is much closer in than 1.15. Stand normally, move naturally without meaning to enter a
   zone, and watch the two side lamps. If they flicker, raise `SIDE_ENTER`.
7. **`×` clears a mapping**, and the knob returns to Live's control.
8. **Save the Set, close Live, reopen.** Every mapping must come back — and `ATTACK` with them, as
   a new Live parameter. **Never confirmed.**
9. **The stepper** — this is the one that was broken *twice*, so check it in this order.
   - **It was rebuilt again on 2026-10-06 (second round): the raise now crosses `[deferlow]` onto
     Live's main thread.** Before that it fired **nothing at all** from a real body or from the
     mock auto-motion, because Live defers every API reply and the scene count came back after the
     walk. **So re-drag the device — a Set loaded before that rebuild still runs the dead one.**
   - **FIRST: are there clips in the SESSION grid?** Scenes are Session View rows. The
     presentation Set as saved on 2026-09-21 had **8 scenes and zero clips** — the song was in the
     Arrangement — so the stepper had nothing it was allowed to fire. If the readout says
     **`no clips`**, that is the device telling you this, and no amount of raising will help until
     there are clips in the grid.
   - **The scene readout shows `scene / count` with Live's own row numbers**, e.g. `2 / 8`. The
     count is every scene row in the Set, filled or not — **8 with 3 filled is correct**, because
     Live keeps the empty rows and the stepper skips them. Only `0` means `getcount` is broken.
     **If the count is `0`, `getcount` is not answering and nothing else about the stepper will
     work** — that was the 2026-10-06 bug and the readout is the five-second check for it.
   - Session View with, say, four filled scenes and Live's trailing empties. Raise both hands:
     scene 1 fires and the lock lamp lights. Raise again immediately: **nothing happens.** Once
     the scene is playing, the next raise advances. After the last filled scene it wraps to the
     first.
   - **Watch how the lock lamp clears.** It should go out when the scene actually starts — within
     a bar at Global Quantization 1 Bar. If it stays lit for a full **8 seconds** every time, the
     `is_triggered` observer is not reporting and the failsafe timer is doing the unlocking
     instead; the guard is then a timer, which is exactly what it was designed not to be.
   - **Open the Max console once** while testing this. The stepper now prints a full sentence when
     a raise finds no scene with a clip, which is the one failure that otherwise looks identical to
     a dead device.
   - Try it with **one** filled scene too. Every raise must re-fire that scene. (That case is
     `verify_cells.py` TEST 29 — it is where live.path's outlet 1 used to die silently.)
10. **The acceptance test from ZONES.md.** Walk out of frame, wait, walk back in through a side
   zone: loops still playing, no effect latched, no parameter jumped, **the song not advanced.**

### If something does not work

The order that has actually paid off, three times today: check `Input` and the BODY lamp, then
read the value readout in the cell (a constant means the movement span does not overlap the
zone), then open the Max console. The five-second checks first.

## ▶ FINISHING THE BOOK — what to write, and what to photograph

The device is finished; the chapter describing it is not. Work through this list.

### ~~Text to change~~ — section 3.3.6 — **DONE 2026-10-06**

Three statements in the old text were wrong. All three are now corrected in the book and the
SET RANGE control is gone from it. **The table is kept because the reasons are the content** —
each correction is only interesting if the chapter says what forced it.

| Replace | With, in a sentence or two |
|---|---|
| the **SET RANGE** button and the per-cell input range | The zone already fixes how much movement is available, so the span is baked into each cell and there is nothing to calibrate. One fewer control on screen. **And then say what that cost**: the baked span has to be right, nothing on screen says when it is not, and the first numbers (a side zone from 1.15 to 1.79 body lengths) were wrong enough that the knob used the lower 0.3 of its range. Revised 2026-10-06 to 0.75 … 1.35. The honest version of this paragraph is the more interesting one. |
| "Live's mapping already provides the output range — use Live's" | True of a MIDI mapping, false of `live.remote~`: it seizes the parameter and drives it from a bare 0..1 signal, and there is **no Min/Max anywhere in Live** for it. The cell therefore carries `FROM %` / `TO %`. Ableton hit the same wall — their own abstraction is called `Abl.MapWithScaledOuput.maxpat` and runs `[clip~ 0. 1.]` → `[scale~ 0. 1. 0. 1.]` → `[live.remote~]`. |
| **FADER pickup is mandatory** | Removed. It latched cells permanently: leaving a side zone drags the fader to exactly 0.00, and "release when the movement crosses the held value" is then true for no value at all, so the cell died after one use. Moved to Chapter 4. |

### Text to add — two paragraphs worth having

Both are episodes, which is what makes a methods chapter specific rather than generic.

- **"Read the reference implementation" has a failure mode.** The plan said to read Max for Live
  Essentials' LFO. In Live 12 that device is **encrypted** — 25 of 139 stock devices are. The
  method survived only because two other shipped devices (`Step Arp`, `Vector Map`) turned out to
  be readable and carried the same abstraction. The advice was right; the specific artefact was
  not, and the difference is worth a paragraph.
- **A lenient test stub certifies a broken patch.** `verify_cells.py` reported **29/29 while the
  device could not map anything at all in Live**, because the stub accepted a bare number where
  Live needs the whole `id <n>` message. Making the stubs strict — an unset `live.object` now
  answers nothing — drops the broken build to 22/24. This belongs next to the existing
  "state the limit too, and mean it" paragraph: it is the sharpest example in the project of the
  replay method certifying something untrue.

### Chapter 4 — future work gained three entries

1. **FADER pickup**, with the clip-edge latch explained — it is a good example of a guard whose
   degenerate case is invisible in the arithmetic.
2. **Name verification on restore.** A mapping is stored as a positional path
   (`live_set tracks 0 devices 0 parameters 3`). Delete an effect, put another in the same slot,
   and the path still resolves — it binds to whatever is there now, silently. Storing the
   parameter's name alongside the path and checking it on load would close this.
3. **The freeze rule** (a hand in a zone freezes its six-slot row) — still emitted by `mb_zones`
   and still consumed by nothing.

### Screenshots — five, and what each is for

Take them **after** the Live test, with a real Set loaded so nothing on screen is empty.

| # | What | How | Caption should say |
|---|---|---|---|
| 1 | **The device panel**, 454 × 168 | The controller in the Live device strip, with a mapping made and the BODY lamp lit | that the whole device is this small, and that the bottom row reports what is mapped and whether a body is present |
| 2 | **The mapping window**, 526 × 309 | Press `ZONE MAPPING`. Have three or four cells mapped to real effects so the names are readable | that it is the book's own table made literal: three zones down, left hand / right hand / both hands across |
| 3 | **One cell, close up** | Crop from #2 | the four controls — MAP with its name and `×`, mode, source, FROM/TO — and that this is the whole interface |
| 4 | **The stepper mid-lockout** | Raise both hands, photograph while the lock lamp is lit and the scene readout shows e.g. `2 / 8` | that the lock is Live's own report of the scene starting, not a timer |
| 5 | **A verification run** | `python3 synth/docs/verification/verify_cells.py` in a terminal, the tail showing `105/105 PASS` | what the replay method actually produces — and it pairs with the "lenient stub" paragraph |

Worth a sixth if there is room: **the negative test**. Delete the lockout gate, rebuild, and show
`five more raises while locked do nothing   FAIL   [0, 1, 2, 3, 0, 1]`. A test that has been
proven able to fail is worth more than a page of green ticks, and this one shows the exact failure
the design exists to prevent.

### The numbers, for when the text needs them

~26–32 Hz capture · 1144-byte OSC bundle · 25 joints · 24 synth parameters · 6 mapping slots ·
9 zone cells (8 parameters + 1 stepper) · 89 Live device parameters · **7/7 + 11/11 + 105/105
behaviour tests** (+ **6/6** on the PC's body lock) · 139 stock devices decoded, 25 of them encrypted · 4 builders, all idempotent

## ▶ THE ZONE MAPPING LAYER — built 2026-09-22

**Deadline:** the book goes to the supervisor around 2026-10-05; presentation 2026-10-20.

**The zone layer is complete.** The eight parameter cells, the MAP button, the mapping window and
the scene stepper are all built and verified: `verify_cells.py` replays the real `[p mb_cell]` and
`[p mb_stepper]` graphs, **105/105**; `verify_zones.py` **11/11**; `verify_body.py` **7/7**.

**It has now been run in Live once, and that produced the 2026-10-06 revision below.**

### ⚠ THE REBUILD IS THREE COMMANDS NOW, NOT TWO

`tune_zones.py` is new and comes **first**. Regenerate, never hand-edit:

```
python3 synth/docs/verification/tune_zones.py
python3 synth/docs/verification/build_cells.py abvL abvR lftL lftR lftB rgtL rgtR rgtB
python3 synth/docs/verification/build_devices.py
```

All three are idempotent — run them twice and the bytes are identical. If you forget the first one,
`verify_zones.py` **TEST 0 fails** and names the command, because it compares the patch's own
thresholds against `zone_constants.py` rather than against a copy of its own.

### ▶ 2026-10-06 — the zone geometry and timing moved into one file

`synth/docs/verification/zone_constants.py` is now **the** source for every zone threshold, delay
and span, with the reasoning for each number beside it. Until then the same figures sat in five
files — the two builders and both verification suites — and the suites asserted against their own
copies, so missing a file would have produced green ticks against the wrong device.

| | was | now | why |
|---|---|---|---|
| side zone enter | 1.15 | **0.75** | reported from Live: entry needed the arm almost horizontal |
| side zone leave | 1.00 | **0.60** | same 0.15 hysteresis band, moved with it |
| side commit delay | 200 ms | **60 ms** | ABOVE keeps 200 ms (it fires scenes); a side cell only moves a knob |
| side X span | 1.15 … 1.79 | **0.75 … 1.35** | 1.79 is a locked-out arm. Chasing it is why the knob used the lower **0.3** of its range |
| side Y / Z / SPREAD spans | ABOVE's figures | **revised** | all three lay *outside* the side zone — see the span table below |
| entering a zone | a one-frame step | **a 250 ms glide** | the new ATTACK envelope |

**The report behind this is a performer's, not a model's**, and that matters: the arithmetic in
`zone_constants.py` predicts the old spans wasted about a third of the knob's travel; dancing in
front of the sensor measured two thirds. When the two disagree, the dancer is right.

### ⚠ Three things the book says that the build had to reverse

**These are design decisions taken against the book, each forced by measurement. Chapter 3.3.6
needs updating for all three.**

| The book says | What was built, and why |
|---|---|
| **SET RANGE** — a button per cell that learns the movement span | **Removed.** The span is fixed by the zone itself and is baked into each cell. There is nothing left to calibrate, and one fewer control — but the span then has to be *right*, and the first set was not: see the 2026-10-06 revision below. |
| **Input range** in the cell; **output range** is "Live's own mapping Min/Max" | **Reversed — the cell now carries the OUTPUT range (FROM % / TO %).** ZONES.md's claim is true of a MIDI mapping and false of `live.remote~`, which seizes the parameter and drives it from a bare 0..1 signal with **no Min/Max anywhere in Live**. Ableton hit the same wall: their own abstraction runs `[clip~ 0. 1.]` → `[scale~ 0. 1. 0. 1.]` → `[live.remote~]` with the scale's range inlets fed from two `[/ 100.]`, and the file is called **`Abl.MapWithScaledOuput.maxpat`**. |
| **FADER pickup** — "mandatory" | **Removed**, at the user's decision on 2026-09-22, after it locked cells dead twice in Live. Moved to Chapter 4 as future work. See the trap below — the failure is not obvious and is worth writing up. |

### What a cell is now — four controls

```
MAP  ‹mapped name›  ×        press MAP, click a knob in Live.  × clears it.
FADER|SWITCH   X|Y|Z|SPREAD     mode, and which axis drives it
FROM %          TO %            where the knob sits on entering, and at full extension
```

- hand enters the zone → the knob **glides to** FROM; arm fully extended → **TO**
- FROM above TO simply inverts the direction
- leaving the zone: a FADER **holds**, a SWITCH glides back to **FROM**
- a SWITCH is the same two ends, so it can be a Dry/Wet between 15% and 85% rather than a hard 0/1

### The ATTACK envelope — the one control that is global, added 2026-10-06

Entering a zone used to **step** the knob to FROM in a single frame, and the step was audible. Each
cell now crossfades:

```
out = held + env * (target - held)

    held     frozen at whatever the knob had the instant the zone flag changed
    target   the live movement value, FROM..TO as before
    env      0 -> 1 over ATTACK ms, smoothstep - flat at both ends, no corner either side
```

After the attack `env` is 1 and the output **is** the movement value. **It shapes the entry, never
the tracking.** `ATTACK 0` switches the **envelope** off — but not the output ramp, and the
difference matters. **Corrected 2026-10-06:** this file used to say ATTACK 0 "restores the
previous instant behaviour exactly, and a test asserts it." The test asserted it and the device
never did it. A cell's value has always reached Live through `[pack 0. OUTPUT_RAMP_MS]` →
`[line~]`, so there has always been an output ramp underneath the envelope — and the test passed
only because `verify_cells.py` modelled `[line~]` as a **pass-through** and so could not see the
ramp at all. ATTACK 0 means no attack; the output still ramps, and that one is not optional.

Three details worth keeping:

- **`env` rides `[line]`, the control-rate `[line~]`, on its own 20 ms clock — not the frame rate.**
  A frame-driven envelope stalls the moment frames stop, and in `MOCK - sliders only` frames stop
  every time the mouse does: the attack would freeze half-finished exactly while you were testing it.
- **It is a crossfade, so it cannot overshoot.** `out` is always between two values that are
  themselves inside FROM..TO. No `clip` to add and none to forget.
- **The same mechanism does three other jobs for free.** A SWITCH's release is the same curve in the
  other direction, so a Dry/Wet no longer clicks. A FADER leaving has `held` and `target` set to the
  *same* value, so the output is provably flat. And a cell that flashes for two frames during a
  two-hand entry slips its knob about **15%** instead of jumping the whole way — which is what made
  the 60 ms side commit affordable. `verify_cells.py` TEST 19 measures that against the same flash
  with the envelope switched off.

**ATTACK is one Live parameter on the mapping window, global to all eight cells, default 250 ms.**
Global and not per cell because the window has no room for eight more; a control at all rather than
a baked constant because an attack time is a feel parameter and baking it in would mean a rebuild,
a re-drag into Live and a restart per attempt.

> **One behaviour changed, and it is worth knowing.** A FADER outside its zone now keeps *sending*
> its held value instead of sending nothing — `[line]` runs for ATTACK ms after every transition and
> the frame still re-evaluates the blend. The value is provably unchanged (TEST 4 asserts exactly
> that, where it used to assert "nothing is sent"), the traffic is control-rate into a `[line~]` and
> never reaches Live's object model, and `live.remote~` was already writing every sample regardless.

Per-cell movement spans, from `SPANS` in **`zone_constants.py`** (body lengths; `lo` is the zone
edge, `hi` is as far as the gesture goes):

| zone | X | Y | Z | SPREAD |
|---|---|---|---|---|
| ABOVE | −1.79 … 1.79 | **1.60 … 2.40** | −1.00 … 1.00 | 1.00 … 3.00 |
| LEFT | **−0.75 … −1.35** | −0.20 … 1.30 | −0.50 … 0.50 | 0.20 … 1.60 |
| RIGHT | **0.75 … 1.35** | −0.20 … 1.30 | −0.50 … 0.50 | 0.20 … 1.60 |

**The span must lie inside the zone that switches the cell on, or the cell is dead.** A range the
zone can never reach normalises to a constant, the knob is pinned, and nothing on screen says why.

**That is not hypothetical — three of the four side axes were wrong until 2026-10-06**, all three
carrying ABOVE's figures, and the old TEST 12 passed every one because it only ever looked at the
cell's *default* axis:

- **Y was 1.60 … 2.40** — above the head, where the head rule puts the hand in ABOVE instead. A
  side cell set to Y was dead.
- **SPREAD was 1.00 … 3.00** — two arms opened wide, impossible with both hands on one side. `lftB`
  and `rgtB` **default** to SPREAD, so both two-hand side cells were dead on arrival.
- **Z was −1.00 … 1.00** — a full body length of depth from an arm already committed sideways.

TEST 12 now checks **all four axes of every cell**, plus that a side cell's X span begins *exactly*
on the entry threshold so there is no step at the edge. It was re-proven to fail on the old numbers.

**ABOVE is deliberately unchanged** — it was not what was reported, and its Y span (the axis anyone
uses there) does start at the zone edge. Its X, Z and SPREAD carry the same optimism the sides did.

### The scene stepper — `[p mb_stepper]`, at ABOVE × two hands

The one FIRE cell. No MAP button, no FROM/TO: it does not drive a parameter, it advances the song.

### ✅ AND THE LOCKOUT WAS THE SECOND HALF — `live.observer` reports a CHANGE (2026-10-06, fifth round)

Reported from Live once the walk worked: **"it worked for moments, broken and inconsistent — it
caused one advance and then it stopped working."** That is a stuck lockout, and the cause is one
sentence of the Live API that the whole design leaned on without checking:

> `live.observer` sends a value **on each change** of the property.

**A scene that starts without ever blinking never changes `is_triggered`.** It is 0 before the
fire and 0 after, so Live sends **no notification at all** — and the lockout, which waits for that
0, is released only by the `[del 8000]` failsafe. **That is the guard becoming the timer it was
explicitly designed not to be**, and it is the normal case whenever the **transport is stopped**
(which is exactly when the user tried it) or Global Quantization is None. Hence "one advance, then
nothing", and hence inconsistent: raise again after eight seconds and it works.

**The fix is to ask as well as listen.** `live.observer`'s own `bang` method: *"Sends current value
of selected property of current object to the left outlet."* 120 ms after the fire the stepper
bangs the observer:

| the re-read answers | |
|---|---|
| `is_triggered 1` | still queued, waiting for the bar — **the lockout stands**, and the notification will release it |
| `is_triggered 0` | already started — **release it now**, which is the release the notification would never have sent |

`verify_cells.py` **TEST 34** is that case, and **removing the single re-read patchline fails it
with `fired == [0]`** — one advance and then nothing, the reported symptom exactly. **TEST 26 had
to be narrowed**, which is the interesting part: it used to assert "the failsafe releases a lock
Live never reported", and that scenario is now the *common* one and belongs to the re-read. What is
left for the failsafe is the genuinely stuck case — queued when the re-read asks, then Live silent
for ever. A failsafe that was quietly covering the main path is a failsafe that was hiding a bug.

**The lockout now says who released it**, which is the line that would have caught this in one
raise: `locked`, every `is_triggered <v>` Live sends, then either `unlocked by Live` or
`unlocked by the 8 s FAILSAFE - Live never reported the scene starting, so the guard ran as a timer`.

> **A wrong turn worth recording, because it nearly became a bug.** Two shipped devices put
> `[route button_matrix_grabbed]` on `live.observer`'s left outlet, and eleven put a `[t ... l]`
> there. That reads as strong evidence that the left outlet sends `<property> <value>`, and it would
> have meant the build's `[t i]` was wrong — so the change was one edit from being made. **The
> refpage says the opposite outright:** left outlet *"Sends the current value of the selected
> property… may be int, float, symbol, id nn"*, and the `bang` method's example output is `Drums`,
> not `name Drums`. Those devices are observing *children*, whose values **are** id lists. **The
> reference implementation is evidence, not proof — it answers "how is this normally done", not
> "what does this object emit".** For the second question, the refpage wins. (`property <name>` as
> a *message* was confirmed the other way: 7+ stock devices use exactly that, so the build is right
> there too.)

### ✅ FOUND IT — `uzi`'s index and carry outlets were swapped (2026-10-06, fourth round)

**This was the actual fault, and three console lines caught it in one raise:**

```
mb_stepper: count 8
mb_stepper: a scene path resolved to id 0 - no object there.
live.object: get: no valid object set
```

`getcount` was fine all along — `count 8`. **`[uzi]`'s outlets are not what the build assumed.**
From its own refpage: outlet 0 is the bang, outlet **1** is *"Done banging bang (carry)"*, outlet
**2** is *"Current Index"*. The second argument *"sets the base value for the **right outlet
count**. The base value defaults to 1"* — which settles both which outlet carries the index and
that it counts from 1. The build read **outlet 1 as the index and outlet 2 as the done-bang**.

So the walk never iterated. It ran **exactly once**, off the done-bang, and `[t i b]` turned that
bang into `0`:

```
candidate = (0 + -1) % 8   ->   -1      (C's % truncates toward zero, and Max's expr is C)
path live_set scenes -1    ->   id 0
live.object set to id 0    ->   "get: no valid object set"
```

One attempt, one `id 0`, no `fired` line — and no `no scene has a clip` line either, because the
"nothing playable" check was wired to the index outlet and so was being fed 1, 2, 3… instead of a
single bang. **Every line of that console output, including the two that were missing, follows from
this one swap.**

**The harness had the same swap, with a comment stating the wrong belief outright** —
*"Per iteration Max sends the index out the middle outlet, then a bang out the left; the right
outlet carries once the whole loop is done."* Correcting the model against the refpage turned
**89/89 into 68/89**: twenty-one assertions across every stepper test. Fixing the two patchlines
put it back to 89/89.

> **This instance corrects the lesson the fourth one drew.** That section says the replay method's
> weak point "is not the model of Max, it is the model of Live". **That is now too comfortable.**
> Max's semantics are *small*, not *known* — and an outlet order got it wrong for weeks, in both
> the patch and the model, because the same wrong belief wrote them both. The honest rule is:
> **every assumption that lives in both the patch and the harness is untested by construction.**
> Those are the ones to go and read, and the refpage is thirty seconds away.

**Also changed, from reading the reference implementation:** the scene path is now built with
`[prepend path live_set scenes]` rather than `[sprintf path live_set scenes %ld]`. **Six shipped
Ableton devices build LOM paths this way — `Vector Map`, `Vector Grain`, `Vector Delay`,
`Vector FM`, `Emit`, `Bouncy Notes` — and of all 142 stock devices scanned, not one uses `sprintf`
for a path.** It also deletes the `%ld` numeric-format question outright: no format string, no
type to get wrong, the index goes in as the atom it already is.

### ⚠ THE STEPPER NOW SAYS WHERE IT STOPPED — read the Max console first (2026-10-06, third round)

**The whole of the available evidence was "it detects both hands but does not even say how many
scenes there are", and that second half was a defect in the readout, not a second bug.** The
window builds `scene / count` with `[sprintf %ld / %ld]`, and sprintf's **hot inlet is the current
scene** — which only ever arrived when something fired. So the one raise that most needed to
report, the one that fires nothing, was structurally the one that could not. CLAUDE.md claimed
this readout was "the five-second check" for a broken `getcount`. **It could never have been.**

Both numbers now leave the stepper on every raise, and the same facts go to the Max console,
because the mapping window can be shut. **Open the console, raise both hands once, and read:**

| The console says | What it means |
|---|---|
| **nothing at all** | the raise never got in. `valid`/BODY lamp, `Input` mode, the 1000 ms fire-arm block, or the lockout — not the stepper's Live side at all |
| `count 0` | Live answered, and the Set genuinely has no scenes |
| **no `count` line** but the raise got in | `getcount` is not answering — the `live.path` has no path, so `path live_set` never ran. Check `live.thisdevice` |
| `count 8`, then nothing | the count is fine and the walk died. The next line localises it |
| `a scene path resolved to id 0` | `path live_set scenes N` found no object. **This was the `uzi` swap above** — if it returns, suspect the candidate arithmetic, and print the candidate |
| `no scene has a clip` | the walk completed and every scene reported `is_empty 1`. **Session View rows, not Arrangement** |
| `fired 2` | the stepper did its whole job and told Live to fire scene 2. Anything still wrong after this is Live's side: quantization, clip launch modes, or the track |

`[print mb_stepper]` prefixes the object name itself, so the message boxes no longer repeat it —
the `mb_stepper: mb_stepper:` doubling in the first capture above is fixed.

**The lockout lines, read the same way:** `locked` then `unlocked by Live` is the healthy path.
`locked` then `is_triggered 1` then `unlocked by Live` is the healthy path *with* quantization.
`locked` then **`unlocked by the 8 s FAILSAFE`** means Live never reported and the re-read found it
still queued — the guard ran as a timer, and that is the one line that should never appear twice in
a performance.

The readout also reads honestly before anything has fired: **`0 / 8`** — no scene yet, eight found —
instead of staying blank.

> **Every LOM message in the stepper was checked against the official docs on this round, and all of
> them are right.** `Scene.is_empty` (get), `Scene.is_triggered` (get, observe), `Scene.fire`,
> `getcount` → `live.path`'s **right** outlet, `path` is *"same as goto"* and so does emit the id on
> the **left** outlet, `live.thisdevice`'s **left** outlet is the device-loaded bang, and an id is
> *"a list of the symbol `id` and an integer"* — which is why the build carries it with `[t b l]`
> rather than stripping it. Sources: the installed refpages in
> `/Applications/Max.app/Contents/Resources/C74/docs/refpages/m4l-ref/`, `docs.cycling74.com/reference/live.path`,
> `docs.cycling74.com/apiref/lom/scene/` and the Live API Overview. **So the remaining fault is not a
> wrong message, and guessing at one again is wasted time — make it speak and read what it says.**

### ⚠ READ THIS BEFORE DEBUGGING THE STEPPER AGAIN — `scenes` are SESSION VIEW ROWS

**The presentation Set has 8 scenes and not one clip in any of them.** Decoded on 2026-10-06
straight out of `MoveBeat Live presentation Project/MoveBeat Live presentation.als`:

| | |
|---|---|
| scenes | **8** — so `getcount scenes` answering 8 is correct, not a fault |
| session clip slots | 88, and **0 hold a clip** |
| where the one MIDI clip is | the **Arrangement** (`MainSequencer > ArrangerAutomation > Events`) on `1-MoveBeatSynth` |
| Global Quantisation | 4 = **1 Bar** — correct, matches the checklist |

So the stepper walked all 8 scenes, found every one empty, and fired nothing — **which is exactly
what it is designed and verified to do** (`verify_cells.py`: "a Set with no playable scene fires
nothing"). The device was right and looked broken.

**A scene is a row of the Session grid.** Live always keeps empty scene rows below the ones you
filled, which is the whole reason the stepper skips empty ones and can discover the length of the
piece. **A song built in the Arrangement has no scenes to fire at all.** Session View, clips in the
grid, is not an implementation detail here — it is the premise.

> **What was actually fixed on this round, then, is the silence.** A raise that finds nothing
> playable now writes **`no clips`** into the scene readout and a full sentence into the Max
> console. Nothing about the walk changed. This is the third separate instance in this project of
> *"correct behaviour, no feedback, hours lost"* — the mock-`valid` trap and the BODY lamp are the
> other two — and the lesson is the same each time: **every refusal needs a voice.**

**Also found in that Set, and it is a documented trap:** two tracks carry `MoveBeatSynth`
(`1-MoveBeatSynth` and `5-MoveBeatSynth`). `udpreceive 7500` cannot bind twice — **the second
instance fails silently.** Delete one before blaming anything else for missing parameter movement.

### ⚠ AND IT COULD NOT ADVANCE AT ALL UNTIL 2026-10-06 — `getcount` is a `live.path` method

Reported from Live: **with three scenes, every raise jumped to the first scene and the song never
advanced.** Three things had to line up to produce that, and each is a trap worth knowing.

**1. `getcount` is a `live.path` method, not a `live.object` one.** The build asked `live.object`
for `getcount scenes`. `live.object` has no such method, so Live answered **nothing** — no error
that reaches the patch. Max's own refpage is unambiguous: `getcount` is listed under `live.path`,
and *"Sends a `count` message to the **right outlet**, containing the name of the child and its
number of entries"* — `count scenes 3`. So it is `getcount` → `live.path`, and the reply is
`route count` → `zl nth 2` off **outlet 2**. (No shipped device could settle this: all 139 were
scanned and **not one uses `getcount`.** Max's refpages were the reference instead.)

**2. `% 0` does not raise in Max — it quietly returns 0.** With no count, every candidate came out
`(k + current) % 0` = **0**, so the stepper fired scene 1 for ever and looked like a logic bug in
the walk rather than a missing query. The modulo now carries the usual no-ternary zero guard, and
`[uzi 0]` replaced `[uzi 1]` so that **a count that never arrives fires nothing at all** — an
obviously dead stepper is a bug you can see; always-the-first-scene is one you have to reason about.

**3. The test stub answered `getcount` on the wrong object, and so passed.** `verify_cells.py`
reported 54/54, then 65/65, on a stepper that could not advance a scene. **This is the third time
this exact failure mode has been recorded in this file**, and the pattern is now unmistakable: the
replay method's real limit is not the model of Max, it is the model of *Live*. The stub is strict
now — `live.object` records a complaint if asked for `getcount`, and `live.path` answers outlet 0
on every `path` message but outlet 1 **only when the id changes**, which is what Live does.

**A second, latent bug fell out of writing that stub honestly.** The stepper read its scene ids off
`live.path` **outlet 1**, which fires only when the id *changes* — so asking about the same scene
twice in a row got one answer and the second query died silently. Three scenes never hit it;
**a Set with one playable scene hits it on every raise after the first.** Both reads moved to
outlet 0, which answers every `path` message. `verify_cells.py` TEST 29 is that case, and reverting
that single patchline fails it and nothing else.

> The cells' own `live.path` objects were checked and left alone. `live.path live_set view
> selected_parameter` **should** read outlet 1 — there the watch behaviour is the point, since Live
> pushes a parameter when the user clicks one. The two in `dontMapToSelf` read outlet 1 into *cold*
> inlets that retain their last value, and the retained value is always the right one, so they work.
> Worth knowing, not worth changing before a deadline.

**Nothing positional is baked in.** The scene count is asked of Live on *every* raise with
`getcount scenes`, and each candidate's `is_empty` is read live. Live always leaves trailing empty
scenes below the ones you filled, so skipping them means the stepper discovers the length of the
piece by itself — add a section in Live and it is simply there. A `[uzi count]` walks forward from
the current scene, `(current + k) % count`, and the first playable one wins; that is also what
makes the end wrap to the beginning, so "restart the piece" is the same binding wrapping.

**The lockout is Live's report, not a timer.** After `call fire`, a `live.observer` watches that
scene's `is_triggered`: 1 while it is queued and blinking, 0 the moment it actually starts. The
stepper unlocks on the 0. The listener is opened only *after* firing, so the observer's own report
at the moment it is armed cannot unlock it straight away.

**The lock is set BEFORE the fire, and that order is forced.** With the fire first, Live can report
`is_triggered` 1 *and* 0 before the lock exists — at Global Quantization None, or on a raise that
lands exactly on a downbeat — both reports are dropped by the still-shut unlock gate, and the 8 s
failsafe ends up running the lockout on every raise. That is the guard quietly becoming the timer it
was designed not to be. It used to depend on patchcord fan-out order, which CLAUDE.md says never to
rely on; `verify_cells.py` TEST 31 fires a scene that starts inside the `call fire` and fails if the
order is reversed.

> **There is one timer, and it is a failsafe, not the mechanism.** If Live never reports — the
> scene was deleted, or it launched between arming and firing — the stepper would stay locked for
> the rest of the set. That is the one failure worse than a double advance, so `[del 8000]`
> releases it. It never decides a normal lockout, and `verify_cells.py` TEST 21 checks that it is
> still locked at 4 s.

Verified by replaying the real graph against a stubbed Live Set (`Song` in `verify_cells.py`):
discovers the length, skips empty scenes including ones in the middle, wraps, refuses to advance
while locked, respects `mb_zones`' 1000 ms fire-arm block, and fires nothing in a Set with no
playable scene. Both guards were **proven to fail when removed** — with the lockout gate deleted,
five quick raises skip five sections.

### The mapping window

The nine cells do not fit in Live's device strip (~169 px tall), so they live in a **separate
window opened with `[pcontrol]`** from a `ZONE MAPPING` button on the device panel — the idiom
Ableton's own `Harmonic Filter.amxd` uses. `[window flags float, window exec]` via `[thispatcher]`
keeps it on top while you click a parameter in Live; without float it disappears the moment Live
takes focus and MAP cannot be driven at all. `Vector Grain.amxd` sets its flags the same way.

The window is 526 × 309 and also carries four long **mock body sliders** and the global `ATTACK`
numbox, so the whole layer can be exercised without the Max editor open beside Live.

### The device panel gained two readouts

- **the last mapped parameter name** — the mapping window can be hidden, so without this there is
  no way to tell a MAP that worked from one that silently did nothing
- **a BODY lamp** — `valid` from `mb_body`. Every zone flag is multiplied by it. **Dark means
  nothing can move, however far a slider is dragged.**

### What is left

The step-by-step is in **"THE LIVE TEST"** at the top of this file; do not duplicate it here.
The two things that test cannot settle:

- **The zone thresholds have been revised once from a real report, and still never measured.**
  0.75 body lengths to the side (was 1.15), head height plus 0.15 above. The side figure moved
  because a performer found the old one unreachable; the new one is reasoned, not observed. The
  risk has also **swapped direction**: at 0.75 the danger is no longer that the zone is too far to
  reach but that natural dance movement latches it while standing still. A hand at rest sits around
  0.36, so there is room — but watch for it. One line in `zone_constants.py`, then the three
  rebuild commands.
- **ABOVE's X, Z and SPREAD spans have not been revisited** — same class of problem as the side
  spans just fixed, and nobody has used those axes yet.
- **What ATTACK should actually be.** 250 ms is a starting point, and it trades against the 60 ms
  side commit. Both are now adjustable without a rebuild, which is the point.
- **Whether a mapping survives save/reopen of the Set.** Never confirmed end to end.
- **Whether the stepper walks a whole piece in Live.** Four faults found and fixed on 2026-10-06.
  A scene **has** now been seen to launch from a raise — that much is confirmed — but it advanced
  once and stuck, which was the lockout fault, and **the fix for that is tested but not yet watched
  running.** What to check next: raise, let it advance, raise again immediately (nothing should
  happen), let the scene start, raise again (it should advance). With the transport **stopped** as
  well as running, because stopped is the case that exposed it.
- **The 120 ms re-read delay is a guess.** Long enough that Live has settled the launch, short
  enough not to be felt. If a raise ever releases its own lockout early, that is the number.

### Known limitation, stated plainly

A mapping is stored as a **positional path** — `live_set tracks 0 devices 0 parameters 3`.
Delete the effect and put another in the same slot and the path still resolves: it binds to
whatever now sits there, silently. A dead path (`id 0`) is refused, and `×` clears a mapping, but
same-position substitution cannot be detected from the path alone. The proper fix is to store the
parameter's name alongside the path and verify it matches on restore. **Not built.**

## Current status (as of 2026-09-05)

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
| Controller device | **Working**, and rebuilt 2026-08-18 as a 6-slot mapping matrix — see below. Both input paths verified on the Mac: live Kinect OSC, and a built-in mock body |
| Movement → sound mapping | **Any body part → any of the 24 synth parameters**, with a per-slot output range lock (2026-08-18). Replaces the four hardcoded features |
| Hop 1 against real hardware | **Verified live from the Mac 2026-08-18** — ~26 Hz, 1144-byte bundles from `192.168.0.101`, `/mb/tracked` = 1, 24/25 joints at `trackingState` 2 |
| The new mapping matrix against real hardware | **Not yet** against the Kinect — but see the Live row below |
| **Ableton Live is now the target** | **Decided 2026-08-22.** Reverses a documented decision — see below |
| Zone layer: `[p mb_body]` + `[p mb_zones]` | **Built, 16/16.** All 9 cells verified driveable from the mock sliders (2026-09-05) by replaying the real graph. Still not watched running in Max |
| **Both halves are Max for Live devices** | **Done and verified in Live 2026-09-05** — generated by `build_devices.py`, see below |
| **Movement → sound, end to end inside Ableton** | **Working 2026-09-05.** Three slots drove three separate parameters audibly at once, from the mock body |
| The eight mapping cells + MAP button | **Built and verified 2026-09-22**, `verify_cells.py` 37/37. Generated by `build_cells.py` |
| The scene stepper (`abvB`) | Built 2026-09-22; **four separate faults, all found on 2026-10-06** — `getcount` asked of the wrong Live object, the deferred-API race, `[uzi]`'s index and carry outlets wired the wrong way round, and a lockout waiting for a `live.observer` notification that is never sent when a scene starts without blinking. **The last two were each diagnosed from a console capture from Live, not from analysis**, which is why the device now reports every step. `verify_cells.py` **105/105** against a strict stub whose `uzi`, `expr`, `trigger`, `deferlow`, `live.observer` and (2026-10-06) `line~` models were all corrected in the process. **It still needs clips in the Session grid** — see the section above |
| Zone geometry + timing in one file, the attack envelope | **2026-10-06**, after the first session in Live — see the zone-mapping section |
| Controller presentation view | **Built 2026-09-05** — 454 × 150 px, six rows + zone monitor |
| Synth presentation view | **Built 2026-09-05** — 450 × 140 px, 24 parameters in four columns |
| Live restoring saved values | **Fixed and confirmed in Live 2026-09-05** — a new Set saved and reopened with every setting intact, in both devices |

### Skeletal tracking — resolved (it was distance)

The long "no body is ever tracked" mystery had nothing to do with software or hardware: **nobody was standing in the sensor's tracking range during the tests.** Kinect v2 needs roughly **2–3 m with the whole body in view** — it will not track someone sitting at the keyboard half a metre away. With a person at proper distance, bodies track and joint coordinates stream normally.

Keep this in mind for every future "no data" report: check framing/distance *first* (`DepthBasics-D2D.exe` shows what the sensor actually sees), before suspecting code.

## Where this is going now: one Ableton Live Set (2026-08-22)

**The end goal changed, and it reversed a decision that `ARCHITECTURE.md` and `BUILD_GUIDE.md`
used to state.** Both said Ableton and Max for Live were deliberately out of scope — true while the
synth was a standalone macOS instrument, false since. **Both were updated 2026-09-05**, along with
`ZONES.md`; the reversal is now recorded rather than pending.

The target is **one saved Live Set**, which is what the project gets presented from:

- Both devices become **Max for Live devices** — `MoveBeatSynth.amxd` (Max Instrument) and
  `MoveBeatController.amxd` (Max MIDI Effect).
- Loops live in Session View, and **scenes are the song's sections**.
- The dancer drives Live directly through the Live Object Model: three body zones mapped to
  effect parameters and to scene launching.
- The synth's notes come from **MIDI clips on its own track** — the dancer shapes timbre, not
  pitch. That deliberately removes the hardest problem (playing pitches by dancing) from scope.

### `synth/docs/ZONES.md` is the reference for all of it

It holds the full specification — three zones, nine cells, the three modes, the MAP button, the
input range, the scene stepper, loss-of-tracking behaviour, distance and framing, and the
verification status of every piece. **Read it before touching anything zone-related**, the same
way `MAPPING.md` governs the six-slot matrix.

### What is built and what is not

| Piece | State |
|---|---|
| `[p mb_body]` — body-relative coordinates | **Built, 7/7 verified.** Runs in Live; not yet watched running in Max |
| `[p mb_zones]` — zones, hysteresis, all the timing | **Built, 11/11 verified.** Retuned 2026-10-06 by `tune_zones.py` from `zone_constants.py` |
| Mock sliders + 12-toggle zone monitor | Built; **usable since 2026-09-05** via the new `MOCK - sliders only` mode |
| The eight cells: MAP, `live.remote~`, FROM/TO | **Built 2026-09-22.** See the zone-mapping section at the top |
| The scene stepper | **Built 2026-09-22** — live scene query, skip empty, wrap, lockout on Live's report |
| The freeze rule | `mb_zones` emits the hand-busy pair; **nothing consumes it yet** |

The zone layer is **purely additive** — `mb_sources` and the six slots are untouched and still
work in absolute sensor metres.

### ▶ The next step, in order

~~1. Five-minute check, drag the mock sliders, watch the toggles light up.~~ **This instruction was
wrong and is retired — the sliders cannot light the zone toggles.** See the mock-`valid` trap
below for why, and what to watch instead.

~~3. Convert both devices to `.amxd` — GUI work that cannot be done from a terminal.~~ **Done
2026-09-05, and it is not GUI work.** See the `.amxd` section below.

~~1. Make the slot settings persist and give the controller a presentation view.~~ **Done
2026-09-05 by `build_presentation.py` — but only structurally.** The next actual step is to
**confirm it in Live**: load the controller, pick a mapping, save the Set, close Live, reopen, and
check the mapping came back. That is the whole point of the change and it is unverified.

> **Superseded 2026-09-21 by "START HERE" at the top of this file** — the scope and order there win.

1. **Build the Live Set** (the user's task, music production). Session View, Global Quantization
   **1 Bar**, scenes as song sections, trailing scenes left empty, effects ready to map. Make the
   song work by clicking scenes with a mouse *before* any camera is involved.
3. **Then build the nine cells** — MAP, `live.remote~`, the scene stepper. Read the Max for Live
   Essentials LFO device first: the MAP button is a standard M4L idiom, not an invention, and a
   working reference ships with Live Suite.
4. **Measure the zone thresholds against a real dancer.** Still derived, still unverified, still
   the most likely thing to be wrong.

## The Max for Live devices — generated, never hand-built (2026-09-05)

Both halves now ship as M4L devices, **verified playing inside Ableton Live**: the synth makes
sound from a MIDI clip, the controller passes MIDI through, and three mapping slots drove three
separate synth parameters audibly at the same time. That is the whole chain — movement → OSC →
parameter → sound — closed inside Live.

### `.amxd` is not an opaque format, and converting is not GUI work

`CLAUDE.md` used to say the conversion was "GUI work in Live that cannot be done from a terminal."
**That was wrong.** An `.amxd` is a 32-byte wrapper around a plain `.maxpat` JSON:

```
"ampf" <u32 4> <4-byte device type>      iiii = instrument      mmmm = MIDI effect
"meta" <u32 4> <u32 flags>               aaaa = audio effect    nagg/natt = Live 12 MIDI
"ptch" <u32 len> <maxpat JSON> "\n\0"
```

Nothing is encrypted or checksummed. This was confirmed against **all 110 stock devices** in Live
12 Suite. `project.amxdtype` inside the JSON must match the header's type tag.

**`synth/docs/verification/build_devices.py` generates both devices from the `.maxpat` sources.**
Rebuilds are byte-identical, so git only ever shows real changes. It applies exactly three edits:

| | change | why |
|---|---|---|
| synth | `notein` → `midiin`→`midiparse`→`unpack 0 0` | Live delivers the track's MIDI to `midiin` |
| synth | `ezdac~` → `plugout~` | audio leaves a device through `plugout~` |
| controller | add `midiin`→`midiout` | **a MIDI-effect device without this silently blocks the track's MIDI** |

`unpack` fires right-to-left, so velocity is stored before pitch triggers the `pack` — the same
order `notein` produced. The on-screen `kslider` is untouched, so the device is still playable
from its own keyboard.

### The `poly~` question, answered

The old worry was whether `poly~` could find `mb_voice.maxpat` inside a device. **It can, through
Max's search path** — and that is the normal mechanism, not a workaround: not one of the 110 stock
devices embeds a patcher in `project.contents.patchers`.

`build_devices.py` puts a **symlink** at `~/Documents/Max 9/Library/mb_voice.maxpat` pointing into
the repo. A symlink and not a copy, deliberately: a second copy of a patcher is exactly how
`build/MoveBeat_ableton_ves.amxd` drifted into a fork. The cost is that moving the repo breaks the
link — re-run the script and it is rebuilt.

### The rule that keeps this from rotting

> **Structural edits go in the `.maxpat`. Ableton is for playing.**

`verify_body.py`, `verify_zones.py` and `build_zone_layer.py` all read the `.maxpat`. Edit a device
inside Live and save, and it forks from the patch while the verification harness keeps checking the
patch — you lose the thing that catches mis-wiring. `MoveBeat_ableton_ves.amxd` is the standing
example of what that produces.

### The six slots are Live device parameters (2026-09-05)

`build_presentation.py` converted the six mapping rows and the input-source menu to `live.menu` /
`live.numbox`. **Zero patchlines changed**, because Max's own object prototypes make these drop-in
replacements for what was there:

| | outlets | 0 | 1 |
|---|---|---|---|
| `umenu` | 2 | index | symbol |
| `live.menu` | 3 | index | symbol |
| `flonum` | 1 | float | — |
| `live.numbox` | 2 | value | raw 0–1 |

Both outlets the patch uses — including `umenu` outlet 1 into `sprintf /movebeat/%s` — carry the
same thing. So the swap keeps every id and every connection, and the verification suites pass by
construction rather than by luck.

**What is deliberately *not* a parameter:** the six `SENDING` readouts and the twelve zone-monitor
toggles. They are driven by the patch, not by the user — giving them `parameter_enable` would put
meaningless entries in Live's automation menu and invite Live to automate a value `mb_zones`
overwrites 30 times a second.

**The MIN/MAX tradeoff:** those numboxes must span every parameter's range, so they run
−24 … 18000. Coarse to drag and coarse to automate — acceptable only because picking a parameter
auto-fills both from the range table, so they are rarely touched by hand.

### ⚠️ `Collect All and Save` freezes the devices — a plain save does not

A Live Set normally stores a **path** to the `.amxd`, so rebuilding with `build_devices.py`
reaches Live on the next load with nothing to re-drag. Verified by decoding a Set:

```
<RelativePath Value="../MoveBeat/synth/controller/MoveBeatController.amxd" />
```

**`Collect All and Save` changes that.** It copies both devices into

```
<Live project>/Presets/{Instruments,MIDI Effects}/Max {Instrument,MIDI Effect}/Imported/
```

and from then on the Set uses its own copy. Rebuilding then updates the repo and changes nothing
Live loads — no error anywhere. Same class of bug as the OneDrive copy and
`MoveBeat_ableton_ves.amxd`: one logical file, two places on disk, silently diverging.

| When | Do |
|---|---|
| While developing | **Plain save only.** Rebuilds flow through automatically |
| Handing the project in | `Collect All and Save`, once the devices are final — it makes the project self-contained instead of depending on this repo's path |

If a change "did nothing", check for an `Imported/` folder before anything else.

### Three traps when running the devices

- **Only one instance of the synth device.** `udpreceive 7500` cannot bind twice; the second
  instance fails silently.
- **Do not leave the standalone `MoveBeatSynth.maxpat` open in Max** while the device runs in Live.
  Same port, same silent failure.
- **After every build, re-drag the device into Live** — Live uses its own imported copy, see the
  section above. This is the single most likely reason a change appears to do nothing.

## Verifying Max patches by replaying their own graph (2026-08-22)

`synth/docs/verification/` now holds a technique worth reusing. `verify_body.py` and
`verify_zones.py` **do not re-implement** the subpatchers. They load `MoveBeatController.maxpat`,
walk the real object graph, and replay it under Max's own message semantics — outlets fire
right-to-left, inlet 0 is hot except `gate` whose data inlet is the right one, `expr` cold inlets
store, plus a virtual millisecond clock for `[del]`.

So a mis-wired patchline **fails the tests**, which is the whole point: reading a patch does not
tell you what it does, and the GUI does not show mis-wiring.

`build_zone_layer.py` regenerates `mb_body` and `mb_zones` from a clean `HEAD` checkout. If either
subpatcher needs structural change, edit the builder and re-run it rather than hand-editing JSON.

> **Its limit, stated plainly:** the replay is a *model* of Max, not Max. If the model is wrong
> somewhere, the tests pass while the patch misbehaves. The least certain assumptions are `[del]`
> restarting on a repeated bang, and fan-out order where it was not forced with an explicit `[t]`.

## Writing this up — the method is the contribution, not the feature list

A thesis that lists what was built reads like a manual. What distinguishes this project is
**how correctness was established**, on a system where almost nothing can be checked by looking
at it: a Max patch's behaviour is invisible in its GUI, a Kinect stream is invisible without a
decoder, and a Live device's state is invisible until you reopen the Set.

Six practices did the work. Each one has at least one concrete episode behind it, and the episodes
are what make the write-up specific rather than generic.

### 1. Measure the artefact; do not reason about it

Every hard question this project asked was settled by **decoding the real file or the real
stream**, never by argument.

| Question | What was decoded | What it settled |
|---|---|---|
| Is the OSC encoder correct? | a captured packet | byte-exact, 1144/1144 consumed |
| Is the PC or the Max side at fault? | live UDP from the Mac | the PC was fine all along |
| Is `.amxd` openable? | 110 stock Live devices | a 32-byte header, nothing encrypted |
| Why did Live not save my mapping? | the `.als`, gunzipped | **Live saved correctly — the patch overwrote it** |

The last one is the strongest example. Every plausible theory pointed at the parameter metadata.
The file said otherwise in one line, and the real bug — a `loadbang` — was somewhere nobody would
have looked.

### 2. Read the reference implementation that is already on disk

Repeatedly, the authoritative answer was sitting in an installed application.

- `BodyBasics-D2D.exe` is the Kinect ground truth: if it tracks and this repo does not, the bug is here.
- Ableton's own devices defined the `.amxd` container and the device-type codes.
- Max's own object prototypes settled that `live.menu` outlet 1 is the item symbol — which is why
  the `sprintf` path survived untouched and **not one patchline had to change**.

Guessing that outlet would have meant rewriting six mapping rows for no reason.

### 3. Replay the real graph rather than re-implementing it

`verify_body.py` and `verify_zones.py` do not model what the subpatchers *should* do. They load
`MoveBeatController.maxpat`, walk the actual object graph, and execute it under Max's own message
semantics — right-to-left outlets, cold inlets that store, a virtual clock for `[del]`.

So a mis-wired patchline **fails the tests**. That is the whole point: reading a patch does not
tell you what it does, and the GUI does not show mis-wiring.

> **State the limit too, and mean it.** The replay is a *model* of Max, not Max. If the model is
> wrong somewhere, the tests pass while the patch misbehaves. Naming the least certain assumptions
> — `[del]` restarting on a repeated bang, fan-out order where no `[t]` forces it — is more
> convincing than claiming completeness.

### 4. Generate artefacts; never hand-edit a derived copy

`build_zone_layer.py`, `build_devices.py`, `build_presentation.py` all regenerate from source, and
all are **idempotent** — three runs, identical bytes — so git only ever shows a real change.

The counter-example is in the repo on purpose. `synth/build/MoveBeat_ableton_ves.amxd` is a
hand-edited near-copy that drifted into a fork, and it is kept as the standing argument for the
rule. The same failure has now appeared three times in three different costumes: OneDrive racing
the build, that forked device, and Live's `Collect All and Save` freezing an imported copy.
**One logical file in two places on disk, diverging silently** — worth naming as a recurring
hazard rather than three separate anecdotes.

### 5. Design for the failure you cannot recover from

Not every risk is equal, and the write-up should say which one is not survivable.

The head rule — *a hand above head height is in ABOVE, whatever its X* — exists because without it,
reaching diagonally for an effect would advance the song. **You cannot un-skip a section in front
of an audience.** Likewise the scene stepper's lockout waits for Live to report that the scene has
actually begun, rather than trusting a millisecond timer.

The pattern: a guard whose cost is a line of arithmetic and whose absence is unrecoverable is not
a trade-off at all.

### 6. Record the wrong turns

The debugging detours are the most useful pages, because they are where the reasoning is visible.

- **"No body is ever tracked"** consumed a long investigation and was **distance** — nobody was
  standing 2–3 m from the sensor. Every "no data" report now checks framing first.
- **"It crashes every ten seconds"** matched four unrelated faults. The fix was a log that tells
  them apart in one command, not a guess at which one it was.
- **`Start-Process -RedirectStandardOutput`** made a healthy app look dead, because it leaves stdin
  as the null device and `Console.ReadLine()` returns instantly.
- **The mock sliders could never light the zone monitor**, and the instruction telling you to try
  sat in this file for two weeks. `[t b i]` reads a list's first element, so `valid` became
  `int(joint.x)` = 0.

Two claims in this document were also **wrong and corrected the same day**: that converting to Max
for Live required GUI work, and that Live imports a copy on a plain save (it is `Collect All and
Save`). Both are marked in place rather than quietly deleted — a document that never records being
wrong cannot be trusted about anything else.

### What the numbers are, when you need them

~26–32 Hz capture · 1144-byte OSC bundle · 25 joints · 24 synth parameters · 6 mapping slots ·
9 zone cells · 31 + 24 Live device parameters · 16/16 behaviour tests · 110 stock devices decoded.

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
| **Controller** | `synth/controller/MoveBeatController.maxpat` | Movement in, synth parameters out. Six mapping slots, one per body part. Reads the Kinect stream, or its own mock body. |

`synth/instrument/mb_voice.maxpat` is the third file — one `poly~` voice. It is only separate because `poly~` requires its voice patcher to be its own file; it is never opened directly.

**`synth/docs/MAPPING.md` is the reference for everything mapping-related.** Read it before changing any movement→sound behaviour.

### Why this split, given there was never a Windows-only Max object

Worth recording, because it is a natural assumption and it is wrong: **the Max patches contain no Windows-only objects and never did.** There is no `dp.kinect2`, no `jit.*`, nothing platform-specific. The Kinect is read by the C# app on the PC; the Max side has always been stock `udpreceive` + `route`, which loads fine on macOS.

So the split is **not** a platform-compatibility fix. It buys three things:

1. The synth can be developed and played on the Mac with no camera, no PC and no network.
2. The mapping can be tested against a mock body that behaves identically to a real one.
3. Any controller speaking the protocol can drive the synth — which is what makes the planned MoveNet/webcam controller a drop-in addition rather than a rewrite.

### The controller owns the mapping, and now the units too

The controller is a **six-slot mapping matrix**, one slot per body part — 2 hands, 2 feet, head,
torso. Each slot picks a source from that part (`X`, `Y`, `Z`, `SPEED`, or the whole-body
`SPREAD` / `LEAN`), sends it to **any of the synth's 24 parameters**, and locks that parameter
inside a min/max band with a linear or exponential curve.

**The wire now carries native units (Hz, ms, semitones), not 0–1.** It used to carry a fraction,
with ranges living only in the instrument. The range lock forced the change: a lock is written
as "500–2000 Hz", so something has to know what a Hz is, and keeping the old split would have
meant the same 24-row range table in both patches — a duplicate contract that drifts silently.
Scaling moved to the controller; the synth still **clamps** every value to the parameter's legal
range but no longer scales. `synth/docs/MAPPING.md` holds the table and the full rationale.

Tuning is still split in two, and knowing which is which saves a lot of hunting:

- **How much movement counts as "full"** → the controller, in `[p mb_sources]`. The `[scale]` objects.
- **How far the parameter may travel** → the min/max on the slot row, live, while sound is playing.

### Testing on the Mac with no camera

`MoveBeatController.maxpat` has an input-source menu at the top left: **LIVE** (real Kinect on port 7400) or **MOCK**. Mock gives one slider per body part plus an auto-motion generator that emits complete joint messages for all eight joints at the Kinect's real ~30 Hz, frame trigger last.

**`[p mb_osc_in]`'s gate is `[gate 1 1]` — open by default.** It used to default closed and rely on `loadbang` to open it, so editing the patch in Max (which re-instantiates objects without re-firing `loadbang`) silently killed the entire device: no LIVE, no MOCK, no output, and nothing in the Max console. Keep the `1 1`.

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

Both devices run on the Mac, so this hop never leaves the machine. One address per parameter,
`/movebeat/<name>`, **each carrying one float in that parameter's own units** — plus
`/movebeat/gate` carrying 0 or 1.

The 24 names are exactly the synth's parameters: `cutoff`, `resonance`, `drive`, `rescomp`,
`outgain`, `osc1level`, `osc2level`, `sublevel`, `detune`, `pw`, `osc1wave`, `osc2wave`,
`lfoRate`, `lfoDepth`, `filtEnvAmt`, `glide`, `ampA/D/S/R`, `filtA/D/S/R`. Thirteen are handled
Max-side in `mb_voice.maxpat`; the other eleven fall through its `route` into `gen~` as Params.
**`synth/docs/MAPPING.md` is the reference** — legal range and default curve for all 24.

Every joint is gated on `trackingState == 2`, so inferred or lost joints never reach the synth —
the last good value simply holds. `/mb/tracked` is the last message in each bundle, so the
controller uses it as the frame-complete trigger and emits one set of mappings per frame.

`/movebeat/gate` currently only lights an indicator. **Open decision:** when tracking is lost,
every parameter freezes at its last value and the synth drones on unchanged. Whether it should
mute, fade or freeze is a musical choice, so nothing is wired to it yet.

### Why OSC and not MIDI CC

Worth writing up, because MIDI CC is the obvious first instinct for "controller drives synth".

**The hard reason:** the Kinect and the synth are on two different computers. MIDI does not cross Ethernet without RTP-MIDI, which on Windows means installing a third-party driver — and **this account is not an administrator**. OSC over UDP already works and is byte-verified.

**The soft reason:** standard MIDI CC is 7-bit, 128 steps. Across the full 20–18000 Hz exponential cutoff sweep each step is a large frequency jump, audible as stepping on a slow sweep even with smoothing. OSC carries a 32-bit float, so the question does not arise. If CC is ever wanted for a hardware controller, add `[ctlin]` in the **controller** and feed it into a slot's source inlet in place of a movement source — the slot's own min/max then converts 1/127 into the parameter's units, so the CC never has to know them. Prefer 14-bit CC for `cutoff`. Note this is a change from the pre-2026-08-18 advice: `[p mb_ctrl_in]` no longer scales, so wiring a raw CC into the synth would now send 0–127 straight at a parameter and get clamped.

### Smoothing — two mechanisms, because there are two kinds of parameter

The camera stream is 30 Hz. Sent raw, that steps audibly. The two routes need different fixes:

- **`cutoff` is a signal** inside the voice. The original `[sig~ 800]` jumped at block boundaries; it is now a `[line~]` fed by `[pack 0. 25]`, ramping each value over 25 ms at signal rate. Because the voice already ramps it, `[p mb_ctrl_in]` passes `cutoff` straight through with no control-rate smoothing — do not add a second ramp.
- **Everything else arrives as a message**, and for the eleven `gen~` Params **`gen~` does not interpolate Param changes** — this is the non-obvious part. All 23 non-`cutoff` parameters are ramped at control rate in `[p mb_ctrl_in]` with `[pack 0. 25]` → `[line 0. 5]`: a 25 ms ramp emitted every 5 ms. `osc1wave` and `osc2wave` are additionally rounded to whole numbers, since a half-way wave shape is meaningless.

Measured result: a 30 Hz input becomes a ~151 Hz parameter stream whose largest single step is 0.25% of the observed range.

If `outgain` ever still clicks on a very fast move, the fix is to pin the Param at 1.0 and do the gain with a `[line~]`-driven `[*~]` in the voice — outside `gen~`, leaving the verified DSP core untouched.

## Max traps that cost real debugging time

The first was found on 2026-08-08 while building the split, the next two on 2026-08-18 while building the mapping matrix. All of them produce a patch that loads and looks right. The last entry is not a trap but the method that catches all of them.

### Max numbers subpatcher inlets/outlets by X position, not creation order

An `inlet`/`outlet` object's index comes from its **on-screen X coordinate**, not from where it appears in the file or the order it was made. Lay them out in a different left-to-right order than you intend and Max silently renumbers them; the parent then connects to the wrong ones **with no error in the Max console**.

This swapped `cutoff`↔`resonance` and `drive`↔`outgain` inside `[p mb_features]` (that subpatch and `[p mb_map]` were replaced by `[p mb_sources]` + six `[p mb_slot]` on 2026-08-18; the lesson is unchanged and the new subpatchers are checked the same way). Everything loaded, and the values looked entirely plausible — they were simply arriving on the wrong addresses. It was only caught by capturing the device's UDP output and noticing the *ranges* belonged to the wrong parameters.

**When editing `.maxpat` JSON, always check that inlet/outlet order matches ascending X.**

### Max's `expr` has no ternary operator

`gen~`'s expr does; the Max object does not. `[expr $i1 < 4 ? $a : $b]` fails with
`expr: syntax error ? ...` — and note the error **echoes the text from the `?` onward**, so the
condition appears to have vanished and it reads like the wrong thing is broken.

Comparisons already return 1 or 0, so blend arithmetically instead:

```
result = A + (cond) * (B - A)
```

When one branch divides or takes `pow()`, guard its operands so the *unused* branch still
evaluates to a finite number — `0 * nan` is `nan`, so an unselected branch can still poison the
result. `[p mb_slot]` does this: the exponential branch clamps its base positive with
`(($f2 > 0) * $f2 + ($f2 <= 0))` so a min of 0 or a negative range can never produce `nan`.

### If you write your own OSC decoder, get the string padding right

`CLAUDE.md` recommends decoding the stream as the way to verify both sides, so this is worth
stating exactly. **An OSC string is padded to a multiple of 4 bytes *including* its null
terminator.** For an address that is already a multiple of 4 once the null is added — `/mb/tracked`
is 11 characters, so 12 with the null — the correct advance is 12, **not** 16.

Getting this wrong reads as corrupt data rather than a decoder bug, which is what makes it
expensive. On 2026-08-18 an over-advance of 4 bytes made `/mb/tracked` decode as having no
arguments at all and `/mb/handtipleft` report a type tag of `f` instead of `,ffff` — so the
packet looked malformed and the PC looked broken, when the stream was byte-perfect. The correct
advance for a string of length L (excluding the null) is `(L + 4) & ~3`.

A free cross-check: the real bundle is exactly **1144 bytes** and consumes 1144/1144. If your
decoder does not land on that, suspect the decoder first.

> **But the 1144-byte invariant only holds while a body is TRACKED** (noted 2026-10-06). With
> nobody in view `Program.cs` sends **only** `/mb/tracked 0` — a short bundle, no joints. A
> decoder that enforces 1144 bytes unconditionally flags every healthy empty frame as corrupt.
> Check the length only when `tracked == 1`.

### A state that other logic is hot on must re-propagate every frame

Each hand's zone test in `mb_zones` first had a `[change]` after it, to avoid re-sending an
unchanged value. That is a reasonable instinct and it was wrong here: the downstream combinations
are hot on **one** hand's value, so filtering out "no change" meant the right hand going up never
recomputed anything. Five of nine behaviour tests failed, and the patch looked entirely correct.

`[change]` is safe on a value that only *drives* something. It is a bug on a value that something
else *reads* while being triggered by a different source.

### A frame-trigger inlet that also carries a *value* cannot be fed by a `pak` (2026-09-05)

This is why **dragging the mock sliders never lights the zone toggles**, and why the retired
"five-minute check" instruction above could never have worked.

`mb_body`'s inlet 5 is the frame trigger. It reaches `[t b i]`: the `b` re-emits the output list,
and the `i` feeds `valid`. Over real OSC the number arriving there is `/mb/tracked`, i.e. `1`.
But in the root patch that inlet is **also** wired from all eight mock `pak` objects — and a `pak`
sends a *list*. Max's `trigger` takes a list's **first element** for an `i` outlet, so `valid`
becomes `int(joint.x)` — `int(-0.35)` = **0**. Every zone code is multiplied by `valid`, so all
nine flags stay dark.

`mb_sources` is immune to exactly the same wiring because its trigger inlet uses `[t b]` — bang
only, never reads the value. **That asymmetry is the whole bug**, and it is invisible in the GUI.

Two consequences worth remembering:

- **A trigger inlet is not automatically a bang inlet.** If anything downstream reads its *value*,
  every source feeding it must send that value's correct type — not merely cause a recompute.
- **In MOCK, watch the auto-motion, not the sliders.** Selecting MOCK starts a `metro 33` inside
  `mb_automotion` that overwrites all eight joints 30×/s, so a slider drag is erased within 33 ms
  regardless. A 30-second replay of the real graph predicts 5 of the 9 toggles blinking on a
  repeating cycle; `lftR`, `lftB`, `rgtL`, `rgtB` **never** light, because the auto-motion swings
  each hand around its own side (`±0.30` about `x = ∓0.35`) and neither hand ever crosses the
  midline. Four dark toggles is correct behaviour, not a fault.

Testing the other four cells is what the sliders are *for*, so this is worth fixing when the zone
layer is next touched — one `[t 1]` between the mock `pak`s and inlet 5 would do it.

### Seven traps from building the mapping cells (2026-09-22)

Every one of these produced a device that loaded, looked right, and did nothing.

**1. Max for Live Essentials' LFO is encrypted — read `Step Arp` instead.**
`CLAUDE.md` used to say "read the LFO, it ships with Live 12 Suite and is editable." **It is
not.** Live 12's built-ins carry a `ciph` chunk: 25 of 139 stock devices are unreadable. Two that
*are* readable carry Ableton's own mapping abstraction, and one of them is a MIDI effect like this
controller:

```
~/Music/Ableton/Factory Packs/Sequencers/Step Arp/Ableton Folder Info/Step Arp.amxd
~/Music/Ableton/Factory Packs/Inspired by Nature by Dillon Bastan/.../Vector Map.amxd
```

**2. An `.amxd`'s `ptch` chunk holds SEVERAL patchers, concatenated.** The device, then each
abstraction it depends on, as separate JSON objects back to back — sometimes behind an `mx@c`
16-byte prefix, with binary trailer chunks (`sz32`, `mdat`) after the last one. Parse with
`json.JSONDecoder().raw_decode` in a loop, not `json.loads`. A decoder that stops at the first
object silently misses the half that matters: the first search for `live.remote~` came back empty
while the device plainly had one.

**3. `live.object` and `live.remote~` are set BY the `id <n>` message, not by a number.**
Strip the selector with `[route id]` and hand them a bare integer and they set *nothing at all* —
no error in the Max console, no clue. Everything downstream then silently does nothing: `getpath`
returns nothing, `dontMapToSelf` never produces a verdict, its gate stays shut, and the MAP button
never turns off. Ableton's own inlet is labelled `(lom id) selected parameter` for this reason.
**Carry the whole message.**

**4. `parameter_unitstyle: 0` is Int, not Float.** A float parameter declared with unitstyle 0 is
rounded to whole numbers by Live. `-1.15` displayed and behaved as `-1`, `1.60` as `2`. In
body-relative coordinates that is the difference between a working zone and a dead one. Float is
**1**; percent is 5.

**5. A freshly dragged device resets every parameter to its initial — including the input mode.**
`Input` initialises to 0 = **LIVE**. So "delete the device and drag a fresh one" — the standard
advice for clearing stale values — silently moves you to LIVE mode. With no camera attached,
`head`, `spinebase` and `spineshoulder` are never sent, so `valid` is 0 and **every zone flag is
forced to 0**: nothing can move, however far a slider is dragged. Worse, spine length is then
`|0 − 0|` = 0, clipped to the 0.25 m floor, and every coordinate is inflated — raw `-1.0 m` reads
as `-4.00` body lengths instead of `-1.79`. The **BODY lamp** on the device panel exists entirely
to make this visible in five seconds.

**6. Pickup latches for ever when the held value lands on a clip boundary.** "Release when the
movement *crosses* the held value" is not enough. The way a body actually leaves a side zone is by
bringing the hand back toward it, which drags the fader down to exactly `0.00` and freezes it
there — and `(value >= 0)` is then true for every possible value, so the side never changes and
the cell is dead after one use. Releasing on *reaching* the value (within ~0.005) fixes it. This
is worth writing up even though pickup was then removed: it is a clean example of a guard whose
degenerate case is invisible in the arithmetic.

**7. `#0` is not unique per `[p]` subpatcher.** It is substituted per *abstraction* instance, and
eight `[p mb_cell]` in one parent all share the parent's. Ableton's `exclusiveArm` works because
their mapping lives in a separate `.maxpat` file. Here the builder bakes a real integer into each
cell instead — `route 1` … `route 8` — which is deterministic and testable.

### A lenient test stub certifies a broken patch

Worth its own heading, because it is the sharpest limit of the whole replay method.

`verify_cells.py` reported **29/29 while the device could not map anything at all in Live.** The
stub for `live.object` accepted a bare number where Live needs `id <n>` — so the model was more
forgiving than reality, and the tests proved something that was not true.

The fix is to make the stubs **strict, and faithful to the failure**: an unset `live.object` now
answers nothing, and anything handed the wrong shape records a complaint that a test asserts on.
Re-running the broken build against the strict stubs gives 22/24 — it fails where it should.

> The rule this suggests: a stub at a boundary should be written to model what the real thing
> *refuses*, not only what it accepts. A stub that never says no cannot fail a test.

**It happened a third time, on 2026-10-06, and the third one is the clearest.** The stub answered
`getcount scenes` on `live.object`. Live has no such method there — it is a `live.path` method whose
reply leaves a different outlet — so the stepper could not read the scene count, every candidate
came out `(k + current) % 0` = 0, and **the device fired the first scene on every raise while the
suite reported 65/65**. The same stub was also lenient about `live.path`'s two id outlets, which hid
a second bug underneath the first.

What the three instances together say, and it is sharper than the original rule: **the replay
method's weak point is not the model of Max, it is the model of Live.** Max's semantics are few and
were got right early. The Live Object Model is large, and every stub of it is a guess that the
suite then treats as ground truth. Two mitigations actually worked here — write the stub from Max's
own **refpages** rather than from memory (`docs/refpages/m4l-ref/*.maxref.xml` inside Max.app, which
is where `getcount`'s outlet is stated outright), and make every stub **refuse** what Live refuses,
so the suite can fail. A third would have caught it sooner and costs nothing: when no shipped device
uses an API message — all 139 were scanned and none uses `getcount` — treat that as a sign to read
the reference, not as permission to guess.

### ⚠ AND IT HAPPENED A FOURTH TIME — THE STUB ANSWERED LIVE *IN LINE* (2026-10-06, later)

**The stepper still fired nothing at all in Live — not the first scene, not any scene — while the
suite reported 78/78.** This is the fourth instance, and it is the one that finally names the
mechanism rather than the symptom.

Max's refpages say it outright, in the description of **both** `live.path` and `live.object`:

> *"The Live API runs in the main thread in Live, and all messages to and from the API are
> **automatically deferred**."*

`[p mb_stepper]` asked Live for the scene count and banged the walk **from two branches of the same
`[t b b b]`** — ask on the middle outlet, walk on the left. That works only if `live.path` answers
*synchronously*, and the stub did exactly that: `s.emit(oid, 2, ['count', child, n])`, in line,
inside the same delivery. In Live the raise arrives in the **scheduler thread** — `[udpreceive
7400]` for a real body, `[metro 33]` for the mock auto-motion, both high priority — so every API
message is deferred to Live's main thread and the `count` reply lands **after** the walk has
already run with `[uzi 0]`'s own argument of 0. Zero candidates, zero fires, and the
"nothing playable" branch printing `no clips` on every raise.

**The giveaway was in the patch all along, and it was a single stale comment.** The harness
modelled `[deferlow]` as a pass-through with `# the model ignores deferral - a stated limit`.
The stated limit *was* the bug. A model that names what it does not simulate is still a model that
does not simulate it.

Two changes, and the second matters more than the first:

| | |
|---|---|
| **`[deferlow]` on the raise**, between `[sel 1]` and the arm/lock gates | moves the whole raise onto Max's main thread, where the Live API answers in line — which is the behaviour every other test in the suite describes |
| **the walk is started by the ANSWER**, not by a parallel branch | `[t i i]` → `[t b i i]`: store the count, set `uzi`'s length, *then* bang it. `[t b b b]` loses its third branch and becomes `[t b b]`. No ordering assumption is left to be wrong |

**`deferlow` and not `defer`:** `defer` passes through immediately when it is already on the main
thread, `deferlow` always re-enters from the queue. The stronger one is wanted here because the
raise can also come from a mouse-dragged mock slider, which *is* the main thread — and a guard
that behaves differently depending on which thread provoked it is the thing being fixed.

**`verify_cells.py` now models the deferral**, which is the part that keeps this fixed: `[deferlow]`
queues instead of passing through, `live.path`/`live.object` replies are held until the event ends,
and `flush()` is Live's main thread catching up. **TEST 32 asserts a deferred raise still fires, and
it was proven to fail on the pre-fix wiring — `fired == []`, nothing at all, which is exactly what
was reported.** 105/105 now.

> The rule the fourth instance adds, and it generalises past Live: **a stub must model the
> boundary's *timing*, not only its vocabulary.** Getting every message name and outlet right still
> certified a device that could not work, because the one thing the stub got wrong was *when* the
> answer comes back. Asking a question and reading its answer in the same event is an assumption —
> write it down, or have a test that breaks when it is false.

**Three model inaccuracies were found and closed on the same round**, two of them while chasing a
single stray decimal point. They are listed because each one is the kind that hides a real fault:

| The model used to | Max actually | Why it mattered |
|---|---|---|
| treat `[deferlow]` as a pass-through, commented *"the model ignores deferral - a stated limit"* | hand the message to the **main thread** | the stated limit *was* the bug — see above |
| pass a value through `[t i]` / `[t f]` untouched | **cast**, and on a list take the **first element** | the second half is the whole `mb_body` mock-slider trap, which the model could not have caught |
| substitute every `expr` variable as a float, `$i` included | `$i` is an **int** variable and an `$i` expression returns an **int** | `[sprintf %ld]` is fed from one, so the scene readout would have shown `1.` in Live. The modulo in the candidate walk is also an `$i` expression |

The last two were caught by a test asserting on a console string — `fired 1` — rather than on a
number, and `'fired 1' in printed` was false for `'fired 1.0'`. **Asserting on the text a device
reports catches type errors that asserting on its values cannot**, because a comparison like
`1 == 1.0` is true and a printed line is not.

### ⚠ A FIFTH TIME — AND THIS ONE WAS IN THE MODEL OF **MAX**, NOT OF LIVE (2026-10-06)

The four instances above all end up blaming the model of *Live*, and the fourth one says so
outright: the replay method's weak point "is not the model of Max, it is the model of Live."
**That is now wrong twice over.** The fifth instance is a Max object, and it is the single object
that decides whether the device's output is smooth.

`verify_cells.py` modelled `[line~]` as a **pass-through**:

```python
elif t.startswith('line~'):
    s.emit(oid, 0, v[0] if isinstance(v, list) else v)      # takes the target, drops the TIME
```

A cell sends `[pack 0. <ramp>]` → `[line~]` → `[live.remote~]`, so every frame hands `line~` a
target **and a time to get there in**. The model took the target and threw the time away. Three
things followed, and none of them showed up as a failing test:

- **The suite could not see the output ramp at all.** No test could measure the shape of what
  actually reaches Live, so "99/99" was never evidence about smoothness — the property most of
  the zone layer exists to provide.
- **The ramp length was unguarded.** It could be set to anything and the suite still printed a
  full house, because the suite replays whatever the patch says.
- **It certified a false claim.** "ATTACK 0 restores the previous instant behaviour exactly" —
  see the correction above. Instant was an artefact of the pass-through; the device never did it.

> **The honest rule, replacing the fourth instance's version:** it is not Live that is the weak
> point, it is **every boundary the model simplifies in order to be a model** — and a comment
> admitting the simplification is not a mitigation. The fourth instance already wrote the right
> sentence (*"a stub must model the boundary's timing, not only its vocabulary"*) and then scoped
> it to the Live API. It applies to Max's own objects too. **Anything with a duration in it is a
> boundary with timing**, and `[line~]`, `[line]`, `[del]` and `[deferlow]` are all of them.

**What was wrong underneath it, once the model could see:** the ramp was **20 ms** while the camera
delivers a frame every **31–38 ms**, so `line~` arrived early and then sat **flat for 11–18 ms** —
a staircase whose tread length wobbled by about a third along with the camera. The parameter moved
unevenly while the arm moved smoothly, which is what the performer reported as jitter. The ramp is
now **`OUTPUT_RAMP_MS = 40.0`** in `zone_constants.py` — just past the 38 ms worst case, so
consecutive ramps overlap and there is no flat spot left.

**Two tests came out of it, and both were proven able to fail**, which is the only reason they are
worth anything:

| Test | Asserts | Proven to fail by |
|---|---|---|
| `verify_cells.py` **TEST 0** | all 8 cells ramp over `OUTPUT_RAMP_MS`, read back by walking to `[line~]` | changing the constant without re-running `build_cells.py` |
| the same test's second check | the ramp is still moving for **the whole 38 ms worst-case gap** | the old 20 ms — it reports `moving 20 of 38 ms` |

**A side effect worth knowing: overlapping ramps CONVERGE rather than land.** Each frame re-aims
`line~` over 40 ms but only ~33 ms passes, so the output closes most of the remaining gap each
time and approaches the target geometrically instead of hitting it. That is not a defect — it is
the thing that removes the flat spots — but it is why TEST 16 and TEST 20 now assert convergence
to 1e-3 (0.1% of a normalised parameter, well under Live's own resolution) **and** that the value
lands exactly once frames stop. Both tests gained an assertion rather than losing one.

### Do not re-serialise a .maxpat with sorted keys

Max writes its JSON in insertion order with 4-space indent and no trailing newline. Rewriting the
file with `json.dump(..., sort_keys=True)` reorders every key in all ~800 objects: functionally
harmless, but it turns the git diff into thousands of lines and destroys the ability to review the
change — in a project where reading the JSON *is* the verification method.

Load with `object_pairs_hook=collections.OrderedDict` and dump with `indent=4` and no `sort_keys`.
Then confirm semantically rather than trusting the line diff: parse both versions and check that
every pre-existing box and patchline is byte-identical.

### Verify Max patches by capturing their UDP output

The same rule already stated for the Windows app applies to the Max side, for a different reason: reading a patch does not tell you what it does, and the GUI does not show mis-wiring like the above. Bind a socket to the port, decode, and check the value *ranges* against what the maths predicts.

Two practical notes from doing this:

- **A listener on 7500 must bind before Max does.** Max's `udpreceive` takes the loopback unicast stream, and a second socket co-bound afterwards with `SO_REUSEPORT` receives **nothing** — which reads as "the controller is sending nothing at all" when the controller is perfectly healthy. Send yourself a canary packet to prove the listener works before trusting a zero. Broadcast traffic on 7400 does not have this problem: every bound socket gets a copy.
- **Max restores previously-open patches after a hard kill.** A stale test copy silently re-opened and streamed to the same port alongside the new one, producing an interleaved mess of two value streams that looked like a logic bug. Delete scratch patches, don't just close them.
- A synthetic Kinect replay is easy and worth having: build the same bundle `OscSender.cs` builds — 25 joints plus `/mb/tracked` — and send it to 7400 at 30 Hz. It comes out at exactly **1144 bytes**, which is a free check that your replay matches the real contract.

## The auto-updater — and its one sharp edge

`tools/sync-loop.ps1` polls `origin/main` every 30s (via a cheap `git ls-remote` SHA check). When the remote moves it: `git fetch` → **verifies `origin/main` actually advanced** → kills `MoveBeat.exe` → `git reset --hard origin/main` → **verifies HEAD landed on the remote SHA** → rebuilds → relaunches.

**Kill before build is mandatory** — a running exe holds a lock on its own output file and the build fails with MSB3021.

**But kill only after the update is known to be applicable** (fixed 2026-08-18). The original order was kill → fetch → reset → build, and *no git exit code was ever checked* — `Invoke-Git` stored the status in `$script:GitExitCode` and nothing read it. So if `fetch` failed, or if `origin/main` never advanced, `reset --hard origin/main` quietly reset to the **old** SHA, HEAD never reached the remote SHA, and the next poll saw the identical "change" again. The result is a loop that **kills and relaunches the Kinect app every cycle, forever**, while the log cheerfully reports a successful update.

The `origin/main`-did-not-advance case is not hypothetical: `git fetch origin main` updates `refs/remotes/origin/main` only *opportunistically*, and does not do so at all if the remote has no fetch refspec configured (a `--single-branch` clone, or a hand-added remote). Check with `git config --get-all remote.origin.fetch`.

Three guards now make that loop impossible:

| Guard | What it stops |
|---|---|
| Fetch + verify **before** `Stop-MoveBeat` | A failed git cycle can no longer kill the app at all |
| A remote SHA that will not apply is **parked** after 3 attempts | Endless retries of one bad SHA |
| Churn brake: >4 update cycles in 10 min → updates pause for 30 min | Any other cause of repeated kill/relaunch |

**The period of this loop was ~30s + build time, never 10s** — worth knowing when matching a symptom to a cause.

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
- A **frame watchdog** reports `NO FRAMES for Ns` after 5 seconds of silence. This distinguishes the two faults that look identical on screen: "nobody is in view" versus "the sensor is not streaming at all". It logs only the *transitions* — stalled, then resumed — so a sensor that drops and recovers on a cycle is visible as a series of timestamped pairs.
- **`tools/logs/movebeat.log`** (added 2026-08-18) records startup with PID, every `IsAvailable` transition with uptime, frame stalls and recoveries, OSC send failures, and any unhandled exception. Before this the app had no log at all, so "it crashed" left nothing behind and every diagnosis was guesswork.
- **Read those values from the app's own visible window, not from redirected output** — see the testing trap above.

## The Kinect doctor — diagnosing the PC from the Mac (2026-08-18)

Built because the fault is on the Windows machine and the work happens on the Mac. It answers one question: **is the process dying, or is the sensor dropping?** Those look identical from a distance and have no fix in common.

| Piece | Where | What it does |
|---|---|---|
| `tools/kinect-doctor.ps1` | PC | Watches `MoveBeat.exe`, the sensor's PnP device, `KinectMonitor` and the Windows event log. Reports every transition. |
| `tools/mac/kinect-doctor-listen.py` | **Mac** | Receives that stream, prints it live, keeps score, and states a verdict. |

On the Mac:

```bash
python3 tools/mac/kinect-doctor-listen.py
```

### Three design points worth keeping

**It is a separate process, deliberately.** A process cannot report its own crash. The interesting moment is the one where `MoveBeat.exe` stops existing, and only something still running can describe it. The doctor outlives the app it watches — that is the whole point, so do not "simplify" it into the C# app.

**It is started by `MoveBeat.exe`, and that is not arbitrary.** With nobody at the PC, the only thing that runs freshly-pulled code is the executable: the auto-updater rebuilds and relaunches it on every push, but it never invokes a new script. A `.ps1` added to the repo sits on disk unexecuted until someone logs in. So `Program.StartDoctor()` spawns it, guarded by a mutex so a crash loop still produces only one doctor. `--no-doctor` skips it.

**It reports on port 7401, never 7400.** 7400 carries the joint stream into Max. The doctor can run while the synth is playing.

### Reading the verdict

The listener reaches one of these on its own:

- **THE PROCESS IS RESTARTING** — three or more starts. If Windows recorded a crash, it is *faulting* and the `CRASH` lines name the module and exception. If there is no crash record it *exited cleanly*, so something closed it on purpose — check `sync.log` for the auto-updater.
- **THE SENSOR IS DROPPING OFF USB** — the device changed state repeatedly while the process stayed up. Hardware: USB bandwidth, the sensor's power brick, or USB selective suspend. Nothing in this repo will fix it.

Restart intervals are computed from **the PC's clock**, taken from the packet, not from arrival time — otherwise network delay would be reported as restart timing, which is the one number the tool exists to get right.

### Its limits, stated plainly

The Mac must be on the **wired `192.168.0.x` LAN** — same requirement as the music path; Wi-Fi receives nothing. If the Mac is off or unreachable, the PC still writes everything to `tools/logs/kinect-doctor.log`. And the doctor only starts once `MoveBeat.exe` has restarted at least once after the push that delivers it.

### "It crashes every few seconds and restarts itself" — how to tell what is actually happening

Four completely different faults produce that same description, and they are told apart by **one command**, not by guessing:

```powershell
Get-Content C:\dev\MoveBeat\tools\logs\movebeat.log -Tail 40
```

| What the log shows | What is actually happening |
|---|---|
| Repeated `MoveBeat starting. PID=…` with a **new PID** each time | The **process** really is dying and being relaunched. The preceding `UNHANDLED EXCEPTION` line says why. |
| **One** PID, but repeated `Sensor IsAvailable -> False` / `-> True` | The **sensor** is dropping and re-enumerating. The process never restarted. This is USB bandwidth, the power adapter, or a USB selective-suspend setting — not code. |
| One PID, repeated `NO FRAMES for Ns` then `Frames RESUMED` | The sensor is attached but the stream stalls. Same hardware family of causes. |
| Nothing repeating in this log, but `sync.log` shows repeated `Relaunched MoveBeat.exe.` | The **auto-updater** is doing it — see the sharp-edge section above. |

Cross-check the last row with:

```powershell
Get-Content C:\dev\MoveBeat\tools\logs\sync.log -Tail 40
```

A healthy poller prints `No change (HEAD=…)` every 30s and nothing else. Any other repeating pattern there is the updater's fault.

### Why a transient error used to kill the whole process (fixed 2026-08-18)

`BodyReader_FrameArrived` runs on a **Kinect-owned background thread** 30 times a second. On .NET Framework an exception escaping a background thread terminates the process immediately — so a single bad frame or a single failed UDP send took the entire app down, with no message anywhere.

`osc.Send()` was the live hazard, for a genuinely non-obvious Windows reason: when a UDP datagram reaches a host with nothing listening on the port, that host replies **ICMP Port Unreachable**, and Windows raises it against the *sending* socket as `SocketException` (WSAECONNRESET, 10054) on a **later** call. So "the Max patch isn't open yet" surfaces as an exception thrown inside the 30 Hz frame callback — i.e. as an app that dies seconds after starting, repeatedly, and looks exactly like a hardware fault.

Both halves are fixed: `SIO_UDP_CONNRESET` is switched off on the socket (this stream is fire-and-forget; whether anyone is listening is none of the sender's business), and `SafeSend` absorbs and rate-limits what is left. Losing packets while a cable is out is the correct behaviour for a control stream — taking the process down for it is not.

### The stdin trap has a second, worse half

`CLAUDE.md` already warned that `Start-Process -RedirectStandardOutput` leaves stdin as the null device, so `Console.ReadLine()` returns instantly and the app exits within milliseconds. The part that was not written down: the app then **exits**, and anything that relaunches it produces a perfect imitation of a crash-restart loop.

`WaitForExitKey()` now checks for `null` — meaning "no interactive stdin" — logs it, and **keeps streaming** instead of exiting. Having no keyboard attached is not a reason for a streaming app to stop.

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
    MoveBeatSynth.maxpat     THE SOURCE. Open this to edit or to play standalone
    MoveBeatSynth.amxd       GENERATED by build_devices.py — never hand-edit
    mb_voice.maxpat          one poly~ voice (loaded by name, never opened directly)
  controller/        THE MOVEMENT DEVICE
    MoveBeatController.maxpat  THE SOURCE. Kinect OSC + mock body + 6-slot matrix
    MoveBeatController.amxd    GENERATED by build_devices.py — never hand-edit
  dsp/*.genexpr      gen~ core: oscillators, drive, Moog ladder filter
  docs/              ARCHITECTURE.md — parameter list and design rationale
                     MAPPING.md     — movement→parameter contract, tuning guide
                     ZONES.md       — THE ZONE LAYER + THE ABLETON PLAN. Read this for
                                      anything zone-, trigger- or Live-related
    verification/    zone_constants.py   — THE source for every zone threshold, delay,
                                      span and ramp time, with the reasoning. Everything
                                      else imports it, tests included. Change a zone
                                      number HERE — including OUTPUT_RAMP_MS, the ramp
                                      into live.remote~ that decides whether the output
                                      has flat spots in it
                     tune_zones.py       — writes those numbers into [p mb_zones] in place,
                                      by walking the graph. Idempotent. RUN IT FIRST
                     verify_body.py, verify_zones.py, verify_cells.py — replay the real
                     .maxpat graphs
                     build_zone_layer.py — built mb_body + mb_zones once, in August. NOT
                                      idempotent and cannot be re-run on the current patch;
                                      tune_zones.py is how their numbers change now
                     build_cells.py      — regenerates the eight mapping cells, the
                                      scene stepper and the mapping window. Idempotent.
                                      Takes the cell keys to build as arguments
                     build_devices.py    — generates both .amxd devices from the .maxpat
                     build_presentation.py — slot rows -> live.* parameters + the
                                      controller's presentation view. Idempotent.
                     VERIFICATION_REPORT.md, verify_filter.py — the DSP filter proof
  build/             PRE-SPLIT single-patch version. Still works, untouched.
                     BUILD_GUIDE.md is its historical construction record.
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
  kinect-doctor.ps1          PC-side watchdog: why did MoveBeat.exe die?
  mac/
    kinect-doctor-listen.py  MAC-side receiver + verdict (run this one)
    verify-body-lock/        the ONLY test the C# app has. Drives the real frame handler
                             against a stub of the Kinect API, so the body lock can be
                             checked on the Mac: ./run.sh, 6/6. Deliberately OUTSIDE
                             MoveBeat/ — the csproj globs **/*.cs and would compile the
                             stub into the app and break the PC build
  logs/                      sync.log, kinect-autostart.log, movebeat.log,
                             kinect-doctor.log, kinect-doctor-received.log (gitignored)
```

Two Startup-folder shortcuts are installed, independent of each other:
`MoveBeatAutoUpdate.lnk` (git poller) and `MoveBeatKinectApps.lnk` (Kinect apps).

`synth/docs/ZONES.md` is the reference for the zone layer, the nine mapping cells and the Ableton
Live plan — **read it before touching anything zone-related.**

`synth/docs/ARCHITECTURE.md` is the reference for the synth's parameter names (`cutoff`, `resonance`, `drive`, `pw`, `outgain`…) and the DSP design rationale. `synth/docs/MAPPING.md` is the reference for the movement→parameter contract and for where to tune what. **Read both before touching anything in `synth/`.**

## Known issues / open decisions

- **Fixed for now: the “crashes every ~10 s and restarts” symptom.** Reported 2026-08-18 from the PC
  and not reproducing since — a **~25 minute run with no crash**, against an original failure
  interval of about 10 seconds.

  The fixes landed as one batch: unhandled exceptions on the Kinect background thread,
  `SocketException` from `osc.Send` (with `SIO_UDP_CONNRESET` switched off), the watchdog null race,
  the null-stdin instant exit, and the auto-updater's kill-before-verify loop. **Which one was the
  actual cause is therefore not attributed** — and does not need to be unless it comes back. If it
  does, `tools/logs/movebeat.log` now records what settles it in one command; follow the table in the
  diagnosis section above.

- **Hop 1 is verified against real hardware. The 6-slot matrix is now verified in Live — but
  against the mock body, not the Kinect.** On 2026-08-18 the PC's stream was decoded live from the
  Mac: ~26 Hz, 1144-byte bundles from `192.168.0.101`, `/mb/tracked` = 1, and 24 of 25 joints at
  `trackingState` 2 with plausible coordinates. So the PC, the sensor, the wired LAN and the OSC
  encoder are all good end to end.

  On 2026-09-05 the matrix ran for the first time as a real M4L device: **three slots driving three
  separate synth parameters audibly at once**, inside Ableton. That retires the old "validated
  structurally only" caveat.

  **What is still untested: the two together.** Nobody has yet stood in front of the Kinect and
  heard the matrix respond. Every part of that path is independently verified, so this is expected
  to work — but "expected to work" is what the tracking-distance bug looked like too.

- **The zone thresholds are derived, and now revised once from a real report.** ⚠️ Still the most
  likely thing to be wrong. The side zones triggered at 1.15 body lengths from the spine (roughly
  58 cm), reasoned from anatomy; **2026-10-06 a performer found that unreachable in practice and it
  is now 0.75.** That was the first measurement of any kind against a body, and it moved the number
  by a third — so assume the remaining figures are wrong by about as much until someone dances in
  front of them. The risk has swapped direction too: at 0.75 the danger is the zone latching while
  standing still rather than being out of reach. The thresholds are one line in
  `synth/docs/verification/zone_constants.py`, then the three rebuild commands at the top of it.

- **The ABOVE threshold rides on `head.y`, and the head joint jitters.** Hysteresis covers small
  noise; a large head-tracking glitch moves the boundary and could fire a zone.

- **~~`Program.cs` still selects the first tracked body it finds.~~ Fixed 2026-10-06 — and it
  was a source of audible clicks, not just a theoretical risk.** `Program.cs` now locks onto a
  `TrackingId` and holds it while that body is still tracked, choosing again only when it is
  genuinely gone and then preferring the body nearest the sensor's centre line. **The asymmetry
  was the bug: losing the body was already guarded** (that path sends `/mb/tracked 0`, and the
  Max side holds faders and releases switches) **while swapping the body was not guarded at
  all** — every coordinate jumped to a different person while `/mb/tracked` stayed 1, so the Mac
  could not know and faithfully mapped the discontinuity. Verified by `tools/mac/verify-body-lock/run.sh`,
  **6/6**, which drives the real frame handler against a stub of the Kinect API and was proven
  to fail with the lock removed. **Still needs building on the PC** — it compiles on the Mac only
  against that stub. The original note read:

  Kinect v2 tracks up to six, and
  the index is neither stable nor meaningfully ordered, so **anyone walking behind the performer
  can take over the stream mid-piece.** It has never shown up because testing has been one person
  alone in a room; in performance it is exactly what will happen. The fix belongs on the PC and
  does not touch the OSC contract: lock onto a body and hold it until genuinely lost, preferring
  the one nearest centre when re-selecting. This is a capture question, not a musical one, so it
  does not violate the weak-machine rule.

- **The freeze rule is emitted but not wired.** `mb_zones` outputs the hand-busy pair; gating the
  two hand slots in the six-slot matrix means editing the verified path, and was deliberately left
  as its own step rather than bundled with new work.

- **~~`ARCHITECTURE.md` and `BUILD_GUIDE.md` still say Ableton is out of scope.~~ Fixed
  2026-09-05.** `ARCHITECTURE.md` now describes the patch-is-source / device-is-generated split;
  `BUILD_GUIDE.md` carries a banner marking it as the historical pre-split record. The DSP content
  of both was left alone — it did not change.

- **~~Slot settings do not survive a reload.~~ Two rounds of work, 2026-09-05.** The six rows and
  the synth's 24 panel controls are now `live.menu` / `live.numbox` with `parameter_enable`.
  `pattrstorage` was not needed.

  The first attempt **looked** right and failed on test: reopening a Set restored the body part and
  the synth parameter but reset MIN/MAX. Decoding the `.als` showed Live had saved everything
  correctly and the patch was overwriting it on load — see the `loadbang` section above. Both
  causes are fixed. **Still unconfirmed end to end:** nobody has yet saved a Set, reopened it, and
  seen every value survive.

  Note `parameter_initial_enable: 1` is not in tension with persistence: the initial applies when
  a *fresh* device is dragged in; a value stored in a Set overrides it on load.
- **`/movebeat/gate` does nothing but light an indicator.** On loss of tracking the sound freezes
  and drones. The zone layer has now answered this for its own half — release switches, freeze
  faders, block fire, let the loops keep playing — but nothing is wired for the synth's parameters.
- **`synth/build/MoveBeat_ableton_ves.amxd` — resolved 2026-09-05: keep it as history, never use
  it.** It is a divergent fork, not an export: a hand-edited near-copy of the *pre-split* patch
  with `notein`→`midiin` and `plugout~` swapped in by hand, carrying its own drifted parameter
  state and referencing `movebeat_voice` rather than `mb_voice`. The shipping devices are generated
  by `build_devices.py` from the split patches. This file is the standing example of why devices
  are generated and never hand-edited — which is worth more than the disk space it costs.
- **Fixed 2026-08-08:** the old `[p mb_mapping]` had a dangling right-hand-X gate, so `resonance` computed `abs(0 − lefthand.x)` and tracked one hand's distance from centre rather than the spread between the hands. Fixed in the old patch too, not only in the new controller.
