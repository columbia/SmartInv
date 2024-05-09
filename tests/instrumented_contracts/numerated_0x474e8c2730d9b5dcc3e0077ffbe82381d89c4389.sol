1 //File： fs://c12714761c8944bd80e2bf619fc588ca/NFT/Opensea/IOperatorFilterRegistry.sol
2 
3 pragma solidity ^0.8.13;
4 
5 interface IOperatorFilterRegistry {
6     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
7     function register(address registrant) external;
8     function registerAndSubscribe(address registrant, address subscription) external;
9     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
10     function unregister(address addr) external;
11     function updateOperator(address registrant, address operator, bool filtered) external;
12     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
13     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
14     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
15     function subscribe(address registrant, address registrantToSubscribe) external;
16     function unsubscribe(address registrant, bool copyExistingEntries) external;
17     function subscriptionOf(address addr) external returns (address registrant);
18     function subscribers(address registrant) external returns (address[] memory);
19     function subscriberAt(address registrant, uint256 index) external returns (address);
20     function copyEntriesOf(address registrant, address registrantToCopy) external;
21     function isOperatorFiltered(address registrant, address operator) external returns (bool);
22     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
23     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
24     function filteredOperators(address addr) external returns (address[] memory);
25     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
26     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
27     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
28     function isRegistered(address addr) external returns (bool);
29     function codeHashOf(address addr) external returns (bytes32);
30 }//File： fs://c12714761c8944bd80e2bf619fc588ca/NFT/Opensea/OperatorFilterer.sol
31 
32 pragma solidity ^0.8.13;
33 
34 
35 /**
36  * @title  OperatorFilterer
37  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
38  *         registrant's entries in the OperatorFilterRegistry.
39  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
40  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
41  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
42  */
43 abstract contract OperatorFilterer {
44     error OperatorNotAllowed(address operator);
45 
46     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
47         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
48 
49     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
50         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
51         // will not revert, but the contract will need to be registered with the registry once it is deployed in
52         // order for the modifier to filter addresses.
53         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
54             if (subscribe) {
55                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
56             } else {
57                 if (subscriptionOrRegistrantToCopy != address(0)) {
58                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
59                 } else {
60                     OPERATOR_FILTER_REGISTRY.register(address(this));
61                 }
62             }
63         }
64     }
65 
66     modifier onlyAllowedOperator(address from) virtual {
67         // Check registry code length to facilitate testing in environments without a deployed registry.
68         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
69             // Allow spending tokens from addresses with balance
70             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
71             // from an EOA.
72             if (from == msg.sender) {
73                 _;
74                 return;
75             }
76             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
77                 revert OperatorNotAllowed(msg.sender);
78             }
79         }
80         _;
81     }
82 
83     modifier onlyAllowedOperatorApproval(address operator) virtual {
84         // Check registry code length to facilitate testing in environments without a deployed registry.
85         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
86             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
87                 revert OperatorNotAllowed(operator);
88             }
89         }
90         _;
91     }
92 }//File： @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
93 
94 // OpenZeppelin Contracts (last updated v4.9.2) (utils/cryptography/MerkleProof.sol)
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev These functions deal with verification of Merkle Tree proofs.
100  *
101  * The tree and the proofs can be generated using our
102  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
103  * You will find a quickstart guide in the readme.
104  *
105  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
106  * hashing, or use a hash function other than keccak256 for hashing leaves.
107  * This is because the concatenation of a sorted pair of internal nodes in
108  * the merkle tree could be reinterpreted as a leaf value.
109  * OpenZeppelin's JavaScript library generates merkle trees that are safe
110  * against this attack out of the box.
111  */
112 library MerkleProof {
113     /**
114      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
115      * defined by `root`. For this, a `proof` must be provided, containing
116      * sibling hashes on the branch from the leaf to the root of the tree. Each
117      * pair of leaves and each pair of pre-images are assumed to be sorted.
118      */
119     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
120         return processProof(proof, leaf) == root;
121     }
122 
123     /**
124      * @dev Calldata version of {verify}
125      *
126      * _Available since v4.7._
127      */
128     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
129         return processProofCalldata(proof, leaf) == root;
130     }
131 
132     /**
133      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
134      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
135      * hash matches the root of the tree. When processing the proof, the pairs
136      * of leafs & pre-images are assumed to be sorted.
137      *
138      * _Available since v4.4._
139      */
140     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
141         bytes32 computedHash = leaf;
142         for (uint256 i = 0; i < proof.length; i++) {
143             computedHash = _hashPair(computedHash, proof[i]);
144         }
145         return computedHash;
146     }
147 
148     /**
149      * @dev Calldata version of {processProof}
150      *
151      * _Available since v4.7._
152      */
153     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
154         bytes32 computedHash = leaf;
155         for (uint256 i = 0; i < proof.length; i++) {
156             computedHash = _hashPair(computedHash, proof[i]);
157         }
158         return computedHash;
159     }
160 
161     /**
162      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
163      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
164      *
165      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
166      *
167      * _Available since v4.7._
168      */
169     function multiProofVerify(
170         bytes32[] memory proof,
171         bool[] memory proofFlags,
172         bytes32 root,
173         bytes32[] memory leaves
174     ) internal pure returns (bool) {
175         return processMultiProof(proof, proofFlags, leaves) == root;
176     }
177 
178     /**
179      * @dev Calldata version of {multiProofVerify}
180      *
181      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
182      *
183      * _Available since v4.7._
184      */
185     function multiProofVerifyCalldata(
186         bytes32[] calldata proof,
187         bool[] calldata proofFlags,
188         bytes32 root,
189         bytes32[] memory leaves
190     ) internal pure returns (bool) {
191         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
192     }
193 
194     /**
195      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
196      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
197      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
198      * respectively.
199      *
200      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
201      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
202      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
203      *
204      * _Available since v4.7._
205      */
206     function processMultiProof(
207         bytes32[] memory proof,
208         bool[] memory proofFlags,
209         bytes32[] memory leaves
210     ) internal pure returns (bytes32 merkleRoot) {
211         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
212         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
213         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
214         // the merkle tree.
215         uint256 leavesLen = leaves.length;
216         uint256 proofLen = proof.length;
217         uint256 totalHashes = proofFlags.length;
218 
219         // Check proof validity.
220         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
221 
222         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
223         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
224         bytes32[] memory hashes = new bytes32[](totalHashes);
225         uint256 leafPos = 0;
226         uint256 hashPos = 0;
227         uint256 proofPos = 0;
228         // At each step, we compute the next hash using two values:
229         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
230         //   get the next hash.
231         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
232         //   `proof` array.
233         for (uint256 i = 0; i < totalHashes; i++) {
234             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
235             bytes32 b = proofFlags[i]
236                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
237                 : proof[proofPos++];
238             hashes[i] = _hashPair(a, b);
239         }
240 
241         if (totalHashes > 0) {
242             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
243             unchecked {
244                 return hashes[totalHashes - 1];
245             }
246         } else if (leavesLen > 0) {
247             return leaves[0];
248         } else {
249             return proof[0];
250         }
251     }
252 
253     /**
254      * @dev Calldata version of {processMultiProof}.
255      *
256      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
257      *
258      * _Available since v4.7._
259      */
260     function processMultiProofCalldata(
261         bytes32[] calldata proof,
262         bool[] calldata proofFlags,
263         bytes32[] memory leaves
264     ) internal pure returns (bytes32 merkleRoot) {
265         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
266         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
267         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
268         // the merkle tree.
269         uint256 leavesLen = leaves.length;
270         uint256 proofLen = proof.length;
271         uint256 totalHashes = proofFlags.length;
272 
273         // Check proof validity.
274         require(leavesLen + proofLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
275 
276         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
277         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
278         bytes32[] memory hashes = new bytes32[](totalHashes);
279         uint256 leafPos = 0;
280         uint256 hashPos = 0;
281         uint256 proofPos = 0;
282         // At each step, we compute the next hash using two values:
283         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
284         //   get the next hash.
285         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
286         //   `proof` array.
287         for (uint256 i = 0; i < totalHashes; i++) {
288             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
289             bytes32 b = proofFlags[i]
290                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
291                 : proof[proofPos++];
292             hashes[i] = _hashPair(a, b);
293         }
294 
295         if (totalHashes > 0) {
296             require(proofPos == proofLen, "MerkleProof: invalid multiproof");
297             unchecked {
298                 return hashes[totalHashes - 1];
299             }
300         } else if (leavesLen > 0) {
301             return leaves[0];
302         } else {
303             return proof[0];
304         }
305     }
306 
307     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
308         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
309     }
310 
311     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
312         /// @solidity memory-safe-assembly
313         assembly {
314             mstore(0x00, a)
315             mstore(0x20, b)
316             value := keccak256(0x00, 0x40)
317         }
318     }
319 }
320 //File： @openzeppelin/contracts/utils/math/SignedMath.sol
321 
322 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
323 
324 pragma solidity ^0.8.0;
325 
326 /**
327  * @dev Standard signed math utilities missing in the Solidity language.
328  */
329 library SignedMath {
330     /**
331      * @dev Returns the largest of two signed numbers.
332      */
333     function max(int256 a, int256 b) internal pure returns (int256) {
334         return a > b ? a : b;
335     }
336 
337     /**
338      * @dev Returns the smallest of two signed numbers.
339      */
340     function min(int256 a, int256 b) internal pure returns (int256) {
341         return a < b ? a : b;
342     }
343 
344     /**
345      * @dev Returns the average of two signed numbers without overflow.
346      * The result is rounded towards zero.
347      */
348     function average(int256 a, int256 b) internal pure returns (int256) {
349         // Formula from the book "Hacker's Delight"
350         int256 x = (a & b) + ((a ^ b) >> 1);
351         return x + (int256(uint256(x) >> 255) & (a ^ b));
352     }
353 
354     /**
355      * @dev Returns the absolute unsigned value of a signed value.
356      */
357     function abs(int256 n) internal pure returns (uint256) {
358         unchecked {
359             // must be unchecked in order to support `n = type(int256).min`
360             return uint256(n >= 0 ? n : -n);
361         }
362     }
363 }
364 //File： @openzeppelin/contracts/utils/math/Math.sol
365 
366 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
367 
368 pragma solidity ^0.8.0;
369 
370 /**
371  * @dev Standard math utilities missing in the Solidity language.
372  */
373 library Math {
374     enum Rounding {
375         Down, // Toward negative infinity
376         Up, // Toward infinity
377         Zero // Toward zero
378     }
379 
380     /**
381      * @dev Returns the largest of two numbers.
382      */
383     function max(uint256 a, uint256 b) internal pure returns (uint256) {
384         return a > b ? a : b;
385     }
386 
387     /**
388      * @dev Returns the smallest of two numbers.
389      */
390     function min(uint256 a, uint256 b) internal pure returns (uint256) {
391         return a < b ? a : b;
392     }
393 
394     /**
395      * @dev Returns the average of two numbers. The result is rounded towards
396      * zero.
397      */
398     function average(uint256 a, uint256 b) internal pure returns (uint256) {
399         // (a + b) / 2 can overflow.
400         return (a & b) + (a ^ b) / 2;
401     }
402 
403     /**
404      * @dev Returns the ceiling of the division of two numbers.
405      *
406      * This differs from standard division with `/` in that it rounds up instead
407      * of rounding down.
408      */
409     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
410         // (a + b - 1) / b can overflow on addition, so we distribute.
411         return a == 0 ? 0 : (a - 1) / b + 1;
412     }
413 
414     /**
415      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
416      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
417      * with further edits by Uniswap Labs also under MIT license.
418      */
419     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
420         unchecked {
421             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
422             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
423             // variables such that product = prod1 * 2^256 + prod0.
424             uint256 prod0; // Least significant 256 bits of the product
425             uint256 prod1; // Most significant 256 bits of the product
426             assembly {
427                 let mm := mulmod(x, y, not(0))
428                 prod0 := mul(x, y)
429                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
430             }
431 
432             // Handle non-overflow cases, 256 by 256 division.
433             if (prod1 == 0) {
434                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
435                 // The surrounding unchecked block does not change this fact.
436                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
437                 return prod0 / denominator;
438             }
439 
440             // Make sure the result is less than 2^256. Also prevents denominator == 0.
441             require(denominator > prod1, "Math: mulDiv overflow");
442 
443             ///////////////////////////////////////////////
444             // 512 by 256 division.
445             ///////////////////////////////////////////////
446 
447             // Make division exact by subtracting the remainder from [prod1 prod0].
448             uint256 remainder;
449             assembly {
450                 // Compute remainder using mulmod.
451                 remainder := mulmod(x, y, denominator)
452 
453                 // Subtract 256 bit number from 512 bit number.
454                 prod1 := sub(prod1, gt(remainder, prod0))
455                 prod0 := sub(prod0, remainder)
456             }
457 
458             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
459             // See https://cs.stackexchange.com/q/138556/92363.
460 
461             // Does not overflow because the denominator cannot be zero at this stage in the function.
462             uint256 twos = denominator & (~denominator + 1);
463             assembly {
464                 // Divide denominator by twos.
465                 denominator := div(denominator, twos)
466 
467                 // Divide [prod1 prod0] by twos.
468                 prod0 := div(prod0, twos)
469 
470                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
471                 twos := add(div(sub(0, twos), twos), 1)
472             }
473 
474             // Shift in bits from prod1 into prod0.
475             prod0 |= prod1 * twos;
476 
477             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
478             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
479             // four bits. That is, denominator * inv = 1 mod 2^4.
480             uint256 inverse = (3 * denominator) ^ 2;
481 
482             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
483             // in modular arithmetic, doubling the correct bits in each step.
484             inverse *= 2 - denominator * inverse; // inverse mod 2^8
485             inverse *= 2 - denominator * inverse; // inverse mod 2^16
486             inverse *= 2 - denominator * inverse; // inverse mod 2^32
487             inverse *= 2 - denominator * inverse; // inverse mod 2^64
488             inverse *= 2 - denominator * inverse; // inverse mod 2^128
489             inverse *= 2 - denominator * inverse; // inverse mod 2^256
490 
491             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
492             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
493             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
494             // is no longer required.
495             result = prod0 * inverse;
496             return result;
497         }
498     }
499 
500     /**
501      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
502      */
503     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
504         uint256 result = mulDiv(x, y, denominator);
505         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
506             result += 1;
507         }
508         return result;
509     }
510 
511     /**
512      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
513      *
514      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
515      */
516     function sqrt(uint256 a) internal pure returns (uint256) {
517         if (a == 0) {
518             return 0;
519         }
520 
521         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
522         //
523         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
524         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
525         //
526         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
527         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
528         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
529         //
530         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
531         uint256 result = 1 << (log2(a) >> 1);
532 
533         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
534         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
535         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
536         // into the expected uint128 result.
537         unchecked {
538             result = (result + a / result) >> 1;
539             result = (result + a / result) >> 1;
540             result = (result + a / result) >> 1;
541             result = (result + a / result) >> 1;
542             result = (result + a / result) >> 1;
543             result = (result + a / result) >> 1;
544             result = (result + a / result) >> 1;
545             return min(result, a / result);
546         }
547     }
548 
549     /**
550      * @notice Calculates sqrt(a), following the selected rounding direction.
551      */
552     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
553         unchecked {
554             uint256 result = sqrt(a);
555             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
556         }
557     }
558 
559     /**
560      * @dev Return the log in base 2, rounded down, of a positive value.
561      * Returns 0 if given 0.
562      */
563     function log2(uint256 value) internal pure returns (uint256) {
564         uint256 result = 0;
565         unchecked {
566             if (value >> 128 > 0) {
567                 value >>= 128;
568                 result += 128;
569             }
570             if (value >> 64 > 0) {
571                 value >>= 64;
572                 result += 64;
573             }
574             if (value >> 32 > 0) {
575                 value >>= 32;
576                 result += 32;
577             }
578             if (value >> 16 > 0) {
579                 value >>= 16;
580                 result += 16;
581             }
582             if (value >> 8 > 0) {
583                 value >>= 8;
584                 result += 8;
585             }
586             if (value >> 4 > 0) {
587                 value >>= 4;
588                 result += 4;
589             }
590             if (value >> 2 > 0) {
591                 value >>= 2;
592                 result += 2;
593             }
594             if (value >> 1 > 0) {
595                 result += 1;
596             }
597         }
598         return result;
599     }
600 
601     /**
602      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
603      * Returns 0 if given 0.
604      */
605     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
606         unchecked {
607             uint256 result = log2(value);
608             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
609         }
610     }
611 
612     /**
613      * @dev Return the log in base 10, rounded down, of a positive value.
614      * Returns 0 if given 0.
615      */
616     function log10(uint256 value) internal pure returns (uint256) {
617         uint256 result = 0;
618         unchecked {
619             if (value >= 10 ** 64) {
620                 value /= 10 ** 64;
621                 result += 64;
622             }
623             if (value >= 10 ** 32) {
624                 value /= 10 ** 32;
625                 result += 32;
626             }
627             if (value >= 10 ** 16) {
628                 value /= 10 ** 16;
629                 result += 16;
630             }
631             if (value >= 10 ** 8) {
632                 value /= 10 ** 8;
633                 result += 8;
634             }
635             if (value >= 10 ** 4) {
636                 value /= 10 ** 4;
637                 result += 4;
638             }
639             if (value >= 10 ** 2) {
640                 value /= 10 ** 2;
641                 result += 2;
642             }
643             if (value >= 10 ** 1) {
644                 result += 1;
645             }
646         }
647         return result;
648     }
649 
650     /**
651      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
652      * Returns 0 if given 0.
653      */
654     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
655         unchecked {
656             uint256 result = log10(value);
657             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
658         }
659     }
660 
661     /**
662      * @dev Return the log in base 256, rounded down, of a positive value.
663      * Returns 0 if given 0.
664      *
665      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
666      */
667     function log256(uint256 value) internal pure returns (uint256) {
668         uint256 result = 0;
669         unchecked {
670             if (value >> 128 > 0) {
671                 value >>= 128;
672                 result += 16;
673             }
674             if (value >> 64 > 0) {
675                 value >>= 64;
676                 result += 8;
677             }
678             if (value >> 32 > 0) {
679                 value >>= 32;
680                 result += 4;
681             }
682             if (value >> 16 > 0) {
683                 value >>= 16;
684                 result += 2;
685             }
686             if (value >> 8 > 0) {
687                 result += 1;
688             }
689         }
690         return result;
691     }
692 
693     /**
694      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
695      * Returns 0 if given 0.
696      */
697     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
698         unchecked {
699             uint256 result = log256(value);
700             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
701         }
702     }
703 }
704 //File： @openzeppelin/contracts/utils/Strings.sol
705 
706 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 
712 /**
713  * @dev String operations.
714  */
715 library Strings {
716     bytes16 private constant _SYMBOLS = "0123456789abcdef";
717     uint8 private constant _ADDRESS_LENGTH = 20;
718 
719     /**
720      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
721      */
722     function toString(uint256 value) internal pure returns (string memory) {
723         unchecked {
724             uint256 length = Math.log10(value) + 1;
725             string memory buffer = new string(length);
726             uint256 ptr;
727             /// @solidity memory-safe-assembly
728             assembly {
729                 ptr := add(buffer, add(32, length))
730             }
731             while (true) {
732                 ptr--;
733                 /// @solidity memory-safe-assembly
734                 assembly {
735                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
736                 }
737                 value /= 10;
738                 if (value == 0) break;
739             }
740             return buffer;
741         }
742     }
743 
744     /**
745      * @dev Converts a `int256` to its ASCII `string` decimal representation.
746      */
747     function toString(int256 value) internal pure returns (string memory) {
748         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
749     }
750 
751     /**
752      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
753      */
754     function toHexString(uint256 value) internal pure returns (string memory) {
755         unchecked {
756             return toHexString(value, Math.log256(value) + 1);
757         }
758     }
759 
760     /**
761      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
762      */
763     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
764         bytes memory buffer = new bytes(2 * length + 2);
765         buffer[0] = "0";
766         buffer[1] = "x";
767         for (uint256 i = 2 * length + 1; i > 1; --i) {
768             buffer[i] = _SYMBOLS[value & 0xf];
769             value >>= 4;
770         }
771         require(value == 0, "Strings: hex length insufficient");
772         return string(buffer);
773     }
774 
775     /**
776      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
777      */
778     function toHexString(address addr) internal pure returns (string memory) {
779         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
780     }
781 
782     /**
783      * @dev Returns true if the two strings are equal.
784      */
785     function equal(string memory a, string memory b) internal pure returns (bool) {
786         return keccak256(bytes(a)) == keccak256(bytes(b));
787     }
788 }
789 //File： @openzeppelin/contracts/utils/Context.sol
790 
791 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
792 
793 pragma solidity ^0.8.0;
794 
795 /**
796  * @dev Provides information about the current execution context, including the
797  * sender of the transaction and its data. While these are generally available
798  * via msg.sender and msg.data, they should not be accessed in such a direct
799  * manner, since when dealing with meta-transactions the account sending and
800  * paying for execution may not be the actual sender (as far as an application
801  * is concerned).
802  *
803  * This contract is only required for intermediate, library-like contracts.
804  */
805 abstract contract Context {
806     function _msgSender() internal view virtual returns (address) {
807         return msg.sender;
808     }
809 
810     function _msgData() internal view virtual returns (bytes calldata) {
811         return msg.data;
812     }
813 }
814 //File： @openzeppelin/contracts/utils/Address.sol
815 
816 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
817 
818 pragma solidity ^0.8.1;
819 
820 /**
821  * @dev Collection of functions related to the address type
822  */
823 library Address {
824     /**
825      * @dev Returns true if `account` is a contract.
826      *
827      * [IMPORTANT]
828      * ====
829      * It is unsafe to assume that an address for which this function returns
830      * false is an externally-owned account (EOA) and not a contract.
831      *
832      * Among others, `isContract` will return false for the following
833      * types of addresses:
834      *
835      *  - an externally-owned account
836      *  - a contract in construction
837      *  - an address where a contract will be created
838      *  - an address where a contract lived, but was destroyed
839      *
840      * Furthermore, `isContract` will also return true if the target contract within
841      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
842      * which only has an effect at the end of a transaction.
843      * ====
844      *
845      * [IMPORTANT]
846      * ====
847      * You shouldn't rely on `isContract` to protect against flash loan attacks!
848      *
849      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
850      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
851      * constructor.
852      * ====
853      */
854     function isContract(address account) internal view returns (bool) {
855         // This method relies on extcodesize/address.code.length, which returns 0
856         // for contracts in construction, since the code is only stored at the end
857         // of the constructor execution.
858 
859         return account.code.length > 0;
860     }
861 
862     /**
863      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
864      * `recipient`, forwarding all available gas and reverting on errors.
865      *
866      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
867      * of certain opcodes, possibly making contracts go over the 2300 gas limit
868      * imposed by `transfer`, making them unable to receive funds via
869      * `transfer`. {sendValue} removes this limitation.
870      *
871      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
872      *
873      * IMPORTANT: because control is transferred to `recipient`, care must be
874      * taken to not create reentrancy vulnerabilities. Consider using
875      * {ReentrancyGuard} or the
876      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
877      */
878     function sendValue(address payable recipient, uint256 amount) internal {
879         require(address(this).balance >= amount, "Address: insufficient balance");
880 
881         (bool success, ) = recipient.call{value: amount}("");
882         require(success, "Address: unable to send value, recipient may have reverted");
883     }
884 
885     /**
886      * @dev Performs a Solidity function call using a low level `call`. A
887      * plain `call` is an unsafe replacement for a function call: use this
888      * function instead.
889      *
890      * If `target` reverts with a revert reason, it is bubbled up by this
891      * function (like regular Solidity function calls).
892      *
893      * Returns the raw returned data. To convert to the expected return value,
894      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
895      *
896      * Requirements:
897      *
898      * - `target` must be a contract.
899      * - calling `target` with `data` must not revert.
900      *
901      * _Available since v3.1._
902      */
903     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
904         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
905     }
906 
907     /**
908      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
909      * `errorMessage` as a fallback revert reason when `target` reverts.
910      *
911      * _Available since v3.1._
912      */
913     function functionCall(
914         address target,
915         bytes memory data,
916         string memory errorMessage
917     ) internal returns (bytes memory) {
918         return functionCallWithValue(target, data, 0, errorMessage);
919     }
920 
921     /**
922      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
923      * but also transferring `value` wei to `target`.
924      *
925      * Requirements:
926      *
927      * - the calling contract must have an ETH balance of at least `value`.
928      * - the called Solidity function must be `payable`.
929      *
930      * _Available since v3.1._
931      */
932     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
933         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
934     }
935 
936     /**
937      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
938      * with `errorMessage` as a fallback revert reason when `target` reverts.
939      *
940      * _Available since v3.1._
941      */
942     function functionCallWithValue(
943         address target,
944         bytes memory data,
945         uint256 value,
946         string memory errorMessage
947     ) internal returns (bytes memory) {
948         require(address(this).balance >= value, "Address: insufficient balance for call");
949         (bool success, bytes memory returndata) = target.call{value: value}(data);
950         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
951     }
952 
953     /**
954      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
955      * but performing a static call.
956      *
957      * _Available since v3.3._
958      */
959     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
960         return functionStaticCall(target, data, "Address: low-level static call failed");
961     }
962 
963     /**
964      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
965      * but performing a static call.
966      *
967      * _Available since v3.3._
968      */
969     function functionStaticCall(
970         address target,
971         bytes memory data,
972         string memory errorMessage
973     ) internal view returns (bytes memory) {
974         (bool success, bytes memory returndata) = target.staticcall(data);
975         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
976     }
977 
978     /**
979      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
980      * but performing a delegate call.
981      *
982      * _Available since v3.4._
983      */
984     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
985         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
986     }
987 
988     /**
989      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
990      * but performing a delegate call.
991      *
992      * _Available since v3.4._
993      */
994     function functionDelegateCall(
995         address target,
996         bytes memory data,
997         string memory errorMessage
998     ) internal returns (bytes memory) {
999         (bool success, bytes memory returndata) = target.delegatecall(data);
1000         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1001     }
1002 
1003     /**
1004      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1005      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1006      *
1007      * _Available since v4.8._
1008      */
1009     function verifyCallResultFromTarget(
1010         address target,
1011         bool success,
1012         bytes memory returndata,
1013         string memory errorMessage
1014     ) internal view returns (bytes memory) {
1015         if (success) {
1016             if (returndata.length == 0) {
1017                 // only check isContract if the call was successful and the return data is empty
1018                 // otherwise we already know that it was a contract
1019                 require(isContract(target), "Address: call to non-contract");
1020             }
1021             return returndata;
1022         } else {
1023             _revert(returndata, errorMessage);
1024         }
1025     }
1026 
1027     /**
1028      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1029      * revert reason or using the provided one.
1030      *
1031      * _Available since v4.3._
1032      */
1033     function verifyCallResult(
1034         bool success,
1035         bytes memory returndata,
1036         string memory errorMessage
1037     ) internal pure returns (bytes memory) {
1038         if (success) {
1039             return returndata;
1040         } else {
1041             _revert(returndata, errorMessage);
1042         }
1043     }
1044 
1045     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1046         // Look for revert reason and bubble it up if present
1047         if (returndata.length > 0) {
1048             // The easiest way to bubble the revert reason is using memory via assembly
1049             /// @solidity memory-safe-assembly
1050             assembly {
1051                 let returndata_size := mload(returndata)
1052                 revert(add(32, returndata), returndata_size)
1053             }
1054         } else {
1055             revert(errorMessage);
1056         }
1057     }
1058 }
1059 //File： @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1060 
1061 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1062 
1063 pragma solidity ^0.8.0;
1064 
1065 /**
1066  * @title ERC721 token receiver interface
1067  * @dev Interface for any contract that wants to support safeTransfers
1068  * from ERC721 asset contracts.
1069  */
1070 interface IERC721Receiver {
1071     /**
1072      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1073      * by `operator` from `from`, this function is called.
1074      *
1075      * It must return its Solidity selector to confirm the token transfer.
1076      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1077      *
1078      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1079      */
1080     function onERC721Received(
1081         address operator,
1082         address from,
1083         uint256 tokenId,
1084         bytes calldata data
1085     ) external returns (bytes4);
1086 }
1087 //File： @openzeppelin/contracts/utils/introspection/IERC165.sol
1088 
1089 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1090 
1091 pragma solidity ^0.8.0;
1092 
1093 /**
1094  * @dev Interface of the ERC165 standard, as defined in the
1095  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1096  *
1097  * Implementers can declare support of contract interfaces, which can then be
1098  * queried by others ({ERC165Checker}).
1099  *
1100  * For an implementation, see {ERC165}.
1101  */
1102 interface IERC165 {
1103     /**
1104      * @dev Returns true if this contract implements the interface defined by
1105      * `interfaceId`. See the corresponding
1106      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1107      * to learn more about how these ids are created.
1108      *
1109      * This function call must use less than 30 000 gas.
1110      */
1111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1112 }
1113 //File： @openzeppelin/contracts/token/ERC721/IERC721.sol
1114 
1115 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 
1120 /**
1121  * @dev Required interface of an ERC721 compliant contract.
1122  */
1123 interface IERC721 is IERC165 {
1124     /**
1125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1126      */
1127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1128 
1129     /**
1130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1131      */
1132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1133 
1134     /**
1135      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1136      */
1137     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1138 
1139     /**
1140      * @dev Returns the number of tokens in ``owner``'s account.
1141      */
1142     function balanceOf(address owner) external view returns (uint256 balance);
1143 
1144     /**
1145      * @dev Returns the owner of the `tokenId` token.
1146      *
1147      * Requirements:
1148      *
1149      * - `tokenId` must exist.
1150      */
1151     function ownerOf(uint256 tokenId) external view returns (address owner);
1152 
1153     /**
1154      * @dev Safely transfers `tokenId` token from `from` to `to`.
1155      *
1156      * Requirements:
1157      *
1158      * - `from` cannot be the zero address.
1159      * - `to` cannot be the zero address.
1160      * - `tokenId` token must exist and be owned by `from`.
1161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1167 
1168     /**
1169      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1170      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1171      *
1172      * Requirements:
1173      *
1174      * - `from` cannot be the zero address.
1175      * - `to` cannot be the zero address.
1176      * - `tokenId` token must exist and be owned by `from`.
1177      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1183 
1184     /**
1185      * @dev Transfers `tokenId` token from `from` to `to`.
1186      *
1187      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1188      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1189      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1190      *
1191      * Requirements:
1192      *
1193      * - `from` cannot be the zero address.
1194      * - `to` cannot be the zero address.
1195      * - `tokenId` token must be owned by `from`.
1196      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function transferFrom(address from, address to, uint256 tokenId) external;
1201 
1202     /**
1203      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1204      * The approval is cleared when the token is transferred.
1205      *
1206      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1207      *
1208      * Requirements:
1209      *
1210      * - The caller must own the token or be an approved operator.
1211      * - `tokenId` must exist.
1212      *
1213      * Emits an {Approval} event.
1214      */
1215     function approve(address to, uint256 tokenId) external;
1216 
1217     /**
1218      * @dev Approve or remove `operator` as an operator for the caller.
1219      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1220      *
1221      * Requirements:
1222      *
1223      * - The `operator` cannot be the caller.
1224      *
1225      * Emits an {ApprovalForAll} event.
1226      */
1227     function setApprovalForAll(address operator, bool approved) external;
1228 
1229     /**
1230      * @dev Returns the account approved for `tokenId` token.
1231      *
1232      * Requirements:
1233      *
1234      * - `tokenId` must exist.
1235      */
1236     function getApproved(uint256 tokenId) external view returns (address operator);
1237 
1238     /**
1239      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1240      *
1241      * See {setApprovalForAll}
1242      */
1243     function isApprovedForAll(address owner, address operator) external view returns (bool);
1244 }
1245 //File： @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1246 
1247 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1248 
1249 pragma solidity ^0.8.0;
1250 
1251 
1252 /**
1253  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1254  * @dev See https://eips.ethereum.org/EIPS/eip-721
1255  */
1256 interface IERC721Metadata is IERC721 {
1257     /**
1258      * @dev Returns the token collection name.
1259      */
1260     function name() external view returns (string memory);
1261 
1262     /**
1263      * @dev Returns the token collection symbol.
1264      */
1265     function symbol() external view returns (string memory);
1266 
1267     /**
1268      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1269      */
1270     function tokenURI(uint256 tokenId) external view returns (string memory);
1271 }
1272 //File： @openzeppelin/contracts/utils/introspection/ERC165.sol
1273 
1274 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1275 
1276 pragma solidity ^0.8.0;
1277 
1278 
1279 /**
1280  * @dev Implementation of the {IERC165} interface.
1281  *
1282  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1283  * for the additional interface id that will be supported. For example:
1284  *
1285  * ```solidity
1286  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1287  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1288  * }
1289  * ```
1290  *
1291  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1292  */
1293 abstract contract ERC165 is IERC165 {
1294     /**
1295      * @dev See {IERC165-supportsInterface}.
1296      */
1297     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1298         return interfaceId == type(IERC165).interfaceId;
1299     }
1300 }
1301 //File： @openzeppelin/contracts/interfaces/IERC2981.sol
1302 
1303 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC2981.sol)
1304 
1305 pragma solidity ^0.8.0;
1306 
1307 
1308 /**
1309  * @dev Interface for the NFT Royalty Standard.
1310  *
1311  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1312  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1313  *
1314  * _Available since v4.5._
1315  */
1316 interface IERC2981 is IERC165 {
1317     /**
1318      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1319      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1320      */
1321     function royaltyInfo(
1322         uint256 tokenId,
1323         uint256 salePrice
1324     ) external view returns (address receiver, uint256 royaltyAmount);
1325 }
1326 //File： fs://c12714761c8944bd80e2bf619fc588ca/NFT/Opensea/DefaultOperatorFilterer.sol
1327 
1328 pragma solidity ^0.8.13;
1329 
1330 
1331 /**
1332  * @title  DefaultOperatorFilterer
1333  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1334  */
1335 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1336     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1337 
1338     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1339 }//File： @openzeppelin/contracts/token/common/ERC2981.sol
1340 
1341 // OpenZeppelin Contracts (last updated v4.9.0) (token/common/ERC2981.sol)
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 
1346 
1347 /**
1348  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1349  *
1350  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1351  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1352  *
1353  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1354  * fee is specified in basis points by default.
1355  *
1356  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1357  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1358  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1359  *
1360  * _Available since v4.5._
1361  */
1362 abstract contract ERC2981 is IERC2981, ERC165 {
1363     struct RoyaltyInfo {
1364         address receiver;
1365         uint96 royaltyFraction;
1366     }
1367 
1368     RoyaltyInfo private _defaultRoyaltyInfo;
1369     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1370 
1371     /**
1372      * @dev See {IERC165-supportsInterface}.
1373      */
1374     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1375         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1376     }
1377 
1378     /**
1379      * @inheritdoc IERC2981
1380      */
1381     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual override returns (address, uint256) {
1382         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
1383 
1384         if (royalty.receiver == address(0)) {
1385             royalty = _defaultRoyaltyInfo;
1386         }
1387 
1388         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
1389 
1390         return (royalty.receiver, royaltyAmount);
1391     }
1392 
1393     /**
1394      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1395      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1396      * override.
1397      */
1398     function _feeDenominator() internal pure virtual returns (uint96) {
1399         return 10000;
1400     }
1401 
1402     /**
1403      * @dev Sets the royalty information that all ids in this contract will default to.
1404      *
1405      * Requirements:
1406      *
1407      * - `receiver` cannot be the zero address.
1408      * - `feeNumerator` cannot be greater than the fee denominator.
1409      */
1410     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1411         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1412         require(receiver != address(0), "ERC2981: invalid receiver");
1413 
1414         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1415     }
1416 
1417     /**
1418      * @dev Removes default royalty information.
1419      */
1420     function _deleteDefaultRoyalty() internal virtual {
1421         delete _defaultRoyaltyInfo;
1422     }
1423 
1424     /**
1425      * @dev Sets the royalty information for a specific token id, overriding the global default.
1426      *
1427      * Requirements:
1428      *
1429      * - `receiver` cannot be the zero address.
1430      * - `feeNumerator` cannot be greater than the fee denominator.
1431      */
1432     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
1433         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1434         require(receiver != address(0), "ERC2981: Invalid parameters");
1435 
1436         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1437     }
1438 
1439     /**
1440      * @dev Resets royalty information for the token id back to the global default.
1441      */
1442     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1443         delete _tokenRoyaltyInfo[tokenId];
1444     }
1445 }
1446 //File： @openzeppelin/contracts/access/Ownable.sol
1447 
1448 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1449 
1450 pragma solidity ^0.8.0;
1451 
1452 
1453 /**
1454  * @dev Contract module which provides a basic access control mechanism, where
1455  * there is an account (an owner) that can be granted exclusive access to
1456  * specific functions.
1457  *
1458  * By default, the owner account will be the one that deploys the contract. This
1459  * can later be changed with {transferOwnership}.
1460  *
1461  * This module is used through inheritance. It will make available the modifier
1462  * `onlyOwner`, which can be applied to your functions to restrict their use to
1463  * the owner.
1464  */
1465 abstract contract Ownable is Context {
1466     address private _owner;
1467 
1468     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1469 
1470     /**
1471      * @dev Initializes the contract setting the deployer as the initial owner.
1472      */
1473     constructor() {
1474         _transferOwnership(_msgSender());
1475     }
1476 
1477     /**
1478      * @dev Throws if called by any account other than the owner.
1479      */
1480     modifier onlyOwner() {
1481         _checkOwner();
1482         _;
1483     }
1484 
1485     /**
1486      * @dev Returns the address of the current owner.
1487      */
1488     function owner() public view virtual returns (address) {
1489         return _owner;
1490     }
1491 
1492     /**
1493      * @dev Throws if the sender is not the owner.
1494      */
1495     function _checkOwner() internal view virtual {
1496         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1497     }
1498 
1499     /**
1500      * @dev Leaves the contract without owner. It will not be possible to call
1501      * `onlyOwner` functions. Can only be called by the current owner.
1502      *
1503      * NOTE: Renouncing ownership will leave the contract without an owner,
1504      * thereby disabling any functionality that is only available to the owner.
1505      */
1506     function renounceOwnership() public virtual onlyOwner {
1507         _transferOwnership(address(0));
1508     }
1509 
1510     /**
1511      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1512      * Can only be called by the current owner.
1513      */
1514     function transferOwnership(address newOwner) public virtual onlyOwner {
1515         require(newOwner != address(0), "Ownable: new owner is the zero address");
1516         _transferOwnership(newOwner);
1517     }
1518 
1519     /**
1520      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1521      * Internal function without access restriction.
1522      */
1523     function _transferOwnership(address newOwner) internal virtual {
1524         address oldOwner = _owner;
1525         _owner = newOwner;
1526         emit OwnershipTransferred(oldOwner, newOwner);
1527     }
1528 }
1529 //File： @openzeppelin/contracts/token/ERC721/ERC721.sol
1530 
1531 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/ERC721.sol)
1532 
1533 pragma solidity ^0.8.0;
1534 
1535 
1536 
1537 
1538 
1539 
1540 
1541 
1542 /**
1543  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1544  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1545  * {ERC721Enumerable}.
1546  */
1547 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1548     using Address for address;
1549     using Strings for uint256;
1550 
1551     // Token name
1552     string private _name;
1553 
1554     // Token symbol
1555     string private _symbol;
1556 
1557     // Mapping from token ID to owner address
1558     mapping(uint256 => address) private _owners;
1559 
1560     // Mapping owner address to token count
1561     mapping(address => uint256) private _balances;
1562 
1563     // Mapping from token ID to approved address
1564     mapping(uint256 => address) private _tokenApprovals;
1565 
1566     // Mapping from owner to operator approvals
1567     mapping(address => mapping(address => bool)) private _operatorApprovals;
1568 
1569     /**
1570      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1571      */
1572     constructor(string memory name_, string memory symbol_) {
1573         _name = name_;
1574         _symbol = symbol_;
1575     }
1576 
1577     /**
1578      * @dev See {IERC165-supportsInterface}.
1579      */
1580     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1581         return
1582             interfaceId == type(IERC721).interfaceId ||
1583             interfaceId == type(IERC721Metadata).interfaceId ||
1584             super.supportsInterface(interfaceId);
1585     }
1586 
1587     /**
1588      * @dev See {IERC721-balanceOf}.
1589      */
1590     function balanceOf(address owner) public view virtual override returns (uint256) {
1591         require(owner != address(0), "ERC721: address zero is not a valid owner");
1592         return _balances[owner];
1593     }
1594 
1595     /**
1596      * @dev See {IERC721-ownerOf}.
1597      */
1598     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1599         address owner = _ownerOf(tokenId);
1600         require(owner != address(0), "ERC721: invalid token ID");
1601         return owner;
1602     }
1603 
1604     /**
1605      * @dev See {IERC721Metadata-name}.
1606      */
1607     function name() public view virtual override returns (string memory) {
1608         return _name;
1609     }
1610 
1611     /**
1612      * @dev See {IERC721Metadata-symbol}.
1613      */
1614     function symbol() public view virtual override returns (string memory) {
1615         return _symbol;
1616     }
1617 
1618     /**
1619      * @dev See {IERC721Metadata-tokenURI}.
1620      */
1621     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1622         _requireMinted(tokenId);
1623 
1624         string memory baseURI = _baseURI();
1625         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1626     }
1627 
1628     /**
1629      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1630      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1631      * by default, can be overridden in child contracts.
1632      */
1633     function _baseURI() internal view virtual returns (string memory) {
1634         return "";
1635     }
1636 
1637     /**
1638      * @dev See {IERC721-approve}.
1639      */
1640     function approve(address to, uint256 tokenId) public virtual override {
1641         address owner = ERC721.ownerOf(tokenId);
1642         require(to != owner, "ERC721: approval to current owner");
1643 
1644         require(
1645             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1646             "ERC721: approve caller is not token owner or approved for all"
1647         );
1648 
1649         _approve(to, tokenId);
1650     }
1651 
1652     /**
1653      * @dev See {IERC721-getApproved}.
1654      */
1655     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1656         _requireMinted(tokenId);
1657 
1658         return _tokenApprovals[tokenId];
1659     }
1660 
1661     /**
1662      * @dev See {IERC721-setApprovalForAll}.
1663      */
1664     function setApprovalForAll(address operator, bool approved) public virtual override {
1665         _setApprovalForAll(_msgSender(), operator, approved);
1666     }
1667 
1668     /**
1669      * @dev See {IERC721-isApprovedForAll}.
1670      */
1671     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1672         return _operatorApprovals[owner][operator];
1673     }
1674 
1675     /**
1676      * @dev See {IERC721-transferFrom}.
1677      */
1678     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1679         //solhint-disable-next-line max-line-length
1680         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1681 
1682         _transfer(from, to, tokenId);
1683     }
1684 
1685     /**
1686      * @dev See {IERC721-safeTransferFrom}.
1687      */
1688     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1689         safeTransferFrom(from, to, tokenId, "");
1690     }
1691 
1692     /**
1693      * @dev See {IERC721-safeTransferFrom}.
1694      */
1695     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
1696         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1697         _safeTransfer(from, to, tokenId, data);
1698     }
1699 
1700     /**
1701      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1702      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1703      *
1704      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1705      *
1706      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1707      * implement alternative mechanisms to perform token transfer, such as signature-based.
1708      *
1709      * Requirements:
1710      *
1711      * - `from` cannot be the zero address.
1712      * - `to` cannot be the zero address.
1713      * - `tokenId` token must exist and be owned by `from`.
1714      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1715      *
1716      * Emits a {Transfer} event.
1717      */
1718     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
1719         _transfer(from, to, tokenId);
1720         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1721     }
1722 
1723     /**
1724      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1725      */
1726     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1727         return _owners[tokenId];
1728     }
1729 
1730     /**
1731      * @dev Returns whether `tokenId` exists.
1732      *
1733      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1734      *
1735      * Tokens start existing when they are minted (`_mint`),
1736      * and stop existing when they are burned (`_burn`).
1737      */
1738     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1739         return _ownerOf(tokenId) != address(0);
1740     }
1741 
1742     /**
1743      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1744      *
1745      * Requirements:
1746      *
1747      * - `tokenId` must exist.
1748      */
1749     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1750         address owner = ERC721.ownerOf(tokenId);
1751         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1752     }
1753 
1754     /**
1755      * @dev Safely mints `tokenId` and transfers it to `to`.
1756      *
1757      * Requirements:
1758      *
1759      * - `tokenId` must not exist.
1760      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1761      *
1762      * Emits a {Transfer} event.
1763      */
1764     function _safeMint(address to, uint256 tokenId) internal virtual {
1765         _safeMint(to, tokenId, "");
1766     }
1767 
1768     /**
1769      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1770      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1771      */
1772     function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
1773         _mint(to, tokenId);
1774         require(
1775             _checkOnERC721Received(address(0), to, tokenId, data),
1776             "ERC721: transfer to non ERC721Receiver implementer"
1777         );
1778     }
1779 
1780     /**
1781      * @dev Mints `tokenId` and transfers it to `to`.
1782      *
1783      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1784      *
1785      * Requirements:
1786      *
1787      * - `tokenId` must not exist.
1788      * - `to` cannot be the zero address.
1789      *
1790      * Emits a {Transfer} event.
1791      */
1792     function _mint(address to, uint256 tokenId) internal virtual {
1793         require(to != address(0), "ERC721: mint to the zero address");
1794         require(!_exists(tokenId), "ERC721: token already minted");
1795 
1796         _beforeTokenTransfer(address(0), to, tokenId, 1);
1797 
1798         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1799         require(!_exists(tokenId), "ERC721: token already minted");
1800 
1801         unchecked {
1802             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1803             // Given that tokens are minted one by one, it is impossible in practice that
1804             // this ever happens. Might change if we allow batch minting.
1805             // The ERC fails to describe this case.
1806             _balances[to] += 1;
1807         }
1808 
1809         _owners[tokenId] = to;
1810 
1811         emit Transfer(address(0), to, tokenId);
1812 
1813         _afterTokenTransfer(address(0), to, tokenId, 1);
1814     }
1815 
1816     /**
1817      * @dev Destroys `tokenId`.
1818      * The approval is cleared when the token is burned.
1819      * This is an internal function that does not check if the sender is authorized to operate on the token.
1820      *
1821      * Requirements:
1822      *
1823      * - `tokenId` must exist.
1824      *
1825      * Emits a {Transfer} event.
1826      */
1827     function _burn(uint256 tokenId) internal virtual {
1828         address owner = ERC721.ownerOf(tokenId);
1829 
1830         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1831 
1832         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1833         owner = ERC721.ownerOf(tokenId);
1834 
1835         // Clear approvals
1836         delete _tokenApprovals[tokenId];
1837 
1838         unchecked {
1839             // Cannot overflow, as that would require more tokens to be burned/transferred
1840             // out than the owner initially received through minting and transferring in.
1841             _balances[owner] -= 1;
1842         }
1843         delete _owners[tokenId];
1844 
1845         emit Transfer(owner, address(0), tokenId);
1846 
1847         _afterTokenTransfer(owner, address(0), tokenId, 1);
1848     }
1849 
1850     /**
1851      * @dev Transfers `tokenId` from `from` to `to`.
1852      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1853      *
1854      * Requirements:
1855      *
1856      * - `to` cannot be the zero address.
1857      * - `tokenId` token must be owned by `from`.
1858      *
1859      * Emits a {Transfer} event.
1860      */
1861     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1862         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1863         require(to != address(0), "ERC721: transfer to the zero address");
1864 
1865         _beforeTokenTransfer(from, to, tokenId, 1);
1866 
1867         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1868         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1869 
1870         // Clear approvals from the previous owner
1871         delete _tokenApprovals[tokenId];
1872 
1873         unchecked {
1874             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1875             // `from`'s balance is the number of token held, which is at least one before the current
1876             // transfer.
1877             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1878             // all 2**256 token ids to be minted, which in practice is impossible.
1879             _balances[from] -= 1;
1880             _balances[to] += 1;
1881         }
1882         _owners[tokenId] = to;
1883 
1884         emit Transfer(from, to, tokenId);
1885 
1886         _afterTokenTransfer(from, to, tokenId, 1);
1887     }
1888 
1889     /**
1890      * @dev Approve `to` to operate on `tokenId`
1891      *
1892      * Emits an {Approval} event.
1893      */
1894     function _approve(address to, uint256 tokenId) internal virtual {
1895         _tokenApprovals[tokenId] = to;
1896         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1897     }
1898 
1899     /**
1900      * @dev Approve `operator` to operate on all of `owner` tokens
1901      *
1902      * Emits an {ApprovalForAll} event.
1903      */
1904     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
1905         require(owner != operator, "ERC721: approve to caller");
1906         _operatorApprovals[owner][operator] = approved;
1907         emit ApprovalForAll(owner, operator, approved);
1908     }
1909 
1910     /**
1911      * @dev Reverts if the `tokenId` has not been minted yet.
1912      */
1913     function _requireMinted(uint256 tokenId) internal view virtual {
1914         require(_exists(tokenId), "ERC721: invalid token ID");
1915     }
1916 
1917     /**
1918      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1919      * The call is not executed if the target address is not a contract.
1920      *
1921      * @param from address representing the previous owner of the given token ID
1922      * @param to target address that will receive the tokens
1923      * @param tokenId uint256 ID of the token to be transferred
1924      * @param data bytes optional data to send along with the call
1925      * @return bool whether the call correctly returned the expected magic value
1926      */
1927     function _checkOnERC721Received(
1928         address from,
1929         address to,
1930         uint256 tokenId,
1931         bytes memory data
1932     ) private returns (bool) {
1933         if (to.isContract()) {
1934             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1935                 return retval == IERC721Receiver.onERC721Received.selector;
1936             } catch (bytes memory reason) {
1937                 if (reason.length == 0) {
1938                     revert("ERC721: transfer to non ERC721Receiver implementer");
1939                 } else {
1940                     /// @solidity memory-safe-assembly
1941                     assembly {
1942                         revert(add(32, reason), mload(reason))
1943                     }
1944                 }
1945             }
1946         } else {
1947             return true;
1948         }
1949     }
1950 
1951     /**
1952      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1953      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1954      *
1955      * Calling conditions:
1956      *
1957      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1958      * - When `from` is zero, the tokens will be minted for `to`.
1959      * - When `to` is zero, ``from``'s tokens will be burned.
1960      * - `from` and `to` are never both zero.
1961      * - `batchSize` is non-zero.
1962      *
1963      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1964      */
1965     function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
1966 
1967     /**
1968      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1969      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1970      *
1971      * Calling conditions:
1972      *
1973      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1974      * - When `from` is zero, the tokens were minted for `to`.
1975      * - When `to` is zero, ``from``'s tokens were burned.
1976      * - `from` and `to` are never both zero.
1977      * - `batchSize` is non-zero.
1978      *
1979      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1980      */
1981     function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
1982 
1983     /**
1984      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
1985      *
1986      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
1987      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
1988      * that `ownerOf(tokenId)` is `a`.
1989      */
1990     // solhint-disable-next-line func-name-mixedcase
1991     function __unsafe_increaseBalance(address account, uint256 amount) internal {
1992         _balances[account] += amount;
1993     }
1994 }
1995 //File： fs://c12714761c8944bd80e2bf619fc588ca/NFT/PlanetMan.sol
1996 
1997 pragma solidity ^0.8.18;
1998 
1999 
2000 
2001 
2002 
2003 
2004 
2005 contract PlanetMan is ERC721, Ownable, ERC2981, DefaultOperatorFilterer {
2006 
2007     constructor(
2008         string memory _baseURI,
2009         address receiver,
2010         uint96 feeNumerator
2011     ) ERC721("PlanetMan", "PlanetMan") {
2012         tokenIdByRarity[0] = 7000;
2013         tokenIdByRarity[1] = 2000;
2014         tokenIdByRarity[2] = 500;
2015         tokenIdByRarity[3] = 50;
2016         tokenIdByRarity[4] = 0;
2017         baseURI = _baseURI;
2018         _setDefaultRoyalty(receiver, feeNumerator);
2019     }
2020 
2021 /** Metadata of PlanetMan **/
2022     string public baseURI;
2023 
2024     function setBaseURI(string memory newBaseURI) public onlyOwner {
2025         baseURI = newBaseURI;
2026     }
2027 
2028     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2029         require(_exists(tokenId), "PlanetMan: Token not exist.");
2030         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json")) : "";
2031     }
2032 
2033 /** Free Mint Whitelist **/
2034     bytes32 public merkleRoot;
2035 
2036     function setWhitelist(bytes32 _merkleRoot) public onlyOwner {
2037         merkleRoot = _merkleRoot;
2038     }
2039 
2040     function verify(address sender, uint256 _rarity, bytes32[] calldata merkleProof) public view returns (bool) {
2041         bytes32 leaf = keccak256(abi.encodePacked(sender, _rarity));
2042         return MerkleProof.verify(merkleProof, merkleRoot, leaf);
2043     }
2044 
2045 /** Mint **/
2046     /* Status */
2047     bool public Open;
2048 
2049     function setOpen(bool _Open) public onlyOwner {
2050         Open = _Open;
2051     }
2052 
2053     /* Quantity */
2054     uint256 public totalSupply;
2055 
2056     uint256 public immutable Max = 10000;
2057 
2058     uint256[] public maxRarity  = [3000, 5000, 1500, 450, 50];
2059 
2060     uint256[] public maxPublic  = [3000, 4850, 1420, 435, 45];
2061 
2062     uint256[] public maxAirdrop = [   0,  150,   50,   0,  0];
2063 
2064     uint256[] public maxReserve = [   0,    0,   30,  15,  5];
2065 
2066     mapping (uint256 => uint256) public numberMinted;    /* Quantity minted for every rarity */
2067 
2068     mapping (uint256 => uint256) public numberAirdroped; /* Quantity airdroped for every rarity */
2069 
2070     mapping (uint256 => uint256) public numberReserved;  /* Quantity reserved for every rarity */
2071 
2072     /* Price */
2073     uint256[] public Price = [0 ether, 0.02 ether, 0.08 ether, 0.2 ether, 0.5 ether];
2074 
2075     /* Rarity */
2076     mapping (uint256 => uint256) public tokenIdByRarity; /* Track minting progress of different rarity */
2077 
2078     mapping (uint256 => uint256) private rarity; /* Mapping tokenId to Rarity */
2079 
2080     function Rarity(uint256 tokenId) public view returns (uint256) {
2081         require(_exists(tokenId), "PlanetMan: Token not exist.");
2082         return rarity[tokenId];
2083     }
2084 
2085     /* Mint Limit */
2086     mapping (address => mapping(uint256 => bool)) public alreadyMinted;
2087 
2088     event mintRecord(address indexed owner, uint256 indexed tokenId, uint256 indexed time);
2089 
2090     /* Public Mint */
2091     function Mint(address owner, uint256 _rarity, bytes32[] calldata merkleProof) public payable {
2092         require(Open, "PlanetMan: Mint is closed.");
2093         require(tx.origin == msg.sender, "PlanetMan: Contracts are not allowed.");
2094         require(_rarity < 5, "PlanetMan: Incorrect rarity inputs.");
2095         require(!alreadyMinted[owner][_rarity], "PlanetMan: Limit 1 per rarity.");
2096         require(totalSupply < Max, "PlanetMan: Exceed the max supply.");
2097         require(numberMinted[_rarity] < maxPublic[_rarity], "PlanetMan: Exceed the public mint limit of that rarity.");
2098         uint256 _Price = Price[_rarity];
2099         if (!verify(owner, _rarity, merkleProof)) {
2100             require(msg.value >= _Price, "PlanetMan: Not enough payment.");
2101         }
2102         tokenIdByRarity[_rarity] ++;
2103         uint256 tokenId = tokenIdByRarity[_rarity];
2104 
2105         _safeMint(owner, tokenId);
2106 
2107         numberMinted[_rarity] ++;
2108         totalSupply ++;
2109         rarity[tokenId] = _rarity;
2110         alreadyMinted[owner][_rarity] = true;
2111 
2112         emit mintRecord(owner, tokenId, block.timestamp);
2113     }
2114 
2115     /* Airdrop Mint */
2116     function Airdrop(address owner, uint256 _rarity) public onlyOwner {
2117         require(_rarity < 5, "PlanetMan: Incorrect rarity inputs.");
2118         require(totalSupply < Max, "PlanetMan: Exceed the max supply.");
2119         require(numberAirdroped[_rarity] < maxAirdrop[_rarity], "PlanetMan: Exceed the airdrop limit of that rarity.");
2120         tokenIdByRarity[_rarity] ++;
2121         uint256 tokenId = tokenIdByRarity[_rarity];
2122 
2123         _safeMint(owner, tokenId);
2124 
2125         numberAirdroped[_rarity] ++;
2126         totalSupply ++;
2127         rarity[tokenId] = _rarity;
2128 
2129         emit mintRecord(owner, tokenId, block.timestamp);
2130     }
2131 
2132     /* Reserve Mint */
2133     function Reserve(address _reserve, uint256 _rarity) public onlyOwner {
2134         require(_rarity < 5, "PlanetMan: Incorrect rarity inputs.");
2135         require(numberReserved[_rarity] < maxReserve[_rarity], "PlanetMan: Exceed the reserve limit of that rarity.");
2136         require(totalSupply < Max, "PlanetMan: Exceed the max supply.");
2137         tokenIdByRarity[_rarity] ++;
2138         uint256 tokenId = tokenIdByRarity[_rarity];
2139 
2140         _safeMint(_reserve, tokenId);
2141         
2142         numberReserved[_rarity] ++;
2143         totalSupply ++;
2144         rarity[tokenId] = _rarity;
2145 
2146         emit mintRecord(_reserve, tokenId, block.timestamp);
2147     }
2148 
2149 /** Binding Tokens With Wallet Address **/
2150     mapping (address => uint256[]) public wallet_token;
2151 
2152     function getAllTokens(address owner) public view returns (uint256[] memory) {
2153         return wallet_token[owner];
2154     }
2155 
2156     function addToken(address user, uint256 tokenId) internal {
2157         wallet_token[user].push(tokenId);
2158     }
2159 
2160     function removeToken(address user, uint256 tokenId) internal {
2161         uint256[] storage token = wallet_token[user];
2162         for (uint256 i=0; i<token.length; i++) {
2163             if(token[i] == tokenId) {
2164                 token[i] = token[token.length - 1];
2165                 token.pop();
2166                 break;
2167             }
2168         }
2169     }
2170 
2171     function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual override {
2172         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
2173         for (uint256 i=0; i<batchSize; i++) {
2174             uint256 tokenId = firstTokenId + i;
2175             if (from != address(0)) {
2176                 removeToken(from, tokenId);
2177             }
2178             if (to != address(0)) {
2179                 addToken(to, tokenId);
2180             }
2181         }
2182     }
2183 
2184 /** Royalty **/
2185     function setRoyaltyInfo(address receiver, uint96 feeNumerator) external onlyOwner {
2186         _setDefaultRoyalty(receiver, feeNumerator);
2187     }
2188 
2189     function setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) external onlyOwner {
2190         _setTokenRoyalty(tokenId, receiver, feeNumerator);
2191     }
2192 
2193     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2194         super.setApprovalForAll(operator, approved);
2195     }
2196 
2197     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2198         super.approve(operator, tokenId);
2199     }
2200 
2201     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2202         super.transferFrom(from, to, tokenId);
2203     }
2204 
2205     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2206         super.safeTransferFrom(from, to, tokenId);
2207     }
2208 
2209     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2210         public
2211         override
2212         onlyAllowedOperator(from)
2213     {
2214         super.safeTransferFrom(from, to, tokenId, data);
2215     }
2216 
2217     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
2218         return super.supportsInterface(interfaceId);
2219     }
2220 
2221 /** Withdraw **/
2222     function Withdraw(address recipient) public payable onlyOwner {
2223         payable(recipient).transfer(address(this).balance);
2224     }
2225 }