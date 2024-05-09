1 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 /**
40  * @title  OperatorFilterer
41  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
42  *         registrant's entries in the OperatorFilterRegistry.
43  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
44  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
45  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
46  */
47 abstract contract OperatorFilterer {
48     error OperatorNotAllowed(address operator);
49 
50     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
51         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
52 
53     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
54         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
55         // will not revert, but the contract will need to be registered with the registry once it is deployed in
56         // order for the modifier to filter addresses.
57         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
58             if (subscribe) {
59                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
60             } else {
61                 if (subscriptionOrRegistrantToCopy != address(0)) {
62                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
63                 } else {
64                     OPERATOR_FILTER_REGISTRY.register(address(this));
65                 }
66             }
67         }
68     }
69 
70     modifier onlyAllowedOperator(address from) virtual {
71         // Allow spending tokens from addresses with balance
72         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
73         // from an EOA.
74         if (from != msg.sender) {
75             _checkFilterOperator(msg.sender);
76         }
77         _;
78     }
79 
80     modifier onlyAllowedOperatorApproval(address operator) virtual {
81         _checkFilterOperator(operator);
82         _;
83     }
84 
85     function _checkFilterOperator(address operator) internal view virtual {
86         // Check registry code length to facilitate testing in environments without a deployed registry.
87         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
88             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
89                 revert OperatorNotAllowed(operator);
90             }
91         }
92     }
93 }
94 
95 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/DefaultOperatorFilterer.sol
96 
97 
98 pragma solidity ^0.8.13;
99 
100 
101 /**
102  * @title  DefaultOperatorFilterer
103  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
104  */
105 abstract contract DefaultOperatorFilterer is OperatorFilterer {
106     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
107 
108     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
109 }
110 
111 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
112 
113 
114 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev These functions deal with verification of Merkle Tree proofs.
120  *
121  * The tree and the proofs can be generated using our
122  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
123  * You will find a quickstart guide in the readme.
124  *
125  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
126  * hashing, or use a hash function other than keccak256 for hashing leaves.
127  * This is because the concatenation of a sorted pair of internal nodes in
128  * the merkle tree could be reinterpreted as a leaf value.
129  * OpenZeppelin's JavaScript library generates merkle trees that are safe
130  * against this attack out of the box.
131  */
132 library MerkleProof {
133     /**
134      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
135      * defined by `root`. For this, a `proof` must be provided, containing
136      * sibling hashes on the branch from the leaf to the root of the tree. Each
137      * pair of leaves and each pair of pre-images are assumed to be sorted.
138      */
139     function verify(
140         bytes32[] memory proof,
141         bytes32 root,
142         bytes32 leaf
143     ) internal pure returns (bool) {
144         return processProof(proof, leaf) == root;
145     }
146 
147     /**
148      * @dev Calldata version of {verify}
149      *
150      * _Available since v4.7._
151      */
152     function verifyCalldata(
153         bytes32[] calldata proof,
154         bytes32 root,
155         bytes32 leaf
156     ) internal pure returns (bool) {
157         return processProofCalldata(proof, leaf) == root;
158     }
159 
160     /**
161      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
162      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
163      * hash matches the root of the tree. When processing the proof, the pairs
164      * of leafs & pre-images are assumed to be sorted.
165      *
166      * _Available since v4.4._
167      */
168     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
169         bytes32 computedHash = leaf;
170         for (uint256 i = 0; i < proof.length; i++) {
171             computedHash = _hashPair(computedHash, proof[i]);
172         }
173         return computedHash;
174     }
175 
176     /**
177      * @dev Calldata version of {processProof}
178      *
179      * _Available since v4.7._
180      */
181     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
182         bytes32 computedHash = leaf;
183         for (uint256 i = 0; i < proof.length; i++) {
184             computedHash = _hashPair(computedHash, proof[i]);
185         }
186         return computedHash;
187     }
188 
189     /**
190      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
191      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
192      *
193      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
194      *
195      * _Available since v4.7._
196      */
197     function multiProofVerify(
198         bytes32[] memory proof,
199         bool[] memory proofFlags,
200         bytes32 root,
201         bytes32[] memory leaves
202     ) internal pure returns (bool) {
203         return processMultiProof(proof, proofFlags, leaves) == root;
204     }
205 
206     /**
207      * @dev Calldata version of {multiProofVerify}
208      *
209      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
210      *
211      * _Available since v4.7._
212      */
213     function multiProofVerifyCalldata(
214         bytes32[] calldata proof,
215         bool[] calldata proofFlags,
216         bytes32 root,
217         bytes32[] memory leaves
218     ) internal pure returns (bool) {
219         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
220     }
221 
222     /**
223      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
224      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
225      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
226      * respectively.
227      *
228      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
229      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
230      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
231      *
232      * _Available since v4.7._
233      */
234     function processMultiProof(
235         bytes32[] memory proof,
236         bool[] memory proofFlags,
237         bytes32[] memory leaves
238     ) internal pure returns (bytes32 merkleRoot) {
239         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
240         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
241         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
242         // the merkle tree.
243         uint256 leavesLen = leaves.length;
244         uint256 totalHashes = proofFlags.length;
245 
246         // Check proof validity.
247         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
248 
249         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
250         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
251         bytes32[] memory hashes = new bytes32[](totalHashes);
252         uint256 leafPos = 0;
253         uint256 hashPos = 0;
254         uint256 proofPos = 0;
255         // At each step, we compute the next hash using two values:
256         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
257         //   get the next hash.
258         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
259         //   `proof` array.
260         for (uint256 i = 0; i < totalHashes; i++) {
261             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
262             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
263             hashes[i] = _hashPair(a, b);
264         }
265 
266         if (totalHashes > 0) {
267             return hashes[totalHashes - 1];
268         } else if (leavesLen > 0) {
269             return leaves[0];
270         } else {
271             return proof[0];
272         }
273     }
274 
275     /**
276      * @dev Calldata version of {processMultiProof}.
277      *
278      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
279      *
280      * _Available since v4.7._
281      */
282     function processMultiProofCalldata(
283         bytes32[] calldata proof,
284         bool[] calldata proofFlags,
285         bytes32[] memory leaves
286     ) internal pure returns (bytes32 merkleRoot) {
287         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
288         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
289         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
290         // the merkle tree.
291         uint256 leavesLen = leaves.length;
292         uint256 totalHashes = proofFlags.length;
293 
294         // Check proof validity.
295         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
296 
297         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
298         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
299         bytes32[] memory hashes = new bytes32[](totalHashes);
300         uint256 leafPos = 0;
301         uint256 hashPos = 0;
302         uint256 proofPos = 0;
303         // At each step, we compute the next hash using two values:
304         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
305         //   get the next hash.
306         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
307         //   `proof` array.
308         for (uint256 i = 0; i < totalHashes; i++) {
309             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
310             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
311             hashes[i] = _hashPair(a, b);
312         }
313 
314         if (totalHashes > 0) {
315             return hashes[totalHashes - 1];
316         } else if (leavesLen > 0) {
317             return leaves[0];
318         } else {
319             return proof[0];
320         }
321     }
322 
323     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
324         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
325     }
326 
327     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
328         /// @solidity memory-safe-assembly
329         assembly {
330             mstore(0x00, a)
331             mstore(0x20, b)
332             value := keccak256(0x00, 0x40)
333         }
334     }
335 }
336 
337 // File: erc721a/contracts/IERC721A.sol
338 
339 
340 // ERC721A Contracts v4.2.3
341 // Creator: Chiru Labs
342 
343 pragma solidity ^0.8.4;
344 
345 /**
346  * @dev Interface of ERC721A.
347  */
348 interface IERC721A {
349     /**
350      * The caller must own the token or be an approved operator.
351      */
352     error ApprovalCallerNotOwnerNorApproved();
353 
354     /**
355      * The token does not exist.
356      */
357     error ApprovalQueryForNonexistentToken();
358 
359     /**
360      * Cannot query the balance for the zero address.
361      */
362     error BalanceQueryForZeroAddress();
363 
364     /**
365      * Cannot mint to the zero address.
366      */
367     error MintToZeroAddress();
368 
369     /**
370      * The quantity of tokens minted must be more than zero.
371      */
372     error MintZeroQuantity();
373 
374     /**
375      * The token does not exist.
376      */
377     error OwnerQueryForNonexistentToken();
378 
379     /**
380      * The caller must own the token or be an approved operator.
381      */
382     error TransferCallerNotOwnerNorApproved();
383 
384     /**
385      * The token must be owned by `from`.
386      */
387     error TransferFromIncorrectOwner();
388 
389     /**
390      * Cannot safely transfer to a contract that does not implement the
391      * ERC721Receiver interface.
392      */
393     error TransferToNonERC721ReceiverImplementer();
394 
395     /**
396      * Cannot transfer to the zero address.
397      */
398     error TransferToZeroAddress();
399 
400     /**
401      * The token does not exist.
402      */
403     error URIQueryForNonexistentToken();
404 
405     /**
406      * The `quantity` minted with ERC2309 exceeds the safety limit.
407      */
408     error MintERC2309QuantityExceedsLimit();
409 
410     /**
411      * The `extraData` cannot be set on an unintialized ownership slot.
412      */
413     error OwnershipNotInitializedForExtraData();
414 
415     // =============================================================
416     //                            STRUCTS
417     // =============================================================
418 
419     struct TokenOwnership {
420         // The address of the owner.
421         address addr;
422         // Stores the start time of ownership with minimal overhead for tokenomics.
423         uint64 startTimestamp;
424         // Whether the token has been burned.
425         bool burned;
426         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
427         uint24 extraData;
428     }
429 
430     // =============================================================
431     //                         TOKEN COUNTERS
432     // =============================================================
433 
434     /**
435      * @dev Returns the total number of tokens in existence.
436      * Burned tokens will reduce the count.
437      * To get the total number of tokens minted, please see {_totalMinted}.
438      */
439     function totalSupply() external view returns (uint256);
440 
441     // =============================================================
442     //                            IERC165
443     // =============================================================
444 
445     /**
446      * @dev Returns true if this contract implements the interface defined by
447      * `interfaceId`. See the corresponding
448      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
449      * to learn more about how these ids are created.
450      *
451      * This function call must use less than 30000 gas.
452      */
453     function supportsInterface(bytes4 interfaceId) external view returns (bool);
454 
455     // =============================================================
456     //                            IERC721
457     // =============================================================
458 
459     /**
460      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
461      */
462     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
463 
464     /**
465      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
466      */
467     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
468 
469     /**
470      * @dev Emitted when `owner` enables or disables
471      * (`approved`) `operator` to manage all of its assets.
472      */
473     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
474 
475     /**
476      * @dev Returns the number of tokens in `owner`'s account.
477      */
478     function balanceOf(address owner) external view returns (uint256 balance);
479 
480     /**
481      * @dev Returns the owner of the `tokenId` token.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function ownerOf(uint256 tokenId) external view returns (address owner);
488 
489     /**
490      * @dev Safely transfers `tokenId` token from `from` to `to`,
491      * checking first that contract recipients are aware of the ERC721 protocol
492      * to prevent tokens from being forever locked.
493      *
494      * Requirements:
495      *
496      * - `from` cannot be the zero address.
497      * - `to` cannot be the zero address.
498      * - `tokenId` token must exist and be owned by `from`.
499      * - If the caller is not `from`, it must be have been allowed to move
500      * this token by either {approve} or {setApprovalForAll}.
501      * - If `to` refers to a smart contract, it must implement
502      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
503      *
504      * Emits a {Transfer} event.
505      */
506     function safeTransferFrom(
507         address from,
508         address to,
509         uint256 tokenId,
510         bytes calldata data
511     ) external payable;
512 
513     /**
514      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
515      */
516     function safeTransferFrom(
517         address from,
518         address to,
519         uint256 tokenId
520     ) external payable;
521 
522     /**
523      * @dev Transfers `tokenId` from `from` to `to`.
524      *
525      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
526      * whenever possible.
527      *
528      * Requirements:
529      *
530      * - `from` cannot be the zero address.
531      * - `to` cannot be the zero address.
532      * - `tokenId` token must be owned by `from`.
533      * - If the caller is not `from`, it must be approved to move this token
534      * by either {approve} or {setApprovalForAll}.
535      *
536      * Emits a {Transfer} event.
537      */
538     function transferFrom(
539         address from,
540         address to,
541         uint256 tokenId
542     ) external payable;
543 
544     /**
545      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
546      * The approval is cleared when the token is transferred.
547      *
548      * Only a single account can be approved at a time, so approving the
549      * zero address clears previous approvals.
550      *
551      * Requirements:
552      *
553      * - The caller must own the token or be an approved operator.
554      * - `tokenId` must exist.
555      *
556      * Emits an {Approval} event.
557      */
558     function approve(address to, uint256 tokenId) external payable;
559 
560     /**
561      * @dev Approve or remove `operator` as an operator for the caller.
562      * Operators can call {transferFrom} or {safeTransferFrom}
563      * for any token owned by the caller.
564      *
565      * Requirements:
566      *
567      * - The `operator` cannot be the caller.
568      *
569      * Emits an {ApprovalForAll} event.
570      */
571     function setApprovalForAll(address operator, bool _approved) external;
572 
573     /**
574      * @dev Returns the account approved for `tokenId` token.
575      *
576      * Requirements:
577      *
578      * - `tokenId` must exist.
579      */
580     function getApproved(uint256 tokenId) external view returns (address operator);
581 
582     /**
583      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
584      *
585      * See {setApprovalForAll}.
586      */
587     function isApprovedForAll(address owner, address operator) external view returns (bool);
588 
589     // =============================================================
590     //                        IERC721Metadata
591     // =============================================================
592 
593     /**
594      * @dev Returns the token collection name.
595      */
596     function name() external view returns (string memory);
597 
598     /**
599      * @dev Returns the token collection symbol.
600      */
601     function symbol() external view returns (string memory);
602 
603     /**
604      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
605      */
606     function tokenURI(uint256 tokenId) external view returns (string memory);
607 
608     // =============================================================
609     //                           IERC2309
610     // =============================================================
611 
612     /**
613      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
614      * (inclusive) is transferred from `from` to `to`, as defined in the
615      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
616      *
617      * See {_mintERC2309} for more details.
618      */
619     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
620 }
621 
622 // File: erc721a/contracts/ERC721A.sol
623 
624 
625 // ERC721A Contracts v4.2.3
626 // Creator: Chiru Labs
627 
628 pragma solidity ^0.8.4;
629 
630 
631 /**
632  * @dev Interface of ERC721 token receiver.
633  */
634 interface ERC721A__IERC721Receiver {
635     function onERC721Received(
636         address operator,
637         address from,
638         uint256 tokenId,
639         bytes calldata data
640     ) external returns (bytes4);
641 }
642 
643 /**
644  * @title ERC721A
645  *
646  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
647  * Non-Fungible Token Standard, including the Metadata extension.
648  * Optimized for lower gas during batch mints.
649  *
650  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
651  * starting from `_startTokenId()`.
652  *
653  * Assumptions:
654  *
655  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
656  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
657  */
658 contract ERC721A is IERC721A {
659     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
660     struct TokenApprovalRef {
661         address value;
662     }
663 
664     // =============================================================
665     //                           CONSTANTS
666     // =============================================================
667 
668     // Mask of an entry in packed address data.
669     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
670 
671     // The bit position of `numberMinted` in packed address data.
672     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
673 
674     // The bit position of `numberBurned` in packed address data.
675     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
676 
677     // The bit position of `aux` in packed address data.
678     uint256 private constant _BITPOS_AUX = 192;
679 
680     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
681     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
682 
683     // The bit position of `startTimestamp` in packed ownership.
684     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
685 
686     // The bit mask of the `burned` bit in packed ownership.
687     uint256 private constant _BITMASK_BURNED = 1 << 224;
688 
689     // The bit position of the `nextInitialized` bit in packed ownership.
690     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
691 
692     // The bit mask of the `nextInitialized` bit in packed ownership.
693     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
694 
695     // The bit position of `extraData` in packed ownership.
696     uint256 private constant _BITPOS_EXTRA_DATA = 232;
697 
698     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
699     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
700 
701     // The mask of the lower 160 bits for addresses.
702     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
703 
704     // The maximum `quantity` that can be minted with {_mintERC2309}.
705     // This limit is to prevent overflows on the address data entries.
706     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
707     // is required to cause an overflow, which is unrealistic.
708     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
709 
710     // The `Transfer` event signature is given by:
711     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
712     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
713         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
714 
715     // =============================================================
716     //                            STORAGE
717     // =============================================================
718 
719     // The next token ID to be minted.
720     uint256 private _currentIndex;
721 
722     // The number of tokens burned.
723     uint256 private _burnCounter;
724 
725     // Token name
726     string private _name;
727 
728     // Token symbol
729     string private _symbol;
730 
731     // Mapping from token ID to ownership details
732     // An empty struct value does not necessarily mean the token is unowned.
733     // See {_packedOwnershipOf} implementation for details.
734     //
735     // Bits Layout:
736     // - [0..159]   `addr`
737     // - [160..223] `startTimestamp`
738     // - [224]      `burned`
739     // - [225]      `nextInitialized`
740     // - [232..255] `extraData`
741     mapping(uint256 => uint256) private _packedOwnerships;
742 
743     // Mapping owner address to address data.
744     //
745     // Bits Layout:
746     // - [0..63]    `balance`
747     // - [64..127]  `numberMinted`
748     // - [128..191] `numberBurned`
749     // - [192..255] `aux`
750     mapping(address => uint256) private _packedAddressData;
751 
752     // Mapping from token ID to approved address.
753     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
754 
755     // Mapping from owner to operator approvals
756     mapping(address => mapping(address => bool)) private _operatorApprovals;
757 
758     // =============================================================
759     //                          CONSTRUCTOR
760     // =============================================================
761 
762     constructor(string memory name_, string memory symbol_) {
763         _name = name_;
764         _symbol = symbol_;
765         _currentIndex = _startTokenId();
766     }
767 
768     // =============================================================
769     //                   TOKEN COUNTING OPERATIONS
770     // =============================================================
771 
772     /**
773      * @dev Returns the starting token ID.
774      * To change the starting token ID, please override this function.
775      */
776     function _startTokenId() internal view virtual returns (uint256) {
777         return 0;
778     }
779 
780     /**
781      * @dev Returns the next token ID to be minted.
782      */
783     function _nextTokenId() internal view virtual returns (uint256) {
784         return _currentIndex;
785     }
786 
787     /**
788      * @dev Returns the total number of tokens in existence.
789      * Burned tokens will reduce the count.
790      * To get the total number of tokens minted, please see {_totalMinted}.
791      */
792     function totalSupply() public view virtual override returns (uint256) {
793         // Counter underflow is impossible as _burnCounter cannot be incremented
794         // more than `_currentIndex - _startTokenId()` times.
795         unchecked {
796             return _currentIndex - _burnCounter - _startTokenId();
797         }
798     }
799 
800     /**
801      * @dev Returns the total amount of tokens minted in the contract.
802      */
803     function _totalMinted() internal view virtual returns (uint256) {
804         // Counter underflow is impossible as `_currentIndex` does not decrement,
805         // and it is initialized to `_startTokenId()`.
806         unchecked {
807             return _currentIndex - _startTokenId();
808         }
809     }
810 
811     /**
812      * @dev Returns the total number of tokens burned.
813      */
814     function _totalBurned() internal view virtual returns (uint256) {
815         return _burnCounter;
816     }
817 
818     // =============================================================
819     //                    ADDRESS DATA OPERATIONS
820     // =============================================================
821 
822     /**
823      * @dev Returns the number of tokens in `owner`'s account.
824      */
825     function balanceOf(address owner) public view virtual override returns (uint256) {
826         if (owner == address(0)) revert BalanceQueryForZeroAddress();
827         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
828     }
829 
830     /**
831      * Returns the number of tokens minted by `owner`.
832      */
833     function _numberMinted(address owner) internal view returns (uint256) {
834         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
835     }
836 
837     /**
838      * Returns the number of tokens burned by or on behalf of `owner`.
839      */
840     function _numberBurned(address owner) internal view returns (uint256) {
841         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
842     }
843 
844     /**
845      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
846      */
847     function _getAux(address owner) internal view returns (uint64) {
848         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
849     }
850 
851     /**
852      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
853      * If there are multiple variables, please pack them into a uint64.
854      */
855     function _setAux(address owner, uint64 aux) internal virtual {
856         uint256 packed = _packedAddressData[owner];
857         uint256 auxCasted;
858         // Cast `aux` with assembly to avoid redundant masking.
859         assembly {
860             auxCasted := aux
861         }
862         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
863         _packedAddressData[owner] = packed;
864     }
865 
866     // =============================================================
867     //                            IERC165
868     // =============================================================
869 
870     /**
871      * @dev Returns true if this contract implements the interface defined by
872      * `interfaceId`. See the corresponding
873      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
874      * to learn more about how these ids are created.
875      *
876      * This function call must use less than 30000 gas.
877      */
878     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
879         // The interface IDs are constants representing the first 4 bytes
880         // of the XOR of all function selectors in the interface.
881         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
882         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
883         return
884             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
885             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
886             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
887     }
888 
889     // =============================================================
890     //                        IERC721Metadata
891     // =============================================================
892 
893     /**
894      * @dev Returns the token collection name.
895      */
896     function name() public view virtual override returns (string memory) {
897         return _name;
898     }
899 
900     /**
901      * @dev Returns the token collection symbol.
902      */
903     function symbol() public view virtual override returns (string memory) {
904         return _symbol;
905     }
906 
907     /**
908      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
909      */
910     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
911         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
912 
913         string memory baseURI = _baseURI();
914         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
915     }
916 
917     /**
918      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
919      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
920      * by default, it can be overridden in child contracts.
921      */
922     function _baseURI() internal view virtual returns (string memory) {
923         return '';
924     }
925 
926     // =============================================================
927     //                     OWNERSHIPS OPERATIONS
928     // =============================================================
929 
930     /**
931      * @dev Returns the owner of the `tokenId` token.
932      *
933      * Requirements:
934      *
935      * - `tokenId` must exist.
936      */
937     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
938         return address(uint160(_packedOwnershipOf(tokenId)));
939     }
940 
941     /**
942      * @dev Gas spent here starts off proportional to the maximum mint batch size.
943      * It gradually moves to O(1) as tokens get transferred around over time.
944      */
945     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
946         return _unpackedOwnership(_packedOwnershipOf(tokenId));
947     }
948 
949     /**
950      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
951      */
952     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
953         return _unpackedOwnership(_packedOwnerships[index]);
954     }
955 
956     /**
957      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
958      */
959     function _initializeOwnershipAt(uint256 index) internal virtual {
960         if (_packedOwnerships[index] == 0) {
961             _packedOwnerships[index] = _packedOwnershipOf(index);
962         }
963     }
964 
965     /**
966      * Returns the packed ownership data of `tokenId`.
967      */
968     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
969         uint256 curr = tokenId;
970 
971         unchecked {
972             if (_startTokenId() <= curr)
973                 if (curr < _currentIndex) {
974                     uint256 packed = _packedOwnerships[curr];
975                     // If not burned.
976                     if (packed & _BITMASK_BURNED == 0) {
977                         // Invariant:
978                         // There will always be an initialized ownership slot
979                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
980                         // before an unintialized ownership slot
981                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
982                         // Hence, `curr` will not underflow.
983                         //
984                         // We can directly compare the packed value.
985                         // If the address is zero, packed will be zero.
986                         while (packed == 0) {
987                             packed = _packedOwnerships[--curr];
988                         }
989                         return packed;
990                     }
991                 }
992         }
993         revert OwnerQueryForNonexistentToken();
994     }
995 
996     /**
997      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
998      */
999     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1000         ownership.addr = address(uint160(packed));
1001         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1002         ownership.burned = packed & _BITMASK_BURNED != 0;
1003         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1004     }
1005 
1006     /**
1007      * @dev Packs ownership data into a single uint256.
1008      */
1009     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1010         assembly {
1011             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1012             owner := and(owner, _BITMASK_ADDRESS)
1013             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1014             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1015         }
1016     }
1017 
1018     /**
1019      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1020      */
1021     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1022         // For branchless setting of the `nextInitialized` flag.
1023         assembly {
1024             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1025             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1026         }
1027     }
1028 
1029     // =============================================================
1030     //                      APPROVAL OPERATIONS
1031     // =============================================================
1032 
1033     /**
1034      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1035      * The approval is cleared when the token is transferred.
1036      *
1037      * Only a single account can be approved at a time, so approving the
1038      * zero address clears previous approvals.
1039      *
1040      * Requirements:
1041      *
1042      * - The caller must own the token or be an approved operator.
1043      * - `tokenId` must exist.
1044      *
1045      * Emits an {Approval} event.
1046      */
1047     function approve(address to, uint256 tokenId) public payable virtual override {
1048         address owner = ownerOf(tokenId);
1049 
1050         if (_msgSenderERC721A() != owner)
1051             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1052                 revert ApprovalCallerNotOwnerNorApproved();
1053             }
1054 
1055         _tokenApprovals[tokenId].value = to;
1056         emit Approval(owner, to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev Returns the account approved for `tokenId` token.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      */
1066     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1067         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1068 
1069         return _tokenApprovals[tokenId].value;
1070     }
1071 
1072     /**
1073      * @dev Approve or remove `operator` as an operator for the caller.
1074      * Operators can call {transferFrom} or {safeTransferFrom}
1075      * for any token owned by the caller.
1076      *
1077      * Requirements:
1078      *
1079      * - The `operator` cannot be the caller.
1080      *
1081      * Emits an {ApprovalForAll} event.
1082      */
1083     function setApprovalForAll(address operator, bool approved) public virtual override {
1084         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1085         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1086     }
1087 
1088     /**
1089      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1090      *
1091      * See {setApprovalForAll}.
1092      */
1093     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1094         return _operatorApprovals[owner][operator];
1095     }
1096 
1097     /**
1098      * @dev Returns whether `tokenId` exists.
1099      *
1100      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1101      *
1102      * Tokens start existing when they are minted. See {_mint}.
1103      */
1104     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1105         return
1106             _startTokenId() <= tokenId &&
1107             tokenId < _currentIndex && // If within bounds,
1108             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1109     }
1110 
1111     /**
1112      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1113      */
1114     function _isSenderApprovedOrOwner(
1115         address approvedAddress,
1116         address owner,
1117         address msgSender
1118     ) private pure returns (bool result) {
1119         assembly {
1120             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1121             owner := and(owner, _BITMASK_ADDRESS)
1122             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1123             msgSender := and(msgSender, _BITMASK_ADDRESS)
1124             // `msgSender == owner || msgSender == approvedAddress`.
1125             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1126         }
1127     }
1128 
1129     /**
1130      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1131      */
1132     function _getApprovedSlotAndAddress(uint256 tokenId)
1133         private
1134         view
1135         returns (uint256 approvedAddressSlot, address approvedAddress)
1136     {
1137         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1138         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1139         assembly {
1140             approvedAddressSlot := tokenApproval.slot
1141             approvedAddress := sload(approvedAddressSlot)
1142         }
1143     }
1144 
1145     // =============================================================
1146     //                      TRANSFER OPERATIONS
1147     // =============================================================
1148 
1149     /**
1150      * @dev Transfers `tokenId` from `from` to `to`.
1151      *
1152      * Requirements:
1153      *
1154      * - `from` cannot be the zero address.
1155      * - `to` cannot be the zero address.
1156      * - `tokenId` token must be owned by `from`.
1157      * - If the caller is not `from`, it must be approved to move this token
1158      * by either {approve} or {setApprovalForAll}.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function transferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) public payable virtual override {
1167         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1168 
1169         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1170 
1171         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1172 
1173         // The nested ifs save around 20+ gas over a compound boolean condition.
1174         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1175             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1176 
1177         if (to == address(0)) revert TransferToZeroAddress();
1178 
1179         _beforeTokenTransfers(from, to, tokenId, 1);
1180 
1181         // Clear approvals from the previous owner.
1182         assembly {
1183             if approvedAddress {
1184                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1185                 sstore(approvedAddressSlot, 0)
1186             }
1187         }
1188 
1189         // Underflow of the sender's balance is impossible because we check for
1190         // ownership above and the recipient's balance can't realistically overflow.
1191         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1192         unchecked {
1193             // We can directly increment and decrement the balances.
1194             --_packedAddressData[from]; // Updates: `balance -= 1`.
1195             ++_packedAddressData[to]; // Updates: `balance += 1`.
1196 
1197             // Updates:
1198             // - `address` to the next owner.
1199             // - `startTimestamp` to the timestamp of transfering.
1200             // - `burned` to `false`.
1201             // - `nextInitialized` to `true`.
1202             _packedOwnerships[tokenId] = _packOwnershipData(
1203                 to,
1204                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1205             );
1206 
1207             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1208             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1209                 uint256 nextTokenId = tokenId + 1;
1210                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1211                 if (_packedOwnerships[nextTokenId] == 0) {
1212                     // If the next slot is within bounds.
1213                     if (nextTokenId != _currentIndex) {
1214                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1215                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1216                     }
1217                 }
1218             }
1219         }
1220 
1221         emit Transfer(from, to, tokenId);
1222         _afterTokenTransfers(from, to, tokenId, 1);
1223     }
1224 
1225     /**
1226      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1227      */
1228     function safeTransferFrom(
1229         address from,
1230         address to,
1231         uint256 tokenId
1232     ) public payable virtual override {
1233         safeTransferFrom(from, to, tokenId, '');
1234     }
1235 
1236     /**
1237      * @dev Safely transfers `tokenId` token from `from` to `to`.
1238      *
1239      * Requirements:
1240      *
1241      * - `from` cannot be the zero address.
1242      * - `to` cannot be the zero address.
1243      * - `tokenId` token must exist and be owned by `from`.
1244      * - If the caller is not `from`, it must be approved to move this token
1245      * by either {approve} or {setApprovalForAll}.
1246      * - If `to` refers to a smart contract, it must implement
1247      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function safeTransferFrom(
1252         address from,
1253         address to,
1254         uint256 tokenId,
1255         bytes memory _data
1256     ) public payable virtual override {
1257         transferFrom(from, to, tokenId);
1258         if (to.code.length != 0)
1259             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1260                 revert TransferToNonERC721ReceiverImplementer();
1261             }
1262     }
1263 
1264     /**
1265      * @dev Hook that is called before a set of serially-ordered token IDs
1266      * are about to be transferred. This includes minting.
1267      * And also called before burning one token.
1268      *
1269      * `startTokenId` - the first token ID to be transferred.
1270      * `quantity` - the amount to be transferred.
1271      *
1272      * Calling conditions:
1273      *
1274      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1275      * transferred to `to`.
1276      * - When `from` is zero, `tokenId` will be minted for `to`.
1277      * - When `to` is zero, `tokenId` will be burned by `from`.
1278      * - `from` and `to` are never both zero.
1279      */
1280     function _beforeTokenTransfers(
1281         address from,
1282         address to,
1283         uint256 startTokenId,
1284         uint256 quantity
1285     ) internal virtual {}
1286 
1287     /**
1288      * @dev Hook that is called after a set of serially-ordered token IDs
1289      * have been transferred. This includes minting.
1290      * And also called after one token has been burned.
1291      *
1292      * `startTokenId` - the first token ID to be transferred.
1293      * `quantity` - the amount to be transferred.
1294      *
1295      * Calling conditions:
1296      *
1297      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1298      * transferred to `to`.
1299      * - When `from` is zero, `tokenId` has been minted for `to`.
1300      * - When `to` is zero, `tokenId` has been burned by `from`.
1301      * - `from` and `to` are never both zero.
1302      */
1303     function _afterTokenTransfers(
1304         address from,
1305         address to,
1306         uint256 startTokenId,
1307         uint256 quantity
1308     ) internal virtual {}
1309 
1310     /**
1311      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1312      *
1313      * `from` - Previous owner of the given token ID.
1314      * `to` - Target address that will receive the token.
1315      * `tokenId` - Token ID to be transferred.
1316      * `_data` - Optional data to send along with the call.
1317      *
1318      * Returns whether the call correctly returned the expected magic value.
1319      */
1320     function _checkContractOnERC721Received(
1321         address from,
1322         address to,
1323         uint256 tokenId,
1324         bytes memory _data
1325     ) private returns (bool) {
1326         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1327             bytes4 retval
1328         ) {
1329             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1330         } catch (bytes memory reason) {
1331             if (reason.length == 0) {
1332                 revert TransferToNonERC721ReceiverImplementer();
1333             } else {
1334                 assembly {
1335                     revert(add(32, reason), mload(reason))
1336                 }
1337             }
1338         }
1339     }
1340 
1341     // =============================================================
1342     //                        MINT OPERATIONS
1343     // =============================================================
1344 
1345     /**
1346      * @dev Mints `quantity` tokens and transfers them to `to`.
1347      *
1348      * Requirements:
1349      *
1350      * - `to` cannot be the zero address.
1351      * - `quantity` must be greater than 0.
1352      *
1353      * Emits a {Transfer} event for each mint.
1354      */
1355     function _mint(address to, uint256 quantity) internal virtual {
1356         uint256 startTokenId = _currentIndex;
1357         if (quantity == 0) revert MintZeroQuantity();
1358 
1359         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1360 
1361         // Overflows are incredibly unrealistic.
1362         // `balance` and `numberMinted` have a maximum limit of 2**64.
1363         // `tokenId` has a maximum limit of 2**256.
1364         unchecked {
1365             // Updates:
1366             // - `balance += quantity`.
1367             // - `numberMinted += quantity`.
1368             //
1369             // We can directly add to the `balance` and `numberMinted`.
1370             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1371 
1372             // Updates:
1373             // - `address` to the owner.
1374             // - `startTimestamp` to the timestamp of minting.
1375             // - `burned` to `false`.
1376             // - `nextInitialized` to `quantity == 1`.
1377             _packedOwnerships[startTokenId] = _packOwnershipData(
1378                 to,
1379                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1380             );
1381 
1382             uint256 toMasked;
1383             uint256 end = startTokenId + quantity;
1384 
1385             // Use assembly to loop and emit the `Transfer` event for gas savings.
1386             // The duplicated `log4` removes an extra check and reduces stack juggling.
1387             // The assembly, together with the surrounding Solidity code, have been
1388             // delicately arranged to nudge the compiler into producing optimized opcodes.
1389             assembly {
1390                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1391                 toMasked := and(to, _BITMASK_ADDRESS)
1392                 // Emit the `Transfer` event.
1393                 log4(
1394                     0, // Start of data (0, since no data).
1395                     0, // End of data (0, since no data).
1396                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1397                     0, // `address(0)`.
1398                     toMasked, // `to`.
1399                     startTokenId // `tokenId`.
1400                 )
1401 
1402                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1403                 // that overflows uint256 will make the loop run out of gas.
1404                 // The compiler will optimize the `iszero` away for performance.
1405                 for {
1406                     let tokenId := add(startTokenId, 1)
1407                 } iszero(eq(tokenId, end)) {
1408                     tokenId := add(tokenId, 1)
1409                 } {
1410                     // Emit the `Transfer` event. Similar to above.
1411                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1412                 }
1413             }
1414             if (toMasked == 0) revert MintToZeroAddress();
1415 
1416             _currentIndex = end;
1417         }
1418         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1419     }
1420 
1421     /**
1422      * @dev Mints `quantity` tokens and transfers them to `to`.
1423      *
1424      * This function is intended for efficient minting only during contract creation.
1425      *
1426      * It emits only one {ConsecutiveTransfer} as defined in
1427      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1428      * instead of a sequence of {Transfer} event(s).
1429      *
1430      * Calling this function outside of contract creation WILL make your contract
1431      * non-compliant with the ERC721 standard.
1432      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1433      * {ConsecutiveTransfer} event is only permissible during contract creation.
1434      *
1435      * Requirements:
1436      *
1437      * - `to` cannot be the zero address.
1438      * - `quantity` must be greater than 0.
1439      *
1440      * Emits a {ConsecutiveTransfer} event.
1441      */
1442     function _mintERC2309(address to, uint256 quantity) internal virtual {
1443         uint256 startTokenId = _currentIndex;
1444         if (to == address(0)) revert MintToZeroAddress();
1445         if (quantity == 0) revert MintZeroQuantity();
1446         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1447 
1448         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1449 
1450         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1451         unchecked {
1452             // Updates:
1453             // - `balance += quantity`.
1454             // - `numberMinted += quantity`.
1455             //
1456             // We can directly add to the `balance` and `numberMinted`.
1457             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1458 
1459             // Updates:
1460             // - `address` to the owner.
1461             // - `startTimestamp` to the timestamp of minting.
1462             // - `burned` to `false`.
1463             // - `nextInitialized` to `quantity == 1`.
1464             _packedOwnerships[startTokenId] = _packOwnershipData(
1465                 to,
1466                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1467             );
1468 
1469             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1470 
1471             _currentIndex = startTokenId + quantity;
1472         }
1473         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1474     }
1475 
1476     /**
1477      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1478      *
1479      * Requirements:
1480      *
1481      * - If `to` refers to a smart contract, it must implement
1482      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1483      * - `quantity` must be greater than 0.
1484      *
1485      * See {_mint}.
1486      *
1487      * Emits a {Transfer} event for each mint.
1488      */
1489     function _safeMint(
1490         address to,
1491         uint256 quantity,
1492         bytes memory _data
1493     ) internal virtual {
1494         _mint(to, quantity);
1495 
1496         unchecked {
1497             if (to.code.length != 0) {
1498                 uint256 end = _currentIndex;
1499                 uint256 index = end - quantity;
1500                 do {
1501                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1502                         revert TransferToNonERC721ReceiverImplementer();
1503                     }
1504                 } while (index < end);
1505                 // Reentrancy protection.
1506                 if (_currentIndex != end) revert();
1507             }
1508         }
1509     }
1510 
1511     /**
1512      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1513      */
1514     function _safeMint(address to, uint256 quantity) internal virtual {
1515         _safeMint(to, quantity, '');
1516     }
1517 
1518     // =============================================================
1519     //                        BURN OPERATIONS
1520     // =============================================================
1521 
1522     /**
1523      * @dev Equivalent to `_burn(tokenId, false)`.
1524      */
1525     function _burn(uint256 tokenId) internal virtual {
1526         _burn(tokenId, false);
1527     }
1528 
1529     /**
1530      * @dev Destroys `tokenId`.
1531      * The approval is cleared when the token is burned.
1532      *
1533      * Requirements:
1534      *
1535      * - `tokenId` must exist.
1536      *
1537      * Emits a {Transfer} event.
1538      */
1539     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1540         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1541 
1542         address from = address(uint160(prevOwnershipPacked));
1543 
1544         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1545 
1546         if (approvalCheck) {
1547             // The nested ifs save around 20+ gas over a compound boolean condition.
1548             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1549                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1550         }
1551 
1552         _beforeTokenTransfers(from, address(0), tokenId, 1);
1553 
1554         // Clear approvals from the previous owner.
1555         assembly {
1556             if approvedAddress {
1557                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1558                 sstore(approvedAddressSlot, 0)
1559             }
1560         }
1561 
1562         // Underflow of the sender's balance is impossible because we check for
1563         // ownership above and the recipient's balance can't realistically overflow.
1564         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1565         unchecked {
1566             // Updates:
1567             // - `balance -= 1`.
1568             // - `numberBurned += 1`.
1569             //
1570             // We can directly decrement the balance, and increment the number burned.
1571             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1572             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1573 
1574             // Updates:
1575             // - `address` to the last owner.
1576             // - `startTimestamp` to the timestamp of burning.
1577             // - `burned` to `true`.
1578             // - `nextInitialized` to `true`.
1579             _packedOwnerships[tokenId] = _packOwnershipData(
1580                 from,
1581                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1582             );
1583 
1584             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1585             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1586                 uint256 nextTokenId = tokenId + 1;
1587                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1588                 if (_packedOwnerships[nextTokenId] == 0) {
1589                     // If the next slot is within bounds.
1590                     if (nextTokenId != _currentIndex) {
1591                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1592                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1593                     }
1594                 }
1595             }
1596         }
1597 
1598         emit Transfer(from, address(0), tokenId);
1599         _afterTokenTransfers(from, address(0), tokenId, 1);
1600 
1601         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1602         unchecked {
1603             _burnCounter++;
1604         }
1605     }
1606 
1607     // =============================================================
1608     //                     EXTRA DATA OPERATIONS
1609     // =============================================================
1610 
1611     /**
1612      * @dev Directly sets the extra data for the ownership data `index`.
1613      */
1614     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1615         uint256 packed = _packedOwnerships[index];
1616         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1617         uint256 extraDataCasted;
1618         // Cast `extraData` with assembly to avoid redundant masking.
1619         assembly {
1620             extraDataCasted := extraData
1621         }
1622         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1623         _packedOwnerships[index] = packed;
1624     }
1625 
1626     /**
1627      * @dev Called during each token transfer to set the 24bit `extraData` field.
1628      * Intended to be overridden by the cosumer contract.
1629      *
1630      * `previousExtraData` - the value of `extraData` before transfer.
1631      *
1632      * Calling conditions:
1633      *
1634      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1635      * transferred to `to`.
1636      * - When `from` is zero, `tokenId` will be minted for `to`.
1637      * - When `to` is zero, `tokenId` will be burned by `from`.
1638      * - `from` and `to` are never both zero.
1639      */
1640     function _extraData(
1641         address from,
1642         address to,
1643         uint24 previousExtraData
1644     ) internal view virtual returns (uint24) {}
1645 
1646     /**
1647      * @dev Returns the next extra data for the packed ownership data.
1648      * The returned result is shifted into position.
1649      */
1650     function _nextExtraData(
1651         address from,
1652         address to,
1653         uint256 prevOwnershipPacked
1654     ) private view returns (uint256) {
1655         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1656         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1657     }
1658 
1659     // =============================================================
1660     //                       OTHER OPERATIONS
1661     // =============================================================
1662 
1663     /**
1664      * @dev Returns the message sender (defaults to `msg.sender`).
1665      *
1666      * If you are writing GSN compatible contracts, you need to override this function.
1667      */
1668     function _msgSenderERC721A() internal view virtual returns (address) {
1669         return msg.sender;
1670     }
1671 
1672     /**
1673      * @dev Converts a uint256 to its ASCII string decimal representation.
1674      */
1675     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1676         assembly {
1677             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1678             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1679             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1680             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1681             let m := add(mload(0x40), 0xa0)
1682             // Update the free memory pointer to allocate.
1683             mstore(0x40, m)
1684             // Assign the `str` to the end.
1685             str := sub(m, 0x20)
1686             // Zeroize the slot after the string.
1687             mstore(str, 0)
1688 
1689             // Cache the end of the memory to calculate the length later.
1690             let end := str
1691 
1692             // We write the string from rightmost digit to leftmost digit.
1693             // The following is essentially a do-while loop that also handles the zero case.
1694             // prettier-ignore
1695             for { let temp := value } 1 {} {
1696                 str := sub(str, 1)
1697                 // Write the character to the pointer.
1698                 // The ASCII index of the '0' character is 48.
1699                 mstore8(str, add(48, mod(temp, 10)))
1700                 // Keep dividing `temp` until zero.
1701                 temp := div(temp, 10)
1702                 // prettier-ignore
1703                 if iszero(temp) { break }
1704             }
1705 
1706             let length := sub(end, str)
1707             // Move the pointer 32 bytes leftwards to make room for the length.
1708             str := sub(str, 0x20)
1709             // Store the length.
1710             mstore(str, length)
1711         }
1712     }
1713 }
1714 
1715 // File: @openzeppelin/contracts/utils/Context.sol
1716 
1717 
1718 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1719 
1720 pragma solidity ^0.8.0;
1721 
1722 /**
1723  * @dev Provides information about the current execution context, including the
1724  * sender of the transaction and its data. While these are generally available
1725  * via msg.sender and msg.data, they should not be accessed in such a direct
1726  * manner, since when dealing with meta-transactions the account sending and
1727  * paying for execution may not be the actual sender (as far as an application
1728  * is concerned).
1729  *
1730  * This contract is only required for intermediate, library-like contracts.
1731  */
1732 abstract contract Context {
1733     function _msgSender() internal view virtual returns (address) {
1734         return msg.sender;
1735     }
1736 
1737     function _msgData() internal view virtual returns (bytes calldata) {
1738         return msg.data;
1739     }
1740 }
1741 
1742 // File: @openzeppelin/contracts/access/Ownable.sol
1743 
1744 
1745 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1746 
1747 pragma solidity ^0.8.0;
1748 
1749 
1750 /**
1751  * @dev Contract module which provides a basic access control mechanism, where
1752  * there is an account (an owner) that can be granted exclusive access to
1753  * specific functions.
1754  *
1755  * By default, the owner account will be the one that deploys the contract. This
1756  * can later be changed with {transferOwnership}.
1757  *
1758  * This module is used through inheritance. It will make available the modifier
1759  * `onlyOwner`, which can be applied to your functions to restrict their use to
1760  * the owner.
1761  */
1762 abstract contract Ownable is Context {
1763     address private _owner;
1764 
1765     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1766 
1767     /**
1768      * @dev Initializes the contract setting the deployer as the initial owner.
1769      */
1770     constructor() {
1771         _transferOwnership(_msgSender());
1772     }
1773 
1774     /**
1775      * @dev Throws if called by any account other than the owner.
1776      */
1777     modifier onlyOwner() {
1778         _checkOwner();
1779         _;
1780     }
1781 
1782     /**
1783      * @dev Returns the address of the current owner.
1784      */
1785     function owner() public view virtual returns (address) {
1786         return _owner;
1787     }
1788 
1789     /**
1790      * @dev Throws if the sender is not the owner.
1791      */
1792     function _checkOwner() internal view virtual {
1793         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1794     }
1795 
1796     /**
1797      * @dev Leaves the contract without owner. It will not be possible to call
1798      * `onlyOwner` functions anymore. Can only be called by the current owner.
1799      *
1800      * NOTE: Renouncing ownership will leave the contract without an owner,
1801      * thereby removing any functionality that is only available to the owner.
1802      */
1803     function renounceOwnership() public virtual onlyOwner {
1804         _transferOwnership(address(0));
1805     }
1806 
1807     /**
1808      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1809      * Can only be called by the current owner.
1810      */
1811     function transferOwnership(address newOwner) public virtual onlyOwner {
1812         require(newOwner != address(0), "Ownable: new owner is the zero address");
1813         _transferOwnership(newOwner);
1814     }
1815 
1816     /**
1817      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1818      * Internal function without access restriction.
1819      */
1820     function _transferOwnership(address newOwner) internal virtual {
1821         address oldOwner = _owner;
1822         _owner = newOwner;
1823         emit OwnershipTransferred(oldOwner, newOwner);
1824     }
1825 }
1826 
1827 // File: @openzeppelin/contracts/utils/math/Math.sol
1828 
1829 
1830 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1831 
1832 pragma solidity ^0.8.0;
1833 
1834 /**
1835  * @dev Standard math utilities missing in the Solidity language.
1836  */
1837 library Math {
1838     enum Rounding {
1839         Down, // Toward negative infinity
1840         Up, // Toward infinity
1841         Zero // Toward zero
1842     }
1843 
1844     /**
1845      * @dev Returns the largest of two numbers.
1846      */
1847     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1848         return a > b ? a : b;
1849     }
1850 
1851     /**
1852      * @dev Returns the smallest of two numbers.
1853      */
1854     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1855         return a < b ? a : b;
1856     }
1857 
1858     /**
1859      * @dev Returns the average of two numbers. The result is rounded towards
1860      * zero.
1861      */
1862     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1863         // (a + b) / 2 can overflow.
1864         return (a & b) + (a ^ b) / 2;
1865     }
1866 
1867     /**
1868      * @dev Returns the ceiling of the division of two numbers.
1869      *
1870      * This differs from standard division with `/` in that it rounds up instead
1871      * of rounding down.
1872      */
1873     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1874         // (a + b - 1) / b can overflow on addition, so we distribute.
1875         return a == 0 ? 0 : (a - 1) / b + 1;
1876     }
1877 
1878     /**
1879      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1880      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1881      * with further edits by Uniswap Labs also under MIT license.
1882      */
1883     function mulDiv(
1884         uint256 x,
1885         uint256 y,
1886         uint256 denominator
1887     ) internal pure returns (uint256 result) {
1888         unchecked {
1889             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1890             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1891             // variables such that product = prod1 * 2^256 + prod0.
1892             uint256 prod0; // Least significant 256 bits of the product
1893             uint256 prod1; // Most significant 256 bits of the product
1894             assembly {
1895                 let mm := mulmod(x, y, not(0))
1896                 prod0 := mul(x, y)
1897                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1898             }
1899 
1900             // Handle non-overflow cases, 256 by 256 division.
1901             if (prod1 == 0) {
1902                 return prod0 / denominator;
1903             }
1904 
1905             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1906             require(denominator > prod1);
1907 
1908             ///////////////////////////////////////////////
1909             // 512 by 256 division.
1910             ///////////////////////////////////////////////
1911 
1912             // Make division exact by subtracting the remainder from [prod1 prod0].
1913             uint256 remainder;
1914             assembly {
1915                 // Compute remainder using mulmod.
1916                 remainder := mulmod(x, y, denominator)
1917 
1918                 // Subtract 256 bit number from 512 bit number.
1919                 prod1 := sub(prod1, gt(remainder, prod0))
1920                 prod0 := sub(prod0, remainder)
1921             }
1922 
1923             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1924             // See https://cs.stackexchange.com/q/138556/92363.
1925 
1926             // Does not overflow because the denominator cannot be zero at this stage in the function.
1927             uint256 twos = denominator & (~denominator + 1);
1928             assembly {
1929                 // Divide denominator by twos.
1930                 denominator := div(denominator, twos)
1931 
1932                 // Divide [prod1 prod0] by twos.
1933                 prod0 := div(prod0, twos)
1934 
1935                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1936                 twos := add(div(sub(0, twos), twos), 1)
1937             }
1938 
1939             // Shift in bits from prod1 into prod0.
1940             prod0 |= prod1 * twos;
1941 
1942             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1943             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1944             // four bits. That is, denominator * inv = 1 mod 2^4.
1945             uint256 inverse = (3 * denominator) ^ 2;
1946 
1947             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1948             // in modular arithmetic, doubling the correct bits in each step.
1949             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1950             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1951             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1952             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1953             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1954             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1955 
1956             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1957             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1958             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1959             // is no longer required.
1960             result = prod0 * inverse;
1961             return result;
1962         }
1963     }
1964 
1965     /**
1966      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1967      */
1968     function mulDiv(
1969         uint256 x,
1970         uint256 y,
1971         uint256 denominator,
1972         Rounding rounding
1973     ) internal pure returns (uint256) {
1974         uint256 result = mulDiv(x, y, denominator);
1975         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1976             result += 1;
1977         }
1978         return result;
1979     }
1980 
1981     /**
1982      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1983      *
1984      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1985      */
1986     function sqrt(uint256 a) internal pure returns (uint256) {
1987         if (a == 0) {
1988             return 0;
1989         }
1990 
1991         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1992         //
1993         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1994         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1995         //
1996         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1997         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1998         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1999         //
2000         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
2001         uint256 result = 1 << (log2(a) >> 1);
2002 
2003         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
2004         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
2005         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
2006         // into the expected uint128 result.
2007         unchecked {
2008             result = (result + a / result) >> 1;
2009             result = (result + a / result) >> 1;
2010             result = (result + a / result) >> 1;
2011             result = (result + a / result) >> 1;
2012             result = (result + a / result) >> 1;
2013             result = (result + a / result) >> 1;
2014             result = (result + a / result) >> 1;
2015             return min(result, a / result);
2016         }
2017     }
2018 
2019     /**
2020      * @notice Calculates sqrt(a), following the selected rounding direction.
2021      */
2022     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2023         unchecked {
2024             uint256 result = sqrt(a);
2025             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
2026         }
2027     }
2028 
2029     /**
2030      * @dev Return the log in base 2, rounded down, of a positive value.
2031      * Returns 0 if given 0.
2032      */
2033     function log2(uint256 value) internal pure returns (uint256) {
2034         uint256 result = 0;
2035         unchecked {
2036             if (value >> 128 > 0) {
2037                 value >>= 128;
2038                 result += 128;
2039             }
2040             if (value >> 64 > 0) {
2041                 value >>= 64;
2042                 result += 64;
2043             }
2044             if (value >> 32 > 0) {
2045                 value >>= 32;
2046                 result += 32;
2047             }
2048             if (value >> 16 > 0) {
2049                 value >>= 16;
2050                 result += 16;
2051             }
2052             if (value >> 8 > 0) {
2053                 value >>= 8;
2054                 result += 8;
2055             }
2056             if (value >> 4 > 0) {
2057                 value >>= 4;
2058                 result += 4;
2059             }
2060             if (value >> 2 > 0) {
2061                 value >>= 2;
2062                 result += 2;
2063             }
2064             if (value >> 1 > 0) {
2065                 result += 1;
2066             }
2067         }
2068         return result;
2069     }
2070 
2071     /**
2072      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2073      * Returns 0 if given 0.
2074      */
2075     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2076         unchecked {
2077             uint256 result = log2(value);
2078             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2079         }
2080     }
2081 
2082     /**
2083      * @dev Return the log in base 10, rounded down, of a positive value.
2084      * Returns 0 if given 0.
2085      */
2086     function log10(uint256 value) internal pure returns (uint256) {
2087         uint256 result = 0;
2088         unchecked {
2089             if (value >= 10**64) {
2090                 value /= 10**64;
2091                 result += 64;
2092             }
2093             if (value >= 10**32) {
2094                 value /= 10**32;
2095                 result += 32;
2096             }
2097             if (value >= 10**16) {
2098                 value /= 10**16;
2099                 result += 16;
2100             }
2101             if (value >= 10**8) {
2102                 value /= 10**8;
2103                 result += 8;
2104             }
2105             if (value >= 10**4) {
2106                 value /= 10**4;
2107                 result += 4;
2108             }
2109             if (value >= 10**2) {
2110                 value /= 10**2;
2111                 result += 2;
2112             }
2113             if (value >= 10**1) {
2114                 result += 1;
2115             }
2116         }
2117         return result;
2118     }
2119 
2120     /**
2121      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2122      * Returns 0 if given 0.
2123      */
2124     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2125         unchecked {
2126             uint256 result = log10(value);
2127             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2128         }
2129     }
2130 
2131     /**
2132      * @dev Return the log in base 256, rounded down, of a positive value.
2133      * Returns 0 if given 0.
2134      *
2135      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2136      */
2137     function log256(uint256 value) internal pure returns (uint256) {
2138         uint256 result = 0;
2139         unchecked {
2140             if (value >> 128 > 0) {
2141                 value >>= 128;
2142                 result += 16;
2143             }
2144             if (value >> 64 > 0) {
2145                 value >>= 64;
2146                 result += 8;
2147             }
2148             if (value >> 32 > 0) {
2149                 value >>= 32;
2150                 result += 4;
2151             }
2152             if (value >> 16 > 0) {
2153                 value >>= 16;
2154                 result += 2;
2155             }
2156             if (value >> 8 > 0) {
2157                 result += 1;
2158             }
2159         }
2160         return result;
2161     }
2162 
2163     /**
2164      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2165      * Returns 0 if given 0.
2166      */
2167     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2168         unchecked {
2169             uint256 result = log256(value);
2170             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2171         }
2172     }
2173 }
2174 
2175 // File: @openzeppelin/contracts/utils/Strings.sol
2176 
2177 
2178 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2179 
2180 pragma solidity ^0.8.0;
2181 
2182 
2183 /**
2184  * @dev String operations.
2185  */
2186 library Strings {
2187     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2188     uint8 private constant _ADDRESS_LENGTH = 20;
2189 
2190     /**
2191      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2192      */
2193     function toString(uint256 value) internal pure returns (string memory) {
2194         unchecked {
2195             uint256 length = Math.log10(value) + 1;
2196             string memory buffer = new string(length);
2197             uint256 ptr;
2198             /// @solidity memory-safe-assembly
2199             assembly {
2200                 ptr := add(buffer, add(32, length))
2201             }
2202             while (true) {
2203                 ptr--;
2204                 /// @solidity memory-safe-assembly
2205                 assembly {
2206                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2207                 }
2208                 value /= 10;
2209                 if (value == 0) break;
2210             }
2211             return buffer;
2212         }
2213     }
2214 
2215     /**
2216      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2217      */
2218     function toHexString(uint256 value) internal pure returns (string memory) {
2219         unchecked {
2220             return toHexString(value, Math.log256(value) + 1);
2221         }
2222     }
2223 
2224     /**
2225      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2226      */
2227     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2228         bytes memory buffer = new bytes(2 * length + 2);
2229         buffer[0] = "0";
2230         buffer[1] = "x";
2231         for (uint256 i = 2 * length + 1; i > 1; --i) {
2232             buffer[i] = _SYMBOLS[value & 0xf];
2233             value >>= 4;
2234         }
2235         require(value == 0, "Strings: hex length insufficient");
2236         return string(buffer);
2237     }
2238 
2239     /**
2240      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2241      */
2242     function toHexString(address addr) internal pure returns (string memory) {
2243         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2244     }
2245 }
2246 
2247 // File: IconZ.sol
2248 
2249 /*
2250 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2251 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2252 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2253 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2254 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2255 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2256 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2257 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2258 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2259 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0cdNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2260 MMMMMMMMMMMMMMMMMMMMMWx::c0Wk:::::::::::::::oXXo::::::::::::::::kWk..;xNMMMMMMNd::lKWx:::::::::::::::::dNMMMMMMMMMMMMMMMMMMMM
2261 MMMMMMMMMMMMMMMMMMMMMNc  .xWl               '00'                cWk.  .,dNMMMMK,  .kN:               'd0WMMMMMMMMMMMMMMMMMMMM
2262 MMMMMMMMMMMMMMMMMMMMMNc  .xWl   ,xxxxxxxxxxxON0'  .ckkkkkkx;    lWk.    .;dXMMK,  .kW0xxxxxxx;     'o0WMMMMMMMMMMMMMMMMMMMMMM
2263 MMMMMMMMMMMMMMMMMMMMMNc  .xWl   lWMMMMMMMMMMMM0'  .kMMMMMMWo    lWk.      .,dXK,  .kMMMMMMMOc'   'd0WMMMMMMMMMMMMMMMMMMMMMMMM
2264 MMMMMMMMMMMMMMMMMMMMMNc  .xWl   lWMMMMMMMMMMMM0'  .kMMMMMMWo    lWk.  .ol.  .;;.  .kMMMMMOc.   ,d0WMMMMMMMMMMMMMMMMMMMMMMMMMM
2265 MMMMMMMMMMMMMMMMMMMMMNc  .xWl   lWMMMMMMMMMMMM0'  .OMMMMMMWo    lWk.  ;XNkl.      .kMMWOc.   ,d0WMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2266 MMMMMMMMMMMMMMMMMMMMMNc  .xWl   .cccccccccccdX0'   ;ccccccc'    lWk.  ;XMMNkc.    .kWkc.     'cccccccxNMMMMMMMMMMMMMMMMMMMMMM
2267 MMMMMMMMMMMMMMMMMMMMMNc  .xWl               '00'                cWk.  ;XMMMMNkc.   ,c.               ;XMMMMMMMMMMMMMMMMMMMMMM
2268 MMMMMMMMMMMMMMMMMMMMMW0ddxKM0dddddddddddddddkNNkddddddddddddddod0WXxddOWMMMMMMNOl. :dddddddddddddddddOWMMMMMMMMMMMMMMMMMMMMMM
2269 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOdXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2270 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2271 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKOOOOOOOOOOOO0NMMMMMN0OOOOOOOOOOOOKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2272 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK;            .OMMMMMk.            ;KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2273 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK,            .kMMMMMk.            ,KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2274 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK,            .OMMMMMk.            ,KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2275 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK,           .,OMMMMMk.          ..cXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2276 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK,          lKXWMMMMMk.         .xKXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2277 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK,         .xMMMMMMMMk.         'OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2278 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0,          cOKNMMMMMk.         .oOKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2279 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK,           .,OMMMMMk.           .:XMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2280 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0kkkkkkkkkkkk0NMMMMMNOkkkkkkkkkkkkKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2281 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2282 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2283 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2284 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMbcBread
2285 */
2286 
2287 pragma solidity ^0.8.0;
2288 
2289 
2290 
2291 
2292 
2293 
2294 contract IconZ is ERC721A, Ownable, DefaultOperatorFilterer{
2295     
2296     using Strings for uint;
2297     
2298 //Standard Variables
2299     string public NR = "ipfs://HIDDEN_URI/1.json";
2300     uint public publicCost = 55000000000000000;//0.055amount in wei
2301     uint public presaleCost = 55000000000000000;//0.055amount in wei
2302     uint public constant maxSupply = 7997;
2303     uint public constant maxPerPublicMint = 20;
2304     uint public constant maxPerPresaleMint = 2;
2305     bool public presaleOnly = true;
2306     bool paused = true;
2307     bool revealed = false;
2308 
2309     bytes32 public merkleRoot;
2310 
2311     mapping(address => uint) public addressMintedBalance;
2312 
2313     constructor(
2314     ) ERC721A("Iconz", "ICNZ")payable{
2315         _mint(msg.sender, 100);
2316     }
2317 
2318     function _startTokenId() internal view virtual override returns (uint256) 
2319     {
2320         return 1;
2321     }
2322 //Public Functions
2323 
2324     function publicMint(uint qty) external payable
2325     
2326     {
2327         uint tm = totalSupply();
2328         uint _cost = publicCost;
2329         require(paused==false);
2330         require(presaleOnly==false,"Presale Only");
2331         require(msg.sender == tx.origin, "no bots Icon");
2332         require(tm + qty < 7998, "SOLD OUT!");
2333         require(msg.value + 1 > qty * _cost, "Not Enough ETH sent");
2334                                   
2335                 _mint(msg.sender, qty);
2336      
2337     }
2338 
2339 
2340 //@dev presale only mint 
2341     function presaleMint(uint qty, bytes32[] memory proof) external payable
2342     {
2343         uint tm = totalSupply();
2344         uint _cost = publicCost;
2345         require(paused==false);
2346         require(presaleOnly==true);
2347         require(addressMintedBalance[msg.sender] + qty < 3, "Only 2 per Presale");
2348         require(qty < 3, "Max amount for presale");
2349         require(tm + qty < 7998, "SOLD OUT!");
2350         require(msg.value + 1 > qty * _cost, "Not Enough ETH sent");
2351 
2352         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2353         require(MerkleProof.verify(proof, merkleRoot, leaf), "Invalid Merkle Tree proof supplied");
2354                                   
2355                 _mint(msg.sender, qty);
2356                 addressMintedBalance[msg.sender] += qty;
2357     
2358     }
2359 
2360 //***********Public Data Calls**********        
2361         function isPaused() public view returns (bool) 
2362     {
2363         return paused;
2364     }
2365 
2366         function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) 
2367      {
2368         return MerkleProof.verify(proof, merkleRoot, leaf);
2369      }
2370 //***********Metadata Functions**********
2371     string private _baseTokenURI;
2372 
2373     function _baseURI() internal view virtual override returns (string memory) 
2374     {
2375         return _baseTokenURI;
2376     }
2377 
2378     function exists(uint256 tokenId) public view returns (bool) 
2379     {
2380         return _exists(tokenId);
2381     }
2382 
2383     function tokenURI(uint tokenId) public view virtual override returns (string memory) 
2384     {
2385       if(revealed == false) 
2386       {
2387         return NR;
2388       }
2389 
2390         string memory currentBaseURI = _baseURI();
2391         return bytes(currentBaseURI).length > 0
2392         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
2393         : "";
2394     }
2395 
2396 //******OnlyOwner Functions**********
2397 
2398 function setPresaleMerkleRoot(bytes32 _root) external onlyOwner 
2399      {
2400         merkleRoot = _root;
2401      }
2402 
2403 //@dev used for changing bool state of presale period
2404 //@param tf
2405      function setPresaleOnly(bool _state) external onlyOwner 
2406      {
2407         presaleOnly = _state;//set to false for main mint
2408      }
2409 //@dev used for changing the base pointer to pinata CID
2410 //@param CID    
2411     function setBaseURI(string memory baseURI) external onlyOwner 
2412     {
2413         _baseTokenURI = baseURI;
2414     }
2415 
2416 //@dev single airdrop for gas efficiency 
2417 //@param wallet address and number to drop to address   
2418     function giftMint(address recipient, uint qty) external onlyOwner 
2419     {
2420         require(_totalMinted() + qty < 7998, "SOLD OUT!");
2421 
2422                 _mint(recipient, qty);
2423     }
2424 //@dev optimized for bulk airdrop to array of addr utilizing loop
2425 //@param CSV bracket per addr
2426     function airDrop(address[] memory users, uint qty) external onlyOwner 
2427     {
2428         for (uint256 i; i < users.length; i++) 
2429         {
2430             _mint(users[i], qty);
2431         }
2432     }
2433 //@dev bool val for returning NR or not
2434 //@param bool
2435     function reveal(bool _state) external onlyOwner 
2436     {
2437         revealed = _state;//reveal
2438     }
2439 //@dev duh
2440 //@param bool
2441     function pause(bool _state) public onlyOwner() 
2442     {
2443         paused = _state;
2444     }
2445 //@dev used for setting the cost of each individual mint after deployment based on ETH price
2446 //@param uint val
2447     function setCost(uint256 _newCost) public onlyOwner() 
2448     {
2449         publicCost = _newCost;
2450     }
2451 //@dev used for setting the cost of each individual mint after deployment based on ETH price
2452 //@param uint val
2453     function setNR(string memory _nr) public onlyOwner() 
2454     {
2455         NR = _nr;
2456     }
2457 //@dev withdraws all remaining funds from the smart contract
2458 //@param send ZERO value to when calling
2459     function withdraw() public payable onlyOwner 
2460     {
2461         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2462         require(success);
2463     }
2464 //OS ROyalties
2465 function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2466         super.transferFrom(from, to, tokenId);
2467     }
2468 
2469     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2470         super.safeTransferFrom(from, to, tokenId);
2471     }
2472 
2473     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2474         public
2475         payable
2476         override
2477         onlyAllowedOperator(from)
2478     {
2479         super.safeTransferFrom(from, to, tokenId, data);
2480     }
2481 
2482 }