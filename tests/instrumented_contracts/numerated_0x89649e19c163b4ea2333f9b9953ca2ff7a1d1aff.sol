1 // File: erc721a/contracts/IERC721A.sol
2 
3 // SPDX-License-Identifier: MIT
4 // ERC721A Contracts v4.2.3
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
24      * Cannot query the balance for the zero address.
25      */
26     error BalanceQueryForZeroAddress();
27 
28     /**
29      * Cannot mint to the zero address.
30      */
31     error MintToZeroAddress();
32 
33     /**
34      * The quantity of tokens minted must be more than zero.
35      */
36     error MintZeroQuantity();
37 
38     /**
39      * The token does not exist.
40      */
41     error OwnerQueryForNonexistentToken();
42 
43     /**
44      * The caller must own the token or be an approved operator.
45      */
46     error TransferCallerNotOwnerNorApproved();
47 
48     /**
49      * The token must be owned by `from`.
50      */
51     error TransferFromIncorrectOwner();
52 
53     /**
54      * Cannot safely transfer to a contract that does not implement the
55      * ERC721Receiver interface.
56      */
57     error TransferToNonERC721ReceiverImplementer();
58 
59     /**
60      * Cannot transfer to the zero address.
61      */
62     error TransferToZeroAddress();
63 
64     /**
65      * The token does not exist.
66      */
67     error URIQueryForNonexistentToken();
68 
69     /**
70      * The `quantity` minted with ERC2309 exceeds the safety limit.
71      */
72     error MintERC2309QuantityExceedsLimit();
73 
74     /**
75      * The `extraData` cannot be set on an unintialized ownership slot.
76      */
77     error OwnershipNotInitializedForExtraData();
78 
79     // =============================================================
80     //                            STRUCTS
81     // =============================================================
82 
83     struct TokenOwnership {
84         // The address of the owner.
85         address addr;
86         // Stores the start time of ownership with minimal overhead for tokenomics.
87         uint64 startTimestamp;
88         // Whether the token has been burned.
89         bool burned;
90         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
91         uint24 extraData;
92     }
93 
94     // =============================================================
95     //                         TOKEN COUNTERS
96     // =============================================================
97 
98     /**
99      * @dev Returns the total number of tokens in existence.
100      * Burned tokens will reduce the count.
101      * To get the total number of tokens minted, please see {_totalMinted}.
102      */
103     function totalSupply() external view returns (uint256);
104 
105     // =============================================================
106     //                            IERC165
107     // =============================================================
108 
109     /**
110      * @dev Returns true if this contract implements the interface defined by
111      * `interfaceId`. See the corresponding
112      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
113      * to learn more about how these ids are created.
114      *
115      * This function call must use less than 30000 gas.
116      */
117     function supportsInterface(bytes4 interfaceId) external view returns (bool);
118 
119     // =============================================================
120     //                            IERC721
121     // =============================================================
122 
123     /**
124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
130      */
131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables or disables
135      * (`approved`) `operator` to manage all of its assets.
136      */
137     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
138 
139     /**
140      * @dev Returns the number of tokens in `owner`'s account.
141      */
142     function balanceOf(address owner) external view returns (uint256 balance);
143 
144     /**
145      * @dev Returns the owner of the `tokenId` token.
146      *
147      * Requirements:
148      *
149      * - `tokenId` must exist.
150      */
151     function ownerOf(uint256 tokenId) external view returns (address owner);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`,
155      * checking first that contract recipients are aware of the ERC721 protocol
156      * to prevent tokens from being forever locked.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be have been allowed to move
164      * this token by either {approve} or {setApprovalForAll}.
165      * - If `to` refers to a smart contract, it must implement
166      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId,
174         bytes calldata data
175     ) external payable;
176 
177     /**
178      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId
184     ) external payable;
185 
186     /**
187      * @dev Transfers `tokenId` from `from` to `to`.
188      *
189      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
190      * whenever possible.
191      *
192      * Requirements:
193      *
194      * - `from` cannot be the zero address.
195      * - `to` cannot be the zero address.
196      * - `tokenId` token must be owned by `from`.
197      * - If the caller is not `from`, it must be approved to move this token
198      * by either {approve} or {setApprovalForAll}.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(
203         address from,
204         address to,
205         uint256 tokenId
206     ) external payable;
207 
208     /**
209      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
210      * The approval is cleared when the token is transferred.
211      *
212      * Only a single account can be approved at a time, so approving the
213      * zero address clears previous approvals.
214      *
215      * Requirements:
216      *
217      * - The caller must own the token or be an approved operator.
218      * - `tokenId` must exist.
219      *
220      * Emits an {Approval} event.
221      */
222     function approve(address to, uint256 tokenId) external payable;
223 
224     /**
225      * @dev Approve or remove `operator` as an operator for the caller.
226      * Operators can call {transferFrom} or {safeTransferFrom}
227      * for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns the account approved for `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function getApproved(uint256 tokenId) external view returns (address operator);
245 
246     /**
247      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
248      *
249      * See {setApprovalForAll}.
250      */
251     function isApprovedForAll(address owner, address operator) external view returns (bool);
252 
253     // =============================================================
254     //                        IERC721Metadata
255     // =============================================================
256 
257     /**
258      * @dev Returns the token collection name.
259      */
260     function name() external view returns (string memory);
261 
262     /**
263      * @dev Returns the token collection symbol.
264      */
265     function symbol() external view returns (string memory);
266 
267     /**
268      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
269      */
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 
272     // =============================================================
273     //                           IERC2309
274     // =============================================================
275 
276     /**
277      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
278      * (inclusive) is transferred from `from` to `to`, as defined in the
279      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
280      *
281      * See {_mintERC2309} for more details.
282      */
283     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
284 }
285 
286 // File: erc721a/contracts/ERC721A.sol
287 
288 // ERC721A Contracts v4.2.3
289 // Creator: Chiru Labs
290 
291 pragma solidity ^0.8.4;
292 
293 /**
294  * @dev Interface of ERC721 token receiver.
295  */
296 interface ERC721A__IERC721Receiver {
297     function onERC721Received(
298         address operator,
299         address from,
300         uint256 tokenId,
301         bytes calldata data
302     ) external returns (bytes4);
303 }
304 
305 /**
306  * @title ERC721A
307  *
308  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
309  * Non-Fungible Token Standard, including the Metadata extension.
310  * Optimized for lower gas during batch mints.
311  *
312  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
313  * starting from `_startTokenId()`.
314  *
315  * Assumptions:
316  *
317  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
318  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
319  */
320 contract ERC721A is IERC721A {
321     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
322     struct TokenApprovalRef {
323         address value;
324     }
325 
326     // =============================================================
327     //                           CONSTANTS
328     // =============================================================
329 
330     // Mask of an entry in packed address data.
331     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
332 
333     // The bit position of `numberMinted` in packed address data.
334     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
335 
336     // The bit position of `numberBurned` in packed address data.
337     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
338 
339     // The bit position of `aux` in packed address data.
340     uint256 private constant _BITPOS_AUX = 192;
341 
342     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
343     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
344 
345     // The bit position of `startTimestamp` in packed ownership.
346     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
347 
348     // The bit mask of the `burned` bit in packed ownership.
349     uint256 private constant _BITMASK_BURNED = 1 << 224;
350 
351     // The bit position of the `nextInitialized` bit in packed ownership.
352     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
353 
354     // The bit mask of the `nextInitialized` bit in packed ownership.
355     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
356 
357     // The bit position of `extraData` in packed ownership.
358     uint256 private constant _BITPOS_EXTRA_DATA = 232;
359 
360     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
361     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
362 
363     // The mask of the lower 160 bits for addresses.
364     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
365 
366     // The maximum `quantity` that can be minted with {_mintERC2309}.
367     // This limit is to prevent overflows on the address data entries.
368     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
369     // is required to cause an overflow, which is unrealistic.
370     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
371 
372     // The `Transfer` event signature is given by:
373     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
374     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
375         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
376 
377     // =============================================================
378     //                            STORAGE
379     // =============================================================
380 
381     // The next token ID to be minted.
382     uint256 private _currentIndex;
383 
384     // The number of tokens burned.
385     uint256 private _burnCounter;
386 
387     // Token name
388     string private _name;
389 
390     // Token symbol
391     string private _symbol;
392 
393     // Mapping from token ID to ownership details
394     // An empty struct value does not necessarily mean the token is unowned.
395     // See {_packedOwnershipOf} implementation for details.
396     //
397     // Bits Layout:
398     // - [0..159]   `addr`
399     // - [160..223] `startTimestamp`
400     // - [224]      `burned`
401     // - [225]      `nextInitialized`
402     // - [232..255] `extraData`
403     mapping(uint256 => uint256) private _packedOwnerships;
404 
405     // Mapping owner address to address data.
406     //
407     // Bits Layout:
408     // - [0..63]    `balance`
409     // - [64..127]  `numberMinted`
410     // - [128..191] `numberBurned`
411     // - [192..255] `aux`
412     mapping(address => uint256) private _packedAddressData;
413 
414     // Mapping from token ID to approved address.
415     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
416 
417     // Mapping from owner to operator approvals
418     mapping(address => mapping(address => bool)) private _operatorApprovals;
419 
420     // =============================================================
421     //                          CONSTRUCTOR
422     // =============================================================
423 
424     constructor(string memory name_, string memory symbol_) {
425         _name = name_;
426         _symbol = symbol_;
427         _currentIndex = _startTokenId();
428     }
429 
430     // =============================================================
431     //                   TOKEN COUNTING OPERATIONS
432     // =============================================================
433 
434     /**
435      * @dev Returns the starting token ID.
436      * To change the starting token ID, please override this function.
437      */
438     function _startTokenId() internal view virtual returns (uint256) {
439         return 0;
440     }
441 
442     /**
443      * @dev Returns the next token ID to be minted.
444      */
445     function _nextTokenId() internal view virtual returns (uint256) {
446         return _currentIndex;
447     }
448 
449     /**
450      * @dev Returns the total number of tokens in existence.
451      * Burned tokens will reduce the count.
452      * To get the total number of tokens minted, please see {_totalMinted}.
453      */
454     function totalSupply() public view virtual override returns (uint256) {
455         // Counter underflow is impossible as _burnCounter cannot be incremented
456         // more than `_currentIndex - _startTokenId()` times.
457         unchecked {
458             return _currentIndex - _burnCounter - _startTokenId();
459         }
460     }
461 
462     /**
463      * @dev Returns the total amount of tokens minted in the contract.
464      */
465     function _totalMinted() internal view virtual returns (uint256) {
466         // Counter underflow is impossible as `_currentIndex` does not decrement,
467         // and it is initialized to `_startTokenId()`.
468         unchecked {
469             return _currentIndex - _startTokenId();
470         }
471     }
472 
473     /**
474      * @dev Returns the total number of tokens burned.
475      */
476     function _totalBurned() internal view virtual returns (uint256) {
477         return _burnCounter;
478     }
479 
480     // =============================================================
481     //                    ADDRESS DATA OPERATIONS
482     // =============================================================
483 
484     /**
485      * @dev Returns the number of tokens in `owner`'s account.
486      */
487     function balanceOf(address owner) public view virtual override returns (uint256) {
488         if (owner == address(0)) revert BalanceQueryForZeroAddress();
489         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
490     }
491 
492     /**
493      * Returns the number of tokens minted by `owner`.
494      */
495     function _numberMinted(address owner) internal view returns (uint256) {
496         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
497     }
498 
499     /**
500      * Returns the number of tokens burned by or on behalf of `owner`.
501      */
502     function _numberBurned(address owner) internal view returns (uint256) {
503         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
504     }
505 
506     /**
507      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
508      */
509     function _getAux(address owner) internal view returns (uint64) {
510         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
511     }
512 
513     /**
514      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
515      * If there are multiple variables, please pack them into a uint64.
516      */
517     function _setAux(address owner, uint64 aux) internal virtual {
518         uint256 packed = _packedAddressData[owner];
519         uint256 auxCasted;
520         // Cast `aux` with assembly to avoid redundant masking.
521         assembly {
522             auxCasted := aux
523         }
524         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
525         _packedAddressData[owner] = packed;
526     }
527 
528     // =============================================================
529     //                            IERC165
530     // =============================================================
531 
532     /**
533      * @dev Returns true if this contract implements the interface defined by
534      * `interfaceId`. See the corresponding
535      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
536      * to learn more about how these ids are created.
537      *
538      * This function call must use less than 30000 gas.
539      */
540     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541         // The interface IDs are constants representing the first 4 bytes
542         // of the XOR of all function selectors in the interface.
543         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
544         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
545         return
546             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
547             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
548             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
549     }
550 
551     // =============================================================
552     //                        IERC721Metadata
553     // =============================================================
554 
555     /**
556      * @dev Returns the token collection name.
557      */
558     function name() public view virtual override returns (string memory) {
559         return _name;
560     }
561 
562     /**
563      * @dev Returns the token collection symbol.
564      */
565     function symbol() public view virtual override returns (string memory) {
566         return _symbol;
567     }
568 
569     /**
570      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
571      */
572     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
573         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
574 
575         string memory baseURI = _baseURI();
576         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
577     }
578 
579     /**
580      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
581      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
582      * by default, it can be overridden in child contracts.
583      */
584     function _baseURI() internal view virtual returns (string memory) {
585         return '';
586     }
587 
588     // =============================================================
589     //                     OWNERSHIPS OPERATIONS
590     // =============================================================
591 
592     /**
593      * @dev Returns the owner of the `tokenId` token.
594      *
595      * Requirements:
596      *
597      * - `tokenId` must exist.
598      */
599     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
600         return address(uint160(_packedOwnershipOf(tokenId)));
601     }
602 
603     /**
604      * @dev Gas spent here starts off proportional to the maximum mint batch size.
605      * It gradually moves to O(1) as tokens get transferred around over time.
606      */
607     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
608         return _unpackedOwnership(_packedOwnershipOf(tokenId));
609     }
610 
611     /**
612      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
613      */
614     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
615         return _unpackedOwnership(_packedOwnerships[index]);
616     }
617 
618     /**
619      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
620      */
621     function _initializeOwnershipAt(uint256 index) internal virtual {
622         if (_packedOwnerships[index] == 0) {
623             _packedOwnerships[index] = _packedOwnershipOf(index);
624         }
625     }
626 
627     /**
628      * Returns the packed ownership data of `tokenId`.
629      */
630     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
631         uint256 curr = tokenId;
632 
633         unchecked {
634             if (_startTokenId() <= curr)
635                 if (curr < _currentIndex) {
636                     uint256 packed = _packedOwnerships[curr];
637                     // If not burned.
638                     if (packed & _BITMASK_BURNED == 0) {
639                         // Invariant:
640                         // There will always be an initialized ownership slot
641                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
642                         // before an unintialized ownership slot
643                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
644                         // Hence, `curr` will not underflow.
645                         //
646                         // We can directly compare the packed value.
647                         // If the address is zero, packed will be zero.
648                         while (packed == 0) {
649                             packed = _packedOwnerships[--curr];
650                         }
651                         return packed;
652                     }
653                 }
654         }
655         revert OwnerQueryForNonexistentToken();
656     }
657 
658     /**
659      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
660      */
661     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
662         ownership.addr = address(uint160(packed));
663         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
664         ownership.burned = packed & _BITMASK_BURNED != 0;
665         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
666     }
667 
668     /**
669      * @dev Packs ownership data into a single uint256.
670      */
671     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
672         assembly {
673             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
674             owner := and(owner, _BITMASK_ADDRESS)
675             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
676             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
677         }
678     }
679 
680     /**
681      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
682      */
683     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
684         // For branchless setting of the `nextInitialized` flag.
685         assembly {
686             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
687             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
688         }
689     }
690 
691     // =============================================================
692     //                      APPROVAL OPERATIONS
693     // =============================================================
694 
695     /**
696      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
697      * The approval is cleared when the token is transferred.
698      *
699      * Only a single account can be approved at a time, so approving the
700      * zero address clears previous approvals.
701      *
702      * Requirements:
703      *
704      * - The caller must own the token or be an approved operator.
705      * - `tokenId` must exist.
706      *
707      * Emits an {Approval} event.
708      */
709     function approve(address to, uint256 tokenId) public payable virtual override {
710         address owner = ownerOf(tokenId);
711 
712         if (_msgSenderERC721A() != owner)
713             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
714                 revert ApprovalCallerNotOwnerNorApproved();
715             }
716 
717         _tokenApprovals[tokenId].value = to;
718         emit Approval(owner, to, tokenId);
719     }
720 
721     /**
722      * @dev Returns the account approved for `tokenId` token.
723      *
724      * Requirements:
725      *
726      * - `tokenId` must exist.
727      */
728     function getApproved(uint256 tokenId) public view virtual override returns (address) {
729         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
730 
731         return _tokenApprovals[tokenId].value;
732     }
733 
734     /**
735      * @dev Approve or remove `operator` as an operator for the caller.
736      * Operators can call {transferFrom} or {safeTransferFrom}
737      * for any token owned by the caller.
738      *
739      * Requirements:
740      *
741      * - The `operator` cannot be the caller.
742      *
743      * Emits an {ApprovalForAll} event.
744      */
745     function setApprovalForAll(address operator, bool approved) public virtual override {
746         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
747         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
748     }
749 
750     /**
751      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
752      *
753      * See {setApprovalForAll}.
754      */
755     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
756         return _operatorApprovals[owner][operator];
757     }
758 
759     /**
760      * @dev Returns whether `tokenId` exists.
761      *
762      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
763      *
764      * Tokens start existing when they are minted. See {_mint}.
765      */
766     function _exists(uint256 tokenId) internal view virtual returns (bool) {
767         return
768             _startTokenId() <= tokenId &&
769             tokenId < _currentIndex && // If within bounds,
770             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
771     }
772 
773     /**
774      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
775      */
776     function _isSenderApprovedOrOwner(
777         address approvedAddress,
778         address owner,
779         address msgSender
780     ) private pure returns (bool result) {
781         assembly {
782             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
783             owner := and(owner, _BITMASK_ADDRESS)
784             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
785             msgSender := and(msgSender, _BITMASK_ADDRESS)
786             // `msgSender == owner || msgSender == approvedAddress`.
787             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
788         }
789     }
790 
791     /**
792      * @dev Returns the storage slot and value for the approved address of `tokenId`.
793      */
794     function _getApprovedSlotAndAddress(uint256 tokenId)
795         private
796         view
797         returns (uint256 approvedAddressSlot, address approvedAddress)
798     {
799         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
800         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
801         assembly {
802             approvedAddressSlot := tokenApproval.slot
803             approvedAddress := sload(approvedAddressSlot)
804         }
805     }
806 
807     // =============================================================
808     //                      TRANSFER OPERATIONS
809     // =============================================================
810 
811     /**
812      * @dev Transfers `tokenId` from `from` to `to`.
813      *
814      * Requirements:
815      *
816      * - `from` cannot be the zero address.
817      * - `to` cannot be the zero address.
818      * - `tokenId` token must be owned by `from`.
819      * - If the caller is not `from`, it must be approved to move this token
820      * by either {approve} or {setApprovalForAll}.
821      *
822      * Emits a {Transfer} event.
823      */
824     function transferFrom(
825         address from,
826         address to,
827         uint256 tokenId
828     ) public payable virtual override {
829         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
830 
831         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
832 
833         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
834 
835         // The nested ifs save around 20+ gas over a compound boolean condition.
836         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
837             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
838 
839         if (to == address(0)) revert TransferToZeroAddress();
840 
841         _beforeTokenTransfers(from, to, tokenId, 1);
842 
843         // Clear approvals from the previous owner.
844         assembly {
845             if approvedAddress {
846                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
847                 sstore(approvedAddressSlot, 0)
848             }
849         }
850 
851         // Underflow of the sender's balance is impossible because we check for
852         // ownership above and the recipient's balance can't realistically overflow.
853         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
854         unchecked {
855             // We can directly increment and decrement the balances.
856             --_packedAddressData[from]; // Updates: `balance -= 1`.
857             ++_packedAddressData[to]; // Updates: `balance += 1`.
858 
859             // Updates:
860             // - `address` to the next owner.
861             // - `startTimestamp` to the timestamp of transfering.
862             // - `burned` to `false`.
863             // - `nextInitialized` to `true`.
864             _packedOwnerships[tokenId] = _packOwnershipData(
865                 to,
866                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
867             );
868 
869             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
870             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
871                 uint256 nextTokenId = tokenId + 1;
872                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
873                 if (_packedOwnerships[nextTokenId] == 0) {
874                     // If the next slot is within bounds.
875                     if (nextTokenId != _currentIndex) {
876                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
877                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
878                     }
879                 }
880             }
881         }
882 
883         emit Transfer(from, to, tokenId);
884         _afterTokenTransfers(from, to, tokenId, 1);
885     }
886 
887     /**
888      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public payable virtual override {
895         safeTransferFrom(from, to, tokenId, '');
896     }
897 
898     /**
899      * @dev Safely transfers `tokenId` token from `from` to `to`.
900      *
901      * Requirements:
902      *
903      * - `from` cannot be the zero address.
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must exist and be owned by `from`.
906      * - If the caller is not `from`, it must be approved to move this token
907      * by either {approve} or {setApprovalForAll}.
908      * - If `to` refers to a smart contract, it must implement
909      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
910      *
911      * Emits a {Transfer} event.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) public payable virtual override {
919         transferFrom(from, to, tokenId);
920         if (to.code.length != 0)
921             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
922                 revert TransferToNonERC721ReceiverImplementer();
923             }
924     }
925 
926     /**
927      * @dev Hook that is called before a set of serially-ordered token IDs
928      * are about to be transferred. This includes minting.
929      * And also called before burning one token.
930      *
931      * `startTokenId` - the first token ID to be transferred.
932      * `quantity` - the amount to be transferred.
933      *
934      * Calling conditions:
935      *
936      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
937      * transferred to `to`.
938      * - When `from` is zero, `tokenId` will be minted for `to`.
939      * - When `to` is zero, `tokenId` will be burned by `from`.
940      * - `from` and `to` are never both zero.
941      */
942     function _beforeTokenTransfers(
943         address from,
944         address to,
945         uint256 startTokenId,
946         uint256 quantity
947     ) internal virtual {}
948 
949     /**
950      * @dev Hook that is called after a set of serially-ordered token IDs
951      * have been transferred. This includes minting.
952      * And also called after one token has been burned.
953      *
954      * `startTokenId` - the first token ID to be transferred.
955      * `quantity` - the amount to be transferred.
956      *
957      * Calling conditions:
958      *
959      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
960      * transferred to `to`.
961      * - When `from` is zero, `tokenId` has been minted for `to`.
962      * - When `to` is zero, `tokenId` has been burned by `from`.
963      * - `from` and `to` are never both zero.
964      */
965     function _afterTokenTransfers(
966         address from,
967         address to,
968         uint256 startTokenId,
969         uint256 quantity
970     ) internal virtual {}
971 
972     /**
973      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
974      *
975      * `from` - Previous owner of the given token ID.
976      * `to` - Target address that will receive the token.
977      * `tokenId` - Token ID to be transferred.
978      * `_data` - Optional data to send along with the call.
979      *
980      * Returns whether the call correctly returned the expected magic value.
981      */
982     function _checkContractOnERC721Received(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory _data
987     ) private returns (bool) {
988         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
989             bytes4 retval
990         ) {
991             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
992         } catch (bytes memory reason) {
993             if (reason.length == 0) {
994                 revert TransferToNonERC721ReceiverImplementer();
995             } else {
996                 assembly {
997                     revert(add(32, reason), mload(reason))
998                 }
999             }
1000         }
1001     }
1002 
1003     // =============================================================
1004     //                        MINT OPERATIONS
1005     // =============================================================
1006 
1007     /**
1008      * @dev Mints `quantity` tokens and transfers them to `to`.
1009      *
1010      * Requirements:
1011      *
1012      * - `to` cannot be the zero address.
1013      * - `quantity` must be greater than 0.
1014      *
1015      * Emits a {Transfer} event for each mint.
1016      */
1017     function _mint(address to, uint256 quantity) internal virtual {
1018         uint256 startTokenId = _currentIndex;
1019         if (quantity == 0) revert MintZeroQuantity();
1020 
1021         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1022 
1023         // Overflows are incredibly unrealistic.
1024         // `balance` and `numberMinted` have a maximum limit of 2**64.
1025         // `tokenId` has a maximum limit of 2**256.
1026         unchecked {
1027             // Updates:
1028             // - `balance += quantity`.
1029             // - `numberMinted += quantity`.
1030             //
1031             // We can directly add to the `balance` and `numberMinted`.
1032             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1033 
1034             // Updates:
1035             // - `address` to the owner.
1036             // - `startTimestamp` to the timestamp of minting.
1037             // - `burned` to `false`.
1038             // - `nextInitialized` to `quantity == 1`.
1039             _packedOwnerships[startTokenId] = _packOwnershipData(
1040                 to,
1041                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1042             );
1043 
1044             uint256 toMasked;
1045             uint256 end = startTokenId + quantity;
1046 
1047             // Use assembly to loop and emit the `Transfer` event for gas savings.
1048             // The duplicated `log4` removes an extra check and reduces stack juggling.
1049             // The assembly, together with the surrounding Solidity code, have been
1050             // delicately arranged to nudge the compiler into producing optimized opcodes.
1051             assembly {
1052                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1053                 toMasked := and(to, _BITMASK_ADDRESS)
1054                 // Emit the `Transfer` event.
1055                 log4(
1056                     0, // Start of data (0, since no data).
1057                     0, // End of data (0, since no data).
1058                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1059                     0, // `address(0)`.
1060                     toMasked, // `to`.
1061                     startTokenId // `tokenId`.
1062                 )
1063 
1064                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1065                 // that overflows uint256 will make the loop run out of gas.
1066                 // The compiler will optimize the `iszero` away for performance.
1067                 for {
1068                     let tokenId := add(startTokenId, 1)
1069                 } iszero(eq(tokenId, end)) {
1070                     tokenId := add(tokenId, 1)
1071                 } {
1072                     // Emit the `Transfer` event. Similar to above.
1073                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1074                 }
1075             }
1076             if (toMasked == 0) revert MintToZeroAddress();
1077 
1078             _currentIndex = end;
1079         }
1080         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1081     }
1082 
1083     /**
1084      * @dev Mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * This function is intended for efficient minting only during contract creation.
1087      *
1088      * It emits only one {ConsecutiveTransfer} as defined in
1089      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1090      * instead of a sequence of {Transfer} event(s).
1091      *
1092      * Calling this function outside of contract creation WILL make your contract
1093      * non-compliant with the ERC721 standard.
1094      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1095      * {ConsecutiveTransfer} event is only permissible during contract creation.
1096      *
1097      * Requirements:
1098      *
1099      * - `to` cannot be the zero address.
1100      * - `quantity` must be greater than 0.
1101      *
1102      * Emits a {ConsecutiveTransfer} event.
1103      */
1104     function _mintERC2309(address to, uint256 quantity) internal virtual {
1105         uint256 startTokenId = _currentIndex;
1106         if (to == address(0)) revert MintToZeroAddress();
1107         if (quantity == 0) revert MintZeroQuantity();
1108         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1109 
1110         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1111 
1112         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1113         unchecked {
1114             // Updates:
1115             // - `balance += quantity`.
1116             // - `numberMinted += quantity`.
1117             //
1118             // We can directly add to the `balance` and `numberMinted`.
1119             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1120 
1121             // Updates:
1122             // - `address` to the owner.
1123             // - `startTimestamp` to the timestamp of minting.
1124             // - `burned` to `false`.
1125             // - `nextInitialized` to `quantity == 1`.
1126             _packedOwnerships[startTokenId] = _packOwnershipData(
1127                 to,
1128                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1129             );
1130 
1131             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1132 
1133             _currentIndex = startTokenId + quantity;
1134         }
1135         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1136     }
1137 
1138     /**
1139      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1140      *
1141      * Requirements:
1142      *
1143      * - If `to` refers to a smart contract, it must implement
1144      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1145      * - `quantity` must be greater than 0.
1146      *
1147      * See {_mint}.
1148      *
1149      * Emits a {Transfer} event for each mint.
1150      */
1151     function _safeMint(
1152         address to,
1153         uint256 quantity,
1154         bytes memory _data
1155     ) internal virtual {
1156         _mint(to, quantity);
1157 
1158         unchecked {
1159             if (to.code.length != 0) {
1160                 uint256 end = _currentIndex;
1161                 uint256 index = end - quantity;
1162                 do {
1163                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1164                         revert TransferToNonERC721ReceiverImplementer();
1165                     }
1166                 } while (index < end);
1167                 // Reentrancy protection.
1168                 if (_currentIndex != end) revert();
1169             }
1170         }
1171     }
1172 
1173     /**
1174      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1175      */
1176     function _safeMint(address to, uint256 quantity) internal virtual {
1177         _safeMint(to, quantity, '');
1178     }
1179 
1180     // =============================================================
1181     //                        BURN OPERATIONS
1182     // =============================================================
1183 
1184     /**
1185      * @dev Equivalent to `_burn(tokenId, false)`.
1186      */
1187     function _burn(uint256 tokenId) internal virtual {
1188         _burn(tokenId, false);
1189     }
1190 
1191     /**
1192      * @dev Destroys `tokenId`.
1193      * The approval is cleared when the token is burned.
1194      *
1195      * Requirements:
1196      *
1197      * - `tokenId` must exist.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1202         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1203 
1204         address from = address(uint160(prevOwnershipPacked));
1205 
1206         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1207 
1208         if (approvalCheck) {
1209             // The nested ifs save around 20+ gas over a compound boolean condition.
1210             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1211                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1212         }
1213 
1214         _beforeTokenTransfers(from, address(0), tokenId, 1);
1215 
1216         // Clear approvals from the previous owner.
1217         assembly {
1218             if approvedAddress {
1219                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1220                 sstore(approvedAddressSlot, 0)
1221             }
1222         }
1223 
1224         // Underflow of the sender's balance is impossible because we check for
1225         // ownership above and the recipient's balance can't realistically overflow.
1226         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1227         unchecked {
1228             // Updates:
1229             // - `balance -= 1`.
1230             // - `numberBurned += 1`.
1231             //
1232             // We can directly decrement the balance, and increment the number burned.
1233             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1234             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1235 
1236             // Updates:
1237             // - `address` to the last owner.
1238             // - `startTimestamp` to the timestamp of burning.
1239             // - `burned` to `true`.
1240             // - `nextInitialized` to `true`.
1241             _packedOwnerships[tokenId] = _packOwnershipData(
1242                 from,
1243                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1244             );
1245 
1246             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1247             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1248                 uint256 nextTokenId = tokenId + 1;
1249                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1250                 if (_packedOwnerships[nextTokenId] == 0) {
1251                     // If the next slot is within bounds.
1252                     if (nextTokenId != _currentIndex) {
1253                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1254                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1255                     }
1256                 }
1257             }
1258         }
1259 
1260         emit Transfer(from, address(0), tokenId);
1261         _afterTokenTransfers(from, address(0), tokenId, 1);
1262 
1263         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1264         unchecked {
1265             _burnCounter++;
1266         }
1267     }
1268 
1269     // =============================================================
1270     //                     EXTRA DATA OPERATIONS
1271     // =============================================================
1272 
1273     /**
1274      * @dev Directly sets the extra data for the ownership data `index`.
1275      */
1276     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1277         uint256 packed = _packedOwnerships[index];
1278         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1279         uint256 extraDataCasted;
1280         // Cast `extraData` with assembly to avoid redundant masking.
1281         assembly {
1282             extraDataCasted := extraData
1283         }
1284         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1285         _packedOwnerships[index] = packed;
1286     }
1287 
1288     /**
1289      * @dev Called during each token transfer to set the 24bit `extraData` field.
1290      * Intended to be overridden by the cosumer contract.
1291      *
1292      * `previousExtraData` - the value of `extraData` before transfer.
1293      *
1294      * Calling conditions:
1295      *
1296      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1297      * transferred to `to`.
1298      * - When `from` is zero, `tokenId` will be minted for `to`.
1299      * - When `to` is zero, `tokenId` will be burned by `from`.
1300      * - `from` and `to` are never both zero.
1301      */
1302     function _extraData(
1303         address from,
1304         address to,
1305         uint24 previousExtraData
1306     ) internal view virtual returns (uint24) {}
1307 
1308     /**
1309      * @dev Returns the next extra data for the packed ownership data.
1310      * The returned result is shifted into position.
1311      */
1312     function _nextExtraData(
1313         address from,
1314         address to,
1315         uint256 prevOwnershipPacked
1316     ) private view returns (uint256) {
1317         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1318         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1319     }
1320 
1321     // =============================================================
1322     //                       OTHER OPERATIONS
1323     // =============================================================
1324 
1325     /**
1326      * @dev Returns the message sender (defaults to `msg.sender`).
1327      *
1328      * If you are writing GSN compatible contracts, you need to override this function.
1329      */
1330     function _msgSenderERC721A() internal view virtual returns (address) {
1331         return msg.sender;
1332     }
1333 
1334     /**
1335      * @dev Converts a uint256 to its ASCII string decimal representation.
1336      */
1337     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1338         assembly {
1339             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1340             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1341             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1342             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1343             let m := add(mload(0x40), 0xa0)
1344             // Update the free memory pointer to allocate.
1345             mstore(0x40, m)
1346             // Assign the `str` to the end.
1347             str := sub(m, 0x20)
1348             // Zeroize the slot after the string.
1349             mstore(str, 0)
1350 
1351             // Cache the end of the memory to calculate the length later.
1352             let end := str
1353 
1354             // We write the string from rightmost digit to leftmost digit.
1355             // The following is essentially a do-while loop that also handles the zero case.
1356             // prettier-ignore
1357             for { let temp := value } 1 {} {
1358                 str := sub(str, 1)
1359                 // Write the character to the pointer.
1360                 // The ASCII index of the '0' character is 48.
1361                 mstore8(str, add(48, mod(temp, 10)))
1362                 // Keep dividing `temp` until zero.
1363                 temp := div(temp, 10)
1364                 // prettier-ignore
1365                 if iszero(temp) { break }
1366             }
1367 
1368             let length := sub(end, str)
1369             // Move the pointer 32 bytes leftwards to make room for the length.
1370             str := sub(str, 0x20)
1371             // Store the length.
1372             mstore(str, length)
1373         }
1374     }
1375 }
1376 
1377 // File: openzeppelin-solidity/contracts/utils/Context.sol
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
1403 // File: openzeppelin-solidity/contracts/access/Ownable.sol
1404 
1405 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1406 
1407 pragma solidity ^0.8.0;
1408 
1409 /**
1410  * @dev Contract module which provides a basic access control mechanism, where
1411  * there is an account (an owner) that can be granted exclusive access to
1412  * specific functions.
1413  *
1414  * By default, the owner account will be the one that deploys the contract. This
1415  * can later be changed with {transferOwnership}.
1416  *
1417  * This module is used through inheritance. It will make available the modifier
1418  * `onlyOwner`, which can be applied to your functions to restrict their use to
1419  * the owner.
1420  */
1421 abstract contract Ownable is Context {
1422     address private _owner;
1423 
1424     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1425 
1426     /**
1427      * @dev Initializes the contract setting the deployer as the initial owner.
1428      */
1429     constructor() {
1430         _transferOwnership(_msgSender());
1431     }
1432 
1433     /**
1434      * @dev Returns the address of the current owner.
1435      */
1436     function owner() public view virtual returns (address) {
1437         return _owner;
1438     }
1439 
1440     /**
1441      * @dev Throws if called by any account other than the owner.
1442      */
1443     modifier onlyOwner() {
1444         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1445         _;
1446     }
1447 
1448     /**
1449      * @dev Leaves the contract without owner. It will not be possible to call
1450      * `onlyOwner` functions anymore. Can only be called by the current owner.
1451      *
1452      * NOTE: Renouncing ownership will leave the contract without an owner,
1453      * thereby removing any functionality that is only available to the owner.
1454      */
1455     function renounceOwnership() public virtual onlyOwner {
1456         _transferOwnership(address(0));
1457     }
1458 
1459     /**
1460      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1461      * Can only be called by the current owner.
1462      */
1463     function transferOwnership(address newOwner) public virtual onlyOwner {
1464         require(newOwner != address(0), "Ownable: new owner is the zero address");
1465         _transferOwnership(newOwner);
1466     }
1467 
1468     /**
1469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1470      * Internal function without access restriction.
1471      */
1472     function _transferOwnership(address newOwner) internal virtual {
1473         address oldOwner = _owner;
1474         _owner = newOwner;
1475         emit OwnershipTransferred(oldOwner, newOwner);
1476     }
1477 }
1478 
1479 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
1480 
1481 pragma solidity ^0.8.13;
1482 
1483 interface IOperatorFilterRegistry {
1484     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1485     function register(address registrant) external;
1486     function registerAndSubscribe(address registrant, address subscription) external;
1487     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1488     function unregister(address addr) external;
1489     function updateOperator(address registrant, address operator, bool filtered) external;
1490     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1491     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1492     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1493     function subscribe(address registrant, address registrantToSubscribe) external;
1494     function unsubscribe(address registrant, bool copyExistingEntries) external;
1495     function subscriptionOf(address addr) external returns (address registrant);
1496     function subscribers(address registrant) external returns (address[] memory);
1497     function subscriberAt(address registrant, uint256 index) external returns (address);
1498     function copyEntriesOf(address registrant, address registrantToCopy) external;
1499     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1500     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1501     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1502     function filteredOperators(address addr) external returns (address[] memory);
1503     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1504     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1505     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1506     function isRegistered(address addr) external returns (bool);
1507     function codeHashOf(address addr) external returns (bytes32);
1508 }
1509 
1510 // File: operator-filter-registry/src/UpdatableOperatorFilterer.sol
1511 
1512 pragma solidity ^0.8.13;
1513 
1514 /**
1515  * @title  UpdatableOperatorFilterer
1516  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1517  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
1518  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
1519  *         which will bypass registry checks.
1520  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
1521  *         on-chain, eg, if the registry is revoked or bypassed.
1522  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1523  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1524  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1525  */
1526 abstract contract UpdatableOperatorFilterer {
1527     error OperatorNotAllowed(address operator);
1528     error OnlyOwner();
1529 
1530     IOperatorFilterRegistry public operatorFilterRegistry;
1531 
1532     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
1533         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
1534         operatorFilterRegistry = registry;
1535         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1536         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1537         // order for the modifier to filter addresses.
1538         if (address(registry).code.length > 0) {
1539             if (subscribe) {
1540                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1541             } else {
1542                 if (subscriptionOrRegistrantToCopy != address(0)) {
1543                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1544                 } else {
1545                     registry.register(address(this));
1546                 }
1547             }
1548         }
1549     }
1550 
1551     modifier onlyAllowedOperator(address from) virtual {
1552         // Allow spending tokens from addresses with balance
1553         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1554         // from an EOA.
1555         if (from != msg.sender) {
1556             _checkFilterOperator(msg.sender);
1557         }
1558         _;
1559     }
1560 
1561     modifier onlyAllowedOperatorApproval(address operator) virtual {
1562         _checkFilterOperator(operator);
1563         _;
1564     }
1565 
1566     /**
1567      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
1568      *         address, checks will be bypassed. OnlyOwner.
1569      */
1570     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
1571         if (msg.sender != owner()) {
1572             revert OnlyOwner();
1573         }
1574         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
1575     }
1576 
1577     /**
1578      * @dev assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract
1579      */
1580     function owner() public view virtual returns (address);
1581 
1582     function _checkFilterOperator(address operator) internal view virtual {
1583         IOperatorFilterRegistry registry = operatorFilterRegistry;
1584         // Check registry code length to facilitate testing in environments without a deployed registry.
1585         if (address(registry) != address(0) && address(registry).code.length > 0) {
1586             if (!registry.isOperatorAllowed(address(this), operator)) {
1587                 revert OperatorNotAllowed(operator);
1588             }
1589         }
1590     }
1591 }
1592 
1593 // File: operator-filter-registry/src/RevokableOperatorFilterer.sol
1594 
1595 pragma solidity ^0.8.13;
1596 
1597 
1598 /**
1599  * @title  RevokableOperatorFilterer
1600  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
1601  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
1602  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
1603  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
1604  *         address cannot be further updated.
1605  *         Note that OpenSea will still disable creator fee enforcement if filtered operators begin fulfilling orders
1606  *         on-chain, eg, if the registry is revoked or bypassed.
1607  */
1608 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
1609     error RegistryHasBeenRevoked();
1610     error InitialRegistryAddressCannotBeZeroAddress();
1611 
1612     bool public isOperatorFilterRegistryRevoked;
1613 
1614     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
1615         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
1616     {
1617         // don't allow creating a contract with a permanently revoked registry
1618         if (_registry == address(0)) {
1619             revert InitialRegistryAddressCannotBeZeroAddress();
1620         }
1621     }
1622 
1623     function _checkFilterOperator(address operator) internal view virtual override {
1624         if (address(operatorFilterRegistry) != address(0)) {
1625             super._checkFilterOperator(operator);
1626         }
1627     }
1628 
1629     /**
1630      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
1631      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
1632      */
1633     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
1634         if (msg.sender != owner()) {
1635             revert OnlyOwner();
1636         }
1637         // if registry has been revoked, do not allow further updates
1638         if (isOperatorFilterRegistryRevoked) {
1639             revert RegistryHasBeenRevoked();
1640         }
1641 
1642         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
1643     }
1644 
1645     /**
1646      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
1647      */
1648     function revokeOperatorFilterRegistry() public {
1649         if (msg.sender != owner()) {
1650             revert OnlyOwner();
1651         }
1652         // if registry has been revoked, do not allow further updates
1653         if (isOperatorFilterRegistryRevoked) {
1654             revert RegistryHasBeenRevoked();
1655         }
1656 
1657         // set to zero address to bypass checks
1658         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
1659         isOperatorFilterRegistryRevoked = true;
1660     }
1661 }
1662 
1663 // File: operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol
1664 
1665 pragma solidity ^0.8.13;
1666 
1667 /**
1668  * @title  RevokableDefaultOperatorFilterer
1669  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
1670  *         Note that OpenSea will disable creator fee enforcement if filtered operators begin fulfilling orders
1671  *         on-chain, eg, if the registry is revoked or bypassed.
1672  */
1673 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
1674     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1675 
1676     constructor() RevokableOperatorFilterer(0x000000000000AAeB6D7670E522A718067333cd4E, DEFAULT_SUBSCRIPTION, true) {}
1677 }
1678 
1679 // File: contracts/Mintable.sol
1680 
1681 pragma solidity ^0.8.17;
1682 
1683 contract Mintable {
1684     mapping(address => bool) public minters;
1685 
1686     modifier onlyMinter() {
1687         require(isMinter(msg.sender), "NOT_MINTER!");
1688         _;
1689     }
1690 
1691     function isMinter(address account) public view virtual returns (bool) {
1692         return minters[account];
1693     }
1694 
1695     function _addMinter(address account) internal  {
1696         require(!isMinter(account), "Mintable: ALREADY_MINTER");
1697         minters[account] = true;
1698     }
1699 
1700     function _removeMinter(address account) internal {
1701         require(isMinter(account), "Mintable: NOT_MINTER");
1702         minters[account] = false;
1703     }
1704 }
1705 
1706 // File: contracts/TANPa.sol
1707 
1708 pragma solidity ^0.8.17;
1709 
1710 
1711 
1712 
1713 contract TANPa is ERC721A("TANP: ART IS THE ULTIMATE UTILITY", "TANP"), RevokableDefaultOperatorFilterer, Ownable, Mintable{
1714     string public baseURI;
1715 
1716     constructor(string memory baseURI_) {
1717         setBaseURI(baseURI_);
1718     }
1719 
1720     function mint(address to, uint256 quantity) external onlyMinter {
1721         // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
1722         _mint(to, quantity);
1723     }
1724 
1725     function burn(uint256 tokenId) public {
1726         _burn(tokenId, true);
1727     }
1728 
1729     function addMinter(address account) public onlyOwner {
1730         _addMinter(account);
1731     }
1732 
1733     function removeMinter(address account) public onlyOwner {
1734         _removeMinter(account);
1735     }
1736 
1737     function setBaseURI(string memory baseURI_) public onlyOwner {
1738         baseURI = baseURI_;
1739     }
1740 
1741     function _baseURI() internal view override returns (string memory) {
1742         return baseURI;
1743     }
1744 
1745     //For OpenSea Royalty Fee Policy
1746     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1747         super.setApprovalForAll(operator, approved);
1748     }
1749 
1750     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1751         super.approve(operator, tokenId);
1752     }
1753 
1754     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1755         super.transferFrom(from, to, tokenId);
1756     }
1757 
1758     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1759         super.safeTransferFrom(from, to, tokenId);
1760     }
1761 
1762     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1763         public
1764         payable
1765         override
1766         onlyAllowedOperator(from)
1767     {
1768         super.safeTransferFrom(from, to, tokenId, data);
1769     }
1770 
1771     function owner() public view virtual override (Ownable, UpdatableOperatorFilterer) returns (address) {
1772         return Ownable.owner();
1773     }
1774 }