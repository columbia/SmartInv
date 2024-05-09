1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Tree proofs.
11  *
12  * The tree and the proofs can be generated using our
13  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
14  * You will find a quickstart guide in the readme.
15  *
16  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
17  * hashing, or use a hash function other than keccak256 for hashing leaves.
18  * This is because the concatenation of a sorted pair of internal nodes in
19  * the merkle tree could be reinterpreted as a leaf value.
20  * OpenZeppelin's JavaScript library generates merkle trees that are safe
21  * against this attack out of the box.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Calldata version of {verify}
40      *
41      * _Available since v4.7._
42      */
43     function verifyCalldata(
44         bytes32[] calldata proof,
45         bytes32 root,
46         bytes32 leaf
47     ) internal pure returns (bool) {
48         return processProofCalldata(proof, leaf) == root;
49     }
50 
51     /**
52      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
53      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
54      * hash matches the root of the tree. When processing the proof, the pairs
55      * of leafs & pre-images are assumed to be sorted.
56      *
57      * _Available since v4.4._
58      */
59     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
60         bytes32 computedHash = leaf;
61         for (uint256 i = 0; i < proof.length; i++) {
62             computedHash = _hashPair(computedHash, proof[i]);
63         }
64         return computedHash;
65     }
66 
67     /**
68      * @dev Calldata version of {processProof}
69      *
70      * _Available since v4.7._
71      */
72     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
73         bytes32 computedHash = leaf;
74         for (uint256 i = 0; i < proof.length; i++) {
75             computedHash = _hashPair(computedHash, proof[i]);
76         }
77         return computedHash;
78     }
79 
80     /**
81      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
82      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
83      *
84      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
85      *
86      * _Available since v4.7._
87      */
88     function multiProofVerify(
89         bytes32[] memory proof,
90         bool[] memory proofFlags,
91         bytes32 root,
92         bytes32[] memory leaves
93     ) internal pure returns (bool) {
94         return processMultiProof(proof, proofFlags, leaves) == root;
95     }
96 
97     /**
98      * @dev Calldata version of {multiProofVerify}
99      *
100      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
101      *
102      * _Available since v4.7._
103      */
104     function multiProofVerifyCalldata(
105         bytes32[] calldata proof,
106         bool[] calldata proofFlags,
107         bytes32 root,
108         bytes32[] memory leaves
109     ) internal pure returns (bool) {
110         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
111     }
112 
113     /**
114      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
115      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
116      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
117      * respectively.
118      *
119      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
120      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
121      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
122      *
123      * _Available since v4.7._
124      */
125     function processMultiProof(
126         bytes32[] memory proof,
127         bool[] memory proofFlags,
128         bytes32[] memory leaves
129     ) internal pure returns (bytes32 merkleRoot) {
130         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
131         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
132         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
133         // the merkle tree.
134         uint256 leavesLen = leaves.length;
135         uint256 totalHashes = proofFlags.length;
136 
137         // Check proof validity.
138         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
139 
140         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
141         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
142         bytes32[] memory hashes = new bytes32[](totalHashes);
143         uint256 leafPos = 0;
144         uint256 hashPos = 0;
145         uint256 proofPos = 0;
146         // At each step, we compute the next hash using two values:
147         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
148         //   get the next hash.
149         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
150         //   `proof` array.
151         for (uint256 i = 0; i < totalHashes; i++) {
152             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
153             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
154             hashes[i] = _hashPair(a, b);
155         }
156 
157         if (totalHashes > 0) {
158             return hashes[totalHashes - 1];
159         } else if (leavesLen > 0) {
160             return leaves[0];
161         } else {
162             return proof[0];
163         }
164     }
165 
166     /**
167      * @dev Calldata version of {processMultiProof}.
168      *
169      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
170      *
171      * _Available since v4.7._
172      */
173     function processMultiProofCalldata(
174         bytes32[] calldata proof,
175         bool[] calldata proofFlags,
176         bytes32[] memory leaves
177     ) internal pure returns (bytes32 merkleRoot) {
178         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
179         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
180         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
181         // the merkle tree.
182         uint256 leavesLen = leaves.length;
183         uint256 totalHashes = proofFlags.length;
184 
185         // Check proof validity.
186         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
187 
188         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
189         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
190         bytes32[] memory hashes = new bytes32[](totalHashes);
191         uint256 leafPos = 0;
192         uint256 hashPos = 0;
193         uint256 proofPos = 0;
194         // At each step, we compute the next hash using two values:
195         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
196         //   get the next hash.
197         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
198         //   `proof` array.
199         for (uint256 i = 0; i < totalHashes; i++) {
200             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
201             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
202             hashes[i] = _hashPair(a, b);
203         }
204 
205         if (totalHashes > 0) {
206             return hashes[totalHashes - 1];
207         } else if (leavesLen > 0) {
208             return leaves[0];
209         } else {
210             return proof[0];
211         }
212     }
213 
214     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
215         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
216     }
217 
218     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
219         /// @solidity memory-safe-assembly
220         assembly {
221             mstore(0x00, a)
222             mstore(0x20, b)
223             value := keccak256(0x00, 0x40)
224         }
225     }
226 }
227 
228 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Contract module that helps prevent reentrant calls to a function.
237  *
238  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
239  * available, which can be applied to functions to make sure there are no nested
240  * (reentrant) calls to them.
241  *
242  * Note that because there is a single `nonReentrant` guard, functions marked as
243  * `nonReentrant` may not call one another. This can be worked around by making
244  * those functions `private`, and then adding `external` `nonReentrant` entry
245  * points to them.
246  *
247  * TIP: If you would like to learn more about reentrancy and alternative ways
248  * to protect against it, check out our blog post
249  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
250  */
251 abstract contract ReentrancyGuard {
252     // Booleans are more expensive than uint256 or any type that takes up a full
253     // word because each write operation emits an extra SLOAD to first read the
254     // slot's contents, replace the bits taken up by the boolean, and then write
255     // back. This is the compiler's defense against contract upgrades and
256     // pointer aliasing, and it cannot be disabled.
257 
258     // The values being non-zero value makes deployment a bit more expensive,
259     // but in exchange the refund on every call to nonReentrant will be lower in
260     // amount. Since refunds are capped to a percentage of the total
261     // transaction's gas, it is best to keep them low in cases like this one, to
262     // increase the likelihood of the full refund coming into effect.
263     uint256 private constant _NOT_ENTERED = 1;
264     uint256 private constant _ENTERED = 2;
265 
266     uint256 private _status;
267 
268     constructor() {
269         _status = _NOT_ENTERED;
270     }
271 
272     /**
273      * @dev Prevents a contract from calling itself, directly or indirectly.
274      * Calling a `nonReentrant` function from another `nonReentrant`
275      * function is not supported. It is possible to prevent this from happening
276      * by making the `nonReentrant` function external, and making it call a
277      * `private` function that does the actual work.
278      */
279     modifier nonReentrant() {
280         _nonReentrantBefore();
281         _;
282         _nonReentrantAfter();
283     }
284 
285     function _nonReentrantBefore() private {
286         // On the first call to nonReentrant, _status will be _NOT_ENTERED
287         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
288 
289         // Any calls to nonReentrant after this point will fail
290         _status = _ENTERED;
291     }
292 
293     function _nonReentrantAfter() private {
294         // By storing the original value once again, a refund is triggered (see
295         // https://eips.ethereum.org/EIPS/eip-2200)
296         _status = _NOT_ENTERED;
297     }
298 }
299 
300 // File: @openzeppelin/contracts/utils/Context.sol
301 
302 
303 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @dev Provides information about the current execution context, including the
309  * sender of the transaction and its data. While these are generally available
310  * via msg.sender and msg.data, they should not be accessed in such a direct
311  * manner, since when dealing with meta-transactions the account sending and
312  * paying for execution may not be the actual sender (as far as an application
313  * is concerned).
314  *
315  * This contract is only required for intermediate, library-like contracts.
316  */
317 abstract contract Context {
318     function _msgSender() internal view virtual returns (address) {
319         return msg.sender;
320     }
321 
322     function _msgData() internal view virtual returns (bytes calldata) {
323         return msg.data;
324     }
325 }
326 
327 // File: @openzeppelin/contracts/access/Ownable.sol
328 
329 
330 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 
335 /**
336  * @dev Contract module which provides a basic access control mechanism, where
337  * there is an account (an owner) that can be granted exclusive access to
338  * specific functions.
339  *
340  * By default, the owner account will be the one that deploys the contract. This
341  * can later be changed with {transferOwnership}.
342  *
343  * This module is used through inheritance. It will make available the modifier
344  * `onlyOwner`, which can be applied to your functions to restrict their use to
345  * the owner.
346  */
347 abstract contract Ownable is Context {
348     address private _owner;
349 
350     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
351 
352     /**
353      * @dev Initializes the contract setting the deployer as the initial owner.
354      */
355     constructor() {
356         _transferOwnership(_msgSender());
357     }
358 
359     /**
360      * @dev Throws if called by any account other than the owner.
361      */
362     modifier onlyOwner() {
363         _checkOwner();
364         _;
365     }
366 
367     /**
368      * @dev Returns the address of the current owner.
369      */
370     function owner() public view virtual returns (address) {
371         return _owner;
372     }
373 
374     /**
375      * @dev Throws if the sender is not the owner.
376      */
377     function _checkOwner() internal view virtual {
378         require(owner() == _msgSender(), "Ownable: caller is not the owner");
379     }
380 
381     /**
382      * @dev Leaves the contract without owner. It will not be possible to call
383      * `onlyOwner` functions anymore. Can only be called by the current owner.
384      *
385      * NOTE: Renouncing ownership will leave the contract without an owner,
386      * thereby removing any functionality that is only available to the owner.
387      */
388     function renounceOwnership() public virtual onlyOwner {
389         _transferOwnership(address(0));
390     }
391 
392     /**
393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
394      * Can only be called by the current owner.
395      */
396     function transferOwnership(address newOwner) public virtual onlyOwner {
397         require(newOwner != address(0), "Ownable: new owner is the zero address");
398         _transferOwnership(newOwner);
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Internal function without access restriction.
404      */
405     function _transferOwnership(address newOwner) internal virtual {
406         address oldOwner = _owner;
407         _owner = newOwner;
408         emit OwnershipTransferred(oldOwner, newOwner);
409     }
410 }
411 
412 // File: FourClaims.sol
413 
414 
415 pragma solidity ^0.8.19;
416 
417 
418 
419 
420 interface Four {
421     function transfer(address to, uint256 amount) external returns (bool);
422     function balanceOf(address account) external view returns (uint256);
423 }
424 
425 contract FourClaims is Ownable, ReentrancyGuard {
426 
427     Four public four;
428     address public treasury;
429 
430     bytes32 public root;
431     uint public constant amount = 5351009340000000000000000;
432     mapping(address => bool) public claimed;
433 
434     constructor(address _four, bytes32 _merkleRoot, address _treasury) {
435       four = Four(_four);
436       root = _merkleRoot;
437       treasury = _treasury;
438     }
439 
440     //================================
441     // Claim
442     //================================
443 
444     event Claimed(address indexed user, uint256 amount);
445     function claim(bytes32[] calldata proof) public nonReentrant {
446       require(_verify(_leaf(msg.sender), proof), "INVALID_MERKLE_PROOF");
447       require(!claimed[msg.sender], "ALREADY_CLAIMED");
448       require(four.balanceOf(address(this)) >= amount, "OUT_OF_FUNDS");
449 
450       claimed[msg.sender] = true;
451       four.transfer(msg.sender, amount);
452       emit Claimed(msg.sender, amount);
453     }
454 
455     function _leaf(address account)
456     private pure returns (bytes32)
457     {
458       return keccak256(abi.encodePacked(account));
459     }
460 
461     function _verify(bytes32 leaf, bytes32[] memory proof)
462     private view returns (bool)
463     {
464       return MerkleProof.verify(proof, root, leaf);
465     }
466 
467     //================================
468     // Admin Functions
469     //================================
470     function setMerkleRoot(bytes32 _newRoot) public onlyOwner {
471       root = _newRoot;
472     }
473     function setTreasury(address _newTreasury) public onlyOwner {
474       treasury = _newTreasury;
475     }
476 
477     function withdraw(uint _amount) public onlyOwner {
478       four.transfer(treasury, _amount);
479     }
480 }