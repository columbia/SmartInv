1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.17;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         _nonReentrantBefore();
55         _;
56         _nonReentrantAfter();
57     }
58 
59     function _nonReentrantBefore() private {
60         // On the first call to nonReentrant, _status will be _NOT_ENTERED
61         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
62 
63         // Any calls to nonReentrant after this point will fail
64         _status = _ENTERED;
65     }
66 
67     function _nonReentrantAfter() private {
68         // By storing the original value once again, a refund is triggered (see
69         // https://eips.ethereum.org/EIPS/eip-2200)
70         _status = _NOT_ENTERED;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
75 
76 
77 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
78 
79 /**
80  * @dev These functions deal with verification of Merkle Tree proofs.
81  *
82  * The tree and the proofs can be generated using our
83  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
84  * You will find a quickstart guide in the readme.
85  *
86  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
87  * hashing, or use a hash function other than keccak256 for hashing leaves.
88  * This is because the concatenation of a sorted pair of internal nodes in
89  * the merkle tree could be reinterpreted as a leaf value.
90  * OpenZeppelin's JavaScript library generates merkle trees that are safe
91  * against this attack out of the box.
92  */
93 library MerkleProof {
94     /**
95      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
96      * defined by `root`. For this, a `proof` must be provided, containing
97      * sibling hashes on the branch from the leaf to the root of the tree. Each
98      * pair of leaves and each pair of pre-images are assumed to be sorted.
99      */
100     function verify(
101         bytes32[] memory proof,
102         bytes32 root,
103         bytes32 leaf
104     ) internal pure returns (bool) {
105         return processProof(proof, leaf) == root;
106     }
107 
108     /**
109      * @dev Calldata version of {verify}
110      *
111      * _Available since v4.7._
112      */
113     function verifyCalldata(
114         bytes32[] calldata proof,
115         bytes32 root,
116         bytes32 leaf
117     ) internal pure returns (bool) {
118         return processProofCalldata(proof, leaf) == root;
119     }
120 
121     /**
122      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
123      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
124      * hash matches the root of the tree. When processing the proof, the pairs
125      * of leafs & pre-images are assumed to be sorted.
126      *
127      * _Available since v4.4._
128      */
129     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
130         bytes32 computedHash = leaf;
131         for (uint256 i = 0; i < proof.length; i++) {
132             computedHash = _hashPair(computedHash, proof[i]);
133         }
134         return computedHash;
135     }
136 
137     /**
138      * @dev Calldata version of {processProof}
139      *
140      * _Available since v4.7._
141      */
142     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
143         bytes32 computedHash = leaf;
144         for (uint256 i = 0; i < proof.length; i++) {
145             computedHash = _hashPair(computedHash, proof[i]);
146         }
147         return computedHash;
148     }
149 
150     /**
151      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
152      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
153      *
154      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
155      *
156      * _Available since v4.7._
157      */
158     function multiProofVerify(
159         bytes32[] memory proof,
160         bool[] memory proofFlags,
161         bytes32 root,
162         bytes32[] memory leaves
163     ) internal pure returns (bool) {
164         return processMultiProof(proof, proofFlags, leaves) == root;
165     }
166 
167     /**
168      * @dev Calldata version of {multiProofVerify}
169      *
170      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
171      *
172      * _Available since v4.7._
173      */
174     function multiProofVerifyCalldata(
175         bytes32[] calldata proof,
176         bool[] calldata proofFlags,
177         bytes32 root,
178         bytes32[] memory leaves
179     ) internal pure returns (bool) {
180         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
181     }
182 
183     /**
184      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
185      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
186      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
187      * respectively.
188      *
189      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
190      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
191      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
192      *
193      * _Available since v4.7._
194      */
195     function processMultiProof(
196         bytes32[] memory proof,
197         bool[] memory proofFlags,
198         bytes32[] memory leaves
199     ) internal pure returns (bytes32 merkleRoot) {
200         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
201         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
202         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
203         // the merkle tree.
204         uint256 leavesLen = leaves.length;
205         uint256 totalHashes = proofFlags.length;
206 
207         // Check proof validity.
208         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
209 
210         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
211         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
212         bytes32[] memory hashes = new bytes32[](totalHashes);
213         uint256 leafPos = 0;
214         uint256 hashPos = 0;
215         uint256 proofPos = 0;
216         // At each step, we compute the next hash using two values:
217         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
218         //   get the next hash.
219         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
220         //   `proof` array.
221         for (uint256 i = 0; i < totalHashes; i++) {
222             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
223             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
224             hashes[i] = _hashPair(a, b);
225         }
226 
227         if (totalHashes > 0) {
228             return hashes[totalHashes - 1];
229         } else if (leavesLen > 0) {
230             return leaves[0];
231         } else {
232             return proof[0];
233         }
234     }
235 
236     /**
237      * @dev Calldata version of {processMultiProof}.
238      *
239      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
240      *
241      * _Available since v4.7._
242      */
243     function processMultiProofCalldata(
244         bytes32[] calldata proof,
245         bool[] calldata proofFlags,
246         bytes32[] memory leaves
247     ) internal pure returns (bytes32 merkleRoot) {
248         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
249         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
250         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
251         // the merkle tree.
252         uint256 leavesLen = leaves.length;
253         uint256 totalHashes = proofFlags.length;
254 
255         // Check proof validity.
256         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
257 
258         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
259         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
260         bytes32[] memory hashes = new bytes32[](totalHashes);
261         uint256 leafPos = 0;
262         uint256 hashPos = 0;
263         uint256 proofPos = 0;
264         // At each step, we compute the next hash using two values:
265         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
266         //   get the next hash.
267         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
268         //   `proof` array.
269         for (uint256 i = 0; i < totalHashes; i++) {
270             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
271             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
272             hashes[i] = _hashPair(a, b);
273         }
274 
275         if (totalHashes > 0) {
276             return hashes[totalHashes - 1];
277         } else if (leavesLen > 0) {
278             return leaves[0];
279         } else {
280             return proof[0];
281         }
282     }
283 
284     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
285         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
286     }
287 
288     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
289         /// @solidity memory-safe-assembly
290         assembly {
291             mstore(0x00, a)
292             mstore(0x20, b)
293             value := keccak256(0x00, 0x40)
294         }
295     }
296 }
297 
298 // File: @openzeppelin/contracts/utils/math/Math.sol
299 
300 
301 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
302 
303 
304 /**
305  * @dev Standard math utilities missing in the Solidity language.
306  */
307 library Math {
308     enum Rounding {
309         Down, // Toward negative infinity
310         Up, // Toward infinity
311         Zero // Toward zero
312     }
313 
314     /**
315      * @dev Returns the largest of two numbers.
316      */
317     function max(uint256 a, uint256 b) internal pure returns (uint256) {
318         return a > b ? a : b;
319     }
320 
321     /**
322      * @dev Returns the smallest of two numbers.
323      */
324     function min(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a < b ? a : b;
326     }
327 
328     /**
329      * @dev Returns the average of two numbers. The result is rounded towards
330      * zero.
331      */
332     function average(uint256 a, uint256 b) internal pure returns (uint256) {
333         // (a + b) / 2 can overflow.
334         return (a & b) + (a ^ b) / 2;
335     }
336 
337     /**
338      * @dev Returns the ceiling of the division of two numbers.
339      *
340      * This differs from standard division with `/` in that it rounds up instead
341      * of rounding down.
342      */
343     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
344         // (a + b - 1) / b can overflow on addition, so we distribute.
345         return a == 0 ? 0 : (a - 1) / b + 1;
346     }
347 
348     /**
349      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
350      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
351      * with further edits by Uniswap Labs also under MIT license.
352      */
353     function mulDiv(
354         uint256 x,
355         uint256 y,
356         uint256 denominator
357     ) internal pure returns (uint256 result) {
358         unchecked {
359             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
360             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
361             // variables such that product = prod1 * 2^256 + prod0.
362             uint256 prod0; // Least significant 256 bits of the product
363             uint256 prod1; // Most significant 256 bits of the product
364             assembly {
365                 let mm := mulmod(x, y, not(0))
366                 prod0 := mul(x, y)
367                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
368             }
369 
370             // Handle non-overflow cases, 256 by 256 division.
371             if (prod1 == 0) {
372                 return prod0 / denominator;
373             }
374 
375             // Make sure the result is less than 2^256. Also prevents denominator == 0.
376             require(denominator > prod1);
377 
378             ///////////////////////////////////////////////
379             // 512 by 256 division.
380             ///////////////////////////////////////////////
381 
382             // Make division exact by subtracting the remainder from [prod1 prod0].
383             uint256 remainder;
384             assembly {
385                 // Compute remainder using mulmod.
386                 remainder := mulmod(x, y, denominator)
387 
388                 // Subtract 256 bit number from 512 bit number.
389                 prod1 := sub(prod1, gt(remainder, prod0))
390                 prod0 := sub(prod0, remainder)
391             }
392 
393             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
394             // See https://cs.stackexchange.com/q/138556/92363.
395 
396             // Does not overflow because the denominator cannot be zero at this stage in the function.
397             uint256 twos = denominator & (~denominator + 1);
398             assembly {
399                 // Divide denominator by twos.
400                 denominator := div(denominator, twos)
401 
402                 // Divide [prod1 prod0] by twos.
403                 prod0 := div(prod0, twos)
404 
405                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
406                 twos := add(div(sub(0, twos), twos), 1)
407             }
408 
409             // Shift in bits from prod1 into prod0.
410             prod0 |= prod1 * twos;
411 
412             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
413             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
414             // four bits. That is, denominator * inv = 1 mod 2^4.
415             uint256 inverse = (3 * denominator) ^ 2;
416 
417             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
418             // in modular arithmetic, doubling the correct bits in each step.
419             inverse *= 2 - denominator * inverse; // inverse mod 2^8
420             inverse *= 2 - denominator * inverse; // inverse mod 2^16
421             inverse *= 2 - denominator * inverse; // inverse mod 2^32
422             inverse *= 2 - denominator * inverse; // inverse mod 2^64
423             inverse *= 2 - denominator * inverse; // inverse mod 2^128
424             inverse *= 2 - denominator * inverse; // inverse mod 2^256
425 
426             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
427             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
428             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
429             // is no longer required.
430             result = prod0 * inverse;
431             return result;
432         }
433     }
434 
435     /**
436      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
437      */
438     function mulDiv(
439         uint256 x,
440         uint256 y,
441         uint256 denominator,
442         Rounding rounding
443     ) internal pure returns (uint256) {
444         uint256 result = mulDiv(x, y, denominator);
445         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
446             result += 1;
447         }
448         return result;
449     }
450 
451     /**
452      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
453      *
454      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
455      */
456     function sqrt(uint256 a) internal pure returns (uint256) {
457         if (a == 0) {
458             return 0;
459         }
460 
461         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
462         //
463         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
464         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
465         //
466         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
467         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
468         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
469         //
470         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
471         uint256 result = 1 << (log2(a) >> 1);
472 
473         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
474         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
475         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
476         // into the expected uint128 result.
477         unchecked {
478             result = (result + a / result) >> 1;
479             result = (result + a / result) >> 1;
480             result = (result + a / result) >> 1;
481             result = (result + a / result) >> 1;
482             result = (result + a / result) >> 1;
483             result = (result + a / result) >> 1;
484             result = (result + a / result) >> 1;
485             return min(result, a / result);
486         }
487     }
488 
489     /**
490      * @notice Calculates sqrt(a), following the selected rounding direction.
491      */
492     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
493         unchecked {
494             uint256 result = sqrt(a);
495             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
496         }
497     }
498 
499     /**
500      * @dev Return the log in base 2, rounded down, of a positive value.
501      * Returns 0 if given 0.
502      */
503     function log2(uint256 value) internal pure returns (uint256) {
504         uint256 result = 0;
505         unchecked {
506             if (value >> 128 > 0) {
507                 value >>= 128;
508                 result += 128;
509             }
510             if (value >> 64 > 0) {
511                 value >>= 64;
512                 result += 64;
513             }
514             if (value >> 32 > 0) {
515                 value >>= 32;
516                 result += 32;
517             }
518             if (value >> 16 > 0) {
519                 value >>= 16;
520                 result += 16;
521             }
522             if (value >> 8 > 0) {
523                 value >>= 8;
524                 result += 8;
525             }
526             if (value >> 4 > 0) {
527                 value >>= 4;
528                 result += 4;
529             }
530             if (value >> 2 > 0) {
531                 value >>= 2;
532                 result += 2;
533             }
534             if (value >> 1 > 0) {
535                 result += 1;
536             }
537         }
538         return result;
539     }
540 
541     /**
542      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
543      * Returns 0 if given 0.
544      */
545     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
546         unchecked {
547             uint256 result = log2(value);
548             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
549         }
550     }
551 
552     /**
553      * @dev Return the log in base 10, rounded down, of a positive value.
554      * Returns 0 if given 0.
555      */
556     function log10(uint256 value) internal pure returns (uint256) {
557         uint256 result = 0;
558         unchecked {
559             if (value >= 10**64) {
560                 value /= 10**64;
561                 result += 64;
562             }
563             if (value >= 10**32) {
564                 value /= 10**32;
565                 result += 32;
566             }
567             if (value >= 10**16) {
568                 value /= 10**16;
569                 result += 16;
570             }
571             if (value >= 10**8) {
572                 value /= 10**8;
573                 result += 8;
574             }
575             if (value >= 10**4) {
576                 value /= 10**4;
577                 result += 4;
578             }
579             if (value >= 10**2) {
580                 value /= 10**2;
581                 result += 2;
582             }
583             if (value >= 10**1) {
584                 result += 1;
585             }
586         }
587         return result;
588     }
589 
590     /**
591      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
592      * Returns 0 if given 0.
593      */
594     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
595         unchecked {
596             uint256 result = log10(value);
597             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
598         }
599     }
600 
601     /**
602      * @dev Return the log in base 256, rounded down, of a positive value.
603      * Returns 0 if given 0.
604      *
605      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
606      */
607     function log256(uint256 value) internal pure returns (uint256) {
608         uint256 result = 0;
609         unchecked {
610             if (value >> 128 > 0) {
611                 value >>= 128;
612                 result += 16;
613             }
614             if (value >> 64 > 0) {
615                 value >>= 64;
616                 result += 8;
617             }
618             if (value >> 32 > 0) {
619                 value >>= 32;
620                 result += 4;
621             }
622             if (value >> 16 > 0) {
623                 value >>= 16;
624                 result += 2;
625             }
626             if (value >> 8 > 0) {
627                 result += 1;
628             }
629         }
630         return result;
631     }
632 
633     /**
634      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
635      * Returns 0 if given 0.
636      */
637     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
638         unchecked {
639             uint256 result = log256(value);
640             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
641         }
642     }
643 }
644 
645 // File: @openzeppelin/contracts/utils/Strings.sol
646 
647 
648 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
649 
650 
651 /**
652  * @dev String operations.
653  */
654 library Strings {
655     bytes16 private constant _SYMBOLS = "0123456789abcdef";
656     uint8 private constant _ADDRESS_LENGTH = 20;
657 
658     /**
659      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
660      */
661     function toString(uint256 value) internal pure returns (string memory) {
662         unchecked {
663             uint256 length = Math.log10(value) + 1;
664             string memory buffer = new string(length);
665             uint256 ptr;
666             /// @solidity memory-safe-assembly
667             assembly {
668                 ptr := add(buffer, add(32, length))
669             }
670             while (true) {
671                 ptr--;
672                 /// @solidity memory-safe-assembly
673                 assembly {
674                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
675                 }
676                 value /= 10;
677                 if (value == 0) break;
678             }
679             return buffer;
680         }
681     }
682 
683     /**
684      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
685      */
686     function toHexString(uint256 value) internal pure returns (string memory) {
687         unchecked {
688             return toHexString(value, Math.log256(value) + 1);
689         }
690     }
691 
692     /**
693      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
694      */
695     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
696         bytes memory buffer = new bytes(2 * length + 2);
697         buffer[0] = "0";
698         buffer[1] = "x";
699         for (uint256 i = 2 * length + 1; i > 1; --i) {
700             buffer[i] = _SYMBOLS[value & 0xf];
701             value >>= 4;
702         }
703         require(value == 0, "Strings: hex length insufficient");
704         return string(buffer);
705     }
706 
707     /**
708      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
709      */
710     function toHexString(address addr) internal pure returns (string memory) {
711         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
712     }
713 }
714 
715 // File: @openzeppelin/contracts/utils/Context.sol
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
719 
720 
721 /**
722  * @dev Provides information about the current execution context, including the
723  * sender of the transaction and its data. While these are generally available
724  * via msg.sender and msg.data, they should not be accessed in such a direct
725  * manner, since when dealing with meta-transactions the account sending and
726  * paying for execution may not be the actual sender (as far as an application
727  * is concerned).
728  *
729  * This contract is only required for intermediate, library-like contracts.
730  */
731 abstract contract Context {
732     function _msgSender() internal view virtual returns (address) {
733         return msg.sender;
734     }
735 
736     function _msgData() internal view virtual returns (bytes calldata) {
737         return msg.data;
738     }
739 }
740 
741 // File: @openzeppelin/contracts/access/Ownable.sol
742 
743 
744 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
745 
746 
747 /**
748  * @dev Contract module which provides a basic access control mechanism, where
749  * there is an account (an owner) that can be granted exclusive access to
750  * specific functions.
751  *
752  * By default, the owner account will be the one that deploys the contract. This
753  * can later be changed with {transferOwnership}.
754  *
755  * This module is used through inheritance. It will make available the modifier
756  * `onlyOwner`, which can be applied to your functions to restrict their use to
757  * the owner.
758  */
759 abstract contract Ownable is Context {
760     address private _owner;
761 
762     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
763 
764     /**
765      * @dev Initializes the contract setting the deployer as the initial owner.
766      */
767     constructor() {
768         _transferOwnership(_msgSender());
769     }
770 
771     /**
772      * @dev Throws if called by any account other than the owner.
773      */
774     modifier onlyOwner() {
775         _checkOwner();
776         _;
777     }
778 
779     /**
780      * @dev Returns the address of the current owner.
781      */
782     function owner() public view virtual returns (address) {
783         return _owner;
784     }
785 
786     /**
787      * @dev Throws if the sender is not the owner.
788      */
789     function _checkOwner() internal view virtual {
790         require(owner() == _msgSender(), "Ownable: caller is not the owner");
791     }
792 
793     /**
794      * @dev Leaves the contract without owner. It will not be possible to call
795      * `onlyOwner` functions anymore. Can only be called by the current owner.
796      *
797      * NOTE: Renouncing ownership will leave the contract without an owner,
798      * thereby removing any functionality that is only available to the owner.
799      */
800     function renounceOwnership() public virtual onlyOwner {
801         _transferOwnership(address(0));
802     }
803 
804     /**
805      * @dev Transfers ownership of the contract to a new account (`newOwner`).
806      * Can only be called by the current owner.
807      */
808     function transferOwnership(address newOwner) public virtual onlyOwner {
809         require(newOwner != address(0), "Ownable: new owner is the zero address");
810         _transferOwnership(newOwner);
811     }
812 
813     /**
814      * @dev Transfers ownership of the contract to a new account (`newOwner`).
815      * Internal function without access restriction.
816      */
817     function _transferOwnership(address newOwner) internal virtual {
818         address oldOwner = _owner;
819         _owner = newOwner;
820         emit OwnershipTransferred(oldOwner, newOwner);
821     }
822 }
823 
824 // File: erc721a/contracts/IERC721A.sol
825 
826 
827 // ERC721A Contracts v4.2.3
828 // Creator: Chiru Labs
829 
830 
831 /**
832  * @dev Interface of ERC721A.
833  */
834 interface IERC721A {
835     /**
836      * The caller must own the token or be an approved operator.
837      */
838     error ApprovalCallerNotOwnerNorApproved();
839 
840     /**
841      * The token does not exist.
842      */
843     error ApprovalQueryForNonexistentToken();
844 
845     /**
846      * Cannot query the balance for the zero address.
847      */
848     error BalanceQueryForZeroAddress();
849 
850     /**
851      * Cannot mint to the zero address.
852      */
853     error MintToZeroAddress();
854 
855     /**
856      * The quantity of tokens minted must be more than zero.
857      */
858     error MintZeroQuantity();
859 
860     /**
861      * The token does not exist.
862      */
863     error OwnerQueryForNonexistentToken();
864 
865     /**
866      * The caller must own the token or be an approved operator.
867      */
868     error TransferCallerNotOwnerNorApproved();
869 
870     /**
871      * The token must be owned by `from`.
872      */
873     error TransferFromIncorrectOwner();
874 
875     /**
876      * Cannot safely transfer to a contract that does not implement the
877      * ERC721Receiver interface.
878      */
879     error TransferToNonERC721ReceiverImplementer();
880 
881     /**
882      * Cannot transfer to the zero address.
883      */
884     error TransferToZeroAddress();
885 
886     /**
887      * The token does not exist.
888      */
889     error URIQueryForNonexistentToken();
890 
891     /**
892      * The `quantity` minted with ERC2309 exceeds the safety limit.
893      */
894     error MintERC2309QuantityExceedsLimit();
895 
896     /**
897      * The `extraData` cannot be set on an unintialized ownership slot.
898      */
899     error OwnershipNotInitializedForExtraData();
900 
901     // =============================================================
902     //                            STRUCTS
903     // =============================================================
904 
905     struct TokenOwnership {
906         // The address of the owner.
907         address addr;
908         // Stores the start time of ownership with minimal overhead for tokenomics.
909         uint64 startTimestamp;
910         // Whether the token has been burned.
911         bool burned;
912         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
913         uint24 extraData;
914     }
915 
916     // =============================================================
917     //                         TOKEN COUNTERS
918     // =============================================================
919 
920     /**
921      * @dev Returns the total number of tokens in existence.
922      * Burned tokens will reduce the count.
923      * To get the total number of tokens minted, please see {_totalMinted}.
924      */
925     function totalSupply() external view returns (uint256);
926 
927     // =============================================================
928     //                            IERC165
929     // =============================================================
930 
931     /**
932      * @dev Returns true if this contract implements the interface defined by
933      * `interfaceId`. See the corresponding
934      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
935      * to learn more about how these ids are created.
936      *
937      * This function call must use less than 30000 gas.
938      */
939     function supportsInterface(bytes4 interfaceId) external view returns (bool);
940 
941     // =============================================================
942     //                            IERC721
943     // =============================================================
944 
945     /**
946      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
947      */
948     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
949 
950     /**
951      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
952      */
953     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
954 
955     /**
956      * @dev Emitted when `owner` enables or disables
957      * (`approved`) `operator` to manage all of its assets.
958      */
959     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
960 
961     /**
962      * @dev Returns the number of tokens in `owner`'s account.
963      */
964     function balanceOf(address owner) external view returns (uint256 balance);
965 
966     /**
967      * @dev Returns the owner of the `tokenId` token.
968      *
969      * Requirements:
970      *
971      * - `tokenId` must exist.
972      */
973     function ownerOf(uint256 tokenId) external view returns (address owner);
974 
975     /**
976      * @dev Safely transfers `tokenId` token from `from` to `to`,
977      * checking first that contract recipients are aware of the ERC721 protocol
978      * to prevent tokens from being forever locked.
979      *
980      * Requirements:
981      *
982      * - `from` cannot be the zero address.
983      * - `to` cannot be the zero address.
984      * - `tokenId` token must exist and be owned by `from`.
985      * - If the caller is not `from`, it must be have been allowed to move
986      * this token by either {approve} or {setApprovalForAll}.
987      * - If `to` refers to a smart contract, it must implement
988      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
989      *
990      * Emits a {Transfer} event.
991      */
992     function safeTransferFrom(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes calldata data
997     ) external payable;
998 
999     /**
1000      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1001      */
1002     function safeTransferFrom(
1003         address from,
1004         address to,
1005         uint256 tokenId
1006     ) external payable;
1007 
1008     /**
1009      * @dev Transfers `tokenId` from `from` to `to`.
1010      *
1011      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1012      * whenever possible.
1013      *
1014      * Requirements:
1015      *
1016      * - `from` cannot be the zero address.
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must be owned by `from`.
1019      * - If the caller is not `from`, it must be approved to move this token
1020      * by either {approve} or {setApprovalForAll}.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function transferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) external payable;
1029 
1030     /**
1031      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1032      * The approval is cleared when the token is transferred.
1033      *
1034      * Only a single account can be approved at a time, so approving the
1035      * zero address clears previous approvals.
1036      *
1037      * Requirements:
1038      *
1039      * - The caller must own the token or be an approved operator.
1040      * - `tokenId` must exist.
1041      *
1042      * Emits an {Approval} event.
1043      */
1044     function approve(address to, uint256 tokenId) external payable;
1045 
1046     /**
1047      * @dev Approve or remove `operator` as an operator for the caller.
1048      * Operators can call {transferFrom} or {safeTransferFrom}
1049      * for any token owned by the caller.
1050      *
1051      * Requirements:
1052      *
1053      * - The `operator` cannot be the caller.
1054      *
1055      * Emits an {ApprovalForAll} event.
1056      */
1057     function setApprovalForAll(address operator, bool _approved) external;
1058 
1059     /**
1060      * @dev Returns the account approved for `tokenId` token.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      */
1066     function getApproved(uint256 tokenId) external view returns (address operator);
1067 
1068     /**
1069      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1070      *
1071      * See {setApprovalForAll}.
1072      */
1073     function isApprovedForAll(address owner, address operator) external view returns (bool);
1074 
1075     // =============================================================
1076     //                        IERC721Metadata
1077     // =============================================================
1078 
1079     /**
1080      * @dev Returns the token collection name.
1081      */
1082     function name() external view returns (string memory);
1083 
1084     /**
1085      * @dev Returns the token collection symbol.
1086      */
1087     function symbol() external view returns (string memory);
1088 
1089     /**
1090      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1091      */
1092     function tokenURI(uint256 tokenId) external view returns (string memory);
1093 
1094     // =============================================================
1095     //                           IERC2309
1096     // =============================================================
1097 
1098     /**
1099      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1100      * (inclusive) is transferred from `from` to `to`, as defined in the
1101      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1102      *
1103      * See {_mintERC2309} for more details.
1104      */
1105     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1106 }
1107 
1108 // File: erc721a/contracts/ERC721A.sol
1109 
1110 
1111 // ERC721A Contracts v4.2.3
1112 // Creator: Chiru Labs
1113 
1114 
1115 
1116 /**
1117  * @dev Interface of ERC721 token receiver.
1118  */
1119 interface ERC721A__IERC721Receiver {
1120     function onERC721Received(
1121         address operator,
1122         address from,
1123         uint256 tokenId,
1124         bytes calldata data
1125     ) external returns (bytes4);
1126 }
1127 
1128 /**
1129  * @title ERC721A
1130  *
1131  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1132  * Non-Fungible Token Standard, including the Metadata extension.
1133  * Optimized for lower gas during batch mints.
1134  *
1135  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1136  * starting from `_startTokenId()`.
1137  *
1138  * Assumptions:
1139  *
1140  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1141  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1142  */
1143 contract ERC721A is IERC721A {
1144     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1145     struct TokenApprovalRef {
1146         address value;
1147     }
1148 
1149     // =============================================================
1150     //                           CONSTANTS
1151     // =============================================================
1152 
1153     // Mask of an entry in packed address data.
1154     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1155 
1156     // The bit position of `numberMinted` in packed address data.
1157     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1158 
1159     // The bit position of `numberBurned` in packed address data.
1160     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1161 
1162     // The bit position of `aux` in packed address data.
1163     uint256 private constant _BITPOS_AUX = 192;
1164 
1165     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1166     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1167 
1168     // The bit position of `startTimestamp` in packed ownership.
1169     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1170 
1171     // The bit mask of the `burned` bit in packed ownership.
1172     uint256 private constant _BITMASK_BURNED = 1 << 224;
1173 
1174     // The bit position of the `nextInitialized` bit in packed ownership.
1175     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1176 
1177     // The bit mask of the `nextInitialized` bit in packed ownership.
1178     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1179 
1180     // The bit position of `extraData` in packed ownership.
1181     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1182 
1183     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1184     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1185 
1186     // The mask of the lower 160 bits for addresses.
1187     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1188 
1189     // The maximum `quantity` that can be minted with {_mintERC2309}.
1190     // This limit is to prevent overflows on the address data entries.
1191     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1192     // is required to cause an overflow, which is unrealistic.
1193     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1194 
1195     // The `Transfer` event signature is given by:
1196     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1197     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1198         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1199 
1200     // =============================================================
1201     //                            STORAGE
1202     // =============================================================
1203 
1204     // The next token ID to be minted.
1205     uint256 private _currentIndex;
1206 
1207     // The number of tokens burned.
1208     uint256 private _burnCounter;
1209 
1210     // Token name
1211     string private _name;
1212 
1213     // Token symbol
1214     string private _symbol;
1215 
1216     // Mapping from token ID to ownership details
1217     // An empty struct value does not necessarily mean the token is unowned.
1218     // See {_packedOwnershipOf} implementation for details.
1219     //
1220     // Bits Layout:
1221     // - [0..159]   `addr`
1222     // - [160..223] `startTimestamp`
1223     // - [224]      `burned`
1224     // - [225]      `nextInitialized`
1225     // - [232..255] `extraData`
1226     mapping(uint256 => uint256) private _packedOwnerships;
1227 
1228     // Mapping owner address to address data.
1229     //
1230     // Bits Layout:
1231     // - [0..63]    `balance`
1232     // - [64..127]  `numberMinted`
1233     // - [128..191] `numberBurned`
1234     // - [192..255] `aux`
1235     mapping(address => uint256) private _packedAddressData;
1236 
1237     // Mapping from token ID to approved address.
1238     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1239 
1240     // Mapping from owner to operator approvals
1241     mapping(address => mapping(address => bool)) private _operatorApprovals;
1242 
1243     // =============================================================
1244     //                          CONSTRUCTOR
1245     // =============================================================
1246 
1247     constructor(string memory name_, string memory symbol_) {
1248         _name = name_;
1249         _symbol = symbol_;
1250         _currentIndex = _startTokenId();
1251     }
1252 
1253     // =============================================================
1254     //                   TOKEN COUNTING OPERATIONS
1255     // =============================================================
1256 
1257     /**
1258      * @dev Returns the starting token ID.
1259      * To change the starting token ID, please override this function.
1260      */
1261     function _startTokenId() internal view virtual returns (uint256) {
1262         return 0;
1263     }
1264 
1265     /**
1266      * @dev Returns the next token ID to be minted.
1267      */
1268     function _nextTokenId() internal view virtual returns (uint256) {
1269         return _currentIndex;
1270     }
1271 
1272     /**
1273      * @dev Returns the total number of tokens in existence.
1274      * Burned tokens will reduce the count.
1275      * To get the total number of tokens minted, please see {_totalMinted}.
1276      */
1277     function totalSupply() public view virtual override returns (uint256) {
1278         // Counter underflow is impossible as _burnCounter cannot be incremented
1279         // more than `_currentIndex - _startTokenId()` times.
1280         unchecked {
1281             return _currentIndex - _burnCounter - _startTokenId();
1282         }
1283     }
1284 
1285     /**
1286      * @dev Returns the total amount of tokens minted in the contract.
1287      */
1288     function _totalMinted() internal view virtual returns (uint256) {
1289         // Counter underflow is impossible as `_currentIndex` does not decrement,
1290         // and it is initialized to `_startTokenId()`.
1291         unchecked {
1292             return _currentIndex - _startTokenId();
1293         }
1294     }
1295 
1296     /**
1297      * @dev Returns the total number of tokens burned.
1298      */
1299     function _totalBurned() internal view virtual returns (uint256) {
1300         return _burnCounter;
1301     }
1302 
1303     // =============================================================
1304     //                    ADDRESS DATA OPERATIONS
1305     // =============================================================
1306 
1307     /**
1308      * @dev Returns the number of tokens in `owner`'s account.
1309      */
1310     function balanceOf(address owner) public view virtual override returns (uint256) {
1311         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1312         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1313     }
1314 
1315     /**
1316      * Returns the number of tokens minted by `owner`.
1317      */
1318     function _numberMinted(address owner) internal view returns (uint256) {
1319         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1320     }
1321 
1322     /**
1323      * Returns the number of tokens burned by or on behalf of `owner`.
1324      */
1325     function _numberBurned(address owner) internal view returns (uint256) {
1326         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1327     }
1328 
1329     /**
1330      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1331      */
1332     function _getAux(address owner) internal view returns (uint64) {
1333         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1334     }
1335 
1336     /**
1337      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1338      * If there are multiple variables, please pack them into a uint64.
1339      */
1340     function _setAux(address owner, uint64 aux) internal virtual {
1341         uint256 packed = _packedAddressData[owner];
1342         uint256 auxCasted;
1343         // Cast `aux` with assembly to avoid redundant masking.
1344         assembly {
1345             auxCasted := aux
1346         }
1347         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1348         _packedAddressData[owner] = packed;
1349     }
1350 
1351     // =============================================================
1352     //                            IERC165
1353     // =============================================================
1354 
1355     /**
1356      * @dev Returns true if this contract implements the interface defined by
1357      * `interfaceId`. See the corresponding
1358      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1359      * to learn more about how these ids are created.
1360      *
1361      * This function call must use less than 30000 gas.
1362      */
1363     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1364         // The interface IDs are constants representing the first 4 bytes
1365         // of the XOR of all function selectors in the interface.
1366         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1367         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1368         return
1369             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1370             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1371             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1372     }
1373 
1374     // =============================================================
1375     //                        IERC721Metadata
1376     // =============================================================
1377 
1378     /**
1379      * @dev Returns the token collection name.
1380      */
1381     function name() public view virtual override returns (string memory) {
1382         return _name;
1383     }
1384 
1385     /**
1386      * @dev Returns the token collection symbol.
1387      */
1388     function symbol() public view virtual override returns (string memory) {
1389         return _symbol;
1390     }
1391 
1392     /**
1393      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1394      */
1395     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1396         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1397 
1398         string memory baseURI = _baseURI();
1399         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1400     }
1401 
1402     /**
1403      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1404      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1405      * by default, it can be overridden in child contracts.
1406      */
1407     function _baseURI() internal view virtual returns (string memory) {
1408         return '';
1409     }
1410 
1411     // =============================================================
1412     //                     OWNERSHIPS OPERATIONS
1413     // =============================================================
1414 
1415     /**
1416      * @dev Returns the owner of the `tokenId` token.
1417      *
1418      * Requirements:
1419      *
1420      * - `tokenId` must exist.
1421      */
1422     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1423         return address(uint160(_packedOwnershipOf(tokenId)));
1424     }
1425 
1426     /**
1427      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1428      * It gradually moves to O(1) as tokens get transferred around over time.
1429      */
1430     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1431         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1432     }
1433 
1434     /**
1435      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1436      */
1437     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1438         return _unpackedOwnership(_packedOwnerships[index]);
1439     }
1440 
1441     /**
1442      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1443      */
1444     function _initializeOwnershipAt(uint256 index) internal virtual {
1445         if (_packedOwnerships[index] == 0) {
1446             _packedOwnerships[index] = _packedOwnershipOf(index);
1447         }
1448     }
1449 
1450     /**
1451      * Returns the packed ownership data of `tokenId`.
1452      */
1453     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1454         uint256 curr = tokenId;
1455 
1456         unchecked {
1457             if (_startTokenId() <= curr)
1458                 if (curr < _currentIndex) {
1459                     uint256 packed = _packedOwnerships[curr];
1460                     // If not burned.
1461                     if (packed & _BITMASK_BURNED == 0) {
1462                         // Invariant:
1463                         // There will always be an initialized ownership slot
1464                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1465                         // before an unintialized ownership slot
1466                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1467                         // Hence, `curr` will not underflow.
1468                         //
1469                         // We can directly compare the packed value.
1470                         // If the address is zero, packed will be zero.
1471                         while (packed == 0) {
1472                             packed = _packedOwnerships[--curr];
1473                         }
1474                         return packed;
1475                     }
1476                 }
1477         }
1478         revert OwnerQueryForNonexistentToken();
1479     }
1480 
1481     /**
1482      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1483      */
1484     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1485         ownership.addr = address(uint160(packed));
1486         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1487         ownership.burned = packed & _BITMASK_BURNED != 0;
1488         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1489     }
1490 
1491     /**
1492      * @dev Packs ownership data into a single uint256.
1493      */
1494     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1495         assembly {
1496             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1497             owner := and(owner, _BITMASK_ADDRESS)
1498             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1499             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1500         }
1501     }
1502 
1503     /**
1504      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1505      */
1506     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1507         // For branchless setting of the `nextInitialized` flag.
1508         assembly {
1509             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1510             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1511         }
1512     }
1513 
1514     // =============================================================
1515     //                      APPROVAL OPERATIONS
1516     // =============================================================
1517 
1518     /**
1519      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1520      * The approval is cleared when the token is transferred.
1521      *
1522      * Only a single account can be approved at a time, so approving the
1523      * zero address clears previous approvals.
1524      *
1525      * Requirements:
1526      *
1527      * - The caller must own the token or be an approved operator.
1528      * - `tokenId` must exist.
1529      *
1530      * Emits an {Approval} event.
1531      */
1532     function approve(address to, uint256 tokenId) public payable virtual override {
1533         address owner = ownerOf(tokenId);
1534 
1535         if (_msgSenderERC721A() != owner)
1536             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1537                 revert ApprovalCallerNotOwnerNorApproved();
1538             }
1539 
1540         _tokenApprovals[tokenId].value = to;
1541         emit Approval(owner, to, tokenId);
1542     }
1543 
1544     /**
1545      * @dev Returns the account approved for `tokenId` token.
1546      *
1547      * Requirements:
1548      *
1549      * - `tokenId` must exist.
1550      */
1551     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1552         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1553 
1554         return _tokenApprovals[tokenId].value;
1555     }
1556 
1557     /**
1558      * @dev Approve or remove `operator` as an operator for the caller.
1559      * Operators can call {transferFrom} or {safeTransferFrom}
1560      * for any token owned by the caller.
1561      *
1562      * Requirements:
1563      *
1564      * - The `operator` cannot be the caller.
1565      *
1566      * Emits an {ApprovalForAll} event.
1567      */
1568     function setApprovalForAll(address operator, bool approved) public virtual override {
1569         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1570         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1571     }
1572 
1573     /**
1574      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1575      *
1576      * See {setApprovalForAll}.
1577      */
1578     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1579         return _operatorApprovals[owner][operator];
1580     }
1581 
1582     /**
1583      * @dev Returns whether `tokenId` exists.
1584      *
1585      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1586      *
1587      * Tokens start existing when they are minted. See {_mint}.
1588      */
1589     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1590         return
1591             _startTokenId() <= tokenId &&
1592             tokenId < _currentIndex && // If within bounds,
1593             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1594     }
1595 
1596     /**
1597      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1598      */
1599     function _isSenderApprovedOrOwner(
1600         address approvedAddress,
1601         address owner,
1602         address msgSender
1603     ) private pure returns (bool result) {
1604         assembly {
1605             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1606             owner := and(owner, _BITMASK_ADDRESS)
1607             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1608             msgSender := and(msgSender, _BITMASK_ADDRESS)
1609             // `msgSender == owner || msgSender == approvedAddress`.
1610             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1611         }
1612     }
1613 
1614     /**
1615      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1616      */
1617     function _getApprovedSlotAndAddress(uint256 tokenId)
1618         private
1619         view
1620         returns (uint256 approvedAddressSlot, address approvedAddress)
1621     {
1622         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1623         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1624         assembly {
1625             approvedAddressSlot := tokenApproval.slot
1626             approvedAddress := sload(approvedAddressSlot)
1627         }
1628     }
1629 
1630     // =============================================================
1631     //                      TRANSFER OPERATIONS
1632     // =============================================================
1633 
1634     /**
1635      * @dev Transfers `tokenId` from `from` to `to`.
1636      *
1637      * Requirements:
1638      *
1639      * - `from` cannot be the zero address.
1640      * - `to` cannot be the zero address.
1641      * - `tokenId` token must be owned by `from`.
1642      * - If the caller is not `from`, it must be approved to move this token
1643      * by either {approve} or {setApprovalForAll}.
1644      *
1645      * Emits a {Transfer} event.
1646      */
1647     function transferFrom(
1648         address from,
1649         address to,
1650         uint256 tokenId
1651     ) public payable virtual override {
1652         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1653 
1654         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1655 
1656         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1657 
1658         // The nested ifs save around 20+ gas over a compound boolean condition.
1659         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1660             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1661 
1662         if (to == address(0)) revert TransferToZeroAddress();
1663 
1664         _beforeTokenTransfers(from, to, tokenId, 1);
1665 
1666         // Clear approvals from the previous owner.
1667         assembly {
1668             if approvedAddress {
1669                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1670                 sstore(approvedAddressSlot, 0)
1671             }
1672         }
1673 
1674         // Underflow of the sender's balance is impossible because we check for
1675         // ownership above and the recipient's balance can't realistically overflow.
1676         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1677         unchecked {
1678             // We can directly increment and decrement the balances.
1679             --_packedAddressData[from]; // Updates: `balance -= 1`.
1680             ++_packedAddressData[to]; // Updates: `balance += 1`.
1681 
1682             // Updates:
1683             // - `address` to the next owner.
1684             // - `startTimestamp` to the timestamp of transfering.
1685             // - `burned` to `false`.
1686             // - `nextInitialized` to `true`.
1687             _packedOwnerships[tokenId] = _packOwnershipData(
1688                 to,
1689                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1690             );
1691 
1692             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1693             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1694                 uint256 nextTokenId = tokenId + 1;
1695                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1696                 if (_packedOwnerships[nextTokenId] == 0) {
1697                     // If the next slot is within bounds.
1698                     if (nextTokenId != _currentIndex) {
1699                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1700                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1701                     }
1702                 }
1703             }
1704         }
1705 
1706         emit Transfer(from, to, tokenId);
1707         _afterTokenTransfers(from, to, tokenId, 1);
1708     }
1709 
1710     /**
1711      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1712      */
1713     function safeTransferFrom(
1714         address from,
1715         address to,
1716         uint256 tokenId
1717     ) public payable virtual override {
1718         safeTransferFrom(from, to, tokenId, '');
1719     }
1720 
1721     /**
1722      * @dev Safely transfers `tokenId` token from `from` to `to`.
1723      *
1724      * Requirements:
1725      *
1726      * - `from` cannot be the zero address.
1727      * - `to` cannot be the zero address.
1728      * - `tokenId` token must exist and be owned by `from`.
1729      * - If the caller is not `from`, it must be approved to move this token
1730      * by either {approve} or {setApprovalForAll}.
1731      * - If `to` refers to a smart contract, it must implement
1732      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1733      *
1734      * Emits a {Transfer} event.
1735      */
1736     function safeTransferFrom(
1737         address from,
1738         address to,
1739         uint256 tokenId,
1740         bytes memory _data
1741     ) public payable virtual override {
1742         transferFrom(from, to, tokenId);
1743         if (to.code.length != 0)
1744             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1745                 revert TransferToNonERC721ReceiverImplementer();
1746             }
1747     }
1748 
1749     /**
1750      * @dev Hook that is called before a set of serially-ordered token IDs
1751      * are about to be transferred. This includes minting.
1752      * And also called before burning one token.
1753      *
1754      * `startTokenId` - the first token ID to be transferred.
1755      * `quantity` - the amount to be transferred.
1756      *
1757      * Calling conditions:
1758      *
1759      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1760      * transferred to `to`.
1761      * - When `from` is zero, `tokenId` will be minted for `to`.
1762      * - When `to` is zero, `tokenId` will be burned by `from`.
1763      * - `from` and `to` are never both zero.
1764      */
1765     function _beforeTokenTransfers(
1766         address from,
1767         address to,
1768         uint256 startTokenId,
1769         uint256 quantity
1770     ) internal virtual {}
1771 
1772     /**
1773      * @dev Hook that is called after a set of serially-ordered token IDs
1774      * have been transferred. This includes minting.
1775      * And also called after one token has been burned.
1776      *
1777      * `startTokenId` - the first token ID to be transferred.
1778      * `quantity` - the amount to be transferred.
1779      *
1780      * Calling conditions:
1781      *
1782      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1783      * transferred to `to`.
1784      * - When `from` is zero, `tokenId` has been minted for `to`.
1785      * - When `to` is zero, `tokenId` has been burned by `from`.
1786      * - `from` and `to` are never both zero.
1787      */
1788     function _afterTokenTransfers(
1789         address from,
1790         address to,
1791         uint256 startTokenId,
1792         uint256 quantity
1793     ) internal virtual {}
1794 
1795     /**
1796      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1797      *
1798      * `from` - Previous owner of the given token ID.
1799      * `to` - Target address that will receive the token.
1800      * `tokenId` - Token ID to be transferred.
1801      * `_data` - Optional data to send along with the call.
1802      *
1803      * Returns whether the call correctly returned the expected magic value.
1804      */
1805     function _checkContractOnERC721Received(
1806         address from,
1807         address to,
1808         uint256 tokenId,
1809         bytes memory _data
1810     ) private returns (bool) {
1811         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1812             bytes4 retval
1813         ) {
1814             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1815         } catch (bytes memory reason) {
1816             if (reason.length == 0) {
1817                 revert TransferToNonERC721ReceiverImplementer();
1818             } else {
1819                 assembly {
1820                     revert(add(32, reason), mload(reason))
1821                 }
1822             }
1823         }
1824     }
1825 
1826     // =============================================================
1827     //                        MINT OPERATIONS
1828     // =============================================================
1829 
1830     /**
1831      * @dev Mints `quantity` tokens and transfers them to `to`.
1832      *
1833      * Requirements:
1834      *
1835      * - `to` cannot be the zero address.
1836      * - `quantity` must be greater than 0.
1837      *
1838      * Emits a {Transfer} event for each mint.
1839      */
1840     function _mint(address to, uint256 quantity) internal virtual {
1841         uint256 startTokenId = _currentIndex;
1842         if (quantity == 0) revert MintZeroQuantity();
1843 
1844         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1845 
1846         // Overflows are incredibly unrealistic.
1847         // `balance` and `numberMinted` have a maximum limit of 2**64.
1848         // `tokenId` has a maximum limit of 2**256.
1849         unchecked {
1850             // Updates:
1851             // - `balance += quantity`.
1852             // - `numberMinted += quantity`.
1853             //
1854             // We can directly add to the `balance` and `numberMinted`.
1855             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1856 
1857             // Updates:
1858             // - `address` to the owner.
1859             // - `startTimestamp` to the timestamp of minting.
1860             // - `burned` to `false`.
1861             // - `nextInitialized` to `quantity == 1`.
1862             _packedOwnerships[startTokenId] = _packOwnershipData(
1863                 to,
1864                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1865             );
1866 
1867             uint256 toMasked;
1868             uint256 end = startTokenId + quantity;
1869 
1870             // Use assembly to loop and emit the `Transfer` event for gas savings.
1871             // The duplicated `log4` removes an extra check and reduces stack juggling.
1872             // The assembly, together with the surrounding Solidity code, have been
1873             // delicately arranged to nudge the compiler into producing optimized opcodes.
1874             assembly {
1875                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1876                 toMasked := and(to, _BITMASK_ADDRESS)
1877                 // Emit the `Transfer` event.
1878                 log4(
1879                     0, // Start of data (0, since no data).
1880                     0, // End of data (0, since no data).
1881                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1882                     0, // `address(0)`.
1883                     toMasked, // `to`.
1884                     startTokenId // `tokenId`.
1885                 )
1886 
1887                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1888                 // that overflows uint256 will make the loop run out of gas.
1889                 // The compiler will optimize the `iszero` away for performance.
1890                 for {
1891                     let tokenId := add(startTokenId, 1)
1892                 } iszero(eq(tokenId, end)) {
1893                     tokenId := add(tokenId, 1)
1894                 } {
1895                     // Emit the `Transfer` event. Similar to above.
1896                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1897                 }
1898             }
1899             if (toMasked == 0) revert MintToZeroAddress();
1900 
1901             _currentIndex = end;
1902         }
1903         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1904     }
1905 
1906     /**
1907      * @dev Mints `quantity` tokens and transfers them to `to`.
1908      *
1909      * This function is intended for efficient minting only during contract creation.
1910      *
1911      * It emits only one {ConsecutiveTransfer} as defined in
1912      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1913      * instead of a sequence of {Transfer} event(s).
1914      *
1915      * Calling this function outside of contract creation WILL make your contract
1916      * non-compliant with the ERC721 standard.
1917      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1918      * {ConsecutiveTransfer} event is only permissible during contract creation.
1919      *
1920      * Requirements:
1921      *
1922      * - `to` cannot be the zero address.
1923      * - `quantity` must be greater than 0.
1924      *
1925      * Emits a {ConsecutiveTransfer} event.
1926      */
1927     function _mintERC2309(address to, uint256 quantity) internal virtual {
1928         uint256 startTokenId = _currentIndex;
1929         if (to == address(0)) revert MintToZeroAddress();
1930         if (quantity == 0) revert MintZeroQuantity();
1931         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1932 
1933         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1934 
1935         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1936         unchecked {
1937             // Updates:
1938             // - `balance += quantity`.
1939             // - `numberMinted += quantity`.
1940             //
1941             // We can directly add to the `balance` and `numberMinted`.
1942             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1943 
1944             // Updates:
1945             // - `address` to the owner.
1946             // - `startTimestamp` to the timestamp of minting.
1947             // - `burned` to `false`.
1948             // - `nextInitialized` to `quantity == 1`.
1949             _packedOwnerships[startTokenId] = _packOwnershipData(
1950                 to,
1951                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1952             );
1953 
1954             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1955 
1956             _currentIndex = startTokenId + quantity;
1957         }
1958         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1959     }
1960 
1961     /**
1962      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1963      *
1964      * Requirements:
1965      *
1966      * - If `to` refers to a smart contract, it must implement
1967      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1968      * - `quantity` must be greater than 0.
1969      *
1970      * See {_mint}.
1971      *
1972      * Emits a {Transfer} event for each mint.
1973      */
1974     function _safeMint(
1975         address to,
1976         uint256 quantity,
1977         bytes memory _data
1978     ) internal virtual {
1979         _mint(to, quantity);
1980 
1981         unchecked {
1982             if (to.code.length != 0) {
1983                 uint256 end = _currentIndex;
1984                 uint256 index = end - quantity;
1985                 do {
1986                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1987                         revert TransferToNonERC721ReceiverImplementer();
1988                     }
1989                 } while (index < end);
1990                 // Reentrancy protection.
1991                 if (_currentIndex != end) revert();
1992             }
1993         }
1994     }
1995 
1996     /**
1997      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1998      */
1999     function _safeMint(address to, uint256 quantity) internal virtual {
2000         _safeMint(to, quantity, '');
2001     }
2002 
2003     // =============================================================
2004     //                        BURN OPERATIONS
2005     // =============================================================
2006 
2007     /**
2008      * @dev Equivalent to `_burn(tokenId, false)`.
2009      */
2010     function _burn(uint256 tokenId) internal virtual {
2011         _burn(tokenId, false);
2012     }
2013 
2014     /**
2015      * @dev Destroys `tokenId`.
2016      * The approval is cleared when the token is burned.
2017      *
2018      * Requirements:
2019      *
2020      * - `tokenId` must exist.
2021      *
2022      * Emits a {Transfer} event.
2023      */
2024     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2025         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2026 
2027         address from = address(uint160(prevOwnershipPacked));
2028 
2029         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2030 
2031         if (approvalCheck) {
2032             // The nested ifs save around 20+ gas over a compound boolean condition.
2033             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2034                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2035         }
2036 
2037         _beforeTokenTransfers(from, address(0), tokenId, 1);
2038 
2039         // Clear approvals from the previous owner.
2040         assembly {
2041             if approvedAddress {
2042                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2043                 sstore(approvedAddressSlot, 0)
2044             }
2045         }
2046 
2047         // Underflow of the sender's balance is impossible because we check for
2048         // ownership above and the recipient's balance can't realistically overflow.
2049         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2050         unchecked {
2051             // Updates:
2052             // - `balance -= 1`.
2053             // - `numberBurned += 1`.
2054             //
2055             // We can directly decrement the balance, and increment the number burned.
2056             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2057             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2058 
2059             // Updates:
2060             // - `address` to the last owner.
2061             // - `startTimestamp` to the timestamp of burning.
2062             // - `burned` to `true`.
2063             // - `nextInitialized` to `true`.
2064             _packedOwnerships[tokenId] = _packOwnershipData(
2065                 from,
2066                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2067             );
2068 
2069             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2070             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2071                 uint256 nextTokenId = tokenId + 1;
2072                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2073                 if (_packedOwnerships[nextTokenId] == 0) {
2074                     // If the next slot is within bounds.
2075                     if (nextTokenId != _currentIndex) {
2076                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2077                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2078                     }
2079                 }
2080             }
2081         }
2082 
2083         emit Transfer(from, address(0), tokenId);
2084         _afterTokenTransfers(from, address(0), tokenId, 1);
2085 
2086         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2087         unchecked {
2088             _burnCounter++;
2089         }
2090     }
2091 
2092     // =============================================================
2093     //                     EXTRA DATA OPERATIONS
2094     // =============================================================
2095 
2096     /**
2097      * @dev Directly sets the extra data for the ownership data `index`.
2098      */
2099     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2100         uint256 packed = _packedOwnerships[index];
2101         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2102         uint256 extraDataCasted;
2103         // Cast `extraData` with assembly to avoid redundant masking.
2104         assembly {
2105             extraDataCasted := extraData
2106         }
2107         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2108         _packedOwnerships[index] = packed;
2109     }
2110 
2111     /**
2112      * @dev Called during each token transfer to set the 24bit `extraData` field.
2113      * Intended to be overridden by the cosumer contract.
2114      *
2115      * `previousExtraData` - the value of `extraData` before transfer.
2116      *
2117      * Calling conditions:
2118      *
2119      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2120      * transferred to `to`.
2121      * - When `from` is zero, `tokenId` will be minted for `to`.
2122      * - When `to` is zero, `tokenId` will be burned by `from`.
2123      * - `from` and `to` are never both zero.
2124      */
2125     function _extraData(
2126         address from,
2127         address to,
2128         uint24 previousExtraData
2129     ) internal view virtual returns (uint24) {}
2130 
2131     /**
2132      * @dev Returns the next extra data for the packed ownership data.
2133      * The returned result is shifted into position.
2134      */
2135     function _nextExtraData(
2136         address from,
2137         address to,
2138         uint256 prevOwnershipPacked
2139     ) private view returns (uint256) {
2140         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2141         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2142     }
2143 
2144     // =============================================================
2145     //                       OTHER OPERATIONS
2146     // =============================================================
2147 
2148     /**
2149      * @dev Returns the message sender (defaults to `msg.sender`).
2150      *
2151      * If you are writing GSN compatible contracts, you need to override this function.
2152      */
2153     function _msgSenderERC721A() internal view virtual returns (address) {
2154         return msg.sender;
2155     }
2156 
2157     /**
2158      * @dev Converts a uint256 to its ASCII string decimal representation.
2159      */
2160     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2161         assembly {
2162             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2163             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2164             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2165             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2166             let m := add(mload(0x40), 0xa0)
2167             // Update the free memory pointer to allocate.
2168             mstore(0x40, m)
2169             // Assign the `str` to the end.
2170             str := sub(m, 0x20)
2171             // Zeroize the slot after the string.
2172             mstore(str, 0)
2173 
2174             // Cache the end of the memory to calculate the length later.
2175             let end := str
2176 
2177             // We write the string from rightmost digit to leftmost digit.
2178             // The following is essentially a do-while loop that also handles the zero case.
2179             // prettier-ignore
2180             for { let temp := value } 1 {} {
2181                 str := sub(str, 1)
2182                 // Write the character to the pointer.
2183                 // The ASCII index of the '0' character is 48.
2184                 mstore8(str, add(48, mod(temp, 10)))
2185                 // Keep dividing `temp` until zero.
2186                 temp := div(temp, 10)
2187                 // prettier-ignore
2188                 if iszero(temp) { break }
2189             }
2190 
2191             let length := sub(end, str)
2192             // Move the pointer 32 bytes leftwards to make room for the length.
2193             str := sub(str, 0x20)
2194             // Store the length.
2195             mstore(str, length)
2196         }
2197     }
2198 }
2199 
2200 // File: contracts/WOAHS.sol
2201 
2202 
2203     contract WOAHS is Ownable, ERC721A, ReentrancyGuard {
2204         string public notRevealedUri;   
2205         string public baseExtension = ".json";
2206         
2207         uint256 public MAX_SUPPLY = 5000;
2208         uint256 public PRICE = 0.04 ether;
2209         uint256 public PRESALE_PRICE = 0.03 ether;
2210         uint256 public _reserveCounter;
2211         uint256 public _airdropCounter;
2212         uint256 public _preSaleListCounter;
2213         uint256 public _publicCounter;
2214         uint256 public maxPresaleMintAmount = 3;
2215         uint256 public maxpublicsaleMintAmount = 100;
2216         uint256 public saleMode = 0; // 1- presale 2- public sale
2217         
2218         bool public _revealed = false;
2219 
2220         mapping(address => bool) public allowList;
2221         mapping(address => uint256) public _preSaleMintCounter;
2222         mapping(address => uint256) public _publicsaleMintCounter;
2223 
2224         // merkle root
2225         bytes32 public preSaleRoot;
2226 
2227         constructor(
2228             string memory name,
2229             string memory symbol,
2230             string memory _notRevealedUri
2231         )
2232             ERC721A(name, symbol)
2233         {
2234             setNotRevealedURI(_notRevealedUri);
2235         }
2236 
2237         function tokenURI(uint256 tokenId)
2238         public
2239         view
2240         virtual
2241         override
2242         returns (string memory)
2243         {
2244             require(
2245                 _exists(tokenId),
2246                 "ERC721AMetadata: URI query for nonexistent token"
2247             );
2248 
2249             if(_revealed == false) {
2250                 return notRevealedUri;
2251             }
2252 
2253             string memory currentBaseURI = _baseURI();
2254             return bytes(currentBaseURI).length > 0
2255             ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
2256             : "";
2257         }
2258 
2259         function setMode(uint256 mode) public onlyOwner{
2260             saleMode = mode;
2261         }
2262 
2263         function getSaleMode() public view returns (uint256){
2264             return saleMode;
2265         }
2266 
2267         function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2268             MAX_SUPPLY = _maxSupply;
2269         }
2270 
2271         function setMaxPresaleMintAmount(uint256 _newQty) public onlyOwner {
2272             maxPresaleMintAmount = _newQty;
2273         }
2274 
2275         function setPublicsaleMintAmount(uint256 _newQty) public onlyOwner {
2276             maxpublicsaleMintAmount = _newQty;
2277         }
2278 
2279         function setCost(uint256 _newCost) public onlyOwner {
2280             PRICE = _newCost;
2281         }
2282 
2283         function setPresaleMintPrice(uint256 _newCost) public onlyOwner {
2284             PRESALE_PRICE = _newCost;
2285         }
2286 
2287         function setPreSaleRoot(bytes32 _merkleRoot) public onlyOwner {
2288             preSaleRoot = _merkleRoot;
2289         }
2290 
2291         function reserveMint(uint256 quantity) public onlyOwner {
2292             require(
2293                 totalSupply() + quantity <= MAX_SUPPLY,
2294                 "would exceed max supply"
2295             );
2296             _safeMint(msg.sender, quantity);
2297             _reserveCounter = _reserveCounter + quantity;
2298         }
2299 
2300         function airDrop(address[] calldata _to, uint256 quantity) public onlyOwner{
2301             require(
2302                 totalSupply() + quantity <= MAX_SUPPLY,
2303                 "would exceed max supply"
2304             );
2305             require(quantity > 0, "need to mint at least 1 NFT");
2306             for (uint256 i = 0; i < _to.length; i++) {
2307                 _safeMint(_to[i], quantity);
2308                 _airdropCounter = _airdropCounter + quantity;
2309             }
2310         }
2311 
2312         // metadata URI
2313         string private _baseTokenURI;
2314 
2315         function setBaseURI(string calldata baseURI) public onlyOwner {
2316             _baseTokenURI = baseURI;
2317         }
2318 
2319         function _baseURI() internal view virtual override returns (string memory) {
2320             return _baseTokenURI;
2321         }
2322 
2323         function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2324             notRevealedUri = _notRevealedURI;
2325         }
2326 
2327         function reveal(bool _state) public onlyOwner {
2328             _revealed = _state;
2329         }
2330 
2331         function mintPreSaleTokens(uint8 quantity, bytes32[] calldata _merkleProof)
2332             public
2333             payable
2334         {
2335             require(saleMode == 1, "Pre sale is not active");
2336             require(quantity > 0, "Must mint more than 0 tokens");
2337             require(
2338                 _preSaleMintCounter[msg.sender] + quantity <= maxPresaleMintAmount,
2339                 "exceeds max per address"
2340             );
2341             require(
2342                 totalSupply() + quantity <= MAX_SUPPLY,
2343                 "Purchase would exceed max supply of Tokens"
2344             );
2345             require(PRESALE_PRICE * quantity == msg.value, "Incorrect funds");
2346 
2347             // check proof & mint
2348             bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2349             require(
2350                 MerkleProof.verify(_merkleProof, preSaleRoot, leaf) ||
2351                     allowList[msg.sender],
2352                 "Invalid signature/ Address not whitelisted"
2353             );
2354             _safeMint(msg.sender, quantity);
2355             _preSaleListCounter = _preSaleListCounter + quantity;
2356             _preSaleMintCounter[msg.sender] = _preSaleMintCounter[msg.sender] + quantity;
2357         }
2358 
2359         function addToPreSaleOverflow(address[] calldata addresses)
2360             external
2361             onlyOwner
2362         {
2363             for (uint256 i = 0; i < addresses.length; i++) {
2364                 allowList[addresses[i]] = true;
2365             }
2366         }
2367 
2368         // public mint
2369         function publicSaleMint(uint256 quantity)
2370             public
2371             payable
2372         {
2373             require(totalSupply() + quantity <= MAX_SUPPLY, "reached max supply");
2374             require(saleMode == 2, "public sale has not begun yet");
2375             require(quantity > 0, "Must mint more than 0 tokens");
2376             require(PRICE * quantity == msg.value, "Incorrect funds");
2377             require(
2378                 _publicsaleMintCounter[msg.sender] + quantity <= maxpublicsaleMintAmount,
2379                 "exceeds max per address"
2380             );
2381 
2382             _safeMint(msg.sender, quantity);
2383             _publicCounter = _publicCounter + quantity;
2384         }
2385 
2386         function getBalance() public view returns (uint256) {
2387             return address(this).balance;
2388         }
2389 
2390         function _startTokenId() internal virtual override view returns (uint256) {
2391             return 1;
2392         }
2393 
2394         function withdraw() public payable onlyOwner nonReentrant{
2395             uint256 balance = address(this).balance;
2396             require(balance > 0, "No ether left to withdraw");
2397             payable(msg.sender).transfer(balance);
2398         }
2399 
2400     }