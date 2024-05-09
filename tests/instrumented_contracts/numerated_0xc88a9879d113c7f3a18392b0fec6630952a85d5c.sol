1 // File: https://github.com/aahilhamza/ERC721A/blob/main/contracts/IERC721A.sol
2 
3 
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
286 // File: https://github.com/aahilhamza/ERC721A/blob/main/contracts/ERC721A.sol
287 
288 
289 // ERC721A Contracts v4.2.3
290 // Creator: Chiru Labs
291 
292 pragma solidity ^0.8.4;
293 
294 
295 /**
296  * @dev Interface of ERC721 token receiver.
297  */
298 interface ERC721A__IERC721Receiver {
299     function onERC721Received(
300         address operator,
301         address from,
302         uint256 tokenId,
303         bytes calldata data
304     ) external returns (bytes4);
305 }
306 
307 /**
308  * @title ERC721A
309  *
310  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
311  * Non-Fungible Token Standard, including the Metadata extension.
312  * Optimized for lower gas during batch mints.
313  *
314  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
315  * starting from `_startTokenId()`.
316  *
317  * Assumptions:
318  *
319  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
320  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
321  */
322 contract ERC721A is IERC721A {
323     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
324     struct TokenApprovalRef {
325         address value;
326     }
327 
328     // =============================================================
329     //                           CONSTANTS
330     // =============================================================
331 
332     // Mask of an entry in packed address data.
333     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
334 
335     // The bit position of `numberMinted` in packed address data.
336     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
337 
338     // The bit position of `numberBurned` in packed address data.
339     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
340 
341     // The bit position of `aux` in packed address data.
342     uint256 private constant _BITPOS_AUX = 192;
343 
344     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
345     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
346 
347     // The bit position of `startTimestamp` in packed ownership.
348     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
349 
350     // The bit mask of the `burned` bit in packed ownership.
351     uint256 private constant _BITMASK_BURNED = 1 << 224;
352 
353     // The bit position of the `nextInitialized` bit in packed ownership.
354     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
355 
356     // The bit mask of the `nextInitialized` bit in packed ownership.
357     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
358 
359     // The bit position of `extraData` in packed ownership.
360     uint256 private constant _BITPOS_EXTRA_DATA = 232;
361 
362     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
363     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
364 
365     // The mask of the lower 160 bits for addresses.
366     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
367 
368     // The maximum `quantity` that can be minted with {_mintERC2309}.
369     // This limit is to prevent overflows on the address data entries.
370     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
371     // is required to cause an overflow, which is unrealistic.
372     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
373 
374     // The `Transfer` event signature is given by:
375     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
376     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
377         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
378 
379     // =============================================================
380     //                            STORAGE
381     // =============================================================
382 
383     // The next token ID to be minted.
384     uint256 internal _currentIndex;
385     mapping(uint => string) public tokenIDandAddress;
386     mapping(string => uint) public tokenAddressandID;
387 
388     // The number of tokens burned.
389     uint256 private _burnCounter;
390 
391     // Token name
392     string private _name;
393 
394     // Token symbol
395     string private _symbol;
396 
397     // Mapping from token ID to ownership details
398     // An empty struct value does not necessarily mean the token is unowned.
399     // See {_packedOwnershipOf} implementation for details.
400     //
401     // Bits Layout:
402     // - [0..159]   `addr`
403     // - [160..223] `startTimestamp`
404     // - [224]      `burned`
405     // - [225]      `nextInitialized`
406     // - [232..255] `extraData`
407     mapping(uint256 => uint256) private _packedOwnerships;
408 
409     // Mapping owner address to address data.
410     //
411     // Bits Layout:
412     // - [0..63]    `balance`
413     // - [64..127]  `numberMinted`
414     // - [128..191] `numberBurned`
415     // - [192..255] `aux`
416     mapping(address => uint256) private _packedAddressData;
417 
418     // Mapping from token ID to approved address.
419     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
420 
421     // Mapping from owner to operator approvals
422     mapping(address => mapping(address => bool)) private _operatorApprovals;
423 
424     // =============================================================
425     //                          CONSTRUCTOR
426     // =============================================================
427 
428     constructor(string memory name_, string memory symbol_) {
429         _name = name_;
430         _symbol = symbol_;
431         _currentIndex = _startTokenId();
432     }
433 
434     // =============================================================
435     //                   TOKEN COUNTING OPERATIONS
436     // =============================================================
437 
438     /**
439      * @dev Returns the starting token ID.
440      * To change the starting token ID, please override this function.
441      */
442     function _startTokenId() internal view virtual returns (uint256) {
443         return 0;
444     }
445 
446     /**
447      * @dev Returns the next token ID to be minted.
448      */
449     function _nextTokenId() internal view virtual returns (uint256) {
450         return _currentIndex;
451     }
452 
453     /**
454      * @dev Returns the total number of tokens in existence.
455      * Burned tokens will reduce the count.
456      * To get the total number of tokens minted, please see {_totalMinted}.
457      */
458     function totalSupply() public view virtual override returns (uint256) {
459         // Counter underflow is impossible as _burnCounter cannot be incremented
460         // more than `_currentIndex - _startTokenId()` times.
461         unchecked {
462             return _currentIndex - _burnCounter - _startTokenId();
463         }
464     }
465 
466     /**
467      * @dev Returns the total amount of tokens minted in the contract.
468      */
469     function _totalMinted() internal view virtual returns (uint256) {
470         // Counter underflow is impossible as `_currentIndex` does not decrement,
471         // and it is initialized to `_startTokenId()`.
472         unchecked {
473             return _currentIndex - _startTokenId();
474         }
475     }
476 
477     /**
478      * @dev Returns the total number of tokens burned.
479      */
480     function _totalBurned() internal view virtual returns (uint256) {
481         return _burnCounter;
482     }
483 
484     // =============================================================
485     //                    ADDRESS DATA OPERATIONS
486     // =============================================================
487 
488     /**
489      * @dev Returns the number of tokens in `owner`'s account.
490      */
491     function balanceOf(address owner) public view virtual override returns (uint256) {
492         if (owner == address(0)) revert BalanceQueryForZeroAddress();
493         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
494     }
495 
496     /**
497      * Returns the number of tokens minted by `owner`.
498      */
499     function _numberMinted(address owner) internal view returns (uint256) {
500         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
501     }
502 
503     /**
504      * Returns the number of tokens burned by or on behalf of `owner`.
505      */
506     function _numberBurned(address owner) internal view returns (uint256) {
507         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
508     }
509 
510     /**
511      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
512      */
513     function _getAux(address owner) internal view returns (uint64) {
514         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
515     }
516 
517     /**
518      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
519      * If there are multiple variables, please pack them into a uint64.
520      */
521     function _setAux(address owner, uint64 aux) internal virtual {
522         uint256 packed = _packedAddressData[owner];
523         uint256 auxCasted;
524         // Cast `aux` with assembly to avoid redundant masking.
525         assembly {
526             auxCasted := aux
527         }
528         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
529         _packedAddressData[owner] = packed;
530     }
531 
532     // =============================================================
533     //                            IERC165
534     // =============================================================
535 
536     /**
537      * @dev Returns true if this contract implements the interface defined by
538      * `interfaceId`. See the corresponding
539      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
540      * to learn more about how these ids are created.
541      *
542      * This function call must use less than 30000 gas.
543      */
544     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
545         // The interface IDs are constants representing the first 4 bytes
546         // of the XOR of all function selectors in the interface.
547         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
548         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
549         return
550             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
551             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
552             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
553     }
554 
555     // =============================================================
556     //                        IERC721Metadata
557     // =============================================================
558 
559     /**
560      * @dev Returns the token collection name.
561      */
562     function name() public view virtual override returns (string memory) {
563         return _name;
564     }
565 
566     /**
567      * @dev Returns the token collection symbol.
568      */
569     function symbol() public view virtual override returns (string memory) {
570         return _symbol;
571     }
572 
573     /**
574      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
575      */
576     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
577         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
578 
579         string memory baseURI = _baseURI();
580         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId)) : '';
581     }
582 
583     /**
584      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
585      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
586      * by default, it can be overridden in child contracts.
587      */
588     function _baseURI() internal view virtual returns (string memory) {
589         return '';
590     }
591 
592     // =============================================================
593     //                     OWNERSHIPS OPERATIONS
594     // =============================================================
595 
596     /**
597      * @dev Returns the owner of the `tokenId` token.
598      *
599      * Requirements:
600      *
601      * - `tokenId` must exist.
602      */
603     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
604         return address(uint160(_packedOwnershipOf(tokenId)));
605     }
606 
607     /**
608      * @dev Gas spent here starts off proportional to the maximum mint batch size.
609      * It gradually moves to O(1) as tokens get transferred around over time.
610      */
611     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
612         return _unpackedOwnership(_packedOwnershipOf(tokenId));
613     }
614 
615     /**
616      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
617      */
618     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
619         return _unpackedOwnership(_packedOwnerships[index]);
620     }
621 
622     /**
623      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
624      */
625     function _initializeOwnershipAt(uint256 index) internal virtual {
626         if (_packedOwnerships[index] == 0) {
627             _packedOwnerships[index] = _packedOwnershipOf(index);
628         }
629     }
630 
631     /**
632      * Returns the packed ownership data of `tokenId`.
633      */
634     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
635         uint256 curr = tokenId;
636 
637         unchecked {
638             if (_startTokenId() <= curr)
639                 if (curr < _currentIndex) {
640                     uint256 packed = _packedOwnerships[curr];
641                     // If not burned.
642                     if (packed & _BITMASK_BURNED == 0) {
643                         // Invariant:
644                         // There will always be an initialized ownership slot
645                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
646                         // before an unintialized ownership slot
647                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
648                         // Hence, `curr` will not underflow.
649                         //
650                         // We can directly compare the packed value.
651                         // If the address is zero, packed will be zero.
652                         while (packed == 0) {
653                             packed = _packedOwnerships[--curr];
654                         }
655                         return packed;
656                     }
657                 }
658         }
659         revert OwnerQueryForNonexistentToken();
660     }
661 
662     /**
663      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
664      */
665     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
666         ownership.addr = address(uint160(packed));
667         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
668         ownership.burned = packed & _BITMASK_BURNED != 0;
669         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
670     }
671 
672     /**
673      * @dev Packs ownership data into a single uint256.
674      */
675     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
676         assembly {
677             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
678             owner := and(owner, _BITMASK_ADDRESS)
679             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
680             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
681         }
682     }
683 
684     /**
685      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
686      */
687     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
688         // For branchless setting of the `nextInitialized` flag.
689         assembly {
690             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
691             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
692         }
693     }
694 
695     // =============================================================
696     //                      APPROVAL OPERATIONS
697     // =============================================================
698 
699     /**
700      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
701      * The approval is cleared when the token is transferred.
702      *
703      * Only a single account can be approved at a time, so approving the
704      * zero address clears previous approvals.
705      *
706      * Requirements:
707      *
708      * - The caller must own the token or be an approved operator.
709      * - `tokenId` must exist.
710      *
711      * Emits an {Approval} event.
712      */
713     function approve(address to, uint256 tokenId) public payable virtual override {
714         address owner = ownerOf(tokenId);
715 
716         if (_msgSenderERC721A() != owner)
717             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
718                 revert ApprovalCallerNotOwnerNorApproved();
719             }
720 
721         _tokenApprovals[tokenId].value = to;
722         emit Approval(owner, to, tokenId);
723     }
724 
725     /**
726      * @dev Returns the account approved for `tokenId` token.
727      *
728      * Requirements:
729      *
730      * - `tokenId` must exist.
731      */
732     function getApproved(uint256 tokenId) public view virtual override returns (address) {
733         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
734 
735         return _tokenApprovals[tokenId].value;
736     }
737 
738     /**
739      * @dev Approve or remove `operator` as an operator for the caller.
740      * Operators can call {transferFrom} or {safeTransferFrom}
741      * for any token owned by the caller.
742      *
743      * Requirements:
744      *
745      * - The `operator` cannot be the caller.
746      *
747      * Emits an {ApprovalForAll} event.
748      */
749     function setApprovalForAll(address operator, bool approved) public virtual override {
750         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
751         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
752     }
753 
754     /**
755      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
756      *
757      * See {setApprovalForAll}.
758      */
759     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
760         return _operatorApprovals[owner][operator];
761     }
762 
763     /**
764      * @dev Returns whether `tokenId` exists.
765      *
766      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
767      *
768      * Tokens start existing when they are minted. See {_mint}.
769      */
770     function _exists(uint256 tokenId) internal view virtual returns (bool) {
771         return
772             _startTokenId() <= tokenId &&
773             tokenId < _currentIndex && // If within bounds,
774             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
775     }
776 
777     /**
778      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
779      */
780     function _isSenderApprovedOrOwner(
781         address approvedAddress,
782         address owner,
783         address msgSender
784     ) private pure returns (bool result) {
785         assembly {
786             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
787             owner := and(owner, _BITMASK_ADDRESS)
788             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
789             msgSender := and(msgSender, _BITMASK_ADDRESS)
790             // `msgSender == owner || msgSender == approvedAddress`.
791             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
792         }
793     }
794 
795     /**
796      * @dev Returns the storage slot and value for the approved address of `tokenId`.
797      */
798     function _getApprovedSlotAndAddress(uint256 tokenId)
799         private
800         view
801         returns (uint256 approvedAddressSlot, address approvedAddress)
802     {
803         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
804         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
805         assembly {
806             approvedAddressSlot := tokenApproval.slot
807             approvedAddress := sload(approvedAddressSlot)
808         }
809     }
810 
811     // =============================================================
812     //                      TRANSFER OPERATIONS
813     // =============================================================
814 
815     /**
816      * @dev Transfers `tokenId` from `from` to `to`.
817      *
818      * Requirements:
819      *
820      * - `from` cannot be the zero address.
821      * - `to` cannot be the zero address.
822      * - `tokenId` token must be owned by `from`.
823      * - If the caller is not `from`, it must be approved to move this token
824      * by either {approve} or {setApprovalForAll}.
825      *
826      * Emits a {Transfer} event.
827      */
828     function transferFrom(
829         address from,
830         address to,
831         uint256 tokenId
832     ) public payable virtual override {
833         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
834 
835         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
836 
837         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
838 
839         // The nested ifs save around 20+ gas over a compound boolean condition.
840         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
841             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
842 
843         if (to == address(0)) revert TransferToZeroAddress();
844 
845         _beforeTokenTransfers(from, to, tokenId, 1);
846 
847         // Clear approvals from the previous owner.
848         assembly {
849             if approvedAddress {
850                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
851                 sstore(approvedAddressSlot, 0)
852             }
853         }
854 
855         // Underflow of the sender's balance is impossible because we check for
856         // ownership above and the recipient's balance can't realistically overflow.
857         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
858         unchecked {
859             // We can directly increment and decrement the balances.
860             --_packedAddressData[from]; // Updates: `balance -= 1`.
861             ++_packedAddressData[to]; // Updates: `balance += 1`.
862 
863             // Updates:
864             // - `address` to the next owner.
865             // - `startTimestamp` to the timestamp of transfering.
866             // - `burned` to `false`.
867             // - `nextInitialized` to `true`.
868             _packedOwnerships[tokenId] = _packOwnershipData(
869                 to,
870                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
871             );
872 
873             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
874             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
875                 uint256 nextTokenId = tokenId + 1;
876                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
877                 if (_packedOwnerships[nextTokenId] == 0) {
878                     // If the next slot is within bounds.
879                     if (nextTokenId != _currentIndex) {
880                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
881                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
882                     }
883                 }
884             }
885         }
886 
887         emit Transfer(from, to, tokenId);
888         _afterTokenTransfers(from, to, tokenId, 1);
889     }
890 
891     /**
892      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
893      */
894     function safeTransferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) public payable virtual override {
899         safeTransferFrom(from, to, tokenId, '');
900     }
901 
902     /**
903      * @dev Safely transfers `tokenId` token from `from` to `to`.
904      *
905      * Requirements:
906      *
907      * - `from` cannot be the zero address.
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must exist and be owned by `from`.
910      * - If the caller is not `from`, it must be approved to move this token
911      * by either {approve} or {setApprovalForAll}.
912      * - If `to` refers to a smart contract, it must implement
913      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) public payable virtual override {
923         transferFrom(from, to, tokenId);
924         if (to.code.length != 0)
925             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
926                 revert TransferToNonERC721ReceiverImplementer();
927             }
928     }
929 
930     /**
931      * @dev Hook that is called before a set of serially-ordered token IDs
932      * are about to be transferred. This includes minting.
933      * And also called before burning one token.
934      *
935      * `startTokenId` - the first token ID to be transferred.
936      * `quantity` - the amount to be transferred.
937      *
938      * Calling conditions:
939      *
940      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
941      * transferred to `to`.
942      * - When `from` is zero, `tokenId` will be minted for `to`.
943      * - When `to` is zero, `tokenId` will be burned by `from`.
944      * - `from` and `to` are never both zero.
945      */
946     function _beforeTokenTransfers(
947         address from,
948         address to,
949         uint256 startTokenId,
950         uint256 quantity
951     ) internal virtual {}
952 
953     /**
954      * @dev Hook that is called after a set of serially-ordered token IDs
955      * have been transferred. This includes minting.
956      * And also called after one token has been burned.
957      *
958      * `startTokenId` - the first token ID to be transferred.
959      * `quantity` - the amount to be transferred.
960      *
961      * Calling conditions:
962      *
963      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
964      * transferred to `to`.
965      * - When `from` is zero, `tokenId` has been minted for `to`.
966      * - When `to` is zero, `tokenId` has been burned by `from`.
967      * - `from` and `to` are never both zero.
968      */
969     function _afterTokenTransfers(
970         address from,
971         address to,
972         uint256 startTokenId,
973         uint256 quantity
974     ) internal virtual {}
975 
976     /**
977      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
978      *
979      * `from` - Previous owner of the given token ID.
980      * `to` - Target address that will receive the token.
981      * `tokenId` - Token ID to be transferred.
982      * `_data` - Optional data to send along with the call.
983      *
984      * Returns whether the call correctly returned the expected magic value.
985      */
986     function _checkContractOnERC721Received(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) private returns (bool) {
992         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
993             bytes4 retval
994         ) {
995             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
996         } catch (bytes memory reason) {
997             if (reason.length == 0) {
998                 revert TransferToNonERC721ReceiverImplementer();
999             } else {
1000                 assembly {
1001                     revert(add(32, reason), mload(reason))
1002                 }
1003             }
1004         }
1005     }
1006 
1007     // =============================================================
1008     //                        MINT OPERATIONS
1009     // =============================================================
1010 
1011     /**
1012      * @dev Mints `quantity` tokens and transfers them to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `to` cannot be the zero address.
1017      * - `quantity` must be greater than 0.
1018      *
1019      * Emits a {Transfer} event for each mint.
1020      */
1021     function _mint(address to, uint256 quantity) internal virtual {
1022         uint256 startTokenId = _currentIndex;
1023         if (quantity == 0) revert MintZeroQuantity();
1024 
1025         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1026 
1027         // Overflows are incredibly unrealistic.
1028         // `balance` and `numberMinted` have a maximum limit of 2**64.
1029         // `tokenId` has a maximum limit of 2**256.
1030         unchecked {
1031             // Updates:
1032             // - `balance += quantity`.
1033             // - `numberMinted += quantity`.
1034             //
1035             // We can directly add to the `balance` and `numberMinted`.
1036             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1037 
1038             // Updates:
1039             // - `address` to the owner.
1040             // - `startTimestamp` to the timestamp of minting.
1041             // - `burned` to `false`.
1042             // - `nextInitialized` to `quantity == 1`.
1043             _packedOwnerships[startTokenId] = _packOwnershipData(
1044                 to,
1045                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1046             );
1047 
1048             uint256 toMasked;
1049             uint256 end = startTokenId + quantity;
1050 
1051             // Use assembly to loop and emit the `Transfer` event for gas savings.
1052             // The duplicated `log4` removes an extra check and reduces stack juggling.
1053             // The assembly, together with the surrounding Solidity code, have been
1054             // delicately arranged to nudge the compiler into producing optimized opcodes.
1055             assembly {
1056                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1057                 toMasked := and(to, _BITMASK_ADDRESS)
1058                 // Emit the `Transfer` event.
1059                 log4(
1060                     0, // Start of data (0, since no data).
1061                     0, // End of data (0, since no data).
1062                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1063                     0, // `address(0)`.
1064                     toMasked, // `to`.
1065                     startTokenId // `tokenId`.
1066                 )
1067 
1068                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1069                 // that overflows uint256 will make the loop run out of gas.
1070                 // The compiler will optimize the `iszero` away for performance.
1071                 for {
1072                     let tokenId := add(startTokenId, 1)
1073                 } iszero(eq(tokenId, end)) {
1074                     tokenId := add(tokenId, 1)
1075                 } {
1076                     // Emit the `Transfer` event. Similar to above.
1077                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1078                 }
1079             }
1080             if (toMasked == 0) revert MintToZeroAddress();
1081 
1082             _currentIndex = end;
1083         }
1084         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1085     }
1086 
1087     /**
1088      * @dev Mints `quantity` tokens and transfers them to `to`.
1089      *
1090      * This function is intended for efficient minting only during contract creation.
1091      *
1092      * It emits only one {ConsecutiveTransfer} as defined in
1093      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1094      * instead of a sequence of {Transfer} event(s).
1095      *
1096      * Calling this function outside of contract creation WILL make your contract
1097      * non-compliant with the ERC721 standard.
1098      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1099      * {ConsecutiveTransfer} event is only permissible during contract creation.
1100      *
1101      * Requirements:
1102      *
1103      * - `to` cannot be the zero address.
1104      * - `quantity` must be greater than 0.
1105      *
1106      * Emits a {ConsecutiveTransfer} event.
1107      */
1108     function _mintERC2309(address to, uint256 quantity) internal virtual {
1109         uint256 startTokenId = _currentIndex;
1110         if (to == address(0)) revert MintToZeroAddress();
1111         if (quantity == 0) revert MintZeroQuantity();
1112         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1113 
1114         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1115 
1116         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1117         unchecked {
1118             // Updates:
1119             // - `balance += quantity`.
1120             // - `numberMinted += quantity`.
1121             //
1122             // We can directly add to the `balance` and `numberMinted`.
1123             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1124 
1125             // Updates:
1126             // - `address` to the owner.
1127             // - `startTimestamp` to the timestamp of minting.
1128             // - `burned` to `false`.
1129             // - `nextInitialized` to `quantity == 1`.
1130             _packedOwnerships[startTokenId] = _packOwnershipData(
1131                 to,
1132                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1133             );
1134 
1135             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1136 
1137             _currentIndex = startTokenId + quantity;
1138         }
1139         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1140     }
1141 
1142     /**
1143      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - If `to` refers to a smart contract, it must implement
1148      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1149      * - `quantity` must be greater than 0.
1150      *
1151      * See {_mint}.
1152      *
1153      * Emits a {Transfer} event for each mint.
1154      */
1155     function _safeMint(
1156         address to,
1157         uint256 quantity,
1158         bytes memory _data
1159     ) internal virtual {
1160         _mint(to, quantity);
1161 
1162         unchecked {
1163             if (to.code.length != 0) {
1164                 uint256 end = _currentIndex;
1165                 uint256 index = end - quantity;
1166                 do {
1167                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1168                         revert TransferToNonERC721ReceiverImplementer();
1169                     }
1170                 } while (index < end);
1171                 // Reentrancy protection.
1172                 if (_currentIndex != end) revert();
1173             }
1174         }
1175     }
1176 
1177     /**
1178      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1179      */
1180     function _safeMint(address to, uint256 quantity) internal virtual {
1181         _safeMint(to, quantity, '');
1182     }
1183 
1184     // =============================================================
1185     //                        BURN OPERATIONS
1186     // =============================================================
1187 
1188     /**
1189      * @dev Equivalent to `_burn(tokenId, false)`.
1190      */
1191     function _burn(uint256 tokenId) internal virtual {
1192         _burn(tokenId, false);
1193     }
1194 
1195     /**
1196      * @dev Destroys `tokenId`.
1197      * The approval is cleared when the token is burned.
1198      *
1199      * Requirements:
1200      *
1201      * - `tokenId` must exist.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1206         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1207 
1208         address from = address(uint160(prevOwnershipPacked));
1209 
1210         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1211 
1212         if (approvalCheck) {
1213             // The nested ifs save around 20+ gas over a compound boolean condition.
1214             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1215                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1216         }
1217 
1218         _beforeTokenTransfers(from, address(0), tokenId, 1);
1219 
1220         // Clear approvals from the previous owner.
1221         assembly {
1222             if approvedAddress {
1223                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1224                 sstore(approvedAddressSlot, 0)
1225             }
1226         }
1227 
1228         // Underflow of the sender's balance is impossible because we check for
1229         // ownership above and the recipient's balance can't realistically overflow.
1230         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1231         unchecked {
1232             // Updates:
1233             // - `balance -= 1`.
1234             // - `numberBurned += 1`.
1235             //
1236             // We can directly decrement the balance, and increment the number burned.
1237             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1238             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1239 
1240             // Updates:
1241             // - `address` to the last owner.
1242             // - `startTimestamp` to the timestamp of burning.
1243             // - `burned` to `true`.
1244             // - `nextInitialized` to `true`.
1245             _packedOwnerships[tokenId] = _packOwnershipData(
1246                 from,
1247                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1248             );
1249 
1250             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1251             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1252                 uint256 nextTokenId = tokenId + 1;
1253                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1254                 if (_packedOwnerships[nextTokenId] == 0) {
1255                     // If the next slot is within bounds.
1256                     if (nextTokenId != _currentIndex) {
1257                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1258                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1259                     }
1260                 }
1261             }
1262         }
1263 
1264         emit Transfer(from, address(0), tokenId);
1265         _afterTokenTransfers(from, address(0), tokenId, 1);
1266 
1267         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1268         unchecked {
1269             _burnCounter++;
1270         }
1271     }
1272 
1273     // =============================================================
1274     //                     EXTRA DATA OPERATIONS
1275     // =============================================================
1276 
1277     /**
1278      * @dev Directly sets the extra data for the ownership data `index`.
1279      */
1280     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1281         uint256 packed = _packedOwnerships[index];
1282         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1283         uint256 extraDataCasted;
1284         // Cast `extraData` with assembly to avoid redundant masking.
1285         assembly {
1286             extraDataCasted := extraData
1287         }
1288         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1289         _packedOwnerships[index] = packed;
1290     }
1291 
1292     /**
1293      * @dev Called during each token transfer to set the 24bit `extraData` field.
1294      * Intended to be overridden by the cosumer contract.
1295      *
1296      * `previousExtraData` - the value of `extraData` before transfer.
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` will be minted for `to`.
1303      * - When `to` is zero, `tokenId` will be burned by `from`.
1304      * - `from` and `to` are never both zero.
1305      */
1306     function _extraData(
1307         address from,
1308         address to,
1309         uint24 previousExtraData
1310     ) internal view virtual returns (uint24) {}
1311 
1312     /**
1313      * @dev Returns the next extra data for the packed ownership data.
1314      * The returned result is shifted into position.
1315      */
1316     function _nextExtraData(
1317         address from,
1318         address to,
1319         uint256 prevOwnershipPacked
1320     ) private view returns (uint256) {
1321         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1322         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1323     }
1324 
1325     // =============================================================
1326     //                       OTHER OPERATIONS
1327     // =============================================================
1328 
1329     /**
1330      * @dev Returns the message sender (defaults to `msg.sender`).
1331      *
1332      * If you are writing GSN compatible contracts, you need to override this function.
1333      */
1334     function _msgSenderERC721A() internal view virtual returns (address) {
1335         return msg.sender;
1336     }
1337 
1338     /**
1339      * @dev Converts a uint256 to its ASCII string decimal representation.
1340      */
1341     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1342         assembly {
1343             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1344             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1345             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1346             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1347             let m := add(mload(0x40), 0xa0)
1348             // Update the free memory pointer to allocate.
1349             mstore(0x40, m)
1350             // Assign the `str` to the end.
1351             str := sub(m, 0x20)
1352             // Zeroize the slot after the string.
1353             mstore(str, 0)
1354 
1355             // Cache the end of the memory to calculate the length later.
1356             let end := str
1357 
1358             // We write the string from rightmost digit to leftmost digit.
1359             // The following is essentially a do-while loop that also handles the zero case.
1360             // prettier-ignore
1361             for { let temp := value } 1 {} {
1362                 str := sub(str, 1)
1363                 // Write the character to the pointer.
1364                 // The ASCII index of the '0' character is 48.
1365                 mstore8(str, add(48, mod(temp, 10)))
1366                 // Keep dividing `temp` until zero.
1367                 temp := div(temp, 10)
1368                 // prettier-ignore
1369                 if iszero(temp) { break }
1370             }
1371 
1372             let length := sub(end, str)
1373             // Move the pointer 32 bytes leftwards to make room for the length.
1374             str := sub(str, 0x20)
1375             // Store the length.
1376             mstore(str, length)
1377         }
1378     }
1379 }
1380 
1381 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1382 
1383 
1384 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1385 
1386 pragma solidity ^0.8.0;
1387 
1388 /**
1389  * @dev Contract module that helps prevent reentrant calls to a function.
1390  *
1391  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1392  * available, which can be applied to functions to make sure there are no nested
1393  * (reentrant) calls to them.
1394  *
1395  * Note that because there is a single `nonReentrant` guard, functions marked as
1396  * `nonReentrant` may not call one another. This can be worked around by making
1397  * those functions `private`, and then adding `external` `nonReentrant` entry
1398  * points to them.
1399  *
1400  * TIP: If you would like to learn more about reentrancy and alternative ways
1401  * to protect against it, check out our blog post
1402  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1403  */
1404 abstract contract ReentrancyGuard {
1405     // Booleans are more expensive than uint256 or any type that takes up a full
1406     // word because each write operation emits an extra SLOAD to first read the
1407     // slot's contents, replace the bits taken up by the boolean, and then write
1408     // back. This is the compiler's defense against contract upgrades and
1409     // pointer aliasing, and it cannot be disabled.
1410 
1411     // The values being non-zero value makes deployment a bit more expensive,
1412     // but in exchange the refund on every call to nonReentrant will be lower in
1413     // amount. Since refunds are capped to a percentage of the total
1414     // transaction's gas, it is best to keep them low in cases like this one, to
1415     // increase the likelihood of the full refund coming into effect.
1416     uint256 private constant _NOT_ENTERED = 1;
1417     uint256 private constant _ENTERED = 2;
1418 
1419     uint256 private _status;
1420 
1421     constructor() {
1422         _status = _NOT_ENTERED;
1423     }
1424 
1425     /**
1426      * @dev Prevents a contract from calling itself, directly or indirectly.
1427      * Calling a `nonReentrant` function from another `nonReentrant`
1428      * function is not supported. It is possible to prevent this from happening
1429      * by making the `nonReentrant` function external, and making it call a
1430      * `private` function that does the actual work.
1431      */
1432     modifier nonReentrant() {
1433         // On the first call to nonReentrant, _notEntered will be true
1434         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1435 
1436         // Any calls to nonReentrant after this point will fail
1437         _status = _ENTERED;
1438 
1439         _;
1440 
1441         // By storing the original value once again, a refund is triggered (see
1442         // https://eips.ethereum.org/EIPS/eip-2200)
1443         _status = _NOT_ENTERED;
1444     }
1445 }
1446 
1447 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1448 
1449 
1450 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1451 
1452 pragma solidity ^0.8.0;
1453 
1454 /**
1455  * @dev These functions deal with verification of Merkle Tree proofs.
1456  *
1457  * The proofs can be generated using the JavaScript library
1458  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1459  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1460  *
1461  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1462  *
1463  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1464  * hashing, or use a hash function other than keccak256 for hashing leaves.
1465  * This is because the concatenation of a sorted pair of internal nodes in
1466  * the merkle tree could be reinterpreted as a leaf value.
1467  */
1468 library MerkleProof {
1469     /**
1470      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1471      * defined by `root`. For this, a `proof` must be provided, containing
1472      * sibling hashes on the branch from the leaf to the root of the tree. Each
1473      * pair of leaves and each pair of pre-images are assumed to be sorted.
1474      */
1475     function verify(
1476         bytes32[] memory proof,
1477         bytes32 root,
1478         bytes32 leaf
1479     ) internal pure returns (bool) {
1480         return processProof(proof, leaf) == root;
1481     }
1482 
1483     /**
1484      * @dev Calldata version of {verify}
1485      *
1486      * _Available since v4.7._
1487      */
1488     function verifyCalldata(
1489         bytes32[] calldata proof,
1490         bytes32 root,
1491         bytes32 leaf
1492     ) internal pure returns (bool) {
1493         return processProofCalldata(proof, leaf) == root;
1494     }
1495 
1496     /**
1497      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1498      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1499      * hash matches the root of the tree. When processing the proof, the pairs
1500      * of leafs & pre-images are assumed to be sorted.
1501      *
1502      * _Available since v4.4._
1503      */
1504     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1505         bytes32 computedHash = leaf;
1506         for (uint256 i = 0; i < proof.length; i++) {
1507             computedHash = _hashPair(computedHash, proof[i]);
1508         }
1509         return computedHash;
1510     }
1511 
1512     /**
1513      * @dev Calldata version of {processProof}
1514      *
1515      * _Available since v4.7._
1516      */
1517     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1518         bytes32 computedHash = leaf;
1519         for (uint256 i = 0; i < proof.length; i++) {
1520             computedHash = _hashPair(computedHash, proof[i]);
1521         }
1522         return computedHash;
1523     }
1524 
1525     /**
1526      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1527      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1528      *
1529      * _Available since v4.7._
1530      */
1531     function multiProofVerify(
1532         bytes32[] memory proof,
1533         bool[] memory proofFlags,
1534         bytes32 root,
1535         bytes32[] memory leaves
1536     ) internal pure returns (bool) {
1537         return processMultiProof(proof, proofFlags, leaves) == root;
1538     }
1539 
1540     /**
1541      * @dev Calldata version of {multiProofVerify}
1542      *
1543      * _Available since v4.7._
1544      */
1545     function multiProofVerifyCalldata(
1546         bytes32[] calldata proof,
1547         bool[] calldata proofFlags,
1548         bytes32 root,
1549         bytes32[] memory leaves
1550     ) internal pure returns (bool) {
1551         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1552     }
1553 
1554     /**
1555      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1556      * consuming from one or the other at each step according to the instructions given by
1557      * `proofFlags`.
1558      *
1559      * _Available since v4.7._
1560      */
1561     function processMultiProof(
1562         bytes32[] memory proof,
1563         bool[] memory proofFlags,
1564         bytes32[] memory leaves
1565     ) internal pure returns (bytes32 merkleRoot) {
1566         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1567         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1568         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1569         // the merkle tree.
1570         uint256 leavesLen = leaves.length;
1571         uint256 totalHashes = proofFlags.length;
1572 
1573         // Check proof validity.
1574         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1575 
1576         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1577         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1578         bytes32[] memory hashes = new bytes32[](totalHashes);
1579         uint256 leafPos = 0;
1580         uint256 hashPos = 0;
1581         uint256 proofPos = 0;
1582         // At each step, we compute the next hash using two values:
1583         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1584         //   get the next hash.
1585         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1586         //   `proof` array.
1587         for (uint256 i = 0; i < totalHashes; i++) {
1588             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1589             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1590             hashes[i] = _hashPair(a, b);
1591         }
1592 
1593         if (totalHashes > 0) {
1594             return hashes[totalHashes - 1];
1595         } else if (leavesLen > 0) {
1596             return leaves[0];
1597         } else {
1598             return proof[0];
1599         }
1600     }
1601 
1602     /**
1603      * @dev Calldata version of {processMultiProof}
1604      *
1605      * _Available since v4.7._
1606      */
1607     function processMultiProofCalldata(
1608         bytes32[] calldata proof,
1609         bool[] calldata proofFlags,
1610         bytes32[] memory leaves
1611     ) internal pure returns (bytes32 merkleRoot) {
1612         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1613         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1614         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1615         // the merkle tree.
1616         uint256 leavesLen = leaves.length;
1617         uint256 totalHashes = proofFlags.length;
1618 
1619         // Check proof validity.
1620         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1621 
1622         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1623         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1624         bytes32[] memory hashes = new bytes32[](totalHashes);
1625         uint256 leafPos = 0;
1626         uint256 hashPos = 0;
1627         uint256 proofPos = 0;
1628         // At each step, we compute the next hash using two values:
1629         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1630         //   get the next hash.
1631         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1632         //   `proof` array.
1633         for (uint256 i = 0; i < totalHashes; i++) {
1634             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1635             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1636             hashes[i] = _hashPair(a, b);
1637         }
1638 
1639         if (totalHashes > 0) {
1640             return hashes[totalHashes - 1];
1641         } else if (leavesLen > 0) {
1642             return leaves[0];
1643         } else {
1644             return proof[0];
1645         }
1646     }
1647 
1648     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1649         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1650     }
1651 
1652     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1653         /// @solidity memory-safe-assembly
1654         assembly {
1655             mstore(0x00, a)
1656             mstore(0x20, b)
1657             value := keccak256(0x00, 0x40)
1658         }
1659     }
1660 }
1661 
1662 // File: @openzeppelin/contracts/utils/Address.sol
1663 
1664 
1665 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1666 
1667 pragma solidity ^0.8.1;
1668 
1669 /**
1670  * @dev Collection of functions related to the address type
1671  */
1672 library Address {
1673     /**
1674      * @dev Returns true if `account` is a contract.
1675      *
1676      * [IMPORTANT]
1677      * ====
1678      * It is unsafe to assume that an address for which this function returns
1679      * false is an externally-owned account (EOA) and not a contract.
1680      *
1681      * Among others, `isContract` will return false for the following
1682      * types of addresses:
1683      *
1684      *  - an externally-owned account
1685      *  - a contract in construction
1686      *  - an address where a contract will be created
1687      *  - an address where a contract lived, but was destroyed
1688      * ====
1689      *
1690      * [IMPORTANT]
1691      * ====
1692      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1693      *
1694      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1695      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1696      * constructor.
1697      * ====
1698      */
1699     function isContract(address account) internal view returns (bool) {
1700         // This method relies on extcodesize/address.code.length, which returns 0
1701         // for contracts in construction, since the code is only stored at the end
1702         // of the constructor execution.
1703 
1704         return account.code.length > 0;
1705     }
1706 
1707     /**
1708      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1709      * `recipient`, forwarding all available gas and reverting on errors.
1710      *
1711      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1712      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1713      * imposed by `transfer`, making them unable to receive funds via
1714      * `transfer`. {sendValue} removes this limitation.
1715      *
1716      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1717      *
1718      * IMPORTANT: because control is transferred to `recipient`, care must be
1719      * taken to not create reentrancy vulnerabilities. Consider using
1720      * {ReentrancyGuard} or the
1721      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1722      */
1723     function sendValue(address payable recipient, uint256 amount) internal {
1724         require(address(this).balance >= amount, "Address: insufficient balance");
1725 
1726         (bool success, ) = recipient.call{value: amount}("");
1727         require(success, "Address: unable to send value, recipient may have reverted");
1728     }
1729 
1730     /**
1731      * @dev Performs a Solidity function call using a low level `call`. A
1732      * plain `call` is an unsafe replacement for a function call: use this
1733      * function instead.
1734      *
1735      * If `target` reverts with a revert reason, it is bubbled up by this
1736      * function (like regular Solidity function calls).
1737      *
1738      * Returns the raw returned data. To convert to the expected return value,
1739      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1740      *
1741      * Requirements:
1742      *
1743      * - `target` must be a contract.
1744      * - calling `target` with `data` must not revert.
1745      *
1746      * _Available since v3.1._
1747      */
1748     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1749         return functionCall(target, data, "Address: low-level call failed");
1750     }
1751 
1752     /**
1753      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1754      * `errorMessage` as a fallback revert reason when `target` reverts.
1755      *
1756      * _Available since v3.1._
1757      */
1758     function functionCall(
1759         address target,
1760         bytes memory data,
1761         string memory errorMessage
1762     ) internal returns (bytes memory) {
1763         return functionCallWithValue(target, data, 0, errorMessage);
1764     }
1765 
1766     /**
1767      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1768      * but also transferring `value` wei to `target`.
1769      *
1770      * Requirements:
1771      *
1772      * - the calling contract must have an ETH balance of at least `value`.
1773      * - the called Solidity function must be `payable`.
1774      *
1775      * _Available since v3.1._
1776      */
1777     function functionCallWithValue(
1778         address target,
1779         bytes memory data,
1780         uint256 value
1781     ) internal returns (bytes memory) {
1782         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1783     }
1784 
1785     /**
1786      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1787      * with `errorMessage` as a fallback revert reason when `target` reverts.
1788      *
1789      * _Available since v3.1._
1790      */
1791     function functionCallWithValue(
1792         address target,
1793         bytes memory data,
1794         uint256 value,
1795         string memory errorMessage
1796     ) internal returns (bytes memory) {
1797         require(address(this).balance >= value, "Address: insufficient balance for call");
1798         require(isContract(target), "Address: call to non-contract");
1799 
1800         (bool success, bytes memory returndata) = target.call{value: value}(data);
1801         return verifyCallResult(success, returndata, errorMessage);
1802     }
1803 
1804     /**
1805      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1806      * but performing a static call.
1807      *
1808      * _Available since v3.3._
1809      */
1810     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1811         return functionStaticCall(target, data, "Address: low-level static call failed");
1812     }
1813 
1814     /**
1815      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1816      * but performing a static call.
1817      *
1818      * _Available since v3.3._
1819      */
1820     function functionStaticCall(
1821         address target,
1822         bytes memory data,
1823         string memory errorMessage
1824     ) internal view returns (bytes memory) {
1825         require(isContract(target), "Address: static call to non-contract");
1826 
1827         (bool success, bytes memory returndata) = target.staticcall(data);
1828         return verifyCallResult(success, returndata, errorMessage);
1829     }
1830 
1831     /**
1832      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1833      * but performing a delegate call.
1834      *
1835      * _Available since v3.4._
1836      */
1837     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1838         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1839     }
1840 
1841     /**
1842      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1843      * but performing a delegate call.
1844      *
1845      * _Available since v3.4._
1846      */
1847     function functionDelegateCall(
1848         address target,
1849         bytes memory data,
1850         string memory errorMessage
1851     ) internal returns (bytes memory) {
1852         require(isContract(target), "Address: delegate call to non-contract");
1853 
1854         (bool success, bytes memory returndata) = target.delegatecall(data);
1855         return verifyCallResult(success, returndata, errorMessage);
1856     }
1857 
1858     /**
1859      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1860      * revert reason using the provided one.
1861      *
1862      * _Available since v4.3._
1863      */
1864     function verifyCallResult(
1865         bool success,
1866         bytes memory returndata,
1867         string memory errorMessage
1868     ) internal pure returns (bytes memory) {
1869         if (success) {
1870             return returndata;
1871         } else {
1872             // Look for revert reason and bubble it up if present
1873             if (returndata.length > 0) {
1874                 // The easiest way to bubble the revert reason is using memory via assembly
1875                 /// @solidity memory-safe-assembly
1876                 assembly {
1877                     let returndata_size := mload(returndata)
1878                     revert(add(32, returndata), returndata_size)
1879                 }
1880             } else {
1881                 revert(errorMessage);
1882             }
1883         }
1884     }
1885 }
1886 
1887 // File: @openzeppelin/contracts/utils/Strings.sol
1888 
1889 
1890 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1891 
1892 pragma solidity ^0.8.0;
1893 
1894 /**
1895  * @dev String operations.
1896  */
1897 library Strings {
1898     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1899     uint8 private constant _ADDRESS_LENGTH = 20;
1900 
1901     /**
1902      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1903      */
1904     function toString(uint256 value) internal pure returns (string memory) {
1905         // Inspired by OraclizeAPI's implementation - MIT licence
1906         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1907 
1908         if (value == 0) {
1909             return "0";
1910         }
1911         uint256 temp = value;
1912         uint256 digits;
1913         while (temp != 0) {
1914             digits++;
1915             temp /= 10;
1916         }
1917         bytes memory buffer = new bytes(digits);
1918         while (value != 0) {
1919             digits -= 1;
1920             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1921             value /= 10;
1922         }
1923         return string(buffer);
1924     }
1925 
1926     /**
1927      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1928      */
1929     function toHexString(uint256 value) internal pure returns (string memory) {
1930         if (value == 0) {
1931             return "0x00";
1932         }
1933         uint256 temp = value;
1934         uint256 length = 0;
1935         while (temp != 0) {
1936             length++;
1937             temp >>= 8;
1938         }
1939         return toHexString(value, length);
1940     }
1941 
1942     /**
1943      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1944      */
1945     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1946         bytes memory buffer = new bytes(2 * length + 2);
1947         buffer[0] = "0";
1948         buffer[1] = "x";
1949         for (uint256 i = 2 * length + 1; i > 1; --i) {
1950             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1951             value >>= 4;
1952         }
1953         require(value == 0, "Strings: hex length insufficient");
1954         return string(buffer);
1955     }
1956 
1957     /**
1958      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1959      */
1960     function toHexString(address addr) internal pure returns (string memory) {
1961         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1962     }
1963 }
1964 
1965 // File: @openzeppelin/contracts/utils/Context.sol
1966 
1967 
1968 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1969 
1970 pragma solidity ^0.8.0;
1971 
1972 /**
1973  * @dev Provides information about the current execution context, including the
1974  * sender of the transaction and its data. While these are generally available
1975  * via msg.sender and msg.data, they should not be accessed in such a direct
1976  * manner, since when dealing with meta-transactions the account sending and
1977  * paying for execution may not be the actual sender (as far as an application
1978  * is concerned).
1979  *
1980  * This contract is only required for intermediate, library-like contracts.
1981  */
1982 abstract contract Context {
1983     function _msgSender() internal view virtual returns (address) {
1984         return msg.sender;
1985     }
1986 
1987     function _msgData() internal view virtual returns (bytes calldata) {
1988         return msg.data;
1989     }
1990 }
1991 
1992 // File: @openzeppelin/contracts/access/Ownable.sol
1993 
1994 
1995 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1996 
1997 pragma solidity ^0.8.0;
1998 
1999 
2000 /**
2001  * @dev Contract module which provides a basic access control mechanism, where
2002  * there is an account (an owner) that can be granted exclusive access to
2003  * specific functions.
2004  *
2005  * By default, the owner account will be the one that deploys the contract. This
2006  * can later be changed with {transferOwnership}.
2007  *
2008  * This module is used through inheritance. It will make available the modifier
2009  * `onlyOwner`, which can be applied to your functions to restrict their use to
2010  * the owner.
2011  */
2012 abstract contract Ownable is Context {
2013     address private _owner;
2014 
2015     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2016 
2017     /**
2018      * @dev Initializes the contract setting the deployer as the initial owner.
2019      */
2020     constructor() {
2021         _transferOwnership(_msgSender());
2022     }
2023 
2024     /**
2025      * @dev Throws if called by any account other than the owner.
2026      */
2027     modifier onlyOwner() {
2028         _checkOwner();
2029         _;
2030     }
2031 
2032     /**
2033      * @dev Returns the address of the current owner.
2034      */
2035     function owner() public view virtual returns (address) {
2036         return _owner;
2037     }
2038 
2039     /**
2040      * @dev Throws if the sender is not the owner.
2041      */
2042     function _checkOwner() internal view virtual {
2043         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2044     }
2045 
2046     /**
2047      * @dev Leaves the contract without owner. It will not be possible to call
2048      * `onlyOwner` functions anymore. Can only be called by the current owner.
2049      *
2050      * NOTE: Renouncing ownership will leave the contract without an owner,
2051      * thereby removing any functionality that is only available to the owner.
2052      */
2053     function renounceOwnership() public virtual onlyOwner {
2054         _transferOwnership(address(0));
2055     }
2056 
2057     /**
2058      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2059      * Can only be called by the current owner.
2060      */
2061     function transferOwnership(address newOwner) public virtual onlyOwner {
2062         require(newOwner != address(0), "Ownable: new owner is the zero address");
2063         _transferOwnership(newOwner);
2064     }
2065 
2066     /**
2067      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2068      * Internal function without access restriction.
2069      */
2070     function _transferOwnership(address newOwner) internal virtual {
2071         address oldOwner = _owner;
2072         _owner = newOwner;
2073         emit OwnershipTransferred(oldOwner, newOwner);
2074     }
2075 }
2076 
2077 // File: contracts/EthNameDomains.sol
2078 
2079 
2080 pragma solidity >=0.7.0 <0.9.0;
2081 
2082 
2083 
2084 
2085 
2086 
2087 
2088 contract EthNameDomains is ERC721A, Ownable, ReentrancyGuard {
2089 
2090     /// ERRORS ///
2091     error NotOwner();
2092     error InvalidName();
2093 
2094     error SaleInactive();
2095     error InsufficientFunds();
2096     error AlreadyClaimedAllowlist();
2097 
2098     error InvalidProof();
2099     error InexistantToken();
2100 
2101     using Strings for uint256;
2102     uint256 public PRICE = 15000000000000000;
2103     uint256 public REF = 20;
2104     uint256 public REF_OWNER = 30;
2105     uint256 public REF_DISCOUNT = 20;
2106     uint256 public SUBDOMAIN_FEE = 10;
2107     uint256 private MAX_CHAR = 20;
2108 
2109     uint32 SALE_START_TIME = 1666625220;
2110     string private domain = ".ethereum";
2111     string private BASE_URI = "https://metadata.ethname.domains/";
2112 
2113     bool public IS_SALE_ACTIVE = true;
2114 
2115     mapping(uint => string[]) public categories;
2116 
2117     mapping(string => address) public resolveAddress;
2118     mapping(address => string) public primaryAddress;
2119     mapping(string => bool) public subDomains_publicSale;
2120     mapping(string => uint) public subDomains_cost;
2121     mapping(string => mapping(string => string)) public nameData;
2122     mapping(address => bool) public allowListMints;
2123     
2124     bytes32 public merkleRoot;
2125     bytes32 public internalRoot;
2126 
2127     constructor() ERC721A(".ethereum Name Service", ".ethereum") payable {
2128         _register("ethereum");
2129         _register("ens");
2130         _register("vitalik");
2131     }
2132 
2133     function register(string memory name, address referrer)
2134         public
2135         payable
2136         nameCompliance(name)
2137     {   
2138         if (!IS_SALE_ACTIVE) revert SaleInactive();
2139 
2140         bool isRef = referrer != address(0);
2141         uint256 finalPrice = PRICE;
2142         uint256 reward;
2143 
2144         unchecked {
2145             if (isRef) {
2146                 if (bytes(primaryAddress[referrer]).length > 0)
2147                     reward = PRICE * REF_OWNER/ 100;
2148                 else
2149                     reward = PRICE * REF / 100;
2150                 finalPrice = PRICE * (100 - REF_DISCOUNT) / 100;
2151             }
2152 
2153             if (msg.value < finalPrice) revert InsufficientFunds();
2154             payable(referrer).transfer(reward);
2155         }
2156 
2157         _register(name);
2158     }
2159 
2160     function registerSubdomain(string memory name, string memory subName)
2161         public
2162         payable
2163     {   
2164         if (!IS_SALE_ACTIVE) revert SaleInactive();
2165 
2166         string memory subDomain = string(abi.encodePacked(subName, '.', name));
2167         if (!validName(subName) || !validName(name) || tokenAddressandID[subDomain] != 0) 
2168             revert InvalidName();
2169 
2170         TokenOwnership memory ownership = _ownershipOf(tokenAddressandID[name]);
2171         if (ownership.addr != msg.sender) {
2172             if (!subDomains_publicSale[name]) revert SaleInactive();
2173             if (msg.value < subDomains_cost[name]) revert InsufficientFunds();
2174             payable(ownership.addr).transfer(msg.value * (100 - SUBDOMAIN_FEE) / 100);
2175         }
2176         
2177         _register(subDomain);
2178     }
2179 
2180     function registerAllowlist(string memory name, bytes32[] calldata merkleProof)
2181         public
2182         nameCompliance(name)
2183     {
2184         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2185         if (!MerkleProof.verify(merkleProof, merkleRoot, leaf)) revert InvalidProof();
2186 
2187         if (allowListMints[msg.sender]) revert AlreadyClaimedAllowlist();
2188         allowListMints[msg.sender] = true;
2189         
2190         _register(name);
2191     }
2192 
2193     function registerInternal(string memory name, bytes32[] calldata merkleProof)
2194         public
2195         nameCompliance(name)
2196     {
2197         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2198         if (!MerkleProof.verify(merkleProof, internalRoot, leaf)) revert InvalidProof();
2199         
2200         _register(name);
2201     }
2202 
2203     function validName(string memory _name) public view returns(bool) {
2204         bytes memory b = bytes(_name);
2205 
2206         unchecked {
2207             if (b.length > MAX_CHAR || b.length < 1) 
2208                 return false;
2209 
2210             for(uint i; i < b.length; ++i) {
2211                 bytes1 char = b[i];
2212 
2213                 if(!(char >= 0x30 && char <= 0x39) && !(char >= 0x61 && char <= 0x7A) && (char != 0x5F) && (char != 0x2D)) // 0-9, a-z, _, -
2214                     return false;
2215             }
2216         }
2217         return true;
2218     }
2219 
2220     function isRegisterable(string memory _name) public view returns(bool) {
2221         return tokenAddressandID[_name] == 0 && validName(_name);
2222     }
2223 
2224     function _register(string memory name) internal {
2225         tokenIDandAddress[_currentIndex] = name;
2226         tokenAddressandID[name] = _currentIndex;
2227         resolveAddress[name] = msg.sender;
2228         _safeMint(msg.sender, 1);
2229     }
2230 
2231     /// GETTERS ///
2232 
2233     function getUserData(string memory name, string calldata field) public view returns(string memory) {
2234         return nameData[name][field];
2235     }
2236 
2237     function getNameOwner(string memory name) public view returns(address) {
2238         uint256 id = tokenAddressandID[name];
2239         return ownerOf(id);
2240     }
2241 
2242     function getCategory(uint256 categoryId) public view returns(string[] memory) {
2243         return categories[categoryId];
2244     }
2245 
2246     function lastAddresses(uint256 count)
2247         public
2248         view
2249         returns (string[] memory)
2250     {
2251         uint256 total = totalSupply();
2252         string[] memory lastAddr = new string[](count);
2253         uint256 currentId = total - count;
2254         uint256 ownedTokenIndex = 0;
2255         require(currentId >= 0, "Invalid");
2256         while (total > currentId) {
2257             lastAddr[ownedTokenIndex] = string(abi.encodePacked(tokenIDandAddress[total], domain));
2258             ownedTokenIndex++;
2259         total--;
2260         }
2261 
2262         return lastAddr;
2263     }
2264 
2265     function walletOfOwnerName(address _owner)
2266         public
2267         view
2268         returns (string[] memory)
2269     {
2270         uint256 ownerTokenCount = balanceOf(_owner);
2271         string[] memory ownedTokenIds = new string[](ownerTokenCount);
2272         uint256 currentTokenId = 1;
2273         uint256 ownedTokenIndex = 0;
2274 
2275         while (ownedTokenIndex < ownerTokenCount) {
2276         address currentTokenOwner = ownerOf(currentTokenId);
2277 
2278         if (currentTokenOwner == _owner) {
2279             ownedTokenIds[ownedTokenIndex] = string(abi.encodePacked(tokenIDandAddress[currentTokenId], domain));
2280 
2281             ownedTokenIndex++;
2282         }
2283 
2284         currentTokenId++;
2285         }
2286 
2287         return ownedTokenIds;
2288     }
2289 
2290 
2291     /// SETTERS ///
2292 
2293     function setBaseURI(string memory customBaseURI_) external onlyOwner {
2294         BASE_URI = customBaseURI_;
2295     }
2296 
2297     function setMaxCharSize(uint256 maxCharSize_) external onlyOwner {
2298         MAX_CHAR = maxCharSize_;
2299     }
2300 
2301     function setPrice(uint256 price) external onlyOwner {
2302         PRICE = price;
2303     }
2304 
2305     function toggleSaleStatus() external onlyOwner {
2306         IS_SALE_ACTIVE = !IS_SALE_ACTIVE;
2307     }
2308 
2309     function addCategories(uint256[] memory newCategories) external onlyOwner {
2310         for (uint i; i < newCategories.length; ++i) {
2311             string[] memory dataField;
2312             categories[newCategories[i]] = dataField;
2313         }
2314     }
2315 
2316     function setRefSettings(uint ref,uint ref_owner, uint ref_discount, uint subdomains_fee) external onlyOwner {
2317         REF = ref;
2318         REF_OWNER = ref_owner;
2319         REF_DISCOUNT = ref_discount;
2320         SUBDOMAIN_FEE = subdomains_fee;
2321     }
2322 
2323     function namediff(uint256 tokenId , string calldata newName) external onlyOwner {
2324         tokenIDandAddress[tokenId] = newName;
2325         tokenAddressandID[newName] = tokenId;
2326     }
2327 
2328     function setMerkleRoot(bytes32 _newMerkleRoot) external onlyOwner {
2329         merkleRoot = _newMerkleRoot;
2330     }
2331 
2332     function setInternalRoot(bytes32 _newMerkleRoot) external onlyOwner {
2333         internalRoot = _newMerkleRoot;
2334     }
2335     
2336     function setSaleStartTime(uint32 time) external onlyOwner {
2337         SALE_START_TIME = time;
2338     }
2339 
2340     function setPrimaryAddress(string calldata name) external {
2341         if (resolveAddress[name] != msg.sender) revert NotOwner();
2342         primaryAddress[msg.sender] = name;
2343     }
2344 
2345     function setUserData(string calldata name, string[] calldata fields, string[] memory data) external ownershipCompliance(name) {
2346         for(uint i; i < fields.length; ++i) {
2347             nameData[name][fields[i]] = data[i];
2348         }
2349     }
2350 
2351     function setUserCategory(string calldata name, uint categoryId) external ownershipCompliance(name) {
2352         categories[categoryId].push(name);
2353     }
2354 
2355     function setAddress(string calldata name, address newResolve) external ownershipCompliance(name) {
2356         bytes memory result = bytes(primaryAddress[resolveAddress[name]]);
2357         if (keccak256(result) == keccak256(bytes(name))) {
2358             primaryAddress[resolveAddress[name]] = "";
2359         }
2360         resolveAddress[name] = newResolve;
2361     }
2362 
2363     function setSubdomainSaleActive(string calldata name, bool isActive, uint256 customPrice)
2364         public
2365         ownershipCompliance(name)
2366     {
2367         subDomains_cost[name] = customPrice;
2368         subDomains_publicSale[name] = isActive;
2369     }
2370 
2371     /// MODIFIERS ///
2372 
2373     modifier ownershipCompliance(string memory name) {
2374         TokenOwnership memory ownership = _ownershipOf(tokenAddressandID[name]);
2375         if (ownership.addr != msg.sender) revert NotOwner();
2376         _;
2377     }
2378 
2379     modifier nameCompliance(string memory name) {
2380         if (block.timestamp < SALE_START_TIME) revert SaleInactive();
2381         if (!isRegisterable(name)) revert InvalidName();
2382         _;
2383     }
2384 
2385     function _startTokenId()
2386         internal
2387         view
2388         virtual
2389         override returns (uint256) 
2390     {
2391         return 1;
2392     }
2393 
2394     function _baseURI()
2395         internal 
2396         view 
2397         virtual
2398         override returns (string memory)
2399     {
2400         return BASE_URI;
2401     }
2402 
2403     function _beforeTokenTransfers(
2404         address from,
2405         address to,
2406         uint256 startTokenId,
2407         uint256 quantity
2408     ) internal virtual override {
2409         super._beforeTokenTransfers(from, to, startTokenId, quantity);
2410         resolveAddress[tokenIDandAddress[startTokenId]] = to;
2411     }
2412 
2413     function tokenURI(uint256 _tokenId)
2414         public
2415         view
2416         virtual
2417         override
2418         returns (string memory)
2419     {
2420         require(
2421             _exists(_tokenId),
2422             "ERC721Metadata: URI query for nonexistent token"
2423         );
2424 
2425         return string(abi.encodePacked(_baseURI(), _tokenId.toString(), '/', tokenIDandAddress[_tokenId]));
2426     }
2427 
2428     /// PAYOUT ///
2429 
2430     function withdraw() public onlyOwner nonReentrant {
2431         uint256 balance = address(this).balance;
2432         payable(0x7CdB864677d9fD4057dd77Be0868e7B82B18CE93).transfer(balance * 50/100);
2433         payable(0x944245C6561Cb4A9BCA276EEEc6F34d386BDbd56).transfer(balance * 50/100);
2434     }
2435 
2436 }