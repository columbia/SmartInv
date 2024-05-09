1 // File: 3dCat/3dCat.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 // ERC721A Contracts v4.2.2
7 // Creator: Chiru Labs
8 
9 // ERC721A Contracts v4.2.2
10 // Creator: Chiru Labs
11 
12 /**
13  * @dev Interface of ERC721A.
14  */
15 interface IERC721A {
16     /**
17      * The caller must own the token or be an approved operator.
18      */
19     error ApprovalCallerNotOwnerNorApproved();
20 
21     /**
22      * The token does not exist.
23      */
24     error ApprovalQueryForNonexistentToken();
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
742         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
743         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
744     }
745 
746     /**
747      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
748      *
749      * See {setApprovalForAll}.
750      */
751     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
752         return _operatorApprovals[owner][operator];
753     }
754 
755     /**
756      * @dev Returns whether `tokenId` exists.
757      *
758      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
759      *
760      * Tokens start existing when they are minted. See {_mint}.
761      */
762     function _exists(uint256 tokenId) internal view virtual returns (bool) {
763         return
764             _startTokenId() <= tokenId &&
765             tokenId < _currentIndex && // If within bounds,
766             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
767     }
768 
769     /**
770      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
771      */
772     function _isSenderApprovedOrOwner(
773         address approvedAddress,
774         address owner,
775         address msgSender
776     ) private pure returns (bool result) {
777         assembly {
778             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
779             owner := and(owner, _BITMASK_ADDRESS)
780             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
781             msgSender := and(msgSender, _BITMASK_ADDRESS)
782             // `msgSender == owner || msgSender == approvedAddress`.
783             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
784         }
785     }
786 
787     /**
788      * @dev Returns the storage slot and value for the approved address of `tokenId`.
789      */
790     function _getApprovedSlotAndAddress(uint256 tokenId)
791         private
792         view
793         returns (uint256 approvedAddressSlot, address approvedAddress)
794     {
795         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
796         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
797         assembly {
798             approvedAddressSlot := tokenApproval.slot
799             approvedAddress := sload(approvedAddressSlot)
800         }
801     }
802 
803     // =============================================================
804     //                      TRANSFER OPERATIONS
805     // =============================================================
806 
807     /**
808      * @dev Transfers `tokenId` from `from` to `to`.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      * - If the caller is not `from`, it must be approved to move this token
816      * by either {approve} or {setApprovalForAll}.
817      *
818      * Emits a {Transfer} event.
819      */
820     function transferFrom(
821         address from,
822         address to,
823         uint256 tokenId
824     ) public virtual override {
825         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
826 
827         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
828 
829         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
830 
831         // The nested ifs save around 20+ gas over a compound boolean condition.
832         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
833             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
834 
835         if (to == address(0)) revert TransferToZeroAddress();
836 
837         _beforeTokenTransfers(from, to, tokenId, 1);
838 
839         // Clear approvals from the previous owner.
840         assembly {
841             if approvedAddress {
842                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
843                 sstore(approvedAddressSlot, 0)
844             }
845         }
846 
847         // Underflow of the sender's balance is impossible because we check for
848         // ownership above and the recipient's balance can't realistically overflow.
849         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
850         unchecked {
851             // We can directly increment and decrement the balances.
852             --_packedAddressData[from]; // Updates: `balance -= 1`.
853             ++_packedAddressData[to]; // Updates: `balance += 1`.
854 
855             // Updates:
856             // - `address` to the next owner.
857             // - `startTimestamp` to the timestamp of transfering.
858             // - `burned` to `false`.
859             // - `nextInitialized` to `true`.
860             _packedOwnerships[tokenId] = _packOwnershipData(
861                 to,
862                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
863             );
864 
865             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
866             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
867                 uint256 nextTokenId = tokenId + 1;
868                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
869                 if (_packedOwnerships[nextTokenId] == 0) {
870                     // If the next slot is within bounds.
871                     if (nextTokenId != _currentIndex) {
872                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
873                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
874                     }
875                 }
876             }
877         }
878 
879         emit Transfer(from, to, tokenId);
880         _afterTokenTransfers(from, to, tokenId, 1);
881     }
882 
883     /**
884      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
885      */
886     function safeTransferFrom(
887         address from,
888         address to,
889         uint256 tokenId
890     ) public virtual override {
891         safeTransferFrom(from, to, tokenId, '');
892     }
893 
894     /**
895      * @dev Safely transfers `tokenId` token from `from` to `to`.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must exist and be owned by `from`.
902      * - If the caller is not `from`, it must be approved to move this token
903      * by either {approve} or {setApprovalForAll}.
904      * - If `to` refers to a smart contract, it must implement
905      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
906      *
907      * Emits a {Transfer} event.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId,
913         bytes memory _data
914     ) public virtual override {
915         transferFrom(from, to, tokenId);
916         if (to.code.length != 0)
917             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
918                 revert TransferToNonERC721ReceiverImplementer();
919             }
920     }
921 
922     /**
923      * @dev Hook that is called before a set of serially-ordered token IDs
924      * are about to be transferred. This includes minting.
925      * And also called before burning one token.
926      *
927      * `startTokenId` - the first token ID to be transferred.
928      * `quantity` - the amount to be transferred.
929      *
930      * Calling conditions:
931      *
932      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
933      * transferred to `to`.
934      * - When `from` is zero, `tokenId` will be minted for `to`.
935      * - When `to` is zero, `tokenId` will be burned by `from`.
936      * - `from` and `to` are never both zero.
937      */
938     function _beforeTokenTransfers(
939         address from,
940         address to,
941         uint256 startTokenId,
942         uint256 quantity
943     ) internal virtual {}
944 
945     /**
946      * @dev Hook that is called after a set of serially-ordered token IDs
947      * have been transferred. This includes minting.
948      * And also called after one token has been burned.
949      *
950      * `startTokenId` - the first token ID to be transferred.
951      * `quantity` - the amount to be transferred.
952      *
953      * Calling conditions:
954      *
955      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
956      * transferred to `to`.
957      * - When `from` is zero, `tokenId` has been minted for `to`.
958      * - When `to` is zero, `tokenId` has been burned by `from`.
959      * - `from` and `to` are never both zero.
960      */
961     function _afterTokenTransfers(
962         address from,
963         address to,
964         uint256 startTokenId,
965         uint256 quantity
966     ) internal virtual {}
967 
968     /**
969      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
970      *
971      * `from` - Previous owner of the given token ID.
972      * `to` - Target address that will receive the token.
973      * `tokenId` - Token ID to be transferred.
974      * `_data` - Optional data to send along with the call.
975      *
976      * Returns whether the call correctly returned the expected magic value.
977      */
978     function _checkContractOnERC721Received(
979         address from,
980         address to,
981         uint256 tokenId,
982         bytes memory _data
983     ) private returns (bool) {
984         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
985             bytes4 retval
986         ) {
987             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
988         } catch (bytes memory reason) {
989             if (reason.length == 0) {
990                 revert TransferToNonERC721ReceiverImplementer();
991             } else {
992                 assembly {
993                     revert(add(32, reason), mload(reason))
994                 }
995             }
996         }
997     }
998 
999     // =============================================================
1000     //                        MINT OPERATIONS
1001     // =============================================================
1002 
1003     /**
1004      * @dev Mints `quantity` tokens and transfers them to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `to` cannot be the zero address.
1009      * - `quantity` must be greater than 0.
1010      *
1011      * Emits a {Transfer} event for each mint.
1012      */
1013     function _mint(address to, uint256 quantity) internal virtual {
1014         uint256 startTokenId = _currentIndex;
1015         if (quantity == 0) revert MintZeroQuantity();
1016 
1017         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1018 
1019         // Overflows are incredibly unrealistic.
1020         // `balance` and `numberMinted` have a maximum limit of 2**64.
1021         // `tokenId` has a maximum limit of 2**256.
1022         unchecked {
1023             // Updates:
1024             // - `balance += quantity`.
1025             // - `numberMinted += quantity`.
1026             //
1027             // We can directly add to the `balance` and `numberMinted`.
1028             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1029 
1030             // Updates:
1031             // - `address` to the owner.
1032             // - `startTimestamp` to the timestamp of minting.
1033             // - `burned` to `false`.
1034             // - `nextInitialized` to `quantity == 1`.
1035             _packedOwnerships[startTokenId] = _packOwnershipData(
1036                 to,
1037                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1038             );
1039 
1040             uint256 toMasked;
1041             uint256 end = startTokenId + quantity;
1042 
1043             // Use assembly to loop and emit the `Transfer` event for gas savings.
1044             // The duplicated `log4` removes an extra check and reduces stack juggling.
1045             // The assembly, together with the surrounding Solidity code, have been
1046             // delicately arranged to nudge the compiler into producing optimized opcodes.
1047             assembly {
1048                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1049                 toMasked := and(to, _BITMASK_ADDRESS)
1050                 // Emit the `Transfer` event.
1051                 log4(
1052                     0, // Start of data (0, since no data).
1053                     0, // End of data (0, since no data).
1054                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1055                     0, // `address(0)`.
1056                     toMasked, // `to`.
1057                     startTokenId // `tokenId`.
1058                 )
1059 
1060                 for {
1061                     let tokenId := add(startTokenId, 1)
1062                 } iszero(eq(tokenId, end)) {
1063                     tokenId := add(tokenId, 1)
1064                 } {
1065                     // Emit the `Transfer` event. Similar to above.
1066                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1067                 }
1068             }
1069             if (toMasked == 0) revert MintToZeroAddress();
1070 
1071             _currentIndex = end;
1072         }
1073         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1074     }
1075 
1076     /**
1077      * @dev Mints `quantity` tokens and transfers them to `to`.
1078      *
1079      * This function is intended for efficient minting only during contract creation.
1080      *
1081      * It emits only one {ConsecutiveTransfer} as defined in
1082      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1083      * instead of a sequence of {Transfer} event(s).
1084      *
1085      * Calling this function outside of contract creation WILL make your contract
1086      * non-compliant with the ERC721 standard.
1087      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1088      * {ConsecutiveTransfer} event is only permissible during contract creation.
1089      *
1090      * Requirements:
1091      *
1092      * - `to` cannot be the zero address.
1093      * - `quantity` must be greater than 0.
1094      *
1095      * Emits a {ConsecutiveTransfer} event.
1096      */
1097     function _mintERC2309(address to, uint256 quantity) internal virtual {
1098         uint256 startTokenId = _currentIndex;
1099         if (to == address(0)) revert MintToZeroAddress();
1100         if (quantity == 0) revert MintZeroQuantity();
1101         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1102 
1103         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1104 
1105         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1106         unchecked {
1107             // Updates:
1108             // - `balance += quantity`.
1109             // - `numberMinted += quantity`.
1110             //
1111             // We can directly add to the `balance` and `numberMinted`.
1112             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1113 
1114             // Updates:
1115             // - `address` to the owner.
1116             // - `startTimestamp` to the timestamp of minting.
1117             // - `burned` to `false`.
1118             // - `nextInitialized` to `quantity == 1`.
1119             _packedOwnerships[startTokenId] = _packOwnershipData(
1120                 to,
1121                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1122             );
1123 
1124             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1125 
1126             _currentIndex = startTokenId + quantity;
1127         }
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131     /**
1132      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1133      *
1134      * Requirements:
1135      *
1136      * - If `to` refers to a smart contract, it must implement
1137      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1138      * - `quantity` must be greater than 0.
1139      *
1140      * See {_mint}.
1141      *
1142      * Emits a {Transfer} event for each mint.
1143      */
1144     function _safeMint(
1145         address to,
1146         uint256 quantity,
1147         bytes memory _data
1148     ) internal virtual {
1149         _mint(to, quantity);
1150 
1151         unchecked {
1152             if (to.code.length != 0) {
1153                 uint256 end = _currentIndex;
1154                 uint256 index = end - quantity;
1155                 do {
1156                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1157                         revert TransferToNonERC721ReceiverImplementer();
1158                     }
1159                 } while (index < end);
1160                 // Reentrancy protection.
1161                 if (_currentIndex != end) revert();
1162             }
1163         }
1164     }
1165 
1166     /**
1167      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1168      */
1169     function _safeMint(address to, uint256 quantity) internal virtual {
1170         _safeMint(to, quantity, '');
1171     }
1172 
1173     // =============================================================
1174     //                        BURN OPERATIONS
1175     // =============================================================
1176 
1177     /**
1178      * @dev Equivalent to `_burn(tokenId, false)`.
1179      */
1180     function _burn(uint256 tokenId) internal virtual {
1181         _burn(tokenId, false);
1182     }
1183 
1184     /**
1185      * @dev Destroys `tokenId`.
1186      * The approval is cleared when the token is burned.
1187      *
1188      * Requirements:
1189      *
1190      * - `tokenId` must exist.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1195         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1196 
1197         address from = address(uint160(prevOwnershipPacked));
1198 
1199         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1200 
1201         if (approvalCheck) {
1202             // The nested ifs save around 20+ gas over a compound boolean condition.
1203             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1204                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1205         }
1206 
1207         _beforeTokenTransfers(from, address(0), tokenId, 1);
1208 
1209         // Clear approvals from the previous owner.
1210         assembly {
1211             if approvedAddress {
1212                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1213                 sstore(approvedAddressSlot, 0)
1214             }
1215         }
1216 
1217         // Underflow of the sender's balance is impossible because we check for
1218         // ownership above and the recipient's balance can't realistically overflow.
1219         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1220         unchecked {
1221             // Updates:
1222             // - `balance -= 1`.
1223             // - `numberBurned += 1`.
1224             //
1225             // We can directly decrement the balance, and increment the number burned.
1226             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1227             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1228 
1229             // Updates:
1230             // - `address` to the last owner.
1231             // - `startTimestamp` to the timestamp of burning.
1232             // - `burned` to `true`.
1233             // - `nextInitialized` to `true`.
1234             _packedOwnerships[tokenId] = _packOwnershipData(
1235                 from,
1236                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1237             );
1238 
1239             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1240             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1241                 uint256 nextTokenId = tokenId + 1;
1242                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1243                 if (_packedOwnerships[nextTokenId] == 0) {
1244                     // If the next slot is within bounds.
1245                     if (nextTokenId != _currentIndex) {
1246                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1247                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1248                     }
1249                 }
1250             }
1251         }
1252 
1253         emit Transfer(from, address(0), tokenId);
1254         _afterTokenTransfers(from, address(0), tokenId, 1);
1255 
1256         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1257         unchecked {
1258             _burnCounter++;
1259         }
1260     }
1261 
1262     // =============================================================
1263     //                     EXTRA DATA OPERATIONS
1264     // =============================================================
1265 
1266     /**
1267      * @dev Directly sets the extra data for the ownership data `index`.
1268      */
1269     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1270         uint256 packed = _packedOwnerships[index];
1271         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1272         uint256 extraDataCasted;
1273         // Cast `extraData` with assembly to avoid redundant masking.
1274         assembly {
1275             extraDataCasted := extraData
1276         }
1277         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1278         _packedOwnerships[index] = packed;
1279     }
1280 
1281     /**
1282      * @dev Called during each token transfer to set the 24bit `extraData` field.
1283      * Intended to be overridden by the cosumer contract.
1284      *
1285      * `previousExtraData` - the value of `extraData` before transfer.
1286      *
1287      * Calling conditions:
1288      *
1289      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1290      * transferred to `to`.
1291      * - When `from` is zero, `tokenId` will be minted for `to`.
1292      * - When `to` is zero, `tokenId` will be burned by `from`.
1293      * - `from` and `to` are never both zero.
1294      */
1295     function _extraData(
1296         address from,
1297         address to,
1298         uint24 previousExtraData
1299     ) internal view virtual returns (uint24) {}
1300 
1301     /**
1302      * @dev Returns the next extra data for the packed ownership data.
1303      * The returned result is shifted into position.
1304      */
1305     function _nextExtraData(
1306         address from,
1307         address to,
1308         uint256 prevOwnershipPacked
1309     ) private view returns (uint256) {
1310         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1311         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1312     }
1313 
1314     // =============================================================
1315     //                       OTHER OPERATIONS
1316     // =============================================================
1317 
1318     /**
1319      * @dev Returns the message sender (defaults to `msg.sender`).
1320      *
1321      * If you are writing GSN compatible contracts, you need to override this function.
1322      */
1323     function _msgSenderERC721A() internal view virtual returns (address) {
1324         return msg.sender;
1325     }
1326 
1327     /**
1328      * @dev Converts a uint256 to its ASCII string decimal representation.
1329      */
1330     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1331         assembly {
1332             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1333             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1334             // We will need 1 32-byte word to store the length,
1335             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1336             str := add(mload(0x40), 0x80)
1337             // Update the free memory pointer to allocate.
1338             mstore(0x40, str)
1339 
1340             // Cache the end of the memory to calculate the length later.
1341             let end := str
1342 
1343             // We write the string from rightmost digit to leftmost digit.
1344             // The following is essentially a do-while loop that also handles the zero case.
1345             // prettier-ignore
1346             for { let temp := value } 1 {} {
1347                 str := sub(str, 1)
1348                 // Write the character to the pointer.
1349                 // The ASCII index of the '0' character is 48.
1350                 mstore8(str, add(48, mod(temp, 10)))
1351                 // Keep dividing `temp` until zero.
1352                 temp := div(temp, 10)
1353                 // prettier-ignore
1354                 if iszero(temp) { break }
1355             }
1356 
1357             let length := sub(end, str)
1358             // Move the pointer 32 bytes leftwards to make room for the length.
1359             str := sub(str, 0x20)
1360             // Store the length.
1361             mstore(str, length)
1362         }
1363     }
1364 }
1365 
1366 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1367 
1368 /**
1369  * @dev Collection of functions related to the address type
1370  */
1371 library Address {
1372     /**
1373      * @dev Returns true if `account` is a contract.
1374      *
1375      * [IMPORTANT]
1376      * ====
1377      * It is unsafe to assume that an address for which this function returns
1378      * false is an externally-owned account (EOA) and not a contract.
1379      *
1380      * Among others, `isContract` will return false for the following
1381      * types of addresses:
1382      *
1383      *  - an externally-owned account
1384      *  - a contract in construction
1385      *  - an address where a contract will be created
1386      *  - an address where a contract lived, but was destroyed
1387      * ====
1388      *
1389      * [IMPORTANT]
1390      * ====
1391      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1392      *
1393      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1394      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1395      * constructor.
1396      * ====
1397      */
1398     function isContract(address account) internal view returns (bool) {
1399         // This method relies on extcodesize/address.code.length, which returns 0
1400         // for contracts in construction, since the code is only stored at the end
1401         // of the constructor execution.
1402 
1403         return account.code.length > 0;
1404     }
1405 
1406     /**
1407      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1408      * `recipient`, forwarding all available gas and reverting on errors.
1409      *
1410      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1411      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1412      * imposed by `transfer`, making them unable to receive funds via
1413      * `transfer`. {sendValue} removes this limitation.
1414      *
1415      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1416      *
1417      * IMPORTANT: because control is transferred to `recipient`, care must be
1418      * taken to not create reentrancy vulnerabilities. Consider using
1419      * {ReentrancyGuard} or the
1420      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1421      */
1422     function sendValue(address payable recipient, uint256 amount) internal {
1423         require(address(this).balance >= amount, "Address: insufficient balance");
1424 
1425         (bool success, ) = recipient.call{value: amount}("");
1426         require(success, "Address: unable to send value, recipient may have reverted");
1427     }
1428 
1429     /**
1430      * @dev Performs a Solidity function call using a low level `call`. A
1431      * plain `call` is an unsafe replacement for a function call: use this
1432      * function instead.
1433      *
1434      * If `target` reverts with a revert reason, it is bubbled up by this
1435      * function (like regular Solidity function calls).
1436      *
1437      * Returns the raw returned data. To convert to the expected return value,
1438      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1439      *
1440      * Requirements:
1441      *
1442      * - `target` must be a contract.
1443      * - calling `target` with `data` must not revert.
1444      *
1445      * _Available since v3.1._
1446      */
1447     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1448         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1449     }
1450 
1451     /**
1452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1453      * `errorMessage` as a fallback revert reason when `target` reverts.
1454      *
1455      * _Available since v3.1._
1456      */
1457     function functionCall(
1458         address target,
1459         bytes memory data,
1460         string memory errorMessage
1461     ) internal returns (bytes memory) {
1462         return functionCallWithValue(target, data, 0, errorMessage);
1463     }
1464 
1465     /**
1466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1467      * but also transferring `value` wei to `target`.
1468      *
1469      * Requirements:
1470      *
1471      * - the calling contract must have an ETH balance of at least `value`.
1472      * - the called Solidity function must be `payable`.
1473      *
1474      * _Available since v3.1._
1475      */
1476     function functionCallWithValue(
1477         address target,
1478         bytes memory data,
1479         uint256 value
1480     ) internal returns (bytes memory) {
1481         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1482     }
1483 
1484     /**
1485      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1486      * with `errorMessage` as a fallback revert reason when `target` reverts.
1487      *
1488      * _Available since v3.1._
1489      */
1490     function functionCallWithValue(
1491         address target,
1492         bytes memory data,
1493         uint256 value,
1494         string memory errorMessage
1495     ) internal returns (bytes memory) {
1496         require(address(this).balance >= value, "Address: insufficient balance for call");
1497         (bool success, bytes memory returndata) = target.call{value: value}(data);
1498         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1499     }
1500 
1501     /**
1502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1503      * but performing a static call.
1504      *
1505      * _Available since v3.3._
1506      */
1507     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1508         return functionStaticCall(target, data, "Address: low-level static call failed");
1509     }
1510 
1511     /**
1512      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1513      * but performing a static call.
1514      *
1515      * _Available since v3.3._
1516      */
1517     function functionStaticCall(
1518         address target,
1519         bytes memory data,
1520         string memory errorMessage
1521     ) internal view returns (bytes memory) {
1522         (bool success, bytes memory returndata) = target.staticcall(data);
1523         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1524     }
1525 
1526     /**
1527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1528      * but performing a delegate call.
1529      *
1530      * _Available since v3.4._
1531      */
1532     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1533         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1534     }
1535 
1536     /**
1537      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1538      * but performing a delegate call.
1539      *
1540      * _Available since v3.4._
1541      */
1542     function functionDelegateCall(
1543         address target,
1544         bytes memory data,
1545         string memory errorMessage
1546     ) internal returns (bytes memory) {
1547         (bool success, bytes memory returndata) = target.delegatecall(data);
1548         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1549     }
1550 
1551     /**
1552      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1553      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1554      *
1555      * _Available since v4.8._
1556      */
1557     function verifyCallResultFromTarget(
1558         address target,
1559         bool success,
1560         bytes memory returndata,
1561         string memory errorMessage
1562     ) internal view returns (bytes memory) {
1563         if (success) {
1564             if (returndata.length == 0) {
1565                 // only check isContract if the call was successful and the return data is empty
1566                 // otherwise we already know that it was a contract
1567                 require(isContract(target), "Address: call to non-contract");
1568             }
1569             return returndata;
1570         } else {
1571             _revert(returndata, errorMessage);
1572         }
1573     }
1574 
1575     /**
1576      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1577      * revert reason or using the provided one.
1578      *
1579      * _Available since v4.3._
1580      */
1581     function verifyCallResult(
1582         bool success,
1583         bytes memory returndata,
1584         string memory errorMessage
1585     ) internal pure returns (bytes memory) {
1586         if (success) {
1587             return returndata;
1588         } else {
1589             _revert(returndata, errorMessage);
1590         }
1591     }
1592 
1593     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1594         // Look for revert reason and bubble it up if present
1595         if (returndata.length > 0) {
1596             // The easiest way to bubble the revert reason is using memory via assembly
1597             /// @solidity memory-safe-assembly
1598             assembly {
1599                 let returndata_size := mload(returndata)
1600                 revert(add(32, returndata), returndata_size)
1601             }
1602         } else {
1603             revert(errorMessage);
1604         }
1605     }
1606 }
1607 
1608 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1609 
1610 /**
1611  * @dev String operations.
1612  */
1613 library Strings {
1614     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1615     uint8 private constant _ADDRESS_LENGTH = 20;
1616 
1617     /**
1618      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1619      */
1620     function toString(uint256 value) internal pure returns (string memory) {
1621         // Inspired by OraclizeAPI's implementation - MIT licence
1622         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1623 
1624         if (value == 0) {
1625             return "0";
1626         }
1627         uint256 temp = value;
1628         uint256 digits;
1629         while (temp != 0) {
1630             digits++;
1631             temp /= 10;
1632         }
1633         bytes memory buffer = new bytes(digits);
1634         while (value != 0) {
1635             digits -= 1;
1636             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1637             value /= 10;
1638         }
1639         return string(buffer);
1640     }
1641 
1642     /**
1643      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1644      */
1645     function toHexString(uint256 value) internal pure returns (string memory) {
1646         if (value == 0) {
1647             return "0x00";
1648         }
1649         uint256 temp = value;
1650         uint256 length = 0;
1651         while (temp != 0) {
1652             length++;
1653             temp >>= 8;
1654         }
1655         return toHexString(value, length);
1656     }
1657 
1658     /**
1659      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1660      */
1661     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1662         bytes memory buffer = new bytes(2 * length + 2);
1663         buffer[0] = "0";
1664         buffer[1] = "x";
1665         for (uint256 i = 2 * length + 1; i > 1; --i) {
1666             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1667             value >>= 4;
1668         }
1669         require(value == 0, "Strings: hex length insufficient");
1670         return string(buffer);
1671     }
1672 
1673     /**
1674      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1675      */
1676     function toHexString(address addr) internal pure returns (string memory) {
1677         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1678     }
1679 }
1680 
1681 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1682 
1683 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1684 
1685 /**
1686  * @dev External interface of AccessControl declared to support ERC165 detection.
1687  */
1688 interface IAccessControl {
1689     /**
1690      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1691      *
1692      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1693      * {RoleAdminChanged} not being emitted signaling this.
1694      *
1695      * _Available since v3.1._
1696      */
1697     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1698 
1699     /**
1700      * @dev Emitted when `account` is granted `role`.
1701      *
1702      * `sender` is the account that originated the contract call, an admin role
1703      * bearer except when using {AccessControl-_setupRole}.
1704      */
1705     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1706 
1707     /**
1708      * @dev Emitted when `account` is revoked `role`.
1709      *
1710      * `sender` is the account that originated the contract call:
1711      *   - if using `revokeRole`, it is the admin role bearer
1712      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1713      */
1714     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1715 
1716     /**
1717      * @dev Returns `true` if `account` has been granted `role`.
1718      */
1719     function hasRole(bytes32 role, address account) external view returns (bool);
1720 
1721     /**
1722      * @dev Returns the admin role that controls `role`. See {grantRole} and
1723      * {revokeRole}.
1724      *
1725      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1726      */
1727     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1728 
1729     /**
1730      * @dev Grants `role` to `account`.
1731      *
1732      * If `account` had not been already granted `role`, emits a {RoleGranted}
1733      * event.
1734      *
1735      * Requirements:
1736      *
1737      * - the caller must have ``role``'s admin role.
1738      */
1739     function grantRole(bytes32 role, address account) external;
1740 
1741     /**
1742      * @dev Revokes `role` from `account`.
1743      *
1744      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1745      *
1746      * Requirements:
1747      *
1748      * - the caller must have ``role``'s admin role.
1749      */
1750     function revokeRole(bytes32 role, address account) external;
1751 
1752     /**
1753      * @dev Revokes `role` from the calling account.
1754      *
1755      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1756      * purpose is to provide a mechanism for accounts to lose their privileges
1757      * if they are compromised (such as when a trusted device is misplaced).
1758      *
1759      * If the calling account had been granted `role`, emits a {RoleRevoked}
1760      * event.
1761      *
1762      * Requirements:
1763      *
1764      * - the caller must be `account`.
1765      */
1766     function renounceRole(bytes32 role, address account) external;
1767 }
1768 
1769 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1770 
1771 /**
1772  * @dev Provides information about the current execution context, including the
1773  * sender of the transaction and its data. While these are generally available
1774  * via msg.sender and msg.data, they should not be accessed in such a direct
1775  * manner, since when dealing with meta-transactions the account sending and
1776  * paying for execution may not be the actual sender (as far as an application
1777  * is concerned).
1778  *
1779  * This contract is only required for intermediate, library-like contracts.
1780  */
1781 abstract contract Context {
1782     function _msgSender() internal view virtual returns (address) {
1783         return msg.sender;
1784     }
1785 
1786     function _msgData() internal view virtual returns (bytes calldata) {
1787         return msg.data;
1788     }
1789 }
1790 
1791 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1792 
1793 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1794 
1795 /**
1796  * @dev Interface of the ERC165 standard, as defined in the
1797  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1798  *
1799  * Implementers can declare support of contract interfaces, which can then be
1800  * queried by others ({ERC165Checker}).
1801  *
1802  * For an implementation, see {ERC165}.
1803  */
1804 interface IERC165 {
1805     /**
1806      * @dev Returns true if this contract implements the interface defined by
1807      * `interfaceId`. See the corresponding
1808      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1809      * to learn more about how these ids are created.
1810      *
1811      * This function call must use less than 30 000 gas.
1812      */
1813     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1814 }
1815 
1816 /**
1817  * @dev Implementation of the {IERC165} interface.
1818  *
1819  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1820  * for the additional interface id that will be supported. For example:
1821  *
1822  * ```solidity
1823  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1824  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1825  * }
1826  * ```
1827  *
1828  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1829  */
1830 abstract contract ERC165 is IERC165 {
1831     /**
1832      * @dev See {IERC165-supportsInterface}.
1833      */
1834     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1835         return interfaceId == type(IERC165).interfaceId;
1836     }
1837 }
1838 
1839 /**
1840  * @dev Contract module that allows children to implement role-based access
1841  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1842  * members except through off-chain means by accessing the contract event logs. Some
1843  * applications may benefit from on-chain enumerability, for those cases see
1844  * {AccessControlEnumerable}.
1845  *
1846  * Roles are referred to by their `bytes32` identifier. These should be exposed
1847  * in the external API and be unique. The best way to achieve this is by
1848  * using `public constant` hash digests:
1849  *
1850  * ```
1851  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1852  * ```
1853  *
1854  * Roles can be used to represent a set of permissions. To restrict access to a
1855  * function call, use {hasRole}:
1856  *
1857  * ```
1858  * function foo() public {
1859  *     require(hasRole(MY_ROLE, msg.sender));
1860  *     ...
1861  * }
1862  * ```
1863  *
1864  * Roles can be granted and revoked dynamically via the {grantRole} and
1865  * {revokeRole} functions. Each role has an associated admin role, and only
1866  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1867  *
1868  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1869  * that only accounts with this role will be able to grant or revoke other
1870  * roles. More complex role relationships can be created by using
1871  * {_setRoleAdmin}.
1872  *
1873  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1874  * grant and revoke this role. Extra precautions should be taken to secure
1875  * accounts that have been granted it.
1876  */
1877 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1878     struct RoleData {
1879         mapping(address => bool) members;
1880         bytes32 adminRole;
1881     }
1882 
1883     mapping(bytes32 => RoleData) private _roles;
1884 
1885     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1886 
1887     /**
1888      * @dev Modifier that checks that an account has a specific role. Reverts
1889      * with a standardized message including the required role.
1890      *
1891      * The format of the revert reason is given by the following regular expression:
1892      *
1893      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1894      *
1895      * _Available since v4.1._
1896      */
1897     modifier onlyRole(bytes32 role) {
1898         _checkRole(role);
1899         _;
1900     }
1901 
1902     /**
1903      * @dev See {IERC165-supportsInterface}.
1904      */
1905     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1906         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1907     }
1908 
1909     /**
1910      * @dev Returns `true` if `account` has been granted `role`.
1911      */
1912     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1913         return _roles[role].members[account];
1914     }
1915 
1916     /**
1917      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1918      * Overriding this function changes the behavior of the {onlyRole} modifier.
1919      *
1920      * Format of the revert message is described in {_checkRole}.
1921      *
1922      * _Available since v4.6._
1923      */
1924     function _checkRole(bytes32 role) internal view virtual {
1925         _checkRole(role, _msgSender());
1926     }
1927 
1928     /**
1929      * @dev Revert with a standard message if `account` is missing `role`.
1930      *
1931      * The format of the revert reason is given by the following regular expression:
1932      *
1933      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1934      */
1935     function _checkRole(bytes32 role, address account) internal view virtual {
1936         if (!hasRole(role, account)) {
1937             revert(
1938                 string(
1939                     abi.encodePacked(
1940                         "AccessControl: account ",
1941                         Strings.toHexString(account),
1942                         " is missing role ",
1943                         Strings.toHexString(uint256(role), 32)
1944                     )
1945                 )
1946             );
1947         }
1948     }
1949 
1950     /**
1951      * @dev Returns the admin role that controls `role`. See {grantRole} and
1952      * {revokeRole}.
1953      *
1954      * To change a role's admin, use {_setRoleAdmin}.
1955      */
1956     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1957         return _roles[role].adminRole;
1958     }
1959 
1960     /**
1961      * @dev Grants `role` to `account`.
1962      *
1963      * If `account` had not been already granted `role`, emits a {RoleGranted}
1964      * event.
1965      *
1966      * Requirements:
1967      *
1968      * - the caller must have ``role``'s admin role.
1969      *
1970      * May emit a {RoleGranted} event.
1971      */
1972     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1973         _grantRole(role, account);
1974     }
1975 
1976     /**
1977      * @dev Revokes `role` from `account`.
1978      *
1979      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1980      *
1981      * Requirements:
1982      *
1983      * - the caller must have ``role``'s admin role.
1984      *
1985      * May emit a {RoleRevoked} event.
1986      */
1987     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1988         _revokeRole(role, account);
1989     }
1990 
1991     /**
1992      * @dev Revokes `role` from the calling account.
1993      *
1994      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1995      * purpose is to provide a mechanism for accounts to lose their privileges
1996      * if they are compromised (such as when a trusted device is misplaced).
1997      *
1998      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1999      * event.
2000      *
2001      * Requirements:
2002      *
2003      * - the caller must be `account`.
2004      *
2005      * May emit a {RoleRevoked} event.
2006      */
2007     function renounceRole(bytes32 role, address account) public virtual override {
2008         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2009 
2010         _revokeRole(role, account);
2011     }
2012 
2013     /**
2014      * @dev Grants `role` to `account`.
2015      *
2016      * If `account` had not been already granted `role`, emits a {RoleGranted}
2017      * event. Note that unlike {grantRole}, this function doesn't perform any
2018      * checks on the calling account.
2019      *
2020      * May emit a {RoleGranted} event.
2021      *
2022      * [WARNING]
2023      * ====
2024      * This function should only be called from the constructor when setting
2025      * up the initial roles for the system.
2026      *
2027      * Using this function in any other way is effectively circumventing the admin
2028      * system imposed by {AccessControl}.
2029      * ====
2030      *
2031      * NOTE: This function is deprecated in favor of {_grantRole}.
2032      */
2033     function _setupRole(bytes32 role, address account) internal virtual {
2034         _grantRole(role, account);
2035     }
2036 
2037     /**
2038      * @dev Sets `adminRole` as ``role``'s admin role.
2039      *
2040      * Emits a {RoleAdminChanged} event.
2041      */
2042     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2043         bytes32 previousAdminRole = getRoleAdmin(role);
2044         _roles[role].adminRole = adminRole;
2045         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2046     }
2047 
2048     /**
2049      * @dev Grants `role` to `account`.
2050      *
2051      * Internal function without access restriction.
2052      *
2053      * May emit a {RoleGranted} event.
2054      */
2055     function _grantRole(bytes32 role, address account) internal virtual {
2056         if (!hasRole(role, account)) {
2057             _roles[role].members[account] = true;
2058             emit RoleGranted(role, account, _msgSender());
2059         }
2060     }
2061 
2062     /**
2063      * @dev Revokes `role` from `account`.
2064      *
2065      * Internal function without access restriction.
2066      *
2067      * May emit a {RoleRevoked} event.
2068      */
2069     function _revokeRole(bytes32 role, address account) internal virtual {
2070         if (hasRole(role, account)) {
2071             _roles[role].members[account] = false;
2072             emit RoleRevoked(role, account, _msgSender());
2073         }
2074     }
2075 }
2076 
2077 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/utils/Initializable.sol)
2078 
2079 /**
2080  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
2081  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
2082  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
2083  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
2084  *
2085  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
2086  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
2087  * case an upgrade adds a module that needs to be initialized.
2088  *
2089  * For example:
2090  *
2091  * [.hljs-theme-light.nopadding]
2092  * ```
2093  * contract MyToken is ERC20Upgradeable {
2094  *     function initialize() initializer public {
2095  *         __ERC20_init("MyToken", "MTK");
2096  *     }
2097  * }
2098  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
2099  *     function initializeV2() reinitializer(2) public {
2100  *         __ERC20Permit_init("MyToken");
2101  *     }
2102  * }
2103  * ```
2104  *
2105  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
2106  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
2107  *
2108  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
2109  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
2110  *
2111  * [CAUTION]
2112  * ====
2113  * Avoid leaving a contract uninitialized.
2114  *
2115  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
2116  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
2117  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
2118  *
2119  * [.hljs-theme-light.nopadding]
2120  * ```
2121  * /// @custom:oz-upgrades-unsafe-allow constructor
2122  * constructor() {
2123  *     _disableInitializers();
2124  * }
2125  * ```
2126  * ====
2127  */
2128 abstract contract Initializable {
2129     /**
2130      * @dev Indicates that the contract has been initialized.
2131      * @custom:oz-retyped-from bool
2132      */
2133     uint8 private _initialized;
2134 
2135     /**
2136      * @dev Indicates that the contract is in the process of being initialized.
2137      */
2138     bool private _initializing;
2139 
2140     /**
2141      * @dev Triggered when the contract has been initialized or reinitialized.
2142      */
2143     event Initialized(uint8 version);
2144 
2145     /**
2146      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
2147      * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
2148      */
2149     modifier initializer() {
2150         bool isTopLevelCall = !_initializing;
2151         require(
2152             (isTopLevelCall && _initialized < 1) || (!Address.isContract(address(this)) && _initialized == 1),
2153             "Initializable: contract is already initialized"
2154         );
2155         _initialized = 1;
2156         if (isTopLevelCall) {
2157             _initializing = true;
2158         }
2159         _;
2160         if (isTopLevelCall) {
2161             _initializing = false;
2162             emit Initialized(1);
2163         }
2164     }
2165 
2166     /**
2167      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
2168      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
2169      * used to initialize parent contracts.
2170      *
2171      * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
2172      * initialization step. This is essential to configure modules that are added through upgrades and that require
2173      * initialization.
2174      *
2175      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
2176      * a contract, executing them in the right order is up to the developer or operator.
2177      */
2178     modifier reinitializer(uint8 version) {
2179         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
2180         _initialized = version;
2181         _initializing = true;
2182         _;
2183         _initializing = false;
2184         emit Initialized(version);
2185     }
2186 
2187     /**
2188      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
2189      * {initializer} and {reinitializer} modifiers, directly or indirectly.
2190      */
2191     modifier onlyInitializing() {
2192         require(_initializing, "Initializable: contract is not initializing");
2193         _;
2194     }
2195 
2196     /**
2197      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
2198      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
2199      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
2200      * through proxies.
2201      */
2202     function _disableInitializers() internal virtual {
2203         require(!_initializing, "Initializable: contract is initializing");
2204         if (_initialized < type(uint8).max) {
2205             _initialized = type(uint8).max;
2206             emit Initialized(type(uint8).max);
2207         }
2208     }
2209 }
2210 
2211 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
2212 
2213 /**
2214  * @dev These functions deal with verification of Merkle Tree proofs.
2215  *
2216  * The proofs can be generated using the JavaScript library
2217  * https://github.com/miguelmota/merkletreejs[merkletreejs].
2218  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
2219  *
2220  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
2221  *
2222  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
2223  * hashing, or use a hash function other than keccak256 for hashing leaves.
2224  * This is because the concatenation of a sorted pair of internal nodes in
2225  * the merkle tree could be reinterpreted as a leaf value.
2226  */
2227 library MerkleProof {
2228     /**
2229      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2230      * defined by `root`. For this, a `proof` must be provided, containing
2231      * sibling hashes on the branch from the leaf to the root of the tree. Each
2232      * pair of leaves and each pair of pre-images are assumed to be sorted.
2233      */
2234     function verify(
2235         bytes32[] memory proof,
2236         bytes32 root,
2237         bytes32 leaf
2238     ) internal pure returns (bool) {
2239         return processProof(proof, leaf) == root;
2240     }
2241 
2242     /**
2243      * @dev Calldata version of {verify}
2244      *
2245      * _Available since v4.7._
2246      */
2247     function verifyCalldata(
2248         bytes32[] calldata proof,
2249         bytes32 root,
2250         bytes32 leaf
2251     ) internal pure returns (bool) {
2252         return processProofCalldata(proof, leaf) == root;
2253     }
2254 
2255     /**
2256      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
2257      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2258      * hash matches the root of the tree. When processing the proof, the pairs
2259      * of leafs & pre-images are assumed to be sorted.
2260      *
2261      * _Available since v4.4._
2262      */
2263     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2264         bytes32 computedHash = leaf;
2265         for (uint256 i = 0; i < proof.length; i++) {
2266             computedHash = _hashPair(computedHash, proof[i]);
2267         }
2268         return computedHash;
2269     }
2270 
2271     /**
2272      * @dev Calldata version of {processProof}
2273      *
2274      * _Available since v4.7._
2275      */
2276     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
2277         bytes32 computedHash = leaf;
2278         for (uint256 i = 0; i < proof.length; i++) {
2279             computedHash = _hashPair(computedHash, proof[i]);
2280         }
2281         return computedHash;
2282     }
2283 
2284     /**
2285      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
2286      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
2287      *
2288      * _Available since v4.7._
2289      */
2290     function multiProofVerify(
2291         bytes32[] memory proof,
2292         bool[] memory proofFlags,
2293         bytes32 root,
2294         bytes32[] memory leaves
2295     ) internal pure returns (bool) {
2296         return processMultiProof(proof, proofFlags, leaves) == root;
2297     }
2298 
2299     /**
2300      * @dev Calldata version of {multiProofVerify}
2301      *
2302      * _Available since v4.7._
2303      */
2304     function multiProofVerifyCalldata(
2305         bytes32[] calldata proof,
2306         bool[] calldata proofFlags,
2307         bytes32 root,
2308         bytes32[] memory leaves
2309     ) internal pure returns (bool) {
2310         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2311     }
2312 
2313     /**
2314      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
2315      * consuming from one or the other at each step according to the instructions given by
2316      * `proofFlags`.
2317      *
2318      * _Available since v4.7._
2319      */
2320     function processMultiProof(
2321         bytes32[] memory proof,
2322         bool[] memory proofFlags,
2323         bytes32[] memory leaves
2324     ) internal pure returns (bytes32 merkleRoot) {
2325         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2326         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2327         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2328         // the merkle tree.
2329         uint256 leavesLen = leaves.length;
2330         uint256 totalHashes = proofFlags.length;
2331 
2332         // Check proof validity.
2333         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2334 
2335         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2336         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2337         bytes32[] memory hashes = new bytes32[](totalHashes);
2338         uint256 leafPos = 0;
2339         uint256 hashPos = 0;
2340         uint256 proofPos = 0;
2341         // At each step, we compute the next hash using two values:
2342         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2343         //   get the next hash.
2344         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2345         //   `proof` array.
2346         for (uint256 i = 0; i < totalHashes; i++) {
2347             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2348             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2349             hashes[i] = _hashPair(a, b);
2350         }
2351 
2352         if (totalHashes > 0) {
2353             return hashes[totalHashes - 1];
2354         } else if (leavesLen > 0) {
2355             return leaves[0];
2356         } else {
2357             return proof[0];
2358         }
2359     }
2360 
2361     /**
2362      * @dev Calldata version of {processMultiProof}
2363      *
2364      * _Available since v4.7._
2365      */
2366     function processMultiProofCalldata(
2367         bytes32[] calldata proof,
2368         bool[] calldata proofFlags,
2369         bytes32[] memory leaves
2370     ) internal pure returns (bytes32 merkleRoot) {
2371         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2372         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2373         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2374         // the merkle tree.
2375         uint256 leavesLen = leaves.length;
2376         uint256 totalHashes = proofFlags.length;
2377 
2378         // Check proof validity.
2379         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2380 
2381         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2382         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2383         bytes32[] memory hashes = new bytes32[](totalHashes);
2384         uint256 leafPos = 0;
2385         uint256 hashPos = 0;
2386         uint256 proofPos = 0;
2387         // At each step, we compute the next hash using two values:
2388         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2389         //   get the next hash.
2390         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2391         //   `proof` array.
2392         for (uint256 i = 0; i < totalHashes; i++) {
2393             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2394             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2395             hashes[i] = _hashPair(a, b);
2396         }
2397 
2398         if (totalHashes > 0) {
2399             return hashes[totalHashes - 1];
2400         } else if (leavesLen > 0) {
2401             return leaves[0];
2402         } else {
2403             return proof[0];
2404         }
2405     }
2406 
2407     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2408         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2409     }
2410 
2411     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2412         /// @solidity memory-safe-assembly
2413         assembly {
2414             mstore(0x00, a)
2415             mstore(0x20, b)
2416             value := keccak256(0x00, 0x40)
2417         }
2418     }
2419 }
2420 
2421 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
2422 
2423 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
2424 
2425 /**
2426  * @dev Interface for the NFT Royalty Standard.
2427  *
2428  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2429  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2430  *
2431  * _Available since v4.5._
2432  */
2433 interface IERC2981 is IERC165 {
2434     /**
2435      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2436      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2437      */
2438     function royaltyInfo(uint256 tokenId, uint256 salePrice)
2439         external
2440         view
2441         returns (address receiver, uint256 royaltyAmount);
2442 }
2443 
2444 /**
2445  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2446  *
2447  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2448  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2449  *
2450  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2451  * fee is specified in basis points by default.
2452  *
2453  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2454  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2455  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2456  *
2457  * _Available since v4.5._
2458  */
2459 
2460 abstract contract ERC2981 is IERC165, IERC2981 {
2461     /**
2462      * @dev See {IERC165-supportsInterface}.
2463      */
2464     function supportsInterface(bytes4 interfaceId)
2465         public
2466         view
2467         virtual
2468         override
2469         returns (bool)
2470     {
2471         return interfaceId == type(IERC2981).interfaceId;
2472     }
2473 }
2474 
2475 /// @title Base64
2476 /// @notice Provides a function for encoding some bytes in base64
2477 /// @author Brecht Devos <brecht@loopring.org>
2478 library Base64 {
2479     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
2480 
2481     /// @notice Encodes some bytes to the base64 representation
2482     function encode(bytes memory data) internal pure returns (string memory) {
2483         uint256 len = data.length;
2484         if (len == 0) return "";
2485 
2486         // multiply by 4/3 rounded up
2487         uint256 encodedLen = 4 * ((len + 2) / 3);
2488 
2489         // Add some extra buffer at the end
2490         bytes memory result = new bytes(encodedLen + 32);
2491 
2492         bytes memory table = TABLE;
2493 
2494         // solium-disable-next-line security/no-inline-assembly
2495         assembly {
2496             let tablePtr := add(table, 1)
2497             let resultPtr := add(result, 32)
2498 
2499             for {
2500                 let i := 0
2501             } lt(i, len) {
2502 
2503             } {
2504                 i := add(i, 3)
2505                 let input := and(mload(add(data, i)), 0xffffff)
2506 
2507                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
2508                 out := shl(8, out)
2509                 out := add(
2510                     out,
2511                     and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF)
2512                 )
2513                 out := shl(8, out)
2514                 out := add(
2515                     out,
2516                     and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF)
2517                 )
2518                 out := shl(8, out)
2519                 out := add(
2520                     out,
2521                     and(mload(add(tablePtr, and(input, 0x3F))), 0xFF)
2522                 )
2523                 out := shl(224, out)
2524 
2525                 mstore(resultPtr, out)
2526 
2527                 resultPtr := add(resultPtr, 4)
2528             }
2529 
2530             switch mod(len, 3)
2531             case 1 {
2532                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
2533             }
2534             case 2 {
2535                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
2536             }
2537 
2538             mstore(result, encodedLen)
2539         }
2540 
2541         return string(result);
2542     }
2543 }
2544 
2545 contract NFTCollection is ERC721A, ERC2981, AccessControl, Initializable {
2546     using Address for address payable;
2547     using Strings for uint256;
2548 
2549     /// Fixed at deployment time
2550     struct DeploymentConfig {
2551         // Name of the NFT contract.
2552         string name;
2553         // Symbol of the NFT contract.
2554         string symbol;
2555         // The contract owner address. If you wish to own the contract, then set it as your wallet address.
2556         // This is also the wallet that can manage the contract on NFT marketplaces. Use `transferOwnership()`
2557         // to update the contract owner.
2558         address owner;
2559         // The maximum number of tokens that can be minted in this collection.
2560         uint256 maxSupply;
2561         // The number of free token mints reserved for the contract owner
2562         uint256 reservedSupply;
2563         // Treasury address is the address where minting fees can be withdrawn to.
2564         // Use `withdrawFees()` to transfer the entire contract balance to the treasury address.
2565         address payable treasuryAddress;
2566     }
2567 
2568     /// Updatable by admins and owner
2569     struct RuntimeConfig {
2570         // Metadata base URI for tokens, NFTs minted in this contract will have metadata URI of `baseURI` + `tokenID`.
2571         // Set this to reveal token metadata.
2572         string baseURI;
2573         // If true, the base URI of the NFTs minted in the specified contract can be updated after minting (token URIs
2574         // are not frozen on the contract level). This is useful for revealing NFTs after the drop. If false, all the
2575         // NFTs minted in this contract are frozen by default which means token URIs are non-updatable.
2576         bool metadataUpdatable;
2577         /// The maximum number of tokens the user can mint per transaction.
2578         uint256 tokensPerMint;
2579         // Minting price per token for public minting
2580         uint256 publicMintPrice;
2581         // Flag for freezing the public mint price
2582         bool publicMintPriceFrozen;
2583         // Minting price per token for presale minting
2584         uint256 presaleMintPrice;
2585         // Flag for freezing the presale mint price
2586         bool presaleMintPriceFrozen;
2587         // Starting timestamp for public minting.
2588         uint256 publicMintStart;
2589         // Starting timestamp for whitelisted/presale minting.
2590         uint256 presaleMintStart;
2591         // Pre-reveal token URI for placholder metadata. This will be returned for all token IDs until a `baseURI`
2592         // has been set.
2593         string prerevealTokenURI;
2594         // Root of the Merkle tree of whitelisted addresses. This is used to check if a wallet has been whitelisted
2595         // for presale minting.
2596         bytes32 presaleMerkleRoot;
2597         // Secondary market royalties in basis points (100 bps = 1%)
2598         uint256 royaltiesBps;
2599         // Address for royalties
2600         address royaltiesAddress;
2601     }
2602 
2603     struct ContractInfo {
2604         uint256 version;
2605         DeploymentConfig deploymentConfig;
2606         RuntimeConfig runtimeConfig;
2607     }
2608 
2609     event OwnershipTransferred(
2610         address indexed previousOwner,
2611         address indexed newOwner
2612     );
2613 
2614     /*************
2615      * Constants *
2616      *************/
2617 
2618     /// Contract version, semver-style uint X_YY_ZZ
2619     uint256 public constant VERSION = 1_03_00;
2620 
2621     /// Admin role
2622     bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
2623 
2624     // Basis for calculating royalties.
2625     // This has to be 10k for royaltiesBps to be in basis points.
2626     uint16 public constant ROYALTIES_BASIS = 10000;
2627 
2628     /********************
2629      * Public variables *
2630      ********************/
2631 
2632     /// The number of tokens remaining in the reserve
2633     /// @dev Managed by the contract
2634     uint256 public reserveRemaining;
2635 
2636     /***************************
2637      * Contract initialization *
2638      ***************************/
2639 
2640     constructor() ERC721A("", "") {
2641         _preventInitialization = true;
2642     }
2643 
2644     /// Contract initializer
2645     function initialize(
2646         DeploymentConfig memory deploymentConfig,
2647         RuntimeConfig memory runtimeConfig
2648     ) public initializer {
2649         require(!_preventInitialization, "Cannot be initialized");
2650         _validateDeploymentConfig(deploymentConfig);
2651 
2652         _grantRole(ADMIN_ROLE, msg.sender);
2653         _transferOwnership(deploymentConfig.owner);
2654 
2655         _deploymentConfig = deploymentConfig;
2656         _runtimeConfig = runtimeConfig;
2657 
2658         reserveRemaining = deploymentConfig.reservedSupply;
2659     }
2660 
2661     /****************
2662      * User actions *
2663      ****************/
2664 
2665     /// Mint tokens
2666     function mint(uint256 amount)
2667         external
2668         payable
2669         paymentProvided(amount * _runtimeConfig.publicMintPrice)
2670     {
2671         require(mintingActive(), "Minting has not started yet");
2672 
2673         _mintTokens(msg.sender, amount);
2674     }
2675 
2676     /// Mint tokens if the wallet has been whitelisted
2677     function presaleMint(uint256 amount, bytes32[] calldata proof)
2678         external
2679         payable
2680         paymentProvided(amount * _runtimeConfig.presaleMintPrice)
2681     {
2682         require(presaleActive(), "Presale has not started yet");
2683         require(
2684             isWhitelisted(msg.sender, proof),
2685             "Not whitelisted for presale"
2686         );
2687 
2688         _presaleMinted[msg.sender] = true;
2689         _mintTokens(msg.sender, amount);
2690     }
2691 
2692     /******************
2693      * View functions *
2694      ******************/
2695 
2696     /// Check if public minting is active
2697     function mintingActive() public view returns (bool) {
2698         // We need to rely on block.timestamp since it's
2699         // asier to configure across different chains
2700         // solhint-disable-next-line not-rely-on-time
2701         return block.timestamp > _runtimeConfig.publicMintStart;
2702     }
2703 
2704     /// Check if presale minting is active
2705     function presaleActive() public view returns (bool) {
2706         // We need to rely on block.timestamp since it's
2707         // easier to configure across different chains
2708         // solhint-disable-next-line not-rely-on-time
2709         return block.timestamp > _runtimeConfig.presaleMintStart;
2710     }
2711 
2712     /// Get the number of tokens still available for minting
2713     function availableSupply() public view returns (uint256) {
2714         return _deploymentConfig.maxSupply - totalSupply() - reserveRemaining;
2715     }
2716 
2717     /// Check if the wallet is whitelisted for the presale
2718     function isWhitelisted(address wallet, bytes32[] calldata proof)
2719         public
2720         view
2721         returns (bool)
2722     {
2723         require(!_presaleMinted[wallet], "Already minted");
2724 
2725         bytes32 leaf = keccak256(abi.encodePacked(wallet));
2726 
2727         return
2728             MerkleProof.verify(proof, _runtimeConfig.presaleMerkleRoot, leaf);
2729     }
2730 
2731     /// 判断是否已经presaleMint address
2732     function didPresaleMinted(address wallet) public view returns (bool) {
2733         return _presaleMinted[wallet];
2734     }
2735 
2736     /// Contract owner address
2737     /// @dev Required for easy integration with OpenSea
2738     function owner() public view returns (address) {
2739         return _deploymentConfig.owner;
2740     }
2741 
2742     /*******************
2743      * Access controls *
2744      *******************/
2745 
2746     /// Transfer contract ownership
2747     function transferOwnership(address newOwner)
2748         external
2749         onlyRole(DEFAULT_ADMIN_ROLE)
2750     {
2751         require(newOwner != _deploymentConfig.owner, "Already the owner");
2752         _transferOwnership(newOwner);
2753     }
2754 
2755     /// Transfer contract ownership
2756     function transferAdminRights(address to) external onlyRole(ADMIN_ROLE) {
2757         require(!hasRole(ADMIN_ROLE, to), "Already an admin");
2758         require(msg.sender != _deploymentConfig.owner, "Use transferOwnership");
2759 
2760         _revokeRole(ADMIN_ROLE, msg.sender);
2761         _grantRole(ADMIN_ROLE, to);
2762     }
2763 
2764     /*****************
2765      * Admin actions *
2766      *****************/
2767 
2768     /// Mint a token from the reserve
2769     function reserveMint(address to, uint256 amount)
2770         external
2771         onlyRole(ADMIN_ROLE)
2772     {
2773         require(amount <= reserveRemaining, "Not enough reserved");
2774 
2775         reserveRemaining -= amount;
2776         _mintTokens(to, amount);
2777     }
2778 
2779     /// Get full contract information
2780     /// @dev Convenience helper
2781     function getInfo() external view returns (ContractInfo memory info) {
2782         info.version = VERSION;
2783         info.deploymentConfig = _deploymentConfig;
2784         info.runtimeConfig = _runtimeConfig;
2785     }
2786 
2787     /// Update contract configuration
2788     /// @dev Callable by admin roles only
2789     function updateConfig(RuntimeConfig calldata newConfig)
2790         external
2791         onlyRole(ADMIN_ROLE)
2792     {
2793         _validateRuntimeConfig(newConfig);
2794         _runtimeConfig = newConfig;
2795     }
2796 
2797     /// Withdraw minting fees to the treasury address
2798     /// @dev Callable by admin roles only
2799     function withdrawFees() external onlyRole(ADMIN_ROLE) {
2800         _deploymentConfig.treasuryAddress.sendValue(address(this).balance);
2801     }
2802 
2803     /*************
2804      * Internals *
2805      *************/
2806 
2807     /// Contract configuration
2808     RuntimeConfig internal _runtimeConfig;
2809     DeploymentConfig internal _deploymentConfig;
2810 
2811     /// Flag for disabling initalization for template contracts
2812     bool internal _preventInitialization;
2813 
2814     /// Mapping for tracking presale mint status
2815     mapping(address => bool) internal _presaleMinted;
2816 
2817     /// @dev Internal function for performing token mints
2818     function _mintTokens(address to, uint256 amount) internal {
2819         require(amount <= _runtimeConfig.tokensPerMint, "Amount too large");
2820         require(amount <= availableSupply(), "Not enough tokens left");
2821 
2822         _safeMint(to, amount);
2823     }
2824 
2825     /// Validate deployment config
2826     function _validateDeploymentConfig(DeploymentConfig memory config)
2827         internal
2828         pure
2829     {
2830         require(config.maxSupply > 0, "Maximum supply must be non-zero");
2831         require(
2832             config.treasuryAddress != address(0),
2833             "Treasury address cannot be null"
2834         );
2835         require(config.owner != address(0), "Contract must have an owner");
2836         require(
2837             config.reservedSupply <= config.maxSupply,
2838             "Reserve greater than supply"
2839         );
2840     }
2841 
2842     /// Validate a runtime configuration change
2843     function _validateRuntimeConfig(RuntimeConfig calldata config)
2844         internal
2845         view
2846     {
2847         // Can't set royalties to more than 100%
2848         require(config.royaltiesBps <= ROYALTIES_BASIS, "Royalties too high");
2849         require(config.tokensPerMint > 0, "Tokens per mint must be non-zero");
2850 
2851         // Validate mint price changes
2852         _validatePublicMintPrice(config);
2853         _validatePresaleMintPrice(config);
2854 
2855         // Validate metadata changes
2856         _validateMetadata(config);
2857     }
2858 
2859     function _validatePublicMintPrice(RuntimeConfig calldata config)
2860         internal
2861         view
2862     {
2863         // As long as public mint price is not frozen, all changes are valid
2864         if (!_runtimeConfig.publicMintPriceFrozen) return;
2865 
2866         // Can't change public mint price once frozen
2867         require(
2868             _runtimeConfig.publicMintPrice == config.publicMintPrice,
2869             "publicMintPrice is frozen"
2870         );
2871 
2872         // Can't unfreeze public mint price
2873         require(
2874             config.publicMintPriceFrozen,
2875             "publicMintPriceFrozen is frozen"
2876         );
2877     }
2878 
2879     function _validatePresaleMintPrice(RuntimeConfig calldata config)
2880         internal
2881         view
2882     {
2883         // As long as presale mint price is not frozen, all changes are valid
2884         if (!_runtimeConfig.presaleMintPriceFrozen) return;
2885 
2886         // Can't change presale mint price once frozen
2887         require(
2888             _runtimeConfig.presaleMintPrice == config.presaleMintPrice,
2889             "presaleMintPrice is frozen"
2890         );
2891 
2892         // Can't unfreeze presale mint price
2893         require(
2894             config.presaleMintPriceFrozen,
2895             "presaleMintPriceFrozen is frozen"
2896         );
2897     }
2898 
2899     function _validateMetadata(RuntimeConfig calldata config) internal view {
2900         // If metadata is updatable, we don't have any other limitations
2901         if (_runtimeConfig.metadataUpdatable) return;
2902 
2903         // If it isn't, we can't allow the flag to change anymore
2904         require(!config.metadataUpdatable, "Cannot unfreeze metadata");
2905 
2906         // We also can't allow base URI to change
2907         require(
2908             keccak256(abi.encodePacked(_runtimeConfig.baseURI)) ==
2909                 keccak256(abi.encodePacked(config.baseURI)),
2910             "Metadata is frozen"
2911         );
2912     }
2913 
2914     /// Internal function without any checks for performing the ownership transfer
2915     function _transferOwnership(address newOwner) internal {
2916         address previousOwner = _deploymentConfig.owner;
2917         _revokeRole(ADMIN_ROLE, previousOwner);
2918         _revokeRole(DEFAULT_ADMIN_ROLE, previousOwner);
2919 
2920         _deploymentConfig.owner = newOwner;
2921         _grantRole(ADMIN_ROLE, newOwner);
2922         _grantRole(DEFAULT_ADMIN_ROLE, newOwner);
2923 
2924         emit OwnershipTransferred(previousOwner, newOwner);
2925     }
2926 
2927     /// @dev See {IERC165-supportsInterface}.
2928     function supportsInterface(bytes4 interfaceId)
2929         public
2930         view
2931         override(ERC721A, AccessControl, ERC2981)
2932         returns (bool)
2933     {
2934         return
2935             ERC721A.supportsInterface(interfaceId) ||
2936             AccessControl.supportsInterface(interfaceId) ||
2937             ERC2981.supportsInterface(interfaceId);
2938     }
2939 
2940     /// Get the token metadata URI
2941     function tokenURI(uint256 tokenId)
2942         public
2943         view
2944         override
2945         returns (string memory)
2946     {
2947         require(_exists(tokenId), "Token does not exist");
2948 
2949         return
2950             bytes(_runtimeConfig.baseURI).length > 0
2951                 ? string(
2952                     abi.encodePacked(_runtimeConfig.baseURI, tokenId.toString())
2953                 )
2954                 : _runtimeConfig.prerevealTokenURI;
2955     }
2956 
2957     /// @dev Need name() to support setting it in the initializer instead of constructor
2958     function name() public view override returns (string memory) {
2959         return _deploymentConfig.name;
2960     }
2961 
2962     /// @dev Need symbol() to support setting it in the initializer instead of constructor
2963     function symbol() public view override returns (string memory) {
2964         return _deploymentConfig.symbol;
2965     }
2966 
2967     /// @dev ERC2981 token royalty info
2968     function royaltyInfo(uint256, uint256 salePrice)
2969         external
2970         view
2971         returns (address receiver, uint256 royaltyAmount)
2972     {
2973         receiver = _runtimeConfig.royaltiesAddress;
2974         royaltyAmount =
2975             (_runtimeConfig.royaltiesBps * salePrice) /
2976             ROYALTIES_BASIS;
2977     }
2978 
2979     /// @dev OpenSea contract metadata
2980     function contractURI() external view returns (string memory) {
2981         string memory json = Base64.encode(
2982             bytes(
2983                 string(
2984                     abi.encodePacked(
2985                         '{"seller_fee_basis_points": ', // solhint-disable-line quotes
2986                         _runtimeConfig.royaltiesBps.toString(),
2987                         ', "fee_recipient": "', // solhint-disable-line quotes
2988                         uint256(uint160(_runtimeConfig.royaltiesAddress))
2989                             .toHexString(20),
2990                         '"}' // solhint-disable-line quotes
2991                     )
2992                 )
2993             )
2994         );
2995 
2996         string memory output = string(
2997             abi.encodePacked("data:application/json;base64,", json)
2998         );
2999 
3000         return output;
3001     }
3002 
3003     /// Check if enough payment was provided
3004     modifier paymentProvided(uint256 payment) {
3005         require(msg.value >= payment, "Payment too small");
3006         _;
3007     }
3008 
3009     /***********************
3010      * Convenience getters *
3011      ***********************/
3012 
3013     function maxSupply() public view returns (uint256) {
3014         return _deploymentConfig.maxSupply;
3015     }
3016 
3017     function reservedSupply() public view returns (uint256) {
3018         return _deploymentConfig.reservedSupply;
3019     }
3020 
3021     function publicMintPrice() public view returns (uint256) {
3022         return _runtimeConfig.publicMintPrice;
3023     }
3024 
3025     function presaleMintPrice() public view returns (uint256) {
3026         return _runtimeConfig.presaleMintPrice;
3027     }
3028 
3029     function tokensPerMint() public view returns (uint256) {
3030         return _runtimeConfig.tokensPerMint;
3031     }
3032 
3033     function treasuryAddress() public view returns (address) {
3034         return _deploymentConfig.treasuryAddress;
3035     }
3036 
3037     function publicMintStart() public view returns (uint256) {
3038         return _runtimeConfig.publicMintStart;
3039     }
3040 
3041     function presaleMintStart() public view returns (uint256) {
3042         return _runtimeConfig.presaleMintStart;
3043     }
3044 
3045     function presaleMerkleRoot() public view returns (bytes32) {
3046         return _runtimeConfig.presaleMerkleRoot;
3047     }
3048 
3049     function baseURI() public view returns (string memory) {
3050         return _runtimeConfig.baseURI;
3051     }
3052 
3053     function metadataUpdatable() public view returns (bool) {
3054         return _runtimeConfig.metadataUpdatable;
3055     }
3056 
3057     function prerevealTokenURI() public view returns (string memory) {
3058         return _runtimeConfig.prerevealTokenURI;
3059     }
3060 }
3061 
3062 contract NFTCollectionContract is NFTCollection {
3063     constructor(
3064         DeploymentConfig memory deploymentConfig,
3065         RuntimeConfig memory runtimeConfig
3066     ) {
3067         _preventInitialization = false;
3068         initialize(deploymentConfig, runtimeConfig);
3069     }
3070 }