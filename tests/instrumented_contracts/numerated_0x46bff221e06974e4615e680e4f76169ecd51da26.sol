1 // SPDX-License-Identifier: MIT
2 // File: erc721a/contracts/IERC721A.sol
3 
4 
5 // ERC721A Contracts v4.2.2
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
1376 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1377 
1378 
1379 // ERC721A Contracts v4.2.2
1380 // Creator: Chiru Labs
1381 
1382 pragma solidity ^0.8.4;
1383 
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
1457 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1458 
1459 
1460 // ERC721A Contracts v4.2.2
1461 // Creator: Chiru Labs
1462 
1463 pragma solidity ^0.8.4;
1464 
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
1637 // File: @openzeppelin/contracts/utils/Strings.sol
1638 
1639 
1640 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1641 
1642 pragma solidity ^0.8.0;
1643 
1644 /**
1645  * @dev String operations.
1646  */
1647 library Strings {
1648     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1649     uint8 private constant _ADDRESS_LENGTH = 20;
1650 
1651     /**
1652      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1653      */
1654     function toString(uint256 value) internal pure returns (string memory) {
1655         // Inspired by OraclizeAPI's implementation - MIT licence
1656         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1657 
1658         if (value == 0) {
1659             return "0";
1660         }
1661         uint256 temp = value;
1662         uint256 digits;
1663         while (temp != 0) {
1664             digits++;
1665             temp /= 10;
1666         }
1667         bytes memory buffer = new bytes(digits);
1668         while (value != 0) {
1669             digits -= 1;
1670             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1671             value /= 10;
1672         }
1673         return string(buffer);
1674     }
1675 
1676     /**
1677      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1678      */
1679     function toHexString(uint256 value) internal pure returns (string memory) {
1680         if (value == 0) {
1681             return "0x00";
1682         }
1683         uint256 temp = value;
1684         uint256 length = 0;
1685         while (temp != 0) {
1686             length++;
1687             temp >>= 8;
1688         }
1689         return toHexString(value, length);
1690     }
1691 
1692     /**
1693      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1694      */
1695     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1696         bytes memory buffer = new bytes(2 * length + 2);
1697         buffer[0] = "0";
1698         buffer[1] = "x";
1699         for (uint256 i = 2 * length + 1; i > 1; --i) {
1700             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1701             value >>= 4;
1702         }
1703         require(value == 0, "Strings: hex length insufficient");
1704         return string(buffer);
1705     }
1706 
1707     /**
1708      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1709      */
1710     function toHexString(address addr) internal pure returns (string memory) {
1711         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1712     }
1713 }
1714 
1715 // File: @openzeppelin/contracts/utils/math/Math.sol
1716 
1717 
1718 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
1719 
1720 pragma solidity ^0.8.0;
1721 
1722 /**
1723  * @dev Standard math utilities missing in the Solidity language.
1724  */
1725 library Math {
1726     enum Rounding {
1727         Down, // Toward negative infinity
1728         Up, // Toward infinity
1729         Zero // Toward zero
1730     }
1731 
1732     /**
1733      * @dev Returns the largest of two numbers.
1734      */
1735     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1736         return a >= b ? a : b;
1737     }
1738 
1739     /**
1740      * @dev Returns the smallest of two numbers.
1741      */
1742     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1743         return a < b ? a : b;
1744     }
1745 
1746     /**
1747      * @dev Returns the average of two numbers. The result is rounded towards
1748      * zero.
1749      */
1750     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1751         // (a + b) / 2 can overflow.
1752         return (a & b) + (a ^ b) / 2;
1753     }
1754 
1755     /**
1756      * @dev Returns the ceiling of the division of two numbers.
1757      *
1758      * This differs from standard division with `/` in that it rounds up instead
1759      * of rounding down.
1760      */
1761     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1762         // (a + b - 1) / b can overflow on addition, so we distribute.
1763         return a == 0 ? 0 : (a - 1) / b + 1;
1764     }
1765 
1766     /**
1767      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1768      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1769      * with further edits by Uniswap Labs also under MIT license.
1770      */
1771     function mulDiv(
1772         uint256 x,
1773         uint256 y,
1774         uint256 denominator
1775     ) internal pure returns (uint256 result) {
1776         unchecked {
1777             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1778             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1779             // variables such that product = prod1 * 2^256 + prod0.
1780             uint256 prod0; // Least significant 256 bits of the product
1781             uint256 prod1; // Most significant 256 bits of the product
1782             assembly {
1783                 let mm := mulmod(x, y, not(0))
1784                 prod0 := mul(x, y)
1785                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1786             }
1787 
1788             // Handle non-overflow cases, 256 by 256 division.
1789             if (prod1 == 0) {
1790                 return prod0 / denominator;
1791             }
1792 
1793             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1794             require(denominator > prod1);
1795 
1796             ///////////////////////////////////////////////
1797             // 512 by 256 division.
1798             ///////////////////////////////////////////////
1799 
1800             // Make division exact by subtracting the remainder from [prod1 prod0].
1801             uint256 remainder;
1802             assembly {
1803                 // Compute remainder using mulmod.
1804                 remainder := mulmod(x, y, denominator)
1805 
1806                 // Subtract 256 bit number from 512 bit number.
1807                 prod1 := sub(prod1, gt(remainder, prod0))
1808                 prod0 := sub(prod0, remainder)
1809             }
1810 
1811             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1812             // See https://cs.stackexchange.com/q/138556/92363.
1813 
1814             // Does not overflow because the denominator cannot be zero at this stage in the function.
1815             uint256 twos = denominator & (~denominator + 1);
1816             assembly {
1817                 // Divide denominator by twos.
1818                 denominator := div(denominator, twos)
1819 
1820                 // Divide [prod1 prod0] by twos.
1821                 prod0 := div(prod0, twos)
1822 
1823                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1824                 twos := add(div(sub(0, twos), twos), 1)
1825             }
1826 
1827             // Shift in bits from prod1 into prod0.
1828             prod0 |= prod1 * twos;
1829 
1830             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1831             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1832             // four bits. That is, denominator * inv = 1 mod 2^4.
1833             uint256 inverse = (3 * denominator) ^ 2;
1834 
1835             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1836             // in modular arithmetic, doubling the correct bits in each step.
1837             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1838             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1839             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1840             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1841             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1842             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1843 
1844             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1845             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1846             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1847             // is no longer required.
1848             result = prod0 * inverse;
1849             return result;
1850         }
1851     }
1852 
1853     /**
1854      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1855      */
1856     function mulDiv(
1857         uint256 x,
1858         uint256 y,
1859         uint256 denominator,
1860         Rounding rounding
1861     ) internal pure returns (uint256) {
1862         uint256 result = mulDiv(x, y, denominator);
1863         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1864             result += 1;
1865         }
1866         return result;
1867     }
1868 
1869     /**
1870      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
1871      *
1872      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1873      */
1874     function sqrt(uint256 a) internal pure returns (uint256) {
1875         if (a == 0) {
1876             return 0;
1877         }
1878 
1879         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1880         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1881         // `msb(a) <= a < 2*msb(a)`.
1882         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
1883         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
1884         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
1885         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
1886         uint256 result = 1;
1887         uint256 x = a;
1888         if (x >> 128 > 0) {
1889             x >>= 128;
1890             result <<= 64;
1891         }
1892         if (x >> 64 > 0) {
1893             x >>= 64;
1894             result <<= 32;
1895         }
1896         if (x >> 32 > 0) {
1897             x >>= 32;
1898             result <<= 16;
1899         }
1900         if (x >> 16 > 0) {
1901             x >>= 16;
1902             result <<= 8;
1903         }
1904         if (x >> 8 > 0) {
1905             x >>= 8;
1906             result <<= 4;
1907         }
1908         if (x >> 4 > 0) {
1909             x >>= 4;
1910             result <<= 2;
1911         }
1912         if (x >> 2 > 0) {
1913             result <<= 1;
1914         }
1915 
1916         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1917         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1918         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1919         // into the expected uint128 result.
1920         unchecked {
1921             result = (result + a / result) >> 1;
1922             result = (result + a / result) >> 1;
1923             result = (result + a / result) >> 1;
1924             result = (result + a / result) >> 1;
1925             result = (result + a / result) >> 1;
1926             result = (result + a / result) >> 1;
1927             result = (result + a / result) >> 1;
1928             return min(result, a / result);
1929         }
1930     }
1931 
1932     /**
1933      * @notice Calculates sqrt(a), following the selected rounding direction.
1934      */
1935     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1936         uint256 result = sqrt(a);
1937         if (rounding == Rounding.Up && result * result < a) {
1938             result += 1;
1939         }
1940         return result;
1941     }
1942 }
1943 
1944 // File: @openzeppelin/contracts/utils/Arrays.sol
1945 
1946 
1947 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
1948 
1949 pragma solidity ^0.8.0;
1950 
1951 
1952 /**
1953  * @dev Collection of functions related to array types.
1954  */
1955 library Arrays {
1956     /**
1957      * @dev Searches a sorted `array` and returns the first index that contains
1958      * a value greater or equal to `element`. If no such index exists (i.e. all
1959      * values in the array are strictly less than `element`), the array length is
1960      * returned. Time complexity O(log n).
1961      *
1962      * `array` is expected to be sorted in ascending order, and to contain no
1963      * repeated elements.
1964      */
1965     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
1966         if (array.length == 0) {
1967             return 0;
1968         }
1969 
1970         uint256 low = 0;
1971         uint256 high = array.length;
1972 
1973         while (low < high) {
1974             uint256 mid = Math.average(low, high);
1975 
1976             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1977             // because Math.average rounds down (it does integer division with truncation).
1978             if (array[mid] > element) {
1979                 high = mid;
1980             } else {
1981                 low = mid + 1;
1982             }
1983         }
1984 
1985         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1986         if (low > 0 && array[low - 1] == element) {
1987             return low - 1;
1988         } else {
1989             return low;
1990         }
1991     }
1992 }
1993 
1994 // File: @openzeppelin/contracts/utils/Context.sol
1995 
1996 
1997 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1998 
1999 pragma solidity ^0.8.0;
2000 
2001 /**
2002  * @dev Provides information about the current execution context, including the
2003  * sender of the transaction and its data. While these are generally available
2004  * via msg.sender and msg.data, they should not be accessed in such a direct
2005  * manner, since when dealing with meta-transactions the account sending and
2006  * paying for execution may not be the actual sender (as far as an application
2007  * is concerned).
2008  *
2009  * This contract is only required for intermediate, library-like contracts.
2010  */
2011 abstract contract Context {
2012     function _msgSender() internal view virtual returns (address) {
2013         return msg.sender;
2014     }
2015 
2016     function _msgData() internal view virtual returns (bytes calldata) {
2017         return msg.data;
2018     }
2019 }
2020 
2021 // File: @openzeppelin/contracts/access/Ownable.sol
2022 
2023 
2024 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2025 
2026 pragma solidity ^0.8.0;
2027 
2028 
2029 /**
2030  * @dev Contract module which provides a basic access control mechanism, where
2031  * there is an account (an owner) that can be granted exclusive access to
2032  * specific functions.
2033  *
2034  * By default, the owner account will be the one that deploys the contract. This
2035  * can later be changed with {transferOwnership}.
2036  *
2037  * This module is used through inheritance. It will make available the modifier
2038  * `onlyOwner`, which can be applied to your functions to restrict their use to
2039  * the owner.
2040  */
2041 abstract contract Ownable is Context {
2042     address private _owner;
2043 
2044     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2045 
2046     /**
2047      * @dev Initializes the contract setting the deployer as the initial owner.
2048      */
2049     constructor() {
2050         _transferOwnership(_msgSender());
2051     }
2052 
2053     /**
2054      * @dev Throws if called by any account other than the owner.
2055      */
2056     modifier onlyOwner() {
2057         _checkOwner();
2058         _;
2059     }
2060 
2061     /**
2062      * @dev Returns the address of the current owner.
2063      */
2064     function owner() public view virtual returns (address) {
2065         return _owner;
2066     }
2067 
2068     /**
2069      * @dev Throws if the sender is not the owner.
2070      */
2071     function _checkOwner() internal view virtual {
2072         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2073     }
2074 
2075     /**
2076      * @dev Leaves the contract without owner. It will not be possible to call
2077      * `onlyOwner` functions anymore. Can only be called by the current owner.
2078      *
2079      * NOTE: Renouncing ownership will leave the contract without an owner,
2080      * thereby removing any functionality that is only available to the owner.
2081      */
2082     function renounceOwnership() public virtual onlyOwner {
2083         _transferOwnership(address(0));
2084     }
2085 
2086     /**
2087      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2088      * Can only be called by the current owner.
2089      */
2090     function transferOwnership(address newOwner) public virtual onlyOwner {
2091         require(newOwner != address(0), "Ownable: new owner is the zero address");
2092         _transferOwnership(newOwner);
2093     }
2094 
2095     /**
2096      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2097      * Internal function without access restriction.
2098      */
2099     function _transferOwnership(address newOwner) internal virtual {
2100         address oldOwner = _owner;
2101         _owner = newOwner;
2102         emit OwnershipTransferred(oldOwner, newOwner);
2103     }
2104 }
2105 
2106 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2107 
2108 
2109 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
2110 
2111 pragma solidity ^0.8.0;
2112 
2113 /**
2114  * @dev Contract module that helps prevent reentrant calls to a function.
2115  *
2116  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2117  * available, which can be applied to functions to make sure there are no nested
2118  * (reentrant) calls to them.
2119  *
2120  * Note that because there is a single `nonReentrant` guard, functions marked as
2121  * `nonReentrant` may not call one another. This can be worked around by making
2122  * those functions `private`, and then adding `external` `nonReentrant` entry
2123  * points to them.
2124  *
2125  * TIP: If you would like to learn more about reentrancy and alternative ways
2126  * to protect against it, check out our blog post
2127  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2128  */
2129 abstract contract ReentrancyGuard {
2130     // Booleans are more expensive than uint256 or any type that takes up a full
2131     // word because each write operation emits an extra SLOAD to first read the
2132     // slot's contents, replace the bits taken up by the boolean, and then write
2133     // back. This is the compiler's defense against contract upgrades and
2134     // pointer aliasing, and it cannot be disabled.
2135 
2136     // The values being non-zero value makes deployment a bit more expensive,
2137     // but in exchange the refund on every call to nonReentrant will be lower in
2138     // amount. Since refunds are capped to a percentage of the total
2139     // transaction's gas, it is best to keep them low in cases like this one, to
2140     // increase the likelihood of the full refund coming into effect.
2141     uint256 private constant _NOT_ENTERED = 1;
2142     uint256 private constant _ENTERED = 2;
2143 
2144     uint256 private _status;
2145 
2146     constructor() {
2147         _status = _NOT_ENTERED;
2148     }
2149 
2150     /**
2151      * @dev Prevents a contract from calling itself, directly or indirectly.
2152      * Calling a `nonReentrant` function from another `nonReentrant`
2153      * function is not supported. It is possible to prevent this from happening
2154      * by making the `nonReentrant` function external, and making it call a
2155      * `private` function that does the actual work.
2156      */
2157     modifier nonReentrant() {
2158         // On the first call to nonReentrant, _notEntered will be true
2159         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2160 
2161         // Any calls to nonReentrant after this point will fail
2162         _status = _ENTERED;
2163 
2164         _;
2165 
2166         // By storing the original value once again, a refund is triggered (see
2167         // https://eips.ethereum.org/EIPS/eip-2200)
2168         _status = _NOT_ENTERED;
2169     }
2170 }
2171 
2172 // File: contracts/colorsblock.sol
2173 
2174 
2175 
2176 
2177 
2178 
2179 
2180 
2181 
2182 pragma solidity >=0.8.13 <0.9.0;
2183 
2184 contract ColorsBlock is ERC721A, Ownable, ReentrancyGuard { //Change contract name from SampleNFTLowGas
2185 
2186   using Strings for uint256;
2187 
2188 // ================== Variables Start =======================
2189 
2190   string public uri; //you don't change this
2191   string public uriSuffix = ".json"; //you don't change this
2192   string public hiddenMetadataUri; //you don't change this
2193   uint256 public cost1 = 0.025 ether; //here you change phase 1 cost (for example first 1k for free, then 0.004 eth each nft)
2194   uint256 public cost2 = 0.05 ether; //here you change phase 2 cost
2195   uint256 public supplyLimitPhase1 = 499;  //change to your NFT supply for phase1
2196   uint256 public supplyLimit = 999;  //change it to your total NFT supply
2197   uint256 public maxMintAmountPerTxPhase1 = 3; //decide how many NFT's you want to mint with cost1
2198   uint256 public maxMintAmountPerTxPhase2 = 5; //decide how many NFT's you want to mint with cost2
2199   uint256 public maxLimitPerWallet = 10; //decide how many NFT's you want to let customers mint per wallet
2200   bool public sale = false;  //if false, then mint is paused. If true - mint is started
2201   bool public revealed = false; //when you want instant reveal, leave true. 
2202 
2203 // ================== Variables End =======================
2204 
2205 // ================== Constructor Start =======================
2206   constructor(
2207     string memory _uri,
2208     string memory _hiddenMetadataUri
2209   ) ERC721A("Colors Block", "CB")  { //change this line to your full and short NFT name
2210     seturi(_uri);
2211     setHiddenMetadataUri(_hiddenMetadataUri);
2212   }
2213 
2214 // ================== Mint Functions Start =======================
2215 
2216    function UpdateCost(uint256 _mintAmount) internal view returns  (uint256 _cost) {
2217 
2218     if (balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerTxPhase1 && totalSupply() < supplyLimitPhase1) {
2219         return cost1;
2220     }
2221     if (balanceOf(msg.sender) + _mintAmount <= supplyLimit){
2222         return cost2;
2223     }
2224   }
2225   
2226   function Mint(uint256 _mintAmount) public payable {
2227     // Normal requirements 
2228     require(sale, 'The Sale is paused!');
2229     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTxPhase2, 'Invalid mint amount!');
2230     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
2231     require(balanceOf(msg.sender) + _mintAmount <= maxLimitPerWallet, 'Max mint per wallet exceeded!');
2232     require(msg.value >= UpdateCost(_mintAmount) * _mintAmount, 'Insufficient funds!');
2233      
2234      _safeMint(_msgSender(), _mintAmount);
2235   }  
2236 
2237   function Airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
2238     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
2239     _safeMint(_receiver, _mintAmount);
2240   }
2241 
2242   function setRevealed(bool _state) public onlyOwner {
2243     revealed = _state;
2244   }
2245 
2246   function seturi(string memory _uri) public onlyOwner {
2247     uri = _uri;
2248   }
2249 
2250   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2251     hiddenMetadataUri = _hiddenMetadataUri;
2252   }
2253 
2254   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2255     uriSuffix = _uriSuffix;
2256   }
2257 
2258   function setSaleStatus(bool _sale) public onlyOwner {
2259     sale = _sale;
2260   }
2261 
2262   function setMaxMintAmountPerTxPhase1(uint256 _maxMintAmountPerTxPhase1) public onlyOwner {
2263     maxMintAmountPerTxPhase1 = _maxMintAmountPerTxPhase1;
2264   }
2265 
2266   function setMaxMintAmountPerTxPhase2(uint256 _maxMintAmountPerTxPhase2) public onlyOwner {
2267     maxMintAmountPerTxPhase2 = _maxMintAmountPerTxPhase2;
2268   }
2269 
2270   function setmaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
2271     maxLimitPerWallet = _maxLimitPerWallet;
2272   }
2273 
2274   function setcost1(uint256 _cost1) public onlyOwner {
2275     cost1 = _cost1;
2276   }  
2277 
2278   function setcost2(uint256 _cost2) public onlyOwner {
2279     cost2 = _cost2;
2280   }  
2281 
2282   function setsupplyLimit(uint256 _supplyLimit) public onlyOwner {
2283     supplyLimit = _supplyLimit;
2284   }
2285 
2286   function withdraw() public onlyOwner {
2287     (bool hs, ) = payable(0x20B0a00544A3aCa8f41A2cB369e2DA685D272F80).call{value: address(this).balance * 20 / 100}("");
2288     require(hs);
2289     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2290     require(os);
2291   }
2292  
2293   function price(uint256 _mintAmount) public view returns (uint256){
2294          if (balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerTxPhase1 && totalSupply() <supplyLimitPhase1) {
2295           return cost1;
2296           }
2297          if (balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerTxPhase2 && totalSupply() < supplyLimit){
2298           return cost2;
2299         }
2300         return cost2;
2301   }
2302 
2303 function tokensOfOwner(address owner) external view returns (uint256[] memory) {
2304     unchecked {
2305         uint256[] memory a = new uint256[](balanceOf(owner)); 
2306         uint256 end = _nextTokenId();
2307         uint256 tokenIdsIdx;
2308         address currOwnershipAddr;
2309         for (uint256 i; i < end; i++) {
2310             TokenOwnership memory ownership = _ownershipAt(i);
2311             if (ownership.burned) {
2312                 continue;
2313             }
2314             if (ownership.addr != address(0)) {
2315                 currOwnershipAddr = ownership.addr;
2316             }
2317             if (currOwnershipAddr == owner) {
2318                 a[tokenIdsIdx++] = i;
2319             }
2320         }
2321         return a;    
2322     }
2323 }
2324 
2325   function _startTokenId() internal view virtual override returns (uint256) {
2326     return 1;
2327   }
2328 
2329   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2330     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2331 
2332     if (revealed == false) {
2333       return hiddenMetadataUri;
2334     }
2335 
2336     string memory currentBaseURI = _baseURI();
2337     return bytes(currentBaseURI).length > 0
2338         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2339         : '';
2340   }
2341 
2342   function _baseURI() internal view virtual override returns (string memory) {
2343     return uri;
2344   }
2345 }