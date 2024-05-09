1 // File: contracts/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function updateOperator(address registrant, address operator, bool filtered) external;
12     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
13     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
14     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
15     function subscribe(address registrant, address registrantToSubscribe) external;
16     function unsubscribe(address registrant, bool copyExistingEntries) external;
17     function subscriptionOf(address addr) external returns (address registrant);
18     function subscribers(address registrant) external returns (address[] memory);
19     function subscriberAt(address registrant, uint256 index) external returns (address);
20     function copyEntriesOf(address registrant, address registrantToCopy) external;
21     function isOperatorFiltered(address registrant, address operator) external returns (bool);
22     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
23     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
24     function filteredOperators(address addr) external returns (address[] memory);
25     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
26     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
27     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
28     function isRegistered(address addr) external returns (bool);
29     function codeHashOf(address addr) external returns (bytes32);
30 }
31 // File: contracts/OperatorFilterer.sol
32 
33 
34 pragma solidity ^0.8.13;
35 
36 
37 abstract contract OperatorFilterer {
38     error OperatorNotAllowed(address operator);
39 
40     IOperatorFilterRegistry constant operatorFilterRegistry =
41         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
42 
43     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
44         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
45         // will not revert, but the contract will need to be registered with the registry once it is deployed in
46         // order for the modifier to filter addresses.
47         if (address(operatorFilterRegistry).code.length > 0) {
48             if (subscribe) {
49                 operatorFilterRegistry.registerAndSubscribe(
50                     address(this),
51                     subscriptionOrRegistrantToCopy
52                 );
53             } else {
54                 if (subscriptionOrRegistrantToCopy != address(0)) {
55                     operatorFilterRegistry.registerAndCopyEntries(
56                         address(this),
57                         subscriptionOrRegistrantToCopy
58                     );
59                 } else {
60                     operatorFilterRegistry.register(address(this));
61                 }
62             }
63         }
64     }
65 
66     modifier onlyAllowedOperator(address from) virtual {
67         // Check registry code length to facilitate testing in environments without a deployed registry.
68         if (address(operatorFilterRegistry).code.length > 0) {
69             // Allow spending tokens from addresses with balance
70             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
71             // from an EOA.
72             if (from == msg.sender) {
73                 _;
74                 return;
75             }
76             if (
77                 !(operatorFilterRegistry.isOperatorAllowed(
78                     address(this),
79                     msg.sender
80                 ) &&
81                     operatorFilterRegistry.isOperatorAllowed(
82                         address(this),
83                         from
84                     ))
85             ) {
86                 revert OperatorNotAllowed(msg.sender);
87             }
88         }
89         _;
90     }
91 }
92 // File: contracts/DefaultOperatorFilterer.sol
93 
94 
95 pragma solidity ^0.8.13;
96 
97 
98 abstract contract DefaultOperatorFilterer is OperatorFilterer {
99     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
100 
101     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
102 }
103 
104 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
105 
106 
107 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
108 
109 pragma solidity ^0.8.0;
110 
111 /**
112  * @dev These functions deal with verification of Merkle Tree proofs.
113  *
114  * The tree and the proofs can be generated using our
115  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
116  * You will find a quickstart guide in the readme.
117  *
118  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
119  * hashing, or use a hash function other than keccak256 for hashing leaves.
120  * This is because the concatenation of a sorted pair of internal nodes in
121  * the merkle tree could be reinterpreted as a leaf value.
122  * OpenZeppelin's JavaScript library generates merkle trees that are safe
123  * against this attack out of the box.
124  */
125 library MerkleProof {
126     /**
127      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
128      * defined by `root`. For this, a `proof` must be provided, containing
129      * sibling hashes on the branch from the leaf to the root of the tree. Each
130      * pair of leaves and each pair of pre-images are assumed to be sorted.
131      */
132     function verify(
133         bytes32[] memory proof,
134         bytes32 root,
135         bytes32 leaf
136     ) internal pure returns (bool) {
137         return processProof(proof, leaf) == root;
138     }
139 
140     /**
141      * @dev Calldata version of {verify}
142      *
143      * _Available since v4.7._
144      */
145     function verifyCalldata(
146         bytes32[] calldata proof,
147         bytes32 root,
148         bytes32 leaf
149     ) internal pure returns (bool) {
150         return processProofCalldata(proof, leaf) == root;
151     }
152 
153     /**
154      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
155      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
156      * hash matches the root of the tree. When processing the proof, the pairs
157      * of leafs & pre-images are assumed to be sorted.
158      *
159      * _Available since v4.4._
160      */
161     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
162         bytes32 computedHash = leaf;
163         for (uint256 i = 0; i < proof.length; i++) {
164             computedHash = _hashPair(computedHash, proof[i]);
165         }
166         return computedHash;
167     }
168 
169     /**
170      * @dev Calldata version of {processProof}
171      *
172      * _Available since v4.7._
173      */
174     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
175         bytes32 computedHash = leaf;
176         for (uint256 i = 0; i < proof.length; i++) {
177             computedHash = _hashPair(computedHash, proof[i]);
178         }
179         return computedHash;
180     }
181 
182     /**
183      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
184      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
185      *
186      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
187      *
188      * _Available since v4.7._
189      */
190     function multiProofVerify(
191         bytes32[] memory proof,
192         bool[] memory proofFlags,
193         bytes32 root,
194         bytes32[] memory leaves
195     ) internal pure returns (bool) {
196         return processMultiProof(proof, proofFlags, leaves) == root;
197     }
198 
199     /**
200      * @dev Calldata version of {multiProofVerify}
201      *
202      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
203      *
204      * _Available since v4.7._
205      */
206     function multiProofVerifyCalldata(
207         bytes32[] calldata proof,
208         bool[] calldata proofFlags,
209         bytes32 root,
210         bytes32[] memory leaves
211     ) internal pure returns (bool) {
212         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
213     }
214 
215     /**
216      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
217      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
218      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
219      * respectively.
220      *
221      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
222      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
223      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
224      *
225      * _Available since v4.7._
226      */
227     function processMultiProof(
228         bytes32[] memory proof,
229         bool[] memory proofFlags,
230         bytes32[] memory leaves
231     ) internal pure returns (bytes32 merkleRoot) {
232         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
233         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
234         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
235         // the merkle tree.
236         uint256 leavesLen = leaves.length;
237         uint256 totalHashes = proofFlags.length;
238 
239         // Check proof validity.
240         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
241 
242         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
243         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
244         bytes32[] memory hashes = new bytes32[](totalHashes);
245         uint256 leafPos = 0;
246         uint256 hashPos = 0;
247         uint256 proofPos = 0;
248         // At each step, we compute the next hash using two values:
249         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
250         //   get the next hash.
251         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
252         //   `proof` array.
253         for (uint256 i = 0; i < totalHashes; i++) {
254             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
255             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
256             hashes[i] = _hashPair(a, b);
257         }
258 
259         if (totalHashes > 0) {
260             return hashes[totalHashes - 1];
261         } else if (leavesLen > 0) {
262             return leaves[0];
263         } else {
264             return proof[0];
265         }
266     }
267 
268     /**
269      * @dev Calldata version of {processMultiProof}.
270      *
271      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
272      *
273      * _Available since v4.7._
274      */
275     function processMultiProofCalldata(
276         bytes32[] calldata proof,
277         bool[] calldata proofFlags,
278         bytes32[] memory leaves
279     ) internal pure returns (bytes32 merkleRoot) {
280         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
281         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
282         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
283         // the merkle tree.
284         uint256 leavesLen = leaves.length;
285         uint256 totalHashes = proofFlags.length;
286 
287         // Check proof validity.
288         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
289 
290         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
291         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
292         bytes32[] memory hashes = new bytes32[](totalHashes);
293         uint256 leafPos = 0;
294         uint256 hashPos = 0;
295         uint256 proofPos = 0;
296         // At each step, we compute the next hash using two values:
297         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
298         //   get the next hash.
299         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
300         //   `proof` array.
301         for (uint256 i = 0; i < totalHashes; i++) {
302             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
303             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
304             hashes[i] = _hashPair(a, b);
305         }
306 
307         if (totalHashes > 0) {
308             return hashes[totalHashes - 1];
309         } else if (leavesLen > 0) {
310             return leaves[0];
311         } else {
312             return proof[0];
313         }
314     }
315 
316     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
317         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
318     }
319 
320     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
321         /// @solidity memory-safe-assembly
322         assembly {
323             mstore(0x00, a)
324             mstore(0x20, b)
325             value := keccak256(0x00, 0x40)
326         }
327     }
328 }
329 
330 // File: @openzeppelin/contracts/utils/math/Math.sol
331 
332 
333 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev Standard math utilities missing in the Solidity language.
339  */
340 library Math {
341     enum Rounding {
342         Down, // Toward negative infinity
343         Up, // Toward infinity
344         Zero // Toward zero
345     }
346 
347     /**
348      * @dev Returns the largest of two numbers.
349      */
350     function max(uint256 a, uint256 b) internal pure returns (uint256) {
351         return a > b ? a : b;
352     }
353 
354     /**
355      * @dev Returns the smallest of two numbers.
356      */
357     function min(uint256 a, uint256 b) internal pure returns (uint256) {
358         return a < b ? a : b;
359     }
360 
361     /**
362      * @dev Returns the average of two numbers. The result is rounded towards
363      * zero.
364      */
365     function average(uint256 a, uint256 b) internal pure returns (uint256) {
366         // (a + b) / 2 can overflow.
367         return (a & b) + (a ^ b) / 2;
368     }
369 
370     /**
371      * @dev Returns the ceiling of the division of two numbers.
372      *
373      * This differs from standard division with `/` in that it rounds up instead
374      * of rounding down.
375      */
376     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
377         // (a + b - 1) / b can overflow on addition, so we distribute.
378         return a == 0 ? 0 : (a - 1) / b + 1;
379     }
380 
381     /**
382      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
383      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
384      * with further edits by Uniswap Labs also under MIT license.
385      */
386     function mulDiv(
387         uint256 x,
388         uint256 y,
389         uint256 denominator
390     ) internal pure returns (uint256 result) {
391         unchecked {
392             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
393             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
394             // variables such that product = prod1 * 2^256 + prod0.
395             uint256 prod0; // Least significant 256 bits of the product
396             uint256 prod1; // Most significant 256 bits of the product
397             assembly {
398                 let mm := mulmod(x, y, not(0))
399                 prod0 := mul(x, y)
400                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
401             }
402 
403             // Handle non-overflow cases, 256 by 256 division.
404             if (prod1 == 0) {
405                 return prod0 / denominator;
406             }
407 
408             // Make sure the result is less than 2^256. Also prevents denominator == 0.
409             require(denominator > prod1);
410 
411             ///////////////////////////////////////////////
412             // 512 by 256 division.
413             ///////////////////////////////////////////////
414 
415             // Make division exact by subtracting the remainder from [prod1 prod0].
416             uint256 remainder;
417             assembly {
418                 // Compute remainder using mulmod.
419                 remainder := mulmod(x, y, denominator)
420 
421                 // Subtract 256 bit number from 512 bit number.
422                 prod1 := sub(prod1, gt(remainder, prod0))
423                 prod0 := sub(prod0, remainder)
424             }
425 
426             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
427             // See https://cs.stackexchange.com/q/138556/92363.
428 
429             // Does not overflow because the denominator cannot be zero at this stage in the function.
430             uint256 twos = denominator & (~denominator + 1);
431             assembly {
432                 // Divide denominator by twos.
433                 denominator := div(denominator, twos)
434 
435                 // Divide [prod1 prod0] by twos.
436                 prod0 := div(prod0, twos)
437 
438                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
439                 twos := add(div(sub(0, twos), twos), 1)
440             }
441 
442             // Shift in bits from prod1 into prod0.
443             prod0 |= prod1 * twos;
444 
445             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
446             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
447             // four bits. That is, denominator * inv = 1 mod 2^4.
448             uint256 inverse = (3 * denominator) ^ 2;
449 
450             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
451             // in modular arithmetic, doubling the correct bits in each step.
452             inverse *= 2 - denominator * inverse; // inverse mod 2^8
453             inverse *= 2 - denominator * inverse; // inverse mod 2^16
454             inverse *= 2 - denominator * inverse; // inverse mod 2^32
455             inverse *= 2 - denominator * inverse; // inverse mod 2^64
456             inverse *= 2 - denominator * inverse; // inverse mod 2^128
457             inverse *= 2 - denominator * inverse; // inverse mod 2^256
458 
459             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
460             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
461             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
462             // is no longer required.
463             result = prod0 * inverse;
464             return result;
465         }
466     }
467 
468     /**
469      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
470      */
471     function mulDiv(
472         uint256 x,
473         uint256 y,
474         uint256 denominator,
475         Rounding rounding
476     ) internal pure returns (uint256) {
477         uint256 result = mulDiv(x, y, denominator);
478         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
479             result += 1;
480         }
481         return result;
482     }
483 
484     /**
485      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
486      *
487      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
488      */
489     function sqrt(uint256 a) internal pure returns (uint256) {
490         if (a == 0) {
491             return 0;
492         }
493 
494         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
495         //
496         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
497         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
498         //
499         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
500         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
501         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
502         //
503         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
504         uint256 result = 1 << (log2(a) >> 1);
505 
506         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
507         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
508         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
509         // into the expected uint128 result.
510         unchecked {
511             result = (result + a / result) >> 1;
512             result = (result + a / result) >> 1;
513             result = (result + a / result) >> 1;
514             result = (result + a / result) >> 1;
515             result = (result + a / result) >> 1;
516             result = (result + a / result) >> 1;
517             result = (result + a / result) >> 1;
518             return min(result, a / result);
519         }
520     }
521 
522     /**
523      * @notice Calculates sqrt(a), following the selected rounding direction.
524      */
525     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
526         unchecked {
527             uint256 result = sqrt(a);
528             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
529         }
530     }
531 
532     /**
533      * @dev Return the log in base 2, rounded down, of a positive value.
534      * Returns 0 if given 0.
535      */
536     function log2(uint256 value) internal pure returns (uint256) {
537         uint256 result = 0;
538         unchecked {
539             if (value >> 128 > 0) {
540                 value >>= 128;
541                 result += 128;
542             }
543             if (value >> 64 > 0) {
544                 value >>= 64;
545                 result += 64;
546             }
547             if (value >> 32 > 0) {
548                 value >>= 32;
549                 result += 32;
550             }
551             if (value >> 16 > 0) {
552                 value >>= 16;
553                 result += 16;
554             }
555             if (value >> 8 > 0) {
556                 value >>= 8;
557                 result += 8;
558             }
559             if (value >> 4 > 0) {
560                 value >>= 4;
561                 result += 4;
562             }
563             if (value >> 2 > 0) {
564                 value >>= 2;
565                 result += 2;
566             }
567             if (value >> 1 > 0) {
568                 result += 1;
569             }
570         }
571         return result;
572     }
573 
574     /**
575      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
576      * Returns 0 if given 0.
577      */
578     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
579         unchecked {
580             uint256 result = log2(value);
581             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
582         }
583     }
584 
585     /**
586      * @dev Return the log in base 10, rounded down, of a positive value.
587      * Returns 0 if given 0.
588      */
589     function log10(uint256 value) internal pure returns (uint256) {
590         uint256 result = 0;
591         unchecked {
592             if (value >= 10**64) {
593                 value /= 10**64;
594                 result += 64;
595             }
596             if (value >= 10**32) {
597                 value /= 10**32;
598                 result += 32;
599             }
600             if (value >= 10**16) {
601                 value /= 10**16;
602                 result += 16;
603             }
604             if (value >= 10**8) {
605                 value /= 10**8;
606                 result += 8;
607             }
608             if (value >= 10**4) {
609                 value /= 10**4;
610                 result += 4;
611             }
612             if (value >= 10**2) {
613                 value /= 10**2;
614                 result += 2;
615             }
616             if (value >= 10**1) {
617                 result += 1;
618             }
619         }
620         return result;
621     }
622 
623     /**
624      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
625      * Returns 0 if given 0.
626      */
627     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
628         unchecked {
629             uint256 result = log10(value);
630             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
631         }
632     }
633 
634     /**
635      * @dev Return the log in base 256, rounded down, of a positive value.
636      * Returns 0 if given 0.
637      *
638      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
639      */
640     function log256(uint256 value) internal pure returns (uint256) {
641         uint256 result = 0;
642         unchecked {
643             if (value >> 128 > 0) {
644                 value >>= 128;
645                 result += 16;
646             }
647             if (value >> 64 > 0) {
648                 value >>= 64;
649                 result += 8;
650             }
651             if (value >> 32 > 0) {
652                 value >>= 32;
653                 result += 4;
654             }
655             if (value >> 16 > 0) {
656                 value >>= 16;
657                 result += 2;
658             }
659             if (value >> 8 > 0) {
660                 result += 1;
661             }
662         }
663         return result;
664     }
665 
666     /**
667      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
668      * Returns 0 if given 0.
669      */
670     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
671         unchecked {
672             uint256 result = log256(value);
673             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
674         }
675     }
676 }
677 
678 // File: @openzeppelin/contracts/utils/Strings.sol
679 
680 
681 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @dev String operations.
688  */
689 library Strings {
690     bytes16 private constant _SYMBOLS = "0123456789abcdef";
691     uint8 private constant _ADDRESS_LENGTH = 20;
692 
693     /**
694      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
695      */
696     function toString(uint256 value) internal pure returns (string memory) {
697         unchecked {
698             uint256 length = Math.log10(value) + 1;
699             string memory buffer = new string(length);
700             uint256 ptr;
701             /// @solidity memory-safe-assembly
702             assembly {
703                 ptr := add(buffer, add(32, length))
704             }
705             while (true) {
706                 ptr--;
707                 /// @solidity memory-safe-assembly
708                 assembly {
709                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
710                 }
711                 value /= 10;
712                 if (value == 0) break;
713             }
714             return buffer;
715         }
716     }
717 
718     /**
719      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
720      */
721     function toHexString(uint256 value) internal pure returns (string memory) {
722         unchecked {
723             return toHexString(value, Math.log256(value) + 1);
724         }
725     }
726 
727     /**
728      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
729      */
730     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
731         bytes memory buffer = new bytes(2 * length + 2);
732         buffer[0] = "0";
733         buffer[1] = "x";
734         for (uint256 i = 2 * length + 1; i > 1; --i) {
735             buffer[i] = _SYMBOLS[value & 0xf];
736             value >>= 4;
737         }
738         require(value == 0, "Strings: hex length insufficient");
739         return string(buffer);
740     }
741 
742     /**
743      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
744      */
745     function toHexString(address addr) internal pure returns (string memory) {
746         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
747     }
748 }
749 
750 // File: @openzeppelin/contracts/utils/Context.sol
751 
752 
753 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
754 
755 pragma solidity ^0.8.0;
756 
757 /**
758  * @dev Provides information about the current execution context, including the
759  * sender of the transaction and its data. While these are generally available
760  * via msg.sender and msg.data, they should not be accessed in such a direct
761  * manner, since when dealing with meta-transactions the account sending and
762  * paying for execution may not be the actual sender (as far as an application
763  * is concerned).
764  *
765  * This contract is only required for intermediate, library-like contracts.
766  */
767 abstract contract Context {
768     function _msgSender() internal view virtual returns (address) {
769         return msg.sender;
770     }
771 
772     function _msgData() internal view virtual returns (bytes calldata) {
773         return msg.data;
774     }
775 }
776 
777 // File: @openzeppelin/contracts/access/Ownable.sol
778 
779 
780 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
781 
782 pragma solidity ^0.8.0;
783 
784 
785 /**
786  * @dev Contract module which provides a basic access control mechanism, where
787  * there is an account (an owner) that can be granted exclusive access to
788  * specific functions.
789  *
790  * By default, the owner account will be the one that deploys the contract. This
791  * can later be changed with {transferOwnership}.
792  *
793  * This module is used through inheritance. It will make available the modifier
794  * `onlyOwner`, which can be applied to your functions to restrict their use to
795  * the owner.
796  */
797 abstract contract Ownable is Context {
798     address private _owner;
799 
800     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
801 
802     /**
803      * @dev Initializes the contract setting the deployer as the initial owner.
804      */
805     constructor() {
806         _transferOwnership(_msgSender());
807     }
808 
809     /**
810      * @dev Throws if called by any account other than the owner.
811      */
812     modifier onlyOwner() {
813         _checkOwner();
814         _;
815     }
816 
817     /**
818      * @dev Returns the address of the current owner.
819      */
820     function owner() public view virtual returns (address) {
821         return _owner;
822     }
823 
824     /**
825      * @dev Throws if the sender is not the owner.
826      */
827     function _checkOwner() internal view virtual {
828         require(owner() == _msgSender(), "Ownable: caller is not the owner");
829     }
830 
831     /**
832      * @dev Leaves the contract without owner. It will not be possible to call
833      * `onlyOwner` functions anymore. Can only be called by the current owner.
834      *
835      * NOTE: Renouncing ownership will leave the contract without an owner,
836      * thereby removing any functionality that is only available to the owner.
837      */
838     function renounceOwnership() public virtual onlyOwner {
839         _transferOwnership(address(0));
840     }
841 
842     /**
843      * @dev Transfers ownership of the contract to a new account (`newOwner`).
844      * Can only be called by the current owner.
845      */
846     function transferOwnership(address newOwner) public virtual onlyOwner {
847         require(newOwner != address(0), "Ownable: new owner is the zero address");
848         _transferOwnership(newOwner);
849     }
850 
851     /**
852      * @dev Transfers ownership of the contract to a new account (`newOwner`).
853      * Internal function without access restriction.
854      */
855     function _transferOwnership(address newOwner) internal virtual {
856         address oldOwner = _owner;
857         _owner = newOwner;
858         emit OwnershipTransferred(oldOwner, newOwner);
859     }
860 }
861 
862 // File: contracts/IERC721A.sol
863 
864 
865 // ERC721A Contracts v4.0.0
866 // Creator: Chiru Labs
867 
868 pragma solidity ^0.8.13;
869 
870 /**
871  * @dev Interface of an ERC721A compliant contract.
872  */
873 interface IERC721A {
874     /**
875      * The caller must own the token or be an approved operator.
876      */
877     error ApprovalCallerNotOwnerNorApproved();
878 
879     /**
880      * The token does not exist.
881      */
882     error ApprovalQueryForNonexistentToken();
883 
884     /**
885      * The caller cannot approve to their own address.
886      */
887     error ApproveToCaller();
888 
889     /**
890      * The caller cannot approve to the current owner.
891      */
892     error ApprovalToCurrentOwner();
893 
894     /**
895      * Cannot query the balance for the zero address.
896      */
897     error BalanceQueryForZeroAddress();
898 
899     /**
900      * Cannot mint to the zero address.
901      */
902     error MintToZeroAddress();
903 
904     /**
905      * The quantity of tokens minted must be more than zero.
906      */
907     error MintZeroQuantity();
908 
909     /**
910      * The token does not exist.
911      */
912     error OwnerQueryForNonexistentToken();
913 
914     /**
915      * The caller must own the token or be an approved operator.
916      */
917     error TransferCallerNotOwnerNorApproved();
918 
919     /**
920      * The token must be owned by `from`.
921      */
922     error TransferFromIncorrectOwner();
923 
924     /**
925      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
926      */
927     error TransferToNonERC721ReceiverImplementer();
928 
929     /**
930      * Cannot transfer to the zero address.
931      */
932     error TransferToZeroAddress();
933 
934     /**
935      * The token does not exist.
936      */
937     error URIQueryForNonexistentToken();
938 
939     struct TokenOwnership {
940         // The address of the owner.
941         address addr;
942         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
943         uint64 startTimestamp;
944         // Whether the token has been burned.
945         bool burned;
946     }
947 
948     /**
949      * @dev Returns the total amount of tokens stored by the contract.
950      *
951      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
952      */
953     function totalSupply() external view returns (uint256);
954 
955     // ==============================
956     //            IERC165
957     // ==============================
958 
959     /**
960      * @dev Returns true if this contract implements the interface defined by
961      * `interfaceId`. See the corresponding
962      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
963      * to learn more about how these ids are created.
964      *
965      * This function call must use less than 30 000 gas.
966      */
967     function supportsInterface(bytes4 interfaceId) external view returns (bool);
968 
969     // ==============================
970     //            IERC721
971     // ==============================
972 
973     /**
974      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
975      */
976     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
977 
978     /**
979      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
980      */
981     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
982 
983     /**
984      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
985      */
986     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
987 
988     /**
989      * @dev Returns the number of tokens in ``owner``'s account.
990      */
991     function balanceOf(address owner) external view returns (uint256 balance);
992 
993     /**
994      * @dev Returns the owner of the `tokenId` token.
995      *
996      * Requirements:
997      *
998      * - `tokenId` must exist.
999      */
1000     function ownerOf(uint256 tokenId) external view returns (address owner);
1001 
1002     /**
1003      * @dev Safely transfers `tokenId` token from `from` to `to`.
1004      *
1005      * Requirements:
1006      *
1007      * - `from` cannot be the zero address.
1008      * - `to` cannot be the zero address.
1009      * - `tokenId` token must exist and be owned by `from`.
1010      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1011      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId,
1019         bytes calldata data
1020     ) external;
1021 
1022     /**
1023      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1024      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1025      *
1026      * Requirements:
1027      *
1028      * - `from` cannot be the zero address.
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must exist and be owned by `from`.
1031      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1032      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) external;
1041 
1042     /**
1043      * @dev Transfers `tokenId` token from `from` to `to`.
1044      *
1045      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1046      *
1047      * Requirements:
1048      *
1049      * - `from` cannot be the zero address.
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must be owned by `from`.
1052      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function transferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId
1060     ) external;
1061 
1062     /**
1063      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1064      * The approval is cleared when the token is transferred.
1065      *
1066      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1067      *
1068      * Requirements:
1069      *
1070      * - The caller must own the token or be an approved operator.
1071      * - `tokenId` must exist.
1072      *
1073      * Emits an {Approval} event.
1074      */
1075     function approve(address to, uint256 tokenId) external;
1076 
1077     /**
1078      * @dev Approve or remove `operator` as an operator for the caller.
1079      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1080      *
1081      * Requirements:
1082      *
1083      * - The `operator` cannot be the caller.
1084      *
1085      * Emits an {ApprovalForAll} event.
1086      */
1087     function setApprovalForAll(address operator, bool _approved) external;
1088 
1089     /**
1090      * @dev Returns the account approved for `tokenId` token.
1091      *
1092      * Requirements:
1093      *
1094      * - `tokenId` must exist.
1095      */
1096     function getApproved(uint256 tokenId) external view returns (address operator);
1097 
1098     /**
1099      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1100      *
1101      * See {setApprovalForAll}
1102      */
1103     function isApprovedForAll(address owner, address operator) external view returns (bool);
1104 
1105     // ==============================
1106     //        IERC721Metadata
1107     // ==============================
1108 
1109     /**
1110      * @dev Returns the token collection name.
1111      */
1112     function name() external view returns (string memory);
1113 
1114     /**
1115      * @dev Returns the token collection symbol.
1116      */
1117     function symbol() external view returns (string memory);
1118 
1119     /**
1120      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1121      */
1122     function tokenURI(uint256 tokenId) external view returns (string memory);
1123 }
1124 // File: contracts/ERC721A.sol
1125 
1126 
1127 // ERC721A Contracts v4.0.0
1128 // Creator: Chiru Labs
1129 
1130 pragma solidity ^0.8.13;
1131 
1132 
1133 /**
1134  * @dev ERC721 token receiver interface.
1135  */
1136 interface ERC721A__IERC721Receiver {
1137     function onERC721Received(
1138         address operator,
1139         address from,
1140         uint256 tokenId,
1141         bytes calldata data
1142     ) external returns (bytes4);
1143 }
1144 
1145 /**
1146  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1147  * the Metadata extension. Built to optimize for lower gas during batch mints.
1148  *
1149  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1150  *
1151  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1152  *
1153  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1154  */
1155 contract ERC721A is IERC721A {
1156     // Mask of an entry in packed address data.
1157     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1158 
1159     // The bit position of `numberMinted` in packed address data.
1160     uint256 private constant BITPOS_NUMBER_MINTED = 64;
1161 
1162     // The bit position of `numberBurned` in packed address data.
1163     uint256 private constant BITPOS_NUMBER_BURNED = 128;
1164 
1165     // The bit position of `aux` in packed address data.
1166     uint256 private constant BITPOS_AUX = 192;
1167 
1168     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1169     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1170 
1171     // The bit position of `startTimestamp` in packed ownership.
1172     uint256 private constant BITPOS_START_TIMESTAMP = 160;
1173 
1174     // The bit mask of the `burned` bit in packed ownership.
1175     uint256 private constant BITMASK_BURNED = 1 << 224;
1176     
1177     // The bit position of the `nextInitialized` bit in packed ownership.
1178     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
1179 
1180     // The bit mask of the `nextInitialized` bit in packed ownership.
1181     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1182 
1183     // The tokenId of the next token to be minted.
1184     uint256 private _currentIndex;
1185 
1186     // The number of tokens burned.
1187     uint256 private _burnCounter;
1188 
1189     // Token name
1190     string private _name;
1191 
1192     // Token symbol
1193     string private _symbol;
1194 
1195     // Mapping from token ID to ownership details
1196     // An empty struct value does not necessarily mean the token is unowned.
1197     // See `_packedOwnershipOf` implementation for details.
1198     //
1199     // Bits Layout:
1200     // - [0..159]   `addr`
1201     // - [160..223] `startTimestamp`
1202     // - [224]      `burned`
1203     // - [225]      `nextInitialized`
1204     mapping(uint256 => uint256) private _packedOwnerships;
1205 
1206     // Mapping owner address to address data.
1207     //
1208     // Bits Layout:
1209     // - [0..63]    `balance`
1210     // - [64..127]  `numberMinted`
1211     // - [128..191] `numberBurned`
1212     // - [192..255] `aux`
1213     mapping(address => uint256) private _packedAddressData;
1214 
1215     // Mapping from token ID to approved address.
1216     mapping(uint256 => address) private _tokenApprovals;
1217 
1218     // Mapping from owner to operator approvals
1219     mapping(address => mapping(address => bool)) private _operatorApprovals;
1220 
1221     constructor(string memory name_, string memory symbol_) {
1222         _name = name_;
1223         _symbol = symbol_;
1224         _currentIndex = _startTokenId();
1225     }
1226 
1227     /**
1228      * @dev Returns the starting token ID. 
1229      * To change the starting token ID, please override this function.
1230      */
1231     function _startTokenId() internal view virtual returns (uint256) {
1232         return 0;
1233     }
1234 
1235     /**
1236      * @dev Returns the next token ID to be minted.
1237      */
1238     function _nextTokenId() internal view returns (uint256) {
1239         return _currentIndex;
1240     }
1241 
1242     /**
1243      * @dev Returns the total number of tokens in existence.
1244      * Burned tokens will reduce the count. 
1245      * To get the total number of tokens minted, please see `_totalMinted`.
1246      */
1247     function totalSupply() public view override returns (uint256) {
1248         // Counter underflow is impossible as _burnCounter cannot be incremented
1249         // more than `_currentIndex - _startTokenId()` times.
1250         unchecked {
1251             return _currentIndex - _burnCounter - _startTokenId();
1252         }
1253     }
1254 
1255     /**
1256      * @dev Returns the total amount of tokens minted in the contract.
1257      */
1258     function _totalMinted() internal view returns (uint256) {
1259         // Counter underflow is impossible as _currentIndex does not decrement,
1260         // and it is initialized to `_startTokenId()`
1261         unchecked {
1262             return _currentIndex - _startTokenId();
1263         }
1264     }
1265 
1266     /**
1267      * @dev Returns the total number of tokens burned.
1268      */
1269     function _totalBurned() internal view returns (uint256) {
1270         return _burnCounter;
1271     }
1272 
1273     /**
1274      * @dev See {IERC165-supportsInterface}.
1275      */
1276     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1277         // The interface IDs are constants representing the first 4 bytes of the XOR of
1278         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1279         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1280         return
1281             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1282             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1283             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1284     }
1285 
1286     /**
1287      * @dev See {IERC721-balanceOf}.
1288      */
1289     function balanceOf(address owner) public view override returns (uint256) {
1290         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
1291         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1292     }
1293 
1294     /**
1295      * Returns the number of tokens minted by `owner`.
1296      */
1297     function _numberMinted(address owner) internal view returns (uint256) {
1298         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1299     }
1300 
1301     /**
1302      * Returns the number of tokens burned by or on behalf of `owner`.
1303      */
1304     function _numberBurned(address owner) internal view returns (uint256) {
1305         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1306     }
1307 
1308     /**
1309      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1310      */
1311     function _getAux(address owner) internal view returns (uint64) {
1312         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1313     }
1314 
1315     /**
1316      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1317      * If there are multiple variables, please pack them into a uint64.
1318      */
1319     function _setAux(address owner, uint64 aux) internal {
1320         uint256 packed = _packedAddressData[owner];
1321         uint256 auxCasted;
1322         assembly { // Cast aux without masking.
1323             auxCasted := aux
1324         }
1325         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1326         _packedAddressData[owner] = packed;
1327     }
1328 
1329     /**
1330      * Returns the packed ownership data of `tokenId`.
1331      */
1332     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1333         uint256 curr = tokenId;
1334 
1335         unchecked {
1336             if (_startTokenId() <= curr)
1337                 if (curr < _currentIndex) {
1338                     uint256 packed = _packedOwnerships[curr];
1339                     // If not burned.
1340                     if (packed & BITMASK_BURNED == 0) {
1341                         // Invariant:
1342                         // There will always be an ownership that has an address and is not burned
1343                         // before an ownership that does not have an address and is not burned.
1344                         // Hence, curr will not underflow.
1345                         //
1346                         // We can directly compare the packed value.
1347                         // If the address is zero, packed is zero.
1348                         while (packed == 0) {
1349                             packed = _packedOwnerships[--curr];
1350                         }
1351                         return packed;
1352                     }
1353                 }
1354         }
1355         revert OwnerQueryForNonexistentToken();
1356     }
1357 
1358     /**
1359      * Returns the unpacked `TokenOwnership` struct from `packed`.
1360      */
1361     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1362         ownership.addr = address(uint160(packed));
1363         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1364         ownership.burned = packed & BITMASK_BURNED != 0;
1365     }
1366 
1367     /**
1368      * Returns the unpacked `TokenOwnership` struct at `index`.
1369      */
1370     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1371         return _unpackedOwnership(_packedOwnerships[index]);
1372     }
1373 
1374     /**
1375      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1376      */
1377     function _initializeOwnershipAt(uint256 index) internal {
1378         if (_packedOwnerships[index] == 0) {
1379             _packedOwnerships[index] = _packedOwnershipOf(index);
1380         }
1381     }
1382 
1383     /**
1384      * Gas spent here starts off proportional to the maximum mint batch size.
1385      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1386      */
1387     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1388         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1389     }
1390 
1391     /**
1392      * @dev See {IERC721-ownerOf}.
1393      */
1394     function ownerOf(uint256 tokenId) public view override returns (address) {
1395         return address(uint160(_packedOwnershipOf(tokenId)));
1396     }
1397 
1398     /**
1399      * @dev See {IERC721Metadata-name}.
1400      */
1401     function name() public view virtual override returns (string memory) {
1402         return _name;
1403     }
1404 
1405     /**
1406      * @dev See {IERC721Metadata-symbol}.
1407      */
1408     function symbol() public view virtual override returns (string memory) {
1409         return _symbol;
1410     }
1411 
1412     /**
1413      * @dev See {IERC721Metadata-tokenURI}.
1414      */
1415     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1416         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1417 
1418         string memory baseURI = _baseURI();
1419         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1420     }
1421 
1422     /**
1423      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1424      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1425      * by default, can be overriden in child contracts.
1426      */
1427     function _baseURI() internal view virtual returns (string memory) {
1428         return '';
1429     }
1430 
1431     /**
1432      * @dev Casts the address to uint256 without masking.
1433      */
1434     function _addressToUint256(address value) private pure returns (uint256 result) {
1435         assembly {
1436             result := value
1437         }
1438     }
1439 
1440     /**
1441      * @dev Casts the boolean to uint256 without branching.
1442      */
1443     function _boolToUint256(bool value) private pure returns (uint256 result) {
1444         assembly {
1445             result := value
1446         }
1447     }
1448 
1449     /**
1450      * @dev See {IERC721-approve}.
1451      */
1452     function approve(address to, uint256 tokenId) public override {
1453         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1454         if (to == owner) revert ApprovalToCurrentOwner();
1455 
1456         if (_msgSenderERC721A() != owner)
1457             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1458                 revert ApprovalCallerNotOwnerNorApproved();
1459             }
1460 
1461         _tokenApprovals[tokenId] = to;
1462         emit Approval(owner, to, tokenId);
1463     }
1464 
1465     /**
1466      * @dev See {IERC721-getApproved}.
1467      */
1468     function getApproved(uint256 tokenId) public view override returns (address) {
1469         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1470 
1471         return _tokenApprovals[tokenId];
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-setApprovalForAll}.
1476      */
1477     function setApprovalForAll(address operator, bool approved) public virtual override {
1478         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1479 
1480         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1481         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1482     }
1483 
1484     /**
1485      * @dev See {IERC721-isApprovedForAll}.
1486      */
1487     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1488         return _operatorApprovals[owner][operator];
1489     }
1490 
1491     /**
1492      * @dev See {IERC721-transferFrom}.
1493      */
1494     function transferFrom(
1495         address from,
1496         address to,
1497         uint256 tokenId
1498     ) public virtual override {
1499         _transfer(from, to, tokenId);
1500     }
1501 
1502     /**
1503      * @dev See {IERC721-safeTransferFrom}.
1504      */
1505     function safeTransferFrom(
1506         address from,
1507         address to,
1508         uint256 tokenId
1509     ) public virtual override {
1510         safeTransferFrom(from, to, tokenId, '');
1511     }
1512 
1513     /**
1514      * @dev See {IERC721-safeTransferFrom}.
1515      */
1516     function safeTransferFrom(
1517         address from,
1518         address to,
1519         uint256 tokenId,
1520         bytes memory _data
1521     ) public virtual override {
1522         _transfer(from, to, tokenId);
1523         if (to.code.length != 0)
1524             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1525                 revert TransferToNonERC721ReceiverImplementer();
1526             }
1527     }
1528 
1529     /**
1530      * @dev Returns whether `tokenId` exists.
1531      *
1532      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1533      *
1534      * Tokens start existing when they are minted (`_mint`),
1535      */
1536     function _exists(uint256 tokenId) internal view returns (bool) {
1537         return
1538             _startTokenId() <= tokenId &&
1539             tokenId < _currentIndex && // If within bounds,
1540             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1541     }
1542 
1543     /**
1544      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1545      */
1546     function _safeMint(address to, uint256 quantity) internal {
1547         _safeMint(to, quantity, '');
1548     }
1549 
1550     /**
1551      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1552      *
1553      * Requirements:
1554      *
1555      * - If `to` refers to a smart contract, it must implement
1556      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1557      * - `quantity` must be greater than 0.
1558      *
1559      * Emits a {Transfer} event.
1560      */
1561     function _safeMint(
1562         address to,
1563         uint256 quantity,
1564         bytes memory _data
1565     ) internal {
1566         uint256 startTokenId = _currentIndex;
1567         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1568         if (quantity == 0) revert MintZeroQuantity();
1569 
1570         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1571 
1572         // Overflows are incredibly unrealistic.
1573         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1574         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1575         unchecked {
1576             // Updates:
1577             // - `balance += quantity`.
1578             // - `numberMinted += quantity`.
1579             //
1580             // We can directly add to the balance and number minted.
1581             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1582 
1583             // Updates:
1584             // - `address` to the owner.
1585             // - `startTimestamp` to the timestamp of minting.
1586             // - `burned` to `false`.
1587             // - `nextInitialized` to `quantity == 1`.
1588             _packedOwnerships[startTokenId] =
1589                 _addressToUint256(to) |
1590                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1591                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1592 
1593             uint256 updatedIndex = startTokenId;
1594             uint256 end = updatedIndex + quantity;
1595 
1596             if (to.code.length != 0) {
1597                 do {
1598                     emit Transfer(address(0), to, updatedIndex);
1599                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1600                         revert TransferToNonERC721ReceiverImplementer();
1601                     }
1602                 } while (updatedIndex < end);
1603                 // Reentrancy protection
1604                 if (_currentIndex != startTokenId) revert();
1605             } else {
1606                 do {
1607                     emit Transfer(address(0), to, updatedIndex++);
1608                 } while (updatedIndex < end);
1609             }
1610             _currentIndex = updatedIndex;
1611         }
1612         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1613     }
1614 
1615     /**
1616      * @dev Mints `quantity` tokens and transfers them to `to`.
1617      *
1618      * Requirements:
1619      *
1620      * - `to` cannot be the zero address.
1621      * - `quantity` must be greater than 0.
1622      *
1623      * Emits a {Transfer} event.
1624      */
1625     function _mint(address to, uint256 quantity) internal {
1626         uint256 startTokenId = _currentIndex;
1627         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1628         if (quantity == 0) revert MintZeroQuantity();
1629 
1630         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1631 
1632         // Overflows are incredibly unrealistic.
1633         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1634         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1635         unchecked {
1636             // Updates:
1637             // - `balance += quantity`.
1638             // - `numberMinted += quantity`.
1639             //
1640             // We can directly add to the balance and number minted.
1641             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1642 
1643             // Updates:
1644             // - `address` to the owner.
1645             // - `startTimestamp` to the timestamp of minting.
1646             // - `burned` to `false`.
1647             // - `nextInitialized` to `quantity == 1`.
1648             _packedOwnerships[startTokenId] =
1649                 _addressToUint256(to) |
1650                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1651                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1652 
1653             uint256 updatedIndex = startTokenId;
1654             uint256 end = updatedIndex + quantity;
1655 
1656             do {
1657                 emit Transfer(address(0), to, updatedIndex++);
1658             } while (updatedIndex < end);
1659 
1660             _currentIndex = updatedIndex;
1661         }
1662         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1663     }
1664 
1665     /**
1666      * @dev Transfers `tokenId` from `from` to `to`.
1667      *
1668      * Requirements:
1669      *
1670      * - `to` cannot be the zero address.
1671      * - `tokenId` token must be owned by `from`.
1672      *
1673      * Emits a {Transfer} event.
1674      */
1675     function _transfer(
1676         address from,
1677         address to,
1678         uint256 tokenId
1679     ) private {
1680         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1681 
1682         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1683 
1684         address approvedAddress = _tokenApprovals[tokenId];
1685 
1686         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1687             isApprovedForAll(from, _msgSenderERC721A()) ||
1688             approvedAddress == _msgSenderERC721A());
1689 
1690         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1691         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1692 
1693         _beforeTokenTransfers(from, to, tokenId, 1);
1694 
1695         // Clear approvals from the previous owner.
1696         if (_addressToUint256(approvedAddress) != 0) {
1697             delete _tokenApprovals[tokenId];
1698         }
1699 
1700         // Underflow of the sender's balance is impossible because we check for
1701         // ownership above and the recipient's balance can't realistically overflow.
1702         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1703         unchecked {
1704             // We can directly increment and decrement the balances.
1705             --_packedAddressData[from]; // Updates: `balance -= 1`.
1706             ++_packedAddressData[to]; // Updates: `balance += 1`.
1707 
1708             // Updates:
1709             // - `address` to the next owner.
1710             // - `startTimestamp` to the timestamp of transfering.
1711             // - `burned` to `false`.
1712             // - `nextInitialized` to `true`.
1713             _packedOwnerships[tokenId] =
1714                 _addressToUint256(to) |
1715                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1716                 BITMASK_NEXT_INITIALIZED;
1717 
1718             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1719             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1720                 uint256 nextTokenId = tokenId + 1;
1721                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1722                 if (_packedOwnerships[nextTokenId] == 0) {
1723                     // If the next slot is within bounds.
1724                     if (nextTokenId != _currentIndex) {
1725                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1726                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1727                     }
1728                 }
1729             }
1730         }
1731 
1732         emit Transfer(from, to, tokenId);
1733         _afterTokenTransfers(from, to, tokenId, 1);
1734     }
1735 
1736     /**
1737      * @dev Equivalent to `_burn(tokenId, false)`.
1738      */
1739     function _burn(uint256 tokenId) internal virtual {
1740         _burn(tokenId, false);
1741     }
1742 
1743     /**
1744      * @dev Destroys `tokenId`.
1745      * The approval is cleared when the token is burned.
1746      *
1747      * Requirements:
1748      *
1749      * - `tokenId` must exist.
1750      *
1751      * Emits a {Transfer} event.
1752      */
1753     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1754         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1755 
1756         address from = address(uint160(prevOwnershipPacked));
1757         address approvedAddress = _tokenApprovals[tokenId];
1758 
1759         if (approvalCheck) {
1760             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1761                 isApprovedForAll(from, _msgSenderERC721A()) ||
1762                 approvedAddress == _msgSenderERC721A());
1763 
1764             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1765         }
1766 
1767         _beforeTokenTransfers(from, address(0), tokenId, 1);
1768 
1769         // Clear approvals from the previous owner.
1770         if (_addressToUint256(approvedAddress) != 0) {
1771             delete _tokenApprovals[tokenId];
1772         }
1773 
1774         // Underflow of the sender's balance is impossible because we check for
1775         // ownership above and the recipient's balance can't realistically overflow.
1776         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1777         unchecked {
1778             // Updates:
1779             // - `balance -= 1`.
1780             // - `numberBurned += 1`.
1781             //
1782             // We can directly decrement the balance, and increment the number burned.
1783             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1784             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1785 
1786             // Updates:
1787             // - `address` to the last owner.
1788             // - `startTimestamp` to the timestamp of burning.
1789             // - `burned` to `true`.
1790             // - `nextInitialized` to `true`.
1791             _packedOwnerships[tokenId] =
1792                 _addressToUint256(from) |
1793                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1794                 BITMASK_BURNED | 
1795                 BITMASK_NEXT_INITIALIZED;
1796 
1797             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1798             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1799                 uint256 nextTokenId = tokenId + 1;
1800                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1801                 if (_packedOwnerships[nextTokenId] == 0) {
1802                     // If the next slot is within bounds.
1803                     if (nextTokenId != _currentIndex) {
1804                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1805                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1806                     }
1807                 }
1808             }
1809         }
1810 
1811         emit Transfer(from, address(0), tokenId);
1812         _afterTokenTransfers(from, address(0), tokenId, 1);
1813 
1814         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1815         unchecked {
1816             _burnCounter++;
1817         }
1818     }
1819 
1820     /**
1821      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1822      *
1823      * @param from address representing the previous owner of the given token ID
1824      * @param to target address that will receive the tokens
1825      * @param tokenId uint256 ID of the token to be transferred
1826      * @param _data bytes optional data to send along with the call
1827      * @return bool whether the call correctly returned the expected magic value
1828      */
1829     function _checkContractOnERC721Received(
1830         address from,
1831         address to,
1832         uint256 tokenId,
1833         bytes memory _data
1834     ) private returns (bool) {
1835         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1836             bytes4 retval
1837         ) {
1838             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1839         } catch (bytes memory reason) {
1840             if (reason.length == 0) {
1841                 revert TransferToNonERC721ReceiverImplementer();
1842             } else {
1843                 assembly {
1844                     revert(add(32, reason), mload(reason))
1845                 }
1846             }
1847         }
1848     }
1849 
1850     /**
1851      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1852      * And also called before burning one token.
1853      *
1854      * startTokenId - the first token id to be transferred
1855      * quantity - the amount to be transferred
1856      *
1857      * Calling conditions:
1858      *
1859      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1860      * transferred to `to`.
1861      * - When `from` is zero, `tokenId` will be minted for `to`.
1862      * - When `to` is zero, `tokenId` will be burned by `from`.
1863      * - `from` and `to` are never both zero.
1864      */
1865     function _beforeTokenTransfers(
1866         address from,
1867         address to,
1868         uint256 startTokenId,
1869         uint256 quantity
1870     ) internal virtual {}
1871 
1872     /**
1873      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1874      * minting.
1875      * And also called after one token has been burned.
1876      *
1877      * startTokenId - the first token id to be transferred
1878      * quantity - the amount to be transferred
1879      *
1880      * Calling conditions:
1881      *
1882      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1883      * transferred to `to`.
1884      * - When `from` is zero, `tokenId` has been minted for `to`.
1885      * - When `to` is zero, `tokenId` has been burned by `from`.
1886      * - `from` and `to` are never both zero.
1887      */
1888     function _afterTokenTransfers(
1889         address from,
1890         address to,
1891         uint256 startTokenId,
1892         uint256 quantity
1893     ) internal virtual {}
1894 
1895     /**
1896      * @dev Returns the message sender (defaults to `msg.sender`).
1897      *
1898      * If you are writing GSN compatible contracts, you need to override this function.
1899      */
1900     function _msgSenderERC721A() internal view virtual returns (address) {
1901         return msg.sender;
1902     }
1903 
1904     /**
1905      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1906      */
1907     function _toString(uint256 value) internal pure returns (string memory ptr) {
1908         assembly {
1909             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1910             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1911             // We will need 1 32-byte word to store the length, 
1912             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1913             ptr := add(mload(0x40), 128)
1914             // Update the free memory pointer to allocate.
1915             mstore(0x40, ptr)
1916 
1917             // Cache the end of the memory to calculate the length later.
1918             let end := ptr
1919 
1920             // We write the string from the rightmost digit to the leftmost digit.
1921             // The following is essentially a do-while loop that also handles the zero case.
1922             // Costs a bit more than early returning for the zero case,
1923             // but cheaper in terms of deployment and overall runtime costs.
1924             for { 
1925                 // Initialize and perform the first pass without check.
1926                 let temp := value
1927                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1928                 ptr := sub(ptr, 1)
1929                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1930                 mstore8(ptr, add(48, mod(temp, 10)))
1931                 temp := div(temp, 10)
1932             } temp { 
1933                 // Keep dividing `temp` until zero.
1934                 temp := div(temp, 10)
1935             } { // Body of the for loop.
1936                 ptr := sub(ptr, 1)
1937                 mstore8(ptr, add(48, mod(temp, 10)))
1938             }
1939             
1940             let length := sub(end, ptr)
1941             // Move the pointer 32 bytes leftwards to make room for the length.
1942             ptr := sub(ptr, 32)
1943             // Store the length.
1944             mstore(ptr, length)
1945         }
1946     }
1947 }
1948 // File: contracts/ninja.sol
1949 
1950 //SPDX-License-Identifier: MIT
1951 // pragma solidity ^0.8.9;
1952 pragma solidity >=0.7.0 <0.9.0;
1953 
1954 
1955 
1956 
1957 
1958 
1959 
1960 contract NinjitSu is ERC721A, Ownable, DefaultOperatorFilterer {
1961     using Strings for uint256;
1962     
1963     uint256 public constant MAX_SUPPLY = 5000;
1964     uint256 public constant P1_SUPPLY = 2500;
1965 
1966     uint256 public phase = 0;
1967 
1968     bytes32 public merkleRoot;
1969 
1970     uint256 public whitelistPrice = 0.0055 ether;
1971     uint256 public publicPrice = 0.0075 ether;
1972     uint256 public maxMintPerTx = 5;
1973     uint256 public maxWLMintPerWallet = 5;
1974     
1975     string public baseURI;
1976 
1977     bool private reveal = false;
1978 
1979     mapping(address => uint) public whitelistMintedTracker;
1980 
1981     constructor() ERC721A("NinjitSu", "NJS") {}
1982 
1983     /**
1984      * @notice token start from id 1
1985      */
1986     function _startTokenId() internal view virtual override returns (uint256) {
1987         return 1;
1988     }
1989 
1990     /**
1991      * @notice team mint
1992      */
1993     function teamMint(address[] memory to, uint quantity) external onlyOwner {
1994         require((to.length * quantity) + totalSupply() <= MAX_SUPPLY, "Sold out");
1995 
1996         for(uint i = 0; i < to.length; i++){
1997             _mint(to[i], quantity);
1998         }
1999     }
2000 
2001     /**
2002      * @notice whitelist mint
2003      */
2004     function whitelistMint(uint quantity, bytes32[] memory proof) external payable {
2005         require(phase == 1, "whitelist is close.");
2006         
2007         require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Not whitelisted.");       
2008         
2009         _mint(quantity);
2010     }
2011 
2012     /**
2013      * @notice public mint
2014      */
2015     function publicMint(uint quantity) external payable {
2016         require(phase == 2 , "Public Sales is close.");
2017         _mint(quantity);
2018     }
2019 
2020     /**
2021      * @notice mint
2022      */
2023     function _mint(uint quantity) internal {
2024 
2025         require(quantity <= maxMintPerTx && quantity > 0, "Hit max mint per transaction.");
2026 
2027         if (phase == 1) {
2028             require(msg.value >= whitelistPrice * quantity, "Not enough ETH to mint");
2029 
2030             require(whitelistMintedTracker[_msgSender()] + quantity <= maxWLMintPerWallet, "Hit the max mint.");
2031 
2032             require(quantity + totalSupply() <= P1_SUPPLY, "P1 Sold out");
2033 
2034             whitelistMintedTracker[_msgSender()] += quantity;
2035         } else if (phase == 2) {
2036             require(msg.value >= publicPrice * quantity, "Not enough ETH to mint");
2037 
2038             require(quantity + totalSupply() <= MAX_SUPPLY, "Total Sold out");
2039         }
2040                 
2041         _mint(_msgSender(), quantity);
2042     }
2043 
2044     /**
2045      * @notice set whitelist merkle root
2046      */
2047     function setMerkleRoot(bytes32 _rootHash) external onlyOwner {
2048         merkleRoot = _rootHash;
2049     }
2050 
2051     /**
2052      * @notice set max mint per transaction
2053      */
2054     function setMaxMintPerTx(uint256 _setMaxTx) external onlyOwner {
2055         maxMintPerTx = _setMaxTx;
2056     }
2057 
2058     /**
2059      * @notice set max mint per wallet
2060      */
2061     function setMaxWLMintPerWallet(uint256 _setMaxWLMint) external onlyOwner {
2062         maxWLMintPerWallet = _setMaxWLMint;
2063     }
2064     
2065     /**
2066      * @notice set whitelist price
2067      */
2068     function setWhitelistPrice(uint256 _price) external onlyOwner {
2069         whitelistPrice = _price;
2070     }
2071 
2072     /**
2073      * @notice set public price
2074      */
2075     function setPublicPrice(uint256 _price) external onlyOwner {
2076         publicPrice = _price;
2077     }
2078 
2079     /**
2080      * @notice set reveal
2081      */
2082     function switchReveal() external onlyOwner {
2083         reveal = !reveal;
2084     }
2085 
2086     /**
2087      * @notice set base uri
2088      */
2089     function setBaseURI(string memory uri) external onlyOwner {
2090         baseURI = uri;
2091     }
2092 
2093     /**
2094      * @notice switch phase 
2095      */
2096     function switchPhase(uint256 phaseNumber) external onlyOwner {
2097         require(phaseNumber >= 0 && phaseNumber < 3 , "Phase out of range 0 - 2");
2098         phase = phaseNumber;
2099     }
2100 
2101     /**
2102      * @notice token URI
2103      */
2104     function tokenURI(uint256 _tokenId)
2105         public
2106         view
2107         virtual
2108         override
2109         returns (string memory)
2110     {
2111         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2112 
2113         if (reveal) {
2114             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _tokenId.toString())) : '';
2115         } else {
2116             return string(abi.encodePacked(baseURI));
2117         }
2118     }
2119 
2120     /**
2121      * @notice transfer funds
2122      */
2123     function withdrawal() external onlyOwner {
2124         uint256 balance = address(this).balance;
2125         payable(msg.sender).transfer(balance);
2126     }
2127 
2128     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2129         super.transferFrom(from, to, tokenId);
2130     }
2131 
2132     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2133         super.safeTransferFrom(from, to, tokenId);
2134     }
2135 
2136     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
2137         super.safeTransferFrom(from, to, tokenId, data);
2138     }
2139 }