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
227 // File: @openzeppelin/contracts/utils/Context.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes calldata) {
250         return msg.data;
251     }
252 }
253 
254 // File: @openzeppelin/contracts/access/Ownable.sol
255 
256 
257 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 
262 /**
263  * @dev Contract module which provides a basic access control mechanism, where
264  * there is an account (an owner) that can be granted exclusive access to
265  * specific functions.
266  *
267  * By default, the owner account will be the one that deploys the contract. This
268  * can later be changed with {transferOwnership}.
269  *
270  * This module is used through inheritance. It will make available the modifier
271  * `onlyOwner`, which can be applied to your functions to restrict their use to
272  * the owner.
273  */
274 abstract contract Ownable is Context {
275     address private _owner;
276 
277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
278 
279     /**
280      * @dev Initializes the contract setting the deployer as the initial owner.
281      */
282     constructor() {
283         _transferOwnership(_msgSender());
284     }
285 
286     /**
287      * @dev Throws if called by any account other than the owner.
288      */
289     modifier onlyOwner() {
290         _checkOwner();
291         _;
292     }
293 
294     /**
295      * @dev Returns the address of the current owner.
296      */
297     function owner() public view virtual returns (address) {
298         return _owner;
299     }
300 
301     /**
302      * @dev Throws if the sender is not the owner.
303      */
304     function _checkOwner() internal view virtual {
305         require(owner() == _msgSender(), "Ownable: caller is not the owner");
306     }
307 
308     /**
309      * @dev Leaves the contract without owner. It will not be possible to call
310      * `onlyOwner` functions anymore. Can only be called by the current owner.
311      *
312      * NOTE: Renouncing ownership will leave the contract without an owner,
313      * thereby removing any functionality that is only available to the owner.
314      */
315     function renounceOwnership() public virtual onlyOwner {
316         _transferOwnership(address(0));
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      * Can only be called by the current owner.
322      */
323     function transferOwnership(address newOwner) public virtual onlyOwner {
324         require(newOwner != address(0), "Ownable: new owner is the zero address");
325         _transferOwnership(newOwner);
326     }
327 
328     /**
329      * @dev Transfers ownership of the contract to a new account (`newOwner`).
330      * Internal function without access restriction.
331      */
332     function _transferOwnership(address newOwner) internal virtual {
333         address oldOwner = _owner;
334         _owner = newOwner;
335         emit OwnershipTransferred(oldOwner, newOwner);
336     }
337 }
338 
339 // File: @openzeppelin/contracts/utils/math/Math.sol
340 
341 
342 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Standard math utilities missing in the Solidity language.
348  */
349 library Math {
350     enum Rounding {
351         Down, // Toward negative infinity
352         Up, // Toward infinity
353         Zero // Toward zero
354     }
355 
356     /**
357      * @dev Returns the largest of two numbers.
358      */
359     function max(uint256 a, uint256 b) internal pure returns (uint256) {
360         return a > b ? a : b;
361     }
362 
363     /**
364      * @dev Returns the smallest of two numbers.
365      */
366     function min(uint256 a, uint256 b) internal pure returns (uint256) {
367         return a < b ? a : b;
368     }
369 
370     /**
371      * @dev Returns the average of two numbers. The result is rounded towards
372      * zero.
373      */
374     function average(uint256 a, uint256 b) internal pure returns (uint256) {
375         // (a + b) / 2 can overflow.
376         return (a & b) + (a ^ b) / 2;
377     }
378 
379     /**
380      * @dev Returns the ceiling of the division of two numbers.
381      *
382      * This differs from standard division with `/` in that it rounds up instead
383      * of rounding down.
384      */
385     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
386         // (a + b - 1) / b can overflow on addition, so we distribute.
387         return a == 0 ? 0 : (a - 1) / b + 1;
388     }
389 
390     /**
391      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
392      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
393      * with further edits by Uniswap Labs also under MIT license.
394      */
395     function mulDiv(
396         uint256 x,
397         uint256 y,
398         uint256 denominator
399     ) internal pure returns (uint256 result) {
400         unchecked {
401             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
402             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
403             // variables such that product = prod1 * 2^256 + prod0.
404             uint256 prod0; // Least significant 256 bits of the product
405             uint256 prod1; // Most significant 256 bits of the product
406             assembly {
407                 let mm := mulmod(x, y, not(0))
408                 prod0 := mul(x, y)
409                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
410             }
411 
412             // Handle non-overflow cases, 256 by 256 division.
413             if (prod1 == 0) {
414                 return prod0 / denominator;
415             }
416 
417             // Make sure the result is less than 2^256. Also prevents denominator == 0.
418             require(denominator > prod1);
419 
420             ///////////////////////////////////////////////
421             // 512 by 256 division.
422             ///////////////////////////////////////////////
423 
424             // Make division exact by subtracting the remainder from [prod1 prod0].
425             uint256 remainder;
426             assembly {
427                 // Compute remainder using mulmod.
428                 remainder := mulmod(x, y, denominator)
429 
430                 // Subtract 256 bit number from 512 bit number.
431                 prod1 := sub(prod1, gt(remainder, prod0))
432                 prod0 := sub(prod0, remainder)
433             }
434 
435             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
436             // See https://cs.stackexchange.com/q/138556/92363.
437 
438             // Does not overflow because the denominator cannot be zero at this stage in the function.
439             uint256 twos = denominator & (~denominator + 1);
440             assembly {
441                 // Divide denominator by twos.
442                 denominator := div(denominator, twos)
443 
444                 // Divide [prod1 prod0] by twos.
445                 prod0 := div(prod0, twos)
446 
447                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
448                 twos := add(div(sub(0, twos), twos), 1)
449             }
450 
451             // Shift in bits from prod1 into prod0.
452             prod0 |= prod1 * twos;
453 
454             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
455             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
456             // four bits. That is, denominator * inv = 1 mod 2^4.
457             uint256 inverse = (3 * denominator) ^ 2;
458 
459             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
460             // in modular arithmetic, doubling the correct bits in each step.
461             inverse *= 2 - denominator * inverse; // inverse mod 2^8
462             inverse *= 2 - denominator * inverse; // inverse mod 2^16
463             inverse *= 2 - denominator * inverse; // inverse mod 2^32
464             inverse *= 2 - denominator * inverse; // inverse mod 2^64
465             inverse *= 2 - denominator * inverse; // inverse mod 2^128
466             inverse *= 2 - denominator * inverse; // inverse mod 2^256
467 
468             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
469             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
470             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
471             // is no longer required.
472             result = prod0 * inverse;
473             return result;
474         }
475     }
476 
477     /**
478      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
479      */
480     function mulDiv(
481         uint256 x,
482         uint256 y,
483         uint256 denominator,
484         Rounding rounding
485     ) internal pure returns (uint256) {
486         uint256 result = mulDiv(x, y, denominator);
487         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
488             result += 1;
489         }
490         return result;
491     }
492 
493     /**
494      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
495      *
496      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
497      */
498     function sqrt(uint256 a) internal pure returns (uint256) {
499         if (a == 0) {
500             return 0;
501         }
502 
503         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
504         //
505         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
506         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
507         //
508         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
509         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
510         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
511         //
512         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
513         uint256 result = 1 << (log2(a) >> 1);
514 
515         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
516         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
517         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
518         // into the expected uint128 result.
519         unchecked {
520             result = (result + a / result) >> 1;
521             result = (result + a / result) >> 1;
522             result = (result + a / result) >> 1;
523             result = (result + a / result) >> 1;
524             result = (result + a / result) >> 1;
525             result = (result + a / result) >> 1;
526             result = (result + a / result) >> 1;
527             return min(result, a / result);
528         }
529     }
530 
531     /**
532      * @notice Calculates sqrt(a), following the selected rounding direction.
533      */
534     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
535         unchecked {
536             uint256 result = sqrt(a);
537             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
538         }
539     }
540 
541     /**
542      * @dev Return the log in base 2, rounded down, of a positive value.
543      * Returns 0 if given 0.
544      */
545     function log2(uint256 value) internal pure returns (uint256) {
546         uint256 result = 0;
547         unchecked {
548             if (value >> 128 > 0) {
549                 value >>= 128;
550                 result += 128;
551             }
552             if (value >> 64 > 0) {
553                 value >>= 64;
554                 result += 64;
555             }
556             if (value >> 32 > 0) {
557                 value >>= 32;
558                 result += 32;
559             }
560             if (value >> 16 > 0) {
561                 value >>= 16;
562                 result += 16;
563             }
564             if (value >> 8 > 0) {
565                 value >>= 8;
566                 result += 8;
567             }
568             if (value >> 4 > 0) {
569                 value >>= 4;
570                 result += 4;
571             }
572             if (value >> 2 > 0) {
573                 value >>= 2;
574                 result += 2;
575             }
576             if (value >> 1 > 0) {
577                 result += 1;
578             }
579         }
580         return result;
581     }
582 
583     /**
584      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
585      * Returns 0 if given 0.
586      */
587     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
588         unchecked {
589             uint256 result = log2(value);
590             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
591         }
592     }
593 
594     /**
595      * @dev Return the log in base 10, rounded down, of a positive value.
596      * Returns 0 if given 0.
597      */
598     function log10(uint256 value) internal pure returns (uint256) {
599         uint256 result = 0;
600         unchecked {
601             if (value >= 10**64) {
602                 value /= 10**64;
603                 result += 64;
604             }
605             if (value >= 10**32) {
606                 value /= 10**32;
607                 result += 32;
608             }
609             if (value >= 10**16) {
610                 value /= 10**16;
611                 result += 16;
612             }
613             if (value >= 10**8) {
614                 value /= 10**8;
615                 result += 8;
616             }
617             if (value >= 10**4) {
618                 value /= 10**4;
619                 result += 4;
620             }
621             if (value >= 10**2) {
622                 value /= 10**2;
623                 result += 2;
624             }
625             if (value >= 10**1) {
626                 result += 1;
627             }
628         }
629         return result;
630     }
631 
632     /**
633      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
634      * Returns 0 if given 0.
635      */
636     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
637         unchecked {
638             uint256 result = log10(value);
639             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
640         }
641     }
642 
643     /**
644      * @dev Return the log in base 256, rounded down, of a positive value.
645      * Returns 0 if given 0.
646      *
647      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
648      */
649     function log256(uint256 value) internal pure returns (uint256) {
650         uint256 result = 0;
651         unchecked {
652             if (value >> 128 > 0) {
653                 value >>= 128;
654                 result += 16;
655             }
656             if (value >> 64 > 0) {
657                 value >>= 64;
658                 result += 8;
659             }
660             if (value >> 32 > 0) {
661                 value >>= 32;
662                 result += 4;
663             }
664             if (value >> 16 > 0) {
665                 value >>= 16;
666                 result += 2;
667             }
668             if (value >> 8 > 0) {
669                 result += 1;
670             }
671         }
672         return result;
673     }
674 
675     /**
676      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
677      * Returns 0 if given 0.
678      */
679     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
680         unchecked {
681             uint256 result = log256(value);
682             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
683         }
684     }
685 }
686 
687 // File: @openzeppelin/contracts/utils/Strings.sol
688 
689 
690 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 /**
696  * @dev String operations.
697  */
698 library Strings {
699     bytes16 private constant _SYMBOLS = "0123456789abcdef";
700     uint8 private constant _ADDRESS_LENGTH = 20;
701 
702     /**
703      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
704      */
705     function toString(uint256 value) internal pure returns (string memory) {
706         unchecked {
707             uint256 length = Math.log10(value) + 1;
708             string memory buffer = new string(length);
709             uint256 ptr;
710             /// @solidity memory-safe-assembly
711             assembly {
712                 ptr := add(buffer, add(32, length))
713             }
714             while (true) {
715                 ptr--;
716                 /// @solidity memory-safe-assembly
717                 assembly {
718                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
719                 }
720                 value /= 10;
721                 if (value == 0) break;
722             }
723             return buffer;
724         }
725     }
726 
727     /**
728      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
729      */
730     function toHexString(uint256 value) internal pure returns (string memory) {
731         unchecked {
732             return toHexString(value, Math.log256(value) + 1);
733         }
734     }
735 
736     /**
737      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
738      */
739     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
740         bytes memory buffer = new bytes(2 * length + 2);
741         buffer[0] = "0";
742         buffer[1] = "x";
743         for (uint256 i = 2 * length + 1; i > 1; --i) {
744             buffer[i] = _SYMBOLS[value & 0xf];
745             value >>= 4;
746         }
747         require(value == 0, "Strings: hex length insufficient");
748         return string(buffer);
749     }
750 
751     /**
752      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
753      */
754     function toHexString(address addr) internal pure returns (string memory) {
755         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
756     }
757 }
758 
759 // File: https://github.com/distractedm1nd/solmate/blob/main/src/tokens/ERC721.sol
760 
761 
762 pragma solidity >=0.8.0;
763 
764 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
765 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
766 /// @dev Note that balanceOf does not revert if passed the zero address, in defiance of the ERC.
767 abstract contract ERC721 {
768     /*///////////////////////////////////////////////////////////////
769                                  EVENTS
770     //////////////////////////////////////////////////////////////*/
771 
772     event Transfer(address indexed from, address indexed to, uint256 indexed id);
773 
774     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
775 
776     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
777 
778     /*///////////////////////////////////////////////////////////////
779                           METADATA STORAGE/LOGIC
780     //////////////////////////////////////////////////////////////*/
781 
782     string public name;
783 
784     string public symbol;
785 
786     function tokenURI(uint256 id) public view virtual returns (string memory);
787 
788     /*///////////////////////////////////////////////////////////////
789                             ERC721 STORAGE                        
790     //////////////////////////////////////////////////////////////*/
791 
792     uint256 public totalSupply;
793 
794     mapping(address => uint256) public balanceOf;
795 
796     mapping(uint256 => address) public ownerOf;
797 
798     mapping(uint256 => address) public getApproved;
799 
800     mapping(address => mapping(address => bool)) public isApprovedForAll;
801 
802     /*///////////////////////////////////////////////////////////////
803                               CONSTRUCTOR
804     //////////////////////////////////////////////////////////////*/
805 
806     constructor(string memory _name, string memory _symbol) {
807         name = _name;
808         symbol = _symbol;
809     }
810 
811     /*///////////////////////////////////////////////////////////////
812                               ERC721 LOGIC
813     //////////////////////////////////////////////////////////////*/
814 
815     function approve(address spender, uint256 id) public virtual {
816         address owner = ownerOf[id];
817 
818         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
819 
820         getApproved[id] = spender;
821 
822         emit Approval(owner, spender, id);
823     }
824 
825     function setApprovalForAll(address operator, bool approved) public virtual {
826         isApprovedForAll[msg.sender][operator] = approved;
827 
828         emit ApprovalForAll(msg.sender, operator, approved);
829     }
830 
831     function transferFrom(
832         address from,
833         address to,
834         uint256 id
835     ) public virtual {
836         require(from == ownerOf[id], "WRONG_FROM");
837 
838         require(to != address(0), "INVALID_RECIPIENT");
839 
840         require(
841             msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender],
842             "NOT_AUTHORIZED"
843         );
844 
845         // Underflow of the sender's balance is impossible because we check for
846         // ownership above and the recipient's balance can't realistically overflow.
847         unchecked {
848             balanceOf[from]--;
849 
850             balanceOf[to]++;
851         }
852 
853         ownerOf[id] = to;
854 
855         delete getApproved[id];
856 
857         emit Transfer(from, to, id);
858     }
859 
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 id
864     ) public virtual {
865         transferFrom(from, to, id);
866 
867         require(
868             to.code.length == 0 ||
869                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
870                 ERC721TokenReceiver.onERC721Received.selector,
871             "UNSAFE_RECIPIENT"
872         );
873     }
874 
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 id,
879         bytes memory data
880     ) public virtual {
881         transferFrom(from, to, id);
882 
883         require(
884             to.code.length == 0 ||
885                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
886                 ERC721TokenReceiver.onERC721Received.selector,
887             "UNSAFE_RECIPIENT"
888         );
889     }
890 
891     /*///////////////////////////////////////////////////////////////
892                               ERC165 LOGIC
893     //////////////////////////////////////////////////////////////*/
894 
895     function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
896         return
897             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
898             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
899             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
900     }
901 
902     /*///////////////////////////////////////////////////////////////
903                        INTERNAL MINT/BURN LOGIC
904     //////////////////////////////////////////////////////////////*/
905 
906     function _mint(address to, uint256 id) internal virtual {
907         require(to != address(0), "INVALID_RECIPIENT");
908 
909         require(ownerOf[id] == address(0), "ALREADY_MINTED");
910 
911         // Counter overflow is incredibly unrealistic.
912         unchecked {
913             totalSupply++;
914 
915             balanceOf[to]++;
916         }
917 
918         ownerOf[id] = to;
919 
920         emit Transfer(address(0), to, id);
921     }
922 
923     function _burn(uint256 id) internal virtual {
924         address owner = ownerOf[id];
925 
926         require(ownerOf[id] != address(0), "NOT_MINTED");
927 
928         // Ownership check above ensures no underflow.
929         unchecked {
930             totalSupply--;
931 
932             balanceOf[owner]--;
933         }
934 
935         delete ownerOf[id];
936 
937         delete getApproved[id];
938 
939         emit Transfer(owner, address(0), id);
940     }
941 
942     /*///////////////////////////////////////////////////////////////
943                        INTERNAL SAFE MINT LOGIC
944     //////////////////////////////////////////////////////////////*/
945 
946     function _safeMint(address to, uint256 id) internal virtual {
947         _mint(to, id);
948 
949         require(
950             to.code.length == 0 ||
951                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
952                 ERC721TokenReceiver.onERC721Received.selector,
953             "UNSAFE_RECIPIENT"
954         );
955     }
956 
957     function _safeMint(
958         address to,
959         uint256 id,
960         bytes memory data
961     ) internal virtual {
962         _mint(to, id);
963 
964         require(
965             to.code.length == 0 ||
966                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
967                 ERC721TokenReceiver.onERC721Received.selector,
968             "UNSAFE_RECIPIENT"
969         );
970     }
971 }
972 
973 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
974 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC721.sol)
975 interface ERC721TokenReceiver {
976     function onERC721Received(
977         address operator,
978         address from,
979         uint256 id,
980         bytes calldata data
981     ) external returns (bytes4);
982 }
983 
984 // File: AIB.sol
985 
986 
987 pragma solidity ^0.8.7;
988 
989 
990 
991 
992 
993 contract AnimeInBox is ERC721, Ownable {
994 
995     address public receivingAddress = 0xE2bD4329cC72896862E78dd590202d6066eb63e6;
996     using Strings for uint256;
997 
998     constructor() ERC721("AnimeInBox","AIB") {
999         unchecked {
1000         balanceOf[receivingAddress] += 90;
1001         totalSupply += 90;
1002         for (uint256 i = 0; i < 90; i++) {
1003         ownerOf[i] = receivingAddress;
1004         emit Transfer(address(0), receivingAddress, i);
1005         }}
1006     }
1007 
1008     mapping(address => uint256) public amountMinted;
1009     uint256 public maxMintAmount = 10;
1010     uint256 public maxSupply = 1500;
1011 
1012     bytes32 public merkleRoot;
1013 
1014     uint256 public wlPrice = 0.02 ether;
1015     uint256 public publicPrice = 0.03 ether;
1016     
1017     string public baseURI;
1018 
1019     enum MintStatus { PAUSED, WLMINT, PUBLIC }
1020     MintStatus public theStatus;
1021 
1022     function setWLMintPrice(uint256 _price) public onlyOwner {
1023         wlPrice = _price;
1024     }
1025 
1026     function setPublicMintPrice(uint256 _price) public onlyOwner {
1027         publicPrice = _price;
1028     }
1029 
1030     function changeStatus(uint _status) public onlyOwner {
1031         if      (_status == 0) { theStatus = MintStatus.PAUSED; }
1032         else if (_status == 1) { theStatus = MintStatus.WLMINT; }
1033         else if (_status == 2) { theStatus = MintStatus.PUBLIC; }
1034     }
1035 
1036     function publicMint(uint256 amount) external payable {
1037         
1038         require(theStatus == MintStatus.PUBLIC, "Not the Public Phase yet");
1039         require(amount > 0, "Unable to mint 0 NFTs");
1040         require (amount <= maxMintAmount, "You are unable to mint this amount of NFTs");
1041         require(msg.value >= amount * publicPrice, "Not enough Ether");
1042         require (totalSupply + amount <= maxSupply, "Minted out supply");
1043         require(msg.sender == tx.origin, "Bot prevention");
1044         require(amountMinted[msg.sender] + amount <= maxMintAmount, "You are unable to mint this many NFTs");
1045 
1046         amountMinted[msg.sender] += amount;
1047         uint currentId = totalSupply;
1048 
1049         totalSupply += amount;
1050         balanceOf[msg.sender] += amount;
1051         unchecked {
1052             for (uint256 ii = 0; ii < amount; ii++) {
1053                 ownerOf[currentId + ii] = msg.sender; 
1054                 emit Transfer(address(0), msg.sender, currentId + ii);
1055             }
1056         }
1057     }
1058 
1059     function whitelistMint(bytes32[] calldata _merkleProof , uint256 amount) external payable {
1060         
1061         require(theStatus == MintStatus.WLMINT, "Not the Whitelist Phase yet");
1062         require(amount > 0, "Unable to mint 0 NFTs");
1063         require (amount <= maxMintAmount, "You are unable to mint this amount of NFTs");
1064         require(msg.value >= amount * wlPrice, "Not enough Ether");
1065         require (totalSupply + amount <= maxSupply, "Minted out supply");
1066         require(msg.sender == tx.origin, "Bot prevention");
1067         require(amountMinted[msg.sender] + amount <= maxMintAmount, "You are unable to mint this many NFTs");
1068         
1069         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1070         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not whitelisted");
1071 
1072         amountMinted[msg.sender] += amount;
1073         uint currentId = totalSupply;
1074 
1075         totalSupply += amount;
1076         balanceOf[msg.sender] += amount;
1077         unchecked { 
1078             for (uint256 ii = 0; ii < amount; ii++) {
1079                 ownerOf[currentId + ii] = msg.sender; 
1080                 emit Transfer(address(0), msg.sender, currentId + ii);
1081             }
1082         }
1083     }
1084 
1085     function tokenURI(uint256 id) public view override virtual returns (string memory) {
1086         return string(abi.encodePacked(baseURI, id.toString()));
1087     }
1088 
1089     function setBaseURI(string memory _baseURI) public onlyOwner {
1090         baseURI = _baseURI;
1091     }
1092 
1093     function changeReceivingAddress(address _receivingAddress) public onlyOwner {
1094         receivingAddress = _receivingAddress;
1095     }
1096     
1097     function airdrop(address sendTo) public onlyOwner {
1098         require(totalSupply < maxSupply, "Can't airdrop");
1099         _mint(sendTo, totalSupply);
1100     }
1101     
1102     function withdraw() public onlyOwner {
1103         (bool success, ) = payable(receivingAddress).call{value: address(this).balance}("");
1104         require(success, "Failed withdrawal.");
1105     }
1106 
1107     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1108         merkleRoot = _merkleRoot;
1109     }
1110 }