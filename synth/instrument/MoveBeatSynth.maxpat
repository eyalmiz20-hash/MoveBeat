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
            301.0,
            114.0,
            1267.0,
            661.0
        ],
        "openinpresentation": 1,
        "boxes": [
            {
                "box": {
                    "fontsize": 18.0,
                    "id": "obj-1",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        8.0,
                        400.0,
                        27.0
                    ],
                    "text": "MoveBeat \u2014 SYNTH DEVICE"
                }
            },
            {
                "box": {
                    "id": "obj-2",
                    "linecount": 3,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        34.0,
                        820.0,
                        47.0
                    ],
                    "text": "A complete standalone instrument. Plays from MIDI or the on-screen keyboard; no camera, no Kinect, no Windows-only objects \u2014 runs on macOS by itself. Movement control is optional and arrives as normalised OSC on port 7500 from MoveBeatController.maxpat. See synth/docs/MAPPING.md for the protocol."
                }
            },
            {
                "box": {
                    "id": "obj-3",
                    "maxclass": "kslider",
                    "mode": 2,
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [
                        "int",
                        "int"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        20.0,
                        96.0,
                        336.0,
                        53.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-4",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "int",
                        "int"
                    ],
                    "patching_rect": [
                        380.0,
                        96.0,
                        55.0,
                        22.0
                    ],
                    "text": "notein"
                }
            },
            {
                "box": {
                    "id": "obj-5",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        168.0,
                        68.0,
                        22.0
                    ],
                    "text": "pack 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-6",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "int",
                        "int"
                    ],
                    "patching_rect": [
                        20.0,
                        200.0,
                        66.0,
                        22.0
                    ],
                    "text": "poly 8 1"
                }
            },
            {
                "box": {
                    "id": "obj-7",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        232.0,
                        80.0,
                        22.0
                    ],
                    "text": "pack 0 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-8",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 4,
                    "outlettype": [
                        "bang",
                        "",
                        "",
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        264.0,
                        70.0,
                        22.0
                    ],
                    "text": "t b l l l"
                }
            },
            {
                "box": {
                    "id": "obj-9",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "int",
                        "int"
                    ],
                    "patching_rect": [
                        20.0,
                        300.0,
                        86.0,
                        22.0
                    ],
                    "text": "unpack 0 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-10",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "int",
                        "int"
                    ],
                    "patching_rect": [
                        120.0,
                        300.0,
                        86.0,
                        22.0
                    ],
                    "text": "unpack 0 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-11",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "int",
                        "int",
                        "int"
                    ],
                    "patching_rect": [
                        220.0,
                        300.0,
                        86.0,
                        22.0
                    ],
                    "text": "unpack 0 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-12",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        336.0,
                        100.0,
                        22.0
                    ],
                    "text": "prepend target"
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        220.0,
                        336.0,
                        108.0,
                        22.0
                    ],
                    "text": "prepend velocity"
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        340.0,
                        300.0,
                        60.0,
                        22.0
                    ],
                    "text": "target 0"
                }
            },
            {
                "box": {
                    "id": "obj-15",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "bang"
                    ],
                    "patching_rect": [
                        420.0,
                        232.0,
                        62.0,
                        22.0
                    ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-16",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "bang",
                        "bang"
                    ],
                    "patching_rect": [
                        420.0,
                        264.0,
                        50.0,
                        22.0
                    ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-17",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "signal"
                    ],
                    "patching_rect": [
                        20.0,
                        402.0,
                        130.0,
                        22.0
                    ],
                    "text": "poly~ mb_voice 8"
                }
            },
            {
                "box": {
                    "id": "obj-18",
                    "maxclass": "ezdac~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        452.0,
                        45.0,
                        45.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-19",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        74.0,
                        464.0,
                        110.0,
                        20.0
                    ],
                    "text": "audio on/off"
                }
            },
            {
                "box": {
                    "id": "obj-20",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        560.0,
                        96.0,
                        300.0,
                        20.0
                    ],
                    "text": "movement control in (optional)"
                }
            },
            {
                "box": {
                    "id": "obj-21",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
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
                        "classnamespace": "box",
                        "rect": [
                            100.0,
                            100.0,
                            1960.0,
                            1000.0
                        ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-1",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        20.0,
                                        8.0,
                                        1700.0,
                                        27.0
                                    ],
                                    "text": "CONTROL INPUT - accepts any of the synth's 24 parameters on /movebeat/<name>. Values arrive in the parameter's own units; each is clamped to its legal range here so a mis-set controller can never drive the DSP out of bounds. See synth/docs/MAPPING.md.",
                                    "fontsize": 12.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        64.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "udpreceive 7500",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        100.0,
                                        200.0,
                                        22.0
                                    ],
                                    "text": "route /movebeat/gate",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 25,
                                    "patching_rect": [
                                        30.0,
                                        140.0,
                                        1880.0,
                                        22.0
                                    ],
                                    "text": "route /movebeat/cutoff /movebeat/resonance /movebeat/drive /movebeat/rescomp /movebeat/outgain /movebeat/osc1level /movebeat/osc2level /movebeat/sublevel /movebeat/detune /movebeat/pw /movebeat/osc1wave /movebeat/osc2wave /movebeat/lfoRate /movebeat/lfoDepth /movebeat/filtEnvAmt /movebeat/glide /movebeat/ampA /movebeat/ampD /movebeat/ampS /movebeat/ampR /movebeat/filtA /movebeat/filtD /movebeat/filtS /movebeat/filtR",
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
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        930.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1800.0,
                                        930.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        70.0,
                                        934.0,
                                        300.0,
                                        20.0
                                    ],
                                    "text": "parameter messages -> poly~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1600.0,
                                        904.0,
                                        180.0,
                                        20.0
                                    ],
                                    "text": "body present"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        216.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "cutoff  (20 .. 18000)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        240.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 20 18000",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        372.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend cutoff",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        265.0,
                                        216.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "resonance  (0 .. 4)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        265.0,
                                        240.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 4",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        265.0,
                                        304.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        265.0,
                                        336.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        265.0,
                                        372.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend resonance",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        500.0,
                                        216.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "drive  (0 .. 1)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        500.0,
                                        240.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 1",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        500.0,
                                        304.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        500.0,
                                        336.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        500.0,
                                        372.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend drive",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        735.0,
                                        216.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "rescomp  (0 .. 1)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        735.0,
                                        240.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 1",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        735.0,
                                        304.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-25",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        735.0,
                                        336.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-26",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        735.0,
                                        372.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend rescomp",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-27",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        970.0,
                                        216.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "outgain  (0 .. 1)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-28",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        970.0,
                                        240.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 1",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        970.0,
                                        304.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-30",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        970.0,
                                        336.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-31",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        970.0,
                                        372.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend outgain",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-32",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1205.0,
                                        216.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "osc1level  (0 .. 1)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-33",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1205.0,
                                        240.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 1",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-34",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1205.0,
                                        304.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-35",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1205.0,
                                        336.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-36",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1205.0,
                                        372.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend osc1level",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1440.0,
                                        216.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "osc2level  (0 .. 1)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-38",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1440.0,
                                        240.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 1",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-39",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1440.0,
                                        304.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-40",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1440.0,
                                        336.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-41",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1440.0,
                                        372.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend osc2level",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-42",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1675.0,
                                        216.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "sublevel  (0 .. 1)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1675.0,
                                        240.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 1",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-44",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1675.0,
                                        304.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-45",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1675.0,
                                        336.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-46",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1675.0,
                                        372.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend sublevel",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-47",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        431.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "detune  (-24 .. 24)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-48",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        455.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip -24 24",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-49",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        519.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-50",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        551.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        587.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend detune",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        265.0,
                                        431.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "pw  (0.05 .. 0.95)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-53",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        265.0,
                                        455.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0.05 0.95",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-54",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        265.0,
                                        519.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        265.0,
                                        551.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-56",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        265.0,
                                        587.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend pw",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-57",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        500.0,
                                        431.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "osc1wave  (0 .. 3)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        500.0,
                                        455.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 3",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        500.0,
                                        487.0,
                                        170.0,
                                        22.0
                                    ],
                                    "text": "expr int($f1 + 0.5)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        500.0,
                                        519.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        500.0,
                                        551.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-62",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        500.0,
                                        587.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend osc1wave",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-63",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        735.0,
                                        431.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "osc2wave  (0 .. 3)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-64",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        735.0,
                                        455.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 3",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        735.0,
                                        487.0,
                                        170.0,
                                        22.0
                                    ],
                                    "text": "expr int($f1 + 0.5)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-66",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        735.0,
                                        519.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-67",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        735.0,
                                        551.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-68",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        735.0,
                                        587.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend osc2wave",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-69",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        970.0,
                                        431.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "lfoRate  (0.01 .. 20)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-70",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        970.0,
                                        455.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0.01 20",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-71",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        970.0,
                                        519.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-72",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        970.0,
                                        551.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-73",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        970.0,
                                        587.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend lfoRate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-74",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1205.0,
                                        431.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "lfoDepth  (0 .. 5000)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-75",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1205.0,
                                        455.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 5000",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-76",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1205.0,
                                        519.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-77",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1205.0,
                                        551.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-78",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1205.0,
                                        587.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend lfoDepth",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-79",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1440.0,
                                        431.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "filtEnvAmt  (0 .. 8000)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-80",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1440.0,
                                        455.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 8000",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-81",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1440.0,
                                        519.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-82",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1440.0,
                                        551.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-83",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1440.0,
                                        587.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend filtEnvAmt",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-84",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1675.0,
                                        431.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "glide  (0 .. 2000)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-85",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1675.0,
                                        455.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 2000",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-86",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1675.0,
                                        519.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-87",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1675.0,
                                        551.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-88",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1675.0,
                                        587.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend glide",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-89",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        646.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "ampA  (0 .. 2000)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-90",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        670.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 2000",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-91",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        734.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-92",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        766.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-93",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        802.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend ampA",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-94",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        265.0,
                                        646.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "ampD  (0 .. 2000)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-95",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        265.0,
                                        670.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 2000",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-96",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        265.0,
                                        734.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-97",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        265.0,
                                        766.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-98",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        265.0,
                                        802.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend ampD",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-99",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        500.0,
                                        646.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "ampS  (0 .. 1)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-100",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        500.0,
                                        670.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 1",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-101",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        500.0,
                                        734.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-102",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        500.0,
                                        766.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-103",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        500.0,
                                        802.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend ampS",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-104",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        735.0,
                                        646.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "ampR  (0 .. 4000)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-105",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        735.0,
                                        670.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 4000",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-106",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        735.0,
                                        734.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-107",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        735.0,
                                        766.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-108",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        735.0,
                                        802.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend ampR",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-109",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        970.0,
                                        646.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "filtA  (0 .. 2000)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-110",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        970.0,
                                        670.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 2000",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-111",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        970.0,
                                        734.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-112",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        970.0,
                                        766.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-113",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        970.0,
                                        802.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend filtA",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-114",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1205.0,
                                        646.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "filtD  (0 .. 2000)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-115",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1205.0,
                                        670.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 2000",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-116",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1205.0,
                                        734.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-117",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1205.0,
                                        766.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-118",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1205.0,
                                        802.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend filtD",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-119",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1440.0,
                                        646.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "filtS  (0 .. 1)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-120",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1440.0,
                                        670.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 1",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-121",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1440.0,
                                        734.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-122",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1440.0,
                                        766.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-123",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1440.0,
                                        802.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend filtS",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-124",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1675.0,
                                        646.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "filtR  (0 .. 4000)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-125",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1675.0,
                                        670.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "clip 0 4000",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-126",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1675.0,
                                        734.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-127",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1675.0,
                                        766.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-128",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1675.0,
                                        802.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "prepend filtR",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "source": [
                                        "obj-2",
                                        0
                                    ],
                                    "destination": [
                                        "obj-3",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-3",
                                        1
                                    ],
                                    "destination": [
                                        "obj-4",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-3",
                                        0
                                    ],
                                    "destination": [
                                        "obj-6",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        0
                                    ],
                                    "destination": [
                                        "obj-10",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-10",
                                        0
                                    ],
                                    "destination": [
                                        "obj-11",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-11",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        1
                                    ],
                                    "destination": [
                                        "obj-13",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-13",
                                        0
                                    ],
                                    "destination": [
                                        "obj-14",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-14",
                                        0
                                    ],
                                    "destination": [
                                        "obj-15",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-15",
                                        0
                                    ],
                                    "destination": [
                                        "obj-16",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-16",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        2
                                    ],
                                    "destination": [
                                        "obj-18",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-18",
                                        0
                                    ],
                                    "destination": [
                                        "obj-19",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-19",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-20",
                                        0
                                    ],
                                    "destination": [
                                        "obj-21",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-21",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        3
                                    ],
                                    "destination": [
                                        "obj-23",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-23",
                                        0
                                    ],
                                    "destination": [
                                        "obj-24",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-24",
                                        0
                                    ],
                                    "destination": [
                                        "obj-25",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-25",
                                        0
                                    ],
                                    "destination": [
                                        "obj-26",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-26",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        4
                                    ],
                                    "destination": [
                                        "obj-28",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-28",
                                        0
                                    ],
                                    "destination": [
                                        "obj-29",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-29",
                                        0
                                    ],
                                    "destination": [
                                        "obj-30",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-30",
                                        0
                                    ],
                                    "destination": [
                                        "obj-31",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-31",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        5
                                    ],
                                    "destination": [
                                        "obj-33",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-33",
                                        0
                                    ],
                                    "destination": [
                                        "obj-34",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-34",
                                        0
                                    ],
                                    "destination": [
                                        "obj-35",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-35",
                                        0
                                    ],
                                    "destination": [
                                        "obj-36",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-36",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        6
                                    ],
                                    "destination": [
                                        "obj-38",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-38",
                                        0
                                    ],
                                    "destination": [
                                        "obj-39",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-39",
                                        0
                                    ],
                                    "destination": [
                                        "obj-40",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-40",
                                        0
                                    ],
                                    "destination": [
                                        "obj-41",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-41",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        7
                                    ],
                                    "destination": [
                                        "obj-43",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-43",
                                        0
                                    ],
                                    "destination": [
                                        "obj-44",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-44",
                                        0
                                    ],
                                    "destination": [
                                        "obj-45",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-45",
                                        0
                                    ],
                                    "destination": [
                                        "obj-46",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-46",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        8
                                    ],
                                    "destination": [
                                        "obj-48",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-48",
                                        0
                                    ],
                                    "destination": [
                                        "obj-49",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-49",
                                        0
                                    ],
                                    "destination": [
                                        "obj-50",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-50",
                                        0
                                    ],
                                    "destination": [
                                        "obj-51",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-51",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        9
                                    ],
                                    "destination": [
                                        "obj-53",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-53",
                                        0
                                    ],
                                    "destination": [
                                        "obj-54",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-54",
                                        0
                                    ],
                                    "destination": [
                                        "obj-55",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-55",
                                        0
                                    ],
                                    "destination": [
                                        "obj-56",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-56",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        10
                                    ],
                                    "destination": [
                                        "obj-58",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-58",
                                        0
                                    ],
                                    "destination": [
                                        "obj-59",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-59",
                                        0
                                    ],
                                    "destination": [
                                        "obj-60",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-60",
                                        0
                                    ],
                                    "destination": [
                                        "obj-61",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-61",
                                        0
                                    ],
                                    "destination": [
                                        "obj-62",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-62",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        11
                                    ],
                                    "destination": [
                                        "obj-64",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-64",
                                        0
                                    ],
                                    "destination": [
                                        "obj-65",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-65",
                                        0
                                    ],
                                    "destination": [
                                        "obj-66",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-66",
                                        0
                                    ],
                                    "destination": [
                                        "obj-67",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-67",
                                        0
                                    ],
                                    "destination": [
                                        "obj-68",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-68",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        12
                                    ],
                                    "destination": [
                                        "obj-70",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-70",
                                        0
                                    ],
                                    "destination": [
                                        "obj-71",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-71",
                                        0
                                    ],
                                    "destination": [
                                        "obj-72",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-72",
                                        0
                                    ],
                                    "destination": [
                                        "obj-73",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-73",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        13
                                    ],
                                    "destination": [
                                        "obj-75",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-75",
                                        0
                                    ],
                                    "destination": [
                                        "obj-76",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-76",
                                        0
                                    ],
                                    "destination": [
                                        "obj-77",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-77",
                                        0
                                    ],
                                    "destination": [
                                        "obj-78",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-78",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        14
                                    ],
                                    "destination": [
                                        "obj-80",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-80",
                                        0
                                    ],
                                    "destination": [
                                        "obj-81",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-81",
                                        0
                                    ],
                                    "destination": [
                                        "obj-82",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-82",
                                        0
                                    ],
                                    "destination": [
                                        "obj-83",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-83",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        15
                                    ],
                                    "destination": [
                                        "obj-85",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-85",
                                        0
                                    ],
                                    "destination": [
                                        "obj-86",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-86",
                                        0
                                    ],
                                    "destination": [
                                        "obj-87",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-87",
                                        0
                                    ],
                                    "destination": [
                                        "obj-88",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-88",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        16
                                    ],
                                    "destination": [
                                        "obj-90",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-90",
                                        0
                                    ],
                                    "destination": [
                                        "obj-91",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-91",
                                        0
                                    ],
                                    "destination": [
                                        "obj-92",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-92",
                                        0
                                    ],
                                    "destination": [
                                        "obj-93",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-93",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        17
                                    ],
                                    "destination": [
                                        "obj-95",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-95",
                                        0
                                    ],
                                    "destination": [
                                        "obj-96",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-96",
                                        0
                                    ],
                                    "destination": [
                                        "obj-97",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-97",
                                        0
                                    ],
                                    "destination": [
                                        "obj-98",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-98",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        18
                                    ],
                                    "destination": [
                                        "obj-100",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-100",
                                        0
                                    ],
                                    "destination": [
                                        "obj-101",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-101",
                                        0
                                    ],
                                    "destination": [
                                        "obj-102",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-102",
                                        0
                                    ],
                                    "destination": [
                                        "obj-103",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-103",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        19
                                    ],
                                    "destination": [
                                        "obj-105",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-105",
                                        0
                                    ],
                                    "destination": [
                                        "obj-106",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-106",
                                        0
                                    ],
                                    "destination": [
                                        "obj-107",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-107",
                                        0
                                    ],
                                    "destination": [
                                        "obj-108",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-108",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        20
                                    ],
                                    "destination": [
                                        "obj-110",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-110",
                                        0
                                    ],
                                    "destination": [
                                        "obj-111",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-111",
                                        0
                                    ],
                                    "destination": [
                                        "obj-112",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-112",
                                        0
                                    ],
                                    "destination": [
                                        "obj-113",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-113",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        21
                                    ],
                                    "destination": [
                                        "obj-115",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-115",
                                        0
                                    ],
                                    "destination": [
                                        "obj-116",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-116",
                                        0
                                    ],
                                    "destination": [
                                        "obj-117",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-117",
                                        0
                                    ],
                                    "destination": [
                                        "obj-118",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-118",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        22
                                    ],
                                    "destination": [
                                        "obj-120",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-120",
                                        0
                                    ],
                                    "destination": [
                                        "obj-121",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-121",
                                        0
                                    ],
                                    "destination": [
                                        "obj-122",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-122",
                                        0
                                    ],
                                    "destination": [
                                        "obj-123",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-123",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-4",
                                        23
                                    ],
                                    "destination": [
                                        "obj-125",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-125",
                                        0
                                    ],
                                    "destination": [
                                        "obj-126",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-126",
                                        0
                                    ],
                                    "destination": [
                                        "obj-127",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-127",
                                        0
                                    ],
                                    "destination": [
                                        "obj-128",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-128",
                                        0
                                    ],
                                    "destination": [
                                        "obj-5",
                                        0
                                    ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [
                        560.0,
                        120.0,
                        110.0,
                        22.0
                    ],
                    "text": "p mb_ctrl_in"
                }
            },
            {
                "box": {
                    "id": "obj-22",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "parameter_enable": 0,
                    "patching_rect": [
                        700.0,
                        168.0,
                        24.0,
                        24.0
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-23",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        730.0,
                        170.0,
                        110.0,
                        20.0
                    ],
                    "text": "body tracked"
                }
            },
            {
                "box": {
                    "id": "obj-24",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        560.0,
                        168.0,
                        130.0,
                        22.0
                    ],
                    "text": "\u2014"
                }
            },
            {
                "box": {
                    "id": "obj-25",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        560.0,
                        196.0,
                        220.0,
                        20.0
                    ],
                    "text": "last parameter received"
                }
            },
            {
                "box": {
                    "fontsize": 13.0,
                    "id": "obj-26",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        62.0,
                        620.0,
                        21.0
                    ],
                    "text": "SYNTH PANEL \u2014 every parameter is playable without a controller"
                }
            },
            {
                "box": {
                    "fontsize": 12.0,
                    "id": "obj-27",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        560.0,
                        200.0,
                        20.0
                    ],
                    "text": "OSCILLATORS"
                }
            },
            {
                "box": {
                    "id": "obj-28",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        584.0,
                        150.0,
                        20.0
                    ],
                    "text": "osc 1 wave"
                }
            },
            {
                "box": {
                    "id": "obj-29",
                    "patching_rect": [
                        20.0,
                        606.0,
                        100.0,
                        22.0
                    ],
                    "maxclass": "live.menu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "",
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        62.0,
                        40.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "osc1wave",
                            "parameter_shortname": "osc1wave",
                            "parameter_type": 2,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 3.0,
                            "parameter_enum": [
                                "saw",
                                "square",
                                "triangle",
                                "sine"
                            ],
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "osc1wave"
                }
            },
            {
                "box": {
                    "id": "obj-30",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        606.0,
                        56.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-31",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        634.0,
                        130.0,
                        22.0
                    ],
                    "text": "osc1wave $1"
                }
            },
            {
                "box": {
                    "id": "obj-32",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        666.0,
                        150.0,
                        20.0
                    ],
                    "text": "osc 2 wave"
                }
            },
            {
                "box": {
                    "id": "obj-33",
                    "patching_rect": [
                        20.0,
                        688.0,
                        100.0,
                        22.0
                    ],
                    "maxclass": "live.menu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [
                        "",
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        62.0,
                        57.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "osc2wave",
                            "parameter_shortname": "osc2wave",
                            "parameter_type": 2,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 3.0,
                            "parameter_enum": [
                                "saw",
                                "square",
                                "triangle",
                                "sine"
                            ],
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "osc2wave"
                }
            },
            {
                "box": {
                    "id": "obj-34",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        688.0,
                        56.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-35",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        716.0,
                        130.0,
                        22.0
                    ],
                    "text": "osc2wave $1"
                }
            },
            {
                "box": {
                    "id": "obj-36",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        748.0,
                        150.0,
                        20.0
                    ],
                    "text": "osc 1 level  0\u20131"
                }
            },
            {
                "box": {
                    "id": "obj-37",
                    "patching_rect": [
                        20.0,
                        770.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        62.0,
                        74.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "osc1level",
                            "parameter_shortname": "osc1level",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 1.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.8
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "osc1level"
                }
            },
            {
                "box": {
                    "id": "obj-38",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        770.0,
                        56.0,
                        22.0
                    ],
                    "text": "0.8"
                }
            },
            {
                "box": {
                    "id": "obj-39",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        798.0,
                        130.0,
                        22.0
                    ],
                    "text": "osc1level $1"
                }
            },
            {
                "box": {
                    "id": "obj-40",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        830.0,
                        150.0,
                        20.0
                    ],
                    "text": "osc 2 level  0\u20131"
                }
            },
            {
                "box": {
                    "id": "obj-41",
                    "patching_rect": [
                        20.0,
                        852.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        62.0,
                        91.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "osc2level",
                            "parameter_shortname": "osc2level",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 1.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.6
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "osc2level"
                }
            },
            {
                "box": {
                    "id": "obj-42",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        852.0,
                        56.0,
                        22.0
                    ],
                    "text": "0.6"
                }
            },
            {
                "box": {
                    "id": "obj-43",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        880.0,
                        130.0,
                        22.0
                    ],
                    "text": "osc2level $1"
                }
            },
            {
                "box": {
                    "id": "obj-44",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        912.0,
                        150.0,
                        20.0
                    ],
                    "text": "sub level  0\u20131"
                }
            },
            {
                "box": {
                    "id": "obj-45",
                    "patching_rect": [
                        20.0,
                        934.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        62.0,
                        108.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "sublevel",
                            "parameter_shortname": "sublevel",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 1.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.4
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "sublevel"
                }
            },
            {
                "box": {
                    "id": "obj-46",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        934.0,
                        56.0,
                        22.0
                    ],
                    "text": "0.4"
                }
            },
            {
                "box": {
                    "id": "obj-47",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        962.0,
                        130.0,
                        22.0
                    ],
                    "text": "sublevel $1"
                }
            },
            {
                "box": {
                    "id": "obj-48",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        994.0,
                        150.0,
                        20.0
                    ],
                    "text": "detune  \u221224\u202624 st"
                }
            },
            {
                "box": {
                    "id": "obj-49",
                    "patching_rect": [
                        20.0,
                        1016.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        62.0,
                        125.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "detune",
                            "parameter_shortname": "detune",
                            "parameter_type": 0,
                            "parameter_mmin": -24.0,
                            "parameter_mmax": 24.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "detune"
                }
            },
            {
                "box": {
                    "id": "obj-50",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        1016.0,
                        56.0,
                        22.0
                    ],
                    "text": "0."
                }
            },
            {
                "box": {
                    "id": "obj-51",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1044.0,
                        130.0,
                        22.0
                    ],
                    "text": "detune $1"
                }
            },
            {
                "box": {
                    "id": "obj-52",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1076.0,
                        150.0,
                        20.0
                    ],
                    "text": "pulse width"
                }
            },
            {
                "box": {
                    "id": "obj-53",
                    "patching_rect": [
                        20.0,
                        1098.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        176.0,
                        40.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "pw",
                            "parameter_shortname": "pw",
                            "parameter_type": 0,
                            "parameter_mmin": 0.05,
                            "parameter_mmax": 0.95,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.5
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "pw"
                }
            },
            {
                "box": {
                    "id": "obj-54",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        1098.0,
                        56.0,
                        22.0
                    ],
                    "text": "0.5"
                }
            },
            {
                "box": {
                    "id": "obj-55",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1126.0,
                        130.0,
                        22.0
                    ],
                    "text": "pw $1"
                }
            },
            {
                "box": {
                    "fontsize": 12.0,
                    "id": "obj-56",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1178.0,
                        200.0,
                        20.0
                    ],
                    "text": "FILTER"
                }
            },
            {
                "box": {
                    "id": "obj-57",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1202.0,
                        150.0,
                        20.0
                    ],
                    "text": "cutoff  20\u201318k Hz"
                }
            },
            {
                "box": {
                    "id": "obj-58",
                    "patching_rect": [
                        20.0,
                        1224.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        176.0,
                        57.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "cutoff",
                            "parameter_shortname": "cutoff",
                            "parameter_type": 0,
                            "parameter_mmin": 20.0,
                            "parameter_mmax": 18000.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                1200.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "cutoff"
                }
            },
            {
                "box": {
                    "id": "obj-59",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        1224.0,
                        56.0,
                        22.0
                    ],
                    "text": "1200"
                }
            },
            {
                "box": {
                    "id": "obj-60",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1252.0,
                        130.0,
                        22.0
                    ],
                    "text": "cutoff $1"
                }
            },
            {
                "box": {
                    "id": "obj-61",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1284.0,
                        150.0,
                        20.0
                    ],
                    "text": "resonance  0\u20134"
                }
            },
            {
                "box": {
                    "id": "obj-62",
                    "patching_rect": [
                        20.0,
                        1306.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        176.0,
                        74.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "resonance",
                            "parameter_shortname": "resonance",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 4.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.6
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "resonance"
                }
            },
            {
                "box": {
                    "id": "obj-63",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        1306.0,
                        56.0,
                        22.0
                    ],
                    "text": "0.6"
                }
            },
            {
                "box": {
                    "id": "obj-64",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1334.0,
                        130.0,
                        22.0
                    ],
                    "text": "resonance $1"
                }
            },
            {
                "box": {
                    "id": "obj-65",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1366.0,
                        150.0,
                        20.0
                    ],
                    "text": "drive  0\u20131"
                }
            },
            {
                "box": {
                    "id": "obj-66",
                    "patching_rect": [
                        20.0,
                        1388.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        176.0,
                        91.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "drive",
                            "parameter_shortname": "drive",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 1.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "drive"
                }
            },
            {
                "box": {
                    "id": "obj-67",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        1388.0,
                        56.0,
                        22.0
                    ],
                    "text": "0."
                }
            },
            {
                "box": {
                    "id": "obj-68",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1416.0,
                        130.0,
                        22.0
                    ],
                    "text": "drive $1"
                }
            },
            {
                "box": {
                    "id": "obj-69",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1448.0,
                        150.0,
                        20.0
                    ],
                    "text": "res comp  0\u20131"
                }
            },
            {
                "box": {
                    "id": "obj-70",
                    "patching_rect": [
                        20.0,
                        1470.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        176.0,
                        108.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "rescomp",
                            "parameter_shortname": "rescomp",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 1.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "rescomp"
                }
            },
            {
                "box": {
                    "id": "obj-71",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        1470.0,
                        56.0,
                        22.0
                    ],
                    "text": "0."
                }
            },
            {
                "box": {
                    "id": "obj-72",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1498.0,
                        130.0,
                        22.0
                    ],
                    "text": "rescomp $1"
                }
            },
            {
                "box": {
                    "fontsize": 12.0,
                    "id": "obj-73",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1550.0,
                        200.0,
                        20.0
                    ],
                    "text": "LFO"
                }
            },
            {
                "box": {
                    "id": "obj-74",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1574.0,
                        150.0,
                        20.0
                    ],
                    "text": "lfo rate  Hz"
                }
            },
            {
                "box": {
                    "id": "obj-75",
                    "patching_rect": [
                        20.0,
                        1596.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        290.0,
                        125.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "lfoRate",
                            "parameter_shortname": "lfoRate",
                            "parameter_type": 0,
                            "parameter_mmin": 0.01,
                            "parameter_mmax": 20.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                2.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "lfoRate"
                }
            },
            {
                "box": {
                    "id": "obj-76",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        1596.0,
                        56.0,
                        22.0
                    ],
                    "text": "2"
                }
            },
            {
                "box": {
                    "id": "obj-77",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1624.0,
                        130.0,
                        22.0
                    ],
                    "text": "lfoRate $1"
                }
            },
            {
                "box": {
                    "id": "obj-78",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1656.0,
                        150.0,
                        20.0
                    ],
                    "text": "lfo depth  Hz"
                }
            },
            {
                "box": {
                    "id": "obj-79",
                    "patching_rect": [
                        20.0,
                        1678.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        404.0,
                        125.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "lfoDepth",
                            "parameter_shortname": "lfoDepth",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 5000.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                500.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "lfoDepth"
                }
            },
            {
                "box": {
                    "id": "obj-80",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        1678.0,
                        56.0,
                        22.0
                    ],
                    "text": "500"
                }
            },
            {
                "box": {
                    "id": "obj-81",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1706.0,
                        130.0,
                        22.0
                    ],
                    "text": "lfoDepth $1"
                }
            },
            {
                "box": {
                    "fontsize": 12.0,
                    "id": "obj-82",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1758.0,
                        200.0,
                        20.0
                    ],
                    "text": "AMP ENVELOPE"
                }
            },
            {
                "box": {
                    "id": "obj-83",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1782.0,
                        150.0,
                        20.0
                    ],
                    "text": "attack  ms"
                }
            },
            {
                "box": {
                    "id": "obj-84",
                    "patching_rect": [
                        20.0,
                        1804.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        290.0,
                        40.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "ampA",
                            "parameter_shortname": "ampA",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 2000.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                10.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "ampA"
                }
            },
            {
                "box": {
                    "id": "obj-85",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        1804.0,
                        56.0,
                        22.0
                    ],
                    "text": "10"
                }
            },
            {
                "box": {
                    "id": "obj-86",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1832.0,
                        130.0,
                        22.0
                    ],
                    "text": "ampA $1"
                }
            },
            {
                "box": {
                    "id": "obj-87",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1864.0,
                        150.0,
                        20.0
                    ],
                    "text": "decay  ms"
                }
            },
            {
                "box": {
                    "id": "obj-88",
                    "patching_rect": [
                        20.0,
                        1886.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        290.0,
                        57.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "ampD",
                            "parameter_shortname": "ampD",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 2000.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                200.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "ampD"
                }
            },
            {
                "box": {
                    "id": "obj-89",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        130.0,
                        1886.0,
                        56.0,
                        22.0
                    ],
                    "text": "200"
                }
            },
            {
                "box": {
                    "id": "obj-90",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        1914.0,
                        130.0,
                        22.0
                    ],
                    "text": "ampD $1"
                }
            },
            {
                "box": {
                    "id": "obj-91",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        560.0,
                        150.0,
                        20.0
                    ],
                    "text": "sustain  0\u20131"
                }
            },
            {
                "box": {
                    "id": "obj-92",
                    "patching_rect": [
                        280.0,
                        582.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        290.0,
                        74.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "ampS",
                            "parameter_shortname": "ampS",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 1.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.8
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "ampS"
                }
            },
            {
                "box": {
                    "id": "obj-93",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        390.0,
                        582.0,
                        56.0,
                        22.0
                    ],
                    "text": "0.8"
                }
            },
            {
                "box": {
                    "id": "obj-94",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        280.0,
                        610.0,
                        130.0,
                        22.0
                    ],
                    "text": "ampS $1"
                }
            },
            {
                "box": {
                    "id": "obj-95",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        642.0,
                        150.0,
                        20.0
                    ],
                    "text": "release  ms"
                }
            },
            {
                "box": {
                    "id": "obj-96",
                    "patching_rect": [
                        280.0,
                        664.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        290.0,
                        91.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "ampR",
                            "parameter_shortname": "ampR",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 4000.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                400.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "ampR"
                }
            },
            {
                "box": {
                    "id": "obj-97",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        390.0,
                        664.0,
                        56.0,
                        22.0
                    ],
                    "text": "400"
                }
            },
            {
                "box": {
                    "id": "obj-98",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        280.0,
                        692.0,
                        130.0,
                        22.0
                    ],
                    "text": "ampR $1"
                }
            },
            {
                "box": {
                    "fontsize": 12.0,
                    "id": "obj-99",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        744.0,
                        200.0,
                        20.0
                    ],
                    "text": "PLAY"
                }
            },
            {
                "box": {
                    "id": "obj-100",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        768.0,
                        150.0,
                        20.0
                    ],
                    "text": "glide  ms"
                }
            },
            {
                "box": {
                    "id": "obj-101",
                    "patching_rect": [
                        280.0,
                        790.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        290.0,
                        108.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "glide",
                            "parameter_shortname": "glide",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 2000.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "glide"
                }
            },
            {
                "box": {
                    "id": "obj-102",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        390.0,
                        790.0,
                        56.0,
                        22.0
                    ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-103",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        280.0,
                        818.0,
                        130.0,
                        22.0
                    ],
                    "text": "glide $1"
                }
            },
            {
                "box": {
                    "id": "obj-104",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        850.0,
                        150.0,
                        20.0
                    ],
                    "text": "out gain  0\u20131"
                }
            },
            {
                "box": {
                    "id": "obj-105",
                    "patching_rect": [
                        280.0,
                        872.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        176.0,
                        125.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "outgain",
                            "parameter_shortname": "outgain",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 1.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.5
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "outgain"
                }
            },
            {
                "box": {
                    "id": "obj-106",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        390.0,
                        872.0,
                        56.0,
                        22.0
                    ],
                    "text": "0.5"
                }
            },
            {
                "box": {
                    "id": "obj-107",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        280.0,
                        900.0,
                        130.0,
                        22.0
                    ],
                    "text": "outgain $1"
                }
            },
            {
                "box": {
                    "fontsize": 12.0,
                    "id": "obj-108",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        952.0,
                        200.0,
                        20.0
                    ],
                    "text": "FILTER ENVELOPE"
                }
            },
            {
                "box": {
                    "id": "obj-109",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        976.0,
                        150.0,
                        20.0
                    ],
                    "text": "attack  ms"
                }
            },
            {
                "box": {
                    "id": "obj-110",
                    "patching_rect": [
                        280.0,
                        998.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        404.0,
                        40.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "filtA",
                            "parameter_shortname": "filtA",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 2000.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                5.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "filtA"
                }
            },
            {
                "box": {
                    "id": "obj-111",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        390.0,
                        998.0,
                        56.0,
                        22.0
                    ],
                    "text": "5"
                }
            },
            {
                "box": {
                    "id": "obj-112",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        280.0,
                        1026.0,
                        130.0,
                        22.0
                    ],
                    "text": "filtA $1"
                }
            },
            {
                "box": {
                    "id": "obj-113",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        1058.0,
                        150.0,
                        20.0
                    ],
                    "text": "decay  ms"
                }
            },
            {
                "box": {
                    "id": "obj-114",
                    "patching_rect": [
                        280.0,
                        1080.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        404.0,
                        57.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "filtD",
                            "parameter_shortname": "filtD",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 2000.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                200.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "filtD"
                }
            },
            {
                "box": {
                    "id": "obj-115",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        390.0,
                        1080.0,
                        56.0,
                        22.0
                    ],
                    "text": "200"
                }
            },
            {
                "box": {
                    "id": "obj-116",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        280.0,
                        1108.0,
                        130.0,
                        22.0
                    ],
                    "text": "filtD $1"
                }
            },
            {
                "box": {
                    "id": "obj-117",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        1140.0,
                        150.0,
                        20.0
                    ],
                    "text": "sustain  0\u20131"
                }
            },
            {
                "box": {
                    "id": "obj-118",
                    "patching_rect": [
                        280.0,
                        1162.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        404.0,
                        74.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "filtS",
                            "parameter_shortname": "filtS",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 1.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                0.5
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "filtS"
                }
            },
            {
                "box": {
                    "id": "obj-119",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        390.0,
                        1162.0,
                        56.0,
                        22.0
                    ],
                    "text": "0.5"
                }
            },
            {
                "box": {
                    "id": "obj-120",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        280.0,
                        1190.0,
                        130.0,
                        22.0
                    ],
                    "text": "filtS $1"
                }
            },
            {
                "box": {
                    "id": "obj-121",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        1222.0,
                        150.0,
                        20.0
                    ],
                    "text": "release  ms"
                }
            },
            {
                "box": {
                    "id": "obj-122",
                    "patching_rect": [
                        280.0,
                        1244.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        404.0,
                        91.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "filtR",
                            "parameter_shortname": "filtR",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 4000.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                300.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "filtR"
                }
            },
            {
                "box": {
                    "id": "obj-123",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        390.0,
                        1244.0,
                        56.0,
                        22.0
                    ],
                    "text": "300"
                }
            },
            {
                "box": {
                    "id": "obj-124",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        280.0,
                        1272.0,
                        130.0,
                        22.0
                    ],
                    "text": "filtR $1"
                }
            },
            {
                "box": {
                    "id": "obj-125",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        1304.0,
                        150.0,
                        20.0
                    ],
                    "text": "env amount  Hz"
                }
            },
            {
                "box": {
                    "id": "obj-126",
                    "patching_rect": [
                        280.0,
                        1326.0,
                        70.0,
                        22.0
                    ],
                    "maxclass": "live.numbox",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        "float"
                    ],
                    "parameter_enable": 1,
                    "presentation": 1,
                    "presentation_rect": [
                        404.0,
                        108.0,
                        46.0,
                        15.0
                    ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "filtEnvAmt",
                            "parameter_shortname": "filtEnvAmt",
                            "parameter_type": 0,
                            "parameter_mmin": 0.0,
                            "parameter_mmax": 8000.0,
                            "parameter_initial_enable": 1,
                            "parameter_initial": [
                                2000.0
                            ],
                            "parameter_unitstyle": 0
                        }
                    },
                    "varname": "filtEnvAmt"
                }
            },
            {
                "box": {
                    "id": "obj-127",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        390.0,
                        1326.0,
                        56.0,
                        22.0
                    ],
                    "text": "2000"
                }
            },
            {
                "box": {
                    "id": "obj-128",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        280.0,
                        1354.0,
                        130.0,
                        22.0
                    ],
                    "text": "filtEnvAmt $1"
                }
            },
            {
                "box": {
                    "id": "obj-129",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1880.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        4.0,
                        24.0,
                        104.0,
                        14.0
                    ],
                    "text": "OSC",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-130",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1900.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        4.0,
                        40.0,
                        56.0,
                        14.0
                    ],
                    "text": "osc1wave",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-131",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1920.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        4.0,
                        57.0,
                        56.0,
                        14.0
                    ],
                    "text": "osc2wave",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-132",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1940.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        4.0,
                        74.0,
                        56.0,
                        14.0
                    ],
                    "text": "osc1level",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-133",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1960.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        4.0,
                        91.0,
                        56.0,
                        14.0
                    ],
                    "text": "osc2level",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-134",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1980.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        4.0,
                        108.0,
                        56.0,
                        14.0
                    ],
                    "text": "sublevel",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-135",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        2000.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        4.0,
                        125.0,
                        56.0,
                        14.0
                    ],
                    "text": "detune",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-136",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        2020.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        118.0,
                        24.0,
                        104.0,
                        14.0
                    ],
                    "text": "TONE",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-137",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        2040.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        118.0,
                        40.0,
                        56.0,
                        14.0
                    ],
                    "text": "pw",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-138",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        2060.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        118.0,
                        57.0,
                        56.0,
                        14.0
                    ],
                    "text": "cutoff",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-139",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        2080.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        118.0,
                        74.0,
                        56.0,
                        14.0
                    ],
                    "text": "resonance",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-140",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1700.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        118.0,
                        91.0,
                        56.0,
                        14.0
                    ],
                    "text": "drive",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-141",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1720.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        118.0,
                        108.0,
                        56.0,
                        14.0
                    ],
                    "text": "rescomp",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-142",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1740.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        118.0,
                        125.0,
                        56.0,
                        14.0
                    ],
                    "text": "outgain",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-143",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1760.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        232.0,
                        24.0,
                        104.0,
                        14.0
                    ],
                    "text": "AMP ENV",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-144",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1780.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        232.0,
                        40.0,
                        56.0,
                        14.0
                    ],
                    "text": "ampA",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-145",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1800.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        232.0,
                        57.0,
                        56.0,
                        14.0
                    ],
                    "text": "ampD",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-146",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1820.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        232.0,
                        74.0,
                        56.0,
                        14.0
                    ],
                    "text": "ampS",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-147",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1840.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        232.0,
                        91.0,
                        56.0,
                        14.0
                    ],
                    "text": "ampR",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-148",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1860.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        232.0,
                        108.0,
                        56.0,
                        14.0
                    ],
                    "text": "glide",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-149",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1880.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        232.0,
                        125.0,
                        56.0,
                        14.0
                    ],
                    "text": "lfoRate",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-150",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1900.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        346.0,
                        24.0,
                        104.0,
                        14.0
                    ],
                    "text": "FILT ENV",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-151",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1920.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        346.0,
                        40.0,
                        56.0,
                        14.0
                    ],
                    "text": "filtA",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-152",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1940.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        346.0,
                        57.0,
                        56.0,
                        14.0
                    ],
                    "text": "filtD",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-153",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1960.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        346.0,
                        74.0,
                        56.0,
                        14.0
                    ],
                    "text": "filtS",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-154",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        1980.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        346.0,
                        91.0,
                        56.0,
                        14.0
                    ],
                    "text": "filtR",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-155",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        2000.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        346.0,
                        108.0,
                        56.0,
                        14.0
                    ],
                    "text": "filtEnvAmt",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-156",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        2020.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        346.0,
                        125.0,
                        56.0,
                        14.0
                    ],
                    "text": "lfoDepth",
                    "fontsize": 8.0,
                    "varname": "mb_pres_label"
                }
            },
            {
                "box": {
                    "id": "obj-157",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1500.0,
                        2040.0,
                        120.0,
                        20.0
                    ],
                    "presentation": 1,
                    "presentation_rect": [
                        4.0,
                        2.0,
                        200.0,
                        18.0
                    ],
                    "text": "MOVEBEAT SYNTH",
                    "fontsize": 11.0,
                    "varname": "mb_pres_label"
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        0
                    ],
                    "midpoints": [
                        163.0,
                        387.0,
                        29.5,
                        387.0
                    ],
                    "source": [
                        "obj-10",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-103",
                        0
                    ],
                    "source": [
                        "obj-101",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-101",
                        0
                    ],
                    "midpoints": [
                        399.5,
                        813.0,
                        276.0,
                        813.0,
                        276.0,
                        786.0,
                        289.5,
                        786.0
                    ],
                    "source": [
                        "obj-102",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        289.5,
                        843.0,
                        231.0,
                        843.0,
                        231.0,
                        399.0,
                        140.5,
                        399.0
                    ],
                    "source": [
                        "obj-103",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-107",
                        0
                    ],
                    "source": [
                        "obj-105",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-105",
                        0
                    ],
                    "midpoints": [
                        399.5,
                        897.0,
                        276.0,
                        897.0,
                        276.0,
                        867.0,
                        289.5,
                        867.0
                    ],
                    "source": [
                        "obj-106",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        289.5,
                        924.0,
                        231.0,
                        924.0,
                        231.0,
                        399.0,
                        140.5,
                        399.0
                    ],
                    "source": [
                        "obj-107",
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
                        296.5,
                        324.0,
                        229.5,
                        324.0
                    ],
                    "source": [
                        "obj-11",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-112",
                        0
                    ],
                    "source": [
                        "obj-110",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-110",
                        0
                    ],
                    "midpoints": [
                        399.5,
                        1023.0,
                        276.0,
                        1023.0,
                        276.0,
                        993.0,
                        289.5,
                        993.0
                    ],
                    "source": [
                        "obj-111",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        289.5,
                        1050.0,
                        231.0,
                        1050.0,
                        231.0,
                        399.0,
                        140.5,
                        399.0
                    ],
                    "source": [
                        "obj-112",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-116",
                        0
                    ],
                    "source": [
                        "obj-114",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-114",
                        0
                    ],
                    "midpoints": [
                        399.5,
                        1104.0,
                        276.0,
                        1104.0,
                        276.0,
                        1077.0,
                        289.5,
                        1077.0
                    ],
                    "source": [
                        "obj-115",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        289.5,
                        1131.0,
                        231.0,
                        1131.0,
                        231.0,
                        399.0,
                        140.5,
                        399.0
                    ],
                    "source": [
                        "obj-116",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-120",
                        0
                    ],
                    "source": [
                        "obj-118",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-118",
                        0
                    ],
                    "midpoints": [
                        399.5,
                        1185.0,
                        276.0,
                        1185.0,
                        276.0,
                        1158.0,
                        289.5,
                        1158.0
                    ],
                    "source": [
                        "obj-119",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        0
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
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        289.5,
                        1215.0,
                        231.0,
                        1215.0,
                        231.0,
                        399.0,
                        140.5,
                        399.0
                    ],
                    "source": [
                        "obj-120",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-124",
                        0
                    ],
                    "source": [
                        "obj-122",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-122",
                        0
                    ],
                    "midpoints": [
                        399.5,
                        1269.0,
                        276.0,
                        1269.0,
                        276.0,
                        1239.0,
                        289.5,
                        1239.0
                    ],
                    "source": [
                        "obj-123",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        289.5,
                        1296.0,
                        231.0,
                        1296.0,
                        231.0,
                        399.0,
                        140.5,
                        399.0
                    ],
                    "source": [
                        "obj-124",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-128",
                        0
                    ],
                    "source": [
                        "obj-126",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-126",
                        0
                    ],
                    "midpoints": [
                        399.5,
                        1350.0,
                        276.0,
                        1350.0,
                        276.0,
                        1323.0,
                        289.5,
                        1323.0
                    ],
                    "source": [
                        "obj-127",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        289.5,
                        1377.0,
                        231.0,
                        1377.0,
                        231.0,
                        399.0,
                        140.5,
                        399.0
                    ],
                    "source": [
                        "obj-128",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        229.5,
                        387.0,
                        140.5,
                        387.0
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
                        "obj-17",
                        0
                    ],
                    "midpoints": [
                        349.5,
                        387.0,
                        29.5,
                        387.0
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
                        "obj-16",
                        0
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
                        "obj-14",
                        0
                    ],
                    "midpoints": [
                        460.5,
                        297.0,
                        349.5,
                        297.0
                    ],
                    "source": [
                        "obj-16",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-18",
                        1
                    ],
                    "order": 0,
                    "source": [
                        "obj-17",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-18",
                        0
                    ],
                    "order": 1,
                    "source": [
                        "obj-17",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        569.5,
                        153.0,
                        492.0,
                        153.0,
                        492.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "order": 1,
                    "source": [
                        "obj-21",
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
                    "midpoints": [
                        660.5,
                        153.0,
                        709.5,
                        153.0
                    ],
                    "source": [
                        "obj-21",
                        1
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
                        569.5,
                        153.0,
                        680.5,
                        153.0
                    ],
                    "order": 0,
                    "source": [
                        "obj-21",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-31",
                        0
                    ],
                    "source": [
                        "obj-29",
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
                    "midpoints": [
                        346.5,
                        165.0,
                        78.5,
                        165.0
                    ],
                    "source": [
                        "obj-3",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-5",
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
                        "obj-29",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        630.0,
                        15.0,
                        630.0,
                        15.0,
                        603.0,
                        29.5,
                        603.0
                    ],
                    "source": [
                        "obj-30",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        657.0,
                        6.0,
                        657.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-31",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-35",
                        0
                    ],
                    "source": [
                        "obj-33",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-33",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        711.0,
                        15.0,
                        711.0,
                        15.0,
                        684.0,
                        29.5,
                        684.0
                    ],
                    "source": [
                        "obj-34",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        741.0,
                        6.0,
                        741.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-35",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-39",
                        0
                    ],
                    "source": [
                        "obj-37",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-37",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        795.0,
                        15.0,
                        795.0,
                        15.0,
                        765.0,
                        29.5,
                        765.0
                    ],
                    "source": [
                        "obj-38",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        822.0,
                        6.0,
                        822.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-39",
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
                    "midpoints": [
                        407.5,
                        165.0,
                        78.5,
                        165.0
                    ],
                    "source": [
                        "obj-4",
                        1
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
                        389.5,
                        165.0,
                        29.5,
                        165.0
                    ],
                    "source": [
                        "obj-4",
                        0
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
                        "obj-41",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-41",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        876.0,
                        15.0,
                        876.0,
                        15.0,
                        849.0,
                        29.5,
                        849.0
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
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        903.0,
                        6.0,
                        903.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
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
                        "obj-47",
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
                        "obj-45",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        957.0,
                        15.0,
                        957.0,
                        15.0,
                        930.0,
                        29.5,
                        930.0
                    ],
                    "source": [
                        "obj-46",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        987.0,
                        6.0,
                        987.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
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
                        "obj-51",
                        0
                    ],
                    "source": [
                        "obj-49",
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
                    "source": [
                        "obj-5",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-49",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        1041.0,
                        15.0,
                        1041.0,
                        15.0,
                        1011.0,
                        29.5,
                        1011.0
                    ],
                    "source": [
                        "obj-50",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        1068.0,
                        6.0,
                        1068.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-51",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-55",
                        0
                    ],
                    "source": [
                        "obj-53",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-53",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        1122.0,
                        15.0,
                        1122.0,
                        15.0,
                        1095.0,
                        29.5,
                        1095.0
                    ],
                    "source": [
                        "obj-54",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        1149.0,
                        6.0,
                        1149.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-55",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-60",
                        0
                    ],
                    "source": [
                        "obj-58",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-58",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        1248.0,
                        15.0,
                        1248.0,
                        15.0,
                        1221.0,
                        29.5,
                        1221.0
                    ],
                    "source": [
                        "obj-59",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-7",
                        2
                    ],
                    "midpoints": [
                        76.5,
                        225.0,
                        90.5,
                        225.0
                    ],
                    "source": [
                        "obj-6",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-7",
                        1
                    ],
                    "midpoints": [
                        53.0,
                        225.0,
                        60.0,
                        225.0
                    ],
                    "source": [
                        "obj-6",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-7",
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
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        1275.0,
                        6.0,
                        1275.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-60",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-64",
                        0
                    ],
                    "source": [
                        "obj-62",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-62",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        1329.0,
                        15.0,
                        1329.0,
                        15.0,
                        1302.0,
                        29.5,
                        1302.0
                    ],
                    "source": [
                        "obj-63",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        1359.0,
                        6.0,
                        1359.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-64",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-68",
                        0
                    ],
                    "source": [
                        "obj-66",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-66",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        1413.0,
                        15.0,
                        1413.0,
                        15.0,
                        1383.0,
                        29.5,
                        1383.0
                    ],
                    "source": [
                        "obj-67",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        1440.0,
                        6.0,
                        1440.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-68",
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
                    "midpoints": [
                        29.5,
                        255.0,
                        30.0,
                        255.0,
                        30.0,
                        261.0,
                        29.5,
                        261.0
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
                        "obj-72",
                        0
                    ],
                    "source": [
                        "obj-70",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-70",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        1494.0,
                        15.0,
                        1494.0,
                        15.0,
                        1467.0,
                        29.5,
                        1467.0
                    ],
                    "source": [
                        "obj-71",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        1521.0,
                        6.0,
                        1521.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-72",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-77",
                        0
                    ],
                    "source": [
                        "obj-75",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-75",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        1620.0,
                        15.0,
                        1620.0,
                        15.0,
                        1593.0,
                        29.5,
                        1593.0
                    ],
                    "source": [
                        "obj-76",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        1647.0,
                        6.0,
                        1647.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-77",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-81",
                        0
                    ],
                    "source": [
                        "obj-79",
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
                    "midpoints": [
                        63.5,
                        294.0,
                        129.5,
                        294.0
                    ],
                    "source": [
                        "obj-8",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-11",
                        0
                    ],
                    "midpoints": [
                        46.5,
                        297.0,
                        229.5,
                        297.0
                    ],
                    "source": [
                        "obj-8",
                        1
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
                        29.5,
                        288.0,
                        6.0,
                        288.0,
                        6.0,
                        369.0,
                        339.0,
                        369.0,
                        339.0,
                        324.0,
                        336.0,
                        324.0,
                        336.0,
                        297.0,
                        349.5,
                        297.0
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
                        "obj-9",
                        0
                    ],
                    "midpoints": [
                        80.5,
                        288.0,
                        29.5,
                        288.0
                    ],
                    "source": [
                        "obj-8",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-79",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        1701.0,
                        15.0,
                        1701.0,
                        15.0,
                        1674.0,
                        29.5,
                        1674.0
                    ],
                    "source": [
                        "obj-80",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        1731.0,
                        6.0,
                        1731.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-81",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-86",
                        0
                    ],
                    "source": [
                        "obj-84",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-84",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        1827.0,
                        15.0,
                        1827.0,
                        15.0,
                        1800.0,
                        29.5,
                        1800.0
                    ],
                    "source": [
                        "obj-85",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        1857.0,
                        6.0,
                        1857.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-86",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-90",
                        0
                    ],
                    "source": [
                        "obj-88",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-88",
                        0
                    ],
                    "midpoints": [
                        139.5,
                        1911.0,
                        15.0,
                        1911.0,
                        15.0,
                        1881.0,
                        29.5,
                        1881.0
                    ],
                    "source": [
                        "obj-89",
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
                    "source": [
                        "obj-9",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        29.5,
                        1938.0,
                        6.0,
                        1938.0,
                        6.0,
                        387.0,
                        140.5,
                        387.0
                    ],
                    "source": [
                        "obj-90",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-94",
                        0
                    ],
                    "source": [
                        "obj-92",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-92",
                        0
                    ],
                    "midpoints": [
                        399.5,
                        606.0,
                        276.0,
                        606.0,
                        276.0,
                        579.0,
                        289.5,
                        579.0
                    ],
                    "source": [
                        "obj-93",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        289.5,
                        633.0,
                        231.0,
                        633.0,
                        231.0,
                        399.0,
                        140.5,
                        399.0
                    ],
                    "source": [
                        "obj-94",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-98",
                        0
                    ],
                    "source": [
                        "obj-96",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-96",
                        0
                    ],
                    "midpoints": [
                        399.5,
                        687.0,
                        276.0,
                        687.0,
                        276.0,
                        660.0,
                        289.5,
                        660.0
                    ],
                    "source": [
                        "obj-97",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-17",
                        1
                    ],
                    "midpoints": [
                        289.5,
                        717.0,
                        231.0,
                        717.0,
                        231.0,
                        399.0,
                        140.5,
                        399.0
                    ],
                    "source": [
                        "obj-98",
                        0
                    ]
                }
            }
        ],
        "autosave": 0
    }
}