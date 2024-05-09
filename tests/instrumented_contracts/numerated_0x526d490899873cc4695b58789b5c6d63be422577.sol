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
1379 // File: @openzeppelin/contracts/utils/math/Math.sol
1380 
1381 
1382 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1383 
1384 pragma solidity ^0.8.0;
1385 
1386 /**
1387  * @dev Standard math utilities missing in the Solidity language.
1388  */
1389 library Math {
1390     enum Rounding {
1391         Down, // Toward negative infinity
1392         Up, // Toward infinity
1393         Zero // Toward zero
1394     }
1395 
1396     /**
1397      * @dev Returns the largest of two numbers.
1398      */
1399     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1400         return a > b ? a : b;
1401     }
1402 
1403     /**
1404      * @dev Returns the smallest of two numbers.
1405      */
1406     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1407         return a < b ? a : b;
1408     }
1409 
1410     /**
1411      * @dev Returns the average of two numbers. The result is rounded towards
1412      * zero.
1413      */
1414     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1415         // (a + b) / 2 can overflow.
1416         return (a & b) + (a ^ b) / 2;
1417     }
1418 
1419     /**
1420      * @dev Returns the ceiling of the division of two numbers.
1421      *
1422      * This differs from standard division with `/` in that it rounds up instead
1423      * of rounding down.
1424      */
1425     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1426         // (a + b - 1) / b can overflow on addition, so we distribute.
1427         return a == 0 ? 0 : (a - 1) / b + 1;
1428     }
1429 
1430     /**
1431      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1432      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1433      * with further edits by Uniswap Labs also under MIT license.
1434      */
1435     function mulDiv(
1436         uint256 x,
1437         uint256 y,
1438         uint256 denominator
1439     ) internal pure returns (uint256 result) {
1440         unchecked {
1441             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1442             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1443             // variables such that product = prod1 * 2^256 + prod0.
1444             uint256 prod0; // Least significant 256 bits of the product
1445             uint256 prod1; // Most significant 256 bits of the product
1446             assembly {
1447                 let mm := mulmod(x, y, not(0))
1448                 prod0 := mul(x, y)
1449                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1450             }
1451 
1452             // Handle non-overflow cases, 256 by 256 division.
1453             if (prod1 == 0) {
1454                 return prod0 / denominator;
1455             }
1456 
1457             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1458             require(denominator > prod1);
1459 
1460             ///////////////////////////////////////////////
1461             // 512 by 256 division.
1462             ///////////////////////////////////////////////
1463 
1464             // Make division exact by subtracting the remainder from [prod1 prod0].
1465             uint256 remainder;
1466             assembly {
1467                 // Compute remainder using mulmod.
1468                 remainder := mulmod(x, y, denominator)
1469 
1470                 // Subtract 256 bit number from 512 bit number.
1471                 prod1 := sub(prod1, gt(remainder, prod0))
1472                 prod0 := sub(prod0, remainder)
1473             }
1474 
1475             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1476             // See https://cs.stackexchange.com/q/138556/92363.
1477 
1478             // Does not overflow because the denominator cannot be zero at this stage in the function.
1479             uint256 twos = denominator & (~denominator + 1);
1480             assembly {
1481                 // Divide denominator by twos.
1482                 denominator := div(denominator, twos)
1483 
1484                 // Divide [prod1 prod0] by twos.
1485                 prod0 := div(prod0, twos)
1486 
1487                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1488                 twos := add(div(sub(0, twos), twos), 1)
1489             }
1490 
1491             // Shift in bits from prod1 into prod0.
1492             prod0 |= prod1 * twos;
1493 
1494             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1495             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1496             // four bits. That is, denominator * inv = 1 mod 2^4.
1497             uint256 inverse = (3 * denominator) ^ 2;
1498 
1499             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1500             // in modular arithmetic, doubling the correct bits in each step.
1501             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1502             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1503             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1504             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1505             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1506             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1507 
1508             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1509             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1510             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1511             // is no longer required.
1512             result = prod0 * inverse;
1513             return result;
1514         }
1515     }
1516 
1517     /**
1518      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1519      */
1520     function mulDiv(
1521         uint256 x,
1522         uint256 y,
1523         uint256 denominator,
1524         Rounding rounding
1525     ) internal pure returns (uint256) {
1526         uint256 result = mulDiv(x, y, denominator);
1527         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1528             result += 1;
1529         }
1530         return result;
1531     }
1532 
1533     /**
1534      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1535      *
1536      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1537      */
1538     function sqrt(uint256 a) internal pure returns (uint256) {
1539         if (a == 0) {
1540             return 0;
1541         }
1542 
1543         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1544         //
1545         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1546         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1547         //
1548         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1549         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1550         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1551         //
1552         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1553         uint256 result = 1 << (log2(a) >> 1);
1554 
1555         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1556         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1557         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1558         // into the expected uint128 result.
1559         unchecked {
1560             result = (result + a / result) >> 1;
1561             result = (result + a / result) >> 1;
1562             result = (result + a / result) >> 1;
1563             result = (result + a / result) >> 1;
1564             result = (result + a / result) >> 1;
1565             result = (result + a / result) >> 1;
1566             result = (result + a / result) >> 1;
1567             return min(result, a / result);
1568         }
1569     }
1570 
1571     /**
1572      * @notice Calculates sqrt(a), following the selected rounding direction.
1573      */
1574     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1575         unchecked {
1576             uint256 result = sqrt(a);
1577             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1578         }
1579     }
1580 
1581     /**
1582      * @dev Return the log in base 2, rounded down, of a positive value.
1583      * Returns 0 if given 0.
1584      */
1585     function log2(uint256 value) internal pure returns (uint256) {
1586         uint256 result = 0;
1587         unchecked {
1588             if (value >> 128 > 0) {
1589                 value >>= 128;
1590                 result += 128;
1591             }
1592             if (value >> 64 > 0) {
1593                 value >>= 64;
1594                 result += 64;
1595             }
1596             if (value >> 32 > 0) {
1597                 value >>= 32;
1598                 result += 32;
1599             }
1600             if (value >> 16 > 0) {
1601                 value >>= 16;
1602                 result += 16;
1603             }
1604             if (value >> 8 > 0) {
1605                 value >>= 8;
1606                 result += 8;
1607             }
1608             if (value >> 4 > 0) {
1609                 value >>= 4;
1610                 result += 4;
1611             }
1612             if (value >> 2 > 0) {
1613                 value >>= 2;
1614                 result += 2;
1615             }
1616             if (value >> 1 > 0) {
1617                 result += 1;
1618             }
1619         }
1620         return result;
1621     }
1622 
1623     /**
1624      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1625      * Returns 0 if given 0.
1626      */
1627     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1628         unchecked {
1629             uint256 result = log2(value);
1630             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1631         }
1632     }
1633 
1634     /**
1635      * @dev Return the log in base 10, rounded down, of a positive value.
1636      * Returns 0 if given 0.
1637      */
1638     function log10(uint256 value) internal pure returns (uint256) {
1639         uint256 result = 0;
1640         unchecked {
1641             if (value >= 10**64) {
1642                 value /= 10**64;
1643                 result += 64;
1644             }
1645             if (value >= 10**32) {
1646                 value /= 10**32;
1647                 result += 32;
1648             }
1649             if (value >= 10**16) {
1650                 value /= 10**16;
1651                 result += 16;
1652             }
1653             if (value >= 10**8) {
1654                 value /= 10**8;
1655                 result += 8;
1656             }
1657             if (value >= 10**4) {
1658                 value /= 10**4;
1659                 result += 4;
1660             }
1661             if (value >= 10**2) {
1662                 value /= 10**2;
1663                 result += 2;
1664             }
1665             if (value >= 10**1) {
1666                 result += 1;
1667             }
1668         }
1669         return result;
1670     }
1671 
1672     /**
1673      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1674      * Returns 0 if given 0.
1675      */
1676     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1677         unchecked {
1678             uint256 result = log10(value);
1679             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1680         }
1681     }
1682 
1683     /**
1684      * @dev Return the log in base 256, rounded down, of a positive value.
1685      * Returns 0 if given 0.
1686      *
1687      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1688      */
1689     function log256(uint256 value) internal pure returns (uint256) {
1690         uint256 result = 0;
1691         unchecked {
1692             if (value >> 128 > 0) {
1693                 value >>= 128;
1694                 result += 16;
1695             }
1696             if (value >> 64 > 0) {
1697                 value >>= 64;
1698                 result += 8;
1699             }
1700             if (value >> 32 > 0) {
1701                 value >>= 32;
1702                 result += 4;
1703             }
1704             if (value >> 16 > 0) {
1705                 value >>= 16;
1706                 result += 2;
1707             }
1708             if (value >> 8 > 0) {
1709                 result += 1;
1710             }
1711         }
1712         return result;
1713     }
1714 
1715     /**
1716      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1717      * Returns 0 if given 0.
1718      */
1719     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1720         unchecked {
1721             uint256 result = log256(value);
1722             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1723         }
1724     }
1725 }
1726 
1727 // File: @openzeppelin/contracts/utils/Strings.sol
1728 
1729 
1730 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1731 
1732 pragma solidity ^0.8.0;
1733 
1734 
1735 /**
1736  * @dev String operations.
1737  */
1738 library Strings {
1739     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1740     uint8 private constant _ADDRESS_LENGTH = 20;
1741 
1742     /**
1743      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1744      */
1745     function toString(uint256 value) internal pure returns (string memory) {
1746         unchecked {
1747             uint256 length = Math.log10(value) + 1;
1748             string memory buffer = new string(length);
1749             uint256 ptr;
1750             /// @solidity memory-safe-assembly
1751             assembly {
1752                 ptr := add(buffer, add(32, length))
1753             }
1754             while (true) {
1755                 ptr--;
1756                 /// @solidity memory-safe-assembly
1757                 assembly {
1758                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1759                 }
1760                 value /= 10;
1761                 if (value == 0) break;
1762             }
1763             return buffer;
1764         }
1765     }
1766 
1767     /**
1768      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1769      */
1770     function toHexString(uint256 value) internal pure returns (string memory) {
1771         unchecked {
1772             return toHexString(value, Math.log256(value) + 1);
1773         }
1774     }
1775 
1776     /**
1777      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1778      */
1779     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1780         bytes memory buffer = new bytes(2 * length + 2);
1781         buffer[0] = "0";
1782         buffer[1] = "x";
1783         for (uint256 i = 2 * length + 1; i > 1; --i) {
1784             buffer[i] = _SYMBOLS[value & 0xf];
1785             value >>= 4;
1786         }
1787         require(value == 0, "Strings: hex length insufficient");
1788         return string(buffer);
1789     }
1790 
1791     /**
1792      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1793      */
1794     function toHexString(address addr) internal pure returns (string memory) {
1795         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1796     }
1797 }
1798 
1799 // File: @openzeppelin/contracts/utils/Context.sol
1800 
1801 
1802 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1803 
1804 pragma solidity ^0.8.0;
1805 
1806 /**
1807  * @dev Provides information about the current execution context, including the
1808  * sender of the transaction and its data. While these are generally available
1809  * via msg.sender and msg.data, they should not be accessed in such a direct
1810  * manner, since when dealing with meta-transactions the account sending and
1811  * paying for execution may not be the actual sender (as far as an application
1812  * is concerned).
1813  *
1814  * This contract is only required for intermediate, library-like contracts.
1815  */
1816 abstract contract Context {
1817     function _msgSender() internal view virtual returns (address) {
1818         return msg.sender;
1819     }
1820 
1821     function _msgData() internal view virtual returns (bytes calldata) {
1822         return msg.data;
1823     }
1824 }
1825 
1826 // File: @openzeppelin/contracts/access/Ownable.sol
1827 
1828 
1829 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1830 
1831 pragma solidity ^0.8.0;
1832 
1833 
1834 /**
1835  * @dev Contract module which provides a basic access control mechanism, where
1836  * there is an account (an owner) that can be granted exclusive access to
1837  * specific functions.
1838  *
1839  * By default, the owner account will be the one that deploys the contract. This
1840  * can later be changed with {transferOwnership}.
1841  *
1842  * This module is used through inheritance. It will make available the modifier
1843  * `onlyOwner`, which can be applied to your functions to restrict their use to
1844  * the owner.
1845  */
1846 abstract contract Ownable is Context {
1847     address private _owner;
1848 
1849     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1850 
1851     /**
1852      * @dev Initializes the contract setting the deployer as the initial owner.
1853      */
1854     constructor() {
1855         _transferOwnership(_msgSender());
1856     }
1857 
1858     /**
1859      * @dev Throws if called by any account other than the owner.
1860      */
1861     modifier onlyOwner() {
1862         _checkOwner();
1863         _;
1864     }
1865 
1866     /**
1867      * @dev Returns the address of the current owner.
1868      */
1869     function owner() public view virtual returns (address) {
1870         return _owner;
1871     }
1872 
1873     /**
1874      * @dev Throws if the sender is not the owner.
1875      */
1876     function _checkOwner() internal view virtual {
1877         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1878     }
1879 
1880     /**
1881      * @dev Leaves the contract without owner. It will not be possible to call
1882      * `onlyOwner` functions anymore. Can only be called by the current owner.
1883      *
1884      * NOTE: Renouncing ownership will leave the contract without an owner,
1885      * thereby removing any functionality that is only available to the owner.
1886      */
1887     function renounceOwnership() public virtual onlyOwner {
1888         _transferOwnership(address(0));
1889     }
1890 
1891     /**
1892      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1893      * Can only be called by the current owner.
1894      */
1895     function transferOwnership(address newOwner) public virtual onlyOwner {
1896         require(newOwner != address(0), "Ownable: new owner is the zero address");
1897         _transferOwnership(newOwner);
1898     }
1899 
1900     /**
1901      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1902      * Internal function without access restriction.
1903      */
1904     function _transferOwnership(address newOwner) internal virtual {
1905         address oldOwner = _owner;
1906         _owner = newOwner;
1907         emit OwnershipTransferred(oldOwner, newOwner);
1908     }
1909 }
1910 
1911 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1912 
1913 
1914 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1915 
1916 pragma solidity ^0.8.0;
1917 
1918 /**
1919  * @dev These functions deal with verification of Merkle Tree proofs.
1920  *
1921  * The tree and the proofs can be generated using our
1922  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1923  * You will find a quickstart guide in the readme.
1924  *
1925  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1926  * hashing, or use a hash function other than keccak256 for hashing leaves.
1927  * This is because the concatenation of a sorted pair of internal nodes in
1928  * the merkle tree could be reinterpreted as a leaf value.
1929  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1930  * against this attack out of the box.
1931  */
1932 library MerkleProof {
1933     /**
1934      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1935      * defined by `root`. For this, a `proof` must be provided, containing
1936      * sibling hashes on the branch from the leaf to the root of the tree. Each
1937      * pair of leaves and each pair of pre-images are assumed to be sorted.
1938      */
1939     function verify(
1940         bytes32[] memory proof,
1941         bytes32 root,
1942         bytes32 leaf
1943     ) internal pure returns (bool) {
1944         return processProof(proof, leaf) == root;
1945     }
1946 
1947     /**
1948      * @dev Calldata version of {verify}
1949      *
1950      * _Available since v4.7._
1951      */
1952     function verifyCalldata(
1953         bytes32[] calldata proof,
1954         bytes32 root,
1955         bytes32 leaf
1956     ) internal pure returns (bool) {
1957         return processProofCalldata(proof, leaf) == root;
1958     }
1959 
1960     /**
1961      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1962      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1963      * hash matches the root of the tree. When processing the proof, the pairs
1964      * of leafs & pre-images are assumed to be sorted.
1965      *
1966      * _Available since v4.4._
1967      */
1968     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1969         bytes32 computedHash = leaf;
1970         for (uint256 i = 0; i < proof.length; i++) {
1971             computedHash = _hashPair(computedHash, proof[i]);
1972         }
1973         return computedHash;
1974     }
1975 
1976     /**
1977      * @dev Calldata version of {processProof}
1978      *
1979      * _Available since v4.7._
1980      */
1981     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1982         bytes32 computedHash = leaf;
1983         for (uint256 i = 0; i < proof.length; i++) {
1984             computedHash = _hashPair(computedHash, proof[i]);
1985         }
1986         return computedHash;
1987     }
1988 
1989     /**
1990      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1991      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1992      *
1993      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1994      *
1995      * _Available since v4.7._
1996      */
1997     function multiProofVerify(
1998         bytes32[] memory proof,
1999         bool[] memory proofFlags,
2000         bytes32 root,
2001         bytes32[] memory leaves
2002     ) internal pure returns (bool) {
2003         return processMultiProof(proof, proofFlags, leaves) == root;
2004     }
2005 
2006     /**
2007      * @dev Calldata version of {multiProofVerify}
2008      *
2009      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2010      *
2011      * _Available since v4.7._
2012      */
2013     function multiProofVerifyCalldata(
2014         bytes32[] calldata proof,
2015         bool[] calldata proofFlags,
2016         bytes32 root,
2017         bytes32[] memory leaves
2018     ) internal pure returns (bool) {
2019         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2020     }
2021 
2022     /**
2023      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2024      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2025      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2026      * respectively.
2027      *
2028      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2029      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2030      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2031      *
2032      * _Available since v4.7._
2033      */
2034     function processMultiProof(
2035         bytes32[] memory proof,
2036         bool[] memory proofFlags,
2037         bytes32[] memory leaves
2038     ) internal pure returns (bytes32 merkleRoot) {
2039         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2040         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2041         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2042         // the merkle tree.
2043         uint256 leavesLen = leaves.length;
2044         uint256 totalHashes = proofFlags.length;
2045 
2046         // Check proof validity.
2047         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2048 
2049         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2050         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2051         bytes32[] memory hashes = new bytes32[](totalHashes);
2052         uint256 leafPos = 0;
2053         uint256 hashPos = 0;
2054         uint256 proofPos = 0;
2055         // At each step, we compute the next hash using two values:
2056         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2057         //   get the next hash.
2058         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2059         //   `proof` array.
2060         for (uint256 i = 0; i < totalHashes; i++) {
2061             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2062             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2063             hashes[i] = _hashPair(a, b);
2064         }
2065 
2066         if (totalHashes > 0) {
2067             return hashes[totalHashes - 1];
2068         } else if (leavesLen > 0) {
2069             return leaves[0];
2070         } else {
2071             return proof[0];
2072         }
2073     }
2074 
2075     /**
2076      * @dev Calldata version of {processMultiProof}.
2077      *
2078      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2079      *
2080      * _Available since v4.7._
2081      */
2082     function processMultiProofCalldata(
2083         bytes32[] calldata proof,
2084         bool[] calldata proofFlags,
2085         bytes32[] memory leaves
2086     ) internal pure returns (bytes32 merkleRoot) {
2087         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2088         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2089         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2090         // the merkle tree.
2091         uint256 leavesLen = leaves.length;
2092         uint256 totalHashes = proofFlags.length;
2093 
2094         // Check proof validity.
2095         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2096 
2097         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2098         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2099         bytes32[] memory hashes = new bytes32[](totalHashes);
2100         uint256 leafPos = 0;
2101         uint256 hashPos = 0;
2102         uint256 proofPos = 0;
2103         // At each step, we compute the next hash using two values:
2104         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2105         //   get the next hash.
2106         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2107         //   `proof` array.
2108         for (uint256 i = 0; i < totalHashes; i++) {
2109             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2110             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2111             hashes[i] = _hashPair(a, b);
2112         }
2113 
2114         if (totalHashes > 0) {
2115             return hashes[totalHashes - 1];
2116         } else if (leavesLen > 0) {
2117             return leaves[0];
2118         } else {
2119             return proof[0];
2120         }
2121     }
2122 
2123     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2124         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2125     }
2126 
2127     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2128         /// @solidity memory-safe-assembly
2129         assembly {
2130             mstore(0x00, a)
2131             mstore(0x20, b)
2132             value := keccak256(0x00, 0x40)
2133         }
2134     }
2135 }
2136 
2137 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2138 
2139 
2140 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
2141 
2142 pragma solidity ^0.8.0;
2143 
2144 /**
2145  * @dev Contract module that helps prevent reentrant calls to a function.
2146  *
2147  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2148  * available, which can be applied to functions to make sure there are no nested
2149  * (reentrant) calls to them.
2150  *
2151  * Note that because there is a single `nonReentrant` guard, functions marked as
2152  * `nonReentrant` may not call one another. This can be worked around by making
2153  * those functions `private`, and then adding `external` `nonReentrant` entry
2154  * points to them.
2155  *
2156  * TIP: If you would like to learn more about reentrancy and alternative ways
2157  * to protect against it, check out our blog post
2158  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2159  */
2160 abstract contract ReentrancyGuard {
2161     // Booleans are more expensive than uint256 or any type that takes up a full
2162     // word because each write operation emits an extra SLOAD to first read the
2163     // slot's contents, replace the bits taken up by the boolean, and then write
2164     // back. This is the compiler's defense against contract upgrades and
2165     // pointer aliasing, and it cannot be disabled.
2166 
2167     // The values being non-zero value makes deployment a bit more expensive,
2168     // but in exchange the refund on every call to nonReentrant will be lower in
2169     // amount. Since refunds are capped to a percentage of the total
2170     // transaction's gas, it is best to keep them low in cases like this one, to
2171     // increase the likelihood of the full refund coming into effect.
2172     uint256 private constant _NOT_ENTERED = 1;
2173     uint256 private constant _ENTERED = 2;
2174 
2175     uint256 private _status;
2176 
2177     constructor() {
2178         _status = _NOT_ENTERED;
2179     }
2180 
2181     /**
2182      * @dev Prevents a contract from calling itself, directly or indirectly.
2183      * Calling a `nonReentrant` function from another `nonReentrant`
2184      * function is not supported. It is possible to prevent this from happening
2185      * by making the `nonReentrant` function external, and making it call a
2186      * `private` function that does the actual work.
2187      */
2188     modifier nonReentrant() {
2189         _nonReentrantBefore();
2190         _;
2191         _nonReentrantAfter();
2192     }
2193 
2194     function _nonReentrantBefore() private {
2195         // On the first call to nonReentrant, _status will be _NOT_ENTERED
2196         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2197 
2198         // Any calls to nonReentrant after this point will fail
2199         _status = _ENTERED;
2200     }
2201 
2202     function _nonReentrantAfter() private {
2203         // By storing the original value once again, a refund is triggered (see
2204         // https://eips.ethereum.org/EIPS/eip-2200)
2205         _status = _NOT_ENTERED;
2206     }
2207 }
2208 
2209 // File: contracts/main.sol
2210 
2211 
2212 
2213 
2214 
2215 
2216 
2217 
2218 
2219 pragma solidity ^0.8.17;
2220 
2221 contract WayToku is ERC721A, Ownable, ReentrancyGuard {
2222 
2223   using Strings for uint256;
2224 
2225 // ================== Variables Start =======================
2226   
2227   bytes32 public merkleRoot;
2228   
2229   string internal uri;
2230   string public uriExtenstion = ".json";
2231 
2232   string public hiddenMetadataUri = "https://bafybeigax3syxbmmlv4kcthd3abvch5uqlzb2sda2ex4hog67qvfk35wwi.ipfs.nftstorage.link/reveal.json";
2233 
2234   uint256 public price = 0.007 ether;
2235   uint256 public wlprice = 0.005 ether;
2236 
2237   uint256 public supplyLimit = 1234;
2238   uint256 public wlsupplyLimit = 1234;
2239 
2240   uint256 public maxMintAmountPerTx = 2;
2241   uint256 public wlmaxMintAmountPerTx = 2;
2242 
2243   uint256 public maxLimitPerWallet = 2;
2244   uint256 public wlmaxLimitPerWallet = 2;
2245 
2246   bool public whitelistSale = false;
2247   bool public publicSale = false;
2248 
2249   bool public revealed = false;
2250 
2251   bool public burnToggle = false;
2252 
2253   mapping(address => uint256) public wlMintCount;
2254   mapping(address => uint256) public publicMintCount;
2255   mapping(uint256  => address) public tokenIDBurnedByAddress;
2256   mapping(address => uint256) public amountOfTokensBurnedByAddress;
2257 
2258   uint256 public publicMinted;
2259   uint256 public wlMinted;    
2260   uint256 public tokensBurned;
2261 
2262 // ================== Variables End =======================  
2263 
2264 // ================== Constructor Start =======================
2265 
2266   constructor(
2267     string memory _uri
2268   ) ERC721A("WayToku", "WTOKU")  {
2269     seturi(_uri);
2270   }
2271 
2272 // ================== Constructor End =======================
2273 
2274 // ================== Mint Functions Start =======================
2275 
2276   function WLmint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable {
2277 
2278     // Verify wl requirements
2279     require(whitelistSale, 'The WlSale is paused!');
2280     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2281     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
2282 
2283 
2284     // Normal requirements 
2285     require(_mintAmount > 0 && _mintAmount <= wlmaxMintAmountPerTx, 'Invalid mint amount!');
2286     require(totalSupply() + _mintAmount <= wlsupplyLimit, 'Max supply exceeded!');
2287     require(wlMintCount[msg.sender] + _mintAmount <= wlmaxLimitPerWallet, 'Max mint per wallet exceeded!');
2288     require(msg.value >= wlprice * _mintAmount, 'Insufficient funds!');
2289      
2290     // Mint
2291      _safeMint(_msgSender(), _mintAmount);
2292 
2293     // Mapping update 
2294     wlMintCount[msg.sender] += _mintAmount; 
2295     wlMinted += _mintAmount;
2296   }
2297 
2298   function PublicMint(uint256 _mintAmount) public payable {
2299     
2300     // Normal requirements 
2301     require(publicSale, 'The PublicSale is paused!');
2302     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
2303     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
2304     require(publicMintCount[msg.sender] + _mintAmount <= maxLimitPerWallet, 'Max mint per wallet exceeded!');
2305     require(msg.value >= price * _mintAmount, 'Insufficient funds!');
2306      
2307     // Mint
2308      _safeMint(_msgSender(), _mintAmount);
2309 
2310     // Mapping update 
2311     publicMintCount[msg.sender] += _mintAmount;  
2312     publicMinted += _mintAmount;   
2313   }  
2314 
2315   function OwnerMint(uint256 _mintAmount, address _receiver) public onlyOwner {
2316     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
2317     _safeMint(_receiver, _mintAmount);
2318   }
2319 
2320     function MassAirdrop(address[] calldata receivers) public onlyOwner {
2321     for (uint256 i; i < receivers.length; ++i) {
2322       require(totalSupply() + 20 <= supplyLimit, 'Max supply exceeded!');
2323       _mint(receivers[i], 20);
2324     }
2325   }
2326   
2327 
2328 // ================== Mint Functions End =======================  
2329 
2330 // ================== Burn Functions Start ======================= 
2331 
2332  function Burn(uint256 _tokenID) public{
2333    require(burnToggle, "Burn phase not started yet");
2334    require(_msgSender() == ownerOf(_tokenID), "Not the owner!");
2335 
2336    _burn(_tokenID);
2337    tokenIDBurnedByAddress[_tokenID] = _msgSender();
2338    amountOfTokensBurnedByAddress[_msgSender()] += 1;
2339    tokensBurned +=1;
2340  }
2341 // ================== Burn Functions End ======================= 
2342 
2343 
2344 // ================== Set Functions Start =======================
2345 
2346 // reveal
2347   function setRevealed(bool _state) public onlyOwner {
2348     revealed = _state;
2349   }
2350 
2351 // uri
2352   function seturi(string memory _uri) public onlyOwner {
2353     uri = _uri;
2354   }
2355 
2356   function seturiExtenstion(string memory _uriExtenstion) public onlyOwner {
2357     uriExtenstion = _uriExtenstion;
2358   }
2359 
2360   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2361     hiddenMetadataUri = _hiddenMetadataUri;
2362   }
2363 
2364 // sales toggle
2365   function setpublicSale(bool _publicSale) public onlyOwner {
2366     publicSale = _publicSale;
2367   }
2368 
2369   function setwlSale(bool _whitelistSale) public onlyOwner {
2370     whitelistSale = _whitelistSale;
2371   }
2372 
2373 // hash set
2374   function setwlMerkleRootHash(bytes32 _merkleRoot) public onlyOwner {
2375     merkleRoot = _merkleRoot;
2376   }
2377 
2378 // max per tx
2379   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2380     maxMintAmountPerTx = _maxMintAmountPerTx;
2381   }
2382 
2383   function setwlmaxMintAmountPerTx(uint256 _wlmaxMintAmountPerTx) public onlyOwner {
2384     wlmaxMintAmountPerTx = _wlmaxMintAmountPerTx;
2385   }
2386 
2387 // pax per wallet
2388   function setmaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
2389     maxLimitPerWallet = _maxLimitPerWallet;
2390   }
2391 
2392   function setwlmaxLimitPerWallet(uint256 _wlmaxLimitPerWallet) public onlyOwner {
2393     wlmaxLimitPerWallet = _wlmaxLimitPerWallet;
2394   }  
2395 
2396 // price
2397   function setPrice(uint256 _price) public onlyOwner {
2398     price = _price;
2399   }
2400 
2401   function setwlPrice(uint256 _wlprice) public onlyOwner {
2402     wlprice = _wlprice;
2403   }  
2404 
2405 // supply limit
2406   function setsupplyLimit(uint256 _supplyLimit) public onlyOwner {
2407     supplyLimit = _supplyLimit;
2408   }
2409 
2410   function setwlsupplyLimit(uint256 _wlsupplyLimit) public onlyOwner {
2411     wlsupplyLimit = _wlsupplyLimit;
2412   }  
2413 
2414 // burn toggle
2415   function setburnToggle(bool _state) public onlyOwner{
2416     burnToggle = _state;
2417   }  
2418 
2419 // ================== Set Functions End =======================
2420 
2421 // ================== Withdraw Function Start =======================
2422   
2423   function withdraw() public onlyOwner nonReentrant {
2424     //owner withdraw
2425     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2426     require(os);
2427   }
2428 
2429 // ================== Withdraw Function End=======================  
2430 
2431 // ================== Read Functions Start =======================
2432 
2433   function tokensOfOwner(address owner) external view returns (uint256[] memory) {
2434     unchecked {
2435         uint256[] memory a = new uint256[](balanceOf(owner)); 
2436         uint256 end = _nextTokenId();
2437         uint256 tokenIdsIdx;
2438         address currOwnershipAddr;
2439         for (uint256 i; i < end; i++) {
2440             TokenOwnership memory ownership = _ownershipAt(i);
2441             if (ownership.burned) {
2442                 continue;
2443             }
2444             if (ownership.addr != address(0)) {
2445                 currOwnershipAddr = ownership.addr;
2446             }
2447             if (currOwnershipAddr == owner) {
2448                 a[tokenIdsIdx++] = i;
2449             }
2450         }
2451         return a;    
2452     }
2453 }
2454 
2455   function _startTokenId() internal view virtual override returns (uint256) {
2456     return 1;
2457   }
2458 
2459   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2460     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2461 
2462     if (revealed == false) {
2463       return hiddenMetadataUri;
2464     }
2465 
2466     string memory currentBaseURI = _baseURI();
2467     return bytes(currentBaseURI).length > 0
2468         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriExtenstion))
2469         : '';
2470   }
2471 
2472   function _baseURI() internal view virtual override returns (string memory) {
2473     return uri;
2474   }
2475 }