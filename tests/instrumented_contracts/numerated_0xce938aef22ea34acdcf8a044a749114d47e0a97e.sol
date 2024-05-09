1 // SPDX-License-Identifier: GPL-3.0
2 
3 /**
4 
5     ╔═╗┌┬┐┬─┐┌─┐┌─┐┌┬┐╔╦╗┌─┐┬ ┌┬┐┌─┐
6     ╚═╗ │ ├┬┘├┤ ├┤  │ ║║║├┤ │  │ └─┐
7     ╚═╝ ┴ ┴└─└─┘└─┘ ┴ ╩ ╩└─┘┴─┘┴ └─┘
8     Contract by @texoid__
9 
10 */
11 
12 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
13 pragma solidity ^0.8.0;
14 /**
15  * @dev These functions deal with verification of Merkle Tree proofs.
16  *
17  * The tree and the proofs can be generated using our
18  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
19  * You will find a quickstart guide in the readme.
20  *
21  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
22  * hashing, or use a hash function other than keccak256 for hashing leaves.
23  * This is because the concatenation of a sorted pair of internal nodes in
24  * the merkle tree could be reinterpreted as a leaf value.
25  * OpenZeppelin's JavaScript library generates merkle trees that are safe
26  * against this attack out of the box.
27  */
28 library MerkleProof {
29     /**
30      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
31      * defined by `root`. For this, a `proof` must be provided, containing
32      * sibling hashes on the branch from the leaf to the root of the tree. Each
33      * pair of leaves and each pair of pre-images are assumed to be sorted.
34      */
35     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
36         return processProof(proof, leaf) == root;
37     }
38 
39     /**
40      * @dev Calldata version of {verify}
41      *
42      * _Available since v4.7._
43      */
44     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
45         return processProofCalldata(proof, leaf) == root;
46     }
47 
48     /**
49      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
50      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
51      * hash matches the root of the tree. When processing the proof, the pairs
52      * of leafs & pre-images are assumed to be sorted.
53      *
54      * _Available since v4.4._
55      */
56     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
57         bytes32 computedHash = leaf;
58         for (uint256 i = 0; i < proof.length; i++) {
59             computedHash = _hashPair(computedHash, proof[i]);
60         }
61         return computedHash;
62     }
63 
64     /**
65      * @dev Calldata version of {processProof}
66      *
67      * _Available since v4.7._
68      */
69     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
70         bytes32 computedHash = leaf;
71         for (uint256 i = 0; i < proof.length; i++) {
72             computedHash = _hashPair(computedHash, proof[i]);
73         }
74         return computedHash;
75     }
76 
77     /**
78      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
79      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
80      *
81      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
82      *
83      * _Available since v4.7._
84      */
85     function multiProofVerify(
86         bytes32[] memory proof,
87         bool[] memory proofFlags,
88         bytes32 root,
89         bytes32[] memory leaves
90     ) internal pure returns (bool) {
91         return processMultiProof(proof, proofFlags, leaves) == root;
92     }
93 
94     /**
95      * @dev Calldata version of {multiProofVerify}
96      *
97      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
98      *
99      * _Available since v4.7._
100      */
101     function multiProofVerifyCalldata(
102         bytes32[] calldata proof,
103         bool[] calldata proofFlags,
104         bytes32 root,
105         bytes32[] memory leaves
106     ) internal pure returns (bool) {
107         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
108     }
109 
110     /**
111      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
112      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
113      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
114      * respectively.
115      *
116      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
117      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
118      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
119      *
120      * _Available since v4.7._
121      */
122     function processMultiProof(
123         bytes32[] memory proof,
124         bool[] memory proofFlags,
125         bytes32[] memory leaves
126     ) internal pure returns (bytes32 merkleRoot) {
127         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
128         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
129         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
130         // the merkle tree.
131         uint256 leavesLen = leaves.length;
132         uint256 totalHashes = proofFlags.length;
133 
134         // Check proof validity.
135         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
136 
137         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
138         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
139         bytes32[] memory hashes = new bytes32[](totalHashes);
140         uint256 leafPos = 0;
141         uint256 hashPos = 0;
142         uint256 proofPos = 0;
143         // At each step, we compute the next hash using two values:
144         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
145         //   get the next hash.
146         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
147         //   `proof` array.
148         for (uint256 i = 0; i < totalHashes; i++) {
149             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
150             bytes32 b = proofFlags[i]
151                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
152                 : proof[proofPos++];
153             hashes[i] = _hashPair(a, b);
154         }
155 
156         if (totalHashes > 0) {
157             unchecked {
158                 return hashes[totalHashes - 1];
159             }
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
179         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
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
198         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
199         //   `proof` array.
200         for (uint256 i = 0; i < totalHashes; i++) {
201             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
202             bytes32 b = proofFlags[i]
203                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
204                 : proof[proofPos++];
205             hashes[i] = _hashPair(a, b);
206         }
207 
208         if (totalHashes > 0) {
209             unchecked {
210                 return hashes[totalHashes - 1];
211             }
212         } else if (leavesLen > 0) {
213             return leaves[0];
214         } else {
215             return proof[0];
216         }
217     }
218 
219     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
220         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
221     }
222 
223     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
224         /// @solidity memory-safe-assembly
225         assembly {
226             mstore(0x00, a)
227             mstore(0x20, b)
228             value := keccak256(0x00, 0x40)
229         }
230     }
231 }
232 
233 
234 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
235 pragma solidity ^0.8.0;
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
285     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
286         unchecked {
287             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
288             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
289             // variables such that product = prod1 * 2^256 + prod0.
290             uint256 prod0; // Least significant 256 bits of the product
291             uint256 prod1; // Most significant 256 bits of the product
292             assembly {
293                 let mm := mulmod(x, y, not(0))
294                 prod0 := mul(x, y)
295                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
296             }
297 
298             // Handle non-overflow cases, 256 by 256 division.
299             if (prod1 == 0) {
300                 return prod0 / denominator;
301             }
302 
303             // Make sure the result is less than 2^256. Also prevents denominator == 0.
304             require(denominator > prod1, "Math: mulDiv overflow");
305 
306             ///////////////////////////////////////////////
307             // 512 by 256 division.
308             ///////////////////////////////////////////////
309 
310             // Make division exact by subtracting the remainder from [prod1 prod0].
311             uint256 remainder;
312             assembly {
313                 // Compute remainder using mulmod.
314                 remainder := mulmod(x, y, denominator)
315 
316                 // Subtract 256 bit number from 512 bit number.
317                 prod1 := sub(prod1, gt(remainder, prod0))
318                 prod0 := sub(prod0, remainder)
319             }
320 
321             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
322             // See https://cs.stackexchange.com/q/138556/92363.
323 
324             // Does not overflow because the denominator cannot be zero at this stage in the function.
325             uint256 twos = denominator & (~denominator + 1);
326             assembly {
327                 // Divide denominator by twos.
328                 denominator := div(denominator, twos)
329 
330                 // Divide [prod1 prod0] by twos.
331                 prod0 := div(prod0, twos)
332 
333                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
334                 twos := add(div(sub(0, twos), twos), 1)
335             }
336 
337             // Shift in bits from prod1 into prod0.
338             prod0 |= prod1 * twos;
339 
340             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
341             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
342             // four bits. That is, denominator * inv = 1 mod 2^4.
343             uint256 inverse = (3 * denominator) ^ 2;
344 
345             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
346             // in modular arithmetic, doubling the correct bits in each step.
347             inverse *= 2 - denominator * inverse; // inverse mod 2^8
348             inverse *= 2 - denominator * inverse; // inverse mod 2^16
349             inverse *= 2 - denominator * inverse; // inverse mod 2^32
350             inverse *= 2 - denominator * inverse; // inverse mod 2^64
351             inverse *= 2 - denominator * inverse; // inverse mod 2^128
352             inverse *= 2 - denominator * inverse; // inverse mod 2^256
353 
354             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
355             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
356             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
357             // is no longer required.
358             result = prod0 * inverse;
359             return result;
360         }
361     }
362 
363     /**
364      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
365      */
366     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
367         uint256 result = mulDiv(x, y, denominator);
368         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
369             result += 1;
370         }
371         return result;
372     }
373 
374     /**
375      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
376      *
377      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
378      */
379     function sqrt(uint256 a) internal pure returns (uint256) {
380         if (a == 0) {
381             return 0;
382         }
383 
384         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
385         //
386         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
387         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
388         //
389         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
390         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
391         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
392         //
393         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
394         uint256 result = 1 << (log2(a) >> 1);
395 
396         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
397         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
398         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
399         // into the expected uint128 result.
400         unchecked {
401             result = (result + a / result) >> 1;
402             result = (result + a / result) >> 1;
403             result = (result + a / result) >> 1;
404             result = (result + a / result) >> 1;
405             result = (result + a / result) >> 1;
406             result = (result + a / result) >> 1;
407             result = (result + a / result) >> 1;
408             return min(result, a / result);
409         }
410     }
411 
412     /**
413      * @notice Calculates sqrt(a), following the selected rounding direction.
414      */
415     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
416         unchecked {
417             uint256 result = sqrt(a);
418             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
419         }
420     }
421 
422     /**
423      * @dev Return the log in base 2, rounded down, of a positive value.
424      * Returns 0 if given 0.
425      */
426     function log2(uint256 value) internal pure returns (uint256) {
427         uint256 result = 0;
428         unchecked {
429             if (value >> 128 > 0) {
430                 value >>= 128;
431                 result += 128;
432             }
433             if (value >> 64 > 0) {
434                 value >>= 64;
435                 result += 64;
436             }
437             if (value >> 32 > 0) {
438                 value >>= 32;
439                 result += 32;
440             }
441             if (value >> 16 > 0) {
442                 value >>= 16;
443                 result += 16;
444             }
445             if (value >> 8 > 0) {
446                 value >>= 8;
447                 result += 8;
448             }
449             if (value >> 4 > 0) {
450                 value >>= 4;
451                 result += 4;
452             }
453             if (value >> 2 > 0) {
454                 value >>= 2;
455                 result += 2;
456             }
457             if (value >> 1 > 0) {
458                 result += 1;
459             }
460         }
461         return result;
462     }
463 
464     /**
465      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
466      * Returns 0 if given 0.
467      */
468     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
469         unchecked {
470             uint256 result = log2(value);
471             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
472         }
473     }
474 
475     /**
476      * @dev Return the log in base 10, rounded down, of a positive value.
477      * Returns 0 if given 0.
478      */
479     function log10(uint256 value) internal pure returns (uint256) {
480         uint256 result = 0;
481         unchecked {
482             if (value >= 10 ** 64) {
483                 value /= 10 ** 64;
484                 result += 64;
485             }
486             if (value >= 10 ** 32) {
487                 value /= 10 ** 32;
488                 result += 32;
489             }
490             if (value >= 10 ** 16) {
491                 value /= 10 ** 16;
492                 result += 16;
493             }
494             if (value >= 10 ** 8) {
495                 value /= 10 ** 8;
496                 result += 8;
497             }
498             if (value >= 10 ** 4) {
499                 value /= 10 ** 4;
500                 result += 4;
501             }
502             if (value >= 10 ** 2) {
503                 value /= 10 ** 2;
504                 result += 2;
505             }
506             if (value >= 10 ** 1) {
507                 result += 1;
508             }
509         }
510         return result;
511     }
512 
513     /**
514      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
515      * Returns 0 if given 0.
516      */
517     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
518         unchecked {
519             uint256 result = log10(value);
520             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
521         }
522     }
523 
524     /**
525      * @dev Return the log in base 256, rounded down, of a positive value.
526      * Returns 0 if given 0.
527      *
528      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
529      */
530     function log256(uint256 value) internal pure returns (uint256) {
531         uint256 result = 0;
532         unchecked {
533             if (value >> 128 > 0) {
534                 value >>= 128;
535                 result += 16;
536             }
537             if (value >> 64 > 0) {
538                 value >>= 64;
539                 result += 8;
540             }
541             if (value >> 32 > 0) {
542                 value >>= 32;
543                 result += 4;
544             }
545             if (value >> 16 > 0) {
546                 value >>= 16;
547                 result += 2;
548             }
549             if (value >> 8 > 0) {
550                 result += 1;
551             }
552         }
553         return result;
554     }
555 
556     /**
557      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
558      * Returns 0 if given 0.
559      */
560     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
561         unchecked {
562             uint256 result = log256(value);
563             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
564         }
565     }
566 }
567 
568 
569 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
570 pragma solidity ^0.8.0;
571 /**
572  * @dev Standard signed math utilities missing in the Solidity language.
573  */
574 library SignedMath {
575     /**
576      * @dev Returns the largest of two signed numbers.
577      */
578     function max(int256 a, int256 b) internal pure returns (int256) {
579         return a > b ? a : b;
580     }
581 
582     /**
583      * @dev Returns the smallest of two signed numbers.
584      */
585     function min(int256 a, int256 b) internal pure returns (int256) {
586         return a < b ? a : b;
587     }
588 
589     /**
590      * @dev Returns the average of two signed numbers without overflow.
591      * The result is rounded towards zero.
592      */
593     function average(int256 a, int256 b) internal pure returns (int256) {
594         // Formula from the book "Hacker's Delight"
595         int256 x = (a & b) + ((a ^ b) >> 1);
596         return x + (int256(uint256(x) >> 255) & (a ^ b));
597     }
598 
599     /**
600      * @dev Returns the absolute unsigned value of a signed value.
601      */
602     function abs(int256 n) internal pure returns (uint256) {
603         unchecked {
604             // must be unchecked in order to support `n = type(int256).min`
605             return uint256(n >= 0 ? n : -n);
606         }
607     }
608 }
609 
610 
611 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
612 pragma solidity ^0.8.0;
613 /**
614  * @dev String operations.
615  */
616 library Strings {
617     bytes16 private constant _SYMBOLS = "0123456789abcdef";
618     uint8 private constant _ADDRESS_LENGTH = 20;
619 
620     /**
621      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
622      */
623     function toString(uint256 value) internal pure returns (string memory) {
624         unchecked {
625             uint256 length = Math.log10(value) + 1;
626             string memory buffer = new string(length);
627             uint256 ptr;
628             /// @solidity memory-safe-assembly
629             assembly {
630                 ptr := add(buffer, add(32, length))
631             }
632             while (true) {
633                 ptr--;
634                 /// @solidity memory-safe-assembly
635                 assembly {
636                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
637                 }
638                 value /= 10;
639                 if (value == 0) break;
640             }
641             return buffer;
642         }
643     }
644 
645     /**
646      * @dev Converts a `int256` to its ASCII `string` decimal representation.
647      */
648     function toString(int256 value) internal pure returns (string memory) {
649         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
650     }
651 
652     /**
653      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
654      */
655     function toHexString(uint256 value) internal pure returns (string memory) {
656         unchecked {
657             return toHexString(value, Math.log256(value) + 1);
658         }
659     }
660 
661     /**
662      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
663      */
664     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
665         bytes memory buffer = new bytes(2 * length + 2);
666         buffer[0] = "0";
667         buffer[1] = "x";
668         for (uint256 i = 2 * length + 1; i > 1; --i) {
669             buffer[i] = _SYMBOLS[value & 0xf];
670             value >>= 4;
671         }
672         require(value == 0, "Strings: hex length insufficient");
673         return string(buffer);
674     }
675 
676     /**
677      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
678      */
679     function toHexString(address addr) internal pure returns (string memory) {
680         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
681     }
682 
683     /**
684      * @dev Returns true if the two strings are equal.
685      */
686     function equal(string memory a, string memory b) internal pure returns (bool) {
687         return keccak256(bytes(a)) == keccak256(bytes(b));
688     }
689 }
690 
691 
692 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
693 pragma solidity ^0.8.0;
694 /**
695  * @dev Provides information about the current execution context, including the
696  * sender of the transaction and its data. While these are generally available
697  * via msg.sender and msg.data, they should not be accessed in such a direct
698  * manner, since when dealing with meta-transactions the account sending and
699  * paying for execution may not be the actual sender (as far as an application
700  * is concerned).
701  *
702  * This contract is only required for intermediate, library-like contracts.
703  */
704 abstract contract Context {
705     function _msgSender() internal view virtual returns (address) {
706         return msg.sender;
707     }
708 
709     function _msgData() internal view virtual returns (bytes calldata) {
710         return msg.data;
711     }
712 }
713 
714 
715 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
716 pragma solidity ^0.8.1;
717 /**
718  * @dev Collection of functions related to the address type
719  */
720 library Address {
721     /**
722      * @dev Returns true if `account` is a contract.
723      *
724      * [IMPORTANT]
725      * ====
726      * It is unsafe to assume that an address for which this function returns
727      * false is an externally-owned account (EOA) and not a contract.
728      *
729      * Among others, `isContract` will return false for the following
730      * types of addresses:
731      *
732      *  - an externally-owned account
733      *  - a contract in construction
734      *  - an address where a contract will be created
735      *  - an address where a contract lived, but was destroyed
736      *
737      * Furthermore, `isContract` will also return true if the target contract within
738      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
739      * which only has an effect at the end of a transaction.
740      * ====
741      *
742      * [IMPORTANT]
743      * ====
744      * You shouldn't rely on `isContract` to protect against flash loan attacks!
745      *
746      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
747      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
748      * constructor.
749      * ====
750      */
751     function isContract(address account) internal view returns (bool) {
752         // This method relies on extcodesize/address.code.length, which returns 0
753         // for contracts in construction, since the code is only stored at the end
754         // of the constructor execution.
755 
756         return account.code.length > 0;
757     }
758 
759     /**
760      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
761      * `recipient`, forwarding all available gas and reverting on errors.
762      *
763      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
764      * of certain opcodes, possibly making contracts go over the 2300 gas limit
765      * imposed by `transfer`, making them unable to receive funds via
766      * `transfer`. {sendValue} removes this limitation.
767      *
768      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
769      *
770      * IMPORTANT: because control is transferred to `recipient`, care must be
771      * taken to not create reentrancy vulnerabilities. Consider using
772      * {ReentrancyGuard} or the
773      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
774      */
775     function sendValue(address payable recipient, uint256 amount) internal {
776         require(address(this).balance >= amount, "Address: insufficient balance");
777 
778         (bool success, ) = recipient.call{value: amount}("");
779         require(success, "Address: unable to send value, recipient may have reverted");
780     }
781 
782     /**
783      * @dev Performs a Solidity function call using a low level `call`. A
784      * plain `call` is an unsafe replacement for a function call: use this
785      * function instead.
786      *
787      * If `target` reverts with a revert reason, it is bubbled up by this
788      * function (like regular Solidity function calls).
789      *
790      * Returns the raw returned data. To convert to the expected return value,
791      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
792      *
793      * Requirements:
794      *
795      * - `target` must be a contract.
796      * - calling `target` with `data` must not revert.
797      *
798      * _Available since v3.1._
799      */
800     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
801         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
802     }
803 
804     /**
805      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
806      * `errorMessage` as a fallback revert reason when `target` reverts.
807      *
808      * _Available since v3.1._
809      */
810     function functionCall(
811         address target,
812         bytes memory data,
813         string memory errorMessage
814     ) internal returns (bytes memory) {
815         return functionCallWithValue(target, data, 0, errorMessage);
816     }
817 
818     /**
819      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
820      * but also transferring `value` wei to `target`.
821      *
822      * Requirements:
823      *
824      * - the calling contract must have an ETH balance of at least `value`.
825      * - the called Solidity function must be `payable`.
826      *
827      * _Available since v3.1._
828      */
829     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
830         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
831     }
832 
833     /**
834      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
835      * with `errorMessage` as a fallback revert reason when `target` reverts.
836      *
837      * _Available since v3.1._
838      */
839     function functionCallWithValue(
840         address target,
841         bytes memory data,
842         uint256 value,
843         string memory errorMessage
844     ) internal returns (bytes memory) {
845         require(address(this).balance >= value, "Address: insufficient balance for call");
846         (bool success, bytes memory returndata) = target.call{value: value}(data);
847         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
848     }
849 
850     /**
851      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
852      * but performing a static call.
853      *
854      * _Available since v3.3._
855      */
856     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
857         return functionStaticCall(target, data, "Address: low-level static call failed");
858     }
859 
860     /**
861      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
862      * but performing a static call.
863      *
864      * _Available since v3.3._
865      */
866     function functionStaticCall(
867         address target,
868         bytes memory data,
869         string memory errorMessage
870     ) internal view returns (bytes memory) {
871         (bool success, bytes memory returndata) = target.staticcall(data);
872         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
873     }
874 
875     /**
876      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
877      * but performing a delegate call.
878      *
879      * _Available since v3.4._
880      */
881     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
882         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
883     }
884 
885     /**
886      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
887      * but performing a delegate call.
888      *
889      * _Available since v3.4._
890      */
891     function functionDelegateCall(
892         address target,
893         bytes memory data,
894         string memory errorMessage
895     ) internal returns (bytes memory) {
896         (bool success, bytes memory returndata) = target.delegatecall(data);
897         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
898     }
899 
900     /**
901      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
902      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
903      *
904      * _Available since v4.8._
905      */
906     function verifyCallResultFromTarget(
907         address target,
908         bool success,
909         bytes memory returndata,
910         string memory errorMessage
911     ) internal view returns (bytes memory) {
912         if (success) {
913             if (returndata.length == 0) {
914                 // only check isContract if the call was successful and the return data is empty
915                 // otherwise we already know that it was a contract
916                 require(isContract(target), "Address: call to non-contract");
917             }
918             return returndata;
919         } else {
920             _revert(returndata, errorMessage);
921         }
922     }
923 
924     /**
925      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
926      * revert reason or using the provided one.
927      *
928      * _Available since v4.3._
929      */
930     function verifyCallResult(
931         bool success,
932         bytes memory returndata,
933         string memory errorMessage
934     ) internal pure returns (bytes memory) {
935         if (success) {
936             return returndata;
937         } else {
938             _revert(returndata, errorMessage);
939         }
940     }
941 
942     function _revert(bytes memory returndata, string memory errorMessage) private pure {
943         // Look for revert reason and bubble it up if present
944         if (returndata.length > 0) {
945             // The easiest way to bubble the revert reason is using memory via assembly
946             /// @solidity memory-safe-assembly
947             assembly {
948                 let returndata_size := mload(returndata)
949                 revert(add(32, returndata), returndata_size)
950             }
951         } else {
952             revert(errorMessage);
953         }
954     }
955 }
956 
957 
958 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
959 pragma solidity ^0.8.0;
960 /**
961  * @dev Contract module that helps prevent reentrant calls to a function.
962  *
963  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
964  * available, which can be applied to functions to make sure there are no nested
965  * (reentrant) calls to them.
966  *
967  * Note that because there is a single `nonReentrant` guard, functions marked as
968  * `nonReentrant` may not call one another. This can be worked around by making
969  * those functions `private`, and then adding `external` `nonReentrant` entry
970  * points to them.
971  *
972  * TIP: If you would like to learn more about reentrancy and alternative ways
973  * to protect against it, check out our blog post
974  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
975  */
976 abstract contract ReentrancyGuard {
977     // Booleans are more expensive than uint256 or any type that takes up a full
978     // word because each write operation emits an extra SLOAD to first read the
979     // slot's contents, replace the bits taken up by the boolean, and then write
980     // back. This is the compiler's defense against contract upgrades and
981     // pointer aliasing, and it cannot be disabled.
982 
983     // The values being non-zero value makes deployment a bit more expensive,
984     // but in exchange the refund on every call to nonReentrant will be lower in
985     // amount. Since refunds are capped to a percentage of the total
986     // transaction's gas, it is best to keep them low in cases like this one, to
987     // increase the likelihood of the full refund coming into effect.
988     uint256 private constant _NOT_ENTERED = 1;
989     uint256 private constant _ENTERED = 2;
990 
991     uint256 private _status;
992 
993     constructor() {
994         _status = _NOT_ENTERED;
995     }
996 
997     /**
998      * @dev Prevents a contract from calling itself, directly or indirectly.
999      * Calling a `nonReentrant` function from another `nonReentrant`
1000      * function is not supported. It is possible to prevent this from happening
1001      * by making the `nonReentrant` function external, and making it call a
1002      * `private` function that does the actual work.
1003      */
1004     modifier nonReentrant() {
1005         _nonReentrantBefore();
1006         _;
1007         _nonReentrantAfter();
1008     }
1009 
1010     function _nonReentrantBefore() private {
1011         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1012         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1013 
1014         // Any calls to nonReentrant after this point will fail
1015         _status = _ENTERED;
1016     }
1017 
1018     function _nonReentrantAfter() private {
1019         // By storing the original value once again, a refund is triggered (see
1020         // https://eips.ethereum.org/EIPS/eip-2200)
1021         _status = _NOT_ENTERED;
1022     }
1023 
1024     /**
1025      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1026      * `nonReentrant` function in the call stack.
1027      */
1028     function _reentrancyGuardEntered() internal view returns (bool) {
1029         return _status == _ENTERED;
1030     }
1031 }
1032 
1033 
1034 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1035 pragma solidity ^0.8.0;
1036 /**
1037  * @dev Contract module which provides a basic access control mechanism, where
1038  * there is an account (an owner) that can be granted exclusive access to
1039  * specific functions.
1040  *
1041  * By default, the owner account will be the one that deploys the contract. This
1042  * can later be changed with {transferOwnership}.
1043  *
1044  * This module is used through inheritance. It will make available the modifier
1045  * `onlyOwner`, which can be applied to your functions to restrict their use to
1046  * the owner.
1047  */
1048 abstract contract Ownable is Context {
1049     address private _owner;
1050 
1051     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1052 
1053     /**
1054      * @dev Initializes the contract setting the deployer as the initial owner.
1055      */
1056     constructor() {
1057         _transferOwnership(_msgSender());
1058     }
1059 
1060     /**
1061      * @dev Throws if called by any account other than the owner.
1062      */
1063     modifier onlyOwner() {
1064         _checkOwner();
1065         _;
1066     }
1067 
1068     /**
1069      * @dev Returns the address of the current owner.
1070      */
1071     function owner() public view virtual returns (address) {
1072         return _owner;
1073     }
1074 
1075     /**
1076      * @dev Throws if the sender is not the owner.
1077      */
1078     function _checkOwner() internal view virtual {
1079         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1080     }
1081 
1082     /**
1083      * @dev Leaves the contract without owner. It will not be possible to call
1084      * `onlyOwner` functions anymore. Can only be called by the current owner.
1085      *
1086      * NOTE: Renouncing ownership will leave the contract without an owner,
1087      * thereby removing any functionality that is only available to the owner.
1088      */
1089     function renounceOwnership() public virtual onlyOwner {
1090         _transferOwnership(address(0));
1091     }
1092 
1093     /**
1094      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1095      * Can only be called by the current owner.
1096      */
1097     function transferOwnership(address newOwner) public virtual onlyOwner {
1098         require(newOwner != address(0), "Ownable: new owner is the zero address");
1099         _transferOwnership(newOwner);
1100     }
1101 
1102     /**
1103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1104      * Internal function without access restriction.
1105      */
1106     function _transferOwnership(address newOwner) internal virtual {
1107         address oldOwner = _owner;
1108         _owner = newOwner;
1109         emit OwnershipTransferred(oldOwner, newOwner);
1110     }
1111 }
1112 
1113 
1114 // Contract - OperatorFilterer
1115 pragma solidity ^0.8.4;
1116 /**
1117  * @notice Optimized and flexible operator filterer to abide to OpenSea's
1118  * mandatory on-chain royalty enforcement in order for new collections to
1119  * receive royalties.
1120  * For more information, see:
1121  * See: https://github.com/ProjectOpenSea/operator-filter-registry
1122  */
1123 abstract contract OperatorFilterer {
1124     /// @dev The default OpenSea operator blocklist subscription.
1125     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1126 
1127     /// @dev The OpenSea operator filter registry.
1128     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
1129 
1130     /// @dev Registers the current contract to OpenSea's operator filter,
1131     /// and subscribe to the default OpenSea operator blocklist.
1132     /// Note: Will not revert nor update existing settings for repeated registration.
1133     function _registerForOperatorFiltering() internal virtual {
1134         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
1135     }
1136 
1137     /// @dev Registers the current contract to OpenSea's operator filter.
1138     /// Note: Will not revert nor update existing settings for repeated registration.
1139     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe)
1140         internal
1141         virtual
1142     {
1143         /// @solidity memory-safe-assembly
1144         assembly {
1145             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
1146 
1147             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
1148             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
1149 
1150             for {} iszero(subscribe) {} {
1151                 if iszero(subscriptionOrRegistrantToCopy) {
1152                     functionSelector := 0x4420e486 // `register(address)`.
1153                     break
1154                 }
1155                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
1156                 break
1157             }
1158             // Store the function selector.
1159             mstore(0x00, shl(224, functionSelector))
1160             // Store the `address(this)`.
1161             mstore(0x04, address())
1162             // Store the `subscriptionOrRegistrantToCopy`.
1163             mstore(0x24, subscriptionOrRegistrantToCopy)
1164             // Register into the registry.
1165             if iszero(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x04)) {
1166                 // If the function selector has not been overwritten,
1167                 // it is an out-of-gas error.
1168                 if eq(shr(224, mload(0x00)), functionSelector) {
1169                     // To prevent gas under-estimation.
1170                     revert(0, 0)
1171                 }
1172             }
1173             // Restore the part of the free memory pointer that was overwritten,
1174             // which is guaranteed to be zero, because of Solidity's memory size limits.
1175             mstore(0x24, 0)
1176         }
1177     }
1178 
1179     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
1180     modifier onlyAllowedOperator(address from) virtual {
1181         if (from != msg.sender) {
1182             if (!_isPriorityOperator(msg.sender)) {
1183                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
1184             }
1185         }
1186         _;
1187     }
1188 
1189     /// @dev Modifier to guard a function from approving a blocked operator..
1190     modifier onlyAllowedOperatorApproval(address operator) virtual {
1191         if (!_isPriorityOperator(operator)) {
1192             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
1193         }
1194         _;
1195     }
1196 
1197     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
1198     function _revertIfBlocked(address operator) private view {
1199         /// @solidity memory-safe-assembly
1200         assembly {
1201             // Store the function selector of `isOperatorAllowed(address,address)`,
1202             // shifted left by 6 bytes, which is enough for 8tb of memory.
1203             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
1204             mstore(0x00, 0xc6171134001122334455)
1205             // Store the `address(this)`.
1206             mstore(0x1a, address())
1207             // Store the `operator`.
1208             mstore(0x3a, operator)
1209 
1210             // `isOperatorAllowed` always returns true if it does not revert.
1211             if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
1212                 // Bubble up the revert if the staticcall reverts.
1213                 returndatacopy(0x00, 0x00, returndatasize())
1214                 revert(0x00, returndatasize())
1215             }
1216 
1217             // We'll skip checking if `from` is inside the blacklist.
1218             // Even though that can block transferring out of wrapper contracts,
1219             // we don't want tokens to be stuck.
1220 
1221             // Restore the part of the free memory pointer that was overwritten,
1222             // which is guaranteed to be zero, if less than 8tb of memory is used.
1223             mstore(0x3a, 0)
1224         }
1225     }
1226 
1227     /// @dev For deriving contracts to override, so that operator filtering
1228     /// can be turned on / off.
1229     /// Returns true by default.
1230     function _operatorFilteringEnabled() internal view virtual returns (bool) {
1231         return true;
1232     }
1233 
1234     /// @dev For deriving contracts to override, so that preferred marketplaces can
1235     /// skip operator filtering, helping users save gas.
1236     /// Returns false for all inputs by default.
1237     function _isPriorityOperator(address) internal view virtual returns (bool) {
1238         return false;
1239     }
1240 }
1241 
1242 
1243 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1244 pragma solidity ^0.8.0;
1245 /**
1246  * @dev Interface of the ERC165 standard, as defined in the
1247  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1248  *
1249  * Implementers can declare support of contract interfaces, which can then be
1250  * queried by others ({ERC165Checker}).
1251  *
1252  * For an implementation, see {ERC165}.
1253  */
1254 interface IERC165 {
1255     /**
1256      * @dev Returns true if this contract implements the interface defined by
1257      * `interfaceId`. See the corresponding
1258      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1259      * to learn more about how these ids are created.
1260      *
1261      * This function call must use less than 30 000 gas.
1262      */
1263     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1264 }
1265 
1266 
1267 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1268 pragma solidity ^0.8.0;
1269 /**
1270  * @dev Implementation of the {IERC165} interface.
1271  *
1272  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1273  * for the additional interface id that will be supported. For example:
1274  *
1275  * ```solidity
1276  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1277  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1278  * }
1279  * ```
1280  *
1281  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1282  */
1283 abstract contract ERC165 is IERC165 {
1284     /**
1285      * @dev See {IERC165-supportsInterface}.
1286      */
1287     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1288         return interfaceId == type(IERC165).interfaceId;
1289     }
1290 }
1291 
1292 
1293 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1294 pragma solidity ^0.8.0;
1295 /**
1296  * @dev Interface for the NFT Royalty Standard.
1297  *
1298  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1299  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1300  *
1301  * _Available since v4.5._
1302  */
1303 interface IERC2981 is IERC165 {
1304     /**
1305      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1306      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1307      */
1308     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1309         external
1310         view
1311         returns (address receiver, uint256 royaltyAmount);
1312 }
1313 
1314 
1315 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1316 pragma solidity ^0.8.0;
1317 /**
1318  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1319  *
1320  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1321  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1322  *
1323  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1324  * fee is specified in basis points by default.
1325  *
1326  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1327  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1328  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1329  *
1330  * _Available since v4.5._
1331  */
1332 abstract contract ERC2981 is IERC2981, ERC165 {
1333     struct RoyaltyInfo {
1334         address receiver;
1335         uint96 royaltyFraction;
1336     }
1337 
1338     RoyaltyInfo private _defaultRoyaltyInfo;
1339     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1340 
1341     /**
1342      * @dev See {IERC165-supportsInterface}.
1343      */
1344     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1345         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1346     }
1347 
1348     /**
1349      * @inheritdoc IERC2981
1350      */
1351     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1352         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1353 
1354         if (royalty.receiver == address(0)) {
1355             royalty = _defaultRoyaltyInfo;
1356         }
1357 
1358         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1359 
1360         return (royalty.receiver, royaltyAmount);
1361     }
1362 
1363     /**
1364      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1365      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1366      * override.
1367      */
1368     function _feeDenominator() internal pure virtual returns (uint96) {
1369         return 10000;
1370     }
1371 
1372     /**
1373      * @dev Sets the royalty information that all ids in this contract will default to.
1374      *
1375      * Requirements:
1376      *
1377      * - `receiver` cannot be the zero address.
1378      * - `feeNumerator` cannot be greater than the fee denominator.
1379      */
1380     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1381         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1382         require(receiver != address(0), "ERC2981: invalid receiver");
1383 
1384         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1385     }
1386 
1387     /**
1388      * @dev Removes default royalty information.
1389      */
1390     function _deleteDefaultRoyalty() internal virtual {
1391         delete _defaultRoyaltyInfo;
1392     }
1393 
1394     /**
1395      * @dev Sets the royalty information for a specific token id, overriding the global default.
1396      *
1397      * Requirements:
1398      *
1399      * - `receiver` cannot be the zero address.
1400      * - `feeNumerator` cannot be greater than the fee denominator.
1401      */
1402     function _setTokenRoyalty(
1403         uint256 tokenId,
1404         address receiver,
1405         uint96 feeNumerator
1406     ) internal virtual {
1407         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1408         require(receiver != address(0), "ERC2981: Invalid parameters");
1409 
1410         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1411     }
1412 
1413     /**
1414      * @dev Resets royalty information for the token id back to the global default.
1415      */
1416     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1417         delete _tokenRoyaltyInfo[tokenId];
1418     }
1419 }
1420 
1421 
1422 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1423 pragma solidity ^0.8.0;
1424 /**
1425  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1426  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1427  *
1428  * _Available since v3.1._
1429  */
1430 interface IERC1155 is IERC165 {
1431     /**
1432      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1433      */
1434     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1435 
1436     /**
1437      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1438      * transfers.
1439      */
1440     event TransferBatch(
1441         address indexed operator,
1442         address indexed from,
1443         address indexed to,
1444         uint256[] ids,
1445         uint256[] values
1446     );
1447 
1448     /**
1449      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1450      * `approved`.
1451      */
1452     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1453 
1454     /**
1455      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1456      *
1457      * If an {URI} event was emitted for `id`, the standard
1458      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1459      * returned by {IERC1155MetadataURI-uri}.
1460      */
1461     event URI(string value, uint256 indexed id);
1462 
1463     /**
1464      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1465      *
1466      * Requirements:
1467      *
1468      * - `account` cannot be the zero address.
1469      */
1470     function balanceOf(address account, uint256 id) external view returns (uint256);
1471 
1472     /**
1473      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1474      *
1475      * Requirements:
1476      *
1477      * - `accounts` and `ids` must have the same length.
1478      */
1479     function balanceOfBatch(
1480         address[] calldata accounts,
1481         uint256[] calldata ids
1482     ) external view returns (uint256[] memory);
1483 
1484     /**
1485      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1486      *
1487      * Emits an {ApprovalForAll} event.
1488      *
1489      * Requirements:
1490      *
1491      * - `operator` cannot be the caller.
1492      */
1493     function setApprovalForAll(address operator, bool approved) external;
1494 
1495     /**
1496      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1497      *
1498      * See {setApprovalForAll}.
1499      */
1500     function isApprovedForAll(address account, address operator) external view returns (bool);
1501 
1502     /**
1503      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1504      *
1505      * Emits a {TransferSingle} event.
1506      *
1507      * Requirements:
1508      *
1509      * - `to` cannot be the zero address.
1510      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1511      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1512      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1513      * acceptance magic value.
1514      */
1515     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
1516 
1517     /**
1518      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1519      *
1520      * Emits a {TransferBatch} event.
1521      *
1522      * Requirements:
1523      *
1524      * - `ids` and `amounts` must have the same length.
1525      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1526      * acceptance magic value.
1527      */
1528     function safeBatchTransferFrom(
1529         address from,
1530         address to,
1531         uint256[] calldata ids,
1532         uint256[] calldata amounts,
1533         bytes calldata data
1534     ) external;
1535 }
1536 
1537 
1538 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1539 pragma solidity ^0.8.0;
1540 /**
1541  * @dev _Available since v3.1._
1542  */
1543 interface IERC1155Receiver is IERC165 {
1544     /**
1545      * @dev Handles the receipt of a single ERC1155 token type. This function is
1546      * called at the end of a `safeTransferFrom` after the balance has been updated.
1547      *
1548      * NOTE: To accept the transfer, this must return
1549      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1550      * (i.e. 0xf23a6e61, or its own function selector).
1551      *
1552      * @param operator The address which initiated the transfer (i.e. msg.sender)
1553      * @param from The address which previously owned the token
1554      * @param id The ID of the token being transferred
1555      * @param value The amount of tokens being transferred
1556      * @param data Additional data with no specified format
1557      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1558      */
1559     function onERC1155Received(
1560         address operator,
1561         address from,
1562         uint256 id,
1563         uint256 value,
1564         bytes calldata data
1565     ) external returns (bytes4);
1566 
1567     /**
1568      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1569      * is called at the end of a `safeBatchTransferFrom` after the balances have
1570      * been updated.
1571      *
1572      * NOTE: To accept the transfer(s), this must return
1573      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1574      * (i.e. 0xbc197c81, or its own function selector).
1575      *
1576      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1577      * @param from The address which previously owned the token
1578      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1579      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1580      * @param data Additional data with no specified format
1581      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1582      */
1583     function onERC1155BatchReceived(
1584         address operator,
1585         address from,
1586         uint256[] calldata ids,
1587         uint256[] calldata values,
1588         bytes calldata data
1589     ) external returns (bytes4);
1590 }
1591 
1592 
1593 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1594 pragma solidity ^0.8.0;
1595 /**
1596  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1597  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1598  *
1599  * _Available since v3.1._
1600  */
1601 interface IERC1155MetadataURI is IERC1155 {
1602     /**
1603      * @dev Returns the URI for token type `id`.
1604      *
1605      * If the `\{id\}` substring is present in the URI, it must be replaced by
1606      * clients with the actual token type ID.
1607      */
1608     function uri(uint256 id) external view returns (string memory);
1609 }
1610 
1611 
1612 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)
1613 pragma solidity ^0.8.0;
1614 /**
1615  * @dev Implementation of the basic standard multi-token.
1616  * See https://eips.ethereum.org/EIPS/eip-1155
1617  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1618  *
1619  * _Available since v3.1._
1620  */
1621 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1622     using Address for address;
1623 
1624     // Mapping from token ID to account balances
1625     mapping(uint256 => mapping(address => uint256)) private _balances;
1626 
1627     // Mapping from account to operator approvals
1628     mapping(address => mapping(address => bool)) private _operatorApprovals;
1629 
1630     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1631     string private _uri;
1632 
1633     /**
1634      * @dev See {_setURI}.
1635      */
1636     constructor(string memory uri_) {
1637         _setURI(uri_);
1638     }
1639 
1640     /**
1641      * @dev See {IERC165-supportsInterface}.
1642      */
1643     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1644         return
1645             interfaceId == type(IERC1155).interfaceId ||
1646             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1647             super.supportsInterface(interfaceId);
1648     }
1649 
1650     /**
1651      * @dev See {IERC1155MetadataURI-uri}.
1652      *
1653      * This implementation returns the same URI for *all* token types. It relies
1654      * on the token type ID substitution mechanism
1655      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1656      *
1657      * Clients calling this function must replace the `\{id\}` substring with the
1658      * actual token type ID.
1659      */
1660     function uri(uint256) public view virtual override returns (string memory) {
1661         return _uri;
1662     }
1663 
1664     /**
1665      * @dev See {IERC1155-balanceOf}.
1666      *
1667      * Requirements:
1668      *
1669      * - `account` cannot be the zero address.
1670      */
1671     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1672         require(account != address(0), "ERC1155: address zero is not a valid owner");
1673         return _balances[id][account];
1674     }
1675 
1676     /**
1677      * @dev See {IERC1155-balanceOfBatch}.
1678      *
1679      * Requirements:
1680      *
1681      * - `accounts` and `ids` must have the same length.
1682      */
1683     function balanceOfBatch(
1684         address[] memory accounts,
1685         uint256[] memory ids
1686     ) public view virtual override returns (uint256[] memory) {
1687         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1688 
1689         uint256[] memory batchBalances = new uint256[](accounts.length);
1690 
1691         for (uint256 i = 0; i < accounts.length; ++i) {
1692             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1693         }
1694 
1695         return batchBalances;
1696     }
1697 
1698     /**
1699      * @dev See {IERC1155-setApprovalForAll}.
1700      */
1701     function setApprovalForAll(address operator, bool approved) public virtual override {
1702         _setApprovalForAll(_msgSender(), operator, approved);
1703     }
1704 
1705     /**
1706      * @dev See {IERC1155-isApprovedForAll}.
1707      */
1708     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1709         return _operatorApprovals[account][operator];
1710     }
1711 
1712     /**
1713      * @dev See {IERC1155-safeTransferFrom}.
1714      */
1715     function safeTransferFrom(
1716         address from,
1717         address to,
1718         uint256 id,
1719         uint256 amount,
1720         bytes memory data
1721     ) public virtual override {
1722         require(
1723             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1724             "ERC1155: caller is not token owner or approved"
1725         );
1726         _safeTransferFrom(from, to, id, amount, data);
1727     }
1728 
1729     /**
1730      * @dev See {IERC1155-safeBatchTransferFrom}.
1731      */
1732     function safeBatchTransferFrom(
1733         address from,
1734         address to,
1735         uint256[] memory ids,
1736         uint256[] memory amounts,
1737         bytes memory data
1738     ) public virtual override {
1739         require(
1740             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1741             "ERC1155: caller is not token owner or approved"
1742         );
1743         _safeBatchTransferFrom(from, to, ids, amounts, data);
1744     }
1745 
1746     /**
1747      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1748      *
1749      * Emits a {TransferSingle} event.
1750      *
1751      * Requirements:
1752      *
1753      * - `to` cannot be the zero address.
1754      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1755      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1756      * acceptance magic value.
1757      */
1758     function _safeTransferFrom(
1759         address from,
1760         address to,
1761         uint256 id,
1762         uint256 amount,
1763         bytes memory data
1764     ) internal virtual {
1765         require(to != address(0), "ERC1155: transfer to the zero address");
1766 
1767         address operator = _msgSender();
1768         uint256[] memory ids = _asSingletonArray(id);
1769         uint256[] memory amounts = _asSingletonArray(amount);
1770 
1771         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1772 
1773         uint256 fromBalance = _balances[id][from];
1774         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1775         unchecked {
1776             _balances[id][from] = fromBalance - amount;
1777         }
1778         _balances[id][to] += amount;
1779 
1780         emit TransferSingle(operator, from, to, id, amount);
1781 
1782         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1783 
1784         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1785     }
1786 
1787     /**
1788      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1789      *
1790      * Emits a {TransferBatch} event.
1791      *
1792      * Requirements:
1793      *
1794      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1795      * acceptance magic value.
1796      */
1797     function _safeBatchTransferFrom(
1798         address from,
1799         address to,
1800         uint256[] memory ids,
1801         uint256[] memory amounts,
1802         bytes memory data
1803     ) internal virtual {
1804         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1805         require(to != address(0), "ERC1155: transfer to the zero address");
1806 
1807         address operator = _msgSender();
1808 
1809         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1810 
1811         for (uint256 i = 0; i < ids.length; ++i) {
1812             uint256 id = ids[i];
1813             uint256 amount = amounts[i];
1814 
1815             uint256 fromBalance = _balances[id][from];
1816             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1817             unchecked {
1818                 _balances[id][from] = fromBalance - amount;
1819             }
1820             _balances[id][to] += amount;
1821         }
1822 
1823         emit TransferBatch(operator, from, to, ids, amounts);
1824 
1825         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1826 
1827         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1828     }
1829 
1830     /**
1831      * @dev Sets a new URI for all token types, by relying on the token type ID
1832      * substitution mechanism
1833      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1834      *
1835      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1836      * URI or any of the amounts in the JSON file at said URI will be replaced by
1837      * clients with the token type ID.
1838      *
1839      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1840      * interpreted by clients as
1841      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1842      * for token type ID 0x4cce0.
1843      *
1844      * See {uri}.
1845      *
1846      * Because these URIs cannot be meaningfully represented by the {URI} event,
1847      * this function emits no events.
1848      */
1849     function _setURI(string memory newuri) internal virtual {
1850         _uri = newuri;
1851     }
1852 
1853     /**
1854      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1855      *
1856      * Emits a {TransferSingle} event.
1857      *
1858      * Requirements:
1859      *
1860      * - `to` cannot be the zero address.
1861      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1862      * acceptance magic value.
1863      */
1864     function _mint(address to, uint256 id, uint256 amount, bytes memory data) internal virtual {
1865         require(to != address(0), "ERC1155: mint to the zero address");
1866 
1867         address operator = _msgSender();
1868         uint256[] memory ids = _asSingletonArray(id);
1869         uint256[] memory amounts = _asSingletonArray(amount);
1870 
1871         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1872 
1873         _balances[id][to] += amount;
1874         emit TransferSingle(operator, address(0), to, id, amount);
1875 
1876         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1877 
1878         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1879     }
1880 
1881     /**
1882      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1883      *
1884      * Emits a {TransferBatch} event.
1885      *
1886      * Requirements:
1887      *
1888      * - `ids` and `amounts` must have the same length.
1889      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1890      * acceptance magic value.
1891      */
1892     function _mintBatch(
1893         address to,
1894         uint256[] memory ids,
1895         uint256[] memory amounts,
1896         bytes memory data
1897     ) internal virtual {
1898         require(to != address(0), "ERC1155: mint to the zero address");
1899         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1900 
1901         address operator = _msgSender();
1902 
1903         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1904 
1905         for (uint256 i = 0; i < ids.length; i++) {
1906             _balances[ids[i]][to] += amounts[i];
1907         }
1908 
1909         emit TransferBatch(operator, address(0), to, ids, amounts);
1910 
1911         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1912 
1913         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1914     }
1915 
1916     /**
1917      * @dev Destroys `amount` tokens of token type `id` from `from`
1918      *
1919      * Emits a {TransferSingle} event.
1920      *
1921      * Requirements:
1922      *
1923      * - `from` cannot be the zero address.
1924      * - `from` must have at least `amount` tokens of token type `id`.
1925      */
1926     function _burn(address from, uint256 id, uint256 amount) internal virtual {
1927         require(from != address(0), "ERC1155: burn from the zero address");
1928 
1929         address operator = _msgSender();
1930         uint256[] memory ids = _asSingletonArray(id);
1931         uint256[] memory amounts = _asSingletonArray(amount);
1932 
1933         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1934 
1935         uint256 fromBalance = _balances[id][from];
1936         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1937         unchecked {
1938             _balances[id][from] = fromBalance - amount;
1939         }
1940 
1941         emit TransferSingle(operator, from, address(0), id, amount);
1942 
1943         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1944     }
1945 
1946     /**
1947      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1948      *
1949      * Emits a {TransferBatch} event.
1950      *
1951      * Requirements:
1952      *
1953      * - `ids` and `amounts` must have the same length.
1954      */
1955     function _burnBatch(address from, uint256[] memory ids, uint256[] memory amounts) internal virtual {
1956         require(from != address(0), "ERC1155: burn from the zero address");
1957         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1958 
1959         address operator = _msgSender();
1960 
1961         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1962 
1963         for (uint256 i = 0; i < ids.length; i++) {
1964             uint256 id = ids[i];
1965             uint256 amount = amounts[i];
1966 
1967             uint256 fromBalance = _balances[id][from];
1968             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1969             unchecked {
1970                 _balances[id][from] = fromBalance - amount;
1971             }
1972         }
1973 
1974         emit TransferBatch(operator, from, address(0), ids, amounts);
1975 
1976         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1977     }
1978 
1979     /**
1980      * @dev Approve `operator` to operate on all of `owner` tokens
1981      *
1982      * Emits an {ApprovalForAll} event.
1983      */
1984     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
1985         require(owner != operator, "ERC1155: setting approval status for self");
1986         _operatorApprovals[owner][operator] = approved;
1987         emit ApprovalForAll(owner, operator, approved);
1988     }
1989 
1990     /**
1991      * @dev Hook that is called before any token transfer. This includes minting
1992      * and burning, as well as batched variants.
1993      *
1994      * The same hook is called on both single and batched variants. For single
1995      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1996      *
1997      * Calling conditions (for each `id` and `amount` pair):
1998      *
1999      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2000      * of token type `id` will be  transferred to `to`.
2001      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2002      * for `to`.
2003      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2004      * will be burned.
2005      * - `from` and `to` are never both zero.
2006      * - `ids` and `amounts` have the same, non-zero length.
2007      *
2008      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2009      */
2010     function _beforeTokenTransfer(
2011         address operator,
2012         address from,
2013         address to,
2014         uint256[] memory ids,
2015         uint256[] memory amounts,
2016         bytes memory data
2017     ) internal virtual {}
2018 
2019     /**
2020      * @dev Hook that is called after any token transfer. This includes minting
2021      * and burning, as well as batched variants.
2022      *
2023      * The same hook is called on both single and batched variants. For single
2024      * transfers, the length of the `id` and `amount` arrays will be 1.
2025      *
2026      * Calling conditions (for each `id` and `amount` pair):
2027      *
2028      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2029      * of token type `id` will be  transferred to `to`.
2030      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2031      * for `to`.
2032      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2033      * will be burned.
2034      * - `from` and `to` are never both zero.
2035      * - `ids` and `amounts` have the same, non-zero length.
2036      *
2037      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2038      */
2039     function _afterTokenTransfer(
2040         address operator,
2041         address from,
2042         address to,
2043         uint256[] memory ids,
2044         uint256[] memory amounts,
2045         bytes memory data
2046     ) internal virtual {}
2047 
2048     function _doSafeTransferAcceptanceCheck(
2049         address operator,
2050         address from,
2051         address to,
2052         uint256 id,
2053         uint256 amount,
2054         bytes memory data
2055     ) private {
2056         if (to.isContract()) {
2057             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
2058                 if (response != IERC1155Receiver.onERC1155Received.selector) {
2059                     revert("ERC1155: ERC1155Receiver rejected tokens");
2060                 }
2061             } catch Error(string memory reason) {
2062                 revert(reason);
2063             } catch {
2064                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
2065             }
2066         }
2067     }
2068 
2069     function _doSafeBatchTransferAcceptanceCheck(
2070         address operator,
2071         address from,
2072         address to,
2073         uint256[] memory ids,
2074         uint256[] memory amounts,
2075         bytes memory data
2076     ) private {
2077         if (to.isContract()) {
2078             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
2079                 bytes4 response
2080             ) {
2081                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
2082                     revert("ERC1155: ERC1155Receiver rejected tokens");
2083                 }
2084             } catch Error(string memory reason) {
2085                 revert(reason);
2086             } catch {
2087                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
2088             }
2089         }
2090     }
2091 
2092     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
2093         uint256[] memory array = new uint256[](1);
2094         array[0] = element;
2095 
2096         return array;
2097     }
2098 
2099 }
2100 
2101 
2102 //- StreetMetlCratez implementation 
2103 interface ICRATEZ {
2104     function burnMint(address _recipient, uint256 _tokenID, uint256 _amount) external;
2105 }
2106 
2107 
2108 //- Contract - Street Melt Open Edition
2109 pragma solidity ^0.8.17;
2110 
2111 error InvalidEdition();
2112 error MintNotActive();
2113 error NotEnoughETH();
2114 error AlreadyClaimedFree();
2115 error AmountExceedFreeAmount();
2116 error InvalidMerkleProof();
2117 error BurnRecipeNotExists();
2118 error BurnNotActive();
2119 error InsufficientBalanceForBurn();
2120 error CrateRecipeNotExists();
2121 error EditionExists();
2122 error ArrayLengthMismatch();
2123 
2124 contract TheHeist is ERC1155, OperatorFilterer, Ownable, ERC2981, ReentrancyGuard {
2125     using Strings for uint256;
2126     bool public operatorFilteringEnabled;
2127 
2128     //- Contract Meta
2129     string public name = "Vandul Heist";
2130     string public symbol = "HEIST";
2131     string public contractMetaLink;
2132 
2133     //- TokenURI
2134     string private baseURI;
2135     string private baseExtension = ".json";
2136 
2137     //- Edition Maps
2138     struct EditionToken { uint mintPrice; bool isValid; bool mintActive; }
2139     mapping (uint256 => EditionToken) public validEdition;
2140 
2141     /** Holder Claim Settings */
2142     bytes32 public merkleRoot;
2143     mapping(uint => mapping(address => bool)) holderFreeClaim;
2144 
2145     /** Burn Settings */
2146     struct BurnRecipe {  uint[] editionTokens; mapping(uint256 => uint256) burnAmount; bool burnActive; }
2147     mapping(uint256 => BurnRecipe) editionBurnRecipe;
2148 
2149     /** Crates settings */
2150     ICRATEZ public crateContract;
2151     struct CrateRecipe { uint[] editionTokens; mapping(uint256 => uint256) burnAmount; bool burnActive; }
2152     mapping(uint256 => CrateRecipe) crateBurnRecipe;
2153 
2154     /** Events */
2155     bool public leftoverBurnActive = false;
2156     event BurnEdition (address user, uint token_id, uint amount);
2157 
2158     //-
2159     constructor(
2160         string memory _baseURI,
2161         string memory _contractMeta
2162     ) ERC1155(_baseURI) {
2163 
2164         //- Setting token settings
2165         contractMetaLink = _contractMeta;
2166         baseURI = _baseURI;
2167 
2168         //- Edition Setup
2169         EditionToken storage _edition = validEdition[1];
2170         _edition.isValid = true;
2171         _edition.mintPrice = 0.003 ether;
2172         _edition.mintActive = false;
2173 
2174         _mint(msg.sender, 1, 1, "");
2175 
2176         //- Operator Filter
2177         _registerForOperatorFiltering();
2178         operatorFilteringEnabled = true;
2179 
2180         //- Setting default royaly to 5%
2181         _setDefaultRoyalty(msg.sender, 500);
2182     }
2183 
2184     //- Mint Functions
2185     function airdrop(address[] memory _receiver, uint256 _token, uint256 _amount) public onlyOwner {
2186         EditionToken storage _edition = validEdition[_token];
2187         if(!_edition.isValid) revert InvalidEdition();
2188 
2189         for(uint i = 0; i < _receiver.length; i++) {
2190             _mint(_receiver[i], _token, _amount, "");
2191         }
2192     }
2193 
2194     function mint(uint256 _token, uint256 _amount, bytes32[] calldata _merkleProof) public payable nonReentrant {
2195 
2196         uint _finalAmount = _amount;
2197 
2198         EditionToken storage _edition = validEdition[_token];
2199 
2200         if(!_edition.isValid) revert InvalidEdition();
2201         if(!_edition.mintActive) revert MintNotActive();
2202 
2203         if(msg.value < _edition.mintPrice * _amount) revert NotEnoughETH();
2204 
2205         //- Free Claims
2206         if(!holderFreeClaim[_token][msg.sender]) {
2207             bytes1 _holder = 0x01;
2208             bytes1 _whitelist = 0x02;
2209 
2210             bytes32 holder = keccak256(abi.encodePacked(msg.sender, _holder));
2211             if(MerkleProof.verify(_merkleProof, merkleRoot, holder)) {
2212                 holderFreeClaim[_token][msg.sender] = true;
2213                 _finalAmount += 5;
2214             }
2215 
2216             bytes32 whitelist = keccak256(abi.encodePacked(msg.sender, _whitelist));
2217             if(MerkleProof.verify(_merkleProof, merkleRoot, whitelist)) {
2218                 holderFreeClaim[_token][msg.sender] = true;
2219                 _finalAmount += 2;
2220             }
2221         }
2222 
2223         //- Minting 
2224         _mint(msg.sender, _token, _finalAmount, "");
2225 
2226     }
2227 
2228     function burnAndMint(uint256 _token, uint256 _amount) public payable nonReentrant {
2229 
2230         BurnRecipe storage _recipe = editionBurnRecipe[_token];
2231 
2232         if(_recipe.editionTokens.length == 0) revert BurnRecipeNotExists();
2233         if(!_recipe.burnActive) revert BurnNotActive();
2234 
2235         for(uint i = 0; i < _recipe.editionTokens.length; i++) {
2236             uint _tokenID = _recipe.editionTokens[i];
2237             uint _burnAmount = _recipe.burnAmount[_tokenID] * _amount;
2238 
2239             if(balanceOf(msg.sender, _tokenID) < _burnAmount) revert InsufficientBalanceForBurn();
2240         }
2241 
2242         for(uint i = 0; i < _recipe.editionTokens.length; i++) {
2243             uint _tokenID = _recipe.editionTokens[i];
2244             uint _burnAmount = _recipe.burnAmount[_tokenID] * _amount;
2245 
2246             _burn(msg.sender, _tokenID, _burnAmount);
2247         }
2248 
2249         //- Minting
2250         _mint(msg.sender, _token, _amount, "");
2251 
2252     }
2253 
2254     function crateBurnMint(uint256 _token, uint256 _amount) public payable nonReentrant {
2255         CrateRecipe storage _recipe = crateBurnRecipe[_token];
2256 
2257         if(_recipe.editionTokens.length == 0) revert CrateRecipeNotExists();
2258         if(!_recipe.burnActive) revert BurnNotActive();
2259 
2260         for(uint i = 0; i < _recipe.editionTokens.length; i++) {
2261             uint _tokenID = _recipe.editionTokens[i];
2262             uint _burnAmount = _recipe.burnAmount[_tokenID] * _amount;
2263 
2264             if(balanceOf(msg.sender, _tokenID) < _burnAmount) revert InsufficientBalanceForBurn();
2265         }
2266 
2267         for(uint i = 0; i < _recipe.editionTokens.length; i++) {
2268             uint _tokenID = _recipe.editionTokens[i];
2269             uint _burnAmount = _recipe.burnAmount[_tokenID] * _amount;
2270 
2271             _burn(msg.sender, _tokenID, _burnAmount);
2272         }
2273 
2274         //- Minting
2275         crateContract.burnMint(msg.sender, _token, _amount);
2276     }
2277 
2278 
2279     //- Public Functions
2280     function uri(uint256 tokenID) public view override returns (string memory) {
2281         EditionToken memory _edition = validEdition[tokenID];
2282         if(!_edition.isValid) revert InvalidEdition();
2283         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenID.toString(), baseExtension)) : baseURI;
2284     }
2285 
2286 
2287     //- Edition Setting Update Functions
2288     function addValidEdition(uint _tokenID, uint _cost, bool _isActive) public onlyOwner {
2289         EditionToken storage _edition = validEdition[_tokenID];
2290         if(_edition.isValid) revert EditionExists();
2291 
2292         _edition.mintPrice = _cost;
2293         _edition.mintActive = _isActive;
2294 
2295         _mint(msg.sender, _tokenID, 1, "");
2296     }
2297 
2298     function setEditionMintPrice(uint _tokenID, uint _cost) public onlyOwner {
2299         EditionToken storage _edition = validEdition[_tokenID];
2300         if(!_edition.isValid) revert EditionExists();
2301 
2302         _edition.mintPrice = _cost;
2303     }
2304 
2305     function toggleEditionMint(uint _tokenID) public onlyOwner {
2306         EditionToken storage _edition = validEdition[_tokenID];
2307         if(!_edition.isValid) revert EditionExists();
2308 
2309         _edition.mintActive = !_edition.mintActive;
2310     }
2311 
2312 
2313     //- Edition Burn functions
2314     function setBurnRecipe(uint _tokenID, uint[] memory _editions, uint[] memory _amounts) public onlyOwner {
2315         if(_editions.length != _amounts.length) revert ArrayLengthMismatch();
2316 
2317         BurnRecipe storage _burnRecipe = editionBurnRecipe[_tokenID];
2318         _burnRecipe.editionTokens = _editions;
2319         _burnRecipe.burnActive = false;
2320 
2321         for(uint i = 0; i < _editions.length; i++) {
2322             _burnRecipe.burnAmount[_editions[i]] = _amounts[i];
2323         }
2324     }
2325 
2326     function toggleBurn(uint _tokenID) public onlyOwner {
2327         BurnRecipe storage _burnRecipe = editionBurnRecipe[_tokenID];
2328         if(_burnRecipe.editionTokens.length == 0) revert BurnRecipeNotExists();
2329         _burnRecipe.burnActive = !_burnRecipe.burnActive;
2330     }
2331 
2332 
2333     //- Leftover token Burn
2334     function burnLeftover(uint[] memory _tokenID, uint[] memory _amount) public nonReentrant {
2335         if(_tokenID.length != _amount.length) revert ArrayLengthMismatch();
2336         if(!leftoverBurnActive) revert BurnNotActive();
2337 
2338         for(uint i = 0; i < _tokenID.length; i++) {
2339 
2340             _burn(msg.sender, _tokenID[i], _amount[i]);
2341             emit BurnEdition(msg.sender, _tokenID[i], _amount[i]);
2342 
2343         }
2344     }
2345 
2346     function toggleLeftoverBurn() public onlyOwner {
2347         leftoverBurnActive = !leftoverBurnActive;
2348     }
2349 
2350 
2351     //- Crate Setting update functions
2352     function setCrateRecipe(uint _crateID, uint[] memory _editions, uint[] memory _amounts) public onlyOwner {
2353         if(_editions.length != _amounts.length) revert ArrayLengthMismatch();
2354 
2355         CrateRecipe storage _crateRecipe = crateBurnRecipe[_crateID];
2356         _crateRecipe.editionTokens = _editions;
2357         _crateRecipe.burnActive = false;
2358 
2359         for(uint i = 0; i < _editions.length; i++) {
2360             _crateRecipe.burnAmount[_editions[i]] = _amounts[i];
2361         }
2362     }
2363 
2364     function toggleCrateBurn(uint _crateID) public onlyOwner {
2365         CrateRecipe storage _recipe = crateBurnRecipe[_crateID];
2366         if(_recipe.editionTokens.length == 0) revert CrateRecipeNotExists();
2367         _recipe.burnActive = !_recipe.burnActive;
2368     }
2369 
2370 
2371     //- Only Owner
2372     function updateBaseURI(string memory _uri) external onlyOwner {
2373         baseURI = _uri;
2374     }
2375 
2376     function updateContractURI(string memory _uri) external onlyOwner {
2377         contractMetaLink = _uri;
2378     }
2379 
2380     function contractURI() public view returns (string memory) {
2381         return contractMetaLink;
2382     }
2383 
2384     function updateCrateContract(address _address) public onlyOwner {
2385         crateContract = ICRATEZ(_address);
2386     }
2387 
2388     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2389         merkleRoot = _merkleRoot;
2390     }
2391 
2392     function withdraw() public payable onlyOwner {
2393         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2394         require(success);
2395     }
2396 
2397 
2398     //- Operator Filter Registry
2399     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2400         super.setApprovalForAll(operator, approved);
2401     }
2402 
2403     function safeTransferFrom( address from, address to, uint256 tokenId, uint256 amount, bytes memory data ) public override onlyAllowedOperator(from) {
2404         super.safeTransferFrom(from, to, tokenId, amount, data);
2405     }
2406 
2407     function safeBatchTransferFrom( address from, address to, uint256[] memory ids, uint256[] memory amounts,  bytes memory data ) public override onlyAllowedOperator(from) {
2408         super.safeBatchTransferFrom(from, to, ids, amounts, data);
2409     }
2410 
2411     function supportsInterface(bytes4 interfaceId) public view virtual override (ERC1155, ERC2981) returns (bool) {
2412         return ERC1155.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
2413     }
2414 
2415     function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
2416         _setDefaultRoyalty(receiver, feeNumerator);
2417     }
2418 
2419     function setOperatorFilteringEnabled(bool value) public onlyOwner {
2420         operatorFilteringEnabled = value;
2421     }
2422 
2423     function _operatorFilteringEnabled() internal view override returns (bool) {
2424         return operatorFilteringEnabled;
2425     }
2426 
2427     function _isPriorityOperator(address operator) internal pure override returns (bool) {
2428         return operator == address(0x1E0049783F008A0085193E00003D00cd54003c71);
2429     }
2430 
2431 }