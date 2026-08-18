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
            120.0,
            80.0,
            1500.0,
            1120.0
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
                        700.0,
                        27.0
                    ],
                    "text": "MoveBeat - CAMERA / MOVEMENT CONTROLLER",
                    "fontsize": 18.0
                }
            },
            {
                "box": {
                    "id": "obj-2",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        40.0,
                        1180.0,
                        20.0
                    ],
                    "text": "Six mapping slots, one per body part. Each slot picks an axis or speed from that part, sends it to any synth parameter, and locks the parameter inside a min/max range. Values on the wire are in the parameter's own units (Hz, ms, semitones); see synth/docs/MAPPING.md."
                }
            },
            {
                "box": {
                    "id": "obj-3",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        20.0,
                        92.0,
                        250.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "LIVE - Kinect via OSC 7400",
                        ",",
                        "MOCK - sliders / auto motion"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-4",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        94.0,
                        200.0,
                        20.0
                    ],
                    "text": "input source"
                }
            },
            {
                "box": {
                    "id": "obj-5",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        20.0,
                        124.0,
                        50.0,
                        22.0
                    ],
                    "text": "t i i",
                    "outlettype": [
                        "int",
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-6",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        20.0,
                        156.0,
                        50.0,
                        22.0
                    ],
                    "text": "== 0",
                    "outlettype": [
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-7",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        120.0,
                        156.0,
                        50.0,
                        22.0
                    ],
                    "text": "== 1",
                    "outlettype": [
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-8",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        400.0,
                        92.0,
                        70.0,
                        22.0
                    ],
                    "text": "loadbang",
                    "outlettype": [
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-9",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        400.0,
                        124.0,
                        40.0,
                        22.0
                    ],
                    "text": "0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-10",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        450.0,
                        126.0,
                        300.0,
                        20.0
                    ],
                    "text": "start in LIVE mode"
                }
            },
            {
                "box": {
                    "id": "obj-11",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 9,
                    "outlettype": [
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
                        20.0,
                        196.0,
                        180.0,
                        22.0
                    ],
                    "text": "p mb_osc_in",
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
                            1100.0,
                            420.0
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
                                        1000.0,
                                        27.0
                                    ],
                                    "text": "LIVE Kinect input. The only camera-facing subpatch. Gate defaults OPEN so the device still works if loadbang never runs (e.g. after editing).",
                                    "fontsize": 12.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        60.0,
                                        30.0,
                                        30.0
                                    ],
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
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        140.0,
                                        60.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "udpreceive 7400",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        140.0,
                                        110.0,
                                        90.0,
                                        22.0
                                    ],
                                    "text": "gate 1 1",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        140.0,
                                        160.0,
                                        180.0,
                                        22.0
                                    ],
                                    "text": "route /mb/tracked",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 9,
                                    "patching_rect": [
                                        140.0,
                                        210.0,
                                        760.0,
                                        22.0
                                    ],
                                    "text": "route /mb/handleft /mb/handright /mb/footleft /mb/footright /mb/head /mb/spinemid /mb/spinebase /mb/spineshoulder",
                                    "outlettype": [
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
                                    "id": "obj-7",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        330.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        120.0,
                                        330.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        210.0,
                                        330.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        300.0,
                                        330.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        390.0,
                                        330.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        480.0,
                                        330.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        570.0,
                                        330.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        660.0,
                                        330.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        750.0,
                                        330.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        300.0,
                                        80.0,
                                        20.0
                                    ],
                                    "text": "tracked"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        120.0,
                                        300.0,
                                        88.0,
                                        20.0
                                    ],
                                    "text": "handleft"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        210.0,
                                        300.0,
                                        88.0,
                                        20.0
                                    ],
                                    "text": "handright"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        300.0,
                                        300.0,
                                        88.0,
                                        20.0
                                    ],
                                    "text": "footleft"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        390.0,
                                        300.0,
                                        88.0,
                                        20.0
                                    ],
                                    "text": "footright"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        480.0,
                                        300.0,
                                        88.0,
                                        20.0
                                    ],
                                    "text": "head"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        570.0,
                                        300.0,
                                        88.0,
                                        20.0
                                    ],
                                    "text": "spinemid"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        660.0,
                                        300.0,
                                        88.0,
                                        20.0
                                    ],
                                    "text": "spinebase"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        750.0,
                                        300.0,
                                        88.0,
                                        20.0
                                    ],
                                    "text": "spineshoulder"
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
                                        "obj-4",
                                        1
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
                                        "obj-5",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-5",
                                        1
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
                                        "obj-5",
                                        0
                                    ],
                                    "destination": [
                                        "obj-7",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-8",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        1
                                    ],
                                    "destination": [
                                        "obj-9",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        2
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
                                        "obj-6",
                                        3
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
                                        "obj-6",
                                        4
                                    ],
                                    "destination": [
                                        "obj-12",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        5
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
                                        "obj-6",
                                        6
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
                                        "obj-6",
                                        7
                                    ],
                                    "destination": [
                                        "obj-15",
                                        0
                                    ]
                                }
                            }
                        ]
                    }
                }
            },
            {
                "box": {
                    "id": "obj-12",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        210.0,
                        198.0,
                        420.0,
                        20.0
                    ],
                    "text": "double-click to see the live OSC receiver"
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 9,
                    "outlettype": [
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
                        20.0,
                        236.0,
                        190.0,
                        22.0
                    ],
                    "text": "p mb_automotion",
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
                            1400.0,
                            700.0
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
                                        1200.0,
                                        27.0
                                    ],
                                    "text": "Synthetic body at the Kinect's real ~30 Hz. Emits one complete message per joint per frame, then the frame trigger last - same shape and order as the PC.",
                                    "fontsize": 12.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        60.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        100.0,
                                        90.0,
                                        22.0
                                    ],
                                    "text": "metro 33",
                                    "outlettype": [
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        140.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "f",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        90.0,
                                        170.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "+ 1",
                                    "outlettype": [
                                        "int"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        210.0,
                                        90.0,
                                        22.0
                                    ],
                                    "text": "* 0.035",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 9,
                                    "patching_rect": [
                                        30.0,
                                        250.0,
                                        420.0,
                                        22.0
                                    ],
                                    "text": "t b b b b b b b b b",
                                    "outlettype": [
                                        "bang",
                                        "bang",
                                        "bang",
                                        "bang",
                                        "bang",
                                        "bang",
                                        "bang",
                                        "bang",
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        620.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        140.0,
                                        620.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        250.0,
                                        620.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        360.0,
                                        620.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        470.0,
                                        620.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        580.0,
                                        620.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        690.0,
                                        620.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        800.0,
                                        620.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        910.0,
                                        620.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        320.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr -0.35 + 0.30*sin($f1 + 0)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        352.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 0.3 + 0.45*sin($f1*0.7 + 1.1)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        384.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 1.75 + 0.12*sin($f1*0.5 + 2.2)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        420.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0. 0. 2.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        300.0,
                                        150.0,
                                        20.0
                                    ],
                                    "text": "handleft"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        190.0,
                                        320.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 0.35 + 0.30*sin($f1 + 0.7)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        190.0,
                                        352.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 0.3 + 0.45*sin($f1*0.7 + 1.8)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        190.0,
                                        384.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 1.75 + 0.12*sin($f1*0.5 + 2.9)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-25",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        190.0,
                                        420.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0. 0. 2.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-26",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        190.0,
                                        300.0,
                                        150.0,
                                        20.0
                                    ],
                                    "text": "handright"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-27",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        350.0,
                                        320.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr -0.16 + 0.30*sin($f1 + 1.4)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-28",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        350.0,
                                        352.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr -0.92 + 0.45*sin($f1*0.7 + 2.5)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        350.0,
                                        384.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 1.8 + 0.12*sin($f1*0.5 + 3.6)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-30",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        350.0,
                                        420.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0. 0. 2.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-31",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        350.0,
                                        300.0,
                                        150.0,
                                        20.0
                                    ],
                                    "text": "footleft"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-32",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        510.0,
                                        320.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 0.16 + 0.30*sin($f1 + 2.1)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-33",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        510.0,
                                        352.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr -0.92 + 0.45*sin($f1*0.7 + 3.2)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-34",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        510.0,
                                        384.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 1.8 + 0.12*sin($f1*0.5 + 4.3)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-35",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        510.0,
                                        420.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0. 0. 2.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-36",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        510.0,
                                        300.0,
                                        150.0,
                                        20.0
                                    ],
                                    "text": "footright"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        670.0,
                                        320.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 0 + 0.30*sin($f1 + 2.8)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-38",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        670.0,
                                        352.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 0.7 + 0.45*sin($f1*0.7 + 3.9)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-39",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        670.0,
                                        384.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 1.6 + 0.12*sin($f1*0.5 + 5)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-40",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        670.0,
                                        420.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0. 0. 2.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-41",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        670.0,
                                        300.0,
                                        150.0,
                                        20.0
                                    ],
                                    "text": "head"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        830.0,
                                        320.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 0 + 0.30*sin($f1 + 3.5)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        830.0,
                                        352.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 0.2 + 0.45*sin($f1*0.7 + 4.6)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-44",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        830.0,
                                        384.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 1.7 + 0.12*sin($f1*0.5 + 5.7)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-45",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        830.0,
                                        420.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0. 0. 2.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-46",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        830.0,
                                        300.0,
                                        150.0,
                                        20.0
                                    ],
                                    "text": "spinemid"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-47",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        990.0,
                                        320.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 0 + 0.30*sin($f1 + 4.2)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-48",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        990.0,
                                        352.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr -0.1 + 0.45*sin($f1*0.7 + 5.3)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-49",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        990.0,
                                        384.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 1.6 + 0.12*sin($f1*0.5 + 6.4)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-50",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        990.0,
                                        420.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0. 0. 2.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        990.0,
                                        300.0,
                                        150.0,
                                        20.0
                                    ],
                                    "text": "spinebase"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1150.0,
                                        320.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 0 + 0.30*sin($f1 + 4.9)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-53",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1150.0,
                                        352.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 0.46 + 0.45*sin($f1*0.7 + 6)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-54",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1150.0,
                                        384.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "expr 1.62 + 0.12*sin($f1*0.5 + 7.1)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1150.0,
                                        420.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0. 0. 2.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-56",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1150.0,
                                        300.0,
                                        150.0,
                                        20.0
                                    ],
                                    "text": "spineshoulder"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-57",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        560.0,
                                        40.0,
                                        22.0
                                    ],
                                    "text": "1",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        80.0,
                                        560.0,
                                        300.0,
                                        20.0
                                    ],
                                    "text": "frame trigger, emitted last"
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
                                        0
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
                                        "obj-4",
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
                                        "obj-5",
                                        0
                                    ],
                                    "destination": [
                                        "obj-4",
                                        1
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
                                        "obj-6",
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
                                        "obj-7",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
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
                                        "obj-6",
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
                                        "obj-17",
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
                                        "obj-18",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        1
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
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        8
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
                                        "obj-9",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-22",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
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
                                        "obj-6",
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
                                        "obj-22",
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
                                        "obj-23",
                                        0
                                    ],
                                    "destination": [
                                        "obj-25",
                                        1
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
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        7
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
                                        "obj-10",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-27",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
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
                                        "obj-6",
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
                                        "obj-27",
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
                                        "obj-28",
                                        0
                                    ],
                                    "destination": [
                                        "obj-30",
                                        1
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
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        6
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
                                        "obj-11",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-32",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
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
                                        "obj-6",
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
                                        "obj-32",
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
                                        "obj-33",
                                        0
                                    ],
                                    "destination": [
                                        "obj-35",
                                        1
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
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        5
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
                                        "obj-12",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-37",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
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
                                        "obj-6",
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
                                        "obj-37",
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
                                        "obj-38",
                                        0
                                    ],
                                    "destination": [
                                        "obj-40",
                                        1
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
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        4
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
                                        "obj-13",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-42",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
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
                                        "obj-6",
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
                                        "obj-42",
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
                                        "obj-43",
                                        0
                                    ],
                                    "destination": [
                                        "obj-45",
                                        1
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
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        3
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
                                        "obj-14",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-47",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
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
                                        "obj-6",
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
                                        "obj-47",
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
                                        "obj-48",
                                        0
                                    ],
                                    "destination": [
                                        "obj-50",
                                        1
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
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        2
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
                                        "obj-15",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-52",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
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
                                        "obj-6",
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
                                        "obj-52",
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
                                        "obj-53",
                                        0
                                    ],
                                    "destination": [
                                        "obj-55",
                                        1
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
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        1
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
                                        "obj-16",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        0
                                    ],
                                    "destination": [
                                        "obj-57",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-57",
                                        0
                                    ],
                                    "destination": [
                                        "obj-8",
                                        0
                                    ]
                                }
                            }
                        ]
                    }
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        220.0,
                        238.0,
                        460.0,
                        20.0
                    ],
                    "text": "auto motion, runs while MOCK is selected"
                }
            },
            {
                "box": {
                    "id": "obj-15",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        278.0,
                        700.0,
                        20.0
                    ],
                    "text": "MOCK BODY - drag to fake a moving person (no camera needed)"
                }
            },
            {
                "box": {
                    "id": "obj-16",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "patching_rect": [
                        20.0,
                        392.0,
                        120.0,
                        22.0
                    ],
                    "text": "pak -0.35 0.3 1.75 2.",
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
                        20.0,
                        306.0,
                        124.0,
                        20.0
                    ],
                    "text": "handleft"
                }
            },
            {
                "box": {
                    "id": "obj-18",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "patching_rect": [
                        150.0,
                        392.0,
                        120.0,
                        22.0
                    ],
                    "text": "pak 0.35 0.3 1.75 2.",
                    "outlettype": [
                        ""
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
                        150.0,
                        306.0,
                        124.0,
                        20.0
                    ],
                    "text": "handright"
                }
            },
            {
                "box": {
                    "id": "obj-20",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "patching_rect": [
                        280.0,
                        392.0,
                        120.0,
                        22.0
                    ],
                    "text": "pak -0.16 -0.92 1.8 2.",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-21",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        306.0,
                        124.0,
                        20.0
                    ],
                    "text": "footleft"
                }
            },
            {
                "box": {
                    "id": "obj-22",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "patching_rect": [
                        410.0,
                        392.0,
                        120.0,
                        22.0
                    ],
                    "text": "pak 0.16 -0.92 1.8 2.",
                    "outlettype": [
                        ""
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
                        410.0,
                        306.0,
                        124.0,
                        20.0
                    ],
                    "text": "footright"
                }
            },
            {
                "box": {
                    "id": "obj-24",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "patching_rect": [
                        540.0,
                        392.0,
                        120.0,
                        22.0
                    ],
                    "text": "pak 0 0.7 1.6 2.",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-25",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        540.0,
                        306.0,
                        124.0,
                        20.0
                    ],
                    "text": "head"
                }
            },
            {
                "box": {
                    "id": "obj-26",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "patching_rect": [
                        670.0,
                        392.0,
                        120.0,
                        22.0
                    ],
                    "text": "pak 0 0.2 1.7 2.",
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
                        670.0,
                        306.0,
                        124.0,
                        20.0
                    ],
                    "text": "spinemid"
                }
            },
            {
                "box": {
                    "id": "obj-28",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "patching_rect": [
                        800.0,
                        392.0,
                        120.0,
                        22.0
                    ],
                    "text": "pak 0 -0.1 1.6 2.",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-29",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        800.0,
                        306.0,
                        124.0,
                        20.0
                    ],
                    "text": "spinebase"
                }
            },
            {
                "box": {
                    "id": "obj-30",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "patching_rect": [
                        930.0,
                        392.0,
                        120.0,
                        22.0
                    ],
                    "text": "pak 0 0.46 1.62 2.",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-31",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        930.0,
                        306.0,
                        124.0,
                        20.0
                    ],
                    "text": "spineshoulder"
                }
            },
            {
                "box": {
                    "id": "obj-32",
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        20.0,
                        330.0,
                        120.0,
                        20.0
                    ],
                    "outlettype": [
                        ""
                    ],
                    "size": 200.0,
                    "orientation": 1
                }
            },
            {
                "box": {
                    "id": "obj-33",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "patching_rect": [
                        20.0,
                        360.0,
                        124.0,
                        22.0
                    ],
                    "text": "scale 0. 199. -1 1",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-34",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        352.0,
                        124.0,
                        20.0
                    ],
                    "text": "handleft.x"
                }
            },
            {
                "box": {
                    "id": "obj-35",
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        150.0,
                        330.0,
                        120.0,
                        20.0
                    ],
                    "outlettype": [
                        ""
                    ],
                    "size": 200.0,
                    "orientation": 1
                }
            },
            {
                "box": {
                    "id": "obj-36",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "patching_rect": [
                        150.0,
                        360.0,
                        124.0,
                        22.0
                    ],
                    "text": "scale 0. 199. -1 1",
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
                        150.0,
                        352.0,
                        124.0,
                        20.0
                    ],
                    "text": "handright.x"
                }
            },
            {
                "box": {
                    "id": "obj-38",
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        280.0,
                        330.0,
                        120.0,
                        20.0
                    ],
                    "outlettype": [
                        ""
                    ],
                    "size": 200.0,
                    "orientation": 1
                }
            },
            {
                "box": {
                    "id": "obj-39",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "patching_rect": [
                        280.0,
                        360.0,
                        124.0,
                        22.0
                    ],
                    "text": "scale 0. 199. -1 1.5",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-40",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        280.0,
                        352.0,
                        124.0,
                        20.0
                    ],
                    "text": "handright.y"
                }
            },
            {
                "box": {
                    "id": "obj-41",
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        410.0,
                        330.0,
                        120.0,
                        20.0
                    ],
                    "outlettype": [
                        ""
                    ],
                    "size": 200.0,
                    "orientation": 1
                }
            },
            {
                "box": {
                    "id": "obj-42",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "patching_rect": [
                        410.0,
                        360.0,
                        124.0,
                        22.0
                    ],
                    "text": "scale 0. 199. -1 1.5",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-43",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        410.0,
                        352.0,
                        124.0,
                        20.0
                    ],
                    "text": "footleft.y"
                }
            },
            {
                "box": {
                    "id": "obj-44",
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        540.0,
                        330.0,
                        120.0,
                        20.0
                    ],
                    "outlettype": [
                        ""
                    ],
                    "size": 200.0,
                    "orientation": 1
                }
            },
            {
                "box": {
                    "id": "obj-45",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "patching_rect": [
                        540.0,
                        360.0,
                        124.0,
                        22.0
                    ],
                    "text": "scale 0. 199. -1 1.5",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-46",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        540.0,
                        352.0,
                        124.0,
                        20.0
                    ],
                    "text": "footright.y"
                }
            },
            {
                "box": {
                    "id": "obj-47",
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        670.0,
                        330.0,
                        120.0,
                        20.0
                    ],
                    "outlettype": [
                        ""
                    ],
                    "size": 200.0,
                    "orientation": 1
                }
            },
            {
                "box": {
                    "id": "obj-48",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "patching_rect": [
                        670.0,
                        360.0,
                        124.0,
                        22.0
                    ],
                    "text": "scale 0. 199. -1 1.5",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-49",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        670.0,
                        352.0,
                        124.0,
                        20.0
                    ],
                    "text": "head.y"
                }
            },
            {
                "box": {
                    "id": "obj-50",
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        800.0,
                        330.0,
                        120.0,
                        20.0
                    ],
                    "outlettype": [
                        ""
                    ],
                    "size": 200.0,
                    "orientation": 1
                }
            },
            {
                "box": {
                    "id": "obj-51",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "patching_rect": [
                        800.0,
                        360.0,
                        124.0,
                        22.0
                    ],
                    "text": "scale 0. 199. 1 2.5",
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
                        800.0,
                        352.0,
                        124.0,
                        20.0
                    ],
                    "text": "spineshoulder.z"
                }
            },
            {
                "box": {
                    "id": "obj-53",
                    "maxclass": "slider",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        930.0,
                        330.0,
                        120.0,
                        20.0
                    ],
                    "outlettype": [
                        ""
                    ],
                    "size": 200.0,
                    "orientation": 1
                }
            },
            {
                "box": {
                    "id": "obj-54",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "patching_rect": [
                        930.0,
                        360.0,
                        124.0,
                        22.0
                    ],
                    "text": "scale 0. 199. 1 2.5",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-55",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        930.0,
                        352.0,
                        124.0,
                        20.0
                    ],
                    "text": "spinebase.z"
                }
            },
            {
                "box": {
                    "id": "obj-56",
                    "maxclass": "newobj",
                    "numinlets": 9,
                    "numoutlets": 1,
                    "outlettype": [
                        ""
                    ],
                    "patching_rect": [
                        20.0,
                        436.0,
                        170.0,
                        22.0
                    ],
                    "text": "p mb_sources",
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
                            80.0,
                            80.0,
                            1900.0,
                            1200.0
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
                                        1400.0,
                                        27.0
                                    ],
                                    "text": "MOVEMENT SOURCES - every body part becomes X, Y, Z and SPEED, all normalised 0..1, plus hand SPREAD and torso LEAN. Emitted as one 27-element list per frame (element 1 is a dummy so element n = source n-2).",
                                    "fontsize": 12.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        180.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        330.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        480.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        630.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        780.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        930.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1080.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1230.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        44.0,
                                        140.0,
                                        20.0
                                    ],
                                    "text": "handleft"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        180.0,
                                        44.0,
                                        140.0,
                                        20.0
                                    ],
                                    "text": "handright"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        330.0,
                                        44.0,
                                        140.0,
                                        20.0
                                    ],
                                    "text": "footleft"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        480.0,
                                        44.0,
                                        140.0,
                                        20.0
                                    ],
                                    "text": "footright"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        630.0,
                                        44.0,
                                        140.0,
                                        20.0
                                    ],
                                    "text": "head"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        780.0,
                                        44.0,
                                        140.0,
                                        20.0
                                    ],
                                    "text": "spinemid"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        930.0,
                                        44.0,
                                        140.0,
                                        20.0
                                    ],
                                    "text": "spinebase"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1080.0,
                                        44.0,
                                        140.0,
                                        20.0
                                    ],
                                    "text": "spineshoulder"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1230.0,
                                        44.0,
                                        140.0,
                                        20.0
                                    ],
                                    "text": "frame trigger"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 27,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        1080.0,
                                        900.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0.",
                                    "outlettype": [
                                        ""
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
                                        1230.0,
                                        1040.0,
                                        40.0,
                                        22.0
                                    ],
                                    "text": "t b",
                                    "outlettype": [
                                        "bang"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "patching_rect": [
                                        30.0,
                                        110.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        170.0,
                                        146.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
                                    "outlettype": [
                                        "int"
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
                                        30.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-25",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        90.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-26",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        150.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-27",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-28",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        90.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1.5 0. 1.",
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
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        90.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-31",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        150.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale 1 4 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-32",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        150.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-33",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
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
                                        30.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-35",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-36",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        100.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        100.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-38",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        100.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-39",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        170.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-40",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        170.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
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
                                        170.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        400.0,
                                        170.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 0. 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        432.0,
                                        250.0,
                                        22.0
                                    ],
                                    "text": "expr sqrt($f1*$f1 + $f2*$f2 + $f3*$f3)",
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
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        464.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "zl stream 8",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-45",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        496.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "zl sum",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-46",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        528.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "/ 8.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-47",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        560.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "scale 0. 0.06 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
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
                                        592.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-49",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        84.0,
                                        240.0,
                                        20.0
                                    ],
                                    "text": "HAND L  (handleft)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-50",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "patching_rect": [
                                        290.0,
                                        110.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        430.0,
                                        146.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
                                    "outlettype": [
                                        "int"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        290.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-53",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        350.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
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
                                        410.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        290.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-56",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        290.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-57",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        350.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1.5 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        350.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        410.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale 1 4 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        410.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        290.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-62",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        290.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-63",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        290.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-64",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        360.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        360.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-66",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        360.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-67",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        430.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-68",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        430.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-69",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        430.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-70",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        290.0,
                                        400.0,
                                        170.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 0. 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-71",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        290.0,
                                        432.0,
                                        250.0,
                                        22.0
                                    ],
                                    "text": "expr sqrt($f1*$f1 + $f2*$f2 + $f3*$f3)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-72",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        290.0,
                                        464.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "zl stream 8",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-73",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        290.0,
                                        496.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "zl sum",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-74",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        290.0,
                                        528.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "/ 8.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-75",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        290.0,
                                        560.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "scale 0. 0.06 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-76",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        290.0,
                                        592.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-77",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        290.0,
                                        84.0,
                                        240.0,
                                        20.0
                                    ],
                                    "text": "HAND R  (handright)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-78",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "patching_rect": [
                                        550.0,
                                        110.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-79",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        690.0,
                                        146.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
                                    "outlettype": [
                                        "int"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-80",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        550.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
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
                                        610.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-82",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        670.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-83",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        550.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-84",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        550.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-85",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        610.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1.5 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-86",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        610.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-87",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        670.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale 1 4 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-88",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        670.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-89",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        550.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-90",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        550.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-91",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        550.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-92",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        620.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-93",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        620.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-94",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        620.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-95",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        690.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
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
                                        690.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-97",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        690.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-98",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        550.0,
                                        400.0,
                                        170.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 0. 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-99",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        550.0,
                                        432.0,
                                        250.0,
                                        22.0
                                    ],
                                    "text": "expr sqrt($f1*$f1 + $f2*$f2 + $f3*$f3)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-100",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        550.0,
                                        464.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "zl stream 8",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-101",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        550.0,
                                        496.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "zl sum",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-102",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        550.0,
                                        528.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "/ 8.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-103",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        550.0,
                                        560.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "scale 0. 0.06 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-104",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        550.0,
                                        592.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-105",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        550.0,
                                        84.0,
                                        240.0,
                                        20.0
                                    ],
                                    "text": "FOOT L  (footleft)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-106",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "patching_rect": [
                                        810.0,
                                        110.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-107",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        950.0,
                                        146.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
                                    "outlettype": [
                                        "int"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-108",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        810.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-109",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        870.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-110",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        930.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-111",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        810.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1 0. 1.",
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
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        810.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-113",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        870.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1.5 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-114",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        870.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-115",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        930.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale 1 4 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-116",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        930.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-117",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        810.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-118",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        810.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-119",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        810.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-120",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        880.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
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
                                        880.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-122",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        880.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-123",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        950.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-124",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        950.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-125",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        950.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-126",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        810.0,
                                        400.0,
                                        170.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 0. 0.",
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
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        810.0,
                                        432.0,
                                        250.0,
                                        22.0
                                    ],
                                    "text": "expr sqrt($f1*$f1 + $f2*$f2 + $f3*$f3)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-128",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        810.0,
                                        464.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "zl stream 8",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-129",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        810.0,
                                        496.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "zl sum",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-130",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        810.0,
                                        528.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "/ 8.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-131",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        810.0,
                                        560.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "scale 0. 0.06 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-132",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        810.0,
                                        592.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-133",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        810.0,
                                        84.0,
                                        240.0,
                                        20.0
                                    ],
                                    "text": "FOOT R  (footright)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-134",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "patching_rect": [
                                        1070.0,
                                        110.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-135",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1210.0,
                                        146.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
                                    "outlettype": [
                                        "int"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-136",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1070.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-137",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1130.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-138",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1190.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-139",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1070.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-140",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1070.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-141",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1130.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1.5 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-142",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1130.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-143",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1190.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale 1 4 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-144",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1190.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-145",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1070.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-146",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1070.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-147",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1070.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-148",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1140.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-149",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1140.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-150",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1140.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-151",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1210.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-152",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1210.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-153",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1210.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-154",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1070.0,
                                        400.0,
                                        170.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 0. 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-155",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1070.0,
                                        432.0,
                                        250.0,
                                        22.0
                                    ],
                                    "text": "expr sqrt($f1*$f1 + $f2*$f2 + $f3*$f3)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-156",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1070.0,
                                        464.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "zl stream 8",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-157",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1070.0,
                                        496.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "zl sum",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-158",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1070.0,
                                        528.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "/ 8.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-159",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1070.0,
                                        560.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "scale 0. 0.06 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-160",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1070.0,
                                        592.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-161",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1070.0,
                                        84.0,
                                        240.0,
                                        20.0
                                    ],
                                    "text": "HEAD  (head)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-162",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "patching_rect": [
                                        1330.0,
                                        110.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-163",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1470.0,
                                        146.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
                                    "outlettype": [
                                        "int"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-164",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1330.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-165",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1390.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-166",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1450.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-167",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1330.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-168",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1330.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-169",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1390.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale -1 1.5 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-170",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1390.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-171",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1450.0,
                                        222.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "scale 1 4 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-172",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1450.0,
                                        254.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-173",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1330.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-174",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1330.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-175",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1330.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-176",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1400.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-177",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1400.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-178",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1400.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-179",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1470.0,
                                        300.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-180",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1470.0,
                                        332.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "- 0.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-181",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1470.0,
                                        364.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "abs",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-182",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1330.0,
                                        400.0,
                                        170.0,
                                        22.0
                                    ],
                                    "text": "pack 0. 0. 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-183",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1330.0,
                                        432.0,
                                        250.0,
                                        22.0
                                    ],
                                    "text": "expr sqrt($f1*$f1 + $f2*$f2 + $f3*$f3)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-184",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1330.0,
                                        464.0,
                                        110.0,
                                        22.0
                                    ],
                                    "text": "zl stream 8",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-185",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        1330.0,
                                        496.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "zl sum",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-186",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1330.0,
                                        528.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "/ 8.",
                                    "outlettype": [
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-187",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1330.0,
                                        560.0,
                                        140.0,
                                        22.0
                                    ],
                                    "text": "scale 0. 0.06 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-188",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1330.0,
                                        592.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-189",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1330.0,
                                        84.0,
                                        240.0,
                                        20.0
                                    ],
                                    "text": "TORSO  (spinemid)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-190",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "patching_rect": [
                                        1590.0,
                                        110.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-191",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1730.0,
                                        146.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
                                    "outlettype": [
                                        "int"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-192",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1590.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-193",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1590.0,
                                        84.0,
                                        240.0,
                                        20.0
                                    ],
                                    "text": "spinebase  (for LEAN)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-194",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "patching_rect": [
                                        1850.0,
                                        110.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "unpack 0. 0. 0. 0.",
                                    "outlettype": [
                                        "float",
                                        "float",
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-195",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1990.0,
                                        146.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "== 2.",
                                    "outlettype": [
                                        "int"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-196",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        1850.0,
                                        182.0,
                                        50.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-197",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        1850.0,
                                        84.0,
                                        240.0,
                                        20.0
                                    ],
                                    "text": "spineshoulder  (for LEAN)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-198",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        700.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-199",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        732.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "expr abs($f1 - $f2)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-200",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        764.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "scale 0. 1.4 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-201",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        796.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-202",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        200.0,
                                        700.0,
                                        300.0,
                                        20.0
                                    ],
                                    "text": "HAND SPREAD  (source 24)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-203",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        850.0,
                                        150.0,
                                        22.0
                                    ],
                                    "text": "pak 0. 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-204",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        882.0,
                                        190.0,
                                        22.0
                                    ],
                                    "text": "expr abs($f1 - $f2)",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-205",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        914.0,
                                        160.0,
                                        22.0
                                    ],
                                    "text": "scale 0. 0.35 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-206",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        946.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "clip 0. 1.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-207",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        200.0,
                                        850.0,
                                        300.0,
                                        20.0
                                    ],
                                    "text": "TORSO LEAN  (source 25)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-208",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        1130.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "source": [
                                        "obj-10",
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
                                        "obj-20",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-2",
                                        0
                                    ],
                                    "destination": [
                                        "obj-22",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-22",
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
                                        "obj-22",
                                        0
                                    ],
                                    "destination": [
                                        "obj-24",
                                        1
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
                                        "obj-25",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-22",
                                        1
                                    ],
                                    "destination": [
                                        "obj-25",
                                        1
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
                                        "obj-26",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-22",
                                        2
                                    ],
                                    "destination": [
                                        "obj-26",
                                        1
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
                                        "obj-27",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-27",
                                        0
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
                                        "obj-20",
                                        1
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
                                        "obj-20",
                                        2
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
                                        "obj-32",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-32",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        3
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
                                        "obj-33",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-33",
                                        1
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
                                        "obj-33",
                                        0
                                    ],
                                    "destination": [
                                        "obj-34",
                                        1
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
                                        "obj-25",
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
                                        1
                                    ],
                                    "destination": [
                                        "obj-37",
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
                                        "obj-37",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-37",
                                        0
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
                                        "obj-24",
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
                                        1
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
                                        "obj-39",
                                        0
                                    ],
                                    "destination": [
                                        "obj-40",
                                        1
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
                                        "obj-42",
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
                                        "obj-42",
                                        1
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
                                        "obj-42",
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-42",
                                        0
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
                                        "obj-47",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-47",
                                        0
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
                                        "obj-20",
                                        4
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
                                        "obj-50",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-50",
                                        3
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
                                        "obj-52",
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
                                        "obj-52",
                                        1
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
                                        "obj-53",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-50",
                                        1
                                    ],
                                    "destination": [
                                        "obj-53",
                                        1
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
                                        "obj-54",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-50",
                                        2
                                    ],
                                    "destination": [
                                        "obj-54",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-52",
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
                                        "obj-20",
                                        5
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
                                        "obj-57",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-57",
                                        0
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
                                        "obj-20",
                                        6
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
                                        "obj-20",
                                        7
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
                                        "obj-61",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-61",
                                        1
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
                                        "obj-61",
                                        0
                                    ],
                                    "destination": [
                                        "obj-62",
                                        1
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
                                        "obj-63",
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
                                        "obj-64",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-64",
                                        1
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
                                        "obj-64",
                                        0
                                    ],
                                    "destination": [
                                        "obj-65",
                                        1
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
                                        "obj-52",
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
                                        1
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
                                        "obj-67",
                                        0
                                    ],
                                    "destination": [
                                        "obj-68",
                                        1
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
                                        "obj-69",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-69",
                                        0
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
                                        "obj-66",
                                        0
                                    ],
                                    "destination": [
                                        "obj-70",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-63",
                                        0
                                    ],
                                    "destination": [
                                        "obj-70",
                                        2
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
                                        "obj-74",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-74",
                                        0
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
                                        "obj-20",
                                        8
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
                                        "obj-78",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-78",
                                        3
                                    ],
                                    "destination": [
                                        "obj-79",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-79",
                                        0
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
                                        "obj-78",
                                        0
                                    ],
                                    "destination": [
                                        "obj-80",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-79",
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
                                        "obj-78",
                                        1
                                    ],
                                    "destination": [
                                        "obj-81",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-79",
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
                                        "obj-78",
                                        2
                                    ],
                                    "destination": [
                                        "obj-82",
                                        1
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
                                        "obj-84",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-84",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        9
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
                                        "obj-20",
                                        10
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
                                        "obj-20",
                                        11
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
                                        "obj-89",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-89",
                                        1
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
                                        "obj-89",
                                        0
                                    ],
                                    "destination": [
                                        "obj-90",
                                        1
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
                                        "obj-81",
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
                                        1
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
                                        "obj-92",
                                        0
                                    ],
                                    "destination": [
                                        "obj-93",
                                        1
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
                                        "obj-94",
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
                                        "obj-95",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-95",
                                        1
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
                                        "obj-95",
                                        0
                                    ],
                                    "destination": [
                                        "obj-96",
                                        1
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
                                        "obj-94",
                                        0
                                    ],
                                    "destination": [
                                        "obj-98",
                                        1
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
                                        "obj-98",
                                        2
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
                                        "obj-99",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-99",
                                        0
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
                                        "obj-104",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-104",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        12
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-5",
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
                                        3
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
                                        "obj-106",
                                        0
                                    ],
                                    "destination": [
                                        "obj-108",
                                        1
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
                                        "obj-109",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-106",
                                        1
                                    ],
                                    "destination": [
                                        "obj-109",
                                        1
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
                                        "obj-110",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-106",
                                        2
                                    ],
                                    "destination": [
                                        "obj-110",
                                        1
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
                                        "obj-20",
                                        13
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-109",
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
                                        "obj-114",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-114",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        14
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
                                        "obj-20",
                                        15
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
                                        "obj-117",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-117",
                                        1
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
                                        "obj-117",
                                        0
                                    ],
                                    "destination": [
                                        "obj-118",
                                        1
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
                                        "obj-119",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-109",
                                        0
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
                                        1
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
                                        "obj-120",
                                        0
                                    ],
                                    "destination": [
                                        "obj-121",
                                        1
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
                                        "obj-108",
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
                                        1
                                    ],
                                    "destination": [
                                        "obj-124",
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
                                        "obj-124",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-124",
                                        0
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
                                        "obj-122",
                                        0
                                    ],
                                    "destination": [
                                        "obj-126",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-119",
                                        0
                                    ],
                                    "destination": [
                                        "obj-126",
                                        2
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
                                        "obj-129",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-129",
                                        0
                                    ],
                                    "destination": [
                                        "obj-130",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-130",
                                        0
                                    ],
                                    "destination": [
                                        "obj-131",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-131",
                                        0
                                    ],
                                    "destination": [
                                        "obj-132",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-132",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        16
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-134",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-134",
                                        3
                                    ],
                                    "destination": [
                                        "obj-135",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-135",
                                        0
                                    ],
                                    "destination": [
                                        "obj-136",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-134",
                                        0
                                    ],
                                    "destination": [
                                        "obj-136",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-135",
                                        0
                                    ],
                                    "destination": [
                                        "obj-137",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-134",
                                        1
                                    ],
                                    "destination": [
                                        "obj-137",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-135",
                                        0
                                    ],
                                    "destination": [
                                        "obj-138",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-134",
                                        2
                                    ],
                                    "destination": [
                                        "obj-138",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-136",
                                        0
                                    ],
                                    "destination": [
                                        "obj-139",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-139",
                                        0
                                    ],
                                    "destination": [
                                        "obj-140",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-140",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        17
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-137",
                                        0
                                    ],
                                    "destination": [
                                        "obj-141",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-141",
                                        0
                                    ],
                                    "destination": [
                                        "obj-142",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-142",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        18
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-138",
                                        0
                                    ],
                                    "destination": [
                                        "obj-143",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-143",
                                        0
                                    ],
                                    "destination": [
                                        "obj-144",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-144",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        19
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-138",
                                        0
                                    ],
                                    "destination": [
                                        "obj-145",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-145",
                                        1
                                    ],
                                    "destination": [
                                        "obj-146",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-145",
                                        0
                                    ],
                                    "destination": [
                                        "obj-146",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-146",
                                        0
                                    ],
                                    "destination": [
                                        "obj-147",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-137",
                                        0
                                    ],
                                    "destination": [
                                        "obj-148",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-148",
                                        1
                                    ],
                                    "destination": [
                                        "obj-149",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-148",
                                        0
                                    ],
                                    "destination": [
                                        "obj-149",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-149",
                                        0
                                    ],
                                    "destination": [
                                        "obj-150",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-136",
                                        0
                                    ],
                                    "destination": [
                                        "obj-151",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-151",
                                        1
                                    ],
                                    "destination": [
                                        "obj-152",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-151",
                                        0
                                    ],
                                    "destination": [
                                        "obj-152",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-152",
                                        0
                                    ],
                                    "destination": [
                                        "obj-153",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-153",
                                        0
                                    ],
                                    "destination": [
                                        "obj-154",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-150",
                                        0
                                    ],
                                    "destination": [
                                        "obj-154",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-147",
                                        0
                                    ],
                                    "destination": [
                                        "obj-154",
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-154",
                                        0
                                    ],
                                    "destination": [
                                        "obj-155",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-155",
                                        0
                                    ],
                                    "destination": [
                                        "obj-156",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-156",
                                        0
                                    ],
                                    "destination": [
                                        "obj-157",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-157",
                                        0
                                    ],
                                    "destination": [
                                        "obj-158",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-158",
                                        0
                                    ],
                                    "destination": [
                                        "obj-159",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-159",
                                        0
                                    ],
                                    "destination": [
                                        "obj-160",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-160",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        20
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        0
                                    ],
                                    "destination": [
                                        "obj-162",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-162",
                                        3
                                    ],
                                    "destination": [
                                        "obj-163",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-163",
                                        0
                                    ],
                                    "destination": [
                                        "obj-164",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-162",
                                        0
                                    ],
                                    "destination": [
                                        "obj-164",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-163",
                                        0
                                    ],
                                    "destination": [
                                        "obj-165",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-162",
                                        1
                                    ],
                                    "destination": [
                                        "obj-165",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-163",
                                        0
                                    ],
                                    "destination": [
                                        "obj-166",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-162",
                                        2
                                    ],
                                    "destination": [
                                        "obj-166",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-164",
                                        0
                                    ],
                                    "destination": [
                                        "obj-167",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-167",
                                        0
                                    ],
                                    "destination": [
                                        "obj-168",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-168",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        21
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-165",
                                        0
                                    ],
                                    "destination": [
                                        "obj-169",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-169",
                                        0
                                    ],
                                    "destination": [
                                        "obj-170",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-170",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        22
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-166",
                                        0
                                    ],
                                    "destination": [
                                        "obj-171",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-171",
                                        0
                                    ],
                                    "destination": [
                                        "obj-172",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-172",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        23
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-166",
                                        0
                                    ],
                                    "destination": [
                                        "obj-173",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-173",
                                        1
                                    ],
                                    "destination": [
                                        "obj-174",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-173",
                                        0
                                    ],
                                    "destination": [
                                        "obj-174",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-174",
                                        0
                                    ],
                                    "destination": [
                                        "obj-175",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-165",
                                        0
                                    ],
                                    "destination": [
                                        "obj-176",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-176",
                                        1
                                    ],
                                    "destination": [
                                        "obj-177",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-176",
                                        0
                                    ],
                                    "destination": [
                                        "obj-177",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-177",
                                        0
                                    ],
                                    "destination": [
                                        "obj-178",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-164",
                                        0
                                    ],
                                    "destination": [
                                        "obj-179",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-179",
                                        1
                                    ],
                                    "destination": [
                                        "obj-180",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-179",
                                        0
                                    ],
                                    "destination": [
                                        "obj-180",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-180",
                                        0
                                    ],
                                    "destination": [
                                        "obj-181",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-181",
                                        0
                                    ],
                                    "destination": [
                                        "obj-182",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-178",
                                        0
                                    ],
                                    "destination": [
                                        "obj-182",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-175",
                                        0
                                    ],
                                    "destination": [
                                        "obj-182",
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-182",
                                        0
                                    ],
                                    "destination": [
                                        "obj-183",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-183",
                                        0
                                    ],
                                    "destination": [
                                        "obj-184",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-184",
                                        0
                                    ],
                                    "destination": [
                                        "obj-185",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-185",
                                        0
                                    ],
                                    "destination": [
                                        "obj-186",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-186",
                                        0
                                    ],
                                    "destination": [
                                        "obj-187",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-187",
                                        0
                                    ],
                                    "destination": [
                                        "obj-188",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-188",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        24
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-8",
                                        0
                                    ],
                                    "destination": [
                                        "obj-190",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-190",
                                        3
                                    ],
                                    "destination": [
                                        "obj-191",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-191",
                                        0
                                    ],
                                    "destination": [
                                        "obj-192",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-190",
                                        2
                                    ],
                                    "destination": [
                                        "obj-192",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-9",
                                        0
                                    ],
                                    "destination": [
                                        "obj-194",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-194",
                                        3
                                    ],
                                    "destination": [
                                        "obj-195",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-195",
                                        0
                                    ],
                                    "destination": [
                                        "obj-196",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-194",
                                        2
                                    ],
                                    "destination": [
                                        "obj-196",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-52",
                                        0
                                    ],
                                    "destination": [
                                        "obj-198",
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
                                        "obj-198",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-198",
                                        0
                                    ],
                                    "destination": [
                                        "obj-199",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-199",
                                        0
                                    ],
                                    "destination": [
                                        "obj-200",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-200",
                                        0
                                    ],
                                    "destination": [
                                        "obj-201",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-201",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        25
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-196",
                                        0
                                    ],
                                    "destination": [
                                        "obj-203",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-192",
                                        0
                                    ],
                                    "destination": [
                                        "obj-203",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-203",
                                        0
                                    ],
                                    "destination": [
                                        "obj-204",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-204",
                                        0
                                    ],
                                    "destination": [
                                        "obj-205",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-205",
                                        0
                                    ],
                                    "destination": [
                                        "obj-206",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-206",
                                        0
                                    ],
                                    "destination": [
                                        "obj-20",
                                        26
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
                                        "obj-208",
                                        0
                                    ]
                                }
                            }
                        ]
                    }
                }
            },
            {
                "box": {
                    "id": "obj-57",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        200.0,
                        438.0,
                        600.0,
                        20.0
                    ],
                    "text": "double-click to tune how much movement counts as 'full'"
                }
            },
            {
                "box": {
                    "id": "obj-58",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        1052.0,
                        190.0,
                        22.0
                    ],
                    "text": "udpsend 127.0.0.1 7500",
                    "outlettype": []
                }
            },
            {
                "box": {
                    "id": "obj-59",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        220.0,
                        1054.0,
                        900.0,
                        20.0
                    ],
                    "text": "-> MoveBeatSynth.maxpat. Both devices on this Mac, so localhost."
                }
            },
            {
                "box": {
                    "id": "obj-60",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        1180.0,
                        196.0,
                        24.0,
                        24.0
                    ],
                    "outlettype": [
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-61",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        1210.0,
                        198.0,
                        120.0,
                        20.0
                    ],
                    "text": "tracked"
                }
            },
            {
                "box": {
                    "id": "obj-62",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        1180.0,
                        236.0,
                        180.0,
                        22.0
                    ],
                    "text": "prepend /movebeat/gate",
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
                        20.0,
                        486.0,
                        180.0,
                        20.0
                    ],
                    "text": "BODY PART"
                }
            },
            {
                "box": {
                    "id": "obj-64",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        110.0,
                        486.0,
                        180.0,
                        20.0
                    ],
                    "text": "SOURCE"
                }
            },
            {
                "box": {
                    "id": "obj-65",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        215.0,
                        486.0,
                        180.0,
                        20.0
                    ],
                    "text": "-> SYNTH PARAMETER"
                }
            },
            {
                "box": {
                    "id": "obj-66",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        390.0,
                        486.0,
                        180.0,
                        20.0
                    ],
                    "text": "MIN"
                }
            },
            {
                "box": {
                    "id": "obj-67",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        470.0,
                        486.0,
                        180.0,
                        20.0
                    ],
                    "text": "MAX"
                }
            },
            {
                "box": {
                    "id": "obj-68",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        550.0,
                        486.0,
                        180.0,
                        20.0
                    ],
                    "text": "CURVE"
                }
            },
            {
                "box": {
                    "id": "obj-69",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        640.0,
                        486.0,
                        180.0,
                        20.0
                    ],
                    "text": "SENDING"
                }
            },
            {
                "box": {
                    "id": "obj-70",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        514.0,
                        90.0,
                        20.0
                    ],
                    "text": "HAND L"
                }
            },
            {
                "box": {
                    "id": "obj-71",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        110.0,
                        512.0,
                        95.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "X",
                        ",",
                        "Y",
                        ",",
                        "Z",
                        ",",
                        "SPEED",
                        ",",
                        "SPREAD",
                        ",",
                        "LEAN"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-72",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        215.0,
                        512.0,
                        165.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "- off -",
                        ",",
                        "cutoff",
                        ",",
                        "resonance",
                        ",",
                        "drive",
                        ",",
                        "rescomp",
                        ",",
                        "outgain",
                        ",",
                        "osc1level",
                        ",",
                        "osc2level",
                        ",",
                        "sublevel",
                        ",",
                        "detune",
                        ",",
                        "pw",
                        ",",
                        "osc1wave",
                        ",",
                        "osc2wave",
                        ",",
                        "lfoRate",
                        ",",
                        "lfoDepth",
                        ",",
                        "filtEnvAmt",
                        ",",
                        "glide",
                        ",",
                        "ampA",
                        ",",
                        "ampD",
                        ",",
                        "ampS",
                        ",",
                        "ampR",
                        ",",
                        "filtA",
                        ",",
                        "filtD",
                        ",",
                        "filtS",
                        ",",
                        "filtR"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-73",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        390.0,
                        512.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-74",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        470.0,
                        512.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-75",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        550.0,
                        512.0,
                        80.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "LIN",
                        ",",
                        "EXP"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-76",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        640.0,
                        512.0,
                        80.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-77",
                    "maxclass": "newobj",
                    "numinlets": 7,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        740.0,
                        512.0,
                        150.0,
                        22.0
                    ],
                    "text": "p mb_slot",
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
                            80.0,
                            80.0,
                            1420.0,
                            560.0
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
                                        900.0,
                                        27.0
                                    ],
                                    "text": "ONE MAPPING SLOT - picks its source out of the list, scales it into the locked output range, and emits <address> <value>.",
                                    "fontsize": 12.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        130.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        230.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        330.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        430.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        530.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        630.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
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
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "list"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        130.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "index"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        230.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "address"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        330.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "min"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        430.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "max"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        530.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "curve"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        630.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "on"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        140.0,
                                        90.0,
                                        22.0
                                    ],
                                    "text": "zl nth",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        190.0,
                                        1300.0,
                                        22.0
                                    ],
                                    "text": "expr ($f2 + $f1 * ($f3 - $f2)) + (($i4 != 0) * ($f2 > 0) * ($f3 > 0)) * (((($f2 > 0) * $f2 + ($f2 <= 0)) * pow((($f3 > 0) * $f3 + ($f3 <= 0)) / (($f2 > 0) * $f2 + ($f2 <= 0))\\, $f1)) - ($f2 + $f1 * ($f3 - $f2)))",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        214.0,
                                        860.0,
                                        20.0
                                    ],
                                    "text": "linear, or exponential when the range is strictly positive (equal movement = equal musical intervals)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        250.0,
                                        60.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        290.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        330.0,
                                        260.0,
                                        22.0
                                    ],
                                    "text": "pak /movebeat/cutoff 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        370.0,
                                        100.0,
                                        22.0
                                    ],
                                    "text": "$1 $2",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        420.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        200.0,
                                        420.0,
                                        30.0,
                                        30.0
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
                                        "obj-16",
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
                                        "obj-16",
                                        1
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
                                        "obj-17",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-5",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        3
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-8",
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
                                        "obj-17",
                                        0
                                    ],
                                    "destination": [
                                        "obj-19",
                                        1
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
                                        "obj-4",
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
                                        "obj-20",
                                        0
                                    ],
                                    "destination": [
                                        "obj-21",
                                        1
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
                                        "obj-22",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-22",
                                        0
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
                                        "obj-20",
                                        1
                                    ],
                                    "destination": [
                                        "obj-24",
                                        0
                                    ]
                                }
                            }
                        ]
                    }
                }
            },
            {
                "box": {
                    "id": "obj-78",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        940.0,
                        512.0,
                        230.0,
                        22.0
                    ],
                    "text": "expr $i1 + 2 + ($i1 >= 4) * 20",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-79",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        1180.0,
                        512.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf /movebeat/%s",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-80",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1345.0,
                        512.0,
                        60.0,
                        22.0
                    ],
                    "text": "!= 0",
                    "outlettype": [
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-81",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        215.0,
                        538.0,
                        60.0,
                        22.0
                    ],
                    "text": "t b i",
                    "outlettype": [
                        "bang",
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-82",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1420.0,
                        538.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 20 0 0 0 0 0 0 0 -24 0.05 0 0 0.01 0 0 0 0 0 0 0 0 0 0 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-83",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1420.0,
                        562.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-84",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1430.0,
                        538.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 18000 4 1 1 1 1 1 1 24 0.95 3 3 20 5000 8000 2000 2000 2000 1 4000 2000 2000 1 4000",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-85",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1430.0,
                        562.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-86",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1440.0,
                        538.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-87",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1440.0,
                        562.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-88",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        588.0,
                        90.0,
                        20.0
                    ],
                    "text": "HAND R"
                }
            },
            {
                "box": {
                    "id": "obj-89",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        110.0,
                        586.0,
                        95.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "X",
                        ",",
                        "Y",
                        ",",
                        "Z",
                        ",",
                        "SPEED",
                        ",",
                        "SPREAD",
                        ",",
                        "LEAN"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-90",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        215.0,
                        586.0,
                        165.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "- off -",
                        ",",
                        "cutoff",
                        ",",
                        "resonance",
                        ",",
                        "drive",
                        ",",
                        "rescomp",
                        ",",
                        "outgain",
                        ",",
                        "osc1level",
                        ",",
                        "osc2level",
                        ",",
                        "sublevel",
                        ",",
                        "detune",
                        ",",
                        "pw",
                        ",",
                        "osc1wave",
                        ",",
                        "osc2wave",
                        ",",
                        "lfoRate",
                        ",",
                        "lfoDepth",
                        ",",
                        "filtEnvAmt",
                        ",",
                        "glide",
                        ",",
                        "ampA",
                        ",",
                        "ampD",
                        ",",
                        "ampS",
                        ",",
                        "ampR",
                        ",",
                        "filtA",
                        ",",
                        "filtD",
                        ",",
                        "filtS",
                        ",",
                        "filtR"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-91",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        390.0,
                        586.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-92",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        470.0,
                        586.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-93",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        550.0,
                        586.0,
                        80.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "LIN",
                        ",",
                        "EXP"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-94",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        640.0,
                        586.0,
                        80.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-95",
                    "maxclass": "newobj",
                    "numinlets": 7,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        740.0,
                        586.0,
                        150.0,
                        22.0
                    ],
                    "text": "p mb_slot",
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
                            80.0,
                            80.0,
                            1420.0,
                            560.0
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
                                        900.0,
                                        27.0
                                    ],
                                    "text": "ONE MAPPING SLOT - picks its source out of the list, scales it into the locked output range, and emits <address> <value>.",
                                    "fontsize": 12.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        130.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        230.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        330.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        430.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        530.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        630.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
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
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "list"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        130.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "index"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        230.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "address"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        330.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "min"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        430.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "max"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        530.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "curve"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        630.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "on"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        140.0,
                                        90.0,
                                        22.0
                                    ],
                                    "text": "zl nth",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        190.0,
                                        1300.0,
                                        22.0
                                    ],
                                    "text": "expr ($f2 + $f1 * ($f3 - $f2)) + (($i4 != 0) * ($f2 > 0) * ($f3 > 0)) * (((($f2 > 0) * $f2 + ($f2 <= 0)) * pow((($f3 > 0) * $f3 + ($f3 <= 0)) / (($f2 > 0) * $f2 + ($f2 <= 0))\\, $f1)) - ($f2 + $f1 * ($f3 - $f2)))",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        214.0,
                                        860.0,
                                        20.0
                                    ],
                                    "text": "linear, or exponential when the range is strictly positive (equal movement = equal musical intervals)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        250.0,
                                        60.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        290.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        330.0,
                                        260.0,
                                        22.0
                                    ],
                                    "text": "pak /movebeat/cutoff 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        370.0,
                                        100.0,
                                        22.0
                                    ],
                                    "text": "$1 $2",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        420.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        200.0,
                                        420.0,
                                        30.0,
                                        30.0
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
                                        "obj-16",
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
                                        "obj-16",
                                        1
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
                                        "obj-17",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-5",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        3
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-8",
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
                                        "obj-17",
                                        0
                                    ],
                                    "destination": [
                                        "obj-19",
                                        1
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
                                        "obj-4",
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
                                        "obj-20",
                                        0
                                    ],
                                    "destination": [
                                        "obj-21",
                                        1
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
                                        "obj-22",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-22",
                                        0
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
                                        "obj-20",
                                        1
                                    ],
                                    "destination": [
                                        "obj-24",
                                        0
                                    ]
                                }
                            }
                        ]
                    }
                }
            },
            {
                "box": {
                    "id": "obj-96",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        940.0,
                        586.0,
                        230.0,
                        22.0
                    ],
                    "text": "expr $i1 + 6 + ($i1 >= 4) * 16",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-97",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        1180.0,
                        586.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf /movebeat/%s",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-98",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1345.0,
                        586.0,
                        60.0,
                        22.0
                    ],
                    "text": "!= 0",
                    "outlettype": [
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-99",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        215.0,
                        612.0,
                        60.0,
                        22.0
                    ],
                    "text": "t b i",
                    "outlettype": [
                        "bang",
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-100",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1420.0,
                        612.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 20 0 0 0 0 0 0 0 -24 0.05 0 0 0.01 0 0 0 0 0 0 0 0 0 0 0",
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
                    "numoutlets": 2,
                    "patching_rect": [
                        1420.0,
                        636.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-102",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1430.0,
                        612.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 18000 4 1 1 1 1 1 1 24 0.95 3 3 20 5000 8000 2000 2000 2000 1 4000 2000 2000 1 4000",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-103",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1430.0,
                        636.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-104",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1440.0,
                        612.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-105",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1440.0,
                        636.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-106",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        662.0,
                        90.0,
                        20.0
                    ],
                    "text": "FOOT L"
                }
            },
            {
                "box": {
                    "id": "obj-107",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        110.0,
                        660.0,
                        95.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "X",
                        ",",
                        "Y",
                        ",",
                        "Z",
                        ",",
                        "SPEED",
                        ",",
                        "SPREAD",
                        ",",
                        "LEAN"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-108",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        215.0,
                        660.0,
                        165.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "- off -",
                        ",",
                        "cutoff",
                        ",",
                        "resonance",
                        ",",
                        "drive",
                        ",",
                        "rescomp",
                        ",",
                        "outgain",
                        ",",
                        "osc1level",
                        ",",
                        "osc2level",
                        ",",
                        "sublevel",
                        ",",
                        "detune",
                        ",",
                        "pw",
                        ",",
                        "osc1wave",
                        ",",
                        "osc2wave",
                        ",",
                        "lfoRate",
                        ",",
                        "lfoDepth",
                        ",",
                        "filtEnvAmt",
                        ",",
                        "glide",
                        ",",
                        "ampA",
                        ",",
                        "ampD",
                        ",",
                        "ampS",
                        ",",
                        "ampR",
                        ",",
                        "filtA",
                        ",",
                        "filtD",
                        ",",
                        "filtS",
                        ",",
                        "filtR"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-109",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        390.0,
                        660.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-110",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        470.0,
                        660.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-111",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        550.0,
                        660.0,
                        80.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "LIN",
                        ",",
                        "EXP"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-112",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        640.0,
                        660.0,
                        80.0,
                        22.0
                    ],
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
                    "numinlets": 7,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        740.0,
                        660.0,
                        150.0,
                        22.0
                    ],
                    "text": "p mb_slot",
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
                            80.0,
                            80.0,
                            1420.0,
                            560.0
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
                                        900.0,
                                        27.0
                                    ],
                                    "text": "ONE MAPPING SLOT - picks its source out of the list, scales it into the locked output range, and emits <address> <value>.",
                                    "fontsize": 12.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        130.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        230.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        330.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        430.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        530.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        630.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
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
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "list"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        130.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "index"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        230.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "address"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        330.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "min"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        430.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "max"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        530.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "curve"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        630.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "on"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        140.0,
                                        90.0,
                                        22.0
                                    ],
                                    "text": "zl nth",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        190.0,
                                        1300.0,
                                        22.0
                                    ],
                                    "text": "expr ($f2 + $f1 * ($f3 - $f2)) + (($i4 != 0) * ($f2 > 0) * ($f3 > 0)) * (((($f2 > 0) * $f2 + ($f2 <= 0)) * pow((($f3 > 0) * $f3 + ($f3 <= 0)) / (($f2 > 0) * $f2 + ($f2 <= 0))\\, $f1)) - ($f2 + $f1 * ($f3 - $f2)))",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        214.0,
                                        860.0,
                                        20.0
                                    ],
                                    "text": "linear, or exponential when the range is strictly positive (equal movement = equal musical intervals)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        250.0,
                                        60.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        290.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        330.0,
                                        260.0,
                                        22.0
                                    ],
                                    "text": "pak /movebeat/cutoff 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        370.0,
                                        100.0,
                                        22.0
                                    ],
                                    "text": "$1 $2",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        420.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        200.0,
                                        420.0,
                                        30.0,
                                        30.0
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
                                        "obj-16",
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
                                        "obj-16",
                                        1
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
                                        "obj-17",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-5",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        3
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-8",
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
                                        "obj-17",
                                        0
                                    ],
                                    "destination": [
                                        "obj-19",
                                        1
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
                                        "obj-4",
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
                                        "obj-20",
                                        0
                                    ],
                                    "destination": [
                                        "obj-21",
                                        1
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
                                        "obj-22",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-22",
                                        0
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
                                        "obj-20",
                                        1
                                    ],
                                    "destination": [
                                        "obj-24",
                                        0
                                    ]
                                }
                            }
                        ]
                    }
                }
            },
            {
                "box": {
                    "id": "obj-114",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        940.0,
                        660.0,
                        230.0,
                        22.0
                    ],
                    "text": "expr $i1 + 10 + ($i1 >= 4) * 12",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-115",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        1180.0,
                        660.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf /movebeat/%s",
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
                        1345.0,
                        660.0,
                        60.0,
                        22.0
                    ],
                    "text": "!= 0",
                    "outlettype": [
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-117",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        215.0,
                        686.0,
                        60.0,
                        22.0
                    ],
                    "text": "t b i",
                    "outlettype": [
                        "bang",
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-118",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1420.0,
                        686.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 20 0 0 0 0 0 0 0 -24 0.05 0 0 0.01 0 0 0 0 0 0 0 0 0 0 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-119",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1420.0,
                        710.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-120",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1430.0,
                        686.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 18000 4 1 1 1 1 1 1 24 0.95 3 3 20 5000 8000 2000 2000 2000 1 4000 2000 2000 1 4000",
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
                    "numoutlets": 2,
                    "patching_rect": [
                        1430.0,
                        710.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-122",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1440.0,
                        686.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-123",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1440.0,
                        710.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
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
                        20.0,
                        736.0,
                        90.0,
                        20.0
                    ],
                    "text": "FOOT R"
                }
            },
            {
                "box": {
                    "id": "obj-125",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        110.0,
                        734.0,
                        95.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "X",
                        ",",
                        "Y",
                        ",",
                        "Z",
                        ",",
                        "SPEED",
                        ",",
                        "SPREAD",
                        ",",
                        "LEAN"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-126",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        215.0,
                        734.0,
                        165.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "- off -",
                        ",",
                        "cutoff",
                        ",",
                        "resonance",
                        ",",
                        "drive",
                        ",",
                        "rescomp",
                        ",",
                        "outgain",
                        ",",
                        "osc1level",
                        ",",
                        "osc2level",
                        ",",
                        "sublevel",
                        ",",
                        "detune",
                        ",",
                        "pw",
                        ",",
                        "osc1wave",
                        ",",
                        "osc2wave",
                        ",",
                        "lfoRate",
                        ",",
                        "lfoDepth",
                        ",",
                        "filtEnvAmt",
                        ",",
                        "glide",
                        ",",
                        "ampA",
                        ",",
                        "ampD",
                        ",",
                        "ampS",
                        ",",
                        "ampR",
                        ",",
                        "filtA",
                        ",",
                        "filtD",
                        ",",
                        "filtS",
                        ",",
                        "filtR"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-127",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        390.0,
                        734.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-128",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        470.0,
                        734.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-129",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        550.0,
                        734.0,
                        80.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "LIN",
                        ",",
                        "EXP"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-130",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        640.0,
                        734.0,
                        80.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-131",
                    "maxclass": "newobj",
                    "numinlets": 7,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        740.0,
                        734.0,
                        150.0,
                        22.0
                    ],
                    "text": "p mb_slot",
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
                            80.0,
                            80.0,
                            1420.0,
                            560.0
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
                                        900.0,
                                        27.0
                                    ],
                                    "text": "ONE MAPPING SLOT - picks its source out of the list, scales it into the locked output range, and emits <address> <value>.",
                                    "fontsize": 12.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        130.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        230.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        330.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        430.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        530.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        630.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
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
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "list"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        130.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "index"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        230.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "address"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        330.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "min"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        430.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "max"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        530.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "curve"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        630.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "on"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        140.0,
                                        90.0,
                                        22.0
                                    ],
                                    "text": "zl nth",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        190.0,
                                        1300.0,
                                        22.0
                                    ],
                                    "text": "expr ($f2 + $f1 * ($f3 - $f2)) + (($i4 != 0) * ($f2 > 0) * ($f3 > 0)) * (((($f2 > 0) * $f2 + ($f2 <= 0)) * pow((($f3 > 0) * $f3 + ($f3 <= 0)) / (($f2 > 0) * $f2 + ($f2 <= 0))\\, $f1)) - ($f2 + $f1 * ($f3 - $f2)))",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        214.0,
                                        860.0,
                                        20.0
                                    ],
                                    "text": "linear, or exponential when the range is strictly positive (equal movement = equal musical intervals)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        250.0,
                                        60.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        290.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        330.0,
                                        260.0,
                                        22.0
                                    ],
                                    "text": "pak /movebeat/cutoff 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        370.0,
                                        100.0,
                                        22.0
                                    ],
                                    "text": "$1 $2",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        420.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        200.0,
                                        420.0,
                                        30.0,
                                        30.0
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
                                        "obj-16",
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
                                        "obj-16",
                                        1
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
                                        "obj-17",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-5",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        3
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-8",
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
                                        "obj-17",
                                        0
                                    ],
                                    "destination": [
                                        "obj-19",
                                        1
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
                                        "obj-4",
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
                                        "obj-20",
                                        0
                                    ],
                                    "destination": [
                                        "obj-21",
                                        1
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
                                        "obj-22",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-22",
                                        0
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
                                        "obj-20",
                                        1
                                    ],
                                    "destination": [
                                        "obj-24",
                                        0
                                    ]
                                }
                            }
                        ]
                    }
                }
            },
            {
                "box": {
                    "id": "obj-132",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        940.0,
                        734.0,
                        230.0,
                        22.0
                    ],
                    "text": "expr $i1 + 14 + ($i1 >= 4) * 8",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-133",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        1180.0,
                        734.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf /movebeat/%s",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-134",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1345.0,
                        734.0,
                        60.0,
                        22.0
                    ],
                    "text": "!= 0",
                    "outlettype": [
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-135",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        215.0,
                        760.0,
                        60.0,
                        22.0
                    ],
                    "text": "t b i",
                    "outlettype": [
                        "bang",
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-136",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1420.0,
                        760.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 20 0 0 0 0 0 0 0 -24 0.05 0 0 0.01 0 0 0 0 0 0 0 0 0 0 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-137",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1420.0,
                        784.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-138",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1430.0,
                        760.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 18000 4 1 1 1 1 1 1 24 0.95 3 3 20 5000 8000 2000 2000 2000 1 4000 2000 2000 1 4000",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-139",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1430.0,
                        784.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-140",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1440.0,
                        760.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-141",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1440.0,
                        784.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-142",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        810.0,
                        90.0,
                        20.0
                    ],
                    "text": "HEAD"
                }
            },
            {
                "box": {
                    "id": "obj-143",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        110.0,
                        808.0,
                        95.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "X",
                        ",",
                        "Y",
                        ",",
                        "Z",
                        ",",
                        "SPEED",
                        ",",
                        "SPREAD",
                        ",",
                        "LEAN"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-144",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        215.0,
                        808.0,
                        165.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "- off -",
                        ",",
                        "cutoff",
                        ",",
                        "resonance",
                        ",",
                        "drive",
                        ",",
                        "rescomp",
                        ",",
                        "outgain",
                        ",",
                        "osc1level",
                        ",",
                        "osc2level",
                        ",",
                        "sublevel",
                        ",",
                        "detune",
                        ",",
                        "pw",
                        ",",
                        "osc1wave",
                        ",",
                        "osc2wave",
                        ",",
                        "lfoRate",
                        ",",
                        "lfoDepth",
                        ",",
                        "filtEnvAmt",
                        ",",
                        "glide",
                        ",",
                        "ampA",
                        ",",
                        "ampD",
                        ",",
                        "ampS",
                        ",",
                        "ampR",
                        ",",
                        "filtA",
                        ",",
                        "filtD",
                        ",",
                        "filtS",
                        ",",
                        "filtR"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-145",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        390.0,
                        808.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-146",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        470.0,
                        808.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-147",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        550.0,
                        808.0,
                        80.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "LIN",
                        ",",
                        "EXP"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-148",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        640.0,
                        808.0,
                        80.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-149",
                    "maxclass": "newobj",
                    "numinlets": 7,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        740.0,
                        808.0,
                        150.0,
                        22.0
                    ],
                    "text": "p mb_slot",
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
                            80.0,
                            80.0,
                            1420.0,
                            560.0
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
                                        900.0,
                                        27.0
                                    ],
                                    "text": "ONE MAPPING SLOT - picks its source out of the list, scales it into the locked output range, and emits <address> <value>.",
                                    "fontsize": 12.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        130.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        230.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        330.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        430.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        530.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        630.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
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
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "list"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        130.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "index"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        230.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "address"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        330.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "min"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        430.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "max"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        530.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "curve"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        630.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "on"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        140.0,
                                        90.0,
                                        22.0
                                    ],
                                    "text": "zl nth",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        190.0,
                                        1300.0,
                                        22.0
                                    ],
                                    "text": "expr ($f2 + $f1 * ($f3 - $f2)) + (($i4 != 0) * ($f2 > 0) * ($f3 > 0)) * (((($f2 > 0) * $f2 + ($f2 <= 0)) * pow((($f3 > 0) * $f3 + ($f3 <= 0)) / (($f2 > 0) * $f2 + ($f2 <= 0))\\, $f1)) - ($f2 + $f1 * ($f3 - $f2)))",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        214.0,
                                        860.0,
                                        20.0
                                    ],
                                    "text": "linear, or exponential when the range is strictly positive (equal movement = equal musical intervals)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        250.0,
                                        60.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        290.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        330.0,
                                        260.0,
                                        22.0
                                    ],
                                    "text": "pak /movebeat/cutoff 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        370.0,
                                        100.0,
                                        22.0
                                    ],
                                    "text": "$1 $2",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        420.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        200.0,
                                        420.0,
                                        30.0,
                                        30.0
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
                                        "obj-16",
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
                                        "obj-16",
                                        1
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
                                        "obj-17",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-5",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        3
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-8",
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
                                        "obj-17",
                                        0
                                    ],
                                    "destination": [
                                        "obj-19",
                                        1
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
                                        "obj-4",
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
                                        "obj-20",
                                        0
                                    ],
                                    "destination": [
                                        "obj-21",
                                        1
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
                                        "obj-22",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-22",
                                        0
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
                                        "obj-20",
                                        1
                                    ],
                                    "destination": [
                                        "obj-24",
                                        0
                                    ]
                                }
                            }
                        ]
                    }
                }
            },
            {
                "box": {
                    "id": "obj-150",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        940.0,
                        808.0,
                        230.0,
                        22.0
                    ],
                    "text": "expr $i1 + 18 + ($i1 >= 4) * 4",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-151",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        1180.0,
                        808.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf /movebeat/%s",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-152",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1345.0,
                        808.0,
                        60.0,
                        22.0
                    ],
                    "text": "!= 0",
                    "outlettype": [
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-153",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        215.0,
                        834.0,
                        60.0,
                        22.0
                    ],
                    "text": "t b i",
                    "outlettype": [
                        "bang",
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-154",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1420.0,
                        834.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 20 0 0 0 0 0 0 0 -24 0.05 0 0 0.01 0 0 0 0 0 0 0 0 0 0 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-155",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1420.0,
                        858.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-156",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1430.0,
                        834.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 18000 4 1 1 1 1 1 1 24 0.95 3 3 20 5000 8000 2000 2000 2000 1 4000 2000 2000 1 4000",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-157",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1430.0,
                        858.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-158",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1440.0,
                        834.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-159",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1440.0,
                        858.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-160",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [
                        20.0,
                        884.0,
                        90.0,
                        20.0
                    ],
                    "text": "TORSO"
                }
            },
            {
                "box": {
                    "id": "obj-161",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        110.0,
                        882.0,
                        95.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "X",
                        ",",
                        "Y",
                        ",",
                        "Z",
                        ",",
                        "SPEED",
                        ",",
                        "SPREAD",
                        ",",
                        "LEAN"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-162",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        215.0,
                        882.0,
                        165.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "- off -",
                        ",",
                        "cutoff",
                        ",",
                        "resonance",
                        ",",
                        "drive",
                        ",",
                        "rescomp",
                        ",",
                        "outgain",
                        ",",
                        "osc1level",
                        ",",
                        "osc2level",
                        ",",
                        "sublevel",
                        ",",
                        "detune",
                        ",",
                        "pw",
                        ",",
                        "osc1wave",
                        ",",
                        "osc2wave",
                        ",",
                        "lfoRate",
                        ",",
                        "lfoDepth",
                        ",",
                        "filtEnvAmt",
                        ",",
                        "glide",
                        ",",
                        "ampA",
                        ",",
                        "ampD",
                        ",",
                        "ampS",
                        ",",
                        "ampR",
                        ",",
                        "filtA",
                        ",",
                        "filtD",
                        ",",
                        "filtS",
                        ",",
                        "filtR"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-163",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        390.0,
                        882.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-164",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        470.0,
                        882.0,
                        70.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-165",
                    "maxclass": "umenu",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "patching_rect": [
                        550.0,
                        882.0,
                        80.0,
                        22.0
                    ],
                    "outlettype": [
                        "int",
                        "",
                        ""
                    ],
                    "items": [
                        "LIN",
                        ",",
                        "EXP"
                    ],
                    "parameter_enable": 0
                }
            },
            {
                "box": {
                    "id": "obj-166",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        640.0,
                        882.0,
                        80.0,
                        22.0
                    ],
                    "outlettype": [
                        "",
                        "bang"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-167",
                    "maxclass": "newobj",
                    "numinlets": 7,
                    "numoutlets": 2,
                    "outlettype": [
                        "",
                        ""
                    ],
                    "patching_rect": [
                        740.0,
                        882.0,
                        150.0,
                        22.0
                    ],
                    "text": "p mb_slot",
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
                            80.0,
                            80.0,
                            1420.0,
                            560.0
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
                                        900.0,
                                        27.0
                                    ],
                                    "text": "ONE MAPPING SLOT - picks its source out of the list, scales it into the locked output range, and emits <address> <value>.",
                                    "fontsize": 12.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        130.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        230.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        330.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        430.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        530.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        630.0,
                                        70.0,
                                        30.0,
                                        30.0
                                    ],
                                    "outlettype": [
                                        ""
                                    ]
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
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "list"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        130.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "index"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        230.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "address"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        330.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "min"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        430.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "max"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        530.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "curve"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        630.0,
                                        104.0,
                                        90.0,
                                        20.0
                                    ],
                                    "text": "on"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        140.0,
                                        90.0,
                                        22.0
                                    ],
                                    "text": "zl nth",
                                    "outlettype": [
                                        "",
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        190.0,
                                        1300.0,
                                        22.0
                                    ],
                                    "text": "expr ($f2 + $f1 * ($f3 - $f2)) + (($i4 != 0) * ($f2 > 0) * ($f3 > 0)) * (((($f2 > 0) * $f2 + ($f2 <= 0)) * pow((($f3 > 0) * $f3 + ($f3 <= 0)) / (($f2 > 0) * $f2 + ($f2 <= 0))\\, $f1)) - ($f2 + $f1 * ($f3 - $f2)))",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        214.0,
                                        860.0,
                                        20.0
                                    ],
                                    "text": "linear, or exponential when the range is strictly positive (equal movement = equal musical intervals)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        250.0,
                                        60.0,
                                        22.0
                                    ],
                                    "text": "gate",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "patching_rect": [
                                        30.0,
                                        290.0,
                                        70.0,
                                        22.0
                                    ],
                                    "text": "t f f",
                                    "outlettype": [
                                        "float",
                                        "float"
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        330.0,
                                        260.0,
                                        22.0
                                    ],
                                    "text": "pak /movebeat/cutoff 0.",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "patching_rect": [
                                        30.0,
                                        370.0,
                                        100.0,
                                        22.0
                                    ],
                                    "text": "$1 $2",
                                    "outlettype": [
                                        ""
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        30.0,
                                        420.0,
                                        30.0,
                                        30.0
                                    ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [
                                        200.0,
                                        420.0,
                                        30.0,
                                        30.0
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
                                        "obj-16",
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
                                        "obj-16",
                                        1
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
                                        "obj-17",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-5",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        1
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-6",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        2
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-7",
                                        0
                                    ],
                                    "destination": [
                                        "obj-17",
                                        3
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-8",
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
                                        "obj-17",
                                        0
                                    ],
                                    "destination": [
                                        "obj-19",
                                        1
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
                                        "obj-4",
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
                                        "obj-20",
                                        0
                                    ],
                                    "destination": [
                                        "obj-21",
                                        1
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
                                        "obj-22",
                                        0
                                    ]
                                }
                            },
                            {
                                "patchline": {
                                    "source": [
                                        "obj-22",
                                        0
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
                                        "obj-20",
                                        1
                                    ],
                                    "destination": [
                                        "obj-24",
                                        0
                                    ]
                                }
                            }
                        ]
                    }
                }
            },
            {
                "box": {
                    "id": "obj-168",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        940.0,
                        882.0,
                        230.0,
                        22.0
                    ],
                    "text": "expr $i1 + 22 + ($i1 >= 4) * 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-169",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "patching_rect": [
                        1180.0,
                        882.0,
                        150.0,
                        22.0
                    ],
                    "text": "sprintf /movebeat/%s",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-170",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1345.0,
                        882.0,
                        60.0,
                        22.0
                    ],
                    "text": "!= 0",
                    "outlettype": [
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-171",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "patching_rect": [
                        215.0,
                        908.0,
                        60.0,
                        22.0
                    ],
                    "text": "t b i",
                    "outlettype": [
                        "bang",
                        "int"
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-172",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1420.0,
                        908.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 20 0 0 0 0 0 0 0 -24 0.05 0 0 0.01 0 0 0 0 0 0 0 0 0 0 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-173",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1420.0,
                        932.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-174",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1430.0,
                        908.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 18000 4 1 1 1 1 1 1 24 0.95 3 3 20 5000 8000 2000 2000 2000 1 4000 2000 2000 1 4000",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-175",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1430.0,
                        932.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-176",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "patching_rect": [
                        1440.0,
                        908.0,
                        60.0,
                        22.0
                    ],
                    "text": "0 1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0",
                    "outlettype": [
                        ""
                    ]
                }
            },
            {
                "box": {
                    "id": "obj-177",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "patching_rect": [
                        1440.0,
                        932.0,
                        60.0,
                        22.0
                    ],
                    "text": "zl nth",
                    "outlettype": [
                        "",
                        ""
                    ]
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "source": [
                        "obj-3",
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
                        "obj-5",
                        1
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
                        "obj-5",
                        0
                    ],
                    "destination": [
                        "obj-7",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-8",
                        0
                    ],
                    "destination": [
                        "obj-9",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-9",
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
                        "obj-6",
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
                        "obj-7",
                        0
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
                        "obj-32",
                        0
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
                        "obj-16",
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
                        "obj-18",
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
                        "obj-18",
                        1
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
                        "obj-42",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-42",
                        0
                    ],
                    "destination": [
                        "obj-20",
                        1
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
                        "obj-22",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-47",
                        0
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
                        "obj-24",
                        1
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
                        "obj-30",
                        2
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
                        "obj-28",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-11",
                        1
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
                        "obj-13",
                        1
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
                        "obj-16",
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
                        "obj-16",
                        0
                    ],
                    "destination": [
                        "obj-56",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-11",
                        2
                    ],
                    "destination": [
                        "obj-56",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-13",
                        2
                    ],
                    "destination": [
                        "obj-56",
                        1
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
                        "obj-56",
                        1
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
                        "obj-56",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-11",
                        3
                    ],
                    "destination": [
                        "obj-56",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-13",
                        3
                    ],
                    "destination": [
                        "obj-56",
                        2
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
                        "obj-56",
                        2
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
                        "obj-56",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-11",
                        4
                    ],
                    "destination": [
                        "obj-56",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-13",
                        4
                    ],
                    "destination": [
                        "obj-56",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-22",
                        0
                    ],
                    "destination": [
                        "obj-56",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-22",
                        0
                    ],
                    "destination": [
                        "obj-56",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-11",
                        5
                    ],
                    "destination": [
                        "obj-56",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-13",
                        5
                    ],
                    "destination": [
                        "obj-56",
                        4
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
                        "obj-56",
                        4
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
                        "obj-56",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-11",
                        6
                    ],
                    "destination": [
                        "obj-56",
                        5
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-13",
                        6
                    ],
                    "destination": [
                        "obj-56",
                        5
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
                        "obj-56",
                        5
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
                        "obj-56",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-11",
                        7
                    ],
                    "destination": [
                        "obj-56",
                        6
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-13",
                        7
                    ],
                    "destination": [
                        "obj-56",
                        6
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
                        "obj-56",
                        6
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
                        "obj-56",
                        8
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-11",
                        8
                    ],
                    "destination": [
                        "obj-56",
                        7
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-13",
                        8
                    ],
                    "destination": [
                        "obj-56",
                        7
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
                        "obj-56",
                        7
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
                        "obj-56",
                        8
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
                        "obj-56",
                        8
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
                        "obj-56",
                        8
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
                        "obj-60",
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
                        "obj-58",
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
                        "obj-77",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-72",
                        1
                    ],
                    "destination": [
                        "obj-79",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-79",
                        0
                    ],
                    "destination": [
                        "obj-77",
                        2
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
                        "obj-77",
                        6
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
                        "obj-81",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-81",
                        1
                    ],
                    "destination": [
                        "obj-83",
                        1
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
                        "obj-73",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-81",
                        1
                    ],
                    "destination": [
                        "obj-85",
                        1
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
                        "obj-84",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-84",
                        0
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
                        "obj-74",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-81",
                        1
                    ],
                    "destination": [
                        "obj-87",
                        1
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
                        "obj-75",
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
                        "obj-77",
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
                        "obj-77",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-74",
                        0
                    ],
                    "destination": [
                        "obj-77",
                        4
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
                        "obj-77",
                        5
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
                        "obj-58",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-77",
                        1
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
                        "obj-89",
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
                        "obj-95",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-90",
                        1
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
                        "obj-95",
                        2
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
                        "obj-95",
                        6
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
                        "obj-99",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-99",
                        1
                    ],
                    "destination": [
                        "obj-101",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-99",
                        0
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
                        "obj-91",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-99",
                        1
                    ],
                    "destination": [
                        "obj-103",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-99",
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
                        "obj-92",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-99",
                        1
                    ],
                    "destination": [
                        "obj-105",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-99",
                        0
                    ],
                    "destination": [
                        "obj-104",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-104",
                        0
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
                        "obj-93",
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
                        "obj-95",
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
                        "obj-95",
                        3
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
                        "obj-95",
                        4
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
                        "obj-95",
                        5
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
                        "obj-58",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-95",
                        1
                    ],
                    "destination": [
                        "obj-94",
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
                        "obj-114",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-114",
                        0
                    ],
                    "destination": [
                        "obj-113",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-108",
                        1
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
                        "obj-113",
                        2
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
                        "obj-113",
                        6
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
                        "obj-117",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-117",
                        1
                    ],
                    "destination": [
                        "obj-119",
                        1
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
                        "obj-119",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-119",
                        0
                    ],
                    "destination": [
                        "obj-109",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-117",
                        1
                    ],
                    "destination": [
                        "obj-121",
                        1
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
                        "obj-110",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-117",
                        1
                    ],
                    "destination": [
                        "obj-123",
                        1
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
                        "obj-111",
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
                        "obj-113",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-109",
                        0
                    ],
                    "destination": [
                        "obj-113",
                        3
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
                        "obj-113",
                        4
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
                        "obj-113",
                        5
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
                        "obj-58",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-113",
                        1
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
                        "obj-125",
                        0
                    ],
                    "destination": [
                        "obj-132",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-132",
                        0
                    ],
                    "destination": [
                        "obj-131",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-126",
                        1
                    ],
                    "destination": [
                        "obj-133",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-133",
                        0
                    ],
                    "destination": [
                        "obj-131",
                        2
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
                        "obj-134",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-134",
                        0
                    ],
                    "destination": [
                        "obj-131",
                        6
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
                        "obj-135",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-135",
                        1
                    ],
                    "destination": [
                        "obj-137",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-135",
                        0
                    ],
                    "destination": [
                        "obj-136",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-136",
                        0
                    ],
                    "destination": [
                        "obj-137",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-137",
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
                        "obj-135",
                        1
                    ],
                    "destination": [
                        "obj-139",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-135",
                        0
                    ],
                    "destination": [
                        "obj-138",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-138",
                        0
                    ],
                    "destination": [
                        "obj-139",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-139",
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
                        "obj-135",
                        1
                    ],
                    "destination": [
                        "obj-141",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-135",
                        0
                    ],
                    "destination": [
                        "obj-140",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-140",
                        0
                    ],
                    "destination": [
                        "obj-141",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-141",
                        0
                    ],
                    "destination": [
                        "obj-129",
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
                        "obj-131",
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
                        "obj-131",
                        3
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
                        "obj-131",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-129",
                        0
                    ],
                    "destination": [
                        "obj-131",
                        5
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-131",
                        0
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
                        "obj-131",
                        1
                    ],
                    "destination": [
                        "obj-130",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-143",
                        0
                    ],
                    "destination": [
                        "obj-150",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-150",
                        0
                    ],
                    "destination": [
                        "obj-149",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-144",
                        1
                    ],
                    "destination": [
                        "obj-151",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-151",
                        0
                    ],
                    "destination": [
                        "obj-149",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-144",
                        0
                    ],
                    "destination": [
                        "obj-152",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-152",
                        0
                    ],
                    "destination": [
                        "obj-149",
                        6
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-144",
                        0
                    ],
                    "destination": [
                        "obj-153",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-153",
                        1
                    ],
                    "destination": [
                        "obj-155",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-153",
                        0
                    ],
                    "destination": [
                        "obj-154",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-154",
                        0
                    ],
                    "destination": [
                        "obj-155",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-155",
                        0
                    ],
                    "destination": [
                        "obj-145",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-153",
                        1
                    ],
                    "destination": [
                        "obj-157",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-153",
                        0
                    ],
                    "destination": [
                        "obj-156",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-156",
                        0
                    ],
                    "destination": [
                        "obj-157",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-157",
                        0
                    ],
                    "destination": [
                        "obj-146",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-153",
                        1
                    ],
                    "destination": [
                        "obj-159",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-153",
                        0
                    ],
                    "destination": [
                        "obj-158",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-158",
                        0
                    ],
                    "destination": [
                        "obj-159",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-159",
                        0
                    ],
                    "destination": [
                        "obj-147",
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
                        "obj-149",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-145",
                        0
                    ],
                    "destination": [
                        "obj-149",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-146",
                        0
                    ],
                    "destination": [
                        "obj-149",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-147",
                        0
                    ],
                    "destination": [
                        "obj-149",
                        5
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-149",
                        0
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
                        "obj-149",
                        1
                    ],
                    "destination": [
                        "obj-148",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-161",
                        0
                    ],
                    "destination": [
                        "obj-168",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-168",
                        0
                    ],
                    "destination": [
                        "obj-167",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-162",
                        1
                    ],
                    "destination": [
                        "obj-169",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-169",
                        0
                    ],
                    "destination": [
                        "obj-167",
                        2
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-162",
                        0
                    ],
                    "destination": [
                        "obj-170",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-170",
                        0
                    ],
                    "destination": [
                        "obj-167",
                        6
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-162",
                        0
                    ],
                    "destination": [
                        "obj-171",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-171",
                        1
                    ],
                    "destination": [
                        "obj-173",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-171",
                        0
                    ],
                    "destination": [
                        "obj-172",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-172",
                        0
                    ],
                    "destination": [
                        "obj-173",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-173",
                        0
                    ],
                    "destination": [
                        "obj-163",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-171",
                        1
                    ],
                    "destination": [
                        "obj-175",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-171",
                        0
                    ],
                    "destination": [
                        "obj-174",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-174",
                        0
                    ],
                    "destination": [
                        "obj-175",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-175",
                        0
                    ],
                    "destination": [
                        "obj-164",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-171",
                        1
                    ],
                    "destination": [
                        "obj-177",
                        1
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-171",
                        0
                    ],
                    "destination": [
                        "obj-176",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-176",
                        0
                    ],
                    "destination": [
                        "obj-177",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-177",
                        0
                    ],
                    "destination": [
                        "obj-165",
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
                        "obj-167",
                        0
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-163",
                        0
                    ],
                    "destination": [
                        "obj-167",
                        3
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-164",
                        0
                    ],
                    "destination": [
                        "obj-167",
                        4
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-165",
                        0
                    ],
                    "destination": [
                        "obj-167",
                        5
                    ]
                }
            },
            {
                "patchline": {
                    "source": [
                        "obj-167",
                        0
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
                        "obj-167",
                        1
                    ],
                    "destination": [
                        "obj-166",
                        0
                    ]
                }
            }
        ]
    }
}