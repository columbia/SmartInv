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
1376 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1377 
1378 
1379 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1380 
1381 pragma solidity ^0.8.0;
1382 
1383 /**
1384  * @dev Contract module that helps prevent reentrant calls to a function.
1385  *
1386  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1387  * available, which can be applied to functions to make sure there are no nested
1388  * (reentrant) calls to them.
1389  *
1390  * Note that because there is a single `nonReentrant` guard, functions marked as
1391  * `nonReentrant` may not call one another. This can be worked around by making
1392  * those functions `private`, and then adding `external` `nonReentrant` entry
1393  * points to them.
1394  *
1395  * TIP: If you would like to learn more about reentrancy and alternative ways
1396  * to protect against it, check out our blog post
1397  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1398  */
1399 abstract contract ReentrancyGuard {
1400     // Booleans are more expensive than uint256 or any type that takes up a full
1401     // word because each write operation emits an extra SLOAD to first read the
1402     // slot's contents, replace the bits taken up by the boolean, and then write
1403     // back. This is the compiler's defense against contract upgrades and
1404     // pointer aliasing, and it cannot be disabled.
1405 
1406     // The values being non-zero value makes deployment a bit more expensive,
1407     // but in exchange the refund on every call to nonReentrant will be lower in
1408     // amount. Since refunds are capped to a percentage of the total
1409     // transaction's gas, it is best to keep them low in cases like this one, to
1410     // increase the likelihood of the full refund coming into effect.
1411     uint256 private constant _NOT_ENTERED = 1;
1412     uint256 private constant _ENTERED = 2;
1413 
1414     uint256 private _status;
1415 
1416     constructor() {
1417         _status = _NOT_ENTERED;
1418     }
1419 
1420     /**
1421      * @dev Prevents a contract from calling itself, directly or indirectly.
1422      * Calling a `nonReentrant` function from another `nonReentrant`
1423      * function is not supported. It is possible to prevent this from happening
1424      * by making the `nonReentrant` function external, and making it call a
1425      * `private` function that does the actual work.
1426      */
1427     modifier nonReentrant() {
1428         // On the first call to nonReentrant, _notEntered will be true
1429         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1430 
1431         // Any calls to nonReentrant after this point will fail
1432         _status = _ENTERED;
1433 
1434         _;
1435 
1436         // By storing the original value once again, a refund is triggered (see
1437         // https://eips.ethereum.org/EIPS/eip-2200)
1438         _status = _NOT_ENTERED;
1439     }
1440 }
1441 
1442 // File: @openzeppelin/contracts/utils/Address.sol
1443 
1444 
1445 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1446 
1447 pragma solidity ^0.8.1;
1448 
1449 /**
1450  * @dev Collection of functions related to the address type
1451  */
1452 library Address {
1453     /**
1454      * @dev Returns true if `account` is a contract.
1455      *
1456      * [IMPORTANT]
1457      * ====
1458      * It is unsafe to assume that an address for which this function returns
1459      * false is an externally-owned account (EOA) and not a contract.
1460      *
1461      * Among others, `isContract` will return false for the following
1462      * types of addresses:
1463      *
1464      *  - an externally-owned account
1465      *  - a contract in construction
1466      *  - an address where a contract will be created
1467      *  - an address where a contract lived, but was destroyed
1468      * ====
1469      *
1470      * [IMPORTANT]
1471      * ====
1472      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1473      *
1474      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1475      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1476      * constructor.
1477      * ====
1478      */
1479     function isContract(address account) internal view returns (bool) {
1480         // This method relies on extcodesize/address.code.length, which returns 0
1481         // for contracts in construction, since the code is only stored at the end
1482         // of the constructor execution.
1483 
1484         return account.code.length > 0;
1485     }
1486 
1487     /**
1488      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1489      * `recipient`, forwarding all available gas and reverting on errors.
1490      *
1491      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1492      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1493      * imposed by `transfer`, making them unable to receive funds via
1494      * `transfer`. {sendValue} removes this limitation.
1495      *
1496      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1497      *
1498      * IMPORTANT: because control is transferred to `recipient`, care must be
1499      * taken to not create reentrancy vulnerabilities. Consider using
1500      * {ReentrancyGuard} or the
1501      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1502      */
1503     function sendValue(address payable recipient, uint256 amount) internal {
1504         require(address(this).balance >= amount, "Address: insufficient balance");
1505 
1506         (bool success, ) = recipient.call{value: amount}("");
1507         require(success, "Address: unable to send value, recipient may have reverted");
1508     }
1509 
1510     /**
1511      * @dev Performs a Solidity function call using a low level `call`. A
1512      * plain `call` is an unsafe replacement for a function call: use this
1513      * function instead.
1514      *
1515      * If `target` reverts with a revert reason, it is bubbled up by this
1516      * function (like regular Solidity function calls).
1517      *
1518      * Returns the raw returned data. To convert to the expected return value,
1519      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1520      *
1521      * Requirements:
1522      *
1523      * - `target` must be a contract.
1524      * - calling `target` with `data` must not revert.
1525      *
1526      * _Available since v3.1._
1527      */
1528     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1529         return functionCall(target, data, "Address: low-level call failed");
1530     }
1531 
1532     /**
1533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1534      * `errorMessage` as a fallback revert reason when `target` reverts.
1535      *
1536      * _Available since v3.1._
1537      */
1538     function functionCall(
1539         address target,
1540         bytes memory data,
1541         string memory errorMessage
1542     ) internal returns (bytes memory) {
1543         return functionCallWithValue(target, data, 0, errorMessage);
1544     }
1545 
1546     /**
1547      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1548      * but also transferring `value` wei to `target`.
1549      *
1550      * Requirements:
1551      *
1552      * - the calling contract must have an ETH balance of at least `value`.
1553      * - the called Solidity function must be `payable`.
1554      *
1555      * _Available since v3.1._
1556      */
1557     function functionCallWithValue(
1558         address target,
1559         bytes memory data,
1560         uint256 value
1561     ) internal returns (bytes memory) {
1562         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1563     }
1564 
1565     /**
1566      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1567      * with `errorMessage` as a fallback revert reason when `target` reverts.
1568      *
1569      * _Available since v3.1._
1570      */
1571     function functionCallWithValue(
1572         address target,
1573         bytes memory data,
1574         uint256 value,
1575         string memory errorMessage
1576     ) internal returns (bytes memory) {
1577         require(address(this).balance >= value, "Address: insufficient balance for call");
1578         require(isContract(target), "Address: call to non-contract");
1579 
1580         (bool success, bytes memory returndata) = target.call{value: value}(data);
1581         return verifyCallResult(success, returndata, errorMessage);
1582     }
1583 
1584     /**
1585      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1586      * but performing a static call.
1587      *
1588      * _Available since v3.3._
1589      */
1590     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1591         return functionStaticCall(target, data, "Address: low-level static call failed");
1592     }
1593 
1594     /**
1595      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1596      * but performing a static call.
1597      *
1598      * _Available since v3.3._
1599      */
1600     function functionStaticCall(
1601         address target,
1602         bytes memory data,
1603         string memory errorMessage
1604     ) internal view returns (bytes memory) {
1605         require(isContract(target), "Address: static call to non-contract");
1606 
1607         (bool success, bytes memory returndata) = target.staticcall(data);
1608         return verifyCallResult(success, returndata, errorMessage);
1609     }
1610 
1611     /**
1612      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1613      * but performing a delegate call.
1614      *
1615      * _Available since v3.4._
1616      */
1617     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1618         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1619     }
1620 
1621     /**
1622      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1623      * but performing a delegate call.
1624      *
1625      * _Available since v3.4._
1626      */
1627     function functionDelegateCall(
1628         address target,
1629         bytes memory data,
1630         string memory errorMessage
1631     ) internal returns (bytes memory) {
1632         require(isContract(target), "Address: delegate call to non-contract");
1633 
1634         (bool success, bytes memory returndata) = target.delegatecall(data);
1635         return verifyCallResult(success, returndata, errorMessage);
1636     }
1637 
1638     /**
1639      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1640      * revert reason using the provided one.
1641      *
1642      * _Available since v4.3._
1643      */
1644     function verifyCallResult(
1645         bool success,
1646         bytes memory returndata,
1647         string memory errorMessage
1648     ) internal pure returns (bytes memory) {
1649         if (success) {
1650             return returndata;
1651         } else {
1652             // Look for revert reason and bubble it up if present
1653             if (returndata.length > 0) {
1654                 // The easiest way to bubble the revert reason is using memory via assembly
1655                 /// @solidity memory-safe-assembly
1656                 assembly {
1657                     let returndata_size := mload(returndata)
1658                     revert(add(32, returndata), returndata_size)
1659                 }
1660             } else {
1661                 revert(errorMessage);
1662             }
1663         }
1664     }
1665 }
1666 
1667 // File: @openzeppelin/contracts/utils/Strings.sol
1668 
1669 
1670 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1671 
1672 pragma solidity ^0.8.0;
1673 
1674 /**
1675  * @dev String operations.
1676  */
1677 library Strings {
1678     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1679     uint8 private constant _ADDRESS_LENGTH = 20;
1680 
1681     /**
1682      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1683      */
1684     function toString(uint256 value) internal pure returns (string memory) {
1685         // Inspired by OraclizeAPI's implementation - MIT licence
1686         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1687 
1688         if (value == 0) {
1689             return "0";
1690         }
1691         uint256 temp = value;
1692         uint256 digits;
1693         while (temp != 0) {
1694             digits++;
1695             temp /= 10;
1696         }
1697         bytes memory buffer = new bytes(digits);
1698         while (value != 0) {
1699             digits -= 1;
1700             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1701             value /= 10;
1702         }
1703         return string(buffer);
1704     }
1705 
1706     /**
1707      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1708      */
1709     function toHexString(uint256 value) internal pure returns (string memory) {
1710         if (value == 0) {
1711             return "0x00";
1712         }
1713         uint256 temp = value;
1714         uint256 length = 0;
1715         while (temp != 0) {
1716             length++;
1717             temp >>= 8;
1718         }
1719         return toHexString(value, length);
1720     }
1721 
1722     /**
1723      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1724      */
1725     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1726         bytes memory buffer = new bytes(2 * length + 2);
1727         buffer[0] = "0";
1728         buffer[1] = "x";
1729         for (uint256 i = 2 * length + 1; i > 1; --i) {
1730             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1731             value >>= 4;
1732         }
1733         require(value == 0, "Strings: hex length insufficient");
1734         return string(buffer);
1735     }
1736 
1737     /**
1738      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1739      */
1740     function toHexString(address addr) internal pure returns (string memory) {
1741         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1742     }
1743 }
1744 
1745 // File: @openzeppelin/contracts/utils/Context.sol
1746 
1747 
1748 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1749 
1750 pragma solidity ^0.8.0;
1751 
1752 /**
1753  * @dev Provides information about the current execution context, including the
1754  * sender of the transaction and its data. While these are generally available
1755  * via msg.sender and msg.data, they should not be accessed in such a direct
1756  * manner, since when dealing with meta-transactions the account sending and
1757  * paying for execution may not be the actual sender (as far as an application
1758  * is concerned).
1759  *
1760  * This contract is only required for intermediate, library-like contracts.
1761  */
1762 abstract contract Context {
1763     function _msgSender() internal view virtual returns (address) {
1764         return msg.sender;
1765     }
1766 
1767     function _msgData() internal view virtual returns (bytes calldata) {
1768         return msg.data;
1769     }
1770 }
1771 
1772 // File: @openzeppelin/contracts/security/Pausable.sol
1773 
1774 
1775 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1776 
1777 pragma solidity ^0.8.0;
1778 
1779 
1780 /**
1781  * @dev Contract module which allows children to implement an emergency stop
1782  * mechanism that can be triggered by an authorized account.
1783  *
1784  * This module is used through inheritance. It will make available the
1785  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1786  * the functions of your contract. Note that they will not be pausable by
1787  * simply including this module, only once the modifiers are put in place.
1788  */
1789 abstract contract Pausable is Context {
1790     /**
1791      * @dev Emitted when the pause is triggered by `account`.
1792      */
1793     event Paused(address account);
1794 
1795     /**
1796      * @dev Emitted when the pause is lifted by `account`.
1797      */
1798     event Unpaused(address account);
1799 
1800     bool private _paused;
1801 
1802     /**
1803      * @dev Initializes the contract in unpaused state.
1804      */
1805     constructor() {
1806         _paused = false;
1807     }
1808 
1809     /**
1810      * @dev Modifier to make a function callable only when the contract is not paused.
1811      *
1812      * Requirements:
1813      *
1814      * - The contract must not be paused.
1815      */
1816     modifier whenNotPaused() {
1817         _requireNotPaused();
1818         _;
1819     }
1820 
1821     /**
1822      * @dev Modifier to make a function callable only when the contract is paused.
1823      *
1824      * Requirements:
1825      *
1826      * - The contract must be paused.
1827      */
1828     modifier whenPaused() {
1829         _requirePaused();
1830         _;
1831     }
1832 
1833     /**
1834      * @dev Returns true if the contract is paused, and false otherwise.
1835      */
1836     function paused() public view virtual returns (bool) {
1837         return _paused;
1838     }
1839 
1840     /**
1841      * @dev Throws if the contract is paused.
1842      */
1843     function _requireNotPaused() internal view virtual {
1844         require(!paused(), "Pausable: paused");
1845     }
1846 
1847     /**
1848      * @dev Throws if the contract is not paused.
1849      */
1850     function _requirePaused() internal view virtual {
1851         require(paused(), "Pausable: not paused");
1852     }
1853 
1854     /**
1855      * @dev Triggers stopped state.
1856      *
1857      * Requirements:
1858      *
1859      * - The contract must not be paused.
1860      */
1861     function _pause() internal virtual whenNotPaused {
1862         _paused = true;
1863         emit Paused(_msgSender());
1864     }
1865 
1866     /**
1867      * @dev Returns to normal state.
1868      *
1869      * Requirements:
1870      *
1871      * - The contract must be paused.
1872      */
1873     function _unpause() internal virtual whenPaused {
1874         _paused = false;
1875         emit Unpaused(_msgSender());
1876     }
1877 }
1878 
1879 // File: @openzeppelin/contracts/access/Ownable.sol
1880 
1881 
1882 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1883 
1884 pragma solidity ^0.8.0;
1885 
1886 
1887 /**
1888  * @dev Contract module which provides a basic access control mechanism, where
1889  * there is an account (an owner) that can be granted exclusive access to
1890  * specific functions.
1891  *
1892  * By default, the owner account will be the one that deploys the contract. This
1893  * can later be changed with {transferOwnership}.
1894  *
1895  * This module is used through inheritance. It will make available the modifier
1896  * `onlyOwner`, which can be applied to your functions to restrict their use to
1897  * the owner.
1898  */
1899 abstract contract Ownable is Context {
1900     address private _owner;
1901 
1902     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1903 
1904     /**
1905      * @dev Initializes the contract setting the deployer as the initial owner.
1906      */
1907     constructor() {
1908         _transferOwnership(_msgSender());
1909     }
1910 
1911     /**
1912      * @dev Throws if called by any account other than the owner.
1913      */
1914     modifier onlyOwner() {
1915         _checkOwner();
1916         _;
1917     }
1918 
1919     /**
1920      * @dev Returns the address of the current owner.
1921      */
1922     function owner() public view virtual returns (address) {
1923         return _owner;
1924     }
1925 
1926     /**
1927      * @dev Throws if the sender is not the owner.
1928      */
1929     function _checkOwner() internal view virtual {
1930         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1931     }
1932 
1933     /**
1934      * @dev Leaves the contract without owner. It will not be possible to call
1935      * `onlyOwner` functions anymore. Can only be called by the current owner.
1936      *
1937      * NOTE: Renouncing ownership will leave the contract without an owner,
1938      * thereby removing any functionality that is only available to the owner.
1939      */
1940     function renounceOwnership() public virtual onlyOwner {
1941         _transferOwnership(address(0));
1942     }
1943 
1944     /**
1945      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1946      * Can only be called by the current owner.
1947      */
1948     function transferOwnership(address newOwner) public virtual onlyOwner {
1949         require(newOwner != address(0), "Ownable: new owner is the zero address");
1950         _transferOwnership(newOwner);
1951     }
1952 
1953     /**
1954      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1955      * Internal function without access restriction.
1956      */
1957     function _transferOwnership(address newOwner) internal virtual {
1958         address oldOwner = _owner;
1959         _owner = newOwner;
1960         emit OwnershipTransferred(oldOwner, newOwner);
1961     }
1962 }
1963 
1964 // File: contracts/RobotTown.sol
1965 
1966 
1967 
1968 pragma solidity ^0.8.0;
1969 
1970 
1971 
1972 
1973 
1974 
1975 
1976 contract RobotTown is ERC721A, Ownable, ReentrancyGuard {
1977   using Address for address;
1978   using Strings for uint;
1979 
1980   string  public  baseTokenURI = "";
1981   uint256  public  maxSupply = 1984;
1982   uint256 public  MAX_MINTS_PER_TX = 20;
1983   uint256 public  PUBLIC_SALE_PRICE = 0.001 ether;
1984   uint256 public  NUM_FREE_MINTS = 999;
1985   uint256 public  MAX_FREE_PER_WALLET = 1;
1986   bool public isPublicSaleActive = true;
1987 
1988   constructor(
1989 
1990   ) ERC721A("Robot Town", "RT") {
1991 
1992   }
1993 
1994   function mint(uint256 numberOfTokens)
1995       external
1996       payable
1997   {
1998     require(isPublicSaleActive, "Public sale is not open");
1999     require(totalSupply() + numberOfTokens < maxSupply + 1, "No more");
2000 
2001     if(totalSupply() > NUM_FREE_MINTS){
2002         require(
2003             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2004             "Incorrect ETH value sent"
2005         );
2006     } else {
2007         if (numberOfTokens > MAX_FREE_PER_WALLET) {
2008         require(
2009             (PUBLIC_SALE_PRICE * numberOfTokens) <= msg.value,
2010             "Incorrect ETH value sent"
2011         );
2012         require(
2013             numberOfTokens <= MAX_MINTS_PER_TX,
2014             "Max mints per transaction exceeded"
2015         );
2016         } else {
2017             require(
2018                 numberOfTokens <= MAX_FREE_PER_WALLET,
2019                 "Max mints per transaction exceeded"
2020             );
2021         }
2022     }
2023     _safeMint(msg.sender, numberOfTokens);
2024   }
2025 
2026   function setBaseURI(string memory baseURI)
2027     public
2028     onlyOwner
2029   {
2030     baseTokenURI = baseURI;
2031   }
2032 
2033   function _startTokenId() internal override view virtual returns (uint256) {
2034     return 1;
2035   }
2036 
2037   function treasuryMint(uint quantity)
2038     public
2039     onlyOwner
2040   {
2041     require(
2042       quantity > 0,
2043       "Invalid mint amount"
2044     );
2045     require(
2046       totalSupply() + quantity <= maxSupply,
2047       "Maximum supply exceeded"
2048     );
2049     _safeMint(msg.sender, quantity);
2050   }
2051 
2052   function withdraw()
2053     public
2054     onlyOwner
2055     nonReentrant
2056   {
2057     Address.sendValue(payable(msg.sender), address(this).balance);
2058   }
2059 
2060   function tokenURI(uint _tokenId)
2061     public
2062     view
2063     virtual
2064     override
2065     returns (string memory)
2066   {
2067     require(
2068       _exists(_tokenId),
2069       "ERC721Metadata: URI query for nonexistent token"
2070     );
2071     return string(abi.encodePacked(baseTokenURI, "/", _tokenId.toString(), ".json"));
2072   }
2073 
2074   function _baseURI()
2075     internal
2076     view
2077     virtual
2078     override
2079     returns (string memory)
2080   {
2081     return baseTokenURI;
2082   }
2083 
2084   function setIsPublicSaleActive(bool _isPublicSaleActive)
2085       external
2086       onlyOwner
2087   {
2088       isPublicSaleActive = _isPublicSaleActive;
2089   }
2090 
2091   function setNumFreeMints(uint256 _numfreemints)
2092       external
2093       onlyOwner
2094   {
2095       NUM_FREE_MINTS = _numfreemints;
2096   }
2097 
2098   function setMaxSupply(uint256 _maxSupply)
2099       external
2100       onlyOwner
2101   {
2102       maxSupply = _maxSupply;
2103   }
2104 
2105   function setSalePrice(uint256 _price)
2106       external
2107       onlyOwner
2108   {
2109       PUBLIC_SALE_PRICE = _price;
2110   }
2111 
2112   function setMaxLimitPerTransaction(uint256 _limit)
2113       external
2114       onlyOwner
2115   {
2116       MAX_MINTS_PER_TX = _limit;
2117   }
2118 
2119   function setFreeLimitPerWallet(uint256 _limit)
2120       external
2121       onlyOwner
2122   {
2123       MAX_FREE_PER_WALLET = _limit;
2124   }
2125 }