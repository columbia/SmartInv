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
228 // File: @openzeppelin/contracts/utils/Counters.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 /**
236  * @title Counters
237  * @author Matt Condon (@shrugs)
238  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
239  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
240  *
241  * Include with `using Counters for Counters.Counter;`
242  */
243 library Counters {
244     struct Counter {
245         // This variable should never be directly accessed by users of the library: interactions must be restricted to
246         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
247         // this feature: see https://github.com/ethereum/solidity/issues/4637
248         uint256 _value; // default: 0
249     }
250 
251     function current(Counter storage counter) internal view returns (uint256) {
252         return counter._value;
253     }
254 
255     function increment(Counter storage counter) internal {
256         unchecked {
257             counter._value += 1;
258         }
259     }
260 
261     function decrement(Counter storage counter) internal {
262         uint256 value = counter._value;
263         require(value > 0, "Counter: decrement overflow");
264         unchecked {
265             counter._value = value - 1;
266         }
267     }
268 
269     function reset(Counter storage counter) internal {
270         counter._value = 0;
271     }
272 }
273 
274 // File: @openzeppelin/contracts/utils/math/Math.sol
275 
276 
277 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
278 
279 pragma solidity ^0.8.0;
280 
281 /**
282  * @dev Standard math utilities missing in the Solidity language.
283  */
284 library Math {
285     enum Rounding {
286         Down, // Toward negative infinity
287         Up, // Toward infinity
288         Zero // Toward zero
289     }
290 
291     /**
292      * @dev Returns the largest of two numbers.
293      */
294     function max(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a > b ? a : b;
296     }
297 
298     /**
299      * @dev Returns the smallest of two numbers.
300      */
301     function min(uint256 a, uint256 b) internal pure returns (uint256) {
302         return a < b ? a : b;
303     }
304 
305     /**
306      * @dev Returns the average of two numbers. The result is rounded towards
307      * zero.
308      */
309     function average(uint256 a, uint256 b) internal pure returns (uint256) {
310         // (a + b) / 2 can overflow.
311         return (a & b) + (a ^ b) / 2;
312     }
313 
314     /**
315      * @dev Returns the ceiling of the division of two numbers.
316      *
317      * This differs from standard division with `/` in that it rounds up instead
318      * of rounding down.
319      */
320     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
321         // (a + b - 1) / b can overflow on addition, so we distribute.
322         return a == 0 ? 0 : (a - 1) / b + 1;
323     }
324 
325     /**
326      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
327      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
328      * with further edits by Uniswap Labs also under MIT license.
329      */
330     function mulDiv(
331         uint256 x,
332         uint256 y,
333         uint256 denominator
334     ) internal pure returns (uint256 result) {
335         unchecked {
336             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
337             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
338             // variables such that product = prod1 * 2^256 + prod0.
339             uint256 prod0; // Least significant 256 bits of the product
340             uint256 prod1; // Most significant 256 bits of the product
341             assembly {
342                 let mm := mulmod(x, y, not(0))
343                 prod0 := mul(x, y)
344                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
345             }
346 
347             // Handle non-overflow cases, 256 by 256 division.
348             if (prod1 == 0) {
349                 return prod0 / denominator;
350             }
351 
352             // Make sure the result is less than 2^256. Also prevents denominator == 0.
353             require(denominator > prod1);
354 
355             ///////////////////////////////////////////////
356             // 512 by 256 division.
357             ///////////////////////////////////////////////
358 
359             // Make division exact by subtracting the remainder from [prod1 prod0].
360             uint256 remainder;
361             assembly {
362                 // Compute remainder using mulmod.
363                 remainder := mulmod(x, y, denominator)
364 
365                 // Subtract 256 bit number from 512 bit number.
366                 prod1 := sub(prod1, gt(remainder, prod0))
367                 prod0 := sub(prod0, remainder)
368             }
369 
370             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
371             // See https://cs.stackexchange.com/q/138556/92363.
372 
373             // Does not overflow because the denominator cannot be zero at this stage in the function.
374             uint256 twos = denominator & (~denominator + 1);
375             assembly {
376                 // Divide denominator by twos.
377                 denominator := div(denominator, twos)
378 
379                 // Divide [prod1 prod0] by twos.
380                 prod0 := div(prod0, twos)
381 
382                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
383                 twos := add(div(sub(0, twos), twos), 1)
384             }
385 
386             // Shift in bits from prod1 into prod0.
387             prod0 |= prod1 * twos;
388 
389             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
390             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
391             // four bits. That is, denominator * inv = 1 mod 2^4.
392             uint256 inverse = (3 * denominator) ^ 2;
393 
394             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
395             // in modular arithmetic, doubling the correct bits in each step.
396             inverse *= 2 - denominator * inverse; // inverse mod 2^8
397             inverse *= 2 - denominator * inverse; // inverse mod 2^16
398             inverse *= 2 - denominator * inverse; // inverse mod 2^32
399             inverse *= 2 - denominator * inverse; // inverse mod 2^64
400             inverse *= 2 - denominator * inverse; // inverse mod 2^128
401             inverse *= 2 - denominator * inverse; // inverse mod 2^256
402 
403             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
404             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
405             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
406             // is no longer required.
407             result = prod0 * inverse;
408             return result;
409         }
410     }
411 
412     /**
413      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
414      */
415     function mulDiv(
416         uint256 x,
417         uint256 y,
418         uint256 denominator,
419         Rounding rounding
420     ) internal pure returns (uint256) {
421         uint256 result = mulDiv(x, y, denominator);
422         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
423             result += 1;
424         }
425         return result;
426     }
427 
428     /**
429      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
430      *
431      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
432      */
433     function sqrt(uint256 a) internal pure returns (uint256) {
434         if (a == 0) {
435             return 0;
436         }
437 
438         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
439         //
440         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
441         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
442         //
443         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
444         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
445         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
446         //
447         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
448         uint256 result = 1 << (log2(a) >> 1);
449 
450         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
451         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
452         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
453         // into the expected uint128 result.
454         unchecked {
455             result = (result + a / result) >> 1;
456             result = (result + a / result) >> 1;
457             result = (result + a / result) >> 1;
458             result = (result + a / result) >> 1;
459             result = (result + a / result) >> 1;
460             result = (result + a / result) >> 1;
461             result = (result + a / result) >> 1;
462             return min(result, a / result);
463         }
464     }
465 
466     /**
467      * @notice Calculates sqrt(a), following the selected rounding direction.
468      */
469     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
470         unchecked {
471             uint256 result = sqrt(a);
472             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
473         }
474     }
475 
476     /**
477      * @dev Return the log in base 2, rounded down, of a positive value.
478      * Returns 0 if given 0.
479      */
480     function log2(uint256 value) internal pure returns (uint256) {
481         uint256 result = 0;
482         unchecked {
483             if (value >> 128 > 0) {
484                 value >>= 128;
485                 result += 128;
486             }
487             if (value >> 64 > 0) {
488                 value >>= 64;
489                 result += 64;
490             }
491             if (value >> 32 > 0) {
492                 value >>= 32;
493                 result += 32;
494             }
495             if (value >> 16 > 0) {
496                 value >>= 16;
497                 result += 16;
498             }
499             if (value >> 8 > 0) {
500                 value >>= 8;
501                 result += 8;
502             }
503             if (value >> 4 > 0) {
504                 value >>= 4;
505                 result += 4;
506             }
507             if (value >> 2 > 0) {
508                 value >>= 2;
509                 result += 2;
510             }
511             if (value >> 1 > 0) {
512                 result += 1;
513             }
514         }
515         return result;
516     }
517 
518     /**
519      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
520      * Returns 0 if given 0.
521      */
522     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
523         unchecked {
524             uint256 result = log2(value);
525             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
526         }
527     }
528 
529     /**
530      * @dev Return the log in base 10, rounded down, of a positive value.
531      * Returns 0 if given 0.
532      */
533     function log10(uint256 value) internal pure returns (uint256) {
534         uint256 result = 0;
535         unchecked {
536             if (value >= 10**64) {
537                 value /= 10**64;
538                 result += 64;
539             }
540             if (value >= 10**32) {
541                 value /= 10**32;
542                 result += 32;
543             }
544             if (value >= 10**16) {
545                 value /= 10**16;
546                 result += 16;
547             }
548             if (value >= 10**8) {
549                 value /= 10**8;
550                 result += 8;
551             }
552             if (value >= 10**4) {
553                 value /= 10**4;
554                 result += 4;
555             }
556             if (value >= 10**2) {
557                 value /= 10**2;
558                 result += 2;
559             }
560             if (value >= 10**1) {
561                 result += 1;
562             }
563         }
564         return result;
565     }
566 
567     /**
568      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
569      * Returns 0 if given 0.
570      */
571     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
572         unchecked {
573             uint256 result = log10(value);
574             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
575         }
576     }
577 
578     /**
579      * @dev Return the log in base 256, rounded down, of a positive value.
580      * Returns 0 if given 0.
581      *
582      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
583      */
584     function log256(uint256 value) internal pure returns (uint256) {
585         uint256 result = 0;
586         unchecked {
587             if (value >> 128 > 0) {
588                 value >>= 128;
589                 result += 16;
590             }
591             if (value >> 64 > 0) {
592                 value >>= 64;
593                 result += 8;
594             }
595             if (value >> 32 > 0) {
596                 value >>= 32;
597                 result += 4;
598             }
599             if (value >> 16 > 0) {
600                 value >>= 16;
601                 result += 2;
602             }
603             if (value >> 8 > 0) {
604                 result += 1;
605             }
606         }
607         return result;
608     }
609 
610     /**
611      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
612      * Returns 0 if given 0.
613      */
614     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
615         unchecked {
616             uint256 result = log256(value);
617             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
618         }
619     }
620 }
621 
622 // File: @openzeppelin/contracts/utils/Strings.sol
623 
624 
625 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
626 
627 pragma solidity ^0.8.0;
628 
629 
630 /**
631  * @dev String operations.
632  */
633 library Strings {
634     bytes16 private constant _SYMBOLS = "0123456789abcdef";
635     uint8 private constant _ADDRESS_LENGTH = 20;
636 
637     /**
638      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
639      */
640     function toString(uint256 value) internal pure returns (string memory) {
641         unchecked {
642             uint256 length = Math.log10(value) + 1;
643             string memory buffer = new string(length);
644             uint256 ptr;
645             /// @solidity memory-safe-assembly
646             assembly {
647                 ptr := add(buffer, add(32, length))
648             }
649             while (true) {
650                 ptr--;
651                 /// @solidity memory-safe-assembly
652                 assembly {
653                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
654                 }
655                 value /= 10;
656                 if (value == 0) break;
657             }
658             return buffer;
659         }
660     }
661 
662     /**
663      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
664      */
665     function toHexString(uint256 value) internal pure returns (string memory) {
666         unchecked {
667             return toHexString(value, Math.log256(value) + 1);
668         }
669     }
670 
671     /**
672      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
673      */
674     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
675         bytes memory buffer = new bytes(2 * length + 2);
676         buffer[0] = "0";
677         buffer[1] = "x";
678         for (uint256 i = 2 * length + 1; i > 1; --i) {
679             buffer[i] = _SYMBOLS[value & 0xf];
680             value >>= 4;
681         }
682         require(value == 0, "Strings: hex length insufficient");
683         return string(buffer);
684     }
685 
686     /**
687      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
688      */
689     function toHexString(address addr) internal pure returns (string memory) {
690         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
691     }
692 }
693 
694 // File: @openzeppelin/contracts/utils/Context.sol
695 
696 
697 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 /**
702  * @dev Provides information about the current execution context, including the
703  * sender of the transaction and its data. While these are generally available
704  * via msg.sender and msg.data, they should not be accessed in such a direct
705  * manner, since when dealing with meta-transactions the account sending and
706  * paying for execution may not be the actual sender (as far as an application
707  * is concerned).
708  *
709  * This contract is only required for intermediate, library-like contracts.
710  */
711 abstract contract Context {
712     function _msgSender() internal view virtual returns (address) {
713         return msg.sender;
714     }
715 
716     function _msgData() internal view virtual returns (bytes calldata) {
717         return msg.data;
718     }
719 }
720 
721 // File: @openzeppelin/contracts/access/Ownable.sol
722 
723 
724 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 
729 /**
730  * @dev Contract module which provides a basic access control mechanism, where
731  * there is an account (an owner) that can be granted exclusive access to
732  * specific functions.
733  *
734  * By default, the owner account will be the one that deploys the contract. This
735  * can later be changed with {transferOwnership}.
736  *
737  * This module is used through inheritance. It will make available the modifier
738  * `onlyOwner`, which can be applied to your functions to restrict their use to
739  * the owner.
740  */
741 abstract contract Ownable is Context {
742     address private _owner;
743 
744     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
745 
746     /**
747      * @dev Initializes the contract setting the deployer as the initial owner.
748      */
749     constructor() {
750         _transferOwnership(_msgSender());
751     }
752 
753     /**
754      * @dev Throws if called by any account other than the owner.
755      */
756     modifier onlyOwner() {
757         _checkOwner();
758         _;
759     }
760 
761     /**
762      * @dev Returns the address of the current owner.
763      */
764     function owner() public view virtual returns (address) {
765         return _owner;
766     }
767 
768     /**
769      * @dev Throws if the sender is not the owner.
770      */
771     function _checkOwner() internal view virtual {
772         require(owner() == _msgSender(), "Ownable: caller is not the owner");
773     }
774 
775     /**
776      * @dev Leaves the contract without owner. It will not be possible to call
777      * `onlyOwner` functions anymore. Can only be called by the current owner.
778      *
779      * NOTE: Renouncing ownership will leave the contract without an owner,
780      * thereby removing any functionality that is only available to the owner.
781      */
782     function renounceOwnership() public virtual onlyOwner {
783         _transferOwnership(address(0));
784     }
785 
786     /**
787      * @dev Transfers ownership of the contract to a new account (`newOwner`).
788      * Can only be called by the current owner.
789      */
790     function transferOwnership(address newOwner) public virtual onlyOwner {
791         require(newOwner != address(0), "Ownable: new owner is the zero address");
792         _transferOwnership(newOwner);
793     }
794 
795     /**
796      * @dev Transfers ownership of the contract to a new account (`newOwner`).
797      * Internal function without access restriction.
798      */
799     function _transferOwnership(address newOwner) internal virtual {
800         address oldOwner = _owner;
801         _owner = newOwner;
802         emit OwnershipTransferred(oldOwner, newOwner);
803     }
804 }
805 
806 // File: @openzeppelin/contracts/utils/Address.sol
807 
808 
809 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
810 
811 pragma solidity ^0.8.1;
812 
813 /**
814  * @dev Collection of functions related to the address type
815  */
816 library Address {
817     /**
818      * @dev Returns true if `account` is a contract.
819      *
820      * [IMPORTANT]
821      * ====
822      * It is unsafe to assume that an address for which this function returns
823      * false is an externally-owned account (EOA) and not a contract.
824      *
825      * Among others, `isContract` will return false for the following
826      * types of addresses:
827      *
828      *  - an externally-owned account
829      *  - a contract in construction
830      *  - an address where a contract will be created
831      *  - an address where a contract lived, but was destroyed
832      * ====
833      *
834      * [IMPORTANT]
835      * ====
836      * You shouldn't rely on `isContract` to protect against flash loan attacks!
837      *
838      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
839      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
840      * constructor.
841      * ====
842      */
843     function isContract(address account) internal view returns (bool) {
844         // This method relies on extcodesize/address.code.length, which returns 0
845         // for contracts in construction, since the code is only stored at the end
846         // of the constructor execution.
847 
848         return account.code.length > 0;
849     }
850 
851     /**
852      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
853      * `recipient`, forwarding all available gas and reverting on errors.
854      *
855      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
856      * of certain opcodes, possibly making contracts go over the 2300 gas limit
857      * imposed by `transfer`, making them unable to receive funds via
858      * `transfer`. {sendValue} removes this limitation.
859      *
860      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
861      *
862      * IMPORTANT: because control is transferred to `recipient`, care must be
863      * taken to not create reentrancy vulnerabilities. Consider using
864      * {ReentrancyGuard} or the
865      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
866      */
867     function sendValue(address payable recipient, uint256 amount) internal {
868         require(address(this).balance >= amount, "Address: insufficient balance");
869 
870         (bool success, ) = recipient.call{value: amount}("");
871         require(success, "Address: unable to send value, recipient may have reverted");
872     }
873 
874     /**
875      * @dev Performs a Solidity function call using a low level `call`. A
876      * plain `call` is an unsafe replacement for a function call: use this
877      * function instead.
878      *
879      * If `target` reverts with a revert reason, it is bubbled up by this
880      * function (like regular Solidity function calls).
881      *
882      * Returns the raw returned data. To convert to the expected return value,
883      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
884      *
885      * Requirements:
886      *
887      * - `target` must be a contract.
888      * - calling `target` with `data` must not revert.
889      *
890      * _Available since v3.1._
891      */
892     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
893         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
894     }
895 
896     /**
897      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
898      * `errorMessage` as a fallback revert reason when `target` reverts.
899      *
900      * _Available since v3.1._
901      */
902     function functionCall(
903         address target,
904         bytes memory data,
905         string memory errorMessage
906     ) internal returns (bytes memory) {
907         return functionCallWithValue(target, data, 0, errorMessage);
908     }
909 
910     /**
911      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
912      * but also transferring `value` wei to `target`.
913      *
914      * Requirements:
915      *
916      * - the calling contract must have an ETH balance of at least `value`.
917      * - the called Solidity function must be `payable`.
918      *
919      * _Available since v3.1._
920      */
921     function functionCallWithValue(
922         address target,
923         bytes memory data,
924         uint256 value
925     ) internal returns (bytes memory) {
926         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
927     }
928 
929     /**
930      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
931      * with `errorMessage` as a fallback revert reason when `target` reverts.
932      *
933      * _Available since v3.1._
934      */
935     function functionCallWithValue(
936         address target,
937         bytes memory data,
938         uint256 value,
939         string memory errorMessage
940     ) internal returns (bytes memory) {
941         require(address(this).balance >= value, "Address: insufficient balance for call");
942         (bool success, bytes memory returndata) = target.call{value: value}(data);
943         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
944     }
945 
946     /**
947      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
948      * but performing a static call.
949      *
950      * _Available since v3.3._
951      */
952     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
953         return functionStaticCall(target, data, "Address: low-level static call failed");
954     }
955 
956     /**
957      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
958      * but performing a static call.
959      *
960      * _Available since v3.3._
961      */
962     function functionStaticCall(
963         address target,
964         bytes memory data,
965         string memory errorMessage
966     ) internal view returns (bytes memory) {
967         (bool success, bytes memory returndata) = target.staticcall(data);
968         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
969     }
970 
971     /**
972      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
973      * but performing a delegate call.
974      *
975      * _Available since v3.4._
976      */
977     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
978         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
979     }
980 
981     /**
982      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
983      * but performing a delegate call.
984      *
985      * _Available since v3.4._
986      */
987     function functionDelegateCall(
988         address target,
989         bytes memory data,
990         string memory errorMessage
991     ) internal returns (bytes memory) {
992         (bool success, bytes memory returndata) = target.delegatecall(data);
993         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
994     }
995 
996     /**
997      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
998      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
999      *
1000      * _Available since v4.8._
1001      */
1002     function verifyCallResultFromTarget(
1003         address target,
1004         bool success,
1005         bytes memory returndata,
1006         string memory errorMessage
1007     ) internal view returns (bytes memory) {
1008         if (success) {
1009             if (returndata.length == 0) {
1010                 // only check isContract if the call was successful and the return data is empty
1011                 // otherwise we already know that it was a contract
1012                 require(isContract(target), "Address: call to non-contract");
1013             }
1014             return returndata;
1015         } else {
1016             _revert(returndata, errorMessage);
1017         }
1018     }
1019 
1020     /**
1021      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1022      * revert reason or using the provided one.
1023      *
1024      * _Available since v4.3._
1025      */
1026     function verifyCallResult(
1027         bool success,
1028         bytes memory returndata,
1029         string memory errorMessage
1030     ) internal pure returns (bytes memory) {
1031         if (success) {
1032             return returndata;
1033         } else {
1034             _revert(returndata, errorMessage);
1035         }
1036     }
1037 
1038     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1039         // Look for revert reason and bubble it up if present
1040         if (returndata.length > 0) {
1041             // The easiest way to bubble the revert reason is using memory via assembly
1042             /// @solidity memory-safe-assembly
1043             assembly {
1044                 let returndata_size := mload(returndata)
1045                 revert(add(32, returndata), returndata_size)
1046             }
1047         } else {
1048             revert(errorMessage);
1049         }
1050     }
1051 }
1052 
1053 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1054 
1055 
1056 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1057 
1058 pragma solidity ^0.8.0;
1059 
1060 /**
1061  * @title ERC721 token receiver interface
1062  * @dev Interface for any contract that wants to support safeTransfers
1063  * from ERC721 asset contracts.
1064  */
1065 interface IERC721Receiver {
1066     /**
1067      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1068      * by `operator` from `from`, this function is called.
1069      *
1070      * It must return its Solidity selector to confirm the token transfer.
1071      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1072      *
1073      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1074      */
1075     function onERC721Received(
1076         address operator,
1077         address from,
1078         uint256 tokenId,
1079         bytes calldata data
1080     ) external returns (bytes4);
1081 }
1082 
1083 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1084 
1085 
1086 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1087 
1088 pragma solidity ^0.8.0;
1089 
1090 /**
1091  * @dev Interface of the ERC165 standard, as defined in the
1092  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1093  *
1094  * Implementers can declare support of contract interfaces, which can then be
1095  * queried by others ({ERC165Checker}).
1096  *
1097  * For an implementation, see {ERC165}.
1098  */
1099 interface IERC165 {
1100     /**
1101      * @dev Returns true if this contract implements the interface defined by
1102      * `interfaceId`. See the corresponding
1103      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1104      * to learn more about how these ids are created.
1105      *
1106      * This function call must use less than 30 000 gas.
1107      */
1108     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1109 }
1110 
1111 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1112 
1113 
1114 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1115 
1116 pragma solidity ^0.8.0;
1117 
1118 
1119 /**
1120  * @dev Implementation of the {IERC165} interface.
1121  *
1122  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1123  * for the additional interface id that will be supported. For example:
1124  *
1125  * ```solidity
1126  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1127  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1128  * }
1129  * ```
1130  *
1131  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1132  */
1133 abstract contract ERC165 is IERC165 {
1134     /**
1135      * @dev See {IERC165-supportsInterface}.
1136      */
1137     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1138         return interfaceId == type(IERC165).interfaceId;
1139     }
1140 }
1141 
1142 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1143 
1144 
1145 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 
1150 /**
1151  * @dev Required interface of an ERC721 compliant contract.
1152  */
1153 interface IERC721 is IERC165 {
1154     /**
1155      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1156      */
1157     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1158 
1159     /**
1160      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1161      */
1162     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1163 
1164     /**
1165      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1166      */
1167     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1168 
1169     /**
1170      * @dev Returns the number of tokens in ``owner``'s account.
1171      */
1172     function balanceOf(address owner) external view returns (uint256 balance);
1173 
1174     /**
1175      * @dev Returns the owner of the `tokenId` token.
1176      *
1177      * Requirements:
1178      *
1179      * - `tokenId` must exist.
1180      */
1181     function ownerOf(uint256 tokenId) external view returns (address owner);
1182 
1183     /**
1184      * @dev Safely transfers `tokenId` token from `from` to `to`.
1185      *
1186      * Requirements:
1187      *
1188      * - `from` cannot be the zero address.
1189      * - `to` cannot be the zero address.
1190      * - `tokenId` token must exist and be owned by `from`.
1191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function safeTransferFrom(
1197         address from,
1198         address to,
1199         uint256 tokenId,
1200         bytes calldata data
1201     ) external;
1202 
1203     /**
1204      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1205      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1206      *
1207      * Requirements:
1208      *
1209      * - `from` cannot be the zero address.
1210      * - `to` cannot be the zero address.
1211      * - `tokenId` token must exist and be owned by `from`.
1212      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1213      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function safeTransferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) external;
1222 
1223     /**
1224      * @dev Transfers `tokenId` token from `from` to `to`.
1225      *
1226      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1227      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1228      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1229      *
1230      * Requirements:
1231      *
1232      * - `from` cannot be the zero address.
1233      * - `to` cannot be the zero address.
1234      * - `tokenId` token must be owned by `from`.
1235      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function transferFrom(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) external;
1244 
1245     /**
1246      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1247      * The approval is cleared when the token is transferred.
1248      *
1249      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1250      *
1251      * Requirements:
1252      *
1253      * - The caller must own the token or be an approved operator.
1254      * - `tokenId` must exist.
1255      *
1256      * Emits an {Approval} event.
1257      */
1258     function approve(address to, uint256 tokenId) external;
1259 
1260     /**
1261      * @dev Approve or remove `operator` as an operator for the caller.
1262      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1263      *
1264      * Requirements:
1265      *
1266      * - The `operator` cannot be the caller.
1267      *
1268      * Emits an {ApprovalForAll} event.
1269      */
1270     function setApprovalForAll(address operator, bool _approved) external;
1271 
1272     /**
1273      * @dev Returns the account approved for `tokenId` token.
1274      *
1275      * Requirements:
1276      *
1277      * - `tokenId` must exist.
1278      */
1279     function getApproved(uint256 tokenId) external view returns (address operator);
1280 
1281     /**
1282      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1283      *
1284      * See {setApprovalForAll}
1285      */
1286     function isApprovedForAll(address owner, address operator) external view returns (bool);
1287 }
1288 
1289 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1290 
1291 
1292 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1293 
1294 pragma solidity ^0.8.0;
1295 
1296 
1297 /**
1298  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1299  * @dev See https://eips.ethereum.org/EIPS/eip-721
1300  */
1301 interface IERC721Enumerable is IERC721 {
1302     /**
1303      * @dev Returns the total amount of tokens stored by the contract.
1304      */
1305     function totalSupply() external view returns (uint256);
1306 
1307     /**
1308      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1309      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1310      */
1311     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1312 
1313     /**
1314      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1315      * Use along with {totalSupply} to enumerate all tokens.
1316      */
1317     function tokenByIndex(uint256 index) external view returns (uint256);
1318 }
1319 
1320 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1321 
1322 
1323 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1324 
1325 pragma solidity ^0.8.0;
1326 
1327 
1328 /**
1329  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1330  * @dev See https://eips.ethereum.org/EIPS/eip-721
1331  */
1332 interface IERC721Metadata is IERC721 {
1333     /**
1334      * @dev Returns the token collection name.
1335      */
1336     function name() external view returns (string memory);
1337 
1338     /**
1339      * @dev Returns the token collection symbol.
1340      */
1341     function symbol() external view returns (string memory);
1342 
1343     /**
1344      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1345      */
1346     function tokenURI(uint256 tokenId) external view returns (string memory);
1347 }
1348 
1349 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1350 
1351 
1352 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1353 
1354 pragma solidity ^0.8.0;
1355 
1356 
1357 
1358 
1359 
1360 
1361 
1362 
1363 /**
1364  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1365  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1366  * {ERC721Enumerable}.
1367  */
1368 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1369     using Address for address;
1370     using Strings for uint256;
1371 
1372     // Token name
1373     string private _name;
1374 
1375     // Token symbol
1376     string private _symbol;
1377 
1378     // Mapping from token ID to owner address
1379     mapping(uint256 => address) private _owners;
1380 
1381     // Mapping owner address to token count
1382     mapping(address => uint256) private _balances;
1383 
1384     // Mapping from token ID to approved address
1385     mapping(uint256 => address) private _tokenApprovals;
1386 
1387     // Mapping from owner to operator approvals
1388     mapping(address => mapping(address => bool)) private _operatorApprovals;
1389 
1390     /**
1391      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1392      */
1393     constructor(string memory name_, string memory symbol_) {
1394         _name = name_;
1395         _symbol = symbol_;
1396     }
1397 
1398     /**
1399      * @dev See {IERC165-supportsInterface}.
1400      */
1401     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1402         return
1403             interfaceId == type(IERC721).interfaceId ||
1404             interfaceId == type(IERC721Metadata).interfaceId ||
1405             super.supportsInterface(interfaceId);
1406     }
1407 
1408     /**
1409      * @dev See {IERC721-balanceOf}.
1410      */
1411     function balanceOf(address owner) public view virtual override returns (uint256) {
1412         require(owner != address(0), "ERC721: address zero is not a valid owner");
1413         return _balances[owner];
1414     }
1415 
1416     /**
1417      * @dev See {IERC721-ownerOf}.
1418      */
1419     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1420         address owner = _ownerOf(tokenId);
1421         require(owner != address(0), "ERC721: invalid token ID");
1422         return owner;
1423     }
1424 
1425     /**
1426      * @dev See {IERC721Metadata-name}.
1427      */
1428     function name() public view virtual override returns (string memory) {
1429         return _name;
1430     }
1431 
1432     /**
1433      * @dev See {IERC721Metadata-symbol}.
1434      */
1435     function symbol() public view virtual override returns (string memory) {
1436         return _symbol;
1437     }
1438 
1439     /**
1440      * @dev See {IERC721Metadata-tokenURI}.
1441      */
1442     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1443         _requireMinted(tokenId);
1444 
1445         string memory baseURI = _baseURI();
1446         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1447     }
1448 
1449     /**
1450      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1451      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1452      * by default, can be overridden in child contracts.
1453      */
1454     function _baseURI() internal view virtual returns (string memory) {
1455         return "";
1456     }
1457 
1458     /**
1459      * @dev See {IERC721-approve}.
1460      */
1461     function approve(address to, uint256 tokenId) public virtual override {
1462         address owner = ERC721.ownerOf(tokenId);
1463         require(to != owner, "ERC721: approval to current owner");
1464 
1465         require(
1466             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1467             "ERC721: approve caller is not token owner or approved for all"
1468         );
1469 
1470         _approve(to, tokenId);
1471     }
1472 
1473     /**
1474      * @dev See {IERC721-getApproved}.
1475      */
1476     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1477         _requireMinted(tokenId);
1478 
1479         return _tokenApprovals[tokenId];
1480     }
1481 
1482     /**
1483      * @dev See {IERC721-setApprovalForAll}.
1484      */
1485     function setApprovalForAll(address operator, bool approved) public virtual override {
1486         _setApprovalForAll(_msgSender(), operator, approved);
1487     }
1488 
1489     /**
1490      * @dev See {IERC721-isApprovedForAll}.
1491      */
1492     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1493         return _operatorApprovals[owner][operator];
1494     }
1495 
1496     /**
1497      * @dev See {IERC721-transferFrom}.
1498      */
1499     function transferFrom(
1500         address from,
1501         address to,
1502         uint256 tokenId
1503     ) public virtual override {
1504         //solhint-disable-next-line max-line-length
1505         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1506 
1507         _transfer(from, to, tokenId);
1508     }
1509 
1510     /**
1511      * @dev See {IERC721-safeTransferFrom}.
1512      */
1513     function safeTransferFrom(
1514         address from,
1515         address to,
1516         uint256 tokenId
1517     ) public virtual override {
1518         safeTransferFrom(from, to, tokenId, "");
1519     }
1520 
1521     /**
1522      * @dev See {IERC721-safeTransferFrom}.
1523      */
1524     function safeTransferFrom(
1525         address from,
1526         address to,
1527         uint256 tokenId,
1528         bytes memory data
1529     ) public virtual override {
1530         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1531         _safeTransfer(from, to, tokenId, data);
1532     }
1533 
1534     /**
1535      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1536      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1537      *
1538      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1539      *
1540      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1541      * implement alternative mechanisms to perform token transfer, such as signature-based.
1542      *
1543      * Requirements:
1544      *
1545      * - `from` cannot be the zero address.
1546      * - `to` cannot be the zero address.
1547      * - `tokenId` token must exist and be owned by `from`.
1548      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1549      *
1550      * Emits a {Transfer} event.
1551      */
1552     function _safeTransfer(
1553         address from,
1554         address to,
1555         uint256 tokenId,
1556         bytes memory data
1557     ) internal virtual {
1558         _transfer(from, to, tokenId);
1559         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1560     }
1561 
1562     /**
1563      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1564      */
1565     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1566         return _owners[tokenId];
1567     }
1568 
1569     /**
1570      * @dev Returns whether `tokenId` exists.
1571      *
1572      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1573      *
1574      * Tokens start existing when they are minted (`_mint`),
1575      * and stop existing when they are burned (`_burn`).
1576      */
1577     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1578         return _ownerOf(tokenId) != address(0);
1579     }
1580 
1581     /**
1582      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1583      *
1584      * Requirements:
1585      *
1586      * - `tokenId` must exist.
1587      */
1588     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1589         address owner = ERC721.ownerOf(tokenId);
1590         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1591     }
1592 
1593     /**
1594      * @dev Safely mints `tokenId` and transfers it to `to`.
1595      *
1596      * Requirements:
1597      *
1598      * - `tokenId` must not exist.
1599      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1600      *
1601      * Emits a {Transfer} event.
1602      */
1603     function _safeMint(address to, uint256 tokenId) internal virtual {
1604         _safeMint(to, tokenId, "");
1605     }
1606 
1607     /**
1608      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1609      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1610      */
1611     function _safeMint(
1612         address to,
1613         uint256 tokenId,
1614         bytes memory data
1615     ) internal virtual {
1616         _mint(to, tokenId);
1617         require(
1618             _checkOnERC721Received(address(0), to, tokenId, data),
1619             "ERC721: transfer to non ERC721Receiver implementer"
1620         );
1621     }
1622 
1623     /**
1624      * @dev Mints `tokenId` and transfers it to `to`.
1625      *
1626      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1627      *
1628      * Requirements:
1629      *
1630      * - `tokenId` must not exist.
1631      * - `to` cannot be the zero address.
1632      *
1633      * Emits a {Transfer} event.
1634      */
1635     function _mint(address to, uint256 tokenId) internal virtual {
1636         require(to != address(0), "ERC721: mint to the zero address");
1637         require(!_exists(tokenId), "ERC721: token already minted");
1638 
1639         _beforeTokenTransfer(address(0), to, tokenId, 1);
1640 
1641         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1642         require(!_exists(tokenId), "ERC721: token already minted");
1643 
1644         unchecked {
1645             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1646             // Given that tokens are minted one by one, it is impossible in practice that
1647             // this ever happens. Might change if we allow batch minting.
1648             // The ERC fails to describe this case.
1649             _balances[to] += 1;
1650         }
1651 
1652         _owners[tokenId] = to;
1653 
1654         emit Transfer(address(0), to, tokenId);
1655 
1656         _afterTokenTransfer(address(0), to, tokenId, 1);
1657     }
1658 
1659     /**
1660      * @dev Destroys `tokenId`.
1661      * The approval is cleared when the token is burned.
1662      * This is an internal function that does not check if the sender is authorized to operate on the token.
1663      *
1664      * Requirements:
1665      *
1666      * - `tokenId` must exist.
1667      *
1668      * Emits a {Transfer} event.
1669      */
1670     function _burn(uint256 tokenId) internal virtual {
1671         address owner = ERC721.ownerOf(tokenId);
1672 
1673         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1674 
1675         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1676         owner = ERC721.ownerOf(tokenId);
1677 
1678         // Clear approvals
1679         delete _tokenApprovals[tokenId];
1680 
1681         unchecked {
1682             // Cannot overflow, as that would require more tokens to be burned/transferred
1683             // out than the owner initially received through minting and transferring in.
1684             _balances[owner] -= 1;
1685         }
1686         delete _owners[tokenId];
1687 
1688         emit Transfer(owner, address(0), tokenId);
1689 
1690         _afterTokenTransfer(owner, address(0), tokenId, 1);
1691     }
1692 
1693     /**
1694      * @dev Transfers `tokenId` from `from` to `to`.
1695      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1696      *
1697      * Requirements:
1698      *
1699      * - `to` cannot be the zero address.
1700      * - `tokenId` token must be owned by `from`.
1701      *
1702      * Emits a {Transfer} event.
1703      */
1704     function _transfer(
1705         address from,
1706         address to,
1707         uint256 tokenId
1708     ) internal virtual {
1709         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1710         require(to != address(0), "ERC721: transfer to the zero address");
1711 
1712         _beforeTokenTransfer(from, to, tokenId, 1);
1713 
1714         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1715         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1716 
1717         // Clear approvals from the previous owner
1718         delete _tokenApprovals[tokenId];
1719 
1720         unchecked {
1721             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1722             // `from`'s balance is the number of token held, which is at least one before the current
1723             // transfer.
1724             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1725             // all 2**256 token ids to be minted, which in practice is impossible.
1726             _balances[from] -= 1;
1727             _balances[to] += 1;
1728         }
1729         _owners[tokenId] = to;
1730 
1731         emit Transfer(from, to, tokenId);
1732 
1733         _afterTokenTransfer(from, to, tokenId, 1);
1734     }
1735 
1736     /**
1737      * @dev Approve `to` to operate on `tokenId`
1738      *
1739      * Emits an {Approval} event.
1740      */
1741     function _approve(address to, uint256 tokenId) internal virtual {
1742         _tokenApprovals[tokenId] = to;
1743         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1744     }
1745 
1746     /**
1747      * @dev Approve `operator` to operate on all of `owner` tokens
1748      *
1749      * Emits an {ApprovalForAll} event.
1750      */
1751     function _setApprovalForAll(
1752         address owner,
1753         address operator,
1754         bool approved
1755     ) internal virtual {
1756         require(owner != operator, "ERC721: approve to caller");
1757         _operatorApprovals[owner][operator] = approved;
1758         emit ApprovalForAll(owner, operator, approved);
1759     }
1760 
1761     /**
1762      * @dev Reverts if the `tokenId` has not been minted yet.
1763      */
1764     function _requireMinted(uint256 tokenId) internal view virtual {
1765         require(_exists(tokenId), "ERC721: invalid token ID");
1766     }
1767 
1768     /**
1769      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1770      * The call is not executed if the target address is not a contract.
1771      *
1772      * @param from address representing the previous owner of the given token ID
1773      * @param to target address that will receive the tokens
1774      * @param tokenId uint256 ID of the token to be transferred
1775      * @param data bytes optional data to send along with the call
1776      * @return bool whether the call correctly returned the expected magic value
1777      */
1778     function _checkOnERC721Received(
1779         address from,
1780         address to,
1781         uint256 tokenId,
1782         bytes memory data
1783     ) private returns (bool) {
1784         if (to.isContract()) {
1785             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1786                 return retval == IERC721Receiver.onERC721Received.selector;
1787             } catch (bytes memory reason) {
1788                 if (reason.length == 0) {
1789                     revert("ERC721: transfer to non ERC721Receiver implementer");
1790                 } else {
1791                     /// @solidity memory-safe-assembly
1792                     assembly {
1793                         revert(add(32, reason), mload(reason))
1794                     }
1795                 }
1796             }
1797         } else {
1798             return true;
1799         }
1800     }
1801 
1802     /**
1803      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1804      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1805      *
1806      * Calling conditions:
1807      *
1808      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1809      * - When `from` is zero, the tokens will be minted for `to`.
1810      * - When `to` is zero, ``from``'s tokens will be burned.
1811      * - `from` and `to` are never both zero.
1812      * - `batchSize` is non-zero.
1813      *
1814      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1815      */
1816     function _beforeTokenTransfer(
1817         address from,
1818         address to,
1819         uint256, /* firstTokenId */
1820         uint256 batchSize
1821     ) internal virtual {
1822         if (batchSize > 1) {
1823             if (from != address(0)) {
1824                 _balances[from] -= batchSize;
1825             }
1826             if (to != address(0)) {
1827                 _balances[to] += batchSize;
1828             }
1829         }
1830     }
1831 
1832     /**
1833      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1834      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1835      *
1836      * Calling conditions:
1837      *
1838      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1839      * - When `from` is zero, the tokens were minted for `to`.
1840      * - When `to` is zero, ``from``'s tokens were burned.
1841      * - `from` and `to` are never both zero.
1842      * - `batchSize` is non-zero.
1843      *
1844      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1845      */
1846     function _afterTokenTransfer(
1847         address from,
1848         address to,
1849         uint256 firstTokenId,
1850         uint256 batchSize
1851     ) internal virtual {}
1852 }
1853 
1854 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1855 
1856 
1857 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1858 
1859 pragma solidity ^0.8.0;
1860 
1861 
1862 
1863 /**
1864  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1865  * enumerability of all the token ids in the contract as well as all token ids owned by each
1866  * account.
1867  */
1868 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1869     // Mapping from owner to list of owned token IDs
1870     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1871 
1872     // Mapping from token ID to index of the owner tokens list
1873     mapping(uint256 => uint256) private _ownedTokensIndex;
1874 
1875     // Array with all token ids, used for enumeration
1876     uint256[] private _allTokens;
1877 
1878     // Mapping from token id to position in the allTokens array
1879     mapping(uint256 => uint256) private _allTokensIndex;
1880 
1881     /**
1882      * @dev See {IERC165-supportsInterface}.
1883      */
1884     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1885         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1886     }
1887 
1888     /**
1889      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1890      */
1891     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1892         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1893         return _ownedTokens[owner][index];
1894     }
1895 
1896     /**
1897      * @dev See {IERC721Enumerable-totalSupply}.
1898      */
1899     function totalSupply() public view virtual override returns (uint256) {
1900         return _allTokens.length;
1901     }
1902 
1903     /**
1904      * @dev See {IERC721Enumerable-tokenByIndex}.
1905      */
1906     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1907         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1908         return _allTokens[index];
1909     }
1910 
1911     /**
1912      * @dev See {ERC721-_beforeTokenTransfer}.
1913      */
1914     function _beforeTokenTransfer(
1915         address from,
1916         address to,
1917         uint256 firstTokenId,
1918         uint256 batchSize
1919     ) internal virtual override {
1920         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1921 
1922         if (batchSize > 1) {
1923             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1924             revert("ERC721Enumerable: consecutive transfers not supported");
1925         }
1926 
1927         uint256 tokenId = firstTokenId;
1928 
1929         if (from == address(0)) {
1930             _addTokenToAllTokensEnumeration(tokenId);
1931         } else if (from != to) {
1932             _removeTokenFromOwnerEnumeration(from, tokenId);
1933         }
1934         if (to == address(0)) {
1935             _removeTokenFromAllTokensEnumeration(tokenId);
1936         } else if (to != from) {
1937             _addTokenToOwnerEnumeration(to, tokenId);
1938         }
1939     }
1940 
1941     /**
1942      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1943      * @param to address representing the new owner of the given token ID
1944      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1945      */
1946     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1947         uint256 length = ERC721.balanceOf(to);
1948         _ownedTokens[to][length] = tokenId;
1949         _ownedTokensIndex[tokenId] = length;
1950     }
1951 
1952     /**
1953      * @dev Private function to add a token to this extension's token tracking data structures.
1954      * @param tokenId uint256 ID of the token to be added to the tokens list
1955      */
1956     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1957         _allTokensIndex[tokenId] = _allTokens.length;
1958         _allTokens.push(tokenId);
1959     }
1960 
1961     /**
1962      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1963      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1964      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1965      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1966      * @param from address representing the previous owner of the given token ID
1967      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1968      */
1969     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1970         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1971         // then delete the last slot (swap and pop).
1972 
1973         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1974         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1975 
1976         // When the token to delete is the last token, the swap operation is unnecessary
1977         if (tokenIndex != lastTokenIndex) {
1978             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1979 
1980             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1981             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1982         }
1983 
1984         // This also deletes the contents at the last position of the array
1985         delete _ownedTokensIndex[tokenId];
1986         delete _ownedTokens[from][lastTokenIndex];
1987     }
1988 
1989     /**
1990      * @dev Private function to remove a token from this extension's token tracking data structures.
1991      * This has O(1) time complexity, but alters the order of the _allTokens array.
1992      * @param tokenId uint256 ID of the token to be removed from the tokens list
1993      */
1994     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1995         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1996         // then delete the last slot (swap and pop).
1997 
1998         uint256 lastTokenIndex = _allTokens.length - 1;
1999         uint256 tokenIndex = _allTokensIndex[tokenId];
2000 
2001         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2002         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2003         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2004         uint256 lastTokenId = _allTokens[lastTokenIndex];
2005 
2006         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2007         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2008 
2009         // This also deletes the contents at the last position of the array
2010         delete _allTokensIndex[tokenId];
2011         _allTokens.pop();
2012     }
2013 }
2014 
2015 // File: snake/SnakeNft.sol
2016 
2017 
2018 pragma solidity ^0.8.0;
2019 
2020 
2021 
2022 
2023 
2024 contract SnakeNft is ERC721Enumerable, Ownable {
2025     using Counters for Counters.Counter;
2026 
2027     uint256 public maxSupply = 3333;
2028     Counters.Counter private _tokenIdCounter;
2029 
2030     uint256 constant PERCENT_BASE = 10000;
2031 
2032     struct Period {
2033         uint256 endTime;
2034         uint256 price;
2035         uint256 limit;
2036         uint256 free;
2037         bool useWhitelist;
2038     }
2039     mapping(uint256 => Period) public periodList;
2040     uint256 public periodCount;
2041     mapping(uint256 => bytes32) public wlTreeRoots;
2042     mapping(uint256 => mapping(address => uint256)) public quotaUsed;
2043 
2044     uint256 public sideIdMin = 1;
2045     uint256 public sideIdMax = 2;
2046     struct NftInfo {
2047         address buyer;
2048         uint256 amount;
2049         uint256 tokenId;
2050         uint256 sideId;
2051         uint256 roundNum;
2052     }
2053     mapping(address => uint256[]) public buyList;
2054     mapping(uint256 => NftInfo) public nftList;
2055     mapping(uint256 => uint256[]) public airdropList;
2056     uint256 public soldCount;
2057     uint256 public soldAmount;
2058     uint256 public totalRewards;
2059 
2060     uint256 public gameRoundCycle = 60 * 60;
2061     uint256 public gameRoundInc = 25;
2062     mapping(uint256 => uint256) public rewardPoolIncDef;
2063     mapping(uint256 => uint256[]) public rewardPoolAllocDef;
2064 
2065     uint256 public roundNum = 0;
2066     uint256[] public winRounds;
2067     mapping(uint256 => uint256) public roundList;
2068     mapping(uint256 => uint256) public rewardPools;
2069     mapping(uint256 => mapping(uint256 => uint256)) public sideCounts;
2070     mapping(uint256 => uint256) public winners;
2071 
2072     mapping(address => uint256) public claimedRewards;
2073     mapping(address => uint256) public claimedNfts;
2074     bool public claimNftEnabled;
2075 
2076     event BuyNft(
2077         address indexed buyer,
2078         uint256 indexed sideId,
2079         uint256 indexed tokenId,
2080         uint256 amount,
2081         uint256 period,
2082         uint256 round
2083     );
2084     event Claim(address indexed buyer, uint256 amount);
2085     event ClaimNft(address indexed buyer, uint256 tokenId);
2086     event BatchMint(
2087         address indexed to,
2088         uint256 indexed sideId,
2089         uint256 indexed tokenId
2090     );
2091 
2092     constructor() ERC721("OROCHIVERSE", "ORO") {
2093         periodList[0] = Period(9999999999, 0, 0, 0, false);
2094         roundList[0] = 9999999999;
2095         rewardPoolIncDef[1] = 1000;
2096         rewardPoolIncDef[2] = 1200;
2097         rewardPoolAllocDef[1] = [3800, 2700, 1500, 2000];
2098         rewardPoolAllocDef[2] = [4500, 1500, 2000, 2000];
2099     }
2100 
2101     function setPeriod(
2102         uint256 startTime_,
2103         uint256[] memory endTimes_,
2104         uint256[] memory prices_,
2105         uint256[] memory limits_,
2106         uint256[] memory frees_,
2107         bool[] memory useWhitelists_
2108     ) external onlyOwner {
2109         require(
2110             endTimes_.length > 0 &&
2111                 endTimes_.length == prices_.length &&
2112                 endTimes_.length == limits_.length &&
2113                 endTimes_.length == frees_.length &&
2114                 endTimes_.length == useWhitelists_.length,
2115             "OROCHI: Invalid param length"
2116         );
2117         periodCount = endTimes_.length;
2118         periodList[0].endTime = startTime_;
2119         for (uint256 i = 0; i < periodCount; i++) {
2120             periodList[i + 1] = Period(
2121                 endTimes_[i],
2122                 prices_[i],
2123                 limits_[i],
2124                 frees_[i],
2125                 useWhitelists_[i]
2126             );
2127         }
2128         periodList[periodCount + 1] = Period(9999999999, 0, 0, 0, false);
2129         roundList[0] = startTime_;
2130     }
2131 
2132     function setWlTreeRoot(uint256 periodNum_, bytes32 wlTreeRoot_)
2133         external
2134         onlyOwner
2135     {
2136         require(
2137             periodNum_ > 0 && periodNum_ <= periodCount,
2138             "OROCHI: Invalid period number"
2139         );
2140         require(wlTreeRoot_ != 0, "OROCHI: Invalid tree root");
2141         wlTreeRoots[periodNum_] = wlTreeRoot_;
2142     }
2143 
2144     function setGame(
2145         uint256 gameRoundCycle_,
2146         uint256 gameRoundInc_,
2147         uint256[] memory rewardPoolIncDef_,
2148         uint256[][] memory rewardPoolAllocDef_
2149     ) external onlyOwner {
2150         require(
2151             gameRoundCycle_ > 0 &&
2152                 gameRoundInc_ > 0 &&
2153                 rewardPoolIncDef_.length == sideIdMax &&
2154                 rewardPoolAllocDef_.length == sideIdMax,
2155             "OROCHI: Zero time param or invalid param length"
2156         );
2157         for (uint256 i = 0; i < sideIdMax; i++) {
2158             require(
2159                 rewardPoolAllocDef_[i].length == sideIdMax + 2,
2160                 "OROCHI: Invalid alloc def length"
2161             );
2162             uint256 allocSum = 0;
2163             for (uint256 j = 0; j < rewardPoolAllocDef_[i].length; j++) {
2164                 allocSum += rewardPoolAllocDef_[i][j];
2165             }
2166             require(
2167                 allocSum == PERCENT_BASE,
2168                 "OROCHI: Invalid alloc def value"
2169             );
2170         }
2171         gameRoundCycle = gameRoundCycle_;
2172         gameRoundInc = gameRoundInc_;
2173         for (uint256 i = 0; i < sideIdMax; i++) {
2174             rewardPoolIncDef[i + 1] = rewardPoolIncDef_[i];
2175             rewardPoolAllocDef[i + 1] = rewardPoolAllocDef_[i];
2176         }
2177     }
2178 
2179     function setNftClaim(bool enabled) external onlyOwner {
2180         claimNftEnabled = enabled;
2181     }
2182 
2183     function validWhitelist(
2184         uint256 periodNum_,
2185         address buyer_,
2186         bytes32[] calldata wlProof_
2187     ) public view returns (bool) {
2188         require(
2189             periodNum_ > 0 && periodNum_ <= periodCount,
2190             "OROCHI: Invalid period"
2191         );
2192         require(
2193             periodList[periodNum_].useWhitelist,
2194             "OROCHI: Whitelist not valid in this period"
2195         );
2196         return
2197             MerkleProof.verify(
2198                 wlProof_,
2199                 wlTreeRoots[periodNum_],
2200                 keccak256(abi.encodePacked(buyer_))
2201             );
2202     }
2203 
2204     function buyNft(
2205         uint256 sideId_,
2206         uint256 count_,
2207         bytes32[] calldata wlProof_
2208     ) external payable {
2209         require(
2210             _tokenIdCounter.current() + count_ <= maxSupply,
2211             "OROCHI: Exceeds maximum supply"
2212         );
2213         uint256 periodNum = 0;
2214         for (; periodNum <= periodCount; periodNum++) {
2215             if (block.timestamp < periodList[periodNum].endTime) {
2216                 break;
2217             }
2218         }
2219         require(periodNum > 0, "OROCHI: Mint not start");
2220         require(periodNum <= periodCount, "OROCHI: Mint has ended");
2221         require(
2222             !periodList[periodNum].useWhitelist ||
2223                 validWhitelist(periodNum, msg.sender, wlProof_),
2224             "OROCHI: Not in whitelist"
2225         );
2226         require(
2227             sideId_ >= sideIdMin && sideId_ <= sideIdMax,
2228             "OROCHI: Choose your side"
2229         );
2230         require(count_ > 0, "OROCHI: Invalid count");
2231         require(
2232             quotaUsed[periodNum][msg.sender] + count_ <=
2233                 periodList[periodNum].limit,
2234             "OROCHI: Exceeded maximum purchase limit"
2235         );
2236         uint256 freeToPay = quotaUsed[periodNum][msg.sender] <
2237             periodList[periodNum].free
2238             ? Math.min(
2239                 periodList[periodNum].free - quotaUsed[periodNum][msg.sender],
2240                 count_
2241             )
2242             : 0;
2243         uint256 needToPay = count_ - freeToPay;
2244         // uint256 needToPay = quotaUsed[periodNum][msg.sender] + count_ >
2245         //     periodList[periodNum].free
2246         //     ? quotaUsed[periodNum][msg.sender] +
2247         //         count_ -
2248         //         Math.max(
2249         //             periodList[periodNum].free,
2250         //             quotaUsed[periodNum][msg.sender]
2251         //         )
2252         //     : 0;
2253         require(
2254             msg.value >= periodList[periodNum].price * needToPay,
2255             "OROCHI: Shortage of balance"
2256         );
2257         uint256 lastRoundNum = roundNum;
2258         for (; block.timestamp >= roundList[roundNum]; roundNum++) {
2259             roundList[roundNum + 1] = roundList[roundNum] + gameRoundCycle;
2260         }
2261         if (
2262             winRounds.length == 0 || winRounds[winRounds.length - 1] < roundNum
2263         ) {
2264             winRounds.push(roundNum);
2265         }
2266         quotaUsed[periodNum][msg.sender] += count_;
2267         require(
2268             quotaUsed[periodNum][msg.sender] <= periodList[periodNum].limit,
2269             "OROCHI: Exceeded maximum purchase limit"
2270         );
2271         roundList[roundNum] += count_ * gameRoundInc;
2272         if (winners[roundNum] == 0 && lastRoundNum > 0) {
2273             for (uint256 s = sideIdMin; s <= sideIdMax; s++) {
2274                 if (sideCounts[lastRoundNum][s] == 0) {
2275                     rewardPools[roundNum] +=
2276                         (rewardPools[lastRoundNum] *
2277                             rewardPoolAllocDef[
2278                                 nftList[winners[lastRoundNum]].sideId
2279                             ][s]) /
2280                         PERCENT_BASE;
2281                 }
2282             }
2283         }
2284         uint256 addedReward = (needToPay *
2285             periodList[periodNum].price *
2286             rewardPoolIncDef[sideId_]) / PERCENT_BASE;
2287         rewardPools[roundNum] += addedReward;
2288         totalRewards += addedReward;
2289         sideCounts[roundNum][sideId_] += count_;
2290         soldCount += count_;
2291         soldAmount += msg.value;
2292         for (uint256 i = 0; i < count_; i++) {
2293             _tokenIdCounter.increment();
2294             uint256 tokenId = _tokenIdCounter.current();
2295             require(tokenId <= maxSupply, "OROCHI: Exceeds maximum supply");
2296             uint256 amount = i < freeToPay ? 0 : periodList[periodNum].price;
2297             nftList[tokenId] = NftInfo(
2298                 msg.sender,
2299                 amount,
2300                 tokenId,
2301                 sideId_,
2302                 roundNum
2303             );
2304             airdropList[amount > 0 ? 1 : 2].push(tokenId);
2305             buyList[msg.sender].push(tokenId);
2306             winners[roundNum] = tokenId;
2307             emit BuyNft(
2308                 msg.sender,
2309                 sideId_,
2310                 tokenId,
2311                 amount,
2312                 periodNum,
2313                 roundNum
2314             );
2315         }
2316     }
2317 
2318     function myBought(address buyer_)
2319         public
2320         view
2321         returns (NftInfo[] memory myNfts)
2322     {
2323         myNfts = new NftInfo[](buyList[buyer_].length);
2324         for (uint256 i = 0; i < myNfts.length; i++) {
2325             myNfts[i] = nftList[buyList[buyer_][i]];
2326         }
2327     }
2328 
2329     function myRewards(address buyer_)
2330         public
2331         view
2332         returns (
2333             uint256 accReward,
2334             uint256 pastRoundReward,
2335             NftInfo memory pastRoundWinner
2336         )
2337     {
2338         uint256 pastRoundNum = roundNum;
2339         uint256 curEndTime = roundList[roundNum];
2340         while (block.timestamp >= curEndTime) {
2341             pastRoundNum++;
2342             curEndTime += gameRoundCycle;
2343             if (curEndTime >= periodList[periodCount].endTime) {
2344                 break;
2345             }
2346         }
2347         if (pastRoundNum > 0) {
2348             pastRoundNum -= 1;
2349         }
2350         for (uint256 i = 0; i < buyList[buyer_].length; i++) {
2351             NftInfo memory nftInfo = nftList[buyList[buyer_][i]];
2352             if (block.timestamp < roundList[nftInfo.roundNum]) {
2353                 break;
2354             }
2355             NftInfo memory winnerInfo = nftList[winners[nftInfo.roundNum]];
2356             uint256 reward = (rewardPools[nftInfo.roundNum] *
2357                 rewardPoolAllocDef[winnerInfo.sideId][nftInfo.sideId]) /
2358                 PERCENT_BASE /
2359                 sideCounts[nftInfo.roundNum][nftInfo.sideId];
2360             if (nftInfo.tokenId == winnerInfo.tokenId) {
2361                 reward +=
2362                     (rewardPools[nftInfo.roundNum] *
2363                         rewardPoolAllocDef[winnerInfo.sideId][0]) /
2364                     PERCENT_BASE;
2365             }
2366             accReward += reward;
2367             if (nftInfo.roundNum == pastRoundNum) {
2368                 pastRoundReward += reward;
2369                 pastRoundWinner = winnerInfo;
2370             }
2371         }
2372     }
2373 
2374     function getMintPeriod()
2375         public
2376         view
2377         returns (uint256 curPeriodNum, Period memory curPeriodInfo)
2378     {
2379         for (curPeriodNum = 0; curPeriodNum <= periodCount; curPeriodNum++) {
2380             if (block.timestamp < periodList[curPeriodNum].endTime) {
2381                 break;
2382             }
2383         }
2384         curPeriodInfo = periodList[curPeriodNum];
2385     }
2386 
2387     function getGameRound()
2388         public
2389         view
2390         returns (
2391             uint256 curRoundNum,
2392             uint256 curEndTime,
2393             uint256 curRewardPool,
2394             uint256[] memory curSideCounts
2395         )
2396     {
2397         curRoundNum = roundNum;
2398         curEndTime = roundList[curRoundNum];
2399         while (block.timestamp >= curEndTime) {
2400             curRoundNum++;
2401             curEndTime += gameRoundCycle;
2402             if (curEndTime >= periodList[periodCount].endTime) {
2403                 break;
2404             }
2405         }
2406         curRewardPool = rewardPools[curRoundNum];
2407         if (winners[curRoundNum] == 0 && roundNum > 0) {
2408             for (uint256 s = sideIdMin; s <= sideIdMax; s++) {
2409                 if (sideCounts[roundNum][s] == 0) {
2410                     curRewardPool +=
2411                         (rewardPools[roundNum] *
2412                             rewardPoolAllocDef[
2413                                 nftList[winners[roundNum]].sideId
2414                             ][s]) /
2415                         PERCENT_BASE;
2416                 }
2417             }
2418         }
2419         curSideCounts = new uint256[](sideIdMax);
2420         for (uint256 i = 0; i < sideIdMax; i++) {
2421             curSideCounts[i] = sideCounts[curRoundNum][i + 1];
2422         }
2423     }
2424 
2425     function getAllWinners()
2426         public
2427         view
2428         returns (NftInfo[] memory winnerInfos, uint256[] memory winnerRewards)
2429     {
2430         uint256 winRoundCount = winRounds.length;
2431         if (
2432             winRoundCount > 0 &&
2433             block.timestamp < roundList[winRounds[winRoundCount - 1]]
2434         ) {
2435             winRoundCount -= 1;
2436         }
2437         if (winRoundCount > 0) {
2438             winnerInfos = new NftInfo[](winRoundCount);
2439             winnerRewards = new uint256[](winRoundCount);
2440             for (uint256 i = 0; i < winRoundCount; i++) {
2441                 winnerInfos[i] = nftList[winners[winRounds[i]]];
2442                 for (
2443                     uint256 j = 0;
2444                     j < buyList[winnerInfos[i].buyer].length;
2445                     j++
2446                 ) {
2447                     NftInfo memory nftInfo = nftList[
2448                         buyList[winnerInfos[i].buyer][j]
2449                     ];
2450                     if (nftInfo.roundNum == winnerInfos[i].roundNum) {
2451                         winnerRewards[i] +=
2452                             (rewardPools[nftInfo.roundNum] *
2453                                 rewardPoolAllocDef[winnerInfos[i].sideId][
2454                                     nftInfo.sideId
2455                                 ]) /
2456                             PERCENT_BASE /
2457                             sideCounts[nftInfo.roundNum][nftInfo.sideId];
2458                         if (nftInfo.tokenId == winnerInfos[i].tokenId) {
2459                             winnerRewards[i] +=
2460                                 (rewardPools[nftInfo.roundNum] *
2461                                     rewardPoolAllocDef[winnerInfos[i].sideId][
2462                                         0
2463                                     ]) /
2464                                 PERCENT_BASE;
2465                         }
2466                     }
2467                 }
2468             }
2469         }
2470     }
2471 
2472     function getTreasury() public view returns (uint256 treasury) {
2473         for (uint256 i = 1; i <= roundNum; i++) {
2474             if (block.timestamp >= roundList[i] && winners[i] != 0) {
2475                 uint256[] memory rewardPoolAlloc = rewardPoolAllocDef[
2476                     nftList[winners[i]].sideId
2477                 ];
2478                 treasury +=
2479                     (rewardPools[i] *
2480                         rewardPoolAlloc[rewardPoolAlloc.length - 1]) /
2481                     PERCENT_BASE;
2482             }
2483         }
2484     }
2485 
2486     function claim() external {
2487         (uint256 accReward, , ) = myRewards(msg.sender);
2488         uint256 restRewards = accReward - claimedRewards[msg.sender];
2489         require(restRewards > 0, "OROCHI: Rewards balance is empty");
2490         claimedRewards[msg.sender] += restRewards;
2491         Address.sendValue(payable(msg.sender), restRewards);
2492         emit Claim(msg.sender, restRewards);
2493     }
2494 
2495     function claimNft() external returns (uint256 mintCount) {
2496         require(claimNftEnabled, "OROCHI: NFT claim not start");
2497         require(
2498             claimedNfts[msg.sender] < buyList[msg.sender].length,
2499             "OROCHI: Claim failed"
2500         );
2501         for (uint256 i = 0; i < buyList[msg.sender].length; i++) {
2502             uint256 tokenId = buyList[msg.sender][i];
2503             if (!_exists(tokenId)) {
2504                 _mint(msg.sender, tokenId);
2505                 emit ClaimNft(msg.sender, tokenId);
2506                 mintCount++;
2507             }
2508         }
2509         claimedNfts[msg.sender] += mintCount;
2510     }
2511 
2512     function airdrop(
2513         uint256 batchNum_,
2514         uint256 startIndex_,
2515         uint256 length_
2516     ) external onlyOwner returns (uint256 mintCount) {
2517         for (
2518             uint256 i = startIndex_;
2519             i < startIndex_ + length_ && i < airdropList[batchNum_].length;
2520             i++
2521         ) {
2522             uint256 tokenId = airdropList[batchNum_][i];
2523             if (!_exists(tokenId)) {
2524                 _mint(nftList[tokenId].buyer, tokenId);
2525                 mintCount++;
2526             }
2527         }
2528     }
2529 
2530     function withdrawEth(address to_, uint256 amount_) external onlyOwner {
2531         Address.sendValue(payable(to_), amount_);
2532     }
2533 
2534     function batchMint(address[] memory tos_, uint256 sideId_)
2535         public
2536         onlyOwner
2537     {
2538         require(
2539             _tokenIdCounter.current() + tos_.length <= maxSupply,
2540             "OROCHI: Exceeds maximum supply"
2541         );
2542         require(tos_.length > 0, "OROCHI: Invalid param length");
2543         require(
2544             sideId_ >= sideIdMin && sideId_ <= sideIdMax,
2545             "OROCHI: Invalid side"
2546         );
2547         for (uint256 i = 0; i < tos_.length; i++) {
2548             _tokenIdCounter.increment();
2549             uint256 tokenId = _tokenIdCounter.current();
2550             require(tokenId <= maxSupply, "OROCHI: Exceeds maximum supply");
2551             nftList[tokenId] = NftInfo(tos_[i], 0, tokenId, sideId_, 999999);
2552             _mint(tos_[i], tokenId);
2553             emit BatchMint(tos_[i], sideId_, tokenId);
2554         }
2555     }
2556 
2557     function batchMint(uint256 count_, uint256 sideId_) external onlyOwner {
2558         require(count_ > 0, "OROCHI: Invalid count");
2559         require(
2560             sideId_ >= sideIdMin && sideId_ <= sideIdMax,
2561             "OROCHI: Invalid side"
2562         );
2563         address[] memory tos = new address[](count_);
2564         for (uint256 i = 0; i < count_; i++) {
2565             tos[i] = msg.sender;
2566         }
2567         batchMint(tos, sideId_);
2568     }
2569 }