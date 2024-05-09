1 /**
2  *  _____ ______   ___  ________  ___  ___  ___  __    ___     
3  * |\   _ \  _   \|\  \|\_____  \|\  \|\  \|\  \|\  \ |\  \    
4  * \ \  \\\__\ \  \ \  \\|___/  /\ \  \\\  \ \  \/  /|\ \  \   
5  *  \ \  \\|__| \  \ \  \   /  / /\ \  \\\  \ \   ___  \ \  \  
6  *   \ \  \    \ \  \ \  \ /  /_/__\ \  \\\  \ \  \\ \  \ \  \ 
7  *    \ \__\    \ \__\ \__\\________\ \_______\ \__\\ \__\ \__\
8  *     \|__|     \|__|\|__|\|_______|\|_______|\|__| \|__|\|__|
9  */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.8.13;
14 
15 // File: erc721a/contracts/IERC721A.sol
16 
17 // ERC721A Contracts v4.2.3
18 // Creator: Chiru Labs
19 
20 /**
21  * @dev Interface of ERC721A.
22  */
23 interface IERC721A {
24     /**
25      * The caller must own the token or be an approved operator.
26      */
27     error ApprovalCallerNotOwnerNorApproved();
28 
29     /**
30      * The token does not exist.
31      */
32     error ApprovalQueryForNonexistentToken();
33 
34     /**
35      * Cannot query the balance for the zero address.
36      */
37     error BalanceQueryForZeroAddress();
38 
39     /**
40      * Cannot mint to the zero address.
41      */
42     error MintToZeroAddress();
43 
44     /**
45      * The quantity of tokens minted must be more than zero.
46      */
47     error MintZeroQuantity();
48 
49     /**
50      * The token does not exist.
51      */
52     error OwnerQueryForNonexistentToken();
53 
54     /**
55      * The caller must own the token or be an approved operator.
56      */
57     error TransferCallerNotOwnerNorApproved();
58 
59     /**
60      * The token must be owned by `from`.
61      */
62     error TransferFromIncorrectOwner();
63 
64     /**
65      * Cannot safely transfer to a contract that does not implement the
66      * ERC721Receiver interface.
67      */
68     error TransferToNonERC721ReceiverImplementer();
69 
70     /**
71      * Cannot transfer to the zero address.
72      */
73     error TransferToZeroAddress();
74 
75     /**
76      * The token does not exist.
77      */
78     error URIQueryForNonexistentToken();
79 
80     /**
81      * The `quantity` minted with ERC2309 exceeds the safety limit.
82      */
83     error MintERC2309QuantityExceedsLimit();
84 
85     /**
86      * The `extraData` cannot be set on an unintialized ownership slot.
87      */
88     error OwnershipNotInitializedForExtraData();
89 
90     // =============================================================
91     //                            STRUCTS
92     // =============================================================
93 
94     struct TokenOwnership {
95         // The address of the owner.
96         address addr;
97         // Stores the start time of ownership with minimal overhead for tokenomics.
98         uint64 startTimestamp;
99         // Whether the token has been burned.
100         bool burned;
101         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
102         uint24 extraData;
103     }
104 
105     // =============================================================
106     //                         TOKEN COUNTERS
107     // =============================================================
108 
109     /**
110      * @dev Returns the total number of tokens in existence.
111      * Burned tokens will reduce the count.
112      * To get the total number of tokens minted, please see {_totalMinted}.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     // =============================================================
117     //                            IERC165
118     // =============================================================
119 
120     /**
121      * @dev Returns true if this contract implements the interface defined by
122      * `interfaceId`. See the corresponding
123      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
124      * to learn more about how these ids are created.
125      *
126      * This function call must use less than 30000 gas.
127      */
128     function supportsInterface(bytes4 interfaceId) external view returns (bool);
129 
130     // =============================================================
131     //                            IERC721
132     // =============================================================
133 
134     /**
135      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
136      */
137     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
138 
139     /**
140      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
141      */
142     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
143 
144     /**
145      * @dev Emitted when `owner` enables or disables
146      * (`approved`) `operator` to manage all of its assets.
147      */
148     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
149 
150     /**
151      * @dev Returns the number of tokens in `owner`'s account.
152      */
153     function balanceOf(address owner) external view returns (uint256 balance);
154 
155     /**
156      * @dev Returns the owner of the `tokenId` token.
157      *
158      * Requirements:
159      *
160      * - `tokenId` must exist.
161      */
162     function ownerOf(uint256 tokenId) external view returns (address owner);
163 
164     /**
165      * @dev Safely transfers `tokenId` token from `from` to `to`,
166      * checking first that contract recipients are aware of the ERC721 protocol
167      * to prevent tokens from being forever locked.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be have been allowed to move
175      * this token by either {approve} or {setApprovalForAll}.
176      * - If `to` refers to a smart contract, it must implement
177      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
178      *
179      * Emits a {Transfer} event.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId,
185         bytes calldata data
186     ) external payable;
187 
188     /**
189      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
190      */
191     function safeTransferFrom(
192         address from,
193         address to,
194         uint256 tokenId
195     ) external payable;
196 
197     /**
198      * @dev Transfers `tokenId` from `from` to `to`.
199      *
200      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
201      * whenever possible.
202      *
203      * Requirements:
204      *
205      * - `from` cannot be the zero address.
206      * - `to` cannot be the zero address.
207      * - `tokenId` token must be owned by `from`.
208      * - If the caller is not `from`, it must be approved to move this token
209      * by either {approve} or {setApprovalForAll}.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transferFrom(
214         address from,
215         address to,
216         uint256 tokenId
217     ) external payable;
218 
219     /**
220      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
221      * The approval is cleared when the token is transferred.
222      *
223      * Only a single account can be approved at a time, so approving the
224      * zero address clears previous approvals.
225      *
226      * Requirements:
227      *
228      * - The caller must own the token or be an approved operator.
229      * - `tokenId` must exist.
230      *
231      * Emits an {Approval} event.
232      */
233     function approve(address to, uint256 tokenId) external payable;
234 
235     /**
236      * @dev Approve or remove `operator` as an operator for the caller.
237      * Operators can call {transferFrom} or {safeTransferFrom}
238      * for any token owned by the caller.
239      *
240      * Requirements:
241      *
242      * - The `operator` cannot be the caller.
243      *
244      * Emits an {ApprovalForAll} event.
245      */
246     function setApprovalForAll(address operator, bool _approved) external;
247 
248     /**
249      * @dev Returns the account approved for `tokenId` token.
250      *
251      * Requirements:
252      *
253      * - `tokenId` must exist.
254      */
255     function getApproved(uint256 tokenId) external view returns (address operator);
256 
257     /**
258      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
259      *
260      * See {setApprovalForAll}.
261      */
262     function isApprovedForAll(address owner, address operator) external view returns (bool);
263 
264     // =============================================================
265     //                        IERC721Metadata
266     // =============================================================
267 
268     /**
269      * @dev Returns the token collection name.
270      */
271     function name() external view returns (string memory);
272 
273     /**
274      * @dev Returns the token collection symbol.
275      */
276     function symbol() external view returns (string memory);
277 
278     /**
279      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
280      */
281     function tokenURI(uint256 tokenId) external view returns (string memory);
282 
283     // =============================================================
284     //                           IERC2309
285     // =============================================================
286 
287     /**
288      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
289      * (inclusive) is transferred from `from` to `to`, as defined in the
290      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
291      *
292      * See {_mintERC2309} for more details.
293      */
294     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
295 }
296 
297 // File: erc721a/contracts/ERC721A.sol
298 
299 // ERC721A Contracts v4.2.3
300 // Creator: Chiru Labs
301 
302 pragma solidity ^0.8.4;
303 
304 /**
305  * @dev Interface of ERC721 token receiver.
306  */
307 interface ERC721A__IERC721Receiver {
308     function onERC721Received(
309         address operator,
310         address from,
311         uint256 tokenId,
312         bytes calldata data
313     ) external returns (bytes4);
314 }
315 
316 /**
317  * @title ERC721A
318  *
319  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
320  * Non-Fungible Token Standard, including the Metadata extension.
321  * Optimized for lower gas during batch mints.
322  *
323  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
324  * starting from `_startTokenId()`.
325  *
326  * Assumptions:
327  *
328  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
329  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
330  */
331 contract ERC721A is IERC721A {
332     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
333     struct TokenApprovalRef {
334         address value;
335     }
336 
337     // =============================================================
338     //                           CONSTANTS
339     // =============================================================
340 
341     // Mask of an entry in packed address data.
342     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
343 
344     // The bit position of `numberMinted` in packed address data.
345     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
346 
347     // The bit position of `numberBurned` in packed address data.
348     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
349 
350     // The bit position of `aux` in packed address data.
351     uint256 private constant _BITPOS_AUX = 192;
352 
353     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
354     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
355 
356     // The bit position of `startTimestamp` in packed ownership.
357     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
358 
359     // The bit mask of the `burned` bit in packed ownership.
360     uint256 private constant _BITMASK_BURNED = 1 << 224;
361 
362     // The bit position of the `nextInitialized` bit in packed ownership.
363     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
364 
365     // The bit mask of the `nextInitialized` bit in packed ownership.
366     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
367 
368     // The bit position of `extraData` in packed ownership.
369     uint256 private constant _BITPOS_EXTRA_DATA = 232;
370 
371     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
372     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
373 
374     // The mask of the lower 160 bits for addresses.
375     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
376 
377     // The maximum `quantity` that can be minted with {_mintERC2309}.
378     // This limit is to prevent overflows on the address data entries.
379     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
380     // is required to cause an overflow, which is unrealistic.
381     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
382 
383     // The `Transfer` event signature is given by:
384     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
385     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
386         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
387 
388     // =============================================================
389     //                            STORAGE
390     // =============================================================
391 
392     // The next token ID to be minted.
393     uint256 private _currentIndex;
394 
395     // The number of tokens burned.
396     uint256 private _burnCounter;
397 
398     // Token name
399     string private _name;
400 
401     // Token symbol
402     string private _symbol;
403 
404     // Mapping from token ID to ownership details
405     // An empty struct value does not necessarily mean the token is unowned.
406     // See {_packedOwnershipOf} implementation for details.
407     //
408     // Bits Layout:
409     // - [0..159]   `addr`
410     // - [160..223] `startTimestamp`
411     // - [224]      `burned`
412     // - [225]      `nextInitialized`
413     // - [232..255] `extraData`
414     mapping(uint256 => uint256) private _packedOwnerships;
415 
416     // Mapping owner address to address data.
417     //
418     // Bits Layout:
419     // - [0..63]    `balance`
420     // - [64..127]  `numberMinted`
421     // - [128..191] `numberBurned`
422     // - [192..255] `aux`
423     mapping(address => uint256) private _packedAddressData;
424 
425     // Mapping from token ID to approved address.
426     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
427 
428     // Mapping from owner to operator approvals
429     mapping(address => mapping(address => bool)) private _operatorApprovals;
430 
431     // =============================================================
432     //                          CONSTRUCTOR
433     // =============================================================
434 
435     constructor(string memory name_, string memory symbol_) {
436         _name = name_;
437         _symbol = symbol_;
438         _currentIndex = _startTokenId();
439     }
440 
441     // =============================================================
442     //                   TOKEN COUNTING OPERATIONS
443     // =============================================================
444 
445     /**
446      * @dev Returns the starting token ID.
447      * To change the starting token ID, please override this function.
448      */
449     function _startTokenId() internal view virtual returns (uint256) {
450         return 0;
451     }
452 
453     /**
454      * @dev Returns the next token ID to be minted.
455      */
456     function _nextTokenId() internal view virtual returns (uint256) {
457         return _currentIndex;
458     }
459 
460     /**
461      * @dev Returns the total number of tokens in existence.
462      * Burned tokens will reduce the count.
463      * To get the total number of tokens minted, please see {_totalMinted}.
464      */
465     function totalSupply() public view virtual override returns (uint256) {
466         // Counter underflow is impossible as _burnCounter cannot be incremented
467         // more than `_currentIndex - _startTokenId()` times.
468         unchecked {
469             return _currentIndex - _burnCounter - _startTokenId();
470         }
471     }
472 
473     /**
474      * @dev Returns the total amount of tokens minted in the contract.
475      */
476     function _totalMinted() internal view virtual returns (uint256) {
477         // Counter underflow is impossible as `_currentIndex` does not decrement,
478         // and it is initialized to `_startTokenId()`.
479         unchecked {
480             return _currentIndex - _startTokenId();
481         }
482     }
483 
484     /**
485      * @dev Returns the total number of tokens burned.
486      */
487     function _totalBurned() internal view virtual returns (uint256) {
488         return _burnCounter;
489     }
490 
491     // =============================================================
492     //                    ADDRESS DATA OPERATIONS
493     // =============================================================
494 
495     /**
496      * @dev Returns the number of tokens in `owner`'s account.
497      */
498     function balanceOf(address owner) public view virtual override returns (uint256) {
499         if (owner == address(0)) revert BalanceQueryForZeroAddress();
500         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
501     }
502 
503     /**
504      * Returns the number of tokens minted by `owner`.
505      */
506     function _numberMinted(address owner) internal view returns (uint256) {
507         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
508     }
509 
510     /**
511      * Returns the number of tokens burned by or on behalf of `owner`.
512      */
513     function _numberBurned(address owner) internal view returns (uint256) {
514         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
515     }
516 
517     /**
518      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
519      */
520     function _getAux(address owner) internal view returns (uint64) {
521         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
522     }
523 
524     /**
525      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
526      * If there are multiple variables, please pack them into a uint64.
527      */
528     function _setAux(address owner, uint64 aux) internal virtual {
529         uint256 packed = _packedAddressData[owner];
530         uint256 auxCasted;
531         // Cast `aux` with assembly to avoid redundant masking.
532         assembly {
533             auxCasted := aux
534         }
535         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
536         _packedAddressData[owner] = packed;
537     }
538 
539     // =============================================================
540     //                            IERC165
541     // =============================================================
542 
543     /**
544      * @dev Returns true if this contract implements the interface defined by
545      * `interfaceId`. See the corresponding
546      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
547      * to learn more about how these ids are created.
548      *
549      * This function call must use less than 30000 gas.
550      */
551     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552         // The interface IDs are constants representing the first 4 bytes
553         // of the XOR of all function selectors in the interface.
554         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
555         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
556         return
557             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
558             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
559             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
560     }
561 
562     // =============================================================
563     //                        IERC721Metadata
564     // =============================================================
565 
566     /**
567      * @dev Returns the token collection name.
568      */
569     function name() public view virtual override returns (string memory) {
570         return _name;
571     }
572 
573     /**
574      * @dev Returns the token collection symbol.
575      */
576     function symbol() public view virtual override returns (string memory) {
577         return _symbol;
578     }
579 
580     /**
581      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
582      */
583     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
584         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
585 
586         string memory baseURI = _baseURI();
587         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
588     }
589 
590     /**
591      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
592      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
593      * by default, it can be overridden in child contracts.
594      */
595     function _baseURI() internal view virtual returns (string memory) {
596         return '';
597     }
598 
599     // =============================================================
600     //                     OWNERSHIPS OPERATIONS
601     // =============================================================
602 
603     /**
604      * @dev Returns the owner of the `tokenId` token.
605      *
606      * Requirements:
607      *
608      * - `tokenId` must exist.
609      */
610     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
611         return address(uint160(_packedOwnershipOf(tokenId)));
612     }
613 
614     /**
615      * @dev Gas spent here starts off proportional to the maximum mint batch size.
616      * It gradually moves to O(1) as tokens get transferred around over time.
617      */
618     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
619         return _unpackedOwnership(_packedOwnershipOf(tokenId));
620     }
621 
622     /**
623      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
624      */
625     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
626         return _unpackedOwnership(_packedOwnerships[index]);
627     }
628 
629     /**
630      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
631      */
632     function _initializeOwnershipAt(uint256 index) internal virtual {
633         if (_packedOwnerships[index] == 0) {
634             _packedOwnerships[index] = _packedOwnershipOf(index);
635         }
636     }
637 
638     /**
639      * Returns the packed ownership data of `tokenId`.
640      */
641     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
642         uint256 curr = tokenId;
643 
644         unchecked {
645             if (_startTokenId() <= curr)
646                 if (curr < _currentIndex) {
647                     uint256 packed = _packedOwnerships[curr];
648                     // If not burned.
649                     if (packed & _BITMASK_BURNED == 0) {
650                         // Invariant:
651                         // There will always be an initialized ownership slot
652                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
653                         // before an unintialized ownership slot
654                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
655                         // Hence, `curr` will not underflow.
656                         //
657                         // We can directly compare the packed value.
658                         // If the address is zero, packed will be zero.
659                         while (packed == 0) {
660                             packed = _packedOwnerships[--curr];
661                         }
662                         return packed;
663                     }
664                 }
665         }
666         revert OwnerQueryForNonexistentToken();
667     }
668 
669     /**
670      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
671      */
672     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
673         ownership.addr = address(uint160(packed));
674         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
675         ownership.burned = packed & _BITMASK_BURNED != 0;
676         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
677     }
678 
679     /**
680      * @dev Packs ownership data into a single uint256.
681      */
682     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
683         assembly {
684             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
685             owner := and(owner, _BITMASK_ADDRESS)
686             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
687             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
688         }
689     }
690 
691     /**
692      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
693      */
694     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
695         // For branchless setting of the `nextInitialized` flag.
696         assembly {
697             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
698             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
699         }
700     }
701 
702     // =============================================================
703     //                      APPROVAL OPERATIONS
704     // =============================================================
705 
706     /**
707      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
708      * The approval is cleared when the token is transferred.
709      *
710      * Only a single account can be approved at a time, so approving the
711      * zero address clears previous approvals.
712      *
713      * Requirements:
714      *
715      * - The caller must own the token or be an approved operator.
716      * - `tokenId` must exist.
717      *
718      * Emits an {Approval} event.
719      */
720     function approve(address to, uint256 tokenId) public payable virtual override {
721         address owner = ownerOf(tokenId);
722 
723         if (_msgSenderERC721A() != owner)
724             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
725                 revert ApprovalCallerNotOwnerNorApproved();
726             }
727 
728         _tokenApprovals[tokenId].value = to;
729         emit Approval(owner, to, tokenId);
730     }
731 
732     /**
733      * @dev Returns the account approved for `tokenId` token.
734      *
735      * Requirements:
736      *
737      * - `tokenId` must exist.
738      */
739     function getApproved(uint256 tokenId) public view virtual override returns (address) {
740         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
741 
742         return _tokenApprovals[tokenId].value;
743     }
744 
745     /**
746      * @dev Approve or remove `operator` as an operator for the caller.
747      * Operators can call {transferFrom} or {safeTransferFrom}
748      * for any token owned by the caller.
749      *
750      * Requirements:
751      *
752      * - The `operator` cannot be the caller.
753      *
754      * Emits an {ApprovalForAll} event.
755      */
756     function setApprovalForAll(address operator, bool approved) public virtual override {
757         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
758         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
759     }
760 
761     /**
762      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
763      *
764      * See {setApprovalForAll}.
765      */
766     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
767         return _operatorApprovals[owner][operator];
768     }
769 
770     /**
771      * @dev Returns whether `tokenId` exists.
772      *
773      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
774      *
775      * Tokens start existing when they are minted. See {_mint}.
776      */
777     function _exists(uint256 tokenId) internal view virtual returns (bool) {
778         return
779             _startTokenId() <= tokenId &&
780             tokenId < _currentIndex && // If within bounds,
781             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
782     }
783 
784     /**
785      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
786      */
787     function _isSenderApprovedOrOwner(
788         address approvedAddress,
789         address owner,
790         address msgSender
791     ) private pure returns (bool result) {
792         assembly {
793             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
794             owner := and(owner, _BITMASK_ADDRESS)
795             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
796             msgSender := and(msgSender, _BITMASK_ADDRESS)
797             // `msgSender == owner || msgSender == approvedAddress`.
798             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
799         }
800     }
801 
802     /**
803      * @dev Returns the storage slot and value for the approved address of `tokenId`.
804      */
805     function _getApprovedSlotAndAddress(uint256 tokenId)
806         private
807         view
808         returns (uint256 approvedAddressSlot, address approvedAddress)
809     {
810         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
811         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
812         assembly {
813             approvedAddressSlot := tokenApproval.slot
814             approvedAddress := sload(approvedAddressSlot)
815         }
816     }
817 
818     // =============================================================
819     //                      TRANSFER OPERATIONS
820     // =============================================================
821 
822     /**
823      * @dev Transfers `tokenId` from `from` to `to`.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must be owned by `from`.
830      * - If the caller is not `from`, it must be approved to move this token
831      * by either {approve} or {setApprovalForAll}.
832      *
833      * Emits a {Transfer} event.
834      */
835     function transferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) public payable virtual override {
840         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
841 
842         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
843 
844         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
845 
846         // The nested ifs save around 20+ gas over a compound boolean condition.
847         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
848             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
849 
850         if (to == address(0)) revert TransferToZeroAddress();
851 
852         _beforeTokenTransfers(from, to, tokenId, 1);
853 
854         // Clear approvals from the previous owner.
855         assembly {
856             if approvedAddress {
857                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
858                 sstore(approvedAddressSlot, 0)
859             }
860         }
861 
862         // Underflow of the sender's balance is impossible because we check for
863         // ownership above and the recipient's balance can't realistically overflow.
864         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
865         unchecked {
866             // We can directly increment and decrement the balances.
867             --_packedAddressData[from]; // Updates: `balance -= 1`.
868             ++_packedAddressData[to]; // Updates: `balance += 1`.
869 
870             // Updates:
871             // - `address` to the next owner.
872             // - `startTimestamp` to the timestamp of transfering.
873             // - `burned` to `false`.
874             // - `nextInitialized` to `true`.
875             _packedOwnerships[tokenId] = _packOwnershipData(
876                 to,
877                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
878             );
879 
880             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
881             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
882                 uint256 nextTokenId = tokenId + 1;
883                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
884                 if (_packedOwnerships[nextTokenId] == 0) {
885                     // If the next slot is within bounds.
886                     if (nextTokenId != _currentIndex) {
887                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
888                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
889                     }
890                 }
891             }
892         }
893 
894         emit Transfer(from, to, tokenId);
895         _afterTokenTransfers(from, to, tokenId, 1);
896     }
897 
898     /**
899      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) public payable virtual override {
906         safeTransferFrom(from, to, tokenId, '');
907     }
908 
909     /**
910      * @dev Safely transfers `tokenId` token from `from` to `to`.
911      *
912      * Requirements:
913      *
914      * - `from` cannot be the zero address.
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must exist and be owned by `from`.
917      * - If the caller is not `from`, it must be approved to move this token
918      * by either {approve} or {setApprovalForAll}.
919      * - If `to` refers to a smart contract, it must implement
920      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
921      *
922      * Emits a {Transfer} event.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId,
928         bytes memory _data
929     ) public payable virtual override {
930         transferFrom(from, to, tokenId);
931         if (to.code.length != 0)
932             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
933                 revert TransferToNonERC721ReceiverImplementer();
934             }
935     }
936 
937     /**
938      * @dev Hook that is called before a set of serially-ordered token IDs
939      * are about to be transferred. This includes minting.
940      * And also called before burning one token.
941      *
942      * `startTokenId` - the first token ID to be transferred.
943      * `quantity` - the amount to be transferred.
944      *
945      * Calling conditions:
946      *
947      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
948      * transferred to `to`.
949      * - When `from` is zero, `tokenId` will be minted for `to`.
950      * - When `to` is zero, `tokenId` will be burned by `from`.
951      * - `from` and `to` are never both zero.
952      */
953     function _beforeTokenTransfers(
954         address from,
955         address to,
956         uint256 startTokenId,
957         uint256 quantity
958     ) internal virtual {}
959 
960     /**
961      * @dev Hook that is called after a set of serially-ordered token IDs
962      * have been transferred. This includes minting.
963      * And also called after one token has been burned.
964      *
965      * `startTokenId` - the first token ID to be transferred.
966      * `quantity` - the amount to be transferred.
967      *
968      * Calling conditions:
969      *
970      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
971      * transferred to `to`.
972      * - When `from` is zero, `tokenId` has been minted for `to`.
973      * - When `to` is zero, `tokenId` has been burned by `from`.
974      * - `from` and `to` are never both zero.
975      */
976     function _afterTokenTransfers(
977         address from,
978         address to,
979         uint256 startTokenId,
980         uint256 quantity
981     ) internal virtual {}
982 
983     /**
984      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
985      *
986      * `from` - Previous owner of the given token ID.
987      * `to` - Target address that will receive the token.
988      * `tokenId` - Token ID to be transferred.
989      * `_data` - Optional data to send along with the call.
990      *
991      * Returns whether the call correctly returned the expected magic value.
992      */
993     function _checkContractOnERC721Received(
994         address from,
995         address to,
996         uint256 tokenId,
997         bytes memory _data
998     ) private returns (bool) {
999         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1000             bytes4 retval
1001         ) {
1002             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1003         } catch (bytes memory reason) {
1004             if (reason.length == 0) {
1005                 revert TransferToNonERC721ReceiverImplementer();
1006             } else {
1007                 assembly {
1008                     revert(add(32, reason), mload(reason))
1009                 }
1010             }
1011         }
1012     }
1013 
1014     // =============================================================
1015     //                        MINT OPERATIONS
1016     // =============================================================
1017 
1018     /**
1019      * @dev Mints `quantity` tokens and transfers them to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `to` cannot be the zero address.
1024      * - `quantity` must be greater than 0.
1025      *
1026      * Emits a {Transfer} event for each mint.
1027      */
1028     function _mint(address to, uint256 quantity) internal virtual {
1029         uint256 startTokenId = _currentIndex;
1030         if (quantity == 0) revert MintZeroQuantity();
1031 
1032         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1033 
1034         // Overflows are incredibly unrealistic.
1035         // `balance` and `numberMinted` have a maximum limit of 2**64.
1036         // `tokenId` has a maximum limit of 2**256.
1037         unchecked {
1038             // Updates:
1039             // - `balance += quantity`.
1040             // - `numberMinted += quantity`.
1041             //
1042             // We can directly add to the `balance` and `numberMinted`.
1043             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1044 
1045             // Updates:
1046             // - `address` to the owner.
1047             // - `startTimestamp` to the timestamp of minting.
1048             // - `burned` to `false`.
1049             // - `nextInitialized` to `quantity == 1`.
1050             _packedOwnerships[startTokenId] = _packOwnershipData(
1051                 to,
1052                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1053             );
1054 
1055             uint256 toMasked;
1056             uint256 end = startTokenId + quantity;
1057 
1058             // Use assembly to loop and emit the `Transfer` event for gas savings.
1059             // The duplicated `log4` removes an extra check and reduces stack juggling.
1060             // The assembly, together with the surrounding Solidity code, have been
1061             // delicately arranged to nudge the compiler into producing optimized opcodes.
1062             assembly {
1063                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1064                 toMasked := and(to, _BITMASK_ADDRESS)
1065                 // Emit the `Transfer` event.
1066                 log4(
1067                     0, // Start of data (0, since no data).
1068                     0, // End of data (0, since no data).
1069                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1070                     0, // `address(0)`.
1071                     toMasked, // `to`.
1072                     startTokenId // `tokenId`.
1073                 )
1074 
1075                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1076                 // that overflows uint256 will make the loop run out of gas.
1077                 // The compiler will optimize the `iszero` away for performance.
1078                 for {
1079                     let tokenId := add(startTokenId, 1)
1080                 } iszero(eq(tokenId, end)) {
1081                     tokenId := add(tokenId, 1)
1082                 } {
1083                     // Emit the `Transfer` event. Similar to above.
1084                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1085                 }
1086             }
1087             if (toMasked == 0) revert MintToZeroAddress();
1088 
1089             _currentIndex = end;
1090         }
1091         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1092     }
1093 
1094     /**
1095      * @dev Mints `quantity` tokens and transfers them to `to`.
1096      *
1097      * This function is intended for efficient minting only during contract creation.
1098      *
1099      * It emits only one {ConsecutiveTransfer} as defined in
1100      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1101      * instead of a sequence of {Transfer} event(s).
1102      *
1103      * Calling this function outside of contract creation WILL make your contract
1104      * non-compliant with the ERC721 standard.
1105      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1106      * {ConsecutiveTransfer} event is only permissible during contract creation.
1107      *
1108      * Requirements:
1109      *
1110      * - `to` cannot be the zero address.
1111      * - `quantity` must be greater than 0.
1112      *
1113      * Emits a {ConsecutiveTransfer} event.
1114      */
1115     function _mintERC2309(address to, uint256 quantity) internal virtual {
1116         uint256 startTokenId = _currentIndex;
1117         if (to == address(0)) revert MintToZeroAddress();
1118         if (quantity == 0) revert MintZeroQuantity();
1119         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1120 
1121         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1122 
1123         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1124         unchecked {
1125             // Updates:
1126             // - `balance += quantity`.
1127             // - `numberMinted += quantity`.
1128             //
1129             // We can directly add to the `balance` and `numberMinted`.
1130             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1131 
1132             // Updates:
1133             // - `address` to the owner.
1134             // - `startTimestamp` to the timestamp of minting.
1135             // - `burned` to `false`.
1136             // - `nextInitialized` to `quantity == 1`.
1137             _packedOwnerships[startTokenId] = _packOwnershipData(
1138                 to,
1139                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1140             );
1141 
1142             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1143 
1144             _currentIndex = startTokenId + quantity;
1145         }
1146         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1147     }
1148 
1149     /**
1150      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1151      *
1152      * Requirements:
1153      *
1154      * - If `to` refers to a smart contract, it must implement
1155      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1156      * - `quantity` must be greater than 0.
1157      *
1158      * See {_mint}.
1159      *
1160      * Emits a {Transfer} event for each mint.
1161      */
1162     function _safeMint(
1163         address to,
1164         uint256 quantity,
1165         bytes memory _data
1166     ) internal virtual {
1167         _mint(to, quantity);
1168 
1169         unchecked {
1170             if (to.code.length != 0) {
1171                 uint256 end = _currentIndex;
1172                 uint256 index = end - quantity;
1173                 do {
1174                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1175                         revert TransferToNonERC721ReceiverImplementer();
1176                     }
1177                 } while (index < end);
1178                 // Reentrancy protection.
1179                 if (_currentIndex != end) revert();
1180             }
1181         }
1182     }
1183 
1184     /**
1185      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1186      */
1187     function _safeMint(address to, uint256 quantity) internal virtual {
1188         _safeMint(to, quantity, '');
1189     }
1190 
1191     // =============================================================
1192     //                        BURN OPERATIONS
1193     // =============================================================
1194 
1195     /**
1196      * @dev Equivalent to `_burn(tokenId, false)`.
1197      */
1198     function _burn(uint256 tokenId) internal virtual {
1199         _burn(tokenId, false);
1200     }
1201 
1202     /**
1203      * @dev Destroys `tokenId`.
1204      * The approval is cleared when the token is burned.
1205      *
1206      * Requirements:
1207      *
1208      * - `tokenId` must exist.
1209      *
1210      * Emits a {Transfer} event.
1211      */
1212     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1213         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1214 
1215         address from = address(uint160(prevOwnershipPacked));
1216 
1217         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1218 
1219         if (approvalCheck) {
1220             // The nested ifs save around 20+ gas over a compound boolean condition.
1221             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1222                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1223         }
1224 
1225         _beforeTokenTransfers(from, address(0), tokenId, 1);
1226 
1227         // Clear approvals from the previous owner.
1228         assembly {
1229             if approvedAddress {
1230                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1231                 sstore(approvedAddressSlot, 0)
1232             }
1233         }
1234 
1235         // Underflow of the sender's balance is impossible because we check for
1236         // ownership above and the recipient's balance can't realistically overflow.
1237         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1238         unchecked {
1239             // Updates:
1240             // - `balance -= 1`.
1241             // - `numberBurned += 1`.
1242             //
1243             // We can directly decrement the balance, and increment the number burned.
1244             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1245             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1246 
1247             // Updates:
1248             // - `address` to the last owner.
1249             // - `startTimestamp` to the timestamp of burning.
1250             // - `burned` to `true`.
1251             // - `nextInitialized` to `true`.
1252             _packedOwnerships[tokenId] = _packOwnershipData(
1253                 from,
1254                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1255             );
1256 
1257             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1258             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1259                 uint256 nextTokenId = tokenId + 1;
1260                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1261                 if (_packedOwnerships[nextTokenId] == 0) {
1262                     // If the next slot is within bounds.
1263                     if (nextTokenId != _currentIndex) {
1264                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1265                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1266                     }
1267                 }
1268             }
1269         }
1270 
1271         emit Transfer(from, address(0), tokenId);
1272         _afterTokenTransfers(from, address(0), tokenId, 1);
1273 
1274         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1275         unchecked {
1276             _burnCounter++;
1277         }
1278     }
1279 
1280     // =============================================================
1281     //                     EXTRA DATA OPERATIONS
1282     // =============================================================
1283 
1284     /**
1285      * @dev Directly sets the extra data for the ownership data `index`.
1286      */
1287     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1288         uint256 packed = _packedOwnerships[index];
1289         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1290         uint256 extraDataCasted;
1291         // Cast `extraData` with assembly to avoid redundant masking.
1292         assembly {
1293             extraDataCasted := extraData
1294         }
1295         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1296         _packedOwnerships[index] = packed;
1297     }
1298 
1299     /**
1300      * @dev Called during each token transfer to set the 24bit `extraData` field.
1301      * Intended to be overridden by the cosumer contract.
1302      *
1303      * `previousExtraData` - the value of `extraData` before transfer.
1304      *
1305      * Calling conditions:
1306      *
1307      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1308      * transferred to `to`.
1309      * - When `from` is zero, `tokenId` will be minted for `to`.
1310      * - When `to` is zero, `tokenId` will be burned by `from`.
1311      * - `from` and `to` are never both zero.
1312      */
1313     function _extraData(
1314         address from,
1315         address to,
1316         uint24 previousExtraData
1317     ) internal view virtual returns (uint24) {}
1318 
1319     /**
1320      * @dev Returns the next extra data for the packed ownership data.
1321      * The returned result is shifted into position.
1322      */
1323     function _nextExtraData(
1324         address from,
1325         address to,
1326         uint256 prevOwnershipPacked
1327     ) private view returns (uint256) {
1328         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1329         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1330     }
1331 
1332     // =============================================================
1333     //                       OTHER OPERATIONS
1334     // =============================================================
1335 
1336     /**
1337      * @dev Returns the message sender (defaults to `msg.sender`).
1338      *
1339      * If you are writing GSN compatible contracts, you need to override this function.
1340      */
1341     function _msgSenderERC721A() internal view virtual returns (address) {
1342         return msg.sender;
1343     }
1344 
1345     /**
1346      * @dev Converts a uint256 to its ASCII string decimal representation.
1347      */
1348     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1349         assembly {
1350             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1351             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1352             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1353             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1354             let m := add(mload(0x40), 0xa0)
1355             // Update the free memory pointer to allocate.
1356             mstore(0x40, m)
1357             // Assign the `str` to the end.
1358             str := sub(m, 0x20)
1359             // Zeroize the slot after the string.
1360             mstore(str, 0)
1361 
1362             // Cache the end of the memory to calculate the length later.
1363             let end := str
1364 
1365             // We write the string from rightmost digit to leftmost digit.
1366             // The following is essentially a do-while loop that also handles the zero case.
1367             // prettier-ignore
1368             for { let temp := value } 1 {} {
1369                 str := sub(str, 1)
1370                 // Write the character to the pointer.
1371                 // The ASCII index of the '0' character is 48.
1372                 mstore8(str, add(48, mod(temp, 10)))
1373                 // Keep dividing `temp` until zero.
1374                 temp := div(temp, 10)
1375                 // prettier-ignore
1376                 if iszero(temp) { break }
1377             }
1378 
1379             let length := sub(end, str)
1380             // Move the pointer 32 bytes leftwards to make room for the length.
1381             str := sub(str, 0x20)
1382             // Store the length.
1383             mstore(str, length)
1384         }
1385     }
1386 }
1387 
1388 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1389 
1390 
1391 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1392 
1393 pragma solidity ^0.8.0;
1394 
1395 /**
1396  * @dev Contract module that helps prevent reentrant calls to a function.
1397  *
1398  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1399  * available, which can be applied to functions to make sure there are no nested
1400  * (reentrant) calls to them.
1401  *
1402  * Note that because there is a single `nonReentrant` guard, functions marked as
1403  * `nonReentrant` may not call one another. This can be worked around by making
1404  * those functions `private`, and then adding `external` `nonReentrant` entry
1405  * points to them.
1406  *
1407  * TIP: If you would like to learn more about reentrancy and alternative ways
1408  * to protect against it, check out our blog post
1409  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1410  */
1411 abstract contract ReentrancyGuard {
1412     // Booleans are more expensive than uint256 or any type that takes up a full
1413     // word because each write operation emits an extra SLOAD to first read the
1414     // slot's contents, replace the bits taken up by the boolean, and then write
1415     // back. This is the compiler's defense against contract upgrades and
1416     // pointer aliasing, and it cannot be disabled.
1417 
1418     // The values being non-zero value makes deployment a bit more expensive,
1419     // but in exchange the refund on every call to nonReentrant will be lower in
1420     // amount. Since refunds are capped to a percentage of the total
1421     // transaction's gas, it is best to keep them low in cases like this one, to
1422     // increase the likelihood of the full refund coming into effect.
1423     uint256 private constant _NOT_ENTERED = 1;
1424     uint256 private constant _ENTERED = 2;
1425 
1426     uint256 private _status;
1427 
1428     constructor() {
1429         _status = _NOT_ENTERED;
1430     }
1431 
1432     /**
1433      * @dev Prevents a contract from calling itself, directly or indirectly.
1434      * Calling a `nonReentrant` function from another `nonReentrant`
1435      * function is not supported. It is possible to prevent this from happening
1436      * by making the `nonReentrant` function external, and making it call a
1437      * `private` function that does the actual work.
1438      */
1439     modifier nonReentrant() {
1440         _nonReentrantBefore();
1441         _;
1442         _nonReentrantAfter();
1443     }
1444 
1445     function _nonReentrantBefore() private {
1446         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1447         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1448 
1449         // Any calls to nonReentrant after this point will fail
1450         _status = _ENTERED;
1451     }
1452 
1453     function _nonReentrantAfter() private {
1454         // By storing the original value once again, a refund is triggered (see
1455         // https://eips.ethereum.org/EIPS/eip-2200)
1456         _status = _NOT_ENTERED;
1457     }
1458 }
1459 
1460 // File: @openzeppelin/contracts/utils/Context.sol
1461 
1462 
1463 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1464 
1465 pragma solidity ^0.8.0;
1466 
1467 /**
1468  * @dev Provides information about the current execution context, including the
1469  * sender of the transaction and its data. While these are generally available
1470  * via msg.sender and msg.data, they should not be accessed in such a direct
1471  * manner, since when dealing with meta-transactions the account sending and
1472  * paying for execution may not be the actual sender (as far as an application
1473  * is concerned).
1474  *
1475  * This contract is only required for intermediate, library-like contracts.
1476  */
1477 abstract contract Context {
1478     function _msgSender() internal view virtual returns (address) {
1479         return msg.sender;
1480     }
1481 
1482     function _msgData() internal view virtual returns (bytes calldata) {
1483         return msg.data;
1484     }
1485 }
1486 
1487 // File: @openzeppelin/contracts/access/Ownable.sol
1488 
1489 
1490 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1491 
1492 pragma solidity ^0.8.0;
1493 
1494 /**
1495  * @dev Contract module which provides a basic access control mechanism, where
1496  * there is an account (an owner) that can be granted exclusive access to
1497  * specific functions.
1498  *
1499  * By default, the owner account will be the one that deploys the contract. This
1500  * can later be changed with {transferOwnership}.
1501  *
1502  * This module is used through inheritance. It will make available the modifier
1503  * `onlyOwner`, which can be applied to your functions to restrict their use to
1504  * the owner.
1505  */
1506 abstract contract Ownable is Context {
1507     address private _owner;
1508 
1509     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1510 
1511     /**
1512      * @dev Initializes the contract setting the deployer as the initial owner.
1513      */
1514     constructor() {
1515         _transferOwnership(_msgSender());
1516     }
1517 
1518     /**
1519      * @dev Throws if called by any account other than the owner.
1520      */
1521     modifier onlyOwner() {
1522         _checkOwner();
1523         _;
1524     }
1525 
1526     /**
1527      * @dev Returns the address of the current owner.
1528      */
1529     function owner() public view virtual returns (address) {
1530         return _owner;
1531     }
1532 
1533     /**
1534      * @dev Throws if the sender is not the owner.
1535      */
1536     function _checkOwner() internal view virtual {
1537         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1538     }
1539 
1540     /**
1541      * @dev Leaves the contract without owner. It will not be possible to call
1542      * `onlyOwner` functions anymore. Can only be called by the current owner.
1543      *
1544      * NOTE: Renouncing ownership will leave the contract without an owner,
1545      * thereby removing any functionality that is only available to the owner.
1546      */
1547     function renounceOwnership() public virtual onlyOwner {
1548         _transferOwnership(address(0));
1549     }
1550 
1551     /**
1552      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1553      * Can only be called by the current owner.
1554      */
1555     function transferOwnership(address newOwner) public virtual onlyOwner {
1556         require(newOwner != address(0), "Ownable: new owner is the zero address");
1557         _transferOwnership(newOwner);
1558     }
1559 
1560     /**
1561      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1562      * Internal function without access restriction.
1563      */
1564     function _transferOwnership(address newOwner) internal virtual {
1565         address oldOwner = _owner;
1566         _owner = newOwner;
1567         emit OwnershipTransferred(oldOwner, newOwner);
1568     }
1569 }
1570 
1571 ////////////////////////
1572 ///// MILADY AZUKI /////
1573 ////////////////////////
1574 pragma solidity ^0.8.17;
1575 
1576 contract MiladyAzuki is ERC721A, Ownable, ReentrancyGuard {
1577 
1578     ///////////////////
1579     ///// DETAILS /////
1580     ///////////////////
1581     uint256 public maxSupply = 6666;
1582     uint256 public mintCost = 0.004 ether;
1583     uint256 public walletMax = 69;
1584     bool public saleActive = false;
1585 
1586     string public baseURI = "ipfs://QmdKBd1ki7WDHqVxa7Wuw9SfvoPtxrWfpvnsCdXW5Bjp18/";
1587 
1588     mapping(address => bool) freeMint;
1589     mapping(address => uint) addressToMinted;
1590     
1591     function _startTokenId() internal view virtual override returns (uint256) {
1592         return 1;
1593     }
1594 
1595     constructor () ERC721A("Milady Azuki", "MIZUKI") {
1596     }
1597 
1598     ///////////////////
1599     ///// ACTIONS /////
1600     ///////////////////
1601     function publicMint(uint256 mintAmount) public payable nonReentrant {
1602         require(saleActive, "milady");
1603         require(addressToMinted[msg.sender] + mintAmount <= walletMax, "milady");
1604         require(totalSupply() + mintAmount <= maxSupply, "milady");
1605 
1606         if(freeMint[msg.sender]) {
1607             require(msg.value >= mintAmount * mintCost, "milady");
1608         }
1609         else {
1610             require(msg.value >= (mintAmount - 1) * mintCost, "milady");
1611             freeMint[msg.sender] = true;
1612         }
1613         
1614         addressToMinted[msg.sender] += mintAmount;
1615         _safeMint(msg.sender, mintAmount);
1616     }
1617 
1618     function teamReserve(uint256 mintAmount) public onlyOwner {
1619         require(totalSupply() + mintAmount <= maxSupply, "milady");
1620         
1621         _safeMint(msg.sender, mintAmount);
1622     }
1623 
1624     /////////////////
1625     ///// ADMIN /////
1626     /////////////////
1627     function setCost(uint256 newCost) external onlyOwner {
1628         mintCost = newCost;
1629     }
1630 
1631     function setWalletMax(uint256 newMax) external onlyOwner {
1632         walletMax = newMax;
1633     }
1634 
1635     function flipSale() external onlyOwner {
1636         saleActive = !saleActive;
1637     }
1638 
1639     function _baseURI() internal view virtual override returns (string memory) {
1640         return baseURI;
1641     }
1642 
1643     function setBaseURI(string memory baseURI_) external onlyOwner {
1644         baseURI = baseURI_;
1645     }
1646 
1647     function withdraw() public onlyOwner {
1648 		payable(msg.sender).transfer(address(this).balance);
1649 	}
1650     
1651 }