1 // SPDX-License-Identifier: UNLICENSED
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
228 // File: @openzeppelin/contracts/utils/math/Math.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @dev Standard math utilities missing in the Solidity language.
237  */
238 library Math {
239     enum Rounding {
240         Down, // Toward negative infinity
241         Up, // Toward infinity
242         Zero // Toward zero
243     }
244 
245     /**
246      * @dev Returns the largest of two numbers.
247      */
248     function max(uint256 a, uint256 b) internal pure returns (uint256) {
249         return a > b ? a : b;
250     }
251 
252     /**
253      * @dev Returns the smallest of two numbers.
254      */
255     function min(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a < b ? a : b;
257     }
258 
259     /**
260      * @dev Returns the average of two numbers. The result is rounded towards
261      * zero.
262      */
263     function average(uint256 a, uint256 b) internal pure returns (uint256) {
264         // (a + b) / 2 can overflow.
265         return (a & b) + (a ^ b) / 2;
266     }
267 
268     /**
269      * @dev Returns the ceiling of the division of two numbers.
270      *
271      * This differs from standard division with `/` in that it rounds up instead
272      * of rounding down.
273      */
274     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
275         // (a + b - 1) / b can overflow on addition, so we distribute.
276         return a == 0 ? 0 : (a - 1) / b + 1;
277     }
278 
279     /**
280      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
281      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
282      * with further edits by Uniswap Labs also under MIT license.
283      */
284     function mulDiv(
285         uint256 x,
286         uint256 y,
287         uint256 denominator
288     ) internal pure returns (uint256 result) {
289         unchecked {
290             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
291             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
292             // variables such that product = prod1 * 2^256 + prod0.
293             uint256 prod0; // Least significant 256 bits of the product
294             uint256 prod1; // Most significant 256 bits of the product
295             assembly {
296                 let mm := mulmod(x, y, not(0))
297                 prod0 := mul(x, y)
298                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
299             }
300 
301             // Handle non-overflow cases, 256 by 256 division.
302             if (prod1 == 0) {
303                 return prod0 / denominator;
304             }
305 
306             // Make sure the result is less than 2^256. Also prevents denominator == 0.
307             require(denominator > prod1);
308 
309             ///////////////////////////////////////////////
310             // 512 by 256 division.
311             ///////////////////////////////////////////////
312 
313             // Make division exact by subtracting the remainder from [prod1 prod0].
314             uint256 remainder;
315             assembly {
316                 // Compute remainder using mulmod.
317                 remainder := mulmod(x, y, denominator)
318 
319                 // Subtract 256 bit number from 512 bit number.
320                 prod1 := sub(prod1, gt(remainder, prod0))
321                 prod0 := sub(prod0, remainder)
322             }
323 
324             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
325             // See https://cs.stackexchange.com/q/138556/92363.
326 
327             // Does not overflow because the denominator cannot be zero at this stage in the function.
328             uint256 twos = denominator & (~denominator + 1);
329             assembly {
330                 // Divide denominator by twos.
331                 denominator := div(denominator, twos)
332 
333                 // Divide [prod1 prod0] by twos.
334                 prod0 := div(prod0, twos)
335 
336                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
337                 twos := add(div(sub(0, twos), twos), 1)
338             }
339 
340             // Shift in bits from prod1 into prod0.
341             prod0 |= prod1 * twos;
342 
343             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
344             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
345             // four bits. That is, denominator * inv = 1 mod 2^4.
346             uint256 inverse = (3 * denominator) ^ 2;
347 
348             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
349             // in modular arithmetic, doubling the correct bits in each step.
350             inverse *= 2 - denominator * inverse; // inverse mod 2^8
351             inverse *= 2 - denominator * inverse; // inverse mod 2^16
352             inverse *= 2 - denominator * inverse; // inverse mod 2^32
353             inverse *= 2 - denominator * inverse; // inverse mod 2^64
354             inverse *= 2 - denominator * inverse; // inverse mod 2^128
355             inverse *= 2 - denominator * inverse; // inverse mod 2^256
356 
357             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
358             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
359             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
360             // is no longer required.
361             result = prod0 * inverse;
362             return result;
363         }
364     }
365 
366     /**
367      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
368      */
369     function mulDiv(
370         uint256 x,
371         uint256 y,
372         uint256 denominator,
373         Rounding rounding
374     ) internal pure returns (uint256) {
375         uint256 result = mulDiv(x, y, denominator);
376         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
377             result += 1;
378         }
379         return result;
380     }
381 
382     /**
383      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
384      *
385      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
386      */
387     function sqrt(uint256 a) internal pure returns (uint256) {
388         if (a == 0) {
389             return 0;
390         }
391 
392         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
393         //
394         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
395         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
396         //
397         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
398         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
399         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
400         //
401         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
402         uint256 result = 1 << (log2(a) >> 1);
403 
404         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
405         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
406         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
407         // into the expected uint128 result.
408         unchecked {
409             result = (result + a / result) >> 1;
410             result = (result + a / result) >> 1;
411             result = (result + a / result) >> 1;
412             result = (result + a / result) >> 1;
413             result = (result + a / result) >> 1;
414             result = (result + a / result) >> 1;
415             result = (result + a / result) >> 1;
416             return min(result, a / result);
417         }
418     }
419 
420     /**
421      * @notice Calculates sqrt(a), following the selected rounding direction.
422      */
423     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
424         unchecked {
425             uint256 result = sqrt(a);
426             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
427         }
428     }
429 
430     /**
431      * @dev Return the log in base 2, rounded down, of a positive value.
432      * Returns 0 if given 0.
433      */
434     function log2(uint256 value) internal pure returns (uint256) {
435         uint256 result = 0;
436         unchecked {
437             if (value >> 128 > 0) {
438                 value >>= 128;
439                 result += 128;
440             }
441             if (value >> 64 > 0) {
442                 value >>= 64;
443                 result += 64;
444             }
445             if (value >> 32 > 0) {
446                 value >>= 32;
447                 result += 32;
448             }
449             if (value >> 16 > 0) {
450                 value >>= 16;
451                 result += 16;
452             }
453             if (value >> 8 > 0) {
454                 value >>= 8;
455                 result += 8;
456             }
457             if (value >> 4 > 0) {
458                 value >>= 4;
459                 result += 4;
460             }
461             if (value >> 2 > 0) {
462                 value >>= 2;
463                 result += 2;
464             }
465             if (value >> 1 > 0) {
466                 result += 1;
467             }
468         }
469         return result;
470     }
471 
472     /**
473      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
474      * Returns 0 if given 0.
475      */
476     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
477         unchecked {
478             uint256 result = log2(value);
479             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
480         }
481     }
482 
483     /**
484      * @dev Return the log in base 10, rounded down, of a positive value.
485      * Returns 0 if given 0.
486      */
487     function log10(uint256 value) internal pure returns (uint256) {
488         uint256 result = 0;
489         unchecked {
490             if (value >= 10**64) {
491                 value /= 10**64;
492                 result += 64;
493             }
494             if (value >= 10**32) {
495                 value /= 10**32;
496                 result += 32;
497             }
498             if (value >= 10**16) {
499                 value /= 10**16;
500                 result += 16;
501             }
502             if (value >= 10**8) {
503                 value /= 10**8;
504                 result += 8;
505             }
506             if (value >= 10**4) {
507                 value /= 10**4;
508                 result += 4;
509             }
510             if (value >= 10**2) {
511                 value /= 10**2;
512                 result += 2;
513             }
514             if (value >= 10**1) {
515                 result += 1;
516             }
517         }
518         return result;
519     }
520 
521     /**
522      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
523      * Returns 0 if given 0.
524      */
525     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
526         unchecked {
527             uint256 result = log10(value);
528             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
529         }
530     }
531 
532     /**
533      * @dev Return the log in base 256, rounded down, of a positive value.
534      * Returns 0 if given 0.
535      *
536      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
537      */
538     function log256(uint256 value) internal pure returns (uint256) {
539         uint256 result = 0;
540         unchecked {
541             if (value >> 128 > 0) {
542                 value >>= 128;
543                 result += 16;
544             }
545             if (value >> 64 > 0) {
546                 value >>= 64;
547                 result += 8;
548             }
549             if (value >> 32 > 0) {
550                 value >>= 32;
551                 result += 4;
552             }
553             if (value >> 16 > 0) {
554                 value >>= 16;
555                 result += 2;
556             }
557             if (value >> 8 > 0) {
558                 result += 1;
559             }
560         }
561         return result;
562     }
563 
564     /**
565      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
566      * Returns 0 if given 0.
567      */
568     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
569         unchecked {
570             uint256 result = log256(value);
571             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
572         }
573     }
574 }
575 
576 // File: @openzeppelin/contracts/utils/Strings.sol
577 
578 
579 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 
584 /**
585  * @dev String operations.
586  */
587 library Strings {
588     bytes16 private constant _SYMBOLS = "0123456789abcdef";
589     uint8 private constant _ADDRESS_LENGTH = 20;
590 
591     /**
592      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
593      */
594     function toString(uint256 value) internal pure returns (string memory) {
595         unchecked {
596             uint256 length = Math.log10(value) + 1;
597             string memory buffer = new string(length);
598             uint256 ptr;
599             /// @solidity memory-safe-assembly
600             assembly {
601                 ptr := add(buffer, add(32, length))
602             }
603             while (true) {
604                 ptr--;
605                 /// @solidity memory-safe-assembly
606                 assembly {
607                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
608                 }
609                 value /= 10;
610                 if (value == 0) break;
611             }
612             return buffer;
613         }
614     }
615 
616     /**
617      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
618      */
619     function toHexString(uint256 value) internal pure returns (string memory) {
620         unchecked {
621             return toHexString(value, Math.log256(value) + 1);
622         }
623     }
624 
625     /**
626      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
627      */
628     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
629         bytes memory buffer = new bytes(2 * length + 2);
630         buffer[0] = "0";
631         buffer[1] = "x";
632         for (uint256 i = 2 * length + 1; i > 1; --i) {
633             buffer[i] = _SYMBOLS[value & 0xf];
634             value >>= 4;
635         }
636         require(value == 0, "Strings: hex length insufficient");
637         return string(buffer);
638     }
639 
640     /**
641      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
642      */
643     function toHexString(address addr) internal pure returns (string memory) {
644         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
645     }
646 }
647 
648 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
649 
650 
651 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 /**
656  * @dev Contract module that helps prevent reentrant calls to a function.
657  *
658  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
659  * available, which can be applied to functions to make sure there are no nested
660  * (reentrant) calls to them.
661  *
662  * Note that because there is a single `nonReentrant` guard, functions marked as
663  * `nonReentrant` may not call one another. This can be worked around by making
664  * those functions `private`, and then adding `external` `nonReentrant` entry
665  * points to them.
666  *
667  * TIP: If you would like to learn more about reentrancy and alternative ways
668  * to protect against it, check out our blog post
669  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
670  */
671 abstract contract ReentrancyGuard {
672     // Booleans are more expensive than uint256 or any type that takes up a full
673     // word because each write operation emits an extra SLOAD to first read the
674     // slot's contents, replace the bits taken up by the boolean, and then write
675     // back. This is the compiler's defense against contract upgrades and
676     // pointer aliasing, and it cannot be disabled.
677 
678     // The values being non-zero value makes deployment a bit more expensive,
679     // but in exchange the refund on every call to nonReentrant will be lower in
680     // amount. Since refunds are capped to a percentage of the total
681     // transaction's gas, it is best to keep them low in cases like this one, to
682     // increase the likelihood of the full refund coming into effect.
683     uint256 private constant _NOT_ENTERED = 1;
684     uint256 private constant _ENTERED = 2;
685 
686     uint256 private _status;
687 
688     constructor() {
689         _status = _NOT_ENTERED;
690     }
691 
692     /**
693      * @dev Prevents a contract from calling itself, directly or indirectly.
694      * Calling a `nonReentrant` function from another `nonReentrant`
695      * function is not supported. It is possible to prevent this from happening
696      * by making the `nonReentrant` function external, and making it call a
697      * `private` function that does the actual work.
698      */
699     modifier nonReentrant() {
700         _nonReentrantBefore();
701         _;
702         _nonReentrantAfter();
703     }
704 
705     function _nonReentrantBefore() private {
706         // On the first call to nonReentrant, _status will be _NOT_ENTERED
707         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
708 
709         // Any calls to nonReentrant after this point will fail
710         _status = _ENTERED;
711     }
712 
713     function _nonReentrantAfter() private {
714         // By storing the original value once again, a refund is triggered (see
715         // https://eips.ethereum.org/EIPS/eip-2200)
716         _status = _NOT_ENTERED;
717     }
718 }
719 
720 // File: @openzeppelin/contracts/utils/Context.sol
721 
722 
723 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 /**
728  * @dev Provides information about the current execution context, including the
729  * sender of the transaction and its data. While these are generally available
730  * via msg.sender and msg.data, they should not be accessed in such a direct
731  * manner, since when dealing with meta-transactions the account sending and
732  * paying for execution may not be the actual sender (as far as an application
733  * is concerned).
734  *
735  * This contract is only required for intermediate, library-like contracts.
736  */
737 abstract contract Context {
738     function _msgSender() internal view virtual returns (address) {
739         return msg.sender;
740     }
741 
742     function _msgData() internal view virtual returns (bytes calldata) {
743         return msg.data;
744     }
745 }
746 
747 // File: @openzeppelin/contracts/access/Ownable.sol
748 
749 
750 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
751 
752 pragma solidity ^0.8.0;
753 
754 
755 /**
756  * @dev Contract module which provides a basic access control mechanism, where
757  * there is an account (an owner) that can be granted exclusive access to
758  * specific functions.
759  *
760  * By default, the owner account will be the one that deploys the contract. This
761  * can later be changed with {transferOwnership}.
762  *
763  * This module is used through inheritance. It will make available the modifier
764  * `onlyOwner`, which can be applied to your functions to restrict their use to
765  * the owner.
766  */
767 abstract contract Ownable is Context {
768     address private _owner;
769 
770     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
771 
772     /**
773      * @dev Initializes the contract setting the deployer as the initial owner.
774      */
775     constructor() {
776         _transferOwnership(_msgSender());
777     }
778 
779     /**
780      * @dev Throws if called by any account other than the owner.
781      */
782     modifier onlyOwner() {
783         _checkOwner();
784         _;
785     }
786 
787     /**
788      * @dev Returns the address of the current owner.
789      */
790     function owner() public view virtual returns (address) {
791         return _owner;
792     }
793 
794     /**
795      * @dev Throws if the sender is not the owner.
796      */
797     function _checkOwner() internal view virtual {
798         require(owner() == _msgSender(), "Ownable: caller is not the owner");
799     }
800 
801     /**
802      * @dev Leaves the contract without owner. It will not be possible to call
803      * `onlyOwner` functions anymore. Can only be called by the current owner.
804      *
805      * NOTE: Renouncing ownership will leave the contract without an owner,
806      * thereby removing any functionality that is only available to the owner.
807      */
808     function renounceOwnership() public virtual onlyOwner {
809         _transferOwnership(address(0));
810     }
811 
812     /**
813      * @dev Transfers ownership of the contract to a new account (`newOwner`).
814      * Can only be called by the current owner.
815      */
816     function transferOwnership(address newOwner) public virtual onlyOwner {
817         require(newOwner != address(0), "Ownable: new owner is the zero address");
818         _transferOwnership(newOwner);
819     }
820 
821     /**
822      * @dev Transfers ownership of the contract to a new account (`newOwner`).
823      * Internal function without access restriction.
824      */
825     function _transferOwnership(address newOwner) internal virtual {
826         address oldOwner = _owner;
827         _owner = newOwner;
828         emit OwnershipTransferred(oldOwner, newOwner);
829     }
830 }
831 
832 // File: erc721a/contracts/IERC721A.sol
833 
834 
835 // ERC721A Contracts v4.2.3
836 // Creator: Chiru Labs
837 
838 pragma solidity ^0.8.4;
839 
840 /**
841  * @dev Interface of ERC721A.
842  */
843 interface IERC721A {
844     /**
845      * The caller must own the token or be an approved operator.
846      */
847     error ApprovalCallerNotOwnerNorApproved();
848 
849     /**
850      * The token does not exist.
851      */
852     error ApprovalQueryForNonexistentToken();
853 
854     /**
855      * Cannot query the balance for the zero address.
856      */
857     error BalanceQueryForZeroAddress();
858 
859     /**
860      * Cannot mint to the zero address.
861      */
862     error MintToZeroAddress();
863 
864     /**
865      * The quantity of tokens minted must be more than zero.
866      */
867     error MintZeroQuantity();
868 
869     /**
870      * The token does not exist.
871      */
872     error OwnerQueryForNonexistentToken();
873 
874     /**
875      * The caller must own the token or be an approved operator.
876      */
877     error TransferCallerNotOwnerNorApproved();
878 
879     /**
880      * The token must be owned by `from`.
881      */
882     error TransferFromIncorrectOwner();
883 
884     /**
885      * Cannot safely transfer to a contract that does not implement the
886      * ERC721Receiver interface.
887      */
888     error TransferToNonERC721ReceiverImplementer();
889 
890     /**
891      * Cannot transfer to the zero address.
892      */
893     error TransferToZeroAddress();
894 
895     /**
896      * The token does not exist.
897      */
898     error URIQueryForNonexistentToken();
899 
900     /**
901      * The `quantity` minted with ERC2309 exceeds the safety limit.
902      */
903     error MintERC2309QuantityExceedsLimit();
904 
905     /**
906      * The `extraData` cannot be set on an unintialized ownership slot.
907      */
908     error OwnershipNotInitializedForExtraData();
909 
910     // =============================================================
911     //                            STRUCTS
912     // =============================================================
913 
914     struct TokenOwnership {
915         // The address of the owner.
916         address addr;
917         // Stores the start time of ownership with minimal overhead for tokenomics.
918         uint64 startTimestamp;
919         // Whether the token has been burned.
920         bool burned;
921         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
922         uint24 extraData;
923     }
924 
925     // =============================================================
926     //                         TOKEN COUNTERS
927     // =============================================================
928 
929     /**
930      * @dev Returns the total number of tokens in existence.
931      * Burned tokens will reduce the count.
932      * To get the total number of tokens minted, please see {_totalMinted}.
933      */
934     function totalSupply() external view returns (uint256);
935 
936     // =============================================================
937     //                            IERC165
938     // =============================================================
939 
940     /**
941      * @dev Returns true if this contract implements the interface defined by
942      * `interfaceId`. See the corresponding
943      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
944      * to learn more about how these ids are created.
945      *
946      * This function call must use less than 30000 gas.
947      */
948     function supportsInterface(bytes4 interfaceId) external view returns (bool);
949 
950     // =============================================================
951     //                            IERC721
952     // =============================================================
953 
954     /**
955      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
956      */
957     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
958 
959     /**
960      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
961      */
962     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
963 
964     /**
965      * @dev Emitted when `owner` enables or disables
966      * (`approved`) `operator` to manage all of its assets.
967      */
968     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
969 
970     /**
971      * @dev Returns the number of tokens in `owner`'s account.
972      */
973     function balanceOf(address owner) external view returns (uint256 balance);
974 
975     /**
976      * @dev Returns the owner of the `tokenId` token.
977      *
978      * Requirements:
979      *
980      * - `tokenId` must exist.
981      */
982     function ownerOf(uint256 tokenId) external view returns (address owner);
983 
984     /**
985      * @dev Safely transfers `tokenId` token from `from` to `to`,
986      * checking first that contract recipients are aware of the ERC721 protocol
987      * to prevent tokens from being forever locked.
988      *
989      * Requirements:
990      *
991      * - `from` cannot be the zero address.
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must exist and be owned by `from`.
994      * - If the caller is not `from`, it must be have been allowed to move
995      * this token by either {approve} or {setApprovalForAll}.
996      * - If `to` refers to a smart contract, it must implement
997      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function safeTransferFrom(
1002         address from,
1003         address to,
1004         uint256 tokenId,
1005         bytes calldata data
1006     ) external payable;
1007 
1008     /**
1009      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1010      */
1011     function safeTransferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) external payable;
1016 
1017     /**
1018      * @dev Transfers `tokenId` from `from` to `to`.
1019      *
1020      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1021      * whenever possible.
1022      *
1023      * Requirements:
1024      *
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      * - If the caller is not `from`, it must be approved to move this token
1029      * by either {approve} or {setApprovalForAll}.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function transferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) external payable;
1038 
1039     /**
1040      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1041      * The approval is cleared when the token is transferred.
1042      *
1043      * Only a single account can be approved at a time, so approving the
1044      * zero address clears previous approvals.
1045      *
1046      * Requirements:
1047      *
1048      * - The caller must own the token or be an approved operator.
1049      * - `tokenId` must exist.
1050      *
1051      * Emits an {Approval} event.
1052      */
1053     function approve(address to, uint256 tokenId) external payable;
1054 
1055     /**
1056      * @dev Approve or remove `operator` as an operator for the caller.
1057      * Operators can call {transferFrom} or {safeTransferFrom}
1058      * for any token owned by the caller.
1059      *
1060      * Requirements:
1061      *
1062      * - The `operator` cannot be the caller.
1063      *
1064      * Emits an {ApprovalForAll} event.
1065      */
1066     function setApprovalForAll(address operator, bool _approved) external;
1067 
1068     /**
1069      * @dev Returns the account approved for `tokenId` token.
1070      *
1071      * Requirements:
1072      *
1073      * - `tokenId` must exist.
1074      */
1075     function getApproved(uint256 tokenId) external view returns (address operator);
1076 
1077     /**
1078      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1079      *
1080      * See {setApprovalForAll}.
1081      */
1082     function isApprovedForAll(address owner, address operator) external view returns (bool);
1083 
1084     // =============================================================
1085     //                        IERC721Metadata
1086     // =============================================================
1087 
1088     /**
1089      * @dev Returns the token collection name.
1090      */
1091     function name() external view returns (string memory);
1092 
1093     /**
1094      * @dev Returns the token collection symbol.
1095      */
1096     function symbol() external view returns (string memory);
1097 
1098     /**
1099      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1100      */
1101     function tokenURI(uint256 tokenId) external view returns (string memory);
1102 
1103     // =============================================================
1104     //                           IERC2309
1105     // =============================================================
1106 
1107     /**
1108      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1109      * (inclusive) is transferred from `from` to `to`, as defined in the
1110      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1111      *
1112      * See {_mintERC2309} for more details.
1113      */
1114     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1115 }
1116 
1117 // File: erc721a/contracts/ERC721A.sol
1118 
1119 
1120 // ERC721A Contracts v4.2.3
1121 // Creator: Chiru Labs
1122 
1123 pragma solidity ^0.8.4;
1124 
1125 
1126 /**
1127  * @dev Interface of ERC721 token receiver.
1128  */
1129 interface ERC721A__IERC721Receiver {
1130     function onERC721Received(
1131         address operator,
1132         address from,
1133         uint256 tokenId,
1134         bytes calldata data
1135     ) external returns (bytes4);
1136 }
1137 
1138 /**
1139  * @title ERC721A
1140  *
1141  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1142  * Non-Fungible Token Standard, including the Metadata extension.
1143  * Optimized for lower gas during batch mints.
1144  *
1145  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1146  * starting from `_startTokenId()`.
1147  *
1148  * Assumptions:
1149  *
1150  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1151  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1152  */
1153 contract ERC721A is IERC721A {
1154     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1155     struct TokenApprovalRef {
1156         address value;
1157     }
1158 
1159     // =============================================================
1160     //                           CONSTANTS
1161     // =============================================================
1162 
1163     // Mask of an entry in packed address data.
1164     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1165 
1166     // The bit position of `numberMinted` in packed address data.
1167     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1168 
1169     // The bit position of `numberBurned` in packed address data.
1170     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1171 
1172     // The bit position of `aux` in packed address data.
1173     uint256 private constant _BITPOS_AUX = 192;
1174 
1175     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1176     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1177 
1178     // The bit position of `startTimestamp` in packed ownership.
1179     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1180 
1181     // The bit mask of the `burned` bit in packed ownership.
1182     uint256 private constant _BITMASK_BURNED = 1 << 224;
1183 
1184     // The bit position of the `nextInitialized` bit in packed ownership.
1185     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1186 
1187     // The bit mask of the `nextInitialized` bit in packed ownership.
1188     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1189 
1190     // The bit position of `extraData` in packed ownership.
1191     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1192 
1193     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1194     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1195 
1196     // The mask of the lower 160 bits for addresses.
1197     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1198 
1199     // The maximum `quantity` that can be minted with {_mintERC2309}.
1200     // This limit is to prevent overflows on the address data entries.
1201     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1202     // is required to cause an overflow, which is unrealistic.
1203     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1204 
1205     // The `Transfer` event signature is given by:
1206     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1207     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1208         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1209 
1210     // =============================================================
1211     //                            STORAGE
1212     // =============================================================
1213 
1214     // The next token ID to be minted.
1215     uint256 private _currentIndex;
1216 
1217     // The number of tokens burned.
1218     uint256 private _burnCounter;
1219 
1220     // Token name
1221     string private _name;
1222 
1223     // Token symbol
1224     string private _symbol;
1225 
1226     // Mapping from token ID to ownership details
1227     // An empty struct value does not necessarily mean the token is unowned.
1228     // See {_packedOwnershipOf} implementation for details.
1229     //
1230     // Bits Layout:
1231     // - [0..159]   `addr`
1232     // - [160..223] `startTimestamp`
1233     // - [224]      `burned`
1234     // - [225]      `nextInitialized`
1235     // - [232..255] `extraData`
1236     mapping(uint256 => uint256) private _packedOwnerships;
1237 
1238     // Mapping owner address to address data.
1239     //
1240     // Bits Layout:
1241     // - [0..63]    `balance`
1242     // - [64..127]  `numberMinted`
1243     // - [128..191] `numberBurned`
1244     // - [192..255] `aux`
1245     mapping(address => uint256) private _packedAddressData;
1246 
1247     // Mapping from token ID to approved address.
1248     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1249 
1250     // Mapping from owner to operator approvals
1251     mapping(address => mapping(address => bool)) private _operatorApprovals;
1252 
1253     // =============================================================
1254     //                          CONSTRUCTOR
1255     // =============================================================
1256 
1257     constructor(string memory name_, string memory symbol_) {
1258         _name = name_;
1259         _symbol = symbol_;
1260         _currentIndex = _startTokenId();
1261     }
1262 
1263     // =============================================================
1264     //                   TOKEN COUNTING OPERATIONS
1265     // =============================================================
1266 
1267     /**
1268      * @dev Returns the starting token ID.
1269      * To change the starting token ID, please override this function.
1270      */
1271     function _startTokenId() internal view virtual returns (uint256) {
1272         return 0;
1273     }
1274 
1275     /**
1276      * @dev Returns the next token ID to be minted.
1277      */
1278     function _nextTokenId() internal view virtual returns (uint256) {
1279         return _currentIndex;
1280     }
1281 
1282     /**
1283      * @dev Returns the total number of tokens in existence.
1284      * Burned tokens will reduce the count.
1285      * To get the total number of tokens minted, please see {_totalMinted}.
1286      */
1287     function totalSupply() public view virtual override returns (uint256) {
1288         // Counter underflow is impossible as _burnCounter cannot be incremented
1289         // more than `_currentIndex - _startTokenId()` times.
1290         unchecked {
1291             return _currentIndex - _burnCounter - _startTokenId();
1292         }
1293     }
1294 
1295     /**
1296      * @dev Returns the total amount of tokens minted in the contract.
1297      */
1298     function _totalMinted() internal view virtual returns (uint256) {
1299         // Counter underflow is impossible as `_currentIndex` does not decrement,
1300         // and it is initialized to `_startTokenId()`.
1301         unchecked {
1302             return _currentIndex - _startTokenId();
1303         }
1304     }
1305 
1306     /**
1307      * @dev Returns the total number of tokens burned.
1308      */
1309     function _totalBurned() internal view virtual returns (uint256) {
1310         return _burnCounter;
1311     }
1312 
1313     // =============================================================
1314     //                    ADDRESS DATA OPERATIONS
1315     // =============================================================
1316 
1317     /**
1318      * @dev Returns the number of tokens in `owner`'s account.
1319      */
1320     function balanceOf(address owner) public view virtual override returns (uint256) {
1321         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1322         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1323     }
1324 
1325     /**
1326      * Returns the number of tokens minted by `owner`.
1327      */
1328     function _numberMinted(address owner) internal view returns (uint256) {
1329         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1330     }
1331 
1332     /**
1333      * Returns the number of tokens burned by or on behalf of `owner`.
1334      */
1335     function _numberBurned(address owner) internal view returns (uint256) {
1336         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1337     }
1338 
1339     /**
1340      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1341      */
1342     function _getAux(address owner) internal view returns (uint64) {
1343         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1344     }
1345 
1346     /**
1347      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1348      * If there are multiple variables, please pack them into a uint64.
1349      */
1350     function _setAux(address owner, uint64 aux) internal virtual {
1351         uint256 packed = _packedAddressData[owner];
1352         uint256 auxCasted;
1353         // Cast `aux` with assembly to avoid redundant masking.
1354         assembly {
1355             auxCasted := aux
1356         }
1357         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1358         _packedAddressData[owner] = packed;
1359     }
1360 
1361     // =============================================================
1362     //                            IERC165
1363     // =============================================================
1364 
1365     /**
1366      * @dev Returns true if this contract implements the interface defined by
1367      * `interfaceId`. See the corresponding
1368      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1369      * to learn more about how these ids are created.
1370      *
1371      * This function call must use less than 30000 gas.
1372      */
1373     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1374         // The interface IDs are constants representing the first 4 bytes
1375         // of the XOR of all function selectors in the interface.
1376         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1377         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1378         return
1379             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1380             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1381             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1382     }
1383 
1384     // =============================================================
1385     //                        IERC721Metadata
1386     // =============================================================
1387 
1388     /**
1389      * @dev Returns the token collection name.
1390      */
1391     function name() public view virtual override returns (string memory) {
1392         return _name;
1393     }
1394 
1395     /**
1396      * @dev Returns the token collection symbol.
1397      */
1398     function symbol() public view virtual override returns (string memory) {
1399         return _symbol;
1400     }
1401 
1402     /**
1403      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1404      */
1405     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1406         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1407 
1408         string memory baseURI = _baseURI();
1409         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1410     }
1411 
1412     /**
1413      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1414      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1415      * by default, it can be overridden in child contracts.
1416      */
1417     function _baseURI() internal view virtual returns (string memory) {
1418         return '';
1419     }
1420 
1421     // =============================================================
1422     //                     OWNERSHIPS OPERATIONS
1423     // =============================================================
1424 
1425     /**
1426      * @dev Returns the owner of the `tokenId` token.
1427      *
1428      * Requirements:
1429      *
1430      * - `tokenId` must exist.
1431      */
1432     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1433         return address(uint160(_packedOwnershipOf(tokenId)));
1434     }
1435 
1436     /**
1437      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1438      * It gradually moves to O(1) as tokens get transferred around over time.
1439      */
1440     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1441         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1442     }
1443 
1444     /**
1445      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1446      */
1447     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1448         return _unpackedOwnership(_packedOwnerships[index]);
1449     }
1450 
1451     /**
1452      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1453      */
1454     function _initializeOwnershipAt(uint256 index) internal virtual {
1455         if (_packedOwnerships[index] == 0) {
1456             _packedOwnerships[index] = _packedOwnershipOf(index);
1457         }
1458     }
1459 
1460     /**
1461      * Returns the packed ownership data of `tokenId`.
1462      */
1463     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1464         uint256 curr = tokenId;
1465 
1466         unchecked {
1467             if (_startTokenId() <= curr)
1468                 if (curr < _currentIndex) {
1469                     uint256 packed = _packedOwnerships[curr];
1470                     // If not burned.
1471                     if (packed & _BITMASK_BURNED == 0) {
1472                         // Invariant:
1473                         // There will always be an initialized ownership slot
1474                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1475                         // before an unintialized ownership slot
1476                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1477                         // Hence, `curr` will not underflow.
1478                         //
1479                         // We can directly compare the packed value.
1480                         // If the address is zero, packed will be zero.
1481                         while (packed == 0) {
1482                             packed = _packedOwnerships[--curr];
1483                         }
1484                         return packed;
1485                     }
1486                 }
1487         }
1488         revert OwnerQueryForNonexistentToken();
1489     }
1490 
1491     /**
1492      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1493      */
1494     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1495         ownership.addr = address(uint160(packed));
1496         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1497         ownership.burned = packed & _BITMASK_BURNED != 0;
1498         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1499     }
1500 
1501     /**
1502      * @dev Packs ownership data into a single uint256.
1503      */
1504     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1505         assembly {
1506             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1507             owner := and(owner, _BITMASK_ADDRESS)
1508             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1509             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1510         }
1511     }
1512 
1513     /**
1514      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1515      */
1516     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1517         // For branchless setting of the `nextInitialized` flag.
1518         assembly {
1519             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1520             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1521         }
1522     }
1523 
1524     // =============================================================
1525     //                      APPROVAL OPERATIONS
1526     // =============================================================
1527 
1528     /**
1529      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1530      * The approval is cleared when the token is transferred.
1531      *
1532      * Only a single account can be approved at a time, so approving the
1533      * zero address clears previous approvals.
1534      *
1535      * Requirements:
1536      *
1537      * - The caller must own the token or be an approved operator.
1538      * - `tokenId` must exist.
1539      *
1540      * Emits an {Approval} event.
1541      */
1542     function approve(address to, uint256 tokenId) public payable virtual override {
1543         address owner = ownerOf(tokenId);
1544 
1545         if (_msgSenderERC721A() != owner)
1546             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1547                 revert ApprovalCallerNotOwnerNorApproved();
1548             }
1549 
1550         _tokenApprovals[tokenId].value = to;
1551         emit Approval(owner, to, tokenId);
1552     }
1553 
1554     /**
1555      * @dev Returns the account approved for `tokenId` token.
1556      *
1557      * Requirements:
1558      *
1559      * - `tokenId` must exist.
1560      */
1561     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1562         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1563 
1564         return _tokenApprovals[tokenId].value;
1565     }
1566 
1567     /**
1568      * @dev Approve or remove `operator` as an operator for the caller.
1569      * Operators can call {transferFrom} or {safeTransferFrom}
1570      * for any token owned by the caller.
1571      *
1572      * Requirements:
1573      *
1574      * - The `operator` cannot be the caller.
1575      *
1576      * Emits an {ApprovalForAll} event.
1577      */
1578     function setApprovalForAll(address operator, bool approved) public virtual override {
1579         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1580         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1581     }
1582 
1583     /**
1584      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1585      *
1586      * See {setApprovalForAll}.
1587      */
1588     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1589         return _operatorApprovals[owner][operator];
1590     }
1591 
1592     /**
1593      * @dev Returns whether `tokenId` exists.
1594      *
1595      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1596      *
1597      * Tokens start existing when they are minted. See {_mint}.
1598      */
1599     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1600         return
1601             _startTokenId() <= tokenId &&
1602             tokenId < _currentIndex && // If within bounds,
1603             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1604     }
1605 
1606     /**
1607      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1608      */
1609     function _isSenderApprovedOrOwner(
1610         address approvedAddress,
1611         address owner,
1612         address msgSender
1613     ) private pure returns (bool result) {
1614         assembly {
1615             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1616             owner := and(owner, _BITMASK_ADDRESS)
1617             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1618             msgSender := and(msgSender, _BITMASK_ADDRESS)
1619             // `msgSender == owner || msgSender == approvedAddress`.
1620             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1621         }
1622     }
1623 
1624     /**
1625      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1626      */
1627     function _getApprovedSlotAndAddress(uint256 tokenId)
1628         private
1629         view
1630         returns (uint256 approvedAddressSlot, address approvedAddress)
1631     {
1632         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1633         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1634         assembly {
1635             approvedAddressSlot := tokenApproval.slot
1636             approvedAddress := sload(approvedAddressSlot)
1637         }
1638     }
1639 
1640     // =============================================================
1641     //                      TRANSFER OPERATIONS
1642     // =============================================================
1643 
1644     /**
1645      * @dev Transfers `tokenId` from `from` to `to`.
1646      *
1647      * Requirements:
1648      *
1649      * - `from` cannot be the zero address.
1650      * - `to` cannot be the zero address.
1651      * - `tokenId` token must be owned by `from`.
1652      * - If the caller is not `from`, it must be approved to move this token
1653      * by either {approve} or {setApprovalForAll}.
1654      *
1655      * Emits a {Transfer} event.
1656      */
1657     function transferFrom(
1658         address from,
1659         address to,
1660         uint256 tokenId
1661     ) public payable virtual override {
1662         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1663 
1664         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1665 
1666         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1667 
1668         // The nested ifs save around 20+ gas over a compound boolean condition.
1669         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1670             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1671 
1672         if (to == address(0)) revert TransferToZeroAddress();
1673 
1674         _beforeTokenTransfers(from, to, tokenId, 1);
1675 
1676         // Clear approvals from the previous owner.
1677         assembly {
1678             if approvedAddress {
1679                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1680                 sstore(approvedAddressSlot, 0)
1681             }
1682         }
1683 
1684         // Underflow of the sender's balance is impossible because we check for
1685         // ownership above and the recipient's balance can't realistically overflow.
1686         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1687         unchecked {
1688             // We can directly increment and decrement the balances.
1689             --_packedAddressData[from]; // Updates: `balance -= 1`.
1690             ++_packedAddressData[to]; // Updates: `balance += 1`.
1691 
1692             // Updates:
1693             // - `address` to the next owner.
1694             // - `startTimestamp` to the timestamp of transfering.
1695             // - `burned` to `false`.
1696             // - `nextInitialized` to `true`.
1697             _packedOwnerships[tokenId] = _packOwnershipData(
1698                 to,
1699                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1700             );
1701 
1702             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1703             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1704                 uint256 nextTokenId = tokenId + 1;
1705                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1706                 if (_packedOwnerships[nextTokenId] == 0) {
1707                     // If the next slot is within bounds.
1708                     if (nextTokenId != _currentIndex) {
1709                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1710                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1711                     }
1712                 }
1713             }
1714         }
1715 
1716         emit Transfer(from, to, tokenId);
1717         _afterTokenTransfers(from, to, tokenId, 1);
1718     }
1719 
1720     /**
1721      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1722      */
1723     function safeTransferFrom(
1724         address from,
1725         address to,
1726         uint256 tokenId
1727     ) public payable virtual override {
1728         safeTransferFrom(from, to, tokenId, '');
1729     }
1730 
1731     /**
1732      * @dev Safely transfers `tokenId` token from `from` to `to`.
1733      *
1734      * Requirements:
1735      *
1736      * - `from` cannot be the zero address.
1737      * - `to` cannot be the zero address.
1738      * - `tokenId` token must exist and be owned by `from`.
1739      * - If the caller is not `from`, it must be approved to move this token
1740      * by either {approve} or {setApprovalForAll}.
1741      * - If `to` refers to a smart contract, it must implement
1742      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1743      *
1744      * Emits a {Transfer} event.
1745      */
1746     function safeTransferFrom(
1747         address from,
1748         address to,
1749         uint256 tokenId,
1750         bytes memory _data
1751     ) public payable virtual override {
1752         transferFrom(from, to, tokenId);
1753         if (to.code.length != 0)
1754             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1755                 revert TransferToNonERC721ReceiverImplementer();
1756             }
1757     }
1758 
1759     /**
1760      * @dev Hook that is called before a set of serially-ordered token IDs
1761      * are about to be transferred. This includes minting.
1762      * And also called before burning one token.
1763      *
1764      * `startTokenId` - the first token ID to be transferred.
1765      * `quantity` - the amount to be transferred.
1766      *
1767      * Calling conditions:
1768      *
1769      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1770      * transferred to `to`.
1771      * - When `from` is zero, `tokenId` will be minted for `to`.
1772      * - When `to` is zero, `tokenId` will be burned by `from`.
1773      * - `from` and `to` are never both zero.
1774      */
1775     function _beforeTokenTransfers(
1776         address from,
1777         address to,
1778         uint256 startTokenId,
1779         uint256 quantity
1780     ) internal virtual {}
1781 
1782     /**
1783      * @dev Hook that is called after a set of serially-ordered token IDs
1784      * have been transferred. This includes minting.
1785      * And also called after one token has been burned.
1786      *
1787      * `startTokenId` - the first token ID to be transferred.
1788      * `quantity` - the amount to be transferred.
1789      *
1790      * Calling conditions:
1791      *
1792      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1793      * transferred to `to`.
1794      * - When `from` is zero, `tokenId` has been minted for `to`.
1795      * - When `to` is zero, `tokenId` has been burned by `from`.
1796      * - `from` and `to` are never both zero.
1797      */
1798     function _afterTokenTransfers(
1799         address from,
1800         address to,
1801         uint256 startTokenId,
1802         uint256 quantity
1803     ) internal virtual {}
1804 
1805     /**
1806      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1807      *
1808      * `from` - Previous owner of the given token ID.
1809      * `to` - Target address that will receive the token.
1810      * `tokenId` - Token ID to be transferred.
1811      * `_data` - Optional data to send along with the call.
1812      *
1813      * Returns whether the call correctly returned the expected magic value.
1814      */
1815     function _checkContractOnERC721Received(
1816         address from,
1817         address to,
1818         uint256 tokenId,
1819         bytes memory _data
1820     ) private returns (bool) {
1821         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1822             bytes4 retval
1823         ) {
1824             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1825         } catch (bytes memory reason) {
1826             if (reason.length == 0) {
1827                 revert TransferToNonERC721ReceiverImplementer();
1828             } else {
1829                 assembly {
1830                     revert(add(32, reason), mload(reason))
1831                 }
1832             }
1833         }
1834     }
1835 
1836     // =============================================================
1837     //                        MINT OPERATIONS
1838     // =============================================================
1839 
1840     /**
1841      * @dev Mints `quantity` tokens and transfers them to `to`.
1842      *
1843      * Requirements:
1844      *
1845      * - `to` cannot be the zero address.
1846      * - `quantity` must be greater than 0.
1847      *
1848      * Emits a {Transfer} event for each mint.
1849      */
1850     function _mint(address to, uint256 quantity) internal virtual {
1851         uint256 startTokenId = _currentIndex;
1852         if (quantity == 0) revert MintZeroQuantity();
1853 
1854         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1855 
1856         // Overflows are incredibly unrealistic.
1857         // `balance` and `numberMinted` have a maximum limit of 2**64.
1858         // `tokenId` has a maximum limit of 2**256.
1859         unchecked {
1860             // Updates:
1861             // - `balance += quantity`.
1862             // - `numberMinted += quantity`.
1863             //
1864             // We can directly add to the `balance` and `numberMinted`.
1865             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1866 
1867             // Updates:
1868             // - `address` to the owner.
1869             // - `startTimestamp` to the timestamp of minting.
1870             // - `burned` to `false`.
1871             // - `nextInitialized` to `quantity == 1`.
1872             _packedOwnerships[startTokenId] = _packOwnershipData(
1873                 to,
1874                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1875             );
1876 
1877             uint256 toMasked;
1878             uint256 end = startTokenId + quantity;
1879 
1880             // Use assembly to loop and emit the `Transfer` event for gas savings.
1881             // The duplicated `log4` removes an extra check and reduces stack juggling.
1882             // The assembly, together with the surrounding Solidity code, have been
1883             // delicately arranged to nudge the compiler into producing optimized opcodes.
1884             assembly {
1885                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1886                 toMasked := and(to, _BITMASK_ADDRESS)
1887                 // Emit the `Transfer` event.
1888                 log4(
1889                     0, // Start of data (0, since no data).
1890                     0, // End of data (0, since no data).
1891                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1892                     0, // `address(0)`.
1893                     toMasked, // `to`.
1894                     startTokenId // `tokenId`.
1895                 )
1896 
1897                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1898                 // that overflows uint256 will make the loop run out of gas.
1899                 // The compiler will optimize the `iszero` away for performance.
1900                 for {
1901                     let tokenId := add(startTokenId, 1)
1902                 } iszero(eq(tokenId, end)) {
1903                     tokenId := add(tokenId, 1)
1904                 } {
1905                     // Emit the `Transfer` event. Similar to above.
1906                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1907                 }
1908             }
1909             if (toMasked == 0) revert MintToZeroAddress();
1910 
1911             _currentIndex = end;
1912         }
1913         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1914     }
1915 
1916     /**
1917      * @dev Mints `quantity` tokens and transfers them to `to`.
1918      *
1919      * This function is intended for efficient minting only during contract creation.
1920      *
1921      * It emits only one {ConsecutiveTransfer} as defined in
1922      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1923      * instead of a sequence of {Transfer} event(s).
1924      *
1925      * Calling this function outside of contract creation WILL make your contract
1926      * non-compliant with the ERC721 standard.
1927      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1928      * {ConsecutiveTransfer} event is only permissible during contract creation.
1929      *
1930      * Requirements:
1931      *
1932      * - `to` cannot be the zero address.
1933      * - `quantity` must be greater than 0.
1934      *
1935      * Emits a {ConsecutiveTransfer} event.
1936      */
1937     function _mintERC2309(address to, uint256 quantity) internal virtual {
1938         uint256 startTokenId = _currentIndex;
1939         if (to == address(0)) revert MintToZeroAddress();
1940         if (quantity == 0) revert MintZeroQuantity();
1941         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1942 
1943         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1944 
1945         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1946         unchecked {
1947             // Updates:
1948             // - `balance += quantity`.
1949             // - `numberMinted += quantity`.
1950             //
1951             // We can directly add to the `balance` and `numberMinted`.
1952             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1953 
1954             // Updates:
1955             // - `address` to the owner.
1956             // - `startTimestamp` to the timestamp of minting.
1957             // - `burned` to `false`.
1958             // - `nextInitialized` to `quantity == 1`.
1959             _packedOwnerships[startTokenId] = _packOwnershipData(
1960                 to,
1961                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1962             );
1963 
1964             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1965 
1966             _currentIndex = startTokenId + quantity;
1967         }
1968         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1969     }
1970 
1971     /**
1972      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1973      *
1974      * Requirements:
1975      *
1976      * - If `to` refers to a smart contract, it must implement
1977      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1978      * - `quantity` must be greater than 0.
1979      *
1980      * See {_mint}.
1981      *
1982      * Emits a {Transfer} event for each mint.
1983      */
1984     function _safeMint(
1985         address to,
1986         uint256 quantity,
1987         bytes memory _data
1988     ) internal virtual {
1989         _mint(to, quantity);
1990 
1991         unchecked {
1992             if (to.code.length != 0) {
1993                 uint256 end = _currentIndex;
1994                 uint256 index = end - quantity;
1995                 do {
1996                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1997                         revert TransferToNonERC721ReceiverImplementer();
1998                     }
1999                 } while (index < end);
2000                 // Reentrancy protection.
2001                 if (_currentIndex != end) revert();
2002             }
2003         }
2004     }
2005 
2006     /**
2007      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2008      */
2009     function _safeMint(address to, uint256 quantity) internal virtual {
2010         _safeMint(to, quantity, '');
2011     }
2012 
2013     // =============================================================
2014     //                        BURN OPERATIONS
2015     // =============================================================
2016 
2017     /**
2018      * @dev Equivalent to `_burn(tokenId, false)`.
2019      */
2020     function _burn(uint256 tokenId) internal virtual {
2021         _burn(tokenId, false);
2022     }
2023 
2024     /**
2025      * @dev Destroys `tokenId`.
2026      * The approval is cleared when the token is burned.
2027      *
2028      * Requirements:
2029      *
2030      * - `tokenId` must exist.
2031      *
2032      * Emits a {Transfer} event.
2033      */
2034     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2035         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2036 
2037         address from = address(uint160(prevOwnershipPacked));
2038 
2039         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2040 
2041         if (approvalCheck) {
2042             // The nested ifs save around 20+ gas over a compound boolean condition.
2043             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2044                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2045         }
2046 
2047         _beforeTokenTransfers(from, address(0), tokenId, 1);
2048 
2049         // Clear approvals from the previous owner.
2050         assembly {
2051             if approvedAddress {
2052                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2053                 sstore(approvedAddressSlot, 0)
2054             }
2055         }
2056 
2057         // Underflow of the sender's balance is impossible because we check for
2058         // ownership above and the recipient's balance can't realistically overflow.
2059         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2060         unchecked {
2061             // Updates:
2062             // - `balance -= 1`.
2063             // - `numberBurned += 1`.
2064             //
2065             // We can directly decrement the balance, and increment the number burned.
2066             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2067             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2068 
2069             // Updates:
2070             // - `address` to the last owner.
2071             // - `startTimestamp` to the timestamp of burning.
2072             // - `burned` to `true`.
2073             // - `nextInitialized` to `true`.
2074             _packedOwnerships[tokenId] = _packOwnershipData(
2075                 from,
2076                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2077             );
2078 
2079             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2080             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2081                 uint256 nextTokenId = tokenId + 1;
2082                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2083                 if (_packedOwnerships[nextTokenId] == 0) {
2084                     // If the next slot is within bounds.
2085                     if (nextTokenId != _currentIndex) {
2086                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2087                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2088                     }
2089                 }
2090             }
2091         }
2092 
2093         emit Transfer(from, address(0), tokenId);
2094         _afterTokenTransfers(from, address(0), tokenId, 1);
2095 
2096         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2097         unchecked {
2098             _burnCounter++;
2099         }
2100     }
2101 
2102     // =============================================================
2103     //                     EXTRA DATA OPERATIONS
2104     // =============================================================
2105 
2106     /**
2107      * @dev Directly sets the extra data for the ownership data `index`.
2108      */
2109     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2110         uint256 packed = _packedOwnerships[index];
2111         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2112         uint256 extraDataCasted;
2113         // Cast `extraData` with assembly to avoid redundant masking.
2114         assembly {
2115             extraDataCasted := extraData
2116         }
2117         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2118         _packedOwnerships[index] = packed;
2119     }
2120 
2121     /**
2122      * @dev Called during each token transfer to set the 24bit `extraData` field.
2123      * Intended to be overridden by the cosumer contract.
2124      *
2125      * `previousExtraData` - the value of `extraData` before transfer.
2126      *
2127      * Calling conditions:
2128      *
2129      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2130      * transferred to `to`.
2131      * - When `from` is zero, `tokenId` will be minted for `to`.
2132      * - When `to` is zero, `tokenId` will be burned by `from`.
2133      * - `from` and `to` are never both zero.
2134      */
2135     function _extraData(
2136         address from,
2137         address to,
2138         uint24 previousExtraData
2139     ) internal view virtual returns (uint24) {}
2140 
2141     /**
2142      * @dev Returns the next extra data for the packed ownership data.
2143      * The returned result is shifted into position.
2144      */
2145     function _nextExtraData(
2146         address from,
2147         address to,
2148         uint256 prevOwnershipPacked
2149     ) private view returns (uint256) {
2150         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2151         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2152     }
2153 
2154     // =============================================================
2155     //                       OTHER OPERATIONS
2156     // =============================================================
2157 
2158     /**
2159      * @dev Returns the message sender (defaults to `msg.sender`).
2160      *
2161      * If you are writing GSN compatible contracts, you need to override this function.
2162      */
2163     function _msgSenderERC721A() internal view virtual returns (address) {
2164         return msg.sender;
2165     }
2166 
2167     /**
2168      * @dev Converts a uint256 to its ASCII string decimal representation.
2169      */
2170     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2171         assembly {
2172             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2173             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2174             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2175             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2176             let m := add(mload(0x40), 0xa0)
2177             // Update the free memory pointer to allocate.
2178             mstore(0x40, m)
2179             // Assign the `str` to the end.
2180             str := sub(m, 0x20)
2181             // Zeroize the slot after the string.
2182             mstore(str, 0)
2183 
2184             // Cache the end of the memory to calculate the length later.
2185             let end := str
2186 
2187             // We write the string from rightmost digit to leftmost digit.
2188             // The following is essentially a do-while loop that also handles the zero case.
2189             // prettier-ignore
2190             for { let temp := value } 1 {} {
2191                 str := sub(str, 1)
2192                 // Write the character to the pointer.
2193                 // The ASCII index of the '0' character is 48.
2194                 mstore8(str, add(48, mod(temp, 10)))
2195                 // Keep dividing `temp` until zero.
2196                 temp := div(temp, 10)
2197                 // prettier-ignore
2198                 if iszero(temp) { break }
2199             }
2200 
2201             let length := sub(end, str)
2202             // Move the pointer 32 bytes leftwards to make room for the length.
2203             str := sub(str, 0x20)
2204             // Store the length.
2205             mstore(str, length)
2206         }
2207     }
2208 }
2209 
2210 // File: contracts/Mikas.sol
2211 
2212 
2213 pragma solidity ^0.8.14;
2214 
2215 
2216 
2217 
2218 
2219 
2220 interface IERC20Mikaboshi {
2221     function totalSupply() external view returns (uint);
2222     function balanceOf(address account) external view returns (uint);
2223     function transfer(address recipient, uint amount) external returns (bool);
2224     function allowance(address owner, address spender) external view returns (uint);
2225     function approve(address spender, uint amount) external returns (bool);
2226     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
2227     event Transfer(address indexed from, address indexed to, uint value);
2228     event Approval(address indexed owner, address indexed spender, uint value);
2229 }
2230 
2231 
2232 contract PayWithIERC20 is ERC721A, Ownable, ReentrancyGuard {
2233   //metadata
2234   string public hiddenMetadataUri = 'https://arweave.net/_';
2235   string public uriPrefix = 'https://arweave.net/__ARWEAVE_HASH_/';
2236   string public uriSuffix = '.json';
2237 
2238   // mainMint
2239   uint256 public mainMintStart =  	1672531201; // Sun Jan 01 2023 00:00:01 GMT+0000
2240   uint256 public maxMintAmountPerTx = 50;
2241   uint256 public mintRate = 7500000 ether;
2242   uint256 public frenListMintRate = 5000000 ether;
2243 
2244 
2245   uint public totalMints;
2246   bool public paused = false;
2247   bool public revealing = true;
2248   uint public revealTo = 0;
2249 
2250   uint public frenListMintLimits = 5;
2251   bytes32 public frenListMerkleRoot;
2252   mapping(address=>uint) public frenListMinted;
2253 
2254   // giftList
2255   bytes32 public giftListMerkleRoot;
2256   uint public giftListDefaultMax = 1;
2257   mapping(address=>uint) public giftListMintLimits;
2258   mapping(address=>uint) public giftListMinted;
2259 
2260   // mika contract
2261   address public IERC20ContractAddress;
2262 
2263   uint public burnPercentage = 5;
2264 
2265   constructor (
2266     address contractAddress,uint256 totalMintable) ERC721A("Atsuma-Mikaboshi-Genesis", "AMGNFT")  {
2267     IERC20ContractAddress = contractAddress;
2268     totalMints = totalMintable;
2269   }
2270 
2271 
2272   function _startTokenId() internal view virtual override returns (uint256) {
2273     return 1;
2274   }
2275   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2276     uriPrefix = _uriPrefix;
2277   }
2278 
2279   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2280     uriSuffix = _uriSuffix;
2281   }
2282 
2283   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2284     hiddenMetadataUri = _hiddenMetadataUri;
2285   }
2286 
2287    function setPaused(bool _state) public onlyOwner {
2288        paused = _state;
2289    }
2290 
2291    function setMintRate(uint256 _cost) public onlyOwner {
2292        mintRate = _cost;
2293    }
2294 
2295     function setRevealState(bool _state) public onlyOwner {
2296       revealing = _state;
2297     }
2298 
2299     function setRevealTo(uint _state) public onlyOwner {
2300       revealTo = _state;
2301     }
2302 
2303     function setMainMintStart(uint _state) public onlyOwner {
2304       mainMintStart = _state;
2305     }
2306 
2307     function setMaxMintAmmountPerTx(uint _state) public onlyOwner {
2308       maxMintAmountPerTx = _state;
2309     }
2310 
2311     function setBurnPercentage(uint _state) public onlyOwner {
2312       require(_state <100, "Cant burn more than 100%");
2313       require(_state > 1, "Cant burn less that 1%");
2314       burnPercentage = _state;
2315     }
2316 
2317   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2318     require(_exists(_tokenId), 'ERC721A Metadata: URI query for nonexistent token');
2319 
2320     // if revealing is on,
2321     if (revealing == true && (_tokenId > revealTo)) {
2322       return hiddenMetadataUri;
2323     }
2324     string memory currentBaseURI = uriPrefix;
2325     return bytes(currentBaseURI).length > 0
2326       ? string(abi.encodePacked(currentBaseURI, Strings.toString(_tokenId), uriSuffix))
2327       : '';
2328   }
2329 
2330   function mint(uint256 quantity) external payable {
2331     require(!paused, "Minting is paused!");
2332     require(block.timestamp >= mainMintStart, "The period to mint this card has not started.");
2333     require((_nextTokenId()-1) + quantity <= totalMints, "Not enough tokens left to fulfill mint ammount requested");
2334     require(quantity <= maxMintAmountPerTx, "Max Mint Amount Per TX reached");
2335 
2336     // does user have enough balance?
2337     require(IERC20Mikaboshi(IERC20ContractAddress).balanceOf(msg.sender)>= (mintRate * quantity),"Sender Does not have anough balance");
2338 
2339     // is user approved  allowance(address owner, address spender)
2340     require(IERC20Mikaboshi(IERC20ContractAddress).allowance(msg.sender, address(this)) >= (mintRate * quantity),"Ammount not approved to spend for user");
2341 
2342     // perform transaction.....
2343     uint _amount = mintRate * quantity;
2344     uint burnAmount = (_amount*burnPercentage)/100;
2345 
2346     require(IERC20Mikaboshi(IERC20ContractAddress).transferFrom(msg.sender, address(this),_amount),"Must send to this contract");
2347     require(IERC20Mikaboshi(IERC20ContractAddress).transfer(0x000000000000000000000000000000000000dEaD, burnAmount),"Must Burn Tokens from this contract");
2348 
2349     // then mint.
2350     _mint(msg.sender, quantity);
2351   }
2352 
2353   function mintForAddress( uint256 quantity, address _reciever) public nonReentrant onlyOwner {
2354     require(block.timestamp >= mainMintStart, "You can only mintForAddress once the frenList Mint starts.");
2355     require((_nextTokenId()-1) + quantity <= totalMints, "Not enough tokens left to fulfill mint ammount requested");
2356 
2357     _safeMint(_reciever, quantity);
2358   }
2359 
2360   function setFrenListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2361     frenListMerkleRoot = merkleRoot;
2362   }
2363 
2364   function setGiftListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2365     giftListMerkleRoot = merkleRoot;
2366   }
2367 
2368   function setFrenListMintLimits(uint limit) external onlyOwner {
2369     frenListMintLimits = limit;
2370   }
2371 
2372   function frenListMint(bytes32[] calldata merkleProof, uint256 quantity) public nonReentrant payable isValidMerkleProof(merkleProof, frenListMerkleRoot) {
2373     require(!paused, "Minting is paused!");
2374     require(block.timestamp >= mainMintStart, "You can only mint once the frenList Mint starts.");
2375     require((frenListMinted[msg.sender]+ quantity) <= frenListMintLimits, "Going over maximum frenList Mints" );
2376     require((_nextTokenId()-1) + quantity <= totalMints, "Not enough tokens left to fulfill mint ammount requested");
2377     require(quantity <= maxMintAmountPerTx, "Max Mint Amount Per TX reached");
2378     // does user have enough balance?
2379     require(IERC20Mikaboshi(IERC20ContractAddress).balanceOf(msg.sender)>= (frenListMintRate * quantity),"Sender Does not have anough balance");
2380 
2381     // is user approved  allowance(address owner, address spender)
2382     require(IERC20Mikaboshi(IERC20ContractAddress).allowance(msg.sender, address(this)) >= (frenListMintRate * quantity),"Ammount not approved to spend for user");
2383 
2384     // perform transaction.....
2385 
2386     uint _amount = frenListMintRate * quantity;
2387     uint burnAmount = (_amount*burnPercentage)/100;
2388 
2389     require(IERC20Mikaboshi(IERC20ContractAddress).transferFrom(msg.sender, address(this),_amount),"Must send to this contract");
2390     require(IERC20Mikaboshi(IERC20ContractAddress).transfer(0x000000000000000000000000000000000000dEaD, burnAmount),"Must Burn Tokens from this contract");
2391 
2392 
2393     frenListMinted[msg.sender] = frenListMinted[msg.sender]+quantity;
2394     _mint(msg.sender, quantity);
2395 
2396   }
2397 
2398   function giftListMint(bytes32[] calldata merkleProof, uint256 quantity) public nonReentrant payable isValidMerkleProof(merkleProof, giftListMerkleRoot) {
2399     require(!paused, "Minting is paused!");
2400     require(block.timestamp >= mainMintStart, "You can only mint once the frenList Mint starts.");
2401     require((_nextTokenId()-1) + quantity <= totalMints, "Not enough tokens left to fulfill mint ammount requested");
2402     // assign default or override if not set.
2403     if(giftListMinted[msg.sender] == 0){
2404       giftListMintLimits[msg.sender] = giftListMintLimits[msg.sender]==0 ? giftListDefaultMax : giftListMintLimits[msg.sender];
2405     }
2406     // can only mint what youve been granted
2407     require(giftListMinted[msg.sender]+quantity <= giftListMintLimits[msg.sender] ,"Can not exceed max gift mints for this address");
2408     giftListMinted[msg.sender] = giftListMinted[msg.sender]+quantity;
2409 
2410     _mint(msg.sender, quantity);
2411   }
2412 
2413   function updateGiftLimit(address[] memory addressses, uint[] memory limits) public nonReentrant onlyOwner {
2414     require(addressses.length == limits.length,"adresses and limits must be of equal length");
2415     for (uint256 i = 0; i<addressses.length; i++){
2416       giftListMintLimits[addressses[i]] = limits[i];
2417     }
2418   }
2419 
2420   modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
2421     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2422     require( MerkleProof.verify( merkleProof, root, leaf), "Address is not in the frens list");
2423     _;
2424   }
2425 
2426   function withdrawMika() external onlyOwner {
2427 
2428     // CHECK BALANCE
2429     uint balance  = IERC20Mikaboshi(IERC20ContractAddress).balanceOf(address(this));
2430 
2431     // approve move
2432     IERC20Mikaboshi(IERC20ContractAddress).approve(address(this), balance);
2433     // transfer
2434     IERC20Mikaboshi(IERC20ContractAddress).transfer(owner(),  balance);
2435   }
2436 
2437   function withdraw() external onlyOwner{
2438     payable(owner()).transfer(address(this).balance);
2439   }
2440 
2441   /**
2442    * Invalid query range (`start` >= `stop`).
2443    */
2444   error InvalidQueryRange();
2445   /**
2446        * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2447        *
2448        * If the `tokenId` is out of bounds:
2449        *
2450        * - `addr = address(0)`
2451        * - `startTimestamp = 0`
2452        * - `burned = false`
2453        * - `extraData = 0`
2454        *
2455        * If the `tokenId` is burned:
2456        *
2457        * - `addr = <Address of owner before token was burned>`
2458        * - `startTimestamp = <Timestamp when token was burned>`
2459        * - `burned = true`
2460        * - `extraData = <Extra data when token was burned>`
2461        *
2462        * Otherwise:
2463        *
2464        * - `addr = <Address of owner>`
2465        * - `startTimestamp = <Timestamp of start of ownership>`
2466        * - `burned = false`
2467        * - `extraData = <Extra data at start of ownership>`
2468        */
2469       function explicitOwnershipOf(uint256 tokenId) public view virtual returns (TokenOwnership memory) {
2470           TokenOwnership memory ownership;
2471           if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2472               return ownership;
2473           }
2474           ownership = _ownershipAt(tokenId);
2475           if (ownership.burned) {
2476               return ownership;
2477           }
2478           return _ownershipOf(tokenId);
2479       }
2480 
2481       /**
2482        * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2483        * See {ERC721AQueryable-explicitOwnershipOf}
2484        */
2485       function explicitOwnershipsOf(uint256[] calldata tokenIds)
2486           external
2487           view
2488           virtual
2489           returns (TokenOwnership[] memory)
2490       {
2491           unchecked {
2492               uint256 tokenIdsLength = tokenIds.length;
2493               TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2494               for (uint256 i; i != tokenIdsLength; ++i) {
2495                   ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2496               }
2497               return ownerships;
2498           }
2499       }
2500 
2501 
2502       /**
2503        * @dev Returns an array of token IDs owned by `owner`.
2504        *
2505        * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2506        * It is meant to be called off-chain.
2507        *
2508        * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2509        * multiple smaller scans if the collection is large enough to cause
2510        * an out-of-gas error (10K collections should be fine).
2511        */
2512       function tokensOfOwner(address owner) external view virtual returns (uint256[] memory) {
2513           unchecked {
2514               uint256 tokenIdsIdx;
2515               address currOwnershipAddr;
2516               uint256 tokenIdsLength = balanceOf(owner);
2517               uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2518               TokenOwnership memory ownership;
2519               for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2520                   ownership = _ownershipAt(i);
2521                   if (ownership.burned) {
2522                       continue;
2523                   }
2524                   if (ownership.addr != address(0)) {
2525                       currOwnershipAddr = ownership.addr;
2526                   }
2527                   if (currOwnershipAddr == owner) {
2528                       tokenIds[tokenIdsIdx++] = i;
2529                   }
2530               }
2531               return tokenIds;
2532           }
2533       }
2534 }