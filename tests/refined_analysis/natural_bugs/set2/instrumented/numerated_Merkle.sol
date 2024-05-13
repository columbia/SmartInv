1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // work based on eth2 deposit contract, which is used under CC0-1.0
5 
6 /**
7  * @title MerkleLib
8  * @author Illusory Systems Inc.
9  * @notice An incremental merkle tree modeled on the eth2 deposit contract.
10  **/
11 library MerkleLib {
12     uint256 internal constant TREE_DEPTH = 32;
13     uint256 internal constant MAX_LEAVES = 2**TREE_DEPTH - 1;
14 
15     /**
16      * @notice Struct representing incremental merkle tree. Contains current
17      * branch and the number of inserted leaves in the tree.
18      **/
19     struct Tree {
20         bytes32[TREE_DEPTH] branch;
21         uint256 count;
22     }
23 
24     /**
25      * @notice Inserts `_node` into merkle tree
26      * @dev Reverts if tree is full
27      * @param _node Element to insert into tree
28      **/
29     function insert(Tree storage _tree, bytes32 _node) internal {
30         require(_tree.count < MAX_LEAVES, "merkle tree full");
31 
32         _tree.count += 1;
33         uint256 size = _tree.count;
34         for (uint256 i = 0; i < TREE_DEPTH; i++) {
35             if ((size & 1) == 1) {
36                 _tree.branch[i] = _node;
37                 return;
38             }
39             _node = keccak256(abi.encodePacked(_tree.branch[i], _node));
40             size /= 2;
41         }
42         // As the loop should always end prematurely with the `return` statement,
43         // this code should be unreachable. We assert `false` just to be safe.
44         assert(false);
45     }
46 
47     /**
48      * @notice Calculates and returns`_tree`'s current root given array of zero
49      * hashes
50      * @param _zeroes Array of zero hashes
51      * @return _current Calculated root of `_tree`
52      **/
53     function rootWithCtx(Tree storage _tree, bytes32[TREE_DEPTH] memory _zeroes)
54         internal
55         view
56         returns (bytes32 _current)
57     {
58         uint256 _index = _tree.count;
59 
60         for (uint256 i = 0; i < TREE_DEPTH; i++) {
61             uint256 _ithBit = (_index >> i) & 0x01;
62             bytes32 _next = _tree.branch[i];
63             if (_ithBit == 1) {
64                 _current = keccak256(abi.encodePacked(_next, _current));
65             } else {
66                 _current = keccak256(abi.encodePacked(_current, _zeroes[i]));
67             }
68         }
69     }
70 
71     /// @notice Calculates and returns`_tree`'s current root
72     function root(Tree storage _tree) internal view returns (bytes32) {
73         return rootWithCtx(_tree, zeroHashes());
74     }
75 
76     /// @notice Returns array of TREE_DEPTH zero hashes
77     /// @return _zeroes Array of TREE_DEPTH zero hashes
78     function zeroHashes()
79         internal
80         pure
81         returns (bytes32[TREE_DEPTH] memory _zeroes)
82     {
83         _zeroes[0] = Z_0;
84         _zeroes[1] = Z_1;
85         _zeroes[2] = Z_2;
86         _zeroes[3] = Z_3;
87         _zeroes[4] = Z_4;
88         _zeroes[5] = Z_5;
89         _zeroes[6] = Z_6;
90         _zeroes[7] = Z_7;
91         _zeroes[8] = Z_8;
92         _zeroes[9] = Z_9;
93         _zeroes[10] = Z_10;
94         _zeroes[11] = Z_11;
95         _zeroes[12] = Z_12;
96         _zeroes[13] = Z_13;
97         _zeroes[14] = Z_14;
98         _zeroes[15] = Z_15;
99         _zeroes[16] = Z_16;
100         _zeroes[17] = Z_17;
101         _zeroes[18] = Z_18;
102         _zeroes[19] = Z_19;
103         _zeroes[20] = Z_20;
104         _zeroes[21] = Z_21;
105         _zeroes[22] = Z_22;
106         _zeroes[23] = Z_23;
107         _zeroes[24] = Z_24;
108         _zeroes[25] = Z_25;
109         _zeroes[26] = Z_26;
110         _zeroes[27] = Z_27;
111         _zeroes[28] = Z_28;
112         _zeroes[29] = Z_29;
113         _zeroes[30] = Z_30;
114         _zeroes[31] = Z_31;
115     }
116 
117     /**
118      * @notice Calculates and returns the merkle root for the given leaf
119      * `_item`, a merkle branch, and the index of `_item` in the tree.
120      * @param _item Merkle leaf
121      * @param _branch Merkle proof
122      * @param _index Index of `_item` in tree
123      * @return _current Calculated merkle root
124      **/
125     function branchRoot(
126         bytes32 _item,
127         bytes32[TREE_DEPTH] memory _branch,
128         uint256 _index
129     ) internal pure returns (bytes32 _current) {
130         _current = _item;
131 
132         for (uint256 i = 0; i < TREE_DEPTH; i++) {
133             uint256 _ithBit = (_index >> i) & 0x01;
134             bytes32 _next = _branch[i];
135             if (_ithBit == 1) {
136                 _current = keccak256(abi.encodePacked(_next, _current));
137             } else {
138                 _current = keccak256(abi.encodePacked(_current, _next));
139             }
140         }
141     }
142 
143     // keccak256 zero hashes
144     bytes32 internal constant Z_0 =
145         hex"0000000000000000000000000000000000000000000000000000000000000000";
146     bytes32 internal constant Z_1 =
147         hex"ad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5";
148     bytes32 internal constant Z_2 =
149         hex"b4c11951957c6f8f642c4af61cd6b24640fec6dc7fc607ee8206a99e92410d30";
150     bytes32 internal constant Z_3 =
151         hex"21ddb9a356815c3fac1026b6dec5df3124afbadb485c9ba5a3e3398a04b7ba85";
152     bytes32 internal constant Z_4 =
153         hex"e58769b32a1beaf1ea27375a44095a0d1fb664ce2dd358e7fcbfb78c26a19344";
154     bytes32 internal constant Z_5 =
155         hex"0eb01ebfc9ed27500cd4dfc979272d1f0913cc9f66540d7e8005811109e1cf2d";
156     bytes32 internal constant Z_6 =
157         hex"887c22bd8750d34016ac3c66b5ff102dacdd73f6b014e710b51e8022af9a1968";
158     bytes32 internal constant Z_7 =
159         hex"ffd70157e48063fc33c97a050f7f640233bf646cc98d9524c6b92bcf3ab56f83";
160     bytes32 internal constant Z_8 =
161         hex"9867cc5f7f196b93bae1e27e6320742445d290f2263827498b54fec539f756af";
162     bytes32 internal constant Z_9 =
163         hex"cefad4e508c098b9a7e1d8feb19955fb02ba9675585078710969d3440f5054e0";
164     bytes32 internal constant Z_10 =
165         hex"f9dc3e7fe016e050eff260334f18a5d4fe391d82092319f5964f2e2eb7c1c3a5";
166     bytes32 internal constant Z_11 =
167         hex"f8b13a49e282f609c317a833fb8d976d11517c571d1221a265d25af778ecf892";
168     bytes32 internal constant Z_12 =
169         hex"3490c6ceeb450aecdc82e28293031d10c7d73bf85e57bf041a97360aa2c5d99c";
170     bytes32 internal constant Z_13 =
171         hex"c1df82d9c4b87413eae2ef048f94b4d3554cea73d92b0f7af96e0271c691e2bb";
172     bytes32 internal constant Z_14 =
173         hex"5c67add7c6caf302256adedf7ab114da0acfe870d449a3a489f781d659e8becc";
174     bytes32 internal constant Z_15 =
175         hex"da7bce9f4e8618b6bd2f4132ce798cdc7a60e7e1460a7299e3c6342a579626d2";
176     bytes32 internal constant Z_16 =
177         hex"2733e50f526ec2fa19a22b31e8ed50f23cd1fdf94c9154ed3a7609a2f1ff981f";
178     bytes32 internal constant Z_17 =
179         hex"e1d3b5c807b281e4683cc6d6315cf95b9ade8641defcb32372f1c126e398ef7a";
180     bytes32 internal constant Z_18 =
181         hex"5a2dce0a8a7f68bb74560f8f71837c2c2ebbcbf7fffb42ae1896f13f7c7479a0";
182     bytes32 internal constant Z_19 =
183         hex"b46a28b6f55540f89444f63de0378e3d121be09e06cc9ded1c20e65876d36aa0";
184     bytes32 internal constant Z_20 =
185         hex"c65e9645644786b620e2dd2ad648ddfcbf4a7e5b1a3a4ecfe7f64667a3f0b7e2";
186     bytes32 internal constant Z_21 =
187         hex"f4418588ed35a2458cffeb39b93d26f18d2ab13bdce6aee58e7b99359ec2dfd9";
188     bytes32 internal constant Z_22 =
189         hex"5a9c16dc00d6ef18b7933a6f8dc65ccb55667138776f7dea101070dc8796e377";
190     bytes32 internal constant Z_23 =
191         hex"4df84f40ae0c8229d0d6069e5c8f39a7c299677a09d367fc7b05e3bc380ee652";
192     bytes32 internal constant Z_24 =
193         hex"cdc72595f74c7b1043d0e1ffbab734648c838dfb0527d971b602bc216c9619ef";
194     bytes32 internal constant Z_25 =
195         hex"0abf5ac974a1ed57f4050aa510dd9c74f508277b39d7973bb2dfccc5eeb0618d";
196     bytes32 internal constant Z_26 =
197         hex"b8cd74046ff337f0a7bf2c8e03e10f642c1886798d71806ab1e888d9e5ee87d0";
198     bytes32 internal constant Z_27 =
199         hex"838c5655cb21c6cb83313b5a631175dff4963772cce9108188b34ac87c81c41e";
200     bytes32 internal constant Z_28 =
201         hex"662ee4dd2dd7b2bc707961b1e646c4047669dcb6584f0d8d770daf5d7e7deb2e";
202     bytes32 internal constant Z_29 =
203         hex"388ab20e2573d171a88108e79d820e98f26c0b84aa8b2f4aa4968dbb818ea322";
204     bytes32 internal constant Z_30 =
205         hex"93237c50ba75ee485f4c22adf2f741400bdf8d6a9cc7df7ecae576221665d735";
206     bytes32 internal constant Z_31 =
207         hex"8448818bb4ae4562849e949e17ac16e0be16688e156b5cf15e098c627c0056a9";
208 }
