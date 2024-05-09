1 // SPDX-License-Identifier: MIT
2 /***
3  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
4  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
5  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
6  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKOo:::::::::::::::::::::::d0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
7  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKOdlllllc,.......................;cdOKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
8  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0kdddl,......:loooooooooooooooooooooo;.'lxOKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
9  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0Ox:....:lllllc:;cooooooooooooooodooooooo:..oKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
10  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK00x,.,cccc:::;;:;;;cooooooooooooooooooooooo:. lKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
11  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKd,.  .::::;;;;;;;;;cooooooooooooooooooooooo:. l0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
12  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0l. .;;;;;;;;;;;;;;;cooooooooooooooooooooooo:..l0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
13  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKl. ,c:;;;;;;;;;;;;;cooooooooooooooooooooood:..lKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
14  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0xl;..';;;;;;;;;;;;;;;cooooooooooooooooooooooo:. ,lx0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
15  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKO; .,;;;;;;;;;;;;;;;;;cooodooolc::cloooooooolc,    'odddddddddxOKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
16  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKO; .,;;;;;;;;;;;;;;;;;cclllllc,.  .;oooooooo;.      ...........ckO0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
17  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKO; .,;;;;;;;;;,,,,,;cl,............,;:::;;;;,''''''''''''''',::'.:OKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
18  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKO; .,;;;;;;;,..  ...................',;'..........  . .. ..,;:;. ,OKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
19  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0xc;............ .....               ...                   ....,cd0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
20  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKl.      ..',...''........                     .;;;;;;;;;;;;:xKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
21  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKl.  ....''.............'..   ........     .  .lKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
22  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0kx:. .........................................  :xk0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
23  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKO:...'........................................... .:OKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
24  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKO; .,,'..........................................  ;OKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
25  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKO; .',''.........................................  ;OKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
26  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKOl;......'.....   ............  .................... .;lOKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
27  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKx. ............',.            .,.....................  .xKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
28  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKx. .'''...... .o0l'...      ':x0:  ................... .cdk0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
29  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKx. .,,''..... .kWXOOOx'    'xKNWl  ..................... .:xxxk0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
30  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0Od. ...''..... .kMWWWWK;     .'OWl  ...........................'dOOOOOOOO0KKKKKKKKKKKKKKKKKKKKKKKKKKK
31  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKd'.....',,''... .kMMMMMK;      .kWl  .................        ....''''''',o00KKKKKKKKKKKKKKKKKKKKKKKKK
32  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKl  .''''....... .kMMMMMK;      .kWl  .................''''''''....''''''''''lOKKKKKKKKKKKKKKKKKKKKKKKK
33  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0l  ........'''. .;ccccc:.       ,c'..................','....','.',,'....,,'.';lkKKKKKKKKKKKKKKKKKKKKKK
34  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0l  ........'''...                ..................,,,'..   .''''''.   ..',,'..;lx0KKKKKKKKKKKKKKKKKKK
35  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0l  ............................................ .,;,'''......''''''.....'''',;'  c0KKKKKKKKKKKKKKKKKKK
36  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0l  .'...'''''....................................,,,''''....''''''''...'''''''.  c0KKKKKKKKKKKKKKKKKKK
37  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0l  ',.....'''''...................................'''''''''''''''''''''''''''....c0KKKKKKKKKKKKKKKKKKK
38  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0l. ..............''..................................''''''''''''''''''''''.. .cxO0KKKKKKKKKKKKKKKKKKK
39  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKko:. .....''..........................................'.'''''''''''''''.'.... .dKKKKKKKKKKKKKKKKKKKKKK
40  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKx. .,'''''..',''........................................'''''''''''........;lkKKKKKKKKKKKKKKKKKKKKKK
41  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKx. .''......',,'.........................................................,l0KKKKKKKKKKKKKKKKKKKKKKKK
42  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0kdddx0KKKKKKKKKKKKk:...................................................   ..............  c0KKKKKKKKKKKKKKKKKKKKKKKKKK
43  *KKKKKKKKKKKKKKKKKKKKKKKKKKKKK0Od,   'xKKKKKKKKKKKK00k;  .......''..................................      .,:ccc:::::ccc;..l0KKKKKKKKKKKKKKKKKKKKKKKKKK
44  *KKKKKKKKKKKKKKKKKKKKKKKKK0O0Od'...  .dKKKKKKKKKKKKKKO: ....'''.....................................        .,lllcc:c:cllccx0KKKKKKKKKKKKKKKKKKKKKKKKKK
45  *KKKKKKKKKKKKKKKKKKKKKKK0Oc.......,. .dKKKKKKKKKKKKKK0kd:. ..................................................;llllc:::clllok00KKKKKKKKKKKKKKKKKKKKKKKKK
46  *KKKKKKKKKKKKKKKKKKKKKKk:'.   ..'',. .dKKKKKKKKKKKKKKKK0l. .......................................          .,llllc:::clllok0KKKKKKKKKKKKKKKKKKKKKKKKKK
47  *KKKKKKKKKKKKKKKKKKKKKKd.   ...''..';lOKKKKKKKKKKKKKKKKKl. ..','''................................           :xdllccccclodxO0KKKKKKKKKKKKKKKKKKKKKKKKKK
48  *KKKKKKKKKKKKKKKKKKKKKKk:'. ..','. ,OKKKKKKKKKKKKKKKK0xl,   ..,,''.......................................    ,lodxddddddxOKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
49  *KKKKKKKKKKKKKKKKKKKKOxddo' .''''..cOKKKKKKKKKKKKKK0xo'      ..............................................   .,oxOKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
50  *KKKKKKKKKKKKKKKKK0Ok:.  ...''. .cO00KKKKKKKKKKKK0Oo'.  ..'................................................  .,..'ok0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
51  *KKKKKKKKKKKKKKKKKO:..  .....'.  l0KKKKKKKKKKKK0Oo..','..................................''''''''''''......  ...,'..lO0KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
52  *KKKKKKKKKKKKKKKKKk,    .'''';'  l0KKKKKKKKKKK0l'...''........''''......................''''',,,,,,,,,'..'.. ...,'. .'cOKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
53  *KKKKKKKKKKKKKKKKK0dc'  .'..',.  l0KKKKKKKKKKKO;  ..........'''''.....................'''''''''',',,',''','... .....  ,OKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
54  *KKKKKKKKKKKKKKKKK0d:'  .....'...,cd0KKKKKKKOo:'.......''''''.........................'''''..............''''.  ......':oOKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
55  *KKKKKKKKKKKKKKKOdc.   .......';;. ,OKKKKKKKx. .''...'..............................''........................  .....'. .dKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
56  *KKKKKKKKKKKKKKKd.   ......''.',,. ,OKKKKKKKx. .'....'.....................................',''''''',,,'......  ......  .dKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
57  *KKKKKKKKKKKKKKKd'   ..'''.....''. ,xO0KKK0Oo. ........................................''''''''''''''''''''''.  ....... .oO0KKKKKKKKKKKKKKKKKKKKKKKKKKK
58  *KKKKKKKKKKKKKKKOxo.  ...........',..,xKK0o..',''''......''''.........................'''''''''''''''''''''''.  .......''..o0KKKKKKKKKKKKKKKKKKKKKKKKKK
59  *KKKKKKKKKKKKKKKx;..  ...........',. .dKK0l  .,......'''''...... ...................''''''''.............''''...  .....,.  c0KKKKKKKKKKKKKKKKKKKKKKKKKK
60  *KKKKKKKKKKKK0d:'.  .....''''''.......,:x0l  .....................................'''...........................   ......  c0KKKKKKKKKKKKKKKKKKKKKKKKKK
61  *KKKKKKKKKKKK0:   ......'''''''.....'.  c0l  .....................  ..........................''''''''''.......    ......  c0KKKKKKKKKKKKKKKKKKKKKKKKKK
62  *KKKKKKKKKKKK0c    .''''..............  c0l  .''..................  ...................''''''''''''''''''''''''.   .....   c0KKKKKKKKKKKKKKKKKKKKKKKKKK 
63  *
64  *                                                                                                                                                     
65  *       ';;;;;;;;;;;;.      ';;;;;;;;;;;;;;;;.       .;;;;;;;;;;;;;;;;'.      .;;;;;;;;;;;;;;;;'        ';;;;;;;;;;;;;;;;.     .';;;;;;;;;;;;;;;;.    
66  *      .kMWMMMMMMMMMMd     .OMMMMMMMMMMMMMMMMd       lWMMMMMMMMMMMMMMMK,      lWMMMMMMMMMMMMMMM0'      '0MMMMMMMMMMMMMMMWo     ,KMMMMMMMMMMMMMMMWl    
67  *    ..'OMMMMMMMMMMMMd     .OMMMMMMMMMMMMMMMMd       lWMMMMMMMMMMMMMMMK,      lWMMMMMMMMMMMMMMM0'      '0MMMMMMMMMMMMMMMMo     ,KMMMMMMMMMMMMMMMWl    
68  *  .o00KNMMMMMMMMMMMMd     .OMMMMMMMMMMMMMMMMd       lWMMMMMMMMMMMMMMMK,      lWMMMMMMMMMMMMMMM0'      '0MMMMMMMMMMMMMMMMo     ,KMMMMMMMMMMMMMMMWl    
69  *  .kMMMMMMNXNXNNXNNNo     .OMMMMMMNOxkXMMMMMd       lWMMMMNOxxxxxxxxxl.      lWMMMMMXkxxxxxxxxl.      '0MMMMW0xxxxxxxxxx,     'OXXNNXXNNNNWMMMMWc    
70  *  .kMMMMMNo..........     .OMMMMMM0' .kMMMMMd       lWMMMMO'                 lWMMMMMx.                '0MMMMNc                 ..........:0MMMMWc    
71  *  .kMMMMMN:               .OMMMMMMK;.'kMMMMMd       lWMMMMNOkkkxxo.          lWMMMMMXkkxxkxx:         '0MMMMWc                           .OMMMMWl    
72  *  .kMMMMMN:               .OMMMMMMWX0KNMMMMMd       lWMMMMMMMMMMMK,          lWMMMMMMMMMMMMMd         '0MMMMWc                       .;ooxXMMMMWl    
73  *  .kMMMMMN:               .OMMMMMMMMMMMMMMNXl       lWMMMMMMMMMMMK,          lWMMMMMMMMMMMMMd         '0MMMMWc   .......             .OMMMMMMMMWl    
74  *  .kMMMMMN:               .OMMMMMMMMMMMMMXl..       lWMMMMMMMWWWWK,          lWMMMMMMMMMMMWWd         '0MMMMWc  ;0KKK000c          .':0MMMMMXOOO;    
75  *  .kMMMMMN:               .OMMMMMMWNXXWMMXc.        lWMMMMKl;;;,,'.          lWMMMMMO:;;;;;;.         '0MMMMWc  :KXXNWMMo         ,0NWWMMMMWo        
76  *  .kMMMMMN:               .OMMMMMMK:.,OMMWXKc       lWMMMMO'                 lWMMMMMd.                '0MMMMWc   ...dWMMo         ;KMMMMMMMWl        
77  *  .kMMMMMN:               .OMMMMMM0' .xMMMMMd       lWMMMMN0kkkkkkkkkd.      lWMMMMMXOkkkkkkkko.      '0MMMMWo......oWMMo     .okkKWMMMMMXo,.        
78  *  .kMMMMMNc               .OMMMMMM0' .xMMMMMd       lWMMMMMMMMMMMMMMMK,      lWMMMMMMMMMMMMMMM0'      '0MMMMMNKKKKKKNMMMo     ,KMMMMMMMMMK,          
79  *  .kMMMMMWKOOOOOOOOO:     .OMMMMMM0' .xMMMMMd       lWMMMMMMMMMMMMMMMK,      lMMMMMMMMMMMMMMMM0'      '0MMMMMMMMMMMMMMMMo     ,KMMMMMMMMMWKOOOOk;    
80  *  .kMMMMMMMMMMMMMMMMd     .OMMMMMM0' .xMMMMMd       ;kOOOOOOOOOOOOOOOd.      ;kOOOOOOOOOOOOOkOo.      '0MMMMMMMMMMMMMMMMo     ,KMMMMMMMMMMMMMMMWl    
81  *  .:ooxXMMMMMMMMMMMMd     .OMMMMMM0' .xMMMMMd                                                         '0MMMMMMMMMMMMMMMMo     ,KMMMMMMMMMMMMMMMWl    
82  *      .kMMMMMMMMMMMMd      ,c:cccc;.  'cc:cc'                                                         .,cccccccccccccccc.     ,KMMMMMMMMMMMMMMMWl    
83  *      .dKKKKKKKKKKKKl                                                                                                         'kKKKKKKKKKKKKKKKK:    
84  *       .............                                                                                                           .................     
85  *                                                                                                    
86  *
87  * Dev by Blue Box Group, LLC                         
88  */
89 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
90 
91 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 /**
96  * @dev These functions deal with verification of Merkle Trees proofs.
97  *
98  * The proofs can be generated using the JavaScript library
99  * https://github.com/miguelmota/merkletreejs[merkletreejs].
100  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
101  *
102  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
103  *
104  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
105  * hashing, or use a hash function other than keccak256 for hashing leaves.
106  * This is because the concatenation of a sorted pair of internal nodes in
107  * the merkle tree could be reinterpreted as a leaf value.
108  */
109 library MerkleProof {
110     /**
111      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
112      * defined by `root`. For this, a `proof` must be provided, containing
113      * sibling hashes on the branch from the leaf to the root of the tree. Each
114      * pair of leaves and each pair of pre-images are assumed to be sorted.
115      */
116     function verify(
117         bytes32[] memory proof,
118         bytes32 root,
119         bytes32 leaf
120     ) internal pure returns (bool) {
121         return processProof(proof, leaf) == root;
122     }
123 
124     /**
125      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
126      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
127      * hash matches the root of the tree. When processing the proof, the pairs
128      * of leafs & pre-images are assumed to be sorted.
129      *
130      * _Available since v4.4._
131      */
132     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
133         bytes32 computedHash = leaf;
134         for (uint256 i = 0; i < proof.length; i++) {
135             bytes32 proofElement = proof[i];
136             if (computedHash <= proofElement) {
137                 // Hash(current computed hash + current element of the proof)
138                 computedHash = _efficientHash(computedHash, proofElement);
139             } else {
140                 // Hash(current element of the proof + current computed hash)
141                 computedHash = _efficientHash(proofElement, computedHash);
142             }
143         }
144         return computedHash;
145     }
146 
147     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
148         assembly {
149             mstore(0x00, a)
150             mstore(0x20, b)
151             value := keccak256(0x00, 0x40)
152         }
153     }
154 }
155 
156 // File: @openzeppelin/contracts/utils/Counters.sol
157 
158 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
159 
160 pragma solidity ^0.8.0;
161 
162 /**
163  * @title Counters
164  * @author Matt Condon (@shrugs)
165  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
166  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
167  *
168  * Include with `using Counters for Counters.Counter;`
169  */
170 library Counters {
171     struct Counter {
172         // This variable should never be directly accessed by users of the library: interactions must be restricted to
173         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
174         // this feature: see https://github.com/ethereum/solidity/issues/4637
175         uint256 _value; // default: 0
176     }
177 
178     function current(Counter storage counter) internal view returns (uint256) {
179         return counter._value;
180     }
181 
182     function increment(Counter storage counter) internal {
183         unchecked {
184             counter._value += 1;
185         }
186     }
187 
188     function decrement(Counter storage counter) internal {
189         uint256 value = counter._value;
190         require(value > 0, "Counter: decrement overflow");
191         unchecked {
192             counter._value = value - 1;
193         }
194     }
195 
196     function reset(Counter storage counter) internal {
197         counter._value = 0;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/utils/Strings.sol
202 
203 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev String operations.
209  */
210 library Strings {
211     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
212 
213     /**
214      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
215      */
216     function toString(uint256 value) internal pure returns (string memory) {
217         // Inspired by OraclizeAPI's implementation - MIT licence
218         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
219 
220         if (value == 0) {
221             return "0";
222         }
223         uint256 temp = value;
224         uint256 digits;
225         while (temp != 0) {
226             digits++;
227             temp /= 10;
228         }
229         bytes memory buffer = new bytes(digits);
230         while (value != 0) {
231             digits -= 1;
232             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
233             value /= 10;
234         }
235         return string(buffer);
236     }
237 
238     /**
239      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
240      */
241     function toHexString(uint256 value) internal pure returns (string memory) {
242         if (value == 0) {
243             return "0x00";
244         }
245         uint256 temp = value;
246         uint256 length = 0;
247         while (temp != 0) {
248             length++;
249             temp >>= 8;
250         }
251         return toHexString(value, length);
252     }
253 
254     /**
255      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
256      */
257     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
258         bytes memory buffer = new bytes(2 * length + 2);
259         buffer[0] = "0";
260         buffer[1] = "x";
261         for (uint256 i = 2 * length + 1; i > 1; --i) {
262             buffer[i] = _HEX_SYMBOLS[value & 0xf];
263             value >>= 4;
264         }
265         require(value == 0, "Strings: hex length insufficient");
266         return string(buffer);
267     }
268 }
269 
270 // File: @openzeppelin/contracts/utils/Context.sol
271 
272 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Provides information about the current execution context, including the
278  * sender of the transaction and its data. While these are generally available
279  * via msg.sender and msg.data, they should not be accessed in such a direct
280  * manner, since when dealing with meta-transactions the account sending and
281  * paying for execution may not be the actual sender (as far as an application
282  * is concerned).
283  *
284  * This contract is only required for intermediate, library-like contracts.
285  */
286 abstract contract Context {
287     function _msgSender() internal view virtual returns (address) {
288         return msg.sender;
289     }
290 
291     function _msgData() internal view virtual returns (bytes calldata) {
292         return msg.data;
293     }
294 }
295 
296 // File: @openzeppelin/contracts/access/Ownable.sol
297 
298 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @dev Contract module which provides a basic access control mechanism, where
304  * there is an account (an owner) that can be granted exclusive access to
305  * specific functions.
306  *
307  * By default, the owner account will be the one that deploys the contract. This
308  * can later be changed with {transferOwnership}.
309  *
310  * This module is used through inheritance. It will make available the modifier
311  * `onlyOwner`, which can be applied to your functions to restrict their use to
312  * the owner.
313  */
314 abstract contract Ownable is Context {
315     address private _owner;
316 
317     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
318 
319     /**
320      * @dev Initializes the contract setting the deployer as the initial owner.
321      */
322     constructor() {
323         _transferOwnership(_msgSender());
324     }
325 
326     /**
327      * @dev Returns the address of the current owner.
328      */
329     function owner() public view virtual returns (address) {
330         return _owner;
331     }
332 
333     /**
334      * @dev Throws if called by any account other than the owner.
335      */
336     modifier onlyOwner() {
337         require(owner() == _msgSender(), "Ownable: caller is not the owner");
338         _;
339     }
340 
341     /**
342      * @dev Leaves the contract without owner. It will not be possible to call
343      * `onlyOwner` functions anymore. Can only be called by the current owner.
344      *
345      * NOTE: Renouncing ownership will leave the contract without an owner,
346      * thereby removing any functionality that is only available to the owner.
347      */
348     function renounceOwnership() public virtual onlyOwner {
349         _transferOwnership(address(0));
350     }
351 
352     /**
353      * @dev Transfers ownership of the contract to a new account (`newOwner`).
354      * Can only be called by the current owner.
355      */
356     function transferOwnership(address newOwner) public virtual onlyOwner {
357         require(newOwner != address(0), "Ownable: new owner is the zero address");
358         _transferOwnership(newOwner);
359     }
360 
361     /**
362      * @dev Transfers ownership of the contract to a new account (`newOwner`).
363      * Internal function without access restriction.
364      */
365     function _transferOwnership(address newOwner) internal virtual {
366         address oldOwner = _owner;
367         _owner = newOwner;
368         emit OwnershipTransferred(oldOwner, newOwner);
369     }
370 }
371 
372 // File: @openzeppelin/contracts/utils/Address.sol
373 
374 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @dev Collection of functions related to the address type
380  */
381 library Address {
382     /**
383      * @dev Returns true if `account` is a contract.
384      *
385      * [IMPORTANT]
386      * ====
387      * It is unsafe to assume that an address for which this function returns
388      * false is an externally-owned account (EOA) and not a contract.
389      *
390      * Among others, `isContract` will return false for the following
391      * types of addresses:
392      *
393      *  - an externally-owned account
394      *  - a contract in construction
395      *  - an address where a contract will be created
396      *  - an address where a contract lived, but was destroyed
397      * ====
398      */
399     function isContract(address account) internal view returns (bool) {
400         // This method relies on extcodesize, which returns 0 for contracts in
401         // construction, since the code is only stored at the end of the
402         // constructor execution.
403 
404         uint256 size;
405         assembly {
406             size := extcodesize(account)
407         }
408         return size > 0;
409     }
410 
411     /**
412      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
413      * `recipient`, forwarding all available gas and reverting on errors.
414      *
415      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
416      * of certain opcodes, possibly making contracts go over the 2300 gas limit
417      * imposed by `transfer`, making them unable to receive funds via
418      * `transfer`. {sendValue} removes this limitation.
419      *
420      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
421      *
422      * IMPORTANT: because control is transferred to `recipient`, care must be
423      * taken to not create reentrancy vulnerabilities. Consider using
424      * {ReentrancyGuard} or the
425      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
426      */
427     function sendValue(address payable recipient, uint256 amount) internal {
428         require(address(this).balance >= amount, "Address: insufficient balance");
429 
430         (bool success, ) = recipient.call{value: amount}("");
431         require(success, "Address: unable to send value, recipient may have reverted");
432     }
433 
434     /**
435      * @dev Performs a Solidity function call using a low level `call`. A
436      * plain `call` is an unsafe replacement for a function call: use this
437      * function instead.
438      *
439      * If `target` reverts with a revert reason, it is bubbled up by this
440      * function (like regular Solidity function calls).
441      *
442      * Returns the raw returned data. To convert to the expected return value,
443      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
444      *
445      * Requirements:
446      *
447      * - `target` must be a contract.
448      * - calling `target` with `data` must not revert.
449      *
450      * _Available since v3.1._
451      */
452     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
453         return functionCall(target, data, "Address: low-level call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
458      * `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         return functionCallWithValue(target, data, 0, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but also transferring `value` wei to `target`.
473      *
474      * Requirements:
475      *
476      * - the calling contract must have an ETH balance of at least `value`.
477      * - the called Solidity function must be `payable`.
478      *
479      * _Available since v3.1._
480      */
481     function functionCallWithValue(
482         address target,
483         bytes memory data,
484         uint256 value
485     ) internal returns (bytes memory) {
486         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
491      * with `errorMessage` as a fallback revert reason when `target` reverts.
492      *
493      * _Available since v3.1._
494      */
495     function functionCallWithValue(
496         address target,
497         bytes memory data,
498         uint256 value,
499         string memory errorMessage
500     ) internal returns (bytes memory) {
501         require(address(this).balance >= value, "Address: insufficient balance for call");
502         require(isContract(target), "Address: call to non-contract");
503 
504         (bool success, bytes memory returndata) = target.call{value: value}(data);
505         return verifyCallResult(success, returndata, errorMessage);
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
510      * but performing a static call.
511      *
512      * _Available since v3.3._
513      */
514     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
515         return functionStaticCall(target, data, "Address: low-level static call failed");
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
520      * but performing a static call.
521      *
522      * _Available since v3.3._
523      */
524     function functionStaticCall(
525         address target,
526         bytes memory data,
527         string memory errorMessage
528     ) internal view returns (bytes memory) {
529         require(isContract(target), "Address: static call to non-contract");
530 
531         (bool success, bytes memory returndata) = target.staticcall(data);
532         return verifyCallResult(success, returndata, errorMessage);
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
537      * but performing a delegate call.
538      *
539      * _Available since v3.4._
540      */
541     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
542         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
547      * but performing a delegate call.
548      *
549      * _Available since v3.4._
550      */
551     function functionDelegateCall(
552         address target,
553         bytes memory data,
554         string memory errorMessage
555     ) internal returns (bytes memory) {
556         require(isContract(target), "Address: delegate call to non-contract");
557 
558         (bool success, bytes memory returndata) = target.delegatecall(data);
559         return verifyCallResult(success, returndata, errorMessage);
560     }
561 
562     /**
563      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
564      * revert reason using the provided one.
565      *
566      * _Available since v4.3._
567      */
568     function verifyCallResult(
569         bool success,
570         bytes memory returndata,
571         string memory errorMessage
572     ) internal pure returns (bytes memory) {
573         if (success) {
574             return returndata;
575         } else {
576             // Look for revert reason and bubble it up if present
577             if (returndata.length > 0) {
578                 // The easiest way to bubble the revert reason is using memory via assembly
579 
580                 assembly {
581                     let returndata_size := mload(returndata)
582                     revert(add(32, returndata), returndata_size)
583                 }
584             } else {
585                 revert(errorMessage);
586             }
587         }
588     }
589 }
590 
591 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
592 
593 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @title ERC721 token receiver interface
599  * @dev Interface for any contract that wants to support safeTransfers
600  * from ERC721 asset contracts.
601  */
602 interface IERC721Receiver {
603     /**
604      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
605      * by `operator` from `from`, this function is called.
606      *
607      * It must return its Solidity selector to confirm the token transfer.
608      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
609      *
610      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
611      */
612     function onERC721Received(
613         address operator,
614         address from,
615         uint256 tokenId,
616         bytes calldata data
617     ) external returns (bytes4);
618 }
619 
620 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
621 
622 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 /**
627  * @dev Interface of the ERC165 standard, as defined in the
628  * https://eips.ethereum.org/EIPS/eip-165[EIP].
629  *
630  * Implementers can declare support of contract interfaces, which can then be
631  * queried by others ({ERC165Checker}).
632  *
633  * For an implementation, see {ERC165}.
634  */
635 interface IERC165 {
636     /**
637      * @dev Returns true if this contract implements the interface defined by
638      * `interfaceId`. See the corresponding
639      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
640      * to learn more about how these ids are created.
641      *
642      * This function call must use less than 30 000 gas.
643      */
644     function supportsInterface(bytes4 interfaceId) external view returns (bool);
645 }
646 
647 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
648 
649 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
650 
651 pragma solidity ^0.8.0;
652 
653 /**
654  * @dev Implementation of the {IERC165} interface.
655  *
656  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
657  * for the additional interface id that will be supported. For example:
658  *
659  * ```solidity
660  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
661  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
662  * }
663  * ```
664  *
665  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
666  */
667 abstract contract ERC165 is IERC165 {
668     /**
669      * @dev See {IERC165-supportsInterface}.
670      */
671     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
672         return interfaceId == type(IERC165).interfaceId;
673     }
674 }
675 
676 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
677 
678 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 /**
683  * @dev Required interface of an ERC721 compliant contract.
684  */
685 interface IERC721 is IERC165 {
686     /**
687      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
688      */
689     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
690 
691     /**
692      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
693      */
694     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
695 
696     /**
697      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
698      */
699     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
700 
701     /**
702      * @dev Returns the number of tokens in ``owner``'s account.
703      */
704     function balanceOf(address owner) external view returns (uint256 balance);
705 
706     /**
707      * @dev Returns the owner of the `tokenId` token.
708      *
709      * Requirements:
710      *
711      * - `tokenId` must exist.
712      */
713     function ownerOf(uint256 tokenId) external view returns (address owner);
714 
715     /**
716      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
717      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
718      *
719      * Requirements:
720      *
721      * - `from` cannot be the zero address.
722      * - `to` cannot be the zero address.
723      * - `tokenId` token must exist and be owned by `from`.
724      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
725      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
726      *
727      * Emits a {Transfer} event.
728      */
729     function safeTransferFrom(
730         address from,
731         address to,
732         uint256 tokenId
733     ) external;
734 
735     /**
736      * @dev Transfers `tokenId` token from `from` to `to`.
737      *
738      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
739      *
740      * Requirements:
741      *
742      * - `from` cannot be the zero address.
743      * - `to` cannot be the zero address.
744      * - `tokenId` token must be owned by `from`.
745      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
746      *
747      * Emits a {Transfer} event.
748      */
749     function transferFrom(
750         address from,
751         address to,
752         uint256 tokenId
753     ) external;
754 
755     /**
756      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
757      * The approval is cleared when the token is transferred.
758      *
759      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
760      *
761      * Requirements:
762      *
763      * - The caller must own the token or be an approved operator.
764      * - `tokenId` must exist.
765      *
766      * Emits an {Approval} event.
767      */
768     function approve(address to, uint256 tokenId) external;
769 
770     /**
771      * @dev Returns the account approved for `tokenId` token.
772      *
773      * Requirements:
774      *
775      * - `tokenId` must exist.
776      */
777     function getApproved(uint256 tokenId) external view returns (address operator);
778 
779     /**
780      * @dev Approve or remove `operator` as an operator for the caller.
781      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
782      *
783      * Requirements:
784      *
785      * - The `operator` cannot be the caller.
786      *
787      * Emits an {ApprovalForAll} event.
788      */
789     function setApprovalForAll(address operator, bool _approved) external;
790 
791     /**
792      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
793      *
794      * See {setApprovalForAll}
795      */
796     function isApprovedForAll(address owner, address operator) external view returns (bool);
797 
798     /**
799      * @dev Safely transfers `tokenId` token from `from` to `to`.
800      *
801      * Requirements:
802      *
803      * - `from` cannot be the zero address.
804      * - `to` cannot be the zero address.
805      * - `tokenId` token must exist and be owned by `from`.
806      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
807      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
808      *
809      * Emits a {Transfer} event.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId,
815         bytes calldata data
816     ) external;
817 }
818 
819 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
820 
821 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
822 
823 pragma solidity ^0.8.0;
824 
825 /**
826  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
827  * @dev See https://eips.ethereum.org/EIPS/eip-721
828  */
829 interface IERC721Metadata is IERC721 {
830     /**
831      * @dev Returns the token collection name.
832      */
833     function name() external view returns (string memory);
834 
835     /**
836      * @dev Returns the token collection symbol.
837      */
838     function symbol() external view returns (string memory);
839 
840     /**
841      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
842      */
843     function tokenURI(uint256 tokenId) external view returns (string memory);
844 }
845 
846 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
847 
848 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
849 
850 pragma solidity ^0.8.0;
851 
852 /**
853  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
854  * the Metadata extension, but not including the Enumerable extension, which is available separately as
855  * {ERC721Enumerable}.
856  */
857 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
858     using Address for address;
859     using Strings for uint256;
860 
861     // Token name
862     string private _name;
863 
864     // Token symbol
865     string private _symbol;
866 
867     // Mapping from token ID to owner address
868     mapping(uint256 => address) private _owners;
869 
870     // Mapping owner address to token count
871     mapping(address => uint256) private _balances;
872 
873     // Mapping from token ID to approved address
874     mapping(uint256 => address) private _tokenApprovals;
875 
876     // Mapping from owner to operator approvals
877     mapping(address => mapping(address => bool)) private _operatorApprovals;
878 
879     /**
880      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
881      */
882     constructor(string memory name_, string memory symbol_) {
883         _name = name_;
884         _symbol = symbol_;
885     }
886 
887     /**
888      * @dev See {IERC165-supportsInterface}.
889      */
890     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
891         return
892             interfaceId == type(IERC721).interfaceId ||
893             interfaceId == type(IERC721Metadata).interfaceId ||
894             super.supportsInterface(interfaceId);
895     }
896 
897     /**
898      * @dev See {IERC721-balanceOf}.
899      */
900     function balanceOf(address owner) public view virtual override returns (uint256) {
901         require(owner != address(0), "ERC721: balance query for the zero address");
902         return _balances[owner];
903     }
904 
905     /**
906      * @dev See {IERC721-ownerOf}.
907      */
908     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
909         address owner = _owners[tokenId];
910         require(owner != address(0), "ERC721: owner query for nonexistent token");
911         return owner;
912     }
913 
914     /**
915      * @dev See {IERC721Metadata-name}.
916      */
917     function name() public view virtual override returns (string memory) {
918         return _name;
919     }
920 
921     /**
922      * @dev See {IERC721Metadata-symbol}.
923      */
924     function symbol() public view virtual override returns (string memory) {
925         return _symbol;
926     }
927 
928     /**
929      * @dev See {IERC721Metadata-tokenURI}.
930      */
931     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
932         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
933 
934         string memory baseURI = _baseURI();
935         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
936     }
937 
938     /**
939      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
940      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
941      * by default, can be overriden in child contracts.
942      */
943     function _baseURI() internal view virtual returns (string memory) {
944         return "";
945     }
946 
947     /**
948      * @dev See {IERC721-approve}.
949      */
950     function approve(address to, uint256 tokenId) public virtual override {
951         address owner = ERC721.ownerOf(tokenId);
952         require(to != owner, "ERC721: approval to current owner");
953 
954         require(
955             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
956             "ERC721: approve caller is not owner nor approved for all"
957         );
958 
959         _approve(to, tokenId);
960     }
961 
962     /**
963      * @dev See {IERC721-getApproved}.
964      */
965     function getApproved(uint256 tokenId) public view virtual override returns (address) {
966         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
967 
968         return _tokenApprovals[tokenId];
969     }
970 
971     /**
972      * @dev See {IERC721-setApprovalForAll}.
973      */
974     function setApprovalForAll(address operator, bool approved) public virtual override {
975         _setApprovalForAll(_msgSender(), operator, approved);
976     }
977 
978     /**
979      * @dev See {IERC721-isApprovedForAll}.
980      */
981     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
982         return _operatorApprovals[owner][operator];
983     }
984 
985     /**
986      * @dev See {IERC721-transferFrom}.
987      */
988     function transferFrom(
989         address from,
990         address to,
991         uint256 tokenId
992     ) public virtual override {
993         //solhint-disable-next-line max-line-length
994         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
995 
996         _transfer(from, to, tokenId);
997     }
998 
999     /**
1000      * @dev See {IERC721-safeTransferFrom}.
1001      */
1002     function safeTransferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) public virtual override {
1007         safeTransferFrom(from, to, tokenId, "");
1008     }
1009 
1010     /**
1011      * @dev See {IERC721-safeTransferFrom}.
1012      */
1013     function safeTransferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) public virtual override {
1019         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1020         _safeTransfer(from, to, tokenId, _data);
1021     }
1022 
1023     /**
1024      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1025      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1026      *
1027      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1028      *
1029      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1030      * implement alternative mechanisms to perform token transfer, such as signature-based.
1031      *
1032      * Requirements:
1033      *
1034      * - `from` cannot be the zero address.
1035      * - `to` cannot be the zero address.
1036      * - `tokenId` token must exist and be owned by `from`.
1037      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function _safeTransfer(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) internal virtual {
1047         _transfer(from, to, tokenId);
1048         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1049     }
1050 
1051     /**
1052      * @dev Returns whether `tokenId` exists.
1053      *
1054      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1055      *
1056      * Tokens start existing when they are minted (`_mint`),
1057      * and stop existing when they are burned (`_burn`).
1058      */
1059     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1060         return _owners[tokenId] != address(0);
1061     }
1062 
1063     /**
1064      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must exist.
1069      */
1070     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1071         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1072         address owner = ERC721.ownerOf(tokenId);
1073         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1074     }
1075 
1076     /**
1077      * @dev Safely mints `tokenId` and transfers it to `to`.
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must not exist.
1082      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _safeMint(address to, uint256 tokenId) internal virtual {
1087         _safeMint(to, tokenId, "");
1088     }
1089 
1090     /**
1091      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1092      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1093      */
1094     function _safeMint(
1095         address to,
1096         uint256 tokenId,
1097         bytes memory _data
1098     ) internal virtual {
1099         _mint(to, tokenId);
1100         require(
1101             _checkOnERC721Received(address(0), to, tokenId, _data),
1102             "ERC721: transfer to non ERC721Receiver implementer"
1103         );
1104     }
1105 
1106     /**
1107      * @dev Mints `tokenId` and transfers it to `to`.
1108      *
1109      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1110      *
1111      * Requirements:
1112      *
1113      * - `tokenId` must not exist.
1114      * - `to` cannot be the zero address.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _mint(address to, uint256 tokenId) internal virtual {
1119         require(to != address(0), "ERC721: mint to the zero address");
1120         require(!_exists(tokenId), "ERC721: token already minted");
1121 
1122         _beforeTokenTransfer(address(0), to, tokenId);
1123 
1124         _balances[to] += 1;
1125         _owners[tokenId] = to;
1126 
1127         emit Transfer(address(0), to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev Destroys `tokenId`.
1132      * The approval is cleared when the token is burned.
1133      *
1134      * Requirements:
1135      *
1136      * - `tokenId` must exist.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _burn(uint256 tokenId) internal virtual {
1141         address owner = ERC721.ownerOf(tokenId);
1142 
1143         _beforeTokenTransfer(owner, address(0), tokenId);
1144 
1145         // Clear approvals
1146         _approve(address(0), tokenId);
1147 
1148         _balances[owner] -= 1;
1149         delete _owners[tokenId];
1150 
1151         emit Transfer(owner, address(0), tokenId);
1152     }
1153 
1154     /**
1155      * @dev Transfers `tokenId` from `from` to `to`.
1156      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1157      *
1158      * Requirements:
1159      *
1160      * - `to` cannot be the zero address.
1161      * - `tokenId` token must be owned by `from`.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _transfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) internal virtual {
1170         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1171         require(to != address(0), "ERC721: transfer to the zero address");
1172 
1173         _beforeTokenTransfer(from, to, tokenId);
1174 
1175         // Clear approvals from the previous owner
1176         _approve(address(0), tokenId);
1177 
1178         _balances[from] -= 1;
1179         _balances[to] += 1;
1180         _owners[tokenId] = to;
1181 
1182         emit Transfer(from, to, tokenId);
1183     }
1184 
1185     /**
1186      * @dev Approve `to` to operate on `tokenId`
1187      *
1188      * Emits a {Approval} event.
1189      */
1190     function _approve(address to, uint256 tokenId) internal virtual {
1191         _tokenApprovals[tokenId] = to;
1192         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1193     }
1194 
1195     /**
1196      * @dev Approve `operator` to operate on all of `owner` tokens
1197      *
1198      * Emits a {ApprovalForAll} event.
1199      */
1200     function _setApprovalForAll(
1201         address owner,
1202         address operator,
1203         bool approved
1204     ) internal virtual {
1205         require(owner != operator, "ERC721: approve to caller");
1206         _operatorApprovals[owner][operator] = approved;
1207         emit ApprovalForAll(owner, operator, approved);
1208     }
1209 
1210     /**
1211      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1212      * The call is not executed if the target address is not a contract.
1213      *
1214      * @param from address representing the previous owner of the given token ID
1215      * @param to target address that will receive the tokens
1216      * @param tokenId uint256 ID of the token to be transferred
1217      * @param _data bytes optional data to send along with the call
1218      * @return bool whether the call correctly returned the expected magic value
1219      */
1220     function _checkOnERC721Received(
1221         address from,
1222         address to,
1223         uint256 tokenId,
1224         bytes memory _data
1225     ) private returns (bool) {
1226         if (to.isContract()) {
1227             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1228                 return retval == IERC721Receiver.onERC721Received.selector;
1229             } catch (bytes memory reason) {
1230                 if (reason.length == 0) {
1231                     revert("ERC721: transfer to non ERC721Receiver implementer");
1232                 } else {
1233                     assembly {
1234                         revert(add(32, reason), mload(reason))
1235                     }
1236                 }
1237             }
1238         } else {
1239             return true;
1240         }
1241     }
1242 
1243     /**
1244      * @dev Hook that is called before any token transfer. This includes minting
1245      * and burning.
1246      *
1247      * Calling conditions:
1248      *
1249      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1250      * transferred to `to`.
1251      * - When `from` is zero, `tokenId` will be minted for `to`.
1252      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1253      * - `from` and `to` are never both zero.
1254      *
1255      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1256      */
1257     function _beforeTokenTransfer(
1258         address from,
1259         address to,
1260         uint256 tokenId
1261     ) internal virtual {}
1262 }
1263 
1264 pragma solidity >=0.7.0 <0.9.0;
1265 
1266 contract OfficialCreegz is ERC721, Ownable {
1267   using Strings for uint256;
1268   using Counters for Counters.Counter;
1269 
1270   Counters.Counter private supply;
1271 
1272   string public uriPrefix = "QmaiuUHmXcSSBsLbUPQ2rGSLLrSb2Y3N8JFA7C9V6UNzqz";
1273   string public uriSuffix = ".json";
1274   string public hiddenMetadataUri;
1275   
1276   uint256 public costPub = 0.06 ether;
1277   uint256 public costWL = 0.05 ether;
1278   uint256 public maxSupply = 5555;
1279   uint256 public maxMintAmountPerWallet = 10;
1280   uint256 public maxMintAmountPerWalletWL = 5;
1281 
1282   bool public paused = true;
1283   bool public revealed = false;
1284   bool public WhitelistActive = true;
1285   address[] public teamAddresses;
1286   //The root hash of the Merkle Tree previously generated in the JavaScript code of your dapp.
1287   //You can add this after deploying using the built in function. replace everything except the 0x
1288   bytes32 public merkleRoot = 0xccfdfe24095d309ecd06996a6a887352fe04a9f733a35f792f58ef75fa16ba07;
1289 
1290   mapping(address => uint256) public addressMintedBalance;
1291   //mapping(address => bool) public whitelistClaimed;
1292 
1293   constructor() ERC721("OfficialCreegz", "OFC") {
1294     setHiddenMetadataUri("ipfs://QmXJpFmT26eCNNYQugghTfr3erTY5w4Cy98NrjK49mzfTx/CreegEg.json");
1295   }
1296 
1297   modifier mintCompliance(uint256 _mintAmount) {
1298     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerWallet, "Invalid mint amount!");
1299     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1300     _;
1301   }
1302 
1303   function totalSupply() public view returns (uint256) {
1304     return supply.current();
1305   }
1306 
1307         function whitelistMint(bytes32[] calldata _merkleProof, uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1308         require(!paused, "The contract is paused!");
1309         //Verify the provided _merkleProof.
1310         if (msg.sender != owner()) {
1311             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1312             require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof.");
1313             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1314             require(_mintAmount + ownerMintedCount <= maxMintAmountPerWalletWL, "max NFT per wallet during whielist would be exceeded");
1315             require(msg.value >= costWL * _mintAmount, "Insufficient funds!");
1316         }
1317         _mintLoop(msg.sender, _mintAmount);
1318         }
1319 
1320         function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1321         require(!paused, "The contract is paused!");
1322         if (msg.sender != owner()) {
1323             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1324             require(_mintAmount + ownerMintedCount <= maxMintAmountPerWallet, "max total NFT's per wallet would be exceeded");
1325             require(msg.value >= costPub * _mintAmount, "Insufficient funds!");
1326         }
1327 
1328         _mintLoop(msg.sender, _mintAmount);
1329         }
1330 
1331         function mintForTeam(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1332             
1333         if (msg.sender != owner()) {
1334             require(isTeam(msg.sender), "user is not a team member");
1335         }
1336 
1337         _mintLoop(msg.sender, _mintAmount);
1338         }
1339 
1340   function isTeam(address _user) public view returns (bool) {
1341     for (uint i = 0; i < teamAddresses.length; i++) {
1342       if (teamAddresses[i] == _user) {
1343           return true;
1344       }
1345     }
1346     return false;
1347   }
1348   
1349   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1350     _mintLoop(_receiver, _mintAmount);
1351   }
1352 
1353   function walletOfOwner(address _owner)
1354     public
1355     view
1356     returns (uint256[] memory)
1357   {
1358     uint256 ownerTokenCount = balanceOf(_owner);
1359     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1360     uint256 currentTokenId = 1;
1361     uint256 ownedTokenIndex = 0;
1362 
1363     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1364       address currentTokenOwner = ownerOf(currentTokenId);
1365 
1366       if (currentTokenOwner == _owner) {
1367         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1368 
1369         ownedTokenIndex++;
1370       }
1371 
1372       currentTokenId++;
1373     }
1374 
1375     return ownedTokenIds;
1376   }
1377 
1378   function tokenURI(uint256 _tokenId)
1379     public
1380     view
1381     virtual
1382     override
1383     returns (string memory)
1384   {
1385     require(
1386       _exists(_tokenId),
1387       "ERC721Metadata: URI query for nonexistent token"
1388     );
1389 
1390     if (revealed == false) {
1391       return hiddenMetadataUri;
1392     }
1393 
1394     string memory currentBaseURI = _baseURI();
1395     return bytes(currentBaseURI).length > 0
1396         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1397         : "";
1398   }
1399 
1400   function setRevealed(bool _state) public onlyOwner {
1401     revealed = _state;
1402   }
1403 
1404   function setCostPub(uint256 _costpub) public onlyOwner {
1405     costPub = _costpub;
1406   }
1407 
1408   function setCostWL(uint256 _costwl) public onlyOwner {
1409     costWL = _costwl;
1410   }
1411 
1412   function setMaxMintAmountPerWallet(uint256 _maxMintAmountPerWallet) public onlyOwner {
1413     maxMintAmountPerWallet = _maxMintAmountPerWallet;
1414   }
1415 
1416   function setMaxMintAmountPerWalletWL(uint256 _maxMintAmountPerWalletWL) public onlyOwner {
1417     maxMintAmountPerWalletWL = _maxMintAmountPerWalletWL;
1418   }
1419 
1420   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1421     hiddenMetadataUri = _hiddenMetadataUri;
1422   }
1423 
1424   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1425     uriPrefix = _uriPrefix;
1426   }
1427 
1428   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1429     uriSuffix = _uriSuffix;
1430   }
1431 
1432   function setPaused(bool _state) public onlyOwner {
1433     paused = _state;
1434   }
1435 
1436   function setWhitelistActive(bool _state) public onlyOwner {
1437     WhitelistActive = _state;
1438   }
1439 
1440   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1441     merkleRoot = _merkleRoot;
1442   }
1443 
1444   function teamUsers(address[] calldata _users) public onlyOwner {
1445     delete teamAddresses;
1446     teamAddresses = _users;
1447   }
1448 
1449   function withdraw() public onlyOwner {
1450     // This will pay MadManwithaBlueBox 0.5% of the initial mint.
1451     // You can comment out the next 2 lines if you want, or leave them uncommented to support MMWABB and his work.
1452     // =============================================================================
1453     //(bool ms, ) = payable(0x943590A42C27D08e3744202c4Ae5eD55c2dE240D).call{value: (address(this).balance * 1 / 100)/2}("");
1454     //require(ms);
1455     // =============================================================================
1456 
1457     // This will transfer the remaining contract balance to the owner.
1458     // Do not remove the next 2 lines otherwise you will not be able to withdraw your funds.
1459     // =============================================================================
1460     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1461     require(os);
1462     // =============================================================================
1463   }
1464 
1465   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1466     for (uint256 i = 0; i < _mintAmount; i++) {
1467       supply.increment();
1468       addressMintedBalance[_receiver]++;
1469       _safeMint(_receiver, supply.current());
1470     }
1471   }
1472 
1473   function _baseURI() internal view virtual override returns (string memory) {
1474     return uriPrefix;
1475   }
1476 }