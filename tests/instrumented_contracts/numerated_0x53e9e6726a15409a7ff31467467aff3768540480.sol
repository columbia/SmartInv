1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * _Available since v4.7._
84      */
85     function multiProofVerify(
86         bytes32[] memory proof,
87         bool[] memory proofFlags,
88         bytes32 root,
89         bytes32[] memory leaves
90     ) internal pure returns (bool) {
91         return processMultiProof(proof, proofFlags, leaves) == root;
92     }
93 
94     /**
95      * @dev Calldata version of {multiProofVerify}
96      *
97      * _Available since v4.7._
98      */
99     function multiProofVerifyCalldata(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32 root,
103         bytes32[] memory leaves
104     ) internal pure returns (bool) {
105         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
106     }
107 
108     /**
109      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
110      * consuming from one or the other at each step according to the instructions given by
111      * `proofFlags`.
112      *
113      * _Available since v4.7._
114      */
115     function processMultiProof(
116         bytes32[] memory proof,
117         bool[] memory proofFlags,
118         bytes32[] memory leaves
119     ) internal pure returns (bytes32 merkleRoot) {
120         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
121         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
122         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
123         // the merkle tree.
124         uint256 leavesLen = leaves.length;
125         uint256 totalHashes = proofFlags.length;
126 
127         // Check proof validity.
128         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
129 
130         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
131         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
132         bytes32[] memory hashes = new bytes32[](totalHashes);
133         uint256 leafPos = 0;
134         uint256 hashPos = 0;
135         uint256 proofPos = 0;
136         // At each step, we compute the next hash using two values:
137         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
138         //   get the next hash.
139         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
140         //   `proof` array.
141         for (uint256 i = 0; i < totalHashes; i++) {
142             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
143             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
144             hashes[i] = _hashPair(a, b);
145         }
146 
147         if (totalHashes > 0) {
148             return hashes[totalHashes - 1];
149         } else if (leavesLen > 0) {
150             return leaves[0];
151         } else {
152             return proof[0];
153         }
154     }
155 
156     /**
157      * @dev Calldata version of {processMultiProof}
158      *
159      * _Available since v4.7._
160      */
161     function processMultiProofCalldata(
162         bytes32[] calldata proof,
163         bool[] calldata proofFlags,
164         bytes32[] memory leaves
165     ) internal pure returns (bytes32 merkleRoot) {
166         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
167         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
168         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
169         // the merkle tree.
170         uint256 leavesLen = leaves.length;
171         uint256 totalHashes = proofFlags.length;
172 
173         // Check proof validity.
174         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
175 
176         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
177         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
178         bytes32[] memory hashes = new bytes32[](totalHashes);
179         uint256 leafPos = 0;
180         uint256 hashPos = 0;
181         uint256 proofPos = 0;
182         // At each step, we compute the next hash using two values:
183         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
184         //   get the next hash.
185         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
186         //   `proof` array.
187         for (uint256 i = 0; i < totalHashes; i++) {
188             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
189             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
190             hashes[i] = _hashPair(a, b);
191         }
192 
193         if (totalHashes > 0) {
194             return hashes[totalHashes - 1];
195         } else if (leavesLen > 0) {
196             return leaves[0];
197         } else {
198             return proof[0];
199         }
200     }
201 
202     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
203         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
204     }
205 
206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
207         /// @solidity memory-safe-assembly
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 
216 // File: erc721a/contracts/IERC721A.sol
217 
218 
219 // ERC721A Contracts v4.2.3
220 // Creator: Chiru Labs
221 
222 pragma solidity ^0.8.4;
223 
224 /**
225  * @dev Interface of ERC721A.
226  */
227 interface IERC721A {
228     /**
229      * The caller must own the token or be an approved operator.
230      */
231     error ApprovalCallerNotOwnerNorApproved();
232 
233     /**
234      * The token does not exist.
235      */
236     error ApprovalQueryForNonexistentToken();
237 
238     /**
239      * Cannot query the balance for the zero address.
240      */
241     error BalanceQueryForZeroAddress();
242 
243     /**
244      * Cannot mint to the zero address.
245      */
246     error MintToZeroAddress();
247 
248     /**
249      * The quantity of tokens minted must be more than zero.
250      */
251     error MintZeroQuantity();
252 
253     /**
254      * The token does not exist.
255      */
256     error OwnerQueryForNonexistentToken();
257 
258     /**
259      * The caller must own the token or be an approved operator.
260      */
261     error TransferCallerNotOwnerNorApproved();
262 
263     /**
264      * The token must be owned by `from`.
265      */
266     error TransferFromIncorrectOwner();
267 
268     /**
269      * Cannot safely transfer to a contract that does not implement the
270      * ERC721Receiver interface.
271      */
272     error TransferToNonERC721ReceiverImplementer();
273 
274     /**
275      * Cannot transfer to the zero address.
276      */
277     error TransferToZeroAddress();
278 
279     /**
280      * The token does not exist.
281      */
282     error URIQueryForNonexistentToken();
283 
284     /**
285      * The `quantity` minted with ERC2309 exceeds the safety limit.
286      */
287     error MintERC2309QuantityExceedsLimit();
288 
289     /**
290      * The `extraData` cannot be set on an unintialized ownership slot.
291      */
292     error OwnershipNotInitializedForExtraData();
293 
294     // =============================================================
295     //                            STRUCTS
296     // =============================================================
297 
298     struct TokenOwnership {
299         // The address of the owner.
300         address addr;
301         // Stores the start time of ownership with minimal overhead for tokenomics.
302         uint64 startTimestamp;
303         // Whether the token has been burned.
304         bool burned;
305         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
306         uint24 extraData;
307     }
308 
309     // =============================================================
310     //                         TOKEN COUNTERS
311     // =============================================================
312 
313     /**
314      * @dev Returns the total number of tokens in existence.
315      * Burned tokens will reduce the count.
316      * To get the total number of tokens minted, please see {_totalMinted}.
317      */
318     function totalSupply() external view returns (uint256);
319 
320     // =============================================================
321     //                            IERC165
322     // =============================================================
323 
324     /**
325      * @dev Returns true if this contract implements the interface defined by
326      * `interfaceId`. See the corresponding
327      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
328      * to learn more about how these ids are created.
329      *
330      * This function call must use less than 30000 gas.
331      */
332     function supportsInterface(bytes4 interfaceId) external view returns (bool);
333 
334     // =============================================================
335     //                            IERC721
336     // =============================================================
337 
338     /**
339      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
340      */
341     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
342 
343     /**
344      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
345      */
346     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
347 
348     /**
349      * @dev Emitted when `owner` enables or disables
350      * (`approved`) `operator` to manage all of its assets.
351      */
352     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
353 
354     /**
355      * @dev Returns the number of tokens in `owner`'s account.
356      */
357     function balanceOf(address owner) external view returns (uint256 balance);
358 
359     /**
360      * @dev Returns the owner of the `tokenId` token.
361      *
362      * Requirements:
363      *
364      * - `tokenId` must exist.
365      */
366     function ownerOf(uint256 tokenId) external view returns (address owner);
367 
368     /**
369      * @dev Safely transfers `tokenId` token from `from` to `to`,
370      * checking first that contract recipients are aware of the ERC721 protocol
371      * to prevent tokens from being forever locked.
372      *
373      * Requirements:
374      *
375      * - `from` cannot be the zero address.
376      * - `to` cannot be the zero address.
377      * - `tokenId` token must exist and be owned by `from`.
378      * - If the caller is not `from`, it must be have been allowed to move
379      * this token by either {approve} or {setApprovalForAll}.
380      * - If `to` refers to a smart contract, it must implement
381      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
382      *
383      * Emits a {Transfer} event.
384      */
385     function safeTransferFrom(
386         address from,
387         address to,
388         uint256 tokenId,
389         bytes calldata data
390     ) external payable;
391 
392     /**
393      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
394      */
395     function safeTransferFrom(
396         address from,
397         address to,
398         uint256 tokenId
399     ) external payable;
400 
401     /**
402      * @dev Transfers `tokenId` from `from` to `to`.
403      *
404      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
405      * whenever possible.
406      *
407      * Requirements:
408      *
409      * - `from` cannot be the zero address.
410      * - `to` cannot be the zero address.
411      * - `tokenId` token must be owned by `from`.
412      * - If the caller is not `from`, it must be approved to move this token
413      * by either {approve} or {setApprovalForAll}.
414      *
415      * Emits a {Transfer} event.
416      */
417     function transferFrom(
418         address from,
419         address to,
420         uint256 tokenId
421     ) external payable;
422 
423     /**
424      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
425      * The approval is cleared when the token is transferred.
426      *
427      * Only a single account can be approved at a time, so approving the
428      * zero address clears previous approvals.
429      *
430      * Requirements:
431      *
432      * - The caller must own the token or be an approved operator.
433      * - `tokenId` must exist.
434      *
435      * Emits an {Approval} event.
436      */
437     function approve(address to, uint256 tokenId) external payable;
438 
439     /**
440      * @dev Approve or remove `operator` as an operator for the caller.
441      * Operators can call {transferFrom} or {safeTransferFrom}
442      * for any token owned by the caller.
443      *
444      * Requirements:
445      *
446      * - The `operator` cannot be the caller.
447      *
448      * Emits an {ApprovalForAll} event.
449      */
450     function setApprovalForAll(address operator, bool _approved) external;
451 
452     /**
453      * @dev Returns the account approved for `tokenId` token.
454      *
455      * Requirements:
456      *
457      * - `tokenId` must exist.
458      */
459     function getApproved(uint256 tokenId) external view returns (address operator);
460 
461     /**
462      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
463      *
464      * See {setApprovalForAll}.
465      */
466     function isApprovedForAll(address owner, address operator) external view returns (bool);
467 
468     // =============================================================
469     //                        IERC721Metadata
470     // =============================================================
471 
472     /**
473      * @dev Returns the token collection name.
474      */
475     function name() external view returns (string memory);
476 
477     /**
478      * @dev Returns the token collection symbol.
479      */
480     function symbol() external view returns (string memory);
481 
482     /**
483      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
484      */
485     function tokenURI(uint256 tokenId) external view returns (string memory);
486 
487     // =============================================================
488     //                           IERC2309
489     // =============================================================
490 
491     /**
492      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
493      * (inclusive) is transferred from `from` to `to`, as defined in the
494      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
495      *
496      * See {_mintERC2309} for more details.
497      */
498     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
499 }
500 
501 // File: erc721a/contracts/ERC721A.sol
502 
503 
504 // ERC721A Contracts v4.2.3
505 // Creator: Chiru Labs
506 
507 pragma solidity ^0.8.4;
508 
509 
510 /**
511  * @dev Interface of ERC721 token receiver.
512  */
513 interface ERC721A__IERC721Receiver {
514     function onERC721Received(
515         address operator,
516         address from,
517         uint256 tokenId,
518         bytes calldata data
519     ) external returns (bytes4);
520 }
521 
522 /**
523  * @title ERC721A
524  *
525  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
526  * Non-Fungible Token Standard, including the Metadata extension.
527  * Optimized for lower gas during batch mints.
528  *
529  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
530  * starting from `_startTokenId()`.
531  *
532  * Assumptions:
533  *
534  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
535  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
536  */
537 contract ERC721A is IERC721A {
538     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
539     struct TokenApprovalRef {
540         address value;
541     }
542 
543     // =============================================================
544     //                           CONSTANTS
545     // =============================================================
546 
547     // Mask of an entry in packed address data.
548     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
549 
550     // The bit position of `numberMinted` in packed address data.
551     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
552 
553     // The bit position of `numberBurned` in packed address data.
554     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
555 
556     // The bit position of `aux` in packed address data.
557     uint256 private constant _BITPOS_AUX = 192;
558 
559     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
560     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
561 
562     // The bit position of `startTimestamp` in packed ownership.
563     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
564 
565     // The bit mask of the `burned` bit in packed ownership.
566     uint256 private constant _BITMASK_BURNED = 1 << 224;
567 
568     // The bit position of the `nextInitialized` bit in packed ownership.
569     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
570 
571     // The bit mask of the `nextInitialized` bit in packed ownership.
572     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
573 
574     // The bit position of `extraData` in packed ownership.
575     uint256 private constant _BITPOS_EXTRA_DATA = 232;
576 
577     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
578     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
579 
580     // The mask of the lower 160 bits for addresses.
581     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
582 
583     // The maximum `quantity` that can be minted with {_mintERC2309}.
584     // This limit is to prevent overflows on the address data entries.
585     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
586     // is required to cause an overflow, which is unrealistic.
587     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
588 
589     // The `Transfer` event signature is given by:
590     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
591     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
592         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
593 
594     // =============================================================
595     //                            STORAGE
596     // =============================================================
597 
598     // The next token ID to be minted.
599     uint256 private _currentIndex;
600 
601     // The number of tokens burned.
602     uint256 private _burnCounter;
603 
604     // Token name
605     string private _name;
606 
607     // Token symbol
608     string private _symbol;
609 
610     // Mapping from token ID to ownership details
611     // An empty struct value does not necessarily mean the token is unowned.
612     // See {_packedOwnershipOf} implementation for details.
613     //
614     // Bits Layout:
615     // - [0..159]   `addr`
616     // - [160..223] `startTimestamp`
617     // - [224]      `burned`
618     // - [225]      `nextInitialized`
619     // - [232..255] `extraData`
620     mapping(uint256 => uint256) private _packedOwnerships;
621 
622     // Mapping owner address to address data.
623     //
624     // Bits Layout:
625     // - [0..63]    `balance`
626     // - [64..127]  `numberMinted`
627     // - [128..191] `numberBurned`
628     // - [192..255] `aux`
629     mapping(address => uint256) private _packedAddressData;
630 
631     // Mapping from token ID to approved address.
632     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
633 
634     // Mapping from owner to operator approvals
635     mapping(address => mapping(address => bool)) private _operatorApprovals;
636 
637     // =============================================================
638     //                          CONSTRUCTOR
639     // =============================================================
640 
641     constructor(string memory name_, string memory symbol_) {
642         _name = name_;
643         _symbol = symbol_;
644         _currentIndex = _startTokenId();
645     }
646 
647     // =============================================================
648     //                   TOKEN COUNTING OPERATIONS
649     // =============================================================
650 
651     /**
652      * @dev Returns the starting token ID.
653      * To change the starting token ID, please override this function.
654      */
655     function _startTokenId() internal view virtual returns (uint256) {
656         return 0;
657     }
658 
659     /**
660      * @dev Returns the next token ID to be minted.
661      */
662     function _nextTokenId() internal view virtual returns (uint256) {
663         return _currentIndex;
664     }
665 
666     /**
667      * @dev Returns the total number of tokens in existence.
668      * Burned tokens will reduce the count.
669      * To get the total number of tokens minted, please see {_totalMinted}.
670      */
671     function totalSupply() public view virtual override returns (uint256) {
672         // Counter underflow is impossible as _burnCounter cannot be incremented
673         // more than `_currentIndex - _startTokenId()` times.
674         unchecked {
675             return _currentIndex - _burnCounter - _startTokenId();
676         }
677     }
678 
679     /**
680      * @dev Returns the total amount of tokens minted in the contract.
681      */
682     function _totalMinted() internal view virtual returns (uint256) {
683         // Counter underflow is impossible as `_currentIndex` does not decrement,
684         // and it is initialized to `_startTokenId()`.
685         unchecked {
686             return _currentIndex - _startTokenId();
687         }
688     }
689 
690     /**
691      * @dev Returns the total number of tokens burned.
692      */
693     function _totalBurned() internal view virtual returns (uint256) {
694         return _burnCounter;
695     }
696 
697     // =============================================================
698     //                    ADDRESS DATA OPERATIONS
699     // =============================================================
700 
701     /**
702      * @dev Returns the number of tokens in `owner`'s account.
703      */
704     function balanceOf(address owner) public view virtual override returns (uint256) {
705         if (owner == address(0)) revert BalanceQueryForZeroAddress();
706         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
707     }
708 
709     /**
710      * Returns the number of tokens minted by `owner`.
711      */
712     function _numberMinted(address owner) internal view returns (uint256) {
713         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
714     }
715 
716     /**
717      * Returns the number of tokens burned by or on behalf of `owner`.
718      */
719     function _numberBurned(address owner) internal view returns (uint256) {
720         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
721     }
722 
723     /**
724      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
725      */
726     function _getAux(address owner) internal view returns (uint64) {
727         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
728     }
729 
730     /**
731      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
732      * If there are multiple variables, please pack them into a uint64.
733      */
734     function _setAux(address owner, uint64 aux) internal virtual {
735         uint256 packed = _packedAddressData[owner];
736         uint256 auxCasted;
737         // Cast `aux` with assembly to avoid redundant masking.
738         assembly {
739             auxCasted := aux
740         }
741         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
742         _packedAddressData[owner] = packed;
743     }
744 
745     // =============================================================
746     //                            IERC165
747     // =============================================================
748 
749     /**
750      * @dev Returns true if this contract implements the interface defined by
751      * `interfaceId`. See the corresponding
752      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
753      * to learn more about how these ids are created.
754      *
755      * This function call must use less than 30000 gas.
756      */
757     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
758         // The interface IDs are constants representing the first 4 bytes
759         // of the XOR of all function selectors in the interface.
760         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
761         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
762         return
763             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
764             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
765             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
766     }
767 
768     // =============================================================
769     //                        IERC721Metadata
770     // =============================================================
771 
772     /**
773      * @dev Returns the token collection name.
774      */
775     function name() public view virtual override returns (string memory) {
776         return _name;
777     }
778 
779     /**
780      * @dev Returns the token collection symbol.
781      */
782     function symbol() public view virtual override returns (string memory) {
783         return _symbol;
784     }
785 
786     /**
787      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
788      */
789     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
790         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
791 
792         string memory baseURI = _baseURI();
793         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
794     }
795 
796     /**
797      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
798      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
799      * by default, it can be overridden in child contracts.
800      */
801     function _baseURI() internal view virtual returns (string memory) {
802         return '';
803     }
804 
805     // =============================================================
806     //                     OWNERSHIPS OPERATIONS
807     // =============================================================
808 
809     /**
810      * @dev Returns the owner of the `tokenId` token.
811      *
812      * Requirements:
813      *
814      * - `tokenId` must exist.
815      */
816     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
817         return address(uint160(_packedOwnershipOf(tokenId)));
818     }
819 
820     /**
821      * @dev Gas spent here starts off proportional to the maximum mint batch size.
822      * It gradually moves to O(1) as tokens get transferred around over time.
823      */
824     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
825         return _unpackedOwnership(_packedOwnershipOf(tokenId));
826     }
827 
828     /**
829      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
830      */
831     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
832         return _unpackedOwnership(_packedOwnerships[index]);
833     }
834 
835     /**
836      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
837      */
838     function _initializeOwnershipAt(uint256 index) internal virtual {
839         if (_packedOwnerships[index] == 0) {
840             _packedOwnerships[index] = _packedOwnershipOf(index);
841         }
842     }
843 
844     /**
845      * Returns the packed ownership data of `tokenId`.
846      */
847     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
848         uint256 curr = tokenId;
849 
850         unchecked {
851             if (_startTokenId() <= curr)
852                 if (curr < _currentIndex) {
853                     uint256 packed = _packedOwnerships[curr];
854                     // If not burned.
855                     if (packed & _BITMASK_BURNED == 0) {
856                         // Invariant:
857                         // There will always be an initialized ownership slot
858                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
859                         // before an unintialized ownership slot
860                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
861                         // Hence, `curr` will not underflow.
862                         //
863                         // We can directly compare the packed value.
864                         // If the address is zero, packed will be zero.
865                         while (packed == 0) {
866                             packed = _packedOwnerships[--curr];
867                         }
868                         return packed;
869                     }
870                 }
871         }
872         revert OwnerQueryForNonexistentToken();
873     }
874 
875     /**
876      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
877      */
878     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
879         ownership.addr = address(uint160(packed));
880         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
881         ownership.burned = packed & _BITMASK_BURNED != 0;
882         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
883     }
884 
885     /**
886      * @dev Packs ownership data into a single uint256.
887      */
888     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
889         assembly {
890             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
891             owner := and(owner, _BITMASK_ADDRESS)
892             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
893             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
894         }
895     }
896 
897     /**
898      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
899      */
900     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
901         // For branchless setting of the `nextInitialized` flag.
902         assembly {
903             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
904             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
905         }
906     }
907 
908     // =============================================================
909     //                      APPROVAL OPERATIONS
910     // =============================================================
911 
912     /**
913      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
914      * The approval is cleared when the token is transferred.
915      *
916      * Only a single account can be approved at a time, so approving the
917      * zero address clears previous approvals.
918      *
919      * Requirements:
920      *
921      * - The caller must own the token or be an approved operator.
922      * - `tokenId` must exist.
923      *
924      * Emits an {Approval} event.
925      */
926     function approve(address to, uint256 tokenId) public payable virtual override {
927         address owner = ownerOf(tokenId);
928 
929         if (_msgSenderERC721A() != owner)
930             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
931                 revert ApprovalCallerNotOwnerNorApproved();
932             }
933 
934         _tokenApprovals[tokenId].value = to;
935         emit Approval(owner, to, tokenId);
936     }
937 
938     /**
939      * @dev Returns the account approved for `tokenId` token.
940      *
941      * Requirements:
942      *
943      * - `tokenId` must exist.
944      */
945     function getApproved(uint256 tokenId) public view virtual override returns (address) {
946         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
947 
948         return _tokenApprovals[tokenId].value;
949     }
950 
951     /**
952      * @dev Approve or remove `operator` as an operator for the caller.
953      * Operators can call {transferFrom} or {safeTransferFrom}
954      * for any token owned by the caller.
955      *
956      * Requirements:
957      *
958      * - The `operator` cannot be the caller.
959      *
960      * Emits an {ApprovalForAll} event.
961      */
962     function setApprovalForAll(address operator, bool approved) public virtual override {
963         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
964         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
965     }
966 
967     /**
968      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
969      *
970      * See {setApprovalForAll}.
971      */
972     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
973         return _operatorApprovals[owner][operator];
974     }
975 
976     /**
977      * @dev Returns whether `tokenId` exists.
978      *
979      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
980      *
981      * Tokens start existing when they are minted. See {_mint}.
982      */
983     function _exists(uint256 tokenId) internal view virtual returns (bool) {
984         return
985             _startTokenId() <= tokenId &&
986             tokenId < _currentIndex && // If within bounds,
987             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
988     }
989 
990     /**
991      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
992      */
993     function _isSenderApprovedOrOwner(
994         address approvedAddress,
995         address owner,
996         address msgSender
997     ) private pure returns (bool result) {
998         assembly {
999             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1000             owner := and(owner, _BITMASK_ADDRESS)
1001             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1002             msgSender := and(msgSender, _BITMASK_ADDRESS)
1003             // `msgSender == owner || msgSender == approvedAddress`.
1004             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1005         }
1006     }
1007 
1008     /**
1009      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1010      */
1011     function _getApprovedSlotAndAddress(uint256 tokenId)
1012         private
1013         view
1014         returns (uint256 approvedAddressSlot, address approvedAddress)
1015     {
1016         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1017         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1018         assembly {
1019             approvedAddressSlot := tokenApproval.slot
1020             approvedAddress := sload(approvedAddressSlot)
1021         }
1022     }
1023 
1024     // =============================================================
1025     //                      TRANSFER OPERATIONS
1026     // =============================================================
1027 
1028     /**
1029      * @dev Transfers `tokenId` from `from` to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - `from` cannot be the zero address.
1034      * - `to` cannot be the zero address.
1035      * - `tokenId` token must be owned by `from`.
1036      * - If the caller is not `from`, it must be approved to move this token
1037      * by either {approve} or {setApprovalForAll}.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function transferFrom(
1042         address from,
1043         address to,
1044         uint256 tokenId
1045     ) public payable virtual override {
1046         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1047 
1048         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1049 
1050         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1051 
1052         // The nested ifs save around 20+ gas over a compound boolean condition.
1053         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1054             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1055 
1056         if (to == address(0)) revert TransferToZeroAddress();
1057 
1058         _beforeTokenTransfers(from, to, tokenId, 1);
1059 
1060         // Clear approvals from the previous owner.
1061         assembly {
1062             if approvedAddress {
1063                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1064                 sstore(approvedAddressSlot, 0)
1065             }
1066         }
1067 
1068         // Underflow of the sender's balance is impossible because we check for
1069         // ownership above and the recipient's balance can't realistically overflow.
1070         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1071         unchecked {
1072             // We can directly increment and decrement the balances.
1073             --_packedAddressData[from]; // Updates: `balance -= 1`.
1074             ++_packedAddressData[to]; // Updates: `balance += 1`.
1075 
1076             // Updates:
1077             // - `address` to the next owner.
1078             // - `startTimestamp` to the timestamp of transfering.
1079             // - `burned` to `false`.
1080             // - `nextInitialized` to `true`.
1081             _packedOwnerships[tokenId] = _packOwnershipData(
1082                 to,
1083                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1084             );
1085 
1086             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1087             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1088                 uint256 nextTokenId = tokenId + 1;
1089                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1090                 if (_packedOwnerships[nextTokenId] == 0) {
1091                     // If the next slot is within bounds.
1092                     if (nextTokenId != _currentIndex) {
1093                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1094                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1095                     }
1096                 }
1097             }
1098         }
1099 
1100         emit Transfer(from, to, tokenId);
1101         _afterTokenTransfers(from, to, tokenId, 1);
1102     }
1103 
1104     /**
1105      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1106      */
1107     function safeTransferFrom(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) public payable virtual override {
1112         safeTransferFrom(from, to, tokenId, '');
1113     }
1114 
1115     /**
1116      * @dev Safely transfers `tokenId` token from `from` to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - `from` cannot be the zero address.
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must exist and be owned by `from`.
1123      * - If the caller is not `from`, it must be approved to move this token
1124      * by either {approve} or {setApprovalForAll}.
1125      * - If `to` refers to a smart contract, it must implement
1126      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function safeTransferFrom(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes memory _data
1135     ) public payable virtual override {
1136         transferFrom(from, to, tokenId);
1137         if (to.code.length != 0)
1138             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1139                 revert TransferToNonERC721ReceiverImplementer();
1140             }
1141     }
1142 
1143     /**
1144      * @dev Hook that is called before a set of serially-ordered token IDs
1145      * are about to be transferred. This includes minting.
1146      * And also called before burning one token.
1147      *
1148      * `startTokenId` - the first token ID to be transferred.
1149      * `quantity` - the amount to be transferred.
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` will be minted for `to`.
1156      * - When `to` is zero, `tokenId` will be burned by `from`.
1157      * - `from` and `to` are never both zero.
1158      */
1159     function _beforeTokenTransfers(
1160         address from,
1161         address to,
1162         uint256 startTokenId,
1163         uint256 quantity
1164     ) internal virtual {}
1165 
1166     /**
1167      * @dev Hook that is called after a set of serially-ordered token IDs
1168      * have been transferred. This includes minting.
1169      * And also called after one token has been burned.
1170      *
1171      * `startTokenId` - the first token ID to be transferred.
1172      * `quantity` - the amount to be transferred.
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` has been minted for `to`.
1179      * - When `to` is zero, `tokenId` has been burned by `from`.
1180      * - `from` and `to` are never both zero.
1181      */
1182     function _afterTokenTransfers(
1183         address from,
1184         address to,
1185         uint256 startTokenId,
1186         uint256 quantity
1187     ) internal virtual {}
1188 
1189     /**
1190      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1191      *
1192      * `from` - Previous owner of the given token ID.
1193      * `to` - Target address that will receive the token.
1194      * `tokenId` - Token ID to be transferred.
1195      * `_data` - Optional data to send along with the call.
1196      *
1197      * Returns whether the call correctly returned the expected magic value.
1198      */
1199     function _checkContractOnERC721Received(
1200         address from,
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) private returns (bool) {
1205         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1206             bytes4 retval
1207         ) {
1208             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1209         } catch (bytes memory reason) {
1210             if (reason.length == 0) {
1211                 revert TransferToNonERC721ReceiverImplementer();
1212             } else {
1213                 assembly {
1214                     revert(add(32, reason), mload(reason))
1215                 }
1216             }
1217         }
1218     }
1219 
1220     // =============================================================
1221     //                        MINT OPERATIONS
1222     // =============================================================
1223 
1224     /**
1225      * @dev Mints `quantity` tokens and transfers them to `to`.
1226      *
1227      * Requirements:
1228      *
1229      * - `to` cannot be the zero address.
1230      * - `quantity` must be greater than 0.
1231      *
1232      * Emits a {Transfer} event for each mint.
1233      */
1234     function _mint(address to, uint256 quantity) internal virtual {
1235         uint256 startTokenId = _currentIndex;
1236         if (quantity == 0) revert MintZeroQuantity();
1237 
1238         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1239 
1240         // Overflows are incredibly unrealistic.
1241         // `balance` and `numberMinted` have a maximum limit of 2**64.
1242         // `tokenId` has a maximum limit of 2**256.
1243         unchecked {
1244             // Updates:
1245             // - `balance += quantity`.
1246             // - `numberMinted += quantity`.
1247             //
1248             // We can directly add to the `balance` and `numberMinted`.
1249             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1250 
1251             // Updates:
1252             // - `address` to the owner.
1253             // - `startTimestamp` to the timestamp of minting.
1254             // - `burned` to `false`.
1255             // - `nextInitialized` to `quantity == 1`.
1256             _packedOwnerships[startTokenId] = _packOwnershipData(
1257                 to,
1258                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1259             );
1260 
1261             uint256 toMasked;
1262             uint256 end = startTokenId + quantity;
1263 
1264             // Use assembly to loop and emit the `Transfer` event for gas savings.
1265             // The duplicated `log4` removes an extra check and reduces stack juggling.
1266             // The assembly, together with the surrounding Solidity code, have been
1267             // delicately arranged to nudge the compiler into producing optimized opcodes.
1268             assembly {
1269                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1270                 toMasked := and(to, _BITMASK_ADDRESS)
1271                 // Emit the `Transfer` event.
1272                 log4(
1273                     0, // Start of data (0, since no data).
1274                     0, // End of data (0, since no data).
1275                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1276                     0, // `address(0)`.
1277                     toMasked, // `to`.
1278                     startTokenId // `tokenId`.
1279                 )
1280 
1281                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1282                 // that overflows uint256 will make the loop run out of gas.
1283                 // The compiler will optimize the `iszero` away for performance.
1284                 for {
1285                     let tokenId := add(startTokenId, 1)
1286                 } iszero(eq(tokenId, end)) {
1287                     tokenId := add(tokenId, 1)
1288                 } {
1289                     // Emit the `Transfer` event. Similar to above.
1290                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1291                 }
1292             }
1293             if (toMasked == 0) revert MintToZeroAddress();
1294 
1295             _currentIndex = end;
1296         }
1297         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1298     }
1299 
1300     /**
1301      * @dev Mints `quantity` tokens and transfers them to `to`.
1302      *
1303      * This function is intended for efficient minting only during contract creation.
1304      *
1305      * It emits only one {ConsecutiveTransfer} as defined in
1306      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1307      * instead of a sequence of {Transfer} event(s).
1308      *
1309      * Calling this function outside of contract creation WILL make your contract
1310      * non-compliant with the ERC721 standard.
1311      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1312      * {ConsecutiveTransfer} event is only permissible during contract creation.
1313      *
1314      * Requirements:
1315      *
1316      * - `to` cannot be the zero address.
1317      * - `quantity` must be greater than 0.
1318      *
1319      * Emits a {ConsecutiveTransfer} event.
1320      */
1321     function _mintERC2309(address to, uint256 quantity) internal virtual {
1322         uint256 startTokenId = _currentIndex;
1323         if (to == address(0)) revert MintToZeroAddress();
1324         if (quantity == 0) revert MintZeroQuantity();
1325         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1326 
1327         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1328 
1329         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1330         unchecked {
1331             // Updates:
1332             // - `balance += quantity`.
1333             // - `numberMinted += quantity`.
1334             //
1335             // We can directly add to the `balance` and `numberMinted`.
1336             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1337 
1338             // Updates:
1339             // - `address` to the owner.
1340             // - `startTimestamp` to the timestamp of minting.
1341             // - `burned` to `false`.
1342             // - `nextInitialized` to `quantity == 1`.
1343             _packedOwnerships[startTokenId] = _packOwnershipData(
1344                 to,
1345                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1346             );
1347 
1348             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1349 
1350             _currentIndex = startTokenId + quantity;
1351         }
1352         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1353     }
1354 
1355     /**
1356      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1357      *
1358      * Requirements:
1359      *
1360      * - If `to` refers to a smart contract, it must implement
1361      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1362      * - `quantity` must be greater than 0.
1363      *
1364      * See {_mint}.
1365      *
1366      * Emits a {Transfer} event for each mint.
1367      */
1368     function _safeMint(
1369         address to,
1370         uint256 quantity,
1371         bytes memory _data
1372     ) internal virtual {
1373         _mint(to, quantity);
1374 
1375         unchecked {
1376             if (to.code.length != 0) {
1377                 uint256 end = _currentIndex;
1378                 uint256 index = end - quantity;
1379                 do {
1380                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1381                         revert TransferToNonERC721ReceiverImplementer();
1382                     }
1383                 } while (index < end);
1384                 // Reentrancy protection.
1385                 if (_currentIndex != end) revert();
1386             }
1387         }
1388     }
1389 
1390     /**
1391      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1392      */
1393     function _safeMint(address to, uint256 quantity) internal virtual {
1394         _safeMint(to, quantity, '');
1395     }
1396 
1397     // =============================================================
1398     //                        BURN OPERATIONS
1399     // =============================================================
1400 
1401     /**
1402      * @dev Equivalent to `_burn(tokenId, false)`.
1403      */
1404     function _burn(uint256 tokenId) internal virtual {
1405         _burn(tokenId, false);
1406     }
1407 
1408     /**
1409      * @dev Destroys `tokenId`.
1410      * The approval is cleared when the token is burned.
1411      *
1412      * Requirements:
1413      *
1414      * - `tokenId` must exist.
1415      *
1416      * Emits a {Transfer} event.
1417      */
1418     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1419         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1420 
1421         address from = address(uint160(prevOwnershipPacked));
1422 
1423         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1424 
1425         if (approvalCheck) {
1426             // The nested ifs save around 20+ gas over a compound boolean condition.
1427             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1428                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1429         }
1430 
1431         _beforeTokenTransfers(from, address(0), tokenId, 1);
1432 
1433         // Clear approvals from the previous owner.
1434         assembly {
1435             if approvedAddress {
1436                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1437                 sstore(approvedAddressSlot, 0)
1438             }
1439         }
1440 
1441         // Underflow of the sender's balance is impossible because we check for
1442         // ownership above and the recipient's balance can't realistically overflow.
1443         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1444         unchecked {
1445             // Updates:
1446             // - `balance -= 1`.
1447             // - `numberBurned += 1`.
1448             //
1449             // We can directly decrement the balance, and increment the number burned.
1450             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1451             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1452 
1453             // Updates:
1454             // - `address` to the last owner.
1455             // - `startTimestamp` to the timestamp of burning.
1456             // - `burned` to `true`.
1457             // - `nextInitialized` to `true`.
1458             _packedOwnerships[tokenId] = _packOwnershipData(
1459                 from,
1460                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1461             );
1462 
1463             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1464             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1465                 uint256 nextTokenId = tokenId + 1;
1466                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1467                 if (_packedOwnerships[nextTokenId] == 0) {
1468                     // If the next slot is within bounds.
1469                     if (nextTokenId != _currentIndex) {
1470                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1471                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1472                     }
1473                 }
1474             }
1475         }
1476 
1477         emit Transfer(from, address(0), tokenId);
1478         _afterTokenTransfers(from, address(0), tokenId, 1);
1479 
1480         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1481         unchecked {
1482             _burnCounter++;
1483         }
1484     }
1485 
1486     // =============================================================
1487     //                     EXTRA DATA OPERATIONS
1488     // =============================================================
1489 
1490     /**
1491      * @dev Directly sets the extra data for the ownership data `index`.
1492      */
1493     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1494         uint256 packed = _packedOwnerships[index];
1495         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1496         uint256 extraDataCasted;
1497         // Cast `extraData` with assembly to avoid redundant masking.
1498         assembly {
1499             extraDataCasted := extraData
1500         }
1501         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1502         _packedOwnerships[index] = packed;
1503     }
1504 
1505     /**
1506      * @dev Called during each token transfer to set the 24bit `extraData` field.
1507      * Intended to be overridden by the cosumer contract.
1508      *
1509      * `previousExtraData` - the value of `extraData` before transfer.
1510      *
1511      * Calling conditions:
1512      *
1513      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1514      * transferred to `to`.
1515      * - When `from` is zero, `tokenId` will be minted for `to`.
1516      * - When `to` is zero, `tokenId` will be burned by `from`.
1517      * - `from` and `to` are never both zero.
1518      */
1519     function _extraData(
1520         address from,
1521         address to,
1522         uint24 previousExtraData
1523     ) internal view virtual returns (uint24) {}
1524 
1525     /**
1526      * @dev Returns the next extra data for the packed ownership data.
1527      * The returned result is shifted into position.
1528      */
1529     function _nextExtraData(
1530         address from,
1531         address to,
1532         uint256 prevOwnershipPacked
1533     ) private view returns (uint256) {
1534         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1535         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1536     }
1537 
1538     // =============================================================
1539     //                       OTHER OPERATIONS
1540     // =============================================================
1541 
1542     /**
1543      * @dev Returns the message sender (defaults to `msg.sender`).
1544      *
1545      * If you are writing GSN compatible contracts, you need to override this function.
1546      */
1547     function _msgSenderERC721A() internal view virtual returns (address) {
1548         return msg.sender;
1549     }
1550 
1551     /**
1552      * @dev Converts a uint256 to its ASCII string decimal representation.
1553      */
1554     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1555         assembly {
1556             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1557             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1558             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1559             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1560             let m := add(mload(0x40), 0xa0)
1561             // Update the free memory pointer to allocate.
1562             mstore(0x40, m)
1563             // Assign the `str` to the end.
1564             str := sub(m, 0x20)
1565             // Zeroize the slot after the string.
1566             mstore(str, 0)
1567 
1568             // Cache the end of the memory to calculate the length later.
1569             let end := str
1570 
1571             // We write the string from rightmost digit to leftmost digit.
1572             // The following is essentially a do-while loop that also handles the zero case.
1573             // prettier-ignore
1574             for { let temp := value } 1 {} {
1575                 str := sub(str, 1)
1576                 // Write the character to the pointer.
1577                 // The ASCII index of the '0' character is 48.
1578                 mstore8(str, add(48, mod(temp, 10)))
1579                 // Keep dividing `temp` until zero.
1580                 temp := div(temp, 10)
1581                 // prettier-ignore
1582                 if iszero(temp) { break }
1583             }
1584 
1585             let length := sub(end, str)
1586             // Move the pointer 32 bytes leftwards to make room for the length.
1587             str := sub(str, 0x20)
1588             // Store the length.
1589             mstore(str, length)
1590         }
1591     }
1592 }
1593 
1594 // File: @openzeppelin/contracts/utils/Counters.sol
1595 
1596 
1597 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1598 
1599 pragma solidity ^0.8.0;
1600 
1601 /**
1602  * @title Counters
1603  * @author Matt Condon (@shrugs)
1604  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1605  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1606  *
1607  * Include with `using Counters for Counters.Counter;`
1608  */
1609 library Counters {
1610     struct Counter {
1611         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1612         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1613         // this feature: see https://github.com/ethereum/solidity/issues/4637
1614         uint256 _value; // default: 0
1615     }
1616 
1617     function current(Counter storage counter) internal view returns (uint256) {
1618         return counter._value;
1619     }
1620 
1621     function increment(Counter storage counter) internal {
1622         unchecked {
1623             counter._value += 1;
1624         }
1625     }
1626 
1627     function decrement(Counter storage counter) internal {
1628         uint256 value = counter._value;
1629         require(value > 0, "Counter: decrement overflow");
1630         unchecked {
1631             counter._value = value - 1;
1632         }
1633     }
1634 
1635     function reset(Counter storage counter) internal {
1636         counter._value = 0;
1637     }
1638 }
1639 
1640 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1641 
1642 
1643 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (security/ReentrancyGuard.sol)
1644 
1645 pragma solidity ^0.8.0;
1646 
1647 /**
1648  * @dev Contract module that helps prevent reentrant calls to a function.
1649  *
1650  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1651  * available, which can be applied to functions to make sure there are no nested
1652  * (reentrant) calls to them.
1653  *
1654  * Note that because there is a single `nonReentrant` guard, functions marked as
1655  * `nonReentrant` may not call one another. This can be worked around by making
1656  * those functions `private`, and then adding `external` `nonReentrant` entry
1657  * points to them.
1658  *
1659  * TIP: If you would like to learn more about reentrancy and alternative ways
1660  * to protect against it, check out our blog post
1661  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1662  */
1663 abstract contract ReentrancyGuard {
1664     // Booleans are more expensive than uint256 or any type that takes up a full
1665     // word because each write operation emits an extra SLOAD to first read the
1666     // slot's contents, replace the bits taken up by the boolean, and then write
1667     // back. This is the compiler's defense against contract upgrades and
1668     // pointer aliasing, and it cannot be disabled.
1669 
1670     // The values being non-zero value makes deployment a bit more expensive,
1671     // but in exchange the refund on every call to nonReentrant will be lower in
1672     // amount. Since refunds are capped to a percentage of the total
1673     // transaction's gas, it is best to keep them low in cases like this one, to
1674     // increase the likelihood of the full refund coming into effect.
1675     uint256 private constant _NOT_ENTERED = 1;
1676     uint256 private constant _ENTERED = 2;
1677 
1678     uint256 private _status;
1679 
1680     constructor() {
1681         _status = _NOT_ENTERED;
1682     }
1683 
1684     /**
1685      * @dev Prevents a contract from calling itself, directly or indirectly.
1686      * Calling a `nonReentrant` function from another `nonReentrant`
1687      * function is not supported. It is possible to prevent this from happening
1688      * by making the `nonReentrant` function external, and making it call a
1689      * `private` function that does the actual work.
1690      */
1691     modifier nonReentrant() {
1692         _nonReentrantBefore();
1693         _;
1694         _nonReentrantAfter();
1695     }
1696 
1697     function _nonReentrantBefore() private {
1698         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1699         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1700 
1701         // Any calls to nonReentrant after this point will fail
1702         _status = _ENTERED;
1703     }
1704 
1705     function _nonReentrantAfter() private {
1706         // By storing the original value once again, a refund is triggered (see
1707         // https://eips.ethereum.org/EIPS/eip-2200)
1708         _status = _NOT_ENTERED;
1709     }
1710 }
1711 
1712 // File: @openzeppelin/contracts/utils/math/Math.sol
1713 
1714 
1715 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (utils/math/Math.sol)
1716 
1717 pragma solidity ^0.8.0;
1718 
1719 /**
1720  * @dev Standard math utilities missing in the Solidity language.
1721  */
1722 library Math {
1723     enum Rounding {
1724         Down, // Toward negative infinity
1725         Up, // Toward infinity
1726         Zero // Toward zero
1727     }
1728 
1729     /**
1730      * @dev Returns the largest of two numbers.
1731      */
1732     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1733         return a > b ? a : b;
1734     }
1735 
1736     /**
1737      * @dev Returns the smallest of two numbers.
1738      */
1739     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1740         return a < b ? a : b;
1741     }
1742 
1743     /**
1744      * @dev Returns the average of two numbers. The result is rounded towards
1745      * zero.
1746      */
1747     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1748         // (a + b) / 2 can overflow.
1749         return (a & b) + (a ^ b) / 2;
1750     }
1751 
1752     /**
1753      * @dev Returns the ceiling of the division of two numbers.
1754      *
1755      * This differs from standard division with `/` in that it rounds up instead
1756      * of rounding down.
1757      */
1758     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1759         // (a + b - 1) / b can overflow on addition, so we distribute.
1760         return a == 0 ? 0 : (a - 1) / b + 1;
1761     }
1762 
1763     /**
1764      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1765      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1766      * with further edits by Uniswap Labs also under MIT license.
1767      */
1768     function mulDiv(
1769         uint256 x,
1770         uint256 y,
1771         uint256 denominator
1772     ) internal pure returns (uint256 result) {
1773         unchecked {
1774             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1775             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1776             // variables such that product = prod1 * 2^256 + prod0.
1777             uint256 prod0; // Least significant 256 bits of the product
1778             uint256 prod1; // Most significant 256 bits of the product
1779             assembly {
1780                 let mm := mulmod(x, y, not(0))
1781                 prod0 := mul(x, y)
1782                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1783             }
1784 
1785             // Handle non-overflow cases, 256 by 256 division.
1786             if (prod1 == 0) {
1787                 return prod0 / denominator;
1788             }
1789 
1790             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1791             require(denominator > prod1);
1792 
1793             ///////////////////////////////////////////////
1794             // 512 by 256 division.
1795             ///////////////////////////////////////////////
1796 
1797             // Make division exact by subtracting the remainder from [prod1 prod0].
1798             uint256 remainder;
1799             assembly {
1800                 // Compute remainder using mulmod.
1801                 remainder := mulmod(x, y, denominator)
1802 
1803                 // Subtract 256 bit number from 512 bit number.
1804                 prod1 := sub(prod1, gt(remainder, prod0))
1805                 prod0 := sub(prod0, remainder)
1806             }
1807 
1808             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1809             // See https://cs.stackexchange.com/q/138556/92363.
1810 
1811             // Does not overflow because the denominator cannot be zero at this stage in the function.
1812             uint256 twos = denominator & (~denominator + 1);
1813             assembly {
1814                 // Divide denominator by twos.
1815                 denominator := div(denominator, twos)
1816 
1817                 // Divide [prod1 prod0] by twos.
1818                 prod0 := div(prod0, twos)
1819 
1820                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1821                 twos := add(div(sub(0, twos), twos), 1)
1822             }
1823 
1824             // Shift in bits from prod1 into prod0.
1825             prod0 |= prod1 * twos;
1826 
1827             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1828             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1829             // four bits. That is, denominator * inv = 1 mod 2^4.
1830             uint256 inverse = (3 * denominator) ^ 2;
1831 
1832             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1833             // in modular arithmetic, doubling the correct bits in each step.
1834             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1835             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1836             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1837             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1838             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1839             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1840 
1841             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1842             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1843             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1844             // is no longer required.
1845             result = prod0 * inverse;
1846             return result;
1847         }
1848     }
1849 
1850     /**
1851      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1852      */
1853     function mulDiv(
1854         uint256 x,
1855         uint256 y,
1856         uint256 denominator,
1857         Rounding rounding
1858     ) internal pure returns (uint256) {
1859         uint256 result = mulDiv(x, y, denominator);
1860         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1861             result += 1;
1862         }
1863         return result;
1864     }
1865 
1866     /**
1867      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1868      *
1869      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1870      */
1871     function sqrt(uint256 a) internal pure returns (uint256) {
1872         if (a == 0) {
1873             return 0;
1874         }
1875 
1876         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1877         //
1878         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1879         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1880         //
1881         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1882         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1883         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1884         //
1885         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1886         uint256 result = 1 << (log2(a) >> 1);
1887 
1888         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1889         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1890         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1891         // into the expected uint128 result.
1892         unchecked {
1893             result = (result + a / result) >> 1;
1894             result = (result + a / result) >> 1;
1895             result = (result + a / result) >> 1;
1896             result = (result + a / result) >> 1;
1897             result = (result + a / result) >> 1;
1898             result = (result + a / result) >> 1;
1899             result = (result + a / result) >> 1;
1900             return min(result, a / result);
1901         }
1902     }
1903 
1904     /**
1905      * @notice Calculates sqrt(a), following the selected rounding direction.
1906      */
1907     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1908         unchecked {
1909             uint256 result = sqrt(a);
1910             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1911         }
1912     }
1913 
1914     /**
1915      * @dev Return the log in base 2, rounded down, of a positive value.
1916      * Returns 0 if given 0.
1917      */
1918     function log2(uint256 value) internal pure returns (uint256) {
1919         uint256 result = 0;
1920         unchecked {
1921             if (value >> 128 > 0) {
1922                 value >>= 128;
1923                 result += 128;
1924             }
1925             if (value >> 64 > 0) {
1926                 value >>= 64;
1927                 result += 64;
1928             }
1929             if (value >> 32 > 0) {
1930                 value >>= 32;
1931                 result += 32;
1932             }
1933             if (value >> 16 > 0) {
1934                 value >>= 16;
1935                 result += 16;
1936             }
1937             if (value >> 8 > 0) {
1938                 value >>= 8;
1939                 result += 8;
1940             }
1941             if (value >> 4 > 0) {
1942                 value >>= 4;
1943                 result += 4;
1944             }
1945             if (value >> 2 > 0) {
1946                 value >>= 2;
1947                 result += 2;
1948             }
1949             if (value >> 1 > 0) {
1950                 result += 1;
1951             }
1952         }
1953         return result;
1954     }
1955 
1956     /**
1957      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1958      * Returns 0 if given 0.
1959      */
1960     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1961         unchecked {
1962             uint256 result = log2(value);
1963             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1964         }
1965     }
1966 
1967     /**
1968      * @dev Return the log in base 10, rounded down, of a positive value.
1969      * Returns 0 if given 0.
1970      */
1971     function log10(uint256 value) internal pure returns (uint256) {
1972         uint256 result = 0;
1973         unchecked {
1974             if (value >= 10**64) {
1975                 value /= 10**64;
1976                 result += 64;
1977             }
1978             if (value >= 10**32) {
1979                 value /= 10**32;
1980                 result += 32;
1981             }
1982             if (value >= 10**16) {
1983                 value /= 10**16;
1984                 result += 16;
1985             }
1986             if (value >= 10**8) {
1987                 value /= 10**8;
1988                 result += 8;
1989             }
1990             if (value >= 10**4) {
1991                 value /= 10**4;
1992                 result += 4;
1993             }
1994             if (value >= 10**2) {
1995                 value /= 10**2;
1996                 result += 2;
1997             }
1998             if (value >= 10**1) {
1999                 result += 1;
2000             }
2001         }
2002         return result;
2003     }
2004 
2005     /**
2006      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2007      * Returns 0 if given 0.
2008      */
2009     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2010         unchecked {
2011             uint256 result = log10(value);
2012             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2013         }
2014     }
2015 
2016     /**
2017      * @dev Return the log in base 256, rounded down, of a positive value.
2018      * Returns 0 if given 0.
2019      *
2020      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2021      */
2022     function log256(uint256 value) internal pure returns (uint256) {
2023         uint256 result = 0;
2024         unchecked {
2025             if (value >> 128 > 0) {
2026                 value >>= 128;
2027                 result += 16;
2028             }
2029             if (value >> 64 > 0) {
2030                 value >>= 64;
2031                 result += 8;
2032             }
2033             if (value >> 32 > 0) {
2034                 value >>= 32;
2035                 result += 4;
2036             }
2037             if (value >> 16 > 0) {
2038                 value >>= 16;
2039                 result += 2;
2040             }
2041             if (value >> 8 > 0) {
2042                 result += 1;
2043             }
2044         }
2045         return result;
2046     }
2047 
2048     /**
2049      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2050      * Returns 0 if given 0.
2051      */
2052     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2053         unchecked {
2054             uint256 result = log256(value);
2055             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2056         }
2057     }
2058 }
2059 
2060 // File: @openzeppelin/contracts/utils/Strings.sol
2061 
2062 
2063 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (utils/Strings.sol)
2064 
2065 pragma solidity ^0.8.0;
2066 
2067 
2068 /**
2069  * @dev String operations.
2070  */
2071 library Strings {
2072     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2073     uint8 private constant _ADDRESS_LENGTH = 20;
2074 
2075     /**
2076      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2077      */
2078     function toString(uint256 value) internal pure returns (string memory) {
2079         unchecked {
2080             uint256 length = Math.log10(value) + 1;
2081             string memory buffer = new string(length);
2082             uint256 ptr;
2083             /// @solidity memory-safe-assembly
2084             assembly {
2085                 ptr := add(buffer, add(32, length))
2086             }
2087             while (true) {
2088                 ptr--;
2089                 /// @solidity memory-safe-assembly
2090                 assembly {
2091                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2092                 }
2093                 value /= 10;
2094                 if (value == 0) break;
2095             }
2096             return buffer;
2097         }
2098     }
2099 
2100     /**
2101      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2102      */
2103     function toHexString(uint256 value) internal pure returns (string memory) {
2104         unchecked {
2105             return toHexString(value, Math.log256(value) + 1);
2106         }
2107     }
2108 
2109     /**
2110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2111      */
2112     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2113         bytes memory buffer = new bytes(2 * length + 2);
2114         buffer[0] = "0";
2115         buffer[1] = "x";
2116         for (uint256 i = 2 * length + 1; i > 1; --i) {
2117             buffer[i] = _SYMBOLS[value & 0xf];
2118             value >>= 4;
2119         }
2120         require(value == 0, "Strings: hex length insufficient");
2121         return string(buffer);
2122     }
2123 
2124     /**
2125      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2126      */
2127     function toHexString(address addr) internal pure returns (string memory) {
2128         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2129     }
2130 }
2131 
2132 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2133 
2134 
2135 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (utils/cryptography/ECDSA.sol)
2136 
2137 pragma solidity ^0.8.0;
2138 
2139 
2140 /**
2141  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2142  *
2143  * These functions can be used to verify that a message was signed by the holder
2144  * of the private keys of a given address.
2145  */
2146 library ECDSA {
2147     enum RecoverError {
2148         NoError,
2149         InvalidSignature,
2150         InvalidSignatureLength,
2151         InvalidSignatureS,
2152         InvalidSignatureV // Deprecated in v4.8
2153     }
2154 
2155     function _throwError(RecoverError error) private pure {
2156         if (error == RecoverError.NoError) {
2157             return; // no error: do nothing
2158         } else if (error == RecoverError.InvalidSignature) {
2159             revert("ECDSA: invalid signature");
2160         } else if (error == RecoverError.InvalidSignatureLength) {
2161             revert("ECDSA: invalid signature length");
2162         } else if (error == RecoverError.InvalidSignatureS) {
2163             revert("ECDSA: invalid signature 's' value");
2164         }
2165     }
2166 
2167     /**
2168      * @dev Returns the address that signed a hashed message (`hash`) with
2169      * `signature` or error string. This address can then be used for verification purposes.
2170      *
2171      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2172      * this function rejects them by requiring the `s` value to be in the lower
2173      * half order, and the `v` value to be either 27 or 28.
2174      *
2175      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2176      * verification to be secure: it is possible to craft signatures that
2177      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2178      * this is by receiving a hash of the original message (which may otherwise
2179      * be too long), and then calling {toEthSignedMessageHash} on it.
2180      *
2181      * Documentation for signature generation:
2182      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
2183      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
2184      *
2185      * _Available since v4.3._
2186      */
2187     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
2188         if (signature.length == 65) {
2189             bytes32 r;
2190             bytes32 s;
2191             uint8 v;
2192             // ecrecover takes the signature parameters, and the only way to get them
2193             // currently is to use assembly.
2194             /// @solidity memory-safe-assembly
2195             assembly {
2196                 r := mload(add(signature, 0x20))
2197                 s := mload(add(signature, 0x40))
2198                 v := byte(0, mload(add(signature, 0x60)))
2199             }
2200             return tryRecover(hash, v, r, s);
2201         } else {
2202             return (address(0), RecoverError.InvalidSignatureLength);
2203         }
2204     }
2205 
2206     /**
2207      * @dev Returns the address that signed a hashed message (`hash`) with
2208      * `signature`. This address can then be used for verification purposes.
2209      *
2210      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2211      * this function rejects them by requiring the `s` value to be in the lower
2212      * half order, and the `v` value to be either 27 or 28.
2213      *
2214      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2215      * verification to be secure: it is possible to craft signatures that
2216      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2217      * this is by receiving a hash of the original message (which may otherwise
2218      * be too long), and then calling {toEthSignedMessageHash} on it.
2219      */
2220     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
2221         (address recovered, RecoverError error) = tryRecover(hash, signature);
2222         _throwError(error);
2223         return recovered;
2224     }
2225 
2226     /**
2227      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
2228      *
2229      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
2230      *
2231      * _Available since v4.3._
2232      */
2233     function tryRecover(
2234         bytes32 hash,
2235         bytes32 r,
2236         bytes32 vs
2237     ) internal pure returns (address, RecoverError) {
2238         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
2239         uint8 v = uint8((uint256(vs) >> 255) + 27);
2240         return tryRecover(hash, v, r, s);
2241     }
2242 
2243     /**
2244      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2245      *
2246      * _Available since v4.2._
2247      */
2248     function recover(
2249         bytes32 hash,
2250         bytes32 r,
2251         bytes32 vs
2252     ) internal pure returns (address) {
2253         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2254         _throwError(error);
2255         return recovered;
2256     }
2257 
2258     /**
2259      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
2260      * `r` and `s` signature fields separately.
2261      *
2262      * _Available since v4.3._
2263      */
2264     function tryRecover(
2265         bytes32 hash,
2266         uint8 v,
2267         bytes32 r,
2268         bytes32 s
2269     ) internal pure returns (address, RecoverError) {
2270         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2271         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2272         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
2273         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2274         //
2275         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2276         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2277         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2278         // these malleable signatures as well.
2279         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2280             return (address(0), RecoverError.InvalidSignatureS);
2281         }
2282 
2283         // If the signature is valid (and not malleable), return the signer address
2284         address signer = ecrecover(hash, v, r, s);
2285         if (signer == address(0)) {
2286             return (address(0), RecoverError.InvalidSignature);
2287         }
2288 
2289         return (signer, RecoverError.NoError);
2290     }
2291 
2292     /**
2293      * @dev Overload of {ECDSA-recover} that receives the `v`,
2294      * `r` and `s` signature fields separately.
2295      */
2296     function recover(
2297         bytes32 hash,
2298         uint8 v,
2299         bytes32 r,
2300         bytes32 s
2301     ) internal pure returns (address) {
2302         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2303         _throwError(error);
2304         return recovered;
2305     }
2306 
2307     /**
2308      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2309      * produces hash corresponding to the one signed with the
2310      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2311      * JSON-RPC method as part of EIP-191.
2312      *
2313      * See {recover}.
2314      */
2315     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2316         // 32 is the length in bytes of hash,
2317         // enforced by the type signature above
2318         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2319     }
2320 
2321     /**
2322      * @dev Returns an Ethereum Signed Message, created from `s`. This
2323      * produces hash corresponding to the one signed with the
2324      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2325      * JSON-RPC method as part of EIP-191.
2326      *
2327      * See {recover}.
2328      */
2329     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
2330         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
2331     }
2332 
2333     /**
2334      * @dev Returns an Ethereum Signed Typed Data, created from a
2335      * `domainSeparator` and a `structHash`. This produces hash corresponding
2336      * to the one signed with the
2337      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2338      * JSON-RPC method as part of EIP-712.
2339      *
2340      * See {recover}.
2341      */
2342     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2343         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2344     }
2345 }
2346 
2347 // File: @openzeppelin/contracts/utils/Context.sol
2348 
2349 
2350 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2351 
2352 pragma solidity ^0.8.0;
2353 
2354 /**
2355  * @dev Provides information about the current execution context, including the
2356  * sender of the transaction and its data. While these are generally available
2357  * via msg.sender and msg.data, they should not be accessed in such a direct
2358  * manner, since when dealing with meta-transactions the account sending and
2359  * paying for execution may not be the actual sender (as far as an application
2360  * is concerned).
2361  *
2362  * This contract is only required for intermediate, library-like contracts.
2363  */
2364 abstract contract Context {
2365     function _msgSender() internal view virtual returns (address) {
2366         return msg.sender;
2367     }
2368 
2369     function _msgData() internal view virtual returns (bytes calldata) {
2370         return msg.data;
2371     }
2372 }
2373 
2374 // File: @openzeppelin/contracts/access/Ownable.sol
2375 
2376 
2377 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2378 
2379 pragma solidity ^0.8.0;
2380 
2381 
2382 /**
2383  * @dev Contract module which provides a basic access control mechanism, where
2384  * there is an account (an owner) that can be granted exclusive access to
2385  * specific functions.
2386  *
2387  * By default, the owner account will be the one that deploys the contract. This
2388  * can later be changed with {transferOwnership}.
2389  *
2390  * This module is used through inheritance. It will make available the modifier
2391  * `onlyOwner`, which can be applied to your functions to restrict their use to
2392  * the owner.
2393  */
2394 abstract contract Ownable is Context {
2395     address private _owner;
2396 
2397     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2398 
2399     /**
2400      * @dev Initializes the contract setting the deployer as the initial owner.
2401      */
2402     constructor() {
2403         _transferOwnership(_msgSender());
2404     }
2405 
2406     /**
2407      * @dev Throws if called by any account other than the owner.
2408      */
2409     modifier onlyOwner() {
2410         _checkOwner();
2411         _;
2412     }
2413 
2414     /**
2415      * @dev Returns the address of the current owner.
2416      */
2417     function owner() public view virtual returns (address) {
2418         return _owner;
2419     }
2420 
2421     /**
2422      * @dev Throws if the sender is not the owner.
2423      */
2424     function _checkOwner() internal view virtual {
2425         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2426     }
2427 
2428     /**
2429      * @dev Leaves the contract without owner. It will not be possible to call
2430      * `onlyOwner` functions anymore. Can only be called by the current owner.
2431      *
2432      * NOTE: Renouncing ownership will leave the contract without an owner,
2433      * thereby removing any functionality that is only available to the owner.
2434      */
2435     function renounceOwnership() public virtual onlyOwner {
2436         _transferOwnership(address(0));
2437     }
2438 
2439     /**
2440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2441      * Can only be called by the current owner.
2442      */
2443     function transferOwnership(address newOwner) public virtual onlyOwner {
2444         require(newOwner != address(0), "Ownable: new owner is the zero address");
2445         _transferOwnership(newOwner);
2446     }
2447 
2448     /**
2449      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2450      * Internal function without access restriction.
2451      */
2452     function _transferOwnership(address newOwner) internal virtual {
2453         address oldOwner = _owner;
2454         _owner = newOwner;
2455         emit OwnershipTransferred(oldOwner, newOwner);
2456     }
2457 }
2458 
2459 // File: @openzeppelin/contracts/utils/Address.sol
2460 
2461 
2462 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (utils/Address.sol)
2463 
2464 pragma solidity ^0.8.1;
2465 
2466 /**
2467  * @dev Collection of functions related to the address type
2468  */
2469 library Address {
2470     /**
2471      * @dev Returns true if `account` is a contract.
2472      *
2473      * [IMPORTANT]
2474      * ====
2475      * It is unsafe to assume that an address for which this function returns
2476      * false is an externally-owned account (EOA) and not a contract.
2477      *
2478      * Among others, `isContract` will return false for the following
2479      * types of addresses:
2480      *
2481      *  - an externally-owned account
2482      *  - a contract in construction
2483      *  - an address where a contract will be created
2484      *  - an address where a contract lived, but was destroyed
2485      * ====
2486      *
2487      * [IMPORTANT]
2488      * ====
2489      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2490      *
2491      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2492      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2493      * constructor.
2494      * ====
2495      */
2496     function isContract(address account) internal view returns (bool) {
2497         // This method relies on extcodesize/address.code.length, which returns 0
2498         // for contracts in construction, since the code is only stored at the end
2499         // of the constructor execution.
2500 
2501         return account.code.length > 0;
2502     }
2503 
2504     /**
2505      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2506      * `recipient`, forwarding all available gas and reverting on errors.
2507      *
2508      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2509      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2510      * imposed by `transfer`, making them unable to receive funds via
2511      * `transfer`. {sendValue} removes this limitation.
2512      *
2513      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2514      *
2515      * IMPORTANT: because control is transferred to `recipient`, care must be
2516      * taken to not create reentrancy vulnerabilities. Consider using
2517      * {ReentrancyGuard} or the
2518      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2519      */
2520     function sendValue(address payable recipient, uint256 amount) internal {
2521         require(address(this).balance >= amount, "Address: insufficient balance");
2522 
2523         (bool success, ) = recipient.call{value: amount}("");
2524         require(success, "Address: unable to send value, recipient may have reverted");
2525     }
2526 
2527     /**
2528      * @dev Performs a Solidity function call using a low level `call`. A
2529      * plain `call` is an unsafe replacement for a function call: use this
2530      * function instead.
2531      *
2532      * If `target` reverts with a revert reason, it is bubbled up by this
2533      * function (like regular Solidity function calls).
2534      *
2535      * Returns the raw returned data. To convert to the expected return value,
2536      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2537      *
2538      * Requirements:
2539      *
2540      * - `target` must be a contract.
2541      * - calling `target` with `data` must not revert.
2542      *
2543      * _Available since v3.1._
2544      */
2545     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2546         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
2547     }
2548 
2549     /**
2550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2551      * `errorMessage` as a fallback revert reason when `target` reverts.
2552      *
2553      * _Available since v3.1._
2554      */
2555     function functionCall(
2556         address target,
2557         bytes memory data,
2558         string memory errorMessage
2559     ) internal returns (bytes memory) {
2560         return functionCallWithValue(target, data, 0, errorMessage);
2561     }
2562 
2563     /**
2564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2565      * but also transferring `value` wei to `target`.
2566      *
2567      * Requirements:
2568      *
2569      * - the calling contract must have an ETH balance of at least `value`.
2570      * - the called Solidity function must be `payable`.
2571      *
2572      * _Available since v3.1._
2573      */
2574     function functionCallWithValue(
2575         address target,
2576         bytes memory data,
2577         uint256 value
2578     ) internal returns (bytes memory) {
2579         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2580     }
2581 
2582     /**
2583      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2584      * with `errorMessage` as a fallback revert reason when `target` reverts.
2585      *
2586      * _Available since v3.1._
2587      */
2588     function functionCallWithValue(
2589         address target,
2590         bytes memory data,
2591         uint256 value,
2592         string memory errorMessage
2593     ) internal returns (bytes memory) {
2594         require(address(this).balance >= value, "Address: insufficient balance for call");
2595         (bool success, bytes memory returndata) = target.call{value: value}(data);
2596         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2597     }
2598 
2599     /**
2600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2601      * but performing a static call.
2602      *
2603      * _Available since v3.3._
2604      */
2605     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2606         return functionStaticCall(target, data, "Address: low-level static call failed");
2607     }
2608 
2609     /**
2610      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2611      * but performing a static call.
2612      *
2613      * _Available since v3.3._
2614      */
2615     function functionStaticCall(
2616         address target,
2617         bytes memory data,
2618         string memory errorMessage
2619     ) internal view returns (bytes memory) {
2620         (bool success, bytes memory returndata) = target.staticcall(data);
2621         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2622     }
2623 
2624     /**
2625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2626      * but performing a delegate call.
2627      *
2628      * _Available since v3.4._
2629      */
2630     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2631         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2632     }
2633 
2634     /**
2635      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2636      * but performing a delegate call.
2637      *
2638      * _Available since v3.4._
2639      */
2640     function functionDelegateCall(
2641         address target,
2642         bytes memory data,
2643         string memory errorMessage
2644     ) internal returns (bytes memory) {
2645         (bool success, bytes memory returndata) = target.delegatecall(data);
2646         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2647     }
2648 
2649     /**
2650      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
2651      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
2652      *
2653      * _Available since v4.8._
2654      */
2655     function verifyCallResultFromTarget(
2656         address target,
2657         bool success,
2658         bytes memory returndata,
2659         string memory errorMessage
2660     ) internal view returns (bytes memory) {
2661         if (success) {
2662             if (returndata.length == 0) {
2663                 // only check isContract if the call was successful and the return data is empty
2664                 // otherwise we already know that it was a contract
2665                 require(isContract(target), "Address: call to non-contract");
2666             }
2667             return returndata;
2668         } else {
2669             _revert(returndata, errorMessage);
2670         }
2671     }
2672 
2673     /**
2674      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
2675      * revert reason or using the provided one.
2676      *
2677      * _Available since v4.3._
2678      */
2679     function verifyCallResult(
2680         bool success,
2681         bytes memory returndata,
2682         string memory errorMessage
2683     ) internal pure returns (bytes memory) {
2684         if (success) {
2685             return returndata;
2686         } else {
2687             _revert(returndata, errorMessage);
2688         }
2689     }
2690 
2691     function _revert(bytes memory returndata, string memory errorMessage) private pure {
2692         // Look for revert reason and bubble it up if present
2693         if (returndata.length > 0) {
2694             // The easiest way to bubble the revert reason is using memory via assembly
2695             /// @solidity memory-safe-assembly
2696             assembly {
2697                 let returndata_size := mload(returndata)
2698                 revert(add(32, returndata), returndata_size)
2699             }
2700         } else {
2701             revert(errorMessage);
2702         }
2703     }
2704 }
2705 
2706 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
2707 
2708 
2709 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2710 
2711 pragma solidity ^0.8.0;
2712 
2713 /**
2714  * @title ERC721 token receiver interface
2715  * @dev Interface for any contract that wants to support safeTransfers
2716  * from ERC721 asset contracts.
2717  */
2718 interface IERC721Receiver {
2719     /**
2720      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2721      * by `operator` from `from`, this function is called.
2722      *
2723      * It must return its Solidity selector to confirm the token transfer.
2724      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2725      *
2726      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2727      */
2728     function onERC721Received(
2729         address operator,
2730         address from,
2731         uint256 tokenId,
2732         bytes calldata data
2733     ) external returns (bytes4);
2734 }
2735 
2736 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2737 
2738 
2739 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2740 
2741 pragma solidity ^0.8.0;
2742 
2743 /**
2744  * @dev Interface of the ERC165 standard, as defined in the
2745  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2746  *
2747  * Implementers can declare support of contract interfaces, which can then be
2748  * queried by others ({ERC165Checker}).
2749  *
2750  * For an implementation, see {ERC165}.
2751  */
2752 interface IERC165 {
2753     /**
2754      * @dev Returns true if this contract implements the interface defined by
2755      * `interfaceId`. See the corresponding
2756      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2757      * to learn more about how these ids are created.
2758      *
2759      * This function call must use less than 30 000 gas.
2760      */
2761     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2762 }
2763 
2764 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
2765 
2766 
2767 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2768 
2769 pragma solidity ^0.8.0;
2770 
2771 
2772 /**
2773  * @dev Implementation of the {IERC165} interface.
2774  *
2775  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2776  * for the additional interface id that will be supported. For example:
2777  *
2778  * ```solidity
2779  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2780  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2781  * }
2782  * ```
2783  *
2784  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2785  */
2786 abstract contract ERC165 is IERC165 {
2787     /**
2788      * @dev See {IERC165-supportsInterface}.
2789      */
2790     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2791         return interfaceId == type(IERC165).interfaceId;
2792     }
2793 }
2794 
2795 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
2796 
2797 
2798 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (token/ERC721/IERC721.sol)
2799 
2800 pragma solidity ^0.8.0;
2801 
2802 
2803 /**
2804  * @dev Required interface of an ERC721 compliant contract.
2805  */
2806 interface IERC721 is IERC165 {
2807     /**
2808      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2809      */
2810     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2811 
2812     /**
2813      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2814      */
2815     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2816 
2817     /**
2818      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2819      */
2820     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2821 
2822     /**
2823      * @dev Returns the number of tokens in ``owner``'s account.
2824      */
2825     function balanceOf(address owner) external view returns (uint256 balance);
2826 
2827     /**
2828      * @dev Returns the owner of the `tokenId` token.
2829      *
2830      * Requirements:
2831      *
2832      * - `tokenId` must exist.
2833      */
2834     function ownerOf(uint256 tokenId) external view returns (address owner);
2835 
2836     /**
2837      * @dev Safely transfers `tokenId` token from `from` to `to`.
2838      *
2839      * Requirements:
2840      *
2841      * - `from` cannot be the zero address.
2842      * - `to` cannot be the zero address.
2843      * - `tokenId` token must exist and be owned by `from`.
2844      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2845      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2846      *
2847      * Emits a {Transfer} event.
2848      */
2849     function safeTransferFrom(
2850         address from,
2851         address to,
2852         uint256 tokenId,
2853         bytes calldata data
2854     ) external;
2855 
2856     /**
2857      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2858      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2859      *
2860      * Requirements:
2861      *
2862      * - `from` cannot be the zero address.
2863      * - `to` cannot be the zero address.
2864      * - `tokenId` token must exist and be owned by `from`.
2865      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2866      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2867      *
2868      * Emits a {Transfer} event.
2869      */
2870     function safeTransferFrom(
2871         address from,
2872         address to,
2873         uint256 tokenId
2874     ) external;
2875 
2876     /**
2877      * @dev Transfers `tokenId` token from `from` to `to`.
2878      *
2879      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
2880      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
2881      * understand this adds an external call which potentially creates a reentrancy vulnerability.
2882      *
2883      * Requirements:
2884      *
2885      * - `from` cannot be the zero address.
2886      * - `to` cannot be the zero address.
2887      * - `tokenId` token must be owned by `from`.
2888      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2889      *
2890      * Emits a {Transfer} event.
2891      */
2892     function transferFrom(
2893         address from,
2894         address to,
2895         uint256 tokenId
2896     ) external;
2897 
2898     /**
2899      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2900      * The approval is cleared when the token is transferred.
2901      *
2902      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2903      *
2904      * Requirements:
2905      *
2906      * - The caller must own the token or be an approved operator.
2907      * - `tokenId` must exist.
2908      *
2909      * Emits an {Approval} event.
2910      */
2911     function approve(address to, uint256 tokenId) external;
2912 
2913     /**
2914      * @dev Approve or remove `operator` as an operator for the caller.
2915      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2916      *
2917      * Requirements:
2918      *
2919      * - The `operator` cannot be the caller.
2920      *
2921      * Emits an {ApprovalForAll} event.
2922      */
2923     function setApprovalForAll(address operator, bool _approved) external;
2924 
2925     /**
2926      * @dev Returns the account approved for `tokenId` token.
2927      *
2928      * Requirements:
2929      *
2930      * - `tokenId` must exist.
2931      */
2932     function getApproved(uint256 tokenId) external view returns (address operator);
2933 
2934     /**
2935      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2936      *
2937      * See {setApprovalForAll}
2938      */
2939     function isApprovedForAll(address owner, address operator) external view returns (bool);
2940 }
2941 
2942 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
2943 
2944 
2945 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2946 
2947 pragma solidity ^0.8.0;
2948 
2949 
2950 /**
2951  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2952  * @dev See https://eips.ethereum.org/EIPS/eip-721
2953  */
2954 interface IERC721Metadata is IERC721 {
2955     /**
2956      * @dev Returns the token collection name.
2957      */
2958     function name() external view returns (string memory);
2959 
2960     /**
2961      * @dev Returns the token collection symbol.
2962      */
2963     function symbol() external view returns (string memory);
2964 
2965     /**
2966      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2967      */
2968     function tokenURI(uint256 tokenId) external view returns (string memory);
2969 }
2970 
2971 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2972 
2973 
2974 // OpenZeppelin Contracts (last updated v4.8.0-rc.1) (token/ERC721/ERC721.sol)
2975 
2976 pragma solidity ^0.8.0;
2977 
2978 
2979 
2980 
2981 
2982 
2983 
2984 
2985 /**
2986  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2987  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2988  * {ERC721Enumerable}.
2989  */
2990 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2991     using Address for address;
2992     using Strings for uint256;
2993 
2994     // Token name
2995     string private _name;
2996 
2997     // Token symbol
2998     string private _symbol;
2999 
3000     // Mapping from token ID to owner address
3001     mapping(uint256 => address) private _owners;
3002 
3003     // Mapping owner address to token count
3004     mapping(address => uint256) private _balances;
3005 
3006     // Mapping from token ID to approved address
3007     mapping(uint256 => address) private _tokenApprovals;
3008 
3009     // Mapping from owner to operator approvals
3010     mapping(address => mapping(address => bool)) private _operatorApprovals;
3011 
3012     /**
3013      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
3014      */
3015     constructor(string memory name_, string memory symbol_) {
3016         _name = name_;
3017         _symbol = symbol_;
3018     }
3019 
3020     /**
3021      * @dev See {IERC165-supportsInterface}.
3022      */
3023     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
3024         return
3025             interfaceId == type(IERC721).interfaceId ||
3026             interfaceId == type(IERC721Metadata).interfaceId ||
3027             super.supportsInterface(interfaceId);
3028     }
3029 
3030     /**
3031      * @dev See {IERC721-balanceOf}.
3032      */
3033     function balanceOf(address owner) public view virtual override returns (uint256) {
3034         require(owner != address(0), "ERC721: address zero is not a valid owner");
3035         return _balances[owner];
3036     }
3037 
3038     /**
3039      * @dev See {IERC721-ownerOf}.
3040      */
3041     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
3042         address owner = _ownerOf(tokenId);
3043         require(owner != address(0), "ERC721: invalid token ID");
3044         return owner;
3045     }
3046 
3047     /**
3048      * @dev See {IERC721Metadata-name}.
3049      */
3050     function name() public view virtual override returns (string memory) {
3051         return _name;
3052     }
3053 
3054     /**
3055      * @dev See {IERC721Metadata-symbol}.
3056      */
3057     function symbol() public view virtual override returns (string memory) {
3058         return _symbol;
3059     }
3060 
3061     /**
3062      * @dev See {IERC721Metadata-tokenURI}.
3063      */
3064     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3065         _requireMinted(tokenId);
3066 
3067         string memory baseURI = _baseURI();
3068         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
3069     }
3070 
3071     /**
3072      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
3073      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
3074      * by default, can be overridden in child contracts.
3075      */
3076     function _baseURI() internal view virtual returns (string memory) {
3077         return "";
3078     }
3079 
3080     /**
3081      * @dev See {IERC721-approve}.
3082      */
3083     function approve(address to, uint256 tokenId) public virtual override {
3084         address owner = ERC721.ownerOf(tokenId);
3085         require(to != owner, "ERC721: approval to current owner");
3086 
3087         require(
3088             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
3089             "ERC721: approve caller is not token owner or approved for all"
3090         );
3091 
3092         _approve(to, tokenId);
3093     }
3094 
3095     /**
3096      * @dev See {IERC721-getApproved}.
3097      */
3098     function getApproved(uint256 tokenId) public view virtual override returns (address) {
3099         _requireMinted(tokenId);
3100 
3101         return _tokenApprovals[tokenId];
3102     }
3103 
3104     /**
3105      * @dev See {IERC721-setApprovalForAll}.
3106      */
3107     function setApprovalForAll(address operator, bool approved) public virtual override {
3108         _setApprovalForAll(_msgSender(), operator, approved);
3109     }
3110 
3111     /**
3112      * @dev See {IERC721-isApprovedForAll}.
3113      */
3114     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
3115         return _operatorApprovals[owner][operator];
3116     }
3117 
3118     /**
3119      * @dev See {IERC721-transferFrom}.
3120      */
3121     function transferFrom(
3122         address from,
3123         address to,
3124         uint256 tokenId
3125     ) public virtual override {
3126         //solhint-disable-next-line max-line-length
3127         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3128 
3129         _transfer(from, to, tokenId);
3130     }
3131 
3132     /**
3133      * @dev See {IERC721-safeTransferFrom}.
3134      */
3135     function safeTransferFrom(
3136         address from,
3137         address to,
3138         uint256 tokenId
3139     ) public virtual override {
3140         safeTransferFrom(from, to, tokenId, "");
3141     }
3142 
3143     /**
3144      * @dev See {IERC721-safeTransferFrom}.
3145      */
3146     function safeTransferFrom(
3147         address from,
3148         address to,
3149         uint256 tokenId,
3150         bytes memory data
3151     ) public virtual override {
3152         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3153         _safeTransfer(from, to, tokenId, data);
3154     }
3155 
3156     /**
3157      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3158      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3159      *
3160      * `data` is additional data, it has no specified format and it is sent in call to `to`.
3161      *
3162      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
3163      * implement alternative mechanisms to perform token transfer, such as signature-based.
3164      *
3165      * Requirements:
3166      *
3167      * - `from` cannot be the zero address.
3168      * - `to` cannot be the zero address.
3169      * - `tokenId` token must exist and be owned by `from`.
3170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3171      *
3172      * Emits a {Transfer} event.
3173      */
3174     function _safeTransfer(
3175         address from,
3176         address to,
3177         uint256 tokenId,
3178         bytes memory data
3179     ) internal virtual {
3180         _transfer(from, to, tokenId);
3181         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
3182     }
3183 
3184     /**
3185      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
3186      */
3187     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
3188         return _owners[tokenId];
3189     }
3190 
3191     /**
3192      * @dev Returns whether `tokenId` exists.
3193      *
3194      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3195      *
3196      * Tokens start existing when they are minted (`_mint`),
3197      * and stop existing when they are burned (`_burn`).
3198      */
3199     function _exists(uint256 tokenId) internal view virtual returns (bool) {
3200         return _ownerOf(tokenId) != address(0);
3201     }
3202 
3203     /**
3204      * @dev Returns whether `spender` is allowed to manage `tokenId`.
3205      *
3206      * Requirements:
3207      *
3208      * - `tokenId` must exist.
3209      */
3210     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
3211         address owner = ERC721.ownerOf(tokenId);
3212         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
3213     }
3214 
3215     /**
3216      * @dev Safely mints `tokenId` and transfers it to `to`.
3217      *
3218      * Requirements:
3219      *
3220      * - `tokenId` must not exist.
3221      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3222      *
3223      * Emits a {Transfer} event.
3224      */
3225     function _safeMint(address to, uint256 tokenId) internal virtual {
3226         _safeMint(to, tokenId, "");
3227     }
3228 
3229     /**
3230      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
3231      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
3232      */
3233     function _safeMint(
3234         address to,
3235         uint256 tokenId,
3236         bytes memory data
3237     ) internal virtual {
3238         _mint(to, tokenId);
3239         require(
3240             _checkOnERC721Received(address(0), to, tokenId, data),
3241             "ERC721: transfer to non ERC721Receiver implementer"
3242         );
3243     }
3244 
3245     /**
3246      * @dev Mints `tokenId` and transfers it to `to`.
3247      *
3248      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
3249      *
3250      * Requirements:
3251      *
3252      * - `tokenId` must not exist.
3253      * - `to` cannot be the zero address.
3254      *
3255      * Emits a {Transfer} event.
3256      */
3257     function _mint(address to, uint256 tokenId) internal virtual {
3258         require(to != address(0), "ERC721: mint to the zero address");
3259         require(!_exists(tokenId), "ERC721: token already minted");
3260 
3261         _beforeTokenTransfer(address(0), to, tokenId);
3262 
3263         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
3264         require(!_exists(tokenId), "ERC721: token already minted");
3265 
3266         unchecked {
3267             // Will not overflow unless all 2**256 token ids are minted to the same owner.
3268             // Given that tokens are minted one by one, it is impossible in practice that
3269             // this ever happens. Might change if we allow batch minting.
3270             // The ERC fails to describe this case.
3271             _balances[to] += 1;
3272         }
3273 
3274         _owners[tokenId] = to;
3275 
3276         emit Transfer(address(0), to, tokenId);
3277 
3278         _afterTokenTransfer(address(0), to, tokenId);
3279     }
3280 
3281     /**
3282      * @dev Destroys `tokenId`.
3283      * The approval is cleared when the token is burned.
3284      * This is an internal function that does not check if the sender is authorized to operate on the token.
3285      *
3286      * Requirements:
3287      *
3288      * - `tokenId` must exist.
3289      *
3290      * Emits a {Transfer} event.
3291      */
3292     function _burn(uint256 tokenId) internal virtual {
3293         address owner = ERC721.ownerOf(tokenId);
3294 
3295         _beforeTokenTransfer(owner, address(0), tokenId);
3296 
3297         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
3298         owner = ERC721.ownerOf(tokenId);
3299 
3300         // Clear approvals
3301         delete _tokenApprovals[tokenId];
3302 
3303         unchecked {
3304             // Cannot overflow, as that would require more tokens to be burned/transferred
3305             // out than the owner initially received through minting and transferring in.
3306             _balances[owner] -= 1;
3307         }
3308         delete _owners[tokenId];
3309 
3310         emit Transfer(owner, address(0), tokenId);
3311 
3312         _afterTokenTransfer(owner, address(0), tokenId);
3313     }
3314 
3315     /**
3316      * @dev Transfers `tokenId` from `from` to `to`.
3317      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3318      *
3319      * Requirements:
3320      *
3321      * - `to` cannot be the zero address.
3322      * - `tokenId` token must be owned by `from`.
3323      *
3324      * Emits a {Transfer} event.
3325      */
3326     function _transfer(
3327         address from,
3328         address to,
3329         uint256 tokenId
3330     ) internal virtual {
3331         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3332         require(to != address(0), "ERC721: transfer to the zero address");
3333 
3334         _beforeTokenTransfer(from, to, tokenId);
3335 
3336         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
3337         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3338 
3339         // Clear approvals from the previous owner
3340         delete _tokenApprovals[tokenId];
3341 
3342         unchecked {
3343             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
3344             // `from`'s balance is the number of token held, which is at least one before the current
3345             // transfer.
3346             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
3347             // all 2**256 token ids to be minted, which in practice is impossible.
3348             _balances[from] -= 1;
3349             _balances[to] += 1;
3350         }
3351         _owners[tokenId] = to;
3352 
3353         emit Transfer(from, to, tokenId);
3354 
3355         _afterTokenTransfer(from, to, tokenId);
3356     }
3357 
3358     /**
3359      * @dev Approve `to` to operate on `tokenId`
3360      *
3361      * Emits an {Approval} event.
3362      */
3363     function _approve(address to, uint256 tokenId) internal virtual {
3364         _tokenApprovals[tokenId] = to;
3365         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3366     }
3367 
3368     /**
3369      * @dev Approve `operator` to operate on all of `owner` tokens
3370      *
3371      * Emits an {ApprovalForAll} event.
3372      */
3373     function _setApprovalForAll(
3374         address owner,
3375         address operator,
3376         bool approved
3377     ) internal virtual {
3378         require(owner != operator, "ERC721: approve to caller");
3379         _operatorApprovals[owner][operator] = approved;
3380         emit ApprovalForAll(owner, operator, approved);
3381     }
3382 
3383     /**
3384      * @dev Reverts if the `tokenId` has not been minted yet.
3385      */
3386     function _requireMinted(uint256 tokenId) internal view virtual {
3387         require(_exists(tokenId), "ERC721: invalid token ID");
3388     }
3389 
3390     /**
3391      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3392      * The call is not executed if the target address is not a contract.
3393      *
3394      * @param from address representing the previous owner of the given token ID
3395      * @param to target address that will receive the tokens
3396      * @param tokenId uint256 ID of the token to be transferred
3397      * @param data bytes optional data to send along with the call
3398      * @return bool whether the call correctly returned the expected magic value
3399      */
3400     function _checkOnERC721Received(
3401         address from,
3402         address to,
3403         uint256 tokenId,
3404         bytes memory data
3405     ) private returns (bool) {
3406         if (to.isContract()) {
3407             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
3408                 return retval == IERC721Receiver.onERC721Received.selector;
3409             } catch (bytes memory reason) {
3410                 if (reason.length == 0) {
3411                     revert("ERC721: transfer to non ERC721Receiver implementer");
3412                 } else {
3413                     /// @solidity memory-safe-assembly
3414                     assembly {
3415                         revert(add(32, reason), mload(reason))
3416                     }
3417                 }
3418             }
3419         } else {
3420             return true;
3421         }
3422     }
3423 
3424     /**
3425      * @dev Hook that is called before any (single) token transfer. This includes minting and burning.
3426      * See {_beforeConsecutiveTokenTransfer}.
3427      *
3428      * Calling conditions:
3429      *
3430      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3431      * transferred to `to`.
3432      * - When `from` is zero, `tokenId` will be minted for `to`.
3433      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3434      * - `from` and `to` are never both zero.
3435      *
3436      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3437      */
3438     function _beforeTokenTransfer(
3439         address from,
3440         address to,
3441         uint256 tokenId
3442     ) internal virtual {}
3443 
3444     /**
3445      * @dev Hook that is called after any (single) transfer of tokens. This includes minting and burning.
3446      * See {_afterConsecutiveTokenTransfer}.
3447      *
3448      * Calling conditions:
3449      *
3450      * - when `from` and `to` are both non-zero.
3451      * - `from` and `to` are never both zero.
3452      *
3453      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3454      */
3455     function _afterTokenTransfer(
3456         address from,
3457         address to,
3458         uint256 tokenId
3459     ) internal virtual {}
3460 
3461     /**
3462      * @dev Hook that is called before consecutive token transfers.
3463      * Calling conditions are similar to {_beforeTokenTransfer}.
3464      *
3465      * The default implementation include balances updates that extensions such as {ERC721Consecutive} cannot perform
3466      * directly.
3467      */
3468     function _beforeConsecutiveTokenTransfer(
3469         address from,
3470         address to,
3471         uint256, /*first*/
3472         uint96 size
3473     ) internal virtual {
3474         if (from != address(0)) {
3475             _balances[from] -= size;
3476         }
3477         if (to != address(0)) {
3478             _balances[to] += size;
3479         }
3480     }
3481 
3482     /**
3483      * @dev Hook that is called after consecutive token transfers.
3484      * Calling conditions are similar to {_afterTokenTransfer}.
3485      */
3486     function _afterConsecutiveTokenTransfer(
3487         address, /*from*/
3488         address, /*to*/
3489         uint256, /*first*/
3490         uint96 /*size*/
3491     ) internal virtual {}
3492 }
3493 
3494 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
3495 
3496 
3497 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
3498 
3499 pragma solidity ^0.8.0;
3500 
3501 
3502 /**
3503  * @dev ERC721 token with storage based token URI management.
3504  */
3505 abstract contract ERC721URIStorage is ERC721 {
3506     using Strings for uint256;
3507 
3508     // Optional mapping for token URIs
3509     mapping(uint256 => string) private _tokenURIs;
3510 
3511     /**
3512      * @dev See {IERC721Metadata-tokenURI}.
3513      */
3514     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3515         _requireMinted(tokenId);
3516 
3517         string memory _tokenURI = _tokenURIs[tokenId];
3518         string memory base = _baseURI();
3519 
3520         // If there is no base URI, return the token URI.
3521         if (bytes(base).length == 0) {
3522             return _tokenURI;
3523         }
3524         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
3525         if (bytes(_tokenURI).length > 0) {
3526             return string(abi.encodePacked(base, _tokenURI));
3527         }
3528 
3529         return super.tokenURI(tokenId);
3530     }
3531 
3532     /**
3533      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
3534      *
3535      * Requirements:
3536      *
3537      * - `tokenId` must exist.
3538      */
3539     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
3540         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
3541         _tokenURIs[tokenId] = _tokenURI;
3542     }
3543 
3544     /**
3545      * @dev See {ERC721-_burn}. This override additionally checks to see if a
3546      * token-specific URI was set for the token, and if so, it deletes the token URI from
3547      * the storage mapping.
3548      */
3549     function _burn(uint256 tokenId) internal virtual override {
3550         super._burn(tokenId);
3551 
3552         if (bytes(_tokenURIs[tokenId]).length != 0) {
3553             delete _tokenURIs[tokenId];
3554         }
3555     }
3556 }
3557 
3558 // File: FinalTest.sol
3559 
3560 
3561 
3562 pragma solidity 0.8.9;
3563 
3564 
3565 
3566 
3567 
3568 
3569 
3570 
3571 
3572 contract Decentramon is ERC721A, ReentrancyGuard, Ownable {
3573     using Counters for Counters.Counter;  
3574     using Address for address;
3575     using ECDSA for bytes32;
3576     
3577     // Starting and stopping sale // Empezar y parar etapas
3578     bool public saleActive = false;
3579     bool public whitelistActive = false;
3580     bool public vipActive = false;
3581     bool public forsale = false;
3582 
3583     // Reserved for the team, customs, giveaways, collabs and so on // Reservado para equipo y otros
3584     uint256 public reserved = 1;
3585 
3586     // Price of each token // Precio inicial mint
3587     
3588     uint256 public MINT_PRICE = 0.059 ether; // price
3589     
3590     //Retirofondos
3591     address payable public withdrawWallet;
3592     // Public Sale Key // Key para verificación extra
3593     string publicKey; // Will change to hash instead of int
3594     string public baseExtension = ".json";
3595     // Maximum limit of tokens that can ever exist // Número de Tokens
3596     mapping(address => uint256) private mintCountMap;
3597     mapping(address => uint256) private allowedMintCountMap;
3598     mapping(address => uint256) public walletMints;
3599     
3600     
3601     uint256 public constant MAX_SUPPLY = 111;
3602     uint256 public constant MINT_LIMIT_PER_WALLET = 1;
3603     uint256 public constant TOTAL_SUPPLY = 0;
3604     
3605 
3606     function max(uint256 a, uint256 b) private pure returns (uint256) {
3607     return a >= b ? a : b;
3608     }
3609 
3610     function allowedMintCount(address minter) public view returns (uint256) {
3611         if (saleActive || forsale || whitelistActive || vipActive) {
3612         return (
3613             max(allowedMintCountMap[minter], MINT_LIMIT_PER_WALLET) -
3614             mintCountMap[minter]
3615         );
3616         }
3617 
3618         return allowedMintCountMap[minter] - mintCountMap[minter];
3619     }
3620 
3621     function updateMintCount(address minter, uint256 count) private {
3622         mintCountMap[minter] += count;
3623     }
3624 
3625     // The base link that leads to the image / video of the token // URL del arte-metadata
3626     //string public baseTokenURI =;
3627     string public baseTokenURI = "";
3628 
3629 
3630     // List of addresses that have a number of reserved tokens for whitelist // Lista de direcciones para Whitelist y Raffle
3631     bytes32 private _whitelistMerkleRoot = 0xdd458cd4186c0d96db060cfdd293d2fc1f1d71350fb5d843be57e716e1fd7025;
3632     bytes32 private _whitelistPayMerkleRoot = 0xdd458cd4186c0d96db060cfdd293d2fc1f1d71350fb5d843be57e716e1fd7025;
3633     
3634 
3635     constructor()
3636     ERC721A ("Decentramon", "DMON") {
3637   }
3638 
3639     // Override so the openzeppelin tokenURI() method will use this method to create the full tokenURI instead // Reemplazar URI
3640     function _baseURI() internal view virtual override returns (string memory) {
3641         return baseTokenURI;
3642     }
3643 
3644     // Exclusive whitelist minting // Función mint con Whitelist
3645     Counters.Counter private supplyCounter;
3646 
3647     function mintWHITElist(bytes32[] memory proof, string memory _pass) public payable nonReentrant {
3648         uint256 quantity = 1;
3649         uint256 supply = totalSupply();
3650         require( whitelistActive,                   "Whitelist isn't active" );
3651         require(
3652             MerkleProof.verify(
3653                 proof,
3654                 _whitelistMerkleRoot,
3655                 keccak256(abi.encodePacked(msg.sender))
3656             ),
3657             "Whitelist validation failed"
3658         );
3659         require( keccak256(abi.encodePacked(publicKey)) == keccak256(abi.encodePacked(_pass)), "Key error"); // Key verifying web3 call // Key que "Verifica" la llamada al contract desde la web3
3660         require( supply + quantity <= MAX_SUPPLY,    "Can't mint more than WL supply" );
3661         require( supply + quantity <= MAX_SUPPLY,    "Can't mint more than max supply" );
3662         require( msg.value == MINT_PRICE * quantity,      "Wrong amount of ETH sent" );
3663         if (allowedMintCount(msg.sender) >= 1) {
3664         updateMintCount(msg.sender, 1);
3665         } else {
3666         revert("Minting limit exceeded");
3667         }
3668         _safeMint( msg.sender, quantity);
3669         
3670     }
3671 
3672     // Exclusive VIP whitelist minting // Función mint pago con VIPlist
3673 
3674     function mintVIPlist(bytes32[] memory proof, uint256 quantity, string memory _pass) public payable nonReentrant {
3675         uint256 supply = totalSupply();
3676         require( whitelistActive,                   "VIPList isn't active" );
3677         require(
3678             MerkleProof.verify(
3679                 proof,
3680                 _whitelistPayMerkleRoot,
3681                 keccak256(abi.encodePacked(msg.sender))
3682             ),
3683             "VIPList validation failed"
3684         );
3685         require( keccak256(abi.encodePacked(publicKey)) == keccak256(abi.encodePacked(_pass)), "Key error"); // Key verifying web3 call // Key que "Verifica" la llamada al contract desde la web3
3686         require( quantity > 0,            "Can't mint less than one" );
3687         require( quantity <= 1,            "Can't mint more than reserved" );
3688         require( supply + quantity <= MAX_SUPPLY,    "Can't mint more than max supply" );
3689         require( supply + quantity <= MAX_SUPPLY,    "Can't mint more than max supply" );
3690         require( msg.value == MINT_PRICE * quantity,      "Wrong amount of ETH sent" );
3691         if (allowedMintCount(msg.sender) >= 1) {
3692         updateMintCount(msg.sender, 1);
3693         } else {
3694         revert("Minting limit exceeded");
3695         }
3696         _safeMint( msg.sender, quantity);
3697     }
3698 
3699 
3700     // Standard mint function // Mint normal sin restricción de dirección
3701 
3702     
3703     function mint(uint256 quantity) public payable nonReentrant {
3704         require( quantity > 0,            "Can't mint less than one" );
3705         require( quantity <= 1,            "Can't mint more than reserved" );
3706         require( forsale,                "Sale isn't active" );
3707         require( msg.value == quantity * MINT_PRICE,    "Wrong amount of ETH sent" );
3708         require( TOTAL_SUPPLY + quantity <= MAX_SUPPLY, "Sold Out");
3709         require(
3710             walletMints[msg.sender] + quantity <= MINT_LIMIT_PER_WALLET,
3711             "Exceed Max Wallet"
3712         );
3713 
3714         for (uint256 i = 0; i < quantity; i++) {
3715             uint256 newTokenId = TOTAL_SUPPLY + 1;
3716             _safeMint(msg.sender, newTokenId);
3717         }
3718 
3719     }
3720 
3721     // Admin minting function to reserve tokens for the team, collabs, customs and giveaways // Función de minteo de los admins
3722     function mintReserved(uint256 quantity) public onlyOwner {
3723         // Limited to a publicly set amount
3724         uint256 supply = totalSupply();
3725         require( quantity <= reserved, "Can't reserve more than set amount" );
3726         require( supply + quantity <= MAX_SUPPLY,    "Can't mint more than max supply" );
3727         reserved -= quantity;
3728         _safeMint( msg.sender, quantity );
3729     }
3730 
3731 
3732     function setMerkleWHITELIST(bytes32 root2) public onlyOwner {
3733         _whitelistMerkleRoot = root2;
3734     }
3735 
3736     function setMerkleVIP(bytes32 root3) public onlyOwner {
3737         _whitelistPayMerkleRoot = root3;
3738     }
3739 
3740     // Start and stop whitelist // Función que activa y desactiva el minteo por Whitelist
3741     function setWhitelistActive(bool val) public onlyOwner {
3742         whitelistActive = val;
3743     }
3744 
3745     // Start and stop raffle // Función que activa y desactiva el minteo vip
3746     function setVipMint(bool val) public onlyOwner {
3747         vipActive = val;
3748     }
3749 
3750     // Start and stop sale // Función que activa y desactiva el minteo por venta genérica
3751     function setSaleActive(bool val) public onlyOwner {
3752         saleActive = val;
3753     }
3754 
3755     function setForsale(bool val) public onlyOwner {
3756         forsale = val;
3757     }
3758     // Set new baseURI // Función para setear baseURI
3759     function setBaseURI(string memory baseURI) public onlyOwner {
3760         baseTokenURI = baseURI;
3761     }
3762 
3763     // Set public key // Función para cambio de key publica
3764     function setPublicKey(string memory newKey) public onlyOwner {
3765         publicKey = newKey;
3766     }
3767 
3768     function withdraw() public onlyOwner {
3769     
3770     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
3771     require(os);
3772     // =============================================================================
3773   }
3774 
3775 
3776 }