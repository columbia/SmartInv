1 // File: erc721a/contracts/IERC721A.sol
2 
3 
4 // ERC721A Contracts v4.2.2
5 // Creator: Chiru Labs
6 
7 pragma solidity ^0.8.4;
8 
9 /**
10  * @dev Interface of ERC721A.
11  */
12 interface IERC721A {
13     /**
14      * The caller must own the token or be an approved operator.
15      */
16     error ApprovalCallerNotOwnerNorApproved();
17 
18     /**
19      * The token does not exist.
20      */
21     error ApprovalQueryForNonexistentToken();
22 
23     /**
24      * The caller cannot approve to their own address.
25      */
26     error ApproveToCaller();
27 
28     /**
29      * Cannot query the balance for the zero address.
30      */
31     error BalanceQueryForZeroAddress();
32 
33     /**
34      * Cannot mint to the zero address.
35      */
36     error MintToZeroAddress();
37 
38     /**
39      * The quantity of tokens minted must be more than zero.
40      */
41     error MintZeroQuantity();
42 
43     /**
44      * The token does not exist.
45      */
46     error OwnerQueryForNonexistentToken();
47 
48     /**
49      * The caller must own the token or be an approved operator.
50      */
51     error TransferCallerNotOwnerNorApproved();
52 
53     /**
54      * The token must be owned by `from`.
55      */
56     error TransferFromIncorrectOwner();
57 
58     /**
59      * Cannot safely transfer to a contract that does not implement the
60      * ERC721Receiver interface.
61      */
62     error TransferToNonERC721ReceiverImplementer();
63 
64     /**
65      * Cannot transfer to the zero address.
66      */
67     error TransferToZeroAddress();
68 
69     /**
70      * The token does not exist.
71      */
72     error URIQueryForNonexistentToken();
73 
74     /**
75      * The `quantity` minted with ERC2309 exceeds the safety limit.
76      */
77     error MintERC2309QuantityExceedsLimit();
78 
79     /**
80      * The `extraData` cannot be set on an unintialized ownership slot.
81      */
82     error OwnershipNotInitializedForExtraData();
83 
84     // =============================================================
85     //                            STRUCTS
86     // =============================================================
87 
88     struct TokenOwnership {
89         // The address of the owner.
90         address addr;
91         // Stores the start time of ownership with minimal overhead for tokenomics.
92         uint64 startTimestamp;
93         // Whether the token has been burned.
94         bool burned;
95         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
96         uint24 extraData;
97     }
98 
99     // =============================================================
100     //                         TOKEN COUNTERS
101     // =============================================================
102 
103     /**
104      * @dev Returns the total number of tokens in existence.
105      * Burned tokens will reduce the count.
106      * To get the total number of tokens minted, please see {_totalMinted}.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     // =============================================================
111     //                            IERC165
112     // =============================================================
113 
114     /**
115      * @dev Returns true if this contract implements the interface defined by
116      * `interfaceId`. See the corresponding
117      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
118      * to learn more about how these ids are created.
119      *
120      * This function call must use less than 30000 gas.
121      */
122     function supportsInterface(bytes4 interfaceId) external view returns (bool);
123 
124     // =============================================================
125     //                            IERC721
126     // =============================================================
127 
128     /**
129      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
135      */
136     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables or disables
140      * (`approved`) `operator` to manage all of its assets.
141      */
142     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
143 
144     /**
145      * @dev Returns the number of tokens in `owner`'s account.
146      */
147     function balanceOf(address owner) external view returns (uint256 balance);
148 
149     /**
150      * @dev Returns the owner of the `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function ownerOf(uint256 tokenId) external view returns (address owner);
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`,
160      * checking first that contract recipients are aware of the ERC721 protocol
161      * to prevent tokens from being forever locked.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be have been allowed to move
169      * this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement
171      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId,
179         bytes calldata data
180     ) external;
181 
182     /**
183      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Transfers `tokenId` from `from` to `to`.
193      *
194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
195      * whenever possible.
196      *
197      * Requirements:
198      *
199      * - `from` cannot be the zero address.
200      * - `to` cannot be the zero address.
201      * - `tokenId` token must be owned by `from`.
202      * - If the caller is not `from`, it must be approved to move this token
203      * by either {approve} or {setApprovalForAll}.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 tokenId
211     ) external;
212 
213     /**
214      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
215      * The approval is cleared when the token is transferred.
216      *
217      * Only a single account can be approved at a time, so approving the
218      * zero address clears previous approvals.
219      *
220      * Requirements:
221      *
222      * - The caller must own the token or be an approved operator.
223      * - `tokenId` must exist.
224      *
225      * Emits an {Approval} event.
226      */
227     function approve(address to, uint256 tokenId) external;
228 
229     /**
230      * @dev Approve or remove `operator` as an operator for the caller.
231      * Operators can call {transferFrom} or {safeTransferFrom}
232      * for any token owned by the caller.
233      *
234      * Requirements:
235      *
236      * - The `operator` cannot be the caller.
237      *
238      * Emits an {ApprovalForAll} event.
239      */
240     function setApprovalForAll(address operator, bool _approved) external;
241 
242     /**
243      * @dev Returns the account approved for `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function getApproved(uint256 tokenId) external view returns (address operator);
250 
251     /**
252      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
253      *
254      * See {setApprovalForAll}.
255      */
256     function isApprovedForAll(address owner, address operator) external view returns (bool);
257 
258     // =============================================================
259     //                        IERC721Metadata
260     // =============================================================
261 
262     /**
263      * @dev Returns the token collection name.
264      */
265     function name() external view returns (string memory);
266 
267     /**
268      * @dev Returns the token collection symbol.
269      */
270     function symbol() external view returns (string memory);
271 
272     /**
273      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
274      */
275     function tokenURI(uint256 tokenId) external view returns (string memory);
276 
277     // =============================================================
278     //                           IERC2309
279     // =============================================================
280 
281     /**
282      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
283      * (inclusive) is transferred from `from` to `to`, as defined in the
284      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
285      *
286      * See {_mintERC2309} for more details.
287      */
288     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
289 }
290 
291 // File: erc721a/contracts/ERC721A.sol
292 
293 
294 // ERC721A Contracts v4.2.2
295 // Creator: Chiru Labs
296 
297 pragma solidity ^0.8.4;
298 
299 
300 /**
301  * @dev Interface of ERC721 token receiver.
302  */
303 interface ERC721A__IERC721Receiver {
304     function onERC721Received(
305         address operator,
306         address from,
307         uint256 tokenId,
308         bytes calldata data
309     ) external returns (bytes4);
310 }
311 
312 /**
313  * @title ERC721A
314  *
315  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
316  * Non-Fungible Token Standard, including the Metadata extension.
317  * Optimized for lower gas during batch mints.
318  *
319  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
320  * starting from `_startTokenId()`.
321  *
322  * Assumptions:
323  *
324  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
325  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
326  */
327 contract ERC721A is IERC721A {
328     // Reference type for token approval.
329     struct TokenApprovalRef {
330         address value;
331     }
332 
333     // =============================================================
334     //                           CONSTANTS
335     // =============================================================
336 
337     // Mask of an entry in packed address data.
338     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
339 
340     // The bit position of `numberMinted` in packed address data.
341     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
342 
343     // The bit position of `numberBurned` in packed address data.
344     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
345 
346     // The bit position of `aux` in packed address data.
347     uint256 private constant _BITPOS_AUX = 192;
348 
349     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
350     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
351 
352     // The bit position of `startTimestamp` in packed ownership.
353     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
354 
355     // The bit mask of the `burned` bit in packed ownership.
356     uint256 private constant _BITMASK_BURNED = 1 << 224;
357 
358     // The bit position of the `nextInitialized` bit in packed ownership.
359     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
360 
361     // The bit mask of the `nextInitialized` bit in packed ownership.
362     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
363 
364     // The bit position of `extraData` in packed ownership.
365     uint256 private constant _BITPOS_EXTRA_DATA = 232;
366 
367     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
368     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
369 
370     // The mask of the lower 160 bits for addresses.
371     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
372 
373     // The maximum `quantity` that can be minted with {_mintERC2309}.
374     // This limit is to prevent overflows on the address data entries.
375     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
376     // is required to cause an overflow, which is unrealistic.
377     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
378 
379     // The `Transfer` event signature is given by:
380     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
381     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
382         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
383 
384     // =============================================================
385     //                            STORAGE
386     // =============================================================
387 
388     // The next token ID to be minted.
389     uint256 private _currentIndex;
390 
391     // The number of tokens burned.
392     uint256 private _burnCounter;
393 
394     // Token name
395     string private _name;
396 
397     // Token symbol
398     string private _symbol;
399 
400     // Mapping from token ID to ownership details
401     // An empty struct value does not necessarily mean the token is unowned.
402     // See {_packedOwnershipOf} implementation for details.
403     //
404     // Bits Layout:
405     // - [0..159]   `addr`
406     // - [160..223] `startTimestamp`
407     // - [224]      `burned`
408     // - [225]      `nextInitialized`
409     // - [232..255] `extraData`
410     mapping(uint256 => uint256) private _packedOwnerships;
411 
412     // Mapping owner address to address data.
413     //
414     // Bits Layout:
415     // - [0..63]    `balance`
416     // - [64..127]  `numberMinted`
417     // - [128..191] `numberBurned`
418     // - [192..255] `aux`
419     mapping(address => uint256) private _packedAddressData;
420 
421     // Mapping from token ID to approved address.
422     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
423 
424     // Mapping from owner to operator approvals
425     mapping(address => mapping(address => bool)) private _operatorApprovals;
426 
427     // =============================================================
428     //                          CONSTRUCTOR
429     // =============================================================
430 
431     constructor(string memory name_, string memory symbol_) {
432         _name = name_;
433         _symbol = symbol_;
434         _currentIndex = _startTokenId();
435     }
436 
437     // =============================================================
438     //                   TOKEN COUNTING OPERATIONS
439     // =============================================================
440 
441     /**
442      * @dev Returns the starting token ID.
443      * To change the starting token ID, please override this function.
444      */
445     function _startTokenId() internal view virtual returns (uint256) {
446         return 0;
447     }
448 
449     /**
450      * @dev Returns the next token ID to be minted.
451      */
452     function _nextTokenId() internal view virtual returns (uint256) {
453         return _currentIndex;
454     }
455 
456     /**
457      * @dev Returns the total number of tokens in existence.
458      * Burned tokens will reduce the count.
459      * To get the total number of tokens minted, please see {_totalMinted}.
460      */
461     function totalSupply() public view virtual override returns (uint256) {
462         // Counter underflow is impossible as _burnCounter cannot be incremented
463         // more than `_currentIndex - _startTokenId()` times.
464         unchecked {
465             return _currentIndex - _burnCounter - _startTokenId();
466         }
467     }
468 
469     /**
470      * @dev Returns the total amount of tokens minted in the contract.
471      */
472     function _totalMinted() internal view virtual returns (uint256) {
473         // Counter underflow is impossible as `_currentIndex` does not decrement,
474         // and it is initialized to `_startTokenId()`.
475         unchecked {
476             return _currentIndex - _startTokenId();
477         }
478     }
479 
480     /**
481      * @dev Returns the total number of tokens burned.
482      */
483     function _totalBurned() internal view virtual returns (uint256) {
484         return _burnCounter;
485     }
486 
487     // =============================================================
488     //                    ADDRESS DATA OPERATIONS
489     // =============================================================
490 
491     /**
492      * @dev Returns the number of tokens in `owner`'s account.
493      */
494     function balanceOf(address owner) public view virtual override returns (uint256) {
495         if (owner == address(0)) revert BalanceQueryForZeroAddress();
496         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
497     }
498 
499     /**
500      * Returns the number of tokens minted by `owner`.
501      */
502     function _numberMinted(address owner) internal view returns (uint256) {
503         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
504     }
505 
506     /**
507      * Returns the number of tokens burned by or on behalf of `owner`.
508      */
509     function _numberBurned(address owner) internal view returns (uint256) {
510         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
511     }
512 
513     /**
514      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
515      */
516     function _getAux(address owner) internal view returns (uint64) {
517         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
518     }
519 
520     /**
521      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
522      * If there are multiple variables, please pack them into a uint64.
523      */
524     function _setAux(address owner, uint64 aux) internal virtual {
525         uint256 packed = _packedAddressData[owner];
526         uint256 auxCasted;
527         // Cast `aux` with assembly to avoid redundant masking.
528         assembly {
529             auxCasted := aux
530         }
531         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
532         _packedAddressData[owner] = packed;
533     }
534 
535     // =============================================================
536     //                            IERC165
537     // =============================================================
538 
539     /**
540      * @dev Returns true if this contract implements the interface defined by
541      * `interfaceId`. See the corresponding
542      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
543      * to learn more about how these ids are created.
544      *
545      * This function call must use less than 30000 gas.
546      */
547     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548         // The interface IDs are constants representing the first 4 bytes
549         // of the XOR of all function selectors in the interface.
550         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
551         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
552         return
553             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
554             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
555             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
556     }
557 
558     // =============================================================
559     //                        IERC721Metadata
560     // =============================================================
561 
562     /**
563      * @dev Returns the token collection name.
564      */
565     function name() public view virtual override returns (string memory) {
566         return _name;
567     }
568 
569     /**
570      * @dev Returns the token collection symbol.
571      */
572     function symbol() public view virtual override returns (string memory) {
573         return _symbol;
574     }
575 
576     /**
577      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
578      */
579     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
580         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
581 
582         string memory baseURI = _baseURI();
583         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
584     }
585 
586     /**
587      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
588      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
589      * by default, it can be overridden in child contracts.
590      */
591     function _baseURI() internal view virtual returns (string memory) {
592         return '';
593     }
594 
595     // =============================================================
596     //                     OWNERSHIPS OPERATIONS
597     // =============================================================
598 
599     /**
600      * @dev Returns the owner of the `tokenId` token.
601      *
602      * Requirements:
603      *
604      * - `tokenId` must exist.
605      */
606     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
607         return address(uint160(_packedOwnershipOf(tokenId)));
608     }
609 
610     /**
611      * @dev Gas spent here starts off proportional to the maximum mint batch size.
612      * It gradually moves to O(1) as tokens get transferred around over time.
613      */
614     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
615         return _unpackedOwnership(_packedOwnershipOf(tokenId));
616     }
617 
618     /**
619      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
620      */
621     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
622         return _unpackedOwnership(_packedOwnerships[index]);
623     }
624 
625     /**
626      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
627      */
628     function _initializeOwnershipAt(uint256 index) internal virtual {
629         if (_packedOwnerships[index] == 0) {
630             _packedOwnerships[index] = _packedOwnershipOf(index);
631         }
632     }
633 
634     /**
635      * Returns the packed ownership data of `tokenId`.
636      */
637     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
638         uint256 curr = tokenId;
639 
640         unchecked {
641             if (_startTokenId() <= curr)
642                 if (curr < _currentIndex) {
643                     uint256 packed = _packedOwnerships[curr];
644                     // If not burned.
645                     if (packed & _BITMASK_BURNED == 0) {
646                         // Invariant:
647                         // There will always be an initialized ownership slot
648                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
649                         // before an unintialized ownership slot
650                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
651                         // Hence, `curr` will not underflow.
652                         //
653                         // We can directly compare the packed value.
654                         // If the address is zero, packed will be zero.
655                         while (packed == 0) {
656                             packed = _packedOwnerships[--curr];
657                         }
658                         return packed;
659                     }
660                 }
661         }
662         revert OwnerQueryForNonexistentToken();
663     }
664 
665     /**
666      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
667      */
668     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
669         ownership.addr = address(uint160(packed));
670         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
671         ownership.burned = packed & _BITMASK_BURNED != 0;
672         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
673     }
674 
675     /**
676      * @dev Packs ownership data into a single uint256.
677      */
678     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
679         assembly {
680             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
681             owner := and(owner, _BITMASK_ADDRESS)
682             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
683             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
684         }
685     }
686 
687     /**
688      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
689      */
690     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
691         // For branchless setting of the `nextInitialized` flag.
692         assembly {
693             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
694             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
695         }
696     }
697 
698     // =============================================================
699     //                      APPROVAL OPERATIONS
700     // =============================================================
701 
702     /**
703      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
704      * The approval is cleared when the token is transferred.
705      *
706      * Only a single account can be approved at a time, so approving the
707      * zero address clears previous approvals.
708      *
709      * Requirements:
710      *
711      * - The caller must own the token or be an approved operator.
712      * - `tokenId` must exist.
713      *
714      * Emits an {Approval} event.
715      */
716     function approve(address to, uint256 tokenId) public virtual override {
717         address owner = ownerOf(tokenId);
718 
719         if (_msgSenderERC721A() != owner)
720             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
721                 revert ApprovalCallerNotOwnerNorApproved();
722             }
723 
724         _tokenApprovals[tokenId].value = to;
725         emit Approval(owner, to, tokenId);
726     }
727 
728     /**
729      * @dev Returns the account approved for `tokenId` token.
730      *
731      * Requirements:
732      *
733      * - `tokenId` must exist.
734      */
735     function getApproved(uint256 tokenId) public view virtual override returns (address) {
736         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
737 
738         return _tokenApprovals[tokenId].value;
739     }
740 
741     /**
742      * @dev Approve or remove `operator` as an operator for the caller.
743      * Operators can call {transferFrom} or {safeTransferFrom}
744      * for any token owned by the caller.
745      *
746      * Requirements:
747      *
748      * - The `operator` cannot be the caller.
749      *
750      * Emits an {ApprovalForAll} event.
751      */
752     function setApprovalForAll(address operator, bool approved) public virtual override {
753         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
754 
755         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
756         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
757     }
758 
759     /**
760      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
761      *
762      * See {setApprovalForAll}.
763      */
764     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
765         return _operatorApprovals[owner][operator];
766     }
767 
768     /**
769      * @dev Returns whether `tokenId` exists.
770      *
771      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
772      *
773      * Tokens start existing when they are minted. See {_mint}.
774      */
775     function _exists(uint256 tokenId) internal view virtual returns (bool) {
776         return
777             _startTokenId() <= tokenId &&
778             tokenId < _currentIndex && // If within bounds,
779             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
780     }
781 
782     /**
783      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
784      */
785     function _isSenderApprovedOrOwner(
786         address approvedAddress,
787         address owner,
788         address msgSender
789     ) private pure returns (bool result) {
790         assembly {
791             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
792             owner := and(owner, _BITMASK_ADDRESS)
793             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
794             msgSender := and(msgSender, _BITMASK_ADDRESS)
795             // `msgSender == owner || msgSender == approvedAddress`.
796             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
797         }
798     }
799 
800     /**
801      * @dev Returns the storage slot and value for the approved address of `tokenId`.
802      */
803     function _getApprovedSlotAndAddress(uint256 tokenId)
804         private
805         view
806         returns (uint256 approvedAddressSlot, address approvedAddress)
807     {
808         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
809         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
810         assembly {
811             approvedAddressSlot := tokenApproval.slot
812             approvedAddress := sload(approvedAddressSlot)
813         }
814     }
815 
816     // =============================================================
817     //                      TRANSFER OPERATIONS
818     // =============================================================
819 
820     /**
821      * @dev Transfers `tokenId` from `from` to `to`.
822      *
823      * Requirements:
824      *
825      * - `from` cannot be the zero address.
826      * - `to` cannot be the zero address.
827      * - `tokenId` token must be owned by `from`.
828      * - If the caller is not `from`, it must be approved to move this token
829      * by either {approve} or {setApprovalForAll}.
830      *
831      * Emits a {Transfer} event.
832      */
833     function transferFrom(
834         address from,
835         address to,
836         uint256 tokenId
837     ) public virtual override {
838         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
839 
840         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
841 
842         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
843 
844         // The nested ifs save around 20+ gas over a compound boolean condition.
845         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
846             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
847 
848         if (to == address(0)) revert TransferToZeroAddress();
849 
850         _beforeTokenTransfers(from, to, tokenId, 1);
851 
852         // Clear approvals from the previous owner.
853         assembly {
854             if approvedAddress {
855                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
856                 sstore(approvedAddressSlot, 0)
857             }
858         }
859 
860         // Underflow of the sender's balance is impossible because we check for
861         // ownership above and the recipient's balance can't realistically overflow.
862         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
863         unchecked {
864             // We can directly increment and decrement the balances.
865             --_packedAddressData[from]; // Updates: `balance -= 1`.
866             ++_packedAddressData[to]; // Updates: `balance += 1`.
867 
868             // Updates:
869             // - `address` to the next owner.
870             // - `startTimestamp` to the timestamp of transfering.
871             // - `burned` to `false`.
872             // - `nextInitialized` to `true`.
873             _packedOwnerships[tokenId] = _packOwnershipData(
874                 to,
875                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
876             );
877 
878             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
879             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
880                 uint256 nextTokenId = tokenId + 1;
881                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
882                 if (_packedOwnerships[nextTokenId] == 0) {
883                     // If the next slot is within bounds.
884                     if (nextTokenId != _currentIndex) {
885                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
886                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
887                     }
888                 }
889             }
890         }
891 
892         emit Transfer(from, to, tokenId);
893         _afterTokenTransfers(from, to, tokenId, 1);
894     }
895 
896     /**
897      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId
903     ) public virtual override {
904         safeTransferFrom(from, to, tokenId, '');
905     }
906 
907     /**
908      * @dev Safely transfers `tokenId` token from `from` to `to`.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must exist and be owned by `from`.
915      * - If the caller is not `from`, it must be approved to move this token
916      * by either {approve} or {setApprovalForAll}.
917      * - If `to` refers to a smart contract, it must implement
918      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
919      *
920      * Emits a {Transfer} event.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId,
926         bytes memory _data
927     ) public virtual override {
928         transferFrom(from, to, tokenId);
929         if (to.code.length != 0)
930             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
931                 revert TransferToNonERC721ReceiverImplementer();
932             }
933     }
934 
935     /**
936      * @dev Hook that is called before a set of serially-ordered token IDs
937      * are about to be transferred. This includes minting.
938      * And also called before burning one token.
939      *
940      * `startTokenId` - the first token ID to be transferred.
941      * `quantity` - the amount to be transferred.
942      *
943      * Calling conditions:
944      *
945      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
946      * transferred to `to`.
947      * - When `from` is zero, `tokenId` will be minted for `to`.
948      * - When `to` is zero, `tokenId` will be burned by `from`.
949      * - `from` and `to` are never both zero.
950      */
951     function _beforeTokenTransfers(
952         address from,
953         address to,
954         uint256 startTokenId,
955         uint256 quantity
956     ) internal virtual {}
957 
958     /**
959      * @dev Hook that is called after a set of serially-ordered token IDs
960      * have been transferred. This includes minting.
961      * And also called after one token has been burned.
962      *
963      * `startTokenId` - the first token ID to be transferred.
964      * `quantity` - the amount to be transferred.
965      *
966      * Calling conditions:
967      *
968      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
969      * transferred to `to`.
970      * - When `from` is zero, `tokenId` has been minted for `to`.
971      * - When `to` is zero, `tokenId` has been burned by `from`.
972      * - `from` and `to` are never both zero.
973      */
974     function _afterTokenTransfers(
975         address from,
976         address to,
977         uint256 startTokenId,
978         uint256 quantity
979     ) internal virtual {}
980 
981     /**
982      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
983      *
984      * `from` - Previous owner of the given token ID.
985      * `to` - Target address that will receive the token.
986      * `tokenId` - Token ID to be transferred.
987      * `_data` - Optional data to send along with the call.
988      *
989      * Returns whether the call correctly returned the expected magic value.
990      */
991     function _checkContractOnERC721Received(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) private returns (bool) {
997         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
998             bytes4 retval
999         ) {
1000             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1001         } catch (bytes memory reason) {
1002             if (reason.length == 0) {
1003                 revert TransferToNonERC721ReceiverImplementer();
1004             } else {
1005                 assembly {
1006                     revert(add(32, reason), mload(reason))
1007                 }
1008             }
1009         }
1010     }
1011 
1012     // =============================================================
1013     //                        MINT OPERATIONS
1014     // =============================================================
1015 
1016     /**
1017      * @dev Mints `quantity` tokens and transfers them to `to`.
1018      *
1019      * Requirements:
1020      *
1021      * - `to` cannot be the zero address.
1022      * - `quantity` must be greater than 0.
1023      *
1024      * Emits a {Transfer} event for each mint.
1025      */
1026     function _mint(address to, uint256 quantity) internal virtual {
1027         uint256 startTokenId = _currentIndex;
1028         if (quantity == 0) revert MintZeroQuantity();
1029 
1030         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1031 
1032         // Overflows are incredibly unrealistic.
1033         // `balance` and `numberMinted` have a maximum limit of 2**64.
1034         // `tokenId` has a maximum limit of 2**256.
1035         unchecked {
1036             // Updates:
1037             // - `balance += quantity`.
1038             // - `numberMinted += quantity`.
1039             //
1040             // We can directly add to the `balance` and `numberMinted`.
1041             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1042 
1043             // Updates:
1044             // - `address` to the owner.
1045             // - `startTimestamp` to the timestamp of minting.
1046             // - `burned` to `false`.
1047             // - `nextInitialized` to `quantity == 1`.
1048             _packedOwnerships[startTokenId] = _packOwnershipData(
1049                 to,
1050                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1051             );
1052 
1053             uint256 toMasked;
1054             uint256 end = startTokenId + quantity;
1055 
1056             // Use assembly to loop and emit the `Transfer` event for gas savings.
1057             assembly {
1058                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1059                 toMasked := and(to, _BITMASK_ADDRESS)
1060                 // Emit the `Transfer` event.
1061                 log4(
1062                     0, // Start of data (0, since no data).
1063                     0, // End of data (0, since no data).
1064                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1065                     0, // `address(0)`.
1066                     toMasked, // `to`.
1067                     startTokenId // `tokenId`.
1068                 )
1069 
1070                 for {
1071                     let tokenId := add(startTokenId, 1)
1072                 } iszero(eq(tokenId, end)) {
1073                     tokenId := add(tokenId, 1)
1074                 } {
1075                     // Emit the `Transfer` event. Similar to above.
1076                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1077                 }
1078             }
1079             if (toMasked == 0) revert MintToZeroAddress();
1080 
1081             _currentIndex = end;
1082         }
1083         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1084     }
1085 
1086     /**
1087      * @dev Mints `quantity` tokens and transfers them to `to`.
1088      *
1089      * This function is intended for efficient minting only during contract creation.
1090      *
1091      * It emits only one {ConsecutiveTransfer} as defined in
1092      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1093      * instead of a sequence of {Transfer} event(s).
1094      *
1095      * Calling this function outside of contract creation WILL make your contract
1096      * non-compliant with the ERC721 standard.
1097      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1098      * {ConsecutiveTransfer} event is only permissible during contract creation.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `quantity` must be greater than 0.
1104      *
1105      * Emits a {ConsecutiveTransfer} event.
1106      */
1107     function _mintERC2309(address to, uint256 quantity) internal virtual {
1108         uint256 startTokenId = _currentIndex;
1109         if (to == address(0)) revert MintToZeroAddress();
1110         if (quantity == 0) revert MintZeroQuantity();
1111         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1112 
1113         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1114 
1115         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1116         unchecked {
1117             // Updates:
1118             // - `balance += quantity`.
1119             // - `numberMinted += quantity`.
1120             //
1121             // We can directly add to the `balance` and `numberMinted`.
1122             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1123 
1124             // Updates:
1125             // - `address` to the owner.
1126             // - `startTimestamp` to the timestamp of minting.
1127             // - `burned` to `false`.
1128             // - `nextInitialized` to `quantity == 1`.
1129             _packedOwnerships[startTokenId] = _packOwnershipData(
1130                 to,
1131                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1132             );
1133 
1134             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1135 
1136             _currentIndex = startTokenId + quantity;
1137         }
1138         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1139     }
1140 
1141     /**
1142      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1143      *
1144      * Requirements:
1145      *
1146      * - If `to` refers to a smart contract, it must implement
1147      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1148      * - `quantity` must be greater than 0.
1149      *
1150      * See {_mint}.
1151      *
1152      * Emits a {Transfer} event for each mint.
1153      */
1154     function _safeMint(
1155         address to,
1156         uint256 quantity,
1157         bytes memory _data
1158     ) internal virtual {
1159         _mint(to, quantity);
1160 
1161         unchecked {
1162             if (to.code.length != 0) {
1163                 uint256 end = _currentIndex;
1164                 uint256 index = end - quantity;
1165                 do {
1166                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1167                         revert TransferToNonERC721ReceiverImplementer();
1168                     }
1169                 } while (index < end);
1170                 // Reentrancy protection.
1171                 if (_currentIndex != end) revert();
1172             }
1173         }
1174     }
1175 
1176     /**
1177      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1178      */
1179     function _safeMint(address to, uint256 quantity) internal virtual {
1180         _safeMint(to, quantity, '');
1181     }
1182 
1183     // =============================================================
1184     //                        BURN OPERATIONS
1185     // =============================================================
1186 
1187     /**
1188      * @dev Equivalent to `_burn(tokenId, false)`.
1189      */
1190     function _burn(uint256 tokenId) internal virtual {
1191         _burn(tokenId, false);
1192     }
1193 
1194     /**
1195      * @dev Destroys `tokenId`.
1196      * The approval is cleared when the token is burned.
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must exist.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1205         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1206 
1207         address from = address(uint160(prevOwnershipPacked));
1208 
1209         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1210 
1211         if (approvalCheck) {
1212             // The nested ifs save around 20+ gas over a compound boolean condition.
1213             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1214                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1215         }
1216 
1217         _beforeTokenTransfers(from, address(0), tokenId, 1);
1218 
1219         // Clear approvals from the previous owner.
1220         assembly {
1221             if approvedAddress {
1222                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1223                 sstore(approvedAddressSlot, 0)
1224             }
1225         }
1226 
1227         // Underflow of the sender's balance is impossible because we check for
1228         // ownership above and the recipient's balance can't realistically overflow.
1229         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1230         unchecked {
1231             // Updates:
1232             // - `balance -= 1`.
1233             // - `numberBurned += 1`.
1234             //
1235             // We can directly decrement the balance, and increment the number burned.
1236             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1237             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1238 
1239             // Updates:
1240             // - `address` to the last owner.
1241             // - `startTimestamp` to the timestamp of burning.
1242             // - `burned` to `true`.
1243             // - `nextInitialized` to `true`.
1244             _packedOwnerships[tokenId] = _packOwnershipData(
1245                 from,
1246                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1247             );
1248 
1249             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1250             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1251                 uint256 nextTokenId = tokenId + 1;
1252                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1253                 if (_packedOwnerships[nextTokenId] == 0) {
1254                     // If the next slot is within bounds.
1255                     if (nextTokenId != _currentIndex) {
1256                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1257                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1258                     }
1259                 }
1260             }
1261         }
1262 
1263         emit Transfer(from, address(0), tokenId);
1264         _afterTokenTransfers(from, address(0), tokenId, 1);
1265 
1266         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1267         unchecked {
1268             _burnCounter++;
1269         }
1270     }
1271 
1272     // =============================================================
1273     //                     EXTRA DATA OPERATIONS
1274     // =============================================================
1275 
1276     /**
1277      * @dev Directly sets the extra data for the ownership data `index`.
1278      */
1279     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1280         uint256 packed = _packedOwnerships[index];
1281         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1282         uint256 extraDataCasted;
1283         // Cast `extraData` with assembly to avoid redundant masking.
1284         assembly {
1285             extraDataCasted := extraData
1286         }
1287         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1288         _packedOwnerships[index] = packed;
1289     }
1290 
1291     /**
1292      * @dev Called during each token transfer to set the 24bit `extraData` field.
1293      * Intended to be overridden by the cosumer contract.
1294      *
1295      * `previousExtraData` - the value of `extraData` before transfer.
1296      *
1297      * Calling conditions:
1298      *
1299      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1300      * transferred to `to`.
1301      * - When `from` is zero, `tokenId` will be minted for `to`.
1302      * - When `to` is zero, `tokenId` will be burned by `from`.
1303      * - `from` and `to` are never both zero.
1304      */
1305     function _extraData(
1306         address from,
1307         address to,
1308         uint24 previousExtraData
1309     ) internal view virtual returns (uint24) {}
1310 
1311     /**
1312      * @dev Returns the next extra data for the packed ownership data.
1313      * The returned result is shifted into position.
1314      */
1315     function _nextExtraData(
1316         address from,
1317         address to,
1318         uint256 prevOwnershipPacked
1319     ) private view returns (uint256) {
1320         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1321         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1322     }
1323 
1324     // =============================================================
1325     //                       OTHER OPERATIONS
1326     // =============================================================
1327 
1328     /**
1329      * @dev Returns the message sender (defaults to `msg.sender`).
1330      *
1331      * If you are writing GSN compatible contracts, you need to override this function.
1332      */
1333     function _msgSenderERC721A() internal view virtual returns (address) {
1334         return msg.sender;
1335     }
1336 
1337     /**
1338      * @dev Converts a uint256 to its ASCII string decimal representation.
1339      */
1340     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1341         assembly {
1342             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1343             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1344             // We will need 1 32-byte word to store the length,
1345             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1346             str := add(mload(0x40), 0x80)
1347             // Update the free memory pointer to allocate.
1348             mstore(0x40, str)
1349 
1350             // Cache the end of the memory to calculate the length later.
1351             let end := str
1352 
1353             // We write the string from rightmost digit to leftmost digit.
1354             // The following is essentially a do-while loop that also handles the zero case.
1355             // prettier-ignore
1356             for { let temp := value } 1 {} {
1357                 str := sub(str, 1)
1358                 // Write the character to the pointer.
1359                 // The ASCII index of the '0' character is 48.
1360                 mstore8(str, add(48, mod(temp, 10)))
1361                 // Keep dividing `temp` until zero.
1362                 temp := div(temp, 10)
1363                 // prettier-ignore
1364                 if iszero(temp) { break }
1365             }
1366 
1367             let length := sub(end, str)
1368             // Move the pointer 32 bytes leftwards to make room for the length.
1369             str := sub(str, 0x20)
1370             // Store the length.
1371             mstore(str, length)
1372         }
1373     }
1374 }
1375 
1376 // File: @openzeppelin/contracts/utils/Context.sol
1377 
1378 
1379 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1380 
1381 pragma solidity ^0.8.0;
1382 
1383 /**
1384  * @dev Provides information about the current execution context, including the
1385  * sender of the transaction and its data. While these are generally available
1386  * via msg.sender and msg.data, they should not be accessed in such a direct
1387  * manner, since when dealing with meta-transactions the account sending and
1388  * paying for execution may not be the actual sender (as far as an application
1389  * is concerned).
1390  *
1391  * This contract is only required for intermediate, library-like contracts.
1392  */
1393 abstract contract Context {
1394     function _msgSender() internal view virtual returns (address) {
1395         return msg.sender;
1396     }
1397 
1398     function _msgData() internal view virtual returns (bytes calldata) {
1399         return msg.data;
1400     }
1401 }
1402 
1403 // File: @openzeppelin/contracts/access/Ownable.sol
1404 
1405 
1406 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1407 
1408 pragma solidity ^0.8.0;
1409 
1410 
1411 /**
1412  * @dev Contract module which provides a basic access control mechanism, where
1413  * there is an account (an owner) that can be granted exclusive access to
1414  * specific functions.
1415  *
1416  * By default, the owner account will be the one that deploys the contract. This
1417  * can later be changed with {transferOwnership}.
1418  *
1419  * This module is used through inheritance. It will make available the modifier
1420  * `onlyOwner`, which can be applied to your functions to restrict their use to
1421  * the owner.
1422  */
1423 abstract contract Ownable is Context {
1424     address private _owner;
1425 
1426     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1427 
1428     /**
1429      * @dev Initializes the contract setting the deployer as the initial owner.
1430      */
1431     constructor() {
1432         _transferOwnership(_msgSender());
1433     }
1434 
1435     /**
1436      * @dev Throws if called by any account other than the owner.
1437      */
1438     modifier onlyOwner() {
1439         _checkOwner();
1440         _;
1441     }
1442 
1443     /**
1444      * @dev Returns the address of the current owner.
1445      */
1446     function owner() public view virtual returns (address) {
1447         return _owner;
1448     }
1449 
1450     /**
1451      * @dev Throws if the sender is not the owner.
1452      */
1453     function _checkOwner() internal view virtual {
1454         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1455     }
1456 
1457     /**
1458      * @dev Leaves the contract without owner. It will not be possible to call
1459      * `onlyOwner` functions anymore. Can only be called by the current owner.
1460      *
1461      * NOTE: Renouncing ownership will leave the contract without an owner,
1462      * thereby removing any functionality that is only available to the owner.
1463      */
1464     function renounceOwnership() public virtual onlyOwner {
1465         _transferOwnership(address(0));
1466     }
1467 
1468     /**
1469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1470      * Can only be called by the current owner.
1471      */
1472     function transferOwnership(address newOwner) public virtual onlyOwner {
1473         require(newOwner != address(0), "Ownable: new owner is the zero address");
1474         _transferOwnership(newOwner);
1475     }
1476 
1477     /**
1478      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1479      * Internal function without access restriction.
1480      */
1481     function _transferOwnership(address newOwner) internal virtual {
1482         address oldOwner = _owner;
1483         _owner = newOwner;
1484         emit OwnershipTransferred(oldOwner, newOwner);
1485     }
1486 }
1487 
1488 // File: contracts/whoamai.sol
1489 
1490 
1491 // WhoAMAI contract
1492 // submitted 8-25-22
1493 
1494 pragma solidity ^0.8.16;
1495 
1496 
1497 
1498 contract WhoAmAI is ERC721A, Ownable {
1499     uint256 public immutable MAX_PER_WALLET;
1500     uint256 public immutable MAX_FREE_PER_WALLET;
1501     uint256 public immutable maxSupply;
1502     uint256 public immutable maxFree;
1503     uint256 public price = 0.00404 ether;
1504     bool public isMintActive;
1505     string private baseURI_;
1506     string private _contractURI;
1507 
1508     mapping(address => uint256) private minters;
1509 
1510     constructor(
1511         uint256 _maxSupply,
1512         uint256 _maxFree,
1513         uint256 _freeTokensPerWallet,
1514         uint256 _tokensPerWallet
1515     ) ERC721A("WhoAmAI?", "WAMAI") {
1516         maxSupply = _maxSupply;
1517         maxFree = _maxFree;
1518         MAX_FREE_PER_WALLET = _freeTokensPerWallet;
1519         MAX_PER_WALLET = _tokensPerWallet;
1520     }
1521 
1522     modifier mintIsActive() {
1523         require(isMintActive, "Sale is not active");
1524         _;
1525     }
1526 
1527     modifier notSoldOut(uint256 amount) {
1528         require(totalSupply() + amount <= maxSupply, "Sold out");
1529         _;
1530     }
1531 
1532     function changeSaleStatus(bool _status) external onlyOwner {
1533         isMintActive = _status;
1534     }
1535 
1536     function ownerMint(uint256 _amount) public onlyOwner notSoldOut(_amount) {
1537         _safeMint(msg.sender, _amount);
1538     }
1539 
1540     function mint(uint256 _amount)
1541         public
1542         payable
1543         mintIsActive
1544         notSoldOut(_amount)
1545     {
1546         if (totalSupply() + _amount <= maxFree) {
1547             require(
1548                 minters[msg.sender] + _amount <= MAX_FREE_PER_WALLET,
1549                 "Invalid amount"
1550             );
1551             minters[msg.sender] += _amount;
1552             _safeMint(msg.sender, _amount);
1553         } else {
1554             require(
1555                 minters[msg.sender] + _amount <= MAX_PER_WALLET,
1556                 "Invalid amount"
1557             );
1558             require(msg.value * _amount >= price * _amount, "Invalid value");
1559             minters[msg.sender] += _amount;
1560             _safeMint(msg.sender, _amount);
1561         }
1562     }
1563 
1564     function _baseURI() internal view override returns (string memory) {
1565         return baseURI_;
1566     }
1567 
1568     function setBaseURI(string calldata _newBaseURI) public onlyOwner {
1569         baseURI_ = _newBaseURI;
1570     }
1571 
1572     function setMintPrice(uint256 _price) public onlyOwner {
1573         price = _price;
1574     }
1575 
1576     function withdraw() public onlyOwner {
1577         payable(msg.sender).transfer(address(this).balance);
1578     }
1579 }