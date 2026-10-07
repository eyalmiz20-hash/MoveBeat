#!/usr/bin/env python3
"""
zone_constants.py - THE one place the zone geometry and timing live.

Until 2026-10-06 these numbers appeared in five files: build_zone_layer.py built them
into [p mb_zones], build_cells.py baked the spans into each cell, and verify_zones.py /
verify_cells.py each repeated them as literals in their assertions.  Changing one meant
finding all five, and the tests would still have passed if a file had been missed -
they were asserting their own copy of the number, not the patch's.

Everything imports this module now, tests included.  verify_zones.py also reads the
thresholds back out of the patch and fails if they disagree with what is written here,
so forgetting to re-run tune_zones.py is a loud failure rather than a silent one.

    REBUILD ORDER, all three, from the repo root:
        python3 synth/docs/verification/tune_zones.py
        python3 synth/docs/verification/build_cells.py abvL abvR lftL lftR lftB rgtL rgtR rgtB
        python3 synth/docs/verification/build_devices.py


WHERE THESE NUMBERS COME FROM

Everything is in BODY LENGTHS - the spinebase-to-spineshoulder distance mb_body divides
by - so one number means the same gesture for any performer at any distance.  For a
typical adult one body length is 0.45-0.50 m, and that is the scale the figures below
are reasoned in:

    shoulder half-width   ~0.36 body lengths      arm, shoulder to hand   ~1.40
    hand hanging at rest  ~0.36 out to the side   hand, arm horizontal    ~1.76

mb_body clamps the scale to [0.25, 0.70] m, and a performer whose spine reads near the
top of that clamp has a SMALLER reach in body lengths - about 1.26 to the side instead
of 1.76.  The spans below are chosen to stay inside that pessimistic figure, because the
failure that costs a cell is a span the arm cannot finish: it normalises to a constant,
the knob pins, and nothing on screen says why.

BUT THE MODEL IS NOT THE MEASUREMENT.  The arithmetic above says the OLD numbers wasted
about a third of the knob's travel; the user, dancing in front of the sensor, measured
two thirds.  So the figures here are reasoned, not observed, exactly as CLAUDE.md says
of the thresholds themselves - and when they disagree with a dancer, the dancer is right.
Nothing in verify_cells.py asserts reachability for that reason: it checks what IS
provable, that each span lies inside the zone that switches its cell on and starts
exactly at that zone's edge.
"""

# --------------------------------------------------------------- zone thresholds
#
# ABOVE is relative to the head; SIDE is |x| from the spine base.  Enter / leave differ
# so every boundary is a Schmitt trigger: a hand resting on a threshold at 30 Hz must
# not chatter.  The band is 0.15 body lengths, about 7 cm, in both zones.

ABOVE_ENTER = 0.15          # head.y + this
ABOVE_LEAVE = 0.00          # head.y + this

# Widened 2026-10-06, on the user's report after the first session in Live: entry at
# 1.15 needed the arm almost horizontal, and the knob then reached only ~0.3 of its
# range because 1.79 - a locked-out arm - was never actually achieved.
#
#   0.75 enter:  the arm raised 16-29 degrees out from the body, depending on scale.
#                A hand hanging at rest sits at ~0.36, so there is clear daylight
#                between standing still and entering the zone.
#   0.60 leave:  the same 0.15 band the ABOVE zone uses.
SIDE_ENTER = 0.75           # was 1.15
SIDE_LEAVE = 0.60           # was 1.00

# --------------------------------------------------------------- timing, in ms
#
# The commit delay exists for ONE reason: both hands never cross a threshold in the same
# millisecond, so a two-hand gesture would fire the one-hand cell on its way in.  It is
# paid on every entry, which is the "it enters with a delay" the user reported.
#
# It is worth paying where a wrong answer advances the song, and not worth paying where
# it moves a knob - so it is now per zone rather than one number for all three.
COMMIT_ABOVE = 200          # the scene stepper lives here: a raise must be unambiguous
COMMIT_SIDE = 60            # was 200.  Two frames at 30 Hz, and below the ~100 ms where
#                             a gesture starts to feel late.
#
#                             WHAT IT COSTS, measured rather than assumed.  The commit
#                             timer RESTARTS on every change of hand count, so a two-hand
#                             entry whose hands land within 60 ms of each other still
#                             never flashes the one-hand cell.  Land further apart and
#                             the one-hand cell does go live, for as long as the gap -
#                             and a FADER keeps whatever it reached.  The attack envelope
#                             is what makes that survivable: verify_cells.py TEST 19
#                             measures a two-frame flash at 15% of the way across with a
#                             250 ms attack, against 100% - a full jump - without it.
#                             Raise ATTACK and the slip falls; the two numbers trade.

GRACE = 1000                # fire re-arms this long after tracking returns

# ------------------------------------------------- the valid de-bounce, added 2026-10-07
#
# GRACE exists so that walking back into frame cannot advance the song.  It was driven
# straight off `valid`, and that turned out to be the fault behind "the two-hands raise
# does not register consistently" - measured, not reasoned:
#
#   valid demands all FIVE joints at trackingState exactly 2, every frame, and a live
#   stream from a real body drops one of them about ONCE A SECOND - usually a hand
#   crossing the torso or the head joint wobbling.  The old chain blocked the fire the
#   instant valid fell and then needed GRACE = 1000 ms of UNINTERRUPTED valid to re-arm,
#   so the timer was being reset about as often as it could complete.  Driving the real
#   mb_body -> mb_zones graphs from the live stream showed the fire BLOCKED for 40
#   seconds straight, and an abvB rising edge arriving inside a blocked window with no
#   trace anywhere - the raise reached the stepper and was refused in silence.
#
# So `valid` now has to be LOW for this long before the zone layer will call it loss of
# tracking.  A one-frame blip costs nothing at all; a performer leaving the frame still
# blocks the fire exactly as before.
#
# RAISED FROM 250 TO 500 the same day, and the reason is a measurement rather than a
# preference.  At 250 the blips were covered - BLOCKED events over a whole session fell
# from 12-in-51-seconds to 2 - but one of the two survivors was this, from the live
# stream driving the real graphs:
#
#     14:42:42  valid 1 -> 0   not tracked: handleft
#     14:42:43  fire-arm -> BLOCKED              <- the de-bounce called it a real loss
#     14:42:45  abvB RISING EDGE ... NOT ARMED   <- the raise fell inside the 1000 ms
#
# A single hand vanishing for 300-500 ms is not the performer leaving the room, but at
# 250 it was being counted as one, and the raise two seconds later paid 250 + GRACE =
# 1250 ms for it.  500 ms covers the hand dropouts that were actually measured.
#
#   500 ms   about 15 frames at 30 Hz.  The cost is that a genuine walk-out takes half
#            a second to register as loss instead of a quarter - and half a second of a
#            stale held pose does no damage, because nothing can fire from it: the
#            coordinates simply stop changing.
#
# This is a DIFFERENT KIND of number from the ones above: those are geometry, this one
# is a statement about how noisy the sensor is.  If a future camera is cleaner it can
# come down; if a raise ever fires while the body is genuinely gone, it is too high.
#
# The proper fix, declined for now and worth recording: GRACE is guarding against
# walking back INTO FRAME, which is a BODY event, so the fire-arm should be driven by
# /mb/tracked rather than by `valid` - a hand going inferred should not enter into it at
# all.  mb_body folds /mb/tracked into `valid` and does not pass it through separately,
# so that means widening the pack between the two subpatchers and the unpack that reads
# it: a deeper change to the verified path than a constant, for a deadline this close.
LOST_DEBOUNCE = 500

# --------------------------------------------------------------- the attack envelope
#
# Entering a zone used to step the knob to FROM in one frame.  Now the cell crossfades
# from where the knob was to where the movement says it should be, over ATTACK_MS, on a
# smoothstep curve - flat at both ends, so there is no corner at the start and none on
# arrival.  This is the ADSR attack the user asked for, applied to the entry rather than
# to an amplitude.  0 ms restores the old instant behaviour exactly.
#
# Exposed as ATTACK on the mapping window, because it is a feel parameter and no amount
# of arithmetic settles it - it gets dialled in while dancing.
ATTACK_MS = 250.0           # default
ATTACK_MAX = 2000.0

# ------------------------------------------------- the output ramp into live.remote~
#
# A cell's value reaches Live as [pack 0. OUTPUT_RAMP_MS] -> [line~] -> [live.remote~],
# so every frame hands line~ a new target AND a time to get there in.  That time has to
# be at least as long as the gap between two frames, and this is the whole reason:
#
# The camera runs 26-32 Hz - a gap of 31-38 ms that varies from frame to frame.  At the
# old 20 ms the ramp ARRIVED and then sat flat for the remaining 11-18 ms, so the output
# was a staircase whose tread length wobbled by about a third along with the camera: the
# parameter moved unevenly while the arm moved smoothly, which is exactly what a
# performer hears as jitter.  A ramp longer than the longest gap never arrives early, so
# consecutive ramps overlap and the output has no flat spots in it at all.
#
# 40 ms clears the 38 ms worst case.  The cost is 40 ms of smoothing lag behind the hand,
# which against the 250 ms ATTACK and the speed of a dance gesture is not felt.  Raising
# it smooths more and lags more; below about 38 the flat spots come back.
#
# Stated limit: this is reasoned from the 26-32 Hz capture figure, NOT measured at the
# output - and until 2026-10-06 it could not have been, because verify_cells.py modelled
# [line~] as a pass-through and so could not see the ramp at all.  The better version
# measures the real inter-frame interval and sets the ramp from it, so it follows a
# camera that is running slow.  Not built: one constant was the change that could be
# proven before the deadline.
OUTPUT_RAMP_MS = 40.0

# --------------------------------------------------------------- movement spans
#
# Each cell's span per source axis, as (lo, hi) in body lengths: lo is where the zone
# begins, hi is as far as the gesture goes.  Baked into each cell by build_cells.py
# rather than exposed - the zone already decides the span, so there is nothing to
# calibrate and no SET RANGE button.
#
# lo for a side cell's X is SIDE_ENTER by construction: the knob must sit at FROM at
# the instant the zone switches on, and that instant IS x = SIDE_ENTER.  Derive it,
# never retype it, or a change to the threshold silently leaves a step at the edge.
#
# SIDE, revised 2026-10-06 - all four axes, not just X.  Y and SPREAD were carrying the
# ABOVE zone's figures, and both were unreachable from a side zone:
#
#   X       0.75 .. 1.35   from the zone edge to a comfortably extended arm (45 deg at a
#                          typical scale).  NOT 1.79: that is a locked-out arm, and
#                          chasing it is what wasted two thirds of the knob's travel.
#   Y      -0.20 .. 1.30   a hand out to the side sweeps from below the hip to just
#                          under the head - above the head it leaves for ABOVE.  The
#                          old 1.60 .. 2.40 is ABOVE's span and lies entirely outside
#                          this zone, so picking Y on a side cell pinned the knob dead.
#   Z      -0.50 .. 0.50   half a body length forward and back.  An arm committed
#                          sideways cannot also reach a full body length of depth, which
#                          is what the old -1.00 .. 1.00 asked for.
#   SPREAD  0.20 .. 1.60   both hands are on the SAME side here, so they are never far
#                          apart: together at 0.20, one high and one low at ~1.60.  The
#                          old 1.00 .. 3.00 is two arms opened wide - impossible inside
#                          one side zone, and lftB / rgtB default to SPREAD, so both
#                          two-hand side cells were dead on arrival.
#
# ABOVE is unchanged.  It was not part of the report, and its Y span does start at the
# zone edge.  Its top (2.40, a fully stretched arm) has the same optimism the sides had:
# worth measuring against a real dancer before trusting it.
SPANS = {
    'ABOVE': [(-1.79, 1.79), (1.60, 2.40), (-1.00, 1.00), (1.00, 3.00)],
    'LEFT':  [(-SIDE_ENTER, -1.35), (-0.20, 1.30), (-0.50, 0.50), (0.20, 1.60)],
    'RIGHT': [(SIDE_ENTER, 1.35), (-0.20, 1.30), (-0.50, 0.50), (0.20, 1.60)],
}

AXES = ['X', 'Y', 'Z', 'SPREAD']


def commit(zone):
    """The hand-count commit delay for a zone name, in ms."""
    return COMMIT_ABOVE if zone.lower() == 'above' else COMMIT_SIDE


def fmt(v):
    """How a number is written into the patch.  %g, so 0.75 is '0.75' and not
    '0.750000', and so SIDE_ENTER - SIDE_LEAVE never lands in the patch as
    0.1499999999999999 the way it did before."""
    return '%g' % round(float(v), 6)
