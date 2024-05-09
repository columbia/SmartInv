1 // SPDX-License-Identifier: UNLICENSED
2 /*  ______    ___    ______    ______   _____          ____     ______           ____     ______    __ __  ______
3    / ____/   /   |  / ____/   / ____/  / ___/         / __ \   / ____/          / __ \   / ____/   / //_/ /_  __/
4   / /_      / /| | / /       / __/     \__ \         / / / /  / /_             / /_/ /  / __/     / ,<     / /
5  / __/     / ___ |/ /___    / /___    ___/ /        / /_/ /  / __/            / _, _/  / /___    / /| |   / /
6 /_/       /_/  |_|\____/   /_____/   /____/         \____/  /_/              /_/ |_|  /_____/   /_/ |_|  /_/
7                                                                                                                  */
8 /*ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
9 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
10 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
11 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
12 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
13 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
14 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
15 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
16 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
17 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
18 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
19 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
20 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@@@@@%%(%%@@@@@%%%@((%@@@@@@@@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
21 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@@@@%#(/////((((%%@@@(((///%%@&%(((@@@@@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
22 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@@@@%%///%(((%&%%&%%%(((((%%@@@@%%((((%&&&&((/&&%#(@@@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
23 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@(((///(((%%&&&&&%(((((((((((((@@@@(((%%&&%((/&&/%%&&&&&%((@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
24 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@&&&%%((///(&&%(((#%(((///((%@@@@@@@@%%(((/#&&&%&&%//(&&((&((%@@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
25 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@@%(((%%&&&&&&%%&&&&&%///((%&&&#(((((((@@%//(((&&/((&(((((&&%&&/((@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
26 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@@%%&((%&&%%&%%((((((%&&%%(%%&&&&&&&&%((%@@@((%&&&&%&&&(((((&&&((&((@@@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
27 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@,,.//@((%&&&&&%%(///((%((%&&&&((((///((&&((((((%@@(((((&%%(//%(/((&%%(((@@@/º.@@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
28 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº../((((((%%&&%&&&&&&&&&&%(((%%&%%(((%%&%%///%@@@&%((%&&&&&&&&&&%((/@@@,,/#@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
29 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@..,@@@@@&&&%%(((%&&&%%((((((%%&&&%#(((%&&&&&&@@@@&&&&&&&%%%%%%%&&&@@@/..@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
30 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@,,............//.../,,......................,,,/º,....................,,@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
31 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@..............,,///.....................................................@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
32 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@........................................................................@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
33 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@........................................................................@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
34 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@........................................................................@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
35 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@..........................................,,............................,(@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
36 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@......,,.....,..,.........................,,............................./@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
37 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@......,,.....,..,.........................,,.,,.......................//./@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
38 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@.....,,,.....,......................@@@...,,,,,.....@@@...............///#@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
39 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@.....,.......,...................@@@@@@.....,,,...,,@@@@@@............@@@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
40 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@.....,......./...............................//...//..................@@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
41 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@.....,.....//,........@#,......,,@,..........,,///,,....@@,.......,@@.@@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
42 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº#@....................@@@#,......,,@@@@@.................@@@,.......,@@@@@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
43 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@,,,...,,@................@,,,,.........,&@@@...............@@,,,.........,,@@@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
44 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@,,.........,,...............@@@@@@@@@@@@@@@@......,,...........@@@@@@@@@@@@@@@@@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
45 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@...////////...................@#º((ººº(@@///......,,.,,...,,....@@(#####((@///@@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
46 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@...//,º///,...................@%(ººº((%@@///......,,///...,,....@@%####%%%@///@@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
47 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@...///º,,,....................@%((((%%#@@///.........,,///,,....@@./(((///@///,,@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
48 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@...,,,º/,,/...................@%///(ºº(@@///....................@@(((..(%%@///..@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
49 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@.....,,,,,,...................@%(%%%((º@@///....................@@/////(ºº@///..,(@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
50 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@...@@.....,......,,..,......@@%%%@@...@(((//................,...@@%(///(((@///.../@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
51 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@...@@.....,......,,../.....@%%%&@ººº@@((((@@.....,..........,...@@/%%%%@(((@@@.../@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
52 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@,,,@@.....@,,....//........@%%#(º...ººººº@,......@,,......,,@..@@@.&@///((///@..,(@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
53 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@@@(...@..,...//........@%%#(º...ººººº@,.......,,@@@@@@@@,......&@///@@///@..@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
54 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@ @@ (@,,@...,,/..........@%%#&@...ººººº@,..........,,,,,.........&@///@@///@..@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
55 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@  #&@,,.................@%%#&@...@@@@@............................@@@@@///@..@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
56 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@###&@,,..................@@%&@...@@.........../@@@@@@@@@@/...........@@///@..@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
57 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@((((((%%@../.................(@ººº@@.........@@@@@@@@@@@@@@@@.........@@(((@..@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
58 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@%%(%%(%@((@../.................................@@@@@@@@@@@@@@@@............,,@..@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
59 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@%%(%%(%@@@...@,,............................,,.@@@@@@@@@@@@@@@@............//@..@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
60 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@@@@@#ººº@@@º@@/...........................,,.%%@@@%%%@@@@@@@@.........,,@@@,,,@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
61 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@(/.........................,,.###%%@%%##%@@@@@........,@@º@@,,,@%ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
62 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@@......................../...,,,,,,,,,,......,//@@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
63 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@...,,@...,,@@@,,,,,,,,,,,@@@@@@@@@@@@@@@@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
64 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@...,,@...,,@@@,,,,,,,,,,,,,@,,...@%,...@@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
65 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@,,.,,@@@@#º@@@,,,,,,,,,,,@@@@@@@@,(@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
66 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@,,,,,@ººº#@((@@@@@@@@@@@@   @@,,,@@@ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
67 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@@(º,              ,, ((      ,,@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
68 ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@@@@@@@@(((,,                    ,, ((         ,,(@@@/ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
69 ºººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº@@@@@@@@@@@@((,                              ,, ((         ,,@@@(@@@@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
70 ººººººººººººººººººººººººººººººººººººººººººººººººººººº/@@@(,,,           ,,(                              ,, ((              ,,,,,(@@@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
71 ºººººººººººººººººººººººººººººººººººººººººººººººººº@@@@(,,                                                ,, ((               .,,,,((@@@@@@@@@@@ººººººººººººººººººººººººººººººººººººººººººººººººººººººººº
72 ºººººººººººººººººººººººººººººººººººººººººººººº@@@@@@(/                            ,,,(@@@%(,,            ,, ((              ,/(@@@((,          ,((@ººººººººººººººººººººººººººººººººººººººººººººººººººººº
73 ººººººººººººººººººººººººººººººººººººººººº@@(,,    ,,(/                               ,,,,,,((@@@(,,         ((        ,(((,,                      ,((@/ººººººººººººººººººººººººººººººººººººººººººººººººº
74 ººººººººººººººººººººººººººººººººººººººº#@((           ,                                 ,,,,,,((@@@@#(,, ,, ((                                     ,,(&@ºººººººººººººººººººººººººººººººººººººººººººººººº
75 ººººººººººººººººººººººººººººººººººººººº#@                            ((,                                    ((                              ,,,(((@@@@@@@@ºººººººººººººººººººººººººººººººººººººººººººººº
76 ººººººººººººººººººººººººººººººººººººººº#@                            ,,@((                               ,, ((                 ,,,(((@@@@@@@@@@@@@&%%%#(@@ºººººººººººººººººººººººººººººººººººººººººººººº
77 ººººººººººººººººººººººººººººººººººººººº#@,,                            ,@@(        ,,(((@@@@@@@@@@@@@@,,    ((@@@@@@@@@@@&%%%#((((((((((((((((((((((((((&&@ººººººººººººººººººººººººººººººººººººººººººººº
78 ºººººººººººººººººººººººººººººººººººººº@%(@@(,,                          ,,@.    ,,@%%%%%%#((((((((((((((@%%((((((((((((((((((((((((((((((((((((((((@@%#(%%@ººººººººººººººººººººººººººººººººººººººººººººº
79 ºººººººººººººººººººººººººººººººººººººº@%(((@((,                        @@@@@@@@@@@@%%%%%@@@@@@@@@@@@%%ºº(@@&((((((((((((((((((((((((((((@@%#((((((((((((%%@ººººººººººººººººººººººººººººººººººººººººººººº
80 ºººººººººººººººººººººººººººººººººººººº@%(,,,,,@@@@@@(((@@@&&%((((((((((((((((((((((((%&&@@&%%(((((((#%@@ººº@&&(((@&%%%((((((((((((((((((((((((((((((((((((@ººººººººººººººººººººººººººººººººººººººººººººº
81 ººººººººººººººººººººººººººººººººººººººº#@@@@@@&%%(@@(((@@&%%(((((((((((((((((((((((%%&%%(((((((((&&@@@@@(ºº(@@((((((((((((((((((((((((((((((((((((////////@ººººººººººººººººººººººººººººººººººººººººººººº
82 ººººººººººººººººººººººººººººººººººººººº#@&&%((((((((%#(%%@%%((((((((((((((@%%(((((&%%(((((((((((((((#%%%@ººº@@((((((((((((//////////////(((#%%%&&&@@@@@@@@@@@ººººººººººººººººººººººººººººººººººººººººººº
83 ººººººººººººººººººººººººººººººººººººººº#@&&%(((@@%((%#(((@%%((((((((((((((((((#&%%(((((((((((/(((%%&&&&&&ººº@@&&&@@@@@@@@@@@@@@@@(@@((((((,,,             ,@@@ºººººººººººººººººººººººººººººººººººººººººº
84 ººººººººººººººººººººººººººººººººººººººº#@&&%((((((((%#(((@%%(((((((((////////&&@(((((((((((//(%%&&&@@@@@(ºº(@@@@@@#,,,           (@@                       ((@ºººººººººººººººººººººººººººººººººººººººººº
85 ººººººººººººººººººººººººººººººººººººººº#@&&%(((((((((#@((&@@&%%&@@@@@@@@@@@@@@@///////////(%%&@@%((((((((@@(,,           ,,,(((@@@@@                         @ºººººººººººººººººººººººººººººººººººººººººº
86 ºººººººººººººººººººººººººººººººººººººº@@&&&&%%%&&@@@@@@%%%@@@@@@%(((,((@((,,,@@(////////(#%&&@@@@@@@@@@@@((,                     ,((@,,                      (@@ºººººººººººººººººººººººººººººººººººººººº
87 ºººººººººººººººººººººººººººººººººººººº@%(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@,,,((@&&&&&&&&@@@(((,,                                       ,                     ,@@ºººººººººººººººººººººººººººººººººººººººº
88 */
89 /*
90    _____    ____    _____  ____ _   __  __         _____  ____ _   ____  ____
91   / ___/   / __ \  / ___/ / __ `/  / / / /        / ___/ / __ `/  / __ \/_  /
92  (__  )   / /_/ / / /    / /_/ /  / /_/ /        / /__  / /_/ /  / / / / / /_
93 /____/   / .___/ /_/     \__,_/   \__, /         \___/  \__,_/  /_/ /_/ /___/
94         /_/                      /____/                                      */
95 
96 //THE GREAT REKT LAUNCH EVENT WILL NOT BE FORGOTTEN -pixelrogueart
97 
98 pragma solidity ^0.8.0;
99 
100 
101 library MerkleProof {
102 
103     function verify(
104         bytes32[] memory proof,
105         bytes32 root,
106         bytes32 leaf
107     ) internal pure returns (bool) {
108         return processProof(proof, leaf) == root;
109     }
110     function verifyCalldata(
111         bytes32[] calldata proof,
112         bytes32 root,
113         bytes32 leaf
114     ) internal pure returns (bool) {
115         return processProofCalldata(proof, leaf) == root;
116     }
117     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
118         bytes32 computedHash = leaf;
119         for (uint256 i = 0; i < proof.length; i++) {
120             computedHash = _hashPair(computedHash, proof[i]);
121         }
122         return computedHash;
123     }
124     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
125         bytes32 computedHash = leaf;
126         for (uint256 i = 0; i < proof.length; i++) {
127             computedHash = _hashPair(computedHash, proof[i]);
128         }
129         return computedHash;
130     }
131     function multiProofVerify(
132         bytes32[] memory proof,
133         bool[] memory proofFlags,
134         bytes32 root,
135         bytes32[] memory leaves
136     ) internal pure returns (bool) {
137         return processMultiProof(proof, proofFlags, leaves) == root;
138     }
139     function multiProofVerifyCalldata(
140         bytes32[] calldata proof,
141         bool[] calldata proofFlags,
142         bytes32 root,
143         bytes32[] memory leaves
144     ) internal pure returns (bool) {
145         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
146     }
147     function processMultiProof(
148         bytes32[] memory proof,
149         bool[] memory proofFlags,
150         bytes32[] memory leaves
151     ) internal pure returns (bytes32 merkleRoot) {
152 
153         uint256 leavesLen = leaves.length;
154         uint256 totalHashes = proofFlags.length;
155 
156         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
157 
158         bytes32[] memory hashes = new bytes32[](totalHashes);
159         uint256 leafPos = 0;
160         uint256 hashPos = 0;
161         uint256 proofPos = 0;
162 
163         for (uint256 i = 0; i < totalHashes; i++) {
164             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
165             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
166             hashes[i] = _hashPair(a, b);
167         }
168 
169         if (totalHashes > 0) {
170             return hashes[totalHashes - 1];
171         } else if (leavesLen > 0) {
172             return leaves[0];
173         } else {
174             return proof[0];
175         }
176     }
177 
178     function processMultiProofCalldata(
179         bytes32[] calldata proof,
180         bool[] calldata proofFlags,
181         bytes32[] memory leaves
182     ) internal pure returns (bytes32 merkleRoot) {
183 
184         uint256 leavesLen = leaves.length;
185         uint256 totalHashes = proofFlags.length;
186 
187 
188         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
189 
190         bytes32[] memory hashes = new bytes32[](totalHashes);
191         uint256 leafPos = 0;
192         uint256 hashPos = 0;
193         uint256 proofPos = 0;
194 
195         for (uint256 i = 0; i < totalHashes; i++) {
196             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
197             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
198             hashes[i] = _hashPair(a, b);
199         }
200 
201         if (totalHashes > 0) {
202             return hashes[totalHashes - 1];
203         } else if (leavesLen > 0) {
204             return leaves[0];
205         } else {
206             return proof[0];
207         }
208     }
209 
210     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
211         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
212     }
213 
214     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
215 
216         assembly {
217             mstore(0x00, a)
218             mstore(0x20, b)
219             value := keccak256(0x00, 0x40)
220         }
221     }
222 }
223 
224 pragma solidity ^0.8.0;
225 library Strings {
226     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
227 
228     function toString(uint256 value) internal pure returns (string memory) {
229 
230         if (value == 0) {
231             return "0";
232         }
233         uint256 temp = value;
234         uint256 digits;
235         while (temp != 0) {
236             digits++;
237             temp /= 10;
238         }
239         bytes memory buffer = new bytes(digits);
240         while (value != 0) {
241             digits -= 1;
242             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
243             value /= 10;
244         }
245         return string(buffer);
246     }
247 
248     function toHexString(uint256 value) internal pure returns (string memory) {
249         if (value == 0) {
250             return "0x00";
251         }
252         uint256 temp = value;
253         uint256 length = 0;
254         while (temp != 0) {
255             length++;
256             temp >>= 8;
257         }
258         return toHexString(value, length);
259     }
260 
261     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
262         bytes memory buffer = new bytes(2 * length + 2);
263         buffer[0] = "0";
264         buffer[1] = "x";
265         for (uint256 i = 2 * length + 1; i > 1; --i) {
266             buffer[i] = _HEX_SYMBOLS[value & 0xf];
267             value >>= 4;
268         }
269         require(value == 0, "Strings: hex length insufficient");
270         return string(buffer);
271     }
272 }
273 
274 
275 pragma solidity ^0.8.0;
276 
277 library ECDSA {
278     enum RecoverError {
279         NoError,
280         InvalidSignature,
281         InvalidSignatureLength,
282         InvalidSignatureS,
283         InvalidSignatureV
284     }
285 
286     function _throwError(RecoverError error) private pure {
287         if (error == RecoverError.NoError) {
288             return; // no error: do nothing
289         } else if (error == RecoverError.InvalidSignature) {
290             revert("ECDSA: invalid signature");
291         } else if (error == RecoverError.InvalidSignatureLength) {
292             revert("ECDSA: invalid signature length");
293         } else if (error == RecoverError.InvalidSignatureS) {
294             revert("ECDSA: invalid signature 's' value");
295         } else if (error == RecoverError.InvalidSignatureV) {
296             revert("ECDSA: invalid signature 'v' value");
297         }
298     }
299 
300     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
301         if (signature.length == 65) {
302             bytes32 r;
303             bytes32 s;
304             uint8 v;
305             assembly {
306                 r := mload(add(signature, 0x20))
307                 s := mload(add(signature, 0x40))
308                 v := byte(0, mload(add(signature, 0x60)))
309             }
310             return tryRecover(hash, v, r, s);
311         } else if (signature.length == 64) {
312             bytes32 r;
313             bytes32 vs;
314             assembly {
315                 r := mload(add(signature, 0x20))
316                 vs := mload(add(signature, 0x40))
317             }
318             return tryRecover(hash, r, vs);
319         } else {
320             return (address(0), RecoverError.InvalidSignatureLength);
321         }
322     }
323 
324     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
325         (address recovered, RecoverError error) = tryRecover(hash, signature);
326         _throwError(error);
327         return recovered;
328     }
329 
330     function tryRecover(
331         bytes32 hash,
332         bytes32 r,
333         bytes32 vs
334     ) internal pure returns (address, RecoverError) {
335         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
336         uint8 v = uint8((uint256(vs) >> 255) + 27);
337         return tryRecover(hash, v, r, s);
338     }
339 
340     function recover(
341         bytes32 hash,
342         bytes32 r,
343         bytes32 vs
344     ) internal pure returns (address) {
345         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
346         _throwError(error);
347         return recovered;
348     }
349 
350     function tryRecover(
351         bytes32 hash,
352         uint8 v,
353         bytes32 r,
354         bytes32 s
355     ) internal pure returns (address, RecoverError) {
356         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
357             return (address(0), RecoverError.InvalidSignatureS);
358         }
359         if (v != 27 && v != 28) {
360             return (address(0), RecoverError.InvalidSignatureV);
361         }
362 
363         // If the signature is valid (and not malleable), return the signer address
364         address signer = ecrecover(hash, v, r, s);
365         if (signer == address(0)) {
366             return (address(0), RecoverError.InvalidSignature);
367         }
368 
369         return (signer, RecoverError.NoError);
370     }
371 
372     function recover(
373         bytes32 hash,
374         uint8 v,
375         bytes32 r,
376         bytes32 s
377     ) internal pure returns (address) {
378         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
379         _throwError(error);
380         return recovered;
381     }
382 
383     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
384 
385         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
386     }
387 
388     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
389         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
390     }
391 
392     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
393         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
394     }
395 }
396 
397 pragma solidity ^0.8.0;
398 
399 abstract contract Context {
400     function _msgSender() internal view virtual returns (address) {
401         return msg.sender;
402     }
403 
404     function _msgData() internal view virtual returns (bytes calldata) {
405         return msg.data;
406     }
407 }
408 
409 pragma solidity ^0.8.0;
410 
411 abstract contract Ownable is Context {
412     address private _owner;
413 
414     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
415     constructor() {
416         _transferOwnership(_msgSender());
417     }
418 
419     function owner() public view virtual returns (address) {
420         return _owner;
421     }
422 
423     modifier onlyOwner() {
424         require(owner() == _msgSender(), "Ownable: caller is not the owner");
425         _;
426     }
427 
428     function renounceOwnership() public virtual onlyOwner {
429         _transferOwnership(address(0));
430     }
431 
432     function transferOwnership(address newOwner) public virtual onlyOwner {
433         require(newOwner != address(0), "Ownable: new owner is the zero address");
434         _transferOwnership(newOwner);
435     }
436 
437     function _transferOwnership(address newOwner) internal virtual {
438         address oldOwner = _owner;
439         _owner = newOwner;
440         emit OwnershipTransferred(oldOwner, newOwner);
441     }
442 }
443 
444 pragma solidity ^0.8.1;
445 
446 library Address {
447 
448     function isContract(address account) internal view returns (bool) {
449 
450         return account.code.length > 0;
451     }
452 
453 
454     function sendValue(address payable recipient, uint256 amount) internal {
455         require(address(this).balance >= amount, "Address: insufficient balance");
456 
457         (bool success, ) = recipient.call{value: amount}("");
458         require(success, "Address: unable to send value, recipient may have reverted");
459     }
460 
461     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
462         return functionCall(target, data, "Address: low-level call failed");
463     }
464 
465     function functionCall(
466         address target,
467         bytes memory data,
468         string memory errorMessage
469     ) internal returns (bytes memory) {
470         return functionCallWithValue(target, data, 0, errorMessage);
471     }
472 
473     function functionCallWithValue(
474         address target,
475         bytes memory data,
476         uint256 value
477     ) internal returns (bytes memory) {
478         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
479     }
480 
481     function functionCallWithValue(
482         address target,
483         bytes memory data,
484         uint256 value,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         require(address(this).balance >= value, "Address: insufficient balance for call");
488         require(isContract(target), "Address: call to non-contract");
489 
490         (bool success, bytes memory returndata) = target.call{value: value}(data);
491         return verifyCallResult(success, returndata, errorMessage);
492     }
493 
494     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
495         return functionStaticCall(target, data, "Address: low-level static call failed");
496     }
497 
498     function functionStaticCall(
499         address target,
500         bytes memory data,
501         string memory errorMessage
502     ) internal view returns (bytes memory) {
503         require(isContract(target), "Address: static call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.staticcall(data);
506         return verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
510         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
511     }
512 
513     function functionDelegateCall(
514         address target,
515         bytes memory data,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         require(isContract(target), "Address: delegate call to non-contract");
519 
520         (bool success, bytes memory returndata) = target.delegatecall(data);
521         return verifyCallResult(success, returndata, errorMessage);
522     }
523 
524     function verifyCallResult(
525         bool success,
526         bytes memory returndata,
527         string memory errorMessage
528     ) internal pure returns (bytes memory) {
529         if (success) {
530             return returndata;
531         } else {
532             if (returndata.length > 0) {
533 
534                 assembly {
535                     let returndata_size := mload(returndata)
536                     revert(add(32, returndata), returndata_size)
537                 }
538             } else {
539                 revert(errorMessage);
540             }
541         }
542     }
543 }
544 
545 pragma solidity ^0.8.0;
546 
547 interface IERC721Receiver {
548 
549     function onERC721Received(
550         address operator,
551         address from,
552         uint256 tokenId,
553         bytes calldata data
554     ) external returns (bytes4);
555 }
556 
557 
558 pragma solidity ^0.8.0;
559 
560 interface IERC165 {
561     function supportsInterface(bytes4 interfaceId) external view returns (bool);
562 }
563 
564 pragma solidity ^0.8.0;
565 
566 abstract contract ERC165 is IERC165 {
567 
568     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569         return interfaceId == type(IERC165).interfaceId;
570     }
571 }
572 
573 
574 
575 pragma solidity ^0.8.0;
576 
577 interface IERC721 is IERC165 {
578 
579     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
580 
581     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
582 
583     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
584 
585     function balanceOf(address owner) external view returns (uint256 balance);
586 
587     function ownerOf(uint256 tokenId) external view returns (address owner);
588 
589     function safeTransferFrom(
590         address from,
591         address to,
592         uint256 tokenId,
593         bytes calldata data
594     ) external;
595 
596     function safeTransferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) external;
601 
602     function transferFrom(
603         address from,
604         address to,
605         uint256 tokenId
606     ) external;
607 
608     function approve(address to, uint256 tokenId) external;
609 
610     function setApprovalForAll(address operator, bool _approved) external;
611 
612     function getApproved(uint256 tokenId) external view returns (address operator);
613 
614     function isApprovedForAll(address owner, address operator) external view returns (bool);
615 }
616 
617 pragma solidity ^0.8.0;
618 
619 interface IERC721Metadata is IERC721 {
620 
621     function name() external view returns (string memory);
622 
623 
624     function symbol() external view returns (string memory);
625 
626 
627     function tokenURI(uint256 tokenId) external view returns (string memory);
628 }
629 
630 pragma solidity ^0.8.0;
631 
632 
633 
634 
635 
636 
637 
638 
639 
640 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
641     using Address for address;
642     using Strings for uint256;
643 
644     string private _name;
645 
646     string private _symbol;
647 
648     mapping(uint256 => address) private _owners;
649 
650     mapping(address => uint256) private _balances;
651 
652     mapping(uint256 => address) private _tokenApprovals;
653 
654     mapping(address => mapping(address => bool)) private _operatorApprovals;
655 
656     constructor(string memory name_, string memory symbol_) {
657         _name = name_;
658         _symbol = symbol_;
659     }
660 
661 
662     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
663         return
664         interfaceId == type(IERC721).interfaceId ||
665         interfaceId == type(IERC721Metadata).interfaceId ||
666         super.supportsInterface(interfaceId);
667     }
668 
669 
670     function balanceOf(address owner) public view virtual override returns (uint256) {
671         require(owner != address(0), "ERC721: balance query for the zero address");
672         return _balances[owner];
673     }
674 
675 
676     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
677         address owner = _owners[tokenId];
678         require(owner != address(0), "ERC721: owner query for nonexistent token");
679         return owner;
680     }
681 
682 
683     function name() public view virtual override returns (string memory) {
684         return _name;
685     }
686 
687 
688     function symbol() public view virtual override returns (string memory) {
689         return _symbol;
690     }
691 
692 
693     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
694         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
695 
696         string memory baseURI = _baseURI();
697         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
698     }
699 
700 
701     function _baseURI() internal view virtual returns (string memory) {
702         return "";
703     }
704 
705 
706     function approve(address to, uint256 tokenId) public virtual override {
707         address owner = ERC721.ownerOf(tokenId);
708         require(to != owner, "ERC721: approval to current owner");
709 
710         require(
711             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
712             "ERC721: approve caller is not owner nor approved for all"
713         );
714 
715         _approve(to, tokenId);
716     }
717 
718 
719     function getApproved(uint256 tokenId) public view virtual override returns (address) {
720         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
721 
722         return _tokenApprovals[tokenId];
723     }
724 
725 
726     function setApprovalForAll(address operator, bool approved) public virtual override {
727         _setApprovalForAll(_msgSender(), operator, approved);
728     }
729 
730 
731     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
732         return _operatorApprovals[owner][operator];
733     }
734 
735 
736     function transferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) public virtual override {
741 
742         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
743 
744         _transfer(from, to, tokenId);
745     }
746 
747 
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 tokenId
752     ) public virtual override {
753         safeTransferFrom(from, to, tokenId, "");
754     }
755 
756 
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory _data
762     ) public virtual override {
763         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
764         _safeTransfer(from, to, tokenId, _data);
765     }
766 
767 
768     function _safeTransfer(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes memory _data
773     ) internal virtual {
774         _transfer(from, to, tokenId);
775         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
776     }
777 
778 
779     function _exists(uint256 tokenId) internal view virtual returns (bool) {
780         return _owners[tokenId] != address(0);
781     }
782 
783 
784     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
785         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
786         address owner = ERC721.ownerOf(tokenId);
787         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
788     }
789 
790     function _safeMint(address to, uint256 tokenId) internal virtual {
791         _safeMint(to, tokenId, "");
792     }
793 
794 
795     function _safeMint(
796         address to,
797         uint256 tokenId,
798         bytes memory _data
799     ) internal virtual {
800         _mint(to, tokenId);
801         require(
802             _checkOnERC721Received(address(0), to, tokenId, _data),
803             "ERC721: transfer to non ERC721Receiver implementer"
804         );
805     }
806 
807 
808     function _mint(address to, uint256 tokenId) internal virtual {
809         require(to != address(0), "ERC721: mint to the zero address");
810         require(!_exists(tokenId), "ERC721: token already minted");
811 
812         _beforeTokenTransfer(address(0), to, tokenId);
813 
814         _balances[to] += 1;
815         _owners[tokenId] = to;
816 
817         emit Transfer(address(0), to, tokenId);
818 
819         _afterTokenTransfer(address(0), to, tokenId);
820     }
821 
822 
823     function _burn(uint256 tokenId) internal virtual {
824         address owner = ERC721.ownerOf(tokenId);
825 
826         _beforeTokenTransfer(owner, address(0), tokenId);
827 
828         // Clear approvals
829         _approve(address(0), tokenId);
830 
831         _balances[owner] -= 1;
832         delete _owners[tokenId];
833 
834         emit Transfer(owner, address(0), tokenId);
835 
836         _afterTokenTransfer(owner, address(0), tokenId);
837     }
838 
839 
840     function _transfer(
841         address from,
842         address to,
843         uint256 tokenId
844     ) internal virtual {
845         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
846         require(to != address(0), "ERC721: transfer to the zero address");
847 
848         _beforeTokenTransfer(from, to, tokenId);
849 
850         _approve(address(0), tokenId);
851 
852         _balances[from] -= 1;
853         _balances[to] += 1;
854         _owners[tokenId] = to;
855 
856         emit Transfer(from, to, tokenId);
857 
858         _afterTokenTransfer(from, to, tokenId);
859     }
860 
861 
862     function _approve(address to, uint256 tokenId) internal virtual {
863         _tokenApprovals[tokenId] = to;
864         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
865     }
866 
867 
868     function _setApprovalForAll(
869         address owner,
870         address operator,
871         bool approved
872     ) internal virtual {
873         require(owner != operator, "ERC721: approve to caller");
874         _operatorApprovals[owner][operator] = approved;
875         emit ApprovalForAll(owner, operator, approved);
876     }
877 
878 
879     function _checkOnERC721Received(
880         address from,
881         address to,
882         uint256 tokenId,
883         bytes memory _data
884     ) private returns (bool) {
885         if (to.isContract()) {
886             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
887                 return retval == IERC721Receiver.onERC721Received.selector;
888             } catch (bytes memory reason) {
889                 if (reason.length == 0) {
890                     revert("ERC721: transfer to non ERC721Receiver implementer");
891                 } else {
892                     assembly {
893                         revert(add(32, reason), mload(reason))
894                     }
895                 }
896             }
897         } else {
898             return true;
899         }
900     }
901 
902     function _beforeTokenTransfer(
903         address from,
904         address to,
905         uint256 tokenId
906     ) internal virtual {}
907 
908     function _afterTokenTransfer(
909         address from,
910         address to,
911         uint256 tokenId
912     ) internal virtual {}
913 }
914 
915 pragma solidity ^0.8.0;
916 
917 abstract contract ERC721URIStorage is ERC721 {
918     using Strings for uint256;
919 
920 
921     mapping(uint256 => string) private _tokenURIs;
922 
923 
924     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
925         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
926 
927         string memory _tokenURI = _tokenURIs[tokenId];
928         string memory base = _baseURI();
929 
930 
931         if (bytes(base).length == 0) {
932             return _tokenURI;
933         }
934 
935         if (bytes(_tokenURI).length > 0) {
936             return string(abi.encodePacked(base, _tokenURI));
937         }
938 
939         return super.tokenURI(tokenId);
940     }
941 
942 
943     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
944         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
945         _tokenURIs[tokenId] = _tokenURI;
946     }
947 
948     function _burn(uint256 tokenId) internal virtual override {
949         super._burn(tokenId);
950 
951         if (bytes(_tokenURIs[tokenId]).length != 0) {
952             delete _tokenURIs[tokenId];
953         }
954     }
955 }
956 pragma solidity ^0.8.0;
957 
958 
959 
960 
961 
962 pragma solidity ^0.8.14;
963 
964 
965 
966 contract FOR is ERC721URIStorage, Ownable {
967 
968     bool whitelist_mint = true;
969 
970     using ECDSA for bytes32;
971 
972     string private _baseURIextended = "ipfs://QmTTvdZZpMFvSCHnAo3FqFY5CccirYRrFC3GZ6drXhP4Bn/"; // This one is used on OpenSea to define the metadata IPFS address
973 
974     bool private mint_paused = false; // in case someone tries to rekt our mint we can pause at will
975 
976     mapping(uint8 => bytes32) private whiteListMapping;
977 
978     mapping(uint8 => uint16) public cansLeft; // our supply
979 
980     mapping(address => uint8) private alreadyOwnCan;  // used to set limits (no more than 2 cans, one of each)
981 
982     mapping(address => string) public cansHeOwn; // your supply
983 
984     mapping(uint8 => uint16) private canCountId;
985 
986     address[] private unknownWhitelist;
987 
988     constructor() ERC721("Rekt cans", "RKC") {
989 
990         cansLeft[0] = 1111;  // B0WB
991         cansLeft[1] = 1111;  // B0LT
992         cansLeft[2] = 1111;  // F1R3
993         cansLeft[3] = 1111;  // SCH00L
994         cansLeft[4] = 1111;  // SN3K
995         cansLeft[5] = 250;   // WabiSabi
996         cansLeft[6] = 100;   // Deladeso
997         cansLeft[7] = 250;   // Creepz
998         cansLeft[8] = 250;   // Grillz Gang
999         cansLeft[9] = 250;   // Mooncan
1000         cansLeft[10] = 50;   // Tiny Zoo
1001         cansLeft[11] = 150;  // Llamaverse
1002         cansLeft[12] = 50;   // ??
1003 
1004 
1005         whiteListMapping[0] = 0xa7b77bb86f03345c356b799d46aaf11289145d178881cf95e3ad5e4faf03934c;
1006         whiteListMapping[1] = 0xa7b77bb86f03345c356b799d46aaf11289145d178881cf95e3ad5e4faf03934c;
1007         whiteListMapping[2] = 0xa7b77bb86f03345c356b799d46aaf11289145d178881cf95e3ad5e4faf03934c;
1008         whiteListMapping[3] = 0xa7b77bb86f03345c356b799d46aaf11289145d178881cf95e3ad5e4faf03934c;
1009         whiteListMapping[4] = 0xa7b77bb86f03345c356b799d46aaf11289145d178881cf95e3ad5e4faf03934c;
1010         whiteListMapping[5] = 0x0fb49340ec9e083562809c17e635d16b1fd00d7d2fa3d02090b63c1f39fc7ca1;  // WabiSabi
1011         whiteListMapping[6] = 0x2d764d45115ce0415195b4296380ba7a8fb5fecb589f52d2d55ed49383bfd781;  // Deladeso
1012         whiteListMapping[7] = 0x01886e59a4db5e0801f9a2243ad9ac01ddbb814b46b70a89f708562506a729a2;  // Creepz
1013         whiteListMapping[8] = 0x4c156357cefbea51166ae7f0253d32c3d14d5849fbf75a297b2caa1fe86ad68e;  // Grillz Gang
1014         whiteListMapping[9] = 0xab2a6e961b690b8f4f4f4dc733818bd4bef8586a7b976e5042bf334f59a5e285;  // Mooncan
1015         whiteListMapping[10] = 0xf61184b70addc57bb4e61134c0c8e15f0da4960b947d636799150eb3339f2860; // Tiny Zoo
1016         whiteListMapping[11] = 0x3af526e2f746fba2e576ed127edbb6d14c39dc13482d928114e7d4015660c03a; // Llamaverse
1017         whiteListMapping[12] = 0x4f0a4dfc85667e30c6f8ad3c1698ece1314a4c26d2b1d1691cafe0c4de21dc2b; // ??
1018 
1019         // TODO TOMOROW
1020     }
1021 
1022     // Set the Metadata IPFS url (see docs.opensea.io)
1023     function setBaseURI(string memory baseURI_) external onlyOwner() {
1024         _baseURIextended = baseURI_;
1025     }
1026 
1027     // In case we need to pause the mint
1028     function switchMintState() external onlyOwner() {
1029         mint_paused = !mint_paused;
1030     }
1031 
1032     function switchWhitelistMintState() external onlyOwner() {
1033         whitelist_mint = !whitelist_mint;
1034     }
1035 
1036     // For OpenSEA
1037     function _baseURI() internal view virtual override returns (string memory) {
1038         return _baseURIextended;
1039     }
1040 
1041     function setWhitelistMerkleRoot(bytes32 newMerkleRoot_, uint8 _id) external onlyOwner {
1042         whiteListMapping[_id] = newMerkleRoot_;
1043     }
1044 
1045 
1046     function M_I_N_T(bytes32[] memory proof,uint256 amount, uint8 tokenID) public {
1047 
1048         if(tokenID > 4) {
1049             require(MerkleProof.verify(
1050                     proof,
1051                     whiteListMapping[tokenID],
1052                     keccak256(abi.encodePacked(msg.sender, amount))), "Not whitelisted, try again later if we don't sell-out");
1053         } else {
1054             if (whitelist_mint) {
1055                 require(MerkleProof.verify(
1056                         proof,
1057                         whiteListMapping[tokenID],
1058                         keccak256(abi.encodePacked(msg.sender, amount))), "Not whitelisted, try again later if we don't sell-out");
1059             }
1060         }
1061 
1062         require(!mint_paused, ">MINT PAUSED< If you're getting this message, shit went down (again). >MINT PAUSED<");
1063 
1064         require(alreadyOwnCan[msg.sender] < 3, "One community can and one collab can per wallet!!!");
1065 
1066         if(tokenID > 4) {
1067             require(alreadyOwnCan[msg.sender] != 2, "One collab can per wallet");
1068 
1069         } else {
1070             require(alreadyOwnCan[msg.sender] != 1, "One community can per wallet");
1071         }
1072         
1073         // In case some of the random cans sell-out, you can still get a can without spending another transaction gas fee
1074         // but now instead of random its from 0 to 4
1075         if(cansLeft[tokenID] == 0 && tokenID < 4) {
1076             for(uint8 i = 0; i < 4; i++) {
1077                 if(cansLeft[i] > 0) {
1078                     tokenID = i;
1079                     i = 4;
1080                 }
1081             }
1082         }
1083 
1084         // sold out require, sorry for the gas mate
1085         require(cansLeft[tokenID] > 0, "Sold out bother, don't brother ;)");
1086 
1087         if(alreadyOwnCan[msg.sender] == 0) {
1088             tokenID <= 4 ? alreadyOwnCan[msg.sender] = 1 : alreadyOwnCan[msg.sender] = 2;
1089         } else {
1090             alreadyOwnCan[msg.sender] = 3;
1091         }
1092 
1093         cansLeft[tokenID] -= 1;
1094 
1095         cansHeOwn[msg.sender] = string.concat(cansHeOwn[msg.sender], Strings.toString(tokenID));
1096 
1097         uint16 _tokenID;
1098 
1099         // Rekt code sorry guys, no time to do math -lrovaris
1100 
1101         if (tokenID <= 5) {
1102             _tokenID = (tokenID * 1111) + canCountId[tokenID];
1103         } else if (tokenID == 6) {
1104             _tokenID = 5805 + canCountId[tokenID];
1105         } else if (tokenID == 7) {
1106             _tokenID = 5905 + canCountId[tokenID];
1107         } else if (tokenID == 8) {
1108             _tokenID = 6155 + canCountId[tokenID];
1109         } else if (tokenID == 9) {
1110             _tokenID = 6405 + canCountId[tokenID];
1111         } else if (tokenID == 10) {
1112             _tokenID = 6655 + canCountId[tokenID];
1113         } else if (tokenID == 11) {
1114             _tokenID = 6705 + canCountId[tokenID];
1115         } else if (tokenID == 12) {
1116             _tokenID = 6855 + canCountId[tokenID];
1117         }
1118 
1119         canCountId[tokenID] += 1;
1120         _safeMint(msg.sender, _tokenID);
1121 
1122     }
1123 
1124 }
1125 
1126 //drop an 'F' in the chat for all those who got rekt in the first mint
1127 //Special thanks to all lab rats that helped us -FOR Team