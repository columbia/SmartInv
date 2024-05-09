1 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
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
33 // File: operator-filter-registry/src/OperatorFilterer.sol
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
71         // Allow spending tokens from addresses with balance
72         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
73         // from an EOA.
74         if (from != msg.sender) {
75             _checkFilterOperator(msg.sender);
76         }
77         _;
78     }
79 
80     modifier onlyAllowedOperatorApproval(address operator) virtual {
81         _checkFilterOperator(operator);
82         _;
83     }
84 
85     function _checkFilterOperator(address operator) internal view virtual {
86         // Check registry code length to facilitate testing in environments without a deployed registry.
87         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
88             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
89                 revert OperatorNotAllowed(operator);
90             }
91         }
92     }
93 }
94 
95 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
96 
97 
98 pragma solidity ^0.8.13;
99 
100 
101 /**
102  * @title  DefaultOperatorFilterer
103  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
104  */
105 abstract contract DefaultOperatorFilterer is OperatorFilterer {
106     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
107 
108     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
109 }
110 
111 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Contract module that helps prevent reentrant calls to a function.
120  *
121  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
122  * available, which can be applied to functions to make sure there are no nested
123  * (reentrant) calls to them.
124  *
125  * Note that because there is a single `nonReentrant` guard, functions marked as
126  * `nonReentrant` may not call one another. This can be worked around by making
127  * those functions `private`, and then adding `external` `nonReentrant` entry
128  * points to them.
129  *
130  * TIP: If you would like to learn more about reentrancy and alternative ways
131  * to protect against it, check out our blog post
132  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
133  */
134 abstract contract ReentrancyGuard {
135     // Booleans are more expensive than uint256 or any type that takes up a full
136     // word because each write operation emits an extra SLOAD to first read the
137     // slot's contents, replace the bits taken up by the boolean, and then write
138     // back. This is the compiler's defense against contract upgrades and
139     // pointer aliasing, and it cannot be disabled.
140 
141     // The values being non-zero value makes deployment a bit more expensive,
142     // but in exchange the refund on every call to nonReentrant will be lower in
143     // amount. Since refunds are capped to a percentage of the total
144     // transaction's gas, it is best to keep them low in cases like this one, to
145     // increase the likelihood of the full refund coming into effect.
146     uint256 private constant _NOT_ENTERED = 1;
147     uint256 private constant _ENTERED = 2;
148 
149     uint256 private _status;
150 
151     constructor() {
152         _status = _NOT_ENTERED;
153     }
154 
155     /**
156      * @dev Prevents a contract from calling itself, directly or indirectly.
157      * Calling a `nonReentrant` function from another `nonReentrant`
158      * function is not supported. It is possible to prevent this from happening
159      * by making the `nonReentrant` function external, and making it call a
160      * `private` function that does the actual work.
161      */
162     modifier nonReentrant() {
163         _nonReentrantBefore();
164         _;
165         _nonReentrantAfter();
166     }
167 
168     function _nonReentrantBefore() private {
169         // On the first call to nonReentrant, _status will be _NOT_ENTERED
170         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
171 
172         // Any calls to nonReentrant after this point will fail
173         _status = _ENTERED;
174     }
175 
176     function _nonReentrantAfter() private {
177         // By storing the original value once again, a refund is triggered (see
178         // https://eips.ethereum.org/EIPS/eip-2200)
179         _status = _NOT_ENTERED;
180     }
181 }
182 
183 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
184 
185 
186 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @dev These functions deal with verification of Merkle Tree proofs.
192  *
193  * The tree and the proofs can be generated using our
194  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
195  * You will find a quickstart guide in the readme.
196  *
197  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
198  * hashing, or use a hash function other than keccak256 for hashing leaves.
199  * This is because the concatenation of a sorted pair of internal nodes in
200  * the merkle tree could be reinterpreted as a leaf value.
201  * OpenZeppelin's JavaScript library generates merkle trees that are safe
202  * against this attack out of the box.
203  */
204 library MerkleProof {
205     /**
206      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
207      * defined by `root`. For this, a `proof` must be provided, containing
208      * sibling hashes on the branch from the leaf to the root of the tree. Each
209      * pair of leaves and each pair of pre-images are assumed to be sorted.
210      */
211     function verify(
212         bytes32[] memory proof,
213         bytes32 root,
214         bytes32 leaf
215     ) internal pure returns (bool) {
216         return processProof(proof, leaf) == root;
217     }
218 
219     /**
220      * @dev Calldata version of {verify}
221      *
222      * _Available since v4.7._
223      */
224     function verifyCalldata(
225         bytes32[] calldata proof,
226         bytes32 root,
227         bytes32 leaf
228     ) internal pure returns (bool) {
229         return processProofCalldata(proof, leaf) == root;
230     }
231 
232     /**
233      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
234      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
235      * hash matches the root of the tree. When processing the proof, the pairs
236      * of leafs & pre-images are assumed to be sorted.
237      *
238      * _Available since v4.4._
239      */
240     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
241         bytes32 computedHash = leaf;
242         for (uint256 i = 0; i < proof.length; i++) {
243             computedHash = _hashPair(computedHash, proof[i]);
244         }
245         return computedHash;
246     }
247 
248     /**
249      * @dev Calldata version of {processProof}
250      *
251      * _Available since v4.7._
252      */
253     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
254         bytes32 computedHash = leaf;
255         for (uint256 i = 0; i < proof.length; i++) {
256             computedHash = _hashPair(computedHash, proof[i]);
257         }
258         return computedHash;
259     }
260 
261     /**
262      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
263      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
264      *
265      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
266      *
267      * _Available since v4.7._
268      */
269     function multiProofVerify(
270         bytes32[] memory proof,
271         bool[] memory proofFlags,
272         bytes32 root,
273         bytes32[] memory leaves
274     ) internal pure returns (bool) {
275         return processMultiProof(proof, proofFlags, leaves) == root;
276     }
277 
278     /**
279      * @dev Calldata version of {multiProofVerify}
280      *
281      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
282      *
283      * _Available since v4.7._
284      */
285     function multiProofVerifyCalldata(
286         bytes32[] calldata proof,
287         bool[] calldata proofFlags,
288         bytes32 root,
289         bytes32[] memory leaves
290     ) internal pure returns (bool) {
291         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
292     }
293 
294     /**
295      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
296      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
297      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
298      * respectively.
299      *
300      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
301      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
302      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
303      *
304      * _Available since v4.7._
305      */
306     function processMultiProof(
307         bytes32[] memory proof,
308         bool[] memory proofFlags,
309         bytes32[] memory leaves
310     ) internal pure returns (bytes32 merkleRoot) {
311         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
312         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
313         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
314         // the merkle tree.
315         uint256 leavesLen = leaves.length;
316         uint256 totalHashes = proofFlags.length;
317 
318         // Check proof validity.
319         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
320 
321         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
322         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
323         bytes32[] memory hashes = new bytes32[](totalHashes);
324         uint256 leafPos = 0;
325         uint256 hashPos = 0;
326         uint256 proofPos = 0;
327         // At each step, we compute the next hash using two values:
328         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
329         //   get the next hash.
330         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
331         //   `proof` array.
332         for (uint256 i = 0; i < totalHashes; i++) {
333             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
334             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
335             hashes[i] = _hashPair(a, b);
336         }
337 
338         if (totalHashes > 0) {
339             return hashes[totalHashes - 1];
340         } else if (leavesLen > 0) {
341             return leaves[0];
342         } else {
343             return proof[0];
344         }
345     }
346 
347     /**
348      * @dev Calldata version of {processMultiProof}.
349      *
350      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
351      *
352      * _Available since v4.7._
353      */
354     function processMultiProofCalldata(
355         bytes32[] calldata proof,
356         bool[] calldata proofFlags,
357         bytes32[] memory leaves
358     ) internal pure returns (bytes32 merkleRoot) {
359         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
360         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
361         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
362         // the merkle tree.
363         uint256 leavesLen = leaves.length;
364         uint256 totalHashes = proofFlags.length;
365 
366         // Check proof validity.
367         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
368 
369         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
370         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
371         bytes32[] memory hashes = new bytes32[](totalHashes);
372         uint256 leafPos = 0;
373         uint256 hashPos = 0;
374         uint256 proofPos = 0;
375         // At each step, we compute the next hash using two values:
376         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
377         //   get the next hash.
378         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
379         //   `proof` array.
380         for (uint256 i = 0; i < totalHashes; i++) {
381             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
382             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
383             hashes[i] = _hashPair(a, b);
384         }
385 
386         if (totalHashes > 0) {
387             return hashes[totalHashes - 1];
388         } else if (leavesLen > 0) {
389             return leaves[0];
390         } else {
391             return proof[0];
392         }
393     }
394 
395     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
396         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
397     }
398 
399     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
400         /// @solidity memory-safe-assembly
401         assembly {
402             mstore(0x00, a)
403             mstore(0x20, b)
404             value := keccak256(0x00, 0x40)
405         }
406     }
407 }
408 
409 // File: @openzeppelin/contracts/utils/math/Math.sol
410 
411 
412 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
413 
414 pragma solidity ^0.8.0;
415 
416 /**
417  * @dev Standard math utilities missing in the Solidity language.
418  */
419 library Math {
420     enum Rounding {
421         Down, // Toward negative infinity
422         Up, // Toward infinity
423         Zero // Toward zero
424     }
425 
426     /**
427      * @dev Returns the largest of two numbers.
428      */
429     function max(uint256 a, uint256 b) internal pure returns (uint256) {
430         return a > b ? a : b;
431     }
432 
433     /**
434      * @dev Returns the smallest of two numbers.
435      */
436     function min(uint256 a, uint256 b) internal pure returns (uint256) {
437         return a < b ? a : b;
438     }
439 
440     /**
441      * @dev Returns the average of two numbers. The result is rounded towards
442      * zero.
443      */
444     function average(uint256 a, uint256 b) internal pure returns (uint256) {
445         // (a + b) / 2 can overflow.
446         return (a & b) + (a ^ b) / 2;
447     }
448 
449     /**
450      * @dev Returns the ceiling of the division of two numbers.
451      *
452      * This differs from standard division with `/` in that it rounds up instead
453      * of rounding down.
454      */
455     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
456         // (a + b - 1) / b can overflow on addition, so we distribute.
457         return a == 0 ? 0 : (a - 1) / b + 1;
458     }
459 
460     /**
461      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
462      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
463      * with further edits by Uniswap Labs also under MIT license.
464      */
465     function mulDiv(
466         uint256 x,
467         uint256 y,
468         uint256 denominator
469     ) internal pure returns (uint256 result) {
470         unchecked {
471             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
472             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
473             // variables such that product = prod1 * 2^256 + prod0.
474             uint256 prod0; // Least significant 256 bits of the product
475             uint256 prod1; // Most significant 256 bits of the product
476             assembly {
477                 let mm := mulmod(x, y, not(0))
478                 prod0 := mul(x, y)
479                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
480             }
481 
482             // Handle non-overflow cases, 256 by 256 division.
483             if (prod1 == 0) {
484                 return prod0 / denominator;
485             }
486 
487             // Make sure the result is less than 2^256. Also prevents denominator == 0.
488             require(denominator > prod1);
489 
490             ///////////////////////////////////////////////
491             // 512 by 256 division.
492             ///////////////////////////////////////////////
493 
494             // Make division exact by subtracting the remainder from [prod1 prod0].
495             uint256 remainder;
496             assembly {
497                 // Compute remainder using mulmod.
498                 remainder := mulmod(x, y, denominator)
499 
500                 // Subtract 256 bit number from 512 bit number.
501                 prod1 := sub(prod1, gt(remainder, prod0))
502                 prod0 := sub(prod0, remainder)
503             }
504 
505             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
506             // See https://cs.stackexchange.com/q/138556/92363.
507 
508             // Does not overflow because the denominator cannot be zero at this stage in the function.
509             uint256 twos = denominator & (~denominator + 1);
510             assembly {
511                 // Divide denominator by twos.
512                 denominator := div(denominator, twos)
513 
514                 // Divide [prod1 prod0] by twos.
515                 prod0 := div(prod0, twos)
516 
517                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
518                 twos := add(div(sub(0, twos), twos), 1)
519             }
520 
521             // Shift in bits from prod1 into prod0.
522             prod0 |= prod1 * twos;
523 
524             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
525             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
526             // four bits. That is, denominator * inv = 1 mod 2^4.
527             uint256 inverse = (3 * denominator) ^ 2;
528 
529             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
530             // in modular arithmetic, doubling the correct bits in each step.
531             inverse *= 2 - denominator * inverse; // inverse mod 2^8
532             inverse *= 2 - denominator * inverse; // inverse mod 2^16
533             inverse *= 2 - denominator * inverse; // inverse mod 2^32
534             inverse *= 2 - denominator * inverse; // inverse mod 2^64
535             inverse *= 2 - denominator * inverse; // inverse mod 2^128
536             inverse *= 2 - denominator * inverse; // inverse mod 2^256
537 
538             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
539             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
540             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
541             // is no longer required.
542             result = prod0 * inverse;
543             return result;
544         }
545     }
546 
547     /**
548      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
549      */
550     function mulDiv(
551         uint256 x,
552         uint256 y,
553         uint256 denominator,
554         Rounding rounding
555     ) internal pure returns (uint256) {
556         uint256 result = mulDiv(x, y, denominator);
557         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
558             result += 1;
559         }
560         return result;
561     }
562 
563     /**
564      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
565      *
566      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
567      */
568     function sqrt(uint256 a) internal pure returns (uint256) {
569         if (a == 0) {
570             return 0;
571         }
572 
573         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
574         //
575         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
576         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
577         //
578         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
579         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
580         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
581         //
582         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
583         uint256 result = 1 << (log2(a) >> 1);
584 
585         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
586         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
587         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
588         // into the expected uint128 result.
589         unchecked {
590             result = (result + a / result) >> 1;
591             result = (result + a / result) >> 1;
592             result = (result + a / result) >> 1;
593             result = (result + a / result) >> 1;
594             result = (result + a / result) >> 1;
595             result = (result + a / result) >> 1;
596             result = (result + a / result) >> 1;
597             return min(result, a / result);
598         }
599     }
600 
601     /**
602      * @notice Calculates sqrt(a), following the selected rounding direction.
603      */
604     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
605         unchecked {
606             uint256 result = sqrt(a);
607             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
608         }
609     }
610 
611     /**
612      * @dev Return the log in base 2, rounded down, of a positive value.
613      * Returns 0 if given 0.
614      */
615     function log2(uint256 value) internal pure returns (uint256) {
616         uint256 result = 0;
617         unchecked {
618             if (value >> 128 > 0) {
619                 value >>= 128;
620                 result += 128;
621             }
622             if (value >> 64 > 0) {
623                 value >>= 64;
624                 result += 64;
625             }
626             if (value >> 32 > 0) {
627                 value >>= 32;
628                 result += 32;
629             }
630             if (value >> 16 > 0) {
631                 value >>= 16;
632                 result += 16;
633             }
634             if (value >> 8 > 0) {
635                 value >>= 8;
636                 result += 8;
637             }
638             if (value >> 4 > 0) {
639                 value >>= 4;
640                 result += 4;
641             }
642             if (value >> 2 > 0) {
643                 value >>= 2;
644                 result += 2;
645             }
646             if (value >> 1 > 0) {
647                 result += 1;
648             }
649         }
650         return result;
651     }
652 
653     /**
654      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
655      * Returns 0 if given 0.
656      */
657     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
658         unchecked {
659             uint256 result = log2(value);
660             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
661         }
662     }
663 
664     /**
665      * @dev Return the log in base 10, rounded down, of a positive value.
666      * Returns 0 if given 0.
667      */
668     function log10(uint256 value) internal pure returns (uint256) {
669         uint256 result = 0;
670         unchecked {
671             if (value >= 10**64) {
672                 value /= 10**64;
673                 result += 64;
674             }
675             if (value >= 10**32) {
676                 value /= 10**32;
677                 result += 32;
678             }
679             if (value >= 10**16) {
680                 value /= 10**16;
681                 result += 16;
682             }
683             if (value >= 10**8) {
684                 value /= 10**8;
685                 result += 8;
686             }
687             if (value >= 10**4) {
688                 value /= 10**4;
689                 result += 4;
690             }
691             if (value >= 10**2) {
692                 value /= 10**2;
693                 result += 2;
694             }
695             if (value >= 10**1) {
696                 result += 1;
697             }
698         }
699         return result;
700     }
701 
702     /**
703      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
704      * Returns 0 if given 0.
705      */
706     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
707         unchecked {
708             uint256 result = log10(value);
709             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
710         }
711     }
712 
713     /**
714      * @dev Return the log in base 256, rounded down, of a positive value.
715      * Returns 0 if given 0.
716      *
717      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
718      */
719     function log256(uint256 value) internal pure returns (uint256) {
720         uint256 result = 0;
721         unchecked {
722             if (value >> 128 > 0) {
723                 value >>= 128;
724                 result += 16;
725             }
726             if (value >> 64 > 0) {
727                 value >>= 64;
728                 result += 8;
729             }
730             if (value >> 32 > 0) {
731                 value >>= 32;
732                 result += 4;
733             }
734             if (value >> 16 > 0) {
735                 value >>= 16;
736                 result += 2;
737             }
738             if (value >> 8 > 0) {
739                 result += 1;
740             }
741         }
742         return result;
743     }
744 
745     /**
746      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
747      * Returns 0 if given 0.
748      */
749     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
750         unchecked {
751             uint256 result = log256(value);
752             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
753         }
754     }
755 }
756 
757 // File: @openzeppelin/contracts/utils/Strings.sol
758 
759 
760 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 /**
766  * @dev String operations.
767  */
768 library Strings {
769     bytes16 private constant _SYMBOLS = "0123456789abcdef";
770     uint8 private constant _ADDRESS_LENGTH = 20;
771 
772     /**
773      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
774      */
775     function toString(uint256 value) internal pure returns (string memory) {
776         unchecked {
777             uint256 length = Math.log10(value) + 1;
778             string memory buffer = new string(length);
779             uint256 ptr;
780             /// @solidity memory-safe-assembly
781             assembly {
782                 ptr := add(buffer, add(32, length))
783             }
784             while (true) {
785                 ptr--;
786                 /// @solidity memory-safe-assembly
787                 assembly {
788                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
789                 }
790                 value /= 10;
791                 if (value == 0) break;
792             }
793             return buffer;
794         }
795     }
796 
797     /**
798      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
799      */
800     function toHexString(uint256 value) internal pure returns (string memory) {
801         unchecked {
802             return toHexString(value, Math.log256(value) + 1);
803         }
804     }
805 
806     /**
807      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
808      */
809     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
810         bytes memory buffer = new bytes(2 * length + 2);
811         buffer[0] = "0";
812         buffer[1] = "x";
813         for (uint256 i = 2 * length + 1; i > 1; --i) {
814             buffer[i] = _SYMBOLS[value & 0xf];
815             value >>= 4;
816         }
817         require(value == 0, "Strings: hex length insufficient");
818         return string(buffer);
819     }
820 
821     /**
822      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
823      */
824     function toHexString(address addr) internal pure returns (string memory) {
825         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
826     }
827 }
828 
829 // File: erc721a/contracts/IERC721A.sol
830 
831 
832 // ERC721A Contracts v4.2.3
833 // Creator: Chiru Labs
834 
835 pragma solidity ^0.8.4;
836 
837 /**
838  * @dev Interface of ERC721A.
839  */
840 interface IERC721A {
841     /**
842      * The caller must own the token or be an approved operator.
843      */
844     error ApprovalCallerNotOwnerNorApproved();
845 
846     /**
847      * The token does not exist.
848      */
849     error ApprovalQueryForNonexistentToken();
850 
851     /**
852      * Cannot query the balance for the zero address.
853      */
854     error BalanceQueryForZeroAddress();
855 
856     /**
857      * Cannot mint to the zero address.
858      */
859     error MintToZeroAddress();
860 
861     /**
862      * The quantity of tokens minted must be more than zero.
863      */
864     error MintZeroQuantity();
865 
866     /**
867      * The token does not exist.
868      */
869     error OwnerQueryForNonexistentToken();
870 
871     /**
872      * The caller must own the token or be an approved operator.
873      */
874     error TransferCallerNotOwnerNorApproved();
875 
876     /**
877      * The token must be owned by `from`.
878      */
879     error TransferFromIncorrectOwner();
880 
881     /**
882      * Cannot safely transfer to a contract that does not implement the
883      * ERC721Receiver interface.
884      */
885     error TransferToNonERC721ReceiverImplementer();
886 
887     /**
888      * Cannot transfer to the zero address.
889      */
890     error TransferToZeroAddress();
891 
892     /**
893      * The token does not exist.
894      */
895     error URIQueryForNonexistentToken();
896 
897     /**
898      * The `quantity` minted with ERC2309 exceeds the safety limit.
899      */
900     error MintERC2309QuantityExceedsLimit();
901 
902     /**
903      * The `extraData` cannot be set on an unintialized ownership slot.
904      */
905     error OwnershipNotInitializedForExtraData();
906 
907     // =============================================================
908     //                            STRUCTS
909     // =============================================================
910 
911     struct TokenOwnership {
912         // The address of the owner.
913         address addr;
914         // Stores the start time of ownership with minimal overhead for tokenomics.
915         uint64 startTimestamp;
916         // Whether the token has been burned.
917         bool burned;
918         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
919         uint24 extraData;
920     }
921 
922     // =============================================================
923     //                         TOKEN COUNTERS
924     // =============================================================
925 
926     /**
927      * @dev Returns the total number of tokens in existence.
928      * Burned tokens will reduce the count.
929      * To get the total number of tokens minted, please see {_totalMinted}.
930      */
931     function totalSupply() external view returns (uint256);
932 
933     // =============================================================
934     //                            IERC165
935     // =============================================================
936 
937     /**
938      * @dev Returns true if this contract implements the interface defined by
939      * `interfaceId`. See the corresponding
940      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
941      * to learn more about how these ids are created.
942      *
943      * This function call must use less than 30000 gas.
944      */
945     function supportsInterface(bytes4 interfaceId) external view returns (bool);
946 
947     // =============================================================
948     //                            IERC721
949     // =============================================================
950 
951     /**
952      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
953      */
954     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
955 
956     /**
957      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
958      */
959     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
960 
961     /**
962      * @dev Emitted when `owner` enables or disables
963      * (`approved`) `operator` to manage all of its assets.
964      */
965     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
966 
967     /**
968      * @dev Returns the number of tokens in `owner`'s account.
969      */
970     function balanceOf(address owner) external view returns (uint256 balance);
971 
972     /**
973      * @dev Returns the owner of the `tokenId` token.
974      *
975      * Requirements:
976      *
977      * - `tokenId` must exist.
978      */
979     function ownerOf(uint256 tokenId) external view returns (address owner);
980 
981     /**
982      * @dev Safely transfers `tokenId` token from `from` to `to`,
983      * checking first that contract recipients are aware of the ERC721 protocol
984      * to prevent tokens from being forever locked.
985      *
986      * Requirements:
987      *
988      * - `from` cannot be the zero address.
989      * - `to` cannot be the zero address.
990      * - `tokenId` token must exist and be owned by `from`.
991      * - If the caller is not `from`, it must be have been allowed to move
992      * this token by either {approve} or {setApprovalForAll}.
993      * - If `to` refers to a smart contract, it must implement
994      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
995      *
996      * Emits a {Transfer} event.
997      */
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes calldata data
1003     ) external payable;
1004 
1005     /**
1006      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) external payable;
1013 
1014     /**
1015      * @dev Transfers `tokenId` from `from` to `to`.
1016      *
1017      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1018      * whenever possible.
1019      *
1020      * Requirements:
1021      *
1022      * - `from` cannot be the zero address.
1023      * - `to` cannot be the zero address.
1024      * - `tokenId` token must be owned by `from`.
1025      * - If the caller is not `from`, it must be approved to move this token
1026      * by either {approve} or {setApprovalForAll}.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function transferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) external payable;
1035 
1036     /**
1037      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1038      * The approval is cleared when the token is transferred.
1039      *
1040      * Only a single account can be approved at a time, so approving the
1041      * zero address clears previous approvals.
1042      *
1043      * Requirements:
1044      *
1045      * - The caller must own the token or be an approved operator.
1046      * - `tokenId` must exist.
1047      *
1048      * Emits an {Approval} event.
1049      */
1050     function approve(address to, uint256 tokenId) external payable;
1051 
1052     /**
1053      * @dev Approve or remove `operator` as an operator for the caller.
1054      * Operators can call {transferFrom} or {safeTransferFrom}
1055      * for any token owned by the caller.
1056      *
1057      * Requirements:
1058      *
1059      * - The `operator` cannot be the caller.
1060      *
1061      * Emits an {ApprovalForAll} event.
1062      */
1063     function setApprovalForAll(address operator, bool _approved) external;
1064 
1065     /**
1066      * @dev Returns the account approved for `tokenId` token.
1067      *
1068      * Requirements:
1069      *
1070      * - `tokenId` must exist.
1071      */
1072     function getApproved(uint256 tokenId) external view returns (address operator);
1073 
1074     /**
1075      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1076      *
1077      * See {setApprovalForAll}.
1078      */
1079     function isApprovedForAll(address owner, address operator) external view returns (bool);
1080 
1081     // =============================================================
1082     //                        IERC721Metadata
1083     // =============================================================
1084 
1085     /**
1086      * @dev Returns the token collection name.
1087      */
1088     function name() external view returns (string memory);
1089 
1090     /**
1091      * @dev Returns the token collection symbol.
1092      */
1093     function symbol() external view returns (string memory);
1094 
1095     /**
1096      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1097      */
1098     function tokenURI(uint256 tokenId) external view returns (string memory);
1099 
1100     // =============================================================
1101     //                           IERC2309
1102     // =============================================================
1103 
1104     /**
1105      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1106      * (inclusive) is transferred from `from` to `to`, as defined in the
1107      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1108      *
1109      * See {_mintERC2309} for more details.
1110      */
1111     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1112 }
1113 
1114 // File: erc721a/contracts/ERC721A.sol
1115 
1116 
1117 // ERC721A Contracts v4.2.3
1118 // Creator: Chiru Labs
1119 
1120 pragma solidity ^0.8.4;
1121 
1122 
1123 /**
1124  * @dev Interface of ERC721 token receiver.
1125  */
1126 interface ERC721A__IERC721Receiver {
1127     function onERC721Received(
1128         address operator,
1129         address from,
1130         uint256 tokenId,
1131         bytes calldata data
1132     ) external returns (bytes4);
1133 }
1134 
1135 /**
1136  * @title ERC721A
1137  *
1138  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1139  * Non-Fungible Token Standard, including the Metadata extension.
1140  * Optimized for lower gas during batch mints.
1141  *
1142  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1143  * starting from `_startTokenId()`.
1144  *
1145  * Assumptions:
1146  *
1147  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1148  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1149  */
1150 contract ERC721A is IERC721A {
1151     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1152     struct TokenApprovalRef {
1153         address value;
1154     }
1155 
1156     // =============================================================
1157     //                           CONSTANTS
1158     // =============================================================
1159 
1160     // Mask of an entry in packed address data.
1161     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1162 
1163     // The bit position of `numberMinted` in packed address data.
1164     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1165 
1166     // The bit position of `numberBurned` in packed address data.
1167     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1168 
1169     // The bit position of `aux` in packed address data.
1170     uint256 private constant _BITPOS_AUX = 192;
1171 
1172     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1173     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1174 
1175     // The bit position of `startTimestamp` in packed ownership.
1176     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1177 
1178     // The bit mask of the `burned` bit in packed ownership.
1179     uint256 private constant _BITMASK_BURNED = 1 << 224;
1180 
1181     // The bit position of the `nextInitialized` bit in packed ownership.
1182     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1183 
1184     // The bit mask of the `nextInitialized` bit in packed ownership.
1185     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1186 
1187     // The bit position of `extraData` in packed ownership.
1188     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1189 
1190     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1191     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1192 
1193     // The mask of the lower 160 bits for addresses.
1194     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1195 
1196     // The maximum `quantity` that can be minted with {_mintERC2309}.
1197     // This limit is to prevent overflows on the address data entries.
1198     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1199     // is required to cause an overflow, which is unrealistic.
1200     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1201 
1202     // The `Transfer` event signature is given by:
1203     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1204     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1205         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1206 
1207     // =============================================================
1208     //                            STORAGE
1209     // =============================================================
1210 
1211     // The next token ID to be minted.
1212     uint256 private _currentIndex;
1213 
1214     // The number of tokens burned.
1215     uint256 private _burnCounter;
1216 
1217     // Token name
1218     string private _name;
1219 
1220     // Token symbol
1221     string private _symbol;
1222 
1223     // Mapping from token ID to ownership details
1224     // An empty struct value does not necessarily mean the token is unowned.
1225     // See {_packedOwnershipOf} implementation for details.
1226     //
1227     // Bits Layout:
1228     // - [0..159]   `addr`
1229     // - [160..223] `startTimestamp`
1230     // - [224]      `burned`
1231     // - [225]      `nextInitialized`
1232     // - [232..255] `extraData`
1233     mapping(uint256 => uint256) private _packedOwnerships;
1234 
1235     // Mapping owner address to address data.
1236     //
1237     // Bits Layout:
1238     // - [0..63]    `balance`
1239     // - [64..127]  `numberMinted`
1240     // - [128..191] `numberBurned`
1241     // - [192..255] `aux`
1242     mapping(address => uint256) private _packedAddressData;
1243 
1244     // Mapping from token ID to approved address.
1245     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1246 
1247     // Mapping from owner to operator approvals
1248     mapping(address => mapping(address => bool)) private _operatorApprovals;
1249 
1250     // =============================================================
1251     //                          CONSTRUCTOR
1252     // =============================================================
1253 
1254     constructor(string memory name_, string memory symbol_) {
1255         _name = name_;
1256         _symbol = symbol_;
1257         _currentIndex = _startTokenId();
1258     }
1259 
1260     // =============================================================
1261     //                   TOKEN COUNTING OPERATIONS
1262     // =============================================================
1263 
1264     /**
1265      * @dev Returns the starting token ID.
1266      * To change the starting token ID, please override this function.
1267      */
1268     function _startTokenId() internal view virtual returns (uint256) {
1269         return 0;
1270     }
1271 
1272     /**
1273      * @dev Returns the next token ID to be minted.
1274      */
1275     function _nextTokenId() internal view virtual returns (uint256) {
1276         return _currentIndex;
1277     }
1278 
1279     /**
1280      * @dev Returns the total number of tokens in existence.
1281      * Burned tokens will reduce the count.
1282      * To get the total number of tokens minted, please see {_totalMinted}.
1283      */
1284     function totalSupply() public view virtual override returns (uint256) {
1285         // Counter underflow is impossible as _burnCounter cannot be incremented
1286         // more than `_currentIndex - _startTokenId()` times.
1287         unchecked {
1288             return _currentIndex - _burnCounter - _startTokenId();
1289         }
1290     }
1291 
1292     /**
1293      * @dev Returns the total amount of tokens minted in the contract.
1294      */
1295     function _totalMinted() internal view virtual returns (uint256) {
1296         // Counter underflow is impossible as `_currentIndex` does not decrement,
1297         // and it is initialized to `_startTokenId()`.
1298         unchecked {
1299             return _currentIndex - _startTokenId();
1300         }
1301     }
1302 
1303     /**
1304      * @dev Returns the total number of tokens burned.
1305      */
1306     function _totalBurned() internal view virtual returns (uint256) {
1307         return _burnCounter;
1308     }
1309 
1310     // =============================================================
1311     //                    ADDRESS DATA OPERATIONS
1312     // =============================================================
1313 
1314     /**
1315      * @dev Returns the number of tokens in `owner`'s account.
1316      */
1317     function balanceOf(address owner) public view virtual override returns (uint256) {
1318         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1319         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1320     }
1321 
1322     /**
1323      * Returns the number of tokens minted by `owner`.
1324      */
1325     function _numberMinted(address owner) internal view returns (uint256) {
1326         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1327     }
1328 
1329     /**
1330      * Returns the number of tokens burned by or on behalf of `owner`.
1331      */
1332     function _numberBurned(address owner) internal view returns (uint256) {
1333         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1334     }
1335 
1336     /**
1337      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1338      */
1339     function _getAux(address owner) internal view returns (uint64) {
1340         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1341     }
1342 
1343     /**
1344      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1345      * If there are multiple variables, please pack them into a uint64.
1346      */
1347     function _setAux(address owner, uint64 aux) internal virtual {
1348         uint256 packed = _packedAddressData[owner];
1349         uint256 auxCasted;
1350         // Cast `aux` with assembly to avoid redundant masking.
1351         assembly {
1352             auxCasted := aux
1353         }
1354         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1355         _packedAddressData[owner] = packed;
1356     }
1357 
1358     // =============================================================
1359     //                            IERC165
1360     // =============================================================
1361 
1362     /**
1363      * @dev Returns true if this contract implements the interface defined by
1364      * `interfaceId`. See the corresponding
1365      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1366      * to learn more about how these ids are created.
1367      *
1368      * This function call must use less than 30000 gas.
1369      */
1370     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1371         // The interface IDs are constants representing the first 4 bytes
1372         // of the XOR of all function selectors in the interface.
1373         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1374         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1375         return
1376             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1377             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1378             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1379     }
1380 
1381     // =============================================================
1382     //                        IERC721Metadata
1383     // =============================================================
1384 
1385     /**
1386      * @dev Returns the token collection name.
1387      */
1388     function name() public view virtual override returns (string memory) {
1389         return _name;
1390     }
1391 
1392     /**
1393      * @dev Returns the token collection symbol.
1394      */
1395     function symbol() public view virtual override returns (string memory) {
1396         return _symbol;
1397     }
1398 
1399     /**
1400      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1401      */
1402     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1403         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1404 
1405         string memory baseURI = _baseURI();
1406         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1407     }
1408 
1409     /**
1410      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1411      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1412      * by default, it can be overridden in child contracts.
1413      */
1414     function _baseURI() internal view virtual returns (string memory) {
1415         return '';
1416     }
1417 
1418     // =============================================================
1419     //                     OWNERSHIPS OPERATIONS
1420     // =============================================================
1421 
1422     /**
1423      * @dev Returns the owner of the `tokenId` token.
1424      *
1425      * Requirements:
1426      *
1427      * - `tokenId` must exist.
1428      */
1429     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1430         return address(uint160(_packedOwnershipOf(tokenId)));
1431     }
1432 
1433     /**
1434      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1435      * It gradually moves to O(1) as tokens get transferred around over time.
1436      */
1437     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1438         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1439     }
1440 
1441     /**
1442      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1443      */
1444     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1445         return _unpackedOwnership(_packedOwnerships[index]);
1446     }
1447 
1448     /**
1449      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1450      */
1451     function _initializeOwnershipAt(uint256 index) internal virtual {
1452         if (_packedOwnerships[index] == 0) {
1453             _packedOwnerships[index] = _packedOwnershipOf(index);
1454         }
1455     }
1456 
1457     /**
1458      * Returns the packed ownership data of `tokenId`.
1459      */
1460     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1461         uint256 curr = tokenId;
1462 
1463         unchecked {
1464             if (_startTokenId() <= curr)
1465                 if (curr < _currentIndex) {
1466                     uint256 packed = _packedOwnerships[curr];
1467                     // If not burned.
1468                     if (packed & _BITMASK_BURNED == 0) {
1469                         // Invariant:
1470                         // There will always be an initialized ownership slot
1471                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1472                         // before an unintialized ownership slot
1473                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1474                         // Hence, `curr` will not underflow.
1475                         //
1476                         // We can directly compare the packed value.
1477                         // If the address is zero, packed will be zero.
1478                         while (packed == 0) {
1479                             packed = _packedOwnerships[--curr];
1480                         }
1481                         return packed;
1482                     }
1483                 }
1484         }
1485         revert OwnerQueryForNonexistentToken();
1486     }
1487 
1488     /**
1489      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1490      */
1491     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1492         ownership.addr = address(uint160(packed));
1493         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1494         ownership.burned = packed & _BITMASK_BURNED != 0;
1495         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1496     }
1497 
1498     /**
1499      * @dev Packs ownership data into a single uint256.
1500      */
1501     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1502         assembly {
1503             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1504             owner := and(owner, _BITMASK_ADDRESS)
1505             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1506             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1507         }
1508     }
1509 
1510     /**
1511      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1512      */
1513     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1514         // For branchless setting of the `nextInitialized` flag.
1515         assembly {
1516             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1517             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1518         }
1519     }
1520 
1521     // =============================================================
1522     //                      APPROVAL OPERATIONS
1523     // =============================================================
1524 
1525     /**
1526      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1527      * The approval is cleared when the token is transferred.
1528      *
1529      * Only a single account can be approved at a time, so approving the
1530      * zero address clears previous approvals.
1531      *
1532      * Requirements:
1533      *
1534      * - The caller must own the token or be an approved operator.
1535      * - `tokenId` must exist.
1536      *
1537      * Emits an {Approval} event.
1538      */
1539     function approve(address to, uint256 tokenId) public payable virtual override {
1540         address owner = ownerOf(tokenId);
1541 
1542         if (_msgSenderERC721A() != owner)
1543             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1544                 revert ApprovalCallerNotOwnerNorApproved();
1545             }
1546 
1547         _tokenApprovals[tokenId].value = to;
1548         emit Approval(owner, to, tokenId);
1549     }
1550 
1551     /**
1552      * @dev Returns the account approved for `tokenId` token.
1553      *
1554      * Requirements:
1555      *
1556      * - `tokenId` must exist.
1557      */
1558     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1559         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1560 
1561         return _tokenApprovals[tokenId].value;
1562     }
1563 
1564     /**
1565      * @dev Approve or remove `operator` as an operator for the caller.
1566      * Operators can call {transferFrom} or {safeTransferFrom}
1567      * for any token owned by the caller.
1568      *
1569      * Requirements:
1570      *
1571      * - The `operator` cannot be the caller.
1572      *
1573      * Emits an {ApprovalForAll} event.
1574      */
1575     function setApprovalForAll(address operator, bool approved) public virtual override {
1576         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1577         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1578     }
1579 
1580     /**
1581      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1582      *
1583      * See {setApprovalForAll}.
1584      */
1585     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1586         return _operatorApprovals[owner][operator];
1587     }
1588 
1589     /**
1590      * @dev Returns whether `tokenId` exists.
1591      *
1592      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1593      *
1594      * Tokens start existing when they are minted. See {_mint}.
1595      */
1596     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1597         return
1598             _startTokenId() <= tokenId &&
1599             tokenId < _currentIndex && // If within bounds,
1600             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1601     }
1602 
1603     /**
1604      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1605      */
1606     function _isSenderApprovedOrOwner(
1607         address approvedAddress,
1608         address owner,
1609         address msgSender
1610     ) private pure returns (bool result) {
1611         assembly {
1612             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1613             owner := and(owner, _BITMASK_ADDRESS)
1614             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1615             msgSender := and(msgSender, _BITMASK_ADDRESS)
1616             // `msgSender == owner || msgSender == approvedAddress`.
1617             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1618         }
1619     }
1620 
1621     /**
1622      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1623      */
1624     function _getApprovedSlotAndAddress(uint256 tokenId)
1625         private
1626         view
1627         returns (uint256 approvedAddressSlot, address approvedAddress)
1628     {
1629         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1630         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1631         assembly {
1632             approvedAddressSlot := tokenApproval.slot
1633             approvedAddress := sload(approvedAddressSlot)
1634         }
1635     }
1636 
1637     // =============================================================
1638     //                      TRANSFER OPERATIONS
1639     // =============================================================
1640 
1641     /**
1642      * @dev Transfers `tokenId` from `from` to `to`.
1643      *
1644      * Requirements:
1645      *
1646      * - `from` cannot be the zero address.
1647      * - `to` cannot be the zero address.
1648      * - `tokenId` token must be owned by `from`.
1649      * - If the caller is not `from`, it must be approved to move this token
1650      * by either {approve} or {setApprovalForAll}.
1651      *
1652      * Emits a {Transfer} event.
1653      */
1654     function transferFrom(
1655         address from,
1656         address to,
1657         uint256 tokenId
1658     ) public payable virtual override {
1659         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1660 
1661         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1662 
1663         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1664 
1665         // The nested ifs save around 20+ gas over a compound boolean condition.
1666         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1667             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1668 
1669         if (to == address(0)) revert TransferToZeroAddress();
1670 
1671         _beforeTokenTransfers(from, to, tokenId, 1);
1672 
1673         // Clear approvals from the previous owner.
1674         assembly {
1675             if approvedAddress {
1676                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1677                 sstore(approvedAddressSlot, 0)
1678             }
1679         }
1680 
1681         // Underflow of the sender's balance is impossible because we check for
1682         // ownership above and the recipient's balance can't realistically overflow.
1683         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1684         unchecked {
1685             // We can directly increment and decrement the balances.
1686             --_packedAddressData[from]; // Updates: `balance -= 1`.
1687             ++_packedAddressData[to]; // Updates: `balance += 1`.
1688 
1689             // Updates:
1690             // - `address` to the next owner.
1691             // - `startTimestamp` to the timestamp of transfering.
1692             // - `burned` to `false`.
1693             // - `nextInitialized` to `true`.
1694             _packedOwnerships[tokenId] = _packOwnershipData(
1695                 to,
1696                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1697             );
1698 
1699             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1700             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1701                 uint256 nextTokenId = tokenId + 1;
1702                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1703                 if (_packedOwnerships[nextTokenId] == 0) {
1704                     // If the next slot is within bounds.
1705                     if (nextTokenId != _currentIndex) {
1706                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1707                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1708                     }
1709                 }
1710             }
1711         }
1712 
1713         emit Transfer(from, to, tokenId);
1714         _afterTokenTransfers(from, to, tokenId, 1);
1715     }
1716 
1717     /**
1718      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1719      */
1720     function safeTransferFrom(
1721         address from,
1722         address to,
1723         uint256 tokenId
1724     ) public payable virtual override {
1725         safeTransferFrom(from, to, tokenId, '');
1726     }
1727 
1728     /**
1729      * @dev Safely transfers `tokenId` token from `from` to `to`.
1730      *
1731      * Requirements:
1732      *
1733      * - `from` cannot be the zero address.
1734      * - `to` cannot be the zero address.
1735      * - `tokenId` token must exist and be owned by `from`.
1736      * - If the caller is not `from`, it must be approved to move this token
1737      * by either {approve} or {setApprovalForAll}.
1738      * - If `to` refers to a smart contract, it must implement
1739      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1740      *
1741      * Emits a {Transfer} event.
1742      */
1743     function safeTransferFrom(
1744         address from,
1745         address to,
1746         uint256 tokenId,
1747         bytes memory _data
1748     ) public payable virtual override {
1749         transferFrom(from, to, tokenId);
1750         if (to.code.length != 0)
1751             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1752                 revert TransferToNonERC721ReceiverImplementer();
1753             }
1754     }
1755 
1756     /**
1757      * @dev Hook that is called before a set of serially-ordered token IDs
1758      * are about to be transferred. This includes minting.
1759      * And also called before burning one token.
1760      *
1761      * `startTokenId` - the first token ID to be transferred.
1762      * `quantity` - the amount to be transferred.
1763      *
1764      * Calling conditions:
1765      *
1766      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1767      * transferred to `to`.
1768      * - When `from` is zero, `tokenId` will be minted for `to`.
1769      * - When `to` is zero, `tokenId` will be burned by `from`.
1770      * - `from` and `to` are never both zero.
1771      */
1772     function _beforeTokenTransfers(
1773         address from,
1774         address to,
1775         uint256 startTokenId,
1776         uint256 quantity
1777     ) internal virtual {}
1778 
1779     /**
1780      * @dev Hook that is called after a set of serially-ordered token IDs
1781      * have been transferred. This includes minting.
1782      * And also called after one token has been burned.
1783      *
1784      * `startTokenId` - the first token ID to be transferred.
1785      * `quantity` - the amount to be transferred.
1786      *
1787      * Calling conditions:
1788      *
1789      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1790      * transferred to `to`.
1791      * - When `from` is zero, `tokenId` has been minted for `to`.
1792      * - When `to` is zero, `tokenId` has been burned by `from`.
1793      * - `from` and `to` are never both zero.
1794      */
1795     function _afterTokenTransfers(
1796         address from,
1797         address to,
1798         uint256 startTokenId,
1799         uint256 quantity
1800     ) internal virtual {}
1801 
1802     /**
1803      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1804      *
1805      * `from` - Previous owner of the given token ID.
1806      * `to` - Target address that will receive the token.
1807      * `tokenId` - Token ID to be transferred.
1808      * `_data` - Optional data to send along with the call.
1809      *
1810      * Returns whether the call correctly returned the expected magic value.
1811      */
1812     function _checkContractOnERC721Received(
1813         address from,
1814         address to,
1815         uint256 tokenId,
1816         bytes memory _data
1817     ) private returns (bool) {
1818         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1819             bytes4 retval
1820         ) {
1821             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1822         } catch (bytes memory reason) {
1823             if (reason.length == 0) {
1824                 revert TransferToNonERC721ReceiverImplementer();
1825             } else {
1826                 assembly {
1827                     revert(add(32, reason), mload(reason))
1828                 }
1829             }
1830         }
1831     }
1832 
1833     // =============================================================
1834     //                        MINT OPERATIONS
1835     // =============================================================
1836 
1837     /**
1838      * @dev Mints `quantity` tokens and transfers them to `to`.
1839      *
1840      * Requirements:
1841      *
1842      * - `to` cannot be the zero address.
1843      * - `quantity` must be greater than 0.
1844      *
1845      * Emits a {Transfer} event for each mint.
1846      */
1847     function _mint(address to, uint256 quantity) internal virtual {
1848         uint256 startTokenId = _currentIndex;
1849         if (quantity == 0) revert MintZeroQuantity();
1850 
1851         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1852 
1853         // Overflows are incredibly unrealistic.
1854         // `balance` and `numberMinted` have a maximum limit of 2**64.
1855         // `tokenId` has a maximum limit of 2**256.
1856         unchecked {
1857             // Updates:
1858             // - `balance += quantity`.
1859             // - `numberMinted += quantity`.
1860             //
1861             // We can directly add to the `balance` and `numberMinted`.
1862             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1863 
1864             // Updates:
1865             // - `address` to the owner.
1866             // - `startTimestamp` to the timestamp of minting.
1867             // - `burned` to `false`.
1868             // - `nextInitialized` to `quantity == 1`.
1869             _packedOwnerships[startTokenId] = _packOwnershipData(
1870                 to,
1871                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1872             );
1873 
1874             uint256 toMasked;
1875             uint256 end = startTokenId + quantity;
1876 
1877             // Use assembly to loop and emit the `Transfer` event for gas savings.
1878             // The duplicated `log4` removes an extra check and reduces stack juggling.
1879             // The assembly, together with the surrounding Solidity code, have been
1880             // delicately arranged to nudge the compiler into producing optimized opcodes.
1881             assembly {
1882                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1883                 toMasked := and(to, _BITMASK_ADDRESS)
1884                 // Emit the `Transfer` event.
1885                 log4(
1886                     0, // Start of data (0, since no data).
1887                     0, // End of data (0, since no data).
1888                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1889                     0, // `address(0)`.
1890                     toMasked, // `to`.
1891                     startTokenId // `tokenId`.
1892                 )
1893 
1894                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1895                 // that overflows uint256 will make the loop run out of gas.
1896                 // The compiler will optimize the `iszero` away for performance.
1897                 for {
1898                     let tokenId := add(startTokenId, 1)
1899                 } iszero(eq(tokenId, end)) {
1900                     tokenId := add(tokenId, 1)
1901                 } {
1902                     // Emit the `Transfer` event. Similar to above.
1903                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1904                 }
1905             }
1906             if (toMasked == 0) revert MintToZeroAddress();
1907 
1908             _currentIndex = end;
1909         }
1910         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1911     }
1912 
1913     /**
1914      * @dev Mints `quantity` tokens and transfers them to `to`.
1915      *
1916      * This function is intended for efficient minting only during contract creation.
1917      *
1918      * It emits only one {ConsecutiveTransfer} as defined in
1919      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1920      * instead of a sequence of {Transfer} event(s).
1921      *
1922      * Calling this function outside of contract creation WILL make your contract
1923      * non-compliant with the ERC721 standard.
1924      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1925      * {ConsecutiveTransfer} event is only permissible during contract creation.
1926      *
1927      * Requirements:
1928      *
1929      * - `to` cannot be the zero address.
1930      * - `quantity` must be greater than 0.
1931      *
1932      * Emits a {ConsecutiveTransfer} event.
1933      */
1934     function _mintERC2309(address to, uint256 quantity) internal virtual {
1935         uint256 startTokenId = _currentIndex;
1936         if (to == address(0)) revert MintToZeroAddress();
1937         if (quantity == 0) revert MintZeroQuantity();
1938         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1939 
1940         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1941 
1942         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1943         unchecked {
1944             // Updates:
1945             // - `balance += quantity`.
1946             // - `numberMinted += quantity`.
1947             //
1948             // We can directly add to the `balance` and `numberMinted`.
1949             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1950 
1951             // Updates:
1952             // - `address` to the owner.
1953             // - `startTimestamp` to the timestamp of minting.
1954             // - `burned` to `false`.
1955             // - `nextInitialized` to `quantity == 1`.
1956             _packedOwnerships[startTokenId] = _packOwnershipData(
1957                 to,
1958                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1959             );
1960 
1961             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1962 
1963             _currentIndex = startTokenId + quantity;
1964         }
1965         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1966     }
1967 
1968     /**
1969      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1970      *
1971      * Requirements:
1972      *
1973      * - If `to` refers to a smart contract, it must implement
1974      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1975      * - `quantity` must be greater than 0.
1976      *
1977      * See {_mint}.
1978      *
1979      * Emits a {Transfer} event for each mint.
1980      */
1981     function _safeMint(
1982         address to,
1983         uint256 quantity,
1984         bytes memory _data
1985     ) internal virtual {
1986         _mint(to, quantity);
1987 
1988         unchecked {
1989             if (to.code.length != 0) {
1990                 uint256 end = _currentIndex;
1991                 uint256 index = end - quantity;
1992                 do {
1993                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1994                         revert TransferToNonERC721ReceiverImplementer();
1995                     }
1996                 } while (index < end);
1997                 // Reentrancy protection.
1998                 if (_currentIndex != end) revert();
1999             }
2000         }
2001     }
2002 
2003     /**
2004      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2005      */
2006     function _safeMint(address to, uint256 quantity) internal virtual {
2007         _safeMint(to, quantity, '');
2008     }
2009 
2010     // =============================================================
2011     //                        BURN OPERATIONS
2012     // =============================================================
2013 
2014     /**
2015      * @dev Equivalent to `_burn(tokenId, false)`.
2016      */
2017     function _burn(uint256 tokenId) internal virtual {
2018         _burn(tokenId, false);
2019     }
2020 
2021     /**
2022      * @dev Destroys `tokenId`.
2023      * The approval is cleared when the token is burned.
2024      *
2025      * Requirements:
2026      *
2027      * - `tokenId` must exist.
2028      *
2029      * Emits a {Transfer} event.
2030      */
2031     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2032         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2033 
2034         address from = address(uint160(prevOwnershipPacked));
2035 
2036         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2037 
2038         if (approvalCheck) {
2039             // The nested ifs save around 20+ gas over a compound boolean condition.
2040             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2041                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2042         }
2043 
2044         _beforeTokenTransfers(from, address(0), tokenId, 1);
2045 
2046         // Clear approvals from the previous owner.
2047         assembly {
2048             if approvedAddress {
2049                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2050                 sstore(approvedAddressSlot, 0)
2051             }
2052         }
2053 
2054         // Underflow of the sender's balance is impossible because we check for
2055         // ownership above and the recipient's balance can't realistically overflow.
2056         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2057         unchecked {
2058             // Updates:
2059             // - `balance -= 1`.
2060             // - `numberBurned += 1`.
2061             //
2062             // We can directly decrement the balance, and increment the number burned.
2063             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2064             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2065 
2066             // Updates:
2067             // - `address` to the last owner.
2068             // - `startTimestamp` to the timestamp of burning.
2069             // - `burned` to `true`.
2070             // - `nextInitialized` to `true`.
2071             _packedOwnerships[tokenId] = _packOwnershipData(
2072                 from,
2073                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2074             );
2075 
2076             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2077             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2078                 uint256 nextTokenId = tokenId + 1;
2079                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2080                 if (_packedOwnerships[nextTokenId] == 0) {
2081                     // If the next slot is within bounds.
2082                     if (nextTokenId != _currentIndex) {
2083                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2084                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2085                     }
2086                 }
2087             }
2088         }
2089 
2090         emit Transfer(from, address(0), tokenId);
2091         _afterTokenTransfers(from, address(0), tokenId, 1);
2092 
2093         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2094         unchecked {
2095             _burnCounter++;
2096         }
2097     }
2098 
2099     // =============================================================
2100     //                     EXTRA DATA OPERATIONS
2101     // =============================================================
2102 
2103     /**
2104      * @dev Directly sets the extra data for the ownership data `index`.
2105      */
2106     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2107         uint256 packed = _packedOwnerships[index];
2108         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2109         uint256 extraDataCasted;
2110         // Cast `extraData` with assembly to avoid redundant masking.
2111         assembly {
2112             extraDataCasted := extraData
2113         }
2114         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2115         _packedOwnerships[index] = packed;
2116     }
2117 
2118     /**
2119      * @dev Called during each token transfer to set the 24bit `extraData` field.
2120      * Intended to be overridden by the cosumer contract.
2121      *
2122      * `previousExtraData` - the value of `extraData` before transfer.
2123      *
2124      * Calling conditions:
2125      *
2126      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2127      * transferred to `to`.
2128      * - When `from` is zero, `tokenId` will be minted for `to`.
2129      * - When `to` is zero, `tokenId` will be burned by `from`.
2130      * - `from` and `to` are never both zero.
2131      */
2132     function _extraData(
2133         address from,
2134         address to,
2135         uint24 previousExtraData
2136     ) internal view virtual returns (uint24) {}
2137 
2138     /**
2139      * @dev Returns the next extra data for the packed ownership data.
2140      * The returned result is shifted into position.
2141      */
2142     function _nextExtraData(
2143         address from,
2144         address to,
2145         uint256 prevOwnershipPacked
2146     ) private view returns (uint256) {
2147         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2148         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2149     }
2150 
2151     // =============================================================
2152     //                       OTHER OPERATIONS
2153     // =============================================================
2154 
2155     /**
2156      * @dev Returns the message sender (defaults to `msg.sender`).
2157      *
2158      * If you are writing GSN compatible contracts, you need to override this function.
2159      */
2160     function _msgSenderERC721A() internal view virtual returns (address) {
2161         return msg.sender;
2162     }
2163 
2164     /**
2165      * @dev Converts a uint256 to its ASCII string decimal representation.
2166      */
2167     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2168         assembly {
2169             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2170             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2171             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2172             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2173             let m := add(mload(0x40), 0xa0)
2174             // Update the free memory pointer to allocate.
2175             mstore(0x40, m)
2176             // Assign the `str` to the end.
2177             str := sub(m, 0x20)
2178             // Zeroize the slot after the string.
2179             mstore(str, 0)
2180 
2181             // Cache the end of the memory to calculate the length later.
2182             let end := str
2183 
2184             // We write the string from rightmost digit to leftmost digit.
2185             // The following is essentially a do-while loop that also handles the zero case.
2186             // prettier-ignore
2187             for { let temp := value } 1 {} {
2188                 str := sub(str, 1)
2189                 // Write the character to the pointer.
2190                 // The ASCII index of the '0' character is 48.
2191                 mstore8(str, add(48, mod(temp, 10)))
2192                 // Keep dividing `temp` until zero.
2193                 temp := div(temp, 10)
2194                 // prettier-ignore
2195                 if iszero(temp) { break }
2196             }
2197 
2198             let length := sub(end, str)
2199             // Move the pointer 32 bytes leftwards to make room for the length.
2200             str := sub(str, 0x20)
2201             // Store the length.
2202             mstore(str, length)
2203         }
2204     }
2205 }
2206 
2207 // File: @openzeppelin/contracts/utils/Context.sol
2208 
2209 
2210 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2211 
2212 pragma solidity ^0.8.0;
2213 
2214 /**
2215  * @dev Provides information about the current execution context, including the
2216  * sender of the transaction and its data. While these are generally available
2217  * via msg.sender and msg.data, they should not be accessed in such a direct
2218  * manner, since when dealing with meta-transactions the account sending and
2219  * paying for execution may not be the actual sender (as far as an application
2220  * is concerned).
2221  *
2222  * This contract is only required for intermediate, library-like contracts.
2223  */
2224 abstract contract Context {
2225     function _msgSender() internal view virtual returns (address) {
2226         return msg.sender;
2227     }
2228 
2229     function _msgData() internal view virtual returns (bytes calldata) {
2230         return msg.data;
2231     }
2232 }
2233 
2234 // File: @openzeppelin/contracts/access/Ownable.sol
2235 
2236 
2237 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2238 
2239 pragma solidity ^0.8.0;
2240 
2241 
2242 /**
2243  * @dev Contract module which provides a basic access control mechanism, where
2244  * there is an account (an owner) that can be granted exclusive access to
2245  * specific functions.
2246  *
2247  * By default, the owner account will be the one that deploys the contract. This
2248  * can later be changed with {transferOwnership}.
2249  *
2250  * This module is used through inheritance. It will make available the modifier
2251  * `onlyOwner`, which can be applied to your functions to restrict their use to
2252  * the owner.
2253  */
2254 abstract contract Ownable is Context {
2255     address private _owner;
2256 
2257     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2258 
2259     /**
2260      * @dev Initializes the contract setting the deployer as the initial owner.
2261      */
2262     constructor() {
2263         _transferOwnership(_msgSender());
2264     }
2265 
2266     /**
2267      * @dev Throws if called by any account other than the owner.
2268      */
2269     modifier onlyOwner() {
2270         _checkOwner();
2271         _;
2272     }
2273 
2274     /**
2275      * @dev Returns the address of the current owner.
2276      */
2277     function owner() public view virtual returns (address) {
2278         return _owner;
2279     }
2280 
2281     /**
2282      * @dev Throws if the sender is not the owner.
2283      */
2284     function _checkOwner() internal view virtual {
2285         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2286     }
2287 
2288     /**
2289      * @dev Leaves the contract without owner. It will not be possible to call
2290      * `onlyOwner` functions anymore. Can only be called by the current owner.
2291      *
2292      * NOTE: Renouncing ownership will leave the contract without an owner,
2293      * thereby removing any functionality that is only available to the owner.
2294      */
2295     function renounceOwnership() public virtual onlyOwner {
2296         _transferOwnership(address(0));
2297     }
2298 
2299     /**
2300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2301      * Can only be called by the current owner.
2302      */
2303     function transferOwnership(address newOwner) public virtual onlyOwner {
2304         require(newOwner != address(0), "Ownable: new owner is the zero address");
2305         _transferOwnership(newOwner);
2306     }
2307 
2308     /**
2309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2310      * Internal function without access restriction.
2311      */
2312     function _transferOwnership(address newOwner) internal virtual {
2313         address oldOwner = _owner;
2314         _owner = newOwner;
2315         emit OwnershipTransferred(oldOwner, newOwner);
2316     }
2317 }
2318 
2319 // File: contracts/coolbastards.sol
2320 
2321 
2322 
2323 
2324 
2325 //	 ██████╗ ██████╗  ██████╗ ██╗         ██████╗  █████╗ ███████╗████████╗ █████╗ ██████╗ ██████╗ ███████╗
2326 //	██╔════╝██╔═══██╗██╔═══██╗██║         ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔════╝
2327 //	██║     ██║   ██║██║   ██║██║         ██████╔╝███████║███████╗   ██║   ███████║██████╔╝██║  ██║███████╗
2328 //	██║     ██║   ██║██║   ██║██║         ██╔══██╗██╔══██║╚════██║   ██║   ██╔══██║██╔══██╗██║  ██║╚════██║
2329 //	╚██████╗╚██████╔╝╚██████╔╝███████╗    ██████╔╝██║  ██║███████║   ██║   ██║  ██║██║  ██║██████╔╝███████║
2330 //	 ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝
2331 
2332 
2333 
2334 pragma solidity ^0.8.13;
2335 
2336 
2337 
2338 
2339 
2340 
2341 
2342 
2343 contract CoolBastards is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2344 
2345             using Strings for uint256;
2346             uint256 public _maxSupply = 8900;
2347             uint256 public maxMintAmountPerWallet = 4;
2348             uint256 public maxMintAmountPerTx = 4;
2349             string baseURL = "";
2350             string ExtensionURL = ".json";
2351             uint256 _initalPrice = 0 ether;
2352             uint256 public costOfNFT = 0.002 ether;
2353             uint256 public numberOfFreeNFTs = 2;
2354             
2355             uint256 currentFreeSupply = 0;
2356             uint256 freeSupplyLimit = 4000;
2357             string HiddenURL;
2358             bool revealed = false;
2359             bool public paused = true;
2360             
2361             error ContractPaused();
2362             error MaxMintWalletExceeded();
2363             error MaxSupply();
2364             error InvalidMintAmount();
2365             error InsufficientFund();
2366             error NoSmartContract();
2367             error TokenNotExisting();
2368 
2369         constructor(string memory _initBaseURI) ERC721A("CoolBastards", "CB") {
2370             baseURL = _initBaseURI;
2371         }
2372 
2373         // ================== Mint Function =======================
2374 
2375         modifier mintCompliance(uint256 _mintAmount) {
2376             if (msg.sender != tx.origin) revert NoSmartContract();
2377             if (totalSupply()  + _mintAmount > _maxSupply) revert MaxSupply();
2378             if (_mintAmount > maxMintAmountPerTx) revert InvalidMintAmount();
2379             if(paused) revert ContractPaused();
2380             _;
2381         }
2382 
2383         modifier mintPriceCompliance(uint256 _mintAmount) {
2384             if(balanceOf(msg.sender) + _mintAmount > maxMintAmountPerWallet) revert MaxMintWalletExceeded();
2385             if (_mintAmount < 0 || _mintAmount > maxMintAmountPerWallet) revert InvalidMintAmount();
2386               if (msg.value < checkCost(_mintAmount)) revert InsufficientFund();
2387             _;
2388         }
2389         
2390 
2391         function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
2392           currentFreeSupply = currentFreeSupply + checkFreemint(_mintAmount);
2393           _safeMint(msg.sender, _mintAmount);
2394           }
2395 
2396         function checkCost(uint256 _mintAmount) public view returns (uint256) {
2397           uint256 totalMints = _mintAmount + balanceOf(msg.sender);
2398           if ((totalMints <= numberOfFreeNFTs) && (currentFreeSupply < freeSupplyLimit)) {
2399           return _initalPrice;
2400           } else if ((balanceOf(msg.sender) == 0) && (totalMints > numberOfFreeNFTs) && (currentFreeSupply < freeSupplyLimit)) { 
2401           uint256 total = costOfNFT * (_mintAmount - numberOfFreeNFTs);
2402           return total;
2403           } 
2404           else {
2405           uint256 total2 = costOfNFT * _mintAmount;
2406           return total2;
2407             }
2408         }
2409         
2410         function checkFreemint(uint256 _mintAmount) public view returns (uint256) {
2411           uint256 totalMints = _mintAmount + balanceOf(msg.sender);
2412           if ((totalMints <= numberOfFreeNFTs) && (currentFreeSupply < freeSupplyLimit)) {
2413           return totalMints;
2414           } else 
2415           if ((balanceOf(msg.sender) == 0) && (totalMints > numberOfFreeNFTs) && (currentFreeSupply < freeSupplyLimit)) { 
2416           return numberOfFreeNFTs;
2417           } 
2418           else {
2419           return 0;
2420             }
2421         }
2422 
2423         function changeFreeSupplyLimit(uint256 _newSupply)public onlyOwner {
2424           freeSupplyLimit = _newSupply;
2425         }
2426         
2427 
2428         function airdrop(address[] memory accounts, uint256 amount)public onlyOwner {
2429           for(uint256 i = 0; i < accounts.length; i++){
2430           _safeMint(accounts[i], amount);
2431           }
2432         }
2433 
2434         // =================== Orange Functions (Owner Only) ===============
2435 
2436         function pause() public onlyOwner {
2437           paused = !paused;
2438         }
2439 
2440         
2441 
2442         function setbaseURL(string memory uri) public onlyOwner{
2443           baseURL = uri;
2444         }
2445 
2446         function setExtensionURL(string memory uri) public onlyOwner{
2447           ExtensionURL = uri;
2448         }
2449 
2450         function setCostPrice(uint256 _cost) public onlyOwner{
2451           costOfNFT = _cost;
2452         } 
2453 
2454         function setSupply(uint256 supply) public onlyOwner{
2455           _maxSupply = supply;
2456         }
2457 
2458         function setMaxMintAmountPerTx(uint256 perTx) public onlyOwner{
2459           maxMintAmountPerTx = perTx;
2460         }
2461 
2462         function setMaxMintAmountPerWallet(uint256 perWallet) public onlyOwner{
2463           maxMintAmountPerWallet = perWallet;
2464         }  
2465         
2466         function setnumberOfFreeNFTs(uint256 perWallet) public onlyOwner{
2467           numberOfFreeNFTs = perWallet;
2468         }            
2469 
2470         // ================================ Withdraw Function ====================
2471 
2472         function withdraw() public onlyOwner nonReentrant{
2473           
2474 
2475           
2476 
2477         (bool owner, ) = payable(owner()).call{value: address(this).balance}('');
2478         require(owner);
2479         }
2480         // =================== Blue Functions (View Only) ====================
2481 
2482         function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
2483           if (!_exists(tokenId)) revert TokenNotExisting();   
2484 
2485         
2486 
2487         string memory currentBaseURI = _baseURI();
2488         return bytes(currentBaseURI).length > 0
2489         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ExtensionURL))
2490         : '';
2491         }
2492         
2493         function _startTokenId() internal view virtual override returns (uint256) {
2494           return 1;
2495         }
2496 
2497         function _baseURI() internal view virtual override returns (string memory) {
2498           return baseURL;
2499         }
2500 
2501         
2502         function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2503           super.transferFrom(from, to, tokenId);
2504         }
2505 
2506         function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2507           super.safeTransferFrom(from, to, tokenId);
2508         }
2509 
2510         function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
2511           super.safeTransferFrom(from, to, tokenId, data);
2512         }  
2513 
2514       }