1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: contracts/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
44  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
45  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
46  */
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
58             if (subscribe) {
59                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     OPERATOR_FILTER_REGISTRY.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Check registry code length to facilitate testing in environments without a deployed registry.
72         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
73             // Allow spending tokens from addresses with balance
74             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
75             // from an EOA.
76             if (from == msg.sender) {
77                 _;
78                 return;
79             }
80             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
81                 revert OperatorNotAllowed(msg.sender);
82             }
83         }
84         _;
85     }
86 
87     modifier onlyAllowedOperatorApproval(address operator) virtual {
88         // Check registry code length to facilitate testing in environments without a deployed registry.
89         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
90             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
91                 revert OperatorNotAllowed(operator);
92             }
93         }
94         _;
95     }
96 }
97 
98 // File: contracts/DefaultOperatorFilterer.sol
99 
100 
101 pragma solidity ^0.8.13;
102 
103 
104 /**
105  * @title  DefaultOperatorFilterer
106  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
107  */
108 abstract contract DefaultOperatorFilterer is OperatorFilterer {
109     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
110 
111     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
112 }
113 
114 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev These functions deal with verification of Merkle Tree proofs.
123  *
124  * The tree and the proofs can be generated using our
125  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
126  * You will find a quickstart guide in the readme.
127  *
128  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
129  * hashing, or use a hash function other than keccak256 for hashing leaves.
130  * This is because the concatenation of a sorted pair of internal nodes in
131  * the merkle tree could be reinterpreted as a leaf value.
132  * OpenZeppelin's JavaScript library generates merkle trees that are safe
133  * against this attack out of the box.
134  */
135 library MerkleProof {
136     /**
137      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
138      * defined by `root`. For this, a `proof` must be provided, containing
139      * sibling hashes on the branch from the leaf to the root of the tree. Each
140      * pair of leaves and each pair of pre-images are assumed to be sorted.
141      */
142     function verify(
143         bytes32[] memory proof,
144         bytes32 root,
145         bytes32 leaf
146     ) internal pure returns (bool) {
147         return processProof(proof, leaf) == root;
148     }
149 
150     /**
151      * @dev Calldata version of {verify}
152      *
153      * _Available since v4.7._
154      */
155     function verifyCalldata(
156         bytes32[] calldata proof,
157         bytes32 root,
158         bytes32 leaf
159     ) internal pure returns (bool) {
160         return processProofCalldata(proof, leaf) == root;
161     }
162 
163     /**
164      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
165      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
166      * hash matches the root of the tree. When processing the proof, the pairs
167      * of leafs & pre-images are assumed to be sorted.
168      *
169      * _Available since v4.4._
170      */
171     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
172         bytes32 computedHash = leaf;
173         for (uint256 i = 0; i < proof.length; i++) {
174             computedHash = _hashPair(computedHash, proof[i]);
175         }
176         return computedHash;
177     }
178 
179     /**
180      * @dev Calldata version of {processProof}
181      *
182      * _Available since v4.7._
183      */
184     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
185         bytes32 computedHash = leaf;
186         for (uint256 i = 0; i < proof.length; i++) {
187             computedHash = _hashPair(computedHash, proof[i]);
188         }
189         return computedHash;
190     }
191 
192     /**
193      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
194      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
195      *
196      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
197      *
198      * _Available since v4.7._
199      */
200     function multiProofVerify(
201         bytes32[] memory proof,
202         bool[] memory proofFlags,
203         bytes32 root,
204         bytes32[] memory leaves
205     ) internal pure returns (bool) {
206         return processMultiProof(proof, proofFlags, leaves) == root;
207     }
208 
209     /**
210      * @dev Calldata version of {multiProofVerify}
211      *
212      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
213      *
214      * _Available since v4.7._
215      */
216     function multiProofVerifyCalldata(
217         bytes32[] calldata proof,
218         bool[] calldata proofFlags,
219         bytes32 root,
220         bytes32[] memory leaves
221     ) internal pure returns (bool) {
222         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
223     }
224 
225     /**
226      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
227      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
228      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
229      * respectively.
230      *
231      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
232      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
233      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
234      *
235      * _Available since v4.7._
236      */
237     function processMultiProof(
238         bytes32[] memory proof,
239         bool[] memory proofFlags,
240         bytes32[] memory leaves
241     ) internal pure returns (bytes32 merkleRoot) {
242         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
243         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
244         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
245         // the merkle tree.
246         uint256 leavesLen = leaves.length;
247         uint256 totalHashes = proofFlags.length;
248 
249         // Check proof validity.
250         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
251 
252         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
253         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
254         bytes32[] memory hashes = new bytes32[](totalHashes);
255         uint256 leafPos = 0;
256         uint256 hashPos = 0;
257         uint256 proofPos = 0;
258         // At each step, we compute the next hash using two values:
259         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
260         //   get the next hash.
261         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
262         //   `proof` array.
263         for (uint256 i = 0; i < totalHashes; i++) {
264             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
265             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
266             hashes[i] = _hashPair(a, b);
267         }
268 
269         if (totalHashes > 0) {
270             return hashes[totalHashes - 1];
271         } else if (leavesLen > 0) {
272             return leaves[0];
273         } else {
274             return proof[0];
275         }
276     }
277 
278     /**
279      * @dev Calldata version of {processMultiProof}.
280      *
281      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
282      *
283      * _Available since v4.7._
284      */
285     function processMultiProofCalldata(
286         bytes32[] calldata proof,
287         bool[] calldata proofFlags,
288         bytes32[] memory leaves
289     ) internal pure returns (bytes32 merkleRoot) {
290         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
291         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
292         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
293         // the merkle tree.
294         uint256 leavesLen = leaves.length;
295         uint256 totalHashes = proofFlags.length;
296 
297         // Check proof validity.
298         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
299 
300         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
301         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
302         bytes32[] memory hashes = new bytes32[](totalHashes);
303         uint256 leafPos = 0;
304         uint256 hashPos = 0;
305         uint256 proofPos = 0;
306         // At each step, we compute the next hash using two values:
307         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
308         //   get the next hash.
309         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
310         //   `proof` array.
311         for (uint256 i = 0; i < totalHashes; i++) {
312             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
313             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
314             hashes[i] = _hashPair(a, b);
315         }
316 
317         if (totalHashes > 0) {
318             return hashes[totalHashes - 1];
319         } else if (leavesLen > 0) {
320             return leaves[0];
321         } else {
322             return proof[0];
323         }
324     }
325 
326     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
327         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
328     }
329 
330     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
331         /// @solidity memory-safe-assembly
332         assembly {
333             mstore(0x00, a)
334             mstore(0x20, b)
335             value := keccak256(0x00, 0x40)
336         }
337     }
338 }
339 
340 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
341 
342 
343 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
344 
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @dev Contract module that helps prevent reentrant calls to a function.
349  *
350  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
351  * available, which can be applied to functions to make sure there are no nested
352  * (reentrant) calls to them.
353  *
354  * Note that because there is a single `nonReentrant` guard, functions marked as
355  * `nonReentrant` may not call one another. This can be worked around by making
356  * those functions `private`, and then adding `external` `nonReentrant` entry
357  * points to them.
358  *
359  * TIP: If you would like to learn more about reentrancy and alternative ways
360  * to protect against it, check out our blog post
361  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
362  */
363 abstract contract ReentrancyGuard {
364     // Booleans are more expensive than uint256 or any type that takes up a full
365     // word because each write operation emits an extra SLOAD to first read the
366     // slot's contents, replace the bits taken up by the boolean, and then write
367     // back. This is the compiler's defense against contract upgrades and
368     // pointer aliasing, and it cannot be disabled.
369 
370     // The values being non-zero value makes deployment a bit more expensive,
371     // but in exchange the refund on every call to nonReentrant will be lower in
372     // amount. Since refunds are capped to a percentage of the total
373     // transaction's gas, it is best to keep them low in cases like this one, to
374     // increase the likelihood of the full refund coming into effect.
375     uint256 private constant _NOT_ENTERED = 1;
376     uint256 private constant _ENTERED = 2;
377 
378     uint256 private _status;
379 
380     constructor() {
381         _status = _NOT_ENTERED;
382     }
383 
384     /**
385      * @dev Prevents a contract from calling itself, directly or indirectly.
386      * Calling a `nonReentrant` function from another `nonReentrant`
387      * function is not supported. It is possible to prevent this from happening
388      * by making the `nonReentrant` function external, and making it call a
389      * `private` function that does the actual work.
390      */
391     modifier nonReentrant() {
392         _nonReentrantBefore();
393         _;
394         _nonReentrantAfter();
395     }
396 
397     function _nonReentrantBefore() private {
398         // On the first call to nonReentrant, _status will be _NOT_ENTERED
399         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
400 
401         // Any calls to nonReentrant after this point will fail
402         _status = _ENTERED;
403     }
404 
405     function _nonReentrantAfter() private {
406         // By storing the original value once again, a refund is triggered (see
407         // https://eips.ethereum.org/EIPS/eip-2200)
408         _status = _NOT_ENTERED;
409     }
410 }
411 
412 // File: @openzeppelin/contracts/utils/math/Math.sol
413 
414 
415 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 /**
420  * @dev Standard math utilities missing in the Solidity language.
421  */
422 library Math {
423     enum Rounding {
424         Down, // Toward negative infinity
425         Up, // Toward infinity
426         Zero // Toward zero
427     }
428 
429     /**
430      * @dev Returns the largest of two numbers.
431      */
432     function max(uint256 a, uint256 b) internal pure returns (uint256) {
433         return a > b ? a : b;
434     }
435 
436     /**
437      * @dev Returns the smallest of two numbers.
438      */
439     function min(uint256 a, uint256 b) internal pure returns (uint256) {
440         return a < b ? a : b;
441     }
442 
443     /**
444      * @dev Returns the average of two numbers. The result is rounded towards
445      * zero.
446      */
447     function average(uint256 a, uint256 b) internal pure returns (uint256) {
448         // (a + b) / 2 can overflow.
449         return (a & b) + (a ^ b) / 2;
450     }
451 
452     /**
453      * @dev Returns the ceiling of the division of two numbers.
454      *
455      * This differs from standard division with `/` in that it rounds up instead
456      * of rounding down.
457      */
458     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
459         // (a + b - 1) / b can overflow on addition, so we distribute.
460         return a == 0 ? 0 : (a - 1) / b + 1;
461     }
462 
463     /**
464      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
465      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
466      * with further edits by Uniswap Labs also under MIT license.
467      */
468     function mulDiv(
469         uint256 x,
470         uint256 y,
471         uint256 denominator
472     ) internal pure returns (uint256 result) {
473         unchecked {
474             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
475             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
476             // variables such that product = prod1 * 2^256 + prod0.
477             uint256 prod0; // Least significant 256 bits of the product
478             uint256 prod1; // Most significant 256 bits of the product
479             assembly {
480                 let mm := mulmod(x, y, not(0))
481                 prod0 := mul(x, y)
482                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
483             }
484 
485             // Handle non-overflow cases, 256 by 256 division.
486             if (prod1 == 0) {
487                 return prod0 / denominator;
488             }
489 
490             // Make sure the result is less than 2^256. Also prevents denominator == 0.
491             require(denominator > prod1);
492 
493             ///////////////////////////////////////////////
494             // 512 by 256 division.
495             ///////////////////////////////////////////////
496 
497             // Make division exact by subtracting the remainder from [prod1 prod0].
498             uint256 remainder;
499             assembly {
500                 // Compute remainder using mulmod.
501                 remainder := mulmod(x, y, denominator)
502 
503                 // Subtract 256 bit number from 512 bit number.
504                 prod1 := sub(prod1, gt(remainder, prod0))
505                 prod0 := sub(prod0, remainder)
506             }
507 
508             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
509             // See https://cs.stackexchange.com/q/138556/92363.
510 
511             // Does not overflow because the denominator cannot be zero at this stage in the function.
512             uint256 twos = denominator & (~denominator + 1);
513             assembly {
514                 // Divide denominator by twos.
515                 denominator := div(denominator, twos)
516 
517                 // Divide [prod1 prod0] by twos.
518                 prod0 := div(prod0, twos)
519 
520                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
521                 twos := add(div(sub(0, twos), twos), 1)
522             }
523 
524             // Shift in bits from prod1 into prod0.
525             prod0 |= prod1 * twos;
526 
527             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
528             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
529             // four bits. That is, denominator * inv = 1 mod 2^4.
530             uint256 inverse = (3 * denominator) ^ 2;
531 
532             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
533             // in modular arithmetic, doubling the correct bits in each step.
534             inverse *= 2 - denominator * inverse; // inverse mod 2^8
535             inverse *= 2 - denominator * inverse; // inverse mod 2^16
536             inverse *= 2 - denominator * inverse; // inverse mod 2^32
537             inverse *= 2 - denominator * inverse; // inverse mod 2^64
538             inverse *= 2 - denominator * inverse; // inverse mod 2^128
539             inverse *= 2 - denominator * inverse; // inverse mod 2^256
540 
541             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
542             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
543             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
544             // is no longer required.
545             result = prod0 * inverse;
546             return result;
547         }
548     }
549 
550     /**
551      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
552      */
553     function mulDiv(
554         uint256 x,
555         uint256 y,
556         uint256 denominator,
557         Rounding rounding
558     ) internal pure returns (uint256) {
559         uint256 result = mulDiv(x, y, denominator);
560         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
561             result += 1;
562         }
563         return result;
564     }
565 
566     /**
567      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
568      *
569      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
570      */
571     function sqrt(uint256 a) internal pure returns (uint256) {
572         if (a == 0) {
573             return 0;
574         }
575 
576         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
577         //
578         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
579         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
580         //
581         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
582         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
583         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
584         //
585         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
586         uint256 result = 1 << (log2(a) >> 1);
587 
588         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
589         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
590         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
591         // into the expected uint128 result.
592         unchecked {
593             result = (result + a / result) >> 1;
594             result = (result + a / result) >> 1;
595             result = (result + a / result) >> 1;
596             result = (result + a / result) >> 1;
597             result = (result + a / result) >> 1;
598             result = (result + a / result) >> 1;
599             result = (result + a / result) >> 1;
600             return min(result, a / result);
601         }
602     }
603 
604     /**
605      * @notice Calculates sqrt(a), following the selected rounding direction.
606      */
607     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
608         unchecked {
609             uint256 result = sqrt(a);
610             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
611         }
612     }
613 
614     /**
615      * @dev Return the log in base 2, rounded down, of a positive value.
616      * Returns 0 if given 0.
617      */
618     function log2(uint256 value) internal pure returns (uint256) {
619         uint256 result = 0;
620         unchecked {
621             if (value >> 128 > 0) {
622                 value >>= 128;
623                 result += 128;
624             }
625             if (value >> 64 > 0) {
626                 value >>= 64;
627                 result += 64;
628             }
629             if (value >> 32 > 0) {
630                 value >>= 32;
631                 result += 32;
632             }
633             if (value >> 16 > 0) {
634                 value >>= 16;
635                 result += 16;
636             }
637             if (value >> 8 > 0) {
638                 value >>= 8;
639                 result += 8;
640             }
641             if (value >> 4 > 0) {
642                 value >>= 4;
643                 result += 4;
644             }
645             if (value >> 2 > 0) {
646                 value >>= 2;
647                 result += 2;
648             }
649             if (value >> 1 > 0) {
650                 result += 1;
651             }
652         }
653         return result;
654     }
655 
656     /**
657      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
658      * Returns 0 if given 0.
659      */
660     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
661         unchecked {
662             uint256 result = log2(value);
663             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
664         }
665     }
666 
667     /**
668      * @dev Return the log in base 10, rounded down, of a positive value.
669      * Returns 0 if given 0.
670      */
671     function log10(uint256 value) internal pure returns (uint256) {
672         uint256 result = 0;
673         unchecked {
674             if (value >= 10**64) {
675                 value /= 10**64;
676                 result += 64;
677             }
678             if (value >= 10**32) {
679                 value /= 10**32;
680                 result += 32;
681             }
682             if (value >= 10**16) {
683                 value /= 10**16;
684                 result += 16;
685             }
686             if (value >= 10**8) {
687                 value /= 10**8;
688                 result += 8;
689             }
690             if (value >= 10**4) {
691                 value /= 10**4;
692                 result += 4;
693             }
694             if (value >= 10**2) {
695                 value /= 10**2;
696                 result += 2;
697             }
698             if (value >= 10**1) {
699                 result += 1;
700             }
701         }
702         return result;
703     }
704 
705     /**
706      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
707      * Returns 0 if given 0.
708      */
709     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
710         unchecked {
711             uint256 result = log10(value);
712             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
713         }
714     }
715 
716     /**
717      * @dev Return the log in base 256, rounded down, of a positive value.
718      * Returns 0 if given 0.
719      *
720      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
721      */
722     function log256(uint256 value) internal pure returns (uint256) {
723         uint256 result = 0;
724         unchecked {
725             if (value >> 128 > 0) {
726                 value >>= 128;
727                 result += 16;
728             }
729             if (value >> 64 > 0) {
730                 value >>= 64;
731                 result += 8;
732             }
733             if (value >> 32 > 0) {
734                 value >>= 32;
735                 result += 4;
736             }
737             if (value >> 16 > 0) {
738                 value >>= 16;
739                 result += 2;
740             }
741             if (value >> 8 > 0) {
742                 result += 1;
743             }
744         }
745         return result;
746     }
747 
748     /**
749      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
750      * Returns 0 if given 0.
751      */
752     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
753         unchecked {
754             uint256 result = log256(value);
755             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
756         }
757     }
758 }
759 
760 // File: @openzeppelin/contracts/utils/Strings.sol
761 
762 
763 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @dev String operations.
770  */
771 library Strings {
772     bytes16 private constant _SYMBOLS = "0123456789abcdef";
773     uint8 private constant _ADDRESS_LENGTH = 20;
774 
775     /**
776      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
777      */
778     function toString(uint256 value) internal pure returns (string memory) {
779         unchecked {
780             uint256 length = Math.log10(value) + 1;
781             string memory buffer = new string(length);
782             uint256 ptr;
783             /// @solidity memory-safe-assembly
784             assembly {
785                 ptr := add(buffer, add(32, length))
786             }
787             while (true) {
788                 ptr--;
789                 /// @solidity memory-safe-assembly
790                 assembly {
791                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
792                 }
793                 value /= 10;
794                 if (value == 0) break;
795             }
796             return buffer;
797         }
798     }
799 
800     /**
801      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
802      */
803     function toHexString(uint256 value) internal pure returns (string memory) {
804         unchecked {
805             return toHexString(value, Math.log256(value) + 1);
806         }
807     }
808 
809     /**
810      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
811      */
812     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
813         bytes memory buffer = new bytes(2 * length + 2);
814         buffer[0] = "0";
815         buffer[1] = "x";
816         for (uint256 i = 2 * length + 1; i > 1; --i) {
817             buffer[i] = _SYMBOLS[value & 0xf];
818             value >>= 4;
819         }
820         require(value == 0, "Strings: hex length insufficient");
821         return string(buffer);
822     }
823 
824     /**
825      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
826      */
827     function toHexString(address addr) internal pure returns (string memory) {
828         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
829     }
830 }
831 
832 // File: @openzeppelin/contracts/utils/Context.sol
833 
834 
835 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
836 
837 pragma solidity ^0.8.0;
838 
839 /**
840  * @dev Provides information about the current execution context, including the
841  * sender of the transaction and its data. While these are generally available
842  * via msg.sender and msg.data, they should not be accessed in such a direct
843  * manner, since when dealing with meta-transactions the account sending and
844  * paying for execution may not be the actual sender (as far as an application
845  * is concerned).
846  *
847  * This contract is only required for intermediate, library-like contracts.
848  */
849 abstract contract Context {
850     function _msgSender() internal view virtual returns (address) {
851         return msg.sender;
852     }
853 
854     function _msgData() internal view virtual returns (bytes calldata) {
855         return msg.data;
856     }
857 }
858 
859 // File: @openzeppelin/contracts/access/Ownable.sol
860 
861 
862 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
863 
864 pragma solidity ^0.8.0;
865 
866 
867 /**
868  * @dev Contract module which provides a basic access control mechanism, where
869  * there is an account (an owner) that can be granted exclusive access to
870  * specific functions.
871  *
872  * By default, the owner account will be the one that deploys the contract. This
873  * can later be changed with {transferOwnership}.
874  *
875  * This module is used through inheritance. It will make available the modifier
876  * `onlyOwner`, which can be applied to your functions to restrict their use to
877  * the owner.
878  */
879 abstract contract Ownable is Context {
880     address private _owner;
881 
882     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
883 
884     /**
885      * @dev Initializes the contract setting the deployer as the initial owner.
886      */
887     constructor() {
888         _transferOwnership(_msgSender());
889     }
890 
891     /**
892      * @dev Throws if called by any account other than the owner.
893      */
894     modifier onlyOwner() {
895         _checkOwner();
896         _;
897     }
898 
899     /**
900      * @dev Returns the address of the current owner.
901      */
902     function owner() public view virtual returns (address) {
903         return _owner;
904     }
905 
906     /**
907      * @dev Throws if the sender is not the owner.
908      */
909     function _checkOwner() internal view virtual {
910         require(owner() == _msgSender(), "Ownable: caller is not the owner");
911     }
912 
913     /**
914      * @dev Leaves the contract without owner. It will not be possible to call
915      * `onlyOwner` functions anymore. Can only be called by the current owner.
916      *
917      * NOTE: Renouncing ownership will leave the contract without an owner,
918      * thereby removing any functionality that is only available to the owner.
919      */
920     function renounceOwnership() public virtual onlyOwner {
921         _transferOwnership(address(0));
922     }
923 
924     /**
925      * @dev Transfers ownership of the contract to a new account (`newOwner`).
926      * Can only be called by the current owner.
927      */
928     function transferOwnership(address newOwner) public virtual onlyOwner {
929         require(newOwner != address(0), "Ownable: new owner is the zero address");
930         _transferOwnership(newOwner);
931     }
932 
933     /**
934      * @dev Transfers ownership of the contract to a new account (`newOwner`).
935      * Internal function without access restriction.
936      */
937     function _transferOwnership(address newOwner) internal virtual {
938         address oldOwner = _owner;
939         _owner = newOwner;
940         emit OwnershipTransferred(oldOwner, newOwner);
941     }
942 }
943 
944 // File: @openzeppelin/contracts/utils/Address.sol
945 
946 
947 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
948 
949 pragma solidity ^0.8.1;
950 
951 /**
952  * @dev Collection of functions related to the address type
953  */
954 library Address {
955     /**
956      * @dev Returns true if `account` is a contract.
957      *
958      * [IMPORTANT]
959      * ====
960      * It is unsafe to assume that an address for which this function returns
961      * false is an externally-owned account (EOA) and not a contract.
962      *
963      * Among others, `isContract` will return false for the following
964      * types of addresses:
965      *
966      *  - an externally-owned account
967      *  - a contract in construction
968      *  - an address where a contract will be created
969      *  - an address where a contract lived, but was destroyed
970      * ====
971      *
972      * [IMPORTANT]
973      * ====
974      * You shouldn't rely on `isContract` to protect against flash loan attacks!
975      *
976      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
977      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
978      * constructor.
979      * ====
980      */
981     function isContract(address account) internal view returns (bool) {
982         // This method relies on extcodesize/address.code.length, which returns 0
983         // for contracts in construction, since the code is only stored at the end
984         // of the constructor execution.
985 
986         return account.code.length > 0;
987     }
988 
989     /**
990      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
991      * `recipient`, forwarding all available gas and reverting on errors.
992      *
993      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
994      * of certain opcodes, possibly making contracts go over the 2300 gas limit
995      * imposed by `transfer`, making them unable to receive funds via
996      * `transfer`. {sendValue} removes this limitation.
997      *
998      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
999      *
1000      * IMPORTANT: because control is transferred to `recipient`, care must be
1001      * taken to not create reentrancy vulnerabilities. Consider using
1002      * {ReentrancyGuard} or the
1003      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1004      */
1005     function sendValue(address payable recipient, uint256 amount) internal {
1006         require(address(this).balance >= amount, "Address: insufficient balance");
1007 
1008         (bool success, ) = recipient.call{value: amount}("");
1009         require(success, "Address: unable to send value, recipient may have reverted");
1010     }
1011 
1012     /**
1013      * @dev Performs a Solidity function call using a low level `call`. A
1014      * plain `call` is an unsafe replacement for a function call: use this
1015      * function instead.
1016      *
1017      * If `target` reverts with a revert reason, it is bubbled up by this
1018      * function (like regular Solidity function calls).
1019      *
1020      * Returns the raw returned data. To convert to the expected return value,
1021      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1022      *
1023      * Requirements:
1024      *
1025      * - `target` must be a contract.
1026      * - calling `target` with `data` must not revert.
1027      *
1028      * _Available since v3.1._
1029      */
1030     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1031         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1032     }
1033 
1034     /**
1035      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1036      * `errorMessage` as a fallback revert reason when `target` reverts.
1037      *
1038      * _Available since v3.1._
1039      */
1040     function functionCall(
1041         address target,
1042         bytes memory data,
1043         string memory errorMessage
1044     ) internal returns (bytes memory) {
1045         return functionCallWithValue(target, data, 0, errorMessage);
1046     }
1047 
1048     /**
1049      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1050      * but also transferring `value` wei to `target`.
1051      *
1052      * Requirements:
1053      *
1054      * - the calling contract must have an ETH balance of at least `value`.
1055      * - the called Solidity function must be `payable`.
1056      *
1057      * _Available since v3.1._
1058      */
1059     function functionCallWithValue(
1060         address target,
1061         bytes memory data,
1062         uint256 value
1063     ) internal returns (bytes memory) {
1064         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1065     }
1066 
1067     /**
1068      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1069      * with `errorMessage` as a fallback revert reason when `target` reverts.
1070      *
1071      * _Available since v3.1._
1072      */
1073     function functionCallWithValue(
1074         address target,
1075         bytes memory data,
1076         uint256 value,
1077         string memory errorMessage
1078     ) internal returns (bytes memory) {
1079         require(address(this).balance >= value, "Address: insufficient balance for call");
1080         (bool success, bytes memory returndata) = target.call{value: value}(data);
1081         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1082     }
1083 
1084     /**
1085      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1086      * but performing a static call.
1087      *
1088      * _Available since v3.3._
1089      */
1090     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1091         return functionStaticCall(target, data, "Address: low-level static call failed");
1092     }
1093 
1094     /**
1095      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1096      * but performing a static call.
1097      *
1098      * _Available since v3.3._
1099      */
1100     function functionStaticCall(
1101         address target,
1102         bytes memory data,
1103         string memory errorMessage
1104     ) internal view returns (bytes memory) {
1105         (bool success, bytes memory returndata) = target.staticcall(data);
1106         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1107     }
1108 
1109     /**
1110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1111      * but performing a delegate call.
1112      *
1113      * _Available since v3.4._
1114      */
1115     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1116         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1117     }
1118 
1119     /**
1120      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1121      * but performing a delegate call.
1122      *
1123      * _Available since v3.4._
1124      */
1125     function functionDelegateCall(
1126         address target,
1127         bytes memory data,
1128         string memory errorMessage
1129     ) internal returns (bytes memory) {
1130         (bool success, bytes memory returndata) = target.delegatecall(data);
1131         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1132     }
1133 
1134     /**
1135      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1136      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1137      *
1138      * _Available since v4.8._
1139      */
1140     function verifyCallResultFromTarget(
1141         address target,
1142         bool success,
1143         bytes memory returndata,
1144         string memory errorMessage
1145     ) internal view returns (bytes memory) {
1146         if (success) {
1147             if (returndata.length == 0) {
1148                 // only check isContract if the call was successful and the return data is empty
1149                 // otherwise we already know that it was a contract
1150                 require(isContract(target), "Address: call to non-contract");
1151             }
1152             return returndata;
1153         } else {
1154             _revert(returndata, errorMessage);
1155         }
1156     }
1157 
1158     /**
1159      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1160      * revert reason or using the provided one.
1161      *
1162      * _Available since v4.3._
1163      */
1164     function verifyCallResult(
1165         bool success,
1166         bytes memory returndata,
1167         string memory errorMessage
1168     ) internal pure returns (bytes memory) {
1169         if (success) {
1170             return returndata;
1171         } else {
1172             _revert(returndata, errorMessage);
1173         }
1174     }
1175 
1176     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1177         // Look for revert reason and bubble it up if present
1178         if (returndata.length > 0) {
1179             // The easiest way to bubble the revert reason is using memory via assembly
1180             /// @solidity memory-safe-assembly
1181             assembly {
1182                 let returndata_size := mload(returndata)
1183                 revert(add(32, returndata), returndata_size)
1184             }
1185         } else {
1186             revert(errorMessage);
1187         }
1188     }
1189 }
1190 
1191 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1192 
1193 
1194 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1195 
1196 pragma solidity ^0.8.0;
1197 
1198 /**
1199  * @title ERC721 token receiver interface
1200  * @dev Interface for any contract that wants to support safeTransfers
1201  * from ERC721 asset contracts.
1202  */
1203 interface IERC721Receiver {
1204     /**
1205      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1206      * by `operator` from `from`, this function is called.
1207      *
1208      * It must return its Solidity selector to confirm the token transfer.
1209      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1210      *
1211      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1212      */
1213     function onERC721Received(
1214         address operator,
1215         address from,
1216         uint256 tokenId,
1217         bytes calldata data
1218     ) external returns (bytes4);
1219 }
1220 
1221 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1222 
1223 
1224 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 /**
1229  * @dev Interface of the ERC165 standard, as defined in the
1230  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1231  *
1232  * Implementers can declare support of contract interfaces, which can then be
1233  * queried by others ({ERC165Checker}).
1234  *
1235  * For an implementation, see {ERC165}.
1236  */
1237 interface IERC165 {
1238     /**
1239      * @dev Returns true if this contract implements the interface defined by
1240      * `interfaceId`. See the corresponding
1241      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1242      * to learn more about how these ids are created.
1243      *
1244      * This function call must use less than 30 000 gas.
1245      */
1246     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1247 }
1248 
1249 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1250 
1251 
1252 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1253 
1254 pragma solidity ^0.8.0;
1255 
1256 
1257 /**
1258  * @dev Implementation of the {IERC165} interface.
1259  *
1260  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1261  * for the additional interface id that will be supported. For example:
1262  *
1263  * ```solidity
1264  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1265  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1266  * }
1267  * ```
1268  *
1269  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1270  */
1271 abstract contract ERC165 is IERC165 {
1272     /**
1273      * @dev See {IERC165-supportsInterface}.
1274      */
1275     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1276         return interfaceId == type(IERC165).interfaceId;
1277     }
1278 }
1279 
1280 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1281 
1282 
1283 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1284 
1285 pragma solidity ^0.8.0;
1286 
1287 
1288 /**
1289  * @dev Required interface of an ERC721 compliant contract.
1290  */
1291 interface IERC721 is IERC165 {
1292     /**
1293      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1294      */
1295     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1296 
1297     /**
1298      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1299      */
1300     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1301 
1302     /**
1303      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1304      */
1305     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1306 
1307     /**
1308      * @dev Returns the number of tokens in ``owner``'s account.
1309      */
1310     function balanceOf(address owner) external view returns (uint256 balance);
1311 
1312     /**
1313      * @dev Returns the owner of the `tokenId` token.
1314      *
1315      * Requirements:
1316      *
1317      * - `tokenId` must exist.
1318      */
1319     function ownerOf(uint256 tokenId) external view returns (address owner);
1320 
1321     /**
1322      * @dev Safely transfers `tokenId` token from `from` to `to`.
1323      *
1324      * Requirements:
1325      *
1326      * - `from` cannot be the zero address.
1327      * - `to` cannot be the zero address.
1328      * - `tokenId` token must exist and be owned by `from`.
1329      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1330      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1331      *
1332      * Emits a {Transfer} event.
1333      */
1334     function safeTransferFrom(
1335         address from,
1336         address to,
1337         uint256 tokenId,
1338         bytes calldata data
1339     ) external;
1340 
1341     /**
1342      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1343      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1344      *
1345      * Requirements:
1346      *
1347      * - `from` cannot be the zero address.
1348      * - `to` cannot be the zero address.
1349      * - `tokenId` token must exist and be owned by `from`.
1350      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1351      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1352      *
1353      * Emits a {Transfer} event.
1354      */
1355     function safeTransferFrom(
1356         address from,
1357         address to,
1358         uint256 tokenId
1359     ) external;
1360 
1361     /**
1362      * @dev Transfers `tokenId` token from `from` to `to`.
1363      *
1364      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1365      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1366      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1367      *
1368      * Requirements:
1369      *
1370      * - `from` cannot be the zero address.
1371      * - `to` cannot be the zero address.
1372      * - `tokenId` token must be owned by `from`.
1373      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1374      *
1375      * Emits a {Transfer} event.
1376      */
1377     function transferFrom(
1378         address from,
1379         address to,
1380         uint256 tokenId
1381     ) external;
1382 
1383     /**
1384      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1385      * The approval is cleared when the token is transferred.
1386      *
1387      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1388      *
1389      * Requirements:
1390      *
1391      * - The caller must own the token or be an approved operator.
1392      * - `tokenId` must exist.
1393      *
1394      * Emits an {Approval} event.
1395      */
1396     function approve(address to, uint256 tokenId) external;
1397 
1398     /**
1399      * @dev Approve or remove `operator` as an operator for the caller.
1400      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1401      *
1402      * Requirements:
1403      *
1404      * - The `operator` cannot be the caller.
1405      *
1406      * Emits an {ApprovalForAll} event.
1407      */
1408     function setApprovalForAll(address operator, bool _approved) external;
1409 
1410     /**
1411      * @dev Returns the account approved for `tokenId` token.
1412      *
1413      * Requirements:
1414      *
1415      * - `tokenId` must exist.
1416      */
1417     function getApproved(uint256 tokenId) external view returns (address operator);
1418 
1419     /**
1420      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1421      *
1422      * See {setApprovalForAll}
1423      */
1424     function isApprovedForAll(address owner, address operator) external view returns (bool);
1425 }
1426 
1427 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1428 
1429 
1430 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1431 
1432 pragma solidity ^0.8.0;
1433 
1434 
1435 /**
1436  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1437  * @dev See https://eips.ethereum.org/EIPS/eip-721
1438  */
1439 interface IERC721Enumerable is IERC721 {
1440     /**
1441      * @dev Returns the total amount of tokens stored by the contract.
1442      */
1443     function totalSupply() external view returns (uint256);
1444 
1445     /**
1446      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1447      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1448      */
1449     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1450 
1451     /**
1452      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1453      * Use along with {totalSupply} to enumerate all tokens.
1454      */
1455     function tokenByIndex(uint256 index) external view returns (uint256);
1456 }
1457 
1458 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1459 
1460 
1461 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1462 
1463 pragma solidity ^0.8.0;
1464 
1465 
1466 /**
1467  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1468  * @dev See https://eips.ethereum.org/EIPS/eip-721
1469  */
1470 interface IERC721Metadata is IERC721 {
1471     /**
1472      * @dev Returns the token collection name.
1473      */
1474     function name() external view returns (string memory);
1475 
1476     /**
1477      * @dev Returns the token collection symbol.
1478      */
1479     function symbol() external view returns (string memory);
1480 
1481     /**
1482      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1483      */
1484     function tokenURI(uint256 tokenId) external view returns (string memory);
1485 }
1486 
1487 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1488 
1489 
1490 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1491 
1492 pragma solidity ^0.8.0;
1493 
1494 
1495 
1496 
1497 
1498 
1499 
1500 
1501 /**
1502  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1503  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1504  * {ERC721Enumerable}.
1505  */
1506 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1507     using Address for address;
1508     using Strings for uint256;
1509 
1510     // Token name
1511     string private _name;
1512 
1513     // Token symbol
1514     string private _symbol;
1515 
1516     // Mapping from token ID to owner address
1517     mapping(uint256 => address) private _owners;
1518 
1519     // Mapping owner address to token count
1520     mapping(address => uint256) private _balances;
1521 
1522     // Mapping from token ID to approved address
1523     mapping(uint256 => address) private _tokenApprovals;
1524 
1525     // Mapping from owner to operator approvals
1526     mapping(address => mapping(address => bool)) private _operatorApprovals;
1527 
1528     /**
1529      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1530      */
1531     constructor(string memory name_, string memory symbol_) {
1532         _name = name_;
1533         _symbol = symbol_;
1534     }
1535 
1536     /**
1537      * @dev See {IERC165-supportsInterface}.
1538      */
1539     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1540         return
1541             interfaceId == type(IERC721).interfaceId ||
1542             interfaceId == type(IERC721Metadata).interfaceId ||
1543             super.supportsInterface(interfaceId);
1544     }
1545 
1546     /**
1547      * @dev See {IERC721-balanceOf}.
1548      */
1549     function balanceOf(address owner) public view virtual override returns (uint256) {
1550         require(owner != address(0), "ERC721: address zero is not a valid owner");
1551         return _balances[owner];
1552     }
1553 
1554     /**
1555      * @dev See {IERC721-ownerOf}.
1556      */
1557     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1558         address owner = _ownerOf(tokenId);
1559         require(owner != address(0), "ERC721: invalid token ID");
1560         return owner;
1561     }
1562 
1563     /**
1564      * @dev See {IERC721Metadata-name}.
1565      */
1566     function name() public view virtual override returns (string memory) {
1567         return _name;
1568     }
1569 
1570     /**
1571      * @dev See {IERC721Metadata-symbol}.
1572      */
1573     function symbol() public view virtual override returns (string memory) {
1574         return _symbol;
1575     }
1576 
1577     /**
1578      * @dev See {IERC721Metadata-tokenURI}.
1579      */
1580     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1581         _requireMinted(tokenId);
1582 
1583         string memory baseURI = _baseURI();
1584         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1585     }
1586 
1587     /**
1588      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1589      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1590      * by default, can be overridden in child contracts.
1591      */
1592     function _baseURI() internal view virtual returns (string memory) {
1593         return "";
1594     }
1595 
1596     /**
1597      * @dev See {IERC721-approve}.
1598      */
1599     function approve(address to, uint256 tokenId) public virtual override {
1600         address owner = ERC721.ownerOf(tokenId);
1601         require(to != owner, "ERC721: approval to current owner");
1602 
1603         require(
1604             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1605             "ERC721: approve caller is not token owner or approved for all"
1606         );
1607 
1608         _approve(to, tokenId);
1609     }
1610 
1611     /**
1612      * @dev See {IERC721-getApproved}.
1613      */
1614     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1615         _requireMinted(tokenId);
1616 
1617         return _tokenApprovals[tokenId];
1618     }
1619 
1620     /**
1621      * @dev See {IERC721-setApprovalForAll}.
1622      */
1623     function setApprovalForAll(address operator, bool approved) public virtual override {
1624         _setApprovalForAll(_msgSender(), operator, approved);
1625     }
1626 
1627     /**
1628      * @dev See {IERC721-isApprovedForAll}.
1629      */
1630     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1631         return _operatorApprovals[owner][operator];
1632     }
1633 
1634     /**
1635      * @dev See {IERC721-transferFrom}.
1636      */
1637     function transferFrom(
1638         address from,
1639         address to,
1640         uint256 tokenId
1641     ) public virtual override {
1642         //solhint-disable-next-line max-line-length
1643         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1644 
1645         _transfer(from, to, tokenId);
1646     }
1647 
1648     /**
1649      * @dev See {IERC721-safeTransferFrom}.
1650      */
1651     function safeTransferFrom(
1652         address from,
1653         address to,
1654         uint256 tokenId
1655     ) public virtual override {
1656         safeTransferFrom(from, to, tokenId, "");
1657     }
1658 
1659     /**
1660      * @dev See {IERC721-safeTransferFrom}.
1661      */
1662     function safeTransferFrom(
1663         address from,
1664         address to,
1665         uint256 tokenId,
1666         bytes memory data
1667     ) public virtual override {
1668         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1669         _safeTransfer(from, to, tokenId, data);
1670     }
1671 
1672     /**
1673      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1674      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1675      *
1676      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1677      *
1678      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1679      * implement alternative mechanisms to perform token transfer, such as signature-based.
1680      *
1681      * Requirements:
1682      *
1683      * - `from` cannot be the zero address.
1684      * - `to` cannot be the zero address.
1685      * - `tokenId` token must exist and be owned by `from`.
1686      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1687      *
1688      * Emits a {Transfer} event.
1689      */
1690     function _safeTransfer(
1691         address from,
1692         address to,
1693         uint256 tokenId,
1694         bytes memory data
1695     ) internal virtual {
1696         _transfer(from, to, tokenId);
1697         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1698     }
1699 
1700     /**
1701      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1702      */
1703     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1704         return _owners[tokenId];
1705     }
1706 
1707     /**
1708      * @dev Returns whether `tokenId` exists.
1709      *
1710      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1711      *
1712      * Tokens start existing when they are minted (`_mint`),
1713      * and stop existing when they are burned (`_burn`).
1714      */
1715     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1716         return _ownerOf(tokenId) != address(0);
1717     }
1718 
1719     /**
1720      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1721      *
1722      * Requirements:
1723      *
1724      * - `tokenId` must exist.
1725      */
1726     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1727         address owner = ERC721.ownerOf(tokenId);
1728         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1729     }
1730 
1731     /**
1732      * @dev Safely mints `tokenId` and transfers it to `to`.
1733      *
1734      * Requirements:
1735      *
1736      * - `tokenId` must not exist.
1737      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1738      *
1739      * Emits a {Transfer} event.
1740      */
1741     function _safeMint(address to, uint256 tokenId) internal virtual {
1742         _safeMint(to, tokenId, "");
1743     }
1744 
1745     /**
1746      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1747      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1748      */
1749     function _safeMint(
1750         address to,
1751         uint256 tokenId,
1752         bytes memory data
1753     ) internal virtual {
1754         _mint(to, tokenId);
1755         require(
1756             _checkOnERC721Received(address(0), to, tokenId, data),
1757             "ERC721: transfer to non ERC721Receiver implementer"
1758         );
1759     }
1760 
1761     /**
1762      * @dev Mints `tokenId` and transfers it to `to`.
1763      *
1764      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1765      *
1766      * Requirements:
1767      *
1768      * - `tokenId` must not exist.
1769      * - `to` cannot be the zero address.
1770      *
1771      * Emits a {Transfer} event.
1772      */
1773     function _mint(address to, uint256 tokenId) internal virtual {
1774         require(to != address(0), "ERC721: mint to the zero address");
1775         require(!_exists(tokenId), "ERC721: token already minted");
1776 
1777         _beforeTokenTransfer(address(0), to, tokenId, 1);
1778 
1779         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1780         require(!_exists(tokenId), "ERC721: token already minted");
1781 
1782         unchecked {
1783             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1784             // Given that tokens are minted one by one, it is impossible in practice that
1785             // this ever happens. Might change if we allow batch minting.
1786             // The ERC fails to describe this case.
1787             _balances[to] += 1;
1788         }
1789 
1790         _owners[tokenId] = to;
1791 
1792         emit Transfer(address(0), to, tokenId);
1793 
1794         _afterTokenTransfer(address(0), to, tokenId, 1);
1795     }
1796 
1797     /**
1798      * @dev Destroys `tokenId`.
1799      * The approval is cleared when the token is burned.
1800      * This is an internal function that does not check if the sender is authorized to operate on the token.
1801      *
1802      * Requirements:
1803      *
1804      * - `tokenId` must exist.
1805      *
1806      * Emits a {Transfer} event.
1807      */
1808     function _burn(uint256 tokenId) internal virtual {
1809         address owner = ERC721.ownerOf(tokenId);
1810 
1811         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1812 
1813         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1814         owner = ERC721.ownerOf(tokenId);
1815 
1816         // Clear approvals
1817         delete _tokenApprovals[tokenId];
1818 
1819         unchecked {
1820             // Cannot overflow, as that would require more tokens to be burned/transferred
1821             // out than the owner initially received through minting and transferring in.
1822             _balances[owner] -= 1;
1823         }
1824         delete _owners[tokenId];
1825 
1826         emit Transfer(owner, address(0), tokenId);
1827 
1828         _afterTokenTransfer(owner, address(0), tokenId, 1);
1829     }
1830 
1831     /**
1832      * @dev Transfers `tokenId` from `from` to `to`.
1833      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1834      *
1835      * Requirements:
1836      *
1837      * - `to` cannot be the zero address.
1838      * - `tokenId` token must be owned by `from`.
1839      *
1840      * Emits a {Transfer} event.
1841      */
1842     function _transfer(
1843         address from,
1844         address to,
1845         uint256 tokenId
1846     ) internal virtual {
1847         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1848         require(to != address(0), "ERC721: transfer to the zero address");
1849 
1850         _beforeTokenTransfer(from, to, tokenId, 1);
1851 
1852         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1853         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1854 
1855         // Clear approvals from the previous owner
1856         delete _tokenApprovals[tokenId];
1857 
1858         unchecked {
1859             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1860             // `from`'s balance is the number of token held, which is at least one before the current
1861             // transfer.
1862             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1863             // all 2**256 token ids to be minted, which in practice is impossible.
1864             _balances[from] -= 1;
1865             _balances[to] += 1;
1866         }
1867         _owners[tokenId] = to;
1868 
1869         emit Transfer(from, to, tokenId);
1870 
1871         _afterTokenTransfer(from, to, tokenId, 1);
1872     }
1873 
1874     /**
1875      * @dev Approve `to` to operate on `tokenId`
1876      *
1877      * Emits an {Approval} event.
1878      */
1879     function _approve(address to, uint256 tokenId) internal virtual {
1880         _tokenApprovals[tokenId] = to;
1881         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1882     }
1883 
1884     /**
1885      * @dev Approve `operator` to operate on all of `owner` tokens
1886      *
1887      * Emits an {ApprovalForAll} event.
1888      */
1889     function _setApprovalForAll(
1890         address owner,
1891         address operator,
1892         bool approved
1893     ) internal virtual {
1894         require(owner != operator, "ERC721: approve to caller");
1895         _operatorApprovals[owner][operator] = approved;
1896         emit ApprovalForAll(owner, operator, approved);
1897     }
1898 
1899     /**
1900      * @dev Reverts if the `tokenId` has not been minted yet.
1901      */
1902     function _requireMinted(uint256 tokenId) internal view virtual {
1903         require(_exists(tokenId), "ERC721: invalid token ID");
1904     }
1905 
1906     /**
1907      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1908      * The call is not executed if the target address is not a contract.
1909      *
1910      * @param from address representing the previous owner of the given token ID
1911      * @param to target address that will receive the tokens
1912      * @param tokenId uint256 ID of the token to be transferred
1913      * @param data bytes optional data to send along with the call
1914      * @return bool whether the call correctly returned the expected magic value
1915      */
1916     function _checkOnERC721Received(
1917         address from,
1918         address to,
1919         uint256 tokenId,
1920         bytes memory data
1921     ) private returns (bool) {
1922         if (to.isContract()) {
1923             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1924                 return retval == IERC721Receiver.onERC721Received.selector;
1925             } catch (bytes memory reason) {
1926                 if (reason.length == 0) {
1927                     revert("ERC721: transfer to non ERC721Receiver implementer");
1928                 } else {
1929                     /// @solidity memory-safe-assembly
1930                     assembly {
1931                         revert(add(32, reason), mload(reason))
1932                     }
1933                 }
1934             }
1935         } else {
1936             return true;
1937         }
1938     }
1939 
1940     /**
1941      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1942      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1943      *
1944      * Calling conditions:
1945      *
1946      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1947      * - When `from` is zero, the tokens will be minted for `to`.
1948      * - When `to` is zero, ``from``'s tokens will be burned.
1949      * - `from` and `to` are never both zero.
1950      * - `batchSize` is non-zero.
1951      *
1952      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1953      */
1954     function _beforeTokenTransfer(
1955         address from,
1956         address to,
1957         uint256, /* firstTokenId */
1958         uint256 batchSize
1959     ) internal virtual {
1960         if (batchSize > 1) {
1961             if (from != address(0)) {
1962                 _balances[from] -= batchSize;
1963             }
1964             if (to != address(0)) {
1965                 _balances[to] += batchSize;
1966             }
1967         }
1968     }
1969 
1970     /**
1971      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1972      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1973      *
1974      * Calling conditions:
1975      *
1976      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1977      * - When `from` is zero, the tokens were minted for `to`.
1978      * - When `to` is zero, ``from``'s tokens were burned.
1979      * - `from` and `to` are never both zero.
1980      * - `batchSize` is non-zero.
1981      *
1982      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1983      */
1984     function _afterTokenTransfer(
1985         address from,
1986         address to,
1987         uint256 firstTokenId,
1988         uint256 batchSize
1989     ) internal virtual {}
1990 }
1991 
1992 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1993 
1994 
1995 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1996 
1997 pragma solidity ^0.8.0;
1998 
1999 
2000 
2001 /**
2002  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2003  * enumerability of all the token ids in the contract as well as all token ids owned by each
2004  * account.
2005  */
2006 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2007     // Mapping from owner to list of owned token IDs
2008     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2009 
2010     // Mapping from token ID to index of the owner tokens list
2011     mapping(uint256 => uint256) private _ownedTokensIndex;
2012 
2013     // Array with all token ids, used for enumeration
2014     uint256[] private _allTokens;
2015 
2016     // Mapping from token id to position in the allTokens array
2017     mapping(uint256 => uint256) private _allTokensIndex;
2018 
2019     /**
2020      * @dev See {IERC165-supportsInterface}.
2021      */
2022     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2023         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2024     }
2025 
2026     /**
2027      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2028      */
2029     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2030         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2031         return _ownedTokens[owner][index];
2032     }
2033 
2034     /**
2035      * @dev See {IERC721Enumerable-totalSupply}.
2036      */
2037     function totalSupply() public view virtual override returns (uint256) {
2038         return _allTokens.length;
2039     }
2040 
2041     /**
2042      * @dev See {IERC721Enumerable-tokenByIndex}.
2043      */
2044     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2045         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2046         return _allTokens[index];
2047     }
2048 
2049     /**
2050      * @dev See {ERC721-_beforeTokenTransfer}.
2051      */
2052     function _beforeTokenTransfer(
2053         address from,
2054         address to,
2055         uint256 firstTokenId,
2056         uint256 batchSize
2057     ) internal virtual override {
2058         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
2059 
2060         if (batchSize > 1) {
2061             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
2062             revert("ERC721Enumerable: consecutive transfers not supported");
2063         }
2064 
2065         uint256 tokenId = firstTokenId;
2066 
2067         if (from == address(0)) {
2068             _addTokenToAllTokensEnumeration(tokenId);
2069         } else if (from != to) {
2070             _removeTokenFromOwnerEnumeration(from, tokenId);
2071         }
2072         if (to == address(0)) {
2073             _removeTokenFromAllTokensEnumeration(tokenId);
2074         } else if (to != from) {
2075             _addTokenToOwnerEnumeration(to, tokenId);
2076         }
2077     }
2078 
2079     /**
2080      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2081      * @param to address representing the new owner of the given token ID
2082      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2083      */
2084     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2085         uint256 length = ERC721.balanceOf(to);
2086         _ownedTokens[to][length] = tokenId;
2087         _ownedTokensIndex[tokenId] = length;
2088     }
2089 
2090     /**
2091      * @dev Private function to add a token to this extension's token tracking data structures.
2092      * @param tokenId uint256 ID of the token to be added to the tokens list
2093      */
2094     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2095         _allTokensIndex[tokenId] = _allTokens.length;
2096         _allTokens.push(tokenId);
2097     }
2098 
2099     /**
2100      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2101      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2102      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2103      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2104      * @param from address representing the previous owner of the given token ID
2105      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2106      */
2107     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2108         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2109         // then delete the last slot (swap and pop).
2110 
2111         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2112         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2113 
2114         // When the token to delete is the last token, the swap operation is unnecessary
2115         if (tokenIndex != lastTokenIndex) {
2116             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2117 
2118             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2119             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2120         }
2121 
2122         // This also deletes the contents at the last position of the array
2123         delete _ownedTokensIndex[tokenId];
2124         delete _ownedTokens[from][lastTokenIndex];
2125     }
2126 
2127     /**
2128      * @dev Private function to remove a token from this extension's token tracking data structures.
2129      * This has O(1) time complexity, but alters the order of the _allTokens array.
2130      * @param tokenId uint256 ID of the token to be removed from the tokens list
2131      */
2132     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2133         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2134         // then delete the last slot (swap and pop).
2135 
2136         uint256 lastTokenIndex = _allTokens.length - 1;
2137         uint256 tokenIndex = _allTokensIndex[tokenId];
2138 
2139         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2140         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2141         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2142         uint256 lastTokenId = _allTokens[lastTokenIndex];
2143 
2144         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2145         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2146 
2147         // This also deletes the contents at the last position of the array
2148         delete _allTokensIndex[tokenId];
2149         _allTokens.pop();
2150     }
2151 }
2152 
2153 // File: contracts/cat.sol
2154 
2155 
2156 pragma solidity ^0.8.10;
2157 
2158 
2159 
2160 
2161 
2162 
2163 
2164 contract CATASTROPHY is ERC721Enumerable, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2165     using Strings for uint256;
2166 
2167     uint256 private s_tokenCounter = 1748;
2168     uint256 private r_tokenCounter = 0;
2169 
2170     mapping(address => bool) public mintedPerAddress;
2171 
2172     bool public mintEnabled = false;
2173     bool public publicEnabled = false;
2174 
2175     bytes32 public merkleRoot;
2176     string private baseURI = "ipfs://QmNtxNr8pxdsr29DkB4zZQFWodZH3gzww7LFDrareMrJss/";
2177 
2178     constructor() ERC721("CATASTROPHY CLUB", "CATS") {}
2179 
2180     function setMerkleRoot(bytes32 merkleRootHash) external onlyOwner {
2181         merkleRoot = merkleRootHash;
2182     }
2183 
2184     function setBaseURI(string memory uri) public onlyOwner {
2185         baseURI = uri;
2186     }
2187 
2188     function _baseURI() internal view virtual override returns (string memory) {
2189         return baseURI;
2190     }
2191 
2192     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2193         _requireMinted(tokenId);
2194 
2195         string memory currentBaseURI = _baseURI();
2196         return
2197             bytes(currentBaseURI).length > 0
2198                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
2199                 : "";
2200     }
2201 
2202     function reserveMint(uint256 _mintAmount, address _catastrophy_club_addr) public onlyOwner {
2203         require((r_tokenCounter + _mintAmount) < 361, "Club only got 360");
2204         require(_mintAmount > 0, "Need to mint at least 1 cat");
2205 
2206         for (uint256 i = 0; i < _mintAmount; i++) {
2207             _safeMint(_catastrophy_club_addr, i + 1388 + r_tokenCounter);
2208         }
2209 
2210         r_tokenCounter += _mintAmount;
2211         mintedPerAddress[_catastrophy_club_addr] = true;
2212     }
2213 
2214     function mintcat(bytes32[] calldata merkleProof) external nonReentrant {
2215         require(mintEnabled, "Minting is not live yet");
2216         require(totalSupply() <= 3000, "No more cat");
2217         require(msg.sender == tx.origin, "Cant mint from another contract");
2218         require(!mintedPerAddress[msg.sender], "You can only mint ONE cat");
2219 
2220         if (mintEnabled && !publicEnabled) {
2221             require(
2222                 MerkleProof.verify(
2223                     merkleProof,
2224                     merkleRoot,
2225                     keccak256(abi.encodePacked(msg.sender))
2226                 ),
2227                 "Sender address is not in WhiteList"
2228             );
2229         }
2230 
2231         mintedPerAddress[msg.sender] = true;
2232 
2233         _safeMint(msg.sender, s_tokenCounter++);
2234     }
2235 
2236     function flipMint(bool status) external onlyOwner {
2237         mintEnabled = status;
2238     }
2239 
2240     function flipPublic(bool status) external onlyOwner {
2241         publicEnabled = status;
2242     }
2243 
2244     // OpenSea OperatorFilter
2245 
2246     function transferFrom(
2247         address from,
2248         address to,
2249         uint256 tokenId
2250     ) public override(IERC721, ERC721) onlyAllowedOperator(from) {
2251         super.transferFrom(from, to, tokenId);
2252     }
2253 
2254     function safeTransferFrom(
2255         address from,
2256         address to,
2257         uint256 tokenId
2258     ) public override(IERC721, ERC721) onlyAllowedOperator(from) {
2259         super.safeTransferFrom(from, to, tokenId);
2260     }
2261 
2262     function safeTransferFrom(
2263         address from,
2264         address to,
2265         uint256 tokenId,
2266         bytes memory data
2267     ) public override(IERC721, ERC721) onlyAllowedOperator(from) {
2268         super.safeTransferFrom(from, to, tokenId, data);
2269     }
2270 }