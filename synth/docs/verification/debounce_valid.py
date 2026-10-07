#!/usr/bin/env python3
"""
debounce_valid.py - puts a de-bounce in front of the fire-arm chain in [p mb_zones].

WHY.  GRACE blocks the fire for a second after tracking returns, so that walking back
into frame cannot advance the song.  It was driven straight off `valid`, which demands
all five joints at trackingState exactly 2 - and a real body drops one about once a
second.  So the fire was being blocked by one-frame blips and then needed a full
uninterrupted second to re-arm.  Driving the real graphs from the live stream measured
the fire BLOCKED for 40 seconds straight, and an abvB rising edge refused inside a
blocked window with nothing printed anywhere.  That is the "the raise does not register
consistently" the performer reported.

WHAT IT BUILDS.  Before:

    valid -> [change] -> [sel 0 1]
                out0 (lost)     -> [stop] -> [del GRACE]      cancel any re-arm
                out0 (lost)     -> [0] -> armed = 0           IMMEDIATELY
                out1 (returned) -> [del GRACE] -> [1] -> armed = 1

After:

    valid -> [change] -> [sel 0 1]
                out0 (lost)     -> [stop] -> [del GRACE]      cancel any re-arm
                out0 (lost)     -> [del LOST_DEBOUNCE]        start the de-bounce
                out1 (returned) -> [stop] -> [del LOST_DEBOUNCE]   it was only a blip
                out1 (returned) -> [del GRACE] -> [1] -> armed = 1
                [del LOST_DEBOUNCE] -> [0] -> armed = 0       only now is it LOST

A blip shorter than LOST_DEBOUNCE never reaches the [0] at all, so it costs nothing.
A genuine loss still blocks, and still re-arms GRACE ms after the body comes back -
which is what verify_zones.py TEST 9 asserts, unchanged.

WHY A SEPARATE SCRIPT.  build_zone_layer.py inserted mb_zones once, in August, and
cannot be re-run: it appends rather than replaces and build_cells.py addresses mb_zones
by its id.  tune_zones.py owns the NUMBERS in this subpatcher; structure needs its own
in-place editor, and this is it.  Like tune_zones.py it finds everything by WALKING THE
GRAPH - never by id, never by position - and it is idempotent: run it twice and the
second run reports that there is nothing to do.

    python3 synth/docs/verification/debounce_valid.py
    then tune_zones.py, build_cells.py, build_devices.py
"""

import json, collections, os, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import zone_constants as Z

OD = collections.OrderedDict
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..')
P = os.path.join(ROOT, 'synth', 'controller', 'MoveBeatController.maxpat')


def fail(msg):
    print('FAIL: ' + msg)
    sys.exit(1)


def main():
    doc = json.load(open(P), object_pairs_hook=OD)
    root = doc['patcher']
    zones = [b['box'] for b in root['boxes'] if b['box'].get('text') == 'p mb_zones']
    if len(zones) != 1:
        fail('expected exactly one [p mb_zones], found %d' % len(zones))
    sub = zones[0]['patcher']

    BOX = {b['box']['id']: b['box'] for b in sub['boxes']}
    FAN, BACK = {}, {}
    for l in sub['lines']:
        pl = l['patchline']
        FAN.setdefault(tuple(pl['source']), []).append(tuple(pl['destination']))
        BACK.setdefault(tuple(pl['destination']), []).append(tuple(pl['source']))

    def text(i):
        return BOX[i].get('text', '') or ''

    # ---- find the fire-arm chain by walking from the only [sel 0 1] ---------
    sels = [i for i in BOX if text(i) == 'sel 0 1']
    if len(sels) != 1:
        fail('expected exactly one [sel 0 1] (the fire-arm branch), found %r' % sels)
    sel = sels[0]

    # and prove it really is the valid chain: [change] <- the unpack's last outlet
    up = BACK.get((sel, 0), [])
    if len(up) != 1 or not text(up[0][0]).startswith('change'):
        fail('[sel 0 1] inlet 0 should come from a [change], found %r' % up)
    chg = up[0][0]
    up2 = BACK.get((chg, 0), [])
    if len(up2) != 1 or not text(up2[0][0]).startswith('unpack'):
        fail('that [change] should be fed by the [unpack], found %r' % up2)
    unp, outn = up2[0]
    if outn != BOX[unp]['numoutlets'] - 1:
        fail('the [change] is fed by unpack outlet %d, not the last one (valid)' % outn)

    lost = FAN.get((sel, 0), [])          # valid went 0
    back = FAN.get((sel, 1), [])          # valid came back

    # ---- idempotency: a [del] already directly on the lost branch ----------
    already = [d for d, _ in lost if text(d).startswith('del ')]
    if already:
        print('the de-bounce is already in [p mb_zones] (%s = %s) - nothing to do'
              % (already[0], text(already[0])))
        print('its value is tune_zones.py\'s job; run that to write %d ms'
              % Z.LOST_DEBOUNCE)
        return

    rearm = [d for d, _ in back if text(d).startswith('del ')]
    if len(rearm) != 1:
        fail('expected one [del] on the returned branch (the re-arm), found %r' % rearm)
    rearm = rearm[0]

    zero = [d for d, _ in lost if BOX[d].get('maxclass') == 'message'
            and text(d).strip() == '0']
    if len(zero) != 1:
        fail('expected the [0] message directly on the lost branch, found %r' % zero)
    zero = zero[0]

    # ---- build the two new objects -----------------------------------------
    nxt = max(int(i.split('-')[1]) for i in BOX) + 1
    d_id, s_id = 'obj-%d' % nxt, 'obj-%d' % (nxt + 1)

    def newobj(oid, cls, txt, x, y, w):
        return OD([('box', OD([
            ('id', oid), ('maxclass', cls), ('numinlets', 2), ('numoutlets', 1),
            ('outlettype', ['bang' if cls == 'newobj' else '']),
            ('patching_rect', [float(x), float(y), float(w), 22.0]),
            ('text', txt)]))])

    sub['boxes'].append(newobj(d_id, 'newobj', 'del %d' % Z.LOST_DEBOUNCE, 380, 1140, 80))
    sub['boxes'].append(newobj(s_id, 'message', 'stop', 380, 1100, 60))

    def line(src, so, dst, di):
        return OD([('patchline', OD([('destination', [dst, di]),
                                     ('source', [src, so])]))])

    # drop the immediate block, and route it through the de-bounce instead
    sub['lines'] = [l for l in sub['lines']
                    if not (tuple(l['patchline']['source']) == (sel, 0)
                            and tuple(l['patchline']['destination']) == (zero, 0))]
    sub['lines'].append(line(sel, 0, d_id, 0))      # lost  -> start the de-bounce
    sub['lines'].append(line(sel, 1, s_id, 0))      # back  -> cancel it: only a blip
    sub['lines'].append(line(s_id, 0, d_id, 0))     # the stop reaches the de-bounce
    sub['lines'].append(line(d_id, 0, zero, 0))     # the de-bounce fired: NOW it is lost

    with open(P, 'w') as f:
        json.dump(doc, f, indent=4)       # insertion order, no sort_keys - CLAUDE.md

    print('de-bounced the fire-arm chain in [p mb_zones]:')
    print('   added    %s [del %d]   the loss de-bounce' % (d_id, Z.LOST_DEBOUNCE))
    print('   added    %s [stop]       cancels it when valid comes straight back' % s_id)
    print('   removed  %s out0 -> %s   the immediate block' % (sel, zero))
    print('   added    %s out0 -> %s -> %s   blocks only after %d ms'
          % (sel, d_id, zero, Z.LOST_DEBOUNCE))
    print('   the re-arm %s [%s] is untouched' % (rearm, text(rearm)))


if __name__ == '__main__':
    main()
