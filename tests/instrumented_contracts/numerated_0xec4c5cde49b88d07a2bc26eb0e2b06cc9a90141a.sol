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
1594 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1595 
1596 
1597 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1598 
1599 pragma solidity ^0.8.0;
1600 
1601 /**
1602  * @dev Interface of the ERC165 standard, as defined in the
1603  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1604  *
1605  * Implementers can declare support of contract interfaces, which can then be
1606  * queried by others ({ERC165Checker}).
1607  *
1608  * For an implementation, see {ERC165}.
1609  */
1610 interface IERC165 {
1611     /**
1612      * @dev Returns true if this contract implements the interface defined by
1613      * `interfaceId`. See the corresponding
1614      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1615      * to learn more about how these ids are created.
1616      *
1617      * This function call must use less than 30 000 gas.
1618      */
1619     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1620 }
1621 
1622 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1623 
1624 
1625 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1626 
1627 pragma solidity ^0.8.0;
1628 
1629 
1630 /**
1631  * @dev Implementation of the {IERC165} interface.
1632  *
1633  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1634  * for the additional interface id that will be supported. For example:
1635  *
1636  * ```solidity
1637  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1638  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1639  * }
1640  * ```
1641  *
1642  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1643  */
1644 abstract contract ERC165 is IERC165 {
1645     /**
1646      * @dev See {IERC165-supportsInterface}.
1647      */
1648     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1649         return interfaceId == type(IERC165).interfaceId;
1650     }
1651 }
1652 
1653 // File: @openzeppelin/contracts/utils/Strings.sol
1654 
1655 
1656 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1657 
1658 pragma solidity ^0.8.0;
1659 
1660 /**
1661  * @dev String operations.
1662  */
1663 library Strings {
1664     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1665     uint8 private constant _ADDRESS_LENGTH = 20;
1666 
1667     /**
1668      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1669      */
1670     function toString(uint256 value) internal pure returns (string memory) {
1671         // Inspired by OraclizeAPI's implementation - MIT licence
1672         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1673 
1674         if (value == 0) {
1675             return "0";
1676         }
1677         uint256 temp = value;
1678         uint256 digits;
1679         while (temp != 0) {
1680             digits++;
1681             temp /= 10;
1682         }
1683         bytes memory buffer = new bytes(digits);
1684         while (value != 0) {
1685             digits -= 1;
1686             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1687             value /= 10;
1688         }
1689         return string(buffer);
1690     }
1691 
1692     /**
1693      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1694      */
1695     function toHexString(uint256 value) internal pure returns (string memory) {
1696         if (value == 0) {
1697             return "0x00";
1698         }
1699         uint256 temp = value;
1700         uint256 length = 0;
1701         while (temp != 0) {
1702             length++;
1703             temp >>= 8;
1704         }
1705         return toHexString(value, length);
1706     }
1707 
1708     /**
1709      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1710      */
1711     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1712         bytes memory buffer = new bytes(2 * length + 2);
1713         buffer[0] = "0";
1714         buffer[1] = "x";
1715         for (uint256 i = 2 * length + 1; i > 1; --i) {
1716             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1717             value >>= 4;
1718         }
1719         require(value == 0, "Strings: hex length insufficient");
1720         return string(buffer);
1721     }
1722 
1723     /**
1724      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1725      */
1726     function toHexString(address addr) internal pure returns (string memory) {
1727         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1728     }
1729 }
1730 
1731 // File: @openzeppelin/contracts/utils/Context.sol
1732 
1733 
1734 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1735 
1736 pragma solidity ^0.8.0;
1737 
1738 /**
1739  * @dev Provides information about the current execution context, including the
1740  * sender of the transaction and its data. While these are generally available
1741  * via msg.sender and msg.data, they should not be accessed in such a direct
1742  * manner, since when dealing with meta-transactions the account sending and
1743  * paying for execution may not be the actual sender (as far as an application
1744  * is concerned).
1745  *
1746  * This contract is only required for intermediate, library-like contracts.
1747  */
1748 abstract contract Context {
1749     function _msgSender() internal view virtual returns (address) {
1750         return msg.sender;
1751     }
1752 
1753     function _msgData() internal view virtual returns (bytes calldata) {
1754         return msg.data;
1755     }
1756 }
1757 
1758 // File: @openzeppelin/contracts/access/Ownable.sol
1759 
1760 
1761 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1762 
1763 pragma solidity ^0.8.0;
1764 
1765 
1766 /**
1767  * @dev Contract module which provides a basic access control mechanism, where
1768  * there is an account (an owner) that can be granted exclusive access to
1769  * specific functions.
1770  *
1771  * By default, the owner account will be the one that deploys the contract. This
1772  * can later be changed with {transferOwnership}.
1773  *
1774  * This module is used through inheritance. It will make available the modifier
1775  * `onlyOwner`, which can be applied to your functions to restrict their use to
1776  * the owner.
1777  */
1778 abstract contract Ownable is Context {
1779     address private _owner;
1780 
1781     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1782 
1783     /**
1784      * @dev Initializes the contract setting the deployer as the initial owner.
1785      */
1786     constructor() {
1787         _transferOwnership(_msgSender());
1788     }
1789 
1790     /**
1791      * @dev Throws if called by any account other than the owner.
1792      */
1793     modifier onlyOwner() {
1794         _checkOwner();
1795         _;
1796     }
1797 
1798     /**
1799      * @dev Returns the address of the current owner.
1800      */
1801     function owner() public view virtual returns (address) {
1802         return _owner;
1803     }
1804 
1805     /**
1806      * @dev Throws if the sender is not the owner.
1807      */
1808     function _checkOwner() internal view virtual {
1809         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1810     }
1811 
1812     /**
1813      * @dev Leaves the contract without owner. It will not be possible to call
1814      * `onlyOwner` functions anymore. Can only be called by the current owner.
1815      *
1816      * NOTE: Renouncing ownership will leave the contract without an owner,
1817      * thereby removing any functionality that is only available to the owner.
1818      */
1819     function renounceOwnership() public virtual onlyOwner {
1820         _transferOwnership(address(0));
1821     }
1822 
1823     /**
1824      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1825      * Can only be called by the current owner.
1826      */
1827     function transferOwnership(address newOwner) public virtual onlyOwner {
1828         require(newOwner != address(0), "Ownable: new owner is the zero address");
1829         _transferOwnership(newOwner);
1830     }
1831 
1832     /**
1833      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1834      * Internal function without access restriction.
1835      */
1836     function _transferOwnership(address newOwner) internal virtual {
1837         address oldOwner = _owner;
1838         _owner = newOwner;
1839         emit OwnershipTransferred(oldOwner, newOwner);
1840     }
1841 }
1842 
1843 // File: @openzeppelin/contracts/access/IAccessControl.sol
1844 
1845 
1846 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1847 
1848 pragma solidity ^0.8.0;
1849 
1850 /**
1851  * @dev External interface of AccessControl declared to support ERC165 detection.
1852  */
1853 interface IAccessControl {
1854     /**
1855      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1856      *
1857      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1858      * {RoleAdminChanged} not being emitted signaling this.
1859      *
1860      * _Available since v3.1._
1861      */
1862     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1863 
1864     /**
1865      * @dev Emitted when `account` is granted `role`.
1866      *
1867      * `sender` is the account that originated the contract call, an admin role
1868      * bearer except when using {AccessControl-_setupRole}.
1869      */
1870     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1871 
1872     /**
1873      * @dev Emitted when `account` is revoked `role`.
1874      *
1875      * `sender` is the account that originated the contract call:
1876      *   - if using `revokeRole`, it is the admin role bearer
1877      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1878      */
1879     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1880 
1881     /**
1882      * @dev Returns `true` if `account` has been granted `role`.
1883      */
1884     function hasRole(bytes32 role, address account) external view returns (bool);
1885 
1886     /**
1887      * @dev Returns the admin role that controls `role`. See {grantRole} and
1888      * {revokeRole}.
1889      *
1890      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1891      */
1892     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1893 
1894     /**
1895      * @dev Grants `role` to `account`.
1896      *
1897      * If `account` had not been already granted `role`, emits a {RoleGranted}
1898      * event.
1899      *
1900      * Requirements:
1901      *
1902      * - the caller must have ``role``'s admin role.
1903      */
1904     function grantRole(bytes32 role, address account) external;
1905 
1906     /**
1907      * @dev Revokes `role` from `account`.
1908      *
1909      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1910      *
1911      * Requirements:
1912      *
1913      * - the caller must have ``role``'s admin role.
1914      */
1915     function revokeRole(bytes32 role, address account) external;
1916 
1917     /**
1918      * @dev Revokes `role` from the calling account.
1919      *
1920      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1921      * purpose is to provide a mechanism for accounts to lose their privileges
1922      * if they are compromised (such as when a trusted device is misplaced).
1923      *
1924      * If the calling account had been granted `role`, emits a {RoleRevoked}
1925      * event.
1926      *
1927      * Requirements:
1928      *
1929      * - the caller must be `account`.
1930      */
1931     function renounceRole(bytes32 role, address account) external;
1932 }
1933 
1934 // File: @openzeppelin/contracts/access/AccessControl.sol
1935 
1936 
1937 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1938 
1939 pragma solidity ^0.8.0;
1940 
1941 
1942 
1943 
1944 
1945 /**
1946  * @dev Contract module that allows children to implement role-based access
1947  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1948  * members except through off-chain means by accessing the contract event logs. Some
1949  * applications may benefit from on-chain enumerability, for those cases see
1950  * {AccessControlEnumerable}.
1951  *
1952  * Roles are referred to by their `bytes32` identifier. These should be exposed
1953  * in the external API and be unique. The best way to achieve this is by
1954  * using `public constant` hash digests:
1955  *
1956  * ```
1957  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1958  * ```
1959  *
1960  * Roles can be used to represent a set of permissions. To restrict access to a
1961  * function call, use {hasRole}:
1962  *
1963  * ```
1964  * function foo() public {
1965  *     require(hasRole(MY_ROLE, msg.sender));
1966  *     ...
1967  * }
1968  * ```
1969  *
1970  * Roles can be granted and revoked dynamically via the {grantRole} and
1971  * {revokeRole} functions. Each role has an associated admin role, and only
1972  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1973  *
1974  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1975  * that only accounts with this role will be able to grant or revoke other
1976  * roles. More complex role relationships can be created by using
1977  * {_setRoleAdmin}.
1978  *
1979  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1980  * grant and revoke this role. Extra precautions should be taken to secure
1981  * accounts that have been granted it.
1982  */
1983 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1984     struct RoleData {
1985         mapping(address => bool) members;
1986         bytes32 adminRole;
1987     }
1988 
1989     mapping(bytes32 => RoleData) private _roles;
1990 
1991     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1992 
1993     /**
1994      * @dev Modifier that checks that an account has a specific role. Reverts
1995      * with a standardized message including the required role.
1996      *
1997      * The format of the revert reason is given by the following regular expression:
1998      *
1999      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2000      *
2001      * _Available since v4.1._
2002      */
2003     modifier onlyRole(bytes32 role) {
2004         _checkRole(role);
2005         _;
2006     }
2007 
2008     /**
2009      * @dev See {IERC165-supportsInterface}.
2010      */
2011     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2012         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2013     }
2014 
2015     /**
2016      * @dev Returns `true` if `account` has been granted `role`.
2017      */
2018     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
2019         return _roles[role].members[account];
2020     }
2021 
2022     /**
2023      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2024      * Overriding this function changes the behavior of the {onlyRole} modifier.
2025      *
2026      * Format of the revert message is described in {_checkRole}.
2027      *
2028      * _Available since v4.6._
2029      */
2030     function _checkRole(bytes32 role) internal view virtual {
2031         _checkRole(role, _msgSender());
2032     }
2033 
2034     /**
2035      * @dev Revert with a standard message if `account` is missing `role`.
2036      *
2037      * The format of the revert reason is given by the following regular expression:
2038      *
2039      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2040      */
2041     function _checkRole(bytes32 role, address account) internal view virtual {
2042         if (!hasRole(role, account)) {
2043             revert(
2044                 string(
2045                     abi.encodePacked(
2046                         "AccessControl: account ",
2047                         Strings.toHexString(uint160(account), 20),
2048                         " is missing role ",
2049                         Strings.toHexString(uint256(role), 32)
2050                     )
2051                 )
2052             );
2053         }
2054     }
2055 
2056     /**
2057      * @dev Returns the admin role that controls `role`. See {grantRole} and
2058      * {revokeRole}.
2059      *
2060      * To change a role's admin, use {_setRoleAdmin}.
2061      */
2062     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
2063         return _roles[role].adminRole;
2064     }
2065 
2066     /**
2067      * @dev Grants `role` to `account`.
2068      *
2069      * If `account` had not been already granted `role`, emits a {RoleGranted}
2070      * event.
2071      *
2072      * Requirements:
2073      *
2074      * - the caller must have ``role``'s admin role.
2075      *
2076      * May emit a {RoleGranted} event.
2077      */
2078     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2079         _grantRole(role, account);
2080     }
2081 
2082     /**
2083      * @dev Revokes `role` from `account`.
2084      *
2085      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2086      *
2087      * Requirements:
2088      *
2089      * - the caller must have ``role``'s admin role.
2090      *
2091      * May emit a {RoleRevoked} event.
2092      */
2093     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2094         _revokeRole(role, account);
2095     }
2096 
2097     /**
2098      * @dev Revokes `role` from the calling account.
2099      *
2100      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2101      * purpose is to provide a mechanism for accounts to lose their privileges
2102      * if they are compromised (such as when a trusted device is misplaced).
2103      *
2104      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2105      * event.
2106      *
2107      * Requirements:
2108      *
2109      * - the caller must be `account`.
2110      *
2111      * May emit a {RoleRevoked} event.
2112      */
2113     function renounceRole(bytes32 role, address account) public virtual override {
2114         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2115 
2116         _revokeRole(role, account);
2117     }
2118 
2119     /**
2120      * @dev Grants `role` to `account`.
2121      *
2122      * If `account` had not been already granted `role`, emits a {RoleGranted}
2123      * event. Note that unlike {grantRole}, this function doesn't perform any
2124      * checks on the calling account.
2125      *
2126      * May emit a {RoleGranted} event.
2127      *
2128      * [WARNING]
2129      * ====
2130      * This function should only be called from the constructor when setting
2131      * up the initial roles for the system.
2132      *
2133      * Using this function in any other way is effectively circumventing the admin
2134      * system imposed by {AccessControl}.
2135      * ====
2136      *
2137      * NOTE: This function is deprecated in favor of {_grantRole}.
2138      */
2139     function _setupRole(bytes32 role, address account) internal virtual {
2140         _grantRole(role, account);
2141     }
2142 
2143     /**
2144      * @dev Sets `adminRole` as ``role``'s admin role.
2145      *
2146      * Emits a {RoleAdminChanged} event.
2147      */
2148     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2149         bytes32 previousAdminRole = getRoleAdmin(role);
2150         _roles[role].adminRole = adminRole;
2151         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2152     }
2153 
2154     /**
2155      * @dev Grants `role` to `account`.
2156      *
2157      * Internal function without access restriction.
2158      *
2159      * May emit a {RoleGranted} event.
2160      */
2161     function _grantRole(bytes32 role, address account) internal virtual {
2162         if (!hasRole(role, account)) {
2163             _roles[role].members[account] = true;
2164             emit RoleGranted(role, account, _msgSender());
2165         }
2166     }
2167 
2168     /**
2169      * @dev Revokes `role` from `account`.
2170      *
2171      * Internal function without access restriction.
2172      *
2173      * May emit a {RoleRevoked} event.
2174      */
2175     function _revokeRole(bytes32 role, address account) internal virtual {
2176         if (hasRole(role, account)) {
2177             _roles[role].members[account] = false;
2178             emit RoleRevoked(role, account, _msgSender());
2179         }
2180     }
2181 }
2182 
2183 // File: base64-sol/base64.sol
2184 
2185 
2186 
2187 pragma solidity >=0.6.0;
2188 
2189 /// @title Base64
2190 /// @author Brecht Devos - <brecht@loopring.org>
2191 /// @notice Provides functions for encoding/decoding base64
2192 library Base64 {
2193     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
2194     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
2195                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
2196                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
2197                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
2198 
2199     function encode(bytes memory data) internal pure returns (string memory) {
2200         if (data.length == 0) return '';
2201 
2202         // load the table into memory
2203         string memory table = TABLE_ENCODE;
2204 
2205         // multiply by 4/3 rounded up
2206         uint256 encodedLen = 4 * ((data.length + 2) / 3);
2207 
2208         // add some extra buffer at the end required for the writing
2209         string memory result = new string(encodedLen + 32);
2210 
2211         assembly {
2212             // set the actual output length
2213             mstore(result, encodedLen)
2214 
2215             // prepare the lookup table
2216             let tablePtr := add(table, 1)
2217 
2218             // input ptr
2219             let dataPtr := data
2220             let endPtr := add(dataPtr, mload(data))
2221 
2222             // result ptr, jump over length
2223             let resultPtr := add(result, 32)
2224 
2225             // run over the input, 3 bytes at a time
2226             for {} lt(dataPtr, endPtr) {}
2227             {
2228                 // read 3 bytes
2229                 dataPtr := add(dataPtr, 3)
2230                 let input := mload(dataPtr)
2231 
2232                 // write 4 characters
2233                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
2234                 resultPtr := add(resultPtr, 1)
2235                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
2236                 resultPtr := add(resultPtr, 1)
2237                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
2238                 resultPtr := add(resultPtr, 1)
2239                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
2240                 resultPtr := add(resultPtr, 1)
2241             }
2242 
2243             // padding with '='
2244             switch mod(mload(data), 3)
2245             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
2246             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
2247         }
2248 
2249         return result;
2250     }
2251 
2252     function decode(string memory _data) internal pure returns (bytes memory) {
2253         bytes memory data = bytes(_data);
2254 
2255         if (data.length == 0) return new bytes(0);
2256         require(data.length % 4 == 0, "invalid base64 decoder input");
2257 
2258         // load the table into memory
2259         bytes memory table = TABLE_DECODE;
2260 
2261         // every 4 characters represent 3 bytes
2262         uint256 decodedLen = (data.length / 4) * 3;
2263 
2264         // add some extra buffer at the end required for the writing
2265         bytes memory result = new bytes(decodedLen + 32);
2266 
2267         assembly {
2268             // padding with '='
2269             let lastBytes := mload(add(data, mload(data)))
2270             if eq(and(lastBytes, 0xFF), 0x3d) {
2271                 decodedLen := sub(decodedLen, 1)
2272                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
2273                     decodedLen := sub(decodedLen, 1)
2274                 }
2275             }
2276 
2277             // set the actual output length
2278             mstore(result, decodedLen)
2279 
2280             // prepare the lookup table
2281             let tablePtr := add(table, 1)
2282 
2283             // input ptr
2284             let dataPtr := data
2285             let endPtr := add(dataPtr, mload(data))
2286 
2287             // result ptr, jump over length
2288             let resultPtr := add(result, 32)
2289 
2290             // run over the input, 4 characters at a time
2291             for {} lt(dataPtr, endPtr) {}
2292             {
2293                // read 4 characters
2294                dataPtr := add(dataPtr, 4)
2295                let input := mload(dataPtr)
2296 
2297                // write 3 bytes
2298                let output := add(
2299                    add(
2300                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
2301                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
2302                    add(
2303                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
2304                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
2305                     )
2306                 )
2307                 mstore(resultPtr, shl(232, output))
2308                 resultPtr := add(resultPtr, 3)
2309             }
2310         }
2311 
2312         return result;
2313     }
2314 }
2315 
2316 // File: frekou_poap.sol
2317 
2318 
2319 // Copyright (c) 2022 Keisuke OHNO
2320 
2321 /*
2322 
2323 Permission is hereby granted, free of charge, to any person obtaining a copy
2324 of this software and associated documentation files (the "Software"), to deal
2325 in the Software without restriction, including without limitation the rights
2326 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
2327 copies of the Software, and to permit persons to whom the Software is
2328 furnished to do so, subject to the following conditions:
2329 
2330 The above copyright notice and this permission notice shall be included in all
2331 copies or substantial portions of the Software.
2332 
2333 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
2334 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
2335 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
2336 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
2337 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
2338 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
2339 SOFTWARE.
2340 
2341 */
2342 
2343 pragma solidity >=0.7.0 <0.9.0;
2344 
2345 
2346 
2347 
2348 
2349 
2350 
2351 
2352 //tokenURI interface
2353 interface iTokenURI {
2354     function tokenURI(uint256 _tokenId) external view returns (string memory);
2355 }
2356 
2357 contract NFTSeminarFromZeroPOAP is ERC721A, Ownable, AccessControl{
2358 
2359     constructor(
2360     ) ERC721A("NFTSeminarFromZeroPOAP", "NSP") {
2361         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2362         _setupRole(AIRDROP_ROLE      , msg.sender);
2363 
2364         setImageURI("ipfs://QmQ2nUVxghV8zpUdWgZE52t9yHaiwELLznkf2VrB7hXHRg/poap.png");
2365         setUseSingleMetadata(true);
2366         setMetadataTitle("NFT seminar from ZERO. October 6, 2022, POAP");
2367         setMetadataDescription("Thank you for coming to the NFT seminar from ZERO. October 6, 2022.");
2368         setMetadataAttributes("POAP");
2369         setIsSBT(true);
2370         setMerkleRoot(0x7d503a54d1a480fe7c19ba9dc5abb95f8ac86d308e1184e95a0f1c7275253840);
2371         _safeMint(0xdEcf4B112d4120B6998e5020a6B4819E490F7db6, 1);//atode kesu
2372     }
2373 
2374 
2375     //
2376     //withdraw section
2377     //
2378 
2379     address public constant withdrawAddress = 0xdEcf4B112d4120B6998e5020a6B4819E490F7db6;
2380 
2381     function withdraw() public onlyOwner {
2382         (bool os, ) = payable(withdrawAddress).call{value: address(this).balance}('');
2383         require(os);
2384     }
2385 
2386 
2387     //
2388     //mint section
2389     //
2390 
2391     uint256 public cost = 0;
2392     uint256 public maxSupply = 600;
2393     uint256 public maxMintAmountPerTransaction = 1;
2394     bool public paused = true;
2395     bool public onlyWhitelisted = true;
2396     bool public mintCount = true;
2397     mapping(address => uint256) public whitelistMintedAmount;
2398     mapping(address => uint256) public publicSaleMintedAmount;
2399     bytes32 public constant AIRDROP_ROLE = keccak256("AIRDROP_ROLE");
2400 
2401     modifier callerIsUser() {
2402         require(tx.origin == msg.sender, "The caller is another contract.");
2403         _;
2404     }
2405 
2406 
2407  
2408     //mint with merkle tree
2409     bytes32 public merkleRoot;
2410     function mint(uint256 _mintAmount , uint256 _maxMintAmount , bytes32[] calldata _merkleProof) public payable callerIsUser{
2411         require(!paused, "the contract is paused");
2412         require(0 < _mintAmount, "need to mint at least 1 NFT");
2413         require(_mintAmount <= maxMintAmountPerTransaction, "max mint amount per session exceeded");
2414         require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
2415         require(cost * _mintAmount <= msg.value, "insufficient funds");
2416         if(onlyWhitelisted == true) {
2417             bytes32 leaf = keccak256( abi.encodePacked(msg.sender, _maxMintAmount) );
2418             require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "user is not whitelisted");
2419             if(mintCount == true){
2420                 require(_mintAmount <= _maxMintAmount - whitelistMintedAmount[msg.sender] , "max NFT per address exceeded");
2421                 whitelistMintedAmount[msg.sender] += _mintAmount;
2422             }
2423         }else{
2424             if(mintCount == true){
2425                 publicSaleMintedAmount[msg.sender] += _mintAmount;
2426             }
2427         }
2428         _safeMint(msg.sender, _mintAmount);
2429     }
2430 
2431     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2432         merkleRoot = _merkleRoot;
2433     }
2434 
2435 
2436 
2437 
2438 /*
2439     //mint with mapping
2440     mapping(address => uint256) public whitelistUserAmount;
2441     function mint(uint256 _mintAmount ) public payable callerIsUser{
2442         require(!paused, "the contract is paused");
2443         require(0 < _mintAmount, "need to mint at least 1 NFT");
2444         require(_mintAmount <= maxMintAmountPerTransaction, "max mint amount per session exceeded");
2445         require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
2446         require(cost * _mintAmount <= msg.value, "insufficient funds");
2447         if(onlyWhitelisted == true) {
2448             require( whitelistUserAmount[msg.sender] != 0 , "user is not whitelisted");
2449             if(mintCount == true){
2450                 require(_mintAmount <= whitelistUserAmount[msg.sender] - whitelistMintedAmount[msg.sender] , "max NFT per address exceeded");
2451                 whitelistMintedAmount[msg.sender] += _mintAmount;
2452             }
2453         }else{
2454             if(mintCount == true){
2455                 publicSaleMintedAmount[msg.sender] += _mintAmount;
2456             }
2457         }
2458         _safeMint(msg.sender, _mintAmount);
2459     }
2460 
2461     function setWhitelist(address[] memory addresses, uint256[] memory saleSupplies) public onlyOwner {
2462         require(addresses.length == saleSupplies.length);
2463         for (uint256 i = 0; i < addresses.length; i++) {
2464             whitelistUserAmount[addresses[i]] = saleSupplies[i];
2465         }
2466     }    
2467 
2468 */
2469 
2470 
2471 
2472     function airdropMint(address[] calldata _airdropAddresses , uint256[] memory _UserMintAmount) public {
2473         require(hasRole(AIRDROP_ROLE, msg.sender), "Caller is not a air dropper");
2474         uint256 _mintAmount = 0;
2475         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
2476             _mintAmount += _UserMintAmount[i];
2477         }
2478         require(0 < _mintAmount , "need to mint at least 1 NFT");
2479         require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
2480         for (uint256 i = 0; i < _UserMintAmount.length; i++) {
2481             _safeMint(_airdropAddresses[i], _UserMintAmount[i] );
2482         }
2483     }
2484 
2485     function setMaxSupply(uint256 _maxSupply) public onlyOwner() {
2486         maxSupply = _maxSupply;
2487     }
2488 
2489     function setCost(uint256 _newCost) public onlyOwner {
2490         cost = _newCost;
2491     }
2492 
2493     function setOnlyWhitelisted(bool _state) public onlyOwner {
2494         onlyWhitelisted = _state;
2495     }
2496 
2497     function setMaxMintAmountPerTransaction(uint256 _maxMintAmountPerTransaction) public onlyOwner {
2498         maxMintAmountPerTransaction = _maxMintAmountPerTransaction;
2499     }
2500   
2501     function pause(bool _state) public onlyOwner {
2502         paused = _state;
2503     }
2504 
2505     function setMintCount(bool _state) public onlyOwner {
2506         mintCount = _state;
2507     }
2508  
2509 
2510 
2511     //
2512     //URI section
2513     //
2514 
2515     iTokenURI public interfaceOfTokenURI;
2516     bool public useInterfaceMetadata = false;
2517     bool public useSingleMetadata = false;
2518     string public imageURI;
2519     string public baseURI;
2520     string public baseExtension = ".json";
2521     string public metadataTitle;
2522     string public metadataDescription;
2523     string public metadataAttributes;
2524 
2525     function _baseURI() internal view virtual override returns (string memory) {
2526         return baseURI;        
2527     }
2528 
2529     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2530         baseURI = _newBaseURI;
2531     }
2532 
2533     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
2534         baseExtension = _newBaseExtension;
2535     }
2536 
2537     function _imageURI() internal view returns (string memory) {
2538         return imageURI;        
2539     }
2540 
2541     function setMetadataTitle(string memory _metadataTitle) public onlyOwner {
2542         metadataTitle = _metadataTitle;
2543     }
2544     function setMetadataDescription(string memory _metadataDescription) public onlyOwner {
2545         metadataDescription = _metadataDescription;
2546     }
2547     function setMetadataAttributes(string memory _metadataAttributes) public onlyOwner {
2548         metadataAttributes = _metadataAttributes;
2549     }
2550 
2551     function setImageURI(string memory _newImageURI) public onlyOwner {
2552         imageURI = _newImageURI;
2553     }
2554 
2555     function setInterfaceOfTokenURI(address _address) public onlyOwner() {
2556         interfaceOfTokenURI = iTokenURI(_address);
2557     }
2558 
2559     function setUseInterfaceMetadata(bool _useInterfaceMetadata) public onlyOwner() {
2560         useInterfaceMetadata = _useInterfaceMetadata;
2561     }
2562 
2563     function setUseSingleMetadata(bool _useSingleMetadata) public onlyOwner() {
2564         useSingleMetadata = _useSingleMetadata;
2565     }
2566 
2567     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2568         if (useInterfaceMetadata == true) {
2569             return interfaceOfTokenURI.tokenURI(tokenId);
2570         } else if (useSingleMetadata == true){
2571             return string( abi.encodePacked( 'data:application/json;base64,' , Base64.encode(bytes(encodePackedJson())) ) );
2572         } else {
2573             return string(abi.encodePacked(ERC721A.tokenURI(tokenId), baseExtension));
2574         }
2575     }
2576 
2577     function encodePackedJson() public view returns (bytes memory) {
2578         return abi.encodePacked(
2579             '{'
2580                 '"name":"' , metadataTitle ,'",' ,
2581                 '"description":"' , metadataDescription ,  '",' ,
2582                 '"image": "' , _imageURI() , '",' ,
2583                 '"attributes":[{"trait_type":"type","value":"' , metadataAttributes , '"}]',
2584             '}'
2585         );
2586     }
2587 
2588 
2589 
2590     function _startTokenId() internal view virtual override returns (uint256) {
2591         return 1;
2592     }
2593 
2594 
2595 
2596 
2597     //
2598     //viewer section
2599     //
2600 
2601     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
2602         unchecked {
2603             uint256 tokenIdsIdx;
2604             address currOwnershipAddr;
2605             uint256 tokenIdsLength = balanceOf(owner);
2606             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2607             TokenOwnership memory ownership;
2608             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2609                 ownership = _ownershipAt(i);
2610                 if (ownership.burned) {
2611                     continue;
2612                 }
2613                 if (ownership.addr != address(0)) {
2614                     currOwnershipAddr = ownership.addr;
2615                 }
2616                 if (currOwnershipAddr == owner) {
2617                     tokenIds[tokenIdsIdx++] = i;
2618                 }
2619             }
2620             return tokenIds;
2621         }
2622     }
2623 
2624 
2625 
2626     //
2627     //sbt section
2628     //
2629 
2630     bool public isSBT = false;
2631 
2632     function setIsSBT(bool _state) public onlyOwner {
2633         isSBT = _state;
2634     }
2635 
2636     function _sbt() internal view returns (bool) {
2637         return isSBT;
2638     }    
2639 
2640     function _beforeTokenTransfers( address from, address to, uint256 startTokenId, uint256 quantity) internal virtual override{
2641         require( _sbt() == false || from == address(0), "transfer is prohibited");
2642         super._beforeTokenTransfers(from, to, startTokenId, quantity);
2643     }
2644 
2645     function setApprovalForAll(address operator, bool approved) public virtual override {
2646         require( _sbt() == false , "setApprovalForAll is prohibited");
2647         super.setApprovalForAll(operator, approved);
2648     }
2649 
2650     function approve(address to, uint256 tokenId) public payable virtual override {
2651         require( _sbt() == false , "approve is prohibited");
2652         super.approve(to, tokenId);
2653     }
2654 
2655 
2656 
2657     //
2658     //override
2659     //
2660 
2661     function supportsInterface(bytes4 interfaceId) public view override(ERC721A, AccessControl) returns (bool) {
2662         return super.supportsInterface(interfaceId);
2663     }
2664 
2665 }