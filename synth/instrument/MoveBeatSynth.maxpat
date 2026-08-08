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
            60.0,
            80.0,
            1180.0,
            980.0
        ],
        "openinpresentation": 1,
        "boxes": [
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        8.0,
                        400.0,
                        20.0
                    ],
                    "text": "MoveBeat — SYNTH DEVICE",
                    "fontsize": 18.0,
                    "id": "obj-1"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        34.0,
                        820.0,
                        60.0
                    ],
                    "text": "A complete standalone instrument. Plays from MIDI or the on-screen keyboard; no camera, no Kinect, no Windows-only objects — runs on macOS by itself. Movement control is optional and arrives as normalised OSC on port 7500 from MoveBeatController.maxpat. See synth/docs/MAPPING.md for the protocol.",
                    "linecount": 3,
                    "id": "obj-2"
                }
            },
            {
                "box": {
                    "maxclass": "kslider",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        96.0,
                        336.0,
                        53.0
                    ],
                    "outlettype": [
                        "int",
                        "int"
                    ],
                    "mode": 2,
                    "parameter_enable": 0,
                    "id": "obj-3",
                    "presentation": 1,
                    "presentation_rect": [
                        20.0,
                        640.0,
                        336.0,
                        53.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "notein",
                    "id": "obj-4"
                }
            },
            {
                "box": {
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
                    "text": "pack 0 0",
                    "id": "obj-5"
                }
            },
            {
                "box": {
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
                    "text": "poly 8 1",
                    "id": "obj-6"
                }
            },
            {
                "box": {
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
                    "text": "pack 0 0 0",
                    "id": "obj-7"
                }
            },
            {
                "box": {
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
                    "text": "t b l l l",
                    "id": "obj-8"
                }
            },
            {
                "box": {
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
                    "text": "unpack 0 0 0",
                    "id": "obj-9"
                }
            },
            {
                "box": {
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
                    "text": "unpack 0 0 0",
                    "id": "obj-10"
                }
            },
            {
                "box": {
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
                    "text": "unpack 0 0 0",
                    "id": "obj-11"
                }
            },
            {
                "box": {
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
                    "text": "prepend target",
                    "id": "obj-12"
                }
            },
            {
                "box": {
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
                    "text": "prepend velocity",
                    "id": "obj-13"
                }
            },
            {
                "box": {
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
                    "text": "target 0",
                    "id": "obj-14"
                }
            },
            {
                "box": {
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
                    "text": "loadbang",
                    "id": "obj-15"
                }
            },
            {
                "box": {
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
                    "text": "t b b",
                    "id": "obj-16"
                }
            },
            {
                "box": {
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
                    "text": "poly~ mb_voice 8",
                    "id": "obj-17"
                }
            },
            {
                "box": {
                    "maxclass": "ezdac~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        452.0,
                        45.0,
                        45.0
                    ],
                    "id": "obj-18",
                    "presentation": 1,
                    "presentation_rect": [
                        380.0,
                        640.0,
                        45.0,
                        45.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        74.0,
                        464.0,
                        110.0,
                        20.0
                    ],
                    "text": "audio on/off",
                    "id": "obj-19"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        560.0,
                        96.0,
                        300.0,
                        20.0
                    ],
                    "text": "movement control in (optional)",
                    "id": "obj-20"
                }
            },
            {
                "box": {
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
                            120.0,
                            140.0,
                            1000.0,
                            620.0
                        ],
                        "boxes": [
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        20.0,
                                        10.0,
                                        900.0,
                                        60.0
                                    ],
                                    "text": "Control input — normalised OSC from MoveBeatController.maxpat (see docs/MAPPING.md). Every address carries ONE float in 0..1; this subpatch owns the parameter RANGES, so any controller (Kinect, MoveNet, a hardware box) can drive the synth without knowing what a Moog ladder is. Nothing here is camera-specific.",
                                    "linecount": 3,
                                    "id": "obj-1"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        30.0,
                                        82.0,
                                        120.0,
                                        22.0
                                    ],
                                    "text": "udpreceive 7500",
                                    "id": "obj-2"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 6,
                                    "outlettype": [
                                        "",
                                        "",
                                        "",
                                        "",
                                        "",
                                        ""
                                    ],
                                    "patching_rect": [
                                        30.0,
                                        118.0,
                                        620.0,
                                        22.0
                                    ],
                                    "text": "route /movebeat/cutoff /movebeat/resonance /movebeat/drive /movebeat/outgain /movebeat/gate",
                                    "id": "obj-3"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        520.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "param messages → poly~ inlet 2",
                                    "id": "obj-4"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        760.0,
                                        520.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "body tracked (0/1)",
                                    "id": "obj-5"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        30.0,
                                        170.0,
                                        80.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "id": "obj-6"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        30.0,
                                        206.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "expr 100. * pow(80., $f1)",
                                    "id": "obj-7"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        30.0,
                                        300.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "prepend cutoff",
                                    "id": "obj-8"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        230.0,
                                        208.0,
                                        460.0,
                                        20.0
                                    ],
                                    "text": "exponential — musical sweep, and the voice's [line~] ramps it over 25 ms",
                                    "id": "obj-9"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        240.0,
                                        170.0,
                                        80.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "id": "obj-10"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        240.0,
                                        206.0,
                                        60.0,
                                        22.0
                                    ],
                                    "text": "* 3.5",
                                    "id": "obj-11"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        240.0,
                                        240.0,
                                        84.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "id": "obj-12"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ],
                                    "patching_rect": [
                                        240.0,
                                        268.0,
                                        76.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "id": "obj-13"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        240.0,
                                        300.0,
                                        120.0,
                                        22.0
                                    ],
                                    "text": "prepend resonance",
                                    "id": "obj-14"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        415.0,
                                        170.0,
                                        80.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "id": "obj-15"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        415.0,
                                        240.0,
                                        84.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "id": "obj-16"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ],
                                    "patching_rect": [
                                        415.0,
                                        268.0,
                                        76.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "id": "obj-17"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        415.0,
                                        300.0,
                                        120.0,
                                        22.0
                                    ],
                                    "text": "prepend drive",
                                    "id": "obj-18"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        590.0,
                                        170.0,
                                        80.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "id": "obj-19"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        590.0,
                                        240.0,
                                        84.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 25",
                                    "id": "obj-20"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "outlettype": [
                                        "",
                                        "bang"
                                    ],
                                    "patching_rect": [
                                        590.0,
                                        268.0,
                                        76.0,
                                        22.0
                                    ],
                                    "text": "line 0. 5",
                                    "id": "obj-21"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        590.0,
                                        300.0,
                                        120.0,
                                        22.0
                                    ],
                                    "text": "prepend outgain",
                                    "id": "obj-22"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        240.0,
                                        340.0,
                                        620.0,
                                        60.0
                                    ],
                                    "text": "[pack]→[line] ramps each value over 25 ms at a 5 ms grain, turning the 30 Hz camera stream into a 200 Hz parameter stream. gen~ Params are set by message and are NOT interpolated by gen~ itself, so without this outgain clicks on fast moves.",
                                    "linecount": 3,
                                    "id": "obj-23"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-3",
                                        0
                                    ],
                                    "source": [
                                        "obj-2",
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
                                        "obj-3",
                                        0
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
                                        "obj-8",
                                        0
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
                                        "obj-4",
                                        0
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
                                        "obj-10",
                                        0
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
                                        "obj-11",
                                        0
                                    ],
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
                                        0
                                    ],
                                    "source": [
                                        "obj-11",
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
                                    "source": [
                                        "obj-12",
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
                                        "obj-13",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-4",
                                        0
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
                                        "obj-15",
                                        0
                                    ],
                                    "source": [
                                        "obj-3",
                                        2
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
                                        "obj-17",
                                        0
                                    ],
                                    "source": [
                                        "obj-16",
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
                                    "source": [
                                        "obj-17",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-4",
                                        0
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
                                        "obj-19",
                                        0
                                    ],
                                    "source": [
                                        "obj-3",
                                        3
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
                                        "obj-19",
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
                                    "source": [
                                        "obj-20",
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
                                        "obj-21",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-4",
                                        0
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
                                        "obj-5",
                                        0
                                    ],
                                    "source": [
                                        "obj-3",
                                        4
                                    ]
                                }
                            }
                        ],
                        "autosave": 0
                    },
                    "patching_rect": [
                        560.0,
                        120.0,
                        110.0,
                        22.0
                    ],
                    "text": "p mb_ctrl_in",
                    "id": "obj-21"
                }
            },
            {
                "box": {
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        700.0,
                        168.0,
                        24.0,
                        24.0
                    ],
                    "outlettype": [
                        "int"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-22",
                    "presentation": 1,
                    "presentation_rect": [
                        452.0,
                        640.0,
                        24.0,
                        24.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        730.0,
                        170.0,
                        110.0,
                        20.0
                    ],
                    "text": "body tracked",
                    "id": "obj-23"
                }
            },
            {
                "box": {
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
                    "text": "—",
                    "id": "obj-24"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        560.0,
                        196.0,
                        220.0,
                        20.0
                    ],
                    "text": "last parameter received",
                    "id": "obj-25"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        62.0,
                        620.0,
                        20.0
                    ],
                    "text": "SYNTH PANEL — every parameter is playable without a controller",
                    "fontsize": 13.0,
                    "id": "obj-26",
                    "presentation": 1,
                    "presentation_rect": [
                        20.0,
                        20.0,
                        620.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        560.0,
                        200.0,
                        20.0
                    ],
                    "text": "OSCILLATORS",
                    "fontsize": 12.0,
                    "id": "obj-27",
                    "presentation": 1,
                    "presentation_rect": [
                        20.0,
                        96.0,
                        210.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        584.0,
                        150.0,
                        20.0
                    ],
                    "text": "osc 1 wave",
                    "id": "obj-28",
                    "presentation": 1,
                    "presentation_rect": [
                        20.0,
                        123.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        20.0,
                        606.0,
                        100.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "saw",
                        ",",
                        "square",
                        ",",
                        "triangle",
                        ",",
                        "sine"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-29",
                    "presentation": 1,
                    "presentation_rect": [
                        152.0,
                        120.0,
                        76.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0",
                    "id": "obj-30"
                }
            },
            {
                "box": {
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
                    "text": "osc1wave $1",
                    "id": "obj-31"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        666.0,
                        150.0,
                        20.0
                    ],
                    "text": "osc 2 wave",
                    "id": "obj-32",
                    "presentation": 1,
                    "presentation_rect": [
                        20.0,
                        149.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        20.0,
                        688.0,
                        100.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "saw",
                        ",",
                        "square",
                        ",",
                        "triangle",
                        ",",
                        "sine"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-33",
                    "presentation": 1,
                    "presentation_rect": [
                        152.0,
                        146.0,
                        76.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0",
                    "id": "obj-34"
                }
            },
            {
                "box": {
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
                    "text": "osc2wave $1",
                    "id": "obj-35"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        748.0,
                        150.0,
                        20.0
                    ],
                    "text": "osc 1 level  0–1",
                    "id": "obj-36",
                    "presentation": 1,
                    "presentation_rect": [
                        20.0,
                        175.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        770.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-37",
                    "presentation": 1,
                    "presentation_rect": [
                        152.0,
                        172.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0.8",
                    "id": "obj-38"
                }
            },
            {
                "box": {
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
                    "text": "osc1level $1",
                    "id": "obj-39"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        830.0,
                        150.0,
                        20.0
                    ],
                    "text": "osc 2 level  0–1",
                    "id": "obj-40",
                    "presentation": 1,
                    "presentation_rect": [
                        20.0,
                        201.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        852.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-41",
                    "presentation": 1,
                    "presentation_rect": [
                        152.0,
                        198.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0.6",
                    "id": "obj-42"
                }
            },
            {
                "box": {
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
                    "text": "osc2level $1",
                    "id": "obj-43"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        912.0,
                        150.0,
                        20.0
                    ],
                    "text": "sub level  0–1",
                    "id": "obj-44",
                    "presentation": 1,
                    "presentation_rect": [
                        20.0,
                        227.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        934.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-45",
                    "presentation": 1,
                    "presentation_rect": [
                        152.0,
                        224.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0.4",
                    "id": "obj-46"
                }
            },
            {
                "box": {
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
                    "text": "sublevel $1",
                    "id": "obj-47"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        994.0,
                        150.0,
                        20.0
                    ],
                    "text": "detune  −24…24 st",
                    "id": "obj-48",
                    "presentation": 1,
                    "presentation_rect": [
                        20.0,
                        253.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        1016.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-49",
                    "presentation": 1,
                    "presentation_rect": [
                        152.0,
                        250.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0.0",
                    "id": "obj-50"
                }
            },
            {
                "box": {
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
                    "text": "detune $1",
                    "id": "obj-51"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1076.0,
                        150.0,
                        20.0
                    ],
                    "text": "pulse width",
                    "id": "obj-52",
                    "presentation": 1,
                    "presentation_rect": [
                        20.0,
                        279.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        1098.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-53",
                    "presentation": 1,
                    "presentation_rect": [
                        152.0,
                        276.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0.5",
                    "id": "obj-54"
                }
            },
            {
                "box": {
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
                    "text": "pw $1",
                    "id": "obj-55"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1178.0,
                        200.0,
                        20.0
                    ],
                    "text": "FILTER",
                    "fontsize": 12.0,
                    "id": "obj-56",
                    "presentation": 1,
                    "presentation_rect": [
                        260.0,
                        96.0,
                        210.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1202.0,
                        150.0,
                        20.0
                    ],
                    "text": "cutoff  20–18k Hz",
                    "id": "obj-57",
                    "presentation": 1,
                    "presentation_rect": [
                        260.0,
                        123.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        1224.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-58",
                    "presentation": 1,
                    "presentation_rect": [
                        392.0,
                        120.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "1200",
                    "id": "obj-59"
                }
            },
            {
                "box": {
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
                    "text": "cutoff $1",
                    "id": "obj-60"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1284.0,
                        150.0,
                        20.0
                    ],
                    "text": "resonance  0–4",
                    "id": "obj-61",
                    "presentation": 1,
                    "presentation_rect": [
                        260.0,
                        149.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        1306.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-62",
                    "presentation": 1,
                    "presentation_rect": [
                        392.0,
                        146.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0.6",
                    "id": "obj-63"
                }
            },
            {
                "box": {
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
                    "text": "resonance $1",
                    "id": "obj-64"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1366.0,
                        150.0,
                        20.0
                    ],
                    "text": "drive  0–1",
                    "id": "obj-65",
                    "presentation": 1,
                    "presentation_rect": [
                        260.0,
                        175.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        1388.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-66",
                    "presentation": 1,
                    "presentation_rect": [
                        392.0,
                        172.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0.0",
                    "id": "obj-67"
                }
            },
            {
                "box": {
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
                    "text": "drive $1",
                    "id": "obj-68"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1448.0,
                        150.0,
                        20.0
                    ],
                    "text": "res comp  0–1",
                    "id": "obj-69",
                    "presentation": 1,
                    "presentation_rect": [
                        260.0,
                        201.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        1470.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-70",
                    "presentation": 1,
                    "presentation_rect": [
                        392.0,
                        198.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0.0",
                    "id": "obj-71"
                }
            },
            {
                "box": {
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
                    "text": "rescomp $1",
                    "id": "obj-72"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1550.0,
                        200.0,
                        20.0
                    ],
                    "text": "LFO",
                    "fontsize": 12.0,
                    "id": "obj-73",
                    "presentation": 1,
                    "presentation_rect": [
                        260.0,
                        238.0,
                        210.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1574.0,
                        150.0,
                        20.0
                    ],
                    "text": "lfo rate  Hz",
                    "id": "obj-74",
                    "presentation": 1,
                    "presentation_rect": [
                        260.0,
                        265.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        1596.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-75",
                    "presentation": 1,
                    "presentation_rect": [
                        392.0,
                        262.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "2",
                    "id": "obj-76"
                }
            },
            {
                "box": {
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
                    "text": "lfoRate $1",
                    "id": "obj-77"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1656.0,
                        150.0,
                        20.0
                    ],
                    "text": "lfo depth  Hz",
                    "id": "obj-78",
                    "presentation": 1,
                    "presentation_rect": [
                        260.0,
                        291.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        1678.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-79",
                    "presentation": 1,
                    "presentation_rect": [
                        392.0,
                        288.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "500",
                    "id": "obj-80"
                }
            },
            {
                "box": {
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
                    "text": "lfoDepth $1",
                    "id": "obj-81"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1758.0,
                        200.0,
                        20.0
                    ],
                    "text": "AMP ENVELOPE",
                    "fontsize": 12.0,
                    "id": "obj-82",
                    "presentation": 1,
                    "presentation_rect": [
                        500.0,
                        96.0,
                        210.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1782.0,
                        150.0,
                        20.0
                    ],
                    "text": "attack  ms",
                    "id": "obj-83",
                    "presentation": 1,
                    "presentation_rect": [
                        500.0,
                        123.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        1804.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-84",
                    "presentation": 1,
                    "presentation_rect": [
                        632.0,
                        120.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "10",
                    "id": "obj-85"
                }
            },
            {
                "box": {
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
                    "text": "ampA $1",
                    "id": "obj-86"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1864.0,
                        150.0,
                        20.0
                    ],
                    "text": "decay  ms",
                    "id": "obj-87",
                    "presentation": 1,
                    "presentation_rect": [
                        500.0,
                        149.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        1886.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-88",
                    "presentation": 1,
                    "presentation_rect": [
                        632.0,
                        146.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "200",
                    "id": "obj-89"
                }
            },
            {
                "box": {
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
                    "text": "ampD $1",
                    "id": "obj-90"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        560.0,
                        150.0,
                        20.0
                    ],
                    "text": "sustain  0–1",
                    "id": "obj-91",
                    "presentation": 1,
                    "presentation_rect": [
                        500.0,
                        175.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        280.0,
                        582.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-92",
                    "presentation": 1,
                    "presentation_rect": [
                        632.0,
                        172.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0.8",
                    "id": "obj-93"
                }
            },
            {
                "box": {
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
                    "text": "ampS $1",
                    "id": "obj-94"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        642.0,
                        150.0,
                        20.0
                    ],
                    "text": "release  ms",
                    "id": "obj-95",
                    "presentation": 1,
                    "presentation_rect": [
                        500.0,
                        201.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        280.0,
                        664.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-96",
                    "presentation": 1,
                    "presentation_rect": [
                        632.0,
                        198.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "400",
                    "id": "obj-97"
                }
            },
            {
                "box": {
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
                    "text": "ampR $1",
                    "id": "obj-98"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        744.0,
                        200.0,
                        20.0
                    ],
                    "text": "PLAY",
                    "fontsize": 12.0,
                    "id": "obj-99",
                    "presentation": 1,
                    "presentation_rect": [
                        500.0,
                        238.0,
                        210.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        768.0,
                        150.0,
                        20.0
                    ],
                    "text": "glide  ms",
                    "id": "obj-100",
                    "presentation": 1,
                    "presentation_rect": [
                        500.0,
                        265.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        280.0,
                        790.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-101",
                    "presentation": 1,
                    "presentation_rect": [
                        632.0,
                        262.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0",
                    "id": "obj-102"
                }
            },
            {
                "box": {
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
                    "text": "glide $1",
                    "id": "obj-103"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        850.0,
                        150.0,
                        20.0
                    ],
                    "text": "out gain  0–1",
                    "id": "obj-104",
                    "presentation": 1,
                    "presentation_rect": [
                        500.0,
                        291.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        280.0,
                        872.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-105",
                    "presentation": 1,
                    "presentation_rect": [
                        632.0,
                        288.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0.5",
                    "id": "obj-106"
                }
            },
            {
                "box": {
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
                    "text": "outgain $1",
                    "id": "obj-107"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        952.0,
                        200.0,
                        20.0
                    ],
                    "text": "FILTER ENVELOPE",
                    "fontsize": 12.0,
                    "id": "obj-108",
                    "presentation": 1,
                    "presentation_rect": [
                        740.0,
                        96.0,
                        210.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        976.0,
                        150.0,
                        20.0
                    ],
                    "text": "attack  ms",
                    "id": "obj-109",
                    "presentation": 1,
                    "presentation_rect": [
                        740.0,
                        123.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        280.0,
                        998.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-110",
                    "presentation": 1,
                    "presentation_rect": [
                        872.0,
                        120.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "5",
                    "id": "obj-111"
                }
            },
            {
                "box": {
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
                    "text": "filtA $1",
                    "id": "obj-112"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        1058.0,
                        150.0,
                        20.0
                    ],
                    "text": "decay  ms",
                    "id": "obj-113",
                    "presentation": 1,
                    "presentation_rect": [
                        740.0,
                        149.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        280.0,
                        1080.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-114",
                    "presentation": 1,
                    "presentation_rect": [
                        872.0,
                        146.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "200",
                    "id": "obj-115"
                }
            },
            {
                "box": {
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
                    "text": "filtD $1",
                    "id": "obj-116"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        1140.0,
                        150.0,
                        20.0
                    ],
                    "text": "sustain  0–1",
                    "id": "obj-117",
                    "presentation": 1,
                    "presentation_rect": [
                        740.0,
                        175.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        280.0,
                        1162.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-118",
                    "presentation": 1,
                    "presentation_rect": [
                        872.0,
                        172.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "0.5",
                    "id": "obj-119"
                }
            },
            {
                "box": {
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
                    "text": "filtS $1",
                    "id": "obj-120"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        1222.0,
                        150.0,
                        20.0
                    ],
                    "text": "release  ms",
                    "id": "obj-121",
                    "presentation": 1,
                    "presentation_rect": [
                        740.0,
                        201.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        280.0,
                        1244.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-122",
                    "presentation": 1,
                    "presentation_rect": [
                        872.0,
                        198.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "300",
                    "id": "obj-123"
                }
            },
            {
                "box": {
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
                    "text": "filtR $1",
                    "id": "obj-124"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        1304.0,
                        150.0,
                        20.0
                    ],
                    "text": "env amount  Hz",
                    "id": "obj-125",
                    "presentation": 1,
                    "presentation_rect": [
                        740.0,
                        227.0,
                        130.0,
                        20.0
                    ]
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        280.0,
                        1326.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-126",
                    "presentation": 1,
                    "presentation_rect": [
                        872.0,
                        224.0,
                        70.0,
                        22.0
                    ]
                }
            },
            {
                "box": {
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
                    "text": "2000",
                    "id": "obj-127"
                }
            },
            {
                "box": {
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
                    "text": "filtEnvAmt $1",
                    "id": "obj-128"
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
                        "obj-3",
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
                        "obj-4",
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
                        "obj-4",
                        1
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
                        "obj-7",
                        1
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
                        2
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
                        "obj-8",
                        0
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
                        "obj-9",
                        0
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
                        "obj-10",
                        0
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
                    "source": [
                        "obj-8",
                        1
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
                        "obj-13",
                        0
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
                        "obj-14",
                        0
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
                    "source": [
                        "obj-16",
                        1
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
                        0
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
                        "obj-17",
                        1
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
                    "source": [
                        "obj-14",
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
                        1
                    ],
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
                    "source": [
                        "obj-21",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-30",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-30",
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
                        "obj-17",
                        1
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
                        "obj-34",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-34",
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
                        "obj-17",
                        1
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
                        "obj-38",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-38",
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
                        "obj-17",
                        1
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
                        "obj-42",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-42",
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
                        "obj-17",
                        1
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
                        "obj-46",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                        "obj-46",
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
                        "obj-17",
                        1
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
                        "obj-50",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-50",
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
                        "obj-17",
                        1
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
                        "obj-54",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-54",
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
                        "obj-17",
                        1
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
                        "obj-59",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-59",
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
                        "obj-17",
                        1
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
                        "obj-63",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-63",
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
                        "obj-17",
                        1
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
                        "obj-67",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-67",
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
                        "obj-17",
                        1
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
                        "obj-71",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-71",
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
                        "obj-17",
                        1
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
                        "obj-76",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-76",
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
                        "obj-17",
                        1
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
                        "obj-80",
                        0
                    ],
                    "source": [
                        "obj-16",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-79",
                        0
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
                        "obj-17",
                        1
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
                        "obj-85",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-85",
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
                        "obj-17",
                        1
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
                        "obj-89",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-89",
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
                        "obj-17",
                        1
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
                        "obj-93",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-93",
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
                        "obj-17",
                        1
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
                        "obj-97",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-97",
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
                        "obj-17",
                        1
                    ],
                    "source": [
                        "obj-98",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-102",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-102",
                        0
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
                        "obj-17",
                        1
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
                        "obj-106",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-106",
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
                        "obj-17",
                        1
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
                        "obj-111",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-111",
                        0
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
                        "obj-17",
                        1
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
                        "obj-115",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-115",
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
                        "obj-17",
                        1
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
                        "obj-119",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-119",
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
                        "obj-17",
                        1
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
                        "obj-123",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-123",
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
                        "obj-17",
                        1
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
                        "obj-127",
                        0
                    ],
                    "source": [
                        "obj-16",
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
                    "source": [
                        "obj-127",
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
                        "obj-17",
                        1
                    ],
                    "source": [
                        "obj-128",
                        0
                    ]
                }
            }
        ],
        "autosave": 0
    }
}
