import json,copy,collections,io
P='synth/controller/MoveBeatController.maxpat'
doc=json.load(open(P),object_pairs_hook=collections.OrderedDict)
root=doc['patcher']
OD=collections.OrderedDict

def mkbox(i,mc,nin,nout,rect,text=None,ot=None,patcher=None,extra=None):
    b=OD(); b['id']=i; b['maxclass']=mc; b['numinlets']=nin; b['numoutlets']=nout
    if nout: b['outlettype']=ot if ot else ['']*nout
    b['patching_rect']=[float(v) for v in rect]
    if text is not None: b['text']=text
    if extra: b.update(extra)
    if patcher is not None: b['patcher']=patcher
    return b

def newsub():
    S={'boxes':[],'lines':[],'n':[0]}
    def nid(): S['n'][0]+=1; return 'obj-%d'%S['n'][0]
    def box(mc,x,y,w,h,text=None,nin=1,nout=1,ot=None):
        i=nid(); S['boxes'].append(OD(box=mkbox(i,mc,nin,nout,[x,y,w,h],text,ot))); return i
    def obj(t,x,y,w=150,nin=1,nout=1,ot=None): return box('newobj',x,y,w,22,t,nin,nout,ot)
    def cmt(t,x,y,w=420): return box('comment',x,y,w,20,t,1,0)
    def msg(t,x,y,w=60): return box('message',x,y,w,22,t,2,1)
    def L(s,so,d,di): S['lines'].append(OD(patchline=OD(destination=[d,di],source=[s,so])))
    def finish(rect):
        return OD([('fileversion',1),('appversion',copy.deepcopy(root['appversion'])),
                   ('classnamespace','box'),('rect',[float(v) for v in rect]),
                   ('boxes',S['boxes']),('lines',S['lines'])])
    return box,obj,cmt,msg,L,finish

# ============================== mb_body ==============================
box,obj,cmt,msg,L,finish=newsub()
SAFE=lambda n:'(($f%d > 0.2) * $f%d + ($f%d <= 0.2) * 0.5)'%(n,n,n)
for i,t in enumerate([
 'mb_body - BODY-RELATIVE COORDINATES.  Every position is expressed as an offset from',
 'spinebase, divided by spine length, so it survives the dancer moving around the room',
 'and reads the same for any performer at any distance.  Feeds the zone layer only -',
 'mb_sources is untouched and still works in absolute sensor metres.']): cmt(t,20,8+i*20,640)
cmt('OUT (list, use zl nth):  2 hL.x  3 hL.y  4 hL.z   5 hR.x  6 hR.y  7 hR.z',20,96,640)
cmt('                         8 spread   9 head.y   10 scale(m)   11 valid',20,116,640)
JX=OD([('handL',30),('handR',200),('head',370),('spineB',540),('spineS',710)])
inl=OD(); 
for k,x in JX.items():
    inl[k]=box('inlet',x,190,30,30,None,0,1); cmt(k,x,168,150)
trig=box('inlet',880,190,30,30,None,0,1); cmt('frame trigger',880,168,150)
G={};TRK={}
for k,x in JX.items():
    up=obj('unpack 0. 0. 0. 0.',x,240,150,1,4,['float']*4); L(inl[k],0,up,0)
    eq=obj('== 2.',x+120,285,50,2,1); L(up,3,eq,0); TRK[k]=eq
    for ai,a in enumerate(['y'] if k=='head' else ['x','y','z']):
        g=obj('gate',x+ai*48,330,44,2,1)
        L(eq,0,g,0); L(up,{'x':0,'y':1,'z':2}[a],g,1); G[(k,a)]=g
sc=obj('expr sqrt(($f1-$f4)*($f1-$f4)+($f2-$f5)*($f2-$f5)+($f3-$f6)*($f3-$f6))',710,390,420,6,1)
for i,a in enumerate(['x','y','z']): L(G[('spineS',a)],0,sc,i); L(G[('spineB',a)],0,sc,i+3)
c1=obj('clip 0.25 0.7',710,430,110,3,1); L(sc,0,c1,0)
sl=obj('slide 15 15',710,470,110,3,1); L(c1,0,sl,0)
scale=obj('clip 0.25 0.7',710,510,110,3,1); L(sl,0,scale,0)
cmt('spine length = the scale everything is divided by. Clamped so it can never be 0.',830,432,540)
cmt('Smoothed: a scale jump would lurch every mapped parameter at once.',830,472,540)
cmt('Cold start only: reads at the 0.25 floor and settles over ~2 s. Nothing performs then.',830,512,600)
REL={}
for k,x,axes in (('handL',30,['x','y','z']),('handR',200,['x','y','z']),('head',370,['y'])):
    for ai,a in enumerate(axes):
        e=obj('expr ($f1 - $f2) / '+SAFE(3),x,570+ai*40,300,3,1)
        L(G[(k,a)],0,e,0); L(G[('spineB',a)],0,e,1); L(scale,0,e,2); REL[(k,a)]=e
cmt('joint - spinebase, over spine length',680,570,400)
sp=obj('expr sqrt(($f1-$f4)*($f1-$f4)+($f2-$f5)*($f2-$f5)+($f3-$f6)*($f3-$f6)) / '+SAFE(7),30,700,560,7,1)
for i,a in enumerate(['x','y','z']): L(G[('handR',a)],0,sp,i); L(G[('handL',a)],0,sp,i+3)
L(scale,0,sp,6); cmt('distance between the hands',610,700,400)
tb=obj('t b i',880,240,80,1,2,['bang','int']); L(trig,0,tb,0)
valid=obj('expr $i1 * $f2 * $f3 * $f4 * $f5 * $f6',880,290,280,6,1); L(tb,1,valid,0)
for i,k in enumerate(['handL','handR','head','spineB','spineS']): L(TRK[k],0,valid,i+1)
cmt('valid = body present AND all five joints really tracked',1170,292,420)
pk=obj('pack 0 0. 0. 0. 0. 0. 0. 0. 0. 0. 0.',30,780,400,11,1); L(tb,0,pk,0)
for i,s in enumerate([REL[('handL','x')],REL[('handL','y')],REL[('handL','z')],
                      REL[('handR','x')],REL[('handR','y')],REL[('handR','z')],
                      sp,REL[('head','y')],scale,valid]): L(s,0,pk,i+1)
o=box('outlet',30,830,30,30,None,1,0); L(pk,0,o,0); cmt('to the zone layer',80,835,300)
BODYSUB=finish([80,80,1700,950])

# ============================== mb_zones ==============================
box,obj,cmt,msg,L,finish=newsub()
AE,AX,SE,SX,COMMIT,GRACE=0.15,0.00,1.15,1.00,200,1000
for i,t in enumerate([
 'mb_zones - WHERE THE HANDS ARE.  Consumes the mb_body list; emits which of the nine',
 '(zone x hand-state) combinations is active. No Live objects here - this whole subpatch',
 'is testable on the Mac against the mock body, with no camera and no Ableton.']): cmt(t,20,8+i*20,700)
cmt(f'THRESHOLDS (body lengths):  ABOVE enter head+{AE} leave head+{AX}   SIDE enter {SE} leave {SX}',20,76,700)
cmt(f'TIMING: hand-count commit {COMMIT} ms   fire re-arm after tracking returns {GRACE} ms',20,96,700)
cmt('The head rule: a hand above the head is in ABOVE, whatever its X. Sides are masked by it.',20,116,700)
inl=box('inlet',30,160,30,30,None,0,1); cmt('mb_body list',70,165,200)
up=obj('unpack 0 0. 0. 0. 0. 0. 0. 0. 0. 0. 0.',30,210,430,1,11,['int']+['float']*10); L(inl,0,up,0)
cmt('fires right-to-left: valid, scale, head.y ... then the hands. Order is load-bearing.',480,212,560)
above={}
for h,(oy,x) in (('L',(2,30)),('R',(5,500))):
    e=obj(f'expr $f1 > $f2 + {AE} - $f3 * {AE-AX}',x,280,290,3,1); L(up,oy,e,0); L(up,8,e,1)
    t=obj('t i i',x,315,80,1,2,['int','int']); L(e,0,t,0); L(t,1,e,2); above[h]=t
    cmt(f'hand {h} above the head',x+300,282,260)
side={}
for h,(ox,x) in (('L',(1,30)),('R',(4,500))):
    seq=obj('t f f',x,400,80,1,2,['float','float']); L(up,ox,seq,0)
    for zi,(zn,sgn,so) in enumerate((('right',+1,1),('left',-1,0))):
        e=obj(f'expr ($f1 * {sgn} > {SE} - $f3 * {SE-SX}) * (1 - $f2)',x+zi*300,440,290,3,1)
        L(seq,so,e,0); L(above[h],0,e,1)
        t=obj('t i i',x+zi*300,475,80,1,2,['int','int']); L(e,0,t,0); L(t,1,e,2)
        side[(zn,h)]=t; cmt(f'hand {h} in the {zn} zone',x+zi*300+90,477,200)
resolved={}
for zi,(zn,gL,gR) in enumerate((('above',above['L'],above['R']),
                                ('left',side[('left','L')],side[('left','R')]),
                                ('right',side[('right','L')],side[('right','R')]))):
    y=570+zi*130
    st=obj('expr ($i1 + 2 * $i2) * $i3',30,y,230,3,1); L(gL,0,st,0); L(gR,0,st,1); L(up,10,st,2)
    c1=obj('change',30,y+30,80); L(st,0,c1,0)
    tb2=obj('t b i',30,y+60,80,1,2,['bang','int']); L(c1,0,tb2,0)
    hold=obj('int',150,y+60,60,2,1); L(tb2,1,hold,1)
    dl=obj(f'del {COMMIT}',30,y+90,80,2,1); L(tb2,0,dl,0); L(dl,0,hold,0)
    c2=obj('change',230,y+90,80); L(hold,0,c2,0); resolved[zn]=c2
    cmt(f'{zn.upper()}: 0 none, 1 left, 2 right, 3 both - committed after {COMMIT} ms so that',330,y+62,560)
    cmt('raising both hands never fires the one-hand cell on the way up.',330,y+82,560)
flags=[]
for zi,zn in enumerate(('above','left','right')):
    for v in (1,2,3):
        e=obj(f'== {v}',960+(v-1)*70,570+130*zi,60,2,1); L(resolved[zn],0,e,0); flags.append(e)
pk=obj('pak 0 0 0 0 0 0 0 0 0',30,980,300,9,1)
for i,f in enumerate(flags): L(f,0,pk,i)
cmt('abvL abvR abvBOTH  lftL lftR lftBOTH  rgtL rgtR rgtBOTH   (zl nth 1..9)',350,982,600)
busy=[]
for i,h in enumerate(('L','R')):
    e=obj('expr $i1 + $i2 + $i3',30+i*220,1030,190,3,1)
    L(side[('left',h)],0,e,0); L(side[('right',h)],0,e,1); L(above[h],0,e,2); busy.append(e)
pb=obj('pak 0 0',30,1065,120,2,1)
for i,e in enumerate(busy): L(e,0,pb,i)
cmt("hand busy in a zone -> freeze that hand's slot in the six-slot matrix",170,1067,560)
vch=obj('change',600,1030,80); L(up,10,vch,0)
sel=obj('sel 0 1',600,1065,80,2,3,['bang','bang','']); L(vch,0,sel,0)
gd=obj(f'del {GRACE}',760,1100,80,2,1)
stp=msg('stop',600,1100,60); L(sel,0,stp,0); L(stp,0,gd,0)
m0=msg('0',680,1140,40); L(sel,0,m0,0); L(sel,1,gd,0)
m1=msg('1',760,1140,40); L(gd,0,m1,0)
ach=obj('change',680,1180,80); L(m0,0,ach,0); L(m1,0,ach,0)
cmt(f'walking back into frame through a side zone must not advance the song: {GRACE} ms',850,1067,600)
o0=box('outlet',30,1240,30,30,None,1,0); L(pk,0,o0,0); cmt('nine flags',70,1245,200)
o1=box('outlet',250,1240,30,30,None,1,0); L(pb,0,o1,0); cmt('hand busy L R',290,1245,200)
o2=box('outlet',470,1240,30,30,None,1,0); L(ach,0,o2,0); cmt('fire armed',510,1245,200)
ZONESUB=finish([80,80,1750,1350])

# ============================== insert into ROOT ==============================
nx=[max(int(b['box']['id'].split('-')[1]) for b in root['boxes'])+1]
def rid(): i='obj-%d'%nx[0]; nx[0]+=1; return i
def radd(mc,x,y,w,h,text=None,nin=1,nout=1,ot=None,patcher=None,extra=None):
    i=rid(); root['boxes'].append(OD(box=mkbox(i,mc,nin,nout,[x,y,w,h],text,ot,patcher,extra))); return i
def RL(s,so,d,di): root['lines'].append(OD(patchline=OD(destination=[d,di],source=[s,so])))

BODY=radd('newobj',20,476,160,22,'p mb_body',6,1,[''],BODYSUB)
radd('comment',200,478,560,20,'body-relative coordinates for the zone layer. mb_sources above is unchanged.',1,0)
for src in ('obj-11','obj-13'):
    for o_,i_ in ((1,0),(2,1),(5,2),(7,3),(8,4),(0,5)): RL(src,o_,BODY,i_)
for pak,i_ in (('obj-16',0),('obj-18',1),('obj-24',2),('obj-28',3),('obj-30',4)): RL(pak,0,BODY,i_)
for pak in ('obj-16','obj-18','obj-20','obj-22','obj-24','obj-26','obj-28','obj-30'): RL(pak,0,BODY,5)

Z=radd('newobj',20,516,160,22,'p mb_zones',1,3,['','',''],ZONESUB)
radd('comment',200,518,620,20,'zone state. Nine flags, hand-busy pair, fire-armed. No Live objects - testable against the mock.',1,0)
RL(BODY,0,Z,0)

# the mock had no handleft.y slider: the left hand could never be raised off-camera
s_=radd('slider',1060,330,120,20,None,1,1,[''],extra={'size':200.0,'orientation':1})
sc_=radd('newobj',1060,360,150,22,'scale 0. 199. -1 1.5',6,1)
radd('comment',1060,352,150,20,'handleft.y  (added: the mock could not raise the left hand)',1,0)
RL(s_,0,sc_,0); RL(sc_,0,'obj-16',1)

radd('comment',20,556,700,20,'ZONE MONITOR - drag the mock sliders and watch these. Not the final panel; a way to see it work.',1,0)
u=radd('newobj',20,640,300,22,'unpack 0 0 0 0 0 0 0 0 0',1,9,['int']*9); RL(Z,0,u,0)
for i,nm in enumerate(['abv L','abv R','abv 2','lft L','lft R','lft 2','rgt L','rgt R','rgt 2']):
    x=20+i*56+(i//3)*24
    radd('comment',x,584,54,20,nm,1,0)
    t=radd('toggle',x,604,24,24,None,1,1,['int']); RL(u,i,t,0)
ub=radd('newobj',560,640,120,22,'unpack 0 0',1,2,['int','int']); RL(Z,1,ub,0)
for i,nm in enumerate(['busy L','busy R']):
    x=560+i*60
    radd('comment',x,584,56,20,nm,1,0)
    t=radd('toggle',x,604,24,24,None,1,1,['int']); RL(ub,i,t,0)
radd('comment',700,584,80,20,'fire armed',1,0)
ta=radd('toggle',700,604,24,24,None,1,1,['int']); RL(Z,2,ta,0)

out=json.dumps(doc,indent=4)
io.open(P,'w',encoding='utf-8',newline='').write(out)
print('rebuilt:',len(BODYSUB['boxes']),'in mb_body,',len(ZONESUB['boxes']),'in mb_zones')
