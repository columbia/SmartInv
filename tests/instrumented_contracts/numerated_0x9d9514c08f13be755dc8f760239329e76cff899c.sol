1 // SPDX-License-Identifier: MIT
2 
3 // NFT: Brainless Spikes                                                                                                                                                                               
4 // Twitter: https://twitter.com/BrainlesSpikes
5 // Website: https://brainlesspikes.io/
6 
7 // File: erc721a/contracts/IERC721A.sol
8 
9 // ERC721A Contracts v4.2.3
10 // Creator: Chiru Labs
11 
12 pragma solidity ^0.8.4;
13 
14 /**
15  * @dev Interface of ERC721A.
16  */
17 interface IERC721A {
18     /**
19      * The caller must own the token or be an approved operator.
20      */
21     error ApprovalCallerNotOwnerNorApproved();
22 
23     /**
24      * The token does not exist.
25      */
26     error ApprovalQueryForNonexistentToken();
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
180     ) external payable;
181 
182     /**
183      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external payable;
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
211     ) external payable;
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
227     function approve(address to, uint256 tokenId) external payable;
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
294 // ERC721A Contracts v4.2.3
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
328     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
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
716     function approve(address to, uint256 tokenId) public payable virtual override {
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
753         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
754         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
755     }
756 
757     /**
758      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
759      *
760      * See {setApprovalForAll}.
761      */
762     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
763         return _operatorApprovals[owner][operator];
764     }
765 
766     /**
767      * @dev Returns whether `tokenId` exists.
768      *
769      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
770      *
771      * Tokens start existing when they are minted. See {_mint}.
772      */
773     function _exists(uint256 tokenId) internal view virtual returns (bool) {
774         return
775             _startTokenId() <= tokenId &&
776             tokenId < _currentIndex && // If within bounds,
777             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
778     }
779 
780     /**
781      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
782      */
783     function _isSenderApprovedOrOwner(
784         address approvedAddress,
785         address owner,
786         address msgSender
787     ) private pure returns (bool result) {
788         assembly {
789             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
790             owner := and(owner, _BITMASK_ADDRESS)
791             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
792             msgSender := and(msgSender, _BITMASK_ADDRESS)
793             // `msgSender == owner || msgSender == approvedAddress`.
794             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
795         }
796     }
797 
798     /**
799      * @dev Returns the storage slot and value for the approved address of `tokenId`.
800      */
801     function _getApprovedSlotAndAddress(uint256 tokenId)
802         private
803         view
804         returns (uint256 approvedAddressSlot, address approvedAddress)
805     {
806         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
807         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
808         assembly {
809             approvedAddressSlot := tokenApproval.slot
810             approvedAddress := sload(approvedAddressSlot)
811         }
812     }
813 
814     // =============================================================
815     //                      TRANSFER OPERATIONS
816     // =============================================================
817 
818     /**
819      * @dev Transfers `tokenId` from `from` to `to`.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must be owned by `from`.
826      * - If the caller is not `from`, it must be approved to move this token
827      * by either {approve} or {setApprovalForAll}.
828      *
829      * Emits a {Transfer} event.
830      */
831     function transferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) public payable virtual override {
836         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
837 
838         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
839 
840         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
841 
842         // The nested ifs save around 20+ gas over a compound boolean condition.
843         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
844             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
845 
846         if (to == address(0)) revert TransferToZeroAddress();
847 
848         _beforeTokenTransfers(from, to, tokenId, 1);
849 
850         // Clear approvals from the previous owner.
851         assembly {
852             if approvedAddress {
853                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
854                 sstore(approvedAddressSlot, 0)
855             }
856         }
857 
858         // Underflow of the sender's balance is impossible because we check for
859         // ownership above and the recipient's balance can't realistically overflow.
860         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
861         unchecked {
862             // We can directly increment and decrement the balances.
863             --_packedAddressData[from]; // Updates: `balance -= 1`.
864             ++_packedAddressData[to]; // Updates: `balance += 1`.
865 
866             // Updates:
867             // - `address` to the next owner.
868             // - `startTimestamp` to the timestamp of transfering.
869             // - `burned` to `false`.
870             // - `nextInitialized` to `true`.
871             _packedOwnerships[tokenId] = _packOwnershipData(
872                 to,
873                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
874             );
875 
876             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
877             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
878                 uint256 nextTokenId = tokenId + 1;
879                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
880                 if (_packedOwnerships[nextTokenId] == 0) {
881                     // If the next slot is within bounds.
882                     if (nextTokenId != _currentIndex) {
883                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
884                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
885                     }
886                 }
887             }
888         }
889 
890         emit Transfer(from, to, tokenId);
891         _afterTokenTransfers(from, to, tokenId, 1);
892     }
893 
894     /**
895      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId
901     ) public payable virtual override {
902         safeTransferFrom(from, to, tokenId, '');
903     }
904 
905     /**
906      * @dev Safely transfers `tokenId` token from `from` to `to`.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If the caller is not `from`, it must be approved to move this token
914      * by either {approve} or {setApprovalForAll}.
915      * - If `to` refers to a smart contract, it must implement
916      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes memory _data
925     ) public payable virtual override {
926         transferFrom(from, to, tokenId);
927         if (to.code.length != 0)
928             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
929                 revert TransferToNonERC721ReceiverImplementer();
930             }
931     }
932 
933     /**
934      * @dev Hook that is called before a set of serially-ordered token IDs
935      * are about to be transferred. This includes minting.
936      * And also called before burning one token.
937      *
938      * `startTokenId` - the first token ID to be transferred.
939      * `quantity` - the amount to be transferred.
940      *
941      * Calling conditions:
942      *
943      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
944      * transferred to `to`.
945      * - When `from` is zero, `tokenId` will be minted for `to`.
946      * - When `to` is zero, `tokenId` will be burned by `from`.
947      * - `from` and `to` are never both zero.
948      */
949     function _beforeTokenTransfers(
950         address from,
951         address to,
952         uint256 startTokenId,
953         uint256 quantity
954     ) internal virtual {}
955 
956     /**
957      * @dev Hook that is called after a set of serially-ordered token IDs
958      * have been transferred. This includes minting.
959      * And also called after one token has been burned.
960      *
961      * `startTokenId` - the first token ID to be transferred.
962      * `quantity` - the amount to be transferred.
963      *
964      * Calling conditions:
965      *
966      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
967      * transferred to `to`.
968      * - When `from` is zero, `tokenId` has been minted for `to`.
969      * - When `to` is zero, `tokenId` has been burned by `from`.
970      * - `from` and `to` are never both zero.
971      */
972     function _afterTokenTransfers(
973         address from,
974         address to,
975         uint256 startTokenId,
976         uint256 quantity
977     ) internal virtual {}
978 
979     /**
980      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
981      *
982      * `from` - Previous owner of the given token ID.
983      * `to` - Target address that will receive the token.
984      * `tokenId` - Token ID to be transferred.
985      * `_data` - Optional data to send along with the call.
986      *
987      * Returns whether the call correctly returned the expected magic value.
988      */
989     function _checkContractOnERC721Received(
990         address from,
991         address to,
992         uint256 tokenId,
993         bytes memory _data
994     ) private returns (bool) {
995         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
996             bytes4 retval
997         ) {
998             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
999         } catch (bytes memory reason) {
1000             if (reason.length == 0) {
1001                 revert TransferToNonERC721ReceiverImplementer();
1002             } else {
1003                 assembly {
1004                     revert(add(32, reason), mload(reason))
1005                 }
1006             }
1007         }
1008     }
1009 
1010     // =============================================================
1011     //                        MINT OPERATIONS
1012     // =============================================================
1013 
1014     /**
1015      * @dev Mints `quantity` tokens and transfers them to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `quantity` must be greater than 0.
1021      *
1022      * Emits a {Transfer} event for each mint.
1023      */
1024     function _mint(address to, uint256 quantity) internal virtual {
1025         uint256 startTokenId = _currentIndex;
1026         if (quantity == 0) revert MintZeroQuantity();
1027 
1028         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1029 
1030         // Overflows are incredibly unrealistic.
1031         // `balance` and `numberMinted` have a maximum limit of 2**64.
1032         // `tokenId` has a maximum limit of 2**256.
1033         unchecked {
1034             // Updates:
1035             // - `balance += quantity`.
1036             // - `numberMinted += quantity`.
1037             //
1038             // We can directly add to the `balance` and `numberMinted`.
1039             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1040 
1041             // Updates:
1042             // - `address` to the owner.
1043             // - `startTimestamp` to the timestamp of minting.
1044             // - `burned` to `false`.
1045             // - `nextInitialized` to `quantity == 1`.
1046             _packedOwnerships[startTokenId] = _packOwnershipData(
1047                 to,
1048                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1049             );
1050 
1051             uint256 toMasked;
1052             uint256 end = startTokenId + quantity;
1053 
1054             // Use assembly to loop and emit the `Transfer` event for gas savings.
1055             // The duplicated `log4` removes an extra check and reduces stack juggling.
1056             // The assembly, together with the surrounding Solidity code, have been
1057             // delicately arranged to nudge the compiler into producing optimized opcodes.
1058             assembly {
1059                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1060                 toMasked := and(to, _BITMASK_ADDRESS)
1061                 // Emit the `Transfer` event.
1062                 log4(
1063                     0, // Start of data (0, since no data).
1064                     0, // End of data (0, since no data).
1065                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1066                     0, // `address(0)`.
1067                     toMasked, // `to`.
1068                     startTokenId // `tokenId`.
1069                 )
1070 
1071                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1072                 // that overflows uint256 will make the loop run out of gas.
1073                 // The compiler will optimize the `iszero` away for performance.
1074                 for {
1075                     let tokenId := add(startTokenId, 1)
1076                 } iszero(eq(tokenId, end)) {
1077                     tokenId := add(tokenId, 1)
1078                 } {
1079                     // Emit the `Transfer` event. Similar to above.
1080                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1081                 }
1082             }
1083             if (toMasked == 0) revert MintToZeroAddress();
1084 
1085             _currentIndex = end;
1086         }
1087         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1088     }
1089 
1090     /**
1091      * @dev Mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * This function is intended for efficient minting only during contract creation.
1094      *
1095      * It emits only one {ConsecutiveTransfer} as defined in
1096      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1097      * instead of a sequence of {Transfer} event(s).
1098      *
1099      * Calling this function outside of contract creation WILL make your contract
1100      * non-compliant with the ERC721 standard.
1101      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1102      * {ConsecutiveTransfer} event is only permissible during contract creation.
1103      *
1104      * Requirements:
1105      *
1106      * - `to` cannot be the zero address.
1107      * - `quantity` must be greater than 0.
1108      *
1109      * Emits a {ConsecutiveTransfer} event.
1110      */
1111     function _mintERC2309(address to, uint256 quantity) internal virtual {
1112         uint256 startTokenId = _currentIndex;
1113         if (to == address(0)) revert MintToZeroAddress();
1114         if (quantity == 0) revert MintZeroQuantity();
1115         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1116 
1117         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1118 
1119         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1120         unchecked {
1121             // Updates:
1122             // - `balance += quantity`.
1123             // - `numberMinted += quantity`.
1124             //
1125             // We can directly add to the `balance` and `numberMinted`.
1126             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1127 
1128             // Updates:
1129             // - `address` to the owner.
1130             // - `startTimestamp` to the timestamp of minting.
1131             // - `burned` to `false`.
1132             // - `nextInitialized` to `quantity == 1`.
1133             _packedOwnerships[startTokenId] = _packOwnershipData(
1134                 to,
1135                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1136             );
1137 
1138             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1139 
1140             _currentIndex = startTokenId + quantity;
1141         }
1142         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1143     }
1144 
1145     /**
1146      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - If `to` refers to a smart contract, it must implement
1151      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1152      * - `quantity` must be greater than 0.
1153      *
1154      * See {_mint}.
1155      *
1156      * Emits a {Transfer} event for each mint.
1157      */
1158     function _safeMint(
1159         address to,
1160         uint256 quantity,
1161         bytes memory _data
1162     ) internal virtual {
1163         _mint(to, quantity);
1164 
1165         unchecked {
1166             if (to.code.length != 0) {
1167                 uint256 end = _currentIndex;
1168                 uint256 index = end - quantity;
1169                 do {
1170                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1171                         revert TransferToNonERC721ReceiverImplementer();
1172                     }
1173                 } while (index < end);
1174                 // Reentrancy protection.
1175                 if (_currentIndex != end) revert();
1176             }
1177         }
1178     }
1179 
1180     /**
1181      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1182      */
1183     function _safeMint(address to, uint256 quantity) internal virtual {
1184         _safeMint(to, quantity, '');
1185     }
1186 
1187     // =============================================================
1188     //                        BURN OPERATIONS
1189     // =============================================================
1190 
1191     /**
1192      * @dev Equivalent to `_burn(tokenId, false)`.
1193      */
1194     function _burn(uint256 tokenId) internal virtual {
1195         _burn(tokenId, false);
1196     }
1197 
1198     /**
1199      * @dev Destroys `tokenId`.
1200      * The approval is cleared when the token is burned.
1201      *
1202      * Requirements:
1203      *
1204      * - `tokenId` must exist.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1209         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1210 
1211         address from = address(uint160(prevOwnershipPacked));
1212 
1213         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1214 
1215         if (approvalCheck) {
1216             // The nested ifs save around 20+ gas over a compound boolean condition.
1217             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1218                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1219         }
1220 
1221         _beforeTokenTransfers(from, address(0), tokenId, 1);
1222 
1223         // Clear approvals from the previous owner.
1224         assembly {
1225             if approvedAddress {
1226                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1227                 sstore(approvedAddressSlot, 0)
1228             }
1229         }
1230 
1231         // Underflow of the sender's balance is impossible because we check for
1232         // ownership above and the recipient's balance can't realistically overflow.
1233         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1234         unchecked {
1235             // Updates:
1236             // - `balance -= 1`.
1237             // - `numberBurned += 1`.
1238             //
1239             // We can directly decrement the balance, and increment the number burned.
1240             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1241             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1242 
1243             // Updates:
1244             // - `address` to the last owner.
1245             // - `startTimestamp` to the timestamp of burning.
1246             // - `burned` to `true`.
1247             // - `nextInitialized` to `true`.
1248             _packedOwnerships[tokenId] = _packOwnershipData(
1249                 from,
1250                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1251             );
1252 
1253             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1254             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1255                 uint256 nextTokenId = tokenId + 1;
1256                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1257                 if (_packedOwnerships[nextTokenId] == 0) {
1258                     // If the next slot is within bounds.
1259                     if (nextTokenId != _currentIndex) {
1260                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1261                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1262                     }
1263                 }
1264             }
1265         }
1266 
1267         emit Transfer(from, address(0), tokenId);
1268         _afterTokenTransfers(from, address(0), tokenId, 1);
1269 
1270         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1271         unchecked {
1272             _burnCounter++;
1273         }
1274     }
1275 
1276     // =============================================================
1277     //                     EXTRA DATA OPERATIONS
1278     // =============================================================
1279 
1280     /**
1281      * @dev Directly sets the extra data for the ownership data `index`.
1282      */
1283     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1284         uint256 packed = _packedOwnerships[index];
1285         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1286         uint256 extraDataCasted;
1287         // Cast `extraData` with assembly to avoid redundant masking.
1288         assembly {
1289             extraDataCasted := extraData
1290         }
1291         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1292         _packedOwnerships[index] = packed;
1293     }
1294 
1295     /**
1296      * @dev Called during each token transfer to set the 24bit `extraData` field.
1297      * Intended to be overridden by the cosumer contract.
1298      *
1299      * `previousExtraData` - the value of `extraData` before transfer.
1300      *
1301      * Calling conditions:
1302      *
1303      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1304      * transferred to `to`.
1305      * - When `from` is zero, `tokenId` will be minted for `to`.
1306      * - When `to` is zero, `tokenId` will be burned by `from`.
1307      * - `from` and `to` are never both zero.
1308      */
1309     function _extraData(
1310         address from,
1311         address to,
1312         uint24 previousExtraData
1313     ) internal view virtual returns (uint24) {}
1314 
1315     /**
1316      * @dev Returns the next extra data for the packed ownership data.
1317      * The returned result is shifted into position.
1318      */
1319     function _nextExtraData(
1320         address from,
1321         address to,
1322         uint256 prevOwnershipPacked
1323     ) private view returns (uint256) {
1324         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1325         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1326     }
1327 
1328     // =============================================================
1329     //                       OTHER OPERATIONS
1330     // =============================================================
1331 
1332     /**
1333      * @dev Returns the message sender (defaults to `msg.sender`).
1334      *
1335      * If you are writing GSN compatible contracts, you need to override this function.
1336      */
1337     function _msgSenderERC721A() internal view virtual returns (address) {
1338         return msg.sender;
1339     }
1340 
1341     /**
1342      * @dev Converts a uint256 to its ASCII string decimal representation.
1343      */
1344     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1345         assembly {
1346             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1347             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1348             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1349             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1350             let m := add(mload(0x40), 0xa0)
1351             // Update the free memory pointer to allocate.
1352             mstore(0x40, m)
1353             // Assign the `str` to the end.
1354             str := sub(m, 0x20)
1355             // Zeroize the slot after the string.
1356             mstore(str, 0)
1357 
1358             // Cache the end of the memory to calculate the length later.
1359             let end := str
1360 
1361             // We write the string from rightmost digit to leftmost digit.
1362             // The following is essentially a do-while loop that also handles the zero case.
1363             // prettier-ignore
1364             for { let temp := value } 1 {} {
1365                 str := sub(str, 1)
1366                 // Write the character to the pointer.
1367                 // The ASCII index of the '0' character is 48.
1368                 mstore8(str, add(48, mod(temp, 10)))
1369                 // Keep dividing `temp` until zero.
1370                 temp := div(temp, 10)
1371                 // prettier-ignore
1372                 if iszero(temp) { break }
1373             }
1374 
1375             let length := sub(end, str)
1376             // Move the pointer 32 bytes leftwards to make room for the length.
1377             str := sub(str, 0x20)
1378             // Store the length.
1379             mstore(str, length)
1380         }
1381     }
1382 }
1383 
1384 // File: @openzeppelin/contracts/utils/math/Math.sol
1385 
1386 
1387 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1388 
1389 pragma solidity ^0.8.0;
1390 
1391 /**
1392  * @dev Standard math utilities missing in the Solidity language.
1393  */
1394 library Math {
1395     enum Rounding {
1396         Down, // Toward negative infinity
1397         Up, // Toward infinity
1398         Zero // Toward zero
1399     }
1400 
1401     /**
1402      * @dev Returns the largest of two numbers.
1403      */
1404     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1405         return a > b ? a : b;
1406     }
1407 
1408     /**
1409      * @dev Returns the smallest of two numbers.
1410      */
1411     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1412         return a < b ? a : b;
1413     }
1414 
1415     /**
1416      * @dev Returns the average of two numbers. The result is rounded towards
1417      * zero.
1418      */
1419     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1420         // (a + b) / 2 can overflow.
1421         return (a & b) + (a ^ b) / 2;
1422     }
1423 
1424     /**
1425      * @dev Returns the ceiling of the division of two numbers.
1426      *
1427      * This differs from standard division with `/` in that it rounds up instead
1428      * of rounding down.
1429      */
1430     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1431         // (a + b - 1) / b can overflow on addition, so we distribute.
1432         return a == 0 ? 0 : (a - 1) / b + 1;
1433     }
1434 
1435     /**
1436      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1437      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1438      * with further edits by Uniswap Labs also under MIT license.
1439      */
1440     function mulDiv(
1441         uint256 x,
1442         uint256 y,
1443         uint256 denominator
1444     ) internal pure returns (uint256 result) {
1445         unchecked {
1446             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1447             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1448             // variables such that product = prod1 * 2^256 + prod0.
1449             uint256 prod0; // Least significant 256 bits of the product
1450             uint256 prod1; // Most significant 256 bits of the product
1451             assembly {
1452                 let mm := mulmod(x, y, not(0))
1453                 prod0 := mul(x, y)
1454                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1455             }
1456 
1457             // Handle non-overflow cases, 256 by 256 division.
1458             if (prod1 == 0) {
1459                 return prod0 / denominator;
1460             }
1461 
1462             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1463             require(denominator > prod1);
1464 
1465             ///////////////////////////////////////////////
1466             // 512 by 256 division.
1467             ///////////////////////////////////////////////
1468 
1469             // Make division exact by subtracting the remainder from [prod1 prod0].
1470             uint256 remainder;
1471             assembly {
1472                 // Compute remainder using mulmod.
1473                 remainder := mulmod(x, y, denominator)
1474 
1475                 // Subtract 256 bit number from 512 bit number.
1476                 prod1 := sub(prod1, gt(remainder, prod0))
1477                 prod0 := sub(prod0, remainder)
1478             }
1479 
1480             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1481             // See https://cs.stackexchange.com/q/138556/92363.
1482 
1483             // Does not overflow because the denominator cannot be zero at this stage in the function.
1484             uint256 twos = denominator & (~denominator + 1);
1485             assembly {
1486                 // Divide denominator by twos.
1487                 denominator := div(denominator, twos)
1488 
1489                 // Divide [prod1 prod0] by twos.
1490                 prod0 := div(prod0, twos)
1491 
1492                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1493                 twos := add(div(sub(0, twos), twos), 1)
1494             }
1495 
1496             // Shift in bits from prod1 into prod0.
1497             prod0 |= prod1 * twos;
1498 
1499             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1500             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1501             // four bits. That is, denominator * inv = 1 mod 2^4.
1502             uint256 inverse = (3 * denominator) ^ 2;
1503 
1504             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1505             // in modular arithmetic, doubling the correct bits in each step.
1506             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1507             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1508             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1509             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1510             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1511             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1512 
1513             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1514             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1515             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1516             // is no longer required.
1517             result = prod0 * inverse;
1518             return result;
1519         }
1520     }
1521 
1522     /**
1523      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1524      */
1525     function mulDiv(
1526         uint256 x,
1527         uint256 y,
1528         uint256 denominator,
1529         Rounding rounding
1530     ) internal pure returns (uint256) {
1531         uint256 result = mulDiv(x, y, denominator);
1532         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1533             result += 1;
1534         }
1535         return result;
1536     }
1537 
1538     /**
1539      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1540      *
1541      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1542      */
1543     function sqrt(uint256 a) internal pure returns (uint256) {
1544         if (a == 0) {
1545             return 0;
1546         }
1547 
1548         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1549         //
1550         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1551         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1552         //
1553         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1554         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1555         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1556         //
1557         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1558         uint256 result = 1 << (log2(a) >> 1);
1559 
1560         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1561         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1562         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1563         // into the expected uint128 result.
1564         unchecked {
1565             result = (result + a / result) >> 1;
1566             result = (result + a / result) >> 1;
1567             result = (result + a / result) >> 1;
1568             result = (result + a / result) >> 1;
1569             result = (result + a / result) >> 1;
1570             result = (result + a / result) >> 1;
1571             result = (result + a / result) >> 1;
1572             return min(result, a / result);
1573         }
1574     }
1575 
1576     /**
1577      * @notice Calculates sqrt(a), following the selected rounding direction.
1578      */
1579     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1580         unchecked {
1581             uint256 result = sqrt(a);
1582             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1583         }
1584     }
1585 
1586     /**
1587      * @dev Return the log in base 2, rounded down, of a positive value.
1588      * Returns 0 if given 0.
1589      */
1590     function log2(uint256 value) internal pure returns (uint256) {
1591         uint256 result = 0;
1592         unchecked {
1593             if (value >> 128 > 0) {
1594                 value >>= 128;
1595                 result += 128;
1596             }
1597             if (value >> 64 > 0) {
1598                 value >>= 64;
1599                 result += 64;
1600             }
1601             if (value >> 32 > 0) {
1602                 value >>= 32;
1603                 result += 32;
1604             }
1605             if (value >> 16 > 0) {
1606                 value >>= 16;
1607                 result += 16;
1608             }
1609             if (value >> 8 > 0) {
1610                 value >>= 8;
1611                 result += 8;
1612             }
1613             if (value >> 4 > 0) {
1614                 value >>= 4;
1615                 result += 4;
1616             }
1617             if (value >> 2 > 0) {
1618                 value >>= 2;
1619                 result += 2;
1620             }
1621             if (value >> 1 > 0) {
1622                 result += 1;
1623             }
1624         }
1625         return result;
1626     }
1627 
1628     /**
1629      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1630      * Returns 0 if given 0.
1631      */
1632     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1633         unchecked {
1634             uint256 result = log2(value);
1635             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1636         }
1637     }
1638 
1639     /**
1640      * @dev Return the log in base 10, rounded down, of a positive value.
1641      * Returns 0 if given 0.
1642      */
1643     function log10(uint256 value) internal pure returns (uint256) {
1644         uint256 result = 0;
1645         unchecked {
1646             if (value >= 10**64) {
1647                 value /= 10**64;
1648                 result += 64;
1649             }
1650             if (value >= 10**32) {
1651                 value /= 10**32;
1652                 result += 32;
1653             }
1654             if (value >= 10**16) {
1655                 value /= 10**16;
1656                 result += 16;
1657             }
1658             if (value >= 10**8) {
1659                 value /= 10**8;
1660                 result += 8;
1661             }
1662             if (value >= 10**4) {
1663                 value /= 10**4;
1664                 result += 4;
1665             }
1666             if (value >= 10**2) {
1667                 value /= 10**2;
1668                 result += 2;
1669             }
1670             if (value >= 10**1) {
1671                 result += 1;
1672             }
1673         }
1674         return result;
1675     }
1676 
1677     /**
1678      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1679      * Returns 0 if given 0.
1680      */
1681     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1682         unchecked {
1683             uint256 result = log10(value);
1684             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1685         }
1686     }
1687 
1688     /**
1689      * @dev Return the log in base 256, rounded down, of a positive value.
1690      * Returns 0 if given 0.
1691      *
1692      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1693      */
1694     function log256(uint256 value) internal pure returns (uint256) {
1695         uint256 result = 0;
1696         unchecked {
1697             if (value >> 128 > 0) {
1698                 value >>= 128;
1699                 result += 16;
1700             }
1701             if (value >> 64 > 0) {
1702                 value >>= 64;
1703                 result += 8;
1704             }
1705             if (value >> 32 > 0) {
1706                 value >>= 32;
1707                 result += 4;
1708             }
1709             if (value >> 16 > 0) {
1710                 value >>= 16;
1711                 result += 2;
1712             }
1713             if (value >> 8 > 0) {
1714                 result += 1;
1715             }
1716         }
1717         return result;
1718     }
1719 
1720     /**
1721      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1722      * Returns 0 if given 0.
1723      */
1724     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1725         unchecked {
1726             uint256 result = log256(value);
1727             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1728         }
1729     }
1730 }
1731 
1732 // File: @openzeppelin/contracts/utils/Strings.sol
1733 
1734 
1735 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1736 
1737 pragma solidity ^0.8.0;
1738 
1739 
1740 /**
1741  * @dev String operations.
1742  */
1743 library Strings {
1744     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1745     uint8 private constant _ADDRESS_LENGTH = 20;
1746 
1747     /**
1748      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1749      */
1750     function toString(uint256 value) internal pure returns (string memory) {
1751         unchecked {
1752             uint256 length = Math.log10(value) + 1;
1753             string memory buffer = new string(length);
1754             uint256 ptr;
1755             /// @solidity memory-safe-assembly
1756             assembly {
1757                 ptr := add(buffer, add(32, length))
1758             }
1759             while (true) {
1760                 ptr--;
1761                 /// @solidity memory-safe-assembly
1762                 assembly {
1763                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1764                 }
1765                 value /= 10;
1766                 if (value == 0) break;
1767             }
1768             return buffer;
1769         }
1770     }
1771 
1772     /**
1773      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1774      */
1775     function toHexString(uint256 value) internal pure returns (string memory) {
1776         unchecked {
1777             return toHexString(value, Math.log256(value) + 1);
1778         }
1779     }
1780 
1781     /**
1782      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1783      */
1784     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1785         bytes memory buffer = new bytes(2 * length + 2);
1786         buffer[0] = "0";
1787         buffer[1] = "x";
1788         for (uint256 i = 2 * length + 1; i > 1; --i) {
1789             buffer[i] = _SYMBOLS[value & 0xf];
1790             value >>= 4;
1791         }
1792         require(value == 0, "Strings: hex length insufficient");
1793         return string(buffer);
1794     }
1795 
1796     /**
1797      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1798      */
1799     function toHexString(address addr) internal pure returns (string memory) {
1800         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1801     }
1802 }
1803 
1804 // File: @openzeppelin/contracts/utils/Context.sol
1805 
1806 
1807 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1808 
1809 pragma solidity ^0.8.0;
1810 
1811 /**
1812  * @dev Provides information about the current execution context, including the
1813  * sender of the transaction and its data. While these are generally available
1814  * via msg.sender and msg.data, they should not be accessed in such a direct
1815  * manner, since when dealing with meta-transactions the account sending and
1816  * paying for execution may not be the actual sender (as far as an application
1817  * is concerned).
1818  *
1819  * This contract is only required for intermediate, library-like contracts.
1820  */
1821 abstract contract Context {
1822     function _msgSender() internal view virtual returns (address) {
1823         return msg.sender;
1824     }
1825 
1826     function _msgData() internal view virtual returns (bytes calldata) {
1827         return msg.data;
1828     }
1829 }
1830 
1831 // File: @openzeppelin/contracts/access/Ownable.sol
1832 
1833 
1834 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1835 
1836 pragma solidity ^0.8.0;
1837 
1838 
1839 /**
1840  * @dev Contract module which provides a basic access control mechanism, where
1841  * there is an account (an owner) that can be granted exclusive access to
1842  * specific functions.
1843  *
1844  * By default, the owner account will be the one that deploys the contract. This
1845  * can later be changed with {transferOwnership}.
1846  *
1847  * This module is used through inheritance. It will make available the modifier
1848  * `onlyOwner`, which can be applied to your functions to restrict their use to
1849  * the owner.
1850  */
1851 abstract contract Ownable is Context {
1852     address private _owner;
1853 
1854     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1855 
1856     /**
1857      * @dev Initializes the contract setting the deployer as the initial owner.
1858      */
1859     constructor() {
1860         _transferOwnership(_msgSender());
1861     }
1862 
1863     /**
1864      * @dev Throws if called by any account other than the owner.
1865      */
1866     modifier onlyOwner() {
1867         _checkOwner();
1868         _;
1869     }
1870 
1871     /**
1872      * @dev Returns the address of the current owner.
1873      */
1874     function owner() public view virtual returns (address) {
1875         return _owner;
1876     }
1877 
1878     /**
1879      * @dev Throws if the sender is not the owner.
1880      */
1881     function _checkOwner() internal view virtual {
1882         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1883     }
1884 
1885     /**
1886      * @dev Leaves the contract without owner. It will not be possible to call
1887      * `onlyOwner` functions anymore. Can only be called by the current owner.
1888      *
1889      * NOTE: Renouncing ownership will leave the contract without an owner,
1890      * thereby removing any functionality that is only available to the owner.
1891      */
1892     function renounceOwnership() public virtual onlyOwner {
1893         _transferOwnership(address(0));
1894     }
1895 
1896     /**
1897      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1898      * Can only be called by the current owner.
1899      */
1900     function transferOwnership(address newOwner) public virtual onlyOwner {
1901         require(newOwner != address(0), "Ownable: new owner is the zero address");
1902         _transferOwnership(newOwner);
1903     }
1904 
1905     /**
1906      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1907      * Internal function without access restriction.
1908      */
1909     function _transferOwnership(address newOwner) internal virtual {
1910         address oldOwner = _owner;
1911         _owner = newOwner;
1912         emit OwnershipTransferred(oldOwner, newOwner);
1913     }
1914 }
1915 
1916 // File: @openzeppelin/contracts/utils/Address.sol
1917 
1918 
1919 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1920 
1921 pragma solidity ^0.8.1;
1922 
1923 /**
1924  * @dev Collection of functions related to the address type
1925  */
1926 library Address {
1927     /**
1928      * @dev Returns true if `account` is a contract.
1929      *
1930      * [IMPORTANT]
1931      * ====
1932      * It is unsafe to assume that an address for which this function returns
1933      * false is an externally-owned account (EOA) and not a contract.
1934      *
1935      * Among others, `isContract` will return false for the following
1936      * types of addresses:
1937      *
1938      *  - an externally-owned account
1939      *  - a contract in construction
1940      *  - an address where a contract will be created
1941      *  - an address where a contract lived, but was destroyed
1942      * ====
1943      *
1944      * [IMPORTANT]
1945      * ====
1946      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1947      *
1948      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1949      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1950      * constructor.
1951      * ====
1952      */
1953     function isContract(address account) internal view returns (bool) {
1954         // This method relies on extcodesize/address.code.length, which returns 0
1955         // for contracts in construction, since the code is only stored at the end
1956         // of the constructor execution.
1957 
1958         return account.code.length > 0;
1959     }
1960 
1961     /**
1962      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1963      * `recipient`, forwarding all available gas and reverting on errors.
1964      *
1965      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1966      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1967      * imposed by `transfer`, making them unable to receive funds via
1968      * `transfer`. {sendValue} removes this limitation.
1969      *
1970      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1971      *
1972      * IMPORTANT: because control is transferred to `recipient`, care must be
1973      * taken to not create reentrancy vulnerabilities. Consider using
1974      * {ReentrancyGuard} or the
1975      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1976      */
1977     function sendValue(address payable recipient, uint256 amount) internal {
1978         require(address(this).balance >= amount, "Address: insufficient balance");
1979 
1980         (bool success, ) = recipient.call{value: amount}("");
1981         require(success, "Address: unable to send value, recipient may have reverted");
1982     }
1983 
1984     /**
1985      * @dev Performs a Solidity function call using a low level `call`. A
1986      * plain `call` is an unsafe replacement for a function call: use this
1987      * function instead.
1988      *
1989      * If `target` reverts with a revert reason, it is bubbled up by this
1990      * function (like regular Solidity function calls).
1991      *
1992      * Returns the raw returned data. To convert to the expected return value,
1993      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1994      *
1995      * Requirements:
1996      *
1997      * - `target` must be a contract.
1998      * - calling `target` with `data` must not revert.
1999      *
2000      * _Available since v3.1._
2001      */
2002     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2003         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
2004     }
2005 
2006     /**
2007      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2008      * `errorMessage` as a fallback revert reason when `target` reverts.
2009      *
2010      * _Available since v3.1._
2011      */
2012     function functionCall(
2013         address target,
2014         bytes memory data,
2015         string memory errorMessage
2016     ) internal returns (bytes memory) {
2017         return functionCallWithValue(target, data, 0, errorMessage);
2018     }
2019 
2020     /**
2021      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2022      * but also transferring `value` wei to `target`.
2023      *
2024      * Requirements:
2025      *
2026      * - the calling contract must have an ETH balance of at least `value`.
2027      * - the called Solidity function must be `payable`.
2028      *
2029      * _Available since v3.1._
2030      */
2031     function functionCallWithValue(
2032         address target,
2033         bytes memory data,
2034         uint256 value
2035     ) internal returns (bytes memory) {
2036         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
2037     }
2038 
2039     /**
2040      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2041      * with `errorMessage` as a fallback revert reason when `target` reverts.
2042      *
2043      * _Available since v3.1._
2044      */
2045     function functionCallWithValue(
2046         address target,
2047         bytes memory data,
2048         uint256 value,
2049         string memory errorMessage
2050     ) internal returns (bytes memory) {
2051         require(address(this).balance >= value, "Address: insufficient balance for call");
2052         (bool success, bytes memory returndata) = target.call{value: value}(data);
2053         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2054     }
2055 
2056     /**
2057      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2058      * but performing a static call.
2059      *
2060      * _Available since v3.3._
2061      */
2062     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
2063         return functionStaticCall(target, data, "Address: low-level static call failed");
2064     }
2065 
2066     /**
2067      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2068      * but performing a static call.
2069      *
2070      * _Available since v3.3._
2071      */
2072     function functionStaticCall(
2073         address target,
2074         bytes memory data,
2075         string memory errorMessage
2076     ) internal view returns (bytes memory) {
2077         (bool success, bytes memory returndata) = target.staticcall(data);
2078         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2079     }
2080 
2081     /**
2082      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2083      * but performing a delegate call.
2084      *
2085      * _Available since v3.4._
2086      */
2087     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
2088         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
2089     }
2090 
2091     /**
2092      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2093      * but performing a delegate call.
2094      *
2095      * _Available since v3.4._
2096      */
2097     function functionDelegateCall(
2098         address target,
2099         bytes memory data,
2100         string memory errorMessage
2101     ) internal returns (bytes memory) {
2102         (bool success, bytes memory returndata) = target.delegatecall(data);
2103         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
2104     }
2105 
2106     /**
2107      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
2108      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
2109      *
2110      * _Available since v4.8._
2111      */
2112     function verifyCallResultFromTarget(
2113         address target,
2114         bool success,
2115         bytes memory returndata,
2116         string memory errorMessage
2117     ) internal view returns (bytes memory) {
2118         if (success) {
2119             if (returndata.length == 0) {
2120                 // only check isContract if the call was successful and the return data is empty
2121                 // otherwise we already know that it was a contract
2122                 require(isContract(target), "Address: call to non-contract");
2123             }
2124             return returndata;
2125         } else {
2126             _revert(returndata, errorMessage);
2127         }
2128     }
2129 
2130     /**
2131      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
2132      * revert reason or using the provided one.
2133      *
2134      * _Available since v4.3._
2135      */
2136     function verifyCallResult(
2137         bool success,
2138         bytes memory returndata,
2139         string memory errorMessage
2140     ) internal pure returns (bytes memory) {
2141         if (success) {
2142             return returndata;
2143         } else {
2144             _revert(returndata, errorMessage);
2145         }
2146     }
2147 
2148     function _revert(bytes memory returndata, string memory errorMessage) private pure {
2149         // Look for revert reason and bubble it up if present
2150         if (returndata.length > 0) {
2151             // The easiest way to bubble the revert reason is using memory via assembly
2152             /// @solidity memory-safe-assembly
2153             assembly {
2154                 let returndata_size := mload(returndata)
2155                 revert(add(32, returndata), returndata_size)
2156             }
2157         } else {
2158             revert(errorMessage);
2159         }
2160     }
2161 }
2162 
2163 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
2164 
2165 
2166 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
2167 
2168 pragma solidity ^0.8.0;
2169 
2170 /**
2171  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
2172  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
2173  *
2174  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
2175  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
2176  * need to send a transaction, and thus is not required to hold Ether at all.
2177  */
2178 interface IERC20Permit {
2179     /**
2180      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
2181      * given ``owner``'s signed approval.
2182      *
2183      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
2184      * ordering also apply here.
2185      *
2186      * Emits an {Approval} event.
2187      *
2188      * Requirements:
2189      *
2190      * - `spender` cannot be the zero address.
2191      * - `deadline` must be a timestamp in the future.
2192      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
2193      * over the EIP712-formatted function arguments.
2194      * - the signature must use ``owner``'s current nonce (see {nonces}).
2195      *
2196      * For more information on the signature format, see the
2197      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
2198      * section].
2199      */
2200     function permit(
2201         address owner,
2202         address spender,
2203         uint256 value,
2204         uint256 deadline,
2205         uint8 v,
2206         bytes32 r,
2207         bytes32 s
2208     ) external;
2209 
2210     /**
2211      * @dev Returns the current nonce for `owner`. This value must be
2212      * included whenever a signature is generated for {permit}.
2213      *
2214      * Every successful call to {permit} increases ``owner``'s nonce by one. This
2215      * prevents a signature from being used multiple times.
2216      */
2217     function nonces(address owner) external view returns (uint256);
2218 
2219     /**
2220      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
2221      */
2222     // solhint-disable-next-line func-name-mixedcase
2223     function DOMAIN_SEPARATOR() external view returns (bytes32);
2224 }
2225 
2226 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2227 
2228 
2229 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2230 
2231 pragma solidity ^0.8.0;
2232 
2233 /**
2234  * @dev Interface of the ERC20 standard as defined in the EIP.
2235  */
2236 interface IERC20 {
2237     /**
2238      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2239      * another (`to`).
2240      *
2241      * Note that `value` may be zero.
2242      */
2243     event Transfer(address indexed from, address indexed to, uint256 value);
2244 
2245     /**
2246      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2247      * a call to {approve}. `value` is the new allowance.
2248      */
2249     event Approval(address indexed owner, address indexed spender, uint256 value);
2250 
2251     /**
2252      * @dev Returns the amount of tokens in existence.
2253      */
2254     function totalSupply() external view returns (uint256);
2255 
2256     /**
2257      * @dev Returns the amount of tokens owned by `account`.
2258      */
2259     function balanceOf(address account) external view returns (uint256);
2260 
2261     /**
2262      * @dev Moves `amount` tokens from the caller's account to `to`.
2263      *
2264      * Returns a boolean value indicating whether the operation succeeded.
2265      *
2266      * Emits a {Transfer} event.
2267      */
2268     function transfer(address to, uint256 amount) external returns (bool);
2269 
2270     /**
2271      * @dev Returns the remaining number of tokens that `spender` will be
2272      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2273      * zero by default.
2274      *
2275      * This value changes when {approve} or {transferFrom} are called.
2276      */
2277     function allowance(address owner, address spender) external view returns (uint256);
2278 
2279     /**
2280      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2281      *
2282      * Returns a boolean value indicating whether the operation succeeded.
2283      *
2284      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2285      * that someone may use both the old and the new allowance by unfortunate
2286      * transaction ordering. One possible solution to mitigate this race
2287      * condition is to first reduce the spender's allowance to 0 and set the
2288      * desired value afterwards:
2289      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2290      *
2291      * Emits an {Approval} event.
2292      */
2293     function approve(address spender, uint256 amount) external returns (bool);
2294 
2295     /**
2296      * @dev Moves `amount` tokens from `from` to `to` using the
2297      * allowance mechanism. `amount` is then deducted from the caller's
2298      * allowance.
2299      *
2300      * Returns a boolean value indicating whether the operation succeeded.
2301      *
2302      * Emits a {Transfer} event.
2303      */
2304     function transferFrom(
2305         address from,
2306         address to,
2307         uint256 amount
2308     ) external returns (bool);
2309 }
2310 
2311 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
2312 
2313 
2314 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
2315 
2316 pragma solidity ^0.8.0;
2317 
2318 
2319 
2320 
2321 /**
2322  * @title SafeERC20
2323  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2324  * contract returns false). Tokens that return no value (and instead revert or
2325  * throw on failure) are also supported, non-reverting calls are assumed to be
2326  * successful.
2327  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2328  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2329  */
2330 library SafeERC20 {
2331     using Address for address;
2332 
2333     function safeTransfer(
2334         IERC20 token,
2335         address to,
2336         uint256 value
2337     ) internal {
2338         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2339     }
2340 
2341     function safeTransferFrom(
2342         IERC20 token,
2343         address from,
2344         address to,
2345         uint256 value
2346     ) internal {
2347         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2348     }
2349 
2350     /**
2351      * @dev Deprecated. This function has issues similar to the ones found in
2352      * {IERC20-approve}, and its usage is discouraged.
2353      *
2354      * Whenever possible, use {safeIncreaseAllowance} and
2355      * {safeDecreaseAllowance} instead.
2356      */
2357     function safeApprove(
2358         IERC20 token,
2359         address spender,
2360         uint256 value
2361     ) internal {
2362         // safeApprove should only be called when setting an initial allowance,
2363         // or when resetting it to zero. To increase and decrease it, use
2364         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2365         require(
2366             (value == 0) || (token.allowance(address(this), spender) == 0),
2367             "SafeERC20: approve from non-zero to non-zero allowance"
2368         );
2369         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2370     }
2371 
2372     function safeIncreaseAllowance(
2373         IERC20 token,
2374         address spender,
2375         uint256 value
2376     ) internal {
2377         uint256 newAllowance = token.allowance(address(this), spender) + value;
2378         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2379     }
2380 
2381     function safeDecreaseAllowance(
2382         IERC20 token,
2383         address spender,
2384         uint256 value
2385     ) internal {
2386         unchecked {
2387             uint256 oldAllowance = token.allowance(address(this), spender);
2388             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2389             uint256 newAllowance = oldAllowance - value;
2390             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2391         }
2392     }
2393 
2394     function safePermit(
2395         IERC20Permit token,
2396         address owner,
2397         address spender,
2398         uint256 value,
2399         uint256 deadline,
2400         uint8 v,
2401         bytes32 r,
2402         bytes32 s
2403     ) internal {
2404         uint256 nonceBefore = token.nonces(owner);
2405         token.permit(owner, spender, value, deadline, v, r, s);
2406         uint256 nonceAfter = token.nonces(owner);
2407         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
2408     }
2409 
2410     /**
2411      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2412      * on the return value: the return value is optional (but if data is returned, it must not be false).
2413      * @param token The token targeted by the call.
2414      * @param data The call data (encoded using abi.encode or one of its variants).
2415      */
2416     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2417         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2418         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
2419         // the target address contains contract code and also asserts for success in the low-level call.
2420 
2421         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2422         if (returndata.length > 0) {
2423             // Return data is optional
2424             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2425         }
2426     }
2427 }
2428 
2429 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
2430 
2431 
2432 // OpenZeppelin Contracts (last updated v4.8.0) (finance/PaymentSplitter.sol)
2433 
2434 pragma solidity ^0.8.0;
2435 
2436 
2437 
2438 
2439 /**
2440  * @title PaymentSplitter
2441  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2442  * that the Ether will be split in this way, since it is handled transparently by the contract.
2443  *
2444  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2445  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2446  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
2447  * time of contract deployment and can't be updated thereafter.
2448  *
2449  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2450  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2451  * function.
2452  *
2453  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2454  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2455  * to run tests before sending real value to this contract.
2456  */
2457 contract PaymentSplitter is Context {
2458     event PayeeAdded(address account, uint256 shares);
2459     event PaymentReleased(address to, uint256 amount);
2460     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
2461     event PaymentReceived(address from, uint256 amount);
2462 
2463     uint256 private _totalShares;
2464     uint256 private _totalReleased;
2465 
2466     mapping(address => uint256) private _shares;
2467     mapping(address => uint256) private _released;
2468     address[] private _payees;
2469 
2470     mapping(IERC20 => uint256) private _erc20TotalReleased;
2471     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2472 
2473     /**
2474      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2475      * the matching position in the `shares` array.
2476      *
2477      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2478      * duplicates in `payees`.
2479      */
2480     constructor(address[] memory payees, uint256[] memory shares_) payable {
2481         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2482         require(payees.length > 0, "PaymentSplitter: no payees");
2483 
2484         for (uint256 i = 0; i < payees.length; i++) {
2485             _addPayee(payees[i], shares_[i]);
2486         }
2487     }
2488 
2489     /**
2490      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2491      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2492      * reliability of the events, and not the actual splitting of Ether.
2493      *
2494      * To learn more about this see the Solidity documentation for
2495      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2496      * functions].
2497      */
2498     receive() external payable virtual {
2499         emit PaymentReceived(_msgSender(), msg.value);
2500     }
2501 
2502     /**
2503      * @dev Getter for the total shares held by payees.
2504      */
2505     function totalShares() public view returns (uint256) {
2506         return _totalShares;
2507     }
2508 
2509     /**
2510      * @dev Getter for the total amount of Ether already released.
2511      */
2512     function totalReleased() public view returns (uint256) {
2513         return _totalReleased;
2514     }
2515 
2516     /**
2517      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2518      * contract.
2519      */
2520     function totalReleased(IERC20 token) public view returns (uint256) {
2521         return _erc20TotalReleased[token];
2522     }
2523 
2524     /**
2525      * @dev Getter for the amount of shares held by an account.
2526      */
2527     function shares(address account) public view returns (uint256) {
2528         return _shares[account];
2529     }
2530 
2531     /**
2532      * @dev Getter for the amount of Ether already released to a payee.
2533      */
2534     function released(address account) public view returns (uint256) {
2535         return _released[account];
2536     }
2537 
2538     /**
2539      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2540      * IERC20 contract.
2541      */
2542     function released(IERC20 token, address account) public view returns (uint256) {
2543         return _erc20Released[token][account];
2544     }
2545 
2546     /**
2547      * @dev Getter for the address of the payee number `index`.
2548      */
2549     function payee(uint256 index) public view returns (address) {
2550         return _payees[index];
2551     }
2552 
2553     /**
2554      * @dev Getter for the amount of payee's releasable Ether.
2555      */
2556     function releasable(address account) public view returns (uint256) {
2557         uint256 totalReceived = address(this).balance + totalReleased();
2558         return _pendingPayment(account, totalReceived, released(account));
2559     }
2560 
2561     /**
2562      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
2563      * IERC20 contract.
2564      */
2565     function releasable(IERC20 token, address account) public view returns (uint256) {
2566         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
2567         return _pendingPayment(account, totalReceived, released(token, account));
2568     }
2569 
2570     /**
2571      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2572      * total shares and their previous withdrawals.
2573      */
2574     function release(address payable account) public virtual {
2575         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2576 
2577         uint256 payment = releasable(account);
2578 
2579         require(payment != 0, "PaymentSplitter: account is not due payment");
2580 
2581         // _totalReleased is the sum of all values in _released.
2582         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
2583         _totalReleased += payment;
2584         unchecked {
2585             _released[account] += payment;
2586         }
2587 
2588         Address.sendValue(account, payment);
2589         emit PaymentReleased(account, payment);
2590     }
2591 
2592     /**
2593      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2594      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2595      * contract.
2596      */
2597     function release(IERC20 token, address account) public virtual {
2598         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2599 
2600         uint256 payment = releasable(token, account);
2601 
2602         require(payment != 0, "PaymentSplitter: account is not due payment");
2603 
2604         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
2605         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
2606         // cannot overflow.
2607         _erc20TotalReleased[token] += payment;
2608         unchecked {
2609             _erc20Released[token][account] += payment;
2610         }
2611 
2612         SafeERC20.safeTransfer(token, account, payment);
2613         emit ERC20PaymentReleased(token, account, payment);
2614     }
2615 
2616     /**
2617      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
2618      * already released amounts.
2619      */
2620     function _pendingPayment(
2621         address account,
2622         uint256 totalReceived,
2623         uint256 alreadyReleased
2624     ) private view returns (uint256) {
2625         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
2626     }
2627 
2628     /**
2629      * @dev Add a new payee to the contract.
2630      * @param account The address of the payee to add.
2631      * @param shares_ The number of shares owned by the payee.
2632      */
2633     function _addPayee(address account, uint256 shares_) private {
2634         require(account != address(0), "PaymentSplitter: account is the zero address");
2635         require(shares_ > 0, "PaymentSplitter: shares are 0");
2636         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
2637 
2638         _payees.push(account);
2639         _shares[account] = shares_;
2640         _totalShares = _totalShares + shares_;
2641         emit PayeeAdded(account, shares_);
2642     }
2643 }
2644 
2645 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2646 
2647 
2648 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
2649 
2650 pragma solidity ^0.8.0;
2651 
2652 /**
2653  * @dev Contract module that helps prevent reentrant calls to a function.
2654  *
2655  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2656  * available, which can be applied to functions to make sure there are no nested
2657  * (reentrant) calls to them.
2658  *
2659  * Note that because there is a single `nonReentrant` guard, functions marked as
2660  * `nonReentrant` may not call one another. This can be worked around by making
2661  * those functions `private`, and then adding `external` `nonReentrant` entry
2662  * points to them.
2663  *
2664  * TIP: If you would like to learn more about reentrancy and alternative ways
2665  * to protect against it, check out our blog post
2666  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2667  */
2668 abstract contract ReentrancyGuard {
2669     // Booleans are more expensive than uint256 or any type that takes up a full
2670     // word because each write operation emits an extra SLOAD to first read the
2671     // slot's contents, replace the bits taken up by the boolean, and then write
2672     // back. This is the compiler's defense against contract upgrades and
2673     // pointer aliasing, and it cannot be disabled.
2674 
2675     // The values being non-zero value makes deployment a bit more expensive,
2676     // but in exchange the refund on every call to nonReentrant will be lower in
2677     // amount. Since refunds are capped to a percentage of the total
2678     // transaction's gas, it is best to keep them low in cases like this one, to
2679     // increase the likelihood of the full refund coming into effect.
2680     uint256 private constant _NOT_ENTERED = 1;
2681     uint256 private constant _ENTERED = 2;
2682 
2683     uint256 private _status;
2684 
2685     constructor() {
2686         _status = _NOT_ENTERED;
2687     }
2688 
2689     /**
2690      * @dev Prevents a contract from calling itself, directly or indirectly.
2691      * Calling a `nonReentrant` function from another `nonReentrant`
2692      * function is not supported. It is possible to prevent this from happening
2693      * by making the `nonReentrant` function external, and making it call a
2694      * `private` function that does the actual work.
2695      */
2696     modifier nonReentrant() {
2697         _nonReentrantBefore();
2698         _;
2699         _nonReentrantAfter();
2700     }
2701 
2702     function _nonReentrantBefore() private {
2703         // On the first call to nonReentrant, _status will be _NOT_ENTERED
2704         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2705 
2706         // Any calls to nonReentrant after this point will fail
2707         _status = _ENTERED;
2708     }
2709 
2710     function _nonReentrantAfter() private {
2711         // By storing the original value once again, a refund is triggered (see
2712         // https://eips.ethereum.org/EIPS/eip-2200)
2713         _status = _NOT_ENTERED;
2714     }
2715 }
2716 
2717 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2718 
2719 
2720 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
2721 
2722 pragma solidity ^0.8.0;
2723 
2724 /**
2725  * @dev These functions deal with verification of Merkle Tree proofs.
2726  *
2727  * The tree and the proofs can be generated using our
2728  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
2729  * You will find a quickstart guide in the readme.
2730  *
2731  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
2732  * hashing, or use a hash function other than keccak256 for hashing leaves.
2733  * This is because the concatenation of a sorted pair of internal nodes in
2734  * the merkle tree could be reinterpreted as a leaf value.
2735  * OpenZeppelin's JavaScript library generates merkle trees that are safe
2736  * against this attack out of the box.
2737  */
2738 library MerkleProof {
2739     /**
2740      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2741      * defined by `root`. For this, a `proof` must be provided, containing
2742      * sibling hashes on the branch from the leaf to the root of the tree. Each
2743      * pair of leaves and each pair of pre-images are assumed to be sorted.
2744      */
2745     function verify(
2746         bytes32[] memory proof,
2747         bytes32 root,
2748         bytes32 leaf
2749     ) internal pure returns (bool) {
2750         return processProof(proof, leaf) == root;
2751     }
2752 
2753     /**
2754      * @dev Calldata version of {verify}
2755      *
2756      * _Available since v4.7._
2757      */
2758     function verifyCalldata(
2759         bytes32[] calldata proof,
2760         bytes32 root,
2761         bytes32 leaf
2762     ) internal pure returns (bool) {
2763         return processProofCalldata(proof, leaf) == root;
2764     }
2765 
2766     /**
2767      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
2768      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
2769      * hash matches the root of the tree. When processing the proof, the pairs
2770      * of leafs & pre-images are assumed to be sorted.
2771      *
2772      * _Available since v4.4._
2773      */
2774     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
2775         bytes32 computedHash = leaf;
2776         for (uint256 i = 0; i < proof.length; i++) {
2777             computedHash = _hashPair(computedHash, proof[i]);
2778         }
2779         return computedHash;
2780     }
2781 
2782     /**
2783      * @dev Calldata version of {processProof}
2784      *
2785      * _Available since v4.7._
2786      */
2787     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
2788         bytes32 computedHash = leaf;
2789         for (uint256 i = 0; i < proof.length; i++) {
2790             computedHash = _hashPair(computedHash, proof[i]);
2791         }
2792         return computedHash;
2793     }
2794 
2795     /**
2796      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
2797      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
2798      *
2799      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2800      *
2801      * _Available since v4.7._
2802      */
2803     function multiProofVerify(
2804         bytes32[] memory proof,
2805         bool[] memory proofFlags,
2806         bytes32 root,
2807         bytes32[] memory leaves
2808     ) internal pure returns (bool) {
2809         return processMultiProof(proof, proofFlags, leaves) == root;
2810     }
2811 
2812     /**
2813      * @dev Calldata version of {multiProofVerify}
2814      *
2815      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2816      *
2817      * _Available since v4.7._
2818      */
2819     function multiProofVerifyCalldata(
2820         bytes32[] calldata proof,
2821         bool[] calldata proofFlags,
2822         bytes32 root,
2823         bytes32[] memory leaves
2824     ) internal pure returns (bool) {
2825         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2826     }
2827 
2828     /**
2829      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2830      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2831      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2832      * respectively.
2833      *
2834      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2835      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2836      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2837      *
2838      * _Available since v4.7._
2839      */
2840     function processMultiProof(
2841         bytes32[] memory proof,
2842         bool[] memory proofFlags,
2843         bytes32[] memory leaves
2844     ) internal pure returns (bytes32 merkleRoot) {
2845         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2846         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2847         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2848         // the merkle tree.
2849         uint256 leavesLen = leaves.length;
2850         uint256 totalHashes = proofFlags.length;
2851 
2852         // Check proof validity.
2853         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2854 
2855         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2856         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2857         bytes32[] memory hashes = new bytes32[](totalHashes);
2858         uint256 leafPos = 0;
2859         uint256 hashPos = 0;
2860         uint256 proofPos = 0;
2861         // At each step, we compute the next hash using two values:
2862         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2863         //   get the next hash.
2864         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2865         //   `proof` array.
2866         for (uint256 i = 0; i < totalHashes; i++) {
2867             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2868             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2869             hashes[i] = _hashPair(a, b);
2870         }
2871 
2872         if (totalHashes > 0) {
2873             return hashes[totalHashes - 1];
2874         } else if (leavesLen > 0) {
2875             return leaves[0];
2876         } else {
2877             return proof[0];
2878         }
2879     }
2880 
2881     /**
2882      * @dev Calldata version of {processMultiProof}.
2883      *
2884      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2885      *
2886      * _Available since v4.7._
2887      */
2888     function processMultiProofCalldata(
2889         bytes32[] calldata proof,
2890         bool[] calldata proofFlags,
2891         bytes32[] memory leaves
2892     ) internal pure returns (bytes32 merkleRoot) {
2893         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2894         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2895         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2896         // the merkle tree.
2897         uint256 leavesLen = leaves.length;
2898         uint256 totalHashes = proofFlags.length;
2899 
2900         // Check proof validity.
2901         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2902 
2903         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2904         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2905         bytes32[] memory hashes = new bytes32[](totalHashes);
2906         uint256 leafPos = 0;
2907         uint256 hashPos = 0;
2908         uint256 proofPos = 0;
2909         // At each step, we compute the next hash using two values:
2910         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2911         //   get the next hash.
2912         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2913         //   `proof` array.
2914         for (uint256 i = 0; i < totalHashes; i++) {
2915             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2916             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2917             hashes[i] = _hashPair(a, b);
2918         }
2919 
2920         if (totalHashes > 0) {
2921             return hashes[totalHashes - 1];
2922         } else if (leavesLen > 0) {
2923             return leaves[0];
2924         } else {
2925             return proof[0];
2926         }
2927     }
2928 
2929     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2930         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2931     }
2932 
2933     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2934         /// @solidity memory-safe-assembly
2935         assembly {
2936             mstore(0x00, a)
2937             mstore(0x20, b)
2938             value := keccak256(0x00, 0x40)
2939         }
2940     }
2941 }
2942 
2943 // File: contracts/BrainlessSpikes.sol
2944 
2945 
2946 pragma solidity ^0.8.13;
2947 
2948 
2949 contract SPK is Ownable, ERC721A, PaymentSplitter, ReentrancyGuard {
2950 
2951     using Strings for uint;
2952 
2953     string private baseURI;
2954     string public hiddenURI;
2955 
2956     uint256 public maxSupply = 2600;
2957     uint256 public maxMintPerTx = 3;
2958     uint256 public nftPerAddressLimit = 3;
2959 
2960     uint256 public wlprice = 0.069 ether;
2961     uint256 public pubprice = 0.0969 ether;
2962 
2963     bool public paused = true;
2964     bool public revealed = false;
2965 
2966     bool public onlyWhitelisted = true;
2967     bool public onlyPublic = false;
2968 
2969     address private royaltyReceiver;
2970     uint96 private royaltyFeesInBeeps = 700;
2971 
2972     bytes32 public merkleRoot;
2973 
2974     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
2975 
2976     mapping(address => uint256) public addressMintedBalance;
2977 
2978     uint private teamLength;
2979 
2980     constructor(
2981         address[] memory _team,
2982         uint[] memory _teamShares,
2983         bytes32 _merkleRoot, 
2984         string memory _baseURI,
2985         string memory _hiddenURI
2986     ) ERC721A ("Brainless Spikes", "SPK")
2987         PaymentSplitter(_team, _teamShares)
2988     {
2989         merkleRoot = _merkleRoot;
2990         baseURI = _baseURI;
2991         hiddenURI = _hiddenURI;
2992         teamLength = _team.length;
2993     }
2994 
2995     modifier callerIsUser() {
2996         require(tx.origin == msg.sender, "Cannot be called from another contract");
2997         _;
2998     }
2999 
3000     // ****** Mint ****** //
3001 
3002     function mint(uint256 _mintAmount, bytes32[] calldata _proof) external payable nonReentrant callerIsUser{
3003         require(!paused, "The contract is paused");
3004         uint256 supply = totalSupply();
3005         require(_mintAmount > 0, "You need to mint at least 1 NFT");
3006         require(supply + _mintAmount <= maxSupply, "Max supply exceeded!");
3007         require(_mintAmount <= maxMintPerTx, "Max mint amount per session exceeded");
3008         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
3009         require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "Max NFT per address exceeded");
3010         
3011         if(onlyWhitelisted == true) {
3012             uint256 price = wlprice;
3013             require(isWhiteListed(msg.sender, _proof), "You are not whitelisted");
3014             require(msg.value >= price * _mintAmount, "You don't have enought funds");
3015             for (uint256 i = 1; i <= _mintAmount; i++) {
3016                 addressMintedBalance[msg.sender]++;
3017             }
3018             _mint(msg.sender, _mintAmount);
3019         }
3020         
3021         if(onlyPublic == true){
3022             uint256 price = pubprice;
3023             require(msg.value >= price * _mintAmount, "You don't have enought funds");
3024             for (uint256 i = 1; i <= _mintAmount; i++) {
3025                 addressMintedBalance[msg.sender]++;
3026             }
3027             _mint(msg.sender, _mintAmount);
3028         }
3029         
3030     }
3031 
3032     // ****** Miscellaneous ****** //
3033 
3034     function setMaxSupply(uint256 _limit) public onlyOwner {
3035         maxSupply = _limit;
3036     }
3037 
3038     function setmaxMintPerTx(uint256 _limit) public onlyOwner {
3039         maxMintPerTx = _limit;
3040     }
3041 
3042     function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
3043         nftPerAddressLimit = _limit;
3044     }
3045 
3046     function setWLPrice(uint256 _limit) public onlyOwner {
3047         wlprice = _limit;
3048     }
3049 
3050     function setPubPrice(uint256 _limit) public onlyOwner {
3051         pubprice = _limit;
3052     }
3053 
3054     function setOnlyWhitelisted(bool _state) public onlyOwner {
3055         onlyWhitelisted = _state;
3056     }
3057 
3058     function setOnlyPublic(bool _state) public onlyOwner {
3059         onlyPublic = _state;
3060     }
3061 
3062     function setRevealed(bool _state) external onlyOwner {
3063         revealed = _state;
3064     }
3065 
3066     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
3067         uint256 _balance = balanceOf(address_);
3068         uint256[] memory _tokens = new uint256[] (_balance);
3069         uint256 _index;
3070         uint256 _loopThrough = totalSupply();
3071         for (uint256 i = 0; i < _loopThrough; i++) {
3072             bool _exists = _exists(i);
3073             if (_exists) {
3074                 if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
3075             }
3076             else if (!_exists && _tokens[_balance - 1] == 0) { _loopThrough++; }
3077         }
3078         return _tokens;
3079     }
3080 
3081     function _startTokenId() internal view virtual override returns (uint256) {
3082         return 1;
3083     }
3084 
3085     function setPaused(bool _state) external onlyOwner {
3086         paused = _state;
3087     }
3088 
3089     function setBaseUri(string memory _baseURI) external onlyOwner {
3090         baseURI = _baseURI;
3091     }
3092 
3093     function setHiddenMetadataUri(string memory _hiddenURI) external onlyOwner {
3094         hiddenURI = _hiddenURI;
3095     }
3096 
3097     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
3098         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
3099 
3100         if (revealed == false) {
3101             return hiddenURI;
3102         } 
3103 
3104         string memory currentBaseURI = baseURI;
3105 
3106         return bytes(currentBaseURI).length > 0
3107         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
3108         : '';
3109     }
3110 
3111     // ****** Whitelist ****** //
3112 
3113     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
3114         merkleRoot = _merkleRoot;
3115     }
3116 
3117     function isWhiteListed(address _account, bytes32[] calldata _proof) internal view returns(bool) {
3118         return _verify(leaf(_account), _proof);
3119     }
3120 
3121     function leaf(address _account) internal pure returns(bytes32) {
3122         return keccak256(abi.encodePacked(_account));
3123     }
3124 
3125     function _verify(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
3126         return MerkleProof.verify(_proof, merkleRoot, _leaf);
3127     }
3128 
3129     // ****** Giveaway ****** //
3130 
3131     function giveawayMint(uint256 _mintAmount, address _receiver) external onlyOwner{
3132         uint256 supply = totalSupply();
3133         require(_mintAmount > 0, "Giveaway need to be at least 1 NFT");
3134         require(supply + _mintAmount <= maxSupply, "Max supply exceeded!");
3135         _mint(_receiver, _mintAmount);
3136     }
3137 
3138     // ****** withdrawal ****** //
3139 
3140     function withdrawalAll() external onlyOwner nonReentrant {
3141         for(uint i = 0 ; i < teamLength ; i++) {
3142             release(payable(payee(i)));
3143         }
3144     }
3145 
3146     // ****** Implementing Royalty Interface (EIP2981) ****** //
3147     
3148     function supportsInterface(bytes4 interfaceId) 
3149         public 
3150         view 
3151         virtual 
3152         override (ERC721A)
3153         returns (bool) 
3154     {
3155         if (interfaceId == _INTERFACE_ID_ERC2981) {
3156             return true;
3157         }
3158         return super.supportsInterface(interfaceId);
3159     }
3160 
3161     // ****** RoyaltyInfo ****** //
3162     
3163     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
3164         external
3165         view
3166         returns (address receiver, uint256 royaltyAmount)
3167     {
3168         require(_exists(_tokenId), "ERC2981Royality: Cannot query non-existent token");
3169         return (royaltyReceiver, (_salePrice * royaltyFeesInBeeps) / 10000);
3170     }
3171 
3172     function calculatingRoyalties(uint256 _salePrice) view public returns (uint256) {
3173         return (_salePrice / 10000) * royaltyFeesInBeeps;
3174     }
3175 
3176     function setRoyalty(uint96 _royaltyFeesInBeeps) external onlyOwner {
3177         royaltyFeesInBeeps = _royaltyFeesInBeeps;
3178     }
3179 
3180     function setRoyaltyReceiver(address _receiver) external onlyOwner{
3181         royaltyReceiver = _receiver;
3182     }
3183 }