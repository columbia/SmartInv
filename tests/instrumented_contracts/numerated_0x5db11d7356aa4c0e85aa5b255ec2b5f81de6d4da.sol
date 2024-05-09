1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
5 //                                                                                                                                                              //
6 //                                                                                                                                                              //
7 //    dkkkxkkxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxxxxxxxxxkkkkkkkxkxxkx    //
8 //    xOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
9 //    xOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
10 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkkOkkOOkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
11 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOOkkkkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
12 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkkkkdldkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
13 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkd;. .:oxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
14 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkko,.....  .lxkOkkOkkOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
15 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOko,. .',,'..  ,okkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
16 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkxl'. .',,,,,,,'. .:xkkkOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
17 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxc.  .',,',,,,,',,.. .lkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
18 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOxc. ..',,,,,,,,,,,,,,'.  ,okkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
19 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkd:. ..,,,,,,,,,,,,,,,,,,,'. .:xkkkkkkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
20 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkkko;. ..,,,,,,,,,,,,,,,,,,,,,,,.. .lkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
21 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkd,. ..,,,,,,,,,,,,,,,,,,,,,,,,,,,.  ;dkOkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
22 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkkkkkkkkkkx:. .',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'. .:xkkkkkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
23 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkko' ..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.. .lkkkkkOkkkOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
24 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkkOkkko. .',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'. .,dkkkkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
25 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOOkOkl. .',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'. .:xkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
26 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkkOkOx:. .,,',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,.. 'lkOkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
27 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkkd, ..,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'. .,dkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
28 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkko. .',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'. .:xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
29 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkc. .',,,,,,,,,,,,,,,,,,,,,,,,,,'''''',,,,,,,,,,,,,,,,,,,.. 'lkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
30 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx;  .,,,,,,,,,''''.................................',,,,,,'.. .;oxkOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
31 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkko' .',,'.........      ..............................'.....      ..,:dkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
32 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOOkc.  ..''............'''',,,,,,,,,,,,,,,,,,,,,,,,,,,,','.............. .:xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
33 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxl,..   ...'''',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'.  ckkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
34 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkd;.  ...'''',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,',,'. ,kkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
35 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx:. ..',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,''''''',,,,',,,,,,,,,,,,,,. .ckOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
36 //    xkkkkkkkkkkkkkkkkkkkkkkkkkOkkk:  .',,,,,,'',,,,,,,,,,,,,''''..................... ...   .............''''.. .ckkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
37 //    xkkkkkkkkkkkkkkkkkkkkkkOkkOkOd. .,,,,,,,,,,,,,'''....... ......'',;;:ccclllloooooodddddooooolccc;.       .':dkxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
38 //    xkkkkkkkkkkkkkkkkkkkkkkkkkOkkk;  ..............  ...,;:cldkOO0KKXXXXNNNNNXXNNNNNNX0Oxolcc::cccodx, .,;,. .,'....,;lxkkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
39 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkko;.                  ...',;cokKXXXXXXXXXXXXXXXXXNNKx;..               .,cc;. .;oool:...:xOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
40 //    xkkkkkkkkkkkkkkkkkkkkkkkkkxl'..;col. .,. ,,               .lKNXXXXXXXXXXXXXXXNXKxc;,''.       .,:;. ':::, .oXNNNX0o. 'okOkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
41 //    xkkkkkkkkkkkkkkkkkkkkkkOko' 'o0XNNd. ,, .x0docc,.   .':clox0XXXXXXXXXXXXXXXNNXXXNXXXXx,..,.  .:0N0, .::::. 'ONXXXXN0:..lkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
42 //    xkkkkkkkkkkkkkkkkkkkkkkOo. ;0NXXXK: .;. 'ONXN0l'..   .:OXXXXXXXXXXXXXXXXXXXXXXXXXXXNO' .oO;    :KX: .;::c;. oXXXXXXXK: 'xOkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
43 //    xkkkkkkkkkkkkkkkkkkkkkOx, ,0NXXXN0; .:. ,0NNK: .lx'    ,0NXXXXXXXXXXXXXXXXXXXXXXXXXNx.   .cd;  ,ONo .;::::. ;KXXXXXXNo .oOkkkOkkkkkkkkkkkkkkkkkkkkkkOx    //
44 //    xkkkkkkkkkkkkkkkkkkkkkOo. lXXXXXX0, .:' 'ONNO'  .,co;. .kNXXXXXXXXXXXXXXXXXXXXXXXXXX0:   .lOl..oXNx. ,c:::' 'ONXXXXXK: 'dOkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
45 //    xkkkkkkkkkkkkkkkkkkkkkOd. cXXXXXN0; .:, .xNXKl.  .o0o..oKXNXXNXXXXXXXXXXXXXXXXXXNXXXXKd;....,:kXXNO' '::::, .kNXXXXKl..lkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
46 //    xkkkkkkkkkkkkkkkkkkkkkOk: .kNXXXNK: .:;. lXXNKx:'..',ckXXXNXXXXXXXXXXXXXXXXXXXXNXXXXXXNXKOk0KXNXXN0, .:::c, .kNXXKx;..lkOkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
47 //    xkkkkkkkkkkkkkkkkkkkkkkOx;..o0XXXXo .;:. 'OXXXXXK0O0KXXXXXXXXXXXXXXXXXXXXXXXXXXNNXXXXXXXXXXXXXXXXXK: .::::' .kKkl,..:dkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
48 //    xkkkkkkkkkkkkkkkkkkkkkkkkxl'..cdkKk' 'c,  cKXXXXXXXXXXXXXXXXXXXXNXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXK: .;:::. .''..,cdkOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
49 //    xkkkkkkkkkkkkkkkkkkkkkkkkkOkl;...''. .;:. .dXXXXXXXXXXXXXXXXXXXXXXNNXXXXXXXXNNNXXXXXXXXXXXXXXXXXXNO, .:::;. .;coxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
50 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkdlc:,. 'c;. ,ONXXXXXXXXXXXXXXXXNNKkdl:,'''',;:ldk0XXNXXXXXXXXXXXXX0;..;c:c, .lOOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
51 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOk: .,:'  ;0XXXXNNXNNXNNXXKko:'. ........... ..,:lodxkOO00KXXKd. .;::::. 'xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
52 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkkOx, .;:'  ,OXXklllllolc:,..  .',;:c:::c::::;,'............ox;..':c:::' .lOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
53 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkkkkOd' .::'. .dKo.   .......',;::::c::,,',;;::::c::::;,'.  .....;:c:::,. :kkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
54 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOko. .;:,.  ,dd;. .';:cc:::c:::;,..      .,;:cc::c:'.    .';:c::::;. ,xOkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
55 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkd' .;::,.  ,c:'.  .,:::c::,.. .:oxxoc:. ...',,'.    .,;::::c::,. ,xOkkOkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
56 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx;  ':::;..  ..    .'......;d0XOccONX0xl:,..     .;:c:::::::'  ;xOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
57 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkc. .;:cc:;'....     .:lx0XXXXl  :0KXXNXO:.  .';:::::::::;. .cxkkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
58 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkd;...,:::c::::,'.. .;lx0XXXNk;.oKXX0d;. ..,;:c:::::cc;'. ,okOkkkkOkkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
59 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkOkd;. .':::::::::;,... .';coxxddol;.  .';::::c::::::'...ckkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
60 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkd,.  ..,:::::::c::;,'... ...   ..';:::::::::::;..  .;oxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
61 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxc'..;odc'...,;:::::::::cc:;;,,,;;::cc:::c::::,'. .:ol:'..;lxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
62 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkko;.  .lKWWWNOl,...,;:::c::::c::::cc:::::::::;'....:xKWWWW0:   .:dkkOOkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
63 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkkOkkOkd;. ...  'l0NWWWNOo,...,;:c:::c::::cc::::::,....:okXWWWWWNk;  ... .,okkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
64 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkd;.  ...'..  .;xXWWWWXOo,...;:::c::::cc::c:'..'ckXWWWWWWWNk;. ...''.. .;okkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
65 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxc..;,  .'''....  'lONWWWWNOc...,::::::::c:'..,dXWWWWWWWWNO:. ...''..'... .:xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
66 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkd,.'xNK;  .'...'...  .;xXWWWWNKd,..';:::::;. .dXWWWWWWWWW0c. ...''.''..'..   .lkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
67 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl..:0WWWk. ..'..''.'...  .lONWWWWXk:...,;,.. :0WWWWWWWXOd:. ...''.'''....  'dl..:kOkkOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
68 //    xkkkkkkkkkkkkkkkkkkkkkkkOOkkkkOx:..dNWWWWNc  .'.'''..'''..  .;xKWWWWN0o'.   .oNWWWN0xo:'.   ..''''..''...  :KWNk' ,xOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
69 //    xkkkkkkkkkkkkkkkkkkkkkkkOkkkkOx, 'kNWWWWWWO. ...'..''''''..    'cx00XNWXd'..c0KOdc,. .....  .'..'''..'.. .dXWWWW0;.'okOkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
70 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkkkd, ,0WWWWWWWWWl  .....''.'.'.   ..   ..',:;'....... ....'',,.  .'''..'''.. .xWWWWWWWXc..okkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
71 //    xkkkkkkkkkkkkkkkkkkkkkkkkkkOd, ;0WWWWWWWWWWk. ..'''''''''..  ','''....  ..'.'.. .',,,,,,,.  .'''..''.. .kWWWWWWWWWXl..okkkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
72 //    xkkkkkkkkkkkkkkkkkkkkkkkOkkx, ;KWWWWWWWWWWWK, ..'''''''..'.  .,,,,,,,,. .',,,,.  .,,,,,,,.  .'''..'.. .xWWWWWWWWWWMXc..okkkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
73 //    xkkkkkkkkkkkkkkkkkkkkkkkkOx; ,0WWWWWWWWWWWWNc  .'''''''''..  .',,,,,,'.  .,,,,.  .'',',,,.  .'''.''.  cNWWWWWWWWWWWWX: 'dOkkkkkkkkkkkkkkkkkkkkkkkkkkOx    //
74 //    xkkkkkkkkkkkkkkkkkkkkkkkkk: .kWWWWWWWWWNOdKWo  .''.'..''''.  .''.....     ....      ......  ..'..'.. .k0okNWWWWWWWWWW0, ;kkkkkOkkkkkkkkkkkkkkkkkkkkkOx    //
75 //    xkkkkkkkkkkkkkkkkkkkkkkkko..oNWWWWWWWWWx..kWd. .'.....''.'..       ....   .'.    ......     ........ '0k..kWWWWWWWWWWWk..ckOkkkkkkkkkkkkkkkkkkkkkkkkOx    //
76 //    xkkkkkkkkkkkkkkkkkkkkkkOx, ;XWWWWWWWWWK, lNWx. .'.....'''''.........''..      .....''...........''.. ,KNl :XWWWWWWWWWWNl .dOkkkkOkkkkkkkkkkkkkkkkkkkOx    //
77 //    xkkkkkkkkkkkkkkkkkkkkkkkl..xWWWWWWWWWWd.'0WWx. .'.....'''''''''..''''...  ....'.......''.''.''..''.. ,KMk..OWWWWWWWWWWWK, ;kOkkkOkkkkkkkkkkkkkkkkkkkOx    //
78 //    xOkkkkOkkkkkkkkkkkkkkkOx, :XWWWWWWWWWX; lNWWd  .''....''''.''...''..'..  .'''..  ..'..''.''..'.'''.. '0M0'.xWWWWWWWWWWWWd..okkkkkkkkkkkkkkkkkkkkkOkkOx    //
79 //    xOkkkkOkkkkkkkkkkkkkkkOo. dWWWWWWWWWWO'.kWWWl  .'''...'''''''''''...''.   .''.   ..'..''.''''''''.'. .xW0'.xWWWWWWWWWWWWK, ;kkkkkkkkkkkkkkkkkkkkkkkkOx    //
80 //    xkkkkkOkkkkkkkkkkOOkkOOc .OWWWWWWWWWWx.'0WWX:  .'''...'''''''''.''..''..  .'''....'''''..''''''''.'.  lN0'.xWWWWWWWWWWWWWl 'xOkkOkkkkkkkkkkkkkkkkOOkOx    //
81 //    odddddddddddddddddddddd; .x0000000000l.'x00O,  .........................  ..........................  ,Ox'.oK000000000000l..cddddddddddddddddddddddddo    //
82 //                                                                                                                                                              //
83 //                                                                                                                                                              //
84 //                                                                                                                                                              //
85 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
86 
87 /**
88   * @dev Library for reading and writing primitive types to specific storage slots.
89   *
90   * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
91   * This library helps with reading and writing to such slots without the need for inline assembly.
92   *
93   * The functions in this library return Slot structs that contain a "value" member that can be used to read or write.
94   *
95   * Example usage to set ERC1967 implementation slot:
96   * 
97   * contract ERC1967 {
98   *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
99   *
100   *     function _getImplementation() internal view returns (address) {
101   *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
102   *     }
103   *
104   *     function _setImplementation(address newImplementation) internal {
105   *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
106   *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
107   *     }
108   * }
109   *
110   *
111   * _Available since v4.1 for address, bool, bytes32, and uint256._
112   */
113 library StorageSlot {
114     struct AddressSlot {
115         address value;
116     }
117 
118     struct BooleanSlot {
119         bool value;
120     }
121 
122     struct Bytes32Slot {
123         bytes32 value;
124     }
125 
126     struct Uint256Slot {
127         uint256 value;
128     }
129 
130     /**
131       * @dev Returns an AddressSlot with member value located at slot.
132       */
133     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
134         assembly {
135             r.slot := slot
136         }
137     }
138 
139     /**
140       * @dev Returns an BooleanSlot with member value located at slot.
141       */
142     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
143         assembly {
144             r.slot := slot
145         }
146     }
147 
148     /**
149       * @dev Returns an Bytes32Slot with member value located at slot.
150       */
151     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
152         assembly {
153             r.slot := slot
154         }
155     }
156 
157     /**
158       * @dev Returns an Uint256Slot with member value located at slot.
159       */
160     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
161         assembly {
162             r.slot := slot
163         }
164     }
165 }
166 
167 /**
168   * @dev Collection of functions related to the address type
169   */
170 library Address {
171     /**
172       * @dev Returns true if account is a contract.
173       *
174       * [IMPORTANT]
175       * ====
176       * It is unsafe to assume that an address for which this function returns
177       * false is an externally-owned account (EOA) and not a contract.
178       *
179       * Among others, {isContract} will return false for the following
180       * types of addresses:
181       *
182       *  - an externally-owned account
183       *  - a contract in construction
184       *  - an address where a contract will be created
185       *  - an address where a contract lived, but was destroyed
186       * ====
187       */
188     function isContract(address account) internal view returns (bool) {
189         // This method relies on extcodesize, which returns 0 for contracts in
190         // construction, since the code is only stored at the end of the
191         // constructor execution.
192 
193         uint256 size;
194         assembly {
195             size := extcodesize(account)
196         }
197         return size > 0;
198     }
199 
200     /**
201       * @dev Replacement for Solidity's {transfer}: sends "amount" wei to
202       * "recipient", forwarding all available gas and reverting on errors.
203       *
204       * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
205       * of certain opcodes, possibly making contracts go over the 2300 gas limit
206       * imposed by {transfer}, making them unable to receive funds via
207       * {transfer}. {sendValue} removes this limitation.
208       *
209       * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
210       *
211       * IMPORTANT: because control is transferred to "recipient", care must be
212       * taken to not create reentrancy vulnerabilities. Consider using
213       * {ReentrancyGuard} or the
214       * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
215       */
216     function sendValue(address payable recipient, uint256 amount) internal {
217         require(address(this).balance >= amount, "Address: insufficient balance");
218 
219         (bool success, ) = recipient.call{value: amount}("");
220         require(success, "Address: unable to send value, recipient may have reverted");
221     }
222 
223     /**
224       * @dev Performs a Solidity function call using a low level "call". A
225       * plain "call" is an unsafe replacement for a function call: use this
226       * function instead.
227       *
228       * If "target" reverts with a revert reason, it is bubbled up by this
229       * function (like regular Solidity function calls).
230       *
231       * Returns the raw returned data. To convert to the expected return value,
232       * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
233       *
234       * Requirements:
235       *
236       * - "target" must be a contract.
237       * - calling "target" with "data" must not revert.
238       *
239       * _Available since v3.1._
240       */
241     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionCall(target, data, "Address: low-level call failed");
243     }
244 
245     /**
246       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
247       * "errorMessage" as a fallback revert reason when "target" reverts.
248       *
249       * _Available since v3.1._
250       */
251     function functionCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         return functionCallWithValue(target, data, 0, errorMessage);
257     }
258 
259     /**
260       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
261       * but also transferring "value" wei to "target".
262       *
263       * Requirements:
264       *
265       * - the calling contract must have an ETH balance of at least "value".
266       * - the called Solidity function must be {payable}.
267       *
268       * _Available since v3.1._
269       */
270     function functionCallWithValue(
271         address target,
272         bytes memory data,
273         uint256 value
274     ) internal returns (bytes memory) {
275         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
276     }
277 
278     /**
279       * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
280       * with "errorMessage" as a fallback revert reason when "target" reverts.
281       *
282       * _Available since v3.1._
283       */
284     function functionCallWithValue(
285         address target,
286         bytes memory data,
287         uint256 value,
288         string memory errorMessage
289     ) internal returns (bytes memory) {
290         require(address(this).balance >= value, "Address: insufficient balance for call");
291         require(isContract(target), "Address: call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.call{value: value}(data);
294         return verifyCallResult(success, returndata, errorMessage);
295     }
296 
297     /**
298       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
299       * but performing a static call.
300       *
301       * _Available since v3.3._
302       */
303     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
304         return functionStaticCall(target, data, "Address: low-level static call failed");
305     }
306 
307     /**
308       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
309       * but performing a static call.
310       *
311       * _Available since v3.3._
312       */
313     function functionStaticCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal view returns (bytes memory) {
318         require(isContract(target), "Address: static call to non-contract");
319 
320         (bool success, bytes memory returndata) = target.staticcall(data);
321         return verifyCallResult(success, returndata, errorMessage);
322     }
323 
324     /**
325       * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
326       * but performing a delegate call.
327       *
328       * _Available since v3.4._
329       */
330     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
331         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
332     }
333 
334     /**
335       * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
336       * but performing a delegate call.
337       *
338       * _Available since v3.4._
339       */
340     function functionDelegateCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal returns (bytes memory) {
345         require(isContract(target), "Address: delegate call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.delegatecall(data);
348         return verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352       * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
353       * revert reason using the provided one.
354       *
355       * _Available since v4.3._
356       */
357     function verifyCallResult(
358         bool success,
359         bytes memory returndata,
360         string memory errorMessage
361     ) internal pure returns (bytes memory) {
362         if (success) {
363             return returndata;
364         } else {
365             // Look for revert reason and bubble it up if present
366             if (returndata.length > 0) {
367                 // The easiest way to bubble the revert reason is using memory via assembly
368 
369                 assembly {
370                     let returndata_size := mload(returndata)
371                     revert(add(32, returndata), returndata_size)
372                 }
373             } else {
374                 revert(errorMessage);
375             }
376         }
377     }
378 }
379 
380 /**
381   * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
382   * instruction {delegatecall}. We refer to the second contract as the _implementation_ behind the proxy, and it has to
383   * be specified by overriding the virtual {_implementation} function.
384   *
385   * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
386   * different contract through the {_delegate} function.
387   *
388   * The success and return data of the delegated call will be returned back to the caller of the proxy.
389   */
390 abstract contract Proxy {
391     /**
392       * @dev Delegates the current call to {implementation}.
393       *
394       * This function does not return to its internall call site, it will return directly to the external caller.
395       */
396     function _delegate(address implementation) internal virtual {
397         assembly {
398             // Copy msg.data. We take full control of memory in this inline assembly
399             // block because it will not return to Solidity code. We overwrite the
400             // Solidity scratch pad at memory position 0.
401             calldatacopy(0, 0, calldatasize())
402 
403             // Call the implementation.
404             // out and outsize are 0 because we don't know the size yet.
405             let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
406 
407             // Copy the returned data.
408             returndatacopy(0, 0, returndatasize())
409 
410             switch result
411             // delegatecall returns 0 on error.
412             case 0 {
413                 revert(0, returndatasize())
414             }
415             default {
416                 return(0, returndatasize())
417             }
418         }
419     }
420 
421     /**
422       * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
423       * and {_fallback} should delegate.
424       */
425     function _implementation() internal view virtual returns (address);
426 
427     /**
428       * @dev Delegates the current call to the address returned by _implementation().
429       *
430       * This function does not return to its internall call site, it will return directly to the external caller.
431       */
432     function _fallback() internal virtual {
433         _beforeFallback();
434         _delegate(_implementation());
435     }
436 
437     /**
438       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if no other
439       * function in the contract matches the call data.
440       */
441     fallback() external payable virtual {
442         _fallback();
443     }
444 
445     /**
446       * @dev Fallback function that delegates calls to the address returned by _implementation(). Will run if call data
447       * is empty.
448       */
449     receive() external payable virtual {
450         _fallback();
451     }
452 
453     /**
454       * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual {_fallback}
455       * call, or as part of the Solidity {fallback} or {receive} functions.
456       *
457       * If overriden should call super._beforeFallback().
458       */
459     function _beforeFallback() internal virtual {}
460 }
461 
462 contract GnomePals is Proxy {
463     /**
464       * @dev Emitted when the implementation is upgraded.
465       */
466     event Upgraded(address indexed implementation);
467     
468     constructor() {
469 
470         assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
471         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = 0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d;
472         emit Upgraded(0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d);
473         Address.functionDelegateCall(
474             0xB56A44Eb3f22569f4ddBafdfa00Ca1A2411A4c0d,
475             abi.encodeWithSignature(
476                 "init(bool[2],address[4],uint256[10],string[4],bytes[2])",
477                 [false,false],
478                 [0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x0000000000000000000000000000000000000000,0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52],
479                 [500,990,0,0,0,10,1,5000,0,2],
480                 ["GnomePals","GNOME","ipfs://","Qmd1eF1fVwF7W4oumNcYhnMxKMnMixJVm7QUf2gJVdA95B"],
481                 ["",""]
482             )
483         );
484     
485     }
486         
487     /**
488       * @dev Storage slot with the address of the current implementation.
489       * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
490       * validated in the constructor.
491       */
492     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
493 
494     /**
495       * @dev Returns the current implementation address.
496       */
497     function implementation() public view returns (address) {
498         return _implementation();
499     }
500 
501     function _implementation() internal override view returns (address) {
502         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
503     }
504 
505     /**
506       * @dev Perform implementation upgrade
507       *
508       * Emits an {Upgraded} event.
509       */
510     function upgradeTo(
511         address newImplementation, 
512         bytes memory data,
513         bool forceCall,
514         uint8 v,
515         bytes32 r,
516         bytes32 s
517     ) external {
518         require(msg.sender == 0xB9C121402f4e89619daF7103369793055ada256A);
519         bytes32 base = keccak256(abi.encode(address(this), newImplementation));
520         bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", base));
521         
522         require(ecrecover(hash, v, r, s) == 0x1BAAd9BFa20Eb279d2E3f3e859e3ae9ddE666c52);
523 
524         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
525         if (data.length > 0 || forceCall) {
526           Address.functionDelegateCall(newImplementation, data);
527         }
528         emit Upgraded(newImplementation);
529     }
530 }
