# verify_zones.py - behavioural verification of [p mb_body] -> [p mb_zones].
#
# Loads MoveBeatController.maxpat and replays BOTH real object graphs, chained exactly as
# they are wired in the patch, under Max's message semantics plus a virtual millisecond
# clock for [del]. A mis-wired patchline or a wrong threshold fails these tests.
#
# Every threshold and every delay this file asserts comes from zone_constants.py, and
# TEST 0 reads them back out of the patch and fails if the two disagree.  Before that
# guard existed each test carried its own copy of 1.15, so forgetting to re-tune the
# patch produced nine green ticks against the wrong device.
#
# Run from the repo root:  python3 synth/docs/verification/verify_zones.py
import json,math,re,os,sys
sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
import zone_constants as Z
ROOT=os.path.join(os.path.dirname(os.path.abspath(__file__)),'..','..','..')
doc=json.load(open(os.path.join(ROOT,'synth','controller','MoveBeatController.maxpat')))
SUB={b['box']['text']:b['box']['patcher'] for b in doc['patcher']['boxes'] if 'patcher' in b['box']}

NOW=[0.0]; TIMERS={}                      # objkey -> due time

class Patch:
    def __init__(s,p,name):
        s.name=name
        s.BOX={b['box']['id']:b['box'] for b in p['boxes']}
        s.FAN={}
        for L in p['lines']:
            l=L['patchline']; s.FAN.setdefault(tuple(l['source']),[]).append(tuple(l['destination']))
        s.st={i:[0.0]*b['numinlets'] for i,b in s.BOX.items()}
        s.last={}; s.sink=[]
        s.inlets=[b['id'] for b in sorted(s.BOX.values(),key=lambda z:z['patching_rect'][0]) if b['maxclass']=='inlet']
        s.outlets=[b['id'] for b in sorted(s.BOX.values(),key=lambda z:z['patching_rect'][0]) if b['maxclass']=='outlet']
        s.on_out={}
    def emit(s,oid,n,v):
        for d,di in s.FAN.get((oid,n),[]): s.send(d,di,v)
    def send(s,oid,inl,v):
        b=s.BOX[oid]; mc=b['maxclass']; t=b.get('text','')
        if mc=='comment': return
        if mc=='outlet':
            i=s.outlets.index(oid)
            if i in s.on_out: s.on_out[i](v)
            return
        if mc=='inlet': s.emit(oid,0,v); return
        if mc=='message':
            if t=='stop': s.emit(oid,0,'stop')
            else: s.emit(oid,0,float(t) if '.' in t else int(t))
            return
        hot=1 if t=='gate' else 0
        if t.startswith('pak '):
            s.st[oid][inl]=v; s.emit(oid,0,list(s.st[oid])); return
        if t=='int':
            if inl==1: s.st[oid][1]=v; return
            if v=='bang': s.emit(oid,0,s.st[oid][1]); return
            s.st[oid][1]=v; s.emit(oid,0,v); return
        if t.startswith('del '):
            if v=='stop': TIMERS.pop((s.name,oid),None); return
            TIMERS[(s.name,oid)]=NOW[0]+float(t.split()[1]); return
        if inl!=hot: s.st[oid][inl]=v; return
        s.st[oid][inl]=v
        if t.startswith('unpack'):
            for k in range(b['numoutlets']-1,-1,-1): s.emit(oid,k,v[k])
        elif t=='change':
            if s.last.get(oid,'\0')!=v: s.last[oid]=v; s.emit(oid,0,v)
        elif t.startswith('sel '):
            args=[float(x) for x in t.split()[1:]]
            for k,a in enumerate(args):
                if float(v)==a: s.emit(oid,k,'bang'); return
            s.emit(oid,len(args),v)
        elif t.startswith('=='):
            s.emit(oid,0,1 if float(v)==float(t.split()[1]) else 0)
        elif t=='gate':
            if s.st[oid][0]: s.emit(oid,0,v)
        elif t.startswith('t '):
            o=t.split()[1:]
            for k in range(len(o)-1,-1,-1): s.emit(oid,k,'bang' if o[k]=='b' else v)
        elif t.startswith('expr '):
            e=re.sub(r'\$[fis](\d+)',lambda m:'(%r)'%float(s.st[oid][int(m.group(1))-1]),t[5:])
            s.emit(oid,0,eval(e,{'sqrt':math.sqrt,'__builtins__':{}}))
        elif t.startswith('clip '):
            lo,hi=[float(x) for x in t.split()[1:3]]; s.emit(oid,0,max(lo,min(hi,v)))
        elif t.startswith('slide '):
            up,dn=[float(x) for x in t.split()[1:3]]
            y=s.last.get(('sl',oid),0.0); y=y+(v-y)/(up if v>y else dn)
            s.last[('sl',oid)]=y; s.emit(oid,0,y)
        elif t.startswith('pack '):
            s.emit(oid,0,list(s.st[oid]))
        else: raise SystemExit('unhandled '+t)

BODY=Patch(SUB['p mb_body'],'body'); ZONES=Patch(SUB['p mb_zones'],'zones')
OUT={'flags':[0]*9,'busy':[0,0],'armed':0}
BODY.on_out={0:lambda v: ZONES.send(ZONES.inlets[0],0,v)}
ZONES.on_out={0:lambda v:OUT.__setitem__('flags',[int(x) for x in v]),
              1:lambda v:OUT.__setitem__('busy',[int(x) for x in v]),
              2:lambda v:OUT.__setitem__('armed',int(v))}

def fire_due():
    while True:
        due=[k for k,t in TIMERS.items() if t<=NOW[0]]
        if not due: break
        for k in due:
            TIMERS.pop(k)
            p=BODY if k[0]=='body' else ZONES
            p.emit(k[1],0,'bang')

def frame(hL,hR,head=(0,0.72,2.5),sb=(0,0.0,2.5),ss=(0,0.50,2.5),tracked=1,ts=2.0,dt=33.0,badjoint=None):
    for nm,v in (('spineB',sb),('head',head),('handL',hL),('handR',hR),('spineS',ss)):
        t = 1.0 if nm==badjoint else ts                      # one joint inferred, the rest tracked - as verify_body.py
        BODY.send(BODY.inlets[{'handL':0,'handR':1,'head':2,'spineB':3,'spineS':4}[nm]],0,[v[0],v[1],v[2],t])
    BODY.send(BODY.inlets[5],0,tracked)
    NOW[0]+=dt; fire_due()
    return OUT

NAMES=['abvL','abvR','abvB','lftL','lftR','lftB','rgtL','rgtR','rgtB']
def on(): return [NAMES[i] for i,v in enumerate(OUT['flags']) if v] or ['-none-']
def run(n,**kw):
    for _ in range(n): frame(**kw)
    return OUT

# The replayed body: spinebase at y=0, spineshoulder at y=0.50, so one BODY LENGTH is
# 0.50 m and a position in body lengths converts straight to the metres the joints carry.
# Head at 0.72 m = 1.44 body lengths.  Every pose below is built from zone_constants.py
# through bl(), so a change to a threshold moves the test poses with it.
SPINE=0.50
def bl(v): return round(v*SPINE,4)          # body lengths -> metres, for a joint
FRAME=33.0                                  # ms per replayed frame, as frame() advances
def frames(ms): return int(ms/FRAME)+1      # frames needed to get past a delay

REST=dict(hL=(-bl(0.40),0.10,2.5), hR=(bl(0.40),0.10,2.5))   # hands hanging, well inside
UPR =dict(hL=(-bl(0.40),0.10,2.5), hR=(bl(0.40),1.10,2.5))
UPL =dict(hL=(-bl(0.40),1.10,2.5), hR=(bl(0.40),0.10,2.5))
UPB =dict(hL=(-bl(0.40),1.10,2.5), hR=(bl(0.40),1.10,2.5))

def side(x_bl, hand='R', y=0.10):
    """One hand out to the side at x body lengths, the other at rest."""
    p=dict(REST)
    p['hR' if hand=='R' else 'hL']=(bl(x_bl) if hand=='R' else -bl(x_bl), y, 2.5)
    return p

IN_SIDE  = Z.SIDE_ENTER+0.25                       # comfortably inside the zone
MID_BAND = (Z.SIDE_ENTER+Z.SIDE_LEAVE)/2.0         # between leave and enter: still latched
OUT_SIDE = Z.SIDE_LEAVE-0.05                       # past the exit
RGT      = side(IN_SIDE)
UPLEFT   = dict(hL=(-bl(1.50),1.10,2.5), hR=(bl(0.40),0.10,2.5))   # hand up AND far left

ok=lambda b:'PASS' if b else 'FAIL'; R=[]

# TEST 0 -------------------------------------------------------------------
# The guard that makes every other number in this file mean something: what the patch
# actually contains, not what this file hopes it contains.  tune_zones.py is a separate
# step from build_cells.py, so forgetting it is the easy mistake - and it used to be an
# invisible one.
print("TEST 0  the patch's own thresholds and delays match zone_constants.py")
ZB={b['box']['id']:b['box'] for b in SUB['p mb_zones']['boxes']}
TXT=[str(b.get('text','') or '') for b in ZB.values()]
want_above='expr $f1 > $f2 + %s - $f3 * %s'%(Z.fmt(Z.ABOVE_ENTER),Z.fmt(Z.ABOVE_ENTER-Z.ABOVE_LEAVE))
want_side =lambda s:'expr ($f1 * %s > %s - $f3 * %s) * (1 - $f2)'%(s,Z.fmt(Z.SIDE_ENTER),Z.fmt(Z.SIDE_ENTER-Z.SIDE_LEAVE))
dels=sorted(int(t.split()[1]) for t in TXT if t.startswith('del '))
want_dels=sorted([Z.COMMIT_ABOVE,Z.COMMIT_SIDE,Z.COMMIT_SIDE,Z.GRACE,Z.LOST_DEBOUNCE])
R.append(TXT.count(want_above)==2 and TXT.count(want_side('1'))==2
         and TXT.count(want_side('-1'))==2 and dels==want_dels)
print(f"    ABOVE enter head+{Z.fmt(Z.ABOVE_ENTER)}  leave head+{Z.fmt(Z.ABOVE_LEAVE)}")
print(f"    SIDE  enter {Z.fmt(Z.SIDE_ENTER)}       leave {Z.fmt(Z.SIDE_LEAVE)}")
print(f"    delays in the patch {dels}  expected {want_dels}   {ok(R[-1])}")
if not R[-1]:
    print("    -> run:  python3 synth/docs/verification/tune_zones.py")

run(400,**REST)
print("\nTEST 1  rest pose activates nothing");             R.append(on()==['-none-'])
print("   ",on(),ok(R[-1]))

print(f"\nTEST 2  one hand up -> the one-hand cell, and not before the {Z.COMMIT_ABOVE} ms ABOVE commit")
n_in, n_past = frames(Z.COMMIT_ABOVE*0.8)-1, frames(Z.COMMIT_ABOVE)+1
frame(**UPR); t1=list(on()); run(n_in,**UPR); tin=list(on()); run(n_past-n_in-1,**UPR); tpast=list(on())
R.append(t1==['-none-'] and tin==['-none-'] and tpast==['abvR'])
print(f"     {FRAME:.0f} ms: {t1}\n    {(n_in+1)*FRAME:.0f} ms: {tin}   <- still inside the commit window")
print(f"    {n_past*FRAME:.0f} ms: {tpast}   {ok(R[-1])}")

print("\nTEST 3  BOTH hands up must never flash the one-hand cell on the way")
run(60,**REST); seen=set()
for i in range(frames(Z.COMMIT_ABOVE)+3):
    frame(**(UPL if i==0 else UPB)); seen.update(on())     # left hand first, right 33 ms later
R.append('abvL' not in seen and 'abvR' not in seen and 'abvB' in seen)
print(f"    everything seen during the raise: {sorted(seen)}   {ok(R[-1])}")

print("\nTEST 4  the head rule - a hand up AND far left is ABOVE, never LEFT")
run(60,**REST); run(frames(Z.COMMIT_ABOVE)+3,**UPLEFT)
R.append(on()==['abvL'])
print(f"    hand at x=-1.50 body, above the head: {on()}   {ok(R[-1])}")

print(f"\nTEST 5  side zone, and hysteresis between {Z.fmt(Z.SIDE_LEAVE)} and {Z.fmt(Z.SIDE_ENTER)}")
run(60,**REST); nside=frames(Z.COMMIT_SIDE)+1
run(nside,**RGT); a=list(on())
run(nside,**side(MID_BAND)); b=list(on())
run(nside,**side(OUT_SIDE)); c=list(on())
R.append(a==['rgtR'] and b==['rgtR'] and c==['-none-'])
print(f"    reached out ({IN_SIDE:.2f} body): {a}\n    drifted back to {MID_BAND:.2f}   : {b}  <- still latched")
print(f"    crossed the exit at {OUT_SIDE:.2f}: {c}   {ok(R[-1])}")

print(f"\nTEST 6  chattering on the {Z.fmt(Z.SIDE_ENTER)} entry threshold does not chatter the output")
run(60,**REST); flips=0; prev=list(OUT['flags'])
for i in range(40):
    frame(**side(Z.SIDE_ENTER+(0.008 if i%2 else -0.008)))
    if OUT['flags']!=prev: flips+=1; prev=list(OUT['flags'])
R.append(flips<=1)
print(f"    40 frames jittering across {Z.fmt(Z.SIDE_ENTER)} body -> {flips} output change(s)   {ok(R[-1])}")

print(f"\nTEST 7  a side zone commits in {Z.COMMIT_SIDE} ms, not {Z.COMMIT_ABOVE} - the whole point of the 2026-10-06 change")
# What the user reported as "it enters with a delay".  A side cell drives a knob, so the
# worst a wrong answer can do is move one for two frames; ABOVE fires scenes and keeps
# the long commit.  Measured here as the number of frames before the flag appears.
run(400,**REST)
got=None
for k in range(1,frames(Z.COMMIT_ABOVE)+2):
    frame(**RGT)
    if on()!=['-none-'] and got is None: got=k
R.append(got is not None and got*FRAME<=Z.COMMIT_SIDE+FRAME)
print(f"    the side flag appeared on frame {got} ({got*FRAME:.0f} ms); ABOVE would still be waiting   {ok(R[-1])}")

print("\nTEST 8  losing the body releases everything")
run(60,**REST); run(frames(Z.COMMIT_SIDE)+1,**RGT); held=list(on())
run(1,tracked=0,**RGT); soon=list(on())
run(frames(Z.COMMIT_SIDE)+1,tracked=0,**RGT); lost=list(on())
R.append(held==['rgtR'] and soon==['rgtR'] and lost==['-none-'])
print(f"    holding the zone: {held}")
print(f"    {FRAME:.0f} ms after loss: {soon}   <- inside the {Z.COMMIT_SIDE} ms commit window")
print(f"    and once it closes: {lost}   {ok(R[-1])}")

print(f"\nTEST 9  fire stays blocked for {Z.GRACE} ms after tracking returns")
run(60,**REST); run(frames(Z.GRACE)+5,tracked=0,**REST); a=OUT['armed']
run(frames(Z.GRACE*0.5),**REST); b=OUT['armed']
run(frames(Z.GRACE*0.6),**REST); c=OUT['armed']
R.append(a==0 and b==0 and c==1)
print(f"    while lost: armed={a}   halfway back: armed={b}   past {Z.GRACE} ms: armed={c}   {ok(R[-1])}")

print("\nTEST 10  hand-busy pair drives the freeze rule")
run(60,**REST); n=list(OUT['busy'])
run(frames(Z.COMMIT_SIDE)+1,**RGT); r=list(OUT['busy'])
run(frames(Z.COMMIT_ABOVE)+2,**UPB); bb=list(OUT['busy'])
R.append(n==[0,0] and r==[0,1] and bb==[1,1])
print(f"    rest {n}   right hand out {r}   both hands up {bb}   [L,R]   {ok(R[-1])}")

print(f"\nTEST 11  a one-frame valid blip must NOT block the fire")
# THE FAULT THIS TEST EXISTS FOR, and it was measured rather than reasoned.  `valid`
# demands all five joints at trackingState exactly 2, and a live stream from a real body
# drops one about ONCE A SECOND - a hand crossing the torso, the head joint wobbling.
# The fire-arm used to be driven straight off valid: it blocked the instant valid fell
# and then needed GRACE ms of UNINTERRUPTED valid to re-arm, so the timer was reset
# about as often as it could complete.  Replaying these same graphs against the live
# stream showed the fire BLOCKED FOR 40 SECONDS STRAIGHT, and an abvB rising edge
# arriving inside a blocked window and being refused with nothing printed anywhere.
# That is what the performer reported as "the raise does not register consistently".
#
# TEST 9 did not catch it, and the reason is worth keeping: TEST 9 loses tracking with
# tracked=0 for a whole second - the obvious failure, walking out of frame.  The blip is
# its neighbour, and nothing looked at it.
run(60,**REST);                      armed_before=OUT['armed']
frame(ts=1.0,**REST);                blip=OUT['armed']      # ONE frame, joints inferred
run(frames(Z.LOST_DEBOUNCE)+5,**REST);  after=OUT['armed']  # valid back, past the de-bounce
# and a loss that really lasts must still block, or TEST 9's guarantee is gone
run(frames(Z.LOST_DEBOUNCE)+5,tracked=0,**REST); genuine=OUT['armed']
R.append(armed_before==1 and blip==1 and after==1 and genuine==0)
print(f"    armed before the blip {armed_before}   during it {blip}   "
      f"{Z.LOST_DEBOUNCE} ms after it {after}   after a real loss {genuine}   {ok(R[-1])}")

print(f"\nTEST 12  a hand going inferred must NOT disarm the fire; losing the BODY must")
# WHY THIS TEST EXISTS - a measurement, not a theory.  Driving these same two graphs from
# the live Kinect stream while the performer danced: the raise itself was fine (44 raises,
# 42 reached abvB), but handleft / handright LEFT trackingState 2 ABOUT 10-11 TIMES PER
# 10 SECONDS, EACH DROPOUT LONGER THAN 500 ms.  A de-bounce on `valid` cannot cover that:
# short enough to catch a real walk-out is shorter than these dropouts, long enough to
# forgive them stops catching the walk-out.  So the fire was disarmed constantly and two
# abvB rising edges were refused in silence.  The question was wrong - GRACE guards
# against re-entering the FRAME, which is a BODY event, and /mb/tracked is that signal.
# arm_from_tracked.py carries it through the pack and drives the fire-arm from it alone;
# `valid` still blanks the nine zone flags.  TEST 11 cannot see this: its blip is one
# frame, which the de-bounce forgives either way.  Phase b here is the whole test - one
# hand inferred for LONGER than LOST_DEBOUNCE while the body stays tracked.
run(60,**REST);                                          a=OUT['armed']   # settled, armed
run(frames(Z.LOST_DEBOUNCE)+5,badjoint='handL',**REST);  b=OUT['armed']   # hand inferred, body tracked
run(frames(Z.LOST_DEBOUNCE)+5,tracked=0,**REST);         c=OUT['armed']   # the BODY gone
run(frames(Z.GRACE)+5,**REST);                           d=OUT['armed']   # back, past GRACE
R.append(a==1 and b==1 and c==0 and d==1)
dropout=(frames(Z.LOST_DEBOUNCE)+5)*FRAME
print(f"    armed at rest {a}   left hand inferred for {dropout:.0f} ms with the body tracked {b}   <- must stay armed")
print(f"    body lost for the same {dropout:.0f} ms {c}   <- must block   {Z.GRACE} ms after it returns {d}   {ok(R[-1])}")

print(f"\n{'='*58}\n  {sum(R)}/{len(R)} PASS")
