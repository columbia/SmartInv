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
647 // File: @openzeppelin/contracts/utils/Address.sol
648 
649 
650 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
651 
652 pragma solidity ^0.8.1;
653 
654 /**
655  * @dev Collection of functions related to the address type
656  */
657 library Address {
658     /**
659      * @dev Returns true if `account` is a contract.
660      *
661      * [IMPORTANT]
662      * ====
663      * It is unsafe to assume that an address for which this function returns
664      * false is an externally-owned account (EOA) and not a contract.
665      *
666      * Among others, `isContract` will return false for the following
667      * types of addresses:
668      *
669      *  - an externally-owned account
670      *  - a contract in construction
671      *  - an address where a contract will be created
672      *  - an address where a contract lived, but was destroyed
673      * ====
674      *
675      * [IMPORTANT]
676      * ====
677      * You shouldn't rely on `isContract` to protect against flash loan attacks!
678      *
679      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
680      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
681      * constructor.
682      * ====
683      */
684     function isContract(address account) internal view returns (bool) {
685         // This method relies on extcodesize/address.code.length, which returns 0
686         // for contracts in construction, since the code is only stored at the end
687         // of the constructor execution.
688 
689         return account.code.length > 0;
690     }
691 
692     /**
693      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
694      * `recipient`, forwarding all available gas and reverting on errors.
695      *
696      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
697      * of certain opcodes, possibly making contracts go over the 2300 gas limit
698      * imposed by `transfer`, making them unable to receive funds via
699      * `transfer`. {sendValue} removes this limitation.
700      *
701      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
702      *
703      * IMPORTANT: because control is transferred to `recipient`, care must be
704      * taken to not create reentrancy vulnerabilities. Consider using
705      * {ReentrancyGuard} or the
706      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
707      */
708     function sendValue(address payable recipient, uint256 amount) internal {
709         require(address(this).balance >= amount, "Address: insufficient balance");
710 
711         (bool success, ) = recipient.call{value: amount}("");
712         require(success, "Address: unable to send value, recipient may have reverted");
713     }
714 
715     /**
716      * @dev Performs a Solidity function call using a low level `call`. A
717      * plain `call` is an unsafe replacement for a function call: use this
718      * function instead.
719      *
720      * If `target` reverts with a revert reason, it is bubbled up by this
721      * function (like regular Solidity function calls).
722      *
723      * Returns the raw returned data. To convert to the expected return value,
724      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
725      *
726      * Requirements:
727      *
728      * - `target` must be a contract.
729      * - calling `target` with `data` must not revert.
730      *
731      * _Available since v3.1._
732      */
733     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
734         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
739      * `errorMessage` as a fallback revert reason when `target` reverts.
740      *
741      * _Available since v3.1._
742      */
743     function functionCall(
744         address target,
745         bytes memory data,
746         string memory errorMessage
747     ) internal returns (bytes memory) {
748         return functionCallWithValue(target, data, 0, errorMessage);
749     }
750 
751     /**
752      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
753      * but also transferring `value` wei to `target`.
754      *
755      * Requirements:
756      *
757      * - the calling contract must have an ETH balance of at least `value`.
758      * - the called Solidity function must be `payable`.
759      *
760      * _Available since v3.1._
761      */
762     function functionCallWithValue(
763         address target,
764         bytes memory data,
765         uint256 value
766     ) internal returns (bytes memory) {
767         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
772      * with `errorMessage` as a fallback revert reason when `target` reverts.
773      *
774      * _Available since v3.1._
775      */
776     function functionCallWithValue(
777         address target,
778         bytes memory data,
779         uint256 value,
780         string memory errorMessage
781     ) internal returns (bytes memory) {
782         require(address(this).balance >= value, "Address: insufficient balance for call");
783         (bool success, bytes memory returndata) = target.call{value: value}(data);
784         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
789      * but performing a static call.
790      *
791      * _Available since v3.3._
792      */
793     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
794         return functionStaticCall(target, data, "Address: low-level static call failed");
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
799      * but performing a static call.
800      *
801      * _Available since v3.3._
802      */
803     function functionStaticCall(
804         address target,
805         bytes memory data,
806         string memory errorMessage
807     ) internal view returns (bytes memory) {
808         (bool success, bytes memory returndata) = target.staticcall(data);
809         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
814      * but performing a delegate call.
815      *
816      * _Available since v3.4._
817      */
818     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
819         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
820     }
821 
822     /**
823      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
824      * but performing a delegate call.
825      *
826      * _Available since v3.4._
827      */
828     function functionDelegateCall(
829         address target,
830         bytes memory data,
831         string memory errorMessage
832     ) internal returns (bytes memory) {
833         (bool success, bytes memory returndata) = target.delegatecall(data);
834         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
835     }
836 
837     /**
838      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
839      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
840      *
841      * _Available since v4.8._
842      */
843     function verifyCallResultFromTarget(
844         address target,
845         bool success,
846         bytes memory returndata,
847         string memory errorMessage
848     ) internal view returns (bytes memory) {
849         if (success) {
850             if (returndata.length == 0) {
851                 // only check isContract if the call was successful and the return data is empty
852                 // otherwise we already know that it was a contract
853                 require(isContract(target), "Address: call to non-contract");
854             }
855             return returndata;
856         } else {
857             _revert(returndata, errorMessage);
858         }
859     }
860 
861     /**
862      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
863      * revert reason or using the provided one.
864      *
865      * _Available since v4.3._
866      */
867     function verifyCallResult(
868         bool success,
869         bytes memory returndata,
870         string memory errorMessage
871     ) internal pure returns (bytes memory) {
872         if (success) {
873             return returndata;
874         } else {
875             _revert(returndata, errorMessage);
876         }
877     }
878 
879     function _revert(bytes memory returndata, string memory errorMessage) private pure {
880         // Look for revert reason and bubble it up if present
881         if (returndata.length > 0) {
882             // The easiest way to bubble the revert reason is using memory via assembly
883             /// @solidity memory-safe-assembly
884             assembly {
885                 let returndata_size := mload(returndata)
886                 revert(add(32, returndata), returndata_size)
887             }
888         } else {
889             revert(errorMessage);
890         }
891     }
892 }
893 
894 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
895 
896 
897 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
898 
899 pragma solidity ^0.8.0;
900 
901 /**
902  * @title ERC721 token receiver interface
903  * @dev Interface for any contract that wants to support safeTransfers
904  * from ERC721 asset contracts.
905  */
906 interface IERC721Receiver {
907     /**
908      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
909      * by `operator` from `from`, this function is called.
910      *
911      * It must return its Solidity selector to confirm the token transfer.
912      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
913      *
914      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
915      */
916     function onERC721Received(
917         address operator,
918         address from,
919         uint256 tokenId,
920         bytes calldata data
921     ) external returns (bytes4);
922 }
923 
924 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
925 
926 
927 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
928 
929 pragma solidity ^0.8.0;
930 
931 /**
932  * @dev Interface of the ERC165 standard, as defined in the
933  * https://eips.ethereum.org/EIPS/eip-165[EIP].
934  *
935  * Implementers can declare support of contract interfaces, which can then be
936  * queried by others ({ERC165Checker}).
937  *
938  * For an implementation, see {ERC165}.
939  */
940 interface IERC165 {
941     /**
942      * @dev Returns true if this contract implements the interface defined by
943      * `interfaceId`. See the corresponding
944      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
945      * to learn more about how these ids are created.
946      *
947      * This function call must use less than 30 000 gas.
948      */
949     function supportsInterface(bytes4 interfaceId) external view returns (bool);
950 }
951 
952 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
953 
954 
955 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
956 
957 pragma solidity ^0.8.0;
958 
959 
960 /**
961  * @dev Implementation of the {IERC165} interface.
962  *
963  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
964  * for the additional interface id that will be supported. For example:
965  *
966  * ```solidity
967  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
968  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
969  * }
970  * ```
971  *
972  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
973  */
974 abstract contract ERC165 is IERC165 {
975     /**
976      * @dev See {IERC165-supportsInterface}.
977      */
978     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
979         return interfaceId == type(IERC165).interfaceId;
980     }
981 }
982 
983 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
984 
985 
986 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
987 
988 pragma solidity ^0.8.0;
989 
990 
991 /**
992  * @dev Required interface of an ERC721 compliant contract.
993  */
994 interface IERC721 is IERC165 {
995     /**
996      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
997      */
998     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
999 
1000     /**
1001      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1002      */
1003     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1004 
1005     /**
1006      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1007      */
1008     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1009 
1010     /**
1011      * @dev Returns the number of tokens in ``owner``'s account.
1012      */
1013     function balanceOf(address owner) external view returns (uint256 balance);
1014 
1015     /**
1016      * @dev Returns the owner of the `tokenId` token.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must exist.
1021      */
1022     function ownerOf(uint256 tokenId) external view returns (address owner);
1023 
1024     /**
1025      * @dev Safely transfers `tokenId` token from `from` to `to`.
1026      *
1027      * Requirements:
1028      *
1029      * - `from` cannot be the zero address.
1030      * - `to` cannot be the zero address.
1031      * - `tokenId` token must exist and be owned by `from`.
1032      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1033      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes calldata data
1042     ) external;
1043 
1044     /**
1045      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1046      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1047      *
1048      * Requirements:
1049      *
1050      * - `from` cannot be the zero address.
1051      * - `to` cannot be the zero address.
1052      * - `tokenId` token must exist and be owned by `from`.
1053      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1054      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function safeTransferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId
1062     ) external;
1063 
1064     /**
1065      * @dev Transfers `tokenId` token from `from` to `to`.
1066      *
1067      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1068      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1069      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1070      *
1071      * Requirements:
1072      *
1073      * - `from` cannot be the zero address.
1074      * - `to` cannot be the zero address.
1075      * - `tokenId` token must be owned by `from`.
1076      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1077      *
1078      * Emits a {Transfer} event.
1079      */
1080     function transferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId
1084     ) external;
1085 
1086     /**
1087      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1088      * The approval is cleared when the token is transferred.
1089      *
1090      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1091      *
1092      * Requirements:
1093      *
1094      * - The caller must own the token or be an approved operator.
1095      * - `tokenId` must exist.
1096      *
1097      * Emits an {Approval} event.
1098      */
1099     function approve(address to, uint256 tokenId) external;
1100 
1101     /**
1102      * @dev Approve or remove `operator` as an operator for the caller.
1103      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1104      *
1105      * Requirements:
1106      *
1107      * - The `operator` cannot be the caller.
1108      *
1109      * Emits an {ApprovalForAll} event.
1110      */
1111     function setApprovalForAll(address operator, bool _approved) external;
1112 
1113     /**
1114      * @dev Returns the account approved for `tokenId` token.
1115      *
1116      * Requirements:
1117      *
1118      * - `tokenId` must exist.
1119      */
1120     function getApproved(uint256 tokenId) external view returns (address operator);
1121 
1122     /**
1123      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1124      *
1125      * See {setApprovalForAll}
1126      */
1127     function isApprovedForAll(address owner, address operator) external view returns (bool);
1128 }
1129 
1130 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1131 
1132 
1133 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1134 
1135 pragma solidity ^0.8.0;
1136 
1137 
1138 /**
1139  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1140  * @dev See https://eips.ethereum.org/EIPS/eip-721
1141  */
1142 interface IERC721Metadata is IERC721 {
1143     /**
1144      * @dev Returns the token collection name.
1145      */
1146     function name() external view returns (string memory);
1147 
1148     /**
1149      * @dev Returns the token collection symbol.
1150      */
1151     function symbol() external view returns (string memory);
1152 
1153     /**
1154      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1155      */
1156     function tokenURI(uint256 tokenId) external view returns (string memory);
1157 }
1158 
1159 // File: @openzeppelin/contracts/utils/Base64.sol
1160 
1161 
1162 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
1163 
1164 pragma solidity ^0.8.0;
1165 
1166 /**
1167  * @dev Provides a set of functions to operate with Base64 strings.
1168  *
1169  * _Available since v4.5._
1170  */
1171 library Base64 {
1172     /**
1173      * @dev Base64 Encoding/Decoding Table
1174      */
1175     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1176 
1177     /**
1178      * @dev Converts a `bytes` to its Bytes64 `string` representation.
1179      */
1180     function encode(bytes memory data) internal pure returns (string memory) {
1181         /**
1182          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
1183          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
1184          */
1185         if (data.length == 0) return "";
1186 
1187         // Loads the table into memory
1188         string memory table = _TABLE;
1189 
1190         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
1191         // and split into 4 numbers of 6 bits.
1192         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
1193         // - `data.length + 2`  -> Round up
1194         // - `/ 3`              -> Number of 3-bytes chunks
1195         // - `4 *`              -> 4 characters for each chunk
1196         string memory result = new string(4 * ((data.length + 2) / 3));
1197 
1198         /// @solidity memory-safe-assembly
1199         assembly {
1200             // Prepare the lookup table (skip the first "length" byte)
1201             let tablePtr := add(table, 1)
1202 
1203             // Prepare result pointer, jump over length
1204             let resultPtr := add(result, 32)
1205 
1206             // Run over the input, 3 bytes at a time
1207             for {
1208                 let dataPtr := data
1209                 let endPtr := add(data, mload(data))
1210             } lt(dataPtr, endPtr) {
1211 
1212             } {
1213                 // Advance 3 bytes
1214                 dataPtr := add(dataPtr, 3)
1215                 let input := mload(dataPtr)
1216 
1217                 // To write each character, shift the 3 bytes (18 bits) chunk
1218                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
1219                 // and apply logical AND with 0x3F which is the number of
1220                 // the previous character in the ASCII table prior to the Base64 Table
1221                 // The result is then added to the table to get the character to write,
1222                 // and finally write it in the result pointer but with a left shift
1223                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
1224 
1225                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1226                 resultPtr := add(resultPtr, 1) // Advance
1227 
1228                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1229                 resultPtr := add(resultPtr, 1) // Advance
1230 
1231                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
1232                 resultPtr := add(resultPtr, 1) // Advance
1233 
1234                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
1235                 resultPtr := add(resultPtr, 1) // Advance
1236             }
1237 
1238             // When data `bytes` is not exactly 3 bytes long
1239             // it is padded with `=` characters at the end
1240             switch mod(mload(data), 3)
1241             case 1 {
1242                 mstore8(sub(resultPtr, 1), 0x3d)
1243                 mstore8(sub(resultPtr, 2), 0x3d)
1244             }
1245             case 2 {
1246                 mstore8(sub(resultPtr, 1), 0x3d)
1247             }
1248         }
1249 
1250         return result;
1251     }
1252 }
1253 
1254 // File: @openzeppelin/contracts/utils/Context.sol
1255 
1256 
1257 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 /**
1262  * @dev Provides information about the current execution context, including the
1263  * sender of the transaction and its data. While these are generally available
1264  * via msg.sender and msg.data, they should not be accessed in such a direct
1265  * manner, since when dealing with meta-transactions the account sending and
1266  * paying for execution may not be the actual sender (as far as an application
1267  * is concerned).
1268  *
1269  * This contract is only required for intermediate, library-like contracts.
1270  */
1271 abstract contract Context {
1272     function _msgSender() internal view virtual returns (address) {
1273         return msg.sender;
1274     }
1275 
1276     function _msgData() internal view virtual returns (bytes calldata) {
1277         return msg.data;
1278     }
1279 }
1280 
1281 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1282 
1283 
1284 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 
1289 
1290 
1291 
1292 
1293 
1294 
1295 /**
1296  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1297  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1298  * {ERC721Enumerable}.
1299  */
1300 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1301     using Address for address;
1302     using Strings for uint256;
1303 
1304     // Token name
1305     string private _name;
1306 
1307     // Token symbol
1308     string private _symbol;
1309 
1310     // Mapping from token ID to owner address
1311     mapping(uint256 => address) private _owners;
1312 
1313     // Mapping owner address to token count
1314     mapping(address => uint256) private _balances;
1315 
1316     // Mapping from token ID to approved address
1317     mapping(uint256 => address) private _tokenApprovals;
1318 
1319     // Mapping from owner to operator approvals
1320     mapping(address => mapping(address => bool)) private _operatorApprovals;
1321 
1322     /**
1323      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1324      */
1325     constructor(string memory name_, string memory symbol_) {
1326         _name = name_;
1327         _symbol = symbol_;
1328     }
1329 
1330     /**
1331      * @dev See {IERC165-supportsInterface}.
1332      */
1333     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1334         return
1335             interfaceId == type(IERC721).interfaceId ||
1336             interfaceId == type(IERC721Metadata).interfaceId ||
1337             super.supportsInterface(interfaceId);
1338     }
1339 
1340     /**
1341      * @dev See {IERC721-balanceOf}.
1342      */
1343     function balanceOf(address owner) public view virtual override returns (uint256) {
1344         require(owner != address(0), "ERC721: address zero is not a valid owner");
1345         return _balances[owner];
1346     }
1347 
1348     /**
1349      * @dev See {IERC721-ownerOf}.
1350      */
1351     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1352         address owner = _ownerOf(tokenId);
1353         require(owner != address(0), "ERC721: invalid token ID");
1354         return owner;
1355     }
1356 
1357     /**
1358      * @dev See {IERC721Metadata-name}.
1359      */
1360     function name() public view virtual override returns (string memory) {
1361         return _name;
1362     }
1363 
1364     /**
1365      * @dev See {IERC721Metadata-symbol}.
1366      */
1367     function symbol() public view virtual override returns (string memory) {
1368         return _symbol;
1369     }
1370 
1371     /**
1372      * @dev See {IERC721Metadata-tokenURI}.
1373      */
1374     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1375         _requireMinted(tokenId);
1376 
1377         string memory baseURI = _baseURI();
1378         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1379     }
1380 
1381     /**
1382      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1383      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1384      * by default, can be overridden in child contracts.
1385      */
1386     function _baseURI() internal view virtual returns (string memory) {
1387         return "";
1388     }
1389 
1390     /**
1391      * @dev See {IERC721-approve}.
1392      */
1393     function approve(address to, uint256 tokenId) public virtual override {
1394         address owner = ERC721.ownerOf(tokenId);
1395         require(to != owner, "ERC721: approval to current owner");
1396 
1397         require(
1398             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1399             "ERC721: approve caller is not token owner or approved for all"
1400         );
1401 
1402         _approve(to, tokenId);
1403     }
1404 
1405     /**
1406      * @dev See {IERC721-getApproved}.
1407      */
1408     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1409         _requireMinted(tokenId);
1410 
1411         return _tokenApprovals[tokenId];
1412     }
1413 
1414     /**
1415      * @dev See {IERC721-setApprovalForAll}.
1416      */
1417     function setApprovalForAll(address operator, bool approved) public virtual override {
1418         _setApprovalForAll(_msgSender(), operator, approved);
1419     }
1420 
1421     /**
1422      * @dev See {IERC721-isApprovedForAll}.
1423      */
1424     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1425         return _operatorApprovals[owner][operator];
1426     }
1427 
1428     /**
1429      * @dev See {IERC721-transferFrom}.
1430      */
1431     function transferFrom(
1432         address from,
1433         address to,
1434         uint256 tokenId
1435     ) public virtual override {
1436         //solhint-disable-next-line max-line-length
1437         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1438 
1439         _transfer(from, to, tokenId);
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-safeTransferFrom}.
1444      */
1445     function safeTransferFrom(
1446         address from,
1447         address to,
1448         uint256 tokenId
1449     ) public virtual override {
1450         safeTransferFrom(from, to, tokenId, "");
1451     }
1452 
1453     /**
1454      * @dev See {IERC721-safeTransferFrom}.
1455      */
1456     function safeTransferFrom(
1457         address from,
1458         address to,
1459         uint256 tokenId,
1460         bytes memory data
1461     ) public virtual override {
1462         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1463         _safeTransfer(from, to, tokenId, data);
1464     }
1465 
1466     /**
1467      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1468      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1469      *
1470      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1471      *
1472      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1473      * implement alternative mechanisms to perform token transfer, such as signature-based.
1474      *
1475      * Requirements:
1476      *
1477      * - `from` cannot be the zero address.
1478      * - `to` cannot be the zero address.
1479      * - `tokenId` token must exist and be owned by `from`.
1480      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1481      *
1482      * Emits a {Transfer} event.
1483      */
1484     function _safeTransfer(
1485         address from,
1486         address to,
1487         uint256 tokenId,
1488         bytes memory data
1489     ) internal virtual {
1490         _transfer(from, to, tokenId);
1491         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1492     }
1493 
1494     /**
1495      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1496      */
1497     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1498         return _owners[tokenId];
1499     }
1500 
1501     /**
1502      * @dev Returns whether `tokenId` exists.
1503      *
1504      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1505      *
1506      * Tokens start existing when they are minted (`_mint`),
1507      * and stop existing when they are burned (`_burn`).
1508      */
1509     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1510         return _ownerOf(tokenId) != address(0);
1511     }
1512 
1513     /**
1514      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1515      *
1516      * Requirements:
1517      *
1518      * - `tokenId` must exist.
1519      */
1520     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1521         address owner = ERC721.ownerOf(tokenId);
1522         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1523     }
1524 
1525     /**
1526      * @dev Safely mints `tokenId` and transfers it to `to`.
1527      *
1528      * Requirements:
1529      *
1530      * - `tokenId` must not exist.
1531      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1532      *
1533      * Emits a {Transfer} event.
1534      */
1535     function _safeMint(address to, uint256 tokenId) internal virtual {
1536         _safeMint(to, tokenId, "");
1537     }
1538 
1539     /**
1540      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1541      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1542      */
1543     function _safeMint(
1544         address to,
1545         uint256 tokenId,
1546         bytes memory data
1547     ) internal virtual {
1548         _mint(to, tokenId);
1549         require(
1550             _checkOnERC721Received(address(0), to, tokenId, data),
1551             "ERC721: transfer to non ERC721Receiver implementer"
1552         );
1553     }
1554 
1555     /**
1556      * @dev Mints `tokenId` and transfers it to `to`.
1557      *
1558      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1559      *
1560      * Requirements:
1561      *
1562      * - `tokenId` must not exist.
1563      * - `to` cannot be the zero address.
1564      *
1565      * Emits a {Transfer} event.
1566      */
1567     function _mint(address to, uint256 tokenId) internal virtual {
1568         require(to != address(0), "ERC721: mint to the zero address");
1569         require(!_exists(tokenId), "ERC721: token already minted");
1570 
1571         _beforeTokenTransfer(address(0), to, tokenId, 1);
1572 
1573         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1574         require(!_exists(tokenId), "ERC721: token already minted");
1575 
1576         unchecked {
1577             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1578             // Given that tokens are minted one by one, it is impossible in practice that
1579             // this ever happens. Might change if we allow batch minting.
1580             // The ERC fails to describe this case.
1581             _balances[to] += 1;
1582         }
1583 
1584         _owners[tokenId] = to;
1585 
1586         emit Transfer(address(0), to, tokenId);
1587 
1588         _afterTokenTransfer(address(0), to, tokenId, 1);
1589     }
1590 
1591     /**
1592      * @dev Destroys `tokenId`.
1593      * The approval is cleared when the token is burned.
1594      * This is an internal function that does not check if the sender is authorized to operate on the token.
1595      *
1596      * Requirements:
1597      *
1598      * - `tokenId` must exist.
1599      *
1600      * Emits a {Transfer} event.
1601      */
1602     function _burn(uint256 tokenId) internal virtual {
1603         address owner = ERC721.ownerOf(tokenId);
1604 
1605         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1606 
1607         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1608         owner = ERC721.ownerOf(tokenId);
1609 
1610         // Clear approvals
1611         delete _tokenApprovals[tokenId];
1612 
1613         unchecked {
1614             // Cannot overflow, as that would require more tokens to be burned/transferred
1615             // out than the owner initially received through minting and transferring in.
1616             _balances[owner] -= 1;
1617         }
1618         delete _owners[tokenId];
1619 
1620         emit Transfer(owner, address(0), tokenId);
1621 
1622         _afterTokenTransfer(owner, address(0), tokenId, 1);
1623     }
1624 
1625     /**
1626      * @dev Transfers `tokenId` from `from` to `to`.
1627      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1628      *
1629      * Requirements:
1630      *
1631      * - `to` cannot be the zero address.
1632      * - `tokenId` token must be owned by `from`.
1633      *
1634      * Emits a {Transfer} event.
1635      */
1636     function _transfer(
1637         address from,
1638         address to,
1639         uint256 tokenId
1640     ) internal virtual {
1641         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1642         require(to != address(0), "ERC721: transfer to the zero address");
1643 
1644         _beforeTokenTransfer(from, to, tokenId, 1);
1645 
1646         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1647         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1648 
1649         // Clear approvals from the previous owner
1650         delete _tokenApprovals[tokenId];
1651 
1652         unchecked {
1653             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1654             // `from`'s balance is the number of token held, which is at least one before the current
1655             // transfer.
1656             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1657             // all 2**256 token ids to be minted, which in practice is impossible.
1658             _balances[from] -= 1;
1659             _balances[to] += 1;
1660         }
1661         _owners[tokenId] = to;
1662 
1663         emit Transfer(from, to, tokenId);
1664 
1665         _afterTokenTransfer(from, to, tokenId, 1);
1666     }
1667 
1668     /**
1669      * @dev Approve `to` to operate on `tokenId`
1670      *
1671      * Emits an {Approval} event.
1672      */
1673     function _approve(address to, uint256 tokenId) internal virtual {
1674         _tokenApprovals[tokenId] = to;
1675         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1676     }
1677 
1678     /**
1679      * @dev Approve `operator` to operate on all of `owner` tokens
1680      *
1681      * Emits an {ApprovalForAll} event.
1682      */
1683     function _setApprovalForAll(
1684         address owner,
1685         address operator,
1686         bool approved
1687     ) internal virtual {
1688         require(owner != operator, "ERC721: approve to caller");
1689         _operatorApprovals[owner][operator] = approved;
1690         emit ApprovalForAll(owner, operator, approved);
1691     }
1692 
1693     /**
1694      * @dev Reverts if the `tokenId` has not been minted yet.
1695      */
1696     function _requireMinted(uint256 tokenId) internal view virtual {
1697         require(_exists(tokenId), "ERC721: invalid token ID");
1698     }
1699 
1700     /**
1701      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1702      * The call is not executed if the target address is not a contract.
1703      *
1704      * @param from address representing the previous owner of the given token ID
1705      * @param to target address that will receive the tokens
1706      * @param tokenId uint256 ID of the token to be transferred
1707      * @param data bytes optional data to send along with the call
1708      * @return bool whether the call correctly returned the expected magic value
1709      */
1710     function _checkOnERC721Received(
1711         address from,
1712         address to,
1713         uint256 tokenId,
1714         bytes memory data
1715     ) private returns (bool) {
1716         if (to.isContract()) {
1717             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1718                 return retval == IERC721Receiver.onERC721Received.selector;
1719             } catch (bytes memory reason) {
1720                 if (reason.length == 0) {
1721                     revert("ERC721: transfer to non ERC721Receiver implementer");
1722                 } else {
1723                     /// @solidity memory-safe-assembly
1724                     assembly {
1725                         revert(add(32, reason), mload(reason))
1726                     }
1727                 }
1728             }
1729         } else {
1730             return true;
1731         }
1732     }
1733 
1734     /**
1735      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1736      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1737      *
1738      * Calling conditions:
1739      *
1740      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1741      * - When `from` is zero, the tokens will be minted for `to`.
1742      * - When `to` is zero, ``from``'s tokens will be burned.
1743      * - `from` and `to` are never both zero.
1744      * - `batchSize` is non-zero.
1745      *
1746      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1747      */
1748     function _beforeTokenTransfer(
1749         address from,
1750         address to,
1751         uint256, /* firstTokenId */
1752         uint256 batchSize
1753     ) internal virtual {
1754         if (batchSize > 1) {
1755             if (from != address(0)) {
1756                 _balances[from] -= batchSize;
1757             }
1758             if (to != address(0)) {
1759                 _balances[to] += batchSize;
1760             }
1761         }
1762     }
1763 
1764     /**
1765      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1766      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1767      *
1768      * Calling conditions:
1769      *
1770      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1771      * - When `from` is zero, the tokens were minted for `to`.
1772      * - When `to` is zero, ``from``'s tokens were burned.
1773      * - `from` and `to` are never both zero.
1774      * - `batchSize` is non-zero.
1775      *
1776      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1777      */
1778     function _afterTokenTransfer(
1779         address from,
1780         address to,
1781         uint256 firstTokenId,
1782         uint256 batchSize
1783     ) internal virtual {}
1784 }
1785 
1786 // File: @openzeppelin/contracts/access/Ownable.sol
1787 
1788 
1789 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1790 
1791 pragma solidity ^0.8.0;
1792 
1793 
1794 /**
1795  * @dev Contract module which provides a basic access control mechanism, where
1796  * there is an account (an owner) that can be granted exclusive access to
1797  * specific functions.
1798  *
1799  * By default, the owner account will be the one that deploys the contract. This
1800  * can later be changed with {transferOwnership}.
1801  *
1802  * This module is used through inheritance. It will make available the modifier
1803  * `onlyOwner`, which can be applied to your functions to restrict their use to
1804  * the owner.
1805  */
1806 abstract contract Ownable is Context {
1807     address private _owner;
1808 
1809     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1810 
1811     /**
1812      * @dev Initializes the contract setting the deployer as the initial owner.
1813      */
1814     constructor() {
1815         _transferOwnership(_msgSender());
1816     }
1817 
1818     /**
1819      * @dev Throws if called by any account other than the owner.
1820      */
1821     modifier onlyOwner() {
1822         _checkOwner();
1823         _;
1824     }
1825 
1826     /**
1827      * @dev Returns the address of the current owner.
1828      */
1829     function owner() public view virtual returns (address) {
1830         return _owner;
1831     }
1832 
1833     /**
1834      * @dev Throws if the sender is not the owner.
1835      */
1836     function _checkOwner() internal view virtual {
1837         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1838     }
1839 
1840     /**
1841      * @dev Leaves the contract without owner. It will not be possible to call
1842      * `onlyOwner` functions anymore. Can only be called by the current owner.
1843      *
1844      * NOTE: Renouncing ownership will leave the contract without an owner,
1845      * thereby removing any functionality that is only available to the owner.
1846      */
1847     function renounceOwnership() public virtual onlyOwner {
1848         _transferOwnership(address(0));
1849     }
1850 
1851     /**
1852      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1853      * Can only be called by the current owner.
1854      */
1855     function transferOwnership(address newOwner) public virtual onlyOwner {
1856         require(newOwner != address(0), "Ownable: new owner is the zero address");
1857         _transferOwnership(newOwner);
1858     }
1859 
1860     /**
1861      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1862      * Internal function without access restriction.
1863      */
1864     function _transferOwnership(address newOwner) internal virtual {
1865         address oldOwner = _owner;
1866         _owner = newOwner;
1867         emit OwnershipTransferred(oldOwner, newOwner);
1868     }
1869 }
1870 
1871 // File: @openzeppelin/contracts/utils/Counters.sol
1872 
1873 
1874 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1875 
1876 pragma solidity ^0.8.0;
1877 
1878 /**
1879  * @title Counters
1880  * @author Matt Condon (@shrugs)
1881  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1882  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1883  *
1884  * Include with `using Counters for Counters.Counter;`
1885  */
1886 library Counters {
1887     struct Counter {
1888         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1889         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1890         // this feature: see https://github.com/ethereum/solidity/issues/4637
1891         uint256 _value; // default: 0
1892     }
1893 
1894     function current(Counter storage counter) internal view returns (uint256) {
1895         return counter._value;
1896     }
1897 
1898     function increment(Counter storage counter) internal {
1899         unchecked {
1900             counter._value += 1;
1901         }
1902     }
1903 
1904     function decrement(Counter storage counter) internal {
1905         uint256 value = counter._value;
1906         require(value > 0, "Counter: decrement overflow");
1907         unchecked {
1908             counter._value = value - 1;
1909         }
1910     }
1911 
1912     function reset(Counter storage counter) internal {
1913         counter._value = 0;
1914     }
1915 }
1916 
1917 // File: StackSpaceships.sol
1918 
1919 /*
1920  /   _____//  |______    ____ |  | __
1921  \_____  \\   __\__  \ _/ ___\|  |/ /
1922  /        \|  |  / __ \\  \___|    < 
1923 /_______  /|__| (____  /\___  >__|_ \
1924         \/           \/     \/     \/
1925   _________                                .__    .__              
1926  /   _____/__________    ____  ____   _____|  |__ |__|_____  ______
1927  \_____  \\____ \__  \ _/ ___\/ __ \ /  ___/  |  \|  \____ \/  ___/
1928  /        \  |_> > __ \\  \__\  ___/ \___ \|   Y  \  |  |_> >___ \ 
1929 /_______  /   __(____  /\___  >___  >____  >___|  /__|   __/____  >
1930         \/|__|       \/     \/    \/     \/     \/   |__|       \/ 
1931 */
1932 
1933 
1934 pragma solidity ^0.8.14;
1935 
1936 
1937 
1938 
1939 
1940 
1941 contract StackSpaceships is ERC721, Ownable {
1942     using Strings for uint;
1943     using Counters for Counters.Counter;
1944 
1945     enum SaleStatus { PAUSED, LIVE }
1946     enum SaleStage { WHITELIST, PUBLIC, PRIVATE, FREE_MINT }
1947 
1948     Counters.Counter private _tokenIds;
1949 
1950     uint256 public startingIndex;
1951     uint256 public startingIndexBlock;
1952 
1953     string public contractURI;
1954 
1955     uint public collectionSize = 4242;
1956     uint public reservedAmount = 100;
1957     
1958     uint public tokensPerPersonPrivateLimit = 5;
1959     uint public tokensPerPersonWhitelistLimit = 5;
1960     uint public tokensPerPersonPublicLimit = 5;
1961     uint public tokensPerPersonFreeMintLimit = 1;
1962 
1963     uint public whitelistMintPrice = 0.0777 ether;
1964     uint public privateMintPrice = 0.0777 ether;
1965     uint public publicMintPrice = 0.0999 ether;
1966 
1967     address public crossmintAddress = 0xdAb1a1854214684acE522439684a145E62505233;
1968 
1969     string public preRevealURL = "https://stackbrowser.com/api/nft/placeholder.json";
1970     string public baseURL;
1971 
1972     bytes32 public whitelistMerkleRoot;
1973     bytes32 public privateMerkleRoot;
1974     bytes32 public freeMintMerkleRoot;
1975 
1976     SaleStatus public privateSaleStatus = SaleStatus.PAUSED;
1977     SaleStatus public whitelistSaleStatus = SaleStatus.PAUSED;
1978     SaleStatus public publicSaleStatus = SaleStatus.PAUSED;
1979     SaleStatus public freeMintSaleStatus = SaleStatus.PAUSED;
1980 
1981     event Minted(address to, uint count, SaleStage stage);
1982 
1983     mapping(address => uint) private _privateMintedCount;
1984     mapping(address => uint) private _whitelistMintedCount;
1985     mapping(address => uint) private _publicMintedCount;
1986     mapping(address => uint) private _freeMintedCount;
1987 
1988     constructor() ERC721("StackSpaceships", "STK"){}
1989     
1990     /// @notice Update Contract-level metadata
1991     function setContractURI(string memory _contractURI) external onlyOwner {
1992         contractURI = string(abi.encodePacked(
1993             "data:application/json;base64,",
1994             Base64.encode(
1995                 bytes(
1996                     _contractURI
1997                 )
1998             )
1999         ));
2000     }
2001     
2002     /// @notice Update the whitelist merkle tree root
2003     function setWhitelistMerkleRoot(bytes32 root) external onlyOwner {
2004         whitelistMerkleRoot = root;
2005     }
2006     
2007     /// @notice Update the private merkle tree root
2008     function setPrivateMerkleRoot(bytes32 root) external onlyOwner {
2009         privateMerkleRoot = root;
2010     }
2011     
2012     /// @notice Update the free mint merkle tree root
2013     function setFreeMintMerkleRoot(bytes32 root) external onlyOwner {
2014         freeMintMerkleRoot = root;
2015     }
2016     
2017     /// @notice Update base url
2018     function setBaseUrl(string calldata url) external onlyOwner {
2019         require(startingIndex == 0, "Collection has been already revealed");
2020         baseURL = url;
2021     }
2022 
2023     /// @notice Set Pre Reveal URL
2024     function setPreRevealUrl(string calldata url) external onlyOwner {
2025         preRevealURL = url;
2026     }
2027 
2028     function totalSupply() external view returns (uint) {
2029         return _tokenIds.current();
2030     }
2031 
2032     /// @notice Update private sale stage
2033     function setPrivateSaleStatus(SaleStatus status) external onlyOwner {
2034         privateSaleStatus = status;
2035     }
2036     
2037     /// @notice Update whitelist sale stage
2038     function setWhitelistSaleStatus(SaleStatus status) external onlyOwner {
2039         whitelistSaleStatus = status;
2040     }
2041     
2042     /// @notice Update public sale stage
2043     function setPublicSaleStatus(SaleStatus status) external onlyOwner {
2044         publicSaleStatus = status;
2045     }
2046     
2047     /// @notice Update free mint sale stage
2048     function setFreeMintSaleStatus(SaleStatus status) external onlyOwner {
2049         freeMintSaleStatus = status;
2050     }
2051 
2052     /// @notice Update collection size
2053     function setCollectionSize(uint size) external onlyOwner {
2054         require(startingIndex == 0, "Collection has been already revealed");
2055         collectionSize = size;
2056     }
2057 
2058     /// @notice Update token limit per address
2059     function setTokensPerPersonPublicLimit(uint limit) external onlyOwner {
2060         tokensPerPersonPublicLimit = limit;
2061     }
2062 
2063     /// @notice Update token limit per whitelisted address
2064     function setTokensPerPersonWhitelistLimit(uint limit) external onlyOwner {
2065         tokensPerPersonWhitelistLimit = limit;
2066     }
2067 
2068     /// @notice Update token limit per private address
2069     function setTokensPerPersonPrivateLimit(uint limit) external onlyOwner {
2070         tokensPerPersonPrivateLimit = limit;
2071     }
2072 
2073     /// @notice Update token limit per free mint address
2074     function setTokensPerPersonFreeMintLimit(uint limit) external onlyOwner {
2075         tokensPerPersonFreeMintLimit = limit;
2076     }
2077 
2078     /// @notice Update reserved amount
2079     function setReservedAmount(uint amount) external onlyOwner {
2080         reservedAmount = amount;
2081     }
2082 
2083     /// @notice Update whitelist mint price
2084     function setWhitelistMintPrice(uint price) external onlyOwner {
2085         whitelistMintPrice = price;
2086     }
2087     
2088     /// @notice Update private mint price
2089     function setPrivateMintPrice(uint price) external onlyOwner {
2090         privateMintPrice = price;
2091     }
2092 
2093     /// @notice Update public mint price
2094     function setPublicMintPrice(uint price) external onlyOwner {
2095         publicMintPrice = price;
2096     }
2097 
2098     /// @notice Update crossmint address
2099     function setCrossmintAddress(address addr) external onlyOwner {
2100         crossmintAddress = addr;
2101     }
2102 
2103     /// @notice Reveal metadata for all the tokens
2104     function reveal() external onlyOwner {
2105         require(startingIndex == 0, "Collection has been already revealed");
2106         require(startingIndexBlock != 0, "Starting index block must be set");
2107         
2108         startingIndex = uint(blockhash(startingIndexBlock)) % collectionSize;
2109         
2110         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
2111         if (block.number - startingIndexBlock > 255) {
2112             startingIndex = uint(blockhash(block.number - 1)) % collectionSize;
2113         }
2114 
2115         // Prevent default sequence
2116         if (startingIndex == 0) {
2117             startingIndex = startingIndex + 1;
2118         }
2119     }
2120 
2121     function emergencySetStartingIndexBlock() public onlyOwner {
2122         require(startingIndex == 0, "Collection has been already revealed");
2123         startingIndexBlock = block.number;
2124     }
2125 
2126     /// @notice Withdraw contract balance
2127     function withdraw() external onlyOwner {
2128         uint balance = address(this).balance;
2129         require(balance > 0, "No balance");
2130         payable(owner()).transfer(balance);
2131     }
2132 
2133     /// @notice Allows owner to mint tokens to a specified address
2134     function airdrop(address to, uint count) external onlyOwner {
2135         require(_tokenIds.current() + count <= collectionSize, "Request exceeds collection size");
2136         _mintTokens(to, count);
2137     }
2138 
2139     /// @notice Get token URI. In case of delayed reveal we give user the json of the placeholer metadata.
2140     /// @param tokenId token ID
2141     function tokenURI(uint tokenId) public view override returns (string memory) {
2142         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2143 
2144         string memory sequenceId;
2145 
2146         if (startingIndex > 0) {
2147             sequenceId = ( 1 + (tokenId + startingIndex) % collectionSize ).toString();
2148             return string(abi.encodePacked(baseURL, sequenceId, '.json'));
2149         } else {
2150             return preRevealURL;
2151         }
2152     }
2153     
2154     function publicMint(uint count) external payable {
2155         _publicMint(count, msg.sender);
2156     }
2157 
2158     function crossmint(address _to, uint count) external payable {
2159         require(msg.sender == crossmintAddress, "This function is for Crossmint only.");
2160         _publicMint(count, _to);
2161     }
2162 
2163     function _publicMint(uint count, address _to) internal {
2164         require(startingIndex == 0, "Collection has been already revealed");
2165         require(publicSaleStatus == SaleStatus.LIVE, "Public Sales are off");
2166         require(_tokenIds.current() + count <= collectionSize - reservedAmount, "Number of requested tokens will exceed collection size");
2167         require(msg.value >= count * publicMintPrice, "Ether value sent is not sufficient");
2168         
2169         require(_publicMintedCount[_to] + count <= tokensPerPersonPublicLimit, "Number of requested tokens exceeds allowance");
2170 
2171         _publicMintedCount[_to] += count;
2172 
2173         _mintTokens(_to, count);
2174         
2175         emit Minted(_to, count, SaleStage.PUBLIC);
2176     }
2177 
2178     function whitelistMint(bytes32[] calldata merkleProof, uint count) external payable {
2179         require(startingIndex == 0, "Collection has been already revealed");
2180         require(whitelistSaleStatus == SaleStatus.LIVE, "Whitelist sales are closed");
2181         require(_tokenIds.current() + count <= collectionSize - reservedAmount, "Number of requested tokens will exceed collection size");
2182         
2183         require(msg.value >= count * whitelistMintPrice, "Ether value sent is not sufficient");
2184         require(_whitelistMintedCount[msg.sender] + count <= tokensPerPersonWhitelistLimit, "Number of requested tokens exceeds allowance");
2185         
2186         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2187         require(MerkleProof.verify(merkleProof, whitelistMerkleRoot, leaf), "You are not whitelisted");
2188         
2189         _whitelistMintedCount[msg.sender] += count;
2190 
2191         _mintTokens(msg.sender, count);
2192         
2193         emit Minted(msg.sender, count, SaleStage.WHITELIST);
2194     }
2195 
2196     function privateMint(bytes32[] calldata merkleProof, uint count) external payable {
2197         require(startingIndex == 0, "Collection has been already revealed");
2198         require(privateSaleStatus == SaleStatus.LIVE, "Private sales are closed");
2199         require(_tokenIds.current() + count <= collectionSize, "Number of requested tokens will exceed collection size");
2200         
2201         require(msg.value >= count * privateMintPrice, "Ether value sent is not sufficient");
2202         require(_privateMintedCount[msg.sender] + count <= tokensPerPersonPrivateLimit, "Number of requested tokens exceeds allowance");
2203         
2204         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2205         require(MerkleProof.verify(merkleProof, privateMerkleRoot, leaf), "You are not whitelisted");
2206         
2207         _privateMintedCount[msg.sender] += count;
2208 
2209         _mintTokens(msg.sender, count);
2210         
2211         emit Minted(msg.sender, count, SaleStage.PRIVATE);
2212     }
2213 
2214     function freeMint(bytes32[] calldata merkleProof, uint count) public {
2215         require(startingIndex == 0, "Collection has been already revealed");
2216         require(freeMintSaleStatus == SaleStatus.LIVE, "Free mint sales are closed");
2217         require(_tokenIds.current() + count <= collectionSize - reservedAmount, "Number of requested tokens will exceed collection size");
2218         require(_freeMintedCount[msg.sender] + count <= tokensPerPersonFreeMintLimit, "Number of requested tokens exceeds allowance");
2219         
2220         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2221         require(MerkleProof.verify(merkleProof, freeMintMerkleRoot, leaf), "You are not allowed to mint for free");
2222         
2223         _freeMintedCount[msg.sender] += count;
2224 
2225         _mintTokens(msg.sender, count);
2226         
2227         emit Minted(msg.sender, count, SaleStage.FREE_MINT);
2228     }
2229     
2230     /// @dev Perform actual minting of the tokens
2231     function _mintTokens(address to, uint count) internal {
2232         for(uint index = 0; index < count; index++) {
2233 
2234             _tokenIds.increment();
2235             uint newItemId = _tokenIds.current();
2236 
2237             _safeMint(to, newItemId);
2238         }
2239 
2240         // if Minting is done, set startingIndexBlock
2241         if (startingIndexBlock == 0 && (_tokenIds.current() == collectionSize)) {
2242             startingIndexBlock = block.number;
2243         }
2244     }
2245 }