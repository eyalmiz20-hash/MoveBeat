#!/usr/bin/env python3
"""
build_cells.py - generates the zone-layer mapping cells into MoveBeatController.maxpat.

Regenerate, never hand-edit.  Idempotent: every object this script creates carries a
varname beginning with MARK, and a rebuild deletes those (and every patchline touching
them) before generating again.  Three runs produce identical bytes.

WHAT IT BUILDS
    [p mb_cell]         one parameter cell - pure logic, no UI, no Live parameters.
                        Instantiated once per cell, exactly as [p mb_slot] is six times.
    [p mb_zone_panel]   the floating mapping window: the 3x3 grid of cell UI, plus the
                        cell instances.  Opened from a button on the device panel with
                        [pcontrol], the idiom Ableton's own Harmonic Filter uses.

WHY THE UI IS NOT INSIDE mb_cell
    Live requires every device parameter to have a unique long name.  Putting live.*
    objects inside a subpatcher that is instantiated eight times would collide.  The
    existing six-slot matrix already solves this the same way: [p mb_slot] is pure
    logic and the live.menu / live.numbox rows live in the parent.  Same pattern here.

THE REFERENCE IMPLEMENTATION
    CLAUDE.md says to read Max for Live Essentials' LFO.  In Live 12 that device is
    encrypted (a 'ciph' chunk; 25 of 139 stock devices are).  Two shipped devices that
    ARE readable carry Ableton's own mapping abstraction and were read instead:
        Step Arp.amxd    (Sequencers pack)      - a MIDI effect, like this controller
        Vector Map.amxd  (Inspired by Nature)
    Everything below - the selected-parameter gate, exclusiveArm, dontMapToSelf,
    live.remote~ @normalized 1, the blob pattr - is copied from them, not invented.
"""

import json, copy, collections, sys, os

OD = collections.OrderedDict
P = 'synth/controller/MoveBeatController.maxpat'
MARK = 'mbz_'                      # every generated root object's varname starts with this

BODY = 'obj-178'                   # [p mb_body]   - verified, do not modify
ZONES = 'obj-180'                  # [p mb_zones]  - verified, do not modify

# mb_zones outlet 0 carries nine flags in this order.
FLAGS = ['abvL', 'abvR', 'abvB', 'lftL', 'lftR', 'lftB', 'rgtL', 'rgtR', 'rgtB']

# The eight parameter cells.  abvB is absent: it is the FIRE cell and belongs to the
# scene stepper, which is built separately.
# The default input range MUST lie inside the zone that switches the cell on, or the
# cell is dead on arrival: mb_zones only raises a side flag once the hand is past 1.15
# body lengths, so a 0..1 default would normalise -1.2 to -1.2, clip it to 0, and pin
# the parameter at zero forever.  These defaults are the span of each zone itself;
# SET RANGE then narrows them to whatever the dancer is comfortable with.
# How much movement each zone offers, per source axis, as (lo, hi) in body lengths.
# lo is where the zone begins, hi is full extension.  This is baked into each cell
# rather than exposed: the zone already decides the span, so there is nothing to
# calibrate and no SET RANGE button.  An arm reaches about 1.79 body lengths.
SPANS = {
    'ABOVE': [(-1.79, 1.79), (1.60, 2.40), (-1.00, 1.00), (1.00, 3.00)],
    'LEFT':  [(-1.15, -1.79), (1.60, 2.40), (-1.00, 1.00), (1.00, 3.00)],
    'RIGHT': [(1.15, 1.79), (1.60, 2.40), (-1.00, 1.00), (1.00, 3.00)],
}

#   key    flag   zone     hand  column  default source (0=X 1=Y 2=Z 3=SPREAD)
CELLS = [
    ('abvL', 'abvL', 'ABOVE', 'L',  'L', 1),
    ('abvR', 'abvR', 'ABOVE', 'R',  'R', 1),
    ('lftL', 'lftL', 'LEFT',  'L',  'L', 0),
    ('lftR', 'lftR', 'LEFT',  'R',  'R', 0),
    ('lftB', 'lftB', 'LEFT',  '2H', 'B', 3),
    ('rgtL', 'rgtL', 'RIGHT', 'L',  'L', 0),
    ('rgtR', 'rgtR', 'RIGHT', 'R',  'R', 0),
    ('rgtB', 'rgtB', 'RIGHT', '2H', 'B', 3),
]

# Which of the eight to actually wire this run.  The agreed order of work is
# one cell -> test in Live -> x8, so this starts as a single cell and becomes
# the full list once the first one is confirmed working.
BUILD = [c for c in CELLS if c[0] in (sys.argv[1:] or ['lftL'])]


# ----------------------------------------------------------------- helpers

def mkbox(i, mc, nin, nout, rect, text=None, ot=None, patcher=None, extra=None):
    b = OD()
    b['id'] = i
    b['maxclass'] = mc
    b['numinlets'] = nin
    b['numoutlets'] = nout
    if nout:
        b['outlettype'] = ot if ot else [''] * nout
    b['patching_rect'] = [float(v) for v in rect]
    if text is not None:
        b['text'] = text
    if extra:
        b.update(extra)
    if patcher is not None:
        b['patcher'] = patcher
    return b


def newsub(appversion):
    """A fresh subpatcher with the same box/obj/cmt/msg/L/finish helpers
    build_zone_layer.py uses, so the two builders read the same way."""
    S = {'boxes': [], 'lines': [], 'n': [0]}

    def nid():
        S['n'][0] += 1
        return 'obj-%d' % S['n'][0]

    def box(mc, x, y, w, h, text=None, nin=1, nout=1, ot=None, extra=None):
        i = nid()
        S['boxes'].append(OD(box=mkbox(i, mc, nin, nout, [x, y, w, h], text, ot, extra=extra)))
        return i

    def obj(t, x, y, w=150, nin=1, nout=1, ot=None, extra=None):
        return box('newobj', x, y, w, 22, t, nin, nout, ot, extra)

    def cmt(t, x, y, w=420):
        return box('comment', x, y, w, 20, t, 1, 0)

    def msg(t, x, y, w=60):
        return box('message', x, y, w, 22, t, 2, 1)

    def L(s, so, d, di):
        S['lines'].append(OD(patchline=OD(destination=[d, di], source=[s, so])))

    def finish(rect, presentation=False):
        p = OD([('fileversion', 1), ('appversion', copy.deepcopy(appversion)),
                ('classnamespace', 'box'), ('rect', [float(v) for v in rect])])
        if presentation:
            p['openinpresentation'] = 1
        p['boxes'] = S['boxes']
        p['lines'] = S['lines']
        return p

    return box, obj, cmt, msg, L, finish


def live_param(longname, shortname, ptype, **kw):
    """The saved_attribute_attributes block Live reads.  Copied from the shape Max
    itself writes (see the .amxd normalisation noted in CLAUDE.md)."""
    v = OD()
    for k in ('parameter_enum',):
        if k in kw:
            v[k] = kw.pop(k)
    v['parameter_longname'] = longname
    v['parameter_shortname'] = shortname
    v['parameter_type'] = ptype
    for k, val in kw.items():
        v[k] = val
    return OD([('valueof', v)])


# ----------------------------------------------------------------- [p mb_cell]

def build_cell(appversion, cellid, span):
    """One parameter cell.  Pure logic - nothing here is a Live parameter.

    `span` is this cell's movement span per source axis, as (lo, hi) pairs for
    X, Y, Z, SPREAD.  It is baked in rather than exposed: the zone already decides
    how much movement is available, so there is nothing for the user to calibrate.

        hand enters the zone   ->  the knob sits at FROM
        arm fully extended     ->  the knob sits at TO

    INLETS  (Max numbers these by ascending X, never by creation order - CLAUDE.md)
        0  source list  [x y z spread valid]   HOT, once per frame
        1  active 0/1   this cell's zone flag
        2  MAP button 0/1
        3  mode         0 = FADER, 1 = SWITCH
        4  source select 0..3  -> X Y Z SPREAD
        5  FROM %       where the knob sits on entering the zone
        6  TO %         where it sits at full extension
        7  restored path (from the blob pattr, on load)
        8  CLEAR - drop the mapping entirely

    OUTLETS
        0  mapped parameter name (symbol)
        1  acquired path -> the pattr that persists it
        2  MAP done (bang) -> releases the MAP button
        3  the value being sent, for the window's readout

    WHY THERE IS AN OUTPUT RANGE HERE AT ALL
        ZONES.md says Live's own mapping provides it and that building one here would
        duplicate it.  That is true of a MIDI mapping and false of live.remote~, which
        seizes the parameter and drives it from a bare 0..1 signal with no Min/Max
        anywhere in Live.  Ableton hit the same wall: their mapping abstraction runs
        [clip~ 0. 1.] -> [scale~ 0. 1. 0. 1.] -> [live.remote~], with the scale's two
        range inlets fed from a pair of [/ 100.].  Their file is even called
        Abl.MapWithScaledOuput.maxpat.  This is that, with the same arithmetic.
    """
    box, obj, cmt, msg, L, finish = newsub(appversion)

    for i, t in enumerate([
            'mb_cell - ONE MAPPING CELL.  Movement in one zone drives one Live parameter.',
            'Pure logic: the MAP button, the menus and the FROM/TO boxes live in the',
            'parent, because Live needs every device parameter to have a unique name and',
            'this subpatcher is instantiated once per cell.  Same split as [p mb_slot].']):
        cmt(t, 20, 8 + i * 20, 700)

    IX = [30, 180, 330, 480, 630, 780, 930, 1080, 1230]
    names = ['source list [x y z spread valid]', 'active 0/1', 'MAP button',
             'mode FADER/SWITCH', 'source select', 'FROM %', 'TO %', 'restored path',
             'CLEAR the mapping']
    IN = []
    for x, n in zip(IX, names):
        IN.append(box('inlet', x, 120, 30, 30, None, 0, 1))
        cmt(n, x, 96, 150)

    # ---- pick the chosen axis out of the frame -----------------------------
    cmt('The list arrives once per frame.  [t l l] forces the order; never rely on',
        30, 170, 700)
    cmt('unforced fan-out.',
        30, 190, 700)
    tsrc = obj('t l l', 30, 220, 80, 1, 2, ['', ''])
    L(IN[0], 0, tsrc, 0)
    snth = obj('zl nth 1', 30, 300, 90, 2, 2, ['', ''])
    L(tsrc, 0, snth, 0)

    # ---- this cell's movement span for that axis ---------------------------
    cmt("The span is fixed by the zone, so there is nothing to calibrate and no SET",
        480, 170, 700)
    cmt('RANGE button.  Entering the zone is one end of it; full extension is the other.',
        480, 190, 700)
    lo_s = ' '.join('%g' % span[a][0] for a in range(4))
    hi_s = ' '.join('%g' % span[a][1] for a in range(4))
    tsel = obj('t b i', 630, 220, 80, 1, 2, ['bang', 'int'])
    L(IN[4], 0, tsel, 0)
    sidx = obj('+ 1', 780, 260, 60, 2, 1, ['int'])
    L(tsel, 1, sidx, 0)                    # 1st: the 1-based index everywhere
    L(sidx, 0, snth, 1)
    mlo = msg(lo_s, 480, 260, 200)
    mhi = msg(hi_s, 480, 300, 200)
    L(tsel, 0, mlo, 0)                     # 2nd: re-read the span for the new axis
    L(tsel, 0, mhi, 0)
    zlo = obj('zl nth 1', 480, 340, 90, 2, 2, ['', ''])
    zhi = obj('zl nth 1', 690, 340, 90, 2, 2, ['', ''])
    L(mlo, 0, zlo, 0)
    L(mhi, 0, zhi, 0)
    L(sidx, 0, zlo, 1)
    L(sidx, 0, zhi, 1)

    # ---- normalise the movement into 0..1 ----------------------------------
    cmt('norm = (raw - lo) / (hi - lo), with the zero span guarded arithmetically -',
        30, 345, 700)
    cmt('Max expr has no ternary, so: (span != 0) * span + (span == 0).  CLAUDE.md.',
        30, 365, 700)
    nrm = obj('expr ($f1 - $f2) / ((($f3 - $f2) != 0) * ($f3 - $f2) + (($f3 - $f2) == 0))',
              30, 395, 560, 3, 1, ['float'])
    L(snth, 0, nrm, 0)
    L(zlo, 0, nrm, 1)
    L(zhi, 0, nrm, 2)
    ncl = obj('clip 0. 1.', 30, 430, 110, 3, 1, ['float'])
    L(nrm, 0, ncl, 0)

    # ---- FADER: only while the hand is in the zone -------------------------
    cmt('Closed while the hand is outside, so a FADER simply holds its last value -',
        30, 470, 700)
    cmt('and so does loss of tracking, since mb_zones drops the flag when the body goes.',
        30, 490, 700)
    agate = obj('gate', 30, 520, 80, 2, 1, [''])
    L(IN[1], 0, agate, 0)
    L(ncl, 0, agate, 1)

    # ---- FROM / TO: how far the knob is allowed to travel ------------------
    cmt('out = from + norm * (to - from).  This is Ableton\'s [scale~ 0. 1. 0. 1.] with',
        430, 520, 700)
    cmt('its range inlets fed from [/ 100.], written as arithmetic.',
        430, 540, 700)
    pfrom = obj('/ 100.', 780, 300, 70, 2, 1, ['float'])
    pto = obj('/ 100.', 930, 300, 70, 2, 1, ['float'])
    L(IN[5], 0, pfrom, 0)
    L(IN[6], 0, pto, 0)

    fmap = obj('expr $f2 + $f1 * ($f3 - $f2)', 30, 570, 290, 3, 1, ['float'])
    L(agate, 0, fmap, 0)
    L(pfrom, 0, fmap, 1)
    L(pto, 0, fmap, 2)

    # ---- SWITCH: TO while in the zone, FROM on leaving ---------------------
    cmt('A SWITCH is the same two ends: TO while the hand is in the zone, FROM when it',
        430, 620, 700)
    cmt('leaves.  Map it to Dry/Wet rather than a device on/off, or releasing it cuts a',
        430, 640, 700)
    cmt('reverb tail dead mid-decay.',
        430, 660, 700)
    smap = obj('expr $f2 + $f1 * ($f3 - $f2)', 430, 690, 290, 3, 1, ['float'])
    L(IN[1], 0, smap, 0)                   # not gated: it must emit on leaving too
    L(pfrom, 0, smap, 1)
    L(pto, 0, smap, 2)

    # ---- mode ---------------------------------------------------------------
    mF = obj('== 0', 330, 220, 60, 2, 1, ['int'])
    mS = obj('== 1', 400, 220, 60, 2, 1, ['int'])
    L(IN[3], 0, mF, 0)
    L(IN[3], 0, mS, 0)
    gF = obj('gate', 30, 740, 80, 2, 1, [''])
    L(mF, 0, gF, 0)
    L(fmap, 0, gF, 1)
    gS = obj('gate', 430, 740, 80, 2, 1, [''])
    L(mS, 0, gS, 0)
    L(smap, 0, gS, 1)

    # ---- out to live.remote~ ------------------------------------------------
    cmt('A short ramp at signal rate: the camera runs at 30 Hz and a raw 30 Hz step is',
        30, 790, 700)
    cmt('audible.  live.remote~ takes a signal - Step Arp, a MIDI effect like this one,',
        30, 810, 700)
    cmt('drives it the same way, which is what proves signals work in a MIDI device.',
        30, 830, 700)
    pk = obj('pack 0. 20', 30, 860, 110, 2, 1, [''])
    L(gF, 0, pk, 0)
    L(gS, 0, pk, 0)
    ln = obj('line~', 30, 900, 80, 2, 1, ['signal'])
    L(pk, 0, ln, 0)
    rem = obj('live.remote~ @normalized 1', 30, 940, 210, 1, 0)
    L(ln, 0, rem, 0)

    # ---- MAP: acquire the parameter the user clicks -------------------------
    cmt("MAP.  Ableton's own idiom, read out of Step Arp.amxd: while the button is on,",
        900, 120, 760)
    cmt("the next parameter clicked in Live arrives on live.path's id outlet.",
        900, 140, 760)

    mt = obj('t i i', 330, 280, 80, 1, 2, ['int', 'int'])
    L(IN[2], 0, mt, 0)

    lp = obj('live.path live_set view selected_parameter', 900, 180, 300, 1, 3, ['', '', ''])
    mg = obj('gate', 900, 230, 80, 2, 1, [''])
    L(mt, 1, mg, 0)                        # armed only while MAP is on
    L(lp, 1, mg, 1)
    dfl = obj('deferlow', 900, 270, 90, 1, 1, [''])
    L(mg, 0, dfl, 0)

    # Carry the whole "id <n>" MESSAGE, never a bare number.  live.object and
    # live.remote~ are set BY that message: hand either one a naked integer and it
    # sets nothing at all, with no error in the Max console.
    cmt('Keep the id MESSAGE intact - a bare number sets live.object to nothing, silently.',
        900, 300, 760)
    tid = obj('t l l', 900, 330, 80, 1, 2, ['', ''])
    L(dfl, 0, tid, 0)
    idn = obj('zl nth 2', 1100, 370, 90, 2, 2, ['', ''])
    L(tid, 1, idn, 0)
    idok = obj('!= 0', 1100, 410, 70, 2, 1, ['int'])
    L(idn, 0, idok, 0)
    nz = obj('gate', 900, 410, 80, 2, 1, [''])
    L(idok, 0, nz, 0)                      # id 0 means nothing is selected
    L(tid, 0, nz, 1)

    # exclusiveArm: turning one MAP on turns every other one off.
    cmt('exclusiveArm: arming one cell disarms the other seven.  Each cell broadcasts its',
        330, 330, 700)
    cmt('own id; route matches only itself, so everyone else falls through and releases.',
        330, 350, 700)
    cmt('The --- prefix scopes the send to this device instance, so two MoveBeat devices',
        330, 370, 700)
    cmt('in one Set never fight.',
        330, 390, 700)
    asel = obj('sel 1', 330, 420, 70, 2, 2, ['bang', ''])
    L(mt, 0, asel, 0)
    amsg = msg(str(cellid), 330, 460, 60)
    L(asel, 0, amsg, 0)
    asnd = obj('s ---mbMapOff', 330, 500, 140, 1, 0)
    L(amsg, 0, asnd, 0)
    arcv = obj('r ---mbMapOff', 510, 420, 140, 0, 1, [''])
    arte = obj('route %d' % cellid, 510, 460, 90, 2, 2, ['', ''])
    L(arcv, 0, arte, 0)
    aoff = obj('t b', 510, 500, 60, 1, 1, ['bang'])
    L(arte, 1, aoff, 0)                    # not me -> release my MAP button

    # dontMapToSelf - Ableton's guard, copied object for object.
    cmt("dontMapToSelf: compare the clicked parameter's canonical_parent against",
        900, 440, 760)
    cmt('path this_device, and refuse if they are the same device.',
        900, 460, 760)
    dt = obj('t l getpath l b', 900, 490, 170, 1, 4, ['', '', '', 'bang'])
    L(nz, 0, dt, 0)
    selfp = msg('path this_device', 1350, 530, 140)
    L(dt, 3, selfp, 0)
    selfpath = obj('live.path', 1350, 570, 90, 1, 3, ['', '', ''])
    L(selfp, 0, selfpath, 0)
    selfid = obj('route id', 1350, 610, 90, 2, 2, ['', ''])
    L(selfpath, 1, selfid, 0)
    lo = obj('live.object', 1100, 570, 110, 2, 2, ['', ''])
    L(dt, 2, lo, 1)
    L(dt, 1, lo, 0)
    apc = obj('append canonical_parent', 1100, 610, 200, 2, 1, [''])
    L(lo, 0, apc, 0)
    ppath = obj('live.path', 1100, 650, 90, 1, 3, ['', '', ''])
    L(apc, 0, ppath, 0)
    pid = obj('route id', 1100, 690, 90, 2, 2, ['', ''])
    L(ppath, 1, pid, 0)
    neq = obj('!=', 1100, 730, 70, 2, 1, ['int'])
    L(pid, 0, neq, 0)
    L(selfid, 0, neq, 1)
    sg = obj('gate', 900, 770, 80, 2, 1, [''])
    L(neq, 0, sg, 0)
    L(dt, 0, sg, 1)

    # ---- the accepted id: bind, name it, remember its path ------------------
    acc = obj('t l l l l', 900, 820, 170, 1, 4, ['', '', '', ''])
    L(sg, 0, acc, 0)

    cmt('Restored mappings join the same bus.  Live hands a stored path back through the',
        1250, 120, 700)
    cmt('blob pattr in the parent; live.thisdevice - never loadbang - is what asks for it,',
        1250, 140, 700)
    cmt('because loadbang fires before Live restores and would overwrite the saved value.',
        1250, 160, 700)
    rt = obj('t l l', 1250, 190, 80, 1, 2, ['', ''])
    L(IN[7], 0, rt, 0)
    rlen = obj('zl len', 1420, 230, 80, 2, 2, ['', ''])
    L(rt, 1, rlen, 0)
    # A real path is 'live_set tracks N devices M parameters K'.  The cleared
    # sentinel is a single 0, so anything shorter than three elements is not a
    # mapping and must not be handed to live.path.
    rok = obj('> 2', 1420, 270, 60, 2, 1, ['int'])
    L(rlen, 0, rok, 0)
    rg = obj('gate', 1250, 310, 80, 2, 1, [''])
    L(rok, 0, rg, 0)
    L(rt, 0, rg, 1)
    rpre = obj('prepend path', 1250, 350, 120, 1, 1, [''])
    L(rg, 0, rpre, 0)
    rpath = obj('live.path', 1250, 390, 90, 1, 3, ['', '', ''])
    L(rpre, 0, rpath, 0)
    # live.path emits "id 0" when a stored path no longer resolves - a track or device
    # that has since been deleted.  Binding that would quietly point the cell at
    # nothing, so it is filtered exactly as the MAP path is.
    rtid = obj('t l l', 1250, 430, 80, 1, 2, ['', ''])
    L(rpath, 1, rtid, 0)
    rn = obj('zl nth 2', 1420, 470, 90, 2, 2, ['', ''])
    L(rtid, 1, rn, 0)
    rnz = obj('!= 0', 1420, 510, 70, 2, 1, ['int'])
    L(rn, 0, rnz, 0)
    rgz = obj('gate', 1250, 510, 80, 2, 1, [''])
    L(rnz, 0, rgz, 0)
    L(rtid, 0, rgz, 1)
    L(rgz, 0, acc, 0)

    L(acc, 3, rem, 0)                      # "id <n>" is already the bind message

    nlo = obj('live.object', 1100, 870, 110, 2, 2, ['', ''])
    L(acc, 2, nlo, 1)
    gname = msg('get name', 1100, 910, 90)
    L(acc, 1, gname, 0)
    L(gname, 0, nlo, 0)
    rname = obj('route name', 1100, 950, 100, 2, 2, ['', ''])
    L(nlo, 0, rname, 0)

    glo = obj('live.object', 1350, 870, 110, 2, 2, ['', ''])
    L(acc, 2, glo, 1)
    gpath = msg('getpath', 1350, 910, 90)
    L(acc, 0, gpath, 0)
    L(gpath, 0, glo, 0)
    rpth = obj('route path', 1350, 950, 100, 2, 2, ['', ''])
    L(glo, 0, rpth, 0)

    # ---- CLEAR --------------------------------------------------------------
    cmt('CLEAR: release the parameter and forget the path.  Without this a mapping can',
        30, 1000, 760)
    cmt('never be undone, and because a stored path is POSITIONAL - live_set tracks 0',
        30, 1020, 760)
    cmt('devices 0 parameters 3 - deleting the effect does not invalidate it.  The path',
        30, 1040, 760)
    cmt('simply resolves to whatever now sits at that position, silently.',
        30, 1060, 760)
    ct = obj('t b b b', 1230, 160, 110, 1, 3, ['bang'] * 3)
    L(IN[8], 0, ct, 0)
    cid = msg('id 0', 1230, 200, 60)
    L(ct, 2, cid, 0)                       # 1st: let the parameter go
    L(cid, 0, rem, 0)
    cpath = msg('0', 1340, 200, 40)
    L(ct, 1, cpath, 0)                     # 2nd: forget the stored path
    cname = msg('-', 1400, 200, 40)
    L(ct, 0, cname, 0)                     # 3rd: blank the name

    OX = [30, 200, 370, 540]
    onames = ['mapped name', 'acquired path', 'MAP done', 'value being sent']
    OUT = []
    for x, n in zip(OX, onames):
        OUT.append(box('outlet', x, 1050, 30, 30, None, 1, 0))
        cmt(n, x, 1080, 150)
    L(rname, 0, OUT[0], 0)
    L(cname, 0, OUT[0], 0)
    L(rpth, 0, OUT[1], 0)
    L(cpath, 0, OUT[1], 0)
    L(aoff, 0, OUT[2], 0)
    tdone = obj('t b', 700, 1000, 60, 1, 1, ['bang'])
    L(acc, 0, tdone, 0)
    L(tdone, 0, OUT[2], 0)                 # a successful map releases the button too
    L(gF, 0, OUT[3], 0)
    L(gS, 0, OUT[3], 0)

    return finish([80, 80, 1700, 1130])


def build_stepper(appversion):
    """[p mb_stepper] - the one FIRE cell, ABOVE x two hands.

    Each two-hand raise advances the song by one scene.  The current scene loops until
    the next raise; past the last one it wraps to the first, so "restart the piece" is
    not a separate binding - it is the same one wrapping.

    NOTHING POSITIONAL IS BAKED IN.  The scene count is asked of Live on every raise
    with `getcount scenes`, and each candidate's `is_empty` is read live.  Live always
    leaves trailing empty scenes below the ones you filled, so skipping them means the
    stepper discovers on its own how long the piece is.  Add a section in Live and it
    is simply there.  (ZONES.md: "Never bake in positional numbers.")

    THE LOCKOUT IS LIVE'S REPORT, NOT A TIMER.  After firing, a live.observer watches
    that scene's `is_triggered`: 1 while it is queued and blinking, 0 the moment it
    actually starts.  The stepper unlocks on the 0.  With Global Quantization at 1 Bar
    that is about a bar of immunity - lower and raise your arms quickly and it simply
    does not count.  An accidental double advance skips a whole section in front of an
    audience and there is no way back, which is why this guard matters more than any
    other in the document.

    INLETS   0 fire flag (abvB)   1 fire armed (mb_zones outlet 2)
    OUTLETS  0 current scene, 1-based   1 scene count   2 locked 0/1
    """
    box, obj, cmt, msg, L, finish = newsub(appversion)

    for i, t in enumerate([
            'mb_stepper - THE SCENE STEPPER.  ABOVE x two hands advances the song.',
            'The scene list is queried live on every raise, empty scenes are skipped, and',
            'the end wraps to the beginning.  Nothing here knows how long the piece is.']):
        cmt(t, 20, 8 + i * 20, 720)

    IN = []
    for x, n in zip([30, 200], ['fire flag (abvB)', 'fire armed']):
        IN.append(box('inlet', x, 100, 30, 30, None, 0, 1))
        cmt(n, x, 76, 200)

    # ---- the song object, resolved once ------------------------------------
    cmt('live.thisdevice, never loadbang: it fires after Live has finished loading.',
        430, 76, 700)
    ltd = obj('live.thisdevice', 430, 110, 140, 1, 3, ['bang', 'bang', ''])
    psong = msg('path live_set', 430, 150, 130)
    L(ltd, 0, psong, 0)
    init0 = msg('0', 600, 150, 40)
    L(ltd, 0, init0, 0)                    # report "not locked" before anything happens
    lpsong = obj('live.path', 430, 190, 90, 1, 3, ['', '', ''])
    L(psong, 0, lpsong, 0)
    tsong = obj('t b l', 430, 230, 80, 1, 2, ['bang', ''])
    L(lpsong, 1, tsong, 0)
    losong = obj('live.object', 430, 310, 110, 2, 2, ['', ''])
    L(tsong, 1, losong, 1)                 # the id message, intact - see CLAUDE.md

    # ---- a raise, if armed and not locked ----------------------------------
    cmt('A rising edge only.  mb_zones has already committed the two-hand state over',
        30, 140, 700)
    cmt('200 ms, so this cannot flicker on the way up.',
        30, 160, 700)
    ech = obj('change -1', 30, 190, 90, 2, 1, ['int'])
    L(IN[0], 0, ech, 0)
    esel = obj('sel 1', 30, 230, 70, 2, 2, ['bang', ''])
    L(ech, 0, esel, 0)
    gArm = obj('gate', 30, 270, 80, 2, 1, [''])
    L(IN[1], 0, gArm, 0)                   # blocked for 1000 ms after tracking returns
    L(esel, 0, gArm, 1)
    flock = obj('f 0.', 200, 190, 60, 2, 1, ['float'])
    nlock = obj('== 0', 200, 230, 60, 2, 1, ['int'])
    L(flock, 0, nlock, 0)
    cmt('gate 1 1 - OPEN by default.  A bare [gate] starts closed and flock does not',
        200, 270, 700)
    cmt('emit until something locks, so the first raise of the set could never pass.',
        200, 290, 700)
    gLock = obj('gate 1 1', 30, 310, 80, 2, 1, [''])
    L(nlock, 0, gLock, 0)
    L(gArm, 0, gLock, 1)

    req = obj('t b b b', 30, 350, 110, 1, 3, ['bang'] * 3)
    L(gLock, 0, req, 0)

    # ---- ask Live how many scenes there are, every time --------------------
    cmt('Asked on every raise rather than cached, so adding a section in Live needs no',
        600, 350, 700)
    cmt('refresh and nothing can go stale.',
        600, 370, 700)
    zero = msg('0', 200, 390, 40)
    L(req, 2, zero, 0)                     # 1st: nothing found yet this raise
    ffound = obj('f 0.', 200, 430, 60, 2, 1, ['float'])
    L(zero, 0, ffound, 0)
    nfound = obj('== 0', 200, 470, 60, 2, 1, ['int'])
    L(ffound, 0, nfound, 0)

    gcnt = msg('getcount scenes', 430, 390, 150)
    L(req, 1, gcnt, 0)                     # 2nd: how many scenes?
    L(gcnt, 0, losong, 0)
    rcnt = obj('route getcount', 430, 430, 130, 2, 2, ['', ''])
    L(losong, 0, rcnt, 0)
    ncnt = obj('zl nth 2', 430, 470, 90, 2, 2, ['', ''])
    L(rcnt, 0, ncnt, 0)
    tcnt = obj('t i i', 430, 510, 80, 1, 2, ['int', 'int'])
    L(ncnt, 0, tcnt, 0)
    fcnt = obj('f 0.', 600, 550, 60, 2, 1, ['float'])
    L(tcnt, 1, fcnt, 1)                    # remember it for the modulo

    uzi = obj('uzi 1', 30, 590, 80, 2, 3, ['bang', 'int', 'bang'])
    L(tcnt, 0, uzi, 1)                     # how many candidates to try
    L(req, 0, uzi, 0)                      # 3rd: walk forward from the current scene

    # ---- candidate = (current + k) mod count -------------------------------
    fcur = obj('f -1.', 780, 550, 70, 2, 1, ['float'])
    cmt('current scene, 0-based.  Starts at -1 so the very first raise fires scene 0.',
        860, 552, 700)
    cmt('[f] holds silently - bang current and count into the cold inlets first.',
        300, 600, 700)
    tk = obj('t i b', 30, 600, 80, 1, 2, ['int', 'bang'])
    L(uzi, 1, tk, 0)
    cand = obj('expr ($i1 + $i2) % $i3', 30, 640, 260, 3, 1, ['int'])
    L(tk, 1, fcur, 0)                      # 1st: emit them
    L(tk, 1, fcnt, 0)
    L(fcur, 0, cand, 1)
    L(fcnt, 0, cand, 2)
    L(tk, 0, cand, 0)                      # 2nd: and now the candidate number
    tcand = obj('t i i', 30, 680, 80, 1, 2, ['int', 'int'])
    L(cand, 0, tcand, 0)
    fcand = obj('f 0.', 300, 720, 60, 2, 1, ['float'])
    L(tcand, 1, fcand, 1)                  # hold it while we ask about it

    # ---- is that scene empty? ----------------------------------------------
    cmt('Live always leaves trailing empty scenes below the ones you filled, so skipping',
        600, 680, 700)
    cmt('them is what lets the stepper discover the length of the piece by itself.',
        600, 700, 700)
    spath = obj('sprintf path live_set scenes %ld', 30, 720, 250, 1, 1, [''])
    L(tcand, 0, spath, 0)
    lpsc = obj('live.path', 30, 760, 90, 1, 3, ['', '', ''])
    L(spath, 0, lpsc, 0)
    tsc = obj('t b l', 30, 800, 80, 1, 2, ['bang', ''])
    L(lpsc, 1, tsc, 0)
    losc = obj('live.object', 30, 880, 110, 2, 2, ['', ''])
    L(tsc, 1, losc, 1)
    gempty = msg('get is_empty', 30, 840, 120)
    L(tsc, 0, gempty, 0)
    L(gempty, 0, losc, 0)
    rempty = obj('route is_empty', 30, 920, 130, 2, 2, ['', ''])
    L(losc, 0, rempty, 0)
    selem = obj('sel 0', 30, 960, 70, 2, 2, ['bang', ''])
    L(rempty, 0, selem, 0)                 # 0 = not empty = playable

    gfirst = obj('gate', 30, 1000, 80, 2, 1, [''])
    L(nfound, 0, gfirst, 0)                # only the first playable one counts
    L(selem, 0, gfirst, 1)
    tfirst = obj('t b b', 30, 1040, 80, 1, 2, ['bang', 'bang'])
    L(gfirst, 0, tfirst, 0)
    one = msg('1', 200, 1040, 40)
    L(tfirst, 1, one, 0)                   # 1st: close the gate behind us
    L(one, 0, ffound, 0)
    L(tfirst, 0, fcand, 0)                 # 2nd: and that is the scene to fire

    # ---- fire it ------------------------------------------------------------
    cmt('Order matters: remember it, resolve it, arm the observer, and only then fire.',
        430, 1080, 700)
    tfire = obj('t i i i', 30, 1090, 110, 1, 3, ['int', 'int', 'int'])
    L(fcand, 0, tfire, 0)
    L(tfire, 2, fcur, 1)                   # 1st: this is the current scene now
    fpath = obj('sprintf path live_set scenes %ld', 30, 1130, 250, 1, 1, [''])
    L(tfire, 1, fpath, 0)                  # 2nd: resolve it and arm the observer
    lpf = obj('live.path', 30, 1170, 90, 1, 3, ['', '', ''])
    L(fpath, 0, lpf, 0)
    tf = obj('t b l l', 30, 1210, 100, 1, 3, ['bang', '', ''])
    L(lpf, 1, tf, 0)
    lof = obj('live.object', 30, 1330, 110, 2, 2, ['', ''])
    L(tf, 2, lof, 1)
    obs = obj('live.observer', 300, 1330, 120, 2, 2, ['', ''])
    L(tf, 1, obs, 1)
    ptrig = msg('property is_triggered', 300, 1290, 190)
    L(tf, 0, ptrig, 0)
    L(ptrig, 0, obs, 0)

    cfire = msg('call fire', 30, 1290, 100)
    L(tfire, 0, cfire, 0)                  # 3rd: fire
    L(cfire, 0, lof, 0)

    # ---- and lock until Live says it has started ---------------------------
    cmt('The observer reports is_triggered: 1 while the scene is queued and blinking, 0',
        600, 1380, 720)
    cmt('when it actually starts.  Unlocking on that 0 is the whole guard - no timer',
        600, 1400, 720)
    cmt('decides it.  The listener is opened only AFTER firing, so the observer\'s own',
        600, 1420, 720)
    cmt('report at the moment it is armed cannot unlock it straight away.',
        600, 1440, 720)
    lk = obj('t b b', 30, 1380, 80, 1, 2, ['bang', 'bang'])
    L(cfire, 0, lk, 0)
    lock1 = msg('1', 30, 1420, 40)
    L(lk, 1, lock1, 0)
    L(lock1, 0, flock, 0)

    tobs = obj('t i', 300, 1380, 60, 1, 1, ['int'])
    L(obs, 0, tobs, 0)
    gunlock = obj('gate', 300, 1420, 80, 2, 1, [''])
    L(flock, 0, gunlock, 0)                # only while we are actually locked
    L(tobs, 0, gunlock, 1)
    selstart = obj('sel 0', 300, 1460, 70, 2, 2, ['bang', ''])
    L(gunlock, 0, selstart, 0)
    lock0 = msg('0', 300, 1500, 40)
    L(selstart, 0, lock0, 0)
    L(lock0, 0, flock, 0)
    L(init0, 0, flock, 0)

    # A failsafe, and named as one.  If Live never reports the change - the scene was
    # deleted, or it launched between arming and firing - the stepper would stay locked
    # for the rest of the performance.  That is the one failure worse than a double
    # advance, so a long timer releases it.  It never decides the normal lockout.
    cmt('FAILSAFE only.  If Live never reports, the stepper would stay locked for the',
        600, 1500, 720)
    cmt('rest of the set - the one failure worse than a double advance.',
        600, 1520, 720)
    fs = obj('del 8000', 30, 1460, 90, 2, 1, ['bang'])
    L(lk, 0, fs, 0)
    L(fs, 0, lock0, 0)
    stop = msg('stop', 430, 1500, 60)
    L(selstart, 0, stop, 0)
    L(stop, 0, fs, 0)

    # ---- outlets -------------------------------------------------------------
    OUT = []
    for x, n in zip([30, 200, 370], ['current scene, 1-based', 'scene count', 'locked']):
        OUT.append(box('outlet', x, 1600, 30, 30, None, 1, 0))
        cmt(n, x, 1630, 200)
    disp = obj('expr $i1 + 1', 30, 1560, 120, 1, 1, ['int'])
    L(tfire, 2, disp, 0)
    L(disp, 0, OUT[0], 0)
    L(tcnt, 1, OUT[1], 0)
    L(flock, 0, OUT[2], 0)

    return finish([80, 80, 1700, 1700])


# ----------------------------------------------------------------- [p mb_zone_panel]

# Where each cell sits in the 3 x 3 grid, and which hand column feeds it.
ZONE_ROW = {'ABOVE': 0, 'LEFT': 1, 'RIGHT': 2}
HAND_COL = {'L': 0, 'R': 1, '2H': 2}

GX, GY, COLW, ROWH = 72, 22, 152, 58      # presentation grid origin and pitch
LABW = 66                                  # the row-label column, clear of the grid


def build_panel(appversion):
    """The floating mapping window: a 3 x 3 grid matching the table in the book,
    one block per cell.  Its presentation view is what the window shows."""
    box, obj, cmt, msg, L, finish = newsub(appversion)

    for i, t in enumerate([
            'mb_zone_panel - THE MAPPING WINDOW.  Three zones x three hand states = nine',
            'cells, laid out exactly as the table in the book.  Eight control parameters;',
            'ABOVE x two hands fires scenes and is built separately as the stepper.',
            'Opened from the device panel with [pcontrol] - the idiom Ableton\'s own',
            'Harmonic Filter.amxd uses.  The cells run whether this window is open or not.']):
        cmt(t, 20, 8 + i * 20, 760)

    # Inlet 0 is reserved for [pcontrol], which attaches to a subpatcher's leftmost
    # inlet to open and close its window.  Keeping it empty means the open/close
    # traffic can never be confused with the body list.  Max numbers inlets by
    # ascending X, so the order below is the order on screen - CLAUDE.md.
    IN = []
    for x, n in zip([30, 300, 570, 840],
                    ['pcontrol - opens/closes this window', 'body list',
                     'nine zone flags', 'fire armed']):
        IN.append(box('inlet', x, 140, 30, 30, None, 0, 1))
        cmt(n, x, 116, 260)

    # ---- unpack the body list ----------------------------------------------
    cmt('mb_body list:  1 hL.x  2 hL.y  3 hL.z   4 hR.x  5 hR.y  6 hR.z   7 spread',
        30, 180, 760)
    cmt('               8 head.y   9 scale   10 valid        (0 is the frame trigger)',
        30, 200, 760)
    ub = obj('unpack 0 0. 0. 0. 0. 0. 0. 0. 0. 0. 0.', 30, 230, 460, 1, 11,
             ['int'] + ['float'] * 10)
    L(IN[1], 0, ub, 0)

    uf = obj('unpack 0 0 0 0 0 0 0 0 0', 300, 180, 300, 1, 9, ['int'] * 9)
    L(IN[2], 0, uf, 0)

    # ---- the three hand columns --------------------------------------------
    # Each cell is fed [x y z spread valid].  unpack fires right to left, so every
    # cold inlet of the pack is filled before hL.x / hR.x reaches inlet 0 and fires it.
    cmt('Each column is packed as [x y z spread valid].  unpack fires right to left, so',
        30, 300, 760)
    cmt('the hot inlet of each pack is the last to arrive and every value is already in.',
        30, 320, 760)
    COL = {}
    for ci, (key, xs) in enumerate((('L', [1, 2, 3]), ('R', [4, 5, 6]))):
        pk = obj('pack 0. 0. 0. 0. 0.', 30 + ci * 260, 350, 240, 5, 1, [''])
        for slot, src in enumerate(xs):
            L(ub, src, pk, slot)
        L(ub, 7, pk, 3)                    # spread
        L(ub, 10, pk, 4)                   # valid
        COL[key] = pk

    # Two hands: the midpoint of the two, with SPREAD as the natural default source.
    bx = obj('expr ($f1 + $f2) / 2.', 560, 350, 180, 2, 1, ['float'])
    by = obj('expr ($f1 + $f2) / 2.', 560, 380, 180, 2, 1, ['float'])
    bz = obj('expr ($f1 + $f2) / 2.', 560, 410, 180, 2, 1, ['float'])
    for e, a, b_ in ((bx, 1, 4), (by, 2, 5), (bz, 3, 6)):
        L(ub, a, e, 0)
        L(ub, b_, e, 1)
    pkb = obj('pack 0. 0. 0. 0. 0.', 560, 450, 240, 5, 1, [''])
    for slot, e in enumerate((bx, by, bz)):
        L(e, 0, pkb, slot)
    L(ub, 7, pkb, 3)
    L(ub, 10, pkb, 4)
    COL['B'] = pkb

    # ---- restore-on-load one-shot ------------------------------------------
    cmt('live.thisdevice fires after Live has restored every parameter.  loadbang fires',
        860, 180, 760)
    cmt('BEFORE, and using it here would overwrite the mapping Live just restored - the',
        860, 200, 760)
    cmt('bug that made slot settings vanish on reload, recorded in CLAUDE.md.',
        860, 220, 760)
    ltd = obj('live.thisdevice', 860, 250, 140, 1, 3, ['bang', 'bang', ''])
    rst = obj('t b b b b', 860, 290, 130, 1, 4, ['bang'] * 4)
    L(ltd, 0, rst, 0)

    # MAP only works if this window is still there after the user clicks into Live.
    # A plain subpatcher window goes behind - or away - the moment Live takes focus.
    # 'float' makes it a utility window that stays on top; 'window exec' applies the
    # flags.  Vector Grain.amxd sets its window flags exactly this way.
    cmt('Without float, clicking a parameter in Live hides this window and MAP cannot be',
        1250, 250, 700)
    cmt('driven at all.  window exec is what actually applies the flags.',
        1250, 270, 700)
    wf = msg('window flags float, window exec', 1250, 300, 250)
    L(rst, 3, wf, 0)
    tp = obj('thispatcher', 1250, 340, 110, 1, 2, ['', ''])
    L(wf, 0, tp, 0)
    ropen = msg('1', 1000, 330, 40)
    rclose = msg('0', 860, 330, 40)
    L(rst, 2, ropen, 0)
    L(rst, 0, rclose, 0)

    # An outlet so the device panel can show what was last mapped.  Without it there
    # is no way to tell a successful MAP from a silent failure while the window is shut.
    cell_patch_span = []
    PANEL_OUT = [box('outlet', 30, 1760, 30, 30, None, 1, 0)]
    cmt('last mapped parameter name -> the device panel', 70, 1765, 400)

    # ---- one block per cell -------------------------------------------------
    ybase = 560
    for n, (key, flag, zone, hand, col, dsrc) in enumerate(BUILD):
        fi = FLAGS.index(flag)
        row, cl = ZONE_ROW[zone], HAND_COL['2H' if hand == '2H' else hand]
        px, py = GX + cl * COLW, GY + row * ROWH
        ox, oy = 30 + n * 900, ybase

        cmt('%s  x  %s' % (zone, {'L': 'left hand', 'R': 'right hand', '2H': 'two hands'}[hand]),
            ox, oy - 26, 300)

        # --- UI, each with a Live parameter name unique to this cell ---------
        mapb = box('live.text', ox, oy, 70, 15, 'MAP', 1, 2, ['', ''], extra=OD([
            ('outputmode', 1), ('appearance', 2), ('parameter_enable', 1),
            ('presentation', 1), ('presentation_rect', [float(px), float(py), 34.0, 15.0]),
            ('saved_attribute_attributes', live_param(
                '%s Map' % key, 'Map', 2, parameter_enum=['off', 'on'],
                parameter_mmax=1, parameter_invisible=2, parameter_modmode=0)),
            ('texton', 'MAP'), ('varname', '%s_map' % key)]))

        clrb = box('live.text', ox + 250, oy, 40, 15, 'x', 1, 2, ['', ''], extra=OD([
            ('outputmode', 0), ('appearance', 2), ('parameter_enable', 1),
            ('presentation', 1),
            ('presentation_rect', [float(px + 136), float(py), 14.0, 15.0]),
            ('saved_attribute_attributes', live_param(
                '%s Clear' % key, 'Clr', 2, parameter_enum=['off', 'on'],
                parameter_mmax=1, parameter_invisible=2, parameter_modmode=0)),
            ('texton', 'x'), ('varname', '%s_clr' % key)]))

        namec = box('comment', ox + 80, oy, 160, 20, '-', 1, 0, extra=OD([
            ('presentation', 1),
            ('presentation_rect', [float(px + 36), float(py), 98.0, 15.0]),
            ('fontsize', 9.0), ('varname', '%s_name' % key)]))

        modem = box('live.menu', ox, oy + 30, 90, 15, None, 1, 3, ['', '', 'float'], extra=OD([
            ('parameter_enable', 1), ('presentation', 1),
            ('presentation_rect', [float(px), float(py + 17), 50.0, 15.0]),
            ('saved_attribute_attributes', live_param(
                '%s Mode' % key, 'Mode', 2, parameter_enum=['FADER', 'SWITCH'],
                parameter_mmax=1, parameter_initial_enable=1, parameter_initial=[0],
                parameter_modmode=0, parameter_unitstyle=9)),
            ('varname', '%s_mode' % key)]))

        srcm = box('live.menu', ox + 100, oy + 30, 90, 15, None, 1, 3, ['', '', 'float'], extra=OD([
            ('parameter_enable', 1), ('presentation', 1),
            ('presentation_rect', [float(px + 52), float(py + 17), 44.0, 15.0]),
            ('saved_attribute_attributes', live_param(
                '%s Src' % key, 'Src', 2, parameter_enum=['X', 'Y', 'Z', 'SPREAD'],
                parameter_mmax=3, parameter_initial_enable=1, parameter_initial=[dsrc],
                parameter_modmode=0, parameter_unitstyle=9)),
            ('varname', '%s_src' % key)]))

        fromb = box('live.numbox', ox, oy + 60, 60, 15, None, 1, 2, ['', 'float'], extra=OD([
            ('parameter_enable', 1), ('presentation', 1),
            ('presentation_rect', [float(px), float(py + 34), 46.0, 15.0]),
            ('saved_attribute_attributes', live_param(
                '%s From' % key, 'From', 0, parameter_mmin=0.0, parameter_mmax=100.0,
                parameter_initial_enable=1, parameter_initial=[0.0],
                parameter_modmode=0, parameter_unitstyle=5)),
            ('varname', '%s_from' % key)]))

        tob = box('live.numbox', ox + 70, oy + 60, 60, 15, None, 1, 2, ['', 'float'], extra=OD([
            ('parameter_enable', 1), ('presentation', 1),
            ('presentation_rect', [float(px + 50), float(py + 34), 46.0, 15.0]),
            ('saved_attribute_attributes', live_param(
                '%s To' % key, 'To', 0, parameter_mmin=0.0, parameter_mmax=100.0,
                parameter_initial_enable=1, parameter_initial=[100.0],
                parameter_modmode=0, parameter_unitstyle=5)),
            ('varname', '%s_to' % key)]))

        # The mapping itself: a blob pattr.  parameter_type 3 holds an arbitrary list,
        # which is how shipped devices persist things a numbox cannot hold - Vector
        # Grain stores a file path exactly this way.  parameter_invisible keeps it out
        # of Live's automation menu, where it would be meaningless.
        pat = box('newobj', ox + 300, oy + 60, 150, 22, 'pattr %s_path @autorestore 0' % key, 1, 3,
                  ['', '', ''], extra=OD([
                      ('saved_object_attributes', OD([('parameter_enable', 1),
                                                      ('parameter_mappable', 0),
                                                      ('initial', [0])])),
                      ('saved_attribute_attributes', live_param(
                          '%s Path' % key, 'Path', 3, parameter_invisible=1,
                          parameter_initial_enable=1, parameter_initial=[0],
                          parameter_modmode=0)),
                      ('varname', '%s_pattr' % key)]))

        # --- the cell itself --------------------------------------------------
        # A lamp that lights while the hand is in this cell's zone, and a readout of
        # what the cell is sending.  Without these there is nothing on screen to tell
        # you whether a zone is live, and the whole layer is invisible while you use it.
        # Driven by the patch, so deliberately NOT Live parameters - the same reason
        # the zone monitor's toggles are not (see CLAUDE.md).
        lamp = box('toggle', ox + 430, oy + 60, 20, 20, None, 1, 1, ['int'], extra=OD([
            ('presentation', 1),
            ('presentation_rect', [float(px + 100), float(py + 18), 13.0, 13.0]),
            ('varname', '%s_lamp' % key)]))
        vshow = box('comment', ox + 460, oy + 60, 60, 20, '-', 1, 0, extra=OD([
            ('presentation', 1),
            ('presentation_rect', [float(px + 116), float(py + 17), 34.0, 15.0]),
            ('fontsize', 9.0), ('varname', '%s_val' % key)]))

        cell = obj('p mb_cell', ox, oy + 100, 120, 9, 4, [''] * 4)
        cell_patch_span.append(SPANS[zone])

        L(COL[col], 0, cell, 0)            # source list   (hot, once per frame)
        L(uf, fi, cell, 1)                 # this cell's zone flag
        L(mapb, 0, cell, 2)
        L(modem, 0, cell, 3)
        L(srcm, 0, cell, 4)
        L(fromb, 0, cell, 5)
        L(tob, 0, cell, 6)

        # restore: open the gate, bang the pattr, close it again
        rgate = obj('gate', ox + 300, oy + 20, 80, 2, 1, [''])
        L(ropen, 0, rgate, 0)
        L(rclose, 0, rgate, 0)
        L(rst, 1, pat, 0)                  # bang -> pattr emits what Live restored
        L(pat, 0, rgate, 1)
        L(rgate, 0, cell, 7)
        L(clrb, 0, cell, 8)

        # outputs
        nset = obj('prepend set', ox + 80, oy + 140, 110, 1, 1, [''])
        L(cell, 0, nset, 0)
        L(nset, 0, namec, 0)
        L(cell, 0, PANEL_OUT[0], 0)        # and out to the device panel, so a mapping
        #                                    can be confirmed without this window open
        L(cell, 1, pat, 0)                 # store the acquired path
        moff = msg('0', ox + 250, oy + 140, 40)
        L(cell, 2, moff, 0)
        L(moff, 0, mapb, 0)                # release the MAP button
        L(uf, fi, lamp, 0)                 # the zone flag lights the lamp directly
        vfmt = obj('sprintf %.2f', ox + 460, oy + 170, 110, 1, 1, [''])
        L(cell, 3, vfmt, 0)
        vset = obj('prepend set', ox + 460, oy + 200, 110, 1, 1, [''])
        L(vfmt, 0, vset, 0)
        L(vset, 0, vshow, 0)

    # ---- the scene stepper, at ABOVE x two hands ----------------------------
    # The one FIRE cell.  It has no MAP button and no FROM/TO: it does not drive a
    # parameter, it advances the song.  ZONES.md: "ABOVE x two hands -> the structure
    # of the piece.  Everything else -> the sound of the piece."
    spx, spy = GX + 2 * COLW, GY
    box('comment', 30, 1500, 160, 20, 'SCENE STEPPER', 1, 0, extra=OD([
        ('presentation', 1), ('presentation_rect', [float(spx), float(spy), 150.0, 15.0]),
        ('fontsize', 9.0), ('varname', 'mbz_steplabel')]))
    scene_disp = box('comment', 30, 1530, 120, 20, '-', 1, 0, extra=OD([
        ('presentation', 1),
        ('presentation_rect', [float(spx), float(spy + 17), 66.0, 15.0]),
        ('fontsize', 9.0), ('varname', 'mbz_scene')]))
    box('comment', 200, 1530, 60, 20, 'scene', 1, 0, extra=OD([
        ('presentation', 1),
        ('presentation_rect', [float(spx), float(spy + 34), 44.0, 15.0]),
        ('fontsize', 9.0), ('varname', 'mbz_scenelab')]))
    fire_lamp = box('toggle', 30, 1560, 20, 20, None, 1, 1, ['int'], extra=OD([
        ('presentation', 1),
        ('presentation_rect', [float(spx + 100), float(spy + 18), 13.0, 13.0]),
        ('varname', 'mbz_firelamp')]))
    lock_lamp = box('toggle', 60, 1560, 20, 20, None, 1, 1, ['int'], extra=OD([
        ('presentation', 1),
        ('presentation_rect', [float(spx + 124), float(spy + 18), 13.0, 13.0]),
        ('varname', 'mbz_locklamp')]))
    box('comment', 90, 1560, 90, 20, 'raise   locked', 1, 0, extra=OD([
        ('presentation', 1),
        ('presentation_rect', [float(spx + 76), float(spy + 34), 74.0, 15.0]),
        ('fontsize', 9.0), ('varname', 'mbz_lamplab')]))

    stepper = obj('p mb_stepper', 30, 1600, 130, 2, 3, ['', '', ''])
    L(uf, FLAGS.index('abvB'), stepper, 0)
    L(uf, FLAGS.index('abvB'), fire_lamp, 0)
    L(IN[3], 0, stepper, 1)                # fire-armed: the 1000 ms block after tracking
    L(stepper, 2, lock_lamp, 0)

    # "3 / 8", built from the two outlets.  sprintf's right inlet is cold, so the count
    # is in place before the scene number fires it.
    sfmt = obj('sprintf %ld / %ld', 30, 1660, 150, 2, 1, [''])
    L(stepper, 1, sfmt, 1)
    L(stepper, 0, sfmt, 0)
    sset = obj('prepend set', 30, 1700, 110, 1, 1, [''])
    L(sfmt, 0, sset, 0)
    L(sset, 0, scene_disp, 0)

    # ---- a mock body, right here in the window ------------------------------
    # The real mock sliders live at the root and are not in the device's presentation,
    # so testing meant opening the Max editor next to Live.  These four drive the same
    # joints through the device-scoped send/receive pair below, which means the whole
    # layer can be exercised from this one window.
    cmt('mock body - drives the same joints the Kinect would', 30, 1600, 500)
    MOCKS = [('LX', 'left hand X', 0, 0, -1.0, 1.0), ('LY', 'left hand Y', 0, 1, -1.0, 1.5),
             ('RX', 'right hand X', 1, 0, -1.0, 1.0), ('RY', 'right hand Y', 1, 1, -1.0, 1.5)]
    # These have to be LONG.  A side zone only begins at 1.15 body lengths and an arm
    # reaches about 1.79, so the whole 0-100% of the fader lives in the outer 17% of
    # the slider's travel.  Drawn 50 px wide that is eight pixels for the entire knob,
    # which is unusable - it snaps between the extremes and nothing in between.  Full
    # width gives about 70 px for the same span.
    box('comment', 30, 1760, 120, 20, 'mock body', 1, 0, extra=OD([
        ('presentation', 1), ('presentation_rect', [4.0, 192.0, 120.0, 15.0]),
        ('fontsize', 9.0), ('varname', 'mbzmocklabel')]))
    for mi, (tag, label, joint, axis, lo, hi) in enumerate(MOCKS):
        sy = 212.0 + mi * 18.0
        box('comment', 30 + mi * 300, 1640, 90, 20, label, 1, 0, extra=OD([
            ('presentation', 1), ('presentation_rect', [4.0, sy, 64.0, 15.0]),
            ('fontsize', 9.0), ('varname', 'mbzmocklab_%s' % tag)]))
        sl = box('slider', 30 + mi * 300, 1670, 140, 18, None, 1, 1, [''], extra=OD([
            ('size', 1000.0), ('presentation', 1),
            ('presentation_rect', [70.0, sy + 1.0, 420.0, 13.0]),
            ('varname', 'mbzmock_%s' % tag)]))
        sc = obj('scale 0. 999. %s %s' % (lo, hi), 30 + mi * 300, 1700, 190, 6, 1, ['float'])
        L(sl, 0, sc, 0)
        snd = obj('s ---mbMock%s' % tag, 30 + mi * 300, 1730, 150, 1, 0)
        L(sc, 0, snd, 0)

    # Row and column labels, so the window reads like the table in the book.
    for zone, r in ZONE_ROW.items():
        shown = {'ABOVE': 'ABOVE HEAD', 'LEFT': 'LEFT SIDE', 'RIGHT': 'RIGHT SIDE'}[zone]
        box('comment', 30, 1800 + r * 24, 100, 20, shown, 1, 0, extra=OD([
            ('presentation', 1),
            ('presentation_rect', [2.0, float(GY + r * ROWH + 17), float(LABW), 15.0]),
            ('fontsize', 9.0), ('varname', 'mbzlab_row%d' % r)]))
    for hand, c in (('L hand', 0), ('R hand', 1), ('both hands', 2)):
        box('comment', 200 + c * 120, 1800, 100, 20, hand, 1, 0, extra=OD([
            ('presentation', 1),
            ('presentation_rect', [float(GX + c * COLW), 4.0, 100.0, 15.0]),
            ('fontsize', 9.0), ('varname', 'mbzlab_col%d' % c)]))

    # [left, top, width, height] - what the floating window actually opens at.
    return finish([200, 200, 546, 340], presentation=True), cell_patch_span



# ----------------------------------------------------------------- the root patch

def rootbox(root, i, mc, nin, nout, rect, text=None, ot=None, patcher=None, extra=None):
    b = mkbox(i, mc, nin, nout, rect, text, ot, patcher, extra)
    root['boxes'].append(OD(box=b))
    return i


def strip_generated(root):
    """Remove everything a previous run made, so a rebuild is idempotent."""
    gone = {b['box']['id'] for b in root['boxes']
            if str(b['box'].get('varname', '')).startswith(MARK)}
    root['boxes'] = [b for b in root['boxes'] if b['box']['id'] not in gone]
    root['lines'] = [l for l in root['lines']
                     if l['patchline']['source'][0] not in gone
                     and l['patchline']['destination'][0] not in gone]
    return gone


def main():
    doc = json.load(open(P), object_pairs_hook=OD)
    root = doc['patcher']
    appversion = root['appversion']

    strip_generated(root)

    # mb_body fed only mb_zones, so its outlet had no fan-out and no ordering problem.
    # Adding the panel creates one.  Max does not define the order of an unforced
    # fan-out, so route both through [t l l]: it fires right to left, the zones get the
    # frame first, and the panel sees flags that are already up to date.
    root['lines'] = [l for l in root['lines']
                     if not (l['patchline']['source'] == [BODY, 0]
                             and l['patchline']['destination'] == [ZONES, 0])]

    used = {b['box']['id'] for b in root['boxes']}
    seq = [0]

    def nid():
        while True:
            seq[0] += 1
            i = 'obj-%d' % (900 + seq[0])
            if i not in used:
                used.add(i)
                return i

    def L(s, so, d, di):
        root['lines'].append(OD(patchline=OD(destination=[d, di], source=[s, so])))

    X0, Y0 = 20.0, 2060.0        # below everything else in the patch
    cmtN = [0]

    def note(t, dx, dy, w=760):
        cmtN[0] += 1
        return rootbox(root, nid(), 'comment', 1, 0, [X0 + dx, Y0 + dy, w, 20], t,
                       extra=OD([('varname', '%snote%d' % (MARK, cmtN[0]))]))

    note('THE ZONE MAPPING LAYER.  Generated by build_cells.py - regenerate, never hand-edit.', 0, -30)
    note('mb_body feeds [t l l]: outlet 1 fires first and gives mb_zones the frame, so the', 0, -10)
    note('flags are already current when outlet 0 hands the same list to the panel.', 0, 10)

    tll = rootbox(root, nid(), 'newobj', 1, 2, [X0, Y0 + 40, 80, 22], 't l l',
                  ['', ''], extra=OD([('varname', MARK + 'split')]))
    L(BODY, 0, tll, 0)
    L(tll, 1, ZONES, 0)

    panelpatch, spans = build_panel(appversion)
    nth = 0
    for b in panelpatch['boxes']:
        if b['box'].get('text') == 'p mb_cell':
            b['box']['patcher'] = build_cell(appversion, nth + 1, spans[nth])
            nth += 1
        elif b['box'].get('text') == 'p mb_stepper':
            b['box']['patcher'] = build_stepper(appversion)

    panel = rootbox(root, nid(), 'newobj', 4, 1, [X0, Y0 + 90, 160, 22],
                    'p mb_zone_panel', [''], panelpatch,
                    extra=OD([('varname', MARK + 'panel')]))
    L(tll, 0, panel, 1)
    L(ZONES, 0, panel, 2)
    L(ZONES, 2, panel, 3)

    # ---- settle the body scale when MOCK is selected ------------------------
    # mb_body smooths the spine length with [slide 15 15] from a 0.25 m floor, which
    # takes ~60 frames.  In LIVE that is 2 s of camera and nobody is performing yet.
    # In MOCK - sliders only there is no metro: the existing [sel 1] seeds the joints
    # exactly ONCE, so the scale reaches only ~0.27 and every coordinate comes out up
    # to 2.2x too large - raw -1.0 m reads as -4.0 body lengths.  That is what made
    # SET RANGE record -4 and +4, and it moved every zone threshold too.
    # Re-bang the same joints 100 times so the filter converges before anyone touches
    # a slider.  Purely additive: the existing seeding path is untouched.
    seedsrc = None
    for b in root['boxes']:
        if str(b['box'].get('text', '')) == '== 2':
            seedsrc = b['box']['id']
    mockpaks = [b['box']['id'] for b in root['boxes']
                if str(b['box'].get('text', '')).startswith('pak ')]
    if seedsrc and mockpaks:
        note('Settle the body scale: [slide 15 15] needs ~60 frames and MOCK seeds once.', 0, 320)
        ssel = rootbox(root, nid(), 'newobj', 2, 2, [X0, Y0 + 350, 70, 22], 'sel 1',
                       ['bang', ''], extra=OD([('varname', MARK + 'seedsel')]))
        L(seedsrc, 0, ssel, 0)
        suzi = rootbox(root, nid(), 'newobj', 2, 3, [X0, Y0 + 380, 80, 22], 'uzi 100',
                       ['bang', 'bang', 'int'], extra=OD([('varname', MARK + 'seeduzi')]))
        L(ssel, 0, suzi, 0)
        for mp in mockpaks:
            L(suzi, 0, mp, 0)

    # ---- the mapping window's mock sliders reach the real mock joints -------
    # Located by their text, not by a hardcoded id, so this survives the patch being
    # renumbered.  handL is the pak seeded at x = -0.35, handR at x = +0.35.
    paks = {}
    for b in root['boxes']:
        t = str(b['box'].get('text', ''))
        if t.startswith('pak -0.35 0.3'):
            paks['L'] = b['box']['id']
        elif t.startswith('pak 0.35 0.3'):
            paks['R'] = b['box']['id']
    note('The mapping window has its own mock sliders; they arrive here and drive the', 0, 240)
    note('same [pak] objects the on-screen mock sliders do.', 0, 260)
    for mi, (tag, joint, axis) in enumerate([('LX', 'L', 0), ('LY', 'L', 1),
                                             ('RX', 'R', 0), ('RY', 'R', 1)]):
        if joint not in paks:
            continue
        r = rootbox(root, nid(), 'newobj', 0, 1, [X0 + mi * 180, Y0 + 290, 150, 22],
                    'r ---mbMock%s' % tag, [''],
                    extra=OD([('varname', MARK + 'mock' + tag)]))
        L(r, 0, paks[joint], axis)

    # ---- a BODY lamp on the device panel -----------------------------------
    # Every zone flag is multiplied by `valid`, which is 0 unless all five joints are
    # really tracked.  In LIVE with no camera attached that is always 0, so nothing can
    # move however far a slider is dragged - and until now there was nothing on screen
    # that said so.  Dragging a mock slider still reaches mb_body directly, which makes
    # the device look alive while every cell is inert.  This lamp is the difference
    # between a five-second diagnosis and an hour of hunting.
    note('BODY lamp: valid from mb_body (element 11).  Dark = no body, nothing can move.', 0, 400)
    vnth = rootbox(root, nid(), 'newobj', 2, 2, [X0 + 600, Y0 + 40, 90, 22], 'zl nth 11',
                   ['', ''], extra=OD([('varname', MARK + 'validnth')]))
    L(tll, 0, vnth, 0)
    vtog = rootbox(root, nid(), 'toggle', 1, 1, [X0 + 600, Y0 + 75, 20, 20], None, ['int'],
                   extra=OD([('presentation', 1),
                             ('presentation_rect', [438.0, 154.0, 13.0, 13.0]),
                             ('varname', MARK + 'validtog')]))
    L(vnth, 0, vtog, 0)
    rootbox(root, nid(), 'comment', 1, 0, [X0 + 640, Y0 + 75, 60, 20], 'body',
            extra=OD([('presentation', 1),
                      ('presentation_rect', [404.0, 153.0, 32.0, 15.0]),
                      ('fontsize', 9.0), ('varname', MARK + 'validlab')]))

    # ---- the button that opens the window ----------------------------------
    note('The window is a subpatcher opened with [pcontrol], exactly as Harmonic Filter', 0, 140)
    note('and Vector Grain do it.  The cells keep running whether it is open or shut.', 0, 160)

    btn = rootbox(root, nid(), 'live.text', 1, 2, [X0 + 400, Y0 + 40, 120, 15],
                  'ZONE MAPPING', ['', ''], extra=OD([
                      ('outputmode', 1), ('appearance', 2), ('parameter_enable', 1),
                      ('presentation', 1), ('presentation_rect', [4.0, 153.0, 120.0, 15.0]),
                      ('saved_attribute_attributes', live_param(
                          'Zone Mapping', 'Zones', 2, parameter_enum=['closed', 'open'],
                          parameter_mmax=1, parameter_invisible=2, parameter_modmode=0)),
                      ('texton', 'ZONE MAPPING'), ('varname', MARK + 'btn')]))
    note('nine cells - three zones x left / right / two hands', 400, 160, 340)
    # A readout on the device itself.  The mapping window can be hidden by Live the
    # moment you click a parameter, so without this there is no way to tell a MAP that
    # worked from one that silently did nothing.
    lastmap = rootbox(root, nid(), 'comment', 1, 0, [X0 + 400, Y0 + 200, 320, 20],
                      'nothing mapped yet', extra=OD([
                          ('presentation', 1),
                          ('presentation_rect', [130.0, 153.0, 270.0, 15.0]),
                          ('fontsize', 9.0), ('varname', MARK + 'hint')]))
    lmset = rootbox(root, nid(), 'newobj', 1, 1, [X0 + 400, Y0 + 170, 140, 22],
                    'prepend set', [''], extra=OD([('varname', MARK + 'lmset')]))
    L(panel, 0, lmset, 0)
    L(lmset, 0, lastmap, 0)

    bsel = rootbox(root, nid(), 'newobj', 2, 3, [X0 + 400, Y0 + 70, 90, 22], 'sel 1 0',
                   ['bang', 'bang', ''], extra=OD([('varname', MARK + 'bsel')]))
    L(btn, 0, bsel, 0)
    mopen = rootbox(root, nid(), 'message', 2, 1, [X0 + 400, Y0 + 105, 60, 22], 'open',
                    [''], extra=OD([('varname', MARK + 'mopen')]))
    mclose = rootbox(root, nid(), 'message', 2, 1, [X0 + 470, Y0 + 105, 60, 22], 'close',
                     [''], extra=OD([('varname', MARK + 'mclose')]))
    L(bsel, 0, mopen, 0)
    L(bsel, 1, mclose, 0)
    pctl = rootbox(root, nid(), 'newobj', 1, 1, [X0 + 400, Y0 + 140, 80, 22], 'pcontrol',
                   [''], extra=OD([('varname', MARK + 'pctl')]))
    L(mopen, 0, pctl, 0)
    L(mclose, 0, pctl, 0)
    L(pctl, 0, panel, 0)

    with open(P, 'w') as f:
        json.dump(doc, f, indent=4)       # insertion order, no sort_keys - CLAUDE.md

    print('built %d cell(s): %s' % (len(BUILD), ', '.join(c[0] for c in BUILD)))
    print('  root boxes now %d, patchlines %d' % (len(root['boxes']), len(root['lines'])))


if __name__ == '__main__':
    main()
