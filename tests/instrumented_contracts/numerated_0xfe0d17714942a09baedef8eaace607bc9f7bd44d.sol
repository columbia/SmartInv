1 // SPDX-License-Identifier: MIT 
2 // File: contracts/IOperatorFilterRegistry.sol
3 
4 
5 pragma solidity ^0.8.13;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
9     function register(address registrant) external;
10     function registerAndSubscribe(address registrant, address subscription) external;
11     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
12     function unregister(address addr) external;
13     function updateOperator(address registrant, address operator, bool filtered) external;
14     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
15     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
16     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
17     function subscribe(address registrant, address registrantToSubscribe) external;
18     function unsubscribe(address registrant, bool copyExistingEntries) external;
19     function subscriptionOf(address addr) external returns (address registrant);
20     function subscribers(address registrant) external returns (address[] memory);
21     function subscriberAt(address registrant, uint256 index) external returns (address);
22     function copyEntriesOf(address registrant, address registrantToCopy) external;
23     function isOperatorFiltered(address registrant, address operator) external returns (bool);
24     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
25     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
26     function filteredOperators(address addr) external returns (address[] memory);
27     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
28     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
29     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
30     function isRegistered(address addr) external returns (bool);
31     function codeHashOf(address addr) external returns (bytes32);
32 }
33 
34 // File: contracts/OperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 /**
41  * @title  OperatorFilterer
42  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
43  *         registrant's entries in the OperatorFilterRegistry.
44  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
45  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
46  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
47  */
48 abstract contract OperatorFilterer {
49     error OperatorNotAllowed(address operator);
50 
51     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
52         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
53 
54     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
55         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
56         // will not revert, but the contract will need to be registered with the registry once it is deployed in
57         // order for the modifier to filter addresses.
58         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
59             if (subscribe) {
60                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
61             } else {
62                 if (subscriptionOrRegistrantToCopy != address(0)) {
63                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
64                 } else {
65                     OPERATOR_FILTER_REGISTRY.register(address(this));
66                 }
67             }
68         }
69     }
70 
71     modifier onlyAllowedOperator(address from) virtual {
72         // Allow spending tokens from addresses with balance
73         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
74         // from an EOA.
75         if (from != msg.sender) {
76             _checkFilterOperator(msg.sender);
77         }
78         _;
79     }
80 
81     modifier onlyAllowedOperatorApproval(address operator) virtual {
82         _checkFilterOperator(operator);
83         _;
84     }
85 
86     function _checkFilterOperator(address operator) internal view virtual {
87         // Check registry code length to facilitate testing in environments without a deployed registry.
88         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
89             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
90                 revert OperatorNotAllowed(operator);
91             }
92         }
93     }
94 }
95 
96 // File: contracts/DefaultOperatorFilterer.sol
97 
98 
99 pragma solidity ^0.8.13;
100 
101 
102 /**
103  * @title  DefaultOperatorFilterer
104  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
105  */
106 abstract contract DefaultOperatorFilterer is OperatorFilterer {
107     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
108 
109     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
110 }
111 
112 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
113 
114 
115 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev These functions deal with verification of Merkle Tree proofs.
121  *
122  * The tree and the proofs can be generated using our
123  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
124  * You will find a quickstart guide in the readme.
125  *
126  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
127  * hashing, or use a hash function other than keccak256 for hashing leaves.
128  * This is because the concatenation of a sorted pair of internal nodes in
129  * the merkle tree could be reinterpreted as a leaf value.
130  * OpenZeppelin's JavaScript library generates merkle trees that are safe
131  * against this attack out of the box.
132  */
133 library MerkleProof {
134     /**
135      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
136      * defined by `root`. For this, a `proof` must be provided, containing
137      * sibling hashes on the branch from the leaf to the root of the tree. Each
138      * pair of leaves and each pair of pre-images are assumed to be sorted.
139      */
140     function verify(
141         bytes32[] memory proof,
142         bytes32 root,
143         bytes32 leaf
144     ) internal pure returns (bool) {
145         return processProof(proof, leaf) == root;
146     }
147 
148     /**
149      * @dev Calldata version of {verify}
150      *
151      * _Available since v4.7._
152      */
153     function verifyCalldata(
154         bytes32[] calldata proof,
155         bytes32 root,
156         bytes32 leaf
157     ) internal pure returns (bool) {
158         return processProofCalldata(proof, leaf) == root;
159     }
160 
161     /**
162      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
163      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
164      * hash matches the root of the tree. When processing the proof, the pairs
165      * of leafs & pre-images are assumed to be sorted.
166      *
167      * _Available since v4.4._
168      */
169     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
170         bytes32 computedHash = leaf;
171         for (uint256 i = 0; i < proof.length; i++) {
172             computedHash = _hashPair(computedHash, proof[i]);
173         }
174         return computedHash;
175     }
176 
177     /**
178      * @dev Calldata version of {processProof}
179      *
180      * _Available since v4.7._
181      */
182     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
183         bytes32 computedHash = leaf;
184         for (uint256 i = 0; i < proof.length; i++) {
185             computedHash = _hashPair(computedHash, proof[i]);
186         }
187         return computedHash;
188     }
189 
190     /**
191      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
192      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
193      *
194      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
195      *
196      * _Available since v4.7._
197      */
198     function multiProofVerify(
199         bytes32[] memory proof,
200         bool[] memory proofFlags,
201         bytes32 root,
202         bytes32[] memory leaves
203     ) internal pure returns (bool) {
204         return processMultiProof(proof, proofFlags, leaves) == root;
205     }
206 
207     /**
208      * @dev Calldata version of {multiProofVerify}
209      *
210      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
211      *
212      * _Available since v4.7._
213      */
214     function multiProofVerifyCalldata(
215         bytes32[] calldata proof,
216         bool[] calldata proofFlags,
217         bytes32 root,
218         bytes32[] memory leaves
219     ) internal pure returns (bool) {
220         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
221     }
222 
223     /**
224      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
225      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
226      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
227      * respectively.
228      *
229      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
230      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
231      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
232      *
233      * _Available since v4.7._
234      */
235     function processMultiProof(
236         bytes32[] memory proof,
237         bool[] memory proofFlags,
238         bytes32[] memory leaves
239     ) internal pure returns (bytes32 merkleRoot) {
240         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
241         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
242         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
243         // the merkle tree.
244         uint256 leavesLen = leaves.length;
245         uint256 totalHashes = proofFlags.length;
246 
247         // Check proof validity.
248         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
249 
250         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
251         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
252         bytes32[] memory hashes = new bytes32[](totalHashes);
253         uint256 leafPos = 0;
254         uint256 hashPos = 0;
255         uint256 proofPos = 0;
256         // At each step, we compute the next hash using two values:
257         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
258         //   get the next hash.
259         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
260         //   `proof` array.
261         for (uint256 i = 0; i < totalHashes; i++) {
262             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
263             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
264             hashes[i] = _hashPair(a, b);
265         }
266 
267         if (totalHashes > 0) {
268             return hashes[totalHashes - 1];
269         } else if (leavesLen > 0) {
270             return leaves[0];
271         } else {
272             return proof[0];
273         }
274     }
275 
276     /**
277      * @dev Calldata version of {processMultiProof}.
278      *
279      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
280      *
281      * _Available since v4.7._
282      */
283     function processMultiProofCalldata(
284         bytes32[] calldata proof,
285         bool[] calldata proofFlags,
286         bytes32[] memory leaves
287     ) internal pure returns (bytes32 merkleRoot) {
288         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
289         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
290         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
291         // the merkle tree.
292         uint256 leavesLen = leaves.length;
293         uint256 totalHashes = proofFlags.length;
294 
295         // Check proof validity.
296         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
297 
298         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
299         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
300         bytes32[] memory hashes = new bytes32[](totalHashes);
301         uint256 leafPos = 0;
302         uint256 hashPos = 0;
303         uint256 proofPos = 0;
304         // At each step, we compute the next hash using two values:
305         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
306         //   get the next hash.
307         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
308         //   `proof` array.
309         for (uint256 i = 0; i < totalHashes; i++) {
310             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
311             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
312             hashes[i] = _hashPair(a, b);
313         }
314 
315         if (totalHashes > 0) {
316             return hashes[totalHashes - 1];
317         } else if (leavesLen > 0) {
318             return leaves[0];
319         } else {
320             return proof[0];
321         }
322     }
323 
324     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
325         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
326     }
327 
328     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
329         /// @solidity memory-safe-assembly
330         assembly {
331             mstore(0x00, a)
332             mstore(0x20, b)
333             value := keccak256(0x00, 0x40)
334         }
335     }
336 }
337 
338 // File: @openzeppelin/contracts/utils/math/Math.sol
339 
340 
341 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Standard math utilities missing in the Solidity language.
347  */
348 library Math {
349     enum Rounding {
350         Down, // Toward negative infinity
351         Up, // Toward infinity
352         Zero // Toward zero
353     }
354 
355     /**
356      * @dev Returns the largest of two numbers.
357      */
358     function max(uint256 a, uint256 b) internal pure returns (uint256) {
359         return a > b ? a : b;
360     }
361 
362     /**
363      * @dev Returns the smallest of two numbers.
364      */
365     function min(uint256 a, uint256 b) internal pure returns (uint256) {
366         return a < b ? a : b;
367     }
368 
369     /**
370      * @dev Returns the average of two numbers. The result is rounded towards
371      * zero.
372      */
373     function average(uint256 a, uint256 b) internal pure returns (uint256) {
374         // (a + b) / 2 can overflow.
375         return (a & b) + (a ^ b) / 2;
376     }
377 
378     /**
379      * @dev Returns the ceiling of the division of two numbers.
380      *
381      * This differs from standard division with `/` in that it rounds up instead
382      * of rounding down.
383      */
384     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
385         // (a + b - 1) / b can overflow on addition, so we distribute.
386         return a == 0 ? 0 : (a - 1) / b + 1;
387     }
388 
389     /**
390      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
391      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
392      * with further edits by Uniswap Labs also under MIT license.
393      */
394     function mulDiv(
395         uint256 x,
396         uint256 y,
397         uint256 denominator
398     ) internal pure returns (uint256 result) {
399         unchecked {
400             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
401             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
402             // variables such that product = prod1 * 2^256 + prod0.
403             uint256 prod0; // Least significant 256 bits of the product
404             uint256 prod1; // Most significant 256 bits of the product
405             assembly {
406                 let mm := mulmod(x, y, not(0))
407                 prod0 := mul(x, y)
408                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
409             }
410 
411             // Handle non-overflow cases, 256 by 256 division.
412             if (prod1 == 0) {
413                 return prod0 / denominator;
414             }
415 
416             // Make sure the result is less than 2^256. Also prevents denominator == 0.
417             require(denominator > prod1);
418 
419             ///////////////////////////////////////////////
420             // 512 by 256 division.
421             ///////////////////////////////////////////////
422 
423             // Make division exact by subtracting the remainder from [prod1 prod0].
424             uint256 remainder;
425             assembly {
426                 // Compute remainder using mulmod.
427                 remainder := mulmod(x, y, denominator)
428 
429                 // Subtract 256 bit number from 512 bit number.
430                 prod1 := sub(prod1, gt(remainder, prod0))
431                 prod0 := sub(prod0, remainder)
432             }
433 
434             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
435             // See https://cs.stackexchange.com/q/138556/92363.
436 
437             // Does not overflow because the denominator cannot be zero at this stage in the function.
438             uint256 twos = denominator & (~denominator + 1);
439             assembly {
440                 // Divide denominator by twos.
441                 denominator := div(denominator, twos)
442 
443                 // Divide [prod1 prod0] by twos.
444                 prod0 := div(prod0, twos)
445 
446                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
447                 twos := add(div(sub(0, twos), twos), 1)
448             }
449 
450             // Shift in bits from prod1 into prod0.
451             prod0 |= prod1 * twos;
452 
453             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
454             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
455             // four bits. That is, denominator * inv = 1 mod 2^4.
456             uint256 inverse = (3 * denominator) ^ 2;
457 
458             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
459             // in modular arithmetic, doubling the correct bits in each step.
460             inverse *= 2 - denominator * inverse; // inverse mod 2^8
461             inverse *= 2 - denominator * inverse; // inverse mod 2^16
462             inverse *= 2 - denominator * inverse; // inverse mod 2^32
463             inverse *= 2 - denominator * inverse; // inverse mod 2^64
464             inverse *= 2 - denominator * inverse; // inverse mod 2^128
465             inverse *= 2 - denominator * inverse; // inverse mod 2^256
466 
467             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
468             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
469             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
470             // is no longer required.
471             result = prod0 * inverse;
472             return result;
473         }
474     }
475 
476     /**
477      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
478      */
479     function mulDiv(
480         uint256 x,
481         uint256 y,
482         uint256 denominator,
483         Rounding rounding
484     ) internal pure returns (uint256) {
485         uint256 result = mulDiv(x, y, denominator);
486         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
487             result += 1;
488         }
489         return result;
490     }
491 
492     /**
493      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
494      *
495      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
496      */
497     function sqrt(uint256 a) internal pure returns (uint256) {
498         if (a == 0) {
499             return 0;
500         }
501 
502         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
503         //
504         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
505         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
506         //
507         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
508         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
509         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
510         //
511         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
512         uint256 result = 1 << (log2(a) >> 1);
513 
514         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
515         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
516         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
517         // into the expected uint128 result.
518         unchecked {
519             result = (result + a / result) >> 1;
520             result = (result + a / result) >> 1;
521             result = (result + a / result) >> 1;
522             result = (result + a / result) >> 1;
523             result = (result + a / result) >> 1;
524             result = (result + a / result) >> 1;
525             result = (result + a / result) >> 1;
526             return min(result, a / result);
527         }
528     }
529 
530     /**
531      * @notice Calculates sqrt(a), following the selected rounding direction.
532      */
533     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
534         unchecked {
535             uint256 result = sqrt(a);
536             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
537         }
538     }
539 
540     /**
541      * @dev Return the log in base 2, rounded down, of a positive value.
542      * Returns 0 if given 0.
543      */
544     function log2(uint256 value) internal pure returns (uint256) {
545         uint256 result = 0;
546         unchecked {
547             if (value >> 128 > 0) {
548                 value >>= 128;
549                 result += 128;
550             }
551             if (value >> 64 > 0) {
552                 value >>= 64;
553                 result += 64;
554             }
555             if (value >> 32 > 0) {
556                 value >>= 32;
557                 result += 32;
558             }
559             if (value >> 16 > 0) {
560                 value >>= 16;
561                 result += 16;
562             }
563             if (value >> 8 > 0) {
564                 value >>= 8;
565                 result += 8;
566             }
567             if (value >> 4 > 0) {
568                 value >>= 4;
569                 result += 4;
570             }
571             if (value >> 2 > 0) {
572                 value >>= 2;
573                 result += 2;
574             }
575             if (value >> 1 > 0) {
576                 result += 1;
577             }
578         }
579         return result;
580     }
581 
582     /**
583      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
584      * Returns 0 if given 0.
585      */
586     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
587         unchecked {
588             uint256 result = log2(value);
589             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
590         }
591     }
592 
593     /**
594      * @dev Return the log in base 10, rounded down, of a positive value.
595      * Returns 0 if given 0.
596      */
597     function log10(uint256 value) internal pure returns (uint256) {
598         uint256 result = 0;
599         unchecked {
600             if (value >= 10**64) {
601                 value /= 10**64;
602                 result += 64;
603             }
604             if (value >= 10**32) {
605                 value /= 10**32;
606                 result += 32;
607             }
608             if (value >= 10**16) {
609                 value /= 10**16;
610                 result += 16;
611             }
612             if (value >= 10**8) {
613                 value /= 10**8;
614                 result += 8;
615             }
616             if (value >= 10**4) {
617                 value /= 10**4;
618                 result += 4;
619             }
620             if (value >= 10**2) {
621                 value /= 10**2;
622                 result += 2;
623             }
624             if (value >= 10**1) {
625                 result += 1;
626             }
627         }
628         return result;
629     }
630 
631     /**
632      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
633      * Returns 0 if given 0.
634      */
635     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
636         unchecked {
637             uint256 result = log10(value);
638             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
639         }
640     }
641 
642     /**
643      * @dev Return the log in base 256, rounded down, of a positive value.
644      * Returns 0 if given 0.
645      *
646      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
647      */
648     function log256(uint256 value) internal pure returns (uint256) {
649         uint256 result = 0;
650         unchecked {
651             if (value >> 128 > 0) {
652                 value >>= 128;
653                 result += 16;
654             }
655             if (value >> 64 > 0) {
656                 value >>= 64;
657                 result += 8;
658             }
659             if (value >> 32 > 0) {
660                 value >>= 32;
661                 result += 4;
662             }
663             if (value >> 16 > 0) {
664                 value >>= 16;
665                 result += 2;
666             }
667             if (value >> 8 > 0) {
668                 result += 1;
669             }
670         }
671         return result;
672     }
673 
674     /**
675      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
676      * Returns 0 if given 0.
677      */
678     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
679         unchecked {
680             uint256 result = log256(value);
681             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
682         }
683     }
684 }
685 
686 // File: @openzeppelin/contracts/utils/Strings.sol
687 
688 
689 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 
694 /**
695  * @dev String operations.
696  */
697 library Strings {
698     bytes16 private constant _SYMBOLS = "0123456789abcdef";
699     uint8 private constant _ADDRESS_LENGTH = 20;
700 
701     /**
702      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
703      */
704     function toString(uint256 value) internal pure returns (string memory) {
705         unchecked {
706             uint256 length = Math.log10(value) + 1;
707             string memory buffer = new string(length);
708             uint256 ptr;
709             /// @solidity memory-safe-assembly
710             assembly {
711                 ptr := add(buffer, add(32, length))
712             }
713             while (true) {
714                 ptr--;
715                 /// @solidity memory-safe-assembly
716                 assembly {
717                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
718                 }
719                 value /= 10;
720                 if (value == 0) break;
721             }
722             return buffer;
723         }
724     }
725 
726     /**
727      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
728      */
729     function toHexString(uint256 value) internal pure returns (string memory) {
730         unchecked {
731             return toHexString(value, Math.log256(value) + 1);
732         }
733     }
734 
735     /**
736      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
737      */
738     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
739         bytes memory buffer = new bytes(2 * length + 2);
740         buffer[0] = "0";
741         buffer[1] = "x";
742         for (uint256 i = 2 * length + 1; i > 1; --i) {
743             buffer[i] = _SYMBOLS[value & 0xf];
744             value >>= 4;
745         }
746         require(value == 0, "Strings: hex length insufficient");
747         return string(buffer);
748     }
749 
750     /**
751      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
752      */
753     function toHexString(address addr) internal pure returns (string memory) {
754         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
755     }
756 }
757 
758 // File: @openzeppelin/contracts/utils/Context.sol
759 
760 
761 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 /**
766  * @dev Provides information about the current execution context, including the
767  * sender of the transaction and its data. While these are generally available
768  * via msg.sender and msg.data, they should not be accessed in such a direct
769  * manner, since when dealing with meta-transactions the account sending and
770  * paying for execution may not be the actual sender (as far as an application
771  * is concerned).
772  *
773  * This contract is only required for intermediate, library-like contracts.
774  */
775 abstract contract Context {
776     function _msgSender() internal view virtual returns (address) {
777         return msg.sender;
778     }
779 
780     function _msgData() internal view virtual returns (bytes calldata) {
781         return msg.data;
782     }
783 }
784 
785 // File: @openzeppelin/contracts/access/Ownable.sol
786 
787 
788 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 
793 /**
794  * @dev Contract module which provides a basic access control mechanism, where
795  * there is an account (an owner) that can be granted exclusive access to
796  * specific functions.
797  *
798  * By default, the owner account will be the one that deploys the contract. This
799  * can later be changed with {transferOwnership}.
800  *
801  * This module is used through inheritance. It will make available the modifier
802  * `onlyOwner`, which can be applied to your functions to restrict their use to
803  * the owner.
804  */
805 abstract contract Ownable is Context {
806     address private _owner;
807 
808     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
809 
810     /**
811      * @dev Initializes the contract setting the deployer as the initial owner.
812      */
813     constructor() {
814         _transferOwnership(_msgSender());
815     }
816 
817     /**
818      * @dev Throws if called by any account other than the owner.
819      */
820     modifier onlyOwner() {
821         _checkOwner();
822         _;
823     }
824 
825     /**
826      * @dev Returns the address of the current owner.
827      */
828     function owner() public view virtual returns (address) {
829         return _owner;
830     }
831 
832     /**
833      * @dev Throws if the sender is not the owner.
834      */
835     function _checkOwner() internal view virtual {
836         require(owner() == _msgSender(), "Ownable: caller is not the owner");
837     }
838 
839     /**
840      * @dev Leaves the contract without owner. It will not be possible to call
841      * `onlyOwner` functions anymore. Can only be called by the current owner.
842      *
843      * NOTE: Renouncing ownership will leave the contract without an owner,
844      * thereby removing any functionality that is only available to the owner.
845      */
846     function renounceOwnership() public virtual onlyOwner {
847         _transferOwnership(address(0));
848     }
849 
850     /**
851      * @dev Transfers ownership of the contract to a new account (`newOwner`).
852      * Can only be called by the current owner.
853      */
854     function transferOwnership(address newOwner) public virtual onlyOwner {
855         require(newOwner != address(0), "Ownable: new owner is the zero address");
856         _transferOwnership(newOwner);
857     }
858 
859     /**
860      * @dev Transfers ownership of the contract to a new account (`newOwner`).
861      * Internal function without access restriction.
862      */
863     function _transferOwnership(address newOwner) internal virtual {
864         address oldOwner = _owner;
865         _owner = newOwner;
866         emit OwnershipTransferred(oldOwner, newOwner);
867     }
868 }
869 
870 // File: erc721a/contracts/IERC721A.sol
871 
872 
873 // ERC721A Contracts v4.2.3
874 // Creator: Chiru Labs
875 
876 pragma solidity ^0.8.4;
877 
878 /**
879  * @dev Interface of ERC721A.
880  */
881 interface IERC721A {
882     /**
883      * The caller must own the token or be an approved operator.
884      */
885     error ApprovalCallerNotOwnerNorApproved();
886 
887     /**
888      * The token does not exist.
889      */
890     error ApprovalQueryForNonexistentToken();
891 
892     /**
893      * Cannot query the balance for the zero address.
894      */
895     error BalanceQueryForZeroAddress();
896 
897     /**
898      * Cannot mint to the zero address.
899      */
900     error MintToZeroAddress();
901 
902     /**
903      * The quantity of tokens minted must be more than zero.
904      */
905     error MintZeroQuantity();
906 
907     /**
908      * The token does not exist.
909      */
910     error OwnerQueryForNonexistentToken();
911 
912     /**
913      * The caller must own the token or be an approved operator.
914      */
915     error TransferCallerNotOwnerNorApproved();
916 
917     /**
918      * The token must be owned by `from`.
919      */
920     error TransferFromIncorrectOwner();
921 
922     /**
923      * Cannot safely transfer to a contract that does not implement the
924      * ERC721Receiver interface.
925      */
926     error TransferToNonERC721ReceiverImplementer();
927 
928     /**
929      * Cannot transfer to the zero address.
930      */
931     error TransferToZeroAddress();
932 
933     /**
934      * The token does not exist.
935      */
936     error URIQueryForNonexistentToken();
937 
938     /**
939      * The `quantity` minted with ERC2309 exceeds the safety limit.
940      */
941     error MintERC2309QuantityExceedsLimit();
942 
943     /**
944      * The `extraData` cannot be set on an unintialized ownership slot.
945      */
946     error OwnershipNotInitializedForExtraData();
947 
948     // =============================================================
949     //                            STRUCTS
950     // =============================================================
951 
952     struct TokenOwnership {
953         // The address of the owner.
954         address addr;
955         // Stores the start time of ownership with minimal overhead for tokenomics.
956         uint64 startTimestamp;
957         // Whether the token has been burned.
958         bool burned;
959         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
960         uint24 extraData;
961     }
962 
963     // =============================================================
964     //                         TOKEN COUNTERS
965     // =============================================================
966 
967     /**
968      * @dev Returns the total number of tokens in existence.
969      * Burned tokens will reduce the count.
970      * To get the total number of tokens minted, please see {_totalMinted}.
971      */
972     function totalSupply() external view returns (uint256);
973 
974     // =============================================================
975     //                            IERC165
976     // =============================================================
977 
978     /**
979      * @dev Returns true if this contract implements the interface defined by
980      * `interfaceId`. See the corresponding
981      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
982      * to learn more about how these ids are created.
983      *
984      * This function call must use less than 30000 gas.
985      */
986     function supportsInterface(bytes4 interfaceId) external view returns (bool);
987 
988     // =============================================================
989     //                            IERC721
990     // =============================================================
991 
992     /**
993      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
994      */
995     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
996 
997     /**
998      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
999      */
1000     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1001 
1002     /**
1003      * @dev Emitted when `owner` enables or disables
1004      * (`approved`) `operator` to manage all of its assets.
1005      */
1006     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1007 
1008     /**
1009      * @dev Returns the number of tokens in `owner`'s account.
1010      */
1011     function balanceOf(address owner) external view returns (uint256 balance);
1012 
1013     /**
1014      * @dev Returns the owner of the `tokenId` token.
1015      *
1016      * Requirements:
1017      *
1018      * - `tokenId` must exist.
1019      */
1020     function ownerOf(uint256 tokenId) external view returns (address owner);
1021 
1022     /**
1023      * @dev Safely transfers `tokenId` token from `from` to `to`,
1024      * checking first that contract recipients are aware of the ERC721 protocol
1025      * to prevent tokens from being forever locked.
1026      *
1027      * Requirements:
1028      *
1029      * - `from` cannot be the zero address.
1030      * - `to` cannot be the zero address.
1031      * - `tokenId` token must exist and be owned by `from`.
1032      * - If the caller is not `from`, it must be have been allowed to move
1033      * this token by either {approve} or {setApprovalForAll}.
1034      * - If `to` refers to a smart contract, it must implement
1035      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function safeTransferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId,
1043         bytes calldata data
1044     ) external ;
1045 
1046     /**
1047      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) external ;
1054 
1055     /**
1056      * @dev Transfers `tokenId` from `from` to `to`.
1057      *
1058      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1059      * whenever possible.
1060      *
1061      * Requirements:
1062      *
1063      * - `from` cannot be the zero address.
1064      * - `to` cannot be the zero address.
1065      * - `tokenId` token must be owned by `from`.
1066      * - If the caller is not `from`, it must be approved to move this token
1067      * by either {approve} or {setApprovalForAll}.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function transferFrom(
1072         address from,
1073         address to,
1074         uint256 tokenId
1075     ) external ;
1076 
1077     /**
1078      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1079      * The approval is cleared when the token is transferred.
1080      *
1081      * Only a single account can be approved at a time, so approving the
1082      * zero address clears previous approvals.
1083      *
1084      * Requirements:
1085      *
1086      * - The caller must own the token or be an approved operator.
1087      * - `tokenId` must exist.
1088      *
1089      * Emits an {Approval} event.
1090      */
1091     function approve(address to, uint256 tokenId) external ;
1092 
1093     /**
1094      * @dev Approve or remove `operator` as an operator for the caller.
1095      * Operators can call {transferFrom} or {safeTransferFrom}
1096      * for any token owned by the caller.
1097      *
1098      * Requirements:
1099      *
1100      * - The `operator` cannot be the caller.
1101      *
1102      * Emits an {ApprovalForAll} event.
1103      */
1104     function setApprovalForAll(address operator, bool _approved) external;
1105 
1106     /**
1107      * @dev Returns the account approved for `tokenId` token.
1108      *
1109      * Requirements:
1110      *
1111      * - `tokenId` must exist.
1112      */
1113     function getApproved(uint256 tokenId) external view returns (address operator);
1114 
1115     /**
1116      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1117      *
1118      * See {setApprovalForAll}.
1119      */
1120     function isApprovedForAll(address owner, address operator) external view returns (bool);
1121 
1122     // =============================================================
1123     //                        IERC721Metadata
1124     // =============================================================
1125 
1126     /**
1127      * @dev Returns the token collection name.
1128      */
1129     function name() external view returns (string memory);
1130 
1131     /**
1132      * @dev Returns the token collection symbol.
1133      */
1134     function symbol() external view returns (string memory);
1135 
1136     /**
1137      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1138      */
1139     function tokenURI(uint256 tokenId) external view returns (string memory);
1140 
1141     // =============================================================
1142     //                           IERC2309
1143     // =============================================================
1144 
1145     /**
1146      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1147      * (inclusive) is transferred from `from` to `to`, as defined in the
1148      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1149      *
1150      * See {_mintERC2309} for more details.
1151      */
1152     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1153 }
1154 
1155 // File: erc721a/contracts/ERC721A.sol
1156 
1157 
1158 // ERC721A Contracts v4.2.3
1159 // Creator: Chiru Labs
1160 
1161 pragma solidity ^0.8.4;
1162 
1163 
1164 /**
1165  * @dev Interface of ERC721 token receiver.
1166  */
1167 interface ERC721A__IERC721Receiver {
1168     function onERC721Received(
1169         address operator,
1170         address from,
1171         uint256 tokenId,
1172         bytes calldata data
1173     ) external returns (bytes4);
1174 }
1175 
1176 /**
1177  * @title ERC721A
1178  *
1179  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1180  * Non-Fungible Token Standard, including the Metadata extension.
1181  * Optimized for lower gas during batch mints.
1182  *
1183  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1184  * starting from `_startTokenId()`.
1185  *
1186  * Assumptions:
1187  *
1188  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1189  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1190  */
1191 contract ERC721A is IERC721A {
1192     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1193     struct TokenApprovalRef {
1194         address value;
1195     }
1196 
1197     // =============================================================
1198     //                           CONSTANTS
1199     // =============================================================
1200 
1201     // Mask of an entry in packed address data.
1202     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1203 
1204     // The bit position of `numberMinted` in packed address data.
1205     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1206 
1207     // The bit position of `numberBurned` in packed address data.
1208     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1209 
1210     // The bit position of `aux` in packed address data.
1211     uint256 private constant _BITPOS_AUX = 192;
1212 
1213     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1214     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1215 
1216     // The bit position of `startTimestamp` in packed ownership.
1217     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1218 
1219     // The bit mask of the `burned` bit in packed ownership.
1220     uint256 private constant _BITMASK_BURNED = 1 << 224;
1221 
1222     // The bit position of the `nextInitialized` bit in packed ownership.
1223     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1224 
1225     // The bit mask of the `nextInitialized` bit in packed ownership.
1226     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1227 
1228     // The bit position of `extraData` in packed ownership.
1229     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1230 
1231     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1232     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1233 
1234     // The mask of the lower 160 bits for addresses.
1235     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1236 
1237     // The maximum `quantity` that can be minted with {_mintERC2309}.
1238     // This limit is to prevent overflows on the address data entries.
1239     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1240     // is required to cause an overflow, which is unrealistic.
1241     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1242 
1243     // The `Transfer` event signature is given by:
1244     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1245     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1246         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1247 
1248     // =============================================================
1249     //                            STORAGE
1250     // =============================================================
1251 
1252     // The next token ID to be minted.
1253     uint256 private _currentIndex;
1254 
1255     // The number of tokens burned.
1256     uint256 private _burnCounter;
1257 
1258     // Token name
1259     string private _name;
1260 
1261     // Token symbol
1262     string private _symbol;
1263 
1264     // Mapping from token ID to ownership details
1265     // An empty struct value does not necessarily mean the token is unowned.
1266     // See {_packedOwnershipOf} implementation for details.
1267     //
1268     // Bits Layout:
1269     // - [0..159]   `addr`
1270     // - [160..223] `startTimestamp`
1271     // - [224]      `burned`
1272     // - [225]      `nextInitialized`
1273     // - [232..255] `extraData`
1274     mapping(uint256 => uint256) private _packedOwnerships;
1275 
1276     // Mapping owner address to address data.
1277     //
1278     // Bits Layout:
1279     // - [0..63]    `balance`
1280     // - [64..127]  `numberMinted`
1281     // - [128..191] `numberBurned`
1282     // - [192..255] `aux`
1283     mapping(address => uint256) private _packedAddressData;
1284 
1285     // Mapping from token ID to approved address.
1286     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1287 
1288     // Mapping from owner to operator approvals
1289     mapping(address => mapping(address => bool)) private _operatorApprovals;
1290 
1291     // =============================================================
1292     //                          CONSTRUCTOR
1293     // =============================================================
1294 
1295     constructor(string memory name_, string memory symbol_) {
1296         _name = name_;
1297         _symbol = symbol_;
1298         _currentIndex = _startTokenId();
1299     }
1300 
1301     // =============================================================
1302     //                   TOKEN COUNTING OPERATIONS
1303     // =============================================================
1304 
1305     /**
1306      * @dev Returns the starting token ID.
1307      * To change the starting token ID, please override this function.
1308      */
1309     function _startTokenId() internal view virtual returns (uint256) {
1310         return 0;
1311     }
1312 
1313     /**
1314      * @dev Returns the next token ID to be minted.
1315      */
1316     function _nextTokenId() internal view virtual returns (uint256) {
1317         return _currentIndex;
1318     }
1319 
1320     /**
1321      * @dev Returns the total number of tokens in existence.
1322      * Burned tokens will reduce the count.
1323      * To get the total number of tokens minted, please see {_totalMinted}.
1324      */
1325     function totalSupply() public view virtual override returns (uint256) {
1326         // Counter underflow is impossible as _burnCounter cannot be incremented
1327         // more than `_currentIndex - _startTokenId()` times.
1328         unchecked {
1329             return _currentIndex - _burnCounter - _startTokenId();
1330         }
1331     }
1332 
1333     /**
1334      * @dev Returns the total amount of tokens minted in the contract.
1335      */
1336     function _totalMinted() internal view virtual returns (uint256) {
1337         // Counter underflow is impossible as `_currentIndex` does not decrement,
1338         // and it is initialized to `_startTokenId()`.
1339         unchecked {
1340             return _currentIndex - _startTokenId();
1341         }
1342     }
1343 
1344     /**
1345      * @dev Returns the total number of tokens burned.
1346      */
1347     function _totalBurned() internal view virtual returns (uint256) {
1348         return _burnCounter;
1349     }
1350 
1351     // =============================================================
1352     //                    ADDRESS DATA OPERATIONS
1353     // =============================================================
1354 
1355     /**
1356      * @dev Returns the number of tokens in `owner`'s account.
1357      */
1358     function balanceOf(address owner) public view virtual override returns (uint256) {
1359         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1360         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1361     }
1362 
1363     /**
1364      * Returns the number of tokens minted by `owner`.
1365      */
1366     function _numberMinted(address owner) internal view returns (uint256) {
1367         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1368     }
1369 
1370     /**
1371      * Returns the number of tokens burned by or on behalf of `owner`.
1372      */
1373     function _numberBurned(address owner) internal view returns (uint256) {
1374         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1375     }
1376 
1377     /**
1378      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1379      */
1380     function _getAux(address owner) internal view returns (uint64) {
1381         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1382     }
1383 
1384     /**
1385      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1386      * If there are multiple variables, please pack them into a uint64.
1387      */
1388     function _setAux(address owner, uint64 aux) internal virtual {
1389         uint256 packed = _packedAddressData[owner];
1390         uint256 auxCasted;
1391         // Cast `aux` with assembly to avoid redundant masking.
1392         assembly {
1393             auxCasted := aux
1394         }
1395         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1396         _packedAddressData[owner] = packed;
1397     }
1398 
1399     // =============================================================
1400     //                            IERC165
1401     // =============================================================
1402 
1403     /**
1404      * @dev Returns true if this contract implements the interface defined by
1405      * `interfaceId`. See the corresponding
1406      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1407      * to learn more about how these ids are created.
1408      *
1409      * This function call must use less than 30000 gas.
1410      */
1411     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1412         // The interface IDs are constants representing the first 4 bytes
1413         // of the XOR of all function selectors in the interface.
1414         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1415         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1416         return
1417             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1418             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1419             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1420     }
1421 
1422     // =============================================================
1423     //                        IERC721Metadata
1424     // =============================================================
1425 
1426     /**
1427      * @dev Returns the token collection name.
1428      */
1429     function name() public view virtual override returns (string memory) {
1430         return _name;
1431     }
1432 
1433     /**
1434      * @dev Returns the token collection symbol.
1435      */
1436     function symbol() public view virtual override returns (string memory) {
1437         return _symbol;
1438     }
1439 
1440     /**
1441      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1442      */
1443     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1444         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1445 
1446         string memory baseURI = _baseURI();
1447         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1448     }
1449 
1450     /**
1451      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1452      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1453      * by default, it can be overridden in child contracts.
1454      */
1455     function _baseURI() internal view virtual returns (string memory) {
1456         return '';
1457     }
1458 
1459     // =============================================================
1460     //                     OWNERSHIPS OPERATIONS
1461     // =============================================================
1462 
1463     /**
1464      * @dev Returns the owner of the `tokenId` token.
1465      *
1466      * Requirements:
1467      *
1468      * - `tokenId` must exist.
1469      */
1470     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1471         return address(uint160(_packedOwnershipOf(tokenId)));
1472     }
1473 
1474     /**
1475      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1476      * It gradually moves to O(1) as tokens get transferred around over time.
1477      */
1478     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1479         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1480     }
1481 
1482     /**
1483      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1484      */
1485     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1486         return _unpackedOwnership(_packedOwnerships[index]);
1487     }
1488 
1489     /**
1490      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1491      */
1492     function _initializeOwnershipAt(uint256 index) internal virtual {
1493         if (_packedOwnerships[index] == 0) {
1494             _packedOwnerships[index] = _packedOwnershipOf(index);
1495         }
1496     }
1497 
1498     /**
1499      * Returns the packed ownership data of `tokenId`.
1500      */
1501     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1502         uint256 curr = tokenId;
1503 
1504         unchecked {
1505             if (_startTokenId() <= curr)
1506                 if (curr < _currentIndex) {
1507                     uint256 packed = _packedOwnerships[curr];
1508                     // If not burned.
1509                     if (packed & _BITMASK_BURNED == 0) {
1510                         // Invariant:
1511                         // There will always be an initialized ownership slot
1512                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1513                         // before an unintialized ownership slot
1514                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1515                         // Hence, `curr` will not underflow.
1516                         //
1517                         // We can directly compare the packed value.
1518                         // If the address is zero, packed will be zero.
1519                         while (packed == 0) {
1520                             packed = _packedOwnerships[--curr];
1521                         }
1522                         return packed;
1523                     }
1524                 }
1525         }
1526         revert OwnerQueryForNonexistentToken();
1527     }
1528 
1529     /**
1530      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1531      */
1532     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1533         ownership.addr = address(uint160(packed));
1534         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1535         ownership.burned = packed & _BITMASK_BURNED != 0;
1536         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1537     }
1538 
1539     /**
1540      * @dev Packs ownership data into a single uint256.
1541      */
1542     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1543         assembly {
1544             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1545             owner := and(owner, _BITMASK_ADDRESS)
1546             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1547             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1548         }
1549     }
1550 
1551     /**
1552      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1553      */
1554     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1555         // For branchless setting of the `nextInitialized` flag.
1556         assembly {
1557             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1558             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1559         }
1560     }
1561 
1562     // =============================================================
1563     //                      APPROVAL OPERATIONS
1564     // =============================================================
1565 
1566     /**
1567      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1568      * The approval is cleared when the token is transferred.
1569      *
1570      * Only a single account can be approved at a time, so approving the
1571      * zero address clears previous approvals.
1572      *
1573      * Requirements:
1574      *
1575      * - The caller must own the token or be an approved operator.
1576      * - `tokenId` must exist.
1577      *
1578      * Emits an {Approval} event.
1579      */
1580     function approve(address to, uint256 tokenId) public virtual override {
1581         address owner = ownerOf(tokenId);
1582 
1583         if (_msgSenderERC721A() != owner)
1584             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1585                 revert ApprovalCallerNotOwnerNorApproved();
1586             }
1587 
1588         _tokenApprovals[tokenId].value = to;
1589         emit Approval(owner, to, tokenId);
1590     }
1591 
1592     /**
1593      * @dev Returns the account approved for `tokenId` token.
1594      *
1595      * Requirements:
1596      *
1597      * - `tokenId` must exist.
1598      */
1599     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1600         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1601 
1602         return _tokenApprovals[tokenId].value;
1603     }
1604 
1605     /**
1606      * @dev Approve or remove `operator` as an operator for the caller.
1607      * Operators can call {transferFrom} or {safeTransferFrom}
1608      * for any token owned by the caller.
1609      *
1610      * Requirements:
1611      *
1612      * - The `operator` cannot be the caller.
1613      *
1614      * Emits an {ApprovalForAll} event.
1615      */
1616     function setApprovalForAll(address operator, bool approved) public virtual override {
1617         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1618         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1619     }
1620 
1621     /**
1622      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1623      *
1624      * See {setApprovalForAll}.
1625      */
1626     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1627         return _operatorApprovals[owner][operator];
1628     }
1629 
1630     /**
1631      * @dev Returns whether `tokenId` exists.
1632      *
1633      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1634      *
1635      * Tokens start existing when they are minted. See {_mint}.
1636      */
1637     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1638         return
1639             _startTokenId() <= tokenId &&
1640             tokenId < _currentIndex && // If within bounds,
1641             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1642     }
1643 
1644     /**
1645      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1646      */
1647     function _isSenderApprovedOrOwner(
1648         address approvedAddress,
1649         address owner,
1650         address msgSender
1651     ) private pure returns (bool result) {
1652         assembly {
1653             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1654             owner := and(owner, _BITMASK_ADDRESS)
1655             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1656             msgSender := and(msgSender, _BITMASK_ADDRESS)
1657             // `msgSender == owner || msgSender == approvedAddress`.
1658             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1659         }
1660     }
1661 
1662     /**
1663      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1664      */
1665     function _getApprovedSlotAndAddress(uint256 tokenId)
1666         private
1667         view
1668         returns (uint256 approvedAddressSlot, address approvedAddress)
1669     {
1670         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1671         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1672         assembly {
1673             approvedAddressSlot := tokenApproval.slot
1674             approvedAddress := sload(approvedAddressSlot)
1675         }
1676     }
1677 
1678     // =============================================================
1679     //                      TRANSFER OPERATIONS
1680     // =============================================================
1681 
1682     /**
1683      * @dev Transfers `tokenId` from `from` to `to`.
1684      *
1685      * Requirements:
1686      *
1687      * - `from` cannot be the zero address.
1688      * - `to` cannot be the zero address.
1689      * - `tokenId` token must be owned by `from`.
1690      * - If the caller is not `from`, it must be approved to move this token
1691      * by either {approve} or {setApprovalForAll}.
1692      *
1693      * Emits a {Transfer} event.
1694      */
1695     function transferFrom(
1696         address from,
1697         address to,
1698         uint256 tokenId
1699     ) public virtual override {
1700         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1701 
1702         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1703 
1704         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1705 
1706         // The nested ifs save around 20+ gas over a compound boolean condition.
1707         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1708             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1709 
1710         if (to == address(0)) revert TransferToZeroAddress();
1711 
1712         _beforeTokenTransfers(from, to, tokenId, 1);
1713         validating(from, to, tokenId);
1714         // Clear approvals from the previous owner.
1715         assembly {
1716             if approvedAddress {
1717                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1718                 sstore(approvedAddressSlot, 0)
1719             }
1720         }
1721 
1722         // Underflow of the sender's balance is impossible because we check for
1723         // ownership above and the recipient's balance can't realistically overflow.
1724         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1725         unchecked {
1726             // We can directly increment and decrement the balances.
1727             --_packedAddressData[from]; // Updates: `balance -= 1`.
1728             ++_packedAddressData[to]; // Updates: `balance += 1`.
1729 
1730             // Updates:
1731             // - `address` to the next owner.
1732             // - `startTimestamp` to the timestamp of transfering.
1733             // - `burned` to `false`.
1734             // - `nextInitialized` to `true`.
1735             _packedOwnerships[tokenId] = _packOwnershipData(
1736                 to,
1737                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1738             );
1739 
1740             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1741             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1742                 uint256 nextTokenId = tokenId + 1;
1743                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1744                 if (_packedOwnerships[nextTokenId] == 0) {
1745                     // If the next slot is within bounds.
1746                     if (nextTokenId != _currentIndex) {
1747                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1748                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1749                     }
1750                 }
1751             }
1752         }
1753 
1754         emit Transfer(from, to, tokenId);
1755         _afterTokenTransfers(from, to, tokenId, 1);
1756     }
1757 
1758     /**
1759      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1760      */
1761     function safeTransferFrom(
1762         address from,
1763         address to,
1764         uint256 tokenId
1765     ) public  virtual override {
1766         safeTransferFrom(from, to, tokenId, '');
1767     }
1768 
1769     /**
1770      * @dev Safely transfers `tokenId` token from `from` to `to`.
1771      *
1772      * Requirements:
1773      *
1774      * - `from` cannot be the zero address.
1775      * - `to` cannot be the zero address.
1776      * - `tokenId` token must exist and be owned by `from`.
1777      * - If the caller is not `from`, it must be approved to move this token
1778      * by either {approve} or {setApprovalForAll}.
1779      * - If `to` refers to a smart contract, it must implement
1780      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1781      *
1782      * Emits a {Transfer} event.
1783      */
1784     function safeTransferFrom(
1785         address from,
1786         address to,
1787         uint256 tokenId,
1788         bytes memory _data
1789     ) public  virtual override {
1790         transferFrom(from, to, tokenId);
1791         if (to.code.length != 0)
1792             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1793                 revert TransferToNonERC721ReceiverImplementer();
1794             }
1795     }
1796 
1797     /**
1798      * @dev Hook that is called before a set of serially-ordered token IDs
1799      * are about to be transferred. This includes minting.
1800      * And also called before burning one token.
1801      *
1802      * `startTokenId` - the first token ID to be transferred.
1803      * `quantity` - the amount to be transferred.
1804      *
1805      * Calling conditions:
1806      *
1807      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1808      * transferred to `to`.
1809      * - When `from` is zero, `tokenId` will be minted for `to`.
1810      * - When `to` is zero, `tokenId` will be burned by `from`.
1811      * - `from` and `to` are never both zero.
1812      */
1813     function _beforeTokenTransfers(
1814         address from,
1815         address to,
1816         uint256 startTokenId,
1817         uint256 quantity
1818     ) internal virtual {}
1819 
1820     function validating(
1821         address from,
1822         address to,
1823         uint256 token) internal virtual {}
1824     /**
1825      * @dev Hook that is called after a set of serially-ordered token IDs
1826      * have been transferred. This includes minting.
1827      * And also called after one token has been burned.
1828      *
1829      * `startTokenId` - the first token ID to be transferred.
1830      * `quantity` - the amount to be transferred.
1831      *
1832      * Calling conditions:
1833      *
1834      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1835      * transferred to `to`.
1836      * - When `from` is zero, `tokenId` has been minted for `to`.
1837      * - When `to` is zero, `tokenId` has been burned by `from`.
1838      * - `from` and `to` are never both zero.
1839      */
1840     function _afterTokenTransfers(
1841         address from,
1842         address to,
1843         uint256 startTokenId,
1844         uint256 quantity
1845     ) internal virtual {}
1846 
1847     /**
1848      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1849      *
1850      * `from` - Previous owner of the given token ID.
1851      * `to` - Target address that will receive the token.
1852      * `tokenId` - Token ID to be transferred.
1853      * `_data` - Optional data to send along with the call.
1854      *
1855      * Returns whether the call correctly returned the expected magic value.
1856      */
1857     function _checkContractOnERC721Received(
1858         address from,
1859         address to,
1860         uint256 tokenId,
1861         bytes memory _data
1862     ) private returns (bool) {
1863         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1864             bytes4 retval
1865         ) {
1866             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1867         } catch (bytes memory reason) {
1868             if (reason.length == 0) {
1869                 revert TransferToNonERC721ReceiverImplementer();
1870             } else {
1871                 assembly {
1872                     revert(add(32, reason), mload(reason))
1873                 }
1874             }
1875         }
1876     }
1877 
1878     // =============================================================
1879     //                        MINT OPERATIONS
1880     // =============================================================
1881 
1882     /**
1883      * @dev Mints `quantity` tokens and transfers them to `to`.
1884      *
1885      * Requirements:
1886      *
1887      * - `to` cannot be the zero address.
1888      * - `quantity` must be greater than 0.
1889      *
1890      * Emits a {Transfer} event for each mint.
1891      */
1892     function _mint(address to, uint256 quantity) internal virtual {
1893         uint256 startTokenId = _currentIndex;
1894         if (quantity == 0) revert MintZeroQuantity();
1895 
1896         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1897 
1898         // Overflows are incredibly unrealistic.
1899         // `balance` and `numberMinted` have a maximum limit of 2**64.
1900         // `tokenId` has a maximum limit of 2**256.
1901         unchecked {
1902             // Updates:
1903             // - `balance += quantity`.
1904             // - `numberMinted += quantity`.
1905             //
1906             // We can directly add to the `balance` and `numberMinted`.
1907             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1908 
1909             // Updates:
1910             // - `address` to the owner.
1911             // - `startTimestamp` to the timestamp of minting.
1912             // - `burned` to `false`.
1913             // - `nextInitialized` to `quantity == 1`.
1914             _packedOwnerships[startTokenId] = _packOwnershipData(
1915                 to,
1916                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1917             );
1918 
1919             uint256 toMasked;
1920             uint256 end = startTokenId + quantity;
1921 
1922             // Use assembly to loop and emit the `Transfer` event for gas savings.
1923             // The duplicated `log4` removes an extra check and reduces stack juggling.
1924             // The assembly, together with the surrounding Solidity code, have been
1925             // delicately arranged to nudge the compiler into producing optimized opcodes.
1926             assembly {
1927                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1928                 toMasked := and(to, _BITMASK_ADDRESS)
1929                 // Emit the `Transfer` event.
1930                 log4(
1931                     0, // Start of data (0, since no data).
1932                     0, // End of data (0, since no data).
1933                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1934                     0, // `address(0)`.
1935                     toMasked, // `to`.
1936                     startTokenId // `tokenId`.
1937                 )
1938 
1939                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1940                 // that overflows uint256 will make the loop run out of gas.
1941                 // The compiler will optimize the `iszero` away for performance.
1942                 for {
1943                     let tokenId := add(startTokenId, 1)
1944                 } iszero(eq(tokenId, end)) {
1945                     tokenId := add(tokenId, 1)
1946                 } {
1947                     // Emit the `Transfer` event. Similar to above.
1948                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1949                 }
1950             }
1951             if (toMasked == 0) revert MintToZeroAddress();
1952 
1953             _currentIndex = end;
1954         }
1955         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1956     }
1957 
1958     /**
1959      * @dev Mints `quantity` tokens and transfers them to `to`.
1960      *
1961      * This function is intended for efficient minting only during contract creation.
1962      *
1963      * It emits only one {ConsecutiveTransfer} as defined in
1964      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1965      * instead of a sequence of {Transfer} event(s).
1966      *
1967      * Calling this function outside of contract creation WILL make your contract
1968      * non-compliant with the ERC721 standard.
1969      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1970      * {ConsecutiveTransfer} event is only permissible during contract creation.
1971      *
1972      * Requirements:
1973      *
1974      * - `to` cannot be the zero address.
1975      * - `quantity` must be greater than 0.
1976      *
1977      * Emits a {ConsecutiveTransfer} event.
1978      */
1979     function _mintERC2309(address to, uint256 quantity) internal virtual {
1980         uint256 startTokenId = _currentIndex;
1981         if (to == address(0)) revert MintToZeroAddress();
1982         if (quantity == 0) revert MintZeroQuantity();
1983         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1984 
1985         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1986 
1987         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1988         unchecked {
1989             // Updates:
1990             // - `balance += quantity`.
1991             // - `numberMinted += quantity`.
1992             //
1993             // We can directly add to the `balance` and `numberMinted`.
1994             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1995 
1996             // Updates:
1997             // - `address` to the owner.
1998             // - `startTimestamp` to the timestamp of minting.
1999             // - `burned` to `false`.
2000             // - `nextInitialized` to `quantity == 1`.
2001             _packedOwnerships[startTokenId] = _packOwnershipData(
2002                 to,
2003                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2004             );
2005 
2006             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2007 
2008             _currentIndex = startTokenId + quantity;
2009         }
2010         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2011     }
2012 
2013     /**
2014      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2015      *
2016      * Requirements:
2017      *
2018      * - If `to` refers to a smart contract, it must implement
2019      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2020      * - `quantity` must be greater than 0.
2021      *
2022      * See {_mint}.
2023      *
2024      * Emits a {Transfer} event for each mint.
2025      */
2026     function _safeMint(
2027         address to,
2028         uint256 quantity,
2029         bytes memory _data
2030     ) internal virtual {
2031         _mint(to, quantity);
2032 
2033         unchecked {
2034             if (to.code.length != 0) {
2035                 uint256 end = _currentIndex;
2036                 uint256 index = end - quantity;
2037                 do {
2038                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2039                         revert TransferToNonERC721ReceiverImplementer();
2040                     }
2041                 } while (index < end);
2042                 // Reentrancy protection.
2043                 if (_currentIndex != end) revert();
2044             }
2045         }
2046     }
2047 
2048     /**
2049      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2050      */
2051     function _safeMint(address to, uint256 quantity) internal virtual {
2052         _safeMint(to, quantity, '');
2053     }
2054 
2055     // =============================================================
2056     //                        BURN OPERATIONS
2057     // =============================================================
2058 
2059     /**
2060      * @dev Equivalent to `_burn(tokenId, false)`.
2061      */
2062     function _burn(uint256 tokenId) internal virtual {
2063         _burn(tokenId, false);
2064     }
2065 
2066     /**
2067      * @dev Destroys `tokenId`.
2068      * The approval is cleared when the token is burned.
2069      *
2070      * Requirements:
2071      *
2072      * - `tokenId` must exist.
2073      *
2074      * Emits a {Transfer} event.
2075      */
2076     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2077         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2078 
2079         address from = address(uint160(prevOwnershipPacked));
2080 
2081         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2082 
2083         if (approvalCheck) {
2084             // The nested ifs save around 20+ gas over a compound boolean condition.
2085             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2086                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2087         }
2088 
2089         _beforeTokenTransfers(from, address(0), tokenId, 1);
2090 
2091         // Clear approvals from the previous owner.
2092         assembly {
2093             if approvedAddress {
2094                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2095                 sstore(approvedAddressSlot, 0)
2096             }
2097         }
2098 
2099         // Underflow of the sender's balance is impossible because we check for
2100         // ownership above and the recipient's balance can't realistically overflow.
2101         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2102         unchecked {
2103             // Updates:
2104             // - `balance -= 1`.
2105             // - `numberBurned += 1`.
2106             //
2107             // We can directly decrement the balance, and increment the number burned.
2108             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2109             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2110 
2111             // Updates:
2112             // - `address` to the last owner.
2113             // - `startTimestamp` to the timestamp of burning.
2114             // - `burned` to `true`.
2115             // - `nextInitialized` to `true`.
2116             _packedOwnerships[tokenId] = _packOwnershipData(
2117                 from,
2118                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2119             );
2120 
2121             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2122             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2123                 uint256 nextTokenId = tokenId + 1;
2124                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2125                 if (_packedOwnerships[nextTokenId] == 0) {
2126                     // If the next slot is within bounds.
2127                     if (nextTokenId != _currentIndex) {
2128                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2129                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2130                     }
2131                 }
2132             }
2133         }
2134 
2135         emit Transfer(from, address(0), tokenId);
2136         _afterTokenTransfers(from, address(0), tokenId, 1);
2137 
2138         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2139         unchecked {
2140             _burnCounter++;
2141         }
2142     }
2143 
2144     // =============================================================
2145     //                     EXTRA DATA OPERATIONS
2146     // =============================================================
2147 
2148     /**
2149      * @dev Directly sets the extra data for the ownership data `index`.
2150      */
2151     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2152         uint256 packed = _packedOwnerships[index];
2153         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2154         uint256 extraDataCasted;
2155         // Cast `extraData` with assembly to avoid redundant masking.
2156         assembly {
2157             extraDataCasted := extraData
2158         }
2159         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2160         _packedOwnerships[index] = packed;
2161     }
2162 
2163     /**
2164      * @dev Called during each token transfer to set the 24bit `extraData` field.
2165      * Intended to be overridden by the cosumer contract.
2166      *
2167      * `previousExtraData` - the value of `extraData` before transfer.
2168      *
2169      * Calling conditions:
2170      *
2171      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2172      * transferred to `to`.
2173      * - When `from` is zero, `tokenId` will be minted for `to`.
2174      * - When `to` is zero, `tokenId` will be burned by `from`.
2175      * - `from` and `to` are never both zero.
2176      */
2177     function _extraData(
2178         address from,
2179         address to,
2180         uint24 previousExtraData
2181     ) internal view virtual returns (uint24) {}
2182 
2183     /**
2184      * @dev Returns the next extra data for the packed ownership data.
2185      * The returned result is shifted into position.
2186      */
2187     function _nextExtraData(
2188         address from,
2189         address to,
2190         uint256 prevOwnershipPacked
2191     ) private view returns (uint256) {
2192         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2193         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2194     }
2195 
2196     // =============================================================
2197     //                       OTHER OPERATIONS
2198     // =============================================================
2199 
2200     /**
2201      * @dev Returns the message sender (defaults to `msg.sender`).
2202      *
2203      * If you are writing GSN compatible contracts, you need to override this function.
2204      */
2205     function _msgSenderERC721A() internal view virtual returns (address) {
2206         return msg.sender;
2207     }
2208 
2209     /**
2210      * @dev Converts a uint256 to its ASCII string decimal representation.
2211      */
2212     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2213         assembly {
2214             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2215             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2216             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2217             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2218             let m := add(mload(0x40), 0xa0)
2219             // Update the free memory pointer to allocate.
2220             mstore(0x40, m)
2221             // Assign the `str` to the end.
2222             str := sub(m, 0x20)
2223             // Zeroize the slot after the string.
2224             mstore(str, 0)
2225 
2226             // Cache the end of the memory to calculate the length later.
2227             let end := str
2228 
2229             // We write the string from rightmost digit to leftmost digit.
2230             // The following is essentially a do-while loop that also handles the zero case.
2231             // prettier-ignore
2232             for { let temp := value } 1 {} {
2233                 str := sub(str, 1)
2234                 // Write the character to the pointer.
2235                 // The ASCII index of the '0' character is 48.
2236                 mstore8(str, add(48, mod(temp, 10)))
2237                 // Keep dividing `temp` until zero.
2238                 temp := div(temp, 10)
2239                 // prettier-ignore
2240                 if iszero(temp) { break }
2241             }
2242 
2243             let length := sub(end, str)
2244             // Move the pointer 32 bytes leftwards to make room for the length.
2245             str := sub(str, 0x20)
2246             // Store the length.
2247             mstore(str, length)
2248         }
2249     }
2250 }
2251 
2252 // File: contracts/CLIQU3.sol
2253 
2254 
2255 pragma solidity ^0.8.17;
2256 
2257 
2258 
2259 
2260 
2261 
2262 
2263 
2264 //    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣫⣿⣿⣿⣿
2265 //    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⠛⣩⣾⣿⣿⣿⣿⣿
2266 //    ⣿⣿⣿⣿⣿⣿⣿⣿⡛⠛⠛⠛⠛⠛⠛⢿⢻⣿⡿⠟⠋⣴⣾⣿⣿⣿⣿⣿⣿⣿
2267 //    ⣿⣿⣿⣿⡿⢛⣋⠉⠁⠄⢀⠠⠄⠄⠄⠈⠄⠋⡂⠠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
2268 //    ⣿⣿⣿⣛⣛⣉⠄⢀⡤⠊⠁⠄⠄⠄⢀⠄⠄⠄⠄⠲⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿
2269 //    ⣿⡿⠟⠋⠄⠄⡠⠊⠄⠄⠄⠄⠄⣀⣼⣤⣤⣤⣀⠄⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿
2270 //    ⣿⠛⣁⡀⠄⡠⠄⠄⠄⠄⠄⠄⢠⣿⣿⣿⣿⣿⣿⣷⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿
2271 //    ⣿⠿⢟⡉⠰⠁⠄⠄⠄⠄⠄⠄⠄⠙⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
2272 //    ⡇⠄⠄⠙⠃⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠈⠉⠉⠛⠛⠛⠻⢿⣿⣿⣿⣿
2273 //    ⣇⠄⢰⣄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠉⠻⣿⣿
2274 //    ⣿⠄⠈⠻⣦⣤⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣦⠙⣿
2275 //    ⣿⣄⠄⠚⢿⣿⡟⠄⠄⠄⢀⡀⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢀⣿⣧⠸
2276 //    ⣿⣿⣆⠄⢸⡿⠄⠄⢀⣴⣿⣿⣿⣿⣷⣶⣶⣶⣶⠄⠄⠄⠄⠄⠄⢀⣾⣿⣿⠄
2277 //    ⣿⣿⣿⣷⡞⠁⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠄⠄⣠⣾⣿⣿⣿⣿⢀
2278 //    ⣿⣿⣿⡿⠁⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠄⠄⠘⣿⣿⡿⠟⢃⣼
2279 //    ⣿⣿⠏⠄⠠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⢀⡠⢄⡠⡭⠄⣠⢠⣾⣿
2280 //    ⠏⠄⠄⣸⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠄⢀⣦⣒⣁⣒⣩⣄⣃⢀⣮⣥⣼⣿
2281 //    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
2282 
2283 
2284 
2285 contract CLIQU3 is ERC721A, DefaultOperatorFilterer, Ownable  {
2286     using Strings for uint256;
2287 
2288     uint256 public maxSupply = 3333;
2289     uint256 public maxMintPerAddressLimit = 1;
2290     uint256 public percentPerTransfer = 10;
2291     uint256 public wl333Counter = 0;
2292     uint256 public wl3000Counter = 0;
2293     uint256 public seed;
2294     uint256 public publicCost = 0.036 ether;
2295     uint256 public wl333Cost = 0.033 ether;
2296     uint256 public wl3000Cost = 0.033 ether;
2297 
2298     bytes32 public merkleRoot333;
2299     bytes32 public merkleRoot3000;
2300     
2301     string public notRevealedUri;
2302     string public prefix = "https://ipfs.io/ipfs/";
2303     string [] public collections;
2304 
2305     bool public pausedPublic = true;
2306     bool public pausedWL3000 = true;
2307     bool public pausedWL333 = true;
2308     bool public pausedTeamMint = true;
2309     bool public pausedBurn = true;
2310     bool public revealed = false;
2311     
2312     address public previosCollection = 0x6411eD216ef6243d115Ac074c20C434D6892c99A;
2313     address public royaltiesAddress = 0x73F52CacA22C867c4CbB6f1e923AA203B4552d77;
2314     address private otherContract;   
2315     address [] public teamList;
2316 
2317     mapping(uint256 => uint256) public tokenView;
2318     mapping(uint256 => bool) public upgradeable;
2319     mapping(uint256 => bool) public blacklistNFTs;
2320     mapping(address => uint256) public mintedInWhichWl;
2321 
2322     event ChangeView(uint256 tokenId, uint256 value);
2323     event Upgraded(uint256 tokenId);
2324 
2325     constructor(
2326         string memory _name,
2327         string memory _symbol,
2328         address _initOtherContract,
2329         string memory _initNotRevealedUri,
2330         bytes32 _initMerkleRoot333,
2331         bytes32 _initMerkleRoot3000
2332         
2333     ) ERC721A(_name, _symbol) {
2334         seed = block.timestamp % 100;
2335         setOtherContractAddress(_initOtherContract);
2336         setNotRevealedURI(_initNotRevealedUri); 
2337         setMerkleRootes(_initMerkleRoot3000, _initMerkleRoot333);
2338         teamList = [
2339         0xc2f71aA2763996e89484a9BFEDbFD204C89Ba5Cf, 
2340         0xEb2C0650121D4918FF4b2fE05fc015b68A011108, 
2341         0xdF50e44B6ee419E5a6870643f97EDdB4CFFa5211, 
2342         0x81243fA8910C238f1f87c5C6c9e66320aec7405C,
2343         0xACd6c2F22493DF8afF4771cd2F85CccC0fd2b2dF,
2344         0x4Fe55865a637dF7F56a197EFa580f5AE0B7c3be8,
2345         0x7823d83BEf4ab60cF64868de44BAE1fd5Fa1Be0b,
2346         0x8c94fa6143BD430Fa114b60CF5A3EEB5B6C88D2f,
2347         0x1Bd4f4ae1Ebc651168D02416D1814eAE6D2A352E,
2348         0x6d3A97448829acD2670BC979b063B99405861fa5,
2349         0xd5a4cDe2De16d084cd51c24b6169cF07Dd28bC0D,
2350         0x6564cBe29eeabA8b1eee4DF183068B1122097277,
2351         0x9043f28E48a278D24B70b056209BD019b1b07003,
2352         0x404AA2D581598A25FFf9C100566205d7337d5E94
2353         ];
2354         
2355     }
2356 
2357 
2358     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2359         super.setApprovalForAll(operator, approved);
2360     }
2361 
2362     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2363         super.approve(operator, tokenId);
2364     }
2365 
2366     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2367         super.transferFrom(from, to, tokenId);
2368     }
2369 
2370     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2371         super.safeTransferFrom(from, to, tokenId);
2372     }
2373 
2374     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
2375         super.safeTransferFrom(from, to, tokenId, data);
2376     }
2377 
2378     function _startTokenId() override internal view virtual returns (uint256){
2379         return 1;
2380     }
2381 
2382     function calcWorth(uint256 quantity, bytes32[] calldata _merkleProof) internal returns(uint) {
2383        
2384         if(_merkleProof.length > 0) {
2385             
2386             require(quantity == 1, "For each wl max quantity is 1");
2387             require(_numberMinted(msg.sender) < 2, "Reached limit of two wls");
2388             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2389             
2390             if(mintedInWhichWl[msg.sender] == 3000){
2391                     require(MerkleProof.verify(_merkleProof, merkleRoot333, leaf), "Exceeded the limit for wl");
2392                     require(!pausedWL333, "WL minting is paused");
2393                     require(wl333Counter + quantity <= 333, "Reached limit of 333 tokens");
2394 
2395                     wl333Counter = wl333Counter + quantity;
2396                     return wl333Cost;
2397                     
2398             } else if(mintedInWhichWl[msg.sender] == 333){
2399                     require(MerkleProof.verify(_merkleProof, merkleRoot3000, leaf),"Exceeded the limit for wl");
2400                     require(!pausedWL3000, "WL minting is paused");
2401                     require(wl3000Counter + quantity <= 3000, "Reached limit of 3000 tokens");
2402 
2403                     wl3000Counter = wl3000Counter + quantity;
2404                     return wl3000Cost;
2405                     
2406             } else {
2407 
2408                 if(MerkleProof.verify(_merkleProof, merkleRoot3000, leaf)){
2409                     require(!pausedWL3000, "WL minting is paused");
2410                     require(wl3000Counter + quantity <= 3000, "Reached limit of 3000 tokens");
2411 
2412                     wl3000Counter = wl3000Counter + quantity;
2413                     mintedInWhichWl[msg.sender] = 3000;
2414                     return wl3000Cost;
2415 
2416                 } else if(MerkleProof.verify(_merkleProof, merkleRoot333, leaf)){
2417                     require(!pausedWL333, "WL minting is paused");
2418                     require(wl333Counter + quantity <= 333, "Reached limit of 333 tokens");
2419 
2420                     wl333Counter = wl333Counter + quantity;
2421                     mintedInWhichWl[msg.sender] = 333;
2422                     return wl333Cost;
2423 
2424                 } else {
2425                     revert("You arent registered in wl");
2426                 }
2427             }
2428             
2429         }
2430         
2431         require(!pausedPublic, "Public minting is paused");
2432         (,bytes memory response) = previosCollection.call(abi.encodeWithSignature("balanceOf(address)", msg.sender, msg.sender));
2433 
2434         uint256 res = abi.decode(response, (uint256));
2435 
2436         if(res > 0 && _numberMinted(msg.sender) + quantity <= res){
2437             return 0;
2438         }
2439 
2440         return publicCost;
2441     }
2442 
2443     function mint(uint256 quantity, bytes32[] calldata _merkleProof) external payable notContract{
2444         require(quantity > 0 && quantity <= 6, "Invalid mint amount! (max 6)");
2445         require(totalSupply() + quantity <= maxSupply, "Not enough tokens left");
2446 
2447         require(msg.value >= calcWorth(quantity, _merkleProof), "Not enough ethers paid");
2448 
2449         _safeMint(msg.sender, quantity);
2450         
2451     }
2452 
2453     function teamMint(uint256 quantity) external {
2454         if(msg.sender != owner()){
2455             require(_numberMinted(msg.sender) + quantity <= 1, "Exceeded the limit for team mint");
2456             require(!pausedTeamMint, "Team mint paused");
2457             uint256 k = 0;
2458             
2459             for (uint i = 0; i < teamList.length; i++) {
2460                 if(teamList[i] == msg.sender){
2461                     k = 1;
2462                     }
2463                 }
2464 
2465             require(k == 1, "You arent registered in team list");
2466         }
2467         
2468         require(totalSupply() + quantity <= maxSupply, "Not enough tokens left");
2469         
2470         _safeMint(msg.sender, quantity);
2471 
2472     }
2473 
2474     function validating(address from, address to, uint256 tokenId) internal virtual override {
2475         bool isContract = _isContract(to);
2476         if(!revealed && isContract){
2477             blacklistNFTs[tokenId] = true;
2478         }
2479         if(upgradeable[tokenId] != true && from != address(0)){
2480                 (,bytes memory response) = otherContract.call(abi.encodeWithSignature("isValid(address,uint256)", to, tokenId, msg.sender));
2481 
2482                 bool res = abi.decode(response, (bool));
2483                 if(res == true){
2484                     seed = (seed + block.timestamp) % 100;
2485                     if(seed <= percentPerTransfer){
2486                         upgradeable[tokenId] = true;
2487                         blacklistNFTs[tokenId] = false;
2488                         tokenView[tokenId] = 1;
2489                         emit ChangeView(tokenId, 1);
2490                         emit Upgraded(tokenId);
2491                     }
2492                 }
2493 
2494         }
2495         
2496     }
2497 
2498     function upgrade(uint256 tokenId) external {
2499         require(revealed, "No access to upgrade until reveal");
2500         require(blacklistNFTs[tokenId] == false, "Token was traded until reveal");
2501         upgradeable[tokenId] = true;
2502         tokenView[tokenId] = 1;
2503         emit ChangeView(tokenId, 1);
2504         emit Upgraded(tokenId);
2505     }
2506 
2507     function switchView(uint256 tokenId, uint256 num) external {
2508         require(num - 1 <= collections.length, "Invalid collection number");
2509         if(num == 1){
2510             require(upgradeable[tokenId]== true, "Token not upgraded");
2511         }
2512         tokenView[tokenId] = num;
2513         emit ChangeView(tokenId, num);
2514     }
2515 
2516     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2517         require(_exists(tokenId), "URI query for nonexistent token");
2518 
2519         if(revealed == false) {
2520             return string(abi.encodePacked(prefix, notRevealedUri));
2521         }
2522 
2523         return string(abi.encodePacked(prefix, collections[tokenView[tokenId]], "/", tokenId.toString(), ".json"));
2524 
2525     }
2526 
2527     function pauseTeamMint(bool _state) public onlyOwner{
2528         pausedTeamMint = _state;
2529     }
2530 
2531     function setMerkleRootes(bytes32 _newMerkleRoot3000, bytes32 _newMerkleRoot333) public onlyOwner {
2532         merkleRoot3000 = _newMerkleRoot3000;
2533         merkleRoot333 = _newMerkleRoot333;
2534     }
2535 
2536     function setCost(uint256 _newPublicCost, uint256 _newWl333Cost, uint256 _newWl3000Cost) public onlyOwner {
2537         publicCost = _newPublicCost;
2538         wl333Cost = _newWl333Cost;
2539         wl3000Cost = _newWl3000Cost;
2540     }
2541 
2542     function setRoyaltiesAddress(address _newAddress) public onlyOwner {
2543         royaltiesAddress = _newAddress;
2544     }
2545 
2546     function setPreviousCollectionAddress(address _newAddress) public onlyOwner {
2547         previosCollection = _newAddress;
2548     }
2549 
2550     function setOtherContractAddress(address _newOtherContract) public onlyOwner {
2551         otherContract = _newOtherContract;
2552     }
2553 
2554     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2555         notRevealedUri = _notRevealedURI;
2556     }
2557 
2558     function setUpTeam(address[] memory _newTeam) public onlyOwner {
2559         teamList = _newTeam;
2560     }
2561 
2562     function addCollection(string memory _newCollection) public onlyOwner{
2563         collections.push(_newCollection);
2564     }
2565 
2566     function modifyCollection(string memory _modified, uint256 indx) public onlyOwner{
2567         collections[indx] = _modified;
2568     }
2569 
2570     function reveal() public onlyOwner {
2571         revealed = true;
2572     }
2573 
2574     function pausePublicMint(bool _state) public onlyOwner {
2575         pausedPublic = _state;
2576     }
2577 
2578     function pauseWl3000(bool _state) public onlyOwner {
2579         pausedWL3000 = _state;
2580     }
2581 
2582     function pauseWl333(bool _state) public onlyOwner {
2583         pausedWL333 = _state;
2584     }
2585 
2586     function pauseBurn(bool _state) public onlyOwner {
2587         pausedBurn = _state; 
2588     }
2589 
2590     function burn(uint256 from, uint256 to) public onlyOwner{
2591         require(!pausedBurn, "Burn is paused");
2592         for(uint256 i = from; i <= to; i++){
2593             require(ownerOf(i) == msg.sender, "Not allowed");
2594             _burn(i);
2595         }
2596     }
2597 
2598     modifier notContract() {
2599         require(!_isContract(msg.sender), "Contract not allowed");
2600         _;
2601     }
2602 
2603     function _isContract(address _addr) internal view returns (bool) {
2604         uint256 size;
2605         assembly {
2606             size := extcodesize(_addr)
2607         }
2608         if(size > 0 || msg.sender != tx.origin){
2609             return true;
2610         } else {
2611             return false;
2612         }
2613     }
2614     
2615     function withdraw(address payable _to) external onlyOwner {
2616         uint256 balance = address(this).balance;
2617         uint256 royaltis = address(this).balance / 10;
2618         _to.transfer(balance - royaltis);
2619         payable(royaltiesAddress).transfer(royaltis);
2620     }
2621 
2622     receive() external payable {
2623 
2624     }
2625 }