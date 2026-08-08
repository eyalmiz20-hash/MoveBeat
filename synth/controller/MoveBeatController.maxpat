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
            1240.0,
            900.0
        ],
        "boxes": [
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        8.0,
                        560.0,
                        20.0
                    ],
                    "text": "MoveBeat — CAMERA / MOVEMENT CONTROLLER",
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
                        900.0,
                        60.0
                    ],
                    "text": "Turns body movement into normalised 0..1 control values and sends them to MoveBeatSynth.maxpat as OSC on port 7500. Two input sources: the live Kinect stream from the Windows PC, or the built-in mock body for working on the Mac with no camera attached. The synth never sees a joint — only 0..1 features.",
                    "linecount": 3,
                    "id": "obj-2"
                }
            },
            {
                "box": {
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        20.0,
                        100.0,
                        250.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "LIVE — Kinect via OSC 7400",
                        ",",
                        "MOCK — sliders / auto motion"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-3"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        102.0,
                        140.0,
                        20.0
                    ],
                    "text": "input source",
                    "id": "obj-4"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [
                        "int",
                        "int"
                    ],
                    "patching_rect": [
                        20.0,
                        132.0,
                        50.0,
                        22.0
                    ],
                    "text": "t i i",
                    "id": "obj-5"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "patching_rect": [
                        20.0,
                        164.0,
                        50.0,
                        22.0
                    ],
                    "text": "== 0",
                    "id": "obj-6"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [
                        "int"
                    ],
                    "patching_rect": [
                        120.0,
                        164.0,
                        50.0,
                        22.0
                    ],
                    "text": "== 1",
                    "id": "obj-7"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 8,
                    "outlettype": [
                        "",
                        "",
                        "",
                        "",
                        "",
                        "",
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
                            940.0,
                            480.0
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
                                        880.0,
                                        80.0
                                    ],
                                    "text": "LIVE KINECT INPUT — the only camera-facing part of this repo's Max side. One OSC bundle per frame from MoveBeat.exe on the Windows PC (wired LAN 192.168.0.x). udpreceive unpacks the bundle; each message is /mb/<lowercase JointType> x y z trackingState, state 0=NotTracked 1=Inferred 2=Tracked. Do NOT rename these addresses — cross-machine contract, see CLAUDE.md.",
                                    "linecount": 4,
                                    "id": "obj-1"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        96.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "enable (1 = LIVE selected)",
                                    "id": "obj-2"
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
                                        110.0,
                                        96.0,
                                        120.0,
                                        22.0
                                    ],
                                    "text": "udpreceive 7400",
                                    "id": "obj-3"
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
                                        110.0,
                                        140.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "id": "obj-4"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        172.0,
                                        142.0,
                                        520.0,
                                        20.0
                                    ],
                                    "text": "muted unless LIVE is selected, so the PC's stream cannot fight the mock body",
                                    "id": "obj-5"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [
                                        "",
                                        ""
                                    ],
                                    "patching_rect": [
                                        110.0,
                                        184.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "route /mb/tracked",
                                    "id": "obj-6"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 7,
                                    "outlettype": [
                                        "",
                                        "",
                                        "",
                                        "",
                                        "",
                                        "",
                                        ""
                                    ],
                                    "patching_rect": [
                                        110.0,
                                        224.0,
                                        560.0,
                                        22.0
                                    ],
                                    "text": "route /mb/head /mb/handleft /mb/handright /mb/spinemid /mb/spinebase /mb/spineshoulder",
                                    "id": "obj-7"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        110.0,
                                        340.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "tracked (0/1)",
                                    "id": "obj-8"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        180.0,
                                        340.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "head x y z state",
                                    "id": "obj-9"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        254.0,
                                        340.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "handleft x y z state",
                                    "id": "obj-10"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        328.0,
                                        340.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "handright x y z state",
                                    "id": "obj-11"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        402.0,
                                        340.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "spinemid x y z state",
                                    "id": "obj-12"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        476.0,
                                        340.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "spinebase x y z state",
                                    "id": "obj-13"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        550.0,
                                        340.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "spineshoulder x y z state",
                                    "id": "obj-14"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        624.0,
                                        340.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "other /mb/ joints (unrouted)",
                                    "id": "obj-15"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-4",
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
                                        "obj-4",
                                        1
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
                                        "obj-6",
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
                                        "obj-7",
                                        0
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
                                        "obj-8",
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
                                        "obj-9",
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
                                        "obj-10",
                                        0
                                    ],
                                    "source": [
                                        "obj-7",
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
                                        "obj-7",
                                        2
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
                                        "obj-7",
                                        3
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
                                        "obj-7",
                                        4
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
                                        "obj-7",
                                        5
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
                                        "obj-7",
                                        6
                                    ]
                                }
                            }
                        ],
                        "autosave": 0
                    },
                    "patching_rect": [
                        20.0,
                        210.0,
                        110.0,
                        22.0
                    ],
                    "text": "p mb_osc_in",
                    "id": "obj-8"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        140.0,
                        212.0,
                        320.0,
                        20.0
                    ],
                    "text": "double-click to see the live OSC receiver",
                    "id": "obj-9"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        520.0,
                        100.0,
                        520.0,
                        20.0
                    ],
                    "text": "MOCK BODY — drag these to fake a moving person (no camera needed)",
                    "fontsize": 13.0,
                    "id": "obj-10"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 4,
                    "outlettype": [
                        "",
                        "",
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
                            140.0,
                            160.0,
                            1020.0,
                            560.0
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
                                        960.0,
                                        60.0
                                    ],
                                    "text": "Synthetic body motion for testing on the Mac with no camera. Emits COMPLETE joint messages (x y z state) at the Kinect's real ~30 Hz, exactly one per joint per frame — the same shape and rate the PC sends — so the feature maths and the smoothing see a stream indistinguishable from a real body.",
                                    "linecount": 3,
                                    "id": "obj-1"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        84.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "enable",
                                    "id": "obj-2"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        "bang"
                                    ],
                                    "patching_rect": [
                                        30.0,
                                        120.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "metro 33",
                                    "id": "obj-3"
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
                                        156.0,
                                        40.0,
                                        22.0
                                    ],
                                    "text": "f",
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
                                        100.0,
                                        156.0,
                                        44.0,
                                        22.0
                                    ],
                                    "text": "+ 1",
                                    "id": "obj-5"
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
                                        192.0,
                                        76.0,
                                        22.0
                                    ],
                                    "text": "* 0.0333",
                                    "id": "obj-6"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        116.0,
                                        194.0,
                                        220.0,
                                        20.0
                                    ],
                                    "text": "frame counter → seconds",
                                    "id": "obj-7"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 5,
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ],
                                    "patching_rect": [
                                        30.0,
                                        228.0,
                                        96.0,
                                        22.0
                                    ],
                                    "text": "t f f f f f",
                                    "id": "obj-8"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        30.0,
                                        400.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 0.4 1.8 2.",
                                    "id": "obj-9"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        250.0,
                                        400.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 0. 1.8 2.",
                                    "id": "obj-10"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        470.0,
                                        400.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0.02 1.77 2.",
                                    "id": "obj-11"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        690.0,
                                        400.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0.57 1.86 2.",
                                    "id": "obj-12"
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
                                        300.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "expr 0.25 + 0.55 * sin($f1 * 1.1)",
                                    "id": "obj-13"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        328.0,
                                        190.0,
                                        20.0
                                    ],
                                    "text": "right hand height Y",
                                    "id": "obj-14"
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
                                        226.0,
                                        300.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "expr 0.3 + 0.25 * sin($f1 * 0.7)",
                                    "id": "obj-15"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        226.0,
                                        328.0,
                                        190.0,
                                        20.0
                                    ],
                                    "text": "right hand across X",
                                    "id": "obj-16"
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
                                        422.0,
                                        300.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "expr -0.3 - 0.25 * sin($f1 * 0.7)",
                                    "id": "obj-17"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        422.0,
                                        328.0,
                                        190.0,
                                        20.0
                                    ],
                                    "text": "left hand across X",
                                    "id": "obj-18"
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
                                        618.0,
                                        300.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "expr 1.86 + 0.14 * sin($f1 * 0.4)",
                                    "id": "obj-19"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        618.0,
                                        328.0,
                                        190.0,
                                        20.0
                                    ],
                                    "text": "shoulder depth Z",
                                    "id": "obj-20"
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
                                        814.0,
                                        300.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "expr 1.77 + 0.02 * sin($f1 * 0.23)",
                                    "id": "obj-21"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        814.0,
                                        328.0,
                                        190.0,
                                        20.0
                                    ],
                                    "text": "hip depth Z",
                                    "id": "obj-22"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        470.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "handleft x y z state",
                                    "id": "obj-23"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        250.0,
                                        470.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "handright x y z state",
                                    "id": "obj-24"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        470.0,
                                        470.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "spinebase x y z state",
                                    "id": "obj-25"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        690.0,
                                        470.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "spineshoulder x y z state",
                                    "id": "obj-26"
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
                                        "obj-4",
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
                                        "obj-4",
                                        1
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
                                        "obj-6",
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
                                        "obj-8",
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
                                        "obj-13",
                                        0
                                    ],
                                    "source": [
                                        "obj-8",
                                        4
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-10",
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
                                        "obj-15",
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
                                        "obj-8",
                                        2
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
                                        "obj-17",
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
                                        "obj-8",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-12",
                                        2
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
                                        "obj-8",
                                        0
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
                                    "source": [
                                        "obj-9",
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
                                    "source": [
                                        "obj-10",
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
                                        "obj-11",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-26",
                                        0
                                    ],
                                    "source": [
                                        "obj-12",
                                        0
                                    ]
                                }
                            }
                        ],
                        "autosave": 0
                    },
                    "patching_rect": [
                        520.0,
                        130.0,
                        120.0,
                        22.0
                    ],
                    "text": "p mb_automotion",
                    "id": "obj-11"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        650.0,
                        132.0,
                        340.0,
                        20.0
                    ],
                    "text": "auto motion, runs while MOCK is selected",
                    "id": "obj-12"
                }
            },
            {
                "box": {
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        520.0,
                        190.0,
                        22.0,
                        130.0
                    ],
                    "outlettype": [
                        "float"
                    ],
                    "floatoutput": 1,
                    "min": -0.5,
                    "size": 1.5,
                    "parameter_enable": 0,
                    "id": "obj-13"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        514.0,
                        324.0,
                        90.0,
                        20.0
                    ],
                    "text": "right hand height",
                    "id": "obj-14"
                }
            },
            {
                "box": {
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        610.0,
                        190.0,
                        22.0,
                        130.0
                    ],
                    "outlettype": [
                        "float"
                    ],
                    "floatoutput": 1,
                    "min": -1.0,
                    "size": 2.0,
                    "parameter_enable": 0,
                    "id": "obj-15"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        604.0,
                        324.0,
                        90.0,
                        20.0
                    ],
                    "text": "right hand X",
                    "id": "obj-16"
                }
            },
            {
                "box": {
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        700.0,
                        190.0,
                        22.0,
                        130.0
                    ],
                    "outlettype": [
                        "float"
                    ],
                    "floatoutput": 1,
                    "min": -1.0,
                    "size": 2.0,
                    "parameter_enable": 0,
                    "id": "obj-17"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        694.0,
                        324.0,
                        90.0,
                        20.0
                    ],
                    "text": "left hand X",
                    "id": "obj-18"
                }
            },
            {
                "box": {
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        790.0,
                        190.0,
                        22.0,
                        130.0
                    ],
                    "outlettype": [
                        "float"
                    ],
                    "floatoutput": 1,
                    "min": 1.0,
                    "size": 1.5,
                    "parameter_enable": 0,
                    "id": "obj-19"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        784.0,
                        324.0,
                        90.0,
                        20.0
                    ],
                    "text": "shoulder Z",
                    "id": "obj-20"
                }
            },
            {
                "box": {
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        880.0,
                        190.0,
                        22.0,
                        130.0
                    ],
                    "outlettype": [
                        "float"
                    ],
                    "floatoutput": 1,
                    "min": 1.0,
                    "size": 1.5,
                    "parameter_enable": 0,
                    "id": "obj-21"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        874.0,
                        324.0,
                        90.0,
                        20.0
                    ],
                    "text": "hip Z",
                    "id": "obj-22"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        520.0,
                        360.0,
                        160.0,
                        22.0
                    ],
                    "text": "pak -0.3 0.4 1.8 2.",
                    "id": "obj-23"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        700.0,
                        360.0,
                        160.0,
                        22.0
                    ],
                    "text": "pak 0.3 0.4 1.8 2.",
                    "id": "obj-24"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        880.0,
                        360.0,
                        160.0,
                        22.0
                    ],
                    "text": "pak 0. 0.02 1.77 2.",
                    "id": "obj-25"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        1060.0,
                        360.0,
                        160.0,
                        22.0
                    ],
                    "text": "pak 0. 0.57 1.86 2.",
                    "id": "obj-26"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        520.0,
                        392.0,
                        460.0,
                        20.0
                    ],
                    "text": "x y z state — same shape as a real /mb/ joint message",
                    "id": "obj-27"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 5,
                    "numoutlets": 5,
                    "outlettype": [
                        "",
                        "",
                        "",
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
                            120.0,
                            1120.0,
                            760.0
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
                                        1060.0,
                                        80.0
                                    ],
                                    "text": "MOVEMENT FEATURES — raw joint metres in, normalised 0..1 out. This is the TUNING layer: the [scale] objects define how much movement counts as 'full'. Every joint is gated on trackingState == 2, so inferred or lost joints never reach the synth. Parameter ranges are NOT here — they live in the synth, so a different controller can speak the same 0..1 protocol. See docs/MAPPING.md.",
                                    "linecount": 4,
                                    "id": "obj-1"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        100.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "handleft x y z state",
                                    "id": "obj-2"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        250.0,
                                        100.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "handright x y z state",
                                    "id": "obj-3"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        700.0,
                                        100.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "spinebase x y z state",
                                    "id": "obj-4"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        880.0,
                                        100.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "spineshoulder x y z state",
                                    "id": "obj-5"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1040.0,
                                        100.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "tracked (0/1)",
                                    "id": "obj-6"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ],
                                    "patching_rect": [
                                        30.0,
                                        140.0,
                                        130.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "id": "obj-7"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        "int"
                                    ],
                                    "patching_rect": [
                                        170.0,
                                        170.0,
                                        54.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
                                    "id": "obj-8"
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
                                        202.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "id": "obj-9"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ],
                                    "patching_rect": [
                                        250.0,
                                        140.0,
                                        130.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "id": "obj-10"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        "int"
                                    ],
                                    "patching_rect": [
                                        390.0,
                                        170.0,
                                        54.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
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
                                        250.0,
                                        202.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "id": "obj-12"
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
                                        320.0,
                                        202.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "id": "obj-13"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ],
                                    "patching_rect": [
                                        700.0,
                                        140.0,
                                        130.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "id": "obj-14"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        "int"
                                    ],
                                    "patching_rect": [
                                        840.0,
                                        170.0,
                                        54.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
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
                                        700.0,
                                        202.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "id": "obj-16"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ],
                                    "patching_rect": [
                                        880.0,
                                        140.0,
                                        130.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "id": "obj-17"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        "int"
                                    ],
                                    "patching_rect": [
                                        1020.0,
                                        170.0,
                                        54.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
                                    "id": "obj-18"
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
                                        880.0,
                                        202.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "id": "obj-19"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        660.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "cutoff feature 0..1",
                                    "id": "obj-20"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        250.0,
                                        660.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "resonance feature 0..1",
                                    "id": "obj-21"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        470.0,
                                        660.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "drive feature 0..1",
                                    "id": "obj-22"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        690.0,
                                        660.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "outgain feature 0..1",
                                    "id": "obj-23"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1040.0,
                                        660.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "tracked 0/1",
                                    "id": "obj-24"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        30.0,
                                        290.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "scale -0.5 1. 0. 1.",
                                    "id": "obj-25"
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
                                        322.0,
                                        80.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "id": "obj-26"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        354.0,
                                        400.0,
                                        20.0
                                    ],
                                    "text": "right hand height → cutoff. −0.5 m lowest, +1.0 m highest.",
                                    "id": "obj-27"
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
                                        250.0,
                                        290.0,
                                        76.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0.",
                                    "id": "obj-28"
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
                                        250.0,
                                        322.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr abs($f1 - $f2)",
                                    "id": "obj-29"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        250.0,
                                        354.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "scale 0. 1.4 0. 1.",
                                    "id": "obj-30"
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
                                        250.0,
                                        386.0,
                                        80.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "id": "obj-31"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        250.0,
                                        418.0,
                                        400.0,
                                        20.0
                                    ],
                                    "text": "hand spread → resonance. 0 m together, 1.4 m fully open.",
                                    "id": "obj-32"
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
                                        470.0,
                                        290.0,
                                        76.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0.",
                                    "id": "obj-33"
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
                                        470.0,
                                        322.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr abs($f1 - $f2)",
                                    "id": "obj-34"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        470.0,
                                        354.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "scale 0. 0.35 0. 1.",
                                    "id": "obj-35"
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
                                        470.0,
                                        386.0,
                                        80.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "id": "obj-36"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        470.0,
                                        418.0,
                                        420.0,
                                        20.0
                                    ],
                                    "text": "torso lean → drive. 0.35 m of shoulder-vs-hip depth = full drive.",
                                    "id": "obj-37"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ],
                                    "patching_rect": [
                                        690.0,
                                        290.0,
                                        60.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "id": "obj-38"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        "float"
                                    ],
                                    "patching_rect": [
                                        690.0,
                                        322.0,
                                        56.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "id": "obj-39"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        "float"
                                    ],
                                    "patching_rect": [
                                        690.0,
                                        354.0,
                                        60.0,
                                        22.0
                                    ],
                                    "text": "abs 0.",
                                    "id": "obj-40"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [
                                        "",
                                        ""
                                    ],
                                    "patching_rect": [
                                        690.0,
                                        386.0,
                                        90.0,
                                        22.0
                                    ],
                                    "text": "zl stream 8",
                                    "id": "obj-41"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [
                                        "",
                                        ""
                                    ],
                                    "patching_rect": [
                                        690.0,
                                        418.0,
                                        66.0,
                                        22.0
                                    ],
                                    "text": "zl sum",
                                    "id": "obj-42"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        "float"
                                    ],
                                    "patching_rect": [
                                        690.0,
                                        450.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "/ 8.",
                                    "id": "obj-43"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [
                                        ""
                                    ],
                                    "patching_rect": [
                                        690.0,
                                        482.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "scale 0. 0.06 0. 1.",
                                    "id": "obj-44"
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
                                        690.0,
                                        514.0,
                                        80.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "id": "obj-45"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        840.0,
                                        484.0,
                                        400.0,
                                        40.0
                                    ],
                                    "text": "right hand speed → out gain. Mean |ΔY| over 8 frames (~0.27 s at 30 Hz). 0.06 m/frame counts as full speed.",
                                    "linecount": 2,
                                    "id": "obj-46"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-7",
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
                                        "obj-8",
                                        0
                                    ],
                                    "source": [
                                        "obj-7",
                                        3
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
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-9",
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
                                        "obj-10",
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
                                        "obj-11",
                                        0
                                    ],
                                    "source": [
                                        "obj-10",
                                        3
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
                                        "obj-11",
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
                                    "source": [
                                        "obj-10",
                                        1
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
                                        "obj-10",
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
                                        "obj-4",
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
                                        "obj-14",
                                        3
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
                                        "obj-16",
                                        1
                                    ],
                                    "source": [
                                        "obj-14",
                                        2
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
                                        "obj-5",
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
                                        3
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
                                        "obj-18",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-19",
                                        1
                                    ],
                                    "source": [
                                        "obj-17",
                                        2
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
                                        "obj-12",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-26",
                                        0
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
                                        "obj-20",
                                        0
                                    ],
                                    "source": [
                                        "obj-26",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-28",
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
                                        "obj-28",
                                        1
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
                                        "obj-29",
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
                                        "obj-30",
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
                                        "obj-31",
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
                                        "obj-21",
                                        0
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
                                        "obj-33",
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
                                        "obj-33",
                                        1
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
                                        "obj-34",
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
                                        "obj-35",
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
                                        "obj-36",
                                        0
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
                                        "obj-22",
                                        0
                                    ],
                                    "source": [
                                        "obj-36",
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
                                        "obj-12",
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
                                        "obj-38",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-39",
                                        1
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
                                        "obj-40",
                                        0
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
                                        "obj-41",
                                        0
                                    ],
                                    "source": [
                                        "obj-40",
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
                                        "obj-41",
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
                                        "obj-42",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-44",
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
                                        "obj-23",
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
                                        "obj-24",
                                        0
                                    ],
                                    "source": [
                                        "obj-6",
                                        0
                                    ]
                                }
                            }
                        ],
                        "autosave": 0
                    },
                    "patching_rect": [
                        20.0,
                        450.0,
                        110.0,
                        22.0
                    ],
                    "text": "p mb_features",
                    "id": "obj-28"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        140.0,
                        452.0,
                        420.0,
                        20.0
                    ],
                    "text": "double-click to tune how much movement counts as 'full'",
                    "id": "obj-29"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        496.0,
                        420.0,
                        20.0
                    ],
                    "text": "normalised features (what actually leaves this device)",
                    "id": "obj-30"
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        520.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
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
                        544.0,
                        100.0,
                        20.0
                    ],
                    "text": "cutoff",
                    "id": "obj-32"
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        130.0,
                        520.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-33"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        130.0,
                        544.0,
                        100.0,
                        20.0
                    ],
                    "text": "resonance",
                    "id": "obj-34"
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        240.0,
                        520.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-35"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        240.0,
                        544.0,
                        100.0,
                        20.0
                    ],
                    "text": "drive",
                    "id": "obj-36"
                }
            },
            {
                "box": {
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        350.0,
                        520.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-37"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        350.0,
                        544.0,
                        100.0,
                        20.0
                    ],
                    "text": "outgain",
                    "id": "obj-38"
                }
            },
            {
                "box": {
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        460.0,
                        520.0,
                        24.0,
                        24.0
                    ],
                    "outlettype": [
                        "int"
                    ],
                    "parameter_enable": 0,
                    "id": "obj-39"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        490.0,
                        522.0,
                        90.0,
                        20.0
                    ],
                    "text": "tracked",
                    "id": "obj-40"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 5,
                    "numoutlets": 1,
                    "outlettype": [
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
                            160.0,
                            180.0,
                            900.0,
                            380.0
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
                                        840.0,
                                        60.0
                                    ],
                                    "text": "THE WIRE PROTOCOL — the contract with the synth. One address per parameter, one float in 0..1. Changing an address here silently breaks the synth with no error anywhere, exactly like the /mb/ contract with the PC. Keep it in step with docs/MAPPING.md.",
                                    "linecount": 3,
                                    "id": "obj-1"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        260.0,
                                        30.0,
                                        30.0
                                    ],
                                    "comment": "OSC → udpsend",
                                    "id": "obj-2"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        96.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "cutoff feature",
                                    "id": "obj-3"
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
                                        160.0,
                                        160.0,
                                        22.0
                                    ],
                                    "text": "prepend /movebeat/cutoff",
                                    "id": "obj-4"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        195.0,
                                        96.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "resonance feature",
                                    "id": "obj-5"
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
                                        195.0,
                                        160.0,
                                        160.0,
                                        22.0
                                    ],
                                    "text": "prepend /movebeat/resonance",
                                    "id": "obj-6"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        360.0,
                                        96.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "drive feature",
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
                                        360.0,
                                        160.0,
                                        160.0,
                                        22.0
                                    ],
                                    "text": "prepend /movebeat/drive",
                                    "id": "obj-8"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        525.0,
                                        96.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "outgain feature",
                                    "id": "obj-9"
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
                                        525.0,
                                        160.0,
                                        160.0,
                                        22.0
                                    ],
                                    "text": "prepend /movebeat/outgain",
                                    "id": "obj-10"
                                }
                            },
                            {
                                "box": {
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        690.0,
                                        96.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ],
                                    "comment": "gate feature",
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
                                        690.0,
                                        160.0,
                                        160.0,
                                        22.0
                                    ],
                                    "text": "prepend /movebeat/gate",
                                    "id": "obj-12"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-4",
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
                                        "obj-2",
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
                                        "obj-2",
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
                                        "obj-2",
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
                                        "obj-9",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [
                                        "obj-2",
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
                                        "obj-2",
                                        0
                                    ],
                                    "source": [
                                        "obj-12",
                                        0
                                    ]
                                }
                            }
                        ],
                        "autosave": 0
                    },
                    "patching_rect": [
                        20.0,
                        596.0,
                        100.0,
                        22.0
                    ],
                    "text": "p mb_map",
                    "id": "obj-41"
                }
            },
            {
                "box": {
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "outlettype": [],
                    "patching_rect": [
                        20.0,
                        660.0,
                        180.0,
                        22.0
                    ],
                    "text": "udpsend 127.0.0.1 7500",
                    "id": "obj-42"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        210.0,
                        640.0,
                        480.0,
                        40.0
                    ],
                    "text": "→ MoveBeatSynth.maxpat. Both devices on this Mac, so localhost. Use the messages below to point the synth at another machine.",
                    "linecount": 2,
                    "id": "obj-43"
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
                        700.0,
                        120.0,
                        22.0
                    ],
                    "text": "host 127.0.0.1",
                    "id": "obj-44"
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
                        160.0,
                        700.0,
                        90.0,
                        22.0
                    ],
                    "text": "port 7500",
                    "id": "obj-45"
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
                        20.0,
                        740.0,
                        62.0,
                        22.0
                    ],
                    "text": "loadbang",
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
                        772.0,
                        40.0,
                        22.0
                    ],
                    "text": "0",
                    "id": "obj-47"
                }
            },
            {
                "box": {
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        70.0,
                        774.0,
                        200.0,
                        20.0
                    ],
                    "text": "start in LIVE mode",
                    "id": "obj-48"
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
                        "obj-6",
                        0
                    ],
                    "source": [
                        "obj-5",
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
                        "obj-5",
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
                        "obj-6",
                        0
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
                        "obj-7",
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
                    "source": [
                        "obj-17",
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
                    "source": [
                        "obj-15",
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
                    "source": [
                        "obj-13",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-25",
                        2
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
                        "obj-26",
                        2
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
                        "obj-28",
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
                        "obj-28",
                        1
                    ],
                    "source": [
                        "obj-11",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-28",
                        2
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
                        "obj-28",
                        3
                    ],
                    "source": [
                        "obj-11",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-28",
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
                        "obj-28",
                        1
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
                        "obj-28",
                        2
                    ],
                    "source": [
                        "obj-8",
                        5
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-28",
                        3
                    ],
                    "source": [
                        "obj-8",
                        6
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-28",
                        4
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
                        "obj-28",
                        0
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
                        "obj-28",
                        1
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
                        "obj-28",
                        2
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
                        "obj-28",
                        3
                    ],
                    "source": [
                        "obj-26",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-28",
                        4
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
                        "obj-31",
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
                        "obj-33",
                        0
                    ],
                    "source": [
                        "obj-28",
                        1
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
                        "obj-28",
                        2
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
                        "obj-28",
                        3
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
                        "obj-28",
                        4
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
                        "obj-28",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-41",
                        1
                    ],
                    "source": [
                        "obj-28",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-41",
                        2
                    ],
                    "source": [
                        "obj-28",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-41",
                        3
                    ],
                    "source": [
                        "obj-28",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-41",
                        4
                    ],
                    "source": [
                        "obj-28",
                        4
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
                        "obj-41",
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
                        "obj-44",
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
                        "obj-46",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "destination": [
                        "obj-3",
                        0
                    ],
                    "source": [
                        "obj-47",
                        0
                    ]
                }
            }
        ],
        "autosave": 0
    }
}
