# verify_zones.py - behavioural verification of [p mb_body] -> [p mb_zones].
#
# Loads MoveBeatController.maxpat and replays BOTH real object graphs, chained exactly as
# they are wired in the patch, under Max's message semantics plus a virtual millisecond
# clock for [del]. A mis-wired patchline or a wrong threshold fails these tests.
#
# Run from the repo root:  python3 synth/docs/verification/verify_zones.py
import json,math,re,os
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

def frame(hL,hR,head=(0,0.72,2.5),sb=(0,0.0,2.5),ss=(0,0.50,2.5),tracked=1,ts=2.0,dt=33.0):
    for nm,v in (('spineB',sb),('head',head),('handL',hL),('handR',hR),('spineS',ss)):
        BODY.send(BODY.inlets[{'handL':0,'handR':1,'head':2,'spineB':3,'spineS':4}[nm]],0,[v[0],v[1],v[2],ts])
    BODY.send(BODY.inlets[5],0,tracked)
    NOW[0]+=dt; fire_due()
    return OUT

NAMES=['abvL','abvR','abvB','lftL','lftR','lftB','rgtL','rgtR','rgtB']
def on(): return [NAMES[i] for i,v in enumerate(OUT['flags']) if v] or ['-none-']
def run(n,**kw):
    for _ in range(n): frame(**kw)
    return OUT

REST=dict(hL=(-0.20,0.10,2.5), hR=(0.20,0.10,2.5))
UPR =dict(hL=(-0.20,0.10,2.5), hR=(0.20,1.10,2.5))
UPL =dict(hL=(-0.20,1.10,2.5), hR=(0.20,0.10,2.5))
UPB =dict(hL=(-0.20,1.10,2.5), hR=(0.20,1.10,2.5))
RGT =dict(hL=(-0.20,0.10,2.5), hR=(0.70,0.10,2.5))
UPLEFT=dict(hL=(-0.75,1.10,2.5), hR=(0.20,0.10,2.5))   # hand up AND far left
ok=lambda b:'PASS' if b else 'FAIL'; R=[]

run(400,**REST)
print("TEST 1  rest pose activates nothing");             R.append(on()==['-none-'])
print("   ",on(),ok(R[-1]))

print("\nTEST 2  one hand up -> the one-hand cell, and not before the 200 ms commit")
frame(**UPR); t33=list(on()); run(4,**UPR); t165=list(on()); run(4,**UPR); t297=list(on())
R.append(t33==['-none-'] and t165==['-none-'] and t297==['abvR'])
print(f"     33 ms: {t33}\n    165 ms: {t165}   <- still inside the commit window")
print(f"    297 ms: {t297}   {ok(R[-1])}")

print("\nTEST 3  BOTH hands up must never flash the one-hand cell on the way")
run(60,**REST); seen=set()
for i in range(12):
    frame(**(UPL if i==0 else UPB)); seen.update(on())     # left hand first, right 33 ms later
R.append('abvL' not in seen and 'abvR' not in seen and 'abvB' in seen)
print(f"    everything seen during the raise: {sorted(seen)}   {ok(R[-1])}")

print("\nTEST 4  the head rule - a hand up AND far left is ABOVE, never LEFT")
run(60,**REST); run(12,**UPLEFT)
R.append(on()==['abvL'])
print(f"    hand at x=-0.75 body, above the head: {on()}   {ok(R[-1])}")

print("\nTEST 5  side zone, and hysteresis at its boundary")
run(60,**REST); run(12,**RGT); a=list(on())
run(12,hL=(-0.20,0.10,2.5),hR=(0.53,0.10,2.5)); b=list(on())   # 1.06 body: inside the band
run(12,hL=(-0.20,0.10,2.5),hR=(0.48,0.10,2.5)); c=list(on())   # 0.96 body: past the exit
R.append(a==['rgtR'] and b==['rgtR'] and c==['-none-'])
print(f"    reached out (1.40 body): {a}\n    drifted back to 1.06   : {b}  <- still latched")
print(f"    crossed the exit at 0.96: {c}   {ok(R[-1])}")

print("\nTEST 6  chattering on the entry threshold does not chatter the output")
run(60,**REST); flips=0; prev=list(OUT['flags'])
for i in range(40):
    frame(hL=(-0.20,0.10,2.5),hR=(0.575+ (0.004 if i%2 else -0.004),0.10,2.5))
    if OUT['flags']!=prev: flips+=1; prev=list(OUT['flags'])
R.append(flips<=1)
print(f"    40 frames jittering across 1.15 body -> {flips} output change(s)   {ok(R[-1])}")

print("\nTEST 7  losing the body releases everything")
run(60,**REST); run(12,**RGT); held=list(on())
run(5,tracked=0,**RGT); soon=list(on())
run(5,tracked=0,**RGT); lost=list(on())
R.append(held==['rgtR'] and lost==['-none-'])
print(f"    holding the zone: {held}")
print(f"    165 ms after loss: {soon}   <- inside the commit window")
print(f"    330 ms after loss: {lost}   {ok(R[-1])}")

print("\nTEST 8  fire stays blocked for 1 s after tracking returns")
run(60,**REST); run(20,tracked=0,**REST); a=OUT['armed']
run(15,**REST); b=OUT['armed']          # ~500 ms back
run(20,**REST); c=OUT['armed']          # ~1.1 s back
R.append(a==0 and b==0 and c==1)
print(f"    while lost: armed={a}   500 ms after return: armed={b}   1.1 s after: armed={c}   {ok(R[-1])}")

print("\nTEST 9  hand-busy pair drives the freeze rule")
run(60,**REST); n=list(OUT['busy']); run(12,**RGT); r=list(OUT['busy']); run(12,**UPB); bb=list(OUT['busy'])
R.append(n==[0,0] and r==[0,1] and bb==[1,1])
print(f"    rest {n}   right hand out {r}   both hands up {bb}   [L,R]   {ok(R[-1])}")

print(f"\n{'='*58}\n  {sum(R)}/{len(R)} PASS")
