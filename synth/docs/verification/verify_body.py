# verify_body.py - structural + numerical verification of [p mb_body].
#
# This does NOT re-implement mb_body. It loads MoveBeatController.maxpat, walks the
# real object graph inside the subpatcher, and replays it with Max's own message
# semantics: outlets fire right-to-left, inlet 0 is hot (except gate, whose data
# inlet is the right one), every other inlet stores. So a mis-wired patchline fails
# these tests - which is the point. Reading a patch does not tell you what it does.
#
# Run from the repo root:  python3 synth/docs/verification/verify_body.py
import json,math,re

import os
ROOT=os.path.join(os.path.dirname(os.path.abspath(__file__)),'..','..','..')
doc=json.load(open(os.path.join(ROOT,'synth','controller','MoveBeatController.maxpat')))
sp=[b['box'] for b in doc['patcher']['boxes'] if b['box'].get('text')=='p mb_body'][0]['patcher']
BOX={b['box']['id']:b['box'] for b in sp['boxes']}
FAN={}
for L in sp['lines']:
    s=L['patchline']; FAN.setdefault(tuple(s['source']),[]).append(tuple(s['destination']))

class Obj:
    def __init__(s,b):
        s.b=b; s.t=b.get('text','') ; s.st=[0.0]*b['numinlets']; s.y=0.0; s.first=True
OBJ={i:Obj(b) for i,b in BOX.items()}
OUTPUT=[]

def emit(oid,outn,val):
    for (d,di) in FAN.get((oid,outn),[]):
        send(d,di,val)

def send(oid,inl,val):
    o=OBJ[oid]; mc=o.b['maxclass']; t=o.t
    if mc=='outlet': OUTPUT.append(val); return
    if mc=='comment': return
    if mc=='inlet': emit(oid,0,val); return
    hot = 1 if t=='gate' else 0          # gate's data inlet is the right one
    if inl!=hot: o.st[inl]=val; return
    o.st[inl]=val
    if t.startswith('unpack'):
        for k in range(3,-1,-1): emit(oid,k,val[k])     # right to left
    elif t.startswith('=='):
        emit(oid,0,1.0 if val==float(t.split()[1]) else 0.0)
    elif t=='gate':
        if o.st[0]: emit(oid,0,val)
    elif t.startswith('t '):
        outs=t.split()[1:]
        for k in range(len(outs)-1,-1,-1):              # right to left
            emit(oid,k,'bang' if outs[k]=='b' else val)
    elif t.startswith('expr '):
        e=t[5:]
        e=re.sub(r'\$[fis](\d+)',lambda m:'(%r)'%o.st[int(m.group(1))-1],e)
        emit(oid,0,eval(e,{'sqrt':math.sqrt,'__builtins__':{}}))
    elif t.startswith('clip '):
        lo,hi=[float(x) for x in t.split()[1:3]]
        emit(oid,0,max(lo,min(hi,val)))
    elif t.startswith('slide '):
        up,dn=[float(x) for x in t.split()[1:3]]
        n=up if val>o.y else dn
        o.y=o.y+(val-o.y)/n
        emit(oid,0,o.y)
    elif t.startswith('pack '):
        emit(oid,0,list(o.st))
    else: raise SystemExit('unhandled: '+t)

INL=sorted([b for b in BOX.values() if b['maxclass']=='inlet'],key=lambda z:z['patching_rect'][0])
IN={n:INL[i]['id'] for i,n in enumerate(['handL','handR','head','spineB','spineS','trig'])}

def frame(hL,hR,head,sb,ss,tracked=1,ts=2.0,badjoint=None):
    for name,v in (('spineB',sb),('head',head),('handL',hL),('handR',hR),('spineS',ss)):
        t = 1.0 if name==badjoint else ts
        send(IN[name],0,[v[0],v[1],v[2],t])
    send(IN['trig'],0,tracked)
    return OUTPUT[-1]

def show(tag,L):
    print(f"  {tag:<26} hL=({L[1]:+.2f},{L[2]:+.2f},{L[3]:+.2f}) hR=({L[4]:+.2f},{L[5]:+.2f},{L[6]:+.2f}) "
          f"spread={L[7]:.2f} headY={L[8]:+.2f} scale={L[9]:.3f} valid={L[10]:.0f}")

# A standing person. Kinect camera space: origin at sensor, +Y up, +Z away.
def pose(z, hLx=-0.45, hLy=0.30, hRx=+0.45, hRy=0.30):
    return dict(hL=(hLx,hLy,z), hR=(hRx,hRy,z), head=(0,0.72,z), sb=(0,0.0,z), ss=(0,0.50,z))

print("settling the scale filter (400 frames)...")
for _ in range(400): L=frame(**pose(2.5))
show("rest, 2.5 m",L)

print("\nTEST 1  distance invariance - the core claim")
a=frame(**pose(2.5))
for _ in range(400): b_=frame(**pose(3.5))
show("same pose at 2.5 m",a); show("same pose at 3.5 m",b_)
d=max(abs(a[i]-b_[i]) for i in range(1,9))
print(f"  -> largest difference across all coords: {d:.6f}   {'PASS' if d<1e-9 else 'FAIL'}")

print("\nTEST 2  the head-height boundary")
lo=frame(**pose(2.5,hRy=0.30)); hi=frame(**pose(2.5,hRy=1.10))
print(f"  hand at chest : hR.y={lo[5]:+.2f}  head.y={lo[8]:+.2f}  above={'YES' if lo[5]>lo[8] else 'no'}")
print(f"  hand overhead : hR.y={hi[5]:+.2f}  head.y={hi[8]:+.2f}  above={'YES' if hi[5]>hi[8] else 'no'}")
print(f"  -> {'PASS' if (not lo[5]>lo[8]) and hi[5]>hi[8] else 'FAIL'}")

print("\nTEST 3  spread, and that it is distance-invariant too")
n=frame(**pose(2.5,hLx=-0.20,hRx=+0.20)); w=frame(**pose(2.5,hLx=-0.80,hRx=+0.80))
for _ in range(400): f=frame(**pose(4.0,hLx=-0.80,hRx=+0.80))
print(f"  narrow (0.40 m apart): {n[7]:.3f}     wide (1.60 m apart): {w[7]:.3f}")
print(f"  wide, but at 4.0 m   : {f[7]:.3f}   -> {'PASS' if abs(w[7]-f[7])<1e-9 and w[7]>n[7] else 'FAIL'}")

print("\nTEST 4  scale tracks real spine length")
tall=pose(2.5); tall['ss']=(0,0.62,2.5)
for _ in range(200): L=frame(**tall)
print(f"  spine 0.62 m -> scale {L[9]:.3f}   {'PASS' if abs(L[9]-0.62)<0.01 else 'FAIL'}")
for _ in range(200): L=frame(**pose(2.5))
print(f"  spine 0.50 m -> scale {L[9]:.3f}   {'PASS' if abs(L[9]-0.50)<0.01 else 'FAIL'}")

print("\nTEST 5  valid drops when a joint is only inferred")
g=frame(**pose(2.5)); bad=frame(**pose(2.5),badjoint='spineS'); off=frame(**pose(2.5),tracked=0)
print(f"  all tracked: valid={g[10]:.0f}   spineshoulder inferred: valid={bad[10]:.0f}   /mb/tracked=0: valid={off[10]:.0f}")
print(f"  -> {'PASS' if g[10]==1 and bad[10]==0 and off[10]==0 else 'FAIL'}")

print("\nTEST 6  the divide guard - a cold start with no scale yet")
for i in OBJ.values(): i.st=[0.0]*i.b['numinlets']; i.y=0.0
c=frame(**pose(2.5))
finite=all(math.isfinite(v) for v in c[1:])
print(f"  first frame ever: scale={c[9]:.3f}  all values finite: {finite}   {'PASS' if finite else 'FAIL'}")
show("cold first frame",c)
