1 // File: contracts/IOperatorFilterRegistry.sol
2 
3 //Abdullah Rangoonwala
4 
5 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⢴⠒⡖⢫⡙⣍⠫⢝⡒⡲⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 // ⠀⠀⠀⠀⠀⠀⠀⢀⣀⢤⠤⡤⢤⣀⠀⠀⠀⣠⠞⡍⡜⢢⡙⢌⠥⡒⢬⡘⢆⡱⢡⢣⠙⡶⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 // ⠀⠀⠀⠀⣀⡴⡚⢭⡘⢆⢓⡘⠆⣎⠳⣄⡞⠥⢋⠴⣨⣧⢾⣮⢶⣍⣦⡘⢢⡑⢎⣴⣩⣴⡽⢦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 // ⠀⠀⠀⣾⣵⣢⡙⢤⠚⡌⠦⣉⠞⡠⢍⢻⣌⠣⣍⡾⠋⠴⠁⠀⠀⠀⠉⠉⠉⠉⠉⠉⠁⠀⠈⠛⠓⠿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 // ⠀⠀⠀⠈⢧⠈⠙⣧⠾⣞⡓⠓⠺⣥⣊⠜⣧⢃⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣙⠲⠦⣄⠀⠀⠀⠀⠀⠀
10 // ⠀⠀⠀⠀⡼⠀⠀⢻⠐⢤⡀⠰⠖⠂⠹⡜⣧⢻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠷⣮⠒⢭⡘⢧⠀⠀⠀⠀⠀
11 // ⠀⠀⠀⠈⣗⠦⣄⣿⠸⡄⢽⠀⡐⢧⠀⡟⣼⡙⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡏⢰⢸⡝⣾⣃⠞⡇⠀⠀⠀⠀
12 // ⠀⠀⠀⢀⡇⠀⣸⣄⠳⣅⣈⣧⡀⠀⣾⡙⠼⣇⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠁⣠⡌⣿⢫⣧⠚⡇⠀⠀⠀⠀
13 // ⠀⠀⣤⠊⢀⡴⠛⢈⡟⢀⡏⢻⠈⠁⢹⡜⢢⣏⠾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠒⣉⣱⢦⠤⢤⣼⣄⣴⢃⠆⢠⢿⢩⡇⠀⠀⠀⠀
14 // ⡠⠔⣁⡽⣏⠠⣆⠀⣇⠸⡄⡎⢀⡼⣰⡋⢆⠫⡜⢿⡀⠀⠀⠀⠀⠀⢀⡴⠋⡥⣶⣾⠟⠂⠛⢿⣶⣤⡈⠻⡏⣦⢈⣾⢡⡇⠀⠀⠀⠀
15 // ⢻⡚⢭⡘⢻⡠⡄⠘⠞⢦⡵⠁⠠⣴⢣⡙⠬⡑⡜⢌⠷⣄⣀⣀⣀⣤⣾⡀⢺⣸⠟⡏⠀⠀⠀⠀⠻⠷⠃⢰⣇⠀⣸⡟⣼⠇⠀⠀⠀⠀
16 // ⠘⣏⠆⡜⡩⢷⡙⠀⢤⠃⡇⠸⠄⣿⠰⢌⢣⠱⡘⣌⠚⡤⢋⣭⠟⠚⠉⠉⠓⢦⠀⠹⡄⠀⠀⠀⠉⠳⡤⠟⠚⠮⢼⣇⡿⠀⠀⠀⠀⠀
17 // ⠀⠹⣎⠴⢡⢋⢷⣄⢬⡀⠄⠂⢀⡟⡱⢊⢆⢣⡑⢢⠍⣶⠋⠀⠀⠀⠀⠀⠀⠈⢧⠀⡗⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⢤⡀⠀⠀
18 // ⠀⠀⠘⢷⣅⢎⠢⣍⠳⣭⢤⡼⢫⠱⣡⢃⠎⢆⡜⣡⢺⡇⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠙⢦⠀
19 // ⠀⠀⠀⠀⠈⠓⠧⣬⡑⢆⠲⢌⢣⡑⠆⡎⢜⢢⠒⣤⢿⡇⠀⠀⠀⠀⠀⣠⣴⣖⠂⠀⠀⠀⠀⠀⠀⠀⠐⠉⢩⢶⣤⠀⢰⠋⠸⣇⢈⡇
20 // ⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠺⢬⡒⢬⠱⡘⡌⢆⡿⠁⠈⣧⠀⠀⠀⢀⡞⠁⠈⢻⣧⠀⠀⠀⠀⠀⠀⠀⠀⢠⠏⠈⣿⠀⢺⠀⠀⠙⠛⣧
21 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣦⠣⡱⢌⡿⠀⠀⠀⣿⠀⠀⠀⣾⠀⠀⠀⠀⣿⡆⠀⠀⠀⠀⢸⡄⠀⢸⠀⠀⢸⠀⠈⢧⠀⠀⠀⣿
22 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⠰⣑⢺⡇⠀⠀⠀⣿⠀⠀⠀⡇⠀⠀⠀⠀⣿⠀⠀⠀⠀⡄⢸⠇⠀⢸⠀⠀⠘⢆⣀⡼⠀⠀⢀⡟
23 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⡧⣸⠼⢷⡀⠀⠀⣿⠀⠀⠀⡇⠀⠀⠀⠀⡏⠀⠀⠀⠀⣏⡼⠀⢀⡞⠀⠀⠀⠀⠁⠀⠀⠀⣼⠁
24 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠈⠳⣄⠀⣿⠀⠀⠀⣷⠀⠀⠀⢸⡅⠀⠀⠀⠀⠉⢁⡴⠋⠀⠀⠀⠀⠀⠀⠀⢀⡾⠁⠀
25 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣿⡀⠀⠀⣿⠀⠀⠀⢸⡄⠀⠀⠀⠀⣰⠋⠀⠀⠀⠀⠀⠀⠀⣀⡶⠋⠀⠀⠀
26 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⡇⠀⠀⢿⡀⠀⠀⠀⢣⡄⡆⠀⢀⡇⠀⠀⠀⢀⣀⣤⡶⠟⠉⠀⠀⠀⠀⠀
27 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡄⠀⢸⠛⠓⠦⠦⠤⣼⡇⠀⢸⡷⠶⠿⠟⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀
28 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠦⠞⠀⠀⠀⠀⠀⠀⡇⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
29 // ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⣀⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
30 
31 
32 pragma solidity ^0.8.13;
33 
34 interface IOperatorFilterRegistry {
35     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
36     function register(address registrant) external;
37     function registerAndSubscribe(address registrant, address subscription) external;
38     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
39     function unregister(address addr) external;
40     function updateOperator(address registrant, address operator, bool filtered) external;
41     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
42     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
43     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
44     function subscribe(address registrant, address registrantToSubscribe) external;
45     function unsubscribe(address registrant, bool copyExistingEntries) external;
46     function subscriptionOf(address addr) external returns (address registrant);
47     function subscribers(address registrant) external returns (address[] memory);
48     function subscriberAt(address registrant, uint256 index) external returns (address);
49     function copyEntriesOf(address regsistrant, address registrantToCopy) external;
50     function isOperatorFiltered(address registrant, address operator) external returns (bool);
51     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
52     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
53     function filteredOperators(address addr) external returns (address[] memory);
54     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
55     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
56     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
57     function isRegistered(address addr) external returns (bool);
58     function codeHashOf(address addr) external returns (bytes32);
59 }
60 
61 // File: contracts/OperatorFilterer.sol
62 
63 
64 pragma solidity ^0.8.13;
65 
66 
67 /**
68  * @title  OperatorFilterer
69  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
70  *         registrant's entries in the OperatorFilterRegistry.
71  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
72  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
73  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
74  */
75 abstract contract OperatorFilterer {
76     error OperatorNotAllowed(address operator);
77 
78     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
79         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
80 
81     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
82         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
83         // will not revert, but the contract will need to be registered with the registry once it is deployed in
84         // order for the modifier to filter addresses.
85         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
86             if (subscribe) {
87                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
88             } else {
89                 if (subscriptionOrRegistrantToCopy != address(0)) {
90                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
91                 } else {
92                     OPERATOR_FILTER_REGISTRY.register(address(this));
93                 }
94             }
95         }
96     }
97 
98     modifier onlyAllowedOperator(address from) virtual {
99         // Allow spending tokens from addresses with balance
100         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
101         // from an EOA.
102         if (from != msg.sender) {
103             _checkFilterOperator(msg.sender);
104         }
105         _;
106     }
107 
108     modifier onlyAllowedOperatorApproval(address operator) virtual {
109         _checkFilterOperator(operator);
110         _;
111     }
112 
113     function _checkFilterOperator(address operator) internal view virtual {
114         // Check registry code length to facilitate testing in environments without a deployed registry.
115         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
116             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
117                 revert OperatorNotAllowed(operator);
118             }
119         }
120     }
121 }
122 
123 // File: contracts/DefaultOperatorFilterer.sol
124 
125 
126 pragma solidity ^0.8.13;
127 
128 
129 /**
130  * @title  DefaultOperatorFilterer
131  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
132  */
133 abstract contract DefaultOperatorFilterer is OperatorFilterer {
134     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
135 
136     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
137 }
138 
139 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
140 
141 
142 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev These functions deal with verification of Merkle Tree proofs.
148  *
149  * The tree and the proofs can be generated using our
150  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
151  * You will find a quickstart guide in the readme.
152  *
153  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
154  * hashing, or use a hash function other than keccak256 for hashing leaves.
155  * This is because the concatenation of a sorted pair of internal nodes in
156  * the merkle tree could be reinterpreted as a leaf value.
157  * OpenZeppelin's JavaScript library generates merkle trees that are safe
158  * against this attack out of the box.
159  */
160 library MerkleProof {
161     /**
162      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
163      * defined by `root`. For this, a `proof` must be provided, containing
164      * sibling hashes on the branch from the leaf to the root of the tree. Each
165      * pair of leaves and each pair of pre-images are assumed to be sorted.
166      */
167     function verify(
168         bytes32[] memory proof,
169         bytes32 root,
170         bytes32 leaf
171     ) internal pure returns (bool) {
172         return processProof(proof, leaf) == root;
173     }
174 
175     /**
176      * @dev Calldata version of {verify}
177      *
178      * _Available since v4.7._
179      */
180     function verifyCalldata(
181         bytes32[] calldata proof,
182         bytes32 root,
183         bytes32 leaf
184     ) internal pure returns (bool) {
185         return processProofCalldata(proof, leaf) == root;
186     }
187 
188     /**
189      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
190      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
191      * hash matches the root of the tree. When processing the proof, the pairs
192      * of leafs & pre-images are assumed to be sorted.
193      *
194      * _Available since v4.4._
195      */
196     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
197         bytes32 computedHash = leaf;
198         for (uint256 i = 0; i < proof.length; i++) {
199             computedHash = _hashPair(computedHash, proof[i]);
200         }
201         return computedHash;
202     }
203 
204     /**
205      * @dev Calldata version of {processProof}
206      *
207      * _Available since v4.7._
208      */
209     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
210         bytes32 computedHash = leaf;
211         for (uint256 i = 0; i < proof.length; i++) {
212             computedHash = _hashPair(computedHash, proof[i]);
213         }
214         return computedHash;
215     }
216 
217     /**
218      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
219      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
220      *
221      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
222      *
223      * _Available since v4.7._
224      */
225     function multiProofVerify(
226         bytes32[] memory proof,
227         bool[] memory proofFlags,
228         bytes32 root,
229         bytes32[] memory leaves
230     ) internal pure returns (bool) {
231         return processMultiProof(proof, proofFlags, leaves) == root;
232     }
233 
234     /**
235      * @dev Calldata version of {multiProofVerify}
236      *
237      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
238      *
239      * _Available since v4.7._
240      */
241     function multiProofVerifyCalldata(
242         bytes32[] calldata proof,
243         bool[] calldata proofFlags,
244         bytes32 root,
245         bytes32[] memory leaves
246     ) internal pure returns (bool) {
247         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
248     }
249 
250     /**
251      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
252      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
253      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
254      * respectively.
255      *
256      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
257      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
258      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
259      *
260      * _Available since v4.7._
261      */
262     function processMultiProof(
263         bytes32[] memory proof,
264         bool[] memory proofFlags,
265         bytes32[] memory leaves
266     ) internal pure returns (bytes32 merkleRoot) {
267         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
268         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
269         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
270         // the merkle tree.
271         uint256 leavesLen = leaves.length;
272         uint256 totalHashes = proofFlags.length;
273 
274         // Check proof validity.
275         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
276 
277         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
278         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
279         bytes32[] memory hashes = new bytes32[](totalHashes);
280         uint256 leafPos = 0;
281         uint256 hashPos = 0;
282         uint256 proofPos = 0;
283         // At each step, we compute the next hash using two values:
284         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
285         //   get the next hash.
286         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
287         //   `proof` array.
288         for (uint256 i = 0; i < totalHashes; i++) {
289             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
290             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
291             hashes[i] = _hashPair(a, b);
292         }
293 
294         if (totalHashes > 0) {
295             return hashes[totalHashes - 1];
296         } else if (leavesLen > 0) {
297             return leaves[0];
298         } else {
299             return proof[0];
300         }
301     }
302 
303     /**
304      * @dev Calldata version of {processMultiProof}.
305      *
306      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
307      *
308      * _Available since v4.7._
309      */
310     function processMultiProofCalldata(
311         bytes32[] calldata proof,
312         bool[] calldata proofFlags,
313         bytes32[] memory leaves
314     ) internal pure returns (bytes32 merkleRoot) {
315         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
316         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
317         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
318         // the merkle tree.
319         uint256 leavesLen = leaves.length;
320         uint256 totalHashes = proofFlags.length;
321 
322         // Check proof validity.
323         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
324 
325         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
326         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
327         bytes32[] memory hashes = new bytes32[](totalHashes);
328         uint256 leafPos = 0;
329         uint256 hashPos = 0;
330         uint256 proofPos = 0;
331         // At each step, we compute the next hash using two values:
332         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
333         //   get the next hash.
334         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
335         //   `proof` array.
336         for (uint256 i = 0; i < totalHashes; i++) {
337             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
338             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
339             hashes[i] = _hashPair(a, b);
340         }
341 
342         if (totalHashes > 0) {
343             return hashes[totalHashes - 1];
344         } else if (leavesLen > 0) {
345             return leaves[0];
346         } else {
347             return proof[0];
348         }
349     }
350 
351     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
352         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
353     }
354 
355     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
356         /// @solidity memory-safe-assembly
357         assembly {
358             mstore(0x00, a)
359             mstore(0x20, b)
360             value := keccak256(0x00, 0x40)
361         }
362     }
363 }
364 
365 // File: erc721a/contracts/IERC721A.sol
366 
367 
368 // ERC721A Contracts v4.2.3
369 // Creator: Chiru Labs
370 
371 pragma solidity ^0.8.4;
372 
373 /**
374  * @dev Interface of ERC721A.
375  */
376 interface IERC721A {
377     /**
378      * The caller must own the token or be an approved operator.
379      */
380     error ApprovalCallerNotOwnerNorApproved();
381 
382     /**
383      * The token does not exist.
384      */
385     error ApprovalQueryForNonexistentToken();
386 
387     /**
388      * Cannot query the balance for the zero address.
389      */
390     error BalanceQueryForZeroAddress();
391 
392     /**
393      * Cannot mint to the zero address.
394      */
395     error MintToZeroAddress();
396 
397     /**
398      * The quantity of tokens minted must be more than zero.
399      */
400     error MintZeroQuantity();
401 
402     /**
403      * The token does not exist.
404      */
405     error OwnerQueryForNonexistentToken();
406 
407     /**
408      * The caller must own the token or be an approved operator.
409      */
410     error TransferCallerNotOwnerNorApproved();
411 
412     /**
413      * The token must be owned by `from`.
414      */
415     error TransferFromIncorrectOwner();
416 
417     /**
418      * Cannot safely transfer to a contract that does not implement the
419      * ERC721Receiver interface.
420      */
421     error TransferToNonERC721ReceiverImplementer();
422 
423     /**
424      * Cannot transfer to the zero address.
425      */
426     error TransferToZeroAddress();
427 
428     /**
429      * The token does not exist.
430      */
431     error URIQueryForNonexistentToken();
432 
433     /**
434      * The `quantity` minted with ERC2309 exceeds the safety limit.
435      */
436     error MintERC2309QuantityExceedsLimit();
437 
438     /**
439      * The `extraData` cannot be set on an unintialized ownership slot.
440      */
441     error OwnershipNotInitializedForExtraData();
442 
443     // =============================================================
444     //                            STRUCTS
445     // =============================================================
446 
447     struct TokenOwnership {
448         // The address of the owner.
449         address addr;
450         // Stores the start time of ownership with minimal overhead for tokenomics.
451         uint64 startTimestamp;
452         // Whether the token has been burned.
453         bool burned;
454         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
455         uint24 extraData;
456     }
457 
458     // =============================================================
459     //                         TOKEN COUNTERS
460     // =============================================================
461 
462     /**
463      * @dev Returns the total number of tokens in existence.
464      * Burned tokens will reduce the count.
465      * To get the total number of tokens minted, please see {_totalMinted}.
466      */
467     function totalSupply() external view returns (uint256);
468 
469     // =============================================================
470     //                            IERC165
471     // =============================================================
472 
473     /**
474      * @dev Returns true if this contract implements the interface defined by
475      * `interfaceId`. See the corresponding
476      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
477      * to learn more about how these ids are created.
478      *
479      * This function call must use less than 30000 gas.
480      */
481     function supportsInterface(bytes4 interfaceId) external view returns (bool);
482 
483     // =============================================================
484     //                            IERC721
485     // =============================================================
486 
487     /**
488      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
489      */
490     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
491 
492     /**
493      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
494      */
495     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
496 
497     /**
498      * @dev Emitted when `owner` enables or disables
499      * (`approved`) `operator` to manage all of its assets.
500      */
501     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
502 
503     /**
504      * @dev Returns the number of tokens in `owner`'s account.
505      */
506     function balanceOf(address owner) external view returns (uint256 balance);
507 
508     /**
509      * @dev Returns the owner of the `tokenId` token.
510      *
511      * Requirements:
512      *
513      * - `tokenId` must exist.
514      */
515     function ownerOf(uint256 tokenId) external view returns (address owner);
516 
517     /**
518      * @dev Safely transfers `tokenId` token from `from` to `to`,
519      * checking first that contract recipients are aware of the ERC721 protocol
520      * to prevent tokens from being forever locked.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must exist and be owned by `from`.
527      * - If the caller is not `from`, it must be have been allowed to move
528      * this token by either {approve} or {setApprovalForAll}.
529      * - If `to` refers to a smart contract, it must implement
530      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
531      *
532      * Emits a {Transfer} event.
533      */
534     function safeTransferFrom(
535         address from,
536         address to,
537         uint256 tokenId,
538         bytes calldata data
539     ) external payable;
540 
541     /**
542      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
543      */
544     function safeTransferFrom(
545         address from,
546         address to,
547         uint256 tokenId
548     ) external payable;
549 
550     /**
551      * @dev Transfers `tokenId` from `from` to `to`.
552      *
553      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
554      * whenever possible.
555      *
556      * Requirements:
557      *
558      * - `from` cannot be the zero address.
559      * - `to` cannot be the zero address.
560      * - `tokenId` token must be owned by `from`.
561      * - If the caller is not `from`, it must be approved to move this token
562      * by either {approve} or {setApprovalForAll}.
563      *
564      * Emits a {Transfer} event.
565      */
566     function transferFrom(
567         address from,
568         address to,
569         uint256 tokenId
570     ) external payable;
571 
572     /**
573      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
574      * The approval is cleared when the token is transferred.
575      *
576      * Only a single account can be approved at a time, so approving the
577      * zero address clears previous approvals.
578      *
579      * Requirements:
580      *
581      * - The caller must own the token or be an approved operator.
582      * - `tokenId` must exist.
583      *
584      * Emits an {Approval} event.
585      */
586     function approve(address to, uint256 tokenId) external payable;
587 
588     /**
589      * @dev Approve or remove `operator` as an operator for the caller.
590      * Operators can call {transferFrom} or {safeTransferFrom}
591      * for any token owned by the caller.
592      *
593      * Requirements:
594      *
595      * - The `operator` cannot be the caller.
596      *
597      * Emits an {ApprovalForAll} event.
598      */
599     function setApprovalForAll(address operator, bool _approved) external;
600 
601     /**
602      * @dev Returns the account approved for `tokenId` token.
603      *
604      * Requirements:
605      *
606      * - `tokenId` must exist.
607      */
608     function getApproved(uint256 tokenId) external view returns (address operator);
609 
610     /**
611      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
612      *
613      * See {setApprovalForAll}.
614      */
615     function isApprovedForAll(address owner, address operator) external view returns (bool);
616 
617     // =============================================================
618     //                        IERC721Metadata
619     // =============================================================
620 
621     /**
622      * @dev Returns the token collection name.
623      */
624     function name() external view returns (string memory);
625 
626     /**
627      * @dev Returns the token collection symbol.
628      */
629     function symbol() external view returns (string memory);
630 
631     /**
632      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
633      */
634     function tokenURI(uint256 tokenId) external view returns (string memory);
635 
636     // =============================================================
637     //                           IERC2309
638     // =============================================================
639 
640     /**
641      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
642      * (inclusive) is transferred from `from` to `to`, as defined in the
643      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
644      *
645      * See {_mintERC2309} for more details.
646      */
647     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
648 }
649 
650 // File: erc721a/contracts/ERC721A.sol
651 
652 
653 // ERC721A Contracts v4.2.3
654 // Creator: Chiru Labs
655 
656 pragma solidity ^0.8.4;
657 
658 
659 /**
660  * @dev Interface of ERC721 token receiver.
661  */
662 interface ERC721A__IERC721Receiver {
663     function onERC721Received(
664         address operator,
665         address from,
666         uint256 tokenId,
667         bytes calldata data
668     ) external returns (bytes4);
669 }
670 
671 /**
672  * @title ERC721A
673  *
674  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
675  * Non-Fungible Token Standard, including the Metadata extension.
676  * Optimized for lower gas during batch mints.
677  *
678  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
679  * starting from `_startTokenId()`.
680  *
681  * Assumptions:
682  *
683  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
684  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
685  */
686 contract ERC721A is IERC721A {
687     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
688     struct TokenApprovalRef {
689         address value;
690     }
691 
692     // =============================================================
693     //                           CONSTANTS
694     // =============================================================
695 
696     // Mask of an entry in packed address data.
697     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
698 
699     // The bit position of `numberMinted` in packed address data.
700     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
701 
702     // The bit position of `numberBurned` in packed address data.
703     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
704 
705     // The bit position of `aux` in packed address data.
706     uint256 private constant _BITPOS_AUX = 192;
707 
708     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
709     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
710 
711     // The bit position of `startTimestamp` in packed ownership.
712     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
713 
714     // The bit mask of the `burned` bit in packed ownership.
715     uint256 private constant _BITMASK_BURNED = 1 << 224;
716 
717     // The bit position of the `nextInitialized` bit in packed ownership.
718     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
719 
720     // The bit mask of the `nextInitialized` bit in packed ownership.
721     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
722 
723     // The bit position of `extraData` in packed ownership.
724     uint256 private constant _BITPOS_EXTRA_DATA = 232;
725 
726     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
727     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
728 
729     // The mask of the lower 160 bits for addresses.
730     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
731 
732     // The maximum `quantity` that can be minted with {_mintERC2309}.
733     // This limit is to prevent overflows on the address data entries.
734     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
735     // is required to cause an overflow, which is unrealistic.
736     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
737 
738     // The `Transfer` event signature is given by:
739     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
740     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
741         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
742 
743     // =============================================================
744     //                            STORAGE
745     // =============================================================
746 
747     // The next token ID to be minted.
748     uint256 private _currentIndex;
749 
750     // The number of tokens burned.
751     uint256 private _burnCounter;
752 
753     // Token name
754     string private _name;
755 
756     // Token symbol
757     string private _symbol;
758 
759     // Mapping from token ID to ownership details
760     // An empty struct value does not necessarily mean the token is unowned.
761     // See {_packedOwnershipOf} implementation for details.
762     //
763     // Bits Layout:
764     // - [0..159]   `addr`
765     // - [160..223] `startTimestamp`
766     // - [224]      `burned`
767     // - [225]      `nextInitialized`
768     // - [232..255] `extraData`
769     mapping(uint256 => uint256) private _packedOwnerships;
770 
771     // Mapping owner address to address data.
772     //
773     // Bits Layout:
774     // - [0..63]    `balance`
775     // - [64..127]  `numberMinted`
776     // - [128..191] `numberBurned`
777     // - [192..255] `aux`
778     mapping(address => uint256) private _packedAddressData;
779 
780     // Mapping from token ID to approved address.
781     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
782 
783     // Mapping from owner to operator approvals
784     mapping(address => mapping(address => bool)) private _operatorApprovals;
785 
786     // =============================================================
787     //                          CONSTRUCTOR
788     // =============================================================
789 
790     constructor(string memory name_, string memory symbol_) {
791         _name = name_;
792         _symbol = symbol_;
793         _currentIndex = _startTokenId();
794     }
795 
796     // =============================================================
797     //                   TOKEN COUNTING OPERATIONS
798     // =============================================================
799 
800     /**
801      * @dev Returns the starting token ID.
802      * To change the starting token ID, please override this function.
803      */
804     function _startTokenId() internal view virtual returns (uint256) {
805         return 0;
806     }
807 
808     /**
809      * @dev Returns the next token ID to be minted.
810      */
811     function _nextTokenId() internal view virtual returns (uint256) {
812         return _currentIndex;
813     }
814 
815     /**
816      * @dev Returns the total number of tokens in existence.
817      * Burned tokens will reduce the count.
818      * To get the total number of tokens minted, please see {_totalMinted}.
819      */
820     function totalSupply() public view virtual override returns (uint256) {
821         // Counter underflow is impossible as _burnCounter cannot be incremented
822         // more than `_currentIndex - _startTokenId()` times.
823         unchecked {
824             return _currentIndex - _burnCounter - _startTokenId();
825         }
826     }
827 
828     /**
829      * @dev Returns the total amount of tokens minted in the contract.
830      */
831     function _totalMinted() internal view virtual returns (uint256) {
832         // Counter underflow is impossible as `_currentIndex` does not decrement,
833         // and it is initialized to `_startTokenId()`.
834         unchecked {
835             return _currentIndex - _startTokenId();
836         }
837     }
838 
839     /**
840      * @dev Returns the total number of tokens burned.
841      */
842     function _totalBurned() internal view virtual returns (uint256) {
843         return _burnCounter;
844     }
845 
846     // =============================================================
847     //                    ADDRESS DATA OPERATIONS
848     // =============================================================
849 
850     /**
851      * @dev Returns the number of tokens in `owner`'s account.
852      */
853     function balanceOf(address owner) public view virtual override returns (uint256) {
854         if (owner == address(0)) revert BalanceQueryForZeroAddress();
855         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
856     }
857 
858     /**
859      * Returns the number of tokens minted by `owner`.
860      */
861     function _numberMinted(address owner) internal view returns (uint256) {
862         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
863     }
864 
865     /**
866      * Returns the number of tokens burned by or on behalf of `owner`.
867      */
868     function _numberBurned(address owner) internal view returns (uint256) {
869         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
870     }
871 
872     /**
873      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
874      */
875     function _getAux(address owner) internal view returns (uint64) {
876         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
877     }
878 
879     /**
880      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
881      * If there are multiple variables, please pack them into a uint64.
882      */
883     function _setAux(address owner, uint64 aux) internal virtual {
884         uint256 packed = _packedAddressData[owner];
885         uint256 auxCasted;
886         // Cast `aux` with assembly to avoid redundant masking.
887         assembly {
888             auxCasted := aux
889         }
890         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
891         _packedAddressData[owner] = packed;
892     }
893 
894     // =============================================================
895     //                            IERC165
896     // =============================================================
897 
898     /**
899      * @dev Returns true if this contract implements the interface defined by
900      * `interfaceId`. See the corresponding
901      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
902      * to learn more about how these ids are created.
903      *
904      * This function call must use less than 30000 gas.
905      */
906     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
907         // The interface IDs are constants representing the first 4 bytes
908         // of the XOR of all function selectors in the interface.
909         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
910         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
911         return
912             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
913             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
914             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
915     }
916 
917     // =============================================================
918     //                        IERC721Metadata
919     // =============================================================
920 
921     /**
922      * @dev Returns the token collection name.
923      */
924     function name() public view virtual override returns (string memory) {
925         return _name;
926     }
927 
928     /**
929      * @dev Returns the token collection symbol.
930      */
931     function symbol() public view virtual override returns (string memory) {
932         return _symbol;
933     }
934 
935     /**
936      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
937      */
938     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
939         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
940 
941         string memory baseURI = _baseURI();
942         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
943     }
944 
945     /**
946      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
947      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
948      * by default, it can be overridden in child contracts.
949      */
950     function _baseURI() internal view virtual returns (string memory) {
951         return '';
952     }
953 
954     // =============================================================
955     //                     OWNERSHIPS OPERATIONS
956     // =============================================================
957 
958     /**
959      * @dev Returns the owner of the `tokenId` token.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must exist.
964      */
965     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
966         return address(uint160(_packedOwnershipOf(tokenId)));
967     }
968 
969     /**
970      * @dev Gas spent here starts off proportional to the maximum mint batch size.
971      * It gradually moves to O(1) as tokens get transferred around over time.
972      */
973     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
974         return _unpackedOwnership(_packedOwnershipOf(tokenId));
975     }
976 
977     /**
978      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
979      */
980     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
981         return _unpackedOwnership(_packedOwnerships[index]);
982     }
983 
984     /**
985      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
986      */
987     function _initializeOwnershipAt(uint256 index) internal virtual {
988         if (_packedOwnerships[index] == 0) {
989             _packedOwnerships[index] = _packedOwnershipOf(index);
990         }
991     }
992 
993     /**
994      * Returns the packed ownership data of `tokenId`.
995      */
996     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
997         uint256 curr = tokenId;
998 
999         unchecked {
1000             if (_startTokenId() <= curr)
1001                 if (curr < _currentIndex) {
1002                     uint256 packed = _packedOwnerships[curr];
1003                     // If not burned.
1004                     if (packed & _BITMASK_BURNED == 0) {
1005                         // Invariant:
1006                         // There will always be an initialized ownership slot
1007                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1008                         // before an unintialized ownership slot
1009                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1010                         // Hence, `curr` will not underflow.
1011                         //
1012                         // We can directly compare the packed value.
1013                         // If the address is zero, packed will be zero.
1014                         while (packed == 0) {
1015                             packed = _packedOwnerships[--curr];
1016                         }
1017                         return packed;
1018                     }
1019                 }
1020         }
1021         revert OwnerQueryForNonexistentToken();
1022     }
1023 
1024     /**
1025      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1026      */
1027     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1028         ownership.addr = address(uint160(packed));
1029         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1030         ownership.burned = packed & _BITMASK_BURNED != 0;
1031         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1032     }
1033 
1034     /**
1035      * @dev Packs ownership data into a single uint256.
1036      */
1037     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1038         assembly {
1039             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1040             owner := and(owner, _BITMASK_ADDRESS)
1041             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1042             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1043         }
1044     }
1045 
1046     /**
1047      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1048      */
1049     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1050         // For branchless setting of the `nextInitialized` flag.
1051         assembly {
1052             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1053             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1054         }
1055     }
1056 
1057     // =============================================================
1058     //                      APPROVAL OPERATIONS
1059     // =============================================================
1060 
1061     /**
1062      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1063      * The approval is cleared when the token is transferred.
1064      *
1065      * Only a single account can be approved at a time, so approving the
1066      * zero address clears previous approvals.
1067      *
1068      * Requirements:
1069      *
1070      * - The caller must own the token or be an approved operator.
1071      * - `tokenId` must exist.
1072      *
1073      * Emits an {Approval} event.
1074      */
1075     function approve(address to, uint256 tokenId) public payable virtual override {
1076         address owner = ownerOf(tokenId);
1077 
1078         if (_msgSenderERC721A() != owner)
1079             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1080                 revert ApprovalCallerNotOwnerNorApproved();
1081             }
1082 
1083         _tokenApprovals[tokenId].value = to;
1084         emit Approval(owner, to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev Returns the account approved for `tokenId` token.
1089      *
1090      * Requirements:
1091      *
1092      * - `tokenId` must exist.
1093      */
1094     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1095         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1096 
1097         return _tokenApprovals[tokenId].value;
1098     }
1099 
1100     /**
1101      * @dev Approve or remove `operator` as an operator for the caller.
1102      * Operators can call {transferFrom} or {safeTransferFrom}
1103      * for any token owned by the caller.
1104      *
1105      * Requirements:
1106      *
1107      * - The `operator` cannot be the caller.
1108      *
1109      * Emits an {ApprovalForAll} event.
1110      */
1111     function setApprovalForAll(address operator, bool approved) public virtual override {
1112         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1113         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1114     }
1115 
1116     /**
1117      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1118      *
1119      * See {setApprovalForAll}.
1120      */
1121     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1122         return _operatorApprovals[owner][operator];
1123     }
1124 
1125     /**
1126      * @dev Returns whether `tokenId` exists.
1127      *
1128      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1129      *
1130      * Tokens start existing when they are minted. See {_mint}.
1131      */
1132     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1133         return
1134             _startTokenId() <= tokenId &&
1135             tokenId < _currentIndex && // If within bounds,
1136             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1137     }
1138 
1139     /**
1140      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1141      */
1142     function _isSenderApprovedOrOwner(
1143         address approvedAddress,
1144         address owner,
1145         address msgSender
1146     ) private pure returns (bool result) {
1147         assembly {
1148             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1149             owner := and(owner, _BITMASK_ADDRESS)
1150             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1151             msgSender := and(msgSender, _BITMASK_ADDRESS)
1152             // `msgSender == owner || msgSender == approvedAddress`.
1153             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1154         }
1155     }
1156 
1157     /**
1158      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1159      */
1160     function _getApprovedSlotAndAddress(uint256 tokenId)
1161         private
1162         view
1163         returns (uint256 approvedAddressSlot, address approvedAddress)
1164     {
1165         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1166         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1167         assembly {
1168             approvedAddressSlot := tokenApproval.slot
1169             approvedAddress := sload(approvedAddressSlot)
1170         }
1171     }
1172 
1173     // =============================================================
1174     //                      TRANSFER OPERATIONS
1175     // =============================================================
1176 
1177     /**
1178      * @dev Transfers `tokenId` from `from` to `to`.
1179      *
1180      * Requirements:
1181      *
1182      * - `from` cannot be the zero address.
1183      * - `to` cannot be the zero address.
1184      * - `tokenId` token must be owned by `from`.
1185      * - If the caller is not `from`, it must be approved to move this token
1186      * by either {approve} or {setApprovalForAll}.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function transferFrom(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) public payable virtual override {
1195         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1196 
1197         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1198 
1199         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1200 
1201         // The nested ifs save around 20+ gas over a compound boolean condition.
1202         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1203             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1204 
1205         if (to == address(0)) revert TransferToZeroAddress();
1206 
1207         _beforeTokenTransfers(from, to, tokenId, 1);
1208 
1209         // Clear approvals from the previous owner.
1210         assembly {
1211             if approvedAddress {
1212                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1213                 sstore(approvedAddressSlot, 0)
1214             }
1215         }
1216 
1217         // Underflow of the sender's balance is impossible because we check for
1218         // ownership above and the recipient's balance can't realistically overflow.
1219         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1220         unchecked {
1221             // We can directly increment and decrement the balances.
1222             --_packedAddressData[from]; // Updates: `balance -= 1`.
1223             ++_packedAddressData[to]; // Updates: `balance += 1`.
1224 
1225             // Updates:
1226             // - `address` to the next owner.
1227             // - `startTimestamp` to the timestamp of transfering.
1228             // - `burned` to `false`.
1229             // - `nextInitialized` to `true`.
1230             _packedOwnerships[tokenId] = _packOwnershipData(
1231                 to,
1232                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1233             );
1234 
1235             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1236             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1237                 uint256 nextTokenId = tokenId + 1;
1238                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1239                 if (_packedOwnerships[nextTokenId] == 0) {
1240                     // If the next slot is within bounds.
1241                     if (nextTokenId != _currentIndex) {
1242                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1243                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1244                     }
1245                 }
1246             }
1247         }
1248 
1249         emit Transfer(from, to, tokenId);
1250         _afterTokenTransfers(from, to, tokenId, 1);
1251     }
1252 
1253     /**
1254      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1255      */
1256     function safeTransferFrom(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) public payable virtual override {
1261         safeTransferFrom(from, to, tokenId, '');
1262     }
1263 
1264     /**
1265      * @dev Safely transfers `tokenId` token from `from` to `to`.
1266      *
1267      * Requirements:
1268      *
1269      * - `from` cannot be the zero address.
1270      * - `to` cannot be the zero address.
1271      * - `tokenId` token must exist and be owned by `from`.
1272      * - If the caller is not `from`, it must be approved to move this token
1273      * by either {approve} or {setApprovalForAll}.
1274      * - If `to` refers to a smart contract, it must implement
1275      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function safeTransferFrom(
1280         address from,
1281         address to,
1282         uint256 tokenId,
1283         bytes memory _data
1284     ) public payable virtual override {
1285         transferFrom(from, to, tokenId);
1286         if (to.code.length != 0)
1287             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1288                 revert TransferToNonERC721ReceiverImplementer();
1289             }
1290     }
1291 
1292     /**
1293      * @dev Hook that is called before a set of serially-ordered token IDs
1294      * are about to be transferred. This includes minting.
1295      * And also called before burning one token.
1296      *
1297      * `startTokenId` - the first token ID to be transferred.
1298      * `quantity` - the amount to be transferred.
1299      *
1300      * Calling conditions:
1301      *
1302      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1303      * transferred to `to`.
1304      * - When `from` is zero, `tokenId` will be minted for `to`.
1305      * - When `to` is zero, `tokenId` will be burned by `from`.
1306      * - `from` and `to` are never both zero.
1307      */
1308     function _beforeTokenTransfers(
1309         address from,
1310         address to,
1311         uint256 startTokenId,
1312         uint256 quantity
1313     ) internal virtual {}
1314 
1315     /**
1316      * @dev Hook that is called after a set of serially-ordered token IDs
1317      * have been transferred. This includes minting.
1318      * And also called after one token has been burned.
1319      *
1320      * `startTokenId` - the first token ID to be transferred.
1321      * `quantity` - the amount to be transferred.
1322      *
1323      * Calling conditions:
1324      *
1325      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1326      * transferred to `to`.
1327      * - When `from` is zero, `tokenId` has been minted for `to`.
1328      * - When `to` is zero, `tokenId` has been burned by `from`.
1329      * - `from` and `to` are never both zero.
1330      */
1331     function _afterTokenTransfers(
1332         address from,
1333         address to,
1334         uint256 startTokenId,
1335         uint256 quantity
1336     ) internal virtual {}
1337 
1338     /**
1339      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1340      *
1341      * `from` - Previous owner of the given token ID.
1342      * `to` - Target address that will receive the token.
1343      * `tokenId` - Token ID to be transferred.
1344      * `_data` - Optional data to send along with the call.
1345      *
1346      * Returns whether the call correctly returned the expected magic value.
1347      */
1348     function _checkContractOnERC721Received(
1349         address from,
1350         address to,
1351         uint256 tokenId,
1352         bytes memory _data
1353     ) private returns (bool) {
1354         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1355             bytes4 retval
1356         ) {
1357             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1358         } catch (bytes memory reason) {
1359             if (reason.length == 0) {
1360                 revert TransferToNonERC721ReceiverImplementer();
1361             } else {
1362                 assembly {
1363                     revert(add(32, reason), mload(reason))
1364                 }
1365             }
1366         }
1367     }
1368 
1369     // =============================================================
1370     //                        MINT OPERATIONS
1371     // =============================================================
1372 
1373     /**
1374      * @dev Mints `quantity` tokens and transfers them to `to`.
1375      *
1376      * Requirements:
1377      *
1378      * - `to` cannot be the zero address.
1379      * - `quantity` must be greater than 0.
1380      *
1381      * Emits a {Transfer} event for each mint.
1382      */
1383     function _mint(address to, uint256 quantity) internal virtual {
1384         uint256 startTokenId = _currentIndex;
1385         if (quantity == 0) revert MintZeroQuantity();
1386 
1387         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1388 
1389         // Overflows are incredibly unrealistic.
1390         // `balance` and `numberMinted` have a maximum limit of 2**64.
1391         // `tokenId` has a maximum limit of 2**256.
1392         unchecked {
1393             // Updates:
1394             // - `balance += quantity`.
1395             // - `numberMinted += quantity`.
1396             //
1397             // We can directly add to the `balance` and `numberMinted`.
1398             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1399 
1400             // Updates:
1401             // - `address` to the owner.
1402             // - `startTimestamp` to the timestamp of minting.
1403             // - `burned` to `false`.
1404             // - `nextInitialized` to `quantity == 1`.
1405             _packedOwnerships[startTokenId] = _packOwnershipData(
1406                 to,
1407                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1408             );
1409 
1410             uint256 toMasked;
1411             uint256 end = startTokenId + quantity;
1412 
1413             // Use assembly to loop and emit the `Transfer` event for gas savings.
1414             // The duplicated `log4` removes an extra check and reduces stack juggling.
1415             // The assembly, together with the surrounding Solidity code, have been
1416             // delicately arranged to nudge the compiler into producing optimized opcodes.
1417             assembly {
1418                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1419                 toMasked := and(to, _BITMASK_ADDRESS)
1420                 // Emit the `Transfer` event.
1421                 log4(
1422                     0, // Start of data (0, since no data).
1423                     0, // End of data (0, since no data).
1424                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1425                     0, // `address(0)`.
1426                     toMasked, // `to`.
1427                     startTokenId // `tokenId`.
1428                 )
1429 
1430                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1431                 // that overflows uint256 will make the loop run out of gas.
1432                 // The compiler will optimize the `iszero` away for performance.
1433                 for {
1434                     let tokenId := add(startTokenId, 1)
1435                 } iszero(eq(tokenId, end)) {
1436                     tokenId := add(tokenId, 1)
1437                 } {
1438                     // Emit the `Transfer` event. Similar to above.
1439                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1440                 }
1441             }
1442             if (toMasked == 0) revert MintToZeroAddress();
1443 
1444             _currentIndex = end;
1445         }
1446         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1447     }
1448 
1449     /**
1450      * @dev Mints `quantity` tokens and transfers them to `to`.
1451      *
1452      * This function is intended for efficient minting only during contract creation.
1453      *
1454      * It emits only one {ConsecutiveTransfer} as defined in
1455      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1456      * instead of a sequence of {Transfer} event(s).
1457      *
1458      * Calling this function outside of contract creation WILL make your contract
1459      * non-compliant with the ERC721 standard.
1460      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1461      * {ConsecutiveTransfer} event is only permissible during contract creation.
1462      *
1463      * Requirements:
1464      *
1465      * - `to` cannot be the zero address.
1466      * - `quantity` must be greater than 0.
1467      *
1468      * Emits a {ConsecutiveTransfer} event.
1469      */
1470     function _mintERC2309(address to, uint256 quantity) internal virtual {
1471         uint256 startTokenId = _currentIndex;
1472         if (to == address(0)) revert MintToZeroAddress();
1473         if (quantity == 0) revert MintZeroQuantity();
1474         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1475 
1476         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1477 
1478         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1479         unchecked {
1480             // Updates:
1481             // - `balance += quantity`.
1482             // - `numberMinted += quantity`.
1483             //
1484             // We can directly add to the `balance` and `numberMinted`.
1485             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1486 
1487             // Updates:
1488             // - `address` to the owner.
1489             // - `startTimestamp` to the timestamp of minting.
1490             // - `burned` to `false`.
1491             // - `nextInitialized` to `quantity == 1`.
1492             _packedOwnerships[startTokenId] = _packOwnershipData(
1493                 to,
1494                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1495             );
1496 
1497             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1498 
1499             _currentIndex = startTokenId + quantity;
1500         }
1501         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1502     }
1503 
1504     /**
1505      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1506      *
1507      * Requirements:
1508      *
1509      * - If `to` refers to a smart contract, it must implement
1510      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1511      * - `quantity` must be greater than 0.
1512      *
1513      * See {_mint}.
1514      *
1515      * Emits a {Transfer} event for each mint.
1516      */
1517     function _safeMint(
1518         address to,
1519         uint256 quantity,
1520         bytes memory _data
1521     ) internal virtual {
1522         _mint(to, quantity);
1523 
1524         unchecked {
1525             if (to.code.length != 0) {
1526                 uint256 end = _currentIndex;
1527                 uint256 index = end - quantity;
1528                 do {
1529                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1530                         revert TransferToNonERC721ReceiverImplementer();
1531                     }
1532                 } while (index < end);
1533                 // Reentrancy protection.
1534                 if (_currentIndex != end) revert();
1535             }
1536         }
1537     }
1538 
1539     /**
1540      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1541      */
1542     function _safeMint(address to, uint256 quantity) internal virtual {
1543         _safeMint(to, quantity, '');
1544     }
1545 
1546     // =============================================================
1547     //                        BURN OPERATIONS
1548     // =============================================================
1549 
1550     /**
1551      * @dev Equivalent to `_burn(tokenId, false)`.
1552      */
1553     function _burn(uint256 tokenId) internal virtual {
1554         _burn(tokenId, false);
1555     }
1556 
1557     /**
1558      * @dev Destroys `tokenId`.
1559      * The approval is cleared when the token is burned.
1560      *
1561      * Requirements:
1562      *
1563      * - `tokenId` must exist.
1564      *
1565      * Emits a {Transfer} event.
1566      */
1567     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1568         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1569 
1570         address from = address(uint160(prevOwnershipPacked));
1571 
1572         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1573 
1574         if (approvalCheck) {
1575             // The nested ifs save around 20+ gas over a compound boolean condition.
1576             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1577                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1578         }
1579 
1580         _beforeTokenTransfers(from, address(0), tokenId, 1);
1581 
1582         // Clear approvals from the previous owner.
1583         assembly {
1584             if approvedAddress {
1585                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1586                 sstore(approvedAddressSlot, 0)
1587             }
1588         }
1589 
1590         // Underflow of the sender's balance is impossible because we check for
1591         // ownership above and the recipient's balance can't realistically overflow.
1592         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1593         unchecked {
1594             // Updates:
1595             // - `balance -= 1`.
1596             // - `numberBurned += 1`.
1597             //
1598             // We can directly decrement the balance, and increment the number burned.
1599             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1600             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1601 
1602             // Updates:
1603             // - `address` to the last owner.
1604             // - `startTimestamp` to the timestamp of burning.
1605             // - `burned` to `true`.
1606             // - `nextInitialized` to `true`.
1607             _packedOwnerships[tokenId] = _packOwnershipData(
1608                 from,
1609                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1610             );
1611 
1612             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1613             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1614                 uint256 nextTokenId = tokenId + 1;
1615                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1616                 if (_packedOwnerships[nextTokenId] == 0) {
1617                     // If the next slot is within bounds.
1618                     if (nextTokenId != _currentIndex) {
1619                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1620                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1621                     }
1622                 }
1623             }
1624         }
1625 
1626         emit Transfer(from, address(0), tokenId);
1627         _afterTokenTransfers(from, address(0), tokenId, 1);
1628 
1629         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1630         unchecked {
1631             _burnCounter++;
1632         }
1633     }
1634 
1635     // =============================================================
1636     //                     EXTRA DATA OPERATIONS
1637     // =============================================================
1638 
1639     /**
1640      * @dev Directly sets the extra data for the ownership data `index`.
1641      */
1642     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1643         uint256 packed = _packedOwnerships[index];
1644         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1645         uint256 extraDataCasted;
1646         // Cast `extraData` with assembly to avoid redundant masking.
1647         assembly {
1648             extraDataCasted := extraData
1649         }
1650         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1651         _packedOwnerships[index] = packed;
1652     }
1653 
1654     /**
1655      * @dev Called during each token transfer to set the 24bit `extraData` field.
1656      * Intended to be overridden by the cosumer contract.
1657      *
1658      * `previousExtraData` - the value of `extraData` before transfer.
1659      *
1660      * Calling conditions:
1661      *
1662      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1663      * transferred to `to`.
1664      * - When `from` is zero, `tokenId` will be minted for `to`.
1665      * - When `to` is zero, `tokenId` will be burned by `from`.
1666      * - `from` and `to` are never both zero.
1667      */
1668     function _extraData(
1669         address from,
1670         address to,
1671         uint24 previousExtraData
1672     ) internal view virtual returns (uint24) {}
1673 
1674     /**
1675      * @dev Returns the next extra data for the packed ownership data.
1676      * The returned result is shifted into position.
1677      */
1678     function _nextExtraData(
1679         address from,
1680         address to,
1681         uint256 prevOwnershipPacked
1682     ) private view returns (uint256) {
1683         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1684         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1685     }
1686 
1687     // =============================================================
1688     //                       OTHER OPERATIONS
1689     // =============================================================
1690 
1691     /**
1692      * @dev Returns the message sender (defaults to `msg.sender`).
1693      *
1694      * If you are writing GSN compatible contracts, you need to override this function.
1695      */
1696     function _msgSenderERC721A() internal view virtual returns (address) {
1697         return msg.sender;
1698     }
1699 
1700     /**
1701      * @dev Converts a uint256 to its ASCII string decimal representation.
1702      */
1703     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1704         assembly {
1705             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1706             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1707             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1708             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1709             let m := add(mload(0x40), 0xa0)
1710             // Update the free memory pointer to allocate.
1711             mstore(0x40, m)
1712             // Assign the `str` to the end.
1713             str := sub(m, 0x20)
1714             // Zeroize the slot after the string.
1715             mstore(str, 0)
1716 
1717             // Cache the end of the memory to calculate the length later.
1718             let end := str
1719 
1720             // We write the string from rightmost digit to leftmost digit.
1721             // The following is essentially a do-while loop that also handles the zero case.
1722             // prettier-ignore
1723             for { let temp := value } 1 {} {
1724                 str := sub(str, 1)
1725                 // Write the character to the pointer.
1726                 // The ASCII index of the '0' character is 48.
1727                 mstore8(str, add(48, mod(temp, 10)))
1728                 // Keep dividing `temp` until zero.
1729                 temp := div(temp, 10)
1730                 // prettier-ignore
1731                 if iszero(temp) { break }
1732             }
1733 
1734             let length := sub(end, str)
1735             // Move the pointer 32 bytes leftwards to make room for the length.
1736             str := sub(str, 0x20)
1737             // Store the length.
1738             mstore(str, length)
1739         }
1740     }
1741 }
1742 
1743 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1744 
1745 
1746 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1747 
1748 pragma solidity ^0.8.0;
1749 
1750 // CAUTION
1751 // This version of SafeMath should only be used with Solidity 0.8 or later,
1752 // because it relies on the compiler's built in overflow checks.
1753 
1754 /**
1755  * @dev Wrappers over Solidity's arithmetic operations.
1756  *
1757  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1758  * now has built in overflow checking.
1759  */
1760 library SafeMath {
1761     /**
1762      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1763      *
1764      * _Available since v3.4._
1765      */
1766     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1767         unchecked {
1768             uint256 c = a + b;
1769             if (c < a) return (false, 0);
1770             return (true, c);
1771         }
1772     }
1773 
1774     /**
1775      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1776      *
1777      * _Available since v3.4._
1778      */
1779     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1780         unchecked {
1781             if (b > a) return (false, 0);
1782             return (true, a - b);
1783         }
1784     }
1785 
1786     /**
1787      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1788      *
1789      * _Available since v3.4._
1790      */
1791     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1792         unchecked {
1793             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1794             // benefit is lost if 'b' is also tested.
1795             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1796             if (a == 0) return (true, 0);
1797             uint256 c = a * b;
1798             if (c / a != b) return (false, 0);
1799             return (true, c);
1800         }
1801     }
1802 
1803     /**
1804      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1805      *
1806      * _Available since v3.4._
1807      */
1808     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1809         unchecked {
1810             if (b == 0) return (false, 0);
1811             return (true, a / b);
1812         }
1813     }
1814 
1815     /**
1816      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1817      *
1818      * _Available since v3.4._
1819      */
1820     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1821         unchecked {
1822             if (b == 0) return (false, 0);
1823             return (true, a % b);
1824         }
1825     }
1826 
1827     /**
1828      * @dev Returns the addition of two unsigned integers, reverting on
1829      * overflow.
1830      *
1831      * Counterpart to Solidity's `+` operator.
1832      *
1833      * Requirements:
1834      *
1835      * - Addition cannot overflow.
1836      */
1837     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1838         return a + b;
1839     }
1840 
1841     /**
1842      * @dev Returns the subtraction of two unsigned integers, reverting on
1843      * overflow (when the result is negative).
1844      *
1845      * Counterpart to Solidity's `-` operator.
1846      *
1847      * Requirements:
1848      *
1849      * - Subtraction cannot overflow.
1850      */
1851     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1852         return a - b;
1853     }
1854 
1855     /**
1856      * @dev Returns the multiplication of two unsigned integers, reverting on
1857      * overflow.
1858      *
1859      * Counterpart to Solidity's `*` operator.
1860      *
1861      * Requirements:
1862      *
1863      * - Multiplication cannot overflow.
1864      */
1865     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1866         return a * b;
1867     }
1868 
1869     /**
1870      * @dev Returns the integer division of two unsigned integers, reverting on
1871      * division by zero. The result is rounded towards zero.
1872      *
1873      * Counterpart to Solidity's `/` operator.
1874      *
1875      * Requirements:
1876      *
1877      * - The divisor cannot be zero.
1878      */
1879     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1880         return a / b;
1881     }
1882 
1883     /**
1884      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1885      * reverting when dividing by zero.
1886      *
1887      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1888      * opcode (which leaves remaining gas untouched) while Solidity uses an
1889      * invalid opcode to revert (consuming all remaining gas).
1890      *
1891      * Requirements:
1892      *
1893      * - The divisor cannot be zero.
1894      */
1895     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1896         return a % b;
1897     }
1898 
1899     /**
1900      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1901      * overflow (when the result is negative).
1902      *
1903      * CAUTION: This function is deprecated because it requires allocating memory for the error
1904      * message unnecessarily. For custom revert reasons use {trySub}.
1905      *
1906      * Counterpart to Solidity's `-` operator.
1907      *
1908      * Requirements:
1909      *
1910      * - Subtraction cannot overflow.
1911      */
1912     function sub(
1913         uint256 a,
1914         uint256 b,
1915         string memory errorMessage
1916     ) internal pure returns (uint256) {
1917         unchecked {
1918             require(b <= a, errorMessage);
1919             return a - b;
1920         }
1921     }
1922 
1923     /**
1924      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1925      * division by zero. The result is rounded towards zero.
1926      *
1927      * Counterpart to Solidity's `/` operator. Note: this function uses a
1928      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1929      * uses an invalid opcode to revert (consuming all remaining gas).
1930      *
1931      * Requirements:
1932      *
1933      * - The divisor cannot be zero.
1934      */
1935     function div(
1936         uint256 a,
1937         uint256 b,
1938         string memory errorMessage
1939     ) internal pure returns (uint256) {
1940         unchecked {
1941             require(b > 0, errorMessage);
1942             return a / b;
1943         }
1944     }
1945 
1946     /**
1947      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1948      * reverting with custom message when dividing by zero.
1949      *
1950      * CAUTION: This function is deprecated because it requires allocating memory for the error
1951      * message unnecessarily. For custom revert reasons use {tryMod}.
1952      *
1953      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1954      * opcode (which leaves remaining gas untouched) while Solidity uses an
1955      * invalid opcode to revert (consuming all remaining gas).
1956      *
1957      * Requirements:
1958      *
1959      * - The divisor cannot be zero.
1960      */
1961     function mod(
1962         uint256 a,
1963         uint256 b,
1964         string memory errorMessage
1965     ) internal pure returns (uint256) {
1966         unchecked {
1967             require(b > 0, errorMessage);
1968             return a % b;
1969         }
1970     }
1971 }
1972 
1973 // File: @openzeppelin/contracts/utils/Context.sol
1974 
1975 
1976 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1977 
1978 pragma solidity ^0.8.0;
1979 
1980 /**
1981  * @dev Provides information about the current execution context, including the
1982  * sender of the transaction and its data. While these are generally available
1983  * via msg.sender and msg.data, they should not be accessed in such a direct
1984  * manner, since when dealing with meta-transactions the account sending and
1985  * paying for execution may not be the actual sender (as far as an application
1986  * is concerned).
1987  *
1988  * This contract is only required for intermediate, library-like contracts.
1989  */
1990 abstract contract Context {
1991     function _msgSender() internal view virtual returns (address) {
1992         return msg.sender;
1993     }
1994 
1995     function _msgData() internal view virtual returns (bytes calldata) {
1996         return msg.data;
1997     }
1998 }
1999 
2000 // File: @openzeppelin/contracts/security/Pausable.sol
2001 
2002 
2003 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
2004 
2005 pragma solidity ^0.8.0;
2006 
2007 
2008 /**
2009  * @dev Contract module which allows children to implement an emergency stop
2010  * mechanism that can be triggered by an authorized account.
2011  *
2012  * This module is used through inheritance. It will make available the
2013  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2014  * the functions of your contract. Note that they will not be pausable by
2015  * simply including this module, only once the modifiers are put in place.
2016  */
2017 abstract contract Pausable is Context {
2018     /**
2019      * @dev Emitted when the pause is triggered by `account`.
2020      */
2021     event Paused(address account);
2022 
2023     /**
2024      * @dev Emitted when the pause is lifted by `account`.
2025      */
2026     event Unpaused(address account);
2027 
2028     bool private _paused;
2029 
2030     /**
2031      * @dev Initializes the contract in unpaused state.
2032      */
2033     constructor() {
2034         _paused = false;
2035     }
2036 
2037     /**
2038      * @dev Modifier to make a function callable only when the contract is not paused.
2039      *
2040      * Requirements:
2041      *
2042      * - The contract must not be paused.
2043      */
2044     modifier whenNotPaused() {
2045         _requireNotPaused();
2046         _;
2047     }
2048 
2049     /**
2050      * @dev Modifier to make a function callable only when the contract is paused.
2051      *
2052      * Requirements:
2053      *
2054      * - The contract must be paused.
2055      */
2056     modifier whenPaused() {
2057         _requirePaused();
2058         _;
2059     }
2060 
2061     /**
2062      * @dev Returns true if the contract is paused, and false otherwise.
2063      */
2064     function paused() public view virtual returns (bool) {
2065         return _paused;
2066     }
2067 
2068     /**
2069      * @dev Throws if the contract is paused.
2070      */
2071     function _requireNotPaused() internal view virtual {
2072         require(!paused(), "Pausable: paused");
2073     }
2074 
2075     /**
2076      * @dev Throws if the contract is not paused.
2077      */
2078     function _requirePaused() internal view virtual {
2079         require(paused(), "Pausable: not paused");
2080     }
2081 
2082     /**
2083      * @dev Triggers stopped state.
2084      *
2085      * Requirements:
2086      *
2087      * - The contract must not be paused.
2088      */
2089     function _pause() internal virtual whenNotPaused {
2090         _paused = true;
2091         emit Paused(_msgSender());
2092     }
2093 
2094     /**
2095      * @dev Returns to normal state.
2096      *
2097      * Requirements:
2098      *
2099      * - The contract must be paused.
2100      */
2101     function _unpause() internal virtual whenPaused {
2102         _paused = false;
2103         emit Unpaused(_msgSender());
2104     }
2105 }
2106 
2107 // File: @openzeppelin/contracts/access/Ownable.sol
2108 
2109 
2110 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2111 
2112 pragma solidity ^0.8.0;
2113 
2114 
2115 /**
2116  * @dev Contract module which provides a basic access control mechanism, where
2117  * there is an account (an owner) that can be granted exclusive access to
2118  * specific functions.
2119  *
2120  * By default, the owner account will be the one that deploys the contract. This
2121  * can later be changed with {transferOwnership}.
2122  *
2123  * This module is used through inheritance. It will make available the modifier
2124  * `onlyOwner`, which can be applied to your functions to restrict their use to
2125  * the owner.
2126  */
2127 abstract contract Ownable is Context {
2128     address private _owner;
2129 
2130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2131 
2132     /**
2133      * @dev Initializes the contract setting the deployer as the initial owner.
2134      */
2135     constructor() {
2136         _transferOwnership(_msgSender());
2137     }
2138 
2139     /**
2140      * @dev Throws if called by any account other than the owner.
2141      */
2142     modifier onlyOwner() {
2143         _checkOwner();
2144         _;
2145     }
2146 
2147     /**
2148      * @dev Returns the address of the current owner.
2149      */
2150     function owner() public view virtual returns (address) {
2151         return _owner;
2152     }
2153 
2154     /**
2155      * @dev Throws if the sender is not the owner.
2156      */
2157     function _checkOwner() internal view virtual {
2158         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2159     }
2160 
2161     /**
2162      * @dev Leaves the contract without owner. It will not be possible to call
2163      * `onlyOwner` functions anymore. Can only be called by the current owner.
2164      *
2165      * NOTE: Renouncing ownership will leave the contract without an owner,
2166      * thereby removing any functionality that is only available to the owner.
2167      */
2168     function renounceOwnership() public virtual onlyOwner {
2169         _transferOwnership(address(0));
2170     }
2171 
2172     /**
2173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2174      * Can only be called by the current owner.
2175      */
2176     function transferOwnership(address newOwner) public virtual onlyOwner {
2177         require(newOwner != address(0), "Ownable: new owner is the zero address");
2178         _transferOwnership(newOwner);
2179     }
2180 
2181     /**
2182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2183      * Internal function without access restriction.
2184      */
2185     function _transferOwnership(address newOwner) internal virtual {
2186         address oldOwner = _owner;
2187         _owner = newOwner;
2188         emit OwnershipTransferred(oldOwner, newOwner);
2189     }
2190 }
2191 
2192 // File: contracts/main.sol
2193 
2194 //SPDX-License-Identifier: MIT
2195 pragma solidity ^0.8.13;
2196 
2197 
2198 
2199 
2200 
2201 
2202 
2203 contract FunApes is ERC721A("Fun Apes", "FAPES"), Ownable, Pausable, DefaultOperatorFilterer {
2204     using SafeMath for uint256;
2205 
2206     event PermanentURI(string _value, uint256 indexed _id);
2207 
2208     uint256 public MINT_SESSION_BEGIN = 0;
2209 
2210     uint256 public constant MAX_SUPPLY = 8888;
2211     uint256 public constant MAX_WHITELIST_SUPPLY = 3000;
2212     uint256 public constant MAX_PUBLIC_SUPPLY = 4800;
2213     uint256 public constant MAX_FREE_SUPPLY = 1000;
2214     bool public overrideTime = false;
2215     address public REVEAL_ADDRESS;
2216     uint256 public constant PRICE = 0.015 ether;
2217     uint256 public constant WHITELIST_PRICE = 0.011 ether;
2218     uint256 public MAX_PER_MINT = 20;
2219     uint256 public constant MAX_PER_MINT_WHITELIST = 3;
2220     mapping(address => uint256) MAX_MINTS;
2221     mapping(address => uint256) MAX_MINTS_WHITELIST;
2222     mapping(address => uint256) MINTED_SNAPSHOT;
2223     bytes32 public merkleRoot =
2224         0xbc28c25d61ae901b5604242cc95ee33eba15486f215df421a0079e4f47a8345a;
2225     bytes32 public snapshotMerkleRoot =
2226         0xcd1875e63ecbd6152096ed8b4f1ddf77179f9dd80fffb582e52b085d956b9aa2;
2227     address nineWalletAddress = 0x0617eeEc0E0D37bcC191dd679d14c68b093dC1Be;
2228     string public _contractBaseURI;
2229 
2230     uint256 nineTotal = 0;
2231     uint256 ownerTotal = 0;
2232     uint256 nineWithdrawal;
2233     uint256 ownerWithdrawal;
2234 
2235     constructor(string memory baseURI) {
2236         _contractBaseURI = baseURI;
2237         _pause();
2238     }
2239     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2240         super.setApprovalForAll(operator, approved);
2241     }
2242 
2243     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2244         super.approve(operator, tokenId);
2245     }
2246 
2247     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2248         super.transferFrom(from, to, tokenId);
2249     }
2250 
2251     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2252         super.safeTransferFrom(from, to, tokenId);
2253     }
2254 
2255     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2256         public
2257         payable
2258         override
2259         onlyAllowedOperator(from)
2260     {
2261         super.safeTransferFrom(from, to, tokenId, data);
2262     }
2263     
2264 
2265     function reserveNFTs(address to, uint256 quantity) external onlyOwner {
2266         require(quantity > 0, "Quantity cannot be zero");
2267         uint256 totalMinted = totalSupply();
2268         require(
2269             totalMinted.add(quantity) <= MAX_SUPPLY,
2270             "No more reserved NFTs left"
2271         );
2272         _safeMint(to, quantity);
2273         lockMetadata(quantity);
2274     }
2275 
2276     function mint(uint256 quantity, address to) external payable whenNotPaused {
2277         require(block.timestamp >= MINT_SESSION_BEGIN + 4500 || overrideTime, "PUBLIC MINT CLOSED");
2278         require(quantity > 0, "Quantity cannot be zero");
2279         require(quantity <= 10, "Quantity cannot be greater than 10");
2280         uint256 totalMinted = totalSupply();
2281         require(
2282             MAX_MINTS[to] + quantity <= MAX_PER_MINT,
2283             "Max mint reached"
2284         );
2285         require(
2286             totalMinted.add(quantity) <= (MAX_SUPPLY - MAX_FREE_SUPPLY),
2287             "Not enough NFTs left to mint"
2288         );
2289         require(
2290             totalMinted.add(quantity) <= MAX_SUPPLY,
2291             "Not enough NFTs left to mint"
2292         );
2293         require(PRICE * quantity <= msg.value, "Insufficient funds sent");
2294         MAX_MINTS[to] += quantity;
2295         _safeMint(to, quantity);
2296         fundsCalculator(msg.value);
2297         lockMetadata(quantity);
2298     }
2299 
2300     function whitelistMint(uint256 quantity, bytes32[] calldata _merkleProof) whenNotPaused
2301         external
2302         payable
2303     {
2304         require(block.timestamp <= MINT_SESSION_BEGIN + 4500 && !overrideTime, "WHITELIST MINT CLOSED");
2305         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2306         require(
2307             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
2308             "Invalid Merkle Proof."
2309         );
2310         require(quantity > 0, "Quantity cannot be zero");
2311         uint256 totalMinted = totalSupply();
2312         require(
2313             MAX_MINTS_WHITELIST[msg.sender] + quantity <= MAX_PER_MINT_WHITELIST,
2314             "Max mint reached"
2315         );
2316         require(
2317             totalMinted.add(quantity) <= MAX_WHITELIST_SUPPLY,
2318             "Not enough NFTs left to mint"
2319         );
2320         require(
2321             totalMinted.add(quantity) <= MAX_SUPPLY,
2322             "Not enough NFTs left to mint"
2323         );
2324         require(
2325             WHITELIST_PRICE * quantity <= msg.value,
2326             "Insufficient funds sent"
2327         );
2328         MAX_MINTS_WHITELIST[msg.sender] += quantity;
2329         _safeMint(msg.sender, quantity);
2330         fundsCalculator(msg.value);
2331         lockMetadata(quantity);
2332     }
2333 
2334     function snapshotMint(uint256 quantity, bytes32[] calldata _merkleProof, uint256 maxQuantity)
2335         external whenNotPaused
2336     {
2337                 uint256 totalMinted = totalSupply();
2338                 require(
2339             totalMinted.add(quantity) <= MAX_FREE_SUPPLY,
2340             "Not enough NFTs left to mint"
2341         );
2342         require(
2343             totalMinted.add(quantity) < MAX_SUPPLY,
2344             "Not enough NFTs left to mint"
2345         );
2346         require(block.timestamp <= MINT_SESSION_BEGIN + 1 days, "FREE MINT CLOSED");
2347         bytes32 leaf = keccak256(abi.encodePacked(msg.sender, maxQuantity));
2348         require(
2349             MerkleProof.verify(_merkleProof, snapshotMerkleRoot, leaf),
2350             "Invalid Merkle Proof."
2351         );
2352         require(quantity > 0, "Quantity cannot be zero");
2353         require(
2354             MINTED_SNAPSHOT[msg.sender] + quantity <= maxQuantity,
2355             "Max mint reached"
2356         );
2357         MINTED_SNAPSHOT[msg.sender] += quantity;
2358         _safeMint(msg.sender, quantity);
2359         lockMetadata(quantity);
2360     }
2361 
2362     function lockMetadata(uint256 quantity) internal {
2363         for (uint256 i = quantity; i > 0; i--) {
2364             uint256 tid = totalSupply() - i;
2365             emit PermanentURI(tokenURI(tid), tid);
2366         }
2367     }
2368 
2369     function pause() public onlyOwner {
2370         _pause();
2371     }
2372 
2373     function unpause() public onlyOwner {
2374         _unpause();
2375     }
2376 
2377     function beginMintingSession() public onlyOwner {
2378         require(MINT_SESSION_BEGIN == 0, "MINT ALREADY BEGUN");
2379         MINT_SESSION_BEGIN = block.timestamp;
2380         _unpause();
2381     }
2382 
2383     function fundsCalculator(uint amount) internal {
2384         nineTotal += amount * 9 / 100;
2385         ownerTotal += amount * 91 / 100;
2386 }
2387 
2388     function withdraw() public onlyOwner {
2389         uint256 ownerWithdrawable = ownerTotal - ownerWithdrawal;
2390         payable(msg.sender).transfer(ownerWithdrawable);
2391         ownerWithdrawal += ownerWithdrawable;
2392     }
2393 
2394     function withdraw9() public {
2395         require(msg.sender == nineWalletAddress, "NOT PERMITTED.");
2396         uint256 nineWithdrawable = nineTotal - nineWithdrawal;
2397         require(nineWithdrawable > 0, "You cannot draw more funds right now");
2398         payable(msg.sender).transfer(nineWithdrawable);
2399         nineWithdrawal += nineWithdrawable;
2400     }
2401 
2402     function setRevealAddress(address add) public onlyOwner {
2403         REVEAL_ADDRESS = add;
2404     }
2405 
2406     function setWhitelist(bytes32 whitelist) public onlyOwner {
2407         merkleRoot = whitelist;
2408     }
2409 
2410     function setSnapshot(bytes32 snapshot) public onlyOwner {
2411         snapshotMerkleRoot = snapshot;
2412     }
2413 
2414     function OverrideTime() public onlyOwner {
2415         overrideTime = true;
2416     }
2417     function OverrideMintsPerWallet(uint256 amount) public onlyOwner {
2418         MAX_PER_MINT = amount;
2419     }
2420 
2421     function setBaseURI(string memory baseURI) public {
2422         require (msg.sender == owner() || msg.sender == REVEAL_ADDRESS);
2423         _contractBaseURI = baseURI;
2424     }
2425 
2426     // OpenSea metadata initialization
2427     function contractURI() public pure returns (string memory) {
2428         return "openseametadata.com/metadata.json";
2429     }
2430 
2431     function _baseURI() internal view override returns (string memory) {
2432         return _contractBaseURI;
2433     }
2434 }