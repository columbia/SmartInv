1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
5 //                                                                                                                                                              //
6 //                                                                                                                                                              //
7 //    :::::::::  :::::::::  :::::::::::  ::::::::  :::    ::: :::::::::::    :::::::::  :::        :::::::::::  ::::::::  :::    ::: :::::::::::  ::::::::      //
8 //    :+:    :+: :+:    :+:     :+:     :+:    :+: :+:    :+:     :+:        :+:    :+: :+:            :+:     :+:    :+: :+:    :+:     :+:     :+:    :+:     //
9 //    +:+    +:+ +:+    +:+     +:+     +:+        +:+    +:+     +:+        +:+    +:+ +:+            +:+     +:+        +:+    +:+     +:+     +:+            //
10 //    +#++:++#+  +#++:++#:      +#+     :#:        +#++:++#++     +#+        +#++:++#+  +#+            +#+     :#:        +#++:++#++     +#+     +#++:++#++     //
11 //    +#+    +#+ +#+    +#+     +#+     +#+   +#+# +#+    +#+     +#+        +#+    +#+ +#+            +#+     +#+   +#+# +#+    +#+     +#+            +#+     //
12 //    #+#    #+# #+#    #+#     #+#     #+#    #+# #+#    #+#     #+#        #+#    #+# #+#            #+#     #+#    #+# #+#    #+#     #+#     #+#    #+#     //
13 //    #########  ###    ### ###########  ########  ###    ###     ###        #########  ########## ###########  ########  ###    ###     ###      ########      //
14 //                                                                                                                                                              //
15 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddddddoc:::codddddddddddddddddo;.           'odddddddddddddddddddddddddddddddddddddddddddddddddddddd    //
16 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddddc,.     .':odddddddddddddl'              ;dddddddddddddddddddddddddddddddddddddddddddddddddddddd    //
17 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddd;.          .cdddddddddddo,       .'.     .:ddddddddddddddddddddddddddddddddddddddddddddddddddddd    //
18 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddc.            .,oddddddddd:.      ,ll;.     .cdddddddddddddddddddddddddddddddddddddddddddddddddddd    //
19 //    dddddddddddddddddddddddddddddddddddddddddddddddddddo,      .;,.     'ldddddddd,      .:ool;      'lddddddddddddddddddddddddddddddddddddddddddddddddddd    //
20 //    dddddddddddddddddddddddddddddddddddddddddddddddddddo.      'lo:.     .cddddddo'      .coool'      'ldddddddddddddddddddddddddddddddddddddddddddddddddd    //
21 //    dddddddddddddddddddddddddddddddddddddddddddddddddddo'      .loo:.     .cdddxdo'      .:ooooc.      .lddddddddddddddddddddddddddddddddddddddddddddddddd    //
22 //    dddddddddddddddddddddddddddddddddddddddddddddddddddd,      .:oooc.     .:ddddd,       ,ooooo:.      .:dddddddddddddddddddddddddddddddddddddddddddddddd    //
23 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddc.      'loooc'     .,odddc.      .cooooo:.       ,ldddddddddddddddddddddddddddddddddddddddddddddd    //
24 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddo,      .;ooool'      .,:oo,       'looool:.       .;ldddddddddddddddddddddddddddddddddddddddddddd    //
25 //    dddddddddddddddddddddddddddddddddddddddddddddddddddddl.      .:ooool,.       'cc.       'clc::;'          .,;clddddddddddddddddddddddddddddddddddddddd    //
26 //    dddddddddddddddddddddddddddddddddddddddddddddddddddddd:.      .:ooool:.        ..         ..                  ..,:oddddddddddddddddddddddddddddddddddd    //
27 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddddd:.      .;looooc,.                    .':clllc;'.          .';coddddddddddddddddddddddddddddddd    //
28 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddddddc.       'coooooc,.               'cxKNWWNNWWWN0d,.....       .;lddddddddddddddddddddddddddddd    //
29 //    dddddddddddddddddddddddddddddddddddddddddddddddddddddddddo,       .,clool:'.           .;xXWWWMWWWNNWWMWWXK0KK0Odc.     .,lddddddddddddddddddddddddddd    //
30 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd:.        .,'.          .'cdOXWMWWNNWWWNKKNWNXKKKKKKXWWKo.     .;oddddddddddddddddddddddddd    //
31 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddo;.                 .:d0XNXXXXWWWXXNWNXXXNWNK00000KXWMMWO,      'ldddddddddddddddddddddddd    //
32 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddo:.            .:d0NWNXKKKXXWWWWWWWXXNWWMMWNXK00KWWNNWWO'      .cddddddddddddddddddddddd    //
33 //    dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc'         ':oOKKKXNNNNNNWWWWWNNNWNNWWWNWWWWNNNNNK00XWNl       .cdddddddddddddddddddddd    //
34 //    dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddc'.        ;xKNNNNXNXKOxollcclox0XNWMMWNXXNNXKXNWWKOO0XWWo        .lddddddddddddddddddddd    //
35 //    dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddl,.        ;kNNXXXXOdc,.          .,oKWWWX0KXXXKKKXNXKKNWWNl         ,ddddddddddddddddddddd    //
36 //    dddddddddddddddddddddddddddddddddddddddddddddddddddddddddo:.        'd0XXXxoc'.                 .oKWWXKKKXKKXXNWWWXKKXk,        .cdddddddddddddddddddd    //
37 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddddddl'        .lO00kl'         .,:lddol:'     :0WWWNNNNNNWWWWX0O0XNXx'       ,oddddddddddddddddddd    //
38 //    dddddddddddddddddddddddddddddddddddddddddddddddddddddddc.        ;kK0kc.        .:ok00000000Oo.    :KMWWWMWNNXXXNX0OOKNWMK:      .cddddddddddddddddddd    //
39 //    dddddddddddddddddddddddddddddddddddddddddddddddddddddd;.       .l0KOl.        'lk0KK00K0000000d.    oNNKKNNKKKKXNNXKKNWWMMK;      ;ddddddddddddddddddd    //
40 //    ddddddddddddddddddddddddddddddddddddddddddddddddddddo;        ,ONXk,       .,oO000000000000000O:    '0WKO0XKKKXNWWWWNXKKNWWx.     ,ddddddddddddddddddd    //
41 //    dddddddddddddddddddddddddddddddddddddddddddddddddddo;       .cKMNx.      .okO000000000000000000o.   .dWWXXNNKXWWWNWWN0OOKNWK;     'odddddddddddddddddd    //
42 //    ddddddddddddddddddddddddddddddddddddddddddddddddddd;       .oXWNo.      ;k00000000000000000000Kd.    cNWWNXXNWMWNXXNWNK00KWX:     'odddddddddddddddddd    //
43 //    dddddddddolc:;;;;:cloddddddddddddddddddddddddddddd:.      .dKNNo.     .lOK00000000000K0000000KKd.    :XWNK00XWMWXK0XWMWNXNW0'     'odddddddddddddddddd    //
44 //    dddddddl,..         .':ldddddddddddddddddddddddddc.      ,kKXXo.     .o0K000000K00OO00000000000o.    :XMWXXXNWMNX000XWMMMMXc      ,ddddddddddddddddddd    //
45 //    dddddc'.               .'cddddddddddddddddddddddl.      ;0WWNx.     .d0K00KK000kc'..';oO000000O:     lNMMWWNNNWNK000KWMMMNo.     .:ddddddddddddddddddd    //
46 //    dddl,.      ...          .,odddddddddddddddddddo'      ;0NNNk'     .o000000KKOo.       ,x0K00Kx.    .dWWWWNK00XX000XNMMW0:       .lddddddddddddddddddd    //
47 //    ddl'      ,d0KKOxl,.       .cdddddddddddddddddd;      ;KN00O:     .l000000KK0c.         :OK0KO:     'OWWWNK0O0XXXXNWWN0l.        ,oddddddddddddddddddd    //
48 //    do'      cXWMMWWWWNk;       .:ddddddddddddddddc.     ;0WNKKd.     ;O00K00000d.          .xK00o.     oNWWWNK00XNXNWWNXx.         .cdddddddddddddddddddd    //
49 //    d;      cXWNWWWNXNWMNd.       ;odddddddddddddl'     'OWWWWK;     .d000K00KOk;           .dK0x'     'ONWWWWNNWNKO0NWWWO.         ,odddddddddddddddddddd    //
50 //    l.     ,0WNXXWWWNNWWMW0;       'ldddddddddddd;     .kNXXWWk.     :O0K00000xl'           .xKO;     .oXXNWNXXNWWKO0KNNNXc        .cddddddddddddddddddddd    //
51 //    :.     oWWXXXNWWNNWWMMMXl.      .:dddddddddd:.    .dNXKXNNl     .d0000000Kxc.           ;OO:      :KNNNNXXXNWWWNK00KNNd.       ;dddddddddddddddddddddd    //
52 //    ,     .kMWNNWWNKKKXWWWWWNk'       ,ldddddddl.    'dXNNXXNK:     ,kK000000Kxl'          .dOc.     'OWWWWNNNWWNXNNX00KNWd.      'odddddddddddddddddddddd    //
53 //    ,     'OWNNWMWNXXXNWWXXNWW0:       .,codddl.   'xXWWNNNNN0,     :O0K0000KKOk:         .lOc.     .xXNNK0kkk0KXXXNWNNNWNc      .lddddddddddddddddddddddd    //
54 //    ,     .ONXXWMMWWWWWWNXKXWWWNx'        .','.   ;KWX0kkxkOX0,     c0000000000Kk,       'ok:.     .oXXKkdooooodOXWWMMMWWO'     .cdddddddddddddddddddddddd    //
55 //    ;     .xWXXNWMWWWWMWNXNWWWWWWKc.             .ON0doooooodk;     :000K000000K0kl,...;lkx,      .lKNXkooooooood0WMMMMWXc     .:ddddddddddddddddddddddddd    //
56 //    c.     lNNNWMMWXXWWWWWWMMNXXWWNO:.           ,KKdooooooooxl.    ,kKK000000000000OkO0Ol.      .oXNNNOoooooooodONWWWMXc     .:dddddddddddddddddddddddddd    //
57 //    o,     'OWWNNWNXXNWNNWWMWNKXNWWWNO:.         .xKdooooooookO;    .l0000000000000000Oo,       .dNWWWWXkooooood0NWWNNO;     .:ddddddddddddddddddddddddddd    //
58 //    dc.     cXWNXNWNNNNXXNNNNNNXXNWMMMW0l'       .xN0dooooookXWO'    .d0000000000000kl,        'xNWMMMWWNKOkkO0XWMWXk:.     .:dddddddddddddddddddddddddddd    //
59 //    dd:.    .oNWWWMMMWNXNNK0KXNWWWWWWMMMWXkocccld0NMWX0OOO0KNWWWO'    .ck00KK0KK0Od:.        .c0WWWMWWWWWWWWNNWWWOc.        ;ddddddddddddddddddddddddddddd    //
60 //    ddd;     .xWMMWNNWWWWNK0KXWWNNNXXWWWNNNWWWWWWWWWWWMWWWWWNNWMW0;     .;loolc:;.         .:OWMMNOoldOXNWWWNXNWO'         ,oddddddddddddddddddddddddddddd    //
61 //    dddo,     .xWWNXXNWMMWNNNWMWNNXKXNWWNXXNWWNNNWWNNNWWWWWNNNNNWWKo.                    'lONWNWXo.   .c0NWWNNNXc         .ldddddddddddddddddddddddddddddd    //
62 //    ddddo;.    .xNWNNNWMMWNXXWWMWWXXXNWWWNNWWNXXNWWNXNWWWNNNNXKXXKXX0o,.             .;oOXNNNNN0c      .xNWNXNWO.         ;ddddddddddddddddddddddddddddddd    //
63 //    dddddd:.    .lXWWWWMWNXKKXNWWNKKXNNXNWWWNNNNNWWNNNWWWWWWWNXXXNNNNWXOdlc:::::ccoxOXNWNNNNNXk,       'kNWWNNWo          ;ddddddddddddddddddddddddddddddd    //
64 //    dddddddl,     ,xNMMMWWNNXXXNWNXKKXXKKNNXKKXNXXWNXXXXXWWWWWWWNNWWWWNKKXWWWWWWWNNNNWWNXNWNOc.       .xXNWWWWNl          .cdddddddddddddddddddddddddddddd    //
65 //    ddddddddo:.     ;xXWMMMWWNNWWWNNXXNNNWXKKXNX0KXNXXXNNWWNNWWWWNNWMMMWNWNNWWWWWNXXXNWNXKx:.        ,kWWNXKXNWd.          .'coddddddddddddddddddddddddddd    //
66 //    ddddddddddl'      'lOXWWWWWWWNWWWWWMMWXXNNXK0KNWNNWWWWNNNWWWNk::lx0XNNNNNNWWWWNXXK0d:.         'oKWMNK0XNWNK:             .,:loddddddddddddddddddddddd    //
67 //    ddddddddddddc.       .:okKWMMWWMMMWWWXKKNNNXXNWMWWMMMWNNWWNNXd.   ..;codxxxxdol:;..         .;xKXXNWNKXNWWNNKc.               ...''''....',;codddddddd    //
68 //    dddddddddddddo:'         .;dKWWWWWWMN0OO0KNWWNXNWMMMWXXXXNWWWW0o'.                       .:d0NNNNXNWNNWWWWWWWNk;.                            ..;lddddd    //
69 //    ddddddddddddddddl;.         .oXWWWWWNKOOO0KNNXKXXWWWNXKKXXWWMWWWNOo:'.             ..,:oOXWWWNNWWNXK0XWMMMWWWWWNOc.                             .:oddd    //
70 //    ddddddddddddddddddoc;..       lNWWWWWX0OO0XNWXXXXNWWNKKKXXNWWWWWMWWNXKOkxdoooodddxO0XNWMMMWWWWWWNK0Ok0XWWWNXXXNWMWKxc,.                           ,odd    //
71 //    dddddddddddddddddddddc.       ;KMWWNNWNK0XWWWNNNNWWWWNXXKXWWWNNWWWWNNWWMMMWWWWWWWWWMMMMXdc:cdKWMWNX0OOKWWWXXKKXNWWWWWNKOdl:,.....   ....           ,od    //
72 //    dddddddddddddddddol:'.       .kWMWNXXXNNNWMWMWWWWWNNWWWWNWMWWXNNWMWNNWMMMMWWNNNWWWNNWWNl     .dNMWWXK0KNWMWNXKKXNWWWWWWMMMWNXXK00OkO0KKKOo'        .:d    //
73 //    dddddddddddddoc;'.          ;OWMMWNNXNWMWWWWWWWWWNNWWXKOO0KNWWWWMMMMMWNWWMMWWWWWMWNNNWNc       :0WWWNNNWWNNWWWWWWWMWWWNNNNNWWMWWWNNNNNWWWW0,        'o    //
74 //    ddddddddddo:,.           'ckXWMMWWWWWWWWWNWWWNNWWNOo;..  ..,lONWMMWWNXKKNWNNXXXWWWWWNWWK:       .:xXWMWWNXXNWWWNXNWWWNK0000KNWWXK0KNNNNNNWNc        .l    //
75 //    dddddddoc,.          .;oOXWWWWWWWNNWNXNWWWWWNNWNk;.          .;xXWWXKK0KNNXKKKXNNNWMWNNNXx'        .:d0XWWWWMWNXKXXNWNK000OOXNK0OOOKNWWNNWO'        'o    //
76 //    dddddo:.         .'cxKNWWWNXXNWNXKKXK0KNWWWWWNO;                ,kNWNXXNWNXKKKKXXNWMWNXNWWKo'         .':dOXWWNXXXKKXWN0OOkkKX0kOOO0NWMMWO,        .cd    //
77 //    dddo:.        .:d0NWWNNNWWXXXWWNXKKKKKNWWWWWXo.      ....        .lXWWWWMWNXXKKXNNWWWWNNWWWNXkc.           .:dOXWWNNWWWNX00KWN0O0XXNWMWKo.         ;dd    //
78 //    ddl'       .ckXWMMWNXXNXXNNWWWWWNXKXNWWWNWWO,      'coddoc'        ;OWWWWMWNNXXNNNXNWWWNNNWWWWWXkl,.          .,lONMMWWWWWWWMWNXNWMWXkc.          ,odd    //
79 //    d:.      'oKNXNWMMWXXXXKKKXWNXXNWNNNWWWNNKl.     .;oddddddd:.       'kWMWWWWWWWNXKXNWMWNXXWWWWWWWWN0dc,.         .,oKWWWWWWMMMMWN0xc'           .;oddd    //
80 //    ;.     .lKWXK0XWWWNKKKK00KNWXKKKNWNXXWWNk,      .:ddddddddddl.       .dNWWWMMWWNNWWWMMWWWNXXWWWWWWWNNNN0o;.         .o0000Okxoc;'.             .:ddddd    //
81 //    .     .kNWWNKKNWNKXXXXKKXNWWNXXNWNXNWN0c.      .:ddddddddddddl'       .lXWMMMWNXXNNNWWWWNX00XWWWNXNNWWWWWN0l.         ....                   .:odddddd    //
82 //         .kWWWWNNWWWX0KWWNNWNXKXNNWWMWWWKl.       .:ddddddddddddddl'        ;0WMMWNNXXXXNWWXKK00KNWX000KNWWWNXXXk.                           ..;cddddddddd    //
83 //         cNMWNX0KXWMWNWWWXXNNXKXNWWWMW0l.        .cddddddddddddddddl'        .d0XWWWNNNNNWWNKK00KNWNKKXNWMWX00KXNd.                     ..';:ldddddddddddd    //
84 //         ;KMWNXKKKNWWXXWNXXXWWWWWMWXk:.        .;oddddddddddddddddddo,         .,xNMWWWWWMWWWNXXNWWWWWNXNWWK0KXNWx.             ....,;:clddddddddddddddddd    //
85 //          ,xKNWNNWWMWNNWWWWWMMWNKkc'          'cdddddddddddddddddddddo;.          ,dKWWMMMWWWWWMWNNWWNKKXWWNNWWXx'         ,cccloodddddddddddddddddddddddd    //
86 //    ,       .,coxkO0KKKKK0Okdoc,.           'cdddddddddddddddddddddddddc'           .;lx0XNWWMMMWWWWWWWWWMWNXOo,         .;odddddddddddddddddddddddddddddd    //
87 //    o:.            .......               .,cddddddddddddddddddddddddddddo:.             ..,:loxkO0000Okxdlc,.           'cdddddddddddddddddddddddddddddddd    //
88 //    ddoc,.                            .':oddddddddddddddddddddddddddddddddoc,.                   ....               ..;cdddddddddddddddddddddddddddddddddd    //
89 //    dddddoc;'.                     .,:oddddddddddddddddddddddddddddddddddddddoc;,.                                .,codddddddddddddddddddddddddddddddddddd    //
90 //                                                                                                                                                              //
91 //                                                                                                                                                              //
92 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
93 
94 /**
95   * @dev Library for reading and writing primitive types to specific storage slots.
96   *
97   * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
98   * This library helps with reading and writing to such slots without the need for inline assembly.
99   *
100   * The functions in this library return Slot structs that contain a "value" member that can be used to read or write.
101   *
102   * Example usage to set ERC1967 implementation slot:
103   * 
104   * contract ERC1967 {
105   *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
106   *
107   *     function _getImplementation() internal view returns (address) {
108   *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
109   *     }
110   *
111   *     function _setImplementation(address newImplementation) internal {
112   *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
113   *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
114   *     }
115   * }
116   *
117   *
118   * _Available since v4.1 for address, bool, bytes32, and uint256._
119   */
120 library StorageSlot {
121     struct AddressSlot {
122         address value;
123     }
124 
125     struct BooleanSlot {
126         bool value;
127     }
128 
129     struct Bytes32Slot {
130         bytes32 value;
131     }
132 
133     struct Uint256Slot {
134         uint256 value;
135     }
136 
137     /**
138       * @dev Returns an AddressSlot with member value located at slot.
139       */
140     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
141         assembly {
142             r.slot := slot
143         }
144     }
145 
146     /**
147       * @dev Returns an BooleanSlot with member value located at slot.
148       */
149     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
150         assembly {
151             r.slot := slot
152         }
153     }
154 
155     /**
156       * @dev Returns an Bytes32Slot with member value located at slot.
157       */
158     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
159         assembly {
160             r.slot := slot
161         }
162     }
163 
164     /**
165       * @dev Returns an Uint256Slot with member value located at slot.
166       */
167     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
168         assembly {
169             r.slot := slot
170         }
171     }
172 }
173 
174 /**
175   * @dev Collection of functions related to the address type
176   */
177 library Address {
178     /**
179       * @dev Returns true if account is a contract.
180       *
181       * [IMPORTANT]
182       * ====
183       * It is unsafe to assume that an address for which this function returns
184       * false is an externally-owned account (EOA) and not a contract.
185       *
186       * Among others, {isContract} will return false for the following
187       * types of addresses:
188       *
189       *  - an externally-owned account
190       *  - a contract in construction
191       *  - an address where a contract will be created
192       *  - an address where a contract lived, but was destroyed
193       * ====
194       */
195     function isContract(address account) internal view returns (bool) {
196         // This method relies on extcodesize, which returns 0 for contracts in
197         // construction, since the code is only stored at the end of the
198         // constructor execution.
199 
200         uint256 size;
201         assembly {
202             size := extcodesize(account)
203         }
204         return size > 0;
205     }
206 
207     /**
208       * @dev Replacement for Solidity's {transfer}: sends "amount" wei to
209       * "recipient", forwarding all available gas and reverting on errors.
210       *
211       * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
212       * of certain opcodes, possibly making contracts go over the 2300 gas limit
213       * imposed by {transfer}, making them unable to receive funds via
214       * {transfer}. {sendValue} removes this limitation.
215       *
216       * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
217       *
218       * IMPORTANT: because control is transferred to "recipient", care must be
219       * taken to not create reentrancy vulnerabilities. Consider using
220       * {ReentrancyGuard} or the
221       * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
222       */
223     function sendValue(address payable recipient, uint256 amount) internal {
224         require(address(this).balance >= amount, "Address: insufficient balance");
225 
226         (bool success, ) = recipient.call{value: amount}("");
227         require(success, "Address: unable to send value, recipient may have reverted");
228     }
229 
230     /**
231       * @dev Performs a Solidity function call using a low level "call". A
232       * plain "call" is an unsafe replacement for a function call: use this
233       * function instead.
234       *
235       * If "target" reverts with a revert reason, it is bubbled up by this
236       * function (like regular Solidity function calls).
237       *
238       * Returns the raw returned data. To convert to the expected return value,
239       * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
240       *
241       * Requirements:
242       *
243       * - "target" must be a contract.
244       * - calling "target" with "data" must not revert.
245       *
246       * _Available since v3.1._
247       */
248     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
249         return functionCall(target, data, "Address: low-level call failed");
250     }
251 
252     /**
253       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
254       * "errorMessage" as a fallback revert reason when "target" reverts.
255       *
256       * _Available since v3.1._
257       */
258     function functionCall(
259         address target,
260         bytes memory data,
261         string memory errorMessage
262     ) internal returns (bytes memory) {
263         return functionCallWithValue(target, data, 0, errorMessage);
264     }
265 
266     /**
267       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
268       * but also transferring "value" wei to "target".
269       *
270       * Requirements:
271       *
272       * - the calling contract must have an ETH balance of at least "value".
273       * - the called Solidity function must be {payable}.
274       *
275       * _Available since v3.1._
276       */
277     function functionCallWithValue(
278         address target,
279         bytes memory data,
280         uint256 value
281     ) internal returns (bytes memory) {
282         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
283     }
284 
285     /**
286       * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
287       * with "errorMessage" as a fallback revert reason when "target" reverts.
288       *
289       * _Available since v3.1._
290       */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value,
295         string memory errorMessage
296     ) internal returns (bytes memory) {
297         require(address(this).balance >= value, "Address: insufficient balance for call");
298         require(isContract(target), "Address: call to non-contract");
299 
300         (bool success, bytes memory returndata) = target.call{value: value}(data);
301         return verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
306       * but performing a static call.
307       *
308       * _Available since v3.3._
309       */
310     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
311         return functionStaticCall(target, data, "Address: low-level static call failed");
312     }
313 
314     /**
315       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
316       * but performing a static call.
317       *
318       * _Available since v3.3._
319       */
320     function functionStaticCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal view returns (bytes memory) {
325         require(isContract(target), "Address: static call to non-contract");
326 
327         (bool success, bytes memory returndata) = target.staticcall(data);
328         return verifyCallResult(success, returndata, errorMessage);
329     }
330 
331     /**
332       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
333       * but performing a delegate call.
334       *
335       * _Available since v3.4._
336       */
337     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
338         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
339     }
340 
341     /**
342       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
343       * but performing a delegate call.
344       *
345       * _Available since v3.4._
346       */
347     function functionDelegateCall(
348         address target,
349         bytes memory data,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(isContract(target), "Address: delegate call to non-contract");
353 
354         (bool success, bytes memory returndata) = target.delegatecall(data);
355         return verifyCallResult(success, returndata, errorMessage);
356     }
357 
358     /**
359       * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
360       * revert reason using the provided one.
361       *
362       * _Available since v4.3._
363       */
364     function verifyCallResult(
365         bool success,
366         bytes memory returndata,
367         string memory errorMessage
368     ) internal pure returns (bytes memory) {
369         if (success) {
370             return returndata;
371         } else {
372             // Look for revert reason and bubble it up if present
373             if (returndata.length > 0) {
374                 // The easiest way to bubble the revert reason is using memory via assembly
375 
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 /**
388   * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
389   * instruction {delegatecall}. We refer to the second contract as the _implementation_ behind the proxy, and it has to
390   * be specified by overriding the virtual {_implementation} function.
391   *
392   * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
393   * different contract through the {_delegate} function.
394   *
395   * The success and return data of the delegated call will be returned back to the caller of the proxy.
396   */
397 abstract contract Proxy {
398     /**
399       * @dev Delegates the current call to {implementation}.
400       *
401       * This function does not return to its internall call site, it will return directly to the external caller.
402       */
403     function _delegate(address implementation) internal virtual {
404         assembly {
405             // Copy msg.data. We take full control of memory in this inline assembly
406             // block because it will not return to Solidity code. We overwrite the
407             // Solidity scratch pad at memory position 0.
408             calldatacopy(0, 0, calldatasize())
409 
410             // Call the implementation.
411             // out and outsize are 0 because we don't know the size yet.
412             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
413 
414             // Copy the returned data.
415             returndatacopy(0, 0, returndatasize())
416 
417             switch result
418             // delegatecall returns 0 on error.
419             case 0 {
420                 revert(0, returndatasize())
421             }
422             default {
423                 return(0, returndatasize())
424             }
425         }
426     }
427 
428     /**
429       * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
430       * and {_fallback} should delegate.
431       */
432     function _implementation() internal view virtual returns (address);
433 
434     /**
435       * @dev Delegates the current call to the address returned by _implementation().
436       *
437       * This function does not return to its internall call site, it will return directly to the external caller.
438       */
439     function _fallback() internal virtual {
440         _beforeFallback();
441         _delegate(_implementation());
442     }
443 
444     /**
445       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if no other
446       * function in the contract matches the call data.
447       */
448     fallback() external payable virtual {
449         _fallback();
450     }
451 
452     /**
453       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if call data
454       * is empty.
455       */
456     receive() external payable virtual {
457         _fallback();
458     }
459 
460     /**
461       * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual {_fallback}
462       * call, or as part of the Solidity {fallback} or {receive} functions.
463       *
464       * If overriden should call super._beforeFallback().
465       */
466     function _beforeFallback() internal virtual {}
467 }
468 
469 contract BrightBlights is Proxy {
470     /**
471       * @dev Emitted when the implementation is upgraded.
472       */
473     event Upgraded(address indexed implementation);
474     
475     constructor() {
476 
477         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
478         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = 0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d;
479         emit Upgraded(0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d);
480         Address.functionDelegateCall(
481             0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d,
482             abi.encodeWithSignature(
483                 "init(bool[2],address[4],uint256[10],string[4],bytes[2])",
484                 [false,true],
485                 [0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52],
486                 [500,750,0,0,0,10,1,5555,0,1],
487                 ["Bright Blights","BRBL","ipfs://","Qmd3BZwc4n3mrCR4N1QFQbxosLPnrM27XMeZEJU6J88jKZ"],
488                 [
489                     hex"d2b93920587903576f967c4f2260362dac290f874e5cea446829fa3a2b86fd3c2dd1601e50aed7532fdf2386890a4a12d104e65846fd88e52c57898e5189f1931c",
490                     hex""
491                 ]
492             )
493         );
494     
495     }
496         
497     /**
498       * @dev Storage slot with the address of the current implementation.
499       * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
500       * validated in the constructor.
501       */
502     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
503 
504     /**
505       * @dev Returns the current implementation address.
506       */
507     function implementation() public view returns (address) {
508         return _implementation();
509     }
510 
511     function _implementation() internal override view returns (address) {
512         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
513     }
514 
515     /**
516       * @dev Perform implementation upgrade
517       *
518       * Emits an {Upgraded} event.
519       */
520     function upgradeTo(
521         address newImplementation, 
522         bytes memory data,
523         bool forceCall,
524         uint8 v,
525         bytes32 r,
526         bytes32 s
527     ) external {
528         require(msg.sender == 0xa17ccaB8aD881A05427E7118771987D09C04A833);
529         bytes32 base = keccak256(abi.encode(address(this), newImplementation));
530         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", base));
531         
532         require(ecrecover(hash, v, r, s) == 0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52);
533 
534         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
535         if (data.length > 0 || forceCall) {
536           Address.functionDelegateCall(newImplementation, data);
537         }
538         emit Upgraded(newImplementation);
539     }
540 }
