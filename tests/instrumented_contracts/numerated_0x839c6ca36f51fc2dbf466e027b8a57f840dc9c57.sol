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
13     function unregister(address addr) external;
14     function updateOperator(address registrant, address operator, bool filtered) external;
15     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
16     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
17     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
18     function subscribe(address registrant, address registrantToSubscribe) external;
19     function unsubscribe(address registrant, bool copyExistingEntries) external;
20     function subscriptionOf(address addr) external returns (address registrant);
21     function subscribers(address registrant) external returns (address[] memory);
22     function subscriberAt(address registrant, uint256 index) external returns (address);
23     function copyEntriesOf(address registrant, address registrantToCopy) external;
24     function isOperatorFiltered(address registrant, address operator) external returns (bool);
25     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
26     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
27     function filteredOperators(address addr) external returns (address[] memory);
28     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
29     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
30     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
31     function isRegistered(address addr) external returns (bool);
32     function codeHashOf(address addr) external returns (bytes32);
33 }
34 
35 // File: operator-filter-registry/src/OperatorFilterer.sol
36 
37 
38 pragma solidity ^0.8.13;
39 
40 
41 /**
42  * @title  OperatorFilterer
43  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
44  *         registrant's entries in the OperatorFilterRegistry.
45  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
46  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
47  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
48  */
49 abstract contract OperatorFilterer {
50     error OperatorNotAllowed(address operator);
51 
52     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
53         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
54 
55     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
56         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
57         // will not revert, but the contract will need to be registered with the registry once it is deployed in
58         // order for the modifier to filter addresses.
59         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
60             if (subscribe) {
61                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
62             } else {
63                 if (subscriptionOrRegistrantToCopy != address(0)) {
64                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
65                 } else {
66                     OPERATOR_FILTER_REGISTRY.register(address(this));
67                 }
68             }
69         }
70     }
71 
72     modifier onlyAllowedOperator(address from) virtual {
73         // Allow spending tokens from addresses with balance
74         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
75         // from an EOA.
76         if (from != msg.sender) {
77             _checkFilterOperator(msg.sender);
78         }
79         _;
80     }
81 
82     modifier onlyAllowedOperatorApproval(address operator) virtual {
83         _checkFilterOperator(operator);
84         _;
85     }
86 
87     function _checkFilterOperator(address operator) internal view virtual {
88         // Check registry code length to facilitate testing in environments without a deployed registry.
89         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
90             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
91                 revert OperatorNotAllowed(operator);
92             }
93         }
94     }
95 }
96 
97 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
98 
99 
100 pragma solidity ^0.8.13;
101 
102 
103 /**
104  * @title  DefaultOperatorFilterer
105  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
106  */
107 abstract contract DefaultOperatorFilterer is OperatorFilterer {
108     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
109 
110     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
111 }
112 
113 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev These functions deal with verification of Merkle Tree proofs.
122  *
123  * The tree and the proofs can be generated using our
124  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
125  * You will find a quickstart guide in the readme.
126  *
127  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
128  * hashing, or use a hash function other than keccak256 for hashing leaves.
129  * This is because the concatenation of a sorted pair of internal nodes in
130  * the merkle tree could be reinterpreted as a leaf value.
131  * OpenZeppelin's JavaScript library generates merkle trees that are safe
132  * against this attack out of the box.
133  */
134 library MerkleProof {
135     /**
136      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
137      * defined by `root`. For this, a `proof` must be provided, containing
138      * sibling hashes on the branch from the leaf to the root of the tree. Each
139      * pair of leaves and each pair of pre-images are assumed to be sorted.
140      */
141     function verify(
142         bytes32[] memory proof,
143         bytes32 root,
144         bytes32 leaf
145     ) internal pure returns (bool) {
146         return processProof(proof, leaf) == root;
147     }
148 
149     /**
150      * @dev Calldata version of {verify}
151      *
152      * _Available since v4.7._
153      */
154     function verifyCalldata(
155         bytes32[] calldata proof,
156         bytes32 root,
157         bytes32 leaf
158     ) internal pure returns (bool) {
159         return processProofCalldata(proof, leaf) == root;
160     }
161 
162     /**
163      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
164      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
165      * hash matches the root of the tree. When processing the proof, the pairs
166      * of leafs & pre-images are assumed to be sorted.
167      *
168      * _Available since v4.4._
169      */
170     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
171         bytes32 computedHash = leaf;
172         for (uint256 i = 0; i < proof.length; i++) {
173             computedHash = _hashPair(computedHash, proof[i]);
174         }
175         return computedHash;
176     }
177 
178     /**
179      * @dev Calldata version of {processProof}
180      *
181      * _Available since v4.7._
182      */
183     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
184         bytes32 computedHash = leaf;
185         for (uint256 i = 0; i < proof.length; i++) {
186             computedHash = _hashPair(computedHash, proof[i]);
187         }
188         return computedHash;
189     }
190 
191     /**
192      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
193      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
194      *
195      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
196      *
197      * _Available since v4.7._
198      */
199     function multiProofVerify(
200         bytes32[] memory proof,
201         bool[] memory proofFlags,
202         bytes32 root,
203         bytes32[] memory leaves
204     ) internal pure returns (bool) {
205         return processMultiProof(proof, proofFlags, leaves) == root;
206     }
207 
208     /**
209      * @dev Calldata version of {multiProofVerify}
210      *
211      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
212      *
213      * _Available since v4.7._
214      */
215     function multiProofVerifyCalldata(
216         bytes32[] calldata proof,
217         bool[] calldata proofFlags,
218         bytes32 root,
219         bytes32[] memory leaves
220     ) internal pure returns (bool) {
221         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
222     }
223 
224     /**
225      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
226      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
227      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
228      * respectively.
229      *
230      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
231      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
232      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
233      *
234      * _Available since v4.7._
235      */
236     function processMultiProof(
237         bytes32[] memory proof,
238         bool[] memory proofFlags,
239         bytes32[] memory leaves
240     ) internal pure returns (bytes32 merkleRoot) {
241         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
242         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
243         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
244         // the merkle tree.
245         uint256 leavesLen = leaves.length;
246         uint256 totalHashes = proofFlags.length;
247 
248         // Check proof validity.
249         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
250 
251         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
252         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
253         bytes32[] memory hashes = new bytes32[](totalHashes);
254         uint256 leafPos = 0;
255         uint256 hashPos = 0;
256         uint256 proofPos = 0;
257         // At each step, we compute the next hash using two values:
258         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
259         //   get the next hash.
260         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
261         //   `proof` array.
262         for (uint256 i = 0; i < totalHashes; i++) {
263             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
264             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
265             hashes[i] = _hashPair(a, b);
266         }
267 
268         if (totalHashes > 0) {
269             return hashes[totalHashes - 1];
270         } else if (leavesLen > 0) {
271             return leaves[0];
272         } else {
273             return proof[0];
274         }
275     }
276 
277     /**
278      * @dev Calldata version of {processMultiProof}.
279      *
280      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
281      *
282      * _Available since v4.7._
283      */
284     function processMultiProofCalldata(
285         bytes32[] calldata proof,
286         bool[] calldata proofFlags,
287         bytes32[] memory leaves
288     ) internal pure returns (bytes32 merkleRoot) {
289         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
290         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
291         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
292         // the merkle tree.
293         uint256 leavesLen = leaves.length;
294         uint256 totalHashes = proofFlags.length;
295 
296         // Check proof validity.
297         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
298 
299         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
300         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
301         bytes32[] memory hashes = new bytes32[](totalHashes);
302         uint256 leafPos = 0;
303         uint256 hashPos = 0;
304         uint256 proofPos = 0;
305         // At each step, we compute the next hash using two values:
306         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
307         //   get the next hash.
308         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
309         //   `proof` array.
310         for (uint256 i = 0; i < totalHashes; i++) {
311             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
312             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
313             hashes[i] = _hashPair(a, b);
314         }
315 
316         if (totalHashes > 0) {
317             return hashes[totalHashes - 1];
318         } else if (leavesLen > 0) {
319             return leaves[0];
320         } else {
321             return proof[0];
322         }
323     }
324 
325     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
326         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
327     }
328 
329     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
330         /// @solidity memory-safe-assembly
331         assembly {
332             mstore(0x00, a)
333             mstore(0x20, b)
334             value := keccak256(0x00, 0x40)
335         }
336     }
337 }
338 
339 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
340 
341 
342 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Contract module that helps prevent reentrant calls to a function.
348  *
349  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
350  * available, which can be applied to functions to make sure there are no nested
351  * (reentrant) calls to them.
352  *
353  * Note that because there is a single `nonReentrant` guard, functions marked as
354  * `nonReentrant` may not call one another. This can be worked around by making
355  * those functions `private`, and then adding `external` `nonReentrant` entry
356  * points to them.
357  *
358  * TIP: If you would like to learn more about reentrancy and alternative ways
359  * to protect against it, check out our blog post
360  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
361  */
362 abstract contract ReentrancyGuard {
363     // Booleans are more expensive than uint256 or any type that takes up a full
364     // word because each write operation emits an extra SLOAD to first read the
365     // slot's contents, replace the bits taken up by the boolean, and then write
366     // back. This is the compiler's defense against contract upgrades and
367     // pointer aliasing, and it cannot be disabled.
368 
369     // The values being non-zero value makes deployment a bit more expensive,
370     // but in exchange the refund on every call to nonReentrant will be lower in
371     // amount. Since refunds are capped to a percentage of the total
372     // transaction's gas, it is best to keep them low in cases like this one, to
373     // increase the likelihood of the full refund coming into effect.
374     uint256 private constant _NOT_ENTERED = 1;
375     uint256 private constant _ENTERED = 2;
376 
377     uint256 private _status;
378 
379     constructor() {
380         _status = _NOT_ENTERED;
381     }
382 
383     /**
384      * @dev Prevents a contract from calling itself, directly or indirectly.
385      * Calling a `nonReentrant` function from another `nonReentrant`
386      * function is not supported. It is possible to prevent this from happening
387      * by making the `nonReentrant` function external, and making it call a
388      * `private` function that does the actual work.
389      */
390     modifier nonReentrant() {
391         _nonReentrantBefore();
392         _;
393         _nonReentrantAfter();
394     }
395 
396     function _nonReentrantBefore() private {
397         // On the first call to nonReentrant, _status will be _NOT_ENTERED
398         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
399 
400         // Any calls to nonReentrant after this point will fail
401         _status = _ENTERED;
402     }
403 
404     function _nonReentrantAfter() private {
405         // By storing the original value once again, a refund is triggered (see
406         // https://eips.ethereum.org/EIPS/eip-2200)
407         _status = _NOT_ENTERED;
408     }
409 }
410 
411 // File: @openzeppelin/contracts/utils/Context.sol
412 
413 
414 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
415 
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @dev Provides information about the current execution context, including the
420  * sender of the transaction and its data. While these are generally available
421  * via msg.sender and msg.data, they should not be accessed in such a direct
422  * manner, since when dealing with meta-transactions the account sending and
423  * paying for execution may not be the actual sender (as far as an application
424  * is concerned).
425  *
426  * This contract is only required for intermediate, library-like contracts.
427  */
428 abstract contract Context {
429     function _msgSender() internal view virtual returns (address) {
430         return msg.sender;
431     }
432 
433     function _msgData() internal view virtual returns (bytes calldata) {
434         return msg.data;
435     }
436 }
437 
438 // File: @openzeppelin/contracts/access/Ownable.sol
439 
440 
441 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 
446 /**
447  * @dev Contract module which provides a basic access control mechanism, where
448  * there is an account (an owner) that can be granted exclusive access to
449  * specific functions.
450  *
451  * By default, the owner account will be the one that deploys the contract. This
452  * can later be changed with {transferOwnership}.
453  *
454  * This module is used through inheritance. It will make available the modifier
455  * `onlyOwner`, which can be applied to your functions to restrict their use to
456  * the owner.
457  */
458 abstract contract Ownable is Context {
459     address private _owner;
460 
461     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
462 
463     /**
464      * @dev Initializes the contract setting the deployer as the initial owner.
465      */
466     constructor() {
467         _transferOwnership(_msgSender());
468     }
469 
470     /**
471      * @dev Throws if called by any account other than the owner.
472      */
473     modifier onlyOwner() {
474         _checkOwner();
475         _;
476     }
477 
478     /**
479      * @dev Returns the address of the current owner.
480      */
481     function owner() public view virtual returns (address) {
482         return _owner;
483     }
484 
485     /**
486      * @dev Throws if the sender is not the owner.
487      */
488     function _checkOwner() internal view virtual {
489         require(owner() == _msgSender(), "Ownable: caller is not the owner");
490     }
491 
492     /**
493      * @dev Leaves the contract without owner. It will not be possible to call
494      * `onlyOwner` functions anymore. Can only be called by the current owner.
495      *
496      * NOTE: Renouncing ownership will leave the contract without an owner,
497      * thereby removing any functionality that is only available to the owner.
498      */
499     function renounceOwnership() public virtual onlyOwner {
500         _transferOwnership(address(0));
501     }
502 
503     /**
504      * @dev Transfers ownership of the contract to a new account (`newOwner`).
505      * Can only be called by the current owner.
506      */
507     function transferOwnership(address newOwner) public virtual onlyOwner {
508         require(newOwner != address(0), "Ownable: new owner is the zero address");
509         _transferOwnership(newOwner);
510     }
511 
512     /**
513      * @dev Transfers ownership of the contract to a new account (`newOwner`).
514      * Internal function without access restriction.
515      */
516     function _transferOwnership(address newOwner) internal virtual {
517         address oldOwner = _owner;
518         _owner = newOwner;
519         emit OwnershipTransferred(oldOwner, newOwner);
520     }
521 }
522 
523 // File: erc721a/contracts/IERC721A.sol
524 
525 
526 // ERC721A Contracts v4.2.3
527 // Creator: Chiru Labs
528 
529 pragma solidity ^0.8.4;
530 
531 /**
532  * @dev Interface of ERC721A.
533  */
534 interface IERC721A {
535     /**
536      * The caller must own the token or be an approved operator.
537      */
538     error ApprovalCallerNotOwnerNorApproved();
539 
540     /**
541      * The token does not exist.
542      */
543     error ApprovalQueryForNonexistentToken();
544 
545     /**
546      * Cannot query the balance for the zero address.
547      */
548     error BalanceQueryForZeroAddress();
549 
550     /**
551      * Cannot mint to the zero address.
552      */
553     error MintToZeroAddress();
554 
555     /**
556      * The quantity of tokens minted must be more than zero.
557      */
558     error MintZeroQuantity();
559 
560     /**
561      * The token does not exist.
562      */
563     error OwnerQueryForNonexistentToken();
564 
565     /**
566      * The caller must own the token or be an approved operator.
567      */
568     error TransferCallerNotOwnerNorApproved();
569 
570     /**
571      * The token must be owned by `from`.
572      */
573     error TransferFromIncorrectOwner();
574 
575     /**
576      * Cannot safely transfer to a contract that does not implement the
577      * ERC721Receiver interface.
578      */
579     error TransferToNonERC721ReceiverImplementer();
580 
581     /**
582      * Cannot transfer to the zero address.
583      */
584     error TransferToZeroAddress();
585 
586     /**
587      * The token does not exist.
588      */
589     error URIQueryForNonexistentToken();
590 
591     /**
592      * The `quantity` minted with ERC2309 exceeds the safety limit.
593      */
594     error MintERC2309QuantityExceedsLimit();
595 
596     /**
597      * The `extraData` cannot be set on an unintialized ownership slot.
598      */
599     error OwnershipNotInitializedForExtraData();
600 
601     // =============================================================
602     //                            STRUCTS
603     // =============================================================
604 
605     struct TokenOwnership {
606         // The address of the owner.
607         address addr;
608         // Stores the start time of ownership with minimal overhead for tokenomics.
609         uint64 startTimestamp;
610         // Whether the token has been burned.
611         bool burned;
612         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
613         uint24 extraData;
614     }
615 
616     // =============================================================
617     //                         TOKEN COUNTERS
618     // =============================================================
619 
620     /**
621      * @dev Returns the total number of tokens in existence.
622      * Burned tokens will reduce the count.
623      * To get the total number of tokens minted, please see {_totalMinted}.
624      */
625     function totalSupply() external view returns (uint256);
626 
627     // =============================================================
628     //                            IERC165
629     // =============================================================
630 
631     /**
632      * @dev Returns true if this contract implements the interface defined by
633      * `interfaceId`. See the corresponding
634      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
635      * to learn more about how these ids are created.
636      *
637      * This function call must use less than 30000 gas.
638      */
639     function supportsInterface(bytes4 interfaceId) external view returns (bool);
640 
641     // =============================================================
642     //                            IERC721
643     // =============================================================
644 
645     /**
646      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
647      */
648     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
649 
650     /**
651      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
652      */
653     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
654 
655     /**
656      * @dev Emitted when `owner` enables or disables
657      * (`approved`) `operator` to manage all of its assets.
658      */
659     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
660 
661     /**
662      * @dev Returns the number of tokens in `owner`'s account.
663      */
664     function balanceOf(address owner) external view returns (uint256 balance);
665 
666     /**
667      * @dev Returns the owner of the `tokenId` token.
668      *
669      * Requirements:
670      *
671      * - `tokenId` must exist.
672      */
673     function ownerOf(uint256 tokenId) external view returns (address owner);
674 
675     /**
676      * @dev Safely transfers `tokenId` token from `from` to `to`,
677      * checking first that contract recipients are aware of the ERC721 protocol
678      * to prevent tokens from being forever locked.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must exist and be owned by `from`.
685      * - If the caller is not `from`, it must be have been allowed to move
686      * this token by either {approve} or {setApprovalForAll}.
687      * - If `to` refers to a smart contract, it must implement
688      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
689      *
690      * Emits a {Transfer} event.
691      */
692     function safeTransferFrom(
693         address from,
694         address to,
695         uint256 tokenId,
696         bytes calldata data
697     ) external payable;
698 
699     /**
700      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
701      */
702     function safeTransferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) external payable;
707 
708     /**
709      * @dev Transfers `tokenId` from `from` to `to`.
710      *
711      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
712      * whenever possible.
713      *
714      * Requirements:
715      *
716      * - `from` cannot be the zero address.
717      * - `to` cannot be the zero address.
718      * - `tokenId` token must be owned by `from`.
719      * - If the caller is not `from`, it must be approved to move this token
720      * by either {approve} or {setApprovalForAll}.
721      *
722      * Emits a {Transfer} event.
723      */
724     function transferFrom(
725         address from,
726         address to,
727         uint256 tokenId
728     ) external payable;
729 
730     /**
731      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
732      * The approval is cleared when the token is transferred.
733      *
734      * Only a single account can be approved at a time, so approving the
735      * zero address clears previous approvals.
736      *
737      * Requirements:
738      *
739      * - The caller must own the token or be an approved operator.
740      * - `tokenId` must exist.
741      *
742      * Emits an {Approval} event.
743      */
744     function approve(address to, uint256 tokenId) external payable;
745 
746     /**
747      * @dev Approve or remove `operator` as an operator for the caller.
748      * Operators can call {transferFrom} or {safeTransferFrom}
749      * for any token owned by the caller.
750      *
751      * Requirements:
752      *
753      * - The `operator` cannot be the caller.
754      *
755      * Emits an {ApprovalForAll} event.
756      */
757     function setApprovalForAll(address operator, bool _approved) external;
758 
759     /**
760      * @dev Returns the account approved for `tokenId` token.
761      *
762      * Requirements:
763      *
764      * - `tokenId` must exist.
765      */
766     function getApproved(uint256 tokenId) external view returns (address operator);
767 
768     /**
769      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
770      *
771      * See {setApprovalForAll}.
772      */
773     function isApprovedForAll(address owner, address operator) external view returns (bool);
774 
775     // =============================================================
776     //                        IERC721Metadata
777     // =============================================================
778 
779     /**
780      * @dev Returns the token collection name.
781      */
782     function name() external view returns (string memory);
783 
784     /**
785      * @dev Returns the token collection symbol.
786      */
787     function symbol() external view returns (string memory);
788 
789     /**
790      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
791      */
792     function tokenURI(uint256 tokenId) external view returns (string memory);
793 
794     // =============================================================
795     //                           IERC2309
796     // =============================================================
797 
798     /**
799      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
800      * (inclusive) is transferred from `from` to `to`, as defined in the
801      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
802      *
803      * See {_mintERC2309} for more details.
804      */
805     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
806 }
807 
808 // File: erc721a/contracts/ERC721A.sol
809 
810 
811 // ERC721A Contracts v4.2.3
812 // Creator: Chiru Labs
813 
814 pragma solidity ^0.8.4;
815 
816 
817 /**
818  * @dev Interface of ERC721 token receiver.
819  */
820 interface ERC721A__IERC721Receiver {
821     function onERC721Received(
822         address operator,
823         address from,
824         uint256 tokenId,
825         bytes calldata data
826     ) external returns (bytes4);
827 }
828 
829 /**
830  * @title ERC721A
831  *
832  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
833  * Non-Fungible Token Standard, including the Metadata extension.
834  * Optimized for lower gas during batch mints.
835  *
836  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
837  * starting from `_startTokenId()`.
838  *
839  * Assumptions:
840  *
841  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
842  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
843  */
844 contract ERC721A is IERC721A {
845     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
846     struct TokenApprovalRef {
847         address value;
848     }
849 
850     // =============================================================
851     //                           CONSTANTS
852     // =============================================================
853 
854     // Mask of an entry in packed address data.
855     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
856 
857     // The bit position of `numberMinted` in packed address data.
858     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
859 
860     // The bit position of `numberBurned` in packed address data.
861     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
862 
863     // The bit position of `aux` in packed address data.
864     uint256 private constant _BITPOS_AUX = 192;
865 
866     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
867     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
868 
869     // The bit position of `startTimestamp` in packed ownership.
870     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
871 
872     // The bit mask of the `burned` bit in packed ownership.
873     uint256 private constant _BITMASK_BURNED = 1 << 224;
874 
875     // The bit position of the `nextInitialized` bit in packed ownership.
876     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
877 
878     // The bit mask of the `nextInitialized` bit in packed ownership.
879     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
880 
881     // The bit position of `extraData` in packed ownership.
882     uint256 private constant _BITPOS_EXTRA_DATA = 232;
883 
884     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
885     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
886 
887     // The mask of the lower 160 bits for addresses.
888     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
889 
890     // The maximum `quantity` that can be minted with {_mintERC2309}.
891     // This limit is to prevent overflows on the address data entries.
892     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
893     // is required to cause an overflow, which is unrealistic.
894     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
895 
896     // The `Transfer` event signature is given by:
897     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
898     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
899         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
900 
901     // =============================================================
902     //                            STORAGE
903     // =============================================================
904 
905     // The next token ID to be minted.
906     uint256 private _currentIndex;
907 
908     // The number of tokens burned.
909     uint256 private _burnCounter;
910 
911     // Token name
912     string private _name;
913 
914     // Token symbol
915     string private _symbol;
916 
917     // Mapping from token ID to ownership details
918     // An empty struct value does not necessarily mean the token is unowned.
919     // See {_packedOwnershipOf} implementation for details.
920     //
921     // Bits Layout:
922     // - [0..159]   `addr`
923     // - [160..223] `startTimestamp`
924     // - [224]      `burned`
925     // - [225]      `nextInitialized`
926     // - [232..255] `extraData`
927     mapping(uint256 => uint256) private _packedOwnerships;
928 
929     // Mapping owner address to address data.
930     //
931     // Bits Layout:
932     // - [0..63]    `balance`
933     // - [64..127]  `numberMinted`
934     // - [128..191] `numberBurned`
935     // - [192..255] `aux`
936     mapping(address => uint256) private _packedAddressData;
937 
938     // Mapping from token ID to approved address.
939     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
940 
941     // Mapping from owner to operator approvals
942     mapping(address => mapping(address => bool)) private _operatorApprovals;
943 
944     // =============================================================
945     //                          CONSTRUCTOR
946     // =============================================================
947 
948     constructor(string memory name_, string memory symbol_) {
949         _name = name_;
950         _symbol = symbol_;
951         _currentIndex = _startTokenId();
952     }
953 
954     // =============================================================
955     //                   TOKEN COUNTING OPERATIONS
956     // =============================================================
957 
958     /**
959      * @dev Returns the starting token ID.
960      * To change the starting token ID, please override this function.
961      */
962     function _startTokenId() internal view virtual returns (uint256) {
963         return 0;
964     }
965 
966     /**
967      * @dev Returns the next token ID to be minted.
968      */
969     function _nextTokenId() internal view virtual returns (uint256) {
970         return _currentIndex;
971     }
972 
973     /**
974      * @dev Returns the total number of tokens in existence.
975      * Burned tokens will reduce the count.
976      * To get the total number of tokens minted, please see {_totalMinted}.
977      */
978     function totalSupply() public view virtual override returns (uint256) {
979         // Counter underflow is impossible as _burnCounter cannot be incremented
980         // more than `_currentIndex - _startTokenId()` times.
981         unchecked {
982             return _currentIndex - _burnCounter - _startTokenId();
983         }
984     }
985 
986     /**
987      * @dev Returns the total amount of tokens minted in the contract.
988      */
989     function _totalMinted() internal view virtual returns (uint256) {
990         // Counter underflow is impossible as `_currentIndex` does not decrement,
991         // and it is initialized to `_startTokenId()`.
992         unchecked {
993             return _currentIndex - _startTokenId();
994         }
995     }
996 
997     /**
998      * @dev Returns the total number of tokens burned.
999      */
1000     function _totalBurned() internal view virtual returns (uint256) {
1001         return _burnCounter;
1002     }
1003 
1004     // =============================================================
1005     //                    ADDRESS DATA OPERATIONS
1006     // =============================================================
1007 
1008     /**
1009      * @dev Returns the number of tokens in `owner`'s account.
1010      */
1011     function balanceOf(address owner) public view virtual override returns (uint256) {
1012         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1013         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1014     }
1015 
1016     /**
1017      * Returns the number of tokens minted by `owner`.
1018      */
1019     function _numberMinted(address owner) internal view returns (uint256) {
1020         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1021     }
1022 
1023     /**
1024      * Returns the number of tokens burned by or on behalf of `owner`.
1025      */
1026     function _numberBurned(address owner) internal view returns (uint256) {
1027         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1028     }
1029 
1030     /**
1031      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1032      */
1033     function _getAux(address owner) internal view returns (uint64) {
1034         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1035     }
1036 
1037     /**
1038      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1039      * If there are multiple variables, please pack them into a uint64.
1040      */
1041     function _setAux(address owner, uint64 aux) internal virtual {
1042         uint256 packed = _packedAddressData[owner];
1043         uint256 auxCasted;
1044         // Cast `aux` with assembly to avoid redundant masking.
1045         assembly {
1046             auxCasted := aux
1047         }
1048         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1049         _packedAddressData[owner] = packed;
1050     }
1051 
1052     // =============================================================
1053     //                            IERC165
1054     // =============================================================
1055 
1056     /**
1057      * @dev Returns true if this contract implements the interface defined by
1058      * `interfaceId`. See the corresponding
1059      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1060      * to learn more about how these ids are created.
1061      *
1062      * This function call must use less than 30000 gas.
1063      */
1064     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1065         // The interface IDs are constants representing the first 4 bytes
1066         // of the XOR of all function selectors in the interface.
1067         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1068         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1069         return
1070             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1071             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1072             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1073     }
1074 
1075     // =============================================================
1076     //                        IERC721Metadata
1077     // =============================================================
1078 
1079     /**
1080      * @dev Returns the token collection name.
1081      */
1082     function name() public view virtual override returns (string memory) {
1083         return _name;
1084     }
1085 
1086     /**
1087      * @dev Returns the token collection symbol.
1088      */
1089     function symbol() public view virtual override returns (string memory) {
1090         return _symbol;
1091     }
1092 
1093     /**
1094      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1095      */
1096     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1097         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1098 
1099         string memory baseURI = _baseURI();
1100         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1101     }
1102 
1103     /**
1104      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1105      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1106      * by default, it can be overridden in child contracts.
1107      */
1108     function _baseURI() internal view virtual returns (string memory) {
1109         return '';
1110     }
1111 
1112     // =============================================================
1113     //                     OWNERSHIPS OPERATIONS
1114     // =============================================================
1115 
1116     /**
1117      * @dev Returns the owner of the `tokenId` token.
1118      *
1119      * Requirements:
1120      *
1121      * - `tokenId` must exist.
1122      */
1123     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1124         return address(uint160(_packedOwnershipOf(tokenId)));
1125     }
1126 
1127     /**
1128      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1129      * It gradually moves to O(1) as tokens get transferred around over time.
1130      */
1131     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1132         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1133     }
1134 
1135     /**
1136      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1137      */
1138     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1139         return _unpackedOwnership(_packedOwnerships[index]);
1140     }
1141 
1142     /**
1143      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1144      */
1145     function _initializeOwnershipAt(uint256 index) internal virtual {
1146         if (_packedOwnerships[index] == 0) {
1147             _packedOwnerships[index] = _packedOwnershipOf(index);
1148         }
1149     }
1150 
1151     /**
1152      * Returns the packed ownership data of `tokenId`.
1153      */
1154     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1155         uint256 curr = tokenId;
1156 
1157         unchecked {
1158             if (_startTokenId() <= curr)
1159                 if (curr < _currentIndex) {
1160                     uint256 packed = _packedOwnerships[curr];
1161                     // If not burned.
1162                     if (packed & _BITMASK_BURNED == 0) {
1163                         // Invariant:
1164                         // There will always be an initialized ownership slot
1165                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1166                         // before an unintialized ownership slot
1167                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1168                         // Hence, `curr` will not underflow.
1169                         //
1170                         // We can directly compare the packed value.
1171                         // If the address is zero, packed will be zero.
1172                         while (packed == 0) {
1173                             packed = _packedOwnerships[--curr];
1174                         }
1175                         return packed;
1176                     }
1177                 }
1178         }
1179         revert OwnerQueryForNonexistentToken();
1180     }
1181 
1182     /**
1183      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1184      */
1185     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1186         ownership.addr = address(uint160(packed));
1187         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1188         ownership.burned = packed & _BITMASK_BURNED != 0;
1189         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1190     }
1191 
1192     /**
1193      * @dev Packs ownership data into a single uint256.
1194      */
1195     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1196         assembly {
1197             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1198             owner := and(owner, _BITMASK_ADDRESS)
1199             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1200             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1201         }
1202     }
1203 
1204     /**
1205      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1206      */
1207     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1208         // For branchless setting of the `nextInitialized` flag.
1209         assembly {
1210             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1211             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1212         }
1213     }
1214 
1215     // =============================================================
1216     //                      APPROVAL OPERATIONS
1217     // =============================================================
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
1233     function approve(address to, uint256 tokenId) public payable virtual override {
1234         address owner = ownerOf(tokenId);
1235 
1236         if (_msgSenderERC721A() != owner)
1237             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1238                 revert ApprovalCallerNotOwnerNorApproved();
1239             }
1240 
1241         _tokenApprovals[tokenId].value = to;
1242         emit Approval(owner, to, tokenId);
1243     }
1244 
1245     /**
1246      * @dev Returns the account approved for `tokenId` token.
1247      *
1248      * Requirements:
1249      *
1250      * - `tokenId` must exist.
1251      */
1252     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1253         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1254 
1255         return _tokenApprovals[tokenId].value;
1256     }
1257 
1258     /**
1259      * @dev Approve or remove `operator` as an operator for the caller.
1260      * Operators can call {transferFrom} or {safeTransferFrom}
1261      * for any token owned by the caller.
1262      *
1263      * Requirements:
1264      *
1265      * - The `operator` cannot be the caller.
1266      *
1267      * Emits an {ApprovalForAll} event.
1268      */
1269     function setApprovalForAll(address operator, bool approved) public virtual override {
1270         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1271         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1272     }
1273 
1274     /**
1275      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1276      *
1277      * See {setApprovalForAll}.
1278      */
1279     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1280         return _operatorApprovals[owner][operator];
1281     }
1282 
1283     /**
1284      * @dev Returns whether `tokenId` exists.
1285      *
1286      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1287      *
1288      * Tokens start existing when they are minted. See {_mint}.
1289      */
1290     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1291         return
1292             _startTokenId() <= tokenId &&
1293             tokenId < _currentIndex && // If within bounds,
1294             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1295     }
1296 
1297     /**
1298      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1299      */
1300     function _isSenderApprovedOrOwner(
1301         address approvedAddress,
1302         address owner,
1303         address msgSender
1304     ) private pure returns (bool result) {
1305         assembly {
1306             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1307             owner := and(owner, _BITMASK_ADDRESS)
1308             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1309             msgSender := and(msgSender, _BITMASK_ADDRESS)
1310             // `msgSender == owner || msgSender == approvedAddress`.
1311             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1312         }
1313     }
1314 
1315     /**
1316      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1317      */
1318     function _getApprovedSlotAndAddress(uint256 tokenId)
1319         private
1320         view
1321         returns (uint256 approvedAddressSlot, address approvedAddress)
1322     {
1323         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1324         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1325         assembly {
1326             approvedAddressSlot := tokenApproval.slot
1327             approvedAddress := sload(approvedAddressSlot)
1328         }
1329     }
1330 
1331     // =============================================================
1332     //                      TRANSFER OPERATIONS
1333     // =============================================================
1334 
1335     /**
1336      * @dev Transfers `tokenId` from `from` to `to`.
1337      *
1338      * Requirements:
1339      *
1340      * - `from` cannot be the zero address.
1341      * - `to` cannot be the zero address.
1342      * - `tokenId` token must be owned by `from`.
1343      * - If the caller is not `from`, it must be approved to move this token
1344      * by either {approve} or {setApprovalForAll}.
1345      *
1346      * Emits a {Transfer} event.
1347      */
1348     function transferFrom(
1349         address from,
1350         address to,
1351         uint256 tokenId
1352     ) public payable virtual override {
1353         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1354 
1355         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1356 
1357         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1358 
1359         // The nested ifs save around 20+ gas over a compound boolean condition.
1360         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1361             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1362 
1363         if (to == address(0)) revert TransferToZeroAddress();
1364 
1365         _beforeTokenTransfers(from, to, tokenId, 1);
1366 
1367         // Clear approvals from the previous owner.
1368         assembly {
1369             if approvedAddress {
1370                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1371                 sstore(approvedAddressSlot, 0)
1372             }
1373         }
1374 
1375         // Underflow of the sender's balance is impossible because we check for
1376         // ownership above and the recipient's balance can't realistically overflow.
1377         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1378         unchecked {
1379             // We can directly increment and decrement the balances.
1380             --_packedAddressData[from]; // Updates: `balance -= 1`.
1381             ++_packedAddressData[to]; // Updates: `balance += 1`.
1382 
1383             // Updates:
1384             // - `address` to the next owner.
1385             // - `startTimestamp` to the timestamp of transfering.
1386             // - `burned` to `false`.
1387             // - `nextInitialized` to `true`.
1388             _packedOwnerships[tokenId] = _packOwnershipData(
1389                 to,
1390                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1391             );
1392 
1393             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1394             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1395                 uint256 nextTokenId = tokenId + 1;
1396                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1397                 if (_packedOwnerships[nextTokenId] == 0) {
1398                     // If the next slot is within bounds.
1399                     if (nextTokenId != _currentIndex) {
1400                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1401                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1402                     }
1403                 }
1404             }
1405         }
1406 
1407         emit Transfer(from, to, tokenId);
1408         _afterTokenTransfers(from, to, tokenId, 1);
1409     }
1410 
1411     /**
1412      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1413      */
1414     function safeTransferFrom(
1415         address from,
1416         address to,
1417         uint256 tokenId
1418     ) public payable virtual override {
1419         safeTransferFrom(from, to, tokenId, '');
1420     }
1421 
1422     /**
1423      * @dev Safely transfers `tokenId` token from `from` to `to`.
1424      *
1425      * Requirements:
1426      *
1427      * - `from` cannot be the zero address.
1428      * - `to` cannot be the zero address.
1429      * - `tokenId` token must exist and be owned by `from`.
1430      * - If the caller is not `from`, it must be approved to move this token
1431      * by either {approve} or {setApprovalForAll}.
1432      * - If `to` refers to a smart contract, it must implement
1433      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1434      *
1435      * Emits a {Transfer} event.
1436      */
1437     function safeTransferFrom(
1438         address from,
1439         address to,
1440         uint256 tokenId,
1441         bytes memory _data
1442     ) public payable virtual override {
1443         transferFrom(from, to, tokenId);
1444         if (to.code.length != 0)
1445             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1446                 revert TransferToNonERC721ReceiverImplementer();
1447             }
1448     }
1449 
1450     /**
1451      * @dev Hook that is called before a set of serially-ordered token IDs
1452      * are about to be transferred. This includes minting.
1453      * And also called before burning one token.
1454      *
1455      * `startTokenId` - the first token ID to be transferred.
1456      * `quantity` - the amount to be transferred.
1457      *
1458      * Calling conditions:
1459      *
1460      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1461      * transferred to `to`.
1462      * - When `from` is zero, `tokenId` will be minted for `to`.
1463      * - When `to` is zero, `tokenId` will be burned by `from`.
1464      * - `from` and `to` are never both zero.
1465      */
1466     function _beforeTokenTransfers(
1467         address from,
1468         address to,
1469         uint256 startTokenId,
1470         uint256 quantity
1471     ) internal virtual {}
1472 
1473     /**
1474      * @dev Hook that is called after a set of serially-ordered token IDs
1475      * have been transferred. This includes minting.
1476      * And also called after one token has been burned.
1477      *
1478      * `startTokenId` - the first token ID to be transferred.
1479      * `quantity` - the amount to be transferred.
1480      *
1481      * Calling conditions:
1482      *
1483      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1484      * transferred to `to`.
1485      * - When `from` is zero, `tokenId` has been minted for `to`.
1486      * - When `to` is zero, `tokenId` has been burned by `from`.
1487      * - `from` and `to` are never both zero.
1488      */
1489     function _afterTokenTransfers(
1490         address from,
1491         address to,
1492         uint256 startTokenId,
1493         uint256 quantity
1494     ) internal virtual {}
1495 
1496     /**
1497      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1498      *
1499      * `from` - Previous owner of the given token ID.
1500      * `to` - Target address that will receive the token.
1501      * `tokenId` - Token ID to be transferred.
1502      * `_data` - Optional data to send along with the call.
1503      *
1504      * Returns whether the call correctly returned the expected magic value.
1505      */
1506     function _checkContractOnERC721Received(
1507         address from,
1508         address to,
1509         uint256 tokenId,
1510         bytes memory _data
1511     ) private returns (bool) {
1512         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1513             bytes4 retval
1514         ) {
1515             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1516         } catch (bytes memory reason) {
1517             if (reason.length == 0) {
1518                 revert TransferToNonERC721ReceiverImplementer();
1519             } else {
1520                 assembly {
1521                     revert(add(32, reason), mload(reason))
1522                 }
1523             }
1524         }
1525     }
1526 
1527     // =============================================================
1528     //                        MINT OPERATIONS
1529     // =============================================================
1530 
1531     /**
1532      * @dev Mints `quantity` tokens and transfers them to `to`.
1533      *
1534      * Requirements:
1535      *
1536      * - `to` cannot be the zero address.
1537      * - `quantity` must be greater than 0.
1538      *
1539      * Emits a {Transfer} event for each mint.
1540      */
1541     function _mint(address to, uint256 quantity) internal virtual {
1542         uint256 startTokenId = _currentIndex;
1543         if (quantity == 0) revert MintZeroQuantity();
1544 
1545         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1546 
1547         // Overflows are incredibly unrealistic.
1548         // `balance` and `numberMinted` have a maximum limit of 2**64.
1549         // `tokenId` has a maximum limit of 2**256.
1550         unchecked {
1551             // Updates:
1552             // - `balance += quantity`.
1553             // - `numberMinted += quantity`.
1554             //
1555             // We can directly add to the `balance` and `numberMinted`.
1556             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1557 
1558             // Updates:
1559             // - `address` to the owner.
1560             // - `startTimestamp` to the timestamp of minting.
1561             // - `burned` to `false`.
1562             // - `nextInitialized` to `quantity == 1`.
1563             _packedOwnerships[startTokenId] = _packOwnershipData(
1564                 to,
1565                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1566             );
1567 
1568             uint256 toMasked;
1569             uint256 end = startTokenId + quantity;
1570 
1571             // Use assembly to loop and emit the `Transfer` event for gas savings.
1572             // The duplicated `log4` removes an extra check and reduces stack juggling.
1573             // The assembly, together with the surrounding Solidity code, have been
1574             // delicately arranged to nudge the compiler into producing optimized opcodes.
1575             assembly {
1576                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1577                 toMasked := and(to, _BITMASK_ADDRESS)
1578                 // Emit the `Transfer` event.
1579                 log4(
1580                     0, // Start of data (0, since no data).
1581                     0, // End of data (0, since no data).
1582                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1583                     0, // `address(0)`.
1584                     toMasked, // `to`.
1585                     startTokenId // `tokenId`.
1586                 )
1587 
1588                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1589                 // that overflows uint256 will make the loop run out of gas.
1590                 // The compiler will optimize the `iszero` away for performance.
1591                 for {
1592                     let tokenId := add(startTokenId, 1)
1593                 } iszero(eq(tokenId, end)) {
1594                     tokenId := add(tokenId, 1)
1595                 } {
1596                     // Emit the `Transfer` event. Similar to above.
1597                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1598                 }
1599             }
1600             if (toMasked == 0) revert MintToZeroAddress();
1601 
1602             _currentIndex = end;
1603         }
1604         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1605     }
1606 
1607     /**
1608      * @dev Mints `quantity` tokens and transfers them to `to`.
1609      *
1610      * This function is intended for efficient minting only during contract creation.
1611      *
1612      * It emits only one {ConsecutiveTransfer} as defined in
1613      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1614      * instead of a sequence of {Transfer} event(s).
1615      *
1616      * Calling this function outside of contract creation WILL make your contract
1617      * non-compliant with the ERC721 standard.
1618      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1619      * {ConsecutiveTransfer} event is only permissible during contract creation.
1620      *
1621      * Requirements:
1622      *
1623      * - `to` cannot be the zero address.
1624      * - `quantity` must be greater than 0.
1625      *
1626      * Emits a {ConsecutiveTransfer} event.
1627      */
1628     function _mintERC2309(address to, uint256 quantity) internal virtual {
1629         uint256 startTokenId = _currentIndex;
1630         if (to == address(0)) revert MintToZeroAddress();
1631         if (quantity == 0) revert MintZeroQuantity();
1632         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1633 
1634         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1635 
1636         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1637         unchecked {
1638             // Updates:
1639             // - `balance += quantity`.
1640             // - `numberMinted += quantity`.
1641             //
1642             // We can directly add to the `balance` and `numberMinted`.
1643             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1644 
1645             // Updates:
1646             // - `address` to the owner.
1647             // - `startTimestamp` to the timestamp of minting.
1648             // - `burned` to `false`.
1649             // - `nextInitialized` to `quantity == 1`.
1650             _packedOwnerships[startTokenId] = _packOwnershipData(
1651                 to,
1652                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1653             );
1654 
1655             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1656 
1657             _currentIndex = startTokenId + quantity;
1658         }
1659         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1660     }
1661 
1662     /**
1663      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1664      *
1665      * Requirements:
1666      *
1667      * - If `to` refers to a smart contract, it must implement
1668      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1669      * - `quantity` must be greater than 0.
1670      *
1671      * See {_mint}.
1672      *
1673      * Emits a {Transfer} event for each mint.
1674      */
1675     function _safeMint(
1676         address to,
1677         uint256 quantity,
1678         bytes memory _data
1679     ) internal virtual {
1680         _mint(to, quantity);
1681 
1682         unchecked {
1683             if (to.code.length != 0) {
1684                 uint256 end = _currentIndex;
1685                 uint256 index = end - quantity;
1686                 do {
1687                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1688                         revert TransferToNonERC721ReceiverImplementer();
1689                     }
1690                 } while (index < end);
1691                 // Reentrancy protection.
1692                 if (_currentIndex != end) revert();
1693             }
1694         }
1695     }
1696 
1697     /**
1698      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1699      */
1700     function _safeMint(address to, uint256 quantity) internal virtual {
1701         _safeMint(to, quantity, '');
1702     }
1703 
1704     // =============================================================
1705     //                        BURN OPERATIONS
1706     // =============================================================
1707 
1708     /**
1709      * @dev Equivalent to `_burn(tokenId, false)`.
1710      */
1711     function _burn(uint256 tokenId) internal virtual {
1712         _burn(tokenId, false);
1713     }
1714 
1715     /**
1716      * @dev Destroys `tokenId`.
1717      * The approval is cleared when the token is burned.
1718      *
1719      * Requirements:
1720      *
1721      * - `tokenId` must exist.
1722      *
1723      * Emits a {Transfer} event.
1724      */
1725     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1726         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1727 
1728         address from = address(uint160(prevOwnershipPacked));
1729 
1730         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1731 
1732         if (approvalCheck) {
1733             // The nested ifs save around 20+ gas over a compound boolean condition.
1734             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1735                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1736         }
1737 
1738         _beforeTokenTransfers(from, address(0), tokenId, 1);
1739 
1740         // Clear approvals from the previous owner.
1741         assembly {
1742             if approvedAddress {
1743                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1744                 sstore(approvedAddressSlot, 0)
1745             }
1746         }
1747 
1748         // Underflow of the sender's balance is impossible because we check for
1749         // ownership above and the recipient's balance can't realistically overflow.
1750         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1751         unchecked {
1752             // Updates:
1753             // - `balance -= 1`.
1754             // - `numberBurned += 1`.
1755             //
1756             // We can directly decrement the balance, and increment the number burned.
1757             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1758             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1759 
1760             // Updates:
1761             // - `address` to the last owner.
1762             // - `startTimestamp` to the timestamp of burning.
1763             // - `burned` to `true`.
1764             // - `nextInitialized` to `true`.
1765             _packedOwnerships[tokenId] = _packOwnershipData(
1766                 from,
1767                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1768             );
1769 
1770             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1771             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1772                 uint256 nextTokenId = tokenId + 1;
1773                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1774                 if (_packedOwnerships[nextTokenId] == 0) {
1775                     // If the next slot is within bounds.
1776                     if (nextTokenId != _currentIndex) {
1777                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1778                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1779                     }
1780                 }
1781             }
1782         }
1783 
1784         emit Transfer(from, address(0), tokenId);
1785         _afterTokenTransfers(from, address(0), tokenId, 1);
1786 
1787         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1788         unchecked {
1789             _burnCounter++;
1790         }
1791     }
1792 
1793     // =============================================================
1794     //                     EXTRA DATA OPERATIONS
1795     // =============================================================
1796 
1797     /**
1798      * @dev Directly sets the extra data for the ownership data `index`.
1799      */
1800     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1801         uint256 packed = _packedOwnerships[index];
1802         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1803         uint256 extraDataCasted;
1804         // Cast `extraData` with assembly to avoid redundant masking.
1805         assembly {
1806             extraDataCasted := extraData
1807         }
1808         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1809         _packedOwnerships[index] = packed;
1810     }
1811 
1812     /**
1813      * @dev Called during each token transfer to set the 24bit `extraData` field.
1814      * Intended to be overridden by the cosumer contract.
1815      *
1816      * `previousExtraData` - the value of `extraData` before transfer.
1817      *
1818      * Calling conditions:
1819      *
1820      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1821      * transferred to `to`.
1822      * - When `from` is zero, `tokenId` will be minted for `to`.
1823      * - When `to` is zero, `tokenId` will be burned by `from`.
1824      * - `from` and `to` are never both zero.
1825      */
1826     function _extraData(
1827         address from,
1828         address to,
1829         uint24 previousExtraData
1830     ) internal view virtual returns (uint24) {}
1831 
1832     /**
1833      * @dev Returns the next extra data for the packed ownership data.
1834      * The returned result is shifted into position.
1835      */
1836     function _nextExtraData(
1837         address from,
1838         address to,
1839         uint256 prevOwnershipPacked
1840     ) private view returns (uint256) {
1841         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1842         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1843     }
1844 
1845     // =============================================================
1846     //                       OTHER OPERATIONS
1847     // =============================================================
1848 
1849     /**
1850      * @dev Returns the message sender (defaults to `msg.sender`).
1851      *
1852      * If you are writing GSN compatible contracts, you need to override this function.
1853      */
1854     function _msgSenderERC721A() internal view virtual returns (address) {
1855         return msg.sender;
1856     }
1857 
1858     /**
1859      * @dev Converts a uint256 to its ASCII string decimal representation.
1860      */
1861     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1862         assembly {
1863             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1864             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1865             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1866             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1867             let m := add(mload(0x40), 0xa0)
1868             // Update the free memory pointer to allocate.
1869             mstore(0x40, m)
1870             // Assign the `str` to the end.
1871             str := sub(m, 0x20)
1872             // Zeroize the slot after the string.
1873             mstore(str, 0)
1874 
1875             // Cache the end of the memory to calculate the length later.
1876             let end := str
1877 
1878             // We write the string from rightmost digit to leftmost digit.
1879             // The following is essentially a do-while loop that also handles the zero case.
1880             // prettier-ignore
1881             for { let temp := value } 1 {} {
1882                 str := sub(str, 1)
1883                 // Write the character to the pointer.
1884                 // The ASCII index of the '0' character is 48.
1885                 mstore8(str, add(48, mod(temp, 10)))
1886                 // Keep dividing `temp` until zero.
1887                 temp := div(temp, 10)
1888                 // prettier-ignore
1889                 if iszero(temp) { break }
1890             }
1891 
1892             let length := sub(end, str)
1893             // Move the pointer 32 bytes leftwards to make room for the length.
1894             str := sub(str, 0x20)
1895             // Store the length.
1896             mstore(str, length)
1897         }
1898     }
1899 }
1900 
1901 // File: contracts/ProjectFox.sol
1902 
1903 
1904 
1905 //Developer : FazelPejmanfar , Twitter :@Pejmanfarfazel
1906 
1907 
1908 
1909 pragma solidity >=0.7.0 <0.9.0;
1910 
1911 
1912 
1913 
1914 
1915 
1916 contract ProjectFox is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer   {
1917 
1918 
1919   string public baseURI;
1920   string public notRevealedUri;
1921   uint256 public cost = 0.0089 ether;
1922   uint256 public wlcost = 0.0069 ether;
1923   uint256 public maxSupply = 3300;
1924   uint256 public WlSupply = 1000;
1925   uint256 public teamreserve = 120;
1926   uint256 public MaxperWallet = 5;
1927   uint256 public MaxperWalletWl = 2;
1928   bool public paused = false;
1929   bool public revealed = false;
1930   bool public preSale = true;
1931   bytes32 public merkleRoot;
1932   mapping (address => uint256) public PublicMintofUser;
1933   mapping (address => uint256) public WhitelistedMintofUser;
1934   uint256 public teamminted;
1935 
1936   constructor(
1937     string memory _initBaseURI,
1938     string memory _notRevealedUri
1939   ) ERC721A("Project Fox", "FOX") {
1940     setBaseURI(_initBaseURI);
1941     setNotRevealedURI(_notRevealedUri);
1942   }
1943 
1944   // internal
1945   function _baseURI() internal view virtual override returns (string memory) {
1946     return baseURI;
1947   }
1948       function _startTokenId() internal view virtual override returns (uint256) {
1949         return 1;
1950     }
1951 
1952   // public
1953   /// @dev Public mint 
1954   function mint(uint256 tokens) public payable nonReentrant {
1955     require(!paused, "FOX: oops contract is paused");
1956     require(!preSale, "FOX: Sale Hasn't started yet");
1957     require(tokens <= MaxperWallet, "FOX: max mint amount per tx exceeded");
1958     require(totalSupply() + tokens <= maxSupply, "FOX: We Soldout");
1959     require(PublicMintofUser[_msgSenderERC721A()] + tokens <= MaxperWallet, "FOX: Max NFT Per Wallet exceeded");
1960     require(msg.value >= cost * tokens, "FOX: insufficient funds");
1961 
1962        PublicMintofUser[_msgSenderERC721A()] += tokens;
1963       _safeMint(_msgSenderERC721A(), tokens);
1964     
1965   }
1966 /// @dev presale mint for whitelisted
1967     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public payable nonReentrant {
1968     require(!paused, "FOX: oops contract is paused");
1969     require(preSale, "FOX: Presale Hasn't started yet");
1970     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "FOX: You are not Whitelisted");
1971     require(WhitelistedMintofUser[_msgSenderERC721A()] + tokens <= MaxperWalletWl, "FOX: Max NFT Per Wallet exceeded");
1972     require(tokens <= MaxperWalletWl, "FOX: max mint per Tx exceeded");
1973     require(totalSupply() + tokens <= WlSupply, "FOX: Whitelist MaxSupply exceeded");
1974     require(msg.value >= wlcost * tokens, "FOX: insufficient funds");
1975 
1976        WhitelistedMintofUser[_msgSenderERC721A()] += tokens;
1977       _safeMint(_msgSenderERC721A(), tokens);
1978     
1979   }
1980 
1981   /// @dev use it for giveaway and team mint
1982      function airdrop(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
1983     require(teamminted + _mintAmount <= teamreserve, "max NFT limit exceeded");
1984           teamminted += _mintAmount;
1985       _safeMint(destination, _mintAmount);
1986   }
1987 
1988 /// @notice returns metadata link of tokenid
1989   function tokenURI(uint256 tokenId)
1990     public
1991     view
1992     virtual
1993     override
1994     returns (string memory)
1995   {
1996     require(
1997       _exists(tokenId),
1998       "ERC721AMetadata: URI query for nonexistent token"
1999     );
2000     
2001     if(revealed == false) {
2002         return notRevealedUri;
2003     }
2004 
2005     string memory currentBaseURI = _baseURI();
2006     return bytes(currentBaseURI).length > 0
2007         ? string(abi.encodePacked(currentBaseURI, _toString(tokenId), ".json"))
2008         : "";
2009   }
2010 
2011      /// @notice return the number minted by an address
2012     function numberMinted(address owner) public view returns (uint256) {
2013     return _numberMinted(owner);
2014   }
2015 
2016     /// @notice return the tokens owned by an address
2017       function tokensOfOwner(address owner) public view returns (uint256[] memory) {
2018         unchecked {
2019             uint256 tokenIdsIdx;
2020             address currOwnershipAddr;
2021             uint256 tokenIdsLength = balanceOf(owner);
2022             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2023             TokenOwnership memory ownership;
2024             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2025                 ownership = _ownershipAt(i);
2026                 if (ownership.burned) {
2027                     continue;
2028                 }
2029                 if (ownership.addr != address(0)) {
2030                     currOwnershipAddr = ownership.addr;
2031                 }
2032                 if (currOwnershipAddr == owner) {
2033                     tokenIds[tokenIdsIdx++] = i;
2034                 }
2035             }
2036             return tokenIds;
2037         }
2038     }
2039 
2040   //only owner
2041   function reveal(bool _state) public onlyOwner {
2042       revealed = _state;
2043   }
2044 
2045     /// @dev change the merkle root for the whitelist phase
2046   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2047         merkleRoot = _merkleRoot;
2048     }
2049 
2050   /// @dev change the public max per wallet
2051   function setMaxPerWallet(uint256 _limit) public onlyOwner {
2052     MaxperWallet = _limit;
2053   }
2054 
2055   /// @dev change the whitelist max per wallet
2056     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
2057     MaxperWalletWl = _limit;
2058   }
2059 
2060    /// @dev change the public price(amount need to be in wei)
2061   function setCost(uint256 _newCost) public onlyOwner {
2062     cost = _newCost;
2063   }
2064 
2065    /// @dev change the whitelist price(amount need to be in wei)
2066     function setWlCost(uint256 _newWlCost) public onlyOwner {
2067     wlcost = _newWlCost;
2068   }
2069 
2070   /// @dev cut the supply if we dont sold out
2071     function setMaxsupply(uint256 _newsupply) public onlyOwner {
2072     maxSupply = _newsupply;
2073   }
2074 
2075  /// @dev cut the whitelist supply if we dont sold out
2076     function setwlsupply(uint256 _newsupply) public onlyOwner {
2077     WlSupply = _newsupply;
2078   }
2079 
2080  /// @dev set your baseuri
2081   function setBaseURI(string memory _newBaseURI) public onlyOwner {
2082     baseURI = _newBaseURI;
2083   }
2084 
2085    /// @dev set hidden uri
2086   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2087     notRevealedUri = _notRevealedURI;
2088   }
2089 
2090  /// @dev to pause and unpause your contract(use booleans true or false)
2091   function pause(bool _state) public onlyOwner {
2092     paused = _state;
2093   }
2094 
2095      /// @dev activate whitelist sale(use booleans true or false)
2096     function togglepreSale(bool _state) external onlyOwner {
2097         preSale = _state;
2098     }
2099 
2100   
2101   /// @dev withdraw funds from contract
2102   function withdraw() public payable onlyOwner nonReentrant {
2103       uint256 balance = address(this).balance;
2104       payable(_msgSenderERC721A()).transfer(balance);
2105   }
2106 
2107 
2108   /// Opensea Royalties
2109 
2110     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2111     super.transferFrom(from, to, tokenId);
2112   }
2113 
2114   function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2115     super.safeTransferFrom(from, to, tokenId);
2116   }
2117 
2118   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
2119     super.safeTransferFrom(from, to, tokenId, data);
2120   }  
2121 }