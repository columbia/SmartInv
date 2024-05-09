1 // SPDX-License-Identifier: MIT
2 
3 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
4 
5 
6 pragma solidity ^0.8.13;
7 
8 interface IOperatorFilterRegistry {
9     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
10     function register(address registrant) external;
11     function registerAndSubscribe(address registrant, address subscription) external;
12     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
13     function updateOperator(address registrant, address operator, bool filtered) external;
14     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
15     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
16     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
17     function subscribe(address registrant, address registrantToSubscribe) external;
18     function unsubscribe(address registrant, bool copyExistingEntries) external;
19     function subscriptionOf(address addr) external returns (address registrant);
20     function subscribers(address registrant) external returns (address[] memory);
21     function subscriberAt(address registrant, uint256 index) external returns (address);
22     function copyEntriesOf(address registrant, address registrantToCopy) external;
23     function isOperatorFiltered(address registrant, address operator) external returns (bool);
24     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
25     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
26     function filteredOperators(address addr) external returns (address[] memory);
27     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
28     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
29     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
30     function isRegistered(address addr) external returns (bool);
31     function codeHashOf(address addr) external returns (bytes32);
32 }
33 
34 // File: operator-filter-registry/src/OperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 abstract contract OperatorFilterer {
41     error OperatorNotAllowed(address operator);
42 
43     IOperatorFilterRegistry constant operatorFilterRegistry =
44         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
45 
46     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
47         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
48         // will not revert, but the contract will need to be registered with the registry once it is deployed in
49         // order for the modifier to filter addresses.
50         if (address(operatorFilterRegistry).code.length > 0) {
51             if (subscribe) {
52                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
53             } else {
54                 if (subscriptionOrRegistrantToCopy != address(0)) {
55                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
56                 } else {
57                     operatorFilterRegistry.register(address(this));
58                 }
59             }
60         }
61     }
62 
63     modifier onlyAllowedOperator(address from) virtual {
64         // Check registry code length to facilitate testing in environments without a deployed registry.
65         if (address(operatorFilterRegistry).code.length > 0) {
66             // Allow spending tokens from addresses with balance
67             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
68             // from an EOA.
69             if (from == msg.sender) {
70                 _;
71                 return;
72             }
73             if (
74                 !(
75                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
76                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
77                 )
78             ) {
79                 revert OperatorNotAllowed(msg.sender);
80             }
81         }
82         _;
83     }
84 }
85 
86 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
87 
88 
89 pragma solidity ^0.8.13;
90 
91 
92 abstract contract DefaultOperatorFilterer is OperatorFilterer {
93     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
94 
95     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
96 }
97 
98 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
99 
100 
101 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev These functions deal with verification of Merkle Tree proofs.
107  *
108  * The tree and the proofs can be generated using our
109  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
110  * You will find a quickstart guide in the readme.
111  *
112  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
113  * hashing, or use a hash function other than keccak256 for hashing leaves.
114  * This is because the concatenation of a sorted pair of internal nodes in
115  * the merkle tree could be reinterpreted as a leaf value.
116  * OpenZeppelin's JavaScript library generates merkle trees that are safe
117  * against this attack out of the box.
118  */
119 library MerkleProof {
120     /**
121      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
122      * defined by `root`. For this, a `proof` must be provided, containing
123      * sibling hashes on the branch from the leaf to the root of the tree. Each
124      * pair of leaves and each pair of pre-images are assumed to be sorted.
125      */
126     function verify(
127         bytes32[] memory proof,
128         bytes32 root,
129         bytes32 leaf
130     ) internal pure returns (bool) {
131         return processProof(proof, leaf) == root;
132     }
133 
134     /**
135      * @dev Calldata version of {verify}
136      *
137      * _Available since v4.7._
138      */
139     function verifyCalldata(
140         bytes32[] calldata proof,
141         bytes32 root,
142         bytes32 leaf
143     ) internal pure returns (bool) {
144         return processProofCalldata(proof, leaf) == root;
145     }
146 
147     /**
148      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
149      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
150      * hash matches the root of the tree. When processing the proof, the pairs
151      * of leafs & pre-images are assumed to be sorted.
152      *
153      * _Available since v4.4._
154      */
155     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
156         bytes32 computedHash = leaf;
157         for (uint256 i = 0; i < proof.length; i++) {
158             computedHash = _hashPair(computedHash, proof[i]);
159         }
160         return computedHash;
161     }
162 
163     /**
164      * @dev Calldata version of {processProof}
165      *
166      * _Available since v4.7._
167      */
168     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
169         bytes32 computedHash = leaf;
170         for (uint256 i = 0; i < proof.length; i++) {
171             computedHash = _hashPair(computedHash, proof[i]);
172         }
173         return computedHash;
174     }
175 
176     /**
177      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
178      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
179      *
180      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
181      *
182      * _Available since v4.7._
183      */
184     function multiProofVerify(
185         bytes32[] memory proof,
186         bool[] memory proofFlags,
187         bytes32 root,
188         bytes32[] memory leaves
189     ) internal pure returns (bool) {
190         return processMultiProof(proof, proofFlags, leaves) == root;
191     }
192 
193     /**
194      * @dev Calldata version of {multiProofVerify}
195      *
196      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
197      *
198      * _Available since v4.7._
199      */
200     function multiProofVerifyCalldata(
201         bytes32[] calldata proof,
202         bool[] calldata proofFlags,
203         bytes32 root,
204         bytes32[] memory leaves
205     ) internal pure returns (bool) {
206         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
207     }
208 
209     /**
210      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
211      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
212      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
213      * respectively.
214      *
215      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
216      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
217      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
218      *
219      * _Available since v4.7._
220      */
221     function processMultiProof(
222         bytes32[] memory proof,
223         bool[] memory proofFlags,
224         bytes32[] memory leaves
225     ) internal pure returns (bytes32 merkleRoot) {
226         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
227         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
228         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
229         // the merkle tree.
230         uint256 leavesLen = leaves.length;
231         uint256 totalHashes = proofFlags.length;
232 
233         // Check proof validity.
234         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
235 
236         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
237         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
238         bytes32[] memory hashes = new bytes32[](totalHashes);
239         uint256 leafPos = 0;
240         uint256 hashPos = 0;
241         uint256 proofPos = 0;
242         // At each step, we compute the next hash using two values:
243         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
244         //   get the next hash.
245         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
246         //   `proof` array.
247         for (uint256 i = 0; i < totalHashes; i++) {
248             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
249             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
250             hashes[i] = _hashPair(a, b);
251         }
252 
253         if (totalHashes > 0) {
254             return hashes[totalHashes - 1];
255         } else if (leavesLen > 0) {
256             return leaves[0];
257         } else {
258             return proof[0];
259         }
260     }
261 
262     /**
263      * @dev Calldata version of {processMultiProof}.
264      *
265      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
266      *
267      * _Available since v4.7._
268      */
269     function processMultiProofCalldata(
270         bytes32[] calldata proof,
271         bool[] calldata proofFlags,
272         bytes32[] memory leaves
273     ) internal pure returns (bytes32 merkleRoot) {
274         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
275         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
276         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
277         // the merkle tree.
278         uint256 leavesLen = leaves.length;
279         uint256 totalHashes = proofFlags.length;
280 
281         // Check proof validity.
282         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
283 
284         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
285         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
286         bytes32[] memory hashes = new bytes32[](totalHashes);
287         uint256 leafPos = 0;
288         uint256 hashPos = 0;
289         uint256 proofPos = 0;
290         // At each step, we compute the next hash using two values:
291         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
292         //   get the next hash.
293         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
294         //   `proof` array.
295         for (uint256 i = 0; i < totalHashes; i++) {
296             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
297             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
298             hashes[i] = _hashPair(a, b);
299         }
300 
301         if (totalHashes > 0) {
302             return hashes[totalHashes - 1];
303         } else if (leavesLen > 0) {
304             return leaves[0];
305         } else {
306             return proof[0];
307         }
308     }
309 
310     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
311         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
312     }
313 
314     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
315         /// @solidity memory-safe-assembly
316         assembly {
317             mstore(0x00, a)
318             mstore(0x20, b)
319             value := keccak256(0x00, 0x40)
320         }
321     }
322 }
323 
324 // File: @openzeppelin/contracts/utils/math/Math.sol
325 
326 
327 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Standard math utilities missing in the Solidity language.
333  */
334 library Math {
335     enum Rounding {
336         Down, // Toward negative infinity
337         Up, // Toward infinity
338         Zero // Toward zero
339     }
340 
341     /**
342      * @dev Returns the largest of two numbers.
343      */
344     function max(uint256 a, uint256 b) internal pure returns (uint256) {
345         return a > b ? a : b;
346     }
347 
348     /**
349      * @dev Returns the smallest of two numbers.
350      */
351     function min(uint256 a, uint256 b) internal pure returns (uint256) {
352         return a < b ? a : b;
353     }
354 
355     /**
356      * @dev Returns the average of two numbers. The result is rounded towards
357      * zero.
358      */
359     function average(uint256 a, uint256 b) internal pure returns (uint256) {
360         // (a + b) / 2 can overflow.
361         return (a & b) + (a ^ b) / 2;
362     }
363 
364     /**
365      * @dev Returns the ceiling of the division of two numbers.
366      *
367      * This differs from standard division with `/` in that it rounds up instead
368      * of rounding down.
369      */
370     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
371         // (a + b - 1) / b can overflow on addition, so we distribute.
372         return a == 0 ? 0 : (a - 1) / b + 1;
373     }
374 
375     /**
376      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
377      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
378      * with further edits by Uniswap Labs also under MIT license.
379      */
380     function mulDiv(
381         uint256 x,
382         uint256 y,
383         uint256 denominator
384     ) internal pure returns (uint256 result) {
385         unchecked {
386             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
387             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
388             // variables such that product = prod1 * 2^256 + prod0.
389             uint256 prod0; // Least significant 256 bits of the product
390             uint256 prod1; // Most significant 256 bits of the product
391             assembly {
392                 let mm := mulmod(x, y, not(0))
393                 prod0 := mul(x, y)
394                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
395             }
396 
397             // Handle non-overflow cases, 256 by 256 division.
398             if (prod1 == 0) {
399                 return prod0 / denominator;
400             }
401 
402             // Make sure the result is less than 2^256. Also prevents denominator == 0.
403             require(denominator > prod1);
404 
405             ///////////////////////////////////////////////
406             // 512 by 256 division.
407             ///////////////////////////////////////////////
408 
409             // Make division exact by subtracting the remainder from [prod1 prod0].
410             uint256 remainder;
411             assembly {
412                 // Compute remainder using mulmod.
413                 remainder := mulmod(x, y, denominator)
414 
415                 // Subtract 256 bit number from 512 bit number.
416                 prod1 := sub(prod1, gt(remainder, prod0))
417                 prod0 := sub(prod0, remainder)
418             }
419 
420             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
421             // See https://cs.stackexchange.com/q/138556/92363.
422 
423             // Does not overflow because the denominator cannot be zero at this stage in the function.
424             uint256 twos = denominator & (~denominator + 1);
425             assembly {
426                 // Divide denominator by twos.
427                 denominator := div(denominator, twos)
428 
429                 // Divide [prod1 prod0] by twos.
430                 prod0 := div(prod0, twos)
431 
432                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
433                 twos := add(div(sub(0, twos), twos), 1)
434             }
435 
436             // Shift in bits from prod1 into prod0.
437             prod0 |= prod1 * twos;
438 
439             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
440             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
441             // four bits. That is, denominator * inv = 1 mod 2^4.
442             uint256 inverse = (3 * denominator) ^ 2;
443 
444             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
445             // in modular arithmetic, doubling the correct bits in each step.
446             inverse *= 2 - denominator * inverse; // inverse mod 2^8
447             inverse *= 2 - denominator * inverse; // inverse mod 2^16
448             inverse *= 2 - denominator * inverse; // inverse mod 2^32
449             inverse *= 2 - denominator * inverse; // inverse mod 2^64
450             inverse *= 2 - denominator * inverse; // inverse mod 2^128
451             inverse *= 2 - denominator * inverse; // inverse mod 2^256
452 
453             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
454             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
455             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
456             // is no longer required.
457             result = prod0 * inverse;
458             return result;
459         }
460     }
461 
462     /**
463      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
464      */
465     function mulDiv(
466         uint256 x,
467         uint256 y,
468         uint256 denominator,
469         Rounding rounding
470     ) internal pure returns (uint256) {
471         uint256 result = mulDiv(x, y, denominator);
472         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
473             result += 1;
474         }
475         return result;
476     }
477 
478     /**
479      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
480      *
481      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
482      */
483     function sqrt(uint256 a) internal pure returns (uint256) {
484         if (a == 0) {
485             return 0;
486         }
487 
488         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
489         //
490         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
491         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
492         //
493         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
494         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
495         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
496         //
497         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
498         uint256 result = 1 << (log2(a) >> 1);
499 
500         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
501         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
502         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
503         // into the expected uint128 result.
504         unchecked {
505             result = (result + a / result) >> 1;
506             result = (result + a / result) >> 1;
507             result = (result + a / result) >> 1;
508             result = (result + a / result) >> 1;
509             result = (result + a / result) >> 1;
510             result = (result + a / result) >> 1;
511             result = (result + a / result) >> 1;
512             return min(result, a / result);
513         }
514     }
515 
516     /**
517      * @notice Calculates sqrt(a), following the selected rounding direction.
518      */
519     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
520         unchecked {
521             uint256 result = sqrt(a);
522             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
523         }
524     }
525 
526     /**
527      * @dev Return the log in base 2, rounded down, of a positive value.
528      * Returns 0 if given 0.
529      */
530     function log2(uint256 value) internal pure returns (uint256) {
531         uint256 result = 0;
532         unchecked {
533             if (value >> 128 > 0) {
534                 value >>= 128;
535                 result += 128;
536             }
537             if (value >> 64 > 0) {
538                 value >>= 64;
539                 result += 64;
540             }
541             if (value >> 32 > 0) {
542                 value >>= 32;
543                 result += 32;
544             }
545             if (value >> 16 > 0) {
546                 value >>= 16;
547                 result += 16;
548             }
549             if (value >> 8 > 0) {
550                 value >>= 8;
551                 result += 8;
552             }
553             if (value >> 4 > 0) {
554                 value >>= 4;
555                 result += 4;
556             }
557             if (value >> 2 > 0) {
558                 value >>= 2;
559                 result += 2;
560             }
561             if (value >> 1 > 0) {
562                 result += 1;
563             }
564         }
565         return result;
566     }
567 
568     /**
569      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
570      * Returns 0 if given 0.
571      */
572     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
573         unchecked {
574             uint256 result = log2(value);
575             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
576         }
577     }
578 
579     /**
580      * @dev Return the log in base 10, rounded down, of a positive value.
581      * Returns 0 if given 0.
582      */
583     function log10(uint256 value) internal pure returns (uint256) {
584         uint256 result = 0;
585         unchecked {
586             if (value >= 10**64) {
587                 value /= 10**64;
588                 result += 64;
589             }
590             if (value >= 10**32) {
591                 value /= 10**32;
592                 result += 32;
593             }
594             if (value >= 10**16) {
595                 value /= 10**16;
596                 result += 16;
597             }
598             if (value >= 10**8) {
599                 value /= 10**8;
600                 result += 8;
601             }
602             if (value >= 10**4) {
603                 value /= 10**4;
604                 result += 4;
605             }
606             if (value >= 10**2) {
607                 value /= 10**2;
608                 result += 2;
609             }
610             if (value >= 10**1) {
611                 result += 1;
612             }
613         }
614         return result;
615     }
616 
617     /**
618      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
619      * Returns 0 if given 0.
620      */
621     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
622         unchecked {
623             uint256 result = log10(value);
624             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
625         }
626     }
627 
628     /**
629      * @dev Return the log in base 256, rounded down, of a positive value.
630      * Returns 0 if given 0.
631      *
632      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
633      */
634     function log256(uint256 value) internal pure returns (uint256) {
635         uint256 result = 0;
636         unchecked {
637             if (value >> 128 > 0) {
638                 value >>= 128;
639                 result += 16;
640             }
641             if (value >> 64 > 0) {
642                 value >>= 64;
643                 result += 8;
644             }
645             if (value >> 32 > 0) {
646                 value >>= 32;
647                 result += 4;
648             }
649             if (value >> 16 > 0) {
650                 value >>= 16;
651                 result += 2;
652             }
653             if (value >> 8 > 0) {
654                 result += 1;
655             }
656         }
657         return result;
658     }
659 
660     /**
661      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
662      * Returns 0 if given 0.
663      */
664     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
665         unchecked {
666             uint256 result = log256(value);
667             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
668         }
669     }
670 }
671 
672 // File: @openzeppelin/contracts/utils/Strings.sol
673 
674 
675 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 
680 /**
681  * @dev String operations.
682  */
683 library Strings {
684     bytes16 private constant _SYMBOLS = "0123456789abcdef";
685     uint8 private constant _ADDRESS_LENGTH = 20;
686 
687     /**
688      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
689      */
690     function toString(uint256 value) internal pure returns (string memory) {
691         unchecked {
692             uint256 length = Math.log10(value) + 1;
693             string memory buffer = new string(length);
694             uint256 ptr;
695             /// @solidity memory-safe-assembly
696             assembly {
697                 ptr := add(buffer, add(32, length))
698             }
699             while (true) {
700                 ptr--;
701                 /// @solidity memory-safe-assembly
702                 assembly {
703                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
704                 }
705                 value /= 10;
706                 if (value == 0) break;
707             }
708             return buffer;
709         }
710     }
711 
712     /**
713      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
714      */
715     function toHexString(uint256 value) internal pure returns (string memory) {
716         unchecked {
717             return toHexString(value, Math.log256(value) + 1);
718         }
719     }
720 
721     /**
722      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
723      */
724     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
725         bytes memory buffer = new bytes(2 * length + 2);
726         buffer[0] = "0";
727         buffer[1] = "x";
728         for (uint256 i = 2 * length + 1; i > 1; --i) {
729             buffer[i] = _SYMBOLS[value & 0xf];
730             value >>= 4;
731         }
732         require(value == 0, "Strings: hex length insufficient");
733         return string(buffer);
734     }
735 
736     /**
737      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
738      */
739     function toHexString(address addr) internal pure returns (string memory) {
740         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
741     }
742 }
743 
744 // File: @openzeppelin/contracts/utils/Context.sol
745 
746 
747 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 /**
752  * @dev Provides information about the current execution context, including the
753  * sender of the transaction and its data. While these are generally available
754  * via msg.sender and msg.data, they should not be accessed in such a direct
755  * manner, since when dealing with meta-transactions the account sending and
756  * paying for execution may not be the actual sender (as far as an application
757  * is concerned).
758  *
759  * This contract is only required for intermediate, library-like contracts.
760  */
761 abstract contract Context {
762     function _msgSender() internal view virtual returns (address) {
763         return msg.sender;
764     }
765 
766     function _msgData() internal view virtual returns (bytes calldata) {
767         return msg.data;
768     }
769 }
770 
771 // File: @openzeppelin/contracts/access/Ownable.sol
772 
773 
774 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
775 
776 pragma solidity ^0.8.0;
777 
778 
779 /**
780  * @dev Contract module which provides a basic access control mechanism, where
781  * there is an account (an owner) that can be granted exclusive access to
782  * specific functions.
783  *
784  * By default, the owner account will be the one that deploys the contract. This
785  * can later be changed with {transferOwnership}.
786  *
787  * This module is used through inheritance. It will make available the modifier
788  * `onlyOwner`, which can be applied to your functions to restrict their use to
789  * the owner.
790  */
791 abstract contract Ownable is Context {
792     address private _owner;
793 
794     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
795 
796     /**
797      * @dev Initializes the contract setting the deployer as the initial owner.
798      */
799     constructor() {
800         _transferOwnership(_msgSender());
801     }
802 
803     /**
804      * @dev Throws if called by any account other than the owner.
805      */
806     modifier onlyOwner() {
807         _checkOwner();
808         _;
809     }
810 
811     /**
812      * @dev Returns the address of the current owner.
813      */
814     function owner() public view virtual returns (address) {
815         return _owner;
816     }
817 
818     /**
819      * @dev Throws if the sender is not the owner.
820      */
821     function _checkOwner() internal view virtual {
822         require(owner() == _msgSender(), "Ownable: caller is not the owner");
823     }
824 
825     /**
826      * @dev Leaves the contract without owner. It will not be possible to call
827      * `onlyOwner` functions anymore. Can only be called by the current owner.
828      *
829      * NOTE: Renouncing ownership will leave the contract without an owner,
830      * thereby removing any functionality that is only available to the owner.
831      */
832     function renounceOwnership() public virtual onlyOwner {
833         _transferOwnership(address(0));
834     }
835 
836     /**
837      * @dev Transfers ownership of the contract to a new account (`newOwner`).
838      * Can only be called by the current owner.
839      */
840     function transferOwnership(address newOwner) public virtual onlyOwner {
841         require(newOwner != address(0), "Ownable: new owner is the zero address");
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
856 // File: erc721a/contracts/IERC721A.sol
857 
858 
859 // ERC721A Contracts v4.2.3
860 // Creator: Chiru Labs
861 
862 pragma solidity ^0.8.4;
863 
864 /**
865  * @dev Interface of ERC721A.
866  */
867 interface IERC721A {
868     /**
869      * The caller must own the token or be an approved operator.
870      */
871     error ApprovalCallerNotOwnerNorApproved();
872 
873     /**
874      * The token does not exist.
875      */
876     error ApprovalQueryForNonexistentToken();
877 
878     /**
879      * Cannot query the balance for the zero address.
880      */
881     error BalanceQueryForZeroAddress();
882 
883     /**
884      * Cannot mint to the zero address.
885      */
886     error MintToZeroAddress();
887 
888     /**
889      * The quantity of tokens minted must be more than zero.
890      */
891     error MintZeroQuantity();
892 
893     /**
894      * The token does not exist.
895      */
896     error OwnerQueryForNonexistentToken();
897 
898     /**
899      * The caller must own the token or be an approved operator.
900      */
901     error TransferCallerNotOwnerNorApproved();
902 
903     /**
904      * The token must be owned by `from`.
905      */
906     error TransferFromIncorrectOwner();
907 
908     /**
909      * Cannot safely transfer to a contract that does not implement the
910      * ERC721Receiver interface.
911      */
912     error TransferToNonERC721ReceiverImplementer();
913 
914     /**
915      * Cannot transfer to the zero address.
916      */
917     error TransferToZeroAddress();
918 
919     /**
920      * The token does not exist.
921      */
922     error URIQueryForNonexistentToken();
923 
924     /**
925      * The `quantity` minted with ERC2309 exceeds the safety limit.
926      */
927     error MintERC2309QuantityExceedsLimit();
928 
929     /**
930      * The `extraData` cannot be set on an unintialized ownership slot.
931      */
932     error OwnershipNotInitializedForExtraData();
933 
934     // =============================================================
935     //                            STRUCTS
936     // =============================================================
937 
938     struct TokenOwnership {
939         // The address of the owner.
940         address addr;
941         // Stores the start time of ownership with minimal overhead for tokenomics.
942         uint64 startTimestamp;
943         // Whether the token has been burned.
944         bool burned;
945         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
946         uint24 extraData;
947     }
948 
949     // =============================================================
950     //                         TOKEN COUNTERS
951     // =============================================================
952 
953     /**
954      * @dev Returns the total number of tokens in existence.
955      * Burned tokens will reduce the count.
956      * To get the total number of tokens minted, please see {_totalMinted}.
957      */
958     function totalSupply() external view returns (uint256);
959 
960     // =============================================================
961     //                            IERC165
962     // =============================================================
963 
964     /**
965      * @dev Returns true if this contract implements the interface defined by
966      * `interfaceId`. See the corresponding
967      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
968      * to learn more about how these ids are created.
969      *
970      * This function call must use less than 30000 gas.
971      */
972     function supportsInterface(bytes4 interfaceId) external view returns (bool);
973 
974     // =============================================================
975     //                            IERC721
976     // =============================================================
977 
978     /**
979      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
980      */
981     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
982 
983     /**
984      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
985      */
986     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
987 
988     /**
989      * @dev Emitted when `owner` enables or disables
990      * (`approved`) `operator` to manage all of its assets.
991      */
992     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
993 
994     /**
995      * @dev Returns the number of tokens in `owner`'s account.
996      */
997     function balanceOf(address owner) external view returns (uint256 balance);
998 
999     /**
1000      * @dev Returns the owner of the `tokenId` token.
1001      *
1002      * Requirements:
1003      *
1004      * - `tokenId` must exist.
1005      */
1006     function ownerOf(uint256 tokenId) external view returns (address owner);
1007 
1008     /**
1009      * @dev Safely transfers `tokenId` token from `from` to `to`,
1010      * checking first that contract recipients are aware of the ERC721 protocol
1011      * to prevent tokens from being forever locked.
1012      *
1013      * Requirements:
1014      *
1015      * - `from` cannot be the zero address.
1016      * - `to` cannot be the zero address.
1017      * - `tokenId` token must exist and be owned by `from`.
1018      * - If the caller is not `from`, it must be have been allowed to move
1019      * this token by either {approve} or {setApprovalForAll}.
1020      * - If `to` refers to a smart contract, it must implement
1021      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId,
1029         bytes calldata data
1030     ) external payable;
1031 
1032     /**
1033      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) external payable;
1040 
1041     /**
1042      * @dev Transfers `tokenId` from `from` to `to`.
1043      *
1044      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1045      * whenever possible.
1046      *
1047      * Requirements:
1048      *
1049      * - `from` cannot be the zero address.
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must be owned by `from`.
1052      * - If the caller is not `from`, it must be approved to move this token
1053      * by either {approve} or {setApprovalForAll}.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function transferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId
1061     ) external payable;
1062 
1063     /**
1064      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1065      * The approval is cleared when the token is transferred.
1066      *
1067      * Only a single account can be approved at a time, so approving the
1068      * zero address clears previous approvals.
1069      *
1070      * Requirements:
1071      *
1072      * - The caller must own the token or be an approved operator.
1073      * - `tokenId` must exist.
1074      *
1075      * Emits an {Approval} event.
1076      */
1077     function approve(address to, uint256 tokenId) external payable;
1078 
1079     /**
1080      * @dev Approve or remove `operator` as an operator for the caller.
1081      * Operators can call {transferFrom} or {safeTransferFrom}
1082      * for any token owned by the caller.
1083      *
1084      * Requirements:
1085      *
1086      * - The `operator` cannot be the caller.
1087      *
1088      * Emits an {ApprovalForAll} event.
1089      */
1090     function setApprovalForAll(address operator, bool _approved) external;
1091 
1092     /**
1093      * @dev Returns the account approved for `tokenId` token.
1094      *
1095      * Requirements:
1096      *
1097      * - `tokenId` must exist.
1098      */
1099     function getApproved(uint256 tokenId) external view returns (address operator);
1100 
1101     /**
1102      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1103      *
1104      * See {setApprovalForAll}.
1105      */
1106     function isApprovedForAll(address owner, address operator) external view returns (bool);
1107 
1108     // =============================================================
1109     //                        IERC721Metadata
1110     // =============================================================
1111 
1112     /**
1113      * @dev Returns the token collection name.
1114      */
1115     function name() external view returns (string memory);
1116 
1117     /**
1118      * @dev Returns the token collection symbol.
1119      */
1120     function symbol() external view returns (string memory);
1121 
1122     /**
1123      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1124      */
1125     function tokenURI(uint256 tokenId) external view returns (string memory);
1126 
1127     // =============================================================
1128     //                           IERC2309
1129     // =============================================================
1130 
1131     /**
1132      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1133      * (inclusive) is transferred from `from` to `to`, as defined in the
1134      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1135      *
1136      * See {_mintERC2309} for more details.
1137      */
1138     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1139 }
1140 
1141 // File: erc721a/contracts/ERC721A.sol
1142 
1143 
1144 // ERC721A Contracts v4.2.3
1145 // Creator: Chiru Labs
1146 
1147 pragma solidity ^0.8.4;
1148 
1149 
1150 /**
1151  * @dev Interface of ERC721 token receiver.
1152  */
1153 interface ERC721A__IERC721Receiver {
1154     function onERC721Received(
1155         address operator,
1156         address from,
1157         uint256 tokenId,
1158         bytes calldata data
1159     ) external returns (bytes4);
1160 }
1161 
1162 /**
1163  * @title ERC721A
1164  *
1165  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1166  * Non-Fungible Token Standard, including the Metadata extension.
1167  * Optimized for lower gas during batch mints.
1168  *
1169  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1170  * starting from `_startTokenId()`.
1171  *
1172  * Assumptions:
1173  *
1174  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1175  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1176  */
1177 contract ERC721A is IERC721A {
1178     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1179     struct TokenApprovalRef {
1180         address value;
1181     }
1182 
1183     // =============================================================
1184     //                           CONSTANTS
1185     // =============================================================
1186 
1187     // Mask of an entry in packed address data.
1188     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1189 
1190     // The bit position of `numberMinted` in packed address data.
1191     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1192 
1193     // The bit position of `numberBurned` in packed address data.
1194     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1195 
1196     // The bit position of `aux` in packed address data.
1197     uint256 private constant _BITPOS_AUX = 192;
1198 
1199     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1200     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1201 
1202     // The bit position of `startTimestamp` in packed ownership.
1203     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1204 
1205     // The bit mask of the `burned` bit in packed ownership.
1206     uint256 private constant _BITMASK_BURNED = 1 << 224;
1207 
1208     // The bit position of the `nextInitialized` bit in packed ownership.
1209     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1210 
1211     // The bit mask of the `nextInitialized` bit in packed ownership.
1212     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1213 
1214     // The bit position of `extraData` in packed ownership.
1215     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1216 
1217     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1218     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1219 
1220     // The mask of the lower 160 bits for addresses.
1221     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1222 
1223     // The maximum `quantity` that can be minted with {_mintERC2309}.
1224     // This limit is to prevent overflows on the address data entries.
1225     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1226     // is required to cause an overflow, which is unrealistic.
1227     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1228 
1229     // The `Transfer` event signature is given by:
1230     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1231     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1232         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1233 
1234     // =============================================================
1235     //                            STORAGE
1236     // =============================================================
1237 
1238     // The next token ID to be minted.
1239     uint256 private _currentIndex;
1240 
1241     // The number of tokens burned.
1242     uint256 private _burnCounter;
1243 
1244     // Token name
1245     string private _name;
1246 
1247     // Token symbol
1248     string private _symbol;
1249 
1250     // Mapping from token ID to ownership details
1251     // An empty struct value does not necessarily mean the token is unowned.
1252     // See {_packedOwnershipOf} implementation for details.
1253     //
1254     // Bits Layout:
1255     // - [0..159]   `addr`
1256     // - [160..223] `startTimestamp`
1257     // - [224]      `burned`
1258     // - [225]      `nextInitialized`
1259     // - [232..255] `extraData`
1260     mapping(uint256 => uint256) private _packedOwnerships;
1261 
1262     // Mapping owner address to address data.
1263     //
1264     // Bits Layout:
1265     // - [0..63]    `balance`
1266     // - [64..127]  `numberMinted`
1267     // - [128..191] `numberBurned`
1268     // - [192..255] `aux`
1269     mapping(address => uint256) private _packedAddressData;
1270 
1271     // Mapping from token ID to approved address.
1272     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1273 
1274     // Mapping from owner to operator approvals
1275     mapping(address => mapping(address => bool)) private _operatorApprovals;
1276 
1277     // =============================================================
1278     //                          CONSTRUCTOR
1279     // =============================================================
1280 
1281     constructor(string memory name_, string memory symbol_) {
1282         _name = name_;
1283         _symbol = symbol_;
1284         _currentIndex = _startTokenId();
1285     }
1286 
1287     // =============================================================
1288     //                   TOKEN COUNTING OPERATIONS
1289     // =============================================================
1290 
1291     /**
1292      * @dev Returns the starting token ID.
1293      * To change the starting token ID, please override this function.
1294      */
1295     function _startTokenId() internal view virtual returns (uint256) {
1296         return 0;
1297     }
1298 
1299     /**
1300      * @dev Returns the next token ID to be minted.
1301      */
1302     function _nextTokenId() internal view virtual returns (uint256) {
1303         return _currentIndex;
1304     }
1305 
1306     /**
1307      * @dev Returns the total number of tokens in existence.
1308      * Burned tokens will reduce the count.
1309      * To get the total number of tokens minted, please see {_totalMinted}.
1310      */
1311     function totalSupply() public view virtual override returns (uint256) {
1312         // Counter underflow is impossible as _burnCounter cannot be incremented
1313         // more than `_currentIndex - _startTokenId()` times.
1314         unchecked {
1315             return _currentIndex - _burnCounter - _startTokenId();
1316         }
1317     }
1318 
1319     /**
1320      * @dev Returns the total amount of tokens minted in the contract.
1321      */
1322     function _totalMinted() internal view virtual returns (uint256) {
1323         // Counter underflow is impossible as `_currentIndex` does not decrement,
1324         // and it is initialized to `_startTokenId()`.
1325         unchecked {
1326             return _currentIndex - _startTokenId();
1327         }
1328     }
1329 
1330     /**
1331      * @dev Returns the total number of tokens burned.
1332      */
1333     function _totalBurned() internal view virtual returns (uint256) {
1334         return _burnCounter;
1335     }
1336 
1337     // =============================================================
1338     //                    ADDRESS DATA OPERATIONS
1339     // =============================================================
1340 
1341     /**
1342      * @dev Returns the number of tokens in `owner`'s account.
1343      */
1344     function balanceOf(address owner) public view virtual override returns (uint256) {
1345         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1346         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1347     }
1348 
1349     /**
1350      * Returns the number of tokens minted by `owner`.
1351      */
1352     function _numberMinted(address owner) internal view returns (uint256) {
1353         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1354     }
1355 
1356     /**
1357      * Returns the number of tokens burned by or on behalf of `owner`.
1358      */
1359     function _numberBurned(address owner) internal view returns (uint256) {
1360         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1361     }
1362 
1363     /**
1364      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1365      */
1366     function _getAux(address owner) internal view returns (uint64) {
1367         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1368     }
1369 
1370     /**
1371      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1372      * If there are multiple variables, please pack them into a uint64.
1373      */
1374     function _setAux(address owner, uint64 aux) internal virtual {
1375         uint256 packed = _packedAddressData[owner];
1376         uint256 auxCasted;
1377         // Cast `aux` with assembly to avoid redundant masking.
1378         assembly {
1379             auxCasted := aux
1380         }
1381         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1382         _packedAddressData[owner] = packed;
1383     }
1384 
1385     // =============================================================
1386     //                            IERC165
1387     // =============================================================
1388 
1389     /**
1390      * @dev Returns true if this contract implements the interface defined by
1391      * `interfaceId`. See the corresponding
1392      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1393      * to learn more about how these ids are created.
1394      *
1395      * This function call must use less than 30000 gas.
1396      */
1397     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1398         // The interface IDs are constants representing the first 4 bytes
1399         // of the XOR of all function selectors in the interface.
1400         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1401         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1402         return
1403             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1404             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1405             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1406     }
1407 
1408     // =============================================================
1409     //                        IERC721Metadata
1410     // =============================================================
1411 
1412     /**
1413      * @dev Returns the token collection name.
1414      */
1415     function name() public view virtual override returns (string memory) {
1416         return _name;
1417     }
1418 
1419     /**
1420      * @dev Returns the token collection symbol.
1421      */
1422     function symbol() public view virtual override returns (string memory) {
1423         return _symbol;
1424     }
1425 
1426     /**
1427      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1428      */
1429     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1430         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1431 
1432         string memory baseURI = _baseURI();
1433         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1434     }
1435 
1436     /**
1437      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1438      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1439      * by default, it can be overridden in child contracts.
1440      */
1441     function _baseURI() internal view virtual returns (string memory) {
1442         return '';
1443     }
1444 
1445     // =============================================================
1446     //                     OWNERSHIPS OPERATIONS
1447     // =============================================================
1448 
1449     /**
1450      * @dev Returns the owner of the `tokenId` token.
1451      *
1452      * Requirements:
1453      *
1454      * - `tokenId` must exist.
1455      */
1456     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1457         return address(uint160(_packedOwnershipOf(tokenId)));
1458     }
1459 
1460     /**
1461      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1462      * It gradually moves to O(1) as tokens get transferred around over time.
1463      */
1464     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1465         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1466     }
1467 
1468     /**
1469      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1470      */
1471     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1472         return _unpackedOwnership(_packedOwnerships[index]);
1473     }
1474 
1475     /**
1476      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1477      */
1478     function _initializeOwnershipAt(uint256 index) internal virtual {
1479         if (_packedOwnerships[index] == 0) {
1480             _packedOwnerships[index] = _packedOwnershipOf(index);
1481         }
1482     }
1483 
1484     /**
1485      * Returns the packed ownership data of `tokenId`.
1486      */
1487     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1488         uint256 curr = tokenId;
1489 
1490         unchecked {
1491             if (_startTokenId() <= curr)
1492                 if (curr < _currentIndex) {
1493                     uint256 packed = _packedOwnerships[curr];
1494                     // If not burned.
1495                     if (packed & _BITMASK_BURNED == 0) {
1496                         // Invariant:
1497                         // There will always be an initialized ownership slot
1498                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1499                         // before an unintialized ownership slot
1500                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1501                         // Hence, `curr` will not underflow.
1502                         //
1503                         // We can directly compare the packed value.
1504                         // If the address is zero, packed will be zero.
1505                         while (packed == 0) {
1506                             packed = _packedOwnerships[--curr];
1507                         }
1508                         return packed;
1509                     }
1510                 }
1511         }
1512         revert OwnerQueryForNonexistentToken();
1513     }
1514 
1515     /**
1516      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1517      */
1518     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1519         ownership.addr = address(uint160(packed));
1520         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1521         ownership.burned = packed & _BITMASK_BURNED != 0;
1522         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1523     }
1524 
1525     /**
1526      * @dev Packs ownership data into a single uint256.
1527      */
1528     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1529         assembly {
1530             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1531             owner := and(owner, _BITMASK_ADDRESS)
1532             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1533             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1534         }
1535     }
1536 
1537     /**
1538      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1539      */
1540     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1541         // For branchless setting of the `nextInitialized` flag.
1542         assembly {
1543             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1544             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1545         }
1546     }
1547 
1548     // =============================================================
1549     //                      APPROVAL OPERATIONS
1550     // =============================================================
1551 
1552     /**
1553      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1554      * The approval is cleared when the token is transferred.
1555      *
1556      * Only a single account can be approved at a time, so approving the
1557      * zero address clears previous approvals.
1558      *
1559      * Requirements:
1560      *
1561      * - The caller must own the token or be an approved operator.
1562      * - `tokenId` must exist.
1563      *
1564      * Emits an {Approval} event.
1565      */
1566     function approve(address to, uint256 tokenId) public payable virtual override {
1567         address owner = ownerOf(tokenId);
1568 
1569         if (_msgSenderERC721A() != owner)
1570             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1571                 revert ApprovalCallerNotOwnerNorApproved();
1572             }
1573 
1574         _tokenApprovals[tokenId].value = to;
1575         emit Approval(owner, to, tokenId);
1576     }
1577 
1578     /**
1579      * @dev Returns the account approved for `tokenId` token.
1580      *
1581      * Requirements:
1582      *
1583      * - `tokenId` must exist.
1584      */
1585     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1586         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1587 
1588         return _tokenApprovals[tokenId].value;
1589     }
1590 
1591     /**
1592      * @dev Approve or remove `operator` as an operator for the caller.
1593      * Operators can call {transferFrom} or {safeTransferFrom}
1594      * for any token owned by the caller.
1595      *
1596      * Requirements:
1597      *
1598      * - The `operator` cannot be the caller.
1599      *
1600      * Emits an {ApprovalForAll} event.
1601      */
1602     function setApprovalForAll(address operator, bool approved) public virtual override {
1603         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1604         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1605     }
1606 
1607     /**
1608      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1609      *
1610      * See {setApprovalForAll}.
1611      */
1612     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1613         return _operatorApprovals[owner][operator];
1614     }
1615 
1616     /**
1617      * @dev Returns whether `tokenId` exists.
1618      *
1619      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1620      *
1621      * Tokens start existing when they are minted. See {_mint}.
1622      */
1623     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1624         return
1625             _startTokenId() <= tokenId &&
1626             tokenId < _currentIndex && // If within bounds,
1627             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1628     }
1629 
1630     /**
1631      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1632      */
1633     function _isSenderApprovedOrOwner(
1634         address approvedAddress,
1635         address owner,
1636         address msgSender
1637     ) private pure returns (bool result) {
1638         assembly {
1639             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1640             owner := and(owner, _BITMASK_ADDRESS)
1641             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1642             msgSender := and(msgSender, _BITMASK_ADDRESS)
1643             // `msgSender == owner || msgSender == approvedAddress`.
1644             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1645         }
1646     }
1647 
1648     /**
1649      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1650      */
1651     function _getApprovedSlotAndAddress(uint256 tokenId)
1652         private
1653         view
1654         returns (uint256 approvedAddressSlot, address approvedAddress)
1655     {
1656         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1657         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1658         assembly {
1659             approvedAddressSlot := tokenApproval.slot
1660             approvedAddress := sload(approvedAddressSlot)
1661         }
1662     }
1663 
1664     // =============================================================
1665     //                      TRANSFER OPERATIONS
1666     // =============================================================
1667 
1668     /**
1669      * @dev Transfers `tokenId` from `from` to `to`.
1670      *
1671      * Requirements:
1672      *
1673      * - `from` cannot be the zero address.
1674      * - `to` cannot be the zero address.
1675      * - `tokenId` token must be owned by `from`.
1676      * - If the caller is not `from`, it must be approved to move this token
1677      * by either {approve} or {setApprovalForAll}.
1678      *
1679      * Emits a {Transfer} event.
1680      */
1681     function transferFrom(
1682         address from,
1683         address to,
1684         uint256 tokenId
1685     ) public payable virtual override {
1686         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1687 
1688         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1689 
1690         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1691 
1692         // The nested ifs save around 20+ gas over a compound boolean condition.
1693         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1694             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1695 
1696         if (to == address(0)) revert TransferToZeroAddress();
1697 
1698         _beforeTokenTransfers(from, to, tokenId, 1);
1699 
1700         // Clear approvals from the previous owner.
1701         assembly {
1702             if approvedAddress {
1703                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1704                 sstore(approvedAddressSlot, 0)
1705             }
1706         }
1707 
1708         // Underflow of the sender's balance is impossible because we check for
1709         // ownership above and the recipient's balance can't realistically overflow.
1710         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1711         unchecked {
1712             // We can directly increment and decrement the balances.
1713             --_packedAddressData[from]; // Updates: `balance -= 1`.
1714             ++_packedAddressData[to]; // Updates: `balance += 1`.
1715 
1716             // Updates:
1717             // - `address` to the next owner.
1718             // - `startTimestamp` to the timestamp of transfering.
1719             // - `burned` to `false`.
1720             // - `nextInitialized` to `true`.
1721             _packedOwnerships[tokenId] = _packOwnershipData(
1722                 to,
1723                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1724             );
1725 
1726             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1727             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1728                 uint256 nextTokenId = tokenId + 1;
1729                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1730                 if (_packedOwnerships[nextTokenId] == 0) {
1731                     // If the next slot is within bounds.
1732                     if (nextTokenId != _currentIndex) {
1733                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1734                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1735                     }
1736                 }
1737             }
1738         }
1739 
1740         emit Transfer(from, to, tokenId);
1741         _afterTokenTransfers(from, to, tokenId, 1);
1742     }
1743 
1744     /**
1745      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1746      */
1747     function safeTransferFrom(
1748         address from,
1749         address to,
1750         uint256 tokenId
1751     ) public payable virtual override {
1752         safeTransferFrom(from, to, tokenId, '');
1753     }
1754 
1755     /**
1756      * @dev Safely transfers `tokenId` token from `from` to `to`.
1757      *
1758      * Requirements:
1759      *
1760      * - `from` cannot be the zero address.
1761      * - `to` cannot be the zero address.
1762      * - `tokenId` token must exist and be owned by `from`.
1763      * - If the caller is not `from`, it must be approved to move this token
1764      * by either {approve} or {setApprovalForAll}.
1765      * - If `to` refers to a smart contract, it must implement
1766      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1767      *
1768      * Emits a {Transfer} event.
1769      */
1770     function safeTransferFrom(
1771         address from,
1772         address to,
1773         uint256 tokenId,
1774         bytes memory _data
1775     ) public payable virtual override {
1776         transferFrom(from, to, tokenId);
1777         if (to.code.length != 0)
1778             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1779                 revert TransferToNonERC721ReceiverImplementer();
1780             }
1781     }
1782 
1783     /**
1784      * @dev Hook that is called before a set of serially-ordered token IDs
1785      * are about to be transferred. This includes minting.
1786      * And also called before burning one token.
1787      *
1788      * `startTokenId` - the first token ID to be transferred.
1789      * `quantity` - the amount to be transferred.
1790      *
1791      * Calling conditions:
1792      *
1793      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1794      * transferred to `to`.
1795      * - When `from` is zero, `tokenId` will be minted for `to`.
1796      * - When `to` is zero, `tokenId` will be burned by `from`.
1797      * - `from` and `to` are never both zero.
1798      */
1799     function _beforeTokenTransfers(
1800         address from,
1801         address to,
1802         uint256 startTokenId,
1803         uint256 quantity
1804     ) internal virtual {}
1805 
1806     /**
1807      * @dev Hook that is called after a set of serially-ordered token IDs
1808      * have been transferred. This includes minting.
1809      * And also called after one token has been burned.
1810      *
1811      * `startTokenId` - the first token ID to be transferred.
1812      * `quantity` - the amount to be transferred.
1813      *
1814      * Calling conditions:
1815      *
1816      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1817      * transferred to `to`.
1818      * - When `from` is zero, `tokenId` has been minted for `to`.
1819      * - When `to` is zero, `tokenId` has been burned by `from`.
1820      * - `from` and `to` are never both zero.
1821      */
1822     function _afterTokenTransfers(
1823         address from,
1824         address to,
1825         uint256 startTokenId,
1826         uint256 quantity
1827     ) internal virtual {}
1828 
1829     /**
1830      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1831      *
1832      * `from` - Previous owner of the given token ID.
1833      * `to` - Target address that will receive the token.
1834      * `tokenId` - Token ID to be transferred.
1835      * `_data` - Optional data to send along with the call.
1836      *
1837      * Returns whether the call correctly returned the expected magic value.
1838      */
1839     function _checkContractOnERC721Received(
1840         address from,
1841         address to,
1842         uint256 tokenId,
1843         bytes memory _data
1844     ) private returns (bool) {
1845         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1846             bytes4 retval
1847         ) {
1848             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1849         } catch (bytes memory reason) {
1850             if (reason.length == 0) {
1851                 revert TransferToNonERC721ReceiverImplementer();
1852             } else {
1853                 assembly {
1854                     revert(add(32, reason), mload(reason))
1855                 }
1856             }
1857         }
1858     }
1859 
1860     // =============================================================
1861     //                        MINT OPERATIONS
1862     // =============================================================
1863 
1864     /**
1865      * @dev Mints `quantity` tokens and transfers them to `to`.
1866      *
1867      * Requirements:
1868      *
1869      * - `to` cannot be the zero address.
1870      * - `quantity` must be greater than 0.
1871      *
1872      * Emits a {Transfer} event for each mint.
1873      */
1874     function _mint(address to, uint256 quantity) internal virtual {
1875         uint256 startTokenId = _currentIndex;
1876         if (quantity == 0) revert MintZeroQuantity();
1877 
1878         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1879 
1880         // Overflows are incredibly unrealistic.
1881         // `balance` and `numberMinted` have a maximum limit of 2**64.
1882         // `tokenId` has a maximum limit of 2**256.
1883         unchecked {
1884             // Updates:
1885             // - `balance += quantity`.
1886             // - `numberMinted += quantity`.
1887             //
1888             // We can directly add to the `balance` and `numberMinted`.
1889             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1890 
1891             // Updates:
1892             // - `address` to the owner.
1893             // - `startTimestamp` to the timestamp of minting.
1894             // - `burned` to `false`.
1895             // - `nextInitialized` to `quantity == 1`.
1896             _packedOwnerships[startTokenId] = _packOwnershipData(
1897                 to,
1898                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1899             );
1900 
1901             uint256 toMasked;
1902             uint256 end = startTokenId + quantity;
1903 
1904             // Use assembly to loop and emit the `Transfer` event for gas savings.
1905             // The duplicated `log4` removes an extra check and reduces stack juggling.
1906             // The assembly, together with the surrounding Solidity code, have been
1907             // delicately arranged to nudge the compiler into producing optimized opcodes.
1908             assembly {
1909                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1910                 toMasked := and(to, _BITMASK_ADDRESS)
1911                 // Emit the `Transfer` event.
1912                 log4(
1913                     0, // Start of data (0, since no data).
1914                     0, // End of data (0, since no data).
1915                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1916                     0, // `address(0)`.
1917                     toMasked, // `to`.
1918                     startTokenId // `tokenId`.
1919                 )
1920 
1921                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1922                 // that overflows uint256 will make the loop run out of gas.
1923                 // The compiler will optimize the `iszero` away for performance.
1924                 for {
1925                     let tokenId := add(startTokenId, 1)
1926                 } iszero(eq(tokenId, end)) {
1927                     tokenId := add(tokenId, 1)
1928                 } {
1929                     // Emit the `Transfer` event. Similar to above.
1930                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1931                 }
1932             }
1933             if (toMasked == 0) revert MintToZeroAddress();
1934 
1935             _currentIndex = end;
1936         }
1937         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1938     }
1939 
1940     /**
1941      * @dev Mints `quantity` tokens and transfers them to `to`.
1942      *
1943      * This function is intended for efficient minting only during contract creation.
1944      *
1945      * It emits only one {ConsecutiveTransfer} as defined in
1946      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1947      * instead of a sequence of {Transfer} event(s).
1948      *
1949      * Calling this function outside of contract creation WILL make your contract
1950      * non-compliant with the ERC721 standard.
1951      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1952      * {ConsecutiveTransfer} event is only permissible during contract creation.
1953      *
1954      * Requirements:
1955      *
1956      * - `to` cannot be the zero address.
1957      * - `quantity` must be greater than 0.
1958      *
1959      * Emits a {ConsecutiveTransfer} event.
1960      */
1961     function _mintERC2309(address to, uint256 quantity) internal virtual {
1962         uint256 startTokenId = _currentIndex;
1963         if (to == address(0)) revert MintToZeroAddress();
1964         if (quantity == 0) revert MintZeroQuantity();
1965         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1966 
1967         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1968 
1969         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1970         unchecked {
1971             // Updates:
1972             // - `balance += quantity`.
1973             // - `numberMinted += quantity`.
1974             //
1975             // We can directly add to the `balance` and `numberMinted`.
1976             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1977 
1978             // Updates:
1979             // - `address` to the owner.
1980             // - `startTimestamp` to the timestamp of minting.
1981             // - `burned` to `false`.
1982             // - `nextInitialized` to `quantity == 1`.
1983             _packedOwnerships[startTokenId] = _packOwnershipData(
1984                 to,
1985                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1986             );
1987 
1988             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1989 
1990             _currentIndex = startTokenId + quantity;
1991         }
1992         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1993     }
1994 
1995     /**
1996      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1997      *
1998      * Requirements:
1999      *
2000      * - If `to` refers to a smart contract, it must implement
2001      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2002      * - `quantity` must be greater than 0.
2003      *
2004      * See {_mint}.
2005      *
2006      * Emits a {Transfer} event for each mint.
2007      */
2008     function _safeMint(
2009         address to,
2010         uint256 quantity,
2011         bytes memory _data
2012     ) internal virtual {
2013         _mint(to, quantity);
2014 
2015         unchecked {
2016             if (to.code.length != 0) {
2017                 uint256 end = _currentIndex;
2018                 uint256 index = end - quantity;
2019                 do {
2020                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2021                         revert TransferToNonERC721ReceiverImplementer();
2022                     }
2023                 } while (index < end);
2024                 // Reentrancy protection.
2025                 if (_currentIndex != end) revert();
2026             }
2027         }
2028     }
2029 
2030     /**
2031      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2032      */
2033     function _safeMint(address to, uint256 quantity) internal virtual {
2034         _safeMint(to, quantity, '');
2035     }
2036 
2037     // =============================================================
2038     //                        BURN OPERATIONS
2039     // =============================================================
2040 
2041     /**
2042      * @dev Equivalent to `_burn(tokenId, false)`.
2043      */
2044     function _burn(uint256 tokenId) internal virtual {
2045         _burn(tokenId, false);
2046     }
2047 
2048     /**
2049      * @dev Destroys `tokenId`.
2050      * The approval is cleared when the token is burned.
2051      *
2052      * Requirements:
2053      *
2054      * - `tokenId` must exist.
2055      *
2056      * Emits a {Transfer} event.
2057      */
2058     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2059         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2060 
2061         address from = address(uint160(prevOwnershipPacked));
2062 
2063         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2064 
2065         if (approvalCheck) {
2066             // The nested ifs save around 20+ gas over a compound boolean condition.
2067             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2068                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2069         }
2070 
2071         _beforeTokenTransfers(from, address(0), tokenId, 1);
2072 
2073         // Clear approvals from the previous owner.
2074         assembly {
2075             if approvedAddress {
2076                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2077                 sstore(approvedAddressSlot, 0)
2078             }
2079         }
2080 
2081         // Underflow of the sender's balance is impossible because we check for
2082         // ownership above and the recipient's balance can't realistically overflow.
2083         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2084         unchecked {
2085             // Updates:
2086             // - `balance -= 1`.
2087             // - `numberBurned += 1`.
2088             //
2089             // We can directly decrement the balance, and increment the number burned.
2090             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2091             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2092 
2093             // Updates:
2094             // - `address` to the last owner.
2095             // - `startTimestamp` to the timestamp of burning.
2096             // - `burned` to `true`.
2097             // - `nextInitialized` to `true`.
2098             _packedOwnerships[tokenId] = _packOwnershipData(
2099                 from,
2100                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2101             );
2102 
2103             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2104             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2105                 uint256 nextTokenId = tokenId + 1;
2106                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2107                 if (_packedOwnerships[nextTokenId] == 0) {
2108                     // If the next slot is within bounds.
2109                     if (nextTokenId != _currentIndex) {
2110                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2111                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2112                     }
2113                 }
2114             }
2115         }
2116 
2117         emit Transfer(from, address(0), tokenId);
2118         _afterTokenTransfers(from, address(0), tokenId, 1);
2119 
2120         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2121         unchecked {
2122             _burnCounter++;
2123         }
2124     }
2125 
2126     // =============================================================
2127     //                     EXTRA DATA OPERATIONS
2128     // =============================================================
2129 
2130     /**
2131      * @dev Directly sets the extra data for the ownership data `index`.
2132      */
2133     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2134         uint256 packed = _packedOwnerships[index];
2135         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2136         uint256 extraDataCasted;
2137         // Cast `extraData` with assembly to avoid redundant masking.
2138         assembly {
2139             extraDataCasted := extraData
2140         }
2141         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2142         _packedOwnerships[index] = packed;
2143     }
2144 
2145     /**
2146      * @dev Called during each token transfer to set the 24bit `extraData` field.
2147      * Intended to be overridden by the cosumer contract.
2148      *
2149      * `previousExtraData` - the value of `extraData` before transfer.
2150      *
2151      * Calling conditions:
2152      *
2153      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2154      * transferred to `to`.
2155      * - When `from` is zero, `tokenId` will be minted for `to`.
2156      * - When `to` is zero, `tokenId` will be burned by `from`.
2157      * - `from` and `to` are never both zero.
2158      */
2159     function _extraData(
2160         address from,
2161         address to,
2162         uint24 previousExtraData
2163     ) internal view virtual returns (uint24) {}
2164 
2165     /**
2166      * @dev Returns the next extra data for the packed ownership data.
2167      * The returned result is shifted into position.
2168      */
2169     function _nextExtraData(
2170         address from,
2171         address to,
2172         uint256 prevOwnershipPacked
2173     ) private view returns (uint256) {
2174         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2175         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2176     }
2177 
2178     // =============================================================
2179     //                       OTHER OPERATIONS
2180     // =============================================================
2181 
2182     /**
2183      * @dev Returns the message sender (defaults to `msg.sender`).
2184      *
2185      * If you are writing GSN compatible contracts, you need to override this function.
2186      */
2187     function _msgSenderERC721A() internal view virtual returns (address) {
2188         return msg.sender;
2189     }
2190 
2191     /**
2192      * @dev Converts a uint256 to its ASCII string decimal representation.
2193      */
2194     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2195         assembly {
2196             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2197             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2198             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2199             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2200             let m := add(mload(0x40), 0xa0)
2201             // Update the free memory pointer to allocate.
2202             mstore(0x40, m)
2203             // Assign the `str` to the end.
2204             str := sub(m, 0x20)
2205             // Zeroize the slot after the string.
2206             mstore(str, 0)
2207 
2208             // Cache the end of the memory to calculate the length later.
2209             let end := str
2210 
2211             // We write the string from rightmost digit to leftmost digit.
2212             // The following is essentially a do-while loop that also handles the zero case.
2213             // prettier-ignore
2214             for { let temp := value } 1 {} {
2215                 str := sub(str, 1)
2216                 // Write the character to the pointer.
2217                 // The ASCII index of the '0' character is 48.
2218                 mstore8(str, add(48, mod(temp, 10)))
2219                 // Keep dividing `temp` until zero.
2220                 temp := div(temp, 10)
2221                 // prettier-ignore
2222                 if iszero(temp) { break }
2223             }
2224 
2225             let length := sub(end, str)
2226             // Move the pointer 32 bytes leftwards to make room for the length.
2227             str := sub(str, 0x20)
2228             // Store the length.
2229             mstore(str, length)
2230         }
2231     }
2232 }
2233 
2234 // File: contracts/pandoramint.sol
2235 
2236 
2237 pragma solidity ^0.8.4;
2238 
2239 
2240 
2241 
2242 
2243 
2244 contract Pandora is ERC721A, DefaultOperatorFilterer, Ownable {
2245     enum SaleStates {
2246         CLOSED,
2247         PUBLIC,
2248         WHITELIST
2249     }
2250 
2251     SaleStates public saleState;
2252 
2253     bytes32 public whitelistMerkleRoot;
2254 
2255     uint256 public maxSupply = 3333;
2256     uint256 public maxPublicTokens = 2556;
2257     uint256 public publicSalePrice = 0.022 ether;
2258 
2259     uint64 public maxPublicTokensPerWallet = 3;
2260     uint64 public maxWLTokensPerWallet = 1;
2261 
2262     string public baseURL;
2263     string public unRevealedURL;
2264 
2265     bool public isRevealed = false;
2266 
2267     constructor() ERC721A("Pandora", "PANDORA") {
2268         _mintERC2309(msg.sender, 25);
2269     }
2270 
2271     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
2272         require(
2273             MerkleProof.verify(
2274                 merkleProof,
2275                 root,
2276                 keccak256(abi.encodePacked(msg.sender))
2277             ),
2278             "Address does not exist in list"
2279         );
2280         _;
2281     }
2282 
2283     modifier canMint(uint256 numberOfTokens) {
2284         require(
2285             _totalMinted() + numberOfTokens <= maxSupply,
2286             "Not enough tokens remaining to mint"
2287         );
2288         _;
2289     }
2290 
2291     modifier checkState(SaleStates _saleState) {
2292         require(saleState == _saleState, "sale is not active");
2293         _;
2294     }
2295 
2296     function whitelistMint(
2297         bytes32[] calldata merkleProof,
2298         uint64 numberOfTokens
2299     )
2300         external
2301         isValidMerkleProof(merkleProof, whitelistMerkleRoot)
2302         canMint(numberOfTokens)
2303         checkState(SaleStates.WHITELIST)
2304     {
2305         uint64 userAuxilary = _getAux(msg.sender);
2306         require(
2307             userAuxilary + numberOfTokens <= maxWLTokensPerWallet,
2308             "Maximum minting limit exceeded"
2309         );
2310 
2311         /// @dev Set non-zero auxilary value to acknowledge that the caller has claimed their token.
2312         _setAux(msg.sender, userAuxilary + numberOfTokens);
2313 
2314         _mint(msg.sender, numberOfTokens);
2315     }
2316 
2317     function publicMint(uint64 numberOfTokens)
2318         external
2319         payable
2320         canMint(numberOfTokens)
2321         checkState(SaleStates.PUBLIC)
2322     {
2323         require(
2324             _totalMinted() + numberOfTokens <= maxPublicTokens,
2325             "Minted the maximum no of public tokens"
2326         );
2327         require(
2328             (_numberMinted(msg.sender) - _getAux(msg.sender)) +
2329                 numberOfTokens <=
2330                 maxPublicTokensPerWallet,
2331             "Maximum minting limit exceeded"
2332         );
2333 
2334         require(
2335             msg.value >= publicSalePrice * numberOfTokens,
2336             "Not enough ETH"
2337         );
2338 
2339         _mint(msg.sender, numberOfTokens);
2340     }
2341 
2342     function mintTo(address[] memory _to, uint256[] memory _numberOfTokens)
2343         external
2344         onlyOwner
2345     {
2346         require(
2347             _to.length == _numberOfTokens.length,
2348             "invalid arrays of address and number"
2349         );
2350 
2351         for (uint256 i = 0; i < _to.length; i++) {
2352             require(
2353                 _totalMinted() + _numberOfTokens[i] <= maxSupply,
2354                 "Not enough tokens remaining to mint"
2355             );
2356             _mint(_to[i], _numberOfTokens[i]);
2357         }
2358     }
2359 
2360     function tokenURI(uint256 _tokenId)
2361         public
2362         view
2363         override
2364         returns (string memory)
2365     {
2366         require(
2367             _exists(_tokenId),
2368             "ERC721Metadata: URI query for nonexistent token"
2369         );
2370 
2371         if (!isRevealed) {
2372             return unRevealedURL;
2373         }
2374 
2375         string memory currentBaseURI = _baseURI();
2376         return
2377             bytes(currentBaseURI).length > 0
2378                 ? string(
2379                     abi.encodePacked(
2380                         currentBaseURI,
2381                         Strings.toString(_tokenId),
2382                         ".json"
2383                     )
2384                 )
2385                 : "";
2386     }
2387 
2388     function _baseURI() internal view override returns (string memory) {
2389         return baseURL;
2390     }
2391 
2392     function _startTokenId() internal view virtual override returns (uint256) {
2393         return 1;
2394     }
2395 
2396     function numberMintedWl(address _account) external view returns (uint64) {
2397         return _getAux(_account);
2398     }
2399 
2400     function numberMinted(address _account) external view returns (uint256) {
2401         return _numberMinted(_account);
2402     }
2403 
2404     // Metadata
2405     function setBaseURL(string memory _baseURL) external onlyOwner {
2406         baseURL = _baseURL;
2407     }
2408 
2409     function setUnRevealedURL(string memory _unRevealedURL) external onlyOwner {
2410         unRevealedURL = _unRevealedURL;
2411     }
2412 
2413     function toggleRevealed() external onlyOwner {
2414         isRevealed = !isRevealed;
2415     }
2416 
2417     // Sale Price
2418     function setPublicSalePrice(uint256 _price) external onlyOwner {
2419         publicSalePrice = _price;
2420     }
2421 
2422     // CLOSED = 0, PUBLIC = 1, WHITELIST = 2
2423     function setSaleState(uint256 newSaleState) external onlyOwner {
2424         require(
2425             newSaleState <= uint256(SaleStates.WHITELIST),
2426             "sale state not valid"
2427         );
2428         saleState = SaleStates(newSaleState);
2429     }
2430 
2431     // Max Tokens Per Wallet
2432     function setMaxPublicTokensPerWallet(uint64 _maxPublicTokensPerWallet)
2433         external
2434         onlyOwner
2435     {
2436         maxPublicTokensPerWallet = _maxPublicTokensPerWallet;
2437     }
2438 
2439     function setMaxWLTokensPerWallet(uint64 _maxWLTokensPerWallet)
2440         external
2441         onlyOwner
2442     {
2443         maxWLTokensPerWallet = _maxWLTokensPerWallet;
2444     }
2445 
2446     function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2447         whitelistMerkleRoot = merkleRoot;
2448     }
2449 
2450     function setMaxPublicTokens(uint256 _maxPublicTokens) external onlyOwner {
2451         maxPublicTokens = _maxPublicTokens;
2452     }
2453 
2454     function setMaxSupply(uint256 _newMaxSupply) external onlyOwner {
2455         require(
2456             _newMaxSupply < maxSupply,
2457             "max supply cannot be more than current"
2458         );
2459         maxSupply = _newMaxSupply;
2460     }
2461 
2462     function withdraw() external onlyOwner {
2463         (bool ps, ) = payable(0x012D8E2cE2716B260718abE39062A76be15570B3).call{
2464             value: (address(this).balance * 6) / 100
2465         }("");
2466         require(ps);
2467 
2468         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2469         require(os);
2470     }
2471 
2472     function transferFrom(
2473         address from,
2474         address to,
2475         uint256 tokenId
2476     ) public payable override onlyAllowedOperator(from) {
2477         super.transferFrom(from, to, tokenId);
2478     }
2479 
2480     function safeTransferFrom(
2481         address from,
2482         address to,
2483         uint256 tokenId
2484     ) public payable override onlyAllowedOperator(from) {
2485         super.safeTransferFrom(from, to, tokenId);
2486     }
2487 
2488     function safeTransferFrom(
2489         address from,
2490         address to,
2491         uint256 tokenId,
2492         bytes memory data
2493     ) public payable override onlyAllowedOperator(from) {
2494         super.safeTransferFrom(from, to, tokenId, data);
2495     }
2496 }