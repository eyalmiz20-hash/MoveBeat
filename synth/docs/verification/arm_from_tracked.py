#!/usr/bin/env python3
"""
arm_from_tracked.py - drive the fire-arm from /mb/tracked instead of from `valid`.

WHY.  GRACE blocks the fire for a second after tracking returns, so that walking back
into frame cannot advance the song.  It was asking `valid`, which demands all FIVE
joints at trackingState exactly 2 - and driving the real mb_body -> mb_zones graphs from
a live stream, while the performer danced, measured this:

    10-11 drops per 10 seconds, EVERY ONE of them a hand
    14:57:42  not tracked: handright      14:57:45  not tracked: handright
    14:57:44  not tracked: handleft       14:57:47  not tracked: handright

and the drops last longer than 500 ms, so 23 fire-arm BLOCKED events in one session and
two abvB rising edges refused in silence.  A de-bounce cannot rescue this: short enough
to catch a real walk-out is shorter than these dropouts, long enough to forgive them
stops catching the walk-out.  The parameter cannot be right, because the QUESTION is
wrong - GRACE guards against re-entering the frame, which is a BODY event, and a hand
hidden behind a torso mid-dance is not the performer leaving the room.

/mb/tracked is that body signal, and the PC already sends it every frame.  mb_body folds
it into `valid` (valid = tracked AND all five joints) and does not pass it through, so
this widens the list between the two subpatchers by one slot to carry it.

WHAT IT CHANGES

    mb_body    [pack]   gains a 12th slot, fed from the [t b i] that already carries
                        /mb/tracked - and fed from its INT outlet, which fires BEFORE
                        the bang outlet that makes the pack output, so the ordering is
                        forced by the trigger and not by patchcord fan-out.
    mb_zones   [unpack] gains a 12th outlet to match.
    mb_zones   the fire-arm [change] moves from outlet 10 (valid) to outlet 11 (tracked).

`valid` keeps driving the nine zone flags exactly as before: a hand going inferred still
blanks them for that frame.  What changes is only that it no longer disarms the fire.

WHAT IT DOES NOT FIX, stated so nobody has to rediscover it: a blanked frame still
restarts the 200 ms ABOVE commit, so a raise can still be DELAYED by up to 200 ms.  It
can no longer be silently REFUSED, which is the fault that was reported.

Idempotent, and it finds everything by walking the graph - never by id, never by
position.  Run it, then tune_zones.py, build_cells.py, build_devices.py.
"""

import json, collections, os, sys

OD = collections.OrderedDict
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..')
P = os.path.join(ROOT, 'synth', 'controller', 'MoveBeatController.maxpat')


def fail(msg):
    print('FAIL: ' + msg)
    sys.exit(1)


class Sub:
    def __init__(s, patcher, name):
        s.p, s.name = patcher, name
        s.BOX = {b['box']['id']: b['box'] for b in patcher['boxes']}
        s.FAN, s.BACK = {}, {}
        for l in patcher['lines']:
            pl = l['patchline']
            s.FAN.setdefault(tuple(pl['source']), []).append(tuple(pl['destination']))
            s.BACK.setdefault(tuple(pl['destination']), []).append(tuple(pl['source']))

    def text(s, i):
        return s.BOX[i].get('text', '') or ''

    def only(s, pred, what):
        hits = [i for i in s.BOX if pred(i)]
        if len(hits) != 1:
            fail('%s: expected exactly one %s, found %r' % (s.name, what, hits))
        return hits[0]

    def add_line(s, src, so, dst, di):
        s.p['lines'].append(OD([('patchline', OD([('destination', [dst, di]),
                                                  ('source', [src, so])]))]))

    def drop_line(s, src, so, dst, di):
        before = len(s.p['lines'])
        s.p['lines'] = [l for l in s.p['lines']
                        if not (tuple(l['patchline']['source']) == (src, so)
                                and tuple(l['patchline']['destination']) == (dst, di))]
        if len(s.p['lines']) == before:
            fail('%s: no patchline %s out%d -> %s in%d to remove'
                 % (s.name, src, so, dst, di))


def main():
    doc = json.load(open(P), object_pairs_hook=OD)
    root = doc['patcher']
    subs = {}
    for b in root['boxes']:
        bb = b['box']
        if bb.get('text') in ('p mb_body', 'p mb_zones'):
            subs[bb['text']] = Sub(bb['patcher'], bb['text'])
    if set(subs) != {'p mb_body', 'p mb_zones'}:
        fail('expected one [p mb_body] and one [p mb_zones], found %r' % sorted(subs))
    body, zones = subs['p mb_body'], subs['p mb_zones']

    # ---- mb_body: the pack that feeds the outlet, and the [t b i] on its inlet 0 -----
    out = body.only(lambda i: body.BOX[i]['maxclass'] == 'outlet', 'outlet')
    feeders = [sid for sid, _ in body.BACK.get((out, 0), [])]
    if len(feeders) != 1 or not body.text(feeders[0]).startswith('pack '):
        fail('mb_body: the outlet should be fed by one [pack], found %r' % feeders)
    pack = feeders[0]

    trig = [sid for sid, so in body.BACK.get((pack, 0), []) if body.text(sid) == 't b i']
    if len(trig) != 1:
        fail('mb_body: pack inlet 0 should be fed by the [t b i], found %r' % trig)
    trig = trig[0]

    # ---- mb_zones: the unpack on inlet 0, and the fire-arm [change] ------------------
    zin = zones.only(lambda i: zones.BOX[i]['maxclass'] == 'inlet', 'inlet')
    unp = [d for d, _ in zones.FAN.get((zin, 0), []) if zones.text(d).startswith('unpack')]
    if len(unp) != 1:
        fail('mb_zones: inlet 0 should feed one [unpack], found %r' % unp)
    unp = unp[0]

    sel = zones.only(lambda i: zones.text(i) == 'sel 0 1', '[sel 0 1]')
    chg = [sid for sid, _ in zones.BACK.get((sel, 0), [])]
    if len(chg) != 1 or not zones.text(chg[0]).startswith('change'):
        fail('mb_zones: [sel 0 1] should be fed by one [change], found %r' % chg)
    chg = chg[0]
    src = zones.BACK.get((chg, 0), [])
    if len(src) != 1 or src[0][0] != unp:
        fail('mb_zones: the fire-arm [change] should be fed by the [unpack], found %r' % src)
    cur_outlet = src[0][1]

    n_in = body.BOX[pack]['numinlets']
    n_out = zones.BOX[unp]['numoutlets']
    if n_in != n_out:
        fail('the pack has %d inlets but the unpack has %d outlets - they must match'
             % (n_in, n_out))

    # ---- idempotency -----------------------------------------------------------------
    tracked_slot = n_in - 1
    already = (cur_outlet == tracked_slot
               and (trig, 1, pack, tracked_slot) in
               [(s, o, d, i) for (s, o), ds in body.FAN.items() for d, i in ds])
    if already:
        print('the fire-arm is already driven by /mb/tracked (unpack outlet %d of %d)'
              ' - nothing to do' % (cur_outlet, n_out))
        return

    if cur_outlet != n_out - 1:
        fail('the fire-arm [change] is fed by unpack outlet %d, expected the last (%d) -'
             ' the valid slot.  Has this already been changed another way?'
             % (cur_outlet, n_out - 1))

    valid_slot, tracked_slot = n_out - 1, n_out      # valid stays put; tracked is new

    # ---- widen both sides ------------------------------------------------------------
    pb, ub = body.BOX[pack], zones.BOX[unp]
    pb['text'] = pb['text'] + ' 0'                  # an int slot: /mb/tracked is 0 or 1
    pb['numinlets'] = n_in + 1
    pb['patching_rect'][2] = float(pb['patching_rect'][2]) + 30.0
    ub['text'] = ub['text'] + ' 0'
    ub['numoutlets'] = n_out + 1
    ub['outlettype'] = list(ub['outlettype']) + ['int']
    ub['patching_rect'][2] = float(ub['patching_rect'][2]) + 30.0

    # ---- carry /mb/tracked, and arm from it ------------------------------------------
    body.add_line(trig, 1, pack, tracked_slot)
    zones.drop_line(unp, valid_slot, chg, 0)
    zones.add_line(unp, tracked_slot, chg, 0)

    with open(P, 'w') as f:
        json.dump(doc, f, indent=4)       # insertion order, no sort_keys - CLAUDE.md

    print('the fire-arm now follows /mb/tracked, not `valid`:')
    print('   mb_body   %s [pack] widened to %d slots; slot %d <- %s [t b i] out1'
          % (pack, n_in + 1, tracked_slot, trig))
    print('   mb_zones  %s [unpack] widened to %d outlets' % (unp, n_out + 1))
    print('   mb_zones  %s [change] moved from outlet %d (valid) to %d (tracked)'
          % (chg, valid_slot, tracked_slot))
    print('   `valid` still drives all nine zone flags, unchanged')


if __name__ == '__main__':
    main()
