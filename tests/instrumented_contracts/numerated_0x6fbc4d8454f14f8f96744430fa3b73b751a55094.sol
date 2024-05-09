1 // File: operator-filter-registry/src/lib/Constants.sol
2 
3 
4 pragma solidity ^0.8.17;
5 
6 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
7 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
8 
9 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
10 
11 
12 pragma solidity ^0.8.13;
13 
14 interface IOperatorFilterRegistry {
15     /**
16      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
17      *         true if supplied registrant address is not registered.
18      */
19     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
20 
21     /**
22      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
23      */
24     function register(address registrant) external;
25 
26     /**
27      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
28      */
29     function registerAndSubscribe(address registrant, address subscription) external;
30 
31     /**
32      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
33      *         address without subscribing.
34      */
35     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
36 
37     /**
38      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
39      *         Note that this does not remove any filtered addresses or codeHashes.
40      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
41      */
42     function unregister(address addr) external;
43 
44     /**
45      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
46      */
47     function updateOperator(address registrant, address operator, bool filtered) external;
48 
49     /**
50      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
51      */
52     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
53 
54     /**
55      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
56      */
57     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
58 
59     /**
60      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
61      */
62     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
63 
64     /**
65      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
66      *         subscription if present.
67      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
68      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
69      *         used.
70      */
71     function subscribe(address registrant, address registrantToSubscribe) external;
72 
73     /**
74      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
75      */
76     function unsubscribe(address registrant, bool copyExistingEntries) external;
77 
78     /**
79      * @notice Get the subscription address of a given registrant, if any.
80      */
81     function subscriptionOf(address addr) external returns (address registrant);
82 
83     /**
84      * @notice Get the set of addresses subscribed to a given registrant.
85      *         Note that order is not guaranteed as updates are made.
86      */
87     function subscribers(address registrant) external returns (address[] memory);
88 
89     /**
90      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
91      *         Note that order is not guaranteed as updates are made.
92      */
93     function subscriberAt(address registrant, uint256 index) external returns (address);
94 
95     /**
96      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
97      */
98     function copyEntriesOf(address registrant, address registrantToCopy) external;
99 
100     /**
101      * @notice Returns true if operator is filtered by a given address or its subscription.
102      */
103     function isOperatorFiltered(address registrant, address operator) external returns (bool);
104 
105     /**
106      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
107      */
108     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
109 
110     /**
111      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
112      */
113     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
114 
115     /**
116      * @notice Returns a list of filtered operators for a given address or its subscription.
117      */
118     function filteredOperators(address addr) external returns (address[] memory);
119 
120     /**
121      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
122      *         Note that order is not guaranteed as updates are made.
123      */
124     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
125 
126     /**
127      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
128      *         its subscription.
129      *         Note that order is not guaranteed as updates are made.
130      */
131     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
132 
133     /**
134      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
135      *         its subscription.
136      *         Note that order is not guaranteed as updates are made.
137      */
138     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
139 
140     /**
141      * @notice Returns true if an address has registered
142      */
143     function isRegistered(address addr) external returns (bool);
144 
145     /**
146      * @dev Convenience method to compute the code hash of an arbitrary contract
147      */
148     function codeHashOf(address addr) external returns (bytes32);
149 }
150 
151 // File: operator-filter-registry/src/OperatorFilterer.sol
152 
153 
154 pragma solidity ^0.8.13;
155 
156 
157 /**
158  * @title  OperatorFilterer
159  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
160  *         registrant's entries in the OperatorFilterRegistry.
161  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
162  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
163  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
164  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
165  *         administration methods on the contract itself to interact with the registry otherwise the subscription
166  *         will be locked to the options set during construction.
167  */
168 
169 abstract contract OperatorFilterer {
170     /// @dev Emitted when an operator is not allowed.
171     error OperatorNotAllowed(address operator);
172 
173     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
174         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
175 
176     /// @dev The constructor that is called when the contract is being deployed.
177     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
178         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
179         // will not revert, but the contract will need to be registered with the registry once it is deployed in
180         // order for the modifier to filter addresses.
181         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
182             if (subscribe) {
183                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
184             } else {
185                 if (subscriptionOrRegistrantToCopy != address(0)) {
186                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
187                 } else {
188                     OPERATOR_FILTER_REGISTRY.register(address(this));
189                 }
190             }
191         }
192     }
193 
194     /**
195      * @dev A helper function to check if an operator is allowed.
196      */
197     modifier onlyAllowedOperator(address from) virtual {
198         // Allow spending tokens from addresses with balance
199         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
200         // from an EOA.
201         if (from != msg.sender) {
202             _checkFilterOperator(msg.sender);
203         }
204         _;
205     }
206 
207     /**
208      * @dev A helper function to check if an operator approval is allowed.
209      */
210     modifier onlyAllowedOperatorApproval(address operator) virtual {
211         _checkFilterOperator(operator);
212         _;
213     }
214 
215     /**
216      * @dev A helper function to check if an operator is allowed.
217      */
218     function _checkFilterOperator(address operator) internal view virtual {
219         // Check registry code length to facilitate testing in environments without a deployed registry.
220         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
221             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
222             // may specify their own OperatorFilterRegistry implementations, which may behave differently
223             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
224                 revert OperatorNotAllowed(operator);
225             }
226         }
227     }
228 }
229 
230 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
231 
232 
233 pragma solidity ^0.8.13;
234 
235 
236 /**
237  * @title  DefaultOperatorFilterer
238  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
239  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
240  *         administration methods on the contract itself to interact with the registry otherwise the subscription
241  *         will be locked to the options set during construction.
242  */
243 
244 abstract contract DefaultOperatorFilterer is OperatorFilterer {
245     /// @dev The constructor that is called when the contract is being deployed.
246     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
247 }
248 
249 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
250 
251 
252 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev These functions deal with verification of Merkle Tree proofs.
258  *
259  * The tree and the proofs can be generated using our
260  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
261  * You will find a quickstart guide in the readme.
262  *
263  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
264  * hashing, or use a hash function other than keccak256 for hashing leaves.
265  * This is because the concatenation of a sorted pair of internal nodes in
266  * the merkle tree could be reinterpreted as a leaf value.
267  * OpenZeppelin's JavaScript library generates merkle trees that are safe
268  * against this attack out of the box.
269  */
270 library MerkleProof {
271     /**
272      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
273      * defined by `root`. For this, a `proof` must be provided, containing
274      * sibling hashes on the branch from the leaf to the root of the tree. Each
275      * pair of leaves and each pair of pre-images are assumed to be sorted.
276      */
277     function verify(
278         bytes32[] memory proof,
279         bytes32 root,
280         bytes32 leaf
281     ) internal pure returns (bool) {
282         return processProof(proof, leaf) == root;
283     }
284 
285     /**
286      * @dev Calldata version of {verify}
287      *
288      * _Available since v4.7._
289      */
290     function verifyCalldata(
291         bytes32[] calldata proof,
292         bytes32 root,
293         bytes32 leaf
294     ) internal pure returns (bool) {
295         return processProofCalldata(proof, leaf) == root;
296     }
297 
298     /**
299      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
300      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
301      * hash matches the root of the tree. When processing the proof, the pairs
302      * of leafs & pre-images are assumed to be sorted.
303      *
304      * _Available since v4.4._
305      */
306     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
307         bytes32 computedHash = leaf;
308         for (uint256 i = 0; i < proof.length; i++) {
309             computedHash = _hashPair(computedHash, proof[i]);
310         }
311         return computedHash;
312     }
313 
314     /**
315      * @dev Calldata version of {processProof}
316      *
317      * _Available since v4.7._
318      */
319     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
320         bytes32 computedHash = leaf;
321         for (uint256 i = 0; i < proof.length; i++) {
322             computedHash = _hashPair(computedHash, proof[i]);
323         }
324         return computedHash;
325     }
326 
327     /**
328      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
329      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
330      *
331      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
332      *
333      * _Available since v4.7._
334      */
335     function multiProofVerify(
336         bytes32[] memory proof,
337         bool[] memory proofFlags,
338         bytes32 root,
339         bytes32[] memory leaves
340     ) internal pure returns (bool) {
341         return processMultiProof(proof, proofFlags, leaves) == root;
342     }
343 
344     /**
345      * @dev Calldata version of {multiProofVerify}
346      *
347      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
348      *
349      * _Available since v4.7._
350      */
351     function multiProofVerifyCalldata(
352         bytes32[] calldata proof,
353         bool[] calldata proofFlags,
354         bytes32 root,
355         bytes32[] memory leaves
356     ) internal pure returns (bool) {
357         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
358     }
359 
360     /**
361      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
362      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
363      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
364      * respectively.
365      *
366      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
367      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
368      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
369      *
370      * _Available since v4.7._
371      */
372     function processMultiProof(
373         bytes32[] memory proof,
374         bool[] memory proofFlags,
375         bytes32[] memory leaves
376     ) internal pure returns (bytes32 merkleRoot) {
377         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
378         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
379         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
380         // the merkle tree.
381         uint256 leavesLen = leaves.length;
382         uint256 totalHashes = proofFlags.length;
383 
384         // Check proof validity.
385         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
386 
387         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
388         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
389         bytes32[] memory hashes = new bytes32[](totalHashes);
390         uint256 leafPos = 0;
391         uint256 hashPos = 0;
392         uint256 proofPos = 0;
393         // At each step, we compute the next hash using two values:
394         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
395         //   get the next hash.
396         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
397         //   `proof` array.
398         for (uint256 i = 0; i < totalHashes; i++) {
399             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
400             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
401             hashes[i] = _hashPair(a, b);
402         }
403 
404         if (totalHashes > 0) {
405             return hashes[totalHashes - 1];
406         } else if (leavesLen > 0) {
407             return leaves[0];
408         } else {
409             return proof[0];
410         }
411     }
412 
413     /**
414      * @dev Calldata version of {processMultiProof}.
415      *
416      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
417      *
418      * _Available since v4.7._
419      */
420     function processMultiProofCalldata(
421         bytes32[] calldata proof,
422         bool[] calldata proofFlags,
423         bytes32[] memory leaves
424     ) internal pure returns (bytes32 merkleRoot) {
425         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
426         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
427         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
428         // the merkle tree.
429         uint256 leavesLen = leaves.length;
430         uint256 totalHashes = proofFlags.length;
431 
432         // Check proof validity.
433         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
434 
435         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
436         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
437         bytes32[] memory hashes = new bytes32[](totalHashes);
438         uint256 leafPos = 0;
439         uint256 hashPos = 0;
440         uint256 proofPos = 0;
441         // At each step, we compute the next hash using two values:
442         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
443         //   get the next hash.
444         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
445         //   `proof` array.
446         for (uint256 i = 0; i < totalHashes; i++) {
447             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
448             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
449             hashes[i] = _hashPair(a, b);
450         }
451 
452         if (totalHashes > 0) {
453             return hashes[totalHashes - 1];
454         } else if (leavesLen > 0) {
455             return leaves[0];
456         } else {
457             return proof[0];
458         }
459     }
460 
461     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
462         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
463     }
464 
465     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
466         /// @solidity memory-safe-assembly
467         assembly {
468             mstore(0x00, a)
469             mstore(0x20, b)
470             value := keccak256(0x00, 0x40)
471         }
472     }
473 }
474 
475 // File: @openzeppelin/contracts/utils/math/Math.sol
476 
477 
478 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev Standard math utilities missing in the Solidity language.
484  */
485 library Math {
486     enum Rounding {
487         Down, // Toward negative infinity
488         Up, // Toward infinity
489         Zero // Toward zero
490     }
491 
492     /**
493      * @dev Returns the largest of two numbers.
494      */
495     function max(uint256 a, uint256 b) internal pure returns (uint256) {
496         return a > b ? a : b;
497     }
498 
499     /**
500      * @dev Returns the smallest of two numbers.
501      */
502     function min(uint256 a, uint256 b) internal pure returns (uint256) {
503         return a < b ? a : b;
504     }
505 
506     /**
507      * @dev Returns the average of two numbers. The result is rounded towards
508      * zero.
509      */
510     function average(uint256 a, uint256 b) internal pure returns (uint256) {
511         // (a + b) / 2 can overflow.
512         return (a & b) + (a ^ b) / 2;
513     }
514 
515     /**
516      * @dev Returns the ceiling of the division of two numbers.
517      *
518      * This differs from standard division with `/` in that it rounds up instead
519      * of rounding down.
520      */
521     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
522         // (a + b - 1) / b can overflow on addition, so we distribute.
523         return a == 0 ? 0 : (a - 1) / b + 1;
524     }
525 
526     /**
527      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
528      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
529      * with further edits by Uniswap Labs also under MIT license.
530      */
531     function mulDiv(
532         uint256 x,
533         uint256 y,
534         uint256 denominator
535     ) internal pure returns (uint256 result) {
536         unchecked {
537             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
538             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
539             // variables such that product = prod1 * 2^256 + prod0.
540             uint256 prod0; // Least significant 256 bits of the product
541             uint256 prod1; // Most significant 256 bits of the product
542             assembly {
543                 let mm := mulmod(x, y, not(0))
544                 prod0 := mul(x, y)
545                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
546             }
547 
548             // Handle non-overflow cases, 256 by 256 division.
549             if (prod1 == 0) {
550                 return prod0 / denominator;
551             }
552 
553             // Make sure the result is less than 2^256. Also prevents denominator == 0.
554             require(denominator > prod1);
555 
556             ///////////////////////////////////////////////
557             // 512 by 256 division.
558             ///////////////////////////////////////////////
559 
560             // Make division exact by subtracting the remainder from [prod1 prod0].
561             uint256 remainder;
562             assembly {
563                 // Compute remainder using mulmod.
564                 remainder := mulmod(x, y, denominator)
565 
566                 // Subtract 256 bit number from 512 bit number.
567                 prod1 := sub(prod1, gt(remainder, prod0))
568                 prod0 := sub(prod0, remainder)
569             }
570 
571             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
572             // See https://cs.stackexchange.com/q/138556/92363.
573 
574             // Does not overflow because the denominator cannot be zero at this stage in the function.
575             uint256 twos = denominator & (~denominator + 1);
576             assembly {
577                 // Divide denominator by twos.
578                 denominator := div(denominator, twos)
579 
580                 // Divide [prod1 prod0] by twos.
581                 prod0 := div(prod0, twos)
582 
583                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
584                 twos := add(div(sub(0, twos), twos), 1)
585             }
586 
587             // Shift in bits from prod1 into prod0.
588             prod0 |= prod1 * twos;
589 
590             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
591             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
592             // four bits. That is, denominator * inv = 1 mod 2^4.
593             uint256 inverse = (3 * denominator) ^ 2;
594 
595             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
596             // in modular arithmetic, doubling the correct bits in each step.
597             inverse *= 2 - denominator * inverse; // inverse mod 2^8
598             inverse *= 2 - denominator * inverse; // inverse mod 2^16
599             inverse *= 2 - denominator * inverse; // inverse mod 2^32
600             inverse *= 2 - denominator * inverse; // inverse mod 2^64
601             inverse *= 2 - denominator * inverse; // inverse mod 2^128
602             inverse *= 2 - denominator * inverse; // inverse mod 2^256
603 
604             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
605             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
606             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
607             // is no longer required.
608             result = prod0 * inverse;
609             return result;
610         }
611     }
612 
613     /**
614      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
615      */
616     function mulDiv(
617         uint256 x,
618         uint256 y,
619         uint256 denominator,
620         Rounding rounding
621     ) internal pure returns (uint256) {
622         uint256 result = mulDiv(x, y, denominator);
623         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
624             result += 1;
625         }
626         return result;
627     }
628 
629     /**
630      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
631      *
632      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
633      */
634     function sqrt(uint256 a) internal pure returns (uint256) {
635         if (a == 0) {
636             return 0;
637         }
638 
639         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
640         //
641         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
642         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
643         //
644         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
645         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
646         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
647         //
648         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
649         uint256 result = 1 << (log2(a) >> 1);
650 
651         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
652         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
653         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
654         // into the expected uint128 result.
655         unchecked {
656             result = (result + a / result) >> 1;
657             result = (result + a / result) >> 1;
658             result = (result + a / result) >> 1;
659             result = (result + a / result) >> 1;
660             result = (result + a / result) >> 1;
661             result = (result + a / result) >> 1;
662             result = (result + a / result) >> 1;
663             return min(result, a / result);
664         }
665     }
666 
667     /**
668      * @notice Calculates sqrt(a), following the selected rounding direction.
669      */
670     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
671         unchecked {
672             uint256 result = sqrt(a);
673             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
674         }
675     }
676 
677     /**
678      * @dev Return the log in base 2, rounded down, of a positive value.
679      * Returns 0 if given 0.
680      */
681     function log2(uint256 value) internal pure returns (uint256) {
682         uint256 result = 0;
683         unchecked {
684             if (value >> 128 > 0) {
685                 value >>= 128;
686                 result += 128;
687             }
688             if (value >> 64 > 0) {
689                 value >>= 64;
690                 result += 64;
691             }
692             if (value >> 32 > 0) {
693                 value >>= 32;
694                 result += 32;
695             }
696             if (value >> 16 > 0) {
697                 value >>= 16;
698                 result += 16;
699             }
700             if (value >> 8 > 0) {
701                 value >>= 8;
702                 result += 8;
703             }
704             if (value >> 4 > 0) {
705                 value >>= 4;
706                 result += 4;
707             }
708             if (value >> 2 > 0) {
709                 value >>= 2;
710                 result += 2;
711             }
712             if (value >> 1 > 0) {
713                 result += 1;
714             }
715         }
716         return result;
717     }
718 
719     /**
720      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
721      * Returns 0 if given 0.
722      */
723     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
724         unchecked {
725             uint256 result = log2(value);
726             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
727         }
728     }
729 
730     /**
731      * @dev Return the log in base 10, rounded down, of a positive value.
732      * Returns 0 if given 0.
733      */
734     function log10(uint256 value) internal pure returns (uint256) {
735         uint256 result = 0;
736         unchecked {
737             if (value >= 10**64) {
738                 value /= 10**64;
739                 result += 64;
740             }
741             if (value >= 10**32) {
742                 value /= 10**32;
743                 result += 32;
744             }
745             if (value >= 10**16) {
746                 value /= 10**16;
747                 result += 16;
748             }
749             if (value >= 10**8) {
750                 value /= 10**8;
751                 result += 8;
752             }
753             if (value >= 10**4) {
754                 value /= 10**4;
755                 result += 4;
756             }
757             if (value >= 10**2) {
758                 value /= 10**2;
759                 result += 2;
760             }
761             if (value >= 10**1) {
762                 result += 1;
763             }
764         }
765         return result;
766     }
767 
768     /**
769      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
770      * Returns 0 if given 0.
771      */
772     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
773         unchecked {
774             uint256 result = log10(value);
775             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
776         }
777     }
778 
779     /**
780      * @dev Return the log in base 256, rounded down, of a positive value.
781      * Returns 0 if given 0.
782      *
783      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
784      */
785     function log256(uint256 value) internal pure returns (uint256) {
786         uint256 result = 0;
787         unchecked {
788             if (value >> 128 > 0) {
789                 value >>= 128;
790                 result += 16;
791             }
792             if (value >> 64 > 0) {
793                 value >>= 64;
794                 result += 8;
795             }
796             if (value >> 32 > 0) {
797                 value >>= 32;
798                 result += 4;
799             }
800             if (value >> 16 > 0) {
801                 value >>= 16;
802                 result += 2;
803             }
804             if (value >> 8 > 0) {
805                 result += 1;
806             }
807         }
808         return result;
809     }
810 
811     /**
812      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
813      * Returns 0 if given 0.
814      */
815     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
816         unchecked {
817             uint256 result = log256(value);
818             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
819         }
820     }
821 }
822 
823 // File: @openzeppelin/contracts/utils/Strings.sol
824 
825 
826 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
827 
828 pragma solidity ^0.8.0;
829 
830 
831 /**
832  * @dev String operations.
833  */
834 library Strings {
835     bytes16 private constant _SYMBOLS = "0123456789abcdef";
836     uint8 private constant _ADDRESS_LENGTH = 20;
837 
838     /**
839      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
840      */
841     function toString(uint256 value) internal pure returns (string memory) {
842         unchecked {
843             uint256 length = Math.log10(value) + 1;
844             string memory buffer = new string(length);
845             uint256 ptr;
846             /// @solidity memory-safe-assembly
847             assembly {
848                 ptr := add(buffer, add(32, length))
849             }
850             while (true) {
851                 ptr--;
852                 /// @solidity memory-safe-assembly
853                 assembly {
854                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
855                 }
856                 value /= 10;
857                 if (value == 0) break;
858             }
859             return buffer;
860         }
861     }
862 
863     /**
864      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
865      */
866     function toHexString(uint256 value) internal pure returns (string memory) {
867         unchecked {
868             return toHexString(value, Math.log256(value) + 1);
869         }
870     }
871 
872     /**
873      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
874      */
875     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
876         bytes memory buffer = new bytes(2 * length + 2);
877         buffer[0] = "0";
878         buffer[1] = "x";
879         for (uint256 i = 2 * length + 1; i > 1; --i) {
880             buffer[i] = _SYMBOLS[value & 0xf];
881             value >>= 4;
882         }
883         require(value == 0, "Strings: hex length insufficient");
884         return string(buffer);
885     }
886 
887     /**
888      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
889      */
890     function toHexString(address addr) internal pure returns (string memory) {
891         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
892     }
893 }
894 
895 // File: @openzeppelin/contracts/utils/Context.sol
896 
897 
898 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
899 
900 pragma solidity ^0.8.0;
901 
902 /**
903  * @dev Provides information about the current execution context, including the
904  * sender of the transaction and its data. While these are generally available
905  * via msg.sender and msg.data, they should not be accessed in such a direct
906  * manner, since when dealing with meta-transactions the account sending and
907  * paying for execution may not be the actual sender (as far as an application
908  * is concerned).
909  *
910  * This contract is only required for intermediate, library-like contracts.
911  */
912 abstract contract Context {
913     function _msgSender() internal view virtual returns (address) {
914         return msg.sender;
915     }
916 
917     function _msgData() internal view virtual returns (bytes calldata) {
918         return msg.data;
919     }
920 }
921 
922 // File: @openzeppelin/contracts/access/Ownable.sol
923 
924 
925 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 
930 /**
931  * @dev Contract module which provides a basic access control mechanism, where
932  * there is an account (an owner) that can be granted exclusive access to
933  * specific functions.
934  *
935  * By default, the owner account will be the one that deploys the contract. This
936  * can later be changed with {transferOwnership}.
937  *
938  * This module is used through inheritance. It will make available the modifier
939  * `onlyOwner`, which can be applied to your functions to restrict their use to
940  * the owner.
941  */
942 abstract contract Ownable is Context {
943     address private _owner;
944 
945     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
946 
947     /**
948      * @dev Initializes the contract setting the deployer as the initial owner.
949      */
950     constructor() {
951         _transferOwnership(_msgSender());
952     }
953 
954     /**
955      * @dev Throws if called by any account other than the owner.
956      */
957     modifier onlyOwner() {
958         _checkOwner();
959         _;
960     }
961 
962     /**
963      * @dev Returns the address of the current owner.
964      */
965     function owner() public view virtual returns (address) {
966         return _owner;
967     }
968 
969     /**
970      * @dev Throws if the sender is not the owner.
971      */
972     function _checkOwner() internal view virtual {
973         require(owner() == _msgSender(), "Ownable: caller is not the owner");
974     }
975 
976     /**
977      * @dev Leaves the contract without owner. It will not be possible to call
978      * `onlyOwner` functions anymore. Can only be called by the current owner.
979      *
980      * NOTE: Renouncing ownership will leave the contract without an owner,
981      * thereby removing any functionality that is only available to the owner.
982      */
983     function renounceOwnership() public virtual onlyOwner {
984         _transferOwnership(address(0));
985     }
986 
987     /**
988      * @dev Transfers ownership of the contract to a new account (`newOwner`).
989      * Can only be called by the current owner.
990      */
991     function transferOwnership(address newOwner) public virtual onlyOwner {
992         require(newOwner != address(0), "Ownable: new owner is the zero address");
993         _transferOwnership(newOwner);
994     }
995 
996     /**
997      * @dev Transfers ownership of the contract to a new account (`newOwner`).
998      * Internal function without access restriction.
999      */
1000     function _transferOwnership(address newOwner) internal virtual {
1001         address oldOwner = _owner;
1002         _owner = newOwner;
1003         emit OwnershipTransferred(oldOwner, newOwner);
1004     }
1005 }
1006 
1007 // File: erc721a/contracts/IERC721A.sol
1008 
1009 
1010 // ERC721A Contracts v4.2.3
1011 // Creator: Chiru Labs
1012 
1013 pragma solidity ^0.8.4;
1014 
1015 /**
1016  * @dev Interface of ERC721A.
1017  */
1018 interface IERC721A {
1019     /**
1020      * The caller must own the token or be an approved operator.
1021      */
1022     error ApprovalCallerNotOwnerNorApproved();
1023 
1024     /**
1025      * The token does not exist.
1026      */
1027     error ApprovalQueryForNonexistentToken();
1028 
1029     /**
1030      * Cannot query the balance for the zero address.
1031      */
1032     error BalanceQueryForZeroAddress();
1033 
1034     /**
1035      * Cannot mint to the zero address.
1036      */
1037     error MintToZeroAddress();
1038 
1039     /**
1040      * The quantity of tokens minted must be more than zero.
1041      */
1042     error MintZeroQuantity();
1043 
1044     /**
1045      * The token does not exist.
1046      */
1047     error OwnerQueryForNonexistentToken();
1048 
1049     /**
1050      * The caller must own the token or be an approved operator.
1051      */
1052     error TransferCallerNotOwnerNorApproved();
1053 
1054     /**
1055      * The token must be owned by `from`.
1056      */
1057     error TransferFromIncorrectOwner();
1058 
1059     /**
1060      * Cannot safely transfer to a contract that does not implement the
1061      * ERC721Receiver interface.
1062      */
1063     error TransferToNonERC721ReceiverImplementer();
1064 
1065     /**
1066      * Cannot transfer to the zero address.
1067      */
1068     error TransferToZeroAddress();
1069 
1070     /**
1071      * The token does not exist.
1072      */
1073     error URIQueryForNonexistentToken();
1074 
1075     /**
1076      * The `quantity` minted with ERC2309 exceeds the safety limit.
1077      */
1078     error MintERC2309QuantityExceedsLimit();
1079 
1080     /**
1081      * The `extraData` cannot be set on an unintialized ownership slot.
1082      */
1083     error OwnershipNotInitializedForExtraData();
1084 
1085     // =============================================================
1086     //                            STRUCTS
1087     // =============================================================
1088 
1089     struct TokenOwnership {
1090         // The address of the owner.
1091         address addr;
1092         // Stores the start time of ownership with minimal overhead for tokenomics.
1093         uint64 startTimestamp;
1094         // Whether the token has been burned.
1095         bool burned;
1096         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1097         uint24 extraData;
1098     }
1099 
1100     // =============================================================
1101     //                         TOKEN COUNTERS
1102     // =============================================================
1103 
1104     /**
1105      * @dev Returns the total number of tokens in existence.
1106      * Burned tokens will reduce the count.
1107      * To get the total number of tokens minted, please see {_totalMinted}.
1108      */
1109     function totalSupply() external view returns (uint256);
1110 
1111     // =============================================================
1112     //                            IERC165
1113     // =============================================================
1114 
1115     /**
1116      * @dev Returns true if this contract implements the interface defined by
1117      * `interfaceId`. See the corresponding
1118      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1119      * to learn more about how these ids are created.
1120      *
1121      * This function call must use less than 30000 gas.
1122      */
1123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1124 
1125     // =============================================================
1126     //                            IERC721
1127     // =============================================================
1128 
1129     /**
1130      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1131      */
1132     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1133 
1134     /**
1135      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1136      */
1137     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1138 
1139     /**
1140      * @dev Emitted when `owner` enables or disables
1141      * (`approved`) `operator` to manage all of its assets.
1142      */
1143     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1144 
1145     /**
1146      * @dev Returns the number of tokens in `owner`'s account.
1147      */
1148     function balanceOf(address owner) external view returns (uint256 balance);
1149 
1150     /**
1151      * @dev Returns the owner of the `tokenId` token.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must exist.
1156      */
1157     function ownerOf(uint256 tokenId) external view returns (address owner);
1158 
1159     /**
1160      * @dev Safely transfers `tokenId` token from `from` to `to`,
1161      * checking first that contract recipients are aware of the ERC721 protocol
1162      * to prevent tokens from being forever locked.
1163      *
1164      * Requirements:
1165      *
1166      * - `from` cannot be the zero address.
1167      * - `to` cannot be the zero address.
1168      * - `tokenId` token must exist and be owned by `from`.
1169      * - If the caller is not `from`, it must be have been allowed to move
1170      * this token by either {approve} or {setApprovalForAll}.
1171      * - If `to` refers to a smart contract, it must implement
1172      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1173      *
1174      * Emits a {Transfer} event.
1175      */
1176     function safeTransferFrom(
1177         address from,
1178         address to,
1179         uint256 tokenId,
1180         bytes calldata data
1181     ) external payable;
1182 
1183     /**
1184      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1185      */
1186     function safeTransferFrom(
1187         address from,
1188         address to,
1189         uint256 tokenId
1190     ) external payable;
1191 
1192     /**
1193      * @dev Transfers `tokenId` from `from` to `to`.
1194      *
1195      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1196      * whenever possible.
1197      *
1198      * Requirements:
1199      *
1200      * - `from` cannot be the zero address.
1201      * - `to` cannot be the zero address.
1202      * - `tokenId` token must be owned by `from`.
1203      * - If the caller is not `from`, it must be approved to move this token
1204      * by either {approve} or {setApprovalForAll}.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function transferFrom(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) external payable;
1213 
1214     /**
1215      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1216      * The approval is cleared when the token is transferred.
1217      *
1218      * Only a single account can be approved at a time, so approving the
1219      * zero address clears previous approvals.
1220      *
1221      * Requirements:
1222      *
1223      * - The caller must own the token or be an approved operator.
1224      * - `tokenId` must exist.
1225      *
1226      * Emits an {Approval} event.
1227      */
1228     function approve(address to, uint256 tokenId) external payable;
1229 
1230     /**
1231      * @dev Approve or remove `operator` as an operator for the caller.
1232      * Operators can call {transferFrom} or {safeTransferFrom}
1233      * for any token owned by the caller.
1234      *
1235      * Requirements:
1236      *
1237      * - The `operator` cannot be the caller.
1238      *
1239      * Emits an {ApprovalForAll} event.
1240      */
1241     function setApprovalForAll(address operator, bool _approved) external;
1242 
1243     /**
1244      * @dev Returns the account approved for `tokenId` token.
1245      *
1246      * Requirements:
1247      *
1248      * - `tokenId` must exist.
1249      */
1250     function getApproved(uint256 tokenId) external view returns (address operator);
1251 
1252     /**
1253      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1254      *
1255      * See {setApprovalForAll}.
1256      */
1257     function isApprovedForAll(address owner, address operator) external view returns (bool);
1258 
1259     // =============================================================
1260     //                        IERC721Metadata
1261     // =============================================================
1262 
1263     /**
1264      * @dev Returns the token collection name.
1265      */
1266     function name() external view returns (string memory);
1267 
1268     /**
1269      * @dev Returns the token collection symbol.
1270      */
1271     function symbol() external view returns (string memory);
1272 
1273     /**
1274      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1275      */
1276     function tokenURI(uint256 tokenId) external view returns (string memory);
1277 
1278     // =============================================================
1279     //                           IERC2309
1280     // =============================================================
1281 
1282     /**
1283      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1284      * (inclusive) is transferred from `from` to `to`, as defined in the
1285      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1286      *
1287      * See {_mintERC2309} for more details.
1288      */
1289     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1290 }
1291 
1292 // File: erc721a/contracts/ERC721A.sol
1293 
1294 
1295 // ERC721A Contracts v4.2.3
1296 // Creator: Chiru Labs
1297 
1298 pragma solidity ^0.8.4;
1299 
1300 
1301 /**
1302  * @dev Interface of ERC721 token receiver.
1303  */
1304 interface ERC721A__IERC721Receiver {
1305     function onERC721Received(
1306         address operator,
1307         address from,
1308         uint256 tokenId,
1309         bytes calldata data
1310     ) external returns (bytes4);
1311 }
1312 
1313 /**
1314  * @title ERC721A
1315  *
1316  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1317  * Non-Fungible Token Standard, including the Metadata extension.
1318  * Optimized for lower gas during batch mints.
1319  *
1320  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1321  * starting from `_startTokenId()`.
1322  *
1323  * Assumptions:
1324  *
1325  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1326  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1327  */
1328 contract ERC721A is IERC721A {
1329     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1330     struct TokenApprovalRef {
1331         address value;
1332     }
1333 
1334     // =============================================================
1335     //                           CONSTANTS
1336     // =============================================================
1337 
1338     // Mask of an entry in packed address data.
1339     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1340 
1341     // The bit position of `numberMinted` in packed address data.
1342     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1343 
1344     // The bit position of `numberBurned` in packed address data.
1345     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1346 
1347     // The bit position of `aux` in packed address data.
1348     uint256 private constant _BITPOS_AUX = 192;
1349 
1350     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1351     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1352 
1353     // The bit position of `startTimestamp` in packed ownership.
1354     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1355 
1356     // The bit mask of the `burned` bit in packed ownership.
1357     uint256 private constant _BITMASK_BURNED = 1 << 224;
1358 
1359     // The bit position of the `nextInitialized` bit in packed ownership.
1360     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1361 
1362     // The bit mask of the `nextInitialized` bit in packed ownership.
1363     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1364 
1365     // The bit position of `extraData` in packed ownership.
1366     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1367 
1368     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1369     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1370 
1371     // The mask of the lower 160 bits for addresses.
1372     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1373 
1374     // The maximum `quantity` that can be minted with {_mintERC2309}.
1375     // This limit is to prevent overflows on the address data entries.
1376     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1377     // is required to cause an overflow, which is unrealistic.
1378     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1379 
1380     // The `Transfer` event signature is given by:
1381     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1382     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1383         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1384 
1385     // =============================================================
1386     //                            STORAGE
1387     // =============================================================
1388 
1389     // The next token ID to be minted.
1390     uint256 private _currentIndex;
1391 
1392     // The number of tokens burned.
1393     uint256 private _burnCounter;
1394 
1395     // Token name
1396     string private _name;
1397 
1398     // Token symbol
1399     string private _symbol;
1400 
1401     // Mapping from token ID to ownership details
1402     // An empty struct value does not necessarily mean the token is unowned.
1403     // See {_packedOwnershipOf} implementation for details.
1404     //
1405     // Bits Layout:
1406     // - [0..159]   `addr`
1407     // - [160..223] `startTimestamp`
1408     // - [224]      `burned`
1409     // - [225]      `nextInitialized`
1410     // - [232..255] `extraData`
1411     mapping(uint256 => uint256) private _packedOwnerships;
1412 
1413     // Mapping owner address to address data.
1414     //
1415     // Bits Layout:
1416     // - [0..63]    `balance`
1417     // - [64..127]  `numberMinted`
1418     // - [128..191] `numberBurned`
1419     // - [192..255] `aux`
1420     mapping(address => uint256) private _packedAddressData;
1421 
1422     // Mapping from token ID to approved address.
1423     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1424 
1425     // Mapping from owner to operator approvals
1426     mapping(address => mapping(address => bool)) private _operatorApprovals;
1427 
1428     // =============================================================
1429     //                          CONSTRUCTOR
1430     // =============================================================
1431 
1432     constructor(string memory name_, string memory symbol_) {
1433         _name = name_;
1434         _symbol = symbol_;
1435         _currentIndex = _startTokenId();
1436     }
1437 
1438     // =============================================================
1439     //                   TOKEN COUNTING OPERATIONS
1440     // =============================================================
1441 
1442     /**
1443      * @dev Returns the starting token ID.
1444      * To change the starting token ID, please override this function.
1445      */
1446     function _startTokenId() internal view virtual returns (uint256) {
1447         return 0;
1448     }
1449 
1450     /**
1451      * @dev Returns the next token ID to be minted.
1452      */
1453     function _nextTokenId() internal view virtual returns (uint256) {
1454         return _currentIndex;
1455     }
1456 
1457     /**
1458      * @dev Returns the total number of tokens in existence.
1459      * Burned tokens will reduce the count.
1460      * To get the total number of tokens minted, please see {_totalMinted}.
1461      */
1462     function totalSupply() public view virtual override returns (uint256) {
1463         // Counter underflow is impossible as _burnCounter cannot be incremented
1464         // more than `_currentIndex - _startTokenId()` times.
1465         unchecked {
1466             return _currentIndex - _burnCounter - _startTokenId();
1467         }
1468     }
1469 
1470     /**
1471      * @dev Returns the total amount of tokens minted in the contract.
1472      */
1473     function _totalMinted() internal view virtual returns (uint256) {
1474         // Counter underflow is impossible as `_currentIndex` does not decrement,
1475         // and it is initialized to `_startTokenId()`.
1476         unchecked {
1477             return _currentIndex - _startTokenId();
1478         }
1479     }
1480 
1481     /**
1482      * @dev Returns the total number of tokens burned.
1483      */
1484     function _totalBurned() internal view virtual returns (uint256) {
1485         return _burnCounter;
1486     }
1487 
1488     // =============================================================
1489     //                    ADDRESS DATA OPERATIONS
1490     // =============================================================
1491 
1492     /**
1493      * @dev Returns the number of tokens in `owner`'s account.
1494      */
1495     function balanceOf(address owner) public view virtual override returns (uint256) {
1496         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1497         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1498     }
1499 
1500     /**
1501      * Returns the number of tokens minted by `owner`.
1502      */
1503     function _numberMinted(address owner) internal view returns (uint256) {
1504         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1505     }
1506 
1507     /**
1508      * Returns the number of tokens burned by or on behalf of `owner`.
1509      */
1510     function _numberBurned(address owner) internal view returns (uint256) {
1511         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1512     }
1513 
1514     /**
1515      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1516      */
1517     function _getAux(address owner) internal view returns (uint64) {
1518         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1519     }
1520 
1521     /**
1522      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1523      * If there are multiple variables, please pack them into a uint64.
1524      */
1525     function _setAux(address owner, uint64 aux) internal virtual {
1526         uint256 packed = _packedAddressData[owner];
1527         uint256 auxCasted;
1528         // Cast `aux` with assembly to avoid redundant masking.
1529         assembly {
1530             auxCasted := aux
1531         }
1532         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1533         _packedAddressData[owner] = packed;
1534     }
1535 
1536     // =============================================================
1537     //                            IERC165
1538     // =============================================================
1539 
1540     /**
1541      * @dev Returns true if this contract implements the interface defined by
1542      * `interfaceId`. See the corresponding
1543      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1544      * to learn more about how these ids are created.
1545      *
1546      * This function call must use less than 30000 gas.
1547      */
1548     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1549         // The interface IDs are constants representing the first 4 bytes
1550         // of the XOR of all function selectors in the interface.
1551         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1552         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1553         return
1554             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1555             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1556             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1557     }
1558 
1559     // =============================================================
1560     //                        IERC721Metadata
1561     // =============================================================
1562 
1563     /**
1564      * @dev Returns the token collection name.
1565      */
1566     function name() public view virtual override returns (string memory) {
1567         return _name;
1568     }
1569 
1570     /**
1571      * @dev Returns the token collection symbol.
1572      */
1573     function symbol() public view virtual override returns (string memory) {
1574         return _symbol;
1575     }
1576 
1577     /**
1578      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1579      */
1580     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1581         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1582 
1583         string memory baseURI = _baseURI();
1584         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1585     }
1586 
1587     /**
1588      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1589      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1590      * by default, it can be overridden in child contracts.
1591      */
1592     function _baseURI() internal view virtual returns (string memory) {
1593         return '';
1594     }
1595 
1596     // =============================================================
1597     //                     OWNERSHIPS OPERATIONS
1598     // =============================================================
1599 
1600     /**
1601      * @dev Returns the owner of the `tokenId` token.
1602      *
1603      * Requirements:
1604      *
1605      * - `tokenId` must exist.
1606      */
1607     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1608         return address(uint160(_packedOwnershipOf(tokenId)));
1609     }
1610 
1611     /**
1612      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1613      * It gradually moves to O(1) as tokens get transferred around over time.
1614      */
1615     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1616         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1617     }
1618 
1619     /**
1620      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1621      */
1622     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1623         return _unpackedOwnership(_packedOwnerships[index]);
1624     }
1625 
1626     /**
1627      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1628      */
1629     function _initializeOwnershipAt(uint256 index) internal virtual {
1630         if (_packedOwnerships[index] == 0) {
1631             _packedOwnerships[index] = _packedOwnershipOf(index);
1632         }
1633     }
1634 
1635     /**
1636      * Returns the packed ownership data of `tokenId`.
1637      */
1638     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1639         uint256 curr = tokenId;
1640 
1641         unchecked {
1642             if (_startTokenId() <= curr)
1643                 if (curr < _currentIndex) {
1644                     uint256 packed = _packedOwnerships[curr];
1645                     // If not burned.
1646                     if (packed & _BITMASK_BURNED == 0) {
1647                         // Invariant:
1648                         // There will always be an initialized ownership slot
1649                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1650                         // before an unintialized ownership slot
1651                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1652                         // Hence, `curr` will not underflow.
1653                         //
1654                         // We can directly compare the packed value.
1655                         // If the address is zero, packed will be zero.
1656                         while (packed == 0) {
1657                             packed = _packedOwnerships[--curr];
1658                         }
1659                         return packed;
1660                     }
1661                 }
1662         }
1663         revert OwnerQueryForNonexistentToken();
1664     }
1665 
1666     /**
1667      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1668      */
1669     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1670         ownership.addr = address(uint160(packed));
1671         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1672         ownership.burned = packed & _BITMASK_BURNED != 0;
1673         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1674     }
1675 
1676     /**
1677      * @dev Packs ownership data into a single uint256.
1678      */
1679     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1680         assembly {
1681             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1682             owner := and(owner, _BITMASK_ADDRESS)
1683             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1684             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1685         }
1686     }
1687 
1688     /**
1689      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1690      */
1691     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1692         // For branchless setting of the `nextInitialized` flag.
1693         assembly {
1694             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1695             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1696         }
1697     }
1698 
1699     // =============================================================
1700     //                      APPROVAL OPERATIONS
1701     // =============================================================
1702 
1703     /**
1704      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1705      * The approval is cleared when the token is transferred.
1706      *
1707      * Only a single account can be approved at a time, so approving the
1708      * zero address clears previous approvals.
1709      *
1710      * Requirements:
1711      *
1712      * - The caller must own the token or be an approved operator.
1713      * - `tokenId` must exist.
1714      *
1715      * Emits an {Approval} event.
1716      */
1717     function approve(address to, uint256 tokenId) public payable virtual override {
1718         address owner = ownerOf(tokenId);
1719 
1720         if (_msgSenderERC721A() != owner)
1721             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1722                 revert ApprovalCallerNotOwnerNorApproved();
1723             }
1724 
1725         _tokenApprovals[tokenId].value = to;
1726         emit Approval(owner, to, tokenId);
1727     }
1728 
1729     /**
1730      * @dev Returns the account approved for `tokenId` token.
1731      *
1732      * Requirements:
1733      *
1734      * - `tokenId` must exist.
1735      */
1736     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1737         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1738 
1739         return _tokenApprovals[tokenId].value;
1740     }
1741 
1742     /**
1743      * @dev Approve or remove `operator` as an operator for the caller.
1744      * Operators can call {transferFrom} or {safeTransferFrom}
1745      * for any token owned by the caller.
1746      *
1747      * Requirements:
1748      *
1749      * - The `operator` cannot be the caller.
1750      *
1751      * Emits an {ApprovalForAll} event.
1752      */
1753     function setApprovalForAll(address operator, bool approved) public virtual override {
1754         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1755         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1756     }
1757 
1758     /**
1759      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1760      *
1761      * See {setApprovalForAll}.
1762      */
1763     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1764         return _operatorApprovals[owner][operator];
1765     }
1766 
1767     /**
1768      * @dev Returns whether `tokenId` exists.
1769      *
1770      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1771      *
1772      * Tokens start existing when they are minted. See {_mint}.
1773      */
1774     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1775         return
1776             _startTokenId() <= tokenId &&
1777             tokenId < _currentIndex && // If within bounds,
1778             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1779     }
1780 
1781     /**
1782      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1783      */
1784     function _isSenderApprovedOrOwner(
1785         address approvedAddress,
1786         address owner,
1787         address msgSender
1788     ) private pure returns (bool result) {
1789         assembly {
1790             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1791             owner := and(owner, _BITMASK_ADDRESS)
1792             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1793             msgSender := and(msgSender, _BITMASK_ADDRESS)
1794             // `msgSender == owner || msgSender == approvedAddress`.
1795             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1796         }
1797     }
1798 
1799     /**
1800      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1801      */
1802     function _getApprovedSlotAndAddress(uint256 tokenId)
1803         private
1804         view
1805         returns (uint256 approvedAddressSlot, address approvedAddress)
1806     {
1807         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1808         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1809         assembly {
1810             approvedAddressSlot := tokenApproval.slot
1811             approvedAddress := sload(approvedAddressSlot)
1812         }
1813     }
1814 
1815     // =============================================================
1816     //                      TRANSFER OPERATIONS
1817     // =============================================================
1818 
1819     /**
1820      * @dev Transfers `tokenId` from `from` to `to`.
1821      *
1822      * Requirements:
1823      *
1824      * - `from` cannot be the zero address.
1825      * - `to` cannot be the zero address.
1826      * - `tokenId` token must be owned by `from`.
1827      * - If the caller is not `from`, it must be approved to move this token
1828      * by either {approve} or {setApprovalForAll}.
1829      *
1830      * Emits a {Transfer} event.
1831      */
1832     function transferFrom(
1833         address from,
1834         address to,
1835         uint256 tokenId
1836     ) public payable virtual override {
1837         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1838 
1839         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1840 
1841         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1842 
1843         // The nested ifs save around 20+ gas over a compound boolean condition.
1844         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1845             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1846 
1847         if (to == address(0)) revert TransferToZeroAddress();
1848 
1849         _beforeTokenTransfers(from, to, tokenId, 1);
1850 
1851         // Clear approvals from the previous owner.
1852         assembly {
1853             if approvedAddress {
1854                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1855                 sstore(approvedAddressSlot, 0)
1856             }
1857         }
1858 
1859         // Underflow of the sender's balance is impossible because we check for
1860         // ownership above and the recipient's balance can't realistically overflow.
1861         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1862         unchecked {
1863             // We can directly increment and decrement the balances.
1864             --_packedAddressData[from]; // Updates: `balance -= 1`.
1865             ++_packedAddressData[to]; // Updates: `balance += 1`.
1866 
1867             // Updates:
1868             // - `address` to the next owner.
1869             // - `startTimestamp` to the timestamp of transfering.
1870             // - `burned` to `false`.
1871             // - `nextInitialized` to `true`.
1872             _packedOwnerships[tokenId] = _packOwnershipData(
1873                 to,
1874                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1875             );
1876 
1877             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1878             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1879                 uint256 nextTokenId = tokenId + 1;
1880                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1881                 if (_packedOwnerships[nextTokenId] == 0) {
1882                     // If the next slot is within bounds.
1883                     if (nextTokenId != _currentIndex) {
1884                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1885                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1886                     }
1887                 }
1888             }
1889         }
1890 
1891         emit Transfer(from, to, tokenId);
1892         _afterTokenTransfers(from, to, tokenId, 1);
1893     }
1894 
1895     /**
1896      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1897      */
1898     function safeTransferFrom(
1899         address from,
1900         address to,
1901         uint256 tokenId
1902     ) public payable virtual override {
1903         safeTransferFrom(from, to, tokenId, '');
1904     }
1905 
1906     /**
1907      * @dev Safely transfers `tokenId` token from `from` to `to`.
1908      *
1909      * Requirements:
1910      *
1911      * - `from` cannot be the zero address.
1912      * - `to` cannot be the zero address.
1913      * - `tokenId` token must exist and be owned by `from`.
1914      * - If the caller is not `from`, it must be approved to move this token
1915      * by either {approve} or {setApprovalForAll}.
1916      * - If `to` refers to a smart contract, it must implement
1917      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1918      *
1919      * Emits a {Transfer} event.
1920      */
1921     function safeTransferFrom(
1922         address from,
1923         address to,
1924         uint256 tokenId,
1925         bytes memory _data
1926     ) public payable virtual override {
1927         transferFrom(from, to, tokenId);
1928         if (to.code.length != 0)
1929             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1930                 revert TransferToNonERC721ReceiverImplementer();
1931             }
1932     }
1933 
1934     /**
1935      * @dev Hook that is called before a set of serially-ordered token IDs
1936      * are about to be transferred. This includes minting.
1937      * And also called before burning one token.
1938      *
1939      * `startTokenId` - the first token ID to be transferred.
1940      * `quantity` - the amount to be transferred.
1941      *
1942      * Calling conditions:
1943      *
1944      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1945      * transferred to `to`.
1946      * - When `from` is zero, `tokenId` will be minted for `to`.
1947      * - When `to` is zero, `tokenId` will be burned by `from`.
1948      * - `from` and `to` are never both zero.
1949      */
1950     function _beforeTokenTransfers(
1951         address from,
1952         address to,
1953         uint256 startTokenId,
1954         uint256 quantity
1955     ) internal virtual {}
1956 
1957     /**
1958      * @dev Hook that is called after a set of serially-ordered token IDs
1959      * have been transferred. This includes minting.
1960      * And also called after one token has been burned.
1961      *
1962      * `startTokenId` - the first token ID to be transferred.
1963      * `quantity` - the amount to be transferred.
1964      *
1965      * Calling conditions:
1966      *
1967      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1968      * transferred to `to`.
1969      * - When `from` is zero, `tokenId` has been minted for `to`.
1970      * - When `to` is zero, `tokenId` has been burned by `from`.
1971      * - `from` and `to` are never both zero.
1972      */
1973     function _afterTokenTransfers(
1974         address from,
1975         address to,
1976         uint256 startTokenId,
1977         uint256 quantity
1978     ) internal virtual {}
1979 
1980     /**
1981      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1982      *
1983      * `from` - Previous owner of the given token ID.
1984      * `to` - Target address that will receive the token.
1985      * `tokenId` - Token ID to be transferred.
1986      * `_data` - Optional data to send along with the call.
1987      *
1988      * Returns whether the call correctly returned the expected magic value.
1989      */
1990     function _checkContractOnERC721Received(
1991         address from,
1992         address to,
1993         uint256 tokenId,
1994         bytes memory _data
1995     ) private returns (bool) {
1996         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1997             bytes4 retval
1998         ) {
1999             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2000         } catch (bytes memory reason) {
2001             if (reason.length == 0) {
2002                 revert TransferToNonERC721ReceiverImplementer();
2003             } else {
2004                 assembly {
2005                     revert(add(32, reason), mload(reason))
2006                 }
2007             }
2008         }
2009     }
2010 
2011     // =============================================================
2012     //                        MINT OPERATIONS
2013     // =============================================================
2014 
2015     /**
2016      * @dev Mints `quantity` tokens and transfers them to `to`.
2017      *
2018      * Requirements:
2019      *
2020      * - `to` cannot be the zero address.
2021      * - `quantity` must be greater than 0.
2022      *
2023      * Emits a {Transfer} event for each mint.
2024      */
2025     function _mint(address to, uint256 quantity) internal virtual {
2026         uint256 startTokenId = _currentIndex;
2027         if (quantity == 0) revert MintZeroQuantity();
2028 
2029         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2030 
2031         // Overflows are incredibly unrealistic.
2032         // `balance` and `numberMinted` have a maximum limit of 2**64.
2033         // `tokenId` has a maximum limit of 2**256.
2034         unchecked {
2035             // Updates:
2036             // - `balance += quantity`.
2037             // - `numberMinted += quantity`.
2038             //
2039             // We can directly add to the `balance` and `numberMinted`.
2040             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2041 
2042             // Updates:
2043             // - `address` to the owner.
2044             // - `startTimestamp` to the timestamp of minting.
2045             // - `burned` to `false`.
2046             // - `nextInitialized` to `quantity == 1`.
2047             _packedOwnerships[startTokenId] = _packOwnershipData(
2048                 to,
2049                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2050             );
2051 
2052             uint256 toMasked;
2053             uint256 end = startTokenId + quantity;
2054 
2055             // Use assembly to loop and emit the `Transfer` event for gas savings.
2056             // The duplicated `log4` removes an extra check and reduces stack juggling.
2057             // The assembly, together with the surrounding Solidity code, have been
2058             // delicately arranged to nudge the compiler into producing optimized opcodes.
2059             assembly {
2060                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2061                 toMasked := and(to, _BITMASK_ADDRESS)
2062                 // Emit the `Transfer` event.
2063                 log4(
2064                     0, // Start of data (0, since no data).
2065                     0, // End of data (0, since no data).
2066                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2067                     0, // `address(0)`.
2068                     toMasked, // `to`.
2069                     startTokenId // `tokenId`.
2070                 )
2071 
2072                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2073                 // that overflows uint256 will make the loop run out of gas.
2074                 // The compiler will optimize the `iszero` away for performance.
2075                 for {
2076                     let tokenId := add(startTokenId, 1)
2077                 } iszero(eq(tokenId, end)) {
2078                     tokenId := add(tokenId, 1)
2079                 } {
2080                     // Emit the `Transfer` event. Similar to above.
2081                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2082                 }
2083             }
2084             if (toMasked == 0) revert MintToZeroAddress();
2085 
2086             _currentIndex = end;
2087         }
2088         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2089     }
2090 
2091     /**
2092      * @dev Mints `quantity` tokens and transfers them to `to`.
2093      *
2094      * This function is intended for efficient minting only during contract creation.
2095      *
2096      * It emits only one {ConsecutiveTransfer} as defined in
2097      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2098      * instead of a sequence of {Transfer} event(s).
2099      *
2100      * Calling this function outside of contract creation WILL make your contract
2101      * non-compliant with the ERC721 standard.
2102      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2103      * {ConsecutiveTransfer} event is only permissible during contract creation.
2104      *
2105      * Requirements:
2106      *
2107      * - `to` cannot be the zero address.
2108      * - `quantity` must be greater than 0.
2109      *
2110      * Emits a {ConsecutiveTransfer} event.
2111      */
2112     function _mintERC2309(address to, uint256 quantity) internal virtual {
2113         uint256 startTokenId = _currentIndex;
2114         if (to == address(0)) revert MintToZeroAddress();
2115         if (quantity == 0) revert MintZeroQuantity();
2116         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2117 
2118         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2119 
2120         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2121         unchecked {
2122             // Updates:
2123             // - `balance += quantity`.
2124             // - `numberMinted += quantity`.
2125             //
2126             // We can directly add to the `balance` and `numberMinted`.
2127             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2128 
2129             // Updates:
2130             // - `address` to the owner.
2131             // - `startTimestamp` to the timestamp of minting.
2132             // - `burned` to `false`.
2133             // - `nextInitialized` to `quantity == 1`.
2134             _packedOwnerships[startTokenId] = _packOwnershipData(
2135                 to,
2136                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2137             );
2138 
2139             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2140 
2141             _currentIndex = startTokenId + quantity;
2142         }
2143         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2144     }
2145 
2146     /**
2147      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2148      *
2149      * Requirements:
2150      *
2151      * - If `to` refers to a smart contract, it must implement
2152      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2153      * - `quantity` must be greater than 0.
2154      *
2155      * See {_mint}.
2156      *
2157      * Emits a {Transfer} event for each mint.
2158      */
2159     function _safeMint(
2160         address to,
2161         uint256 quantity,
2162         bytes memory _data
2163     ) internal virtual {
2164         _mint(to, quantity);
2165 
2166         unchecked {
2167             if (to.code.length != 0) {
2168                 uint256 end = _currentIndex;
2169                 uint256 index = end - quantity;
2170                 do {
2171                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2172                         revert TransferToNonERC721ReceiverImplementer();
2173                     }
2174                 } while (index < end);
2175                 // Reentrancy protection.
2176                 if (_currentIndex != end) revert();
2177             }
2178         }
2179     }
2180 
2181     /**
2182      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2183      */
2184     function _safeMint(address to, uint256 quantity) internal virtual {
2185         _safeMint(to, quantity, '');
2186     }
2187 
2188     // =============================================================
2189     //                        BURN OPERATIONS
2190     // =============================================================
2191 
2192     /**
2193      * @dev Equivalent to `_burn(tokenId, false)`.
2194      */
2195     function _burn(uint256 tokenId) internal virtual {
2196         _burn(tokenId, false);
2197     }
2198 
2199     /**
2200      * @dev Destroys `tokenId`.
2201      * The approval is cleared when the token is burned.
2202      *
2203      * Requirements:
2204      *
2205      * - `tokenId` must exist.
2206      *
2207      * Emits a {Transfer} event.
2208      */
2209     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2210         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2211 
2212         address from = address(uint160(prevOwnershipPacked));
2213 
2214         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2215 
2216         if (approvalCheck) {
2217             // The nested ifs save around 20+ gas over a compound boolean condition.
2218             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2219                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2220         }
2221 
2222         _beforeTokenTransfers(from, address(0), tokenId, 1);
2223 
2224         // Clear approvals from the previous owner.
2225         assembly {
2226             if approvedAddress {
2227                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2228                 sstore(approvedAddressSlot, 0)
2229             }
2230         }
2231 
2232         // Underflow of the sender's balance is impossible because we check for
2233         // ownership above and the recipient's balance can't realistically overflow.
2234         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2235         unchecked {
2236             // Updates:
2237             // - `balance -= 1`.
2238             // - `numberBurned += 1`.
2239             //
2240             // We can directly decrement the balance, and increment the number burned.
2241             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2242             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2243 
2244             // Updates:
2245             // - `address` to the last owner.
2246             // - `startTimestamp` to the timestamp of burning.
2247             // - `burned` to `true`.
2248             // - `nextInitialized` to `true`.
2249             _packedOwnerships[tokenId] = _packOwnershipData(
2250                 from,
2251                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2252             );
2253 
2254             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2255             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2256                 uint256 nextTokenId = tokenId + 1;
2257                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2258                 if (_packedOwnerships[nextTokenId] == 0) {
2259                     // If the next slot is within bounds.
2260                     if (nextTokenId != _currentIndex) {
2261                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2262                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2263                     }
2264                 }
2265             }
2266         }
2267 
2268         emit Transfer(from, address(0), tokenId);
2269         _afterTokenTransfers(from, address(0), tokenId, 1);
2270 
2271         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2272         unchecked {
2273             _burnCounter++;
2274         }
2275     }
2276 
2277     // =============================================================
2278     //                     EXTRA DATA OPERATIONS
2279     // =============================================================
2280 
2281     /**
2282      * @dev Directly sets the extra data for the ownership data `index`.
2283      */
2284     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2285         uint256 packed = _packedOwnerships[index];
2286         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2287         uint256 extraDataCasted;
2288         // Cast `extraData` with assembly to avoid redundant masking.
2289         assembly {
2290             extraDataCasted := extraData
2291         }
2292         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2293         _packedOwnerships[index] = packed;
2294     }
2295 
2296     /**
2297      * @dev Called during each token transfer to set the 24bit `extraData` field.
2298      * Intended to be overridden by the cosumer contract.
2299      *
2300      * `previousExtraData` - the value of `extraData` before transfer.
2301      *
2302      * Calling conditions:
2303      *
2304      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2305      * transferred to `to`.
2306      * - When `from` is zero, `tokenId` will be minted for `to`.
2307      * - When `to` is zero, `tokenId` will be burned by `from`.
2308      * - `from` and `to` are never both zero.
2309      */
2310     function _extraData(
2311         address from,
2312         address to,
2313         uint24 previousExtraData
2314     ) internal view virtual returns (uint24) {}
2315 
2316     /**
2317      * @dev Returns the next extra data for the packed ownership data.
2318      * The returned result is shifted into position.
2319      */
2320     function _nextExtraData(
2321         address from,
2322         address to,
2323         uint256 prevOwnershipPacked
2324     ) private view returns (uint256) {
2325         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2326         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2327     }
2328 
2329     // =============================================================
2330     //                       OTHER OPERATIONS
2331     // =============================================================
2332 
2333     /**
2334      * @dev Returns the message sender (defaults to `msg.sender`).
2335      *
2336      * If you are writing GSN compatible contracts, you need to override this function.
2337      */
2338     function _msgSenderERC721A() internal view virtual returns (address) {
2339         return msg.sender;
2340     }
2341 
2342     /**
2343      * @dev Converts a uint256 to its ASCII string decimal representation.
2344      */
2345     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2346         assembly {
2347             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2348             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2349             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2350             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2351             let m := add(mload(0x40), 0xa0)
2352             // Update the free memory pointer to allocate.
2353             mstore(0x40, m)
2354             // Assign the `str` to the end.
2355             str := sub(m, 0x20)
2356             // Zeroize the slot after the string.
2357             mstore(str, 0)
2358 
2359             // Cache the end of the memory to calculate the length later.
2360             let end := str
2361 
2362             // We write the string from rightmost digit to leftmost digit.
2363             // The following is essentially a do-while loop that also handles the zero case.
2364             // prettier-ignore
2365             for { let temp := value } 1 {} {
2366                 str := sub(str, 1)
2367                 // Write the character to the pointer.
2368                 // The ASCII index of the '0' character is 48.
2369                 mstore8(str, add(48, mod(temp, 10)))
2370                 // Keep dividing `temp` until zero.
2371                 temp := div(temp, 10)
2372                 // prettier-ignore
2373                 if iszero(temp) { break }
2374             }
2375 
2376             let length := sub(end, str)
2377             // Move the pointer 32 bytes leftwards to make room for the length.
2378             str := sub(str, 0x20)
2379             // Store the length.
2380             mstore(str, length)
2381         }
2382     }
2383 }
2384 
2385 // File: contracts/bb.sol
2386 
2387 
2388 
2389 pragma solidity ^0.8.17;
2390 
2391 
2392 
2393 
2394 
2395 
2396 contract BrokeBeaglez is ERC721A, DefaultOperatorFilterer, Ownable{
2397 
2398     using Strings for uint256;
2399 
2400     uint256 public constant MAX_SUPPLY = 3333;
2401     bool public _isSaleActive = false; 
2402     bool public _WLActive = false; 
2403     bool public _revealed = true;     
2404     uint256 public WLPrice = 0 ether; 
2405     uint256 public WLLimit = 333;
2406     uint256 public WLNum = 2;
2407     uint256 public WLCount = 0;
2408     uint256 public mintPrice = 0.001 ether; 
2409     uint256 public maxBalance = 5; 
2410     uint256 public maxMint = 5; 
2411     string baseURI;
2412     string public notRevealedUri;
2413     string public baseExtension = ".json";
2414     bytes32 public merkleRoot;
2415     mapping(address => bool) public _mintedAddress; 
2416     mapping(uint256 => string) private _tokenURIs;
2417 
2418     constructor(string memory initBaseURI, string memory initNotRevealedUri) 
2419         ERC721A("BrokeBeaglez", "BB") 
2420     {
2421         setBaseURI(initBaseURI);
2422         setNotRevealedURI(initNotRevealedUri);
2423     }
2424 
2425     function mintWL(bytes32[] calldata proof) public payable {
2426         require(_WLActive, "Whitelist must be active to mint NFT");
2427         require(
2428             balanceOf(msg.sender)  + WLNum <= maxBalance, 
2429             "Sale would exceed max balance"
2430         );
2431         require(
2432             WLCount + WLNum <= WLLimit,
2433             "Sale would exceed max WL supply"
2434         );
2435         require(
2436             totalSupply() + WLNum <= MAX_SUPPLY,
2437             "Sale would exceed max supply"
2438         );
2439         require(!_mintedAddress[msg.sender], "Already minted!"); 
2440         require(MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "Invalid merkle proof");   
2441 
2442         _safeMint(msg.sender, WLNum); 
2443         _mintedAddress[msg.sender] = true;
2444         WLCount = WLCount + 2;
2445     }
2446 
2447     function mintPublic(uint256 tokenQuantity) public payable {
2448         require(
2449             totalSupply() + tokenQuantity <= MAX_SUPPLY,
2450             "Sale would exceed max supply"
2451         );
2452         require(_isSaleActive, "Sale must be active to mint NFT");
2453         require(tokenQuantity <= maxMint, "Mint too many tokens at a time");
2454         require(
2455             balanceOf(msg.sender)  + tokenQuantity <= maxBalance, 
2456             "Sale would exceed max balance"
2457         );
2458         require(tokenQuantity * mintPrice <= msg.value, "Not enough ether");
2459 
2460         _safeMint(msg.sender, tokenQuantity);
2461     }
2462 
2463     function tokenURI(uint256 tokenId)
2464         public
2465         view
2466         virtual
2467         override
2468         returns (string memory)
2469     {
2470         require(
2471             _exists(tokenId),
2472             "URI query for nonexistent token"
2473         );
2474 
2475         if (_revealed == false) {
2476             return notRevealedUri;
2477         }
2478 
2479         string memory _tokenURI = _tokenURIs[tokenId];
2480         string memory base = _baseURI();
2481 
2482         if (bytes(base).length == 0) {
2483             return _tokenURI;
2484         }
2485 
2486         if (bytes(_tokenURI).length > 0) {
2487             return string(abi.encodePacked(base, _tokenURI));
2488         }
2489 
2490         return
2491             string(abi.encodePacked(base, tokenId.toString(), baseExtension));
2492     }
2493 
2494     function setRoot(bytes32 _root) public onlyOwner {
2495         merkleRoot = _root;
2496     }
2497 
2498     function _baseURI() internal view virtual override returns (string memory) {
2499         return baseURI;
2500     }
2501 
2502     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2503         baseURI = _newBaseURI;
2504     }
2505 
2506     function flipSaleActive() public onlyOwner {
2507         _isSaleActive = !_isSaleActive;
2508     }
2509 
2510     function flipWLActive() public onlyOwner {
2511         _WLActive = !_WLActive;
2512     }
2513 
2514     function flipReveal() public onlyOwner {
2515         _revealed = !_revealed;
2516     }
2517 
2518     function mintOwner() public onlyOwner {
2519         _safeMint(msg.sender, 1);
2520     }
2521 
2522     function setMintPrice(uint256 _mintPrice) public onlyOwner {
2523         mintPrice = _mintPrice;
2524     }
2525 
2526     function setWLPrice(uint256 _WLPrice) public onlyOwner {
2527         WLPrice = _WLPrice;
2528     }
2529 
2530     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2531         notRevealedUri = _notRevealedURI;
2532     }
2533 
2534     function setBaseExtension(string memory _newBaseExtension)
2535         public
2536         onlyOwner
2537     {
2538         baseExtension = _newBaseExtension;
2539     }
2540 
2541     function setMaxBalance(uint256 _maxBalance) public onlyOwner {
2542         maxBalance = _maxBalance;
2543     }
2544 
2545     function setMaxMint(uint256 _maxMint) public onlyOwner {
2546         maxMint = _maxMint;
2547     }
2548 
2549     function withdraw(address to) public onlyOwner {
2550         uint256 balance = address(this).balance;
2551         payable(to).transfer(balance);
2552     }
2553 
2554     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2555         super.setApprovalForAll(operator, approved);
2556     }
2557 
2558     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2559         super.approve(operator, tokenId);
2560     }
2561 
2562     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2563         super.transferFrom(from, to, tokenId);
2564     }
2565 
2566     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2567         super.safeTransferFrom(from, to, tokenId);
2568     }
2569 
2570     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2571         public payable
2572         override
2573         onlyAllowedOperator(from){
2574         super.safeTransferFrom(from, to, tokenId, data);
2575     }
2576 
2577 }