1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Tree proofs.
12  *
13  * The tree and the proofs can be generated using our
14  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
15  * You will find a quickstart guide in the readme.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  * OpenZeppelin's JavaScript library generates merkle trees that are safe
22  * against this attack out of the box.
23  */
24 library MerkleProof {
25     /**
26      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
27      * defined by `root`. For this, a `proof` must be provided, containing
28      * sibling hashes on the branch from the leaf to the root of the tree. Each
29      * pair of leaves and each pair of pre-images are assumed to be sorted.
30      */
31     function verify(
32         bytes32[] memory proof,
33         bytes32 root,
34         bytes32 leaf
35     ) internal pure returns (bool) {
36         return processProof(proof, leaf) == root;
37     }
38 
39     /**
40      * @dev Calldata version of {verify}
41      *
42      * _Available since v4.7._
43      */
44     function verifyCalldata(
45         bytes32[] calldata proof,
46         bytes32 root,
47         bytes32 leaf
48     ) internal pure returns (bool) {
49         return processProofCalldata(proof, leaf) == root;
50     }
51 
52     /**
53      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
54      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
55      * hash matches the root of the tree. When processing the proof, the pairs
56      * of leafs & pre-images are assumed to be sorted.
57      *
58      * _Available since v4.4._
59      */
60     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
61         bytes32 computedHash = leaf;
62         for (uint256 i = 0; i < proof.length; i++) {
63             computedHash = _hashPair(computedHash, proof[i]);
64         }
65         return computedHash;
66     }
67 
68     /**
69      * @dev Calldata version of {processProof}
70      *
71      * _Available since v4.7._
72      */
73     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
74         bytes32 computedHash = leaf;
75         for (uint256 i = 0; i < proof.length; i++) {
76             computedHash = _hashPair(computedHash, proof[i]);
77         }
78         return computedHash;
79     }
80 
81     /**
82      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
83      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
84      *
85      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
86      *
87      * _Available since v4.7._
88      */
89     function multiProofVerify(
90         bytes32[] memory proof,
91         bool[] memory proofFlags,
92         bytes32 root,
93         bytes32[] memory leaves
94     ) internal pure returns (bool) {
95         return processMultiProof(proof, proofFlags, leaves) == root;
96     }
97 
98     /**
99      * @dev Calldata version of {multiProofVerify}
100      *
101      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
102      *
103      * _Available since v4.7._
104      */
105     function multiProofVerifyCalldata(
106         bytes32[] calldata proof,
107         bool[] calldata proofFlags,
108         bytes32 root,
109         bytes32[] memory leaves
110     ) internal pure returns (bool) {
111         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
112     }
113 
114     /**
115      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
116      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
117      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
118      * respectively.
119      *
120      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
121      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
122      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
123      *
124      * _Available since v4.7._
125      */
126     function processMultiProof(
127         bytes32[] memory proof,
128         bool[] memory proofFlags,
129         bytes32[] memory leaves
130     ) internal pure returns (bytes32 merkleRoot) {
131         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
132         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
133         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
134         // the merkle tree.
135         uint256 leavesLen = leaves.length;
136         uint256 totalHashes = proofFlags.length;
137 
138         // Check proof validity.
139         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
140 
141         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
142         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
143         bytes32[] memory hashes = new bytes32[](totalHashes);
144         uint256 leafPos = 0;
145         uint256 hashPos = 0;
146         uint256 proofPos = 0;
147         // At each step, we compute the next hash using two values:
148         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
149         //   get the next hash.
150         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
151         //   `proof` array.
152         for (uint256 i = 0; i < totalHashes; i++) {
153             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
154             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
155             hashes[i] = _hashPair(a, b);
156         }
157 
158         if (totalHashes > 0) {
159             return hashes[totalHashes - 1];
160         } else if (leavesLen > 0) {
161             return leaves[0];
162         } else {
163             return proof[0];
164         }
165     }
166 
167     /**
168      * @dev Calldata version of {processMultiProof}.
169      *
170      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
171      *
172      * _Available since v4.7._
173      */
174     function processMultiProofCalldata(
175         bytes32[] calldata proof,
176         bool[] calldata proofFlags,
177         bytes32[] memory leaves
178     ) internal pure returns (bytes32 merkleRoot) {
179         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
180         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
181         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
182         // the merkle tree.
183         uint256 leavesLen = leaves.length;
184         uint256 totalHashes = proofFlags.length;
185 
186         // Check proof validity.
187         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
188 
189         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
190         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
191         bytes32[] memory hashes = new bytes32[](totalHashes);
192         uint256 leafPos = 0;
193         uint256 hashPos = 0;
194         uint256 proofPos = 0;
195         // At each step, we compute the next hash using two values:
196         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
197         //   get the next hash.
198         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
199         //   `proof` array.
200         for (uint256 i = 0; i < totalHashes; i++) {
201             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
202             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
203             hashes[i] = _hashPair(a, b);
204         }
205 
206         if (totalHashes > 0) {
207             return hashes[totalHashes - 1];
208         } else if (leavesLen > 0) {
209             return leaves[0];
210         } else {
211             return proof[0];
212         }
213     }
214 
215     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
216         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
217     }
218 
219     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
220         /// @solidity memory-safe-assembly
221         assembly {
222             mstore(0x00, a)
223             mstore(0x20, b)
224             value := keccak256(0x00, 0x40)
225         }
226     }
227 }
228 
229 // File: @openzeppelin/contracts/utils/math/Math.sol
230 
231 
232 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 /**
237  * @dev Standard math utilities missing in the Solidity language.
238  */
239 library Math {
240     enum Rounding {
241         Down, // Toward negative infinity
242         Up, // Toward infinity
243         Zero // Toward zero
244     }
245 
246     /**
247      * @dev Returns the largest of two numbers.
248      */
249     function max(uint256 a, uint256 b) internal pure returns (uint256) {
250         return a > b ? a : b;
251     }
252 
253     /**
254      * @dev Returns the smallest of two numbers.
255      */
256     function min(uint256 a, uint256 b) internal pure returns (uint256) {
257         return a < b ? a : b;
258     }
259 
260     /**
261      * @dev Returns the average of two numbers. The result is rounded towards
262      * zero.
263      */
264     function average(uint256 a, uint256 b) internal pure returns (uint256) {
265         // (a + b) / 2 can overflow.
266         return (a & b) + (a ^ b) / 2;
267     }
268 
269     /**
270      * @dev Returns the ceiling of the division of two numbers.
271      *
272      * This differs from standard division with `/` in that it rounds up instead
273      * of rounding down.
274      */
275     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
276         // (a + b - 1) / b can overflow on addition, so we distribute.
277         return a == 0 ? 0 : (a - 1) / b + 1;
278     }
279 
280     /**
281      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
282      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
283      * with further edits by Uniswap Labs also under MIT license.
284      */
285     function mulDiv(
286         uint256 x,
287         uint256 y,
288         uint256 denominator
289     ) internal pure returns (uint256 result) {
290         unchecked {
291             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
292             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
293             // variables such that product = prod1 * 2^256 + prod0.
294             uint256 prod0; // Least significant 256 bits of the product
295             uint256 prod1; // Most significant 256 bits of the product
296             assembly {
297                 let mm := mulmod(x, y, not(0))
298                 prod0 := mul(x, y)
299                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
300             }
301 
302             // Handle non-overflow cases, 256 by 256 division.
303             if (prod1 == 0) {
304                 return prod0 / denominator;
305             }
306 
307             // Make sure the result is less than 2^256. Also prevents denominator == 0.
308             require(denominator > prod1);
309 
310             ///////////////////////////////////////////////
311             // 512 by 256 division.
312             ///////////////////////////////////////////////
313 
314             // Make division exact by subtracting the remainder from [prod1 prod0].
315             uint256 remainder;
316             assembly {
317                 // Compute remainder using mulmod.
318                 remainder := mulmod(x, y, denominator)
319 
320                 // Subtract 256 bit number from 512 bit number.
321                 prod1 := sub(prod1, gt(remainder, prod0))
322                 prod0 := sub(prod0, remainder)
323             }
324 
325             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
326             // See https://cs.stackexchange.com/q/138556/92363.
327 
328             // Does not overflow because the denominator cannot be zero at this stage in the function.
329             uint256 twos = denominator & (~denominator + 1);
330             assembly {
331                 // Divide denominator by twos.
332                 denominator := div(denominator, twos)
333 
334                 // Divide [prod1 prod0] by twos.
335                 prod0 := div(prod0, twos)
336 
337                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
338                 twos := add(div(sub(0, twos), twos), 1)
339             }
340 
341             // Shift in bits from prod1 into prod0.
342             prod0 |= prod1 * twos;
343 
344             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
345             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
346             // four bits. That is, denominator * inv = 1 mod 2^4.
347             uint256 inverse = (3 * denominator) ^ 2;
348 
349             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
350             // in modular arithmetic, doubling the correct bits in each step.
351             inverse *= 2 - denominator * inverse; // inverse mod 2^8
352             inverse *= 2 - denominator * inverse; // inverse mod 2^16
353             inverse *= 2 - denominator * inverse; // inverse mod 2^32
354             inverse *= 2 - denominator * inverse; // inverse mod 2^64
355             inverse *= 2 - denominator * inverse; // inverse mod 2^128
356             inverse *= 2 - denominator * inverse; // inverse mod 2^256
357 
358             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
359             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
360             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
361             // is no longer required.
362             result = prod0 * inverse;
363             return result;
364         }
365     }
366 
367     /**
368      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
369      */
370     function mulDiv(
371         uint256 x,
372         uint256 y,
373         uint256 denominator,
374         Rounding rounding
375     ) internal pure returns (uint256) {
376         uint256 result = mulDiv(x, y, denominator);
377         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
378             result += 1;
379         }
380         return result;
381     }
382 
383     /**
384      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
385      *
386      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
387      */
388     function sqrt(uint256 a) internal pure returns (uint256) {
389         if (a == 0) {
390             return 0;
391         }
392 
393         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
394         //
395         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
396         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
397         //
398         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
399         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
400         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
401         //
402         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
403         uint256 result = 1 << (log2(a) >> 1);
404 
405         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
406         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
407         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
408         // into the expected uint128 result.
409         unchecked {
410             result = (result + a / result) >> 1;
411             result = (result + a / result) >> 1;
412             result = (result + a / result) >> 1;
413             result = (result + a / result) >> 1;
414             result = (result + a / result) >> 1;
415             result = (result + a / result) >> 1;
416             result = (result + a / result) >> 1;
417             return min(result, a / result);
418         }
419     }
420 
421     /**
422      * @notice Calculates sqrt(a), following the selected rounding direction.
423      */
424     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
425         unchecked {
426             uint256 result = sqrt(a);
427             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
428         }
429     }
430 
431     /**
432      * @dev Return the log in base 2, rounded down, of a positive value.
433      * Returns 0 if given 0.
434      */
435     function log2(uint256 value) internal pure returns (uint256) {
436         uint256 result = 0;
437         unchecked {
438             if (value >> 128 > 0) {
439                 value >>= 128;
440                 result += 128;
441             }
442             if (value >> 64 > 0) {
443                 value >>= 64;
444                 result += 64;
445             }
446             if (value >> 32 > 0) {
447                 value >>= 32;
448                 result += 32;
449             }
450             if (value >> 16 > 0) {
451                 value >>= 16;
452                 result += 16;
453             }
454             if (value >> 8 > 0) {
455                 value >>= 8;
456                 result += 8;
457             }
458             if (value >> 4 > 0) {
459                 value >>= 4;
460                 result += 4;
461             }
462             if (value >> 2 > 0) {
463                 value >>= 2;
464                 result += 2;
465             }
466             if (value >> 1 > 0) {
467                 result += 1;
468             }
469         }
470         return result;
471     }
472 
473     /**
474      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
475      * Returns 0 if given 0.
476      */
477     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
478         unchecked {
479             uint256 result = log2(value);
480             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
481         }
482     }
483 
484     /**
485      * @dev Return the log in base 10, rounded down, of a positive value.
486      * Returns 0 if given 0.
487      */
488     function log10(uint256 value) internal pure returns (uint256) {
489         uint256 result = 0;
490         unchecked {
491             if (value >= 10**64) {
492                 value /= 10**64;
493                 result += 64;
494             }
495             if (value >= 10**32) {
496                 value /= 10**32;
497                 result += 32;
498             }
499             if (value >= 10**16) {
500                 value /= 10**16;
501                 result += 16;
502             }
503             if (value >= 10**8) {
504                 value /= 10**8;
505                 result += 8;
506             }
507             if (value >= 10**4) {
508                 value /= 10**4;
509                 result += 4;
510             }
511             if (value >= 10**2) {
512                 value /= 10**2;
513                 result += 2;
514             }
515             if (value >= 10**1) {
516                 result += 1;
517             }
518         }
519         return result;
520     }
521 
522     /**
523      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
524      * Returns 0 if given 0.
525      */
526     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
527         unchecked {
528             uint256 result = log10(value);
529             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
530         }
531     }
532 
533     /**
534      * @dev Return the log in base 256, rounded down, of a positive value.
535      * Returns 0 if given 0.
536      *
537      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
538      */
539     function log256(uint256 value) internal pure returns (uint256) {
540         uint256 result = 0;
541         unchecked {
542             if (value >> 128 > 0) {
543                 value >>= 128;
544                 result += 16;
545             }
546             if (value >> 64 > 0) {
547                 value >>= 64;
548                 result += 8;
549             }
550             if (value >> 32 > 0) {
551                 value >>= 32;
552                 result += 4;
553             }
554             if (value >> 16 > 0) {
555                 value >>= 16;
556                 result += 2;
557             }
558             if (value >> 8 > 0) {
559                 result += 1;
560             }
561         }
562         return result;
563     }
564 
565     /**
566      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
567      * Returns 0 if given 0.
568      */
569     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
570         unchecked {
571             uint256 result = log256(value);
572             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
573         }
574     }
575 }
576 
577 // File: @openzeppelin/contracts/utils/Strings.sol
578 
579 
580 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 
585 /**
586  * @dev String operations.
587  */
588 library Strings {
589     bytes16 private constant _SYMBOLS = "0123456789abcdef";
590     uint8 private constant _ADDRESS_LENGTH = 20;
591 
592     /**
593      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
594      */
595     function toString(uint256 value) internal pure returns (string memory) {
596         unchecked {
597             uint256 length = Math.log10(value) + 1;
598             string memory buffer = new string(length);
599             uint256 ptr;
600             /// @solidity memory-safe-assembly
601             assembly {
602                 ptr := add(buffer, add(32, length))
603             }
604             while (true) {
605                 ptr--;
606                 /// @solidity memory-safe-assembly
607                 assembly {
608                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
609                 }
610                 value /= 10;
611                 if (value == 0) break;
612             }
613             return buffer;
614         }
615     }
616 
617     /**
618      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
619      */
620     function toHexString(uint256 value) internal pure returns (string memory) {
621         unchecked {
622             return toHexString(value, Math.log256(value) + 1);
623         }
624     }
625 
626     /**
627      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
628      */
629     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
630         bytes memory buffer = new bytes(2 * length + 2);
631         buffer[0] = "0";
632         buffer[1] = "x";
633         for (uint256 i = 2 * length + 1; i > 1; --i) {
634             buffer[i] = _SYMBOLS[value & 0xf];
635             value >>= 4;
636         }
637         require(value == 0, "Strings: hex length insufficient");
638         return string(buffer);
639     }
640 
641     /**
642      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
643      */
644     function toHexString(address addr) internal pure returns (string memory) {
645         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
646     }
647 }
648 
649 // File: @openzeppelin/contracts/utils/Context.sol
650 
651 
652 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev Provides information about the current execution context, including the
658  * sender of the transaction and its data. While these are generally available
659  * via msg.sender and msg.data, they should not be accessed in such a direct
660  * manner, since when dealing with meta-transactions the account sending and
661  * paying for execution may not be the actual sender (as far as an application
662  * is concerned).
663  *
664  * This contract is only required for intermediate, library-like contracts.
665  */
666 abstract contract Context {
667     function _msgSender() internal view virtual returns (address) {
668         return msg.sender;
669     }
670 
671     function _msgData() internal view virtual returns (bytes calldata) {
672         return msg.data;
673     }
674 }
675 
676 // File: @openzeppelin/contracts/access/Ownable.sol
677 
678 
679 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 
684 /**
685  * @dev Contract module which provides a basic access control mechanism, where
686  * there is an account (an owner) that can be granted exclusive access to
687  * specific functions.
688  *
689  * By default, the owner account will be the one that deploys the contract. This
690  * can later be changed with {transferOwnership}.
691  *
692  * This module is used through inheritance. It will make available the modifier
693  * `onlyOwner`, which can be applied to your functions to restrict their use to
694  * the owner.
695  */
696 abstract contract Ownable is Context {
697     address private _owner;
698 
699     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
700 
701     /**
702      * @dev Initializes the contract setting the deployer as the initial owner.
703      */
704     constructor() {
705         _transferOwnership(_msgSender());
706     }
707 
708     /**
709      * @dev Throws if called by any account other than the owner.
710      */
711     modifier onlyOwner() {
712         _checkOwner();
713         _;
714     }
715 
716     /**
717      * @dev Returns the address of the current owner.
718      */
719     function owner() public view virtual returns (address) {
720         return _owner;
721     }
722 
723     /**
724      * @dev Throws if the sender is not the owner.
725      */
726     function _checkOwner() internal view virtual {
727         require(owner() == _msgSender(), "Ownable: caller is not the owner");
728     }
729 
730     /**
731      * @dev Leaves the contract without owner. It will not be possible to call
732      * `onlyOwner` functions anymore. Can only be called by the current owner.
733      *
734      * NOTE: Renouncing ownership will leave the contract without an owner,
735      * thereby removing any functionality that is only available to the owner.
736      */
737     function renounceOwnership() public virtual onlyOwner {
738         _transferOwnership(address(0));
739     }
740 
741     /**
742      * @dev Transfers ownership of the contract to a new account (`newOwner`).
743      * Can only be called by the current owner.
744      */
745     function transferOwnership(address newOwner) public virtual onlyOwner {
746         require(newOwner != address(0), "Ownable: new owner is the zero address");
747         _transferOwnership(newOwner);
748     }
749 
750     /**
751      * @dev Transfers ownership of the contract to a new account (`newOwner`).
752      * Internal function without access restriction.
753      */
754     function _transferOwnership(address newOwner) internal virtual {
755         address oldOwner = _owner;
756         _owner = newOwner;
757         emit OwnershipTransferred(oldOwner, newOwner);
758     }
759 }
760 
761 // File: @openzeppelin/contracts/utils/Address.sol
762 
763 
764 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
765 
766 pragma solidity ^0.8.1;
767 
768 /**
769  * @dev Collection of functions related to the address type
770  */
771 library Address {
772     /**
773      * @dev Returns true if `account` is a contract.
774      *
775      * [IMPORTANT]
776      * ====
777      * It is unsafe to assume that an address for which this function returns
778      * false is an externally-owned account (EOA) and not a contract.
779      *
780      * Among others, `isContract` will return false for the following
781      * types of addresses:
782      *
783      *  - an externally-owned account
784      *  - a contract in construction
785      *  - an address where a contract will be created
786      *  - an address where a contract lived, but was destroyed
787      * ====
788      *
789      * [IMPORTANT]
790      * ====
791      * You shouldn't rely on `isContract` to protect against flash loan attacks!
792      *
793      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
794      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
795      * constructor.
796      * ====
797      */
798     function isContract(address account) internal view returns (bool) {
799         // This method relies on extcodesize/address.code.length, which returns 0
800         // for contracts in construction, since the code is only stored at the end
801         // of the constructor execution.
802 
803         return account.code.length > 0;
804     }
805 
806     /**
807      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
808      * `recipient`, forwarding all available gas and reverting on errors.
809      *
810      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
811      * of certain opcodes, possibly making contracts go over the 2300 gas limit
812      * imposed by `transfer`, making them unable to receive funds via
813      * `transfer`. {sendValue} removes this limitation.
814      *
815      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
816      *
817      * IMPORTANT: because control is transferred to `recipient`, care must be
818      * taken to not create reentrancy vulnerabilities. Consider using
819      * {ReentrancyGuard} or the
820      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
821      */
822     function sendValue(address payable recipient, uint256 amount) internal {
823         require(address(this).balance >= amount, "Address: insufficient balance");
824 
825         (bool success, ) = recipient.call{value: amount}("");
826         require(success, "Address: unable to send value, recipient may have reverted");
827     }
828 
829     /**
830      * @dev Performs a Solidity function call using a low level `call`. A
831      * plain `call` is an unsafe replacement for a function call: use this
832      * function instead.
833      *
834      * If `target` reverts with a revert reason, it is bubbled up by this
835      * function (like regular Solidity function calls).
836      *
837      * Returns the raw returned data. To convert to the expected return value,
838      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
839      *
840      * Requirements:
841      *
842      * - `target` must be a contract.
843      * - calling `target` with `data` must not revert.
844      *
845      * _Available since v3.1._
846      */
847     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
848         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
849     }
850 
851     /**
852      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
853      * `errorMessage` as a fallback revert reason when `target` reverts.
854      *
855      * _Available since v3.1._
856      */
857     function functionCall(
858         address target,
859         bytes memory data,
860         string memory errorMessage
861     ) internal returns (bytes memory) {
862         return functionCallWithValue(target, data, 0, errorMessage);
863     }
864 
865     /**
866      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
867      * but also transferring `value` wei to `target`.
868      *
869      * Requirements:
870      *
871      * - the calling contract must have an ETH balance of at least `value`.
872      * - the called Solidity function must be `payable`.
873      *
874      * _Available since v3.1._
875      */
876     function functionCallWithValue(
877         address target,
878         bytes memory data,
879         uint256 value
880     ) internal returns (bytes memory) {
881         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
882     }
883 
884     /**
885      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
886      * with `errorMessage` as a fallback revert reason when `target` reverts.
887      *
888      * _Available since v3.1._
889      */
890     function functionCallWithValue(
891         address target,
892         bytes memory data,
893         uint256 value,
894         string memory errorMessage
895     ) internal returns (bytes memory) {
896         require(address(this).balance >= value, "Address: insufficient balance for call");
897         (bool success, bytes memory returndata) = target.call{value: value}(data);
898         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
899     }
900 
901     /**
902      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
903      * but performing a static call.
904      *
905      * _Available since v3.3._
906      */
907     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
908         return functionStaticCall(target, data, "Address: low-level static call failed");
909     }
910 
911     /**
912      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
913      * but performing a static call.
914      *
915      * _Available since v3.3._
916      */
917     function functionStaticCall(
918         address target,
919         bytes memory data,
920         string memory errorMessage
921     ) internal view returns (bytes memory) {
922         (bool success, bytes memory returndata) = target.staticcall(data);
923         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
924     }
925 
926     /**
927      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
928      * but performing a delegate call.
929      *
930      * _Available since v3.4._
931      */
932     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
933         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
934     }
935 
936     /**
937      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
938      * but performing a delegate call.
939      *
940      * _Available since v3.4._
941      */
942     function functionDelegateCall(
943         address target,
944         bytes memory data,
945         string memory errorMessage
946     ) internal returns (bytes memory) {
947         (bool success, bytes memory returndata) = target.delegatecall(data);
948         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
949     }
950 
951     /**
952      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
953      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
954      *
955      * _Available since v4.8._
956      */
957     function verifyCallResultFromTarget(
958         address target,
959         bool success,
960         bytes memory returndata,
961         string memory errorMessage
962     ) internal view returns (bytes memory) {
963         if (success) {
964             if (returndata.length == 0) {
965                 // only check isContract if the call was successful and the return data is empty
966                 // otherwise we already know that it was a contract
967                 require(isContract(target), "Address: call to non-contract");
968             }
969             return returndata;
970         } else {
971             _revert(returndata, errorMessage);
972         }
973     }
974 
975     /**
976      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
977      * revert reason or using the provided one.
978      *
979      * _Available since v4.3._
980      */
981     function verifyCallResult(
982         bool success,
983         bytes memory returndata,
984         string memory errorMessage
985     ) internal pure returns (bytes memory) {
986         if (success) {
987             return returndata;
988         } else {
989             _revert(returndata, errorMessage);
990         }
991     }
992 
993     function _revert(bytes memory returndata, string memory errorMessage) private pure {
994         // Look for revert reason and bubble it up if present
995         if (returndata.length > 0) {
996             // The easiest way to bubble the revert reason is using memory via assembly
997             /// @solidity memory-safe-assembly
998             assembly {
999                 let returndata_size := mload(returndata)
1000                 revert(add(32, returndata), returndata_size)
1001             }
1002         } else {
1003             revert(errorMessage);
1004         }
1005     }
1006 }
1007 
1008 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1009 
1010 
1011 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1012 
1013 pragma solidity ^0.8.0;
1014 
1015 /**
1016  * @title ERC721 token receiver interface
1017  * @dev Interface for any contract that wants to support safeTransfers
1018  * from ERC721 asset contracts.
1019  */
1020 interface IERC721Receiver {
1021     /**
1022      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1023      * by `operator` from `from`, this function is called.
1024      *
1025      * It must return its Solidity selector to confirm the token transfer.
1026      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1027      *
1028      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1029      */
1030     function onERC721Received(
1031         address operator,
1032         address from,
1033         uint256 tokenId,
1034         bytes calldata data
1035     ) external returns (bytes4);
1036 }
1037 
1038 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1039 
1040 
1041 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1042 
1043 pragma solidity ^0.8.0;
1044 
1045 /**
1046  * @dev Interface of the ERC165 standard, as defined in the
1047  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1048  *
1049  * Implementers can declare support of contract interfaces, which can then be
1050  * queried by others ({ERC165Checker}).
1051  *
1052  * For an implementation, see {ERC165}.
1053  */
1054 interface IERC165 {
1055     /**
1056      * @dev Returns true if this contract implements the interface defined by
1057      * `interfaceId`. See the corresponding
1058      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1059      * to learn more about how these ids are created.
1060      *
1061      * This function call must use less than 30 000 gas.
1062      */
1063     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1064 }
1065 
1066 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1067 
1068 
1069 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1070 
1071 pragma solidity ^0.8.0;
1072 
1073 
1074 /**
1075  * @dev Implementation of the {IERC165} interface.
1076  *
1077  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1078  * for the additional interface id that will be supported. For example:
1079  *
1080  * ```solidity
1081  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1082  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1083  * }
1084  * ```
1085  *
1086  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1087  */
1088 abstract contract ERC165 is IERC165 {
1089     /**
1090      * @dev See {IERC165-supportsInterface}.
1091      */
1092     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1093         return interfaceId == type(IERC165).interfaceId;
1094     }
1095 }
1096 
1097 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1098 
1099 
1100 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1101 
1102 pragma solidity ^0.8.0;
1103 
1104 
1105 /**
1106  * @dev Required interface of an ERC721 compliant contract.
1107  */
1108 interface IERC721 is IERC165 {
1109     /**
1110      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1111      */
1112     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1113 
1114     /**
1115      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1116      */
1117     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1118 
1119     /**
1120      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1121      */
1122     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1123 
1124     /**
1125      * @dev Returns the number of tokens in ``owner``'s account.
1126      */
1127     function balanceOf(address owner) external view returns (uint256 balance);
1128 
1129     /**
1130      * @dev Returns the owner of the `tokenId` token.
1131      *
1132      * Requirements:
1133      *
1134      * - `tokenId` must exist.
1135      */
1136     function ownerOf(uint256 tokenId) external view returns (address owner);
1137 
1138     /**
1139      * @dev Safely transfers `tokenId` token from `from` to `to`.
1140      *
1141      * Requirements:
1142      *
1143      * - `from` cannot be the zero address.
1144      * - `to` cannot be the zero address.
1145      * - `tokenId` token must exist and be owned by `from`.
1146      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1147      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function safeTransferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId,
1155         bytes calldata data
1156     ) external;
1157 
1158     /**
1159      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1160      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1161      *
1162      * Requirements:
1163      *
1164      * - `from` cannot be the zero address.
1165      * - `to` cannot be the zero address.
1166      * - `tokenId` token must exist and be owned by `from`.
1167      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function safeTransferFrom(
1173         address from,
1174         address to,
1175         uint256 tokenId
1176     ) external;
1177 
1178     /**
1179      * @dev Transfers `tokenId` token from `from` to `to`.
1180      *
1181      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1182      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1183      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1184      *
1185      * Requirements:
1186      *
1187      * - `from` cannot be the zero address.
1188      * - `to` cannot be the zero address.
1189      * - `tokenId` token must be owned by `from`.
1190      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function transferFrom(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) external;
1199 
1200     /**
1201      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1202      * The approval is cleared when the token is transferred.
1203      *
1204      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1205      *
1206      * Requirements:
1207      *
1208      * - The caller must own the token or be an approved operator.
1209      * - `tokenId` must exist.
1210      *
1211      * Emits an {Approval} event.
1212      */
1213     function approve(address to, uint256 tokenId) external;
1214 
1215     /**
1216      * @dev Approve or remove `operator` as an operator for the caller.
1217      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1218      *
1219      * Requirements:
1220      *
1221      * - The `operator` cannot be the caller.
1222      *
1223      * Emits an {ApprovalForAll} event.
1224      */
1225     function setApprovalForAll(address operator, bool _approved) external;
1226 
1227     /**
1228      * @dev Returns the account approved for `tokenId` token.
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must exist.
1233      */
1234     function getApproved(uint256 tokenId) external view returns (address operator);
1235 
1236     /**
1237      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1238      *
1239      * See {setApprovalForAll}
1240      */
1241     function isApprovedForAll(address owner, address operator) external view returns (bool);
1242 }
1243 
1244 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1245 
1246 
1247 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1248 
1249 pragma solidity ^0.8.0;
1250 
1251 
1252 /**
1253  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1254  * @dev See https://eips.ethereum.org/EIPS/eip-721
1255  */
1256 interface IERC721Metadata is IERC721 {
1257     /**
1258      * @dev Returns the token collection name.
1259      */
1260     function name() external view returns (string memory);
1261 
1262     /**
1263      * @dev Returns the token collection symbol.
1264      */
1265     function symbol() external view returns (string memory);
1266 
1267     /**
1268      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1269      */
1270     function tokenURI(uint256 tokenId) external view returns (string memory);
1271 }
1272 
1273 // File: erc721a/contracts/ERC721A.sol
1274 
1275 
1276 // Creator: Chiru Labs
1277 
1278 pragma solidity ^0.8.4;
1279 
1280 
1281 
1282 
1283 
1284 
1285 
1286 
1287 error ApprovalCallerNotOwnerNorApproved();
1288 error ApprovalQueryForNonexistentToken();
1289 error ApproveToCaller();
1290 error ApprovalToCurrentOwner();
1291 error BalanceQueryForZeroAddress();
1292 error MintToZeroAddress();
1293 error MintZeroQuantity();
1294 error OwnerQueryForNonexistentToken();
1295 error TransferCallerNotOwnerNorApproved();
1296 error TransferFromIncorrectOwner();
1297 error TransferToNonERC721ReceiverImplementer();
1298 error TransferToZeroAddress();
1299 error URIQueryForNonexistentToken();
1300 
1301 /**
1302  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1303  * the Metadata extension. Built to optimize for lower gas during batch mints.
1304  *
1305  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1306  *
1307  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1308  *
1309  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1310  */
1311 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1312     using Address for address;
1313     using Strings for uint256;
1314 
1315     // Compiler will pack this into a single 256bit word.
1316     struct TokenOwnership {
1317         // The address of the owner.
1318         address addr;
1319         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1320         uint64 startTimestamp;
1321         // Whether the token has been burned.
1322         bool burned;
1323     }
1324 
1325     // Compiler will pack this into a single 256bit word.
1326     struct AddressData {
1327         // Realistically, 2**64-1 is more than enough.
1328         uint64 balance;
1329         // Keeps track of mint count with minimal overhead for tokenomics.
1330         uint64 numberMinted;
1331         // Keeps track of burn count with minimal overhead for tokenomics.
1332         uint64 numberBurned;
1333         // For miscellaneous variable(s) pertaining to the address
1334         // (e.g. number of whitelist mint slots used).
1335         // If there are multiple variables, please pack them into a uint64.
1336         uint64 aux;
1337     }
1338 
1339     // The tokenId of the next token to be minted.
1340     uint256 internal _currentIndex;
1341 
1342     // The number of tokens burned.
1343     uint256 internal _burnCounter;
1344 
1345     // Token name
1346     string private _name;
1347 
1348     // Token symbol
1349     string private _symbol;
1350 
1351     // Mapping from token ID to ownership details
1352     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1353     mapping(uint256 => TokenOwnership) internal _ownerships;
1354 
1355     // Mapping owner address to address data
1356     mapping(address => AddressData) private _addressData;
1357 
1358     // Mapping from token ID to approved address
1359     mapping(uint256 => address) private _tokenApprovals;
1360 
1361     // Mapping from owner to operator approvals
1362     mapping(address => mapping(address => bool)) private _operatorApprovals;
1363 
1364     constructor(string memory name_, string memory symbol_) {
1365         _name = name_;
1366         _symbol = symbol_;
1367         _currentIndex = _startTokenId();
1368     }
1369 
1370     /**
1371      * To change the starting tokenId, please override this function.
1372      */
1373     function _startTokenId() internal view virtual returns (uint256) {
1374         return 0;
1375     }
1376 
1377     /**
1378      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1379      */
1380     function totalSupply() public view returns (uint256) {
1381         // Counter underflow is impossible as _burnCounter cannot be incremented
1382         // more than _currentIndex - _startTokenId() times
1383         unchecked {
1384             return _currentIndex - _burnCounter - _startTokenId();
1385         }
1386     }
1387 
1388     /**
1389      * Returns the total amount of tokens minted in the contract.
1390      */
1391     function _totalMinted() internal view returns (uint256) {
1392         // Counter underflow is impossible as _currentIndex does not decrement,
1393         // and it is initialized to _startTokenId()
1394         unchecked {
1395             return _currentIndex - _startTokenId();
1396         }
1397     }
1398 
1399     /**
1400      * @dev See {IERC165-supportsInterface}.
1401      */
1402     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1403         return
1404             interfaceId == type(IERC721).interfaceId ||
1405             interfaceId == type(IERC721Metadata).interfaceId ||
1406             super.supportsInterface(interfaceId);
1407     }
1408 
1409     /**
1410      * @dev See {IERC721-balanceOf}.
1411      */
1412     function balanceOf(address owner) public view override returns (uint256) {
1413         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1414         return uint256(_addressData[owner].balance);
1415     }
1416 
1417     /**
1418      * Returns the number of tokens minted by `owner`.
1419      */
1420     function _numberMinted(address owner) internal view returns (uint256) {
1421         return uint256(_addressData[owner].numberMinted);
1422     }
1423 
1424     /**
1425      * Returns the number of tokens burned by or on behalf of `owner`.
1426      */
1427     function _numberBurned(address owner) internal view returns (uint256) {
1428         return uint256(_addressData[owner].numberBurned);
1429     }
1430 
1431     /**
1432      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1433      */
1434     function _getAux(address owner) internal view returns (uint64) {
1435         return _addressData[owner].aux;
1436     }
1437 
1438     /**
1439      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1440      * If there are multiple variables, please pack them into a uint64.
1441      */
1442     function _setAux(address owner, uint64 aux) internal {
1443         _addressData[owner].aux = aux;
1444     }
1445 
1446     /**
1447      * Gas spent here starts off proportional to the maximum mint batch size.
1448      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1449      */
1450     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1451         uint256 curr = tokenId;
1452 
1453         unchecked {
1454             if (_startTokenId() <= curr && curr < _currentIndex) {
1455                 TokenOwnership memory ownership = _ownerships[curr];
1456                 if (!ownership.burned) {
1457                     if (ownership.addr != address(0)) {
1458                         return ownership;
1459                     }
1460                     // Invariant:
1461                     // There will always be an ownership that has an address and is not burned
1462                     // before an ownership that does not have an address and is not burned.
1463                     // Hence, curr will not underflow.
1464                     while (true) {
1465                         curr--;
1466                         ownership = _ownerships[curr];
1467                         if (ownership.addr != address(0)) {
1468                             return ownership;
1469                         }
1470                     }
1471                 }
1472             }
1473         }
1474         revert OwnerQueryForNonexistentToken();
1475     }
1476 
1477     /**
1478      * @dev See {IERC721-ownerOf}.
1479      */
1480     function ownerOf(uint256 tokenId) public view override returns (address) {
1481         return _ownershipOf(tokenId).addr;
1482     }
1483 
1484     /**
1485      * @dev See {IERC721Metadata-name}.
1486      */
1487     function name() public view virtual override returns (string memory) {
1488         return _name;
1489     }
1490 
1491     /**
1492      * @dev See {IERC721Metadata-symbol}.
1493      */
1494     function symbol() public view virtual override returns (string memory) {
1495         return _symbol;
1496     }
1497 
1498     /**
1499      * @dev See {IERC721Metadata-tokenURI}.
1500      */
1501     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1502         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1503 
1504         string memory baseURI = _baseURI();
1505         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1506     }
1507 
1508     /**
1509      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1510      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1511      * by default, can be overriden in child contracts.
1512      */
1513     function _baseURI() internal view virtual returns (string memory) {
1514         return '';
1515     }
1516 
1517     /**
1518      * @dev See {IERC721-approve}.
1519      */
1520     function approve(address to, uint256 tokenId) public override {
1521         address owner = ERC721A.ownerOf(tokenId);
1522         if (to == owner) revert ApprovalToCurrentOwner();
1523 
1524         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1525             revert ApprovalCallerNotOwnerNorApproved();
1526         }
1527 
1528         _approve(to, tokenId, owner);
1529     }
1530 
1531     /**
1532      * @dev See {IERC721-getApproved}.
1533      */
1534     function getApproved(uint256 tokenId) public view override returns (address) {
1535         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1536 
1537         return _tokenApprovals[tokenId];
1538     }
1539 
1540     /**
1541      * @dev See {IERC721-setApprovalForAll}.
1542      */
1543     function setApprovalForAll(address operator, bool approved) public virtual override {
1544         if (operator == _msgSender()) revert ApproveToCaller();
1545 
1546         _operatorApprovals[_msgSender()][operator] = approved;
1547         emit ApprovalForAll(_msgSender(), operator, approved);
1548     }
1549 
1550     /**
1551      * @dev See {IERC721-isApprovedForAll}.
1552      */
1553     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1554         return _operatorApprovals[owner][operator];
1555     }
1556 
1557     /**
1558      * @dev See {IERC721-transferFrom}.
1559      */
1560     function transferFrom(
1561         address from,
1562         address to,
1563         uint256 tokenId
1564     ) public virtual override {
1565         _transfer(from, to, tokenId);
1566     }
1567 
1568     /**
1569      * @dev See {IERC721-safeTransferFrom}.
1570      */
1571     function safeTransferFrom(
1572         address from,
1573         address to,
1574         uint256 tokenId
1575     ) public virtual override {
1576         safeTransferFrom(from, to, tokenId, '');
1577     }
1578 
1579     /**
1580      * @dev See {IERC721-safeTransferFrom}.
1581      */
1582     function safeTransferFrom(
1583         address from,
1584         address to,
1585         uint256 tokenId,
1586         bytes memory _data
1587     ) public virtual override {
1588         _transfer(from, to, tokenId);
1589         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1590             revert TransferToNonERC721ReceiverImplementer();
1591         }
1592     }
1593 
1594     /**
1595      * @dev Returns whether `tokenId` exists.
1596      *
1597      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1598      *
1599      * Tokens start existing when they are minted (`_mint`),
1600      */
1601     function _exists(uint256 tokenId) internal view returns (bool) {
1602         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1603             !_ownerships[tokenId].burned;
1604     }
1605 
1606     function _safeMint(address to, uint256 quantity) internal {
1607         _safeMint(to, quantity, '');
1608     }
1609 
1610     /**
1611      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1612      *
1613      * Requirements:
1614      *
1615      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1616      * - `quantity` must be greater than 0.
1617      *
1618      * Emits a {Transfer} event.
1619      */
1620     function _safeMint(
1621         address to,
1622         uint256 quantity,
1623         bytes memory _data
1624     ) internal {
1625         _mint(to, quantity, _data, true);
1626     }
1627 
1628     /**
1629      * @dev Mints `quantity` tokens and transfers them to `to`.
1630      *
1631      * Requirements:
1632      *
1633      * - `to` cannot be the zero address.
1634      * - `quantity` must be greater than 0.
1635      *
1636      * Emits a {Transfer} event.
1637      */
1638     function _mint(
1639         address to,
1640         uint256 quantity,
1641         bytes memory _data,
1642         bool safe
1643     ) internal {
1644         uint256 startTokenId = _currentIndex;
1645         if (to == address(0)) revert MintToZeroAddress();
1646         if (quantity == 0) revert MintZeroQuantity();
1647 
1648         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1649 
1650         // Overflows are incredibly unrealistic.
1651         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1652         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1653         unchecked {
1654             _addressData[to].balance += uint64(quantity);
1655             _addressData[to].numberMinted += uint64(quantity);
1656 
1657             _ownerships[startTokenId].addr = to;
1658             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1659 
1660             uint256 updatedIndex = startTokenId;
1661             uint256 end = updatedIndex + quantity;
1662 
1663             if (safe && to.isContract()) {
1664                 do {
1665                     emit Transfer(address(0), to, updatedIndex);
1666                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1667                         revert TransferToNonERC721ReceiverImplementer();
1668                     }
1669                 } while (updatedIndex != end);
1670                 // Reentrancy protection
1671                 if (_currentIndex != startTokenId) revert();
1672             } else {
1673                 do {
1674                     emit Transfer(address(0), to, updatedIndex++);
1675                 } while (updatedIndex != end);
1676             }
1677             _currentIndex = updatedIndex;
1678         }
1679         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1680     }
1681 
1682     /**
1683      * @dev Transfers `tokenId` from `from` to `to`.
1684      *
1685      * Requirements:
1686      *
1687      * - `to` cannot be the zero address.
1688      * - `tokenId` token must be owned by `from`.
1689      *
1690      * Emits a {Transfer} event.
1691      */
1692     function _transfer(
1693         address from,
1694         address to,
1695         uint256 tokenId
1696     ) private {
1697         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1698 
1699         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1700 
1701         bool isApprovedOrOwner = (_msgSender() == from ||
1702             isApprovedForAll(from, _msgSender()) ||
1703             getApproved(tokenId) == _msgSender());
1704 
1705         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1706         if (to == address(0)) revert TransferToZeroAddress();
1707 
1708         _beforeTokenTransfers(from, to, tokenId, 1);
1709 
1710         // Clear approvals from the previous owner
1711         _approve(address(0), tokenId, from);
1712 
1713         // Underflow of the sender's balance is impossible because we check for
1714         // ownership above and the recipient's balance can't realistically overflow.
1715         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1716         unchecked {
1717             _addressData[from].balance -= 1;
1718             _addressData[to].balance += 1;
1719 
1720             TokenOwnership storage currSlot = _ownerships[tokenId];
1721             currSlot.addr = to;
1722             currSlot.startTimestamp = uint64(block.timestamp);
1723 
1724             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1725             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1726             uint256 nextTokenId = tokenId + 1;
1727             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1728             if (nextSlot.addr == address(0)) {
1729                 // This will suffice for checking _exists(nextTokenId),
1730                 // as a burned slot cannot contain the zero address.
1731                 if (nextTokenId != _currentIndex) {
1732                     nextSlot.addr = from;
1733                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1734                 }
1735             }
1736         }
1737 
1738         emit Transfer(from, to, tokenId);
1739         _afterTokenTransfers(from, to, tokenId, 1);
1740     }
1741 
1742     /**
1743      * @dev This is equivalent to _burn(tokenId, false)
1744      */
1745     function _burn(uint256 tokenId) internal virtual {
1746         _burn(tokenId, false);
1747     }
1748 
1749     /**
1750      * @dev Destroys `tokenId`.
1751      * The approval is cleared when the token is burned.
1752      *
1753      * Requirements:
1754      *
1755      * - `tokenId` must exist.
1756      *
1757      * Emits a {Transfer} event.
1758      */
1759     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1760         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1761 
1762         address from = prevOwnership.addr;
1763 
1764         if (approvalCheck) {
1765             bool isApprovedOrOwner = (_msgSender() == from ||
1766                 isApprovedForAll(from, _msgSender()) ||
1767                 getApproved(tokenId) == _msgSender());
1768 
1769             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1770         }
1771 
1772         _beforeTokenTransfers(from, address(0), tokenId, 1);
1773 
1774         // Clear approvals from the previous owner
1775         _approve(address(0), tokenId, from);
1776 
1777         // Underflow of the sender's balance is impossible because we check for
1778         // ownership above and the recipient's balance can't realistically overflow.
1779         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1780         unchecked {
1781             AddressData storage addressData = _addressData[from];
1782             addressData.balance -= 1;
1783             addressData.numberBurned += 1;
1784 
1785             // Keep track of who burned the token, and the timestamp of burning.
1786             TokenOwnership storage currSlot = _ownerships[tokenId];
1787             currSlot.addr = from;
1788             currSlot.startTimestamp = uint64(block.timestamp);
1789             currSlot.burned = true;
1790 
1791             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1792             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1793             uint256 nextTokenId = tokenId + 1;
1794             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1795             if (nextSlot.addr == address(0)) {
1796                 // This will suffice for checking _exists(nextTokenId),
1797                 // as a burned slot cannot contain the zero address.
1798                 if (nextTokenId != _currentIndex) {
1799                     nextSlot.addr = from;
1800                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1801                 }
1802             }
1803         }
1804 
1805         emit Transfer(from, address(0), tokenId);
1806         _afterTokenTransfers(from, address(0), tokenId, 1);
1807 
1808         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1809         unchecked {
1810             _burnCounter++;
1811         }
1812     }
1813 
1814     /**
1815      * @dev Approve `to` to operate on `tokenId`
1816      *
1817      * Emits a {Approval} event.
1818      */
1819     function _approve(
1820         address to,
1821         uint256 tokenId,
1822         address owner
1823     ) private {
1824         _tokenApprovals[tokenId] = to;
1825         emit Approval(owner, to, tokenId);
1826     }
1827 
1828     /**
1829      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1830      *
1831      * @param from address representing the previous owner of the given token ID
1832      * @param to target address that will receive the tokens
1833      * @param tokenId uint256 ID of the token to be transferred
1834      * @param _data bytes optional data to send along with the call
1835      * @return bool whether the call correctly returned the expected magic value
1836      */
1837     function _checkContractOnERC721Received(
1838         address from,
1839         address to,
1840         uint256 tokenId,
1841         bytes memory _data
1842     ) private returns (bool) {
1843         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1844             return retval == IERC721Receiver(to).onERC721Received.selector;
1845         } catch (bytes memory reason) {
1846             if (reason.length == 0) {
1847                 revert TransferToNonERC721ReceiverImplementer();
1848             } else {
1849                 assembly {
1850                     revert(add(32, reason), mload(reason))
1851                 }
1852             }
1853         }
1854     }
1855 
1856     /**
1857      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1858      * And also called before burning one token.
1859      *
1860      * startTokenId - the first token id to be transferred
1861      * quantity - the amount to be transferred
1862      *
1863      * Calling conditions:
1864      *
1865      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1866      * transferred to `to`.
1867      * - When `from` is zero, `tokenId` will be minted for `to`.
1868      * - When `to` is zero, `tokenId` will be burned by `from`.
1869      * - `from` and `to` are never both zero.
1870      */
1871     function _beforeTokenTransfers(
1872         address from,
1873         address to,
1874         uint256 startTokenId,
1875         uint256 quantity
1876     ) internal virtual {}
1877 
1878     /**
1879      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1880      * minting.
1881      * And also called after one token has been burned.
1882      *
1883      * startTokenId - the first token id to be transferred
1884      * quantity - the amount to be transferred
1885      *
1886      * Calling conditions:
1887      *
1888      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1889      * transferred to `to`.
1890      * - When `from` is zero, `tokenId` has been minted for `to`.
1891      * - When `to` is zero, `tokenId` has been burned by `from`.
1892      * - `from` and `to` are never both zero.
1893      */
1894     function _afterTokenTransfers(
1895         address from,
1896         address to,
1897         uint256 startTokenId,
1898         uint256 quantity
1899     ) internal virtual {}
1900 }
1901 
1902 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1903 
1904 
1905 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1906 
1907 pragma solidity ^0.8.0;
1908 
1909 /**
1910  * @dev Contract module that helps prevent reentrant calls to a function.
1911  *
1912  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1913  * available, which can be applied to functions to make sure there are no nested
1914  * (reentrant) calls to them.
1915  *
1916  * Note that because there is a single `nonReentrant` guard, functions marked as
1917  * `nonReentrant` may not call one another. This can be worked around by making
1918  * those functions `private`, and then adding `external` `nonReentrant` entry
1919  * points to them.
1920  *
1921  * TIP: If you would like to learn more about reentrancy and alternative ways
1922  * to protect against it, check out our blog post
1923  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1924  */
1925 abstract contract ReentrancyGuard {
1926     // Booleans are more expensive than uint256 or any type that takes up a full
1927     // word because each write operation emits an extra SLOAD to first read the
1928     // slot's contents, replace the bits taken up by the boolean, and then write
1929     // back. This is the compiler's defense against contract upgrades and
1930     // pointer aliasing, and it cannot be disabled.
1931 
1932     // The values being non-zero value makes deployment a bit more expensive,
1933     // but in exchange the refund on every call to nonReentrant will be lower in
1934     // amount. Since refunds are capped to a percentage of the total
1935     // transaction's gas, it is best to keep them low in cases like this one, to
1936     // increase the likelihood of the full refund coming into effect.
1937     uint256 private constant _NOT_ENTERED = 1;
1938     uint256 private constant _ENTERED = 2;
1939 
1940     uint256 private _status;
1941 
1942     constructor() {
1943         _status = _NOT_ENTERED;
1944     }
1945 
1946     /**
1947      * @dev Prevents a contract from calling itself, directly or indirectly.
1948      * Calling a `nonReentrant` function from another `nonReentrant`
1949      * function is not supported. It is possible to prevent this from happening
1950      * by making the `nonReentrant` function external, and making it call a
1951      * `private` function that does the actual work.
1952      */
1953     modifier nonReentrant() {
1954         _nonReentrantBefore();
1955         _;
1956         _nonReentrantAfter();
1957     }
1958 
1959     function _nonReentrantBefore() private {
1960         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1961         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1962 
1963         // Any calls to nonReentrant after this point will fail
1964         _status = _ENTERED;
1965     }
1966 
1967     function _nonReentrantAfter() private {
1968         // By storing the original value once again, a refund is triggered (see
1969         // https://eips.ethereum.org/EIPS/eip-2200)
1970         _status = _NOT_ENTERED;
1971     }
1972 }
1973 
1974 // File: contracts/moe-contract.sol
1975 
1976 
1977 
1978 pragma solidity ^0.8.17;
1979 
1980 
1981 
1982 
1983 
1984 contract SmolMoe is ERC721A, Ownable, ReentrancyGuard {
1985     using Strings for uint256;
1986 
1987     uint256 public constant STAGE_STOPPED = 0;
1988     uint256 public constant STAGE_PHASE1 = 1;
1989     uint256 public constant STAGE_PHASE2 = 2;
1990     uint256 public currentStage = STAGE_STOPPED;
1991 
1992     uint256 public tokenPriceWhitelist = 0.00 ether;
1993     uint256 public tokenPricePublic = 0.01 ether;
1994 
1995     uint256 public phase2Price = 0 ether;
1996     uint256 public phase2PriceIncrement = 0 ether;
1997 
1998     uint256 public maxTokensPerTransaction = 50;
1999 
2000     uint256 public maxTokensPerAddressPublicPhase1 = 50;
2001     uint256 public maxTokensPerAddressWhiteListPhase1 = 2;
2002 
2003     uint256 public maxTokensPerAddressPublicPhase2 = 0;
2004 
2005 
2006     uint256 public phase1Limit = 4444;
2007     uint256 public phase1WhitelistLimit = 2222;
2008     uint256 public phase2Limit = 0;
2009 
2010     bytes32 public whitelistRoot = 0x7f8f2969d051285c3bd1907b995e12b41909e6c852fba511463e9b49356212a9;
2011 
2012     string public tokenBaseURI = "ipfs://QmeZXzYhy1k5LQyFiZRADpJ5kvc7xpJpceQbNBmVGHJE5Y/";
2013 
2014     uint256 public soldAmount = 0;
2015     uint256 public soldAmountPhase2 = 0;
2016     mapping(address => uint256) public purchased;
2017 
2018     constructor() ERC721A("Smol Moe", "Smol Moe") {
2019         
2020     }
2021 
2022     function setTokenPriceWhitelist(uint256 val) external onlyOwner {
2023         tokenPriceWhitelist = val;
2024     }
2025 
2026     function setTokenPricePublic(uint256 val) external onlyOwner {
2027         tokenPricePublic = val;
2028     }
2029 
2030     function setPhase2Price(uint256 val) external onlyOwner {
2031         phase2Price = val;
2032     }
2033 
2034     function setPhase2PriceIncrement(uint256 val) external onlyOwner {
2035         phase2PriceIncrement = val;
2036     }
2037 
2038     function setMaxTokensPerAddressPublicPhase1(uint256 val) external onlyOwner {
2039         maxTokensPerAddressPublicPhase1 = val;
2040     }
2041 
2042     function setMaxTokensPerAddressWhiteListPhase1 (uint256 val) external onlyOwner {
2043         maxTokensPerAddressWhiteListPhase1  = val;
2044     }
2045 
2046     function setMaxTokensPerAddressPublicPhase2(uint256 val) external onlyOwner {
2047         maxTokensPerAddressPublicPhase2 = val;
2048     }
2049 
2050     function setMaxTokensPerTransaction(uint256 val) external onlyOwner {
2051         maxTokensPerTransaction = val;
2052     }
2053 
2054     function setPhase1Limit(uint256 val) external onlyOwner {
2055         phase1Limit = val;
2056     }
2057 
2058     function setPhase1WhitelistLimit(uint256 val) external onlyOwner {
2059         phase1WhitelistLimit = val;
2060     }
2061 
2062     function setPhase2Limit(uint256 val) external onlyOwner {
2063         phase2Limit = val;
2064     }
2065 
2066     function stopSale() external onlyOwner {
2067         currentStage = STAGE_STOPPED;
2068     }
2069 
2070     function startPhase1() external onlyOwner {
2071         currentStage = STAGE_PHASE1;
2072     }
2073     function startPhase2() external  onlyOwner {
2074         currentStage = STAGE_PHASE2;
2075     }
2076 
2077     function startPhase2WithInfo(
2078         uint256 _maxTokensPerAddressPublicPhase2,
2079         uint256 _phase2Limit,
2080         uint256 _phase2Price,
2081         uint256 _phase2PriceIncrement,
2082         uint256 _maxTokensPerTransaction) external onlyOwner {
2083         maxTokensPerAddressPublicPhase2 = _maxTokensPerAddressPublicPhase2;
2084         phase2Limit = _phase2Limit;
2085         phase2Price = _phase2Price;
2086         phase2PriceIncrement = _phase2PriceIncrement;
2087         maxTokensPerTransaction = _maxTokensPerTransaction;
2088         currentStage = STAGE_PHASE2;
2089     }
2090 
2091     function _baseURI() internal view override(ERC721A) returns (string memory) {
2092         return tokenBaseURI;
2093     }
2094    
2095     function setBaseURI(string calldata URI) external onlyOwner {
2096         tokenBaseURI = URI;
2097     }
2098 
2099     function withdraw() external onlyOwner {
2100         require(payable(msg.sender).send(address(this).balance));
2101     }
2102 
2103     function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
2104         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
2105     }
2106 
2107     function _startTokenId() internal pure override(ERC721A) returns (uint256) {
2108         return 1;
2109     }
2110     function setWhitelistRoot(bytes32 val) external onlyOwner {
2111         whitelistRoot = val;
2112     }
2113 
2114     function tokenPrice(address target, bytes32[] memory proof) public view returns (uint256) {
2115         bytes32 leaf = keccak256(abi.encodePacked(target));
2116         
2117         if (currentStage == STAGE_PHASE1) {
2118             uint256 tokensLeftWhitelist = safeSub(phase1WhitelistLimit, soldAmount);
2119             if (MerkleProof.verify(proof, whitelistRoot, leaf) && purchased[target] < maxTokensPerAddressWhiteListPhase1
2120             && tokensLeftWhitelist > 0) {
2121                 return tokenPriceWhitelist;
2122             } else {
2123                 return tokenPricePublic;
2124             }
2125         } else if(currentStage == STAGE_PHASE2) {
2126             return phase2Price + phase2PriceIncrement * soldAmountPhase2;
2127         } else { 
2128             return 0;
2129         }
2130     }
2131 
2132     function getMaxTokensForPhase(address target, bytes32[] memory proof) public view returns (uint256) {
2133         bytes32 leaf = keccak256(abi.encodePacked(target));
2134 
2135         if (currentStage == STAGE_STOPPED) {
2136             return 0;
2137         }else if (currentStage == STAGE_PHASE1) {
2138             uint256 tokensLeftWhitelist = safeSub(phase1WhitelistLimit, soldAmount);
2139             if (MerkleProof.verify(proof, whitelistRoot, leaf) && purchased[target] < maxTokensPerAddressWhiteListPhase1
2140             && tokensLeftWhitelist > 0) {
2141                 return min(tokensLeftWhitelist, maxTokensPerAddressWhiteListPhase1);
2142             } else {
2143                 return maxTokensPerAddressPublicPhase1;
2144             }
2145         }else if(currentStage == STAGE_PHASE2) {
2146             return maxTokensPerAddressPublicPhase2;
2147         }else {
2148             return 0;
2149         } 
2150     }
2151 
2152     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
2153         if (a < b) {
2154             return 0;
2155         }
2156         return a - b;
2157     }
2158 
2159     function getMaxTokensAllowed(address target, bytes32[] memory proof) public view returns (uint256) {
2160 
2161         uint256 maxAllowedTokens = getMaxTokensForPhase(target, proof);
2162 
2163         uint256 tokensLeftForAddress = safeSub(maxAllowedTokens, purchased[target]);
2164         maxAllowedTokens = min(maxAllowedTokens, tokensLeftForAddress);
2165 
2166         if (currentStage == STAGE_PHASE1) {
2167             uint256 tokensLeftForPhase1 = safeSub(phase1Limit, soldAmount);
2168             maxAllowedTokens = min(maxAllowedTokens, tokensLeftForPhase1);
2169         } else if(currentStage == STAGE_PHASE2) {
2170             uint256 tokensLeftPhase2 = safeSub(phase2Limit, soldAmountPhase2);
2171             maxAllowedTokens = min(maxAllowedTokens, tokensLeftPhase2);
2172         }
2173        
2174         maxAllowedTokens = min(maxAllowedTokens, maxTokensPerTransaction);
2175 
2176         return maxAllowedTokens;
2177     }
2178 
2179      function getContractInfo(address target, bytes32[] memory proof) external view returns (
2180         uint256 _currentStage,
2181         uint256 _maxTokensAllowed,
2182         uint256 _tokenPrice,
2183         uint256 _phase2PriceIncrement,
2184         uint256 _soldAmount,
2185         uint256 _totalForSale,
2186         uint256 _purchasedAmount,
2187         uint256 _phase1TotalLimit,
2188         uint256 _phase2TotalLimit,
2189         bytes32 _whitelistRoot
2190     ) {
2191         _currentStage = currentStage;
2192         _maxTokensAllowed = getMaxTokensAllowed(target, proof);
2193         _tokenPrice = tokenPrice(target, proof);
2194         _phase2PriceIncrement = phase2PriceIncrement;
2195         _soldAmount = soldAmount + soldAmountPhase2;
2196         _totalForSale = phase1Limit + phase2Limit;
2197         _purchasedAmount = purchased[target];
2198         _phase1TotalLimit = phase1Limit;
2199         _phase2TotalLimit = phase2Limit;
2200         _whitelistRoot = whitelistRoot;
2201     }
2202 
2203     function mint(uint256 amount, bytes32[] calldata proof) external payable nonReentrant {
2204         require(currentStage != STAGE_STOPPED, "Cannot mint before sale start");
2205         require(amount <= getMaxTokensAllowed(msg.sender, proof), "Cannot mint more than the max allowed tokens");
2206 
2207         if (currentStage == STAGE_PHASE1) {
2208             require(msg.value >= tokenPrice(msg.sender, proof) * amount, "Incorrect ETH");
2209             soldAmount += amount;
2210         }else if(currentStage == STAGE_PHASE2) {
2211             uint256 priceOfFirstToken = tokenPrice(msg.sender, proof);
2212             uint256 totalPrice = priceOfFirstToken;
2213             if (amount > 0) {
2214                 uint256 priceOfLastToken = priceOfFirstToken + (amount - 1) * phase2PriceIncrement;
2215                 totalPrice = amount * ((priceOfFirstToken + priceOfLastToken) / 2);
2216             }
2217             require(msg.value >= totalPrice, "Incorrect ETH");
2218             soldAmountPhase2 += amount;
2219         }
2220         _safeMint(msg.sender, amount);
2221         purchased[msg.sender] += amount;
2222     }
2223 
2224     function min(uint256 a, uint256 b) internal pure returns (uint256) {
2225         return a < b ? a : b;
2226     }
2227 }