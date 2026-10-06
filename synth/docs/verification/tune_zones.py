#!/usr/bin/env python3
"""
tune_zones.py - writes the numbers in zone_constants.py into [p mb_zones], in place.

WHY THIS SCRIPT EXISTS AND build_zone_layer.py DOES NOT DO IT

build_zone_layer.py INSERTED mb_body and mb_zones into the controller once, in August.
It is not idempotent and cannot be re-run: it appends rather than replaces, references
root objects by hard-coded id, and build_cells.py in turn addresses mb_zones by its id
(obj-180).  Re-running it would produce a second copy of both subpatchers and leave the
cells wired to the old one.

So the thresholds live inside a patch that its own builder can no longer regenerate.
This script closes that gap: it finds the real objects by WALKING THE GRAPH - never by
id and never by position - and rewrites only their arguments.  It is idempotent by
construction (it writes a whole text from a template rather than editing the old one),
so three runs produce identical bytes, and it is safe to run every time.

    python3 synth/docs/verification/tune_zones.py        then build_cells.py, build_devices.py

HOW EACH OBJECT IS IDENTIFIED

    the two ABOVE tests     expr $f1 > $f2 + <enter> - $f3 * <band>
    the four SIDE tests     expr ($f1 * <sign> > <enter> - $f3 * <band>) * (1 - $f2)
    a zone's commit delay   from its state expr - expr ($i1 + 2 * $i2) * $i3 - forward
                            through [change] -> [t b i] -> [del N], and backward through
                            the [t i i] on inlet 0 to whichever test feeds it.  That
                            backward walk is what says which of the three zones this is;
                            the sign in a SIDE test separates left from right.
    the grace timer         the one [del] no zone chain reaches.

If the graph ever stops matching, this script fails loudly with what it expected rather
than writing a half-tuned patch.
"""

import json, collections, os, re, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import zone_constants as Z

OD = collections.OrderedDict
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..')
P = os.path.join(ROOT, 'synth', 'controller', 'MoveBeatController.maxpat')

# What each object's text becomes.  One template per kind, so a rerun rewrites rather
# than edits and the result cannot drift.
ABOVE_T = 'expr $f1 > $f2 + {enter} - $f3 * {band}'
SIDE_T = 'expr ($f1 * {sign} > {enter} - $f3 * {band}) * (1 - $f2)'
STATE_T = 'expr ($i1 + 2 * $i2) * $i3'

ABOVE_RE = re.compile(r'^expr \$f1 > \$f2 \+ [-0-9.]+ - \$f3 \* [-0-9.]+$')
SIDE_RE = re.compile(r'^expr \(\$f1 \* (-?1) > [-0-9.]+ - \$f3 \* [-0-9.]+\) \* \(1 - \$f2\)$')

changes = []


def fail(msg):
    print('FAIL: ' + msg)
    sys.exit(1)


def set_text(box, text, what):
    if box.get('text') != text:
        changes.append('%-26s %s' % (what, text))
        box['text'] = text


def main():
    doc = json.load(open(P), object_pairs_hook=OD)
    root = doc['patcher']

    zones = [b['box'] for b in root['boxes'] if b['box'].get('text') == 'p mb_zones']
    if len(zones) != 1:
        fail('expected exactly one [p mb_zones] in the root patch, found %d' % len(zones))
    sub = zones[0]['patcher']

    BOX = {b['box']['id']: b['box'] for b in sub['boxes']}
    FAN = {}                     # (src id, outlet) -> [(dst id, inlet)]
    BACK = {}                    # (dst id, inlet)  -> [(src id, outlet)]
    for l in sub['lines']:
        pl = l['patchline']
        FAN.setdefault(tuple(pl['source']), []).append(tuple(pl['destination']))
        BACK.setdefault(tuple(pl['destination']), []).append(tuple(pl['source']))

    def text(i):
        return BOX[i].get('text', '') or ''

    # ---- the six zone tests ------------------------------------------------
    band_above = Z.fmt(Z.ABOVE_ENTER - Z.ABOVE_LEAVE)
    band_side = Z.fmt(Z.SIDE_ENTER - Z.SIDE_LEAVE)

    kind = {}                    # test object id -> 'above' | 'left' | 'right'
    for i, b in BOX.items():
        t = text(i)
        if ABOVE_RE.match(t):
            set_text(b, ABOVE_T.format(enter=Z.fmt(Z.ABOVE_ENTER), band=band_above),
                     'ABOVE test')
            kind[i] = 'above'
            continue
        m = SIDE_RE.match(t)
        if m:
            sign = m.group(1)
            set_text(b, SIDE_T.format(sign=sign, enter=Z.fmt(Z.SIDE_ENTER),
                                      band=band_side), 'SIDE test (sign %s)' % sign)
            # build_zone_layer.py writes the RIGHT zone as (x * +1 > enter) and the LEFT
            # zone as (x * -1 > enter): the sign is the zone.
            kind[i] = 'right' if sign == '1' else 'left'
    if sorted(kind.values()) != ['above', 'above', 'left', 'left', 'right', 'right']:
        fail('expected two tests per zone, found %r' % sorted(kind.values()))

    # ---- each zone's commit delay ------------------------------------------
    # From the state expr: back through the [t i i] on inlet 0 to the test that feeds it
    # (which names the zone), and forward through [change] -> [t b i] to the [del].
    commit_dels = {}
    for i in list(BOX):
        if text(i) != STATE_T:
            continue
        up = [s for s, _ in BACK.get((i, 0), [])]
        zone = {kind[s] for t in up for s, _ in BACK.get((t, 0), []) if s in kind}
        if len(zone) != 1:
            fail('state expr %s does not trace back to exactly one zone (%r)' % (i, zone))
        zone = zone.pop()

        step = [d for d, _ in FAN.get((i, 0), []) if text(d).startswith('change')]
        step = [d for s in step for d, _ in FAN.get((s, 0), []) if text(d).startswith('t b i')]
        dels = [d for s in step for d, _ in FAN.get((s, 0), []) if text(d).startswith('del ')]
        if len(dels) != 1:
            fail('%s zone: expected one commit [del], found %r' % (zone, dels))
        commit_dels[zone] = dels[0]
        set_text(BOX[dels[0]], 'del %d' % Z.commit(zone), '%s commit' % zone.upper())
    if set(commit_dels) != {'above', 'left', 'right'}:
        fail('did not find all three commit delays: %r' % sorted(commit_dels))

    # ---- the grace timer: the one [del] no zone chain reaches ---------------
    grace = [i for i in BOX if text(i).startswith('del ') and i not in commit_dels.values()]
    if len(grace) != 1:
        fail('expected exactly one non-commit [del] (the fire re-arm), found %r' % grace)
    set_text(BOX[grace[0]], 'del %d' % Z.GRACE, 'fire re-arm')

    # ---- the comments that quote the numbers -------------------------------
    # A patch whose comments contradict its objects is worse than one with no comments.
    for i, b in BOX.items():
        if b.get('maxclass') != 'comment':
            continue
        t = text(i)
        if t.startswith('THRESHOLDS'):
            set_text(b, 'THRESHOLDS (body lengths):  ABOVE enter head+%s leave head+%s'
                        '   SIDE enter %s leave %s'
                     % (Z.fmt(Z.ABOVE_ENTER), Z.fmt(Z.ABOVE_LEAVE),
                        Z.fmt(Z.SIDE_ENTER), Z.fmt(Z.SIDE_LEAVE)), 'comment THRESHOLDS')
        elif t.startswith('TIMING'):
            set_text(b, 'TIMING: hand-count commit %d ms ABOVE / %d ms the sides'
                        '   fire re-arm after tracking returns %d ms'
                     % (Z.COMMIT_ABOVE, Z.COMMIT_SIDE, Z.GRACE), 'comment TIMING')
        elif t.startswith('walking back into frame'):
            set_text(b, 'walking back into frame through a side zone must not advance '
                        'the song: %d ms' % Z.GRACE, 'comment re-arm')
        else:
            m = re.match(r'^(ABOVE|LEFT|RIGHT): 0 none, 1 left, 2 right, 3 both'
                         r' - committed after ', t)
            if m:
                zone = m.group(1)
                set_text(b, '%s: 0 none, 1 left, 2 right, 3 both - committed after '
                            '%d ms so that' % (zone, Z.commit(zone)),
                         'comment %s' % zone)

    if not changes:
        print('mb_zones already matches zone_constants.py - nothing written')
        return
    with open(P, 'w') as f:
        json.dump(doc, f, indent=4)       # insertion order, no sort_keys - CLAUDE.md
    print('retuned [p mb_zones] from zone_constants.py:')
    for c in changes:
        print('   ' + c)


if __name__ == '__main__':
    main()
