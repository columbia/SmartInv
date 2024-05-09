1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 
24 
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         _checkOwner();
57         _;
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if the sender is not the owner.
69      */
70     function _checkOwner() internal view virtual {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 
106 
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev Standard math utilities missing in the Solidity language.
112  */
113 library Math {
114     enum Rounding {
115         Down, // Toward negative infinity
116         Up, // Toward infinity
117         Zero // Toward zero
118     }
119 
120     /**
121      * @dev Returns the largest of two numbers.
122      */
123     function max(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a > b ? a : b;
125     }
126 
127     /**
128      * @dev Returns the smallest of two numbers.
129      */
130     function min(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a < b ? a : b;
132     }
133 
134     /**
135      * @dev Returns the average of two numbers. The result is rounded towards
136      * zero.
137      */
138     function average(uint256 a, uint256 b) internal pure returns (uint256) {
139         // (a + b) / 2 can overflow.
140         return (a & b) + (a ^ b) / 2;
141     }
142 
143     /**
144      * @dev Returns the ceiling of the division of two numbers.
145      *
146      * This differs from standard division with `/` in that it rounds up instead
147      * of rounding down.
148      */
149     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
150         // (a + b - 1) / b can overflow on addition, so we distribute.
151         return a == 0 ? 0 : (a - 1) / b + 1;
152     }
153 
154     /**
155      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
156      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
157      * with further edits by Uniswap Labs also under MIT license.
158      */
159     function mulDiv(
160         uint256 x,
161         uint256 y,
162         uint256 denominator
163     ) internal pure returns (uint256 result) {
164         unchecked {
165             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
166             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
167             // variables such that product = prod1 * 2^256 + prod0.
168             uint256 prod0; // Least significant 256 bits of the product
169             uint256 prod1; // Most significant 256 bits of the product
170             assembly {
171                 let mm := mulmod(x, y, not(0))
172                 prod0 := mul(x, y)
173                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
174             }
175 
176             // Handle non-overflow cases, 256 by 256 division.
177             if (prod1 == 0) {
178                 return prod0 / denominator;
179             }
180 
181             // Make sure the result is less than 2^256. Also prevents denominator == 0.
182             require(denominator > prod1);
183 
184             ///////////////////////////////////////////////
185             // 512 by 256 division.
186             ///////////////////////////////////////////////
187 
188             // Make division exact by subtracting the remainder from [prod1 prod0].
189             uint256 remainder;
190             assembly {
191                 // Compute remainder using mulmod.
192                 remainder := mulmod(x, y, denominator)
193 
194                 // Subtract 256 bit number from 512 bit number.
195                 prod1 := sub(prod1, gt(remainder, prod0))
196                 prod0 := sub(prod0, remainder)
197             }
198 
199             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
200             // See https://cs.stackexchange.com/q/138556/92363.
201 
202             // Does not overflow because the denominator cannot be zero at this stage in the function.
203             uint256 twos = denominator & (~denominator + 1);
204             assembly {
205                 // Divide denominator by twos.
206                 denominator := div(denominator, twos)
207 
208                 // Divide [prod1 prod0] by twos.
209                 prod0 := div(prod0, twos)
210 
211                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
212                 twos := add(div(sub(0, twos), twos), 1)
213             }
214 
215             // Shift in bits from prod1 into prod0.
216             prod0 |= prod1 * twos;
217 
218             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
219             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
220             // four bits. That is, denominator * inv = 1 mod 2^4.
221             uint256 inverse = (3 * denominator) ^ 2;
222 
223             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
224             // in modular arithmetic, doubling the correct bits in each step.
225             inverse *= 2 - denominator * inverse; // inverse mod 2^8
226             inverse *= 2 - denominator * inverse; // inverse mod 2^16
227             inverse *= 2 - denominator * inverse; // inverse mod 2^32
228             inverse *= 2 - denominator * inverse; // inverse mod 2^64
229             inverse *= 2 - denominator * inverse; // inverse mod 2^128
230             inverse *= 2 - denominator * inverse; // inverse mod 2^256
231 
232             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
233             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
234             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
235             // is no longer required.
236             result = prod0 * inverse;
237             return result;
238         }
239     }
240 
241     /**
242      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
243      */
244     function mulDiv(
245         uint256 x,
246         uint256 y,
247         uint256 denominator,
248         Rounding rounding
249     ) internal pure returns (uint256) {
250         uint256 result = mulDiv(x, y, denominator);
251         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
252             result += 1;
253         }
254         return result;
255     }
256 
257     /**
258      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
259      *
260      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
261      */
262     function sqrt(uint256 a) internal pure returns (uint256) {
263         if (a == 0) {
264             return 0;
265         }
266 
267         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
268         //
269         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
270         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
271         //
272         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
273         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
274         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
275         //
276         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
277         uint256 result = 1 << (log2(a) >> 1);
278 
279         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
280         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
281         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
282         // into the expected uint128 result.
283         unchecked {
284             result = (result + a / result) >> 1;
285             result = (result + a / result) >> 1;
286             result = (result + a / result) >> 1;
287             result = (result + a / result) >> 1;
288             result = (result + a / result) >> 1;
289             result = (result + a / result) >> 1;
290             result = (result + a / result) >> 1;
291             return min(result, a / result);
292         }
293     }
294 
295     /**
296      * @notice Calculates sqrt(a), following the selected rounding direction.
297      */
298     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
299         unchecked {
300             uint256 result = sqrt(a);
301             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
302         }
303     }
304 
305     /**
306      * @dev Return the log in base 2, rounded down, of a positive value.
307      * Returns 0 if given 0.
308      */
309     function log2(uint256 value) internal pure returns (uint256) {
310         uint256 result = 0;
311         unchecked {
312             if (value >> 128 > 0) {
313                 value >>= 128;
314                 result += 128;
315             }
316             if (value >> 64 > 0) {
317                 value >>= 64;
318                 result += 64;
319             }
320             if (value >> 32 > 0) {
321                 value >>= 32;
322                 result += 32;
323             }
324             if (value >> 16 > 0) {
325                 value >>= 16;
326                 result += 16;
327             }
328             if (value >> 8 > 0) {
329                 value >>= 8;
330                 result += 8;
331             }
332             if (value >> 4 > 0) {
333                 value >>= 4;
334                 result += 4;
335             }
336             if (value >> 2 > 0) {
337                 value >>= 2;
338                 result += 2;
339             }
340             if (value >> 1 > 0) {
341                 result += 1;
342             }
343         }
344         return result;
345     }
346 
347     /**
348      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
349      * Returns 0 if given 0.
350      */
351     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
352         unchecked {
353             uint256 result = log2(value);
354             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
355         }
356     }
357 
358     /**
359      * @dev Return the log in base 10, rounded down, of a positive value.
360      * Returns 0 if given 0.
361      */
362     function log10(uint256 value) internal pure returns (uint256) {
363         uint256 result = 0;
364         unchecked {
365             if (value >= 10**64) {
366                 value /= 10**64;
367                 result += 64;
368             }
369             if (value >= 10**32) {
370                 value /= 10**32;
371                 result += 32;
372             }
373             if (value >= 10**16) {
374                 value /= 10**16;
375                 result += 16;
376             }
377             if (value >= 10**8) {
378                 value /= 10**8;
379                 result += 8;
380             }
381             if (value >= 10**4) {
382                 value /= 10**4;
383                 result += 4;
384             }
385             if (value >= 10**2) {
386                 value /= 10**2;
387                 result += 2;
388             }
389             if (value >= 10**1) {
390                 result += 1;
391             }
392         }
393         return result;
394     }
395 
396     /**
397      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
398      * Returns 0 if given 0.
399      */
400     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
401         unchecked {
402             uint256 result = log10(value);
403             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
404         }
405     }
406 
407     /**
408      * @dev Return the log in base 256, rounded down, of a positive value.
409      * Returns 0 if given 0.
410      *
411      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
412      */
413     function log256(uint256 value) internal pure returns (uint256) {
414         uint256 result = 0;
415         unchecked {
416             if (value >> 128 > 0) {
417                 value >>= 128;
418                 result += 16;
419             }
420             if (value >> 64 > 0) {
421                 value >>= 64;
422                 result += 8;
423             }
424             if (value >> 32 > 0) {
425                 value >>= 32;
426                 result += 4;
427             }
428             if (value >> 16 > 0) {
429                 value >>= 16;
430                 result += 2;
431             }
432             if (value >> 8 > 0) {
433                 result += 1;
434             }
435         }
436         return result;
437     }
438 
439     /**
440      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
441      * Returns 0 if given 0.
442      */
443     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
444         unchecked {
445             uint256 result = log256(value);
446             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
447         }
448     }
449 }
450 
451 
452 
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev String operations.
458  */
459 library Strings {
460     bytes16 private constant _SYMBOLS = "0123456789abcdef";
461     uint8 private constant _ADDRESS_LENGTH = 20;
462 
463     /**
464      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
465      */
466     function toString(uint256 value) internal pure returns (string memory) {
467         unchecked {
468             uint256 length = Math.log10(value) + 1;
469             string memory buffer = new string(length);
470             uint256 ptr;
471             /// @solidity memory-safe-assembly
472             assembly {
473                 ptr := add(buffer, add(32, length))
474             }
475             while (true) {
476                 ptr--;
477                 /// @solidity memory-safe-assembly
478                 assembly {
479                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
480                 }
481                 value /= 10;
482                 if (value == 0) break;
483             }
484             return buffer;
485         }
486     }
487 
488     /**
489      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
490      */
491     function toHexString(uint256 value) internal pure returns (string memory) {
492         unchecked {
493             return toHexString(value, Math.log256(value) + 1);
494         }
495     }
496 
497     /**
498      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
499      */
500     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
501         bytes memory buffer = new bytes(2 * length + 2);
502         buffer[0] = "0";
503         buffer[1] = "x";
504         for (uint256 i = 2 * length + 1; i > 1; --i) {
505             buffer[i] = _SYMBOLS[value & 0xf];
506             value >>= 4;
507         }
508         require(value == 0, "Strings: hex length insufficient");
509         return string(buffer);
510     }
511 
512     /**
513      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
514      */
515     function toHexString(address addr) internal pure returns (string memory) {
516         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
517     }
518 }
519 
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @dev Contract module that helps prevent reentrant calls to a function.
527  *
528  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
529  * available, which can be applied to functions to make sure there are no nested
530  * (reentrant) calls to them.
531  *
532  * Note that because there is a single `nonReentrant` guard, functions marked as
533  * `nonReentrant` may not call one another. This can be worked around by making
534  * those functions `private`, and then adding `external` `nonReentrant` entry
535  * points to them.
536  *
537  * TIP: If you would like to learn more about reentrancy and alternative ways
538  * to protect against it, check out our blog post
539  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
540  */
541 abstract contract ReentrancyGuard {
542     // Booleans are more expensive than uint256 or any type that takes up a full
543     // word because each write operation emits an extra SLOAD to first read the
544     // slot's contents, replace the bits taken up by the boolean, and then write
545     // back. This is the compiler's defense against contract upgrades and
546     // pointer aliasing, and it cannot be disabled.
547 
548     // The values being non-zero value makes deployment a bit more expensive,
549     // but in exchange the refund on every call to nonReentrant will be lower in
550     // amount. Since refunds are capped to a percentage of the total
551     // transaction's gas, it is best to keep them low in cases like this one, to
552     // increase the likelihood of the full refund coming into effect.
553     uint256 private constant _NOT_ENTERED = 1;
554     uint256 private constant _ENTERED = 2;
555 
556     uint256 private _status;
557 
558     constructor() {
559         _status = _NOT_ENTERED;
560     }
561 
562     /**
563      * @dev Prevents a contract from calling itself, directly or indirectly.
564      * Calling a `nonReentrant` function from another `nonReentrant`
565      * function is not supported. It is possible to prevent this from happening
566      * by making the `nonReentrant` function external, and making it call a
567      * `private` function that does the actual work.
568      */
569     modifier nonReentrant() {
570         _nonReentrantBefore();
571         _;
572         _nonReentrantAfter();
573     }
574 
575     function _nonReentrantBefore() private {
576         // On the first call to nonReentrant, _status will be _NOT_ENTERED
577         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
578 
579         // Any calls to nonReentrant after this point will fail
580         _status = _ENTERED;
581     }
582 
583     function _nonReentrantAfter() private {
584         // By storing the original value once again, a refund is triggered (see
585         // https://eips.ethereum.org/EIPS/eip-2200)
586         _status = _NOT_ENTERED;
587     }
588 }
589 
590 
591 
592 
593 pragma solidity ^0.8.0;
594 
595 /**
596  * @dev These functions deal with verification of Merkle Tree proofs.
597  *
598  * The tree and the proofs can be generated using our
599  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
600  * You will find a quickstart guide in the readme.
601  *
602  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
603  * hashing, or use a hash function other than keccak256 for hashing leaves.
604  * This is because the concatenation of a sorted pair of internal nodes in
605  * the merkle tree could be reinterpreted as a leaf value.
606  * OpenZeppelin's JavaScript library generates merkle trees that are safe
607  * against this attack out of the box.
608  */
609 library MerkleProof {
610     /**
611      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
612      * defined by `root`. For this, a `proof` must be provided, containing
613      * sibling hashes on the branch from the leaf to the root of the tree. Each
614      * pair of leaves and each pair of pre-images are assumed to be sorted.
615      */
616     function verify(
617         bytes32[] memory proof,
618         bytes32 root,
619         bytes32 leaf
620     ) internal pure returns (bool) {
621         return processProof(proof, leaf) == root;
622     }
623 
624     /**
625      * @dev Calldata version of {verify}
626      *
627      * _Available since v4.7._
628      */
629     function verifyCalldata(
630         bytes32[] calldata proof,
631         bytes32 root,
632         bytes32 leaf
633     ) internal pure returns (bool) {
634         return processProofCalldata(proof, leaf) == root;
635     }
636 
637     /**
638      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
639      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
640      * hash matches the root of the tree. When processing the proof, the pairs
641      * of leafs & pre-images are assumed to be sorted.
642      *
643      * _Available since v4.4._
644      */
645     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
646         bytes32 computedHash = leaf;
647         for (uint256 i = 0; i < proof.length; i++) {
648             computedHash = _hashPair(computedHash, proof[i]);
649         }
650         return computedHash;
651     }
652 
653     /**
654      * @dev Calldata version of {processProof}
655      *
656      * _Available since v4.7._
657      */
658     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
659         bytes32 computedHash = leaf;
660         for (uint256 i = 0; i < proof.length; i++) {
661             computedHash = _hashPair(computedHash, proof[i]);
662         }
663         return computedHash;
664     }
665 
666     /**
667      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
668      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
669      *
670      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
671      *
672      * _Available since v4.7._
673      */
674     function multiProofVerify(
675         bytes32[] memory proof,
676         bool[] memory proofFlags,
677         bytes32 root,
678         bytes32[] memory leaves
679     ) internal pure returns (bool) {
680         return processMultiProof(proof, proofFlags, leaves) == root;
681     }
682 
683     /**
684      * @dev Calldata version of {multiProofVerify}
685      *
686      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
687      *
688      * _Available since v4.7._
689      */
690     function multiProofVerifyCalldata(
691         bytes32[] calldata proof,
692         bool[] calldata proofFlags,
693         bytes32 root,
694         bytes32[] memory leaves
695     ) internal pure returns (bool) {
696         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
697     }
698 
699     /**
700      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
701      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
702      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
703      * respectively.
704      *
705      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
706      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
707      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
708      *
709      * _Available since v4.7._
710      */
711     function processMultiProof(
712         bytes32[] memory proof,
713         bool[] memory proofFlags,
714         bytes32[] memory leaves
715     ) internal pure returns (bytes32 merkleRoot) {
716         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
717         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
718         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
719         // the merkle tree.
720         uint256 leavesLen = leaves.length;
721         uint256 totalHashes = proofFlags.length;
722 
723         // Check proof validity.
724         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
725 
726         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
727         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
728         bytes32[] memory hashes = new bytes32[](totalHashes);
729         uint256 leafPos = 0;
730         uint256 hashPos = 0;
731         uint256 proofPos = 0;
732         // At each step, we compute the next hash using two values:
733         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
734         //   get the next hash.
735         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
736         //   `proof` array.
737         for (uint256 i = 0; i < totalHashes; i++) {
738             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
739             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
740             hashes[i] = _hashPair(a, b);
741         }
742 
743         if (totalHashes > 0) {
744             return hashes[totalHashes - 1];
745         } else if (leavesLen > 0) {
746             return leaves[0];
747         } else {
748             return proof[0];
749         }
750     }
751 
752     /**
753      * @dev Calldata version of {processMultiProof}.
754      *
755      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
756      *
757      * _Available since v4.7._
758      */
759     function processMultiProofCalldata(
760         bytes32[] calldata proof,
761         bool[] calldata proofFlags,
762         bytes32[] memory leaves
763     ) internal pure returns (bytes32 merkleRoot) {
764         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
765         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
766         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
767         // the merkle tree.
768         uint256 leavesLen = leaves.length;
769         uint256 totalHashes = proofFlags.length;
770 
771         // Check proof validity.
772         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
773 
774         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
775         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
776         bytes32[] memory hashes = new bytes32[](totalHashes);
777         uint256 leafPos = 0;
778         uint256 hashPos = 0;
779         uint256 proofPos = 0;
780         // At each step, we compute the next hash using two values:
781         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
782         //   get the next hash.
783         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
784         //   `proof` array.
785         for (uint256 i = 0; i < totalHashes; i++) {
786             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
787             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
788             hashes[i] = _hashPair(a, b);
789         }
790 
791         if (totalHashes > 0) {
792             return hashes[totalHashes - 1];
793         } else if (leavesLen > 0) {
794             return leaves[0];
795         } else {
796             return proof[0];
797         }
798     }
799 
800     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
801         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
802     }
803 
804     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
805         /// @solidity memory-safe-assembly
806         assembly {
807             mstore(0x00, a)
808             mstore(0x20, b)
809             value := keccak256(0x00, 0x40)
810         }
811     }
812 }
813 
814 
815 
816 
817 pragma solidity ^0.8.4;
818 
819 /**
820  * @dev Interface of ERC721A.
821  */
822 interface IERC721A {
823     /**
824      * The caller must own the token or be an approved operator.
825      */
826     error ApprovalCallerNotOwnerNorApproved();
827 
828     /**
829      * The token does not exist.
830      */
831     error ApprovalQueryForNonexistentToken();
832 
833     /**
834      * Cannot query the balance for the zero address.
835      */
836     error BalanceQueryForZeroAddress();
837 
838     /**
839      * Cannot mint to the zero address.
840      */
841     error MintToZeroAddress();
842 
843     /**
844      * The quantity of tokens minted must be more than zero.
845      */
846     error MintZeroQuantity();
847 
848     /**
849      * The token does not exist.
850      */
851     error OwnerQueryForNonexistentToken();
852 
853     /**
854      * The caller must own the token or be an approved operator.
855      */
856     error TransferCallerNotOwnerNorApproved();
857 
858     /**
859      * The token must be owned by `from`.
860      */
861     error TransferFromIncorrectOwner();
862 
863     /**
864      * Cannot safely transfer to a contract that does not implement the
865      * ERC721Receiver interface.
866      */
867     error TransferToNonERC721ReceiverImplementer();
868 
869     /**
870      * Cannot transfer to the zero address.
871      */
872     error TransferToZeroAddress();
873 
874     /**
875      * The token does not exist.
876      */
877     error URIQueryForNonexistentToken();
878 
879     /**
880      * The `quantity` minted with ERC2309 exceeds the safety limit.
881      */
882     error MintERC2309QuantityExceedsLimit();
883 
884     /**
885      * The `extraData` cannot be set on an unintialized ownership slot.
886      */
887     error OwnershipNotInitializedForExtraData();
888 
889     // =============================================================
890     //                            STRUCTS
891     // =============================================================
892 
893     struct TokenOwnership {
894         // The address of the owner.
895         address addr;
896         // Stores the start time of ownership with minimal overhead for tokenomics.
897         uint64 startTimestamp;
898         // Whether the token has been burned.
899         bool burned;
900         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
901         uint24 extraData;
902     }
903 
904     // =============================================================
905     //                         TOKEN COUNTERS
906     // =============================================================
907 
908     /**
909      * @dev Returns the total number of tokens in existence.
910      * Burned tokens will reduce the count.
911      * To get the total number of tokens minted, please see {_totalMinted}.
912      */
913     function totalSupply() external view returns (uint256);
914 
915     // =============================================================
916     //                            IERC165
917     // =============================================================
918 
919     /**
920      * @dev Returns true if this contract implements the interface defined by
921      * `interfaceId`. See the corresponding
922      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
923      * to learn more about how these ids are created.
924      *
925      * This function call must use less than 30000 gas.
926      */
927     function supportsInterface(bytes4 interfaceId) external view returns (bool);
928 
929     // =============================================================
930     //                            IERC721
931     // =============================================================
932 
933     /**
934      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
935      */
936     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
937 
938     /**
939      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
940      */
941     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
942 
943     /**
944      * @dev Emitted when `owner` enables or disables
945      * (`approved`) `operator` to manage all of its assets.
946      */
947     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
948 
949     /**
950      * @dev Returns the number of tokens in `owner`'s account.
951      */
952     function balanceOf(address owner) external view returns (uint256 balance);
953 
954     /**
955      * @dev Returns the owner of the `tokenId` token.
956      *
957      * Requirements:
958      *
959      * - `tokenId` must exist.
960      */
961     function ownerOf(uint256 tokenId) external view returns (address owner);
962 
963     /**
964      * @dev Safely transfers `tokenId` token from `from` to `to`,
965      * checking first that contract recipients are aware of the ERC721 protocol
966      * to prevent tokens from being forever locked.
967      *
968      * Requirements:
969      *
970      * - `from` cannot be the zero address.
971      * - `to` cannot be the zero address.
972      * - `tokenId` token must exist and be owned by `from`.
973      * - If the caller is not `from`, it must be have been allowed to move
974      * this token by either {approve} or {setApprovalForAll}.
975      * - If `to` refers to a smart contract, it must implement
976      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
977      *
978      * Emits a {Transfer} event.
979      */
980     function safeTransferFrom(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes calldata data
985     ) external payable;
986 
987     /**
988      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
989      */
990     function safeTransferFrom(
991         address from,
992         address to,
993         uint256 tokenId
994     ) external payable;
995 
996     /**
997      * @dev Transfers `tokenId` from `from` to `to`.
998      *
999      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1000      * whenever possible.
1001      *
1002      * Requirements:
1003      *
1004      * - `from` cannot be the zero address.
1005      * - `to` cannot be the zero address.
1006      * - `tokenId` token must be owned by `from`.
1007      * - If the caller is not `from`, it must be approved to move this token
1008      * by either {approve} or {setApprovalForAll}.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function transferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) external payable;
1017 
1018     /**
1019      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1020      * The approval is cleared when the token is transferred.
1021      *
1022      * Only a single account can be approved at a time, so approving the
1023      * zero address clears previous approvals.
1024      *
1025      * Requirements:
1026      *
1027      * - The caller must own the token or be an approved operator.
1028      * - `tokenId` must exist.
1029      *
1030      * Emits an {Approval} event.
1031      */
1032     function approve(address to, uint256 tokenId) external payable;
1033 
1034     /**
1035      * @dev Approve or remove `operator` as an operator for the caller.
1036      * Operators can call {transferFrom} or {safeTransferFrom}
1037      * for any token owned by the caller.
1038      *
1039      * Requirements:
1040      *
1041      * - The `operator` cannot be the caller.
1042      *
1043      * Emits an {ApprovalForAll} event.
1044      */
1045     function setApprovalForAll(address operator, bool _approved) external;
1046 
1047     /**
1048      * @dev Returns the account approved for `tokenId` token.
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must exist.
1053      */
1054     function getApproved(uint256 tokenId) external view returns (address operator);
1055 
1056     /**
1057      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1058      *
1059      * See {setApprovalForAll}.
1060      */
1061     function isApprovedForAll(address owner, address operator) external view returns (bool);
1062 
1063     // =============================================================
1064     //                        IERC721Metadata
1065     // =============================================================
1066 
1067     /**
1068      * @dev Returns the token collection name.
1069      */
1070     function name() external view returns (string memory);
1071 
1072     /**
1073      * @dev Returns the token collection symbol.
1074      */
1075     function symbol() external view returns (string memory);
1076 
1077     /**
1078      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1079      */
1080     function tokenURI(uint256 tokenId) external view returns (string memory);
1081 
1082     // =============================================================
1083     //                           IERC2309
1084     // =============================================================
1085 
1086     /**
1087      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1088      * (inclusive) is transferred from `from` to `to`, as defined in the
1089      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1090      *
1091      * See {_mintERC2309} for more details.
1092      */
1093     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1094 }
1095 
1096 
1097 
1098 
1099 pragma solidity ^0.8.4;
1100 
1101 /**
1102  * @dev Interface of ERC721 token receiver.
1103  */
1104 interface ERC721A__IERC721Receiver {
1105     function onERC721Received(
1106         address operator,
1107         address from,
1108         uint256 tokenId,
1109         bytes calldata data
1110     ) external returns (bytes4);
1111 }
1112 
1113 /**
1114  * @title ERC721A
1115  *
1116  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1117  * Non-Fungible Token Standard, including the Metadata extension.
1118  * Optimized for lower gas during batch mints.
1119  *
1120  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1121  * starting from `_startTokenId()`.
1122  *
1123  * Assumptions:
1124  *
1125  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1126  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1127  */
1128 contract ERC721A is IERC721A {
1129     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1130     struct TokenApprovalRef {
1131         address value;
1132     }
1133 
1134     // =============================================================
1135     //                           CONSTANTS
1136     // =============================================================
1137 
1138     // Mask of an entry in packed address data.
1139     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1140 
1141     // The bit position of `numberMinted` in packed address data.
1142     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1143 
1144     // The bit position of `numberBurned` in packed address data.
1145     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1146 
1147     // The bit position of `aux` in packed address data.
1148     uint256 private constant _BITPOS_AUX = 192;
1149 
1150     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1151     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1152 
1153     // The bit position of `startTimestamp` in packed ownership.
1154     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1155 
1156     // The bit mask of the `burned` bit in packed ownership.
1157     uint256 private constant _BITMASK_BURNED = 1 << 224;
1158 
1159     // The bit position of the `nextInitialized` bit in packed ownership.
1160     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1161 
1162     // The bit mask of the `nextInitialized` bit in packed ownership.
1163     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1164 
1165     // The bit position of `extraData` in packed ownership.
1166     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1167 
1168     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1169     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1170 
1171     // The mask of the lower 160 bits for addresses.
1172     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1173 
1174     // The maximum `quantity` that can be minted with {_mintERC2309}.
1175     // This limit is to prevent overflows on the address data entries.
1176     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1177     // is required to cause an overflow, which is unrealistic.
1178     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1179 
1180     // The `Transfer` event signature is given by:
1181     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1182     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1183         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1184 
1185     // =============================================================
1186     //                            STORAGE
1187     // =============================================================
1188 
1189     // The next token ID to be minted.
1190     uint256 private _currentIndex;
1191 
1192     // The number of tokens burned.
1193     uint256 private _burnCounter;
1194 
1195     // Token name
1196     string private _name;
1197 
1198     // Token symbol
1199     string private _symbol;
1200 
1201     // Mapping from token ID to ownership details
1202     // An empty struct value does not necessarily mean the token is unowned.
1203     // See {_packedOwnershipOf} implementation for details.
1204     //
1205     // Bits Layout:
1206     // - [0..159]   `addr`
1207     // - [160..223] `startTimestamp`
1208     // - [224]      `burned`
1209     // - [225]      `nextInitialized`
1210     // - [232..255] `extraData`
1211     mapping(uint256 => uint256) private _packedOwnerships;
1212 
1213     // Mapping owner address to address data.
1214     //
1215     // Bits Layout:
1216     // - [0..63]    `balance`
1217     // - [64..127]  `numberMinted`
1218     // - [128..191] `numberBurned`
1219     // - [192..255] `aux`
1220     mapping(address => uint256) private _packedAddressData;
1221 
1222     // Mapping from token ID to approved address.
1223     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1224 
1225     // Mapping from owner to operator approvals
1226     mapping(address => mapping(address => bool)) private _operatorApprovals;
1227 
1228     // =============================================================
1229     //                          CONSTRUCTOR
1230     // =============================================================
1231 
1232     constructor(string memory name_, string memory symbol_) {
1233         _name = name_;
1234         _symbol = symbol_;
1235         _currentIndex = _startTokenId();
1236     }
1237 
1238     // =============================================================
1239     //                   TOKEN COUNTING OPERATIONS
1240     // =============================================================
1241 
1242     /**
1243      * @dev Returns the starting token ID.
1244      * To change the starting token ID, please override this function.
1245      */
1246     function _startTokenId() internal view virtual returns (uint256) {
1247         return 0;
1248     }
1249 
1250     /**
1251      * @dev Returns the next token ID to be minted.
1252      */
1253     function _nextTokenId() internal view virtual returns (uint256) {
1254         return _currentIndex;
1255     }
1256 
1257     /**
1258      * @dev Returns the total number of tokens in existence.
1259      * Burned tokens will reduce the count.
1260      * To get the total number of tokens minted, please see {_totalMinted}.
1261      */
1262     function totalSupply() public view virtual override returns (uint256) {
1263         // Counter underflow is impossible as _burnCounter cannot be incremented
1264         // more than `_currentIndex - _startTokenId()` times.
1265         unchecked {
1266             return _currentIndex - _burnCounter - _startTokenId();
1267         }
1268     }
1269 
1270     /**
1271      * @dev Returns the total amount of tokens minted in the contract.
1272      */
1273     function _totalMinted() internal view virtual returns (uint256) {
1274         // Counter underflow is impossible as `_currentIndex` does not decrement,
1275         // and it is initialized to `_startTokenId()`.
1276         unchecked {
1277             return _currentIndex - _startTokenId();
1278         }
1279     }
1280 
1281     /**
1282      * @dev Returns the total number of tokens burned.
1283      */
1284     function _totalBurned() internal view virtual returns (uint256) {
1285         return _burnCounter;
1286     }
1287 
1288     // =============================================================
1289     //                    ADDRESS DATA OPERATIONS
1290     // =============================================================
1291 
1292     /**
1293      * @dev Returns the number of tokens in `owner`'s account.
1294      */
1295     function balanceOf(address owner) public view virtual override returns (uint256) {
1296         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1297         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1298     }
1299 
1300     /**
1301      * Returns the number of tokens minted by `owner`.
1302      */
1303     function _numberMinted(address owner) internal view returns (uint256) {
1304         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1305     }
1306 
1307     /**
1308      * Returns the number of tokens burned by or on behalf of `owner`.
1309      */
1310     function _numberBurned(address owner) internal view returns (uint256) {
1311         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1312     }
1313 
1314     /**
1315      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1316      */
1317     function _getAux(address owner) internal view returns (uint64) {
1318         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1319     }
1320 
1321     /**
1322      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1323      * If there are multiple variables, please pack them into a uint64.
1324      */
1325     function _setAux(address owner, uint64 aux) internal virtual {
1326         uint256 packed = _packedAddressData[owner];
1327         uint256 auxCasted;
1328         // Cast `aux` with assembly to avoid redundant masking.
1329         assembly {
1330             auxCasted := aux
1331         }
1332         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1333         _packedAddressData[owner] = packed;
1334     }
1335 
1336     // =============================================================
1337     //                            IERC165
1338     // =============================================================
1339 
1340     /**
1341      * @dev Returns true if this contract implements the interface defined by
1342      * `interfaceId`. See the corresponding
1343      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1344      * to learn more about how these ids are created.
1345      *
1346      * This function call must use less than 30000 gas.
1347      */
1348     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1349         // The interface IDs are constants representing the first 4 bytes
1350         // of the XOR of all function selectors in the interface.
1351         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1352         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1353         return
1354             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1355             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1356             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1357     }
1358 
1359     // =============================================================
1360     //                        IERC721Metadata
1361     // =============================================================
1362 
1363     /**
1364      * @dev Returns the token collection name.
1365      */
1366     function name() public view virtual override returns (string memory) {
1367         return _name;
1368     }
1369 
1370     /**
1371      * @dev Returns the token collection symbol.
1372      */
1373     function symbol() public view virtual override returns (string memory) {
1374         return _symbol;
1375     }
1376 
1377     /**
1378      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1379      */
1380     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1381         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1382 
1383         string memory baseURI = _baseURI();
1384         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1385     }
1386 
1387     /**
1388      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1389      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1390      * by default, it can be overridden in child contracts.
1391      */
1392     function _baseURI() internal view virtual returns (string memory) {
1393         return '';
1394     }
1395 
1396     // =============================================================
1397     //                     OWNERSHIPS OPERATIONS
1398     // =============================================================
1399 
1400     /**
1401      * @dev Returns the owner of the `tokenId` token.
1402      *
1403      * Requirements:
1404      *
1405      * - `tokenId` must exist.
1406      */
1407     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1408         return address(uint160(_packedOwnershipOf(tokenId)));
1409     }
1410 
1411     /**
1412      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1413      * It gradually moves to O(1) as tokens get transferred around over time.
1414      */
1415     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1416         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1417     }
1418 
1419     /**
1420      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1421      */
1422     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1423         return _unpackedOwnership(_packedOwnerships[index]);
1424     }
1425 
1426     /**
1427      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1428      */
1429     function _initializeOwnershipAt(uint256 index) internal virtual {
1430         if (_packedOwnerships[index] == 0) {
1431             _packedOwnerships[index] = _packedOwnershipOf(index);
1432         }
1433     }
1434 
1435     /**
1436      * Returns the packed ownership data of `tokenId`.
1437      */
1438     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1439         uint256 curr = tokenId;
1440 
1441         unchecked {
1442             if (_startTokenId() <= curr)
1443                 if (curr < _currentIndex) {
1444                     uint256 packed = _packedOwnerships[curr];
1445                     // If not burned.
1446                     if (packed & _BITMASK_BURNED == 0) {
1447                         // Invariant:
1448                         // There will always be an initialized ownership slot
1449                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1450                         // before an unintialized ownership slot
1451                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1452                         // Hence, `curr` will not underflow.
1453                         //
1454                         // We can directly compare the packed value.
1455                         // If the address is zero, packed will be zero.
1456                         while (packed == 0) {
1457                             packed = _packedOwnerships[--curr];
1458                         }
1459                         return packed;
1460                     }
1461                 }
1462         }
1463         revert OwnerQueryForNonexistentToken();
1464     }
1465 
1466     /**
1467      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1468      */
1469     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1470         ownership.addr = address(uint160(packed));
1471         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1472         ownership.burned = packed & _BITMASK_BURNED != 0;
1473         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1474     }
1475 
1476     /**
1477      * @dev Packs ownership data into a single uint256.
1478      */
1479     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1480         assembly {
1481             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1482             owner := and(owner, _BITMASK_ADDRESS)
1483             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1484             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1485         }
1486     }
1487 
1488     /**
1489      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1490      */
1491     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1492         // For branchless setting of the `nextInitialized` flag.
1493         assembly {
1494             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1495             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1496         }
1497     }
1498 
1499     // =============================================================
1500     //                      APPROVAL OPERATIONS
1501     // =============================================================
1502 
1503     /**
1504      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1505      * The approval is cleared when the token is transferred.
1506      *
1507      * Only a single account can be approved at a time, so approving the
1508      * zero address clears previous approvals.
1509      *
1510      * Requirements:
1511      *
1512      * - The caller must own the token or be an approved operator.
1513      * - `tokenId` must exist.
1514      *
1515      * Emits an {Approval} event.
1516      */
1517     function approve(address to, uint256 tokenId) public payable virtual override {
1518         address owner = ownerOf(tokenId);
1519 
1520         if (_msgSenderERC721A() != owner)
1521             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1522                 revert ApprovalCallerNotOwnerNorApproved();
1523             }
1524 
1525         _tokenApprovals[tokenId].value = to;
1526         emit Approval(owner, to, tokenId);
1527     }
1528 
1529     /**
1530      * @dev Returns the account approved for `tokenId` token.
1531      *
1532      * Requirements:
1533      *
1534      * - `tokenId` must exist.
1535      */
1536     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1537         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1538 
1539         return _tokenApprovals[tokenId].value;
1540     }
1541 
1542     /**
1543      * @dev Approve or remove `operator` as an operator for the caller.
1544      * Operators can call {transferFrom} or {safeTransferFrom}
1545      * for any token owned by the caller.
1546      *
1547      * Requirements:
1548      *
1549      * - The `operator` cannot be the caller.
1550      *
1551      * Emits an {ApprovalForAll} event.
1552      */
1553     function setApprovalForAll(address operator, bool approved) public virtual override {
1554         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1555         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1556     }
1557 
1558     /**
1559      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1560      *
1561      * See {setApprovalForAll}.
1562      */
1563     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1564         return _operatorApprovals[owner][operator];
1565     }
1566 
1567     /**
1568      * @dev Returns whether `tokenId` exists.
1569      *
1570      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1571      *
1572      * Tokens start existing when they are minted. See {_mint}.
1573      */
1574     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1575         return
1576             _startTokenId() <= tokenId &&
1577             tokenId < _currentIndex && // If within bounds,
1578             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1579     }
1580 
1581     /**
1582      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1583      */
1584     function _isSenderApprovedOrOwner(
1585         address approvedAddress,
1586         address owner,
1587         address msgSender
1588     ) private pure returns (bool result) {
1589         assembly {
1590             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1591             owner := and(owner, _BITMASK_ADDRESS)
1592             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1593             msgSender := and(msgSender, _BITMASK_ADDRESS)
1594             // `msgSender == owner || msgSender == approvedAddress`.
1595             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1596         }
1597     }
1598 
1599     /**
1600      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1601      */
1602     function _getApprovedSlotAndAddress(uint256 tokenId)
1603         private
1604         view
1605         returns (uint256 approvedAddressSlot, address approvedAddress)
1606     {
1607         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1608         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1609         assembly {
1610             approvedAddressSlot := tokenApproval.slot
1611             approvedAddress := sload(approvedAddressSlot)
1612         }
1613     }
1614 
1615     // =============================================================
1616     //                      TRANSFER OPERATIONS
1617     // =============================================================
1618 
1619     /**
1620      * @dev Transfers `tokenId` from `from` to `to`.
1621      *
1622      * Requirements:
1623      *
1624      * - `from` cannot be the zero address.
1625      * - `to` cannot be the zero address.
1626      * - `tokenId` token must be owned by `from`.
1627      * - If the caller is not `from`, it must be approved to move this token
1628      * by either {approve} or {setApprovalForAll}.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function transferFrom(
1633         address from,
1634         address to,
1635         uint256 tokenId
1636     ) public payable virtual override {
1637         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1638 
1639         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1640 
1641         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1642 
1643         // The nested ifs save around 20+ gas over a compound boolean condition.
1644         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1645             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1646 
1647         if (to == address(0)) revert TransferToZeroAddress();
1648 
1649         _beforeTokenTransfers(from, to, tokenId, 1);
1650 
1651         // Clear approvals from the previous owner.
1652         assembly {
1653             if approvedAddress {
1654                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1655                 sstore(approvedAddressSlot, 0)
1656             }
1657         }
1658 
1659         // Underflow of the sender's balance is impossible because we check for
1660         // ownership above and the recipient's balance can't realistically overflow.
1661         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1662         unchecked {
1663             // We can directly increment and decrement the balances.
1664             --_packedAddressData[from]; // Updates: `balance -= 1`.
1665             ++_packedAddressData[to]; // Updates: `balance += 1`.
1666 
1667             // Updates:
1668             // - `address` to the next owner.
1669             // - `startTimestamp` to the timestamp of transfering.
1670             // - `burned` to `false`.
1671             // - `nextInitialized` to `true`.
1672             _packedOwnerships[tokenId] = _packOwnershipData(
1673                 to,
1674                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1675             );
1676 
1677             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1678             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1679                 uint256 nextTokenId = tokenId + 1;
1680                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1681                 if (_packedOwnerships[nextTokenId] == 0) {
1682                     // If the next slot is within bounds.
1683                     if (nextTokenId != _currentIndex) {
1684                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1685                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1686                     }
1687                 }
1688             }
1689         }
1690 
1691         emit Transfer(from, to, tokenId);
1692         _afterTokenTransfers(from, to, tokenId, 1);
1693     }
1694 
1695     /**
1696      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1697      */
1698     function safeTransferFrom(
1699         address from,
1700         address to,
1701         uint256 tokenId
1702     ) public payable virtual override {
1703         safeTransferFrom(from, to, tokenId, '');
1704     }
1705 
1706     /**
1707      * @dev Safely transfers `tokenId` token from `from` to `to`.
1708      *
1709      * Requirements:
1710      *
1711      * - `from` cannot be the zero address.
1712      * - `to` cannot be the zero address.
1713      * - `tokenId` token must exist and be owned by `from`.
1714      * - If the caller is not `from`, it must be approved to move this token
1715      * by either {approve} or {setApprovalForAll}.
1716      * - If `to` refers to a smart contract, it must implement
1717      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1718      *
1719      * Emits a {Transfer} event.
1720      */
1721     function safeTransferFrom(
1722         address from,
1723         address to,
1724         uint256 tokenId,
1725         bytes memory _data
1726     ) public payable virtual override {
1727         transferFrom(from, to, tokenId);
1728         if (to.code.length != 0)
1729             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1730                 revert TransferToNonERC721ReceiverImplementer();
1731             }
1732     }
1733 
1734     /**
1735      * @dev Hook that is called before a set of serially-ordered token IDs
1736      * are about to be transferred. This includes minting.
1737      * And also called before burning one token.
1738      *
1739      * `startTokenId` - the first token ID to be transferred.
1740      * `quantity` - the amount to be transferred.
1741      *
1742      * Calling conditions:
1743      *
1744      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1745      * transferred to `to`.
1746      * - When `from` is zero, `tokenId` will be minted for `to`.
1747      * - When `to` is zero, `tokenId` will be burned by `from`.
1748      * - `from` and `to` are never both zero.
1749      */
1750     function _beforeTokenTransfers(
1751         address from,
1752         address to,
1753         uint256 startTokenId,
1754         uint256 quantity
1755     ) internal virtual {}
1756 
1757     /**
1758      * @dev Hook that is called after a set of serially-ordered token IDs
1759      * have been transferred. This includes minting.
1760      * And also called after one token has been burned.
1761      *
1762      * `startTokenId` - the first token ID to be transferred.
1763      * `quantity` - the amount to be transferred.
1764      *
1765      * Calling conditions:
1766      *
1767      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1768      * transferred to `to`.
1769      * - When `from` is zero, `tokenId` has been minted for `to`.
1770      * - When `to` is zero, `tokenId` has been burned by `from`.
1771      * - `from` and `to` are never both zero.
1772      */
1773     function _afterTokenTransfers(
1774         address from,
1775         address to,
1776         uint256 startTokenId,
1777         uint256 quantity
1778     ) internal virtual {}
1779 
1780     /**
1781      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1782      *
1783      * `from` - Previous owner of the given token ID.
1784      * `to` - Target address that will receive the token.
1785      * `tokenId` - Token ID to be transferred.
1786      * `_data` - Optional data to send along with the call.
1787      *
1788      * Returns whether the call correctly returned the expected magic value.
1789      */
1790     function _checkContractOnERC721Received(
1791         address from,
1792         address to,
1793         uint256 tokenId,
1794         bytes memory _data
1795     ) private returns (bool) {
1796         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1797             bytes4 retval
1798         ) {
1799             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1800         } catch (bytes memory reason) {
1801             if (reason.length == 0) {
1802                 revert TransferToNonERC721ReceiverImplementer();
1803             } else {
1804                 assembly {
1805                     revert(add(32, reason), mload(reason))
1806                 }
1807             }
1808         }
1809     }
1810 
1811     // =============================================================
1812     //                        MINT OPERATIONS
1813     // =============================================================
1814 
1815     /**
1816      * @dev Mints `quantity` tokens and transfers them to `to`.
1817      *
1818      * Requirements:
1819      *
1820      * - `to` cannot be the zero address.
1821      * - `quantity` must be greater than 0.
1822      *
1823      * Emits a {Transfer} event for each mint.
1824      */
1825     function _mint(address to, uint256 quantity) internal virtual {
1826         uint256 startTokenId = _currentIndex;
1827         if (quantity == 0) revert MintZeroQuantity();
1828 
1829         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1830 
1831         // Overflows are incredibly unrealistic.
1832         // `balance` and `numberMinted` have a maximum limit of 2**64.
1833         // `tokenId` has a maximum limit of 2**256.
1834         unchecked {
1835             // Updates:
1836             // - `balance += quantity`.
1837             // - `numberMinted += quantity`.
1838             //
1839             // We can directly add to the `balance` and `numberMinted`.
1840             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1841 
1842             // Updates:
1843             // - `address` to the owner.
1844             // - `startTimestamp` to the timestamp of minting.
1845             // - `burned` to `false`.
1846             // - `nextInitialized` to `quantity == 1`.
1847             _packedOwnerships[startTokenId] = _packOwnershipData(
1848                 to,
1849                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1850             );
1851 
1852             uint256 toMasked;
1853             uint256 end = startTokenId + quantity;
1854 
1855             // Use assembly to loop and emit the `Transfer` event for gas savings.
1856             // The duplicated `log4` removes an extra check and reduces stack juggling.
1857             // The assembly, together with the surrounding Solidity code, have been
1858             // delicately arranged to nudge the compiler into producing optimized opcodes.
1859             assembly {
1860                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1861                 toMasked := and(to, _BITMASK_ADDRESS)
1862                 // Emit the `Transfer` event.
1863                 log4(
1864                     0, // Start of data (0, since no data).
1865                     0, // End of data (0, since no data).
1866                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1867                     0, // `address(0)`.
1868                     toMasked, // `to`.
1869                     startTokenId // `tokenId`.
1870                 )
1871 
1872                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1873                 // that overflows uint256 will make the loop run out of gas.
1874                 // The compiler will optimize the `iszero` away for performance.
1875                 for {
1876                     let tokenId := add(startTokenId, 1)
1877                 } iszero(eq(tokenId, end)) {
1878                     tokenId := add(tokenId, 1)
1879                 } {
1880                     // Emit the `Transfer` event. Similar to above.
1881                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1882                 }
1883             }
1884             if (toMasked == 0) revert MintToZeroAddress();
1885 
1886             _currentIndex = end;
1887         }
1888         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1889     }
1890 
1891     /**
1892      * @dev Mints `quantity` tokens and transfers them to `to`.
1893      *
1894      * This function is intended for efficient minting only during contract creation.
1895      *
1896      * It emits only one {ConsecutiveTransfer} as defined in
1897      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1898      * instead of a sequence of {Transfer} event(s).
1899      *
1900      * Calling this function outside of contract creation WILL make your contract
1901      * non-compliant with the ERC721 standard.
1902      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1903      * {ConsecutiveTransfer} event is only permissible during contract creation.
1904      *
1905      * Requirements:
1906      *
1907      * - `to` cannot be the zero address.
1908      * - `quantity` must be greater than 0.
1909      *
1910      * Emits a {ConsecutiveTransfer} event.
1911      */
1912     function _mintERC2309(address to, uint256 quantity) internal virtual {
1913         uint256 startTokenId = _currentIndex;
1914         if (to == address(0)) revert MintToZeroAddress();
1915         if (quantity == 0) revert MintZeroQuantity();
1916         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1917 
1918         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1919 
1920         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1921         unchecked {
1922             // Updates:
1923             // - `balance += quantity`.
1924             // - `numberMinted += quantity`.
1925             //
1926             // We can directly add to the `balance` and `numberMinted`.
1927             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1928 
1929             // Updates:
1930             // - `address` to the owner.
1931             // - `startTimestamp` to the timestamp of minting.
1932             // - `burned` to `false`.
1933             // - `nextInitialized` to `quantity == 1`.
1934             _packedOwnerships[startTokenId] = _packOwnershipData(
1935                 to,
1936                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1937             );
1938 
1939             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1940 
1941             _currentIndex = startTokenId + quantity;
1942         }
1943         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1944     }
1945 
1946     /**
1947      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1948      *
1949      * Requirements:
1950      *
1951      * - If `to` refers to a smart contract, it must implement
1952      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1953      * - `quantity` must be greater than 0.
1954      *
1955      * See {_mint}.
1956      *
1957      * Emits a {Transfer} event for each mint.
1958      */
1959     function _safeMint(
1960         address to,
1961         uint256 quantity,
1962         bytes memory _data
1963     ) internal virtual {
1964         _mint(to, quantity);
1965 
1966         unchecked {
1967             if (to.code.length != 0) {
1968                 uint256 end = _currentIndex;
1969                 uint256 index = end - quantity;
1970                 do {
1971                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1972                         revert TransferToNonERC721ReceiverImplementer();
1973                     }
1974                 } while (index < end);
1975                 // Reentrancy protection.
1976                 if (_currentIndex != end) revert();
1977             }
1978         }
1979     }
1980 
1981     /**
1982      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1983      */
1984     function _safeMint(address to, uint256 quantity) internal virtual {
1985         _safeMint(to, quantity, '');
1986     }
1987 
1988     // =============================================================
1989     //                        BURN OPERATIONS
1990     // =============================================================
1991 
1992     /**
1993      * @dev Equivalent to `_burn(tokenId, false)`.
1994      */
1995     function _burn(uint256 tokenId) internal virtual {
1996         _burn(tokenId, false);
1997     }
1998 
1999     /**
2000      * @dev Destroys `tokenId`.
2001      * The approval is cleared when the token is burned.
2002      *
2003      * Requirements:
2004      *
2005      * - `tokenId` must exist.
2006      *
2007      * Emits a {Transfer} event.
2008      */
2009     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2010         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2011 
2012         address from = address(uint160(prevOwnershipPacked));
2013 
2014         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2015 
2016         if (approvalCheck) {
2017             // The nested ifs save around 20+ gas over a compound boolean condition.
2018             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2019                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2020         }
2021 
2022         _beforeTokenTransfers(from, address(0), tokenId, 1);
2023 
2024         // Clear approvals from the previous owner.
2025         assembly {
2026             if approvedAddress {
2027                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2028                 sstore(approvedAddressSlot, 0)
2029             }
2030         }
2031 
2032         // Underflow of the sender's balance is impossible because we check for
2033         // ownership above and the recipient's balance can't realistically overflow.
2034         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2035         unchecked {
2036             // Updates:
2037             // - `balance -= 1`.
2038             // - `numberBurned += 1`.
2039             //
2040             // We can directly decrement the balance, and increment the number burned.
2041             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2042             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2043 
2044             // Updates:
2045             // - `address` to the last owner.
2046             // - `startTimestamp` to the timestamp of burning.
2047             // - `burned` to `true`.
2048             // - `nextInitialized` to `true`.
2049             _packedOwnerships[tokenId] = _packOwnershipData(
2050                 from,
2051                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2052             );
2053 
2054             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2055             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2056                 uint256 nextTokenId = tokenId + 1;
2057                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2058                 if (_packedOwnerships[nextTokenId] == 0) {
2059                     // If the next slot is within bounds.
2060                     if (nextTokenId != _currentIndex) {
2061                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2062                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2063                     }
2064                 }
2065             }
2066         }
2067 
2068         emit Transfer(from, address(0), tokenId);
2069         _afterTokenTransfers(from, address(0), tokenId, 1);
2070 
2071         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2072         unchecked {
2073             _burnCounter++;
2074         }
2075     }
2076 
2077     // =============================================================
2078     //                     EXTRA DATA OPERATIONS
2079     // =============================================================
2080 
2081     /**
2082      * @dev Directly sets the extra data for the ownership data `index`.
2083      */
2084     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2085         uint256 packed = _packedOwnerships[index];
2086         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2087         uint256 extraDataCasted;
2088         // Cast `extraData` with assembly to avoid redundant masking.
2089         assembly {
2090             extraDataCasted := extraData
2091         }
2092         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2093         _packedOwnerships[index] = packed;
2094     }
2095 
2096     /**
2097      * @dev Called during each token transfer to set the 24bit `extraData` field.
2098      * Intended to be overridden by the cosumer contract.
2099      *
2100      * `previousExtraData` - the value of `extraData` before transfer.
2101      *
2102      * Calling conditions:
2103      *
2104      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2105      * transferred to `to`.
2106      * - When `from` is zero, `tokenId` will be minted for `to`.
2107      * - When `to` is zero, `tokenId` will be burned by `from`.
2108      * - `from` and `to` are never both zero.
2109      */
2110     function _extraData(
2111         address from,
2112         address to,
2113         uint24 previousExtraData
2114     ) internal view virtual returns (uint24) {}
2115 
2116     /**
2117      * @dev Returns the next extra data for the packed ownership data.
2118      * The returned result is shifted into position.
2119      */
2120     function _nextExtraData(
2121         address from,
2122         address to,
2123         uint256 prevOwnershipPacked
2124     ) private view returns (uint256) {
2125         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2126         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2127     }
2128 
2129     // =============================================================
2130     //                       OTHER OPERATIONS
2131     // =============================================================
2132 
2133     /**
2134      * @dev Returns the message sender (defaults to `msg.sender`).
2135      *
2136      * If you are writing GSN compatible contracts, you need to override this function.
2137      */
2138     function _msgSenderERC721A() internal view virtual returns (address) {
2139         return msg.sender;
2140     }
2141 
2142     /**
2143      * @dev Converts a uint256 to its ASCII string decimal representation.
2144      */
2145     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2146         assembly {
2147             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2148             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2149             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2150             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2151             let m := add(mload(0x40), 0xa0)
2152             // Update the free memory pointer to allocate.
2153             mstore(0x40, m)
2154             // Assign the `str` to the end.
2155             str := sub(m, 0x20)
2156             // Zeroize the slot after the string.
2157             mstore(str, 0)
2158 
2159             // Cache the end of the memory to calculate the length later.
2160             let end := str
2161 
2162             // We write the string from rightmost digit to leftmost digit.
2163             // The following is essentially a do-while loop that also handles the zero case.
2164             // prettier-ignore
2165             for { let temp := value } 1 {} {
2166                 str := sub(str, 1)
2167                 // Write the character to the pointer.
2168                 // The ASCII index of the '0' character is 48.
2169                 mstore8(str, add(48, mod(temp, 10)))
2170                 // Keep dividing `temp` until zero.
2171                 temp := div(temp, 10)
2172                 // prettier-ignore
2173                 if iszero(temp) { break }
2174             }
2175 
2176             let length := sub(end, str)
2177             // Move the pointer 32 bytes leftwards to make room for the length.
2178             str := sub(str, 0x20)
2179             // Store the length.
2180             mstore(str, length)
2181         }
2182     }
2183 }
2184 
2185 
2186 
2187 pragma solidity ^0.8.13;
2188 
2189 interface IOperatorFilterRegistry {
2190     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2191     function register(address registrant) external;
2192     function registerAndSubscribe(address registrant, address subscription) external;
2193     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2194     function unregister(address addr) external;
2195     function updateOperator(address registrant, address operator, bool filtered) external;
2196     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2197     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2198     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2199     function subscribe(address registrant, address registrantToSubscribe) external;
2200     function unsubscribe(address registrant, bool copyExistingEntries) external;
2201     function subscriptionOf(address addr) external returns (address registrant);
2202     function subscribers(address registrant) external returns (address[] memory);
2203     function subscriberAt(address registrant, uint256 index) external returns (address);
2204     function copyEntriesOf(address registrant, address registrantToCopy) external;
2205     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2206     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2207     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2208     function filteredOperators(address addr) external returns (address[] memory);
2209     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2210     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2211     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2212     function isRegistered(address addr) external returns (bool);
2213     function codeHashOf(address addr) external returns (bytes32);
2214 }
2215 
2216 
2217 
2218 pragma solidity ^0.8.13;
2219 
2220 /**
2221  * @title  OperatorFilterer
2222  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2223  *         registrant's entries in the OperatorFilterRegistry.
2224  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2225  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2226  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2227  */
2228 abstract contract OperatorFilterer {
2229     error OperatorNotAllowed(address operator);
2230 
2231     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2232         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
2233 
2234     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2235         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2236         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2237         // order for the modifier to filter addresses.
2238         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2239             if (subscribe) {
2240                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2241             } else {
2242                 if (subscriptionOrRegistrantToCopy != address(0)) {
2243                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2244                 } else {
2245                     OPERATOR_FILTER_REGISTRY.register(address(this));
2246                 }
2247             }
2248         }
2249     }
2250 
2251     modifier onlyAllowedOperator(address from) virtual {
2252         // Allow spending tokens from addresses with balance
2253         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2254         // from an EOA.
2255         if (from != msg.sender) {
2256             _checkFilterOperator(msg.sender);
2257         }
2258         _;
2259     }
2260 
2261     modifier onlyAllowedOperatorApproval(address operator) virtual {
2262         _checkFilterOperator(operator);
2263         _;
2264     }
2265 
2266     function _checkFilterOperator(address operator) internal view virtual {
2267         // Check registry code length to facilitate testing in environments without a deployed registry.
2268         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2269             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2270                 revert OperatorNotAllowed(operator);
2271             }
2272         }
2273     }
2274 }
2275 
2276 
2277 
2278 pragma solidity ^0.8.13;
2279 
2280 /**
2281  * @title  DefaultOperatorFilterer
2282  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2283  */
2284 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2285     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2286 
2287     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
2288 }
2289 
2290 
2291 
2292 pragma solidity ^0.8.19;
2293 
2294 
2295 
2296 
2297 
2298 
2299 contract IconicNFT721a is ERC721A, ReentrancyGuard, Ownable, DefaultOperatorFilterer {
2300   uint16 public maxMintsPerAddress = 1;
2301   mapping(address => int16) public artPassMints;
2302 
2303   bool public artPassMintingActive = false;
2304   bool public allowListMintingActive = false;
2305   bool public mintingActive = false;
2306   bool public burningActive = false;
2307   bytes32 public allowListMerkleRoot = '';
2308   bytes32 public artPassMerkleRoot = '';
2309 
2310   string public baseURI;
2311   bool public useEditionForURI = false;
2312   
2313   uint256 public mintPrice;
2314   address payable iconicAddress;
2315   address admin;
2316 
2317   mapping(uint16 => uint16) public editionSupply; //how many available within that edition
2318   mapping(uint256 => uint16) public tokenToEdition; //token to edition
2319 
2320   constructor(string memory name_,
2321     string memory symbol_,
2322     string memory baseURI_,
2323     bytes32 artPassMerkleRoot_,
2324     bytes32 allowListMerkleRoot_,
2325     address iconicAddress_,
2326     uint256 mintPrice_,
2327     uint16 editionSupply_)
2328     ERC721A(name_, symbol_) {
2329     require(_msgSenderERC721A() != iconicAddress_, "Error");
2330     admin = _msgSenderERC721A();
2331 
2332     baseURI = baseURI_;
2333     artPassMerkleRoot = artPassMerkleRoot_;
2334     allowListMerkleRoot = allowListMerkleRoot_;
2335     iconicAddress = payable(iconicAddress_);
2336     mintPrice = mintPrice_;
2337     setSupplyInEdition(1, editionSupply_);
2338   }
2339 
2340   function enableArtPassMinting() public requiresAdmin {
2341     artPassMintingActive = true;
2342   }
2343 
2344   function disableArtPassMinting() public requiresAdmin {
2345     artPassMintingActive = false;
2346   }
2347 
2348   function enableAllowListMinting() public requiresAdmin {
2349     allowListMintingActive = true;
2350   }
2351 
2352   function disableAllowListMinting() public requiresAdmin {
2353     allowListMintingActive = false;
2354   }
2355 
2356   function enableMinting() public requiresAdmin {
2357     mintingActive = true;
2358   }
2359 
2360   function disableMinting() public requiresAdmin {
2361     mintingActive = false;
2362   }
2363 
2364   function enableTokenBurning() public requiresAdmin {
2365     burningActive = true;
2366   }
2367 
2368   function disableTokenBurning() public requiresAdmin {
2369     burningActive = false;
2370   }
2371 
2372   function enableUseEditionForURI() public requiresAdmin {
2373     useEditionForURI = true;
2374   }
2375 
2376   function disableUseEditionForURI() public requiresAdmin {
2377     useEditionForURI = false;
2378   }
2379 
2380   function setBaseTokenURI(string memory baseURI_) public requiresAdmin {
2381     baseURI = baseURI_;
2382   }
2383 
2384   function setSupplyInEdition(uint16 edition, uint16 supply) public requiresAdmin {
2385     editionSupply[edition] = supply;
2386   }
2387 
2388   function setMintPrice(uint256 mintPrice_) public requiresAdmin {
2389     mintPrice = mintPrice_;
2390   }
2391 
2392   function setMaxMintsPerAddress(uint8 maxMintsPerAddress_) public requiresAdmin {
2393     maxMintsPerAddress = maxMintsPerAddress_;
2394   }
2395 
2396   function setArtPassMerkleRoot(bytes32 merkleRoot_) public requiresAdmin {
2397     artPassMerkleRoot = merkleRoot_;
2398   }
2399 
2400   function setAllowListMerkleRoot(bytes32 merkleRoot_) public requiresAdmin {
2401     allowListMerkleRoot = merkleRoot_;
2402   }
2403 
2404   function setAdditionalArtPassMints(address[] memory artPassHolders, int8[] memory extras) public requiresAdmin {
2405     //remember to zero out old addresses
2406     require(artPassHolders.length == extras.length, "incorrect list");
2407 
2408     for(uint16 i = 0; i < artPassHolders.length; i++) {
2409       artPassMints[artPassHolders[i]] = extras[i];
2410     }
2411   }
2412 
2413   function getAvailableArtPassMintCount(address artPassHolder) public view returns (uint16) {
2414     int16 availableMints = 1 + artPassMints[artPassHolder];
2415     return uint16(availableMints);
2416   }
2417 
2418   function artPassMint(bytes32[] calldata merkleProof, uint16 amount, uint16 editionIndex) external payable nonReentrant() {
2419     require(artPassMintingActive, "Art Pass minting not enabled");
2420     require(msg.value == mintPrice * amount, "Incorrect amount of ether sent");
2421     require(amount > 0, "Must mint positive amount");
2422     require(editionSupply[editionIndex] >= amount, "Mint exceeds collection size");
2423 
2424     require(getAvailableArtPassMintCount(_msgSenderERC721A())>= amount, "Exceeds Art Pass holder mint limit");
2425 
2426     require(
2427         MerkleProof.verify(
2428             merkleProof,
2429             artPassMerkleRoot,
2430             keccak256(abi.encodePacked(_msgSenderERC721A()))
2431         ),
2432         "Not an Art Pass holder"
2433     );
2434 
2435     iconicAddress.transfer(msg.value);
2436     _mint(_msgSenderERC721A(), amount);
2437     _editionUpdate(amount, editionIndex);
2438     artPassMints[_msgSenderERC721A()] = artPassMints[_msgSenderERC721A()] - int16(amount);
2439   }
2440 
2441   function allowlistMint(bytes32[] calldata merkleProof, uint16 amount, uint16 editionIndex) external payable nonReentrant() {
2442     require(allowListMintingActive, "Allow list minting not enabled");
2443     require(msg.value == mintPrice * amount, "Incorrect amount of ether sent");
2444     require(amount > 0, "Must mint positive amount");
2445     require(editionSupply[editionIndex] >= amount, "Mint exceeds collection size");
2446 
2447     uint64 mintCountBySender = _getAux(_msgSenderERC721A()) + amount;
2448     require(mintCountBySender <= maxMintsPerAddress, "Exceeds per address mint limit");
2449 
2450     require(
2451         MerkleProof.verify(
2452             merkleProof,
2453             allowListMerkleRoot,
2454             keccak256(abi.encodePacked(_msgSenderERC721A()))
2455         ),
2456         "Address not in allowlist"
2457     );
2458 
2459     iconicAddress.transfer(msg.value);
2460     _mint(_msgSenderERC721A(), amount);
2461     _editionUpdate(amount, editionIndex);
2462     _setAux(_msgSenderERC721A(), mintCountBySender);
2463   }
2464 
2465   function mint(uint16 amount, uint16 editionIndex) external payable nonReentrant() {
2466     require(mintingActive, "Minting not enabled");
2467     require(msg.value == mintPrice * amount, "Incorrect amount of ether sent");
2468     require(amount > 0, "Must mint positive amount");
2469     require(editionSupply[editionIndex] >= amount, "Mint exceeds collection size");
2470 
2471     uint64 mintCountBySender = _getAux(_msgSenderERC721A()) + amount;
2472     require(mintCountBySender <= maxMintsPerAddress, "Exceeds per address mint limit");
2473 
2474     iconicAddress.transfer(msg.value);
2475     _mint(_msgSenderERC721A(), amount);
2476     _editionUpdate(amount, editionIndex);
2477     _setAux(_msgSenderERC721A(), mintCountBySender);
2478   }
2479 
2480   function burn(uint256 tokenId) public {
2481     require(burningActive, "Token burning is not enabled");
2482     _burn(tokenId, true);
2483   }
2484 
2485   function _editionUpdate(uint16 amount, uint16 editionIndex) internal {
2486     editionSupply[editionIndex] = editionSupply[editionIndex] - amount;
2487 
2488     //this function takes place post mint, so the tokenIds have already been incremented to match the amount
2489     for(uint tokenId=_nextTokenId() - amount; tokenId < _nextTokenId(); tokenId++) {
2490       tokenToEdition[tokenId] = editionIndex;
2491     }
2492   }
2493 
2494   function _startTokenId() internal pure override returns (uint256) {
2495     return 1;
2496   }
2497 
2498   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2499     require(_exists(tokenId), "Token does not exist");
2500     uint uriIndex = useEditionForURI ? tokenToEdition[tokenId] : tokenId;
2501     return string(abi.encodePacked(baseURI, Strings.toString(uriIndex)));
2502   }
2503 
2504   modifier requiresAdmin() {
2505     require(_msgSenderERC721A() == admin, "Not Authorized");
2506    _;
2507   }
2508 
2509   /* Operator Filter Registry Overrides */
2510   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2511     super.setApprovalForAll(operator, approved);
2512   }
2513 
2514   function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2515     super.approve(operator, tokenId);
2516   }
2517 
2518   function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2519     super.transferFrom(from, to, tokenId);
2520   }
2521 
2522   function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2523     super.safeTransferFrom(from, to, tokenId);
2524   }
2525 
2526   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2527     public
2528     payable
2529     override
2530     onlyAllowedOperator(from)
2531   {
2532     super.safeTransferFrom(from, to, tokenId, data);
2533   }
2534 }