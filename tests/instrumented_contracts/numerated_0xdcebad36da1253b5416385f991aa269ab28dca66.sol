1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _transferOwnership(_msgSender());
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         _checkOwner();
54         _;
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if the sender is not the owner.
66      */
67     function _checkOwner() internal view virtual {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 
103 pragma solidity ^0.8.0;
104 /**
105  * @dev These functions deal with verification of Merkle Tree proofs.
106  *
107  * The tree and the proofs can be generated using our
108  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
109  * You will find a quickstart guide in the readme.
110  *
111  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
112  * hashing, or use a hash function other than keccak256 for hashing leaves.
113  * This is because the concatenation of a sorted pair of internal nodes in
114  * the merkle tree could be reinterpreted as a leaf value.
115  * OpenZeppelin's JavaScript library generates merkle trees that are safe
116  * against this attack out of the box.
117  */
118 library MerkleProof {
119     /**
120      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
121      * defined by `root`. For this, a `proof` must be provided, containing
122      * sibling hashes on the branch from the leaf to the root of the tree. Each
123      * pair of leaves and each pair of pre-images are assumed to be sorted.
124      */
125     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
126         return processProof(proof, leaf) == root;
127     }
128 
129     /**
130      * @dev Calldata version of {verify}
131      *
132      * _Available since v4.7._
133      */
134     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
135         return processProofCalldata(proof, leaf) == root;
136     }
137 
138     /**
139      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
140      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
141      * hash matches the root of the tree. When processing the proof, the pairs
142      * of leafs & pre-images are assumed to be sorted.
143      *
144      * _Available since v4.4._
145      */
146     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
147         bytes32 computedHash = leaf;
148         for (uint256 i = 0; i < proof.length; i++) {
149             computedHash = _hashPair(computedHash, proof[i]);
150         }
151         return computedHash;
152     }
153 
154     /**
155      * @dev Calldata version of {processProof}
156      *
157      * _Available since v4.7._
158      */
159     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
160         bytes32 computedHash = leaf;
161         for (uint256 i = 0; i < proof.length; i++) {
162             computedHash = _hashPair(computedHash, proof[i]);
163         }
164         return computedHash;
165     }
166 
167     /**
168      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
169      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
170      *
171      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
172      *
173      * _Available since v4.7._
174      */
175     function multiProofVerify(
176         bytes32[] memory proof,
177         bool[] memory proofFlags,
178         bytes32 root,
179         bytes32[] memory leaves
180     ) internal pure returns (bool) {
181         return processMultiProof(proof, proofFlags, leaves) == root;
182     }
183 
184     /**
185      * @dev Calldata version of {multiProofVerify}
186      *
187      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
188      *
189      * _Available since v4.7._
190      */
191     function multiProofVerifyCalldata(
192         bytes32[] calldata proof,
193         bool[] calldata proofFlags,
194         bytes32 root,
195         bytes32[] memory leaves
196     ) internal pure returns (bool) {
197         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
198     }
199 
200     /**
201      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
202      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
203      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
204      * respectively.
205      *
206      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
207      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
208      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
209      *
210      * _Available since v4.7._
211      */
212     function processMultiProof(
213         bytes32[] memory proof,
214         bool[] memory proofFlags,
215         bytes32[] memory leaves
216     ) internal pure returns (bytes32 merkleRoot) {
217         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
218         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
219         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
220         // the merkle tree.
221         uint256 leavesLen = leaves.length;
222         uint256 proofLen = proof.length;
223         uint256 totalHashes = proofFlags.length;
224 
225         // Check proof validity.
226         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
227 
228         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
229         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
230         bytes32[] memory hashes = new bytes32[](totalHashes);
231         uint256 leafPos = 0;
232         uint256 hashPos = 0;
233         uint256 proofPos = 0;
234         // At each step, we compute the next hash using two values:
235         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
236         //   get the next hash.
237         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
238         //   `proof` array.
239         for (uint256 i = 0; i < totalHashes; i++) {
240             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
241             bytes32 b = proofFlags[i]
242                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
243                 : proof[proofPos++];
244             hashes[i] = _hashPair(a, b);
245         }
246 
247         if (totalHashes > 0) {
248             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
249             unchecked {
250                 return hashes[totalHashes - 1];
251             }
252         } else if (leavesLen > 0) {
253             return leaves[0];
254         } else {
255             return proof[0];
256         }
257     }
258 
259     /**
260      * @dev Calldata version of {processMultiProof}.
261      *
262      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
263      *
264      * _Available since v4.7._
265      */
266     function processMultiProofCalldata(
267         bytes32[] calldata proof,
268         bool[] calldata proofFlags,
269         bytes32[] memory leaves
270     ) internal pure returns (bytes32 merkleRoot) {
271         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
272         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
273         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
274         // the merkle tree.
275         uint256 leavesLen = leaves.length;
276         uint256 proofLen = proof.length;
277         uint256 totalHashes = proofFlags.length;
278 
279         // Check proof validity.
280         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
281 
282         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
283         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
284         bytes32[] memory hashes = new bytes32[](totalHashes);
285         uint256 leafPos = 0;
286         uint256 hashPos = 0;
287         uint256 proofPos = 0;
288         // At each step, we compute the next hash using two values:
289         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
290         //   get the next hash.
291         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
292         //   `proof` array.
293         for (uint256 i = 0; i < totalHashes; i++) {
294             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
295             bytes32 b = proofFlags[i]
296                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
297                 : proof[proofPos++];
298             hashes[i] = _hashPair(a, b);
299         }
300 
301         if (totalHashes > 0) {
302             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
303             unchecked {
304                 return hashes[totalHashes - 1];
305             }
306         } else if (leavesLen > 0) {
307             return leaves[0];
308         } else {
309             return proof[0];
310         }
311     }
312 
313     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
314         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
315     }
316 
317     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
318         /// @solidity memory-safe-assembly
319         assembly {
320             mstore(0x00, a)
321             mstore(0x20, b)
322             value := keccak256(0x00, 0x40)
323         }
324     }
325 }
326 
327 
328 pragma solidity ^0.8.7;
329 contract OG_CARD is Ownable {
330     uint256 public current_index;
331     uint256 public constant MAX_INDEX = 1200;
332     uint256 public constant MINT_PRICE_WHITELIST = 0.02 ether;
333     uint256 public constant MINT_PRICE = 0.05 ether;
334     address payable public receiver;
335     uint256 public freeCount;
336 
337     bytes32 public merkleRoot;
338 
339     event Mint(address indexed sender, uint256 tokenID);
340 
341     constructor(address payable _receiver, bytes32 mRoot) {
342         receiver = _receiver;
343         freeCount = 0;
344         merkleRoot = mRoot;
345     }
346 
347     function setMerkleRoot(bytes32 mRoot)external onlyOwner {
348         merkleRoot = mRoot;
349     }
350 
351     function toBytes32(address addr) pure internal returns (bytes32) {
352         return bytes32(uint256(uint160(addr)));
353     }
354 
355     function mintFromWhitelist( bytes32[] calldata merkleProof) payable external {
356 
357         require(current_index < MAX_INDEX, "Exceeds maximum index limit");
358         require(MerkleProof.verify(merkleProof, merkleRoot, toBytes32(msg.sender)) == true, "invalid merkle proof");
359 
360         if(freeCount < 100){
361             current_index++;
362             freeCount++;
363             emit Mint(msg.sender,current_index);
364         }else{
365             uint256 cycle = current_index % 30;
366             if(cycle > 2){
367                 require(msg.value >= MINT_PRICE_WHITELIST, "Incorrect payment amount");
368                 receiver.transfer(msg.value);
369             }
370             current_index++;
371             emit Mint(msg.sender,current_index);
372         }
373     }
374 
375     function mint() external payable {
376         require(current_index < MAX_INDEX, "Exceeds maximum index limit");
377         uint256 cycle = current_index % 30;
378         if(cycle > 2){
379             require(msg.value >= MINT_PRICE, "Incorrect payment amount");
380             receiver.transfer(msg.value);
381         }
382         current_index++;
383         emit Mint(msg.sender,current_index);
384     }
385 
386     function getState() public view returns(uint256,uint256){
387         return (current_index,freeCount);
388     }
389 }