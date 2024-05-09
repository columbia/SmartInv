1 // SPDX-License-Identifier: MIT
2 // File: IOperatorFilterRegistry.sol
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
34 // File: OperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 /**
41  * @title  OperatorFilterer
42  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
43  *         registrant's entries in the OperatorFilterRegistry.
44  */
45 abstract contract OperatorFilterer {
46     error OperatorNotAllowed(address operator);
47 
48     IOperatorFilterRegistry constant OPERATOR_FILTER_REGISTRY =
49         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
50 
51     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
52         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
53         // will not revert, but the contract will need to be registered with the registry once it is deployed in
54         // order for the modifier to filter addresses.
55         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
56             if (subscribe) {
57                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
58             } else {
59                 if (subscriptionOrRegistrantToCopy != address(0)) {
60                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
61                 } else {
62                     OPERATOR_FILTER_REGISTRY.register(address(this));
63                 }
64             }
65         }
66     }
67 
68     modifier onlyAllowedOperator(address from) virtual {
69         // Check registry code length to facilitate testing in environments without a deployed registry.
70         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
71             // Allow spending tokens from addresses with balance
72             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
73             // from an EOA.
74             if (from == msg.sender) {
75                 _;
76                 return;
77             }
78             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
79                 revert OperatorNotAllowed(msg.sender);
80             }
81         }
82         _;
83     }
84 
85     modifier onlyAllowedOperatorApproval(address operator) virtual {
86         // Check registry code length to facilitate testing in environments without a deployed registry.
87         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
88             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
89                 revert OperatorNotAllowed(operator);
90             }
91         }
92         _;
93     }
94 }
95 
96 // File: DefaultOperatorFilterer.sol
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
112 // File: whitelist_flat.sol
113 
114 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
115 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
116 
117 
118 pragma solidity ^0.8.4;
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
339 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
340 
341 
342 // ERC721A Contracts v4.2.2
343 // Creator: Chiru Labs
344 
345 pragma solidity ^0.8.4;
346 
347 /**
348  * @dev Interface of ERC721A.
349  */
350 interface IERC721A {
351     /**
352      * The caller must own the token or be an approved operator.
353      */
354     error ApprovalCallerNotOwnerNorApproved();
355 
356     /**
357      * The token does not exist.
358      */
359     error ApprovalQueryForNonexistentToken();
360 
361     /**
362      * Cannot query the balance for the zero address.
363      */
364     error BalanceQueryForZeroAddress();
365 
366     /**
367      * Cannot mint to the zero address.
368      */
369     error MintToZeroAddress();
370 
371     /**
372      * The quantity of tokens minted must be more than zero.
373      */
374     error MintZeroQuantity();
375 
376     /**
377      * The token does not exist.
378      */
379     error OwnerQueryForNonexistentToken();
380 
381     /**
382      * The caller must own the token or be an approved operator.
383      */
384     error TransferCallerNotOwnerNorApproved();
385 
386     /**
387      * The token must be owned by `from`.
388      */
389     error TransferFromIncorrectOwner();
390 
391     /**
392      * Cannot safely transfer to a contract that does not implement the
393      * ERC721Receiver interface.
394      */
395     error TransferToNonERC721ReceiverImplementer();
396 
397     /**
398      * Cannot transfer to the zero address.
399      */
400     error TransferToZeroAddress();
401 
402     /**
403      * The token does not exist.
404      */
405     error URIQueryForNonexistentToken();
406 
407     /**
408      * The `quantity` minted with ERC2309 exceeds the safety limit.
409      */
410     error MintERC2309QuantityExceedsLimit();
411 
412     /**
413      * The `extraData` cannot be set on an unintialized ownership slot.
414      */
415     error OwnershipNotInitializedForExtraData();
416 
417     // =============================================================
418     //                            STRUCTS
419     // =============================================================
420 
421     struct TokenOwnership {
422         // The address of the owner.
423         address addr;
424         // Stores the start time of ownership with minimal overhead for tokenomics.
425         uint64 startTimestamp;
426         // Whether the token has been burned.
427         bool burned;
428         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
429         uint24 extraData;
430     }
431 
432     // =============================================================
433     //                         TOKEN COUNTERS
434     // =============================================================
435 
436     /**
437      * @dev Returns the total number of tokens in existence.
438      * Burned tokens will reduce the count.
439      * To get the total number of tokens minted, please see {_totalMinted}.
440      */
441     function totalSupply() external view returns (uint256);
442 
443     // =============================================================
444     //                            IERC165
445     // =============================================================
446 
447     /**
448      * @dev Returns true if this contract implements the interface defined by
449      * `interfaceId`. See the corresponding
450      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
451      * to learn more about how these ids are created.
452      *
453      * This function call must use less than 30000 gas.
454      */
455     function supportsInterface(bytes4 interfaceId) external view returns (bool);
456 
457     // =============================================================
458     //                            IERC721
459     // =============================================================
460 
461     /**
462      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
463      */
464     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
465 
466     /**
467      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
468      */
469     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
470 
471     /**
472      * @dev Emitted when `owner` enables or disables
473      * (`approved`) `operator` to manage all of its assets.
474      */
475     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
476 
477     /**
478      * @dev Returns the number of tokens in `owner`'s account.
479      */
480     function balanceOf(address owner) external view returns (uint256 balance);
481 
482     /**
483      * @dev Returns the owner of the `tokenId` token.
484      *
485      * Requirements:
486      *
487      * - `tokenId` must exist.
488      */
489     function ownerOf(uint256 tokenId) external view returns (address owner);
490 
491     /**
492      * @dev Safely transfers `tokenId` token from `from` to `to`,
493      * checking first that contract recipients are aware of the ERC721 protocol
494      * to prevent tokens from being forever locked.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `tokenId` token must exist and be owned by `from`.
501      * - If the caller is not `from`, it must be have been allowed to move
502      * this token by either {approve} or {setApprovalForAll}.
503      * - If `to` refers to a smart contract, it must implement
504      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
505      *
506      * Emits a {Transfer} event.
507      */
508     function safeTransferFrom(
509         address from,
510         address to,
511         uint256 tokenId,
512         bytes calldata data
513     ) external;
514 
515     /**
516      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
517      */
518     function safeTransferFrom(
519         address from,
520         address to,
521         uint256 tokenId
522     ) external;
523 
524     /**
525      * @dev Transfers `tokenId` from `from` to `to`.
526      *
527      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
528      * whenever possible.
529      *
530      * Requirements:
531      *
532      * - `from` cannot be the zero address.
533      * - `to` cannot be the zero address.
534      * - `tokenId` token must be owned by `from`.
535      * - If the caller is not `from`, it must be approved to move this token
536      * by either {approve} or {setApprovalForAll}.
537      *
538      * Emits a {Transfer} event.
539      */
540     function transferFrom(
541         address from,
542         address to,
543         uint256 tokenId
544     ) external;
545 
546     /**
547      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
548      * The approval is cleared when the token is transferred.
549      *
550      * Only a single account can be approved at a time, so approving the
551      * zero address clears previous approvals.
552      *
553      * Requirements:
554      *
555      * - The caller must own the token or be an approved operator.
556      * - `tokenId` must exist.
557      *
558      * Emits an {Approval} event.
559      */
560     function approve(address to, uint256 tokenId) external;
561 
562     /**
563      * @dev Approve or remove `operator` as an operator for the caller.
564      * Operators can call {transferFrom} or {safeTransferFrom}
565      * for any token owned by the caller.
566      *
567      * Requirements:
568      *
569      * - The `operator` cannot be the caller.
570      *
571      * Emits an {ApprovalForAll} event.
572      */
573     function setApprovalForAll(address operator, bool _approved) external;
574 
575     /**
576      * @dev Returns the account approved for `tokenId` token.
577      *
578      * Requirements:
579      *
580      * - `tokenId` must exist.
581      */
582     function getApproved(uint256 tokenId) external view returns (address operator);
583 
584     /**
585      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
586      *
587      * See {setApprovalForAll}.
588      */
589     function isApprovedForAll(address owner, address operator) external view returns (bool);
590 
591     // =============================================================
592     //                        IERC721Metadata
593     // =============================================================
594 
595     /**
596      * @dev Returns the token collection name.
597      */
598     function name() external view returns (string memory);
599 
600     /**
601      * @dev Returns the token collection symbol.
602      */
603     function symbol() external view returns (string memory);
604 
605     /**
606      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
607      */
608     function tokenURI(uint256 tokenId) external view returns (string memory);
609 
610     // =============================================================
611     //                           IERC2309
612     // =============================================================
613 
614     /**
615      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
616      * (inclusive) is transferred from `from` to `to`, as defined in the
617      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
618      *
619      * See {_mintERC2309} for more details.
620      */
621     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
622 }
623 
624 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
625 
626 
627 // ERC721A Contracts v4.2.2
628 // Creator: Chiru Labs
629 
630 pragma solidity ^0.8.4;
631 
632 
633 /**
634  * @dev Interface of ERC721 token receiver.
635  */
636 interface ERC721A__IERC721Receiver {
637     function onERC721Received(
638         address operator,
639         address from,
640         uint256 tokenId,
641         bytes calldata data
642     ) external returns (bytes4);
643 }
644 
645 /**
646  * @title ERC721A
647  *
648  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
649  * Non-Fungible Token Standard, including the Metadata extension.
650  * Optimized for lower gas during batch mints.
651  *
652  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
653  * starting from `_startTokenId()`.
654  *
655  * Assumptions:
656  *
657  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
658  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
659  */
660 contract ERC721A is IERC721A {
661     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
662     struct TokenApprovalRef {
663         address value;
664     }
665 
666     // =============================================================
667     //                           CONSTANTS
668     // =============================================================
669 
670     // Mask of an entry in packed address data.
671     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
672 
673     // The bit position of `numberMinted` in packed address data.
674     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
675 
676     // The bit position of `numberBurned` in packed address data.
677     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
678 
679     // The bit position of `aux` in packed address data.
680     uint256 private constant _BITPOS_AUX = 192;
681 
682     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
683     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
684 
685     // The bit position of `startTimestamp` in packed ownership.
686     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
687 
688     // The bit mask of the `burned` bit in packed ownership.
689     uint256 private constant _BITMASK_BURNED = 1 << 224;
690 
691     // The bit position of the `nextInitialized` bit in packed ownership.
692     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
693 
694     // The bit mask of the `nextInitialized` bit in packed ownership.
695     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
696 
697     // The bit position of `extraData` in packed ownership.
698     uint256 private constant _BITPOS_EXTRA_DATA = 232;
699 
700     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
701     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
702 
703     // The mask of the lower 160 bits for addresses.
704     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
705 
706     // The maximum `quantity` that can be minted with {_mintERC2309}.
707     // This limit is to prevent overflows on the address data entries.
708     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
709     // is required to cause an overflow, which is unrealistic.
710     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
711 
712     // The `Transfer` event signature is given by:
713     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
714     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
715         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
716 
717     // =============================================================
718     //                            STORAGE
719     // =============================================================
720 
721     // The next token ID to be minted.
722     uint256 private _currentIndex;
723 
724     // The number of tokens burned.
725     uint256 private _burnCounter;
726 
727     // Token name
728     string private _name;
729 
730     // Token symbol
731     string private _symbol;
732 
733     // Mapping from token ID to ownership details
734     // An empty struct value does not necessarily mean the token is unowned.
735     // See {_packedOwnershipOf} implementation for details.
736     //
737     // Bits Layout:
738     // - [0..159]   `addr`
739     // - [160..223] `startTimestamp`
740     // - [224]      `burned`
741     // - [225]      `nextInitialized`
742     // - [232..255] `extraData`
743     mapping(uint256 => uint256) private _packedOwnerships;
744 
745     // Mapping owner address to address data.
746     //
747     // Bits Layout:
748     // - [0..63]    `balance`
749     // - [64..127]  `numberMinted`
750     // - [128..191] `numberBurned`
751     // - [192..255] `aux`
752     mapping(address => uint256) private _packedAddressData;
753 
754     // Mapping from token ID to approved address.
755     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
756 
757     // Mapping from owner to operator approvals
758     mapping(address => mapping(address => bool)) private _operatorApprovals;
759 
760     // =============================================================
761     //                          CONSTRUCTOR
762     // =============================================================
763 
764     constructor(string memory name_, string memory symbol_) {
765         _name = name_;
766         _symbol = symbol_;
767         _currentIndex = _startTokenId();
768     }
769 
770     // =============================================================
771     //                   TOKEN COUNTING OPERATIONS
772     // =============================================================
773 
774     /**
775      * @dev Returns the starting token ID.
776      * To change the starting token ID, please override this function.
777      */
778     function _startTokenId() internal view virtual returns (uint256) {
779         return 0;
780     }
781 
782     /**
783      * @dev Returns the next token ID to be minted.
784      */
785     function _nextTokenId() internal view virtual returns (uint256) {
786         return _currentIndex;
787     }
788 
789     /**
790      * @dev Returns the total number of tokens in existence.
791      * Burned tokens will reduce the count.
792      * To get the total number of tokens minted, please see {_totalMinted}.
793      */
794     function totalSupply() public view virtual override returns (uint256) {
795         // Counter underflow is impossible as _burnCounter cannot be incremented
796         // more than `_currentIndex - _startTokenId()` times.
797         unchecked {
798             return _currentIndex - _burnCounter - _startTokenId();
799         }
800     }
801 
802     /**
803      * @dev Returns the total amount of tokens minted in the contract.
804      */
805     function _totalMinted() internal view virtual returns (uint256) {
806         // Counter underflow is impossible as `_currentIndex` does not decrement,
807         // and it is initialized to `_startTokenId()`.
808         unchecked {
809             return _currentIndex - _startTokenId();
810         }
811     }
812 
813     /**
814      * @dev Returns the total number of tokens burned.
815      */
816     function _totalBurned() internal view virtual returns (uint256) {
817         return _burnCounter;
818     }
819 
820     // =============================================================
821     //                    ADDRESS DATA OPERATIONS
822     // =============================================================
823 
824     /**
825      * @dev Returns the number of tokens in `owner`'s account.
826      */
827     function balanceOf(address owner) public view virtual override returns (uint256) {
828         if (owner == address(0)) revert BalanceQueryForZeroAddress();
829         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
830     }
831 
832     /**
833      * Returns the number of tokens minted by `owner`.
834      */
835     function _numberMinted(address owner) internal view returns (uint256) {
836         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
837     }
838 
839     /**
840      * Returns the number of tokens burned by or on behalf of `owner`.
841      */
842     function _numberBurned(address owner) internal view returns (uint256) {
843         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
844     }
845 
846     /**
847      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
848      */
849     function _getAux(address owner) internal view returns (uint64) {
850         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
851     }
852 
853     /**
854      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
855      * If there are multiple variables, please pack them into a uint64.
856      */
857     function _setAux(address owner, uint64 aux) internal virtual {
858         uint256 packed = _packedAddressData[owner];
859         uint256 auxCasted;
860         // Cast `aux` with assembly to avoid redundant masking.
861         assembly {
862             auxCasted := aux
863         }
864         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
865         _packedAddressData[owner] = packed;
866     }
867 
868     // =============================================================
869     //                            IERC165
870     // =============================================================
871 
872     /**
873      * @dev Returns true if this contract implements the interface defined by
874      * `interfaceId`. See the corresponding
875      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
876      * to learn more about how these ids are created.
877      *
878      * This function call must use less than 30000 gas.
879      */
880     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
881         // The interface IDs are constants representing the first 4 bytes
882         // of the XOR of all function selectors in the interface.
883         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
884         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
885         return
886             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
887             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
888             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
889     }
890 
891     // =============================================================
892     //                        IERC721Metadata
893     // =============================================================
894 
895     /**
896      * @dev Returns the token collection name.
897      */
898     function name() public view virtual override returns (string memory) {
899         return _name;
900     }
901 
902     /**
903      * @dev Returns the token collection symbol.
904      */
905     function symbol() public view virtual override returns (string memory) {
906         return _symbol;
907     }
908 
909     /**
910      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
911      */
912     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
913         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
914 
915         string memory baseURI = _baseURI();
916         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
917     }
918 
919     /**
920      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
921      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
922      * by default, it can be overridden in child contracts.
923      */
924     function _baseURI() internal view virtual returns (string memory) {
925         return '';
926     }
927 
928     // =============================================================
929     //                     OWNERSHIPS OPERATIONS
930     // =============================================================
931 
932     /**
933      * @dev Returns the owner of the `tokenId` token.
934      *
935      * Requirements:
936      *
937      * - `tokenId` must exist.
938      */
939     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
940         return address(uint160(_packedOwnershipOf(tokenId)));
941     }
942 
943     /**
944      * @dev Gas spent here starts off proportional to the maximum mint batch size.
945      * It gradually moves to O(1) as tokens get transferred around over time.
946      */
947     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
948         return _unpackedOwnership(_packedOwnershipOf(tokenId));
949     }
950 
951     /**
952      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
953      */
954     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
955         return _unpackedOwnership(_packedOwnerships[index]);
956     }
957 
958     /**
959      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
960      */
961     function _initializeOwnershipAt(uint256 index) internal virtual {
962         if (_packedOwnerships[index] == 0) {
963             _packedOwnerships[index] = _packedOwnershipOf(index);
964         }
965     }
966 
967     /**
968      * Returns the packed ownership data of `tokenId`.
969      */
970     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
971         uint256 curr = tokenId;
972 
973         unchecked {
974             if (_startTokenId() <= curr)
975                 if (curr < _currentIndex) {
976                     uint256 packed = _packedOwnerships[curr];
977                     // If not burned.
978                     if (packed & _BITMASK_BURNED == 0) {
979                         // Invariant:
980                         // There will always be an initialized ownership slot
981                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
982                         // before an unintialized ownership slot
983                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
984                         // Hence, `curr` will not underflow.
985                         //
986                         // We can directly compare the packed value.
987                         // If the address is zero, packed will be zero.
988                         while (packed == 0) {
989                             packed = _packedOwnerships[--curr];
990                         }
991                         return packed;
992                     }
993                 }
994         }
995         revert OwnerQueryForNonexistentToken();
996     }
997 
998     /**
999      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1000      */
1001     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1002         ownership.addr = address(uint160(packed));
1003         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1004         ownership.burned = packed & _BITMASK_BURNED != 0;
1005         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1006     }
1007 
1008     /**
1009      * @dev Packs ownership data into a single uint256.
1010      */
1011     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1012         assembly {
1013             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1014             owner := and(owner, _BITMASK_ADDRESS)
1015             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1016             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1017         }
1018     }
1019 
1020     /**
1021      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1022      */
1023     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1024         // For branchless setting of the `nextInitialized` flag.
1025         assembly {
1026             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1027             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1028         }
1029     }
1030 
1031     // =============================================================
1032     //                      APPROVAL OPERATIONS
1033     // =============================================================
1034 
1035     /**
1036      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1037      * The approval is cleared when the token is transferred.
1038      *
1039      * Only a single account can be approved at a time, so approving the
1040      * zero address clears previous approvals.
1041      *
1042      * Requirements:
1043      *
1044      * - The caller must own the token or be an approved operator.
1045      * - `tokenId` must exist.
1046      *
1047      * Emits an {Approval} event.
1048      */
1049     function approve(address to, uint256 tokenId) public virtual override {
1050         address owner = ownerOf(tokenId);
1051 
1052         if (_msgSenderERC721A() != owner)
1053             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1054                 revert ApprovalCallerNotOwnerNorApproved();
1055             }
1056 
1057         _tokenApprovals[tokenId].value = to;
1058         emit Approval(owner, to, tokenId);
1059     }
1060 
1061     /**
1062      * @dev Returns the account approved for `tokenId` token.
1063      *
1064      * Requirements:
1065      *
1066      * - `tokenId` must exist.
1067      */
1068     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1069         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1070 
1071         return _tokenApprovals[tokenId].value;
1072     }
1073 
1074     /**
1075      * @dev Approve or remove `operator` as an operator for the caller.
1076      * Operators can call {transferFrom} or {safeTransferFrom}
1077      * for any token owned by the caller.
1078      *
1079      * Requirements:
1080      *
1081      * - The `operator` cannot be the caller.
1082      *
1083      * Emits an {ApprovalForAll} event.
1084      */
1085     function setApprovalForAll(address operator, bool approved) public virtual override {
1086         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1087         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1088     }
1089 
1090     /**
1091      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1092      *
1093      * See {setApprovalForAll}.
1094      */
1095     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1096         return _operatorApprovals[owner][operator];
1097     }
1098 
1099     /**
1100      * @dev Returns whether `tokenId` exists.
1101      *
1102      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1103      *
1104      * Tokens start existing when they are minted. See {_mint}.
1105      */
1106     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1107         return
1108             _startTokenId() <= tokenId &&
1109             tokenId < _currentIndex && // If within bounds,
1110             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1111     }
1112 
1113     /**
1114      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1115      */
1116     function _isSenderApprovedOrOwner(
1117         address approvedAddress,
1118         address owner,
1119         address msgSender
1120     ) private pure returns (bool result) {
1121         assembly {
1122             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1123             owner := and(owner, _BITMASK_ADDRESS)
1124             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1125             msgSender := and(msgSender, _BITMASK_ADDRESS)
1126             // `msgSender == owner || msgSender == approvedAddress`.
1127             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1128         }
1129     }
1130 
1131     /**
1132      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1133      */
1134     function _getApprovedSlotAndAddress(uint256 tokenId)
1135         private
1136         view
1137         returns (uint256 approvedAddressSlot, address approvedAddress)
1138     {
1139         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1140         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1141         assembly {
1142             approvedAddressSlot := tokenApproval.slot
1143             approvedAddress := sload(approvedAddressSlot)
1144         }
1145     }
1146 
1147     // =============================================================
1148     //                      TRANSFER OPERATIONS
1149     // =============================================================
1150 
1151     /**
1152      * @dev Transfers `tokenId` from `from` to `to`.
1153      *
1154      * Requirements:
1155      *
1156      * - `from` cannot be the zero address.
1157      * - `to` cannot be the zero address.
1158      * - `tokenId` token must be owned by `from`.
1159      * - If the caller is not `from`, it must be approved to move this token
1160      * by either {approve} or {setApprovalForAll}.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function transferFrom(
1165         address from,
1166         address to,
1167         uint256 tokenId
1168     ) public virtual override {
1169         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1170 
1171         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1172 
1173         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1174 
1175         // The nested ifs save around 20+ gas over a compound boolean condition.
1176         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1177             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1178 
1179         if (to == address(0)) revert TransferToZeroAddress();
1180 
1181         _beforeTokenTransfers(from, to, tokenId, 1);
1182 
1183         // Clear approvals from the previous owner.
1184         assembly {
1185             if approvedAddress {
1186                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1187                 sstore(approvedAddressSlot, 0)
1188             }
1189         }
1190 
1191         // Underflow of the sender's balance is impossible because we check for
1192         // ownership above and the recipient's balance can't realistically overflow.
1193         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1194         unchecked {
1195             // We can directly increment and decrement the balances.
1196             --_packedAddressData[from]; // Updates: `balance -= 1`.
1197             ++_packedAddressData[to]; // Updates: `balance += 1`.
1198 
1199             // Updates:
1200             // - `address` to the next owner.
1201             // - `startTimestamp` to the timestamp of transfering.
1202             // - `burned` to `false`.
1203             // - `nextInitialized` to `true`.
1204             _packedOwnerships[tokenId] = _packOwnershipData(
1205                 to,
1206                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1207             );
1208 
1209             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1210             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1211                 uint256 nextTokenId = tokenId + 1;
1212                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1213                 if (_packedOwnerships[nextTokenId] == 0) {
1214                     // If the next slot is within bounds.
1215                     if (nextTokenId != _currentIndex) {
1216                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1217                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1218                     }
1219                 }
1220             }
1221         }
1222 
1223         emit Transfer(from, to, tokenId);
1224         _afterTokenTransfers(from, to, tokenId, 1);
1225     }
1226 
1227     /**
1228      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1229      */
1230     function safeTransferFrom(
1231         address from,
1232         address to,
1233         uint256 tokenId
1234     ) public virtual override {
1235         safeTransferFrom(from, to, tokenId, '');
1236     }
1237 
1238     /**
1239      * @dev Safely transfers `tokenId` token from `from` to `to`.
1240      *
1241      * Requirements:
1242      *
1243      * - `from` cannot be the zero address.
1244      * - `to` cannot be the zero address.
1245      * - `tokenId` token must exist and be owned by `from`.
1246      * - If the caller is not `from`, it must be approved to move this token
1247      * by either {approve} or {setApprovalForAll}.
1248      * - If `to` refers to a smart contract, it must implement
1249      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1250      *
1251      * Emits a {Transfer} event.
1252      */
1253     function safeTransferFrom(
1254         address from,
1255         address to,
1256         uint256 tokenId,
1257         bytes memory _data
1258     ) public virtual override {
1259         transferFrom(from, to, tokenId);
1260         if (to.code.length != 0)
1261             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1262                 revert TransferToNonERC721ReceiverImplementer();
1263             }
1264     }
1265 
1266     /**
1267      * @dev Hook that is called before a set of serially-ordered token IDs
1268      * are about to be transferred. This includes minting.
1269      * And also called before burning one token.
1270      *
1271      * `startTokenId` - the first token ID to be transferred.
1272      * `quantity` - the amount to be transferred.
1273      *
1274      * Calling conditions:
1275      *
1276      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1277      * transferred to `to`.
1278      * - When `from` is zero, `tokenId` will be minted for `to`.
1279      * - When `to` is zero, `tokenId` will be burned by `from`.
1280      * - `from` and `to` are never both zero.
1281      */
1282     function _beforeTokenTransfers(
1283         address from,
1284         address to,
1285         uint256 startTokenId,
1286         uint256 quantity
1287     ) internal virtual {}
1288 
1289     /**
1290      * @dev Hook that is called after a set of serially-ordered token IDs
1291      * have been transferred. This includes minting.
1292      * And also called after one token has been burned.
1293      *
1294      * `startTokenId` - the first token ID to be transferred.
1295      * `quantity` - the amount to be transferred.
1296      *
1297      * Calling conditions:
1298      *
1299      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1300      * transferred to `to`.
1301      * - When `from` is zero, `tokenId` has been minted for `to`.
1302      * - When `to` is zero, `tokenId` has been burned by `from`.
1303      * - `from` and `to` are never both zero.
1304      */
1305     function _afterTokenTransfers(
1306         address from,
1307         address to,
1308         uint256 startTokenId,
1309         uint256 quantity
1310     ) internal virtual {}
1311 
1312     /**
1313      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1314      *
1315      * `from` - Previous owner of the given token ID.
1316      * `to` - Target address that will receive the token.
1317      * `tokenId` - Token ID to be transferred.
1318      * `_data` - Optional data to send along with the call.
1319      *
1320      * Returns whether the call correctly returned the expected magic value.
1321      */
1322     function _checkContractOnERC721Received(
1323         address from,
1324         address to,
1325         uint256 tokenId,
1326         bytes memory _data
1327     ) private returns (bool) {
1328         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1329             bytes4 retval
1330         ) {
1331             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1332         } catch (bytes memory reason) {
1333             if (reason.length == 0) {
1334                 revert TransferToNonERC721ReceiverImplementer();
1335             } else {
1336                 assembly {
1337                     revert(add(32, reason), mload(reason))
1338                 }
1339             }
1340         }
1341     }
1342 
1343     // =============================================================
1344     //                        MINT OPERATIONS
1345     // =============================================================
1346 
1347     /**
1348      * @dev Mints `quantity` tokens and transfers them to `to`.
1349      *
1350      * Requirements:
1351      *
1352      * - `to` cannot be the zero address.
1353      * - `quantity` must be greater than 0.
1354      *
1355      * Emits a {Transfer} event for each mint.
1356      */
1357     function _mint(address to, uint256 quantity) internal virtual {
1358         uint256 startTokenId = _currentIndex;
1359         if (quantity == 0) revert MintZeroQuantity();
1360 
1361         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1362 
1363         // Overflows are incredibly unrealistic.
1364         // `balance` and `numberMinted` have a maximum limit of 2**64.
1365         // `tokenId` has a maximum limit of 2**256.
1366         unchecked {
1367             // Updates:
1368             // - `balance += quantity`.
1369             // - `numberMinted += quantity`.
1370             //
1371             // We can directly add to the `balance` and `numberMinted`.
1372             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1373 
1374             // Updates:
1375             // - `address` to the owner.
1376             // - `startTimestamp` to the timestamp of minting.
1377             // - `burned` to `false`.
1378             // - `nextInitialized` to `quantity == 1`.
1379             _packedOwnerships[startTokenId] = _packOwnershipData(
1380                 to,
1381                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1382             );
1383 
1384             uint256 toMasked;
1385             uint256 end = startTokenId + quantity;
1386 
1387             // Use assembly to loop and emit the `Transfer` event for gas savings.
1388             // The duplicated `log4` removes an extra check and reduces stack juggling.
1389             // The assembly, together with the surrounding Solidity code, have been
1390             // delicately arranged to nudge the compiler into producing optimized opcodes.
1391             assembly {
1392                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1393                 toMasked := and(to, _BITMASK_ADDRESS)
1394                 // Emit the `Transfer` event.
1395                 log4(
1396                     0, // Start of data (0, since no data).
1397                     0, // End of data (0, since no data).
1398                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1399                     0, // `address(0)`.
1400                     toMasked, // `to`.
1401                     startTokenId // `tokenId`.
1402                 )
1403 
1404                 for {
1405                     let tokenId := add(startTokenId, 1)
1406                 } iszero(eq(tokenId, end)) {
1407                     tokenId := add(tokenId, 1)
1408                 } {
1409                     // Emit the `Transfer` event. Similar to above.
1410                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1411                 }
1412             }
1413             if (toMasked == 0) revert MintToZeroAddress();
1414 
1415             _currentIndex = end;
1416         }
1417         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1418     }
1419 
1420     /**
1421      * @dev Mints `quantity` tokens and transfers them to `to`.
1422      *
1423      * This function is intended for efficient minting only during contract creation.
1424      *
1425      * It emits only one {ConsecutiveTransfer} as defined in
1426      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1427      * instead of a sequence of {Transfer} event(s).
1428      *
1429      * Calling this function outside of contract creation WILL make your contract
1430      * non-compliant with the ERC721 standard.
1431      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1432      * {ConsecutiveTransfer} event is only permissible during contract creation.
1433      *
1434      * Requirements:
1435      *
1436      * - `to` cannot be the zero address.
1437      * - `quantity` must be greater than 0.
1438      *
1439      * Emits a {ConsecutiveTransfer} event.
1440      */
1441     function _mintERC2309(address to, uint256 quantity) internal virtual {
1442         uint256 startTokenId = _currentIndex;
1443         if (to == address(0)) revert MintToZeroAddress();
1444         if (quantity == 0) revert MintZeroQuantity();
1445         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1446 
1447         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1448 
1449         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1450         unchecked {
1451             // Updates:
1452             // - `balance += quantity`.
1453             // - `numberMinted += quantity`.
1454             //
1455             // We can directly add to the `balance` and `numberMinted`.
1456             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1457 
1458             // Updates:
1459             // - `address` to the owner.
1460             // - `startTimestamp` to the timestamp of minting.
1461             // - `burned` to `false`.
1462             // - `nextInitialized` to `quantity == 1`.
1463             _packedOwnerships[startTokenId] = _packOwnershipData(
1464                 to,
1465                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1466             );
1467 
1468             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1469 
1470             _currentIndex = startTokenId + quantity;
1471         }
1472         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1473     }
1474 
1475     /**
1476      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1477      *
1478      * Requirements:
1479      *
1480      * - If `to` refers to a smart contract, it must implement
1481      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1482      * - `quantity` must be greater than 0.
1483      *
1484      * See {_mint}.
1485      *
1486      * Emits a {Transfer} event for each mint.
1487      */
1488     function _safeMint(
1489         address to,
1490         uint256 quantity,
1491         bytes memory _data
1492     ) internal virtual {
1493         _mint(to, quantity);
1494 
1495         unchecked {
1496             if (to.code.length != 0) {
1497                 uint256 end = _currentIndex;
1498                 uint256 index = end - quantity;
1499                 do {
1500                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1501                         revert TransferToNonERC721ReceiverImplementer();
1502                     }
1503                 } while (index < end);
1504                 // Reentrancy protection.
1505                 if (_currentIndex != end) revert();
1506             }
1507         }
1508     }
1509 
1510     /**
1511      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1512      */
1513     function _safeMint(address to, uint256 quantity) internal virtual {
1514         _safeMint(to, quantity, '');
1515     }
1516 
1517     // =============================================================
1518     //                        BURN OPERATIONS
1519     // =============================================================
1520 
1521     /**
1522      * @dev Equivalent to `_burn(tokenId, false)`.
1523      */
1524     function _burn(uint256 tokenId) internal virtual {
1525         _burn(tokenId, false);
1526     }
1527 
1528     /**
1529      * @dev Destroys `tokenId`.
1530      * The approval is cleared when the token is burned.
1531      *
1532      * Requirements:
1533      *
1534      * - `tokenId` must exist.
1535      *
1536      * Emits a {Transfer} event.
1537      */
1538     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1539         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1540 
1541         address from = address(uint160(prevOwnershipPacked));
1542 
1543         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1544 
1545         if (approvalCheck) {
1546             // The nested ifs save around 20+ gas over a compound boolean condition.
1547             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1548                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1549         }
1550 
1551         _beforeTokenTransfers(from, address(0), tokenId, 1);
1552 
1553         // Clear approvals from the previous owner.
1554         assembly {
1555             if approvedAddress {
1556                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1557                 sstore(approvedAddressSlot, 0)
1558             }
1559         }
1560 
1561         // Underflow of the sender's balance is impossible because we check for
1562         // ownership above and the recipient's balance can't realistically overflow.
1563         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1564         unchecked {
1565             // Updates:
1566             // - `balance -= 1`.
1567             // - `numberBurned += 1`.
1568             //
1569             // We can directly decrement the balance, and increment the number burned.
1570             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1571             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1572 
1573             // Updates:
1574             // - `address` to the last owner.
1575             // - `startTimestamp` to the timestamp of burning.
1576             // - `burned` to `true`.
1577             // - `nextInitialized` to `true`.
1578             _packedOwnerships[tokenId] = _packOwnershipData(
1579                 from,
1580                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1581             );
1582 
1583             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1584             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1585                 uint256 nextTokenId = tokenId + 1;
1586                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1587                 if (_packedOwnerships[nextTokenId] == 0) {
1588                     // If the next slot is within bounds.
1589                     if (nextTokenId != _currentIndex) {
1590                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1591                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1592                     }
1593                 }
1594             }
1595         }
1596 
1597         emit Transfer(from, address(0), tokenId);
1598         _afterTokenTransfers(from, address(0), tokenId, 1);
1599 
1600         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1601         unchecked {
1602             _burnCounter++;
1603         }
1604     }
1605 
1606     // =============================================================
1607     //                     EXTRA DATA OPERATIONS
1608     // =============================================================
1609 
1610     /**
1611      * @dev Directly sets the extra data for the ownership data `index`.
1612      */
1613     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1614         uint256 packed = _packedOwnerships[index];
1615         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1616         uint256 extraDataCasted;
1617         // Cast `extraData` with assembly to avoid redundant masking.
1618         assembly {
1619             extraDataCasted := extraData
1620         }
1621         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1622         _packedOwnerships[index] = packed;
1623     }
1624 
1625     /**
1626      * @dev Called during each token transfer to set the 24bit `extraData` field.
1627      * Intended to be overridden by the cosumer contract.
1628      *
1629      * `previousExtraData` - the value of `extraData` before transfer.
1630      *
1631      * Calling conditions:
1632      *
1633      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1634      * transferred to `to`.
1635      * - When `from` is zero, `tokenId` will be minted for `to`.
1636      * - When `to` is zero, `tokenId` will be burned by `from`.
1637      * - `from` and `to` are never both zero.
1638      */
1639     function _extraData(
1640         address from,
1641         address to,
1642         uint24 previousExtraData
1643     ) internal view virtual returns (uint24) {}
1644 
1645     /**
1646      * @dev Returns the next extra data for the packed ownership data.
1647      * The returned result is shifted into position.
1648      */
1649     function _nextExtraData(
1650         address from,
1651         address to,
1652         uint256 prevOwnershipPacked
1653     ) private view returns (uint256) {
1654         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1655         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1656     }
1657 
1658     // =============================================================
1659     //                       OTHER OPERATIONS
1660     // =============================================================
1661 
1662     /**
1663      * @dev Returns the message sender (defaults to `msg.sender`).
1664      *
1665      * If you are writing GSN compatible contracts, you need to override this function.
1666      */
1667     function _msgSenderERC721A() internal view virtual returns (address) {
1668         return msg.sender;
1669     }
1670 
1671     /**
1672      * @dev Converts a uint256 to its ASCII string decimal representation.
1673      */
1674     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1675         assembly {
1676             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1677             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1678             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1679             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1680             let m := add(mload(0x40), 0xa0)
1681             // Update the free memory pointer to allocate.
1682             mstore(0x40, m)
1683             // Assign the `str` to the end.
1684             str := sub(m, 0x20)
1685             // Zeroize the slot after the string.
1686             mstore(str, 0)
1687 
1688             // Cache the end of the memory to calculate the length later.
1689             let end := str
1690 
1691             // We write the string from rightmost digit to leftmost digit.
1692             // The following is essentially a do-while loop that also handles the zero case.
1693             // prettier-ignore
1694             for { let temp := value } 1 {} {
1695                 str := sub(str, 1)
1696                 // Write the character to the pointer.
1697                 // The ASCII index of the '0' character is 48.
1698                 mstore8(str, add(48, mod(temp, 10)))
1699                 // Keep dividing `temp` until zero.
1700                 temp := div(temp, 10)
1701                 // prettier-ignore
1702                 if iszero(temp) { break }
1703             }
1704 
1705             let length := sub(end, str)
1706             // Move the pointer 32 bytes leftwards to make room for the length.
1707             str := sub(str, 0x20)
1708             // Store the length.
1709             mstore(str, length)
1710         }
1711     }
1712 }
1713 
1714 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/IERC721AQueryable.sol
1715 
1716 
1717 // ERC721A Contracts v4.2.2
1718 // Creator: Chiru Labs
1719 
1720 pragma solidity ^0.8.4;
1721 
1722 
1723 /**
1724  * @dev Interface of ERC721AQueryable.
1725  */
1726 interface IERC721AQueryable is IERC721A {
1727     /**
1728      * Invalid query range (`start` >= `stop`).
1729      */
1730     error InvalidQueryRange();
1731 
1732     /**
1733      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1734      *
1735      * If the `tokenId` is out of bounds:
1736      *
1737      * - `addr = address(0)`
1738      * - `startTimestamp = 0`
1739      * - `burned = false`
1740      * - `extraData = 0`
1741      *
1742      * If the `tokenId` is burned:
1743      *
1744      * - `addr = <Address of owner before token was burned>`
1745      * - `startTimestamp = <Timestamp when token was burned>`
1746      * - `burned = true`
1747      * - `extraData = <Extra data when token was burned>`
1748      *
1749      * Otherwise:
1750      *
1751      * - `addr = <Address of owner>`
1752      * - `startTimestamp = <Timestamp of start of ownership>`
1753      * - `burned = false`
1754      * - `extraData = <Extra data at start of ownership>`
1755      */
1756     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1757 
1758     /**
1759      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1760      * See {ERC721AQueryable-explicitOwnershipOf}
1761      */
1762     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1763 
1764     /**
1765      * @dev Returns an array of token IDs owned by `owner`,
1766      * in the range [`start`, `stop`)
1767      * (i.e. `start <= tokenId < stop`).
1768      *
1769      * This function allows for tokens to be queried if the collection
1770      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1771      *
1772      * Requirements:
1773      *
1774      * - `start < stop`
1775      */
1776     function tokensOfOwnerIn(
1777         address owner,
1778         uint256 start,
1779         uint256 stop
1780     ) external view returns (uint256[] memory);
1781 
1782     /**
1783      * @dev Returns an array of token IDs owned by `owner`.
1784      *
1785      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1786      * It is meant to be called off-chain.
1787      *
1788      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1789      * multiple smaller scans if the collection is large enough to cause
1790      * an out-of-gas error (10K collections should be fine).
1791      */
1792     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1793 }
1794 
1795 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721AQueryable.sol
1796 
1797 
1798 // ERC721A Contracts v4.2.2
1799 // Creator: Chiru Labs
1800 
1801 pragma solidity ^0.8.4;
1802 
1803 
1804 
1805 /**
1806  * @title ERC721AQueryable.
1807  *
1808  * @dev ERC721A subclass with convenience query functions.
1809  */
1810 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1811     /**
1812      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1813      *
1814      * If the `tokenId` is out of bounds:
1815      *
1816      * - `addr = address(0)`
1817      * - `startTimestamp = 0`
1818      * - `burned = false`
1819      * - `extraData = 0`
1820      *
1821      * If the `tokenId` is burned:
1822      *
1823      * - `addr = <Address of owner before token was burned>`
1824      * - `startTimestamp = <Timestamp when token was burned>`
1825      * - `burned = true`
1826      * - `extraData = <Extra data when token was burned>`
1827      *
1828      * Otherwise:
1829      *
1830      * - `addr = <Address of owner>`
1831      * - `startTimestamp = <Timestamp of start of ownership>`
1832      * - `burned = false`
1833      * - `extraData = <Extra data at start of ownership>`
1834      */
1835     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1836         TokenOwnership memory ownership;
1837         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1838             return ownership;
1839         }
1840         ownership = _ownershipAt(tokenId);
1841         if (ownership.burned) {
1842             return ownership;
1843         }
1844         return _ownershipOf(tokenId);
1845     }
1846 
1847     /**
1848      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1849      * See {ERC721AQueryable-explicitOwnershipOf}
1850      */
1851     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1852         external
1853         view
1854         virtual
1855         override
1856         returns (TokenOwnership[] memory)
1857     {
1858         unchecked {
1859             uint256 tokenIdsLength = tokenIds.length;
1860             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1861             for (uint256 i; i != tokenIdsLength; ++i) {
1862                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1863             }
1864             return ownerships;
1865         }
1866     }
1867 
1868     /**
1869      * @dev Returns an array of token IDs owned by `owner`,
1870      * in the range [`start`, `stop`)
1871      * (i.e. `start <= tokenId < stop`).
1872      *
1873      * This function allows for tokens to be queried if the collection
1874      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1875      *
1876      * Requirements:
1877      *
1878      * - `start < stop`
1879      */
1880     function tokensOfOwnerIn(
1881         address owner,
1882         uint256 start,
1883         uint256 stop
1884     ) external view virtual override returns (uint256[] memory) {
1885         unchecked {
1886             if (start >= stop) revert InvalidQueryRange();
1887             uint256 tokenIdsIdx;
1888             uint256 stopLimit = _nextTokenId();
1889             // Set `start = max(start, _startTokenId())`.
1890             if (start < _startTokenId()) {
1891                 start = _startTokenId();
1892             }
1893             // Set `stop = min(stop, stopLimit)`.
1894             if (stop > stopLimit) {
1895                 stop = stopLimit;
1896             }
1897             uint256 tokenIdsMaxLength = balanceOf(owner);
1898             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1899             // to cater for cases where `balanceOf(owner)` is too big.
1900             if (start < stop) {
1901                 uint256 rangeLength = stop - start;
1902                 if (rangeLength < tokenIdsMaxLength) {
1903                     tokenIdsMaxLength = rangeLength;
1904                 }
1905             } else {
1906                 tokenIdsMaxLength = 0;
1907             }
1908             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1909             if (tokenIdsMaxLength == 0) {
1910                 return tokenIds;
1911             }
1912             // We need to call `explicitOwnershipOf(start)`,
1913             // because the slot at `start` may not be initialized.
1914             TokenOwnership memory ownership = explicitOwnershipOf(start);
1915             address currOwnershipAddr;
1916             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1917             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1918             if (!ownership.burned) {
1919                 currOwnershipAddr = ownership.addr;
1920             }
1921             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1922                 ownership = _ownershipAt(i);
1923                 if (ownership.burned) {
1924                     continue;
1925                 }
1926                 if (ownership.addr != address(0)) {
1927                     currOwnershipAddr = ownership.addr;
1928                 }
1929                 if (currOwnershipAddr == owner) {
1930                     tokenIds[tokenIdsIdx++] = i;
1931                 }
1932             }
1933             // Downsize the array to fit.
1934             assembly {
1935                 mstore(tokenIds, tokenIdsIdx)
1936             }
1937             return tokenIds;
1938         }
1939     }
1940 
1941     /**
1942      * @dev Returns an array of token IDs owned by `owner`.
1943      *
1944      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1945      * It is meant to be called off-chain.
1946      *
1947      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1948      * multiple smaller scans if the collection is large enough to cause
1949      * an out-of-gas error (10K collections should be fine).
1950      */
1951     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1952         unchecked {
1953             uint256 tokenIdsIdx;
1954             address currOwnershipAddr;
1955             uint256 tokenIdsLength = balanceOf(owner);
1956             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1957             TokenOwnership memory ownership;
1958             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1959                 ownership = _ownershipAt(i);
1960                 if (ownership.burned) {
1961                     continue;
1962                 }
1963                 if (ownership.addr != address(0)) {
1964                     currOwnershipAddr = ownership.addr;
1965                 }
1966                 if (currOwnershipAddr == owner) {
1967                     tokenIds[tokenIdsIdx++] = i;
1968                 }
1969             }
1970             return tokenIds;
1971         }
1972     }
1973 }
1974 
1975 // File: https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol
1976 
1977 
1978 pragma solidity >=0.8.0;
1979 
1980 /// @notice Simple single owner authorization mixin.
1981 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
1982 abstract contract Owned {
1983     /*//////////////////////////////////////////////////////////////
1984                                  EVENTS
1985     //////////////////////////////////////////////////////////////*/
1986 
1987     event OwnerUpdated(address indexed user, address indexed newOwner);
1988 
1989     /*//////////////////////////////////////////////////////////////
1990                             OWNERSHIP STORAGE
1991     //////////////////////////////////////////////////////////////*/
1992 
1993     address public owner;
1994 
1995     modifier onlyOwner() virtual {
1996         require(msg.sender == owner, "UNAUTHORIZED");
1997 
1998         _;
1999     }
2000 
2001     /*//////////////////////////////////////////////////////////////
2002                                CONSTRUCTOR
2003     //////////////////////////////////////////////////////////////*/
2004 
2005     constructor(address _owner) {
2006         owner = _owner;
2007 
2008         emit OwnerUpdated(address(0), _owner);
2009     }
2010 
2011     /*//////////////////////////////////////////////////////////////
2012                              OWNERSHIP LOGIC
2013     //////////////////////////////////////////////////////////////*/
2014 
2015     function setOwner(address newOwner) public virtual onlyOwner {
2016         owner = newOwner;
2017 
2018         emit OwnerUpdated(msg.sender, newOwner);
2019     }
2020 }
2021 
2022 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
2023 
2024 
2025 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
2026 
2027 pragma solidity ^0.8.0;
2028 
2029 /**
2030  * @dev String operations.
2031  */
2032 library Strings {
2033     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2034     uint8 private constant _ADDRESS_LENGTH = 20;
2035 
2036     /**
2037      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2038      */
2039     function toString(uint256 value) internal pure returns (string memory) {
2040         // Inspired by OraclizeAPI's implementation - MIT licence
2041         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2042 
2043         if (value == 0) {
2044             return "0";
2045         }
2046         uint256 temp = value;
2047         uint256 digits;
2048         while (temp != 0) {
2049             digits++;
2050             temp /= 10;
2051         }
2052         bytes memory buffer = new bytes(digits);
2053         while (value != 0) {
2054             digits -= 1;
2055             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2056             value /= 10;
2057         }
2058         return string(buffer);
2059     }
2060 
2061     /**
2062      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2063      */
2064     function toHexString(uint256 value) internal pure returns (string memory) {
2065         if (value == 0) {
2066             return "0x00";
2067         }
2068         uint256 temp = value;
2069         uint256 length = 0;
2070         while (temp != 0) {
2071             length++;
2072             temp >>= 8;
2073         }
2074         return toHexString(value, length);
2075     }
2076 
2077     /**
2078      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2079      */
2080     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2081         bytes memory buffer = new bytes(2 * length + 2);
2082         buffer[0] = "0";
2083         buffer[1] = "x";
2084         for (uint256 i = 2 * length + 1; i > 1; --i) {
2085             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2086             value >>= 4;
2087         }
2088         require(value == 0, "Strings: hex length insufficient");
2089         return string(buffer);
2090     }
2091 
2092     /**
2093      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2094      */
2095     function toHexString(address addr) internal pure returns (string memory) {
2096         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2097     }
2098 }
2099 
2100 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
2101 
2102 
2103 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2104 
2105 pragma solidity ^0.8.0;
2106 
2107 /**
2108  * @dev Provides information about the current execution context, including the
2109  * sender of the transaction and its data. While these are generally available
2110  * via msg.sender and msg.data, they should not be accessed in such a direct
2111  * manner, since when dealing with meta-transactions the account sending and
2112  * paying for execution may not be the actual sender (as far as an application
2113  * is concerned).
2114  *
2115  * This contract is only required for intermediate, library-like contracts.
2116  */
2117 abstract contract Context {
2118     function _msgSender() internal view virtual returns (address) {
2119         return msg.sender;
2120     }
2121 
2122     function _msgData() internal view virtual returns (bytes calldata) {
2123         return msg.data;
2124     }
2125 }
2126 
2127 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
2128 
2129 
2130 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
2131 
2132 pragma solidity ^0.8.1;
2133 
2134 /**
2135  * @dev Collection of functions related to the address type
2136  */
2137 library Address {
2138     /**
2139      * @dev Returns true if `account` is a contract.
2140      *
2141      * [IMPORTANT]
2142      * ====
2143      * It is unsafe to assume that an address for which this function returns
2144      * false is an externally-owned account (EOA) and not a contract.
2145      *
2146      * Among others, `isContract` will return false for the following
2147      * types of addresses:
2148      *
2149      *  - an externally-owned account
2150      *  - a contract in construction
2151      *  - an address where a contract will be created
2152      *  - an address where a contract lived, but was destroyed
2153      * ====
2154      *
2155      * [IMPORTANT]
2156      * ====
2157      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2158      *
2159      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2160      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2161      * constructor.
2162      * ====
2163      */
2164     function isContract(address account) internal view returns (bool) {
2165         // This method relies on extcodesize/address.code.length, which returns 0
2166         // for contracts in construction, since the code is only stored at the end
2167         // of the constructor execution.
2168 
2169         return account.code.length > 0;
2170     }
2171 
2172     /**
2173      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2174      * `recipient`, forwarding all available gas and reverting on errors.
2175      *
2176      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2177      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2178      * imposed by `transfer`, making them unable to receive funds via
2179      * `transfer`. {sendValue} removes this limitation.
2180      *
2181      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2182      *
2183      * IMPORTANT: because control is transferred to `recipient`, care must be
2184      * taken to not create reentrancy vulnerabilities. Consider using
2185      * {ReentrancyGuard} or the
2186      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2187      */
2188     function sendValue(address payable recipient, uint256 amount) internal {
2189         require(address(this).balance >= amount, "Address: insufficient balance");
2190 
2191         (bool success, ) = recipient.call{value: amount}("");
2192         require(success, "Address: unable to send value, recipient may have reverted");
2193     }
2194 
2195     /**
2196      * @dev Performs a Solidity function call using a low level `call`. A
2197      * plain `call` is an unsafe replacement for a function call: use this
2198      * function instead.
2199      *
2200      * If `target` reverts with a revert reason, it is bubbled up by this
2201      * function (like regular Solidity function calls).
2202      *
2203      * Returns the raw returned data. To convert to the expected return value,
2204      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2205      *
2206      * Requirements:
2207      *
2208      * - `target` must be a contract.
2209      * - calling `target` with `data` must not revert.
2210      *
2211      * _Available since v3.1._
2212      */
2213     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2214         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
2215     }
2216 
2217     /**
2218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2219      * `errorMessage` as a fallback revert reason when `target` reverts.
2220      *
2221      * _Available since v3.1._
2222      */
2223     function functionCall(
2224         address target,
2225         bytes memory data,
2226         string memory errorMessage
2227     ) internal returns (bytes memory) {
2228         return functionCallWithValue(target, data, 0, errorMessage);
2229     }
2230 
2231     /**
2232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2233      * but also transferring `value` wei to `target`.
2234      *
2235      * Requirements:
2236      *
2237      * - the calling contract must have an ETH balance of at least `value`.
2238      * - the called Solidity function must be `payable`.
2239      *
2240      * _Available since v3.1._
2241      */
2242     function functionCallWithValue(
2243         address target,
2244         bytes memory data,
2245         uint256 value
2246     ) internal returns (bytes memory) {
2247         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2248     }
2249 
2250     /**
2251      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2252      * with `errorMessage` as a fallback revert reason when `target` reverts.
2253      *
2254      * _Available since v3.1._
2255      */
2256     function functionCallWithValue(
2257         address target,
2258         bytes memory data,
2259         uint256 value,
2260         string memory errorMessage
2261     ) internal returns (bytes memory) {
2262         require(address(this).balance >= value, "Address: insufficient balance for call");
2263         (bool success, bytes memory returndata) = target.call{value: value}(data);
2264         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2265     }
2266 
2267     /**
2268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2269      * but performing a static call.
2270      *
2271      * _Available since v3.3._
2272      */
2273     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2274         return functionStaticCall(target, data, "Address: low-level static call failed");
2275     }
2276 
2277     /**
2278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2279      * but performing a static call.
2280      *
2281      * _Available since v3.3._
2282      */
2283     function functionStaticCall(
2284         address target,
2285         bytes memory data,
2286         string memory errorMessage
2287     ) internal view returns (bytes memory) {
2288         (bool success, bytes memory returndata) = target.staticcall(data);
2289         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2290     }
2291 
2292     /**
2293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2294      * but performing a delegate call.
2295      *
2296      * _Available since v3.4._
2297      */
2298     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2299         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2300     }
2301 
2302     /**
2303      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2304      * but performing a delegate call.
2305      *
2306      * _Available since v3.4._
2307      */
2308     function functionDelegateCall(
2309         address target,
2310         bytes memory data,
2311         string memory errorMessage
2312     ) internal returns (bytes memory) {
2313         (bool success, bytes memory returndata) = target.delegatecall(data);
2314         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2315     }
2316 
2317     /**
2318      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
2319      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
2320      *
2321      * _Available since v4.8._
2322      */
2323     function verifyCallResultFromTarget(
2324         address target,
2325         bool success,
2326         bytes memory returndata,
2327         string memory errorMessage
2328     ) internal view returns (bytes memory) {
2329         if (success) {
2330             if (returndata.length == 0) {
2331                 // only check isContract if the call was successful and the return data is empty
2332                 // otherwise we already know that it was a contract
2333                 require(isContract(target), "Address: call to non-contract");
2334             }
2335             return returndata;
2336         } else {
2337             _revert(returndata, errorMessage);
2338         }
2339     }
2340 
2341     /**
2342      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
2343      * revert reason or using the provided one.
2344      *
2345      * _Available since v4.3._
2346      */
2347     function verifyCallResult(
2348         bool success,
2349         bytes memory returndata,
2350         string memory errorMessage
2351     ) internal pure returns (bytes memory) {
2352         if (success) {
2353             return returndata;
2354         } else {
2355             _revert(returndata, errorMessage);
2356         }
2357     }
2358 
2359     function _revert(bytes memory returndata, string memory errorMessage) private pure {
2360         // Look for revert reason and bubble it up if present
2361         if (returndata.length > 0) {
2362             // The easiest way to bubble the revert reason is using memory via assembly
2363             /// @solidity memory-safe-assembly
2364             assembly {
2365                 let returndata_size := mload(returndata)
2366                 revert(add(32, returndata), returndata_size)
2367             }
2368         } else {
2369             revert(errorMessage);
2370         }
2371     }
2372 }
2373 
2374 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
2375 
2376 
2377 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2378 
2379 pragma solidity ^0.8.0;
2380 
2381 /**
2382  * @title ERC721 token receiver interface
2383  * @dev Interface for any contract that wants to support safeTransfers
2384  * from ERC721 asset contracts.
2385  */
2386 interface IERC721Receiver {
2387     /**
2388      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2389      * by `operator` from `from`, this function is called.
2390      *
2391      * It must return its Solidity selector to confirm the token transfer.
2392      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2393      *
2394      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2395      */
2396     function onERC721Received(
2397         address operator,
2398         address from,
2399         uint256 tokenId,
2400         bytes calldata data
2401     ) external returns (bytes4);
2402 }
2403 
2404 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
2405 
2406 
2407 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2408 
2409 pragma solidity ^0.8.0;
2410 
2411 /**
2412  * @dev Interface of the ERC165 standard, as defined in the
2413  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2414  *
2415  * Implementers can declare support of contract interfaces, which can then be
2416  * queried by others ({ERC165Checker}).
2417  *
2418  * For an implementation, see {ERC165}.
2419  */
2420 interface IERC165 {
2421     /**
2422      * @dev Returns true if this contract implements the interface defined by
2423      * `interfaceId`. See the corresponding
2424      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2425      * to learn more about how these ids are created.
2426      *
2427      * This function call must use less than 30 000 gas.
2428      */
2429     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2430 }
2431 
2432 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
2433 
2434 
2435 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2436 
2437 pragma solidity ^0.8.0;
2438 
2439 
2440 /**
2441  * @dev Implementation of the {IERC165} interface.
2442  *
2443  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2444  * for the additional interface id that will be supported. For example:
2445  *
2446  * ```solidity
2447  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2448  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2449  * }
2450  * ```
2451  *
2452  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2453  */
2454 abstract contract ERC165 is IERC165 {
2455     /**
2456      * @dev See {IERC165-supportsInterface}.
2457      */
2458     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2459         return interfaceId == type(IERC165).interfaceId;
2460     }
2461 }
2462 
2463 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
2464 
2465 
2466 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
2467 
2468 pragma solidity ^0.8.0;
2469 
2470 
2471 /**
2472  * @dev Required interface of an ERC721 compliant contract.
2473  */
2474 interface IERC721 is IERC165 {
2475     /**
2476      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2477      */
2478     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2479 
2480     /**
2481      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2482      */
2483     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2484 
2485     /**
2486      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2487      */
2488     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2489 
2490     /**
2491      * @dev Returns the number of tokens in ``owner``'s account.
2492      */
2493     function balanceOf(address owner) external view returns (uint256 balance);
2494 
2495     /**
2496      * @dev Returns the owner of the `tokenId` token.
2497      *
2498      * Requirements:
2499      *
2500      * - `tokenId` must exist.
2501      */
2502     function ownerOf(uint256 tokenId) external view returns (address owner);
2503 
2504     /**
2505      * @dev Safely transfers `tokenId` token from `from` to `to`.
2506      *
2507      * Requirements:
2508      *
2509      * - `from` cannot be the zero address.
2510      * - `to` cannot be the zero address.
2511      * - `tokenId` token must exist and be owned by `from`.
2512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2513      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2514      *
2515      * Emits a {Transfer} event.
2516      */
2517     function safeTransferFrom(
2518         address from,
2519         address to,
2520         uint256 tokenId,
2521         bytes calldata data
2522     ) external;
2523 
2524     /**
2525      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2526      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2527      *
2528      * Requirements:
2529      *
2530      * - `from` cannot be the zero address.
2531      * - `to` cannot be the zero address.
2532      * - `tokenId` token must exist and be owned by `from`.
2533      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2534      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2535      *
2536      * Emits a {Transfer} event.
2537      */
2538     function safeTransferFrom(
2539         address from,
2540         address to,
2541         uint256 tokenId
2542     ) external;
2543 
2544     /**
2545      * @dev Transfers `tokenId` token from `from` to `to`.
2546      *
2547      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2548      *
2549      * Requirements:
2550      *
2551      * - `from` cannot be the zero address.
2552      * - `to` cannot be the zero address.
2553      * - `tokenId` token must be owned by `from`.
2554      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2555      *
2556      * Emits a {Transfer} event.
2557      */
2558     function transferFrom(
2559         address from,
2560         address to,
2561         uint256 tokenId
2562     ) external;
2563 
2564     /**
2565      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2566      * The approval is cleared when the token is transferred.
2567      *
2568      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2569      *
2570      * Requirements:
2571      *
2572      * - The caller must own the token or be an approved operator.
2573      * - `tokenId` must exist.
2574      *
2575      * Emits an {Approval} event.
2576      */
2577     function approve(address to, uint256 tokenId) external;
2578 
2579     /**
2580      * @dev Approve or remove `operator` as an operator for the caller.
2581      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2582      *
2583      * Requirements:
2584      *
2585      * - The `operator` cannot be the caller.
2586      *
2587      * Emits an {ApprovalForAll} event.
2588      */
2589     function setApprovalForAll(address operator, bool _approved) external;
2590 
2591     /**
2592      * @dev Returns the account approved for `tokenId` token.
2593      *
2594      * Requirements:
2595      *
2596      * - `tokenId` must exist.
2597      */
2598     function getApproved(uint256 tokenId) external view returns (address operator);
2599 
2600     /**
2601      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2602      *
2603      * See {setApprovalForAll}
2604      */
2605     function isApprovedForAll(address owner, address operator) external view returns (bool);
2606 }
2607 
2608 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
2609 
2610 
2611 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2612 
2613 pragma solidity ^0.8.0;
2614 
2615 
2616 /**
2617  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2618  * @dev See https://eips.ethereum.org/EIPS/eip-721
2619  */
2620 interface IERC721Metadata is IERC721 {
2621     /**
2622      * @dev Returns the token collection name.
2623      */
2624     function name() external view returns (string memory);
2625 
2626     /**
2627      * @dev Returns the token collection symbol.
2628      */
2629     function symbol() external view returns (string memory);
2630 
2631     /**
2632      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2633      */
2634     function tokenURI(uint256 tokenId) external view returns (string memory);
2635 }
2636 
2637 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
2638 
2639 
2640 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
2641 
2642 pragma solidity ^0.8.0;
2643 
2644 
2645 
2646 
2647 
2648 
2649 
2650 
2651 /**
2652  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2653  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2654  * {ERC721Enumerable}.
2655  */
2656 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2657     using Address for address;
2658     using Strings for uint256;
2659 
2660     // Token name
2661     string private _name;
2662 
2663     // Token symbol
2664     string private _symbol;
2665 
2666     // Mapping from token ID to owner address
2667     mapping(uint256 => address) private _owners;
2668 
2669     // Mapping owner address to token count
2670     mapping(address => uint256) private _balances;
2671 
2672     // Mapping from token ID to approved address
2673     mapping(uint256 => address) private _tokenApprovals;
2674 
2675     // Mapping from owner to operator approvals
2676     mapping(address => mapping(address => bool)) private _operatorApprovals;
2677 
2678     /**
2679      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2680      */
2681     constructor(string memory name_, string memory symbol_) {
2682         _name = name_;
2683         _symbol = symbol_;
2684     }
2685 
2686     /**
2687      * @dev See {IERC165-supportsInterface}.
2688      */
2689     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2690         return
2691             interfaceId == type(IERC721).interfaceId ||
2692             interfaceId == type(IERC721Metadata).interfaceId ||
2693             super.supportsInterface(interfaceId);
2694     }
2695 
2696     /**
2697      * @dev See {IERC721-balanceOf}.
2698      */
2699     function balanceOf(address owner) public view virtual override returns (uint256) {
2700         require(owner != address(0), "ERC721: address zero is not a valid owner");
2701         return _balances[owner];
2702     }
2703 
2704     /**
2705      * @dev See {IERC721-ownerOf}.
2706      */
2707     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2708         address owner = _owners[tokenId];
2709         require(owner != address(0), "ERC721: invalid token ID");
2710         return owner;
2711     }
2712 
2713     /**
2714      * @dev See {IERC721Metadata-name}.
2715      */
2716     function name() public view virtual override returns (string memory) {
2717         return _name;
2718     }
2719 
2720     /**
2721      * @dev See {IERC721Metadata-symbol}.
2722      */
2723     function symbol() public view virtual override returns (string memory) {
2724         return _symbol;
2725     }
2726 
2727     /**
2728      * @dev See {IERC721Metadata-tokenURI}.
2729      */
2730     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2731         _requireMinted(tokenId);
2732 
2733         string memory baseURI = _baseURI();
2734         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2735     }
2736 
2737     /**
2738      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2739      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2740      * by default, can be overridden in child contracts.
2741      */
2742     function _baseURI() internal view virtual returns (string memory) {
2743         return "";
2744     }
2745 
2746     /**
2747      * @dev See {IERC721-approve}.
2748      */
2749     function approve(address to, uint256 tokenId) public virtual override {
2750         address owner = ERC721.ownerOf(tokenId);
2751         require(to != owner, "ERC721: approval to current owner");
2752 
2753         require(
2754             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2755             "ERC721: approve caller is not token owner or approved for all"
2756         );
2757 
2758         _approve(to, tokenId);
2759     }
2760 
2761     /**
2762      * @dev See {IERC721-getApproved}.
2763      */
2764     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2765         _requireMinted(tokenId);
2766 
2767         return _tokenApprovals[tokenId];
2768     }
2769 
2770     /**
2771      * @dev See {IERC721-setApprovalForAll}.
2772      */
2773     function setApprovalForAll(address operator, bool approved) public virtual override {
2774         _setApprovalForAll(_msgSender(), operator, approved);
2775     }
2776 
2777     /**
2778      * @dev See {IERC721-isApprovedForAll}.
2779      */
2780     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2781         return _operatorApprovals[owner][operator];
2782     }
2783 
2784     /**
2785      * @dev See {IERC721-transferFrom}.
2786      */
2787     function transferFrom(
2788         address from,
2789         address to,
2790         uint256 tokenId
2791     ) public virtual override {
2792         //solhint-disable-next-line max-line-length
2793         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
2794 
2795         _transfer(from, to, tokenId);
2796     }
2797 
2798     /**
2799      * @dev See {IERC721-safeTransferFrom}.
2800      */
2801     function safeTransferFrom(
2802         address from,
2803         address to,
2804         uint256 tokenId
2805     ) public virtual override {
2806         safeTransferFrom(from, to, tokenId, "");
2807     }
2808 
2809     /**
2810      * @dev See {IERC721-safeTransferFrom}.
2811      */
2812     function safeTransferFrom(
2813         address from,
2814         address to,
2815         uint256 tokenId,
2816         bytes memory data
2817     ) public virtual override {
2818         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
2819         _safeTransfer(from, to, tokenId, data);
2820     }
2821 
2822     /**
2823      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2824      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2825      *
2826      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2827      *
2828      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2829      * implement alternative mechanisms to perform token transfer, such as signature-based.
2830      *
2831      * Requirements:
2832      *
2833      * - `from` cannot be the zero address.
2834      * - `to` cannot be the zero address.
2835      * - `tokenId` token must exist and be owned by `from`.
2836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2837      *
2838      * Emits a {Transfer} event.
2839      */
2840     function _safeTransfer(
2841         address from,
2842         address to,
2843         uint256 tokenId,
2844         bytes memory data
2845     ) internal virtual {
2846         _transfer(from, to, tokenId);
2847         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2848     }
2849 
2850     /**
2851      * @dev Returns whether `tokenId` exists.
2852      *
2853      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2854      *
2855      * Tokens start existing when they are minted (`_mint`),
2856      * and stop existing when they are burned (`_burn`).
2857      */
2858     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2859         return _owners[tokenId] != address(0);
2860     }
2861 
2862     /**
2863      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2864      *
2865      * Requirements:
2866      *
2867      * - `tokenId` must exist.
2868      */
2869     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2870         address owner = ERC721.ownerOf(tokenId);
2871         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2872     }
2873 
2874     /**
2875      * @dev Safely mints `tokenId` and transfers it to `to`.
2876      *
2877      * Requirements:
2878      *
2879      * - `tokenId` must not exist.
2880      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2881      *
2882      * Emits a {Transfer} event.
2883      */
2884     function _safeMint(address to, uint256 tokenId) internal virtual {
2885         _safeMint(to, tokenId, "");
2886     }
2887 
2888     /**
2889      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2890      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2891      */
2892     function _safeMint(
2893         address to,
2894         uint256 tokenId,
2895         bytes memory data
2896     ) internal virtual {
2897         _mint(to, tokenId);
2898         require(
2899             _checkOnERC721Received(address(0), to, tokenId, data),
2900             "ERC721: transfer to non ERC721Receiver implementer"
2901         );
2902     }
2903 
2904     /**
2905      * @dev Mints `tokenId` and transfers it to `to`.
2906      *
2907      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2908      *
2909      * Requirements:
2910      *
2911      * - `tokenId` must not exist.
2912      * - `to` cannot be the zero address.
2913      *
2914      * Emits a {Transfer} event.
2915      */
2916     function _mint(address to, uint256 tokenId) internal virtual {
2917         require(to != address(0), "ERC721: mint to the zero address");
2918         require(!_exists(tokenId), "ERC721: token already minted");
2919 
2920         _beforeTokenTransfer(address(0), to, tokenId);
2921 
2922         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
2923         require(!_exists(tokenId), "ERC721: token already minted");
2924 
2925         unchecked {
2926             // Will not overflow unless all 2**256 token ids are minted to the same owner.
2927             // Given that tokens are minted one by one, it is impossible in practice that
2928             // this ever happens. Might change if we allow batch minting.
2929             // The ERC fails to describe this case.
2930             _balances[to] += 1;
2931         }
2932 
2933         _owners[tokenId] = to;
2934 
2935         emit Transfer(address(0), to, tokenId);
2936 
2937         _afterTokenTransfer(address(0), to, tokenId);
2938     }
2939 
2940     /**
2941      * @dev Destroys `tokenId`.
2942      * The approval is cleared when the token is burned.
2943      * This is an internal function that does not check if the sender is authorized to operate on the token.
2944      *
2945      * Requirements:
2946      *
2947      * - `tokenId` must exist.
2948      *
2949      * Emits a {Transfer} event.
2950      */
2951     function _burn(uint256 tokenId) internal virtual {
2952         address owner = ERC721.ownerOf(tokenId);
2953 
2954         _beforeTokenTransfer(owner, address(0), tokenId);
2955 
2956         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
2957         owner = ERC721.ownerOf(tokenId);
2958 
2959         // Clear approvals
2960         delete _tokenApprovals[tokenId];
2961 
2962         unchecked {
2963             // Cannot overflow, as that would require more tokens to be burned/transferred
2964             // out than the owner initially received through minting and transferring in.
2965             _balances[owner] -= 1;
2966         }
2967         delete _owners[tokenId];
2968 
2969         emit Transfer(owner, address(0), tokenId);
2970 
2971         _afterTokenTransfer(owner, address(0), tokenId);
2972     }
2973 
2974     /**
2975      * @dev Transfers `tokenId` from `from` to `to`.
2976      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2977      *
2978      * Requirements:
2979      *
2980      * - `to` cannot be the zero address.
2981      * - `tokenId` token must be owned by `from`.
2982      *
2983      * Emits a {Transfer} event.
2984      */
2985     function _transfer(
2986         address from,
2987         address to,
2988         uint256 tokenId
2989     ) internal virtual {
2990         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2991         require(to != address(0), "ERC721: transfer to the zero address");
2992 
2993         _beforeTokenTransfer(from, to, tokenId);
2994 
2995         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
2996         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2997 
2998         // Clear approvals from the previous owner
2999         delete _tokenApprovals[tokenId];
3000 
3001         unchecked {
3002             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
3003             // `from`'s balance is the number of token held, which is at least one before the current
3004             // transfer.
3005             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
3006             // all 2**256 token ids to be minted, which in practice is impossible.
3007             _balances[from] -= 1;
3008             _balances[to] += 1;
3009         }
3010         _owners[tokenId] = to;
3011 
3012         emit Transfer(from, to, tokenId);
3013 
3014         _afterTokenTransfer(from, to, tokenId);
3015     }
3016 
3017     /**
3018      * @dev Approve `to` to operate on `tokenId`
3019      *
3020      * Emits an {Approval} event.
3021      */
3022     function _approve(address to, uint256 tokenId) internal virtual {
3023         _tokenApprovals[tokenId] = to;
3024         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3025     }
3026 
3027     /**
3028      * @dev Approve `operator` to operate on all of `owner` tokens
3029      *
3030      * Emits an {ApprovalForAll} event.
3031      */
3032     function _setApprovalForAll(
3033         address owner,
3034         address operator,
3035         bool approved
3036     ) internal virtual {
3037         require(owner != operator, "ERC721: approve to caller");
3038         _operatorApprovals[owner][operator] = approved;
3039         emit ApprovalForAll(owner, operator, approved);
3040     }
3041 
3042     /**
3043      * @dev Reverts if the `tokenId` has not been minted yet.
3044      */
3045     function _requireMinted(uint256 tokenId) internal view virtual {
3046         require(_exists(tokenId), "ERC721: invalid token ID");
3047     }
3048 
3049     /**
3050      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3051      * The call is not executed if the target address is not a contract.
3052      *
3053      * @param from address representing the previous owner of the given token ID
3054      * @param to target address that will receive the tokens
3055      * @param tokenId uint256 ID of the token to be transferred
3056      * @param data bytes optional data to send along with the call
3057      * @return bool whether the call correctly returned the expected magic value
3058      */
3059     function _checkOnERC721Received(
3060         address from,
3061         address to,
3062         uint256 tokenId,
3063         bytes memory data
3064     ) private returns (bool) {
3065         if (to.isContract()) {
3066             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
3067                 return retval == IERC721Receiver.onERC721Received.selector;
3068             } catch (bytes memory reason) {
3069                 if (reason.length == 0) {
3070                     revert("ERC721: transfer to non ERC721Receiver implementer");
3071                 } else {
3072                     /// @solidity memory-safe-assembly
3073                     assembly {
3074                         revert(add(32, reason), mload(reason))
3075                     }
3076                 }
3077             }
3078         } else {
3079             return true;
3080         }
3081     }
3082 
3083     /**
3084      * @dev Hook that is called before any token transfer. This includes minting
3085      * and burning.
3086      *
3087      * Calling conditions:
3088      *
3089      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3090      * transferred to `to`.
3091      * - When `from` is zero, `tokenId` will be minted for `to`.
3092      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3093      * - `from` and `to` are never both zero.
3094      *
3095      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3096      */
3097     function _beforeTokenTransfer(
3098         address from,
3099         address to,
3100         uint256 tokenId
3101     ) internal virtual {}
3102 
3103     /**
3104      * @dev Hook that is called after any transfer of tokens. This includes
3105      * minting and burning.
3106      *
3107      * Calling conditions:
3108      *
3109      * - when `from` and `to` are both non-zero.
3110      * - `from` and `to` are never both zero.
3111      *
3112      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3113      */
3114     function _afterTokenTransfer(
3115         address from,
3116         address to,
3117         uint256 tokenId
3118     ) internal virtual {}
3119 }
3120 
3121 
3122 // File: contracts/LightTrails_Flat.sol
3123 
3124 pragma solidity ^0.8.4;
3125 
3126 contract LightTrails is ERC721A, ERC721AQueryable, DefaultOperatorFilterer, Owned {
3127   uint256 public FIRST_MINT_PRICE = 0 ether;
3128   uint256 public EXTRA_MINT_PRICE = 0 ether;
3129   uint256 public FIRST_MINT_PRICE_PUBLIC = 0.02 ether;
3130   uint256 public EXTRA_MINT_PRICE_PUBLIC = 0.02 ether;
3131   uint256 constant MAX_SUPPLY_PLUS_ONE = 1001;
3132   uint256 constant MAX_PER_WALLET_PLUS_ONE = 6;
3133   uint256 RESERVED = 50;
3134 
3135   string tokenBaseUri = "ipfs://QmWowjx9HKytYNg9oPg96DtjJUvfx4ivg6p6bTXS1AeGhS/";
3136 
3137   bool public paused = true;
3138   bool public openToPublic = false;
3139 
3140   bytes32 public merkleRoot;
3141 
3142   mapping(address => uint256) private _freeMintedCount;
3143   mapping(address => uint256) private _totalMintedCount;
3144   mapping(address => bool) private _wLMinted;
3145 
3146   constructor(bytes32 _merkleRoot) ERC721A("LightTrails", "LTTrail") Owned(msg.sender) {
3147     merkleRoot = _merkleRoot;
3148   }
3149 
3150   function checkInWhiteList(bytes32[] calldata proof, uint256 quantity) view public returns(bool) {
3151     bytes32 leaf = keccak256(abi.encodePacked(msg.sender, quantity));
3152     bool verified = MerkleProof.verify(proof, merkleRoot, leaf);
3153 
3154     return verified;
3155   }
3156 
3157   // Rename mint function to optimize gas
3158   function mint_540(uint256 _quantity, bytes32[] calldata _proof) external payable {
3159     unchecked {
3160       require(!paused, "MINTING PAUSED");
3161 
3162       bool isWhiteListed = checkInWhiteList(_proof, _quantity);
3163       
3164       uint256 firstMintPrice;
3165       uint256 extraMintPrice;
3166 
3167       if(isWhiteListed && !openToPublic) {
3168         require(!_wLMinted[msg.sender], "ALREADY MINTED");
3169         firstMintPrice = FIRST_MINT_PRICE;
3170         extraMintPrice = EXTRA_MINT_PRICE;  
3171       } else {
3172         require(openToPublic, "MINTING NOT YET OPEN FOR PUBLIC");
3173         require(_totalMintedCount[msg.sender] + _quantity < MAX_PER_WALLET_PLUS_ONE, "MAX PER WALLET IS 5");
3174         firstMintPrice = FIRST_MINT_PRICE_PUBLIC;
3175         extraMintPrice = EXTRA_MINT_PRICE_PUBLIC;
3176       }
3177       
3178       uint256 _totalSupply = totalSupply();
3179 
3180       require(_totalSupply + _quantity + RESERVED < MAX_SUPPLY_PLUS_ONE, "MAX SUPPLY REACHED");
3181 
3182       uint256 payForCount = _quantity;
3183       uint256 payForFirstMint = 0;
3184       uint256 freeMintCount = _freeMintedCount[msg.sender];
3185 
3186       if (freeMintCount < 1) {
3187         if (_quantity > 1) {
3188           payForCount = _quantity - 1;
3189         } else {
3190           payForCount = 0;
3191         }
3192         payForFirstMint = 1;
3193 
3194         if(isWhiteListed && !openToPublic) {
3195             _freeMintedCount[msg.sender] = 0;
3196         } else {
3197             _freeMintedCount[msg.sender] = 1;
3198         }
3199       }
3200       if(isWhiteListed && !openToPublic) {
3201         _wLMinted[msg.sender] = true;
3202       } else {
3203         _totalMintedCount[msg.sender] += _quantity;
3204       }
3205 
3206       require(
3207         msg.value >= (payForCount * extraMintPrice + payForFirstMint * firstMintPrice),
3208         "INCORRECT ETH AMOUNT"
3209       );
3210 
3211       _mint(msg.sender, _quantity);
3212     }
3213   }
3214 
3215   // Set first mint price
3216   function setFirstMintPrice(uint256 _newPrice) public onlyOwner {
3217     FIRST_MINT_PRICE = _newPrice;
3218   }
3219 
3220   // Set extra mint price
3221   function setExtraMintPrice(uint256 _newPrice) public onlyOwner {
3222     EXTRA_MINT_PRICE = _newPrice;
3223   }
3224 
3225   // Set first mint price for public
3226   function setFirstMintPricePublic(uint256 _newPrice) public onlyOwner {
3227     FIRST_MINT_PRICE_PUBLIC = _newPrice;
3228   }
3229 
3230   // Set extra mint price for public
3231   function setExtraMintPricePublic(uint256 _newPrice) public onlyOwner {
3232     EXTRA_MINT_PRICE_PUBLIC = _newPrice;
3233   }
3234 
3235   function freeMintedCount(address owner) external view returns (uint256) {
3236     return _freeMintedCount[owner];
3237   }
3238 
3239   function totalMintedCount(address owner) external view returns (uint256) {
3240     return _totalMintedCount[owner];
3241   }
3242 
3243   function _startTokenId() internal pure override returns (uint256) {
3244     return 1;
3245   }
3246 
3247   function _baseURI() internal view override returns (string memory) {
3248     return tokenBaseUri;
3249   }
3250 
3251   function setBaseURI(string calldata _newBaseUri) external onlyOwner {
3252     tokenBaseUri = _newBaseUri;
3253   }
3254 
3255   function flipSale() external onlyOwner {
3256     paused = !paused;
3257   }
3258 
3259   function flipOpenToPublic() external onlyOwner {
3260     openToPublic = !openToPublic;
3261   }
3262 
3263   function collectReserves() external onlyOwner {
3264     require(RESERVED > 0, "RESERVES TAKEN");
3265 
3266     _mint(msg.sender, 50);
3267     RESERVED = 0;
3268   }
3269 
3270   function withdraw() external onlyOwner {
3271     require(
3272       payable(owner).send(address(this).balance),
3273       "UNSUCCESSFUL"
3274     );
3275   }
3276 
3277   function setApprovalForAll(address operator, bool approved) public override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
3278     super.setApprovalForAll(operator, approved);
3279     }
3280 
3281     function approve(address operator, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
3282         super.approve(operator, tokenId);
3283     }
3284 
3285     function transferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperator(from) {
3286         super.transferFrom(from, to, tokenId);
3287     }
3288 
3289     function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721A, IERC721A) onlyAllowedOperator(from) {
3290         super.safeTransferFrom(from, to, tokenId);
3291     }
3292 
3293     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3294         public
3295         override(ERC721A, IERC721A)
3296         onlyAllowedOperator(from)
3297     {
3298         super.safeTransferFrom(from, to, tokenId, data);
3299     }
3300 }