#!/usr/bin/env python3
"""build_presentation.py - turn the controller's six mapping slots into Live device
parameters, and lay out the device's presentation view.

WHY THIS EXISTS
    `umenu` does not persist its selection.  In a standalone patch that was a nuisance;
    in a Live Set you perform from it means the set opens with six `- off -` slots and
    makes no sound.  Objects with `parameter_enable` become Live *device parameters*,
    which are saved with the Live Set, drawn in the device strip, and automatable.
    So persistence and the presentation view are the same job, done once.

WHY IT IS SAFE
    Max's own object prototypes settle the outlet semantics:

        umenu   2 outlets:  0 index   1 symbol
        live.menu  3     :  0 index   1 symbol   2 raw 0-1
        flonum  1 outlet :  0 float
        live.numbox 2    :  0 value   1 raw 0-1

    The two outlets this patch actually uses map exactly - including umenu outlet 1 into
    [sprintf /movebeat/%s].  So this is a box swap with NO rewiring: every patchline and
    every object id is left alone, which is why verify_body.py / verify_zones.py keep
    passing by construction.

Idempotent - run it twice and the second run is a no-op.
Run from anywhere:  python3 synth/docs/verification/build_presentation.py
"""

import collections
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..', '..', '..'))
CTRL = os.path.join(ROOT, 'synth', 'controller', 'MoveBeatController.maxpat')
SYNTH = os.path.join(ROOT, 'synth', 'instrument', 'MoveBeatSynth.maxpat')

# MIN/MAX must span every parameter's legal range: detune reaches -24, cutoff 18000.
# See MAPPING.md for the table.  The range table auto-fills both fields when a parameter
# is picked, so these are rarely dragged by hand - which is just as well, because a
# -24..18000 numbox is coarse to drag and coarse to automate.
PARAM_MIN, PARAM_MAX = -24.0, 18000.0

ROWS = [  # (label, source-menu id, param id, min id, max id, curve id, sending id)
    ('LH', 'obj-71', 'obj-72', 'obj-73', 'obj-74', 'obj-75', 'obj-76'),
    ('RH', 'obj-89', 'obj-90', 'obj-91', 'obj-92', 'obj-93', 'obj-94'),
    ('LF', 'obj-107', 'obj-108', 'obj-109', 'obj-110', 'obj-111', 'obj-112'),
    ('RF', 'obj-125', 'obj-126', 'obj-127', 'obj-128', 'obj-129', 'obj-130'),
    ('HD', 'obj-143', 'obj-144', 'obj-145', 'obj-146', 'obj-147', 'obj-148'),
    ('TR', 'obj-161', 'obj-162', 'obj-163', 'obj-164', 'obj-165', 'obj-166'),
]
SOURCE_MENU = 'obj-3'
# A third input mode.  The existing wiring already produces it for free: [== 0] drives the
# OSC gate and [== 1] drives the auto-motion's metro, so index 2 turns BOTH off and leaves
# the sliders as the only source.  Without it the sliders are unusable - picking MOCK
# starts a `metro 33` that overwrites every joint 30x/s, erasing a drag within 33 ms.
INPUT_MODES = ['LIVE - Kinect via OSC 7400',
               'MOCK - auto motion',
               'MOCK - sliders only']
SLIDER_MODE_INDEX = 2
TRACKED_TOGGLE = 'obj-60'
ZONE_TOGGLES = ['obj-188', 'obj-190', 'obj-192',      # abv  L R both
                'obj-194', 'obj-196', 'obj-198',      # lft  L R both
                'obj-200', 'obj-202', 'obj-204']      # rgt  L R both
BUSY_TOGGLES = ['obj-207', 'obj-209']
ARMED_TOGGLE = 'obj-211'

# ---- presentation geometry -----------------------------------------------------------
# Live's device strip has a hard height budget (the "Device vertical limit", ~169 px).
# Six rows plus a zone monitor fit in ~151.
COL = {'label': (4, 46), 'src': (52, 56), 'prm': (112, 84), 'min': (200, 48),
       'max': (252, 48), 'crv': (304, 52), 'snd': (362, 48)}
ROW_Y = [34, 50, 66, 82, 98, 114]
ROW_H = 15
HDR_Y = 20
TITLE_Y = 2
ZONE_Y = 136


def load(path):
    with open(path) as f:
        return json.load(f, object_pairs_hook=collections.OrderedDict)


def save(path, doc):
    with open(path, 'w') as f:
        json.dump(doc, f, indent=4)


def items_of(box):
    """The menu's items, from whichever form the box is currently in.

    `umenu` stores them in `items` with ',' separators.  Once converted they live in
    `saved_attribute_attributes.valueof.parameter_enum` and `items` is gone - so reading
    only `items` would blank every menu on a second run.  That is what makes this
    function the difference between idempotent and destructive.
    """
    if box.get('maxclass') == 'live.menu':
        return list(box['saved_attribute_attributes']['valueof']['parameter_enum'])
    return [i for i in (box.get('items') or []) if i != ',']


def as_live(box, maxclass, longname, enum=None, mmin=0.0, mmax=1.0,
            initial=0, prect=None):
    """Rewrite a box in place into a live.* parameter, keeping its id and position."""
    keep_id = box['id']
    keep_rect = box['patching_rect']
    for k in list(box):
        if k not in ('id', 'patching_rect'):
            del box[k]
    box['maxclass'] = maxclass
    box['numinlets'] = 1
    if maxclass == 'live.menu':
        box['numoutlets'] = 3
        box['outlettype'] = ['', '', 'float']
    else:
        box['numoutlets'] = 2
        box['outlettype'] = ['', 'float']
    box['parameter_enable'] = 1
    box['patching_rect'] = keep_rect
    if prect:
        box['presentation'] = 1
        box['presentation_rect'] = [float(v) for v in prect]
    v = collections.OrderedDict()
    v['parameter_longname'] = longname
    v['parameter_shortname'] = longname
    v['parameter_type'] = 2 if enum else 0
    v['parameter_mmin'] = float(mmin)
    v['parameter_mmax'] = float(mmax)
    if enum:
        v['parameter_enum'] = list(enum)
    v['parameter_initial_enable'] = 1
    v['parameter_initial'] = [initial]
    v['parameter_unitstyle'] = 0
    box['saved_attribute_attributes'] = collections.OrderedDict([('valueof', v)])
    box['varname'] = longname.replace(' ', '_')
    box['id'] = keep_id
    return box


def show(box, prect):
    """Put an existing (non-parameter) object into the presentation view."""
    box['presentation'] = 1
    box['presentation_rect'] = [float(v) for v in prect]


def obj(oid, text, maxclass='newobj', **kw):
    b = collections.OrderedDict()
    b['id'] = oid
    b['maxclass'] = maxclass
    b['numinlets'] = kw.pop('numinlets', 1)
    b['numoutlets'] = kw.pop('numoutlets', 0)
    b['patching_rect'] = [float(v) for v in kw.pop('rect', [0, 0, 80, 22])]
    if text is not None:
        b['text'] = text
    for k, v in kw.items():
        b[k] = v
    return collections.OrderedDict([('box', b)])


def line(src, so, dst, di):
    return collections.OrderedDict([
        ('patchline', collections.OrderedDict([
            ('destination', [dst, di]), ('source', [src, so])]))])


LABEL_MARK = 'mb_pres_label'


def clear_generated(p):
    """Drop labels this script made last time, so re-running does not stack duplicates.

    They carry LABEL_MARK and are never referenced by a patchline, so removing them is
    safe.  They are always the highest ids too, so re-adding them reproduces the same
    ids - which is what keeps the whole build byte-identical on a second run.
    """
    wired = set()
    for e in p.get('lines', []):
        wired.add(e['patchline']['source'][0])
        wired.add(e['patchline']['destination'][0])

    def generated(b):
        if b.get('varname') == LABEL_MARK:
            return True
        # Labels made before LABEL_MARK existed carry no marker.  comment() is the only
        # thing that parks a box at x=1500, and a comment is never wired, so that pair of
        # conditions identifies them without risking a hand-placed object.
        return (b.get('maxclass') == 'comment'
                and b.get('patching_rect', [0])[0] == 1500.0
                and b['id'] not in wired)

    p['boxes'] = [e for e in p['boxes'] if not generated(e['box'])]


def clear_presentation(p):
    """Strip every presentation flag before laying out a new one.

    The synth already had a presentation view, 950 x 473 px - built when it was a
    standalone patch with a whole window to fill.  A Max for Live device gets ~169 px of
    height, so that layout cannot be kept; leaving the old flags on would also stack the
    old labels underneath the new ones.
    """
    for e in p['boxes']:
        e['box'].pop('presentation', None)
        e['box'].pop('presentation_rect', None)


def comment(oid, text, prect, fontsize=9.0):
    b = collections.OrderedDict()
    b['id'] = oid
    b['maxclass'] = 'comment'
    b['numinlets'] = 1
    b['numoutlets'] = 0
    b['patching_rect'] = [1500.0, 1700.0 + 20 * int(oid.split('-')[1]) % 400, 120.0, 20.0]
    b['presentation'] = 1
    b['presentation_rect'] = [float(v) for v in prect]
    b['text'] = text
    b['fontsize'] = fontsize
    b['varname'] = LABEL_MARK
    return collections.OrderedDict([('box', b)])


TBI = ['obj-81', 'obj-99', 'obj-117', 'obj-135', 'obj-153', 'obj-171']
LOAD_WINDOW_MS = 2000
GATE_MARK = 'gate 1 1'   # 1 outlet, OPEN by default - see the loadbang note below


def protect_restored_values(p, B):
    """Stop the patch from overwriting the values Live restores at load.

    Two separate bugs, both invisible until a Live Set is reopened:

    1. `loadbang -> [0] -> Input menu` forced the input source to LIVE on every load,
       destroying whatever Live had just restored.  Correct when that menu was a plain
       `umenu` and something had to seed it; wrong once it is a Live parameter, because
       Live owns the restore.  General M4L rule: never loadbang a `live.*` object that
       has parameter_enable.  The menu emits its own value at load (from
       parameter_initial, or from the Set), so the [t i i] -> [== 0]/[== 1] chain that
       configures the gates still runs - it just is not fought.

    2. Picking a parameter auto-fills MIN/MAX/CURVE from the range table.  Live's restore
       makes the menu emit, which fires that same auto-fill, which overwrites the MIN/MAX
       the user saved.  Measured in the .als: Live stored LH Min=500 / LH Max=8000
       correctly, and the patch replaced them with the table's 20 / 18000 on load.  The
       stored parameter order is alphabetical - Max, Min, then Prm - so Prm is restored
       last and clobbers the two before it.

    The fix for (2) closes a [gate] over the auto-fill for the first two seconds, so the
    restore lands untouched; afterwards picking a parameter fills the range exactly as
    before.  The gates are `gate 1 1` - OPEN by default - deliberately: a gate that
    defaults closed and relies on loadbang silently kills the feature whenever the patch
    is edited in Max, which this project has already been bitten by once.
    """
    lines = p['lines']
    if any((e['box'].get('text') or '') == GATE_MARK and
           e['box'].get('varname', '').startswith('fillgate') for e in p['boxes']):
        return 'already protected'

    # (1) cut the loadbang off the Input menu
    before = len(lines)
    p['lines'] = [e for e in lines
                  if not (e['patchline']['source'][0] == 'obj-9' and
                          e['patchline']['destination'][0] == SOURCE_MENU)]
    lines = p['lines']
    cut = before - len(lines)

    nid = max(int(e['box']['id'].split('-')[1]) for e in p['boxes'])

    def new(text, rect, **kw):
        nonlocal nid
        nid += 1
        oid = 'obj-%d' % nid
        p['boxes'].append(obj(oid, text, rect=rect, **kw))
        return oid

    X, Y = 1500.0, 90.0
    trig = new('t b b', [X, Y, 60.0, 22.0], numinlets=1, numoutlets=2,
               outlettype=['bang', 'bang'])
    close = new('0', [X + 90, Y + 34, 32.0, 22.0], maxclass='message',
                numinlets=2, numoutlets=1, outlettype=[''])
    dely = new('del %d' % LOAD_WINDOW_MS, [X, Y + 34, 80.0, 22.0],
               numinlets=2, numoutlets=1, outlettype=['bang'])
    openm = new('1', [X, Y + 68, 32.0, 22.0], maxclass='message',
                numinlets=2, numoutlets=1, outlettype=[''])
    new('Live restores device parameters at load. For %d ms the range auto-fill is '
        'held shut so the restored MIN/MAX survive; after that it works normally.'
        % LOAD_WINDOW_MS,
        [X + 140, Y, 330.0, 60.0], maxclass='comment', numinlets=1, numoutlets=0)

    # [t b b] fires right-to-left: close the gates first, then start the timer.
    lines.append(line('obj-8', 0, trig, 0))
    lines.append(line(trig, 1, close, 0))
    lines.append(line(trig, 0, dely, 0))
    lines.append(line(dely, 0, openm, 0))

    made = []
    for ri, prm in enumerate([r[2] for r in ROWS]):
        tbi = TBI[ri]
        # drop the direct PARAM -> [t b i] link, keeping PARAM -> [!= 0] untouched:
        # the slot must still be enabled by a restored parameter.
        p['lines'] = [e for e in p['lines']
                      if not (e['patchline']['source'][0] == prm and
                              e['patchline']['source'][1] == 0 and
                              e['patchline']['destination'][0] == tbi)]
        lines = p['lines']
        g = new(GATE_MARK, [X, Y + 110 + 30 * ri, 70.0, 22.0],
                numinlets=2, numoutlets=1, outlettype=[''], varname='fillgate%d' % ri)
        lines.append(line(close, 0, g, 0))
        lines.append(line(openm, 0, g, 0))
        lines.append(line(prm, 0, g, 1))      # gate's DATA inlet is the right one
        lines.append(line(g, 0, tbi, 0))
        made.append(g)
    return 'cut %d loadbang link, added %d fill-gates' % (cut, len(made))


# ---- the synth panel -----------------------------------------------------------------
# (control id, default-message id, parameter name, min, max, enum-or-None)
# Ranges are the same table the controller's slots use - see MAPPING.md.
SYNTH_PANEL = [
    ('OSC', [
        ('obj-29', 'obj-30', 'osc1wave', 0, 3, 'wave'),
        ('obj-33', 'obj-34', 'osc2wave', 0, 3, 'wave'),
        ('obj-37', 'obj-38', 'osc1level', 0, 1, None),
        ('obj-41', 'obj-42', 'osc2level', 0, 1, None),
        ('obj-45', 'obj-46', 'sublevel', 0, 1, None),
        ('obj-49', 'obj-50', 'detune', -24, 24, None)]),
    ('TONE', [
        ('obj-53', 'obj-54', 'pw', 0.05, 0.95, None),
        ('obj-58', 'obj-59', 'cutoff', 20, 18000, None),
        ('obj-62', 'obj-63', 'resonance', 0, 4, None),
        ('obj-66', 'obj-67', 'drive', 0, 1, None),
        ('obj-70', 'obj-71', 'rescomp', 0, 1, None),
        ('obj-105', 'obj-106', 'outgain', 0, 1, None)]),
    ('AMP ENV', [
        ('obj-84', 'obj-85', 'ampA', 0, 2000, None),
        ('obj-88', 'obj-89', 'ampD', 0, 2000, None),
        ('obj-92', 'obj-93', 'ampS', 0, 1, None),
        ('obj-96', 'obj-97', 'ampR', 0, 4000, None),
        ('obj-101', 'obj-102', 'glide', 0, 2000, None),
        ('obj-75', 'obj-76', 'lfoRate', 0.01, 20, None)]),
    ('FILT ENV', [
        ('obj-110', 'obj-111', 'filtA', 0, 2000, None),
        ('obj-114', 'obj-115', 'filtD', 0, 2000, None),
        ('obj-118', 'obj-119', 'filtS', 0, 1, None),
        ('obj-122', 'obj-123', 'filtR', 0, 4000, None),
        ('obj-126', 'obj-127', 'filtEnvAmt', 0, 8000, None),
        ('obj-79', 'obj-80', 'lfoDepth', 0, 5000, None)]),
]
SYNTH_LOADBANG_T = 'obj-16'    # [t b b]: out0 banged the 24 defaults, out1 sets target 0
SYNTH_COL_X = [4, 118, 232, 346]
SYNTH_ROW_Y = [40, 57, 74, 91, 108, 125]


def build_synth():
    """Same job for the instrument: panel controls become Live device parameters.

    The synth had the identical bug-1: `loadbang -> [t b b] -> 24 default-value messages`
    reset every panel control on load, which would overwrite whatever Live restored.  The
    defaults move into `parameter_initial` instead, so a fresh device still comes up
    correct while a saved Set wins.

    Only outlet 0 of the [t b b] is cut.  Outlet 1 sends `target 0` to poly~ and has
    nothing to do with the panel - cutting it would break voice allocation.

    The default-value message boxes are left in place and still work when clicked, so the
    'reset this control' affordance survives.

    No fill-gate is needed here: nothing in the synth writes to a panel control in
    response to another parameter.  OSC from the controller goes straight to poly~ and
    never touches the panel, which is why the two can coexist.
    """
    doc = load(SYNTH)
    p = doc['patcher']
    clear_generated(p)
    clear_presentation(p)
    B = {e['box']['id']: e['box'] for e in p['boxes']}

    cut = 0
    keep = []
    for e in p['lines']:
        l = e['patchline']
        if l['source'][0] == SYNTH_LOADBANG_T and l['source'][1] == 0:
            cut += 1
            continue
        keep.append(e)
    p['lines'] = keep

    nid = max(int(e['box']['id'].split('-')[1]) for e in p['boxes'])
    labels = []
    for ci, (section, rows) in enumerate(SYNTH_PANEL):
        x = SYNTH_COL_X[ci]
        labels.append((section, (x, 24, 104, 14), 8.0))
        for ri, (ctl, dfl, name, lo, hi, kind) in enumerate(rows):
            y = SYNTH_ROW_Y[ri]
            box = B[ctl]
            default = B[dfl].get('text', '0')
            try:
                initial = float(default)
            except ValueError:
                initial = 0.0
            enum = items_of(box) if kind == 'wave' else None
            if kind == 'wave' and not enum:
                enum = ['saw', 'square', 'tri', 'sine']
            as_live(box, 'live.menu' if enum else 'live.numbox', name,
                    enum=enum, mmin=lo, mmax=(len(enum) - 1) if enum else hi,
                    initial=int(initial) if enum else initial,
                    prect=(x + 58, y, 46, 15))
            labels.append((name, (x, y, 56, 14), 8.0))

    labels.append(('MOVEBEAT SYNTH', (4, 2, 200, 18), 11.0))
    for txt, rect, size in labels:
        nid += 1
        p['boxes'].append(comment('obj-%d' % nid, txt, rect, size))

    p['openinpresentation'] = 1
    save(SYNTH, doc)

    B2 = {e['box']['id']: e['box']
          for e in load(SYNTH)['patcher']['boxes']}
    params = [b['saved_attribute_attributes']['valueof']['parameter_longname']
              for b in B2.values() if b.get('parameter_enable')]
    shown = [b for b in B2.values() if b.get('presentation')]
    ext = [b['presentation_rect'] for b in shown]
    w = max(r[0] + r[2] for r in ext)
    h = max(r[1] + r[3] for r in ext)
    print('\nMoveBeatSynth.maxpat')
    print('   cut %d loadbang->default links (kept out1 -> "target 0")' % cut)
    print('   %d Live device parameters' % len(params))
    print('   presentation extent: %.0f x %.0f px' % (w, h))
    if h > 169:
        print('   !! TALLER THAN THE DEVICE LIMIT')
    if len(set(params)) != len(params):
        sys.exit('!! duplicate parameter_longname in the synth')
    print('   parameter names unique: yes')


MB_BODY = 'obj-178'
MB_BODY_TRIGGER_INLET = 5
MOCK_PAKS = ['obj-16', 'obj-18', 'obj-20', 'obj-22',
             'obj-24', 'obj-26', 'obj-28', 'obj-30']
VALID_MARK = 'mock_tracked'


def fix_mock_valid(p):
    """Let the mock sliders actually drive the zone layer.

    `mb_body`'s inlet 5 is the frame trigger, and it reaches `[t b i]`: the `b` re-emits
    the output list, the `i` feeds `valid`.  Over real OSC the number arriving there is
    `/mb/tracked`, i.e. 1.  But the root patch also wires all eight mock `pak` objects
    into that inlet, and a `pak` sends a LIST.  Max's `trigger` takes a list's first
    element for an `i` outlet, so `valid` became `int(joint.x)` - `int(-0.35)` = 0.  Every
    zone code is multiplied by `valid`, so all nine flags stayed dark no matter how the
    sliders moved.

    `mb_sources` survives the identical wiring because its trigger inlet is `[t b]` -
    bang only, never reads the value.  That asymmetry was the whole bug.

    The fix: send the eight mock paks through one `[t 1]`, so the trigger inlet receives
    the integer 1 - the same thing the OSC path and the auto-motion already send - instead
    of a joint list.  The two device sources keep their direct connections; they were
    always correct.

    Why it matters beyond tidiness: the auto-motion swings each hand about its own side of
    the body and neither hand ever crosses the midline, so four of the nine cells -
    lftR, lftB, rgtL, rgtB - are unreachable without the sliders.
    """
    if any(e['box'].get('varname') == VALID_MARK for e in p['boxes']):
        return 'already fixed'

    before = len(p['lines'])
    p['lines'] = [e for e in p['lines']
                  if not (e['patchline']['source'][0] in MOCK_PAKS and
                          e['patchline']['destination'][0] == MB_BODY and
                          e['patchline']['destination'][1] == MB_BODY_TRIGGER_INLET)]
    cut = before - len(p['lines'])
    if cut != len(MOCK_PAKS):
        sys.exit('expected %d mock-pak trigger links, found %d - patch has changed'
                 % (len(MOCK_PAKS), cut))

    nid = max(int(e['box']['id'].split('-')[1]) for e in p['boxes'])
    tid = 'obj-%d' % (nid + 1)
    p['boxes'].append(obj(tid, 't 1', rect=[20.0, 690.0, 40.0, 22.0],
                          numinlets=1, numoutlets=1, outlettype=[''],
                          varname=VALID_MARK))
    p['boxes'].append(obj('obj-%d' % (nid + 2),
                          'The mock paks send a LIST; [t b i] inside mb_body would read '
                          'its first element as "tracked" and get 0. This makes it a 1.',
                          maxclass='comment', numinlets=1, numoutlets=0,
                          rect=[70.0, 688.0, 380.0, 34.0]))
    for pk in MOCK_PAKS:
        p['lines'].append(line(pk, 0, tid, 0))
    p['lines'].append(line(tid, 0, MB_BODY, MB_BODY_TRIGGER_INLET))
    return 'routed %d mock paks through [t 1]' % len(MOCK_PAKS)


def wire_mock_gate(p):
    """Report a tracked body while the mock sliders are driving.

    The `tracked` toggle - and through it `/movebeat/gate` - is fed only by `mb_osc_in`
    and `mb_automotion`.  Both are switched off in slider-only mode, so the synth's "body
    tracked" light stayed dark even though a complete body was being sent.  Factually
    there IS a body: the mock is one.  Feeding the same `[t 1]` that fixes `valid` into
    the toggle makes the mock self-consistent.

    Note this is the one place the mock touches `/movebeat/gate`, which is still an open
    musical decision (nothing acts on loss of tracking yet).  Sending 1 is safe precisely
    because nothing downstream acts on it - if that changes, revisit this line.
    """
    tid = next((e['box']['id'] for e in p['boxes']
                if e['box'].get('varname') == VALID_MARK), None)
    if tid is None:
        return 'no [t 1] found - run fix_mock_valid first'
    if any(e['patchline']['source'][0] == tid and
           e['patchline']['destination'][0] == TRACKED_TOGGLE for e in p['lines']):
        return 'already wired'
    p['lines'].append(line(tid, 0, TRACKED_TOGGLE, 0))
    return '[t 1] -> tracked toggle -> /movebeat/gate'


SEED_MARK = 'slider_mode_seed'


def add_slider_mode(p, B):
    """Make "MOCK - sliders only" usable by seeding the joints when it is selected.

    Selecting the mode is free - [== 0] and [== 1] both go false, so the OSC gate and the
    auto-motion metro are both off and nothing fights the sliders.  But the zone layer
    needs every one of its five joints to have reported `trackingState == 2` at least
    once, or `valid` stays 0 and the nine flags stay dark.  Until a slider is touched,
    that joint has never reported.

    So entering the mode bangs all eight mock `pak` objects, which re-emit their stored
    values.  One bang, and the whole zone layer has a complete body to work from.
    """
    if any(e['box'].get('varname') == SEED_MARK for e in p['boxes']):
        return 'already present'
    nid = max(int(e['box']['id'].split('-')[1]) for e in p['boxes'])
    eq = 'obj-%d' % (nid + 1)
    sel = 'obj-%d' % (nid + 2)
    p['boxes'].append(obj(eq, '== %d' % SLIDER_MODE_INDEX, rect=[220.0, 156.0, 50.0, 22.0],
                          numinlets=2, numoutlets=1, outlettype=[''], varname=SEED_MARK))
    p['boxes'].append(obj(sel, 'sel 1', rect=[220.0, 190.0, 45.0, 22.0],
                          numinlets=2, numoutlets=2, outlettype=['bang', '']))
    p['boxes'].append(obj('obj-%d' % (nid + 3),
                          'Entering slider-only mode bangs every mock pak once, so all '
                          'five zone joints have reported and `valid` can go 1.',
                          maxclass='comment', numinlets=1, numoutlets=0,
                          rect=[280.0, 156.0, 330.0, 34.0]))
    # obj-5 is the [t i i] the input menu feeds; take the same value it hands [== 0].
    p['lines'].append(line('obj-5', 1, eq, 0))
    p['lines'].append(line(eq, 0, sel, 0))
    for pk in MOCK_PAKS:
        p['lines'].append(line(sel, 0, pk, 0))
    return 'added mode %d + seed bang to %d paks' % (SLIDER_MODE_INDEX, len(MOCK_PAKS))


def main():
    doc = load(CTRL)
    p = doc['patcher']
    clear_generated(p)
    B = {e['box']['id']: e['box'] for e in p['boxes']}

    if B[ROWS[0][1]].get('maxclass') == 'live.menu':
        print('Already converted - re-laying out presentation only.')

    # ---- the six mapping rows --------------------------------------------------------
    for ri, (key, src, prm, mn, mx, crv, snd) in enumerate(ROWS):
        y = ROW_Y[ri]
        src_items = items_of(B[src]) or ['X', 'Y', 'Z', 'SPEED', 'SPREAD', 'LEAN']
        prm_items = items_of(B[prm])
        crv_items = items_of(B[crv]) or ['LIN', 'EXP']
        if not prm_items:
            sys.exit('%s: parameter menu has no items - refusing to guess' % prm)

        as_live(B[src], 'live.menu', '%s Src' % key, enum=src_items,
                mmax=len(src_items) - 1, prect=(COL['src'][0], y, COL['src'][1], ROW_H))
        as_live(B[prm], 'live.menu', '%s Prm' % key, enum=prm_items,
                mmax=len(prm_items) - 1, prect=(COL['prm'][0], y, COL['prm'][1], ROW_H))
        as_live(B[mn], 'live.numbox', '%s Min' % key, mmin=PARAM_MIN, mmax=PARAM_MAX,
                initial=0.0, prect=(COL['min'][0], y, COL['min'][1], ROW_H))
        as_live(B[mx], 'live.numbox', '%s Max' % key, mmin=PARAM_MIN, mmax=PARAM_MAX,
                initial=0.0, prect=(COL['max'][0], y, COL['max'][1], ROW_H))
        as_live(B[crv], 'live.menu', '%s Crv' % key, enum=crv_items,
                mmax=len(crv_items) - 1, prect=(COL['crv'][0], y, COL['crv'][1], ROW_H))
        # SENDING stays a plain flonum: it is a readout, not something Live should
        # automate.  Giving it parameter_enable would put a meaningless entry in every
        # automation menu.
        show(B[snd], (COL['snd'][0], y, COL['snd'][1], ROW_H))

    # ---- input source, tracked light -------------------------------------------------
    as_live(B[SOURCE_MENU], 'live.menu', 'Input', enum=INPUT_MODES,
            mmax=len(INPUT_MODES) - 1, prect=(232, TITLE_Y, 138, ROW_H))
    show(B[TRACKED_TOGGLE], (394, TITLE_Y, 14, 14))

    # ---- zone monitor ----------------------------------------------------------------
    # Left as plain toggles on purpose: they are driven BY mb_zones, so they are
    # indicators, not controls.  parameter_enable here would invite Live to automate a
    # value the patch overwrites 30 times a second.
    groups = [(44, ZONE_TOGGLES[0:3]), (130, ZONE_TOGGLES[3:6]), (220, ZONE_TOGGLES[6:9])]
    for x0, ids in groups:
        for k, oid in enumerate(ids):
            show(B[oid], (x0 + 16 * k, ZONE_Y, 13, 13))
    for k, oid in enumerate(BUSY_TOGGLES):
        show(B[oid], (302 + 16 * k, ZONE_Y, 13, 13))
    show(B[ARMED_TOGGLE], (364, ZONE_Y, 13, 13))

    # ---- labels ----------------------------------------------------------------------
    existing = {e['box'].get('text'): e['box']['id']
                for e in p['boxes'] if e['box'].get('maxclass') == 'comment'}
    nid = max(int(e['box']['id'].split('-')[1]) for e in p['boxes'])

    def add(text, prect, size=9.0):
        nonlocal nid
        nid += 1
        p['boxes'].append(comment('obj-%d' % nid, text, prect, size))

    labels = [
        ('MOVEBEAT  movement → sound', (4, TITLE_Y, 200, 18), 11.0),
        ('SOURCE', (COL['src'][0], HDR_Y, COL['src'][1], 14), 8.0),
        ('PARAMETER', (COL['prm'][0], HDR_Y, COL['prm'][1], 14), 8.0),
        ('MIN', (COL['min'][0], HDR_Y, COL['min'][1], 14), 8.0),
        ('MAX', (COL['max'][0], HDR_Y, COL['max'][1], 14), 8.0),
        ('CURVE', (COL['crv'][0], HDR_Y, COL['crv'][1], 14), 8.0),
        ('SENDING', (COL['snd'][0], HDR_Y, COL['snd'][1], 14), 8.0),
        ('ABOVE', (4, ZONE_Y, 38, 14), 8.0),
        ('LEFT', (94, ZONE_Y, 32, 14), 8.0),
        ('RIGHT', (180, ZONE_Y, 36, 14), 8.0),
        ('busy', (272, ZONE_Y, 26, 14), 8.0),
        ('fire', (340, ZONE_Y, 22, 14), 8.0),
        ('L · R · both', (384, ZONE_Y, 70, 14), 8.0),
    ]
    for txt, rect, size in labels:
        add(txt, rect, size)

    # row labels: reuse the HAND L / HAND R / ... comments already in the patch
    for ri, (key, *_rest) in enumerate(ROWS):
        pass
    for name, ri in (('HAND L', 0), ('HAND R', 1), ('FOOT L', 2),
                     ('FOOT R', 3), ('HEAD', 4), ('TORSO', 5)):
        oid = existing.get(name)
        if oid:
            show(B[oid], (COL['label'][0], ROW_Y[ri], COL['label'][1], 14))
            B[oid]['fontsize'] = 8.0

    protect_restored_values(p, B)
    print('   valid fix: %s' % fix_mock_valid(p))
    print('   slider mode: %s' % add_slider_mode(p, B))
    print('   mock gate : %s' % wire_mock_gate(p))
    p['openinpresentation'] = 1

    save(CTRL, doc)

    # ---- report ----------------------------------------------------------------------
    doc2 = load(CTRL)
    p2 = doc2['patcher']
    B2 = {e['box']['id']: e['box'] for e in p2['boxes']}
    params = [(b['saved_attribute_attributes']['valueof']['parameter_longname'],
               b['maxclass'])
              for b in B2.values() if b.get('parameter_enable')]
    shown = [b for b in B2.values() if b.get('presentation')]
    ext = [b['presentation_rect'] for b in shown]
    w = max(r[0] + r[2] for r in ext)
    h = max(r[1] + r[3] for r in ext)
    print('MoveBeatController.maxpat')
    print('   %d Live device parameters:' % len(params))
    for n, mc in sorted(params):
        print('      %-10s %s' % (n, mc))
    print('   %d objects in the presentation view' % len(shown))
    print('   presentation extent: %.0f x %.0f px  (Live vertical limit is ~169)' % (w, h))
    if h > 169:
        print('   !! TALLER THAN THE DEVICE LIMIT - Live will clip the bottom')
    names = [n for n, _ in params]
    if len(set(names)) != len(names):
        sys.exit('!! duplicate parameter_longname - Live requires unique names')
    print('   parameter names unique: yes')
    build_synth()


if __name__ == '__main__':
    main()
