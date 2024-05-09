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
475 // File: @openzeppelin/contracts/utils/Context.sol
476 
477 
478 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev Provides information about the current execution context, including the
484  * sender of the transaction and its data. While these are generally available
485  * via msg.sender and msg.data, they should not be accessed in such a direct
486  * manner, since when dealing with meta-transactions the account sending and
487  * paying for execution may not be the actual sender (as far as an application
488  * is concerned).
489  *
490  * This contract is only required for intermediate, library-like contracts.
491  */
492 abstract contract Context {
493     function _msgSender() internal view virtual returns (address) {
494         return msg.sender;
495     }
496 
497     function _msgData() internal view virtual returns (bytes calldata) {
498         return msg.data;
499     }
500 }
501 
502 // File: @openzeppelin/contracts/access/Ownable.sol
503 
504 
505 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 
510 /**
511  * @dev Contract module which provides a basic access control mechanism, where
512  * there is an account (an owner) that can be granted exclusive access to
513  * specific functions.
514  *
515  * By default, the owner account will be the one that deploys the contract. This
516  * can later be changed with {transferOwnership}.
517  *
518  * This module is used through inheritance. It will make available the modifier
519  * `onlyOwner`, which can be applied to your functions to restrict their use to
520  * the owner.
521  */
522 abstract contract Ownable is Context {
523     address private _owner;
524 
525     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
526 
527     /**
528      * @dev Initializes the contract setting the deployer as the initial owner.
529      */
530     constructor() {
531         _transferOwnership(_msgSender());
532     }
533 
534     /**
535      * @dev Throws if called by any account other than the owner.
536      */
537     modifier onlyOwner() {
538         _checkOwner();
539         _;
540     }
541 
542     /**
543      * @dev Returns the address of the current owner.
544      */
545     function owner() public view virtual returns (address) {
546         return _owner;
547     }
548 
549     /**
550      * @dev Throws if the sender is not the owner.
551      */
552     function _checkOwner() internal view virtual {
553         require(owner() == _msgSender(), "Ownable: caller is not the owner");
554     }
555 
556     /**
557      * @dev Leaves the contract without owner. It will not be possible to call
558      * `onlyOwner` functions anymore. Can only be called by the current owner.
559      *
560      * NOTE: Renouncing ownership will leave the contract without an owner,
561      * thereby removing any functionality that is only available to the owner.
562      */
563     function renounceOwnership() public virtual onlyOwner {
564         _transferOwnership(address(0));
565     }
566 
567     /**
568      * @dev Transfers ownership of the contract to a new account (`newOwner`).
569      * Can only be called by the current owner.
570      */
571     function transferOwnership(address newOwner) public virtual onlyOwner {
572         require(newOwner != address(0), "Ownable: new owner is the zero address");
573         _transferOwnership(newOwner);
574     }
575 
576     /**
577      * @dev Transfers ownership of the contract to a new account (`newOwner`).
578      * Internal function without access restriction.
579      */
580     function _transferOwnership(address newOwner) internal virtual {
581         address oldOwner = _owner;
582         _owner = newOwner;
583         emit OwnershipTransferred(oldOwner, newOwner);
584     }
585 }
586 
587 // File: erc721a/contracts/IERC721A.sol
588 
589 
590 // ERC721A Contracts v4.2.3
591 // Creator: Chiru Labs
592 
593 pragma solidity ^0.8.4;
594 
595 /**
596  * @dev Interface of ERC721A.
597  */
598 interface IERC721A {
599     /**
600      * The caller must own the token or be an approved operator.
601      */
602     error ApprovalCallerNotOwnerNorApproved();
603 
604     /**
605      * The token does not exist.
606      */
607     error ApprovalQueryForNonexistentToken();
608 
609     /**
610      * Cannot query the balance for the zero address.
611      */
612     error BalanceQueryForZeroAddress();
613 
614     /**
615      * Cannot mint to the zero address.
616      */
617     error MintToZeroAddress();
618 
619     /**
620      * The quantity of tokens minted must be more than zero.
621      */
622     error MintZeroQuantity();
623 
624     /**
625      * The token does not exist.
626      */
627     error OwnerQueryForNonexistentToken();
628 
629     /**
630      * The caller must own the token or be an approved operator.
631      */
632     error TransferCallerNotOwnerNorApproved();
633 
634     /**
635      * The token must be owned by `from`.
636      */
637     error TransferFromIncorrectOwner();
638 
639     /**
640      * Cannot safely transfer to a contract that does not implement the
641      * ERC721Receiver interface.
642      */
643     error TransferToNonERC721ReceiverImplementer();
644 
645     /**
646      * Cannot transfer to the zero address.
647      */
648     error TransferToZeroAddress();
649 
650     /**
651      * The token does not exist.
652      */
653     error URIQueryForNonexistentToken();
654 
655     /**
656      * The `quantity` minted with ERC2309 exceeds the safety limit.
657      */
658     error MintERC2309QuantityExceedsLimit();
659 
660     /**
661      * The `extraData` cannot be set on an unintialized ownership slot.
662      */
663     error OwnershipNotInitializedForExtraData();
664 
665     // =============================================================
666     //                            STRUCTS
667     // =============================================================
668 
669     struct TokenOwnership {
670         // The address of the owner.
671         address addr;
672         // Stores the start time of ownership with minimal overhead for tokenomics.
673         uint64 startTimestamp;
674         // Whether the token has been burned.
675         bool burned;
676         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
677         uint24 extraData;
678     }
679 
680     // =============================================================
681     //                         TOKEN COUNTERS
682     // =============================================================
683 
684     /**
685      * @dev Returns the total number of tokens in existence.
686      * Burned tokens will reduce the count.
687      * To get the total number of tokens minted, please see {_totalMinted}.
688      */
689     function totalSupply() external view returns (uint256);
690 
691     // =============================================================
692     //                            IERC165
693     // =============================================================
694 
695     /**
696      * @dev Returns true if this contract implements the interface defined by
697      * `interfaceId`. See the corresponding
698      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
699      * to learn more about how these ids are created.
700      *
701      * This function call must use less than 30000 gas.
702      */
703     function supportsInterface(bytes4 interfaceId) external view returns (bool);
704 
705     // =============================================================
706     //                            IERC721
707     // =============================================================
708 
709     /**
710      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
711      */
712     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
713 
714     /**
715      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
716      */
717     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
718 
719     /**
720      * @dev Emitted when `owner` enables or disables
721      * (`approved`) `operator` to manage all of its assets.
722      */
723     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
724 
725     /**
726      * @dev Returns the number of tokens in `owner`'s account.
727      */
728     function balanceOf(address owner) external view returns (uint256 balance);
729 
730     /**
731      * @dev Returns the owner of the `tokenId` token.
732      *
733      * Requirements:
734      *
735      * - `tokenId` must exist.
736      */
737     function ownerOf(uint256 tokenId) external view returns (address owner);
738 
739     /**
740      * @dev Safely transfers `tokenId` token from `from` to `to`,
741      * checking first that contract recipients are aware of the ERC721 protocol
742      * to prevent tokens from being forever locked.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must exist and be owned by `from`.
749      * - If the caller is not `from`, it must be have been allowed to move
750      * this token by either {approve} or {setApprovalForAll}.
751      * - If `to` refers to a smart contract, it must implement
752      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
753      *
754      * Emits a {Transfer} event.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes calldata data
761     ) external payable;
762 
763     /**
764      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
765      */
766     function safeTransferFrom(
767         address from,
768         address to,
769         uint256 tokenId
770     ) external payable;
771 
772     /**
773      * @dev Transfers `tokenId` from `from` to `to`.
774      *
775      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
776      * whenever possible.
777      *
778      * Requirements:
779      *
780      * - `from` cannot be the zero address.
781      * - `to` cannot be the zero address.
782      * - `tokenId` token must be owned by `from`.
783      * - If the caller is not `from`, it must be approved to move this token
784      * by either {approve} or {setApprovalForAll}.
785      *
786      * Emits a {Transfer} event.
787      */
788     function transferFrom(
789         address from,
790         address to,
791         uint256 tokenId
792     ) external payable;
793 
794     /**
795      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
796      * The approval is cleared when the token is transferred.
797      *
798      * Only a single account can be approved at a time, so approving the
799      * zero address clears previous approvals.
800      *
801      * Requirements:
802      *
803      * - The caller must own the token or be an approved operator.
804      * - `tokenId` must exist.
805      *
806      * Emits an {Approval} event.
807      */
808     function approve(address to, uint256 tokenId) external payable;
809 
810     /**
811      * @dev Approve or remove `operator` as an operator for the caller.
812      * Operators can call {transferFrom} or {safeTransferFrom}
813      * for any token owned by the caller.
814      *
815      * Requirements:
816      *
817      * - The `operator` cannot be the caller.
818      *
819      * Emits an {ApprovalForAll} event.
820      */
821     function setApprovalForAll(address operator, bool _approved) external;
822 
823     /**
824      * @dev Returns the account approved for `tokenId` token.
825      *
826      * Requirements:
827      *
828      * - `tokenId` must exist.
829      */
830     function getApproved(uint256 tokenId) external view returns (address operator);
831 
832     /**
833      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
834      *
835      * See {setApprovalForAll}.
836      */
837     function isApprovedForAll(address owner, address operator) external view returns (bool);
838 
839     // =============================================================
840     //                        IERC721Metadata
841     // =============================================================
842 
843     /**
844      * @dev Returns the token collection name.
845      */
846     function name() external view returns (string memory);
847 
848     /**
849      * @dev Returns the token collection symbol.
850      */
851     function symbol() external view returns (string memory);
852 
853     /**
854      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
855      */
856     function tokenURI(uint256 tokenId) external view returns (string memory);
857 
858     // =============================================================
859     //                           IERC2309
860     // =============================================================
861 
862     /**
863      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
864      * (inclusive) is transferred from `from` to `to`, as defined in the
865      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
866      *
867      * See {_mintERC2309} for more details.
868      */
869     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
870 }
871 
872 // File: erc721a/contracts/ERC721A.sol
873 
874 
875 // ERC721A Contracts v4.2.3
876 // Creator: Chiru Labs
877 
878 pragma solidity ^0.8.4;
879 
880 
881 /**
882  * @dev Interface of ERC721 token receiver.
883  */
884 interface ERC721A__IERC721Receiver {
885     function onERC721Received(
886         address operator,
887         address from,
888         uint256 tokenId,
889         bytes calldata data
890     ) external returns (bytes4);
891 }
892 
893 /**
894  * @title ERC721A
895  *
896  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
897  * Non-Fungible Token Standard, including the Metadata extension.
898  * Optimized for lower gas during batch mints.
899  *
900  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
901  * starting from `_startTokenId()`.
902  *
903  * Assumptions:
904  *
905  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
906  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
907  */
908 contract ERC721A is IERC721A {
909     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
910     struct TokenApprovalRef {
911         address value;
912     }
913 
914     // =============================================================
915     //                           CONSTANTS
916     // =============================================================
917 
918     // Mask of an entry in packed address data.
919     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
920 
921     // The bit position of `numberMinted` in packed address data.
922     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
923 
924     // The bit position of `numberBurned` in packed address data.
925     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
926 
927     // The bit position of `aux` in packed address data.
928     uint256 private constant _BITPOS_AUX = 192;
929 
930     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
931     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
932 
933     // The bit position of `startTimestamp` in packed ownership.
934     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
935 
936     // The bit mask of the `burned` bit in packed ownership.
937     uint256 private constant _BITMASK_BURNED = 1 << 224;
938 
939     // The bit position of the `nextInitialized` bit in packed ownership.
940     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
941 
942     // The bit mask of the `nextInitialized` bit in packed ownership.
943     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
944 
945     // The bit position of `extraData` in packed ownership.
946     uint256 private constant _BITPOS_EXTRA_DATA = 232;
947 
948     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
949     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
950 
951     // The mask of the lower 160 bits for addresses.
952     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
953 
954     // The maximum `quantity` that can be minted with {_mintERC2309}.
955     // This limit is to prevent overflows on the address data entries.
956     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
957     // is required to cause an overflow, which is unrealistic.
958     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
959 
960     // The `Transfer` event signature is given by:
961     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
962     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
963         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
964 
965     // =============================================================
966     //                            STORAGE
967     // =============================================================
968 
969     // The next token ID to be minted.
970     uint256 private _currentIndex;
971 
972     // The number of tokens burned.
973     uint256 private _burnCounter;
974 
975     // Token name
976     string private _name;
977 
978     // Token symbol
979     string private _symbol;
980 
981     // Mapping from token ID to ownership details
982     // An empty struct value does not necessarily mean the token is unowned.
983     // See {_packedOwnershipOf} implementation for details.
984     //
985     // Bits Layout:
986     // - [0..159]   `addr`
987     // - [160..223] `startTimestamp`
988     // - [224]      `burned`
989     // - [225]      `nextInitialized`
990     // - [232..255] `extraData`
991     mapping(uint256 => uint256) private _packedOwnerships;
992 
993     // Mapping owner address to address data.
994     //
995     // Bits Layout:
996     // - [0..63]    `balance`
997     // - [64..127]  `numberMinted`
998     // - [128..191] `numberBurned`
999     // - [192..255] `aux`
1000     mapping(address => uint256) private _packedAddressData;
1001 
1002     // Mapping from token ID to approved address.
1003     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1004 
1005     // Mapping from owner to operator approvals
1006     mapping(address => mapping(address => bool)) private _operatorApprovals;
1007 
1008     // =============================================================
1009     //                          CONSTRUCTOR
1010     // =============================================================
1011 
1012     constructor(string memory name_, string memory symbol_) {
1013         _name = name_;
1014         _symbol = symbol_;
1015         _currentIndex = _startTokenId();
1016     }
1017 
1018     // =============================================================
1019     //                   TOKEN COUNTING OPERATIONS
1020     // =============================================================
1021 
1022     /**
1023      * @dev Returns the starting token ID.
1024      * To change the starting token ID, please override this function.
1025      */
1026     function _startTokenId() internal view virtual returns (uint256) {
1027         return 0;
1028     }
1029 
1030     /**
1031      * @dev Returns the next token ID to be minted.
1032      */
1033     function _nextTokenId() internal view virtual returns (uint256) {
1034         return _currentIndex;
1035     }
1036 
1037     /**
1038      * @dev Returns the total number of tokens in existence.
1039      * Burned tokens will reduce the count.
1040      * To get the total number of tokens minted, please see {_totalMinted}.
1041      */
1042     function totalSupply() public view virtual override returns (uint256) {
1043         // Counter underflow is impossible as _burnCounter cannot be incremented
1044         // more than `_currentIndex - _startTokenId()` times.
1045         unchecked {
1046             return _currentIndex - _burnCounter - _startTokenId();
1047         }
1048     }
1049 
1050     /**
1051      * @dev Returns the total amount of tokens minted in the contract.
1052      */
1053     function _totalMinted() internal view virtual returns (uint256) {
1054         // Counter underflow is impossible as `_currentIndex` does not decrement,
1055         // and it is initialized to `_startTokenId()`.
1056         unchecked {
1057             return _currentIndex - _startTokenId();
1058         }
1059     }
1060 
1061     /**
1062      * @dev Returns the total number of tokens burned.
1063      */
1064     function _totalBurned() internal view virtual returns (uint256) {
1065         return _burnCounter;
1066     }
1067 
1068     // =============================================================
1069     //                    ADDRESS DATA OPERATIONS
1070     // =============================================================
1071 
1072     /**
1073      * @dev Returns the number of tokens in `owner`'s account.
1074      */
1075     function balanceOf(address owner) public view virtual override returns (uint256) {
1076         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1077         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1078     }
1079 
1080     /**
1081      * Returns the number of tokens minted by `owner`.
1082      */
1083     function _numberMinted(address owner) internal view returns (uint256) {
1084         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1085     }
1086 
1087     /**
1088      * Returns the number of tokens burned by or on behalf of `owner`.
1089      */
1090     function _numberBurned(address owner) internal view returns (uint256) {
1091         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1092     }
1093 
1094     /**
1095      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1096      */
1097     function _getAux(address owner) internal view returns (uint64) {
1098         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1099     }
1100 
1101     /**
1102      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1103      * If there are multiple variables, please pack them into a uint64.
1104      */
1105     function _setAux(address owner, uint64 aux) internal virtual {
1106         uint256 packed = _packedAddressData[owner];
1107         uint256 auxCasted;
1108         // Cast `aux` with assembly to avoid redundant masking.
1109         assembly {
1110             auxCasted := aux
1111         }
1112         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1113         _packedAddressData[owner] = packed;
1114     }
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
1128     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1129         // The interface IDs are constants representing the first 4 bytes
1130         // of the XOR of all function selectors in the interface.
1131         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1132         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1133         return
1134             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1135             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1136             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1137     }
1138 
1139     // =============================================================
1140     //                        IERC721Metadata
1141     // =============================================================
1142 
1143     /**
1144      * @dev Returns the token collection name.
1145      */
1146     function name() public view virtual override returns (string memory) {
1147         return _name;
1148     }
1149 
1150     /**
1151      * @dev Returns the token collection symbol.
1152      */
1153     function symbol() public view virtual override returns (string memory) {
1154         return _symbol;
1155     }
1156 
1157     /**
1158      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1159      */
1160     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1161         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1162 
1163         string memory baseURI = _baseURI();
1164         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1165     }
1166 
1167     /**
1168      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1169      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1170      * by default, it can be overridden in child contracts.
1171      */
1172     function _baseURI() internal view virtual returns (string memory) {
1173         return '';
1174     }
1175 
1176     // =============================================================
1177     //                     OWNERSHIPS OPERATIONS
1178     // =============================================================
1179 
1180     /**
1181      * @dev Returns the owner of the `tokenId` token.
1182      *
1183      * Requirements:
1184      *
1185      * - `tokenId` must exist.
1186      */
1187     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1188         return address(uint160(_packedOwnershipOf(tokenId)));
1189     }
1190 
1191     /**
1192      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1193      * It gradually moves to O(1) as tokens get transferred around over time.
1194      */
1195     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1196         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1197     }
1198 
1199     /**
1200      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1201      */
1202     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1203         return _unpackedOwnership(_packedOwnerships[index]);
1204     }
1205 
1206     /**
1207      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1208      */
1209     function _initializeOwnershipAt(uint256 index) internal virtual {
1210         if (_packedOwnerships[index] == 0) {
1211             _packedOwnerships[index] = _packedOwnershipOf(index);
1212         }
1213     }
1214 
1215     /**
1216      * Returns the packed ownership data of `tokenId`.
1217      */
1218     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1219         uint256 curr = tokenId;
1220 
1221         unchecked {
1222             if (_startTokenId() <= curr)
1223                 if (curr < _currentIndex) {
1224                     uint256 packed = _packedOwnerships[curr];
1225                     // If not burned.
1226                     if (packed & _BITMASK_BURNED == 0) {
1227                         // Invariant:
1228                         // There will always be an initialized ownership slot
1229                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1230                         // before an unintialized ownership slot
1231                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1232                         // Hence, `curr` will not underflow.
1233                         //
1234                         // We can directly compare the packed value.
1235                         // If the address is zero, packed will be zero.
1236                         while (packed == 0) {
1237                             packed = _packedOwnerships[--curr];
1238                         }
1239                         return packed;
1240                     }
1241                 }
1242         }
1243         revert OwnerQueryForNonexistentToken();
1244     }
1245 
1246     /**
1247      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1248      */
1249     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1250         ownership.addr = address(uint160(packed));
1251         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1252         ownership.burned = packed & _BITMASK_BURNED != 0;
1253         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1254     }
1255 
1256     /**
1257      * @dev Packs ownership data into a single uint256.
1258      */
1259     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1260         assembly {
1261             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1262             owner := and(owner, _BITMASK_ADDRESS)
1263             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1264             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1265         }
1266     }
1267 
1268     /**
1269      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1270      */
1271     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1272         // For branchless setting of the `nextInitialized` flag.
1273         assembly {
1274             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1275             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1276         }
1277     }
1278 
1279     // =============================================================
1280     //                      APPROVAL OPERATIONS
1281     // =============================================================
1282 
1283     /**
1284      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1285      * The approval is cleared when the token is transferred.
1286      *
1287      * Only a single account can be approved at a time, so approving the
1288      * zero address clears previous approvals.
1289      *
1290      * Requirements:
1291      *
1292      * - The caller must own the token or be an approved operator.
1293      * - `tokenId` must exist.
1294      *
1295      * Emits an {Approval} event.
1296      */
1297     function approve(address to, uint256 tokenId) public payable virtual override {
1298         address owner = ownerOf(tokenId);
1299 
1300         if (_msgSenderERC721A() != owner)
1301             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1302                 revert ApprovalCallerNotOwnerNorApproved();
1303             }
1304 
1305         _tokenApprovals[tokenId].value = to;
1306         emit Approval(owner, to, tokenId);
1307     }
1308 
1309     /**
1310      * @dev Returns the account approved for `tokenId` token.
1311      *
1312      * Requirements:
1313      *
1314      * - `tokenId` must exist.
1315      */
1316     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1317         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1318 
1319         return _tokenApprovals[tokenId].value;
1320     }
1321 
1322     /**
1323      * @dev Approve or remove `operator` as an operator for the caller.
1324      * Operators can call {transferFrom} or {safeTransferFrom}
1325      * for any token owned by the caller.
1326      *
1327      * Requirements:
1328      *
1329      * - The `operator` cannot be the caller.
1330      *
1331      * Emits an {ApprovalForAll} event.
1332      */
1333     function setApprovalForAll(address operator, bool approved) public virtual override {
1334         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1335         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1336     }
1337 
1338     /**
1339      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1340      *
1341      * See {setApprovalForAll}.
1342      */
1343     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1344         return _operatorApprovals[owner][operator];
1345     }
1346 
1347     /**
1348      * @dev Returns whether `tokenId` exists.
1349      *
1350      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1351      *
1352      * Tokens start existing when they are minted. See {_mint}.
1353      */
1354     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1355         return
1356             _startTokenId() <= tokenId &&
1357             tokenId < _currentIndex && // If within bounds,
1358             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1359     }
1360 
1361     /**
1362      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1363      */
1364     function _isSenderApprovedOrOwner(
1365         address approvedAddress,
1366         address owner,
1367         address msgSender
1368     ) private pure returns (bool result) {
1369         assembly {
1370             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1371             owner := and(owner, _BITMASK_ADDRESS)
1372             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1373             msgSender := and(msgSender, _BITMASK_ADDRESS)
1374             // `msgSender == owner || msgSender == approvedAddress`.
1375             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1376         }
1377     }
1378 
1379     /**
1380      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1381      */
1382     function _getApprovedSlotAndAddress(uint256 tokenId)
1383         private
1384         view
1385         returns (uint256 approvedAddressSlot, address approvedAddress)
1386     {
1387         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1388         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1389         assembly {
1390             approvedAddressSlot := tokenApproval.slot
1391             approvedAddress := sload(approvedAddressSlot)
1392         }
1393     }
1394 
1395     // =============================================================
1396     //                      TRANSFER OPERATIONS
1397     // =============================================================
1398 
1399     /**
1400      * @dev Transfers `tokenId` from `from` to `to`.
1401      *
1402      * Requirements:
1403      *
1404      * - `from` cannot be the zero address.
1405      * - `to` cannot be the zero address.
1406      * - `tokenId` token must be owned by `from`.
1407      * - If the caller is not `from`, it must be approved to move this token
1408      * by either {approve} or {setApprovalForAll}.
1409      *
1410      * Emits a {Transfer} event.
1411      */
1412     function transferFrom(
1413         address from,
1414         address to,
1415         uint256 tokenId
1416     ) public payable virtual override {
1417         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1418 
1419         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1420 
1421         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1422 
1423         // The nested ifs save around 20+ gas over a compound boolean condition.
1424         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1425             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1426 
1427         if (to == address(0)) revert TransferToZeroAddress();
1428 
1429         _beforeTokenTransfers(from, to, tokenId, 1);
1430 
1431         // Clear approvals from the previous owner.
1432         assembly {
1433             if approvedAddress {
1434                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1435                 sstore(approvedAddressSlot, 0)
1436             }
1437         }
1438 
1439         // Underflow of the sender's balance is impossible because we check for
1440         // ownership above and the recipient's balance can't realistically overflow.
1441         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1442         unchecked {
1443             // We can directly increment and decrement the balances.
1444             --_packedAddressData[from]; // Updates: `balance -= 1`.
1445             ++_packedAddressData[to]; // Updates: `balance += 1`.
1446 
1447             // Updates:
1448             // - `address` to the next owner.
1449             // - `startTimestamp` to the timestamp of transfering.
1450             // - `burned` to `false`.
1451             // - `nextInitialized` to `true`.
1452             _packedOwnerships[tokenId] = _packOwnershipData(
1453                 to,
1454                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1455             );
1456 
1457             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1458             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1459                 uint256 nextTokenId = tokenId + 1;
1460                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1461                 if (_packedOwnerships[nextTokenId] == 0) {
1462                     // If the next slot is within bounds.
1463                     if (nextTokenId != _currentIndex) {
1464                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1465                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1466                     }
1467                 }
1468             }
1469         }
1470 
1471         emit Transfer(from, to, tokenId);
1472         _afterTokenTransfers(from, to, tokenId, 1);
1473     }
1474 
1475     /**
1476      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1477      */
1478     function safeTransferFrom(
1479         address from,
1480         address to,
1481         uint256 tokenId
1482     ) public payable virtual override {
1483         safeTransferFrom(from, to, tokenId, '');
1484     }
1485 
1486     /**
1487      * @dev Safely transfers `tokenId` token from `from` to `to`.
1488      *
1489      * Requirements:
1490      *
1491      * - `from` cannot be the zero address.
1492      * - `to` cannot be the zero address.
1493      * - `tokenId` token must exist and be owned by `from`.
1494      * - If the caller is not `from`, it must be approved to move this token
1495      * by either {approve} or {setApprovalForAll}.
1496      * - If `to` refers to a smart contract, it must implement
1497      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1498      *
1499      * Emits a {Transfer} event.
1500      */
1501     function safeTransferFrom(
1502         address from,
1503         address to,
1504         uint256 tokenId,
1505         bytes memory _data
1506     ) public payable virtual override {
1507         transferFrom(from, to, tokenId);
1508         if (to.code.length != 0)
1509             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1510                 revert TransferToNonERC721ReceiverImplementer();
1511             }
1512     }
1513 
1514     /**
1515      * @dev Hook that is called before a set of serially-ordered token IDs
1516      * are about to be transferred. This includes minting.
1517      * And also called before burning one token.
1518      *
1519      * `startTokenId` - the first token ID to be transferred.
1520      * `quantity` - the amount to be transferred.
1521      *
1522      * Calling conditions:
1523      *
1524      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1525      * transferred to `to`.
1526      * - When `from` is zero, `tokenId` will be minted for `to`.
1527      * - When `to` is zero, `tokenId` will be burned by `from`.
1528      * - `from` and `to` are never both zero.
1529      */
1530     function _beforeTokenTransfers(
1531         address from,
1532         address to,
1533         uint256 startTokenId,
1534         uint256 quantity
1535     ) internal virtual {}
1536 
1537     /**
1538      * @dev Hook that is called after a set of serially-ordered token IDs
1539      * have been transferred. This includes minting.
1540      * And also called after one token has been burned.
1541      *
1542      * `startTokenId` - the first token ID to be transferred.
1543      * `quantity` - the amount to be transferred.
1544      *
1545      * Calling conditions:
1546      *
1547      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1548      * transferred to `to`.
1549      * - When `from` is zero, `tokenId` has been minted for `to`.
1550      * - When `to` is zero, `tokenId` has been burned by `from`.
1551      * - `from` and `to` are never both zero.
1552      */
1553     function _afterTokenTransfers(
1554         address from,
1555         address to,
1556         uint256 startTokenId,
1557         uint256 quantity
1558     ) internal virtual {}
1559 
1560     /**
1561      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1562      *
1563      * `from` - Previous owner of the given token ID.
1564      * `to` - Target address that will receive the token.
1565      * `tokenId` - Token ID to be transferred.
1566      * `_data` - Optional data to send along with the call.
1567      *
1568      * Returns whether the call correctly returned the expected magic value.
1569      */
1570     function _checkContractOnERC721Received(
1571         address from,
1572         address to,
1573         uint256 tokenId,
1574         bytes memory _data
1575     ) private returns (bool) {
1576         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1577             bytes4 retval
1578         ) {
1579             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1580         } catch (bytes memory reason) {
1581             if (reason.length == 0) {
1582                 revert TransferToNonERC721ReceiverImplementer();
1583             } else {
1584                 assembly {
1585                     revert(add(32, reason), mload(reason))
1586                 }
1587             }
1588         }
1589     }
1590 
1591     // =============================================================
1592     //                        MINT OPERATIONS
1593     // =============================================================
1594 
1595     /**
1596      * @dev Mints `quantity` tokens and transfers them to `to`.
1597      *
1598      * Requirements:
1599      *
1600      * - `to` cannot be the zero address.
1601      * - `quantity` must be greater than 0.
1602      *
1603      * Emits a {Transfer} event for each mint.
1604      */
1605     function _mint(address to, uint256 quantity) internal virtual {
1606         uint256 startTokenId = _currentIndex;
1607         if (quantity == 0) revert MintZeroQuantity();
1608 
1609         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1610 
1611         // Overflows are incredibly unrealistic.
1612         // `balance` and `numberMinted` have a maximum limit of 2**64.
1613         // `tokenId` has a maximum limit of 2**256.
1614         unchecked {
1615             // Updates:
1616             // - `balance += quantity`.
1617             // - `numberMinted += quantity`.
1618             //
1619             // We can directly add to the `balance` and `numberMinted`.
1620             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1621 
1622             // Updates:
1623             // - `address` to the owner.
1624             // - `startTimestamp` to the timestamp of minting.
1625             // - `burned` to `false`.
1626             // - `nextInitialized` to `quantity == 1`.
1627             _packedOwnerships[startTokenId] = _packOwnershipData(
1628                 to,
1629                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1630             );
1631 
1632             uint256 toMasked;
1633             uint256 end = startTokenId + quantity;
1634 
1635             // Use assembly to loop and emit the `Transfer` event for gas savings.
1636             // The duplicated `log4` removes an extra check and reduces stack juggling.
1637             // The assembly, together with the surrounding Solidity code, have been
1638             // delicately arranged to nudge the compiler into producing optimized opcodes.
1639             assembly {
1640                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1641                 toMasked := and(to, _BITMASK_ADDRESS)
1642                 // Emit the `Transfer` event.
1643                 log4(
1644                     0, // Start of data (0, since no data).
1645                     0, // End of data (0, since no data).
1646                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1647                     0, // `address(0)`.
1648                     toMasked, // `to`.
1649                     startTokenId // `tokenId`.
1650                 )
1651 
1652                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1653                 // that overflows uint256 will make the loop run out of gas.
1654                 // The compiler will optimize the `iszero` away for performance.
1655                 for {
1656                     let tokenId := add(startTokenId, 1)
1657                 } iszero(eq(tokenId, end)) {
1658                     tokenId := add(tokenId, 1)
1659                 } {
1660                     // Emit the `Transfer` event. Similar to above.
1661                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1662                 }
1663             }
1664             if (toMasked == 0) revert MintToZeroAddress();
1665 
1666             _currentIndex = end;
1667         }
1668         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1669     }
1670 
1671     /**
1672      * @dev Mints `quantity` tokens and transfers them to `to`.
1673      *
1674      * This function is intended for efficient minting only during contract creation.
1675      *
1676      * It emits only one {ConsecutiveTransfer} as defined in
1677      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1678      * instead of a sequence of {Transfer} event(s).
1679      *
1680      * Calling this function outside of contract creation WILL make your contract
1681      * non-compliant with the ERC721 standard.
1682      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1683      * {ConsecutiveTransfer} event is only permissible during contract creation.
1684      *
1685      * Requirements:
1686      *
1687      * - `to` cannot be the zero address.
1688      * - `quantity` must be greater than 0.
1689      *
1690      * Emits a {ConsecutiveTransfer} event.
1691      */
1692     function _mintERC2309(address to, uint256 quantity) internal virtual {
1693         uint256 startTokenId = _currentIndex;
1694         if (to == address(0)) revert MintToZeroAddress();
1695         if (quantity == 0) revert MintZeroQuantity();
1696         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1697 
1698         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1699 
1700         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1701         unchecked {
1702             // Updates:
1703             // - `balance += quantity`.
1704             // - `numberMinted += quantity`.
1705             //
1706             // We can directly add to the `balance` and `numberMinted`.
1707             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1708 
1709             // Updates:
1710             // - `address` to the owner.
1711             // - `startTimestamp` to the timestamp of minting.
1712             // - `burned` to `false`.
1713             // - `nextInitialized` to `quantity == 1`.
1714             _packedOwnerships[startTokenId] = _packOwnershipData(
1715                 to,
1716                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1717             );
1718 
1719             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1720 
1721             _currentIndex = startTokenId + quantity;
1722         }
1723         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1724     }
1725 
1726     /**
1727      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1728      *
1729      * Requirements:
1730      *
1731      * - If `to` refers to a smart contract, it must implement
1732      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1733      * - `quantity` must be greater than 0.
1734      *
1735      * See {_mint}.
1736      *
1737      * Emits a {Transfer} event for each mint.
1738      */
1739     function _safeMint(
1740         address to,
1741         uint256 quantity,
1742         bytes memory _data
1743     ) internal virtual {
1744         _mint(to, quantity);
1745 
1746         unchecked {
1747             if (to.code.length != 0) {
1748                 uint256 end = _currentIndex;
1749                 uint256 index = end - quantity;
1750                 do {
1751                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1752                         revert TransferToNonERC721ReceiverImplementer();
1753                     }
1754                 } while (index < end);
1755                 // Reentrancy protection.
1756                 if (_currentIndex != end) revert();
1757             }
1758         }
1759     }
1760 
1761     /**
1762      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1763      */
1764     function _safeMint(address to, uint256 quantity) internal virtual {
1765         _safeMint(to, quantity, '');
1766     }
1767 
1768     // =============================================================
1769     //                        BURN OPERATIONS
1770     // =============================================================
1771 
1772     /**
1773      * @dev Equivalent to `_burn(tokenId, false)`.
1774      */
1775     function _burn(uint256 tokenId) internal virtual {
1776         _burn(tokenId, false);
1777     }
1778 
1779     /**
1780      * @dev Destroys `tokenId`.
1781      * The approval is cleared when the token is burned.
1782      *
1783      * Requirements:
1784      *
1785      * - `tokenId` must exist.
1786      *
1787      * Emits a {Transfer} event.
1788      */
1789     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1790         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1791 
1792         address from = address(uint160(prevOwnershipPacked));
1793 
1794         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1795 
1796         if (approvalCheck) {
1797             // The nested ifs save around 20+ gas over a compound boolean condition.
1798             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1799                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1800         }
1801 
1802         _beforeTokenTransfers(from, address(0), tokenId, 1);
1803 
1804         // Clear approvals from the previous owner.
1805         assembly {
1806             if approvedAddress {
1807                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1808                 sstore(approvedAddressSlot, 0)
1809             }
1810         }
1811 
1812         // Underflow of the sender's balance is impossible because we check for
1813         // ownership above and the recipient's balance can't realistically overflow.
1814         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1815         unchecked {
1816             // Updates:
1817             // - `balance -= 1`.
1818             // - `numberBurned += 1`.
1819             //
1820             // We can directly decrement the balance, and increment the number burned.
1821             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1822             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1823 
1824             // Updates:
1825             // - `address` to the last owner.
1826             // - `startTimestamp` to the timestamp of burning.
1827             // - `burned` to `true`.
1828             // - `nextInitialized` to `true`.
1829             _packedOwnerships[tokenId] = _packOwnershipData(
1830                 from,
1831                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1832             );
1833 
1834             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1835             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1836                 uint256 nextTokenId = tokenId + 1;
1837                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1838                 if (_packedOwnerships[nextTokenId] == 0) {
1839                     // If the next slot is within bounds.
1840                     if (nextTokenId != _currentIndex) {
1841                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1842                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1843                     }
1844                 }
1845             }
1846         }
1847 
1848         emit Transfer(from, address(0), tokenId);
1849         _afterTokenTransfers(from, address(0), tokenId, 1);
1850 
1851         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1852         unchecked {
1853             _burnCounter++;
1854         }
1855     }
1856 
1857     // =============================================================
1858     //                     EXTRA DATA OPERATIONS
1859     // =============================================================
1860 
1861     /**
1862      * @dev Directly sets the extra data for the ownership data `index`.
1863      */
1864     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1865         uint256 packed = _packedOwnerships[index];
1866         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1867         uint256 extraDataCasted;
1868         // Cast `extraData` with assembly to avoid redundant masking.
1869         assembly {
1870             extraDataCasted := extraData
1871         }
1872         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1873         _packedOwnerships[index] = packed;
1874     }
1875 
1876     /**
1877      * @dev Called during each token transfer to set the 24bit `extraData` field.
1878      * Intended to be overridden by the cosumer contract.
1879      *
1880      * `previousExtraData` - the value of `extraData` before transfer.
1881      *
1882      * Calling conditions:
1883      *
1884      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1885      * transferred to `to`.
1886      * - When `from` is zero, `tokenId` will be minted for `to`.
1887      * - When `to` is zero, `tokenId` will be burned by `from`.
1888      * - `from` and `to` are never both zero.
1889      */
1890     function _extraData(
1891         address from,
1892         address to,
1893         uint24 previousExtraData
1894     ) internal view virtual returns (uint24) {}
1895 
1896     /**
1897      * @dev Returns the next extra data for the packed ownership data.
1898      * The returned result is shifted into position.
1899      */
1900     function _nextExtraData(
1901         address from,
1902         address to,
1903         uint256 prevOwnershipPacked
1904     ) private view returns (uint256) {
1905         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1906         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1907     }
1908 
1909     // =============================================================
1910     //                       OTHER OPERATIONS
1911     // =============================================================
1912 
1913     /**
1914      * @dev Returns the message sender (defaults to `msg.sender`).
1915      *
1916      * If you are writing GSN compatible contracts, you need to override this function.
1917      */
1918     function _msgSenderERC721A() internal view virtual returns (address) {
1919         return msg.sender;
1920     }
1921 
1922     /**
1923      * @dev Converts a uint256 to its ASCII string decimal representation.
1924      */
1925     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1926         assembly {
1927             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1928             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1929             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1930             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1931             let m := add(mload(0x40), 0xa0)
1932             // Update the free memory pointer to allocate.
1933             mstore(0x40, m)
1934             // Assign the `str` to the end.
1935             str := sub(m, 0x20)
1936             // Zeroize the slot after the string.
1937             mstore(str, 0)
1938 
1939             // Cache the end of the memory to calculate the length later.
1940             let end := str
1941 
1942             // We write the string from rightmost digit to leftmost digit.
1943             // The following is essentially a do-while loop that also handles the zero case.
1944             // prettier-ignore
1945             for { let temp := value } 1 {} {
1946                 str := sub(str, 1)
1947                 // Write the character to the pointer.
1948                 // The ASCII index of the '0' character is 48.
1949                 mstore8(str, add(48, mod(temp, 10)))
1950                 // Keep dividing `temp` until zero.
1951                 temp := div(temp, 10)
1952                 // prettier-ignore
1953                 if iszero(temp) { break }
1954             }
1955 
1956             let length := sub(end, str)
1957             // Move the pointer 32 bytes leftwards to make room for the length.
1958             str := sub(str, 0x20)
1959             // Store the length.
1960             mstore(str, length)
1961         }
1962     }
1963 }
1964 
1965 // File: contracts/SunDayZoo.sol
1966 
1967 //SPDX-License-Identifier: MIT
1968 
1969 pragma solidity ^0.8.4;
1970 
1971 
1972 
1973 
1974 
1975 contract SunDayZoo is ERC721A, Ownable, DefaultOperatorFilterer {
1976     uint256 public maxSupply;
1977     string public baseURI;
1978     uint256 public maxQuantity;
1979 
1980     // whitelist mint information //
1981 
1982     bytes32 public whiteListMerkleRoot;
1983     mapping(address => uint256) public whitelistBuy;
1984     uint256 public whitelistPrice;
1985     bool public allowToWhitelistMint;
1986 
1987     // free mint information //
1988 
1989     bytes32 public freeMintMerkleRoot;
1990     mapping(address => uint256) public freeMintBuy;
1991     uint256 public freeMintPrice;
1992     bool public allowToFreeMint;
1993 
1994     // public mint information //
1995 
1996     mapping(address => uint256) public publicBuy;
1997     uint256 public publicPrice;
1998     bool public allowToPublicMint;
1999 
2000     mapping(address => bool) public admin;
2001 
2002     constructor() ERC721A("SunDayZoo", "SDZ") {
2003         maxSupply = 3333;
2004         baseURI = "https://api.sundayzoo.club/metadata/";
2005         whiteListMerkleRoot = 0xe19bd53bab712a429fbae8335e5cb6d8c8edc15158d2bf9f05f9369658200094;
2006         freeMintMerkleRoot = 0x0b4260fc528bd7544f99d9a03ef01b5356244beabba87ae85545f2fe34f9f2a5;
2007         whitelistPrice = 20000000000000000;
2008         freeMintPrice = 20000000000000000;
2009         publicPrice = 40000000000000000;
2010         maxQuantity = 2;
2011 
2012         // dev team //
2013         admin[0xaCE96014CfF1478255Da9a6efD7Ecc01a0ec87e4] = true;
2014         admin[0x83e707EE630e5c90EDb2B4eEc950100407889e85] = true;
2015         admin[0x4f8f2d4e169B54Db965Ac31A5DA8ca65C0b35ea8] = true;
2016         admin[0xA5B6BB9e10603BA288481e1EBC227b403E27D407] = true;
2017         admin[0x7228e6D23c23DD695b2bc9f29Ba84cE80fb1Ac44] = true;
2018         // dev team //
2019     }
2020 
2021     event WhitelistMint(address to, uint256 quantity, uint256 price);
2022     event FreeMint(address to, uint256 quantity, uint256 price);
2023     event PublicMint(address to, uint256 quantity, uint256 price);
2024     event DevMint(address to, uint256 quantity);
2025 
2026     modifier notContract() {
2027         require(!isContract(msg.sender), "contract not allowed");
2028         require(msg.sender == tx.origin, "proxy contract not allowed");
2029 
2030         _;
2031     }
2032 
2033     function whitelistMint(bytes32[] calldata proof, uint256 quantity)
2034         public
2035         payable
2036         notContract
2037     {
2038         require(
2039             totalSupply() + quantity <= 3133 && allowToWhitelistMint,
2040             "not allow to mint"
2041         );
2042         require(
2043             isWhitelist(msg.sender, proof, whiteListMerkleRoot),
2044             "not in the free mint list"
2045         );
2046 
2047         require(
2048             quantity > 0 && quantity <= maxQuantity,
2049             "out for quantity range"
2050         );
2051         require(whitelistBuy[msg.sender] + quantity < 3, "don't be greedy");
2052         require(msg.value == quantity * whitelistPrice, "not enough ether");
2053 
2054         whitelistBuy[msg.sender] = whitelistBuy[msg.sender] + quantity;
2055         _mint(msg.sender, quantity);
2056 
2057         emit WhitelistMint(msg.sender, quantity, quantity * whitelistPrice);
2058     }
2059 
2060     function freeMint(bytes32[] calldata proof, uint256 quantity)
2061         public
2062         payable
2063         notContract
2064     {
2065         require(totalSupply() + quantity <= maxSupply, "out of supply");
2066         require(allowToFreeMint, "not allow to mint");
2067         require(
2068             isWhitelist(msg.sender, proof, freeMintMerkleRoot),
2069             "not in the free mint list"
2070         );
2071         require(
2072             quantity > 0 && quantity <= maxQuantity,
2073             "out for quantity range"
2074         );
2075         require(freeMintBuy[msg.sender] + quantity <= 2, "don't be greedy");
2076 
2077         if (freeMintBuy[msg.sender] == 0) {
2078             if (quantity == 2) {
2079                 require(msg.value == freeMintPrice, "not enough ether");
2080             }
2081         } else {
2082             require(msg.value == freeMintPrice, "not enough ether");
2083         }
2084 
2085         freeMintBuy[msg.sender] = freeMintBuy[msg.sender] + quantity;
2086         _mint(msg.sender, quantity);
2087 
2088         emit FreeMint(msg.sender, quantity, quantity * freeMintPrice);
2089     }
2090 
2091     function publicMint(uint256 quantity) public payable notContract {
2092         require(totalSupply() + quantity <= maxSupply, "out of supply");
2093         require(allowToPublicMint, "not allow to mint");
2094         require(
2095             quantity > 0 && quantity <= maxQuantity,
2096             "out for quantity range"
2097         );
2098         require(publicBuy[msg.sender] + quantity <= 2, "don't be greedy");
2099         require(msg.value == quantity * publicPrice, "not enough ether");
2100 
2101         publicBuy[msg.sender] = publicBuy[msg.sender] + quantity;
2102         _mint(msg.sender, quantity);
2103 
2104         emit PublicMint(msg.sender, quantity, quantity * publicPrice);
2105     }
2106 
2107     function devMint(uint256 quantity) public {
2108         require(admin[msg.sender], "you are not the admin");
2109         require(totalSupply() + quantity <= maxSupply, "out of supply");
2110         _mint(msg.sender, quantity);
2111 
2112         emit DevMint(msg.sender, quantity);
2113     }
2114 
2115     function tokenURI(uint256 tokenId)
2116         public
2117         view
2118         virtual
2119         override(ERC721A)
2120         returns (string memory)
2121     {
2122         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2123 
2124         return
2125             bytes(baseURI).length != 0
2126                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
2127                 : "";
2128     }
2129 
2130     function withdraw() external onlyOwner {
2131         require(address(this).balance > 0, "insufficient balance");
2132         payable(msg.sender).transfer(address(this).balance);
2133     }
2134 
2135     function leaf(address account) internal pure returns (bytes32) {
2136         return keccak256(abi.encodePacked(account));
2137     }
2138 
2139     function isWhitelist(
2140         address adr,
2141         bytes32[] calldata proof,
2142         bytes32 root
2143     ) internal pure returns (bool) {
2144         return MerkleProof.verify(proof, root, leaf(adr));
2145     }
2146 
2147     function isContract(address addr) internal view returns (bool) {
2148         uint256 size;
2149         assembly {
2150             size := extcodesize(addr)
2151         }
2152         return size > 0;
2153     }
2154 
2155     function setTokenURI(string memory _baseURI) external onlyOwner {
2156         baseURI = _baseURI;
2157     }
2158 
2159     function setAdmin(address _admin, bool _allow) external onlyOwner {
2160         admin[_admin] = _allow;
2161     }
2162 
2163     function setWhiteListMerkleRoot(bytes32 _whiteListMerkleRoot)
2164         external
2165         onlyOwner
2166     {
2167         whiteListMerkleRoot = _whiteListMerkleRoot;
2168     }
2169 
2170     function setFreeMintMerkleRoot(bytes32 _freeMintMerkleRoot)
2171         external
2172         onlyOwner
2173     {
2174         freeMintMerkleRoot = _freeMintMerkleRoot;
2175     }
2176 
2177     function setMintStatus(
2178         bool _allowToWhitelistMint,
2179         bool _allowToFreeMint,
2180         bool _allowToPublicMint
2181     ) external onlyOwner {
2182         allowToWhitelistMint = _allowToWhitelistMint;
2183         allowToFreeMint = _allowToFreeMint;
2184         allowToPublicMint = _allowToPublicMint;
2185     }
2186 }