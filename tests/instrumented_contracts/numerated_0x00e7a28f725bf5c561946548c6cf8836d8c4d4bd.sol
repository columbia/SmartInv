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
228 // File: @openzeppelin/contracts/utils/Context.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Provides information about the current execution context, including the
237  * sender of the transaction and its data. While these are generally available
238  * via msg.sender and msg.data, they should not be accessed in such a direct
239  * manner, since when dealing with meta-transactions the account sending and
240  * paying for execution may not be the actual sender (as far as an application
241  * is concerned).
242  *
243  * This contract is only required for intermediate, library-like contracts.
244  */
245 abstract contract Context {
246     function _msgSender() internal view virtual returns (address) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view virtual returns (bytes calldata) {
251         return msg.data;
252     }
253 }
254 
255 // File: @openzeppelin/contracts/access/Ownable.sol
256 
257 
258 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * By default, the owner account will be the one that deploys the contract. This
269  * can later be changed with {transferOwnership}.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 abstract contract Ownable is Context {
276     address private _owner;
277 
278     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280     /**
281      * @dev Initializes the contract setting the deployer as the initial owner.
282      */
283     constructor() {
284         _transferOwnership(_msgSender());
285     }
286 
287     /**
288      * @dev Throws if called by any account other than the owner.
289      */
290     modifier onlyOwner() {
291         _checkOwner();
292         _;
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view virtual returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if the sender is not the owner.
304      */
305     function _checkOwner() internal view virtual {
306         require(owner() == _msgSender(), "Ownable: caller is not the owner");
307     }
308 
309     /**
310      * @dev Leaves the contract without owner. It will not be possible to call
311      * `onlyOwner` functions anymore. Can only be called by the current owner.
312      *
313      * NOTE: Renouncing ownership will leave the contract without an owner,
314      * thereby removing any functionality that is only available to the owner.
315      */
316     function renounceOwnership() public virtual onlyOwner {
317         _transferOwnership(address(0));
318     }
319 
320     /**
321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
322      * Can only be called by the current owner.
323      */
324     function transferOwnership(address newOwner) public virtual onlyOwner {
325         require(newOwner != address(0), "Ownable: new owner is the zero address");
326         _transferOwnership(newOwner);
327     }
328 
329     /**
330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
331      * Internal function without access restriction.
332      */
333     function _transferOwnership(address newOwner) internal virtual {
334         address oldOwner = _owner;
335         _owner = newOwner;
336         emit OwnershipTransferred(oldOwner, newOwner);
337     }
338 }
339 
340 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
341 
342 
343 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev Interface of the ERC20 standard as defined in the EIP.
349  */
350 interface IERC20 {
351     /**
352      * @dev Emitted when `value` tokens are moved from one account (`from`) to
353      * another (`to`).
354      *
355      * Note that `value` may be zero.
356      */
357     event Transfer(address indexed from, address indexed to, uint256 value);
358 
359     /**
360      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
361      * a call to {approve}. `value` is the new allowance.
362      */
363     event Approval(address indexed owner, address indexed spender, uint256 value);
364 
365     /**
366      * @dev Returns the amount of tokens in existence.
367      */
368     function totalSupply() external view returns (uint256);
369 
370     /**
371      * @dev Returns the amount of tokens owned by `account`.
372      */
373     function balanceOf(address account) external view returns (uint256);
374 
375     /**
376      * @dev Moves `amount` tokens from the caller's account to `to`.
377      *
378      * Returns a boolean value indicating whether the operation succeeded.
379      *
380      * Emits a {Transfer} event.
381      */
382     function transfer(address to, uint256 amount) external returns (bool);
383 
384     /**
385      * @dev Returns the remaining number of tokens that `spender` will be
386      * allowed to spend on behalf of `owner` through {transferFrom}. This is
387      * zero by default.
388      *
389      * This value changes when {approve} or {transferFrom} are called.
390      */
391     function allowance(address owner, address spender) external view returns (uint256);
392 
393     /**
394      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
395      *
396      * Returns a boolean value indicating whether the operation succeeded.
397      *
398      * IMPORTANT: Beware that changing an allowance with this method brings the risk
399      * that someone may use both the old and the new allowance by unfortunate
400      * transaction ordering. One possible solution to mitigate this race
401      * condition is to first reduce the spender's allowance to 0 and set the
402      * desired value afterwards:
403      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
404      *
405      * Emits an {Approval} event.
406      */
407     function approve(address spender, uint256 amount) external returns (bool);
408 
409     /**
410      * @dev Moves `amount` tokens from `from` to `to` using the
411      * allowance mechanism. `amount` is then deducted from the caller's
412      * allowance.
413      *
414      * Returns a boolean value indicating whether the operation succeeded.
415      *
416      * Emits a {Transfer} event.
417      */
418     function transferFrom(
419         address from,
420         address to,
421         uint256 amount
422     ) external returns (bool);
423 }
424 
425 // File: contracts/airdrop.sol
426 
427 
428 pragma solidity ^0.8.0;
429 
430 
431 
432 
433 contract FoxeAirdrop is Ownable {
434     IERC20 public token;
435     uint256 private constant MAX_CLAIMABLE = 1777819;
436     uint256 private claimedCount;
437     mapping(address => bool) public hasClaimed;
438     bytes32 public merkleRoot;
439     bool public isAirdropEnabled;
440 
441     event Claimed(address indexed claimer, uint256 amount);
442 
443     constructor(IERC20 _token, bytes32 _merkleRoot) {
444         token = _token;
445         merkleRoot = _merkleRoot;
446         isAirdropEnabled = false;
447     }
448 
449     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
450         merkleRoot = _merkleRoot;
451     }
452 
453     function toggleAirdrop(bool _isAirdropEnabled) external onlyOwner {
454         isAirdropEnabled = _isAirdropEnabled;
455     }
456 
457     function claim(bytes32[] calldata merkleProof) external {
458         require(isAirdropEnabled, "Airdrop: The airdrop is currently disabled");
459         require(claimedCount < MAX_CLAIMABLE, "Airdrop: All tokens have been claimed");
460         require(!hasClaimed[msg.sender], "Airdrop: You have already claimed your tokens");
461 
462         bytes32 node = keccak256(abi.encodePacked(msg.sender));
463         require(MerkleProof.verify(merkleProof, merkleRoot, node), "Airdrop: Invalid merkle proof");
464 
465         uint256 amount;
466         if (claimedCount < 10000) {
467             amount = 5000000000 * 10 ** 18;
468         } else if (claimedCount >= 10000 && claimedCount < 100000) {
469             amount = 4000000000 * 10 ** 18;
470         } else if (claimedCount >= 100000 && claimedCount < 1700000) {
471             amount = 1000000000 * 10 ** 18;
472         }
473 
474         hasClaimed[msg.sender] = true;
475         claimedCount++;
476 
477         require(token.transfer(msg.sender, amount), "Airdrop: Token transfer failed");
478         emit Claimed(msg.sender, amount);
479     }
480 
481     function emergencyWithdraw(uint256 _amount) external onlyOwner {
482         require(token.transfer(owner(), _amount), "Airdrop: Emergency withdrawal failed");
483     }
484 }