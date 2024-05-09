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
647 // File: @openzeppelin/contracts/utils/StorageSlot.sol
648 
649 
650 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 /**
655  * @dev Library for reading and writing primitive types to specific storage slots.
656  *
657  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
658  * This library helps with reading and writing to such slots without the need for inline assembly.
659  *
660  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
661  *
662  * Example usage to set ERC1967 implementation slot:
663  * ```
664  * contract ERC1967 {
665  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
666  *
667  *     function _getImplementation() internal view returns (address) {
668  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
669  *     }
670  *
671  *     function _setImplementation(address newImplementation) internal {
672  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
673  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
674  *     }
675  * }
676  * ```
677  *
678  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
679  */
680 library StorageSlot {
681     struct AddressSlot {
682         address value;
683     }
684 
685     struct BooleanSlot {
686         bool value;
687     }
688 
689     struct Bytes32Slot {
690         bytes32 value;
691     }
692 
693     struct Uint256Slot {
694         uint256 value;
695     }
696 
697     /**
698      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
699      */
700     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
701         /// @solidity memory-safe-assembly
702         assembly {
703             r.slot := slot
704         }
705     }
706 
707     /**
708      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
709      */
710     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
711         /// @solidity memory-safe-assembly
712         assembly {
713             r.slot := slot
714         }
715     }
716 
717     /**
718      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
719      */
720     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
721         /// @solidity memory-safe-assembly
722         assembly {
723             r.slot := slot
724         }
725     }
726 
727     /**
728      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
729      */
730     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
731         /// @solidity memory-safe-assembly
732         assembly {
733             r.slot := slot
734         }
735     }
736 }
737 
738 // File: @openzeppelin/contracts/utils/Arrays.sol
739 
740 
741 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Arrays.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 
746 
747 /**
748  * @dev Collection of functions related to array types.
749  */
750 library Arrays {
751     using StorageSlot for bytes32;
752 
753     /**
754      * @dev Searches a sorted `array` and returns the first index that contains
755      * a value greater or equal to `element`. If no such index exists (i.e. all
756      * values in the array are strictly less than `element`), the array length is
757      * returned. Time complexity O(log n).
758      *
759      * `array` is expected to be sorted in ascending order, and to contain no
760      * repeated elements.
761      */
762     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
763         if (array.length == 0) {
764             return 0;
765         }
766 
767         uint256 low = 0;
768         uint256 high = array.length;
769 
770         while (low < high) {
771             uint256 mid = Math.average(low, high);
772 
773             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
774             // because Math.average rounds down (it does integer division with truncation).
775             if (unsafeAccess(array, mid).value > element) {
776                 high = mid;
777             } else {
778                 low = mid + 1;
779             }
780         }
781 
782         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
783         if (low > 0 && unsafeAccess(array, low - 1).value == element) {
784             return low - 1;
785         } else {
786             return low;
787         }
788     }
789 
790     /**
791      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
792      *
793      * WARNING: Only use if you are certain `pos` is lower than the array length.
794      */
795     function unsafeAccess(address[] storage arr, uint256 pos) internal pure returns (StorageSlot.AddressSlot storage) {
796         bytes32 slot;
797         /// @solidity memory-safe-assembly
798         assembly {
799             mstore(0, arr.slot)
800             slot := add(keccak256(0, 0x20), pos)
801         }
802         return slot.getAddressSlot();
803     }
804 
805     /**
806      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
807      *
808      * WARNING: Only use if you are certain `pos` is lower than the array length.
809      */
810     function unsafeAccess(bytes32[] storage arr, uint256 pos) internal pure returns (StorageSlot.Bytes32Slot storage) {
811         bytes32 slot;
812         /// @solidity memory-safe-assembly
813         assembly {
814             mstore(0, arr.slot)
815             slot := add(keccak256(0, 0x20), pos)
816         }
817         return slot.getBytes32Slot();
818     }
819 
820     /**
821      * @dev Access an array in an "unsafe" way. Skips solidity "index-out-of-range" check.
822      *
823      * WARNING: Only use if you are certain `pos` is lower than the array length.
824      */
825     function unsafeAccess(uint256[] storage arr, uint256 pos) internal pure returns (StorageSlot.Uint256Slot storage) {
826         bytes32 slot;
827         /// @solidity memory-safe-assembly
828         assembly {
829             mstore(0, arr.slot)
830             slot := add(keccak256(0, 0x20), pos)
831         }
832         return slot.getUint256Slot();
833     }
834 }
835 
836 // File: @openzeppelin/contracts/utils/Context.sol
837 
838 
839 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
840 
841 pragma solidity ^0.8.0;
842 
843 /**
844  * @dev Provides information about the current execution context, including the
845  * sender of the transaction and its data. While these are generally available
846  * via msg.sender and msg.data, they should not be accessed in such a direct
847  * manner, since when dealing with meta-transactions the account sending and
848  * paying for execution may not be the actual sender (as far as an application
849  * is concerned).
850  *
851  * This contract is only required for intermediate, library-like contracts.
852  */
853 abstract contract Context {
854     function _msgSender() internal view virtual returns (address) {
855         return msg.sender;
856     }
857 
858     function _msgData() internal view virtual returns (bytes calldata) {
859         return msg.data;
860     }
861 }
862 
863 // File: @openzeppelin/contracts/access/Ownable.sol
864 
865 
866 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
867 
868 pragma solidity ^0.8.0;
869 
870 
871 /**
872  * @dev Contract module which provides a basic access control mechanism, where
873  * there is an account (an owner) that can be granted exclusive access to
874  * specific functions.
875  *
876  * By default, the owner account will be the one that deploys the contract. This
877  * can later be changed with {transferOwnership}.
878  *
879  * This module is used through inheritance. It will make available the modifier
880  * `onlyOwner`, which can be applied to your functions to restrict their use to
881  * the owner.
882  */
883 abstract contract Ownable is Context {
884     address private _owner;
885 
886     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
887 
888     /**
889      * @dev Initializes the contract setting the deployer as the initial owner.
890      */
891     constructor() {
892         _transferOwnership(_msgSender());
893     }
894 
895     /**
896      * @dev Throws if called by any account other than the owner.
897      */
898     modifier onlyOwner() {
899         _checkOwner();
900         _;
901     }
902 
903     /**
904      * @dev Returns the address of the current owner.
905      */
906     function owner() public view virtual returns (address) {
907         return _owner;
908     }
909 
910     /**
911      * @dev Throws if the sender is not the owner.
912      */
913     function _checkOwner() internal view virtual {
914         require(owner() == _msgSender(), "Ownable: caller is not the owner");
915     }
916 
917     /**
918      * @dev Leaves the contract without owner. It will not be possible to call
919      * `onlyOwner` functions anymore. Can only be called by the current owner.
920      *
921      * NOTE: Renouncing ownership will leave the contract without an owner,
922      * thereby removing any functionality that is only available to the owner.
923      */
924     function renounceOwnership() public virtual onlyOwner {
925         _transferOwnership(address(0));
926     }
927 
928     /**
929      * @dev Transfers ownership of the contract to a new account (`newOwner`).
930      * Can only be called by the current owner.
931      */
932     function transferOwnership(address newOwner) public virtual onlyOwner {
933         require(newOwner != address(0), "Ownable: new owner is the zero address");
934         _transferOwnership(newOwner);
935     }
936 
937     /**
938      * @dev Transfers ownership of the contract to a new account (`newOwner`).
939      * Internal function without access restriction.
940      */
941     function _transferOwnership(address newOwner) internal virtual {
942         address oldOwner = _owner;
943         _owner = newOwner;
944         emit OwnershipTransferred(oldOwner, newOwner);
945     }
946 }
947 
948 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
949 
950 
951 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
952 
953 pragma solidity ^0.8.0;
954 
955 /**
956  * @dev Contract module that helps prevent reentrant calls to a function.
957  *
958  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
959  * available, which can be applied to functions to make sure there are no nested
960  * (reentrant) calls to them.
961  *
962  * Note that because there is a single `nonReentrant` guard, functions marked as
963  * `nonReentrant` may not call one another. This can be worked around by making
964  * those functions `private`, and then adding `external` `nonReentrant` entry
965  * points to them.
966  *
967  * TIP: If you would like to learn more about reentrancy and alternative ways
968  * to protect against it, check out our blog post
969  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
970  */
971 abstract contract ReentrancyGuard {
972     // Booleans are more expensive than uint256 or any type that takes up a full
973     // word because each write operation emits an extra SLOAD to first read the
974     // slot's contents, replace the bits taken up by the boolean, and then write
975     // back. This is the compiler's defense against contract upgrades and
976     // pointer aliasing, and it cannot be disabled.
977 
978     // The values being non-zero value makes deployment a bit more expensive,
979     // but in exchange the refund on every call to nonReentrant will be lower in
980     // amount. Since refunds are capped to a percentage of the total
981     // transaction's gas, it is best to keep them low in cases like this one, to
982     // increase the likelihood of the full refund coming into effect.
983     uint256 private constant _NOT_ENTERED = 1;
984     uint256 private constant _ENTERED = 2;
985 
986     uint256 private _status;
987 
988     constructor() {
989         _status = _NOT_ENTERED;
990     }
991 
992     /**
993      * @dev Prevents a contract from calling itself, directly or indirectly.
994      * Calling a `nonReentrant` function from another `nonReentrant`
995      * function is not supported. It is possible to prevent this from happening
996      * by making the `nonReentrant` function external, and making it call a
997      * `private` function that does the actual work.
998      */
999     modifier nonReentrant() {
1000         _nonReentrantBefore();
1001         _;
1002         _nonReentrantAfter();
1003     }
1004 
1005     function _nonReentrantBefore() private {
1006         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1007         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1008 
1009         // Any calls to nonReentrant after this point will fail
1010         _status = _ENTERED;
1011     }
1012 
1013     function _nonReentrantAfter() private {
1014         // By storing the original value once again, a refund is triggered (see
1015         // https://eips.ethereum.org/EIPS/eip-2200)
1016         _status = _NOT_ENTERED;
1017     }
1018 }
1019 
1020 // File: erc721a/contracts/IERC721A.sol
1021 
1022 
1023 // ERC721A Contracts v4.2.3
1024 // Creator: Chiru Labs
1025 
1026 pragma solidity ^0.8.4;
1027 
1028 /**
1029  * @dev Interface of ERC721A.
1030  */
1031 interface IERC721A {
1032     /**
1033      * The caller must own the token or be an approved operator.
1034      */
1035     error ApprovalCallerNotOwnerNorApproved();
1036 
1037     /**
1038      * The token does not exist.
1039      */
1040     error ApprovalQueryForNonexistentToken();
1041 
1042     /**
1043      * Cannot query the balance for the zero address.
1044      */
1045     error BalanceQueryForZeroAddress();
1046 
1047     /**
1048      * Cannot mint to the zero address.
1049      */
1050     error MintToZeroAddress();
1051 
1052     /**
1053      * The quantity of tokens minted must be more than zero.
1054      */
1055     error MintZeroQuantity();
1056 
1057     /**
1058      * The token does not exist.
1059      */
1060     error OwnerQueryForNonexistentToken();
1061 
1062     /**
1063      * The caller must own the token or be an approved operator.
1064      */
1065     error TransferCallerNotOwnerNorApproved();
1066 
1067     /**
1068      * The token must be owned by `from`.
1069      */
1070     error TransferFromIncorrectOwner();
1071 
1072     /**
1073      * Cannot safely transfer to a contract that does not implement the
1074      * ERC721Receiver interface.
1075      */
1076     error TransferToNonERC721ReceiverImplementer();
1077 
1078     /**
1079      * Cannot transfer to the zero address.
1080      */
1081     error TransferToZeroAddress();
1082 
1083     /**
1084      * The token does not exist.
1085      */
1086     error URIQueryForNonexistentToken();
1087 
1088     /**
1089      * The `quantity` minted with ERC2309 exceeds the safety limit.
1090      */
1091     error MintERC2309QuantityExceedsLimit();
1092 
1093     /**
1094      * The `extraData` cannot be set on an unintialized ownership slot.
1095      */
1096     error OwnershipNotInitializedForExtraData();
1097 
1098     // =============================================================
1099     //                            STRUCTS
1100     // =============================================================
1101 
1102     struct TokenOwnership {
1103         // The address of the owner.
1104         address addr;
1105         // Stores the start time of ownership with minimal overhead for tokenomics.
1106         uint64 startTimestamp;
1107         // Whether the token has been burned.
1108         bool burned;
1109         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1110         uint24 extraData;
1111     }
1112 
1113     // =============================================================
1114     //                         TOKEN COUNTERS
1115     // =============================================================
1116 
1117     /**
1118      * @dev Returns the total number of tokens in existence.
1119      * Burned tokens will reduce the count.
1120      * To get the total number of tokens minted, please see {_totalMinted}.
1121      */
1122     function totalSupply() external view returns (uint256);
1123 
1124     // =============================================================
1125     //                            IERC165
1126     // =============================================================
1127 
1128     /**
1129      * @dev Returns true if this contract implements the interface defined by
1130      * `interfaceId`. See the corresponding
1131      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1132      * to learn more about how these ids are created.
1133      *
1134      * This function call must use less than 30000 gas.
1135      */
1136     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1137 
1138     // =============================================================
1139     //                            IERC721
1140     // =============================================================
1141 
1142     /**
1143      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1144      */
1145     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1146 
1147     /**
1148      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1149      */
1150     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1151 
1152     /**
1153      * @dev Emitted when `owner` enables or disables
1154      * (`approved`) `operator` to manage all of its assets.
1155      */
1156     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1157 
1158     /**
1159      * @dev Returns the number of tokens in `owner`'s account.
1160      */
1161     function balanceOf(address owner) external view returns (uint256 balance);
1162 
1163     /**
1164      * @dev Returns the owner of the `tokenId` token.
1165      *
1166      * Requirements:
1167      *
1168      * - `tokenId` must exist.
1169      */
1170     function ownerOf(uint256 tokenId) external view returns (address owner);
1171 
1172     /**
1173      * @dev Safely transfers `tokenId` token from `from` to `to`,
1174      * checking first that contract recipients are aware of the ERC721 protocol
1175      * to prevent tokens from being forever locked.
1176      *
1177      * Requirements:
1178      *
1179      * - `from` cannot be the zero address.
1180      * - `to` cannot be the zero address.
1181      * - `tokenId` token must exist and be owned by `from`.
1182      * - If the caller is not `from`, it must be have been allowed to move
1183      * this token by either {approve} or {setApprovalForAll}.
1184      * - If `to` refers to a smart contract, it must implement
1185      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function safeTransferFrom(
1190         address from,
1191         address to,
1192         uint256 tokenId,
1193         bytes calldata data
1194     ) external payable;
1195 
1196     /**
1197      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1198      */
1199     function safeTransferFrom(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) external payable;
1204 
1205     /**
1206      * @dev Transfers `tokenId` from `from` to `to`.
1207      *
1208      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1209      * whenever possible.
1210      *
1211      * Requirements:
1212      *
1213      * - `from` cannot be the zero address.
1214      * - `to` cannot be the zero address.
1215      * - `tokenId` token must be owned by `from`.
1216      * - If the caller is not `from`, it must be approved to move this token
1217      * by either {approve} or {setApprovalForAll}.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function transferFrom(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) external payable;
1226 
1227     /**
1228      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1229      * The approval is cleared when the token is transferred.
1230      *
1231      * Only a single account can be approved at a time, so approving the
1232      * zero address clears previous approvals.
1233      *
1234      * Requirements:
1235      *
1236      * - The caller must own the token or be an approved operator.
1237      * - `tokenId` must exist.
1238      *
1239      * Emits an {Approval} event.
1240      */
1241     function approve(address to, uint256 tokenId) external payable;
1242 
1243     /**
1244      * @dev Approve or remove `operator` as an operator for the caller.
1245      * Operators can call {transferFrom} or {safeTransferFrom}
1246      * for any token owned by the caller.
1247      *
1248      * Requirements:
1249      *
1250      * - The `operator` cannot be the caller.
1251      *
1252      * Emits an {ApprovalForAll} event.
1253      */
1254     function setApprovalForAll(address operator, bool _approved) external;
1255 
1256     /**
1257      * @dev Returns the account approved for `tokenId` token.
1258      *
1259      * Requirements:
1260      *
1261      * - `tokenId` must exist.
1262      */
1263     function getApproved(uint256 tokenId) external view returns (address operator);
1264 
1265     /**
1266      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1267      *
1268      * See {setApprovalForAll}.
1269      */
1270     function isApprovedForAll(address owner, address operator) external view returns (bool);
1271 
1272     // =============================================================
1273     //                        IERC721Metadata
1274     // =============================================================
1275 
1276     /**
1277      * @dev Returns the token collection name.
1278      */
1279     function name() external view returns (string memory);
1280 
1281     /**
1282      * @dev Returns the token collection symbol.
1283      */
1284     function symbol() external view returns (string memory);
1285 
1286     /**
1287      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1288      */
1289     function tokenURI(uint256 tokenId) external view returns (string memory);
1290 
1291     // =============================================================
1292     //                           IERC2309
1293     // =============================================================
1294 
1295     /**
1296      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1297      * (inclusive) is transferred from `from` to `to`, as defined in the
1298      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1299      *
1300      * See {_mintERC2309} for more details.
1301      */
1302     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1303 }
1304 
1305 // File: erc721a/contracts/ERC721A.sol
1306 
1307 
1308 // ERC721A Contracts v4.2.3
1309 // Creator: Chiru Labs
1310 
1311 pragma solidity ^0.8.4;
1312 
1313 
1314 /**
1315  * @dev Interface of ERC721 token receiver.
1316  */
1317 interface ERC721A__IERC721Receiver {
1318     function onERC721Received(
1319         address operator,
1320         address from,
1321         uint256 tokenId,
1322         bytes calldata data
1323     ) external returns (bytes4);
1324 }
1325 
1326 /**
1327  * @title ERC721A
1328  *
1329  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1330  * Non-Fungible Token Standard, including the Metadata extension.
1331  * Optimized for lower gas during batch mints.
1332  *
1333  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1334  * starting from `_startTokenId()`.
1335  *
1336  * Assumptions:
1337  *
1338  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1339  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1340  */
1341 contract ERC721A is IERC721A {
1342     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1343     struct TokenApprovalRef {
1344         address value;
1345     }
1346 
1347     // =============================================================
1348     //                           CONSTANTS
1349     // =============================================================
1350 
1351     // Mask of an entry in packed address data.
1352     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1353 
1354     // The bit position of `numberMinted` in packed address data.
1355     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1356 
1357     // The bit position of `numberBurned` in packed address data.
1358     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1359 
1360     // The bit position of `aux` in packed address data.
1361     uint256 private constant _BITPOS_AUX = 192;
1362 
1363     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1364     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1365 
1366     // The bit position of `startTimestamp` in packed ownership.
1367     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1368 
1369     // The bit mask of the `burned` bit in packed ownership.
1370     uint256 private constant _BITMASK_BURNED = 1 << 224;
1371 
1372     // The bit position of the `nextInitialized` bit in packed ownership.
1373     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1374 
1375     // The bit mask of the `nextInitialized` bit in packed ownership.
1376     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1377 
1378     // The bit position of `extraData` in packed ownership.
1379     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1380 
1381     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1382     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1383 
1384     // The mask of the lower 160 bits for addresses.
1385     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1386 
1387     // The maximum `quantity` that can be minted with {_mintERC2309}.
1388     // This limit is to prevent overflows on the address data entries.
1389     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1390     // is required to cause an overflow, which is unrealistic.
1391     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1392 
1393     // The `Transfer` event signature is given by:
1394     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1395     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1396         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1397 
1398     // =============================================================
1399     //                            STORAGE
1400     // =============================================================
1401 
1402     // The next token ID to be minted.
1403     uint256 private _currentIndex;
1404 
1405     // The number of tokens burned.
1406     uint256 private _burnCounter;
1407 
1408     // Token name
1409     string private _name;
1410 
1411     // Token symbol
1412     string private _symbol;
1413 
1414     // Mapping from token ID to ownership details
1415     // An empty struct value does not necessarily mean the token is unowned.
1416     // See {_packedOwnershipOf} implementation for details.
1417     //
1418     // Bits Layout:
1419     // - [0..159]   `addr`
1420     // - [160..223] `startTimestamp`
1421     // - [224]      `burned`
1422     // - [225]      `nextInitialized`
1423     // - [232..255] `extraData`
1424     mapping(uint256 => uint256) private _packedOwnerships;
1425 
1426     // Mapping owner address to address data.
1427     //
1428     // Bits Layout:
1429     // - [0..63]    `balance`
1430     // - [64..127]  `numberMinted`
1431     // - [128..191] `numberBurned`
1432     // - [192..255] `aux`
1433     mapping(address => uint256) private _packedAddressData;
1434 
1435     // Mapping from token ID to approved address.
1436     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1437 
1438     // Mapping from owner to operator approvals
1439     mapping(address => mapping(address => bool)) private _operatorApprovals;
1440 
1441     // =============================================================
1442     //                          CONSTRUCTOR
1443     // =============================================================
1444 
1445     constructor(string memory name_, string memory symbol_) {
1446         _name = name_;
1447         _symbol = symbol_;
1448         _currentIndex = _startTokenId();
1449     }
1450 
1451     // =============================================================
1452     //                   TOKEN COUNTING OPERATIONS
1453     // =============================================================
1454 
1455     /**
1456      * @dev Returns the starting token ID.
1457      * To change the starting token ID, please override this function.
1458      */
1459     function _startTokenId() internal view virtual returns (uint256) {
1460         return 0;
1461     }
1462 
1463     /**
1464      * @dev Returns the next token ID to be minted.
1465      */
1466     function _nextTokenId() internal view virtual returns (uint256) {
1467         return _currentIndex;
1468     }
1469 
1470     /**
1471      * @dev Returns the total number of tokens in existence.
1472      * Burned tokens will reduce the count.
1473      * To get the total number of tokens minted, please see {_totalMinted}.
1474      */
1475     function totalSupply() public view virtual override returns (uint256) {
1476         // Counter underflow is impossible as _burnCounter cannot be incremented
1477         // more than `_currentIndex - _startTokenId()` times.
1478         unchecked {
1479             return _currentIndex - _burnCounter - _startTokenId();
1480         }
1481     }
1482 
1483     /**
1484      * @dev Returns the total amount of tokens minted in the contract.
1485      */
1486     function _totalMinted() internal view virtual returns (uint256) {
1487         // Counter underflow is impossible as `_currentIndex` does not decrement,
1488         // and it is initialized to `_startTokenId()`.
1489         unchecked {
1490             return _currentIndex - _startTokenId();
1491         }
1492     }
1493 
1494     /**
1495      * @dev Returns the total number of tokens burned.
1496      */
1497     function _totalBurned() internal view virtual returns (uint256) {
1498         return _burnCounter;
1499     }
1500 
1501     // =============================================================
1502     //                    ADDRESS DATA OPERATIONS
1503     // =============================================================
1504 
1505     /**
1506      * @dev Returns the number of tokens in `owner`'s account.
1507      */
1508     function balanceOf(address owner) public view virtual override returns (uint256) {
1509         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1510         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1511     }
1512 
1513     /**
1514      * Returns the number of tokens minted by `owner`.
1515      */
1516     function _numberMinted(address owner) internal view returns (uint256) {
1517         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1518     }
1519 
1520     /**
1521      * Returns the number of tokens burned by or on behalf of `owner`.
1522      */
1523     function _numberBurned(address owner) internal view returns (uint256) {
1524         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1525     }
1526 
1527     /**
1528      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1529      */
1530     function _getAux(address owner) internal view returns (uint64) {
1531         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1532     }
1533 
1534     /**
1535      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1536      * If there are multiple variables, please pack them into a uint64.
1537      */
1538     function _setAux(address owner, uint64 aux) internal virtual {
1539         uint256 packed = _packedAddressData[owner];
1540         uint256 auxCasted;
1541         // Cast `aux` with assembly to avoid redundant masking.
1542         assembly {
1543             auxCasted := aux
1544         }
1545         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1546         _packedAddressData[owner] = packed;
1547     }
1548 
1549     // =============================================================
1550     //                            IERC165
1551     // =============================================================
1552 
1553     /**
1554      * @dev Returns true if this contract implements the interface defined by
1555      * `interfaceId`. See the corresponding
1556      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1557      * to learn more about how these ids are created.
1558      *
1559      * This function call must use less than 30000 gas.
1560      */
1561     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1562         // The interface IDs are constants representing the first 4 bytes
1563         // of the XOR of all function selectors in the interface.
1564         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1565         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1566         return
1567             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1568             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1569             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1570     }
1571 
1572     // =============================================================
1573     //                        IERC721Metadata
1574     // =============================================================
1575 
1576     /**
1577      * @dev Returns the token collection name.
1578      */
1579     function name() public view virtual override returns (string memory) {
1580         return _name;
1581     }
1582 
1583     /**
1584      * @dev Returns the token collection symbol.
1585      */
1586     function symbol() public view virtual override returns (string memory) {
1587         return _symbol;
1588     }
1589 
1590     /**
1591      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1592      */
1593     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1594         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1595 
1596         string memory baseURI = _baseURI();
1597         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1598     }
1599 
1600     /**
1601      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1602      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1603      * by default, it can be overridden in child contracts.
1604      */
1605     function _baseURI() internal view virtual returns (string memory) {
1606         return '';
1607     }
1608 
1609     // =============================================================
1610     //                     OWNERSHIPS OPERATIONS
1611     // =============================================================
1612 
1613     /**
1614      * @dev Returns the owner of the `tokenId` token.
1615      *
1616      * Requirements:
1617      *
1618      * - `tokenId` must exist.
1619      */
1620     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1621         return address(uint160(_packedOwnershipOf(tokenId)));
1622     }
1623 
1624     /**
1625      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1626      * It gradually moves to O(1) as tokens get transferred around over time.
1627      */
1628     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1629         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1630     }
1631 
1632     /**
1633      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1634      */
1635     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1636         return _unpackedOwnership(_packedOwnerships[index]);
1637     }
1638 
1639     /**
1640      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1641      */
1642     function _initializeOwnershipAt(uint256 index) internal virtual {
1643         if (_packedOwnerships[index] == 0) {
1644             _packedOwnerships[index] = _packedOwnershipOf(index);
1645         }
1646     }
1647 
1648     /**
1649      * Returns the packed ownership data of `tokenId`.
1650      */
1651     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1652         uint256 curr = tokenId;
1653 
1654         unchecked {
1655             if (_startTokenId() <= curr)
1656                 if (curr < _currentIndex) {
1657                     uint256 packed = _packedOwnerships[curr];
1658                     // If not burned.
1659                     if (packed & _BITMASK_BURNED == 0) {
1660                         // Invariant:
1661                         // There will always be an initialized ownership slot
1662                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1663                         // before an unintialized ownership slot
1664                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1665                         // Hence, `curr` will not underflow.
1666                         //
1667                         // We can directly compare the packed value.
1668                         // If the address is zero, packed will be zero.
1669                         while (packed == 0) {
1670                             packed = _packedOwnerships[--curr];
1671                         }
1672                         return packed;
1673                     }
1674                 }
1675         }
1676         revert OwnerQueryForNonexistentToken();
1677     }
1678 
1679     /**
1680      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1681      */
1682     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1683         ownership.addr = address(uint160(packed));
1684         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1685         ownership.burned = packed & _BITMASK_BURNED != 0;
1686         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1687     }
1688 
1689     /**
1690      * @dev Packs ownership data into a single uint256.
1691      */
1692     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1693         assembly {
1694             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1695             owner := and(owner, _BITMASK_ADDRESS)
1696             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1697             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1698         }
1699     }
1700 
1701     /**
1702      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1703      */
1704     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1705         // For branchless setting of the `nextInitialized` flag.
1706         assembly {
1707             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1708             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1709         }
1710     }
1711 
1712     // =============================================================
1713     //                      APPROVAL OPERATIONS
1714     // =============================================================
1715 
1716     /**
1717      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1718      * The approval is cleared when the token is transferred.
1719      *
1720      * Only a single account can be approved at a time, so approving the
1721      * zero address clears previous approvals.
1722      *
1723      * Requirements:
1724      *
1725      * - The caller must own the token or be an approved operator.
1726      * - `tokenId` must exist.
1727      *
1728      * Emits an {Approval} event.
1729      */
1730     function approve(address to, uint256 tokenId) public payable virtual override {
1731         address owner = ownerOf(tokenId);
1732 
1733         if (_msgSenderERC721A() != owner)
1734             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1735                 revert ApprovalCallerNotOwnerNorApproved();
1736             }
1737 
1738         _tokenApprovals[tokenId].value = to;
1739         emit Approval(owner, to, tokenId);
1740     }
1741 
1742     /**
1743      * @dev Returns the account approved for `tokenId` token.
1744      *
1745      * Requirements:
1746      *
1747      * - `tokenId` must exist.
1748      */
1749     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1750         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1751 
1752         return _tokenApprovals[tokenId].value;
1753     }
1754 
1755     /**
1756      * @dev Approve or remove `operator` as an operator for the caller.
1757      * Operators can call {transferFrom} or {safeTransferFrom}
1758      * for any token owned by the caller.
1759      *
1760      * Requirements:
1761      *
1762      * - The `operator` cannot be the caller.
1763      *
1764      * Emits an {ApprovalForAll} event.
1765      */
1766     function setApprovalForAll(address operator, bool approved) public virtual override {
1767         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1768         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1769     }
1770 
1771     /**
1772      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1773      *
1774      * See {setApprovalForAll}.
1775      */
1776     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1777         return _operatorApprovals[owner][operator];
1778     }
1779 
1780     /**
1781      * @dev Returns whether `tokenId` exists.
1782      *
1783      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1784      *
1785      * Tokens start existing when they are minted. See {_mint}.
1786      */
1787     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1788         return
1789             _startTokenId() <= tokenId &&
1790             tokenId < _currentIndex && // If within bounds,
1791             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1792     }
1793 
1794     /**
1795      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1796      */
1797     function _isSenderApprovedOrOwner(
1798         address approvedAddress,
1799         address owner,
1800         address msgSender
1801     ) private pure returns (bool result) {
1802         assembly {
1803             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1804             owner := and(owner, _BITMASK_ADDRESS)
1805             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1806             msgSender := and(msgSender, _BITMASK_ADDRESS)
1807             // `msgSender == owner || msgSender == approvedAddress`.
1808             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1809         }
1810     }
1811 
1812     /**
1813      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1814      */
1815     function _getApprovedSlotAndAddress(uint256 tokenId)
1816         private
1817         view
1818         returns (uint256 approvedAddressSlot, address approvedAddress)
1819     {
1820         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1821         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1822         assembly {
1823             approvedAddressSlot := tokenApproval.slot
1824             approvedAddress := sload(approvedAddressSlot)
1825         }
1826     }
1827 
1828     // =============================================================
1829     //                      TRANSFER OPERATIONS
1830     // =============================================================
1831 
1832     /**
1833      * @dev Transfers `tokenId` from `from` to `to`.
1834      *
1835      * Requirements:
1836      *
1837      * - `from` cannot be the zero address.
1838      * - `to` cannot be the zero address.
1839      * - `tokenId` token must be owned by `from`.
1840      * - If the caller is not `from`, it must be approved to move this token
1841      * by either {approve} or {setApprovalForAll}.
1842      *
1843      * Emits a {Transfer} event.
1844      */
1845     function transferFrom(
1846         address from,
1847         address to,
1848         uint256 tokenId
1849     ) public payable virtual override {
1850         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1851 
1852         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1853 
1854         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1855 
1856         // The nested ifs save around 20+ gas over a compound boolean condition.
1857         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1858             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1859 
1860         if (to == address(0)) revert TransferToZeroAddress();
1861 
1862         _beforeTokenTransfers(from, to, tokenId, 1);
1863 
1864         // Clear approvals from the previous owner.
1865         assembly {
1866             if approvedAddress {
1867                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1868                 sstore(approvedAddressSlot, 0)
1869             }
1870         }
1871 
1872         // Underflow of the sender's balance is impossible because we check for
1873         // ownership above and the recipient's balance can't realistically overflow.
1874         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1875         unchecked {
1876             // We can directly increment and decrement the balances.
1877             --_packedAddressData[from]; // Updates: `balance -= 1`.
1878             ++_packedAddressData[to]; // Updates: `balance += 1`.
1879 
1880             // Updates:
1881             // - `address` to the next owner.
1882             // - `startTimestamp` to the timestamp of transfering.
1883             // - `burned` to `false`.
1884             // - `nextInitialized` to `true`.
1885             _packedOwnerships[tokenId] = _packOwnershipData(
1886                 to,
1887                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1888             );
1889 
1890             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1891             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1892                 uint256 nextTokenId = tokenId + 1;
1893                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1894                 if (_packedOwnerships[nextTokenId] == 0) {
1895                     // If the next slot is within bounds.
1896                     if (nextTokenId != _currentIndex) {
1897                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1898                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1899                     }
1900                 }
1901             }
1902         }
1903 
1904         emit Transfer(from, to, tokenId);
1905         _afterTokenTransfers(from, to, tokenId, 1);
1906     }
1907 
1908     /**
1909      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1910      */
1911     function safeTransferFrom(
1912         address from,
1913         address to,
1914         uint256 tokenId
1915     ) public payable virtual override {
1916         safeTransferFrom(from, to, tokenId, '');
1917     }
1918 
1919     /**
1920      * @dev Safely transfers `tokenId` token from `from` to `to`.
1921      *
1922      * Requirements:
1923      *
1924      * - `from` cannot be the zero address.
1925      * - `to` cannot be the zero address.
1926      * - `tokenId` token must exist and be owned by `from`.
1927      * - If the caller is not `from`, it must be approved to move this token
1928      * by either {approve} or {setApprovalForAll}.
1929      * - If `to` refers to a smart contract, it must implement
1930      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1931      *
1932      * Emits a {Transfer} event.
1933      */
1934     function safeTransferFrom(
1935         address from,
1936         address to,
1937         uint256 tokenId,
1938         bytes memory _data
1939     ) public payable virtual override {
1940         transferFrom(from, to, tokenId);
1941         if (to.code.length != 0)
1942             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1943                 revert TransferToNonERC721ReceiverImplementer();
1944             }
1945     }
1946 
1947     /**
1948      * @dev Hook that is called before a set of serially-ordered token IDs
1949      * are about to be transferred. This includes minting.
1950      * And also called before burning one token.
1951      *
1952      * `startTokenId` - the first token ID to be transferred.
1953      * `quantity` - the amount to be transferred.
1954      *
1955      * Calling conditions:
1956      *
1957      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1958      * transferred to `to`.
1959      * - When `from` is zero, `tokenId` will be minted for `to`.
1960      * - When `to` is zero, `tokenId` will be burned by `from`.
1961      * - `from` and `to` are never both zero.
1962      */
1963     function _beforeTokenTransfers(
1964         address from,
1965         address to,
1966         uint256 startTokenId,
1967         uint256 quantity
1968     ) internal virtual {}
1969 
1970     /**
1971      * @dev Hook that is called after a set of serially-ordered token IDs
1972      * have been transferred. This includes minting.
1973      * And also called after one token has been burned.
1974      *
1975      * `startTokenId` - the first token ID to be transferred.
1976      * `quantity` - the amount to be transferred.
1977      *
1978      * Calling conditions:
1979      *
1980      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1981      * transferred to `to`.
1982      * - When `from` is zero, `tokenId` has been minted for `to`.
1983      * - When `to` is zero, `tokenId` has been burned by `from`.
1984      * - `from` and `to` are never both zero.
1985      */
1986     function _afterTokenTransfers(
1987         address from,
1988         address to,
1989         uint256 startTokenId,
1990         uint256 quantity
1991     ) internal virtual {}
1992 
1993     /**
1994      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1995      *
1996      * `from` - Previous owner of the given token ID.
1997      * `to` - Target address that will receive the token.
1998      * `tokenId` - Token ID to be transferred.
1999      * `_data` - Optional data to send along with the call.
2000      *
2001      * Returns whether the call correctly returned the expected magic value.
2002      */
2003     function _checkContractOnERC721Received(
2004         address from,
2005         address to,
2006         uint256 tokenId,
2007         bytes memory _data
2008     ) private returns (bool) {
2009         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2010             bytes4 retval
2011         ) {
2012             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2013         } catch (bytes memory reason) {
2014             if (reason.length == 0) {
2015                 revert TransferToNonERC721ReceiverImplementer();
2016             } else {
2017                 assembly {
2018                     revert(add(32, reason), mload(reason))
2019                 }
2020             }
2021         }
2022     }
2023 
2024     // =============================================================
2025     //                        MINT OPERATIONS
2026     // =============================================================
2027 
2028     /**
2029      * @dev Mints `quantity` tokens and transfers them to `to`.
2030      *
2031      * Requirements:
2032      *
2033      * - `to` cannot be the zero address.
2034      * - `quantity` must be greater than 0.
2035      *
2036      * Emits a {Transfer} event for each mint.
2037      */
2038     function _mint(address to, uint256 quantity) internal virtual {
2039         uint256 startTokenId = _currentIndex;
2040         if (quantity == 0) revert MintZeroQuantity();
2041 
2042         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2043 
2044         // Overflows are incredibly unrealistic.
2045         // `balance` and `numberMinted` have a maximum limit of 2**64.
2046         // `tokenId` has a maximum limit of 2**256.
2047         unchecked {
2048             // Updates:
2049             // - `balance += quantity`.
2050             // - `numberMinted += quantity`.
2051             //
2052             // We can directly add to the `balance` and `numberMinted`.
2053             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2054 
2055             // Updates:
2056             // - `address` to the owner.
2057             // - `startTimestamp` to the timestamp of minting.
2058             // - `burned` to `false`.
2059             // - `nextInitialized` to `quantity == 1`.
2060             _packedOwnerships[startTokenId] = _packOwnershipData(
2061                 to,
2062                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2063             );
2064 
2065             uint256 toMasked;
2066             uint256 end = startTokenId + quantity;
2067 
2068             // Use assembly to loop and emit the `Transfer` event for gas savings.
2069             // The duplicated `log4` removes an extra check and reduces stack juggling.
2070             // The assembly, together with the surrounding Solidity code, have been
2071             // delicately arranged to nudge the compiler into producing optimized opcodes.
2072             assembly {
2073                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2074                 toMasked := and(to, _BITMASK_ADDRESS)
2075                 // Emit the `Transfer` event.
2076                 log4(
2077                     0, // Start of data (0, since no data).
2078                     0, // End of data (0, since no data).
2079                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2080                     0, // `address(0)`.
2081                     toMasked, // `to`.
2082                     startTokenId // `tokenId`.
2083                 )
2084 
2085                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2086                 // that overflows uint256 will make the loop run out of gas.
2087                 // The compiler will optimize the `iszero` away for performance.
2088                 for {
2089                     let tokenId := add(startTokenId, 1)
2090                 } iszero(eq(tokenId, end)) {
2091                     tokenId := add(tokenId, 1)
2092                 } {
2093                     // Emit the `Transfer` event. Similar to above.
2094                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2095                 }
2096             }
2097             if (toMasked == 0) revert MintToZeroAddress();
2098 
2099             _currentIndex = end;
2100         }
2101         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2102     }
2103 
2104     /**
2105      * @dev Mints `quantity` tokens and transfers them to `to`.
2106      *
2107      * This function is intended for efficient minting only during contract creation.
2108      *
2109      * It emits only one {ConsecutiveTransfer} as defined in
2110      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2111      * instead of a sequence of {Transfer} event(s).
2112      *
2113      * Calling this function outside of contract creation WILL make your contract
2114      * non-compliant with the ERC721 standard.
2115      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2116      * {ConsecutiveTransfer} event is only permissible during contract creation.
2117      *
2118      * Requirements:
2119      *
2120      * - `to` cannot be the zero address.
2121      * - `quantity` must be greater than 0.
2122      *
2123      * Emits a {ConsecutiveTransfer} event.
2124      */
2125     function _mintERC2309(address to, uint256 quantity) internal virtual {
2126         uint256 startTokenId = _currentIndex;
2127         if (to == address(0)) revert MintToZeroAddress();
2128         if (quantity == 0) revert MintZeroQuantity();
2129         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2130 
2131         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2132 
2133         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2134         unchecked {
2135             // Updates:
2136             // - `balance += quantity`.
2137             // - `numberMinted += quantity`.
2138             //
2139             // We can directly add to the `balance` and `numberMinted`.
2140             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2141 
2142             // Updates:
2143             // - `address` to the owner.
2144             // - `startTimestamp` to the timestamp of minting.
2145             // - `burned` to `false`.
2146             // - `nextInitialized` to `quantity == 1`.
2147             _packedOwnerships[startTokenId] = _packOwnershipData(
2148                 to,
2149                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2150             );
2151 
2152             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2153 
2154             _currentIndex = startTokenId + quantity;
2155         }
2156         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2157     }
2158 
2159     /**
2160      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2161      *
2162      * Requirements:
2163      *
2164      * - If `to` refers to a smart contract, it must implement
2165      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2166      * - `quantity` must be greater than 0.
2167      *
2168      * See {_mint}.
2169      *
2170      * Emits a {Transfer} event for each mint.
2171      */
2172     function _safeMint(
2173         address to,
2174         uint256 quantity,
2175         bytes memory _data
2176     ) internal virtual {
2177         _mint(to, quantity);
2178 
2179         unchecked {
2180             if (to.code.length != 0) {
2181                 uint256 end = _currentIndex;
2182                 uint256 index = end - quantity;
2183                 do {
2184                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2185                         revert TransferToNonERC721ReceiverImplementer();
2186                     }
2187                 } while (index < end);
2188                 // Reentrancy protection.
2189                 if (_currentIndex != end) revert();
2190             }
2191         }
2192     }
2193 
2194     /**
2195      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2196      */
2197     function _safeMint(address to, uint256 quantity) internal virtual {
2198         _safeMint(to, quantity, '');
2199     }
2200 
2201     // =============================================================
2202     //                        BURN OPERATIONS
2203     // =============================================================
2204 
2205     /**
2206      * @dev Equivalent to `_burn(tokenId, false)`.
2207      */
2208     function _burn(uint256 tokenId) internal virtual {
2209         _burn(tokenId, false);
2210     }
2211 
2212     /**
2213      * @dev Destroys `tokenId`.
2214      * The approval is cleared when the token is burned.
2215      *
2216      * Requirements:
2217      *
2218      * - `tokenId` must exist.
2219      *
2220      * Emits a {Transfer} event.
2221      */
2222     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2223         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2224 
2225         address from = address(uint160(prevOwnershipPacked));
2226 
2227         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2228 
2229         if (approvalCheck) {
2230             // The nested ifs save around 20+ gas over a compound boolean condition.
2231             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2232                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2233         }
2234 
2235         _beforeTokenTransfers(from, address(0), tokenId, 1);
2236 
2237         // Clear approvals from the previous owner.
2238         assembly {
2239             if approvedAddress {
2240                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2241                 sstore(approvedAddressSlot, 0)
2242             }
2243         }
2244 
2245         // Underflow of the sender's balance is impossible because we check for
2246         // ownership above and the recipient's balance can't realistically overflow.
2247         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2248         unchecked {
2249             // Updates:
2250             // - `balance -= 1`.
2251             // - `numberBurned += 1`.
2252             //
2253             // We can directly decrement the balance, and increment the number burned.
2254             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2255             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2256 
2257             // Updates:
2258             // - `address` to the last owner.
2259             // - `startTimestamp` to the timestamp of burning.
2260             // - `burned` to `true`.
2261             // - `nextInitialized` to `true`.
2262             _packedOwnerships[tokenId] = _packOwnershipData(
2263                 from,
2264                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2265             );
2266 
2267             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2268             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2269                 uint256 nextTokenId = tokenId + 1;
2270                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2271                 if (_packedOwnerships[nextTokenId] == 0) {
2272                     // If the next slot is within bounds.
2273                     if (nextTokenId != _currentIndex) {
2274                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2275                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2276                     }
2277                 }
2278             }
2279         }
2280 
2281         emit Transfer(from, address(0), tokenId);
2282         _afterTokenTransfers(from, address(0), tokenId, 1);
2283 
2284         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2285         unchecked {
2286             _burnCounter++;
2287         }
2288     }
2289 
2290     // =============================================================
2291     //                     EXTRA DATA OPERATIONS
2292     // =============================================================
2293 
2294     /**
2295      * @dev Directly sets the extra data for the ownership data `index`.
2296      */
2297     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2298         uint256 packed = _packedOwnerships[index];
2299         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2300         uint256 extraDataCasted;
2301         // Cast `extraData` with assembly to avoid redundant masking.
2302         assembly {
2303             extraDataCasted := extraData
2304         }
2305         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2306         _packedOwnerships[index] = packed;
2307     }
2308 
2309     /**
2310      * @dev Called during each token transfer to set the 24bit `extraData` field.
2311      * Intended to be overridden by the cosumer contract.
2312      *
2313      * `previousExtraData` - the value of `extraData` before transfer.
2314      *
2315      * Calling conditions:
2316      *
2317      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2318      * transferred to `to`.
2319      * - When `from` is zero, `tokenId` will be minted for `to`.
2320      * - When `to` is zero, `tokenId` will be burned by `from`.
2321      * - `from` and `to` are never both zero.
2322      */
2323     function _extraData(
2324         address from,
2325         address to,
2326         uint24 previousExtraData
2327     ) internal view virtual returns (uint24) {}
2328 
2329     /**
2330      * @dev Returns the next extra data for the packed ownership data.
2331      * The returned result is shifted into position.
2332      */
2333     function _nextExtraData(
2334         address from,
2335         address to,
2336         uint256 prevOwnershipPacked
2337     ) private view returns (uint256) {
2338         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2339         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2340     }
2341 
2342     // =============================================================
2343     //                       OTHER OPERATIONS
2344     // =============================================================
2345 
2346     /**
2347      * @dev Returns the message sender (defaults to `msg.sender`).
2348      *
2349      * If you are writing GSN compatible contracts, you need to override this function.
2350      */
2351     function _msgSenderERC721A() internal view virtual returns (address) {
2352         return msg.sender;
2353     }
2354 
2355     /**
2356      * @dev Converts a uint256 to its ASCII string decimal representation.
2357      */
2358     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2359         assembly {
2360             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2361             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2362             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2363             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2364             let m := add(mload(0x40), 0xa0)
2365             // Update the free memory pointer to allocate.
2366             mstore(0x40, m)
2367             // Assign the `str` to the end.
2368             str := sub(m, 0x20)
2369             // Zeroize the slot after the string.
2370             mstore(str, 0)
2371 
2372             // Cache the end of the memory to calculate the length later.
2373             let end := str
2374 
2375             // We write the string from rightmost digit to leftmost digit.
2376             // The following is essentially a do-while loop that also handles the zero case.
2377             // prettier-ignore
2378             for { let temp := value } 1 {} {
2379                 str := sub(str, 1)
2380                 // Write the character to the pointer.
2381                 // The ASCII index of the '0' character is 48.
2382                 mstore8(str, add(48, mod(temp, 10)))
2383                 // Keep dividing `temp` until zero.
2384                 temp := div(temp, 10)
2385                 // prettier-ignore
2386                 if iszero(temp) { break }
2387             }
2388 
2389             let length := sub(end, str)
2390             // Move the pointer 32 bytes leftwards to make room for the length.
2391             str := sub(str, 0x20)
2392             // Store the length.
2393             mstore(str, length)
2394         }
2395     }
2396 }
2397 
2398 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
2399 
2400 
2401 // ERC721A Contracts v4.2.3
2402 // Creator: Chiru Labs
2403 
2404 pragma solidity ^0.8.4;
2405 
2406 
2407 /**
2408  * @dev Interface of ERC721AQueryable.
2409  */
2410 interface IERC721AQueryable is IERC721A {
2411     /**
2412      * Invalid query range (`start` >= `stop`).
2413      */
2414     error InvalidQueryRange();
2415 
2416     /**
2417      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2418      *
2419      * If the `tokenId` is out of bounds:
2420      *
2421      * - `addr = address(0)`
2422      * - `startTimestamp = 0`
2423      * - `burned = false`
2424      * - `extraData = 0`
2425      *
2426      * If the `tokenId` is burned:
2427      *
2428      * - `addr = <Address of owner before token was burned>`
2429      * - `startTimestamp = <Timestamp when token was burned>`
2430      * - `burned = true`
2431      * - `extraData = <Extra data when token was burned>`
2432      *
2433      * Otherwise:
2434      *
2435      * - `addr = <Address of owner>`
2436      * - `startTimestamp = <Timestamp of start of ownership>`
2437      * - `burned = false`
2438      * - `extraData = <Extra data at start of ownership>`
2439      */
2440     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
2441 
2442     /**
2443      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2444      * See {ERC721AQueryable-explicitOwnershipOf}
2445      */
2446     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
2447 
2448     /**
2449      * @dev Returns an array of token IDs owned by `owner`,
2450      * in the range [`start`, `stop`)
2451      * (i.e. `start <= tokenId < stop`).
2452      *
2453      * This function allows for tokens to be queried if the collection
2454      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2455      *
2456      * Requirements:
2457      *
2458      * - `start < stop`
2459      */
2460     function tokensOfOwnerIn(
2461         address owner,
2462         uint256 start,
2463         uint256 stop
2464     ) external view returns (uint256[] memory);
2465 
2466     /**
2467      * @dev Returns an array of token IDs owned by `owner`.
2468      *
2469      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2470      * It is meant to be called off-chain.
2471      *
2472      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2473      * multiple smaller scans if the collection is large enough to cause
2474      * an out-of-gas error (10K collections should be fine).
2475      */
2476     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2477 }
2478 
2479 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2480 
2481 
2482 // ERC721A Contracts v4.2.3
2483 // Creator: Chiru Labs
2484 
2485 pragma solidity ^0.8.4;
2486 
2487 
2488 
2489 /**
2490  * @title ERC721AQueryable.
2491  *
2492  * @dev ERC721A subclass with convenience query functions.
2493  */
2494 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2495     /**
2496      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2497      *
2498      * If the `tokenId` is out of bounds:
2499      *
2500      * - `addr = address(0)`
2501      * - `startTimestamp = 0`
2502      * - `burned = false`
2503      * - `extraData = 0`
2504      *
2505      * If the `tokenId` is burned:
2506      *
2507      * - `addr = <Address of owner before token was burned>`
2508      * - `startTimestamp = <Timestamp when token was burned>`
2509      * - `burned = true`
2510      * - `extraData = <Extra data when token was burned>`
2511      *
2512      * Otherwise:
2513      *
2514      * - `addr = <Address of owner>`
2515      * - `startTimestamp = <Timestamp of start of ownership>`
2516      * - `burned = false`
2517      * - `extraData = <Extra data at start of ownership>`
2518      */
2519     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2520         TokenOwnership memory ownership;
2521         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2522             return ownership;
2523         }
2524         ownership = _ownershipAt(tokenId);
2525         if (ownership.burned) {
2526             return ownership;
2527         }
2528         return _ownershipOf(tokenId);
2529     }
2530 
2531     /**
2532      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2533      * See {ERC721AQueryable-explicitOwnershipOf}
2534      */
2535     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2536         external
2537         view
2538         virtual
2539         override
2540         returns (TokenOwnership[] memory)
2541     {
2542         unchecked {
2543             uint256 tokenIdsLength = tokenIds.length;
2544             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2545             for (uint256 i; i != tokenIdsLength; ++i) {
2546                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2547             }
2548             return ownerships;
2549         }
2550     }
2551 
2552     /**
2553      * @dev Returns an array of token IDs owned by `owner`,
2554      * in the range [`start`, `stop`)
2555      * (i.e. `start <= tokenId < stop`).
2556      *
2557      * This function allows for tokens to be queried if the collection
2558      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2559      *
2560      * Requirements:
2561      *
2562      * - `start < stop`
2563      */
2564     function tokensOfOwnerIn(
2565         address owner,
2566         uint256 start,
2567         uint256 stop
2568     ) external view virtual override returns (uint256[] memory) {
2569         unchecked {
2570             if (start >= stop) revert InvalidQueryRange();
2571             uint256 tokenIdsIdx;
2572             uint256 stopLimit = _nextTokenId();
2573             // Set `start = max(start, _startTokenId())`.
2574             if (start < _startTokenId()) {
2575                 start = _startTokenId();
2576             }
2577             // Set `stop = min(stop, stopLimit)`.
2578             if (stop > stopLimit) {
2579                 stop = stopLimit;
2580             }
2581             uint256 tokenIdsMaxLength = balanceOf(owner);
2582             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2583             // to cater for cases where `balanceOf(owner)` is too big.
2584             if (start < stop) {
2585                 uint256 rangeLength = stop - start;
2586                 if (rangeLength < tokenIdsMaxLength) {
2587                     tokenIdsMaxLength = rangeLength;
2588                 }
2589             } else {
2590                 tokenIdsMaxLength = 0;
2591             }
2592             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2593             if (tokenIdsMaxLength == 0) {
2594                 return tokenIds;
2595             }
2596             // We need to call `explicitOwnershipOf(start)`,
2597             // because the slot at `start` may not be initialized.
2598             TokenOwnership memory ownership = explicitOwnershipOf(start);
2599             address currOwnershipAddr;
2600             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2601             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2602             if (!ownership.burned) {
2603                 currOwnershipAddr = ownership.addr;
2604             }
2605             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2606                 ownership = _ownershipAt(i);
2607                 if (ownership.burned) {
2608                     continue;
2609                 }
2610                 if (ownership.addr != address(0)) {
2611                     currOwnershipAddr = ownership.addr;
2612                 }
2613                 if (currOwnershipAddr == owner) {
2614                     tokenIds[tokenIdsIdx++] = i;
2615                 }
2616             }
2617             // Downsize the array to fit.
2618             assembly {
2619                 mstore(tokenIds, tokenIdsIdx)
2620             }
2621             return tokenIds;
2622         }
2623     }
2624 
2625     /**
2626      * @dev Returns an array of token IDs owned by `owner`.
2627      *
2628      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2629      * It is meant to be called off-chain.
2630      *
2631      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2632      * multiple smaller scans if the collection is large enough to cause
2633      * an out-of-gas error (10K collections should be fine).
2634      */
2635     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2636         unchecked {
2637             uint256 tokenIdsIdx;
2638             address currOwnershipAddr;
2639             uint256 tokenIdsLength = balanceOf(owner);
2640             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2641             TokenOwnership memory ownership;
2642             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2643                 ownership = _ownershipAt(i);
2644                 if (ownership.burned) {
2645                     continue;
2646                 }
2647                 if (ownership.addr != address(0)) {
2648                     currOwnershipAddr = ownership.addr;
2649                 }
2650                 if (currOwnershipAddr == owner) {
2651                     tokenIds[tokenIdsIdx++] = i;
2652                 }
2653             }
2654             return tokenIds;
2655         }
2656     }
2657 }
2658 
2659 // File: contracts/BulletsClub.sol
2660 
2661 
2662 
2663 pragma solidity >=0.8.13 <0.9.0;
2664 
2665 
2666 
2667 
2668 
2669 
2670 
2671 
2672 
2673 
2674 contract BulletsClub is ERC721A, Ownable, ReentrancyGuard {
2675 
2676   using Strings for uint256;
2677 
2678 // ================== Variables Start =======================
2679     
2680     string public uri;
2681     string public uriSuffix = ".json";
2682     uint256 public pricePublic = 0.125 ether;
2683 
2684     uint256 public maxSupply = 1326;
2685     uint256 public maxMintAmountPerTx = 5;
2686     uint256 public maxLimitPerWallet = 1326;
2687     bool public publicMinting = false;
2688 
2689     mapping (address => uint256) public addressBalance;
2690 
2691 
2692 // ================== Variables End =======================  
2693 
2694 // ================== Constructor Start =======================
2695 
2696     constructor(
2697         string memory _uri
2698     ) ERC721A("Bullets Club NFT", "BCN")  {
2699         seturi(_uri);
2700     }
2701 
2702 // ================== Constructor End =======================
2703 
2704 // ================== Modifiers Start =======================
2705 
2706 // ================== Modifiers End ========================
2707 
2708 // ================== Mint Functions Start =======================
2709  
2710     function CollectReserves(uint256 amount) public onlyOwner nonReentrant {
2711         require(totalSupply() + amount <= maxSupply, 'Max Supply Exceeded.');
2712         _safeMint(msg.sender, amount);
2713     }
2714 
2715     function Mint(uint256 _mintAmount) public payable nonReentrant {
2716         uint256 supply = totalSupply();
2717         // Normal requirements 
2718         require(publicMinting, 'Public sale not active!');
2719         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
2720         require(supply + _mintAmount <= maxSupply, 'Max supply exceeded!');
2721         require(msg.value >= pricePublic * _mintAmount, 'Insufficient funds!');
2722         require(addressBalance[msg.sender] < maxLimitPerWallet, 'Too many NFTs minted to wallet.');
2723         
2724         addressBalance[msg.sender] += _mintAmount;
2725         // Mint
2726         _safeMint(_msgSender(), _mintAmount);
2727     }  
2728 
2729     function Airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
2730         require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2731         _safeMint(_receiver, _mintAmount);
2732     }
2733 
2734 
2735 // ================== Mint Functions End =======================  
2736 
2737 // ================== Set Functions Start =======================
2738 
2739 // uri
2740     function seturi(string memory _uri) public onlyOwner {
2741         uri = _uri;
2742     }
2743 
2744     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2745         uriSuffix = _uriSuffix;
2746     }
2747 
2748 // max per tx
2749     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2750         maxMintAmountPerTx = _maxMintAmountPerTx;
2751     }
2752 
2753 // max per wallet
2754     function setMaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
2755         maxLimitPerWallet = _maxLimitPerWallet;
2756     }
2757 
2758 // price
2759 
2760     function setCostPublic(uint256 _cost) public onlyOwner {
2761         pricePublic = _cost;
2762     }  
2763 
2764 // supply limit
2765     function setSupplyLimit(uint256 _supplyLimit) public onlyOwner {
2766         maxSupply = _supplyLimit;
2767     }
2768 
2769 // set mintingallowed
2770     function setPublicMinting(bool setActive) public onlyOwner {
2771         publicMinting = setActive;
2772     }
2773 
2774 // ================== Set Functions End =======================
2775 
2776 // ================== Withdraw Function Start =======================
2777   
2778     function withdraw() public onlyOwner {
2779         uint256 _balance = address(this).balance;
2780         require(_balance > 0);
2781         _withdraw(owner(), address(this).balance);
2782     }
2783 
2784     function _withdraw(address _address, uint256 _amount) private {
2785         (bool success, ) = _address.call{value: _amount}("");
2786         require(success, "Transfer failed.");
2787     }
2788 
2789 
2790 // ================== Withdraw Function End=======================  
2791 
2792 // ================== Read Functions Start =======================
2793 
2794     function tokensOfOwner(address owner) external view returns (uint256[] memory) {
2795         unchecked {
2796             uint256[] memory a = new uint256[](balanceOf(owner)); 
2797             uint256 end = _nextTokenId();
2798             uint256 tokenIdsIdx;
2799             address currOwnershipAddr;
2800             for (uint256 i; i < end; i++) {
2801                 TokenOwnership memory ownership = _ownershipAt(i);
2802                 if (ownership.burned) {
2803                     continue;
2804                 }
2805                 if (ownership.addr != address(0)) {
2806                     currOwnershipAddr = ownership.addr;
2807                 }
2808                 if (currOwnershipAddr == owner) {
2809                     a[tokenIdsIdx++] = i;
2810                 }
2811             }
2812             return a;    
2813         }
2814     }
2815 
2816     function _startTokenId() internal view virtual override returns (uint256) {
2817         return 0;
2818     }
2819 
2820     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2821         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2822 
2823         string memory currentBaseURI = _baseURI();
2824         return bytes(currentBaseURI).length > 0
2825             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2826             : '';
2827     }
2828 
2829     function _baseURI() internal view virtual override returns (string memory) {
2830         return uri;
2831     }
2832 
2833 // ================== Read Functions End =======================  
2834 }