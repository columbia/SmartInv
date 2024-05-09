1 // File contracts/IERC721A.sol
2 
3 // SPDX-License-Identifier: MIT
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
291 
292 // File contracts/ERC721A.sol
293 
294 
295 // ERC721A Contracts v4.2.2
296 // Creator: Chiru Labs
297 
298 pragma solidity ^0.8.4;
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
1376 
1377 // File contracts/IERC721AQueryable.sol
1378 
1379 
1380 // ERC721A Contracts v4.2.2
1381 // Creator: Chiru Labs
1382 
1383 pragma solidity ^0.8.4;
1384 
1385 /**
1386  * @dev Interface of ERC721AQueryable.
1387  */
1388 interface IERC721AQueryable is IERC721A {
1389     /**
1390      * Invalid query range (`start` >= `stop`).
1391      */
1392     error InvalidQueryRange();
1393 
1394     /**
1395      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1396      *
1397      * If the `tokenId` is out of bounds:
1398      *
1399      * - `addr = address(0)`
1400      * - `startTimestamp = 0`
1401      * - `burned = false`
1402      * - `extraData = 0`
1403      *
1404      * If the `tokenId` is burned:
1405      *
1406      * - `addr = <Address of owner before token was burned>`
1407      * - `startTimestamp = <Timestamp when token was burned>`
1408      * - `burned = true`
1409      * - `extraData = <Extra data when token was burned>`
1410      *
1411      * Otherwise:
1412      *
1413      * - `addr = <Address of owner>`
1414      * - `startTimestamp = <Timestamp of start of ownership>`
1415      * - `burned = false`
1416      * - `extraData = <Extra data at start of ownership>`
1417      */
1418     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1419 
1420     /**
1421      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1422      * See {ERC721AQueryable-explicitOwnershipOf}
1423      */
1424     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1425 
1426     /**
1427      * @dev Returns an array of token IDs owned by `owner`,
1428      * in the range [`start`, `stop`)
1429      * (i.e. `start <= tokenId < stop`).
1430      *
1431      * This function allows for tokens to be queried if the collection
1432      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1433      *
1434      * Requirements:
1435      *
1436      * - `start < stop`
1437      */
1438     function tokensOfOwnerIn(
1439         address owner,
1440         uint256 start,
1441         uint256 stop
1442     ) external view returns (uint256[] memory);
1443 
1444     /**
1445      * @dev Returns an array of token IDs owned by `owner`.
1446      *
1447      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1448      * It is meant to be called off-chain.
1449      *
1450      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1451      * multiple smaller scans if the collection is large enough to cause
1452      * an out-of-gas error (10K collections should be fine).
1453      */
1454     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1455 }
1456 
1457 
1458 // File contracts/ERC721AQueryable.sol
1459 
1460 
1461 // ERC721A Contracts v4.2.2
1462 // Creator: Chiru Labs
1463 
1464 pragma solidity ^0.8.4;
1465 
1466 
1467 /**
1468  * @title ERC721AQueryable.
1469  *
1470  * @dev ERC721A subclass with convenience query functions.
1471  */
1472 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1473     /**
1474      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1475      *
1476      * If the `tokenId` is out of bounds:
1477      *
1478      * - `addr = address(0)`
1479      * - `startTimestamp = 0`
1480      * - `burned = false`
1481      * - `extraData = 0`
1482      *
1483      * If the `tokenId` is burned:
1484      *
1485      * - `addr = <Address of owner before token was burned>`
1486      * - `startTimestamp = <Timestamp when token was burned>`
1487      * - `burned = true`
1488      * - `extraData = <Extra data when token was burned>`
1489      *
1490      * Otherwise:
1491      *
1492      * - `addr = <Address of owner>`
1493      * - `startTimestamp = <Timestamp of start of ownership>`
1494      * - `burned = false`
1495      * - `extraData = <Extra data at start of ownership>`
1496      */
1497     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1498         TokenOwnership memory ownership;
1499         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1500             return ownership;
1501         }
1502         ownership = _ownershipAt(tokenId);
1503         if (ownership.burned) {
1504             return ownership;
1505         }
1506         return _ownershipOf(tokenId);
1507     }
1508 
1509     /**
1510      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1511      * See {ERC721AQueryable-explicitOwnershipOf}
1512      */
1513     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1514         external
1515         view
1516         virtual
1517         override
1518         returns (TokenOwnership[] memory)
1519     {
1520         unchecked {
1521             uint256 tokenIdsLength = tokenIds.length;
1522             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1523             for (uint256 i; i != tokenIdsLength; ++i) {
1524                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1525             }
1526             return ownerships;
1527         }
1528     }
1529 
1530     /**
1531      * @dev Returns an array of token IDs owned by `owner`,
1532      * in the range [`start`, `stop`)
1533      * (i.e. `start <= tokenId < stop`).
1534      *
1535      * This function allows for tokens to be queried if the collection
1536      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1537      *
1538      * Requirements:
1539      *
1540      * - `start < stop`
1541      */
1542     function tokensOfOwnerIn(
1543         address owner,
1544         uint256 start,
1545         uint256 stop
1546     ) external view virtual override returns (uint256[] memory) {
1547         unchecked {
1548             if (start >= stop) revert InvalidQueryRange();
1549             uint256 tokenIdsIdx;
1550             uint256 stopLimit = _nextTokenId();
1551             // Set `start = max(start, _startTokenId())`.
1552             if (start < _startTokenId()) {
1553                 start = _startTokenId();
1554             }
1555             // Set `stop = min(stop, stopLimit)`.
1556             if (stop > stopLimit) {
1557                 stop = stopLimit;
1558             }
1559             uint256 tokenIdsMaxLength = balanceOf(owner);
1560             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1561             // to cater for cases where `balanceOf(owner)` is too big.
1562             if (start < stop) {
1563                 uint256 rangeLength = stop - start;
1564                 if (rangeLength < tokenIdsMaxLength) {
1565                     tokenIdsMaxLength = rangeLength;
1566                 }
1567             } else {
1568                 tokenIdsMaxLength = 0;
1569             }
1570             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1571             if (tokenIdsMaxLength == 0) {
1572                 return tokenIds;
1573             }
1574             // We need to call `explicitOwnershipOf(start)`,
1575             // because the slot at `start` may not be initialized.
1576             TokenOwnership memory ownership = explicitOwnershipOf(start);
1577             address currOwnershipAddr;
1578             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1579             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1580             if (!ownership.burned) {
1581                 currOwnershipAddr = ownership.addr;
1582             }
1583             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1584                 ownership = _ownershipAt(i);
1585                 if (ownership.burned) {
1586                     continue;
1587                 }
1588                 if (ownership.addr != address(0)) {
1589                     currOwnershipAddr = ownership.addr;
1590                 }
1591                 if (currOwnershipAddr == owner) {
1592                     tokenIds[tokenIdsIdx++] = i;
1593                 }
1594             }
1595             // Downsize the array to fit.
1596             assembly {
1597                 mstore(tokenIds, tokenIdsIdx)
1598             }
1599             return tokenIds;
1600         }
1601     }
1602 
1603     /**
1604      * @dev Returns an array of token IDs owned by `owner`.
1605      *
1606      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1607      * It is meant to be called off-chain.
1608      *
1609      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1610      * multiple smaller scans if the collection is large enough to cause
1611      * an out-of-gas error (10K collections should be fine).
1612      */
1613     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1614         unchecked {
1615             uint256 tokenIdsIdx;
1616             address currOwnershipAddr;
1617             uint256 tokenIdsLength = balanceOf(owner);
1618             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1619             TokenOwnership memory ownership;
1620             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1621                 ownership = _ownershipAt(i);
1622                 if (ownership.burned) {
1623                     continue;
1624                 }
1625                 if (ownership.addr != address(0)) {
1626                     currOwnershipAddr = ownership.addr;
1627                 }
1628                 if (currOwnershipAddr == owner) {
1629                     tokenIds[tokenIdsIdx++] = i;
1630                 }
1631             }
1632             return tokenIds;
1633         }
1634     }
1635 }
1636 
1637 
1638 // File contracts/Context.sol
1639 
1640 
1641 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1642 
1643 pragma solidity ^0.8.0;
1644 
1645 /**
1646  * @dev Provides information about the current execution context, including the
1647  * sender of the transaction and its data. While these are generally available
1648  * via msg.sender and msg.data, they should not be accessed in such a direct
1649  * manner, since when dealing with meta-transactions the account sending and
1650  * paying for execution may not be the actual sender (as far as an application
1651  * is concerned).
1652  *
1653  * This contract is only required for intermediate, library-like contracts.
1654  */
1655 abstract contract Context {
1656     function _msgSender() internal view virtual returns (address) {
1657         return msg.sender;
1658     }
1659 
1660     function _msgData() internal view virtual returns (bytes calldata) {
1661         return msg.data;
1662     }
1663 }
1664 
1665 
1666 // File contracts/Ownable.sol
1667 
1668 
1669 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1670 
1671 pragma solidity ^0.8.0;
1672 
1673 /**
1674  * @dev Contract module which provides a basic access control mechanism, where
1675  * there is an account (an owner) that can be granted exclusive access to
1676  * specific functions.
1677  *
1678  * By default, the owner account will be the one that deploys the contract. This
1679  * can later be changed with {transferOwnership}.
1680  *
1681  * This module is used through inheritance. It will make available the modifier
1682  * `onlyOwner`, which can be applied to your functions to restrict their use to
1683  * the owner.
1684  */
1685 abstract contract Ownable is Context {
1686     address private _owner;
1687 
1688     event OwnershipTransferred(
1689         address indexed previousOwner,
1690         address indexed newOwner
1691     );
1692 
1693     /**
1694      * @dev Initializes the contract setting the deployer as the initial owner.
1695      */
1696     constructor() {
1697         _transferOwnership(_msgSender());
1698     }
1699 
1700     /**
1701      * @dev Throws if called by any account other than the owner.
1702      */
1703     modifier onlyOwner() {
1704         _checkOwner();
1705         _;
1706     }
1707 
1708     /**
1709      * @dev Returns the address of the current owner.
1710      */
1711     function owner() public view virtual returns (address) {
1712         return _owner;
1713     }
1714 
1715     /**
1716      * @dev Throws if the sender is not the owner.
1717      */
1718     function _checkOwner() internal view virtual {
1719         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1720     }
1721 
1722     /**
1723      * @dev Leaves the contract without owner. It will not be possible to call
1724      * `onlyOwner` functions anymore. Can only be called by the current owner.
1725      *
1726      * NOTE: Renouncing ownership will leave the contract without an owner,
1727      * thereby removing any functionality that is only available to the owner.
1728      */
1729     function renounceOwnership() public virtual onlyOwner {
1730         _transferOwnership(address(0));
1731     }
1732 
1733     /**
1734      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1735      * Can only be called by the current owner.
1736      */
1737     function transferOwnership(address newOwner) public virtual onlyOwner {
1738         require(
1739             newOwner != address(0),
1740             "Ownable: new owner is the zero address"
1741         );
1742         _transferOwnership(newOwner);
1743     }
1744 
1745     /**
1746      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1747      * Internal function without access restriction.
1748      */
1749     function _transferOwnership(address newOwner) internal virtual {
1750         address oldOwner = _owner;
1751         _owner = newOwner;
1752         emit OwnershipTransferred(oldOwner, newOwner);
1753     }
1754 }
1755 
1756 
1757 // File contracts/Math.sol
1758 
1759 
1760 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
1761 
1762 pragma solidity ^0.8.0;
1763 
1764 /**
1765  * @dev Standard math utilities missing in the Solidity language.
1766  */
1767 library Math {
1768     enum Rounding {
1769         Down, // Toward negative infinity
1770         Up, // Toward infinity
1771         Zero // Toward zero
1772     }
1773 
1774     /**
1775      * @dev Returns the largest of two numbers.
1776      */
1777     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1778         return a > b ? a : b;
1779     }
1780 
1781     /**
1782      * @dev Returns the smallest of two numbers.
1783      */
1784     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1785         return a < b ? a : b;
1786     }
1787 
1788     /**
1789      * @dev Returns the average of two numbers. The result is rounded towards
1790      * zero.
1791      */
1792     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1793         // (a + b) / 2 can overflow.
1794         return (a & b) + (a ^ b) / 2;
1795     }
1796 
1797     /**
1798      * @dev Returns the ceiling of the division of two numbers.
1799      *
1800      * This differs from standard division with `/` in that it rounds up instead
1801      * of rounding down.
1802      */
1803     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1804         // (a + b - 1) / b can overflow on addition, so we distribute.
1805         return a == 0 ? 0 : (a - 1) / b + 1;
1806     }
1807 
1808     /**
1809      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1810      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1811      * with further edits by Uniswap Labs also under MIT license.
1812      */
1813     function mulDiv(
1814         uint256 x,
1815         uint256 y,
1816         uint256 denominator
1817     ) internal pure returns (uint256 result) {
1818         unchecked {
1819             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1820             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1821             // variables such that product = prod1 * 2^256 + prod0.
1822             uint256 prod0; // Least significant 256 bits of the product
1823             uint256 prod1; // Most significant 256 bits of the product
1824             assembly {
1825                 let mm := mulmod(x, y, not(0))
1826                 prod0 := mul(x, y)
1827                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1828             }
1829 
1830             // Handle non-overflow cases, 256 by 256 division.
1831             if (prod1 == 0) {
1832                 return prod0 / denominator;
1833             }
1834 
1835             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1836             require(denominator > prod1);
1837 
1838             ///////////////////////////////////////////////
1839             // 512 by 256 division.
1840             ///////////////////////////////////////////////
1841 
1842             // Make division exact by subtracting the remainder from [prod1 prod0].
1843             uint256 remainder;
1844             assembly {
1845                 // Compute remainder using mulmod.
1846                 remainder := mulmod(x, y, denominator)
1847 
1848                 // Subtract 256 bit number from 512 bit number.
1849                 prod1 := sub(prod1, gt(remainder, prod0))
1850                 prod0 := sub(prod0, remainder)
1851             }
1852 
1853             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1854             // See https://cs.stackexchange.com/q/138556/92363.
1855 
1856             // Does not overflow because the denominator cannot be zero at this stage in the function.
1857             uint256 twos = denominator & (~denominator + 1);
1858             assembly {
1859                 // Divide denominator by twos.
1860                 denominator := div(denominator, twos)
1861 
1862                 // Divide [prod1 prod0] by twos.
1863                 prod0 := div(prod0, twos)
1864 
1865                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1866                 twos := add(div(sub(0, twos), twos), 1)
1867             }
1868 
1869             // Shift in bits from prod1 into prod0.
1870             prod0 |= prod1 * twos;
1871 
1872             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1873             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1874             // four bits. That is, denominator * inv = 1 mod 2^4.
1875             uint256 inverse = (3 * denominator) ^ 2;
1876 
1877             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1878             // in modular arithmetic, doubling the correct bits in each step.
1879             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1880             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1881             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1882             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1883             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1884             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1885 
1886             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1887             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1888             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1889             // is no longer required.
1890             result = prod0 * inverse;
1891             return result;
1892         }
1893     }
1894 
1895     /**
1896      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1897      */
1898     function mulDiv(
1899         uint256 x,
1900         uint256 y,
1901         uint256 denominator,
1902         Rounding rounding
1903     ) internal pure returns (uint256) {
1904         uint256 result = mulDiv(x, y, denominator);
1905         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1906             result += 1;
1907         }
1908         return result;
1909     }
1910 
1911     /**
1912      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1913      *
1914      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1915      */
1916     function sqrt(uint256 a) internal pure returns (uint256) {
1917         if (a == 0) {
1918             return 0;
1919         }
1920 
1921         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1922         //
1923         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1924         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1925         //
1926         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1927         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1928         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1929         //
1930         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1931         uint256 result = 1 << (log2(a) >> 1);
1932 
1933         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1934         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1935         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1936         // into the expected uint128 result.
1937         unchecked {
1938             result = (result + a / result) >> 1;
1939             result = (result + a / result) >> 1;
1940             result = (result + a / result) >> 1;
1941             result = (result + a / result) >> 1;
1942             result = (result + a / result) >> 1;
1943             result = (result + a / result) >> 1;
1944             result = (result + a / result) >> 1;
1945             return min(result, a / result);
1946         }
1947     }
1948 
1949     /**
1950      * @notice Calculates sqrt(a), following the selected rounding direction.
1951      */
1952     function sqrt(uint256 a, Rounding rounding)
1953         internal
1954         pure
1955         returns (uint256)
1956     {
1957         unchecked {
1958             uint256 result = sqrt(a);
1959             return
1960                 result +
1961                 (rounding == Rounding.Up && result * result < a ? 1 : 0);
1962         }
1963     }
1964 
1965     /**
1966      * @dev Return the log in base 2, rounded down, of a positive value.
1967      * Returns 0 if given 0.
1968      */
1969     function log2(uint256 value) internal pure returns (uint256) {
1970         uint256 result = 0;
1971         unchecked {
1972             if (value >> 128 > 0) {
1973                 value >>= 128;
1974                 result += 128;
1975             }
1976             if (value >> 64 > 0) {
1977                 value >>= 64;
1978                 result += 64;
1979             }
1980             if (value >> 32 > 0) {
1981                 value >>= 32;
1982                 result += 32;
1983             }
1984             if (value >> 16 > 0) {
1985                 value >>= 16;
1986                 result += 16;
1987             }
1988             if (value >> 8 > 0) {
1989                 value >>= 8;
1990                 result += 8;
1991             }
1992             if (value >> 4 > 0) {
1993                 value >>= 4;
1994                 result += 4;
1995             }
1996             if (value >> 2 > 0) {
1997                 value >>= 2;
1998                 result += 2;
1999             }
2000             if (value >> 1 > 0) {
2001                 result += 1;
2002             }
2003         }
2004         return result;
2005     }
2006 
2007     /**
2008      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2009      * Returns 0 if given 0.
2010      */
2011     function log2(uint256 value, Rounding rounding)
2012         internal
2013         pure
2014         returns (uint256)
2015     {
2016         unchecked {
2017             uint256 result = log2(value);
2018             return
2019                 result +
2020                 (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2021         }
2022     }
2023 
2024     /**
2025      * @dev Return the log in base 10, rounded down, of a positive value.
2026      * Returns 0 if given 0.
2027      */
2028     function log10(uint256 value) internal pure returns (uint256) {
2029         uint256 result = 0;
2030         unchecked {
2031             if (value >= 10**64) {
2032                 value /= 10**64;
2033                 result += 64;
2034             }
2035             if (value >= 10**32) {
2036                 value /= 10**32;
2037                 result += 32;
2038             }
2039             if (value >= 10**16) {
2040                 value /= 10**16;
2041                 result += 16;
2042             }
2043             if (value >= 10**8) {
2044                 value /= 10**8;
2045                 result += 8;
2046             }
2047             if (value >= 10**4) {
2048                 value /= 10**4;
2049                 result += 4;
2050             }
2051             if (value >= 10**2) {
2052                 value /= 10**2;
2053                 result += 2;
2054             }
2055             if (value >= 10**1) {
2056                 result += 1;
2057             }
2058         }
2059         return result;
2060     }
2061 
2062     /**
2063      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2064      * Returns 0 if given 0.
2065      */
2066     function log10(uint256 value, Rounding rounding)
2067         internal
2068         pure
2069         returns (uint256)
2070     {
2071         unchecked {
2072             uint256 result = log10(value);
2073             return
2074                 result +
2075                 (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2076         }
2077     }
2078 
2079     /**
2080      * @dev Return the log in base 256, rounded down, of a positive value.
2081      * Returns 0 if given 0.
2082      *
2083      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2084      */
2085     function log256(uint256 value) internal pure returns (uint256) {
2086         uint256 result = 0;
2087         unchecked {
2088             if (value >> 128 > 0) {
2089                 value >>= 128;
2090                 result += 16;
2091             }
2092             if (value >> 64 > 0) {
2093                 value >>= 64;
2094                 result += 8;
2095             }
2096             if (value >> 32 > 0) {
2097                 value >>= 32;
2098                 result += 4;
2099             }
2100             if (value >> 16 > 0) {
2101                 value >>= 16;
2102                 result += 2;
2103             }
2104             if (value >> 8 > 0) {
2105                 result += 1;
2106             }
2107         }
2108         return result;
2109     }
2110 
2111     /**
2112      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2113      * Returns 0 if given 0.
2114      */
2115     function log256(uint256 value, Rounding rounding)
2116         internal
2117         pure
2118         returns (uint256)
2119     {
2120         unchecked {
2121             uint256 result = log256(value);
2122             return
2123                 result +
2124                 (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
2125         }
2126     }
2127 }
2128 
2129 
2130 // File contracts/Strings.sol
2131 
2132 
2133 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
2134 
2135 pragma solidity ^0.8.0;
2136 
2137 /**
2138  * @dev String operations.
2139  */
2140 library Strings {
2141     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2142     uint8 private constant _ADDRESS_LENGTH = 20;
2143 
2144     /**
2145      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2146      */
2147     function toString(uint256 value) internal pure returns (string memory) {
2148         unchecked {
2149             uint256 length = Math.log10(value) + 1;
2150             string memory buffer = new string(length);
2151             uint256 ptr;
2152             /// @solidity memory-safe-assembly
2153             assembly {
2154                 ptr := add(buffer, add(32, length))
2155             }
2156             while (true) {
2157                 ptr--;
2158                 /// @solidity memory-safe-assembly
2159                 assembly {
2160                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2161                 }
2162                 value /= 10;
2163                 if (value == 0) break;
2164             }
2165             return buffer;
2166         }
2167     }
2168 
2169     /**
2170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2171      */
2172     function toHexString(uint256 value) internal pure returns (string memory) {
2173         unchecked {
2174             return toHexString(value, Math.log256(value) + 1);
2175         }
2176     }
2177 
2178     /**
2179      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2180      */
2181     function toHexString(uint256 value, uint256 length)
2182         internal
2183         pure
2184         returns (string memory)
2185     {
2186         bytes memory buffer = new bytes(2 * length + 2);
2187         buffer[0] = "0";
2188         buffer[1] = "x";
2189         for (uint256 i = 2 * length + 1; i > 1; --i) {
2190             buffer[i] = _SYMBOLS[value & 0xf];
2191             value >>= 4;
2192         }
2193         require(value == 0, "Strings: hex length insufficient");
2194         return string(buffer);
2195     }
2196 
2197     /**
2198      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2199      */
2200     function toHexString(address addr) internal pure returns (string memory) {
2201         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2202     }
2203 }
2204 
2205 
2206 // File contracts/MerkleProof.sol
2207 
2208 
2209 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
2210 
2211 pragma solidity ^0.8.0;
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
2263     function processProof(bytes32[] memory proof, bytes32 leaf)
2264         internal
2265         pure
2266         returns (bytes32)
2267     {
2268         bytes32 computedHash = leaf;
2269         for (uint256 i = 0; i < proof.length; i++) {
2270             computedHash = _hashPair(computedHash, proof[i]);
2271         }
2272         return computedHash;
2273     }
2274 
2275     /**
2276      * @dev Calldata version of {processProof}
2277      *
2278      * _Available since v4.7._
2279      */
2280     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf)
2281         internal
2282         pure
2283         returns (bytes32)
2284     {
2285         bytes32 computedHash = leaf;
2286         for (uint256 i = 0; i < proof.length; i++) {
2287             computedHash = _hashPair(computedHash, proof[i]);
2288         }
2289         return computedHash;
2290     }
2291 
2292     /**
2293      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
2294      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
2295      *
2296      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2297      *
2298      * _Available since v4.7._
2299      */
2300     function multiProofVerify(
2301         bytes32[] memory proof,
2302         bool[] memory proofFlags,
2303         bytes32 root,
2304         bytes32[] memory leaves
2305     ) internal pure returns (bool) {
2306         return processMultiProof(proof, proofFlags, leaves) == root;
2307     }
2308 
2309     /**
2310      * @dev Calldata version of {multiProofVerify}
2311      *
2312      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2313      *
2314      * _Available since v4.7._
2315      */
2316     function multiProofVerifyCalldata(
2317         bytes32[] calldata proof,
2318         bool[] calldata proofFlags,
2319         bytes32 root,
2320         bytes32[] memory leaves
2321     ) internal pure returns (bool) {
2322         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2323     }
2324 
2325     /**
2326      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2327      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2328      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2329      * respectively.
2330      *
2331      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2332      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2333      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2334      *
2335      * _Available since v4.7._
2336      */
2337     function processMultiProof(
2338         bytes32[] memory proof,
2339         bool[] memory proofFlags,
2340         bytes32[] memory leaves
2341     ) internal pure returns (bytes32 merkleRoot) {
2342         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2343         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2344         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2345         // the merkle tree.
2346         uint256 leavesLen = leaves.length;
2347         uint256 totalHashes = proofFlags.length;
2348 
2349         // Check proof validity.
2350         require(
2351             leavesLen + proof.length - 1 == totalHashes,
2352             "MerkleProof: invalid multiproof"
2353         );
2354 
2355         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2356         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2357         bytes32[] memory hashes = new bytes32[](totalHashes);
2358         uint256 leafPos = 0;
2359         uint256 hashPos = 0;
2360         uint256 proofPos = 0;
2361         // At each step, we compute the next hash using two values:
2362         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2363         //   get the next hash.
2364         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2365         //   `proof` array.
2366         for (uint256 i = 0; i < totalHashes; i++) {
2367             bytes32 a = leafPos < leavesLen
2368                 ? leaves[leafPos++]
2369                 : hashes[hashPos++];
2370             bytes32 b = proofFlags[i]
2371                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
2372                 : proof[proofPos++];
2373             hashes[i] = _hashPair(a, b);
2374         }
2375 
2376         if (totalHashes > 0) {
2377             return hashes[totalHashes - 1];
2378         } else if (leavesLen > 0) {
2379             return leaves[0];
2380         } else {
2381             return proof[0];
2382         }
2383     }
2384 
2385     /**
2386      * @dev Calldata version of {processMultiProof}.
2387      *
2388      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2389      *
2390      * _Available since v4.7._
2391      */
2392     function processMultiProofCalldata(
2393         bytes32[] calldata proof,
2394         bool[] calldata proofFlags,
2395         bytes32[] memory leaves
2396     ) internal pure returns (bytes32 merkleRoot) {
2397         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2398         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2399         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2400         // the merkle tree.
2401         uint256 leavesLen = leaves.length;
2402         uint256 totalHashes = proofFlags.length;
2403 
2404         // Check proof validity.
2405         require(
2406             leavesLen + proof.length - 1 == totalHashes,
2407             "MerkleProof: invalid multiproof"
2408         );
2409 
2410         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2411         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2412         bytes32[] memory hashes = new bytes32[](totalHashes);
2413         uint256 leafPos = 0;
2414         uint256 hashPos = 0;
2415         uint256 proofPos = 0;
2416         // At each step, we compute the next hash using two values:
2417         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2418         //   get the next hash.
2419         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2420         //   `proof` array.
2421         for (uint256 i = 0; i < totalHashes; i++) {
2422             bytes32 a = leafPos < leavesLen
2423                 ? leaves[leafPos++]
2424                 : hashes[hashPos++];
2425             bytes32 b = proofFlags[i]
2426                 ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++]
2427                 : proof[proofPos++];
2428             hashes[i] = _hashPair(a, b);
2429         }
2430 
2431         if (totalHashes > 0) {
2432             return hashes[totalHashes - 1];
2433         } else if (leavesLen > 0) {
2434             return leaves[0];
2435         } else {
2436             return proof[0];
2437         }
2438     }
2439 
2440     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2441         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2442     }
2443 
2444     function _efficientHash(bytes32 a, bytes32 b)
2445         private
2446         pure
2447         returns (bytes32 value)
2448     {
2449         /// @solidity memory-safe-assembly
2450         assembly {
2451             mstore(0x00, a)
2452             mstore(0x20, b)
2453             value := keccak256(0x00, 0x40)
2454         }
2455     }
2456 }
2457 
2458 
2459 // File operator-filter-registry/src/IOperatorFilterRegistry.sol@v1.4.0
2460 
2461 
2462 pragma solidity ^0.8.13;
2463 
2464 interface IOperatorFilterRegistry {
2465     /**
2466      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
2467      *         true if supplied registrant address is not registered.
2468      */
2469     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2470 
2471     /**
2472      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
2473      */
2474     function register(address registrant) external;
2475 
2476     /**
2477      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
2478      */
2479     function registerAndSubscribe(address registrant, address subscription) external;
2480 
2481     /**
2482      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
2483      *         address without subscribing.
2484      */
2485     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2486 
2487     /**
2488      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
2489      *         Note that this does not remove any filtered addresses or codeHashes.
2490      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
2491      */
2492     function unregister(address addr) external;
2493 
2494     /**
2495      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
2496      */
2497     function updateOperator(address registrant, address operator, bool filtered) external;
2498 
2499     /**
2500      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
2501      */
2502     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2503 
2504     /**
2505      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
2506      */
2507     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2508 
2509     /**
2510      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
2511      */
2512     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2513 
2514     /**
2515      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
2516      *         subscription if present.
2517      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
2518      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
2519      *         used.
2520      */
2521     function subscribe(address registrant, address registrantToSubscribe) external;
2522 
2523     /**
2524      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
2525      */
2526     function unsubscribe(address registrant, bool copyExistingEntries) external;
2527 
2528     /**
2529      * @notice Get the subscription address of a given registrant, if any.
2530      */
2531     function subscriptionOf(address addr) external returns (address registrant);
2532 
2533     /**
2534      * @notice Get the set of addresses subscribed to a given registrant.
2535      *         Note that order is not guaranteed as updates are made.
2536      */
2537     function subscribers(address registrant) external returns (address[] memory);
2538 
2539     /**
2540      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
2541      *         Note that order is not guaranteed as updates are made.
2542      */
2543     function subscriberAt(address registrant, uint256 index) external returns (address);
2544 
2545     /**
2546      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
2547      */
2548     function copyEntriesOf(address registrant, address registrantToCopy) external;
2549 
2550     /**
2551      * @notice Returns true if operator is filtered by a given address or its subscription.
2552      */
2553     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2554 
2555     /**
2556      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
2557      */
2558     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2559 
2560     /**
2561      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
2562      */
2563     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2564 
2565     /**
2566      * @notice Returns a list of filtered operators for a given address or its subscription.
2567      */
2568     function filteredOperators(address addr) external returns (address[] memory);
2569 
2570     /**
2571      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
2572      *         Note that order is not guaranteed as updates are made.
2573      */
2574     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2575 
2576     /**
2577      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
2578      *         its subscription.
2579      *         Note that order is not guaranteed as updates are made.
2580      */
2581     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2582 
2583     /**
2584      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
2585      *         its subscription.
2586      *         Note that order is not guaranteed as updates are made.
2587      */
2588     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2589 
2590     /**
2591      * @notice Returns true if an address has registered
2592      */
2593     function isRegistered(address addr) external returns (bool);
2594 
2595     /**
2596      * @dev Convenience method to compute the code hash of an arbitrary contract
2597      */
2598     function codeHashOf(address addr) external returns (bytes32);
2599 }
2600 
2601 
2602 // File operator-filter-registry/src/lib/Constants.sol@v1.4.0
2603 
2604 
2605 pragma solidity ^0.8.17;
2606 
2607 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
2608 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
2609 
2610 
2611 // File operator-filter-registry/src/OperatorFilterer.sol@v1.4.0
2612 
2613 
2614 pragma solidity ^0.8.13;
2615 
2616 
2617 /**
2618  * @title  OperatorFilterer
2619  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2620  *         registrant's entries in the OperatorFilterRegistry.
2621  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2622  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2623  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2624  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
2625  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2626  *         will be locked to the options set during construction.
2627  */
2628 
2629 abstract contract OperatorFilterer {
2630     /// @dev Emitted when an operator is not allowed.
2631     error OperatorNotAllowed(address operator);
2632 
2633     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2634         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
2635 
2636     /// @dev The constructor that is called when the contract is being deployed.
2637     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2638         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2639         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2640         // order for the modifier to filter addresses.
2641         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2642             if (subscribe) {
2643                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2644             } else {
2645                 if (subscriptionOrRegistrantToCopy != address(0)) {
2646                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2647                 } else {
2648                     OPERATOR_FILTER_REGISTRY.register(address(this));
2649                 }
2650             }
2651         }
2652     }
2653 
2654     /**
2655      * @dev A helper function to check if an operator is allowed.
2656      */
2657     modifier onlyAllowedOperator(address from) virtual {
2658         // Allow spending tokens from addresses with balance
2659         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2660         // from an EOA.
2661         if (from != msg.sender) {
2662             _checkFilterOperator(msg.sender);
2663         }
2664         _;
2665     }
2666 
2667     /**
2668      * @dev A helper function to check if an operator approval is allowed.
2669      */
2670     modifier onlyAllowedOperatorApproval(address operator) virtual {
2671         _checkFilterOperator(operator);
2672         _;
2673     }
2674 
2675     /**
2676      * @dev A helper function to check if an operator is allowed.
2677      */
2678     function _checkFilterOperator(address operator) internal view virtual {
2679         // Check registry code length to facilitate testing in environments without a deployed registry.
2680         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2681             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
2682             // may specify their own OperatorFilterRegistry implementations, which may behave differently
2683             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2684                 revert OperatorNotAllowed(operator);
2685             }
2686         }
2687     }
2688 }
2689 
2690 
2691 // File operator-filter-registry/src/DefaultOperatorFilterer.sol@v1.4.0
2692 
2693 
2694 pragma solidity ^0.8.13;
2695 
2696 
2697 /**
2698  * @title  DefaultOperatorFilterer
2699  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2700  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
2701  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2702  *         will be locked to the options set during construction.
2703  */
2704 
2705 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2706     /// @dev The constructor that is called when the contract is being deployed.
2707     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2708 }
2709 
2710 
2711 // File contracts/WizhNFT.sol
2712 
2713 
2714 pragma solidity ^0.8.12;
2715 
2716 //@author Soakverse
2717 //@title Wizh by Soakverse
2718 
2719 
2720 
2721 
2722 
2723 contract WizhNFT is DefaultOperatorFilterer, Ownable, ERC721A {
2724     using Strings for uint256;
2725 
2726     enum Step {
2727         Before,
2728         OGWhitelist,
2729         Eggz3Whitelist,
2730         Eggz1Whitelist,
2731         PremiumWhitelist,
2732         StandardWhitelist,
2733         Waitlist,
2734         Public,
2735         Soldout
2736     }
2737 
2738     string public baseURI;
2739 
2740     Step public sellingStep;
2741 
2742     uint256 private constant MAX_SUPPLY = 5000;
2743 
2744     bytes32 public ogMerkleRoot;
2745     bytes32 public eggz3MerkleRoot;
2746     bytes32 public eggz1MerkleRoot;
2747     bytes32 public premiumMerkleRoot;
2748     bytes32 public standardMerkleRoot;
2749     bytes32 public waitlistMerkleRoot;
2750 
2751     mapping(address => uint256) public ogAmountNftPerWallet;
2752     mapping(address => uint256) public eggz3AmountNftPerWallet;
2753     mapping(address => uint256) public eggz1AmountNftPerWallet;
2754     mapping(address => uint256) public premiumAmountNftPerWallet;
2755     mapping(address => uint256) public standardAmountNftPerWallet;
2756     mapping(address => uint256) public waitlistAmountNftPerWallet;
2757     mapping(address => uint256) public publicAmountNftPerWallet;
2758 
2759     constructor(
2760         bytes32 _ogMerkleRoot,
2761         bytes32 _eggz3MerkleRoot,
2762         bytes32 _eggz1MerkleRoot,
2763         bytes32 _premiumMerkleRoot,
2764         bytes32 _standardMerkleRoot,
2765         bytes32 _waitlistMerkleRoot,
2766         string memory _baseURI
2767     ) ERC721A("Wizh By Soakverse", "WIZH") {
2768         ogMerkleRoot = _ogMerkleRoot;
2769         eggz3MerkleRoot = _eggz3MerkleRoot;
2770         eggz1MerkleRoot = _eggz1MerkleRoot;
2771         premiumMerkleRoot = _premiumMerkleRoot;
2772         standardMerkleRoot = _standardMerkleRoot;
2773         waitlistMerkleRoot = _waitlistMerkleRoot;
2774         baseURI = _baseURI;
2775     }
2776 
2777     modifier callerIsUser() {
2778         require(tx.origin == msg.sender, "The caller is another contract");
2779         _;
2780     }
2781 
2782     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2783         super.setApprovalForAll(operator, approved);
2784     }
2785 
2786     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2787         super.approve(operator, tokenId);
2788     }
2789 
2790     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2791         super.transferFrom(from, to, tokenId);
2792     }
2793 
2794     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2795         super.safeTransferFrom(from, to, tokenId);
2796     }
2797 
2798     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2799         public
2800         override
2801         onlyAllowedOperator(from)
2802     {
2803         super.safeTransferFrom(from, to, tokenId, data);
2804     }
2805 
2806     function ogWhitelistMint(uint256 _quantity, bytes32[] calldata _proof)
2807         external
2808         callerIsUser
2809     {
2810         require(
2811             sellingStep >= Step.OGWhitelist,
2812             "OG Whitelist sale is not activated"
2813         );
2814         require(
2815             isOGWhiteListed(msg.sender, _quantity, _proof),
2816             "Not OG whitelisted for that amount"
2817         );
2818         require(
2819             ogAmountNftPerWallet[msg.sender] + _quantity <= _quantity,
2820             "You reached maximum on OG Whitelist Sale"
2821         );
2822         require(
2823             totalSupply() + _quantity <= MAX_SUPPLY,
2824             "Max total supply exceeded"
2825         );
2826         ogAmountNftPerWallet[msg.sender] += _quantity;
2827         _safeMint(msg.sender, _quantity);
2828     }
2829 
2830     function eggz3WhitelistMint(uint256 _quantity, bytes32[] calldata _proof)
2831         external
2832         callerIsUser
2833     {
2834         require(
2835             sellingStep >= Step.Eggz3Whitelist,
2836             "Eggz 3 Whitelist sale is not activated"
2837         );
2838         require(
2839             isEggz3WhiteListed(msg.sender, _quantity, _proof),
2840             "Not Eggz 3 whitelisted for that amount"
2841         );
2842         require(
2843             eggz3AmountNftPerWallet[msg.sender] + _quantity <= _quantity,
2844             "You reached maximum on Eggz 3 Whitelist Sale"
2845         );
2846         require(
2847             totalSupply() + _quantity <= MAX_SUPPLY,
2848             "Max total supply exceeded"
2849         );
2850         eggz3AmountNftPerWallet[msg.sender] += _quantity;
2851         _safeMint(msg.sender, _quantity);
2852     }
2853 
2854     function eggz1WhitelistMint(uint256 _quantity, bytes32[] calldata _proof)
2855         external
2856         callerIsUser
2857     {
2858         require(
2859             sellingStep >= Step.Eggz1Whitelist,
2860             "Eggz 1 Whitelist sale is not activated"
2861         );
2862         require(
2863             isEggz1WhiteListed(msg.sender, _quantity, _proof),
2864             "Not Eggz 1 whitelisted for that amount"
2865         );
2866         require(
2867             eggz1AmountNftPerWallet[msg.sender] + _quantity <= _quantity,
2868             "You reached maximum on Eggz 1 Whitelist Sale"
2869         );
2870         require(
2871             totalSupply() + _quantity <= MAX_SUPPLY,
2872             "Max total supply exceeded"
2873         );
2874         eggz1AmountNftPerWallet[msg.sender] += _quantity;
2875         _safeMint(msg.sender, _quantity);
2876     }
2877 
2878     function premiumWhitelistMint(uint256 _quantity, bytes32[] calldata _proof)
2879         external
2880         callerIsUser
2881     {
2882         require(
2883             sellingStep >= Step.PremiumWhitelist,
2884             "Premium Whitelist sale is not activated"
2885         );
2886         require(
2887             isPremiumWhiteListed(msg.sender, _quantity, _proof),
2888             "Not Premium whitelisted for that amount"
2889         );
2890         require(
2891             premiumAmountNftPerWallet[msg.sender] + _quantity <= _quantity,
2892             "You reached maximum on Premium Whitelist Sale"
2893         );
2894         require(
2895             totalSupply() + _quantity <= MAX_SUPPLY,
2896             "Max total supply exceeded"
2897         );
2898         premiumAmountNftPerWallet[msg.sender] += _quantity;
2899         _safeMint(msg.sender, _quantity);
2900     }
2901 
2902     function standardWhitelistMint(uint256 _quantity, bytes32[] calldata _proof)
2903         external
2904         callerIsUser
2905     {
2906         require(
2907             sellingStep >= Step.StandardWhitelist,
2908             "Standard Whitelist sale is not activated"
2909         );
2910         require(
2911             isStandardWhiteListed(msg.sender, _quantity, _proof),
2912             "Not Standard whitelisted for that amount"
2913         );
2914         require(
2915             standardAmountNftPerWallet[msg.sender] + _quantity <= _quantity,
2916             "You reached maximum on Standard Whitelist Sale"
2917         );
2918         require(
2919             totalSupply() + _quantity <= MAX_SUPPLY,
2920             "Max total supply exceeded"
2921         );
2922         standardAmountNftPerWallet[msg.sender] += _quantity;
2923         _safeMint(msg.sender, _quantity);
2924     }
2925 
2926     function waitlistWhitelistMint(uint256 _quantity, bytes32[] calldata _proof)
2927         external
2928         callerIsUser
2929     {
2930         require(
2931             sellingStep >= Step.Waitlist,
2932             "Wailist Whitelist sale is not activated"
2933         );
2934         require(
2935             isWaitlistWhiteListed(msg.sender, _quantity, _proof),
2936             "Not Wailist whitelisted for that amount"
2937         );
2938         require(
2939             waitlistAmountNftPerWallet[msg.sender] + _quantity <= _quantity,
2940             "You reached maximum on Wailist Whitelist Sale"
2941         );
2942         require(
2943             totalSupply() + _quantity <= MAX_SUPPLY,
2944             "Max total supply exceeded"
2945         );
2946         waitlistAmountNftPerWallet[msg.sender] += _quantity;
2947         _safeMint(msg.sender, _quantity);
2948     }
2949 
2950     function mint() external callerIsUser {
2951         require(sellingStep >= Step.Public, "Public sale is not activated");
2952         require(
2953             publicAmountNftPerWallet[msg.sender] + 1 <= 1,
2954             "You can only get 1 NFT on the Public Sale"
2955         );
2956         require(
2957             totalSupply() + 1 <= MAX_SUPPLY,
2958             "Max freemint supply exceeded"
2959         );
2960         publicAmountNftPerWallet[msg.sender] += 1;
2961         _safeMint(msg.sender, 1);
2962     }
2963 
2964     function giveaway(address _to, uint256 _quantity) external onlyOwner {
2965         require(totalSupply() + _quantity <= MAX_SUPPLY, "Max supply exceeded");
2966         _safeMint(_to, _quantity);
2967     }
2968 
2969     function setStep(uint256 _step) external onlyOwner {
2970         sellingStep = Step(_step);
2971     }
2972 
2973     function setBaseUri(string memory _baseURI) external onlyOwner {
2974         baseURI = _baseURI;
2975     }
2976 
2977     function tokenURI(uint256 _tokenId)
2978         public
2979         view
2980         virtual
2981         override
2982         returns (string memory)
2983     {
2984         require(_exists(_tokenId), "URI query for nonexistent token");
2985 
2986         return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
2987     }
2988 
2989     // ---- OG Whitelist ----
2990     function setOGMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2991         ogMerkleRoot = _merkleRoot;
2992     }
2993 
2994     function isOGWhiteListed(
2995         address _account,
2996         uint256 _quantity,
2997         bytes32[] calldata _proof
2998     ) internal view returns (bool) {
2999         bytes32 _leaf = keccak256(abi.encodePacked(_account, _quantity));
3000         return _verify(_leaf, ogMerkleRoot, _proof);
3001     }
3002 
3003     // ---- Eggz 3 Whitelist ----
3004     function setEggz3MerkleRoot(bytes32 _merkleRoot) external onlyOwner {
3005         eggz3MerkleRoot = _merkleRoot;
3006     }
3007 
3008     function isEggz3WhiteListed(
3009         address _account,
3010         uint256 _quantity,
3011         bytes32[] calldata _proof
3012     ) internal view returns (bool) {
3013         bytes32 _leaf = keccak256(abi.encodePacked(_account, _quantity));
3014         return _verify(_leaf, eggz3MerkleRoot, _proof);
3015     }
3016 
3017     // ---- Eggz 1 Whitelist ----
3018     function setEggz1MerkleRoot(bytes32 _merkleRoot) external onlyOwner {
3019         eggz1MerkleRoot = _merkleRoot;
3020     }
3021 
3022     function isEggz1WhiteListed(
3023         address _account,
3024         uint256 _quantity,
3025         bytes32[] calldata _proof
3026     ) internal view returns (bool) {
3027         bytes32 _leaf = keccak256(abi.encodePacked(_account, _quantity));
3028         return _verify(_leaf, eggz1MerkleRoot, _proof);
3029     }
3030 
3031     // ---- Premium Whitelist ----
3032     function setPremiumMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
3033         premiumMerkleRoot = _merkleRoot;
3034     }
3035 
3036     function isPremiumWhiteListed(
3037         address _account,
3038         uint256 _quantity,
3039         bytes32[] calldata _proof
3040     ) internal view returns (bool) {
3041         bytes32 _leaf = keccak256(abi.encodePacked(_account, _quantity));
3042         return _verify(_leaf, premiumMerkleRoot, _proof);
3043     }
3044 
3045     // ---- Standard Whitelist ----
3046     function setStandardMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
3047         standardMerkleRoot = _merkleRoot;
3048     }
3049 
3050     function isStandardWhiteListed(
3051         address _account,
3052         uint256 _quantity,
3053         bytes32[] calldata _proof
3054     ) internal view returns (bool) {
3055         bytes32 _leaf = keccak256(abi.encodePacked(_account, _quantity));
3056         return _verify(_leaf, standardMerkleRoot, _proof);
3057     }
3058 
3059         // ---- Waitlist Whitelist ----
3060     function setWaitlistMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
3061         waitlistMerkleRoot = _merkleRoot;
3062     }
3063 
3064     function isWaitlistWhiteListed(
3065         address _account,
3066         uint256 _quantity,
3067         bytes32[] calldata _proof
3068     ) internal view returns (bool) {
3069         bytes32 _leaf = keccak256(abi.encodePacked(_account, _quantity));
3070         return _verify(_leaf, waitlistMerkleRoot, _proof);
3071     }
3072 
3073     function _verify(
3074         bytes32 _leaf,
3075         bytes32 _root,
3076         bytes32[] memory _proof
3077     ) internal pure returns (bool) {
3078         return MerkleProof.verify(_proof, _root, _leaf);
3079     }
3080 
3081     function _startTokenId() internal pure override returns (uint256) {
3082         return 1;
3083     }
3084 
3085     function withdrawAll() external onlyOwner {
3086         uint256 balance = address(this).balance;
3087         require(balance > 0, "there is nothing to withdraw");
3088         _withdraw(owner(), address(this).balance);
3089     }
3090 
3091     function _withdraw(address _address, uint256 _amount) private {
3092         (bool success, ) = _address.call{value: _amount}("");
3093         require(success, "could not withdraw");
3094     }
3095 }