1 // SPDX-License-Identifier: MIT
2 
3 // File: operator-filter-registry/src/lib/Constants.sol
4 
5 
6 pragma solidity ^0.8.13;
7 
8 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
9 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
10 
11 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
12 
13 
14 pragma solidity ^0.8.13;
15 
16 interface IOperatorFilterRegistry {
17     /**
18      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
19      *         true if supplied registrant address is not registered.
20      */
21     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
22 
23     /**
24      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
25      */
26     function register(address registrant) external;
27 
28     /**
29      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
30      */
31     function registerAndSubscribe(address registrant, address subscription) external;
32 
33     /**
34      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
35      *         address without subscribing.
36      */
37     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
38 
39     /**
40      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
41      *         Note that this does not remove any filtered addresses or codeHashes.
42      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
43      */
44     function unregister(address addr) external;
45 
46     /**
47      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
48      */
49     function updateOperator(address registrant, address operator, bool filtered) external;
50 
51     /**
52      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
53      */
54     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
55 
56     /**
57      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
58      */
59     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
60 
61     /**
62      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
63      */
64     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
65 
66     /**
67      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
68      *         subscription if present.
69      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
70      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
71      *         used.
72      */
73     function subscribe(address registrant, address registrantToSubscribe) external;
74 
75     /**
76      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
77      */
78     function unsubscribe(address registrant, bool copyExistingEntries) external;
79 
80     /**
81      * @notice Get the subscription address of a given registrant, if any.
82      */
83     function subscriptionOf(address addr) external returns (address registrant);
84 
85     /**
86      * @notice Get the set of addresses subscribed to a given registrant.
87      *         Note that order is not guaranteed as updates are made.
88      */
89     function subscribers(address registrant) external returns (address[] memory);
90 
91     /**
92      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
93      *         Note that order is not guaranteed as updates are made.
94      */
95     function subscriberAt(address registrant, uint256 index) external returns (address);
96 
97     /**
98      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
99      */
100     function copyEntriesOf(address registrant, address registrantToCopy) external;
101 
102     /**
103      * @notice Returns true if operator is filtered by a given address or its subscription.
104      */
105     function isOperatorFiltered(address registrant, address operator) external returns (bool);
106 
107     /**
108      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
109      */
110     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
111 
112     /**
113      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
114      */
115     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
116 
117     /**
118      * @notice Returns a list of filtered operators for a given address or its subscription.
119      */
120     function filteredOperators(address addr) external returns (address[] memory);
121 
122     /**
123      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
124      *         Note that order is not guaranteed as updates are made.
125      */
126     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
127 
128     /**
129      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
130      *         its subscription.
131      *         Note that order is not guaranteed as updates are made.
132      */
133     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
134 
135     /**
136      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
137      *         its subscription.
138      *         Note that order is not guaranteed as updates are made.
139      */
140     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
141 
142     /**
143      * @notice Returns true if an address has registered
144      */
145     function isRegistered(address addr) external returns (bool);
146 
147     /**
148      * @dev Convenience method to compute the code hash of an arbitrary contract
149      */
150     function codeHashOf(address addr) external returns (bytes32);
151 }
152 
153 // File: operator-filter-registry/src/OperatorFilterer.sol
154 
155 
156 pragma solidity ^0.8.13;
157 
158 
159 /**
160  * @title  OperatorFilterer
161  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
162  *         registrant's entries in the OperatorFilterRegistry.
163  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
164  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
165  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
166  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
167  *         administration methods on the contract itself to interact with the registry otherwise the subscription
168  *         will be locked to the options set during construction.
169  */
170 
171 abstract contract OperatorFilterer {
172     /// @dev Emitted when an operator is not allowed.
173     error OperatorNotAllowed(address operator);
174 
175     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
176         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
177 
178     /// @dev The constructor that is called when the contract is being deployed.
179     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
180         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
181         // will not revert, but the contract will need to be registered with the registry once it is deployed in
182         // order for the modifier to filter addresses.
183         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
184             if (subscribe) {
185                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
186             } else {
187                 if (subscriptionOrRegistrantToCopy != address(0)) {
188                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
189                 } else {
190                     OPERATOR_FILTER_REGISTRY.register(address(this));
191                 }
192             }
193         }
194     }
195 
196     /**
197      * @dev A helper function to check if an operator is allowed.
198      */
199     modifier onlyAllowedOperator(address from) virtual {
200         // Allow spending tokens from addresses with balance
201         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
202         // from an EOA.
203         if (from != msg.sender) {
204             _checkFilterOperator(msg.sender);
205         }
206         _;
207     }
208 
209     /**
210      * @dev A helper function to check if an operator approval is allowed.
211      */
212     modifier onlyAllowedOperatorApproval(address operator) virtual {
213         _checkFilterOperator(operator);
214         _;
215     }
216 
217     /**
218      * @dev A helper function to check if an operator is allowed.
219      */
220     function _checkFilterOperator(address operator) internal view virtual {
221         // Check registry code length to facilitate testing in environments without a deployed registry.
222         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
223             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
224             // may specify their own OperatorFilterRegistry implementations, which may behave differently
225             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
226                 revert OperatorNotAllowed(operator);
227             }
228         }
229     }
230 }
231 
232 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
233 
234 
235 pragma solidity ^0.8.13;
236 
237 
238 /**
239  * @title  DefaultOperatorFilterer
240  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
241  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
242  *         administration methods on the contract itself to interact with the registry otherwise the subscription
243  *         will be locked to the options set during construction.
244  */
245 
246 abstract contract DefaultOperatorFilterer is OperatorFilterer {
247     /// @dev The constructor that is called when the contract is being deployed.
248     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
249 }
250 
251 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
252 
253 
254 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/MerkleProof.sol)
255 
256 pragma solidity ^0.8.0;
257 
258 /**
259  * @dev These functions deal with verification of Merkle Tree proofs.
260  *
261  * The tree and the proofs can be generated using our
262  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
263  * You will find a quickstart guide in the readme.
264  *
265  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
266  * hashing, or use a hash function other than keccak256 for hashing leaves.
267  * This is because the concatenation of a sorted pair of internal nodes in
268  * the merkle tree could be reinterpreted as a leaf value.
269  * OpenZeppelin's JavaScript library generates merkle trees that are safe
270  * against this attack out of the box.
271  */
272 library MerkleProof {
273     /**
274      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
275      * defined by `root`. For this, a `proof` must be provided, containing
276      * sibling hashes on the branch from the leaf to the root of the tree. Each
277      * pair of leaves and each pair of pre-images are assumed to be sorted.
278      */
279     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
280         return processProof(proof, leaf) == root;
281     }
282 
283     /**
284      * @dev Calldata version of {verify}
285      *
286      * _Available since v4.7._
287      */
288     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
289         return processProofCalldata(proof, leaf) == root;
290     }
291 
292     /**
293      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
294      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
295      * hash matches the root of the tree. When processing the proof, the pairs
296      * of leafs & pre-images are assumed to be sorted.
297      *
298      * _Available since v4.4._
299      */
300     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
301         bytes32 computedHash = leaf;
302         for (uint256 i = 0; i < proof.length; i++) {
303             computedHash = _hashPair(computedHash, proof[i]);
304         }
305         return computedHash;
306     }
307 
308     /**
309      * @dev Calldata version of {processProof}
310      *
311      * _Available since v4.7._
312      */
313     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
314         bytes32 computedHash = leaf;
315         for (uint256 i = 0; i < proof.length; i++) {
316             computedHash = _hashPair(computedHash, proof[i]);
317         }
318         return computedHash;
319     }
320 
321     /**
322      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
323      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
324      *
325      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
326      *
327      * _Available since v4.7._
328      */
329     function multiProofVerify(
330         bytes32[] memory proof,
331         bool[] memory proofFlags,
332         bytes32 root,
333         bytes32[] memory leaves
334     ) internal pure returns (bool) {
335         return processMultiProof(proof, proofFlags, leaves) == root;
336     }
337 
338     /**
339      * @dev Calldata version of {multiProofVerify}
340      *
341      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
342      *
343      * _Available since v4.7._
344      */
345     function multiProofVerifyCalldata(
346         bytes32[] calldata proof,
347         bool[] calldata proofFlags,
348         bytes32 root,
349         bytes32[] memory leaves
350     ) internal pure returns (bool) {
351         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
352     }
353 
354     /**
355      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
356      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
357      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
358      * respectively.
359      *
360      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
361      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
362      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
363      *
364      * _Available since v4.7._
365      */
366     function processMultiProof(
367         bytes32[] memory proof,
368         bool[] memory proofFlags,
369         bytes32[] memory leaves
370     ) internal pure returns (bytes32 merkleRoot) {
371         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
372         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
373         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
374         // the merkle tree.
375         uint256 leavesLen = leaves.length;
376         uint256 totalHashes = proofFlags.length;
377 
378         // Check proof validity.
379         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
380 
381         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
382         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
383         bytes32[] memory hashes = new bytes32[](totalHashes);
384         uint256 leafPos = 0;
385         uint256 hashPos = 0;
386         uint256 proofPos = 0;
387         // At each step, we compute the next hash using two values:
388         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
389         //   get the next hash.
390         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
391         //   `proof` array.
392         for (uint256 i = 0; i < totalHashes; i++) {
393             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
394             bytes32 b = proofFlags[i]
395                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
396                 : proof[proofPos++];
397             hashes[i] = _hashPair(a, b);
398         }
399 
400         if (totalHashes > 0) {
401             unchecked {
402                 return hashes[totalHashes - 1];
403             }
404         } else if (leavesLen > 0) {
405             return leaves[0];
406         } else {
407             return proof[0];
408         }
409     }
410 
411     /**
412      * @dev Calldata version of {processMultiProof}.
413      *
414      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
415      *
416      * _Available since v4.7._
417      */
418     function processMultiProofCalldata(
419         bytes32[] calldata proof,
420         bool[] calldata proofFlags,
421         bytes32[] memory leaves
422     ) internal pure returns (bytes32 merkleRoot) {
423         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
424         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
425         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
426         // the merkle tree.
427         uint256 leavesLen = leaves.length;
428         uint256 totalHashes = proofFlags.length;
429 
430         // Check proof validity.
431         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
432 
433         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
434         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
435         bytes32[] memory hashes = new bytes32[](totalHashes);
436         uint256 leafPos = 0;
437         uint256 hashPos = 0;
438         uint256 proofPos = 0;
439         // At each step, we compute the next hash using two values:
440         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
441         //   get the next hash.
442         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
443         //   `proof` array.
444         for (uint256 i = 0; i < totalHashes; i++) {
445             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
446             bytes32 b = proofFlags[i]
447                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
448                 : proof[proofPos++];
449             hashes[i] = _hashPair(a, b);
450         }
451 
452         if (totalHashes > 0) {
453             unchecked {
454                 return hashes[totalHashes - 1];
455             }
456         } else if (leavesLen > 0) {
457             return leaves[0];
458         } else {
459             return proof[0];
460         }
461     }
462 
463     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
464         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
465     }
466 
467     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
468         /// @solidity memory-safe-assembly
469         assembly {
470             mstore(0x00, a)
471             mstore(0x20, b)
472             value := keccak256(0x00, 0x40)
473         }
474     }
475 }
476 
477 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
478 
479 
480 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
481 
482 pragma solidity ^0.8.0;
483 
484 /**
485  * @dev Contract module that helps prevent reentrant calls to a function.
486  *
487  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
488  * available, which can be applied to functions to make sure there are no nested
489  * (reentrant) calls to them.
490  *
491  * Note that because there is a single `nonReentrant` guard, functions marked as
492  * `nonReentrant` may not call one another. This can be worked around by making
493  * those functions `private`, and then adding `external` `nonReentrant` entry
494  * points to them.
495  *
496  * TIP: If you would like to learn more about reentrancy and alternative ways
497  * to protect against it, check out our blog post
498  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
499  */
500 abstract contract ReentrancyGuard {
501     // Booleans are more expensive than uint256 or any type that takes up a full
502     // word because each write operation emits an extra SLOAD to first read the
503     // slot's contents, replace the bits taken up by the boolean, and then write
504     // back. This is the compiler's defense against contract upgrades and
505     // pointer aliasing, and it cannot be disabled.
506 
507     // The values being non-zero value makes deployment a bit more expensive,
508     // but in exchange the refund on every call to nonReentrant will be lower in
509     // amount. Since refunds are capped to a percentage of the total
510     // transaction's gas, it is best to keep them low in cases like this one, to
511     // increase the likelihood of the full refund coming into effect.
512     uint256 private constant _NOT_ENTERED = 1;
513     uint256 private constant _ENTERED = 2;
514 
515     uint256 private _status;
516 
517     constructor() {
518         _status = _NOT_ENTERED;
519     }
520 
521     /**
522      * @dev Prevents a contract from calling itself, directly or indirectly.
523      * Calling a `nonReentrant` function from another `nonReentrant`
524      * function is not supported. It is possible to prevent this from happening
525      * by making the `nonReentrant` function external, and making it call a
526      * `private` function that does the actual work.
527      */
528     modifier nonReentrant() {
529         _nonReentrantBefore();
530         _;
531         _nonReentrantAfter();
532     }
533 
534     function _nonReentrantBefore() private {
535         // On the first call to nonReentrant, _status will be _NOT_ENTERED
536         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
537 
538         // Any calls to nonReentrant after this point will fail
539         _status = _ENTERED;
540     }
541 
542     function _nonReentrantAfter() private {
543         // By storing the original value once again, a refund is triggered (see
544         // https://eips.ethereum.org/EIPS/eip-2200)
545         _status = _NOT_ENTERED;
546     }
547 
548     /**
549      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
550      * `nonReentrant` function in the call stack.
551      */
552     function _reentrancyGuardEntered() internal view returns (bool) {
553         return _status == _ENTERED;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/utils/Context.sol
558 
559 
560 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @dev Provides information about the current execution context, including the
566  * sender of the transaction and its data. While these are generally available
567  * via msg.sender and msg.data, they should not be accessed in such a direct
568  * manner, since when dealing with meta-transactions the account sending and
569  * paying for execution may not be the actual sender (as far as an application
570  * is concerned).
571  *
572  * This contract is only required for intermediate, library-like contracts.
573  */
574 abstract contract Context {
575     function _msgSender() internal view virtual returns (address) {
576         return msg.sender;
577     }
578 
579     function _msgData() internal view virtual returns (bytes calldata) {
580         return msg.data;
581     }
582 }
583 
584 // File: @openzeppelin/contracts/access/Ownable.sol
585 
586 
587 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Contract module which provides a basic access control mechanism, where
594  * there is an account (an owner) that can be granted exclusive access to
595  * specific functions.
596  *
597  * By default, the owner account will be the one that deploys the contract. This
598  * can later be changed with {transferOwnership}.
599  *
600  * This module is used through inheritance. It will make available the modifier
601  * `onlyOwner`, which can be applied to your functions to restrict their use to
602  * the owner.
603  */
604 abstract contract Ownable is Context {
605     address private _owner;
606 
607     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
608 
609     /**
610      * @dev Initializes the contract setting the deployer as the initial owner.
611      */
612     constructor() {
613         _transferOwnership(_msgSender());
614     }
615 
616     /**
617      * @dev Throws if called by any account other than the owner.
618      */
619     modifier onlyOwner() {
620         _checkOwner();
621         _;
622     }
623 
624     /**
625      * @dev Returns the address of the current owner.
626      */
627     function owner() public view virtual returns (address) {
628         return _owner;
629     }
630 
631     /**
632      * @dev Throws if the sender is not the owner.
633      */
634     function _checkOwner() internal view virtual {
635         require(owner() == _msgSender(), "Ownable: caller is not the owner");
636     }
637 
638     /**
639      * @dev Leaves the contract without owner. It will not be possible to call
640      * `onlyOwner` functions. Can only be called by the current owner.
641      *
642      * NOTE: Renouncing ownership will leave the contract without an owner,
643      * thereby disabling any functionality that is only available to the owner.
644      */
645     function renounceOwnership() public virtual onlyOwner {
646         _transferOwnership(address(0));
647     }
648 
649     /**
650      * @dev Transfers ownership of the contract to a new account (`newOwner`).
651      * Can only be called by the current owner.
652      */
653     function transferOwnership(address newOwner) public virtual onlyOwner {
654         require(newOwner != address(0), "Ownable: new owner is the zero address");
655         _transferOwnership(newOwner);
656     }
657 
658     /**
659      * @dev Transfers ownership of the contract to a new account (`newOwner`).
660      * Internal function without access restriction.
661      */
662     function _transferOwnership(address newOwner) internal virtual {
663         address oldOwner = _owner;
664         _owner = newOwner;
665         emit OwnershipTransferred(oldOwner, newOwner);
666     }
667 }
668 
669 // File: erc721a/contracts/IERC721A.sol
670 
671 
672 // ERC721A Contracts v4.2.3
673 // Creator: Chiru Labs
674 
675 pragma solidity ^0.8.4;
676 
677 /**
678  * @dev Interface of ERC721A.
679  */
680 interface IERC721A {
681     /**
682      * The caller must own the token or be an approved operator.
683      */
684     error ApprovalCallerNotOwnerNorApproved();
685 
686     /**
687      * The token does not exist.
688      */
689     error ApprovalQueryForNonexistentToken();
690 
691     /**
692      * Cannot query the balance for the zero address.
693      */
694     error BalanceQueryForZeroAddress();
695 
696     /**
697      * Cannot mint to the zero address.
698      */
699     error MintToZeroAddress();
700 
701     /**
702      * The quantity of tokens minted must be more than zero.
703      */
704     error MintZeroQuantity();
705 
706     /**
707      * The token does not exist.
708      */
709     error OwnerQueryForNonexistentToken();
710 
711     /**
712      * The caller must own the token or be an approved operator.
713      */
714     error TransferCallerNotOwnerNorApproved();
715 
716     /**
717      * The token must be owned by `from`.
718      */
719     error TransferFromIncorrectOwner();
720 
721     /**
722      * Cannot safely transfer to a contract that does not implement the
723      * ERC721Receiver interface.
724      */
725     error TransferToNonERC721ReceiverImplementer();
726 
727     /**
728      * Cannot transfer to the zero address.
729      */
730     error TransferToZeroAddress();
731 
732     /**
733      * The token does not exist.
734      */
735     error URIQueryForNonexistentToken();
736 
737     /**
738      * The `quantity` minted with ERC2309 exceeds the safety limit.
739      */
740     error MintERC2309QuantityExceedsLimit();
741 
742     /**
743      * The `extraData` cannot be set on an unintialized ownership slot.
744      */
745     error OwnershipNotInitializedForExtraData();
746 
747     // =============================================================
748     //                            STRUCTS
749     // =============================================================
750 
751     struct TokenOwnership {
752         // The address of the owner.
753         address addr;
754         // Stores the start time of ownership with minimal overhead for tokenomics.
755         uint64 startTimestamp;
756         // Whether the token has been burned.
757         bool burned;
758         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
759         uint24 extraData;
760     }
761 
762     // =============================================================
763     //                         TOKEN COUNTERS
764     // =============================================================
765 
766     /**
767      * @dev Returns the total number of tokens in existence.
768      * Burned tokens will reduce the count.
769      * To get the total number of tokens minted, please see {_totalMinted}.
770      */
771     function totalSupply() external view returns (uint256);
772 
773     // =============================================================
774     //                            IERC165
775     // =============================================================
776 
777     /**
778      * @dev Returns true if this contract implements the interface defined by
779      * `interfaceId`. See the corresponding
780      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
781      * to learn more about how these ids are created.
782      *
783      * This function call must use less than 30000 gas.
784      */
785     function supportsInterface(bytes4 interfaceId) external view returns (bool);
786 
787     // =============================================================
788     //                            IERC721
789     // =============================================================
790 
791     /**
792      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
793      */
794     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
795 
796     /**
797      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
798      */
799     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
800 
801     /**
802      * @dev Emitted when `owner` enables or disables
803      * (`approved`) `operator` to manage all of its assets.
804      */
805     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
806 
807     /**
808      * @dev Returns the number of tokens in `owner`'s account.
809      */
810     function balanceOf(address owner) external view returns (uint256 balance);
811 
812     /**
813      * @dev Returns the owner of the `tokenId` token.
814      *
815      * Requirements:
816      *
817      * - `tokenId` must exist.
818      */
819     function ownerOf(uint256 tokenId) external view returns (address owner);
820 
821     /**
822      * @dev Safely transfers `tokenId` token from `from` to `to`,
823      * checking first that contract recipients are aware of the ERC721 protocol
824      * to prevent tokens from being forever locked.
825      *
826      * Requirements:
827      *
828      * - `from` cannot be the zero address.
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must exist and be owned by `from`.
831      * - If the caller is not `from`, it must be have been allowed to move
832      * this token by either {approve} or {setApprovalForAll}.
833      * - If `to` refers to a smart contract, it must implement
834      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
835      *
836      * Emits a {Transfer} event.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId,
842         bytes calldata data
843     ) external payable;
844 
845     /**
846      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
847      */
848     function safeTransferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) external payable;
853 
854     /**
855      * @dev Transfers `tokenId` from `from` to `to`.
856      *
857      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
858      * whenever possible.
859      *
860      * Requirements:
861      *
862      * - `from` cannot be the zero address.
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must be owned by `from`.
865      * - If the caller is not `from`, it must be approved to move this token
866      * by either {approve} or {setApprovalForAll}.
867      *
868      * Emits a {Transfer} event.
869      */
870     function transferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) external payable;
875 
876     /**
877      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
878      * The approval is cleared when the token is transferred.
879      *
880      * Only a single account can be approved at a time, so approving the
881      * zero address clears previous approvals.
882      *
883      * Requirements:
884      *
885      * - The caller must own the token or be an approved operator.
886      * - `tokenId` must exist.
887      *
888      * Emits an {Approval} event.
889      */
890     function approve(address to, uint256 tokenId) external payable;
891 
892     /**
893      * @dev Approve or remove `operator` as an operator for the caller.
894      * Operators can call {transferFrom} or {safeTransferFrom}
895      * for any token owned by the caller.
896      *
897      * Requirements:
898      *
899      * - The `operator` cannot be the caller.
900      *
901      * Emits an {ApprovalForAll} event.
902      */
903     function setApprovalForAll(address operator, bool _approved) external;
904 
905     /**
906      * @dev Returns the account approved for `tokenId` token.
907      *
908      * Requirements:
909      *
910      * - `tokenId` must exist.
911      */
912     function getApproved(uint256 tokenId) external view returns (address operator);
913 
914     /**
915      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
916      *
917      * See {setApprovalForAll}.
918      */
919     function isApprovedForAll(address owner, address operator) external view returns (bool);
920 
921     // =============================================================
922     //                        IERC721Metadata
923     // =============================================================
924 
925     /**
926      * @dev Returns the token collection name.
927      */
928     function name() external view returns (string memory);
929 
930     /**
931      * @dev Returns the token collection symbol.
932      */
933     function symbol() external view returns (string memory);
934 
935     /**
936      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
937      */
938     function tokenURI(uint256 tokenId) external view returns (string memory);
939 
940     // =============================================================
941     //                           IERC2309
942     // =============================================================
943 
944     /**
945      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
946      * (inclusive) is transferred from `from` to `to`, as defined in the
947      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
948      *
949      * See {_mintERC2309} for more details.
950      */
951     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
952 }
953 
954 // File: erc721a/contracts/ERC721A.sol
955 
956 
957 // ERC721A Contracts v4.2.3
958 // Creator: Chiru Labs
959 
960 pragma solidity ^0.8.4;
961 
962 
963 /**
964  * @dev Interface of ERC721 token receiver.
965  */
966 interface ERC721A__IERC721Receiver {
967     function onERC721Received(
968         address operator,
969         address from,
970         uint256 tokenId,
971         bytes calldata data
972     ) external returns (bytes4);
973 }
974 
975 /**
976  * @title ERC721A
977  *
978  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
979  * Non-Fungible Token Standard, including the Metadata extension.
980  * Optimized for lower gas during batch mints.
981  *
982  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
983  * starting from `_startTokenId()`.
984  *
985  * Assumptions:
986  *
987  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
988  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
989  */
990 contract ERC721A is IERC721A {
991     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
992     struct TokenApprovalRef {
993         address value;
994     }
995 
996     // =============================================================
997     //                           CONSTANTS
998     // =============================================================
999 
1000     // Mask of an entry in packed address data.
1001     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1002 
1003     // The bit position of `numberMinted` in packed address data.
1004     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1005 
1006     // The bit position of `numberBurned` in packed address data.
1007     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1008 
1009     // The bit position of `aux` in packed address data.
1010     uint256 private constant _BITPOS_AUX = 192;
1011 
1012     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1013     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1014 
1015     // The bit position of `startTimestamp` in packed ownership.
1016     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1017 
1018     // The bit mask of the `burned` bit in packed ownership.
1019     uint256 private constant _BITMASK_BURNED = 1 << 224;
1020 
1021     // The bit position of the `nextInitialized` bit in packed ownership.
1022     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1023 
1024     // The bit mask of the `nextInitialized` bit in packed ownership.
1025     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1026 
1027     // The bit position of `extraData` in packed ownership.
1028     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1029 
1030     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1031     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1032 
1033     // The mask of the lower 160 bits for addresses.
1034     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1035 
1036     // The maximum `quantity` that can be minted with {_mintERC2309}.
1037     // This limit is to prevent overflows on the address data entries.
1038     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1039     // is required to cause an overflow, which is unrealistic.
1040     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1041 
1042     // The `Transfer` event signature is given by:
1043     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1044     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1045         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1046 
1047     // =============================================================
1048     //                            STORAGE
1049     // =============================================================
1050 
1051     // The next token ID to be minted.
1052     uint256 private _currentIndex;
1053 
1054     // The number of tokens burned.
1055     uint256 private _burnCounter;
1056 
1057     // Token name
1058     string private _name;
1059 
1060     // Token symbol
1061     string private _symbol;
1062 
1063     // Mapping from token ID to ownership details
1064     // An empty struct value does not necessarily mean the token is unowned.
1065     // See {_packedOwnershipOf} implementation for details.
1066     //
1067     // Bits Layout:
1068     // - [0..159]   `addr`
1069     // - [160..223] `startTimestamp`
1070     // - [224]      `burned`
1071     // - [225]      `nextInitialized`
1072     // - [232..255] `extraData`
1073     mapping(uint256 => uint256) private _packedOwnerships;
1074 
1075     // Mapping owner address to address data.
1076     //
1077     // Bits Layout:
1078     // - [0..63]    `balance`
1079     // - [64..127]  `numberMinted`
1080     // - [128..191] `numberBurned`
1081     // - [192..255] `aux`
1082     mapping(address => uint256) private _packedAddressData;
1083 
1084     // Mapping from token ID to approved address.
1085     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1086 
1087     // Mapping from owner to operator approvals
1088     mapping(address => mapping(address => bool)) private _operatorApprovals;
1089 
1090     // =============================================================
1091     //                          CONSTRUCTOR
1092     // =============================================================
1093 
1094     constructor(string memory name_, string memory symbol_) {
1095         _name = name_;
1096         _symbol = symbol_;
1097         _currentIndex = _startTokenId();
1098     }
1099 
1100     // =============================================================
1101     //                   TOKEN COUNTING OPERATIONS
1102     // =============================================================
1103 
1104     /**
1105      * @dev Returns the starting token ID.
1106      * To change the starting token ID, please override this function.
1107      */
1108     function _startTokenId() internal view virtual returns (uint256) {
1109         return 0;
1110     }
1111 
1112     /**
1113      * @dev Returns the next token ID to be minted.
1114      */
1115     function _nextTokenId() internal view virtual returns (uint256) {
1116         return _currentIndex;
1117     }
1118 
1119     /**
1120      * @dev Returns the total number of tokens in existence.
1121      * Burned tokens will reduce the count.
1122      * To get the total number of tokens minted, please see {_totalMinted}.
1123      */
1124     function totalSupply() public view virtual override returns (uint256) {
1125         // Counter underflow is impossible as _burnCounter cannot be incremented
1126         // more than `_currentIndex - _startTokenId()` times.
1127         unchecked {
1128             return _currentIndex - _burnCounter - _startTokenId();
1129         }
1130     }
1131 
1132     /**
1133      * @dev Returns the total amount of tokens minted in the contract.
1134      */
1135     function _totalMinted() internal view virtual returns (uint256) {
1136         // Counter underflow is impossible as `_currentIndex` does not decrement,
1137         // and it is initialized to `_startTokenId()`.
1138         unchecked {
1139             return _currentIndex - _startTokenId();
1140         }
1141     }
1142 
1143     /**
1144      * @dev Returns the total number of tokens burned.
1145      */
1146     function _totalBurned() internal view virtual returns (uint256) {
1147         return _burnCounter;
1148     }
1149 
1150     // =============================================================
1151     //                    ADDRESS DATA OPERATIONS
1152     // =============================================================
1153 
1154     /**
1155      * @dev Returns the number of tokens in `owner`'s account.
1156      */
1157     function balanceOf(address owner) public view virtual override returns (uint256) {
1158         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1159         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1160     }
1161 
1162     /**
1163      * Returns the number of tokens minted by `owner`.
1164      */
1165     function _numberMinted(address owner) internal view returns (uint256) {
1166         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1167     }
1168 
1169     /**
1170      * Returns the number of tokens burned by or on behalf of `owner`.
1171      */
1172     function _numberBurned(address owner) internal view returns (uint256) {
1173         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1174     }
1175 
1176     /**
1177      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1178      */
1179     function _getAux(address owner) internal view returns (uint64) {
1180         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1181     }
1182 
1183     /**
1184      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1185      * If there are multiple variables, please pack them into a uint64.
1186      */
1187     function _setAux(address owner, uint64 aux) internal virtual {
1188         uint256 packed = _packedAddressData[owner];
1189         uint256 auxCasted;
1190         // Cast `aux` with assembly to avoid redundant masking.
1191         assembly {
1192             auxCasted := aux
1193         }
1194         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1195         _packedAddressData[owner] = packed;
1196     }
1197 
1198     // =============================================================
1199     //                            IERC165
1200     // =============================================================
1201 
1202     /**
1203      * @dev Returns true if this contract implements the interface defined by
1204      * `interfaceId`. See the corresponding
1205      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1206      * to learn more about how these ids are created.
1207      *
1208      * This function call must use less than 30000 gas.
1209      */
1210     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1211         // The interface IDs are constants representing the first 4 bytes
1212         // of the XOR of all function selectors in the interface.
1213         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1214         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1215         return
1216             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1217             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1218             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1219     }
1220 
1221     // =============================================================
1222     //                        IERC721Metadata
1223     // =============================================================
1224 
1225     /**
1226      * @dev Returns the token collection name.
1227      */
1228     function name() public view virtual override returns (string memory) {
1229         return _name;
1230     }
1231 
1232     /**
1233      * @dev Returns the token collection symbol.
1234      */
1235     function symbol() public view virtual override returns (string memory) {
1236         return _symbol;
1237     }
1238 
1239     /**
1240      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1241      */
1242     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1243         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1244 
1245         string memory baseURI = _baseURI();
1246         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1247     }
1248 
1249     /**
1250      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1251      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1252      * by default, it can be overridden in child contracts.
1253      */
1254     function _baseURI() internal view virtual returns (string memory) {
1255         return '';
1256     }
1257 
1258     // =============================================================
1259     //                     OWNERSHIPS OPERATIONS
1260     // =============================================================
1261 
1262     /**
1263      * @dev Returns the owner of the `tokenId` token.
1264      *
1265      * Requirements:
1266      *
1267      * - `tokenId` must exist.
1268      */
1269     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1270         return address(uint160(_packedOwnershipOf(tokenId)));
1271     }
1272 
1273     /**
1274      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1275      * It gradually moves to O(1) as tokens get transferred around over time.
1276      */
1277     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1278         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1279     }
1280 
1281     /**
1282      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1283      */
1284     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1285         return _unpackedOwnership(_packedOwnerships[index]);
1286     }
1287 
1288     /**
1289      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1290      */
1291     function _initializeOwnershipAt(uint256 index) internal virtual {
1292         if (_packedOwnerships[index] == 0) {
1293             _packedOwnerships[index] = _packedOwnershipOf(index);
1294         }
1295     }
1296 
1297     /**
1298      * Returns the packed ownership data of `tokenId`.
1299      */
1300     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1301         uint256 curr = tokenId;
1302 
1303         unchecked {
1304             if (_startTokenId() <= curr)
1305                 if (curr < _currentIndex) {
1306                     uint256 packed = _packedOwnerships[curr];
1307                     // If not burned.
1308                     if (packed & _BITMASK_BURNED == 0) {
1309                         // Invariant:
1310                         // There will always be an initialized ownership slot
1311                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1312                         // before an unintialized ownership slot
1313                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1314                         // Hence, `curr` will not underflow.
1315                         //
1316                         // We can directly compare the packed value.
1317                         // If the address is zero, packed will be zero.
1318                         while (packed == 0) {
1319                             packed = _packedOwnerships[--curr];
1320                         }
1321                         return packed;
1322                     }
1323                 }
1324         }
1325         revert OwnerQueryForNonexistentToken();
1326     }
1327 
1328     /**
1329      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1330      */
1331     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1332         ownership.addr = address(uint160(packed));
1333         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1334         ownership.burned = packed & _BITMASK_BURNED != 0;
1335         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1336     }
1337 
1338     /**
1339      * @dev Packs ownership data into a single uint256.
1340      */
1341     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1342         assembly {
1343             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1344             owner := and(owner, _BITMASK_ADDRESS)
1345             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1346             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1347         }
1348     }
1349 
1350     /**
1351      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1352      */
1353     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1354         // For branchless setting of the `nextInitialized` flag.
1355         assembly {
1356             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1357             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1358         }
1359     }
1360 
1361     // =============================================================
1362     //                      APPROVAL OPERATIONS
1363     // =============================================================
1364 
1365     /**
1366      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1367      * The approval is cleared when the token is transferred.
1368      *
1369      * Only a single account can be approved at a time, so approving the
1370      * zero address clears previous approvals.
1371      *
1372      * Requirements:
1373      *
1374      * - The caller must own the token or be an approved operator.
1375      * - `tokenId` must exist.
1376      *
1377      * Emits an {Approval} event.
1378      */
1379     function approve(address to, uint256 tokenId) public payable virtual override {
1380         address owner = ownerOf(tokenId);
1381 
1382         if (_msgSenderERC721A() != owner)
1383             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1384                 revert ApprovalCallerNotOwnerNorApproved();
1385             }
1386 
1387         _tokenApprovals[tokenId].value = to;
1388         emit Approval(owner, to, tokenId);
1389     }
1390 
1391     /**
1392      * @dev Returns the account approved for `tokenId` token.
1393      *
1394      * Requirements:
1395      *
1396      * - `tokenId` must exist.
1397      */
1398     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1399         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1400 
1401         return _tokenApprovals[tokenId].value;
1402     }
1403 
1404     /**
1405      * @dev Approve or remove `operator` as an operator for the caller.
1406      * Operators can call {transferFrom} or {safeTransferFrom}
1407      * for any token owned by the caller.
1408      *
1409      * Requirements:
1410      *
1411      * - The `operator` cannot be the caller.
1412      *
1413      * Emits an {ApprovalForAll} event.
1414      */
1415     function setApprovalForAll(address operator, bool approved) public virtual override {
1416         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1417         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1418     }
1419 
1420     /**
1421      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1422      *
1423      * See {setApprovalForAll}.
1424      */
1425     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1426         return _operatorApprovals[owner][operator];
1427     }
1428 
1429     /**
1430      * @dev Returns whether `tokenId` exists.
1431      *
1432      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1433      *
1434      * Tokens start existing when they are minted. See {_mint}.
1435      */
1436     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1437         return
1438             _startTokenId() <= tokenId &&
1439             tokenId < _currentIndex && // If within bounds,
1440             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1441     }
1442 
1443     /**
1444      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1445      */
1446     function _isSenderApprovedOrOwner(
1447         address approvedAddress,
1448         address owner,
1449         address msgSender
1450     ) private pure returns (bool result) {
1451         assembly {
1452             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1453             owner := and(owner, _BITMASK_ADDRESS)
1454             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1455             msgSender := and(msgSender, _BITMASK_ADDRESS)
1456             // `msgSender == owner || msgSender == approvedAddress`.
1457             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1458         }
1459     }
1460 
1461     /**
1462      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1463      */
1464     function _getApprovedSlotAndAddress(uint256 tokenId)
1465         private
1466         view
1467         returns (uint256 approvedAddressSlot, address approvedAddress)
1468     {
1469         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1470         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1471         assembly {
1472             approvedAddressSlot := tokenApproval.slot
1473             approvedAddress := sload(approvedAddressSlot)
1474         }
1475     }
1476 
1477     // =============================================================
1478     //                      TRANSFER OPERATIONS
1479     // =============================================================
1480 
1481     /**
1482      * @dev Transfers `tokenId` from `from` to `to`.
1483      *
1484      * Requirements:
1485      *
1486      * - `from` cannot be the zero address.
1487      * - `to` cannot be the zero address.
1488      * - `tokenId` token must be owned by `from`.
1489      * - If the caller is not `from`, it must be approved to move this token
1490      * by either {approve} or {setApprovalForAll}.
1491      *
1492      * Emits a {Transfer} event.
1493      */
1494     function transferFrom(
1495         address from,
1496         address to,
1497         uint256 tokenId
1498     ) public payable virtual override {
1499         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1500 
1501         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1502 
1503         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1504 
1505         // The nested ifs save around 20+ gas over a compound boolean condition.
1506         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1507             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1508 
1509         if (to == address(0)) revert TransferToZeroAddress();
1510 
1511         _beforeTokenTransfers(from, to, tokenId, 1);
1512 
1513         // Clear approvals from the previous owner.
1514         assembly {
1515             if approvedAddress {
1516                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1517                 sstore(approvedAddressSlot, 0)
1518             }
1519         }
1520 
1521         // Underflow of the sender's balance is impossible because we check for
1522         // ownership above and the recipient's balance can't realistically overflow.
1523         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1524         unchecked {
1525             // We can directly increment and decrement the balances.
1526             --_packedAddressData[from]; // Updates: `balance -= 1`.
1527             ++_packedAddressData[to]; // Updates: `balance += 1`.
1528 
1529             // Updates:
1530             // - `address` to the next owner.
1531             // - `startTimestamp` to the timestamp of transfering.
1532             // - `burned` to `false`.
1533             // - `nextInitialized` to `true`.
1534             _packedOwnerships[tokenId] = _packOwnershipData(
1535                 to,
1536                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1537             );
1538 
1539             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1540             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1541                 uint256 nextTokenId = tokenId + 1;
1542                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1543                 if (_packedOwnerships[nextTokenId] == 0) {
1544                     // If the next slot is within bounds.
1545                     if (nextTokenId != _currentIndex) {
1546                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1547                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1548                     }
1549                 }
1550             }
1551         }
1552 
1553         emit Transfer(from, to, tokenId);
1554         _afterTokenTransfers(from, to, tokenId, 1);
1555     }
1556 
1557     /**
1558      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1559      */
1560     function safeTransferFrom(
1561         address from,
1562         address to,
1563         uint256 tokenId
1564     ) public payable virtual override {
1565         safeTransferFrom(from, to, tokenId, '');
1566     }
1567 
1568     /**
1569      * @dev Safely transfers `tokenId` token from `from` to `to`.
1570      *
1571      * Requirements:
1572      *
1573      * - `from` cannot be the zero address.
1574      * - `to` cannot be the zero address.
1575      * - `tokenId` token must exist and be owned by `from`.
1576      * - If the caller is not `from`, it must be approved to move this token
1577      * by either {approve} or {setApprovalForAll}.
1578      * - If `to` refers to a smart contract, it must implement
1579      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1580      *
1581      * Emits a {Transfer} event.
1582      */
1583     function safeTransferFrom(
1584         address from,
1585         address to,
1586         uint256 tokenId,
1587         bytes memory _data
1588     ) public payable virtual override {
1589         transferFrom(from, to, tokenId);
1590         if (to.code.length != 0)
1591             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1592                 revert TransferToNonERC721ReceiverImplementer();
1593             }
1594     }
1595 
1596     /**
1597      * @dev Hook that is called before a set of serially-ordered token IDs
1598      * are about to be transferred. This includes minting.
1599      * And also called before burning one token.
1600      *
1601      * `startTokenId` - the first token ID to be transferred.
1602      * `quantity` - the amount to be transferred.
1603      *
1604      * Calling conditions:
1605      *
1606      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1607      * transferred to `to`.
1608      * - When `from` is zero, `tokenId` will be minted for `to`.
1609      * - When `to` is zero, `tokenId` will be burned by `from`.
1610      * - `from` and `to` are never both zero.
1611      */
1612     function _beforeTokenTransfers(
1613         address from,
1614         address to,
1615         uint256 startTokenId,
1616         uint256 quantity
1617     ) internal virtual {}
1618 
1619     /**
1620      * @dev Hook that is called after a set of serially-ordered token IDs
1621      * have been transferred. This includes minting.
1622      * And also called after one token has been burned.
1623      *
1624      * `startTokenId` - the first token ID to be transferred.
1625      * `quantity` - the amount to be transferred.
1626      *
1627      * Calling conditions:
1628      *
1629      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1630      * transferred to `to`.
1631      * - When `from` is zero, `tokenId` has been minted for `to`.
1632      * - When `to` is zero, `tokenId` has been burned by `from`.
1633      * - `from` and `to` are never both zero.
1634      */
1635     function _afterTokenTransfers(
1636         address from,
1637         address to,
1638         uint256 startTokenId,
1639         uint256 quantity
1640     ) internal virtual {}
1641 
1642     /**
1643      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1644      *
1645      * `from` - Previous owner of the given token ID.
1646      * `to` - Target address that will receive the token.
1647      * `tokenId` - Token ID to be transferred.
1648      * `_data` - Optional data to send along with the call.
1649      *
1650      * Returns whether the call correctly returned the expected magic value.
1651      */
1652     function _checkContractOnERC721Received(
1653         address from,
1654         address to,
1655         uint256 tokenId,
1656         bytes memory _data
1657     ) private returns (bool) {
1658         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1659             bytes4 retval
1660         ) {
1661             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1662         } catch (bytes memory reason) {
1663             if (reason.length == 0) {
1664                 revert TransferToNonERC721ReceiverImplementer();
1665             } else {
1666                 assembly {
1667                     revert(add(32, reason), mload(reason))
1668                 }
1669             }
1670         }
1671     }
1672 
1673     // =============================================================
1674     //                        MINT OPERATIONS
1675     // =============================================================
1676 
1677     /**
1678      * @dev Mints `quantity` tokens and transfers them to `to`.
1679      *
1680      * Requirements:
1681      *
1682      * - `to` cannot be the zero address.
1683      * - `quantity` must be greater than 0.
1684      *
1685      * Emits a {Transfer} event for each mint.
1686      */
1687     function _mint(address to, uint256 quantity) internal virtual {
1688         uint256 startTokenId = _currentIndex;
1689         if (quantity == 0) revert MintZeroQuantity();
1690 
1691         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1692 
1693         // Overflows are incredibly unrealistic.
1694         // `balance` and `numberMinted` have a maximum limit of 2**64.
1695         // `tokenId` has a maximum limit of 2**256.
1696         unchecked {
1697             // Updates:
1698             // - `balance += quantity`.
1699             // - `numberMinted += quantity`.
1700             //
1701             // We can directly add to the `balance` and `numberMinted`.
1702             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1703 
1704             // Updates:
1705             // - `address` to the owner.
1706             // - `startTimestamp` to the timestamp of minting.
1707             // - `burned` to `false`.
1708             // - `nextInitialized` to `quantity == 1`.
1709             _packedOwnerships[startTokenId] = _packOwnershipData(
1710                 to,
1711                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1712             );
1713 
1714             uint256 toMasked;
1715             uint256 end = startTokenId + quantity;
1716 
1717             // Use assembly to loop and emit the `Transfer` event for gas savings.
1718             // The duplicated `log4` removes an extra check and reduces stack juggling.
1719             // The assembly, together with the surrounding Solidity code, have been
1720             // delicately arranged to nudge the compiler into producing optimized opcodes.
1721             assembly {
1722                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1723                 toMasked := and(to, _BITMASK_ADDRESS)
1724                 // Emit the `Transfer` event.
1725                 log4(
1726                     0, // Start of data (0, since no data).
1727                     0, // End of data (0, since no data).
1728                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1729                     0, // `address(0)`.
1730                     toMasked, // `to`.
1731                     startTokenId // `tokenId`.
1732                 )
1733 
1734                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1735                 // that overflows uint256 will make the loop run out of gas.
1736                 // The compiler will optimize the `iszero` away for performance.
1737                 for {
1738                     let tokenId := add(startTokenId, 1)
1739                 } iszero(eq(tokenId, end)) {
1740                     tokenId := add(tokenId, 1)
1741                 } {
1742                     // Emit the `Transfer` event. Similar to above.
1743                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1744                 }
1745             }
1746             if (toMasked == 0) revert MintToZeroAddress();
1747 
1748             _currentIndex = end;
1749         }
1750         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1751     }
1752 
1753     /**
1754      * @dev Mints `quantity` tokens and transfers them to `to`.
1755      *
1756      * This function is intended for efficient minting only during contract creation.
1757      *
1758      * It emits only one {ConsecutiveTransfer} as defined in
1759      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1760      * instead of a sequence of {Transfer} event(s).
1761      *
1762      * Calling this function outside of contract creation WILL make your contract
1763      * non-compliant with the ERC721 standard.
1764      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1765      * {ConsecutiveTransfer} event is only permissible during contract creation.
1766      *
1767      * Requirements:
1768      *
1769      * - `to` cannot be the zero address.
1770      * - `quantity` must be greater than 0.
1771      *
1772      * Emits a {ConsecutiveTransfer} event.
1773      */
1774     function _mintERC2309(address to, uint256 quantity) internal virtual {
1775         uint256 startTokenId = _currentIndex;
1776         if (to == address(0)) revert MintToZeroAddress();
1777         if (quantity == 0) revert MintZeroQuantity();
1778         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1779 
1780         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1781 
1782         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1783         unchecked {
1784             // Updates:
1785             // - `balance += quantity`.
1786             // - `numberMinted += quantity`.
1787             //
1788             // We can directly add to the `balance` and `numberMinted`.
1789             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1790 
1791             // Updates:
1792             // - `address` to the owner.
1793             // - `startTimestamp` to the timestamp of minting.
1794             // - `burned` to `false`.
1795             // - `nextInitialized` to `quantity == 1`.
1796             _packedOwnerships[startTokenId] = _packOwnershipData(
1797                 to,
1798                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1799             );
1800 
1801             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1802 
1803             _currentIndex = startTokenId + quantity;
1804         }
1805         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1806     }
1807 
1808     /**
1809      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1810      *
1811      * Requirements:
1812      *
1813      * - If `to` refers to a smart contract, it must implement
1814      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1815      * - `quantity` must be greater than 0.
1816      *
1817      * See {_mint}.
1818      *
1819      * Emits a {Transfer} event for each mint.
1820      */
1821     function _safeMint(
1822         address to,
1823         uint256 quantity,
1824         bytes memory _data
1825     ) internal virtual {
1826         _mint(to, quantity);
1827 
1828         unchecked {
1829             if (to.code.length != 0) {
1830                 uint256 end = _currentIndex;
1831                 uint256 index = end - quantity;
1832                 do {
1833                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1834                         revert TransferToNonERC721ReceiverImplementer();
1835                     }
1836                 } while (index < end);
1837                 // Reentrancy protection.
1838                 if (_currentIndex != end) revert();
1839             }
1840         }
1841     }
1842 
1843     /**
1844      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1845      */
1846     function _safeMint(address to, uint256 quantity) internal virtual {
1847         _safeMint(to, quantity, '');
1848     }
1849 
1850     // =============================================================
1851     //                        BURN OPERATIONS
1852     // =============================================================
1853 
1854     /**
1855      * @dev Equivalent to `_burn(tokenId, false)`.
1856      */
1857     function _burn(uint256 tokenId) internal virtual {
1858         _burn(tokenId, false);
1859     }
1860 
1861     /**
1862      * @dev Destroys `tokenId`.
1863      * The approval is cleared when the token is burned.
1864      *
1865      * Requirements:
1866      *
1867      * - `tokenId` must exist.
1868      *
1869      * Emits a {Transfer} event.
1870      */
1871     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1872         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1873 
1874         address from = address(uint160(prevOwnershipPacked));
1875 
1876         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1877 
1878         if (approvalCheck) {
1879             // The nested ifs save around 20+ gas over a compound boolean condition.
1880             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1881                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1882         }
1883 
1884         _beforeTokenTransfers(from, address(0), tokenId, 1);
1885 
1886         // Clear approvals from the previous owner.
1887         assembly {
1888             if approvedAddress {
1889                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1890                 sstore(approvedAddressSlot, 0)
1891             }
1892         }
1893 
1894         // Underflow of the sender's balance is impossible because we check for
1895         // ownership above and the recipient's balance can't realistically overflow.
1896         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1897         unchecked {
1898             // Updates:
1899             // - `balance -= 1`.
1900             // - `numberBurned += 1`.
1901             //
1902             // We can directly decrement the balance, and increment the number burned.
1903             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1904             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1905 
1906             // Updates:
1907             // - `address` to the last owner.
1908             // - `startTimestamp` to the timestamp of burning.
1909             // - `burned` to `true`.
1910             // - `nextInitialized` to `true`.
1911             _packedOwnerships[tokenId] = _packOwnershipData(
1912                 from,
1913                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1914             );
1915 
1916             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1917             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1918                 uint256 nextTokenId = tokenId + 1;
1919                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1920                 if (_packedOwnerships[nextTokenId] == 0) {
1921                     // If the next slot is within bounds.
1922                     if (nextTokenId != _currentIndex) {
1923                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1924                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1925                     }
1926                 }
1927             }
1928         }
1929 
1930         emit Transfer(from, address(0), tokenId);
1931         _afterTokenTransfers(from, address(0), tokenId, 1);
1932 
1933         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1934         unchecked {
1935             _burnCounter++;
1936         }
1937     }
1938 
1939     // =============================================================
1940     //                     EXTRA DATA OPERATIONS
1941     // =============================================================
1942 
1943     /**
1944      * @dev Directly sets the extra data for the ownership data `index`.
1945      */
1946     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1947         uint256 packed = _packedOwnerships[index];
1948         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1949         uint256 extraDataCasted;
1950         // Cast `extraData` with assembly to avoid redundant masking.
1951         assembly {
1952             extraDataCasted := extraData
1953         }
1954         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1955         _packedOwnerships[index] = packed;
1956     }
1957 
1958     /**
1959      * @dev Called during each token transfer to set the 24bit `extraData` field.
1960      * Intended to be overridden by the cosumer contract.
1961      *
1962      * `previousExtraData` - the value of `extraData` before transfer.
1963      *
1964      * Calling conditions:
1965      *
1966      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1967      * transferred to `to`.
1968      * - When `from` is zero, `tokenId` will be minted for `to`.
1969      * - When `to` is zero, `tokenId` will be burned by `from`.
1970      * - `from` and `to` are never both zero.
1971      */
1972     function _extraData(
1973         address from,
1974         address to,
1975         uint24 previousExtraData
1976     ) internal view virtual returns (uint24) {}
1977 
1978     /**
1979      * @dev Returns the next extra data for the packed ownership data.
1980      * The returned result is shifted into position.
1981      */
1982     function _nextExtraData(
1983         address from,
1984         address to,
1985         uint256 prevOwnershipPacked
1986     ) private view returns (uint256) {
1987         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1988         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1989     }
1990 
1991     // =============================================================
1992     //                       OTHER OPERATIONS
1993     // =============================================================
1994 
1995     /**
1996      * @dev Returns the message sender (defaults to `msg.sender`).
1997      *
1998      * If you are writing GSN compatible contracts, you need to override this function.
1999      */
2000     function _msgSenderERC721A() internal view virtual returns (address) {
2001         return msg.sender;
2002     }
2003 
2004     /**
2005      * @dev Converts a uint256 to its ASCII string decimal representation.
2006      */
2007     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2008         assembly {
2009             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2010             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2011             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2012             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2013             let m := add(mload(0x40), 0xa0)
2014             // Update the free memory pointer to allocate.
2015             mstore(0x40, m)
2016             // Assign the `str` to the end.
2017             str := sub(m, 0x20)
2018             // Zeroize the slot after the string.
2019             mstore(str, 0)
2020 
2021             // Cache the end of the memory to calculate the length later.
2022             let end := str
2023 
2024             // We write the string from rightmost digit to leftmost digit.
2025             // The following is essentially a do-while loop that also handles the zero case.
2026             // prettier-ignore
2027             for { let temp := value } 1 {} {
2028                 str := sub(str, 1)
2029                 // Write the character to the pointer.
2030                 // The ASCII index of the '0' character is 48.
2031                 mstore8(str, add(48, mod(temp, 10)))
2032                 // Keep dividing `temp` until zero.
2033                 temp := div(temp, 10)
2034                 // prettier-ignore
2035                 if iszero(temp) { break }
2036             }
2037 
2038             let length := sub(end, str)
2039             // Move the pointer 32 bytes leftwards to make room for the length.
2040             str := sub(str, 0x20)
2041             // Store the length.
2042             mstore(str, length)
2043         }
2044     }
2045 }
2046 
2047 // File: contracts/CryptoPunksBackV2.sol
2048 
2049 
2050 
2051 //Developer : FazelPejmanfar , Twitter :@Pejmanfarfazel
2052 
2053 pragma solidity >=0.7.0 <0.9.0;
2054 
2055 
2056 
2057 
2058 
2059 
2060 contract CryptoPunksBack is
2061     ERC721A,
2062     Ownable,
2063     ReentrancyGuard,
2064     DefaultOperatorFilterer
2065 {
2066     string public baseURI;
2067     string public notRevealedUri = "ipfs://bafkreidehu5kbpeefoabvnypbiolyhremrfzzoata4oqbhpnrv6jnwxghu";
2068     uint256 public cost = 0.0079 ether;
2069     uint256 public maxSupply = 10000;
2070     uint256 public MaxPerWallet = 10;
2071     uint256 public FreePerWallet = 2;
2072     bool public paused = false;
2073     bool public revealed = false;
2074     bool public preSale = true;
2075     bytes32 public merkleRoot;
2076     mapping(address => uint256) public FreeClaimed;
2077 
2078     constructor() ERC721A("CryptoPunksBack", "CPB") {}
2079 
2080     // internal
2081     function _baseURI() internal view virtual override returns (string memory) {
2082         return baseURI;
2083     }
2084 
2085     // public
2086     /// @dev Public mint
2087     function mint(uint256 tokens) public payable nonReentrant {
2088         require(tx.origin == _msgSenderERC721A(), "BTOS NOT ALLOWED");
2089         require(!paused, "CPB: oops contract is paused");
2090         require(!preSale, "CPB: Sale Hasn't started yet");
2091         require(
2092             tokens <= MaxPerWallet,
2093             "CPB: max mint amount per tx exceeded"
2094         );
2095         require(
2096             numberMinted(_msgSenderERC721A()) + tokens <= MaxPerWallet,
2097             "CPB: max NFT per Wallet exceeded"
2098         );
2099         require(totalSupply() + tokens <= maxSupply, "CPB: We Soldout");
2100         require(msg.value >= cost * tokens, "CPB: insufficient funds");
2101         _safeMint(_msgSenderERC721A(), tokens);
2102     }
2103 
2104     /// @dev presale mint for whitelisted
2105     function presalemint(uint256 tokens, bytes32[] calldata merkleProof)
2106         public
2107         payable
2108         nonReentrant
2109     {
2110         require(!paused, "CPB: oops contract is paused");
2111         require(preSale, "CPB: Presale Hasn't started yet");
2112         require(
2113             MerkleProof.verify(
2114                 merkleProof,
2115                 merkleRoot,
2116                 keccak256(abi.encodePacked(msg.sender))
2117             ),
2118             "CPB: You are not Whitelisted"
2119         );
2120         require(tokens <= FreePerWallet, "CPB: max mint per Tx exceeded");
2121         require(
2122             numberMinted(_msgSenderERC721A()) + tokens <= MaxPerWallet,
2123             "CPB: max NFT per Wallet exceeded"
2124         );
2125         require(
2126             FreeClaimed[_msgSenderERC721A()] + tokens <= FreePerWallet,
2127             "CPB: You have minted your Free NFTs"
2128         );
2129 
2130         FreeClaimed[_msgSenderERC721A()] += tokens;
2131         _safeMint(_msgSenderERC721A(), tokens);
2132     }
2133 
2134     /// @dev use it for giveaway and team mint
2135     function airdrop(uint256 _mintAmount, address destination)
2136         public
2137         onlyOwner
2138         nonReentrant
2139     {
2140         require(
2141             totalSupply() + _mintAmount <= maxSupply,
2142             "max NFT limit exceeded"
2143         );
2144 
2145         _safeMint(destination, _mintAmount);
2146     }
2147 
2148     /// @notice returns metadata link of tokenid
2149     function tokenURI(uint256 tokenId)
2150         public
2151         view
2152         virtual
2153         override
2154         returns (string memory)
2155     {
2156         require(
2157             _exists(tokenId),
2158             "ERC721AMetadata: URI query for nonexistent token"
2159         );
2160 
2161         if (revealed == false) {
2162             return notRevealedUri;
2163         }
2164 
2165         string memory currentBaseURI = _baseURI();
2166         return
2167             bytes(currentBaseURI).length > 0
2168                 ? string(
2169                     abi.encodePacked(
2170                         currentBaseURI,
2171                         _toString(tokenId),
2172                         ".json"
2173                     )
2174                 )
2175                 : "";
2176     }
2177 
2178     /// @notice return the number minted by an address
2179     function numberMinted(address owner) public view returns (uint256) {
2180         return _numberMinted(owner);
2181     }
2182 
2183     /// @notice return the tokens owned by an address
2184     function tokensOfOwner(address owner)
2185         public
2186         view
2187         returns (uint256[] memory)
2188     {
2189         unchecked {
2190             uint256 tokenIdsIdx;
2191             address currOwnershipAddr;
2192             uint256 tokenIdsLength = balanceOf(owner);
2193             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2194             TokenOwnership memory ownership;
2195             for (
2196                 uint256 i = _startTokenId();
2197                 tokenIdsIdx != tokenIdsLength;
2198                 ++i
2199             ) {
2200                 ownership = _ownershipAt(i);
2201                 if (ownership.burned) {
2202                     continue;
2203                 }
2204                 if (ownership.addr != address(0)) {
2205                     currOwnershipAddr = ownership.addr;
2206                 }
2207                 if (currOwnershipAddr == owner) {
2208                     tokenIds[tokenIdsIdx++] = i;
2209                 }
2210             }
2211             return tokenIds;
2212         }
2213     }
2214 
2215     //only owner
2216     function reveal(bool _state) public onlyOwner {
2217         revealed = _state;
2218     }
2219 
2220     /// @dev change the merkle root for the whitelist phase
2221     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2222         merkleRoot = _merkleRoot;
2223     }
2224 
2225     /// @dev change the public price(amount need to be in wei)
2226     function setCost(uint256 _newCost) public onlyOwner {
2227         cost = _newCost;
2228     }
2229 
2230     /// @dev cut the supply if we dont sold out
2231     function setMaxsupply(uint256 _newsupply) public onlyOwner {
2232         maxSupply = _newsupply;
2233     }
2234 
2235     function setMaxPerWallet(uint256 _newwallet) public onlyOwner {
2236         MaxPerWallet = _newwallet;
2237     }
2238 
2239         function setFreePerWallet(uint256 _newfree) public onlyOwner {
2240         FreePerWallet = _newfree;
2241     }
2242 
2243     /// @dev set your baseuri
2244     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2245         baseURI = _newBaseURI;
2246     }
2247 
2248     /// @dev set hidden uri
2249     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2250         notRevealedUri = _notRevealedURI;
2251     }
2252 
2253     /// @dev to pause and unpause your contract(use booleans true or false)
2254     function pause(bool _state) public onlyOwner {
2255         paused = _state;
2256     }
2257 
2258     /// @dev activate whitelist sale(use booleans true or false)
2259     function togglepreSale(bool _state) external onlyOwner {
2260         preSale = _state;
2261     }
2262 
2263     /// @dev withdraw funds from contract
2264     function withdraw() public payable onlyOwner nonReentrant {
2265         uint256 balance = address(this).balance;
2266         payable(_msgSenderERC721A()).transfer(balance);
2267     }
2268 
2269     /// Opensea Royalties
2270     function transferFrom(
2271         address from,
2272         address to,
2273         uint256 tokenId
2274     ) public payable override onlyAllowedOperator(from) {
2275         super.transferFrom(from, to, tokenId);
2276     }
2277 
2278     function safeTransferFrom(
2279         address from,
2280         address to,
2281         uint256 tokenId
2282     ) public payable override onlyAllowedOperator(from) {
2283         super.safeTransferFrom(from, to, tokenId);
2284     }
2285 
2286     function safeTransferFrom(
2287         address from,
2288         address to,
2289         uint256 tokenId,
2290         bytes memory data
2291     ) public payable override onlyAllowedOperator(from) {
2292         super.safeTransferFrom(from, to, tokenId, data);
2293     }
2294 }