1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.13;
4 
5 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
6 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
7 
8 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
9 
10 
11 pragma solidity ^0.8.13;
12 
13 interface IOperatorFilterRegistry {
14     /**
15      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
16      *         true if supplied registrant address is not registered.
17      */
18     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
19 
20     /**
21      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
22      */
23     function register(address registrant) external;
24 
25     /**
26      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
27      */
28     function registerAndSubscribe(address registrant, address subscription) external;
29 
30     /**
31      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
32      *         address without subscribing.
33      */
34     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
35 
36     /**
37      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
38      *         Note that this does not remove any filtered addresses or codeHashes.
39      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
40      */
41     function unregister(address addr) external;
42 
43     /**
44      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
45      */
46     function updateOperator(address registrant, address operator, bool filtered) external;
47 
48     /**
49      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
50      */
51     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
52 
53     /**
54      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
55      */
56     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
57 
58     /**
59      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
60      */
61     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
62 
63     /**
64      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
65      *         subscription if present.
66      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
67      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
68      *         used.
69      */
70     function subscribe(address registrant, address registrantToSubscribe) external;
71 
72     /**
73      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
74      */
75     function unsubscribe(address registrant, bool copyExistingEntries) external;
76 
77     /**
78      * @notice Get the subscription address of a given registrant, if any.
79      */
80     function subscriptionOf(address addr) external returns (address registrant);
81 
82     /**
83      * @notice Get the set of addresses subscribed to a given registrant.
84      *         Note that order is not guaranteed as updates are made.
85      */
86     function subscribers(address registrant) external returns (address[] memory);
87 
88     /**
89      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
90      *         Note that order is not guaranteed as updates are made.
91      */
92     function subscriberAt(address registrant, uint256 index) external returns (address);
93 
94     /**
95      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
96      */
97     function copyEntriesOf(address registrant, address registrantToCopy) external;
98 
99     /**
100      * @notice Returns true if operator is filtered by a given address or its subscription.
101      */
102     function isOperatorFiltered(address registrant, address operator) external returns (bool);
103 
104     /**
105      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
106      */
107     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
108 
109     /**
110      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
111      */
112     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
113 
114     /**
115      * @notice Returns a list of filtered operators for a given address or its subscription.
116      */
117     function filteredOperators(address addr) external returns (address[] memory);
118 
119     /**
120      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
121      *         Note that order is not guaranteed as updates are made.
122      */
123     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
124 
125     /**
126      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
127      *         its subscription.
128      *         Note that order is not guaranteed as updates are made.
129      */
130     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
131 
132     /**
133      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
134      *         its subscription.
135      *         Note that order is not guaranteed as updates are made.
136      */
137     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
138 
139     /**
140      * @notice Returns true if an address has registered
141      */
142     function isRegistered(address addr) external returns (bool);
143 
144     /**
145      * @dev Convenience method to compute the code hash of an arbitrary contract
146      */
147     function codeHashOf(address addr) external returns (bytes32);
148 }
149 
150 // File: operator-filter-registry/src/OperatorFilterer.sol
151 
152 
153 pragma solidity ^0.8.13;
154 
155 
156 /**
157  * @title  OperatorFilterer
158  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
159  *         registrant's entries in the OperatorFilterRegistry.
160  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
161  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
162  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
163  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
164  *         administration methods on the contract itself to interact with the registry otherwise the subscription
165  *         will be locked to the options set during construction.
166  */
167 
168 abstract contract OperatorFilterer {
169     /// @dev Emitted when an operator is not allowed.
170     error OperatorNotAllowed(address operator);
171 
172     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
173         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
174 
175     /// @dev The constructor that is called when the contract is being deployed.
176     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
177         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
178         // will not revert, but the contract will need to be registered with the registry once it is deployed in
179         // order for the modifier to filter addresses.
180         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
181             if (subscribe) {
182                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
183             } else {
184                 if (subscriptionOrRegistrantToCopy != address(0)) {
185                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
186                 } else {
187                     OPERATOR_FILTER_REGISTRY.register(address(this));
188                 }
189             }
190         }
191     }
192 
193     /**
194      * @dev A helper function to check if an operator is allowed.
195      */
196     modifier onlyAllowedOperator(address from) virtual {
197         // Allow spending tokens from addresses with balance
198         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
199         // from an EOA.
200         if (from != msg.sender) {
201             _checkFilterOperator(msg.sender);
202         }
203         _;
204     }
205 
206     /**
207      * @dev A helper function to check if an operator approval is allowed.
208      */
209     modifier onlyAllowedOperatorApproval(address operator) virtual {
210         _checkFilterOperator(operator);
211         _;
212     }
213 
214     /**
215      * @dev A helper function to check if an operator is allowed.
216      */
217     function _checkFilterOperator(address operator) internal view virtual {
218         // Check registry code length to facilitate testing in environments without a deployed registry.
219         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
220             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
221             // may specify their own OperatorFilterRegistry implementations, which may behave differently
222             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
223                 revert OperatorNotAllowed(operator);
224             }
225         }
226     }
227 }
228 
229 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
230 
231 
232 pragma solidity ^0.8.13;
233 
234 
235 /**
236  * @title  DefaultOperatorFilterer
237  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
238  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
239  *         administration methods on the contract itself to interact with the registry otherwise the subscription
240  *         will be locked to the options set during construction.
241  */
242 
243 abstract contract DefaultOperatorFilterer is OperatorFilterer {
244     /// @dev The constructor that is called when the contract is being deployed.
245     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
246 }
247 
248 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @dev These functions deal with verification of Merkle Tree proofs.
257  *
258  * The tree and the proofs can be generated using our
259  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
260  * You will find a quickstart guide in the readme.
261  *
262  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
263  * hashing, or use a hash function other than keccak256 for hashing leaves.
264  * This is because the concatenation of a sorted pair of internal nodes in
265  * the merkle tree could be reinterpreted as a leaf value.
266  * OpenZeppelin's JavaScript library generates merkle trees that are safe
267  * against this attack out of the box.
268  */
269 library MerkleProof {
270     /**
271      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
272      * defined by `root`. For this, a `proof` must be provided, containing
273      * sibling hashes on the branch from the leaf to the root of the tree. Each
274      * pair of leaves and each pair of pre-images are assumed to be sorted.
275      */
276     function verify(
277         bytes32[] memory proof,
278         bytes32 root,
279         bytes32 leaf
280     ) internal pure returns (bool) {
281         return processProof(proof, leaf) == root;
282     }
283 
284     /**
285      * @dev Calldata version of {verify}
286      *
287      * _Available since v4.7._
288      */
289     function verifyCalldata(
290         bytes32[] calldata proof,
291         bytes32 root,
292         bytes32 leaf
293     ) internal pure returns (bool) {
294         return processProofCalldata(proof, leaf) == root;
295     }
296 
297     /**
298      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
299      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
300      * hash matches the root of the tree. When processing the proof, the pairs
301      * of leafs & pre-images are assumed to be sorted.
302      *
303      * _Available since v4.4._
304      */
305     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
306         bytes32 computedHash = leaf;
307         for (uint256 i = 0; i < proof.length; i++) {
308             computedHash = _hashPair(computedHash, proof[i]);
309         }
310         return computedHash;
311     }
312 
313     /**
314      * @dev Calldata version of {processProof}
315      *
316      * _Available since v4.7._
317      */
318     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
319         bytes32 computedHash = leaf;
320         for (uint256 i = 0; i < proof.length; i++) {
321             computedHash = _hashPair(computedHash, proof[i]);
322         }
323         return computedHash;
324     }
325 
326     /**
327      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
328      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
329      *
330      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
331      *
332      * _Available since v4.7._
333      */
334     function multiProofVerify(
335         bytes32[] memory proof,
336         bool[] memory proofFlags,
337         bytes32 root,
338         bytes32[] memory leaves
339     ) internal pure returns (bool) {
340         return processMultiProof(proof, proofFlags, leaves) == root;
341     }
342 
343     /**
344      * @dev Calldata version of {multiProofVerify}
345      *
346      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
347      *
348      * _Available since v4.7._
349      */
350     function multiProofVerifyCalldata(
351         bytes32[] calldata proof,
352         bool[] calldata proofFlags,
353         bytes32 root,
354         bytes32[] memory leaves
355     ) internal pure returns (bool) {
356         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
357     }
358 
359     /**
360      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
361      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
362      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
363      * respectively.
364      *
365      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
366      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
367      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
368      *
369      * _Available since v4.7._
370      */
371     function processMultiProof(
372         bytes32[] memory proof,
373         bool[] memory proofFlags,
374         bytes32[] memory leaves
375     ) internal pure returns (bytes32 merkleRoot) {
376         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
377         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
378         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
379         // the merkle tree.
380         uint256 leavesLen = leaves.length;
381         uint256 totalHashes = proofFlags.length;
382 
383         // Check proof validity.
384         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
385 
386         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
387         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
388         bytes32[] memory hashes = new bytes32[](totalHashes);
389         uint256 leafPos = 0;
390         uint256 hashPos = 0;
391         uint256 proofPos = 0;
392         // At each step, we compute the next hash using two values:
393         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
394         //   get the next hash.
395         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
396         //   `proof` array.
397         for (uint256 i = 0; i < totalHashes; i++) {
398             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
399             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
400             hashes[i] = _hashPair(a, b);
401         }
402 
403         if (totalHashes > 0) {
404             return hashes[totalHashes - 1];
405         } else if (leavesLen > 0) {
406             return leaves[0];
407         } else {
408             return proof[0];
409         }
410     }
411 
412     /**
413      * @dev Calldata version of {processMultiProof}.
414      *
415      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
416      *
417      * _Available since v4.7._
418      */
419     function processMultiProofCalldata(
420         bytes32[] calldata proof,
421         bool[] calldata proofFlags,
422         bytes32[] memory leaves
423     ) internal pure returns (bytes32 merkleRoot) {
424         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
425         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
426         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
427         // the merkle tree.
428         uint256 leavesLen = leaves.length;
429         uint256 totalHashes = proofFlags.length;
430 
431         // Check proof validity.
432         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
433 
434         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
435         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
436         bytes32[] memory hashes = new bytes32[](totalHashes);
437         uint256 leafPos = 0;
438         uint256 hashPos = 0;
439         uint256 proofPos = 0;
440         // At each step, we compute the next hash using two values:
441         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
442         //   get the next hash.
443         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
444         //   `proof` array.
445         for (uint256 i = 0; i < totalHashes; i++) {
446             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
447             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
448             hashes[i] = _hashPair(a, b);
449         }
450 
451         if (totalHashes > 0) {
452             return hashes[totalHashes - 1];
453         } else if (leavesLen > 0) {
454             return leaves[0];
455         } else {
456             return proof[0];
457         }
458     }
459 
460     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
461         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
462     }
463 
464     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
465         /// @solidity memory-safe-assembly
466         assembly {
467             mstore(0x00, a)
468             mstore(0x20, b)
469             value := keccak256(0x00, 0x40)
470         }
471     }
472 }
473 
474 // File: @openzeppelin/contracts/utils/math/Math.sol
475 
476 
477 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
478 
479 pragma solidity ^0.8.0;
480 
481 /**
482  * @dev Standard math utilities missing in the Solidity language.
483  */
484 library Math {
485     enum Rounding {
486         Down, // Toward negative infinity
487         Up, // Toward infinity
488         Zero // Toward zero
489     }
490 
491     /**
492      * @dev Returns the largest of two numbers.
493      */
494     function max(uint256 a, uint256 b) internal pure returns (uint256) {
495         return a > b ? a : b;
496     }
497 
498     /**
499      * @dev Returns the smallest of two numbers.
500      */
501     function min(uint256 a, uint256 b) internal pure returns (uint256) {
502         return a < b ? a : b;
503     }
504 
505     /**
506      * @dev Returns the average of two numbers. The result is rounded towards
507      * zero.
508      */
509     function average(uint256 a, uint256 b) internal pure returns (uint256) {
510         // (a + b) / 2 can overflow.
511         return (a & b) + (a ^ b) / 2;
512     }
513 
514     /**
515      * @dev Returns the ceiling of the division of two numbers.
516      *
517      * This differs from standard division with `/` in that it rounds up instead
518      * of rounding down.
519      */
520     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
521         // (a + b - 1) / b can overflow on addition, so we distribute.
522         return a == 0 ? 0 : (a - 1) / b + 1;
523     }
524 
525     /**
526      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
527      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
528      * with further edits by Uniswap Labs also under MIT license.
529      */
530     function mulDiv(
531         uint256 x,
532         uint256 y,
533         uint256 denominator
534     ) internal pure returns (uint256 result) {
535         unchecked {
536             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
537             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
538             // variables such that product = prod1 * 2^256 + prod0.
539             uint256 prod0; // Least significant 256 bits of the product
540             uint256 prod1; // Most significant 256 bits of the product
541             assembly {
542                 let mm := mulmod(x, y, not(0))
543                 prod0 := mul(x, y)
544                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
545             }
546 
547             // Handle non-overflow cases, 256 by 256 division.
548             if (prod1 == 0) {
549                 return prod0 / denominator;
550             }
551 
552             // Make sure the result is less than 2^256. Also prevents denominator == 0.
553             require(denominator > prod1);
554 
555             ///////////////////////////////////////////////
556             // 512 by 256 division.
557             ///////////////////////////////////////////////
558 
559             // Make division exact by subtracting the remainder from [prod1 prod0].
560             uint256 remainder;
561             assembly {
562                 // Compute remainder using mulmod.
563                 remainder := mulmod(x, y, denominator)
564 
565                 // Subtract 256 bit number from 512 bit number.
566                 prod1 := sub(prod1, gt(remainder, prod0))
567                 prod0 := sub(prod0, remainder)
568             }
569 
570             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
571             // See https://cs.stackexchange.com/q/138556/92363.
572 
573             // Does not overflow because the denominator cannot be zero at this stage in the function.
574             uint256 twos = denominator & (~denominator + 1);
575             assembly {
576                 // Divide denominator by twos.
577                 denominator := div(denominator, twos)
578 
579                 // Divide [prod1 prod0] by twos.
580                 prod0 := div(prod0, twos)
581 
582                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
583                 twos := add(div(sub(0, twos), twos), 1)
584             }
585 
586             // Shift in bits from prod1 into prod0.
587             prod0 |= prod1 * twos;
588 
589             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
590             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
591             // four bits. That is, denominator * inv = 1 mod 2^4.
592             uint256 inverse = (3 * denominator) ^ 2;
593 
594             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
595             // in modular arithmetic, doubling the correct bits in each step.
596             inverse *= 2 - denominator * inverse; // inverse mod 2^8
597             inverse *= 2 - denominator * inverse; // inverse mod 2^16
598             inverse *= 2 - denominator * inverse; // inverse mod 2^32
599             inverse *= 2 - denominator * inverse; // inverse mod 2^64
600             inverse *= 2 - denominator * inverse; // inverse mod 2^128
601             inverse *= 2 - denominator * inverse; // inverse mod 2^256
602 
603             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
604             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
605             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
606             // is no longer required.
607             result = prod0 * inverse;
608             return result;
609         }
610     }
611 
612     /**
613      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
614      */
615     function mulDiv(
616         uint256 x,
617         uint256 y,
618         uint256 denominator,
619         Rounding rounding
620     ) internal pure returns (uint256) {
621         uint256 result = mulDiv(x, y, denominator);
622         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
623             result += 1;
624         }
625         return result;
626     }
627 
628     /**
629      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
630      *
631      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
632      */
633     function sqrt(uint256 a) internal pure returns (uint256) {
634         if (a == 0) {
635             return 0;
636         }
637 
638         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
639         //
640         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
641         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
642         //
643         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
644         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
645         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
646         //
647         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
648         uint256 result = 1 << (log2(a) >> 1);
649 
650         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
651         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
652         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
653         // into the expected uint128 result.
654         unchecked {
655             result = (result + a / result) >> 1;
656             result = (result + a / result) >> 1;
657             result = (result + a / result) >> 1;
658             result = (result + a / result) >> 1;
659             result = (result + a / result) >> 1;
660             result = (result + a / result) >> 1;
661             result = (result + a / result) >> 1;
662             return min(result, a / result);
663         }
664     }
665 
666     /**
667      * @notice Calculates sqrt(a), following the selected rounding direction.
668      */
669     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
670         unchecked {
671             uint256 result = sqrt(a);
672             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
673         }
674     }
675 
676     /**
677      * @dev Return the log in base 2, rounded down, of a positive value.
678      * Returns 0 if given 0.
679      */
680     function log2(uint256 value) internal pure returns (uint256) {
681         uint256 result = 0;
682         unchecked {
683             if (value >> 128 > 0) {
684                 value >>= 128;
685                 result += 128;
686             }
687             if (value >> 64 > 0) {
688                 value >>= 64;
689                 result += 64;
690             }
691             if (value >> 32 > 0) {
692                 value >>= 32;
693                 result += 32;
694             }
695             if (value >> 16 > 0) {
696                 value >>= 16;
697                 result += 16;
698             }
699             if (value >> 8 > 0) {
700                 value >>= 8;
701                 result += 8;
702             }
703             if (value >> 4 > 0) {
704                 value >>= 4;
705                 result += 4;
706             }
707             if (value >> 2 > 0) {
708                 value >>= 2;
709                 result += 2;
710             }
711             if (value >> 1 > 0) {
712                 result += 1;
713             }
714         }
715         return result;
716     }
717 
718     /**
719      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
720      * Returns 0 if given 0.
721      */
722     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
723         unchecked {
724             uint256 result = log2(value);
725             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
726         }
727     }
728 
729     /**
730      * @dev Return the log in base 10, rounded down, of a positive value.
731      * Returns 0 if given 0.
732      */
733     function log10(uint256 value) internal pure returns (uint256) {
734         uint256 result = 0;
735         unchecked {
736             if (value >= 10**64) {
737                 value /= 10**64;
738                 result += 64;
739             }
740             if (value >= 10**32) {
741                 value /= 10**32;
742                 result += 32;
743             }
744             if (value >= 10**16) {
745                 value /= 10**16;
746                 result += 16;
747             }
748             if (value >= 10**8) {
749                 value /= 10**8;
750                 result += 8;
751             }
752             if (value >= 10**4) {
753                 value /= 10**4;
754                 result += 4;
755             }
756             if (value >= 10**2) {
757                 value /= 10**2;
758                 result += 2;
759             }
760             if (value >= 10**1) {
761                 result += 1;
762             }
763         }
764         return result;
765     }
766 
767     /**
768      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
769      * Returns 0 if given 0.
770      */
771     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
772         unchecked {
773             uint256 result = log10(value);
774             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
775         }
776     }
777 
778     /**
779      * @dev Return the log in base 256, rounded down, of a positive value.
780      * Returns 0 if given 0.
781      *
782      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
783      */
784     function log256(uint256 value) internal pure returns (uint256) {
785         uint256 result = 0;
786         unchecked {
787             if (value >> 128 > 0) {
788                 value >>= 128;
789                 result += 16;
790             }
791             if (value >> 64 > 0) {
792                 value >>= 64;
793                 result += 8;
794             }
795             if (value >> 32 > 0) {
796                 value >>= 32;
797                 result += 4;
798             }
799             if (value >> 16 > 0) {
800                 value >>= 16;
801                 result += 2;
802             }
803             if (value >> 8 > 0) {
804                 result += 1;
805             }
806         }
807         return result;
808     }
809 
810     /**
811      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
812      * Returns 0 if given 0.
813      */
814     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
815         unchecked {
816             uint256 result = log256(value);
817             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
818         }
819     }
820 }
821 
822 // File: @openzeppelin/contracts/utils/Strings.sol
823 
824 
825 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
826 
827 pragma solidity ^0.8.0;
828 
829 
830 /**
831  * @dev String operations.
832  */
833 library Strings {
834     bytes16 private constant _SYMBOLS = "0123456789abcdef";
835     uint8 private constant _ADDRESS_LENGTH = 20;
836 
837     /**
838      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
839      */
840     function toString(uint256 value) internal pure returns (string memory) {
841         unchecked {
842             uint256 length = Math.log10(value) + 1;
843             string memory buffer = new string(length);
844             uint256 ptr;
845             /// @solidity memory-safe-assembly
846             assembly {
847                 ptr := add(buffer, add(32, length))
848             }
849             while (true) {
850                 ptr--;
851                 /// @solidity memory-safe-assembly
852                 assembly {
853                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
854                 }
855                 value /= 10;
856                 if (value == 0) break;
857             }
858             return buffer;
859         }
860     }
861 
862     /**
863      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
864      */
865     function toHexString(uint256 value) internal pure returns (string memory) {
866         unchecked {
867             return toHexString(value, Math.log256(value) + 1);
868         }
869     }
870 
871     /**
872      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
873      */
874     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
875         bytes memory buffer = new bytes(2 * length + 2);
876         buffer[0] = "0";
877         buffer[1] = "x";
878         for (uint256 i = 2 * length + 1; i > 1; --i) {
879             buffer[i] = _SYMBOLS[value & 0xf];
880             value >>= 4;
881         }
882         require(value == 0, "Strings: hex length insufficient");
883         return string(buffer);
884     }
885 
886     /**
887      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
888      */
889     function toHexString(address addr) internal pure returns (string memory) {
890         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
891     }
892 }
893 
894 // File: @openzeppelin/contracts/utils/Context.sol
895 
896 
897 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
898 
899 pragma solidity ^0.8.0;
900 
901 /**
902  * @dev Provides information about the current execution context, including the
903  * sender of the transaction and its data. While these are generally available
904  * via msg.sender and msg.data, they should not be accessed in such a direct
905  * manner, since when dealing with meta-transactions the account sending and
906  * paying for execution may not be the actual sender (as far as an application
907  * is concerned).
908  *
909  * This contract is only required for intermediate, library-like contracts.
910  */
911 abstract contract Context {
912     function _msgSender() internal view virtual returns (address) {
913         return msg.sender;
914     }
915 
916     function _msgData() internal view virtual returns (bytes calldata) {
917         return msg.data;
918     }
919 }
920 
921 // File: @openzeppelin/contracts/access/Ownable.sol
922 
923 
924 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
925 
926 pragma solidity ^0.8.0;
927 
928 
929 /**
930  * @dev Contract module which provides a basic access control mechanism, where
931  * there is an account (an owner) that can be granted exclusive access to
932  * specific functions.
933  *
934  * By default, the owner account will be the one that deploys the contract. This
935  * can later be changed with {transferOwnership}.
936  *
937  * This module is used through inheritance. It will make available the modifier
938  * `onlyOwner`, which can be applied to your functions to restrict their use to
939  * the owner.
940  */
941 abstract contract Ownable is Context {
942     address private _owner;
943 
944     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
945 
946     /**
947      * @dev Initializes the contract setting the deployer as the initial owner.
948      */
949     constructor() {
950         _transferOwnership(_msgSender());
951     }
952 
953     /**
954      * @dev Throws if called by any account other than the owner.
955      */
956     modifier onlyOwner() {
957         _checkOwner();
958         _;
959     }
960 
961     /**
962      * @dev Returns the address of the current owner.
963      */
964     function owner() public view virtual returns (address) {
965         return _owner;
966     }
967 
968     /**
969      * @dev Throws if the sender is not the owner.
970      */
971     function _checkOwner() internal view virtual {
972         require(owner() == _msgSender(), "Ownable: caller is not the owner");
973     }
974 
975     /**
976      * @dev Leaves the contract without owner. It will not be possible to call
977      * `onlyOwner` functions anymore. Can only be called by the current owner.
978      *
979      * NOTE: Renouncing ownership will leave the contract without an owner,
980      * thereby removing any functionality that is only available to the owner.
981      */
982     function renounceOwnership() public virtual onlyOwner {
983         _transferOwnership(address(0));
984     }
985 
986     /**
987      * @dev Transfers ownership of the contract to a new account (`newOwner`).
988      * Can only be called by the current owner.
989      */
990     function transferOwnership(address newOwner) public virtual onlyOwner {
991         require(newOwner != address(0), "Ownable: new owner is the zero address");
992         _transferOwnership(newOwner);
993     }
994 
995     /**
996      * @dev Transfers ownership of the contract to a new account (`newOwner`).
997      * Internal function without access restriction.
998      */
999     function _transferOwnership(address newOwner) internal virtual {
1000         address oldOwner = _owner;
1001         _owner = newOwner;
1002         emit OwnershipTransferred(oldOwner, newOwner);
1003     }
1004 }
1005 
1006 // File: erc721a/contracts/IERC721A.sol
1007 
1008 
1009 // ERC721A Contracts v4.2.3
1010 // Creator: Chiru Labs
1011 
1012 pragma solidity ^0.8.4;
1013 
1014 /**
1015  * @dev Interface of ERC721A.
1016  */
1017 interface IERC721A {
1018     /**
1019      * The caller must own the token or be an approved operator.
1020      */
1021     error ApprovalCallerNotOwnerNorApproved();
1022 
1023     /**
1024      * The token does not exist.
1025      */
1026     error ApprovalQueryForNonexistentToken();
1027 
1028     /**
1029      * Cannot query the balance for the zero address.
1030      */
1031     error BalanceQueryForZeroAddress();
1032 
1033     /**
1034      * Cannot mint to the zero address.
1035      */
1036     error MintToZeroAddress();
1037 
1038     /**
1039      * The quantity of tokens minted must be more than zero.
1040      */
1041     error MintZeroQuantity();
1042 
1043     /**
1044      * The token does not exist.
1045      */
1046     error OwnerQueryForNonexistentToken();
1047 
1048     /**
1049      * The caller must own the token or be an approved operator.
1050      */
1051     error TransferCallerNotOwnerNorApproved();
1052 
1053     /**
1054      * The token must be owned by `from`.
1055      */
1056     error TransferFromIncorrectOwner();
1057 
1058     /**
1059      * Cannot safely transfer to a contract that does not implement the
1060      * ERC721Receiver interface.
1061      */
1062     error TransferToNonERC721ReceiverImplementer();
1063 
1064     /**
1065      * Cannot transfer to the zero address.
1066      */
1067     error TransferToZeroAddress();
1068 
1069     /**
1070      * The token does not exist.
1071      */
1072     error URIQueryForNonexistentToken();
1073 
1074     /**
1075      * The `quantity` minted with ERC2309 exceeds the safety limit.
1076      */
1077     error MintERC2309QuantityExceedsLimit();
1078 
1079     /**
1080      * The `extraData` cannot be set on an unintialized ownership slot.
1081      */
1082     error OwnershipNotInitializedForExtraData();
1083 
1084     // =============================================================
1085     //                            STRUCTS
1086     // =============================================================
1087 
1088     struct TokenOwnership {
1089         // The address of the owner.
1090         address addr;
1091         // Stores the start time of ownership with minimal overhead for tokenomics.
1092         uint64 startTimestamp;
1093         // Whether the token has been burned.
1094         bool burned;
1095         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1096         uint24 extraData;
1097     }
1098 
1099     // =============================================================
1100     //                         TOKEN COUNTERS
1101     // =============================================================
1102 
1103     /**
1104      * @dev Returns the total number of tokens in existence.
1105      * Burned tokens will reduce the count.
1106      * To get the total number of tokens minted, please see {_totalMinted}.
1107      */
1108     function totalSupply() external view returns (uint256);
1109 
1110     // =============================================================
1111     //                            IERC165
1112     // =============================================================
1113 
1114     /**
1115      * @dev Returns true if this contract implements the interface defined by
1116      * `interfaceId`. See the corresponding
1117      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1118      * to learn more about how these ids are created.
1119      *
1120      * This function call must use less than 30000 gas.
1121      */
1122     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1123 
1124     // =============================================================
1125     //                            IERC721
1126     // =============================================================
1127 
1128     /**
1129      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1130      */
1131     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1132 
1133     /**
1134      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1135      */
1136     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1137 
1138     /**
1139      * @dev Emitted when `owner` enables or disables
1140      * (`approved`) `operator` to manage all of its assets.
1141      */
1142     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1143 
1144     /**
1145      * @dev Returns the number of tokens in `owner`'s account.
1146      */
1147     function balanceOf(address owner) external view returns (uint256 balance);
1148 
1149     /**
1150      * @dev Returns the owner of the `tokenId` token.
1151      *
1152      * Requirements:
1153      *
1154      * - `tokenId` must exist.
1155      */
1156     function ownerOf(uint256 tokenId) external view returns (address owner);
1157 
1158     /**
1159      * @dev Safely transfers `tokenId` token from `from` to `to`,
1160      * checking first that contract recipients are aware of the ERC721 protocol
1161      * to prevent tokens from being forever locked.
1162      *
1163      * Requirements:
1164      *
1165      * - `from` cannot be the zero address.
1166      * - `to` cannot be the zero address.
1167      * - `tokenId` token must exist and be owned by `from`.
1168      * - If the caller is not `from`, it must be have been allowed to move
1169      * this token by either {approve} or {setApprovalForAll}.
1170      * - If `to` refers to a smart contract, it must implement
1171      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function safeTransferFrom(
1176         address from,
1177         address to,
1178         uint256 tokenId,
1179         bytes calldata data
1180     ) external payable;
1181 
1182     /**
1183      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1184      */
1185     function safeTransferFrom(
1186         address from,
1187         address to,
1188         uint256 tokenId
1189     ) external payable;
1190 
1191     /**
1192      * @dev Transfers `tokenId` from `from` to `to`.
1193      *
1194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1195      * whenever possible.
1196      *
1197      * Requirements:
1198      *
1199      * - `from` cannot be the zero address.
1200      * - `to` cannot be the zero address.
1201      * - `tokenId` token must be owned by `from`.
1202      * - If the caller is not `from`, it must be approved to move this token
1203      * by either {approve} or {setApprovalForAll}.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function transferFrom(
1208         address from,
1209         address to,
1210         uint256 tokenId
1211     ) external payable;
1212 
1213     /**
1214      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1215      * The approval is cleared when the token is transferred.
1216      *
1217      * Only a single account can be approved at a time, so approving the
1218      * zero address clears previous approvals.
1219      *
1220      * Requirements:
1221      *
1222      * - The caller must own the token or be an approved operator.
1223      * - `tokenId` must exist.
1224      *
1225      * Emits an {Approval} event.
1226      */
1227     function approve(address to, uint256 tokenId) external payable;
1228 
1229     /**
1230      * @dev Approve or remove `operator` as an operator for the caller.
1231      * Operators can call {transferFrom} or {safeTransferFrom}
1232      * for any token owned by the caller.
1233      *
1234      * Requirements:
1235      *
1236      * - The `operator` cannot be the caller.
1237      *
1238      * Emits an {ApprovalForAll} event.
1239      */
1240     function setApprovalForAll(address operator, bool _approved) external;
1241 
1242     /**
1243      * @dev Returns the account approved for `tokenId` token.
1244      *
1245      * Requirements:
1246      *
1247      * - `tokenId` must exist.
1248      */
1249     function getApproved(uint256 tokenId) external view returns (address operator);
1250 
1251     /**
1252      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1253      *
1254      * See {setApprovalForAll}.
1255      */
1256     function isApprovedForAll(address owner, address operator) external view returns (bool);
1257 
1258     // =============================================================
1259     //                        IERC721Metadata
1260     // =============================================================
1261 
1262     /**
1263      * @dev Returns the token collection name.
1264      */
1265     function name() external view returns (string memory);
1266 
1267     /**
1268      * @dev Returns the token collection symbol.
1269      */
1270     function symbol() external view returns (string memory);
1271 
1272     /**
1273      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1274      */
1275     function tokenURI(uint256 tokenId) external view returns (string memory);
1276 
1277     // =============================================================
1278     //                           IERC2309
1279     // =============================================================
1280 
1281     /**
1282      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1283      * (inclusive) is transferred from `from` to `to`, as defined in the
1284      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1285      *
1286      * See {_mintERC2309} for more details.
1287      */
1288     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1289 }
1290 
1291 // File: erc721a/contracts/ERC721A.sol
1292 
1293 
1294 // ERC721A Contracts v4.2.3
1295 // Creator: Chiru Labs
1296 
1297 pragma solidity ^0.8.4;
1298 
1299 
1300 /**
1301  * @dev Interface of ERC721 token receiver.
1302  */
1303 interface ERC721A__IERC721Receiver {
1304     function onERC721Received(
1305         address operator,
1306         address from,
1307         uint256 tokenId,
1308         bytes calldata data
1309     ) external returns (bytes4);
1310 }
1311 
1312 /**
1313  * @title ERC721A
1314  *
1315  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1316  * Non-Fungible Token Standard, including the Metadata extension.
1317  * Optimized for lower gas during batch mints.
1318  *
1319  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1320  * starting from `_startTokenId()`.
1321  *
1322  * Assumptions:
1323  *
1324  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1325  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1326  */
1327 contract ERC721A is IERC721A {
1328     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1329     struct TokenApprovalRef {
1330         address value;
1331     }
1332 
1333     // =============================================================
1334     //                           CONSTANTS
1335     // =============================================================
1336 
1337     // Mask of an entry in packed address data.
1338     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1339 
1340     // The bit position of `numberMinted` in packed address data.
1341     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1342 
1343     // The bit position of `numberBurned` in packed address data.
1344     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1345 
1346     // The bit position of `aux` in packed address data.
1347     uint256 private constant _BITPOS_AUX = 192;
1348 
1349     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1350     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1351 
1352     // The bit position of `startTimestamp` in packed ownership.
1353     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1354 
1355     // The bit mask of the `burned` bit in packed ownership.
1356     uint256 private constant _BITMASK_BURNED = 1 << 224;
1357 
1358     // The bit position of the `nextInitialized` bit in packed ownership.
1359     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1360 
1361     // The bit mask of the `nextInitialized` bit in packed ownership.
1362     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1363 
1364     // The bit position of `extraData` in packed ownership.
1365     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1366 
1367     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1368     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1369 
1370     // The mask of the lower 160 bits for addresses.
1371     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1372 
1373     // The maximum `quantity` that can be minted with {_mintERC2309}.
1374     // This limit is to prevent overflows on the address data entries.
1375     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1376     // is required to cause an overflow, which is unrealistic.
1377     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1378 
1379     // The `Transfer` event signature is given by:
1380     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1381     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1382         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1383 
1384     // =============================================================
1385     //                            STORAGE
1386     // =============================================================
1387 
1388     // The next token ID to be minted.
1389     uint256 private _currentIndex;
1390 
1391     // The number of tokens burned.
1392     uint256 private _burnCounter;
1393 
1394     // Token name
1395     string private _name;
1396 
1397     // Token symbol
1398     string private _symbol;
1399 
1400     // Mapping from token ID to ownership details
1401     // An empty struct value does not necessarily mean the token is unowned.
1402     // See {_packedOwnershipOf} implementation for details.
1403     //
1404     // Bits Layout:
1405     // - [0..159]   `addr`
1406     // - [160..223] `startTimestamp`
1407     // - [224]      `burned`
1408     // - [225]      `nextInitialized`
1409     // - [232..255] `extraData`
1410     mapping(uint256 => uint256) private _packedOwnerships;
1411 
1412     // Mapping owner address to address data.
1413     //
1414     // Bits Layout:
1415     // - [0..63]    `balance`
1416     // - [64..127]  `numberMinted`
1417     // - [128..191] `numberBurned`
1418     // - [192..255] `aux`
1419     mapping(address => uint256) private _packedAddressData;
1420 
1421     // Mapping from token ID to approved address.
1422     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1423 
1424     // Mapping from owner to operator approvals
1425     mapping(address => mapping(address => bool)) private _operatorApprovals;
1426 
1427     // =============================================================
1428     //                          CONSTRUCTOR
1429     // =============================================================
1430 
1431     constructor(string memory name_, string memory symbol_) {
1432         _name = name_;
1433         _symbol = symbol_;
1434         _currentIndex = _startTokenId();
1435     }
1436 
1437     // =============================================================
1438     //                   TOKEN COUNTING OPERATIONS
1439     // =============================================================
1440 
1441     /**
1442      * @dev Returns the starting token ID.
1443      * To change the starting token ID, please override this function.
1444      */
1445     function _startTokenId() internal view virtual returns (uint256) {
1446         return 0;
1447     }
1448 
1449     /**
1450      * @dev Returns the next token ID to be minted.
1451      */
1452     function _nextTokenId() internal view virtual returns (uint256) {
1453         return _currentIndex;
1454     }
1455 
1456     /**
1457      * @dev Returns the total number of tokens in existence.
1458      * Burned tokens will reduce the count.
1459      * To get the total number of tokens minted, please see {_totalMinted}.
1460      */
1461     function totalSupply() public view virtual override returns (uint256) {
1462         // Counter underflow is impossible as _burnCounter cannot be incremented
1463         // more than `_currentIndex - _startTokenId()` times.
1464         unchecked {
1465             return _currentIndex - _burnCounter - _startTokenId();
1466         }
1467     }
1468 
1469     /**
1470      * @dev Returns the total amount of tokens minted in the contract.
1471      */
1472     function _totalMinted() internal view virtual returns (uint256) {
1473         // Counter underflow is impossible as `_currentIndex` does not decrement,
1474         // and it is initialized to `_startTokenId()`.
1475         unchecked {
1476             return _currentIndex - _startTokenId();
1477         }
1478     }
1479 
1480     /**
1481      * @dev Returns the total number of tokens burned.
1482      */
1483     function _totalBurned() internal view virtual returns (uint256) {
1484         return _burnCounter;
1485     }
1486 
1487     // =============================================================
1488     //                    ADDRESS DATA OPERATIONS
1489     // =============================================================
1490 
1491     /**
1492      * @dev Returns the number of tokens in `owner`'s account.
1493      */
1494     function balanceOf(address owner) public view virtual override returns (uint256) {
1495         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1496         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1497     }
1498 
1499     /**
1500      * Returns the number of tokens minted by `owner`.
1501      */
1502     function _numberMinted(address owner) internal view returns (uint256) {
1503         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1504     }
1505 
1506     /**
1507      * Returns the number of tokens burned by or on behalf of `owner`.
1508      */
1509     function _numberBurned(address owner) internal view returns (uint256) {
1510         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1511     }
1512 
1513     /**
1514      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1515      */
1516     function _getAux(address owner) internal view returns (uint64) {
1517         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1518     }
1519 
1520     /**
1521      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1522      * If there are multiple variables, please pack them into a uint64.
1523      */
1524     function _setAux(address owner, uint64 aux) internal virtual {
1525         uint256 packed = _packedAddressData[owner];
1526         uint256 auxCasted;
1527         // Cast `aux` with assembly to avoid redundant masking.
1528         assembly {
1529             auxCasted := aux
1530         }
1531         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1532         _packedAddressData[owner] = packed;
1533     }
1534 
1535     // =============================================================
1536     //                            IERC165
1537     // =============================================================
1538 
1539     /**
1540      * @dev Returns true if this contract implements the interface defined by
1541      * `interfaceId`. See the corresponding
1542      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1543      * to learn more about how these ids are created.
1544      *
1545      * This function call must use less than 30000 gas.
1546      */
1547     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1548         // The interface IDs are constants representing the first 4 bytes
1549         // of the XOR of all function selectors in the interface.
1550         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1551         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1552         return
1553             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1554             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1555             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1556     }
1557 
1558     // =============================================================
1559     //                        IERC721Metadata
1560     // =============================================================
1561 
1562     /**
1563      * @dev Returns the token collection name.
1564      */
1565     function name() public view virtual override returns (string memory) {
1566         return _name;
1567     }
1568 
1569     /**
1570      * @dev Returns the token collection symbol.
1571      */
1572     function symbol() public view virtual override returns (string memory) {
1573         return _symbol;
1574     }
1575 
1576     /**
1577      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1578      */
1579     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1580         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1581 
1582         string memory baseURI = _baseURI();
1583         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1584     }
1585 
1586     /**
1587      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1588      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1589      * by default, it can be overridden in child contracts.
1590      */
1591     function _baseURI() internal view virtual returns (string memory) {
1592         return '';
1593     }
1594 
1595     // =============================================================
1596     //                     OWNERSHIPS OPERATIONS
1597     // =============================================================
1598 
1599     /**
1600      * @dev Returns the owner of the `tokenId` token.
1601      *
1602      * Requirements:
1603      *
1604      * - `tokenId` must exist.
1605      */
1606     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1607         return address(uint160(_packedOwnershipOf(tokenId)));
1608     }
1609 
1610     /**
1611      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1612      * It gradually moves to O(1) as tokens get transferred around over time.
1613      */
1614     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1615         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1616     }
1617 
1618     /**
1619      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1620      */
1621     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1622         return _unpackedOwnership(_packedOwnerships[index]);
1623     }
1624 
1625     /**
1626      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1627      */
1628     function _initializeOwnershipAt(uint256 index) internal virtual {
1629         if (_packedOwnerships[index] == 0) {
1630             _packedOwnerships[index] = _packedOwnershipOf(index);
1631         }
1632     }
1633 
1634     /**
1635      * Returns the packed ownership data of `tokenId`.
1636      */
1637     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1638         uint256 curr = tokenId;
1639 
1640         unchecked {
1641             if (_startTokenId() <= curr)
1642                 if (curr < _currentIndex) {
1643                     uint256 packed = _packedOwnerships[curr];
1644                     // If not burned.
1645                     if (packed & _BITMASK_BURNED == 0) {
1646                         // Invariant:
1647                         // There will always be an initialized ownership slot
1648                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1649                         // before an unintialized ownership slot
1650                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1651                         // Hence, `curr` will not underflow.
1652                         //
1653                         // We can directly compare the packed value.
1654                         // If the address is zero, packed will be zero.
1655                         while (packed == 0) {
1656                             packed = _packedOwnerships[--curr];
1657                         }
1658                         return packed;
1659                     }
1660                 }
1661         }
1662         revert OwnerQueryForNonexistentToken();
1663     }
1664 
1665     /**
1666      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1667      */
1668     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1669         ownership.addr = address(uint160(packed));
1670         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1671         ownership.burned = packed & _BITMASK_BURNED != 0;
1672         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1673     }
1674 
1675     /**
1676      * @dev Packs ownership data into a single uint256.
1677      */
1678     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1679         assembly {
1680             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1681             owner := and(owner, _BITMASK_ADDRESS)
1682             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1683             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1684         }
1685     }
1686 
1687     /**
1688      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1689      */
1690     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1691         // For branchless setting of the `nextInitialized` flag.
1692         assembly {
1693             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1694             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1695         }
1696     }
1697 
1698     // =============================================================
1699     //                      APPROVAL OPERATIONS
1700     // =============================================================
1701 
1702     /**
1703      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1704      * The approval is cleared when the token is transferred.
1705      *
1706      * Only a single account can be approved at a time, so approving the
1707      * zero address clears previous approvals.
1708      *
1709      * Requirements:
1710      *
1711      * - The caller must own the token or be an approved operator.
1712      * - `tokenId` must exist.
1713      *
1714      * Emits an {Approval} event.
1715      */
1716     function approve(address to, uint256 tokenId) public payable virtual override {
1717         address owner = ownerOf(tokenId);
1718 
1719         if (_msgSenderERC721A() != owner)
1720             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1721                 revert ApprovalCallerNotOwnerNorApproved();
1722             }
1723 
1724         _tokenApprovals[tokenId].value = to;
1725         emit Approval(owner, to, tokenId);
1726     }
1727 
1728     /**
1729      * @dev Returns the account approved for `tokenId` token.
1730      *
1731      * Requirements:
1732      *
1733      * - `tokenId` must exist.
1734      */
1735     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1736         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1737 
1738         return _tokenApprovals[tokenId].value;
1739     }
1740 
1741     /**
1742      * @dev Approve or remove `operator` as an operator for the caller.
1743      * Operators can call {transferFrom} or {safeTransferFrom}
1744      * for any token owned by the caller.
1745      *
1746      * Requirements:
1747      *
1748      * - The `operator` cannot be the caller.
1749      *
1750      * Emits an {ApprovalForAll} event.
1751      */
1752     function setApprovalForAll(address operator, bool approved) public virtual override {
1753         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1754         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1755     }
1756 
1757     /**
1758      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1759      *
1760      * See {setApprovalForAll}.
1761      */
1762     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1763         return _operatorApprovals[owner][operator];
1764     }
1765 
1766     /**
1767      * @dev Returns whether `tokenId` exists.
1768      *
1769      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1770      *
1771      * Tokens start existing when they are minted. See {_mint}.
1772      */
1773     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1774         return
1775             _startTokenId() <= tokenId &&
1776             tokenId < _currentIndex && // If within bounds,
1777             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1778     }
1779 
1780     /**
1781      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1782      */
1783     function _isSenderApprovedOrOwner(
1784         address approvedAddress,
1785         address owner,
1786         address msgSender
1787     ) private pure returns (bool result) {
1788         assembly {
1789             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1790             owner := and(owner, _BITMASK_ADDRESS)
1791             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1792             msgSender := and(msgSender, _BITMASK_ADDRESS)
1793             // `msgSender == owner || msgSender == approvedAddress`.
1794             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1795         }
1796     }
1797 
1798     /**
1799      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1800      */
1801     function _getApprovedSlotAndAddress(uint256 tokenId)
1802         private
1803         view
1804         returns (uint256 approvedAddressSlot, address approvedAddress)
1805     {
1806         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1807         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1808         assembly {
1809             approvedAddressSlot := tokenApproval.slot
1810             approvedAddress := sload(approvedAddressSlot)
1811         }
1812     }
1813 
1814     // =============================================================
1815     //                      TRANSFER OPERATIONS
1816     // =============================================================
1817 
1818     /**
1819      * @dev Transfers `tokenId` from `from` to `to`.
1820      *
1821      * Requirements:
1822      *
1823      * - `from` cannot be the zero address.
1824      * - `to` cannot be the zero address.
1825      * - `tokenId` token must be owned by `from`.
1826      * - If the caller is not `from`, it must be approved to move this token
1827      * by either {approve} or {setApprovalForAll}.
1828      *
1829      * Emits a {Transfer} event.
1830      */
1831     function transferFrom(
1832         address from,
1833         address to,
1834         uint256 tokenId
1835     ) public payable virtual override {
1836         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1837 
1838         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1839 
1840         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1841 
1842         // The nested ifs save around 20+ gas over a compound boolean condition.
1843         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1844             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1845 
1846         if (to == address(0)) revert TransferToZeroAddress();
1847 
1848         _beforeTokenTransfers(from, to, tokenId, 1);
1849 
1850         // Clear approvals from the previous owner.
1851         assembly {
1852             if approvedAddress {
1853                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1854                 sstore(approvedAddressSlot, 0)
1855             }
1856         }
1857 
1858         // Underflow of the sender's balance is impossible because we check for
1859         // ownership above and the recipient's balance can't realistically overflow.
1860         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1861         unchecked {
1862             // We can directly increment and decrement the balances.
1863             --_packedAddressData[from]; // Updates: `balance -= 1`.
1864             ++_packedAddressData[to]; // Updates: `balance += 1`.
1865 
1866             // Updates:
1867             // - `address` to the next owner.
1868             // - `startTimestamp` to the timestamp of transfering.
1869             // - `burned` to `false`.
1870             // - `nextInitialized` to `true`.
1871             _packedOwnerships[tokenId] = _packOwnershipData(
1872                 to,
1873                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1874             );
1875 
1876             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1877             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1878                 uint256 nextTokenId = tokenId + 1;
1879                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1880                 if (_packedOwnerships[nextTokenId] == 0) {
1881                     // If the next slot is within bounds.
1882                     if (nextTokenId != _currentIndex) {
1883                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1884                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1885                     }
1886                 }
1887             }
1888         }
1889 
1890         emit Transfer(from, to, tokenId);
1891         _afterTokenTransfers(from, to, tokenId, 1);
1892     }
1893 
1894     /**
1895      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1896      */
1897     function safeTransferFrom(
1898         address from,
1899         address to,
1900         uint256 tokenId
1901     ) public payable virtual override {
1902         safeTransferFrom(from, to, tokenId, '');
1903     }
1904 
1905     /**
1906      * @dev Safely transfers `tokenId` token from `from` to `to`.
1907      *
1908      * Requirements:
1909      *
1910      * - `from` cannot be the zero address.
1911      * - `to` cannot be the zero address.
1912      * - `tokenId` token must exist and be owned by `from`.
1913      * - If the caller is not `from`, it must be approved to move this token
1914      * by either {approve} or {setApprovalForAll}.
1915      * - If `to` refers to a smart contract, it must implement
1916      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1917      *
1918      * Emits a {Transfer} event.
1919      */
1920     function safeTransferFrom(
1921         address from,
1922         address to,
1923         uint256 tokenId,
1924         bytes memory _data
1925     ) public payable virtual override {
1926         transferFrom(from, to, tokenId);
1927         if (to.code.length != 0)
1928             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1929                 revert TransferToNonERC721ReceiverImplementer();
1930             }
1931     }
1932 
1933     /**
1934      * @dev Hook that is called before a set of serially-ordered token IDs
1935      * are about to be transferred. This includes minting.
1936      * And also called before burning one token.
1937      *
1938      * `startTokenId` - the first token ID to be transferred.
1939      * `quantity` - the amount to be transferred.
1940      *
1941      * Calling conditions:
1942      *
1943      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1944      * transferred to `to`.
1945      * - When `from` is zero, `tokenId` will be minted for `to`.
1946      * - When `to` is zero, `tokenId` will be burned by `from`.
1947      * - `from` and `to` are never both zero.
1948      */
1949     function _beforeTokenTransfers(
1950         address from,
1951         address to,
1952         uint256 startTokenId,
1953         uint256 quantity
1954     ) internal virtual {}
1955 
1956     /**
1957      * @dev Hook that is called after a set of serially-ordered token IDs
1958      * have been transferred. This includes minting.
1959      * And also called after one token has been burned.
1960      *
1961      * `startTokenId` - the first token ID to be transferred.
1962      * `quantity` - the amount to be transferred.
1963      *
1964      * Calling conditions:
1965      *
1966      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1967      * transferred to `to`.
1968      * - When `from` is zero, `tokenId` has been minted for `to`.
1969      * - When `to` is zero, `tokenId` has been burned by `from`.
1970      * - `from` and `to` are never both zero.
1971      */
1972     function _afterTokenTransfers(
1973         address from,
1974         address to,
1975         uint256 startTokenId,
1976         uint256 quantity
1977     ) internal virtual {}
1978 
1979     /**
1980      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1981      *
1982      * `from` - Previous owner of the given token ID.
1983      * `to` - Target address that will receive the token.
1984      * `tokenId` - Token ID to be transferred.
1985      * `_data` - Optional data to send along with the call.
1986      *
1987      * Returns whether the call correctly returned the expected magic value.
1988      */
1989     function _checkContractOnERC721Received(
1990         address from,
1991         address to,
1992         uint256 tokenId,
1993         bytes memory _data
1994     ) private returns (bool) {
1995         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1996             bytes4 retval
1997         ) {
1998             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1999         } catch (bytes memory reason) {
2000             if (reason.length == 0) {
2001                 revert TransferToNonERC721ReceiverImplementer();
2002             } else {
2003                 assembly {
2004                     revert(add(32, reason), mload(reason))
2005                 }
2006             }
2007         }
2008     }
2009 
2010     // =============================================================
2011     //                        MINT OPERATIONS
2012     // =============================================================
2013 
2014     /**
2015      * @dev Mints `quantity` tokens and transfers them to `to`.
2016      *
2017      * Requirements:
2018      *
2019      * - `to` cannot be the zero address.
2020      * - `quantity` must be greater than 0.
2021      *
2022      * Emits a {Transfer} event for each mint.
2023      */
2024     function _mint(address to, uint256 quantity) internal virtual {
2025         uint256 startTokenId = _currentIndex;
2026         if (quantity == 0) revert MintZeroQuantity();
2027 
2028         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2029 
2030         // Overflows are incredibly unrealistic.
2031         // `balance` and `numberMinted` have a maximum limit of 2**64.
2032         // `tokenId` has a maximum limit of 2**256.
2033         unchecked {
2034             // Updates:
2035             // - `balance += quantity`.
2036             // - `numberMinted += quantity`.
2037             //
2038             // We can directly add to the `balance` and `numberMinted`.
2039             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2040 
2041             // Updates:
2042             // - `address` to the owner.
2043             // - `startTimestamp` to the timestamp of minting.
2044             // - `burned` to `false`.
2045             // - `nextInitialized` to `quantity == 1`.
2046             _packedOwnerships[startTokenId] = _packOwnershipData(
2047                 to,
2048                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2049             );
2050 
2051             uint256 toMasked;
2052             uint256 end = startTokenId + quantity;
2053 
2054             // Use assembly to loop and emit the `Transfer` event for gas savings.
2055             // The duplicated `log4` removes an extra check and reduces stack juggling.
2056             // The assembly, together with the surrounding Solidity code, have been
2057             // delicately arranged to nudge the compiler into producing optimized opcodes.
2058             assembly {
2059                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2060                 toMasked := and(to, _BITMASK_ADDRESS)
2061                 // Emit the `Transfer` event.
2062                 log4(
2063                     0, // Start of data (0, since no data).
2064                     0, // End of data (0, since no data).
2065                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2066                     0, // `address(0)`.
2067                     toMasked, // `to`.
2068                     startTokenId // `tokenId`.
2069                 )
2070 
2071                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2072                 // that overflows uint256 will make the loop run out of gas.
2073                 // The compiler will optimize the `iszero` away for performance.
2074                 for {
2075                     let tokenId := add(startTokenId, 1)
2076                 } iszero(eq(tokenId, end)) {
2077                     tokenId := add(tokenId, 1)
2078                 } {
2079                     // Emit the `Transfer` event. Similar to above.
2080                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2081                 }
2082             }
2083             if (toMasked == 0) revert MintToZeroAddress();
2084 
2085             _currentIndex = end;
2086         }
2087         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2088     }
2089 
2090     /**
2091      * @dev Mints `quantity` tokens and transfers them to `to`.
2092      *
2093      * This function is intended for efficient minting only during contract creation.
2094      *
2095      * It emits only one {ConsecutiveTransfer} as defined in
2096      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2097      * instead of a sequence of {Transfer} event(s).
2098      *
2099      * Calling this function outside of contract creation WILL make your contract
2100      * non-compliant with the ERC721 standard.
2101      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2102      * {ConsecutiveTransfer} event is only permissible during contract creation.
2103      *
2104      * Requirements:
2105      *
2106      * - `to` cannot be the zero address.
2107      * - `quantity` must be greater than 0.
2108      *
2109      * Emits a {ConsecutiveTransfer} event.
2110      */
2111     function _mintERC2309(address to, uint256 quantity) internal virtual {
2112         uint256 startTokenId = _currentIndex;
2113         if (to == address(0)) revert MintToZeroAddress();
2114         if (quantity == 0) revert MintZeroQuantity();
2115         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2116 
2117         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2118 
2119         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2120         unchecked {
2121             // Updates:
2122             // - `balance += quantity`.
2123             // - `numberMinted += quantity`.
2124             //
2125             // We can directly add to the `balance` and `numberMinted`.
2126             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2127 
2128             // Updates:
2129             // - `address` to the owner.
2130             // - `startTimestamp` to the timestamp of minting.
2131             // - `burned` to `false`.
2132             // - `nextInitialized` to `quantity == 1`.
2133             _packedOwnerships[startTokenId] = _packOwnershipData(
2134                 to,
2135                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2136             );
2137 
2138             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2139 
2140             _currentIndex = startTokenId + quantity;
2141         }
2142         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2143     }
2144 
2145     /**
2146      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2147      *
2148      * Requirements:
2149      *
2150      * - If `to` refers to a smart contract, it must implement
2151      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2152      * - `quantity` must be greater than 0.
2153      *
2154      * See {_mint}.
2155      *
2156      * Emits a {Transfer} event for each mint.
2157      */
2158     function _safeMint(
2159         address to,
2160         uint256 quantity,
2161         bytes memory _data
2162     ) internal virtual {
2163         _mint(to, quantity);
2164 
2165         unchecked {
2166             if (to.code.length != 0) {
2167                 uint256 end = _currentIndex;
2168                 uint256 index = end - quantity;
2169                 do {
2170                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2171                         revert TransferToNonERC721ReceiverImplementer();
2172                     }
2173                 } while (index < end);
2174                 // Reentrancy protection.
2175                 if (_currentIndex != end) revert();
2176             }
2177         }
2178     }
2179 
2180     /**
2181      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2182      */
2183     function _safeMint(address to, uint256 quantity) internal virtual {
2184         _safeMint(to, quantity, '');
2185     }
2186 
2187     // =============================================================
2188     //                        BURN OPERATIONS
2189     // =============================================================
2190 
2191     /**
2192      * @dev Equivalent to `_burn(tokenId, false)`.
2193      */
2194     function _burn(uint256 tokenId) internal virtual {
2195         _burn(tokenId, false);
2196     }
2197 
2198     /**
2199      * @dev Destroys `tokenId`.
2200      * The approval is cleared when the token is burned.
2201      *
2202      * Requirements:
2203      *
2204      * - `tokenId` must exist.
2205      *
2206      * Emits a {Transfer} event.
2207      */
2208     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2209         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2210 
2211         address from = address(uint160(prevOwnershipPacked));
2212 
2213         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2214 
2215         if (approvalCheck) {
2216             // The nested ifs save around 20+ gas over a compound boolean condition.
2217             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2218                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2219         }
2220 
2221         _beforeTokenTransfers(from, address(0), tokenId, 1);
2222 
2223         // Clear approvals from the previous owner.
2224         assembly {
2225             if approvedAddress {
2226                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2227                 sstore(approvedAddressSlot, 0)
2228             }
2229         }
2230 
2231         // Underflow of the sender's balance is impossible because we check for
2232         // ownership above and the recipient's balance can't realistically overflow.
2233         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2234         unchecked {
2235             // Updates:
2236             // - `balance -= 1`.
2237             // - `numberBurned += 1`.
2238             //
2239             // We can directly decrement the balance, and increment the number burned.
2240             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2241             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2242 
2243             // Updates:
2244             // - `address` to the last owner.
2245             // - `startTimestamp` to the timestamp of burning.
2246             // - `burned` to `true`.
2247             // - `nextInitialized` to `true`.
2248             _packedOwnerships[tokenId] = _packOwnershipData(
2249                 from,
2250                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2251             );
2252 
2253             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2254             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2255                 uint256 nextTokenId = tokenId + 1;
2256                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2257                 if (_packedOwnerships[nextTokenId] == 0) {
2258                     // If the next slot is within bounds.
2259                     if (nextTokenId != _currentIndex) {
2260                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2261                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2262                     }
2263                 }
2264             }
2265         }
2266 
2267         emit Transfer(from, address(0), tokenId);
2268         _afterTokenTransfers(from, address(0), tokenId, 1);
2269 
2270         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2271         unchecked {
2272             _burnCounter++;
2273         }
2274     }
2275 
2276     // =============================================================
2277     //                     EXTRA DATA OPERATIONS
2278     // =============================================================
2279 
2280     /**
2281      * @dev Directly sets the extra data for the ownership data `index`.
2282      */
2283     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2284         uint256 packed = _packedOwnerships[index];
2285         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2286         uint256 extraDataCasted;
2287         // Cast `extraData` with assembly to avoid redundant masking.
2288         assembly {
2289             extraDataCasted := extraData
2290         }
2291         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2292         _packedOwnerships[index] = packed;
2293     }
2294 
2295     /**
2296      * @dev Called during each token transfer to set the 24bit `extraData` field.
2297      * Intended to be overridden by the cosumer contract.
2298      *
2299      * `previousExtraData` - the value of `extraData` before transfer.
2300      *
2301      * Calling conditions:
2302      *
2303      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2304      * transferred to `to`.
2305      * - When `from` is zero, `tokenId` will be minted for `to`.
2306      * - When `to` is zero, `tokenId` will be burned by `from`.
2307      * - `from` and `to` are never both zero.
2308      */
2309     function _extraData(
2310         address from,
2311         address to,
2312         uint24 previousExtraData
2313     ) internal view virtual returns (uint24) {}
2314 
2315     /**
2316      * @dev Returns the next extra data for the packed ownership data.
2317      * The returned result is shifted into position.
2318      */
2319     function _nextExtraData(
2320         address from,
2321         address to,
2322         uint256 prevOwnershipPacked
2323     ) private view returns (uint256) {
2324         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2325         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2326     }
2327 
2328     // =============================================================
2329     //                       OTHER OPERATIONS
2330     // =============================================================
2331 
2332     /**
2333      * @dev Returns the message sender (defaults to `msg.sender`).
2334      *
2335      * If you are writing GSN compatible contracts, you need to override this function.
2336      */
2337     function _msgSenderERC721A() internal view virtual returns (address) {
2338         return msg.sender;
2339     }
2340 
2341     /**
2342      * @dev Converts a uint256 to its ASCII string decimal representation.
2343      */
2344     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2345         assembly {
2346             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2347             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2348             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2349             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2350             let m := add(mload(0x40), 0xa0)
2351             // Update the free memory pointer to allocate.
2352             mstore(0x40, m)
2353             // Assign the `str` to the end.
2354             str := sub(m, 0x20)
2355             // Zeroize the slot after the string.
2356             mstore(str, 0)
2357 
2358             // Cache the end of the memory to calculate the length later.
2359             let end := str
2360 
2361             // We write the string from rightmost digit to leftmost digit.
2362             // The following is essentially a do-while loop that also handles the zero case.
2363             // prettier-ignore
2364             for { let temp := value } 1 {} {
2365                 str := sub(str, 1)
2366                 // Write the character to the pointer.
2367                 // The ASCII index of the '0' character is 48.
2368                 mstore8(str, add(48, mod(temp, 10)))
2369                 // Keep dividing `temp` until zero.
2370                 temp := div(temp, 10)
2371                 // prettier-ignore
2372                 if iszero(temp) { break }
2373             }
2374 
2375             let length := sub(end, str)
2376             // Move the pointer 32 bytes leftwards to make room for the length.
2377             str := sub(str, 0x20)
2378             // Store the length.
2379             mstore(str, length)
2380         }
2381     }
2382 }
2383 
2384 
2385 
2386 
2387 
2388 pragma solidity ^0.8.17;
2389 
2390 
2391 
2392 
2393 
2394 
2395 contract vikingsgame is ERC721A, DefaultOperatorFilterer, Ownable{
2396 
2397     using Strings for uint256;
2398 
2399     uint256 public constant MAX_SUPPLY = 10000;
2400     uint256 public publicPrice = 0.01 ether; 
2401     uint256 public WLPrice = 0.01 ether; 
2402     bool public _publicActive = true; 
2403     bool public _WLActive = false; 
2404     bytes32 public merkleRoot;
2405     uint256 public maxBalance = 10000; 
2406     uint256 public maxMint = 20;         
2407     bool public _revealed = true;    
2408     string public notRevealedUri;
2409     string baseURI;
2410     string public baseExtension = "";    
2411     mapping(address => bool) public _mintedAddress; 
2412     mapping(uint256 => string) private _tokenURIs;
2413 
2414     constructor(
2415         string memory initBaseURI, 
2416         string memory initNotRevealedUri
2417     ) ERC721A("The Vikings Game", "Vikings Game - Season One") {
2418         setBaseURI(initBaseURI);
2419         setNotRevealedURI(initNotRevealedUri);
2420     }
2421 
2422     function setRoot(bytes32 _root) public onlyOwner {
2423         merkleRoot = _root;
2424     }
2425 
2426     function mintWL(bytes32[] calldata proof, uint256 tokenQuantity) public payable {
2427         require(_WLActive, "whitelist sale need to be activated");
2428         require(tokenQuantity <= maxMint, "max mint amount per session exceeded");
2429         require(
2430             totalSupply() + tokenQuantity <= MAX_SUPPLY,
2431             "max NFT limit exceeded"
2432         );
2433         require(
2434             balanceOf(msg.sender)  + tokenQuantity <= maxBalance, 
2435             "max balance exceeded"
2436         );       
2437         require(WLPrice * tokenQuantity <= msg.value, "not enough ether");            
2438         require(!_mintedAddress[msg.sender], "already minted"); 
2439         require(
2440             MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), 
2441             "user is not whitelisted"
2442         );   
2443         _safeMint(msg.sender, tokenQuantity); 
2444         _mintedAddress[msg.sender] = true;
2445     }
2446 
2447     function mintViking(uint256 tokenQuantity) public payable {
2448         require(_publicActive, "public sale has not started yet");
2449         require(tokenQuantity <= maxMint, "max mint amount per session exceeded");
2450         require(
2451             totalSupply() + tokenQuantity <= MAX_SUPPLY,
2452             "max NFT limit exceeded"
2453         );        
2454         require(
2455             balanceOf(msg.sender)  + tokenQuantity <= maxBalance, 
2456             "max balance exceeded"
2457         );
2458         require(tokenQuantity * publicPrice <= msg.value, "not enough ether");
2459         _safeMint(msg.sender, tokenQuantity);
2460     }
2461 
2462     function mintOwner(uint256 tokenQuantity) public onlyOwner {
2463         _safeMint(msg.sender, tokenQuantity);
2464     }
2465 
2466     function tokenURI(uint256 tokenId)
2467         public
2468         view
2469         virtual
2470         override
2471         returns (string memory)
2472     {
2473         require(_exists(tokenId), "URI query failed");
2474         if (_revealed == false) {
2475             return notRevealedUri;
2476         }
2477         string memory _tokenURI = _tokenURIs[tokenId];
2478         string memory base = _baseURI();
2479         if (bytes(base).length == 0) {
2480             return _tokenURI;
2481         }
2482         if (bytes(_tokenURI).length > 0) {
2483             return string(abi.encodePacked(base, _tokenURI));
2484         }
2485         return
2486             string(abi.encodePacked(base, tokenId.toString(), baseExtension));
2487     }
2488 
2489     function publicSwitch() public onlyOwner {
2490         _publicActive = !_publicActive;
2491     }
2492 
2493     function whitelistSwitch() public onlyOwner {
2494         _WLActive = !_WLActive;
2495     }
2496 
2497     function revealSwitch() public onlyOwner {
2498         _revealed = !_revealed;
2499     }
2500 
2501     function _baseURI() internal view virtual override returns (string memory) {
2502         return baseURI;
2503     }
2504 
2505     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2506         baseURI = _newBaseURI;
2507     }
2508 
2509     function setPublicPrice(uint256 _publicPrice) public onlyOwner {
2510         publicPrice = _publicPrice;
2511     }
2512 
2513     function setWLPrice(uint256 _WLPrice) public onlyOwner {
2514         WLPrice = _WLPrice;
2515     }
2516 
2517     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2518         notRevealedUri = _notRevealedURI;
2519     }
2520 
2521     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
2522         baseExtension = _newBaseExtension;
2523     }
2524 
2525     function setMaxBalance(uint256 _maxBalance) public onlyOwner {
2526         maxBalance = _maxBalance;
2527     }
2528 
2529     function setMaxMint(uint256 _maxMint) public onlyOwner {
2530         maxMint = _maxMint;
2531     }
2532 
2533     function withdraw(address to) public onlyOwner {
2534         uint256 balance = address(this).balance;
2535         payable(to).transfer(balance);
2536     }
2537 
2538     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2539         super.setApprovalForAll(operator, approved);
2540     }
2541 
2542     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2543         super.approve(operator, tokenId);
2544     }
2545 
2546     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2547         super.transferFrom(from, to, tokenId);
2548     }
2549 
2550     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2551         super.safeTransferFrom(from, to, tokenId);
2552     }
2553 
2554     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2555         public payable
2556         override
2557         onlyAllowedOperator(from){
2558         super.safeTransferFrom(from, to, tokenId, data);
2559     }
2560 
2561 }