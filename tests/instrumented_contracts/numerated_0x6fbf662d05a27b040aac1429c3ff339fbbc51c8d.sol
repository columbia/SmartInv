1 //      _             _             ____  _     _           
2 //     / \__   ____ _| |_ __ _ _ __|  _ \(_) __| | ___ _ __ 
3 //    / _ \ \ / / _` | __/ _` | '__| |_) | |/ _` |/ _ \ '__|
4 //   / ___ \ V / (_| | || (_| | |  |  _ <| | (_| |  __/ |   
5 //  /_/   \_\_/ \__,_|\__\__,_|_|  |_| \_\_|\__,_|\___|_|     
6 // File: operator-filter-registry/src/lib/Constants.sol
7 
8 
9 pragma solidity ^0.8.17;
10 
11 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
12 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
13 
14 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
15 
16 
17 pragma solidity ^0.8.13;
18 
19 interface IOperatorFilterRegistry {
20     /**
21      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
22      *         true if supplied registrant address is not registered.
23      */
24     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
25 
26     /**
27      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
28      */
29     function register(address registrant) external;
30 
31     /**
32      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
33      */
34     function registerAndSubscribe(address registrant, address subscription) external;
35 
36     /**
37      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
38      *         address without subscribing.
39      */
40     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
41 
42     /**
43      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
44      *         Note that this does not remove any filtered addresses or codeHashes.
45      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
46      */
47     function unregister(address addr) external;
48 
49     /**
50      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
51      */
52     function updateOperator(address registrant, address operator, bool filtered) external;
53 
54     /**
55      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
56      */
57     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
58 
59     /**
60      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
61      */
62     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
63 
64     /**
65      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
66      */
67     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
68 
69     /**
70      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
71      *         subscription if present.
72      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
73      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
74      *         used.
75      */
76     function subscribe(address registrant, address registrantToSubscribe) external;
77 
78     /**
79      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
80      */
81     function unsubscribe(address registrant, bool copyExistingEntries) external;
82 
83     /**
84      * @notice Get the subscription address of a given registrant, if any.
85      */
86     function subscriptionOf(address addr) external returns (address registrant);
87 
88     /**
89      * @notice Get the set of addresses subscribed to a given registrant.
90      *         Note that order is not guaranteed as updates are made.
91      */
92     function subscribers(address registrant) external returns (address[] memory);
93 
94     /**
95      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
96      *         Note that order is not guaranteed as updates are made.
97      */
98     function subscriberAt(address registrant, uint256 index) external returns (address);
99 
100     /**
101      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
102      */
103     function copyEntriesOf(address registrant, address registrantToCopy) external;
104 
105     /**
106      * @notice Returns true if operator is filtered by a given address or its subscription.
107      */
108     function isOperatorFiltered(address registrant, address operator) external returns (bool);
109 
110     /**
111      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
112      */
113     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
114 
115     /**
116      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
117      */
118     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
119 
120     /**
121      * @notice Returns a list of filtered operators for a given address or its subscription.
122      */
123     function filteredOperators(address addr) external returns (address[] memory);
124 
125     /**
126      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
127      *         Note that order is not guaranteed as updates are made.
128      */
129     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
130 
131     /**
132      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
133      *         its subscription.
134      *         Note that order is not guaranteed as updates are made.
135      */
136     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
137 
138     /**
139      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
140      *         its subscription.
141      *         Note that order is not guaranteed as updates are made.
142      */
143     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
144 
145     /**
146      * @notice Returns true if an address has registered
147      */
148     function isRegistered(address addr) external returns (bool);
149 
150     /**
151      * @dev Convenience method to compute the code hash of an arbitrary contract
152      */
153     function codeHashOf(address addr) external returns (bytes32);
154 }
155 
156 // File: operator-filter-registry/src/OperatorFilterer.sol
157 
158 
159 pragma solidity ^0.8.13;
160 
161 
162 /**
163  * @title  OperatorFilterer
164  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
165  *         registrant's entries in the OperatorFilterRegistry.
166  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
167  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
168  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
169  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
170  *         administration methods on the contract itself to interact with the registry otherwise the subscription
171  *         will be locked to the options set during construction.
172  */
173 
174 abstract contract OperatorFilterer {
175     /// @dev Emitted when an operator is not allowed.
176     error OperatorNotAllowed(address operator);
177 
178     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
179         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
180 
181     /// @dev The constructor that is called when the contract is being deployed.
182     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
183         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
184         // will not revert, but the contract will need to be registered with the registry once it is deployed in
185         // order for the modifier to filter addresses.
186         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
187             if (subscribe) {
188                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
189             } else {
190                 if (subscriptionOrRegistrantToCopy != address(0)) {
191                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
192                 } else {
193                     OPERATOR_FILTER_REGISTRY.register(address(this));
194                 }
195             }
196         }
197     }
198 
199     /**
200      * @dev A helper function to check if an operator is allowed.
201      */
202     modifier onlyAllowedOperator(address from) virtual {
203         // Allow spending tokens from addresses with balance
204         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
205         // from an EOA.
206         if (from != msg.sender) {
207             _checkFilterOperator(msg.sender);
208         }
209         _;
210     }
211 
212     /**
213      * @dev A helper function to check if an operator approval is allowed.
214      */
215     modifier onlyAllowedOperatorApproval(address operator) virtual {
216         _checkFilterOperator(operator);
217         _;
218     }
219 
220     /**
221      * @dev A helper function to check if an operator is allowed.
222      */
223     function _checkFilterOperator(address operator) internal view virtual {
224         // Check registry code length to facilitate testing in environments without a deployed registry.
225         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
226             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
227             // may specify their own OperatorFilterRegistry implementations, which may behave differently
228             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
229                 revert OperatorNotAllowed(operator);
230             }
231         }
232     }
233 }
234 
235 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
236 
237 
238 pragma solidity ^0.8.13;
239 
240 
241 /**
242  * @title  DefaultOperatorFilterer
243  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
244  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
245  *         administration methods on the contract itself to interact with the registry otherwise the subscription
246  *         will be locked to the options set during construction.
247  */
248 
249 abstract contract DefaultOperatorFilterer is OperatorFilterer {
250     /// @dev The constructor that is called when the contract is being deployed.
251     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
252 }
253 
254 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
255 
256 
257 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @dev These functions deal with verification of Merkle Tree proofs.
263  *
264  * The tree and the proofs can be generated using our
265  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
266  * You will find a quickstart guide in the readme.
267  *
268  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
269  * hashing, or use a hash function other than keccak256 for hashing leaves.
270  * This is because the concatenation of a sorted pair of internal nodes in
271  * the merkle tree could be reinterpreted as a leaf value.
272  * OpenZeppelin's JavaScript library generates merkle trees that are safe
273  * against this attack out of the box.
274  */
275 library MerkleProof {
276     /**
277      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
278      * defined by `root`. For this, a `proof` must be provided, containing
279      * sibling hashes on the branch from the leaf to the root of the tree. Each
280      * pair of leaves and each pair of pre-images are assumed to be sorted.
281      */
282     function verify(
283         bytes32[] memory proof,
284         bytes32 root,
285         bytes32 leaf
286     ) internal pure returns (bool) {
287         return processProof(proof, leaf) == root;
288     }
289 
290     /**
291      * @dev Calldata version of {verify}
292      *
293      * _Available since v4.7._
294      */
295     function verifyCalldata(
296         bytes32[] calldata proof,
297         bytes32 root,
298         bytes32 leaf
299     ) internal pure returns (bool) {
300         return processProofCalldata(proof, leaf) == root;
301     }
302 
303     /**
304      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
305      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
306      * hash matches the root of the tree. When processing the proof, the pairs
307      * of leafs & pre-images are assumed to be sorted.
308      *
309      * _Available since v4.4._
310      */
311     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
312         bytes32 computedHash = leaf;
313         for (uint256 i = 0; i < proof.length; i++) {
314             computedHash = _hashPair(computedHash, proof[i]);
315         }
316         return computedHash;
317     }
318 
319     /**
320      * @dev Calldata version of {processProof}
321      *
322      * _Available since v4.7._
323      */
324     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
325         bytes32 computedHash = leaf;
326         for (uint256 i = 0; i < proof.length; i++) {
327             computedHash = _hashPair(computedHash, proof[i]);
328         }
329         return computedHash;
330     }
331 
332     /**
333      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
334      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
335      *
336      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
337      *
338      * _Available since v4.7._
339      */
340     function multiProofVerify(
341         bytes32[] memory proof,
342         bool[] memory proofFlags,
343         bytes32 root,
344         bytes32[] memory leaves
345     ) internal pure returns (bool) {
346         return processMultiProof(proof, proofFlags, leaves) == root;
347     }
348 
349     /**
350      * @dev Calldata version of {multiProofVerify}
351      *
352      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
353      *
354      * _Available since v4.7._
355      */
356     function multiProofVerifyCalldata(
357         bytes32[] calldata proof,
358         bool[] calldata proofFlags,
359         bytes32 root,
360         bytes32[] memory leaves
361     ) internal pure returns (bool) {
362         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
363     }
364 
365     /**
366      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
367      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
368      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
369      * respectively.
370      *
371      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
372      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
373      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
374      *
375      * _Available since v4.7._
376      */
377     function processMultiProof(
378         bytes32[] memory proof,
379         bool[] memory proofFlags,
380         bytes32[] memory leaves
381     ) internal pure returns (bytes32 merkleRoot) {
382         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
383         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
384         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
385         // the merkle tree.
386         uint256 leavesLen = leaves.length;
387         uint256 totalHashes = proofFlags.length;
388 
389         // Check proof validity.
390         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
391 
392         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
393         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
394         bytes32[] memory hashes = new bytes32[](totalHashes);
395         uint256 leafPos = 0;
396         uint256 hashPos = 0;
397         uint256 proofPos = 0;
398         // At each step, we compute the next hash using two values:
399         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
400         //   get the next hash.
401         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
402         //   `proof` array.
403         for (uint256 i = 0; i < totalHashes; i++) {
404             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
405             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
406             hashes[i] = _hashPair(a, b);
407         }
408 
409         if (totalHashes > 0) {
410             return hashes[totalHashes - 1];
411         } else if (leavesLen > 0) {
412             return leaves[0];
413         } else {
414             return proof[0];
415         }
416     }
417 
418     /**
419      * @dev Calldata version of {processMultiProof}.
420      *
421      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
422      *
423      * _Available since v4.7._
424      */
425     function processMultiProofCalldata(
426         bytes32[] calldata proof,
427         bool[] calldata proofFlags,
428         bytes32[] memory leaves
429     ) internal pure returns (bytes32 merkleRoot) {
430         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
431         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
432         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
433         // the merkle tree.
434         uint256 leavesLen = leaves.length;
435         uint256 totalHashes = proofFlags.length;
436 
437         // Check proof validity.
438         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
439 
440         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
441         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
442         bytes32[] memory hashes = new bytes32[](totalHashes);
443         uint256 leafPos = 0;
444         uint256 hashPos = 0;
445         uint256 proofPos = 0;
446         // At each step, we compute the next hash using two values:
447         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
448         //   get the next hash.
449         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
450         //   `proof` array.
451         for (uint256 i = 0; i < totalHashes; i++) {
452             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
453             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
454             hashes[i] = _hashPair(a, b);
455         }
456 
457         if (totalHashes > 0) {
458             return hashes[totalHashes - 1];
459         } else if (leavesLen > 0) {
460             return leaves[0];
461         } else {
462             return proof[0];
463         }
464     }
465 
466     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
467         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
468     }
469 
470     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
471         /// @solidity memory-safe-assembly
472         assembly {
473             mstore(0x00, a)
474             mstore(0x20, b)
475             value := keccak256(0x00, 0x40)
476         }
477     }
478 }
479 
480 // File: @openzeppelin/contracts/utils/math/Math.sol
481 
482 
483 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 /**
488  * @dev Standard math utilities missing in the Solidity language.
489  */
490 library Math {
491     enum Rounding {
492         Down, // Toward negative infinity
493         Up, // Toward infinity
494         Zero // Toward zero
495     }
496 
497     /**
498      * @dev Returns the largest of two numbers.
499      */
500     function max(uint256 a, uint256 b) internal pure returns (uint256) {
501         return a > b ? a : b;
502     }
503 
504     /**
505      * @dev Returns the smallest of two numbers.
506      */
507     function min(uint256 a, uint256 b) internal pure returns (uint256) {
508         return a < b ? a : b;
509     }
510 
511     /**
512      * @dev Returns the average of two numbers. The result is rounded towards
513      * zero.
514      */
515     function average(uint256 a, uint256 b) internal pure returns (uint256) {
516         // (a + b) / 2 can overflow.
517         return (a & b) + (a ^ b) / 2;
518     }
519 
520     /**
521      * @dev Returns the ceiling of the division of two numbers.
522      *
523      * This differs from standard division with `/` in that it rounds up instead
524      * of rounding down.
525      */
526     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
527         // (a + b - 1) / b can overflow on addition, so we distribute.
528         return a == 0 ? 0 : (a - 1) / b + 1;
529     }
530 
531     /**
532      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
533      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
534      * with further edits by Uniswap Labs also under MIT license.
535      */
536     function mulDiv(
537         uint256 x,
538         uint256 y,
539         uint256 denominator
540     ) internal pure returns (uint256 result) {
541         unchecked {
542             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
543             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
544             // variables such that product = prod1 * 2^256 + prod0.
545             uint256 prod0; // Least significant 256 bits of the product
546             uint256 prod1; // Most significant 256 bits of the product
547             assembly {
548                 let mm := mulmod(x, y, not(0))
549                 prod0 := mul(x, y)
550                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
551             }
552 
553             // Handle non-overflow cases, 256 by 256 division.
554             if (prod1 == 0) {
555                 return prod0 / denominator;
556             }
557 
558             // Make sure the result is less than 2^256. Also prevents denominator == 0.
559             require(denominator > prod1);
560 
561             ///////////////////////////////////////////////
562             // 512 by 256 division.
563             ///////////////////////////////////////////////
564 
565             // Make division exact by subtracting the remainder from [prod1 prod0].
566             uint256 remainder;
567             assembly {
568                 // Compute remainder using mulmod.
569                 remainder := mulmod(x, y, denominator)
570 
571                 // Subtract 256 bit number from 512 bit number.
572                 prod1 := sub(prod1, gt(remainder, prod0))
573                 prod0 := sub(prod0, remainder)
574             }
575 
576             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
577             // See https://cs.stackexchange.com/q/138556/92363.
578 
579             // Does not overflow because the denominator cannot be zero at this stage in the function.
580             uint256 twos = denominator & (~denominator + 1);
581             assembly {
582                 // Divide denominator by twos.
583                 denominator := div(denominator, twos)
584 
585                 // Divide [prod1 prod0] by twos.
586                 prod0 := div(prod0, twos)
587 
588                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
589                 twos := add(div(sub(0, twos), twos), 1)
590             }
591 
592             // Shift in bits from prod1 into prod0.
593             prod0 |= prod1 * twos;
594 
595             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
596             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
597             // four bits. That is, denominator * inv = 1 mod 2^4.
598             uint256 inverse = (3 * denominator) ^ 2;
599 
600             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
601             // in modular arithmetic, doubling the correct bits in each step.
602             inverse *= 2 - denominator * inverse; // inverse mod 2^8
603             inverse *= 2 - denominator * inverse; // inverse mod 2^16
604             inverse *= 2 - denominator * inverse; // inverse mod 2^32
605             inverse *= 2 - denominator * inverse; // inverse mod 2^64
606             inverse *= 2 - denominator * inverse; // inverse mod 2^128
607             inverse *= 2 - denominator * inverse; // inverse mod 2^256
608 
609             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
610             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
611             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
612             // is no longer required.
613             result = prod0 * inverse;
614             return result;
615         }
616     }
617 
618     /**
619      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
620      */
621     function mulDiv(
622         uint256 x,
623         uint256 y,
624         uint256 denominator,
625         Rounding rounding
626     ) internal pure returns (uint256) {
627         uint256 result = mulDiv(x, y, denominator);
628         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
629             result += 1;
630         }
631         return result;
632     }
633 
634     /**
635      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
636      *
637      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
638      */
639     function sqrt(uint256 a) internal pure returns (uint256) {
640         if (a == 0) {
641             return 0;
642         }
643 
644         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
645         //
646         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
647         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
648         //
649         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
650         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
651         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
652         //
653         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
654         uint256 result = 1 << (log2(a) >> 1);
655 
656         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
657         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
658         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
659         // into the expected uint128 result.
660         unchecked {
661             result = (result + a / result) >> 1;
662             result = (result + a / result) >> 1;
663             result = (result + a / result) >> 1;
664             result = (result + a / result) >> 1;
665             result = (result + a / result) >> 1;
666             result = (result + a / result) >> 1;
667             result = (result + a / result) >> 1;
668             return min(result, a / result);
669         }
670     }
671 
672     /**
673      * @notice Calculates sqrt(a), following the selected rounding direction.
674      */
675     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
676         unchecked {
677             uint256 result = sqrt(a);
678             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
679         }
680     }
681 
682     /**
683      * @dev Return the log in base 2, rounded down, of a positive value.
684      * Returns 0 if given 0.
685      */
686     function log2(uint256 value) internal pure returns (uint256) {
687         uint256 result = 0;
688         unchecked {
689             if (value >> 128 > 0) {
690                 value >>= 128;
691                 result += 128;
692             }
693             if (value >> 64 > 0) {
694                 value >>= 64;
695                 result += 64;
696             }
697             if (value >> 32 > 0) {
698                 value >>= 32;
699                 result += 32;
700             }
701             if (value >> 16 > 0) {
702                 value >>= 16;
703                 result += 16;
704             }
705             if (value >> 8 > 0) {
706                 value >>= 8;
707                 result += 8;
708             }
709             if (value >> 4 > 0) {
710                 value >>= 4;
711                 result += 4;
712             }
713             if (value >> 2 > 0) {
714                 value >>= 2;
715                 result += 2;
716             }
717             if (value >> 1 > 0) {
718                 result += 1;
719             }
720         }
721         return result;
722     }
723 
724     /**
725      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
726      * Returns 0 if given 0.
727      */
728     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
729         unchecked {
730             uint256 result = log2(value);
731             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
732         }
733     }
734 
735     /**
736      * @dev Return the log in base 10, rounded down, of a positive value.
737      * Returns 0 if given 0.
738      */
739     function log10(uint256 value) internal pure returns (uint256) {
740         uint256 result = 0;
741         unchecked {
742             if (value >= 10**64) {
743                 value /= 10**64;
744                 result += 64;
745             }
746             if (value >= 10**32) {
747                 value /= 10**32;
748                 result += 32;
749             }
750             if (value >= 10**16) {
751                 value /= 10**16;
752                 result += 16;
753             }
754             if (value >= 10**8) {
755                 value /= 10**8;
756                 result += 8;
757             }
758             if (value >= 10**4) {
759                 value /= 10**4;
760                 result += 4;
761             }
762             if (value >= 10**2) {
763                 value /= 10**2;
764                 result += 2;
765             }
766             if (value >= 10**1) {
767                 result += 1;
768             }
769         }
770         return result;
771     }
772 
773     /**
774      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
775      * Returns 0 if given 0.
776      */
777     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
778         unchecked {
779             uint256 result = log10(value);
780             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
781         }
782     }
783 
784     /**
785      * @dev Return the log in base 256, rounded down, of a positive value.
786      * Returns 0 if given 0.
787      *
788      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
789      */
790     function log256(uint256 value) internal pure returns (uint256) {
791         uint256 result = 0;
792         unchecked {
793             if (value >> 128 > 0) {
794                 value >>= 128;
795                 result += 16;
796             }
797             if (value >> 64 > 0) {
798                 value >>= 64;
799                 result += 8;
800             }
801             if (value >> 32 > 0) {
802                 value >>= 32;
803                 result += 4;
804             }
805             if (value >> 16 > 0) {
806                 value >>= 16;
807                 result += 2;
808             }
809             if (value >> 8 > 0) {
810                 result += 1;
811             }
812         }
813         return result;
814     }
815 
816     /**
817      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
818      * Returns 0 if given 0.
819      */
820     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
821         unchecked {
822             uint256 result = log256(value);
823             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
824         }
825     }
826 }
827 
828 // File: @openzeppelin/contracts/utils/Strings.sol
829 
830 
831 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
832 
833 pragma solidity ^0.8.0;
834 
835 
836 /**
837  * @dev String operations.
838  */
839 library Strings {
840     bytes16 private constant _SYMBOLS = "0123456789abcdef";
841     uint8 private constant _ADDRESS_LENGTH = 20;
842 
843     /**
844      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
845      */
846     function toString(uint256 value) internal pure returns (string memory) {
847         unchecked {
848             uint256 length = Math.log10(value) + 1;
849             string memory buffer = new string(length);
850             uint256 ptr;
851             /// @solidity memory-safe-assembly
852             assembly {
853                 ptr := add(buffer, add(32, length))
854             }
855             while (true) {
856                 ptr--;
857                 /// @solidity memory-safe-assembly
858                 assembly {
859                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
860                 }
861                 value /= 10;
862                 if (value == 0) break;
863             }
864             return buffer;
865         }
866     }
867 
868     /**
869      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
870      */
871     function toHexString(uint256 value) internal pure returns (string memory) {
872         unchecked {
873             return toHexString(value, Math.log256(value) + 1);
874         }
875     }
876 
877     /**
878      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
879      */
880     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
881         bytes memory buffer = new bytes(2 * length + 2);
882         buffer[0] = "0";
883         buffer[1] = "x";
884         for (uint256 i = 2 * length + 1; i > 1; --i) {
885             buffer[i] = _SYMBOLS[value & 0xf];
886             value >>= 4;
887         }
888         require(value == 0, "Strings: hex length insufficient");
889         return string(buffer);
890     }
891 
892     /**
893      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
894      */
895     function toHexString(address addr) internal pure returns (string memory) {
896         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
897     }
898 }
899 
900 // File: @openzeppelin/contracts/utils/Context.sol
901 
902 
903 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
904 
905 pragma solidity ^0.8.0;
906 
907 /**
908  * @dev Provides information about the current execution context, including the
909  * sender of the transaction and its data. While these are generally available
910  * via msg.sender and msg.data, they should not be accessed in such a direct
911  * manner, since when dealing with meta-transactions the account sending and
912  * paying for execution may not be the actual sender (as far as an application
913  * is concerned).
914  *
915  * This contract is only required for intermediate, library-like contracts.
916  */
917 abstract contract Context {
918     function _msgSender() internal view virtual returns (address) {
919         return msg.sender;
920     }
921 
922     function _msgData() internal view virtual returns (bytes calldata) {
923         return msg.data;
924     }
925 }
926 
927 // File: @openzeppelin/contracts/access/Ownable.sol
928 
929 
930 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
931 
932 pragma solidity ^0.8.0;
933 
934 
935 /**
936  * @dev Contract module which provides a basic access control mechanism, where
937  * there is an account (an owner) that can be granted exclusive access to
938  * specific functions.
939  *
940  * By default, the owner account will be the one that deploys the contract. This
941  * can later be changed with {transferOwnership}.
942  *
943  * This module is used through inheritance. It will make available the modifier
944  * `onlyOwner`, which can be applied to your functions to restrict their use to
945  * the owner.
946  */
947 abstract contract Ownable is Context {
948     address private _owner;
949 
950     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
951 
952     /**
953      * @dev Initializes the contract setting the deployer as the initial owner.
954      */
955     constructor() {
956         _transferOwnership(_msgSender());
957     }
958 
959     /**
960      * @dev Throws if called by any account other than the owner.
961      */
962     modifier onlyOwner() {
963         _checkOwner();
964         _;
965     }
966 
967     /**
968      * @dev Returns the address of the current owner.
969      */
970     function owner() public view virtual returns (address) {
971         return _owner;
972     }
973 
974     /**
975      * @dev Throws if the sender is not the owner.
976      */
977     function _checkOwner() internal view virtual {
978         require(owner() == _msgSender(), "Ownable: caller is not the owner");
979     }
980 
981     /**
982      * @dev Leaves the contract without owner. It will not be possible to call
983      * `onlyOwner` functions anymore. Can only be called by the current owner.
984      *
985      * NOTE: Renouncing ownership will leave the contract without an owner,
986      * thereby removing any functionality that is only available to the owner.
987      */
988     function renounceOwnership() public virtual onlyOwner {
989         _transferOwnership(address(0));
990     }
991 
992     /**
993      * @dev Transfers ownership of the contract to a new account (`newOwner`).
994      * Can only be called by the current owner.
995      */
996     function transferOwnership(address newOwner) public virtual onlyOwner {
997         require(newOwner != address(0), "Ownable: new owner is the zero address");
998         _transferOwnership(newOwner);
999     }
1000 
1001     /**
1002      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1003      * Internal function without access restriction.
1004      */
1005     function _transferOwnership(address newOwner) internal virtual {
1006         address oldOwner = _owner;
1007         _owner = newOwner;
1008         emit OwnershipTransferred(oldOwner, newOwner);
1009     }
1010 }
1011 
1012 // File: erc721a/contracts/IERC721A.sol
1013 
1014 
1015 // ERC721A Contracts v4.2.3
1016 // Creator: Chiru Labs
1017 
1018 pragma solidity ^0.8.4;
1019 
1020 /**
1021  * @dev Interface of ERC721A.
1022  */
1023 interface IERC721A {
1024     /**
1025      * The caller must own the token or be an approved operator.
1026      */
1027     error ApprovalCallerNotOwnerNorApproved();
1028 
1029     /**
1030      * The token does not exist.
1031      */
1032     error ApprovalQueryForNonexistentToken();
1033 
1034     /**
1035      * Cannot query the balance for the zero address.
1036      */
1037     error BalanceQueryForZeroAddress();
1038 
1039     /**
1040      * Cannot mint to the zero address.
1041      */
1042     error MintToZeroAddress();
1043 
1044     /**
1045      * The quantity of tokens minted must be more than zero.
1046      */
1047     error MintZeroQuantity();
1048 
1049     /**
1050      * The token does not exist.
1051      */
1052     error OwnerQueryForNonexistentToken();
1053 
1054     /**
1055      * The caller must own the token or be an approved operator.
1056      */
1057     error TransferCallerNotOwnerNorApproved();
1058 
1059     /**
1060      * The token must be owned by `from`.
1061      */
1062     error TransferFromIncorrectOwner();
1063 
1064     /**
1065      * Cannot safely transfer to a contract that does not implement the
1066      * ERC721Receiver interface.
1067      */
1068     error TransferToNonERC721ReceiverImplementer();
1069 
1070     /**
1071      * Cannot transfer to the zero address.
1072      */
1073     error TransferToZeroAddress();
1074 
1075     /**
1076      * The token does not exist.
1077      */
1078     error URIQueryForNonexistentToken();
1079 
1080     /**
1081      * The `quantity` minted with ERC2309 exceeds the safety limit.
1082      */
1083     error MintERC2309QuantityExceedsLimit();
1084 
1085     /**
1086      * The `extraData` cannot be set on an unintialized ownership slot.
1087      */
1088     error OwnershipNotInitializedForExtraData();
1089 
1090     // =============================================================
1091     //                            STRUCTS
1092     // =============================================================
1093 
1094     struct TokenOwnership {
1095         // The address of the owner.
1096         address addr;
1097         // Stores the start time of ownership with minimal overhead for tokenomics.
1098         uint64 startTimestamp;
1099         // Whether the token has been burned.
1100         bool burned;
1101         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1102         uint24 extraData;
1103     }
1104 
1105     // =============================================================
1106     //                         TOKEN COUNTERS
1107     // =============================================================
1108 
1109     /**
1110      * @dev Returns the total number of tokens in existence.
1111      * Burned tokens will reduce the count.
1112      * To get the total number of tokens minted, please see {_totalMinted}.
1113      */
1114     function totalSupply() external view returns (uint256);
1115 
1116     // =============================================================
1117     //                            IERC165
1118     // =============================================================
1119 
1120     /**
1121      * @dev Returns true if this contract implements the interface defined by
1122      * `interfaceId`. See the corresponding
1123      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1124      * to learn more about how these ids are created.
1125      *
1126      * This function call must use less than 30000 gas.
1127      */
1128     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1129 
1130     // =============================================================
1131     //                            IERC721
1132     // =============================================================
1133 
1134     /**
1135      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1136      */
1137     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1138 
1139     /**
1140      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1141      */
1142     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1143 
1144     /**
1145      * @dev Emitted when `owner` enables or disables
1146      * (`approved`) `operator` to manage all of its assets.
1147      */
1148     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1149 
1150     /**
1151      * @dev Returns the number of tokens in `owner`'s account.
1152      */
1153     function balanceOf(address owner) external view returns (uint256 balance);
1154 
1155     /**
1156      * @dev Returns the owner of the `tokenId` token.
1157      *
1158      * Requirements:
1159      *
1160      * - `tokenId` must exist.
1161      */
1162     function ownerOf(uint256 tokenId) external view returns (address owner);
1163 
1164     /**
1165      * @dev Safely transfers `tokenId` token from `from` to `to`,
1166      * checking first that contract recipients are aware of the ERC721 protocol
1167      * to prevent tokens from being forever locked.
1168      *
1169      * Requirements:
1170      *
1171      * - `from` cannot be the zero address.
1172      * - `to` cannot be the zero address.
1173      * - `tokenId` token must exist and be owned by `from`.
1174      * - If the caller is not `from`, it must be have been allowed to move
1175      * this token by either {approve} or {setApprovalForAll}.
1176      * - If `to` refers to a smart contract, it must implement
1177      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function safeTransferFrom(
1182         address from,
1183         address to,
1184         uint256 tokenId,
1185         bytes calldata data
1186     ) external payable;
1187 
1188     /**
1189      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1190      */
1191     function safeTransferFrom(
1192         address from,
1193         address to,
1194         uint256 tokenId
1195     ) external payable;
1196 
1197     /**
1198      * @dev Transfers `tokenId` from `from` to `to`.
1199      *
1200      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1201      * whenever possible.
1202      *
1203      * Requirements:
1204      *
1205      * - `from` cannot be the zero address.
1206      * - `to` cannot be the zero address.
1207      * - `tokenId` token must be owned by `from`.
1208      * - If the caller is not `from`, it must be approved to move this token
1209      * by either {approve} or {setApprovalForAll}.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function transferFrom(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) external payable;
1218 
1219     /**
1220      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1221      * The approval is cleared when the token is transferred.
1222      *
1223      * Only a single account can be approved at a time, so approving the
1224      * zero address clears previous approvals.
1225      *
1226      * Requirements:
1227      *
1228      * - The caller must own the token or be an approved operator.
1229      * - `tokenId` must exist.
1230      *
1231      * Emits an {Approval} event.
1232      */
1233     function approve(address to, uint256 tokenId) external payable;
1234 
1235     /**
1236      * @dev Approve or remove `operator` as an operator for the caller.
1237      * Operators can call {transferFrom} or {safeTransferFrom}
1238      * for any token owned by the caller.
1239      *
1240      * Requirements:
1241      *
1242      * - The `operator` cannot be the caller.
1243      *
1244      * Emits an {ApprovalForAll} event.
1245      */
1246     function setApprovalForAll(address operator, bool _approved) external;
1247 
1248     /**
1249      * @dev Returns the account approved for `tokenId` token.
1250      *
1251      * Requirements:
1252      *
1253      * - `tokenId` must exist.
1254      */
1255     function getApproved(uint256 tokenId) external view returns (address operator);
1256 
1257     /**
1258      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1259      *
1260      * See {setApprovalForAll}.
1261      */
1262     function isApprovedForAll(address owner, address operator) external view returns (bool);
1263 
1264     // =============================================================
1265     //                        IERC721Metadata
1266     // =============================================================
1267 
1268     /**
1269      * @dev Returns the token collection name.
1270      */
1271     function name() external view returns (string memory);
1272 
1273     /**
1274      * @dev Returns the token collection symbol.
1275      */
1276     function symbol() external view returns (string memory);
1277 
1278     /**
1279      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1280      */
1281     function tokenURI(uint256 tokenId) external view returns (string memory);
1282 
1283     // =============================================================
1284     //                           IERC2309
1285     // =============================================================
1286 
1287     /**
1288      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1289      * (inclusive) is transferred from `from` to `to`, as defined in the
1290      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1291      *
1292      * See {_mintERC2309} for more details.
1293      */
1294     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1295 }
1296 
1297 // File: erc721a/contracts/ERC721A.sol
1298 
1299 
1300 // ERC721A Contracts v4.2.3
1301 // Creator: Chiru Labs
1302 
1303 pragma solidity ^0.8.4;
1304 
1305 
1306 /**
1307  * @dev Interface of ERC721 token receiver.
1308  */
1309 interface ERC721A__IERC721Receiver {
1310     function onERC721Received(
1311         address operator,
1312         address from,
1313         uint256 tokenId,
1314         bytes calldata data
1315     ) external returns (bytes4);
1316 }
1317 
1318 /**
1319  * @title ERC721A
1320  *
1321  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1322  * Non-Fungible Token Standard, including the Metadata extension.
1323  * Optimized for lower gas during batch mints.
1324  *
1325  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1326  * starting from `_startTokenId()`.
1327  *
1328  * Assumptions:
1329  *
1330  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1331  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1332  */
1333 contract ERC721A is IERC721A {
1334     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1335     struct TokenApprovalRef {
1336         address value;
1337     }
1338 
1339     // =============================================================
1340     //                           CONSTANTS
1341     // =============================================================
1342 
1343     // Mask of an entry in packed address data.
1344     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1345 
1346     // The bit position of `numberMinted` in packed address data.
1347     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1348 
1349     // The bit position of `numberBurned` in packed address data.
1350     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1351 
1352     // The bit position of `aux` in packed address data.
1353     uint256 private constant _BITPOS_AUX = 192;
1354 
1355     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1356     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1357 
1358     // The bit position of `startTimestamp` in packed ownership.
1359     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1360 
1361     // The bit mask of the `burned` bit in packed ownership.
1362     uint256 private constant _BITMASK_BURNED = 1 << 224;
1363 
1364     // The bit position of the `nextInitialized` bit in packed ownership.
1365     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1366 
1367     // The bit mask of the `nextInitialized` bit in packed ownership.
1368     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1369 
1370     // The bit position of `extraData` in packed ownership.
1371     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1372 
1373     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1374     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1375 
1376     // The mask of the lower 160 bits for addresses.
1377     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1378 
1379     // The maximum `quantity` that can be minted with {_mintERC2309}.
1380     // This limit is to prevent overflows on the address data entries.
1381     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1382     // is required to cause an overflow, which is unrealistic.
1383     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1384 
1385     // The `Transfer` event signature is given by:
1386     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1387     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1388         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1389 
1390     // =============================================================
1391     //                            STORAGE
1392     // =============================================================
1393 
1394     // The next token ID to be minted.
1395     uint256 private _currentIndex;
1396 
1397     // The number of tokens burned.
1398     uint256 private _burnCounter;
1399 
1400     // Token name
1401     string private _name;
1402 
1403     // Token symbol
1404     string private _symbol;
1405 
1406     // Mapping from token ID to ownership details
1407     // An empty struct value does not necessarily mean the token is unowned.
1408     // See {_packedOwnershipOf} implementation for details.
1409     //
1410     // Bits Layout:
1411     // - [0..159]   `addr`
1412     // - [160..223] `startTimestamp`
1413     // - [224]      `burned`
1414     // - [225]      `nextInitialized`
1415     // - [232..255] `extraData`
1416     mapping(uint256 => uint256) private _packedOwnerships;
1417 
1418     // Mapping owner address to address data.
1419     //
1420     // Bits Layout:
1421     // - [0..63]    `balance`
1422     // - [64..127]  `numberMinted`
1423     // - [128..191] `numberBurned`
1424     // - [192..255] `aux`
1425     mapping(address => uint256) private _packedAddressData;
1426 
1427     // Mapping from token ID to approved address.
1428     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1429 
1430     // Mapping from owner to operator approvals
1431     mapping(address => mapping(address => bool)) private _operatorApprovals;
1432 
1433     // =============================================================
1434     //                          CONSTRUCTOR
1435     // =============================================================
1436 
1437     constructor(string memory name_, string memory symbol_) {
1438         _name = name_;
1439         _symbol = symbol_;
1440         _currentIndex = _startTokenId();
1441     }
1442 
1443     // =============================================================
1444     //                   TOKEN COUNTING OPERATIONS
1445     // =============================================================
1446 
1447     /**
1448      * @dev Returns the starting token ID.
1449      * To change the starting token ID, please override this function.
1450      */
1451     function _startTokenId() internal view virtual returns (uint256) {
1452         return 0;
1453     }
1454 
1455     /**
1456      * @dev Returns the next token ID to be minted.
1457      */
1458     function _nextTokenId() internal view virtual returns (uint256) {
1459         return _currentIndex;
1460     }
1461 
1462     /**
1463      * @dev Returns the total number of tokens in existence.
1464      * Burned tokens will reduce the count.
1465      * To get the total number of tokens minted, please see {_totalMinted}.
1466      */
1467     function totalSupply() public view virtual override returns (uint256) {
1468         // Counter underflow is impossible as _burnCounter cannot be incremented
1469         // more than `_currentIndex - _startTokenId()` times.
1470         unchecked {
1471             return _currentIndex - _burnCounter - _startTokenId();
1472         }
1473     }
1474 
1475     /**
1476      * @dev Returns the total amount of tokens minted in the contract.
1477      */
1478     function _totalMinted() internal view virtual returns (uint256) {
1479         // Counter underflow is impossible as `_currentIndex` does not decrement,
1480         // and it is initialized to `_startTokenId()`.
1481         unchecked {
1482             return _currentIndex - _startTokenId();
1483         }
1484     }
1485 
1486     /**
1487      * @dev Returns the total number of tokens burned.
1488      */
1489     function _totalBurned() internal view virtual returns (uint256) {
1490         return _burnCounter;
1491     }
1492 
1493     // =============================================================
1494     //                    ADDRESS DATA OPERATIONS
1495     // =============================================================
1496 
1497     /**
1498      * @dev Returns the number of tokens in `owner`'s account.
1499      */
1500     function balanceOf(address owner) public view virtual override returns (uint256) {
1501         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1502         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1503     }
1504 
1505     /**
1506      * Returns the number of tokens minted by `owner`.
1507      */
1508     function _numberMinted(address owner) internal view returns (uint256) {
1509         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1510     }
1511 
1512     /**
1513      * Returns the number of tokens burned by or on behalf of `owner`.
1514      */
1515     function _numberBurned(address owner) internal view returns (uint256) {
1516         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1517     }
1518 
1519     /**
1520      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1521      */
1522     function _getAux(address owner) internal view returns (uint64) {
1523         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1524     }
1525 
1526     /**
1527      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1528      * If there are multiple variables, please pack them into a uint64.
1529      */
1530     function _setAux(address owner, uint64 aux) internal virtual {
1531         uint256 packed = _packedAddressData[owner];
1532         uint256 auxCasted;
1533         // Cast `aux` with assembly to avoid redundant masking.
1534         assembly {
1535             auxCasted := aux
1536         }
1537         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1538         _packedAddressData[owner] = packed;
1539     }
1540 
1541     // =============================================================
1542     //                            IERC165
1543     // =============================================================
1544 
1545     /**
1546      * @dev Returns true if this contract implements the interface defined by
1547      * `interfaceId`. See the corresponding
1548      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1549      * to learn more about how these ids are created.
1550      *
1551      * This function call must use less than 30000 gas.
1552      */
1553     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1554         // The interface IDs are constants representing the first 4 bytes
1555         // of the XOR of all function selectors in the interface.
1556         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1557         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1558         return
1559             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1560             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1561             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1562     }
1563 
1564     // =============================================================
1565     //                        IERC721Metadata
1566     // =============================================================
1567 
1568     /**
1569      * @dev Returns the token collection name.
1570      */
1571     function name() public view virtual override returns (string memory) {
1572         return _name;
1573     }
1574 
1575     /**
1576      * @dev Returns the token collection symbol.
1577      */
1578     function symbol() public view virtual override returns (string memory) {
1579         return _symbol;
1580     }
1581 
1582     /**
1583      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1584      */
1585     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1586         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1587 
1588         string memory baseURI = _baseURI();
1589         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1590     }
1591 
1592     /**
1593      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1594      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1595      * by default, it can be overridden in child contracts.
1596      */
1597     function _baseURI() internal view virtual returns (string memory) {
1598         return '';
1599     }
1600 
1601     // =============================================================
1602     //                     OWNERSHIPS OPERATIONS
1603     // =============================================================
1604 
1605     /**
1606      * @dev Returns the owner of the `tokenId` token.
1607      *
1608      * Requirements:
1609      *
1610      * - `tokenId` must exist.
1611      */
1612     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1613         return address(uint160(_packedOwnershipOf(tokenId)));
1614     }
1615 
1616     /**
1617      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1618      * It gradually moves to O(1) as tokens get transferred around over time.
1619      */
1620     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1621         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1622     }
1623 
1624     /**
1625      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1626      */
1627     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1628         return _unpackedOwnership(_packedOwnerships[index]);
1629     }
1630 
1631     /**
1632      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1633      */
1634     function _initializeOwnershipAt(uint256 index) internal virtual {
1635         if (_packedOwnerships[index] == 0) {
1636             _packedOwnerships[index] = _packedOwnershipOf(index);
1637         }
1638     }
1639 
1640     /**
1641      * Returns the packed ownership data of `tokenId`.
1642      */
1643     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1644         uint256 curr = tokenId;
1645 
1646         unchecked {
1647             if (_startTokenId() <= curr)
1648                 if (curr < _currentIndex) {
1649                     uint256 packed = _packedOwnerships[curr];
1650                     // If not burned.
1651                     if (packed & _BITMASK_BURNED == 0) {
1652                         // Invariant:
1653                         // There will always be an initialized ownership slot
1654                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1655                         // before an unintialized ownership slot
1656                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1657                         // Hence, `curr` will not underflow.
1658                         //
1659                         // We can directly compare the packed value.
1660                         // If the address is zero, packed will be zero.
1661                         while (packed == 0) {
1662                             packed = _packedOwnerships[--curr];
1663                         }
1664                         return packed;
1665                     }
1666                 }
1667         }
1668         revert OwnerQueryForNonexistentToken();
1669     }
1670 
1671     /**
1672      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1673      */
1674     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1675         ownership.addr = address(uint160(packed));
1676         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1677         ownership.burned = packed & _BITMASK_BURNED != 0;
1678         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1679     }
1680 
1681     /**
1682      * @dev Packs ownership data into a single uint256.
1683      */
1684     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1685         assembly {
1686             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1687             owner := and(owner, _BITMASK_ADDRESS)
1688             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1689             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1690         }
1691     }
1692 
1693     /**
1694      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1695      */
1696     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1697         // For branchless setting of the `nextInitialized` flag.
1698         assembly {
1699             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1700             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1701         }
1702     }
1703 
1704     // =============================================================
1705     //                      APPROVAL OPERATIONS
1706     // =============================================================
1707 
1708     /**
1709      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1710      * The approval is cleared when the token is transferred.
1711      *
1712      * Only a single account can be approved at a time, so approving the
1713      * zero address clears previous approvals.
1714      *
1715      * Requirements:
1716      *
1717      * - The caller must own the token or be an approved operator.
1718      * - `tokenId` must exist.
1719      *
1720      * Emits an {Approval} event.
1721      */
1722     function approve(address to, uint256 tokenId) public payable virtual override {
1723         address owner = ownerOf(tokenId);
1724 
1725         if (_msgSenderERC721A() != owner)
1726             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1727                 revert ApprovalCallerNotOwnerNorApproved();
1728             }
1729 
1730         _tokenApprovals[tokenId].value = to;
1731         emit Approval(owner, to, tokenId);
1732     }
1733 
1734     /**
1735      * @dev Returns the account approved for `tokenId` token.
1736      *
1737      * Requirements:
1738      *
1739      * - `tokenId` must exist.
1740      */
1741     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1742         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1743 
1744         return _tokenApprovals[tokenId].value;
1745     }
1746 
1747     /**
1748      * @dev Approve or remove `operator` as an operator for the caller.
1749      * Operators can call {transferFrom} or {safeTransferFrom}
1750      * for any token owned by the caller.
1751      *
1752      * Requirements:
1753      *
1754      * - The `operator` cannot be the caller.
1755      *
1756      * Emits an {ApprovalForAll} event.
1757      */
1758     function setApprovalForAll(address operator, bool approved) public virtual override {
1759         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1760         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1761     }
1762 
1763     /**
1764      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1765      *
1766      * See {setApprovalForAll}.
1767      */
1768     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1769         return _operatorApprovals[owner][operator];
1770     }
1771 
1772     /**
1773      * @dev Returns whether `tokenId` exists.
1774      *
1775      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1776      *
1777      * Tokens start existing when they are minted. See {_mint}.
1778      */
1779     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1780         return
1781             _startTokenId() <= tokenId &&
1782             tokenId < _currentIndex && // If within bounds,
1783             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1784     }
1785 
1786     /**
1787      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1788      */
1789     function _isSenderApprovedOrOwner(
1790         address approvedAddress,
1791         address owner,
1792         address msgSender
1793     ) private pure returns (bool result) {
1794         assembly {
1795             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1796             owner := and(owner, _BITMASK_ADDRESS)
1797             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1798             msgSender := and(msgSender, _BITMASK_ADDRESS)
1799             // `msgSender == owner || msgSender == approvedAddress`.
1800             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1801         }
1802     }
1803 
1804     /**
1805      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1806      */
1807     function _getApprovedSlotAndAddress(uint256 tokenId)
1808         private
1809         view
1810         returns (uint256 approvedAddressSlot, address approvedAddress)
1811     {
1812         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1813         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1814         assembly {
1815             approvedAddressSlot := tokenApproval.slot
1816             approvedAddress := sload(approvedAddressSlot)
1817         }
1818     }
1819 
1820     // =============================================================
1821     //                      TRANSFER OPERATIONS
1822     // =============================================================
1823 
1824     /**
1825      * @dev Transfers `tokenId` from `from` to `to`.
1826      *
1827      * Requirements:
1828      *
1829      * - `from` cannot be the zero address.
1830      * - `to` cannot be the zero address.
1831      * - `tokenId` token must be owned by `from`.
1832      * - If the caller is not `from`, it must be approved to move this token
1833      * by either {approve} or {setApprovalForAll}.
1834      *
1835      * Emits a {Transfer} event.
1836      */
1837     function transferFrom(
1838         address from,
1839         address to,
1840         uint256 tokenId
1841     ) public payable virtual override {
1842         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1843 
1844         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1845 
1846         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1847 
1848         // The nested ifs save around 20+ gas over a compound boolean condition.
1849         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1850             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1851 
1852         if (to == address(0)) revert TransferToZeroAddress();
1853 
1854         _beforeTokenTransfers(from, to, tokenId, 1);
1855 
1856         // Clear approvals from the previous owner.
1857         assembly {
1858             if approvedAddress {
1859                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1860                 sstore(approvedAddressSlot, 0)
1861             }
1862         }
1863 
1864         // Underflow of the sender's balance is impossible because we check for
1865         // ownership above and the recipient's balance can't realistically overflow.
1866         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1867         unchecked {
1868             // We can directly increment and decrement the balances.
1869             --_packedAddressData[from]; // Updates: `balance -= 1`.
1870             ++_packedAddressData[to]; // Updates: `balance += 1`.
1871 
1872             // Updates:
1873             // - `address` to the next owner.
1874             // - `startTimestamp` to the timestamp of transfering.
1875             // - `burned` to `false`.
1876             // - `nextInitialized` to `true`.
1877             _packedOwnerships[tokenId] = _packOwnershipData(
1878                 to,
1879                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1880             );
1881 
1882             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1883             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1884                 uint256 nextTokenId = tokenId + 1;
1885                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1886                 if (_packedOwnerships[nextTokenId] == 0) {
1887                     // If the next slot is within bounds.
1888                     if (nextTokenId != _currentIndex) {
1889                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1890                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1891                     }
1892                 }
1893             }
1894         }
1895 
1896         emit Transfer(from, to, tokenId);
1897         _afterTokenTransfers(from, to, tokenId, 1);
1898     }
1899 
1900     /**
1901      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1902      */
1903     function safeTransferFrom(
1904         address from,
1905         address to,
1906         uint256 tokenId
1907     ) public payable virtual override {
1908         safeTransferFrom(from, to, tokenId, '');
1909     }
1910 
1911     /**
1912      * @dev Safely transfers `tokenId` token from `from` to `to`.
1913      *
1914      * Requirements:
1915      *
1916      * - `from` cannot be the zero address.
1917      * - `to` cannot be the zero address.
1918      * - `tokenId` token must exist and be owned by `from`.
1919      * - If the caller is not `from`, it must be approved to move this token
1920      * by either {approve} or {setApprovalForAll}.
1921      * - If `to` refers to a smart contract, it must implement
1922      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1923      *
1924      * Emits a {Transfer} event.
1925      */
1926     function safeTransferFrom(
1927         address from,
1928         address to,
1929         uint256 tokenId,
1930         bytes memory _data
1931     ) public payable virtual override {
1932         transferFrom(from, to, tokenId);
1933         if (to.code.length != 0)
1934             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1935                 revert TransferToNonERC721ReceiverImplementer();
1936             }
1937     }
1938 
1939     /**
1940      * @dev Hook that is called before a set of serially-ordered token IDs
1941      * are about to be transferred. This includes minting.
1942      * And also called before burning one token.
1943      *
1944      * `startTokenId` - the first token ID to be transferred.
1945      * `quantity` - the amount to be transferred.
1946      *
1947      * Calling conditions:
1948      *
1949      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1950      * transferred to `to`.
1951      * - When `from` is zero, `tokenId` will be minted for `to`.
1952      * - When `to` is zero, `tokenId` will be burned by `from`.
1953      * - `from` and `to` are never both zero.
1954      */
1955     function _beforeTokenTransfers(
1956         address from,
1957         address to,
1958         uint256 startTokenId,
1959         uint256 quantity
1960     ) internal virtual {}
1961 
1962     /**
1963      * @dev Hook that is called after a set of serially-ordered token IDs
1964      * have been transferred. This includes minting.
1965      * And also called after one token has been burned.
1966      *
1967      * `startTokenId` - the first token ID to be transferred.
1968      * `quantity` - the amount to be transferred.
1969      *
1970      * Calling conditions:
1971      *
1972      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1973      * transferred to `to`.
1974      * - When `from` is zero, `tokenId` has been minted for `to`.
1975      * - When `to` is zero, `tokenId` has been burned by `from`.
1976      * - `from` and `to` are never both zero.
1977      */
1978     function _afterTokenTransfers(
1979         address from,
1980         address to,
1981         uint256 startTokenId,
1982         uint256 quantity
1983     ) internal virtual {}
1984 
1985     /**
1986      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1987      *
1988      * `from` - Previous owner of the given token ID.
1989      * `to` - Target address that will receive the token.
1990      * `tokenId` - Token ID to be transferred.
1991      * `_data` - Optional data to send along with the call.
1992      *
1993      * Returns whether the call correctly returned the expected magic value.
1994      */
1995     function _checkContractOnERC721Received(
1996         address from,
1997         address to,
1998         uint256 tokenId,
1999         bytes memory _data
2000     ) private returns (bool) {
2001         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2002             bytes4 retval
2003         ) {
2004             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2005         } catch (bytes memory reason) {
2006             if (reason.length == 0) {
2007                 revert TransferToNonERC721ReceiverImplementer();
2008             } else {
2009                 assembly {
2010                     revert(add(32, reason), mload(reason))
2011                 }
2012             }
2013         }
2014     }
2015 
2016     // =============================================================
2017     //                        MINT OPERATIONS
2018     // =============================================================
2019 
2020     /**
2021      * @dev Mints `quantity` tokens and transfers them to `to`.
2022      *
2023      * Requirements:
2024      *
2025      * - `to` cannot be the zero address.
2026      * - `quantity` must be greater than 0.
2027      *
2028      * Emits a {Transfer} event for each mint.
2029      */
2030     function _mint(address to, uint256 quantity) internal virtual {
2031         uint256 startTokenId = _currentIndex;
2032         if (quantity == 0) revert MintZeroQuantity();
2033 
2034         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2035 
2036         // Overflows are incredibly unrealistic.
2037         // `balance` and `numberMinted` have a maximum limit of 2**64.
2038         // `tokenId` has a maximum limit of 2**256.
2039         unchecked {
2040             // Updates:
2041             // - `balance += quantity`.
2042             // - `numberMinted += quantity`.
2043             //
2044             // We can directly add to the `balance` and `numberMinted`.
2045             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2046 
2047             // Updates:
2048             // - `address` to the owner.
2049             // - `startTimestamp` to the timestamp of minting.
2050             // - `burned` to `false`.
2051             // - `nextInitialized` to `quantity == 1`.
2052             _packedOwnerships[startTokenId] = _packOwnershipData(
2053                 to,
2054                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2055             );
2056 
2057             uint256 toMasked;
2058             uint256 end = startTokenId + quantity;
2059 
2060             // Use assembly to loop and emit the `Transfer` event for gas savings.
2061             // The duplicated `log4` removes an extra check and reduces stack juggling.
2062             // The assembly, together with the surrounding Solidity code, have been
2063             // delicately arranged to nudge the compiler into producing optimized opcodes.
2064             assembly {
2065                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2066                 toMasked := and(to, _BITMASK_ADDRESS)
2067                 // Emit the `Transfer` event.
2068                 log4(
2069                     0, // Start of data (0, since no data).
2070                     0, // End of data (0, since no data).
2071                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2072                     0, // `address(0)`.
2073                     toMasked, // `to`.
2074                     startTokenId // `tokenId`.
2075                 )
2076 
2077                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2078                 // that overflows uint256 will make the loop run out of gas.
2079                 // The compiler will optimize the `iszero` away for performance.
2080                 for {
2081                     let tokenId := add(startTokenId, 1)
2082                 } iszero(eq(tokenId, end)) {
2083                     tokenId := add(tokenId, 1)
2084                 } {
2085                     // Emit the `Transfer` event. Similar to above.
2086                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2087                 }
2088             }
2089             if (toMasked == 0) revert MintToZeroAddress();
2090 
2091             _currentIndex = end;
2092         }
2093         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2094     }
2095 
2096     /**
2097      * @dev Mints `quantity` tokens and transfers them to `to`.
2098      *
2099      * This function is intended for efficient minting only during contract creation.
2100      *
2101      * It emits only one {ConsecutiveTransfer} as defined in
2102      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2103      * instead of a sequence of {Transfer} event(s).
2104      *
2105      * Calling this function outside of contract creation WILL make your contract
2106      * non-compliant with the ERC721 standard.
2107      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2108      * {ConsecutiveTransfer} event is only permissible during contract creation.
2109      *
2110      * Requirements:
2111      *
2112      * - `to` cannot be the zero address.
2113      * - `quantity` must be greater than 0.
2114      *
2115      * Emits a {ConsecutiveTransfer} event.
2116      */
2117     function _mintERC2309(address to, uint256 quantity) internal virtual {
2118         uint256 startTokenId = _currentIndex;
2119         if (to == address(0)) revert MintToZeroAddress();
2120         if (quantity == 0) revert MintZeroQuantity();
2121         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2122 
2123         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2124 
2125         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2126         unchecked {
2127             // Updates:
2128             // - `balance += quantity`.
2129             // - `numberMinted += quantity`.
2130             //
2131             // We can directly add to the `balance` and `numberMinted`.
2132             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2133 
2134             // Updates:
2135             // - `address` to the owner.
2136             // - `startTimestamp` to the timestamp of minting.
2137             // - `burned` to `false`.
2138             // - `nextInitialized` to `quantity == 1`.
2139             _packedOwnerships[startTokenId] = _packOwnershipData(
2140                 to,
2141                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2142             );
2143 
2144             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2145 
2146             _currentIndex = startTokenId + quantity;
2147         }
2148         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2149     }
2150 
2151     /**
2152      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2153      *
2154      * Requirements:
2155      *
2156      * - If `to` refers to a smart contract, it must implement
2157      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2158      * - `quantity` must be greater than 0.
2159      *
2160      * See {_mint}.
2161      *
2162      * Emits a {Transfer} event for each mint.
2163      */
2164     function _safeMint(
2165         address to,
2166         uint256 quantity,
2167         bytes memory _data
2168     ) internal virtual {
2169         _mint(to, quantity);
2170 
2171         unchecked {
2172             if (to.code.length != 0) {
2173                 uint256 end = _currentIndex;
2174                 uint256 index = end - quantity;
2175                 do {
2176                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2177                         revert TransferToNonERC721ReceiverImplementer();
2178                     }
2179                 } while (index < end);
2180                 // Reentrancy protection.
2181                 if (_currentIndex != end) revert();
2182             }
2183         }
2184     }
2185 
2186     /**
2187      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2188      */
2189     function _safeMint(address to, uint256 quantity) internal virtual {
2190         _safeMint(to, quantity, '');
2191     }
2192 
2193     // =============================================================
2194     //                        BURN OPERATIONS
2195     // =============================================================
2196 
2197     /**
2198      * @dev Equivalent to `_burn(tokenId, false)`.
2199      */
2200     function _burn(uint256 tokenId) internal virtual {
2201         _burn(tokenId, false);
2202     }
2203 
2204     /**
2205      * @dev Destroys `tokenId`.
2206      * The approval is cleared when the token is burned.
2207      *
2208      * Requirements:
2209      *
2210      * - `tokenId` must exist.
2211      *
2212      * Emits a {Transfer} event.
2213      */
2214     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2215         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2216 
2217         address from = address(uint160(prevOwnershipPacked));
2218 
2219         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2220 
2221         if (approvalCheck) {
2222             // The nested ifs save around 20+ gas over a compound boolean condition.
2223             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2224                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2225         }
2226 
2227         _beforeTokenTransfers(from, address(0), tokenId, 1);
2228 
2229         // Clear approvals from the previous owner.
2230         assembly {
2231             if approvedAddress {
2232                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2233                 sstore(approvedAddressSlot, 0)
2234             }
2235         }
2236 
2237         // Underflow of the sender's balance is impossible because we check for
2238         // ownership above and the recipient's balance can't realistically overflow.
2239         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2240         unchecked {
2241             // Updates:
2242             // - `balance -= 1`.
2243             // - `numberBurned += 1`.
2244             //
2245             // We can directly decrement the balance, and increment the number burned.
2246             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2247             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2248 
2249             // Updates:
2250             // - `address` to the last owner.
2251             // - `startTimestamp` to the timestamp of burning.
2252             // - `burned` to `true`.
2253             // - `nextInitialized` to `true`.
2254             _packedOwnerships[tokenId] = _packOwnershipData(
2255                 from,
2256                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2257             );
2258 
2259             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2260             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2261                 uint256 nextTokenId = tokenId + 1;
2262                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2263                 if (_packedOwnerships[nextTokenId] == 0) {
2264                     // If the next slot is within bounds.
2265                     if (nextTokenId != _currentIndex) {
2266                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2267                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2268                     }
2269                 }
2270             }
2271         }
2272 
2273         emit Transfer(from, address(0), tokenId);
2274         _afterTokenTransfers(from, address(0), tokenId, 1);
2275 
2276         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2277         unchecked {
2278             _burnCounter++;
2279         }
2280     }
2281 
2282     // =============================================================
2283     //                     EXTRA DATA OPERATIONS
2284     // =============================================================
2285 
2286     /**
2287      * @dev Directly sets the extra data for the ownership data `index`.
2288      */
2289     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2290         uint256 packed = _packedOwnerships[index];
2291         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2292         uint256 extraDataCasted;
2293         // Cast `extraData` with assembly to avoid redundant masking.
2294         assembly {
2295             extraDataCasted := extraData
2296         }
2297         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2298         _packedOwnerships[index] = packed;
2299     }
2300 
2301     /**
2302      * @dev Called during each token transfer to set the 24bit `extraData` field.
2303      * Intended to be overridden by the cosumer contract.
2304      *
2305      * `previousExtraData` - the value of `extraData` before transfer.
2306      *
2307      * Calling conditions:
2308      *
2309      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2310      * transferred to `to`.
2311      * - When `from` is zero, `tokenId` will be minted for `to`.
2312      * - When `to` is zero, `tokenId` will be burned by `from`.
2313      * - `from` and `to` are never both zero.
2314      */
2315     function _extraData(
2316         address from,
2317         address to,
2318         uint24 previousExtraData
2319     ) internal view virtual returns (uint24) {}
2320 
2321     /**
2322      * @dev Returns the next extra data for the packed ownership data.
2323      * The returned result is shifted into position.
2324      */
2325     function _nextExtraData(
2326         address from,
2327         address to,
2328         uint256 prevOwnershipPacked
2329     ) private view returns (uint256) {
2330         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2331         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2332     }
2333 
2334     // =============================================================
2335     //                       OTHER OPERATIONS
2336     // =============================================================
2337 
2338     /**
2339      * @dev Returns the message sender (defaults to `msg.sender`).
2340      *
2341      * If you are writing GSN compatible contracts, you need to override this function.
2342      */
2343     function _msgSenderERC721A() internal view virtual returns (address) {
2344         return msg.sender;
2345     }
2346 
2347     /**
2348      * @dev Converts a uint256 to its ASCII string decimal representation.
2349      */
2350     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2351         assembly {
2352             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2353             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2354             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2355             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2356             let m := add(mload(0x40), 0xa0)
2357             // Update the free memory pointer to allocate.
2358             mstore(0x40, m)
2359             // Assign the `str` to the end.
2360             str := sub(m, 0x20)
2361             // Zeroize the slot after the string.
2362             mstore(str, 0)
2363 
2364             // Cache the end of the memory to calculate the length later.
2365             let end := str
2366 
2367             // We write the string from rightmost digit to leftmost digit.
2368             // The following is essentially a do-while loop that also handles the zero case.
2369             // prettier-ignore
2370             for { let temp := value } 1 {} {
2371                 str := sub(str, 1)
2372                 // Write the character to the pointer.
2373                 // The ASCII index of the '0' character is 48.
2374                 mstore8(str, add(48, mod(temp, 10)))
2375                 // Keep dividing `temp` until zero.
2376                 temp := div(temp, 10)
2377                 // prettier-ignore
2378                 if iszero(temp) { break }
2379             }
2380 
2381             let length := sub(end, str)
2382             // Move the pointer 32 bytes leftwards to make room for the length.
2383             str := sub(str, 0x20)
2384             // Store the length.
2385             mstore(str, length)
2386         }
2387     }
2388 }
2389 
2390 // File: contracts/avatar.sol
2391 
2392 //      _             _             ____  _     _           
2393 //     / \__   ____ _| |_ __ _ _ __|  _ \(_) __| | ___ _ __ 
2394 //    / _ \ \ / / _` | __/ _` | '__| |_) | |/ _` |/ _ \ '__|
2395 //   / ___ \ V / (_| | || (_| | |  |  _ <| | (_| |  __/ |   
2396 //  /_/   \_\_/ \__,_|\__\__,_|_|  |_| \_\_|\__,_|\___|_|                                                           
2397 
2398 
2399 pragma solidity ^0.8.17;
2400 
2401 
2402 
2403 
2404 
2405 
2406 contract AvatarRiders is ERC721A, DefaultOperatorFilterer, Ownable{
2407 
2408     using Strings for uint256;
2409 
2410     uint256 public constant MAX_SUPPLY = 5555;
2411     bool public _isSaleActive = false; 
2412     bool public _WLActive = false; 
2413     bool public _revealed = false;     
2414     bool public _stopMint = false;   
2415     uint256 public WLPrice = 0.0029 ether; 
2416     uint256 public mintPrice = 0.0049 ether; 
2417     uint256 public maxBalance = 3; 
2418     uint256 public maxMint = 3; 
2419     uint256 public stopNum = 0; 
2420     string baseURI;
2421     string public notRevealedUri;
2422     string public baseExtension = ".json";
2423     bytes32 public merkleRoot;
2424     mapping(address => bool) public _mintedAddress; 
2425     mapping(uint256 => string) private _tokenURIs;
2426 
2427     constructor(string memory initBaseURI, string memory initNotRevealedUri) 
2428         ERC721A("AvatarRiders", "AR") 
2429     {
2430         setBaseURI(initBaseURI);
2431         setNotRevealedURI(initNotRevealedUri);
2432     }
2433 
2434     function mintWL(bytes32[] calldata proof) public payable {
2435         require(_WLActive, "Whitelist must be active to mint NFT");
2436         require(WLPrice <= msg.value, "Not enough ether");
2437         require(!_mintedAddress[msg.sender], "Already minted!"); 
2438         require(checkWL(proof), "Invalid merkle proof");         
2439         _safeMint(msg.sender, 1); 
2440         _mintedAddress[msg.sender] = true;
2441     }
2442 
2443     function checkWL(bytes32[] calldata proof) view public returns (bool) {
2444         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2445         bool verified = MerkleProof.verify(proof, merkleRoot, leaf);
2446         return verified;
2447     }
2448 
2449     function getNum() public view returns (uint) {
2450        return totalSupply();
2451     }
2452 
2453     function mintPublic(uint256 tokenQuantity) public payable {
2454         require(
2455             totalSupply() + tokenQuantity <= MAX_SUPPLY,
2456             "Sale would exceed max supply"
2457         );
2458         require(_isSaleActive, "Sale must be active to mint NFT");
2459 
2460         require(tokenQuantity <= maxMint, "Mint too many tokens at a time");
2461 
2462         require(
2463             balanceOf(msg.sender)  + tokenQuantity <= maxBalance, 
2464             "Sale would exceed max balance"
2465         );
2466 
2467         require(tokenQuantity * mintPrice <= msg.value, "Not enough ether");
2468 
2469         if (_stopMint) {
2470             require(totalSupply() + tokenQuantity <= stopNum, "Sale would exceed max supply");
2471         }
2472 
2473         _safeMint(msg.sender, tokenQuantity);
2474     }
2475 
2476     function tokenURI(uint256 tokenId)
2477         public
2478         view
2479         virtual
2480         override
2481         returns (string memory)
2482     {
2483         require(
2484             _exists(tokenId),
2485             "URI query for nonexistent token"
2486         );
2487 
2488         if (_revealed == false) {
2489             return notRevealedUri;
2490         }
2491 
2492         string memory _tokenURI = _tokenURIs[tokenId];
2493         string memory base = _baseURI();
2494 
2495         if (bytes(base).length == 0) {
2496             return _tokenURI;
2497         }
2498 
2499         if (bytes(_tokenURI).length > 0) {
2500             return string(abi.encodePacked(base, _tokenURI));
2501         }
2502 
2503         return
2504             string(abi.encodePacked(base, tokenId.toString(), baseExtension));
2505     }
2506 
2507     function setRoot(bytes32 _root) public onlyOwner {
2508         merkleRoot = _root;
2509     }
2510 
2511     function _baseURI() internal view virtual override returns (string memory) {
2512         return baseURI;
2513     }
2514 
2515     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2516         baseURI = _newBaseURI;
2517     }
2518 
2519     function flipSaleActive() public onlyOwner {
2520         _isSaleActive = !_isSaleActive;
2521     }
2522 
2523     function flipWLActive() public onlyOwner {
2524         _WLActive = !_WLActive;
2525     }
2526 
2527     function flipReveal() public onlyOwner {
2528         _revealed = !_revealed;
2529     }
2530 
2531     function flipStopMint() public onlyOwner {
2532         _stopMint = !_stopMint;
2533     }
2534 
2535     function setStopNum(uint256 _stopNum) public onlyOwner {
2536         stopNum = _stopNum;
2537     }
2538 
2539     function mintOwner() public onlyOwner {
2540         _safeMint(msg.sender, 1);
2541     }
2542 
2543     function setMintPrice(uint256 _mintPrice) public onlyOwner {
2544         mintPrice = _mintPrice;
2545     }
2546 
2547     function setWLPrice(uint256 _WLPrice) public onlyOwner {
2548         WLPrice = _WLPrice;
2549     }
2550 
2551     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2552         notRevealedUri = _notRevealedURI;
2553     }
2554 
2555     function setBaseExtension(string memory _newBaseExtension)
2556         public
2557         onlyOwner
2558     {
2559         baseExtension = _newBaseExtension;
2560     }
2561 
2562     function setMaxBalance(uint256 _maxBalance) public onlyOwner {
2563         maxBalance = _maxBalance;
2564     }
2565 
2566     function setMaxMint(uint256 _maxMint) public onlyOwner {
2567         maxMint = _maxMint;
2568     }
2569 
2570     function withdraw(address to) public onlyOwner {
2571         uint256 balance = address(this).balance;
2572         payable(to).transfer(balance);
2573     }
2574 
2575   //----------------------Override some methods based on opensea new policy---------------------
2576   //---------------- https://github.com/ProjectOpenSea/operator-filter-registry ----------------
2577 
2578   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2579     super.setApprovalForAll(operator, approved);
2580   }
2581 
2582   function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2583     super.approve(operator, tokenId);
2584   }
2585 
2586   function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2587     super.transferFrom(from, to, tokenId);
2588   }
2589 
2590   function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2591     super.safeTransferFrom(from, to, tokenId);
2592   }
2593 
2594   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2595   public payable
2596   override
2597   onlyAllowedOperator(from)
2598   {
2599     super.safeTransferFrom(from, to, tokenId, data);
2600   }
2601 
2602 }