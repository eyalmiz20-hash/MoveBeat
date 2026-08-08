{
    "patcher": {
        "fileversion": 1,
        "appversion": {
            "major": 9,
            "minor": 1,
            "revision": 4,
            "architecture": "x64",
            "modernui": 1
        },
        "classnamespace": "box",
        "rect": [
            41.0,
            87.0,
            908.0,
            952.0
        ],
        "boxes": [
            {
                "box": {
                    "id": "obj-28",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        103.00000154972076,
                        111.03895998001099,
                        28.0,
                        22.0
                    ],
                    "saved_object_attributes": {
                        "attr_comment": "",
                        "c": ""
                    },
                    "text": "in 1"
                }
            },
            {
                "box": {
                    "id": "obj-25",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        498.0,
                        488.0,
                        87.0,
                        22.0
                    ],
                    "text": "clip~ 20 18000"
                }
            },
            {
                "box": {
                    "id": "obj-24",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        420.0,
                        433.0,
                        29.5,
                        22.0
                    ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        311.87403559684753,
                        421.8749839067459,
                        29.5,
                        22.0
                    ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-22",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        372.0,
                        366.66667234897614,
                        60.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-21",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        516.0,
                        373.0,
                        29.5,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-20",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        577.0,
                        290.0,
                        54.0,
                        22.0
                    ],
                    "text": "sig~ 500"
                }
            },
            {
                "box": {
                    "id": "obj-19",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        498.0,
                        290.0,
                        53.0,
                        22.0
                    ],
                    "text": "cycle~ 2"
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "dsp.gen",
                        "rect": [
                            134.0,
                            87.0,
                            1526.0,
                            959.0
                        ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        561.0,
                                        66.0,
                                        28.0,
                                        22.0
                                    ],
                                    "text": "in 2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        230.0,
                                        72.0,
                                        28.0,
                                        22.0
                                    ],
                                    "text": "in 1"
                                }
                            },
                            {
                                "box": {
                                    "code": "/* ============================================================\n   MoveBeat Synth  —  Audio Core  (oscillators -> drive -> filter)\n   ------------------------------------------------------------\n   gen~ codebox. This is the complete per-voice audio engine:\n   two anti-aliased oscillators + a sub oscillator, mixed, driven,\n   and fed through the Moog ladder filter (same DSP as\n   moog_ladder.genexpr). Amp/filter envelopes, LFO, glide and\n   voice allocation are done around this in RNBO (see build guide).\n\n   Anti-aliasing: saw and square use polyBLEP band-limiting, so the\n   synth stays clean up high instead of aliasing like a naive\n   digital oscillator. This is what makes it sound like an analog\n   synth rather than a buzzy digital one.\n\n   ---- SIGNAL inlet ----\n     in1 = pitch, in Hz  (already glide-smoothed outside; e.g. mtof)\n     in2 = filter cutoff modulation, in Hz (from filter-envelope+LFO,\n           already summed outside). If not patched, `cutoff` Param is used.\n\n   ---- control PARAMS (surface automatically in RNBO / [gen~]) ----\n   set from Max with messages like:  osc1wave 0 ,  detune 7. , etc.\n   ============================================================ */\n\n// ---------- oscillator params ----------\nParam osc1wave(0.);      // 0 saw | 1 square | 2 triangle | 3 sine\nParam osc2wave(0.);      // 0 saw | 1 square | 2 triangle | 3 sine\nParam osc1level(0.8);    // 0..1\nParam osc2level(0.6);    // 0..1\nParam sublevel(0.4);     // 0..1  (square, one octave below osc1)\nParam detune(0.);        // osc2 detune in semitones (-24..+24)\nParam pw(0.5);           // pulse width for square waves (0.05..0.95)\n\n// ---------- filter params (mirror of moog_ladder) ----------\nParam cutoff(1200., min=20, max=18000);  // used if in2 is 0/unpatched\nParam resonance(0.6, min=0, max=4);\nParam drive(0., min=0, max=1);\nParam rescomp(0., min=0, max=1);          // resonance make-up gain\n\n// ---------- output ----------\nParam outgain(0.5, min=0, max=1);\n\n// ---------- ALL state declared up front (gen~ requires this) ----------\nHistory p1(0.), p2(0.), psub(0.);            // three oscillator phase accumulators [0,1)\nHistory s1(0.), s2(0.), s3(0.), s4(0.), y4z(0.);  // filter states + feedback tap\n\n// ============================================================\n//  OSCILLATORS\n// ============================================================\n\nf1  = clamp(in1, 0.001, 18000.);        // osc1 frequency\nf2  = f1 * pow(2., detune / 12.);       // osc2 detuned\nfs2 = f1 * 0.5;                         // sub = one octave down\n\ndt1 = f1  / samplerate;                 // phase increments\ndt2 = f2  / samplerate;\ndts = fs2 / samplerate;\n\n// advance + wrap phases\np1   = p1   + dt1;   p1   = p1   - floor(p1);\np2   = p2   + dt2;   p2   = p2   - floor(p2);\npsub = psub + dts;   psub = psub - floor(psub);\n\n// ---- osc1 ----\n// naive shapes\nsaw1 = 2. * p1 - 1.;\n// polyBLEP correction for saw at the 0/1 discontinuity\nbl = 0.;\nif (p1 < dt1)        { tt = p1 / dt1;        bl = tt + tt - tt*tt - 1.; }\nelse if (p1 > 1.-dt1){ tt = (p1 - 1.) / dt1; bl = tt*tt + tt + tt + 1.; }\nsaw1 = saw1 - bl;\n// square from two blep edges (rising at 0, falling at pw)\nsq1 = (p1 < pw) ? 1. : -1.;\nbl = 0.;\nif (p1 < dt1)        { tt = p1 / dt1;        bl = tt + tt - tt*tt - 1.; }\nelse if (p1 > 1.-dt1){ tt = (p1 - 1.) / dt1; bl = tt*tt + tt + tt + 1.; }\nsq1 = sq1 + bl;\npp = p1 - pw; pp = pp - floor(pp);      // phase relative to the falling edge\nbl = 0.;\nif (pp < dt1)        { tt = pp / dt1;        bl = tt + tt - tt*tt - 1.; }\nelse if (pp > 1.-dt1){ tt = (pp - 1.) / dt1; bl = tt*tt + tt + tt + 1.; }\nsq1 = sq1 - bl;\ntri1 = 4. * abs(p1 - 0.5) - 1.;         // naive triangle (low aliasing)\nsin1 = sin(2. * PI * p1);\n// select osc1 waveform\no1 = (osc1wave < 0.5) ? saw1 : (osc1wave < 1.5) ? sq1 : (osc1wave < 2.5) ? tri1 : sin1;\n\n// ---- osc2 ----\nsaw2 = 2. * p2 - 1.;\nbl = 0.;\nif (p2 < dt2)        { tt = p2 / dt2;        bl = tt + tt - tt*tt - 1.; }\nelse if (p2 > 1.-dt2){ tt = (p2 - 1.) / dt2; bl = tt*tt + tt + tt + 1.; }\nsaw2 = saw2 - bl;\nsq2 = (p2 < pw) ? 1. : -1.;\nbl = 0.;\nif (p2 < dt2)        { tt = p2 / dt2;        bl = tt + tt - tt*tt - 1.; }\nelse if (p2 > 1.-dt2){ tt = (p2 - 1.) / dt2; bl = tt*tt + tt + tt + 1.; }\nsq2 = sq2 + bl;\npp = p2 - pw; pp = pp - floor(pp);\nbl = 0.;\nif (pp < dt2)        { tt = pp / dt2;        bl = tt + tt - tt*tt - 1.; }\nelse if (pp > 1.-dt2){ tt = (pp - 1.) / dt2; bl = tt*tt + tt + tt + 1.; }\nsq2 = sq2 - bl;\ntri2 = 4. * abs(p2 - 0.5) - 1.;\nsin2 = sin(2. * PI * p2);\no2 = (osc2wave < 0.5) ? saw2 : (osc2wave < 1.5) ? sq2 : (osc2wave < 2.5) ? tri2 : sin2;\n\n// ---- sub oscillator (square, one octave down) ----\nsub = (psub < 0.5) ? 1. : -1.;\nbl = 0.;\nif (psub < dts)        { tt = psub / dts;        bl = tt + tt - tt*tt - 1.; }\nelse if (psub > 1.-dts){ tt = (psub - 1.) / dts; bl = tt*tt + tt + tt + 1.; }\nsub = sub + bl;\npp = psub - 0.5; pp = pp - floor(pp);\nbl = 0.;\nif (pp < dts)        { tt = pp / dts;        bl = tt + tt - tt*tt - 1.; }\nelse if (pp > 1.-dts){ tt = (pp - 1.) / dts; bl = tt*tt + tt + tt + 1.; }\nsub = sub - bl;\n\n// ---- oscillator mix ----\nmix = o1 * osc1level + o2 * osc2level + sub * sublevel;\nmix = mix * 0.5;   // headroom before the filter\n\n// ============================================================\n//  MOOG LADDER FILTER  (identical DSP to moog_ladder.genexpr)\n//  (states s1..s4, y4z are declared at the top of the file)\n// ============================================================\n// cutoff: use the summed modulation signal on in2 if patched, else Param\nfcin = (in2 > 0.) ? in2 : cutoff;\nFc   = clamp(fcin, 20., 18000.);\nk    = clamp(resonance, 0., 4.);\ndr   = clamp(drive, 0., 1.);\ncmp  = clamp(rescomp, 0., 1.);\n\nwc = tan(PI * Fc / samplerate);\nG  = wc / (1. + wc);\n\nx  = mix * (1. + 3. * dr);\nmkg = 1. + cmp * k * 0.5;\nU  = tanh(x * mkg - k * y4z);\n\nv1 = (U  - s1) * G;   yy1 = v1 + s1;   s1 = yy1 + v1;\nv2 = (yy1 - s2) * G;  yy2 = v2 + s2;   s2 = yy2 + v2;\nv3 = (yy2 - s3) * G;  yy3 = v3 + s3;   s3 = yy3 + v3;\nv4 = (yy3 - s4) * G;  yy4 = v4 + s4;   s4 = yy4 + v4;\ny4z = yy4;\n\nout1 = yy4 * outgain;\n",
                                    "fontface": 0,
                                    "fontname": "<Monospaced>",
                                    "fontsize": 12.0,
                                    "id": "obj-5",
                                    "maxclass": "codebox",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        204.0,
                                        166.0,
                                        987.0,
                                        667.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        204.0,
                                        860.0,
                                        40.0,
                                        22.0
                                    ],
                                    "text": "out 1"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-5",
                                        0
                                    ],
                                    "source": [
                                        "obj-6",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-5",
                                        1
                                    ],
                                    "source": [
                                        "obj-7",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-8",
                                        0
                                    ],
                                    "source": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [
                        96.75000154972076,
                        366.66667234897614,
                        36.0,
                        22.0
                    ],
                    "text": "gen~"
                }
            },
            {
                "box": {
                    "id": "obj-18",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        408.0,
                        290.0,
                        61.0,
                        22.0
                    ],
                    "text": "sig~ 2000"
                }
            },
            {
                "box": {
                    "id": "obj-15",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        296.12403559684753,
                        366.66667234897614,
                        29.5,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "newobj",
                    "numinlets": 5,
                    "numoutlets": 4,
                    "outlettype": [
                        "signal",
                        "signal",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        311.87403559684753,
                        289.9224851131439,
                        122.0,
                        22.0
                    ],
                    "text": "adsr~ 5 200 0.5 300"
                }
            },
            {
                "box": {
                    "id": "obj-12",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        100.00000154972076,
                        421.8749839067459,
                        29.5,
                        22.0
                    ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-11",
                    "maxclass": "newobj",
                    "numinlets": 5,
                    "numoutlets": 4,
                    "outlettype": [
                        "signal",
                        "signal",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        155.81395590305328,
                        289.9224851131439,
                        122.0,
                        22.0
                    ],
                    "text": "adsr~ 10 200 0.8 400"
                }
            },
            {
                "box": {
                    "id": "obj-10",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "float"
                    ],
                    "patching_rect": [
                        155.81395590305328,
                        224.03101122379303,
                        40.0,
                        22.0
                    ],
                    "text": "/ 127."
                }
            },
            {
                "box": {
                    "id": "obj-9",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        100.00000154972076,
                        289.9224851131439,
                        39.0,
                        22.0
                    ],
                    "text": "mtof~"
                }
            },
            {
                "box": {
                    "id": "obj-8",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "signal",
                        "bang"
                    ],
                    "patching_rect": [
                        100.00000154972076,
                        224.03101122379303,
                        34.0,
                        22.0
                    ],
                    "text": "line~"
                }
            },
            {
                "box": {
                    "id": "obj-42",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 15,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        155.81395590305328,
                        168.2170568704605,
                        700.0,
                        22.0
                    ],
                    "text": "route velocity cutoff lfoRate lfoDepth filtEnvAmt glide ampA ampD ampS ampR filtA filtD filtS filtR"
                }
            },
            {
                "box": {
                    "id": "obj-6",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        98.50000154972076,
                        487.5969067811966,
                        42.0,
                        22.0
                    ],
                    "text": "out~ 1"
                }
            },
            {
                "box": {
                    "id": "obj-5",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "int",
                        "int"
                    ],
                    "patching_rect": [
                        195.34884023666382,
                        366.66667234897614,
                        56.0,
                        22.0
                    ],
                    "text": "thispoly~"
                }
            },
            {
                "box": {
                    "id": "obj-3",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        727.9069880247116,
                        116.27907156944275,
                        28.0,
                        22.0
                    ],
                    "text": "in 2"
                }
            },
            {
                "box": {
                    "id": "obj-43",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        372.0,
                        332.66667234897614,
                        76.0,
                        22.0
                    ],
                    "text": "pack 0. 25"
                }
            },
            {
                "box": {
                    "id": "obj-44",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "bang"
                    ],
                    "patching_rect": [
                        522.0,
                        288.66667234897614,
                        62.0,
                        22.0
                    ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-45",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        522.0,
                        320.66667234897614,
                        40.0,
                        22.0
                    ],
                    "text": "800"
                }
            },
            {
                "box": {
                    "id": "obj-46",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        572.0,
                        354.66667234897614,
                        400.0,
                        20.0
                    ],
                    "text": "cutoff Hz ramped over 25 ms — kills the 30 Hz control stepping"
                }
            },
            {
                "box": {
                    "id": "obj-47",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        100.00000154972076,
                        192.03101122379303,
                        72.0,
                        22.0
                    ],
                    "text": "pack 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-48",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        190.00000154972076,
                        194.03101122379303,
                        240.0,
                        20.0
                    ],
                    "text": "note + glide ms -> portamento"
                }
            },
            {
                "box": {
                    "id": "obj-49",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        8.0,
                        700.0,
                        60.0
                    ],
                    "text": "MoveBeat voice — one poly~ instance. Loaded by [poly~ mb_voice 8] in MoveBeatSynth.maxpat. Identical to the frozen build/movebeat_voice.maxpat except: wider [route], line~ cutoff smoothing, and working glide.",
                    "linecount": 3
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [
                        "obj-11",
                        0
                    ],
                    "midpoints": [
                        165.31395590305328,
                        276.0,
                        165.31395590305328,
                        276.0
                    ],
                    "order": 1,
                    "source": [
                        "obj-10",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-13",
                        0
                    ],
                    "midpoints": [
                        165.31395590305328,
                        276.0,
                        321.37403559684753,
                        276.0
                    ],
                    "order": 0,
                    "source": [
                        "obj-10",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-12",
                        1
                    ],
                    "midpoints": [
                        165.31395590305328,
                        351.0,
                        147.0,
                        351.0,
                        147.0,
                        397.5451781717129,
                        120.00000154972076,
                        397.5451781717129
                    ],
                    "order": 1,
                    "source": [
                        "obj-11",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-5",
                        0
                    ],
                    "midpoints": [
                        165.31395590305328,
                        351.0,
                        204.84884023666382,
                        351.0
                    ],
                    "order": 0,
                    "source": [
                        "obj-11",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-6",
                        0
                    ],
                    "midpoints": [
                        109.50000154972076,
                        451.5221648379229,
                        108.00000154972076,
                        451.5221648379229
                    ],
                    "source": [
                        "obj-12",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-15",
                        0
                    ],
                    "midpoints": [
                        321.37403559684753,
                        351.0,
                        305.62403559684753,
                        351.0
                    ],
                    "source": [
                        "obj-13",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-12",
                        0
                    ],
                    "midpoints": [
                        106.25000154972076,
                        393.55486840428784,
                        109.50000154972076,
                        393.55486840428784
                    ],
                    "source": [
                        "obj-14",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-23",
                        1
                    ],
                    "midpoints": [
                        305.62403559684753,
                        398.39752873498946,
                        331.87403559684753,
                        398.39752873498946
                    ],
                    "source": [
                        "obj-15",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-15",
                        1
                    ],
                    "midpoints": [
                        417.5,
                        351.0,
                        316.12403559684753,
                        351.0
                    ],
                    "source": [
                        "obj-18",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        0
                    ],
                    "midpoints": [
                        507.5,
                        351.4030932188034,
                        525.5,
                        351.4030932188034
                    ],
                    "source": [
                        "obj-19",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-21",
                        1
                    ],
                    "midpoints": [
                        586.5,
                        351.4030932188034,
                        536.0,
                        351.4030932188034
                    ],
                    "source": [
                        "obj-20",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-24",
                        1
                    ],
                    "midpoints": [
                        525.5,
                        423.4030932188034,
                        440.0,
                        423.4030932188034
                    ],
                    "source": [
                        "obj-21",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-23",
                        0
                    ],
                    "midpoints": [
                        381.5,
                        414.82670161360875,
                        321.37403559684753,
                        414.82670161360875
                    ],
                    "source": [
                        "obj-22",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-24",
                        0
                    ],
                    "midpoints": [
                        321.37403559684753,
                        449.37109375,
                        365.5390625,
                        449.37109375,
                        365.5390625,
                        435.0,
                        429.5,
                        435.0
                    ],
                    "source": [
                        "obj-23",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-25",
                        0
                    ],
                    "source": [
                        "obj-24",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-14",
                        1
                    ],
                    "midpoints": [
                        507.5,
                        518.6847139564343,
                        163.46208834042773,
                        518.6847139564343,
                        163.46208834042773,
                        358.70300297252834,
                        123.25000154972076,
                        358.70300297252834
                    ],
                    "source": [
                        "obj-25",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-42",
                        0
                    ],
                    "source": [
                        "obj-3",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-10",
                        0
                    ],
                    "source": [
                        "obj-42",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-19",
                        0
                    ],
                    "source": [
                        "obj-42",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-20",
                        0
                    ],
                    "source": [
                        "obj-42",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-18",
                        0
                    ],
                    "source": [
                        "obj-42",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-9",
                        0
                    ],
                    "midpoints": [
                        109.50000154972076,
                        249.0,
                        109.50000154972076,
                        249.0
                    ],
                    "source": [
                        "obj-8",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-14",
                        0
                    ],
                    "midpoints": [
                        109.50000154972076,
                        312.0,
                        106.25000154972076,
                        312.0
                    ],
                    "source": [
                        "obj-9",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-14",
                        0
                    ],
                    "source": [
                        "obj-42",
                        14
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-43",
                        0
                    ],
                    "source": [
                        "obj-42",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-43",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-45",
                        0
                    ],
                    "source": [
                        "obj-44",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-22",
                        0
                    ],
                    "source": [
                        "obj-45",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-47",
                        0
                    ],
                    "source": [
                        "obj-28",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-8",
                        0
                    ],
                    "source": [
                        "obj-47",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-11",
                        1
                    ],
                    "source": [
                        "obj-42",
                        6
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-11",
                        2
                    ],
                    "source": [
                        "obj-42",
                        7
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-11",
                        3
                    ],
                    "source": [
                        "obj-42",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-11",
                        4
                    ],
                    "source": [
                        "obj-42",
                        9
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-13",
                        1
                    ],
                    "source": [
                        "obj-42",
                        10
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-13",
                        2
                    ],
                    "source": [
                        "obj-42",
                        11
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-13",
                        3
                    ],
                    "source": [
                        "obj-42",
                        12
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-13",
                        4
                    ],
                    "source": [
                        "obj-42",
                        13
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-47",
                        1
                    ],
                    "source": [
                        "obj-42",
                        5
                    ]
                }
            }
        ],
        "autosave": 0
    }
}
