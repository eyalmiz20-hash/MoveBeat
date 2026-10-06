# verify_cells.py - behavioural verification of [p mb_cell], the zone mapping cell.
#
# Same method as verify_body.py / verify_zones.py: this does NOT re-implement the cell.
# It loads MoveBeatController.maxpat, finds the real [p mb_cell] graph inside
# [p mb_zone_panel], and replays it under Max's message semantics - outlets fire right
# to left, inlet 0 is hot except [gate] whose data inlet is the right one, cold inlets
# store, [f] emits only when banged.  A mis-wired patchline fails these tests.
#
# STATED LIMIT, because it matters here more than anywhere else in this repo:
#   The Live Object Model cannot be replayed.  live.path, live.object, live.remote~ and
#   live.thisdevice are STUBBED AT THE BOUNDARY - they record what they were asked to do
#   and hand back a fixed fake id and path.  So these tests prove the cell's arithmetic
#   and message ordering: the modes, pickup, SET RANGE, source selection and behaviour on
#   loss of tracking.  They prove NOTHING about whether Live accepts the mapping, whether
#   a parameter is really acquired by clicking it, or whether anything survives a save.
#   Those four can only be established inside Live, by hand.
#
# Run from the repo root:  python3 synth/docs/verification/verify_cells.py
#
# THE CLOCK MATTERS NOW.  Since the attack envelope (2026-10-06) a cell's output is a
# function of TIME as well as of movement: entering a zone starts a [line] ramp that the
# cell keeps crossfading along for ATTACK ms.  So frame() advances a virtual millisecond
# clock the way the camera would, settle() runs it past the end of an attack, and the
# model of [line] below is what makes both mean anything.  A test that checks a value
# without saying when it looked is testing nothing in particular.

import json, math, re, os, sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import zone_constants as Z

ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..')
doc = json.load(open(os.path.join(ROOT, 'synth', 'controller', 'MoveBeatController.maxpat')))


def find(patcher, text):
    """Depth-first search for a subpatcher box with this text."""
    for b in patcher.get('boxes', []):
        bb = b['box']
        if bb.get('text') == text and 'patcher' in bb:
            return bb['patcher']
        if 'patcher' in bb:
            got = find(bb['patcher'], text)
            if got:
                return got
    return None


def find_all(patcher, text, out=None):
    if out is None:
        out = []
    for b in patcher.get('boxes', []):
        bb = b['box']
        if bb.get('text') == text and 'patcher' in bb:
            out.append(bb['patcher'])
        elif 'patcher' in bb:
            find_all(bb['patcher'], text, out)
    return out


ALL_CELLS = find_all(doc['patcher'], 'p mb_cell')
if not ALL_CELLS:
    print('FAIL: no [p mb_cell] in the patch - run build_cells.py first')
    sys.exit(1)

# Each cell has its zone's movement span baked in, so the behavioural tests below have
# to replay a LEFT-side cell.  Which one that is comes from zone_constants.py rather than
# from a literal: picking whichever cell happened to be first would silently test the
# wrong geometry, and a hard-coded -1.15 would silently test the wrong build.
LEFT_LO = ' '.join('%g' % Z.SPANS['LEFT'][a][0] for a in range(4))
CELL = None
for cp in ALL_CELLS:
    tables = [str(b['box'].get('text', '')) for b in cp['boxes']
              if b['box'].get('maxclass') == 'message']
    if LEFT_LO in tables:
        CELL = cp
        break
if CELL is None:
    print('FAIL: no cell carries the LEFT span %r.' % LEFT_LO)
    print('      run:  python3 synth/docs/verification/build_cells.py '
          'abvL abvR lftL lftR lftB rgtL rgtR rgtB')
    sys.exit(1)

class Cell:
    """A replay of the real mb_cell graph."""

    def __init__(s, p):
        s.BOX = {b['box']['id']: b['box'] for b in p['boxes']}
        s.FAN = {}
        for L in p['lines']:
            l = L['patchline']
            s.FAN.setdefault(tuple(l['source']), []).append(tuple(l['destination']))
        s.st = {i: [0.0] * max(1, b['numinlets']) for i, b in s.BOX.items()}
        s.last = {}
        s.remote = []          # every value that reached live.remote~
        s.lom_errors = []      # complaints from the stubbed Live objects
        s.printed = []         # what the device said in the Max console
        s.timers = {}          # a virtual clock, for [del]
        s.lines = {}           # and for [line], which ramps on that same clock
        s.now = 0.0
        s.outs = {}            # outlet index -> last value
        byx = sorted(s.BOX.values(), key=lambda z: z['patching_rect'][0])
        s.inlets = [b['id'] for b in byx if b['maxclass'] == 'inlet']
        s.outlets = [b['id'] for b in byx if b['maxclass'] == 'outlet']
        # [f] initial values come from their argument
        for i, b in s.BOX.items():
            t = b.get('text', '') or ''
            if re.match(r'^[fi]\s+[-0-9.]+$', t):
                # [i] is [f] that truncates.  The scene readout needs it: sprintf's
                # %ld is fed from here and a float would arrive as "1." not "1".
                a = float(t.split()[1])
                s.st[i][1] = a if t[0] == 'f' else int(a)
            if t.startswith('zl nth '):
                s.st[i][1] = int(t.split()[2])
            if re.match(r'^pa[ck]k?(\s|$)', t):
                # [pack 1. 250] really does START holding 1 and 250 - its arguments are
                # its initial values, and a bang outputs them.  The model used to start
                # every pack at zeros, so a bang produced "0 250" instead of "1 250" and
                # the envelope ramped to 0: the attack existed and did nothing.  Exactly
                # the lenient-stub failure CLAUDE.md records, in a second place.
                for k, a in enumerate(t.split()[1:]):
                    if k < len(s.st[i]):
                        try:
                            s.st[i][k] = float(a)
                        except ValueError:
                            s.st[i][k] = a
            if re.match(r'^line(\s|$)', t):
                a = t.split()[1:]
                s.lines[i] = {'v': float(a[0]) if a else 0.0,
                              'grain': float(a[1]) if len(a) > 1 else 20.0,
                              'start': 0.0, 'target': 0.0, 'dur': 0.0,
                              't0': 0.0, 'next': 0.0, 'running': False}
            if t.startswith('uzi') and len(t.split()) > 1:
                s.st[i][1] = float(t.split()[1])
            if t.startswith('change'):
                s.last[i] = None
            g = t.split()
            if g and g[0] == 'gate' and len(g) > 2:
                s.st[i][0] = float(g[2])   # [gate 1 1] is open before anyone sets it
        s.recv = {}
        for i, b in s.BOX.items():
            t = b.get('text', '') or ''
            if t.startswith('r '):
                s.recv.setdefault(t.split(None, 1)[1], []).append(i)

    def advance(s, ms):
        """Move the virtual clock, firing whatever comes due on the way.

        Both kinds of event have to be interleaved in real time rather than batched:
        a [del] that fires can start a [line], and a [line] that reaches 1 can be what
        a later assertion is about.  So this walks to the next due event, whichever kind
        it is, and rescans - because handling one can create another."""
        end = s.now + ms
        while True:
            nxt = None
            for oid, due in s.timers.items():
                if due <= end and (nxt is None or due < nxt[0]):
                    nxt = (due, 'del', oid)
            for oid, st in s.lines.items():
                if st['running'] and st['next'] <= end and (nxt is None or st['next'] < nxt[0]):
                    nxt = (st['next'], 'line', oid)
            if nxt is None:
                break
            s.now = max(s.now, nxt[0])
            if nxt[1] == 'del':
                s.timers.pop(nxt[2])
                s.emit(nxt[2], 0, 'bang')
            else:
                oid = nxt[2]
                st = s.lines[oid]
                frac = 1.0 if st['dur'] <= 0 else min(1.0, (s.now - st['t0']) / st['dur'])
                st['v'] = st['start'] + frac * (st['target'] - st['start'])
                if frac >= 1.0:
                    st['running'] = False
                else:
                    st['next'] = s.now + st['grain']
                s.emit(oid, 0, st['v'])
        s.now = end

    # ---------------------------------------------------------------- the LOM
    # These stubs are STRICT on purpose.  The first build of this cell passed every
    # test while being completely broken in Live, because the stub accepted a bare
    # number where Live needs the whole "id <n>" message.  A lenient stub is worse
    # than no stub: it certifies a patch that cannot work.
    @staticmethod
    def isid(x):
        return isinstance(x, list) and len(x) == 2 and str(x[0]) == 'id'

    @staticmethod
    def asked(v):
        return ' '.join(str(x) for x in v) if isinstance(v, list) else str(v)

    def lom(s, oid, inl, v, t):
        if t.startswith('live.remote~'):
            if isinstance(v, list) and not s.isid(v):
                s.lom_err('live.remote~ bound with %r, expected [id, n]' % (v,))
            s.remote.append(v)
            return True
        if t.startswith('live.thisdevice'):
            return True
        if t.startswith('live.path'):
            if inl == 0:
                # id 1 is this device; id 9 is some other device holding the clicked
                # parameter.  They must differ or dontMapToSelf refuses the mapping.
                s.emit(oid, 1, ['id', 1 if s.asked(v) == 'path this_device' else 9])
            return True
        if t.startswith('live.observer'):
            return True
        if t.startswith('live.object'):
            if inl == 1:
                if not s.isid(v):
                    s.lom_err('live.object set with %r, expected [id, n]' % (v,))
                    return True            # Live would set nothing - so neither do we
                s.st[oid][1] = v
                return True
            if not s.isid(s.st[oid][1]):
                s.lom_err('live.object asked %r before it was set to an id' % (v,))
                return True                # an unset live.object answers nothing
            a = s.asked(v)
            if a == 'getpath':
                s.emit(oid, 0, ['path', 'live_set', 'tracks', 0, 'devices', 0, 'parameters', 3])
            elif a == 'get name':
                s.emit(oid, 0, ['name', 'FakeParam'])
            return True
        return False

    def lom_err(s, msg):
        s.lom_errors.append(msg)

    # ---------------------------------------------------------------- plumbing
    def emit(s, oid, n, v):
        for d, di in s.FAN.get((oid, n), []):
            s.send(d, di, v)

    def inlet(s, idx, v):
        s.send(s.inlets[idx], 0, v)

    def send(s, oid, inl, v):
        b = s.BOX[oid]
        mc = b['maxclass']
        t = b.get('text', '') or ''

        if mc == 'comment':
            return
        if mc == 'outlet':
            s.outs[s.outlets.index(oid)] = v
            return
        if mc == 'inlet':
            s.emit(oid, 0, v)
            return
        if mc == 'message':
            toks = t.strip().split()
            def num(tk):
                try:
                    return float(tk) if ('.' in tk or 'e' in tk) else int(tk)
                except ValueError:
                    return tk
            vals = [num(tk) for tk in toks]
            if len(vals) == 1:
                s.emit(oid, 0, vals[0])    # a number, or a symbol like getpath
            else:
                s.emit(oid, 0, vals)       # a list: "path this_device", a span table
            return

        # ---- Live Object Model: stubbed at the boundary, see the header ------
        if s.lom(oid, inl, v, t):
            return

        hot = 1 if t.startswith('gate') else 0

        if t.startswith('s '):
            for r in s.recv.get(t.split(None, 1)[1], []):
                s.emit(r, 0, v)
            return
        if t.startswith('r '):
            return
        if t == 'deferlow':
            # NO LONGER "the model ignores deferral".  That stated limit was where a real
            # bug lived.  [deferlow] hands the message to Max's MAIN thread, and that is
            # load-bearing: the Live API answers in line on the main thread and defers
            # from the scheduler thread, so only a raise that crosses this boundary can
            # read Live's answers at all.  With a scheduler-thread origin the chain stops
            # here and flush() resumes it on the main thread, which is what Live does.
            if getattr(s, 'defer_api', False) and not getattr(s, 'in_main', False):
                s.deferq.append((oid, 0, v))
            else:
                s.emit(oid, 0, v)
            return
        if re.match(r'^print(\s|$)', t):
            # Captured, not ignored.  A device that reports why it did nothing is only
            # useful if it really reports, so a test can assert on this.
            s.printed.append(s.asked(v))
            return

        if inl != hot:
            s.st[oid][inl] = v
            return

        # [pack] and [line] both take a bang, and a bang is not a value: storing it
        # would turn "1 250" into "bang 250".  Every other object here is fed numbers
        # or lists, so this is the only place it comes up.
        if v != 'bang':
            s.st[oid][inl] = v

        # ---- the objects the cell actually uses -----------------------------
        if t.startswith('unpack'):
            for k in range(b['numoutlets'] - 1, -1, -1):
                s.emit(oid, k, v[k])
        elif re.match(r'^line(\s|$)', t):
            # [line] is the control-rate [line~]: "target time" ramps there and keeps
            # outputting every `grain` ms until it arrives; a bare number jumps.  The
            # envelope rides this, which is why it keeps running when frames stop.
            st = s.lines[oid]
            if isinstance(v, list) and len(v) >= 2:
                st['start'], st['target'] = st['v'], float(v[0])
                st['dur'], st['t0'] = float(v[1]), s.now
                if st['dur'] <= 0:
                    st['v'], st['running'] = st['target'], False
                    s.emit(oid, 0, st['v'])
                else:
                    st['running'] = True
                    st['next'] = s.now + st['grain']
            elif v != 'bang':
                st['v'], st['running'] = float(v[0] if isinstance(v, list) else v), False
                s.emit(oid, 0, st['v'])
        elif t.startswith('pack'):
            s.emit(oid, 0, list(s.st[oid]))
        elif re.match(r'^[fi](\s|$)', t):
            cast = (lambda x: x) if t[0] == 'f' else (lambda x: int(x))
            if v == 'bang':
                s.emit(oid, 0, s.st[oid][1])
            else:
                s.st[oid][1] = cast(v)
                s.emit(oid, 0, cast(v))
        elif t.startswith('zl nth'):
            n = int(s.st[oid][1])
            s.emit(oid, 0, v[n - 1] if 1 <= n <= len(v) else 0.0)
        elif t.startswith('zl len'):
            s.emit(oid, 0, len(v) if isinstance(v, list) else 1)
        elif t.startswith('change'):
            if s.last.get(oid, '\0') != v:
                s.last[oid] = v
                s.emit(oid, 0, v)
        elif t.startswith('sel '):
            args = t.split()[1:]
            for k, a in enumerate(args):
                if float(v) == float(a):
                    s.emit(oid, k, 'bang')
                    return
            s.emit(oid, len(args), v)
        elif t.startswith('=='):
            s.emit(oid, 0, 1 if float(v) == float(t.split()[1]) else 0)
        elif t.startswith('>'):
            s.emit(oid, 0, 1 if float(v) > float(t.split()[1]) else 0)
        elif t.startswith('!='):
            arg = t.split()[1:] 
            rhs = float(arg[0]) if arg else float(s.st[oid][1])
            s.emit(oid, 0, 1 if float(v) != rhs else 0)
        elif t.startswith('uzi'):
            # THE OUTLETS ARE NOT WHAT THIS MODEL USED TO SAY, and the old comment stated
            # the wrong belief outright - the same shape of mistake as the [deferlow] one.
            # uzi's own refpage: outlet 0 "Watch out" (the bang), outlet 1 "Done banging
            # bang (carry)", outlet 2 "Current Index".  And the second argument "sets the
            # base value for the RIGHT OUTLET COUNT. The base value defaults to 1" - which
            # settles both which outlet carries the index and that it is 1-based.
            g = t.split()
            n = int(float(s.st[oid][1]))
            base = int(float(g[2])) if len(g) > 2 else 1
            for k in range(base, base + n):
                s.emit(oid, 2, k)          # the index, out the RIGHT outlet
                s.emit(oid, 0, 'bang')     # then the bang, out the LEFT
            s.emit(oid, 1, 'bang')         # and the carry once, out the MIDDLE
        elif t.startswith('sprintf '):
            fmt = t[len('sprintf '):]
            arg = v
            if '%ld' in fmt or '%d' in fmt:
                try:
                    arg = int(float(v))
                except (TypeError, ValueError):
                    pass
            filled = fmt.replace('%ld', str(arg), 1).replace('%d', str(arg), 1) \
                        .replace('%s', str(arg), 1)
            if '%ld' in filled or '%d' in filled:
                right = s.st[oid][1]
                filled = filled.replace('%ld', str(int(float(right))), 1) \
                               .replace('%d', str(int(float(right))), 1)
            toks = filled.split()
            s.emit(oid, 0, toks if len(toks) > 1 else toks[0])
        elif t.startswith('del '):
            if v == 'stop':
                s.timers.pop(oid, None)
            else:
                s.timers[oid] = s.now + float(t.split()[1])
        elif t.startswith('/ '):
            s.emit(oid, 0, float(v) / float(t.split()[1]))
        elif t.startswith('* '):
            s.emit(oid, 0, float(v) * float(t.split()[1]))
        elif t.startswith('- '):
            s.emit(oid, 0, float(v) - float(t.split()[1]))
        elif t.startswith('&&'):
            s.emit(oid, 0, 1 if (float(v) and float(s.st[oid][1])) else 0)
        elif t.startswith('+ '):
            s.emit(oid, 0, v + float(t.split()[1]))
        elif t.startswith('gate'):
            # [gate] starts CLOSED; [gate 1 1] starts OPEN - the second argument is the
            # initially open outlet.  CLAUDE.md records this from [p mb_osc_in].
            if s.st[oid][0]:
                s.emit(oid, 0, v)
        elif t.startswith('t '):
            o = t.split()[1:]
            for k in range(len(o) - 1, -1, -1):
                a = o[k]
                if a == 'b':
                    s.emit(oid, k, 'bang')
                elif a in ('i', 'f') and v != 'bang':
                    # [t i] CASTS, and on a list it takes the FIRST element - which is
                    # the whole of the mb_body mock-slider trap in CLAUDE.md.  The model
                    # used to pass the value through untouched, so "1" and "1." were the
                    # same thing to it and an int outlet could emit a float.
                    x = v[0] if isinstance(v, list) and v else v
                    try:
                        s.emit(oid, k, int(x) if a == 'i' else float(x))
                    except (TypeError, ValueError):
                        s.emit(oid, k, x)
                elif a in ('l', 'i', 'f', 's', 'a'):
                    s.emit(oid, k, v)
                else:
                    s.emit(oid, k, a)      # a literal argument: [t l getpath l b]
        elif t.startswith('prepend '):
            # The argument goes in as separate atoms, not as one multi-word symbol:
            # [prepend path live_set scenes] + 3 is the message "path live_set scenes 3".
            # That is the idiom six shipped Ableton devices use to build a LOM path.
            arg = t.split(None, 1)[1].split()
            s.emit(oid, 0, arg + (list(v) if isinstance(v, list) else [v]))
        elif t.startswith('append '):
            arg = t.split(None, 1)[1]
            s.emit(oid, 0, (list(v) if isinstance(v, list) else [v]) + [arg])
        elif t.startswith('route '):
            arg = t.split(None, 1)[1]
            if isinstance(v, list) and v and str(v[0]) == arg:
                rest = v[1:]
                s.emit(oid, 0, rest[0] if len(rest) == 1 else rest)
            else:
                s.emit(oid, 1, v)
        elif t.startswith('expr '):
            # $i is an INT variable in Max and $f a float, and the difference is not
            # cosmetic: an $i expression returns an int, which is what [sprintf %ld]
            # needs downstream.  The model used to cast every variable to float, so
            # "fired 1" came out as "fired 1." and the scene readout would have shown
            # a decimal point in Live.
            def sub(m):
                raw = s.st[oid][int(m.group(2)) - 1]
                if m.group(1) == 'i':
                    try:
                        return '(%d)' % int(float(raw))
                    except (TypeError, ValueError):
                        return '(0)'
                return '(%r)' % float(raw)
            e = re.sub(r'\$([fis])(\d+)', sub, t[5:])
            s.emit(oid, 0, eval(e, {'sqrt': math.sqrt, 'abs': abs, '__builtins__': {}}))
        elif t.startswith('clip '):
            lo, hi = [float(x) for x in t.split()[1:3]]
            s.emit(oid, 0, max(lo, min(hi, v)))
        elif t.startswith('line~'):
            s.emit(oid, 0, v[0] if isinstance(v, list) else v)


# --------------------------------------------------------------------- helpers

IN_SRC, IN_ACT, IN_MAP, IN_MODE, IN_SEL, IN_FROM, IN_TO, IN_PATH, IN_CLEAR, \
    IN_ATTACK = range(10)
FADER, SWITCH = 0, 1

# The replayed cell is a LEFT-side one, so its X span runs from the zone edge outwards.
# Both numbers come from zone_constants.py - the same file build_cells.py baked them from.
ZLO, ZHI = Z.SPANS['LEFT'][0]
FRAME_MS = 33.0                   # one camera frame at ~30 Hz


def new(mode=FADER, sel=0, frm=0.0, to=100.0, mapped=True, attack=Z.ATTACK_MS):
    c = Cell(CELL)
    c.inlet(IN_MODE, mode)
    c.inlet(IN_SEL, sel)
    c.inlet(IN_FROM, frm)
    c.inlet(IN_TO, to)
    c.inlet(IN_ATTACK, attack)
    if mapped:
        c.inlet(IN_MAP, 1)
        c.inlet(IN_PATH, ['live_set', 'tracks', 0, 'devices', 0, 'parameters', 3])
    c.remote.clear()
    return c


def frame(c, x=0.0, y=0.0, z=0.0, spread=0.0, valid=1, active=None, dt=FRAME_MS):
    """One camera frame, in the order the panel delivers it: flag first, then the list.

    Then the clock moves on by one frame, because the envelope rides [line]'s own clock
    and a frame that took no time would never let it advance."""
    if active is not None:
        c.inlet(IN_ACT, active)
    c.inlet(IN_SRC, [x, y, z, spread, float(valid)])
    c.advance(dt)


def settle(c):
    """Run the clock past the end of any attack, without delivering a frame.  The
    envelope is on its own clock, so the cell arrives at its target either way - which
    is the property that makes the attack usable in MOCK, where frames stop with the mouse."""
    c.advance(Z.ATTACK_MS * 2 + 100.0)


PASS = []


def check(name, cond, detail=''):
    PASS.append(bool(cond))
    print('  %-58s %s   %s' % (name, 'PASS' if cond else 'FAIL', detail))


print('=' * 74)
print('  verify_cells.py - replaying the real [p mb_cell] graph')
print('  LEFT span %+.2f .. %+.2f body lengths   ATTACK %g ms' % (ZLO, ZHI, Z.ATTACK_MS))
print('=' * 74)

# TEST 1 -------------------------------------------------------------------
print('\nTEST 1  entering the zone puts the knob at FROM, full extension at TO')
# Each position is read AFTER the attack has run out.  Before the attack ran out the
# answer would be "somewhere on the way", which is the whole point of the envelope and
# is tested on its own further down.
c = new(FADER, frm=0.0, to=100.0)
got = []
for x in (ZLO, (ZLO + ZHI) / 2, ZHI):
    frame(c, x=x, active=1)
    settle(c)
    got.append(round(c.remote[-1], 3))
check('zone edge / halfway / full reach -> 0 / 0.5 / 1', got == [0.0, 0.5, 1.0], str(got))

# TEST 2 -------------------------------------------------------------------
print('\nTEST 2  FROM and TO bound how far the knob may travel')
c = new(FADER, frm=20.0, to=60.0)
got = []
for x in (ZLO, (ZLO + ZHI) / 2, ZHI):
    frame(c, x=x, active=1)
    settle(c)
    got.append(round(c.remote[-1], 3))
check('20%..60% -> the knob stays inside that band', got == [0.2, 0.4, 0.6], str(got))
c = new(FADER, frm=100.0, to=0.0)
inv = []
for x in (ZLO, ZHI):
    frame(c, x=x, active=1)
    settle(c)
    inv.append(round(c.remote[-1], 3))
check('FROM above TO simply inverts the direction', inv == [1.0, 0.0], str(inv))

# TEST 3 -------------------------------------------------------------------
print('\nTEST 3  reaching past the span cannot push the knob outside FROM..TO')
# Measured from the first arrival onwards.  Before that the cell is gliding away from
# wherever live.remote~ was already holding the parameter - 0 on a fresh load, which is
# below FROM and is the parameter's own starting point, not somewhere the cell drove it.
# That one case has its own test below.
c = new(FADER, frm=10.0, to=70.0)
frame(c, x=ZLO, active=1)
settle(c)
n0 = len(c.remote)
frame(c, x=-3.0)                     # further than any arm reaches
settle(c)
frame(c, x=0.0)                      # and back past the zone edge
settle(c)
vals = [round(v, 3) for v in c.remote[n0:]]
check('every value stays within 0.10..0.70',
      all(0.10 - 1e-9 <= v <= 0.70 + 1e-9 for v in vals), str(vals[:6]) + ' ...')

# TEST 4 -------------------------------------------------------------------
print('\nTEST 4  a FADER holds its value when the hand leaves the zone')
# Since the envelope the cell keeps SENDING while the hand is outside - [line] runs for
# ATTACK ms after every transition, and the frame still bangs the blend.  What it may
# never do is CHANGE: leaving sets held and target to the same value, so the crossfade
# has nothing to cross and the output is flat.  The old test asserted "nothing is sent",
# which was a fact about the old implementation rather than the behaviour that matters.
c = new(FADER)
frame(c, x=ZHI, active=1)
settle(c)
held = c.remote[-1]
n0 = len(c.remote)                   # everything from here on is "while outside"
frame(c, x=-0.9, active=0)
for x in (-0.5, 0.0, 0.3):
    frame(c, x=x)
settle(c)
after = c.remote[-1]
moved = max(abs(v - held) for v in c.remote[n0:])
check('the value never moves while the hand is outside', moved < 1e-9,
      'drifted by %.2e' % moved)
check('and it is the value that was held', abs(after - 1.0) < 1e-6, str(round(after, 3)))

# TEST 5 -------------------------------------------------------------------
print('\nTEST 5  and it follows the hand again the moment it returns')
# There is no pickup: the knob tracks the hand on every entry.  What the attack changes
# is that it ARRIVES rather than jumps - verified on its own in TEST 16.
n0 = len(c.remote)
frame(c, x=ZLO, active=1)
settle(c)
a = round(c.remote[-1], 3)
frame(c, x=ZHI)
settle(c)
b = round(c.remote[-1], 3)
check('re-entry tracks the hand again', [a, b] == [0.0, 1.0], str([a, b]))

# TEST 6 -------------------------------------------------------------------
print('\nTEST 6  SWITCH is TO in the zone and FROM on leaving')
c = new(SWITCH, frm=15.0, to=85.0)
frame(c, x=0.0, active=1)
settle(c)
on = round(c.remote[-1], 3)
frame(c, x=0.0, active=0)
settle(c)
off = round(c.remote[-1], 3)
check('in the zone = TO, out of the zone = FROM', on == 0.85 and off == 0.15,
      'on=%s off=%s' % (on, off))

# TEST 7 -------------------------------------------------------------------
print('\nTEST 7  the source menu picks the right axis, with that axis\'s own span')
for sel, nm in enumerate(Z.AXES):
    lo, hi = Z.SPANS['LEFT'][sel]
    c = new(FADER, sel=sel)
    kw = dict(x=0.0, y=0.0, z=0.0, spread=0.0)
    kw[['x', 'y', 'z', 'spread'][sel]] = hi
    frame(c, active=1, **kw)
    settle(c)
    check('source %-6s at the top of its span (%+.2f) -> 1.0' % (nm, hi),
          abs(c.remote[-1] - 1.0) < 1e-6, str(round(c.remote[-1], 3)))

# TEST 8 -------------------------------------------------------------------
print('\nTEST 8  loss of tracking: switches release, faders freeze')
# mb_zones drops every flag when the body is lost (its own TEST 8), so the cell
# sees active go to 0.  That is what releases a switch and freezes a fader.
c = new(SWITCH, frm=0.0, to=100.0)
frame(c, x=0.0, active=1)
settle(c)
frame(c, x=0.0, valid=0, active=0)
settle(c)
check('SWITCH released on loss of tracking', c.remote[-1] == 0.0, str(c.remote[-1]))
c = new(FADER)
frame(c, x=ZHI, active=1)
settle(c)
held = c.remote[-1]
n0 = len(c.remote)
frame(c, x=0.0, valid=0, active=0)
for _ in range(5):
    frame(c, x=0.0, valid=0)
settle(c)
moved = max(abs(v - held) for v in c.remote[n0:])
check('FADER frozen on loss of tracking', moved < 1e-9, 'drifted by %.2e' % moved)

# TEST 9 -------------------------------------------------------------------
print('\nTEST 9  MAP acquires, names and reports a path for persistence')
# Live pushes a selected parameter out of live.path's id outlet on its own; nothing
# is sent INTO that object.  So the harness plays Live's part and fires that outlet.
c = Cell(CELL)
c.inlet(IN_MODE, FADER)
c.inlet(IN_MAP, 1)
sel_box = [i for i, b in c.BOX.items()
           if str(b.get('text', '')).startswith('live.path live_set view selected_parameter')]
assert len(sel_box) == 1, sel_box
c.emit(sel_box[0], 1, ['id', 9])
check('the mapped parameter name is reported', c.outs.get(0) == 'FakeParam', repr(c.outs.get(0)))
check('a path is reported for the blob pattr to persist',
      isinstance(c.outs.get(1), list) and 'live_set' in [str(x) for x in c.outs[1]],
      repr(c.outs.get(1)))
check('the MAP button is released once mapping succeeds', 2 in c.outs, repr(c.outs.get(2)))

# TEST 10 ------------------------------------------------------------------
print('\nTEST 10  dontMapToSelf refuses a parameter on this same device')
c = Cell(CELL)
orig_send = c.send
def same_device(oid, inl, v, _o=orig_send):
    if str(c.BOX[oid].get('text', '')).startswith('live.path') and inl == 0:
        c.emit(oid, 1, ['id', 1])          # everything is device 1
        return
    return _o(oid, inl, v)
c.send = same_device
c.inlet(IN_MODE, FADER)
c.inlet(IN_MAP, 1)
sel_box = [i for i, b in c.BOX.items()
           if str(b.get('text', '')).startswith('live.path live_set view selected_parameter')]
c.emit(sel_box[0], 1, ['id', 1])
check('a control on this device is not accepted as a target',
      c.outs.get(1) is None, repr(c.outs.get(1)))

# TEST 11 ------------------------------------------------------------------
print('\nTEST 11  a restored mapping binds the same way a fresh one does')
c = Cell(CELL)
c.inlet(IN_MODE, FADER)
c.inlet(IN_PATH, ['live_set', 'tracks', 0, 'devices', 0, 'parameters', 3])
bind = [v for v in c.remote if isinstance(v, list)]
check('live.remote~ is bound with a single id, not a doubled one',
      bind and bind[0][0] == 'id' and len(bind[0]) == 2, repr(bind[:1]))
c2 = Cell(CELL)
c2.inlet(IN_MODE, FADER)
c2.inlet(IN_PATH, [])
check('a device that was never mapped stays unbound',
      not [v for v in c2.remote if isinstance(v, list)], repr(c2.remote))

# TEST 12 ------------------------------------------------------------------
print('\nTEST 12  every cell\'s baked span lies inside the zone that switches it on')
# The failure this prevents: a span the zone can never reach normalises to a constant,
# the knob is pinned, and nothing on screen says why.  It cost two rounds in Live.
#
# Checked on ALL FOUR axes since 2026-10-06, not just the default one.  Three of the
# four side spans were ABOVE's figures, and nothing caught it because nothing looked:
# a side cell set to Y asked for 1.60..2.40 body lengths, which is above the head and so
# outside the very zone that switches the cell on.  Picking Y on a side cell pinned the
# knob, lftB and rgtB default to SPREAD and asked for two arms opened wide inside one
# side zone, and the old TEST 12 passed all of it.
PANEL = find(doc['patcher'], 'p mb_zone_panel')
HEAD_Y = 1.44                       # the replayed body: head 0.72 m over a 0.50 m spine
ABOVE_FLOOR = HEAD_Y + Z.ABOVE_ENTER
SIDE_CEIL = HEAD_Y + Z.ABOVE_ENTER  # past this a side hand is in ABOVE instead
cells = [b['box'] for b in PANEL['boxes'] if b['box'].get('text') == 'p mb_cell']
lamps = sorted(b['box']['varname'][:-5] for b in PANEL['boxes']
               if str(b['box'].get('varname', '')).endswith('_lamp'))
if not cells:
    check('at least one cell is built', False, 'none found')
for key, cb in zip(lamps, cells):
    msgs = [str(x['box'].get('text', '')) for x in cb['patcher']['boxes']
            if x['box'].get('maxclass') == 'message']
    tables = [m for m in msgs if len(m.split()) == 4 and
              all(t.replace('-', '').replace('.', '').isdigit() for t in m.split())]
    if len(tables) != 2:
        check('%s declares a span table' % key, False, repr(tables))
        continue
    lo = [float(t) for t in tables[0].split()]
    hi = [float(t) for t in tables[1].split()]
    zone = key[:3]

    bad = []
    for a, nm in enumerate(Z.AXES):
        if lo[a] == hi[a]:
            bad.append('%s span is zero-width' % nm)
    if zone in ('lft', 'rgt'):
        sgn = -1.0 if zone == 'lft' else 1.0
        # X: the whole span past the entry threshold, and starting EXACTLY on it, so the
        # knob sits at FROM at the instant the zone switches on rather than a step away.
        if min(lo[0] * sgn, hi[0] * sgn) < Z.SIDE_ENTER:
            bad.append('X span reaches inside the %g threshold' % Z.SIDE_ENTER)
        if abs(abs(lo[0]) - Z.SIDE_ENTER) > 1e-9:
            bad.append('X span does not START at the threshold (%g)' % lo[0])
        # Y: a hand above the head is in ABOVE, so a side span may not go up there.
        if max(lo[1], hi[1]) > SIDE_CEIL:
            bad.append('Y span reaches above the head, where the zone is ABOVE')
    else:
        if min(lo[1], hi[1]) < ABOVE_FLOOR:
            bad.append('Y span reaches below head+%g' % Z.ABOVE_ENTER)
    check('%s  X %+.2f..%+.2f  Y %+.2f..%+.2f  Z %+.2f..%+.2f  SPR %.2f..%.2f'
          % (key, lo[0], hi[0], lo[1], hi[1], lo[2], hi[2], lo[3], hi[3]),
          not bad, '; '.join(bad))

# TEST 13 ------------------------------------------------------------------
print('\nTEST 13  the Live objects are addressed the way Live actually requires')
c = Cell(CELL)
c.inlet(IN_MODE, FADER)
c.inlet(IN_MAP, 1)
sel_box = [i for i, b in c.BOX.items()
           if str(b.get('text', '')).startswith('live.path live_set view selected_parameter')]
c.emit(sel_box[0], 1, ['id', 9])
check('nothing was handed a bare number instead of an id message',
      not c.lom_errors, '; '.join(c.lom_errors[:2]))
c2 = Cell(CELL)
c2.inlet(IN_MODE, FADER)
c2.inlet(IN_PATH, ['live_set', 'tracks', 0, 'devices', 0, 'parameters', 3])
check('the restore path addresses them the same way', not c2.lom_errors, '; '.join(c2.lom_errors[:2]))

# TEST 14 ------------------------------------------------------------------
print('\nTEST 14  CLEAR releases the parameter and forgets the path')
# A stored path is POSITIONAL - "live_set tracks 0 devices 0 parameters 3".  Deleting
# the effect does not invalidate it; it just resolves to whatever now sits there.  So
# there has to be a way to drop a mapping outright.
c = Cell(CELL)
c.inlet(IN_MODE, FADER)
c.inlet(IN_MAP, 1)
sel_box = [i for i, b in c.BOX.items()
           if str(b.get('text', '')).startswith('live.path live_set view selected_parameter')]
c.emit(sel_box[0], 1, ['id', 9])
check('a parameter is mapped to begin with', c.outs.get(0) == 'FakeParam', repr(c.outs.get(0)))
c.remote.clear()
c.inlet(IN_CLEAR, 1)
check('live.remote~ is released with id 0',
      ['id', 0] in [v for v in c.remote if isinstance(v, list)], repr(c.remote))
check('the stored path is replaced by the cleared sentinel', c.outs.get(1) == 0,
      repr(c.outs.get(1)))
check('the name display is blanked', c.outs.get(0) == '-', repr(c.outs.get(0)))

# TEST 15 ------------------------------------------------------------------
print('\nTEST 15  a stored path that no longer resolves is not bound')
c = Cell(CELL)
orig = c.send
def dead_path(oid, inl, v, _o=orig):
    if str(c.BOX[oid].get('text', '')) == 'live.path' and inl == 0:
        c.emit(oid, 1, ['id', 0])          # Live: "that path resolves to nothing"
        return
    return _o(oid, inl, v)
c.send = dead_path
c.inlet(IN_MODE, FADER)
c.inlet(IN_PATH, ['live_set', 'tracks', 9, 'devices', 9, 'parameters', 9])
check('nothing is bound when the path is dead',
      not [v for v in c.remote if isinstance(v, list)], repr(c.remote))
check('and the cleared sentinel is not mistaken for a path', True, '')
c2 = Cell(CELL)
c2.inlet(IN_MODE, FADER)
c2.inlet(IN_PATH, 0)                       # what CLEAR leaves behind
check('a cleared cell restores as unmapped',
      not [v for v in c2.remote if isinstance(v, list)], repr(c2.remote))

# ==========================================================================
#  THE ATTACK ENVELOPE - added 2026-10-06
# ==========================================================================
# Four properties, and the fourth is the one that let the side commit delay come down
# from 200 ms to 60 ms: entering softly means a cell that flashes briefly no longer
# throws its knob across the room.

# TEST 16 ------------------------------------------------------------------
print('\nTEST 16  entering a zone glides instead of stepping')
# The worst case on purpose: a cell holding 1.0 re-enters where the movement says 0.0,
# so an unsoftened entry would be a full-range step in one frame.
c = new(FADER, frm=0.0, to=100.0)
frame(c, x=ZHI, active=1)
settle(c)
frame(c, x=ZHI, active=0)
settle(c)
n0 = len(c.remote)
frame(c, x=ZLO, active=1)
first = c.remote[n0]
traj = [c.remote[-1]]
for _ in range(11):                  # ~400 ms, comfortably past a 250 ms attack
    frame(c, x=ZLO)
    traj.append(c.remote[-1])
check('the first frame in the zone does not step the knob', abs(first - 1.0) < 0.02,
      'moved %.3f on arrival' % abs(first - 1.0))
check('and it only moves one way', all(b <= a + 1e-9 for a, b in zip(traj, traj[1:])),
      '%s ...' % [round(v, 2) for v in traj[:5]])
check('halfway through the attack it is still on its way',
      0.15 < traj[int(Z.ATTACK_MS / 2 / FRAME_MS)] < 0.95,
      'at %g ms: %.2f' % (Z.ATTACK_MS / 2, traj[int(Z.ATTACK_MS / 2 / FRAME_MS)]))
check('and it arrives', abs(traj[-1]) < 1e-6, str(round(traj[-1], 4)))

# TEST 17 ------------------------------------------------------------------
print('\nTEST 17  ATTACK 0 is the old instant entry, exactly')
# A feel control that cannot be switched off is a trap: there has to be a way back to
# the behaviour that was verified before it existed.
c = new(FADER, frm=0.0, to=100.0, attack=0.0)
frame(c, x=ZHI, active=1)
check('one frame reaches the target with no glide', abs(c.remote[-1] - 1.0) < 1e-9,
      str(round(c.remote[-1], 6)))

# TEST 18 ------------------------------------------------------------------
print('\nTEST 18  the envelope is a crossfade, so it cannot overshoot either end')
# out = held + env * (target - held) with env in 0..1 is a value BETWEEN two values that
# are themselves inside FROM..TO.  No clip needed, and none to forget.
c = new(FADER, frm=20.0, to=80.0)
frame(c, x=ZHI, active=1)
settle(c)
frame(c, x=ZHI, active=0)
settle(c)
n0 = len(c.remote)
frame(c, x=ZLO, active=1)
for _ in range(14):
    frame(c, x=ZLO)
vals = c.remote[n0:]
check('every value on the way stays within 0.20..0.80',
      all(0.20 - 1e-9 <= v <= 0.80 + 1e-9 for v in vals),
      'range %.3f..%.3f over %d values' % (min(vals), max(vals), len(vals)))

# TEST 19 ------------------------------------------------------------------
print('\nTEST 19  a two-frame flash no longer throws the knob - why COMMIT_SIDE is %d ms'
      % Z.COMMIT_SIDE)
# mb_zones commits a side zone in 60 ms now.  The cost is that a two-hand entry whose
# hands are more than 60 ms apart lets the one-hand cell go live for that long, and a
# FADER holds whatever it reached.  This measures the damage, against the same flash with
# the envelope switched off - no invented threshold, just the two side by side.
def flash(attack):
    c = new(FADER, frm=0.0, to=100.0, attack=attack)
    frame(c, x=ZHI, active=1)
    settle(c)
    frame(c, x=ZHI, active=0)
    settle(c)
    frame(c, x=ZLO, active=1)        # the flash: two frames, then gone
    frame(c, x=ZLO)
    frame(c, x=ZLO, active=0)
    settle(c)
    return abs(c.remote[-1] - 1.0)

slip_off, slip_on = flash(0.0), flash(Z.ATTACK_MS)
check('with no envelope the flash moves the knob the whole way', slip_off > 0.99,
      'slipped %.0f%%' % (slip_off * 100))
check('with the %g ms attack it barely moves' % Z.ATTACK_MS, slip_on < 0.25,
      'slipped %.0f%% instead of %.0f%%' % (slip_on * 100, slip_off * 100))

# TEST 20 ------------------------------------------------------------------
print('\nTEST 20  a SWITCH releases on the same curve it arrived on')
# The same envelope, in the other direction.  Mapped to a Dry/Wet - which ZONES.md says
# to prefer over a device on/off - a stepped release is a click.
c = new(SWITCH, frm=20.0, to=80.0)
frame(c, x=0.0, active=1)
settle(c)
check('in the zone it has arrived at TO', abs(c.remote[-1] - 0.80) < 1e-9,
      str(round(c.remote[-1], 3)))
n0 = len(c.remote)
frame(c, x=0.0, active=0)
first = c.remote[n0]
rel = [c.remote[-1]]
for _ in range(11):
    frame(c, x=0.0)
    rel.append(c.remote[-1])
check('leaving does not step it either', abs(first - 0.80) < 0.02,
      'moved %.3f on release' % abs(first - 0.80))
check('it glides down to FROM', abs(rel[-1] - 0.20) < 1e-6
      and all(b <= a + 1e-9 for a, b in zip(rel, rel[1:])),
      '%s ...' % [round(v, 2) for v in rel[:5]])

# ====================================================================== stepper
STEPPER = find(doc['patcher'], 'p mb_stepper')


class Song(Cell):
    """A replay of [p mb_stepper] against a stubbed Live Set.

    `empties` is the Session View: one flag per scene, True where the scene is empty.
    Live always leaves trailing empty scenes below the ones you filled, which is the
    whole reason the stepper can discover the length of the piece by itself.
    """

    SONG_ID = 1
    SCENE_BASE = 100

    def __init__(s, patcher, empties):
        s.empties = list(empties)
        s.fired = []                       # scene indices Live was told to fire
        s.observing = None                 # which scene the observer is watching
        s.trig = 0                         # is_triggered of the observed scene
        s.pathid = {}                      # live.path object -> the id it currently holds
        s.instant_start = False            # Live reports the scene started DURING the fire
        # LIVE DEFERS EVERY API REPLY, and this stub used to answer in line.  Max's own
        # refpages, for live.path and live.object alike: "The Live API runs in the main
        # thread in Live, and all messages to and from the API are automatically
        # deferred."  A raise arrives in the SCHEDULER thread - [udpreceive] for a real
        # body, [metro 33] for the mock - so with defer_api set, nothing Live says comes
        # back inside the event that asked.  flush() is Live's main thread catching up.
        s.defer_api = False                # True = this raise came from the scheduler
        s.in_main = False                  # True once [deferlow] has handed it over
        s.apiq = []
        s.deferq = []
        super().__init__(patcher)
        # live.thisdevice fires once Live has finished loading the device.  Nothing in
        # the stepper resolves the song before that, so the harness has to play it.
        for i, b in s.BOX.items():
            if str(b.get('text', '')).startswith('live.thisdevice'):
                s.emit(i, 0, 'bang')

    def lom(s, oid, inl, v, t):
        if t.startswith('live.thisdevice'):
            return True
        if t.startswith('live.path'):
            # STRICT, and faithful to the refpage, because the lenient version of this
            # stub certified a stepper that could not advance a scene in Live:
            #
            #   OUTLET 0  answers a goto / path / bang / getid - EVERY time.
            #   OUTLET 1  sends id nn only WHEN THE ID CHANGES.  Asking for the same path
            #             twice gets one answer, not two.  A request-response pattern that
            #             reads outlet 1 therefore works until it asks twice in a row.
            #   OUTLET 2  answers getpath, getchildren and getcount - nothing else does.
            #
            # Max fires outlets right to left, so the higher ones go first.
            if inl == 0:
                a = s.asked(v)
                if a.startswith('path ') or a.startswith('goto '):
                    tgt = a.split(None, 1)[1]
                    if tgt == 'live_set':
                        new_id = s.SONG_ID
                    elif tgt.startswith('live_set scenes '):
                        n = int(tgt.rsplit(' ', 1)[1])
                        new_id = s.SCENE_BASE + n if 0 <= n < len(s.empties) else 0
                        if new_id == 0:
                            s.lom_err('asked for scene %d of %d' % (n, len(s.empties)))
                    else:
                        s.lom_err('live.path asked %r' % (a,))
                        return True
                    prev = s.pathid.get(oid)
                    s.pathid[oid] = new_id
                    if prev != new_id:
                        s.api_emit(oid, 1, ['id', new_id])
                    s.api_emit(oid, 0, ['id', new_id])
                elif a.startswith('getcount '):
                    child = a.split(None, 1)[1]
                    if s.pathid.get(oid) != s.SONG_ID:
                        s.lom_err('getcount %s asked of a live.path at %r, not the song'
                                  % (child, s.pathid.get(oid)))
                    elif child != 'scenes':
                        s.lom_err('getcount asked for %r' % (child,))
                    else:
                        s.api_emit(oid, 2, ['count', child, len(s.empties)])
                else:
                    s.lom_err('live.path asked %r' % (a,))
            return True
        if t.startswith('live.observer'):
            if inl == 1:
                if not s.isid(v):
                    s.lom_err('live.observer set with %r' % (v,))
                else:
                    s.observing = v[1] - s.SCENE_BASE
                    s.st[oid][1] = v
                return True
            # THE STUB USED TO BE SILENT HERE, and that hid the whole lockout fault.
            # live.observer's refpage, on the `property` message: "Selects the property
            # to be observed.  Outputs the current value to the left outlet if a proper
            # Live object is set."  And on `bang`: "Sends current value of selected
            # property of current object to the left outlet."  So BOTH answer, with the
            # bare value - "Example: left / value / Drums", no property-name prefix.
            # The arming answer is the one the lockout relies on being dropped by its
            # still-shut gate, so a stub that never sent it could not test that at all.
            a = s.asked(v)
            if v == 'bang' or a.startswith('property '):
                if a.startswith('property ') and a.split(None, 1)[1] != 'is_triggered':
                    s.lom_err('live.observer asked to watch %r' % (a,))
                elif s.observing is None:
                    pass                   # no object set: Live answers nothing
                else:
                    s.api_emit(oid, 0, s.trig)
                return True
            s.lom_err('live.observer asked %r' % (a,))
            return True
        if t.startswith('live.object'):
            if inl == 1:
                if not s.isid(v):
                    s.lom_err('live.object set with %r' % (v,))
                    return True
                s.st[oid][1] = v
                return True
            if not s.isid(s.st[oid][1]):
                s.lom_err('live.object asked %r before it was set' % (v,))
                return True
            oid_val = s.st[oid][1][1]
            a = s.asked(v)
            if a.startswith('getcount'):
                # THE BUG THIS STUB USED TO HIDE.  live.object has no getcount - it is a
                # live.path method whose reply leaves live.path's RIGHT outlet as
                # "count <child> <n>".  Live answers nothing here, so neither do we.
                s.lom_err('live.object was asked %r; getcount is a live.path method and '
                          'live.object answers nothing' % (a,))
            elif a == 'get is_empty':
                n = oid_val - s.SCENE_BASE
                s.api_emit(oid, 0, ['is_empty', 1 if s.empties[n] else 0])
            elif a == 'call fire':
                s.fired.append(oid_val - s.SCENE_BASE)
                if s.instant_start:
                    # Global Quantization None, or a raise that lands exactly on the
                    # downbeat: Live queues AND starts the scene inside the fire call, so
                    # both observer reports arrive before `call fire` has returned.  The
                    # lock has to already be set, or both are dropped and the stepper
                    # stays locked until the 8 s failsafe.
                    s.scene_starts()
            else:
                s.lom_err('live.object asked %r' % (a,))
            return True
        return False

    # --- the things Live does back -----------------------------------------
    def api_emit(s, oid, n, v):
        """An answer FROM Live.  Queued when the API is deferred, in line when not."""
        if s.defer_api and not s.in_main:
            s.apiq.append((oid, n, v))
        else:
            s.emit(oid, n, v)

    def flush(s):
        """Max's main thread catches up: the deferred raise first, then Live's answers."""
        guard = 0
        while s.deferq or s.apiq:
            if s.deferq:
                oid, n, v = s.deferq.pop(0)
                prev, s.in_main = s.in_main, True
                s.emit(oid, n, v)          # on the main thread the API answers in line
                s.in_main = prev
            else:
                oid, n, v = s.apiq.pop(0)
                s.emit(oid, n, v)
            guard += 1
            if guard > 10000:
                raise RuntimeError('the deferred queue will not drain')
        return guard

    def raise_hands(s, armed=1):
        """A two-hand raise: the flag goes 0 -> 1 with the fire gate armed."""
        s.inlet(1, armed)
        s.inlet(0, 0)
        s.inlet(0, 1)

    def obs_box(s):
        return [i for i, b in s.BOX.items()
                if str(b.get('text', '')).startswith('live.observer')][0]

    def scene_starts(s):
        """Live reports is_triggered 1 (queued) then 0 (actually playing)."""
        o = s.obs_box()
        s.trig = 1
        s.emit(o, 0, 1)
        s.trig = 0
        s.emit(o, 0, 0)

    def scene_starts_without_blinking(s):
        """The transport was stopped, or quantization is None: the scene starts at once.

        is_triggered was 0 before the fire and is 0 after, so it never CHANGES and Live
        sends no notification whatsoever.  Nothing to emit - that is the entire point.
        """
        s.trig = 0


def newsong(empties):
    c = Song(STEPPER, empties)
    return c


# A piece of four sections, with Live's usual trailing empties below them.
PIECE = [False, False, False, False, True, True, True, True]

print('\nTEST 21  the stepper discovers the length of the piece by itself')
if STEPPER is None:
    check('mb_stepper exists', False, 'not built')
else:
    c = newsong(PIECE)
    c.raise_hands()
    check('the first raise fires scene 0', c.fired == [0], str(c.fired))
    check('and the readout shows it 1-based', c.outs.get(0) == 1, repr(c.outs.get(0)))
    check('the scene count came from Live, not from a constant',
          c.outs.get(1) == len(PIECE), repr(c.outs.get(1)))

    print('\nTEST 22  it advances one section per raise, and skips the empty ones')
    c = newsong(PIECE)
    for _ in range(6):
        c.raise_hands()
        c.scene_starts()
    check('four filled scenes, then it wraps to the first',
          c.fired == [0, 1, 2, 3, 0, 1], str(c.fired))

    print('\nTEST 23  empty scenes in the MIDDLE are skipped too')
    c = newsong([False, True, False, True, True])
    for _ in range(4):
        c.raise_hands()
        c.scene_starts()
    check('scene 1 and 3 are never fired', c.fired == [0, 2, 0, 2], str(c.fired))

    print('\nTEST 24  the lockout: no advance until Live says the scene started')
    c = newsong(PIECE)
    c.raise_hands()
    check('locked immediately after firing', c.outs.get(2) == 1, repr(c.outs.get(2)))
    for _ in range(5):
        c.raise_hands()
    check('five more raises while locked do nothing', c.fired == [0], str(c.fired))
    c.scene_starts()
    check('Live reporting the scene started unlocks it', c.outs.get(2) == 0,
          repr(c.outs.get(2)))
    c.raise_hands()
    check('and the next raise advances', c.fired == [0, 1], str(c.fired))

    print('\nTEST 25  FIRE stays blocked while mb_zones has not re-armed it')
    # mb_zones holds this low for 1000 ms after tracking returns, so walking back into
    # frame through a side zone cannot advance the song.
    c = newsong(PIECE)
    c.raise_hands(armed=0)
    check('a raise with the fire gate closed fires nothing', c.fired == [], str(c.fired))
    c.raise_hands(armed=1)
    check('and it works once mb_zones re-arms', c.fired == [0], str(c.fired))

    print('\nTEST 26  the failsafe releases a lock even Live and the re-read cannot')
    # Narrower than it used to be, and that is the point.  This test used to cover "Live
    # never reports", which is now the COMMON case and is handled by the 120 ms re-read -
    # so if the failsafe still ran it, the guard would be a timer in normal use.  What is
    # left for the failsafe is the genuinely stuck case: the scene is queued when the
    # re-read asks, so the lockout rightly stands, and then Live goes silent for ever
    # because the scene was deleted or the transport stopped while it was blinking.
    c = newsong(PIECE)
    c.raise_hands()
    c.trig = 1                             # queued when the re-read asks, so it stays
    c.advance(4000)
    check('still locked after 4 s', c.outs.get(2) == 1, repr(c.outs.get(2)))
    check('and the re-read did ask', 'is_triggered 1' in c.printed, str(c.printed))
    c.advance(5000)
    check('released after the failsafe expires', c.outs.get(2) == 0, repr(c.outs.get(2)))
    check('and it SAYS the failsafe did it, not Live',
          any('FAILSAFE' in p for p in c.printed), str(c.printed))

    print('\nTEST 27  nothing positional is baked in, and the LOM is addressed properly')
    c = newsong([False] * 3)
    for _ in range(3):
        c.raise_hands()
        c.scene_starts()
    check('a three-scene Set wraps after three', c.fired == [0, 1, 2], str(c.fired))
    check('no LOM object was mis-addressed', not c.lom_errors, '; '.join(c.lom_errors[:2]))
    c = newsong([True] * 4)
    c.raise_hands()
    check('a Set with no playable scene fires nothing', c.fired == [], str(c.fired))

    # TEST 28 --------------------------------------------------------------
    print('\nTEST 28  the regression itself: three scenes, raise six times, advance six times')
    # Reported from Live on 2026-10-06: "with three scenes, every raise jumps to the first
    # scene and it never moves forward."  The cause was asking live.object for getcount -
    # a live.path method - so the count stayed 0, every candidate came out
    # (k + current) % 0 = 0, and Max returns 0 for a modulo by zero rather than erroring.
    # Three green ticks covered it because the stub answered getcount on the wrong object.
    c = newsong([False] * 3)
    for _ in range(6):
        c.raise_hands()
        c.scene_starts()
    check('six raises walk 0 1 2 0 1 2, and do not stick on the first',
          c.fired == [0, 1, 2, 0, 1, 2], str(c.fired))
    check("Live's scene count actually reached the stepper", c.outs.get(1) == 3,
          'count outlet reports %r' % (c.outs.get(1),))
    check('and nothing was asked of the wrong Live object', not c.lom_errors,
          '; '.join(c.lom_errors[:2]))

    # TEST 29 --------------------------------------------------------------
    print('\nTEST 29  a one-scene Set: asking Live about the SAME scene twice must answer')
    # The case that separates live.path's two id outlets.  Outlet 1 emits only WHEN THE ID
    # CHANGES, so a second query for a path it already holds gets no answer and the raise
    # dies with nothing in the Max console.  A single-scene Set asks about scene 0 on every
    # raise, so it is the smallest Set that exposes it - and the obvious thing to try first
    # when testing.  Outlet 0 answers every path message, which is why the request/response
    # path reads outlet 0.  Reverting that one patchline fails this and nothing else.
    c = newsong([False])
    for _ in range(4):
        c.raise_hands()
        c.scene_starts()
    check('four raises keep re-firing the only scene', c.fired == [0, 0, 0, 0], str(c.fired))
    check('no query went unanswered', not c.lom_errors, '; '.join(c.lom_errors[:2]))

    # TEST 30 --------------------------------------------------------------
    print('\nTEST 30  an empty Session grid is REPORTED, not just skipped in silence')
    # Decoded straight out of the presentation Set on 2026-10-06: 8 scenes, 88 clip slots,
    # not one clip in any of them - the song was in the Arrangement.  The stepper walked
    # all 8, found nothing playable and correctly fired nothing, and said nothing at all.
    # Being right and looking broken is the failure this project keeps re-learning, so the
    # silence is the bug, not the behaviour.
    c = newsong([True] * 8)
    c.raise_hands()
    check('still fires nothing', c.fired == [], str(c.fired))
    # A Max message box sends "no clips" as two atoms, which is exactly what the panel's
    # [prepend set] needs to turn into "set no clips" for the comment.
    said = c.outs.get(3)
    check('the window readout says so',
          ' '.join(str(x) for x in (said if isinstance(said, list) else [said])) == 'no clips',
          repr(said))
    check('and so does the Max console',
          any('no scene has a clip' in m for m in c.printed), repr(c.printed[:1]))
    # and it must not latch: filling the grid later has to just work
    c = newsong([False] * 3 + [True] * 5)
    c.raise_hands()
    check('a grid with 3 of 8 filled fires the first filled scene', c.fired == [0],
          str(c.fired))
    check('and does not report "nothing playable"', c.outs.get(3) is None,
          repr(c.outs.get(3)))

    # TEST 31 --------------------------------------------------------------
    print('\nTEST 31  a scene that starts the instant it is fired still unlocks')
    # Lock BEFORE fire, forced with a trigger rather than left to fan-out order.  With the
    # fire first, Live can report is_triggered 1 and 0 before the lock exists, both reports
    # are dropped by the still-shut unlock gate, and the 8 s failsafe ends up running the
    # lockout - once per raise.  That is the guard becoming the timer it was designed not
    # to be, and it happens at Global Quantization None or on an exact downbeat.
    c = newsong([False] * 3)
    c.instant_start = True
    c.raise_hands()
    check('the scene fired', c.fired == [0], str(c.fired))
    check('and the stepper is NOT left locked', c.outs.get(2) == 0, repr(c.outs.get(2)))
    c.raise_hands()
    check('so the next raise advances', c.fired == [0, 1], str(c.fired))

    # TEST 32 --------------------------------------------------------------
    print('\nTEST 32  Live DEFERS every API reply - a raise must survive that')
    # THE BUG THIS SUITE USED TO HIDE, and the fourth time the same shape of mistake has
    # been recorded in this project: the weak point is not the model of Max, it is the
    # model of LIVE.  The stub answered getcount in line, so the walk could be banged
    # from a second branch of the same trigger and still see a count.  In Live the raise
    # arrives in the scheduler thread, every API message is deferred to Live's main
    # thread, and that count comes back AFTER the walk has already run with uzi's own
    # argument of 0.  Nothing fired, ever - not the first scene, not any scene.
    c = newsong(PIECE)
    c.defer_api = True
    c.raise_hands()
    check('nothing has fired while Live has not answered yet', c.fired == [],
          str(c.fired))
    n = c.flush()
    check('Live answered something at all', n > 0, '%d deferred messages' % n)
    check('and the scene fires once the answers arrive', c.fired == [0], str(c.fired))
    c.scene_starts()
    c.defer_api = True
    c.raise_hands()
    c.flush()
    check('a second deferred raise advances', c.fired == [0, 1], str(c.fired))

    # TEST 33 --------------------------------------------------------------
    print('\nTEST 33  the scene count reports itself, with or without a fire')
    # "it does not even say how many scenes there are" was the whole of the available
    # evidence on 2026-10-06, and that was a defect in the readout, not a second bug:
    # the window builds "scene / count" with [sprintf %ld / %ld], whose HOT inlet is the
    # current scene - which only ever arrived when something fired.  So the one raise
    # that most needs to report - the one that fires nothing - was the one that could
    # not.  Both numbers now leave the stepper on every raise, and the console gets them
    # too, because the window can be shut.
    c = newsong([True] * 8)                # eight scenes, every one of them empty
    c.raise_hands()
    check('nothing fired, correctly', c.fired == [], str(c.fired))
    check('the count still reached the readout', c.outs.get(1) == 8,
          repr(c.outs.get(1)))
    check('and so did a current scene, so the readout can form at all',
          c.outs.get(0) == 0, repr(c.outs.get(0)))
    check('the console states the count', 'count 8' in c.printed, str(c.printed))
    check('and still says why nothing fired',
          any('no scene has a clip' in p for p in c.printed), str(c.printed))

    c = newsong([False] * 3 + [True] * 5)
    c.raise_hands()
    check('a raise that DOES fire reports both', c.outs.get(0) == 1 and
          c.outs.get(1) == 8, '%r / %r' % (c.outs.get(0), c.outs.get(1)))
    check('the console names the scene it fired', 'fired 1' in c.printed,
          str(c.printed))

    # TEST 34 --------------------------------------------------------------
    print('\nTEST 34  a scene that starts WITHOUT blinking still releases the lockout')
    # Reported from Live: "it caused one advance and then it stopped working", and not
    # consistently.  live.observer reports a CHANGE, and a scene that starts immediately
    # - transport stopped, or Global Quantization None - never changes is_triggered: 0
    # before the fire, 0 after.  So no notification is ever sent, the lockout is released
    # only by the 8 s failsafe, and the guard silently becomes the timer it was designed
    # not to be.  The stepper now ASKS, 120 ms after firing, with live.observer's own
    # documented bang method.
    c = newsong([False] * 3)
    c.raise_hands()
    check('the scene fired', c.fired == [0], str(c.fired))
    check('and the lockout is on', c.outs.get(2) == 1, repr(c.outs.get(2)))
    c.scene_starts_without_blinking()      # Live says NOTHING at all
    c.advance(60)
    check('still locked before the re-read is due', c.outs.get(2) == 1,
          repr(c.outs.get(2)))
    c.advance(120)
    check('the re-read released it', c.outs.get(2) == 0, repr(c.outs.get(2)))
    check('and it was Live that answered, not the failsafe',
          'is_triggered 0' in c.printed and not any('FAILSAFE' in p for p in c.printed),
          str(c.printed))
    c.raise_hands()
    check('so the next raise advances', c.fired == [0, 1], str(c.fired))

    # and the opposite case must still hold: a scene that IS queued keeps the lock
    c = newsong([False] * 3)
    c.raise_hands()
    c.trig = 1                             # queued and blinking, waiting for the bar
    c.advance(200)
    check('a scene still queued keeps the lockout', c.outs.get(2) == 1,
          repr(c.outs.get(2)))
    c.raise_hands()
    check('and a raise while it is queued does nothing', c.fired == [0], str(c.fired))
    c.scene_starts()
    check('the notification then releases it', c.outs.get(2) == 0,
          repr(c.outs.get(2)))

print('\n' + '=' * 74)
print('  %d/%d PASS' % (sum(PASS), len(PASS)))
print('=' * 74)
print('\nNot covered here, and only provable inside Live: that clicking a parameter really')
print('acquires it, that live.remote~ is accepted, and that a mapping survives a save.')
sys.exit(0 if all(PASS) else 1)
