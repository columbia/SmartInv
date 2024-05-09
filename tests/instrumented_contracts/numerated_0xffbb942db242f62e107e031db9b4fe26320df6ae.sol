1 // File: contracts/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
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
30 }
31 // File: contracts/OperatorFilterer.sol
32 
33 
34 pragma solidity ^0.8.13;
35 
36 
37 abstract contract OperatorFilterer {
38     error OperatorNotAllowed(address operator);
39 
40     IOperatorFilterRegistry constant operatorFilterRegistry =
41         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
42 
43     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
44         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
45         // will not revert, but the contract will need to be registered with the registry once it is deployed in
46         // order for the modifier to filter addresses.
47         if (address(operatorFilterRegistry).code.length > 0) {
48             if (subscribe) {
49                 operatorFilterRegistry.registerAndSubscribe(
50                     address(this),
51                     subscriptionOrRegistrantToCopy
52                 );
53             } else {
54                 if (subscriptionOrRegistrantToCopy != address(0)) {
55                     operatorFilterRegistry.registerAndCopyEntries(
56                         address(this),
57                         subscriptionOrRegistrantToCopy
58                     );
59                 } else {
60                     operatorFilterRegistry.register(address(this));
61                 }
62             }
63         }
64     }
65 
66     modifier onlyAllowedOperator(address from) virtual {
67         // Check registry code length to facilitate testing in environments without a deployed registry.
68         if (address(operatorFilterRegistry).code.length > 0) {
69             // Allow spending tokens from addresses with balance
70             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
71             // from an EOA.
72             if (from == msg.sender) {
73                 _;
74                 return;
75             }
76             if (
77                 !(operatorFilterRegistry.isOperatorAllowed(
78                     address(this),
79                     msg.sender
80                 ) &&
81                     operatorFilterRegistry.isOperatorAllowed(
82                         address(this),
83                         from
84                     ))
85             ) {
86                 revert OperatorNotAllowed(msg.sender);
87             }
88         }
89         _;
90     }
91 }
92 // File: contracts/DefaultOperatorFilterer.sol
93 
94 
95 pragma solidity ^0.8.13;
96 
97 
98 abstract contract DefaultOperatorFilterer is OperatorFilterer {
99     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
100 
101     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
102 }
103 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
104 
105 
106 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev These functions deal with verification of Merkle Tree proofs.
112  *
113  * The tree and the proofs can be generated using our
114  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
115  * You will find a quickstart guide in the readme.
116  *
117  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
118  * hashing, or use a hash function other than keccak256 for hashing leaves.
119  * This is because the concatenation of a sorted pair of internal nodes in
120  * the merkle tree could be reinterpreted as a leaf value.
121  * OpenZeppelin's JavaScript library generates merkle trees that are safe
122  * against this attack out of the box.
123  */
124 library MerkleProof {
125     /**
126      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
127      * defined by `root`. For this, a `proof` must be provided, containing
128      * sibling hashes on the branch from the leaf to the root of the tree. Each
129      * pair of leaves and each pair of pre-images are assumed to be sorted.
130      */
131     function verify(
132         bytes32[] memory proof,
133         bytes32 root,
134         bytes32 leaf
135     ) internal pure returns (bool) {
136         return processProof(proof, leaf) == root;
137     }
138 
139     /**
140      * @dev Calldata version of {verify}
141      *
142      * _Available since v4.7._
143      */
144     function verifyCalldata(
145         bytes32[] calldata proof,
146         bytes32 root,
147         bytes32 leaf
148     ) internal pure returns (bool) {
149         return processProofCalldata(proof, leaf) == root;
150     }
151 
152     /**
153      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
154      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
155      * hash matches the root of the tree. When processing the proof, the pairs
156      * of leafs & pre-images are assumed to be sorted.
157      *
158      * _Available since v4.4._
159      */
160     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
161         bytes32 computedHash = leaf;
162         for (uint256 i = 0; i < proof.length; i++) {
163             computedHash = _hashPair(computedHash, proof[i]);
164         }
165         return computedHash;
166     }
167 
168     /**
169      * @dev Calldata version of {processProof}
170      *
171      * _Available since v4.7._
172      */
173     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
174         bytes32 computedHash = leaf;
175         for (uint256 i = 0; i < proof.length; i++) {
176             computedHash = _hashPair(computedHash, proof[i]);
177         }
178         return computedHash;
179     }
180 
181     /**
182      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
183      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
184      *
185      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
186      *
187      * _Available since v4.7._
188      */
189     function multiProofVerify(
190         bytes32[] memory proof,
191         bool[] memory proofFlags,
192         bytes32 root,
193         bytes32[] memory leaves
194     ) internal pure returns (bool) {
195         return processMultiProof(proof, proofFlags, leaves) == root;
196     }
197 
198     /**
199      * @dev Calldata version of {multiProofVerify}
200      *
201      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
202      *
203      * _Available since v4.7._
204      */
205     function multiProofVerifyCalldata(
206         bytes32[] calldata proof,
207         bool[] calldata proofFlags,
208         bytes32 root,
209         bytes32[] memory leaves
210     ) internal pure returns (bool) {
211         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
212     }
213 
214     /**
215      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
216      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
217      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
218      * respectively.
219      *
220      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
221      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
222      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
223      *
224      * _Available since v4.7._
225      */
226     function processMultiProof(
227         bytes32[] memory proof,
228         bool[] memory proofFlags,
229         bytes32[] memory leaves
230     ) internal pure returns (bytes32 merkleRoot) {
231         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
232         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
233         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
234         // the merkle tree.
235         uint256 leavesLen = leaves.length;
236         uint256 totalHashes = proofFlags.length;
237 
238         // Check proof validity.
239         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
240 
241         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
242         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
243         bytes32[] memory hashes = new bytes32[](totalHashes);
244         uint256 leafPos = 0;
245         uint256 hashPos = 0;
246         uint256 proofPos = 0;
247         // At each step, we compute the next hash using two values:
248         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
249         //   get the next hash.
250         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
251         //   `proof` array.
252         for (uint256 i = 0; i < totalHashes; i++) {
253             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
254             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
255             hashes[i] = _hashPair(a, b);
256         }
257 
258         if (totalHashes > 0) {
259             return hashes[totalHashes - 1];
260         } else if (leavesLen > 0) {
261             return leaves[0];
262         } else {
263             return proof[0];
264         }
265     }
266 
267     /**
268      * @dev Calldata version of {processMultiProof}.
269      *
270      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
271      *
272      * _Available since v4.7._
273      */
274     function processMultiProofCalldata(
275         bytes32[] calldata proof,
276         bool[] calldata proofFlags,
277         bytes32[] memory leaves
278     ) internal pure returns (bytes32 merkleRoot) {
279         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
280         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
281         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
282         // the merkle tree.
283         uint256 leavesLen = leaves.length;
284         uint256 totalHashes = proofFlags.length;
285 
286         // Check proof validity.
287         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
288 
289         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
290         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
291         bytes32[] memory hashes = new bytes32[](totalHashes);
292         uint256 leafPos = 0;
293         uint256 hashPos = 0;
294         uint256 proofPos = 0;
295         // At each step, we compute the next hash using two values:
296         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
297         //   get the next hash.
298         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
299         //   `proof` array.
300         for (uint256 i = 0; i < totalHashes; i++) {
301             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
302             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
303             hashes[i] = _hashPair(a, b);
304         }
305 
306         if (totalHashes > 0) {
307             return hashes[totalHashes - 1];
308         } else if (leavesLen > 0) {
309             return leaves[0];
310         } else {
311             return proof[0];
312         }
313     }
314 
315     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
316         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
317     }
318 
319     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
320         /// @solidity memory-safe-assembly
321         assembly {
322             mstore(0x00, a)
323             mstore(0x20, b)
324             value := keccak256(0x00, 0x40)
325         }
326     }
327 }
328 
329 // File: @openzeppelin/contracts/utils/math/Math.sol
330 
331 
332 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev Standard math utilities missing in the Solidity language.
338  */
339 library Math {
340     enum Rounding {
341         Down, // Toward negative infinity
342         Up, // Toward infinity
343         Zero // Toward zero
344     }
345 
346     /**
347      * @dev Returns the largest of two numbers.
348      */
349     function max(uint256 a, uint256 b) internal pure returns (uint256) {
350         return a > b ? a : b;
351     }
352 
353     /**
354      * @dev Returns the smallest of two numbers.
355      */
356     function min(uint256 a, uint256 b) internal pure returns (uint256) {
357         return a < b ? a : b;
358     }
359 
360     /**
361      * @dev Returns the average of two numbers. The result is rounded towards
362      * zero.
363      */
364     function average(uint256 a, uint256 b) internal pure returns (uint256) {
365         // (a + b) / 2 can overflow.
366         return (a & b) + (a ^ b) / 2;
367     }
368 
369     /**
370      * @dev Returns the ceiling of the division of two numbers.
371      *
372      * This differs from standard division with `/` in that it rounds up instead
373      * of rounding down.
374      */
375     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
376         // (a + b - 1) / b can overflow on addition, so we distribute.
377         return a == 0 ? 0 : (a - 1) / b + 1;
378     }
379 
380     /**
381      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
382      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
383      * with further edits by Uniswap Labs also under MIT license.
384      */
385     function mulDiv(
386         uint256 x,
387         uint256 y,
388         uint256 denominator
389     ) internal pure returns (uint256 result) {
390         unchecked {
391             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
392             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
393             // variables such that product = prod1 * 2^256 + prod0.
394             uint256 prod0; // Least significant 256 bits of the product
395             uint256 prod1; // Most significant 256 bits of the product
396             assembly {
397                 let mm := mulmod(x, y, not(0))
398                 prod0 := mul(x, y)
399                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
400             }
401 
402             // Handle non-overflow cases, 256 by 256 division.
403             if (prod1 == 0) {
404                 return prod0 / denominator;
405             }
406 
407             // Make sure the result is less than 2^256. Also prevents denominator == 0.
408             require(denominator > prod1);
409 
410             ///////////////////////////////////////////////
411             // 512 by 256 division.
412             ///////////////////////////////////////////////
413 
414             // Make division exact by subtracting the remainder from [prod1 prod0].
415             uint256 remainder;
416             assembly {
417                 // Compute remainder using mulmod.
418                 remainder := mulmod(x, y, denominator)
419 
420                 // Subtract 256 bit number from 512 bit number.
421                 prod1 := sub(prod1, gt(remainder, prod0))
422                 prod0 := sub(prod0, remainder)
423             }
424 
425             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
426             // See https://cs.stackexchange.com/q/138556/92363.
427 
428             // Does not overflow because the denominator cannot be zero at this stage in the function.
429             uint256 twos = denominator & (~denominator + 1);
430             assembly {
431                 // Divide denominator by twos.
432                 denominator := div(denominator, twos)
433 
434                 // Divide [prod1 prod0] by twos.
435                 prod0 := div(prod0, twos)
436 
437                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
438                 twos := add(div(sub(0, twos), twos), 1)
439             }
440 
441             // Shift in bits from prod1 into prod0.
442             prod0 |= prod1 * twos;
443 
444             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
445             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
446             // four bits. That is, denominator * inv = 1 mod 2^4.
447             uint256 inverse = (3 * denominator) ^ 2;
448 
449             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
450             // in modular arithmetic, doubling the correct bits in each step.
451             inverse *= 2 - denominator * inverse; // inverse mod 2^8
452             inverse *= 2 - denominator * inverse; // inverse mod 2^16
453             inverse *= 2 - denominator * inverse; // inverse mod 2^32
454             inverse *= 2 - denominator * inverse; // inverse mod 2^64
455             inverse *= 2 - denominator * inverse; // inverse mod 2^128
456             inverse *= 2 - denominator * inverse; // inverse mod 2^256
457 
458             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
459             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
460             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
461             // is no longer required.
462             result = prod0 * inverse;
463             return result;
464         }
465     }
466 
467     /**
468      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
469      */
470     function mulDiv(
471         uint256 x,
472         uint256 y,
473         uint256 denominator,
474         Rounding rounding
475     ) internal pure returns (uint256) {
476         uint256 result = mulDiv(x, y, denominator);
477         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
478             result += 1;
479         }
480         return result;
481     }
482 
483     /**
484      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
485      *
486      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
487      */
488     function sqrt(uint256 a) internal pure returns (uint256) {
489         if (a == 0) {
490             return 0;
491         }
492 
493         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
494         //
495         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
496         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
497         //
498         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
499         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
500         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
501         //
502         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
503         uint256 result = 1 << (log2(a) >> 1);
504 
505         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
506         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
507         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
508         // into the expected uint128 result.
509         unchecked {
510             result = (result + a / result) >> 1;
511             result = (result + a / result) >> 1;
512             result = (result + a / result) >> 1;
513             result = (result + a / result) >> 1;
514             result = (result + a / result) >> 1;
515             result = (result + a / result) >> 1;
516             result = (result + a / result) >> 1;
517             return min(result, a / result);
518         }
519     }
520 
521     /**
522      * @notice Calculates sqrt(a), following the selected rounding direction.
523      */
524     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
525         unchecked {
526             uint256 result = sqrt(a);
527             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
528         }
529     }
530 
531     /**
532      * @dev Return the log in base 2, rounded down, of a positive value.
533      * Returns 0 if given 0.
534      */
535     function log2(uint256 value) internal pure returns (uint256) {
536         uint256 result = 0;
537         unchecked {
538             if (value >> 128 > 0) {
539                 value >>= 128;
540                 result += 128;
541             }
542             if (value >> 64 > 0) {
543                 value >>= 64;
544                 result += 64;
545             }
546             if (value >> 32 > 0) {
547                 value >>= 32;
548                 result += 32;
549             }
550             if (value >> 16 > 0) {
551                 value >>= 16;
552                 result += 16;
553             }
554             if (value >> 8 > 0) {
555                 value >>= 8;
556                 result += 8;
557             }
558             if (value >> 4 > 0) {
559                 value >>= 4;
560                 result += 4;
561             }
562             if (value >> 2 > 0) {
563                 value >>= 2;
564                 result += 2;
565             }
566             if (value >> 1 > 0) {
567                 result += 1;
568             }
569         }
570         return result;
571     }
572 
573     /**
574      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
575      * Returns 0 if given 0.
576      */
577     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
578         unchecked {
579             uint256 result = log2(value);
580             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
581         }
582     }
583 
584     /**
585      * @dev Return the log in base 10, rounded down, of a positive value.
586      * Returns 0 if given 0.
587      */
588     function log10(uint256 value) internal pure returns (uint256) {
589         uint256 result = 0;
590         unchecked {
591             if (value >= 10**64) {
592                 value /= 10**64;
593                 result += 64;
594             }
595             if (value >= 10**32) {
596                 value /= 10**32;
597                 result += 32;
598             }
599             if (value >= 10**16) {
600                 value /= 10**16;
601                 result += 16;
602             }
603             if (value >= 10**8) {
604                 value /= 10**8;
605                 result += 8;
606             }
607             if (value >= 10**4) {
608                 value /= 10**4;
609                 result += 4;
610             }
611             if (value >= 10**2) {
612                 value /= 10**2;
613                 result += 2;
614             }
615             if (value >= 10**1) {
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
626     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
627         unchecked {
628             uint256 result = log10(value);
629             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
630         }
631     }
632 
633     /**
634      * @dev Return the log in base 256, rounded down, of a positive value.
635      * Returns 0 if given 0.
636      *
637      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
638      */
639     function log256(uint256 value) internal pure returns (uint256) {
640         uint256 result = 0;
641         unchecked {
642             if (value >> 128 > 0) {
643                 value >>= 128;
644                 result += 16;
645             }
646             if (value >> 64 > 0) {
647                 value >>= 64;
648                 result += 8;
649             }
650             if (value >> 32 > 0) {
651                 value >>= 32;
652                 result += 4;
653             }
654             if (value >> 16 > 0) {
655                 value >>= 16;
656                 result += 2;
657             }
658             if (value >> 8 > 0) {
659                 result += 1;
660             }
661         }
662         return result;
663     }
664 
665     /**
666      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
667      * Returns 0 if given 0.
668      */
669     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
670         unchecked {
671             uint256 result = log256(value);
672             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
673         }
674     }
675 }
676 
677 // File: @openzeppelin/contracts/utils/Strings.sol
678 
679 
680 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @dev String operations.
687  */
688 library Strings {
689     bytes16 private constant _SYMBOLS = "0123456789abcdef";
690     uint8 private constant _ADDRESS_LENGTH = 20;
691 
692     /**
693      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
694      */
695     function toString(uint256 value) internal pure returns (string memory) {
696         unchecked {
697             uint256 length = Math.log10(value) + 1;
698             string memory buffer = new string(length);
699             uint256 ptr;
700             /// @solidity memory-safe-assembly
701             assembly {
702                 ptr := add(buffer, add(32, length))
703             }
704             while (true) {
705                 ptr--;
706                 /// @solidity memory-safe-assembly
707                 assembly {
708                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
709                 }
710                 value /= 10;
711                 if (value == 0) break;
712             }
713             return buffer;
714         }
715     }
716 
717     /**
718      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
719      */
720     function toHexString(uint256 value) internal pure returns (string memory) {
721         unchecked {
722             return toHexString(value, Math.log256(value) + 1);
723         }
724     }
725 
726     /**
727      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
728      */
729     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
730         bytes memory buffer = new bytes(2 * length + 2);
731         buffer[0] = "0";
732         buffer[1] = "x";
733         for (uint256 i = 2 * length + 1; i > 1; --i) {
734             buffer[i] = _SYMBOLS[value & 0xf];
735             value >>= 4;
736         }
737         require(value == 0, "Strings: hex length insufficient");
738         return string(buffer);
739     }
740 
741     /**
742      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
743      */
744     function toHexString(address addr) internal pure returns (string memory) {
745         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
746     }
747 }
748 
749 // File: @openzeppelin/contracts/utils/Context.sol
750 
751 
752 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 /**
757  * @dev Provides information about the current execution context, including the
758  * sender of the transaction and its data. While these are generally available
759  * via msg.sender and msg.data, they should not be accessed in such a direct
760  * manner, since when dealing with meta-transactions the account sending and
761  * paying for execution may not be the actual sender (as far as an application
762  * is concerned).
763  *
764  * This contract is only required for intermediate, library-like contracts.
765  */
766 abstract contract Context {
767     function _msgSender() internal view virtual returns (address) {
768         return msg.sender;
769     }
770 
771     function _msgData() internal view virtual returns (bytes calldata) {
772         return msg.data;
773     }
774 }
775 
776 // File: @openzeppelin/contracts/access/Ownable.sol
777 
778 
779 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
780 
781 pragma solidity ^0.8.0;
782 
783 
784 /**
785  * @dev Contract module which provides a basic access control mechanism, where
786  * there is an account (an owner) that can be granted exclusive access to
787  * specific functions.
788  *
789  * By default, the owner account will be the one that deploys the contract. This
790  * can later be changed with {transferOwnership}.
791  *
792  * This module is used through inheritance. It will make available the modifier
793  * `onlyOwner`, which can be applied to your functions to restrict their use to
794  * the owner.
795  */
796 abstract contract Ownable is Context {
797     address private _owner;
798 
799     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
800 
801     /**
802      * @dev Initializes the contract setting the deployer as the initial owner.
803      */
804     constructor() {
805         _transferOwnership(_msgSender());
806     }
807 
808     /**
809      * @dev Throws if called by any account other than the owner.
810      */
811     modifier onlyOwner() {
812         _checkOwner();
813         _;
814     }
815 
816     /**
817      * @dev Returns the address of the current owner.
818      */
819     function owner() public view virtual returns (address) {
820         return _owner;
821     }
822 
823     /**
824      * @dev Throws if the sender is not the owner.
825      */
826     function _checkOwner() internal view virtual {
827         require(owner() == _msgSender(), "Ownable: caller is not the owner");
828     }
829 
830     /**
831      * @dev Leaves the contract without owner. It will not be possible to call
832      * `onlyOwner` functions anymore. Can only be called by the current owner.
833      *
834      * NOTE: Renouncing ownership will leave the contract without an owner,
835      * thereby removing any functionality that is only available to the owner.
836      */
837     function renounceOwnership() public virtual onlyOwner {
838         _transferOwnership(address(0));
839     }
840 
841     /**
842      * @dev Transfers ownership of the contract to a new account (`newOwner`).
843      * Can only be called by the current owner.
844      */
845     function transferOwnership(address newOwner) public virtual onlyOwner {
846         require(newOwner != address(0), "Ownable: new owner is the zero address");
847         _transferOwnership(newOwner);
848     }
849 
850     /**
851      * @dev Transfers ownership of the contract to a new account (`newOwner`).
852      * Internal function without access restriction.
853      */
854     function _transferOwnership(address newOwner) internal virtual {
855         address oldOwner = _owner;
856         _owner = newOwner;
857         emit OwnershipTransferred(oldOwner, newOwner);
858     }
859 }
860 
861 // File: contracts/IERC721A.sol
862 
863 
864 // ERC721A Contracts v4.0.0
865 // Creator: Chiru Labs
866 
867 pragma solidity ^0.8.4;
868 
869 /**
870  * @dev Interface of an ERC721A compliant contract.
871  */
872 interface IERC721A {
873     /**
874      * The caller must own the token or be an approved operator.
875      */
876     error ApprovalCallerNotOwnerNorApproved();
877 
878     /**
879      * The token does not exist.
880      */
881     error ApprovalQueryForNonexistentToken();
882 
883     /**
884      * The caller cannot approve to their own address.
885      */
886     error ApproveToCaller();
887 
888     /**
889      * The caller cannot approve to the current owner.
890      */
891     error ApprovalToCurrentOwner();
892 
893     /**
894      * Cannot query the balance for the zero address.
895      */
896     error BalanceQueryForZeroAddress();
897 
898     /**
899      * Cannot mint to the zero address.
900      */
901     error MintToZeroAddress();
902 
903     /**
904      * The quantity of tokens minted must be more than zero.
905      */
906     error MintZeroQuantity();
907 
908     /**
909      * The token does not exist.
910      */
911     error OwnerQueryForNonexistentToken();
912 
913     /**
914      * The caller must own the token or be an approved operator.
915      */
916     error TransferCallerNotOwnerNorApproved();
917 
918     /**
919      * The token must be owned by `from`.
920      */
921     error TransferFromIncorrectOwner();
922 
923     /**
924      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
925      */
926     error TransferToNonERC721ReceiverImplementer();
927 
928     /**
929      * Cannot transfer to the zero address.
930      */
931     error TransferToZeroAddress();
932 
933     /**
934      * The token does not exist.
935      */
936     error URIQueryForNonexistentToken();
937 
938     struct TokenOwnership {
939         // The address of the owner.
940         address addr;
941         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
942         uint64 startTimestamp;
943         // Whether the token has been burned.
944         bool burned;
945     }
946 
947     /**
948      * @dev Returns the total amount of tokens stored by the contract.
949      *
950      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
951      */
952     function totalSupply() external view returns (uint256);
953 
954     // ==============================
955     //            IERC165
956     // ==============================
957 
958     /**
959      * @dev Returns true if this contract implements the interface defined by
960      * `interfaceId`. See the corresponding
961      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
962      * to learn more about how these ids are created.
963      *
964      * This function call must use less than 30 000 gas.
965      */
966     function supportsInterface(bytes4 interfaceId) external view returns (bool);
967 
968     // ==============================
969     //            IERC721
970     // ==============================
971 
972     /**
973      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
974      */
975     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
976 
977     /**
978      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
979      */
980     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
981 
982     /**
983      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
984      */
985     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
986 
987     /**
988      * @dev Returns the number of tokens in ``owner``'s account.
989      */
990     function balanceOf(address owner) external view returns (uint256 balance);
991 
992     /**
993      * @dev Returns the owner of the `tokenId` token.
994      *
995      * Requirements:
996      *
997      * - `tokenId` must exist.
998      */
999     function ownerOf(uint256 tokenId) external view returns (address owner);
1000 
1001     /**
1002      * @dev Safely transfers `tokenId` token from `from` to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - `from` cannot be the zero address.
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must exist and be owned by `from`.
1009      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1010      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId,
1018         bytes calldata data
1019     ) external;
1020 
1021     /**
1022      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1023      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1024      *
1025      * Requirements:
1026      *
1027      * - `from` cannot be the zero address.
1028      * - `to` cannot be the zero address.
1029      * - `tokenId` token must exist and be owned by `from`.
1030      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1031      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) external;
1040 
1041     /**
1042      * @dev Transfers `tokenId` token from `from` to `to`.
1043      *
1044      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1045      *
1046      * Requirements:
1047      *
1048      * - `from` cannot be the zero address.
1049      * - `to` cannot be the zero address.
1050      * - `tokenId` token must be owned by `from`.
1051      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function transferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) external;
1060 
1061     /**
1062      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1063      * The approval is cleared when the token is transferred.
1064      *
1065      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1066      *
1067      * Requirements:
1068      *
1069      * - The caller must own the token or be an approved operator.
1070      * - `tokenId` must exist.
1071      *
1072      * Emits an {Approval} event.
1073      */
1074     function approve(address to, uint256 tokenId) external;
1075 
1076     /**
1077      * @dev Approve or remove `operator` as an operator for the caller.
1078      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1079      *
1080      * Requirements:
1081      *
1082      * - The `operator` cannot be the caller.
1083      *
1084      * Emits an {ApprovalForAll} event.
1085      */
1086     function setApprovalForAll(address operator, bool _approved) external;
1087 
1088     /**
1089      * @dev Returns the account approved for `tokenId` token.
1090      *
1091      * Requirements:
1092      *
1093      * - `tokenId` must exist.
1094      */
1095     function getApproved(uint256 tokenId) external view returns (address operator);
1096 
1097     /**
1098      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1099      *
1100      * See {setApprovalForAll}
1101      */
1102     function isApprovedForAll(address owner, address operator) external view returns (bool);
1103 
1104     // ==============================
1105     //        IERC721Metadata
1106     // ==============================
1107 
1108     /**
1109      * @dev Returns the token collection name.
1110      */
1111     function name() external view returns (string memory);
1112 
1113     /**
1114      * @dev Returns the token collection symbol.
1115      */
1116     function symbol() external view returns (string memory);
1117 
1118     /**
1119      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1120      */
1121     function tokenURI(uint256 tokenId) external view returns (string memory);
1122 }
1123 // File: contracts/ERC721A.sol
1124 
1125 
1126 // ERC721A Contracts v4.0.0
1127 // Creator: Chiru Labs
1128 
1129 pragma solidity ^0.8.4;
1130 
1131 
1132 /**
1133  * @dev ERC721 token receiver interface.
1134  */
1135 interface ERC721A__IERC721Receiver {
1136     function onERC721Received(
1137         address operator,
1138         address from,
1139         uint256 tokenId,
1140         bytes calldata data
1141     ) external returns (bytes4);
1142 }
1143 
1144 /**
1145  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1146  * the Metadata extension. Built to optimize for lower gas during batch mints.
1147  *
1148  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1149  *
1150  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1151  *
1152  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1153  */
1154 contract ERC721A is IERC721A {
1155     // Mask of an entry in packed address data.
1156     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1157 
1158     // The bit position of `numberMinted` in packed address data.
1159     uint256 private constant BITPOS_NUMBER_MINTED = 64;
1160 
1161     // The bit position of `numberBurned` in packed address data.
1162     uint256 private constant BITPOS_NUMBER_BURNED = 128;
1163 
1164     // The bit position of `aux` in packed address data.
1165     uint256 private constant BITPOS_AUX = 192;
1166 
1167     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1168     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1169 
1170     // The bit position of `startTimestamp` in packed ownership.
1171     uint256 private constant BITPOS_START_TIMESTAMP = 160;
1172 
1173     // The bit mask of the `burned` bit in packed ownership.
1174     uint256 private constant BITMASK_BURNED = 1 << 224;
1175     
1176     // The bit position of the `nextInitialized` bit in packed ownership.
1177     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
1178 
1179     // The bit mask of the `nextInitialized` bit in packed ownership.
1180     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1181 
1182     // The tokenId of the next token to be minted.
1183     uint256 private _currentIndex;
1184 
1185     // The number of tokens burned.
1186     uint256 private _burnCounter;
1187 
1188     // Token name
1189     string private _name;
1190 
1191     // Token symbol
1192     string private _symbol;
1193 
1194     // Mapping from token ID to ownership details
1195     // An empty struct value does not necessarily mean the token is unowned.
1196     // See `_packedOwnershipOf` implementation for details.
1197     //
1198     // Bits Layout:
1199     // - [0..159]   `addr`
1200     // - [160..223] `startTimestamp`
1201     // - [224]      `burned`
1202     // - [225]      `nextInitialized`
1203     mapping(uint256 => uint256) private _packedOwnerships;
1204 
1205     // Mapping owner address to address data.
1206     //
1207     // Bits Layout:
1208     // - [0..63]    `balance`
1209     // - [64..127]  `numberMinted`
1210     // - [128..191] `numberBurned`
1211     // - [192..255] `aux`
1212     mapping(address => uint256) private _packedAddressData;
1213 
1214     // Mapping from token ID to approved address.
1215     mapping(uint256 => address) private _tokenApprovals;
1216 
1217     // Mapping from owner to operator approvals
1218     mapping(address => mapping(address => bool)) private _operatorApprovals;
1219 
1220     constructor(string memory name_, string memory symbol_) {
1221         _name = name_;
1222         _symbol = symbol_;
1223         _currentIndex = _startTokenId();
1224     }
1225 
1226     /**
1227      * @dev Returns the starting token ID. 
1228      * To change the starting token ID, please override this function.
1229      */
1230     function _startTokenId() internal view virtual returns (uint256) {
1231         return 0;
1232     }
1233 
1234     /**
1235      * @dev Returns the next token ID to be minted.
1236      */
1237     function _nextTokenId() internal view returns (uint256) {
1238         return _currentIndex;
1239     }
1240 
1241     /**
1242      * @dev Returns the total number of tokens in existence.
1243      * Burned tokens will reduce the count. 
1244      * To get the total number of tokens minted, please see `_totalMinted`.
1245      */
1246     function totalSupply() public view override returns (uint256) {
1247         // Counter underflow is impossible as _burnCounter cannot be incremented
1248         // more than `_currentIndex - _startTokenId()` times.
1249         unchecked {
1250             return _currentIndex - _burnCounter - _startTokenId();
1251         }
1252     }
1253 
1254     /**
1255      * @dev Returns the total amount of tokens minted in the contract.
1256      */
1257     function _totalMinted() internal view returns (uint256) {
1258         // Counter underflow is impossible as _currentIndex does not decrement,
1259         // and it is initialized to `_startTokenId()`
1260         unchecked {
1261             return _currentIndex - _startTokenId();
1262         }
1263     }
1264 
1265     /**
1266      * @dev Returns the total number of tokens burned.
1267      */
1268     function _totalBurned() internal view returns (uint256) {
1269         return _burnCounter;
1270     }
1271 
1272     /**
1273      * @dev See {IERC165-supportsInterface}.
1274      */
1275     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1276         // The interface IDs are constants representing the first 4 bytes of the XOR of
1277         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1278         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1279         return
1280             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1281             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1282             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-balanceOf}.
1287      */
1288     function balanceOf(address owner) public view override returns (uint256) {
1289         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
1290         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1291     }
1292 
1293     /**
1294      * Returns the number of tokens minted by `owner`.
1295      */
1296     function _numberMinted(address owner) internal view returns (uint256) {
1297         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1298     }
1299 
1300     /**
1301      * Returns the number of tokens burned by or on behalf of `owner`.
1302      */
1303     function _numberBurned(address owner) internal view returns (uint256) {
1304         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1305     }
1306 
1307     /**
1308      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1309      */
1310     function _getAux(address owner) internal view returns (uint64) {
1311         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1312     }
1313 
1314     /**
1315      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1316      * If there are multiple variables, please pack them into a uint64.
1317      */
1318     function _setAux(address owner, uint64 aux) internal {
1319         uint256 packed = _packedAddressData[owner];
1320         uint256 auxCasted;
1321         assembly { // Cast aux without masking.
1322             auxCasted := aux
1323         }
1324         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1325         _packedAddressData[owner] = packed;
1326     }
1327 
1328     /**
1329      * Returns the packed ownership data of `tokenId`.
1330      */
1331     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1332         uint256 curr = tokenId;
1333 
1334         unchecked {
1335             if (_startTokenId() <= curr)
1336                 if (curr < _currentIndex) {
1337                     uint256 packed = _packedOwnerships[curr];
1338                     // If not burned.
1339                     if (packed & BITMASK_BURNED == 0) {
1340                         // Invariant:
1341                         // There will always be an ownership that has an address and is not burned
1342                         // before an ownership that does not have an address and is not burned.
1343                         // Hence, curr will not underflow.
1344                         //
1345                         // We can directly compare the packed value.
1346                         // If the address is zero, packed is zero.
1347                         while (packed == 0) {
1348                             packed = _packedOwnerships[--curr];
1349                         }
1350                         return packed;
1351                     }
1352                 }
1353         }
1354         revert OwnerQueryForNonexistentToken();
1355     }
1356 
1357     /**
1358      * Returns the unpacked `TokenOwnership` struct from `packed`.
1359      */
1360     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1361         ownership.addr = address(uint160(packed));
1362         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1363         ownership.burned = packed & BITMASK_BURNED != 0;
1364     }
1365 
1366     /**
1367      * Returns the unpacked `TokenOwnership` struct at `index`.
1368      */
1369     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1370         return _unpackedOwnership(_packedOwnerships[index]);
1371     }
1372 
1373     /**
1374      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1375      */
1376     function _initializeOwnershipAt(uint256 index) internal {
1377         if (_packedOwnerships[index] == 0) {
1378             _packedOwnerships[index] = _packedOwnershipOf(index);
1379         }
1380     }
1381 
1382     /**
1383      * Gas spent here starts off proportional to the maximum mint batch size.
1384      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1385      */
1386     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1387         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1388     }
1389 
1390     /**
1391      * @dev See {IERC721-ownerOf}.
1392      */
1393     function ownerOf(uint256 tokenId) public view override returns (address) {
1394         return address(uint160(_packedOwnershipOf(tokenId)));
1395     }
1396 
1397     /**
1398      * @dev See {IERC721Metadata-name}.
1399      */
1400     function name() public view virtual override returns (string memory) {
1401         return _name;
1402     }
1403 
1404     /**
1405      * @dev See {IERC721Metadata-symbol}.
1406      */
1407     function symbol() public view virtual override returns (string memory) {
1408         return _symbol;
1409     }
1410 
1411     /**
1412      * @dev See {IERC721Metadata-tokenURI}.
1413      */
1414     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1415         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1416 
1417         string memory baseURI = _baseURI();
1418         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1419     }
1420 
1421     /**
1422      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1423      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1424      * by default, can be overriden in child contracts.
1425      */
1426     function _baseURI() internal view virtual returns (string memory) {
1427         return '';
1428     }
1429 
1430     /**
1431      * @dev Casts the address to uint256 without masking.
1432      */
1433     function _addressToUint256(address value) private pure returns (uint256 result) {
1434         assembly {
1435             result := value
1436         }
1437     }
1438 
1439     /**
1440      * @dev Casts the boolean to uint256 without branching.
1441      */
1442     function _boolToUint256(bool value) private pure returns (uint256 result) {
1443         assembly {
1444             result := value
1445         }
1446     }
1447 
1448     /**
1449      * @dev See {IERC721-approve}.
1450      */
1451     function approve(address to, uint256 tokenId) public override {
1452         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1453         if (to == owner) revert ApprovalToCurrentOwner();
1454 
1455         if (_msgSenderERC721A() != owner)
1456             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1457                 revert ApprovalCallerNotOwnerNorApproved();
1458             }
1459 
1460         _tokenApprovals[tokenId] = to;
1461         emit Approval(owner, to, tokenId);
1462     }
1463 
1464     /**
1465      * @dev See {IERC721-getApproved}.
1466      */
1467     function getApproved(uint256 tokenId) public view override returns (address) {
1468         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1469 
1470         return _tokenApprovals[tokenId];
1471     }
1472 
1473     /**
1474      * @dev See {IERC721-setApprovalForAll}.
1475      */
1476     function setApprovalForAll(address operator, bool approved) public virtual override {
1477         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1478 
1479         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1480         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1481     }
1482 
1483     /**
1484      * @dev See {IERC721-isApprovedForAll}.
1485      */
1486     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1487         return _operatorApprovals[owner][operator];
1488     }
1489 
1490     /**
1491      * @dev See {IERC721-transferFrom}.
1492      */
1493     function transferFrom(
1494         address from,
1495         address to,
1496         uint256 tokenId
1497     ) public virtual override {
1498         _transfer(from, to, tokenId);
1499     }
1500 
1501     /**
1502      * @dev See {IERC721-safeTransferFrom}.
1503      */
1504     function safeTransferFrom(
1505         address from,
1506         address to,
1507         uint256 tokenId
1508     ) public virtual override {
1509         safeTransferFrom(from, to, tokenId, '');
1510     }
1511 
1512     /**
1513      * @dev See {IERC721-safeTransferFrom}.
1514      */
1515     function safeTransferFrom(
1516         address from,
1517         address to,
1518         uint256 tokenId,
1519         bytes memory _data
1520     ) public virtual override {
1521         _transfer(from, to, tokenId);
1522         if (to.code.length != 0)
1523             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1524                 revert TransferToNonERC721ReceiverImplementer();
1525             }
1526     }
1527 
1528     /**
1529      * @dev Returns whether `tokenId` exists.
1530      *
1531      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1532      *
1533      * Tokens start existing when they are minted (`_mint`),
1534      */
1535     function _exists(uint256 tokenId) internal view returns (bool) {
1536         return
1537             _startTokenId() <= tokenId &&
1538             tokenId < _currentIndex && // If within bounds,
1539             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1540     }
1541 
1542     /**
1543      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1544      */
1545     function _safeMint(address to, uint256 quantity) internal {
1546         _safeMint(to, quantity, '');
1547     }
1548 
1549     /**
1550      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1551      *
1552      * Requirements:
1553      *
1554      * - If `to` refers to a smart contract, it must implement
1555      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1556      * - `quantity` must be greater than 0.
1557      *
1558      * Emits a {Transfer} event.
1559      */
1560     function _safeMint(
1561         address to,
1562         uint256 quantity,
1563         bytes memory _data
1564     ) internal {
1565         uint256 startTokenId = _currentIndex;
1566         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1567         if (quantity == 0) revert MintZeroQuantity();
1568 
1569         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1570 
1571         // Overflows are incredibly unrealistic.
1572         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1573         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1574         unchecked {
1575             // Updates:
1576             // - `balance += quantity`.
1577             // - `numberMinted += quantity`.
1578             //
1579             // We can directly add to the balance and number minted.
1580             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1581 
1582             // Updates:
1583             // - `address` to the owner.
1584             // - `startTimestamp` to the timestamp of minting.
1585             // - `burned` to `false`.
1586             // - `nextInitialized` to `quantity == 1`.
1587             _packedOwnerships[startTokenId] =
1588                 _addressToUint256(to) |
1589                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1590                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1591 
1592             uint256 updatedIndex = startTokenId;
1593             uint256 end = updatedIndex + quantity;
1594 
1595             if (to.code.length != 0) {
1596                 do {
1597                     emit Transfer(address(0), to, updatedIndex);
1598                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1599                         revert TransferToNonERC721ReceiverImplementer();
1600                     }
1601                 } while (updatedIndex < end);
1602                 // Reentrancy protection
1603                 if (_currentIndex != startTokenId) revert();
1604             } else {
1605                 do {
1606                     emit Transfer(address(0), to, updatedIndex++);
1607                 } while (updatedIndex < end);
1608             }
1609             _currentIndex = updatedIndex;
1610         }
1611         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1612     }
1613 
1614     /**
1615      * @dev Mints `quantity` tokens and transfers them to `to`.
1616      *
1617      * Requirements:
1618      *
1619      * - `to` cannot be the zero address.
1620      * - `quantity` must be greater than 0.
1621      *
1622      * Emits a {Transfer} event.
1623      */
1624     function _mint(address to, uint256 quantity) internal {
1625         uint256 startTokenId = _currentIndex;
1626         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1627         if (quantity == 0) revert MintZeroQuantity();
1628 
1629         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1630 
1631         // Overflows are incredibly unrealistic.
1632         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1633         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1634         unchecked {
1635             // Updates:
1636             // - `balance += quantity`.
1637             // - `numberMinted += quantity`.
1638             //
1639             // We can directly add to the balance and number minted.
1640             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1641 
1642             // Updates:
1643             // - `address` to the owner.
1644             // - `startTimestamp` to the timestamp of minting.
1645             // - `burned` to `false`.
1646             // - `nextInitialized` to `quantity == 1`.
1647             _packedOwnerships[startTokenId] =
1648                 _addressToUint256(to) |
1649                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1650                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1651 
1652             uint256 updatedIndex = startTokenId;
1653             uint256 end = updatedIndex + quantity;
1654 
1655             do {
1656                 emit Transfer(address(0), to, updatedIndex++);
1657             } while (updatedIndex < end);
1658 
1659             _currentIndex = updatedIndex;
1660         }
1661         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1662     }
1663 
1664     /**
1665      * @dev Transfers `tokenId` from `from` to `to`.
1666      *
1667      * Requirements:
1668      *
1669      * - `to` cannot be the zero address.
1670      * - `tokenId` token must be owned by `from`.
1671      *
1672      * Emits a {Transfer} event.
1673      */
1674     function _transfer(
1675         address from,
1676         address to,
1677         uint256 tokenId
1678     ) private {
1679         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1680 
1681         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1682 
1683         address approvedAddress = _tokenApprovals[tokenId];
1684 
1685         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1686             isApprovedForAll(from, _msgSenderERC721A()) ||
1687             approvedAddress == _msgSenderERC721A());
1688 
1689         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1690         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1691 
1692         _beforeTokenTransfers(from, to, tokenId, 1);
1693 
1694         // Clear approvals from the previous owner.
1695         if (_addressToUint256(approvedAddress) != 0) {
1696             delete _tokenApprovals[tokenId];
1697         }
1698 
1699         // Underflow of the sender's balance is impossible because we check for
1700         // ownership above and the recipient's balance can't realistically overflow.
1701         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1702         unchecked {
1703             // We can directly increment and decrement the balances.
1704             --_packedAddressData[from]; // Updates: `balance -= 1`.
1705             ++_packedAddressData[to]; // Updates: `balance += 1`.
1706 
1707             // Updates:
1708             // - `address` to the next owner.
1709             // - `startTimestamp` to the timestamp of transfering.
1710             // - `burned` to `false`.
1711             // - `nextInitialized` to `true`.
1712             _packedOwnerships[tokenId] =
1713                 _addressToUint256(to) |
1714                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1715                 BITMASK_NEXT_INITIALIZED;
1716 
1717             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1718             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1719                 uint256 nextTokenId = tokenId + 1;
1720                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1721                 if (_packedOwnerships[nextTokenId] == 0) {
1722                     // If the next slot is within bounds.
1723                     if (nextTokenId != _currentIndex) {
1724                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1725                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1726                     }
1727                 }
1728             }
1729         }
1730 
1731         emit Transfer(from, to, tokenId);
1732         _afterTokenTransfers(from, to, tokenId, 1);
1733     }
1734 
1735     /**
1736      * @dev Equivalent to `_burn(tokenId, false)`.
1737      */
1738     function _burn(uint256 tokenId) internal virtual {
1739         _burn(tokenId, false);
1740     }
1741 
1742     /**
1743      * @dev Destroys `tokenId`.
1744      * The approval is cleared when the token is burned.
1745      *
1746      * Requirements:
1747      *
1748      * - `tokenId` must exist.
1749      *
1750      * Emits a {Transfer} event.
1751      */
1752     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1753         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1754 
1755         address from = address(uint160(prevOwnershipPacked));
1756         address approvedAddress = _tokenApprovals[tokenId];
1757 
1758         if (approvalCheck) {
1759             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1760                 isApprovedForAll(from, _msgSenderERC721A()) ||
1761                 approvedAddress == _msgSenderERC721A());
1762 
1763             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1764         }
1765 
1766         _beforeTokenTransfers(from, address(0), tokenId, 1);
1767 
1768         // Clear approvals from the previous owner.
1769         if (_addressToUint256(approvedAddress) != 0) {
1770             delete _tokenApprovals[tokenId];
1771         }
1772 
1773         // Underflow of the sender's balance is impossible because we check for
1774         // ownership above and the recipient's balance can't realistically overflow.
1775         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1776         unchecked {
1777             // Updates:
1778             // - `balance -= 1`.
1779             // - `numberBurned += 1`.
1780             //
1781             // We can directly decrement the balance, and increment the number burned.
1782             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1783             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1784 
1785             // Updates:
1786             // - `address` to the last owner.
1787             // - `startTimestamp` to the timestamp of burning.
1788             // - `burned` to `true`.
1789             // - `nextInitialized` to `true`.
1790             _packedOwnerships[tokenId] =
1791                 _addressToUint256(from) |
1792                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1793                 BITMASK_BURNED | 
1794                 BITMASK_NEXT_INITIALIZED;
1795 
1796             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1797             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1798                 uint256 nextTokenId = tokenId + 1;
1799                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1800                 if (_packedOwnerships[nextTokenId] == 0) {
1801                     // If the next slot is within bounds.
1802                     if (nextTokenId != _currentIndex) {
1803                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1804                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1805                     }
1806                 }
1807             }
1808         }
1809 
1810         emit Transfer(from, address(0), tokenId);
1811         _afterTokenTransfers(from, address(0), tokenId, 1);
1812 
1813         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1814         unchecked {
1815             _burnCounter++;
1816         }
1817     }
1818 
1819     /**
1820      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1821      *
1822      * @param from address representing the previous owner of the given token ID
1823      * @param to target address that will receive the tokens
1824      * @param tokenId uint256 ID of the token to be transferred
1825      * @param _data bytes optional data to send along with the call
1826      * @return bool whether the call correctly returned the expected magic value
1827      */
1828     function _checkContractOnERC721Received(
1829         address from,
1830         address to,
1831         uint256 tokenId,
1832         bytes memory _data
1833     ) private returns (bool) {
1834         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1835             bytes4 retval
1836         ) {
1837             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1838         } catch (bytes memory reason) {
1839             if (reason.length == 0) {
1840                 revert TransferToNonERC721ReceiverImplementer();
1841             } else {
1842                 assembly {
1843                     revert(add(32, reason), mload(reason))
1844                 }
1845             }
1846         }
1847     }
1848 
1849     /**
1850      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1851      * And also called before burning one token.
1852      *
1853      * startTokenId - the first token id to be transferred
1854      * quantity - the amount to be transferred
1855      *
1856      * Calling conditions:
1857      *
1858      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1859      * transferred to `to`.
1860      * - When `from` is zero, `tokenId` will be minted for `to`.
1861      * - When `to` is zero, `tokenId` will be burned by `from`.
1862      * - `from` and `to` are never both zero.
1863      */
1864     function _beforeTokenTransfers(
1865         address from,
1866         address to,
1867         uint256 startTokenId,
1868         uint256 quantity
1869     ) internal virtual {}
1870 
1871     /**
1872      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1873      * minting.
1874      * And also called after one token has been burned.
1875      *
1876      * startTokenId - the first token id to be transferred
1877      * quantity - the amount to be transferred
1878      *
1879      * Calling conditions:
1880      *
1881      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1882      * transferred to `to`.
1883      * - When `from` is zero, `tokenId` has been minted for `to`.
1884      * - When `to` is zero, `tokenId` has been burned by `from`.
1885      * - `from` and `to` are never both zero.
1886      */
1887     function _afterTokenTransfers(
1888         address from,
1889         address to,
1890         uint256 startTokenId,
1891         uint256 quantity
1892     ) internal virtual {}
1893 
1894     /**
1895      * @dev Returns the message sender (defaults to `msg.sender`).
1896      *
1897      * If you are writing GSN compatible contracts, you need to override this function.
1898      */
1899     function _msgSenderERC721A() internal view virtual returns (address) {
1900         return msg.sender;
1901     }
1902 
1903     /**
1904      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1905      */
1906     function _toString(uint256 value) internal pure returns (string memory ptr) {
1907         assembly {
1908             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1909             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1910             // We will need 1 32-byte word to store the length, 
1911             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1912             ptr := add(mload(0x40), 128)
1913             // Update the free memory pointer to allocate.
1914             mstore(0x40, ptr)
1915 
1916             // Cache the end of the memory to calculate the length later.
1917             let end := ptr
1918 
1919             // We write the string from the rightmost digit to the leftmost digit.
1920             // The following is essentially a do-while loop that also handles the zero case.
1921             // Costs a bit more than early returning for the zero case,
1922             // but cheaper in terms of deployment and overall runtime costs.
1923             for { 
1924                 // Initialize and perform the first pass without check.
1925                 let temp := value
1926                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1927                 ptr := sub(ptr, 1)
1928                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1929                 mstore8(ptr, add(48, mod(temp, 10)))
1930                 temp := div(temp, 10)
1931             } temp { 
1932                 // Keep dividing `temp` until zero.
1933                 temp := div(temp, 10)
1934             } { // Body of the for loop.
1935                 ptr := sub(ptr, 1)
1936                 mstore8(ptr, add(48, mod(temp, 10)))
1937             }
1938             
1939             let length := sub(end, ptr)
1940             // Move the pointer 32 bytes leftwards to make room for the length.
1941             ptr := sub(ptr, 32)
1942             // Store the length.
1943             mstore(ptr, length)
1944         }
1945     }
1946 }
1947 // File: contracts/saibogu-hei.sol
1948 
1949 
1950 // pragma solidity ^0.8.9;
1951 pragma solidity >=0.7.0 <0.9.0;
1952 
1953 
1954 
1955 
1956 
1957 
1958 contract SaiboguHei is ERC721A, Ownable, DefaultOperatorFilterer {
1959     using Strings for uint256;
1960     
1961     uint256 public constant MAX_SUPPLY = 888;
1962 
1963     uint256 public phase = 0;
1964 
1965     bytes32 public merkleRoot;
1966 
1967     uint256 public salePrice = 0 ether;
1968     uint256 public maxMintPerTx = 2;
1969     uint256 public maxMintPerWallet = 2;
1970     
1971     string public baseURI;
1972 
1973     bool private reveal = false;
1974 
1975     mapping(address => uint) public accountMinted;
1976 
1977     constructor() ERC721A("SaiboguHei", "SBG") {}
1978 
1979     /**
1980      * @notice token start from id 1
1981      */
1982     function _startTokenId() internal view virtual override returns (uint256) {
1983         return 1;
1984     }
1985 
1986     /**
1987      * @notice whitelist mint
1988      */
1989     function whitelistMint(uint quantity, bytes32[] memory proof) external payable {
1990         require(phase == 1, "whitelist is close.");
1991 
1992         require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Not whitelisted.");       
1993         
1994         _mint(quantity);
1995     }
1996 
1997     /**
1998      * @notice public mint
1999      */
2000     function publicMint(uint quantity) external payable {
2001         require(phase == 2 , "Public Sales is close.");
2002         _mint(quantity);
2003     }
2004 
2005     /**
2006      * @notice mint
2007      */
2008     function _mint(uint quantity) internal {
2009         require(accountMinted[_msgSender()] + quantity <= maxMintPerWallet, "Account reached the max mint.");
2010 
2011         require(quantity <= maxMintPerTx && quantity > 0, "Max two per transaction.");
2012 
2013         require(quantity + totalSupply() <= MAX_SUPPLY, "Total Sold out");
2014 
2015         require(msg.value >= salePrice * quantity, "Not enough ETH to mint");
2016 
2017         accountMinted[_msgSender()] += quantity;
2018        
2019         _mint(_msgSender(), quantity);
2020     }
2021 
2022     /**
2023      * @notice set whitelist merkle root
2024      */
2025     function setMerkleRoot(bytes32 _rootHash) external onlyOwner {
2026         merkleRoot = _rootHash;
2027     }
2028 
2029     /**
2030      * @notice set max mint per transaction
2031      */
2032     function setMaxMintPerTx(uint256 _setMaxTx) external onlyOwner {
2033         maxMintPerTx = _setMaxTx;
2034     }
2035 
2036     /**
2037      * @notice set max mint per wallet
2038      */
2039     function setMaxMintPerWallet(uint256 _setMaxMint) external onlyOwner {
2040         maxMintPerWallet = _setMaxMint;
2041     }
2042     
2043     /**
2044      * @notice set sale price
2045      */
2046     function setSalePrice(uint256 _salePrice) external onlyOwner {
2047         salePrice = _salePrice;
2048     }
2049 
2050     /**
2051      * @notice set reveal
2052      */
2053     function switchReveal() external onlyOwner {
2054         reveal = !reveal;
2055     }
2056 
2057     /**
2058      * @notice set rea uri
2059      */
2060     function setBaseURI(string memory uri) external onlyOwner {
2061         baseURI = uri;
2062     }
2063 
2064     /**
2065      * @notice switch phase 
2066      */
2067     function switchPhase(uint256 phaseNumber) external onlyOwner {
2068         require(phaseNumber >= 0 && phaseNumber < 3 , "Phase out of range 0 - 2");
2069         phase = phaseNumber;
2070     }
2071 
2072     /**
2073      * @notice token URI
2074      */
2075     function tokenURI(uint256 _tokenId)
2076         public
2077         view
2078         virtual
2079         override
2080         returns (string memory)
2081     {
2082         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2083 
2084         if (reveal) {
2085             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _tokenId.toString())) : '';
2086         } else {
2087             return string(abi.encodePacked(baseURI));
2088         }
2089     }
2090 
2091     /**
2092      * @notice transfer funds
2093      */
2094     function withdrawal() external onlyOwner {
2095         uint256 balance = address(this).balance;
2096         payable(msg.sender).transfer(balance);
2097     }
2098     
2099     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2100         super.transferFrom(from, to, tokenId);
2101     }
2102 
2103     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2104         super.safeTransferFrom(from, to, tokenId);
2105     }
2106 
2107     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
2108         super.safeTransferFrom(from, to, tokenId, data);
2109     }
2110 }