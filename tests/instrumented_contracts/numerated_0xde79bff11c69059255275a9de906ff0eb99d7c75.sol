1 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
2 //@@@@@@@@@@@@@@@@@@@@@@&&&&&&@@@@@@@@@@@@@@@@@@@@@@
3 //@@@@@@@@@@@@@@@@&G5?7~::::::~7?5G#@@@@@@@@@@@@@@@@
4 //@@@@@@@@@@@@&GJ~.    .!~  ~!.    .~Y!7P#@@@@@@@@@@
5 //@@@@@@@@@@B7: .7J~ .?B@?  ?@B?. ~?7G7. .?B@@@@@@@@
6 //@@@@@@@@B7. ^J##! .5@@@?  ?@@@P::J~J#5!. .?&@@@@@@
7 //@@@@@@@5:   .:~:  :!7Y5~  ~5Y7!: ^J!:::::  ~B@@@@@
8 //@@@@@@J. ~PBGP:                   .7G&&&&5: ^G@@@@
9 //@@@@@J. !&@@@&^.?!:!7. .!!. .7!:!?.:#@@@@@P. ^#@@@
10 //@@@@G: :B@@@@P: :5GY: ^P55P^ :YG5^ .P@@@@@@?  ?@@@
11 //@@@&7 .5@@@@@? .?~.~7.:^  ^:.7~.~7: ~5&@@@@#^ :G@@
12 //@@@#: .JPPPPY^                   .^:  !JJJJ?. .P@@
13 //@@@#^ .JPPPPY^  ~PPPPPP!  ~PPPPPPB5  :G####B^ :G@@
14 //@@@@J .5@@@@@?  ?@@@@@@?  ?@@@@@@@5. ^&@@@@P. 7@@@
15 //@@@@G: :B@@@@Y. !&@@@@@?  7@@@@@@@J .Y@@@@#^ .P@@@
16 //@@@@@J. !#@@@&J7?#@@@@@?  ?@@@@@#Y.:B@@@@#! .J@@@@
17 //@@@@@@Y.:P@@G~~!B@&&P??^  ^???JJ^  .YBGB5: .Y@@@@@
18 //@@@@@@Y..7?7:   .::7GYY~  ~YY?~.  :^:. ~7^7G@@@@@@
19 //@@@@@@G~   ~7Y!  ~P#@@@?  ?@@@P: ~#BJ^ .?#@@@@@@@@
20 //@@@@@@@&5^ .!P#7 .J&@@@?  ?@B?. :J7. :7G@@@@@@@@@@
21 //@@@@@@@@@&P?: :^.  ^?:!~  ~!.    .~?P&@@@@@@@@@@@@
22 //@@@@@@@@@@@@&BY!^:^7?~::::::~7?5G#@@@@@@@@@@@@@@@@
23 //@@@@@@@@@@@@@@@@@&@@@@&&&&&&@@@@@@@@@@@@@@@@@@@@@@
24 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
25 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
26 
27 
28 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev These functions deal with verification of Merkle Tree proofs.
34  *
35  * The tree and the proofs can be generated using our
36  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
37  * You will find a quickstart guide in the readme.
38  *
39  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
40  * hashing, or use a hash function other than keccak256 for hashing leaves.
41  * This is because the concatenation of a sorted pair of internal nodes in
42  * the merkle tree could be reinterpreted as a leaf value.
43  * OpenZeppelin's JavaScript library generates merkle trees that are safe
44  * against this attack out of the box.
45  */
46 library MerkleProof {
47     /**
48      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
49      * defined by `root`. For this, a `proof` must be provided, containing
50      * sibling hashes on the branch from the leaf to the root of the tree. Each
51      * pair of leaves and each pair of pre-images are assumed to be sorted.
52      */
53     function verify(
54         bytes32[] memory proof,
55         bytes32 root,
56         bytes32 leaf
57     ) internal pure returns (bool) {
58         return processProof(proof, leaf) == root;
59     }
60 
61     /**
62      * @dev Calldata version of {verify}
63      *
64      * _Available since v4.7._
65      */
66     function verifyCalldata(
67         bytes32[] calldata proof,
68         bytes32 root,
69         bytes32 leaf
70     ) internal pure returns (bool) {
71         return processProofCalldata(proof, leaf) == root;
72     }
73 
74     /**
75      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
76      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
77      * hash matches the root of the tree. When processing the proof, the pairs
78      * of leafs & pre-images are assumed to be sorted.
79      *
80      * _Available since v4.4._
81      */
82     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
83         bytes32 computedHash = leaf;
84         for (uint256 i = 0; i < proof.length; i++) {
85             computedHash = _hashPair(computedHash, proof[i]);
86         }
87         return computedHash;
88     }
89 
90     /**
91      * @dev Calldata version of {processProof}
92      *
93      * _Available since v4.7._
94      */
95     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
96         bytes32 computedHash = leaf;
97         for (uint256 i = 0; i < proof.length; i++) {
98             computedHash = _hashPair(computedHash, proof[i]);
99         }
100         return computedHash;
101     }
102 
103     /**
104      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
105      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
106      *
107      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
108      *
109      * _Available since v4.7._
110      */
111     function multiProofVerify(
112         bytes32[] memory proof,
113         bool[] memory proofFlags,
114         bytes32 root,
115         bytes32[] memory leaves
116     ) internal pure returns (bool) {
117         return processMultiProof(proof, proofFlags, leaves) == root;
118     }
119 
120     /**
121      * @dev Calldata version of {multiProofVerify}
122      *
123      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
124      *
125      * _Available since v4.7._
126      */
127     function multiProofVerifyCalldata(
128         bytes32[] calldata proof,
129         bool[] calldata proofFlags,
130         bytes32 root,
131         bytes32[] memory leaves
132     ) internal pure returns (bool) {
133         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
134     }
135 
136     /**
137      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
138      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
139      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
140      * respectively.
141      *
142      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
143      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
144      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
145      *
146      * _Available since v4.7._
147      */
148     function processMultiProof(
149         bytes32[] memory proof,
150         bool[] memory proofFlags,
151         bytes32[] memory leaves
152     ) internal pure returns (bytes32 merkleRoot) {
153         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
154         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
155         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
156         // the merkle tree.
157         uint256 leavesLen = leaves.length;
158         uint256 totalHashes = proofFlags.length;
159 
160         // Check proof validity.
161         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
162 
163         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
164         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
165         bytes32[] memory hashes = new bytes32[](totalHashes);
166         uint256 leafPos = 0;
167         uint256 hashPos = 0;
168         uint256 proofPos = 0;
169         // At each step, we compute the next hash using two values:
170         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
171         //   get the next hash.
172         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
173         //   `proof` array.
174         for (uint256 i = 0; i < totalHashes; i++) {
175             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
176             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
177             hashes[i] = _hashPair(a, b);
178         }
179 
180         if (totalHashes > 0) {
181             return hashes[totalHashes - 1];
182         } else if (leavesLen > 0) {
183             return leaves[0];
184         } else {
185             return proof[0];
186         }
187     }
188 
189     /**
190      * @dev Calldata version of {processMultiProof}.
191      *
192      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
193      *
194      * _Available since v4.7._
195      */
196     function processMultiProofCalldata(
197         bytes32[] calldata proof,
198         bool[] calldata proofFlags,
199         bytes32[] memory leaves
200     ) internal pure returns (bytes32 merkleRoot) {
201         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
202         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
203         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
204         // the merkle tree.
205         uint256 leavesLen = leaves.length;
206         uint256 totalHashes = proofFlags.length;
207 
208         // Check proof validity.
209         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
210 
211         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
212         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
213         bytes32[] memory hashes = new bytes32[](totalHashes);
214         uint256 leafPos = 0;
215         uint256 hashPos = 0;
216         uint256 proofPos = 0;
217         // At each step, we compute the next hash using two values:
218         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
219         //   get the next hash.
220         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
221         //   `proof` array.
222         for (uint256 i = 0; i < totalHashes; i++) {
223             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
224             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
225             hashes[i] = _hashPair(a, b);
226         }
227 
228         if (totalHashes > 0) {
229             return hashes[totalHashes - 1];
230         } else if (leavesLen > 0) {
231             return leaves[0];
232         } else {
233             return proof[0];
234         }
235     }
236 
237     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
238         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
239     }
240 
241     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
242         /// @solidity memory-safe-assembly
243         assembly {
244             mstore(0x00, a)
245             mstore(0x20, b)
246             value := keccak256(0x00, 0x40)
247         }
248     }
249 }
250 
251 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
252 
253 
254 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev Contract module that helps prevent reentrant calls to a function.
260  *
261  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
262  * available, which can be applied to functions to make sure there are no nested
263  * (reentrant) calls to them.
264  *
265  * Note that because there is a single `nonReentrant` guard, functions marked as
266  * `nonReentrant` may not call one another. This can be worked around by making
267  * those functions `private`, and then adding `external` `nonReentrant` entry
268  * points to them.
269  *
270  * TIP: If you would like to learn more about reentrancy and alternative ways
271  * to protect against it, check out our blog post
272  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
273  */
274 abstract contract ReentrancyGuard {
275     // Booleans are more expensive than uint256 or any type that takes up a full
276     // word because each write operation emits an extra SLOAD to first read the
277     // slot's contents, replace the bits taken up by the boolean, and then write
278     // back. This is the compiler's defense against contract upgrades and
279     // pointer aliasing, and it cannot be disabled.
280 
281     // The values being non-zero value makes deployment a bit more expensive,
282     // but in exchange the refund on every call to nonReentrant will be lower in
283     // amount. Since refunds are capped to a percentage of the total
284     // transaction's gas, it is best to keep them low in cases like this one, to
285     // increase the likelihood of the full refund coming into effect.
286     uint256 private constant _NOT_ENTERED = 1;
287     uint256 private constant _ENTERED = 2;
288 
289     uint256 private _status;
290 
291     constructor() {
292         _status = _NOT_ENTERED;
293     }
294 
295     /**
296      * @dev Prevents a contract from calling itself, directly or indirectly.
297      * Calling a `nonReentrant` function from another `nonReentrant`
298      * function is not supported. It is possible to prevent this from happening
299      * by making the `nonReentrant` function external, and making it call a
300      * `private` function that does the actual work.
301      */
302     modifier nonReentrant() {
303         _nonReentrantBefore();
304         _;
305         _nonReentrantAfter();
306     }
307 
308     function _nonReentrantBefore() private {
309         // On the first call to nonReentrant, _status will be _NOT_ENTERED
310         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
311 
312         // Any calls to nonReentrant after this point will fail
313         _status = _ENTERED;
314     }
315 
316     function _nonReentrantAfter() private {
317         // By storing the original value once again, a refund is triggered (see
318         // https://eips.ethereum.org/EIPS/eip-2200)
319         _status = _NOT_ENTERED;
320     }
321 }
322 
323 // File: @openzeppelin/contracts/utils/Context.sol
324 
325 
326 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
327 
328 pragma solidity ^0.8.0;
329 
330 /**
331  * @dev Provides information about the current execution context, including the
332  * sender of the transaction and its data. While these are generally available
333  * via msg.sender and msg.data, they should not be accessed in such a direct
334  * manner, since when dealing with meta-transactions the account sending and
335  * paying for execution may not be the actual sender (as far as an application
336  * is concerned).
337  *
338  * This contract is only required for intermediate, library-like contracts.
339  */
340 abstract contract Context {
341     function _msgSender() internal view virtual returns (address) {
342         return msg.sender;
343     }
344 
345     function _msgData() internal view virtual returns (bytes calldata) {
346         return msg.data;
347     }
348 }
349 
350 // File: @openzeppelin/contracts/access/Ownable.sol
351 
352 
353 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev Contract module which provides a basic access control mechanism, where
360  * there is an account (an owner) that can be granted exclusive access to
361  * specific functions.
362  *
363  * By default, the owner account will be the one that deploys the contract. This
364  * can later be changed with {transferOwnership}.
365  *
366  * This module is used through inheritance. It will make available the modifier
367  * `onlyOwner`, which can be applied to your functions to restrict their use to
368  * the owner.
369  */
370 abstract contract Ownable is Context {
371     address private _owner;
372 
373     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375     /**
376      * @dev Initializes the contract setting the deployer as the initial owner.
377      */
378     constructor() {
379         _transferOwnership(_msgSender());
380     }
381 
382     /**
383      * @dev Throws if called by any account other than the owner.
384      */
385     modifier onlyOwner() {
386         _checkOwner();
387         _;
388     }
389 
390     /**
391      * @dev Returns the address of the current owner.
392      */
393     function owner() public view virtual returns (address) {
394         return _owner;
395     }
396 
397     /**
398      * @dev Throws if the sender is not the owner.
399      */
400     function _checkOwner() internal view virtual {
401         require(owner() == _msgSender(), "Ownable: caller is not the owner");
402     }
403 
404     /**
405      * @dev Leaves the contract without owner. It will not be possible to call
406      * `onlyOwner` functions anymore. Can only be called by the current owner.
407      *
408      * NOTE: Renouncing ownership will leave the contract without an owner,
409      * thereby removing any functionality that is only available to the owner.
410      */
411     function renounceOwnership() public virtual onlyOwner {
412         _transferOwnership(address(0));
413     }
414 
415     /**
416      * @dev Transfers ownership of the contract to a new account (`newOwner`).
417      * Can only be called by the current owner.
418      */
419     function transferOwnership(address newOwner) public virtual onlyOwner {
420         require(newOwner != address(0), "Ownable: new owner is the zero address");
421         _transferOwnership(newOwner);
422     }
423 
424     /**
425      * @dev Transfers ownership of the contract to a new account (`newOwner`).
426      * Internal function without access restriction.
427      */
428     function _transferOwnership(address newOwner) internal virtual {
429         address oldOwner = _owner;
430         _owner = newOwner;
431         emit OwnershipTransferred(oldOwner, newOwner);
432     }
433 }
434 
435 // File: @openzeppelin/contracts/utils/math/Math.sol
436 
437 
438 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Standard math utilities missing in the Solidity language.
444  */
445 library Math {
446     enum Rounding {
447         Down, // Toward negative infinity
448         Up, // Toward infinity
449         Zero // Toward zero
450     }
451 
452     /**
453      * @dev Returns the largest of two numbers.
454      */
455     function max(uint256 a, uint256 b) internal pure returns (uint256) {
456         return a > b ? a : b;
457     }
458 
459     /**
460      * @dev Returns the smallest of two numbers.
461      */
462     function min(uint256 a, uint256 b) internal pure returns (uint256) {
463         return a < b ? a : b;
464     }
465 
466     /**
467      * @dev Returns the average of two numbers. The result is rounded towards
468      * zero.
469      */
470     function average(uint256 a, uint256 b) internal pure returns (uint256) {
471         // (a + b) / 2 can overflow.
472         return (a & b) + (a ^ b) / 2;
473     }
474 
475     /**
476      * @dev Returns the ceiling of the division of two numbers.
477      *
478      * This differs from standard division with `/` in that it rounds up instead
479      * of rounding down.
480      */
481     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
482         // (a + b - 1) / b can overflow on addition, so we distribute.
483         return a == 0 ? 0 : (a - 1) / b + 1;
484     }
485 
486     /**
487      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
488      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
489      * with further edits by Uniswap Labs also under MIT license.
490      */
491     function mulDiv(
492         uint256 x,
493         uint256 y,
494         uint256 denominator
495     ) internal pure returns (uint256 result) {
496         unchecked {
497             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
498             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
499             // variables such that product = prod1 * 2^256 + prod0.
500             uint256 prod0; // Least significant 256 bits of the product
501             uint256 prod1; // Most significant 256 bits of the product
502             assembly {
503                 let mm := mulmod(x, y, not(0))
504                 prod0 := mul(x, y)
505                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
506             }
507 
508             // Handle non-overflow cases, 256 by 256 division.
509             if (prod1 == 0) {
510                 return prod0 / denominator;
511             }
512 
513             // Make sure the result is less than 2^256. Also prevents denominator == 0.
514             require(denominator > prod1);
515 
516             ///////////////////////////////////////////////
517             // 512 by 256 division.
518             ///////////////////////////////////////////////
519 
520             // Make division exact by subtracting the remainder from [prod1 prod0].
521             uint256 remainder;
522             assembly {
523                 // Compute remainder using mulmod.
524                 remainder := mulmod(x, y, denominator)
525 
526                 // Subtract 256 bit number from 512 bit number.
527                 prod1 := sub(prod1, gt(remainder, prod0))
528                 prod0 := sub(prod0, remainder)
529             }
530 
531             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
532             // See https://cs.stackexchange.com/q/138556/92363.
533 
534             // Does not overflow because the denominator cannot be zero at this stage in the function.
535             uint256 twos = denominator & (~denominator + 1);
536             assembly {
537                 // Divide denominator by twos.
538                 denominator := div(denominator, twos)
539 
540                 // Divide [prod1 prod0] by twos.
541                 prod0 := div(prod0, twos)
542 
543                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
544                 twos := add(div(sub(0, twos), twos), 1)
545             }
546 
547             // Shift in bits from prod1 into prod0.
548             prod0 |= prod1 * twos;
549 
550             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
551             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
552             // four bits. That is, denominator * inv = 1 mod 2^4.
553             uint256 inverse = (3 * denominator) ^ 2;
554 
555             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
556             // in modular arithmetic, doubling the correct bits in each step.
557             inverse *= 2 - denominator * inverse; // inverse mod 2^8
558             inverse *= 2 - denominator * inverse; // inverse mod 2^16
559             inverse *= 2 - denominator * inverse; // inverse mod 2^32
560             inverse *= 2 - denominator * inverse; // inverse mod 2^64
561             inverse *= 2 - denominator * inverse; // inverse mod 2^128
562             inverse *= 2 - denominator * inverse; // inverse mod 2^256
563 
564             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
565             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
566             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
567             // is no longer required.
568             result = prod0 * inverse;
569             return result;
570         }
571     }
572 
573     /**
574      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
575      */
576     function mulDiv(
577         uint256 x,
578         uint256 y,
579         uint256 denominator,
580         Rounding rounding
581     ) internal pure returns (uint256) {
582         uint256 result = mulDiv(x, y, denominator);
583         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
584             result += 1;
585         }
586         return result;
587     }
588 
589     /**
590      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
591      *
592      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
593      */
594     function sqrt(uint256 a) internal pure returns (uint256) {
595         if (a == 0) {
596             return 0;
597         }
598 
599         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
600         //
601         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
602         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
603         //
604         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
605         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
606         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
607         //
608         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
609         uint256 result = 1 << (log2(a) >> 1);
610 
611         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
612         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
613         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
614         // into the expected uint128 result.
615         unchecked {
616             result = (result + a / result) >> 1;
617             result = (result + a / result) >> 1;
618             result = (result + a / result) >> 1;
619             result = (result + a / result) >> 1;
620             result = (result + a / result) >> 1;
621             result = (result + a / result) >> 1;
622             result = (result + a / result) >> 1;
623             return min(result, a / result);
624         }
625     }
626 
627     /**
628      * @notice Calculates sqrt(a), following the selected rounding direction.
629      */
630     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
631         unchecked {
632             uint256 result = sqrt(a);
633             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
634         }
635     }
636 
637     /**
638      * @dev Return the log in base 2, rounded down, of a positive value.
639      * Returns 0 if given 0.
640      */
641     function log2(uint256 value) internal pure returns (uint256) {
642         uint256 result = 0;
643         unchecked {
644             if (value >> 128 > 0) {
645                 value >>= 128;
646                 result += 128;
647             }
648             if (value >> 64 > 0) {
649                 value >>= 64;
650                 result += 64;
651             }
652             if (value >> 32 > 0) {
653                 value >>= 32;
654                 result += 32;
655             }
656             if (value >> 16 > 0) {
657                 value >>= 16;
658                 result += 16;
659             }
660             if (value >> 8 > 0) {
661                 value >>= 8;
662                 result += 8;
663             }
664             if (value >> 4 > 0) {
665                 value >>= 4;
666                 result += 4;
667             }
668             if (value >> 2 > 0) {
669                 value >>= 2;
670                 result += 2;
671             }
672             if (value >> 1 > 0) {
673                 result += 1;
674             }
675         }
676         return result;
677     }
678 
679     /**
680      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
681      * Returns 0 if given 0.
682      */
683     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
684         unchecked {
685             uint256 result = log2(value);
686             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
687         }
688     }
689 
690     /**
691      * @dev Return the log in base 10, rounded down, of a positive value.
692      * Returns 0 if given 0.
693      */
694     function log10(uint256 value) internal pure returns (uint256) {
695         uint256 result = 0;
696         unchecked {
697             if (value >= 10**64) {
698                 value /= 10**64;
699                 result += 64;
700             }
701             if (value >= 10**32) {
702                 value /= 10**32;
703                 result += 32;
704             }
705             if (value >= 10**16) {
706                 value /= 10**16;
707                 result += 16;
708             }
709             if (value >= 10**8) {
710                 value /= 10**8;
711                 result += 8;
712             }
713             if (value >= 10**4) {
714                 value /= 10**4;
715                 result += 4;
716             }
717             if (value >= 10**2) {
718                 value /= 10**2;
719                 result += 2;
720             }
721             if (value >= 10**1) {
722                 result += 1;
723             }
724         }
725         return result;
726     }
727 
728     /**
729      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
730      * Returns 0 if given 0.
731      */
732     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
733         unchecked {
734             uint256 result = log10(value);
735             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
736         }
737     }
738 
739     /**
740      * @dev Return the log in base 256, rounded down, of a positive value.
741      * Returns 0 if given 0.
742      *
743      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
744      */
745     function log256(uint256 value) internal pure returns (uint256) {
746         uint256 result = 0;
747         unchecked {
748             if (value >> 128 > 0) {
749                 value >>= 128;
750                 result += 16;
751             }
752             if (value >> 64 > 0) {
753                 value >>= 64;
754                 result += 8;
755             }
756             if (value >> 32 > 0) {
757                 value >>= 32;
758                 result += 4;
759             }
760             if (value >> 16 > 0) {
761                 value >>= 16;
762                 result += 2;
763             }
764             if (value >> 8 > 0) {
765                 result += 1;
766             }
767         }
768         return result;
769     }
770 
771     /**
772      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
773      * Returns 0 if given 0.
774      */
775     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
776         unchecked {
777             uint256 result = log256(value);
778             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
779         }
780     }
781 }
782 
783 // File: @openzeppelin/contracts/utils/Strings.sol
784 
785 
786 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 
791 /**
792  * @dev String operations.
793  */
794 library Strings {
795     bytes16 private constant _SYMBOLS = "0123456789abcdef";
796     uint8 private constant _ADDRESS_LENGTH = 20;
797 
798     /**
799      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
800      */
801     function toString(uint256 value) internal pure returns (string memory) {
802         unchecked {
803             uint256 length = Math.log10(value) + 1;
804             string memory buffer = new string(length);
805             uint256 ptr;
806             /// @solidity memory-safe-assembly
807             assembly {
808                 ptr := add(buffer, add(32, length))
809             }
810             while (true) {
811                 ptr--;
812                 /// @solidity memory-safe-assembly
813                 assembly {
814                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
815                 }
816                 value /= 10;
817                 if (value == 0) break;
818             }
819             return buffer;
820         }
821     }
822 
823     /**
824      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
825      */
826     function toHexString(uint256 value) internal pure returns (string memory) {
827         unchecked {
828             return toHexString(value, Math.log256(value) + 1);
829         }
830     }
831 
832     /**
833      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
834      */
835     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
836         bytes memory buffer = new bytes(2 * length + 2);
837         buffer[0] = "0";
838         buffer[1] = "x";
839         for (uint256 i = 2 * length + 1; i > 1; --i) {
840             buffer[i] = _SYMBOLS[value & 0xf];
841             value >>= 4;
842         }
843         require(value == 0, "Strings: hex length insufficient");
844         return string(buffer);
845     }
846 
847     /**
848      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
849      */
850     function toHexString(address addr) internal pure returns (string memory) {
851         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
852     }
853 }
854 
855 // File: @openzeppelin/contracts/utils/Address.sol
856 
857 
858 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
859 
860 pragma solidity ^0.8.1;
861 
862 /**
863  * @dev Collection of functions related to the address type
864  */
865 library Address {
866     /**
867      * @dev Returns true if `account` is a contract.
868      *
869      * [IMPORTANT]
870      * ====
871      * It is unsafe to assume that an address for which this function returns
872      * false is an externally-owned account (EOA) and not a contract.
873      *
874      * Among others, `isContract` will return false for the following
875      * types of addresses:
876      *
877      *  - an externally-owned account
878      *  - a contract in construction
879      *  - an address where a contract will be created
880      *  - an address where a contract lived, but was destroyed
881      * ====
882      *
883      * [IMPORTANT]
884      * ====
885      * You shouldn't rely on `isContract` to protect against flash loan attacks!
886      *
887      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
888      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
889      * constructor.
890      * ====
891      */
892     function isContract(address account) internal view returns (bool) {
893         // This method relies on extcodesize/address.code.length, which returns 0
894         // for contracts in construction, since the code is only stored at the end
895         // of the constructor execution.
896 
897         return account.code.length > 0;
898     }
899 
900     /**
901      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
902      * `recipient`, forwarding all available gas and reverting on errors.
903      *
904      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
905      * of certain opcodes, possibly making contracts go over the 2300 gas limit
906      * imposed by `transfer`, making them unable to receive funds via
907      * `transfer`. {sendValue} removes this limitation.
908      *
909      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
910      *
911      * IMPORTANT: because control is transferred to `recipient`, care must be
912      * taken to not create reentrancy vulnerabilities. Consider using
913      * {ReentrancyGuard} or the
914      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
915      */
916     function sendValue(address payable recipient, uint256 amount) internal {
917         require(address(this).balance >= amount, "Address: insufficient balance");
918 
919         (bool success, ) = recipient.call{value: amount}("");
920         require(success, "Address: unable to send value, recipient may have reverted");
921     }
922 
923     /**
924      * @dev Performs a Solidity function call using a low level `call`. A
925      * plain `call` is an unsafe replacement for a function call: use this
926      * function instead.
927      *
928      * If `target` reverts with a revert reason, it is bubbled up by this
929      * function (like regular Solidity function calls).
930      *
931      * Returns the raw returned data. To convert to the expected return value,
932      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
933      *
934      * Requirements:
935      *
936      * - `target` must be a contract.
937      * - calling `target` with `data` must not revert.
938      *
939      * _Available since v3.1._
940      */
941     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
942         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
943     }
944 
945     /**
946      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
947      * `errorMessage` as a fallback revert reason when `target` reverts.
948      *
949      * _Available since v3.1._
950      */
951     function functionCall(
952         address target,
953         bytes memory data,
954         string memory errorMessage
955     ) internal returns (bytes memory) {
956         return functionCallWithValue(target, data, 0, errorMessage);
957     }
958 
959     /**
960      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
961      * but also transferring `value` wei to `target`.
962      *
963      * Requirements:
964      *
965      * - the calling contract must have an ETH balance of at least `value`.
966      * - the called Solidity function must be `payable`.
967      *
968      * _Available since v3.1._
969      */
970     function functionCallWithValue(
971         address target,
972         bytes memory data,
973         uint256 value
974     ) internal returns (bytes memory) {
975         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
976     }
977 
978     /**
979      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
980      * with `errorMessage` as a fallback revert reason when `target` reverts.
981      *
982      * _Available since v3.1._
983      */
984     function functionCallWithValue(
985         address target,
986         bytes memory data,
987         uint256 value,
988         string memory errorMessage
989     ) internal returns (bytes memory) {
990         require(address(this).balance >= value, "Address: insufficient balance for call");
991         (bool success, bytes memory returndata) = target.call{value: value}(data);
992         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
993     }
994 
995     /**
996      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
997      * but performing a static call.
998      *
999      * _Available since v3.3._
1000      */
1001     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1002         return functionStaticCall(target, data, "Address: low-level static call failed");
1003     }
1004 
1005     /**
1006      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1007      * but performing a static call.
1008      *
1009      * _Available since v3.3._
1010      */
1011     function functionStaticCall(
1012         address target,
1013         bytes memory data,
1014         string memory errorMessage
1015     ) internal view returns (bytes memory) {
1016         (bool success, bytes memory returndata) = target.staticcall(data);
1017         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1018     }
1019 
1020     /**
1021      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1022      * but performing a delegate call.
1023      *
1024      * _Available since v3.4._
1025      */
1026     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1027         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1028     }
1029 
1030     /**
1031      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1032      * but performing a delegate call.
1033      *
1034      * _Available since v3.4._
1035      */
1036     function functionDelegateCall(
1037         address target,
1038         bytes memory data,
1039         string memory errorMessage
1040     ) internal returns (bytes memory) {
1041         (bool success, bytes memory returndata) = target.delegatecall(data);
1042         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1043     }
1044 
1045     /**
1046      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1047      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1048      *
1049      * _Available since v4.8._
1050      */
1051     function verifyCallResultFromTarget(
1052         address target,
1053         bool success,
1054         bytes memory returndata,
1055         string memory errorMessage
1056     ) internal view returns (bytes memory) {
1057         if (success) {
1058             if (returndata.length == 0) {
1059                 // only check isContract if the call was successful and the return data is empty
1060                 // otherwise we already know that it was a contract
1061                 require(isContract(target), "Address: call to non-contract");
1062             }
1063             return returndata;
1064         } else {
1065             _revert(returndata, errorMessage);
1066         }
1067     }
1068 
1069     /**
1070      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1071      * revert reason or using the provided one.
1072      *
1073      * _Available since v4.3._
1074      */
1075     function verifyCallResult(
1076         bool success,
1077         bytes memory returndata,
1078         string memory errorMessage
1079     ) internal pure returns (bytes memory) {
1080         if (success) {
1081             return returndata;
1082         } else {
1083             _revert(returndata, errorMessage);
1084         }
1085     }
1086 
1087     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1088         // Look for revert reason and bubble it up if present
1089         if (returndata.length > 0) {
1090             // The easiest way to bubble the revert reason is using memory via assembly
1091             /// @solidity memory-safe-assembly
1092             assembly {
1093                 let returndata_size := mload(returndata)
1094                 revert(add(32, returndata), returndata_size)
1095             }
1096         } else {
1097             revert(errorMessage);
1098         }
1099     }
1100 }
1101 
1102 // File: erc721a/contracts/IERC721A.sol
1103 
1104 
1105 // ERC721A Contracts v4.2.3
1106 // Creator: Chiru Labs
1107 
1108 pragma solidity ^0.8.4;
1109 
1110 /**
1111  * @dev Interface of ERC721A.
1112  */
1113 interface IERC721A {
1114     /**
1115      * The caller must own the token or be an approved operator.
1116      */
1117     error ApprovalCallerNotOwnerNorApproved();
1118 
1119     /**
1120      * The token does not exist.
1121      */
1122     error ApprovalQueryForNonexistentToken();
1123 
1124     /**
1125      * Cannot query the balance for the zero address.
1126      */
1127     error BalanceQueryForZeroAddress();
1128 
1129     /**
1130      * Cannot mint to the zero address.
1131      */
1132     error MintToZeroAddress();
1133 
1134     /**
1135      * The quantity of tokens minted must be more than zero.
1136      */
1137     error MintZeroQuantity();
1138 
1139     /**
1140      * The token does not exist.
1141      */
1142     error OwnerQueryForNonexistentToken();
1143 
1144     /**
1145      * The caller must own the token or be an approved operator.
1146      */
1147     error TransferCallerNotOwnerNorApproved();
1148 
1149     /**
1150      * The token must be owned by `from`.
1151      */
1152     error TransferFromIncorrectOwner();
1153 
1154     /**
1155      * Cannot safely transfer to a contract that does not implement the
1156      * ERC721Receiver interface.
1157      */
1158     error TransferToNonERC721ReceiverImplementer();
1159 
1160     /**
1161      * Cannot transfer to the zero address.
1162      */
1163     error TransferToZeroAddress();
1164 
1165     /**
1166      * The token does not exist.
1167      */
1168     error URIQueryForNonexistentToken();
1169 
1170     /**
1171      * The `quantity` minted with ERC2309 exceeds the safety limit.
1172      */
1173     error MintERC2309QuantityExceedsLimit();
1174 
1175     /**
1176      * The `extraData` cannot be set on an unintialized ownership slot.
1177      */
1178     error OwnershipNotInitializedForExtraData();
1179 
1180     // =============================================================
1181     //                            STRUCTS
1182     // =============================================================
1183 
1184     struct TokenOwnership {
1185         // The address of the owner.
1186         address addr;
1187         // Stores the start time of ownership with minimal overhead for tokenomics.
1188         uint64 startTimestamp;
1189         // Whether the token has been burned.
1190         bool burned;
1191         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1192         uint24 extraData;
1193     }
1194 
1195     // =============================================================
1196     //                         TOKEN COUNTERS
1197     // =============================================================
1198 
1199     /**
1200      * @dev Returns the total number of tokens in existence.
1201      * Burned tokens will reduce the count.
1202      * To get the total number of tokens minted, please see {_totalMinted}.
1203      */
1204     function totalSupply() external view returns (uint256);
1205 
1206     // =============================================================
1207     //                            IERC165
1208     // =============================================================
1209 
1210     /**
1211      * @dev Returns true if this contract implements the interface defined by
1212      * `interfaceId`. See the corresponding
1213      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1214      * to learn more about how these ids are created.
1215      *
1216      * This function call must use less than 30000 gas.
1217      */
1218     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1219 
1220     // =============================================================
1221     //                            IERC721
1222     // =============================================================
1223 
1224     /**
1225      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1226      */
1227     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1228 
1229     /**
1230      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1231      */
1232     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1233 
1234     /**
1235      * @dev Emitted when `owner` enables or disables
1236      * (`approved`) `operator` to manage all of its assets.
1237      */
1238     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1239 
1240     /**
1241      * @dev Returns the number of tokens in `owner`'s account.
1242      */
1243     function balanceOf(address owner) external view returns (uint256 balance);
1244 
1245     /**
1246      * @dev Returns the owner of the `tokenId` token.
1247      *
1248      * Requirements:
1249      *
1250      * - `tokenId` must exist.
1251      */
1252     function ownerOf(uint256 tokenId) external view returns (address owner);
1253 
1254     /**
1255      * @dev Safely transfers `tokenId` token from `from` to `to`,
1256      * checking first that contract recipients are aware of the ERC721 protocol
1257      * to prevent tokens from being forever locked.
1258      *
1259      * Requirements:
1260      *
1261      * - `from` cannot be the zero address.
1262      * - `to` cannot be the zero address.
1263      * - `tokenId` token must exist and be owned by `from`.
1264      * - If the caller is not `from`, it must be have been allowed to move
1265      * this token by either {approve} or {setApprovalForAll}.
1266      * - If `to` refers to a smart contract, it must implement
1267      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1268      *
1269      * Emits a {Transfer} event.
1270      */
1271     function safeTransferFrom(
1272         address from,
1273         address to,
1274         uint256 tokenId,
1275         bytes calldata data
1276     ) external payable;
1277 
1278     /**
1279      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1280      */
1281     function safeTransferFrom(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) external payable;
1286 
1287     /**
1288      * @dev Transfers `tokenId` from `from` to `to`.
1289      *
1290      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1291      * whenever possible.
1292      *
1293      * Requirements:
1294      *
1295      * - `from` cannot be the zero address.
1296      * - `to` cannot be the zero address.
1297      * - `tokenId` token must be owned by `from`.
1298      * - If the caller is not `from`, it must be approved to move this token
1299      * by either {approve} or {setApprovalForAll}.
1300      *
1301      * Emits a {Transfer} event.
1302      */
1303     function transferFrom(
1304         address from,
1305         address to,
1306         uint256 tokenId
1307     ) external payable;
1308 
1309     /**
1310      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1311      * The approval is cleared when the token is transferred.
1312      *
1313      * Only a single account can be approved at a time, so approving the
1314      * zero address clears previous approvals.
1315      *
1316      * Requirements:
1317      *
1318      * - The caller must own the token or be an approved operator.
1319      * - `tokenId` must exist.
1320      *
1321      * Emits an {Approval} event.
1322      */
1323     function approve(address to, uint256 tokenId) external payable;
1324 
1325     /**
1326      * @dev Approve or remove `operator` as an operator for the caller.
1327      * Operators can call {transferFrom} or {safeTransferFrom}
1328      * for any token owned by the caller.
1329      *
1330      * Requirements:
1331      *
1332      * - The `operator` cannot be the caller.
1333      *
1334      * Emits an {ApprovalForAll} event.
1335      */
1336     function setApprovalForAll(address operator, bool _approved) external;
1337 
1338     /**
1339      * @dev Returns the account approved for `tokenId` token.
1340      *
1341      * Requirements:
1342      *
1343      * - `tokenId` must exist.
1344      */
1345     function getApproved(uint256 tokenId) external view returns (address operator);
1346 
1347     /**
1348      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1349      *
1350      * See {setApprovalForAll}.
1351      */
1352     function isApprovedForAll(address owner, address operator) external view returns (bool);
1353 
1354     // =============================================================
1355     //                        IERC721Metadata
1356     // =============================================================
1357 
1358     /**
1359      * @dev Returns the token collection name.
1360      */
1361     function name() external view returns (string memory);
1362 
1363     /**
1364      * @dev Returns the token collection symbol.
1365      */
1366     function symbol() external view returns (string memory);
1367 
1368     /**
1369      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1370      */
1371     function tokenURI(uint256 tokenId) external view returns (string memory);
1372 
1373     // =============================================================
1374     //                           IERC2309
1375     // =============================================================
1376 
1377     /**
1378      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1379      * (inclusive) is transferred from `from` to `to`, as defined in the
1380      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1381      *
1382      * See {_mintERC2309} for more details.
1383      */
1384     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1385 }
1386 
1387 // File: erc721a/contracts/ERC721A.sol
1388 
1389 
1390 // ERC721A Contracts v4.2.3
1391 // Creator: Chiru Labs
1392 
1393 pragma solidity ^0.8.4;
1394 
1395 
1396 /**
1397  * @dev Interface of ERC721 token receiver.
1398  */
1399 interface ERC721A__IERC721Receiver {
1400     function onERC721Received(
1401         address operator,
1402         address from,
1403         uint256 tokenId,
1404         bytes calldata data
1405     ) external returns (bytes4);
1406 }
1407 
1408 /**
1409  * @title ERC721A
1410  *
1411  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1412  * Non-Fungible Token Standard, including the Metadata extension.
1413  * Optimized for lower gas during batch mints.
1414  *
1415  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1416  * starting from `_startTokenId()`.
1417  *
1418  * Assumptions:
1419  *
1420  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1421  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1422  */
1423 contract ERC721A is IERC721A {
1424     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1425     struct TokenApprovalRef {
1426         address value;
1427     }
1428 
1429     // =============================================================
1430     //                           CONSTANTS
1431     // =============================================================
1432 
1433     // Mask of an entry in packed address data.
1434     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1435 
1436     // The bit position of `numberMinted` in packed address data.
1437     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1438 
1439     // The bit position of `numberBurned` in packed address data.
1440     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1441 
1442     // The bit position of `aux` in packed address data.
1443     uint256 private constant _BITPOS_AUX = 192;
1444 
1445     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1446     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1447 
1448     // The bit position of `startTimestamp` in packed ownership.
1449     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1450 
1451     // The bit mask of the `burned` bit in packed ownership.
1452     uint256 private constant _BITMASK_BURNED = 1 << 224;
1453 
1454     // The bit position of the `nextInitialized` bit in packed ownership.
1455     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1456 
1457     // The bit mask of the `nextInitialized` bit in packed ownership.
1458     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1459 
1460     // The bit position of `extraData` in packed ownership.
1461     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1462 
1463     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1464     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1465 
1466     // The mask of the lower 160 bits for addresses.
1467     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1468 
1469     // The maximum `quantity` that can be minted with {_mintERC2309}.
1470     // This limit is to prevent overflows on the address data entries.
1471     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1472     // is required to cause an overflow, which is unrealistic.
1473     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1474 
1475     // The `Transfer` event signature is given by:
1476     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1477     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1478         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1479 
1480     // =============================================================
1481     //                            STORAGE
1482     // =============================================================
1483 
1484     // The next token ID to be minted.
1485     uint256 private _currentIndex;
1486 
1487     // The number of tokens burned.
1488     uint256 private _burnCounter;
1489 
1490     // Token name
1491     string private _name;
1492 
1493     // Token symbol
1494     string private _symbol;
1495 
1496     // Mapping from token ID to ownership details
1497     // An empty struct value does not necessarily mean the token is unowned.
1498     // See {_packedOwnershipOf} implementation for details.
1499     //
1500     // Bits Layout:
1501     // - [0..159]   `addr`
1502     // - [160..223] `startTimestamp`
1503     // - [224]      `burned`
1504     // - [225]      `nextInitialized`
1505     // - [232..255] `extraData`
1506     mapping(uint256 => uint256) private _packedOwnerships;
1507 
1508     // Mapping owner address to address data.
1509     //
1510     // Bits Layout:
1511     // - [0..63]    `balance`
1512     // - [64..127]  `numberMinted`
1513     // - [128..191] `numberBurned`
1514     // - [192..255] `aux`
1515     mapping(address => uint256) private _packedAddressData;
1516 
1517     // Mapping from token ID to approved address.
1518     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1519 
1520     // Mapping from owner to operator approvals
1521     mapping(address => mapping(address => bool)) private _operatorApprovals;
1522 
1523     // =============================================================
1524     //                          CONSTRUCTOR
1525     // =============================================================
1526 
1527     constructor(string memory name_, string memory symbol_) {
1528         _name = name_;
1529         _symbol = symbol_;
1530         _currentIndex = _startTokenId();
1531     }
1532 
1533     // =============================================================
1534     //                   TOKEN COUNTING OPERATIONS
1535     // =============================================================
1536 
1537     /**
1538      * @dev Returns the starting token ID.
1539      * To change the starting token ID, please override this function.
1540      */
1541     function _startTokenId() internal view virtual returns (uint256) {
1542         return 0;
1543     }
1544 
1545     /**
1546      * @dev Returns the next token ID to be minted.
1547      */
1548     function _nextTokenId() internal view virtual returns (uint256) {
1549         return _currentIndex;
1550     }
1551 
1552     /**
1553      * @dev Returns the total number of tokens in existence.
1554      * Burned tokens will reduce the count.
1555      * To get the total number of tokens minted, please see {_totalMinted}.
1556      */
1557     function totalSupply() public view virtual override returns (uint256) {
1558         // Counter underflow is impossible as _burnCounter cannot be incremented
1559         // more than `_currentIndex - _startTokenId()` times.
1560         unchecked {
1561             return _currentIndex - _burnCounter - _startTokenId();
1562         }
1563     }
1564 
1565     /**
1566      * @dev Returns the total amount of tokens minted in the contract.
1567      */
1568     function _totalMinted() internal view virtual returns (uint256) {
1569         // Counter underflow is impossible as `_currentIndex` does not decrement,
1570         // and it is initialized to `_startTokenId()`.
1571         unchecked {
1572             return _currentIndex - _startTokenId();
1573         }
1574     }
1575 
1576     /**
1577      * @dev Returns the total number of tokens burned.
1578      */
1579     function _totalBurned() internal view virtual returns (uint256) {
1580         return _burnCounter;
1581     }
1582 
1583     // =============================================================
1584     //                    ADDRESS DATA OPERATIONS
1585     // =============================================================
1586 
1587     /**
1588      * @dev Returns the number of tokens in `owner`'s account.
1589      */
1590     function balanceOf(address owner) public view virtual override returns (uint256) {
1591         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1592         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1593     }
1594 
1595     /**
1596      * Returns the number of tokens minted by `owner`.
1597      */
1598     function _numberMinted(address owner) internal view returns (uint256) {
1599         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1600     }
1601 
1602     /**
1603      * Returns the number of tokens burned by or on behalf of `owner`.
1604      */
1605     function _numberBurned(address owner) internal view returns (uint256) {
1606         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1607     }
1608 
1609     /**
1610      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1611      */
1612     function _getAux(address owner) internal view returns (uint64) {
1613         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1614     }
1615 
1616     /**
1617      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1618      * If there are multiple variables, please pack them into a uint64.
1619      */
1620     function _setAux(address owner, uint64 aux) internal virtual {
1621         uint256 packed = _packedAddressData[owner];
1622         uint256 auxCasted;
1623         // Cast `aux` with assembly to avoid redundant masking.
1624         assembly {
1625             auxCasted := aux
1626         }
1627         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1628         _packedAddressData[owner] = packed;
1629     }
1630 
1631     // =============================================================
1632     //                            IERC165
1633     // =============================================================
1634 
1635     /**
1636      * @dev Returns true if this contract implements the interface defined by
1637      * `interfaceId`. See the corresponding
1638      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1639      * to learn more about how these ids are created.
1640      *
1641      * This function call must use less than 30000 gas.
1642      */
1643     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1644         // The interface IDs are constants representing the first 4 bytes
1645         // of the XOR of all function selectors in the interface.
1646         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1647         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1648         return
1649             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1650             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1651             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1652     }
1653 
1654     // =============================================================
1655     //                        IERC721Metadata
1656     // =============================================================
1657 
1658     /**
1659      * @dev Returns the token collection name.
1660      */
1661     function name() public view virtual override returns (string memory) {
1662         return _name;
1663     }
1664 
1665     /**
1666      * @dev Returns the token collection symbol.
1667      */
1668     function symbol() public view virtual override returns (string memory) {
1669         return _symbol;
1670     }
1671 
1672     /**
1673      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1674      */
1675     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1676         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1677 
1678         string memory baseURI = _baseURI();
1679         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1680     }
1681 
1682     /**
1683      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1684      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1685      * by default, it can be overridden in child contracts.
1686      */
1687     function _baseURI() internal view virtual returns (string memory) {
1688         return '';
1689     }
1690 
1691     // =============================================================
1692     //                     OWNERSHIPS OPERATIONS
1693     // =============================================================
1694 
1695     /**
1696      * @dev Returns the owner of the `tokenId` token.
1697      *
1698      * Requirements:
1699      *
1700      * - `tokenId` must exist.
1701      */
1702     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1703         return address(uint160(_packedOwnershipOf(tokenId)));
1704     }
1705 
1706     /**
1707      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1708      * It gradually moves to O(1) as tokens get transferred around over time.
1709      */
1710     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1711         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1712     }
1713 
1714     /**
1715      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1716      */
1717     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1718         return _unpackedOwnership(_packedOwnerships[index]);
1719     }
1720 
1721     /**
1722      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1723      */
1724     function _initializeOwnershipAt(uint256 index) internal virtual {
1725         if (_packedOwnerships[index] == 0) {
1726             _packedOwnerships[index] = _packedOwnershipOf(index);
1727         }
1728     }
1729 
1730     /**
1731      * Returns the packed ownership data of `tokenId`.
1732      */
1733     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1734         uint256 curr = tokenId;
1735 
1736         unchecked {
1737             if (_startTokenId() <= curr)
1738                 if (curr < _currentIndex) {
1739                     uint256 packed = _packedOwnerships[curr];
1740                     // If not burned.
1741                     if (packed & _BITMASK_BURNED == 0) {
1742                         // Invariant:
1743                         // There will always be an initialized ownership slot
1744                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1745                         // before an unintialized ownership slot
1746                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1747                         // Hence, `curr` will not underflow.
1748                         //
1749                         // We can directly compare the packed value.
1750                         // If the address is zero, packed will be zero.
1751                         while (packed == 0) {
1752                             packed = _packedOwnerships[--curr];
1753                         }
1754                         return packed;
1755                     }
1756                 }
1757         }
1758         revert OwnerQueryForNonexistentToken();
1759     }
1760 
1761     /**
1762      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1763      */
1764     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1765         ownership.addr = address(uint160(packed));
1766         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1767         ownership.burned = packed & _BITMASK_BURNED != 0;
1768         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1769     }
1770 
1771     /**
1772      * @dev Packs ownership data into a single uint256.
1773      */
1774     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1775         assembly {
1776             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1777             owner := and(owner, _BITMASK_ADDRESS)
1778             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1779             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1780         }
1781     }
1782 
1783     /**
1784      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1785      */
1786     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1787         // For branchless setting of the `nextInitialized` flag.
1788         assembly {
1789             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1790             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1791         }
1792     }
1793 
1794     // =============================================================
1795     //                      APPROVAL OPERATIONS
1796     // =============================================================
1797 
1798     /**
1799      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1800      * The approval is cleared when the token is transferred.
1801      *
1802      * Only a single account can be approved at a time, so approving the
1803      * zero address clears previous approvals.
1804      *
1805      * Requirements:
1806      *
1807      * - The caller must own the token or be an approved operator.
1808      * - `tokenId` must exist.
1809      *
1810      * Emits an {Approval} event.
1811      */
1812     function approve(address to, uint256 tokenId) public payable virtual override {
1813         address owner = ownerOf(tokenId);
1814 
1815         if (_msgSenderERC721A() != owner)
1816             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1817                 revert ApprovalCallerNotOwnerNorApproved();
1818             }
1819 
1820         _tokenApprovals[tokenId].value = to;
1821         emit Approval(owner, to, tokenId);
1822     }
1823 
1824     /**
1825      * @dev Returns the account approved for `tokenId` token.
1826      *
1827      * Requirements:
1828      *
1829      * - `tokenId` must exist.
1830      */
1831     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1832         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1833 
1834         return _tokenApprovals[tokenId].value;
1835     }
1836 
1837     /**
1838      * @dev Approve or remove `operator` as an operator for the caller.
1839      * Operators can call {transferFrom} or {safeTransferFrom}
1840      * for any token owned by the caller.
1841      *
1842      * Requirements:
1843      *
1844      * - The `operator` cannot be the caller.
1845      *
1846      * Emits an {ApprovalForAll} event.
1847      */
1848     function setApprovalForAll(address operator, bool approved) public virtual override {
1849         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1850         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1851     }
1852 
1853     /**
1854      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1855      *
1856      * See {setApprovalForAll}.
1857      */
1858     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1859         return _operatorApprovals[owner][operator];
1860     }
1861 
1862     /**
1863      * @dev Returns whether `tokenId` exists.
1864      *
1865      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1866      *
1867      * Tokens start existing when they are minted. See {_mint}.
1868      */
1869     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1870         return
1871             _startTokenId() <= tokenId &&
1872             tokenId < _currentIndex && // If within bounds,
1873             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1874     }
1875 
1876     /**
1877      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1878      */
1879     function _isSenderApprovedOrOwner(
1880         address approvedAddress,
1881         address owner,
1882         address msgSender
1883     ) private pure returns (bool result) {
1884         assembly {
1885             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1886             owner := and(owner, _BITMASK_ADDRESS)
1887             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1888             msgSender := and(msgSender, _BITMASK_ADDRESS)
1889             // `msgSender == owner || msgSender == approvedAddress`.
1890             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1891         }
1892     }
1893 
1894     /**
1895      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1896      */
1897     function _getApprovedSlotAndAddress(uint256 tokenId)
1898         private
1899         view
1900         returns (uint256 approvedAddressSlot, address approvedAddress)
1901     {
1902         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1903         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1904         assembly {
1905             approvedAddressSlot := tokenApproval.slot
1906             approvedAddress := sload(approvedAddressSlot)
1907         }
1908     }
1909 
1910     // =============================================================
1911     //                      TRANSFER OPERATIONS
1912     // =============================================================
1913 
1914     /**
1915      * @dev Transfers `tokenId` from `from` to `to`.
1916      *
1917      * Requirements:
1918      *
1919      * - `from` cannot be the zero address.
1920      * - `to` cannot be the zero address.
1921      * - `tokenId` token must be owned by `from`.
1922      * - If the caller is not `from`, it must be approved to move this token
1923      * by either {approve} or {setApprovalForAll}.
1924      *
1925      * Emits a {Transfer} event.
1926      */
1927     function transferFrom(
1928         address from,
1929         address to,
1930         uint256 tokenId
1931     ) public payable virtual override {
1932         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1933 
1934         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1935 
1936         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1937 
1938         // The nested ifs save around 20+ gas over a compound boolean condition.
1939         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1940             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1941 
1942         if (to == address(0)) revert TransferToZeroAddress();
1943 
1944         _beforeTokenTransfers(from, to, tokenId, 1);
1945 
1946         // Clear approvals from the previous owner.
1947         assembly {
1948             if approvedAddress {
1949                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1950                 sstore(approvedAddressSlot, 0)
1951             }
1952         }
1953 
1954         // Underflow of the sender's balance is impossible because we check for
1955         // ownership above and the recipient's balance can't realistically overflow.
1956         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1957         unchecked {
1958             // We can directly increment and decrement the balances.
1959             --_packedAddressData[from]; // Updates: `balance -= 1`.
1960             ++_packedAddressData[to]; // Updates: `balance += 1`.
1961 
1962             // Updates:
1963             // - `address` to the next owner.
1964             // - `startTimestamp` to the timestamp of transfering.
1965             // - `burned` to `false`.
1966             // - `nextInitialized` to `true`.
1967             _packedOwnerships[tokenId] = _packOwnershipData(
1968                 to,
1969                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1970             );
1971 
1972             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1973             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1974                 uint256 nextTokenId = tokenId + 1;
1975                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1976                 if (_packedOwnerships[nextTokenId] == 0) {
1977                     // If the next slot is within bounds.
1978                     if (nextTokenId != _currentIndex) {
1979                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1980                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1981                     }
1982                 }
1983             }
1984         }
1985 
1986         emit Transfer(from, to, tokenId);
1987         _afterTokenTransfers(from, to, tokenId, 1);
1988     }
1989 
1990     /**
1991      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1992      */
1993     function safeTransferFrom(
1994         address from,
1995         address to,
1996         uint256 tokenId
1997     ) public payable virtual override {
1998         safeTransferFrom(from, to, tokenId, '');
1999     }
2000 
2001     /**
2002      * @dev Safely transfers `tokenId` token from `from` to `to`.
2003      *
2004      * Requirements:
2005      *
2006      * - `from` cannot be the zero address.
2007      * - `to` cannot be the zero address.
2008      * - `tokenId` token must exist and be owned by `from`.
2009      * - If the caller is not `from`, it must be approved to move this token
2010      * by either {approve} or {setApprovalForAll}.
2011      * - If `to` refers to a smart contract, it must implement
2012      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2013      *
2014      * Emits a {Transfer} event.
2015      */
2016     function safeTransferFrom(
2017         address from,
2018         address to,
2019         uint256 tokenId,
2020         bytes memory _data
2021     ) public payable virtual override {
2022         transferFrom(from, to, tokenId);
2023         if (to.code.length != 0)
2024             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2025                 revert TransferToNonERC721ReceiverImplementer();
2026             }
2027     }
2028 
2029     /**
2030      * @dev Hook that is called before a set of serially-ordered token IDs
2031      * are about to be transferred. This includes minting.
2032      * And also called before burning one token.
2033      *
2034      * `startTokenId` - the first token ID to be transferred.
2035      * `quantity` - the amount to be transferred.
2036      *
2037      * Calling conditions:
2038      *
2039      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2040      * transferred to `to`.
2041      * - When `from` is zero, `tokenId` will be minted for `to`.
2042      * - When `to` is zero, `tokenId` will be burned by `from`.
2043      * - `from` and `to` are never both zero.
2044      */
2045     function _beforeTokenTransfers(
2046         address from,
2047         address to,
2048         uint256 startTokenId,
2049         uint256 quantity
2050     ) internal virtual {}
2051 
2052     /**
2053      * @dev Hook that is called after a set of serially-ordered token IDs
2054      * have been transferred. This includes minting.
2055      * And also called after one token has been burned.
2056      *
2057      * `startTokenId` - the first token ID to be transferred.
2058      * `quantity` - the amount to be transferred.
2059      *
2060      * Calling conditions:
2061      *
2062      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2063      * transferred to `to`.
2064      * - When `from` is zero, `tokenId` has been minted for `to`.
2065      * - When `to` is zero, `tokenId` has been burned by `from`.
2066      * - `from` and `to` are never both zero.
2067      */
2068     function _afterTokenTransfers(
2069         address from,
2070         address to,
2071         uint256 startTokenId,
2072         uint256 quantity
2073     ) internal virtual {}
2074 
2075     /**
2076      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2077      *
2078      * `from` - Previous owner of the given token ID.
2079      * `to` - Target address that will receive the token.
2080      * `tokenId` - Token ID to be transferred.
2081      * `_data` - Optional data to send along with the call.
2082      *
2083      * Returns whether the call correctly returned the expected magic value.
2084      */
2085     function _checkContractOnERC721Received(
2086         address from,
2087         address to,
2088         uint256 tokenId,
2089         bytes memory _data
2090     ) private returns (bool) {
2091         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2092             bytes4 retval
2093         ) {
2094             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2095         } catch (bytes memory reason) {
2096             if (reason.length == 0) {
2097                 revert TransferToNonERC721ReceiverImplementer();
2098             } else {
2099                 assembly {
2100                     revert(add(32, reason), mload(reason))
2101                 }
2102             }
2103         }
2104     }
2105 
2106     // =============================================================
2107     //                        MINT OPERATIONS
2108     // =============================================================
2109 
2110     /**
2111      * @dev Mints `quantity` tokens and transfers them to `to`.
2112      *
2113      * Requirements:
2114      *
2115      * - `to` cannot be the zero address.
2116      * - `quantity` must be greater than 0.
2117      *
2118      * Emits a {Transfer} event for each mint.
2119      */
2120     function _mint(address to, uint256 quantity) internal virtual {
2121         uint256 startTokenId = _currentIndex;
2122         if (quantity == 0) revert MintZeroQuantity();
2123 
2124         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2125 
2126         // Overflows are incredibly unrealistic.
2127         // `balance` and `numberMinted` have a maximum limit of 2**64.
2128         // `tokenId` has a maximum limit of 2**256.
2129         unchecked {
2130             // Updates:
2131             // - `balance += quantity`.
2132             // - `numberMinted += quantity`.
2133             //
2134             // We can directly add to the `balance` and `numberMinted`.
2135             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2136 
2137             // Updates:
2138             // - `address` to the owner.
2139             // - `startTimestamp` to the timestamp of minting.
2140             // - `burned` to `false`.
2141             // - `nextInitialized` to `quantity == 1`.
2142             _packedOwnerships[startTokenId] = _packOwnershipData(
2143                 to,
2144                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2145             );
2146 
2147             uint256 toMasked;
2148             uint256 end = startTokenId + quantity;
2149 
2150             // Use assembly to loop and emit the `Transfer` event for gas savings.
2151             // The duplicated `log4` removes an extra check and reduces stack juggling.
2152             // The assembly, together with the surrounding Solidity code, have been
2153             // delicately arranged to nudge the compiler into producing optimized opcodes.
2154             assembly {
2155                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2156                 toMasked := and(to, _BITMASK_ADDRESS)
2157                 // Emit the `Transfer` event.
2158                 log4(
2159                     0, // Start of data (0, since no data).
2160                     0, // End of data (0, since no data).
2161                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2162                     0, // `address(0)`.
2163                     toMasked, // `to`.
2164                     startTokenId // `tokenId`.
2165                 )
2166 
2167                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2168                 // that overflows uint256 will make the loop run out of gas.
2169                 // The compiler will optimize the `iszero` away for performance.
2170                 for {
2171                     let tokenId := add(startTokenId, 1)
2172                 } iszero(eq(tokenId, end)) {
2173                     tokenId := add(tokenId, 1)
2174                 } {
2175                     // Emit the `Transfer` event. Similar to above.
2176                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2177                 }
2178             }
2179             if (toMasked == 0) revert MintToZeroAddress();
2180 
2181             _currentIndex = end;
2182         }
2183         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2184     }
2185 
2186     /**
2187      * @dev Mints `quantity` tokens and transfers them to `to`.
2188      *
2189      * This function is intended for efficient minting only during contract creation.
2190      *
2191      * It emits only one {ConsecutiveTransfer} as defined in
2192      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2193      * instead of a sequence of {Transfer} event(s).
2194      *
2195      * Calling this function outside of contract creation WILL make your contract
2196      * non-compliant with the ERC721 standard.
2197      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2198      * {ConsecutiveTransfer} event is only permissible during contract creation.
2199      *
2200      * Requirements:
2201      *
2202      * - `to` cannot be the zero address.
2203      * - `quantity` must be greater than 0.
2204      *
2205      * Emits a {ConsecutiveTransfer} event.
2206      */
2207     function _mintERC2309(address to, uint256 quantity) internal virtual {
2208         uint256 startTokenId = _currentIndex;
2209         if (to == address(0)) revert MintToZeroAddress();
2210         if (quantity == 0) revert MintZeroQuantity();
2211         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2212 
2213         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2214 
2215         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2216         unchecked {
2217             // Updates:
2218             // - `balance += quantity`.
2219             // - `numberMinted += quantity`.
2220             //
2221             // We can directly add to the `balance` and `numberMinted`.
2222             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2223 
2224             // Updates:
2225             // - `address` to the owner.
2226             // - `startTimestamp` to the timestamp of minting.
2227             // - `burned` to `false`.
2228             // - `nextInitialized` to `quantity == 1`.
2229             _packedOwnerships[startTokenId] = _packOwnershipData(
2230                 to,
2231                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2232             );
2233 
2234             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2235 
2236             _currentIndex = startTokenId + quantity;
2237         }
2238         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2239     }
2240 
2241     /**
2242      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2243      *
2244      * Requirements:
2245      *
2246      * - If `to` refers to a smart contract, it must implement
2247      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2248      * - `quantity` must be greater than 0.
2249      *
2250      * See {_mint}.
2251      *
2252      * Emits a {Transfer} event for each mint.
2253      */
2254     function _safeMint(
2255         address to,
2256         uint256 quantity,
2257         bytes memory _data
2258     ) internal virtual {
2259         _mint(to, quantity);
2260 
2261         unchecked {
2262             if (to.code.length != 0) {
2263                 uint256 end = _currentIndex;
2264                 uint256 index = end - quantity;
2265                 do {
2266                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2267                         revert TransferToNonERC721ReceiverImplementer();
2268                     }
2269                 } while (index < end);
2270                 // Reentrancy protection.
2271                 if (_currentIndex != end) revert();
2272             }
2273         }
2274     }
2275 
2276     /**
2277      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2278      */
2279     function _safeMint(address to, uint256 quantity) internal virtual {
2280         _safeMint(to, quantity, '');
2281     }
2282 
2283     // =============================================================
2284     //                        BURN OPERATIONS
2285     // =============================================================
2286 
2287     /**
2288      * @dev Equivalent to `_burn(tokenId, false)`.
2289      */
2290     function _burn(uint256 tokenId) internal virtual {
2291         _burn(tokenId, false);
2292     }
2293 
2294     /**
2295      * @dev Destroys `tokenId`.
2296      * The approval is cleared when the token is burned.
2297      *
2298      * Requirements:
2299      *
2300      * - `tokenId` must exist.
2301      *
2302      * Emits a {Transfer} event.
2303      */
2304     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2305         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2306 
2307         address from = address(uint160(prevOwnershipPacked));
2308 
2309         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2310 
2311         if (approvalCheck) {
2312             // The nested ifs save around 20+ gas over a compound boolean condition.
2313             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2314                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2315         }
2316 
2317         _beforeTokenTransfers(from, address(0), tokenId, 1);
2318 
2319         // Clear approvals from the previous owner.
2320         assembly {
2321             if approvedAddress {
2322                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2323                 sstore(approvedAddressSlot, 0)
2324             }
2325         }
2326 
2327         // Underflow of the sender's balance is impossible because we check for
2328         // ownership above and the recipient's balance can't realistically overflow.
2329         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2330         unchecked {
2331             // Updates:
2332             // - `balance -= 1`.
2333             // - `numberBurned += 1`.
2334             //
2335             // We can directly decrement the balance, and increment the number burned.
2336             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2337             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2338 
2339             // Updates:
2340             // - `address` to the last owner.
2341             // - `startTimestamp` to the timestamp of burning.
2342             // - `burned` to `true`.
2343             // - `nextInitialized` to `true`.
2344             _packedOwnerships[tokenId] = _packOwnershipData(
2345                 from,
2346                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2347             );
2348 
2349             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2350             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2351                 uint256 nextTokenId = tokenId + 1;
2352                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2353                 if (_packedOwnerships[nextTokenId] == 0) {
2354                     // If the next slot is within bounds.
2355                     if (nextTokenId != _currentIndex) {
2356                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2357                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2358                     }
2359                 }
2360             }
2361         }
2362 
2363         emit Transfer(from, address(0), tokenId);
2364         _afterTokenTransfers(from, address(0), tokenId, 1);
2365 
2366         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2367         unchecked {
2368             _burnCounter++;
2369         }
2370     }
2371 
2372     // =============================================================
2373     //                     EXTRA DATA OPERATIONS
2374     // =============================================================
2375 
2376     /**
2377      * @dev Directly sets the extra data for the ownership data `index`.
2378      */
2379     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2380         uint256 packed = _packedOwnerships[index];
2381         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2382         uint256 extraDataCasted;
2383         // Cast `extraData` with assembly to avoid redundant masking.
2384         assembly {
2385             extraDataCasted := extraData
2386         }
2387         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2388         _packedOwnerships[index] = packed;
2389     }
2390 
2391     /**
2392      * @dev Called during each token transfer to set the 24bit `extraData` field.
2393      * Intended to be overridden by the cosumer contract.
2394      *
2395      * `previousExtraData` - the value of `extraData` before transfer.
2396      *
2397      * Calling conditions:
2398      *
2399      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2400      * transferred to `to`.
2401      * - When `from` is zero, `tokenId` will be minted for `to`.
2402      * - When `to` is zero, `tokenId` will be burned by `from`.
2403      * - `from` and `to` are never both zero.
2404      */
2405     function _extraData(
2406         address from,
2407         address to,
2408         uint24 previousExtraData
2409     ) internal view virtual returns (uint24) {}
2410 
2411     /**
2412      * @dev Returns the next extra data for the packed ownership data.
2413      * The returned result is shifted into position.
2414      */
2415     function _nextExtraData(
2416         address from,
2417         address to,
2418         uint256 prevOwnershipPacked
2419     ) private view returns (uint256) {
2420         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2421         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2422     }
2423 
2424     // =============================================================
2425     //                       OTHER OPERATIONS
2426     // =============================================================
2427 
2428     /**
2429      * @dev Returns the message sender (defaults to `msg.sender`).
2430      *
2431      * If you are writing GSN compatible contracts, you need to override this function.
2432      */
2433     function _msgSenderERC721A() internal view virtual returns (address) {
2434         return msg.sender;
2435     }
2436 
2437     /**
2438      * @dev Converts a uint256 to its ASCII string decimal representation.
2439      */
2440     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2441         assembly {
2442             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2443             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2444             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2445             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2446             let m := add(mload(0x40), 0xa0)
2447             // Update the free memory pointer to allocate.
2448             mstore(0x40, m)
2449             // Assign the `str` to the end.
2450             str := sub(m, 0x20)
2451             // Zeroize the slot after the string.
2452             mstore(str, 0)
2453 
2454             // Cache the end of the memory to calculate the length later.
2455             let end := str
2456 
2457             // We write the string from rightmost digit to leftmost digit.
2458             // The following is essentially a do-while loop that also handles the zero case.
2459             // prettier-ignore
2460             for { let temp := value } 1 {} {
2461                 str := sub(str, 1)
2462                 // Write the character to the pointer.
2463                 // The ASCII index of the '0' character is 48.
2464                 mstore8(str, add(48, mod(temp, 10)))
2465                 // Keep dividing `temp` until zero.
2466                 temp := div(temp, 10)
2467                 // prettier-ignore
2468                 if iszero(temp) { break }
2469             }
2470 
2471             let length := sub(end, str)
2472             // Move the pointer 32 bytes leftwards to make room for the length.
2473             str := sub(str, 0x20)
2474             // Store the length.
2475             mstore(str, length)
2476         }
2477     }
2478 }
2479 
2480 // File: contracts/Defaces.sol
2481 
2482 
2483 pragma solidity 0.8.17;
2484 
2485 
2486 
2487 
2488 
2489 
2490 
2491 contract Defaces is ERC721A, Ownable, ReentrancyGuard {
2492 
2493     using Address for address;
2494     using Strings for uint256;
2495     using MerkleProof for bytes32[];
2496 
2497     string public hiddenURL;
2498     string private uriPrefix ;
2499     string private uriSuffix = ".json";
2500 
2501     bytes32 whitelistMerkleRoot = 0x534750dee122d7779a0b8d643646d16e2d27fd3f797183ce7ae9258173436de0;
2502     
2503     uint256 public maxSupply = 5000;
2504     uint256 public maxSupplyPublic = 1800;
2505     uint256 public maxSupplyWhitelist = 3200;
2506 
2507     uint256 public pricePublic = 0.005 ether;
2508     uint256 public priceWhitelist = 0.003 ether;
2509     
2510     uint256 public maxPerPublicTx = 5;
2511     uint256 public maxPerPublicWallet = 5;
2512     uint256 public maxPerWhiteListTx = 2;
2513     uint256 public maxPerWhiteListWallet = 2;
2514 
2515     bool public publicOpen = false;
2516     bool public whitelistOpen = false;
2517 
2518     bool public reveal = false;
2519 
2520     constructor(
2521         string memory _tokenName,
2522         string memory _tokenSymbol,
2523         string memory _hiddenMetadataUri
2524     ) ERC721A(_tokenName, _tokenSymbol) {}
2525 
2526     modifier mintCompliance(uint256 quantity) {
2527 
2528         require(quantity > 0,
2529          unicode"Defaces>0◠0");
2530 
2531         require(totalSupply() + quantity <= maxSupply,
2532          unicode"ERROR◠404");
2533         _;
2534     }
2535 
2536     function mintPublic(uint256 quantity)
2537      public
2538      payable
2539      mintCompliance(quantity) 
2540      nonReentrant 
2541     {
2542         require(publicOpen, unicode"Mint◠Closed!");
2543 
2544         require(msg.value >= quantity * pricePublic, unicode"Deface◠0.005◠Each");
2545 
2546         require(quantity <= maxPerPublicTx, unicode"Deface <= 5◠Per◠TX");
2547 
2548         _safeMint(msg.sender, quantity);
2549 
2550     }
2551 
2552     function mintDefaceList(bytes32[] calldata _merkleProof, uint256 quantity)
2553      public
2554      payable
2555      mintCompliance(quantity)
2556      nonReentrant
2557     {      
2558         require(whitelistOpen, unicode"WL◠Mint◠Closed!");
2559 
2560         require(msg.value >= quantity * priceWhitelist, unicode"DefaceList◠0.003◠Each");
2561         
2562         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2563         require(MerkleProof.verify(_merkleProof, whitelistMerkleRoot, leaf), unicode"Invalid◠Pro◠of.");
2564 
2565         require(quantity <= maxPerWhiteListTx, unicode"DefaceList <= 2◠Per◠TX");
2566 
2567         require(
2568             balanceOf(msg.sender) + quantity <= maxPerWhiteListWallet,
2569             unicode"DefaceList <= 2◠Per◠Wallet"
2570         );
2571         
2572         _safeMint(msg.sender, quantity);
2573         
2574     }
2575 
2576     function OwnerMint(uint256 quantity, address _to) 
2577     public 
2578     onlyOwner 
2579     mintCompliance(quantity) 
2580     {
2581         _safeMint(_to, quantity);
2582     }
2583 
2584     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2585         whitelistMerkleRoot = _merkleRoot;
2586     }
2587 
2588     function updatePrices(uint256 _priceWhitelist, uint256 _pricePublic) public onlyOwner {
2589         priceWhitelist = _priceWhitelist;
2590         pricePublic = _pricePublic;
2591     }
2592 
2593     function updateSupplies(uint256 _maxSupplyPublic, uint256 _maxSupplyWhitelist) public onlyOwner {
2594         maxSupplyPublic = _maxSupplyPublic;
2595         maxSupplyWhitelist = _maxSupplyWhitelist;
2596     }
2597 
2598     function setStates(bool _publicOpen, bool _whitelistOpen) public onlyOwner {
2599         publicOpen = _publicOpen;
2600         whitelistOpen = _whitelistOpen;
2601     }
2602 
2603     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2604         maxSupply = _maxSupply;
2605     }
2606     
2607     function tokenURI(uint256 _tokenId)
2608     public
2609     view
2610     virtual
2611     override
2612     returns (string memory)
2613     {
2614     require(
2615       _exists(_tokenId),
2616       unicode"ERC721Metadata:◠URI◠query◠for◠nonexistent◠token"
2617     );
2618     if (reveal == false)
2619     {
2620         return hiddenURL;
2621     }
2622     string memory currentBaseURI = _baseURI();
2623     return bytes(currentBaseURI).length > 0
2624         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
2625         : "";
2626     }
2627     
2628     function setUriPrefix(string memory _uriPrefix) external onlyOwner {
2629         uriPrefix = _uriPrefix;
2630     }
2631 
2632     function setHiddenUri(string memory _uriPrefix) external onlyOwner {
2633         hiddenURL = _uriPrefix;
2634     }
2635 
2636     function setRevealed() external onlyOwner{
2637         reveal = !reveal;
2638     }
2639 
2640    function _baseURI() internal view  override returns (string memory) {
2641         return uriPrefix;
2642    }
2643 
2644     function _startTokenId() internal pure override returns (uint256) {
2645         return 1;
2646     }
2647 
2648     function withdraw() public onlyOwner {
2649         (bool success, ) = payable(owner()).call{value: address(this).balance}("");
2650         require(success, unicode"Transfer◠Failed");
2651     }
2652 }