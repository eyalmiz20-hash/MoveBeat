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
