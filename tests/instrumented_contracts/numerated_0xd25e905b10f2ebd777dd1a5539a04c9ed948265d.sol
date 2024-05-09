1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
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
80      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
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
97      * _Available since v4.7._
98      */
99     function multiProofVerifyCalldata(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32 root,
103         bytes32[] memory leaves
104     ) internal pure returns (bool) {
105         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
106     }
107 
108     /**
109      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
110      * consuming from one or the other at each step according to the instructions given by
111      * `proofFlags`.
112      *
113      * _Available since v4.7._
114      */
115     function processMultiProof(
116         bytes32[] memory proof,
117         bool[] memory proofFlags,
118         bytes32[] memory leaves
119     ) internal pure returns (bytes32 merkleRoot) {
120         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
121         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
122         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
123         // the merkle tree.
124         uint256 leavesLen = leaves.length;
125         uint256 totalHashes = proofFlags.length;
126 
127         // Check proof validity.
128         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
129 
130         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
131         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
132         bytes32[] memory hashes = new bytes32[](totalHashes);
133         uint256 leafPos = 0;
134         uint256 hashPos = 0;
135         uint256 proofPos = 0;
136         // At each step, we compute the next hash using two values:
137         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
138         //   get the next hash.
139         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
140         //   `proof` array.
141         for (uint256 i = 0; i < totalHashes; i++) {
142             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
143             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
144             hashes[i] = _hashPair(a, b);
145         }
146 
147         if (totalHashes > 0) {
148             return hashes[totalHashes - 1];
149         } else if (leavesLen > 0) {
150             return leaves[0];
151         } else {
152             return proof[0];
153         }
154     }
155 
156     /**
157      * @dev Calldata version of {processMultiProof}
158      *
159      * _Available since v4.7._
160      */
161     function processMultiProofCalldata(
162         bytes32[] calldata proof,
163         bool[] calldata proofFlags,
164         bytes32[] memory leaves
165     ) internal pure returns (bytes32 merkleRoot) {
166         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
167         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
168         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
169         // the merkle tree.
170         uint256 leavesLen = leaves.length;
171         uint256 totalHashes = proofFlags.length;
172 
173         // Check proof validity.
174         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
175 
176         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
177         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
178         bytes32[] memory hashes = new bytes32[](totalHashes);
179         uint256 leafPos = 0;
180         uint256 hashPos = 0;
181         uint256 proofPos = 0;
182         // At each step, we compute the next hash using two values:
183         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
184         //   get the next hash.
185         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
186         //   `proof` array.
187         for (uint256 i = 0; i < totalHashes; i++) {
188             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
189             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
190             hashes[i] = _hashPair(a, b);
191         }
192 
193         if (totalHashes > 0) {
194             return hashes[totalHashes - 1];
195         } else if (leavesLen > 0) {
196             return leaves[0];
197         } else {
198             return proof[0];
199         }
200     }
201 
202     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
203         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
204     }
205 
206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
207         /// @solidity memory-safe-assembly
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/Strings.sol
217 
218 
219 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev String operations.
225  */
226 library Strings {
227     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
228     uint8 private constant _ADDRESS_LENGTH = 20;
229 
230     /**
231      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
232      */
233     function toString(uint256 value) internal pure returns (string memory) {
234         // Inspired by OraclizeAPI's implementation - MIT licence
235         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
236 
237         if (value == 0) {
238             return "0";
239         }
240         uint256 temp = value;
241         uint256 digits;
242         while (temp != 0) {
243             digits++;
244             temp /= 10;
245         }
246         bytes memory buffer = new bytes(digits);
247         while (value != 0) {
248             digits -= 1;
249             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
250             value /= 10;
251         }
252         return string(buffer);
253     }
254 
255     /**
256      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
257      */
258     function toHexString(uint256 value) internal pure returns (string memory) {
259         if (value == 0) {
260             return "0x00";
261         }
262         uint256 temp = value;
263         uint256 length = 0;
264         while (temp != 0) {
265             length++;
266             temp >>= 8;
267         }
268         return toHexString(value, length);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
273      */
274     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
275         bytes memory buffer = new bytes(2 * length + 2);
276         buffer[0] = "0";
277         buffer[1] = "x";
278         for (uint256 i = 2 * length + 1; i > 1; --i) {
279             buffer[i] = _HEX_SYMBOLS[value & 0xf];
280             value >>= 4;
281         }
282         require(value == 0, "Strings: hex length insufficient");
283         return string(buffer);
284     }
285 
286     /**
287      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
288      */
289     function toHexString(address addr) internal pure returns (string memory) {
290         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/math/Math.sol
295 
296 
297 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Standard math utilities missing in the Solidity language.
303  */
304 library Math {
305     enum Rounding {
306         Down, // Toward negative infinity
307         Up, // Toward infinity
308         Zero // Toward zero
309     }
310 
311     /**
312      * @dev Returns the largest of two numbers.
313      */
314     function max(uint256 a, uint256 b) internal pure returns (uint256) {
315         return a >= b ? a : b;
316     }
317 
318     /**
319      * @dev Returns the smallest of two numbers.
320      */
321     function min(uint256 a, uint256 b) internal pure returns (uint256) {
322         return a < b ? a : b;
323     }
324 
325     /**
326      * @dev Returns the average of two numbers. The result is rounded towards
327      * zero.
328      */
329     function average(uint256 a, uint256 b) internal pure returns (uint256) {
330         // (a + b) / 2 can overflow.
331         return (a & b) + (a ^ b) / 2;
332     }
333 
334     /**
335      * @dev Returns the ceiling of the division of two numbers.
336      *
337      * This differs from standard division with `/` in that it rounds up instead
338      * of rounding down.
339      */
340     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
341         // (a + b - 1) / b can overflow on addition, so we distribute.
342         return a == 0 ? 0 : (a - 1) / b + 1;
343     }
344 
345     /**
346      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
347      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
348      * with further edits by Uniswap Labs also under MIT license.
349      */
350     function mulDiv(
351         uint256 x,
352         uint256 y,
353         uint256 denominator
354     ) internal pure returns (uint256 result) {
355         unchecked {
356             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
357             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
358             // variables such that product = prod1 * 2^256 + prod0.
359             uint256 prod0; // Least significant 256 bits of the product
360             uint256 prod1; // Most significant 256 bits of the product
361             assembly {
362                 let mm := mulmod(x, y, not(0))
363                 prod0 := mul(x, y)
364                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
365             }
366 
367             // Handle non-overflow cases, 256 by 256 division.
368             if (prod1 == 0) {
369                 return prod0 / denominator;
370             }
371 
372             // Make sure the result is less than 2^256. Also prevents denominator == 0.
373             require(denominator > prod1);
374 
375             ///////////////////////////////////////////////
376             // 512 by 256 division.
377             ///////////////////////////////////////////////
378 
379             // Make division exact by subtracting the remainder from [prod1 prod0].
380             uint256 remainder;
381             assembly {
382                 // Compute remainder using mulmod.
383                 remainder := mulmod(x, y, denominator)
384 
385                 // Subtract 256 bit number from 512 bit number.
386                 prod1 := sub(prod1, gt(remainder, prod0))
387                 prod0 := sub(prod0, remainder)
388             }
389 
390             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
391             // See https://cs.stackexchange.com/q/138556/92363.
392 
393             // Does not overflow because the denominator cannot be zero at this stage in the function.
394             uint256 twos = denominator & (~denominator + 1);
395             assembly {
396                 // Divide denominator by twos.
397                 denominator := div(denominator, twos)
398 
399                 // Divide [prod1 prod0] by twos.
400                 prod0 := div(prod0, twos)
401 
402                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
403                 twos := add(div(sub(0, twos), twos), 1)
404             }
405 
406             // Shift in bits from prod1 into prod0.
407             prod0 |= prod1 * twos;
408 
409             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
410             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
411             // four bits. That is, denominator * inv = 1 mod 2^4.
412             uint256 inverse = (3 * denominator) ^ 2;
413 
414             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
415             // in modular arithmetic, doubling the correct bits in each step.
416             inverse *= 2 - denominator * inverse; // inverse mod 2^8
417             inverse *= 2 - denominator * inverse; // inverse mod 2^16
418             inverse *= 2 - denominator * inverse; // inverse mod 2^32
419             inverse *= 2 - denominator * inverse; // inverse mod 2^64
420             inverse *= 2 - denominator * inverse; // inverse mod 2^128
421             inverse *= 2 - denominator * inverse; // inverse mod 2^256
422 
423             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
424             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
425             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
426             // is no longer required.
427             result = prod0 * inverse;
428             return result;
429         }
430     }
431 
432     /**
433      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
434      */
435     function mulDiv(
436         uint256 x,
437         uint256 y,
438         uint256 denominator,
439         Rounding rounding
440     ) internal pure returns (uint256) {
441         uint256 result = mulDiv(x, y, denominator);
442         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
443             result += 1;
444         }
445         return result;
446     }
447 
448     /**
449      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
450      *
451      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
452      */
453     function sqrt(uint256 a) internal pure returns (uint256) {
454         if (a == 0) {
455             return 0;
456         }
457 
458         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
459         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
460         // `msb(a) <= a < 2*msb(a)`.
461         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
462         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
463         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
464         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
465         uint256 result = 1;
466         uint256 x = a;
467         if (x >> 128 > 0) {
468             x >>= 128;
469             result <<= 64;
470         }
471         if (x >> 64 > 0) {
472             x >>= 64;
473             result <<= 32;
474         }
475         if (x >> 32 > 0) {
476             x >>= 32;
477             result <<= 16;
478         }
479         if (x >> 16 > 0) {
480             x >>= 16;
481             result <<= 8;
482         }
483         if (x >> 8 > 0) {
484             x >>= 8;
485             result <<= 4;
486         }
487         if (x >> 4 > 0) {
488             x >>= 4;
489             result <<= 2;
490         }
491         if (x >> 2 > 0) {
492             result <<= 1;
493         }
494 
495         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
496         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
497         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
498         // into the expected uint128 result.
499         unchecked {
500             result = (result + a / result) >> 1;
501             result = (result + a / result) >> 1;
502             result = (result + a / result) >> 1;
503             result = (result + a / result) >> 1;
504             result = (result + a / result) >> 1;
505             result = (result + a / result) >> 1;
506             result = (result + a / result) >> 1;
507             return min(result, a / result);
508         }
509     }
510 
511     /**
512      * @notice Calculates sqrt(a), following the selected rounding direction.
513      */
514     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
515         uint256 result = sqrt(a);
516         if (rounding == Rounding.Up && result * result < a) {
517             result += 1;
518         }
519         return result;
520     }
521 }
522 
523 // File: @openzeppelin/contracts/utils/Arrays.sol
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 
531 /**
532  * @dev Collection of functions related to array types.
533  */
534 library Arrays {
535     /**
536      * @dev Searches a sorted `array` and returns the first index that contains
537      * a value greater or equal to `element`. If no such index exists (i.e. all
538      * values in the array are strictly less than `element`), the array length is
539      * returned. Time complexity O(log n).
540      *
541      * `array` is expected to be sorted in ascending order, and to contain no
542      * repeated elements.
543      */
544     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
545         if (array.length == 0) {
546             return 0;
547         }
548 
549         uint256 low = 0;
550         uint256 high = array.length;
551 
552         while (low < high) {
553             uint256 mid = Math.average(low, high);
554 
555             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
556             // because Math.average rounds down (it does integer division with truncation).
557             if (array[mid] > element) {
558                 high = mid;
559             } else {
560                 low = mid + 1;
561             }
562         }
563 
564         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
565         if (low > 0 && array[low - 1] == element) {
566             return low - 1;
567         } else {
568             return low;
569         }
570     }
571 }
572 
573 // File: @openzeppelin/contracts/utils/Context.sol
574 
575 
576 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 /**
581  * @dev Provides information about the current execution context, including the
582  * sender of the transaction and its data. While these are generally available
583  * via msg.sender and msg.data, they should not be accessed in such a direct
584  * manner, since when dealing with meta-transactions the account sending and
585  * paying for execution may not be the actual sender (as far as an application
586  * is concerned).
587  *
588  * This contract is only required for intermediate, library-like contracts.
589  */
590 abstract contract Context {
591     function _msgSender() internal view virtual returns (address) {
592         return msg.sender;
593     }
594 
595     function _msgData() internal view virtual returns (bytes calldata) {
596         return msg.data;
597     }
598 }
599 
600 // File: @openzeppelin/contracts/access/Ownable.sol
601 
602 
603 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 
608 /**
609  * @dev Contract module which provides a basic access control mechanism, where
610  * there is an account (an owner) that can be granted exclusive access to
611  * specific functions.
612  *
613  * By default, the owner account will be the one that deploys the contract. This
614  * can later be changed with {transferOwnership}.
615  *
616  * This module is used through inheritance. It will make available the modifier
617  * `onlyOwner`, which can be applied to your functions to restrict their use to
618  * the owner.
619  */
620 abstract contract Ownable is Context {
621     address private _owner;
622 
623     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
624 
625     /**
626      * @dev Initializes the contract setting the deployer as the initial owner.
627      */
628     constructor() {
629         _transferOwnership(_msgSender());
630     }
631 
632     /**
633      * @dev Throws if called by any account other than the owner.
634      */
635     modifier onlyOwner() {
636         _checkOwner();
637         _;
638     }
639 
640     /**
641      * @dev Returns the address of the current owner.
642      */
643     function owner() public view virtual returns (address) {
644         return _owner;
645     }
646 
647     /**
648      * @dev Throws if the sender is not the owner.
649      */
650     function _checkOwner() internal view virtual {
651         require(owner() == _msgSender(), "Ownable: caller is not the owner");
652     }
653 
654     /**
655      * @dev Leaves the contract without owner. It will not be possible to call
656      * `onlyOwner` functions anymore. Can only be called by the current owner.
657      *
658      * NOTE: Renouncing ownership will leave the contract without an owner,
659      * thereby removing any functionality that is only available to the owner.
660      */
661     function renounceOwnership() public virtual onlyOwner {
662         _transferOwnership(address(0));
663     }
664 
665     /**
666      * @dev Transfers ownership of the contract to a new account (`newOwner`).
667      * Can only be called by the current owner.
668      */
669     function transferOwnership(address newOwner) public virtual onlyOwner {
670         require(newOwner != address(0), "Ownable: new owner is the zero address");
671         _transferOwnership(newOwner);
672     }
673 
674     /**
675      * @dev Transfers ownership of the contract to a new account (`newOwner`).
676      * Internal function without access restriction.
677      */
678     function _transferOwnership(address newOwner) internal virtual {
679         address oldOwner = _owner;
680         _owner = newOwner;
681         emit OwnershipTransferred(oldOwner, newOwner);
682     }
683 }
684 
685 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 /**
693  * @dev Contract module that helps prevent reentrant calls to a function.
694  *
695  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
696  * available, which can be applied to functions to make sure there are no nested
697  * (reentrant) calls to them.
698  *
699  * Note that because there is a single `nonReentrant` guard, functions marked as
700  * `nonReentrant` may not call one another. This can be worked around by making
701  * those functions `private`, and then adding `external` `nonReentrant` entry
702  * points to them.
703  *
704  * TIP: If you would like to learn more about reentrancy and alternative ways
705  * to protect against it, check out our blog post
706  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
707  */
708 abstract contract ReentrancyGuard {
709     // Booleans are more expensive than uint256 or any type that takes up a full
710     // word because each write operation emits an extra SLOAD to first read the
711     // slot's contents, replace the bits taken up by the boolean, and then write
712     // back. This is the compiler's defense against contract upgrades and
713     // pointer aliasing, and it cannot be disabled.
714 
715     // The values being non-zero value makes deployment a bit more expensive,
716     // but in exchange the refund on every call to nonReentrant will be lower in
717     // amount. Since refunds are capped to a percentage of the total
718     // transaction's gas, it is best to keep them low in cases like this one, to
719     // increase the likelihood of the full refund coming into effect.
720     uint256 private constant _NOT_ENTERED = 1;
721     uint256 private constant _ENTERED = 2;
722 
723     uint256 private _status;
724 
725     constructor() {
726         _status = _NOT_ENTERED;
727     }
728 
729     /**
730      * @dev Prevents a contract from calling itself, directly or indirectly.
731      * Calling a `nonReentrant` function from another `nonReentrant`
732      * function is not supported. It is possible to prevent this from happening
733      * by making the `nonReentrant` function external, and making it call a
734      * `private` function that does the actual work.
735      */
736     modifier nonReentrant() {
737         // On the first call to nonReentrant, _notEntered will be true
738         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
739 
740         // Any calls to nonReentrant after this point will fail
741         _status = _ENTERED;
742 
743         _;
744 
745         // By storing the original value once again, a refund is triggered (see
746         // https://eips.ethereum.org/EIPS/eip-2200)
747         _status = _NOT_ENTERED;
748     }
749 }
750 
751 // File: erc721a/contracts/IERC721A.sol
752 
753 
754 // ERC721A Contracts v4.2.0
755 // Creator: Chiru Labs
756 
757 pragma solidity ^0.8.4;
758 
759 /**
760  * @dev Interface of ERC721A.
761  */
762 interface IERC721A {
763     /**
764      * The caller must own the token or be an approved operator.
765      */
766     error ApprovalCallerNotOwnerNorApproved();
767 
768     /**
769      * The token does not exist.
770      */
771     error ApprovalQueryForNonexistentToken();
772 
773     /**
774      * The caller cannot approve to their own address.
775      */
776     error ApproveToCaller();
777 
778     /**
779      * Cannot query the balance for the zero address.
780      */
781     error BalanceQueryForZeroAddress();
782 
783     /**
784      * Cannot mint to the zero address.
785      */
786     error MintToZeroAddress();
787 
788     /**
789      * The quantity of tokens minted must be more than zero.
790      */
791     error MintZeroQuantity();
792 
793     /**
794      * The token does not exist.
795      */
796     error OwnerQueryForNonexistentToken();
797 
798     /**
799      * The caller must own the token or be an approved operator.
800      */
801     error TransferCallerNotOwnerNorApproved();
802 
803     /**
804      * The token must be owned by `from`.
805      */
806     error TransferFromIncorrectOwner();
807 
808     /**
809      * Cannot safely transfer to a contract that does not implement the
810      * ERC721Receiver interface.
811      */
812     error TransferToNonERC721ReceiverImplementer();
813 
814     /**
815      * Cannot transfer to the zero address.
816      */
817     error TransferToZeroAddress();
818 
819     /**
820      * The token does not exist.
821      */
822     error URIQueryForNonexistentToken();
823 
824     /**
825      * The `quantity` minted with ERC2309 exceeds the safety limit.
826      */
827     error MintERC2309QuantityExceedsLimit();
828 
829     /**
830      * The `extraData` cannot be set on an unintialized ownership slot.
831      */
832     error OwnershipNotInitializedForExtraData();
833 
834     // =============================================================
835     //                            STRUCTS
836     // =============================================================
837 
838     struct TokenOwnership {
839         // The address of the owner.
840         address addr;
841         // Stores the start time of ownership with minimal overhead for tokenomics.
842         uint64 startTimestamp;
843         // Whether the token has been burned.
844         bool burned;
845         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
846         uint24 extraData;
847     }
848 
849     // =============================================================
850     //                         TOKEN COUNTERS
851     // =============================================================
852 
853     /**
854      * @dev Returns the total number of tokens in existence.
855      * Burned tokens will reduce the count.
856      * To get the total number of tokens minted, please see {_totalMinted}.
857      */
858     function totalSupply() external view returns (uint256);
859 
860     // =============================================================
861     //                            IERC165
862     // =============================================================
863 
864     /**
865      * @dev Returns true if this contract implements the interface defined by
866      * `interfaceId`. See the corresponding
867      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
868      * to learn more about how these ids are created.
869      *
870      * This function call must use less than 30000 gas.
871      */
872     function supportsInterface(bytes4 interfaceId) external view returns (bool);
873 
874     // =============================================================
875     //                            IERC721
876     // =============================================================
877 
878     /**
879      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
880      */
881     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
882 
883     /**
884      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
885      */
886     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
887 
888     /**
889      * @dev Emitted when `owner` enables or disables
890      * (`approved`) `operator` to manage all of its assets.
891      */
892     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
893 
894     /**
895      * @dev Returns the number of tokens in `owner`'s account.
896      */
897     function balanceOf(address owner) external view returns (uint256 balance);
898 
899     /**
900      * @dev Returns the owner of the `tokenId` token.
901      *
902      * Requirements:
903      *
904      * - `tokenId` must exist.
905      */
906     function ownerOf(uint256 tokenId) external view returns (address owner);
907 
908     /**
909      * @dev Safely transfers `tokenId` token from `from` to `to`,
910      * checking first that contract recipients are aware of the ERC721 protocol
911      * to prevent tokens from being forever locked.
912      *
913      * Requirements:
914      *
915      * - `from` cannot be the zero address.
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must exist and be owned by `from`.
918      * - If the caller is not `from`, it must be have been allowed to move
919      * this token by either {approve} or {setApprovalForAll}.
920      * - If `to` refers to a smart contract, it must implement
921      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
922      *
923      * Emits a {Transfer} event.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId,
929         bytes calldata data
930     ) external;
931 
932     /**
933      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) external;
940 
941     /**
942      * @dev Transfers `tokenId` from `from` to `to`.
943      *
944      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
945      * whenever possible.
946      *
947      * Requirements:
948      *
949      * - `from` cannot be the zero address.
950      * - `to` cannot be the zero address.
951      * - `tokenId` token must be owned by `from`.
952      * - If the caller is not `from`, it must be approved to move this token
953      * by either {approve} or {setApprovalForAll}.
954      *
955      * Emits a {Transfer} event.
956      */
957     function transferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) external;
962 
963     /**
964      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
965      * The approval is cleared when the token is transferred.
966      *
967      * Only a single account can be approved at a time, so approving the
968      * zero address clears previous approvals.
969      *
970      * Requirements:
971      *
972      * - The caller must own the token or be an approved operator.
973      * - `tokenId` must exist.
974      *
975      * Emits an {Approval} event.
976      */
977     function approve(address to, uint256 tokenId) external;
978 
979     /**
980      * @dev Approve or remove `operator` as an operator for the caller.
981      * Operators can call {transferFrom} or {safeTransferFrom}
982      * for any token owned by the caller.
983      *
984      * Requirements:
985      *
986      * - The `operator` cannot be the caller.
987      *
988      * Emits an {ApprovalForAll} event.
989      */
990     function setApprovalForAll(address operator, bool _approved) external;
991 
992     /**
993      * @dev Returns the account approved for `tokenId` token.
994      *
995      * Requirements:
996      *
997      * - `tokenId` must exist.
998      */
999     function getApproved(uint256 tokenId) external view returns (address operator);
1000 
1001     /**
1002      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1003      *
1004      * See {setApprovalForAll}.
1005      */
1006     function isApprovedForAll(address owner, address operator) external view returns (bool);
1007 
1008     // =============================================================
1009     //                        IERC721Metadata
1010     // =============================================================
1011 
1012     /**
1013      * @dev Returns the token collection name.
1014      */
1015     function name() external view returns (string memory);
1016 
1017     /**
1018      * @dev Returns the token collection symbol.
1019      */
1020     function symbol() external view returns (string memory);
1021 
1022     /**
1023      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1024      */
1025     function tokenURI(uint256 tokenId) external view returns (string memory);
1026 
1027     // =============================================================
1028     //                           IERC2309
1029     // =============================================================
1030 
1031     /**
1032      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1033      * (inclusive) is transferred from `from` to `to`, as defined in the
1034      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1035      *
1036      * See {_mintERC2309} for more details.
1037      */
1038     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1039 }
1040 
1041 // File: erc721a/contracts/ERC721A.sol
1042 
1043 
1044 // ERC721A Contracts v4.2.0
1045 // Creator: Chiru Labs
1046 
1047 pragma solidity ^0.8.4;
1048 
1049 
1050 /**
1051  * @dev Interface of ERC721 token receiver.
1052  */
1053 interface ERC721A__IERC721Receiver {
1054     function onERC721Received(
1055         address operator,
1056         address from,
1057         uint256 tokenId,
1058         bytes calldata data
1059     ) external returns (bytes4);
1060 }
1061 
1062 /**
1063  * @title ERC721A
1064  *
1065  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1066  * Non-Fungible Token Standard, including the Metadata extension.
1067  * Optimized for lower gas during batch mints.
1068  *
1069  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1070  * starting from `_startTokenId()`.
1071  *
1072  * Assumptions:
1073  *
1074  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1075  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1076  */
1077 contract ERC721A is IERC721A {
1078     // Reference type for token approval.
1079     struct TokenApprovalRef {
1080         address value;
1081     }
1082 
1083     // =============================================================
1084     //                           CONSTANTS
1085     // =============================================================
1086 
1087     // Mask of an entry in packed address data.
1088     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1089 
1090     // The bit position of `numberMinted` in packed address data.
1091     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1092 
1093     // The bit position of `numberBurned` in packed address data.
1094     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1095 
1096     // The bit position of `aux` in packed address data.
1097     uint256 private constant _BITPOS_AUX = 192;
1098 
1099     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1100     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1101 
1102     // The bit position of `startTimestamp` in packed ownership.
1103     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1104 
1105     // The bit mask of the `burned` bit in packed ownership.
1106     uint256 private constant _BITMASK_BURNED = 1 << 224;
1107 
1108     // The bit position of the `nextInitialized` bit in packed ownership.
1109     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1110 
1111     // The bit mask of the `nextInitialized` bit in packed ownership.
1112     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1113 
1114     // The bit position of `extraData` in packed ownership.
1115     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1116 
1117     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1118     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1119 
1120     // The mask of the lower 160 bits for addresses.
1121     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1122 
1123     // The maximum `quantity` that can be minted with {_mintERC2309}.
1124     // This limit is to prevent overflows on the address data entries.
1125     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1126     // is required to cause an overflow, which is unrealistic.
1127     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1128 
1129     // The `Transfer` event signature is given by:
1130     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1131     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1132         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1133 
1134     // =============================================================
1135     //                            STORAGE
1136     // =============================================================
1137 
1138     // The next token ID to be minted.
1139     uint256 private _currentIndex;
1140 
1141     // The number of tokens burned.
1142     uint256 private _burnCounter;
1143 
1144     // Token name
1145     string private _name;
1146 
1147     // Token symbol
1148     string private _symbol;
1149 
1150     // Mapping from token ID to ownership details
1151     // An empty struct value does not necessarily mean the token is unowned.
1152     // See {_packedOwnershipOf} implementation for details.
1153     //
1154     // Bits Layout:
1155     // - [0..159]   `addr`
1156     // - [160..223] `startTimestamp`
1157     // - [224]      `burned`
1158     // - [225]      `nextInitialized`
1159     // - [232..255] `extraData`
1160     mapping(uint256 => uint256) private _packedOwnerships;
1161 
1162     // Mapping owner address to address data.
1163     //
1164     // Bits Layout:
1165     // - [0..63]    `balance`
1166     // - [64..127]  `numberMinted`
1167     // - [128..191] `numberBurned`
1168     // - [192..255] `aux`
1169     mapping(address => uint256) private _packedAddressData;
1170 
1171     // Mapping from token ID to approved address.
1172     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1173 
1174     // Mapping from owner to operator approvals
1175     mapping(address => mapping(address => bool)) private _operatorApprovals;
1176 
1177     // =============================================================
1178     //                          CONSTRUCTOR
1179     // =============================================================
1180 
1181     constructor(string memory name_, string memory symbol_) {
1182         _name = name_;
1183         _symbol = symbol_;
1184         _currentIndex = _startTokenId();
1185     }
1186 
1187     // =============================================================
1188     //                   TOKEN COUNTING OPERATIONS
1189     // =============================================================
1190 
1191     /**
1192      * @dev Returns the starting token ID.
1193      * To change the starting token ID, please override this function.
1194      */
1195     function _startTokenId() internal view virtual returns (uint256) {
1196         return 0;
1197     }
1198 
1199     /**
1200      * @dev Returns the next token ID to be minted.
1201      */
1202     function _nextTokenId() internal view virtual returns (uint256) {
1203         return _currentIndex;
1204     }
1205 
1206     /**
1207      * @dev Returns the total number of tokens in existence.
1208      * Burned tokens will reduce the count.
1209      * To get the total number of tokens minted, please see {_totalMinted}.
1210      */
1211     function totalSupply() public view virtual override returns (uint256) {
1212         // Counter underflow is impossible as _burnCounter cannot be incremented
1213         // more than `_currentIndex - _startTokenId()` times.
1214         unchecked {
1215             return _currentIndex - _burnCounter - _startTokenId();
1216         }
1217     }
1218 
1219     /**
1220      * @dev Returns the total amount of tokens minted in the contract.
1221      */
1222     function _totalMinted() internal view virtual returns (uint256) {
1223         // Counter underflow is impossible as `_currentIndex` does not decrement,
1224         // and it is initialized to `_startTokenId()`.
1225         unchecked {
1226             return _currentIndex - _startTokenId();
1227         }
1228     }
1229 
1230     /**
1231      * @dev Returns the total number of tokens burned.
1232      */
1233     function _totalBurned() internal view virtual returns (uint256) {
1234         return _burnCounter;
1235     }
1236 
1237     // =============================================================
1238     //                    ADDRESS DATA OPERATIONS
1239     // =============================================================
1240 
1241     /**
1242      * @dev Returns the number of tokens in `owner`'s account.
1243      */
1244     function balanceOf(address owner) public view virtual override returns (uint256) {
1245         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1246         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1247     }
1248 
1249     /**
1250      * Returns the number of tokens minted by `owner`.
1251      */
1252     function _numberMinted(address owner) internal view returns (uint256) {
1253         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1254     }
1255 
1256     /**
1257      * Returns the number of tokens burned by or on behalf of `owner`.
1258      */
1259     function _numberBurned(address owner) internal view returns (uint256) {
1260         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1261     }
1262 
1263     /**
1264      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1265      */
1266     function _getAux(address owner) internal view returns (uint64) {
1267         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1268     }
1269 
1270     /**
1271      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1272      * If there are multiple variables, please pack them into a uint64.
1273      */
1274     function _setAux(address owner, uint64 aux) internal virtual {
1275         uint256 packed = _packedAddressData[owner];
1276         uint256 auxCasted;
1277         // Cast `aux` with assembly to avoid redundant masking.
1278         assembly {
1279             auxCasted := aux
1280         }
1281         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1282         _packedAddressData[owner] = packed;
1283     }
1284 
1285     // =============================================================
1286     //                            IERC165
1287     // =============================================================
1288 
1289     /**
1290      * @dev Returns true if this contract implements the interface defined by
1291      * `interfaceId`. See the corresponding
1292      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1293      * to learn more about how these ids are created.
1294      *
1295      * This function call must use less than 30000 gas.
1296      */
1297     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1298         // The interface IDs are constants representing the first 4 bytes
1299         // of the XOR of all function selectors in the interface.
1300         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1301         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1302         return
1303             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1304             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1305             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1306     }
1307 
1308     // =============================================================
1309     //                        IERC721Metadata
1310     // =============================================================
1311 
1312     /**
1313      * @dev Returns the token collection name.
1314      */
1315     function name() public view virtual override returns (string memory) {
1316         return _name;
1317     }
1318 
1319     /**
1320      * @dev Returns the token collection symbol.
1321      */
1322     function symbol() public view virtual override returns (string memory) {
1323         return _symbol;
1324     }
1325 
1326     /**
1327      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1328      */
1329     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1330         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1331 
1332         string memory baseURI = _baseURI();
1333         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1334     }
1335 
1336     /**
1337      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1338      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1339      * by default, it can be overridden in child contracts.
1340      */
1341     function _baseURI() internal view virtual returns (string memory) {
1342         return '';
1343     }
1344 
1345     // =============================================================
1346     //                     OWNERSHIPS OPERATIONS
1347     // =============================================================
1348 
1349     /**
1350      * @dev Returns the owner of the `tokenId` token.
1351      *
1352      * Requirements:
1353      *
1354      * - `tokenId` must exist.
1355      */
1356     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1357         return address(uint160(_packedOwnershipOf(tokenId)));
1358     }
1359 
1360     /**
1361      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1362      * It gradually moves to O(1) as tokens get transferred around over time.
1363      */
1364     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1365         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1366     }
1367 
1368     /**
1369      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1370      */
1371     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1372         return _unpackedOwnership(_packedOwnerships[index]);
1373     }
1374 
1375     /**
1376      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1377      */
1378     function _initializeOwnershipAt(uint256 index) internal virtual {
1379         if (_packedOwnerships[index] == 0) {
1380             _packedOwnerships[index] = _packedOwnershipOf(index);
1381         }
1382     }
1383 
1384     /**
1385      * Returns the packed ownership data of `tokenId`.
1386      */
1387     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1388         uint256 curr = tokenId;
1389 
1390         unchecked {
1391             if (_startTokenId() <= curr)
1392                 if (curr < _currentIndex) {
1393                     uint256 packed = _packedOwnerships[curr];
1394                     // If not burned.
1395                     if (packed & _BITMASK_BURNED == 0) {
1396                         // Invariant:
1397                         // There will always be an initialized ownership slot
1398                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1399                         // before an unintialized ownership slot
1400                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1401                         // Hence, `curr` will not underflow.
1402                         //
1403                         // We can directly compare the packed value.
1404                         // If the address is zero, packed will be zero.
1405                         while (packed == 0) {
1406                             packed = _packedOwnerships[--curr];
1407                         }
1408                         return packed;
1409                     }
1410                 }
1411         }
1412         revert OwnerQueryForNonexistentToken();
1413     }
1414 
1415     /**
1416      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1417      */
1418     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1419         ownership.addr = address(uint160(packed));
1420         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1421         ownership.burned = packed & _BITMASK_BURNED != 0;
1422         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1423     }
1424 
1425     /**
1426      * @dev Packs ownership data into a single uint256.
1427      */
1428     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1429         assembly {
1430             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1431             owner := and(owner, _BITMASK_ADDRESS)
1432             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1433             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1434         }
1435     }
1436 
1437     /**
1438      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1439      */
1440     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1441         // For branchless setting of the `nextInitialized` flag.
1442         assembly {
1443             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1444             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1445         }
1446     }
1447 
1448     // =============================================================
1449     //                      APPROVAL OPERATIONS
1450     // =============================================================
1451 
1452     /**
1453      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1454      * The approval is cleared when the token is transferred.
1455      *
1456      * Only a single account can be approved at a time, so approving the
1457      * zero address clears previous approvals.
1458      *
1459      * Requirements:
1460      *
1461      * - The caller must own the token or be an approved operator.
1462      * - `tokenId` must exist.
1463      *
1464      * Emits an {Approval} event.
1465      */
1466     function approve(address to, uint256 tokenId) public virtual override {
1467         address owner = ownerOf(tokenId);
1468 
1469         if (_msgSenderERC721A() != owner)
1470             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1471                 revert ApprovalCallerNotOwnerNorApproved();
1472             }
1473 
1474         _tokenApprovals[tokenId].value = to;
1475         emit Approval(owner, to, tokenId);
1476     }
1477 
1478     /**
1479      * @dev Returns the account approved for `tokenId` token.
1480      *
1481      * Requirements:
1482      *
1483      * - `tokenId` must exist.
1484      */
1485     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1486         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1487 
1488         return _tokenApprovals[tokenId].value;
1489     }
1490 
1491     /**
1492      * @dev Approve or remove `operator` as an operator for the caller.
1493      * Operators can call {transferFrom} or {safeTransferFrom}
1494      * for any token owned by the caller.
1495      *
1496      * Requirements:
1497      *
1498      * - The `operator` cannot be the caller.
1499      *
1500      * Emits an {ApprovalForAll} event.
1501      */
1502     function setApprovalForAll(address operator, bool approved) public virtual override {
1503         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1504 
1505         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1506         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1507     }
1508 
1509     /**
1510      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1511      *
1512      * See {setApprovalForAll}.
1513      */
1514     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1515         return _operatorApprovals[owner][operator];
1516     }
1517 
1518     /**
1519      * @dev Returns whether `tokenId` exists.
1520      *
1521      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1522      *
1523      * Tokens start existing when they are minted. See {_mint}.
1524      */
1525     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1526         return
1527             _startTokenId() <= tokenId &&
1528             tokenId < _currentIndex && // If within bounds,
1529             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1530     }
1531 
1532     /**
1533      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1534      */
1535     function _isSenderApprovedOrOwner(
1536         address approvedAddress,
1537         address owner,
1538         address msgSender
1539     ) private pure returns (bool result) {
1540         assembly {
1541             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1542             owner := and(owner, _BITMASK_ADDRESS)
1543             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1544             msgSender := and(msgSender, _BITMASK_ADDRESS)
1545             // `msgSender == owner || msgSender == approvedAddress`.
1546             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1547         }
1548     }
1549 
1550     /**
1551      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1552      */
1553     function _getApprovedSlotAndAddress(uint256 tokenId)
1554         private
1555         view
1556         returns (uint256 approvedAddressSlot, address approvedAddress)
1557     {
1558         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1559         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1560         assembly {
1561             approvedAddressSlot := tokenApproval.slot
1562             approvedAddress := sload(approvedAddressSlot)
1563         }
1564     }
1565 
1566     // =============================================================
1567     //                      TRANSFER OPERATIONS
1568     // =============================================================
1569 
1570     /**
1571      * @dev Transfers `tokenId` from `from` to `to`.
1572      *
1573      * Requirements:
1574      *
1575      * - `from` cannot be the zero address.
1576      * - `to` cannot be the zero address.
1577      * - `tokenId` token must be owned by `from`.
1578      * - If the caller is not `from`, it must be approved to move this token
1579      * by either {approve} or {setApprovalForAll}.
1580      *
1581      * Emits a {Transfer} event.
1582      */
1583     function transferFrom(
1584         address from,
1585         address to,
1586         uint256 tokenId
1587     ) public virtual override {
1588         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1589 
1590         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1591 
1592         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1593 
1594         // The nested ifs save around 20+ gas over a compound boolean condition.
1595         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1596             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1597 
1598         if (to == address(0)) revert TransferToZeroAddress();
1599 
1600         _beforeTokenTransfers(from, to, tokenId, 1);
1601 
1602         // Clear approvals from the previous owner.
1603         assembly {
1604             if approvedAddress {
1605                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1606                 sstore(approvedAddressSlot, 0)
1607             }
1608         }
1609 
1610         // Underflow of the sender's balance is impossible because we check for
1611         // ownership above and the recipient's balance can't realistically overflow.
1612         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1613         unchecked {
1614             // We can directly increment and decrement the balances.
1615             --_packedAddressData[from]; // Updates: `balance -= 1`.
1616             ++_packedAddressData[to]; // Updates: `balance += 1`.
1617 
1618             // Updates:
1619             // - `address` to the next owner.
1620             // - `startTimestamp` to the timestamp of transfering.
1621             // - `burned` to `false`.
1622             // - `nextInitialized` to `true`.
1623             _packedOwnerships[tokenId] = _packOwnershipData(
1624                 to,
1625                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1626             );
1627 
1628             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1629             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1630                 uint256 nextTokenId = tokenId + 1;
1631                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1632                 if (_packedOwnerships[nextTokenId] == 0) {
1633                     // If the next slot is within bounds.
1634                     if (nextTokenId != _currentIndex) {
1635                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1636                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1637                     }
1638                 }
1639             }
1640         }
1641 
1642         emit Transfer(from, to, tokenId);
1643         _afterTokenTransfers(from, to, tokenId, 1);
1644     }
1645 
1646     /**
1647      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1648      */
1649     function safeTransferFrom(
1650         address from,
1651         address to,
1652         uint256 tokenId
1653     ) public virtual override {
1654         safeTransferFrom(from, to, tokenId, '');
1655     }
1656 
1657     /**
1658      * @dev Safely transfers `tokenId` token from `from` to `to`.
1659      *
1660      * Requirements:
1661      *
1662      * - `from` cannot be the zero address.
1663      * - `to` cannot be the zero address.
1664      * - `tokenId` token must exist and be owned by `from`.
1665      * - If the caller is not `from`, it must be approved to move this token
1666      * by either {approve} or {setApprovalForAll}.
1667      * - If `to` refers to a smart contract, it must implement
1668      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1669      *
1670      * Emits a {Transfer} event.
1671      */
1672     function safeTransferFrom(
1673         address from,
1674         address to,
1675         uint256 tokenId,
1676         bytes memory _data
1677     ) public virtual override {
1678         transferFrom(from, to, tokenId);
1679         if (to.code.length != 0)
1680             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1681                 revert TransferToNonERC721ReceiverImplementer();
1682             }
1683     }
1684 
1685     /**
1686      * @dev Hook that is called before a set of serially-ordered token IDs
1687      * are about to be transferred. This includes minting.
1688      * And also called before burning one token.
1689      *
1690      * `startTokenId` - the first token ID to be transferred.
1691      * `quantity` - the amount to be transferred.
1692      *
1693      * Calling conditions:
1694      *
1695      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1696      * transferred to `to`.
1697      * - When `from` is zero, `tokenId` will be minted for `to`.
1698      * - When `to` is zero, `tokenId` will be burned by `from`.
1699      * - `from` and `to` are never both zero.
1700      */
1701     function _beforeTokenTransfers(
1702         address from,
1703         address to,
1704         uint256 startTokenId,
1705         uint256 quantity
1706     ) internal virtual {}
1707 
1708     /**
1709      * @dev Hook that is called after a set of serially-ordered token IDs
1710      * have been transferred. This includes minting.
1711      * And also called after one token has been burned.
1712      *
1713      * `startTokenId` - the first token ID to be transferred.
1714      * `quantity` - the amount to be transferred.
1715      *
1716      * Calling conditions:
1717      *
1718      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1719      * transferred to `to`.
1720      * - When `from` is zero, `tokenId` has been minted for `to`.
1721      * - When `to` is zero, `tokenId` has been burned by `from`.
1722      * - `from` and `to` are never both zero.
1723      */
1724     function _afterTokenTransfers(
1725         address from,
1726         address to,
1727         uint256 startTokenId,
1728         uint256 quantity
1729     ) internal virtual {}
1730 
1731     /**
1732      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1733      *
1734      * `from` - Previous owner of the given token ID.
1735      * `to` - Target address that will receive the token.
1736      * `tokenId` - Token ID to be transferred.
1737      * `_data` - Optional data to send along with the call.
1738      *
1739      * Returns whether the call correctly returned the expected magic value.
1740      */
1741     function _checkContractOnERC721Received(
1742         address from,
1743         address to,
1744         uint256 tokenId,
1745         bytes memory _data
1746     ) private returns (bool) {
1747         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1748             bytes4 retval
1749         ) {
1750             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1751         } catch (bytes memory reason) {
1752             if (reason.length == 0) {
1753                 revert TransferToNonERC721ReceiverImplementer();
1754             } else {
1755                 assembly {
1756                     revert(add(32, reason), mload(reason))
1757                 }
1758             }
1759         }
1760     }
1761 
1762     // =============================================================
1763     //                        MINT OPERATIONS
1764     // =============================================================
1765 
1766     /**
1767      * @dev Mints `quantity` tokens and transfers them to `to`.
1768      *
1769      * Requirements:
1770      *
1771      * - `to` cannot be the zero address.
1772      * - `quantity` must be greater than 0.
1773      *
1774      * Emits a {Transfer} event for each mint.
1775      */
1776     function _mint(address to, uint256 quantity) internal virtual {
1777         uint256 startTokenId = _currentIndex;
1778         if (quantity == 0) revert MintZeroQuantity();
1779 
1780         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1781 
1782         // Overflows are incredibly unrealistic.
1783         // `balance` and `numberMinted` have a maximum limit of 2**64.
1784         // `tokenId` has a maximum limit of 2**256.
1785         unchecked {
1786             // Updates:
1787             // - `balance += quantity`.
1788             // - `numberMinted += quantity`.
1789             //
1790             // We can directly add to the `balance` and `numberMinted`.
1791             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1792 
1793             // Updates:
1794             // - `address` to the owner.
1795             // - `startTimestamp` to the timestamp of minting.
1796             // - `burned` to `false`.
1797             // - `nextInitialized` to `quantity == 1`.
1798             _packedOwnerships[startTokenId] = _packOwnershipData(
1799                 to,
1800                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1801             );
1802 
1803             uint256 toMasked;
1804             uint256 end = startTokenId + quantity;
1805 
1806             // Use assembly to loop and emit the `Transfer` event for gas savings.
1807             assembly {
1808                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1809                 toMasked := and(to, _BITMASK_ADDRESS)
1810                 // Emit the `Transfer` event.
1811                 log4(
1812                     0, // Start of data (0, since no data).
1813                     0, // End of data (0, since no data).
1814                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1815                     0, // `address(0)`.
1816                     toMasked, // `to`.
1817                     startTokenId // `tokenId`.
1818                 )
1819 
1820                 for {
1821                     let tokenId := add(startTokenId, 1)
1822                 } iszero(eq(tokenId, end)) {
1823                     tokenId := add(tokenId, 1)
1824                 } {
1825                     // Emit the `Transfer` event. Similar to above.
1826                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1827                 }
1828             }
1829             if (toMasked == 0) revert MintToZeroAddress();
1830 
1831             _currentIndex = end;
1832         }
1833         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1834     }
1835 
1836     /**
1837      * @dev Mints `quantity` tokens and transfers them to `to`.
1838      *
1839      * This function is intended for efficient minting only during contract creation.
1840      *
1841      * It emits only one {ConsecutiveTransfer} as defined in
1842      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1843      * instead of a sequence of {Transfer} event(s).
1844      *
1845      * Calling this function outside of contract creation WILL make your contract
1846      * non-compliant with the ERC721 standard.
1847      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1848      * {ConsecutiveTransfer} event is only permissible during contract creation.
1849      *
1850      * Requirements:
1851      *
1852      * - `to` cannot be the zero address.
1853      * - `quantity` must be greater than 0.
1854      *
1855      * Emits a {ConsecutiveTransfer} event.
1856      */
1857     function _mintERC2309(address to, uint256 quantity) internal virtual {
1858         uint256 startTokenId = _currentIndex;
1859         if (to == address(0)) revert MintToZeroAddress();
1860         if (quantity == 0) revert MintZeroQuantity();
1861         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1862 
1863         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1864 
1865         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1866         unchecked {
1867             // Updates:
1868             // - `balance += quantity`.
1869             // - `numberMinted += quantity`.
1870             //
1871             // We can directly add to the `balance` and `numberMinted`.
1872             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1873 
1874             // Updates:
1875             // - `address` to the owner.
1876             // - `startTimestamp` to the timestamp of minting.
1877             // - `burned` to `false`.
1878             // - `nextInitialized` to `quantity == 1`.
1879             _packedOwnerships[startTokenId] = _packOwnershipData(
1880                 to,
1881                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1882             );
1883 
1884             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1885 
1886             _currentIndex = startTokenId + quantity;
1887         }
1888         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1889     }
1890 
1891     /**
1892      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1893      *
1894      * Requirements:
1895      *
1896      * - If `to` refers to a smart contract, it must implement
1897      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1898      * - `quantity` must be greater than 0.
1899      *
1900      * See {_mint}.
1901      *
1902      * Emits a {Transfer} event for each mint.
1903      */
1904     function _safeMint(
1905         address to,
1906         uint256 quantity,
1907         bytes memory _data
1908     ) internal virtual {
1909         _mint(to, quantity);
1910 
1911         unchecked {
1912             if (to.code.length != 0) {
1913                 uint256 end = _currentIndex;
1914                 uint256 index = end - quantity;
1915                 do {
1916                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1917                         revert TransferToNonERC721ReceiverImplementer();
1918                     }
1919                 } while (index < end);
1920                 // Reentrancy protection.
1921                 if (_currentIndex != end) revert();
1922             }
1923         }
1924     }
1925 
1926     /**
1927      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1928      */
1929     function _safeMint(address to, uint256 quantity) internal virtual {
1930         _safeMint(to, quantity, '');
1931     }
1932 
1933     // =============================================================
1934     //                        BURN OPERATIONS
1935     // =============================================================
1936 
1937     /**
1938      * @dev Equivalent to `_burn(tokenId, false)`.
1939      */
1940     function _burn(uint256 tokenId) internal virtual {
1941         _burn(tokenId, false);
1942     }
1943 
1944     /**
1945      * @dev Destroys `tokenId`.
1946      * The approval is cleared when the token is burned.
1947      *
1948      * Requirements:
1949      *
1950      * - `tokenId` must exist.
1951      *
1952      * Emits a {Transfer} event.
1953      */
1954     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1955         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1956 
1957         address from = address(uint160(prevOwnershipPacked));
1958 
1959         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1960 
1961         if (approvalCheck) {
1962             // The nested ifs save around 20+ gas over a compound boolean condition.
1963             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1964                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1965         }
1966 
1967         _beforeTokenTransfers(from, address(0), tokenId, 1);
1968 
1969         // Clear approvals from the previous owner.
1970         assembly {
1971             if approvedAddress {
1972                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1973                 sstore(approvedAddressSlot, 0)
1974             }
1975         }
1976 
1977         // Underflow of the sender's balance is impossible because we check for
1978         // ownership above and the recipient's balance can't realistically overflow.
1979         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1980         unchecked {
1981             // Updates:
1982             // - `balance -= 1`.
1983             // - `numberBurned += 1`.
1984             //
1985             // We can directly decrement the balance, and increment the number burned.
1986             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1987             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1988 
1989             // Updates:
1990             // - `address` to the last owner.
1991             // - `startTimestamp` to the timestamp of burning.
1992             // - `burned` to `true`.
1993             // - `nextInitialized` to `true`.
1994             _packedOwnerships[tokenId] = _packOwnershipData(
1995                 from,
1996                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1997             );
1998 
1999             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2000             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2001                 uint256 nextTokenId = tokenId + 1;
2002                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2003                 if (_packedOwnerships[nextTokenId] == 0) {
2004                     // If the next slot is within bounds.
2005                     if (nextTokenId != _currentIndex) {
2006                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2007                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2008                     }
2009                 }
2010             }
2011         }
2012 
2013         emit Transfer(from, address(0), tokenId);
2014         _afterTokenTransfers(from, address(0), tokenId, 1);
2015 
2016         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2017         unchecked {
2018             _burnCounter++;
2019         }
2020     }
2021 
2022     // =============================================================
2023     //                     EXTRA DATA OPERATIONS
2024     // =============================================================
2025 
2026     /**
2027      * @dev Directly sets the extra data for the ownership data `index`.
2028      */
2029     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2030         uint256 packed = _packedOwnerships[index];
2031         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2032         uint256 extraDataCasted;
2033         // Cast `extraData` with assembly to avoid redundant masking.
2034         assembly {
2035             extraDataCasted := extraData
2036         }
2037         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2038         _packedOwnerships[index] = packed;
2039     }
2040 
2041     /**
2042      * @dev Called during each token transfer to set the 24bit `extraData` field.
2043      * Intended to be overridden by the cosumer contract.
2044      *
2045      * `previousExtraData` - the value of `extraData` before transfer.
2046      *
2047      * Calling conditions:
2048      *
2049      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2050      * transferred to `to`.
2051      * - When `from` is zero, `tokenId` will be minted for `to`.
2052      * - When `to` is zero, `tokenId` will be burned by `from`.
2053      * - `from` and `to` are never both zero.
2054      */
2055     function _extraData(
2056         address from,
2057         address to,
2058         uint24 previousExtraData
2059     ) internal view virtual returns (uint24) {}
2060 
2061     /**
2062      * @dev Returns the next extra data for the packed ownership data.
2063      * The returned result is shifted into position.
2064      */
2065     function _nextExtraData(
2066         address from,
2067         address to,
2068         uint256 prevOwnershipPacked
2069     ) private view returns (uint256) {
2070         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2071         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2072     }
2073 
2074     // =============================================================
2075     //                       OTHER OPERATIONS
2076     // =============================================================
2077 
2078     /**
2079      * @dev Returns the message sender (defaults to `msg.sender`).
2080      *
2081      * If you are writing GSN compatible contracts, you need to override this function.
2082      */
2083     function _msgSenderERC721A() internal view virtual returns (address) {
2084         return msg.sender;
2085     }
2086 
2087     /**
2088      * @dev Converts a uint256 to its ASCII string decimal representation.
2089      */
2090     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2091         assembly {
2092             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2093             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2094             // We will need 1 32-byte word to store the length,
2095             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2096             ptr := add(mload(0x40), 128)
2097             // Update the free memory pointer to allocate.
2098             mstore(0x40, ptr)
2099 
2100             // Cache the end of the memory to calculate the length later.
2101             let end := ptr
2102 
2103             // We write the string from the rightmost digit to the leftmost digit.
2104             // The following is essentially a do-while loop that also handles the zero case.
2105             // Costs a bit more than early returning for the zero case,
2106             // but cheaper in terms of deployment and overall runtime costs.
2107             for {
2108                 // Initialize and perform the first pass without check.
2109                 let temp := value
2110                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2111                 ptr := sub(ptr, 1)
2112                 // Write the character to the pointer.
2113                 // The ASCII index of the '0' character is 48.
2114                 mstore8(ptr, add(48, mod(temp, 10)))
2115                 temp := div(temp, 10)
2116             } temp {
2117                 // Keep dividing `temp` until zero.
2118                 temp := div(temp, 10)
2119             } {
2120                 // Body of the for loop.
2121                 ptr := sub(ptr, 1)
2122                 mstore8(ptr, add(48, mod(temp, 10)))
2123             }
2124 
2125             let length := sub(end, ptr)
2126             // Move the pointer 32 bytes leftwards to make room for the length.
2127             ptr := sub(ptr, 32)
2128             // Store the length.
2129             mstore(ptr, length)
2130         }
2131     }
2132 }
2133 
2134 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
2135 
2136 
2137 // ERC721A Contracts v4.2.0
2138 // Creator: Chiru Labs
2139 
2140 pragma solidity ^0.8.4;
2141 
2142 
2143 /**
2144  * @dev Interface of ERC721AQueryable.
2145  */
2146 interface IERC721AQueryable is IERC721A {
2147     /**
2148      * Invalid query range (`start` >= `stop`).
2149      */
2150     error InvalidQueryRange();
2151 
2152     /**
2153      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2154      *
2155      * If the `tokenId` is out of bounds:
2156      *
2157      * - `addr = address(0)`
2158      * - `startTimestamp = 0`
2159      * - `burned = false`
2160      * - `extraData = 0`
2161      *
2162      * If the `tokenId` is burned:
2163      *
2164      * - `addr = <Address of owner before token was burned>`
2165      * - `startTimestamp = <Timestamp when token was burned>`
2166      * - `burned = true`
2167      * - `extraData = <Extra data when token was burned>`
2168      *
2169      * Otherwise:
2170      *
2171      * - `addr = <Address of owner>`
2172      * - `startTimestamp = <Timestamp of start of ownership>`
2173      * - `burned = false`
2174      * - `extraData = <Extra data at start of ownership>`
2175      */
2176     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
2177 
2178     /**
2179      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2180      * See {ERC721AQueryable-explicitOwnershipOf}
2181      */
2182     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
2183 
2184     /**
2185      * @dev Returns an array of token IDs owned by `owner`,
2186      * in the range [`start`, `stop`)
2187      * (i.e. `start <= tokenId < stop`).
2188      *
2189      * This function allows for tokens to be queried if the collection
2190      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2191      *
2192      * Requirements:
2193      *
2194      * - `start < stop`
2195      */
2196     function tokensOfOwnerIn(
2197         address owner,
2198         uint256 start,
2199         uint256 stop
2200     ) external view returns (uint256[] memory);
2201 
2202     /**
2203      * @dev Returns an array of token IDs owned by `owner`.
2204      *
2205      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2206      * It is meant to be called off-chain.
2207      *
2208      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2209      * multiple smaller scans if the collection is large enough to cause
2210      * an out-of-gas error (10K collections should be fine).
2211      */
2212     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2213 }
2214 
2215 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2216 
2217 
2218 // ERC721A Contracts v4.2.0
2219 // Creator: Chiru Labs
2220 
2221 pragma solidity ^0.8.4;
2222 
2223 
2224 
2225 /**
2226  * @title ERC721AQueryable.
2227  *
2228  * @dev ERC721A subclass with convenience query functions.
2229  */
2230 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2231     /**
2232      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2233      *
2234      * If the `tokenId` is out of bounds:
2235      *
2236      * - `addr = address(0)`
2237      * - `startTimestamp = 0`
2238      * - `burned = false`
2239      * - `extraData = 0`
2240      *
2241      * If the `tokenId` is burned:
2242      *
2243      * - `addr = <Address of owner before token was burned>`
2244      * - `startTimestamp = <Timestamp when token was burned>`
2245      * - `burned = true`
2246      * - `extraData = <Extra data when token was burned>`
2247      *
2248      * Otherwise:
2249      *
2250      * - `addr = <Address of owner>`
2251      * - `startTimestamp = <Timestamp of start of ownership>`
2252      * - `burned = false`
2253      * - `extraData = <Extra data at start of ownership>`
2254      */
2255     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2256         TokenOwnership memory ownership;
2257         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2258             return ownership;
2259         }
2260         ownership = _ownershipAt(tokenId);
2261         if (ownership.burned) {
2262             return ownership;
2263         }
2264         return _ownershipOf(tokenId);
2265     }
2266 
2267     /**
2268      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2269      * See {ERC721AQueryable-explicitOwnershipOf}
2270      */
2271     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2272         external
2273         view
2274         virtual
2275         override
2276         returns (TokenOwnership[] memory)
2277     {
2278         unchecked {
2279             uint256 tokenIdsLength = tokenIds.length;
2280             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2281             for (uint256 i; i != tokenIdsLength; ++i) {
2282                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2283             }
2284             return ownerships;
2285         }
2286     }
2287 
2288     /**
2289      * @dev Returns an array of token IDs owned by `owner`,
2290      * in the range [`start`, `stop`)
2291      * (i.e. `start <= tokenId < stop`).
2292      *
2293      * This function allows for tokens to be queried if the collection
2294      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2295      *
2296      * Requirements:
2297      *
2298      * - `start < stop`
2299      */
2300     function tokensOfOwnerIn(
2301         address owner,
2302         uint256 start,
2303         uint256 stop
2304     ) external view virtual override returns (uint256[] memory) {
2305         unchecked {
2306             if (start >= stop) revert InvalidQueryRange();
2307             uint256 tokenIdsIdx;
2308             uint256 stopLimit = _nextTokenId();
2309             // Set `start = max(start, _startTokenId())`.
2310             if (start < _startTokenId()) {
2311                 start = _startTokenId();
2312             }
2313             // Set `stop = min(stop, stopLimit)`.
2314             if (stop > stopLimit) {
2315                 stop = stopLimit;
2316             }
2317             uint256 tokenIdsMaxLength = balanceOf(owner);
2318             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2319             // to cater for cases where `balanceOf(owner)` is too big.
2320             if (start < stop) {
2321                 uint256 rangeLength = stop - start;
2322                 if (rangeLength < tokenIdsMaxLength) {
2323                     tokenIdsMaxLength = rangeLength;
2324                 }
2325             } else {
2326                 tokenIdsMaxLength = 0;
2327             }
2328             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2329             if (tokenIdsMaxLength == 0) {
2330                 return tokenIds;
2331             }
2332             // We need to call `explicitOwnershipOf(start)`,
2333             // because the slot at `start` may not be initialized.
2334             TokenOwnership memory ownership = explicitOwnershipOf(start);
2335             address currOwnershipAddr;
2336             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2337             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2338             if (!ownership.burned) {
2339                 currOwnershipAddr = ownership.addr;
2340             }
2341             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2342                 ownership = _ownershipAt(i);
2343                 if (ownership.burned) {
2344                     continue;
2345                 }
2346                 if (ownership.addr != address(0)) {
2347                     currOwnershipAddr = ownership.addr;
2348                 }
2349                 if (currOwnershipAddr == owner) {
2350                     tokenIds[tokenIdsIdx++] = i;
2351                 }
2352             }
2353             // Downsize the array to fit.
2354             assembly {
2355                 mstore(tokenIds, tokenIdsIdx)
2356             }
2357             return tokenIds;
2358         }
2359     }
2360 
2361     /**
2362      * @dev Returns an array of token IDs owned by `owner`.
2363      *
2364      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2365      * It is meant to be called off-chain.
2366      *
2367      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2368      * multiple smaller scans if the collection is large enough to cause
2369      * an out-of-gas error (10K collections should be fine).
2370      */
2371     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2372         unchecked {
2373             uint256 tokenIdsIdx;
2374             address currOwnershipAddr;
2375             uint256 tokenIdsLength = balanceOf(owner);
2376             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2377             TokenOwnership memory ownership;
2378             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2379                 ownership = _ownershipAt(i);
2380                 if (ownership.burned) {
2381                     continue;
2382                 }
2383                 if (ownership.addr != address(0)) {
2384                     currOwnershipAddr = ownership.addr;
2385                 }
2386                 if (currOwnershipAddr == owner) {
2387                     tokenIds[tokenIdsIdx++] = i;
2388                 }
2389             }
2390             return tokenIds;
2391         }
2392     }
2393 }
2394 
2395 // File: contracts/SillyGoatPokerClub.sol
2396 
2397 
2398 
2399 //////////////////////////////////////////////////////////////////////////////////////
2400 /*////////////////////////////////////////////////////////////////////////////////////
2401 /////////////////////////𝓢𝓘𝓛𝓛𝓨 𝓖𝓞𝓐𝓣 𝓟𝓞𝓚𝓔𝓡 𝓒𝓛𝓤𝓑//////////////////////////////////
2402 */////////////////////////////////////////////////////////////////////////////////////
2403 //////////////////////////////////////////////////////////////////////////////////////
2404 
2405 
2406 pragma solidity >=0.8.13 <0.9.0;
2407 
2408 
2409 
2410 
2411 
2412 
2413 
2414 
2415 
2416 
2417 contract SillyGoatPokerClub is ERC721A, Ownable, ReentrancyGuard {
2418 
2419   using Strings for uint256;
2420 
2421 // ================== Variables Start =======================
2422     
2423     string public uri;
2424     string public uriSuffix = ".json";
2425     uint256 public pricePublic = 0.075 ether;
2426     uint256 public priceWhiteList = 0.052 ether;
2427     uint256 public maxSupply = 2500;
2428     uint256 public reservesAmount = 50;
2429     uint256 public maxMintAmountPerTx = 10;
2430     uint256 public maxLimitPerWLWallet = 5;
2431     bool public publicMinting = false;
2432     bool public whitelistMinting = false;
2433     bytes32 public merkleRootWL;
2434     bytes32 public merkleRootFree;
2435 
2436     mapping (address => uint256) public addressBalance;
2437     mapping (address => uint256) public freeMintAddressBalance;
2438 
2439 
2440 // ================== Variables End =======================  
2441 
2442 // ================== Constructor Start =======================
2443 
2444     constructor(
2445         string memory _uri
2446     ) ERC721A("Silly Goat Poker Club", "SGPC")  {
2447         seturi(_uri);
2448     }
2449 
2450 // ================== Constructor End =======================
2451 
2452 // ================== Modifiers Start =======================
2453 
2454     modifier mintWLCompliance(uint tokensToMint) {
2455         require(tokensToMint >= 1, "Min mint is 1 token");
2456         require(totalSupply() + tokensToMint <= maxSupply, "Minting more tokens than allowed");
2457         require(addressBalance[msg.sender] + tokensToMint <= maxLimitPerWLWallet,"Max per wallet during WL is 5");
2458         _;
2459     }
2460 
2461     modifier mintFreeCompliance()
2462     {
2463         require(totalSupply() + 1 <= maxSupply, "Max Supply exceeded.");
2464         require(freeMintAddressBalance[msg.sender] + 1 <= 1, "Free mint claimed.");
2465         _;
2466     }
2467 
2468 // ================== Modifiers End ========================
2469 
2470 // ================== Mint Functions Start =======================
2471  
2472     function CollectReserves() public onlyOwner nonReentrant {
2473         require(totalSupply() + reservesAmount <= maxSupply, 'Max Supply Exceeded.');
2474         _safeMint(msg.sender, reservesAmount);
2475     }
2476 
2477     function FreeMint(bytes32[] memory proof) public payable nonReentrant mintFreeCompliance {
2478         require(isValidFree(proof, msg.sender), "Not eligible for free mint.");
2479         freeMintAddressBalance[msg.sender] += 1;
2480 
2481         _safeMint(msg.sender, reservesAmount);
2482     }
2483 
2484     function WhitelistMint(uint256 _mintAmount, bytes32[] memory proof) public payable nonReentrant mintWLCompliance(_mintAmount) {
2485         // uint256 supply = totalSupply();
2486         // Normal requirements 
2487         require(whitelistMinting, 'Whitelist sale not active!');
2488         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
2489         require(balanceOf(msg.sender) + _mintAmount <= maxLimitPerWLWallet, 'Max mint per wallet exceeded!');
2490         require(isValid(proof, msg.sender), "Not whitelisted");
2491         require(msg.value >= priceWhiteList * _mintAmount, 'Insufficient funds!');
2492         
2493         addressBalance[msg.sender] += _mintAmount;
2494         // Mint
2495         _safeMint(_msgSender(), _mintAmount);
2496     }
2497 
2498     function Mint(uint256 _mintAmount) public payable nonReentrant {
2499         uint256 supply = totalSupply();
2500         // Normal requirements 
2501         require(publicMinting, 'Public sale not active!');
2502         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
2503         require(supply + _mintAmount <= maxSupply, 'Max supply exceeded!');
2504         require(msg.value >= pricePublic * _mintAmount, 'Insufficient funds!');
2505         
2506         // Mint
2507         _safeMint(_msgSender(), _mintAmount);
2508     }  
2509 
2510     function Airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
2511         require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
2512         _safeMint(_receiver, _mintAmount);
2513     }
2514 
2515     function isValid(bytes32[] memory proof, address sender) public view returns (bool) {
2516         return MerkleProof.verify(proof, merkleRootWL, keccak256(abi.encodePacked(sender)));
2517     }
2518 
2519     function isValidFree(bytes32[] memory proof, address sender) public view returns (bool) {
2520         return MerkleProof.verify(proof, merkleRootFree, keccak256(abi.encodePacked(sender)));
2521     }
2522 
2523 
2524 // ================== Mint Functions End =======================  
2525 
2526 // ================== Set Functions Start =======================
2527 
2528 // uri
2529     function seturi(string memory _uri) public onlyOwner {
2530         uri = _uri;
2531     }
2532 
2533     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2534         uriSuffix = _uriSuffix;
2535     }
2536 
2537 // max per tx
2538     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2539         maxMintAmountPerTx = _maxMintAmountPerTx;
2540     }
2541 
2542 // max per wallet
2543     function setMaxLimitPerWhitelistWallet(uint256 _maxLimitPerWallet) public onlyOwner {
2544         maxLimitPerWLWallet = _maxLimitPerWallet;
2545     }
2546 
2547 // price
2548 
2549     function setCostPublic(uint256 _cost) public onlyOwner {
2550         pricePublic = _cost;
2551     }  
2552 
2553     function setCostWL(uint256 _cost) public onlyOwner {
2554         priceWhiteList = _cost;
2555     }
2556 
2557 // supply limit
2558     function setSupplyLimit(uint256 _supplyLimit) public onlyOwner {
2559         maxSupply = _supplyLimit;
2560     }
2561 
2562 // set merkles
2563     function setMerkleRootWL(bytes32 _root) public onlyOwner {
2564         merkleRootWL = _root;
2565     }
2566 
2567     function setMerkleRootFree(bytes32 _root) public onlyOwner {
2568         merkleRootFree = _root;
2569     }
2570 
2571     function setPublicMinting(bool setActive) public onlyOwner {
2572         publicMinting = setActive;
2573     }
2574 
2575     function setWhitelistMinting(bool setActive) public onlyOwner {
2576         whitelistMinting = setActive;
2577     }
2578 
2579 
2580 // ================== Set Functions End =======================
2581 
2582 // ================== Withdraw Function Start =======================
2583   
2584     function withdraw() public onlyOwner nonReentrant {
2585             uint _balance = address(this).balance;
2586             (bool os, ) = payable(owner()).call{value: _balance}("");
2587             require(os);
2588     }
2589 
2590 // ================== Withdraw Function End=======================  
2591 
2592 // ================== Read Functions Start =======================
2593 
2594     function tokensOfOwner(address owner) external view returns (uint256[] memory) {
2595         unchecked {
2596             uint256[] memory a = new uint256[](balanceOf(owner)); 
2597             uint256 end = _nextTokenId();
2598             uint256 tokenIdsIdx;
2599             address currOwnershipAddr;
2600             for (uint256 i; i < end; i++) {
2601                 TokenOwnership memory ownership = _ownershipAt(i);
2602                 if (ownership.burned) {
2603                     continue;
2604                 }
2605                 if (ownership.addr != address(0)) {
2606                     currOwnershipAddr = ownership.addr;
2607                 }
2608                 if (currOwnershipAddr == owner) {
2609                     a[tokenIdsIdx++] = i;
2610                 }
2611             }
2612             return a;    
2613         }
2614     }
2615 
2616     function _startTokenId() internal view virtual override returns (uint256) {
2617         return 1;
2618     }
2619 
2620     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2621         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2622 
2623         string memory currentBaseURI = _baseURI();
2624         return bytes(currentBaseURI).length > 0
2625             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2626             : '';
2627     }
2628 
2629     function _baseURI() internal view virtual override returns (string memory) {
2630         return uri;
2631     }
2632 
2633 // ================== Read Functions End =======================  
2634 
2635 }