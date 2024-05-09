1 /**
2  _          _ _                                 
3 | |__   ___| | | ___     __ _ _ __   ___  _ __  
4 | '_ \ / _ \ | |/ _ \   / _` | '_ \ / _ \| '_ \ 
5 | | | |  __/ | | (_) | | (_| | | | | (_) | | | |
6 |_| |_|\___|_|_|\___/   \__,_|_| |_|\___/|_| |_|                                                                 
7  */
8 
9 // SPDX-License-Identifier: GPL-3.0
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
905         safeTransferFrom(from, to, tokenId, '');
906     }
907 
908     /**
909      * @dev Safely transfers `tokenId` token from `from` to `to`.
910      *
911      * Requirements:
912      *
913      * - `from` cannot be the zero address.
914      * - `to` cannot be the zero address.
915      * - `tokenId` token must exist and be owned by `from`.
916      * - If the caller is not `from`, it must be approved to move this token
917      * by either {approve} or {setApprovalForAll}.
918      * - If `to` refers to a smart contract, it must implement
919      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function safeTransferFrom(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes memory _data
928     ) public payable virtual override {
929         transferFrom(from, to, tokenId);
930         if (to.code.length != 0)
931             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
932                 revert TransferToNonERC721ReceiverImplementer();
933             }
934     }
935 
936     /**
937      * @dev Hook that is called before a set of serially-ordered token IDs
938      * are about to be transferred. This includes minting.
939      * And also called before burning one token.
940      *
941      * `startTokenId` - the first token ID to be transferred.
942      * `quantity` - the amount to be transferred.
943      *
944      * Calling conditions:
945      *
946      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
947      * transferred to `to`.
948      * - When `from` is zero, `tokenId` will be minted for `to`.
949      * - When `to` is zero, `tokenId` will be burned by `from`.
950      * - `from` and `to` are never both zero.
951      */
952     function _beforeTokenTransfers(
953         address from,
954         address to,
955         uint256 startTokenId,
956         uint256 quantity
957     ) internal virtual {}
958 
959     /**
960      * @dev Hook that is called after a set of serially-ordered token IDs
961      * have been transferred. This includes minting.
962      * And also called after one token has been burned.
963      *
964      * `startTokenId` - the first token ID to be transferred.
965      * `quantity` - the amount to be transferred.
966      *
967      * Calling conditions:
968      *
969      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
970      * transferred to `to`.
971      * - When `from` is zero, `tokenId` has been minted for `to`.
972      * - When `to` is zero, `tokenId` has been burned by `from`.
973      * - `from` and `to` are never both zero.
974      */
975     function _afterTokenTransfers(
976         address from,
977         address to,
978         uint256 startTokenId,
979         uint256 quantity
980     ) internal virtual {}
981 
982     /**
983      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
984      *
985      * `from` - Previous owner of the given token ID.
986      * `to` - Target address that will receive the token.
987      * `tokenId` - Token ID to be transferred.
988      * `_data` - Optional data to send along with the call.
989      *
990      * Returns whether the call correctly returned the expected magic value.
991      */
992     function _checkContractOnERC721Received(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory _data
997     ) private returns (bool) {
998         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
999             bytes4 retval
1000         ) {
1001             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1002         } catch (bytes memory reason) {
1003             if (reason.length == 0) {
1004                 revert TransferToNonERC721ReceiverImplementer();
1005             } else {
1006                 assembly {
1007                     revert(add(32, reason), mload(reason))
1008                 }
1009             }
1010         }
1011     }
1012 
1013     // =============================================================
1014     //                        MINT OPERATIONS
1015     // =============================================================
1016 
1017     /**
1018      * @dev Mints `quantity` tokens and transfers them to `to`.
1019      *
1020      * Requirements:
1021      *
1022      * - `to` cannot be the zero address.
1023      * - `quantity` must be greater than 0.
1024      *
1025      * Emits a {Transfer} event for each mint.
1026      */
1027     function _mint(address to, uint256 quantity) internal virtual {
1028         uint256 startTokenId = _currentIndex;
1029         if (quantity == 0) revert MintZeroQuantity();
1030 
1031         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1032 
1033         // Overflows are incredibly unrealistic.
1034         // `balance` and `numberMinted` have a maximum limit of 2**64.
1035         // `tokenId` has a maximum limit of 2**256.
1036         unchecked {
1037             // Updates:
1038             // - `balance += quantity`.
1039             // - `numberMinted += quantity`.
1040             //
1041             // We can directly add to the `balance` and `numberMinted`.
1042             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1043 
1044             // Updates:
1045             // - `address` to the owner.
1046             // - `startTimestamp` to the timestamp of minting.
1047             // - `burned` to `false`.
1048             // - `nextInitialized` to `quantity == 1`.
1049             _packedOwnerships[startTokenId] = _packOwnershipData(
1050                 to,
1051                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1052             );
1053 
1054             uint256 toMasked;
1055             uint256 end = startTokenId + quantity;
1056 
1057             // Use assembly to loop and emit the `Transfer` event for gas savings.
1058             // The duplicated `log4` removes an extra check and reduces stack juggling.
1059             // The assembly, together with the surrounding Solidity code, have been
1060             // delicately arranged to nudge the compiler into producing optimized opcodes.
1061             assembly {
1062                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1063                 toMasked := and(to, _BITMASK_ADDRESS)
1064                 // Emit the `Transfer` event.
1065                 log4(
1066                     0, // Start of data (0, since no data).
1067                     0, // End of data (0, since no data).
1068                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1069                     0, // `address(0)`.
1070                     toMasked, // `to`.
1071                     startTokenId // `tokenId`.
1072                 )
1073 
1074                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1075                 // that overflows uint256 will make the loop run out of gas.
1076                 // The compiler will optimize the `iszero` away for performance.
1077                 for {
1078                     let tokenId := add(startTokenId, 1)
1079                 } iszero(eq(tokenId, end)) {
1080                     tokenId := add(tokenId, 1)
1081                 } {
1082                     // Emit the `Transfer` event. Similar to above.
1083                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1084                 }
1085             }
1086             if (toMasked == 0) revert MintToZeroAddress();
1087 
1088             _currentIndex = end;
1089         }
1090         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1091     }
1092 
1093     /**
1094      * @dev Mints `quantity` tokens and transfers them to `to`.
1095      *
1096      * This function is intended for efficient minting only during contract creation.
1097      *
1098      * It emits only one {ConsecutiveTransfer} as defined in
1099      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1100      * instead of a sequence of {Transfer} event(s).
1101      *
1102      * Calling this function outside of contract creation WILL make your contract
1103      * non-compliant with the ERC721 standard.
1104      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1105      * {ConsecutiveTransfer} event is only permissible during contract creation.
1106      *
1107      * Requirements:
1108      *
1109      * - `to` cannot be the zero address.
1110      * - `quantity` must be greater than 0.
1111      *
1112      * Emits a {ConsecutiveTransfer} event.
1113      */
1114     function _mintERC2309(address to, uint256 quantity) internal virtual {
1115         uint256 startTokenId = _currentIndex;
1116         if (to == address(0)) revert MintToZeroAddress();
1117         if (quantity == 0) revert MintZeroQuantity();
1118         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1119 
1120         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1121 
1122         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1123         unchecked {
1124             // Updates:
1125             // - `balance += quantity`.
1126             // - `numberMinted += quantity`.
1127             //
1128             // We can directly add to the `balance` and `numberMinted`.
1129             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1130 
1131             // Updates:
1132             // - `address` to the owner.
1133             // - `startTimestamp` to the timestamp of minting.
1134             // - `burned` to `false`.
1135             // - `nextInitialized` to `quantity == 1`.
1136             _packedOwnerships[startTokenId] = _packOwnershipData(
1137                 to,
1138                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1139             );
1140 
1141             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1142 
1143             _currentIndex = startTokenId + quantity;
1144         }
1145         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1146     }
1147 
1148     /**
1149      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - If `to` refers to a smart contract, it must implement
1154      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1155      * - `quantity` must be greater than 0.
1156      *
1157      * See {_mint}.
1158      *
1159      * Emits a {Transfer} event for each mint.
1160      */
1161     function _safeMint(
1162         address to,
1163         uint256 quantity,
1164         bytes memory _data
1165     ) internal virtual {
1166         _mint(to, quantity);
1167 
1168         unchecked {
1169             if (to.code.length != 0) {
1170                 uint256 end = _currentIndex;
1171                 uint256 index = end - quantity;
1172                 do {
1173                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1174                         revert TransferToNonERC721ReceiverImplementer();
1175                     }
1176                 } while (index < end);
1177                 // Reentrancy protection.
1178                 if (_currentIndex != end) revert();
1179             }
1180         }
1181     }
1182 
1183     /**
1184      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1185      */
1186     function _safeMint(address to, uint256 quantity) internal virtual {
1187         _safeMint(to, quantity, '');
1188     }
1189 
1190     // =============================================================
1191     //                        BURN OPERATIONS
1192     // =============================================================
1193 
1194     /**
1195      * @dev Equivalent to `_burn(tokenId, false)`.
1196      */
1197     function _burn(uint256 tokenId) internal virtual {
1198         _burn(tokenId, false);
1199     }
1200 
1201     /**
1202      * @dev Destroys `tokenId`.
1203      * The approval is cleared when the token is burned.
1204      *
1205      * Requirements:
1206      *
1207      * - `tokenId` must exist.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1212         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1213 
1214         address from = address(uint160(prevOwnershipPacked));
1215 
1216         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1217 
1218         if (approvalCheck) {
1219             // The nested ifs save around 20+ gas over a compound boolean condition.
1220             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1221                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1222         }
1223 
1224         _beforeTokenTransfers(from, address(0), tokenId, 1);
1225 
1226         // Clear approvals from the previous owner.
1227         assembly {
1228             if approvedAddress {
1229                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1230                 sstore(approvedAddressSlot, 0)
1231             }
1232         }
1233 
1234         // Underflow of the sender's balance is impossible because we check for
1235         // ownership above and the recipient's balance can't realistically overflow.
1236         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1237         unchecked {
1238             // Updates:
1239             // - `balance -= 1`.
1240             // - `numberBurned += 1`.
1241             //
1242             // We can directly decrement the balance, and increment the number burned.
1243             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1244             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1245 
1246             // Updates:
1247             // - `address` to the last owner.
1248             // - `startTimestamp` to the timestamp of burning.
1249             // - `burned` to `true`.
1250             // - `nextInitialized` to `true`.
1251             _packedOwnerships[tokenId] = _packOwnershipData(
1252                 from,
1253                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1254             );
1255 
1256             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1257             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1258                 uint256 nextTokenId = tokenId + 1;
1259                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1260                 if (_packedOwnerships[nextTokenId] == 0) {
1261                     // If the next slot is within bounds.
1262                     if (nextTokenId != _currentIndex) {
1263                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1264                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1265                     }
1266                 }
1267             }
1268         }
1269 
1270         emit Transfer(from, address(0), tokenId);
1271         _afterTokenTransfers(from, address(0), tokenId, 1);
1272 
1273         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1274         unchecked {
1275             _burnCounter++;
1276         }
1277     }
1278 
1279     // =============================================================
1280     //                     EXTRA DATA OPERATIONS
1281     // =============================================================
1282 
1283     /**
1284      * @dev Directly sets the extra data for the ownership data `index`.
1285      */
1286     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1287         uint256 packed = _packedOwnerships[index];
1288         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1289         uint256 extraDataCasted;
1290         // Cast `extraData` with assembly to avoid redundant masking.
1291         assembly {
1292             extraDataCasted := extraData
1293         }
1294         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1295         _packedOwnerships[index] = packed;
1296     }
1297 
1298     /**
1299      * @dev Called during each token transfer to set the 24bit `extraData` field.
1300      * Intended to be overridden by the cosumer contract.
1301      *
1302      * `previousExtraData` - the value of `extraData` before transfer.
1303      *
1304      * Calling conditions:
1305      *
1306      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1307      * transferred to `to`.
1308      * - When `from` is zero, `tokenId` will be minted for `to`.
1309      * - When `to` is zero, `tokenId` will be burned by `from`.
1310      * - `from` and `to` are never both zero.
1311      */
1312     function _extraData(
1313         address from,
1314         address to,
1315         uint24 previousExtraData
1316     ) internal view virtual returns (uint24) {}
1317 
1318     /**
1319      * @dev Returns the next extra data for the packed ownership data.
1320      * The returned result is shifted into position.
1321      */
1322     function _nextExtraData(
1323         address from,
1324         address to,
1325         uint256 prevOwnershipPacked
1326     ) private view returns (uint256) {
1327         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1328         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1329     }
1330 
1331     // =============================================================
1332     //                       OTHER OPERATIONS
1333     // =============================================================
1334 
1335     /**
1336      * @dev Returns the message sender (defaults to `msg.sender`).
1337      *
1338      * If you are writing GSN compatible contracts, you need to override this function.
1339      */
1340     function _msgSenderERC721A() internal view virtual returns (address) {
1341         return msg.sender;
1342     }
1343 
1344     /**
1345      * @dev Converts a uint256 to its ASCII string decimal representation.
1346      */
1347     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1348         assembly {
1349             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1350             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1351             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1352             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1353             let m := add(mload(0x40), 0xa0)
1354             // Update the free memory pointer to allocate.
1355             mstore(0x40, m)
1356             // Assign the `str` to the end.
1357             str := sub(m, 0x20)
1358             // Zeroize the slot after the string.
1359             mstore(str, 0)
1360 
1361             // Cache the end of the memory to calculate the length later.
1362             let end := str
1363 
1364             // We write the string from rightmost digit to leftmost digit.
1365             // The following is essentially a do-while loop that also handles the zero case.
1366             // prettier-ignore
1367             for { let temp := value } 1 {} {
1368                 str := sub(str, 1)
1369                 // Write the character to the pointer.
1370                 // The ASCII index of the '0' character is 48.
1371                 mstore8(str, add(48, mod(temp, 10)))
1372                 // Keep dividing `temp` until zero.
1373                 temp := div(temp, 10)
1374                 // prettier-ignore
1375                 if iszero(temp) { break }
1376             }
1377 
1378             let length := sub(end, str)
1379             // Move the pointer 32 bytes leftwards to make room for the length.
1380             str := sub(str, 0x20)
1381             // Store the length.
1382             mstore(str, length)
1383         }
1384     }
1385 }
1386 
1387 
1388 interface IOperatorFilterRegistry {
1389     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1390     function register(address registrant) external;
1391     function registerAndSubscribe(address registrant, address subscription) external;
1392     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1393     function unregister(address addr) external;
1394     function updateOperator(address registrant, address operator, bool filtered) external;
1395     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1396     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1397     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1398     function subscribe(address registrant, address registrantToSubscribe) external;
1399     function unsubscribe(address registrant, bool copyExistingEntries) external;
1400     function subscriptionOf(address addr) external returns (address registrant);
1401     function subscribers(address registrant) external returns (address[] memory);
1402     function subscriberAt(address registrant, uint256 index) external returns (address);
1403     function copyEntriesOf(address registrant, address registrantToCopy) external;
1404     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1405     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1406     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1407     function filteredOperators(address addr) external returns (address[] memory);
1408     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1409     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1410     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1411     function isRegistered(address addr) external returns (bool);
1412     function codeHashOf(address addr) external returns (bytes32);
1413 }
1414 
1415 
1416 /**
1417  * @title  OperatorFilterer
1418  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1419  *         registrant's entries in the OperatorFilterRegistry.
1420  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1421  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1422  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1423  */
1424 abstract contract OperatorFilterer {
1425     error OperatorNotAllowed(address operator);
1426 
1427     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1428         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1429 
1430     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1431         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1432         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1433         // order for the modifier to filter addresses.
1434         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1435             if (subscribe) {
1436                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1437             } else {
1438                 if (subscriptionOrRegistrantToCopy != address(0)) {
1439                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1440                 } else {
1441                     OPERATOR_FILTER_REGISTRY.register(address(this));
1442                 }
1443             }
1444         }
1445     }
1446 
1447     modifier onlyAllowedOperator(address from) virtual {
1448         // Check registry code length to facilitate testing in environments without a deployed registry.
1449         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1450             // Allow spending tokens from addresses with balance
1451             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1452             // from an EOA.
1453             if (from == msg.sender) {
1454                 _;
1455                 return;
1456             }
1457             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1458                 revert OperatorNotAllowed(msg.sender);
1459             }
1460         }
1461         _;
1462     }
1463 
1464     modifier onlyAllowedOperatorApproval(address operator) virtual {
1465         // Check registry code length to facilitate testing in environments without a deployed registry.
1466         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1467             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1468                 revert OperatorNotAllowed(operator);
1469             }
1470         }
1471         _;
1472     }
1473 }
1474 
1475 /**
1476  * @title  DefaultOperatorFilterer
1477  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1478  */
1479 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1480     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1481 
1482     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1483 }
1484 
1485 
1486 contract Mynameisnotimportantbuttheartis is ERC721A, DefaultOperatorFilterer {
1487     string public baseURI = "ipfs://bafybeihykuaeg4ld2ca6vyzwzdkdne4tsbpt3uxzocpifsxnq2xln2llsq/";      
1488     uint256 public maxSupply = 999; 
1489     uint256 public price = 0.001 ether;
1490     uint256 public maxPerTx = 20;
1491     uint256 private _baseGasLimit = 80000;
1492     uint256 private _baseDifficulty = 10;
1493     uint256 private _difficultyBais = 120;
1494 
1495     function mint(uint256 amount) payable public {
1496         require(totalSupply() + amount <= maxSupply);
1497         require(amount <= maxPerTx);
1498         require(msg.value >= amount * price);
1499         _safeMint(msg.sender, amount);
1500     }
1501 
1502     function _baseURI() internal view virtual override returns (string memory) {
1503         return baseURI;
1504     }
1505 
1506     function setBaseURI(string memory baseURI_) external onlyOwner {
1507         baseURI = baseURI_;
1508     }     
1509 
1510     function mint() public {
1511         require(gasleft() > _baseGasLimit);       
1512         if (!raffle()) return;
1513         require(msg.sender == tx.origin);
1514         require(totalSupply() + 1 <= maxSupply);
1515         require(balanceOf(msg.sender) == 0);
1516         _safeMint(msg.sender, 1);
1517     }
1518 
1519     function raffle() public view returns(bool) {
1520         uint256 num = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 100;
1521         return num > difficulty();
1522     }
1523 
1524     function difficulty() public view returns(uint256) {
1525         return _baseDifficulty + totalSupply() * _difficultyBais / maxSupply;
1526     }
1527 
1528     address public owner;
1529     modifier onlyOwner {
1530         require(owner == msg.sender);
1531         _;
1532     }
1533 
1534     constructor() ERC721A("My name is not important but the art is", "MNINIBTAI") {
1535         owner = msg.sender;
1536     }
1537     
1538     function setPrice(uint256 newPrice, uint256 maxT) external onlyOwner {
1539         price = newPrice;
1540         maxPerTx = maxT;
1541     }
1542 
1543     // function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1544     //     uint256 royaltyAmount = (_salePrice * 50) / 1000;
1545     //     return (owner, royaltyAmount);
1546     // }
1547     
1548     function withdraw() external onlyOwner {
1549         payable(msg.sender).transfer(address(this).balance);
1550     }
1551 
1552     /////////////////////////////
1553     // OPENSEA FILTER REGISTRY 
1554     /////////////////////////////
1555 
1556     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1557         super.setApprovalForAll(operator, approved);
1558     }
1559 
1560     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1561         super.approve(operator, tokenId);
1562     }
1563 
1564     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1565         super.transferFrom(from, to, tokenId);
1566     }
1567 
1568     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1569         super.safeTransferFrom(from, to, tokenId);
1570     }
1571 
1572     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1573         public
1574         payable
1575         override
1576         onlyAllowedOperator(from)
1577     {
1578         super.safeTransferFrom(from, to, tokenId, data);
1579     }
1580 }