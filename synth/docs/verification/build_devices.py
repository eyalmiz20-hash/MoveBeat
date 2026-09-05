#!/usr/bin/env python3
"""build_devices.py - generate the two Max for Live devices from the .maxpat sources.

The .maxpat files stay the source of truth.  verify_body.py, verify_zones.py and
build_zone_layer.py all read them, and that harness is what catches mis-wiring - so the
devices are DERIVED from the patches rather than replacing them.  Change a patch, re-run
this, and the devices follow.  Edit a device inside Live and save, and it silently forks:
that is exactly how synth/build/MoveBeat_ableton_ves.amxd became a divergent copy.

    Structural edits go in the .maxpat.  Ableton is for playing.

Run from anywhere:  python3 synth/docs/verification/build_devices.py

---------------------------------------------------------------------------------------
The .amxd container, decoded from Ableton's own devices (110 of them checked):

    "ampf" <u32 4> <4-byte device type>     iiii instrument · mmmm MIDI effect
    "meta" <u32 4> <u32 flags>              aaaa audio effect · nagg/natt Live 12 MIDI
    "ptch" <u32 len> <maxpat JSON> "\\n\\0"

Nothing is encrypted or checksummed, so a device is just a .maxpat in a 32-byte wrapper.
Every object signature and every patcher key below was read out of Live's own
"Max Instrument.amxd" / "Max MIDI Effect.amxd" templates rather than guessed.
"""

import collections
import json
import os
import shutil
import struct
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..', '..', '..'))

SYNTH_SRC = os.path.join(ROOT, 'synth', 'instrument', 'MoveBeatSynth.maxpat')
VOICE_SRC = os.path.join(ROOT, 'synth', 'instrument', 'mb_voice.maxpat')
CTRL_SRC = os.path.join(ROOT, 'synth', 'controller', 'MoveBeatController.maxpat')
SYNTH_OUT = os.path.join(ROOT, 'synth', 'instrument', 'MoveBeatSynth.amxd')
CTRL_OUT = os.path.join(ROOT, 'synth', 'controller', 'MoveBeatController.amxd')

# poly~ resolves its voice patcher through Max's search path, and ~/Documents/Max 9/Library
# is always on it.  Ableton's own devices do the same - not one of the 110 embeds a patcher
# in project.contents.patchers - so this is the normal mechanism, not a workaround.
MAX_LIBRARY = os.path.expanduser('~/Documents/Max 9/Library')

AMXD_TYPE = {'instrument': b'iiii', 'midi_effect': b'mmmm', 'audio_effect': b'aaaa'}

# A fixed timestamp keeps rebuilds byte-identical, so git only sees real changes.
STAMP = 3590052838


def load(path):
    with open(path) as f:
        return json.load(f, object_pairs_hook=collections.OrderedDict)


def obj(oid, text, maxclass='newobj', **kw):
    b = collections.OrderedDict()
    b['id'] = oid
    b['maxclass'] = maxclass
    b['numinlets'] = kw.pop('numinlets', 1)
    b['numoutlets'] = kw.pop('numoutlets', 0)
    b['patching_rect'] = kw.pop('rect', [0.0, 0.0, 80.0, 22.0])
    if text is not None:
        b['text'] = text
    for k, v in kw.items():
        b[k] = v
    return collections.OrderedDict([('box', b)])


def line(src, so, dst, di):
    return collections.OrderedDict([
        ('patchline', collections.OrderedDict([
            ('destination', [dst, di]), ('source', [src, so])]))])


def next_id(patcher):
    n = max(int(e['box']['id'].split('-')[1]) for e in patcher['boxes'])
    while True:
        n += 1
        yield 'obj-%d' % n


def find(patcher, text):
    for e in patcher['boxes']:
        if (e['box'].get('text') or '').strip() == text:
            return e['box']
    return None


def drop_lines(patcher, pred):
    before = len(patcher['lines'])
    patcher['lines'] = [e for e in patcher['lines'] if not pred(e['patchline'])]
    return before - len(patcher['lines'])


# --------------------------------------------------------------------------------------
# the Max for Live patcher keys, copied verbatim out of Live's blank templates
# --------------------------------------------------------------------------------------

def m4l_project(devtype):
    return collections.OrderedDict([
        ('version', 1), ('creationdate', STAMP), ('modificationdate', STAMP),
        ('viewrect', [0.0, 0.0, 300.0, 500.0]), ('autoorganize', 1),
        ('hideprojectwindow', 1), ('showdependencies', 1), ('autolocalize', 0),
        ('contents', collections.OrderedDict([('patchers', collections.OrderedDict())])),
        ('layout', collections.OrderedDict()),
        ('searchpath', collections.OrderedDict()),
        ('detailsvisible', 0),
        ('amxdtype', struct.unpack('<I', AMXD_TYPE[devtype])[0]),
        ('readonly', 0), ('devpathtype', 0), ('devpath', '.'),
        ('sortmode', 0), ('viewmode', 0), ('includepackages', 0)])


M4L_KEYS = [
    ('openrect', [0.0, 0.0, 0.0, 169.0]), ('bglocked', 0), ('openinpresentation', 0),
    ('default_fontsize', 10.0), ('default_fontface', 0), ('default_fontname', 'Arial Bold'),
    ('gridonopen', 1), ('gridsize', [8.0, 8.0]), ('gridsnaponopen', 1),
    ('objectsnaponopen', 1), ('statusbarvisible', 2), ('toolbarvisible', 1),
    ('lefttoolbarpinned', 0), ('toptoolbarpinned', 0), ('righttoolbarpinned', 0),
    ('bottomtoolbarpinned', 0), ('toolbars_unpinned_last_save', 0), ('tallnewobj', 0),
    ('boxanimatetime', 500), ('enablehscroll', 1), ('enablevscroll', 1),
    ('devicewidth', 0.0), ('description', ''), ('digest', ''), ('tags', ''),
    ('style', ''), ('subpatcher_template', ''), ('dependency_cache', []), ('latency', 0),
]


def make_device_patcher(patcher, devtype, title):
    """Add every key Live needs, without disturbing the ones the patch already has."""
    for k, v in M4L_KEYS:
        patcher.setdefault(k, v)
    patcher['title'] = title
    patcher['project'] = m4l_project(devtype)
    patcher.setdefault('autosave', 0)
    return patcher


def write_amxd(path, doc, devtype):
    payload = json.dumps(doc, indent=4).encode('utf-8') + b'\n\x00'
    blob = b'ampf' + struct.pack('<I', 4) + AMXD_TYPE[devtype]
    blob += b'meta' + struct.pack('<I', 4) + struct.pack('<I', 0)
    blob += b'ptch' + struct.pack('<I', len(payload)) + payload
    with open(path, 'wb') as f:
        f.write(blob)
    return blob


# --------------------------------------------------------------------------------------
# the synth: notein -> midiin|midiparse|unpack,  ezdac~ -> plugout~
# --------------------------------------------------------------------------------------

def build_synth():
    doc = load(SYNTH_SRC)
    p = doc['patcher']
    ids = next_id(p)
    notes = []

    notein = find(p, 'notein')
    if notein is None:
        sys.exit('MoveBeatSynth.maxpat: no [notein] found - has it already been converted?')
    nid = notein['id']
    # Where notein's pitch/velocity landed.  Keep those destinations exactly.
    dests = {}
    for e in p['lines']:
        l = e['patchline']
        if l['source'][0] == nid:
            dests[l['source'][1]] = tuple(l['destination'])
    if 0 not in dests or 1 not in dests:
        sys.exit('MoveBeatSynth.maxpat: [notein] is not wired as pitch+velocity')
    drop_lines(p, lambda l: l['source'][0] == nid)

    x, y, w, _ = notein['patching_rect']
    notein['text'] = 'midiin'
    notein['numinlets'] = 1
    notein['numoutlets'] = 1
    notein['outlettype'] = ['int']

    parse_id, unp_id = next(ids), next(ids)
    p['boxes'].append(obj(parse_id, 'midiparse', numinlets=1, numoutlets=7,
                          rect=[x, y + 32.0, 100.0, 22.0],
                          outlettype=['', '', '', 'int', 'int', 'int', 'int']))
    p['boxes'].append(obj(unp_id, 'unpack 0 0', numinlets=1, numoutlets=2,
                          rect=[x, y + 64.0, 80.0, 22.0], outlettype=['int', 'int']))
    p['lines'].append(line(nid, 0, parse_id, 0))
    p['lines'].append(line(parse_id, 0, unp_id, 0))
    # unpack fires right-to-left, so velocity is stored before pitch triggers [pack] -
    # the same order notein produced.
    p['lines'].append(line(unp_id, 0, dests[0][0], dests[0][1]))
    p['lines'].append(line(unp_id, 1, dests[1][0], dests[1][1]))
    notes.append('notein -> [midiin]->[midiparse]->[unpack 0 0]  (Live sends the track\'s '
                 'MIDI to midiin, not to notein)')

    ez = None
    for e in p['boxes']:
        if e['box'].get('maxclass') == 'ezdac~':
            ez = e['box']
            break
    if ez is None:
        sys.exit('MoveBeatSynth.maxpat: no [ezdac~] found')
    ez['maxclass'] = 'newobj'
    ez['text'] = 'plugout~'
    ez['numinlets'] = 2
    ez['numoutlets'] = 2
    ez['outlettype'] = ['signal', 'signal']
    r = ez['patching_rect']
    ez['patching_rect'] = [r[0], r[1], 90.0, 22.0]
    notes.append('ezdac~ -> [plugout~]  (audio leaves a device through plugout~; no '
                 '"start" message needed, Live drives it)')

    make_device_patcher(p, 'instrument', 'MoveBeatSynth')
    return doc, notes


# --------------------------------------------------------------------------------------
# the controller: add the MIDI passthrough a MIDI-effect device must have
# --------------------------------------------------------------------------------------

def build_controller():
    doc = load(CTRL_SRC)
    p = doc['patcher']
    ids = next_id(p)
    notes = []

    if find(p, 'midiin') is None:
        mi, mo = next(ids), next(ids)
        p['boxes'].append(obj(mi, 'midiin', numinlets=1, numoutlets=1,
                              rect=[1300.0, 8.0, 60.0, 22.0], outlettype=['int']))
        p['boxes'].append(obj(mo, 'midiout', numinlets=1, numoutlets=0,
                              rect=[1300.0, 48.0, 60.0, 22.0]))
        p['boxes'].append(obj(next(ids),
                              'MIDI passthrough. Without it this device BLOCKS the '
                              'track\'s MIDI.',
                              maxclass='comment', numinlets=1, numoutlets=0,
                              rect=[1370.0, 50.0, 320.0, 20.0]))
        p['lines'].append(line(mi, 0, mo, 0))
        notes.append('added [midiin]->[midiout]  (a MIDI-effect device that does not pass '
                     'MIDI silently kills the track)')

    make_device_patcher(p, 'midi_effect', 'MoveBeatController')
    return doc, notes


# --------------------------------------------------------------------------------------

def link_voice():
    """Put mb_voice.maxpat on Max's search path as a SYMLINK, never a copy.

    poly~ resolves its voice patcher by name through the search path, and
    ~/Documents/Max 9/Library is always on it.  Ableton's own devices rely on the same
    mechanism - not one of the 110 stock devices embeds a patcher in
    project.contents.patchers - so this is normal, not a workaround.

    A symlink rather than a copy because a second copy of a patcher is exactly how
    synth/build/MoveBeat_ableton_ves.amxd drifted into a fork.  One file, two paths,
    nothing to keep in sync.  The cost is that the link points into this repo, so moving
    the repo breaks it - re-run this script and it is rebuilt.
    """
    dst = os.path.join(MAX_LIBRARY, 'mb_voice.maxpat')
    if not os.path.isdir(MAX_LIBRARY):
        print('!! %s not found - [poly~ mb_voice 8] will not resolve.' % MAX_LIBRARY)
        return
    if os.path.islink(dst):
        if os.path.realpath(dst) == os.path.realpath(VOICE_SRC):
            print('voice patcher: symlink already correct')
            print('   %s -> %s' % (dst, os.path.relpath(VOICE_SRC, ROOT)))
            return
        os.unlink(dst)
    elif os.path.exists(dst):
        # A real file here is either an older copy of ours or the user's own. Keep it,
        # renamed, rather than deleting something we did not write.
        backup = dst + '.replaced-by-symlink'
        shutil.move(dst, backup)
        print('voice patcher: found a real file on the search path, moved it to')
        print('   %s' % backup)
    os.symlink(os.path.abspath(VOICE_SRC), dst)
    print('voice patcher: symlinked onto Max\'s search path')
    print('   %s -> %s' % (dst, os.path.relpath(VOICE_SRC, ROOT)))
    print('   (this is how [poly~ mb_voice 8] resolves inside a device)')


def verify(path, devtype, src_patcher):
    """Read the file back the way Live will and prove it survived the round trip."""
    raw = open(path, 'rb').read()
    assert raw[:4] == b'ampf', 'bad magic'
    assert raw[8:12] == AMXD_TYPE[devtype], 'wrong device type tag'
    assert raw[12:16] == b'meta' and raw[24:28] == b'ptch', 'bad chunk layout'
    ln = struct.unpack('<I', raw[28:32])[0]
    assert 32 + ln == len(raw), 'ptch length %d does not match file size %d' % (ln, len(raw))
    doc, end = json.JSONDecoder().raw_decode(raw[32:].decode('utf-8'))
    assert raw[32 + end:] == b'\n\x00', 'bad JSON terminator'
    back = doc['patcher']
    assert len(back['boxes']) == len(src_patcher['boxes']), 'box count changed'
    assert len(back['lines']) == len(src_patcher['lines']), 'line count changed'
    ok = struct.unpack('<I', AMXD_TYPE[devtype])[0]
    assert back['project']['amxdtype'] == ok, 'amxdtype does not match the header tag'
    return len(raw), len(back['boxes']), len(back['lines'])


def io_order_ok(patcher):
    """The inlet/outlet-by-X trap: re-check every subpatcher after touching the file."""
    bad = []

    def walk(p, path):
        for kind in ('inlet', 'outlet'):
            items = [e['box'] for e in p.get('boxes', []) if e['box'].get('maxclass') == kind]
            for pos, it in enumerate(sorted(items, key=lambda z: z['patching_rect'][0])):
                if it.get('index') is not None and it['index'] != pos + 1:
                    bad.append('%s %s %s' % (path, kind, it['id']))
        for e in p.get('boxes', []):
            if 'patcher' in e['box']:
                walk(e['box']['patcher'], path + '/' + str(e['box'].get('text')))
    walk(patcher, 'root')
    return bad


def main():
    print('MoveBeat -> Max for Live\n' + '=' * 70)

    link_voice()

    for label, builder, out, devtype in (
            ('MoveBeatSynth.amxd    (Max Instrument)', build_synth, SYNTH_OUT, 'instrument'),
            ('MoveBeatController.amxd (MIDI Effect)', build_controller, CTRL_OUT, 'midi_effect')):
        doc, notes = builder()
        write_amxd(out, doc, devtype)
        size, nb, nl = verify(out, devtype, doc['patcher'])
        bad = io_order_ok(doc['patcher'])
        print('\n%s' % label)
        for n in notes:
            print('   * %s' % n)
        print('   %s' % os.path.relpath(out, ROOT))
        print('   %d bytes, %d boxes, %d patchlines, type %s'
              % (size, nb, nl, AMXD_TYPE[devtype].decode()))
        print('   inlet/outlet X-order: %s'
              % ('OK' if not bad else 'BROKEN -> %s' % bad))

    print('\n' + '=' * 70)
    print('Both devices verified structurally. What that does NOT prove: that Live loads')
    print('them, that poly~ finds the voice, or that any sound comes out. Smoke-test in')
    print('Live next - see the note printed by --help.')


if __name__ == '__main__':
    if '--help' in sys.argv or '-h' in sys.argv:
        print(__doc__)
    else:
        main()
