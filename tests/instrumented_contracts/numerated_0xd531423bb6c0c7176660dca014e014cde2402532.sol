1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.2) (utils/cryptography/MerkleProof.sol)
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
29     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Calldata version of {verify}
35      *
36      * _Available since v4.7._
37      */
38     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
39         return processProofCalldata(proof, leaf) == root;
40     }
41 
42     /**
43      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
44      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
45      * hash matches the root of the tree. When processing the proof, the pairs
46      * of leafs & pre-images are assumed to be sorted.
47      *
48      * _Available since v4.4._
49      */
50     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
51         bytes32 computedHash = leaf;
52         for (uint256 i = 0; i < proof.length; i++) {
53             computedHash = _hashPair(computedHash, proof[i]);
54         }
55         return computedHash;
56     }
57 
58     /**
59      * @dev Calldata version of {processProof}
60      *
61      * _Available since v4.7._
62      */
63     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
64         bytes32 computedHash = leaf;
65         for (uint256 i = 0; i < proof.length; i++) {
66             computedHash = _hashPair(computedHash, proof[i]);
67         }
68         return computedHash;
69     }
70 
71     /**
72      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
73      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
74      *
75      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
76      *
77      * _Available since v4.7._
78      */
79     function multiProofVerify(
80         bytes32[] memory proof,
81         bool[] memory proofFlags,
82         bytes32 root,
83         bytes32[] memory leaves
84     ) internal pure returns (bool) {
85         return processMultiProof(proof, proofFlags, leaves) == root;
86     }
87 
88     /**
89      * @dev Calldata version of {multiProofVerify}
90      *
91      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
92      *
93      * _Available since v4.7._
94      */
95     function multiProofVerifyCalldata(
96         bytes32[] calldata proof,
97         bool[] calldata proofFlags,
98         bytes32 root,
99         bytes32[] memory leaves
100     ) internal pure returns (bool) {
101         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
102     }
103 
104     /**
105      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
106      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
107      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
108      * respectively.
109      *
110      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
111      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
112      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
113      *
114      * _Available since v4.7._
115      */
116     function processMultiProof(
117         bytes32[] memory proof,
118         bool[] memory proofFlags,
119         bytes32[] memory leaves
120     ) internal pure returns (bytes32 merkleRoot) {
121         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
122         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
123         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
124         // the merkle tree.
125         uint256 leavesLen = leaves.length;
126         uint256 proofLen = proof.length;
127         uint256 totalHashes = proofFlags.length;
128 
129         // Check proof validity.
130         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
131 
132         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
133         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
134         bytes32[] memory hashes = new bytes32[](totalHashes);
135         uint256 leafPos = 0;
136         uint256 hashPos = 0;
137         uint256 proofPos = 0;
138         // At each step, we compute the next hash using two values:
139         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
140         //   get the next hash.
141         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
142         //   `proof` array.
143         for (uint256 i = 0; i < totalHashes; i++) {
144             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
145             bytes32 b = proofFlags[i]
146                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
147                 : proof[proofPos++];
148             hashes[i] = _hashPair(a, b);
149         }
150 
151         if (totalHashes > 0) {
152             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
153             unchecked {
154                 return hashes[totalHashes - 1];
155             }
156         } else if (leavesLen > 0) {
157             return leaves[0];
158         } else {
159             return proof[0];
160         }
161     }
162 
163     /**
164      * @dev Calldata version of {processMultiProof}.
165      *
166      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
167      *
168      * _Available since v4.7._
169      */
170     function processMultiProofCalldata(
171         bytes32[] calldata proof,
172         bool[] calldata proofFlags,
173         bytes32[] memory leaves
174     ) internal pure returns (bytes32 merkleRoot) {
175         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
176         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
177         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
178         // the merkle tree.
179         uint256 leavesLen = leaves.length;
180         uint256 proofLen = proof.length;
181         uint256 totalHashes = proofFlags.length;
182 
183         // Check proof validity.
184         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
185 
186         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
187         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
188         bytes32[] memory hashes = new bytes32[](totalHashes);
189         uint256 leafPos = 0;
190         uint256 hashPos = 0;
191         uint256 proofPos = 0;
192         // At each step, we compute the next hash using two values:
193         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
194         //   get the next hash.
195         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
196         //   `proof` array.
197         for (uint256 i = 0; i < totalHashes; i++) {
198             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
199             bytes32 b = proofFlags[i]
200                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
201                 : proof[proofPos++];
202             hashes[i] = _hashPair(a, b);
203         }
204 
205         if (totalHashes > 0) {
206             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
207             unchecked {
208                 return hashes[totalHashes - 1];
209             }
210         } else if (leavesLen > 0) {
211             return leaves[0];
212         } else {
213             return proof[0];
214         }
215     }
216 
217     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
218         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
219     }
220 
221     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
222         /// @solidity memory-safe-assembly
223         assembly {
224             mstore(0x00, a)
225             mstore(0x20, b)
226             value := keccak256(0x00, 0x40)
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Standard signed math utilities missing in the Solidity language.
240  */
241 library SignedMath {
242     /**
243      * @dev Returns the largest of two signed numbers.
244      */
245     function max(int256 a, int256 b) internal pure returns (int256) {
246         return a > b ? a : b;
247     }
248 
249     /**
250      * @dev Returns the smallest of two signed numbers.
251      */
252     function min(int256 a, int256 b) internal pure returns (int256) {
253         return a < b ? a : b;
254     }
255 
256     /**
257      * @dev Returns the average of two signed numbers without overflow.
258      * The result is rounded towards zero.
259      */
260     function average(int256 a, int256 b) internal pure returns (int256) {
261         // Formula from the book "Hacker's Delight"
262         int256 x = (a & b) + ((a ^ b) >> 1);
263         return x + (int256(uint256(x) >> 255) & (a ^ b));
264     }
265 
266     /**
267      * @dev Returns the absolute unsigned value of a signed value.
268      */
269     function abs(int256 n) internal pure returns (uint256) {
270         unchecked {
271             // must be unchecked in order to support `n = type(int256).min`
272             return uint256(n >= 0 ? n : -n);
273         }
274     }
275 }
276 
277 // File: @openzeppelin/contracts/utils/math/Math.sol
278 
279 
280 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev Standard math utilities missing in the Solidity language.
286  */
287 library Math {
288     enum Rounding {
289         Down, // Toward negative infinity
290         Up, // Toward infinity
291         Zero // Toward zero
292     }
293 
294     /**
295      * @dev Returns the largest of two numbers.
296      */
297     function max(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a > b ? a : b;
299     }
300 
301     /**
302      * @dev Returns the smallest of two numbers.
303      */
304     function min(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a < b ? a : b;
306     }
307 
308     /**
309      * @dev Returns the average of two numbers. The result is rounded towards
310      * zero.
311      */
312     function average(uint256 a, uint256 b) internal pure returns (uint256) {
313         // (a + b) / 2 can overflow.
314         return (a & b) + (a ^ b) / 2;
315     }
316 
317     /**
318      * @dev Returns the ceiling of the division of two numbers.
319      *
320      * This differs from standard division with `/` in that it rounds up instead
321      * of rounding down.
322      */
323     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
324         // (a + b - 1) / b can overflow on addition, so we distribute.
325         return a == 0 ? 0 : (a - 1) / b + 1;
326     }
327 
328     /**
329      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
330      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
331      * with further edits by Uniswap Labs also under MIT license.
332      */
333     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
334         unchecked {
335             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
336             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
337             // variables such that product = prod1 * 2^256 + prod0.
338             uint256 prod0; // Least significant 256 bits of the product
339             uint256 prod1; // Most significant 256 bits of the product
340             assembly {
341                 let mm := mulmod(x, y, not(0))
342                 prod0 := mul(x, y)
343                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
344             }
345 
346             // Handle non-overflow cases, 256 by 256 division.
347             if (prod1 == 0) {
348                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
349                 // The surrounding unchecked block does not change this fact.
350                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
351                 return prod0 / denominator;
352             }
353 
354             // Make sure the result is less than 2^256. Also prevents denominator == 0.
355             require(denominator > prod1, "Math: mulDiv overflow");
356 
357             ///////////////////////////////////////////////
358             // 512 by 256 division.
359             ///////////////////////////////////////////////
360 
361             // Make division exact by subtracting the remainder from [prod1 prod0].
362             uint256 remainder;
363             assembly {
364                 // Compute remainder using mulmod.
365                 remainder := mulmod(x, y, denominator)
366 
367                 // Subtract 256 bit number from 512 bit number.
368                 prod1 := sub(prod1, gt(remainder, prod0))
369                 prod0 := sub(prod0, remainder)
370             }
371 
372             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
373             // See https://cs.stackexchange.com/q/138556/92363.
374 
375             // Does not overflow because the denominator cannot be zero at this stage in the function.
376             uint256 twos = denominator & (~denominator + 1);
377             assembly {
378                 // Divide denominator by twos.
379                 denominator := div(denominator, twos)
380 
381                 // Divide [prod1 prod0] by twos.
382                 prod0 := div(prod0, twos)
383 
384                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
385                 twos := add(div(sub(0, twos), twos), 1)
386             }
387 
388             // Shift in bits from prod1 into prod0.
389             prod0 |= prod1 * twos;
390 
391             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
392             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
393             // four bits. That is, denominator * inv = 1 mod 2^4.
394             uint256 inverse = (3 * denominator) ^ 2;
395 
396             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
397             // in modular arithmetic, doubling the correct bits in each step.
398             inverse *= 2 - denominator * inverse; // inverse mod 2^8
399             inverse *= 2 - denominator * inverse; // inverse mod 2^16
400             inverse *= 2 - denominator * inverse; // inverse mod 2^32
401             inverse *= 2 - denominator * inverse; // inverse mod 2^64
402             inverse *= 2 - denominator * inverse; // inverse mod 2^128
403             inverse *= 2 - denominator * inverse; // inverse mod 2^256
404 
405             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
406             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
407             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
408             // is no longer required.
409             result = prod0 * inverse;
410             return result;
411         }
412     }
413 
414     /**
415      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
416      */
417     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
418         uint256 result = mulDiv(x, y, denominator);
419         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
420             result += 1;
421         }
422         return result;
423     }
424 
425     /**
426      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
427      *
428      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
429      */
430     function sqrt(uint256 a) internal pure returns (uint256) {
431         if (a == 0) {
432             return 0;
433         }
434 
435         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
436         //
437         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
438         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
439         //
440         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
441         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
442         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
443         //
444         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
445         uint256 result = 1 << (log2(a) >> 1);
446 
447         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
448         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
449         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
450         // into the expected uint128 result.
451         unchecked {
452             result = (result + a / result) >> 1;
453             result = (result + a / result) >> 1;
454             result = (result + a / result) >> 1;
455             result = (result + a / result) >> 1;
456             result = (result + a / result) >> 1;
457             result = (result + a / result) >> 1;
458             result = (result + a / result) >> 1;
459             return min(result, a / result);
460         }
461     }
462 
463     /**
464      * @notice Calculates sqrt(a), following the selected rounding direction.
465      */
466     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
467         unchecked {
468             uint256 result = sqrt(a);
469             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
470         }
471     }
472 
473     /**
474      * @dev Return the log in base 2, rounded down, of a positive value.
475      * Returns 0 if given 0.
476      */
477     function log2(uint256 value) internal pure returns (uint256) {
478         uint256 result = 0;
479         unchecked {
480             if (value >> 128 > 0) {
481                 value >>= 128;
482                 result += 128;
483             }
484             if (value >> 64 > 0) {
485                 value >>= 64;
486                 result += 64;
487             }
488             if (value >> 32 > 0) {
489                 value >>= 32;
490                 result += 32;
491             }
492             if (value >> 16 > 0) {
493                 value >>= 16;
494                 result += 16;
495             }
496             if (value >> 8 > 0) {
497                 value >>= 8;
498                 result += 8;
499             }
500             if (value >> 4 > 0) {
501                 value >>= 4;
502                 result += 4;
503             }
504             if (value >> 2 > 0) {
505                 value >>= 2;
506                 result += 2;
507             }
508             if (value >> 1 > 0) {
509                 result += 1;
510             }
511         }
512         return result;
513     }
514 
515     /**
516      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
517      * Returns 0 if given 0.
518      */
519     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
520         unchecked {
521             uint256 result = log2(value);
522             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
523         }
524     }
525 
526     /**
527      * @dev Return the log in base 10, rounded down, of a positive value.
528      * Returns 0 if given 0.
529      */
530     function log10(uint256 value) internal pure returns (uint256) {
531         uint256 result = 0;
532         unchecked {
533             if (value >= 10 ** 64) {
534                 value /= 10 ** 64;
535                 result += 64;
536             }
537             if (value >= 10 ** 32) {
538                 value /= 10 ** 32;
539                 result += 32;
540             }
541             if (value >= 10 ** 16) {
542                 value /= 10 ** 16;
543                 result += 16;
544             }
545             if (value >= 10 ** 8) {
546                 value /= 10 ** 8;
547                 result += 8;
548             }
549             if (value >= 10 ** 4) {
550                 value /= 10 ** 4;
551                 result += 4;
552             }
553             if (value >= 10 ** 2) {
554                 value /= 10 ** 2;
555                 result += 2;
556             }
557             if (value >= 10 ** 1) {
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
568     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
569         unchecked {
570             uint256 result = log10(value);
571             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
572         }
573     }
574 
575     /**
576      * @dev Return the log in base 256, rounded down, of a positive value.
577      * Returns 0 if given 0.
578      *
579      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
580      */
581     function log256(uint256 value) internal pure returns (uint256) {
582         uint256 result = 0;
583         unchecked {
584             if (value >> 128 > 0) {
585                 value >>= 128;
586                 result += 16;
587             }
588             if (value >> 64 > 0) {
589                 value >>= 64;
590                 result += 8;
591             }
592             if (value >> 32 > 0) {
593                 value >>= 32;
594                 result += 4;
595             }
596             if (value >> 16 > 0) {
597                 value >>= 16;
598                 result += 2;
599             }
600             if (value >> 8 > 0) {
601                 result += 1;
602             }
603         }
604         return result;
605     }
606 
607     /**
608      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
609      * Returns 0 if given 0.
610      */
611     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
612         unchecked {
613             uint256 result = log256(value);
614             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
615         }
616     }
617 }
618 
619 // File: @openzeppelin/contracts/utils/Strings.sol
620 
621 
622 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 
627 
628 /**
629  * @dev String operations.
630  */
631 library Strings {
632     bytes16 private constant _SYMBOLS = "0123456789abcdef";
633     uint8 private constant _ADDRESS_LENGTH = 20;
634 
635     /**
636      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
637      */
638     function toString(uint256 value) internal pure returns (string memory) {
639         unchecked {
640             uint256 length = Math.log10(value) + 1;
641             string memory buffer = new string(length);
642             uint256 ptr;
643             /// @solidity memory-safe-assembly
644             assembly {
645                 ptr := add(buffer, add(32, length))
646             }
647             while (true) {
648                 ptr--;
649                 /// @solidity memory-safe-assembly
650                 assembly {
651                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
652                 }
653                 value /= 10;
654                 if (value == 0) break;
655             }
656             return buffer;
657         }
658     }
659 
660     /**
661      * @dev Converts a `int256` to its ASCII `string` decimal representation.
662      */
663     function toString(int256 value) internal pure returns (string memory) {
664         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
665     }
666 
667     /**
668      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
669      */
670     function toHexString(uint256 value) internal pure returns (string memory) {
671         unchecked {
672             return toHexString(value, Math.log256(value) + 1);
673         }
674     }
675 
676     /**
677      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
678      */
679     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
680         bytes memory buffer = new bytes(2 * length + 2);
681         buffer[0] = "0";
682         buffer[1] = "x";
683         for (uint256 i = 2 * length + 1; i > 1; --i) {
684             buffer[i] = _SYMBOLS[value & 0xf];
685             value >>= 4;
686         }
687         require(value == 0, "Strings: hex length insufficient");
688         return string(buffer);
689     }
690 
691     /**
692      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
693      */
694     function toHexString(address addr) internal pure returns (string memory) {
695         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
696     }
697 
698     /**
699      * @dev Returns true if the two strings are equal.
700      */
701     function equal(string memory a, string memory b) internal pure returns (bool) {
702         return keccak256(bytes(a)) == keccak256(bytes(b));
703     }
704 }
705 
706 // File: @openzeppelin/contracts/utils/Context.sol
707 
708 
709 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
710 
711 pragma solidity ^0.8.0;
712 
713 /**
714  * @dev Provides information about the current execution context, including the
715  * sender of the transaction and its data. While these are generally available
716  * via msg.sender and msg.data, they should not be accessed in such a direct
717  * manner, since when dealing with meta-transactions the account sending and
718  * paying for execution may not be the actual sender (as far as an application
719  * is concerned).
720  *
721  * This contract is only required for intermediate, library-like contracts.
722  */
723 abstract contract Context {
724     function _msgSender() internal view virtual returns (address) {
725         return msg.sender;
726     }
727 
728     function _msgData() internal view virtual returns (bytes calldata) {
729         return msg.data;
730     }
731 }
732 
733 // File: @openzeppelin/contracts/access/Ownable.sol
734 
735 
736 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
737 
738 pragma solidity ^0.8.0;
739 
740 
741 /**
742  * @dev Contract module which provides a basic access control mechanism, where
743  * there is an account (an owner) that can be granted exclusive access to
744  * specific functions.
745  *
746  * By default, the owner account will be the one that deploys the contract. This
747  * can later be changed with {transferOwnership}.
748  *
749  * This module is used through inheritance. It will make available the modifier
750  * `onlyOwner`, which can be applied to your functions to restrict their use to
751  * the owner.
752  */
753 abstract contract Ownable is Context {
754     address private _owner;
755 
756     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
757 
758     /**
759      * @dev Initializes the contract setting the deployer as the initial owner.
760      */
761     constructor() {
762         _transferOwnership(_msgSender());
763     }
764 
765     /**
766      * @dev Throws if called by any account other than the owner.
767      */
768     modifier onlyOwner() {
769         _checkOwner();
770         _;
771     }
772 
773     /**
774      * @dev Returns the address of the current owner.
775      */
776     function owner() public view virtual returns (address) {
777         return _owner;
778     }
779 
780     /**
781      * @dev Throws if the sender is not the owner.
782      */
783     function _checkOwner() internal view virtual {
784         require(owner() == _msgSender(), "Ownable: caller is not the owner");
785     }
786 
787     /**
788      * @dev Leaves the contract without owner. It will not be possible to call
789      * `onlyOwner` functions. Can only be called by the current owner.
790      *
791      * NOTE: Renouncing ownership will leave the contract without an owner,
792      * thereby disabling any functionality that is only available to the owner.
793      */
794     function renounceOwnership() public virtual onlyOwner {
795         _transferOwnership(address(0));
796     }
797 
798     /**
799      * @dev Transfers ownership of the contract to a new account (`newOwner`).
800      * Can only be called by the current owner.
801      */
802     function transferOwnership(address newOwner) public virtual onlyOwner {
803         require(newOwner != address(0), "Ownable: new owner is the zero address");
804         _transferOwnership(newOwner);
805     }
806 
807     /**
808      * @dev Transfers ownership of the contract to a new account (`newOwner`).
809      * Internal function without access restriction.
810      */
811     function _transferOwnership(address newOwner) internal virtual {
812         address oldOwner = _owner;
813         _owner = newOwner;
814         emit OwnershipTransferred(oldOwner, newOwner);
815     }
816 }
817 
818 // File: @openzeppelin/contracts/utils/Address.sol
819 
820 
821 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
822 
823 pragma solidity ^0.8.1;
824 
825 /**
826  * @dev Collection of functions related to the address type
827  */
828 library Address {
829     /**
830      * @dev Returns true if `account` is a contract.
831      *
832      * [IMPORTANT]
833      * ====
834      * It is unsafe to assume that an address for which this function returns
835      * false is an externally-owned account (EOA) and not a contract.
836      *
837      * Among others, `isContract` will return false for the following
838      * types of addresses:
839      *
840      *  - an externally-owned account
841      *  - a contract in construction
842      *  - an address where a contract will be created
843      *  - an address where a contract lived, but was destroyed
844      *
845      * Furthermore, `isContract` will also return true if the target contract within
846      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
847      * which only has an effect at the end of a transaction.
848      * ====
849      *
850      * [IMPORTANT]
851      * ====
852      * You shouldn't rely on `isContract` to protect against flash loan attacks!
853      *
854      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
855      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
856      * constructor.
857      * ====
858      */
859     function isContract(address account) internal view returns (bool) {
860         // This method relies on extcodesize/address.code.length, which returns 0
861         // for contracts in construction, since the code is only stored at the end
862         // of the constructor execution.
863 
864         return account.code.length > 0;
865     }
866 
867     /**
868      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
869      * `recipient`, forwarding all available gas and reverting on errors.
870      *
871      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
872      * of certain opcodes, possibly making contracts go over the 2300 gas limit
873      * imposed by `transfer`, making them unable to receive funds via
874      * `transfer`. {sendValue} removes this limitation.
875      *
876      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
877      *
878      * IMPORTANT: because control is transferred to `recipient`, care must be
879      * taken to not create reentrancy vulnerabilities. Consider using
880      * {ReentrancyGuard} or the
881      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
882      */
883     function sendValue(address payable recipient, uint256 amount) internal {
884         require(address(this).balance >= amount, "Address: insufficient balance");
885 
886         (bool success, ) = recipient.call{value: amount}("");
887         require(success, "Address: unable to send value, recipient may have reverted");
888     }
889 
890     /**
891      * @dev Performs a Solidity function call using a low level `call`. A
892      * plain `call` is an unsafe replacement for a function call: use this
893      * function instead.
894      *
895      * If `target` reverts with a revert reason, it is bubbled up by this
896      * function (like regular Solidity function calls).
897      *
898      * Returns the raw returned data. To convert to the expected return value,
899      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
900      *
901      * Requirements:
902      *
903      * - `target` must be a contract.
904      * - calling `target` with `data` must not revert.
905      *
906      * _Available since v3.1._
907      */
908     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
909         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
910     }
911 
912     /**
913      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
914      * `errorMessage` as a fallback revert reason when `target` reverts.
915      *
916      * _Available since v3.1._
917      */
918     function functionCall(
919         address target,
920         bytes memory data,
921         string memory errorMessage
922     ) internal returns (bytes memory) {
923         return functionCallWithValue(target, data, 0, errorMessage);
924     }
925 
926     /**
927      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
928      * but also transferring `value` wei to `target`.
929      *
930      * Requirements:
931      *
932      * - the calling contract must have an ETH balance of at least `value`.
933      * - the called Solidity function must be `payable`.
934      *
935      * _Available since v3.1._
936      */
937     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
938         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
939     }
940 
941     /**
942      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
943      * with `errorMessage` as a fallback revert reason when `target` reverts.
944      *
945      * _Available since v3.1._
946      */
947     function functionCallWithValue(
948         address target,
949         bytes memory data,
950         uint256 value,
951         string memory errorMessage
952     ) internal returns (bytes memory) {
953         require(address(this).balance >= value, "Address: insufficient balance for call");
954         (bool success, bytes memory returndata) = target.call{value: value}(data);
955         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
956     }
957 
958     /**
959      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
960      * but performing a static call.
961      *
962      * _Available since v3.3._
963      */
964     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
965         return functionStaticCall(target, data, "Address: low-level static call failed");
966     }
967 
968     /**
969      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
970      * but performing a static call.
971      *
972      * _Available since v3.3._
973      */
974     function functionStaticCall(
975         address target,
976         bytes memory data,
977         string memory errorMessage
978     ) internal view returns (bytes memory) {
979         (bool success, bytes memory returndata) = target.staticcall(data);
980         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
981     }
982 
983     /**
984      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
985      * but performing a delegate call.
986      *
987      * _Available since v3.4._
988      */
989     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
990         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
991     }
992 
993     /**
994      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
995      * but performing a delegate call.
996      *
997      * _Available since v3.4._
998      */
999     function functionDelegateCall(
1000         address target,
1001         bytes memory data,
1002         string memory errorMessage
1003     ) internal returns (bytes memory) {
1004         (bool success, bytes memory returndata) = target.delegatecall(data);
1005         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1006     }
1007 
1008     /**
1009      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1010      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1011      *
1012      * _Available since v4.8._
1013      */
1014     function verifyCallResultFromTarget(
1015         address target,
1016         bool success,
1017         bytes memory returndata,
1018         string memory errorMessage
1019     ) internal view returns (bytes memory) {
1020         if (success) {
1021             if (returndata.length == 0) {
1022                 // only check isContract if the call was successful and the return data is empty
1023                 // otherwise we already know that it was a contract
1024                 require(isContract(target), "Address: call to non-contract");
1025             }
1026             return returndata;
1027         } else {
1028             _revert(returndata, errorMessage);
1029         }
1030     }
1031 
1032     /**
1033      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1034      * revert reason or using the provided one.
1035      *
1036      * _Available since v4.3._
1037      */
1038     function verifyCallResult(
1039         bool success,
1040         bytes memory returndata,
1041         string memory errorMessage
1042     ) internal pure returns (bytes memory) {
1043         if (success) {
1044             return returndata;
1045         } else {
1046             _revert(returndata, errorMessage);
1047         }
1048     }
1049 
1050     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1051         // Look for revert reason and bubble it up if present
1052         if (returndata.length > 0) {
1053             // The easiest way to bubble the revert reason is using memory via assembly
1054             /// @solidity memory-safe-assembly
1055             assembly {
1056                 let returndata_size := mload(returndata)
1057                 revert(add(32, returndata), returndata_size)
1058             }
1059         } else {
1060             revert(errorMessage);
1061         }
1062     }
1063 }
1064 
1065 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1066 
1067 
1068 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1069 
1070 pragma solidity ^0.8.0;
1071 
1072 /**
1073  * @title ERC721 token receiver interface
1074  * @dev Interface for any contract that wants to support safeTransfers
1075  * from ERC721 asset contracts.
1076  */
1077 interface IERC721Receiver {
1078     /**
1079      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1080      * by `operator` from `from`, this function is called.
1081      *
1082      * It must return its Solidity selector to confirm the token transfer.
1083      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1084      *
1085      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1086      */
1087     function onERC721Received(
1088         address operator,
1089         address from,
1090         uint256 tokenId,
1091         bytes calldata data
1092     ) external returns (bytes4);
1093 }
1094 
1095 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1096 
1097 
1098 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1099 
1100 pragma solidity ^0.8.0;
1101 
1102 /**
1103  * @dev Interface of the ERC165 standard, as defined in the
1104  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1105  *
1106  * Implementers can declare support of contract interfaces, which can then be
1107  * queried by others ({ERC165Checker}).
1108  *
1109  * For an implementation, see {ERC165}.
1110  */
1111 interface IERC165 {
1112     /**
1113      * @dev Returns true if this contract implements the interface defined by
1114      * `interfaceId`. See the corresponding
1115      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1116      * to learn more about how these ids are created.
1117      *
1118      * This function call must use less than 30 000 gas.
1119      */
1120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1121 }
1122 
1123 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1124 
1125 
1126 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1127 
1128 pragma solidity ^0.8.0;
1129 
1130 
1131 /**
1132  * @dev Implementation of the {IERC165} interface.
1133  *
1134  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1135  * for the additional interface id that will be supported. For example:
1136  *
1137  * ```solidity
1138  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1139  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1140  * }
1141  * ```
1142  *
1143  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1144  */
1145 abstract contract ERC165 is IERC165 {
1146     /**
1147      * @dev See {IERC165-supportsInterface}.
1148      */
1149     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1150         return interfaceId == type(IERC165).interfaceId;
1151     }
1152 }
1153 
1154 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1155 
1156 
1157 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
1158 
1159 pragma solidity ^0.8.0;
1160 
1161 
1162 /**
1163  * @dev Required interface of an ERC721 compliant contract.
1164  */
1165 interface IERC721 is IERC165 {
1166     /**
1167      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1168      */
1169     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1170 
1171     /**
1172      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1173      */
1174     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1175 
1176     /**
1177      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1178      */
1179     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1180 
1181     /**
1182      * @dev Returns the number of tokens in ``owner``'s account.
1183      */
1184     function balanceOf(address owner) external view returns (uint256 balance);
1185 
1186     /**
1187      * @dev Returns the owner of the `tokenId` token.
1188      *
1189      * Requirements:
1190      *
1191      * - `tokenId` must exist.
1192      */
1193     function ownerOf(uint256 tokenId) external view returns (address owner);
1194 
1195     /**
1196      * @dev Safely transfers `tokenId` token from `from` to `to`.
1197      *
1198      * Requirements:
1199      *
1200      * - `from` cannot be the zero address.
1201      * - `to` cannot be the zero address.
1202      * - `tokenId` token must exist and be owned by `from`.
1203      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1204      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1209 
1210     /**
1211      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1212      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1213      *
1214      * Requirements:
1215      *
1216      * - `from` cannot be the zero address.
1217      * - `to` cannot be the zero address.
1218      * - `tokenId` token must exist and be owned by `from`.
1219      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1221      *
1222      * Emits a {Transfer} event.
1223      */
1224     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1225 
1226     /**
1227      * @dev Transfers `tokenId` token from `from` to `to`.
1228      *
1229      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1230      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1231      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1232      *
1233      * Requirements:
1234      *
1235      * - `from` cannot be the zero address.
1236      * - `to` cannot be the zero address.
1237      * - `tokenId` token must be owned by `from`.
1238      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1239      *
1240      * Emits a {Transfer} event.
1241      */
1242     function transferFrom(address from, address to, uint256 tokenId) external;
1243 
1244     /**
1245      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1246      * The approval is cleared when the token is transferred.
1247      *
1248      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1249      *
1250      * Requirements:
1251      *
1252      * - The caller must own the token or be an approved operator.
1253      * - `tokenId` must exist.
1254      *
1255      * Emits an {Approval} event.
1256      */
1257     function approve(address to, uint256 tokenId) external;
1258 
1259     /**
1260      * @dev Approve or remove `operator` as an operator for the caller.
1261      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1262      *
1263      * Requirements:
1264      *
1265      * - The `operator` cannot be the caller.
1266      *
1267      * Emits an {ApprovalForAll} event.
1268      */
1269     function setApprovalForAll(address operator, bool approved) external;
1270 
1271     /**
1272      * @dev Returns the account approved for `tokenId` token.
1273      *
1274      * Requirements:
1275      *
1276      * - `tokenId` must exist.
1277      */
1278     function getApproved(uint256 tokenId) external view returns (address operator);
1279 
1280     /**
1281      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1282      *
1283      * See {setApprovalForAll}
1284      */
1285     function isApprovedForAll(address owner, address operator) external view returns (bool);
1286 }
1287 
1288 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1289 
1290 
1291 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1292 
1293 pragma solidity ^0.8.0;
1294 
1295 
1296 /**
1297  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1298  * @dev See https://eips.ethereum.org/EIPS/eip-721
1299  */
1300 interface IERC721Enumerable is IERC721 {
1301     /**
1302      * @dev Returns the total amount of tokens stored by the contract.
1303      */
1304     function totalSupply() external view returns (uint256);
1305 
1306     /**
1307      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1308      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1309      */
1310     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1311 
1312     /**
1313      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1314      * Use along with {totalSupply} to enumerate all tokens.
1315      */
1316     function tokenByIndex(uint256 index) external view returns (uint256);
1317 }
1318 
1319 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1320 
1321 
1322 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1323 
1324 pragma solidity ^0.8.0;
1325 
1326 
1327 /**
1328  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1329  * @dev See https://eips.ethereum.org/EIPS/eip-721
1330  */
1331 interface IERC721Metadata is IERC721 {
1332     /**
1333      * @dev Returns the token collection name.
1334      */
1335     function name() external view returns (string memory);
1336 
1337     /**
1338      * @dev Returns the token collection symbol.
1339      */
1340     function symbol() external view returns (string memory);
1341 
1342     /**
1343      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1344      */
1345     function tokenURI(uint256 tokenId) external view returns (string memory);
1346 }
1347 
1348 // File: ERC721A.sol
1349 
1350 
1351 // Creator: Chiru Labs
1352 pragma solidity ^0.8.4;
1353 
1354 
1355 
1356 
1357 
1358 
1359 
1360 
1361 
1362 error ApprovalCallerNotOwnerNorApproved();
1363 error ApprovalQueryForNonexistentToken();
1364 error ApproveToCaller();
1365 error ApprovalToCurrentOwner();
1366 error BalanceQueryForZeroAddress();
1367 error MintedQueryForZeroAddress();
1368 error BurnedQueryForZeroAddress();
1369 error AuxQueryForZeroAddress();
1370 error MintToZeroAddress();
1371 error MintZeroQuantity();
1372 error OwnerIndexOutOfBounds();
1373 error OwnerQueryForNonexistentToken();
1374 error TokenIndexOutOfBounds();
1375 error TransferCallerNotOwnerNorApproved();
1376 error TransferFromIncorrectOwner();
1377 error TransferToNonERC721ReceiverImplementer();
1378 error TransferToZeroAddress();
1379 error URIQueryForNonexistentToken();
1380 
1381 /**
1382  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1383  * the Metadata extension. Built to optimize for lower gas during batch mints.
1384  *
1385  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1386  *
1387  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1388  *
1389  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1390  */
1391 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1392     using Address for address;
1393     using Strings for uint256;
1394 
1395     // Compiler will pack this into a single 256bit word.
1396     struct TokenOwnership {
1397         // The address of the owner.
1398         address addr;
1399         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1400         uint64 startTimestamp;
1401         // Whether the token has been burned.
1402         bool burned;
1403     }
1404 
1405     // Compiler will pack this into a single 256bit word.
1406     struct AddressData {
1407         // Realistically, 2**64-1 is more than enough.
1408         uint64 balance;
1409         // Keeps track of mint count with minimal overhead for tokenomics.
1410         uint64 numberMinted;
1411         // Keeps track of burn count with minimal overhead for tokenomics.
1412         uint64 numberBurned;
1413         // For miscellaneous variable(s) pertaining to the address
1414         // (e.g. number of whitelist mint slots used).
1415         // If there are multiple variables, please pack them into a uint64.
1416         uint64 aux;
1417     }
1418 
1419     // The tokenId of the next token to be minted.
1420     uint256 internal _currentIndex;
1421 
1422     // The number of tokens burned.
1423     uint256 internal _burnCounter;
1424 
1425     // Token name
1426     string private _name;
1427 
1428     // Token symbol
1429     string private _symbol;
1430 
1431     // Mapping from token ID to ownership details
1432     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1433     mapping(uint256 => TokenOwnership) internal _ownerships;
1434 
1435     // Mapping owner address to address data
1436     mapping(address => AddressData) private _addressData;
1437 
1438     // Mapping from token ID to approved address
1439     mapping(uint256 => address) private _tokenApprovals;
1440 
1441     // Mapping from owner to operator approvals
1442     mapping(address => mapping(address => bool)) private _operatorApprovals;
1443 
1444     constructor(string memory name_, string memory symbol_) {
1445         _name = name_;
1446         _symbol = symbol_;
1447         _currentIndex = _startTokenId();
1448     }
1449 
1450     /**
1451      * To change the starting tokenId, please override this function.
1452      */
1453     function _startTokenId() internal view virtual returns (uint256) {
1454         return 0;
1455     }
1456 
1457     /**
1458      * @dev See {IERC721Enumerable-totalSupply}.
1459      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1460      */
1461     function totalSupply() public view returns (uint256) {
1462         // Counter underflow is impossible as _burnCounter cannot be incremented
1463         // more than _currentIndex - _startTokenId() times
1464         unchecked {
1465             return _currentIndex - _burnCounter - _startTokenId();
1466         }
1467     }
1468 
1469     /**
1470      * Returns the total amount of tokens minted in the contract.
1471      */
1472     function _totalMinted() internal view returns (uint256) {
1473         // Counter underflow is impossible as _currentIndex does not decrement,
1474         // and it is initialized to _startTokenId()
1475         unchecked {
1476             return _currentIndex - _startTokenId();
1477         }
1478     }
1479 
1480     /**
1481      * @dev See {IERC165-supportsInterface}.
1482      */
1483     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1484         return
1485             interfaceId == type(IERC721).interfaceId ||
1486             interfaceId == type(IERC721Metadata).interfaceId ||
1487             super.supportsInterface(interfaceId);
1488     }
1489 
1490     /**
1491      * @dev See {IERC721-balanceOf}.
1492      */
1493     function balanceOf(address owner) public view override returns (uint256) {
1494         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1495         return uint256(_addressData[owner].balance);
1496     }
1497 
1498     /**
1499      * Returns the number of tokens minted by `owner`.
1500      */
1501     function _numberMinted(address owner) internal view returns (uint256) {
1502         if (owner == address(0)) revert MintedQueryForZeroAddress();
1503         return uint256(_addressData[owner].numberMinted);
1504     }
1505 
1506     /**
1507      * Returns the number of tokens burned by or on behalf of `owner`.
1508      */
1509     function _numberBurned(address owner) internal view returns (uint256) {
1510         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1511         return uint256(_addressData[owner].numberBurned);
1512     }
1513 
1514     /**
1515      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1516      */
1517     function _getAux(address owner) internal view returns (uint64) {
1518         if (owner == address(0)) revert AuxQueryForZeroAddress();
1519         return _addressData[owner].aux;
1520     }
1521 
1522     /**
1523      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1524      * If there are multiple variables, please pack them into a uint64.
1525      */
1526     function _setAux(address owner, uint64 aux) internal {
1527         if (owner == address(0)) revert AuxQueryForZeroAddress();
1528         _addressData[owner].aux = aux;
1529     }
1530 
1531     /**
1532      * Gas spent here starts off proportional to the maximum mint batch size.
1533      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1534      */
1535     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1536         uint256 curr = tokenId;
1537 
1538         unchecked {
1539             if (_startTokenId() <= curr && curr < _currentIndex) {
1540                 TokenOwnership memory ownership = _ownerships[curr];
1541                 if (!ownership.burned) {
1542                     if (ownership.addr != address(0)) {
1543                         return ownership;
1544                     }
1545                     // Invariant:
1546                     // There will always be an ownership that has an address and is not burned
1547                     // before an ownership that does not have an address and is not burned.
1548                     // Hence, curr will not underflow.
1549                     while (true) {
1550                         curr--;
1551                         ownership = _ownerships[curr];
1552                         if (ownership.addr != address(0)) {
1553                             return ownership;
1554                         }
1555                     }
1556                 }
1557             }
1558         }
1559         revert OwnerQueryForNonexistentToken();
1560     }
1561 
1562     /**
1563      * @dev See {IERC721-ownerOf}.
1564      */
1565     function ownerOf(uint256 tokenId) public view override returns (address) {
1566         return ownershipOf(tokenId).addr;
1567     }
1568 
1569     /**
1570      * @dev See {IERC721Metadata-name}.
1571      */
1572     function name() public view virtual override returns (string memory) {
1573         return _name;
1574     }
1575 
1576     /**
1577      * @dev See {IERC721Metadata-symbol}.
1578      */
1579     function symbol() public view virtual override returns (string memory) {
1580         return _symbol;
1581     }
1582 
1583     /**
1584      * @dev See {IERC721Metadata-tokenURI}.
1585      */
1586     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1587         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1588 
1589         string memory baseURI = _baseURI();
1590         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1591     }
1592 
1593     /**
1594      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1595      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1596      * by default, can be overriden in child contracts.
1597      */
1598     function _baseURI() internal view virtual returns (string memory) {
1599         return '';
1600     }
1601 
1602     /**
1603      * @dev See {IERC721-approve}.
1604      */
1605     function approve(address to, uint256 tokenId) public override {
1606         address owner = ERC721A.ownerOf(tokenId);
1607         if (to == owner) revert ApprovalToCurrentOwner();
1608 
1609         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1610             revert ApprovalCallerNotOwnerNorApproved();
1611         }
1612 
1613         _approve(to, tokenId, owner);
1614     }
1615 
1616     /**
1617      * @dev See {IERC721-getApproved}.
1618      */
1619     function getApproved(uint256 tokenId) public view override returns (address) {
1620         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1621 
1622         return _tokenApprovals[tokenId];
1623     }
1624 
1625     /**
1626      * @dev See {IERC721-setApprovalForAll}.
1627      */
1628     function setApprovalForAll(address operator, bool approved) public override {
1629         if (operator == _msgSender()) revert ApproveToCaller();
1630 
1631         _operatorApprovals[_msgSender()][operator] = approved;
1632         emit ApprovalForAll(_msgSender(), operator, approved);
1633     }
1634 
1635     /**
1636      * @dev See {IERC721-isApprovedForAll}.
1637      */
1638     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1639         return _operatorApprovals[owner][operator];
1640     }
1641 
1642     /**
1643      * @dev See {IERC721-transferFrom}.
1644      */
1645     function transferFrom(
1646         address from,
1647         address to,
1648         uint256 tokenId
1649     ) public virtual override {
1650         _transfer(from, to, tokenId);
1651     }
1652 
1653     /**
1654      * @dev See {IERC721-safeTransferFrom}.
1655      */
1656     function safeTransferFrom(
1657         address from,
1658         address to,
1659         uint256 tokenId
1660     ) public virtual override {
1661         safeTransferFrom(from, to, tokenId, '');
1662     }
1663 
1664     /**
1665      * @dev See {IERC721-safeTransferFrom}.
1666      */
1667     function safeTransferFrom(
1668         address from,
1669         address to,
1670         uint256 tokenId,
1671         bytes memory _data
1672     ) public virtual override {
1673         _transfer(from, to, tokenId);
1674         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1675             revert TransferToNonERC721ReceiverImplementer();
1676         }
1677     }
1678 
1679     /**
1680      * @dev Returns whether `tokenId` exists.
1681      *
1682      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1683      *
1684      * Tokens start existing when they are minted (`_mint`),
1685      */
1686     function _exists(uint256 tokenId) internal view returns (bool) {
1687         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1688             !_ownerships[tokenId].burned;
1689     }
1690 
1691     function _safeMint(address to, uint256 quantity) internal {
1692         _safeMint(to, quantity, '');
1693     }
1694 
1695     /**
1696      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1697      *
1698      * Requirements:
1699      *
1700      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1701      * - `quantity` must be greater than 0.
1702      *
1703      * Emits a {Transfer} event.
1704      */
1705     function _safeMint(
1706         address to,
1707         uint256 quantity,
1708         bytes memory _data
1709     ) internal {
1710         _mint(to, quantity, _data, true);
1711     }
1712 
1713     /**
1714      * @dev Mints `quantity` tokens and transfers them to `to`.
1715      *
1716      * Requirements:
1717      *
1718      * - `to` cannot be the zero address.
1719      * - `quantity` must be greater than 0.
1720      *
1721      * Emits a {Transfer} event.
1722      */
1723     function _mint(
1724         address to,
1725         uint256 quantity,
1726         bytes memory _data,
1727         bool safe
1728     ) internal {
1729         uint256 startTokenId = _currentIndex;
1730         if (to == address(0)) revert MintToZeroAddress();
1731         if (quantity == 0) revert MintZeroQuantity();
1732 
1733         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1734 
1735         // Overflows are incredibly unrealistic.
1736         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1737         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1738         unchecked {
1739             _addressData[to].balance += uint64(quantity);
1740             _addressData[to].numberMinted += uint64(quantity);
1741 
1742             _ownerships[startTokenId].addr = to;
1743             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1744 
1745             uint256 updatedIndex = startTokenId;
1746             uint256 end = updatedIndex + quantity;
1747 
1748             if (safe && to.isContract()) {
1749                 do {
1750                     emit Transfer(address(0), to, updatedIndex);
1751                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1752                         revert TransferToNonERC721ReceiverImplementer();
1753                     }
1754                 } while (updatedIndex != end);
1755                 // Reentrancy protection
1756                 if (_currentIndex != startTokenId) revert();
1757             } else {
1758                 do {
1759                     emit Transfer(address(0), to, updatedIndex++);
1760                 } while (updatedIndex != end);
1761             }
1762             _currentIndex = updatedIndex;
1763         }
1764         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1765     }
1766 
1767     /**
1768      * @dev Transfers `tokenId` from `from` to `to`.
1769      *
1770      * Requirements:
1771      *
1772      * - `to` cannot be the zero address.
1773      * - `tokenId` token must be owned by `from`.
1774      *
1775      * Emits a {Transfer} event.
1776      */
1777     function _transfer(
1778         address from,
1779         address to,
1780         uint256 tokenId
1781     ) private {
1782         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1783 
1784         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1785             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1786             getApproved(tokenId) == _msgSender());
1787 
1788         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1789         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1790         if (to == address(0)) revert TransferToZeroAddress();
1791 
1792         _beforeTokenTransfers(from, to, tokenId, 1);
1793 
1794         // Clear approvals from the previous owner
1795         _approve(address(0), tokenId, prevOwnership.addr);
1796 
1797         // Underflow of the sender's balance is impossible because we check for
1798         // ownership above and the recipient's balance can't realistically overflow.
1799         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1800         unchecked {
1801             _addressData[from].balance -= 1;
1802             _addressData[to].balance += 1;
1803 
1804             _ownerships[tokenId].addr = to;
1805             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1806 
1807             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1808             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1809             uint256 nextTokenId = tokenId + 1;
1810             if (_ownerships[nextTokenId].addr == address(0)) {
1811                 // This will suffice for checking _exists(nextTokenId),
1812                 // as a burned slot cannot contain the zero address.
1813                 if (nextTokenId < _currentIndex) {
1814                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1815                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1816                 }
1817             }
1818         }
1819 
1820         emit Transfer(from, to, tokenId);
1821         _afterTokenTransfers(from, to, tokenId, 1);
1822     }
1823 
1824     /**
1825      * @dev Destroys `tokenId`.
1826      * The approval is cleared when the token is burned.
1827      *
1828      * Requirements:
1829      *
1830      * - `tokenId` must exist.
1831      *
1832      * Emits a {Transfer} event.
1833      */
1834     function _burn(uint256 tokenId) internal virtual {
1835         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1836 
1837         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1838 
1839         // Clear approvals from the previous owner
1840         _approve(address(0), tokenId, prevOwnership.addr);
1841 
1842         // Underflow of the sender's balance is impossible because we check for
1843         // ownership above and the recipient's balance can't realistically overflow.
1844         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1845         unchecked {
1846             _addressData[prevOwnership.addr].balance -= 1;
1847             _addressData[prevOwnership.addr].numberBurned += 1;
1848 
1849             // Keep track of who burned the token, and the timestamp of burning.
1850             _ownerships[tokenId].addr = prevOwnership.addr;
1851             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1852             _ownerships[tokenId].burned = true;
1853 
1854             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1855             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1856             uint256 nextTokenId = tokenId + 1;
1857             if (_ownerships[nextTokenId].addr == address(0)) {
1858                 // This will suffice for checking _exists(nextTokenId),
1859                 // as a burned slot cannot contain the zero address.
1860                 if (nextTokenId < _currentIndex) {
1861                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1862                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1863                 }
1864             }
1865         }
1866 
1867         emit Transfer(prevOwnership.addr, address(0), tokenId);
1868         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1869 
1870         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1871         unchecked {
1872             _burnCounter++;
1873         }
1874     }
1875 
1876     /**
1877      * @dev Approve `to` to operate on `tokenId`
1878      *
1879      * Emits a {Approval} event.
1880      */
1881     function _approve(
1882         address to,
1883         uint256 tokenId,
1884         address owner
1885     ) private {
1886         _tokenApprovals[tokenId] = to;
1887         emit Approval(owner, to, tokenId);
1888     }
1889 
1890     /**
1891      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1892      *
1893      * @param from address representing the previous owner of the given token ID
1894      * @param to target address that will receive the tokens
1895      * @param tokenId uint256 ID of the token to be transferred
1896      * @param _data bytes optional data to send along with the call
1897      * @return bool whether the call correctly returned the expected magic value
1898      */
1899     function _checkContractOnERC721Received(
1900         address from,
1901         address to,
1902         uint256 tokenId,
1903         bytes memory _data
1904     ) private returns (bool) {
1905         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1906             return retval == IERC721Receiver(to).onERC721Received.selector;
1907         } catch (bytes memory reason) {
1908             if (reason.length == 0) {
1909                 revert TransferToNonERC721ReceiverImplementer();
1910             } else {
1911                 assembly {
1912                     revert(add(32, reason), mload(reason))
1913                 }
1914             }
1915         }
1916     }
1917 
1918     /**
1919      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1920      * And also called before burning one token.
1921      *
1922      * startTokenId - the first token id to be transferred
1923      * quantity - the amount to be transferred
1924      *
1925      * Calling conditions:
1926      *
1927      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1928      * transferred to `to`.
1929      * - When `from` is zero, `tokenId` will be minted for `to`.
1930      * - When `to` is zero, `tokenId` will be burned by `from`.
1931      * - `from` and `to` are never both zero.
1932      */
1933     function _beforeTokenTransfers(
1934         address from,
1935         address to,
1936         uint256 startTokenId,
1937         uint256 quantity
1938     ) internal virtual {}
1939 
1940     /**
1941      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1942      * minting.
1943      * And also called after one token has been burned.
1944      *
1945      * startTokenId - the first token id to be transferred
1946      * quantity - the amount to be transferred
1947      *
1948      * Calling conditions:
1949      *
1950      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1951      * transferred to `to`.
1952      * - When `from` is zero, `tokenId` has been minted for `to`.
1953      * - When `to` is zero, `tokenId` has been burned by `from`.
1954      * - `from` and `to` are never both zero.
1955      */
1956     function _afterTokenTransfers(
1957         address from,
1958         address to,
1959         uint256 startTokenId,
1960         uint256 quantity
1961     ) internal virtual {}
1962 }
1963 
1964 // File: nft.sol
1965 
1966 
1967 pragma solidity ^0.8.4;
1968 
1969 
1970 
1971 
1972 
1973 contract STRIK9LABS is ERC721A, Ownable {
1974     using Strings for uint256;
1975 
1976     // Supply
1977     uint256 public maxSupply = 5555;
1978 
1979     // URI
1980     string public baseURI;
1981     string public hiddenURI;
1982 
1983     // Costs
1984     uint256 public pack1WhitelistSaleCost = 0.012 ether;
1985     uint256 public pack1PublicSaleCost = 0.016 ether;
1986 
1987     uint256 public pack2WhitelistSaleCost = 0.022 ether;
1988     uint256 public pack2PublicSaleCost = 0.028 ether;
1989 
1990     uint256 public pack3WhitelistSaleCost = 0.03 ether;
1991     uint256 public pack3PublicSaleCost = 0.039 ether;
1992 
1993     uint256 public pack4WhitelistSaleCost = 0.045 ether;
1994     uint256 public pack4PublicSaleCost = 0.06 ether;
1995 
1996     // States
1997     bool public freeSale = false;
1998     bool public whitelistSale = false;
1999     bool public publicSale = false;
2000 
2001     bool public revealed = false;
2002 
2003     // Merkle Tree Roots
2004     bytes32 public freeSaleMerkleTreeRoot;
2005     bytes32 public whitelistSaleMerkleTreeRoot;
2006 
2007     // Balances
2008     mapping(address => bool) public freeMintClaimed;
2009 
2010     // Companions contract
2011     address companionsContractAddress = 0x999999999099334c4D6900D09dd18e3C2E9a9460;
2012 
2013     // Constructor
2014     constructor() ERC721A("STRIK9 LABS", "S9L") {}
2015 
2016     // Free Sale Mint - Functions
2017     function fetchTotalOwnedCompanions() public view returns (uint256) {
2018         uint256 totalOwned = IERC721(companionsContractAddress).balanceOf(msg.sender);
2019 
2020         return totalOwned;
2021     }
2022 
2023     function freeSaleMint(bytes32[] memory _merkleTreeProof) public payable freeSaleMintCompliance(_merkleTreeProof) {
2024         require(freeSale == true, "MSG: Free sale is not live");
2025 
2026         uint256 _mintAmount = 1;
2027 
2028         uint256 totalOwnedCompanions = fetchTotalOwnedCompanions();
2029 
2030         if(totalOwnedCompanions > 0) {
2031             _mintAmount = totalOwnedCompanions * 2;
2032         }
2033 
2034         require(!freeMintClaimed[msg.sender], "MSG: You can only mint 1 time on free sale");
2035         freeMintClaimed[msg.sender] = true;
2036 
2037         require(totalSupply() + _mintAmount <= maxSupply, "MSG: Max supply exceeded");
2038         _safeMint(msg.sender, _mintAmount);
2039     }
2040 
2041     modifier freeSaleMintCompliance(bytes32[] memory _merkleTreeProof) {
2042         require(isValidFreeSaleMerkleTreeProof(_merkleTreeProof, keccak256(abi.encodePacked(msg.sender))), "MSG: User is not whitelisted");
2043         _;
2044     }
2045 
2046     function isValidFreeSaleMerkleTreeProof(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
2047         return MerkleProof.verify(proof, freeSaleMerkleTreeRoot, leaf);
2048     }
2049 
2050     // Whitelist Sale Mint - Functions
2051     function whitelistSaleMint(uint256 _pack, uint256 _quantity, bytes32[] memory _merkleTreeProof) public payable whitelistSaleMintCompliance(_merkleTreeProof) {
2052         require(whitelistSale == true, "MSG: Whitelist sale is not live");
2053 
2054         require(_pack >= 1 && _pack <= 4, "MSG: Invalid pack");
2055 
2056         uint256 _mintAmount;
2057 
2058         if(_pack == 1) {
2059             require(msg.value == pack1WhitelistSaleCost * _quantity, "MSG: Insufficient funds");
2060             _mintAmount = 1 * _quantity;
2061         } else if(_pack == 2) {
2062             require(msg.value == pack2WhitelistSaleCost * _quantity, "MSG: Insufficient funds");
2063             _mintAmount = 2 * _quantity;
2064         } else if(_pack == 3) {
2065             require(msg.value == pack3WhitelistSaleCost * _quantity, "MSG: Insufficient funds");
2066             _mintAmount = 3 * _quantity;
2067         } else if(_pack == 4) {
2068             require(msg.value == pack4WhitelistSaleCost * _quantity, "MSG: Insufficient funds");
2069             _mintAmount = 5 * _quantity;
2070         }
2071 
2072         require(totalSupply() + _mintAmount <= maxSupply, "MSG: Max supply exceeded");
2073         _safeMint(msg.sender, _mintAmount);
2074     }
2075 
2076     modifier whitelistSaleMintCompliance(bytes32[] memory _merkleTreeProof) {
2077         require(isValidWhitelistSaleMerkleTreeProof(_merkleTreeProof, keccak256(abi.encodePacked(msg.sender))), "MSG: User is not whitelisted");
2078         _;
2079     }
2080 
2081     function isValidWhitelistSaleMerkleTreeProof(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
2082         return MerkleProof.verify(proof, whitelistSaleMerkleTreeRoot, leaf);
2083     }
2084 
2085     // Public Sale Mint - Functions
2086     function publicSaleMint(uint256 _pack, uint256 _quantity) public payable {
2087         require(publicSale == true, "MSG: Public sale is not live");
2088 
2089         require(_pack >= 1 && _pack <= 4, "MSG: Invalid pack");
2090 
2091         uint256 _mintAmount;
2092 
2093         if(_pack == 1) {
2094             require(msg.value == pack1PublicSaleCost * _quantity, "MSG: Insufficient funds");
2095             _mintAmount = 1 * _quantity;
2096         } else if(_pack == 2) {
2097             require(msg.value == pack2PublicSaleCost * _quantity, "MSG: Insufficient funds");
2098             _mintAmount = 2 * _quantity;
2099         } else if(_pack == 3) {
2100             require(msg.value == pack3PublicSaleCost * _quantity, "MSG: Insufficient funds");
2101             _mintAmount = 3 * _quantity;
2102         } else if(_pack == 4) {
2103             require(msg.value == pack4PublicSaleCost * _quantity, "MSG: Insufficient funds");
2104             _mintAmount = 5 * _quantity;
2105         }
2106 
2107         require(totalSupply() + _mintAmount <= maxSupply, "MSG: Max supply exceeded");
2108         _safeMint(msg.sender, _mintAmount);
2109     }
2110 
2111     // Owner Mint - Functions
2112     function ownerMint(uint256 _mintAmount) public onlyOwner {
2113         require(totalSupply() + _mintAmount <= maxSupply, "MSG: Max supply exceeded");
2114         _safeMint(msg.sender, _mintAmount);
2115     }
2116 
2117     function ownerMintForOthers(address _receiver, uint256 _mintAmount) public onlyOwner {
2118         require(totalSupply() + _mintAmount <= maxSupply, "MSG: Max supply exceeded");
2119         _safeMint(_receiver, _mintAmount);
2120     }
2121 
2122     // URI - Functions
2123     function _baseURI() internal view override returns (string memory) {
2124         return baseURI;
2125     }
2126 
2127     function setBaseURI(string memory _uri) public onlyOwner {
2128         baseURI = _uri;
2129     }
2130 
2131     function setHiddenURI(string memory _uri) public onlyOwner {
2132         hiddenURI = _uri;
2133     }
2134 
2135     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2136         require(_exists(_tokenId), "MSG: URI query for nonexistent token.");
2137 
2138         if (revealed == false) {
2139             return hiddenURI;
2140         }
2141 
2142         string memory currentBaseURI = _baseURI();
2143         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json")) : "";
2144     }
2145 
2146     // Cost - Functions
2147     function setPack1WhitelistSaleCost(uint256 _cost) public onlyOwner {
2148         pack1WhitelistSaleCost = _cost;
2149     }
2150 
2151     function setPack1PublicSaleCost(uint256 _cost) public onlyOwner {
2152         pack1PublicSaleCost = _cost;
2153     }
2154 
2155     function setPack2WhitelistSaleCost(uint256 _cost) public onlyOwner {
2156         pack2WhitelistSaleCost = _cost;
2157     }
2158 
2159     function setPack2PublicSaleCost(uint256 _cost) public onlyOwner {
2160         pack2PublicSaleCost = _cost;
2161     }
2162 
2163     function setPack3WhitelistSaleCost(uint256 _cost) public onlyOwner {
2164         pack3WhitelistSaleCost = _cost;
2165     }
2166 
2167     function setPack3PublicSaleCost(uint256 _cost) public onlyOwner {
2168         pack3PublicSaleCost = _cost;
2169     }
2170 
2171     function setPack4WhitelistSaleCost(uint256 _cost) public onlyOwner {
2172         pack4WhitelistSaleCost = _cost;
2173     }
2174 
2175     function setPack4PublicSaleCost(uint256 _cost) public onlyOwner {
2176         pack4PublicSaleCost = _cost;
2177     }
2178 
2179     // State - Functions
2180     function setFreeSale(bool _state) public onlyOwner {
2181         freeSale = _state;
2182     }
2183 
2184     function setWhitelistSale(bool _state) public onlyOwner {
2185         whitelistSale = _state;
2186     }
2187 
2188     function setPublicSale(bool _state) public onlyOwner {
2189         publicSale = _state;
2190     }
2191 
2192     function setRevealed(bool _state) public onlyOwner {
2193         revealed = _state;
2194     }
2195 
2196     // Merkle Tree Root - Functions
2197     function setFreeSaleMerkleTreeRoot(bytes32 _root) public onlyOwner {
2198         freeSaleMerkleTreeRoot = _root;
2199     }
2200     
2201     function setWhitelistSaleMerkleTreeRoot(bytes32 _root) public onlyOwner {
2202         whitelistSaleMerkleTreeRoot = _root;
2203     }
2204 
2205     // Other Functions
2206     function setCompanionsContractAddress(address _address) public onlyOwner {
2207         companionsContractAddress = _address;
2208     }
2209 
2210     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
2211         uint256 ownerTokenCount = balanceOf(_owner);
2212         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2213         uint256 currentTokenId = _startTokenId();
2214         uint256 ownedTokenIndex = 0;
2215 
2216         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2217             TokenOwnership memory ownership = _ownerships[currentTokenId];
2218 
2219             if (!ownership.burned && ownership.addr == _owner) {
2220                 ownedTokenIds[ownedTokenIndex++] = currentTokenId;
2221             }
2222 
2223             currentTokenId++;
2224         }
2225 
2226         return ownedTokenIds;
2227     }
2228 
2229     // Withdraw - Function
2230     function withdraw() public payable onlyOwner {
2231         payable(owner()).transfer(address(this).balance);
2232     }
2233 }