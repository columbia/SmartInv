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
475 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
476 
477 
478 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev Contract module that helps prevent reentrant calls to a function.
484  *
485  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
486  * available, which can be applied to functions to make sure there are no nested
487  * (reentrant) calls to them.
488  *
489  * Note that because there is a single `nonReentrant` guard, functions marked as
490  * `nonReentrant` may not call one another. This can be worked around by making
491  * those functions `private`, and then adding `external` `nonReentrant` entry
492  * points to them.
493  *
494  * TIP: If you would like to learn more about reentrancy and alternative ways
495  * to protect against it, check out our blog post
496  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
497  */
498 abstract contract ReentrancyGuard {
499     // Booleans are more expensive than uint256 or any type that takes up a full
500     // word because each write operation emits an extra SLOAD to first read the
501     // slot's contents, replace the bits taken up by the boolean, and then write
502     // back. This is the compiler's defense against contract upgrades and
503     // pointer aliasing, and it cannot be disabled.
504 
505     // The values being non-zero value makes deployment a bit more expensive,
506     // but in exchange the refund on every call to nonReentrant will be lower in
507     // amount. Since refunds are capped to a percentage of the total
508     // transaction's gas, it is best to keep them low in cases like this one, to
509     // increase the likelihood of the full refund coming into effect.
510     uint256 private constant _NOT_ENTERED = 1;
511     uint256 private constant _ENTERED = 2;
512 
513     uint256 private _status;
514 
515     constructor() {
516         _status = _NOT_ENTERED;
517     }
518 
519     /**
520      * @dev Prevents a contract from calling itself, directly or indirectly.
521      * Calling a `nonReentrant` function from another `nonReentrant`
522      * function is not supported. It is possible to prevent this from happening
523      * by making the `nonReentrant` function external, and making it call a
524      * `private` function that does the actual work.
525      */
526     modifier nonReentrant() {
527         _nonReentrantBefore();
528         _;
529         _nonReentrantAfter();
530     }
531 
532     function _nonReentrantBefore() private {
533         // On the first call to nonReentrant, _status will be _NOT_ENTERED
534         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
535 
536         // Any calls to nonReentrant after this point will fail
537         _status = _ENTERED;
538     }
539 
540     function _nonReentrantAfter() private {
541         // By storing the original value once again, a refund is triggered (see
542         // https://eips.ethereum.org/EIPS/eip-2200)
543         _status = _NOT_ENTERED;
544     }
545 }
546 
547 // File: @openzeppelin/contracts/utils/Context.sol
548 
549 
550 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 /**
555  * @dev Provides information about the current execution context, including the
556  * sender of the transaction and its data. While these are generally available
557  * via msg.sender and msg.data, they should not be accessed in such a direct
558  * manner, since when dealing with meta-transactions the account sending and
559  * paying for execution may not be the actual sender (as far as an application
560  * is concerned).
561  *
562  * This contract is only required for intermediate, library-like contracts.
563  */
564 abstract contract Context {
565     function _msgSender() internal view virtual returns (address) {
566         return msg.sender;
567     }
568 
569     function _msgData() internal view virtual returns (bytes calldata) {
570         return msg.data;
571     }
572 }
573 
574 // File: @openzeppelin/contracts/access/Ownable.sol
575 
576 
577 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @dev Contract module which provides a basic access control mechanism, where
584  * there is an account (an owner) that can be granted exclusive access to
585  * specific functions.
586  *
587  * By default, the owner account will be the one that deploys the contract. This
588  * can later be changed with {transferOwnership}.
589  *
590  * This module is used through inheritance. It will make available the modifier
591  * `onlyOwner`, which can be applied to your functions to restrict their use to
592  * the owner.
593  */
594 abstract contract Ownable is Context {
595     address private _owner;
596 
597     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
598 
599     /**
600      * @dev Initializes the contract setting the deployer as the initial owner.
601      */
602     constructor() {
603         _transferOwnership(_msgSender());
604     }
605 
606     /**
607      * @dev Throws if called by any account other than the owner.
608      */
609     modifier onlyOwner() {
610         _checkOwner();
611         _;
612     }
613 
614     /**
615      * @dev Returns the address of the current owner.
616      */
617     function owner() public view virtual returns (address) {
618         return _owner;
619     }
620 
621     /**
622      * @dev Throws if the sender is not the owner.
623      */
624     function _checkOwner() internal view virtual {
625         require(owner() == _msgSender(), "Ownable: caller is not the owner");
626     }
627 
628     /**
629      * @dev Leaves the contract without owner. It will not be possible to call
630      * `onlyOwner` functions anymore. Can only be called by the current owner.
631      *
632      * NOTE: Renouncing ownership will leave the contract without an owner,
633      * thereby removing any functionality that is only available to the owner.
634      */
635     function renounceOwnership() public virtual onlyOwner {
636         _transferOwnership(address(0));
637     }
638 
639     /**
640      * @dev Transfers ownership of the contract to a new account (`newOwner`).
641      * Can only be called by the current owner.
642      */
643     function transferOwnership(address newOwner) public virtual onlyOwner {
644         require(newOwner != address(0), "Ownable: new owner is the zero address");
645         _transferOwnership(newOwner);
646     }
647 
648     /**
649      * @dev Transfers ownership of the contract to a new account (`newOwner`).
650      * Internal function without access restriction.
651      */
652     function _transferOwnership(address newOwner) internal virtual {
653         address oldOwner = _owner;
654         _owner = newOwner;
655         emit OwnershipTransferred(oldOwner, newOwner);
656     }
657 }
658 
659 // File: erc721a/contracts/IERC721A.sol
660 
661 
662 // ERC721A Contracts v4.2.3
663 // Creator: Chiru Labs
664 
665 pragma solidity ^0.8.4;
666 
667 /**
668  * @dev Interface of ERC721A.
669  */
670 interface IERC721A {
671     /**
672      * The caller must own the token or be an approved operator.
673      */
674     error ApprovalCallerNotOwnerNorApproved();
675 
676     /**
677      * The token does not exist.
678      */
679     error ApprovalQueryForNonexistentToken();
680 
681     /**
682      * Cannot query the balance for the zero address.
683      */
684     error BalanceQueryForZeroAddress();
685 
686     /**
687      * Cannot mint to the zero address.
688      */
689     error MintToZeroAddress();
690 
691     /**
692      * The quantity of tokens minted must be more than zero.
693      */
694     error MintZeroQuantity();
695 
696     /**
697      * The token does not exist.
698      */
699     error OwnerQueryForNonexistentToken();
700 
701     /**
702      * The caller must own the token or be an approved operator.
703      */
704     error TransferCallerNotOwnerNorApproved();
705 
706     /**
707      * The token must be owned by `from`.
708      */
709     error TransferFromIncorrectOwner();
710 
711     /**
712      * Cannot safely transfer to a contract that does not implement the
713      * ERC721Receiver interface.
714      */
715     error TransferToNonERC721ReceiverImplementer();
716 
717     /**
718      * Cannot transfer to the zero address.
719      */
720     error TransferToZeroAddress();
721 
722     /**
723      * The token does not exist.
724      */
725     error URIQueryForNonexistentToken();
726 
727     /**
728      * The `quantity` minted with ERC2309 exceeds the safety limit.
729      */
730     error MintERC2309QuantityExceedsLimit();
731 
732     /**
733      * The `extraData` cannot be set on an unintialized ownership slot.
734      */
735     error OwnershipNotInitializedForExtraData();
736 
737     // =============================================================
738     //                            STRUCTS
739     // =============================================================
740 
741     struct TokenOwnership {
742         // The address of the owner.
743         address addr;
744         // Stores the start time of ownership with minimal overhead for tokenomics.
745         uint64 startTimestamp;
746         // Whether the token has been burned.
747         bool burned;
748         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
749         uint24 extraData;
750     }
751 
752     // =============================================================
753     //                         TOKEN COUNTERS
754     // =============================================================
755 
756     /**
757      * @dev Returns the total number of tokens in existence.
758      * Burned tokens will reduce the count.
759      * To get the total number of tokens minted, please see {_totalMinted}.
760      */
761     function totalSupply() external view returns (uint256);
762 
763     // =============================================================
764     //                            IERC165
765     // =============================================================
766 
767     /**
768      * @dev Returns true if this contract implements the interface defined by
769      * `interfaceId`. See the corresponding
770      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
771      * to learn more about how these ids are created.
772      *
773      * This function call must use less than 30000 gas.
774      */
775     function supportsInterface(bytes4 interfaceId) external view returns (bool);
776 
777     // =============================================================
778     //                            IERC721
779     // =============================================================
780 
781     /**
782      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
783      */
784     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
785 
786     /**
787      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
788      */
789     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
790 
791     /**
792      * @dev Emitted when `owner` enables or disables
793      * (`approved`) `operator` to manage all of its assets.
794      */
795     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
796 
797     /**
798      * @dev Returns the number of tokens in `owner`'s account.
799      */
800     function balanceOf(address owner) external view returns (uint256 balance);
801 
802     /**
803      * @dev Returns the owner of the `tokenId` token.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function ownerOf(uint256 tokenId) external view returns (address owner);
810 
811     /**
812      * @dev Safely transfers `tokenId` token from `from` to `to`,
813      * checking first that contract recipients are aware of the ERC721 protocol
814      * to prevent tokens from being forever locked.
815      *
816      * Requirements:
817      *
818      * - `from` cannot be the zero address.
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must exist and be owned by `from`.
821      * - If the caller is not `from`, it must be have been allowed to move
822      * this token by either {approve} or {setApprovalForAll}.
823      * - If `to` refers to a smart contract, it must implement
824      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
825      *
826      * Emits a {Transfer} event.
827      */
828     function safeTransferFrom(
829         address from,
830         address to,
831         uint256 tokenId,
832         bytes calldata data
833     ) external payable;
834 
835     /**
836      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) external payable;
843 
844     /**
845      * @dev Transfers `tokenId` from `from` to `to`.
846      *
847      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
848      * whenever possible.
849      *
850      * Requirements:
851      *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must be owned by `from`.
855      * - If the caller is not `from`, it must be approved to move this token
856      * by either {approve} or {setApprovalForAll}.
857      *
858      * Emits a {Transfer} event.
859      */
860     function transferFrom(
861         address from,
862         address to,
863         uint256 tokenId
864     ) external payable;
865 
866     /**
867      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
868      * The approval is cleared when the token is transferred.
869      *
870      * Only a single account can be approved at a time, so approving the
871      * zero address clears previous approvals.
872      *
873      * Requirements:
874      *
875      * - The caller must own the token or be an approved operator.
876      * - `tokenId` must exist.
877      *
878      * Emits an {Approval} event.
879      */
880     function approve(address to, uint256 tokenId) external payable;
881 
882     /**
883      * @dev Approve or remove `operator` as an operator for the caller.
884      * Operators can call {transferFrom} or {safeTransferFrom}
885      * for any token owned by the caller.
886      *
887      * Requirements:
888      *
889      * - The `operator` cannot be the caller.
890      *
891      * Emits an {ApprovalForAll} event.
892      */
893     function setApprovalForAll(address operator, bool _approved) external;
894 
895     /**
896      * @dev Returns the account approved for `tokenId` token.
897      *
898      * Requirements:
899      *
900      * - `tokenId` must exist.
901      */
902     function getApproved(uint256 tokenId) external view returns (address operator);
903 
904     /**
905      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
906      *
907      * See {setApprovalForAll}.
908      */
909     function isApprovedForAll(address owner, address operator) external view returns (bool);
910 
911     // =============================================================
912     //                        IERC721Metadata
913     // =============================================================
914 
915     /**
916      * @dev Returns the token collection name.
917      */
918     function name() external view returns (string memory);
919 
920     /**
921      * @dev Returns the token collection symbol.
922      */
923     function symbol() external view returns (string memory);
924 
925     /**
926      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
927      */
928     function tokenURI(uint256 tokenId) external view returns (string memory);
929 
930     // =============================================================
931     //                           IERC2309
932     // =============================================================
933 
934     /**
935      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
936      * (inclusive) is transferred from `from` to `to`, as defined in the
937      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
938      *
939      * See {_mintERC2309} for more details.
940      */
941     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
942 }
943 
944 // File: erc721a/contracts/ERC721A.sol
945 
946 
947 // ERC721A Contracts v4.2.3
948 // Creator: Chiru Labs
949 
950 pragma solidity ^0.8.4;
951 
952 
953 /**
954  * @dev Interface of ERC721 token receiver.
955  */
956 interface ERC721A__IERC721Receiver {
957     function onERC721Received(
958         address operator,
959         address from,
960         uint256 tokenId,
961         bytes calldata data
962     ) external returns (bytes4);
963 }
964 
965 /**
966  * @title ERC721A
967  *
968  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
969  * Non-Fungible Token Standard, including the Metadata extension.
970  * Optimized for lower gas during batch mints.
971  *
972  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
973  * starting from `_startTokenId()`.
974  *
975  * Assumptions:
976  *
977  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
978  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
979  */
980 contract ERC721A is IERC721A {
981     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
982     struct TokenApprovalRef {
983         address value;
984     }
985 
986     // =============================================================
987     //                           CONSTANTS
988     // =============================================================
989 
990     // Mask of an entry in packed address data.
991     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
992 
993     // The bit position of `numberMinted` in packed address data.
994     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
995 
996     // The bit position of `numberBurned` in packed address data.
997     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
998 
999     // The bit position of `aux` in packed address data.
1000     uint256 private constant _BITPOS_AUX = 192;
1001 
1002     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1003     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1004 
1005     // The bit position of `startTimestamp` in packed ownership.
1006     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1007 
1008     // The bit mask of the `burned` bit in packed ownership.
1009     uint256 private constant _BITMASK_BURNED = 1 << 224;
1010 
1011     // The bit position of the `nextInitialized` bit in packed ownership.
1012     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1013 
1014     // The bit mask of the `nextInitialized` bit in packed ownership.
1015     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1016 
1017     // The bit position of `extraData` in packed ownership.
1018     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1019 
1020     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1021     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1022 
1023     // The mask of the lower 160 bits for addresses.
1024     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1025 
1026     // The maximum `quantity` that can be minted with {_mintERC2309}.
1027     // This limit is to prevent overflows on the address data entries.
1028     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1029     // is required to cause an overflow, which is unrealistic.
1030     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1031 
1032     // The `Transfer` event signature is given by:
1033     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1034     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1035         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1036 
1037     // =============================================================
1038     //                            STORAGE
1039     // =============================================================
1040 
1041     // The next token ID to be minted.
1042     uint256 private _currentIndex;
1043 
1044     // The number of tokens burned.
1045     uint256 private _burnCounter;
1046 
1047     // Token name
1048     string private _name;
1049 
1050     // Token symbol
1051     string private _symbol;
1052 
1053     // Mapping from token ID to ownership details
1054     // An empty struct value does not necessarily mean the token is unowned.
1055     // See {_packedOwnershipOf} implementation for details.
1056     //
1057     // Bits Layout:
1058     // - [0..159]   `addr`
1059     // - [160..223] `startTimestamp`
1060     // - [224]      `burned`
1061     // - [225]      `nextInitialized`
1062     // - [232..255] `extraData`
1063     mapping(uint256 => uint256) private _packedOwnerships;
1064 
1065     // Mapping owner address to address data.
1066     //
1067     // Bits Layout:
1068     // - [0..63]    `balance`
1069     // - [64..127]  `numberMinted`
1070     // - [128..191] `numberBurned`
1071     // - [192..255] `aux`
1072     mapping(address => uint256) private _packedAddressData;
1073 
1074     // Mapping from token ID to approved address.
1075     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1076 
1077     // Mapping from owner to operator approvals
1078     mapping(address => mapping(address => bool)) private _operatorApprovals;
1079 
1080     // =============================================================
1081     //                          CONSTRUCTOR
1082     // =============================================================
1083 
1084     constructor(string memory name_, string memory symbol_) {
1085         _name = name_;
1086         _symbol = symbol_;
1087         _currentIndex = _startTokenId();
1088     }
1089 
1090     // =============================================================
1091     //                   TOKEN COUNTING OPERATIONS
1092     // =============================================================
1093 
1094     /**
1095      * @dev Returns the starting token ID.
1096      * To change the starting token ID, please override this function.
1097      */
1098     function _startTokenId() internal view virtual returns (uint256) {
1099         return 0;
1100     }
1101 
1102     /**
1103      * @dev Returns the next token ID to be minted.
1104      */
1105     function _nextTokenId() internal view virtual returns (uint256) {
1106         return _currentIndex;
1107     }
1108 
1109     /**
1110      * @dev Returns the total number of tokens in existence.
1111      * Burned tokens will reduce the count.
1112      * To get the total number of tokens minted, please see {_totalMinted}.
1113      */
1114     function totalSupply() public view virtual override returns (uint256) {
1115         // Counter underflow is impossible as _burnCounter cannot be incremented
1116         // more than `_currentIndex - _startTokenId()` times.
1117         unchecked {
1118             return _currentIndex - _burnCounter - _startTokenId();
1119         }
1120     }
1121 
1122     /**
1123      * @dev Returns the total amount of tokens minted in the contract.
1124      */
1125     function _totalMinted() internal view virtual returns (uint256) {
1126         // Counter underflow is impossible as `_currentIndex` does not decrement,
1127         // and it is initialized to `_startTokenId()`.
1128         unchecked {
1129             return _currentIndex - _startTokenId();
1130         }
1131     }
1132 
1133     /**
1134      * @dev Returns the total number of tokens burned.
1135      */
1136     function _totalBurned() internal view virtual returns (uint256) {
1137         return _burnCounter;
1138     }
1139 
1140     // =============================================================
1141     //                    ADDRESS DATA OPERATIONS
1142     // =============================================================
1143 
1144     /**
1145      * @dev Returns the number of tokens in `owner`'s account.
1146      */
1147     function balanceOf(address owner) public view virtual override returns (uint256) {
1148         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1149         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1150     }
1151 
1152     /**
1153      * Returns the number of tokens minted by `owner`.
1154      */
1155     function _numberMinted(address owner) internal view returns (uint256) {
1156         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1157     }
1158 
1159     /**
1160      * Returns the number of tokens burned by or on behalf of `owner`.
1161      */
1162     function _numberBurned(address owner) internal view returns (uint256) {
1163         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1164     }
1165 
1166     /**
1167      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1168      */
1169     function _getAux(address owner) internal view returns (uint64) {
1170         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1171     }
1172 
1173     /**
1174      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1175      * If there are multiple variables, please pack them into a uint64.
1176      */
1177     function _setAux(address owner, uint64 aux) internal virtual {
1178         uint256 packed = _packedAddressData[owner];
1179         uint256 auxCasted;
1180         // Cast `aux` with assembly to avoid redundant masking.
1181         assembly {
1182             auxCasted := aux
1183         }
1184         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1185         _packedAddressData[owner] = packed;
1186     }
1187 
1188     // =============================================================
1189     //                            IERC165
1190     // =============================================================
1191 
1192     /**
1193      * @dev Returns true if this contract implements the interface defined by
1194      * `interfaceId`. See the corresponding
1195      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1196      * to learn more about how these ids are created.
1197      *
1198      * This function call must use less than 30000 gas.
1199      */
1200     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1201         // The interface IDs are constants representing the first 4 bytes
1202         // of the XOR of all function selectors in the interface.
1203         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1204         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1205         return
1206             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1207             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1208             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1209     }
1210 
1211     // =============================================================
1212     //                        IERC721Metadata
1213     // =============================================================
1214 
1215     /**
1216      * @dev Returns the token collection name.
1217      */
1218     function name() public view virtual override returns (string memory) {
1219         return _name;
1220     }
1221 
1222     /**
1223      * @dev Returns the token collection symbol.
1224      */
1225     function symbol() public view virtual override returns (string memory) {
1226         return _symbol;
1227     }
1228 
1229     /**
1230      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1231      */
1232     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1233         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1234 
1235         string memory baseURI = _baseURI();
1236         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1237     }
1238 
1239     /**
1240      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1241      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1242      * by default, it can be overridden in child contracts.
1243      */
1244     function _baseURI() internal view virtual returns (string memory) {
1245         return '';
1246     }
1247 
1248     // =============================================================
1249     //                     OWNERSHIPS OPERATIONS
1250     // =============================================================
1251 
1252     /**
1253      * @dev Returns the owner of the `tokenId` token.
1254      *
1255      * Requirements:
1256      *
1257      * - `tokenId` must exist.
1258      */
1259     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1260         return address(uint160(_packedOwnershipOf(tokenId)));
1261     }
1262 
1263     /**
1264      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1265      * It gradually moves to O(1) as tokens get transferred around over time.
1266      */
1267     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1268         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1269     }
1270 
1271     /**
1272      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1273      */
1274     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1275         return _unpackedOwnership(_packedOwnerships[index]);
1276     }
1277 
1278     /**
1279      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1280      */
1281     function _initializeOwnershipAt(uint256 index) internal virtual {
1282         if (_packedOwnerships[index] == 0) {
1283             _packedOwnerships[index] = _packedOwnershipOf(index);
1284         }
1285     }
1286 
1287     /**
1288      * Returns the packed ownership data of `tokenId`.
1289      */
1290     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1291         uint256 curr = tokenId;
1292 
1293         unchecked {
1294             if (_startTokenId() <= curr)
1295                 if (curr < _currentIndex) {
1296                     uint256 packed = _packedOwnerships[curr];
1297                     // If not burned.
1298                     if (packed & _BITMASK_BURNED == 0) {
1299                         // Invariant:
1300                         // There will always be an initialized ownership slot
1301                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1302                         // before an unintialized ownership slot
1303                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1304                         // Hence, `curr` will not underflow.
1305                         //
1306                         // We can directly compare the packed value.
1307                         // If the address is zero, packed will be zero.
1308                         while (packed == 0) {
1309                             packed = _packedOwnerships[--curr];
1310                         }
1311                         return packed;
1312                     }
1313                 }
1314         }
1315         revert OwnerQueryForNonexistentToken();
1316     }
1317 
1318     /**
1319      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1320      */
1321     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1322         ownership.addr = address(uint160(packed));
1323         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1324         ownership.burned = packed & _BITMASK_BURNED != 0;
1325         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1326     }
1327 
1328     /**
1329      * @dev Packs ownership data into a single uint256.
1330      */
1331     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1332         assembly {
1333             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1334             owner := and(owner, _BITMASK_ADDRESS)
1335             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1336             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1337         }
1338     }
1339 
1340     /**
1341      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1342      */
1343     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1344         // For branchless setting of the `nextInitialized` flag.
1345         assembly {
1346             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1347             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1348         }
1349     }
1350 
1351     // =============================================================
1352     //                      APPROVAL OPERATIONS
1353     // =============================================================
1354 
1355     /**
1356      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1357      * The approval is cleared when the token is transferred.
1358      *
1359      * Only a single account can be approved at a time, so approving the
1360      * zero address clears previous approvals.
1361      *
1362      * Requirements:
1363      *
1364      * - The caller must own the token or be an approved operator.
1365      * - `tokenId` must exist.
1366      *
1367      * Emits an {Approval} event.
1368      */
1369     function approve(address to, uint256 tokenId) public payable virtual override {
1370         address owner = ownerOf(tokenId);
1371 
1372         if (_msgSenderERC721A() != owner)
1373             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1374                 revert ApprovalCallerNotOwnerNorApproved();
1375             }
1376 
1377         _tokenApprovals[tokenId].value = to;
1378         emit Approval(owner, to, tokenId);
1379     }
1380 
1381     /**
1382      * @dev Returns the account approved for `tokenId` token.
1383      *
1384      * Requirements:
1385      *
1386      * - `tokenId` must exist.
1387      */
1388     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1389         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1390 
1391         return _tokenApprovals[tokenId].value;
1392     }
1393 
1394     /**
1395      * @dev Approve or remove `operator` as an operator for the caller.
1396      * Operators can call {transferFrom} or {safeTransferFrom}
1397      * for any token owned by the caller.
1398      *
1399      * Requirements:
1400      *
1401      * - The `operator` cannot be the caller.
1402      *
1403      * Emits an {ApprovalForAll} event.
1404      */
1405     function setApprovalForAll(address operator, bool approved) public virtual override {
1406         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1407         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1408     }
1409 
1410     /**
1411      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1412      *
1413      * See {setApprovalForAll}.
1414      */
1415     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1416         return _operatorApprovals[owner][operator];
1417     }
1418 
1419     /**
1420      * @dev Returns whether `tokenId` exists.
1421      *
1422      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1423      *
1424      * Tokens start existing when they are minted. See {_mint}.
1425      */
1426     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1427         return
1428             _startTokenId() <= tokenId &&
1429             tokenId < _currentIndex && // If within bounds,
1430             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1431     }
1432 
1433     /**
1434      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1435      */
1436     function _isSenderApprovedOrOwner(
1437         address approvedAddress,
1438         address owner,
1439         address msgSender
1440     ) private pure returns (bool result) {
1441         assembly {
1442             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1443             owner := and(owner, _BITMASK_ADDRESS)
1444             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1445             msgSender := and(msgSender, _BITMASK_ADDRESS)
1446             // `msgSender == owner || msgSender == approvedAddress`.
1447             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1448         }
1449     }
1450 
1451     /**
1452      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1453      */
1454     function _getApprovedSlotAndAddress(uint256 tokenId)
1455         private
1456         view
1457         returns (uint256 approvedAddressSlot, address approvedAddress)
1458     {
1459         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1460         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1461         assembly {
1462             approvedAddressSlot := tokenApproval.slot
1463             approvedAddress := sload(approvedAddressSlot)
1464         }
1465     }
1466 
1467     // =============================================================
1468     //                      TRANSFER OPERATIONS
1469     // =============================================================
1470 
1471     /**
1472      * @dev Transfers `tokenId` from `from` to `to`.
1473      *
1474      * Requirements:
1475      *
1476      * - `from` cannot be the zero address.
1477      * - `to` cannot be the zero address.
1478      * - `tokenId` token must be owned by `from`.
1479      * - If the caller is not `from`, it must be approved to move this token
1480      * by either {approve} or {setApprovalForAll}.
1481      *
1482      * Emits a {Transfer} event.
1483      */
1484     function transferFrom(
1485         address from,
1486         address to,
1487         uint256 tokenId
1488     ) public payable virtual override {
1489         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1490 
1491         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1492 
1493         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1494 
1495         // The nested ifs save around 20+ gas over a compound boolean condition.
1496         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1497             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1498 
1499         if (to == address(0)) revert TransferToZeroAddress();
1500 
1501         _beforeTokenTransfers(from, to, tokenId, 1);
1502 
1503         // Clear approvals from the previous owner.
1504         assembly {
1505             if approvedAddress {
1506                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1507                 sstore(approvedAddressSlot, 0)
1508             }
1509         }
1510 
1511         // Underflow of the sender's balance is impossible because we check for
1512         // ownership above and the recipient's balance can't realistically overflow.
1513         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1514         unchecked {
1515             // We can directly increment and decrement the balances.
1516             --_packedAddressData[from]; // Updates: `balance -= 1`.
1517             ++_packedAddressData[to]; // Updates: `balance += 1`.
1518 
1519             // Updates:
1520             // - `address` to the next owner.
1521             // - `startTimestamp` to the timestamp of transfering.
1522             // - `burned` to `false`.
1523             // - `nextInitialized` to `true`.
1524             _packedOwnerships[tokenId] = _packOwnershipData(
1525                 to,
1526                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1527             );
1528 
1529             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1530             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1531                 uint256 nextTokenId = tokenId + 1;
1532                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1533                 if (_packedOwnerships[nextTokenId] == 0) {
1534                     // If the next slot is within bounds.
1535                     if (nextTokenId != _currentIndex) {
1536                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1537                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1538                     }
1539                 }
1540             }
1541         }
1542 
1543         emit Transfer(from, to, tokenId);
1544         _afterTokenTransfers(from, to, tokenId, 1);
1545     }
1546 
1547     /**
1548      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1549      */
1550     function safeTransferFrom(
1551         address from,
1552         address to,
1553         uint256 tokenId
1554     ) public payable virtual override {
1555         safeTransferFrom(from, to, tokenId, '');
1556     }
1557 
1558     /**
1559      * @dev Safely transfers `tokenId` token from `from` to `to`.
1560      *
1561      * Requirements:
1562      *
1563      * - `from` cannot be the zero address.
1564      * - `to` cannot be the zero address.
1565      * - `tokenId` token must exist and be owned by `from`.
1566      * - If the caller is not `from`, it must be approved to move this token
1567      * by either {approve} or {setApprovalForAll}.
1568      * - If `to` refers to a smart contract, it must implement
1569      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1570      *
1571      * Emits a {Transfer} event.
1572      */
1573     function safeTransferFrom(
1574         address from,
1575         address to,
1576         uint256 tokenId,
1577         bytes memory _data
1578     ) public payable virtual override {
1579         transferFrom(from, to, tokenId);
1580         if (to.code.length != 0)
1581             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1582                 revert TransferToNonERC721ReceiverImplementer();
1583             }
1584     }
1585 
1586     /**
1587      * @dev Hook that is called before a set of serially-ordered token IDs
1588      * are about to be transferred. This includes minting.
1589      * And also called before burning one token.
1590      *
1591      * `startTokenId` - the first token ID to be transferred.
1592      * `quantity` - the amount to be transferred.
1593      *
1594      * Calling conditions:
1595      *
1596      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1597      * transferred to `to`.
1598      * - When `from` is zero, `tokenId` will be minted for `to`.
1599      * - When `to` is zero, `tokenId` will be burned by `from`.
1600      * - `from` and `to` are never both zero.
1601      */
1602     function _beforeTokenTransfers(
1603         address from,
1604         address to,
1605         uint256 startTokenId,
1606         uint256 quantity
1607     ) internal virtual {}
1608 
1609     /**
1610      * @dev Hook that is called after a set of serially-ordered token IDs
1611      * have been transferred. This includes minting.
1612      * And also called after one token has been burned.
1613      *
1614      * `startTokenId` - the first token ID to be transferred.
1615      * `quantity` - the amount to be transferred.
1616      *
1617      * Calling conditions:
1618      *
1619      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1620      * transferred to `to`.
1621      * - When `from` is zero, `tokenId` has been minted for `to`.
1622      * - When `to` is zero, `tokenId` has been burned by `from`.
1623      * - `from` and `to` are never both zero.
1624      */
1625     function _afterTokenTransfers(
1626         address from,
1627         address to,
1628         uint256 startTokenId,
1629         uint256 quantity
1630     ) internal virtual {}
1631 
1632     /**
1633      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1634      *
1635      * `from` - Previous owner of the given token ID.
1636      * `to` - Target address that will receive the token.
1637      * `tokenId` - Token ID to be transferred.
1638      * `_data` - Optional data to send along with the call.
1639      *
1640      * Returns whether the call correctly returned the expected magic value.
1641      */
1642     function _checkContractOnERC721Received(
1643         address from,
1644         address to,
1645         uint256 tokenId,
1646         bytes memory _data
1647     ) private returns (bool) {
1648         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1649             bytes4 retval
1650         ) {
1651             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1652         } catch (bytes memory reason) {
1653             if (reason.length == 0) {
1654                 revert TransferToNonERC721ReceiverImplementer();
1655             } else {
1656                 assembly {
1657                     revert(add(32, reason), mload(reason))
1658                 }
1659             }
1660         }
1661     }
1662 
1663     // =============================================================
1664     //                        MINT OPERATIONS
1665     // =============================================================
1666 
1667     /**
1668      * @dev Mints `quantity` tokens and transfers them to `to`.
1669      *
1670      * Requirements:
1671      *
1672      * - `to` cannot be the zero address.
1673      * - `quantity` must be greater than 0.
1674      *
1675      * Emits a {Transfer} event for each mint.
1676      */
1677     function _mint(address to, uint256 quantity) internal virtual {
1678         uint256 startTokenId = _currentIndex;
1679         if (quantity == 0) revert MintZeroQuantity();
1680 
1681         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1682 
1683         // Overflows are incredibly unrealistic.
1684         // `balance` and `numberMinted` have a maximum limit of 2**64.
1685         // `tokenId` has a maximum limit of 2**256.
1686         unchecked {
1687             // Updates:
1688             // - `balance += quantity`.
1689             // - `numberMinted += quantity`.
1690             //
1691             // We can directly add to the `balance` and `numberMinted`.
1692             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1693 
1694             // Updates:
1695             // - `address` to the owner.
1696             // - `startTimestamp` to the timestamp of minting.
1697             // - `burned` to `false`.
1698             // - `nextInitialized` to `quantity == 1`.
1699             _packedOwnerships[startTokenId] = _packOwnershipData(
1700                 to,
1701                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1702             );
1703 
1704             uint256 toMasked;
1705             uint256 end = startTokenId + quantity;
1706 
1707             // Use assembly to loop and emit the `Transfer` event for gas savings.
1708             // The duplicated `log4` removes an extra check and reduces stack juggling.
1709             // The assembly, together with the surrounding Solidity code, have been
1710             // delicately arranged to nudge the compiler into producing optimized opcodes.
1711             assembly {
1712                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1713                 toMasked := and(to, _BITMASK_ADDRESS)
1714                 // Emit the `Transfer` event.
1715                 log4(
1716                     0, // Start of data (0, since no data).
1717                     0, // End of data (0, since no data).
1718                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1719                     0, // `address(0)`.
1720                     toMasked, // `to`.
1721                     startTokenId // `tokenId`.
1722                 )
1723 
1724                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1725                 // that overflows uint256 will make the loop run out of gas.
1726                 // The compiler will optimize the `iszero` away for performance.
1727                 for {
1728                     let tokenId := add(startTokenId, 1)
1729                 } iszero(eq(tokenId, end)) {
1730                     tokenId := add(tokenId, 1)
1731                 } {
1732                     // Emit the `Transfer` event. Similar to above.
1733                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1734                 }
1735             }
1736             if (toMasked == 0) revert MintToZeroAddress();
1737 
1738             _currentIndex = end;
1739         }
1740         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1741     }
1742 
1743     /**
1744      * @dev Mints `quantity` tokens and transfers them to `to`.
1745      *
1746      * This function is intended for efficient minting only during contract creation.
1747      *
1748      * It emits only one {ConsecutiveTransfer} as defined in
1749      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1750      * instead of a sequence of {Transfer} event(s).
1751      *
1752      * Calling this function outside of contract creation WILL make your contract
1753      * non-compliant with the ERC721 standard.
1754      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1755      * {ConsecutiveTransfer} event is only permissible during contract creation.
1756      *
1757      * Requirements:
1758      *
1759      * - `to` cannot be the zero address.
1760      * - `quantity` must be greater than 0.
1761      *
1762      * Emits a {ConsecutiveTransfer} event.
1763      */
1764     function _mintERC2309(address to, uint256 quantity) internal virtual {
1765         uint256 startTokenId = _currentIndex;
1766         if (to == address(0)) revert MintToZeroAddress();
1767         if (quantity == 0) revert MintZeroQuantity();
1768         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1769 
1770         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1771 
1772         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1773         unchecked {
1774             // Updates:
1775             // - `balance += quantity`.
1776             // - `numberMinted += quantity`.
1777             //
1778             // We can directly add to the `balance` and `numberMinted`.
1779             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1780 
1781             // Updates:
1782             // - `address` to the owner.
1783             // - `startTimestamp` to the timestamp of minting.
1784             // - `burned` to `false`.
1785             // - `nextInitialized` to `quantity == 1`.
1786             _packedOwnerships[startTokenId] = _packOwnershipData(
1787                 to,
1788                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1789             );
1790 
1791             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1792 
1793             _currentIndex = startTokenId + quantity;
1794         }
1795         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1796     }
1797 
1798     /**
1799      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1800      *
1801      * Requirements:
1802      *
1803      * - If `to` refers to a smart contract, it must implement
1804      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1805      * - `quantity` must be greater than 0.
1806      *
1807      * See {_mint}.
1808      *
1809      * Emits a {Transfer} event for each mint.
1810      */
1811     function _safeMint(
1812         address to,
1813         uint256 quantity,
1814         bytes memory _data
1815     ) internal virtual {
1816         _mint(to, quantity);
1817 
1818         unchecked {
1819             if (to.code.length != 0) {
1820                 uint256 end = _currentIndex;
1821                 uint256 index = end - quantity;
1822                 do {
1823                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1824                         revert TransferToNonERC721ReceiverImplementer();
1825                     }
1826                 } while (index < end);
1827                 // Reentrancy protection.
1828                 if (_currentIndex != end) revert();
1829             }
1830         }
1831     }
1832 
1833     /**
1834      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1835      */
1836     function _safeMint(address to, uint256 quantity) internal virtual {
1837         _safeMint(to, quantity, '');
1838     }
1839 
1840     // =============================================================
1841     //                        BURN OPERATIONS
1842     // =============================================================
1843 
1844     /**
1845      * @dev Equivalent to `_burn(tokenId, false)`.
1846      */
1847     function _burn(uint256 tokenId) internal virtual {
1848         _burn(tokenId, false);
1849     }
1850 
1851     /**
1852      * @dev Destroys `tokenId`.
1853      * The approval is cleared when the token is burned.
1854      *
1855      * Requirements:
1856      *
1857      * - `tokenId` must exist.
1858      *
1859      * Emits a {Transfer} event.
1860      */
1861     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1862         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1863 
1864         address from = address(uint160(prevOwnershipPacked));
1865 
1866         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1867 
1868         if (approvalCheck) {
1869             // The nested ifs save around 20+ gas over a compound boolean condition.
1870             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1871                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1872         }
1873 
1874         _beforeTokenTransfers(from, address(0), tokenId, 1);
1875 
1876         // Clear approvals from the previous owner.
1877         assembly {
1878             if approvedAddress {
1879                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1880                 sstore(approvedAddressSlot, 0)
1881             }
1882         }
1883 
1884         // Underflow of the sender's balance is impossible because we check for
1885         // ownership above and the recipient's balance can't realistically overflow.
1886         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1887         unchecked {
1888             // Updates:
1889             // - `balance -= 1`.
1890             // - `numberBurned += 1`.
1891             //
1892             // We can directly decrement the balance, and increment the number burned.
1893             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1894             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1895 
1896             // Updates:
1897             // - `address` to the last owner.
1898             // - `startTimestamp` to the timestamp of burning.
1899             // - `burned` to `true`.
1900             // - `nextInitialized` to `true`.
1901             _packedOwnerships[tokenId] = _packOwnershipData(
1902                 from,
1903                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1904             );
1905 
1906             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1907             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1908                 uint256 nextTokenId = tokenId + 1;
1909                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1910                 if (_packedOwnerships[nextTokenId] == 0) {
1911                     // If the next slot is within bounds.
1912                     if (nextTokenId != _currentIndex) {
1913                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1914                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1915                     }
1916                 }
1917             }
1918         }
1919 
1920         emit Transfer(from, address(0), tokenId);
1921         _afterTokenTransfers(from, address(0), tokenId, 1);
1922 
1923         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1924         unchecked {
1925             _burnCounter++;
1926         }
1927     }
1928 
1929     // =============================================================
1930     //                     EXTRA DATA OPERATIONS
1931     // =============================================================
1932 
1933     /**
1934      * @dev Directly sets the extra data for the ownership data `index`.
1935      */
1936     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1937         uint256 packed = _packedOwnerships[index];
1938         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1939         uint256 extraDataCasted;
1940         // Cast `extraData` with assembly to avoid redundant masking.
1941         assembly {
1942             extraDataCasted := extraData
1943         }
1944         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1945         _packedOwnerships[index] = packed;
1946     }
1947 
1948     /**
1949      * @dev Called during each token transfer to set the 24bit `extraData` field.
1950      * Intended to be overridden by the cosumer contract.
1951      *
1952      * `previousExtraData` - the value of `extraData` before transfer.
1953      *
1954      * Calling conditions:
1955      *
1956      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1957      * transferred to `to`.
1958      * - When `from` is zero, `tokenId` will be minted for `to`.
1959      * - When `to` is zero, `tokenId` will be burned by `from`.
1960      * - `from` and `to` are never both zero.
1961      */
1962     function _extraData(
1963         address from,
1964         address to,
1965         uint24 previousExtraData
1966     ) internal view virtual returns (uint24) {}
1967 
1968     /**
1969      * @dev Returns the next extra data for the packed ownership data.
1970      * The returned result is shifted into position.
1971      */
1972     function _nextExtraData(
1973         address from,
1974         address to,
1975         uint256 prevOwnershipPacked
1976     ) private view returns (uint256) {
1977         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1978         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1979     }
1980 
1981     // =============================================================
1982     //                       OTHER OPERATIONS
1983     // =============================================================
1984 
1985     /**
1986      * @dev Returns the message sender (defaults to `msg.sender`).
1987      *
1988      * If you are writing GSN compatible contracts, you need to override this function.
1989      */
1990     function _msgSenderERC721A() internal view virtual returns (address) {
1991         return msg.sender;
1992     }
1993 
1994     /**
1995      * @dev Converts a uint256 to its ASCII string decimal representation.
1996      */
1997     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1998         assembly {
1999             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2000             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2001             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2002             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2003             let m := add(mload(0x40), 0xa0)
2004             // Update the free memory pointer to allocate.
2005             mstore(0x40, m)
2006             // Assign the `str` to the end.
2007             str := sub(m, 0x20)
2008             // Zeroize the slot after the string.
2009             mstore(str, 0)
2010 
2011             // Cache the end of the memory to calculate the length later.
2012             let end := str
2013 
2014             // We write the string from rightmost digit to leftmost digit.
2015             // The following is essentially a do-while loop that also handles the zero case.
2016             // prettier-ignore
2017             for { let temp := value } 1 {} {
2018                 str := sub(str, 1)
2019                 // Write the character to the pointer.
2020                 // The ASCII index of the '0' character is 48.
2021                 mstore8(str, add(48, mod(temp, 10)))
2022                 // Keep dividing `temp` until zero.
2023                 temp := div(temp, 10)
2024                 // prettier-ignore
2025                 if iszero(temp) { break }
2026             }
2027 
2028             let length := sub(end, str)
2029             // Move the pointer 32 bytes leftwards to make room for the length.
2030             str := sub(str, 0x20)
2031             // Store the length.
2032             mstore(str, length)
2033         }
2034     }
2035 }
2036 
2037 // File: contracts/xoregenesis.sol
2038 
2039 
2040 
2041 
2042 // 1337  ___   ______     _______    _______         ______    ____  ____       __      _____  ___  ___________  ____  ____  ___      ___ 
2043 // |"  \/"  | /    " \   /"      \  /"     "|       /    " \  ("  _||_ " |     /""\    (\"   \|"  \("     _   ")("  _||_ " ||"  \    /"  |
2044 //  \   \  / // ____  \ |:        |(: ______)      // ____  \ |   (  ) : |    /    \   |.\\   \    |)__/  \\__/ |   (  ) : | \   \  //   |
2045 //   \\  \/ /  /    ) :)|_____/   ) \/    |       /  /    )  )(:  |  | . )   /' /\  \  |: \.   \\  |   \\_ /    (:  |  | . ) /\\  \/.    |
2046 //   /\.  \(: (____/ //  //      /  // ___)_     (: (____/ //  \\ \__/ //   //  __'  \ |.  \    \. |   |.  |     \\ \__/ // |: \.        |
2047 //  /  \   \\        /  |:  __   \ (:      "|     \         \  /\\ __ //\  /   /  \\  \|    \    \ |   \:  |     /\\ __ //\ |.  \    /:  |
2048 // |___/\___|\"_____/   |__|  \___) \_______)      \"____/\__\(__________)(___/    \___)\___|\____\)    \__|    (__________)|___|\__/|___|
2049                                                                                                                                        
2050 
2051 
2052 
2053 pragma solidity ^0.8.13;
2054 
2055 
2056 
2057 
2058 
2059 
2060 contract XoreQuantum is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2061 
2062 
2063   string public baseURI;
2064   string public notRevealedUri;
2065   uint256 public cost = 0.088 ether;
2066   uint256 public wlcost = 0.088 ether;
2067   uint256 public maxSupply = 1337;
2068   uint256 public WlSupply = 777;
2069   uint256 public MaxperWallet = 2; // max per wallet for public
2070   uint256 public MaxperWalletWl = 2; // max per wallet for whitelist
2071   uint256 public MaxperTx = 1;  // max per transaction for public
2072   uint256 public MaxperTxWl = 1; // max per transaction for whitelist
2073   bool public paused = true;
2074   bool public revealed = false;
2075   bool public preSale = false;
2076   bool public publicSale = false;
2077   bytes32 public merkleRoot;
2078   mapping (address => uint256) public PublicMinted;
2079   mapping (address => uint256) public WhitelistMinted;
2080   address public p1 = 0xdef889a07c5608f2EEaAbb13BB6dA45cF21EF2a5;
2081 
2082   constructor(
2083     string memory _initBaseURI,
2084     string memory _notRevealedUri
2085   ) ERC721A("XORE-Quantum", "XQT") {
2086     setBaseURI(_initBaseURI);
2087     setNotRevealedURI(_notRevealedUri);
2088   }
2089 
2090   // internal
2091   function _baseURI() internal view virtual override returns (string memory) {
2092     return baseURI;
2093   }
2094       function _startTokenId() internal view virtual override returns (uint256) {
2095         return 1;
2096     }
2097 
2098 
2099 
2100   /// @dev Public mint 
2101   function mint(uint256 tokens) public payable nonReentrant {
2102     require(!paused, "oops contract is paused");
2103     require(publicSale, "Sale hasn't started yet");
2104     require(tokens <= MaxperTx, "max mint amount per tx exceeded");
2105     require(totalSupply() + tokens <= maxSupply, "We Soldout");
2106     require(PublicMinted[_msgSenderERC721A()] + tokens <= MaxperWallet, "Max NFT Per Wallet exceeded");
2107     require(msg.value >= cost * tokens, "insufficient funds");
2108 
2109       PublicMinted[_msgSenderERC721A()] += tokens;
2110       _safeMint(_msgSenderERC721A(), tokens);
2111     
2112   }
2113 /// @dev presale mint for whitelisted
2114     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public payable nonReentrant {
2115     require(!paused, "oops contract is paused");
2116     require(preSale, "Presale hasn't started yet");
2117     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You are not Whitelisted");
2118     require(WhitelistMinted[_msgSenderERC721A()] + tokens <= MaxperWalletWl, "Max NFT Per Wallet exceeded");
2119     require(tokens <= MaxperTxWl, "max mint per Tx exceeded");
2120     require(totalSupply() + tokens <= WlSupply, "Whitelist MaxSupply exceeded");
2121     require(msg.value >= wlcost * tokens, "insufficient funds");
2122 
2123         WhitelistMinted[_msgSenderERC721A()] += tokens;
2124       _safeMint(_msgSenderERC721A(), tokens);
2125   }
2126 
2127   /// @dev use it for giveaway and team mint
2128      function airdrop(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
2129     require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
2130 
2131       _safeMint(destination, _mintAmount);
2132   }
2133 
2134 /// @notice returns metadata link of tokenid
2135   function tokenURI(uint256 tokenId)
2136     public
2137     view
2138     virtual
2139     override
2140     returns (string memory)
2141   {
2142     require(
2143       _exists(tokenId),
2144       "ERC721AMetadata: URI query for nonexistent token"
2145     );
2146     
2147     if(revealed == false) {
2148         return notRevealedUri;
2149     }
2150 
2151     string memory currentBaseURI = _baseURI();
2152     return bytes(currentBaseURI).length > 0
2153         ? string(abi.encodePacked(currentBaseURI, _toString(tokenId), ".json"))
2154         : "";
2155   }
2156 
2157      /// @notice return the number minted by an address
2158     function numberMinted(address owner) public view returns (uint256) {
2159     return _numberMinted(owner);
2160   }
2161 
2162     /// @notice return the tokens owned by an address
2163       function tokensOfOwner(address owner) public view returns (uint256[] memory) {
2164         unchecked {
2165             uint256 tokenIdsIdx;
2166             address currOwnershipAddr;
2167             uint256 tokenIdsLength = balanceOf(owner);
2168             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2169             TokenOwnership memory ownership;
2170             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2171                 ownership = _ownershipAt(i);
2172                 if (ownership.burned) {
2173                     continue;
2174                 }
2175                 if (ownership.addr != address(0)) {
2176                     currOwnershipAddr = ownership.addr;
2177                 }
2178                 if (currOwnershipAddr == owner) {
2179                     tokenIds[tokenIdsIdx++] = i;
2180                 }
2181             }
2182             return tokenIds;
2183         }
2184     }
2185 
2186   //only owner
2187   function reveal(bool _state) public onlyOwner {
2188       revealed = _state;
2189   }
2190 
2191     /// @dev change the merkle root for the whitelist phase
2192   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2193         merkleRoot = _merkleRoot;
2194     }
2195 
2196   /// @dev change the public max per wallet
2197   function setMaxPerWallet(uint256 _limit) public onlyOwner {
2198     MaxperWallet = _limit;
2199   }
2200 
2201   /// @dev change the whitelist max per wallet
2202     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
2203     MaxperWalletWl = _limit;
2204   }
2205 
2206     /// @dev change the public max per transaction
2207   function setMaxPerTx(uint256 _limit) public onlyOwner {
2208     MaxperTx = _limit;
2209   }
2210 
2211   /// @dev change the whitelist max per transaction
2212     function setWlMaxPerTx(uint256 _limit) public onlyOwner {
2213     MaxperTxWl = _limit;
2214   }
2215 
2216    /// @dev change the public price(amount need to be in wei)
2217   function setCost(uint256 _newCost) public onlyOwner {
2218     cost = _newCost;
2219   }
2220 
2221    /// @dev change the whitelist price(amount need to be in wei)
2222     function setWlCost(uint256 _newWlCost) public onlyOwner {
2223     wlcost = _newWlCost;
2224   }
2225 
2226   /// @dev cut the supply if we dont sold out
2227     function setMaxsupply(uint256 _newsupply) public onlyOwner {
2228     maxSupply = _newsupply;
2229   }
2230 
2231  /// @dev cut the whitelist supply if we dont sold out
2232     function setwlsupply(uint256 _newsupply) public onlyOwner {
2233     WlSupply = _newsupply;
2234   }
2235 
2236  /// @dev set your baseuri
2237   function setBaseURI(string memory _newBaseURI) public onlyOwner {
2238     baseURI = _newBaseURI;
2239   }
2240 
2241    /// @dev set hidden uri
2242   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2243     notRevealedUri = _notRevealedURI;
2244   }
2245 
2246  /// @dev to pause and unpause your contract(use booleans true or false)
2247   function pause(bool _state) public onlyOwner {
2248     paused = _state;
2249   }
2250 
2251      /// @dev activate whitelist sale(use booleans true or false)
2252     function togglepreSale(bool _state) external onlyOwner {
2253         preSale = _state;
2254     }
2255 
2256     /// @dev activate public sale(use booleans true or false)
2257     function togglepublicSale(bool _state) external onlyOwner {
2258         publicSale = _state;
2259     }
2260   
2261   /// @dev withdraw funds from contract
2262   function withdraw() public payable onlyOwner nonReentrant {
2263       uint256 share1 = address(this).balance * 100 / 100;
2264 
2265       payable(p1).transfer(share1);
2266   }
2267 
2268     /// Opensea Royalties
2269 
2270     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2271     super.transferFrom(from, to, tokenId);
2272   }
2273 
2274     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2275     super.safeTransferFrom(from, to, tokenId);
2276   }
2277 
2278     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
2279     super.safeTransferFrom(from, to, tokenId, data);
2280   }
2281 }