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
648 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
649 
650 
651 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 // CAUTION
656 // This version of SafeMath should only be used with Solidity 0.8 or later,
657 // because it relies on the compiler's built in overflow checks.
658 
659 /**
660  * @dev Wrappers over Solidity's arithmetic operations.
661  *
662  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
663  * now has built in overflow checking.
664  */
665 library SafeMath {
666     /**
667      * @dev Returns the addition of two unsigned integers, with an overflow flag.
668      *
669      * _Available since v3.4._
670      */
671     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
672         unchecked {
673             uint256 c = a + b;
674             if (c < a) return (false, 0);
675             return (true, c);
676         }
677     }
678 
679     /**
680      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
681      *
682      * _Available since v3.4._
683      */
684     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
685         unchecked {
686             if (b > a) return (false, 0);
687             return (true, a - b);
688         }
689     }
690 
691     /**
692      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
693      *
694      * _Available since v3.4._
695      */
696     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
697         unchecked {
698             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
699             // benefit is lost if 'b' is also tested.
700             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
701             if (a == 0) return (true, 0);
702             uint256 c = a * b;
703             if (c / a != b) return (false, 0);
704             return (true, c);
705         }
706     }
707 
708     /**
709      * @dev Returns the division of two unsigned integers, with a division by zero flag.
710      *
711      * _Available since v3.4._
712      */
713     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
714         unchecked {
715             if (b == 0) return (false, 0);
716             return (true, a / b);
717         }
718     }
719 
720     /**
721      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
722      *
723      * _Available since v3.4._
724      */
725     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
726         unchecked {
727             if (b == 0) return (false, 0);
728             return (true, a % b);
729         }
730     }
731 
732     /**
733      * @dev Returns the addition of two unsigned integers, reverting on
734      * overflow.
735      *
736      * Counterpart to Solidity's `+` operator.
737      *
738      * Requirements:
739      *
740      * - Addition cannot overflow.
741      */
742     function add(uint256 a, uint256 b) internal pure returns (uint256) {
743         return a + b;
744     }
745 
746     /**
747      * @dev Returns the subtraction of two unsigned integers, reverting on
748      * overflow (when the result is negative).
749      *
750      * Counterpart to Solidity's `-` operator.
751      *
752      * Requirements:
753      *
754      * - Subtraction cannot overflow.
755      */
756     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
757         return a - b;
758     }
759 
760     /**
761      * @dev Returns the multiplication of two unsigned integers, reverting on
762      * overflow.
763      *
764      * Counterpart to Solidity's `*` operator.
765      *
766      * Requirements:
767      *
768      * - Multiplication cannot overflow.
769      */
770     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
771         return a * b;
772     }
773 
774     /**
775      * @dev Returns the integer division of two unsigned integers, reverting on
776      * division by zero. The result is rounded towards zero.
777      *
778      * Counterpart to Solidity's `/` operator.
779      *
780      * Requirements:
781      *
782      * - The divisor cannot be zero.
783      */
784     function div(uint256 a, uint256 b) internal pure returns (uint256) {
785         return a / b;
786     }
787 
788     /**
789      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
790      * reverting when dividing by zero.
791      *
792      * Counterpart to Solidity's `%` operator. This function uses a `revert`
793      * opcode (which leaves remaining gas untouched) while Solidity uses an
794      * invalid opcode to revert (consuming all remaining gas).
795      *
796      * Requirements:
797      *
798      * - The divisor cannot be zero.
799      */
800     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
801         return a % b;
802     }
803 
804     /**
805      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
806      * overflow (when the result is negative).
807      *
808      * CAUTION: This function is deprecated because it requires allocating memory for the error
809      * message unnecessarily. For custom revert reasons use {trySub}.
810      *
811      * Counterpart to Solidity's `-` operator.
812      *
813      * Requirements:
814      *
815      * - Subtraction cannot overflow.
816      */
817     function sub(
818         uint256 a,
819         uint256 b,
820         string memory errorMessage
821     ) internal pure returns (uint256) {
822         unchecked {
823             require(b <= a, errorMessage);
824             return a - b;
825         }
826     }
827 
828     /**
829      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
830      * division by zero. The result is rounded towards zero.
831      *
832      * Counterpart to Solidity's `/` operator. Note: this function uses a
833      * `revert` opcode (which leaves remaining gas untouched) while Solidity
834      * uses an invalid opcode to revert (consuming all remaining gas).
835      *
836      * Requirements:
837      *
838      * - The divisor cannot be zero.
839      */
840     function div(
841         uint256 a,
842         uint256 b,
843         string memory errorMessage
844     ) internal pure returns (uint256) {
845         unchecked {
846             require(b > 0, errorMessage);
847             return a / b;
848         }
849     }
850 
851     /**
852      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
853      * reverting with custom message when dividing by zero.
854      *
855      * CAUTION: This function is deprecated because it requires allocating memory for the error
856      * message unnecessarily. For custom revert reasons use {tryMod}.
857      *
858      * Counterpart to Solidity's `%` operator. This function uses a `revert`
859      * opcode (which leaves remaining gas untouched) while Solidity uses an
860      * invalid opcode to revert (consuming all remaining gas).
861      *
862      * Requirements:
863      *
864      * - The divisor cannot be zero.
865      */
866     function mod(
867         uint256 a,
868         uint256 b,
869         string memory errorMessage
870     ) internal pure returns (uint256) {
871         unchecked {
872             require(b > 0, errorMessage);
873             return a % b;
874         }
875     }
876 }
877 
878 // File: @openzeppelin/contracts/utils/Context.sol
879 
880 
881 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
882 
883 pragma solidity ^0.8.0;
884 
885 /**
886  * @dev Provides information about the current execution context, including the
887  * sender of the transaction and its data. While these are generally available
888  * via msg.sender and msg.data, they should not be accessed in such a direct
889  * manner, since when dealing with meta-transactions the account sending and
890  * paying for execution may not be the actual sender (as far as an application
891  * is concerned).
892  *
893  * This contract is only required for intermediate, library-like contracts.
894  */
895 abstract contract Context {
896     function _msgSender() internal view virtual returns (address) {
897         return msg.sender;
898     }
899 
900     function _msgData() internal view virtual returns (bytes calldata) {
901         return msg.data;
902     }
903 }
904 
905 // File: @openzeppelin/contracts/access/Ownable.sol
906 
907 
908 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
909 
910 pragma solidity ^0.8.0;
911 
912 
913 /**
914  * @dev Contract module which provides a basic access control mechanism, where
915  * there is an account (an owner) that can be granted exclusive access to
916  * specific functions.
917  *
918  * By default, the owner account will be the one that deploys the contract. This
919  * can later be changed with {transferOwnership}.
920  *
921  * This module is used through inheritance. It will make available the modifier
922  * `onlyOwner`, which can be applied to your functions to restrict their use to
923  * the owner.
924  */
925 abstract contract Ownable is Context {
926     address private _owner;
927 
928     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
929 
930     /**
931      * @dev Initializes the contract setting the deployer as the initial owner.
932      */
933     constructor() {
934         _transferOwnership(_msgSender());
935     }
936 
937     /**
938      * @dev Throws if called by any account other than the owner.
939      */
940     modifier onlyOwner() {
941         _checkOwner();
942         _;
943     }
944 
945     /**
946      * @dev Returns the address of the current owner.
947      */
948     function owner() public view virtual returns (address) {
949         return _owner;
950     }
951 
952     /**
953      * @dev Throws if the sender is not the owner.
954      */
955     function _checkOwner() internal view virtual {
956         require(owner() == _msgSender(), "Ownable: caller is not the owner");
957     }
958 
959     /**
960      * @dev Leaves the contract without owner. It will not be possible to call
961      * `onlyOwner` functions anymore. Can only be called by the current owner.
962      *
963      * NOTE: Renouncing ownership will leave the contract without an owner,
964      * thereby removing any functionality that is only available to the owner.
965      */
966     function renounceOwnership() public virtual onlyOwner {
967         _transferOwnership(address(0));
968     }
969 
970     /**
971      * @dev Transfers ownership of the contract to a new account (`newOwner`).
972      * Can only be called by the current owner.
973      */
974     function transferOwnership(address newOwner) public virtual onlyOwner {
975         require(newOwner != address(0), "Ownable: new owner is the zero address");
976         _transferOwnership(newOwner);
977     }
978 
979     /**
980      * @dev Transfers ownership of the contract to a new account (`newOwner`).
981      * Internal function without access restriction.
982      */
983     function _transferOwnership(address newOwner) internal virtual {
984         address oldOwner = _owner;
985         _owner = newOwner;
986         emit OwnershipTransferred(oldOwner, newOwner);
987     }
988 }
989 
990 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/IOperatorFilterRegistry.sol
991 
992 
993 pragma solidity ^0.8.13;
994 
995 interface IOperatorFilterRegistry {
996     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
997     function register(address registrant) external;
998     function registerAndSubscribe(address registrant, address subscription) external;
999     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1000     function unregister(address addr) external;
1001     function updateOperator(address registrant, address operator, bool filtered) external;
1002     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1003     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1004     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1005     function subscribe(address registrant, address registrantToSubscribe) external;
1006     function unsubscribe(address registrant, bool copyExistingEntries) external;
1007     function subscriptionOf(address addr) external returns (address registrant);
1008     function subscribers(address registrant) external returns (address[] memory);
1009     function subscriberAt(address registrant, uint256 index) external returns (address);
1010     function copyEntriesOf(address registrant, address registrantToCopy) external;
1011     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1012     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1013     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1014     function filteredOperators(address addr) external returns (address[] memory);
1015     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1016     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1017     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1018     function isRegistered(address addr) external returns (bool);
1019     function codeHashOf(address addr) external returns (bytes32);
1020 }
1021 
1022 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/OperatorFilterer.sol
1023 
1024 
1025 pragma solidity ^0.8.13;
1026 
1027 
1028 /**
1029  * @title  OperatorFilterer
1030  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1031  *         registrant's entries in the OperatorFilterRegistry.
1032  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1033  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1034  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1035  */
1036 abstract contract OperatorFilterer {
1037     error OperatorNotAllowed(address operator);
1038 
1039     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1040         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1041 
1042     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1043         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1044         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1045         // order for the modifier to filter addresses.
1046         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1047             if (subscribe) {
1048                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1049             } else {
1050                 if (subscriptionOrRegistrantToCopy != address(0)) {
1051                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1052                 } else {
1053                     OPERATOR_FILTER_REGISTRY.register(address(this));
1054                 }
1055             }
1056         }
1057     }
1058 
1059     modifier onlyAllowedOperator(address from) virtual {
1060         // Check registry code length to facilitate testing in environments without a deployed registry.
1061         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1062             // Allow spending tokens from addresses with balance
1063             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1064             // from an EOA.
1065             if (from == msg.sender) {
1066                 _;
1067                 return;
1068             }
1069             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1070                 revert OperatorNotAllowed(msg.sender);
1071             }
1072         }
1073         _;
1074     }
1075 
1076     modifier onlyAllowedOperatorApproval(address operator) virtual {
1077         // Check registry code length to facilitate testing in environments without a deployed registry.
1078         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1079             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1080                 revert OperatorNotAllowed(operator);
1081             }
1082         }
1083         _;
1084     }
1085 }
1086 
1087 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/529cceeda9f5f8e28812c20042cc57626f784718/src/DefaultOperatorFilterer.sol
1088 
1089 
1090 pragma solidity ^0.8.13;
1091 
1092 
1093 /**
1094  * @title  DefaultOperatorFilterer
1095  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1096  */
1097 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1098     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1099 
1100     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1101 }
1102 
1103 // File: https://github.com/chiru-labs/ERC721A/blob/2342b592d990a7710faf40fe66cfa1ce61dd2339/contracts/IERC721A.sol
1104 
1105 
1106 // ERC721A Contracts v4.2.3
1107 // Creator: Chiru Labs
1108 
1109 pragma solidity ^0.8.4;
1110 
1111 /**
1112  * @dev Interface of ERC721A.
1113  */
1114 interface IERC721A {
1115     /**
1116      * The caller must own the token or be an approved operator.
1117      */
1118     error ApprovalCallerNotOwnerNorApproved();
1119 
1120     /**
1121      * The token does not exist.
1122      */
1123     error ApprovalQueryForNonexistentToken();
1124 
1125     /**
1126      * Cannot query the balance for the zero address.
1127      */
1128     error BalanceQueryForZeroAddress();
1129 
1130     /**
1131      * Cannot mint to the zero address.
1132      */
1133     error MintToZeroAddress();
1134 
1135     /**
1136      * The quantity of tokens minted must be more than zero.
1137      */
1138     error MintZeroQuantity();
1139 
1140     /**
1141      * The token does not exist.
1142      */
1143     error OwnerQueryForNonexistentToken();
1144 
1145     /**
1146      * The caller must own the token or be an approved operator.
1147      */
1148     error TransferCallerNotOwnerNorApproved();
1149 
1150     /**
1151      * The token must be owned by `from`.
1152      */
1153     error TransferFromIncorrectOwner();
1154 
1155     /**
1156      * Cannot safely transfer to a contract that does not implement the
1157      * ERC721Receiver interface.
1158      */
1159     error TransferToNonERC721ReceiverImplementer();
1160 
1161     /**
1162      * Cannot transfer to the zero address.
1163      */
1164     error TransferToZeroAddress();
1165 
1166     /**
1167      * The token does not exist.
1168      */
1169     error URIQueryForNonexistentToken();
1170 
1171     /**
1172      * The `quantity` minted with ERC2309 exceeds the safety limit.
1173      */
1174     error MintERC2309QuantityExceedsLimit();
1175 
1176     /**
1177      * The `extraData` cannot be set on an unintialized ownership slot.
1178      */
1179     error OwnershipNotInitializedForExtraData();
1180 
1181     // =============================================================
1182     //                            STRUCTS
1183     // =============================================================
1184 
1185     struct TokenOwnership {
1186         // The address of the owner.
1187         address addr;
1188         // Stores the start time of ownership with minimal overhead for tokenomics.
1189         uint64 startTimestamp;
1190         // Whether the token has been burned.
1191         bool burned;
1192         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1193         uint24 extraData;
1194     }
1195 
1196     // =============================================================
1197     //                         TOKEN COUNTERS
1198     // =============================================================
1199 
1200     /**
1201      * @dev Returns the total number of tokens in existence.
1202      * Burned tokens will reduce the count.
1203      * To get the total number of tokens minted, please see {_totalMinted}.
1204      */
1205     function totalSupply() external view returns (uint256);
1206 
1207     // =============================================================
1208     //                            IERC165
1209     // =============================================================
1210 
1211     /**
1212      * @dev Returns true if this contract implements the interface defined by
1213      * `interfaceId`. See the corresponding
1214      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1215      * to learn more about how these ids are created.
1216      *
1217      * This function call must use less than 30000 gas.
1218      */
1219     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1220 
1221     // =============================================================
1222     //                            IERC721
1223     // =============================================================
1224 
1225     /**
1226      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1227      */
1228     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1229 
1230     /**
1231      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1232      */
1233     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1234 
1235     /**
1236      * @dev Emitted when `owner` enables or disables
1237      * (`approved`) `operator` to manage all of its assets.
1238      */
1239     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1240 
1241     /**
1242      * @dev Returns the number of tokens in `owner`'s account.
1243      */
1244     function balanceOf(address owner) external view returns (uint256 balance);
1245 
1246     /**
1247      * @dev Returns the owner of the `tokenId` token.
1248      *
1249      * Requirements:
1250      *
1251      * - `tokenId` must exist.
1252      */
1253     function ownerOf(uint256 tokenId) external view returns (address owner);
1254 
1255     /**
1256      * @dev Safely transfers `tokenId` token from `from` to `to`,
1257      * checking first that contract recipients are aware of the ERC721 protocol
1258      * to prevent tokens from being forever locked.
1259      *
1260      * Requirements:
1261      *
1262      * - `from` cannot be the zero address.
1263      * - `to` cannot be the zero address.
1264      * - `tokenId` token must exist and be owned by `from`.
1265      * - If the caller is not `from`, it must be have been allowed to move
1266      * this token by either {approve} or {setApprovalForAll}.
1267      * - If `to` refers to a smart contract, it must implement
1268      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1269      *
1270      * Emits a {Transfer} event.
1271      */
1272     function safeTransferFrom(
1273         address from,
1274         address to,
1275         uint256 tokenId,
1276         bytes calldata data
1277     ) external payable;
1278 
1279     /**
1280      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1281      */
1282     function safeTransferFrom(
1283         address from,
1284         address to,
1285         uint256 tokenId
1286     ) external payable;
1287 
1288     /**
1289      * @dev Transfers `tokenId` from `from` to `to`.
1290      *
1291      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1292      * whenever possible.
1293      *
1294      * Requirements:
1295      *
1296      * - `from` cannot be the zero address.
1297      * - `to` cannot be the zero address.
1298      * - `tokenId` token must be owned by `from`.
1299      * - If the caller is not `from`, it must be approved to move this token
1300      * by either {approve} or {setApprovalForAll}.
1301      *
1302      * Emits a {Transfer} event.
1303      */
1304     function transferFrom(
1305         address from,
1306         address to,
1307         uint256 tokenId
1308     ) external payable;
1309 
1310     /**
1311      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1312      * The approval is cleared when the token is transferred.
1313      *
1314      * Only a single account can be approved at a time, so approving the
1315      * zero address clears previous approvals.
1316      *
1317      * Requirements:
1318      *
1319      * - The caller must own the token or be an approved operator.
1320      * - `tokenId` must exist.
1321      *
1322      * Emits an {Approval} event.
1323      */
1324     function approve(address to, uint256 tokenId) external payable;
1325 
1326     /**
1327      * @dev Approve or remove `operator` as an operator for the caller.
1328      * Operators can call {transferFrom} or {safeTransferFrom}
1329      * for any token owned by the caller.
1330      *
1331      * Requirements:
1332      *
1333      * - The `operator` cannot be the caller.
1334      *
1335      * Emits an {ApprovalForAll} event.
1336      */
1337     function setApprovalForAll(address operator, bool _approved) external;
1338 
1339     /**
1340      * @dev Returns the account approved for `tokenId` token.
1341      *
1342      * Requirements:
1343      *
1344      * - `tokenId` must exist.
1345      */
1346     function getApproved(uint256 tokenId) external view returns (address operator);
1347 
1348     /**
1349      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1350      *
1351      * See {setApprovalForAll}.
1352      */
1353     function isApprovedForAll(address owner, address operator) external view returns (bool);
1354 
1355     // =============================================================
1356     //                        IERC721Metadata
1357     // =============================================================
1358 
1359     /**
1360      * @dev Returns the token collection name.
1361      */
1362     function name() external view returns (string memory);
1363 
1364     /**
1365      * @dev Returns the token collection symbol.
1366      */
1367     function symbol() external view returns (string memory);
1368 
1369     /**
1370      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1371      */
1372     function tokenURI(uint256 tokenId) external view returns (string memory);
1373 
1374     // =============================================================
1375     //                           IERC2309
1376     // =============================================================
1377 
1378     /**
1379      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1380      * (inclusive) is transferred from `from` to `to`, as defined in the
1381      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1382      *
1383      * See {_mintERC2309} for more details.
1384      */
1385     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1386 }
1387 
1388 // File: https://github.com/chiru-labs/ERC721A/blob/2342b592d990a7710faf40fe66cfa1ce61dd2339/contracts/extensions/IERC721AQueryable.sol
1389 
1390 
1391 // ERC721A Contracts v4.2.3
1392 // Creator: Chiru Labs
1393 
1394 pragma solidity ^0.8.4;
1395 
1396 
1397 /**
1398  * @dev Interface of ERC721AQueryable.
1399  */
1400 interface IERC721AQueryable is IERC721A {
1401     /**
1402      * Invalid query range (`start` >= `stop`).
1403      */
1404     error InvalidQueryRange();
1405 
1406     /**
1407      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1408      *
1409      * If the `tokenId` is out of bounds:
1410      *
1411      * - `addr = address(0)`
1412      * - `startTimestamp = 0`
1413      * - `burned = false`
1414      * - `extraData = 0`
1415      *
1416      * If the `tokenId` is burned:
1417      *
1418      * - `addr = <Address of owner before token was burned>`
1419      * - `startTimestamp = <Timestamp when token was burned>`
1420      * - `burned = true`
1421      * - `extraData = <Extra data when token was burned>`
1422      *
1423      * Otherwise:
1424      *
1425      * - `addr = <Address of owner>`
1426      * - `startTimestamp = <Timestamp of start of ownership>`
1427      * - `burned = false`
1428      * - `extraData = <Extra data at start of ownership>`
1429      */
1430     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1431 
1432     /**
1433      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1434      * See {ERC721AQueryable-explicitOwnershipOf}
1435      */
1436     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1437 
1438     /**
1439      * @dev Returns an array of token IDs owned by `owner`,
1440      * in the range [`start`, `stop`)
1441      * (i.e. `start <= tokenId < stop`).
1442      *
1443      * This function allows for tokens to be queried if the collection
1444      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1445      *
1446      * Requirements:
1447      *
1448      * - `start < stop`
1449      */
1450     function tokensOfOwnerIn(
1451         address owner,
1452         uint256 start,
1453         uint256 stop
1454     ) external view returns (uint256[] memory);
1455 
1456     /**
1457      * @dev Returns an array of token IDs owned by `owner`.
1458      *
1459      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1460      * It is meant to be called off-chain.
1461      *
1462      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1463      * multiple smaller scans if the collection is large enough to cause
1464      * an out-of-gas error (10K collections should be fine).
1465      */
1466     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1467 }
1468 
1469 // File: https://github.com/chiru-labs/ERC721A/blob/2342b592d990a7710faf40fe66cfa1ce61dd2339/contracts/ERC721A.sol
1470 
1471 
1472 // ERC721A Contracts v4.2.3
1473 // Creator: Chiru Labs
1474 
1475 pragma solidity ^0.8.4;
1476 
1477 
1478 /**
1479  * @dev Interface of ERC721 token receiver.
1480  */
1481 interface ERC721A__IERC721Receiver {
1482     function onERC721Received(
1483         address operator,
1484         address from,
1485         uint256 tokenId,
1486         bytes calldata data
1487     ) external returns (bytes4);
1488 }
1489 
1490 /**
1491  * @title ERC721A
1492  *
1493  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1494  * Non-Fungible Token Standard, including the Metadata extension.
1495  * Optimized for lower gas during batch mints.
1496  *
1497  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1498  * starting from `_startTokenId()`.
1499  *
1500  * Assumptions:
1501  *
1502  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1503  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1504  */
1505 contract ERC721A is IERC721A {
1506     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1507     struct TokenApprovalRef {
1508         address value;
1509     }
1510 
1511     // =============================================================
1512     //                           CONSTANTS
1513     // =============================================================
1514 
1515     // Mask of an entry in packed address data.
1516     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1517 
1518     // The bit position of `numberMinted` in packed address data.
1519     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1520 
1521     // The bit position of `numberBurned` in packed address data.
1522     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1523 
1524     // The bit position of `aux` in packed address data.
1525     uint256 private constant _BITPOS_AUX = 192;
1526 
1527     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1528     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1529 
1530     // The bit position of `startTimestamp` in packed ownership.
1531     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1532 
1533     // The bit mask of the `burned` bit in packed ownership.
1534     uint256 private constant _BITMASK_BURNED = 1 << 224;
1535 
1536     // The bit position of the `nextInitialized` bit in packed ownership.
1537     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1538 
1539     // The bit mask of the `nextInitialized` bit in packed ownership.
1540     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1541 
1542     // The bit position of `extraData` in packed ownership.
1543     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1544 
1545     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1546     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1547 
1548     // The mask of the lower 160 bits for addresses.
1549     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1550 
1551     // The maximum `quantity` that can be minted with {_mintERC2309}.
1552     // This limit is to prevent overflows on the address data entries.
1553     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1554     // is required to cause an overflow, which is unrealistic.
1555     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1556 
1557     // The `Transfer` event signature is given by:
1558     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1559     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1560         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1561 
1562     // =============================================================
1563     //                            STORAGE
1564     // =============================================================
1565 
1566     // The next token ID to be minted.
1567     uint256 private _currentIndex;
1568 
1569     // The number of tokens burned.
1570     uint256 private _burnCounter;
1571 
1572     // Token name
1573     string private _name;
1574 
1575     // Token symbol
1576     string private _symbol;
1577 
1578     // Mapping from token ID to ownership details
1579     // An empty struct value does not necessarily mean the token is unowned.
1580     // See {_packedOwnershipOf} implementation for details.
1581     //
1582     // Bits Layout:
1583     // - [0..159]   `addr`
1584     // - [160..223] `startTimestamp`
1585     // - [224]      `burned`
1586     // - [225]      `nextInitialized`
1587     // - [232..255] `extraData`
1588     mapping(uint256 => uint256) private _packedOwnerships;
1589 
1590     // Mapping owner address to address data.
1591     //
1592     // Bits Layout:
1593     // - [0..63]    `balance`
1594     // - [64..127]  `numberMinted`
1595     // - [128..191] `numberBurned`
1596     // - [192..255] `aux`
1597     mapping(address => uint256) private _packedAddressData;
1598 
1599     // Mapping from token ID to approved address.
1600     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1601 
1602     // Mapping from owner to operator approvals
1603     mapping(address => mapping(address => bool)) private _operatorApprovals;
1604 
1605     // =============================================================
1606     //                          CONSTRUCTOR
1607     // =============================================================
1608 
1609     constructor(string memory name_, string memory symbol_) {
1610         _name = name_;
1611         _symbol = symbol_;
1612         _currentIndex = _startTokenId();
1613     }
1614 
1615     // =============================================================
1616     //                   TOKEN COUNTING OPERATIONS
1617     // =============================================================
1618 
1619     /**
1620      * @dev Returns the starting token ID.
1621      * To change the starting token ID, please override this function.
1622      */
1623     function _startTokenId() internal view virtual returns (uint256) {
1624         return 0;
1625     }
1626 
1627     /**
1628      * @dev Returns the next token ID to be minted.
1629      */
1630     function _nextTokenId() internal view virtual returns (uint256) {
1631         return _currentIndex;
1632     }
1633 
1634     /**
1635      * @dev Returns the total number of tokens in existence.
1636      * Burned tokens will reduce the count.
1637      * To get the total number of tokens minted, please see {_totalMinted}.
1638      */
1639     function totalSupply() public view virtual override returns (uint256) {
1640         // Counter underflow is impossible as _burnCounter cannot be incremented
1641         // more than `_currentIndex - _startTokenId()` times.
1642         unchecked {
1643             return _currentIndex - _burnCounter - _startTokenId();
1644         }
1645     }
1646 
1647     /**
1648      * @dev Returns the total amount of tokens minted in the contract.
1649      */
1650     function _totalMinted() internal view virtual returns (uint256) {
1651         // Counter underflow is impossible as `_currentIndex` does not decrement,
1652         // and it is initialized to `_startTokenId()`.
1653         unchecked {
1654             return _currentIndex - _startTokenId();
1655         }
1656     }
1657 
1658     /**
1659      * @dev Returns the total number of tokens burned.
1660      */
1661     function _totalBurned() internal view virtual returns (uint256) {
1662         return _burnCounter;
1663     }
1664 
1665     // =============================================================
1666     //                    ADDRESS DATA OPERATIONS
1667     // =============================================================
1668 
1669     /**
1670      * @dev Returns the number of tokens in `owner`'s account.
1671      */
1672     function balanceOf(address owner) public view virtual override returns (uint256) {
1673         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1674         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1675     }
1676 
1677     /**
1678      * Returns the number of tokens minted by `owner`.
1679      */
1680     function _numberMinted(address owner) internal view returns (uint256) {
1681         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1682     }
1683 
1684     /**
1685      * Returns the number of tokens burned by or on behalf of `owner`.
1686      */
1687     function _numberBurned(address owner) internal view returns (uint256) {
1688         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1689     }
1690 
1691     /**
1692      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1693      */
1694     function _getAux(address owner) internal view returns (uint64) {
1695         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1696     }
1697 
1698     /**
1699      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1700      * If there are multiple variables, please pack them into a uint64.
1701      */
1702     function _setAux(address owner, uint64 aux) internal virtual {
1703         uint256 packed = _packedAddressData[owner];
1704         uint256 auxCasted;
1705         // Cast `aux` with assembly to avoid redundant masking.
1706         assembly {
1707             auxCasted := aux
1708         }
1709         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1710         _packedAddressData[owner] = packed;
1711     }
1712 
1713     // =============================================================
1714     //                            IERC165
1715     // =============================================================
1716 
1717     /**
1718      * @dev Returns true if this contract implements the interface defined by
1719      * `interfaceId`. See the corresponding
1720      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1721      * to learn more about how these ids are created.
1722      *
1723      * This function call must use less than 30000 gas.
1724      */
1725     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1726         // The interface IDs are constants representing the first 4 bytes
1727         // of the XOR of all function selectors in the interface.
1728         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1729         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1730         return
1731             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1732             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1733             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1734     }
1735 
1736     // =============================================================
1737     //                        IERC721Metadata
1738     // =============================================================
1739 
1740     /**
1741      * @dev Returns the token collection name.
1742      */
1743     function name() public view virtual override returns (string memory) {
1744         return _name;
1745     }
1746 
1747     /**
1748      * @dev Returns the token collection symbol.
1749      */
1750     function symbol() public view virtual override returns (string memory) {
1751         return _symbol;
1752     }
1753 
1754     /**
1755      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1756      */
1757     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1758         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1759 
1760         string memory baseURI = _baseURI();
1761         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1762     }
1763 
1764     /**
1765      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1766      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1767      * by default, it can be overridden in child contracts.
1768      */
1769     function _baseURI() internal view virtual returns (string memory) {
1770         return '';
1771     }
1772 
1773     // =============================================================
1774     //                     OWNERSHIPS OPERATIONS
1775     // =============================================================
1776 
1777     /**
1778      * @dev Returns the owner of the `tokenId` token.
1779      *
1780      * Requirements:
1781      *
1782      * - `tokenId` must exist.
1783      */
1784     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1785         return address(uint160(_packedOwnershipOf(tokenId)));
1786     }
1787 
1788     /**
1789      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1790      * It gradually moves to O(1) as tokens get transferred around over time.
1791      */
1792     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1793         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1794     }
1795 
1796     /**
1797      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1798      */
1799     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1800         return _unpackedOwnership(_packedOwnerships[index]);
1801     }
1802 
1803     /**
1804      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1805      */
1806     function _initializeOwnershipAt(uint256 index) internal virtual {
1807         if (_packedOwnerships[index] == 0) {
1808             _packedOwnerships[index] = _packedOwnershipOf(index);
1809         }
1810     }
1811 
1812     /**
1813      * Returns the packed ownership data of `tokenId`.
1814      */
1815     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
1816         if (_startTokenId() <= tokenId) {
1817             packed = _packedOwnerships[tokenId];
1818             // If not burned.
1819             if (packed & _BITMASK_BURNED == 0) {
1820                 // If the data at the starting slot does not exist, start the scan.
1821                 if (packed == 0) {
1822                     if (tokenId >= _currentIndex) revert OwnerQueryForNonexistentToken();
1823                     // Invariant:
1824                     // There will always be an initialized ownership slot
1825                     // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1826                     // before an unintialized ownership slot
1827                     // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1828                     // Hence, `tokenId` will not underflow.
1829                     //
1830                     // We can directly compare the packed value.
1831                     // If the address is zero, packed will be zero.
1832                     for (;;) {
1833                         unchecked {
1834                             packed = _packedOwnerships[--tokenId];
1835                         }
1836                         if (packed == 0) continue;
1837                         return packed;
1838                     }
1839                 }
1840                 // Otherwise, the data exists and is not burned. We can skip the scan.
1841                 // This is possible because we have already achieved the target condition.
1842                 // This saves 2143 gas on transfers of initialized tokens.
1843                 return packed;
1844             }
1845         }
1846         revert OwnerQueryForNonexistentToken();
1847     }
1848 
1849     /**
1850      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1851      */
1852     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1853         ownership.addr = address(uint160(packed));
1854         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1855         ownership.burned = packed & _BITMASK_BURNED != 0;
1856         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1857     }
1858 
1859     /**
1860      * @dev Packs ownership data into a single uint256.
1861      */
1862     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1863         assembly {
1864             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1865             owner := and(owner, _BITMASK_ADDRESS)
1866             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1867             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1868         }
1869     }
1870 
1871     /**
1872      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1873      */
1874     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1875         // For branchless setting of the `nextInitialized` flag.
1876         assembly {
1877             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1878             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1879         }
1880     }
1881 
1882     // =============================================================
1883     //                      APPROVAL OPERATIONS
1884     // =============================================================
1885 
1886     /**
1887      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1888      *
1889      * Requirements:
1890      *
1891      * - The caller must own the token or be an approved operator.
1892      */
1893     function approve(address to, uint256 tokenId) public payable virtual override {
1894         _approve(to, tokenId, true);
1895     }
1896 
1897     /**
1898      * @dev Returns the account approved for `tokenId` token.
1899      *
1900      * Requirements:
1901      *
1902      * - `tokenId` must exist.
1903      */
1904     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1905         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1906 
1907         return _tokenApprovals[tokenId].value;
1908     }
1909 
1910     /**
1911      * @dev Approve or remove `operator` as an operator for the caller.
1912      * Operators can call {transferFrom} or {safeTransferFrom}
1913      * for any token owned by the caller.
1914      *
1915      * Requirements:
1916      *
1917      * - The `operator` cannot be the caller.
1918      *
1919      * Emits an {ApprovalForAll} event.
1920      */
1921     function setApprovalForAll(address operator, bool approved) public virtual override {
1922         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1923         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1924     }
1925 
1926     /**
1927      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1928      *
1929      * See {setApprovalForAll}.
1930      */
1931     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1932         return _operatorApprovals[owner][operator];
1933     }
1934 
1935     /**
1936      * @dev Returns whether `tokenId` exists.
1937      *
1938      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1939      *
1940      * Tokens start existing when they are minted. See {_mint}.
1941      */
1942     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1943         return
1944             _startTokenId() <= tokenId &&
1945             tokenId < _currentIndex && // If within bounds,
1946             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1947     }
1948 
1949     /**
1950      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1951      */
1952     function _isSenderApprovedOrOwner(
1953         address approvedAddress,
1954         address owner,
1955         address msgSender
1956     ) private pure returns (bool result) {
1957         assembly {
1958             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1959             owner := and(owner, _BITMASK_ADDRESS)
1960             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1961             msgSender := and(msgSender, _BITMASK_ADDRESS)
1962             // `msgSender == owner || msgSender == approvedAddress`.
1963             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1964         }
1965     }
1966 
1967     /**
1968      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1969      */
1970     function _getApprovedSlotAndAddress(uint256 tokenId)
1971         private
1972         view
1973         returns (uint256 approvedAddressSlot, address approvedAddress)
1974     {
1975         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1976         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1977         assembly {
1978             approvedAddressSlot := tokenApproval.slot
1979             approvedAddress := sload(approvedAddressSlot)
1980         }
1981     }
1982 
1983     // =============================================================
1984     //                      TRANSFER OPERATIONS
1985     // =============================================================
1986 
1987     /**
1988      * @dev Transfers `tokenId` from `from` to `to`.
1989      *
1990      * Requirements:
1991      *
1992      * - `from` cannot be the zero address.
1993      * - `to` cannot be the zero address.
1994      * - `tokenId` token must be owned by `from`.
1995      * - If the caller is not `from`, it must be approved to move this token
1996      * by either {approve} or {setApprovalForAll}.
1997      *
1998      * Emits a {Transfer} event.
1999      */
2000     function transferFrom(
2001         address from,
2002         address to,
2003         uint256 tokenId
2004     ) public payable virtual override {
2005         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2006 
2007         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2008 
2009         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2010 
2011         // The nested ifs save around 20+ gas over a compound boolean condition.
2012         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2013             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2014 
2015         if (to == address(0)) revert TransferToZeroAddress();
2016 
2017         _beforeTokenTransfers(from, to, tokenId, 1);
2018 
2019         // Clear approvals from the previous owner.
2020         assembly {
2021             if approvedAddress {
2022                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2023                 sstore(approvedAddressSlot, 0)
2024             }
2025         }
2026 
2027         // Underflow of the sender's balance is impossible because we check for
2028         // ownership above and the recipient's balance can't realistically overflow.
2029         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2030         unchecked {
2031             // We can directly increment and decrement the balances.
2032             --_packedAddressData[from]; // Updates: `balance -= 1`.
2033             ++_packedAddressData[to]; // Updates: `balance += 1`.
2034 
2035             // Updates:
2036             // - `address` to the next owner.
2037             // - `startTimestamp` to the timestamp of transfering.
2038             // - `burned` to `false`.
2039             // - `nextInitialized` to `true`.
2040             _packedOwnerships[tokenId] = _packOwnershipData(
2041                 to,
2042                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2043             );
2044 
2045             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2046             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2047                 uint256 nextTokenId = tokenId + 1;
2048                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2049                 if (_packedOwnerships[nextTokenId] == 0) {
2050                     // If the next slot is within bounds.
2051                     if (nextTokenId != _currentIndex) {
2052                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2053                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2054                     }
2055                 }
2056             }
2057         }
2058 
2059         emit Transfer(from, to, tokenId);
2060         _afterTokenTransfers(from, to, tokenId, 1);
2061     }
2062 
2063     /**
2064      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2065      */
2066     function safeTransferFrom(
2067         address from,
2068         address to,
2069         uint256 tokenId
2070     ) public payable virtual override {
2071         safeTransferFrom(from, to, tokenId, '');
2072     }
2073 
2074     /**
2075      * @dev Safely transfers `tokenId` token from `from` to `to`.
2076      *
2077      * Requirements:
2078      *
2079      * - `from` cannot be the zero address.
2080      * - `to` cannot be the zero address.
2081      * - `tokenId` token must exist and be owned by `from`.
2082      * - If the caller is not `from`, it must be approved to move this token
2083      * by either {approve} or {setApprovalForAll}.
2084      * - If `to` refers to a smart contract, it must implement
2085      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2086      *
2087      * Emits a {Transfer} event.
2088      */
2089     function safeTransferFrom(
2090         address from,
2091         address to,
2092         uint256 tokenId,
2093         bytes memory _data
2094     ) public payable virtual override {
2095         transferFrom(from, to, tokenId);
2096         if (to.code.length != 0)
2097             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2098                 revert TransferToNonERC721ReceiverImplementer();
2099             }
2100     }
2101 
2102     /**
2103      * @dev Hook that is called before a set of serially-ordered token IDs
2104      * are about to be transferred. This includes minting.
2105      * And also called before burning one token.
2106      *
2107      * `startTokenId` - the first token ID to be transferred.
2108      * `quantity` - the amount to be transferred.
2109      *
2110      * Calling conditions:
2111      *
2112      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2113      * transferred to `to`.
2114      * - When `from` is zero, `tokenId` will be minted for `to`.
2115      * - When `to` is zero, `tokenId` will be burned by `from`.
2116      * - `from` and `to` are never both zero.
2117      */
2118     function _beforeTokenTransfers(
2119         address from,
2120         address to,
2121         uint256 startTokenId,
2122         uint256 quantity
2123     ) internal virtual {}
2124 
2125     /**
2126      * @dev Hook that is called after a set of serially-ordered token IDs
2127      * have been transferred. This includes minting.
2128      * And also called after one token has been burned.
2129      *
2130      * `startTokenId` - the first token ID to be transferred.
2131      * `quantity` - the amount to be transferred.
2132      *
2133      * Calling conditions:
2134      *
2135      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2136      * transferred to `to`.
2137      * - When `from` is zero, `tokenId` has been minted for `to`.
2138      * - When `to` is zero, `tokenId` has been burned by `from`.
2139      * - `from` and `to` are never both zero.
2140      */
2141     function _afterTokenTransfers(
2142         address from,
2143         address to,
2144         uint256 startTokenId,
2145         uint256 quantity
2146     ) internal virtual {}
2147 
2148     /**
2149      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2150      *
2151      * `from` - Previous owner of the given token ID.
2152      * `to` - Target address that will receive the token.
2153      * `tokenId` - Token ID to be transferred.
2154      * `_data` - Optional data to send along with the call.
2155      *
2156      * Returns whether the call correctly returned the expected magic value.
2157      */
2158     function _checkContractOnERC721Received(
2159         address from,
2160         address to,
2161         uint256 tokenId,
2162         bytes memory _data
2163     ) private returns (bool) {
2164         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2165             bytes4 retval
2166         ) {
2167             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2168         } catch (bytes memory reason) {
2169             if (reason.length == 0) {
2170                 revert TransferToNonERC721ReceiverImplementer();
2171             } else {
2172                 assembly {
2173                     revert(add(32, reason), mload(reason))
2174                 }
2175             }
2176         }
2177     }
2178 
2179     // =============================================================
2180     //                        MINT OPERATIONS
2181     // =============================================================
2182 
2183     /**
2184      * @dev Mints `quantity` tokens and transfers them to `to`.
2185      *
2186      * Requirements:
2187      *
2188      * - `to` cannot be the zero address.
2189      * - `quantity` must be greater than 0.
2190      *
2191      * Emits a {Transfer} event for each mint.
2192      */
2193     function _mint(address to, uint256 quantity) internal virtual {
2194         uint256 startTokenId = _currentIndex;
2195         if (quantity == 0) revert MintZeroQuantity();
2196 
2197         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2198 
2199         // Overflows are incredibly unrealistic.
2200         // `balance` and `numberMinted` have a maximum limit of 2**64.
2201         // `tokenId` has a maximum limit of 2**256.
2202         unchecked {
2203             // Updates:
2204             // - `balance += quantity`.
2205             // - `numberMinted += quantity`.
2206             //
2207             // We can directly add to the `balance` and `numberMinted`.
2208             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2209 
2210             // Updates:
2211             // - `address` to the owner.
2212             // - `startTimestamp` to the timestamp of minting.
2213             // - `burned` to `false`.
2214             // - `nextInitialized` to `quantity == 1`.
2215             _packedOwnerships[startTokenId] = _packOwnershipData(
2216                 to,
2217                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2218             );
2219 
2220             uint256 toMasked;
2221             uint256 end = startTokenId + quantity;
2222 
2223             // Use assembly to loop and emit the `Transfer` event for gas savings.
2224             // The duplicated `log4` removes an extra check and reduces stack juggling.
2225             // The assembly, together with the surrounding Solidity code, have been
2226             // delicately arranged to nudge the compiler into producing optimized opcodes.
2227             assembly {
2228                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2229                 toMasked := and(to, _BITMASK_ADDRESS)
2230                 // Emit the `Transfer` event.
2231                 log4(
2232                     0, // Start of data (0, since no data).
2233                     0, // End of data (0, since no data).
2234                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2235                     0, // `address(0)`.
2236                     toMasked, // `to`.
2237                     startTokenId // `tokenId`.
2238                 )
2239 
2240                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2241                 // that overflows uint256 will make the loop run out of gas.
2242                 // The compiler will optimize the `iszero` away for performance.
2243                 for {
2244                     let tokenId := add(startTokenId, 1)
2245                 } iszero(eq(tokenId, end)) {
2246                     tokenId := add(tokenId, 1)
2247                 } {
2248                     // Emit the `Transfer` event. Similar to above.
2249                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2250                 }
2251             }
2252             if (toMasked == 0) revert MintToZeroAddress();
2253 
2254             _currentIndex = end;
2255         }
2256         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2257     }
2258 
2259     /**
2260      * @dev Mints `quantity` tokens and transfers them to `to`.
2261      *
2262      * This function is intended for efficient minting only during contract creation.
2263      *
2264      * It emits only one {ConsecutiveTransfer} as defined in
2265      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2266      * instead of a sequence of {Transfer} event(s).
2267      *
2268      * Calling this function outside of contract creation WILL make your contract
2269      * non-compliant with the ERC721 standard.
2270      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2271      * {ConsecutiveTransfer} event is only permissible during contract creation.
2272      *
2273      * Requirements:
2274      *
2275      * - `to` cannot be the zero address.
2276      * - `quantity` must be greater than 0.
2277      *
2278      * Emits a {ConsecutiveTransfer} event.
2279      */
2280     function _mintERC2309(address to, uint256 quantity) internal virtual {
2281         uint256 startTokenId = _currentIndex;
2282         if (to == address(0)) revert MintToZeroAddress();
2283         if (quantity == 0) revert MintZeroQuantity();
2284         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2285 
2286         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2287 
2288         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2289         unchecked {
2290             // Updates:
2291             // - `balance += quantity`.
2292             // - `numberMinted += quantity`.
2293             //
2294             // We can directly add to the `balance` and `numberMinted`.
2295             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2296 
2297             // Updates:
2298             // - `address` to the owner.
2299             // - `startTimestamp` to the timestamp of minting.
2300             // - `burned` to `false`.
2301             // - `nextInitialized` to `quantity == 1`.
2302             _packedOwnerships[startTokenId] = _packOwnershipData(
2303                 to,
2304                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2305             );
2306 
2307             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2308 
2309             _currentIndex = startTokenId + quantity;
2310         }
2311         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2312     }
2313 
2314     /**
2315      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2316      *
2317      * Requirements:
2318      *
2319      * - If `to` refers to a smart contract, it must implement
2320      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2321      * - `quantity` must be greater than 0.
2322      *
2323      * See {_mint}.
2324      *
2325      * Emits a {Transfer} event for each mint.
2326      */
2327     function _safeMint(
2328         address to,
2329         uint256 quantity,
2330         bytes memory _data
2331     ) internal virtual {
2332         _mint(to, quantity);
2333 
2334         unchecked {
2335             if (to.code.length != 0) {
2336                 uint256 end = _currentIndex;
2337                 uint256 index = end - quantity;
2338                 do {
2339                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2340                         revert TransferToNonERC721ReceiverImplementer();
2341                     }
2342                 } while (index < end);
2343                 // Reentrancy protection.
2344                 if (_currentIndex != end) revert();
2345             }
2346         }
2347     }
2348 
2349     /**
2350      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2351      */
2352     function _safeMint(address to, uint256 quantity) internal virtual {
2353         _safeMint(to, quantity, '');
2354     }
2355 
2356     // =============================================================
2357     //                       APPROVAL OPERATIONS
2358     // =============================================================
2359 
2360     /**
2361      * @dev Equivalent to `_approve(to, tokenId, false)`.
2362      */
2363     function _approve(address to, uint256 tokenId) internal virtual {
2364         _approve(to, tokenId, false);
2365     }
2366 
2367     /**
2368      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2369      * The approval is cleared when the token is transferred.
2370      *
2371      * Only a single account can be approved at a time, so approving the
2372      * zero address clears previous approvals.
2373      *
2374      * Requirements:
2375      *
2376      * - `tokenId` must exist.
2377      *
2378      * Emits an {Approval} event.
2379      */
2380     function _approve(
2381         address to,
2382         uint256 tokenId,
2383         bool approvalCheck
2384     ) internal virtual {
2385         address owner = ownerOf(tokenId);
2386 
2387         if (approvalCheck)
2388             if (_msgSenderERC721A() != owner)
2389                 if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2390                     revert ApprovalCallerNotOwnerNorApproved();
2391                 }
2392 
2393         _tokenApprovals[tokenId].value = to;
2394         emit Approval(owner, to, tokenId);
2395     }
2396 
2397     // =============================================================
2398     //                        BURN OPERATIONS
2399     // =============================================================
2400 
2401     /**
2402      * @dev Equivalent to `_burn(tokenId, false)`.
2403      */
2404     function _burn(uint256 tokenId) internal virtual {
2405         _burn(tokenId, false);
2406     }
2407 
2408     /**
2409      * @dev Destroys `tokenId`.
2410      * The approval is cleared when the token is burned.
2411      *
2412      * Requirements:
2413      *
2414      * - `tokenId` must exist.
2415      *
2416      * Emits a {Transfer} event.
2417      */
2418     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2419         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2420 
2421         address from = address(uint160(prevOwnershipPacked));
2422 
2423         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2424 
2425         if (approvalCheck) {
2426             // The nested ifs save around 20+ gas over a compound boolean condition.
2427             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2428                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2429         }
2430 
2431         _beforeTokenTransfers(from, address(0), tokenId, 1);
2432 
2433         // Clear approvals from the previous owner.
2434         assembly {
2435             if approvedAddress {
2436                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2437                 sstore(approvedAddressSlot, 0)
2438             }
2439         }
2440 
2441         // Underflow of the sender's balance is impossible because we check for
2442         // ownership above and the recipient's balance can't realistically overflow.
2443         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2444         unchecked {
2445             // Updates:
2446             // - `balance -= 1`.
2447             // - `numberBurned += 1`.
2448             //
2449             // We can directly decrement the balance, and increment the number burned.
2450             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2451             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2452 
2453             // Updates:
2454             // - `address` to the last owner.
2455             // - `startTimestamp` to the timestamp of burning.
2456             // - `burned` to `true`.
2457             // - `nextInitialized` to `true`.
2458             _packedOwnerships[tokenId] = _packOwnershipData(
2459                 from,
2460                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2461             );
2462 
2463             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2464             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2465                 uint256 nextTokenId = tokenId + 1;
2466                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2467                 if (_packedOwnerships[nextTokenId] == 0) {
2468                     // If the next slot is within bounds.
2469                     if (nextTokenId != _currentIndex) {
2470                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2471                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2472                     }
2473                 }
2474             }
2475         }
2476 
2477         emit Transfer(from, address(0), tokenId);
2478         _afterTokenTransfers(from, address(0), tokenId, 1);
2479 
2480         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2481         unchecked {
2482             _burnCounter++;
2483         }
2484     }
2485 
2486     // =============================================================
2487     //                     EXTRA DATA OPERATIONS
2488     // =============================================================
2489 
2490     /**
2491      * @dev Directly sets the extra data for the ownership data `index`.
2492      */
2493     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2494         uint256 packed = _packedOwnerships[index];
2495         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2496         uint256 extraDataCasted;
2497         // Cast `extraData` with assembly to avoid redundant masking.
2498         assembly {
2499             extraDataCasted := extraData
2500         }
2501         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2502         _packedOwnerships[index] = packed;
2503     }
2504 
2505     /**
2506      * @dev Called during each token transfer to set the 24bit `extraData` field.
2507      * Intended to be overridden by the cosumer contract.
2508      *
2509      * `previousExtraData` - the value of `extraData` before transfer.
2510      *
2511      * Calling conditions:
2512      *
2513      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2514      * transferred to `to`.
2515      * - When `from` is zero, `tokenId` will be minted for `to`.
2516      * - When `to` is zero, `tokenId` will be burned by `from`.
2517      * - `from` and `to` are never both zero.
2518      */
2519     function _extraData(
2520         address from,
2521         address to,
2522         uint24 previousExtraData
2523     ) internal view virtual returns (uint24) {}
2524 
2525     /**
2526      * @dev Returns the next extra data for the packed ownership data.
2527      * The returned result is shifted into position.
2528      */
2529     function _nextExtraData(
2530         address from,
2531         address to,
2532         uint256 prevOwnershipPacked
2533     ) private view returns (uint256) {
2534         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2535         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2536     }
2537 
2538     // =============================================================
2539     //                       OTHER OPERATIONS
2540     // =============================================================
2541 
2542     /**
2543      * @dev Returns the message sender (defaults to `msg.sender`).
2544      *
2545      * If you are writing GSN compatible contracts, you need to override this function.
2546      */
2547     function _msgSenderERC721A() internal view virtual returns (address) {
2548         return msg.sender;
2549     }
2550 
2551     /**
2552      * @dev Converts a uint256 to its ASCII string decimal representation.
2553      */
2554     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2555         assembly {
2556             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2557             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2558             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2559             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2560             let m := add(mload(0x40), 0xa0)
2561             // Update the free memory pointer to allocate.
2562             mstore(0x40, m)
2563             // Assign the `str` to the end.
2564             str := sub(m, 0x20)
2565             // Zeroize the slot after the string.
2566             mstore(str, 0)
2567 
2568             // Cache the end of the memory to calculate the length later.
2569             let end := str
2570 
2571             // We write the string from rightmost digit to leftmost digit.
2572             // The following is essentially a do-while loop that also handles the zero case.
2573             // prettier-ignore
2574             for { let temp := value } 1 {} {
2575                 str := sub(str, 1)
2576                 // Write the character to the pointer.
2577                 // The ASCII index of the '0' character is 48.
2578                 mstore8(str, add(48, mod(temp, 10)))
2579                 // Keep dividing `temp` until zero.
2580                 temp := div(temp, 10)
2581                 // prettier-ignore
2582                 if iszero(temp) { break }
2583             }
2584 
2585             let length := sub(end, str)
2586             // Move the pointer 32 bytes leftwards to make room for the length.
2587             str := sub(str, 0x20)
2588             // Store the length.
2589             mstore(str, length)
2590         }
2591     }
2592 }
2593 
2594 // File: https://github.com/chiru-labs/ERC721A/blob/2342b592d990a7710faf40fe66cfa1ce61dd2339/contracts/extensions/ERC721AQueryable.sol
2595 
2596 
2597 // ERC721A Contracts v4.2.3
2598 // Creator: Chiru Labs
2599 
2600 pragma solidity ^0.8.4;
2601 
2602 
2603 
2604 /**
2605  * @title ERC721AQueryable.
2606  *
2607  * @dev ERC721A subclass with convenience query functions.
2608  */
2609 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2610     /**
2611      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2612      *
2613      * If the `tokenId` is out of bounds:
2614      *
2615      * - `addr = address(0)`
2616      * - `startTimestamp = 0`
2617      * - `burned = false`
2618      * - `extraData = 0`
2619      *
2620      * If the `tokenId` is burned:
2621      *
2622      * - `addr = <Address of owner before token was burned>`
2623      * - `startTimestamp = <Timestamp when token was burned>`
2624      * - `burned = true`
2625      * - `extraData = <Extra data when token was burned>`
2626      *
2627      * Otherwise:
2628      *
2629      * - `addr = <Address of owner>`
2630      * - `startTimestamp = <Timestamp of start of ownership>`
2631      * - `burned = false`
2632      * - `extraData = <Extra data at start of ownership>`
2633      */
2634     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2635         TokenOwnership memory ownership;
2636         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2637             return ownership;
2638         }
2639         ownership = _ownershipAt(tokenId);
2640         if (ownership.burned) {
2641             return ownership;
2642         }
2643         return _ownershipOf(tokenId);
2644     }
2645 
2646     /**
2647      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2648      * See {ERC721AQueryable-explicitOwnershipOf}
2649      */
2650     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2651         external
2652         view
2653         virtual
2654         override
2655         returns (TokenOwnership[] memory)
2656     {
2657         unchecked {
2658             uint256 tokenIdsLength = tokenIds.length;
2659             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2660             for (uint256 i; i != tokenIdsLength; ++i) {
2661                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2662             }
2663             return ownerships;
2664         }
2665     }
2666 
2667     /**
2668      * @dev Returns an array of token IDs owned by `owner`,
2669      * in the range [`start`, `stop`)
2670      * (i.e. `start <= tokenId < stop`).
2671      *
2672      * This function allows for tokens to be queried if the collection
2673      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2674      *
2675      * Requirements:
2676      *
2677      * - `start < stop`
2678      */
2679     function tokensOfOwnerIn(
2680         address owner,
2681         uint256 start,
2682         uint256 stop
2683     ) external view virtual override returns (uint256[] memory) {
2684         unchecked {
2685             if (start >= stop) revert InvalidQueryRange();
2686             uint256 tokenIdsIdx;
2687             uint256 stopLimit = _nextTokenId();
2688             // Set `start = max(start, _startTokenId())`.
2689             if (start < _startTokenId()) {
2690                 start = _startTokenId();
2691             }
2692             // Set `stop = min(stop, stopLimit)`.
2693             if (stop > stopLimit) {
2694                 stop = stopLimit;
2695             }
2696             uint256 tokenIdsMaxLength = balanceOf(owner);
2697             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2698             // to cater for cases where `balanceOf(owner)` is too big.
2699             if (start < stop) {
2700                 uint256 rangeLength = stop - start;
2701                 if (rangeLength < tokenIdsMaxLength) {
2702                     tokenIdsMaxLength = rangeLength;
2703                 }
2704             } else {
2705                 tokenIdsMaxLength = 0;
2706             }
2707             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2708             if (tokenIdsMaxLength == 0) {
2709                 return tokenIds;
2710             }
2711             // We need to call `explicitOwnershipOf(start)`,
2712             // because the slot at `start` may not be initialized.
2713             TokenOwnership memory ownership = explicitOwnershipOf(start);
2714             address currOwnershipAddr;
2715             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2716             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2717             if (!ownership.burned) {
2718                 currOwnershipAddr = ownership.addr;
2719             }
2720             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2721                 ownership = _ownershipAt(i);
2722                 if (ownership.burned) {
2723                     continue;
2724                 }
2725                 if (ownership.addr != address(0)) {
2726                     currOwnershipAddr = ownership.addr;
2727                 }
2728                 if (currOwnershipAddr == owner) {
2729                     tokenIds[tokenIdsIdx++] = i;
2730                 }
2731             }
2732             // Downsize the array to fit.
2733             assembly {
2734                 mstore(tokenIds, tokenIdsIdx)
2735             }
2736             return tokenIds;
2737         }
2738     }
2739 
2740     /**
2741      * @dev Returns an array of token IDs owned by `owner`.
2742      *
2743      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2744      * It is meant to be called off-chain.
2745      *
2746      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2747      * multiple smaller scans if the collection is large enough to cause
2748      * an out-of-gas error (10K collections should be fine).
2749      */
2750     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2751         unchecked {
2752             uint256 tokenIdsIdx;
2753             address currOwnershipAddr;
2754             uint256 tokenIdsLength = balanceOf(owner);
2755             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2756             TokenOwnership memory ownership;
2757             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2758                 ownership = _ownershipAt(i);
2759                 if (ownership.burned) {
2760                     continue;
2761                 }
2762                 if (ownership.addr != address(0)) {
2763                     currOwnershipAddr = ownership.addr;
2764                 }
2765                 if (currOwnershipAddr == owner) {
2766                     tokenIds[tokenIdsIdx++] = i;
2767                 }
2768             }
2769             return tokenIds;
2770         }
2771     }
2772 }
2773 
2774 // File: contracts/SpringfieldApes.sol
2775 
2776 
2777 pragma solidity ^0.8.17;
2778 
2779 contract SpringfieldApes is ERC721A, DefaultOperatorFilterer, Ownable {
2780     using SafeMath for uint256;
2781     using Strings for uint256;
2782 
2783     uint256 public constant MAX_TOKENS = 5000;
2784     uint256 public price = 0.04 ether;
2785     uint256 public presalePrice = 0.03 ether;
2786     uint256 public maxPerALWallet = 3;
2787     uint256 public maxPerWallet = 3;
2788 
2789     address public constant w1 = 0x6bd2C84ad25148988B5087e5Dfc55Ba022D963e8;
2790     address public constant w2 = 0xA8ebD0C99a8734ce3EdCa0beA70F1DE3B808e11d;
2791     address public constant w3 = 0x1631592F0f1F835daA7515d9488AB3D8652D4Ab3;
2792 
2793     bool public publicSaleStarted = false;
2794     bool public presaleStarted = false;
2795 
2796     mapping(address => uint256) private _walletMints;
2797     mapping(address => uint256) private _ALWalletMints;
2798 
2799     string public baseURI = "";
2800     bytes32 public merkleRoot;
2801 
2802     constructor() ERC721A("Springfield Apes", "SAPES") {
2803     }
2804 
2805     function presaleMinted(address owner) public view returns (uint256) {
2806         return _ALWalletMints[owner];
2807     }
2808 
2809     function publicMinted(address owner) public view returns (uint256) {
2810         return _walletMints[owner];
2811     }
2812 
2813     function togglePresaleStarted() external onlyOwner {
2814         presaleStarted = !presaleStarted;
2815     }
2816 
2817     function togglePublicSaleStarted() external onlyOwner {
2818         publicSaleStarted = !publicSaleStarted;
2819     }
2820 
2821     function setMaxPerWallet(uint256 _newMaxPerWallet) external onlyOwner {
2822         maxPerWallet = _newMaxPerWallet;
2823     }
2824 
2825     function setMaxPerALWallet(uint256 _newMaxPerALWallet) external onlyOwner {
2826         maxPerALWallet = _newMaxPerALWallet;
2827     }
2828 
2829     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2830         baseURI = _newBaseURI;
2831     }
2832 
2833     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2834         merkleRoot = _merkleRoot;
2835     }
2836 
2837     function _baseURI() internal view override returns (string memory) {
2838         return baseURI;
2839     }
2840 
2841     function _startTokenId() internal pure override returns (uint256) {
2842         return 1;
2843     }
2844     
2845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2846         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
2847 
2848 	    string memory currentBaseURI = _baseURI();
2849 	    return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json")) : "";
2850     }
2851 
2852     function internalMint(address teamAddress, uint256 _teamAmount) external onlyOwner  {
2853         require(totalSupply() + _teamAmount <= MAX_TOKENS, "Max supply exceeded!");
2854         _safeMint(teamAddress, _teamAmount);
2855     }
2856 
2857     function mintAllowlist(uint256 tokens, bytes32[] calldata merkleProof) external payable {
2858         require(presaleStarted, "Sale has not started");
2859         require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Not on the allowlist");
2860         require(totalSupply() + tokens <= MAX_TOKENS, "Minting would exceed max supply");
2861         require(tokens > 0, "Must mint at least one Springfield Ape");
2862         require(_ALWalletMints[_msgSender()] + tokens <= maxPerALWallet, "AL limit for this wallet reached");
2863         require(presalePrice * tokens <= msg.value, "Not enough ETH");
2864 
2865         _ALWalletMints[_msgSender()] += tokens;
2866         _safeMint(_msgSender(), tokens);
2867     }
2868 
2869     function mint(uint256 tokens) external payable {
2870         require(publicSaleStarted, "Sale has not started");
2871         require(totalSupply() + tokens <= MAX_TOKENS, "Minting would exceed max supply");
2872         require(tokens > 0, "Must mint at least one Springfield Ape");
2873         require(_walletMints[_msgSender()] + tokens <= maxPerWallet, "Limit for this wallet reached");
2874         require(price * tokens <= msg.value, "Not enough ETH");
2875 
2876         _walletMints[_msgSender()] += tokens;
2877         _safeMint(_msgSender(), tokens);
2878     }
2879 
2880     function withdrawAll() public onlyOwner {
2881         uint256 balance = address(this).balance;
2882         require(balance > 0, "Insufficent balance");
2883         _withdraw(w1, ((balance * 34) / 100)); // 34%
2884         _withdraw(w2, ((balance * 33) / 100)); // 33%
2885         _withdraw(w3, ((balance * 33) / 100)); // 33%
2886     }
2887 
2888     function _withdraw(address _address, uint256 _amount) private {
2889         (bool success, ) = _address.call{value: _amount}("");
2890         require(success, "Failed to withdraw Ether");
2891     }
2892 
2893     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2894         super.setApprovalForAll(operator, approved);
2895     }
2896 
2897     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2898         super.approve(operator, tokenId);
2899     }
2900 
2901     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2902         super.transferFrom(from, to, tokenId);
2903     }
2904 
2905     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2906         super.safeTransferFrom(from, to, tokenId);
2907     }
2908 
2909     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
2910         super.safeTransferFrom(from, to, tokenId, data);
2911     }
2912 
2913 
2914 }