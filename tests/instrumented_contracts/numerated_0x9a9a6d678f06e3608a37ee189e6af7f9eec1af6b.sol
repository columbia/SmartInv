1 // File: contracts/operator-filter/lib/Constants.sol
2 
3 
4 pragma solidity ^0.8.17;
5 
6 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
7 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
8 
9 // File: contracts/operator-filter/IOperatorFilterRegistry.sol
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
151 // File: contracts/operator-filter/OperatorFilterer.sol
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
230 // File: contracts/operator-filter/DefaultOperatorFilterer.sol
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
475 // File: @openzeppelin/contracts@4.8.0/access/IAccessControl.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev External interface of AccessControl declared to support ERC165 detection.
484  */
485 interface IAccessControl {
486     /**
487      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
488      *
489      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
490      * {RoleAdminChanged} not being emitted signaling this.
491      *
492      * _Available since v3.1._
493      */
494     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
495 
496     /**
497      * @dev Emitted when `account` is granted `role`.
498      *
499      * `sender` is the account that originated the contract call, an admin role
500      * bearer except when using {AccessControl-_setupRole}.
501      */
502     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
503 
504     /**
505      * @dev Emitted when `account` is revoked `role`.
506      *
507      * `sender` is the account that originated the contract call:
508      *   - if using `revokeRole`, it is the admin role bearer
509      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
510      */
511     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
512 
513     /**
514      * @dev Returns `true` if `account` has been granted `role`.
515      */
516     function hasRole(bytes32 role, address account) external view returns (bool);
517 
518     /**
519      * @dev Returns the admin role that controls `role`. See {grantRole} and
520      * {revokeRole}.
521      *
522      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
523      */
524     function getRoleAdmin(bytes32 role) external view returns (bytes32);
525 
526     /**
527      * @dev Grants `role` to `account`.
528      *
529      * If `account` had not been already granted `role`, emits a {RoleGranted}
530      * event.
531      *
532      * Requirements:
533      *
534      * - the caller must have ``role``'s admin role.
535      */
536     function grantRole(bytes32 role, address account) external;
537 
538     /**
539      * @dev Revokes `role` from `account`.
540      *
541      * If `account` had been granted `role`, emits a {RoleRevoked} event.
542      *
543      * Requirements:
544      *
545      * - the caller must have ``role``'s admin role.
546      */
547     function revokeRole(bytes32 role, address account) external;
548 
549     /**
550      * @dev Revokes `role` from the calling account.
551      *
552      * Roles are often managed via {grantRole} and {revokeRole}: this function's
553      * purpose is to provide a mechanism for accounts to lose their privileges
554      * if they are compromised (such as when a trusted device is misplaced).
555      *
556      * If the calling account had been granted `role`, emits a {RoleRevoked}
557      * event.
558      *
559      * Requirements:
560      *
561      * - the caller must be `account`.
562      */
563     function renounceRole(bytes32 role, address account) external;
564 }
565 
566 // File: @openzeppelin/contracts@4.8.0/utils/math/Math.sol
567 
568 
569 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @dev Standard math utilities missing in the Solidity language.
575  */
576 library Math {
577     enum Rounding {
578         Down, // Toward negative infinity
579         Up, // Toward infinity
580         Zero // Toward zero
581     }
582 
583     /**
584      * @dev Returns the largest of two numbers.
585      */
586     function max(uint256 a, uint256 b) internal pure returns (uint256) {
587         return a > b ? a : b;
588     }
589 
590     /**
591      * @dev Returns the smallest of two numbers.
592      */
593     function min(uint256 a, uint256 b) internal pure returns (uint256) {
594         return a < b ? a : b;
595     }
596 
597     /**
598      * @dev Returns the average of two numbers. The result is rounded towards
599      * zero.
600      */
601     function average(uint256 a, uint256 b) internal pure returns (uint256) {
602         // (a + b) / 2 can overflow.
603         return (a & b) + (a ^ b) / 2;
604     }
605 
606     /**
607      * @dev Returns the ceiling of the division of two numbers.
608      *
609      * This differs from standard division with `/` in that it rounds up instead
610      * of rounding down.
611      */
612     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
613         // (a + b - 1) / b can overflow on addition, so we distribute.
614         return a == 0 ? 0 : (a - 1) / b + 1;
615     }
616 
617     /**
618      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
619      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
620      * with further edits by Uniswap Labs also under MIT license.
621      */
622     function mulDiv(
623         uint256 x,
624         uint256 y,
625         uint256 denominator
626     ) internal pure returns (uint256 result) {
627         unchecked {
628             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
629             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
630             // variables such that product = prod1 * 2^256 + prod0.
631             uint256 prod0; // Least significant 256 bits of the product
632             uint256 prod1; // Most significant 256 bits of the product
633             assembly {
634                 let mm := mulmod(x, y, not(0))
635                 prod0 := mul(x, y)
636                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
637             }
638 
639             // Handle non-overflow cases, 256 by 256 division.
640             if (prod1 == 0) {
641                 return prod0 / denominator;
642             }
643 
644             // Make sure the result is less than 2^256. Also prevents denominator == 0.
645             require(denominator > prod1);
646 
647             ///////////////////////////////////////////////
648             // 512 by 256 division.
649             ///////////////////////////////////////////////
650 
651             // Make division exact by subtracting the remainder from [prod1 prod0].
652             uint256 remainder;
653             assembly {
654                 // Compute remainder using mulmod.
655                 remainder := mulmod(x, y, denominator)
656 
657                 // Subtract 256 bit number from 512 bit number.
658                 prod1 := sub(prod1, gt(remainder, prod0))
659                 prod0 := sub(prod0, remainder)
660             }
661 
662             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
663             // See https://cs.stackexchange.com/q/138556/92363.
664 
665             // Does not overflow because the denominator cannot be zero at this stage in the function.
666             uint256 twos = denominator & (~denominator + 1);
667             assembly {
668                 // Divide denominator by twos.
669                 denominator := div(denominator, twos)
670 
671                 // Divide [prod1 prod0] by twos.
672                 prod0 := div(prod0, twos)
673 
674                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
675                 twos := add(div(sub(0, twos), twos), 1)
676             }
677 
678             // Shift in bits from prod1 into prod0.
679             prod0 |= prod1 * twos;
680 
681             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
682             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
683             // four bits. That is, denominator * inv = 1 mod 2^4.
684             uint256 inverse = (3 * denominator) ^ 2;
685 
686             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
687             // in modular arithmetic, doubling the correct bits in each step.
688             inverse *= 2 - denominator * inverse; // inverse mod 2^8
689             inverse *= 2 - denominator * inverse; // inverse mod 2^16
690             inverse *= 2 - denominator * inverse; // inverse mod 2^32
691             inverse *= 2 - denominator * inverse; // inverse mod 2^64
692             inverse *= 2 - denominator * inverse; // inverse mod 2^128
693             inverse *= 2 - denominator * inverse; // inverse mod 2^256
694 
695             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
696             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
697             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
698             // is no longer required.
699             result = prod0 * inverse;
700             return result;
701         }
702     }
703 
704     /**
705      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
706      */
707     function mulDiv(
708         uint256 x,
709         uint256 y,
710         uint256 denominator,
711         Rounding rounding
712     ) internal pure returns (uint256) {
713         uint256 result = mulDiv(x, y, denominator);
714         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
715             result += 1;
716         }
717         return result;
718     }
719 
720     /**
721      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
722      *
723      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
724      */
725     function sqrt(uint256 a) internal pure returns (uint256) {
726         if (a == 0) {
727             return 0;
728         }
729 
730         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
731         //
732         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
733         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
734         //
735         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
736         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
737         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
738         //
739         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
740         uint256 result = 1 << (log2(a) >> 1);
741 
742         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
743         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
744         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
745         // into the expected uint128 result.
746         unchecked {
747             result = (result + a / result) >> 1;
748             result = (result + a / result) >> 1;
749             result = (result + a / result) >> 1;
750             result = (result + a / result) >> 1;
751             result = (result + a / result) >> 1;
752             result = (result + a / result) >> 1;
753             result = (result + a / result) >> 1;
754             return min(result, a / result);
755         }
756     }
757 
758     /**
759      * @notice Calculates sqrt(a), following the selected rounding direction.
760      */
761     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
762         unchecked {
763             uint256 result = sqrt(a);
764             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
765         }
766     }
767 
768     /**
769      * @dev Return the log in base 2, rounded down, of a positive value.
770      * Returns 0 if given 0.
771      */
772     function log2(uint256 value) internal pure returns (uint256) {
773         uint256 result = 0;
774         unchecked {
775             if (value >> 128 > 0) {
776                 value >>= 128;
777                 result += 128;
778             }
779             if (value >> 64 > 0) {
780                 value >>= 64;
781                 result += 64;
782             }
783             if (value >> 32 > 0) {
784                 value >>= 32;
785                 result += 32;
786             }
787             if (value >> 16 > 0) {
788                 value >>= 16;
789                 result += 16;
790             }
791             if (value >> 8 > 0) {
792                 value >>= 8;
793                 result += 8;
794             }
795             if (value >> 4 > 0) {
796                 value >>= 4;
797                 result += 4;
798             }
799             if (value >> 2 > 0) {
800                 value >>= 2;
801                 result += 2;
802             }
803             if (value >> 1 > 0) {
804                 result += 1;
805             }
806         }
807         return result;
808     }
809 
810     /**
811      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
812      * Returns 0 if given 0.
813      */
814     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
815         unchecked {
816             uint256 result = log2(value);
817             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
818         }
819     }
820 
821     /**
822      * @dev Return the log in base 10, rounded down, of a positive value.
823      * Returns 0 if given 0.
824      */
825     function log10(uint256 value) internal pure returns (uint256) {
826         uint256 result = 0;
827         unchecked {
828             if (value >= 10**64) {
829                 value /= 10**64;
830                 result += 64;
831             }
832             if (value >= 10**32) {
833                 value /= 10**32;
834                 result += 32;
835             }
836             if (value >= 10**16) {
837                 value /= 10**16;
838                 result += 16;
839             }
840             if (value >= 10**8) {
841                 value /= 10**8;
842                 result += 8;
843             }
844             if (value >= 10**4) {
845                 value /= 10**4;
846                 result += 4;
847             }
848             if (value >= 10**2) {
849                 value /= 10**2;
850                 result += 2;
851             }
852             if (value >= 10**1) {
853                 result += 1;
854             }
855         }
856         return result;
857     }
858 
859     /**
860      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
861      * Returns 0 if given 0.
862      */
863     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
864         unchecked {
865             uint256 result = log10(value);
866             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
867         }
868     }
869 
870     /**
871      * @dev Return the log in base 256, rounded down, of a positive value.
872      * Returns 0 if given 0.
873      *
874      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
875      */
876     function log256(uint256 value) internal pure returns (uint256) {
877         uint256 result = 0;
878         unchecked {
879             if (value >> 128 > 0) {
880                 value >>= 128;
881                 result += 16;
882             }
883             if (value >> 64 > 0) {
884                 value >>= 64;
885                 result += 8;
886             }
887             if (value >> 32 > 0) {
888                 value >>= 32;
889                 result += 4;
890             }
891             if (value >> 16 > 0) {
892                 value >>= 16;
893                 result += 2;
894             }
895             if (value >> 8 > 0) {
896                 result += 1;
897             }
898         }
899         return result;
900     }
901 
902     /**
903      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
904      * Returns 0 if given 0.
905      */
906     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
907         unchecked {
908             uint256 result = log256(value);
909             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
910         }
911     }
912 }
913 
914 // File: @openzeppelin/contracts@4.8.0/utils/Strings.sol
915 
916 
917 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
918 
919 pragma solidity ^0.8.0;
920 
921 
922 /**
923  * @dev String operations.
924  */
925 library Strings {
926     bytes16 private constant _SYMBOLS = "0123456789abcdef";
927     uint8 private constant _ADDRESS_LENGTH = 20;
928 
929     /**
930      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
931      */
932     function toString(uint256 value) internal pure returns (string memory) {
933         unchecked {
934             uint256 length = Math.log10(value) + 1;
935             string memory buffer = new string(length);
936             uint256 ptr;
937             /// @solidity memory-safe-assembly
938             assembly {
939                 ptr := add(buffer, add(32, length))
940             }
941             while (true) {
942                 ptr--;
943                 /// @solidity memory-safe-assembly
944                 assembly {
945                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
946                 }
947                 value /= 10;
948                 if (value == 0) break;
949             }
950             return buffer;
951         }
952     }
953 
954     /**
955      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
956      */
957     function toHexString(uint256 value) internal pure returns (string memory) {
958         unchecked {
959             return toHexString(value, Math.log256(value) + 1);
960         }
961     }
962 
963     /**
964      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
965      */
966     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
967         bytes memory buffer = new bytes(2 * length + 2);
968         buffer[0] = "0";
969         buffer[1] = "x";
970         for (uint256 i = 2 * length + 1; i > 1; --i) {
971             buffer[i] = _SYMBOLS[value & 0xf];
972             value >>= 4;
973         }
974         require(value == 0, "Strings: hex length insufficient");
975         return string(buffer);
976     }
977 
978     /**
979      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
980      */
981     function toHexString(address addr) internal pure returns (string memory) {
982         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
983     }
984 }
985 
986 // File: @openzeppelin/contracts@4.8.0/utils/Context.sol
987 
988 
989 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
990 
991 pragma solidity ^0.8.0;
992 
993 /**
994  * @dev Provides information about the current execution context, including the
995  * sender of the transaction and its data. While these are generally available
996  * via msg.sender and msg.data, they should not be accessed in such a direct
997  * manner, since when dealing with meta-transactions the account sending and
998  * paying for execution may not be the actual sender (as far as an application
999  * is concerned).
1000  *
1001  * This contract is only required for intermediate, library-like contracts.
1002  */
1003 abstract contract Context {
1004     function _msgSender() internal view virtual returns (address) {
1005         return msg.sender;
1006     }
1007 
1008     function _msgData() internal view virtual returns (bytes calldata) {
1009         return msg.data;
1010     }
1011 }
1012 
1013 // File: @openzeppelin/contracts@4.8.0/utils/Address.sol
1014 
1015 
1016 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1017 
1018 pragma solidity ^0.8.1;
1019 
1020 /**
1021  * @dev Collection of functions related to the address type
1022  */
1023 library Address {
1024     /**
1025      * @dev Returns true if `account` is a contract.
1026      *
1027      * [IMPORTANT]
1028      * ====
1029      * It is unsafe to assume that an address for which this function returns
1030      * false is an externally-owned account (EOA) and not a contract.
1031      *
1032      * Among others, `isContract` will return false for the following
1033      * types of addresses:
1034      *
1035      *  - an externally-owned account
1036      *  - a contract in construction
1037      *  - an address where a contract will be created
1038      *  - an address where a contract lived, but was destroyed
1039      * ====
1040      *
1041      * [IMPORTANT]
1042      * ====
1043      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1044      *
1045      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1046      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1047      * constructor.
1048      * ====
1049      */
1050     function isContract(address account) internal view returns (bool) {
1051         // This method relies on extcodesize/address.code.length, which returns 0
1052         // for contracts in construction, since the code is only stored at the end
1053         // of the constructor execution.
1054 
1055         return account.code.length > 0;
1056     }
1057 
1058     /**
1059      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1060      * `recipient`, forwarding all available gas and reverting on errors.
1061      *
1062      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1063      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1064      * imposed by `transfer`, making them unable to receive funds via
1065      * `transfer`. {sendValue} removes this limitation.
1066      *
1067      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1068      *
1069      * IMPORTANT: because control is transferred to `recipient`, care must be
1070      * taken to not create reentrancy vulnerabilities. Consider using
1071      * {ReentrancyGuard} or the
1072      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1073      */
1074     function sendValue(address payable recipient, uint256 amount) internal {
1075         require(address(this).balance >= amount, "Address: insufficient balance");
1076 
1077         (bool success, ) = recipient.call{value: amount}("");
1078         require(success, "Address: unable to send value, recipient may have reverted");
1079     }
1080 
1081     /**
1082      * @dev Performs a Solidity function call using a low level `call`. A
1083      * plain `call` is an unsafe replacement for a function call: use this
1084      * function instead.
1085      *
1086      * If `target` reverts with a revert reason, it is bubbled up by this
1087      * function (like regular Solidity function calls).
1088      *
1089      * Returns the raw returned data. To convert to the expected return value,
1090      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1091      *
1092      * Requirements:
1093      *
1094      * - `target` must be a contract.
1095      * - calling `target` with `data` must not revert.
1096      *
1097      * _Available since v3.1._
1098      */
1099     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1100         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1101     }
1102 
1103     /**
1104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1105      * `errorMessage` as a fallback revert reason when `target` reverts.
1106      *
1107      * _Available since v3.1._
1108      */
1109     function functionCall(
1110         address target,
1111         bytes memory data,
1112         string memory errorMessage
1113     ) internal returns (bytes memory) {
1114         return functionCallWithValue(target, data, 0, errorMessage);
1115     }
1116 
1117     /**
1118      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1119      * but also transferring `value` wei to `target`.
1120      *
1121      * Requirements:
1122      *
1123      * - the calling contract must have an ETH balance of at least `value`.
1124      * - the called Solidity function must be `payable`.
1125      *
1126      * _Available since v3.1._
1127      */
1128     function functionCallWithValue(
1129         address target,
1130         bytes memory data,
1131         uint256 value
1132     ) internal returns (bytes memory) {
1133         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1134     }
1135 
1136     /**
1137      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1138      * with `errorMessage` as a fallback revert reason when `target` reverts.
1139      *
1140      * _Available since v3.1._
1141      */
1142     function functionCallWithValue(
1143         address target,
1144         bytes memory data,
1145         uint256 value,
1146         string memory errorMessage
1147     ) internal returns (bytes memory) {
1148         require(address(this).balance >= value, "Address: insufficient balance for call");
1149         (bool success, bytes memory returndata) = target.call{value: value}(data);
1150         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1151     }
1152 
1153     /**
1154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1155      * but performing a static call.
1156      *
1157      * _Available since v3.3._
1158      */
1159     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1160         return functionStaticCall(target, data, "Address: low-level static call failed");
1161     }
1162 
1163     /**
1164      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1165      * but performing a static call.
1166      *
1167      * _Available since v3.3._
1168      */
1169     function functionStaticCall(
1170         address target,
1171         bytes memory data,
1172         string memory errorMessage
1173     ) internal view returns (bytes memory) {
1174         (bool success, bytes memory returndata) = target.staticcall(data);
1175         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1176     }
1177 
1178     /**
1179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1180      * but performing a delegate call.
1181      *
1182      * _Available since v3.4._
1183      */
1184     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1185         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1186     }
1187 
1188     /**
1189      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1190      * but performing a delegate call.
1191      *
1192      * _Available since v3.4._
1193      */
1194     function functionDelegateCall(
1195         address target,
1196         bytes memory data,
1197         string memory errorMessage
1198     ) internal returns (bytes memory) {
1199         (bool success, bytes memory returndata) = target.delegatecall(data);
1200         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1201     }
1202 
1203     /**
1204      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1205      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1206      *
1207      * _Available since v4.8._
1208      */
1209     function verifyCallResultFromTarget(
1210         address target,
1211         bool success,
1212         bytes memory returndata,
1213         string memory errorMessage
1214     ) internal view returns (bytes memory) {
1215         if (success) {
1216             if (returndata.length == 0) {
1217                 // only check isContract if the call was successful and the return data is empty
1218                 // otherwise we already know that it was a contract
1219                 require(isContract(target), "Address: call to non-contract");
1220             }
1221             return returndata;
1222         } else {
1223             _revert(returndata, errorMessage);
1224         }
1225     }
1226 
1227     /**
1228      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1229      * revert reason or using the provided one.
1230      *
1231      * _Available since v4.3._
1232      */
1233     function verifyCallResult(
1234         bool success,
1235         bytes memory returndata,
1236         string memory errorMessage
1237     ) internal pure returns (bytes memory) {
1238         if (success) {
1239             return returndata;
1240         } else {
1241             _revert(returndata, errorMessage);
1242         }
1243     }
1244 
1245     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1246         // Look for revert reason and bubble it up if present
1247         if (returndata.length > 0) {
1248             // The easiest way to bubble the revert reason is using memory via assembly
1249             /// @solidity memory-safe-assembly
1250             assembly {
1251                 let returndata_size := mload(returndata)
1252                 revert(add(32, returndata), returndata_size)
1253             }
1254         } else {
1255             revert(errorMessage);
1256         }
1257     }
1258 }
1259 
1260 // File: @openzeppelin/contracts@4.8.0/token/ERC721/IERC721Receiver.sol
1261 
1262 
1263 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 /**
1268  * @title ERC721 token receiver interface
1269  * @dev Interface for any contract that wants to support safeTransfers
1270  * from ERC721 asset contracts.
1271  */
1272 interface IERC721Receiver {
1273     /**
1274      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1275      * by `operator` from `from`, this function is called.
1276      *
1277      * It must return its Solidity selector to confirm the token transfer.
1278      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1279      *
1280      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1281      */
1282     function onERC721Received(
1283         address operator,
1284         address from,
1285         uint256 tokenId,
1286         bytes calldata data
1287     ) external returns (bytes4);
1288 }
1289 
1290 // File: @openzeppelin/contracts@4.8.0/utils/introspection/IERC165.sol
1291 
1292 
1293 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1294 
1295 pragma solidity ^0.8.0;
1296 
1297 /**
1298  * @dev Interface of the ERC165 standard, as defined in the
1299  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1300  *
1301  * Implementers can declare support of contract interfaces, which can then be
1302  * queried by others ({ERC165Checker}).
1303  *
1304  * For an implementation, see {ERC165}.
1305  */
1306 interface IERC165 {
1307     /**
1308      * @dev Returns true if this contract implements the interface defined by
1309      * `interfaceId`. See the corresponding
1310      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1311      * to learn more about how these ids are created.
1312      *
1313      * This function call must use less than 30 000 gas.
1314      */
1315     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1316 }
1317 
1318 // File: @openzeppelin/contracts@4.8.0/token/ERC721/IERC721.sol
1319 
1320 
1321 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1322 
1323 pragma solidity ^0.8.0;
1324 
1325 
1326 /**
1327  * @dev Required interface of an ERC721 compliant contract.
1328  */
1329 interface IERC721 is IERC165 {
1330     /**
1331      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1332      */
1333     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1334 
1335     /**
1336      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1337      */
1338     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1339 
1340     /**
1341      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1342      */
1343     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1344 
1345     /**
1346      * @dev Returns the number of tokens in ``owner``'s account.
1347      */
1348     function balanceOf(address owner) external view returns (uint256 balance);
1349 
1350     /**
1351      * @dev Returns the owner of the `tokenId` token.
1352      *
1353      * Requirements:
1354      *
1355      * - `tokenId` must exist.
1356      */
1357     function ownerOf(uint256 tokenId) external view returns (address owner);
1358 
1359     /**
1360      * @dev Safely transfers `tokenId` token from `from` to `to`.
1361      *
1362      * Requirements:
1363      *
1364      * - `from` cannot be the zero address.
1365      * - `to` cannot be the zero address.
1366      * - `tokenId` token must exist and be owned by `from`.
1367      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1368      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1369      *
1370      * Emits a {Transfer} event.
1371      */
1372     function safeTransferFrom(
1373         address from,
1374         address to,
1375         uint256 tokenId,
1376         bytes calldata data
1377     ) external;
1378 
1379     /**
1380      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1381      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1382      *
1383      * Requirements:
1384      *
1385      * - `from` cannot be the zero address.
1386      * - `to` cannot be the zero address.
1387      * - `tokenId` token must exist and be owned by `from`.
1388      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1389      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1390      *
1391      * Emits a {Transfer} event.
1392      */
1393     function safeTransferFrom(
1394         address from,
1395         address to,
1396         uint256 tokenId
1397     ) external;
1398 
1399     /**
1400      * @dev Transfers `tokenId` token from `from` to `to`.
1401      *
1402      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1403      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1404      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1405      *
1406      * Requirements:
1407      *
1408      * - `from` cannot be the zero address.
1409      * - `to` cannot be the zero address.
1410      * - `tokenId` token must be owned by `from`.
1411      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1412      *
1413      * Emits a {Transfer} event.
1414      */
1415     function transferFrom(
1416         address from,
1417         address to,
1418         uint256 tokenId
1419     ) external;
1420 
1421     /**
1422      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1423      * The approval is cleared when the token is transferred.
1424      *
1425      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1426      *
1427      * Requirements:
1428      *
1429      * - The caller must own the token or be an approved operator.
1430      * - `tokenId` must exist.
1431      *
1432      * Emits an {Approval} event.
1433      */
1434     function approve(address to, uint256 tokenId) external;
1435 
1436     /**
1437      * @dev Approve or remove `operator` as an operator for the caller.
1438      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1439      *
1440      * Requirements:
1441      *
1442      * - The `operator` cannot be the caller.
1443      *
1444      * Emits an {ApprovalForAll} event.
1445      */
1446     function setApprovalForAll(address operator, bool _approved) external;
1447 
1448     /**
1449      * @dev Returns the account approved for `tokenId` token.
1450      *
1451      * Requirements:
1452      *
1453      * - `tokenId` must exist.
1454      */
1455     function getApproved(uint256 tokenId) external view returns (address operator);
1456 
1457     /**
1458      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1459      *
1460      * See {setApprovalForAll}
1461      */
1462     function isApprovedForAll(address owner, address operator) external view returns (bool);
1463 }
1464 
1465 // File: @openzeppelin/contracts@4.8.0/token/ERC721/extensions/IERC721Enumerable.sol
1466 
1467 
1468 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1469 
1470 pragma solidity ^0.8.0;
1471 
1472 
1473 /**
1474  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1475  * @dev See https://eips.ethereum.org/EIPS/eip-721
1476  */
1477 interface IERC721Enumerable is IERC721 {
1478     /**
1479      * @dev Returns the total amount of tokens stored by the contract.
1480      */
1481     function totalSupply() external view returns (uint256);
1482 
1483     /**
1484      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1485      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1486      */
1487     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1488 
1489     /**
1490      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1491      * Use along with {totalSupply} to enumerate all tokens.
1492      */
1493     function tokenByIndex(uint256 index) external view returns (uint256);
1494 }
1495 
1496 // File: @openzeppelin/contracts@4.8.0/token/ERC721/extensions/IERC721Metadata.sol
1497 
1498 
1499 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1500 
1501 pragma solidity ^0.8.0;
1502 
1503 
1504 /**
1505  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1506  * @dev See https://eips.ethereum.org/EIPS/eip-721
1507  */
1508 interface IERC721Metadata is IERC721 {
1509     /**
1510      * @dev Returns the token collection name.
1511      */
1512     function name() external view returns (string memory);
1513 
1514     /**
1515      * @dev Returns the token collection symbol.
1516      */
1517     function symbol() external view returns (string memory);
1518 
1519     /**
1520      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1521      */
1522     function tokenURI(uint256 tokenId) external view returns (string memory);
1523 }
1524 
1525 // File: @openzeppelin/contracts@4.8.0/utils/introspection/ERC165.sol
1526 
1527 
1528 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1529 
1530 pragma solidity ^0.8.0;
1531 
1532 
1533 /**
1534  * @dev Implementation of the {IERC165} interface.
1535  *
1536  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1537  * for the additional interface id that will be supported. For example:
1538  *
1539  * ```solidity
1540  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1541  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1542  * }
1543  * ```
1544  *
1545  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1546  */
1547 abstract contract ERC165 is IERC165 {
1548     /**
1549      * @dev See {IERC165-supportsInterface}.
1550      */
1551     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1552         return interfaceId == type(IERC165).interfaceId;
1553     }
1554 }
1555 
1556 // File: @openzeppelin/contracts@4.8.0/access/AccessControl.sol
1557 
1558 
1559 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
1560 
1561 pragma solidity ^0.8.0;
1562 
1563 
1564 
1565 
1566 
1567 /**
1568  * @dev Contract module that allows children to implement role-based access
1569  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1570  * members except through off-chain means by accessing the contract event logs. Some
1571  * applications may benefit from on-chain enumerability, for those cases see
1572  * {AccessControlEnumerable}.
1573  *
1574  * Roles are referred to by their `bytes32` identifier. These should be exposed
1575  * in the external API and be unique. The best way to achieve this is by
1576  * using `public constant` hash digests:
1577  *
1578  * ```
1579  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1580  * ```
1581  *
1582  * Roles can be used to represent a set of permissions. To restrict access to a
1583  * function call, use {hasRole}:
1584  *
1585  * ```
1586  * function foo() public {
1587  *     require(hasRole(MY_ROLE, msg.sender));
1588  *     ...
1589  * }
1590  * ```
1591  *
1592  * Roles can be granted and revoked dynamically via the {grantRole} and
1593  * {revokeRole} functions. Each role has an associated admin role, and only
1594  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1595  *
1596  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1597  * that only accounts with this role will be able to grant or revoke other
1598  * roles. More complex role relationships can be created by using
1599  * {_setRoleAdmin}.
1600  *
1601  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1602  * grant and revoke this role. Extra precautions should be taken to secure
1603  * accounts that have been granted it.
1604  */
1605 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1606     struct RoleData {
1607         mapping(address => bool) members;
1608         bytes32 adminRole;
1609     }
1610 
1611     mapping(bytes32 => RoleData) private _roles;
1612 
1613     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1614 
1615     /**
1616      * @dev Modifier that checks that an account has a specific role. Reverts
1617      * with a standardized message including the required role.
1618      *
1619      * The format of the revert reason is given by the following regular expression:
1620      *
1621      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1622      *
1623      * _Available since v4.1._
1624      */
1625     modifier onlyRole(bytes32 role) {
1626         _checkRole(role);
1627         _;
1628     }
1629 
1630     /**
1631      * @dev See {IERC165-supportsInterface}.
1632      */
1633     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1634         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1635     }
1636 
1637     /**
1638      * @dev Returns `true` if `account` has been granted `role`.
1639      */
1640     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1641         return _roles[role].members[account];
1642     }
1643 
1644     /**
1645      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1646      * Overriding this function changes the behavior of the {onlyRole} modifier.
1647      *
1648      * Format of the revert message is described in {_checkRole}.
1649      *
1650      * _Available since v4.6._
1651      */
1652     function _checkRole(bytes32 role) internal view virtual {
1653         _checkRole(role, _msgSender());
1654     }
1655 
1656     /**
1657      * @dev Revert with a standard message if `account` is missing `role`.
1658      *
1659      * The format of the revert reason is given by the following regular expression:
1660      *
1661      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1662      */
1663     function _checkRole(bytes32 role, address account) internal view virtual {
1664         if (!hasRole(role, account)) {
1665             revert(
1666                 string(
1667                     abi.encodePacked(
1668                         "AccessControl: account ",
1669                         Strings.toHexString(account),
1670                         " is missing role ",
1671                         Strings.toHexString(uint256(role), 32)
1672                     )
1673                 )
1674             );
1675         }
1676     }
1677 
1678     /**
1679      * @dev Returns the admin role that controls `role`. See {grantRole} and
1680      * {revokeRole}.
1681      *
1682      * To change a role's admin, use {_setRoleAdmin}.
1683      */
1684     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1685         return _roles[role].adminRole;
1686     }
1687 
1688     /**
1689      * @dev Grants `role` to `account`.
1690      *
1691      * If `account` had not been already granted `role`, emits a {RoleGranted}
1692      * event.
1693      *
1694      * Requirements:
1695      *
1696      * - the caller must have ``role``'s admin role.
1697      *
1698      * May emit a {RoleGranted} event.
1699      */
1700     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1701         _grantRole(role, account);
1702     }
1703 
1704     /**
1705      * @dev Revokes `role` from `account`.
1706      *
1707      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1708      *
1709      * Requirements:
1710      *
1711      * - the caller must have ``role``'s admin role.
1712      *
1713      * May emit a {RoleRevoked} event.
1714      */
1715     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1716         _revokeRole(role, account);
1717     }
1718 
1719     /**
1720      * @dev Revokes `role` from the calling account.
1721      *
1722      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1723      * purpose is to provide a mechanism for accounts to lose their privileges
1724      * if they are compromised (such as when a trusted device is misplaced).
1725      *
1726      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1727      * event.
1728      *
1729      * Requirements:
1730      *
1731      * - the caller must be `account`.
1732      *
1733      * May emit a {RoleRevoked} event.
1734      */
1735     function renounceRole(bytes32 role, address account) public virtual override {
1736         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1737 
1738         _revokeRole(role, account);
1739     }
1740 
1741     /**
1742      * @dev Grants `role` to `account`.
1743      *
1744      * If `account` had not been already granted `role`, emits a {RoleGranted}
1745      * event. Note that unlike {grantRole}, this function doesn't perform any
1746      * checks on the calling account.
1747      *
1748      * May emit a {RoleGranted} event.
1749      *
1750      * [WARNING]
1751      * ====
1752      * This function should only be called from the constructor when setting
1753      * up the initial roles for the system.
1754      *
1755      * Using this function in any other way is effectively circumventing the admin
1756      * system imposed by {AccessControl}.
1757      * ====
1758      *
1759      * NOTE: This function is deprecated in favor of {_grantRole}.
1760      */
1761     function _setupRole(bytes32 role, address account) internal virtual {
1762         _grantRole(role, account);
1763     }
1764 
1765     /**
1766      * @dev Sets `adminRole` as ``role``'s admin role.
1767      *
1768      * Emits a {RoleAdminChanged} event.
1769      */
1770     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1771         bytes32 previousAdminRole = getRoleAdmin(role);
1772         _roles[role].adminRole = adminRole;
1773         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1774     }
1775 
1776     /**
1777      * @dev Grants `role` to `account`.
1778      *
1779      * Internal function without access restriction.
1780      *
1781      * May emit a {RoleGranted} event.
1782      */
1783     function _grantRole(bytes32 role, address account) internal virtual {
1784         if (!hasRole(role, account)) {
1785             _roles[role].members[account] = true;
1786             emit RoleGranted(role, account, _msgSender());
1787         }
1788     }
1789 
1790     /**
1791      * @dev Revokes `role` from `account`.
1792      *
1793      * Internal function without access restriction.
1794      *
1795      * May emit a {RoleRevoked} event.
1796      */
1797     function _revokeRole(bytes32 role, address account) internal virtual {
1798         if (hasRole(role, account)) {
1799             _roles[role].members[account] = false;
1800             emit RoleRevoked(role, account, _msgSender());
1801         }
1802     }
1803 }
1804 
1805 // File: @openzeppelin/contracts@4.8.0/token/ERC721/ERC721.sol
1806 
1807 
1808 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1809 
1810 pragma solidity ^0.8.0;
1811 
1812 
1813 
1814 
1815 
1816 
1817 
1818 
1819 /**
1820  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1821  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1822  * {ERC721Enumerable}.
1823  */
1824 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1825     using Address for address;
1826     using Strings for uint256;
1827 
1828     // Token name
1829     string private _name;
1830 
1831     // Token symbol
1832     string private _symbol;
1833 
1834     // Mapping from token ID to owner address
1835     mapping(uint256 => address) private _owners;
1836 
1837     // Mapping owner address to token count
1838     mapping(address => uint256) private _balances;
1839 
1840     // Mapping from token ID to approved address
1841     mapping(uint256 => address) private _tokenApprovals;
1842 
1843     // Mapping from owner to operator approvals
1844     mapping(address => mapping(address => bool)) private _operatorApprovals;
1845 
1846     /**
1847      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1848      */
1849     constructor(string memory name_, string memory symbol_) {
1850         _name = name_;
1851         _symbol = symbol_;
1852     }
1853 
1854     /**
1855      * @dev See {IERC165-supportsInterface}.
1856      */
1857     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1858         return
1859             interfaceId == type(IERC721).interfaceId ||
1860             interfaceId == type(IERC721Metadata).interfaceId ||
1861             super.supportsInterface(interfaceId);
1862     }
1863 
1864     /**
1865      * @dev See {IERC721-balanceOf}.
1866      */
1867     function balanceOf(address owner) public view virtual override returns (uint256) {
1868         require(owner != address(0), "ERC721: address zero is not a valid owner");
1869         return _balances[owner];
1870     }
1871 
1872     /**
1873      * @dev See {IERC721-ownerOf}.
1874      */
1875     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1876         address owner = _ownerOf(tokenId);
1877         require(owner != address(0), "ERC721: invalid token ID");
1878         return owner;
1879     }
1880 
1881     /**
1882      * @dev See {IERC721Metadata-name}.
1883      */
1884     function name() public view virtual override returns (string memory) {
1885         return _name;
1886     }
1887 
1888     /**
1889      * @dev See {IERC721Metadata-symbol}.
1890      */
1891     function symbol() public view virtual override returns (string memory) {
1892         return _symbol;
1893     }
1894 
1895     /**
1896      * @dev See {IERC721Metadata-tokenURI}.
1897      */
1898     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1899         _requireMinted(tokenId);
1900 
1901         string memory baseURI = _baseURI();
1902         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1903     }
1904 
1905     /**
1906      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1907      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1908      * by default, can be overridden in child contracts.
1909      */
1910     function _baseURI() internal view virtual returns (string memory) {
1911         return "";
1912     }
1913 
1914     /**
1915      * @dev See {IERC721-approve}.
1916      */
1917     function approve(address to, uint256 tokenId) public virtual override {
1918         address owner = ERC721.ownerOf(tokenId);
1919         require(to != owner, "ERC721: approval to current owner");
1920 
1921         require(
1922             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1923             "ERC721: approve caller is not token owner or approved for all"
1924         );
1925 
1926         _approve(to, tokenId);
1927     }
1928 
1929     /**
1930      * @dev See {IERC721-getApproved}.
1931      */
1932     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1933         _requireMinted(tokenId);
1934 
1935         return _tokenApprovals[tokenId];
1936     }
1937 
1938     /**
1939      * @dev See {IERC721-setApprovalForAll}.
1940      */
1941     function setApprovalForAll(address operator, bool approved) public virtual override {
1942         _setApprovalForAll(_msgSender(), operator, approved);
1943     }
1944 
1945     /**
1946      * @dev See {IERC721-isApprovedForAll}.
1947      */
1948     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1949         return _operatorApprovals[owner][operator];
1950     }
1951 
1952     /**
1953      * @dev See {IERC721-transferFrom}.
1954      */
1955     function transferFrom(
1956         address from,
1957         address to,
1958         uint256 tokenId
1959     ) public virtual override {
1960         //solhint-disable-next-line max-line-length
1961         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1962 
1963         _transfer(from, to, tokenId);
1964     }
1965 
1966     /**
1967      * @dev See {IERC721-safeTransferFrom}.
1968      */
1969     function safeTransferFrom(
1970         address from,
1971         address to,
1972         uint256 tokenId
1973     ) public virtual override {
1974         safeTransferFrom(from, to, tokenId, "");
1975     }
1976 
1977     /**
1978      * @dev See {IERC721-safeTransferFrom}.
1979      */
1980     function safeTransferFrom(
1981         address from,
1982         address to,
1983         uint256 tokenId,
1984         bytes memory data
1985     ) public virtual override {
1986         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1987         _safeTransfer(from, to, tokenId, data);
1988     }
1989 
1990     /**
1991      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1992      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1993      *
1994      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1995      *
1996      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1997      * implement alternative mechanisms to perform token transfer, such as signature-based.
1998      *
1999      * Requirements:
2000      *
2001      * - `from` cannot be the zero address.
2002      * - `to` cannot be the zero address.
2003      * - `tokenId` token must exist and be owned by `from`.
2004      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2005      *
2006      * Emits a {Transfer} event.
2007      */
2008     function _safeTransfer(
2009         address from,
2010         address to,
2011         uint256 tokenId,
2012         bytes memory data
2013     ) internal virtual {
2014         _transfer(from, to, tokenId);
2015         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2016     }
2017 
2018     /**
2019      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
2020      */
2021     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
2022         return _owners[tokenId];
2023     }
2024 
2025     /**
2026      * @dev Returns whether `tokenId` exists.
2027      *
2028      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2029      *
2030      * Tokens start existing when they are minted (`_mint`),
2031      * and stop existing when they are burned (`_burn`).
2032      */
2033     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2034         return _ownerOf(tokenId) != address(0);
2035     }
2036 
2037     /**
2038      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2039      *
2040      * Requirements:
2041      *
2042      * - `tokenId` must exist.
2043      */
2044     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2045         address owner = ERC721.ownerOf(tokenId);
2046         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2047     }
2048 
2049     /**
2050      * @dev Safely mints `tokenId` and transfers it to `to`.
2051      *
2052      * Requirements:
2053      *
2054      * - `tokenId` must not exist.
2055      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2056      *
2057      * Emits a {Transfer} event.
2058      */
2059     function _safeMint(address to, uint256 tokenId) internal virtual {
2060         _safeMint(to, tokenId, "");
2061     }
2062 
2063     /**
2064      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2065      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2066      */
2067     function _safeMint(
2068         address to,
2069         uint256 tokenId,
2070         bytes memory data
2071     ) internal virtual {
2072         _mint(to, tokenId);
2073         require(
2074             _checkOnERC721Received(address(0), to, tokenId, data),
2075             "ERC721: transfer to non ERC721Receiver implementer"
2076         );
2077     }
2078 
2079     /**
2080      * @dev Mints `tokenId` and transfers it to `to`.
2081      *
2082      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2083      *
2084      * Requirements:
2085      *
2086      * - `tokenId` must not exist.
2087      * - `to` cannot be the zero address.
2088      *
2089      * Emits a {Transfer} event.
2090      */
2091     function _mint(address to, uint256 tokenId) internal virtual {
2092         require(to != address(0), "ERC721: mint to the zero address");
2093         require(!_exists(tokenId), "ERC721: token already minted");
2094 
2095         _beforeTokenTransfer(address(0), to, tokenId, 1);
2096 
2097         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
2098         require(!_exists(tokenId), "ERC721: token already minted");
2099 
2100         unchecked {
2101             // Will not overflow unless all 2**256 token ids are minted to the same owner.
2102             // Given that tokens are minted one by one, it is impossible in practice that
2103             // this ever happens. Might change if we allow batch minting.
2104             // The ERC fails to describe this case.
2105             _balances[to] += 1;
2106         }
2107 
2108         _owners[tokenId] = to;
2109 
2110         emit Transfer(address(0), to, tokenId);
2111 
2112         _afterTokenTransfer(address(0), to, tokenId, 1);
2113     }
2114 
2115     /**
2116      * @dev Destroys `tokenId`.
2117      * The approval is cleared when the token is burned.
2118      * This is an internal function that does not check if the sender is authorized to operate on the token.
2119      *
2120      * Requirements:
2121      *
2122      * - `tokenId` must exist.
2123      *
2124      * Emits a {Transfer} event.
2125      */
2126     function _burn(uint256 tokenId) internal virtual {
2127         address owner = ERC721.ownerOf(tokenId);
2128 
2129         _beforeTokenTransfer(owner, address(0), tokenId, 1);
2130 
2131         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
2132         owner = ERC721.ownerOf(tokenId);
2133 
2134         // Clear approvals
2135         delete _tokenApprovals[tokenId];
2136 
2137         unchecked {
2138             // Cannot overflow, as that would require more tokens to be burned/transferred
2139             // out than the owner initially received through minting and transferring in.
2140             _balances[owner] -= 1;
2141         }
2142         delete _owners[tokenId];
2143 
2144         emit Transfer(owner, address(0), tokenId);
2145 
2146         _afterTokenTransfer(owner, address(0), tokenId, 1);
2147     }
2148 
2149     /**
2150      * @dev Transfers `tokenId` from `from` to `to`.
2151      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2152      *
2153      * Requirements:
2154      *
2155      * - `to` cannot be the zero address.
2156      * - `tokenId` token must be owned by `from`.
2157      *
2158      * Emits a {Transfer} event.
2159      */
2160     function _transfer(
2161         address from,
2162         address to,
2163         uint256 tokenId
2164     ) internal virtual {
2165         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2166         require(to != address(0), "ERC721: transfer to the zero address");
2167 
2168         _beforeTokenTransfer(from, to, tokenId, 1);
2169 
2170         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
2171         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2172 
2173         // Clear approvals from the previous owner
2174         delete _tokenApprovals[tokenId];
2175 
2176         unchecked {
2177             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
2178             // `from`'s balance is the number of token held, which is at least one before the current
2179             // transfer.
2180             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
2181             // all 2**256 token ids to be minted, which in practice is impossible.
2182             _balances[from] -= 1;
2183             _balances[to] += 1;
2184         }
2185         _owners[tokenId] = to;
2186 
2187         emit Transfer(from, to, tokenId);
2188 
2189         _afterTokenTransfer(from, to, tokenId, 1);
2190     }
2191 
2192     /**
2193      * @dev Approve `to` to operate on `tokenId`
2194      *
2195      * Emits an {Approval} event.
2196      */
2197     function _approve(address to, uint256 tokenId) internal virtual {
2198         _tokenApprovals[tokenId] = to;
2199         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2200     }
2201 
2202     /**
2203      * @dev Approve `operator` to operate on all of `owner` tokens
2204      *
2205      * Emits an {ApprovalForAll} event.
2206      */
2207     function _setApprovalForAll(
2208         address owner,
2209         address operator,
2210         bool approved
2211     ) internal virtual {
2212         require(owner != operator, "ERC721: approve to caller");
2213         _operatorApprovals[owner][operator] = approved;
2214         emit ApprovalForAll(owner, operator, approved);
2215     }
2216 
2217     /**
2218      * @dev Reverts if the `tokenId` has not been minted yet.
2219      */
2220     function _requireMinted(uint256 tokenId) internal view virtual {
2221         require(_exists(tokenId), "ERC721: invalid token ID");
2222     }
2223 
2224     /**
2225      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2226      * The call is not executed if the target address is not a contract.
2227      *
2228      * @param from address representing the previous owner of the given token ID
2229      * @param to target address that will receive the tokens
2230      * @param tokenId uint256 ID of the token to be transferred
2231      * @param data bytes optional data to send along with the call
2232      * @return bool whether the call correctly returned the expected magic value
2233      */
2234     function _checkOnERC721Received(
2235         address from,
2236         address to,
2237         uint256 tokenId,
2238         bytes memory data
2239     ) private returns (bool) {
2240         if (to.isContract()) {
2241             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2242                 return retval == IERC721Receiver.onERC721Received.selector;
2243             } catch (bytes memory reason) {
2244                 if (reason.length == 0) {
2245                     revert("ERC721: transfer to non ERC721Receiver implementer");
2246                 } else {
2247                     /// @solidity memory-safe-assembly
2248                     assembly {
2249                         revert(add(32, reason), mload(reason))
2250                     }
2251                 }
2252             }
2253         } else {
2254             return true;
2255         }
2256     }
2257 
2258     /**
2259      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2260      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2261      *
2262      * Calling conditions:
2263      *
2264      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
2265      * - When `from` is zero, the tokens will be minted for `to`.
2266      * - When `to` is zero, ``from``'s tokens will be burned.
2267      * - `from` and `to` are never both zero.
2268      * - `batchSize` is non-zero.
2269      *
2270      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2271      */
2272     function _beforeTokenTransfer(
2273         address from,
2274         address to,
2275         uint256, /* firstTokenId */
2276         uint256 batchSize
2277     ) internal virtual {
2278         if (batchSize > 1) {
2279             if (from != address(0)) {
2280                 _balances[from] -= batchSize;
2281             }
2282             if (to != address(0)) {
2283                 _balances[to] += batchSize;
2284             }
2285         }
2286     }
2287 
2288     /**
2289      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2290      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2291      *
2292      * Calling conditions:
2293      *
2294      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
2295      * - When `from` is zero, the tokens were minted for `to`.
2296      * - When `to` is zero, ``from``'s tokens were burned.
2297      * - `from` and `to` are never both zero.
2298      * - `batchSize` is non-zero.
2299      *
2300      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2301      */
2302     function _afterTokenTransfer(
2303         address from,
2304         address to,
2305         uint256 firstTokenId,
2306         uint256 batchSize
2307     ) internal virtual {}
2308 }
2309 
2310 // File: @openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Burnable.sol
2311 
2312 
2313 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Burnable.sol)
2314 
2315 pragma solidity ^0.8.0;
2316 
2317 
2318 
2319 /**
2320  * @title ERC721 Burnable Token
2321  * @dev ERC721 Token that can be burned (destroyed).
2322  */
2323 abstract contract ERC721Burnable is Context, ERC721 {
2324     /**
2325      * @dev Burns `tokenId`. See {ERC721-_burn}.
2326      *
2327      * Requirements:
2328      *
2329      * - The caller must own `tokenId` or be an approved operator.
2330      */
2331     function burn(uint256 tokenId) public virtual {
2332         //solhint-disable-next-line max-line-length
2333         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
2334         _burn(tokenId);
2335     }
2336 }
2337 
2338 // File: @openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721URIStorage.sol
2339 
2340 
2341 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
2342 
2343 pragma solidity ^0.8.0;
2344 
2345 
2346 /**
2347  * @dev ERC721 token with storage based token URI management.
2348  */
2349 abstract contract ERC721URIStorage is ERC721 {
2350     using Strings for uint256;
2351 
2352     // Optional mapping for token URIs
2353     mapping(uint256 => string) private _tokenURIs;
2354 
2355     /**
2356      * @dev See {IERC721Metadata-tokenURI}.
2357      */
2358     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2359         _requireMinted(tokenId);
2360 
2361         string memory _tokenURI = _tokenURIs[tokenId];
2362         string memory base = _baseURI();
2363 
2364         // If there is no base URI, return the token URI.
2365         if (bytes(base).length == 0) {
2366             return _tokenURI;
2367         }
2368         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
2369         if (bytes(_tokenURI).length > 0) {
2370             return string(abi.encodePacked(base, _tokenURI));
2371         }
2372 
2373         return super.tokenURI(tokenId);
2374     }
2375 
2376     /**
2377      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2378      *
2379      * Requirements:
2380      *
2381      * - `tokenId` must exist.
2382      */
2383     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
2384         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
2385         _tokenURIs[tokenId] = _tokenURI;
2386     }
2387 
2388     /**
2389      * @dev See {ERC721-_burn}. This override additionally checks to see if a
2390      * token-specific URI was set for the token, and if so, it deletes the token URI from
2391      * the storage mapping.
2392      */
2393     function _burn(uint256 tokenId) internal virtual override {
2394         super._burn(tokenId);
2395 
2396         if (bytes(_tokenURIs[tokenId]).length != 0) {
2397             delete _tokenURIs[tokenId];
2398         }
2399     }
2400 }
2401 
2402 // File: @openzeppelin/contracts@4.8.0/token/ERC721/extensions/ERC721Enumerable.sol
2403 
2404 
2405 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
2406 
2407 pragma solidity ^0.8.0;
2408 
2409 
2410 
2411 /**
2412  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
2413  * enumerability of all the token ids in the contract as well as all token ids owned by each
2414  * account.
2415  */
2416 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
2417     // Mapping from owner to list of owned token IDs
2418     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2419 
2420     // Mapping from token ID to index of the owner tokens list
2421     mapping(uint256 => uint256) private _ownedTokensIndex;
2422 
2423     // Array with all token ids, used for enumeration
2424     uint256[] private _allTokens;
2425 
2426     // Mapping from token id to position in the allTokens array
2427     mapping(uint256 => uint256) private _allTokensIndex;
2428 
2429     /**
2430      * @dev See {IERC165-supportsInterface}.
2431      */
2432     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
2433         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
2434     }
2435 
2436     /**
2437      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
2438      */
2439     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
2440         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
2441         return _ownedTokens[owner][index];
2442     }
2443 
2444     /**
2445      * @dev See {IERC721Enumerable-totalSupply}.
2446      */
2447     function totalSupply() public view virtual override returns (uint256) {
2448         return _allTokens.length;
2449     }
2450 
2451     /**
2452      * @dev See {IERC721Enumerable-tokenByIndex}.
2453      */
2454     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
2455         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
2456         return _allTokens[index];
2457     }
2458 
2459     /**
2460      * @dev See {ERC721-_beforeTokenTransfer}.
2461      */
2462     function _beforeTokenTransfer(
2463         address from,
2464         address to,
2465         uint256 firstTokenId,
2466         uint256 batchSize
2467     ) internal virtual override {
2468         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
2469 
2470         if (batchSize > 1) {
2471             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
2472             revert("ERC721Enumerable: consecutive transfers not supported");
2473         }
2474 
2475         uint256 tokenId = firstTokenId;
2476 
2477         if (from == address(0)) {
2478             _addTokenToAllTokensEnumeration(tokenId);
2479         } else if (from != to) {
2480             _removeTokenFromOwnerEnumeration(from, tokenId);
2481         }
2482         if (to == address(0)) {
2483             _removeTokenFromAllTokensEnumeration(tokenId);
2484         } else if (to != from) {
2485             _addTokenToOwnerEnumeration(to, tokenId);
2486         }
2487     }
2488 
2489     /**
2490      * @dev Private function to add a token to this extension's ownership-tracking data structures.
2491      * @param to address representing the new owner of the given token ID
2492      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
2493      */
2494     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2495         uint256 length = ERC721.balanceOf(to);
2496         _ownedTokens[to][length] = tokenId;
2497         _ownedTokensIndex[tokenId] = length;
2498     }
2499 
2500     /**
2501      * @dev Private function to add a token to this extension's token tracking data structures.
2502      * @param tokenId uint256 ID of the token to be added to the tokens list
2503      */
2504     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2505         _allTokensIndex[tokenId] = _allTokens.length;
2506         _allTokens.push(tokenId);
2507     }
2508 
2509     /**
2510      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
2511      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
2512      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
2513      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
2514      * @param from address representing the previous owner of the given token ID
2515      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
2516      */
2517     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
2518         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2519         // then delete the last slot (swap and pop).
2520 
2521         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2522         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2523 
2524         // When the token to delete is the last token, the swap operation is unnecessary
2525         if (tokenIndex != lastTokenIndex) {
2526             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2527 
2528             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2529             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2530         }
2531 
2532         // This also deletes the contents at the last position of the array
2533         delete _ownedTokensIndex[tokenId];
2534         delete _ownedTokens[from][lastTokenIndex];
2535     }
2536 
2537     /**
2538      * @dev Private function to remove a token from this extension's token tracking data structures.
2539      * This has O(1) time complexity, but alters the order of the _allTokens array.
2540      * @param tokenId uint256 ID of the token to be removed from the tokens list
2541      */
2542     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2543         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2544         // then delete the last slot (swap and pop).
2545 
2546         uint256 lastTokenIndex = _allTokens.length - 1;
2547         uint256 tokenIndex = _allTokensIndex[tokenId];
2548 
2549         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2550         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2551         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2552         uint256 lastTokenId = _allTokens[lastTokenIndex];
2553 
2554         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2555         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2556 
2557         // This also deletes the contents at the last position of the array
2558         delete _allTokensIndex[tokenId];
2559         _allTokens.pop();
2560     }
2561 }
2562 
2563 // File: @openzeppelin/contracts@4.8.0/interfaces/IERC2981.sol
2564 
2565 
2566 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
2567 
2568 pragma solidity ^0.8.0;
2569 
2570 
2571 /**
2572  * @dev Interface for the NFT Royalty Standard.
2573  *
2574  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2575  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2576  *
2577  * _Available since v4.5._
2578  */
2579 interface IERC2981 is IERC165 {
2580     /**
2581      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2582      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2583      */
2584     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2585         external
2586         view
2587         returns (address receiver, uint256 royaltyAmount);
2588 }
2589 
2590 // File: @openzeppelin/contracts@4.8.0/token/common/ERC2981.sol
2591 
2592 
2593 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
2594 
2595 pragma solidity ^0.8.0;
2596 
2597 
2598 
2599 /**
2600  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2601  *
2602  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2603  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2604  *
2605  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2606  * fee is specified in basis points by default.
2607  *
2608  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2609  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2610  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2611  *
2612  * _Available since v4.5._
2613  */
2614 abstract contract ERC2981 is IERC2981, ERC165 {
2615     struct RoyaltyInfo {
2616         address receiver;
2617         uint96 royaltyFraction;
2618     }
2619 
2620     RoyaltyInfo private _defaultRoyaltyInfo;
2621     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2622 
2623     /**
2624      * @dev See {IERC165-supportsInterface}.
2625      */
2626     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2627         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2628     }
2629 
2630     /**
2631      * @inheritdoc IERC2981
2632      */
2633     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
2634         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
2635 
2636         if (royalty.receiver == address(0)) {
2637             royalty = _defaultRoyaltyInfo;
2638         }
2639 
2640         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
2641 
2642         return (royalty.receiver, royaltyAmount);
2643     }
2644 
2645     /**
2646      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2647      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2648      * override.
2649      */
2650     function _feeDenominator() internal pure virtual returns (uint96) {
2651         return 10000;
2652     }
2653 
2654     /**
2655      * @dev Sets the royalty information that all ids in this contract will default to.
2656      *
2657      * Requirements:
2658      *
2659      * - `receiver` cannot be the zero address.
2660      * - `feeNumerator` cannot be greater than the fee denominator.
2661      */
2662     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2663         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2664         require(receiver != address(0), "ERC2981: invalid receiver");
2665 
2666         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2667     }
2668 
2669     /**
2670      * @dev Removes default royalty information.
2671      */
2672     function _deleteDefaultRoyalty() internal virtual {
2673         delete _defaultRoyaltyInfo;
2674     }
2675 
2676     /**
2677      * @dev Sets the royalty information for a specific token id, overriding the global default.
2678      *
2679      * Requirements:
2680      *
2681      * - `receiver` cannot be the zero address.
2682      * - `feeNumerator` cannot be greater than the fee denominator.
2683      */
2684     function _setTokenRoyalty(
2685         uint256 tokenId,
2686         address receiver,
2687         uint96 feeNumerator
2688     ) internal virtual {
2689         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2690         require(receiver != address(0), "ERC2981: Invalid parameters");
2691 
2692         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2693     }
2694 
2695     /**
2696      * @dev Resets royalty information for the token id back to the global default.
2697      */
2698     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2699         delete _tokenRoyaltyInfo[tokenId];
2700     }
2701 }
2702 
2703 // File: contracts/user-sm/mitaverse/mitaverse.sol
2704 
2705 
2706 pragma solidity ^0.8.9;
2707 
2708 
2709 
2710 
2711 
2712 
2713 
2714 
2715 
2716 contract mitaverse is ERC721, ERC721Enumerable, ERC721URIStorage, AccessControl, ERC721Burnable, DefaultOperatorFilterer, ERC2981 {
2717     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
2718     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2719 
2720     string private metadataUri;
2721     string private metadataSuffix = "";
2722     bool private _paused;
2723 
2724     uint256 public maxSupply;
2725     uint256 public tokenId;
2726     address public owner;
2727     mapping(uint256 => uint256) public rarity;
2728 
2729     struct SaleInfo {
2730         uint256 amount;
2731         uint256 price;
2732         uint64 startTime;
2733         uint64 endTime;
2734         uint256 startId;
2735         bytes32 merkleRoot;
2736         uint256 perTx;
2737         uint256 perWallet;
2738         uint256 maxLimit;
2739         uint256 minted;
2740     }
2741     mapping(uint16 => SaleInfo) public saleInfos;
2742     mapping(uint16 => mapping(address => uint256)) public mintLogs;
2743 
2744     uint16 public saleInfoNum = 0;
2745     bool private isRevealed = false;
2746 
2747     event Paused(address account);
2748     event Unpaused(address account);
2749 
2750     constructor(
2751         string memory name,
2752         string memory symbol,
2753         uint256 _maxSupply
2754     ) ERC721(name, symbol) {
2755         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
2756         _grantRole(PAUSER_ROLE, msg.sender);
2757         _grantRole(MINTER_ROLE, msg.sender);
2758         tokenId = 1;
2759         maxSupply = _maxSupply;
2760         owner = msg.sender;
2761     }
2762 
2763     // =============================================================
2764     //                        INTERNAL METHODS
2765     // =============================================================
2766 
2767     function _logMint(address addr, uint16 step, uint256 quantity)
2768     private 
2769     {
2770         mintLogs[step][addr] += quantity;
2771         saleInfos[step].minted += quantity;
2772     }
2773     function _checkIsMintable(address addr, uint16 step, uint256 quantity) 
2774     internal 
2775     returns (bool) 
2776     {
2777         if (step >= saleInfoNum) revert("Not exist mint step");
2778         SaleInfo memory saleInfo = saleInfos[step];
2779         if (block.timestamp < saleInfo.startTime) revert("Minting hasn't started yet");
2780         if (block.timestamp > saleInfo.endTime) revert("Minting has ended");
2781         if (saleInfo.amount < saleInfo.minted + quantity) revert("Sold out in this step");
2782         if (tokenId + quantity - 1 > maxSupply) revert("Sold out for total supply");
2783         if (saleInfo.maxLimit != 0 && tokenId + quantity - 1 > saleInfo.maxLimit) revert("Sold out for max limit");
2784         if (saleInfo.perTx != 0 && saleInfo.perTx < quantity)
2785             revert("Exceeds the maximum number of mints per transaction");
2786         if (saleInfo.perWallet != 0 && saleInfo.perWallet < mintLogs[step][addr] + quantity)
2787             revert("Exceeds the maximum number of mints per wallet");
2788         if (quantity == 0) revert("Invalid quantity");
2789         if (msg.sender == addr && msg.value != saleInfo.price * quantity) revert("Invalid value");
2790         return true;
2791     }
2792     function _beforeTokenTransfer(address from, address to, uint256 _tokenId, uint256 batchSize)
2793         internal
2794         override(ERC721, ERC721Enumerable)
2795     {
2796         if(!paused() || from == address(0)) super._beforeTokenTransfer(from, to, _tokenId, batchSize);
2797         else revert("Pasused");
2798     }
2799     function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) 
2800     {
2801         super._burn(_tokenId);
2802     }
2803     function transferOwnership(address newOwner) public onlyRole(DEFAULT_ADMIN_ROLE) {
2804         _grantRole(DEFAULT_ADMIN_ROLE, newOwner);
2805         _grantRole(PAUSER_ROLE, newOwner);
2806         _grantRole(MINTER_ROLE, newOwner);
2807         _revokeRole(PAUSER_ROLE, msg.sender);
2808         _revokeRole(MINTER_ROLE, msg.sender);
2809         _revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);
2810         owner = newOwner;
2811     }
2812      function _pause() internal virtual {
2813         _paused = true;
2814         emit Paused(_msgSender());
2815     }
2816       function _unpause() internal virtual {
2817         _paused = false;
2818         emit Unpaused(_msgSender());
2819     }
2820 
2821     // =============================================================
2822     //                        MINT METHODS
2823     // =============================================================
2824 
2825     function airdrop(address to, uint256 amount)
2826         public
2827         onlyRole(MINTER_ROLE)
2828     {
2829         if(tokenId + amount - 1 > maxSupply) revert("Sold out for max supply");
2830        for(uint256 i = 0; i < amount; i++) {
2831         _safeMint(to, tokenId);
2832         tokenId++;
2833         }
2834     }
2835 
2836     function mint(
2837         uint16 step,
2838         uint8 amount,
2839         bytes32[] memory proof
2840     ) external payable {
2841         SaleInfo memory saleInfo = saleInfos[step];
2842         _checkIsMintable(msg.sender, step, amount);
2843         if (!isWhiteListed(msg.sender, proof, step)) revert("Not in whitelist");
2844         for(uint256 i = 0; i < amount; i++) {
2845         _safeMint(msg.sender, saleInfo.startId + saleInfo.minted + i);
2846         tokenId++;
2847         }
2848         _logMint(msg.sender, step, amount);
2849     }
2850     
2851     function setSaleInfoList(
2852         uint256[] memory amounts,
2853         uint256[] memory prices,
2854         uint64[] memory startTimes,
2855         uint64[] memory endTimes,
2856         uint256[] memory startIds,
2857         bytes32[] memory merkleRoots,
2858         uint256[] memory perTxs,
2859         uint256[] memory perWallets,
2860         uint256[] memory maxLimits,
2861         uint16 startIdx
2862     ) external onlyRole(MINTER_ROLE) {
2863         require(startIdx <= saleInfoNum, "startIdx is out of range");
2864         for (uint16 i = 0; i < amounts.length; i++)
2865             saleInfos[i + startIdx] = SaleInfo(
2866                 amounts[i],
2867                 prices[i],
2868                 startTimes[i],
2869                 endTimes[i],
2870                 startIds[i],
2871                 merkleRoots[i],
2872                 perTxs[i],
2873                 perWallets[i],
2874                 maxLimits[i],
2875                 saleInfos[i + startIdx].minted
2876             );
2877         if (startIdx + amounts.length > saleInfoNum) saleInfoNum = startIdx + uint16(amounts.length);
2878     }
2879     function isWhiteListed(
2880         address _account,
2881         bytes32[] memory _proof,
2882         uint16 step
2883     ) public view returns (bool) {
2884         return
2885             saleInfos[step].merkleRoot == 0x0 || MerkleProof.verify(_proof, saleInfos[step].merkleRoot, leaf(_account));
2886     }
2887     function leaf(address _account) internal pure returns (bytes32) {
2888         return keccak256(abi.encodePacked(_account));
2889     }
2890     function withdraw(uint256 amount)
2891     public
2892     onlyRole(DEFAULT_ADMIN_ROLE)
2893     {
2894     payable(msg.sender).transfer(amount);
2895     }
2896     function currentTime()
2897     public 
2898     view
2899     returns(uint256)
2900     {
2901         return block.timestamp;
2902     }
2903 
2904     // =============================================================
2905     //                        TOKEN METHODS
2906     // =============================================================
2907 
2908     function tokensOfOwner(address owner_)
2909         public
2910         view
2911         virtual
2912         returns (uint256[] memory)
2913     {
2914         uint256 balance = balanceOf(owner_);
2915         uint256[] memory result = new uint256[](balance);
2916         for (uint256 i = 0; i < balance; i++) {
2917             result[i] = tokenOfOwnerByIndex(owner_, i);
2918         }
2919         return result;
2920     }
2921 
2922     function setMaxSupply(uint256 _amount)
2923     public
2924     onlyRole(MINTER_ROLE)
2925     {
2926         maxSupply = _amount;
2927     }
2928     function tokenURI(uint256 _tokenId) public view virtual override(ERC721, ERC721URIStorage)
2929     returns (string memory)
2930     {
2931         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2932         if (!isRevealed) return string(abi.encodePacked(metadataUri, metadataSuffix));
2933         return string(abi.encodePacked(metadataUri, Strings.toString(_tokenId), metadataSuffix));
2934     }
2935     function contractURI()
2936     public
2937     view
2938     returns (string memory)
2939     {
2940         return string(abi.encodePacked(metadataUri, "contract", metadataSuffix));
2941     }
2942     function setMetadata(string calldata _metadataUri, string calldata _metadataSuffix, bool _isReveal)
2943     external
2944     onlyRole(MINTER_ROLE)
2945     {
2946         metadataUri = _metadataUri;
2947         metadataSuffix = _metadataSuffix;
2948         isRevealed = _isReveal;
2949     }
2950     function supportsInterface(bytes4 interfaceId)
2951     public
2952     view
2953     override(ERC721, ERC721Enumerable, AccessControl, ERC2981)
2954     returns (bool)
2955     {
2956         return super.supportsInterface(interfaceId);
2957     }
2958      function setApprovalForAll(address operator, bool approved) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
2959         super.setApprovalForAll(operator, approved);
2960     }
2961 
2962     /**
2963      * @dev See {IERC721-approve}.
2964      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2965      */
2966     function approve(address operator, uint256 _tokenId) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
2967         super.approve(operator, _tokenId);
2968     }
2969 
2970     /**
2971      * @dev See {IERC721-transferFrom}.
2972      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2973      */
2974     function transferFrom(address from, address to, uint256 _tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
2975         super.transferFrom(from, to, _tokenId);
2976     }
2977 
2978     /**
2979      * @dev See {IERC721-safeTransferFrom}.
2980      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2981      */
2982     function safeTransferFrom(address from, address to, uint256 _tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
2983         super.safeTransferFrom(from, to, _tokenId);
2984     }
2985 
2986     /**
2987      * @dev See {IERC721-safeTransferFrom}.
2988      *      In this example the added modifier ensures that the operator is allowed by the OperatorFilterRegistry.
2989      */
2990     function safeTransferFrom(address from, address to, uint256 _tokenId, bytes memory data)
2991         public
2992         override(ERC721, IERC721)
2993         onlyAllowedOperator(from)
2994     {
2995         super.safeTransferFrom(from, to, _tokenId, data);
2996     }
2997 
2998     function pause() public onlyRole(PAUSER_ROLE)
2999     {
3000         _pause();
3001     }
3002     function unpause() public onlyRole(PAUSER_ROLE)
3003     {
3004         _unpause();
3005     }
3006     function paused() public view virtual returns (bool) {
3007         return _paused;
3008     }
3009 }