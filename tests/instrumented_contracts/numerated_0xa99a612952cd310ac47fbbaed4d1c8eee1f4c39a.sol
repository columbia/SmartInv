1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The tree and the proofs can be generated using our
12  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
13  * You will find a quickstart guide in the readme.
14  *
15  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
16  * hashing, or use a hash function other than keccak256 for hashing leaves.
17  * This is because the concatenation of a sorted pair of internal nodes in
18  * the merkle tree could be reinterpreted as a leaf value.
19  * OpenZeppelin's JavaScript library generates merkle trees that are safe
20  * against this attack out of the box.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
84      *
85      * _Available since v4.7._
86      */
87     function multiProofVerify(
88         bytes32[] memory proof,
89         bool[] memory proofFlags,
90         bytes32 root,
91         bytes32[] memory leaves
92     ) internal pure returns (bool) {
93         return processMultiProof(proof, proofFlags, leaves) == root;
94     }
95 
96     /**
97      * @dev Calldata version of {multiProofVerify}
98      *
99      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
100      *
101      * _Available since v4.7._
102      */
103     function multiProofVerifyCalldata(
104         bytes32[] calldata proof,
105         bool[] calldata proofFlags,
106         bytes32 root,
107         bytes32[] memory leaves
108     ) internal pure returns (bool) {
109         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
110     }
111 
112     /**
113      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
114      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
115      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
116      * respectively.
117      *
118      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
119      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
120      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
121      *
122      * _Available since v4.7._
123      */
124     function processMultiProof(
125         bytes32[] memory proof,
126         bool[] memory proofFlags,
127         bytes32[] memory leaves
128     ) internal pure returns (bytes32 merkleRoot) {
129         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
130         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
131         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
132         // the merkle tree.
133         uint256 leavesLen = leaves.length;
134         uint256 totalHashes = proofFlags.length;
135 
136         // Check proof validity.
137         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
138 
139         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
140         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
141         bytes32[] memory hashes = new bytes32[](totalHashes);
142         uint256 leafPos = 0;
143         uint256 hashPos = 0;
144         uint256 proofPos = 0;
145         // At each step, we compute the next hash using two values:
146         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
147         //   get the next hash.
148         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
149         //   `proof` array.
150         for (uint256 i = 0; i < totalHashes; i++) {
151             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
152             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
153             hashes[i] = _hashPair(a, b);
154         }
155 
156         if (totalHashes > 0) {
157             return hashes[totalHashes - 1];
158         } else if (leavesLen > 0) {
159             return leaves[0];
160         } else {
161             return proof[0];
162         }
163     }
164 
165     /**
166      * @dev Calldata version of {processMultiProof}.
167      *
168      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
169      *
170      * _Available since v4.7._
171      */
172     function processMultiProofCalldata(
173         bytes32[] calldata proof,
174         bool[] calldata proofFlags,
175         bytes32[] memory leaves
176     ) internal pure returns (bytes32 merkleRoot) {
177         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
178         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
179         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
180         // the merkle tree.
181         uint256 leavesLen = leaves.length;
182         uint256 totalHashes = proofFlags.length;
183 
184         // Check proof validity.
185         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
186 
187         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
188         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
189         bytes32[] memory hashes = new bytes32[](totalHashes);
190         uint256 leafPos = 0;
191         uint256 hashPos = 0;
192         uint256 proofPos = 0;
193         // At each step, we compute the next hash using two values:
194         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
195         //   get the next hash.
196         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
197         //   `proof` array.
198         for (uint256 i = 0; i < totalHashes; i++) {
199             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
200             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
201             hashes[i] = _hashPair(a, b);
202         }
203 
204         if (totalHashes > 0) {
205             return hashes[totalHashes - 1];
206         } else if (leavesLen > 0) {
207             return leaves[0];
208         } else {
209             return proof[0];
210         }
211     }
212 
213     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
214         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
215     }
216 
217     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
218         /// @solidity memory-safe-assembly
219         assembly {
220             mstore(0x00, a)
221             mstore(0x20, b)
222             value := keccak256(0x00, 0x40)
223         }
224     }
225 }
226 
227 // File: @openzeppelin/contracts/utils/math/Math.sol
228 
229 
230 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Standard math utilities missing in the Solidity language.
236  */
237 library Math {
238     enum Rounding {
239         Down, // Toward negative infinity
240         Up, // Toward infinity
241         Zero // Toward zero
242     }
243 
244     /**
245      * @dev Returns the largest of two numbers.
246      */
247     function max(uint256 a, uint256 b) internal pure returns (uint256) {
248         return a > b ? a : b;
249     }
250 
251     /**
252      * @dev Returns the smallest of two numbers.
253      */
254     function min(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a < b ? a : b;
256     }
257 
258     /**
259      * @dev Returns the average of two numbers. The result is rounded towards
260      * zero.
261      */
262     function average(uint256 a, uint256 b) internal pure returns (uint256) {
263         // (a + b) / 2 can overflow.
264         return (a & b) + (a ^ b) / 2;
265     }
266 
267     /**
268      * @dev Returns the ceiling of the division of two numbers.
269      *
270      * This differs from standard division with `/` in that it rounds up instead
271      * of rounding down.
272      */
273     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
274         // (a + b - 1) / b can overflow on addition, so we distribute.
275         return a == 0 ? 0 : (a - 1) / b + 1;
276     }
277 
278     /**
279      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
280      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
281      * with further edits by Uniswap Labs also under MIT license.
282      */
283     function mulDiv(
284         uint256 x,
285         uint256 y,
286         uint256 denominator
287     ) internal pure returns (uint256 result) {
288         unchecked {
289             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
290             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
291             // variables such that product = prod1 * 2^256 + prod0.
292             uint256 prod0; // Least significant 256 bits of the product
293             uint256 prod1; // Most significant 256 bits of the product
294             assembly {
295                 let mm := mulmod(x, y, not(0))
296                 prod0 := mul(x, y)
297                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
298             }
299 
300             // Handle non-overflow cases, 256 by 256 division.
301             if (prod1 == 0) {
302                 return prod0 / denominator;
303             }
304 
305             // Make sure the result is less than 2^256. Also prevents denominator == 0.
306             require(denominator > prod1);
307 
308             ///////////////////////////////////////////////
309             // 512 by 256 division.
310             ///////////////////////////////////////////////
311 
312             // Make division exact by subtracting the remainder from [prod1 prod0].
313             uint256 remainder;
314             assembly {
315                 // Compute remainder using mulmod.
316                 remainder := mulmod(x, y, denominator)
317 
318                 // Subtract 256 bit number from 512 bit number.
319                 prod1 := sub(prod1, gt(remainder, prod0))
320                 prod0 := sub(prod0, remainder)
321             }
322 
323             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
324             // See https://cs.stackexchange.com/q/138556/92363.
325 
326             // Does not overflow because the denominator cannot be zero at this stage in the function.
327             uint256 twos = denominator & (~denominator + 1);
328             assembly {
329                 // Divide denominator by twos.
330                 denominator := div(denominator, twos)
331 
332                 // Divide [prod1 prod0] by twos.
333                 prod0 := div(prod0, twos)
334 
335                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
336                 twos := add(div(sub(0, twos), twos), 1)
337             }
338 
339             // Shift in bits from prod1 into prod0.
340             prod0 |= prod1 * twos;
341 
342             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
343             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
344             // four bits. That is, denominator * inv = 1 mod 2^4.
345             uint256 inverse = (3 * denominator) ^ 2;
346 
347             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
348             // in modular arithmetic, doubling the correct bits in each step.
349             inverse *= 2 - denominator * inverse; // inverse mod 2^8
350             inverse *= 2 - denominator * inverse; // inverse mod 2^16
351             inverse *= 2 - denominator * inverse; // inverse mod 2^32
352             inverse *= 2 - denominator * inverse; // inverse mod 2^64
353             inverse *= 2 - denominator * inverse; // inverse mod 2^128
354             inverse *= 2 - denominator * inverse; // inverse mod 2^256
355 
356             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
357             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
358             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
359             // is no longer required.
360             result = prod0 * inverse;
361             return result;
362         }
363     }
364 
365     /**
366      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
367      */
368     function mulDiv(
369         uint256 x,
370         uint256 y,
371         uint256 denominator,
372         Rounding rounding
373     ) internal pure returns (uint256) {
374         uint256 result = mulDiv(x, y, denominator);
375         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
376             result += 1;
377         }
378         return result;
379     }
380 
381     /**
382      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
383      *
384      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
385      */
386     function sqrt(uint256 a) internal pure returns (uint256) {
387         if (a == 0) {
388             return 0;
389         }
390 
391         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
392         //
393         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
394         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
395         //
396         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
397         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
398         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
399         //
400         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
401         uint256 result = 1 << (log2(a) >> 1);
402 
403         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
404         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
405         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
406         // into the expected uint128 result.
407         unchecked {
408             result = (result + a / result) >> 1;
409             result = (result + a / result) >> 1;
410             result = (result + a / result) >> 1;
411             result = (result + a / result) >> 1;
412             result = (result + a / result) >> 1;
413             result = (result + a / result) >> 1;
414             result = (result + a / result) >> 1;
415             return min(result, a / result);
416         }
417     }
418 
419     /**
420      * @notice Calculates sqrt(a), following the selected rounding direction.
421      */
422     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
423         unchecked {
424             uint256 result = sqrt(a);
425             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
426         }
427     }
428 
429     /**
430      * @dev Return the log in base 2, rounded down, of a positive value.
431      * Returns 0 if given 0.
432      */
433     function log2(uint256 value) internal pure returns (uint256) {
434         uint256 result = 0;
435         unchecked {
436             if (value >> 128 > 0) {
437                 value >>= 128;
438                 result += 128;
439             }
440             if (value >> 64 > 0) {
441                 value >>= 64;
442                 result += 64;
443             }
444             if (value >> 32 > 0) {
445                 value >>= 32;
446                 result += 32;
447             }
448             if (value >> 16 > 0) {
449                 value >>= 16;
450                 result += 16;
451             }
452             if (value >> 8 > 0) {
453                 value >>= 8;
454                 result += 8;
455             }
456             if (value >> 4 > 0) {
457                 value >>= 4;
458                 result += 4;
459             }
460             if (value >> 2 > 0) {
461                 value >>= 2;
462                 result += 2;
463             }
464             if (value >> 1 > 0) {
465                 result += 1;
466             }
467         }
468         return result;
469     }
470 
471     /**
472      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
473      * Returns 0 if given 0.
474      */
475     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
476         unchecked {
477             uint256 result = log2(value);
478             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
479         }
480     }
481 
482     /**
483      * @dev Return the log in base 10, rounded down, of a positive value.
484      * Returns 0 if given 0.
485      */
486     function log10(uint256 value) internal pure returns (uint256) {
487         uint256 result = 0;
488         unchecked {
489             if (value >= 10**64) {
490                 value /= 10**64;
491                 result += 64;
492             }
493             if (value >= 10**32) {
494                 value /= 10**32;
495                 result += 32;
496             }
497             if (value >= 10**16) {
498                 value /= 10**16;
499                 result += 16;
500             }
501             if (value >= 10**8) {
502                 value /= 10**8;
503                 result += 8;
504             }
505             if (value >= 10**4) {
506                 value /= 10**4;
507                 result += 4;
508             }
509             if (value >= 10**2) {
510                 value /= 10**2;
511                 result += 2;
512             }
513             if (value >= 10**1) {
514                 result += 1;
515             }
516         }
517         return result;
518     }
519 
520     /**
521      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
522      * Returns 0 if given 0.
523      */
524     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
525         unchecked {
526             uint256 result = log10(value);
527             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
528         }
529     }
530 
531     /**
532      * @dev Return the log in base 256, rounded down, of a positive value.
533      * Returns 0 if given 0.
534      *
535      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
536      */
537     function log256(uint256 value) internal pure returns (uint256) {
538         uint256 result = 0;
539         unchecked {
540             if (value >> 128 > 0) {
541                 value >>= 128;
542                 result += 16;
543             }
544             if (value >> 64 > 0) {
545                 value >>= 64;
546                 result += 8;
547             }
548             if (value >> 32 > 0) {
549                 value >>= 32;
550                 result += 4;
551             }
552             if (value >> 16 > 0) {
553                 value >>= 16;
554                 result += 2;
555             }
556             if (value >> 8 > 0) {
557                 result += 1;
558             }
559         }
560         return result;
561     }
562 
563     /**
564      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
565      * Returns 0 if given 0.
566      */
567     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
568         unchecked {
569             uint256 result = log256(value);
570             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
571         }
572     }
573 }
574 
575 // File: @openzeppelin/contracts/utils/Strings.sol
576 
577 
578 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @dev String operations.
585  */
586 library Strings {
587     bytes16 private constant _SYMBOLS = "0123456789abcdef";
588     uint8 private constant _ADDRESS_LENGTH = 20;
589 
590     /**
591      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
592      */
593     function toString(uint256 value) internal pure returns (string memory) {
594         unchecked {
595             uint256 length = Math.log10(value) + 1;
596             string memory buffer = new string(length);
597             uint256 ptr;
598             /// @solidity memory-safe-assembly
599             assembly {
600                 ptr := add(buffer, add(32, length))
601             }
602             while (true) {
603                 ptr--;
604                 /// @solidity memory-safe-assembly
605                 assembly {
606                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
607                 }
608                 value /= 10;
609                 if (value == 0) break;
610             }
611             return buffer;
612         }
613     }
614 
615     /**
616      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
617      */
618     function toHexString(uint256 value) internal pure returns (string memory) {
619         unchecked {
620             return toHexString(value, Math.log256(value) + 1);
621         }
622     }
623 
624     /**
625      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
626      */
627     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
628         bytes memory buffer = new bytes(2 * length + 2);
629         buffer[0] = "0";
630         buffer[1] = "x";
631         for (uint256 i = 2 * length + 1; i > 1; --i) {
632             buffer[i] = _SYMBOLS[value & 0xf];
633             value >>= 4;
634         }
635         require(value == 0, "Strings: hex length insufficient");
636         return string(buffer);
637     }
638 
639     /**
640      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
641      */
642     function toHexString(address addr) internal pure returns (string memory) {
643         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
644     }
645 }
646 
647 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
648 
649 
650 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 // CAUTION
655 // This version of SafeMath should only be used with Solidity 0.8 or later,
656 // because it relies on the compiler's built in overflow checks.
657 
658 /**
659  * @dev Wrappers over Solidity's arithmetic operations.
660  *
661  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
662  * now has built in overflow checking.
663  */
664 library SafeMath {
665     /**
666      * @dev Returns the addition of two unsigned integers, with an overflow flag.
667      *
668      * _Available since v3.4._
669      */
670     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
671         unchecked {
672             uint256 c = a + b;
673             if (c < a) return (false, 0);
674             return (true, c);
675         }
676     }
677 
678     /**
679      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
680      *
681      * _Available since v3.4._
682      */
683     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
684         unchecked {
685             if (b > a) return (false, 0);
686             return (true, a - b);
687         }
688     }
689 
690     /**
691      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
692      *
693      * _Available since v3.4._
694      */
695     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
696         unchecked {
697             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
698             // benefit is lost if 'b' is also tested.
699             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
700             if (a == 0) return (true, 0);
701             uint256 c = a * b;
702             if (c / a != b) return (false, 0);
703             return (true, c);
704         }
705     }
706 
707     /**
708      * @dev Returns the division of two unsigned integers, with a division by zero flag.
709      *
710      * _Available since v3.4._
711      */
712     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
713         unchecked {
714             if (b == 0) return (false, 0);
715             return (true, a / b);
716         }
717     }
718 
719     /**
720      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
721      *
722      * _Available since v3.4._
723      */
724     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
725         unchecked {
726             if (b == 0) return (false, 0);
727             return (true, a % b);
728         }
729     }
730 
731     /**
732      * @dev Returns the addition of two unsigned integers, reverting on
733      * overflow.
734      *
735      * Counterpart to Solidity's `+` operator.
736      *
737      * Requirements:
738      *
739      * - Addition cannot overflow.
740      */
741     function add(uint256 a, uint256 b) internal pure returns (uint256) {
742         return a + b;
743     }
744 
745     /**
746      * @dev Returns the subtraction of two unsigned integers, reverting on
747      * overflow (when the result is negative).
748      *
749      * Counterpart to Solidity's `-` operator.
750      *
751      * Requirements:
752      *
753      * - Subtraction cannot overflow.
754      */
755     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
756         return a - b;
757     }
758 
759     /**
760      * @dev Returns the multiplication of two unsigned integers, reverting on
761      * overflow.
762      *
763      * Counterpart to Solidity's `*` operator.
764      *
765      * Requirements:
766      *
767      * - Multiplication cannot overflow.
768      */
769     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
770         return a * b;
771     }
772 
773     /**
774      * @dev Returns the integer division of two unsigned integers, reverting on
775      * division by zero. The result is rounded towards zero.
776      *
777      * Counterpart to Solidity's `/` operator.
778      *
779      * Requirements:
780      *
781      * - The divisor cannot be zero.
782      */
783     function div(uint256 a, uint256 b) internal pure returns (uint256) {
784         return a / b;
785     }
786 
787     /**
788      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
789      * reverting when dividing by zero.
790      *
791      * Counterpart to Solidity's `%` operator. This function uses a `revert`
792      * opcode (which leaves remaining gas untouched) while Solidity uses an
793      * invalid opcode to revert (consuming all remaining gas).
794      *
795      * Requirements:
796      *
797      * - The divisor cannot be zero.
798      */
799     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
800         return a % b;
801     }
802 
803     /**
804      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
805      * overflow (when the result is negative).
806      *
807      * CAUTION: This function is deprecated because it requires allocating memory for the error
808      * message unnecessarily. For custom revert reasons use {trySub}.
809      *
810      * Counterpart to Solidity's `-` operator.
811      *
812      * Requirements:
813      *
814      * - Subtraction cannot overflow.
815      */
816     function sub(
817         uint256 a,
818         uint256 b,
819         string memory errorMessage
820     ) internal pure returns (uint256) {
821         unchecked {
822             require(b <= a, errorMessage);
823             return a - b;
824         }
825     }
826 
827     /**
828      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
829      * division by zero. The result is rounded towards zero.
830      *
831      * Counterpart to Solidity's `/` operator. Note: this function uses a
832      * `revert` opcode (which leaves remaining gas untouched) while Solidity
833      * uses an invalid opcode to revert (consuming all remaining gas).
834      *
835      * Requirements:
836      *
837      * - The divisor cannot be zero.
838      */
839     function div(
840         uint256 a,
841         uint256 b,
842         string memory errorMessage
843     ) internal pure returns (uint256) {
844         unchecked {
845             require(b > 0, errorMessage);
846             return a / b;
847         }
848     }
849 
850     /**
851      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
852      * reverting with custom message when dividing by zero.
853      *
854      * CAUTION: This function is deprecated because it requires allocating memory for the error
855      * message unnecessarily. For custom revert reasons use {tryMod}.
856      *
857      * Counterpart to Solidity's `%` operator. This function uses a `revert`
858      * opcode (which leaves remaining gas untouched) while Solidity uses an
859      * invalid opcode to revert (consuming all remaining gas).
860      *
861      * Requirements:
862      *
863      * - The divisor cannot be zero.
864      */
865     function mod(
866         uint256 a,
867         uint256 b,
868         string memory errorMessage
869     ) internal pure returns (uint256) {
870         unchecked {
871             require(b > 0, errorMessage);
872             return a % b;
873         }
874     }
875 }
876 
877 // File: @openzeppelin/contracts/utils/Context.sol
878 
879 
880 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
881 
882 pragma solidity ^0.8.0;
883 
884 /**
885  * @dev Provides information about the current execution context, including the
886  * sender of the transaction and its data. While these are generally available
887  * via msg.sender and msg.data, they should not be accessed in such a direct
888  * manner, since when dealing with meta-transactions the account sending and
889  * paying for execution may not be the actual sender (as far as an application
890  * is concerned).
891  *
892  * This contract is only required for intermediate, library-like contracts.
893  */
894 abstract contract Context {
895     function _msgSender() internal view virtual returns (address) {
896         return msg.sender;
897     }
898 
899     function _msgData() internal view virtual returns (bytes calldata) {
900         return msg.data;
901     }
902 }
903 
904 // File: @openzeppelin/contracts/access/Ownable.sol
905 
906 
907 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
908 
909 pragma solidity ^0.8.0;
910 
911 
912 /**
913  * @dev Contract module which provides a basic access control mechanism, where
914  * there is an account (an owner) that can be granted exclusive access to
915  * specific functions.
916  *
917  * By default, the owner account will be the one that deploys the contract. This
918  * can later be changed with {transferOwnership}.
919  *
920  * This module is used through inheritance. It will make available the modifier
921  * `onlyOwner`, which can be applied to your functions to restrict their use to
922  * the owner.
923  */
924 abstract contract Ownable is Context {
925     address private _owner;
926 
927     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
928 
929     /**
930      * @dev Initializes the contract setting the deployer as the initial owner.
931      */
932     constructor() {
933         _transferOwnership(_msgSender());
934     }
935 
936     /**
937      * @dev Throws if called by any account other than the owner.
938      */
939     modifier onlyOwner() {
940         _checkOwner();
941         _;
942     }
943 
944     /**
945      * @dev Returns the address of the current owner.
946      */
947     function owner() public view virtual returns (address) {
948         return _owner;
949     }
950 
951     /**
952      * @dev Throws if the sender is not the owner.
953      */
954     function _checkOwner() internal view virtual {
955         require(owner() == _msgSender(), "Ownable: caller is not the owner");
956     }
957 
958     /**
959      * @dev Leaves the contract without owner. It will not be possible to call
960      * `onlyOwner` functions anymore. Can only be called by the current owner.
961      *
962      * NOTE: Renouncing ownership will leave the contract without an owner,
963      * thereby removing any functionality that is only available to the owner.
964      */
965     function renounceOwnership() public virtual onlyOwner {
966         _transferOwnership(address(0));
967     }
968 
969     /**
970      * @dev Transfers ownership of the contract to a new account (`newOwner`).
971      * Can only be called by the current owner.
972      */
973     function transferOwnership(address newOwner) public virtual onlyOwner {
974         require(newOwner != address(0), "Ownable: new owner is the zero address");
975         _transferOwnership(newOwner);
976     }
977 
978     /**
979      * @dev Transfers ownership of the contract to a new account (`newOwner`).
980      * Internal function without access restriction.
981      */
982     function _transferOwnership(address newOwner) internal virtual {
983         address oldOwner = _owner;
984         _owner = newOwner;
985         emit OwnershipTransferred(oldOwner, newOwner);
986     }
987 }
988 
989 // File: erc721a/contracts/IERC721A.sol
990 
991 
992 // ERC721A Contracts v4.2.3
993 // Creator: Chiru Labs
994 
995 pragma solidity ^0.8.4;
996 
997 /**
998  * @dev Interface of ERC721A.
999  */
1000 interface IERC721A {
1001     /**
1002      * The caller must own the token or be an approved operator.
1003      */
1004     error ApprovalCallerNotOwnerNorApproved();
1005 
1006     /**
1007      * The token does not exist.
1008      */
1009     error ApprovalQueryForNonexistentToken();
1010 
1011     /**
1012      * Cannot query the balance for the zero address.
1013      */
1014     error BalanceQueryForZeroAddress();
1015 
1016     /**
1017      * Cannot mint to the zero address.
1018      */
1019     error MintToZeroAddress();
1020 
1021     /**
1022      * The quantity of tokens minted must be more than zero.
1023      */
1024     error MintZeroQuantity();
1025 
1026     /**
1027      * The token does not exist.
1028      */
1029     error OwnerQueryForNonexistentToken();
1030 
1031     /**
1032      * The caller must own the token or be an approved operator.
1033      */
1034     error TransferCallerNotOwnerNorApproved();
1035 
1036     /**
1037      * The token must be owned by `from`.
1038      */
1039     error TransferFromIncorrectOwner();
1040 
1041     /**
1042      * Cannot safely transfer to a contract that does not implement the
1043      * ERC721Receiver interface.
1044      */
1045     error TransferToNonERC721ReceiverImplementer();
1046 
1047     /**
1048      * Cannot transfer to the zero address.
1049      */
1050     error TransferToZeroAddress();
1051 
1052     /**
1053      * The token does not exist.
1054      */
1055     error URIQueryForNonexistentToken();
1056 
1057     /**
1058      * The `quantity` minted with ERC2309 exceeds the safety limit.
1059      */
1060     error MintERC2309QuantityExceedsLimit();
1061 
1062     /**
1063      * The `extraData` cannot be set on an unintialized ownership slot.
1064      */
1065     error OwnershipNotInitializedForExtraData();
1066 
1067     // =============================================================
1068     //                            STRUCTS
1069     // =============================================================
1070 
1071     struct TokenOwnership {
1072         // The address of the owner.
1073         address addr;
1074         // Stores the start time of ownership with minimal overhead for tokenomics.
1075         uint64 startTimestamp;
1076         // Whether the token has been burned.
1077         bool burned;
1078         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1079         uint24 extraData;
1080     }
1081 
1082     // =============================================================
1083     //                         TOKEN COUNTERS
1084     // =============================================================
1085 
1086     /**
1087      * @dev Returns the total number of tokens in existence.
1088      * Burned tokens will reduce the count.
1089      * To get the total number of tokens minted, please see {_totalMinted}.
1090      */
1091     function totalSupply() external view returns (uint256);
1092 
1093     // =============================================================
1094     //                            IERC165
1095     // =============================================================
1096 
1097     /**
1098      * @dev Returns true if this contract implements the interface defined by
1099      * `interfaceId`. See the corresponding
1100      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1101      * to learn more about how these ids are created.
1102      *
1103      * This function call must use less than 30000 gas.
1104      */
1105     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1106 
1107     // =============================================================
1108     //                            IERC721
1109     // =============================================================
1110 
1111     /**
1112      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1113      */
1114     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1115 
1116     /**
1117      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1118      */
1119     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1120 
1121     /**
1122      * @dev Emitted when `owner` enables or disables
1123      * (`approved`) `operator` to manage all of its assets.
1124      */
1125     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1126 
1127     /**
1128      * @dev Returns the number of tokens in `owner`'s account.
1129      */
1130     function balanceOf(address owner) external view returns (uint256 balance);
1131 
1132     /**
1133      * @dev Returns the owner of the `tokenId` token.
1134      *
1135      * Requirements:
1136      *
1137      * - `tokenId` must exist.
1138      */
1139     function ownerOf(uint256 tokenId) external view returns (address owner);
1140 
1141     /**
1142      * @dev Safely transfers `tokenId` token from `from` to `to`,
1143      * checking first that contract recipients are aware of the ERC721 protocol
1144      * to prevent tokens from being forever locked.
1145      *
1146      * Requirements:
1147      *
1148      * - `from` cannot be the zero address.
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must exist and be owned by `from`.
1151      * - If the caller is not `from`, it must be have been allowed to move
1152      * this token by either {approve} or {setApprovalForAll}.
1153      * - If `to` refers to a smart contract, it must implement
1154      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function safeTransferFrom(
1159         address from,
1160         address to,
1161         uint256 tokenId,
1162         bytes calldata data
1163     ) external payable;
1164 
1165     /**
1166      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1167      */
1168     function safeTransferFrom(
1169         address from,
1170         address to,
1171         uint256 tokenId
1172     ) external payable;
1173 
1174     /**
1175      * @dev Transfers `tokenId` from `from` to `to`.
1176      *
1177      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1178      * whenever possible.
1179      *
1180      * Requirements:
1181      *
1182      * - `from` cannot be the zero address.
1183      * - `to` cannot be the zero address.
1184      * - `tokenId` token must be owned by `from`.
1185      * - If the caller is not `from`, it must be approved to move this token
1186      * by either {approve} or {setApprovalForAll}.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function transferFrom(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) external payable;
1195 
1196     /**
1197      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1198      * The approval is cleared when the token is transferred.
1199      *
1200      * Only a single account can be approved at a time, so approving the
1201      * zero address clears previous approvals.
1202      *
1203      * Requirements:
1204      *
1205      * - The caller must own the token or be an approved operator.
1206      * - `tokenId` must exist.
1207      *
1208      * Emits an {Approval} event.
1209      */
1210     function approve(address to, uint256 tokenId) external payable;
1211 
1212     /**
1213      * @dev Approve or remove `operator` as an operator for the caller.
1214      * Operators can call {transferFrom} or {safeTransferFrom}
1215      * for any token owned by the caller.
1216      *
1217      * Requirements:
1218      *
1219      * - The `operator` cannot be the caller.
1220      *
1221      * Emits an {ApprovalForAll} event.
1222      */
1223     function setApprovalForAll(address operator, bool _approved) external;
1224 
1225     /**
1226      * @dev Returns the account approved for `tokenId` token.
1227      *
1228      * Requirements:
1229      *
1230      * - `tokenId` must exist.
1231      */
1232     function getApproved(uint256 tokenId) external view returns (address operator);
1233 
1234     /**
1235      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1236      *
1237      * See {setApprovalForAll}.
1238      */
1239     function isApprovedForAll(address owner, address operator) external view returns (bool);
1240 
1241     // =============================================================
1242     //                        IERC721Metadata
1243     // =============================================================
1244 
1245     /**
1246      * @dev Returns the token collection name.
1247      */
1248     function name() external view returns (string memory);
1249 
1250     /**
1251      * @dev Returns the token collection symbol.
1252      */
1253     function symbol() external view returns (string memory);
1254 
1255     /**
1256      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1257      */
1258     function tokenURI(uint256 tokenId) external view returns (string memory);
1259 
1260     // =============================================================
1261     //                           IERC2309
1262     // =============================================================
1263 
1264     /**
1265      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1266      * (inclusive) is transferred from `from` to `to`, as defined in the
1267      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1268      *
1269      * See {_mintERC2309} for more details.
1270      */
1271     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1272 }
1273 
1274 // File: erc721a/contracts/ERC721A.sol
1275 
1276 
1277 // ERC721A Contracts v4.2.3
1278 // Creator: Chiru Labs
1279 
1280 pragma solidity ^0.8.4;
1281 
1282 
1283 /**
1284  * @dev Interface of ERC721 token receiver.
1285  */
1286 interface ERC721A__IERC721Receiver {
1287     function onERC721Received(
1288         address operator,
1289         address from,
1290         uint256 tokenId,
1291         bytes calldata data
1292     ) external returns (bytes4);
1293 }
1294 
1295 /**
1296  * @title ERC721A
1297  *
1298  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1299  * Non-Fungible Token Standard, including the Metadata extension.
1300  * Optimized for lower gas during batch mints.
1301  *
1302  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1303  * starting from `_startTokenId()`.
1304  *
1305  * Assumptions:
1306  *
1307  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1308  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1309  */
1310 contract ERC721A is IERC721A {
1311     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1312     struct TokenApprovalRef {
1313         address value;
1314     }
1315 
1316     // =============================================================
1317     //                           CONSTANTS
1318     // =============================================================
1319 
1320     // Mask of an entry in packed address data.
1321     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1322 
1323     // The bit position of `numberMinted` in packed address data.
1324     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1325 
1326     // The bit position of `numberBurned` in packed address data.
1327     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1328 
1329     // The bit position of `aux` in packed address data.
1330     uint256 private constant _BITPOS_AUX = 192;
1331 
1332     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1333     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1334 
1335     // The bit position of `startTimestamp` in packed ownership.
1336     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1337 
1338     // The bit mask of the `burned` bit in packed ownership.
1339     uint256 private constant _BITMASK_BURNED = 1 << 224;
1340 
1341     // The bit position of the `nextInitialized` bit in packed ownership.
1342     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1343 
1344     // The bit mask of the `nextInitialized` bit in packed ownership.
1345     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1346 
1347     // The bit position of `extraData` in packed ownership.
1348     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1349 
1350     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1351     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1352 
1353     // The mask of the lower 160 bits for addresses.
1354     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1355 
1356     // The maximum `quantity` that can be minted with {_mintERC2309}.
1357     // This limit is to prevent overflows on the address data entries.
1358     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1359     // is required to cause an overflow, which is unrealistic.
1360     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1361 
1362     // The `Transfer` event signature is given by:
1363     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1364     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1365         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1366 
1367     // =============================================================
1368     //                            STORAGE
1369     // =============================================================
1370 
1371     // The next token ID to be minted.
1372     uint256 private _currentIndex;
1373 
1374     // The number of tokens burned.
1375     uint256 private _burnCounter;
1376 
1377     // Token name
1378     string private _name;
1379 
1380     // Token symbol
1381     string private _symbol;
1382 
1383     // Mapping from token ID to ownership details
1384     // An empty struct value does not necessarily mean the token is unowned.
1385     // See {_packedOwnershipOf} implementation for details.
1386     //
1387     // Bits Layout:
1388     // - [0..159]   `addr`
1389     // - [160..223] `startTimestamp`
1390     // - [224]      `burned`
1391     // - [225]      `nextInitialized`
1392     // - [232..255] `extraData`
1393     mapping(uint256 => uint256) private _packedOwnerships;
1394 
1395     // Mapping owner address to address data.
1396     //
1397     // Bits Layout:
1398     // - [0..63]    `balance`
1399     // - [64..127]  `numberMinted`
1400     // - [128..191] `numberBurned`
1401     // - [192..255] `aux`
1402     mapping(address => uint256) private _packedAddressData;
1403 
1404     // Mapping from token ID to approved address.
1405     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1406 
1407     // Mapping from owner to operator approvals
1408     mapping(address => mapping(address => bool)) private _operatorApprovals;
1409 
1410     // =============================================================
1411     //                          CONSTRUCTOR
1412     // =============================================================
1413 
1414     constructor(string memory name_, string memory symbol_) {
1415         _name = name_;
1416         _symbol = symbol_;
1417         _currentIndex = _startTokenId();
1418     }
1419 
1420     // =============================================================
1421     //                   TOKEN COUNTING OPERATIONS
1422     // =============================================================
1423 
1424     /**
1425      * @dev Returns the starting token ID.
1426      * To change the starting token ID, please override this function.
1427      */
1428     function _startTokenId() internal view virtual returns (uint256) {
1429         return 0;
1430     }
1431 
1432     /**
1433      * @dev Returns the next token ID to be minted.
1434      */
1435     function _nextTokenId() internal view virtual returns (uint256) {
1436         return _currentIndex;
1437     }
1438 
1439     /**
1440      * @dev Returns the total number of tokens in existence.
1441      * Burned tokens will reduce the count.
1442      * To get the total number of tokens minted, please see {_totalMinted}.
1443      */
1444     function totalSupply() public view virtual override returns (uint256) {
1445         // Counter underflow is impossible as _burnCounter cannot be incremented
1446         // more than `_currentIndex - _startTokenId()` times.
1447         unchecked {
1448             return _currentIndex - _burnCounter - _startTokenId();
1449         }
1450     }
1451 
1452     /**
1453      * @dev Returns the total amount of tokens minted in the contract.
1454      */
1455     function _totalMinted() internal view virtual returns (uint256) {
1456         // Counter underflow is impossible as `_currentIndex` does not decrement,
1457         // and it is initialized to `_startTokenId()`.
1458         unchecked {
1459             return _currentIndex - _startTokenId();
1460         }
1461     }
1462 
1463     /**
1464      * @dev Returns the total number of tokens burned.
1465      */
1466     function _totalBurned() internal view virtual returns (uint256) {
1467         return _burnCounter;
1468     }
1469 
1470     // =============================================================
1471     //                    ADDRESS DATA OPERATIONS
1472     // =============================================================
1473 
1474     /**
1475      * @dev Returns the number of tokens in `owner`'s account.
1476      */
1477     function balanceOf(address owner) public view virtual override returns (uint256) {
1478         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1479         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1480     }
1481 
1482     /**
1483      * Returns the number of tokens minted by `owner`.
1484      */
1485     function _numberMinted(address owner) internal view returns (uint256) {
1486         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1487     }
1488 
1489     /**
1490      * Returns the number of tokens burned by or on behalf of `owner`.
1491      */
1492     function _numberBurned(address owner) internal view returns (uint256) {
1493         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1494     }
1495 
1496     /**
1497      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1498      */
1499     function _getAux(address owner) internal view returns (uint64) {
1500         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1501     }
1502 
1503     /**
1504      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1505      * If there are multiple variables, please pack them into a uint64.
1506      */
1507     function _setAux(address owner, uint64 aux) internal virtual {
1508         uint256 packed = _packedAddressData[owner];
1509         uint256 auxCasted;
1510         // Cast `aux` with assembly to avoid redundant masking.
1511         assembly {
1512             auxCasted := aux
1513         }
1514         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1515         _packedAddressData[owner] = packed;
1516     }
1517 
1518     // =============================================================
1519     //                            IERC165
1520     // =============================================================
1521 
1522     /**
1523      * @dev Returns true if this contract implements the interface defined by
1524      * `interfaceId`. See the corresponding
1525      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1526      * to learn more about how these ids are created.
1527      *
1528      * This function call must use less than 30000 gas.
1529      */
1530     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1531         // The interface IDs are constants representing the first 4 bytes
1532         // of the XOR of all function selectors in the interface.
1533         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1534         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1535         return
1536             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1537             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1538             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1539     }
1540 
1541     // =============================================================
1542     //                        IERC721Metadata
1543     // =============================================================
1544 
1545     /**
1546      * @dev Returns the token collection name.
1547      */
1548     function name() public view virtual override returns (string memory) {
1549         return _name;
1550     }
1551 
1552     /**
1553      * @dev Returns the token collection symbol.
1554      */
1555     function symbol() public view virtual override returns (string memory) {
1556         return _symbol;
1557     }
1558 
1559     /**
1560      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1561      */
1562     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1563         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1564 
1565         string memory baseURI = _baseURI();
1566         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1567     }
1568 
1569     /**
1570      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1571      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1572      * by default, it can be overridden in child contracts.
1573      */
1574     function _baseURI() internal view virtual returns (string memory) {
1575         return '';
1576     }
1577 
1578     // =============================================================
1579     //                     OWNERSHIPS OPERATIONS
1580     // =============================================================
1581 
1582     /**
1583      * @dev Returns the owner of the `tokenId` token.
1584      *
1585      * Requirements:
1586      *
1587      * - `tokenId` must exist.
1588      */
1589     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1590         return address(uint160(_packedOwnershipOf(tokenId)));
1591     }
1592 
1593     /**
1594      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1595      * It gradually moves to O(1) as tokens get transferred around over time.
1596      */
1597     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1598         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1599     }
1600 
1601     /**
1602      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1603      */
1604     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1605         return _unpackedOwnership(_packedOwnerships[index]);
1606     }
1607 
1608     /**
1609      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1610      */
1611     function _initializeOwnershipAt(uint256 index) internal virtual {
1612         if (_packedOwnerships[index] == 0) {
1613             _packedOwnerships[index] = _packedOwnershipOf(index);
1614         }
1615     }
1616 
1617     /**
1618      * Returns the packed ownership data of `tokenId`.
1619      */
1620     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1621         uint256 curr = tokenId;
1622 
1623         unchecked {
1624             if (_startTokenId() <= curr)
1625                 if (curr < _currentIndex) {
1626                     uint256 packed = _packedOwnerships[curr];
1627                     // If not burned.
1628                     if (packed & _BITMASK_BURNED == 0) {
1629                         // Invariant:
1630                         // There will always be an initialized ownership slot
1631                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1632                         // before an unintialized ownership slot
1633                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1634                         // Hence, `curr` will not underflow.
1635                         //
1636                         // We can directly compare the packed value.
1637                         // If the address is zero, packed will be zero.
1638                         while (packed == 0) {
1639                             packed = _packedOwnerships[--curr];
1640                         }
1641                         return packed;
1642                     }
1643                 }
1644         }
1645         revert OwnerQueryForNonexistentToken();
1646     }
1647 
1648     /**
1649      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1650      */
1651     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1652         ownership.addr = address(uint160(packed));
1653         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1654         ownership.burned = packed & _BITMASK_BURNED != 0;
1655         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1656     }
1657 
1658     /**
1659      * @dev Packs ownership data into a single uint256.
1660      */
1661     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1662         assembly {
1663             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1664             owner := and(owner, _BITMASK_ADDRESS)
1665             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1666             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1667         }
1668     }
1669 
1670     /**
1671      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1672      */
1673     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1674         // For branchless setting of the `nextInitialized` flag.
1675         assembly {
1676             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1677             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1678         }
1679     }
1680 
1681     // =============================================================
1682     //                      APPROVAL OPERATIONS
1683     // =============================================================
1684 
1685     /**
1686      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1687      * The approval is cleared when the token is transferred.
1688      *
1689      * Only a single account can be approved at a time, so approving the
1690      * zero address clears previous approvals.
1691      *
1692      * Requirements:
1693      *
1694      * - The caller must own the token or be an approved operator.
1695      * - `tokenId` must exist.
1696      *
1697      * Emits an {Approval} event.
1698      */
1699     function approve(address to, uint256 tokenId) public payable virtual override {
1700         address owner = ownerOf(tokenId);
1701 
1702         if (_msgSenderERC721A() != owner)
1703             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1704                 revert ApprovalCallerNotOwnerNorApproved();
1705             }
1706 
1707         _tokenApprovals[tokenId].value = to;
1708         emit Approval(owner, to, tokenId);
1709     }
1710 
1711     /**
1712      * @dev Returns the account approved for `tokenId` token.
1713      *
1714      * Requirements:
1715      *
1716      * - `tokenId` must exist.
1717      */
1718     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1719         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1720 
1721         return _tokenApprovals[tokenId].value;
1722     }
1723 
1724     /**
1725      * @dev Approve or remove `operator` as an operator for the caller.
1726      * Operators can call {transferFrom} or {safeTransferFrom}
1727      * for any token owned by the caller.
1728      *
1729      * Requirements:
1730      *
1731      * - The `operator` cannot be the caller.
1732      *
1733      * Emits an {ApprovalForAll} event.
1734      */
1735     function setApprovalForAll(address operator, bool approved) public virtual override {
1736         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1737         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1738     }
1739 
1740     /**
1741      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1742      *
1743      * See {setApprovalForAll}.
1744      */
1745     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1746         return _operatorApprovals[owner][operator];
1747     }
1748 
1749     /**
1750      * @dev Returns whether `tokenId` exists.
1751      *
1752      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1753      *
1754      * Tokens start existing when they are minted. See {_mint}.
1755      */
1756     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1757         return
1758             _startTokenId() <= tokenId &&
1759             tokenId < _currentIndex && // If within bounds,
1760             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1761     }
1762 
1763     /**
1764      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1765      */
1766     function _isSenderApprovedOrOwner(
1767         address approvedAddress,
1768         address owner,
1769         address msgSender
1770     ) private pure returns (bool result) {
1771         assembly {
1772             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1773             owner := and(owner, _BITMASK_ADDRESS)
1774             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1775             msgSender := and(msgSender, _BITMASK_ADDRESS)
1776             // `msgSender == owner || msgSender == approvedAddress`.
1777             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1778         }
1779     }
1780 
1781     /**
1782      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1783      */
1784     function _getApprovedSlotAndAddress(uint256 tokenId)
1785         private
1786         view
1787         returns (uint256 approvedAddressSlot, address approvedAddress)
1788     {
1789         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1790         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1791         assembly {
1792             approvedAddressSlot := tokenApproval.slot
1793             approvedAddress := sload(approvedAddressSlot)
1794         }
1795     }
1796 
1797     // =============================================================
1798     //                      TRANSFER OPERATIONS
1799     // =============================================================
1800 
1801     /**
1802      * @dev Transfers `tokenId` from `from` to `to`.
1803      *
1804      * Requirements:
1805      *
1806      * - `from` cannot be the zero address.
1807      * - `to` cannot be the zero address.
1808      * - `tokenId` token must be owned by `from`.
1809      * - If the caller is not `from`, it must be approved to move this token
1810      * by either {approve} or {setApprovalForAll}.
1811      *
1812      * Emits a {Transfer} event.
1813      */
1814     function transferFrom(
1815         address from,
1816         address to,
1817         uint256 tokenId
1818     ) public payable virtual override {
1819         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1820 
1821         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1822 
1823         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1824 
1825         // The nested ifs save around 20+ gas over a compound boolean condition.
1826         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1827             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1828 
1829         if (to == address(0)) revert TransferToZeroAddress();
1830 
1831         _beforeTokenTransfers(from, to, tokenId, 1);
1832 
1833         // Clear approvals from the previous owner.
1834         assembly {
1835             if approvedAddress {
1836                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1837                 sstore(approvedAddressSlot, 0)
1838             }
1839         }
1840 
1841         // Underflow of the sender's balance is impossible because we check for
1842         // ownership above and the recipient's balance can't realistically overflow.
1843         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1844         unchecked {
1845             // We can directly increment and decrement the balances.
1846             --_packedAddressData[from]; // Updates: `balance -= 1`.
1847             ++_packedAddressData[to]; // Updates: `balance += 1`.
1848 
1849             // Updates:
1850             // - `address` to the next owner.
1851             // - `startTimestamp` to the timestamp of transfering.
1852             // - `burned` to `false`.
1853             // - `nextInitialized` to `true`.
1854             _packedOwnerships[tokenId] = _packOwnershipData(
1855                 to,
1856                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1857             );
1858 
1859             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1860             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1861                 uint256 nextTokenId = tokenId + 1;
1862                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1863                 if (_packedOwnerships[nextTokenId] == 0) {
1864                     // If the next slot is within bounds.
1865                     if (nextTokenId != _currentIndex) {
1866                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1867                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1868                     }
1869                 }
1870             }
1871         }
1872 
1873         emit Transfer(from, to, tokenId);
1874         _afterTokenTransfers(from, to, tokenId, 1);
1875     }
1876 
1877     /**
1878      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1879      */
1880     function safeTransferFrom(
1881         address from,
1882         address to,
1883         uint256 tokenId
1884     ) public payable virtual override {
1885         safeTransferFrom(from, to, tokenId, '');
1886     }
1887 
1888     /**
1889      * @dev Safely transfers `tokenId` token from `from` to `to`.
1890      *
1891      * Requirements:
1892      *
1893      * - `from` cannot be the zero address.
1894      * - `to` cannot be the zero address.
1895      * - `tokenId` token must exist and be owned by `from`.
1896      * - If the caller is not `from`, it must be approved to move this token
1897      * by either {approve} or {setApprovalForAll}.
1898      * - If `to` refers to a smart contract, it must implement
1899      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1900      *
1901      * Emits a {Transfer} event.
1902      */
1903     function safeTransferFrom(
1904         address from,
1905         address to,
1906         uint256 tokenId,
1907         bytes memory _data
1908     ) public payable virtual override {
1909         transferFrom(from, to, tokenId);
1910         if (to.code.length != 0)
1911             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1912                 revert TransferToNonERC721ReceiverImplementer();
1913             }
1914     }
1915 
1916     /**
1917      * @dev Hook that is called before a set of serially-ordered token IDs
1918      * are about to be transferred. This includes minting.
1919      * And also called before burning one token.
1920      *
1921      * `startTokenId` - the first token ID to be transferred.
1922      * `quantity` - the amount to be transferred.
1923      *
1924      * Calling conditions:
1925      *
1926      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1927      * transferred to `to`.
1928      * - When `from` is zero, `tokenId` will be minted for `to`.
1929      * - When `to` is zero, `tokenId` will be burned by `from`.
1930      * - `from` and `to` are never both zero.
1931      */
1932     function _beforeTokenTransfers(
1933         address from,
1934         address to,
1935         uint256 startTokenId,
1936         uint256 quantity
1937     ) internal virtual {}
1938 
1939     /**
1940      * @dev Hook that is called after a set of serially-ordered token IDs
1941      * have been transferred. This includes minting.
1942      * And also called after one token has been burned.
1943      *
1944      * `startTokenId` - the first token ID to be transferred.
1945      * `quantity` - the amount to be transferred.
1946      *
1947      * Calling conditions:
1948      *
1949      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1950      * transferred to `to`.
1951      * - When `from` is zero, `tokenId` has been minted for `to`.
1952      * - When `to` is zero, `tokenId` has been burned by `from`.
1953      * - `from` and `to` are never both zero.
1954      */
1955     function _afterTokenTransfers(
1956         address from,
1957         address to,
1958         uint256 startTokenId,
1959         uint256 quantity
1960     ) internal virtual {}
1961 
1962     /**
1963      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1964      *
1965      * `from` - Previous owner of the given token ID.
1966      * `to` - Target address that will receive the token.
1967      * `tokenId` - Token ID to be transferred.
1968      * `_data` - Optional data to send along with the call.
1969      *
1970      * Returns whether the call correctly returned the expected magic value.
1971      */
1972     function _checkContractOnERC721Received(
1973         address from,
1974         address to,
1975         uint256 tokenId,
1976         bytes memory _data
1977     ) private returns (bool) {
1978         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1979             bytes4 retval
1980         ) {
1981             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1982         } catch (bytes memory reason) {
1983             if (reason.length == 0) {
1984                 revert TransferToNonERC721ReceiverImplementer();
1985             } else {
1986                 assembly {
1987                     revert(add(32, reason), mload(reason))
1988                 }
1989             }
1990         }
1991     }
1992 
1993     // =============================================================
1994     //                        MINT OPERATIONS
1995     // =============================================================
1996 
1997     /**
1998      * @dev Mints `quantity` tokens and transfers them to `to`.
1999      *
2000      * Requirements:
2001      *
2002      * - `to` cannot be the zero address.
2003      * - `quantity` must be greater than 0.
2004      *
2005      * Emits a {Transfer} event for each mint.
2006      */
2007     function _mint(address to, uint256 quantity) internal virtual {
2008         uint256 startTokenId = _currentIndex;
2009         if (quantity == 0) revert MintZeroQuantity();
2010 
2011         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2012 
2013         // Overflows are incredibly unrealistic.
2014         // `balance` and `numberMinted` have a maximum limit of 2**64.
2015         // `tokenId` has a maximum limit of 2**256.
2016         unchecked {
2017             // Updates:
2018             // - `balance += quantity`.
2019             // - `numberMinted += quantity`.
2020             //
2021             // We can directly add to the `balance` and `numberMinted`.
2022             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2023 
2024             // Updates:
2025             // - `address` to the owner.
2026             // - `startTimestamp` to the timestamp of minting.
2027             // - `burned` to `false`.
2028             // - `nextInitialized` to `quantity == 1`.
2029             _packedOwnerships[startTokenId] = _packOwnershipData(
2030                 to,
2031                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2032             );
2033 
2034             uint256 toMasked;
2035             uint256 end = startTokenId + quantity;
2036 
2037             // Use assembly to loop and emit the `Transfer` event for gas savings.
2038             // The duplicated `log4` removes an extra check and reduces stack juggling.
2039             // The assembly, together with the surrounding Solidity code, have been
2040             // delicately arranged to nudge the compiler into producing optimized opcodes.
2041             assembly {
2042                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2043                 toMasked := and(to, _BITMASK_ADDRESS)
2044                 // Emit the `Transfer` event.
2045                 log4(
2046                     0, // Start of data (0, since no data).
2047                     0, // End of data (0, since no data).
2048                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2049                     0, // `address(0)`.
2050                     toMasked, // `to`.
2051                     startTokenId // `tokenId`.
2052                 )
2053 
2054                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2055                 // that overflows uint256 will make the loop run out of gas.
2056                 // The compiler will optimize the `iszero` away for performance.
2057                 for {
2058                     let tokenId := add(startTokenId, 1)
2059                 } iszero(eq(tokenId, end)) {
2060                     tokenId := add(tokenId, 1)
2061                 } {
2062                     // Emit the `Transfer` event. Similar to above.
2063                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2064                 }
2065             }
2066             if (toMasked == 0) revert MintToZeroAddress();
2067 
2068             _currentIndex = end;
2069         }
2070         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2071     }
2072 
2073     /**
2074      * @dev Mints `quantity` tokens and transfers them to `to`.
2075      *
2076      * This function is intended for efficient minting only during contract creation.
2077      *
2078      * It emits only one {ConsecutiveTransfer} as defined in
2079      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2080      * instead of a sequence of {Transfer} event(s).
2081      *
2082      * Calling this function outside of contract creation WILL make your contract
2083      * non-compliant with the ERC721 standard.
2084      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2085      * {ConsecutiveTransfer} event is only permissible during contract creation.
2086      *
2087      * Requirements:
2088      *
2089      * - `to` cannot be the zero address.
2090      * - `quantity` must be greater than 0.
2091      *
2092      * Emits a {ConsecutiveTransfer} event.
2093      */
2094     function _mintERC2309(address to, uint256 quantity) internal virtual {
2095         uint256 startTokenId = _currentIndex;
2096         if (to == address(0)) revert MintToZeroAddress();
2097         if (quantity == 0) revert MintZeroQuantity();
2098         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2099 
2100         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2101 
2102         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2103         unchecked {
2104             // Updates:
2105             // - `balance += quantity`.
2106             // - `numberMinted += quantity`.
2107             //
2108             // We can directly add to the `balance` and `numberMinted`.
2109             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2110 
2111             // Updates:
2112             // - `address` to the owner.
2113             // - `startTimestamp` to the timestamp of minting.
2114             // - `burned` to `false`.
2115             // - `nextInitialized` to `quantity == 1`.
2116             _packedOwnerships[startTokenId] = _packOwnershipData(
2117                 to,
2118                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2119             );
2120 
2121             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2122 
2123             _currentIndex = startTokenId + quantity;
2124         }
2125         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2126     }
2127 
2128     /**
2129      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2130      *
2131      * Requirements:
2132      *
2133      * - If `to` refers to a smart contract, it must implement
2134      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2135      * - `quantity` must be greater than 0.
2136      *
2137      * See {_mint}.
2138      *
2139      * Emits a {Transfer} event for each mint.
2140      */
2141     function _safeMint(
2142         address to,
2143         uint256 quantity,
2144         bytes memory _data
2145     ) internal virtual {
2146         _mint(to, quantity);
2147 
2148         unchecked {
2149             if (to.code.length != 0) {
2150                 uint256 end = _currentIndex;
2151                 uint256 index = end - quantity;
2152                 do {
2153                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2154                         revert TransferToNonERC721ReceiverImplementer();
2155                     }
2156                 } while (index < end);
2157                 // Reentrancy protection.
2158                 if (_currentIndex != end) revert();
2159             }
2160         }
2161     }
2162 
2163     /**
2164      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2165      */
2166     function _safeMint(address to, uint256 quantity) internal virtual {
2167         _safeMint(to, quantity, '');
2168     }
2169 
2170     // =============================================================
2171     //                        BURN OPERATIONS
2172     // =============================================================
2173 
2174     /**
2175      * @dev Equivalent to `_burn(tokenId, false)`.
2176      */
2177     function _burn(uint256 tokenId) internal virtual {
2178         _burn(tokenId, false);
2179     }
2180 
2181     /**
2182      * @dev Destroys `tokenId`.
2183      * The approval is cleared when the token is burned.
2184      *
2185      * Requirements:
2186      *
2187      * - `tokenId` must exist.
2188      *
2189      * Emits a {Transfer} event.
2190      */
2191     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2192         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2193 
2194         address from = address(uint160(prevOwnershipPacked));
2195 
2196         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2197 
2198         if (approvalCheck) {
2199             // The nested ifs save around 20+ gas over a compound boolean condition.
2200             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2201                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2202         }
2203 
2204         _beforeTokenTransfers(from, address(0), tokenId, 1);
2205 
2206         // Clear approvals from the previous owner.
2207         assembly {
2208             if approvedAddress {
2209                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2210                 sstore(approvedAddressSlot, 0)
2211             }
2212         }
2213 
2214         // Underflow of the sender's balance is impossible because we check for
2215         // ownership above and the recipient's balance can't realistically overflow.
2216         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2217         unchecked {
2218             // Updates:
2219             // - `balance -= 1`.
2220             // - `numberBurned += 1`.
2221             //
2222             // We can directly decrement the balance, and increment the number burned.
2223             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2224             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2225 
2226             // Updates:
2227             // - `address` to the last owner.
2228             // - `startTimestamp` to the timestamp of burning.
2229             // - `burned` to `true`.
2230             // - `nextInitialized` to `true`.
2231             _packedOwnerships[tokenId] = _packOwnershipData(
2232                 from,
2233                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2234             );
2235 
2236             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2237             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2238                 uint256 nextTokenId = tokenId + 1;
2239                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2240                 if (_packedOwnerships[nextTokenId] == 0) {
2241                     // If the next slot is within bounds.
2242                     if (nextTokenId != _currentIndex) {
2243                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2244                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2245                     }
2246                 }
2247             }
2248         }
2249 
2250         emit Transfer(from, address(0), tokenId);
2251         _afterTokenTransfers(from, address(0), tokenId, 1);
2252 
2253         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2254         unchecked {
2255             _burnCounter++;
2256         }
2257     }
2258 
2259     // =============================================================
2260     //                     EXTRA DATA OPERATIONS
2261     // =============================================================
2262 
2263     /**
2264      * @dev Directly sets the extra data for the ownership data `index`.
2265      */
2266     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2267         uint256 packed = _packedOwnerships[index];
2268         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2269         uint256 extraDataCasted;
2270         // Cast `extraData` with assembly to avoid redundant masking.
2271         assembly {
2272             extraDataCasted := extraData
2273         }
2274         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2275         _packedOwnerships[index] = packed;
2276     }
2277 
2278     /**
2279      * @dev Called during each token transfer to set the 24bit `extraData` field.
2280      * Intended to be overridden by the cosumer contract.
2281      *
2282      * `previousExtraData` - the value of `extraData` before transfer.
2283      *
2284      * Calling conditions:
2285      *
2286      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2287      * transferred to `to`.
2288      * - When `from` is zero, `tokenId` will be minted for `to`.
2289      * - When `to` is zero, `tokenId` will be burned by `from`.
2290      * - `from` and `to` are never both zero.
2291      */
2292     function _extraData(
2293         address from,
2294         address to,
2295         uint24 previousExtraData
2296     ) internal view virtual returns (uint24) {}
2297 
2298     /**
2299      * @dev Returns the next extra data for the packed ownership data.
2300      * The returned result is shifted into position.
2301      */
2302     function _nextExtraData(
2303         address from,
2304         address to,
2305         uint256 prevOwnershipPacked
2306     ) private view returns (uint256) {
2307         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2308         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2309     }
2310 
2311     // =============================================================
2312     //                       OTHER OPERATIONS
2313     // =============================================================
2314 
2315     /**
2316      * @dev Returns the message sender (defaults to `msg.sender`).
2317      *
2318      * If you are writing GSN compatible contracts, you need to override this function.
2319      */
2320     function _msgSenderERC721A() internal view virtual returns (address) {
2321         return msg.sender;
2322     }
2323 
2324     /**
2325      * @dev Converts a uint256 to its ASCII string decimal representation.
2326      */
2327     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2328         assembly {
2329             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2330             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2331             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2332             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2333             let m := add(mload(0x40), 0xa0)
2334             // Update the free memory pointer to allocate.
2335             mstore(0x40, m)
2336             // Assign the `str` to the end.
2337             str := sub(m, 0x20)
2338             // Zeroize the slot after the string.
2339             mstore(str, 0)
2340 
2341             // Cache the end of the memory to calculate the length later.
2342             let end := str
2343 
2344             // We write the string from rightmost digit to leftmost digit.
2345             // The following is essentially a do-while loop that also handles the zero case.
2346             // prettier-ignore
2347             for { let temp := value } 1 {} {
2348                 str := sub(str, 1)
2349                 // Write the character to the pointer.
2350                 // The ASCII index of the '0' character is 48.
2351                 mstore8(str, add(48, mod(temp, 10)))
2352                 // Keep dividing `temp` until zero.
2353                 temp := div(temp, 10)
2354                 // prettier-ignore
2355                 if iszero(temp) { break }
2356             }
2357 
2358             let length := sub(end, str)
2359             // Move the pointer 32 bytes leftwards to make room for the length.
2360             str := sub(str, 0x20)
2361             // Store the length.
2362             mstore(str, length)
2363         }
2364     }
2365 }
2366 
2367 // File: DegenWarriors.sol
2368 
2369 
2370 
2371 // Degen Warriors NFT
2372 
2373 pragma solidity ^0.8.17;
2374 
2375 
2376 
2377 
2378 
2379 
2380 contract DegenWarriors is ERC721A, Ownable {
2381     using SafeMath for uint256;
2382     using Strings for uint256;
2383 
2384     uint256 public constant MAX_TOKENS = 1366;
2385     uint256 public price = 0.018 ether;
2386     uint256 public presalePrice = 0.009 ether;
2387     uint256 public maxPerALWallet = 2;
2388     uint256 public maxPerWallet = 3;
2389     // update this to owner address
2390     address public constant w1 = 0x502614827D18C7fCeADCb2B349D3faf44393431f;
2391 
2392     bool public publicSaleStarted = false;
2393     bool public presaleStarted = false;
2394 
2395     mapping(address => uint256) private _walletMints;
2396     mapping(address => uint256) private _ALWalletMints;
2397     bool public revealed = false; // by default collection is unrevealed
2398     string public unRevealedURL = "https://ipfs.io/ipfs/QmYiRCPTf37YsufeG73L9YJKKapLCqgjz459ip8KduxQWw/hidden.json";
2399     string public baseURI = "";
2400     string public extensionURL = ".json";
2401     bytes32 public merkleRoot = 0x11dc6bf27563bf6b68de1eff55f7b41ffe92ef586e3e84c5e503ce5bc142bd32;
2402 
2403     constructor() ERC721A("Degen Warriors", "DGW") {}
2404 
2405     function togglePresaleStarted() external onlyOwner {
2406         presaleStarted = !presaleStarted;
2407     }
2408 
2409     function togglePublicSaleStarted() external onlyOwner {
2410         publicSaleStarted = !publicSaleStarted;
2411     }
2412 
2413      function toggleRevealed() external onlyOwner {
2414         revealed = !revealed;
2415     }
2416 
2417     function setPublicPrice(uint256 _newpublicPrice) external onlyOwner {
2418         price = _newpublicPrice;
2419     }
2420 
2421     function setAllowListPrice(uint256 _newallowListprice) external onlyOwner {
2422         presalePrice = _newallowListprice;
2423     }
2424 
2425     function setMaxPerWallet(uint256 _newMaxPerWallet) external onlyOwner {
2426         maxPerWallet = _newMaxPerWallet;
2427     }
2428 
2429     function setMaxPerALWallet(uint256 _newMaxPerALWallet) external onlyOwner {
2430         maxPerALWallet = _newMaxPerALWallet;
2431     }
2432 
2433     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2434         baseURI = _newBaseURI;
2435     }
2436 
2437     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2438         merkleRoot = _merkleRoot;
2439     }
2440 
2441     function setUnrevealURL(string memory _notRevealuri) public onlyOwner {
2442         unRevealedURL = _notRevealuri;
2443     }
2444 
2445     function _baseURI() internal view override returns (string memory) {
2446         return baseURI;
2447     }
2448 
2449     function _startTokenId() internal pure override returns (uint256) {
2450         return 1;
2451     }
2452 
2453     function tokenURI(uint256 tokenId)
2454         public
2455         view
2456         virtual
2457         override
2458         returns (string memory)
2459     {
2460         require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
2461 
2462         if (revealed == false) {
2463             return unRevealedURL;
2464         } else {
2465             string memory currentBaseURI = _baseURI();
2466             return
2467                 bytes(currentBaseURI).length > 0
2468                     ? string(
2469                         abi.encodePacked(
2470                             currentBaseURI,
2471                             tokenId.toString(),
2472                             extensionURL
2473                         )
2474                     )
2475                     : "";
2476         }
2477     }
2478 
2479     function mintAllowlist(uint256 tokens, bytes32[] calldata merkleProof)
2480         external
2481         payable
2482     {
2483         require(presaleStarted, "Sale has not started");
2484         require(
2485             MerkleProof.verify(
2486                 merkleProof,
2487                 merkleRoot,
2488                 keccak256(abi.encodePacked(msg.sender))
2489             ),
2490             "Not on the allowlist"
2491         );
2492         require(
2493             totalSupply() + tokens <= MAX_TOKENS,
2494             "Minting would exceed max supply"
2495         );
2496         require(tokens > 0, "Must mint at least one Degen Warriors");
2497         require(
2498             _ALWalletMints[_msgSender()] + tokens <= maxPerALWallet,
2499             "AL limit for this wallet reached"
2500         );
2501         require(presalePrice * tokens <= msg.value, "Not enough ETH");
2502 
2503         _ALWalletMints[_msgSender()] += tokens;
2504         _safeMint(_msgSender(), tokens);
2505     }
2506 
2507     function mint(uint256 tokens) external payable {
2508         require(publicSaleStarted, "Sale has not started");
2509         require(
2510             totalSupply() + tokens <= MAX_TOKENS,
2511             "Minting would exceed max supply"
2512         );
2513         require(tokens > 0, "Must mint at least one Degen Warriors");
2514         require(
2515             _walletMints[_msgSender()] + tokens <= maxPerWallet,
2516             "Limit for this wallet reached"
2517         );
2518         require(price * tokens <= msg.value, "Not enough ETH");
2519 
2520         _walletMints[_msgSender()] += tokens;
2521         _safeMint(_msgSender(), tokens);
2522     }
2523 
2524     function withdrawAll() public onlyOwner {
2525         uint256 balance = address(this).balance;
2526         require(balance > 0, "Insufficent balance");
2527         _withdraw(w1, ((balance * 100) / 100));
2528     }
2529 
2530     function _withdraw(address _address, uint256 _amount) private {
2531         (bool success, ) = _address.call{value: _amount}("");
2532         require(success, "Failed to withdraw Ether");
2533     }
2534 }