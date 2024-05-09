1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/lib/Constants.sol
3 
4 
5 pragma solidity ^0.8.13;
6 
7 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
8 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
9 
10 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
11 
12 
13 pragma solidity ^0.8.13;
14 
15 interface IOperatorFilterRegistry {
16     /**
17      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
18      *         true if supplied registrant address is not registered.
19      */
20     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
21 
22     /**
23      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
24      */
25     function register(address registrant) external;
26 
27     /**
28      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
29      */
30     function registerAndSubscribe(address registrant, address subscription) external;
31 
32     /**
33      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
34      *         address without subscribing.
35      */
36     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
37 
38     /**
39      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
40      *         Note that this does not remove any filtered addresses or codeHashes.
41      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
42      */
43     function unregister(address addr) external;
44 
45     /**
46      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
47      */
48     function updateOperator(address registrant, address operator, bool filtered) external;
49 
50     /**
51      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
52      */
53     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
54 
55     /**
56      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
57      */
58     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
59 
60     /**
61      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
62      */
63     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
64 
65     /**
66      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
67      *         subscription if present.
68      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
69      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
70      *         used.
71      */
72     function subscribe(address registrant, address registrantToSubscribe) external;
73 
74     /**
75      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
76      */
77     function unsubscribe(address registrant, bool copyExistingEntries) external;
78 
79     /**
80      * @notice Get the subscription address of a given registrant, if any.
81      */
82     function subscriptionOf(address addr) external returns (address registrant);
83 
84     /**
85      * @notice Get the set of addresses subscribed to a given registrant.
86      *         Note that order is not guaranteed as updates are made.
87      */
88     function subscribers(address registrant) external returns (address[] memory);
89 
90     /**
91      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
92      *         Note that order is not guaranteed as updates are made.
93      */
94     function subscriberAt(address registrant, uint256 index) external returns (address);
95 
96     /**
97      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
98      */
99     function copyEntriesOf(address registrant, address registrantToCopy) external;
100 
101     /**
102      * @notice Returns true if operator is filtered by a given address or its subscription.
103      */
104     function isOperatorFiltered(address registrant, address operator) external returns (bool);
105 
106     /**
107      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
108      */
109     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
110 
111     /**
112      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
113      */
114     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
115 
116     /**
117      * @notice Returns a list of filtered operators for a given address or its subscription.
118      */
119     function filteredOperators(address addr) external returns (address[] memory);
120 
121     /**
122      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
123      *         Note that order is not guaranteed as updates are made.
124      */
125     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
126 
127     /**
128      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
129      *         its subscription.
130      *         Note that order is not guaranteed as updates are made.
131      */
132     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
133 
134     /**
135      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
136      *         its subscription.
137      *         Note that order is not guaranteed as updates are made.
138      */
139     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
140 
141     /**
142      * @notice Returns true if an address has registered
143      */
144     function isRegistered(address addr) external returns (bool);
145 
146     /**
147      * @dev Convenience method to compute the code hash of an arbitrary contract
148      */
149     function codeHashOf(address addr) external returns (bytes32);
150 }
151 
152 // File: operator-filter-registry/src/UpdatableOperatorFilterer.sol
153 
154 
155 pragma solidity ^0.8.13;
156 
157 
158 /**
159  * @title  UpdatableOperatorFilterer
160  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
161  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
162  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
163  *         which will bypass registry checks.
164  *         Note that OpenSea will still disable creator earnings enforcement if filtered operators begin fulfilling orders
165  *         on-chain, eg, if the registry is revoked or bypassed.
166  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
167  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
168  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
169  */
170 abstract contract UpdatableOperatorFilterer {
171     /// @dev Emitted when an operator is not allowed.
172     error OperatorNotAllowed(address operator);
173     /// @dev Emitted when someone other than the owner is trying to call an only owner function.
174     error OnlyOwner();
175 
176     event OperatorFilterRegistryAddressUpdated(address newRegistry);
177 
178     IOperatorFilterRegistry public operatorFilterRegistry;
179 
180     /// @dev The constructor that is called when the contract is being deployed.
181     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
182         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
183         operatorFilterRegistry = registry;
184         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
185         // will not revert, but the contract will need to be registered with the registry once it is deployed in
186         // order for the modifier to filter addresses.
187         if (address(registry).code.length > 0) {
188             if (subscribe) {
189                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
190             } else {
191                 if (subscriptionOrRegistrantToCopy != address(0)) {
192                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
193                 } else {
194                     registry.register(address(this));
195                 }
196             }
197         }
198     }
199 
200     /**
201      * @dev A helper function to check if the operator is allowed.
202      */
203     modifier onlyAllowedOperator(address from) virtual {
204         // Allow spending tokens from addresses with balance
205         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
206         // from an EOA.
207         if (from != msg.sender) {
208             _checkFilterOperator(msg.sender);
209         }
210         _;
211     }
212 
213     /**
214      * @dev A helper function to check if the operator approval is allowed.
215      */
216     modifier onlyAllowedOperatorApproval(address operator) virtual {
217         _checkFilterOperator(operator);
218         _;
219     }
220 
221     /**
222      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
223      *         address, checks will be bypassed. OnlyOwner.
224      */
225     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
226         if (msg.sender != owner()) {
227             revert OnlyOwner();
228         }
229         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
230         emit OperatorFilterRegistryAddressUpdated(newRegistry);
231     }
232 
233     /**
234      * @dev Assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract.
235      */
236     function owner() public view virtual returns (address);
237 
238     /**
239      * @dev A helper function to check if the operator is allowed.
240      */
241     function _checkFilterOperator(address operator) internal view virtual {
242         IOperatorFilterRegistry registry = operatorFilterRegistry;
243         // Check registry code length to facilitate testing in environments without a deployed registry.
244         if (address(registry) != address(0) && address(registry).code.length > 0) {
245             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
246             // may specify their own OperatorFilterRegistry implementations, which may behave differently
247             if (!registry.isOperatorAllowed(address(this), operator)) {
248                 revert OperatorNotAllowed(operator);
249             }
250         }
251     }
252 }
253 
254 // File: operator-filter-registry/src/RevokableOperatorFilterer.sol
255 
256 
257 pragma solidity ^0.8.13;
258 
259 
260 
261 /**
262  * @title  RevokableOperatorFilterer
263  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
264  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
265  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
266  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
267  *         address cannot be further updated.
268  *         Note that OpenSea will still disable creator earnings enforcement if filtered operators begin fulfilling orders
269  *         on-chain, eg, if the registry is revoked or bypassed.
270  */
271 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
272     /// @dev Emitted when the registry has already been revoked.
273     error RegistryHasBeenRevoked();
274     /// @dev Emitted when the initial registry address is attempted to be set to the zero address.
275     error InitialRegistryAddressCannotBeZeroAddress();
276 
277     event OperatorFilterRegistryRevoked();
278 
279     bool public isOperatorFilterRegistryRevoked;
280 
281     /// @dev The constructor that is called when the contract is being deployed.
282     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
283         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
284     {
285         // don't allow creating a contract with a permanently revoked registry
286         if (_registry == address(0)) {
287             revert InitialRegistryAddressCannotBeZeroAddress();
288         }
289     }
290 
291     /**
292      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
293      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
294      */
295     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
296         if (msg.sender != owner()) {
297             revert OnlyOwner();
298         }
299         // if registry has been revoked, do not allow further updates
300         if (isOperatorFilterRegistryRevoked) {
301             revert RegistryHasBeenRevoked();
302         }
303 
304         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
305         emit OperatorFilterRegistryAddressUpdated(newRegistry);
306     }
307 
308     /**
309      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
310      */
311     function revokeOperatorFilterRegistry() public {
312         if (msg.sender != owner()) {
313             revert OnlyOwner();
314         }
315         // if registry has been revoked, do not allow further updates
316         if (isOperatorFilterRegistryRevoked) {
317             revert RegistryHasBeenRevoked();
318         }
319 
320         // set to zero address to bypass checks
321         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
322         isOperatorFilterRegistryRevoked = true;
323         emit OperatorFilterRegistryRevoked();
324     }
325 }
326 
327 // File: operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol
328 
329 
330 pragma solidity ^0.8.13;
331 
332 
333 /**
334  * @title  RevokableDefaultOperatorFilterer
335  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
336  *         Note that OpenSea will disable creator earnings enforcement if filtered operators begin fulfilling orders
337  *         on-chain, eg, if the registry is revoked or bypassed.
338  */
339 
340 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
341     /// @dev The constructor that is called when the contract is being deployed.
342     constructor()
343         RevokableOperatorFilterer(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS, CANONICAL_CORI_SUBSCRIPTION, true)
344     {}
345 }
346 
347 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
348 
349 
350 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @dev Contract module that helps prevent reentrant calls to a function.
356  *
357  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
358  * available, which can be applied to functions to make sure there are no nested
359  * (reentrant) calls to them.
360  *
361  * Note that because there is a single `nonReentrant` guard, functions marked as
362  * `nonReentrant` may not call one another. This can be worked around by making
363  * those functions `private`, and then adding `external` `nonReentrant` entry
364  * points to them.
365  *
366  * TIP: If you would like to learn more about reentrancy and alternative ways
367  * to protect against it, check out our blog post
368  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
369  */
370 abstract contract ReentrancyGuard {
371     // Booleans are more expensive than uint256 or any type that takes up a full
372     // word because each write operation emits an extra SLOAD to first read the
373     // slot's contents, replace the bits taken up by the boolean, and then write
374     // back. This is the compiler's defense against contract upgrades and
375     // pointer aliasing, and it cannot be disabled.
376 
377     // The values being non-zero value makes deployment a bit more expensive,
378     // but in exchange the refund on every call to nonReentrant will be lower in
379     // amount. Since refunds are capped to a percentage of the total
380     // transaction's gas, it is best to keep them low in cases like this one, to
381     // increase the likelihood of the full refund coming into effect.
382     uint256 private constant _NOT_ENTERED = 1;
383     uint256 private constant _ENTERED = 2;
384 
385     uint256 private _status;
386 
387     constructor() {
388         _status = _NOT_ENTERED;
389     }
390 
391     /**
392      * @dev Prevents a contract from calling itself, directly or indirectly.
393      * Calling a `nonReentrant` function from another `nonReentrant`
394      * function is not supported. It is possible to prevent this from happening
395      * by making the `nonReentrant` function external, and making it call a
396      * `private` function that does the actual work.
397      */
398     modifier nonReentrant() {
399         _nonReentrantBefore();
400         _;
401         _nonReentrantAfter();
402     }
403 
404     function _nonReentrantBefore() private {
405         // On the first call to nonReentrant, _status will be _NOT_ENTERED
406         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
407 
408         // Any calls to nonReentrant after this point will fail
409         _status = _ENTERED;
410     }
411 
412     function _nonReentrantAfter() private {
413         // By storing the original value once again, a refund is triggered (see
414         // https://eips.ethereum.org/EIPS/eip-2200)
415         _status = _NOT_ENTERED;
416     }
417 }
418 
419 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
420 
421 
422 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @dev These functions deal with verification of Merkle Tree proofs.
428  *
429  * The tree and the proofs can be generated using our
430  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
431  * You will find a quickstart guide in the readme.
432  *
433  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
434  * hashing, or use a hash function other than keccak256 for hashing leaves.
435  * This is because the concatenation of a sorted pair of internal nodes in
436  * the merkle tree could be reinterpreted as a leaf value.
437  * OpenZeppelin's JavaScript library generates merkle trees that are safe
438  * against this attack out of the box.
439  */
440 library MerkleProof {
441     /**
442      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
443      * defined by `root`. For this, a `proof` must be provided, containing
444      * sibling hashes on the branch from the leaf to the root of the tree. Each
445      * pair of leaves and each pair of pre-images are assumed to be sorted.
446      */
447     function verify(
448         bytes32[] memory proof,
449         bytes32 root,
450         bytes32 leaf
451     ) internal pure returns (bool) {
452         return processProof(proof, leaf) == root;
453     }
454 
455     /**
456      * @dev Calldata version of {verify}
457      *
458      * _Available since v4.7._
459      */
460     function verifyCalldata(
461         bytes32[] calldata proof,
462         bytes32 root,
463         bytes32 leaf
464     ) internal pure returns (bool) {
465         return processProofCalldata(proof, leaf) == root;
466     }
467 
468     /**
469      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
470      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
471      * hash matches the root of the tree. When processing the proof, the pairs
472      * of leafs & pre-images are assumed to be sorted.
473      *
474      * _Available since v4.4._
475      */
476     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
477         bytes32 computedHash = leaf;
478         for (uint256 i = 0; i < proof.length; i++) {
479             computedHash = _hashPair(computedHash, proof[i]);
480         }
481         return computedHash;
482     }
483 
484     /**
485      * @dev Calldata version of {processProof}
486      *
487      * _Available since v4.7._
488      */
489     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
490         bytes32 computedHash = leaf;
491         for (uint256 i = 0; i < proof.length; i++) {
492             computedHash = _hashPair(computedHash, proof[i]);
493         }
494         return computedHash;
495     }
496 
497     /**
498      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
499      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
500      *
501      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
502      *
503      * _Available since v4.7._
504      */
505     function multiProofVerify(
506         bytes32[] memory proof,
507         bool[] memory proofFlags,
508         bytes32 root,
509         bytes32[] memory leaves
510     ) internal pure returns (bool) {
511         return processMultiProof(proof, proofFlags, leaves) == root;
512     }
513 
514     /**
515      * @dev Calldata version of {multiProofVerify}
516      *
517      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
518      *
519      * _Available since v4.7._
520      */
521     function multiProofVerifyCalldata(
522         bytes32[] calldata proof,
523         bool[] calldata proofFlags,
524         bytes32 root,
525         bytes32[] memory leaves
526     ) internal pure returns (bool) {
527         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
528     }
529 
530     /**
531      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
532      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
533      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
534      * respectively.
535      *
536      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
537      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
538      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
539      *
540      * _Available since v4.7._
541      */
542     function processMultiProof(
543         bytes32[] memory proof,
544         bool[] memory proofFlags,
545         bytes32[] memory leaves
546     ) internal pure returns (bytes32 merkleRoot) {
547         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
548         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
549         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
550         // the merkle tree.
551         uint256 leavesLen = leaves.length;
552         uint256 totalHashes = proofFlags.length;
553 
554         // Check proof validity.
555         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
556 
557         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
558         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
559         bytes32[] memory hashes = new bytes32[](totalHashes);
560         uint256 leafPos = 0;
561         uint256 hashPos = 0;
562         uint256 proofPos = 0;
563         // At each step, we compute the next hash using two values:
564         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
565         //   get the next hash.
566         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
567         //   `proof` array.
568         for (uint256 i = 0; i < totalHashes; i++) {
569             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
570             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
571             hashes[i] = _hashPair(a, b);
572         }
573 
574         if (totalHashes > 0) {
575             return hashes[totalHashes - 1];
576         } else if (leavesLen > 0) {
577             return leaves[0];
578         } else {
579             return proof[0];
580         }
581     }
582 
583     /**
584      * @dev Calldata version of {processMultiProof}.
585      *
586      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
587      *
588      * _Available since v4.7._
589      */
590     function processMultiProofCalldata(
591         bytes32[] calldata proof,
592         bool[] calldata proofFlags,
593         bytes32[] memory leaves
594     ) internal pure returns (bytes32 merkleRoot) {
595         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
596         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
597         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
598         // the merkle tree.
599         uint256 leavesLen = leaves.length;
600         uint256 totalHashes = proofFlags.length;
601 
602         // Check proof validity.
603         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
604 
605         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
606         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
607         bytes32[] memory hashes = new bytes32[](totalHashes);
608         uint256 leafPos = 0;
609         uint256 hashPos = 0;
610         uint256 proofPos = 0;
611         // At each step, we compute the next hash using two values:
612         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
613         //   get the next hash.
614         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
615         //   `proof` array.
616         for (uint256 i = 0; i < totalHashes; i++) {
617             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
618             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
619             hashes[i] = _hashPair(a, b);
620         }
621 
622         if (totalHashes > 0) {
623             return hashes[totalHashes - 1];
624         } else if (leavesLen > 0) {
625             return leaves[0];
626         } else {
627             return proof[0];
628         }
629     }
630 
631     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
632         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
633     }
634 
635     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
636         /// @solidity memory-safe-assembly
637         assembly {
638             mstore(0x00, a)
639             mstore(0x20, b)
640             value := keccak256(0x00, 0x40)
641         }
642     }
643 }
644 
645 // File: @openzeppelin/contracts/access/IAccessControl.sol
646 
647 
648 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 /**
653  * @dev External interface of AccessControl declared to support ERC165 detection.
654  */
655 interface IAccessControl {
656     /**
657      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
658      *
659      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
660      * {RoleAdminChanged} not being emitted signaling this.
661      *
662      * _Available since v3.1._
663      */
664     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
665 
666     /**
667      * @dev Emitted when `account` is granted `role`.
668      *
669      * `sender` is the account that originated the contract call, an admin role
670      * bearer except when using {AccessControl-_setupRole}.
671      */
672     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
673 
674     /**
675      * @dev Emitted when `account` is revoked `role`.
676      *
677      * `sender` is the account that originated the contract call:
678      *   - if using `revokeRole`, it is the admin role bearer
679      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
680      */
681     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
682 
683     /**
684      * @dev Returns `true` if `account` has been granted `role`.
685      */
686     function hasRole(bytes32 role, address account) external view returns (bool);
687 
688     /**
689      * @dev Returns the admin role that controls `role`. See {grantRole} and
690      * {revokeRole}.
691      *
692      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
693      */
694     function getRoleAdmin(bytes32 role) external view returns (bytes32);
695 
696     /**
697      * @dev Grants `role` to `account`.
698      *
699      * If `account` had not been already granted `role`, emits a {RoleGranted}
700      * event.
701      *
702      * Requirements:
703      *
704      * - the caller must have ``role``'s admin role.
705      */
706     function grantRole(bytes32 role, address account) external;
707 
708     /**
709      * @dev Revokes `role` from `account`.
710      *
711      * If `account` had been granted `role`, emits a {RoleRevoked} event.
712      *
713      * Requirements:
714      *
715      * - the caller must have ``role``'s admin role.
716      */
717     function revokeRole(bytes32 role, address account) external;
718 
719     /**
720      * @dev Revokes `role` from the calling account.
721      *
722      * Roles are often managed via {grantRole} and {revokeRole}: this function's
723      * purpose is to provide a mechanism for accounts to lose their privileges
724      * if they are compromised (such as when a trusted device is misplaced).
725      *
726      * If the calling account had been granted `role`, emits a {RoleRevoked}
727      * event.
728      *
729      * Requirements:
730      *
731      * - the caller must be `account`.
732      */
733     function renounceRole(bytes32 role, address account) external;
734 }
735 
736 // File: contract-allow-list/contracts/proxy/interface/IContractAllowListProxy.sol
737 
738 
739 pragma solidity >=0.7.0 <0.9.0;
740 
741 interface IContractAllowListProxy {
742     function isAllowed(address _transferer, uint256 _level)
743         external
744         view
745         returns (bool);
746 }
747 
748 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
749 
750 
751 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
752 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
753 
754 pragma solidity ^0.8.0;
755 
756 /**
757  * @dev Library for managing
758  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
759  * types.
760  *
761  * Sets have the following properties:
762  *
763  * - Elements are added, removed, and checked for existence in constant time
764  * (O(1)).
765  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
766  *
767  * ```
768  * contract Example {
769  *     // Add the library methods
770  *     using EnumerableSet for EnumerableSet.AddressSet;
771  *
772  *     // Declare a set state variable
773  *     EnumerableSet.AddressSet private mySet;
774  * }
775  * ```
776  *
777  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
778  * and `uint256` (`UintSet`) are supported.
779  *
780  * [WARNING]
781  * ====
782  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
783  * unusable.
784  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
785  *
786  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
787  * array of EnumerableSet.
788  * ====
789  */
790 library EnumerableSet {
791     // To implement this library for multiple types with as little code
792     // repetition as possible, we write it in terms of a generic Set type with
793     // bytes32 values.
794     // The Set implementation uses private functions, and user-facing
795     // implementations (such as AddressSet) are just wrappers around the
796     // underlying Set.
797     // This means that we can only create new EnumerableSets for types that fit
798     // in bytes32.
799 
800     struct Set {
801         // Storage of set values
802         bytes32[] _values;
803         // Position of the value in the `values` array, plus 1 because index 0
804         // means a value is not in the set.
805         mapping(bytes32 => uint256) _indexes;
806     }
807 
808     /**
809      * @dev Add a value to a set. O(1).
810      *
811      * Returns true if the value was added to the set, that is if it was not
812      * already present.
813      */
814     function _add(Set storage set, bytes32 value) private returns (bool) {
815         if (!_contains(set, value)) {
816             set._values.push(value);
817             // The value is stored at length-1, but we add 1 to all indexes
818             // and use 0 as a sentinel value
819             set._indexes[value] = set._values.length;
820             return true;
821         } else {
822             return false;
823         }
824     }
825 
826     /**
827      * @dev Removes a value from a set. O(1).
828      *
829      * Returns true if the value was removed from the set, that is if it was
830      * present.
831      */
832     function _remove(Set storage set, bytes32 value) private returns (bool) {
833         // We read and store the value's index to prevent multiple reads from the same storage slot
834         uint256 valueIndex = set._indexes[value];
835 
836         if (valueIndex != 0) {
837             // Equivalent to contains(set, value)
838             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
839             // the array, and then remove the last element (sometimes called as 'swap and pop').
840             // This modifies the order of the array, as noted in {at}.
841 
842             uint256 toDeleteIndex = valueIndex - 1;
843             uint256 lastIndex = set._values.length - 1;
844 
845             if (lastIndex != toDeleteIndex) {
846                 bytes32 lastValue = set._values[lastIndex];
847 
848                 // Move the last value to the index where the value to delete is
849                 set._values[toDeleteIndex] = lastValue;
850                 // Update the index for the moved value
851                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
852             }
853 
854             // Delete the slot where the moved value was stored
855             set._values.pop();
856 
857             // Delete the index for the deleted slot
858             delete set._indexes[value];
859 
860             return true;
861         } else {
862             return false;
863         }
864     }
865 
866     /**
867      * @dev Returns true if the value is in the set. O(1).
868      */
869     function _contains(Set storage set, bytes32 value) private view returns (bool) {
870         return set._indexes[value] != 0;
871     }
872 
873     /**
874      * @dev Returns the number of values on the set. O(1).
875      */
876     function _length(Set storage set) private view returns (uint256) {
877         return set._values.length;
878     }
879 
880     /**
881      * @dev Returns the value stored at position `index` in the set. O(1).
882      *
883      * Note that there are no guarantees on the ordering of values inside the
884      * array, and it may change when more values are added or removed.
885      *
886      * Requirements:
887      *
888      * - `index` must be strictly less than {length}.
889      */
890     function _at(Set storage set, uint256 index) private view returns (bytes32) {
891         return set._values[index];
892     }
893 
894     /**
895      * @dev Return the entire set in an array
896      *
897      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
898      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
899      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
900      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
901      */
902     function _values(Set storage set) private view returns (bytes32[] memory) {
903         return set._values;
904     }
905 
906     // Bytes32Set
907 
908     struct Bytes32Set {
909         Set _inner;
910     }
911 
912     /**
913      * @dev Add a value to a set. O(1).
914      *
915      * Returns true if the value was added to the set, that is if it was not
916      * already present.
917      */
918     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
919         return _add(set._inner, value);
920     }
921 
922     /**
923      * @dev Removes a value from a set. O(1).
924      *
925      * Returns true if the value was removed from the set, that is if it was
926      * present.
927      */
928     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
929         return _remove(set._inner, value);
930     }
931 
932     /**
933      * @dev Returns true if the value is in the set. O(1).
934      */
935     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
936         return _contains(set._inner, value);
937     }
938 
939     /**
940      * @dev Returns the number of values in the set. O(1).
941      */
942     function length(Bytes32Set storage set) internal view returns (uint256) {
943         return _length(set._inner);
944     }
945 
946     /**
947      * @dev Returns the value stored at position `index` in the set. O(1).
948      *
949      * Note that there are no guarantees on the ordering of values inside the
950      * array, and it may change when more values are added or removed.
951      *
952      * Requirements:
953      *
954      * - `index` must be strictly less than {length}.
955      */
956     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
957         return _at(set._inner, index);
958     }
959 
960     /**
961      * @dev Return the entire set in an array
962      *
963      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
964      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
965      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
966      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
967      */
968     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
969         bytes32[] memory store = _values(set._inner);
970         bytes32[] memory result;
971 
972         /// @solidity memory-safe-assembly
973         assembly {
974             result := store
975         }
976 
977         return result;
978     }
979 
980     // AddressSet
981 
982     struct AddressSet {
983         Set _inner;
984     }
985 
986     /**
987      * @dev Add a value to a set. O(1).
988      *
989      * Returns true if the value was added to the set, that is if it was not
990      * already present.
991      */
992     function add(AddressSet storage set, address value) internal returns (bool) {
993         return _add(set._inner, bytes32(uint256(uint160(value))));
994     }
995 
996     /**
997      * @dev Removes a value from a set. O(1).
998      *
999      * Returns true if the value was removed from the set, that is if it was
1000      * present.
1001      */
1002     function remove(AddressSet storage set, address value) internal returns (bool) {
1003         return _remove(set._inner, bytes32(uint256(uint160(value))));
1004     }
1005 
1006     /**
1007      * @dev Returns true if the value is in the set. O(1).
1008      */
1009     function contains(AddressSet storage set, address value) internal view returns (bool) {
1010         return _contains(set._inner, bytes32(uint256(uint160(value))));
1011     }
1012 
1013     /**
1014      * @dev Returns the number of values in the set. O(1).
1015      */
1016     function length(AddressSet storage set) internal view returns (uint256) {
1017         return _length(set._inner);
1018     }
1019 
1020     /**
1021      * @dev Returns the value stored at position `index` in the set. O(1).
1022      *
1023      * Note that there are no guarantees on the ordering of values inside the
1024      * array, and it may change when more values are added or removed.
1025      *
1026      * Requirements:
1027      *
1028      * - `index` must be strictly less than {length}.
1029      */
1030     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1031         return address(uint160(uint256(_at(set._inner, index))));
1032     }
1033 
1034     /**
1035      * @dev Return the entire set in an array
1036      *
1037      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1038      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1039      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1040      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1041      */
1042     function values(AddressSet storage set) internal view returns (address[] memory) {
1043         bytes32[] memory store = _values(set._inner);
1044         address[] memory result;
1045 
1046         /// @solidity memory-safe-assembly
1047         assembly {
1048             result := store
1049         }
1050 
1051         return result;
1052     }
1053 
1054     // UintSet
1055 
1056     struct UintSet {
1057         Set _inner;
1058     }
1059 
1060     /**
1061      * @dev Add a value to a set. O(1).
1062      *
1063      * Returns true if the value was added to the set, that is if it was not
1064      * already present.
1065      */
1066     function add(UintSet storage set, uint256 value) internal returns (bool) {
1067         return _add(set._inner, bytes32(value));
1068     }
1069 
1070     /**
1071      * @dev Removes a value from a set. O(1).
1072      *
1073      * Returns true if the value was removed from the set, that is if it was
1074      * present.
1075      */
1076     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1077         return _remove(set._inner, bytes32(value));
1078     }
1079 
1080     /**
1081      * @dev Returns true if the value is in the set. O(1).
1082      */
1083     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1084         return _contains(set._inner, bytes32(value));
1085     }
1086 
1087     /**
1088      * @dev Returns the number of values in the set. O(1).
1089      */
1090     function length(UintSet storage set) internal view returns (uint256) {
1091         return _length(set._inner);
1092     }
1093 
1094     /**
1095      * @dev Returns the value stored at position `index` in the set. O(1).
1096      *
1097      * Note that there are no guarantees on the ordering of values inside the
1098      * array, and it may change when more values are added or removed.
1099      *
1100      * Requirements:
1101      *
1102      * - `index` must be strictly less than {length}.
1103      */
1104     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1105         return uint256(_at(set._inner, index));
1106     }
1107 
1108     /**
1109      * @dev Return the entire set in an array
1110      *
1111      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1112      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1113      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1114      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1115      */
1116     function values(UintSet storage set) internal view returns (uint256[] memory) {
1117         bytes32[] memory store = _values(set._inner);
1118         uint256[] memory result;
1119 
1120         /// @solidity memory-safe-assembly
1121         assembly {
1122             result := store
1123         }
1124 
1125         return result;
1126     }
1127 }
1128 
1129 // File: contract-allow-list/contracts/ERC721AntiScam/restrictApprove/IERC721RestrictApprove.sol
1130 
1131 
1132 pragma solidity >=0.8.0;
1133 
1134 /// @title IERC721RestrictApprove
1135 /// @dev Approve抑制機能付きコントラクトのインターフェース
1136 /// @author Lavulite
1137 
1138 interface IERC721RestrictApprove {
1139     /**
1140      * @dev CALレベルが変更された場合のイベント
1141      */
1142     event CalLevelChanged(address indexed operator, uint256 indexed level);
1143     
1144     /**
1145      * @dev LocalContractAllowListnに追加された場合のイベント
1146      */
1147     event LocalCalAdded(address indexed operator, address indexed transferer);
1148 
1149     /**
1150      * @dev LocalContractAllowListnに削除された場合のイベント
1151      */
1152     event LocalCalRemoved(address indexed operator, address indexed transferer);
1153 
1154     /**
1155      * @dev CALを利用する場合のCALのレベルを設定する。レベルが高いほど、許可されるコントラクトの範囲が狭い。
1156      */
1157     function setCALLevel(uint256 level) external;
1158 
1159     /**
1160      * @dev CALのアドレスをセットする。
1161      */
1162     function setCAL(address calAddress) external;
1163 
1164     /**
1165      * @dev CALのリストに無い独自の許可アドレスを追加する場合、こちらにアドレスを記載する。
1166      */
1167     function addLocalContractAllowList(address transferer) external;
1168 
1169     /**
1170      * @dev CALのリストにある独自の許可アドレスを削除する場合、こちらにアドレスを記載する。
1171      */
1172     function removeLocalContractAllowList(address transferer) external;
1173 
1174     /**
1175      * @dev CALのリストにある独自の許可アドレスの一覧を取得する。
1176      */
1177     function getLocalContractAllowList() external view returns(address[] memory);
1178 
1179 }
1180 
1181 // File: @openzeppelin/contracts/utils/StorageSlot.sol
1182 
1183 
1184 // OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 /**
1189  * @dev Library for reading and writing primitive types to specific storage slots.
1190  *
1191  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
1192  * This library helps with reading and writing to such slots without the need for inline assembly.
1193  *
1194  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
1195  *
1196  * Example usage to set ERC1967 implementation slot:
1197  * ```
1198  * contract ERC1967 {
1199  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
1200  *
1201  *     function _getImplementation() internal view returns (address) {
1202  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
1203  *     }
1204  *
1205  *     function _setImplementation(address newImplementation) internal {
1206  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
1207  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
1208  *     }
1209  * }
1210  * ```
1211  *
1212  * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
1213  */
1214 library StorageSlot {
1215     struct AddressSlot {
1216         address value;
1217     }
1218 
1219     struct BooleanSlot {
1220         bool value;
1221     }
1222 
1223     struct Bytes32Slot {
1224         bytes32 value;
1225     }
1226 
1227     struct Uint256Slot {
1228         uint256 value;
1229     }
1230 
1231     /**
1232      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
1233      */
1234     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
1235         /// @solidity memory-safe-assembly
1236         assembly {
1237             r.slot := slot
1238         }
1239     }
1240 
1241     /**
1242      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
1243      */
1244     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
1245         /// @solidity memory-safe-assembly
1246         assembly {
1247             r.slot := slot
1248         }
1249     }
1250 
1251     /**
1252      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
1253      */
1254     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
1255         /// @solidity memory-safe-assembly
1256         assembly {
1257             r.slot := slot
1258         }
1259     }
1260 
1261     /**
1262      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
1263      */
1264     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
1265         /// @solidity memory-safe-assembly
1266         assembly {
1267             r.slot := slot
1268         }
1269     }
1270 }
1271 
1272 // File: @openzeppelin/contracts/utils/Address.sol
1273 
1274 
1275 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1276 
1277 pragma solidity ^0.8.1;
1278 
1279 /**
1280  * @dev Collection of functions related to the address type
1281  */
1282 library Address {
1283     /**
1284      * @dev Returns true if `account` is a contract.
1285      *
1286      * [IMPORTANT]
1287      * ====
1288      * It is unsafe to assume that an address for which this function returns
1289      * false is an externally-owned account (EOA) and not a contract.
1290      *
1291      * Among others, `isContract` will return false for the following
1292      * types of addresses:
1293      *
1294      *  - an externally-owned account
1295      *  - a contract in construction
1296      *  - an address where a contract will be created
1297      *  - an address where a contract lived, but was destroyed
1298      * ====
1299      *
1300      * [IMPORTANT]
1301      * ====
1302      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1303      *
1304      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1305      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1306      * constructor.
1307      * ====
1308      */
1309     function isContract(address account) internal view returns (bool) {
1310         // This method relies on extcodesize/address.code.length, which returns 0
1311         // for contracts in construction, since the code is only stored at the end
1312         // of the constructor execution.
1313 
1314         return account.code.length > 0;
1315     }
1316 
1317     /**
1318      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1319      * `recipient`, forwarding all available gas and reverting on errors.
1320      *
1321      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1322      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1323      * imposed by `transfer`, making them unable to receive funds via
1324      * `transfer`. {sendValue} removes this limitation.
1325      *
1326      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1327      *
1328      * IMPORTANT: because control is transferred to `recipient`, care must be
1329      * taken to not create reentrancy vulnerabilities. Consider using
1330      * {ReentrancyGuard} or the
1331      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1332      */
1333     function sendValue(address payable recipient, uint256 amount) internal {
1334         require(address(this).balance >= amount, "Address: insufficient balance");
1335 
1336         (bool success, ) = recipient.call{value: amount}("");
1337         require(success, "Address: unable to send value, recipient may have reverted");
1338     }
1339 
1340     /**
1341      * @dev Performs a Solidity function call using a low level `call`. A
1342      * plain `call` is an unsafe replacement for a function call: use this
1343      * function instead.
1344      *
1345      * If `target` reverts with a revert reason, it is bubbled up by this
1346      * function (like regular Solidity function calls).
1347      *
1348      * Returns the raw returned data. To convert to the expected return value,
1349      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1350      *
1351      * Requirements:
1352      *
1353      * - `target` must be a contract.
1354      * - calling `target` with `data` must not revert.
1355      *
1356      * _Available since v3.1._
1357      */
1358     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1359         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1360     }
1361 
1362     /**
1363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1364      * `errorMessage` as a fallback revert reason when `target` reverts.
1365      *
1366      * _Available since v3.1._
1367      */
1368     function functionCall(
1369         address target,
1370         bytes memory data,
1371         string memory errorMessage
1372     ) internal returns (bytes memory) {
1373         return functionCallWithValue(target, data, 0, errorMessage);
1374     }
1375 
1376     /**
1377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1378      * but also transferring `value` wei to `target`.
1379      *
1380      * Requirements:
1381      *
1382      * - the calling contract must have an ETH balance of at least `value`.
1383      * - the called Solidity function must be `payable`.
1384      *
1385      * _Available since v3.1._
1386      */
1387     function functionCallWithValue(
1388         address target,
1389         bytes memory data,
1390         uint256 value
1391     ) internal returns (bytes memory) {
1392         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1393     }
1394 
1395     /**
1396      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1397      * with `errorMessage` as a fallback revert reason when `target` reverts.
1398      *
1399      * _Available since v3.1._
1400      */
1401     function functionCallWithValue(
1402         address target,
1403         bytes memory data,
1404         uint256 value,
1405         string memory errorMessage
1406     ) internal returns (bytes memory) {
1407         require(address(this).balance >= value, "Address: insufficient balance for call");
1408         (bool success, bytes memory returndata) = target.call{value: value}(data);
1409         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1410     }
1411 
1412     /**
1413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1414      * but performing a static call.
1415      *
1416      * _Available since v3.3._
1417      */
1418     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1419         return functionStaticCall(target, data, "Address: low-level static call failed");
1420     }
1421 
1422     /**
1423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1424      * but performing a static call.
1425      *
1426      * _Available since v3.3._
1427      */
1428     function functionStaticCall(
1429         address target,
1430         bytes memory data,
1431         string memory errorMessage
1432     ) internal view returns (bytes memory) {
1433         (bool success, bytes memory returndata) = target.staticcall(data);
1434         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1435     }
1436 
1437     /**
1438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1439      * but performing a delegate call.
1440      *
1441      * _Available since v3.4._
1442      */
1443     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1444         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1445     }
1446 
1447     /**
1448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1449      * but performing a delegate call.
1450      *
1451      * _Available since v3.4._
1452      */
1453     function functionDelegateCall(
1454         address target,
1455         bytes memory data,
1456         string memory errorMessage
1457     ) internal returns (bytes memory) {
1458         (bool success, bytes memory returndata) = target.delegatecall(data);
1459         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1460     }
1461 
1462     /**
1463      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1464      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1465      *
1466      * _Available since v4.8._
1467      */
1468     function verifyCallResultFromTarget(
1469         address target,
1470         bool success,
1471         bytes memory returndata,
1472         string memory errorMessage
1473     ) internal view returns (bytes memory) {
1474         if (success) {
1475             if (returndata.length == 0) {
1476                 // only check isContract if the call was successful and the return data is empty
1477                 // otherwise we already know that it was a contract
1478                 require(isContract(target), "Address: call to non-contract");
1479             }
1480             return returndata;
1481         } else {
1482             _revert(returndata, errorMessage);
1483         }
1484     }
1485 
1486     /**
1487      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1488      * revert reason or using the provided one.
1489      *
1490      * _Available since v4.3._
1491      */
1492     function verifyCallResult(
1493         bool success,
1494         bytes memory returndata,
1495         string memory errorMessage
1496     ) internal pure returns (bytes memory) {
1497         if (success) {
1498             return returndata;
1499         } else {
1500             _revert(returndata, errorMessage);
1501         }
1502     }
1503 
1504     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1505         // Look for revert reason and bubble it up if present
1506         if (returndata.length > 0) {
1507             // The easiest way to bubble the revert reason is using memory via assembly
1508             /// @solidity memory-safe-assembly
1509             assembly {
1510                 let returndata_size := mload(returndata)
1511                 revert(add(32, returndata), returndata_size)
1512             }
1513         } else {
1514             revert(errorMessage);
1515         }
1516     }
1517 }
1518 
1519 // File: @openzeppelin/contracts/utils/math/Math.sol
1520 
1521 
1522 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1523 
1524 pragma solidity ^0.8.0;
1525 
1526 /**
1527  * @dev Standard math utilities missing in the Solidity language.
1528  */
1529 library Math {
1530     enum Rounding {
1531         Down, // Toward negative infinity
1532         Up, // Toward infinity
1533         Zero // Toward zero
1534     }
1535 
1536     /**
1537      * @dev Returns the largest of two numbers.
1538      */
1539     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1540         return a > b ? a : b;
1541     }
1542 
1543     /**
1544      * @dev Returns the smallest of two numbers.
1545      */
1546     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1547         return a < b ? a : b;
1548     }
1549 
1550     /**
1551      * @dev Returns the average of two numbers. The result is rounded towards
1552      * zero.
1553      */
1554     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1555         // (a + b) / 2 can overflow.
1556         return (a & b) + (a ^ b) / 2;
1557     }
1558 
1559     /**
1560      * @dev Returns the ceiling of the division of two numbers.
1561      *
1562      * This differs from standard division with `/` in that it rounds up instead
1563      * of rounding down.
1564      */
1565     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1566         // (a + b - 1) / b can overflow on addition, so we distribute.
1567         return a == 0 ? 0 : (a - 1) / b + 1;
1568     }
1569 
1570     /**
1571      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1572      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1573      * with further edits by Uniswap Labs also under MIT license.
1574      */
1575     function mulDiv(
1576         uint256 x,
1577         uint256 y,
1578         uint256 denominator
1579     ) internal pure returns (uint256 result) {
1580         unchecked {
1581             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1582             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1583             // variables such that product = prod1 * 2^256 + prod0.
1584             uint256 prod0; // Least significant 256 bits of the product
1585             uint256 prod1; // Most significant 256 bits of the product
1586             assembly {
1587                 let mm := mulmod(x, y, not(0))
1588                 prod0 := mul(x, y)
1589                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1590             }
1591 
1592             // Handle non-overflow cases, 256 by 256 division.
1593             if (prod1 == 0) {
1594                 return prod0 / denominator;
1595             }
1596 
1597             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1598             require(denominator > prod1);
1599 
1600             ///////////////////////////////////////////////
1601             // 512 by 256 division.
1602             ///////////////////////////////////////////////
1603 
1604             // Make division exact by subtracting the remainder from [prod1 prod0].
1605             uint256 remainder;
1606             assembly {
1607                 // Compute remainder using mulmod.
1608                 remainder := mulmod(x, y, denominator)
1609 
1610                 // Subtract 256 bit number from 512 bit number.
1611                 prod1 := sub(prod1, gt(remainder, prod0))
1612                 prod0 := sub(prod0, remainder)
1613             }
1614 
1615             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1616             // See https://cs.stackexchange.com/q/138556/92363.
1617 
1618             // Does not overflow because the denominator cannot be zero at this stage in the function.
1619             uint256 twos = denominator & (~denominator + 1);
1620             assembly {
1621                 // Divide denominator by twos.
1622                 denominator := div(denominator, twos)
1623 
1624                 // Divide [prod1 prod0] by twos.
1625                 prod0 := div(prod0, twos)
1626 
1627                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1628                 twos := add(div(sub(0, twos), twos), 1)
1629             }
1630 
1631             // Shift in bits from prod1 into prod0.
1632             prod0 |= prod1 * twos;
1633 
1634             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1635             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1636             // four bits. That is, denominator * inv = 1 mod 2^4.
1637             uint256 inverse = (3 * denominator) ^ 2;
1638 
1639             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1640             // in modular arithmetic, doubling the correct bits in each step.
1641             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1642             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1643             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1644             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1645             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1646             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1647 
1648             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1649             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1650             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1651             // is no longer required.
1652             result = prod0 * inverse;
1653             return result;
1654         }
1655     }
1656 
1657     /**
1658      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1659      */
1660     function mulDiv(
1661         uint256 x,
1662         uint256 y,
1663         uint256 denominator,
1664         Rounding rounding
1665     ) internal pure returns (uint256) {
1666         uint256 result = mulDiv(x, y, denominator);
1667         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1668             result += 1;
1669         }
1670         return result;
1671     }
1672 
1673     /**
1674      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1675      *
1676      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1677      */
1678     function sqrt(uint256 a) internal pure returns (uint256) {
1679         if (a == 0) {
1680             return 0;
1681         }
1682 
1683         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1684         //
1685         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1686         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1687         //
1688         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1689         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1690         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1691         //
1692         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1693         uint256 result = 1 << (log2(a) >> 1);
1694 
1695         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1696         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1697         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1698         // into the expected uint128 result.
1699         unchecked {
1700             result = (result + a / result) >> 1;
1701             result = (result + a / result) >> 1;
1702             result = (result + a / result) >> 1;
1703             result = (result + a / result) >> 1;
1704             result = (result + a / result) >> 1;
1705             result = (result + a / result) >> 1;
1706             result = (result + a / result) >> 1;
1707             return min(result, a / result);
1708         }
1709     }
1710 
1711     /**
1712      * @notice Calculates sqrt(a), following the selected rounding direction.
1713      */
1714     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1715         unchecked {
1716             uint256 result = sqrt(a);
1717             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1718         }
1719     }
1720 
1721     /**
1722      * @dev Return the log in base 2, rounded down, of a positive value.
1723      * Returns 0 if given 0.
1724      */
1725     function log2(uint256 value) internal pure returns (uint256) {
1726         uint256 result = 0;
1727         unchecked {
1728             if (value >> 128 > 0) {
1729                 value >>= 128;
1730                 result += 128;
1731             }
1732             if (value >> 64 > 0) {
1733                 value >>= 64;
1734                 result += 64;
1735             }
1736             if (value >> 32 > 0) {
1737                 value >>= 32;
1738                 result += 32;
1739             }
1740             if (value >> 16 > 0) {
1741                 value >>= 16;
1742                 result += 16;
1743             }
1744             if (value >> 8 > 0) {
1745                 value >>= 8;
1746                 result += 8;
1747             }
1748             if (value >> 4 > 0) {
1749                 value >>= 4;
1750                 result += 4;
1751             }
1752             if (value >> 2 > 0) {
1753                 value >>= 2;
1754                 result += 2;
1755             }
1756             if (value >> 1 > 0) {
1757                 result += 1;
1758             }
1759         }
1760         return result;
1761     }
1762 
1763     /**
1764      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1765      * Returns 0 if given 0.
1766      */
1767     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1768         unchecked {
1769             uint256 result = log2(value);
1770             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1771         }
1772     }
1773 
1774     /**
1775      * @dev Return the log in base 10, rounded down, of a positive value.
1776      * Returns 0 if given 0.
1777      */
1778     function log10(uint256 value) internal pure returns (uint256) {
1779         uint256 result = 0;
1780         unchecked {
1781             if (value >= 10**64) {
1782                 value /= 10**64;
1783                 result += 64;
1784             }
1785             if (value >= 10**32) {
1786                 value /= 10**32;
1787                 result += 32;
1788             }
1789             if (value >= 10**16) {
1790                 value /= 10**16;
1791                 result += 16;
1792             }
1793             if (value >= 10**8) {
1794                 value /= 10**8;
1795                 result += 8;
1796             }
1797             if (value >= 10**4) {
1798                 value /= 10**4;
1799                 result += 4;
1800             }
1801             if (value >= 10**2) {
1802                 value /= 10**2;
1803                 result += 2;
1804             }
1805             if (value >= 10**1) {
1806                 result += 1;
1807             }
1808         }
1809         return result;
1810     }
1811 
1812     /**
1813      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1814      * Returns 0 if given 0.
1815      */
1816     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1817         unchecked {
1818             uint256 result = log10(value);
1819             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1820         }
1821     }
1822 
1823     /**
1824      * @dev Return the log in base 256, rounded down, of a positive value.
1825      * Returns 0 if given 0.
1826      *
1827      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1828      */
1829     function log256(uint256 value) internal pure returns (uint256) {
1830         uint256 result = 0;
1831         unchecked {
1832             if (value >> 128 > 0) {
1833                 value >>= 128;
1834                 result += 16;
1835             }
1836             if (value >> 64 > 0) {
1837                 value >>= 64;
1838                 result += 8;
1839             }
1840             if (value >> 32 > 0) {
1841                 value >>= 32;
1842                 result += 4;
1843             }
1844             if (value >> 16 > 0) {
1845                 value >>= 16;
1846                 result += 2;
1847             }
1848             if (value >> 8 > 0) {
1849                 result += 1;
1850             }
1851         }
1852         return result;
1853     }
1854 
1855     /**
1856      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1857      * Returns 0 if given 0.
1858      */
1859     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1860         unchecked {
1861             uint256 result = log256(value);
1862             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1863         }
1864     }
1865 }
1866 
1867 // File: @openzeppelin/contracts/utils/Strings.sol
1868 
1869 
1870 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1871 
1872 pragma solidity ^0.8.0;
1873 
1874 
1875 /**
1876  * @dev String operations.
1877  */
1878 library Strings {
1879     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1880     uint8 private constant _ADDRESS_LENGTH = 20;
1881 
1882     /**
1883      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1884      */
1885     function toString(uint256 value) internal pure returns (string memory) {
1886         unchecked {
1887             uint256 length = Math.log10(value) + 1;
1888             string memory buffer = new string(length);
1889             uint256 ptr;
1890             /// @solidity memory-safe-assembly
1891             assembly {
1892                 ptr := add(buffer, add(32, length))
1893             }
1894             while (true) {
1895                 ptr--;
1896                 /// @solidity memory-safe-assembly
1897                 assembly {
1898                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1899                 }
1900                 value /= 10;
1901                 if (value == 0) break;
1902             }
1903             return buffer;
1904         }
1905     }
1906 
1907     /**
1908      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1909      */
1910     function toHexString(uint256 value) internal pure returns (string memory) {
1911         unchecked {
1912             return toHexString(value, Math.log256(value) + 1);
1913         }
1914     }
1915 
1916     /**
1917      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1918      */
1919     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1920         bytes memory buffer = new bytes(2 * length + 2);
1921         buffer[0] = "0";
1922         buffer[1] = "x";
1923         for (uint256 i = 2 * length + 1; i > 1; --i) {
1924             buffer[i] = _SYMBOLS[value & 0xf];
1925             value >>= 4;
1926         }
1927         require(value == 0, "Strings: hex length insufficient");
1928         return string(buffer);
1929     }
1930 
1931     /**
1932      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1933      */
1934     function toHexString(address addr) internal pure returns (string memory) {
1935         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1936     }
1937 }
1938 
1939 // File: @openzeppelin/contracts/utils/Context.sol
1940 
1941 
1942 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1943 
1944 pragma solidity ^0.8.0;
1945 
1946 /**
1947  * @dev Provides information about the current execution context, including the
1948  * sender of the transaction and its data. While these are generally available
1949  * via msg.sender and msg.data, they should not be accessed in such a direct
1950  * manner, since when dealing with meta-transactions the account sending and
1951  * paying for execution may not be the actual sender (as far as an application
1952  * is concerned).
1953  *
1954  * This contract is only required for intermediate, library-like contracts.
1955  */
1956 abstract contract Context {
1957     function _msgSender() internal view virtual returns (address) {
1958         return msg.sender;
1959     }
1960 
1961     function _msgData() internal view virtual returns (bytes calldata) {
1962         return msg.data;
1963     }
1964 }
1965 
1966 // File: @openzeppelin/contracts/access/Ownable.sol
1967 
1968 
1969 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1970 
1971 pragma solidity ^0.8.0;
1972 
1973 
1974 /**
1975  * @dev Contract module which provides a basic access control mechanism, where
1976  * there is an account (an owner) that can be granted exclusive access to
1977  * specific functions.
1978  *
1979  * By default, the owner account will be the one that deploys the contract. This
1980  * can later be changed with {transferOwnership}.
1981  *
1982  * This module is used through inheritance. It will make available the modifier
1983  * `onlyOwner`, which can be applied to your functions to restrict their use to
1984  * the owner.
1985  */
1986 abstract contract Ownable is Context {
1987     address private _owner;
1988 
1989     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1990 
1991     /**
1992      * @dev Initializes the contract setting the deployer as the initial owner.
1993      */
1994     constructor() {
1995         _transferOwnership(_msgSender());
1996     }
1997 
1998     /**
1999      * @dev Throws if called by any account other than the owner.
2000      */
2001     modifier onlyOwner() {
2002         _checkOwner();
2003         _;
2004     }
2005 
2006     /**
2007      * @dev Returns the address of the current owner.
2008      */
2009     function owner() public view virtual returns (address) {
2010         return _owner;
2011     }
2012 
2013     /**
2014      * @dev Throws if the sender is not the owner.
2015      */
2016     function _checkOwner() internal view virtual {
2017         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2018     }
2019 
2020     /**
2021      * @dev Leaves the contract without owner. It will not be possible to call
2022      * `onlyOwner` functions anymore. Can only be called by the current owner.
2023      *
2024      * NOTE: Renouncing ownership will leave the contract without an owner,
2025      * thereby removing any functionality that is only available to the owner.
2026      */
2027     function renounceOwnership() public virtual onlyOwner {
2028         _transferOwnership(address(0));
2029     }
2030 
2031     /**
2032      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2033      * Can only be called by the current owner.
2034      */
2035     function transferOwnership(address newOwner) public virtual onlyOwner {
2036         require(newOwner != address(0), "Ownable: new owner is the zero address");
2037         _transferOwnership(newOwner);
2038     }
2039 
2040     /**
2041      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2042      * Internal function without access restriction.
2043      */
2044     function _transferOwnership(address newOwner) internal virtual {
2045         address oldOwner = _owner;
2046         _owner = newOwner;
2047         emit OwnershipTransferred(oldOwner, newOwner);
2048     }
2049 }
2050 
2051 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2052 
2053 
2054 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2055 
2056 pragma solidity ^0.8.0;
2057 
2058 /**
2059  * @title ERC721 token receiver interface
2060  * @dev Interface for any contract that wants to support safeTransfers
2061  * from ERC721 asset contracts.
2062  */
2063 interface IERC721Receiver {
2064     /**
2065      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2066      * by `operator` from `from`, this function is called.
2067      *
2068      * It must return its Solidity selector to confirm the token transfer.
2069      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2070      *
2071      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2072      */
2073     function onERC721Received(
2074         address operator,
2075         address from,
2076         uint256 tokenId,
2077         bytes calldata data
2078     ) external returns (bytes4);
2079 }
2080 
2081 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2082 
2083 
2084 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2085 
2086 pragma solidity ^0.8.0;
2087 
2088 /**
2089  * @dev Interface of the ERC165 standard, as defined in the
2090  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2091  *
2092  * Implementers can declare support of contract interfaces, which can then be
2093  * queried by others ({ERC165Checker}).
2094  *
2095  * For an implementation, see {ERC165}.
2096  */
2097 interface IERC165 {
2098     /**
2099      * @dev Returns true if this contract implements the interface defined by
2100      * `interfaceId`. See the corresponding
2101      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2102      * to learn more about how these ids are created.
2103      *
2104      * This function call must use less than 30 000 gas.
2105      */
2106     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2107 }
2108 
2109 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
2110 
2111 
2112 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
2113 
2114 pragma solidity ^0.8.0;
2115 
2116 
2117 /**
2118  * @dev Interface for the NFT Royalty Standard.
2119  *
2120  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2121  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2122  *
2123  * _Available since v4.5._
2124  */
2125 interface IERC2981 is IERC165 {
2126     /**
2127      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2128      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2129      */
2130     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2131         external
2132         view
2133         returns (address receiver, uint256 royaltyAmount);
2134 }
2135 
2136 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2137 
2138 
2139 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2140 
2141 pragma solidity ^0.8.0;
2142 
2143 
2144 /**
2145  * @dev Implementation of the {IERC165} interface.
2146  *
2147  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2148  * for the additional interface id that will be supported. For example:
2149  *
2150  * ```solidity
2151  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2152  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2153  * }
2154  * ```
2155  *
2156  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2157  */
2158 abstract contract ERC165 is IERC165 {
2159     /**
2160      * @dev See {IERC165-supportsInterface}.
2161      */
2162     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2163         return interfaceId == type(IERC165).interfaceId;
2164     }
2165 }
2166 
2167 // File: @openzeppelin/contracts/token/common/ERC2981.sol
2168 
2169 
2170 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
2171 
2172 pragma solidity ^0.8.0;
2173 
2174 
2175 
2176 /**
2177  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2178  *
2179  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2180  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2181  *
2182  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2183  * fee is specified in basis points by default.
2184  *
2185  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2186  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2187  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2188  *
2189  * _Available since v4.5._
2190  */
2191 abstract contract ERC2981 is IERC2981, ERC165 {
2192     struct RoyaltyInfo {
2193         address receiver;
2194         uint96 royaltyFraction;
2195     }
2196 
2197     RoyaltyInfo private _defaultRoyaltyInfo;
2198     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2199 
2200     /**
2201      * @dev See {IERC165-supportsInterface}.
2202      */
2203     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2204         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2205     }
2206 
2207     /**
2208      * @inheritdoc IERC2981
2209      */
2210     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
2211         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
2212 
2213         if (royalty.receiver == address(0)) {
2214             royalty = _defaultRoyaltyInfo;
2215         }
2216 
2217         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
2218 
2219         return (royalty.receiver, royaltyAmount);
2220     }
2221 
2222     /**
2223      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2224      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2225      * override.
2226      */
2227     function _feeDenominator() internal pure virtual returns (uint96) {
2228         return 10000;
2229     }
2230 
2231     /**
2232      * @dev Sets the royalty information that all ids in this contract will default to.
2233      *
2234      * Requirements:
2235      *
2236      * - `receiver` cannot be the zero address.
2237      * - `feeNumerator` cannot be greater than the fee denominator.
2238      */
2239     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2240         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2241         require(receiver != address(0), "ERC2981: invalid receiver");
2242 
2243         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2244     }
2245 
2246     /**
2247      * @dev Removes default royalty information.
2248      */
2249     function _deleteDefaultRoyalty() internal virtual {
2250         delete _defaultRoyaltyInfo;
2251     }
2252 
2253     /**
2254      * @dev Sets the royalty information for a specific token id, overriding the global default.
2255      *
2256      * Requirements:
2257      *
2258      * - `receiver` cannot be the zero address.
2259      * - `feeNumerator` cannot be greater than the fee denominator.
2260      */
2261     function _setTokenRoyalty(
2262         uint256 tokenId,
2263         address receiver,
2264         uint96 feeNumerator
2265     ) internal virtual {
2266         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2267         require(receiver != address(0), "ERC2981: Invalid parameters");
2268 
2269         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2270     }
2271 
2272     /**
2273      * @dev Resets royalty information for the token id back to the global default.
2274      */
2275     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2276         delete _tokenRoyaltyInfo[tokenId];
2277     }
2278 }
2279 
2280 // File: @openzeppelin/contracts/access/AccessControl.sol
2281 
2282 
2283 // OpenZeppelin Contracts (last updated v4.8.0) (access/AccessControl.sol)
2284 
2285 pragma solidity ^0.8.0;
2286 
2287 
2288 
2289 
2290 
2291 /**
2292  * @dev Contract module that allows children to implement role-based access
2293  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
2294  * members except through off-chain means by accessing the contract event logs. Some
2295  * applications may benefit from on-chain enumerability, for those cases see
2296  * {AccessControlEnumerable}.
2297  *
2298  * Roles are referred to by their `bytes32` identifier. These should be exposed
2299  * in the external API and be unique. The best way to achieve this is by
2300  * using `public constant` hash digests:
2301  *
2302  * ```
2303  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
2304  * ```
2305  *
2306  * Roles can be used to represent a set of permissions. To restrict access to a
2307  * function call, use {hasRole}:
2308  *
2309  * ```
2310  * function foo() public {
2311  *     require(hasRole(MY_ROLE, msg.sender));
2312  *     ...
2313  * }
2314  * ```
2315  *
2316  * Roles can be granted and revoked dynamically via the {grantRole} and
2317  * {revokeRole} functions. Each role has an associated admin role, and only
2318  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
2319  *
2320  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
2321  * that only accounts with this role will be able to grant or revoke other
2322  * roles. More complex role relationships can be created by using
2323  * {_setRoleAdmin}.
2324  *
2325  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
2326  * grant and revoke this role. Extra precautions should be taken to secure
2327  * accounts that have been granted it.
2328  */
2329 abstract contract AccessControl is Context, IAccessControl, ERC165 {
2330     struct RoleData {
2331         mapping(address => bool) members;
2332         bytes32 adminRole;
2333     }
2334 
2335     mapping(bytes32 => RoleData) private _roles;
2336 
2337     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2338 
2339     /**
2340      * @dev Modifier that checks that an account has a specific role. Reverts
2341      * with a standardized message including the required role.
2342      *
2343      * The format of the revert reason is given by the following regular expression:
2344      *
2345      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2346      *
2347      * _Available since v4.1._
2348      */
2349     modifier onlyRole(bytes32 role) {
2350         _checkRole(role);
2351         _;
2352     }
2353 
2354     /**
2355      * @dev See {IERC165-supportsInterface}.
2356      */
2357     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2358         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2359     }
2360 
2361     /**
2362      * @dev Returns `true` if `account` has been granted `role`.
2363      */
2364     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
2365         return _roles[role].members[account];
2366     }
2367 
2368     /**
2369      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2370      * Overriding this function changes the behavior of the {onlyRole} modifier.
2371      *
2372      * Format of the revert message is described in {_checkRole}.
2373      *
2374      * _Available since v4.6._
2375      */
2376     function _checkRole(bytes32 role) internal view virtual {
2377         _checkRole(role, _msgSender());
2378     }
2379 
2380     /**
2381      * @dev Revert with a standard message if `account` is missing `role`.
2382      *
2383      * The format of the revert reason is given by the following regular expression:
2384      *
2385      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2386      */
2387     function _checkRole(bytes32 role, address account) internal view virtual {
2388         if (!hasRole(role, account)) {
2389             revert(
2390                 string(
2391                     abi.encodePacked(
2392                         "AccessControl: account ",
2393                         Strings.toHexString(account),
2394                         " is missing role ",
2395                         Strings.toHexString(uint256(role), 32)
2396                     )
2397                 )
2398             );
2399         }
2400     }
2401 
2402     /**
2403      * @dev Returns the admin role that controls `role`. See {grantRole} and
2404      * {revokeRole}.
2405      *
2406      * To change a role's admin, use {_setRoleAdmin}.
2407      */
2408     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
2409         return _roles[role].adminRole;
2410     }
2411 
2412     /**
2413      * @dev Grants `role` to `account`.
2414      *
2415      * If `account` had not been already granted `role`, emits a {RoleGranted}
2416      * event.
2417      *
2418      * Requirements:
2419      *
2420      * - the caller must have ``role``'s admin role.
2421      *
2422      * May emit a {RoleGranted} event.
2423      */
2424     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2425         _grantRole(role, account);
2426     }
2427 
2428     /**
2429      * @dev Revokes `role` from `account`.
2430      *
2431      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2432      *
2433      * Requirements:
2434      *
2435      * - the caller must have ``role``'s admin role.
2436      *
2437      * May emit a {RoleRevoked} event.
2438      */
2439     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2440         _revokeRole(role, account);
2441     }
2442 
2443     /**
2444      * @dev Revokes `role` from the calling account.
2445      *
2446      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2447      * purpose is to provide a mechanism for accounts to lose their privileges
2448      * if they are compromised (such as when a trusted device is misplaced).
2449      *
2450      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2451      * event.
2452      *
2453      * Requirements:
2454      *
2455      * - the caller must be `account`.
2456      *
2457      * May emit a {RoleRevoked} event.
2458      */
2459     function renounceRole(bytes32 role, address account) public virtual override {
2460         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2461 
2462         _revokeRole(role, account);
2463     }
2464 
2465     /**
2466      * @dev Grants `role` to `account`.
2467      *
2468      * If `account` had not been already granted `role`, emits a {RoleGranted}
2469      * event. Note that unlike {grantRole}, this function doesn't perform any
2470      * checks on the calling account.
2471      *
2472      * May emit a {RoleGranted} event.
2473      *
2474      * [WARNING]
2475      * ====
2476      * This function should only be called from the constructor when setting
2477      * up the initial roles for the system.
2478      *
2479      * Using this function in any other way is effectively circumventing the admin
2480      * system imposed by {AccessControl}.
2481      * ====
2482      *
2483      * NOTE: This function is deprecated in favor of {_grantRole}.
2484      */
2485     function _setupRole(bytes32 role, address account) internal virtual {
2486         _grantRole(role, account);
2487     }
2488 
2489     /**
2490      * @dev Sets `adminRole` as ``role``'s admin role.
2491      *
2492      * Emits a {RoleAdminChanged} event.
2493      */
2494     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2495         bytes32 previousAdminRole = getRoleAdmin(role);
2496         _roles[role].adminRole = adminRole;
2497         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2498     }
2499 
2500     /**
2501      * @dev Grants `role` to `account`.
2502      *
2503      * Internal function without access restriction.
2504      *
2505      * May emit a {RoleGranted} event.
2506      */
2507     function _grantRole(bytes32 role, address account) internal virtual {
2508         if (!hasRole(role, account)) {
2509             _roles[role].members[account] = true;
2510             emit RoleGranted(role, account, _msgSender());
2511         }
2512     }
2513 
2514     /**
2515      * @dev Revokes `role` from `account`.
2516      *
2517      * Internal function without access restriction.
2518      *
2519      * May emit a {RoleRevoked} event.
2520      */
2521     function _revokeRole(bytes32 role, address account) internal virtual {
2522         if (hasRole(role, account)) {
2523             _roles[role].members[account] = false;
2524             emit RoleRevoked(role, account, _msgSender());
2525         }
2526     }
2527 }
2528 
2529 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2530 
2531 
2532 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
2533 
2534 pragma solidity ^0.8.0;
2535 
2536 
2537 /**
2538  * @dev Required interface of an ERC721 compliant contract.
2539  */
2540 interface IERC721 is IERC165 {
2541     /**
2542      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2543      */
2544     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2545 
2546     /**
2547      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2548      */
2549     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2550 
2551     /**
2552      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2553      */
2554     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2555 
2556     /**
2557      * @dev Returns the number of tokens in ``owner``'s account.
2558      */
2559     function balanceOf(address owner) external view returns (uint256 balance);
2560 
2561     /**
2562      * @dev Returns the owner of the `tokenId` token.
2563      *
2564      * Requirements:
2565      *
2566      * - `tokenId` must exist.
2567      */
2568     function ownerOf(uint256 tokenId) external view returns (address owner);
2569 
2570     /**
2571      * @dev Safely transfers `tokenId` token from `from` to `to`.
2572      *
2573      * Requirements:
2574      *
2575      * - `from` cannot be the zero address.
2576      * - `to` cannot be the zero address.
2577      * - `tokenId` token must exist and be owned by `from`.
2578      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2580      *
2581      * Emits a {Transfer} event.
2582      */
2583     function safeTransferFrom(
2584         address from,
2585         address to,
2586         uint256 tokenId,
2587         bytes calldata data
2588     ) external;
2589 
2590     /**
2591      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2592      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2593      *
2594      * Requirements:
2595      *
2596      * - `from` cannot be the zero address.
2597      * - `to` cannot be the zero address.
2598      * - `tokenId` token must exist and be owned by `from`.
2599      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2600      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2601      *
2602      * Emits a {Transfer} event.
2603      */
2604     function safeTransferFrom(
2605         address from,
2606         address to,
2607         uint256 tokenId
2608     ) external;
2609 
2610     /**
2611      * @dev Transfers `tokenId` token from `from` to `to`.
2612      *
2613      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
2614      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
2615      * understand this adds an external call which potentially creates a reentrancy vulnerability.
2616      *
2617      * Requirements:
2618      *
2619      * - `from` cannot be the zero address.
2620      * - `to` cannot be the zero address.
2621      * - `tokenId` token must be owned by `from`.
2622      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2623      *
2624      * Emits a {Transfer} event.
2625      */
2626     function transferFrom(
2627         address from,
2628         address to,
2629         uint256 tokenId
2630     ) external;
2631 
2632     /**
2633      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2634      * The approval is cleared when the token is transferred.
2635      *
2636      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2637      *
2638      * Requirements:
2639      *
2640      * - The caller must own the token or be an approved operator.
2641      * - `tokenId` must exist.
2642      *
2643      * Emits an {Approval} event.
2644      */
2645     function approve(address to, uint256 tokenId) external;
2646 
2647     /**
2648      * @dev Approve or remove `operator` as an operator for the caller.
2649      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2650      *
2651      * Requirements:
2652      *
2653      * - The `operator` cannot be the caller.
2654      *
2655      * Emits an {ApprovalForAll} event.
2656      */
2657     function setApprovalForAll(address operator, bool _approved) external;
2658 
2659     /**
2660      * @dev Returns the account approved for `tokenId` token.
2661      *
2662      * Requirements:
2663      *
2664      * - `tokenId` must exist.
2665      */
2666     function getApproved(uint256 tokenId) external view returns (address operator);
2667 
2668     /**
2669      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2670      *
2671      * See {setApprovalForAll}
2672      */
2673     function isApprovedForAll(address owner, address operator) external view returns (bool);
2674 }
2675 
2676 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2677 
2678 
2679 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2680 
2681 pragma solidity ^0.8.0;
2682 
2683 
2684 /**
2685  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2686  * @dev See https://eips.ethereum.org/EIPS/eip-721
2687  */
2688 interface IERC721Metadata is IERC721 {
2689     /**
2690      * @dev Returns the token collection name.
2691      */
2692     function name() external view returns (string memory);
2693 
2694     /**
2695      * @dev Returns the token collection symbol.
2696      */
2697     function symbol() external view returns (string memory);
2698 
2699     /**
2700      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2701      */
2702     function tokenURI(uint256 tokenId) external view returns (string memory);
2703 }
2704 
2705 // File: solidity-bits/contracts/Popcount.sol
2706 
2707 
2708 /**
2709    _____       ___     ___ __           ____  _ __      
2710   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
2711   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
2712  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
2713 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
2714                            /____/                        
2715 
2716 - npm: https://www.npmjs.com/package/solidity-bits
2717 - github: https://github.com/estarriolvetch/solidity-bits
2718 
2719  */
2720 
2721 pragma solidity ^0.8.0;
2722 
2723 library Popcount {
2724     uint256 private constant m1 = 0x5555555555555555555555555555555555555555555555555555555555555555;
2725     uint256 private constant m2 = 0x3333333333333333333333333333333333333333333333333333333333333333;
2726     uint256 private constant m4 = 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f;
2727     uint256 private constant h01 = 0x0101010101010101010101010101010101010101010101010101010101010101;
2728 
2729     function popcount256A(uint256 x) internal pure returns (uint256 count) {
2730         unchecked{
2731             for (count=0; x!=0; count++)
2732                 x &= x - 1;
2733         }
2734     }
2735 
2736     function popcount256B(uint256 x) internal pure returns (uint256) {
2737         if (x == type(uint256).max) {
2738             return 256;
2739         }
2740         unchecked {
2741             x -= (x >> 1) & m1;             //put count of each 2 bits into those 2 bits
2742             x = (x & m2) + ((x >> 2) & m2); //put count of each 4 bits into those 4 bits 
2743             x = (x + (x >> 4)) & m4;        //put count of each 8 bits into those 8 bits 
2744             x = (x * h01) >> 248;  //returns left 8 bits of x + (x<<8) + (x<<16) + (x<<24) + ... 
2745         }
2746         return x;
2747     }
2748 }
2749 // File: solidity-bits/contracts/BitScan.sol
2750 
2751 
2752 /**
2753    _____       ___     ___ __           ____  _ __      
2754   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
2755   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
2756  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
2757 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
2758                            /____/                        
2759 
2760 - npm: https://www.npmjs.com/package/solidity-bits
2761 - github: https://github.com/estarriolvetch/solidity-bits
2762 
2763  */
2764 
2765 pragma solidity ^0.8.0;
2766 
2767 
2768 library BitScan {
2769     uint256 constant private DEBRUIJN_256 = 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
2770     bytes constant private LOOKUP_TABLE_256 = hex"0001020903110a19042112290b311a3905412245134d2a550c5d32651b6d3a7506264262237d468514804e8d2b95569d0d495ea533a966b11c886eb93bc176c9071727374353637324837e9b47af86c7155181ad4fd18ed32c9096db57d59ee30e2e4a6a5f92a6be3498aae067ddb2eb1d5989b56fd7baf33ca0c2ee77e5caf7ff0810182028303840444c545c646c7425617c847f8c949c48a4a8b087b8c0c816365272829aaec650acd0d28fdad4e22d6991bd97dfdcea58b4d6f29fede4f6fe0f1f2f3f4b5b6b607b8b93a3a7b7bf357199c5abcfd9e168bcdee9b3f1ecf5fd1e3e5a7a8aa2b670c4ced8bbe8f0f4fc3d79a1c3cde7effb78cce6facbf9f8";
2771 
2772     /**
2773         @dev Isolate the least significant set bit.
2774      */ 
2775     function isolateLS1B256(uint256 bb) pure internal returns (uint256) {
2776         require(bb > 0);
2777         unchecked {
2778             return bb & (0 - bb);
2779         }
2780     } 
2781 
2782     /**
2783         @dev Isolate the most significant set bit.
2784      */ 
2785     function isolateMS1B256(uint256 bb) pure internal returns (uint256) {
2786         require(bb > 0);
2787         unchecked {
2788             bb |= bb >> 128;
2789             bb |= bb >> 64;
2790             bb |= bb >> 32;
2791             bb |= bb >> 16;
2792             bb |= bb >> 8;
2793             bb |= bb >> 4;
2794             bb |= bb >> 2;
2795             bb |= bb >> 1;
2796             
2797             return (bb >> 1) + 1;
2798         }
2799     } 
2800 
2801     /**
2802         @dev Find the index of the lest significant set bit. (trailing zero count)
2803      */ 
2804     function bitScanForward256(uint256 bb) pure internal returns (uint8) {
2805         unchecked {
2806             return uint8(LOOKUP_TABLE_256[(isolateLS1B256(bb) * DEBRUIJN_256) >> 248]);
2807         }   
2808     }
2809 
2810     /**
2811         @dev Find the index of the most significant set bit.
2812      */ 
2813     function bitScanReverse256(uint256 bb) pure internal returns (uint8) {
2814         unchecked {
2815             return 255 - uint8(LOOKUP_TABLE_256[((isolateMS1B256(bb) * DEBRUIJN_256) >> 248)]);
2816         }   
2817     }
2818 
2819     function log2(uint256 bb) pure internal returns (uint8) {
2820         unchecked {
2821             return uint8(LOOKUP_TABLE_256[(isolateMS1B256(bb) * DEBRUIJN_256) >> 248]);
2822         } 
2823     }
2824 }
2825 
2826 // File: solidity-bits/contracts/BitMaps.sol
2827 
2828 
2829 /**
2830    _____       ___     ___ __           ____  _ __      
2831   / ___/____  / (_)___/ (_) /___  __   / __ )(_) /______
2832   \__ \/ __ \/ / / __  / / __/ / / /  / __  / / __/ ___/
2833  ___/ / /_/ / / / /_/ / / /_/ /_/ /  / /_/ / / /_(__  ) 
2834 /____/\____/_/_/\__,_/_/\__/\__, /  /_____/_/\__/____/  
2835                            /____/                        
2836 
2837 - npm: https://www.npmjs.com/package/solidity-bits
2838 - github: https://github.com/estarriolvetch/solidity-bits
2839 
2840  */
2841 pragma solidity ^0.8.0;
2842 
2843 
2844 
2845 /**
2846  * @dev This Library is a modified version of Openzeppelin's BitMaps library with extra features.
2847  *
2848  * 1. Functions of finding the index of the closest set bit from a given index are added.
2849  *    The indexing of each bucket is modifed to count from the MSB to the LSB instead of from the LSB to the MSB.
2850  *    The modification of indexing makes finding the closest previous set bit more efficient in gas usage.
2851  * 2. Setting and unsetting the bitmap consecutively.
2852  * 3. Accounting number of set bits within a given range.   
2853  *
2854 */
2855 
2856 /**
2857  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
2858  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
2859  */
2860 
2861 library BitMaps {
2862     using BitScan for uint256;
2863     uint256 private constant MASK_INDEX_ZERO = (1 << 255);
2864     uint256 private constant MASK_FULL = type(uint256).max;
2865 
2866     struct BitMap {
2867         mapping(uint256 => uint256) _data;
2868     }
2869 
2870     /**
2871      * @dev Returns whether the bit at `index` is set.
2872      */
2873     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
2874         uint256 bucket = index >> 8;
2875         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
2876         return bitmap._data[bucket] & mask != 0;
2877     }
2878 
2879     /**
2880      * @dev Sets the bit at `index` to the boolean `value`.
2881      */
2882     function setTo(
2883         BitMap storage bitmap,
2884         uint256 index,
2885         bool value
2886     ) internal {
2887         if (value) {
2888             set(bitmap, index);
2889         } else {
2890             unset(bitmap, index);
2891         }
2892     }
2893 
2894     /**
2895      * @dev Sets the bit at `index`.
2896      */
2897     function set(BitMap storage bitmap, uint256 index) internal {
2898         uint256 bucket = index >> 8;
2899         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
2900         bitmap._data[bucket] |= mask;
2901     }
2902 
2903     /**
2904      * @dev Unsets the bit at `index`.
2905      */
2906     function unset(BitMap storage bitmap, uint256 index) internal {
2907         uint256 bucket = index >> 8;
2908         uint256 mask = MASK_INDEX_ZERO >> (index & 0xff);
2909         bitmap._data[bucket] &= ~mask;
2910     }
2911 
2912 
2913     /**
2914      * @dev Consecutively sets `amount` of bits starting from the bit at `startIndex`.
2915      */    
2916     function setBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
2917         uint256 bucket = startIndex >> 8;
2918 
2919         uint256 bucketStartIndex = (startIndex & 0xff);
2920 
2921         unchecked {
2922             if(bucketStartIndex + amount < 256) {
2923                 bitmap._data[bucket] |= MASK_FULL << (256 - amount) >> bucketStartIndex;
2924             } else {
2925                 bitmap._data[bucket] |= MASK_FULL >> bucketStartIndex;
2926                 amount -= (256 - bucketStartIndex);
2927                 bucket++;
2928 
2929                 while(amount > 256) {
2930                     bitmap._data[bucket] = MASK_FULL;
2931                     amount -= 256;
2932                     bucket++;
2933                 }
2934 
2935                 bitmap._data[bucket] |= MASK_FULL << (256 - amount);
2936             }
2937         }
2938     }
2939 
2940 
2941     /**
2942      * @dev Consecutively unsets `amount` of bits starting from the bit at `startIndex`.
2943      */    
2944     function unsetBatch(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal {
2945         uint256 bucket = startIndex >> 8;
2946 
2947         uint256 bucketStartIndex = (startIndex & 0xff);
2948 
2949         unchecked {
2950             if(bucketStartIndex + amount < 256) {
2951                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount) >> bucketStartIndex);
2952             } else {
2953                 bitmap._data[bucket] &= ~(MASK_FULL >> bucketStartIndex);
2954                 amount -= (256 - bucketStartIndex);
2955                 bucket++;
2956 
2957                 while(amount > 256) {
2958                     bitmap._data[bucket] = 0;
2959                     amount -= 256;
2960                     bucket++;
2961                 }
2962 
2963                 bitmap._data[bucket] &= ~(MASK_FULL << (256 - amount));
2964             }
2965         }
2966     }
2967 
2968     /**
2969      * @dev Returns number of set bits within a range.
2970      */
2971     function popcountA(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
2972         uint256 bucket = startIndex >> 8;
2973 
2974         uint256 bucketStartIndex = (startIndex & 0xff);
2975 
2976         unchecked {
2977             if(bucketStartIndex + amount < 256) {
2978                 count +=  Popcount.popcount256A(
2979                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
2980                 );
2981             } else {
2982                 count += Popcount.popcount256A(
2983                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
2984                 );
2985                 amount -= (256 - bucketStartIndex);
2986                 bucket++;
2987 
2988                 while(amount > 256) {
2989                     count += Popcount.popcount256A(bitmap._data[bucket]);
2990                     amount -= 256;
2991                     bucket++;
2992                 }
2993                 count += Popcount.popcount256A(
2994                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
2995                 );
2996             }
2997         }
2998     }
2999 
3000     /**
3001      * @dev Returns number of set bits within a range.
3002      */
3003     function popcountB(BitMap storage bitmap, uint256 startIndex, uint256 amount) internal view returns(uint256 count) {
3004         uint256 bucket = startIndex >> 8;
3005 
3006         uint256 bucketStartIndex = (startIndex & 0xff);
3007 
3008         unchecked {
3009             if(bucketStartIndex + amount < 256) {
3010                 count +=  Popcount.popcount256B(
3011                     bitmap._data[bucket] & (MASK_FULL << (256 - amount) >> bucketStartIndex)
3012                 );
3013             } else {
3014                 count += Popcount.popcount256B(
3015                     bitmap._data[bucket] & (MASK_FULL >> bucketStartIndex)
3016                 );
3017                 amount -= (256 - bucketStartIndex);
3018                 bucket++;
3019 
3020                 while(amount > 256) {
3021                     count += Popcount.popcount256B(bitmap._data[bucket]);
3022                     amount -= 256;
3023                     bucket++;
3024                 }
3025                 count += Popcount.popcount256B(
3026                     bitmap._data[bucket] & (MASK_FULL << (256 - amount))
3027                 );
3028             }
3029         }
3030     }
3031 
3032 
3033     /**
3034      * @dev Find the closest index of the set bit before `index`.
3035      */
3036     function scanForward(BitMap storage bitmap, uint256 index) internal view returns (uint256 setBitIndex) {
3037         uint256 bucket = index >> 8;
3038 
3039         // index within the bucket
3040         uint256 bucketIndex = (index & 0xff);
3041 
3042         // load a bitboard from the bitmap.
3043         uint256 bb = bitmap._data[bucket];
3044 
3045         // offset the bitboard to scan from `bucketIndex`.
3046         bb = bb >> (0xff ^ bucketIndex); // bb >> (255 - bucketIndex)
3047         
3048         if(bb > 0) {
3049             unchecked {
3050                 setBitIndex = (bucket << 8) | (bucketIndex -  bb.bitScanForward256());    
3051             }
3052         } else {
3053             while(true) {
3054                 require(bucket > 0, "BitMaps: The set bit before the index doesn't exist.");
3055                 unchecked {
3056                     bucket--;
3057                 }
3058                 // No offset. Always scan from the least significiant bit now.
3059                 bb = bitmap._data[bucket];
3060                 
3061                 if(bb > 0) {
3062                     unchecked {
3063                         setBitIndex = (bucket << 8) | (255 -  bb.bitScanForward256());
3064                         break;
3065                     }
3066                 } 
3067             }
3068         }
3069     }
3070 
3071     function getBucket(BitMap storage bitmap, uint256 bucket) internal view returns (uint256) {
3072         return bitmap._data[bucket];
3073     }
3074 }
3075 
3076 // File: erc721psi/contracts/ERC721Psi.sol
3077 
3078 
3079 /**
3080   ______ _____   _____ ______ ___  __ _  _  _ 
3081  |  ____|  __ \ / ____|____  |__ \/_ | || || |
3082  | |__  | |__) | |        / /   ) || | \| |/ |
3083  |  __| |  _  /| |       / /   / / | |\_   _/ 
3084  | |____| | \ \| |____  / /   / /_ | |  | |   
3085  |______|_|  \_\\_____|/_/   |____||_|  |_|   
3086 
3087  - github: https://github.com/estarriolvetch/ERC721Psi
3088  - npm: https://www.npmjs.com/package/erc721psi
3089                                           
3090  */
3091 
3092 pragma solidity ^0.8.0;
3093 
3094 
3095 
3096 
3097 
3098 
3099 
3100 
3101 
3102 
3103 
3104 contract ERC721Psi is Context, ERC165, IERC721, IERC721Metadata {
3105     using Address for address;
3106     using Strings for uint256;
3107     using BitMaps for BitMaps.BitMap;
3108 
3109     BitMaps.BitMap private _batchHead;
3110 
3111     string private _name;
3112     string private _symbol;
3113 
3114     // Mapping from token ID to owner address
3115     mapping(uint256 => address) internal _owners;
3116     uint256 private _currentIndex;
3117 
3118     mapping(uint256 => address) private _tokenApprovals;
3119     mapping(address => mapping(address => bool)) private _operatorApprovals;
3120 
3121     /**
3122      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
3123      */
3124     constructor(string memory name_, string memory symbol_) {
3125         _name = name_;
3126         _symbol = symbol_;
3127         _currentIndex = _startTokenId();
3128     }
3129 
3130     /**
3131      * @dev Returns the starting token ID.
3132      * To change the starting token ID, please override this function.
3133      */
3134     function _startTokenId() internal pure returns (uint256) {
3135         // It will become modifiable in the future versions
3136         return 0;
3137     }
3138 
3139     /**
3140      * @dev Returns the next token ID to be minted.
3141      */
3142     function _nextTokenId() internal view virtual returns (uint256) {
3143         return _currentIndex;
3144     }
3145 
3146     /**
3147      * @dev Returns the total amount of tokens minted in the contract.
3148      */
3149     function _totalMinted() internal view virtual returns (uint256) {
3150         return _currentIndex - _startTokenId();
3151     }
3152 
3153 
3154     /**
3155      * @dev See {IERC165-supportsInterface}.
3156      */
3157     function supportsInterface(bytes4 interfaceId)
3158         public
3159         view
3160         virtual
3161         override(ERC165, IERC165)
3162         returns (bool)
3163     {
3164         return
3165             interfaceId == type(IERC721).interfaceId ||
3166             interfaceId == type(IERC721Metadata).interfaceId ||
3167             super.supportsInterface(interfaceId);
3168     }
3169 
3170     /**
3171      * @dev See {IERC721-balanceOf}.
3172      */
3173     function balanceOf(address owner) 
3174         public 
3175         view 
3176         virtual 
3177         override 
3178         returns (uint) 
3179     {
3180         require(owner != address(0), "ERC721Psi: balance query for the zero address");
3181 
3182         uint count;
3183         for( uint i = _startTokenId(); i < _nextTokenId(); ++i ){
3184             if(_exists(i)){
3185                 if( owner == ownerOf(i)){
3186                     ++count;
3187                 }
3188             }
3189         }
3190         return count;
3191     }
3192 
3193     /**
3194      * @dev See {IERC721-ownerOf}.
3195      */
3196     function ownerOf(uint256 tokenId)
3197         public
3198         view
3199         virtual
3200         override
3201         returns (address)
3202     {
3203         (address owner, ) = _ownerAndBatchHeadOf(tokenId);
3204         return owner;
3205     }
3206 
3207     function _ownerAndBatchHeadOf(uint256 tokenId) internal view returns (address owner, uint256 tokenIdBatchHead){
3208         require(_exists(tokenId), "ERC721Psi: owner query for nonexistent token");
3209         tokenIdBatchHead = _getBatchHead(tokenId);
3210         owner = _owners[tokenIdBatchHead];
3211     }
3212 
3213     /**
3214      * @dev See {IERC721Metadata-name}.
3215      */
3216     function name() public view virtual override returns (string memory) {
3217         return _name;
3218     }
3219 
3220     /**
3221      * @dev See {IERC721Metadata-symbol}.
3222      */
3223     function symbol() public view virtual override returns (string memory) {
3224         return _symbol;
3225     }
3226 
3227     /**
3228      * @dev See {IERC721Metadata-tokenURI}.
3229      */
3230     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3231         require(_exists(tokenId), "ERC721Psi: URI query for nonexistent token");
3232 
3233         string memory baseURI = _baseURI();
3234         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
3235     }
3236 
3237     /**
3238      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
3239      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
3240      * by default, can be overriden in child contracts.
3241      */
3242     function _baseURI() internal view virtual returns (string memory) {
3243         return "";
3244     }
3245 
3246 
3247     /**
3248      * @dev See {IERC721-approve}.
3249      */
3250     function approve(address to, uint256 tokenId) public virtual override {
3251         address owner = ownerOf(tokenId);
3252         require(to != owner, "ERC721Psi: approval to current owner");
3253 
3254         require(
3255             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
3256             "ERC721Psi: approve caller is not owner nor approved for all"
3257         );
3258 
3259         _approve(to, tokenId);
3260     }
3261 
3262     /**
3263      * @dev See {IERC721-getApproved}.
3264      */
3265     function getApproved(uint256 tokenId)
3266         public
3267         view
3268         virtual
3269         override
3270         returns (address)
3271     {
3272         require(
3273             _exists(tokenId),
3274             "ERC721Psi: approved query for nonexistent token"
3275         );
3276 
3277         return _tokenApprovals[tokenId];
3278     }
3279 
3280     /**
3281      * @dev See {IERC721-setApprovalForAll}.
3282      */
3283     function setApprovalForAll(address operator, bool approved)
3284         public
3285         virtual
3286         override
3287     {
3288         require(operator != _msgSender(), "ERC721Psi: approve to caller");
3289 
3290         _operatorApprovals[_msgSender()][operator] = approved;
3291         emit ApprovalForAll(_msgSender(), operator, approved);
3292     }
3293 
3294     /**
3295      * @dev See {IERC721-isApprovedForAll}.
3296      */
3297     function isApprovedForAll(address owner, address operator)
3298         public
3299         view
3300         virtual
3301         override
3302         returns (bool)
3303     {
3304         return _operatorApprovals[owner][operator];
3305     }
3306 
3307     /**
3308      * @dev See {IERC721-transferFrom}.
3309      */
3310     function transferFrom(
3311         address from,
3312         address to,
3313         uint256 tokenId
3314     ) public virtual override {
3315         //solhint-disable-next-line max-line-length
3316         require(
3317             _isApprovedOrOwner(_msgSender(), tokenId),
3318             "ERC721Psi: transfer caller is not owner nor approved"
3319         );
3320 
3321         _transfer(from, to, tokenId);
3322     }
3323 
3324     /**
3325      * @dev See {IERC721-safeTransferFrom}.
3326      */
3327     function safeTransferFrom(
3328         address from,
3329         address to,
3330         uint256 tokenId
3331     ) public virtual override {
3332         safeTransferFrom(from, to, tokenId, "");
3333     }
3334 
3335     /**
3336      * @dev See {IERC721-safeTransferFrom}.
3337      */
3338     function safeTransferFrom(
3339         address from,
3340         address to,
3341         uint256 tokenId,
3342         bytes memory _data
3343     ) public virtual override {
3344         require(
3345             _isApprovedOrOwner(_msgSender(), tokenId),
3346             "ERC721Psi: transfer caller is not owner nor approved"
3347         );
3348         _safeTransfer(from, to, tokenId, _data);
3349     }
3350 
3351     /**
3352      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3353      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3354      *
3355      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
3356      *
3357      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
3358      * implement alternative mechanisms to perform token transfer, such as signature-based.
3359      *
3360      * Requirements:
3361      *
3362      * - `from` cannot be the zero address.
3363      * - `to` cannot be the zero address.
3364      * - `tokenId` token must exist and be owned by `from`.
3365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3366      *
3367      * Emits a {Transfer} event.
3368      */
3369     function _safeTransfer(
3370         address from,
3371         address to,
3372         uint256 tokenId,
3373         bytes memory _data
3374     ) internal virtual {
3375         _transfer(from, to, tokenId);
3376         require(
3377             _checkOnERC721Received(from, to, tokenId, 1,_data),
3378             "ERC721Psi: transfer to non ERC721Receiver implementer"
3379         );
3380     }
3381 
3382     /**
3383      * @dev Returns whether `tokenId` exists.
3384      *
3385      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3386      *
3387      * Tokens start existing when they are minted (`_mint`).
3388      */
3389     function _exists(uint256 tokenId) internal view virtual returns (bool) {
3390         return tokenId < _nextTokenId() && _startTokenId() <= tokenId;
3391     }
3392 
3393     /**
3394      * @dev Returns whether `spender` is allowed to manage `tokenId`.
3395      *
3396      * Requirements:
3397      *
3398      * - `tokenId` must exist.
3399      */
3400     function _isApprovedOrOwner(address spender, uint256 tokenId)
3401         internal
3402         view
3403         virtual
3404         returns (bool)
3405     {
3406         require(
3407             _exists(tokenId),
3408             "ERC721Psi: operator query for nonexistent token"
3409         );
3410         address owner = ownerOf(tokenId);
3411         return (spender == owner ||
3412             getApproved(tokenId) == spender ||
3413             isApprovedForAll(owner, spender));
3414     }
3415 
3416     /**
3417      * @dev Safely mints `quantity` tokens and transfers them to `to`.
3418      *
3419      * Requirements:
3420      *
3421      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
3422      * - `quantity` must be greater than 0.
3423      *
3424      * Emits a {Transfer} event.
3425      */
3426     function _safeMint(address to, uint256 quantity) internal virtual {
3427         _safeMint(to, quantity, "");
3428     }
3429 
3430     
3431     function _safeMint(
3432         address to,
3433         uint256 quantity,
3434         bytes memory _data
3435     ) internal virtual {
3436         uint256 nextTokenId = _nextTokenId();
3437         _mint(to, quantity);
3438         require(
3439             _checkOnERC721Received(address(0), to, nextTokenId, quantity, _data),
3440             "ERC721Psi: transfer to non ERC721Receiver implementer"
3441         );
3442     }
3443 
3444 
3445     function _mint(
3446         address to,
3447         uint256 quantity
3448     ) internal virtual {
3449         uint256 nextTokenId = _nextTokenId();
3450         
3451         require(quantity > 0, "ERC721Psi: quantity must be greater 0");
3452         require(to != address(0), "ERC721Psi: mint to the zero address");
3453         
3454         _beforeTokenTransfers(address(0), to, nextTokenId, quantity);
3455         _currentIndex += quantity;
3456         _owners[nextTokenId] = to;
3457         _batchHead.set(nextTokenId);
3458         _afterTokenTransfers(address(0), to, nextTokenId, quantity);
3459         
3460         // Emit events
3461         for(uint256 tokenId=nextTokenId; tokenId < nextTokenId + quantity; tokenId++){
3462             emit Transfer(address(0), to, tokenId);
3463         } 
3464     }
3465 
3466 
3467     /**
3468      * @dev Transfers `tokenId` from `from` to `to`.
3469      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3470      *
3471      * Requirements:
3472      *
3473      * - `to` cannot be the zero address.
3474      * - `tokenId` token must be owned by `from`.
3475      *
3476      * Emits a {Transfer} event.
3477      */
3478     function _transfer(
3479         address from,
3480         address to,
3481         uint256 tokenId
3482     ) internal virtual {
3483         (address owner, uint256 tokenIdBatchHead) = _ownerAndBatchHeadOf(tokenId);
3484 
3485         require(
3486             owner == from,
3487             "ERC721Psi: transfer of token that is not own"
3488         );
3489         require(to != address(0), "ERC721Psi: transfer to the zero address");
3490 
3491         _beforeTokenTransfers(from, to, tokenId, 1);
3492 
3493         // Clear approvals from the previous owner
3494         _approve(address(0), tokenId);   
3495 
3496         uint256 subsequentTokenId = tokenId + 1;
3497 
3498         if(!_batchHead.get(subsequentTokenId) &&  
3499             subsequentTokenId < _nextTokenId()
3500         ) {
3501             _owners[subsequentTokenId] = from;
3502             _batchHead.set(subsequentTokenId);
3503         }
3504 
3505         _owners[tokenId] = to;
3506         if(tokenId != tokenIdBatchHead) {
3507             _batchHead.set(tokenId);
3508         }
3509 
3510         emit Transfer(from, to, tokenId);
3511 
3512         _afterTokenTransfers(from, to, tokenId, 1);
3513     }
3514 
3515     /**
3516      * @dev Approve `to` to operate on `tokenId`
3517      *
3518      * Emits a {Approval} event.
3519      */
3520     function _approve(address to, uint256 tokenId) internal virtual {
3521         _tokenApprovals[tokenId] = to;
3522         emit Approval(ownerOf(tokenId), to, tokenId);
3523     }
3524 
3525     /**
3526      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3527      * The call is not executed if the target address is not a contract.
3528      *
3529      * @param from address representing the previous owner of the given token ID
3530      * @param to target address that will receive the tokens
3531      * @param startTokenId uint256 the first ID of the tokens to be transferred
3532      * @param quantity uint256 amount of the tokens to be transfered.
3533      * @param _data bytes optional data to send along with the call
3534      * @return r bool whether the call correctly returned the expected magic value
3535      */
3536     function _checkOnERC721Received(
3537         address from,
3538         address to,
3539         uint256 startTokenId,
3540         uint256 quantity,
3541         bytes memory _data
3542     ) private returns (bool r) {
3543         if (to.isContract()) {
3544             r = true;
3545             for(uint256 tokenId = startTokenId; tokenId < startTokenId + quantity; tokenId++){
3546                 try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
3547                     r = r && retval == IERC721Receiver.onERC721Received.selector;
3548                 } catch (bytes memory reason) {
3549                     if (reason.length == 0) {
3550                         revert("ERC721Psi: transfer to non ERC721Receiver implementer");
3551                     } else {
3552                         assembly {
3553                             revert(add(32, reason), mload(reason))
3554                         }
3555                     }
3556                 }
3557             }
3558             return r;
3559         } else {
3560             return true;
3561         }
3562     }
3563 
3564     function _getBatchHead(uint256 tokenId) internal view returns (uint256 tokenIdBatchHead) {
3565         tokenIdBatchHead = _batchHead.scanForward(tokenId); 
3566     }
3567 
3568 
3569     function totalSupply() public virtual view returns (uint256) {
3570         return _totalMinted();
3571     }
3572 
3573     /**
3574      * @dev Returns an array of token IDs owned by `owner`.
3575      *
3576      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
3577      * It is meant to be called off-chain.
3578      *
3579      * This function is compatiable with ERC721AQueryable.
3580      */
3581     function tokensOfOwner(address owner) external view virtual returns (uint256[] memory) {
3582         unchecked {
3583             uint256 tokenIdsIdx;
3584             uint256 tokenIdsLength = balanceOf(owner);
3585             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
3586             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
3587                 if (_exists(i)) {
3588                     if (ownerOf(i) == owner) {
3589                         tokenIds[tokenIdsIdx++] = i;
3590                     }
3591                 }
3592             }
3593             return tokenIds;   
3594         }
3595     }
3596 
3597     /**
3598      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
3599      *
3600      * startTokenId - the first token id to be transferred
3601      * quantity - the amount to be transferred
3602      *
3603      * Calling conditions:
3604      *
3605      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3606      * transferred to `to`.
3607      * - When `from` is zero, `tokenId` will be minted for `to`.
3608      */
3609     function _beforeTokenTransfers(
3610         address from,
3611         address to,
3612         uint256 startTokenId,
3613         uint256 quantity
3614     ) internal virtual {}
3615 
3616     /**
3617      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
3618      * minting.
3619      *
3620      * startTokenId - the first token id to be transferred
3621      * quantity - the amount to be transferred
3622      *
3623      * Calling conditions:
3624      *
3625      * - when `from` and `to` are both non-zero.
3626      * - `from` and `to` are never both zero.
3627      */
3628     function _afterTokenTransfers(
3629         address from,
3630         address to,
3631         uint256 startTokenId,
3632         uint256 quantity
3633     ) internal virtual {}
3634 }
3635 // File: erc721psi/contracts/extension/ERC721PsiBurnable.sol
3636 
3637 
3638 /**
3639   ______ _____   _____ ______ ___  __ _  _  _ 
3640  |  ____|  __ \ / ____|____  |__ \/_ | || || |
3641  | |__  | |__) | |        / /   ) || | \| |/ |
3642  |  __| |  _  /| |       / /   / / | |\_   _/ 
3643  | |____| | \ \| |____  / /   / /_ | |  | |   
3644  |______|_|  \_\\_____|/_/   |____||_|  |_|   
3645                                               
3646                                             
3647  */
3648 pragma solidity ^0.8.0;
3649 
3650 
3651 
3652 
3653 abstract contract ERC721PsiBurnable is ERC721Psi {
3654     using BitMaps for BitMaps.BitMap;
3655     BitMaps.BitMap private _burnedToken;
3656 
3657     /**
3658      * @dev Destroys `tokenId`.
3659      * The approval is cleared when the token is burned.
3660      *
3661      * Requirements:
3662      *
3663      * - `tokenId` must exist.
3664      *
3665      * Emits a {Transfer} event.
3666      */
3667     function _burn(uint256 tokenId) internal virtual {
3668         address from = ownerOf(tokenId);
3669         _beforeTokenTransfers(from, address(0), tokenId, 1);
3670         _burnedToken.set(tokenId);
3671         
3672         emit Transfer(from, address(0), tokenId);
3673 
3674         _afterTokenTransfers(from, address(0), tokenId, 1);
3675     }
3676 
3677     /**
3678      * @dev Returns whether `tokenId` exists.
3679      *
3680      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3681      *
3682      * Tokens start existing when they are minted (`_mint`),
3683      * and stop existing when they are burned (`_burn`).
3684      */
3685     function _exists(uint256 tokenId) internal view override virtual returns (bool){
3686         if(_burnedToken.get(tokenId)) {
3687             return false;
3688         } 
3689         return super._exists(tokenId);
3690     }
3691 
3692     /**
3693      * @dev See {IERC721Enumerable-totalSupply}.
3694      */
3695     function totalSupply() public view virtual override returns (uint256) {
3696         return _totalMinted() - _burned();
3697     }
3698 
3699     /**
3700      * @dev Returns number of token burned.
3701      */
3702     function _burned() internal view returns (uint256 burned){
3703         uint256 startBucket = _startTokenId() >> 8;
3704         uint256 lastBucket = (_nextTokenId() >> 8) + 1;
3705 
3706         for(uint256 i=startBucket; i < lastBucket; i++) {
3707             uint256 bucket = _burnedToken.getBucket(i);
3708             burned += _popcount(bucket);
3709         }
3710     }
3711 
3712     /**
3713      * @dev Returns number of set bits.
3714      */
3715     function _popcount(uint256 x) private pure returns (uint256 count) {
3716         unchecked{
3717             for (count=0; x!=0; count++)
3718                 x &= x - 1;
3719         }
3720     }
3721 }
3722 // File: contract-allow-list/contracts/ERC721AntiScam/restrictApprove/ERC721RestrictApprove.sol
3723 
3724 
3725 pragma solidity >=0.8.0;
3726 
3727 
3728 
3729 
3730 
3731 /// @title AntiScam機能付きERC721A
3732 /// @dev Readmeを見てください。
3733 
3734 abstract contract ERC721RestrictApprove is ERC721PsiBurnable, IERC721RestrictApprove {
3735     using EnumerableSet for EnumerableSet.AddressSet;
3736 
3737     IContractAllowListProxy public CAL;
3738     EnumerableSet.AddressSet localAllowedAddresses;
3739 
3740     modifier onlyHolder(uint256 tokenId) {
3741         require(
3742             msg.sender == ownerOf(tokenId),
3743             "RestrictApprove: operation is only holder."
3744         );
3745         _;
3746     }
3747 
3748     /*//////////////////////////////////////////////////////////////
3749     変数
3750     //////////////////////////////////////////////////////////////*/
3751     bool public enableRestrict = true;
3752 
3753     // token lock
3754     mapping(uint256 => uint256) public tokenCALLevel;
3755 
3756     // wallet lock
3757     mapping(address => uint256) public walletCALLevel;
3758 
3759     // contract lock
3760     uint256 public CALLevel = 1;
3761 
3762     /*///////////////////////////////////////////////////////////////
3763     Approve抑制機能ロジック
3764     //////////////////////////////////////////////////////////////*/
3765     function _addLocalContractAllowList(address transferer)
3766         internal
3767         virtual
3768     {
3769         localAllowedAddresses.add(transferer);
3770         emit LocalCalAdded(msg.sender, transferer);
3771     }
3772 
3773     function _removeLocalContractAllowList(address transferer)
3774         internal
3775         virtual
3776     {
3777         localAllowedAddresses.remove(transferer);
3778         emit LocalCalRemoved(msg.sender, transferer);
3779     }
3780 
3781     function _getLocalContractAllowList()
3782         internal
3783         virtual
3784         view
3785         returns(address[] memory)
3786     {
3787         return localAllowedAddresses.values();
3788     }
3789 
3790     function _isLocalAllowed(address transferer)
3791         internal
3792         view
3793         virtual
3794         returns (bool)
3795     {
3796         return localAllowedAddresses.contains(transferer);
3797     }
3798 
3799     function _isAllowed(address transferer)
3800         internal
3801         view
3802         virtual
3803         returns (bool)
3804     {
3805         return _isAllowed(msg.sender, transferer);
3806     }
3807 
3808     function _isAllowed(uint256 tokenId, address transferer)
3809         internal
3810         view
3811         virtual
3812         returns (bool)
3813     {
3814         uint256 level = _getCALLevel(msg.sender, tokenId);
3815         return _isAllowed(transferer, level);
3816     }
3817 
3818     function _isAllowed(address holder, address transferer)
3819         internal
3820         view
3821         virtual
3822         returns (bool)
3823     {
3824         uint256 level = _getCALLevel(holder);
3825         return _isAllowed(transferer, level);
3826     }
3827 
3828     function _isAllowed(address transferer, uint256 level)
3829         internal
3830         view
3831         virtual
3832         returns (bool)
3833     {
3834         if (!enableRestrict) {
3835             return true;
3836         }
3837 
3838         return _isLocalAllowed(transferer) || CAL.isAllowed(transferer, level);
3839     }
3840 
3841     function _getCALLevel(address holder, uint256 tokenId)
3842         internal
3843         view
3844         virtual
3845         returns (uint256)
3846     {
3847         if (tokenCALLevel[tokenId] > 0) {
3848             return tokenCALLevel[tokenId];
3849         }
3850 
3851         return _getCALLevel(holder);
3852     }
3853 
3854     function _getCALLevel(address holder)
3855         internal
3856         view
3857         virtual
3858         returns (uint256)
3859     {
3860         if (walletCALLevel[holder] > 0) {
3861             return walletCALLevel[holder];
3862         }
3863 
3864         return CALLevel;
3865     }
3866 
3867     function _setCAL(address _cal) internal virtual {
3868         CAL = IContractAllowListProxy(_cal);
3869     }
3870 
3871     function _deleteTokenCALLevel(uint256 tokenId) internal virtual {
3872         delete tokenCALLevel[tokenId];
3873     }
3874 
3875     function setTokenCALLevel(uint256 tokenId, uint256 level)
3876         external
3877         virtual
3878         onlyHolder(tokenId)
3879     {
3880         tokenCALLevel[tokenId] = level;
3881     }
3882 
3883     function setWalletCALLevel(uint256 level)
3884         external
3885         virtual
3886     {
3887         walletCALLevel[msg.sender] = level;
3888     }
3889 
3890     /*///////////////////////////////////////////////////////////////
3891                               OVERRIDES
3892     //////////////////////////////////////////////////////////////*/
3893 
3894     function isApprovedForAll(address owner, address operator)
3895         public
3896         view
3897         virtual
3898         override
3899         returns (bool)
3900     {
3901         if (_isAllowed(owner, operator) == false) {
3902             return false;
3903         }
3904         return super.isApprovedForAll(owner, operator);
3905     }
3906 
3907     function setApprovalForAll(address operator, bool approved)
3908         public
3909         virtual
3910         override
3911     {
3912         require(
3913             _isAllowed(operator) || approved == false,
3914             "RestrictApprove: Can not approve locked token"
3915         );
3916         super.setApprovalForAll(operator, approved);
3917     }
3918 
3919     function _beforeApprove(address to, uint256 tokenId)
3920         internal
3921         virtual
3922     {
3923         if (to != address(0)) {
3924             require(_isAllowed(tokenId, to), "RestrictApprove: The contract is not allowed.");
3925         }
3926     }
3927 
3928     function approve(address to, uint256 tokenId)
3929         public
3930         virtual
3931         override
3932     {
3933         _beforeApprove(to, tokenId);
3934         super.approve(to, tokenId);
3935     }
3936 
3937     function _afterTokenTransfers(
3938         address from,
3939         address, /*to*/
3940         uint256 startTokenId,
3941         uint256 /*quantity*/
3942     ) internal virtual override {
3943         // 転送やバーンにおいては、常にstartTokenIdは TokenIDそのものとなります。
3944         if (from != address(0)) {
3945             // CALレベルをデフォルトに戻す。
3946             _deleteTokenCALLevel(startTokenId);
3947         }
3948     }
3949 
3950     function supportsInterface(bytes4 interfaceId)
3951         public
3952         view
3953         virtual
3954         override
3955         returns (bool)
3956     {
3957         return
3958             interfaceId == type(IERC721RestrictApprove).interfaceId ||
3959             super.supportsInterface(interfaceId);
3960     }
3961 }
3962 
3963 // File: base64-sol/base64.sol
3964 
3965 
3966 
3967 pragma solidity >=0.6.0;
3968 
3969 /// @title Base64
3970 /// @author Brecht Devos - <brecht@loopring.org>
3971 /// @notice Provides functions for encoding/decoding base64
3972 library Base64 {
3973     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
3974     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
3975                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
3976                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
3977                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
3978 
3979     function encode(bytes memory data) internal pure returns (string memory) {
3980         if (data.length == 0) return '';
3981 
3982         // load the table into memory
3983         string memory table = TABLE_ENCODE;
3984 
3985         // multiply by 4/3 rounded up
3986         uint256 encodedLen = 4 * ((data.length + 2) / 3);
3987 
3988         // add some extra buffer at the end required for the writing
3989         string memory result = new string(encodedLen + 32);
3990 
3991         assembly {
3992             // set the actual output length
3993             mstore(result, encodedLen)
3994 
3995             // prepare the lookup table
3996             let tablePtr := add(table, 1)
3997 
3998             // input ptr
3999             let dataPtr := data
4000             let endPtr := add(dataPtr, mload(data))
4001 
4002             // result ptr, jump over length
4003             let resultPtr := add(result, 32)
4004 
4005             // run over the input, 3 bytes at a time
4006             for {} lt(dataPtr, endPtr) {}
4007             {
4008                 // read 3 bytes
4009                 dataPtr := add(dataPtr, 3)
4010                 let input := mload(dataPtr)
4011 
4012                 // write 4 characters
4013                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
4014                 resultPtr := add(resultPtr, 1)
4015                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
4016                 resultPtr := add(resultPtr, 1)
4017                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
4018                 resultPtr := add(resultPtr, 1)
4019                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
4020                 resultPtr := add(resultPtr, 1)
4021             }
4022 
4023             // padding with '='
4024             switch mod(mload(data), 3)
4025             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
4026             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
4027         }
4028 
4029         return result;
4030     }
4031 
4032     function decode(string memory _data) internal pure returns (bytes memory) {
4033         bytes memory data = bytes(_data);
4034 
4035         if (data.length == 0) return new bytes(0);
4036         require(data.length % 4 == 0, "invalid base64 decoder input");
4037 
4038         // load the table into memory
4039         bytes memory table = TABLE_DECODE;
4040 
4041         // every 4 characters represent 3 bytes
4042         uint256 decodedLen = (data.length / 4) * 3;
4043 
4044         // add some extra buffer at the end required for the writing
4045         bytes memory result = new bytes(decodedLen + 32);
4046 
4047         assembly {
4048             // padding with '='
4049             let lastBytes := mload(add(data, mload(data)))
4050             if eq(and(lastBytes, 0xFF), 0x3d) {
4051                 decodedLen := sub(decodedLen, 1)
4052                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
4053                     decodedLen := sub(decodedLen, 1)
4054                 }
4055             }
4056 
4057             // set the actual output length
4058             mstore(result, decodedLen)
4059 
4060             // prepare the lookup table
4061             let tablePtr := add(table, 1)
4062 
4063             // input ptr
4064             let dataPtr := data
4065             let endPtr := add(dataPtr, mload(data))
4066 
4067             // result ptr, jump over length
4068             let resultPtr := add(result, 32)
4069 
4070             // run over the input, 4 characters at a time
4071             for {} lt(dataPtr, endPtr) {}
4072             {
4073                // read 4 characters
4074                dataPtr := add(dataPtr, 4)
4075                let input := mload(dataPtr)
4076 
4077                // write 3 bytes
4078                let output := add(
4079                    add(
4080                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
4081                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
4082                    add(
4083                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
4084                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
4085                     )
4086                 )
4087                 mstore(resultPtr, shl(232, output))
4088                 resultPtr := add(resultPtr, 3)
4089             }
4090         }
4091 
4092         return result;
4093     }
4094 }
4095 
4096 // File: contracts/MusubiCollection.sol
4097 
4098 
4099 // Copyright (c) 2022 Keisuke OHNO
4100 
4101 /*
4102 
4103 Permission is hereby granted, free of charge, to any person obtaining a copy
4104 of this software and associated documentation files (the "Software"), to deal
4105 in the Software without restriction, including without limitation the rights
4106 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
4107 copies of the Software, and to permit persons to whom the Software is
4108 furnished to do so, subject to the following conditions:
4109 
4110 The above copyright notice and this permission notice shall be included in all
4111 copies or substantial portions of the Software.
4112 
4113 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
4114 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
4115 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
4116 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
4117 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
4118 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
4119 SOFTWARE.
4120 
4121 */
4122 
4123 pragma solidity >=0.8.17;
4124 
4125 
4126 
4127 
4128 
4129 
4130 
4131 
4132 
4133 
4134 //tokenURI interface
4135 interface iTokenURI {
4136     function tokenURI(uint256 _tokenId) external view returns (string memory);
4137 }
4138 
4139 //SBT interface
4140 interface iSbtCollection {
4141     function externalMint(address _address , uint256 _amount ) external payable;
4142     function balanceOf(address _owner) external view returns (uint);
4143 }
4144 
4145 contract MusubiCollection is RevokableDefaultOperatorFilterer, ERC2981 ,Ownable, ERC721RestrictApprove ,AccessControl,ReentrancyGuard {
4146 
4147     constructor(
4148     ) ERC721Psi("MusubiCollection", "MCND") {
4149         
4150         //Role initialization
4151         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
4152         grantRole(MINTER_ROLE       , msg.sender);
4153         grantRole(AIRDROP_ROLE      , msg.sender);
4154         grantRole(ADMIN             , msg.sender);
4155 
4156         setBaseURI("https://musubicollection.xyz/data/metadata/");
4157 
4158         //use single metadata
4159         //setUseSingleMetadata(true);
4160         //setMetadataTitle("Musubi Collection by NinjaDAO");
4161         //setMetadataDescription("Musubi Collection by NinjaDAO");
4162         //setMetadataAttributes("Musubi Collection by NinjaDAO");
4163         //setImageURI("https://musubicollection.xyz/data/images/1png");//sanuqn
4164 
4165         //CAL initialization
4166         setCALLevel(1);
4167 
4168         _setCAL(0xdbaa28cBe70aF04EbFB166b1A3E8F8034e5B9FC7);//Ethereum mainnet proxy
4169         //_setCAL(0xb506d7BbE23576b8AAf22477cd9A7FDF08002211);//Goerli testnet proxy
4170 
4171         _addLocalContractAllowList(0x1E0049783F008A0085193E00003D00cd54003c71);//OpenSea
4172         _addLocalContractAllowList(0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be);//Rarible
4173 
4174         //initial mint
4175         //_safeMint(0x49889aB7BC1939B2D745c9e5A6516370da7098e2, 484);
4176         //_safeMint(0x320d25E04d913d4529941Cb9C35Ed356CB86a5cC, 300);
4177         _safeMint(msg.sender, 1);
4178         //_safeMint(0x49889aB7BC1939B2D745c9e5A6516370da7098e2, 10000);
4179         //_safeMint(0x07Bd15a8589fd3693847B30e7452F038cc20C780, 3000);
4180         
4181 
4182         //Royalty
4183         setDefaultRoyalty(0xAc6534C66b393E6cb33a13795857E0d9d2b90f96 , 1000);
4184         //setWithdrawAddress(0xDC68E2aF8816B3154c95dab301f7838c7D83A0Ba);
4185 
4186         //setMintWithSBT(true);
4187         //setSbtCollection(0x6eED0Ff2afbe92B6d0990Cd63cA10Ce5F425dBf1);
4188     }
4189     //
4190     //withdraw section
4191     //
4192 
4193     address public withdrawAddress = 0x52C5DcF49f10C827E070cee4aDf1D006942eAaB6;
4194 
4195     function setWithdrawAddress(address _withdrawAddress) public onlyOwner {
4196         withdrawAddress = _withdrawAddress;
4197     }
4198 
4199     function withdraw() public payable onlyOwner {
4200         (bool os, ) = payable(withdrawAddress).call{value: address(this).balance}('');
4201         require(os);
4202     }
4203 
4204     //
4205     //mint section
4206     //
4207 
4208     uint256 public cost = 10000000000000000;
4209     uint256 public maxSupply = 2221;
4210     uint256 public maxMintAmountPerTransaction = 200;
4211     uint256 public publicSaleMaxMintAmountPerAddress = 10;
4212     bool public paused = true;
4213 
4214     bool public onlyAllowlisted = true;
4215     bool public mintCount = true;
4216     bool public burnAndMintMode = false;
4217 
4218     //0 : Merkle Tree
4219     //1 : Mapping
4220     uint256 public allowlistType = 0;
4221     bytes32 public merkleRoot;
4222     uint256 public saleId = 0;
4223     mapping(uint256 => mapping(address => uint256)) public userMintedAmount;
4224     mapping(uint256 => mapping(address => uint256)) public allowlistUserAmount;
4225 
4226     bool public mintWithSBT = false;
4227     iSbtCollection public sbtCollection;
4228 
4229 
4230     modifier callerIsUser() {
4231         require(tx.origin == msg.sender, "The caller is another contract.");
4232         _;
4233     }
4234  
4235     //mint with merkle tree
4236     function mint(uint256 _mintAmount , uint256 _maxMintAmount , bytes32[] calldata _merkleProof , uint256 _burnId ) public payable callerIsUser{
4237         require(!paused, "the contract is paused");
4238         require(0 < _mintAmount, "need to mint at least 1 NFT");
4239         require(_mintAmount <= maxMintAmountPerTransaction, "max mint amount per session exceeded");
4240         require( (_nextTokenId() -1) + _mintAmount <= maxSupply , "max NFT limit exceeded");
4241         require(cost * _mintAmount <= msg.value, "insufficient funds");
4242 
4243         uint256 maxMintAmountPerAddress;
4244         if(onlyAllowlisted == true) {
4245             if(allowlistType == 0){
4246                 //Merkle tree
4247                 bytes32 leaf = keccak256( abi.encodePacked(msg.sender, _maxMintAmount) );
4248                 require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "user is not allowlisted");
4249                 maxMintAmountPerAddress = _maxMintAmount;
4250             }else if(allowlistType == 1){
4251                 //Mapping
4252                 require( allowlistUserAmount[saleId][msg.sender] != 0 , "user is not allowlisted");
4253                 maxMintAmountPerAddress = allowlistUserAmount[saleId][msg.sender];
4254             }
4255         }else{
4256             maxMintAmountPerAddress = publicSaleMaxMintAmountPerAddress;
4257         }
4258 
4259         if(mintCount == true){
4260             require(_mintAmount <= maxMintAmountPerAddress - userMintedAmount[saleId][msg.sender] , "max NFT per address exceeded");
4261             userMintedAmount[saleId][msg.sender] += _mintAmount;
4262         }
4263 
4264         if(burnAndMintMode == true ){
4265             require(_mintAmount == 1, "The number of mints is over.");
4266             require(msg.sender == ownerOf(_burnId) , "Owner is different");
4267             _burn(_burnId);
4268         }
4269 
4270         if( mintWithSBT == true ){
4271             if( sbtCollection.balanceOf(msg.sender) == 0 ){
4272                 sbtCollection.externalMint(msg.sender,1);
4273             }
4274         }
4275 
4276         _safeMint(msg.sender, _mintAmount);
4277     }
4278 
4279     bytes32 public constant AIRDROP_ROLE = keccak256("AIRDROP_ROLE");
4280     function airdropMint(address[] calldata _airdropAddresses , uint256[] memory _UserMintAmount) public {
4281         require(hasRole(AIRDROP_ROLE, msg.sender), "Caller is not a air dropper");
4282         require(_airdropAddresses.length == _UserMintAmount.length , "Array lengths are different");
4283         uint256 _mintAmount = 0;
4284         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
4285             _mintAmount += _UserMintAmount[i];
4286         }
4287         require(0 < _mintAmount , "need to mint at least 1 NFT");
4288         require( (_nextTokenId() -1) + _mintAmount <= maxSupply , "max NFT limit exceeded");        
4289         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
4290             _safeMint(_airdropAddresses[i], _UserMintAmount[i] );
4291         }
4292     }
4293 
4294     function currentTokenId() public view returns(uint256){
4295         return _nextTokenId() -1;
4296     }
4297 
4298     function setMintWithSBT(bool _mintWithSBT) public onlyRole(ADMIN) {
4299         mintWithSBT = _mintWithSBT;
4300     }
4301 
4302     function setSbtCollection(address _address) public onlyRole(ADMIN) {
4303         sbtCollection = iSbtCollection(_address);
4304     }
4305 
4306     function setBurnAndMintMode(bool _burnAndMintMode) public onlyRole(ADMIN) {
4307         burnAndMintMode = _burnAndMintMode;
4308     }
4309 
4310     function setMerkleRoot(bytes32 _merkleRoot) public onlyRole(ADMIN) {
4311         merkleRoot = _merkleRoot;
4312     }
4313 
4314     function setPause(bool _state) public onlyRole(ADMIN) {
4315         paused = _state;
4316     }
4317 
4318     function setAllowListType(uint256 _type)public onlyRole(ADMIN){
4319         require( _type == 0 || _type == 1 , "Allow list type error");
4320         allowlistType = _type;
4321     }
4322 
4323     function setAllowlistMapping(uint256 _saleId , address[] memory addresses, uint256[] memory saleSupplies) public onlyRole(ADMIN) {
4324         require(addresses.length == saleSupplies.length);
4325         for (uint256 i = 0; i < addresses.length; i++) {
4326             allowlistUserAmount[_saleId][addresses[i]] = saleSupplies[i];
4327         }
4328     }
4329 
4330     function getAllowlistUserAmount(address _address ) public view returns(uint256){
4331         return allowlistUserAmount[saleId][_address];
4332     }
4333 
4334     function getUserMintedAmountBySaleId(uint256 _saleId , address _address ) public view returns(uint256){
4335         return userMintedAmount[_saleId][_address];
4336     }
4337 
4338     function getUserMintedAmount(address _address ) public view returns(uint256){
4339         return userMintedAmount[saleId][_address];
4340     }
4341 
4342     function setSaleId(uint256 _saleId) public onlyRole(ADMIN) {
4343         saleId = _saleId;
4344     }
4345 
4346     function setMaxSupply(uint256 _maxSupply) public onlyRole(ADMIN) {
4347         maxSupply = _maxSupply;
4348     }
4349 
4350     function setPublicSaleMaxMintAmountPerAddress(uint256 _publicSaleMaxMintAmountPerAddress) public onlyRole(ADMIN) {
4351         publicSaleMaxMintAmountPerAddress = _publicSaleMaxMintAmountPerAddress;
4352     }
4353 
4354     function setCost(uint256 _newCost) public onlyRole(ADMIN) {
4355         cost = _newCost;
4356     }
4357 
4358     function setOnlyAllowlisted(bool _state) public onlyRole(ADMIN) {
4359         onlyAllowlisted = _state;
4360     }
4361 
4362     function setMaxMintAmountPerTransaction(uint256 _maxMintAmountPerTransaction) public onlyRole(ADMIN) {
4363         maxMintAmountPerTransaction = _maxMintAmountPerTransaction;
4364     }
4365   
4366     function setMintCount(bool _state) public onlyRole(ADMIN) {
4367         mintCount = _state;
4368     }
4369 
4370     //
4371     //URI section
4372     //
4373 
4374     string public baseURI;
4375     string public baseExtension = ".json";
4376 
4377     function _baseURI() internal view virtual override returns (string memory) {
4378         return baseURI;        
4379     }
4380 
4381     function setBaseURI(string memory _newBaseURI) public onlyRole(ADMIN) {
4382         baseURI = _newBaseURI;
4383     }
4384 
4385     function setBaseExtension(string memory _newBaseExtension) public onlyRole(ADMIN) {
4386         baseExtension = _newBaseExtension;
4387     }
4388 
4389     //
4390     //interface metadata
4391     //
4392 
4393     iTokenURI public interfaceOfTokenURI;
4394     bool public useInterfaceMetadata = false;
4395 
4396     function setInterfaceOfTokenURI(address _address) public onlyRole(ADMIN) {
4397         interfaceOfTokenURI = iTokenURI(_address);
4398     }
4399 
4400     function setUseInterfaceMetadata(bool _useInterfaceMetadata) public onlyRole(ADMIN) {
4401         useInterfaceMetadata = _useInterfaceMetadata;
4402     }
4403 
4404     //
4405     //single metadata
4406     //
4407 
4408     bool public useSingleMetadata = false;
4409     string public imageURI;
4410     string public metadataTitle;
4411     string public metadataDescription;
4412     string public metadataAttributes;
4413     bool public useAnimationUrl = false;
4414     string public animationURI;
4415 
4416     //single image metadata
4417     function setUseSingleMetadata(bool _useSingleMetadata) public onlyRole(ADMIN) {
4418         useSingleMetadata = _useSingleMetadata;
4419     }
4420     function setMetadataTitle(string memory _metadataTitle) public onlyRole(ADMIN) {
4421         metadataTitle = _metadataTitle;
4422     }
4423     function setMetadataDescription(string memory _metadataDescription) public onlyRole(ADMIN) {
4424         metadataDescription = _metadataDescription;
4425     }
4426     function setMetadataAttributes(string memory _metadataAttributes) public onlyRole(ADMIN) {
4427         metadataAttributes = _metadataAttributes;
4428     }
4429     function setImageURI(string memory _ImageURI) public onlyRole(ADMIN) {
4430         imageURI = _ImageURI;
4431     }
4432     function setUseAnimationUrl(bool _useAnimationUrl) public onlyRole(ADMIN) {
4433         useAnimationUrl = _useAnimationUrl;
4434     }
4435     function setAnimationURI(string memory _animationURI) public onlyRole(ADMIN) {
4436         animationURI = _animationURI;
4437     }
4438 
4439     //
4440     //token URI
4441     //
4442 
4443     function tokenURI(uint256 tokenId) public view override returns (string memory) {
4444         if (useInterfaceMetadata == true) {
4445             return interfaceOfTokenURI.tokenURI(tokenId);
4446         }
4447         if(useSingleMetadata == true){
4448             return string( abi.encodePacked( 'data:application/json;base64,' , Base64.encode(
4449                 abi.encodePacked(
4450                     '{',
4451                         '"name":"' , metadataTitle ,'",' ,
4452                         '"description":"' , metadataDescription ,  '",' ,
4453                         '"image": "' , imageURI , '",' ,
4454                         useAnimationUrl==true ? string(abi.encodePacked('"animation_url": "' , animationURI , '",')) :"" ,
4455                         '"attributes":[{"trait_type":"type","value":"' , metadataAttributes , '"}]',
4456                     '}'
4457                 )
4458             ) ) );
4459         }
4460         return string(abi.encodePacked(ERC721Psi.tokenURI(tokenId), baseExtension));
4461     }
4462 
4463     //
4464     //burnin' section
4465     //
4466 
4467     bytes32 public constant MINTER_ROLE  = keccak256("MINTER_ROLE");
4468     bytes32 public constant BURNER_ROLE  = keccak256("BURNER_ROLE");
4469 
4470     function externalMint(address _address , uint256 _amount ) external payable {
4471         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
4472         require( (_nextTokenId() -1) + _amount <= maxSupply , "max NFT limit exceeded");
4473         _safeMint( _address, _amount );
4474     }
4475 
4476     function externalBurn(uint256[] memory _burnTokenIds) external nonReentrant{
4477         require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
4478         for (uint256 i = 0; i < _burnTokenIds.length; i++) {
4479             uint256 tokenId = _burnTokenIds[i];
4480             require(tx.origin == ownerOf(tokenId) , "Owner is different");
4481             _burn(tokenId);
4482         }        
4483     }
4484 
4485     //
4486     //sbt and opensea filter section
4487     //
4488 
4489     bool public isSBT = false;
4490 
4491     function setIsSBT(bool _state) public onlyRole(ADMIN) {
4492         isSBT = _state;
4493     }
4494 
4495     function _beforeTokenTransfers( address from, address to, uint256 startTokenId, uint256 quantity) internal virtual override{
4496         require( isSBT == false || from == address(0) || to == address(0)|| to == address(0x000000000000000000000000000000000000dEaD), "transfer is prohibited");
4497         super._beforeTokenTransfers(from, to, startTokenId, quantity);
4498     }
4499 
4500     function setApprovalForAll(address operator, bool approved) public virtual override onlyAllowedOperatorApproval(operator){
4501         require( isSBT == false || approved == false , "setApprovalForAll is prohibited");
4502         super.setApprovalForAll(operator, approved);
4503     }
4504 
4505     function approve(address operator, uint256 tokenId) public virtual override onlyAllowedOperatorApproval(operator){
4506         require( isSBT == false , "approve is prohibited");
4507         super.approve(operator, tokenId);
4508     }
4509 
4510     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
4511         super.transferFrom(from, to, tokenId);
4512     }
4513 
4514     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
4515         super.safeTransferFrom(from, to, tokenId);
4516     }
4517 
4518     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from) {
4519         super.safeTransferFrom(from, to, tokenId, data);
4520     }
4521 
4522     function owner() public view virtual override (Ownable, UpdatableOperatorFilterer) returns (address) {
4523         return Ownable.owner();
4524     }
4525 
4526     //
4527     //ERC721PsiAddressData section
4528     //
4529 
4530     // Mapping owner address to address data
4531     mapping(address => AddressData) _addressData;
4532 
4533     // Compiler will pack this into a single 256bit word.
4534     struct AddressData {
4535         // Realistically, 2**64-1 is more than enough.
4536         uint64 balance;
4537         // Keeps track of mint count with minimal overhead for tokenomics.
4538         uint64 numberMinted;
4539         // Keeps track of burn count with minimal overhead for tokenomics.
4540         uint64 numberBurned;
4541         // For miscellaneous variable(s) pertaining to the address
4542         // (e.g. number of whitelist mint slots used).
4543         // If there are multiple variables, please pack them into a uint64.
4544         uint64 aux;
4545     }
4546        
4547      /**
4548      * @dev See {IERC721-balanceOf}.
4549      */
4550     function balanceOf(address _owner) 
4551         public 
4552         view 
4553         virtual 
4554         override 
4555         returns (uint) 
4556     {
4557         require(_owner != address(0), "ERC721Psi: balance query for the zero address");
4558         return uint256(_addressData[_owner].balance);   
4559     }
4560 
4561     /**
4562      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
4563      * minting.
4564      *
4565      * startTokenId - the first token id to be transferred
4566      * quantity - the amount to be transferred
4567      *
4568      * Calling conditions:
4569      *
4570      * - when `from` and `to` are both non-zero.
4571      * - `from` and `to` are never both zero.
4572      */
4573     function _afterTokenTransfers(
4574         address from,
4575         address to,
4576         uint256 startTokenId,
4577         uint256 quantity
4578     ) internal override virtual {
4579         require(quantity < 2 ** 64);
4580         uint64 _quantity = uint64(quantity);
4581 
4582         if(from != address(0)){
4583             _addressData[from].balance -= _quantity;
4584         } else {
4585             // Mint
4586             _addressData[to].numberMinted += _quantity;
4587         }
4588 
4589         if(to != address(0)){
4590             _addressData[to].balance += _quantity;
4591         } else {
4592             // Burn
4593             _addressData[from].numberBurned += _quantity;
4594         }
4595         super._afterTokenTransfers(from, to, startTokenId, quantity);
4596     }
4597 
4598     //
4599     //ERC721AntiScam section
4600     //
4601 
4602     bytes32 public constant ADMIN = keccak256("ADMIN");
4603 
4604     function setEnebleRestrict(bool _enableRestrict )public onlyRole(ADMIN){
4605         enableRestrict = _enableRestrict;
4606     }
4607 
4608     /*///////////////////////////////////////////////////////////////
4609                     OVERRIDES ERC721RestrictApprove
4610     //////////////////////////////////////////////////////////////*/
4611     function addLocalContractAllowList(address transferer)
4612         external
4613         override
4614         onlyRole(ADMIN)
4615     {
4616         _addLocalContractAllowList(transferer);
4617     }
4618 
4619     function removeLocalContractAllowList(address transferer)
4620         external
4621         override
4622         onlyRole(ADMIN)
4623     {
4624         _removeLocalContractAllowList(transferer);
4625     }
4626 
4627     function getLocalContractAllowList()
4628         external
4629         override
4630         view
4631         returns(address[] memory)
4632     {
4633         return _getLocalContractAllowList();
4634     }
4635 
4636     function setCALLevel(uint256 level) public override onlyRole(ADMIN) {
4637         CALLevel = level;
4638     }
4639 
4640     function setCAL(address calAddress) external override onlyRole(ADMIN) {
4641         _setCAL(calAddress);
4642     }
4643 
4644     //
4645     //setDefaultRoyalty
4646     //
4647     function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner{
4648         _setDefaultRoyalty(_receiver, _feeNumerator);
4649     }
4650 
4651 
4652     /*///////////////////////////////////////////////////////////////
4653                     OVERRIDES ERC721RestrictApprove
4654     //////////////////////////////////////////////////////////////*/
4655     function supportsInterface(bytes4 interfaceId)
4656         public
4657         view
4658         override(ERC2981,ERC721RestrictApprove, AccessControl)
4659         returns (bool)
4660     {
4661         return
4662             ERC2981.supportsInterface(interfaceId) ||
4663             AccessControl.supportsInterface(interfaceId) ||
4664             ERC721RestrictApprove.supportsInterface(interfaceId);
4665     }
4666 
4667 
4668     
4669 
4670 }