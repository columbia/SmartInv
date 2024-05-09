1 pragma solidity 0.8.4;
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
5 /**
6  * @dev These functions deal with verification of Merkle Tree proofs.
7  *
8  * The tree and the proofs can be generated using our
9  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
10  * You will find a quickstart guide in the readme.
11  *
12  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
13  * hashing, or use a hash function other than keccak256 for hashing leaves.
14  * This is because the concatenation of a sorted pair of internal nodes in
15  * the merkle tree could be reinterpreted as a leaf value.
16  * OpenZeppelin's JavaScript library generates merkle trees that are safe
17  * against this attack out of the box.
18  */
19 library MerkleProof {
20     /**
21      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22      * defined by `root`. For this, a `proof` must be provided, containing
23      * sibling hashes on the branch from the leaf to the root of the tree. Each
24      * pair of leaves and each pair of pre-images are assumed to be sorted.
25      */
26     function verify(
27         bytes32[] memory proof,
28         bytes32 root,
29         bytes32 leaf
30     ) internal pure returns (bool) {
31         return processProof(proof, leaf) == root;
32     }
33 
34     /**
35      * @dev Calldata version of {verify}
36      *
37      * _Available since v4.7._
38      */
39     function verifyCalldata(
40         bytes32[] calldata proof,
41         bytes32 root,
42         bytes32 leaf
43     ) internal pure returns (bool) {
44         return processProofCalldata(proof, leaf) == root;
45     }
46 
47     /**
48      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
49      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
50      * hash matches the root of the tree. When processing the proof, the pairs
51      * of leafs & pre-images are assumed to be sorted.
52      *
53      * _Available since v4.4._
54      */
55     function processProof(bytes32[] memory proof, bytes32 leaf)
56         internal
57         pure
58         returns (bytes32)
59     {
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
72     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
73         internal
74         pure
75         returns (bytes32)
76     {
77         bytes32 computedHash = leaf;
78         for (uint256 i = 0; i < proof.length; i++) {
79             computedHash = _hashPair(computedHash, proof[i]);
80         }
81         return computedHash;
82     }
83 
84     /**
85      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
86      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
87      *
88      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
89      *
90      * _Available since v4.7._
91      */
92     function multiProofVerify(
93         bytes32[] memory proof,
94         bool[] memory proofFlags,
95         bytes32 root,
96         bytes32[] memory leaves
97     ) internal pure returns (bool) {
98         return processMultiProof(proof, proofFlags, leaves) == root;
99     }
100 
101     /**
102      * @dev Calldata version of {multiProofVerify}
103      *
104      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
105      *
106      * _Available since v4.7._
107      */
108     function multiProofVerifyCalldata(
109         bytes32[] calldata proof,
110         bool[] calldata proofFlags,
111         bytes32 root,
112         bytes32[] memory leaves
113     ) internal pure returns (bool) {
114         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
115     }
116 
117     /**
118      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
119      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
120      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
121      * respectively.
122      *
123      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
124      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
125      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
126      *
127      * _Available since v4.7._
128      */
129     function processMultiProof(
130         bytes32[] memory proof,
131         bool[] memory proofFlags,
132         bytes32[] memory leaves
133     ) internal pure returns (bytes32 merkleRoot) {
134         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
135         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
136         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
137         // the merkle tree.
138         uint256 leavesLen = leaves.length;
139         uint256 totalHashes = proofFlags.length;
140 
141         // Check proof validity.
142         require(
143             leavesLen + proof.length - 1 == totalHashes,
144             "MerkleProof: invalid multiproof"
145         );
146 
147         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
148         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
149         bytes32[] memory hashes = new bytes32[](totalHashes);
150         uint256 leafPos = 0;
151         uint256 hashPos = 0;
152         uint256 proofPos = 0;
153         // At each step, we compute the next hash using two values:
154         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
155         //   get the next hash.
156         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
157         //   `proof` array.
158         for (uint256 i = 0; i < totalHashes; i++) {
159             bytes32 a = leafPos < leavesLen
160                 ? leaves[leafPos++]
161                 : hashes[hashPos++];
162             bytes32 b = proofFlags[i]
163                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
164                 : proof[proofPos++];
165             hashes[i] = _hashPair(a, b);
166         }
167 
168         if (totalHashes > 0) {
169             return hashes[totalHashes - 1];
170         } else if (leavesLen > 0) {
171             return leaves[0];
172         } else {
173             return proof[0];
174         }
175     }
176 
177     /**
178      * @dev Calldata version of {processMultiProof}.
179      *
180      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
181      *
182      * _Available since v4.7._
183      */
184     function processMultiProofCalldata(
185         bytes32[] calldata proof,
186         bool[] calldata proofFlags,
187         bytes32[] memory leaves
188     ) internal pure returns (bytes32 merkleRoot) {
189         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
190         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
191         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
192         // the merkle tree.
193         uint256 leavesLen = leaves.length;
194         uint256 totalHashes = proofFlags.length;
195 
196         // Check proof validity.
197         require(
198             leavesLen + proof.length - 1 == totalHashes,
199             "MerkleProof: invalid multiproof"
200         );
201 
202         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
203         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
204         bytes32[] memory hashes = new bytes32[](totalHashes);
205         uint256 leafPos = 0;
206         uint256 hashPos = 0;
207         uint256 proofPos = 0;
208         // At each step, we compute the next hash using two values:
209         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
210         //   get the next hash.
211         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
212         //   `proof` array.
213         for (uint256 i = 0; i < totalHashes; i++) {
214             bytes32 a = leafPos < leavesLen
215                 ? leaves[leafPos++]
216                 : hashes[hashPos++];
217             bytes32 b = proofFlags[i]
218                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
219                 : proof[proofPos++];
220             hashes[i] = _hashPair(a, b);
221         }
222 
223         if (totalHashes > 0) {
224             return hashes[totalHashes - 1];
225         } else if (leavesLen > 0) {
226             return leaves[0];
227         } else {
228             return proof[0];
229         }
230     }
231 
232     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
233         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
234     }
235 
236     function _efficientHash(bytes32 a, bytes32 b)
237         private
238         pure
239         returns (bytes32 value)
240     {
241         /// @solidity memory-safe-assembly
242         assembly {
243             mstore(0x00, a)
244             mstore(0x20, b)
245             value := keccak256(0x00, 0x40)
246         }
247     }
248 }
249 
250 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
251 /**
252  * @dev Contract module that helps prevent reentrant calls to a function.
253  *
254  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
255  * available, which can be applied to functions to make sure there are no nested
256  * (reentrant) calls to them.
257  *
258  * Note that because there is a single `nonReentrant` guard, functions marked as
259  * `nonReentrant` may not call one another. This can be worked around by making
260  * those functions `private`, and then adding `external` `nonReentrant` entry
261  * points to them.
262  *
263  * TIP: If you would like to learn more about reentrancy and alternative ways
264  * to protect against it, check out our blog post
265  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
266  */
267 abstract contract ReentrancyGuard {
268     // Booleans are more expensive than uint256 or any type that takes up a full
269     // word because each write operation emits an extra SLOAD to first read the
270     // slot's contents, replace the bits taken up by the boolean, and then write
271     // back. This is the compiler's defense against contract upgrades and
272     // pointer aliasing, and it cannot be disabled.
273 
274     // The values being non-zero value makes deployment a bit more expensive,
275     // but in exchange the refund on every call to nonReentrant will be lower in
276     // amount. Since refunds are capped to a percentage of the total
277     // transaction's gas, it is best to keep them low in cases like this one, to
278     // increase the likelihood of the full refund coming into effect.
279     uint256 private constant _NOT_ENTERED = 1;
280     uint256 private constant _ENTERED = 2;
281 
282     uint256 private _status;
283 
284     constructor() {
285         _status = _NOT_ENTERED;
286     }
287 
288     /**
289      * @dev Prevents a contract from calling itself, directly or indirectly.
290      * Calling a `nonReentrant` function from another `nonReentrant`
291      * function is not supported. It is possible to prevent this from happening
292      * by making the `nonReentrant` function external, and making it call a
293      * `private` function that does the actual work.
294      */
295     modifier nonReentrant() {
296         _nonReentrantBefore();
297         _;
298         _nonReentrantAfter();
299     }
300 
301     function _nonReentrantBefore() private {
302         // On the first call to nonReentrant, _status will be _NOT_ENTERED
303         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
304 
305         // Any calls to nonReentrant after this point will fail
306         _status = _ENTERED;
307     }
308 
309     function _nonReentrantAfter() private {
310         // By storing the original value once again, a refund is triggered (see
311         // https://eips.ethereum.org/EIPS/eip-2200)
312         _status = _NOT_ENTERED;
313     }
314 }
315 
316 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
317 /**
318  * @dev Provides information about the current execution context, including the
319  * sender of the transaction and its data. While these are generally available
320  * via msg.sender and msg.data, they should not be accessed in such a direct
321  * manner, since when dealing with meta-transactions the account sending and
322  * paying for execution may not be the actual sender (as far as an application
323  * is concerned).
324  *
325  * This contract is only required for intermediate, library-like contracts.
326  */
327 abstract contract Context {
328     function _msgSender() internal view virtual returns (address) {
329         return msg.sender;
330     }
331 
332     function _msgData() internal view virtual returns (bytes calldata) {
333         return msg.data;
334     }
335 }
336 
337 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
338 /**
339  * @dev Standard math utilities missing in the Solidity language.
340  */
341 library Math {
342     enum Rounding {
343         Down, // Toward negative infinity
344         Up, // Toward infinity
345         Zero // Toward zero
346     }
347 
348     /**
349      * @dev Returns the largest of two numbers.
350      */
351     function max(uint256 a, uint256 b) internal pure returns (uint256) {
352         return a > b ? a : b;
353     }
354 
355     /**
356      * @dev Returns the smallest of two numbers.
357      */
358     function min(uint256 a, uint256 b) internal pure returns (uint256) {
359         return a < b ? a : b;
360     }
361 
362     /**
363      * @dev Returns the average of two numbers. The result is rounded towards
364      * zero.
365      */
366     function average(uint256 a, uint256 b) internal pure returns (uint256) {
367         // (a + b) / 2 can overflow.
368         return (a & b) + (a ^ b) / 2;
369     }
370 
371     /**
372      * @dev Returns the ceiling of the division of two numbers.
373      *
374      * This differs from standard division with `/` in that it rounds up instead
375      * of rounding down.
376      */
377     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
378         // (a + b - 1) / b can overflow on addition, so we distribute.
379         return a == 0 ? 0 : (a - 1) / b + 1;
380     }
381 
382     /**
383      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
384      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
385      * with further edits by Uniswap Labs also under MIT license.
386      */
387     function mulDiv(
388         uint256 x,
389         uint256 y,
390         uint256 denominator
391     ) internal pure returns (uint256 result) {
392         unchecked {
393             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
394             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
395             // variables such that product = prod1 * 2^256 + prod0.
396             uint256 prod0; // Least significant 256 bits of the product
397             uint256 prod1; // Most significant 256 bits of the product
398             assembly {
399                 let mm := mulmod(x, y, not(0))
400                 prod0 := mul(x, y)
401                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
402             }
403 
404             // Handle non-overflow cases, 256 by 256 division.
405             if (prod1 == 0) {
406                 return prod0 / denominator;
407             }
408 
409             // Make sure the result is less than 2^256. Also prevents denominator == 0.
410             require(denominator > prod1);
411 
412             ///////////////////////////////////////////////
413             // 512 by 256 division.
414             ///////////////////////////////////////////////
415 
416             // Make division exact by subtracting the remainder from [prod1 prod0].
417             uint256 remainder;
418             assembly {
419                 // Compute remainder using mulmod.
420                 remainder := mulmod(x, y, denominator)
421 
422                 // Subtract 256 bit number from 512 bit number.
423                 prod1 := sub(prod1, gt(remainder, prod0))
424                 prod0 := sub(prod0, remainder)
425             }
426 
427             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
428             // See https://cs.stackexchange.com/q/138556/92363.
429 
430             // Does not overflow because the denominator cannot be zero at this stage in the function.
431             uint256 twos = denominator & (~denominator + 1);
432             assembly {
433                 // Divide denominator by twos.
434                 denominator := div(denominator, twos)
435 
436                 // Divide [prod1 prod0] by twos.
437                 prod0 := div(prod0, twos)
438 
439                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
440                 twos := add(div(sub(0, twos), twos), 1)
441             }
442 
443             // Shift in bits from prod1 into prod0.
444             prod0 |= prod1 * twos;
445 
446             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
447             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
448             // four bits. That is, denominator * inv = 1 mod 2^4.
449             uint256 inverse = (3 * denominator) ^ 2;
450 
451             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
452             // in modular arithmetic, doubling the correct bits in each step.
453             inverse *= 2 - denominator * inverse; // inverse mod 2^8
454             inverse *= 2 - denominator * inverse; // inverse mod 2^16
455             inverse *= 2 - denominator * inverse; // inverse mod 2^32
456             inverse *= 2 - denominator * inverse; // inverse mod 2^64
457             inverse *= 2 - denominator * inverse; // inverse mod 2^128
458             inverse *= 2 - denominator * inverse; // inverse mod 2^256
459 
460             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
461             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
462             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
463             // is no longer required.
464             result = prod0 * inverse;
465             return result;
466         }
467     }
468 
469     /**
470      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
471      */
472     function mulDiv(
473         uint256 x,
474         uint256 y,
475         uint256 denominator,
476         Rounding rounding
477     ) internal pure returns (uint256) {
478         uint256 result = mulDiv(x, y, denominator);
479         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
480             result += 1;
481         }
482         return result;
483     }
484 
485     /**
486      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
487      *
488      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
489      */
490     function sqrt(uint256 a) internal pure returns (uint256) {
491         if (a == 0) {
492             return 0;
493         }
494 
495         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
496         //
497         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
498         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
499         //
500         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
501         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
502         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
503         //
504         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
505         uint256 result = 1 << (log2(a) >> 1);
506 
507         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
508         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
509         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
510         // into the expected uint128 result.
511         unchecked {
512             result = (result + a / result) >> 1;
513             result = (result + a / result) >> 1;
514             result = (result + a / result) >> 1;
515             result = (result + a / result) >> 1;
516             result = (result + a / result) >> 1;
517             result = (result + a / result) >> 1;
518             result = (result + a / result) >> 1;
519             return min(result, a / result);
520         }
521     }
522 
523     /**
524      * @notice Calculates sqrt(a), following the selected rounding direction.
525      */
526     function sqrt(uint256 a, Rounding rounding)
527         internal
528         pure
529         returns (uint256)
530     {
531         unchecked {
532             uint256 result = sqrt(a);
533             return
534                 result +
535                 (rounding == Rounding.Up && result * result < a ? 1 : 0);
536         }
537     }
538 
539     /**
540      * @dev Return the log in base 2, rounded down, of a positive value.
541      * Returns 0 if given 0.
542      */
543     function log2(uint256 value) internal pure returns (uint256) {
544         uint256 result = 0;
545         unchecked {
546             if (value >> 128 > 0) {
547                 value >>= 128;
548                 result += 128;
549             }
550             if (value >> 64 > 0) {
551                 value >>= 64;
552                 result += 64;
553             }
554             if (value >> 32 > 0) {
555                 value >>= 32;
556                 result += 32;
557             }
558             if (value >> 16 > 0) {
559                 value >>= 16;
560                 result += 16;
561             }
562             if (value >> 8 > 0) {
563                 value >>= 8;
564                 result += 8;
565             }
566             if (value >> 4 > 0) {
567                 value >>= 4;
568                 result += 4;
569             }
570             if (value >> 2 > 0) {
571                 value >>= 2;
572                 result += 2;
573             }
574             if (value >> 1 > 0) {
575                 result += 1;
576             }
577         }
578         return result;
579     }
580 
581     /**
582      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
583      * Returns 0 if given 0.
584      */
585     function log2(uint256 value, Rounding rounding)
586         internal
587         pure
588         returns (uint256)
589     {
590         unchecked {
591             uint256 result = log2(value);
592             return
593                 result +
594                 (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
595         }
596     }
597 
598     /**
599      * @dev Return the log in base 10, rounded down, of a positive value.
600      * Returns 0 if given 0.
601      */
602     function log10(uint256 value) internal pure returns (uint256) {
603         uint256 result = 0;
604         unchecked {
605             if (value >= 10**64) {
606                 value /= 10**64;
607                 result += 64;
608             }
609             if (value >= 10**32) {
610                 value /= 10**32;
611                 result += 32;
612             }
613             if (value >= 10**16) {
614                 value /= 10**16;
615                 result += 16;
616             }
617             if (value >= 10**8) {
618                 value /= 10**8;
619                 result += 8;
620             }
621             if (value >= 10**4) {
622                 value /= 10**4;
623                 result += 4;
624             }
625             if (value >= 10**2) {
626                 value /= 10**2;
627                 result += 2;
628             }
629             if (value >= 10**1) {
630                 result += 1;
631             }
632         }
633         return result;
634     }
635 
636     /**
637      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
638      * Returns 0 if given 0.
639      */
640     function log10(uint256 value, Rounding rounding)
641         internal
642         pure
643         returns (uint256)
644     {
645         unchecked {
646             uint256 result = log10(value);
647             return
648                 result +
649                 (rounding == Rounding.Up && 10**result < value ? 1 : 0);
650         }
651     }
652 
653     /**
654      * @dev Return the log in base 256, rounded down, of a positive value.
655      * Returns 0 if given 0.
656      *
657      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
658      */
659     function log256(uint256 value) internal pure returns (uint256) {
660         uint256 result = 0;
661         unchecked {
662             if (value >> 128 > 0) {
663                 value >>= 128;
664                 result += 16;
665             }
666             if (value >> 64 > 0) {
667                 value >>= 64;
668                 result += 8;
669             }
670             if (value >> 32 > 0) {
671                 value >>= 32;
672                 result += 4;
673             }
674             if (value >> 16 > 0) {
675                 value >>= 16;
676                 result += 2;
677             }
678             if (value >> 8 > 0) {
679                 result += 1;
680             }
681         }
682         return result;
683     }
684 
685     /**
686      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
687      * Returns 0 if given 0.
688      */
689     function log256(uint256 value, Rounding rounding)
690         internal
691         pure
692         returns (uint256)
693     {
694         unchecked {
695             uint256 result = log256(value);
696             return
697                 result +
698                 (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
699         }
700     }
701 }
702 
703 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
704 /**
705  * @dev String operations.
706  */
707 library Strings {
708     bytes16 private constant _SYMBOLS = "0123456789abcdef";
709     uint8 private constant _ADDRESS_LENGTH = 20;
710 
711     /**
712      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
713      */
714     function toString(uint256 value) internal pure returns (string memory) {
715         unchecked {
716             uint256 length = Math.log10(value) + 1;
717             string memory buffer = new string(length);
718             uint256 ptr;
719             /// @solidity memory-safe-assembly
720             assembly {
721                 ptr := add(buffer, add(32, length))
722             }
723             while (true) {
724                 ptr--;
725                 /// @solidity memory-safe-assembly
726                 assembly {
727                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
728                 }
729                 value /= 10;
730                 if (value == 0) break;
731             }
732             return buffer;
733         }
734     }
735 
736     /**
737      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
738      */
739     function toHexString(uint256 value) internal pure returns (string memory) {
740         unchecked {
741             return toHexString(value, Math.log256(value) + 1);
742         }
743     }
744 
745     /**
746      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
747      */
748     function toHexString(uint256 value, uint256 length)
749         internal
750         pure
751         returns (string memory)
752     {
753         bytes memory buffer = new bytes(2 * length + 2);
754         buffer[0] = "0";
755         buffer[1] = "x";
756         for (uint256 i = 2 * length + 1; i > 1; --i) {
757             buffer[i] = _SYMBOLS[value & 0xf];
758             value >>= 4;
759         }
760         require(value == 0, "Strings: hex length insufficient");
761         return string(buffer);
762     }
763 
764     /**
765      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
766      */
767     function toHexString(address addr) internal pure returns (string memory) {
768         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
769     }
770 }
771 
772 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
773 /**
774  * @dev Contract module which provides a basic access control mechanism, where
775  * there is an account (an owner) that can be granted exclusive access to
776  * specific functions.
777  *
778  * By default, the owner account will be the one that deploys the contract. This
779  * can later be changed with {transferOwnership}.
780  *
781  * This module is used through inheritance. It will make available the modifier
782  * `onlyOwner`, which can be applied to your functions to restrict their use to
783  * the owner.
784  */
785 abstract contract Ownable is Context {
786     address private _owner;
787 
788     event OwnershipTransferred(
789         address indexed previousOwner,
790         address indexed newOwner
791     );
792 
793     /**
794      * @dev Initializes the contract setting the deployer as the initial owner.
795      */
796     constructor() {
797         _transferOwnership(_msgSender());
798     }
799 
800     /**
801      * @dev Throws if called by any account other than the owner.
802      */
803     modifier onlyOwner() {
804         _checkOwner();
805         _;
806     }
807 
808     /**
809      * @dev Returns the address of the current owner.
810      */
811     function owner() public view virtual returns (address) {
812         return _owner;
813     }
814 
815     /**
816      * @dev Throws if the sender is not the owner.
817      */
818     function _checkOwner() internal view virtual {
819         require(owner() == _msgSender(), "Ownable: caller is not the owner");
820     }
821 
822     /**
823      * @dev Leaves the contract without owner. It will not be possible to call
824      * `onlyOwner` functions anymore. Can only be called by the current owner.
825      *
826      * NOTE: Renouncing ownership will leave the contract without an owner,
827      * thereby removing any functionality that is only available to the owner.
828      */
829     function renounceOwnership() public virtual onlyOwner {
830         _transferOwnership(address(0));
831     }
832 
833     /**
834      * @dev Transfers ownership of the contract to a new account (`newOwner`).
835      * Can only be called by the current owner.
836      */
837     function transferOwnership(address newOwner) public virtual onlyOwner {
838         require(
839             newOwner != address(0),
840             "Ownable: new owner is the zero address"
841         );
842         _transferOwnership(newOwner);
843     }
844 
845     /**
846      * @dev Transfers ownership of the contract to a new account (`newOwner`).
847      * Internal function without access restriction.
848      */
849     function _transferOwnership(address newOwner) internal virtual {
850         address oldOwner = _owner;
851         _owner = newOwner;
852         emit OwnershipTransferred(oldOwner, newOwner);
853     }
854 }
855 
856 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
857 /**
858  * @dev Collection of functions related to the address type
859  */
860 library Address {
861     /**
862      * @dev Returns true if `account` is a contract.
863      *
864      * [IMPORTANT]
865      * ====
866      * It is unsafe to assume that an address for which this function returns
867      * false is an externally-owned account (EOA) and not a contract.
868      *
869      * Among others, `isContract` will return false for the following
870      * types of addresses:
871      *
872      *  - an externally-owned account
873      *  - a contract in construction
874      *  - an address where a contract will be created
875      *  - an address where a contract lived, but was destroyed
876      * ====
877      *
878      * [IMPORTANT]
879      * ====
880      * You shouldn't rely on `isContract` to protect against flash loan attacks!
881      *
882      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
883      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
884      * constructor.
885      * ====
886      */
887     function isContract(address account) internal view returns (bool) {
888         // This method relies on extcodesize/address.code.length, which returns 0
889         // for contracts in construction, since the code is only stored at the end
890         // of the constructor execution.
891 
892         return account.code.length > 0;
893     }
894 
895     /**
896      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
897      * `recipient`, forwarding all available gas and reverting on errors.
898      *
899      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
900      * of certain opcodes, possibly making contracts go over the 2300 gas limit
901      * imposed by `transfer`, making them unable to receive funds via
902      * `transfer`. {sendValue} removes this limitation.
903      *
904      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
905      *
906      * IMPORTANT: because control is transferred to `recipient`, care must be
907      * taken to not create reentrancy vulnerabilities. Consider using
908      * {ReentrancyGuard} or the
909      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
910      */
911     function sendValue(address payable recipient, uint256 amount) internal {
912         require(
913             address(this).balance >= amount,
914             "Address: insufficient balance"
915         );
916 
917         (bool success, ) = recipient.call{value: amount}("");
918         require(
919             success,
920             "Address: unable to send value, recipient may have reverted"
921         );
922     }
923 
924     /**
925      * @dev Performs a Solidity function call using a low level `call`. A
926      * plain `call` is an unsafe replacement for a function call: use this
927      * function instead.
928      *
929      * If `target` reverts with a revert reason, it is bubbled up by this
930      * function (like regular Solidity function calls).
931      *
932      * Returns the raw returned data. To convert to the expected return value,
933      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
934      *
935      * Requirements:
936      *
937      * - `target` must be a contract.
938      * - calling `target` with `data` must not revert.
939      *
940      * _Available since v3.1._
941      */
942     function functionCall(address target, bytes memory data)
943         internal
944         returns (bytes memory)
945     {
946         return
947             functionCallWithValue(
948                 target,
949                 data,
950                 0,
951                 "Address: low-level call failed"
952             );
953     }
954 
955     /**
956      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
957      * `errorMessage` as a fallback revert reason when `target` reverts.
958      *
959      * _Available since v3.1._
960      */
961     function functionCall(
962         address target,
963         bytes memory data,
964         string memory errorMessage
965     ) internal returns (bytes memory) {
966         return functionCallWithValue(target, data, 0, errorMessage);
967     }
968 
969     /**
970      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
971      * but also transferring `value` wei to `target`.
972      *
973      * Requirements:
974      *
975      * - the calling contract must have an ETH balance of at least `value`.
976      * - the called Solidity function must be `payable`.
977      *
978      * _Available since v3.1._
979      */
980     function functionCallWithValue(
981         address target,
982         bytes memory data,
983         uint256 value
984     ) internal returns (bytes memory) {
985         return
986             functionCallWithValue(
987                 target,
988                 data,
989                 value,
990                 "Address: low-level call with value failed"
991             );
992     }
993 
994     /**
995      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
996      * with `errorMessage` as a fallback revert reason when `target` reverts.
997      *
998      * _Available since v3.1._
999      */
1000     function functionCallWithValue(
1001         address target,
1002         bytes memory data,
1003         uint256 value,
1004         string memory errorMessage
1005     ) internal returns (bytes memory) {
1006         require(
1007             address(this).balance >= value,
1008             "Address: insufficient balance for call"
1009         );
1010         (bool success, bytes memory returndata) = target.call{value: value}(
1011             data
1012         );
1013         return
1014             verifyCallResultFromTarget(
1015                 target,
1016                 success,
1017                 returndata,
1018                 errorMessage
1019             );
1020     }
1021 
1022     /**
1023      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1024      * but performing a static call.
1025      *
1026      * _Available since v3.3._
1027      */
1028     function functionStaticCall(address target, bytes memory data)
1029         internal
1030         view
1031         returns (bytes memory)
1032     {
1033         return
1034             functionStaticCall(
1035                 target,
1036                 data,
1037                 "Address: low-level static call failed"
1038             );
1039     }
1040 
1041     /**
1042      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1043      * but performing a static call.
1044      *
1045      * _Available since v3.3._
1046      */
1047     function functionStaticCall(
1048         address target,
1049         bytes memory data,
1050         string memory errorMessage
1051     ) internal view returns (bytes memory) {
1052         (bool success, bytes memory returndata) = target.staticcall(data);
1053         return
1054             verifyCallResultFromTarget(
1055                 target,
1056                 success,
1057                 returndata,
1058                 errorMessage
1059             );
1060     }
1061 
1062     /**
1063      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1064      * but performing a delegate call.
1065      *
1066      * _Available since v3.4._
1067      */
1068     function functionDelegateCall(address target, bytes memory data)
1069         internal
1070         returns (bytes memory)
1071     {
1072         return
1073             functionDelegateCall(
1074                 target,
1075                 data,
1076                 "Address: low-level delegate call failed"
1077             );
1078     }
1079 
1080     /**
1081      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1082      * but performing a delegate call.
1083      *
1084      * _Available since v3.4._
1085      */
1086     function functionDelegateCall(
1087         address target,
1088         bytes memory data,
1089         string memory errorMessage
1090     ) internal returns (bytes memory) {
1091         (bool success, bytes memory returndata) = target.delegatecall(data);
1092         return
1093             verifyCallResultFromTarget(
1094                 target,
1095                 success,
1096                 returndata,
1097                 errorMessage
1098             );
1099     }
1100 
1101     /**
1102      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1103      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1104      *
1105      * _Available since v4.8._
1106      */
1107     function verifyCallResultFromTarget(
1108         address target,
1109         bool success,
1110         bytes memory returndata,
1111         string memory errorMessage
1112     ) internal view returns (bytes memory) {
1113         if (success) {
1114             if (returndata.length == 0) {
1115                 // only check isContract if the call was successful and the return data is empty
1116                 // otherwise we already know that it was a contract
1117                 require(isContract(target), "Address: call to non-contract");
1118             }
1119             return returndata;
1120         } else {
1121             _revert(returndata, errorMessage);
1122         }
1123     }
1124 
1125     /**
1126      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1127      * revert reason or using the provided one.
1128      *
1129      * _Available since v4.3._
1130      */
1131     function verifyCallResult(
1132         bool success,
1133         bytes memory returndata,
1134         string memory errorMessage
1135     ) internal pure returns (bytes memory) {
1136         if (success) {
1137             return returndata;
1138         } else {
1139             _revert(returndata, errorMessage);
1140         }
1141     }
1142 
1143     function _revert(bytes memory returndata, string memory errorMessage)
1144         private
1145         pure
1146     {
1147         // Look for revert reason and bubble it up if present
1148         if (returndata.length > 0) {
1149             // The easiest way to bubble the revert reason is using memory via assembly
1150             /// @solidity memory-safe-assembly
1151             assembly {
1152                 let returndata_size := mload(returndata)
1153                 revert(add(32, returndata), returndata_size)
1154             }
1155         } else {
1156             revert(errorMessage);
1157         }
1158     }
1159 }
1160 
1161 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1162 /**
1163  * @dev Interface of the ERC20 standard as defined in the EIP.
1164  */
1165 interface IERC20 {
1166     /**
1167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1168      * another (`to`).
1169      *
1170      * Note that `value` may be zero.
1171      */
1172     event Transfer(address indexed from, address indexed to, uint256 value);
1173 
1174     /**
1175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1176      * a call to {approve}. `value` is the new allowance.
1177      */
1178     event Approval(
1179         address indexed owner,
1180         address indexed spender,
1181         uint256 value
1182     );
1183 
1184     /**
1185      * @dev Returns the amount of tokens in existence.
1186      */
1187     function totalSupply() external view returns (uint256);
1188 
1189     /**
1190      * @dev Returns the amount of tokens owned by `account`.
1191      */
1192     function balanceOf(address account) external view returns (uint256);
1193 
1194     /**
1195      * @dev Moves `amount` tokens from the caller's account to `to`.
1196      *
1197      * Returns a boolean value indicating whether the operation succeeded.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function transfer(address to, uint256 amount) external returns (bool);
1202 
1203     /**
1204      * @dev Returns the remaining number of tokens that `spender` will be
1205      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1206      * zero by default.
1207      *
1208      * This value changes when {approve} or {transferFrom} are called.
1209      */
1210     function allowance(address owner, address spender)
1211         external
1212         view
1213         returns (uint256);
1214 
1215     /**
1216      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1217      *
1218      * Returns a boolean value indicating whether the operation succeeded.
1219      *
1220      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1221      * that someone may use both the old and the new allowance by unfortunate
1222      * transaction ordering. One possible solution to mitigate this race
1223      * condition is to first reduce the spender's allowance to 0 and set the
1224      * desired value afterwards:
1225      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1226      *
1227      * Emits an {Approval} event.
1228      */
1229     function approve(address spender, uint256 amount) external returns (bool);
1230 
1231     /**
1232      * @dev Moves `amount` tokens from `from` to `to` using the
1233      * allowance mechanism. `amount` is then deducted from the caller's
1234      * allowance.
1235      *
1236      * Returns a boolean value indicating whether the operation succeeded.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function transferFrom(
1241         address from,
1242         address to,
1243         uint256 amount
1244     ) external returns (bool);
1245 }
1246 
1247 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1248 /**
1249  * @dev Interface of the ERC165 standard, as defined in the
1250  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1251  *
1252  * Implementers can declare support of contract interfaces, which can then be
1253  * queried by others ({ERC165Checker}).
1254  *
1255  * For an implementation, see {ERC165}.
1256  */
1257 interface IERC165 {
1258     /**
1259      * @dev Returns true if this contract implements the interface defined by
1260      * `interfaceId`. See the corresponding
1261      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1262      * to learn more about how these ids are created.
1263      *
1264      * This function call must use less than 30 000 gas.
1265      */
1266     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1267 }
1268 
1269 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1270 /**
1271  * @dev Required interface of an ERC721 compliant contract.
1272  */
1273 interface IERC721 is IERC165 {
1274     /**
1275      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1276      */
1277     event Transfer(
1278         address indexed from,
1279         address indexed to,
1280         uint256 indexed tokenId
1281     );
1282 
1283     /**
1284      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1285      */
1286     event Approval(
1287         address indexed owner,
1288         address indexed approved,
1289         uint256 indexed tokenId
1290     );
1291 
1292     /**
1293      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1294      */
1295     event ApprovalForAll(
1296         address indexed owner,
1297         address indexed operator,
1298         bool approved
1299     );
1300 
1301     /**
1302      * @dev Returns the number of tokens in ``owner``'s account.
1303      */
1304     function balanceOf(address owner) external view returns (uint256 balance);
1305 
1306     /**
1307      * @dev Returns the owner of the `tokenId` token.
1308      *
1309      * Requirements:
1310      *
1311      * - `tokenId` must exist.
1312      */
1313     function ownerOf(uint256 tokenId) external view returns (address owner);
1314 
1315     /**
1316      * @dev Safely transfers `tokenId` token from `from` to `to`.
1317      *
1318      * Requirements:
1319      *
1320      * - `from` cannot be the zero address.
1321      * - `to` cannot be the zero address.
1322      * - `tokenId` token must exist and be owned by `from`.
1323      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1324      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1325      *
1326      * Emits a {Transfer} event.
1327      */
1328     function safeTransferFrom(
1329         address from,
1330         address to,
1331         uint256 tokenId,
1332         bytes calldata data
1333     ) external;
1334 
1335     /**
1336      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1337      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1338      *
1339      * Requirements:
1340      *
1341      * - `from` cannot be the zero address.
1342      * - `to` cannot be the zero address.
1343      * - `tokenId` token must exist and be owned by `from`.
1344      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1345      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1346      *
1347      * Emits a {Transfer} event.
1348      */
1349     function safeTransferFrom(
1350         address from,
1351         address to,
1352         uint256 tokenId
1353     ) external;
1354 
1355     /**
1356      * @dev Transfers `tokenId` token from `from` to `to`.
1357      *
1358      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1359      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1360      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1361      *
1362      * Requirements:
1363      *
1364      * - `from` cannot be the zero address.
1365      * - `to` cannot be the zero address.
1366      * - `tokenId` token must be owned by `from`.
1367      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1368      *
1369      * Emits a {Transfer} event.
1370      */
1371     function transferFrom(
1372         address from,
1373         address to,
1374         uint256 tokenId
1375     ) external;
1376 
1377     /**
1378      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1379      * The approval is cleared when the token is transferred.
1380      *
1381      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1382      *
1383      * Requirements:
1384      *
1385      * - The caller must own the token or be an approved operator.
1386      * - `tokenId` must exist.
1387      *
1388      * Emits an {Approval} event.
1389      */
1390     function approve(address to, uint256 tokenId) external;
1391 
1392     /**
1393      * @dev Approve or remove `operator` as an operator for the caller.
1394      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1395      *
1396      * Requirements:
1397      *
1398      * - The `operator` cannot be the caller.
1399      *
1400      * Emits an {ApprovalForAll} event.
1401      */
1402     function setApprovalForAll(address operator, bool _approved) external;
1403 
1404     /**
1405      * @dev Returns the account approved for `tokenId` token.
1406      *
1407      * Requirements:
1408      *
1409      * - `tokenId` must exist.
1410      */
1411     function getApproved(uint256 tokenId)
1412         external
1413         view
1414         returns (address operator);
1415 
1416     /**
1417      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1418      *
1419      * See {setApprovalForAll}
1420      */
1421     function isApprovedForAll(address owner, address operator)
1422         external
1423         view
1424         returns (bool);
1425 }
1426 
1427 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1428 /**
1429  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1430  * @dev See https://eips.ethereum.org/EIPS/eip-721
1431  */
1432 interface IERC721Metadata is IERC721 {
1433     /**
1434      * @dev Returns the token collection name.
1435      */
1436     function name() external view returns (string memory);
1437 
1438     /**
1439      * @dev Returns the token collection symbol.
1440      */
1441     function symbol() external view returns (string memory);
1442 
1443     /**
1444      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1445      */
1446     function tokenURI(uint256 tokenId) external view returns (string memory);
1447 }
1448 
1449 // ERC721A Contracts v3.3.0
1450 // Creator: Chiru Labs
1451 /**
1452  * @dev Interface of an ERC721A compliant contract.
1453  */
1454 interface IERC721A is IERC721, IERC721Metadata {
1455     /**
1456      * The caller must own the token or be an approved operator.
1457      */
1458     error ApprovalCallerNotOwnerNorApproved();
1459 
1460     /**
1461      * The token does not exist.
1462      */
1463     error ApprovalQueryForNonexistentToken();
1464 
1465     /**
1466      * The caller cannot approve to their own address.
1467      */
1468     error ApproveToCaller();
1469 
1470     /**
1471      * The caller cannot approve to the current owner.
1472      */
1473     error ApprovalToCurrentOwner();
1474 
1475     /**
1476      * Cannot query the balance for the zero address.
1477      */
1478     error BalanceQueryForZeroAddress();
1479 
1480     /**
1481      * Cannot mint to the zero address.
1482      */
1483     error MintToZeroAddress();
1484 
1485     /**
1486      * The quantity of tokens minted must be more than zero.
1487      */
1488     error MintZeroQuantity();
1489 
1490     /**
1491      * The token does not exist.
1492      */
1493     error OwnerQueryForNonexistentToken();
1494 
1495     /**
1496      * The caller must own the token or be an approved operator.
1497      */
1498     error TransferCallerNotOwnerNorApproved();
1499 
1500     /**
1501      * The token must be owned by `from`.
1502      */
1503     error TransferFromIncorrectOwner();
1504 
1505     /**
1506      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1507      */
1508     error TransferToNonERC721ReceiverImplementer();
1509 
1510     /**
1511      * Cannot transfer to the zero address.
1512      */
1513     error TransferToZeroAddress();
1514 
1515     /**
1516      * The token does not exist.
1517      */
1518     error URIQueryForNonexistentToken();
1519 
1520     // Compiler will pack this into a single 256bit word.
1521     struct TokenOwnership {
1522         // The address of the owner.
1523         address addr;
1524         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1525         uint64 startTimestamp;
1526         // Whether the token has been burned.
1527         bool burned;
1528     }
1529 
1530     // Compiler will pack this into a single 256bit word.
1531     struct AddressData {
1532         // Realistically, 2**64-1 is more than enough.
1533         uint64 balance;
1534         // Keeps track of mint count with minimal overhead for tokenomics.
1535         uint64 numberMinted;
1536         // Keeps track of burn count with minimal overhead for tokenomics.
1537         uint64 numberBurned;
1538         // For miscellaneous variable(s) pertaining to the address
1539         // (e.g. number of whitelist mint slots used).
1540         // If there are multiple variables, please pack them into a uint64.
1541         uint64 aux;
1542     }
1543 
1544     /**
1545      * @dev Returns the total amount of tokens stored by the contract.
1546      *
1547      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1548      */
1549     function totalSupply() external view returns (uint256);
1550 }
1551 
1552 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1553 /**
1554  * @title ERC721 token receiver interface
1555  * @dev Interface for any contract that wants to support safeTransfers
1556  * from ERC721 asset contracts.
1557  */
1558 interface IERC721Receiver {
1559     /**
1560      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1561      * by `operator` from `from`, this function is called.
1562      *
1563      * It must return its Solidity selector to confirm the token transfer.
1564      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1565      *
1566      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1567      */
1568     function onERC721Received(
1569         address operator,
1570         address from,
1571         uint256 tokenId,
1572         bytes calldata data
1573     ) external returns (bytes4);
1574 }
1575 
1576 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1577 /**
1578  * @dev Implementation of the {IERC165} interface.
1579  *
1580  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1581  * for the additional interface id that will be supported. For example:
1582  *
1583  * ```solidity
1584  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1585  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1586  * }
1587  * ```
1588  *
1589  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1590  */
1591 abstract contract ERC165 is IERC165 {
1592     /**
1593      * @dev See {IERC165-supportsInterface}.
1594      */
1595     function supportsInterface(bytes4 interfaceId)
1596         public
1597         view
1598         virtual
1599         override
1600         returns (bool)
1601     {
1602         return interfaceId == type(IERC165).interfaceId;
1603     }
1604 }
1605 
1606 // ERC721A Contracts v3.3.0
1607 // Creator: Chiru Labs
1608 /**
1609  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1610  * the Metadata extension. Built to optimize for lower gas during batch mints.
1611  *
1612  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1613  *
1614  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1615  *
1616  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1617  */
1618 contract ERC721A is Context, ERC165, IERC721A {
1619     using Address for address;
1620     using Strings for uint256;
1621 
1622     // The tokenId of the next token to be minted.
1623     uint256 internal _currentIndex;
1624 
1625     // The number of tokens burned.
1626     uint256 internal _burnCounter;
1627 
1628     // Token name
1629     string private _name;
1630 
1631     // Token symbol
1632     string private _symbol;
1633 
1634     // Mapping from token ID to ownership details
1635     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1636     mapping(uint256 => TokenOwnership) internal _ownerships;
1637 
1638     // Mapping owner address to address data
1639     mapping(address => AddressData) private _addressData;
1640 
1641     // Mapping from token ID to approved address
1642     mapping(uint256 => address) private _tokenApprovals;
1643 
1644     // Mapping from owner to operator approvals
1645     mapping(address => mapping(address => bool)) private _operatorApprovals;
1646 
1647     constructor(string memory name_, string memory symbol_) {
1648         _name = name_;
1649         _symbol = symbol_;
1650         _currentIndex = _startTokenId();
1651     }
1652 
1653     /**
1654      * To change the starting tokenId, please override this function.
1655      */
1656     function _startTokenId() internal view virtual returns (uint256) {
1657         return 0;
1658     }
1659 
1660     /**
1661      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1662      */
1663     function totalSupply() public view override returns (uint256) {
1664         // Counter underflow is impossible as _burnCounter cannot be incremented
1665         // more than _currentIndex - _startTokenId() times
1666         unchecked {
1667             return _currentIndex - _burnCounter - _startTokenId();
1668         }
1669     }
1670 
1671     /**
1672      * Returns the total amount of tokens minted in the contract.
1673      */
1674     function _totalMinted() internal view returns (uint256) {
1675         // Counter underflow is impossible as _currentIndex does not decrement,
1676         // and it is initialized to _startTokenId()
1677         unchecked {
1678             return _currentIndex - _startTokenId();
1679         }
1680     }
1681 
1682     /**
1683      * @dev See {IERC165-supportsInterface}.
1684      */
1685     function supportsInterface(bytes4 interfaceId)
1686         public
1687         view
1688         virtual
1689         override(ERC165, IERC165)
1690         returns (bool)
1691     {
1692         return
1693             interfaceId == type(IERC721).interfaceId ||
1694             interfaceId == type(IERC721Metadata).interfaceId ||
1695             super.supportsInterface(interfaceId);
1696     }
1697 
1698     /**
1699      * @dev See {IERC721-balanceOf}.
1700      */
1701     function balanceOf(address owner) public view override returns (uint256) {
1702         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1703         return uint256(_addressData[owner].balance);
1704     }
1705 
1706     /**
1707      * Returns the number of tokens minted by `owner`.
1708      */
1709     function _numberMinted(address owner) internal view returns (uint256) {
1710         return uint256(_addressData[owner].numberMinted);
1711     }
1712 
1713     /**
1714      * Returns the number of tokens burned by or on behalf of `owner`.
1715      */
1716     function _numberBurned(address owner) internal view returns (uint256) {
1717         return uint256(_addressData[owner].numberBurned);
1718     }
1719 
1720     /**
1721      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1722      */
1723     function _getAux(address owner) internal view returns (uint64) {
1724         return _addressData[owner].aux;
1725     }
1726 
1727     /**
1728      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1729      * If there are multiple variables, please pack them into a uint64.
1730      */
1731     function _setAux(address owner, uint64 aux) internal {
1732         _addressData[owner].aux = aux;
1733     }
1734 
1735     /**
1736      * Gas spent here starts off proportional to the maximum mint batch size.
1737      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1738      */
1739     function _ownershipOf(uint256 tokenId)
1740         internal
1741         view
1742         returns (TokenOwnership memory)
1743     {
1744         uint256 curr = tokenId;
1745 
1746         unchecked {
1747             if (_startTokenId() <= curr)
1748                 if (curr < _currentIndex) {
1749                     TokenOwnership memory ownership = _ownerships[curr];
1750                     if (!ownership.burned) {
1751                         if (ownership.addr != address(0)) {
1752                             return ownership;
1753                         }
1754                         // Invariant:
1755                         // There will always be an ownership that has an address and is not burned
1756                         // before an ownership that does not have an address and is not burned.
1757                         // Hence, curr will not underflow.
1758                         while (true) {
1759                             curr--;
1760                             ownership = _ownerships[curr];
1761                             if (ownership.addr != address(0)) {
1762                                 return ownership;
1763                             }
1764                         }
1765                     }
1766                 }
1767         }
1768         revert OwnerQueryForNonexistentToken();
1769     }
1770 
1771     /**
1772      * @dev See {IERC721-ownerOf}.
1773      */
1774     function ownerOf(uint256 tokenId) public view override returns (address) {
1775         return _ownershipOf(tokenId).addr;
1776     }
1777 
1778     /**
1779      * @dev See {IERC721Metadata-name}.
1780      */
1781     function name() public view virtual override returns (string memory) {
1782         return _name;
1783     }
1784 
1785     /**
1786      * @dev See {IERC721Metadata-symbol}.
1787      */
1788     function symbol() public view virtual override returns (string memory) {
1789         return _symbol;
1790     }
1791 
1792     /**
1793      * @dev See {IERC721Metadata-tokenURI}.
1794      */
1795     function tokenURI(uint256 tokenId)
1796         public
1797         view
1798         virtual
1799         override
1800         returns (string memory)
1801     {
1802         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1803 
1804         string memory baseURI = _baseURI();
1805         return
1806             bytes(baseURI).length != 0
1807                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1808                 : "";
1809     }
1810 
1811     /**
1812      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1813      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1814      * by default, can be overriden in child contracts.
1815      */
1816     function _baseURI() internal view virtual returns (string memory) {
1817         return "";
1818     }
1819 
1820     /**
1821      * @dev See {IERC721-approve}.
1822      */
1823     function approve(address to, uint256 tokenId) public override {
1824         address owner = ERC721A.ownerOf(tokenId);
1825         if (to == owner) revert ApprovalToCurrentOwner();
1826 
1827         if (_msgSender() != owner)
1828             if (!isApprovedForAll(owner, _msgSender())) {
1829                 revert ApprovalCallerNotOwnerNorApproved();
1830             }
1831 
1832         _approve(to, tokenId, owner);
1833     }
1834 
1835     /**
1836      * @dev See {IERC721-getApproved}.
1837      */
1838     function getApproved(uint256 tokenId)
1839         public
1840         view
1841         override
1842         returns (address)
1843     {
1844         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1845 
1846         return _tokenApprovals[tokenId];
1847     }
1848 
1849     /**
1850      * @dev See {IERC721-setApprovalForAll}.
1851      */
1852     function setApprovalForAll(address operator, bool approved)
1853         public
1854         virtual
1855         override
1856     {
1857         if (operator == _msgSender()) revert ApproveToCaller();
1858 
1859         _operatorApprovals[_msgSender()][operator] = approved;
1860         emit ApprovalForAll(_msgSender(), operator, approved);
1861     }
1862 
1863     /**
1864      * @dev See {IERC721-isApprovedForAll}.
1865      */
1866     function isApprovedForAll(address owner, address operator)
1867         public
1868         view
1869         virtual
1870         override
1871         returns (bool)
1872     {
1873         return _operatorApprovals[owner][operator];
1874     }
1875 
1876     /**
1877      * @dev See {IERC721-transferFrom}.
1878      */
1879     function transferFrom(
1880         address from,
1881         address to,
1882         uint256 tokenId
1883     ) public virtual override {
1884         _transfer(from, to, tokenId);
1885     }
1886 
1887     /**
1888      * @dev See {IERC721-safeTransferFrom}.
1889      */
1890     function safeTransferFrom(
1891         address from,
1892         address to,
1893         uint256 tokenId
1894     ) public virtual override {
1895         safeTransferFrom(from, to, tokenId, "");
1896     }
1897 
1898     /**
1899      * @dev See {IERC721-safeTransferFrom}.
1900      */
1901     function safeTransferFrom(
1902         address from,
1903         address to,
1904         uint256 tokenId,
1905         bytes memory _data
1906     ) public virtual override {
1907         _transfer(from, to, tokenId);
1908         if (to.isContract())
1909             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1910                 revert TransferToNonERC721ReceiverImplementer();
1911             }
1912     }
1913 
1914     /**
1915      * @dev Returns whether `tokenId` exists.
1916      *
1917      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1918      *
1919      * Tokens start existing when they are minted (`_mint`),
1920      */
1921     function _exists(uint256 tokenId) internal view returns (bool) {
1922         return
1923             _startTokenId() <= tokenId &&
1924             tokenId < _currentIndex &&
1925             !_ownerships[tokenId].burned;
1926     }
1927 
1928     /**
1929      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1930      */
1931     function _safeMint(address to, uint256 quantity) internal {
1932         _safeMint(to, quantity, "");
1933     }
1934 
1935     /**
1936      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1937      *
1938      * Requirements:
1939      *
1940      * - If `to` refers to a smart contract, it must implement
1941      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1942      * - `quantity` must be greater than 0.
1943      *
1944      * Emits a {Transfer} event.
1945      */
1946     function _safeMint(
1947         address to,
1948         uint256 quantity,
1949         bytes memory _data
1950     ) internal {
1951         uint256 startTokenId = _currentIndex;
1952         if (to == address(0)) revert MintToZeroAddress();
1953         if (quantity == 0) revert MintZeroQuantity();
1954 
1955         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1956 
1957         // Overflows are incredibly unrealistic.
1958         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1959         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1960         unchecked {
1961             _addressData[to].balance += uint64(quantity);
1962             _addressData[to].numberMinted += uint64(quantity);
1963 
1964             _ownerships[startTokenId].addr = to;
1965             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1966 
1967             uint256 updatedIndex = startTokenId;
1968             uint256 end = updatedIndex + quantity;
1969 
1970             if (to.isContract()) {
1971                 do {
1972                     emit Transfer(address(0), to, updatedIndex);
1973                     if (
1974                         !_checkContractOnERC721Received(
1975                             address(0),
1976                             to,
1977                             updatedIndex++,
1978                             _data
1979                         )
1980                     ) {
1981                         revert TransferToNonERC721ReceiverImplementer();
1982                     }
1983                 } while (updatedIndex < end);
1984                 // Reentrancy protection
1985                 if (_currentIndex != startTokenId) revert();
1986             } else {
1987                 do {
1988                     emit Transfer(address(0), to, updatedIndex++);
1989                 } while (updatedIndex < end);
1990             }
1991             _currentIndex = updatedIndex;
1992         }
1993         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1994     }
1995 
1996     /**
1997      * @dev Mints `quantity` tokens and transfers them to `to`.
1998      *
1999      * Requirements:
2000      *
2001      * - `to` cannot be the zero address.
2002      * - `quantity` must be greater than 0.
2003      *
2004      * Emits a {Transfer} event.
2005      */
2006     function _mint(address to, uint256 quantity) internal {
2007         uint256 startTokenId = _currentIndex;
2008         if (to == address(0)) revert MintToZeroAddress();
2009         if (quantity == 0) revert MintZeroQuantity();
2010 
2011         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2012 
2013         // Overflows are incredibly unrealistic.
2014         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2015         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2016         unchecked {
2017             _addressData[to].balance += uint64(quantity);
2018             _addressData[to].numberMinted += uint64(quantity);
2019 
2020             _ownerships[startTokenId].addr = to;
2021             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2022 
2023             uint256 updatedIndex = startTokenId;
2024             uint256 end = updatedIndex + quantity;
2025 
2026             do {
2027                 emit Transfer(address(0), to, updatedIndex++);
2028             } while (updatedIndex < end);
2029 
2030             _currentIndex = updatedIndex;
2031         }
2032         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2033     }
2034 
2035     /**
2036      * @dev Transfers `tokenId` from `from` to `to`.
2037      *
2038      * Requirements:
2039      *
2040      * - `to` cannot be the zero address.
2041      * - `tokenId` token must be owned by `from`.
2042      *
2043      * Emits a {Transfer} event.
2044      */
2045     function _transfer(
2046         address from,
2047         address to,
2048         uint256 tokenId
2049     ) private {
2050         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2051 
2052         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2053 
2054         bool isApprovedOrOwner = (_msgSender() == from ||
2055             isApprovedForAll(from, _msgSender()) ||
2056             getApproved(tokenId) == _msgSender());
2057 
2058         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2059         if (to == address(0)) revert TransferToZeroAddress();
2060 
2061         _beforeTokenTransfers(from, to, tokenId, 1);
2062 
2063         // Clear approvals from the previous owner
2064         _approve(address(0), tokenId, from);
2065 
2066         // Underflow of the sender's balance is impossible because we check for
2067         // ownership above and the recipient's balance can't realistically overflow.
2068         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2069         unchecked {
2070             _addressData[from].balance -= 1;
2071             _addressData[to].balance += 1;
2072 
2073             TokenOwnership storage currSlot = _ownerships[tokenId];
2074             currSlot.addr = to;
2075             currSlot.startTimestamp = uint64(block.timestamp);
2076 
2077             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2078             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2079             uint256 nextTokenId = tokenId + 1;
2080             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2081             if (nextSlot.addr == address(0)) {
2082                 // This will suffice for checking _exists(nextTokenId),
2083                 // as a burned slot cannot contain the zero address.
2084                 if (nextTokenId != _currentIndex) {
2085                     nextSlot.addr = from;
2086                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2087                 }
2088             }
2089         }
2090 
2091         emit Transfer(from, to, tokenId);
2092         _afterTokenTransfers(from, to, tokenId, 1);
2093     }
2094 
2095     /**
2096      * @dev Equivalent to `_burn(tokenId, false)`.
2097      */
2098     function _burn(uint256 tokenId) internal virtual {
2099         _burn(tokenId, false);
2100     }
2101 
2102     /**
2103      * @dev Destroys `tokenId`.
2104      * The approval is cleared when the token is burned.
2105      *
2106      * Requirements:
2107      *
2108      * - `tokenId` must exist.
2109      *
2110      * Emits a {Transfer} event.
2111      */
2112     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2113         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2114 
2115         address from = prevOwnership.addr;
2116 
2117         if (approvalCheck) {
2118             bool isApprovedOrOwner = (_msgSender() == from ||
2119                 isApprovedForAll(from, _msgSender()) ||
2120                 getApproved(tokenId) == _msgSender());
2121 
2122             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2123         }
2124 
2125         _beforeTokenTransfers(from, address(0), tokenId, 1);
2126 
2127         // Clear approvals from the previous owner
2128         _approve(address(0), tokenId, from);
2129 
2130         // Underflow of the sender's balance is impossible because we check for
2131         // ownership above and the recipient's balance can't realistically overflow.
2132         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2133         unchecked {
2134             AddressData storage addressData = _addressData[from];
2135             addressData.balance -= 1;
2136             addressData.numberBurned += 1;
2137 
2138             // Keep track of who burned the token, and the timestamp of burning.
2139             TokenOwnership storage currSlot = _ownerships[tokenId];
2140             currSlot.addr = from;
2141             currSlot.startTimestamp = uint64(block.timestamp);
2142             currSlot.burned = true;
2143 
2144             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2145             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2146             uint256 nextTokenId = tokenId + 1;
2147             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2148             if (nextSlot.addr == address(0)) {
2149                 // This will suffice for checking _exists(nextTokenId),
2150                 // as a burned slot cannot contain the zero address.
2151                 if (nextTokenId != _currentIndex) {
2152                     nextSlot.addr = from;
2153                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2154                 }
2155             }
2156         }
2157 
2158         emit Transfer(from, address(0), tokenId);
2159         _afterTokenTransfers(from, address(0), tokenId, 1);
2160 
2161         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2162         unchecked {
2163             _burnCounter++;
2164         }
2165     }
2166 
2167     /**
2168      * @dev Approve `to` to operate on `tokenId`
2169      *
2170      * Emits a {Approval} event.
2171      */
2172     function _approve(
2173         address to,
2174         uint256 tokenId,
2175         address owner
2176     ) private {
2177         _tokenApprovals[tokenId] = to;
2178         emit Approval(owner, to, tokenId);
2179     }
2180 
2181     /**
2182      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2183      *
2184      * @param from address representing the previous owner of the given token ID
2185      * @param to target address that will receive the tokens
2186      * @param tokenId uint256 ID of the token to be transferred
2187      * @param _data bytes optional data to send along with the call
2188      * @return bool whether the call correctly returned the expected magic value
2189      */
2190     function _checkContractOnERC721Received(
2191         address from,
2192         address to,
2193         uint256 tokenId,
2194         bytes memory _data
2195     ) private returns (bool) {
2196         try
2197             IERC721Receiver(to).onERC721Received(
2198                 _msgSender(),
2199                 from,
2200                 tokenId,
2201                 _data
2202             )
2203         returns (bytes4 retval) {
2204             return retval == IERC721Receiver(to).onERC721Received.selector;
2205         } catch (bytes memory reason) {
2206             if (reason.length == 0) {
2207                 revert TransferToNonERC721ReceiverImplementer();
2208             } else {
2209                 assembly {
2210                     revert(add(32, reason), mload(reason))
2211                 }
2212             }
2213         }
2214     }
2215 
2216     /**
2217      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2218      * And also called before burning one token.
2219      *
2220      * startTokenId - the first token id to be transferred
2221      * quantity - the amount to be transferred
2222      *
2223      * Calling conditions:
2224      *
2225      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2226      * transferred to `to`.
2227      * - When `from` is zero, `tokenId` will be minted for `to`.
2228      * - When `to` is zero, `tokenId` will be burned by `from`.
2229      * - `from` and `to` are never both zero.
2230      */
2231     function _beforeTokenTransfers(
2232         address from,
2233         address to,
2234         uint256 startTokenId,
2235         uint256 quantity
2236     ) internal virtual {}
2237 
2238     /**
2239      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2240      * minting.
2241      * And also called after one token has been burned.
2242      *
2243      * startTokenId - the first token id to be transferred
2244      * quantity - the amount to be transferred
2245      *
2246      * Calling conditions:
2247      *
2248      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2249      * transferred to `to`.
2250      * - When `from` is zero, `tokenId` has been minted for `to`.
2251      * - When `to` is zero, `tokenId` has been burned by `from`.
2252      * - `from` and `to` are never both zero.
2253      */
2254     function _afterTokenTransfers(
2255         address from,
2256         address to,
2257         uint256 startTokenId,
2258         uint256 quantity
2259     ) internal virtual {}
2260 }
2261 
2262 interface IOperatorAccessControl {
2263     event RoleGranted(
2264         bytes32 indexed role,
2265         address indexed account,
2266         address indexed sender
2267     );
2268 
2269     event RoleRevoked(
2270         bytes32 indexed role,
2271         address indexed account,
2272         address indexed sender
2273     );
2274 
2275     function hasRole(bytes32 role, address account)
2276         external
2277         view
2278         returns (bool);
2279 
2280     function isOperator(address account) external view returns (bool);
2281 
2282     function addOperator(address account) external;
2283 
2284     function revokeOperator(address account) external;
2285 }
2286 
2287 contract OperatorAccessControl is IOperatorAccessControl, Ownable {
2288     struct RoleData {
2289         mapping(address => bool) members;
2290         bytes32 adminRole;
2291     }
2292 
2293     mapping(bytes32 => RoleData) private _roles;
2294 
2295     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
2296 
2297     function hasRole(bytes32 role, address account)
2298         public
2299         view
2300         override
2301         returns (bool)
2302     {
2303         return _roles[role].members[account];
2304     }
2305 
2306     function _grantRole(bytes32 role, address account) private {
2307         if (!hasRole(role, account)) {
2308             _roles[role].members[account] = true;
2309             emit RoleGranted(role, account, _msgSender());
2310         }
2311     }
2312 
2313     function _setupRole(bytes32 role, address account) internal virtual {
2314         _grantRole(role, account);
2315     }
2316 
2317     function _revokeRole(bytes32 role, address account) private {
2318         if (hasRole(role, account)) {
2319             _roles[role].members[account] = false;
2320             emit RoleRevoked(role, account, _msgSender());
2321         }
2322     }
2323 
2324     modifier isOperatorOrOwner() {
2325         address _sender = _msgSender();
2326         require(
2327             isOperator(_sender) || owner() == _sender,
2328             "OperatorAccessControl: caller is not operator or owner"
2329         );
2330         _;
2331     }
2332 
2333     modifier onlyOperator() {
2334         require(
2335             isOperator(_msgSender()),
2336             "OperatorAccessControl: caller is not operator"
2337         );
2338         _;
2339     }
2340 
2341     function isOperator(address account) public view override returns (bool) {
2342         return hasRole(OPERATOR_ROLE, account);
2343     }
2344 
2345     function _addOperator(address account) internal virtual {
2346         _grantRole(OPERATOR_ROLE, account);
2347     }
2348 
2349     function addOperator(address account) public override onlyOperator {
2350         _grantRole(OPERATOR_ROLE, account);
2351     }
2352 
2353     function revokeOperator(address account) public override onlyOperator {
2354         _revokeRole(OPERATOR_ROLE, account);
2355     }
2356 }
2357 
2358 library Base64 {
2359     bytes internal constant TABLE =
2360         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
2361 
2362     /// @notice Encodes some bytes to the base64 representation
2363     function encode(bytes memory data) internal pure returns (string memory) {
2364         uint256 len = data.length;
2365         if (len == 0) return "";
2366 
2367         // multiply by 4/3 rounded up
2368         uint256 encodedLen = 4 * ((len + 2) / 3);
2369 
2370         // Add some extra buffer at the end
2371         bytes memory result = new bytes(encodedLen + 32);
2372 
2373         bytes memory table = TABLE;
2374 
2375         assembly {
2376             let tablePtr := add(table, 1)
2377             let resultPtr := add(result, 32)
2378 
2379             for {
2380                 let i := 0
2381             } lt(i, len) {
2382 
2383             } {
2384                 i := add(i, 3)
2385                 let input := and(mload(add(data, i)), 0xffffff)
2386 
2387                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
2388                 out := shl(8, out)
2389                 out := add(
2390                     out,
2391                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
2392                 )
2393                 out := shl(8, out)
2394                 out := add(
2395                     out,
2396                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
2397                 )
2398                 out := shl(8, out)
2399                 out := add(
2400                     out,
2401                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
2402                 )
2403                 out := shl(224, out)
2404 
2405                 mstore(resultPtr, out)
2406 
2407                 resultPtr := add(resultPtr, 4)
2408             }
2409 
2410             switch mod(len, 3)
2411             case 1 {
2412                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
2413             }
2414             case 2 {
2415                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
2416             }
2417 
2418             mstore(result, encodedLen)
2419         }
2420 
2421         return string(result);
2422     }
2423 }
2424 
2425 /*
2426                                                                                                                                                                         
2427                                                    :*****.    +***                ***=                                                                                  
2428         .-=                                        :#%%%%.    #%%%      .--      .%%%*                      ...   .::.          .::::.      ....      ....     ....     
2429        +%%%                                          +%%%.    =+++     #%%*       +++=                      +**+-*****+:      :+*******=.   +***.    +***+     +**+     
2430      ::#%%%:::.  :::::  -==:   .-====-:       .-===: +%%%.  .:::::   ::%%%*:::  ::::::       :====-.     ---************:    +****+++****:  -***-   :*****-   -***:     
2431      *%%%%%%%%- .%%%%%:#%%%+ .*%%%##%%%*.    +%%%%%%#*%%%.  =%%%%%   %%%%%%%%%. *%%%%*    .+%%%%%%%%+.   %%%****#%%%#***+   =***=.   :+***:  +***   +******.  +**+      
2432      ::*%%%:::.  :=%%%%#=--: +%%#.  .#%%+   +%%%+:.:+%%%%.  .:*%%%   ::%%%*:::  .:%%%*   .#%%%-..-#%%%.  :-%****. :#%***+  .***+      :***=  -***- -***.***- :***:      
2433        *%%%       -%%%#      ..:::---*%%#  .%%%*     +%%%.    +%%%     %%%*       #%%*   +%%%:    :%%%+   :%***+   =%***+  .***=      .***=   +**+.+**- -***.+**+       
2434        *%%%       -%%%-      :*%%%%%%%%%#  :%%%=     -%%%.    +%%%     %%%*       #%%*   *%%%      %%%#   :%***+   -%***+   ***+.     -***-   :***+**+   +**+***:       
2435        *%%%       -%%%:     .%%%*:.  +%%#  :%%%+     =%%%.    +%%%     %%%*       #%%*   *%%%.     %%%#   :%***+   -%***+   -***+-..:=***+.    +*****-   -*****+        
2436        *%%%  ##:  -%%%:     :%%%:   :%%%#   #%%%:   .#%%%.    +%%%     %%%* :##   #%%*   :%%%*    +%%%-   :%***+   -%***+    -**********+.     :****+     +****:        
2437        -%%%##%%..##%%%##-    #%%%++*%#%%%#= :#%%%**#%*%%%#* -#%%%%#*   +%%%*#%* +#%%%%#=  -%%%%**%%%%=   ##%####..##%####.    .-+****+=:        =+++:     :+++=         
2438         :*#%#+: .*******-     =*#%#+:-****-  .=*#%#*:.****+ :******=    =*#%#+. =******-   .-*#%%#*=.    *******..*******.                                              
2439         
2440 */
2441 contract NUO is ERC721A, OperatorAccessControl, ReentrancyGuard {
2442     bytes32 public _kycMintMerkleRoot;
2443     bytes32 public _preMintMerkleRoot;
2444 
2445     mapping(uint256 => uint256) private stakeStarted;
2446 
2447     mapping(uint256 => uint256) private stakeTotal;
2448 
2449     mapping(address => uint256) private addressMintCount;
2450 
2451     uint256 private _kycMintLimit = 0;
2452 
2453     uint256 private _preMintLimit = 0;
2454 
2455     uint256 private _publicMintLimit = 0;
2456 
2457     uint256 private _superMintLimit = 1000;
2458 
2459     uint256 private _addressMintLimit = 0;
2460 
2461     uint256 private _kycMintCount;
2462 
2463     uint256 private _preMintCount;
2464 
2465     uint256 private _publicMintCount;
2466 
2467     uint256 private _superMintCount;
2468 
2469     uint256 private _kycMintPrice = 0;
2470 
2471     uint256 private _preMintPrice = 0;
2472 
2473     uint256 private _publicMintPrice = 0;
2474 
2475     bool private _kycMintOpen = false;
2476 
2477     bool private _preMintOpen = false;
2478 
2479     bool private _publicMintOpen = false;
2480 
2481     bool private _superMintOpen = false;
2482 
2483     uint256 _totalSupply = 2006;
2484 
2485     uint256 _totalTokens;
2486 
2487     bool private _transferOpen = false;
2488 
2489     string private _nftName = "NUO";
2490     string private _baseUri =
2491         "ipfs://QmVDNBSAEe996o9mAHaZLa5bqK726FovEehdwJeFYYDc6Q";
2492 
2493     constructor() ERC721A(_nftName, _nftName) Ownable() {
2494         _addOperator(_msgSender());
2495     }
2496 
2497     function getMintCount()
2498         public
2499         view
2500         returns (
2501             uint256 kycMintCount,
2502             uint256 preMintCount,
2503             uint256 publicMintCount,
2504             uint256 superMintCount
2505         )
2506     {
2507         kycMintCount = _kycMintCount;
2508         preMintCount = _preMintCount;
2509         publicMintCount = _publicMintCount;
2510         superMintCount = _superMintCount;
2511     }
2512 
2513     function setMerkleRoot(bytes32 kycMintMerkleRoot, bytes32 preMintMerkleRoot)
2514         public
2515         onlyOperator
2516     {
2517         _kycMintMerkleRoot = kycMintMerkleRoot;
2518         _preMintMerkleRoot = preMintMerkleRoot;
2519     }
2520 
2521     function isWhitelist(
2522         bytes32[] calldata kycMerkleProof,
2523         bytes32[] calldata preMerkleProof
2524     ) public view returns (bool isKycWhitelist, bool isPreWhitelist) {
2525         isKycWhitelist = MerkleProof.verify(
2526             kycMerkleProof,
2527             _kycMintMerkleRoot,
2528             keccak256(abi.encodePacked(msg.sender))
2529         );
2530 
2531         isPreWhitelist = MerkleProof.verify(
2532             preMerkleProof,
2533             _preMintMerkleRoot,
2534             keccak256(abi.encodePacked(msg.sender))
2535         );
2536     }
2537 
2538     function setMintLimit(
2539         uint256 kycMintLimit,
2540         uint256 preMintLimit,
2541         uint256 publicMintLimit,
2542         uint256 addressMintLimit,
2543         uint256 superMintLimit
2544     ) public onlyOperator {
2545         _kycMintLimit = kycMintLimit;
2546         _preMintLimit = preMintLimit;
2547         _publicMintLimit = publicMintLimit;
2548         _addressMintLimit = addressMintLimit;
2549         _superMintLimit = superMintLimit;
2550     }
2551 
2552     function getMintLimit()
2553         public
2554         view
2555         returns (
2556             uint256 kycMintLimit,
2557             uint256 preMintLimit,
2558             uint256 publicMintLimit,
2559             uint256 addressMintLimit,
2560             uint256 superMintLimit
2561         )
2562     {
2563         kycMintLimit = _kycMintLimit;
2564         preMintLimit = _preMintLimit;
2565         publicMintLimit = _publicMintLimit;
2566         addressMintLimit = _addressMintLimit;
2567         superMintLimit = _superMintLimit;
2568     }
2569 
2570     function setMintPrice(
2571         uint256 kycMintPrice,
2572         uint256 preMintPrice,
2573         uint256 publicMintPrice
2574     ) public onlyOperator {
2575         _kycMintPrice = kycMintPrice;
2576         _preMintPrice = preMintPrice;
2577         _publicMintPrice = publicMintPrice;
2578     }
2579 
2580     function getMintPrice()
2581         public
2582         view
2583         returns (
2584             uint256 kycMintPrice,
2585             uint256 preMintPrice,
2586             uint256 publicMintPrice
2587         )
2588     {
2589         kycMintPrice = _kycMintPrice;
2590         preMintPrice = _preMintPrice;
2591         publicMintPrice = _publicMintPrice;
2592     }
2593 
2594     function setSwith(
2595         bool kycMintOpen,
2596         bool preMintOpen,
2597         bool publicMintOpen,
2598         bool transferOpen,
2599         bool superMintOpen
2600     ) public onlyOperator {
2601         _kycMintOpen = kycMintOpen;
2602         _preMintOpen = preMintOpen;
2603         _publicMintOpen = publicMintOpen;
2604         _transferOpen = transferOpen;
2605         _superMintOpen = superMintOpen;
2606     }
2607 
2608     function getSwith()
2609         public
2610         view
2611         returns (
2612             bool kycMintOpen,
2613             bool preMintOpen,
2614             bool publicMintOpen,
2615             bool transferOpen,
2616             bool superMintOpen
2617         )
2618     {
2619         kycMintOpen = _kycMintOpen;
2620         preMintOpen = _preMintOpen;
2621         publicMintOpen = _publicMintOpen;
2622         transferOpen = _transferOpen;
2623         superMintOpen = _superMintOpen;
2624     }
2625 
2626     function _handleMint(address to) internal {
2627         require(
2628             addressMintCount[to] < _addressMintLimit,
2629             "error:10003 already claimed"
2630         );
2631         require(
2632             _totalTokens < _totalSupply,
2633             "error:10010 Exceeding the total amount"
2634         );
2635 
2636         _safeMint(to, 1);
2637 
2638         addressMintCount[to] = addressMintCount[to] + 1;
2639 
2640         _totalTokens = _totalTokens + 1;
2641     }
2642 
2643     function kycMint(bytes32[] calldata merkleProof, uint256 count)
2644         public
2645         payable
2646         nonReentrant
2647     {
2648         require(count >= 1, "error:10010 Must be greater than 1");
2649 
2650         require(
2651             msg.value == _kycMintPrice * count,
2652             "error:10000 msg.value is incorrect"
2653         );
2654 
2655         require(_kycMintOpen, "error:10001 switch off");
2656 
2657         require(
2658             MerkleProof.verify(
2659                 merkleProof,
2660                 _kycMintMerkleRoot,
2661                 keccak256(abi.encodePacked(msg.sender))
2662             ),
2663             "error:10002 not in the whitelist"
2664         );
2665 
2666         for (uint256 i = 0; i < count; i++) {
2667             require(
2668                 _kycMintCount < _kycMintLimit,
2669                 "error:10004 Reach the limit"
2670             );
2671 
2672             _handleMint(_msgSender());
2673 
2674             _kycMintCount = _kycMintCount + 1;
2675         }
2676     }
2677 
2678     function preMint(bytes32[] calldata merkleProof, uint256 count)
2679         public
2680         payable
2681         nonReentrant
2682     {
2683         require(count >= 1, "error:10010 Must be greater than 1");
2684 
2685         require(
2686             msg.value == _preMintPrice * count,
2687             "error:10000 msg.value is incorrect"
2688         );
2689 
2690         require(_preMintOpen, "error:10001 switch off");
2691 
2692         require(
2693             MerkleProof.verify(
2694                 merkleProof,
2695                 _preMintMerkleRoot,
2696                 keccak256(abi.encodePacked(msg.sender))
2697             ),
2698             "error:10002 not in the whitelist"
2699         );
2700 
2701         for (uint256 i = 0; i < count; i++) {
2702             require(
2703                 _preMintCount < _preMintLimit,
2704                 "error:10004 Reach the limit"
2705             );
2706 
2707             _handleMint(_msgSender());
2708 
2709             _preMintCount = _preMintCount + 1;
2710         }
2711     }
2712 
2713     function publicMint(uint256 count) public payable nonReentrant {
2714         require(count >= 1, "error:10010 Must be greater than 1");
2715 
2716         require(
2717             msg.value == _publicMintPrice * count,
2718             "error:10000 msg.value is incorrect"
2719         );
2720 
2721         require(_publicMintOpen, "error:10001 switch off");
2722 
2723         for (uint256 i = 0; i < count; i++) {
2724             require(
2725                 _publicMintCount < _publicMintLimit,
2726                 "error:10004 Reach the limit"
2727             );
2728 
2729             _handleMint(_msgSender());
2730 
2731             _publicMintCount = _publicMintCount + 1;
2732         }
2733     }
2734 
2735     function operatorMint(
2736         address[] memory toAddresses,
2737         uint256[] memory amounts
2738     ) public onlyOperator {
2739         require(
2740             toAddresses.length == amounts.length,
2741             "error:10033 toAddresses length does not match amounts length"
2742         );
2743 
2744         uint256 _len = toAddresses.length;
2745         for (uint256 _i; _i < _len; _i++) {
2746             address to = toAddresses[_i];
2747             uint256 amount = amounts[_i];
2748 
2749             for (uint256 j = 0; j < amount; j++) {
2750                 require(
2751                     _totalTokens < _totalSupply,
2752                     "error:10010 Exceeding the total amount"
2753                 );
2754 
2755                 _safeMint(to, 1);
2756 
2757                 _totalTokens = _totalTokens + 1;
2758             }
2759         }
2760     }
2761 
2762     function getCanMintCount(address user) external view returns (uint256) {
2763         return _addressMintLimit - addressMintCount[user];
2764     }
2765 
2766     function stakePeriod(uint256 tokenId)
2767         external
2768         view
2769         returns (
2770             bool isStake,
2771             uint256 current,
2772             uint256 total
2773         )
2774     {
2775         uint256 start = stakeStarted[tokenId];
2776         if (start != 0) {
2777             isStake = true;
2778             current = block.timestamp - start;
2779         }
2780         total = current + stakeTotal[tokenId];
2781     }
2782 
2783     function getStakeTime(uint256 tokenId) public view returns (uint256) {
2784         return stakeStarted[tokenId];
2785     }
2786 
2787     bool public stakeOpen = false;
2788 
2789     function setStakeOpen(bool open) external onlyOperator {
2790         stakeOpen = open;
2791     }
2792 
2793     event Staked(uint256 indexed tokenId, uint256 indexed time);
2794 
2795     event UnStaked(uint256 indexed tokenId, uint256 indexed time);
2796 
2797     function stake(uint256[] calldata tokenIds) external {
2798         require(stakeOpen, "error:10006 stake closed");
2799 
2800         uint256 n = tokenIds.length;
2801         for (uint256 i = 0; i < n; ++i) {
2802             uint256 tokenId = tokenIds[i];
2803             require(
2804                 _ownershipOf(tokenId).addr == _msgSender(),
2805                 "error:10005 Not owner"
2806             );
2807 
2808             uint256 start = stakeStarted[tokenId];
2809             if (start == 0) {
2810                 stakeStarted[tokenId] = block.timestamp;
2811                 emit Staked(tokenId, block.timestamp);
2812             }
2813         }
2814     }
2815 
2816     function unStake(uint256[] calldata tokenIds) external {
2817         uint256 n = tokenIds.length;
2818         for (uint256 i = 0; i < n; ++i) {
2819             uint256 tokenId = tokenIds[i];
2820             require(
2821                 _ownershipOf(tokenId).addr == _msgSender(),
2822                 "error:10005 Not owner"
2823             );
2824 
2825             uint256 start = stakeStarted[tokenId];
2826             if (start > 0) {
2827                 stakeTotal[tokenId] += block.timestamp - start;
2828                 stakeStarted[tokenId] = 0;
2829                 emit UnStaked(tokenId, block.timestamp);
2830             }
2831         }
2832     }
2833 
2834     function operatorUnStake(uint256[] calldata tokenIds)
2835         external
2836         onlyOperator
2837     {
2838         uint256 n = tokenIds.length;
2839         for (uint256 i = 0; i < n; ++i) {
2840             uint256 tokenId = tokenIds[i];
2841             uint256 start = stakeStarted[tokenId];
2842             if (start > 0) {
2843                 stakeTotal[tokenId] += block.timestamp - start;
2844                 stakeStarted[tokenId] = 0;
2845                 emit UnStaked(tokenId, block.timestamp);
2846             }
2847         }
2848     }
2849 
2850     uint256 private stakeTransfer = 1;
2851 
2852     function safeTransferWhileStake(
2853         address from,
2854         address to,
2855         uint256 tokenId
2856     ) external {
2857         require(ownerOf(tokenId) == _msgSender(), "error:10005 Not owner");
2858         stakeTransfer = 2;
2859         safeTransferFrom(from, to, tokenId);
2860         stakeTransfer = 1;
2861     }
2862 
2863     function _beforeTokenTransfers(
2864         address,
2865         address,
2866         uint256 startTokenId,
2867         uint256 quantity
2868     ) internal view override {
2869         uint256 tokenId = startTokenId;
2870         for (uint256 end = tokenId + quantity; tokenId < end; ++tokenId) {
2871             require(
2872                 stakeStarted[tokenId] == 0 ||
2873                     stakeTransfer == 2 ||
2874                     _transferOpen,
2875                 "error:10007 Stake can't transfer"
2876             );
2877         }
2878     }
2879 
2880     function setBaseUri(string memory baseUri) public onlyOperator {
2881         _baseUri = baseUri;
2882     }
2883 
2884     function tokenURI(uint256 tokenId)
2885         public
2886         view
2887         override
2888         returns (string memory)
2889     {
2890         return
2891             string(abi.encodePacked(_baseUri, "/", toString(tokenId), ".json"));
2892     }
2893 
2894     function supply() public view returns (uint256) {
2895         return _totalSupply;
2896     }
2897 
2898     function totalMinted() public view returns (uint256) {
2899         return _totalTokens;
2900     }
2901 
2902     function withdraw(address[] memory tokens, address _to)
2903         public
2904         onlyOperator
2905     {
2906         for (uint8 i; i < tokens.length; i++) {
2907             IERC20 token = IERC20(tokens[i]);
2908             uint256 b = token.balanceOf(address(this));
2909             if (b > 0) {
2910                 token.transfer(_to, b);
2911             }
2912         }
2913         uint256 balance = address(this).balance;
2914         payable(_to).transfer(balance);
2915     }
2916 
2917     function toString(uint256 value) internal pure returns (string memory) {
2918         if (value == 0) {
2919             return "0";
2920         }
2921         uint256 temp = value;
2922         uint256 digits;
2923         while (temp != 0) {
2924             digits++;
2925             temp /= 10;
2926         }
2927         bytes memory buffer = new bytes(digits);
2928         while (value != 0) {
2929             digits -= 1;
2930             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2931             value /= 10;
2932         }
2933         return string(buffer);
2934     }
2935 
2936     mapping(address => mapping(uint256 => uint256)) private superAddressToken;
2937 
2938     uint256 private _superMintPrice = 0;
2939 
2940     function setSuperMintPrice(uint256 superMintPrice) public onlyOperator {
2941         _superMintPrice = superMintPrice;
2942     }
2943 
2944     function getSuperMintPrice() public view returns (uint256) {
2945         return _superMintPrice;
2946     }
2947 
2948     mapping(address => uint256) private superAddress;
2949 
2950     function setSuperAddress(address contractAddress, uint256 count)
2951         public
2952         onlyOperator
2953     {
2954         superAddress[contractAddress] = count;
2955     }
2956 
2957     function getSuperAddress(address contractAddress)
2958         public
2959         view
2960         returns (uint256)
2961     {
2962         return superAddress[contractAddress];
2963     }
2964 
2965     function getTokenCanMintCount(address contractAddress, uint256 tokenId)
2966         public
2967         view
2968         returns (uint256)
2969     {
2970         if (superAddress[contractAddress] == 0) {
2971             return 0;
2972         }
2973         return
2974             superAddress[contractAddress] -
2975             superAddressToken[contractAddress][tokenId];
2976     }
2977 
2978     function superMint(
2979         address[] memory contracts,
2980         uint256[] memory tokenIds,
2981         uint256[] memory counts
2982     ) public payable nonReentrant {
2983         require(
2984             contracts.length == tokenIds.length,
2985             "error: 10000 contracts length does not match tokenIds length"
2986         );
2987 
2988         require(
2989             tokenIds.length == counts.length,
2990             "error: 10001 tokenIds length does not match counts length"
2991         );
2992 
2993         require(_superMintOpen, "error:10002 switch off");
2994 
2995         uint256 totalMintCount = 0;
2996         for (uint256 i = 0; i < tokenIds.length; i++) {
2997             totalMintCount = totalMintCount + counts[i];
2998         }
2999 
3000         require(totalMintCount < 30, "error: 10003 Limit 30");
3001 
3002         require(
3003             msg.value == _superMintPrice * totalMintCount,
3004             "error:10004 msg.value is incorrect"
3005         );
3006 
3007         for (uint256 i = 0; i < tokenIds.length; i++) {
3008             address contractAddress = contracts[i];
3009             uint256 tokenId = tokenIds[i];
3010             uint256 mintCount = counts[i];
3011 
3012             require(
3013                 IERC721(contractAddress).ownerOf(tokenId) == msg.sender,
3014                 "error:10005 No owner"
3015             );
3016 
3017             require(
3018                 superAddress[contractAddress] > 0,
3019                 "error:10006 Contract cannot mint"
3020             );
3021 
3022             require(
3023                 superAddressToken[contractAddress][tokenId] + mintCount <=
3024                     superAddress[contractAddress],
3025                 "error:10007 Greater than maximum quantity"
3026             );
3027 
3028             require(
3029                 _totalTokens + mintCount <= _totalSupply,
3030                 "error:10008 Exceeding the total amount"
3031             );
3032 
3033             require(
3034                 _superMintCount + mintCount <= _superMintLimit,
3035                 "error:10009 Reach the limit"
3036             );
3037 
3038             for (uint256 j = 0; j < mintCount; j++) {
3039                 _safeMint(msg.sender, 1);
3040             }
3041 
3042             _superMintCount = _superMintCount + mintCount;
3043 
3044             _totalTokens = _totalTokens + mintCount;
3045 
3046             superAddressToken[contractAddress][tokenId] =
3047                 superAddressToken[contractAddress][tokenId] +
3048                 mintCount;
3049         }
3050     }
3051 }