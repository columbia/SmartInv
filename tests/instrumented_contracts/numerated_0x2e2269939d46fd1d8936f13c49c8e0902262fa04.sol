1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 
5 pragma solidity >=0.7.0 <0.9.0;
6 
7 /**
8  * @dev Interface of ERC721A.
9  */
10 interface IERC721A {
11     /**
12      * The caller must own the token or be an approved operator.
13      */
14     error ApprovalCallerNotOwnerNorApproved();
15 
16     /**
17      * The token does not exist.
18      */
19     error ApprovalQueryForNonexistentToken();
20 
21     /**
22      * The caller cannot approve to their own address.
23      */
24     error ApproveToCaller();
25 
26     /**
27      * Cannot query the balance for the zero address.
28      */
29     error BalanceQueryForZeroAddress();
30 
31     /**
32      * Cannot mint to the zero address.
33      */
34     error MintToZeroAddress();
35 
36     /**
37      * The quantity of tokens minted must be more than zero.
38      */
39     error MintZeroQuantity();
40 
41     /**
42      * The token does not exist.
43      */
44     error OwnerQueryForNonexistentToken();
45 
46     /**
47      * The caller must own the token or be an approved operator.
48      */
49     error TransferCallerNotOwnerNorApproved();
50 
51     /**
52      * The token must be owned by `from`.
53      */
54     error TransferFromIncorrectOwner();
55 
56     /**
57      * Cannot safely transfer to a contract that does not implement the
58      * ERC721Receiver interface.
59      */
60     error TransferToNonERC721ReceiverImplementer();
61 
62     /**
63      * Cannot transfer to the zero address.
64      */
65     error TransferToZeroAddress();
66 
67     /**
68      * The token does not exist.
69      */
70     error URIQueryForNonexistentToken();
71 
72     /**
73      * The `quantity` minted with ERC2309 exceeds the safety limit.
74      */
75     error MintERC2309QuantityExceedsLimit();
76 
77     /**
78      * The `extraData` cannot be set on an unintialized ownership slot.
79      */
80     error OwnershipNotInitializedForExtraData();
81 
82     // =============================================================
83     //                            STRUCTS
84     // =============================================================
85 
86     struct TokenOwnership {
87         // The address of the owner.
88         address addr;
89         // Stores the start time of ownership with minimal overhead for tokenomics.
90         uint64 startTimestamp;
91         // Whether the token has been burned.
92         bool burned;
93         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
94         uint24 extraData;
95     }
96 
97     // =============================================================
98     //                         TOKEN COUNTERS
99     // =============================================================
100 
101     /**
102      * @dev Returns the total number of tokens in existence.
103      * Burned tokens will reduce the count.
104      * To get the total number of tokens minted, please see {_totalMinted}.
105      */
106     function totalSupply() external view returns (uint256);
107 
108     // =============================================================
109     //                            IERC165
110     // =============================================================
111 
112     /**
113      * @dev Returns true if this contract implements the interface defined by
114      * `interfaceId`. See the corresponding
115      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
116      * to learn more about how these ids are created.
117      *
118      * This function call must use less than 30000 gas.
119      */
120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
121 
122     // =============================================================
123     //                            IERC721
124     // =============================================================
125 
126     /**
127      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
130 
131     /**
132      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
133      */
134     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables or disables
138      * (`approved`) `operator` to manage all of its assets.
139      */
140     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
141 
142     /**
143      * @dev Returns the number of tokens in `owner`'s account.
144      */
145     function balanceOf(address owner) external view returns (uint256 balance);
146 
147     /**
148      * @dev Returns the owner of the `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function ownerOf(uint256 tokenId) external view returns (address owner);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`,
158      * checking first that contract recipients are aware of the ERC721 protocol
159      * to prevent tokens from being forever locked.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be have been allowed to move
167      * this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement
169      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId,
177         bytes calldata data
178     ) external;
179 
180     /**
181      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) external;
188 
189     /**
190      * @dev Transfers `tokenId` from `from` to `to`.
191      *
192      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
193      * whenever possible.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token
201      * by either {approve} or {setApprovalForAll}.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
213      * The approval is cleared when the token is transferred.
214      *
215      * Only a single account can be approved at a time, so approving the
216      * zero address clears previous approvals.
217      *
218      * Requirements:
219      *
220      * - The caller must own the token or be an approved operator.
221      * - `tokenId` must exist.
222      *
223      * Emits an {Approval} event.
224      */
225     function approve(address to, uint256 tokenId) external;
226 
227     /**
228      * @dev Approve or remove `operator` as an operator for the caller.
229      * Operators can call {transferFrom} or {safeTransferFrom}
230      * for any token owned by the caller.
231      *
232      * Requirements:
233      *
234      * - The `operator` cannot be the caller.
235      *
236      * Emits an {ApprovalForAll} event.
237      */
238     function setApprovalForAll(address operator, bool _approved) external;
239 
240     /**
241      * @dev Returns the account approved for `tokenId` token.
242      *
243      * Requirements:
244      *
245      * - `tokenId` must exist.
246      */
247     function getApproved(uint256 tokenId) external view returns (address operator);
248 
249     /**
250      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
251      *
252      * See {setApprovalForAll}.
253      */
254     function isApprovedForAll(address owner, address operator) external view returns (bool);
255 
256     // =============================================================
257     //                        IERC721Metadata
258     // =============================================================
259 
260     /**
261      * @dev Returns the token collection name.
262      */
263     function name() external view returns (string memory);
264 
265     /**
266      * @dev Returns the token collection symbol.
267      */
268     function symbol() external view returns (string memory);
269 
270     /**
271      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
272      */
273     function tokenURI(uint256 tokenId) external view returns (string memory);
274 
275     // =============================================================
276     //                           IERC2309
277     // =============================================================
278 
279     /**
280      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
281      * (inclusive) is transferred from `from` to `to`, as defined in the
282      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
283      *
284      * See {_mintERC2309} for more details.
285      */
286     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
287 }
288 
289 /**
290  * @dev Interface of ERC721 token receiver.
291  */
292 interface ERC721A__IERC721Receiver {
293     function onERC721Received(
294         address operator,
295         address from,
296         uint256 tokenId,
297         bytes calldata data
298     ) external returns (bytes4);
299 }
300 
301 /**
302  * @title ERC721A
303  *
304  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
305  * Non-Fungible Token Standard, including the Metadata extension.
306  * Optimized for lower gas during batch mints.
307  *
308  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
309  * starting from `_startTokenId()`.
310  *
311  * Assumptions:
312  *
313  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
314  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
315  */
316 contract ERC721A is IERC721A {
317     // Reference type for token approval.
318     struct TokenApprovalRef {
319         address value;
320     }
321 
322     // =============================================================
323     //                           CONSTANTS
324     // =============================================================
325 
326     // Mask of an entry in packed address data.
327     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
328 
329     // The bit position of `numberMinted` in packed address data.
330     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
331 
332     // The bit position of `numberBurned` in packed address data.
333     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
334 
335     // The bit position of `aux` in packed address data.
336     uint256 private constant _BITPOS_AUX = 192;
337 
338     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
339     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
340 
341     // The bit position of `startTimestamp` in packed ownership.
342     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
343 
344     // The bit mask of the `burned` bit in packed ownership.
345     uint256 private constant _BITMASK_BURNED = 1 << 224;
346 
347     // The bit position of the `nextInitialized` bit in packed ownership.
348     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
349 
350     // The bit mask of the `nextInitialized` bit in packed ownership.
351     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
352 
353     // The bit position of `extraData` in packed ownership.
354     uint256 private constant _BITPOS_EXTRA_DATA = 232;
355 
356     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
357     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
358 
359     // The mask of the lower 160 bits for addresses.
360     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
361 
362     // The maximum `quantity` that can be minted with {_mintERC2309}.
363     // This limit is to prevent overflows on the address data entries.
364     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
365     // is required to cause an overflow, which is unrealistic.
366     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
367 
368     // The `Transfer` event signature is given by:
369     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
370     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
371         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
372 
373     // =============================================================
374     //                            STORAGE
375     // =============================================================
376 
377     // The next token ID to be minted.
378     uint256 private _currentIndex;
379 
380     // The number of tokens burned.
381     uint256 private _burnCounter;
382 
383     // Token name
384     string private _name;
385 
386     // Token symbol
387     string private _symbol;
388 
389     // Mapping from token ID to ownership details
390     // An empty struct value does not necessarily mean the token is unowned.
391     // See {_packedOwnershipOf} implementation for details.
392     //
393     // Bits Layout:
394     // - [0..159]   `addr`
395     // - [160..223] `startTimestamp`
396     // - [224]      `burned`
397     // - [225]      `nextInitialized`
398     // - [232..255] `extraData`
399     mapping(uint256 => uint256) private _packedOwnerships;
400 
401     // Mapping owner address to address data.
402     //
403     // Bits Layout:
404     // - [0..63]    `balance`
405     // - [64..127]  `numberMinted`
406     // - [128..191] `numberBurned`
407     // - [192..255] `aux`
408     mapping(address => uint256) private _packedAddressData;
409 
410     // Mapping from token ID to approved address.
411     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
412 
413     // Mapping from owner to operator approvals
414     mapping(address => mapping(address => bool)) private _operatorApprovals;
415 
416     // =============================================================
417     //                          CONSTRUCTOR
418     // =============================================================
419 
420     constructor(string memory name_, string memory symbol_) {
421         _name = name_;
422         _symbol = symbol_;
423         _currentIndex = _startTokenId();
424     }
425 
426     // =============================================================
427     //                   TOKEN COUNTING OPERATIONS
428     // =============================================================
429 
430     /**
431      * @dev Returns the starting token ID.
432      * To change the starting token ID, please override this function.
433      */
434     function _startTokenId() internal view virtual returns (uint256) {
435         return 0;
436     }
437 
438     /**
439      * @dev Returns the next token ID to be minted.
440      */
441     function _nextTokenId() internal view virtual returns (uint256) {
442         return _currentIndex;
443     }
444 
445     /**
446      * @dev Returns the total number of tokens in existence.
447      * Burned tokens will reduce the count.
448      * To get the total number of tokens minted, please see {_totalMinted}.
449      */
450     function totalSupply() public view virtual override returns (uint256) {
451         // Counter underflow is impossible as _burnCounter cannot be incremented
452         // more than `_currentIndex - _startTokenId()` times.
453         unchecked {
454             return _currentIndex - _burnCounter - _startTokenId();
455         }
456     }
457 
458     /**
459      * @dev Returns the total amount of tokens minted in the contract.
460      */
461     function _totalMinted() internal view virtual returns (uint256) {
462         // Counter underflow is impossible as `_currentIndex` does not decrement,
463         // and it is initialized to `_startTokenId()`.
464         unchecked {
465             return _currentIndex - _startTokenId();
466         }
467     }
468 
469     /**
470      * @dev Returns the total number of tokens burned.
471      */
472     function _totalBurned() internal view virtual returns (uint256) {
473         return _burnCounter;
474     }
475 
476     // =============================================================
477     //                    ADDRESS DATA OPERATIONS
478     // =============================================================
479 
480     /**
481      * @dev Returns the number of tokens in `owner`'s account.
482      */
483     function balanceOf(address owner) public view virtual override returns (uint256) {
484         if (owner == address(0)) revert BalanceQueryForZeroAddress();
485         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
486     }
487 
488     /**
489      * Returns the number of tokens minted by `owner`.
490      */
491     function _numberMinted(address owner) internal view returns (uint256) {
492         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
493     }
494 
495     /**
496      * Returns the number of tokens burned by or on behalf of `owner`.
497      */
498     function _numberBurned(address owner) internal view returns (uint256) {
499         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
500     }
501 
502     /**
503      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
504      */
505     function _getAux(address owner) internal view returns (uint64) {
506         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
507     }
508 
509     /**
510      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
511      * If there are multiple variables, please pack them into a uint64.
512      */
513     function _setAux(address owner, uint64 aux) internal virtual {
514         uint256 packed = _packedAddressData[owner];
515         uint256 auxCasted;
516         // Cast `aux` with assembly to avoid redundant masking.
517         assembly {
518             auxCasted := aux
519         }
520         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
521         _packedAddressData[owner] = packed;
522     }
523 
524     // =============================================================
525     //                            IERC165
526     // =============================================================
527 
528     /**
529      * @dev Returns true if this contract implements the interface defined by
530      * `interfaceId`. See the corresponding
531      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
532      * to learn more about how these ids are created.
533      *
534      * This function call must use less than 30000 gas.
535      */
536     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537         // The interface IDs are constants representing the first 4 bytes
538         // of the XOR of all function selectors in the interface.
539         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
540         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
541         return
542             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
543             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
544             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
545     }
546 
547     // =============================================================
548     //                        IERC721Metadata
549     // =============================================================
550 
551     /**
552      * @dev Returns the token collection name.
553      */
554     function name() public view virtual override returns (string memory) {
555         return _name;
556     }
557 
558     /**
559      * @dev Returns the token collection symbol.
560      */
561     function symbol() public view virtual override returns (string memory) {
562         return _symbol;
563     }
564 
565     /**
566      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
567      */
568     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
569         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
570 
571         string memory baseURI = _baseURI();
572         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
573     }
574 
575     /**
576      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
577      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
578      * by default, it can be overridden in child contracts.
579      */
580     function _baseURI() internal view virtual returns (string memory) {
581         return '';
582     }
583 
584     // =============================================================
585     //                     OWNERSHIPS OPERATIONS
586     // =============================================================
587 
588     /**
589      * @dev Returns the owner of the `tokenId` token.
590      *
591      * Requirements:
592      *
593      * - `tokenId` must exist.
594      */
595     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
596         return address(uint160(_packedOwnershipOf(tokenId)));
597     }
598 
599     /**
600      * @dev Gas spent here starts off proportional to the maximum mint batch size.
601      * It gradually moves to O(1) as tokens get transferred around over time.
602      */
603     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
604         return _unpackedOwnership(_packedOwnershipOf(tokenId));
605     }
606 
607     /**
608      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
609      */
610     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
611         return _unpackedOwnership(_packedOwnerships[index]);
612     }
613 
614     /**
615      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
616      */
617     function _initializeOwnershipAt(uint256 index) internal virtual {
618         if (_packedOwnerships[index] == 0) {
619             _packedOwnerships[index] = _packedOwnershipOf(index);
620         }
621     }
622 
623     /**
624      * Returns the packed ownership data of `tokenId`.
625      */
626     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
627         uint256 curr = tokenId;
628 
629         unchecked {
630             if (_startTokenId() <= curr)
631                 if (curr < _currentIndex) {
632                     uint256 packed = _packedOwnerships[curr];
633                     // If not burned.
634                     if (packed & _BITMASK_BURNED == 0) {
635                         // Invariant:
636                         // There will always be an initialized ownership slot
637                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
638                         // before an unintialized ownership slot
639                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
640                         // Hence, `curr` will not underflow.
641                         //
642                         // We can directly compare the packed value.
643                         // If the address is zero, packed will be zero.
644                         while (packed == 0) {
645                             packed = _packedOwnerships[--curr];
646                         }
647                         return packed;
648                     }
649                 }
650         }
651         revert OwnerQueryForNonexistentToken();
652     }
653 
654     /**
655      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
656      */
657     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
658         ownership.addr = address(uint160(packed));
659         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
660         ownership.burned = packed & _BITMASK_BURNED != 0;
661         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
662     }
663 
664     /**
665      * @dev Packs ownership data into a single uint256.
666      */
667     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
668         assembly {
669             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
670             owner := and(owner, _BITMASK_ADDRESS)
671             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
672             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
673         }
674     }
675 
676     /**
677      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
678      */
679     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
680         // For branchless setting of the `nextInitialized` flag.
681         assembly {
682             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
683             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
684         }
685     }
686 
687     // =============================================================
688     //                      APPROVAL OPERATIONS
689     // =============================================================
690 
691     /**
692      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
693      * The approval is cleared when the token is transferred.
694      *
695      * Only a single account can be approved at a time, so approving the
696      * zero address clears previous approvals.
697      *
698      * Requirements:
699      *
700      * - The caller must own the token or be an approved operator.
701      * - `tokenId` must exist.
702      *
703      * Emits an {Approval} event.
704      */
705     function approve(address to, uint256 tokenId) public virtual override {
706         address owner = ownerOf(tokenId);
707 
708         if (_msgSenderERC721A() != owner)
709             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
710                 revert ApprovalCallerNotOwnerNorApproved();
711             }
712 
713         _tokenApprovals[tokenId].value = to;
714         emit Approval(owner, to, tokenId);
715     }
716 
717     /**
718      * @dev Returns the account approved for `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function getApproved(uint256 tokenId) public view virtual override returns (address) {
725         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
726 
727         return _tokenApprovals[tokenId].value;
728     }
729 
730     /**
731      * @dev Approve or remove `operator` as an operator for the caller.
732      * Operators can call {transferFrom} or {safeTransferFrom}
733      * for any token owned by the caller.
734      *
735      * Requirements:
736      *
737      * - The `operator` cannot be the caller.
738      *
739      * Emits an {ApprovalForAll} event.
740      */
741     function setApprovalForAll(address operator, bool approved) public virtual override {
742         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
743 
744         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
745         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
746     }
747 
748     /**
749      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
750      *
751      * See {setApprovalForAll}.
752      */
753     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
754         return _operatorApprovals[owner][operator];
755     }
756 
757     /**
758      * @dev Returns whether `tokenId` exists.
759      *
760      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
761      *
762      * Tokens start existing when they are minted. See {_mint}.
763      */
764     function _exists(uint256 tokenId) internal view virtual returns (bool) {
765         return
766             _startTokenId() <= tokenId &&
767             tokenId < _currentIndex && // If within bounds,
768             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
769     }
770 
771     /**
772      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
773      */
774     function _isSenderApprovedOrOwner(
775         address approvedAddress,
776         address owner,
777         address msgSender
778     ) private pure returns (bool result) {
779         assembly {
780             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
781             owner := and(owner, _BITMASK_ADDRESS)
782             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
783             msgSender := and(msgSender, _BITMASK_ADDRESS)
784             // `msgSender == owner || msgSender == approvedAddress`.
785             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
786         }
787     }
788 
789     /**
790      * @dev Returns the storage slot and value for the approved address of `tokenId`.
791      */
792     function _getApprovedSlotAndAddress(uint256 tokenId)
793         private
794         view
795         returns (uint256 approvedAddressSlot, address approvedAddress)
796     {
797         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
798         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
799         assembly {
800             approvedAddressSlot := tokenApproval.slot
801             approvedAddress := sload(approvedAddressSlot)
802         }
803     }
804 
805     // =============================================================
806     //                      TRANSFER OPERATIONS
807     // =============================================================
808 
809     /**
810      * @dev Transfers `tokenId` from `from` to `to`.
811      *
812      * Requirements:
813      *
814      * - `from` cannot be the zero address.
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must be owned by `from`.
817      * - If the caller is not `from`, it must be approved to move this token
818      * by either {approve} or {setApprovalForAll}.
819      *
820      * Emits a {Transfer} event.
821      */
822     function transferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) public virtual override {
827         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
828 
829         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
830 
831         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
832 
833         // The nested ifs save around 20+ gas over a compound boolean condition.
834         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
835             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
836 
837         if (to == address(0)) revert TransferToZeroAddress();
838 
839         _beforeTokenTransfers(from, to, tokenId, 1);
840 
841         // Clear approvals from the previous owner.
842         assembly {
843             if approvedAddress {
844                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
845                 sstore(approvedAddressSlot, 0)
846             }
847         }
848 
849         // Underflow of the sender's balance is impossible because we check for
850         // ownership above and the recipient's balance can't realistically overflow.
851         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
852         unchecked {
853             // We can directly increment and decrement the balances.
854             --_packedAddressData[from]; // Updates: `balance -= 1`.
855             ++_packedAddressData[to]; // Updates: `balance += 1`.
856 
857             // Updates:
858             // - `address` to the next owner.
859             // - `startTimestamp` to the timestamp of transfering.
860             // - `burned` to `false`.
861             // - `nextInitialized` to `true`.
862             _packedOwnerships[tokenId] = _packOwnershipData(
863                 to,
864                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
865             );
866 
867             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
868             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
869                 uint256 nextTokenId = tokenId + 1;
870                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
871                 if (_packedOwnerships[nextTokenId] == 0) {
872                     // If the next slot is within bounds.
873                     if (nextTokenId != _currentIndex) {
874                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
875                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
876                     }
877                 }
878             }
879         }
880 
881         emit Transfer(from, to, tokenId);
882         _afterTokenTransfers(from, to, tokenId, 1);
883     }
884 
885     /**
886      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         safeTransferFrom(from, to, tokenId, '');
894     }
895 
896     /**
897      * @dev Safely transfers `tokenId` token from `from` to `to`.
898      *
899      * Requirements:
900      *
901      * - `from` cannot be the zero address.
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must exist and be owned by `from`.
904      * - If the caller is not `from`, it must be approved to move this token
905      * by either {approve} or {setApprovalForAll}.
906      * - If `to` refers to a smart contract, it must implement
907      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
908      *
909      * Emits a {Transfer} event.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId,
915         bytes memory _data
916     ) public virtual override {
917         transferFrom(from, to, tokenId);
918         if (to.code.length != 0)
919             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
920                 revert TransferToNonERC721ReceiverImplementer();
921             }
922     }
923 
924     /**
925      * @dev Hook that is called before a set of serially-ordered token IDs
926      * are about to be transferred. This includes minting.
927      * And also called before burning one token.
928      *
929      * `startTokenId` - the first token ID to be transferred.
930      * `quantity` - the amount to be transferred.
931      *
932      * Calling conditions:
933      *
934      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
935      * transferred to `to`.
936      * - When `from` is zero, `tokenId` will be minted for `to`.
937      * - When `to` is zero, `tokenId` will be burned by `from`.
938      * - `from` and `to` are never both zero.
939      */
940     function _beforeTokenTransfers(
941         address from,
942         address to,
943         uint256 startTokenId,
944         uint256 quantity
945     ) internal virtual {}
946 
947     /**
948      * @dev Hook that is called after a set of serially-ordered token IDs
949      * have been transferred. This includes minting.
950      * And also called after one token has been burned.
951      *
952      * `startTokenId` - the first token ID to be transferred.
953      * `quantity` - the amount to be transferred.
954      *
955      * Calling conditions:
956      *
957      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
958      * transferred to `to`.
959      * - When `from` is zero, `tokenId` has been minted for `to`.
960      * - When `to` is zero, `tokenId` has been burned by `from`.
961      * - `from` and `to` are never both zero.
962      */
963     function _afterTokenTransfers(
964         address from,
965         address to,
966         uint256 startTokenId,
967         uint256 quantity
968     ) internal virtual {}
969 
970     /**
971      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
972      *
973      * `from` - Previous owner of the given token ID.
974      * `to` - Target address that will receive the token.
975      * `tokenId` - Token ID to be transferred.
976      * `_data` - Optional data to send along with the call.
977      *
978      * Returns whether the call correctly returned the expected magic value.
979      */
980     function _checkContractOnERC721Received(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) private returns (bool) {
986         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
987             bytes4 retval
988         ) {
989             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
990         } catch (bytes memory reason) {
991             if (reason.length == 0) {
992                 revert TransferToNonERC721ReceiverImplementer();
993             } else {
994                 assembly {
995                     revert(add(32, reason), mload(reason))
996                 }
997             }
998         }
999     }
1000 
1001     // =============================================================
1002     //                        MINT OPERATIONS
1003     // =============================================================
1004 
1005     /**
1006      * @dev Mints `quantity` tokens and transfers them to `to`.
1007      *
1008      * Requirements:
1009      *
1010      * - `to` cannot be the zero address.
1011      * - `quantity` must be greater than 0.
1012      *
1013      * Emits a {Transfer} event for each mint.
1014      */
1015     function _mint(address to, uint256 quantity) internal virtual {
1016         uint256 startTokenId = _currentIndex;
1017         if (quantity == 0) revert MintZeroQuantity();
1018 
1019         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1020 
1021         // Overflows are incredibly unrealistic.
1022         // `balance` and `numberMinted` have a maximum limit of 2**64.
1023         // `tokenId` has a maximum limit of 2**256.
1024         unchecked {
1025             // Updates:
1026             // - `balance += quantity`.
1027             // - `numberMinted += quantity`.
1028             //
1029             // We can directly add to the `balance` and `numberMinted`.
1030             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1031 
1032             // Updates:
1033             // - `address` to the owner.
1034             // - `startTimestamp` to the timestamp of minting.
1035             // - `burned` to `false`.
1036             // - `nextInitialized` to `quantity == 1`.
1037             _packedOwnerships[startTokenId] = _packOwnershipData(
1038                 to,
1039                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1040             );
1041 
1042             uint256 toMasked;
1043             uint256 end = startTokenId + quantity;
1044 
1045             // Use assembly to loop and emit the `Transfer` event for gas savings.
1046             assembly {
1047                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1048                 toMasked := and(to, _BITMASK_ADDRESS)
1049                 // Emit the `Transfer` event.
1050                 log4(
1051                     0, // Start of data (0, since no data).
1052                     0, // End of data (0, since no data).
1053                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1054                     0, // `address(0)`.
1055                     toMasked, // `to`.
1056                     startTokenId // `tokenId`.
1057                 )
1058 
1059                 for {
1060                     let tokenId := add(startTokenId, 1)
1061                 } iszero(eq(tokenId, end)) {
1062                     tokenId := add(tokenId, 1)
1063                 } {
1064                     // Emit the `Transfer` event. Similar to above.
1065                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1066                 }
1067             }
1068             if (toMasked == 0) revert MintToZeroAddress();
1069 
1070             _currentIndex = end;
1071         }
1072         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1073     }
1074 
1075     /**
1076      * @dev Mints `quantity` tokens and transfers them to `to`.
1077      *
1078      * This function is intended for efficient minting only during contract creation.
1079      *
1080      * It emits only one {ConsecutiveTransfer} as defined in
1081      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1082      * instead of a sequence of {Transfer} event(s).
1083      *
1084      * Calling this function outside of contract creation WILL make your contract
1085      * non-compliant with the ERC721 standard.
1086      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1087      * {ConsecutiveTransfer} event is only permissible during contract creation.
1088      *
1089      * Requirements:
1090      *
1091      * - `to` cannot be the zero address.
1092      * - `quantity` must be greater than 0.
1093      *
1094      * Emits a {ConsecutiveTransfer} event.
1095      */
1096     function _mintERC2309(address to, uint256 quantity) internal virtual {
1097         uint256 startTokenId = _currentIndex;
1098         if (to == address(0)) revert MintToZeroAddress();
1099         if (quantity == 0) revert MintZeroQuantity();
1100         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1105         unchecked {
1106             // Updates:
1107             // - `balance += quantity`.
1108             // - `numberMinted += quantity`.
1109             //
1110             // We can directly add to the `balance` and `numberMinted`.
1111             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1112 
1113             // Updates:
1114             // - `address` to the owner.
1115             // - `startTimestamp` to the timestamp of minting.
1116             // - `burned` to `false`.
1117             // - `nextInitialized` to `quantity == 1`.
1118             _packedOwnerships[startTokenId] = _packOwnershipData(
1119                 to,
1120                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1121             );
1122 
1123             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1124 
1125             _currentIndex = startTokenId + quantity;
1126         }
1127         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1128     }
1129 
1130     /**
1131      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - If `to` refers to a smart contract, it must implement
1136      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1137      * - `quantity` must be greater than 0.
1138      *
1139      * See {_mint}.
1140      *
1141      * Emits a {Transfer} event for each mint.
1142      */
1143     function _safeMint(
1144         address to,
1145         uint256 quantity,
1146         bytes memory _data
1147     ) internal virtual {
1148         _mint(to, quantity);
1149 
1150         unchecked {
1151             if (to.code.length != 0) {
1152                 uint256 end = _currentIndex;
1153                 uint256 index = end - quantity;
1154                 do {
1155                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1156                         revert TransferToNonERC721ReceiverImplementer();
1157                     }
1158                 } while (index < end);
1159                 // Reentrancy protection.
1160                 if (_currentIndex != end) revert();
1161             }
1162         }
1163     }
1164 
1165     /**
1166      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1167      */
1168     function _safeMint(address to, uint256 quantity) internal virtual {
1169         _safeMint(to, quantity, '');
1170     }
1171 
1172     // =============================================================
1173     //                        BURN OPERATIONS
1174     // =============================================================
1175 
1176     /**
1177      * @dev Equivalent to `_burn(tokenId, false)`.
1178      */
1179     function _burn(uint256 tokenId) internal virtual {
1180         _burn(tokenId, false);
1181     }
1182 
1183     /**
1184      * @dev Destroys `tokenId`.
1185      * The approval is cleared when the token is burned.
1186      *
1187      * Requirements:
1188      *
1189      * - `tokenId` must exist.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1194         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1195 
1196         address from = address(uint160(prevOwnershipPacked));
1197 
1198         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1199 
1200         if (approvalCheck) {
1201             // The nested ifs save around 20+ gas over a compound boolean condition.
1202             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1203                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1204         }
1205 
1206         _beforeTokenTransfers(from, address(0), tokenId, 1);
1207 
1208         // Clear approvals from the previous owner.
1209         assembly {
1210             if approvedAddress {
1211                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1212                 sstore(approvedAddressSlot, 0)
1213             }
1214         }
1215 
1216         // Underflow of the sender's balance is impossible because we check for
1217         // ownership above and the recipient's balance can't realistically overflow.
1218         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1219         unchecked {
1220             // Updates:
1221             // - `balance -= 1`.
1222             // - `numberBurned += 1`.
1223             //
1224             // We can directly decrement the balance, and increment the number burned.
1225             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1226             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1227 
1228             // Updates:
1229             // - `address` to the last owner.
1230             // - `startTimestamp` to the timestamp of burning.
1231             // - `burned` to `true`.
1232             // - `nextInitialized` to `true`.
1233             _packedOwnerships[tokenId] = _packOwnershipData(
1234                 from,
1235                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1236             );
1237 
1238             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1239             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1240                 uint256 nextTokenId = tokenId + 1;
1241                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1242                 if (_packedOwnerships[nextTokenId] == 0) {
1243                     // If the next slot is within bounds.
1244                     if (nextTokenId != _currentIndex) {
1245                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1246                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1247                     }
1248                 }
1249             }
1250         }
1251 
1252         emit Transfer(from, address(0), tokenId);
1253         _afterTokenTransfers(from, address(0), tokenId, 1);
1254 
1255         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1256         unchecked {
1257             _burnCounter++;
1258         }
1259     }
1260 
1261     // =============================================================
1262     //                     EXTRA DATA OPERATIONS
1263     // =============================================================
1264 
1265     /**
1266      * @dev Directly sets the extra data for the ownership data `index`.
1267      */
1268     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1269         uint256 packed = _packedOwnerships[index];
1270         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1271         uint256 extraDataCasted;
1272         // Cast `extraData` with assembly to avoid redundant masking.
1273         assembly {
1274             extraDataCasted := extraData
1275         }
1276         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1277         _packedOwnerships[index] = packed;
1278     }
1279 
1280     /**
1281      * @dev Called during each token transfer to set the 24bit `extraData` field.
1282      * Intended to be overridden by the cosumer contract.
1283      *
1284      * `previousExtraData` - the value of `extraData` before transfer.
1285      *
1286      * Calling conditions:
1287      *
1288      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1289      * transferred to `to`.
1290      * - When `from` is zero, `tokenId` will be minted for `to`.
1291      * - When `to` is zero, `tokenId` will be burned by `from`.
1292      * - `from` and `to` are never both zero.
1293      */
1294     function _extraData(
1295         address from,
1296         address to,
1297         uint24 previousExtraData
1298     ) internal view virtual returns (uint24) {}
1299 
1300     /**
1301      * @dev Returns the next extra data for the packed ownership data.
1302      * The returned result is shifted into position.
1303      */
1304     function _nextExtraData(
1305         address from,
1306         address to,
1307         uint256 prevOwnershipPacked
1308     ) private view returns (uint256) {
1309         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1310         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1311     }
1312 
1313     // =============================================================
1314     //                       OTHER OPERATIONS
1315     // =============================================================
1316 
1317     /**
1318      * @dev Returns the message sender (defaults to `msg.sender`).
1319      *
1320      * If you are writing GSN compatible contracts, you need to override this function.
1321      */
1322     function _msgSenderERC721A() internal view virtual returns (address) {
1323         return msg.sender;
1324     }
1325 
1326     /**
1327      * @dev Converts a uint256 to its ASCII string decimal representation.
1328      */
1329     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1330         assembly {
1331             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1332             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1333             // We will need 1 32-byte word to store the length,
1334             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1335             ptr := add(mload(0x40), 128)
1336             // Update the free memory pointer to allocate.
1337             mstore(0x40, ptr)
1338 
1339             // Cache the end of the memory to calculate the length later.
1340             let end := ptr
1341 
1342             // We write the string from the rightmost digit to the leftmost digit.
1343             // The following is essentially a do-while loop that also handles the zero case.
1344             // Costs a bit more than early returning for the zero case,
1345             // but cheaper in terms of deployment and overall runtime costs.
1346             for {
1347                 // Initialize and perform the first pass without check.
1348                 let temp := value
1349                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1350                 ptr := sub(ptr, 1)
1351                 // Write the character to the pointer.
1352                 // The ASCII index of the '0' character is 48.
1353                 mstore8(ptr, add(48, mod(temp, 10)))
1354                 temp := div(temp, 10)
1355             } temp {
1356                 // Keep dividing `temp` until zero.
1357                 temp := div(temp, 10)
1358             } {
1359                 // Body of the for loop.
1360                 ptr := sub(ptr, 1)
1361                 mstore8(ptr, add(48, mod(temp, 10)))
1362             }
1363 
1364             let length := sub(end, ptr)
1365             // Move the pointer 32 bytes leftwards to make room for the length.
1366             ptr := sub(ptr, 32)
1367             // Store the length.
1368             mstore(ptr, length)
1369         }
1370     }
1371 }
1372 
1373 contract EightBitDogz is ERC721A {
1374     address _owner;
1375     uint256 _price = 0.001 ether;
1376     uint256 _maxSupply = 999; 
1377     uint256 _maxPerTx = 10;
1378 
1379     
1380     modifier onlyOwner {
1381         require(_owner == msg.sender, "No Permission");
1382         _;
1383     }
1384     constructor() ERC721A("8BitDogz", "8BD") {
1385         _owner = msg.sender;
1386     }
1387     
1388     function mint(uint256 amount) payable public {
1389         require(amount <= _maxPerTx);
1390         uint256 cost = (amount - 1) * _price;
1391         require(msg.value >= cost, "Need Ether");
1392         require(totalSupply() <= _maxSupply, "No More");
1393         _safeMint(msg.sender, amount);
1394     }
1395 
1396     function setcost(uint256 cost, uint8 maxper) public onlyOwner {
1397         _price = cost;
1398         _maxPerTx = maxper;
1399     }
1400 
1401     function maxSupply() public view returns (uint256){
1402         return _maxSupply;
1403     }
1404 
1405     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1406         require(_exists(tokenId), "Cannot query non-existent token");
1407         return string(abi.encodePacked("https://black-negative-whale-730.mypinata.cloud/ipfs/QmdfHRTRtkAJtbJwQwJoPcCYXs3EkuKwPUHvJLCJa3rNyK/", _toString(tokenId), ".json"));
1408     }
1409     
1410     function withdraw() external onlyOwner {
1411         payable(msg.sender).transfer(address(this).balance);
1412     }
1413 }