1 // File: erc721a/contracts/IERC721A.sol
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
286 // File: erc721a/contracts/ERC721A.sol
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
384     uint256 private _currentIndex;
385 
386     // The number of tokens burned.
387     uint256 private _burnCounter;
388 
389     // Token name
390     string private _name;
391 
392     // Token symbol
393     string private _symbol;
394 
395     // Mapping from token ID to ownership details
396     // An empty struct value does not necessarily mean the token is unowned.
397     // See {_packedOwnershipOf} implementation for details.
398     //
399     // Bits Layout:
400     // - [0..159]   `addr`
401     // - [160..223] `startTimestamp`
402     // - [224]      `burned`
403     // - [225]      `nextInitialized`
404     // - [232..255] `extraData`
405     mapping(uint256 => uint256) private _packedOwnerships;
406 
407     // Mapping owner address to address data.
408     //
409     // Bits Layout:
410     // - [0..63]    `balance`
411     // - [64..127]  `numberMinted`
412     // - [128..191] `numberBurned`
413     // - [192..255] `aux`
414     mapping(address => uint256) private _packedAddressData;
415 
416     // Mapping from token ID to approved address.
417     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
418 
419     // Mapping from owner to operator approvals
420     mapping(address => mapping(address => bool)) private _operatorApprovals;
421 
422     // =============================================================
423     //                          CONSTRUCTOR
424     // =============================================================
425 
426     constructor(string memory name_, string memory symbol_) {
427         _name = name_;
428         _symbol = symbol_;
429         _currentIndex = _startTokenId();
430     }
431 
432     // =============================================================
433     //                   TOKEN COUNTING OPERATIONS
434     // =============================================================
435 
436     /**
437      * @dev Returns the starting token ID.
438      * To change the starting token ID, please override this function.
439      */
440     function _startTokenId() internal view virtual returns (uint256) {
441         return 0;
442     }
443 
444     /**
445      * @dev Returns the next token ID to be minted.
446      */
447     function _nextTokenId() internal view virtual returns (uint256) {
448         return _currentIndex;
449     }
450 
451     /**
452      * @dev Returns the total number of tokens in existence.
453      * Burned tokens will reduce the count.
454      * To get the total number of tokens minted, please see {_totalMinted}.
455      */
456     function totalSupply() public view virtual override returns (uint256) {
457         // Counter underflow is impossible as _burnCounter cannot be incremented
458         // more than `_currentIndex - _startTokenId()` times.
459         unchecked {
460             return _currentIndex - _burnCounter - _startTokenId();
461         }
462     }
463 
464     /**
465      * @dev Returns the total amount of tokens minted in the contract.
466      */
467     function _totalMinted() internal view virtual returns (uint256) {
468         // Counter underflow is impossible as `_currentIndex` does not decrement,
469         // and it is initialized to `_startTokenId()`.
470         unchecked {
471             return _currentIndex - _startTokenId();
472         }
473     }
474 
475     /**
476      * @dev Returns the total number of tokens burned.
477      */
478     function _totalBurned() internal view virtual returns (uint256) {
479         return _burnCounter;
480     }
481 
482     // =============================================================
483     //                    ADDRESS DATA OPERATIONS
484     // =============================================================
485 
486     /**
487      * @dev Returns the number of tokens in `owner`'s account.
488      */
489     function balanceOf(address owner) public view virtual override returns (uint256) {
490         if (owner == address(0)) revert BalanceQueryForZeroAddress();
491         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
492     }
493 
494     /**
495      * Returns the number of tokens minted by `owner`.
496      */
497     function _numberMinted(address owner) internal view returns (uint256) {
498         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
499     }
500 
501     /**
502      * Returns the number of tokens burned by or on behalf of `owner`.
503      */
504     function _numberBurned(address owner) internal view returns (uint256) {
505         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
506     }
507 
508     /**
509      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
510      */
511     function _getAux(address owner) internal view returns (uint64) {
512         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
513     }
514 
515     /**
516      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
517      * If there are multiple variables, please pack them into a uint64.
518      */
519     function _setAux(address owner, uint64 aux) internal virtual {
520         uint256 packed = _packedAddressData[owner];
521         uint256 auxCasted;
522         // Cast `aux` with assembly to avoid redundant masking.
523         assembly {
524             auxCasted := aux
525         }
526         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
527         _packedAddressData[owner] = packed;
528     }
529 
530     // =============================================================
531     //                            IERC165
532     // =============================================================
533 
534     /**
535      * @dev Returns true if this contract implements the interface defined by
536      * `interfaceId`. See the corresponding
537      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
538      * to learn more about how these ids are created.
539      *
540      * This function call must use less than 30000 gas.
541      */
542     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543         // The interface IDs are constants representing the first 4 bytes
544         // of the XOR of all function selectors in the interface.
545         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
546         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
547         return
548             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
549             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
550             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
551     }
552 
553     // =============================================================
554     //                        IERC721Metadata
555     // =============================================================
556 
557     /**
558      * @dev Returns the token collection name.
559      */
560     function name() public view virtual override returns (string memory) {
561         return _name;
562     }
563 
564     /**
565      * @dev Returns the token collection symbol.
566      */
567     function symbol() public view virtual override returns (string memory) {
568         return _symbol;
569     }
570 
571     /**
572      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
573      */
574     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
575         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
576 
577         string memory baseURI = _baseURI();
578         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
579     }
580 
581     /**
582      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
583      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
584      * by default, it can be overridden in child contracts.
585      */
586     function _baseURI() internal view virtual returns (string memory) {
587         return '';
588     }
589 
590     // =============================================================
591     //                     OWNERSHIPS OPERATIONS
592     // =============================================================
593 
594     /**
595      * @dev Returns the owner of the `tokenId` token.
596      *
597      * Requirements:
598      *
599      * - `tokenId` must exist.
600      */
601     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
602         return address(uint160(_packedOwnershipOf(tokenId)));
603     }
604 
605     /**
606      * @dev Gas spent here starts off proportional to the maximum mint batch size.
607      * It gradually moves to O(1) as tokens get transferred around over time.
608      */
609     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
610         return _unpackedOwnership(_packedOwnershipOf(tokenId));
611     }
612 
613     /**
614      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
615      */
616     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
617         return _unpackedOwnership(_packedOwnerships[index]);
618     }
619 
620     /**
621      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
622      */
623     function _initializeOwnershipAt(uint256 index) internal virtual {
624         if (_packedOwnerships[index] == 0) {
625             _packedOwnerships[index] = _packedOwnershipOf(index);
626         }
627     }
628 
629     /**
630      * Returns the packed ownership data of `tokenId`.
631      */
632     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
633         uint256 curr = tokenId;
634 
635         unchecked {
636             if (_startTokenId() <= curr)
637                 if (curr < _currentIndex) {
638                     uint256 packed = _packedOwnerships[curr];
639                     // If not burned.
640                     if (packed & _BITMASK_BURNED == 0) {
641                         // Invariant:
642                         // There will always be an initialized ownership slot
643                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
644                         // before an unintialized ownership slot
645                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
646                         // Hence, `curr` will not underflow.
647                         //
648                         // We can directly compare the packed value.
649                         // If the address is zero, packed will be zero.
650                         while (packed == 0) {
651                             packed = _packedOwnerships[--curr];
652                         }
653                         return packed;
654                     }
655                 }
656         }
657         revert OwnerQueryForNonexistentToken();
658     }
659 
660     /**
661      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
662      */
663     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
664         ownership.addr = address(uint160(packed));
665         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
666         ownership.burned = packed & _BITMASK_BURNED != 0;
667         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
668     }
669 
670     /**
671      * @dev Packs ownership data into a single uint256.
672      */
673     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
674         assembly {
675             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
676             owner := and(owner, _BITMASK_ADDRESS)
677             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
678             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
679         }
680     }
681 
682     /**
683      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
684      */
685     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
686         // For branchless setting of the `nextInitialized` flag.
687         assembly {
688             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
689             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
690         }
691     }
692 
693     // =============================================================
694     //                      APPROVAL OPERATIONS
695     // =============================================================
696 
697     /**
698      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
699      * The approval is cleared when the token is transferred.
700      *
701      * Only a single account can be approved at a time, so approving the
702      * zero address clears previous approvals.
703      *
704      * Requirements:
705      *
706      * - The caller must own the token or be an approved operator.
707      * - `tokenId` must exist.
708      *
709      * Emits an {Approval} event.
710      */
711     function approve(address to, uint256 tokenId) public payable virtual override {
712         address owner = ownerOf(tokenId);
713 
714         if (_msgSenderERC721A() != owner)
715             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
716                 revert ApprovalCallerNotOwnerNorApproved();
717             }
718 
719         _tokenApprovals[tokenId].value = to;
720         emit Approval(owner, to, tokenId);
721     }
722 
723     /**
724      * @dev Returns the account approved for `tokenId` token.
725      *
726      * Requirements:
727      *
728      * - `tokenId` must exist.
729      */
730     function getApproved(uint256 tokenId) public view virtual override returns (address) {
731         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
732 
733         return _tokenApprovals[tokenId].value;
734     }
735 
736     /**
737      * @dev Approve or remove `operator` as an operator for the caller.
738      * Operators can call {transferFrom} or {safeTransferFrom}
739      * for any token owned by the caller.
740      *
741      * Requirements:
742      *
743      * - The `operator` cannot be the caller.
744      *
745      * Emits an {ApprovalForAll} event.
746      */
747     function setApprovalForAll(address operator, bool approved) public virtual override {
748         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
749         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
750     }
751 
752     /**
753      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
754      *
755      * See {setApprovalForAll}.
756      */
757     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
758         return _operatorApprovals[owner][operator];
759     }
760 
761     /**
762      * @dev Returns whether `tokenId` exists.
763      *
764      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
765      *
766      * Tokens start existing when they are minted. See {_mint}.
767      */
768     function _exists(uint256 tokenId) internal view virtual returns (bool) {
769         return
770             _startTokenId() <= tokenId &&
771             tokenId < _currentIndex && // If within bounds,
772             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
773     }
774 
775     /**
776      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
777      */
778     function _isSenderApprovedOrOwner(
779         address approvedAddress,
780         address owner,
781         address msgSender
782     ) private pure returns (bool result) {
783         assembly {
784             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
785             owner := and(owner, _BITMASK_ADDRESS)
786             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
787             msgSender := and(msgSender, _BITMASK_ADDRESS)
788             // `msgSender == owner || msgSender == approvedAddress`.
789             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
790         }
791     }
792 
793     /**
794      * @dev Returns the storage slot and value for the approved address of `tokenId`.
795      */
796     function _getApprovedSlotAndAddress(uint256 tokenId)
797         private
798         view
799         returns (uint256 approvedAddressSlot, address approvedAddress)
800     {
801         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
802         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
803         assembly {
804             approvedAddressSlot := tokenApproval.slot
805             approvedAddress := sload(approvedAddressSlot)
806         }
807     }
808 
809     // =============================================================
810     //                      TRANSFER OPERATIONS
811     // =============================================================
812 
813     /**
814      * @dev Transfers `tokenId` from `from` to `to`.
815      *
816      * Requirements:
817      *
818      * - `from` cannot be the zero address.
819      * - `to` cannot be the zero address.
820      * - `tokenId` token must be owned by `from`.
821      * - If the caller is not `from`, it must be approved to move this token
822      * by either {approve} or {setApprovalForAll}.
823      *
824      * Emits a {Transfer} event.
825      */
826     function transferFrom(
827         address from,
828         address to,
829         uint256 tokenId
830     ) public payable virtual override {
831         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
832 
833         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
834 
835         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
836 
837         // The nested ifs save around 20+ gas over a compound boolean condition.
838         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
839             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
840 
841         if (to == address(0)) revert TransferToZeroAddress();
842 
843         _beforeTokenTransfers(from, to, tokenId, 1);
844 
845         // Clear approvals from the previous owner.
846         assembly {
847             if approvedAddress {
848                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
849                 sstore(approvedAddressSlot, 0)
850             }
851         }
852 
853         // Underflow of the sender's balance is impossible because we check for
854         // ownership above and the recipient's balance can't realistically overflow.
855         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
856         unchecked {
857             // We can directly increment and decrement the balances.
858             --_packedAddressData[from]; // Updates: `balance -= 1`.
859             ++_packedAddressData[to]; // Updates: `balance += 1`.
860 
861             // Updates:
862             // - `address` to the next owner.
863             // - `startTimestamp` to the timestamp of transfering.
864             // - `burned` to `false`.
865             // - `nextInitialized` to `true`.
866             _packedOwnerships[tokenId] = _packOwnershipData(
867                 to,
868                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
869             );
870 
871             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
872             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
873                 uint256 nextTokenId = tokenId + 1;
874                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
875                 if (_packedOwnerships[nextTokenId] == 0) {
876                     // If the next slot is within bounds.
877                     if (nextTokenId != _currentIndex) {
878                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
879                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
880                     }
881                 }
882             }
883         }
884 
885         emit Transfer(from, to, tokenId);
886         _afterTokenTransfers(from, to, tokenId, 1);
887     }
888 
889     /**
890      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public payable virtual override {
897         safeTransferFrom(from, to, tokenId, '');
898     }
899 
900     /**
901      * @dev Safely transfers `tokenId` token from `from` to `to`.
902      *
903      * Requirements:
904      *
905      * - `from` cannot be the zero address.
906      * - `to` cannot be the zero address.
907      * - `tokenId` token must exist and be owned by `from`.
908      * - If the caller is not `from`, it must be approved to move this token
909      * by either {approve} or {setApprovalForAll}.
910      * - If `to` refers to a smart contract, it must implement
911      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
912      *
913      * Emits a {Transfer} event.
914      */
915     function safeTransferFrom(
916         address from,
917         address to,
918         uint256 tokenId,
919         bytes memory _data
920     ) public payable virtual override {
921         transferFrom(from, to, tokenId);
922         if (to.code.length != 0)
923             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
924                 revert TransferToNonERC721ReceiverImplementer();
925             }
926     }
927 
928     /**
929      * @dev Hook that is called before a set of serially-ordered token IDs
930      * are about to be transferred. This includes minting.
931      * And also called before burning one token.
932      *
933      * `startTokenId` - the first token ID to be transferred.
934      * `quantity` - the amount to be transferred.
935      *
936      * Calling conditions:
937      *
938      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
939      * transferred to `to`.
940      * - When `from` is zero, `tokenId` will be minted for `to`.
941      * - When `to` is zero, `tokenId` will be burned by `from`.
942      * - `from` and `to` are never both zero.
943      */
944     function _beforeTokenTransfers(
945         address from,
946         address to,
947         uint256 startTokenId,
948         uint256 quantity
949     ) internal virtual {}
950 
951     /**
952      * @dev Hook that is called after a set of serially-ordered token IDs
953      * have been transferred. This includes minting.
954      * And also called after one token has been burned.
955      *
956      * `startTokenId` - the first token ID to be transferred.
957      * `quantity` - the amount to be transferred.
958      *
959      * Calling conditions:
960      *
961      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
962      * transferred to `to`.
963      * - When `from` is zero, `tokenId` has been minted for `to`.
964      * - When `to` is zero, `tokenId` has been burned by `from`.
965      * - `from` and `to` are never both zero.
966      */
967     function _afterTokenTransfers(
968         address from,
969         address to,
970         uint256 startTokenId,
971         uint256 quantity
972     ) internal virtual {}
973 
974     /**
975      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
976      *
977      * `from` - Previous owner of the given token ID.
978      * `to` - Target address that will receive the token.
979      * `tokenId` - Token ID to be transferred.
980      * `_data` - Optional data to send along with the call.
981      *
982      * Returns whether the call correctly returned the expected magic value.
983      */
984     function _checkContractOnERC721Received(
985         address from,
986         address to,
987         uint256 tokenId,
988         bytes memory _data
989     ) private returns (bool) {
990         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
991             bytes4 retval
992         ) {
993             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
994         } catch (bytes memory reason) {
995             if (reason.length == 0) {
996                 revert TransferToNonERC721ReceiverImplementer();
997             } else {
998                 assembly {
999                     revert(add(32, reason), mload(reason))
1000                 }
1001             }
1002         }
1003     }
1004 
1005     // =============================================================
1006     //                        MINT OPERATIONS
1007     // =============================================================
1008 
1009     /**
1010      * @dev Mints `quantity` tokens and transfers them to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `to` cannot be the zero address.
1015      * - `quantity` must be greater than 0.
1016      *
1017      * Emits a {Transfer} event for each mint.
1018      */
1019     function _mint(address to, uint256 quantity) internal virtual {
1020         uint256 startTokenId = _currentIndex;
1021         if (quantity == 0) revert MintZeroQuantity();
1022 
1023         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1024 
1025         // Overflows are incredibly unrealistic.
1026         // `balance` and `numberMinted` have a maximum limit of 2**64.
1027         // `tokenId` has a maximum limit of 2**256.
1028         unchecked {
1029             // Updates:
1030             // - `balance += quantity`.
1031             // - `numberMinted += quantity`.
1032             //
1033             // We can directly add to the `balance` and `numberMinted`.
1034             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1035 
1036             // Updates:
1037             // - `address` to the owner.
1038             // - `startTimestamp` to the timestamp of minting.
1039             // - `burned` to `false`.
1040             // - `nextInitialized` to `quantity == 1`.
1041             _packedOwnerships[startTokenId] = _packOwnershipData(
1042                 to,
1043                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1044             );
1045 
1046             uint256 toMasked;
1047             uint256 end = startTokenId + quantity;
1048 
1049             // Use assembly to loop and emit the `Transfer` event for gas savings.
1050             // The duplicated `log4` removes an extra check and reduces stack juggling.
1051             // The assembly, together with the surrounding Solidity code, have been
1052             // delicately arranged to nudge the compiler into producing optimized opcodes.
1053             assembly {
1054                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1055                 toMasked := and(to, _BITMASK_ADDRESS)
1056                 // Emit the `Transfer` event.
1057                 log4(
1058                     0, // Start of data (0, since no data).
1059                     0, // End of data (0, since no data).
1060                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1061                     0, // `address(0)`.
1062                     toMasked, // `to`.
1063                     startTokenId // `tokenId`.
1064                 )
1065 
1066                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1067                 // that overflows uint256 will make the loop run out of gas.
1068                 // The compiler will optimize the `iszero` away for performance.
1069                 for {
1070                     let tokenId := add(startTokenId, 1)
1071                 } iszero(eq(tokenId, end)) {
1072                     tokenId := add(tokenId, 1)
1073                 } {
1074                     // Emit the `Transfer` event. Similar to above.
1075                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1076                 }
1077             }
1078             if (toMasked == 0) revert MintToZeroAddress();
1079 
1080             _currentIndex = end;
1081         }
1082         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1083     }
1084 
1085     /**
1086      * @dev Mints `quantity` tokens and transfers them to `to`.
1087      *
1088      * This function is intended for efficient minting only during contract creation.
1089      *
1090      * It emits only one {ConsecutiveTransfer} as defined in
1091      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1092      * instead of a sequence of {Transfer} event(s).
1093      *
1094      * Calling this function outside of contract creation WILL make your contract
1095      * non-compliant with the ERC721 standard.
1096      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1097      * {ConsecutiveTransfer} event is only permissible during contract creation.
1098      *
1099      * Requirements:
1100      *
1101      * - `to` cannot be the zero address.
1102      * - `quantity` must be greater than 0.
1103      *
1104      * Emits a {ConsecutiveTransfer} event.
1105      */
1106     function _mintERC2309(address to, uint256 quantity) internal virtual {
1107         uint256 startTokenId = _currentIndex;
1108         if (to == address(0)) revert MintToZeroAddress();
1109         if (quantity == 0) revert MintZeroQuantity();
1110         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1111 
1112         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1113 
1114         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1115         unchecked {
1116             // Updates:
1117             // - `balance += quantity`.
1118             // - `numberMinted += quantity`.
1119             //
1120             // We can directly add to the `balance` and `numberMinted`.
1121             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1122 
1123             // Updates:
1124             // - `address` to the owner.
1125             // - `startTimestamp` to the timestamp of minting.
1126             // - `burned` to `false`.
1127             // - `nextInitialized` to `quantity == 1`.
1128             _packedOwnerships[startTokenId] = _packOwnershipData(
1129                 to,
1130                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1131             );
1132 
1133             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1134 
1135             _currentIndex = startTokenId + quantity;
1136         }
1137         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1138     }
1139 
1140     /**
1141      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1142      *
1143      * Requirements:
1144      *
1145      * - If `to` refers to a smart contract, it must implement
1146      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1147      * - `quantity` must be greater than 0.
1148      *
1149      * See {_mint}.
1150      *
1151      * Emits a {Transfer} event for each mint.
1152      */
1153     function _safeMint(
1154         address to,
1155         uint256 quantity,
1156         bytes memory _data
1157     ) internal virtual {
1158         _mint(to, quantity);
1159 
1160         unchecked {
1161             if (to.code.length != 0) {
1162                 uint256 end = _currentIndex;
1163                 uint256 index = end - quantity;
1164                 do {
1165                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1166                         revert TransferToNonERC721ReceiverImplementer();
1167                     }
1168                 } while (index < end);
1169                 // Reentrancy protection.
1170                 if (_currentIndex != end) revert();
1171             }
1172         }
1173     }
1174 
1175     /**
1176      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1177      */
1178     function _safeMint(address to, uint256 quantity) internal virtual {
1179         _safeMint(to, quantity, '');
1180     }
1181 
1182     // =============================================================
1183     //                        BURN OPERATIONS
1184     // =============================================================
1185 
1186     /**
1187      * @dev Equivalent to `_burn(tokenId, false)`.
1188      */
1189     function _burn(uint256 tokenId) internal virtual {
1190         _burn(tokenId, false);
1191     }
1192 
1193     /**
1194      * @dev Destroys `tokenId`.
1195      * The approval is cleared when the token is burned.
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must exist.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1204         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1205 
1206         address from = address(uint160(prevOwnershipPacked));
1207 
1208         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1209 
1210         if (approvalCheck) {
1211             // The nested ifs save around 20+ gas over a compound boolean condition.
1212             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1213                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1214         }
1215 
1216         _beforeTokenTransfers(from, address(0), tokenId, 1);
1217 
1218         // Clear approvals from the previous owner.
1219         assembly {
1220             if approvedAddress {
1221                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1222                 sstore(approvedAddressSlot, 0)
1223             }
1224         }
1225 
1226         // Underflow of the sender's balance is impossible because we check for
1227         // ownership above and the recipient's balance can't realistically overflow.
1228         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1229         unchecked {
1230             // Updates:
1231             // - `balance -= 1`.
1232             // - `numberBurned += 1`.
1233             //
1234             // We can directly decrement the balance, and increment the number burned.
1235             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1236             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1237 
1238             // Updates:
1239             // - `address` to the last owner.
1240             // - `startTimestamp` to the timestamp of burning.
1241             // - `burned` to `true`.
1242             // - `nextInitialized` to `true`.
1243             _packedOwnerships[tokenId] = _packOwnershipData(
1244                 from,
1245                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1246             );
1247 
1248             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1249             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1250                 uint256 nextTokenId = tokenId + 1;
1251                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1252                 if (_packedOwnerships[nextTokenId] == 0) {
1253                     // If the next slot is within bounds.
1254                     if (nextTokenId != _currentIndex) {
1255                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1256                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1257                     }
1258                 }
1259             }
1260         }
1261 
1262         emit Transfer(from, address(0), tokenId);
1263         _afterTokenTransfers(from, address(0), tokenId, 1);
1264 
1265         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1266         unchecked {
1267             _burnCounter++;
1268         }
1269     }
1270 
1271     // =============================================================
1272     //                     EXTRA DATA OPERATIONS
1273     // =============================================================
1274 
1275     /**
1276      * @dev Directly sets the extra data for the ownership data `index`.
1277      */
1278     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1279         uint256 packed = _packedOwnerships[index];
1280         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1281         uint256 extraDataCasted;
1282         // Cast `extraData` with assembly to avoid redundant masking.
1283         assembly {
1284             extraDataCasted := extraData
1285         }
1286         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1287         _packedOwnerships[index] = packed;
1288     }
1289 
1290     /**
1291      * @dev Called during each token transfer to set the 24bit `extraData` field.
1292      * Intended to be overridden by the cosumer contract.
1293      *
1294      * `previousExtraData` - the value of `extraData` before transfer.
1295      *
1296      * Calling conditions:
1297      *
1298      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1299      * transferred to `to`.
1300      * - When `from` is zero, `tokenId` will be minted for `to`.
1301      * - When `to` is zero, `tokenId` will be burned by `from`.
1302      * - `from` and `to` are never both zero.
1303      */
1304     function _extraData(
1305         address from,
1306         address to,
1307         uint24 previousExtraData
1308     ) internal view virtual returns (uint24) {}
1309 
1310     /**
1311      * @dev Returns the next extra data for the packed ownership data.
1312      * The returned result is shifted into position.
1313      */
1314     function _nextExtraData(
1315         address from,
1316         address to,
1317         uint256 prevOwnershipPacked
1318     ) private view returns (uint256) {
1319         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1320         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1321     }
1322 
1323     // =============================================================
1324     //                       OTHER OPERATIONS
1325     // =============================================================
1326 
1327     /**
1328      * @dev Returns the message sender (defaults to `msg.sender`).
1329      *
1330      * If you are writing GSN compatible contracts, you need to override this function.
1331      */
1332     function _msgSenderERC721A() internal view virtual returns (address) {
1333         return msg.sender;
1334     }
1335 
1336     /**
1337      * @dev Converts a uint256 to its ASCII string decimal representation.
1338      */
1339     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1340         assembly {
1341             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1342             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1343             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1344             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1345             let m := add(mload(0x40), 0xa0)
1346             // Update the free memory pointer to allocate.
1347             mstore(0x40, m)
1348             // Assign the `str` to the end.
1349             str := sub(m, 0x20)
1350             // Zeroize the slot after the string.
1351             mstore(str, 0)
1352 
1353             // Cache the end of the memory to calculate the length later.
1354             let end := str
1355 
1356             // We write the string from rightmost digit to leftmost digit.
1357             // The following is essentially a do-while loop that also handles the zero case.
1358             // prettier-ignore
1359             for { let temp := value } 1 {} {
1360                 str := sub(str, 1)
1361                 // Write the character to the pointer.
1362                 // The ASCII index of the '0' character is 48.
1363                 mstore8(str, add(48, mod(temp, 10)))
1364                 // Keep dividing `temp` until zero.
1365                 temp := div(temp, 10)
1366                 // prettier-ignore
1367                 if iszero(temp) { break }
1368             }
1369 
1370             let length := sub(end, str)
1371             // Move the pointer 32 bytes leftwards to make room for the length.
1372             str := sub(str, 0x20)
1373             // Store the length.
1374             mstore(str, length)
1375         }
1376     }
1377 }
1378 
1379 // File: erc721a/contracts/extensions/IERC721ABurnable.sol
1380 
1381 
1382 // ERC721A Contracts v4.2.3
1383 // Creator: Chiru Labs
1384 
1385 pragma solidity ^0.8.4;
1386 
1387 
1388 /**
1389  * @dev Interface of ERC721ABurnable.
1390  */
1391 interface IERC721ABurnable is IERC721A {
1392     /**
1393      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1394      *
1395      * Requirements:
1396      *
1397      * - The caller must own `tokenId` or be an approved operator.
1398      */
1399     function burn(uint256 tokenId) external;
1400 }
1401 
1402 // File: erc721a/contracts/extensions/ERC721ABurnable.sol
1403 
1404 
1405 // ERC721A Contracts v4.2.3
1406 // Creator: Chiru Labs
1407 
1408 pragma solidity ^0.8.4;
1409 
1410 
1411 
1412 /**
1413  * @title ERC721ABurnable.
1414  *
1415  * @dev ERC721A token that can be irreversibly burned (destroyed).
1416  */
1417 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1418     /**
1419      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1420      *
1421      * Requirements:
1422      *
1423      * - The caller must own `tokenId` or be an approved operator.
1424      */
1425     function burn(uint256 tokenId) public virtual override {
1426         _burn(tokenId, true);
1427     }
1428 }
1429 
1430 // File: filterer/IOperatorFilterRegistry.sol
1431 
1432 
1433 pragma solidity ^0.8.17;
1434 
1435 interface IOperatorFilterRegistry {
1436     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1437     function register(address registrant) external;
1438     function registerAndSubscribe(address registrant, address subscription) external;
1439     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1440     function unregister(address addr) external;
1441     function updateOperator(address registrant, address operator, bool filtered) external;
1442     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1443     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1444     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1445     function subscribe(address registrant, address registrantToSubscribe) external;
1446     function unsubscribe(address registrant, bool copyExistingEntries) external;
1447     function subscriptionOf(address addr) external returns (address registrant);
1448     function subscribers(address registrant) external returns (address[] memory);
1449     function subscriberAt(address registrant, uint256 index) external returns (address);
1450     function copyEntriesOf(address registrant, address registrantToCopy) external;
1451     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1452     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1453     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1454     function filteredOperators(address addr) external returns (address[] memory);
1455     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1456     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1457     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1458     function isRegistered(address addr) external returns (bool);
1459     function codeHashOf(address addr) external returns (bytes32);
1460 }
1461 
1462 // File: filterer/OperatorFilterer.sol
1463 
1464 
1465 pragma solidity ^0.8.17;
1466 
1467 
1468 /**
1469  * @title  OperatorFilterer
1470  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1471  *         registrant's entries in the OperatorFilterRegistry.
1472  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1473  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1474  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1475  */
1476 abstract contract OperatorFilterer {
1477     error OperatorNotAllowed(address operator);
1478 
1479     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1480         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1481 
1482     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1483         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1484         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1485         // order for the modifier to filter addresses.
1486         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1487             if (subscribe) {
1488                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1489             } else {
1490                 if (subscriptionOrRegistrantToCopy != address(0)) {
1491                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1492                 } else {
1493                     OPERATOR_FILTER_REGISTRY.register(address(this));
1494                 }
1495             }
1496         }
1497     }
1498 
1499     modifier onlyAllowedOperator(address from) virtual {
1500         // Allow spending tokens from addresses with balance
1501         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1502         // from an EOA.
1503         if (from != msg.sender) {
1504             _checkFilterOperator(msg.sender);
1505         }
1506         _;
1507     }
1508 
1509     modifier onlyAllowedOperatorApproval(address operator) virtual {
1510         _checkFilterOperator(operator);
1511         _;
1512     }
1513 
1514     function _checkFilterOperator(address operator) internal view virtual {
1515         // Check registry code length to facilitate testing in environments without a deployed registry.
1516         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1517             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1518                 revert OperatorNotAllowed(operator);
1519             }
1520         }
1521     }
1522 }
1523 
1524 // File: filterer/DefaultOperatorFilterer.sol
1525 
1526 
1527 pragma solidity ^0.8.17;
1528 
1529 
1530 /**
1531  * @title  DefaultOperatorFilterer
1532  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1533  */
1534 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1535     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1536 
1537     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1538 }
1539 // File: @openzeppelin/contracts/utils/Context.sol
1540 
1541 
1542 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1543 
1544 pragma solidity ^0.8.0;
1545 
1546 /**
1547  * @dev Provides information about the current execution context, including the
1548  * sender of the transaction and its data. While these are generally available
1549  * via msg.sender and msg.data, they should not be accessed in such a direct
1550  * manner, since when dealing with meta-transactions the account sending and
1551  * paying for execution may not be the actual sender (as far as an application
1552  * is concerned).
1553  *
1554  * This contract is only required for intermediate, library-like contracts.
1555  */
1556 abstract contract Context {
1557     function _msgSender() internal view virtual returns (address) {
1558         return msg.sender;
1559     }
1560 
1561     function _msgData() internal view virtual returns (bytes calldata) {
1562         return msg.data;
1563     }
1564 }
1565 
1566 // File: @openzeppelin/contracts/access/Ownable.sol
1567 
1568 
1569 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1570 
1571 pragma solidity ^0.8.0;
1572 
1573 
1574 /**
1575  * @dev Contract module which provides a basic access control mechanism, where
1576  * there is an account (an owner) that can be granted exclusive access to
1577  * specific functions.
1578  *
1579  * By default, the owner account will be the one that deploys the contract. This
1580  * can later be changed with {transferOwnership}.
1581  *
1582  * This module is used through inheritance. It will make available the modifier
1583  * `onlyOwner`, which can be applied to your functions to restrict their use to
1584  * the owner.
1585  */
1586 abstract contract Ownable is Context {
1587     address private _owner;
1588 
1589     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1590 
1591     /**
1592      * @dev Initializes the contract setting the deployer as the initial owner.
1593      */
1594     constructor() {
1595         _transferOwnership(_msgSender());
1596     }
1597 
1598     /**
1599      * @dev Throws if called by any account other than the owner.
1600      */
1601     modifier onlyOwner() {
1602         _checkOwner();
1603         _;
1604     }
1605 
1606     /**
1607      * @dev Returns the address of the current owner.
1608      */
1609     function owner() public view virtual returns (address) {
1610         return _owner;
1611     }
1612 
1613     /**
1614      * @dev Throws if the sender is not the owner.
1615      */
1616     function _checkOwner() internal view virtual {
1617         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1618     }
1619 
1620     /**
1621      * @dev Leaves the contract without owner. It will not be possible to call
1622      * `onlyOwner` functions anymore. Can only be called by the current owner.
1623      *
1624      * NOTE: Renouncing ownership will leave the contract without an owner,
1625      * thereby removing any functionality that is only available to the owner.
1626      */
1627     function renounceOwnership() public virtual onlyOwner {
1628         _transferOwnership(address(0));
1629     }
1630 
1631     /**
1632      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1633      * Can only be called by the current owner.
1634      */
1635     function transferOwnership(address newOwner) public virtual onlyOwner {
1636         require(newOwner != address(0), "Ownable: new owner is the zero address");
1637         _transferOwnership(newOwner);
1638     }
1639 
1640     /**
1641      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1642      * Internal function without access restriction.
1643      */
1644     function _transferOwnership(address newOwner) internal virtual {
1645         address oldOwner = _owner;
1646         _owner = newOwner;
1647         emit OwnershipTransferred(oldOwner, newOwner);
1648     }
1649 }
1650 
1651 
1652 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1653 
1654 
1655 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1656 
1657 pragma solidity ^0.8.0;
1658 
1659 /**
1660  * @dev Interface of the ERC165 standard, as defined in the
1661  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1662  *
1663  * Implementers can declare support of contract interfaces, which can then be
1664  * queried by others ({ERC165Checker}).
1665  *
1666  * For an implementation, see {ERC165}.
1667  */
1668 interface IERC165 {
1669     /**
1670      * @dev Returns true if this contract implements the interface defined by
1671      * `interfaceId`. See the corresponding
1672      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1673      * to learn more about how these ids are created.
1674      *
1675      * This function call must use less than 30 000 gas.
1676      */
1677     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1678 }
1679 
1680 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1681 
1682 
1683 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1684 
1685 pragma solidity ^0.8.0;
1686 
1687 
1688 /**
1689  * @dev Implementation of the {IERC165} interface.
1690  *
1691  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1692  * for the additional interface id that will be supported. For example:
1693  *
1694  * ```solidity
1695  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1696  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1697  * }
1698  * ```
1699  *
1700  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1701  */
1702 abstract contract ERC165 is IERC165 {
1703     /**
1704      * @dev See {IERC165-supportsInterface}.
1705      */
1706     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1707         return interfaceId == type(IERC165).interfaceId;
1708     }
1709 }
1710 
1711 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1712 
1713 
1714 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1715 
1716 pragma solidity ^0.8.0;
1717 
1718 
1719 /**
1720  * @dev Interface for the NFT Royalty Standard.
1721  *
1722  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1723  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1724  *
1725  * _Available since v4.5._
1726  */
1727 interface IERC2981 is IERC165 {
1728     /**
1729      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1730      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1731      */
1732     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1733         external
1734         view
1735         returns (address receiver, uint256 royaltyAmount);
1736 }
1737 
1738 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1739 
1740 
1741 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1742 
1743 pragma solidity ^0.8.0;
1744 
1745 
1746 
1747 /**
1748  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1749  *
1750  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1751  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1752  *
1753  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1754  * fee is specified in basis points by default.
1755  *
1756  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1757  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1758  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1759  *
1760  * _Available since v4.5._
1761  */
1762 abstract contract ERC2981 is IERC2981, ERC165 {
1763     struct RoyaltyInfo {
1764         address receiver;
1765         uint96 royaltyFraction;
1766     }
1767 
1768     RoyaltyInfo private _defaultRoyaltyInfo;
1769     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1770 
1771     /**
1772      * @dev See {IERC165-supportsInterface}.
1773      */
1774     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1775         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1776     }
1777 
1778     /**
1779      * @inheritdoc IERC2981
1780      */
1781     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1782         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1783 
1784         if (royalty.receiver == address(0)) {
1785             royalty = _defaultRoyaltyInfo;
1786         }
1787 
1788         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1789 
1790         return (royalty.receiver, royaltyAmount);
1791     }
1792 
1793     /**
1794      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1795      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1796      * override.
1797      */
1798     function _feeDenominator() internal pure virtual returns (uint96) {
1799         return 10000;
1800     }
1801 
1802     /**
1803      * @dev Sets the royalty information that all ids in this contract will default to.
1804      *
1805      * Requirements:
1806      *
1807      * - `receiver` cannot be the zero address.
1808      * - `feeNumerator` cannot be greater than the fee denominator.
1809      */
1810     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1811         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1812         require(receiver != address(0), "ERC2981: invalid receiver");
1813 
1814         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1815     }
1816 
1817     /**
1818      * @dev Removes default royalty information.
1819      */
1820     function _deleteDefaultRoyalty() internal virtual {
1821         delete _defaultRoyaltyInfo;
1822     }
1823 
1824     /**
1825      * @dev Sets the royalty information for a specific token id, overriding the global default.
1826      *
1827      * Requirements:
1828      *
1829      * - `receiver` cannot be the zero address.
1830      * - `feeNumerator` cannot be greater than the fee denominator.
1831      */
1832     function _setTokenRoyalty(
1833         uint256 tokenId,
1834         address receiver,
1835         uint96 feeNumerator
1836     ) internal virtual {
1837         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1838         require(receiver != address(0), "ERC2981: Invalid parameters");
1839 
1840         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1841     }
1842 
1843     /**
1844      * @dev Resets royalty information for the token id back to the global default.
1845      */
1846     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1847         delete _tokenRoyaltyInfo[tokenId];
1848     }
1849 }
1850 
1851 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1852 
1853 
1854 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1855 
1856 pragma solidity ^0.8.0;
1857 
1858 /**
1859  * @dev These functions deal with verification of Merkle Tree proofs.
1860  *
1861  * The tree and the proofs can be generated using our
1862  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1863  * You will find a quickstart guide in the readme.
1864  *
1865  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1866  * hashing, or use a hash function other than keccak256 for hashing leaves.
1867  * This is because the concatenation of a sorted pair of internal nodes in
1868  * the merkle tree could be reinterpreted as a leaf value.
1869  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1870  * against this attack out of the box.
1871  */
1872 library MerkleProof {
1873     /**
1874      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1875      * defined by `root`. For this, a `proof` must be provided, containing
1876      * sibling hashes on the branch from the leaf to the root of the tree. Each
1877      * pair of leaves and each pair of pre-images are assumed to be sorted.
1878      */
1879     function verify(
1880         bytes32[] memory proof,
1881         bytes32 root,
1882         bytes32 leaf
1883     ) internal pure returns (bool) {
1884         return processProof(proof, leaf) == root;
1885     }
1886 
1887     /**
1888      * @dev Calldata version of {verify}
1889      *
1890      * _Available since v4.7._
1891      */
1892     function verifyCalldata(
1893         bytes32[] calldata proof,
1894         bytes32 root,
1895         bytes32 leaf
1896     ) internal pure returns (bool) {
1897         return processProofCalldata(proof, leaf) == root;
1898     }
1899 
1900     /**
1901      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1902      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1903      * hash matches the root of the tree. When processing the proof, the pairs
1904      * of leafs & pre-images are assumed to be sorted.
1905      *
1906      * _Available since v4.4._
1907      */
1908     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1909         bytes32 computedHash = leaf;
1910         for (uint256 i = 0; i < proof.length; i++) {
1911             computedHash = _hashPair(computedHash, proof[i]);
1912         }
1913         return computedHash;
1914     }
1915 
1916     /**
1917      * @dev Calldata version of {processProof}
1918      *
1919      * _Available since v4.7._
1920      */
1921     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1922         bytes32 computedHash = leaf;
1923         for (uint256 i = 0; i < proof.length; i++) {
1924             computedHash = _hashPair(computedHash, proof[i]);
1925         }
1926         return computedHash;
1927     }
1928 
1929     /**
1930      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1931      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1932      *
1933      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1934      *
1935      * _Available since v4.7._
1936      */
1937     function multiProofVerify(
1938         bytes32[] memory proof,
1939         bool[] memory proofFlags,
1940         bytes32 root,
1941         bytes32[] memory leaves
1942     ) internal pure returns (bool) {
1943         return processMultiProof(proof, proofFlags, leaves) == root;
1944     }
1945 
1946     /**
1947      * @dev Calldata version of {multiProofVerify}
1948      *
1949      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1950      *
1951      * _Available since v4.7._
1952      */
1953     function multiProofVerifyCalldata(
1954         bytes32[] calldata proof,
1955         bool[] calldata proofFlags,
1956         bytes32 root,
1957         bytes32[] memory leaves
1958     ) internal pure returns (bool) {
1959         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1960     }
1961 
1962     /**
1963      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1964      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1965      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1966      * respectively.
1967      *
1968      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1969      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1970      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1971      *
1972      * _Available since v4.7._
1973      */
1974     function processMultiProof(
1975         bytes32[] memory proof,
1976         bool[] memory proofFlags,
1977         bytes32[] memory leaves
1978     ) internal pure returns (bytes32 merkleRoot) {
1979         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1980         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1981         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1982         // the merkle tree.
1983         uint256 leavesLen = leaves.length;
1984         uint256 totalHashes = proofFlags.length;
1985 
1986         // Check proof validity.
1987         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1988 
1989         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1990         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1991         bytes32[] memory hashes = new bytes32[](totalHashes);
1992         uint256 leafPos = 0;
1993         uint256 hashPos = 0;
1994         uint256 proofPos = 0;
1995         // At each step, we compute the next hash using two values:
1996         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1997         //   get the next hash.
1998         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1999         //   `proof` array.
2000         for (uint256 i = 0; i < totalHashes; i++) {
2001             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2002             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2003             hashes[i] = _hashPair(a, b);
2004         }
2005 
2006         if (totalHashes > 0) {
2007             return hashes[totalHashes - 1];
2008         } else if (leavesLen > 0) {
2009             return leaves[0];
2010         } else {
2011             return proof[0];
2012         }
2013     }
2014 
2015     /**
2016      * @dev Calldata version of {processMultiProof}.
2017      *
2018      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2019      *
2020      * _Available since v4.7._
2021      */
2022     function processMultiProofCalldata(
2023         bytes32[] calldata proof,
2024         bool[] calldata proofFlags,
2025         bytes32[] memory leaves
2026     ) internal pure returns (bytes32 merkleRoot) {
2027         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2028         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2029         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2030         // the merkle tree.
2031         uint256 leavesLen = leaves.length;
2032         uint256 totalHashes = proofFlags.length;
2033 
2034         // Check proof validity.
2035         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2036 
2037         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2038         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2039         bytes32[] memory hashes = new bytes32[](totalHashes);
2040         uint256 leafPos = 0;
2041         uint256 hashPos = 0;
2042         uint256 proofPos = 0;
2043         // At each step, we compute the next hash using two values:
2044         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2045         //   get the next hash.
2046         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2047         //   `proof` array.
2048         for (uint256 i = 0; i < totalHashes; i++) {
2049             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2050             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2051             hashes[i] = _hashPair(a, b);
2052         }
2053 
2054         if (totalHashes > 0) {
2055             return hashes[totalHashes - 1];
2056         } else if (leavesLen > 0) {
2057             return leaves[0];
2058         } else {
2059             return proof[0];
2060         }
2061     }
2062 
2063     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2064         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2065     }
2066 
2067     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2068         /// @solidity memory-safe-assembly
2069         assembly {
2070             mstore(0x00, a)
2071             mstore(0x20, b)
2072             value := keccak256(0x00, 0x40)
2073         }
2074     }
2075 }
2076 
2077 // File: AcidBurn.sol
2078 
2079 
2080 pragma solidity 0.8.17;
2081 
2082 /// @author Viv_0002
2083 
2084 contract AcidBurn is ERC721ABurnable, ERC2981, Ownable, DefaultOperatorFilterer{
2085 
2086     enum MintState {
2087         PAUSED,
2088         FREECLAIM,
2089         ALLOWLIST,
2090         PUBLIC,
2091         ENDED
2092     }
2093     
2094     MintState public state = MintState.PAUSED;
2095 
2096     uint256 public mintcost = 0.25 ether;
2097     uint256 public maxSupply = 2800;
2098     uint256 public publicMax = 3;
2099     bytes32 public whitelistMerkleRoot;
2100     string public tokenUriBase = "http://metadata.mintfud.com:3333/acidburn/";
2101     bool public burnEnabled = false;
2102     address public payee;
2103 
2104     constructor() ERC721A("AcidBurn", "AcidBurn") {
2105              _setDefaultRoyalty(owner(), 500);
2106              payee = owner();
2107     }
2108 
2109     // OVERRIDES
2110     function _startTokenId() internal view virtual override returns (uint256) {
2111         return 0;
2112     }
2113 
2114     // MODIFIERS
2115     modifier mintCompliance(uint256 _mintAmount) {
2116         require(
2117             _mintAmount > 0,"Invalid mint amount");
2118         
2119         require(
2120             totalSupply() + _mintAmount <= maxSupply,
2121             "Max supply exceeded"
2122         );
2123         _;
2124     }
2125 
2126     // MERKLE TREE
2127     function _verify(bytes32 leaf, bytes32[] memory proof)
2128         internal
2129         view
2130         returns (bool)
2131     {
2132         return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
2133     }
2134 
2135     function _leaf(address account, uint256 maxMint)
2136         internal
2137         pure
2138         returns (bytes32)
2139     {
2140         return keccak256(bytes.concat(keccak256(abi.encode(account, maxMint))));
2141     }
2142 
2143     // MINTING FUNCTIONS
2144 
2145     function freeclaim(
2146         uint256 amount,
2147         uint256 maxMint,
2148         bytes32[] calldata proof
2149         ) public mintCompliance(amount) {
2150             require(state == MintState.FREECLAIM, "Free Claim period not open");
2151             require(_verify(_leaf(msg.sender, maxMint), proof), "Invalid proof");
2152             require(numberMinted(msg.sender) + amount <= maxMint,"Exceeds allowed number of mints");
2153 
2154             _safeMint(msg.sender, amount);
2155         }
2156 
2157     function ALMint(
2158         uint256 amount,
2159         uint256 maxMint,
2160         bytes32[] calldata proof
2161         ) public payable mintCompliance(amount) {
2162   
2163             require(state == MintState.ALLOWLIST , "AllowList mint is not available right now");
2164             require(_verify(_leaf(msg.sender, maxMint), proof), "Invalid proof");
2165             require(msg.value >= mintcost * amount, "Insufficient funds");
2166             require(numberMinted(msg.sender) + amount <= maxMint,"Exceeds allowed number of mints");
2167 
2168             _safeMint(msg.sender, amount);
2169     }
2170 
2171     function mint(uint256 amount) public payable mintCompliance(amount) {
2172         require(state == MintState.PUBLIC, "Public mint is not available yet");
2173         require (amount <= publicMax, "Too many mints per transaction requested");
2174         require(msg.value >= mintcost * amount, "Insufficient funds");
2175 
2176         _safeMint(msg.sender, amount);
2177     }
2178 
2179     function mintForAddress(uint256 amount, address _receiver)
2180         public
2181         onlyOwner
2182     {
2183         require(totalSupply() + amount <= maxSupply, "Max supply exceeded");
2184         _safeMint(_receiver, amount);
2185     }
2186 
2187     // GETTERS
2188     function numberMinted(address _minter) public view returns (uint256) {
2189         return _numberMinted(_minter);
2190     }
2191 
2192     function numberBurned(address _minter) public view returns (uint256) {
2193         return _numberBurned(_minter);
2194     }
2195 
2196     function tokenURI(
2197         uint256 tokenId
2198     ) public view override(ERC721A, IERC721A) returns (string memory) {
2199         return string(abi.encodePacked(tokenUriBase, _toString(tokenId), ".json"));
2200     }
2201 
2202     function walletOfOwner(address _owner)
2203         public
2204         view
2205         returns (uint256[] memory)
2206     {
2207         uint256 ownerTokenCount = balanceOf(_owner);
2208         uint256[] memory ownerTokens = new uint256[](ownerTokenCount);
2209         uint256 ownerTokenIdx = 0;
2210         for (
2211             uint256 tokenIdx = _startTokenId();
2212             tokenIdx < _totalMinted();
2213             tokenIdx++
2214         ) {
2215             if (_exists(tokenIdx)){
2216             if (ownerOf(tokenIdx) == _owner) {
2217                 ownerTokens[ownerTokenIdx] = tokenIdx;
2218                 ownerTokenIdx++;
2219             }}
2220         }
2221         return ownerTokens;
2222     }
2223 
2224     function getBurnCounter() public view returns (uint256) {
2225         return _totalBurned();
2226     }
2227 
2228     function getTotalMinted() public view returns (uint256) {
2229         return _totalMinted();
2230     }
2231 
2232     // SETTERS
2233 
2234     function setState(MintState _state) public onlyOwner {
2235         state = _state;
2236     }
2237 
2238     function setCost(uint256 _newcost) public onlyOwner {
2239         mintcost = _newcost;
2240     }
2241 
2242     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2243         maxSupply = _maxSupply;
2244     }
2245 
2246     function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot)
2247         external
2248         onlyOwner
2249     {
2250         whitelistMerkleRoot = _whitelistMerkleRoot;
2251     }
2252 
2253     function setTokenURI(string memory newUriBase) external onlyOwner {
2254         tokenUriBase = newUriBase;
2255     }
2256 
2257     function setPublicMax(uint256 _newmax) public onlyOwner {
2258         publicMax = _newmax;
2259     }
2260 
2261     function enableBurn(bool _burn) public onlyOwner {
2262         burnEnabled = _burn;
2263     }
2264     
2265     function setPayee(address _payee) public onlyOwner {
2266         payee = _payee;
2267     }
2268     
2269     // 2981
2270 
2271     function setDefaultRoyalty(address receiver, uint96 feeNumerator)
2272     external
2273     onlyOwner
2274     {
2275         _setDefaultRoyalty(receiver, feeNumerator);
2276     }
2277 
2278    function supportsInterface(bytes4 interfaceId)
2279     public
2280     view
2281     override(ERC721A, ERC2981, IERC721A)
2282     returns (bool)
2283      {
2284         return super.supportsInterface(interfaceId);
2285     }   
2286 
2287 
2288    // OS
2289 
2290    function setApprovalForAll(address operator, bool approved) public override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
2291         super.setApprovalForAll(operator, approved);
2292     }
2293 
2294     function approve(address operator, uint256 tokenId) public payable override(ERC721A, IERC721A) onlyAllowedOperatorApproval(operator) {
2295         super.approve(operator, tokenId);
2296     }
2297 
2298     function transferFrom(address from, address to, uint256 tokenId) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2299         super.transferFrom(from, to, tokenId);
2300     }
2301 
2302     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override(ERC721A, IERC721A) onlyAllowedOperator(from) {
2303         super.safeTransferFrom(from, to, tokenId);
2304     }
2305 
2306     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2307         public
2308         payable
2309         override(ERC721A, IERC721A)
2310         onlyAllowedOperator(from)
2311     {
2312         super.safeTransferFrom(from, to, tokenId, data);
2313     }
2314 
2315     // WITHDRAW
2316 
2317     function withdraw() public onlyOwner {
2318         uint256 contractBalance = address(this).balance;
2319         bool success = true;
2320 
2321         (success, ) = payable(payee).call{
2322             value: contractBalance}("");
2323         require(success, "Transfer failed");
2324     }
2325 
2326     // BURN
2327 
2328     function burn(uint256 tokenId) public virtual override {
2329         require(burnEnabled!=false, "Burn is not enabled");
2330         _burn(tokenId, true);
2331     }
2332 
2333     function bulkburn(uint256[] calldata tokenIDs) public virtual {
2334         require(burnEnabled!=false, "Burn is not enabled");
2335         for (uint i = 0; i < tokenIDs.length; i++) {
2336             burn(tokenIDs[i]);
2337         }
2338     }
2339 
2340 }