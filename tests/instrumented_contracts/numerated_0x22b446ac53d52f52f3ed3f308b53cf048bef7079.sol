1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
3 
4 
5 pragma solidity ^0.8.13;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
9     function register(address registrant) external;
10     function registerAndSubscribe(address registrant, address subscription) external;
11     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
12     function unregister(address addr) external;
13     function updateOperator(address registrant, address operator, bool filtered) external;
14     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
15     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
16     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
17     function subscribe(address registrant, address registrantToSubscribe) external;
18     function unsubscribe(address registrant, bool copyExistingEntries) external;
19     function subscriptionOf(address addr) external returns (address registrant);
20     function subscribers(address registrant) external returns (address[] memory);
21     function subscriberAt(address registrant, uint256 index) external returns (address);
22     function copyEntriesOf(address registrant, address registrantToCopy) external;
23     function isOperatorFiltered(address registrant, address operator) external returns (bool);
24     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
25     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
26     function filteredOperators(address addr) external returns (address[] memory);
27     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
28     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
29     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
30     function isRegistered(address addr) external returns (bool);
31     function codeHashOf(address addr) external returns (bytes32);
32 }
33 
34 // File: operator-filter-registry/src/OperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 /**
41  * @title  OperatorFilterer
42  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
43  *         registrant's entries in the OperatorFilterRegistry.
44  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
45  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
46  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
47  */
48 abstract contract OperatorFilterer {
49     error OperatorNotAllowed(address operator);
50 
51     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
52         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
53 
54     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
55         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
56         // will not revert, but the contract will need to be registered with the registry once it is deployed in
57         // order for the modifier to filter addresses.
58         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
59             if (subscribe) {
60                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
61             } else {
62                 if (subscriptionOrRegistrantToCopy != address(0)) {
63                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
64                 } else {
65                     OPERATOR_FILTER_REGISTRY.register(address(this));
66                 }
67             }
68         }
69     }
70 
71     modifier onlyAllowedOperator(address from) virtual {
72         // Allow spending tokens from addresses with balance
73         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
74         // from an EOA.
75         if (from != msg.sender) {
76             _checkFilterOperator(msg.sender);
77         }
78         _;
79     }
80 
81     modifier onlyAllowedOperatorApproval(address operator) virtual {
82         _checkFilterOperator(operator);
83         _;
84     }
85 
86     function _checkFilterOperator(address operator) internal view virtual {
87         // Check registry code length to facilitate testing in environments without a deployed registry.
88         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
89             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
90                 revert OperatorNotAllowed(operator);
91             }
92         }
93     }
94 }
95 
96 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
97 
98 
99 pragma solidity ^0.8.13;
100 
101 
102 /**
103  * @title  DefaultOperatorFilterer
104  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
105  */
106 abstract contract DefaultOperatorFilterer is OperatorFilterer {
107     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
108 
109     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
110 }
111 
112 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
113 
114 
115 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev These functions deal with verification of Merkle Tree proofs.
121  *
122  * The tree and the proofs can be generated using our
123  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
124  * You will find a quickstart guide in the readme.
125  *
126  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
127  * hashing, or use a hash function other than keccak256 for hashing leaves.
128  * This is because the concatenation of a sorted pair of internal nodes in
129  * the merkle tree could be reinterpreted as a leaf value.
130  * OpenZeppelin's JavaScript library generates merkle trees that are safe
131  * against this attack out of the box.
132  */
133 library MerkleProof {
134     /**
135      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
136      * defined by `root`. For this, a `proof` must be provided, containing
137      * sibling hashes on the branch from the leaf to the root of the tree. Each
138      * pair of leaves and each pair of pre-images are assumed to be sorted.
139      */
140     function verify(
141         bytes32[] memory proof,
142         bytes32 root,
143         bytes32 leaf
144     ) internal pure returns (bool) {
145         return processProof(proof, leaf) == root;
146     }
147 
148     /**
149      * @dev Calldata version of {verify}
150      *
151      * _Available since v4.7._
152      */
153     function verifyCalldata(
154         bytes32[] calldata proof,
155         bytes32 root,
156         bytes32 leaf
157     ) internal pure returns (bool) {
158         return processProofCalldata(proof, leaf) == root;
159     }
160 
161     /**
162      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
163      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
164      * hash matches the root of the tree. When processing the proof, the pairs
165      * of leafs & pre-images are assumed to be sorted.
166      *
167      * _Available since v4.4._
168      */
169     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
170         bytes32 computedHash = leaf;
171         for (uint256 i = 0; i < proof.length; i++) {
172             computedHash = _hashPair(computedHash, proof[i]);
173         }
174         return computedHash;
175     }
176 
177     /**
178      * @dev Calldata version of {processProof}
179      *
180      * _Available since v4.7._
181      */
182     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
183         bytes32 computedHash = leaf;
184         for (uint256 i = 0; i < proof.length; i++) {
185             computedHash = _hashPair(computedHash, proof[i]);
186         }
187         return computedHash;
188     }
189 
190     /**
191      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
192      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
193      *
194      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
195      *
196      * _Available since v4.7._
197      */
198     function multiProofVerify(
199         bytes32[] memory proof,
200         bool[] memory proofFlags,
201         bytes32 root,
202         bytes32[] memory leaves
203     ) internal pure returns (bool) {
204         return processMultiProof(proof, proofFlags, leaves) == root;
205     }
206 
207     /**
208      * @dev Calldata version of {multiProofVerify}
209      *
210      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
211      *
212      * _Available since v4.7._
213      */
214     function multiProofVerifyCalldata(
215         bytes32[] calldata proof,
216         bool[] calldata proofFlags,
217         bytes32 root,
218         bytes32[] memory leaves
219     ) internal pure returns (bool) {
220         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
221     }
222 
223     /**
224      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
225      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
226      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
227      * respectively.
228      *
229      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
230      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
231      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
232      *
233      * _Available since v4.7._
234      */
235     function processMultiProof(
236         bytes32[] memory proof,
237         bool[] memory proofFlags,
238         bytes32[] memory leaves
239     ) internal pure returns (bytes32 merkleRoot) {
240         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
241         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
242         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
243         // the merkle tree.
244         uint256 leavesLen = leaves.length;
245         uint256 totalHashes = proofFlags.length;
246 
247         // Check proof validity.
248         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
249 
250         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
251         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
252         bytes32[] memory hashes = new bytes32[](totalHashes);
253         uint256 leafPos = 0;
254         uint256 hashPos = 0;
255         uint256 proofPos = 0;
256         // At each step, we compute the next hash using two values:
257         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
258         //   get the next hash.
259         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
260         //   `proof` array.
261         for (uint256 i = 0; i < totalHashes; i++) {
262             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
263             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
264             hashes[i] = _hashPair(a, b);
265         }
266 
267         if (totalHashes > 0) {
268             return hashes[totalHashes - 1];
269         } else if (leavesLen > 0) {
270             return leaves[0];
271         } else {
272             return proof[0];
273         }
274     }
275 
276     /**
277      * @dev Calldata version of {processMultiProof}.
278      *
279      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
280      *
281      * _Available since v4.7._
282      */
283     function processMultiProofCalldata(
284         bytes32[] calldata proof,
285         bool[] calldata proofFlags,
286         bytes32[] memory leaves
287     ) internal pure returns (bytes32 merkleRoot) {
288         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
289         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
290         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
291         // the merkle tree.
292         uint256 leavesLen = leaves.length;
293         uint256 totalHashes = proofFlags.length;
294 
295         // Check proof validity.
296         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
297 
298         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
299         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
300         bytes32[] memory hashes = new bytes32[](totalHashes);
301         uint256 leafPos = 0;
302         uint256 hashPos = 0;
303         uint256 proofPos = 0;
304         // At each step, we compute the next hash using two values:
305         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
306         //   get the next hash.
307         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
308         //   `proof` array.
309         for (uint256 i = 0; i < totalHashes; i++) {
310             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
311             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
312             hashes[i] = _hashPair(a, b);
313         }
314 
315         if (totalHashes > 0) {
316             return hashes[totalHashes - 1];
317         } else if (leavesLen > 0) {
318             return leaves[0];
319         } else {
320             return proof[0];
321         }
322     }
323 
324     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
325         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
326     }
327 
328     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
329         /// @solidity memory-safe-assembly
330         assembly {
331             mstore(0x00, a)
332             mstore(0x20, b)
333             value := keccak256(0x00, 0x40)
334         }
335     }
336 }
337 
338 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
339 
340 
341 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
342 
343 pragma solidity ^0.8.0;
344 
345 /**
346  * @dev Contract module that helps prevent reentrant calls to a function.
347  *
348  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
349  * available, which can be applied to functions to make sure there are no nested
350  * (reentrant) calls to them.
351  *
352  * Note that because there is a single `nonReentrant` guard, functions marked as
353  * `nonReentrant` may not call one another. This can be worked around by making
354  * those functions `private`, and then adding `external` `nonReentrant` entry
355  * points to them.
356  *
357  * TIP: If you would like to learn more about reentrancy and alternative ways
358  * to protect against it, check out our blog post
359  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
360  */
361 abstract contract ReentrancyGuard {
362     // Booleans are more expensive than uint256 or any type that takes up a full
363     // word because each write operation emits an extra SLOAD to first read the
364     // slot's contents, replace the bits taken up by the boolean, and then write
365     // back. This is the compiler's defense against contract upgrades and
366     // pointer aliasing, and it cannot be disabled.
367 
368     // The values being non-zero value makes deployment a bit more expensive,
369     // but in exchange the refund on every call to nonReentrant will be lower in
370     // amount. Since refunds are capped to a percentage of the total
371     // transaction's gas, it is best to keep them low in cases like this one, to
372     // increase the likelihood of the full refund coming into effect.
373     uint256 private constant _NOT_ENTERED = 1;
374     uint256 private constant _ENTERED = 2;
375 
376     uint256 private _status;
377 
378     constructor() {
379         _status = _NOT_ENTERED;
380     }
381 
382     /**
383      * @dev Prevents a contract from calling itself, directly or indirectly.
384      * Calling a `nonReentrant` function from another `nonReentrant`
385      * function is not supported. It is possible to prevent this from happening
386      * by making the `nonReentrant` function external, and making it call a
387      * `private` function that does the actual work.
388      */
389     modifier nonReentrant() {
390         _nonReentrantBefore();
391         _;
392         _nonReentrantAfter();
393     }
394 
395     function _nonReentrantBefore() private {
396         // On the first call to nonReentrant, _status will be _NOT_ENTERED
397         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
398 
399         // Any calls to nonReentrant after this point will fail
400         _status = _ENTERED;
401     }
402 
403     function _nonReentrantAfter() private {
404         // By storing the original value once again, a refund is triggered (see
405         // https://eips.ethereum.org/EIPS/eip-2200)
406         _status = _NOT_ENTERED;
407     }
408 }
409 
410 // File: @openzeppelin/contracts/utils/Context.sol
411 
412 
413 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
414 
415 pragma solidity ^0.8.0;
416 
417 /**
418  * @dev Provides information about the current execution context, including the
419  * sender of the transaction and its data. While these are generally available
420  * via msg.sender and msg.data, they should not be accessed in such a direct
421  * manner, since when dealing with meta-transactions the account sending and
422  * paying for execution may not be the actual sender (as far as an application
423  * is concerned).
424  *
425  * This contract is only required for intermediate, library-like contracts.
426  */
427 abstract contract Context {
428     function _msgSender() internal view virtual returns (address) {
429         return msg.sender;
430     }
431 
432     function _msgData() internal view virtual returns (bytes calldata) {
433         return msg.data;
434     }
435 }
436 
437 // File: @openzeppelin/contracts/access/Ownable.sol
438 
439 
440 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
441 
442 pragma solidity ^0.8.0;
443 
444 
445 /**
446  * @dev Contract module which provides a basic access control mechanism, where
447  * there is an account (an owner) that can be granted exclusive access to
448  * specific functions.
449  *
450  * By default, the owner account will be the one that deploys the contract. This
451  * can later be changed with {transferOwnership}.
452  *
453  * This module is used through inheritance. It will make available the modifier
454  * `onlyOwner`, which can be applied to your functions to restrict their use to
455  * the owner.
456  */
457 abstract contract Ownable is Context {
458     address private _owner;
459 
460     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
461 
462     /**
463      * @dev Initializes the contract setting the deployer as the initial owner.
464      */
465     constructor() {
466         _transferOwnership(_msgSender());
467     }
468 
469     /**
470      * @dev Throws if called by any account other than the owner.
471      */
472     modifier onlyOwner() {
473         _checkOwner();
474         _;
475     }
476 
477     /**
478      * @dev Returns the address of the current owner.
479      */
480     function owner() public view virtual returns (address) {
481         return _owner;
482     }
483 
484     /**
485      * @dev Throws if the sender is not the owner.
486      */
487     function _checkOwner() internal view virtual {
488         require(owner() == _msgSender(), "Ownable: caller is not the owner");
489     }
490 
491     /**
492      * @dev Leaves the contract without owner. It will not be possible to call
493      * `onlyOwner` functions anymore. Can only be called by the current owner.
494      *
495      * NOTE: Renouncing ownership will leave the contract without an owner,
496      * thereby removing any functionality that is only available to the owner.
497      */
498     function renounceOwnership() public virtual onlyOwner {
499         _transferOwnership(address(0));
500     }
501 
502     /**
503      * @dev Transfers ownership of the contract to a new account (`newOwner`).
504      * Can only be called by the current owner.
505      */
506     function transferOwnership(address newOwner) public virtual onlyOwner {
507         require(newOwner != address(0), "Ownable: new owner is the zero address");
508         _transferOwnership(newOwner);
509     }
510 
511     /**
512      * @dev Transfers ownership of the contract to a new account (`newOwner`).
513      * Internal function without access restriction.
514      */
515     function _transferOwnership(address newOwner) internal virtual {
516         address oldOwner = _owner;
517         _owner = newOwner;
518         emit OwnershipTransferred(oldOwner, newOwner);
519     }
520 }
521 
522 // File: erc721a/contracts/IERC721A.sol
523 
524 
525 // ERC721A Contracts v4.2.3
526 // Creator: Chiru Labs
527 
528 pragma solidity ^0.8.4;
529 
530 /**
531  * @dev Interface of ERC721A.
532  */
533 interface IERC721A {
534     /**
535      * The caller must own the token or be an approved operator.
536      */
537     error ApprovalCallerNotOwnerNorApproved();
538 
539     /**
540      * The token does not exist.
541      */
542     error ApprovalQueryForNonexistentToken();
543 
544     /**
545      * Cannot query the balance for the zero address.
546      */
547     error BalanceQueryForZeroAddress();
548 
549     /**
550      * Cannot mint to the zero address.
551      */
552     error MintToZeroAddress();
553 
554     /**
555      * The quantity of tokens minted must be more than zero.
556      */
557     error MintZeroQuantity();
558 
559     /**
560      * The token does not exist.
561      */
562     error OwnerQueryForNonexistentToken();
563 
564     /**
565      * The caller must own the token or be an approved operator.
566      */
567     error TransferCallerNotOwnerNorApproved();
568 
569     /**
570      * The token must be owned by `from`.
571      */
572     error TransferFromIncorrectOwner();
573 
574     /**
575      * Cannot safely transfer to a contract that does not implement the
576      * ERC721Receiver interface.
577      */
578     error TransferToNonERC721ReceiverImplementer();
579 
580     /**
581      * Cannot transfer to the zero address.
582      */
583     error TransferToZeroAddress();
584 
585     /**
586      * The token does not exist.
587      */
588     error URIQueryForNonexistentToken();
589 
590     /**
591      * The `quantity` minted with ERC2309 exceeds the safety limit.
592      */
593     error MintERC2309QuantityExceedsLimit();
594 
595     /**
596      * The `extraData` cannot be set on an unintialized ownership slot.
597      */
598     error OwnershipNotInitializedForExtraData();
599 
600     // =============================================================
601     //                            STRUCTS
602     // =============================================================
603 
604     struct TokenOwnership {
605         // The address of the owner.
606         address addr;
607         // Stores the start time of ownership with minimal overhead for tokenomics.
608         uint64 startTimestamp;
609         // Whether the token has been burned.
610         bool burned;
611         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
612         uint24 extraData;
613     }
614 
615     // =============================================================
616     //                         TOKEN COUNTERS
617     // =============================================================
618 
619     /**
620      * @dev Returns the total number of tokens in existence.
621      * Burned tokens will reduce the count.
622      * To get the total number of tokens minted, please see {_totalMinted}.
623      */
624     function totalSupply() external view returns (uint256);
625 
626     // =============================================================
627     //                            IERC165
628     // =============================================================
629 
630     /**
631      * @dev Returns true if this contract implements the interface defined by
632      * `interfaceId`. See the corresponding
633      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
634      * to learn more about how these ids are created.
635      *
636      * This function call must use less than 30000 gas.
637      */
638     function supportsInterface(bytes4 interfaceId) external view returns (bool);
639 
640     // =============================================================
641     //                            IERC721
642     // =============================================================
643 
644     /**
645      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
646      */
647     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
648 
649     /**
650      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
651      */
652     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
653 
654     /**
655      * @dev Emitted when `owner` enables or disables
656      * (`approved`) `operator` to manage all of its assets.
657      */
658     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
659 
660     /**
661      * @dev Returns the number of tokens in `owner`'s account.
662      */
663     function balanceOf(address owner) external view returns (uint256 balance);
664 
665     /**
666      * @dev Returns the owner of the `tokenId` token.
667      *
668      * Requirements:
669      *
670      * - `tokenId` must exist.
671      */
672     function ownerOf(uint256 tokenId) external view returns (address owner);
673 
674     /**
675      * @dev Safely transfers `tokenId` token from `from` to `to`,
676      * checking first that contract recipients are aware of the ERC721 protocol
677      * to prevent tokens from being forever locked.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must exist and be owned by `from`.
684      * - If the caller is not `from`, it must be have been allowed to move
685      * this token by either {approve} or {setApprovalForAll}.
686      * - If `to` refers to a smart contract, it must implement
687      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
688      *
689      * Emits a {Transfer} event.
690      */
691     function safeTransferFrom(
692         address from,
693         address to,
694         uint256 tokenId,
695         bytes calldata data
696     ) external payable;
697 
698     /**
699      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId
705     ) external payable;
706 
707     /**
708      * @dev Transfers `tokenId` from `from` to `to`.
709      *
710      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
711      * whenever possible.
712      *
713      * Requirements:
714      *
715      * - `from` cannot be the zero address.
716      * - `to` cannot be the zero address.
717      * - `tokenId` token must be owned by `from`.
718      * - If the caller is not `from`, it must be approved to move this token
719      * by either {approve} or {setApprovalForAll}.
720      *
721      * Emits a {Transfer} event.
722      */
723     function transferFrom(
724         address from,
725         address to,
726         uint256 tokenId
727     ) external payable;
728 
729     /**
730      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
731      * The approval is cleared when the token is transferred.
732      *
733      * Only a single account can be approved at a time, so approving the
734      * zero address clears previous approvals.
735      *
736      * Requirements:
737      *
738      * - The caller must own the token or be an approved operator.
739      * - `tokenId` must exist.
740      *
741      * Emits an {Approval} event.
742      */
743     function approve(address to, uint256 tokenId) external payable;
744 
745     /**
746      * @dev Approve or remove `operator` as an operator for the caller.
747      * Operators can call {transferFrom} or {safeTransferFrom}
748      * for any token owned by the caller.
749      *
750      * Requirements:
751      *
752      * - The `operator` cannot be the caller.
753      *
754      * Emits an {ApprovalForAll} event.
755      */
756     function setApprovalForAll(address operator, bool _approved) external;
757 
758     /**
759      * @dev Returns the account approved for `tokenId` token.
760      *
761      * Requirements:
762      *
763      * - `tokenId` must exist.
764      */
765     function getApproved(uint256 tokenId) external view returns (address operator);
766 
767     /**
768      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
769      *
770      * See {setApprovalForAll}.
771      */
772     function isApprovedForAll(address owner, address operator) external view returns (bool);
773 
774     // =============================================================
775     //                        IERC721Metadata
776     // =============================================================
777 
778     /**
779      * @dev Returns the token collection name.
780      */
781     function name() external view returns (string memory);
782 
783     /**
784      * @dev Returns the token collection symbol.
785      */
786     function symbol() external view returns (string memory);
787 
788     /**
789      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
790      */
791     function tokenURI(uint256 tokenId) external view returns (string memory);
792 
793     // =============================================================
794     //                           IERC2309
795     // =============================================================
796 
797     /**
798      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
799      * (inclusive) is transferred from `from` to `to`, as defined in the
800      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
801      *
802      * See {_mintERC2309} for more details.
803      */
804     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
805 }
806 
807 // File: erc721a/contracts/ERC721A.sol
808 
809 
810 // ERC721A Contracts v4.2.3
811 // Creator: Chiru Labs
812 
813 pragma solidity ^0.8.4;
814 
815 
816 /**
817  * @dev Interface of ERC721 token receiver.
818  */
819 interface ERC721A__IERC721Receiver {
820     function onERC721Received(
821         address operator,
822         address from,
823         uint256 tokenId,
824         bytes calldata data
825     ) external returns (bytes4);
826 }
827 
828 /**
829  * @title ERC721A
830  *
831  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
832  * Non-Fungible Token Standard, including the Metadata extension.
833  * Optimized for lower gas during batch mints.
834  *
835  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
836  * starting from `_startTokenId()`.
837  *
838  * Assumptions:
839  *
840  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
841  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
842  */
843 contract ERC721A is IERC721A {
844     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
845     struct TokenApprovalRef {
846         address value;
847     }
848 
849     // =============================================================
850     //                           CONSTANTS
851     // =============================================================
852 
853     // Mask of an entry in packed address data.
854     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
855 
856     // The bit position of `numberMinted` in packed address data.
857     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
858 
859     // The bit position of `numberBurned` in packed address data.
860     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
861 
862     // The bit position of `aux` in packed address data.
863     uint256 private constant _BITPOS_AUX = 192;
864 
865     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
866     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
867 
868     // The bit position of `startTimestamp` in packed ownership.
869     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
870 
871     // The bit mask of the `burned` bit in packed ownership.
872     uint256 private constant _BITMASK_BURNED = 1 << 224;
873 
874     // The bit position of the `nextInitialized` bit in packed ownership.
875     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
876 
877     // The bit mask of the `nextInitialized` bit in packed ownership.
878     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
879 
880     // The bit position of `extraData` in packed ownership.
881     uint256 private constant _BITPOS_EXTRA_DATA = 232;
882 
883     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
884     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
885 
886     // The mask of the lower 160 bits for addresses.
887     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
888 
889     // The maximum `quantity` that can be minted with {_mintERC2309}.
890     // This limit is to prevent overflows on the address data entries.
891     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
892     // is required to cause an overflow, which is unrealistic.
893     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
894 
895     // The `Transfer` event signature is given by:
896     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
897     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
898         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
899 
900     // =============================================================
901     //                            STORAGE
902     // =============================================================
903 
904     // The next token ID to be minted.
905     uint256 private _currentIndex;
906 
907     // The number of tokens burned.
908     uint256 private _burnCounter;
909 
910     // Token name
911     string private _name;
912 
913     // Token symbol
914     string private _symbol;
915 
916     // Mapping from token ID to ownership details
917     // An empty struct value does not necessarily mean the token is unowned.
918     // See {_packedOwnershipOf} implementation for details.
919     //
920     // Bits Layout:
921     // - [0..159]   `addr`
922     // - [160..223] `startTimestamp`
923     // - [224]      `burned`
924     // - [225]      `nextInitialized`
925     // - [232..255] `extraData`
926     mapping(uint256 => uint256) private _packedOwnerships;
927 
928     // Mapping owner address to address data.
929     //
930     // Bits Layout:
931     // - [0..63]    `balance`
932     // - [64..127]  `numberMinted`
933     // - [128..191] `numberBurned`
934     // - [192..255] `aux`
935     mapping(address => uint256) private _packedAddressData;
936 
937     // Mapping from token ID to approved address.
938     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
939 
940     // Mapping from owner to operator approvals
941     mapping(address => mapping(address => bool)) private _operatorApprovals;
942 
943     // =============================================================
944     //                          CONSTRUCTOR
945     // =============================================================
946 
947     constructor(string memory name_, string memory symbol_) {
948         _name = name_;
949         _symbol = symbol_;
950         _currentIndex = _startTokenId();
951     }
952 
953     // =============================================================
954     //                   TOKEN COUNTING OPERATIONS
955     // =============================================================
956 
957     /**
958      * @dev Returns the starting token ID.
959      * To change the starting token ID, please override this function.
960      */
961     function _startTokenId() internal view virtual returns (uint256) {
962         return 0;
963     }
964 
965     /**
966      * @dev Returns the next token ID to be minted.
967      */
968     function _nextTokenId() internal view virtual returns (uint256) {
969         return _currentIndex;
970     }
971 
972     /**
973      * @dev Returns the total number of tokens in existence.
974      * Burned tokens will reduce the count.
975      * To get the total number of tokens minted, please see {_totalMinted}.
976      */
977     function totalSupply() public view virtual override returns (uint256) {
978         // Counter underflow is impossible as _burnCounter cannot be incremented
979         // more than `_currentIndex - _startTokenId()` times.
980         unchecked {
981             return _currentIndex - _burnCounter - _startTokenId();
982         }
983     }
984 
985     /**
986      * @dev Returns the total amount of tokens minted in the contract.
987      */
988     function _totalMinted() internal view virtual returns (uint256) {
989         // Counter underflow is impossible as `_currentIndex` does not decrement,
990         // and it is initialized to `_startTokenId()`.
991         unchecked {
992             return _currentIndex - _startTokenId();
993         }
994     }
995 
996     /**
997      * @dev Returns the total number of tokens burned.
998      */
999     function _totalBurned() internal view virtual returns (uint256) {
1000         return _burnCounter;
1001     }
1002 
1003     // =============================================================
1004     //                    ADDRESS DATA OPERATIONS
1005     // =============================================================
1006 
1007     /**
1008      * @dev Returns the number of tokens in `owner`'s account.
1009      */
1010     function balanceOf(address owner) public view virtual override returns (uint256) {
1011         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1012         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1013     }
1014 
1015     /**
1016      * Returns the number of tokens minted by `owner`.
1017      */
1018     function _numberMinted(address owner) internal view returns (uint256) {
1019         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1020     }
1021 
1022     /**
1023      * Returns the number of tokens burned by or on behalf of `owner`.
1024      */
1025     function _numberBurned(address owner) internal view returns (uint256) {
1026         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1027     }
1028 
1029     /**
1030      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1031      */
1032     function _getAux(address owner) internal view returns (uint64) {
1033         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1034     }
1035 
1036     /**
1037      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1038      * If there are multiple variables, please pack them into a uint64.
1039      */
1040     function _setAux(address owner, uint64 aux) internal virtual {
1041         uint256 packed = _packedAddressData[owner];
1042         uint256 auxCasted;
1043         // Cast `aux` with assembly to avoid redundant masking.
1044         assembly {
1045             auxCasted := aux
1046         }
1047         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1048         _packedAddressData[owner] = packed;
1049     }
1050 
1051     // =============================================================
1052     //                            IERC165
1053     // =============================================================
1054 
1055     /**
1056      * @dev Returns true if this contract implements the interface defined by
1057      * `interfaceId`. See the corresponding
1058      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1059      * to learn more about how these ids are created.
1060      *
1061      * This function call must use less than 30000 gas.
1062      */
1063     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1064         // The interface IDs are constants representing the first 4 bytes
1065         // of the XOR of all function selectors in the interface.
1066         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1067         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1068         return
1069             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1070             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1071             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1072     }
1073 
1074     // =============================================================
1075     //                        IERC721Metadata
1076     // =============================================================
1077 
1078     /**
1079      * @dev Returns the token collection name.
1080      */
1081     function name() public view virtual override returns (string memory) {
1082         return _name;
1083     }
1084 
1085     /**
1086      * @dev Returns the token collection symbol.
1087      */
1088     function symbol() public view virtual override returns (string memory) {
1089         return _symbol;
1090     }
1091 
1092     /**
1093      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1094      */
1095     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1096         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1097 
1098         string memory baseURI = _baseURI();
1099         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1100     }
1101 
1102     /**
1103      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1104      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1105      * by default, it can be overridden in child contracts.
1106      */
1107     function _baseURI() internal view virtual returns (string memory) {
1108         return '';
1109     }
1110 
1111     // =============================================================
1112     //                     OWNERSHIPS OPERATIONS
1113     // =============================================================
1114 
1115     /**
1116      * @dev Returns the owner of the `tokenId` token.
1117      *
1118      * Requirements:
1119      *
1120      * - `tokenId` must exist.
1121      */
1122     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1123         return address(uint160(_packedOwnershipOf(tokenId)));
1124     }
1125 
1126     /**
1127      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1128      * It gradually moves to O(1) as tokens get transferred around over time.
1129      */
1130     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1131         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1132     }
1133 
1134     /**
1135      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1136      */
1137     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1138         return _unpackedOwnership(_packedOwnerships[index]);
1139     }
1140 
1141     /**
1142      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1143      */
1144     function _initializeOwnershipAt(uint256 index) internal virtual {
1145         if (_packedOwnerships[index] == 0) {
1146             _packedOwnerships[index] = _packedOwnershipOf(index);
1147         }
1148     }
1149 
1150     /**
1151      * Returns the packed ownership data of `tokenId`.
1152      */
1153     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1154         uint256 curr = tokenId;
1155 
1156         unchecked {
1157             if (_startTokenId() <= curr)
1158                 if (curr < _currentIndex) {
1159                     uint256 packed = _packedOwnerships[curr];
1160                     // If not burned.
1161                     if (packed & _BITMASK_BURNED == 0) {
1162                         // Invariant:
1163                         // There will always be an initialized ownership slot
1164                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1165                         // before an unintialized ownership slot
1166                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1167                         // Hence, `curr` will not underflow.
1168                         //
1169                         // We can directly compare the packed value.
1170                         // If the address is zero, packed will be zero.
1171                         while (packed == 0) {
1172                             packed = _packedOwnerships[--curr];
1173                         }
1174                         return packed;
1175                     }
1176                 }
1177         }
1178         revert OwnerQueryForNonexistentToken();
1179     }
1180 
1181     /**
1182      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1183      */
1184     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1185         ownership.addr = address(uint160(packed));
1186         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1187         ownership.burned = packed & _BITMASK_BURNED != 0;
1188         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1189     }
1190 
1191     /**
1192      * @dev Packs ownership data into a single uint256.
1193      */
1194     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1195         assembly {
1196             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1197             owner := and(owner, _BITMASK_ADDRESS)
1198             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1199             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1200         }
1201     }
1202 
1203     /**
1204      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1205      */
1206     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1207         // For branchless setting of the `nextInitialized` flag.
1208         assembly {
1209             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1210             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1211         }
1212     }
1213 
1214     // =============================================================
1215     //                      APPROVAL OPERATIONS
1216     // =============================================================
1217 
1218     /**
1219      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1220      * The approval is cleared when the token is transferred.
1221      *
1222      * Only a single account can be approved at a time, so approving the
1223      * zero address clears previous approvals.
1224      *
1225      * Requirements:
1226      *
1227      * - The caller must own the token or be an approved operator.
1228      * - `tokenId` must exist.
1229      *
1230      * Emits an {Approval} event.
1231      */
1232     function approve(address to, uint256 tokenId) public payable virtual override {
1233         address owner = ownerOf(tokenId);
1234 
1235         if (_msgSenderERC721A() != owner)
1236             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1237                 revert ApprovalCallerNotOwnerNorApproved();
1238             }
1239 
1240         _tokenApprovals[tokenId].value = to;
1241         emit Approval(owner, to, tokenId);
1242     }
1243 
1244     /**
1245      * @dev Returns the account approved for `tokenId` token.
1246      *
1247      * Requirements:
1248      *
1249      * - `tokenId` must exist.
1250      */
1251     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1252         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1253 
1254         return _tokenApprovals[tokenId].value;
1255     }
1256 
1257     /**
1258      * @dev Approve or remove `operator` as an operator for the caller.
1259      * Operators can call {transferFrom} or {safeTransferFrom}
1260      * for any token owned by the caller.
1261      *
1262      * Requirements:
1263      *
1264      * - The `operator` cannot be the caller.
1265      *
1266      * Emits an {ApprovalForAll} event.
1267      */
1268     function setApprovalForAll(address operator, bool approved) public virtual override {
1269         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1270         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1271     }
1272 
1273     /**
1274      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1275      *
1276      * See {setApprovalForAll}.
1277      */
1278     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1279         return _operatorApprovals[owner][operator];
1280     }
1281 
1282     /**
1283      * @dev Returns whether `tokenId` exists.
1284      *
1285      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1286      *
1287      * Tokens start existing when they are minted. See {_mint}.
1288      */
1289     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1290         return
1291             _startTokenId() <= tokenId &&
1292             tokenId < _currentIndex && // If within bounds,
1293             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1294     }
1295 
1296     /**
1297      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1298      */
1299     function _isSenderApprovedOrOwner(
1300         address approvedAddress,
1301         address owner,
1302         address msgSender
1303     ) private pure returns (bool result) {
1304         assembly {
1305             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1306             owner := and(owner, _BITMASK_ADDRESS)
1307             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1308             msgSender := and(msgSender, _BITMASK_ADDRESS)
1309             // `msgSender == owner || msgSender == approvedAddress`.
1310             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1311         }
1312     }
1313 
1314     /**
1315      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1316      */
1317     function _getApprovedSlotAndAddress(uint256 tokenId)
1318         private
1319         view
1320         returns (uint256 approvedAddressSlot, address approvedAddress)
1321     {
1322         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1323         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1324         assembly {
1325             approvedAddressSlot := tokenApproval.slot
1326             approvedAddress := sload(approvedAddressSlot)
1327         }
1328     }
1329 
1330     // =============================================================
1331     //                      TRANSFER OPERATIONS
1332     // =============================================================
1333 
1334     /**
1335      * @dev Transfers `tokenId` from `from` to `to`.
1336      *
1337      * Requirements:
1338      *
1339      * - `from` cannot be the zero address.
1340      * - `to` cannot be the zero address.
1341      * - `tokenId` token must be owned by `from`.
1342      * - If the caller is not `from`, it must be approved to move this token
1343      * by either {approve} or {setApprovalForAll}.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function transferFrom(
1348         address from,
1349         address to,
1350         uint256 tokenId
1351     ) public payable virtual override {
1352         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1353 
1354         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1355 
1356         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1357 
1358         // The nested ifs save around 20+ gas over a compound boolean condition.
1359         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1360             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1361 
1362         if (to == address(0)) revert TransferToZeroAddress();
1363 
1364         _beforeTokenTransfers(from, to, tokenId, 1);
1365 
1366         // Clear approvals from the previous owner.
1367         assembly {
1368             if approvedAddress {
1369                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1370                 sstore(approvedAddressSlot, 0)
1371             }
1372         }
1373 
1374         // Underflow of the sender's balance is impossible because we check for
1375         // ownership above and the recipient's balance can't realistically overflow.
1376         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1377         unchecked {
1378             // We can directly increment and decrement the balances.
1379             --_packedAddressData[from]; // Updates: `balance -= 1`.
1380             ++_packedAddressData[to]; // Updates: `balance += 1`.
1381 
1382             // Updates:
1383             // - `address` to the next owner.
1384             // - `startTimestamp` to the timestamp of transfering.
1385             // - `burned` to `false`.
1386             // - `nextInitialized` to `true`.
1387             _packedOwnerships[tokenId] = _packOwnershipData(
1388                 to,
1389                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1390             );
1391 
1392             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1393             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1394                 uint256 nextTokenId = tokenId + 1;
1395                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1396                 if (_packedOwnerships[nextTokenId] == 0) {
1397                     // If the next slot is within bounds.
1398                     if (nextTokenId != _currentIndex) {
1399                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1400                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1401                     }
1402                 }
1403             }
1404         }
1405 
1406         emit Transfer(from, to, tokenId);
1407         _afterTokenTransfers(from, to, tokenId, 1);
1408     }
1409 
1410     /**
1411      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1412      */
1413     function safeTransferFrom(
1414         address from,
1415         address to,
1416         uint256 tokenId
1417     ) public payable virtual override {
1418         safeTransferFrom(from, to, tokenId, '');
1419     }
1420 
1421     /**
1422      * @dev Safely transfers `tokenId` token from `from` to `to`.
1423      *
1424      * Requirements:
1425      *
1426      * - `from` cannot be the zero address.
1427      * - `to` cannot be the zero address.
1428      * - `tokenId` token must exist and be owned by `from`.
1429      * - If the caller is not `from`, it must be approved to move this token
1430      * by either {approve} or {setApprovalForAll}.
1431      * - If `to` refers to a smart contract, it must implement
1432      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function safeTransferFrom(
1437         address from,
1438         address to,
1439         uint256 tokenId,
1440         bytes memory _data
1441     ) public payable virtual override {
1442         transferFrom(from, to, tokenId);
1443         if (to.code.length != 0)
1444             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1445                 revert TransferToNonERC721ReceiverImplementer();
1446             }
1447     }
1448 
1449     /**
1450      * @dev Hook that is called before a set of serially-ordered token IDs
1451      * are about to be transferred. This includes minting.
1452      * And also called before burning one token.
1453      *
1454      * `startTokenId` - the first token ID to be transferred.
1455      * `quantity` - the amount to be transferred.
1456      *
1457      * Calling conditions:
1458      *
1459      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1460      * transferred to `to`.
1461      * - When `from` is zero, `tokenId` will be minted for `to`.
1462      * - When `to` is zero, `tokenId` will be burned by `from`.
1463      * - `from` and `to` are never both zero.
1464      */
1465     function _beforeTokenTransfers(
1466         address from,
1467         address to,
1468         uint256 startTokenId,
1469         uint256 quantity
1470     ) internal virtual {}
1471 
1472     /**
1473      * @dev Hook that is called after a set of serially-ordered token IDs
1474      * have been transferred. This includes minting.
1475      * And also called after one token has been burned.
1476      *
1477      * `startTokenId` - the first token ID to be transferred.
1478      * `quantity` - the amount to be transferred.
1479      *
1480      * Calling conditions:
1481      *
1482      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1483      * transferred to `to`.
1484      * - When `from` is zero, `tokenId` has been minted for `to`.
1485      * - When `to` is zero, `tokenId` has been burned by `from`.
1486      * - `from` and `to` are never both zero.
1487      */
1488     function _afterTokenTransfers(
1489         address from,
1490         address to,
1491         uint256 startTokenId,
1492         uint256 quantity
1493     ) internal virtual {}
1494 
1495     /**
1496      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1497      *
1498      * `from` - Previous owner of the given token ID.
1499      * `to` - Target address that will receive the token.
1500      * `tokenId` - Token ID to be transferred.
1501      * `_data` - Optional data to send along with the call.
1502      *
1503      * Returns whether the call correctly returned the expected magic value.
1504      */
1505     function _checkContractOnERC721Received(
1506         address from,
1507         address to,
1508         uint256 tokenId,
1509         bytes memory _data
1510     ) private returns (bool) {
1511         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1512             bytes4 retval
1513         ) {
1514             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1515         } catch (bytes memory reason) {
1516             if (reason.length == 0) {
1517                 revert TransferToNonERC721ReceiverImplementer();
1518             } else {
1519                 assembly {
1520                     revert(add(32, reason), mload(reason))
1521                 }
1522             }
1523         }
1524     }
1525 
1526     // =============================================================
1527     //                        MINT OPERATIONS
1528     // =============================================================
1529 
1530     /**
1531      * @dev Mints `quantity` tokens and transfers them to `to`.
1532      *
1533      * Requirements:
1534      *
1535      * - `to` cannot be the zero address.
1536      * - `quantity` must be greater than 0.
1537      *
1538      * Emits a {Transfer} event for each mint.
1539      */
1540     function _mint(address to, uint256 quantity) internal virtual {
1541         uint256 startTokenId = _currentIndex;
1542         if (quantity == 0) revert MintZeroQuantity();
1543 
1544         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1545 
1546         // Overflows are incredibly unrealistic.
1547         // `balance` and `numberMinted` have a maximum limit of 2**64.
1548         // `tokenId` has a maximum limit of 2**256.
1549         unchecked {
1550             // Updates:
1551             // - `balance += quantity`.
1552             // - `numberMinted += quantity`.
1553             //
1554             // We can directly add to the `balance` and `numberMinted`.
1555             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1556 
1557             // Updates:
1558             // - `address` to the owner.
1559             // - `startTimestamp` to the timestamp of minting.
1560             // - `burned` to `false`.
1561             // - `nextInitialized` to `quantity == 1`.
1562             _packedOwnerships[startTokenId] = _packOwnershipData(
1563                 to,
1564                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1565             );
1566 
1567             uint256 toMasked;
1568             uint256 end = startTokenId + quantity;
1569 
1570             // Use assembly to loop and emit the `Transfer` event for gas savings.
1571             // The duplicated `log4` removes an extra check and reduces stack juggling.
1572             // The assembly, together with the surrounding Solidity code, have been
1573             // delicately arranged to nudge the compiler into producing optimized opcodes.
1574             assembly {
1575                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1576                 toMasked := and(to, _BITMASK_ADDRESS)
1577                 // Emit the `Transfer` event.
1578                 log4(
1579                     0, // Start of data (0, since no data).
1580                     0, // End of data (0, since no data).
1581                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1582                     0, // `address(0)`.
1583                     toMasked, // `to`.
1584                     startTokenId // `tokenId`.
1585                 )
1586 
1587                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1588                 // that overflows uint256 will make the loop run out of gas.
1589                 // The compiler will optimize the `iszero` away for performance.
1590                 for {
1591                     let tokenId := add(startTokenId, 1)
1592                 } iszero(eq(tokenId, end)) {
1593                     tokenId := add(tokenId, 1)
1594                 } {
1595                     // Emit the `Transfer` event. Similar to above.
1596                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1597                 }
1598             }
1599             if (toMasked == 0) revert MintToZeroAddress();
1600 
1601             _currentIndex = end;
1602         }
1603         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1604     }
1605 
1606     /**
1607      * @dev Mints `quantity` tokens and transfers them to `to`.
1608      *
1609      * This function is intended for efficient minting only during contract creation.
1610      *
1611      * It emits only one {ConsecutiveTransfer} as defined in
1612      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1613      * instead of a sequence of {Transfer} event(s).
1614      *
1615      * Calling this function outside of contract creation WILL make your contract
1616      * non-compliant with the ERC721 standard.
1617      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1618      * {ConsecutiveTransfer} event is only permissible during contract creation.
1619      *
1620      * Requirements:
1621      *
1622      * - `to` cannot be the zero address.
1623      * - `quantity` must be greater than 0.
1624      *
1625      * Emits a {ConsecutiveTransfer} event.
1626      */
1627     function _mintERC2309(address to, uint256 quantity) internal virtual {
1628         uint256 startTokenId = _currentIndex;
1629         if (to == address(0)) revert MintToZeroAddress();
1630         if (quantity == 0) revert MintZeroQuantity();
1631         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1632 
1633         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1634 
1635         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1636         unchecked {
1637             // Updates:
1638             // - `balance += quantity`.
1639             // - `numberMinted += quantity`.
1640             //
1641             // We can directly add to the `balance` and `numberMinted`.
1642             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1643 
1644             // Updates:
1645             // - `address` to the owner.
1646             // - `startTimestamp` to the timestamp of minting.
1647             // - `burned` to `false`.
1648             // - `nextInitialized` to `quantity == 1`.
1649             _packedOwnerships[startTokenId] = _packOwnershipData(
1650                 to,
1651                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1652             );
1653 
1654             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1655 
1656             _currentIndex = startTokenId + quantity;
1657         }
1658         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1659     }
1660 
1661     /**
1662      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1663      *
1664      * Requirements:
1665      *
1666      * - If `to` refers to a smart contract, it must implement
1667      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1668      * - `quantity` must be greater than 0.
1669      *
1670      * See {_mint}.
1671      *
1672      * Emits a {Transfer} event for each mint.
1673      */
1674     function _safeMint(
1675         address to,
1676         uint256 quantity,
1677         bytes memory _data
1678     ) internal virtual {
1679         _mint(to, quantity);
1680 
1681         unchecked {
1682             if (to.code.length != 0) {
1683                 uint256 end = _currentIndex;
1684                 uint256 index = end - quantity;
1685                 do {
1686                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1687                         revert TransferToNonERC721ReceiverImplementer();
1688                     }
1689                 } while (index < end);
1690                 // Reentrancy protection.
1691                 if (_currentIndex != end) revert();
1692             }
1693         }
1694     }
1695 
1696     /**
1697      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1698      */
1699     function _safeMint(address to, uint256 quantity) internal virtual {
1700         _safeMint(to, quantity, '');
1701     }
1702 
1703     // =============================================================
1704     //                        BURN OPERATIONS
1705     // =============================================================
1706 
1707     /**
1708      * @dev Equivalent to `_burn(tokenId, false)`.
1709      */
1710     function _burn(uint256 tokenId) internal virtual {
1711         _burn(tokenId, false);
1712     }
1713 
1714     /**
1715      * @dev Destroys `tokenId`.
1716      * The approval is cleared when the token is burned.
1717      *
1718      * Requirements:
1719      *
1720      * - `tokenId` must exist.
1721      *
1722      * Emits a {Transfer} event.
1723      */
1724     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1725         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1726 
1727         address from = address(uint160(prevOwnershipPacked));
1728 
1729         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1730 
1731         if (approvalCheck) {
1732             // The nested ifs save around 20+ gas over a compound boolean condition.
1733             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1734                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1735         }
1736 
1737         _beforeTokenTransfers(from, address(0), tokenId, 1);
1738 
1739         // Clear approvals from the previous owner.
1740         assembly {
1741             if approvedAddress {
1742                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1743                 sstore(approvedAddressSlot, 0)
1744             }
1745         }
1746 
1747         // Underflow of the sender's balance is impossible because we check for
1748         // ownership above and the recipient's balance can't realistically overflow.
1749         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1750         unchecked {
1751             // Updates:
1752             // - `balance -= 1`.
1753             // - `numberBurned += 1`.
1754             //
1755             // We can directly decrement the balance, and increment the number burned.
1756             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1757             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1758 
1759             // Updates:
1760             // - `address` to the last owner.
1761             // - `startTimestamp` to the timestamp of burning.
1762             // - `burned` to `true`.
1763             // - `nextInitialized` to `true`.
1764             _packedOwnerships[tokenId] = _packOwnershipData(
1765                 from,
1766                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1767             );
1768 
1769             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1770             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1771                 uint256 nextTokenId = tokenId + 1;
1772                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1773                 if (_packedOwnerships[nextTokenId] == 0) {
1774                     // If the next slot is within bounds.
1775                     if (nextTokenId != _currentIndex) {
1776                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1777                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1778                     }
1779                 }
1780             }
1781         }
1782 
1783         emit Transfer(from, address(0), tokenId);
1784         _afterTokenTransfers(from, address(0), tokenId, 1);
1785 
1786         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1787         unchecked {
1788             _burnCounter++;
1789         }
1790     }
1791 
1792     // =============================================================
1793     //                     EXTRA DATA OPERATIONS
1794     // =============================================================
1795 
1796     /**
1797      * @dev Directly sets the extra data for the ownership data `index`.
1798      */
1799     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1800         uint256 packed = _packedOwnerships[index];
1801         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1802         uint256 extraDataCasted;
1803         // Cast `extraData` with assembly to avoid redundant masking.
1804         assembly {
1805             extraDataCasted := extraData
1806         }
1807         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1808         _packedOwnerships[index] = packed;
1809     }
1810 
1811     /**
1812      * @dev Called during each token transfer to set the 24bit `extraData` field.
1813      * Intended to be overridden by the cosumer contract.
1814      *
1815      * `previousExtraData` - the value of `extraData` before transfer.
1816      *
1817      * Calling conditions:
1818      *
1819      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1820      * transferred to `to`.
1821      * - When `from` is zero, `tokenId` will be minted for `to`.
1822      * - When `to` is zero, `tokenId` will be burned by `from`.
1823      * - `from` and `to` are never both zero.
1824      */
1825     function _extraData(
1826         address from,
1827         address to,
1828         uint24 previousExtraData
1829     ) internal view virtual returns (uint24) {}
1830 
1831     /**
1832      * @dev Returns the next extra data for the packed ownership data.
1833      * The returned result is shifted into position.
1834      */
1835     function _nextExtraData(
1836         address from,
1837         address to,
1838         uint256 prevOwnershipPacked
1839     ) private view returns (uint256) {
1840         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1841         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1842     }
1843 
1844     // =============================================================
1845     //                       OTHER OPERATIONS
1846     // =============================================================
1847 
1848     /**
1849      * @dev Returns the message sender (defaults to `msg.sender`).
1850      *
1851      * If you are writing GSN compatible contracts, you need to override this function.
1852      */
1853     function _msgSenderERC721A() internal view virtual returns (address) {
1854         return msg.sender;
1855     }
1856 
1857     /**
1858      * @dev Converts a uint256 to its ASCII string decimal representation.
1859      */
1860     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1861         assembly {
1862             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1863             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1864             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1865             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1866             let m := add(mload(0x40), 0xa0)
1867             // Update the free memory pointer to allocate.
1868             mstore(0x40, m)
1869             // Assign the `str` to the end.
1870             str := sub(m, 0x20)
1871             // Zeroize the slot after the string.
1872             mstore(str, 0)
1873 
1874             // Cache the end of the memory to calculate the length later.
1875             let end := str
1876 
1877             // We write the string from rightmost digit to leftmost digit.
1878             // The following is essentially a do-while loop that also handles the zero case.
1879             // prettier-ignore
1880             for { let temp := value } 1 {} {
1881                 str := sub(str, 1)
1882                 // Write the character to the pointer.
1883                 // The ASCII index of the '0' character is 48.
1884                 mstore8(str, add(48, mod(temp, 10)))
1885                 // Keep dividing `temp` until zero.
1886                 temp := div(temp, 10)
1887                 // prettier-ignore
1888                 if iszero(temp) { break }
1889             }
1890 
1891             let length := sub(end, str)
1892             // Move the pointer 32 bytes leftwards to make room for the length.
1893             str := sub(str, 0x20)
1894             // Store the length.
1895             mstore(str, length)
1896         }
1897     }
1898 }
1899 
1900 // File: plluma.sol
1901 
1902 
1903 
1904 //Developer : FazelPejmanfar , Twitter :@Pejmanfarfazel
1905 
1906 
1907 
1908 pragma solidity >=0.7.0 <0.9.0;
1909 
1910 
1911 
1912 
1913 
1914 
1915 contract Pllum is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
1916 
1917 
1918   string public baseURI;
1919   string public notRevealedUri;
1920   uint256 public cost = 0.005 ether;
1921   uint256 public wlcost = 0.005 ether;
1922   uint256 public maxSupply = 2222;
1923   uint256 public WlSupply = 2222;
1924   uint256 public MaxperWallet = 10;
1925   uint256 public MaxperWalletWl = 10;
1926   bool public paused = true;
1927   bool public revealed = false;
1928   bool public preSale = false;
1929   bytes32 public merkleRoot;
1930   mapping (address => uint256) public PublicMintofUser;
1931   mapping (address => uint256) public WhitelistedMintofUser;
1932 
1933   constructor() ERC721A("Pllum", "PLLUM") {}
1934 
1935   // internal
1936   function _baseURI() internal view virtual override returns (string memory) {
1937     return baseURI;
1938   }
1939       function _startTokenId() internal view virtual override returns (uint256) {
1940         return 1;
1941     }
1942 
1943   // public
1944   /// @dev Public mint 
1945   function mint(uint256 tokens) public payable nonReentrant {
1946     require(!paused, "PLLUM: oops contract is paused");
1947     require(!preSale, "PLLUM: Sale Hasn't started yet");
1948     require(tokens <= 5, "PLLUM: max mint amount per tx exceeded");
1949     require(totalSupply() + tokens <= maxSupply, "PLLUM: We Soldout");
1950     require(PublicMintofUser[_msgSenderERC721A()] + tokens <= MaxperWallet, "PLLUM: Max NFT Per Wallet exceeded");
1951     require(msg.value >= cost * tokens, "PLLUM: insufficient funds");
1952 
1953        PublicMintofUser[_msgSenderERC721A()] += tokens;
1954       _safeMint(_msgSenderERC721A(), tokens);
1955     
1956   }
1957 /// @dev presale mint for whitelisted
1958     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public payable nonReentrant {
1959     require(!paused, "PLLUM: oops contract is paused");
1960     require(preSale, "PLLUM: Presale Hasn't started yet");
1961     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "PLLUM: You are not Whitelisted");
1962     require(WhitelistedMintofUser[_msgSenderERC721A()] + tokens <= MaxperWalletWl, "PLLUM: Max NFT Per Wallet exceeded");
1963     require(tokens <= MaxperWalletWl, "PLLUM: max mint per Tx exceeded");
1964     require(totalSupply() + tokens <= WlSupply, "PLLUM: Whitelist MaxSupply exceeded");
1965     require(msg.value >= wlcost * tokens, "PLLUM: insufficient funds");
1966 
1967        WhitelistedMintofUser[_msgSenderERC721A()] += tokens;
1968       _safeMint(_msgSenderERC721A(), tokens);
1969     
1970   }
1971 
1972   /// @dev use it for giveaway and team mint
1973      function airdrop(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
1974     require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
1975 
1976       _safeMint(destination, _mintAmount);
1977   }
1978 
1979 /// @notice returns metadata link of tokenid
1980   function tokenURI(uint256 tokenId)
1981     public
1982     view
1983     virtual
1984     override
1985     returns (string memory)
1986   {
1987     require(
1988       _exists(tokenId),
1989       "ERC721AMetadata: URI query for nonexistent token"
1990     );
1991     
1992     if(revealed == false) {
1993         return notRevealedUri;
1994     }
1995 
1996     string memory currentBaseURI = _baseURI();
1997     return bytes(currentBaseURI).length > 0
1998         ? string(abi.encodePacked(currentBaseURI, _toString(tokenId), ".json"))
1999         : "";
2000   }
2001 
2002      /// @notice return the number minted by an address
2003     function numberMinted(address owner) public view returns (uint256) {
2004     return _numberMinted(owner);
2005   }
2006 
2007     /// @notice return the tokens owned by an address
2008       function tokensOfOwner(address owner) public view returns (uint256[] memory) {
2009         unchecked {
2010             uint256 tokenIdsIdx;
2011             address currOwnershipAddr;
2012             uint256 tokenIdsLength = balanceOf(owner);
2013             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2014             TokenOwnership memory ownership;
2015             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2016                 ownership = _ownershipAt(i);
2017                 if (ownership.burned) {
2018                     continue;
2019                 }
2020                 if (ownership.addr != address(0)) {
2021                     currOwnershipAddr = ownership.addr;
2022                 }
2023                 if (currOwnershipAddr == owner) {
2024                     tokenIds[tokenIdsIdx++] = i;
2025                 }
2026             }
2027             return tokenIds;
2028         }
2029     }
2030 
2031   //only owner
2032   function reveal(bool _state) public onlyOwner {
2033       revealed = _state;
2034   }
2035 
2036     /// @dev change the merkle root for the whitelist phase
2037   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2038         merkleRoot = _merkleRoot;
2039     }
2040 
2041   /// @dev change the public max per wallet
2042   function setMaxPerWallet(uint256 _limit) public onlyOwner {
2043     MaxperWallet = _limit;
2044   }
2045 
2046   /// @dev change the whitelist max per wallet
2047     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
2048     MaxperWalletWl = _limit;
2049   }
2050 
2051    /// @dev change the public price(amount need to be in wei)
2052   function setCost(uint256 _newCost) public onlyOwner {
2053     cost = _newCost;
2054   }
2055 
2056    /// @dev change the whitelist price(amount need to be in wei)
2057     function setWlCost(uint256 _newWlCost) public onlyOwner {
2058     wlcost = _newWlCost;
2059   }
2060 
2061   /// @dev cut the supply if we dont sold out
2062     function setMaxsupply(uint256 _newsupply) public onlyOwner {
2063     maxSupply = _newsupply;
2064   }
2065 
2066  /// @dev cut the whitelist supply if we dont sold out
2067     function setwlsupply(uint256 _newsupply) public onlyOwner {
2068     WlSupply = _newsupply;
2069   }
2070 
2071  /// @dev set your baseuri
2072   function setBaseURI(string memory _newBaseURI) public onlyOwner {
2073     baseURI = _newBaseURI;
2074   }
2075 
2076    /// @dev set hidden uri
2077   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2078     notRevealedUri = _notRevealedURI;
2079   }
2080 
2081  /// @dev to pause and unpause your contract(use booleans true or false)
2082   function pause(bool _state) public onlyOwner {
2083     paused = _state;
2084   }
2085 
2086      /// @dev activate whitelist sale(use booleans true or false)
2087     function togglepreSale(bool _state) external onlyOwner {
2088         preSale = _state;
2089     }
2090 
2091   
2092   /// @dev withdraw funds from contract
2093   function withdraw() public payable onlyOwner nonReentrant {
2094       uint256 balance = address(this).balance;
2095       payable(_msgSenderERC721A()).transfer(balance);
2096   }
2097 
2098 
2099   /// Opensea Royalties
2100 
2101     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2102     super.transferFrom(from, to, tokenId);
2103   }
2104 
2105   function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2106     super.safeTransferFrom(from, to, tokenId);
2107   }
2108 
2109   function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
2110     super.safeTransferFrom(from, to, tokenId, data);
2111   }  
2112 }