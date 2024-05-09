1 // File: @openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (utils/math/Math.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library MathUpgradeable {
12     enum Rounding {
13         Down, // Toward negative infinity
14         Up, // Toward infinity
15         Zero // Toward zero
16     }
17 
18     /**
19      * @dev Returns the largest of two numbers.
20      */
21     function max(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a > b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the smallest of two numbers.
27      */
28     function min(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a < b ? a : b;
30     }
31 
32     /**
33      * @dev Returns the average of two numbers. The result is rounded towards
34      * zero.
35      */
36     function average(uint256 a, uint256 b) internal pure returns (uint256) {
37         // (a + b) / 2 can overflow.
38         return (a & b) + (a ^ b) / 2;
39     }
40 
41     /**
42      * @dev Returns the ceiling of the division of two numbers.
43      *
44      * This differs from standard division with `/` in that it rounds up instead
45      * of rounding down.
46      */
47     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
48         // (a + b - 1) / b can overflow on addition, so we distribute.
49         return a == 0 ? 0 : (a - 1) / b + 1;
50     }
51 
52     /**
53      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
54      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
55      * with further edits by Uniswap Labs also under MIT license.
56      */
57     function mulDiv(
58         uint256 x,
59         uint256 y,
60         uint256 denominator
61     ) internal pure returns (uint256 result) {
62         unchecked {
63             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
64             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
65             // variables such that product = prod1 * 2^256 + prod0.
66             uint256 prod0; // Least significant 256 bits of the product
67             uint256 prod1; // Most significant 256 bits of the product
68             assembly {
69                 let mm := mulmod(x, y, not(0))
70                 prod0 := mul(x, y)
71                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
72             }
73 
74             // Handle non-overflow cases, 256 by 256 division.
75             if (prod1 == 0) {
76                 return prod0 / denominator;
77             }
78 
79             // Make sure the result is less than 2^256. Also prevents denominator == 0.
80             require(denominator > prod1);
81 
82             ///////////////////////////////////////////////
83             // 512 by 256 division.
84             ///////////////////////////////////////////////
85 
86             // Make division exact by subtracting the remainder from [prod1 prod0].
87             uint256 remainder;
88             assembly {
89                 // Compute remainder using mulmod.
90                 remainder := mulmod(x, y, denominator)
91 
92                 // Subtract 256 bit number from 512 bit number.
93                 prod1 := sub(prod1, gt(remainder, prod0))
94                 prod0 := sub(prod0, remainder)
95             }
96 
97             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
98             // See https://cs.stackexchange.com/q/138556/92363.
99 
100             // Does not overflow because the denominator cannot be zero at this stage in the function.
101             uint256 twos = denominator & (~denominator + 1);
102             assembly {
103                 // Divide denominator by twos.
104                 denominator := div(denominator, twos)
105 
106                 // Divide [prod1 prod0] by twos.
107                 prod0 := div(prod0, twos)
108 
109                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
110                 twos := add(div(sub(0, twos), twos), 1)
111             }
112 
113             // Shift in bits from prod1 into prod0.
114             prod0 |= prod1 * twos;
115 
116             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
117             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
118             // four bits. That is, denominator * inv = 1 mod 2^4.
119             uint256 inverse = (3 * denominator) ^ 2;
120 
121             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
122             // in modular arithmetic, doubling the correct bits in each step.
123             inverse *= 2 - denominator * inverse; // inverse mod 2^8
124             inverse *= 2 - denominator * inverse; // inverse mod 2^16
125             inverse *= 2 - denominator * inverse; // inverse mod 2^32
126             inverse *= 2 - denominator * inverse; // inverse mod 2^64
127             inverse *= 2 - denominator * inverse; // inverse mod 2^128
128             inverse *= 2 - denominator * inverse; // inverse mod 2^256
129 
130             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
131             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
132             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
133             // is no longer required.
134             result = prod0 * inverse;
135             return result;
136         }
137     }
138 
139     /**
140      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
141      */
142     function mulDiv(
143         uint256 x,
144         uint256 y,
145         uint256 denominator,
146         Rounding rounding
147     ) internal pure returns (uint256) {
148         uint256 result = mulDiv(x, y, denominator);
149         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
150             result += 1;
151         }
152         return result;
153     }
154 
155     /**
156      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
157      *
158      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
159      */
160     function sqrt(uint256 a) internal pure returns (uint256) {
161         if (a == 0) {
162             return 0;
163         }
164 
165         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
166         //
167         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
168         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
169         //
170         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
171         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
172         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
173         //
174         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
175         uint256 result = 1 << (log2(a) >> 1);
176 
177         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
178         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
179         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
180         // into the expected uint128 result.
181         unchecked {
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             return min(result, a / result);
190         }
191     }
192 
193     /**
194      * @notice Calculates sqrt(a), following the selected rounding direction.
195      */
196     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
197         unchecked {
198             uint256 result = sqrt(a);
199             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
200         }
201     }
202 
203     /**
204      * @dev Return the log in base 2, rounded down, of a positive value.
205      * Returns 0 if given 0.
206      */
207     function log2(uint256 value) internal pure returns (uint256) {
208         uint256 result = 0;
209         unchecked {
210             if (value >> 128 > 0) {
211                 value >>= 128;
212                 result += 128;
213             }
214             if (value >> 64 > 0) {
215                 value >>= 64;
216                 result += 64;
217             }
218             if (value >> 32 > 0) {
219                 value >>= 32;
220                 result += 32;
221             }
222             if (value >> 16 > 0) {
223                 value >>= 16;
224                 result += 16;
225             }
226             if (value >> 8 > 0) {
227                 value >>= 8;
228                 result += 8;
229             }
230             if (value >> 4 > 0) {
231                 value >>= 4;
232                 result += 4;
233             }
234             if (value >> 2 > 0) {
235                 value >>= 2;
236                 result += 2;
237             }
238             if (value >> 1 > 0) {
239                 result += 1;
240             }
241         }
242         return result;
243     }
244 
245     /**
246      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
247      * Returns 0 if given 0.
248      */
249     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
250         unchecked {
251             uint256 result = log2(value);
252             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
253         }
254     }
255 
256     /**
257      * @dev Return the log in base 10, rounded down, of a positive value.
258      * Returns 0 if given 0.
259      */
260     function log10(uint256 value) internal pure returns (uint256) {
261         uint256 result = 0;
262         unchecked {
263             if (value >= 10**64) {
264                 value /= 10**64;
265                 result += 64;
266             }
267             if (value >= 10**32) {
268                 value /= 10**32;
269                 result += 32;
270             }
271             if (value >= 10**16) {
272                 value /= 10**16;
273                 result += 16;
274             }
275             if (value >= 10**8) {
276                 value /= 10**8;
277                 result += 8;
278             }
279             if (value >= 10**4) {
280                 value /= 10**4;
281                 result += 4;
282             }
283             if (value >= 10**2) {
284                 value /= 10**2;
285                 result += 2;
286             }
287             if (value >= 10**1) {
288                 result += 1;
289             }
290         }
291         return result;
292     }
293 
294     /**
295      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
296      * Returns 0 if given 0.
297      */
298     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
299         unchecked {
300             uint256 result = log10(value);
301             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
302         }
303     }
304 
305     /**
306      * @dev Return the log in base 256, rounded down, of a positive value.
307      * Returns 0 if given 0.
308      *
309      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
310      */
311     function log256(uint256 value) internal pure returns (uint256) {
312         uint256 result = 0;
313         unchecked {
314             if (value >> 128 > 0) {
315                 value >>= 128;
316                 result += 16;
317             }
318             if (value >> 64 > 0) {
319                 value >>= 64;
320                 result += 8;
321             }
322             if (value >> 32 > 0) {
323                 value >>= 32;
324                 result += 4;
325             }
326             if (value >> 16 > 0) {
327                 value >>= 16;
328                 result += 2;
329             }
330             if (value >> 8 > 0) {
331                 result += 1;
332             }
333         }
334         return result;
335     }
336 
337     /**
338      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
339      * Returns 0 if given 0.
340      */
341     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
342         unchecked {
343             uint256 result = log256(value);
344             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
345         }
346     }
347 }
348 
349 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (utils/Strings.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev String operations.
359  */
360 library StringsUpgradeable {
361     bytes16 private constant _SYMBOLS = "0123456789abcdef";
362     uint8 private constant _ADDRESS_LENGTH = 20;
363 
364     /**
365      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
366      */
367     function toString(uint256 value) internal pure returns (string memory) {
368         unchecked {
369             uint256 length = MathUpgradeable.log10(value) + 1;
370             string memory buffer = new string(length);
371             uint256 ptr;
372             /// @solidity memory-safe-assembly
373             assembly {
374                 ptr := add(buffer, add(32, length))
375             }
376             while (true) {
377                 ptr--;
378                 /// @solidity memory-safe-assembly
379                 assembly {
380                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
381                 }
382                 value /= 10;
383                 if (value == 0) break;
384             }
385             return buffer;
386         }
387     }
388 
389     /**
390      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
391      */
392     function toHexString(uint256 value) internal pure returns (string memory) {
393         unchecked {
394             return toHexString(value, MathUpgradeable.log256(value) + 1);
395         }
396     }
397 
398     /**
399      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
400      */
401     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
402         bytes memory buffer = new bytes(2 * length + 2);
403         buffer[0] = "0";
404         buffer[1] = "x";
405         for (uint256 i = 2 * length + 1; i > 1; --i) {
406             buffer[i] = _SYMBOLS[value & 0xf];
407             value >>= 4;
408         }
409         require(value == 0, "Strings: hex length insufficient");
410         return string(buffer);
411     }
412 
413     /**
414      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
415      */
416     function toHexString(address addr) internal pure returns (string memory) {
417         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
418     }
419 }
420 
421 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
422 
423 
424 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @dev These functions deal with verification of Merkle Tree proofs.
430  *
431  * The proofs can be generated using the JavaScript library
432  * https://github.com/miguelmota/merkletreejs[merkletreejs].
433  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
434  *
435  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
436  *
437  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
438  * hashing, or use a hash function other than keccak256 for hashing leaves.
439  * This is because the concatenation of a sorted pair of internal nodes in
440  * the merkle tree could be reinterpreted as a leaf value.
441  */
442 library MerkleProof {
443     /**
444      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
445      * defined by `root`. For this, a `proof` must be provided, containing
446      * sibling hashes on the branch from the leaf to the root of the tree. Each
447      * pair of leaves and each pair of pre-images are assumed to be sorted.
448      */
449     function verify(
450         bytes32[] memory proof,
451         bytes32 root,
452         bytes32 leaf
453     ) internal pure returns (bool) {
454         return processProof(proof, leaf) == root;
455     }
456 
457     /**
458      * @dev Calldata version of {verify}
459      *
460      * _Available since v4.7._
461      */
462     function verifyCalldata(
463         bytes32[] calldata proof,
464         bytes32 root,
465         bytes32 leaf
466     ) internal pure returns (bool) {
467         return processProofCalldata(proof, leaf) == root;
468     }
469 
470     /**
471      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
472      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
473      * hash matches the root of the tree. When processing the proof, the pairs
474      * of leafs & pre-images are assumed to be sorted.
475      *
476      * _Available since v4.4._
477      */
478     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
479         bytes32 computedHash = leaf;
480         for (uint256 i = 0; i < proof.length; i++) {
481             computedHash = _hashPair(computedHash, proof[i]);
482         }
483         return computedHash;
484     }
485 
486     /**
487      * @dev Calldata version of {processProof}
488      *
489      * _Available since v4.7._
490      */
491     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
492         bytes32 computedHash = leaf;
493         for (uint256 i = 0; i < proof.length; i++) {
494             computedHash = _hashPair(computedHash, proof[i]);
495         }
496         return computedHash;
497     }
498 
499     /**
500      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
501      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
502      *
503      * _Available since v4.7._
504      */
505     function multiProofVerify(
506         bytes32[] memory proof,
507         bool[] memory proofFlags,
508         bytes32 root,
509         bytes32[] memory leaves
510     ) internal pure returns (bool) {
511         return processMultiProof(proof, proofFlags, leaves) == root;
512     }
513 
514     /**
515      * @dev Calldata version of {multiProofVerify}
516      *
517      * _Available since v4.7._
518      */
519     function multiProofVerifyCalldata(
520         bytes32[] calldata proof,
521         bool[] calldata proofFlags,
522         bytes32 root,
523         bytes32[] memory leaves
524     ) internal pure returns (bool) {
525         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
526     }
527 
528     /**
529      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
530      * consuming from one or the other at each step according to the instructions given by
531      * `proofFlags`.
532      *
533      * _Available since v4.7._
534      */
535     function processMultiProof(
536         bytes32[] memory proof,
537         bool[] memory proofFlags,
538         bytes32[] memory leaves
539     ) internal pure returns (bytes32 merkleRoot) {
540         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
541         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
542         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
543         // the merkle tree.
544         uint256 leavesLen = leaves.length;
545         uint256 totalHashes = proofFlags.length;
546 
547         // Check proof validity.
548         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
549 
550         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
551         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
552         bytes32[] memory hashes = new bytes32[](totalHashes);
553         uint256 leafPos = 0;
554         uint256 hashPos = 0;
555         uint256 proofPos = 0;
556         // At each step, we compute the next hash using two values:
557         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
558         //   get the next hash.
559         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
560         //   `proof` array.
561         for (uint256 i = 0; i < totalHashes; i++) {
562             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
563             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
564             hashes[i] = _hashPair(a, b);
565         }
566 
567         if (totalHashes > 0) {
568             return hashes[totalHashes - 1];
569         } else if (leavesLen > 0) {
570             return leaves[0];
571         } else {
572             return proof[0];
573         }
574     }
575 
576     /**
577      * @dev Calldata version of {processMultiProof}
578      *
579      * _Available since v4.7._
580      */
581     function processMultiProofCalldata(
582         bytes32[] calldata proof,
583         bool[] calldata proofFlags,
584         bytes32[] memory leaves
585     ) internal pure returns (bytes32 merkleRoot) {
586         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
587         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
588         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
589         // the merkle tree.
590         uint256 leavesLen = leaves.length;
591         uint256 totalHashes = proofFlags.length;
592 
593         // Check proof validity.
594         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
595 
596         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
597         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
598         bytes32[] memory hashes = new bytes32[](totalHashes);
599         uint256 leafPos = 0;
600         uint256 hashPos = 0;
601         uint256 proofPos = 0;
602         // At each step, we compute the next hash using two values:
603         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
604         //   get the next hash.
605         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
606         //   `proof` array.
607         for (uint256 i = 0; i < totalHashes; i++) {
608             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
609             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
610             hashes[i] = _hashPair(a, b);
611         }
612 
613         if (totalHashes > 0) {
614             return hashes[totalHashes - 1];
615         } else if (leavesLen > 0) {
616             return leaves[0];
617         } else {
618             return proof[0];
619         }
620     }
621 
622     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
623         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
624     }
625 
626     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
627         /// @solidity memory-safe-assembly
628         assembly {
629             mstore(0x00, a)
630             mstore(0x20, b)
631             value := keccak256(0x00, 0x40)
632         }
633     }
634 }
635 
636 // File: @openzeppelin/contracts/utils/Context.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @dev Provides information about the current execution context, including the
645  * sender of the transaction and its data. While these are generally available
646  * via msg.sender and msg.data, they should not be accessed in such a direct
647  * manner, since when dealing with meta-transactions the account sending and
648  * paying for execution may not be the actual sender (as far as an application
649  * is concerned).
650  *
651  * This contract is only required for intermediate, library-like contracts.
652  */
653 abstract contract Context {
654     function _msgSender() internal view virtual returns (address) {
655         return msg.sender;
656     }
657 
658     function _msgData() internal view virtual returns (bytes calldata) {
659         return msg.data;
660     }
661 }
662 
663 // File: @openzeppelin/contracts/access/Ownable.sol
664 
665 
666 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 
671 /**
672  * @dev Contract module which provides a basic access control mechanism, where
673  * there is an account (an owner) that can be granted exclusive access to
674  * specific functions.
675  *
676  * By default, the owner account will be the one that deploys the contract. This
677  * can later be changed with {transferOwnership}.
678  *
679  * This module is used through inheritance. It will make available the modifier
680  * `onlyOwner`, which can be applied to your functions to restrict their use to
681  * the owner.
682  */
683 abstract contract Ownable is Context {
684     address private _owner;
685 
686     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
687 
688     /**
689      * @dev Initializes the contract setting the deployer as the initial owner.
690      */
691     constructor() {
692         _transferOwnership(_msgSender());
693     }
694 
695     /**
696      * @dev Throws if called by any account other than the owner.
697      */
698     modifier onlyOwner() {
699         _checkOwner();
700         _;
701     }
702 
703     /**
704      * @dev Returns the address of the current owner.
705      */
706     function owner() public view virtual returns (address) {
707         return _owner;
708     }
709 
710     /**
711      * @dev Throws if the sender is not the owner.
712      */
713     function _checkOwner() internal view virtual {
714         require(owner() == _msgSender(), "Ownable: caller is not the owner");
715     }
716 
717     /**
718      * @dev Leaves the contract without owner. It will not be possible to call
719      * `onlyOwner` functions anymore. Can only be called by the current owner.
720      *
721      * NOTE: Renouncing ownership will leave the contract without an owner,
722      * thereby removing any functionality that is only available to the owner.
723      */
724     function renounceOwnership() public virtual onlyOwner {
725         _transferOwnership(address(0));
726     }
727 
728     /**
729      * @dev Transfers ownership of the contract to a new account (`newOwner`).
730      * Can only be called by the current owner.
731      */
732     function transferOwnership(address newOwner) public virtual onlyOwner {
733         require(newOwner != address(0), "Ownable: new owner is the zero address");
734         _transferOwnership(newOwner);
735     }
736 
737     /**
738      * @dev Transfers ownership of the contract to a new account (`newOwner`).
739      * Internal function without access restriction.
740      */
741     function _transferOwnership(address newOwner) internal virtual {
742         address oldOwner = _owner;
743         _owner = newOwner;
744         emit OwnershipTransferred(oldOwner, newOwner);
745     }
746 }
747 
748 // File: erc721a/contracts/IERC721A.sol
749 
750 
751 // ERC721A Contracts v4.2.3
752 // Creator: Chiru Labs
753 
754 pragma solidity ^0.8.4;
755 
756 /**
757  * @dev Interface of ERC721A.
758  */
759 interface IERC721A {
760     /**
761      * The caller must own the token or be an approved operator.
762      */
763     error ApprovalCallerNotOwnerNorApproved();
764 
765     /**
766      * The token does not exist.
767      */
768     error ApprovalQueryForNonexistentToken();
769 
770     /**
771      * Cannot query the balance for the zero address.
772      */
773     error BalanceQueryForZeroAddress();
774 
775     /**
776      * Cannot mint to the zero address.
777      */
778     error MintToZeroAddress();
779 
780     /**
781      * The quantity of tokens minted must be more than zero.
782      */
783     error MintZeroQuantity();
784 
785     /**
786      * The token does not exist.
787      */
788     error OwnerQueryForNonexistentToken();
789 
790     /**
791      * The caller must own the token or be an approved operator.
792      */
793     error TransferCallerNotOwnerNorApproved();
794 
795     /**
796      * The token must be owned by `from`.
797      */
798     error TransferFromIncorrectOwner();
799 
800     /**
801      * Cannot safely transfer to a contract that does not implement the
802      * ERC721Receiver interface.
803      */
804     error TransferToNonERC721ReceiverImplementer();
805 
806     /**
807      * Cannot transfer to the zero address.
808      */
809     error TransferToZeroAddress();
810 
811     /**
812      * The token does not exist.
813      */
814     error URIQueryForNonexistentToken();
815 
816     /**
817      * The `quantity` minted with ERC2309 exceeds the safety limit.
818      */
819     error MintERC2309QuantityExceedsLimit();
820 
821     /**
822      * The `extraData` cannot be set on an unintialized ownership slot.
823      */
824     error OwnershipNotInitializedForExtraData();
825 
826     // =============================================================
827     //                            STRUCTS
828     // =============================================================
829 
830     struct TokenOwnership {
831         // The address of the owner.
832         address addr;
833         // Stores the start time of ownership with minimal overhead for tokenomics.
834         uint64 startTimestamp;
835         // Whether the token has been burned.
836         bool burned;
837         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
838         uint24 extraData;
839     }
840 
841     // =============================================================
842     //                         TOKEN COUNTERS
843     // =============================================================
844 
845     /**
846      * @dev Returns the total number of tokens in existence.
847      * Burned tokens will reduce the count.
848      * To get the total number of tokens minted, please see {_totalMinted}.
849      */
850     function totalSupply() external view returns (uint256);
851 
852     // =============================================================
853     //                            IERC165
854     // =============================================================
855 
856     /**
857      * @dev Returns true if this contract implements the interface defined by
858      * `interfaceId`. See the corresponding
859      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
860      * to learn more about how these ids are created.
861      *
862      * This function call must use less than 30000 gas.
863      */
864     function supportsInterface(bytes4 interfaceId) external view returns (bool);
865 
866     // =============================================================
867     //                            IERC721
868     // =============================================================
869 
870     /**
871      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
872      */
873     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
874 
875     /**
876      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
877      */
878     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
879 
880     /**
881      * @dev Emitted when `owner` enables or disables
882      * (`approved`) `operator` to manage all of its assets.
883      */
884     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
885 
886     /**
887      * @dev Returns the number of tokens in `owner`'s account.
888      */
889     function balanceOf(address owner) external view returns (uint256 balance);
890 
891     /**
892      * @dev Returns the owner of the `tokenId` token.
893      *
894      * Requirements:
895      *
896      * - `tokenId` must exist.
897      */
898     function ownerOf(uint256 tokenId) external view returns (address owner);
899 
900     /**
901      * @dev Safely transfers `tokenId` token from `from` to `to`,
902      * checking first that contract recipients are aware of the ERC721 protocol
903      * to prevent tokens from being forever locked.
904      *
905      * Requirements:
906      *
907      * - `from` cannot be the zero address.
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must exist and be owned by `from`.
910      * - If the caller is not `from`, it must be have been allowed to move
911      * this token by either {approve} or {setApprovalForAll}.
912      * - If `to` refers to a smart contract, it must implement
913      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes calldata data
922     ) external payable;
923 
924     /**
925      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) external payable;
932 
933     /**
934      * @dev Transfers `tokenId` from `from` to `to`.
935      *
936      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
937      * whenever possible.
938      *
939      * Requirements:
940      *
941      * - `from` cannot be the zero address.
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must be owned by `from`.
944      * - If the caller is not `from`, it must be approved to move this token
945      * by either {approve} or {setApprovalForAll}.
946      *
947      * Emits a {Transfer} event.
948      */
949     function transferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) external payable;
954 
955     /**
956      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
957      * The approval is cleared when the token is transferred.
958      *
959      * Only a single account can be approved at a time, so approving the
960      * zero address clears previous approvals.
961      *
962      * Requirements:
963      *
964      * - The caller must own the token or be an approved operator.
965      * - `tokenId` must exist.
966      *
967      * Emits an {Approval} event.
968      */
969     function approve(address to, uint256 tokenId) external payable;
970 
971     /**
972      * @dev Approve or remove `operator` as an operator for the caller.
973      * Operators can call {transferFrom} or {safeTransferFrom}
974      * for any token owned by the caller.
975      *
976      * Requirements:
977      *
978      * - The `operator` cannot be the caller.
979      *
980      * Emits an {ApprovalForAll} event.
981      */
982     function setApprovalForAll(address operator, bool _approved) external;
983 
984     /**
985      * @dev Returns the account approved for `tokenId` token.
986      *
987      * Requirements:
988      *
989      * - `tokenId` must exist.
990      */
991     function getApproved(uint256 tokenId) external view returns (address operator);
992 
993     /**
994      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
995      *
996      * See {setApprovalForAll}.
997      */
998     function isApprovedForAll(address owner, address operator) external view returns (bool);
999 
1000     // =============================================================
1001     //                        IERC721Metadata
1002     // =============================================================
1003 
1004     /**
1005      * @dev Returns the token collection name.
1006      */
1007     function name() external view returns (string memory);
1008 
1009     /**
1010      * @dev Returns the token collection symbol.
1011      */
1012     function symbol() external view returns (string memory);
1013 
1014     /**
1015      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1016      */
1017     function tokenURI(uint256 tokenId) external view returns (string memory);
1018 
1019     // =============================================================
1020     //                           IERC2309
1021     // =============================================================
1022 
1023     /**
1024      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1025      * (inclusive) is transferred from `from` to `to`, as defined in the
1026      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1027      *
1028      * See {_mintERC2309} for more details.
1029      */
1030     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1031 }
1032 
1033 // File: erc721a/contracts/ERC721A.sol
1034 
1035 
1036 // ERC721A Contracts v4.2.3
1037 // Creator: Chiru Labs
1038 
1039 pragma solidity ^0.8.4;
1040 
1041 
1042 /**
1043  * @dev Interface of ERC721 token receiver.
1044  */
1045 interface ERC721A__IERC721Receiver {
1046     function onERC721Received(
1047         address operator,
1048         address from,
1049         uint256 tokenId,
1050         bytes calldata data
1051     ) external returns (bytes4);
1052 }
1053 
1054 /**
1055  * @title ERC721A
1056  *
1057  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1058  * Non-Fungible Token Standard, including the Metadata extension.
1059  * Optimized for lower gas during batch mints.
1060  *
1061  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1062  * starting from `_startTokenId()`.
1063  *
1064  * Assumptions:
1065  *
1066  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1067  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1068  */
1069 contract ERC721A is IERC721A {
1070     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1071     struct TokenApprovalRef {
1072         address value;
1073     }
1074 
1075     // =============================================================
1076     //                           CONSTANTS
1077     // =============================================================
1078 
1079     // Mask of an entry in packed address data.
1080     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1081 
1082     // The bit position of `numberMinted` in packed address data.
1083     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1084 
1085     // The bit position of `numberBurned` in packed address data.
1086     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1087 
1088     // The bit position of `aux` in packed address data.
1089     uint256 private constant _BITPOS_AUX = 192;
1090 
1091     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1092     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1093 
1094     // The bit position of `startTimestamp` in packed ownership.
1095     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1096 
1097     // The bit mask of the `burned` bit in packed ownership.
1098     uint256 private constant _BITMASK_BURNED = 1 << 224;
1099 
1100     // The bit position of the `nextInitialized` bit in packed ownership.
1101     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1102 
1103     // The bit mask of the `nextInitialized` bit in packed ownership.
1104     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1105 
1106     // The bit position of `extraData` in packed ownership.
1107     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1108 
1109     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1110     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1111 
1112     // The mask of the lower 160 bits for addresses.
1113     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1114 
1115     // The maximum `quantity` that can be minted with {_mintERC2309}.
1116     // This limit is to prevent overflows on the address data entries.
1117     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1118     // is required to cause an overflow, which is unrealistic.
1119     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1120 
1121     // The `Transfer` event signature is given by:
1122     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1123     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1124         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1125 
1126     // =============================================================
1127     //                            STORAGE
1128     // =============================================================
1129 
1130     // The next token ID to be minted.
1131     uint256 private _currentIndex;
1132 
1133     // The number of tokens burned.
1134     uint256 private _burnCounter;
1135 
1136     // Token name
1137     string private _name;
1138 
1139     // Token symbol
1140     string private _symbol;
1141 
1142     // Mapping from token ID to ownership details
1143     // An empty struct value does not necessarily mean the token is unowned.
1144     // See {_packedOwnershipOf} implementation for details.
1145     //
1146     // Bits Layout:
1147     // - [0..159]   `addr`
1148     // - [160..223] `startTimestamp`
1149     // - [224]      `burned`
1150     // - [225]      `nextInitialized`
1151     // - [232..255] `extraData`
1152     mapping(uint256 => uint256) private _packedOwnerships;
1153 
1154     // Mapping owner address to address data.
1155     //
1156     // Bits Layout:
1157     // - [0..63]    `balance`
1158     // - [64..127]  `numberMinted`
1159     // - [128..191] `numberBurned`
1160     // - [192..255] `aux`
1161     mapping(address => uint256) private _packedAddressData;
1162 
1163     // Mapping from token ID to approved address.
1164     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1165 
1166     // Mapping from owner to operator approvals
1167     mapping(address => mapping(address => bool)) private _operatorApprovals;
1168 
1169     // =============================================================
1170     //                          CONSTRUCTOR
1171     // =============================================================
1172 
1173     constructor(string memory name_, string memory symbol_) {
1174         _name = name_;
1175         _symbol = symbol_;
1176         _currentIndex = _startTokenId();
1177     }
1178 
1179     // =============================================================
1180     //                   TOKEN COUNTING OPERATIONS
1181     // =============================================================
1182 
1183     /**
1184      * @dev Returns the starting token ID.
1185      * To change the starting token ID, please override this function.
1186      */
1187     function _startTokenId() internal view virtual returns (uint256) {
1188         return 0;
1189     }
1190 
1191     /**
1192      * @dev Returns the next token ID to be minted.
1193      */
1194     function _nextTokenId() internal view virtual returns (uint256) {
1195         return _currentIndex;
1196     }
1197 
1198     /**
1199      * @dev Returns the total number of tokens in existence.
1200      * Burned tokens will reduce the count.
1201      * To get the total number of tokens minted, please see {_totalMinted}.
1202      */
1203     function totalSupply() public view virtual override returns (uint256) {
1204         // Counter underflow is impossible as _burnCounter cannot be incremented
1205         // more than `_currentIndex - _startTokenId()` times.
1206         unchecked {
1207             return _currentIndex - _burnCounter - _startTokenId();
1208         }
1209     }
1210 
1211     /**
1212      * @dev Returns the total amount of tokens minted in the contract.
1213      */
1214     function _totalMinted() internal view virtual returns (uint256) {
1215         // Counter underflow is impossible as `_currentIndex` does not decrement,
1216         // and it is initialized to `_startTokenId()`.
1217         unchecked {
1218             return _currentIndex - _startTokenId();
1219         }
1220     }
1221 
1222     /**
1223      * @dev Returns the total number of tokens burned.
1224      */
1225     function _totalBurned() internal view virtual returns (uint256) {
1226         return _burnCounter;
1227     }
1228 
1229     // =============================================================
1230     //                    ADDRESS DATA OPERATIONS
1231     // =============================================================
1232 
1233     /**
1234      * @dev Returns the number of tokens in `owner`'s account.
1235      */
1236     function balanceOf(address owner) public view virtual override returns (uint256) {
1237         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1238         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1239     }
1240 
1241     /**
1242      * Returns the number of tokens minted by `owner`.
1243      */
1244     function _numberMinted(address owner) internal view returns (uint256) {
1245         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1246     }
1247 
1248     /**
1249      * Returns the number of tokens burned by or on behalf of `owner`.
1250      */
1251     function _numberBurned(address owner) internal view returns (uint256) {
1252         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1253     }
1254 
1255     /**
1256      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1257      */
1258     function _getAux(address owner) internal view returns (uint64) {
1259         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1260     }
1261 
1262     /**
1263      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1264      * If there are multiple variables, please pack them into a uint64.
1265      */
1266     function _setAux(address owner, uint64 aux) internal virtual {
1267         uint256 packed = _packedAddressData[owner];
1268         uint256 auxCasted;
1269         // Cast `aux` with assembly to avoid redundant masking.
1270         assembly {
1271             auxCasted := aux
1272         }
1273         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1274         _packedAddressData[owner] = packed;
1275     }
1276 
1277     // =============================================================
1278     //                            IERC165
1279     // =============================================================
1280 
1281     /**
1282      * @dev Returns true if this contract implements the interface defined by
1283      * `interfaceId`. See the corresponding
1284      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1285      * to learn more about how these ids are created.
1286      *
1287      * This function call must use less than 30000 gas.
1288      */
1289     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1290         // The interface IDs are constants representing the first 4 bytes
1291         // of the XOR of all function selectors in the interface.
1292         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1293         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1294         return
1295             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1296             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1297             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1298     }
1299 
1300     // =============================================================
1301     //                        IERC721Metadata
1302     // =============================================================
1303 
1304     /**
1305      * @dev Returns the token collection name.
1306      */
1307     function name() public view virtual override returns (string memory) {
1308         return _name;
1309     }
1310 
1311     /**
1312      * @dev Returns the token collection symbol.
1313      */
1314     function symbol() public view virtual override returns (string memory) {
1315         return _symbol;
1316     }
1317 
1318     /**
1319      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1320      */
1321     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1322         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1323 
1324         string memory baseURI = _baseURI();
1325         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1326     }
1327 
1328     /**
1329      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1330      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1331      * by default, it can be overridden in child contracts.
1332      */
1333     function _baseURI() internal view virtual returns (string memory) {
1334         return '';
1335     }
1336 
1337     // =============================================================
1338     //                     OWNERSHIPS OPERATIONS
1339     // =============================================================
1340 
1341     /**
1342      * @dev Returns the owner of the `tokenId` token.
1343      *
1344      * Requirements:
1345      *
1346      * - `tokenId` must exist.
1347      */
1348     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1349         return address(uint160(_packedOwnershipOf(tokenId)));
1350     }
1351 
1352     /**
1353      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1354      * It gradually moves to O(1) as tokens get transferred around over time.
1355      */
1356     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1357         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1358     }
1359 
1360     /**
1361      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1362      */
1363     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1364         return _unpackedOwnership(_packedOwnerships[index]);
1365     }
1366 
1367     /**
1368      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1369      */
1370     function _initializeOwnershipAt(uint256 index) internal virtual {
1371         if (_packedOwnerships[index] == 0) {
1372             _packedOwnerships[index] = _packedOwnershipOf(index);
1373         }
1374     }
1375 
1376     /**
1377      * Returns the packed ownership data of `tokenId`.
1378      */
1379     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1380         uint256 curr = tokenId;
1381 
1382         unchecked {
1383             if (_startTokenId() <= curr)
1384                 if (curr < _currentIndex) {
1385                     uint256 packed = _packedOwnerships[curr];
1386                     // If not burned.
1387                     if (packed & _BITMASK_BURNED == 0) {
1388                         // Invariant:
1389                         // There will always be an initialized ownership slot
1390                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1391                         // before an unintialized ownership slot
1392                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1393                         // Hence, `curr` will not underflow.
1394                         //
1395                         // We can directly compare the packed value.
1396                         // If the address is zero, packed will be zero.
1397                         while (packed == 0) {
1398                             packed = _packedOwnerships[--curr];
1399                         }
1400                         return packed;
1401                     }
1402                 }
1403         }
1404         revert OwnerQueryForNonexistentToken();
1405     }
1406 
1407     /**
1408      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1409      */
1410     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1411         ownership.addr = address(uint160(packed));
1412         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1413         ownership.burned = packed & _BITMASK_BURNED != 0;
1414         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1415     }
1416 
1417     /**
1418      * @dev Packs ownership data into a single uint256.
1419      */
1420     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1421         assembly {
1422             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1423             owner := and(owner, _BITMASK_ADDRESS)
1424             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1425             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1426         }
1427     }
1428 
1429     /**
1430      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1431      */
1432     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1433         // For branchless setting of the `nextInitialized` flag.
1434         assembly {
1435             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1436             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1437         }
1438     }
1439 
1440     // =============================================================
1441     //                      APPROVAL OPERATIONS
1442     // =============================================================
1443 
1444     /**
1445      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1446      * The approval is cleared when the token is transferred.
1447      *
1448      * Only a single account can be approved at a time, so approving the
1449      * zero address clears previous approvals.
1450      *
1451      * Requirements:
1452      *
1453      * - The caller must own the token or be an approved operator.
1454      * - `tokenId` must exist.
1455      *
1456      * Emits an {Approval} event.
1457      */
1458     function approve(address to, uint256 tokenId) public payable virtual override {
1459         address owner = ownerOf(tokenId);
1460 
1461         if (_msgSenderERC721A() != owner)
1462             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1463                 revert ApprovalCallerNotOwnerNorApproved();
1464             }
1465 
1466         _tokenApprovals[tokenId].value = to;
1467         emit Approval(owner, to, tokenId);
1468     }
1469 
1470     /**
1471      * @dev Returns the account approved for `tokenId` token.
1472      *
1473      * Requirements:
1474      *
1475      * - `tokenId` must exist.
1476      */
1477     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1478         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1479 
1480         return _tokenApprovals[tokenId].value;
1481     }
1482 
1483     /**
1484      * @dev Approve or remove `operator` as an operator for the caller.
1485      * Operators can call {transferFrom} or {safeTransferFrom}
1486      * for any token owned by the caller.
1487      *
1488      * Requirements:
1489      *
1490      * - The `operator` cannot be the caller.
1491      *
1492      * Emits an {ApprovalForAll} event.
1493      */
1494     function setApprovalForAll(address operator, bool approved) public virtual override {
1495         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1496         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1497     }
1498 
1499     /**
1500      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1501      *
1502      * See {setApprovalForAll}.
1503      */
1504     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1505         return _operatorApprovals[owner][operator];
1506     }
1507 
1508     /**
1509      * @dev Returns whether `tokenId` exists.
1510      *
1511      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1512      *
1513      * Tokens start existing when they are minted. See {_mint}.
1514      */
1515     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1516         return
1517             _startTokenId() <= tokenId &&
1518             tokenId < _currentIndex && // If within bounds,
1519             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1520     }
1521 
1522     /**
1523      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1524      */
1525     function _isSenderApprovedOrOwner(
1526         address approvedAddress,
1527         address owner,
1528         address msgSender
1529     ) private pure returns (bool result) {
1530         assembly {
1531             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1532             owner := and(owner, _BITMASK_ADDRESS)
1533             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1534             msgSender := and(msgSender, _BITMASK_ADDRESS)
1535             // `msgSender == owner || msgSender == approvedAddress`.
1536             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1537         }
1538     }
1539 
1540     /**
1541      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1542      */
1543     function _getApprovedSlotAndAddress(uint256 tokenId)
1544         private
1545         view
1546         returns (uint256 approvedAddressSlot, address approvedAddress)
1547     {
1548         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1549         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1550         assembly {
1551             approvedAddressSlot := tokenApproval.slot
1552             approvedAddress := sload(approvedAddressSlot)
1553         }
1554     }
1555 
1556     // =============================================================
1557     //                      TRANSFER OPERATIONS
1558     // =============================================================
1559 
1560     /**
1561      * @dev Transfers `tokenId` from `from` to `to`.
1562      *
1563      * Requirements:
1564      *
1565      * - `from` cannot be the zero address.
1566      * - `to` cannot be the zero address.
1567      * - `tokenId` token must be owned by `from`.
1568      * - If the caller is not `from`, it must be approved to move this token
1569      * by either {approve} or {setApprovalForAll}.
1570      *
1571      * Emits a {Transfer} event.
1572      */
1573     function transferFrom(
1574         address from,
1575         address to,
1576         uint256 tokenId
1577     ) public payable virtual override {
1578         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1579 
1580         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1581 
1582         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1583 
1584         // The nested ifs save around 20+ gas over a compound boolean condition.
1585         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1586             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1587 
1588         if (to == address(0)) revert TransferToZeroAddress();
1589 
1590         _beforeTokenTransfers(from, to, tokenId, 1);
1591 
1592         // Clear approvals from the previous owner.
1593         assembly {
1594             if approvedAddress {
1595                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1596                 sstore(approvedAddressSlot, 0)
1597             }
1598         }
1599 
1600         // Underflow of the sender's balance is impossible because we check for
1601         // ownership above and the recipient's balance can't realistically overflow.
1602         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1603         unchecked {
1604             // We can directly increment and decrement the balances.
1605             --_packedAddressData[from]; // Updates: `balance -= 1`.
1606             ++_packedAddressData[to]; // Updates: `balance += 1`.
1607 
1608             // Updates:
1609             // - `address` to the next owner.
1610             // - `startTimestamp` to the timestamp of transfering.
1611             // - `burned` to `false`.
1612             // - `nextInitialized` to `true`.
1613             _packedOwnerships[tokenId] = _packOwnershipData(
1614                 to,
1615                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1616             );
1617 
1618             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1619             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1620                 uint256 nextTokenId = tokenId + 1;
1621                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1622                 if (_packedOwnerships[nextTokenId] == 0) {
1623                     // If the next slot is within bounds.
1624                     if (nextTokenId != _currentIndex) {
1625                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1626                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1627                     }
1628                 }
1629             }
1630         }
1631 
1632         emit Transfer(from, to, tokenId);
1633         _afterTokenTransfers(from, to, tokenId, 1);
1634     }
1635 
1636     /**
1637      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1638      */
1639     function safeTransferFrom(
1640         address from,
1641         address to,
1642         uint256 tokenId
1643     ) public payable virtual override {
1644         safeTransferFrom(from, to, tokenId, '');
1645     }
1646 
1647     /**
1648      * @dev Safely transfers `tokenId` token from `from` to `to`.
1649      *
1650      * Requirements:
1651      *
1652      * - `from` cannot be the zero address.
1653      * - `to` cannot be the zero address.
1654      * - `tokenId` token must exist and be owned by `from`.
1655      * - If the caller is not `from`, it must be approved to move this token
1656      * by either {approve} or {setApprovalForAll}.
1657      * - If `to` refers to a smart contract, it must implement
1658      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1659      *
1660      * Emits a {Transfer} event.
1661      */
1662     function safeTransferFrom(
1663         address from,
1664         address to,
1665         uint256 tokenId,
1666         bytes memory _data
1667     ) public payable virtual override {
1668         transferFrom(from, to, tokenId);
1669         if (to.code.length != 0)
1670             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1671                 revert TransferToNonERC721ReceiverImplementer();
1672             }
1673     }
1674 
1675     /**
1676      * @dev Hook that is called before a set of serially-ordered token IDs
1677      * are about to be transferred. This includes minting.
1678      * And also called before burning one token.
1679      *
1680      * `startTokenId` - the first token ID to be transferred.
1681      * `quantity` - the amount to be transferred.
1682      *
1683      * Calling conditions:
1684      *
1685      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1686      * transferred to `to`.
1687      * - When `from` is zero, `tokenId` will be minted for `to`.
1688      * - When `to` is zero, `tokenId` will be burned by `from`.
1689      * - `from` and `to` are never both zero.
1690      */
1691     function _beforeTokenTransfers(
1692         address from,
1693         address to,
1694         uint256 startTokenId,
1695         uint256 quantity
1696     ) internal virtual {}
1697 
1698     /**
1699      * @dev Hook that is called after a set of serially-ordered token IDs
1700      * have been transferred. This includes minting.
1701      * And also called after one token has been burned.
1702      *
1703      * `startTokenId` - the first token ID to be transferred.
1704      * `quantity` - the amount to be transferred.
1705      *
1706      * Calling conditions:
1707      *
1708      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1709      * transferred to `to`.
1710      * - When `from` is zero, `tokenId` has been minted for `to`.
1711      * - When `to` is zero, `tokenId` has been burned by `from`.
1712      * - `from` and `to` are never both zero.
1713      */
1714     function _afterTokenTransfers(
1715         address from,
1716         address to,
1717         uint256 startTokenId,
1718         uint256 quantity
1719     ) internal virtual {}
1720 
1721     /**
1722      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1723      *
1724      * `from` - Previous owner of the given token ID.
1725      * `to` - Target address that will receive the token.
1726      * `tokenId` - Token ID to be transferred.
1727      * `_data` - Optional data to send along with the call.
1728      *
1729      * Returns whether the call correctly returned the expected magic value.
1730      */
1731     function _checkContractOnERC721Received(
1732         address from,
1733         address to,
1734         uint256 tokenId,
1735         bytes memory _data
1736     ) private returns (bool) {
1737         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1738             bytes4 retval
1739         ) {
1740             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1741         } catch (bytes memory reason) {
1742             if (reason.length == 0) {
1743                 revert TransferToNonERC721ReceiverImplementer();
1744             } else {
1745                 assembly {
1746                     revert(add(32, reason), mload(reason))
1747                 }
1748             }
1749         }
1750     }
1751 
1752     // =============================================================
1753     //                        MINT OPERATIONS
1754     // =============================================================
1755 
1756     /**
1757      * @dev Mints `quantity` tokens and transfers them to `to`.
1758      *
1759      * Requirements:
1760      *
1761      * - `to` cannot be the zero address.
1762      * - `quantity` must be greater than 0.
1763      *
1764      * Emits a {Transfer} event for each mint.
1765      */
1766     function _mint(address to, uint256 quantity) internal virtual {
1767         uint256 startTokenId = _currentIndex;
1768         if (quantity == 0) revert MintZeroQuantity();
1769 
1770         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1771 
1772         // Overflows are incredibly unrealistic.
1773         // `balance` and `numberMinted` have a maximum limit of 2**64.
1774         // `tokenId` has a maximum limit of 2**256.
1775         unchecked {
1776             // Updates:
1777             // - `balance += quantity`.
1778             // - `numberMinted += quantity`.
1779             //
1780             // We can directly add to the `balance` and `numberMinted`.
1781             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1782 
1783             // Updates:
1784             // - `address` to the owner.
1785             // - `startTimestamp` to the timestamp of minting.
1786             // - `burned` to `false`.
1787             // - `nextInitialized` to `quantity == 1`.
1788             _packedOwnerships[startTokenId] = _packOwnershipData(
1789                 to,
1790                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1791             );
1792 
1793             uint256 toMasked;
1794             uint256 end = startTokenId + quantity;
1795 
1796             // Use assembly to loop and emit the `Transfer` event for gas savings.
1797             // The duplicated `log4` removes an extra check and reduces stack juggling.
1798             // The assembly, together with the surrounding Solidity code, have been
1799             // delicately arranged to nudge the compiler into producing optimized opcodes.
1800             assembly {
1801                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1802                 toMasked := and(to, _BITMASK_ADDRESS)
1803                 // Emit the `Transfer` event.
1804                 log4(
1805                     0, // Start of data (0, since no data).
1806                     0, // End of data (0, since no data).
1807                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1808                     0, // `address(0)`.
1809                     toMasked, // `to`.
1810                     startTokenId // `tokenId`.
1811                 )
1812 
1813                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1814                 // that overflows uint256 will make the loop run out of gas.
1815                 // The compiler will optimize the `iszero` away for performance.
1816                 for {
1817                     let tokenId := add(startTokenId, 1)
1818                 } iszero(eq(tokenId, end)) {
1819                     tokenId := add(tokenId, 1)
1820                 } {
1821                     // Emit the `Transfer` event. Similar to above.
1822                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1823                 }
1824             }
1825             if (toMasked == 0) revert MintToZeroAddress();
1826 
1827             _currentIndex = end;
1828         }
1829         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1830     }
1831 
1832     /**
1833      * @dev Mints `quantity` tokens and transfers them to `to`.
1834      *
1835      * This function is intended for efficient minting only during contract creation.
1836      *
1837      * It emits only one {ConsecutiveTransfer} as defined in
1838      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1839      * instead of a sequence of {Transfer} event(s).
1840      *
1841      * Calling this function outside of contract creation WILL make your contract
1842      * non-compliant with the ERC721 standard.
1843      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1844      * {ConsecutiveTransfer} event is only permissible during contract creation.
1845      *
1846      * Requirements:
1847      *
1848      * - `to` cannot be the zero address.
1849      * - `quantity` must be greater than 0.
1850      *
1851      * Emits a {ConsecutiveTransfer} event.
1852      */
1853     function _mintERC2309(address to, uint256 quantity) internal virtual {
1854         uint256 startTokenId = _currentIndex;
1855         if (to == address(0)) revert MintToZeroAddress();
1856         if (quantity == 0) revert MintZeroQuantity();
1857         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1858 
1859         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1860 
1861         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1862         unchecked {
1863             // Updates:
1864             // - `balance += quantity`.
1865             // - `numberMinted += quantity`.
1866             //
1867             // We can directly add to the `balance` and `numberMinted`.
1868             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1869 
1870             // Updates:
1871             // - `address` to the owner.
1872             // - `startTimestamp` to the timestamp of minting.
1873             // - `burned` to `false`.
1874             // - `nextInitialized` to `quantity == 1`.
1875             _packedOwnerships[startTokenId] = _packOwnershipData(
1876                 to,
1877                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1878             );
1879 
1880             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1881 
1882             _currentIndex = startTokenId + quantity;
1883         }
1884         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1885     }
1886 
1887     /**
1888      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1889      *
1890      * Requirements:
1891      *
1892      * - If `to` refers to a smart contract, it must implement
1893      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1894      * - `quantity` must be greater than 0.
1895      *
1896      * See {_mint}.
1897      *
1898      * Emits a {Transfer} event for each mint.
1899      */
1900     function _safeMint(
1901         address to,
1902         uint256 quantity,
1903         bytes memory _data
1904     ) internal virtual {
1905         _mint(to, quantity);
1906 
1907         unchecked {
1908             if (to.code.length != 0) {
1909                 uint256 end = _currentIndex;
1910                 uint256 index = end - quantity;
1911                 do {
1912                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1913                         revert TransferToNonERC721ReceiverImplementer();
1914                     }
1915                 } while (index < end);
1916                 // Reentrancy protection.
1917                 if (_currentIndex != end) revert();
1918             }
1919         }
1920     }
1921 
1922     /**
1923      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1924      */
1925     function _safeMint(address to, uint256 quantity) internal virtual {
1926         _safeMint(to, quantity, '');
1927     }
1928 
1929     // =============================================================
1930     //                        BURN OPERATIONS
1931     // =============================================================
1932 
1933     /**
1934      * @dev Equivalent to `_burn(tokenId, false)`.
1935      */
1936     function _burn(uint256 tokenId) internal virtual {
1937         _burn(tokenId, false);
1938     }
1939 
1940     /**
1941      * @dev Destroys `tokenId`.
1942      * The approval is cleared when the token is burned.
1943      *
1944      * Requirements:
1945      *
1946      * - `tokenId` must exist.
1947      *
1948      * Emits a {Transfer} event.
1949      */
1950     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1951         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1952 
1953         address from = address(uint160(prevOwnershipPacked));
1954 
1955         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1956 
1957         if (approvalCheck) {
1958             // The nested ifs save around 20+ gas over a compound boolean condition.
1959             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1960                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1961         }
1962 
1963         _beforeTokenTransfers(from, address(0), tokenId, 1);
1964 
1965         // Clear approvals from the previous owner.
1966         assembly {
1967             if approvedAddress {
1968                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1969                 sstore(approvedAddressSlot, 0)
1970             }
1971         }
1972 
1973         // Underflow of the sender's balance is impossible because we check for
1974         // ownership above and the recipient's balance can't realistically overflow.
1975         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1976         unchecked {
1977             // Updates:
1978             // - `balance -= 1`.
1979             // - `numberBurned += 1`.
1980             //
1981             // We can directly decrement the balance, and increment the number burned.
1982             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1983             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1984 
1985             // Updates:
1986             // - `address` to the last owner.
1987             // - `startTimestamp` to the timestamp of burning.
1988             // - `burned` to `true`.
1989             // - `nextInitialized` to `true`.
1990             _packedOwnerships[tokenId] = _packOwnershipData(
1991                 from,
1992                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1993             );
1994 
1995             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1996             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1997                 uint256 nextTokenId = tokenId + 1;
1998                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1999                 if (_packedOwnerships[nextTokenId] == 0) {
2000                     // If the next slot is within bounds.
2001                     if (nextTokenId != _currentIndex) {
2002                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2003                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2004                     }
2005                 }
2006             }
2007         }
2008 
2009         emit Transfer(from, address(0), tokenId);
2010         _afterTokenTransfers(from, address(0), tokenId, 1);
2011 
2012         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2013         unchecked {
2014             _burnCounter++;
2015         }
2016     }
2017 
2018     // =============================================================
2019     //                     EXTRA DATA OPERATIONS
2020     // =============================================================
2021 
2022     /**
2023      * @dev Directly sets the extra data for the ownership data `index`.
2024      */
2025     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2026         uint256 packed = _packedOwnerships[index];
2027         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2028         uint256 extraDataCasted;
2029         // Cast `extraData` with assembly to avoid redundant masking.
2030         assembly {
2031             extraDataCasted := extraData
2032         }
2033         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2034         _packedOwnerships[index] = packed;
2035     }
2036 
2037     /**
2038      * @dev Called during each token transfer to set the 24bit `extraData` field.
2039      * Intended to be overridden by the cosumer contract.
2040      *
2041      * `previousExtraData` - the value of `extraData` before transfer.
2042      *
2043      * Calling conditions:
2044      *
2045      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2046      * transferred to `to`.
2047      * - When `from` is zero, `tokenId` will be minted for `to`.
2048      * - When `to` is zero, `tokenId` will be burned by `from`.
2049      * - `from` and `to` are never both zero.
2050      */
2051     function _extraData(
2052         address from,
2053         address to,
2054         uint24 previousExtraData
2055     ) internal view virtual returns (uint24) {}
2056 
2057     /**
2058      * @dev Returns the next extra data for the packed ownership data.
2059      * The returned result is shifted into position.
2060      */
2061     function _nextExtraData(
2062         address from,
2063         address to,
2064         uint256 prevOwnershipPacked
2065     ) private view returns (uint256) {
2066         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2067         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2068     }
2069 
2070     // =============================================================
2071     //                       OTHER OPERATIONS
2072     // =============================================================
2073 
2074     /**
2075      * @dev Returns the message sender (defaults to `msg.sender`).
2076      *
2077      * If you are writing GSN compatible contracts, you need to override this function.
2078      */
2079     function _msgSenderERC721A() internal view virtual returns (address) {
2080         return msg.sender;
2081     }
2082 
2083     /**
2084      * @dev Converts a uint256 to its ASCII string decimal representation.
2085      */
2086     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2087         assembly {
2088             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2089             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2090             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2091             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2092             let m := add(mload(0x40), 0xa0)
2093             // Update the free memory pointer to allocate.
2094             mstore(0x40, m)
2095             // Assign the `str` to the end.
2096             str := sub(m, 0x20)
2097             // Zeroize the slot after the string.
2098             mstore(str, 0)
2099 
2100             // Cache the end of the memory to calculate the length later.
2101             let end := str
2102 
2103             // We write the string from rightmost digit to leftmost digit.
2104             // The following is essentially a do-while loop that also handles the zero case.
2105             // prettier-ignore
2106             for { let temp := value } 1 {} {
2107                 str := sub(str, 1)
2108                 // Write the character to the pointer.
2109                 // The ASCII index of the '0' character is 48.
2110                 mstore8(str, add(48, mod(temp, 10)))
2111                 // Keep dividing `temp` until zero.
2112                 temp := div(temp, 10)
2113                 // prettier-ignore
2114                 if iszero(temp) { break }
2115             }
2116 
2117             let length := sub(end, str)
2118             // Move the pointer 32 bytes leftwards to make room for the length.
2119             str := sub(str, 0x20)
2120             // Store the length.
2121             mstore(str, length)
2122         }
2123     }
2124 }
2125 
2126 // File: contracts/4_SproutsAcademy.sol
2127 
2128 
2129 pragma solidity ^0.8.0;
2130 
2131 
2132 
2133 
2134 
2135 interface IWLCC {
2136   function ownerOf(uint256 tokenId) external returns (address);
2137 
2138   function balanceOf(address holderAddress) external returns (uint256);
2139 }
2140 
2141 interface IStakingWLCC {
2142   function tokenOwners(uint256 tokenId) external returns (address);
2143 
2144   function stakedTokens(address holderAddress) external returns (uint256);
2145 }
2146 
2147 contract SproutAcademy is ERC721A, Ownable {
2148     using StringsUpgradeable for uint256;
2149 
2150     uint256 public constant MAX_SUPPLY = 5000;
2151     uint256 public constant MAX_PUBLIC_MINT = 1;
2152     uint256 public constant MAX_WHITELIST_MINT = 1;
2153     uint256 public constant MAX_WLCC_MINT = 10;
2154 
2155     string public baseTokenURI;
2156 
2157     address public wlccContractAddress;
2158     address public wlccStakingContractAddress;
2159 
2160     bool public publicSale;
2161     bool public whiteListSale;
2162     bool public wlccSale;
2163 
2164     bytes32 private merkleRoot;
2165 
2166     mapping(address => uint256) public totalPublicMint;
2167     mapping(address => uint256) public totalWhitelistMint;
2168     mapping(address => uint256) public totalWlccMint;
2169     mapping(uint256 => bool) internal tokenIdToClaimed;
2170 
2171     constructor() ERC721A("Sprout Academy", "SPROUT"){
2172 
2173     }
2174 
2175     modifier callerIsUser() {
2176         require(tx.origin == msg.sender, "Sprout Academy :: Cannot be called by a contract");
2177         _;
2178     }
2179 
2180     function mintWLCC(uint256[] memory tokenIds) external callerIsUser {
2181         require(wlccSale, "Sprout Academy :: Not Yet Active.");
2182         require((totalWlccMint[msg.sender]) <= MAX_WLCC_MINT, "Sprout Academy :: Already minted maximum times!");
2183 
2184         IWLCC wlcc = IWLCC(wlccContractAddress);
2185         IStakingWLCC stakedTokens = IStakingWLCC(wlccStakingContractAddress);
2186 
2187         uint256 wlccCount = wlcc.balanceOf(msg.sender);
2188         uint256 stakingCount = stakedTokens.stakedTokens(msg.sender);
2189 
2190         uint256 claimableCount = wlccCount + stakingCount;
2191         uint256 sproutMintCount = 0;
2192 
2193         if(claimableCount == 1 || claimableCount == 2) {
2194             sproutMintCount = 1;
2195         }
2196         else if(claimableCount > 2 && claimableCount < 5) {
2197             sproutMintCount = 2;
2198         }
2199         else if(claimableCount > 4 && claimableCount < 8) {
2200             sproutMintCount = 5;
2201         }
2202         else if(claimableCount > 7 && claimableCount < 10) {
2203             sproutMintCount = 6;
2204         }
2205         else if(claimableCount > 9) {
2206             sproutMintCount = 10;
2207         }
2208 
2209         for (uint256 i; i < sproutMintCount; i++) {
2210             uint256 wlccTokenId = tokenIds[i];
2211             if (wlcc.ownerOf(wlccTokenId) == msg.sender && !tokenIdToClaimed[wlccTokenId]) {
2212                 _safeMint(msg.sender, 1);
2213 
2214                 tokenIdToClaimed[wlccTokenId] = true;
2215             }
2216             else if(stakedTokens.tokenOwners(wlccTokenId) == msg.sender && !tokenIdToClaimed[wlccTokenId]) {
2217                 _safeMint(msg.sender, 1);
2218 
2219                 tokenIdToClaimed[wlccTokenId] = true;
2220             }
2221         }
2222     }
2223 
2224     function mint() external callerIsUser {
2225         require(publicSale, "Sprout Academy :: Not Yet Active.");
2226         require((totalSupply() + 1) <= MAX_SUPPLY, "Sprout Academy :: Cannot mint beyond max supply");
2227         require((totalPublicMint[msg.sender] + 1) <= MAX_PUBLIC_MINT, "Sprout Academy :: Already minted maximum times!");
2228 
2229         totalPublicMint[msg.sender] += 1;
2230         _safeMint(msg.sender, 1);
2231     }
2232 
2233     function whitelistMint(bytes32[] memory _merkleProof) external callerIsUser {
2234         require(whiteListSale, "Sprout Academy :: Minting is on Pause");
2235         require((totalSupply() + 1) <= MAX_SUPPLY, "Sprout Academy :: Cannot mint beyond max supply");
2236         require((totalWhitelistMint[msg.sender] + 1)  <= MAX_WHITELIST_MINT, "Sprout Academy :: Cannot mint beyond whitelist max mint!");
2237 
2238         //create leaf node
2239         bytes32 sender = keccak256(abi.encodePacked(msg.sender));
2240         require(MerkleProof.verify(_merkleProof, merkleRoot, sender), "Sprout Academy :: You are not on the Sproutlist");
2241 
2242         totalWhitelistMint[msg.sender] += 1;
2243         _safeMint(msg.sender, 1);
2244     }
2245 
2246     function reserveSprouts() external onlyOwner {
2247        _safeMint(msg.sender, 150);
2248     }
2249 
2250 
2251   /// @notice Get uri of tokens
2252   /// @return string Uri
2253   function _baseURI() internal view virtual override returns (string memory) {
2254     return baseTokenURI;
2255   }
2256 
2257    /// @notice Set the WLCC NFT contract address
2258   /// @param wlccAddress Address of the WLCC nft contract
2259   function setWastelandCactusCrewAddress(address wlccAddress) external onlyOwner {
2260     wlccContractAddress = wlccAddress;
2261   }
2262 
2263   // @notice Set the WLCC Staking contract address
2264   /// @param wlccStakingAddress Address of the WLCC nft contract
2265   function setStakingAddress(address wlccStakingAddress) external onlyOwner {
2266     wlccStakingContractAddress = wlccStakingAddress;
2267   }
2268 
2269     //return uri for certain token
2270     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2271         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2272 
2273         uint256 trueId = tokenId + 1;
2274 
2275         //string memory baseURI = _baseURI();
2276         return string(abi.encodePacked(_baseURI(), trueId.toString(), ".json"));
2277     }
2278 
2279     function setTokenUri(string memory _baseTokenUri) external onlyOwner{
2280         baseTokenURI = _baseTokenUri;
2281     }
2282 
2283     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
2284         merkleRoot = _merkleRoot;
2285     }
2286 
2287     function getMerkleRoot() external view returns (bytes32){
2288         return merkleRoot;
2289     }
2290 
2291     function toggleWhiteListSale() external onlyOwner{
2292         whiteListSale = !whiteListSale;
2293     }
2294 
2295     function togglePublicSale() external onlyOwner{
2296         publicSale = !publicSale;
2297     }
2298 
2299     function toggleWlccSale() external onlyOwner{
2300         wlccSale = !wlccSale;
2301     }
2302 }