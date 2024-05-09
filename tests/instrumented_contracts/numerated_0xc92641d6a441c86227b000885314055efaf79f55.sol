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
227 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Interface of the ERC165 standard, as defined in the
236  * https://eips.ethereum.org/EIPS/eip-165[EIP].
237  *
238  * Implementers can declare support of contract interfaces, which can then be
239  * queried by others ({ERC165Checker}).
240  *
241  * For an implementation, see {ERC165}.
242  */
243 interface IERC165 {
244     /**
245      * @dev Returns true if this contract implements the interface defined by
246      * `interfaceId`. See the corresponding
247      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
248      * to learn more about how these ids are created.
249      *
250      * This function call must use less than 30 000 gas.
251      */
252     function supportsInterface(bytes4 interfaceId) external view returns (bool);
253 }
254 
255 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
256 
257 
258 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 
263 /**
264  * @dev Implementation of the {IERC165} interface.
265  *
266  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
267  * for the additional interface id that will be supported. For example:
268  *
269  * ```solidity
270  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
271  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
272  * }
273  * ```
274  *
275  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
276  */
277 abstract contract ERC165 is IERC165 {
278     /**
279      * @dev See {IERC165-supportsInterface}.
280      */
281     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
282         return interfaceId == type(IERC165).interfaceId;
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/math/Math.sol
287 
288 
289 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Standard math utilities missing in the Solidity language.
295  */
296 library Math {
297     enum Rounding {
298         Down, // Toward negative infinity
299         Up, // Toward infinity
300         Zero // Toward zero
301     }
302 
303     /**
304      * @dev Returns the largest of two numbers.
305      */
306     function max(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a > b ? a : b;
308     }
309 
310     /**
311      * @dev Returns the smallest of two numbers.
312      */
313     function min(uint256 a, uint256 b) internal pure returns (uint256) {
314         return a < b ? a : b;
315     }
316 
317     /**
318      * @dev Returns the average of two numbers. The result is rounded towards
319      * zero.
320      */
321     function average(uint256 a, uint256 b) internal pure returns (uint256) {
322         // (a + b) / 2 can overflow.
323         return (a & b) + (a ^ b) / 2;
324     }
325 
326     /**
327      * @dev Returns the ceiling of the division of two numbers.
328      *
329      * This differs from standard division with `/` in that it rounds up instead
330      * of rounding down.
331      */
332     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
333         // (a + b - 1) / b can overflow on addition, so we distribute.
334         return a == 0 ? 0 : (a - 1) / b + 1;
335     }
336 
337     /**
338      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
339      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
340      * with further edits by Uniswap Labs also under MIT license.
341      */
342     function mulDiv(
343         uint256 x,
344         uint256 y,
345         uint256 denominator
346     ) internal pure returns (uint256 result) {
347         unchecked {
348             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
349             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
350             // variables such that product = prod1 * 2^256 + prod0.
351             uint256 prod0; // Least significant 256 bits of the product
352             uint256 prod1; // Most significant 256 bits of the product
353             assembly {
354                 let mm := mulmod(x, y, not(0))
355                 prod0 := mul(x, y)
356                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
357             }
358 
359             // Handle non-overflow cases, 256 by 256 division.
360             if (prod1 == 0) {
361                 return prod0 / denominator;
362             }
363 
364             // Make sure the result is less than 2^256. Also prevents denominator == 0.
365             require(denominator > prod1);
366 
367             ///////////////////////////////////////////////
368             // 512 by 256 division.
369             ///////////////////////////////////////////////
370 
371             // Make division exact by subtracting the remainder from [prod1 prod0].
372             uint256 remainder;
373             assembly {
374                 // Compute remainder using mulmod.
375                 remainder := mulmod(x, y, denominator)
376 
377                 // Subtract 256 bit number from 512 bit number.
378                 prod1 := sub(prod1, gt(remainder, prod0))
379                 prod0 := sub(prod0, remainder)
380             }
381 
382             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
383             // See https://cs.stackexchange.com/q/138556/92363.
384 
385             // Does not overflow because the denominator cannot be zero at this stage in the function.
386             uint256 twos = denominator & (~denominator + 1);
387             assembly {
388                 // Divide denominator by twos.
389                 denominator := div(denominator, twos)
390 
391                 // Divide [prod1 prod0] by twos.
392                 prod0 := div(prod0, twos)
393 
394                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
395                 twos := add(div(sub(0, twos), twos), 1)
396             }
397 
398             // Shift in bits from prod1 into prod0.
399             prod0 |= prod1 * twos;
400 
401             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
402             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
403             // four bits. That is, denominator * inv = 1 mod 2^4.
404             uint256 inverse = (3 * denominator) ^ 2;
405 
406             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
407             // in modular arithmetic, doubling the correct bits in each step.
408             inverse *= 2 - denominator * inverse; // inverse mod 2^8
409             inverse *= 2 - denominator * inverse; // inverse mod 2^16
410             inverse *= 2 - denominator * inverse; // inverse mod 2^32
411             inverse *= 2 - denominator * inverse; // inverse mod 2^64
412             inverse *= 2 - denominator * inverse; // inverse mod 2^128
413             inverse *= 2 - denominator * inverse; // inverse mod 2^256
414 
415             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
416             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
417             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
418             // is no longer required.
419             result = prod0 * inverse;
420             return result;
421         }
422     }
423 
424     /**
425      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
426      */
427     function mulDiv(
428         uint256 x,
429         uint256 y,
430         uint256 denominator,
431         Rounding rounding
432     ) internal pure returns (uint256) {
433         uint256 result = mulDiv(x, y, denominator);
434         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
435             result += 1;
436         }
437         return result;
438     }
439 
440     /**
441      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
442      *
443      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
444      */
445     function sqrt(uint256 a) internal pure returns (uint256) {
446         if (a == 0) {
447             return 0;
448         }
449 
450         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
451         //
452         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
453         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
454         //
455         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
456         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
457         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
458         //
459         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
460         uint256 result = 1 << (log2(a) >> 1);
461 
462         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
463         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
464         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
465         // into the expected uint128 result.
466         unchecked {
467             result = (result + a / result) >> 1;
468             result = (result + a / result) >> 1;
469             result = (result + a / result) >> 1;
470             result = (result + a / result) >> 1;
471             result = (result + a / result) >> 1;
472             result = (result + a / result) >> 1;
473             result = (result + a / result) >> 1;
474             return min(result, a / result);
475         }
476     }
477 
478     /**
479      * @notice Calculates sqrt(a), following the selected rounding direction.
480      */
481     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
482         unchecked {
483             uint256 result = sqrt(a);
484             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
485         }
486     }
487 
488     /**
489      * @dev Return the log in base 2, rounded down, of a positive value.
490      * Returns 0 if given 0.
491      */
492     function log2(uint256 value) internal pure returns (uint256) {
493         uint256 result = 0;
494         unchecked {
495             if (value >> 128 > 0) {
496                 value >>= 128;
497                 result += 128;
498             }
499             if (value >> 64 > 0) {
500                 value >>= 64;
501                 result += 64;
502             }
503             if (value >> 32 > 0) {
504                 value >>= 32;
505                 result += 32;
506             }
507             if (value >> 16 > 0) {
508                 value >>= 16;
509                 result += 16;
510             }
511             if (value >> 8 > 0) {
512                 value >>= 8;
513                 result += 8;
514             }
515             if (value >> 4 > 0) {
516                 value >>= 4;
517                 result += 4;
518             }
519             if (value >> 2 > 0) {
520                 value >>= 2;
521                 result += 2;
522             }
523             if (value >> 1 > 0) {
524                 result += 1;
525             }
526         }
527         return result;
528     }
529 
530     /**
531      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
532      * Returns 0 if given 0.
533      */
534     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
535         unchecked {
536             uint256 result = log2(value);
537             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
538         }
539     }
540 
541     /**
542      * @dev Return the log in base 10, rounded down, of a positive value.
543      * Returns 0 if given 0.
544      */
545     function log10(uint256 value) internal pure returns (uint256) {
546         uint256 result = 0;
547         unchecked {
548             if (value >= 10**64) {
549                 value /= 10**64;
550                 result += 64;
551             }
552             if (value >= 10**32) {
553                 value /= 10**32;
554                 result += 32;
555             }
556             if (value >= 10**16) {
557                 value /= 10**16;
558                 result += 16;
559             }
560             if (value >= 10**8) {
561                 value /= 10**8;
562                 result += 8;
563             }
564             if (value >= 10**4) {
565                 value /= 10**4;
566                 result += 4;
567             }
568             if (value >= 10**2) {
569                 value /= 10**2;
570                 result += 2;
571             }
572             if (value >= 10**1) {
573                 result += 1;
574             }
575         }
576         return result;
577     }
578 
579     /**
580      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
581      * Returns 0 if given 0.
582      */
583     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
584         unchecked {
585             uint256 result = log10(value);
586             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
587         }
588     }
589 
590     /**
591      * @dev Return the log in base 256, rounded down, of a positive value.
592      * Returns 0 if given 0.
593      *
594      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
595      */
596     function log256(uint256 value) internal pure returns (uint256) {
597         uint256 result = 0;
598         unchecked {
599             if (value >> 128 > 0) {
600                 value >>= 128;
601                 result += 16;
602             }
603             if (value >> 64 > 0) {
604                 value >>= 64;
605                 result += 8;
606             }
607             if (value >> 32 > 0) {
608                 value >>= 32;
609                 result += 4;
610             }
611             if (value >> 16 > 0) {
612                 value >>= 16;
613                 result += 2;
614             }
615             if (value >> 8 > 0) {
616                 result += 1;
617             }
618         }
619         return result;
620     }
621 
622     /**
623      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
624      * Returns 0 if given 0.
625      */
626     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
627         unchecked {
628             uint256 result = log256(value);
629             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
630         }
631     }
632 }
633 
634 // File: @openzeppelin/contracts/utils/Strings.sol
635 
636 
637 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 /**
643  * @dev String operations.
644  */
645 library Strings {
646     bytes16 private constant _SYMBOLS = "0123456789abcdef";
647     uint8 private constant _ADDRESS_LENGTH = 20;
648 
649     /**
650      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
651      */
652     function toString(uint256 value) internal pure returns (string memory) {
653         unchecked {
654             uint256 length = Math.log10(value) + 1;
655             string memory buffer = new string(length);
656             uint256 ptr;
657             /// @solidity memory-safe-assembly
658             assembly {
659                 ptr := add(buffer, add(32, length))
660             }
661             while (true) {
662                 ptr--;
663                 /// @solidity memory-safe-assembly
664                 assembly {
665                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
666                 }
667                 value /= 10;
668                 if (value == 0) break;
669             }
670             return buffer;
671         }
672     }
673 
674     /**
675      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
676      */
677     function toHexString(uint256 value) internal pure returns (string memory) {
678         unchecked {
679             return toHexString(value, Math.log256(value) + 1);
680         }
681     }
682 
683     /**
684      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
685      */
686     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
687         bytes memory buffer = new bytes(2 * length + 2);
688         buffer[0] = "0";
689         buffer[1] = "x";
690         for (uint256 i = 2 * length + 1; i > 1; --i) {
691             buffer[i] = _SYMBOLS[value & 0xf];
692             value >>= 4;
693         }
694         require(value == 0, "Strings: hex length insufficient");
695         return string(buffer);
696     }
697 
698     /**
699      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
700      */
701     function toHexString(address addr) internal pure returns (string memory) {
702         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
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
733 // File: @openzeppelin/contracts/access/IAccessControl.sol
734 
735 
736 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
737 
738 pragma solidity ^0.8.0;
739 
740 /**
741  * @dev External interface of AccessControl declared to support ERC165 detection.
742  */
743 interface IAccessControl {
744     /**
745      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
746      *
747      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
748      * {RoleAdminChanged} not being emitted signaling this.
749      *
750      * _Available since v3.1._
751      */
752     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
753 
754     /**
755      * @dev Emitted when `account` is granted `role`.
756      *
757      * `sender` is the account that originated the contract call, an admin role
758      * bearer except when using {AccessControl-_setupRole}.
759      */
760     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
761 
762     /**
763      * @dev Emitted when `account` is revoked `role`.
764      *
765      * `sender` is the account that originated the contract call:
766      *   - if using `revokeRole`, it is the admin role bearer
767      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
768      */
769     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
770 
771     /**
772      * @dev Returns `true` if `account` has been granted `role`.
773      */
774     function hasRole(bytes32 role, address account) external view returns (bool);
775 
776     /**
777      * @dev Returns the admin role that controls `role`. See {grantRole} and
778      * {revokeRole}.
779      *
780      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
781      */
782     function getRoleAdmin(bytes32 role) external view returns (bytes32);
783 
784     /**
785      * @dev Grants `role` to `account`.
786      *
787      * If `account` had not been already granted `role`, emits a {RoleGranted}
788      * event.
789      *
790      * Requirements:
791      *
792      * - the caller must have ``role``'s admin role.
793      */
794     function grantRole(bytes32 role, address account) external;
795 
796     /**
797      * @dev Revokes `role` from `account`.
798      *
799      * If `account` had been granted `role`, emits a {RoleRevoked} event.
800      *
801      * Requirements:
802      *
803      * - the caller must have ``role``'s admin role.
804      */
805     function revokeRole(bytes32 role, address account) external;
806 
807     /**
808      * @dev Revokes `role` from the calling account.
809      *
810      * Roles are often managed via {grantRole} and {revokeRole}: this function's
811      * purpose is to provide a mechanism for accounts to lose their privileges
812      * if they are compromised (such as when a trusted device is misplaced).
813      *
814      * If the calling account had been granted `role`, emits a {RoleRevoked}
815      * event.
816      *
817      * Requirements:
818      *
819      * - the caller must be `account`.
820      */
821     function renounceRole(bytes32 role, address account) external;
822 }
823 
824 // File: @openzeppelin/contracts/access/AccessControl.sol
825 
826 
827 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
828 
829 pragma solidity ^0.8.0;
830 
831 
832 
833 
834 
835 /**
836  * @dev Contract module that allows children to implement role-based access
837  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
838  * members except through off-chain means by accessing the contract event logs. Some
839  * applications may benefit from on-chain enumerability, for those cases see
840  * {AccessControlEnumerable}.
841  *
842  * Roles are referred to by their `bytes32` identifier. These should be exposed
843  * in the external API and be unique. The best way to achieve this is by
844  * using `public constant` hash digests:
845  *
846  * ```
847  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
848  * ```
849  *
850  * Roles can be used to represent a set of permissions. To restrict access to a
851  * function call, use {hasRole}:
852  *
853  * ```
854  * function foo() public {
855  *     require(hasRole(MY_ROLE, msg.sender));
856  *     ...
857  * }
858  * ```
859  *
860  * Roles can be granted and revoked dynamically via the {grantRole} and
861  * {revokeRole} functions. Each role has an associated admin role, and only
862  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
863  *
864  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
865  * that only accounts with this role will be able to grant or revoke other
866  * roles. More complex role relationships can be created by using
867  * {_setRoleAdmin}.
868  *
869  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
870  * grant and revoke this role. Extra precautions should be taken to secure
871  * accounts that have been granted it.
872  */
873 abstract contract AccessControl is Context, IAccessControl, ERC165 {
874     struct RoleData {
875         mapping(address => bool) members;
876         bytes32 adminRole;
877     }
878 
879     mapping(bytes32 => RoleData) private _roles;
880 
881     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
882 
883     /**
884      * @dev Modifier that checks that an account has a specific role. Reverts
885      * with a standardized message including the required role.
886      *
887      * The format of the revert reason is given by the following regular expression:
888      *
889      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
890      *
891      * _Available since v4.1._
892      */
893     modifier onlyRole(bytes32 role) {
894         _checkRole(role);
895         _;
896     }
897 
898     /**
899      * @dev See {IERC165-supportsInterface}.
900      */
901     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
902         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
903     }
904 
905     /**
906      * @dev Returns `true` if `account` has been granted `role`.
907      */
908     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
909         return _roles[role].members[account];
910     }
911 
912     /**
913      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
914      * Overriding this function changes the behavior of the {onlyRole} modifier.
915      *
916      * Format of the revert message is described in {_checkRole}.
917      *
918      * _Available since v4.6._
919      */
920     function _checkRole(bytes32 role) internal view virtual {
921         _checkRole(role, _msgSender());
922     }
923 
924     /**
925      * @dev Revert with a standard message if `account` is missing `role`.
926      *
927      * The format of the revert reason is given by the following regular expression:
928      *
929      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
930      */
931     function _checkRole(bytes32 role, address account) internal view virtual {
932         if (!hasRole(role, account)) {
933             revert(
934                 string(
935                     abi.encodePacked(
936                         "AccessControl: account ",
937                         Strings.toHexString(account),
938                         " is missing role ",
939                         Strings.toHexString(uint256(role), 32)
940                     )
941                 )
942             );
943         }
944     }
945 
946     /**
947      * @dev Returns the admin role that controls `role`. See {grantRole} and
948      * {revokeRole}.
949      *
950      * To change a role's admin, use {_setRoleAdmin}.
951      */
952     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
953         return _roles[role].adminRole;
954     }
955 
956     /**
957      * @dev Grants `role` to `account`.
958      *
959      * If `account` had not been already granted `role`, emits a {RoleGranted}
960      * event.
961      *
962      * Requirements:
963      *
964      * - the caller must have ``role``'s admin role.
965      *
966      * May emit a {RoleGranted} event.
967      */
968     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
969         _grantRole(role, account);
970     }
971 
972     /**
973      * @dev Revokes `role` from `account`.
974      *
975      * If `account` had been granted `role`, emits a {RoleRevoked} event.
976      *
977      * Requirements:
978      *
979      * - the caller must have ``role``'s admin role.
980      *
981      * May emit a {RoleRevoked} event.
982      */
983     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
984         _revokeRole(role, account);
985     }
986 
987     /**
988      * @dev Revokes `role` from the calling account.
989      *
990      * Roles are often managed via {grantRole} and {revokeRole}: this function's
991      * purpose is to provide a mechanism for accounts to lose their privileges
992      * if they are compromised (such as when a trusted device is misplaced).
993      *
994      * If the calling account had been revoked `role`, emits a {RoleRevoked}
995      * event.
996      *
997      * Requirements:
998      *
999      * - the caller must be `account`.
1000      *
1001      * May emit a {RoleRevoked} event.
1002      */
1003     function renounceRole(bytes32 role, address account) public virtual override {
1004         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1005 
1006         _revokeRole(role, account);
1007     }
1008 
1009     /**
1010      * @dev Grants `role` to `account`.
1011      *
1012      * If `account` had not been already granted `role`, emits a {RoleGranted}
1013      * event. Note that unlike {grantRole}, this function doesn't perform any
1014      * checks on the calling account.
1015      *
1016      * May emit a {RoleGranted} event.
1017      *
1018      * [WARNING]
1019      * ====
1020      * This function should only be called from the constructor when setting
1021      * up the initial roles for the system.
1022      *
1023      * Using this function in any other way is effectively circumventing the admin
1024      * system imposed by {AccessControl}.
1025      * ====
1026      *
1027      * NOTE: This function is deprecated in favor of {_grantRole}.
1028      */
1029     function _setupRole(bytes32 role, address account) internal virtual {
1030         _grantRole(role, account);
1031     }
1032 
1033     /**
1034      * @dev Sets `adminRole` as ``role``'s admin role.
1035      *
1036      * Emits a {RoleAdminChanged} event.
1037      */
1038     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1039         bytes32 previousAdminRole = getRoleAdmin(role);
1040         _roles[role].adminRole = adminRole;
1041         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1042     }
1043 
1044     /**
1045      * @dev Grants `role` to `account`.
1046      *
1047      * Internal function without access restriction.
1048      *
1049      * May emit a {RoleGranted} event.
1050      */
1051     function _grantRole(bytes32 role, address account) internal virtual {
1052         if (!hasRole(role, account)) {
1053             _roles[role].members[account] = true;
1054             emit RoleGranted(role, account, _msgSender());
1055         }
1056     }
1057 
1058     /**
1059      * @dev Revokes `role` from `account`.
1060      *
1061      * Internal function without access restriction.
1062      *
1063      * May emit a {RoleRevoked} event.
1064      */
1065     function _revokeRole(bytes32 role, address account) internal virtual {
1066         if (hasRole(role, account)) {
1067             _roles[role].members[account] = false;
1068             emit RoleRevoked(role, account, _msgSender());
1069         }
1070     }
1071 }
1072 
1073 // File: contracts/MintingModule.sol
1074 
1075 
1076 pragma solidity ^0.8.17;
1077 
1078 error AddressAlreadyMinted();
1079 error ProofInvalidOrNotInAllowlist();
1080 error PublicMintingDisabled();
1081 error AllowlistMintingDisabled();
1082 error NotEnoughEth();
1083 error TransferFailed();
1084 error InvalidTreasury();
1085 
1086 
1087 
1088 interface IPassport {
1089   function mintPassport(address to) external returns (uint256);
1090 }
1091 
1092 interface HashingModule {
1093   function storeTokenHash(uint256 tokenId) external;
1094 }
1095 
1096 interface LegacyMintingModule {
1097   function minted(address minter) external returns (bool);
1098 }
1099 
1100 contract MintingModule is AccessControl {
1101   IPassport public decagon;
1102   HashingModule public hashingModule;
1103   LegacyMintingModule public legacyMintingModule;
1104 
1105   mapping(address => bool) public minted;
1106   bytes32 public merkleRoot;
1107 
1108   bool public publicMintEnabled;
1109   bool public allowlistMintEnabled;
1110 
1111   uint256 public fee;
1112   uint256 public allowlistFee;
1113 
1114   // Fee management contract
1115   address payable private treasury;
1116 
1117   event PublicMintToggled();
1118   event AllowlistMintToggled();
1119   event MerkleRootSet(bytes32 indexed newMerkleRoot);
1120   event HashingModuleSet(address indexed newHashingModule);
1121   event LegacyMintingModuleSet(address indexed legacyMintingModule);
1122   event PublicFeeSet(uint256 indexed newFee);
1123   event AllowlistFeeSet(uint256 indexed newAllowlistFee);
1124   event TreasuryAddressSet(address indexed newTreasuryAddress);
1125 
1126   constructor(
1127     address decagonContractAddress,
1128     address hashingModuleContractAddress,
1129     address legacyMintingModuleAddress,
1130     uint256 _fee,
1131     uint256 _allowlistFee,
1132     address payable _treasury
1133   ) {
1134     _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1135     decagon = IPassport(decagonContractAddress);
1136     hashingModule = HashingModule(hashingModuleContractAddress);
1137     legacyMintingModule = LegacyMintingModule(legacyMintingModuleAddress);
1138     publicMintEnabled = false;
1139     allowlistMintEnabled = false;
1140     fee = _fee;
1141     allowlistFee = _allowlistFee;
1142     treasury = _treasury;
1143   }
1144 
1145   function mintDecagon() external payable {
1146     if (!publicMintEnabled) revert PublicMintingDisabled();
1147     if (msg.value < fee) revert NotEnoughEth();
1148     _mint();
1149   }
1150 
1151   function mintAllowlistedDecagon(bytes32[] calldata _merkleProof) external payable {
1152     if (!allowlistMintEnabled) revert AllowlistMintingDisabled();
1153     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1154     if (!MerkleProof.verify(_merkleProof, merkleRoot, leaf)) revert ProofInvalidOrNotInAllowlist();
1155     if (msg.value < allowlistFee) revert NotEnoughEth();
1156     _mint();
1157   }
1158 
1159   function _mint() internal {
1160     if (minted[msg.sender]) revert AddressAlreadyMinted();
1161     if (legacyMintingModule.minted(msg.sender)) revert AddressAlreadyMinted();
1162     minted[msg.sender] = true;
1163 
1164     (bool sentTreasury, ) = treasury.call{value: msg.value}("");
1165     if (!sentTreasury) revert TransferFailed();
1166 
1167     uint256 tokenId = decagon.mintPassport(msg.sender);
1168     hashingModule.storeTokenHash(tokenId);
1169   }
1170 
1171   function setMerkleRoot(bytes32 merkleRoot_) external onlyRole(DEFAULT_ADMIN_ROLE) {
1172     merkleRoot = merkleRoot_;
1173     emit MerkleRootSet(merkleRoot_);
1174   }
1175 
1176   function setHashingModule(address newHashingModuleContractAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
1177     hashingModule = HashingModule(newHashingModuleContractAddress);
1178     emit HashingModuleSet(newHashingModuleContractAddress);
1179   }
1180 
1181   function setLegacyMintingModule(address legacyMintingModuleAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
1182     legacyMintingModule = LegacyMintingModule(legacyMintingModuleAddress);
1183     emit LegacyMintingModuleSet(legacyMintingModuleAddress);
1184   }
1185 
1186   function togglePublicMintEnabled() external onlyRole(DEFAULT_ADMIN_ROLE) {
1187     publicMintEnabled = !publicMintEnabled;
1188     emit PublicMintToggled();
1189   }
1190 
1191   function toggleAllowlistMintEnabled() external onlyRole(DEFAULT_ADMIN_ROLE) {
1192     allowlistMintEnabled = !allowlistMintEnabled;
1193     emit AllowlistMintToggled();
1194   }
1195 
1196   function setFee(uint256 newFee) external onlyRole(DEFAULT_ADMIN_ROLE) {
1197     fee = newFee;
1198     emit PublicFeeSet(newFee);
1199   }
1200 
1201   function setAllowlistFee(uint256 newAllowlistFee) external onlyRole(DEFAULT_ADMIN_ROLE) {
1202     allowlistFee = newAllowlistFee;
1203     emit AllowlistFeeSet(newAllowlistFee);
1204   }
1205 
1206   function setTreasury(address payable _newTreasury) external onlyRole(DEFAULT_ADMIN_ROLE) {
1207     if (_newTreasury == address(0)) revert InvalidTreasury();
1208     treasury = _newTreasury;
1209     emit TreasuryAddressSet(_newTreasury);
1210   }
1211 }