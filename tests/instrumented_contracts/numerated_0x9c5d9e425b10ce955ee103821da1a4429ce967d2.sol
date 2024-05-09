1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/math/Math.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Standard math utilities missing in the Solidity language.
12  */
13 library Math {
14     enum Rounding {
15         Down, // Toward negative infinity
16         Up, // Toward infinity
17         Zero // Toward zero
18     }
19 
20     /**
21      * @dev Returns the largest of two numbers.
22      */
23     function max(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a > b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the smallest of two numbers.
29      */
30     function min(uint256 a, uint256 b) internal pure returns (uint256) {
31         return a < b ? a : b;
32     }
33 
34     /**
35      * @dev Returns the average of two numbers. The result is rounded towards
36      * zero.
37      */
38     function average(uint256 a, uint256 b) internal pure returns (uint256) {
39         // (a + b) / 2 can overflow.
40         return (a & b) + (a ^ b) / 2;
41     }
42 
43     /**
44      * @dev Returns the ceiling of the division of two numbers.
45      *
46      * This differs from standard division with `/` in that it rounds up instead
47      * of rounding down.
48      */
49     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
50         // (a + b - 1) / b can overflow on addition, so we distribute.
51         return a == 0 ? 0 : (a - 1) / b + 1;
52     }
53 
54     /**
55      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
56      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
57      * with further edits by Uniswap Labs also under MIT license.
58      */
59     function mulDiv(
60         uint256 x,
61         uint256 y,
62         uint256 denominator
63     ) internal pure returns (uint256 result) {
64         unchecked {
65             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
66             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
67             // variables such that product = prod1 * 2^256 + prod0.
68             uint256 prod0; // Least significant 256 bits of the product
69             uint256 prod1; // Most significant 256 bits of the product
70             assembly {
71                 let mm := mulmod(x, y, not(0))
72                 prod0 := mul(x, y)
73                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
74             }
75 
76             // Handle non-overflow cases, 256 by 256 division.
77             if (prod1 == 0) {
78                 return prod0 / denominator;
79             }
80 
81             // Make sure the result is less than 2^256. Also prevents denominator == 0.
82             require(denominator > prod1);
83 
84             ///////////////////////////////////////////////
85             // 512 by 256 division.
86             ///////////////////////////////////////////////
87 
88             // Make division exact by subtracting the remainder from [prod1 prod0].
89             uint256 remainder;
90             assembly {
91                 // Compute remainder using mulmod.
92                 remainder := mulmod(x, y, denominator)
93 
94                 // Subtract 256 bit number from 512 bit number.
95                 prod1 := sub(prod1, gt(remainder, prod0))
96                 prod0 := sub(prod0, remainder)
97             }
98 
99             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
100             // See https://cs.stackexchange.com/q/138556/92363.
101 
102             // Does not overflow because the denominator cannot be zero at this stage in the function.
103             uint256 twos = denominator & (~denominator + 1);
104             assembly {
105                 // Divide denominator by twos.
106                 denominator := div(denominator, twos)
107 
108                 // Divide [prod1 prod0] by twos.
109                 prod0 := div(prod0, twos)
110 
111                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
112                 twos := add(div(sub(0, twos), twos), 1)
113             }
114 
115             // Shift in bits from prod1 into prod0.
116             prod0 |= prod1 * twos;
117 
118             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
119             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
120             // four bits. That is, denominator * inv = 1 mod 2^4.
121             uint256 inverse = (3 * denominator) ^ 2;
122 
123             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
124             // in modular arithmetic, doubling the correct bits in each step.
125             inverse *= 2 - denominator * inverse; // inverse mod 2^8
126             inverse *= 2 - denominator * inverse; // inverse mod 2^16
127             inverse *= 2 - denominator * inverse; // inverse mod 2^32
128             inverse *= 2 - denominator * inverse; // inverse mod 2^64
129             inverse *= 2 - denominator * inverse; // inverse mod 2^128
130             inverse *= 2 - denominator * inverse; // inverse mod 2^256
131 
132             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
133             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
134             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
135             // is no longer required.
136             result = prod0 * inverse;
137             return result;
138         }
139     }
140 
141     /**
142      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
143      */
144     function mulDiv(
145         uint256 x,
146         uint256 y,
147         uint256 denominator,
148         Rounding rounding
149     ) internal pure returns (uint256) {
150         uint256 result = mulDiv(x, y, denominator);
151         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
152             result += 1;
153         }
154         return result;
155     }
156 
157     /**
158      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
159      *
160      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
161      */
162     function sqrt(uint256 a) internal pure returns (uint256) {
163         if (a == 0) {
164             return 0;
165         }
166 
167         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
168         //
169         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
170         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
171         //
172         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
173         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
174         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
175         //
176         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
177         uint256 result = 1 << (log2(a) >> 1);
178 
179         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
180         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
181         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
182         // into the expected uint128 result.
183         unchecked {
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             result = (result + a / result) >> 1;
190             result = (result + a / result) >> 1;
191             return min(result, a / result);
192         }
193     }
194 
195     /**
196      * @notice Calculates sqrt(a), following the selected rounding direction.
197      */
198     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
199         unchecked {
200             uint256 result = sqrt(a);
201             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
202         }
203     }
204 
205     /**
206      * @dev Return the log in base 2, rounded down, of a positive value.
207      * Returns 0 if given 0.
208      */
209     function log2(uint256 value) internal pure returns (uint256) {
210         uint256 result = 0;
211         unchecked {
212             if (value >> 128 > 0) {
213                 value >>= 128;
214                 result += 128;
215             }
216             if (value >> 64 > 0) {
217                 value >>= 64;
218                 result += 64;
219             }
220             if (value >> 32 > 0) {
221                 value >>= 32;
222                 result += 32;
223             }
224             if (value >> 16 > 0) {
225                 value >>= 16;
226                 result += 16;
227             }
228             if (value >> 8 > 0) {
229                 value >>= 8;
230                 result += 8;
231             }
232             if (value >> 4 > 0) {
233                 value >>= 4;
234                 result += 4;
235             }
236             if (value >> 2 > 0) {
237                 value >>= 2;
238                 result += 2;
239             }
240             if (value >> 1 > 0) {
241                 result += 1;
242             }
243         }
244         return result;
245     }
246 
247     /**
248      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
249      * Returns 0 if given 0.
250      */
251     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
252         unchecked {
253             uint256 result = log2(value);
254             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
255         }
256     }
257 
258     /**
259      * @dev Return the log in base 10, rounded down, of a positive value.
260      * Returns 0 if given 0.
261      */
262     function log10(uint256 value) internal pure returns (uint256) {
263         uint256 result = 0;
264         unchecked {
265             if (value >= 10**64) {
266                 value /= 10**64;
267                 result += 64;
268             }
269             if (value >= 10**32) {
270                 value /= 10**32;
271                 result += 32;
272             }
273             if (value >= 10**16) {
274                 value /= 10**16;
275                 result += 16;
276             }
277             if (value >= 10**8) {
278                 value /= 10**8;
279                 result += 8;
280             }
281             if (value >= 10**4) {
282                 value /= 10**4;
283                 result += 4;
284             }
285             if (value >= 10**2) {
286                 value /= 10**2;
287                 result += 2;
288             }
289             if (value >= 10**1) {
290                 result += 1;
291             }
292         }
293         return result;
294     }
295 
296     /**
297      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
298      * Returns 0 if given 0.
299      */
300     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
301         unchecked {
302             uint256 result = log10(value);
303             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
304         }
305     }
306 
307     /**
308      * @dev Return the log in base 256, rounded down, of a positive value.
309      * Returns 0 if given 0.
310      *
311      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
312      */
313     function log256(uint256 value) internal pure returns (uint256) {
314         uint256 result = 0;
315         unchecked {
316             if (value >> 128 > 0) {
317                 value >>= 128;
318                 result += 16;
319             }
320             if (value >> 64 > 0) {
321                 value >>= 64;
322                 result += 8;
323             }
324             if (value >> 32 > 0) {
325                 value >>= 32;
326                 result += 4;
327             }
328             if (value >> 16 > 0) {
329                 value >>= 16;
330                 result += 2;
331             }
332             if (value >> 8 > 0) {
333                 result += 1;
334             }
335         }
336         return result;
337     }
338 
339     /**
340      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
341      * Returns 0 if given 0.
342      */
343     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
344         unchecked {
345             uint256 result = log256(value);
346             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
347         }
348     }
349 }
350 
351 // File: @openzeppelin/contracts/utils/Strings.sol
352 
353 
354 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 
359 /**
360  * @dev String operations.
361  */
362 library Strings {
363     bytes16 private constant _SYMBOLS = "0123456789abcdef";
364     uint8 private constant _ADDRESS_LENGTH = 20;
365 
366     /**
367      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
368      */
369     function toString(uint256 value) internal pure returns (string memory) {
370         unchecked {
371             uint256 length = Math.log10(value) + 1;
372             string memory buffer = new string(length);
373             uint256 ptr;
374             /// @solidity memory-safe-assembly
375             assembly {
376                 ptr := add(buffer, add(32, length))
377             }
378             while (true) {
379                 ptr--;
380                 /// @solidity memory-safe-assembly
381                 assembly {
382                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
383                 }
384                 value /= 10;
385                 if (value == 0) break;
386             }
387             return buffer;
388         }
389     }
390 
391     /**
392      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
393      */
394     function toHexString(uint256 value) internal pure returns (string memory) {
395         unchecked {
396             return toHexString(value, Math.log256(value) + 1);
397         }
398     }
399 
400     /**
401      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
402      */
403     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
404         bytes memory buffer = new bytes(2 * length + 2);
405         buffer[0] = "0";
406         buffer[1] = "x";
407         for (uint256 i = 2 * length + 1; i > 1; --i) {
408             buffer[i] = _SYMBOLS[value & 0xf];
409             value >>= 4;
410         }
411         require(value == 0, "Strings: hex length insufficient");
412         return string(buffer);
413     }
414 
415     /**
416      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
417      */
418     function toHexString(address addr) internal pure returns (string memory) {
419         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
420     }
421 }
422 
423 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
424 
425 
426 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Contract module that helps prevent reentrant calls to a function.
432  *
433  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
434  * available, which can be applied to functions to make sure there are no nested
435  * (reentrant) calls to them.
436  *
437  * Note that because there is a single `nonReentrant` guard, functions marked as
438  * `nonReentrant` may not call one another. This can be worked around by making
439  * those functions `private`, and then adding `external` `nonReentrant` entry
440  * points to them.
441  *
442  * TIP: If you would like to learn more about reentrancy and alternative ways
443  * to protect against it, check out our blog post
444  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
445  */
446 abstract contract ReentrancyGuard {
447     // Booleans are more expensive than uint256 or any type that takes up a full
448     // word because each write operation emits an extra SLOAD to first read the
449     // slot's contents, replace the bits taken up by the boolean, and then write
450     // back. This is the compiler's defense against contract upgrades and
451     // pointer aliasing, and it cannot be disabled.
452 
453     // The values being non-zero value makes deployment a bit more expensive,
454     // but in exchange the refund on every call to nonReentrant will be lower in
455     // amount. Since refunds are capped to a percentage of the total
456     // transaction's gas, it is best to keep them low in cases like this one, to
457     // increase the likelihood of the full refund coming into effect.
458     uint256 private constant _NOT_ENTERED = 1;
459     uint256 private constant _ENTERED = 2;
460 
461     uint256 private _status;
462 
463     constructor() {
464         _status = _NOT_ENTERED;
465     }
466 
467     /**
468      * @dev Prevents a contract from calling itself, directly or indirectly.
469      * Calling a `nonReentrant` function from another `nonReentrant`
470      * function is not supported. It is possible to prevent this from happening
471      * by making the `nonReentrant` function external, and making it call a
472      * `private` function that does the actual work.
473      */
474     modifier nonReentrant() {
475         _nonReentrantBefore();
476         _;
477         _nonReentrantAfter();
478     }
479 
480     function _nonReentrantBefore() private {
481         // On the first call to nonReentrant, _status will be _NOT_ENTERED
482         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
483 
484         // Any calls to nonReentrant after this point will fail
485         _status = _ENTERED;
486     }
487 
488     function _nonReentrantAfter() private {
489         // By storing the original value once again, a refund is triggered (see
490         // https://eips.ethereum.org/EIPS/eip-2200)
491         _status = _NOT_ENTERED;
492     }
493 }
494 
495 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
496 
497 
498 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev These functions deal with verification of Merkle Tree proofs.
504  *
505  * The tree and the proofs can be generated using our
506  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
507  * You will find a quickstart guide in the readme.
508  *
509  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
510  * hashing, or use a hash function other than keccak256 for hashing leaves.
511  * This is because the concatenation of a sorted pair of internal nodes in
512  * the merkle tree could be reinterpreted as a leaf value.
513  * OpenZeppelin's JavaScript library generates merkle trees that are safe
514  * against this attack out of the box.
515  */
516 library MerkleProof {
517     /**
518      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
519      * defined by `root`. For this, a `proof` must be provided, containing
520      * sibling hashes on the branch from the leaf to the root of the tree. Each
521      * pair of leaves and each pair of pre-images are assumed to be sorted.
522      */
523     function verify(
524         bytes32[] memory proof,
525         bytes32 root,
526         bytes32 leaf
527     ) internal pure returns (bool) {
528         return processProof(proof, leaf) == root;
529     }
530 
531     /**
532      * @dev Calldata version of {verify}
533      *
534      * _Available since v4.7._
535      */
536     function verifyCalldata(
537         bytes32[] calldata proof,
538         bytes32 root,
539         bytes32 leaf
540     ) internal pure returns (bool) {
541         return processProofCalldata(proof, leaf) == root;
542     }
543 
544     /**
545      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
546      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
547      * hash matches the root of the tree. When processing the proof, the pairs
548      * of leafs & pre-images are assumed to be sorted.
549      *
550      * _Available since v4.4._
551      */
552     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
553         bytes32 computedHash = leaf;
554         for (uint256 i = 0; i < proof.length; i++) {
555             computedHash = _hashPair(computedHash, proof[i]);
556         }
557         return computedHash;
558     }
559 
560     /**
561      * @dev Calldata version of {processProof}
562      *
563      * _Available since v4.7._
564      */
565     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
566         bytes32 computedHash = leaf;
567         for (uint256 i = 0; i < proof.length; i++) {
568             computedHash = _hashPair(computedHash, proof[i]);
569         }
570         return computedHash;
571     }
572 
573     /**
574      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
575      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
576      *
577      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
578      *
579      * _Available since v4.7._
580      */
581     function multiProofVerify(
582         bytes32[] memory proof,
583         bool[] memory proofFlags,
584         bytes32 root,
585         bytes32[] memory leaves
586     ) internal pure returns (bool) {
587         return processMultiProof(proof, proofFlags, leaves) == root;
588     }
589 
590     /**
591      * @dev Calldata version of {multiProofVerify}
592      *
593      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
594      *
595      * _Available since v4.7._
596      */
597     function multiProofVerifyCalldata(
598         bytes32[] calldata proof,
599         bool[] calldata proofFlags,
600         bytes32 root,
601         bytes32[] memory leaves
602     ) internal pure returns (bool) {
603         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
604     }
605 
606     /**
607      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
608      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
609      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
610      * respectively.
611      *
612      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
613      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
614      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
615      *
616      * _Available since v4.7._
617      */
618     function processMultiProof(
619         bytes32[] memory proof,
620         bool[] memory proofFlags,
621         bytes32[] memory leaves
622     ) internal pure returns (bytes32 merkleRoot) {
623         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
624         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
625         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
626         // the merkle tree.
627         uint256 leavesLen = leaves.length;
628         uint256 totalHashes = proofFlags.length;
629 
630         // Check proof validity.
631         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
632 
633         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
634         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
635         bytes32[] memory hashes = new bytes32[](totalHashes);
636         uint256 leafPos = 0;
637         uint256 hashPos = 0;
638         uint256 proofPos = 0;
639         // At each step, we compute the next hash using two values:
640         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
641         //   get the next hash.
642         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
643         //   `proof` array.
644         for (uint256 i = 0; i < totalHashes; i++) {
645             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
646             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
647             hashes[i] = _hashPair(a, b);
648         }
649 
650         if (totalHashes > 0) {
651             return hashes[totalHashes - 1];
652         } else if (leavesLen > 0) {
653             return leaves[0];
654         } else {
655             return proof[0];
656         }
657     }
658 
659     /**
660      * @dev Calldata version of {processMultiProof}.
661      *
662      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
663      *
664      * _Available since v4.7._
665      */
666     function processMultiProofCalldata(
667         bytes32[] calldata proof,
668         bool[] calldata proofFlags,
669         bytes32[] memory leaves
670     ) internal pure returns (bytes32 merkleRoot) {
671         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
672         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
673         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
674         // the merkle tree.
675         uint256 leavesLen = leaves.length;
676         uint256 totalHashes = proofFlags.length;
677 
678         // Check proof validity.
679         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
680 
681         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
682         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
683         bytes32[] memory hashes = new bytes32[](totalHashes);
684         uint256 leafPos = 0;
685         uint256 hashPos = 0;
686         uint256 proofPos = 0;
687         // At each step, we compute the next hash using two values:
688         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
689         //   get the next hash.
690         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
691         //   `proof` array.
692         for (uint256 i = 0; i < totalHashes; i++) {
693             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
694             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
695             hashes[i] = _hashPair(a, b);
696         }
697 
698         if (totalHashes > 0) {
699             return hashes[totalHashes - 1];
700         } else if (leavesLen > 0) {
701             return leaves[0];
702         } else {
703             return proof[0];
704         }
705     }
706 
707     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
708         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
709     }
710 
711     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
712         /// @solidity memory-safe-assembly
713         assembly {
714             mstore(0x00, a)
715             mstore(0x20, b)
716             value := keccak256(0x00, 0x40)
717         }
718     }
719 }
720 
721 // File: @openzeppelin/contracts/utils/Context.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 /**
729  * @dev Provides information about the current execution context, including the
730  * sender of the transaction and its data. While these are generally available
731  * via msg.sender and msg.data, they should not be accessed in such a direct
732  * manner, since when dealing with meta-transactions the account sending and
733  * paying for execution may not be the actual sender (as far as an application
734  * is concerned).
735  *
736  * This contract is only required for intermediate, library-like contracts.
737  */
738 abstract contract Context {
739     function _msgSender() internal view virtual returns (address) {
740         return msg.sender;
741     }
742 
743     function _msgData() internal view virtual returns (bytes calldata) {
744         return msg.data;
745     }
746 }
747 
748 // File: @openzeppelin/contracts/access/Ownable.sol
749 
750 
751 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
752 
753 pragma solidity ^0.8.0;
754 
755 
756 /**
757  * @dev Contract module which provides a basic access control mechanism, where
758  * there is an account (an owner) that can be granted exclusive access to
759  * specific functions.
760  *
761  * By default, the owner account will be the one that deploys the contract. This
762  * can later be changed with {transferOwnership}.
763  *
764  * This module is used through inheritance. It will make available the modifier
765  * `onlyOwner`, which can be applied to your functions to restrict their use to
766  * the owner.
767  */
768 abstract contract Ownable is Context {
769     address private _owner;
770 
771     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
772 
773     /**
774      * @dev Initializes the contract setting the deployer as the initial owner.
775      */
776     constructor() {
777         _transferOwnership(_msgSender());
778     }
779 
780     /**
781      * @dev Throws if called by any account other than the owner.
782      */
783     modifier onlyOwner() {
784         _checkOwner();
785         _;
786     }
787 
788     /**
789      * @dev Returns the address of the current owner.
790      */
791     function owner() public view virtual returns (address) {
792         return _owner;
793     }
794 
795     /**
796      * @dev Throws if the sender is not the owner.
797      */
798     function _checkOwner() internal view virtual {
799         require(owner() == _msgSender(), "Ownable: caller is not the owner");
800     }
801 
802     /**
803      * @dev Leaves the contract without owner. It will not be possible to call
804      * `onlyOwner` functions anymore. Can only be called by the current owner.
805      *
806      * NOTE: Renouncing ownership will leave the contract without an owner,
807      * thereby removing any functionality that is only available to the owner.
808      */
809     function renounceOwnership() public virtual onlyOwner {
810         _transferOwnership(address(0));
811     }
812 
813     /**
814      * @dev Transfers ownership of the contract to a new account (`newOwner`).
815      * Can only be called by the current owner.
816      */
817     function transferOwnership(address newOwner) public virtual onlyOwner {
818         require(newOwner != address(0), "Ownable: new owner is the zero address");
819         _transferOwnership(newOwner);
820     }
821 
822     /**
823      * @dev Transfers ownership of the contract to a new account (`newOwner`).
824      * Internal function without access restriction.
825      */
826     function _transferOwnership(address newOwner) internal virtual {
827         address oldOwner = _owner;
828         _owner = newOwner;
829         emit OwnershipTransferred(oldOwner, newOwner);
830     }
831 }
832 
833 // File: erc721a/contracts/IERC721A.sol
834 
835 
836 // ERC721A Contracts v4.2.3
837 // Creator: Chiru Labs
838 
839 pragma solidity ^0.8.4;
840 
841 /**
842  * @dev Interface of ERC721A.
843  */
844 interface IERC721A {
845     /**
846      * The caller must own the token or be an approved operator.
847      */
848     error ApprovalCallerNotOwnerNorApproved();
849 
850     /**
851      * The token does not exist.
852      */
853     error ApprovalQueryForNonexistentToken();
854 
855     /**
856      * Cannot query the balance for the zero address.
857      */
858     error BalanceQueryForZeroAddress();
859 
860     /**
861      * Cannot mint to the zero address.
862      */
863     error MintToZeroAddress();
864 
865     /**
866      * The quantity of tokens minted must be more than zero.
867      */
868     error MintZeroQuantity();
869 
870     /**
871      * The token does not exist.
872      */
873     error OwnerQueryForNonexistentToken();
874 
875     /**
876      * The caller must own the token or be an approved operator.
877      */
878     error TransferCallerNotOwnerNorApproved();
879 
880     /**
881      * The token must be owned by `from`.
882      */
883     error TransferFromIncorrectOwner();
884 
885     /**
886      * Cannot safely transfer to a contract that does not implement the
887      * ERC721Receiver interface.
888      */
889     error TransferToNonERC721ReceiverImplementer();
890 
891     /**
892      * Cannot transfer to the zero address.
893      */
894     error TransferToZeroAddress();
895 
896     /**
897      * The token does not exist.
898      */
899     error URIQueryForNonexistentToken();
900 
901     /**
902      * The `quantity` minted with ERC2309 exceeds the safety limit.
903      */
904     error MintERC2309QuantityExceedsLimit();
905 
906     /**
907      * The `extraData` cannot be set on an unintialized ownership slot.
908      */
909     error OwnershipNotInitializedForExtraData();
910 
911     // =============================================================
912     //                            STRUCTS
913     // =============================================================
914 
915     struct TokenOwnership {
916         // The address of the owner.
917         address addr;
918         // Stores the start time of ownership with minimal overhead for tokenomics.
919         uint64 startTimestamp;
920         // Whether the token has been burned.
921         bool burned;
922         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
923         uint24 extraData;
924     }
925 
926     // =============================================================
927     //                         TOKEN COUNTERS
928     // =============================================================
929 
930     /**
931      * @dev Returns the total number of tokens in existence.
932      * Burned tokens will reduce the count.
933      * To get the total number of tokens minted, please see {_totalMinted}.
934      */
935     function totalSupply() external view returns (uint256);
936 
937     // =============================================================
938     //                            IERC165
939     // =============================================================
940 
941     /**
942      * @dev Returns true if this contract implements the interface defined by
943      * `interfaceId`. See the corresponding
944      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
945      * to learn more about how these ids are created.
946      *
947      * This function call must use less than 30000 gas.
948      */
949     function supportsInterface(bytes4 interfaceId) external view returns (bool);
950 
951     // =============================================================
952     //                            IERC721
953     // =============================================================
954 
955     /**
956      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
957      */
958     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
959 
960     /**
961      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
962      */
963     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
964 
965     /**
966      * @dev Emitted when `owner` enables or disables
967      * (`approved`) `operator` to manage all of its assets.
968      */
969     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
970 
971     /**
972      * @dev Returns the number of tokens in `owner`'s account.
973      */
974     function balanceOf(address owner) external view returns (uint256 balance);
975 
976     /**
977      * @dev Returns the owner of the `tokenId` token.
978      *
979      * Requirements:
980      *
981      * - `tokenId` must exist.
982      */
983     function ownerOf(uint256 tokenId) external view returns (address owner);
984 
985     /**
986      * @dev Safely transfers `tokenId` token from `from` to `to`,
987      * checking first that contract recipients are aware of the ERC721 protocol
988      * to prevent tokens from being forever locked.
989      *
990      * Requirements:
991      *
992      * - `from` cannot be the zero address.
993      * - `to` cannot be the zero address.
994      * - `tokenId` token must exist and be owned by `from`.
995      * - If the caller is not `from`, it must be have been allowed to move
996      * this token by either {approve} or {setApprovalForAll}.
997      * - If `to` refers to a smart contract, it must implement
998      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function safeTransferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId,
1006         bytes calldata data
1007     ) external payable;
1008 
1009     /**
1010      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1011      */
1012     function safeTransferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) external payable;
1017 
1018     /**
1019      * @dev Transfers `tokenId` from `from` to `to`.
1020      *
1021      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1022      * whenever possible.
1023      *
1024      * Requirements:
1025      *
1026      * - `from` cannot be the zero address.
1027      * - `to` cannot be the zero address.
1028      * - `tokenId` token must be owned by `from`.
1029      * - If the caller is not `from`, it must be approved to move this token
1030      * by either {approve} or {setApprovalForAll}.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function transferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) external payable;
1039 
1040     /**
1041      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1042      * The approval is cleared when the token is transferred.
1043      *
1044      * Only a single account can be approved at a time, so approving the
1045      * zero address clears previous approvals.
1046      *
1047      * Requirements:
1048      *
1049      * - The caller must own the token or be an approved operator.
1050      * - `tokenId` must exist.
1051      *
1052      * Emits an {Approval} event.
1053      */
1054     function approve(address to, uint256 tokenId) external payable;
1055 
1056     /**
1057      * @dev Approve or remove `operator` as an operator for the caller.
1058      * Operators can call {transferFrom} or {safeTransferFrom}
1059      * for any token owned by the caller.
1060      *
1061      * Requirements:
1062      *
1063      * - The `operator` cannot be the caller.
1064      *
1065      * Emits an {ApprovalForAll} event.
1066      */
1067     function setApprovalForAll(address operator, bool _approved) external;
1068 
1069     /**
1070      * @dev Returns the account approved for `tokenId` token.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      */
1076     function getApproved(uint256 tokenId) external view returns (address operator);
1077 
1078     /**
1079      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1080      *
1081      * See {setApprovalForAll}.
1082      */
1083     function isApprovedForAll(address owner, address operator) external view returns (bool);
1084 
1085     // =============================================================
1086     //                        IERC721Metadata
1087     // =============================================================
1088 
1089     /**
1090      * @dev Returns the token collection name.
1091      */
1092     function name() external view returns (string memory);
1093 
1094     /**
1095      * @dev Returns the token collection symbol.
1096      */
1097     function symbol() external view returns (string memory);
1098 
1099     /**
1100      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1101      */
1102     function tokenURI(uint256 tokenId) external view returns (string memory);
1103 
1104     // =============================================================
1105     //                           IERC2309
1106     // =============================================================
1107 
1108     /**
1109      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1110      * (inclusive) is transferred from `from` to `to`, as defined in the
1111      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1112      *
1113      * See {_mintERC2309} for more details.
1114      */
1115     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1116 }
1117 
1118 // File: erc721a/contracts/ERC721A.sol
1119 
1120 
1121 // ERC721A Contracts v4.2.3
1122 // Creator: Chiru Labs
1123 
1124 pragma solidity ^0.8.4;
1125 
1126 
1127 /**
1128  * @dev Interface of ERC721 token receiver.
1129  */
1130 interface ERC721A__IERC721Receiver {
1131     function onERC721Received(
1132         address operator,
1133         address from,
1134         uint256 tokenId,
1135         bytes calldata data
1136     ) external returns (bytes4);
1137 }
1138 
1139 /**
1140  * @title ERC721A
1141  *
1142  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1143  * Non-Fungible Token Standard, including the Metadata extension.
1144  * Optimized for lower gas during batch mints.
1145  *
1146  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1147  * starting from `_startTokenId()`.
1148  *
1149  * Assumptions:
1150  *
1151  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1152  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1153  */
1154 contract ERC721A is IERC721A {
1155     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1156     struct TokenApprovalRef {
1157         address value;
1158     }
1159 
1160     // =============================================================
1161     //                           CONSTANTS
1162     // =============================================================
1163 
1164     // Mask of an entry in packed address data.
1165     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1166 
1167     // The bit position of `numberMinted` in packed address data.
1168     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1169 
1170     // The bit position of `numberBurned` in packed address data.
1171     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1172 
1173     // The bit position of `aux` in packed address data.
1174     uint256 private constant _BITPOS_AUX = 192;
1175 
1176     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1177     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1178 
1179     // The bit position of `startTimestamp` in packed ownership.
1180     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1181 
1182     // The bit mask of the `burned` bit in packed ownership.
1183     uint256 private constant _BITMASK_BURNED = 1 << 224;
1184 
1185     // The bit position of the `nextInitialized` bit in packed ownership.
1186     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1187 
1188     // The bit mask of the `nextInitialized` bit in packed ownership.
1189     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1190 
1191     // The bit position of `extraData` in packed ownership.
1192     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1193 
1194     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1195     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1196 
1197     // The mask of the lower 160 bits for addresses.
1198     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1199 
1200     // The maximum `quantity` that can be minted with {_mintERC2309}.
1201     // This limit is to prevent overflows on the address data entries.
1202     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1203     // is required to cause an overflow, which is unrealistic.
1204     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1205 
1206     // The `Transfer` event signature is given by:
1207     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1208     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1209         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1210 
1211     // =============================================================
1212     //                            STORAGE
1213     // =============================================================
1214 
1215     // The next token ID to be minted.
1216     uint256 private _currentIndex;
1217 
1218     // The number of tokens burned.
1219     uint256 private _burnCounter;
1220 
1221     // Token name
1222     string private _name;
1223 
1224     // Token symbol
1225     string private _symbol;
1226 
1227     // Mapping from token ID to ownership details
1228     // An empty struct value does not necessarily mean the token is unowned.
1229     // See {_packedOwnershipOf} implementation for details.
1230     //
1231     // Bits Layout:
1232     // - [0..159]   `addr`
1233     // - [160..223] `startTimestamp`
1234     // - [224]      `burned`
1235     // - [225]      `nextInitialized`
1236     // - [232..255] `extraData`
1237     mapping(uint256 => uint256) private _packedOwnerships;
1238 
1239     // Mapping owner address to address data.
1240     //
1241     // Bits Layout:
1242     // - [0..63]    `balance`
1243     // - [64..127]  `numberMinted`
1244     // - [128..191] `numberBurned`
1245     // - [192..255] `aux`
1246     mapping(address => uint256) private _packedAddressData;
1247 
1248     // Mapping from token ID to approved address.
1249     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1250 
1251     // Mapping from owner to operator approvals
1252     mapping(address => mapping(address => bool)) private _operatorApprovals;
1253 
1254     // =============================================================
1255     //                          CONSTRUCTOR
1256     // =============================================================
1257 
1258     constructor(string memory name_, string memory symbol_) {
1259         _name = name_;
1260         _symbol = symbol_;
1261         _currentIndex = _startTokenId();
1262     }
1263 
1264     // =============================================================
1265     //                   TOKEN COUNTING OPERATIONS
1266     // =============================================================
1267 
1268     /**
1269      * @dev Returns the starting token ID.
1270      * To change the starting token ID, please override this function.
1271      */
1272     function _startTokenId() internal view virtual returns (uint256) {
1273         return 0;
1274     }
1275 
1276     /**
1277      * @dev Returns the next token ID to be minted.
1278      */
1279     function _nextTokenId() internal view virtual returns (uint256) {
1280         return _currentIndex;
1281     }
1282 
1283     /**
1284      * @dev Returns the total number of tokens in existence.
1285      * Burned tokens will reduce the count.
1286      * To get the total number of tokens minted, please see {_totalMinted}.
1287      */
1288     function totalSupply() public view virtual override returns (uint256) {
1289         // Counter underflow is impossible as _burnCounter cannot be incremented
1290         // more than `_currentIndex - _startTokenId()` times.
1291         unchecked {
1292             return _currentIndex - _burnCounter - _startTokenId();
1293         }
1294     }
1295 
1296     /**
1297      * @dev Returns the total amount of tokens minted in the contract.
1298      */
1299     function _totalMinted() internal view virtual returns (uint256) {
1300         // Counter underflow is impossible as `_currentIndex` does not decrement,
1301         // and it is initialized to `_startTokenId()`.
1302         unchecked {
1303             return _currentIndex - _startTokenId();
1304         }
1305     }
1306 
1307     /**
1308      * @dev Returns the total number of tokens burned.
1309      */
1310     function _totalBurned() internal view virtual returns (uint256) {
1311         return _burnCounter;
1312     }
1313 
1314     // =============================================================
1315     //                    ADDRESS DATA OPERATIONS
1316     // =============================================================
1317 
1318     /**
1319      * @dev Returns the number of tokens in `owner`'s account.
1320      */
1321     function balanceOf(address owner) public view virtual override returns (uint256) {
1322         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1323         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1324     }
1325 
1326     /**
1327      * Returns the number of tokens minted by `owner`.
1328      */
1329     function _numberMinted(address owner) internal view returns (uint256) {
1330         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1331     }
1332 
1333     /**
1334      * Returns the number of tokens burned by or on behalf of `owner`.
1335      */
1336     function _numberBurned(address owner) internal view returns (uint256) {
1337         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1338     }
1339 
1340     /**
1341      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1342      */
1343     function _getAux(address owner) internal view returns (uint64) {
1344         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1345     }
1346 
1347     /**
1348      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1349      * If there are multiple variables, please pack them into a uint64.
1350      */
1351     function _setAux(address owner, uint64 aux) internal virtual {
1352         uint256 packed = _packedAddressData[owner];
1353         uint256 auxCasted;
1354         // Cast `aux` with assembly to avoid redundant masking.
1355         assembly {
1356             auxCasted := aux
1357         }
1358         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1359         _packedAddressData[owner] = packed;
1360     }
1361 
1362     // =============================================================
1363     //                            IERC165
1364     // =============================================================
1365 
1366     /**
1367      * @dev Returns true if this contract implements the interface defined by
1368      * `interfaceId`. See the corresponding
1369      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1370      * to learn more about how these ids are created.
1371      *
1372      * This function call must use less than 30000 gas.
1373      */
1374     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1375         // The interface IDs are constants representing the first 4 bytes
1376         // of the XOR of all function selectors in the interface.
1377         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1378         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1379         return
1380             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1381             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1382             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1383     }
1384 
1385     // =============================================================
1386     //                        IERC721Metadata
1387     // =============================================================
1388 
1389     /**
1390      * @dev Returns the token collection name.
1391      */
1392     function name() public view virtual override returns (string memory) {
1393         return _name;
1394     }
1395 
1396     /**
1397      * @dev Returns the token collection symbol.
1398      */
1399     function symbol() public view virtual override returns (string memory) {
1400         return _symbol;
1401     }
1402 
1403     /**
1404      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1405      */
1406     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1407         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1408 
1409         string memory baseURI = _baseURI();
1410         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1411     }
1412 
1413     /**
1414      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1415      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1416      * by default, it can be overridden in child contracts.
1417      */
1418     function _baseURI() internal view virtual returns (string memory) {
1419         return '';
1420     }
1421 
1422     // =============================================================
1423     //                     OWNERSHIPS OPERATIONS
1424     // =============================================================
1425 
1426     /**
1427      * @dev Returns the owner of the `tokenId` token.
1428      *
1429      * Requirements:
1430      *
1431      * - `tokenId` must exist.
1432      */
1433     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1434         return address(uint160(_packedOwnershipOf(tokenId)));
1435     }
1436 
1437     /**
1438      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1439      * It gradually moves to O(1) as tokens get transferred around over time.
1440      */
1441     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1442         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1443     }
1444 
1445     /**
1446      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1447      */
1448     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1449         return _unpackedOwnership(_packedOwnerships[index]);
1450     }
1451 
1452     /**
1453      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1454      */
1455     function _initializeOwnershipAt(uint256 index) internal virtual {
1456         if (_packedOwnerships[index] == 0) {
1457             _packedOwnerships[index] = _packedOwnershipOf(index);
1458         }
1459     }
1460 
1461     /**
1462      * Returns the packed ownership data of `tokenId`.
1463      */
1464     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1465         uint256 curr = tokenId;
1466 
1467         unchecked {
1468             if (_startTokenId() <= curr)
1469                 if (curr < _currentIndex) {
1470                     uint256 packed = _packedOwnerships[curr];
1471                     // If not burned.
1472                     if (packed & _BITMASK_BURNED == 0) {
1473                         // Invariant:
1474                         // There will always be an initialized ownership slot
1475                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1476                         // before an unintialized ownership slot
1477                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1478                         // Hence, `curr` will not underflow.
1479                         //
1480                         // We can directly compare the packed value.
1481                         // If the address is zero, packed will be zero.
1482                         while (packed == 0) {
1483                             packed = _packedOwnerships[--curr];
1484                         }
1485                         return packed;
1486                     }
1487                 }
1488         }
1489         revert OwnerQueryForNonexistentToken();
1490     }
1491 
1492     /**
1493      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1494      */
1495     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1496         ownership.addr = address(uint160(packed));
1497         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1498         ownership.burned = packed & _BITMASK_BURNED != 0;
1499         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1500     }
1501 
1502     /**
1503      * @dev Packs ownership data into a single uint256.
1504      */
1505     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1506         assembly {
1507             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1508             owner := and(owner, _BITMASK_ADDRESS)
1509             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1510             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1511         }
1512     }
1513 
1514     /**
1515      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1516      */
1517     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1518         // For branchless setting of the `nextInitialized` flag.
1519         assembly {
1520             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1521             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1522         }
1523     }
1524 
1525     // =============================================================
1526     //                      APPROVAL OPERATIONS
1527     // =============================================================
1528 
1529     /**
1530      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1531      * The approval is cleared when the token is transferred.
1532      *
1533      * Only a single account can be approved at a time, so approving the
1534      * zero address clears previous approvals.
1535      *
1536      * Requirements:
1537      *
1538      * - The caller must own the token or be an approved operator.
1539      * - `tokenId` must exist.
1540      *
1541      * Emits an {Approval} event.
1542      */
1543     function approve(address to, uint256 tokenId) public payable virtual override {
1544         address owner = ownerOf(tokenId);
1545 
1546         if (_msgSenderERC721A() != owner)
1547             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1548                 revert ApprovalCallerNotOwnerNorApproved();
1549             }
1550 
1551         _tokenApprovals[tokenId].value = to;
1552         emit Approval(owner, to, tokenId);
1553     }
1554 
1555     /**
1556      * @dev Returns the account approved for `tokenId` token.
1557      *
1558      * Requirements:
1559      *
1560      * - `tokenId` must exist.
1561      */
1562     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1563         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1564 
1565         return _tokenApprovals[tokenId].value;
1566     }
1567 
1568     /**
1569      * @dev Approve or remove `operator` as an operator for the caller.
1570      * Operators can call {transferFrom} or {safeTransferFrom}
1571      * for any token owned by the caller.
1572      *
1573      * Requirements:
1574      *
1575      * - The `operator` cannot be the caller.
1576      *
1577      * Emits an {ApprovalForAll} event.
1578      */
1579     function setApprovalForAll(address operator, bool approved) public virtual override {
1580         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1581         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1582     }
1583 
1584     /**
1585      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1586      *
1587      * See {setApprovalForAll}.
1588      */
1589     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1590         return _operatorApprovals[owner][operator];
1591     }
1592 
1593     /**
1594      * @dev Returns whether `tokenId` exists.
1595      *
1596      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1597      *
1598      * Tokens start existing when they are minted. See {_mint}.
1599      */
1600     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1601         return
1602             _startTokenId() <= tokenId &&
1603             tokenId < _currentIndex && // If within bounds,
1604             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1605     }
1606 
1607     /**
1608      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1609      */
1610     function _isSenderApprovedOrOwner(
1611         address approvedAddress,
1612         address owner,
1613         address msgSender
1614     ) private pure returns (bool result) {
1615         assembly {
1616             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1617             owner := and(owner, _BITMASK_ADDRESS)
1618             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1619             msgSender := and(msgSender, _BITMASK_ADDRESS)
1620             // `msgSender == owner || msgSender == approvedAddress`.
1621             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1622         }
1623     }
1624 
1625     /**
1626      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1627      */
1628     function _getApprovedSlotAndAddress(uint256 tokenId)
1629         private
1630         view
1631         returns (uint256 approvedAddressSlot, address approvedAddress)
1632     {
1633         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1634         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1635         assembly {
1636             approvedAddressSlot := tokenApproval.slot
1637             approvedAddress := sload(approvedAddressSlot)
1638         }
1639     }
1640 
1641     // =============================================================
1642     //                      TRANSFER OPERATIONS
1643     // =============================================================
1644 
1645     /**
1646      * @dev Transfers `tokenId` from `from` to `to`.
1647      *
1648      * Requirements:
1649      *
1650      * - `from` cannot be the zero address.
1651      * - `to` cannot be the zero address.
1652      * - `tokenId` token must be owned by `from`.
1653      * - If the caller is not `from`, it must be approved to move this token
1654      * by either {approve} or {setApprovalForAll}.
1655      *
1656      * Emits a {Transfer} event.
1657      */
1658     function transferFrom(
1659         address from,
1660         address to,
1661         uint256 tokenId
1662     ) public payable virtual override {
1663         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1664 
1665         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1666 
1667         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1668 
1669         // The nested ifs save around 20+ gas over a compound boolean condition.
1670         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1671             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1672 
1673         if (to == address(0)) revert TransferToZeroAddress();
1674 
1675         _beforeTokenTransfers(from, to, tokenId, 1);
1676 
1677         // Clear approvals from the previous owner.
1678         assembly {
1679             if approvedAddress {
1680                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1681                 sstore(approvedAddressSlot, 0)
1682             }
1683         }
1684 
1685         // Underflow of the sender's balance is impossible because we check for
1686         // ownership above and the recipient's balance can't realistically overflow.
1687         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1688         unchecked {
1689             // We can directly increment and decrement the balances.
1690             --_packedAddressData[from]; // Updates: `balance -= 1`.
1691             ++_packedAddressData[to]; // Updates: `balance += 1`.
1692 
1693             // Updates:
1694             // - `address` to the next owner.
1695             // - `startTimestamp` to the timestamp of transfering.
1696             // - `burned` to `false`.
1697             // - `nextInitialized` to `true`.
1698             _packedOwnerships[tokenId] = _packOwnershipData(
1699                 to,
1700                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1701             );
1702 
1703             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1704             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1705                 uint256 nextTokenId = tokenId + 1;
1706                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1707                 if (_packedOwnerships[nextTokenId] == 0) {
1708                     // If the next slot is within bounds.
1709                     if (nextTokenId != _currentIndex) {
1710                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1711                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1712                     }
1713                 }
1714             }
1715         }
1716 
1717         emit Transfer(from, to, tokenId);
1718         _afterTokenTransfers(from, to, tokenId, 1);
1719     }
1720 
1721     /**
1722      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1723      */
1724     function safeTransferFrom(
1725         address from,
1726         address to,
1727         uint256 tokenId
1728     ) public payable virtual override {
1729         safeTransferFrom(from, to, tokenId, '');
1730     }
1731 
1732     /**
1733      * @dev Safely transfers `tokenId` token from `from` to `to`.
1734      *
1735      * Requirements:
1736      *
1737      * - `from` cannot be the zero address.
1738      * - `to` cannot be the zero address.
1739      * - `tokenId` token must exist and be owned by `from`.
1740      * - If the caller is not `from`, it must be approved to move this token
1741      * by either {approve} or {setApprovalForAll}.
1742      * - If `to` refers to a smart contract, it must implement
1743      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1744      *
1745      * Emits a {Transfer} event.
1746      */
1747     function safeTransferFrom(
1748         address from,
1749         address to,
1750         uint256 tokenId,
1751         bytes memory _data
1752     ) public payable virtual override {
1753         transferFrom(from, to, tokenId);
1754         if (to.code.length != 0)
1755             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1756                 revert TransferToNonERC721ReceiverImplementer();
1757             }
1758     }
1759 
1760     /**
1761      * @dev Hook that is called before a set of serially-ordered token IDs
1762      * are about to be transferred. This includes minting.
1763      * And also called before burning one token.
1764      *
1765      * `startTokenId` - the first token ID to be transferred.
1766      * `quantity` - the amount to be transferred.
1767      *
1768      * Calling conditions:
1769      *
1770      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1771      * transferred to `to`.
1772      * - When `from` is zero, `tokenId` will be minted for `to`.
1773      * - When `to` is zero, `tokenId` will be burned by `from`.
1774      * - `from` and `to` are never both zero.
1775      */
1776     function _beforeTokenTransfers(
1777         address from,
1778         address to,
1779         uint256 startTokenId,
1780         uint256 quantity
1781     ) internal virtual {}
1782 
1783     /**
1784      * @dev Hook that is called after a set of serially-ordered token IDs
1785      * have been transferred. This includes minting.
1786      * And also called after one token has been burned.
1787      *
1788      * `startTokenId` - the first token ID to be transferred.
1789      * `quantity` - the amount to be transferred.
1790      *
1791      * Calling conditions:
1792      *
1793      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1794      * transferred to `to`.
1795      * - When `from` is zero, `tokenId` has been minted for `to`.
1796      * - When `to` is zero, `tokenId` has been burned by `from`.
1797      * - `from` and `to` are never both zero.
1798      */
1799     function _afterTokenTransfers(
1800         address from,
1801         address to,
1802         uint256 startTokenId,
1803         uint256 quantity
1804     ) internal virtual {}
1805 
1806     /**
1807      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1808      *
1809      * `from` - Previous owner of the given token ID.
1810      * `to` - Target address that will receive the token.
1811      * `tokenId` - Token ID to be transferred.
1812      * `_data` - Optional data to send along with the call.
1813      *
1814      * Returns whether the call correctly returned the expected magic value.
1815      */
1816     function _checkContractOnERC721Received(
1817         address from,
1818         address to,
1819         uint256 tokenId,
1820         bytes memory _data
1821     ) private returns (bool) {
1822         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1823             bytes4 retval
1824         ) {
1825             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1826         } catch (bytes memory reason) {
1827             if (reason.length == 0) {
1828                 revert TransferToNonERC721ReceiverImplementer();
1829             } else {
1830                 assembly {
1831                     revert(add(32, reason), mload(reason))
1832                 }
1833             }
1834         }
1835     }
1836 
1837     // =============================================================
1838     //                        MINT OPERATIONS
1839     // =============================================================
1840 
1841     /**
1842      * @dev Mints `quantity` tokens and transfers them to `to`.
1843      *
1844      * Requirements:
1845      *
1846      * - `to` cannot be the zero address.
1847      * - `quantity` must be greater than 0.
1848      *
1849      * Emits a {Transfer} event for each mint.
1850      */
1851     function _mint(address to, uint256 quantity) internal virtual {
1852         uint256 startTokenId = _currentIndex;
1853         if (quantity == 0) revert MintZeroQuantity();
1854 
1855         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1856 
1857         // Overflows are incredibly unrealistic.
1858         // `balance` and `numberMinted` have a maximum limit of 2**64.
1859         // `tokenId` has a maximum limit of 2**256.
1860         unchecked {
1861             // Updates:
1862             // - `balance += quantity`.
1863             // - `numberMinted += quantity`.
1864             //
1865             // We can directly add to the `balance` and `numberMinted`.
1866             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1867 
1868             // Updates:
1869             // - `address` to the owner.
1870             // - `startTimestamp` to the timestamp of minting.
1871             // - `burned` to `false`.
1872             // - `nextInitialized` to `quantity == 1`.
1873             _packedOwnerships[startTokenId] = _packOwnershipData(
1874                 to,
1875                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1876             );
1877 
1878             uint256 toMasked;
1879             uint256 end = startTokenId + quantity;
1880 
1881             // Use assembly to loop and emit the `Transfer` event for gas savings.
1882             // The duplicated `log4` removes an extra check and reduces stack juggling.
1883             // The assembly, together with the surrounding Solidity code, have been
1884             // delicately arranged to nudge the compiler into producing optimized opcodes.
1885             assembly {
1886                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1887                 toMasked := and(to, _BITMASK_ADDRESS)
1888                 // Emit the `Transfer` event.
1889                 log4(
1890                     0, // Start of data (0, since no data).
1891                     0, // End of data (0, since no data).
1892                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1893                     0, // `address(0)`.
1894                     toMasked, // `to`.
1895                     startTokenId // `tokenId`.
1896                 )
1897 
1898                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1899                 // that overflows uint256 will make the loop run out of gas.
1900                 // The compiler will optimize the `iszero` away for performance.
1901                 for {
1902                     let tokenId := add(startTokenId, 1)
1903                 } iszero(eq(tokenId, end)) {
1904                     tokenId := add(tokenId, 1)
1905                 } {
1906                     // Emit the `Transfer` event. Similar to above.
1907                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1908                 }
1909             }
1910             if (toMasked == 0) revert MintToZeroAddress();
1911 
1912             _currentIndex = end;
1913         }
1914         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1915     }
1916 
1917     /**
1918      * @dev Mints `quantity` tokens and transfers them to `to`.
1919      *
1920      * This function is intended for efficient minting only during contract creation.
1921      *
1922      * It emits only one {ConsecutiveTransfer} as defined in
1923      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1924      * instead of a sequence of {Transfer} event(s).
1925      *
1926      * Calling this function outside of contract creation WILL make your contract
1927      * non-compliant with the ERC721 standard.
1928      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1929      * {ConsecutiveTransfer} event is only permissible during contract creation.
1930      *
1931      * Requirements:
1932      *
1933      * - `to` cannot be the zero address.
1934      * - `quantity` must be greater than 0.
1935      *
1936      * Emits a {ConsecutiveTransfer} event.
1937      */
1938     function _mintERC2309(address to, uint256 quantity) internal virtual {
1939         uint256 startTokenId = _currentIndex;
1940         if (to == address(0)) revert MintToZeroAddress();
1941         if (quantity == 0) revert MintZeroQuantity();
1942         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1943 
1944         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1945 
1946         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1947         unchecked {
1948             // Updates:
1949             // - `balance += quantity`.
1950             // - `numberMinted += quantity`.
1951             //
1952             // We can directly add to the `balance` and `numberMinted`.
1953             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1954 
1955             // Updates:
1956             // - `address` to the owner.
1957             // - `startTimestamp` to the timestamp of minting.
1958             // - `burned` to `false`.
1959             // - `nextInitialized` to `quantity == 1`.
1960             _packedOwnerships[startTokenId] = _packOwnershipData(
1961                 to,
1962                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1963             );
1964 
1965             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1966 
1967             _currentIndex = startTokenId + quantity;
1968         }
1969         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1970     }
1971 
1972     /**
1973      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1974      *
1975      * Requirements:
1976      *
1977      * - If `to` refers to a smart contract, it must implement
1978      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1979      * - `quantity` must be greater than 0.
1980      *
1981      * See {_mint}.
1982      *
1983      * Emits a {Transfer} event for each mint.
1984      */
1985     function _safeMint(
1986         address to,
1987         uint256 quantity,
1988         bytes memory _data
1989     ) internal virtual {
1990         _mint(to, quantity);
1991 
1992         unchecked {
1993             if (to.code.length != 0) {
1994                 uint256 end = _currentIndex;
1995                 uint256 index = end - quantity;
1996                 do {
1997                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1998                         revert TransferToNonERC721ReceiverImplementer();
1999                     }
2000                 } while (index < end);
2001                 // Reentrancy protection.
2002                 if (_currentIndex != end) revert();
2003             }
2004         }
2005     }
2006 
2007     /**
2008      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2009      */
2010     function _safeMint(address to, uint256 quantity) internal virtual {
2011         _safeMint(to, quantity, '');
2012     }
2013 
2014     // =============================================================
2015     //                        BURN OPERATIONS
2016     // =============================================================
2017 
2018     /**
2019      * @dev Equivalent to `_burn(tokenId, false)`.
2020      */
2021     function _burn(uint256 tokenId) internal virtual {
2022         _burn(tokenId, false);
2023     }
2024 
2025     /**
2026      * @dev Destroys `tokenId`.
2027      * The approval is cleared when the token is burned.
2028      *
2029      * Requirements:
2030      *
2031      * - `tokenId` must exist.
2032      *
2033      * Emits a {Transfer} event.
2034      */
2035     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2036         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2037 
2038         address from = address(uint160(prevOwnershipPacked));
2039 
2040         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2041 
2042         if (approvalCheck) {
2043             // The nested ifs save around 20+ gas over a compound boolean condition.
2044             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2045                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2046         }
2047 
2048         _beforeTokenTransfers(from, address(0), tokenId, 1);
2049 
2050         // Clear approvals from the previous owner.
2051         assembly {
2052             if approvedAddress {
2053                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2054                 sstore(approvedAddressSlot, 0)
2055             }
2056         }
2057 
2058         // Underflow of the sender's balance is impossible because we check for
2059         // ownership above and the recipient's balance can't realistically overflow.
2060         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2061         unchecked {
2062             // Updates:
2063             // - `balance -= 1`.
2064             // - `numberBurned += 1`.
2065             //
2066             // We can directly decrement the balance, and increment the number burned.
2067             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2068             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2069 
2070             // Updates:
2071             // - `address` to the last owner.
2072             // - `startTimestamp` to the timestamp of burning.
2073             // - `burned` to `true`.
2074             // - `nextInitialized` to `true`.
2075             _packedOwnerships[tokenId] = _packOwnershipData(
2076                 from,
2077                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2078             );
2079 
2080             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2081             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2082                 uint256 nextTokenId = tokenId + 1;
2083                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2084                 if (_packedOwnerships[nextTokenId] == 0) {
2085                     // If the next slot is within bounds.
2086                     if (nextTokenId != _currentIndex) {
2087                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2088                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2089                     }
2090                 }
2091             }
2092         }
2093 
2094         emit Transfer(from, address(0), tokenId);
2095         _afterTokenTransfers(from, address(0), tokenId, 1);
2096 
2097         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2098         unchecked {
2099             _burnCounter++;
2100         }
2101     }
2102 
2103     // =============================================================
2104     //                     EXTRA DATA OPERATIONS
2105     // =============================================================
2106 
2107     /**
2108      * @dev Directly sets the extra data for the ownership data `index`.
2109      */
2110     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2111         uint256 packed = _packedOwnerships[index];
2112         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2113         uint256 extraDataCasted;
2114         // Cast `extraData` with assembly to avoid redundant masking.
2115         assembly {
2116             extraDataCasted := extraData
2117         }
2118         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2119         _packedOwnerships[index] = packed;
2120     }
2121 
2122     /**
2123      * @dev Called during each token transfer to set the 24bit `extraData` field.
2124      * Intended to be overridden by the cosumer contract.
2125      *
2126      * `previousExtraData` - the value of `extraData` before transfer.
2127      *
2128      * Calling conditions:
2129      *
2130      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2131      * transferred to `to`.
2132      * - When `from` is zero, `tokenId` will be minted for `to`.
2133      * - When `to` is zero, `tokenId` will be burned by `from`.
2134      * - `from` and `to` are never both zero.
2135      */
2136     function _extraData(
2137         address from,
2138         address to,
2139         uint24 previousExtraData
2140     ) internal view virtual returns (uint24) {}
2141 
2142     /**
2143      * @dev Returns the next extra data for the packed ownership data.
2144      * The returned result is shifted into position.
2145      */
2146     function _nextExtraData(
2147         address from,
2148         address to,
2149         uint256 prevOwnershipPacked
2150     ) private view returns (uint256) {
2151         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2152         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2153     }
2154 
2155     // =============================================================
2156     //                       OTHER OPERATIONS
2157     // =============================================================
2158 
2159     /**
2160      * @dev Returns the message sender (defaults to `msg.sender`).
2161      *
2162      * If you are writing GSN compatible contracts, you need to override this function.
2163      */
2164     function _msgSenderERC721A() internal view virtual returns (address) {
2165         return msg.sender;
2166     }
2167 
2168     /**
2169      * @dev Converts a uint256 to its ASCII string decimal representation.
2170      */
2171     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2172         assembly {
2173             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2174             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2175             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2176             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2177             let m := add(mload(0x40), 0xa0)
2178             // Update the free memory pointer to allocate.
2179             mstore(0x40, m)
2180             // Assign the `str` to the end.
2181             str := sub(m, 0x20)
2182             // Zeroize the slot after the string.
2183             mstore(str, 0)
2184 
2185             // Cache the end of the memory to calculate the length later.
2186             let end := str
2187 
2188             // We write the string from rightmost digit to leftmost digit.
2189             // The following is essentially a do-while loop that also handles the zero case.
2190             // prettier-ignore
2191             for { let temp := value } 1 {} {
2192                 str := sub(str, 1)
2193                 // Write the character to the pointer.
2194                 // The ASCII index of the '0' character is 48.
2195                 mstore8(str, add(48, mod(temp, 10)))
2196                 // Keep dividing `temp` until zero.
2197                 temp := div(temp, 10)
2198                 // prettier-ignore
2199                 if iszero(temp) { break }
2200             }
2201 
2202             let length := sub(end, str)
2203             // Move the pointer 32 bytes leftwards to make room for the length.
2204             str := sub(str, 0x20)
2205             // Store the length.
2206             mstore(str, length)
2207         }
2208     }
2209 }
2210 
2211 // File: contracts/PNG.sol
2212 
2213 contract PNG is ERC721A, Ownable, ReentrancyGuard {
2214 
2215   using Strings for uint256;
2216 
2217   string public uriPrefix = '';
2218   string public uriSuffix = '.json';
2219   string public hiddenMetadataUri;
2220   
2221   uint256 public cost;
2222   uint256 public maxSupply;
2223   uint256 public maxMintAmountPerTx;
2224   uint256 public maxMintAmountPerWallet = 2;
2225   mapping (address => uint256) public ownerTokenMapping;
2226 
2227   bool public paused = true;
2228   bool public revealed = true;
2229 
2230   constructor(
2231     string memory _tokenName,
2232     string memory _tokenSymbol,
2233     uint256 _cost,
2234     uint256 _maxSupply,
2235     uint256 _maxMintAmountPerTx,
2236     string memory _hiddenMetadataUri
2237   ) ERC721A(_tokenName, _tokenSymbol) {
2238     setCost(_cost);
2239     maxSupply = _maxSupply;
2240     setMaxMintAmountPerTx(_maxMintAmountPerTx);
2241     setHiddenMetadataUri(_hiddenMetadataUri);
2242   }
2243 
2244   modifier mintCompliance(uint256 _mintAmount) {
2245     require(_mintAmount > 0, "Invalid mint amount!");
2246     require(_mintAmount <= maxMintAmountPerTx, "Max mint amount exceeded");
2247 
2248     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
2249 
2250     _;
2251   }
2252 
2253   modifier mintPriceCompliance(uint256 _mintAmount) {
2254     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
2255     _;
2256   }
2257 
2258   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
2259     require(!paused, "The contract is paused!");
2260     require(ownerTokenMapping[msg.sender] + _mintAmount <= maxMintAmountPerWallet, "Max mints per wallet exceeded");
2261     _safeMint(_msgSender(), _mintAmount);
2262     ownerTokenMapping[msg.sender] += _mintAmount;
2263   }
2264   
2265   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
2266     _safeMint(_receiver, _mintAmount);
2267   }
2268 
2269   function _startTokenId() internal view virtual override returns (uint256) {
2270     return 1;
2271   }
2272 
2273   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2274     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2275 
2276     if (revealed == false) {
2277       return hiddenMetadataUri;
2278     }
2279 
2280     string memory currentBaseURI = _baseURI();
2281     return bytes(currentBaseURI).length > 0
2282         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2283         : '';
2284   }
2285 
2286   function setRevealed(bool _state) public onlyOwner {
2287     revealed = _state;
2288   }
2289 
2290   function setCost(uint256 _cost) public onlyOwner {
2291     cost = _cost;
2292   }
2293 
2294   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2295     maxMintAmountPerTx = _maxMintAmountPerTx;
2296   }
2297 
2298   function setMaxMintAmountPerWallet(uint256 _maxMintAmountPerWallet) public onlyOwner {
2299     maxMintAmountPerWallet = _maxMintAmountPerWallet;
2300   }
2301 
2302   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2303     hiddenMetadataUri = _hiddenMetadataUri;
2304   }
2305 
2306   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2307     uriPrefix = _uriPrefix;
2308   }
2309 
2310   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2311     uriSuffix = _uriSuffix;
2312   }
2313 
2314   function setPaused(bool _state) public onlyOwner {
2315     paused = _state;
2316   }
2317 
2318   function withdraw() public onlyOwner nonReentrant {
2319     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2320     require(os);
2321   }
2322 
2323   function _baseURI() internal view virtual override returns (string memory) {
2324     return uriPrefix;
2325   }
2326 }