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
1379 // File: @openzeppelin/contracts/utils/Strings.sol
1380 
1381 
1382 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1383 
1384 pragma solidity ^0.8.0;
1385 
1386 /**
1387  * @dev String operations.
1388  */
1389 library Strings {
1390     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1391     uint8 private constant _ADDRESS_LENGTH = 20;
1392 
1393     /**
1394      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1395      */
1396     function toString(uint256 value) internal pure returns (string memory) {
1397         // Inspired by OraclizeAPI's implementation - MIT licence
1398         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1399 
1400         if (value == 0) {
1401             return "0";
1402         }
1403         uint256 temp = value;
1404         uint256 digits;
1405         while (temp != 0) {
1406             digits++;
1407             temp /= 10;
1408         }
1409         bytes memory buffer = new bytes(digits);
1410         while (value != 0) {
1411             digits -= 1;
1412             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1413             value /= 10;
1414         }
1415         return string(buffer);
1416     }
1417 
1418     /**
1419      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1420      */
1421     function toHexString(uint256 value) internal pure returns (string memory) {
1422         if (value == 0) {
1423             return "0x00";
1424         }
1425         uint256 temp = value;
1426         uint256 length = 0;
1427         while (temp != 0) {
1428             length++;
1429             temp >>= 8;
1430         }
1431         return toHexString(value, length);
1432     }
1433 
1434     /**
1435      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1436      */
1437     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1438         bytes memory buffer = new bytes(2 * length + 2);
1439         buffer[0] = "0";
1440         buffer[1] = "x";
1441         for (uint256 i = 2 * length + 1; i > 1; --i) {
1442             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1443             value >>= 4;
1444         }
1445         require(value == 0, "Strings: hex length insufficient");
1446         return string(buffer);
1447     }
1448 
1449     /**
1450      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1451      */
1452     function toHexString(address addr) internal pure returns (string memory) {
1453         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1454     }
1455 }
1456 
1457 // File: @openzeppelin/contracts/utils/Context.sol
1458 
1459 
1460 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1461 
1462 pragma solidity ^0.8.0;
1463 
1464 /**
1465  * @dev Provides information about the current execution context, including the
1466  * sender of the transaction and its data. While these are generally available
1467  * via msg.sender and msg.data, they should not be accessed in such a direct
1468  * manner, since when dealing with meta-transactions the account sending and
1469  * paying for execution may not be the actual sender (as far as an application
1470  * is concerned).
1471  *
1472  * This contract is only required for intermediate, library-like contracts.
1473  */
1474 abstract contract Context {
1475     function _msgSender() internal view virtual returns (address) {
1476         return msg.sender;
1477     }
1478 
1479     function _msgData() internal view virtual returns (bytes calldata) {
1480         return msg.data;
1481     }
1482 }
1483 
1484 // File: @openzeppelin/contracts/access/Ownable.sol
1485 
1486 
1487 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1488 
1489 pragma solidity ^0.8.0;
1490 
1491 
1492 /**
1493  * @dev Contract module which provides a basic access control mechanism, where
1494  * there is an account (an owner) that can be granted exclusive access to
1495  * specific functions.
1496  *
1497  * By default, the owner account will be the one that deploys the contract. This
1498  * can later be changed with {transferOwnership}.
1499  *
1500  * This module is used through inheritance. It will make available the modifier
1501  * `onlyOwner`, which can be applied to your functions to restrict their use to
1502  * the owner.
1503  */
1504 abstract contract Ownable is Context {
1505     address private _owner;
1506 
1507     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1508 
1509     /**
1510      * @dev Initializes the contract setting the deployer as the initial owner.
1511      */
1512     constructor() {
1513         _transferOwnership(_msgSender());
1514     }
1515 
1516     /**
1517      * @dev Throws if called by any account other than the owner.
1518      */
1519     modifier onlyOwner() {
1520         _checkOwner();
1521         _;
1522     }
1523 
1524     /**
1525      * @dev Returns the address of the current owner.
1526      */
1527     function owner() public view virtual returns (address) {
1528         return _owner;
1529     }
1530 
1531     /**
1532      * @dev Throws if the sender is not the owner.
1533      */
1534     function _checkOwner() internal view virtual {
1535         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1536     }
1537 
1538     /**
1539      * @dev Leaves the contract without owner. It will not be possible to call
1540      * `onlyOwner` functions anymore. Can only be called by the current owner.
1541      *
1542      * NOTE: Renouncing ownership will leave the contract without an owner,
1543      * thereby removing any functionality that is only available to the owner.
1544      */
1545     function renounceOwnership() public virtual onlyOwner {
1546         _transferOwnership(address(0));
1547     }
1548 
1549     /**
1550      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1551      * Can only be called by the current owner.
1552      */
1553     function transferOwnership(address newOwner) public virtual onlyOwner {
1554         require(newOwner != address(0), "Ownable: new owner is the zero address");
1555         _transferOwnership(newOwner);
1556     }
1557 
1558     /**
1559      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1560      * Internal function without access restriction.
1561      */
1562     function _transferOwnership(address newOwner) internal virtual {
1563         address oldOwner = _owner;
1564         _owner = newOwner;
1565         emit OwnershipTransferred(oldOwner, newOwner);
1566     }
1567 }
1568 
1569 // File: github/abdullahtilalcodup/nftContracts/maestrosmix.sol
1570 
1571 //SPDX-License-Identifier: GPL-3.0
1572 
1573 pragma solidity >=0.7.0 <0.9.0;
1574 
1575 
1576 
1577 
1578 /// @title Mestro's Mix
1579 /// @author Adam Bawany
1580 contract MaestrosMix is ERC721A, Ownable {
1581 
1582     using Strings for uint256;
1583     
1584     bool public paused = false; 
1585     bool public revealed = false;
1586     bool public onlyWhiteListed = true; //To pause both OG and WL 
1587     bool public onlyWhiteListedOG = true; //To pause only OG
1588     bool public onlyWhiteList = false; //To pause only WL
1589     bool public publicSale = false; //To pause only public
1590     
1591     uint8 public maxMintAmount = 5; //Max Limit per Wallet
1592     uint8 public nftPerAddressLimitFreeO =2; //Max Free mint for WL
1593     uint8 public nftPerAddressLimitO =5; //Max Limit per Wallet for WL
1594     uint8 public nftPerAddressLimitFreeL =1; //Max Free mint for WL
1595     uint8 public nftPerAddressLimitL =5; //Max Limit per Wallet for WL
1596     uint8 public nftPerAddressLimitFreePublic =1; //Max Free mint for Public
1597     uint8 public nftPerAddressLimitPublic =5; //Max Limit per Wallet for Public
1598     
1599     uint256 public cost = 0.005 ether;
1600     uint256 public maxSupply = 1920;
1601 
1602     uint256 public whitelistFreeMinted=0;
1603     uint256 public whitelistOFreeMinted=0;
1604     uint256 public whitelistLFreeMinted=0;
1605     uint256 public publicFreeMinted=0;
1606     uint256 public paidMinted=0;
1607 
1608     uint256 public whitelistLLimit=300;
1609     uint256 public whitelistOLimit=100;
1610     uint256 public publicFreeLimit=500;
1611     uint256 public paidMintedLimit=1000;
1612 
1613     string private baseURI;
1614     string public baseExtension = ".json";
1615     string private notRevealedUri;
1616 
1617     mapping(address => bool) whitelistedAddressesO;
1618     mapping(address => bool) whitelistedAddressesL;
1619     mapping(address => uint8) mintedList;
1620 
1621     constructor(
1622         string memory _name,
1623         string memory _symbol,
1624         string memory _initBaseURI,
1625         string memory _initNotRevealedUri,
1626         address[] memory whiteListAdresesO,
1627         address[] memory whiteListAdresesL
1628     ) ERC721A(_name, _symbol) {
1629         setBaseURI(_initBaseURI);
1630         setNotRevealedURI(_initNotRevealedUri);
1631         addWhiteListAddresesO(whiteListAdresesO);
1632         addWhiteListAddresesL(whiteListAdresesL);
1633         _safeMint(msg.sender, 20);
1634     }
1635 
1636     ///@notice some common conditions for public and pre sale that needs to be true like minting is not paused,amount to mint is greater than 0,supply dont exceed more than the total supply and sender dont exceed the max mint amount set
1637     ///@dev this modifier needs to be added on every function thats going to mint tokens
1638     ///@param _mintAmount is the amount to mint tokens
1639     modifier preConditions(uint8 _mintAmount) {
1640         require(!paused,"Minting is currently paused");
1641         require(_mintAmount > 0,"Mint amount should be greater than 0");
1642         require(totalSupply() + _mintAmount <= maxSupply,"Insuffiecient tokens available");
1643         require(_mintAmount+ mintedList[msg.sender] <= maxMintAmount,"Max lmit of tokens exceeded");
1644         _;
1645     }
1646     
1647     ///@notice it is the helper mint function which cheks if the mint amount is less than free mint available then it mint wwithout charges.Otherwise it calculates mint amount that need to be charged,alculate and verify the charges and then mint the tokens
1648     ///@dev  if the mint amount is less than free mint available,then we mint without checking the amount.Otherwise we first calculate how many tokens need to be minted are paid,then checkes the amount send by the minter and then mints the tokens
1649     ///@param _mintAmount is the number of tokens to mint,senderAmount is the amount send by minter while minting,freeMintAvailable is the number of free tokens that are left for the specified addresss.
1650     function mint(
1651         uint8 _mintAmount,
1652         uint256 senderAmount,
1653         uint256 freeMintAvailable,
1654         uint8 isWhitelist
1655     ) private {
1656          if (_mintAmount <= freeMintAvailable) {
1657 
1658              if(isWhitelist==1){
1659                 whitelistFreeMinted=whitelistFreeMinted+_mintAmount;
1660                 whitelistOFreeMinted=whitelistOFreeMinted+_mintAmount;
1661              }
1662              else if(isWhitelist==2){
1663                  whitelistFreeMinted=whitelistFreeMinted+_mintAmount;
1664                  whitelistLFreeMinted=whitelistLFreeMinted+_mintAmount;
1665              }
1666              else{
1667                  publicFreeMinted=publicFreeMinted+_mintAmount;
1668              }
1669 
1670             _safeMint(msg.sender, _mintAmount);
1671             mintedList[msg.sender]+=_mintAmount;
1672            
1673 
1674         } else {
1675 
1676            
1677             if(isWhitelist==1){
1678                 whitelistFreeMinted=whitelistFreeMinted+freeMintAvailable;
1679                  whitelistOFreeMinted=whitelistOFreeMinted+freeMintAvailable;
1680             }
1681             else if(isWhitelist==2){
1682                 whitelistFreeMinted=whitelistFreeMinted+freeMintAvailable;
1683                 whitelistLFreeMinted=whitelistLFreeMinted+freeMintAvailable;
1684             }
1685              else{
1686                  publicFreeMinted=publicFreeMinted+freeMintAvailable;
1687              }
1688              
1689 
1690             uint256 paidMint = _mintAmount - freeMintAvailable;
1691             require(senderAmount >= paidMint * cost,"Insuffiecient funds transfered");
1692             require(paidMinted+paidMint<=paidMintedLimit,"paid limit is exceded");
1693             _safeMint(msg.sender, _mintAmount);
1694             mintedList[msg.sender]+=_mintAmount;
1695             paidMinted=paidMinted+paidMint;
1696         }
1697     }
1698 
1699     ///@notice It returns the number of free mint available for the specific address depending on the type of mint such as pre sale and public sale
1700     ///@dev It is used to calculate the number of free token available for the specific address.It is used as we have different number of free mints for different whitelisting and public sale.
1701     ///@param maxFreeMintAmount is the maximum amount of tokens available to mint free.
1702     ///@return it returns the number of free tokens available to mint,in type uint256, for the senders address.
1703     function getFreeMintAvailableAmount(uint256 maxFreeMintAmount,uint8 isWhitelist)
1704         private
1705         view
1706         returns (uint256)
1707     {
1708         uint256 currentMintAmount = mintedList[msg.sender];
1709         if (maxFreeMintAmount > currentMintAmount) {
1710             uint256 freeMintAvailable=maxFreeMintAmount - currentMintAmount;
1711             if((isWhitelist==1&&whitelistOFreeMinted<whitelistOLimit)){
1712                 
1713                 if(freeMintAvailable<whitelistOLimit-whitelistOFreeMinted){
1714                     return freeMintAvailable;
1715                 }
1716                 else{
1717                     return(whitelistOLimit-whitelistOFreeMinted);
1718                 }
1719                     
1720             }
1721             else if((isWhitelist==2&&whitelistLFreeMinted<whitelistLLimit)){
1722                 
1723                 if(freeMintAvailable<whitelistLLimit-whitelistLFreeMinted){
1724                     return freeMintAvailable;
1725                 }
1726                 else{
1727                     return(whitelistLLimit-whitelistLFreeMinted);
1728                 }
1729                     
1730             }
1731             else if((isWhitelist==0&&publicFreeMinted<publicFreeLimit)){
1732 
1733                 if(freeMintAvailable<publicFreeLimit-publicFreeMinted){
1734                     return freeMintAvailable;
1735                 }
1736                 else{
1737                     return(publicFreeLimit-publicFreeMinted);
1738                 }
1739             }
1740             else{
1741                 return 0;
1742             }
1743             
1744         } else {
1745             return 0;
1746         }
1747     }
1748 
1749     /// @notice It is use to allow mint for the adresses added in whitelist
1750     /// @dev Since we have two whitelist,we calculate there free mint avialble depending on the whitelist and call the private mint function.Cannot break further as free mints are variable to type of sale
1751     /// @param _mintAmount is the quantity of tocken to mint
1752     function preSaleMintOG(uint8 _mintAmount) preConditions(_mintAmount) public payable {
1753        
1754         require(onlyWhiteListed,"Pre sale is not active currently");
1755         require(onlyWhiteListedOG,"Pre sale OG is not active currently");
1756 
1757         uint256 ownerTokenCount = mintedList[msg.sender];
1758         require(_mintAmount+ownerTokenCount<= nftPerAddressLimitO,"Max lmit of tokens exceeded for Whitelists");
1759 
1760         require(isWhiteListedO(msg.sender),"This Adresses is not whitelisted, You can Mint Maestro's Mix in Public Sale");
1761         if (isWhiteListedO(msg.sender)) {
1762             require(ownerTokenCount < nftPerAddressLimitO,"Max lmit of tokens exceeded for OG list");
1763             uint256 freeMintAvailable = getFreeMintAvailableAmount(
1764                 nftPerAddressLimitFreeO,1
1765             );
1766             // require(freeMintAvailable+whitelistFreeMinted<=500,"White list free mint are over");
1767             mint(_mintAmount,msg.value,freeMintAvailable,1);
1768            
1769         }
1770 }
1771 
1772     /// @notice It is use to allow mint for the adresses added in whitelist
1773     /// @dev Since we have two whitelist,we calculate there free mint avialble depending on the whitelist and call the private mint function.Cannot break further as free mints are variable to type of sale
1774     /// @param _mintAmount is the quantity of tocken to mint
1775     function preSaleMintWL(uint8 _mintAmount) preConditions(_mintAmount) public payable {
1776        
1777         require(onlyWhiteListed,"Pre sale is not active currently");
1778         require(onlyWhiteList,"Pre sale WL is not active currently");
1779 
1780         uint256 ownerTokenCount = mintedList[msg.sender];
1781         require(_mintAmount+ownerTokenCount<= nftPerAddressLimitL,"Max lmit of tokens exceeded for Whitelists");
1782 
1783         require(isWhiteListedL(msg.sender),"This Adresses is not whitelisted, You can Mint Maestro's Mix in Public Sale");
1784         if (isWhiteListedL(msg.sender)) {
1785             require(ownerTokenCount < nftPerAddressLimitL,"Max lmit of tokens exceeded for OG list");
1786             uint256 freeMintAvailable = getFreeMintAvailableAmount(
1787                 nftPerAddressLimitFreeL,2
1788             );
1789             // require(freeMintAvailable+whitelistFreeMinted<=500,"White list free mint are over");
1790             mint(_mintAmount,msg.value,freeMintAvailable,2);
1791            
1792         }
1793 }
1794 
1795     /// @notice It is use to allow mint for the public sale
1796     /// @dev Use in public sale.Can also add a check of boolean onlyPulicSale in order to make it discrete with onlyWhiteListed.Cause as of now when whitelisting is off,public sales gets active immediately.Can also add lazy minting for optimization
1797     /// @param _mintAmount is the quantity of tocken to mint
1798     function publicMint(uint8 _mintAmount) preConditions(_mintAmount) public payable {
1799        
1800         require(publicSale,"Public sale is currently inactive");
1801         //require(_mintAmount <= nftPerAddressLimitPublic,"Mint amount should be greater than 0");
1802         uint256 ownerTokenCount = mintedList[msg.sender];
1803         require(_mintAmount+ownerTokenCount <= nftPerAddressLimitPublic,"Max lmit of tokens exceeded for public sale");
1804 
1805         uint256 freeMintAvailable = getFreeMintAvailableAmount(
1806             nftPerAddressLimitFreePublic,0
1807         );
1808 
1809         // require(freeMintAvailable+publicFreeMinted<=1000,"Public free mint is over free");
1810 
1811          mint( _mintAmount,msg.value,freeMintAvailable,0);
1812     }
1813 
1814     function mintOwner(uint256 _mintAmount) public onlyOwner {
1815          _safeMint(msg.sender, _mintAmount);
1816     }
1817 
1818     /// @notice it stops/resume the whitelisting minting process
1819     /// @dev it is to stop/resume the whitelisting minting process.When passed false public mint will be open
1820     /// @param _state is the boolean to whther resume or pause the whitelisting minting process or public mint.
1821     function setOnlyWhiteListed(bool _state) public onlyOwner {
1822         onlyWhiteListed = _state;
1823     }
1824 
1825     /// @notice check if the address is in whitelisted og list
1826     /// @dev use to check if address is in whitelisted og list
1827     /// @param _user is the address of wallet to check
1828     /// @return it returns the boolen,true if address exist in the whitelist og list
1829     function isWhiteListedO(address _user) public view returns (bool) {
1830         bool userIsWhitelisted = whitelistedAddressesO[_user];
1831         return userIsWhitelisted;
1832     }
1833 
1834     /// @notice check if the address is in whitelisted og list
1835     /// @dev use to check if address is in whitelisted og list
1836     /// @param _user is the address of wallet to check
1837     /// @return it returns the boolen,true if address exist in the whitelist og list
1838     function isWhiteListedL(address _user) public view returns (bool) {
1839         bool userIsWhitelisted = whitelistedAddressesL[_user];
1840         return userIsWhitelisted;
1841     }
1842 
1843     ///@notice add number of whitelisted addresses in OG List
1844     ///@dev It takes an array of addreses and add them into mapping of whitelistedO.Istead of taking them in array we can use merkle tree
1845     ///@param whiteListAdreses is array of type adresses where all the whitelisted addreses are stored
1846     function addWhiteListAddresesO(address[]memory whiteListAdreses)public onlyOwner{
1847         for(uint16 i=0;i<whiteListAdreses.length;i++){
1848             whitelistedAddressesO[whiteListAdreses[i]]=true;
1849         }
1850     }
1851 
1852     ///@notice add number of whitelisted addresses in OG List
1853     ///@dev It takes an array of addreses and add them into mapping of whitelistedO.Istead of taking them in array we can use merkle tree
1854     ///@param whiteListAdreses is array of type adresses where all the whitelisted addreses are stored
1855     function addWhiteListAddresesL(address[]memory whiteListAdreses)public onlyOwner{
1856         for(uint16 i=0;i<whiteListAdreses.length;i++){
1857             whitelistedAddressesL[whiteListAdreses[i]]=true;
1858         }
1859     }
1860 
1861     ///@notice add number of whitelisted addresses in L List
1862     ///@dev It takes an array of addreses and add them into mapping of whitelistedL.Istead of taking them in array we can use merkle tree
1863     ///@param whiteListAdreses is array of type adresses where all the whitelisted addreses are stored
1864     
1865     /// @notice it removes the address from whitelist Og list
1866     /// @dev it removes the address from whitelist Og list.Could be removed in future due  to high gass fee
1867     /// @param _user is the address of wallet to be removed from whitelist Og list
1868     function removeWhitelistUsersO(address _user) public onlyOwner {
1869         // Validate the caller is already part of the whitelist.
1870         require(
1871             whitelistedAddressesO[_user],
1872             "Error: Sender is not whitelisted"
1873         );
1874         // Set whitelist boolean to false.
1875         whitelistedAddressesO[_user] = false;
1876         
1877     }
1878 
1879     
1880     ///@notice To set the number of token allowed to free mint in OG whitelist per address
1881     ///@dev set the number of token allowed to free mint in OG list
1882     ///@param _nftPerAddressLimitFreeO of type uint8 is the number of free tokens allowed to mint in OG whitelist
1883     function setNftPerAddressLimitFreeO (uint8 _nftPerAddressLimitFreeO) public onlyOwner{
1884        nftPerAddressLimitFreeO=_nftPerAddressLimitFreeO;
1885        
1886     }
1887     
1888    
1889 
1890     ///@notice To set the total number of token allowed to mint in OG whitelist per address
1891     ///@dev set the total number of token allowed to mint in OG list per address
1892     ///@param _nftPerAddressLimitO of type uint8 is the total number of tokens allowed to mint in OG whitelist per address
1893     function setNftPerAddressLimitO (uint8 _nftPerAddressLimitO) public onlyOwner{
1894         nftPerAddressLimitO=_nftPerAddressLimitO;
1895     }
1896 
1897      ///@notice To set the number of token allowed to free mint in public sale per address
1898     ///@dev set the number of token allowed to free mint in public sale per address
1899     ///@param _nftPerAddressLimitFreePublic of type uint8 is the number of free tokens allowed to mint in public sale per address
1900     function setNftPerAddressLimitFreePublic (uint8 _nftPerAddressLimitFreePublic) public onlyOwner{
1901         nftPerAddressLimitFreePublic=_nftPerAddressLimitFreePublic;
1902     }
1903 
1904     ///@notice To set the total number of token allowed to mint in public sale per address
1905     ///@dev set the total number of token allowed to mint in public sale per address
1906     ///@param _nftPerAddressLimitPublic of type uint8 is the total number of tokens allowed to mint in public sale per address
1907     function setNftPerAddressLimitPublic(uint8 _nftPerAddressLimitPublic) public onlyOwner{
1908         nftPerAddressLimitPublic=_nftPerAddressLimitPublic;
1909     }
1910 
1911     /// @notice Gives the base uri for tocken
1912     /// @dev use for the BaseUri setup at the time of initialization
1913     /// @return base uri of tockens on ipfs in string
1914     function _baseURI() internal view virtual override returns (string memory) {
1915         return baseURI;
1916     }
1917     /// @notice gives the token uri of specific token
1918     /// @dev it is to give us the token uri when minted an nft
1919     /// @param tokenId is the index of the token for which uri has to return
1920     /// @return it returns the uri of specific token
1921     function tokenURI(uint256 tokenId)
1922         public
1923         view
1924         virtual
1925         override
1926         returns (string memory)
1927     {
1928         require(
1929             _exists(tokenId),
1930             "ERC721Metadata: URI query for nonexistent token"
1931         );
1932 
1933         if (revealed == false) {
1934             return notRevealedUri;
1935         }
1936 
1937         string memory currentBaseURI = _baseURI();
1938         if(bytes(currentBaseURI).length > 0){
1939                 return string(
1940                     abi.encodePacked(
1941                         currentBaseURI,
1942                         tokenId.toString(),
1943                         baseExtension
1944                     )
1945                 );
1946         }else{
1947                 return "";
1948             }
1949     }
1950 
1951     /// @notice reveal the nft art
1952     /// @dev set the reveal to true inorder to reveal nft art.
1953     function reveal() public onlyOwner {
1954         revealed = true;
1955     }
1956 
1957     /// @notice set the cost for paid mint
1958     /// @dev it is to set the cost for the tokens minted in paid mint
1959     /// @param _newCost is the new cost to set for the paid mint
1960     function setCost(uint256 _newCost) public onlyOwner {
1961         cost = _newCost;
1962     }
1963 
1964     /// @notice set the max amount of token that can be minted by a simgle wallet
1965     /// @dev it is to set max amount of token that can be minted by a simgle wallet
1966     /// @param _newmaxMintAmount is the new max amount that a single wallet can mint totally
1967     function setmaxMintAmount(uint8 _newmaxMintAmount) public onlyOwner {
1968         maxMintAmount = _newmaxMintAmount;
1969     }
1970 
1971     /// @notice it sets the uri for the image to show when tokens are not revealed
1972     /// @dev it is to set uri of json that has details to show along with image when the tokens are not revealed
1973     /// @param _notRevealedURI is the new uri of json for the metadata when tokens are not revealed
1974     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1975         notRevealedUri = _notRevealedURI;
1976     }
1977 
1978     /// @notice it sets the uri for the data including images,description to show when tokens are  revealed
1979     /// @dev it is to set domain uri of json metadata that has details to show along with image when the tokens are revealed
1980     /// @param _newBaseURI is the new domain uri of json for the metadata when tokens are  revealed
1981     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1982         baseURI = _newBaseURI;
1983     }
1984 
1985     /// @notice it sets the extension of file containing metadata
1986     /// @dev it is to set file extension of metadata that has details to show along with image when the tokens are not revealed
1987     /// @param _newBaseExtension is the new extension of the metadata file
1988     function setBaseExtension(string memory _newBaseExtension)
1989         public
1990         onlyOwner
1991     {
1992         baseExtension = _newBaseExtension;
1993     }
1994 
1995     /// @notice it stops/resume wallet from minting.
1996     /// @dev it is to stop/resume the minting process.Could be used when system is compromised.
1997     /// @param _state is the boolean to whther resume or pause the minting process.
1998     function pause(bool _state) public onlyOwner {
1999         paused = _state;
2000     }
2001 
2002     /// @notice it is to withraw funds from the paid mint
2003     /// @dev it withdraws the fund from minting to the wallet of owner
2004     function withdraw() public payable onlyOwner {
2005         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2006         require(os);
2007     }
2008 
2009     /// @notice it to get track of public mint minted.
2010     /// @dev it to get track of public mint minted.
2011     function getPublicSaleAmount() public view onlyOwner returns (uint256){
2012     return publicFreeMinted;
2013     }
2014     /// @notice it to get track of pres sale mint minted.
2015     /// @dev it to get track of presale mint minted.
2016     function getPreSaleAmount() public view onlyOwner returns (uint256){
2017     return whitelistFreeMinted;
2018     }
2019     /// @notice it to track addresses that mints and thier amount
2020     /// @dev it is added to stop addresses from selling and minting again
2021     /// @param wallet is the wallet addr of minter
2022     function getMintedAmountByWallet(address wallet) public view returns (uint8){
2023     return mintedList[wallet];
2024     }
2025     /// @notice it sets the paid mint amount
2026     /// @dev it is to set the cap on paid mint
2027     /// @param paidMintLim is the uint256 to set paid mint amount limit
2028     function setPaidMintLimit(uint256 paidMintLim)
2029         public
2030         onlyOwner
2031     {
2032         paidMintedLimit=paidMintLim;
2033     }
2034     /// @notice it toggle the whitelistog
2035     /// @dev it toggle the whitelistog
2036     /// @param toggleWhitelistOG is the bool to toggle the whitelistog
2037     function setWhiteListOG(bool toggleWhitelistOG)
2038         public
2039         onlyOwner
2040     {
2041         onlyWhiteListedOG=toggleWhitelistOG;
2042     }
2043     /// @notice it toggle the whitelist
2044     /// @dev it toggle the whitelist
2045     /// @param toggleWhitelist is the bool to toggle the whitelist
2046     function setWhiteList(bool toggleWhitelist)
2047         public
2048         onlyOwner
2049     {
2050         onlyWhiteList=toggleWhitelist;
2051     }
2052     /// @notice it toggle the publicSale
2053     /// @dev it toggle the publicsale
2054     /// @param togglePublicSale is the bool to toggle the whitelist
2055     function setPublicSale(bool togglePublicSale)
2056         public
2057         onlyOwner
2058     {
2059         publicSale=togglePublicSale;
2060     }
2061 }