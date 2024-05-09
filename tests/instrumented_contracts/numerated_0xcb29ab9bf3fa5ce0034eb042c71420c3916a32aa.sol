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
1379 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1380 
1381 
1382 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1383 
1384 pragma solidity ^0.8.0;
1385 
1386 /**
1387  * @dev Contract module that helps prevent reentrant calls to a function.
1388  *
1389  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1390  * available, which can be applied to functions to make sure there are no nested
1391  * (reentrant) calls to them.
1392  *
1393  * Note that because there is a single `nonReentrant` guard, functions marked as
1394  * `nonReentrant` may not call one another. This can be worked around by making
1395  * those functions `private`, and then adding `external` `nonReentrant` entry
1396  * points to them.
1397  *
1398  * TIP: If you would like to learn more about reentrancy and alternative ways
1399  * to protect against it, check out our blog post
1400  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1401  */
1402 abstract contract ReentrancyGuard {
1403     // Booleans are more expensive than uint256 or any type that takes up a full
1404     // word because each write operation emits an extra SLOAD to first read the
1405     // slot's contents, replace the bits taken up by the boolean, and then write
1406     // back. This is the compiler's defense against contract upgrades and
1407     // pointer aliasing, and it cannot be disabled.
1408 
1409     // The values being non-zero value makes deployment a bit more expensive,
1410     // but in exchange the refund on every call to nonReentrant will be lower in
1411     // amount. Since refunds are capped to a percentage of the total
1412     // transaction's gas, it is best to keep them low in cases like this one, to
1413     // increase the likelihood of the full refund coming into effect.
1414     uint256 private constant _NOT_ENTERED = 1;
1415     uint256 private constant _ENTERED = 2;
1416 
1417     uint256 private _status;
1418 
1419     constructor() {
1420         _status = _NOT_ENTERED;
1421     }
1422 
1423     /**
1424      * @dev Prevents a contract from calling itself, directly or indirectly.
1425      * Calling a `nonReentrant` function from another `nonReentrant`
1426      * function is not supported. It is possible to prevent this from happening
1427      * by making the `nonReentrant` function external, and making it call a
1428      * `private` function that does the actual work.
1429      */
1430     modifier nonReentrant() {
1431         _nonReentrantBefore();
1432         _;
1433         _nonReentrantAfter();
1434     }
1435 
1436     function _nonReentrantBefore() private {
1437         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1438         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1439 
1440         // Any calls to nonReentrant after this point will fail
1441         _status = _ENTERED;
1442     }
1443 
1444     function _nonReentrantAfter() private {
1445         // By storing the original value once again, a refund is triggered (see
1446         // https://eips.ethereum.org/EIPS/eip-2200)
1447         _status = _NOT_ENTERED;
1448     }
1449 }
1450 
1451 // File: @openzeppelin/contracts/utils/Strings.sol
1452 
1453 
1454 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1455 
1456 pragma solidity ^0.8.0;
1457 
1458 /**
1459  * @dev String operations.
1460  */
1461 library Strings {
1462     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1463     uint8 private constant _ADDRESS_LENGTH = 20;
1464 
1465     /**
1466      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1467      */
1468     function toString(uint256 value) internal pure returns (string memory) {
1469         // Inspired by OraclizeAPI's implementation - MIT licence
1470         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1471 
1472         if (value == 0) {
1473             return "0";
1474         }
1475         uint256 temp = value;
1476         uint256 digits;
1477         while (temp != 0) {
1478             digits++;
1479             temp /= 10;
1480         }
1481         bytes memory buffer = new bytes(digits);
1482         while (value != 0) {
1483             digits -= 1;
1484             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1485             value /= 10;
1486         }
1487         return string(buffer);
1488     }
1489 
1490     /**
1491      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1492      */
1493     function toHexString(uint256 value) internal pure returns (string memory) {
1494         if (value == 0) {
1495             return "0x00";
1496         }
1497         uint256 temp = value;
1498         uint256 length = 0;
1499         while (temp != 0) {
1500             length++;
1501             temp >>= 8;
1502         }
1503         return toHexString(value, length);
1504     }
1505 
1506     /**
1507      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1508      */
1509     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1510         bytes memory buffer = new bytes(2 * length + 2);
1511         buffer[0] = "0";
1512         buffer[1] = "x";
1513         for (uint256 i = 2 * length + 1; i > 1; --i) {
1514             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1515             value >>= 4;
1516         }
1517         require(value == 0, "Strings: hex length insufficient");
1518         return string(buffer);
1519     }
1520 
1521     /**
1522      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1523      */
1524     function toHexString(address addr) internal pure returns (string memory) {
1525         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1526     }
1527 }
1528 
1529 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1530 
1531 
1532 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1533 
1534 pragma solidity ^0.8.0;
1535 
1536 /**
1537  * @dev These functions deal with verification of Merkle Tree proofs.
1538  *
1539  * The proofs can be generated using the JavaScript library
1540  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1541  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1542  *
1543  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1544  *
1545  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1546  * hashing, or use a hash function other than keccak256 for hashing leaves.
1547  * This is because the concatenation of a sorted pair of internal nodes in
1548  * the merkle tree could be reinterpreted as a leaf value.
1549  */
1550 library MerkleProof {
1551     /**
1552      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1553      * defined by `root`. For this, a `proof` must be provided, containing
1554      * sibling hashes on the branch from the leaf to the root of the tree. Each
1555      * pair of leaves and each pair of pre-images are assumed to be sorted.
1556      */
1557     function verify(
1558         bytes32[] memory proof,
1559         bytes32 root,
1560         bytes32 leaf
1561     ) internal pure returns (bool) {
1562         return processProof(proof, leaf) == root;
1563     }
1564 
1565     /**
1566      * @dev Calldata version of {verify}
1567      *
1568      * _Available since v4.7._
1569      */
1570     function verifyCalldata(
1571         bytes32[] calldata proof,
1572         bytes32 root,
1573         bytes32 leaf
1574     ) internal pure returns (bool) {
1575         return processProofCalldata(proof, leaf) == root;
1576     }
1577 
1578     /**
1579      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1580      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1581      * hash matches the root of the tree. When processing the proof, the pairs
1582      * of leafs & pre-images are assumed to be sorted.
1583      *
1584      * _Available since v4.4._
1585      */
1586     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1587         bytes32 computedHash = leaf;
1588         for (uint256 i = 0; i < proof.length; i++) {
1589             computedHash = _hashPair(computedHash, proof[i]);
1590         }
1591         return computedHash;
1592     }
1593 
1594     /**
1595      * @dev Calldata version of {processProof}
1596      *
1597      * _Available since v4.7._
1598      */
1599     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1600         bytes32 computedHash = leaf;
1601         for (uint256 i = 0; i < proof.length; i++) {
1602             computedHash = _hashPair(computedHash, proof[i]);
1603         }
1604         return computedHash;
1605     }
1606 
1607     /**
1608      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1609      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1610      *
1611      * _Available since v4.7._
1612      */
1613     function multiProofVerify(
1614         bytes32[] memory proof,
1615         bool[] memory proofFlags,
1616         bytes32 root,
1617         bytes32[] memory leaves
1618     ) internal pure returns (bool) {
1619         return processMultiProof(proof, proofFlags, leaves) == root;
1620     }
1621 
1622     /**
1623      * @dev Calldata version of {multiProofVerify}
1624      *
1625      * _Available since v4.7._
1626      */
1627     function multiProofVerifyCalldata(
1628         bytes32[] calldata proof,
1629         bool[] calldata proofFlags,
1630         bytes32 root,
1631         bytes32[] memory leaves
1632     ) internal pure returns (bool) {
1633         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1634     }
1635 
1636     /**
1637      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1638      * consuming from one or the other at each step according to the instructions given by
1639      * `proofFlags`.
1640      *
1641      * _Available since v4.7._
1642      */
1643     function processMultiProof(
1644         bytes32[] memory proof,
1645         bool[] memory proofFlags,
1646         bytes32[] memory leaves
1647     ) internal pure returns (bytes32 merkleRoot) {
1648         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1649         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1650         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1651         // the merkle tree.
1652         uint256 leavesLen = leaves.length;
1653         uint256 totalHashes = proofFlags.length;
1654 
1655         // Check proof validity.
1656         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1657 
1658         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1659         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1660         bytes32[] memory hashes = new bytes32[](totalHashes);
1661         uint256 leafPos = 0;
1662         uint256 hashPos = 0;
1663         uint256 proofPos = 0;
1664         // At each step, we compute the next hash using two values:
1665         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1666         //   get the next hash.
1667         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1668         //   `proof` array.
1669         for (uint256 i = 0; i < totalHashes; i++) {
1670             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1671             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1672             hashes[i] = _hashPair(a, b);
1673         }
1674 
1675         if (totalHashes > 0) {
1676             return hashes[totalHashes - 1];
1677         } else if (leavesLen > 0) {
1678             return leaves[0];
1679         } else {
1680             return proof[0];
1681         }
1682     }
1683 
1684     /**
1685      * @dev Calldata version of {processMultiProof}
1686      *
1687      * _Available since v4.7._
1688      */
1689     function processMultiProofCalldata(
1690         bytes32[] calldata proof,
1691         bool[] calldata proofFlags,
1692         bytes32[] memory leaves
1693     ) internal pure returns (bytes32 merkleRoot) {
1694         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1695         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1696         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1697         // the merkle tree.
1698         uint256 leavesLen = leaves.length;
1699         uint256 totalHashes = proofFlags.length;
1700 
1701         // Check proof validity.
1702         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1703 
1704         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1705         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1706         bytes32[] memory hashes = new bytes32[](totalHashes);
1707         uint256 leafPos = 0;
1708         uint256 hashPos = 0;
1709         uint256 proofPos = 0;
1710         // At each step, we compute the next hash using two values:
1711         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1712         //   get the next hash.
1713         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1714         //   `proof` array.
1715         for (uint256 i = 0; i < totalHashes; i++) {
1716             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1717             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1718             hashes[i] = _hashPair(a, b);
1719         }
1720 
1721         if (totalHashes > 0) {
1722             return hashes[totalHashes - 1];
1723         } else if (leavesLen > 0) {
1724             return leaves[0];
1725         } else {
1726             return proof[0];
1727         }
1728     }
1729 
1730     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1731         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1732     }
1733 
1734     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1735         /// @solidity memory-safe-assembly
1736         assembly {
1737             mstore(0x00, a)
1738             mstore(0x20, b)
1739             value := keccak256(0x00, 0x40)
1740         }
1741     }
1742 }
1743 
1744 // File: @openzeppelin/contracts/utils/Context.sol
1745 
1746 
1747 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1748 
1749 pragma solidity ^0.8.0;
1750 
1751 /**
1752  * @dev Provides information about the current execution context, including the
1753  * sender of the transaction and its data. While these are generally available
1754  * via msg.sender and msg.data, they should not be accessed in such a direct
1755  * manner, since when dealing with meta-transactions the account sending and
1756  * paying for execution may not be the actual sender (as far as an application
1757  * is concerned).
1758  *
1759  * This contract is only required for intermediate, library-like contracts.
1760  */
1761 abstract contract Context {
1762     function _msgSender() internal view virtual returns (address) {
1763         return msg.sender;
1764     }
1765 
1766     function _msgData() internal view virtual returns (bytes calldata) {
1767         return msg.data;
1768     }
1769 }
1770 
1771 // File: @openzeppelin/contracts/access/Ownable.sol
1772 
1773 
1774 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1775 
1776 pragma solidity ^0.8.0;
1777 
1778 
1779 /**
1780  * @dev Contract module which provides a basic access control mechanism, where
1781  * there is an account (an owner) that can be granted exclusive access to
1782  * specific functions.
1783  *
1784  * By default, the owner account will be the one that deploys the contract. This
1785  * can later be changed with {transferOwnership}.
1786  *
1787  * This module is used through inheritance. It will make available the modifier
1788  * `onlyOwner`, which can be applied to your functions to restrict their use to
1789  * the owner.
1790  */
1791 abstract contract Ownable is Context {
1792     address private _owner;
1793 
1794     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1795 
1796     /**
1797      * @dev Initializes the contract setting the deployer as the initial owner.
1798      */
1799     constructor() {
1800         _transferOwnership(_msgSender());
1801     }
1802 
1803     /**
1804      * @dev Throws if called by any account other than the owner.
1805      */
1806     modifier onlyOwner() {
1807         _checkOwner();
1808         _;
1809     }
1810 
1811     /**
1812      * @dev Returns the address of the current owner.
1813      */
1814     function owner() public view virtual returns (address) {
1815         return _owner;
1816     }
1817 
1818     /**
1819      * @dev Throws if the sender is not the owner.
1820      */
1821     function _checkOwner() internal view virtual {
1822         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1823     }
1824 
1825     /**
1826      * @dev Leaves the contract without owner. It will not be possible to call
1827      * `onlyOwner` functions anymore. Can only be called by the current owner.
1828      *
1829      * NOTE: Renouncing ownership will leave the contract without an owner,
1830      * thereby removing any functionality that is only available to the owner.
1831      */
1832     function renounceOwnership() public virtual onlyOwner {
1833         _transferOwnership(address(0));
1834     }
1835 
1836     /**
1837      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1838      * Can only be called by the current owner.
1839      */
1840     function transferOwnership(address newOwner) public virtual onlyOwner {
1841         require(newOwner != address(0), "Ownable: new owner is the zero address");
1842         _transferOwnership(newOwner);
1843     }
1844 
1845     /**
1846      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1847      * Internal function without access restriction.
1848      */
1849     function _transferOwnership(address newOwner) internal virtual {
1850         address oldOwner = _owner;
1851         _owner = newOwner;
1852         emit OwnershipTransferred(oldOwner, newOwner);
1853     }
1854 }
1855 
1856 // File: contracts/cuddlyKids.sol
1857 
1858 
1859 pragma solidity >=0.8.0 <0.9.0;
1860 // ipfs://QmUNNn6iYjDDwX9MM8uKHc8o5ZM2RuNzHm5H84AGGB6nPf/
1861 
1862 
1863 
1864 
1865 
1866 
1867 contract CuddlyCrypto is ERC721A, Ownable, ReentrancyGuard {
1868     using Strings for uint256;
1869 
1870     enum ContractMintState {
1871         PAUSED,
1872         PUBLIC,
1873         WHITELIST,
1874         ALLOWLIST,
1875         WHITELIST_B,
1876         ALLOWLIST_B
1877     }
1878     
1879 
1880     uint256 public maxSupply = 5555;
1881     uint256 public publicSupply = 5555;
1882 
1883     string public uriPrefix = "";
1884     string public hiddenMetadataUri =
1885         "ipfs://QmRtoGVkaRgk4NNy2DP672EV9hKNDiV2GEEFmjJSpwBHmq";
1886 
1887     uint256 public publicCost = 0.02 ether;
1888     uint256 public allowlistCost = 0.016 ether;
1889     uint256 public whitelistCost = 0.016 ether;
1890     constructor() ERC721A("Cuddly kids", "CKS") {}
1891 
1892     function setPublicCost(uint256 _cost) public onlyOwner {
1893         publicCost = _cost;
1894     }
1895 
1896     function setAllowlistCost(uint256 _cost) public onlyOwner {
1897         allowlistCost = _cost;
1898     }
1899 
1900     function setWhitelistCost(uint256 _cost) public onlyOwner {
1901         whitelistCost = _cost;                                                                  
1902     }
1903 
1904 
1905     function _baseURI() internal view virtual override returns (string memory) {
1906         return uriPrefix;
1907     }
1908 
1909     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1910         uriPrefix = _uriPrefix;
1911     }
1912 
1913     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
1914         public
1915         onlyOwner
1916     {
1917         hiddenMetadataUri = _hiddenMetadataUri;
1918     }
1919 
1920     function tokenURI(uint256 _tokenId)
1921         public
1922         view
1923         virtual
1924         override
1925         returns (string memory)
1926     {
1927         require(
1928             _exists(_tokenId),
1929             "ERC721Metadata: URI query for nonexistent token"
1930         );
1931         string memory currentBaseURI = _baseURI();
1932 
1933         return
1934             bytes(currentBaseURI).length > 0
1935                 ? string(
1936                     abi.encodePacked(
1937                         currentBaseURI,
1938                         _tokenId.toString(),
1939                         ".json"
1940                     )
1941                 )
1942                 : hiddenMetadataUri;
1943     }
1944 
1945     modifier mintCompliance(uint256 _mintAmount, uint256 _limit) {
1946         require(
1947             _mintAmount > 0 && _mintAmount <= _limit,
1948             "Invalid mint amount"
1949         );
1950         require(
1951             totalSupply() + _mintAmount <= maxSupply,
1952             "Max supply exceeded"
1953         );
1954         _;
1955     }
1956 
1957     uint256 public publicMintLimit = 3;
1958 
1959     function setPublicMintLimit(uint256 _limit) public onlyOwner {
1960         publicMintLimit = _limit;
1961     }
1962 
1963     mapping(address => uint256) public publicMinted;
1964 
1965     function publicMint(uint256 amount)
1966         public
1967         payable
1968         mintCompliance(amount, publicMintLimit)
1969     {
1970         require(
1971             publicMinted[msg.sender] + amount <= publicMintLimit,
1972             "Can't mint that many"
1973         );
1974         require(state == ContractMintState.PUBLIC, "Public mint is disabled");
1975         require(totalSupply() + amount <= publicSupply, "Can't mint that many");
1976         require(msg.value >= publicCost * amount, "Insufficient funds");
1977         publicMinted[msg.sender] += amount;
1978         _safeMint(msg.sender, amount);
1979     }
1980 
1981     // allowlistMintLimit - section
1982     uint256 public allowlistMintLimit = 3;
1983 
1984     function setAllowlistMintLimit(uint256 _limit) public onlyOwner {
1985         allowlistMintLimit = _limit;
1986     }
1987 
1988     bytes32 private allowlistMerkleRoot =
1989         0xf5fd04e01134135b09451af2bb9438bc6cca789e6037969be43e6b52baadd91d;
1990 
1991     function setAllowlistMerkleRoot(bytes32 _root) public onlyOwner {
1992         allowlistMerkleRoot = _root;
1993     }
1994 
1995     mapping(address => uint256) public allowlistMinted;
1996 
1997     uint256 public whitelistMintLimit = 3;
1998 
1999     function setWhitelistMintLimit(uint256 _limit) public onlyOwner {
2000         whitelistMintLimit = _limit;
2001     }
2002 
2003     bytes32 public whitelistMerkleRoot =
2004         0xd5d0a7d496f2fd3c65af07cbb8fb3a5806c6541f4ef0b95a80eec376a42d4db7;
2005 
2006     function setWhitelistMerkleRoot(bytes32 _root) public onlyOwner {
2007         whitelistMerkleRoot = _root;
2008     }
2009 
2010     mapping(address => uint256) public whitelistMinted;
2011 
2012  
2013     function mintForAddress(uint256 amount, address _reciver) public onlyOwner {
2014         require(totalSupply() + amount <= maxSupply, "Max supply exceeded");
2015         _safeMint(_reciver, amount);
2016     }
2017 
2018     function numberMinted(address _mint) public view returns (uint256) {
2019         return _numberMinted(_mint);
2020     }
2021 
2022     function _startTokenId() internal view virtual override returns (uint256) {
2023         return 1;
2024     }
2025 
2026     function walletOfOwner(address _owner)
2027         public
2028         view
2029         returns (uint256[] memory)
2030     {
2031         uint256 ownerTokenCount = balanceOf(_owner);
2032         uint256[] memory ownerTokens = new uint256[](ownerTokenCount);
2033         uint256 ownerTokenIdx = 0;
2034         for (
2035             uint256 tokenIdx = _startTokenId();
2036             tokenIdx <= totalSupply();
2037             tokenIdx++
2038         ) {
2039             if (ownerOf(tokenIdx) == _owner) {
2040                 ownerTokens[ownerTokenIdx] = tokenIdx;
2041                 ownerTokenIdx++;
2042             }
2043         }
2044         return ownerTokens;
2045     }
2046 
2047     ContractMintState public state = ContractMintState.PAUSED;
2048 
2049     function setState(ContractMintState _state) public onlyOwner {
2050         state = _state;
2051     }
2052 
2053     function withdraw() external onlyOwner nonReentrant {
2054         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2055         require(success, "Transfer failed");
2056     }
2057     
2058     function _leaf(address account, uint256 allowance)
2059         internal
2060         pure
2061         returns(bytes32)
2062     {
2063         return keccak256(abi.encodePacked(account, allowance));
2064     }
2065 
2066     function _verify(bytes32 leaf, bytes32[] memory proof, bytes32 root)
2067         internal
2068         pure
2069         returns(bool)
2070     {
2071         return MerkleProof.verify(proof, root, leaf);
2072     }
2073 
2074     function addressTx(uint256 allowance, uint256 num)public view returns(bytes32) {
2075         if(num == 3) {
2076             return keccak256(abi.encodePacked(allowance));
2077         }
2078         if(num == 4) {
2079             return keccak256(abi.encodePacked(msg.sender));
2080         }
2081        return keccak256(abi.encodePacked(msg.sender, allowance));
2082     }   
2083 
2084     function whitelistMerkleMint(
2085         uint256 amount,
2086         uint256 numToken,
2087         bytes32[] memory proof
2088     ) public payable {
2089         require(
2090             state == ContractMintState.WHITELIST,
2091             "whitelist mint disabled"
2092         );
2093         require(
2094             whitelistMinted[msg.sender] + amount <= whitelistMintLimit,
2095             "can't mint that many"
2096         );
2097         require(
2098             msg.sender != address(0),
2099              "address error"
2100         );
2101         bytes32 leaf = _leaf(msg.sender, numToken);
2102         require(
2103             _verify(leaf, proof, whitelistMerkleRoot),
2104             "Verification failed"
2105         );
2106 
2107         whitelistMinted[msg.sender] += amount;
2108         _safeMint(msg.sender, amount);
2109     }
2110 
2111     function allowlistMerkleMint(
2112         uint256 amount,
2113         uint256 numToken,
2114         bytes32[] memory proof
2115     )
2116         public payable
2117     {
2118         require(
2119             state == ContractMintState.ALLOWLIST,
2120             "allowlist mint disabled"
2121         );
2122         require(
2123             allowlistMinted[msg.sender] + amount <= allowlistMintLimit,
2124             "can't mint that many"
2125         );
2126         require(
2127             msg.sender != address(0),
2128              "address error"
2129         );
2130         bytes32 leaf = _leaf(msg.sender, numToken);
2131         require(
2132             _verify(leaf, proof, allowlistMerkleRoot),
2133             "Verification failed"
2134         );
2135 
2136         allowlistMinted[msg.sender] += amount;
2137         _safeMint(msg.sender, amount);
2138     }
2139 
2140     // B
2141     mapping(address => bool) internal isWhitelist;
2142 
2143     function checkWhitelist(address account) public view returns(bool) {
2144         require(state == ContractMintState.WHITELIST_B, "illegal");
2145         require(account != address(0), "address illegal");
2146         return isWhitelist[account];
2147     }
2148 
2149     function mintForWhiteList(uint256 amount)
2150         public
2151         payable
2152         mintCompliance(amount, whitelistMintLimit)
2153     {
2154         require(
2155             state == ContractMintState.WHITELIST_B,
2156             "Whitelist mint is disabled"
2157         );
2158         require(
2159             whitelistMinted[msg.sender] + amount <= whitelistMintLimit,
2160             "Can't mint that many"
2161         );
2162         require(isWhitelist[msg.sender], "Not whitelist");
2163         uint256 mintedNum = whitelistMinted[msg.sender];
2164         uint256 totalPrice;
2165         if (mintedNum > 0) {
2166             totalPrice = whitelistCost * amount;
2167         } else {
2168             totalPrice = whitelistCost * (amount - 1);
2169         }
2170 
2171         require(msg.value >= totalPrice, "value not eq");
2172 
2173         whitelistMinted[msg.sender] += amount;
2174         _safeMint(msg.sender, amount);
2175     }
2176 
2177     function setWhiteList(address[] memory _whitelistMenu)
2178         external
2179         onlyOwner
2180         nonReentrant
2181     {
2182         require(
2183             state == ContractMintState.WHITELIST_B,
2184             "allowlist mint is disabled"
2185         );
2186         uint256 idx = 0;
2187         for (idx; idx < _whitelistMenu.length; idx++) {
2188             if (_whitelistMenu[idx] != address(0)) {
2189                 isWhitelist[_whitelistMenu[idx]] = true;
2190             }
2191         }
2192     }
2193 
2194     mapping(address => bool) internal isAllowlist;
2195 
2196     function checkAllowlist(address account) public view returns(bool) {
2197         require(state == ContractMintState.ALLOWLIST_B, "illegal");
2198         require(account != address(0), "address illegal");
2199         return isAllowlist[account];
2200     }
2201 
2202     function setAllowlist(address[] memory _allowlist)
2203         external
2204         onlyOwner
2205         nonReentrant
2206     {
2207         require(
2208             state == ContractMintState.ALLOWLIST_B,
2209             "allowlist mint is disabled"
2210         );
2211         uint256 idx = 0;
2212         for (idx; idx < _allowlist.length; idx++) {
2213             if (_allowlist[idx] != address(0)) {
2214                 isAllowlist[_allowlist[idx]] = true;
2215             }
2216         }
2217     }
2218 
2219     function mintForAllowlist(uint256 amount)
2220         public
2221         payable
2222         mintCompliance(amount, allowlistMintLimit)
2223     {
2224         require(
2225             state == ContractMintState.ALLOWLIST_B,
2226             "Allowlist muint is disabled"
2227         );
2228         require(
2229             allowlistMinted[msg.sender] + amount <= allowlistMintLimit,
2230             "Can't mint that many"
2231         );
2232         require(isAllowlist[msg.sender], "not in allowlist");
2233         allowlistMinted[msg.sender] += amount;
2234         _safeMint(msg.sender, amount);
2235     }
2236 }