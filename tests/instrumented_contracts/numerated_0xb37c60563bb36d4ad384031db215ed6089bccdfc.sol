1 // File: contracts/IERC721A.sol
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
286 // File: contracts/ERC721A.sol
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
1382 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
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
1431         // On the first call to nonReentrant, _notEntered will be true
1432         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1433 
1434         // Any calls to nonReentrant after this point will fail
1435         _status = _ENTERED;
1436 
1437         _;
1438 
1439         // By storing the original value once again, a refund is triggered (see
1440         // https://eips.ethereum.org/EIPS/eip-2200)
1441         _status = _NOT_ENTERED;
1442     }
1443 }
1444 
1445 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1446 
1447 
1448 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1449 
1450 pragma solidity ^0.8.0;
1451 
1452 /**
1453  * @dev These functions deal with verification of Merkle Tree proofs.
1454  *
1455  * The proofs can be generated using the JavaScript library
1456  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1457  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1458  *
1459  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1460  *
1461  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1462  * hashing, or use a hash function other than keccak256 for hashing leaves.
1463  * This is because the concatenation of a sorted pair of internal nodes in
1464  * the merkle tree could be reinterpreted as a leaf value.
1465  */
1466 library MerkleProof {
1467     /**
1468      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1469      * defined by `root`. For this, a `proof` must be provided, containing
1470      * sibling hashes on the branch from the leaf to the root of the tree. Each
1471      * pair of leaves and each pair of pre-images are assumed to be sorted.
1472      */
1473     function verify(
1474         bytes32[] memory proof,
1475         bytes32 root,
1476         bytes32 leaf
1477     ) internal pure returns (bool) {
1478         return processProof(proof, leaf) == root;
1479     }
1480 
1481     /**
1482      * @dev Calldata version of {verify}
1483      *
1484      * _Available since v4.7._
1485      */
1486     function verifyCalldata(
1487         bytes32[] calldata proof,
1488         bytes32 root,
1489         bytes32 leaf
1490     ) internal pure returns (bool) {
1491         return processProofCalldata(proof, leaf) == root;
1492     }
1493 
1494     /**
1495      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1496      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1497      * hash matches the root of the tree. When processing the proof, the pairs
1498      * of leafs & pre-images are assumed to be sorted.
1499      *
1500      * _Available since v4.4._
1501      */
1502     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1503         bytes32 computedHash = leaf;
1504         for (uint256 i = 0; i < proof.length; i++) {
1505             computedHash = _hashPair(computedHash, proof[i]);
1506         }
1507         return computedHash;
1508     }
1509 
1510     /**
1511      * @dev Calldata version of {processProof}
1512      *
1513      * _Available since v4.7._
1514      */
1515     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1516         bytes32 computedHash = leaf;
1517         for (uint256 i = 0; i < proof.length; i++) {
1518             computedHash = _hashPair(computedHash, proof[i]);
1519         }
1520         return computedHash;
1521     }
1522 
1523     /**
1524      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1525      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1526      *
1527      * _Available since v4.7._
1528      */
1529     function multiProofVerify(
1530         bytes32[] memory proof,
1531         bool[] memory proofFlags,
1532         bytes32 root,
1533         bytes32[] memory leaves
1534     ) internal pure returns (bool) {
1535         return processMultiProof(proof, proofFlags, leaves) == root;
1536     }
1537 
1538     /**
1539      * @dev Calldata version of {multiProofVerify}
1540      *
1541      * _Available since v4.7._
1542      */
1543     function multiProofVerifyCalldata(
1544         bytes32[] calldata proof,
1545         bool[] calldata proofFlags,
1546         bytes32 root,
1547         bytes32[] memory leaves
1548     ) internal pure returns (bool) {
1549         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1550     }
1551 
1552     /**
1553      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1554      * consuming from one or the other at each step according to the instructions given by
1555      * `proofFlags`.
1556      *
1557      * _Available since v4.7._
1558      */
1559     function processMultiProof(
1560         bytes32[] memory proof,
1561         bool[] memory proofFlags,
1562         bytes32[] memory leaves
1563     ) internal pure returns (bytes32 merkleRoot) {
1564         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1565         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1566         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1567         // the merkle tree.
1568         uint256 leavesLen = leaves.length;
1569         uint256 totalHashes = proofFlags.length;
1570 
1571         // Check proof validity.
1572         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1573 
1574         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1575         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1576         bytes32[] memory hashes = new bytes32[](totalHashes);
1577         uint256 leafPos = 0;
1578         uint256 hashPos = 0;
1579         uint256 proofPos = 0;
1580         // At each step, we compute the next hash using two values:
1581         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1582         //   get the next hash.
1583         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1584         //   `proof` array.
1585         for (uint256 i = 0; i < totalHashes; i++) {
1586             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1587             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1588             hashes[i] = _hashPair(a, b);
1589         }
1590 
1591         if (totalHashes > 0) {
1592             return hashes[totalHashes - 1];
1593         } else if (leavesLen > 0) {
1594             return leaves[0];
1595         } else {
1596             return proof[0];
1597         }
1598     }
1599 
1600     /**
1601      * @dev Calldata version of {processMultiProof}
1602      *
1603      * _Available since v4.7._
1604      */
1605     function processMultiProofCalldata(
1606         bytes32[] calldata proof,
1607         bool[] calldata proofFlags,
1608         bytes32[] memory leaves
1609     ) internal pure returns (bytes32 merkleRoot) {
1610         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1611         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1612         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1613         // the merkle tree.
1614         uint256 leavesLen = leaves.length;
1615         uint256 totalHashes = proofFlags.length;
1616 
1617         // Check proof validity.
1618         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1619 
1620         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1621         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1622         bytes32[] memory hashes = new bytes32[](totalHashes);
1623         uint256 leafPos = 0;
1624         uint256 hashPos = 0;
1625         uint256 proofPos = 0;
1626         // At each step, we compute the next hash using two values:
1627         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1628         //   get the next hash.
1629         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1630         //   `proof` array.
1631         for (uint256 i = 0; i < totalHashes; i++) {
1632             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1633             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1634             hashes[i] = _hashPair(a, b);
1635         }
1636 
1637         if (totalHashes > 0) {
1638             return hashes[totalHashes - 1];
1639         } else if (leavesLen > 0) {
1640             return leaves[0];
1641         } else {
1642             return proof[0];
1643         }
1644     }
1645 
1646     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1647         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1648     }
1649 
1650     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1651         /// @solidity memory-safe-assembly
1652         assembly {
1653             mstore(0x00, a)
1654             mstore(0x20, b)
1655             value := keccak256(0x00, 0x40)
1656         }
1657     }
1658 }
1659 
1660 // File: @openzeppelin/contracts/utils/Address.sol
1661 
1662 
1663 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1664 
1665 pragma solidity ^0.8.1;
1666 
1667 /**
1668  * @dev Collection of functions related to the address type
1669  */
1670 library Address {
1671     /**
1672      * @dev Returns true if `account` is a contract.
1673      *
1674      * [IMPORTANT]
1675      * ====
1676      * It is unsafe to assume that an address for which this function returns
1677      * false is an externally-owned account (EOA) and not a contract.
1678      *
1679      * Among others, `isContract` will return false for the following
1680      * types of addresses:
1681      *
1682      *  - an externally-owned account
1683      *  - a contract in construction
1684      *  - an address where a contract will be created
1685      *  - an address where a contract lived, but was destroyed
1686      * ====
1687      *
1688      * [IMPORTANT]
1689      * ====
1690      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1691      *
1692      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1693      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1694      * constructor.
1695      * ====
1696      */
1697     function isContract(address account) internal view returns (bool) {
1698         // This method relies on extcodesize/address.code.length, which returns 0
1699         // for contracts in construction, since the code is only stored at the end
1700         // of the constructor execution.
1701 
1702         return account.code.length > 0;
1703     }
1704 
1705     /**
1706      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1707      * `recipient`, forwarding all available gas and reverting on errors.
1708      *
1709      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1710      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1711      * imposed by `transfer`, making them unable to receive funds via
1712      * `transfer`. {sendValue} removes this limitation.
1713      *
1714      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1715      *
1716      * IMPORTANT: because control is transferred to `recipient`, care must be
1717      * taken to not create reentrancy vulnerabilities. Consider using
1718      * {ReentrancyGuard} or the
1719      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1720      */
1721     function sendValue(address payable recipient, uint256 amount) internal {
1722         require(address(this).balance >= amount, "Address: insufficient balance");
1723 
1724         (bool success, ) = recipient.call{value: amount}("");
1725         require(success, "Address: unable to send value, recipient may have reverted");
1726     }
1727 
1728     /**
1729      * @dev Performs a Solidity function call using a low level `call`. A
1730      * plain `call` is an unsafe replacement for a function call: use this
1731      * function instead.
1732      *
1733      * If `target` reverts with a revert reason, it is bubbled up by this
1734      * function (like regular Solidity function calls).
1735      *
1736      * Returns the raw returned data. To convert to the expected return value,
1737      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1738      *
1739      * Requirements:
1740      *
1741      * - `target` must be a contract.
1742      * - calling `target` with `data` must not revert.
1743      *
1744      * _Available since v3.1._
1745      */
1746     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1747         return functionCall(target, data, "Address: low-level call failed");
1748     }
1749 
1750     /**
1751      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1752      * `errorMessage` as a fallback revert reason when `target` reverts.
1753      *
1754      * _Available since v3.1._
1755      */
1756     function functionCall(
1757         address target,
1758         bytes memory data,
1759         string memory errorMessage
1760     ) internal returns (bytes memory) {
1761         return functionCallWithValue(target, data, 0, errorMessage);
1762     }
1763 
1764     /**
1765      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1766      * but also transferring `value` wei to `target`.
1767      *
1768      * Requirements:
1769      *
1770      * - the calling contract must have an ETH balance of at least `value`.
1771      * - the called Solidity function must be `payable`.
1772      *
1773      * _Available since v3.1._
1774      */
1775     function functionCallWithValue(
1776         address target,
1777         bytes memory data,
1778         uint256 value
1779     ) internal returns (bytes memory) {
1780         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1781     }
1782 
1783     /**
1784      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1785      * with `errorMessage` as a fallback revert reason when `target` reverts.
1786      *
1787      * _Available since v3.1._
1788      */
1789     function functionCallWithValue(
1790         address target,
1791         bytes memory data,
1792         uint256 value,
1793         string memory errorMessage
1794     ) internal returns (bytes memory) {
1795         require(address(this).balance >= value, "Address: insufficient balance for call");
1796         require(isContract(target), "Address: call to non-contract");
1797 
1798         (bool success, bytes memory returndata) = target.call{value: value}(data);
1799         return verifyCallResult(success, returndata, errorMessage);
1800     }
1801 
1802     /**
1803      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1804      * but performing a static call.
1805      *
1806      * _Available since v3.3._
1807      */
1808     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1809         return functionStaticCall(target, data, "Address: low-level static call failed");
1810     }
1811 
1812     /**
1813      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1814      * but performing a static call.
1815      *
1816      * _Available since v3.3._
1817      */
1818     function functionStaticCall(
1819         address target,
1820         bytes memory data,
1821         string memory errorMessage
1822     ) internal view returns (bytes memory) {
1823         require(isContract(target), "Address: static call to non-contract");
1824 
1825         (bool success, bytes memory returndata) = target.staticcall(data);
1826         return verifyCallResult(success, returndata, errorMessage);
1827     }
1828 
1829     /**
1830      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1831      * but performing a delegate call.
1832      *
1833      * _Available since v3.4._
1834      */
1835     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1836         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1837     }
1838 
1839     /**
1840      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1841      * but performing a delegate call.
1842      *
1843      * _Available since v3.4._
1844      */
1845     function functionDelegateCall(
1846         address target,
1847         bytes memory data,
1848         string memory errorMessage
1849     ) internal returns (bytes memory) {
1850         require(isContract(target), "Address: delegate call to non-contract");
1851 
1852         (bool success, bytes memory returndata) = target.delegatecall(data);
1853         return verifyCallResult(success, returndata, errorMessage);
1854     }
1855 
1856     /**
1857      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1858      * revert reason using the provided one.
1859      *
1860      * _Available since v4.3._
1861      */
1862     function verifyCallResult(
1863         bool success,
1864         bytes memory returndata,
1865         string memory errorMessage
1866     ) internal pure returns (bytes memory) {
1867         if (success) {
1868             return returndata;
1869         } else {
1870             // Look for revert reason and bubble it up if present
1871             if (returndata.length > 0) {
1872                 // The easiest way to bubble the revert reason is using memory via assembly
1873                 /// @solidity memory-safe-assembly
1874                 assembly {
1875                     let returndata_size := mload(returndata)
1876                     revert(add(32, returndata), returndata_size)
1877                 }
1878             } else {
1879                 revert(errorMessage);
1880             }
1881         }
1882     }
1883 }
1884 
1885 // File: @openzeppelin/contracts/utils/Strings.sol
1886 
1887 
1888 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1889 
1890 pragma solidity ^0.8.0;
1891 
1892 /**
1893  * @dev String operations.
1894  */
1895 library Strings {
1896     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1897     uint8 private constant _ADDRESS_LENGTH = 20;
1898 
1899     /**
1900      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1901      */
1902     function toString(uint256 value) internal pure returns (string memory) {
1903         // Inspired by OraclizeAPI's implementation - MIT licence
1904         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1905 
1906         if (value == 0) {
1907             return "0";
1908         }
1909         uint256 temp = value;
1910         uint256 digits;
1911         while (temp != 0) {
1912             digits++;
1913             temp /= 10;
1914         }
1915         bytes memory buffer = new bytes(digits);
1916         while (value != 0) {
1917             digits -= 1;
1918             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1919             value /= 10;
1920         }
1921         return string(buffer);
1922     }
1923 
1924     /**
1925      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1926      */
1927     function toHexString(uint256 value) internal pure returns (string memory) {
1928         if (value == 0) {
1929             return "0x00";
1930         }
1931         uint256 temp = value;
1932         uint256 length = 0;
1933         while (temp != 0) {
1934             length++;
1935             temp >>= 8;
1936         }
1937         return toHexString(value, length);
1938     }
1939 
1940     /**
1941      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1942      */
1943     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1944         bytes memory buffer = new bytes(2 * length + 2);
1945         buffer[0] = "0";
1946         buffer[1] = "x";
1947         for (uint256 i = 2 * length + 1; i > 1; --i) {
1948             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1949             value >>= 4;
1950         }
1951         require(value == 0, "Strings: hex length insufficient");
1952         return string(buffer);
1953     }
1954 
1955     /**
1956      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1957      */
1958     function toHexString(address addr) internal pure returns (string memory) {
1959         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1960     }
1961 }
1962 
1963 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1964 
1965 
1966 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1967 
1968 pragma solidity ^0.8.0;
1969 
1970 // CAUTION
1971 // This version of SafeMath should only be used with Solidity 0.8 or later,
1972 // because it relies on the compiler's built in overflow checks.
1973 
1974 /**
1975  * @dev Wrappers over Solidity's arithmetic operations.
1976  *
1977  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1978  * now has built in overflow checking.
1979  */
1980 library SafeMath {
1981     /**
1982      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1983      *
1984      * _Available since v3.4._
1985      */
1986     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1987         unchecked {
1988             uint256 c = a + b;
1989             if (c < a) return (false, 0);
1990             return (true, c);
1991         }
1992     }
1993 
1994     /**
1995      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1996      *
1997      * _Available since v3.4._
1998      */
1999     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2000         unchecked {
2001             if (b > a) return (false, 0);
2002             return (true, a - b);
2003         }
2004     }
2005 
2006     /**
2007      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
2008      *
2009      * _Available since v3.4._
2010      */
2011     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2012         unchecked {
2013             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2014             // benefit is lost if 'b' is also tested.
2015             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
2016             if (a == 0) return (true, 0);
2017             uint256 c = a * b;
2018             if (c / a != b) return (false, 0);
2019             return (true, c);
2020         }
2021     }
2022 
2023     /**
2024      * @dev Returns the division of two unsigned integers, with a division by zero flag.
2025      *
2026      * _Available since v3.4._
2027      */
2028     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2029         unchecked {
2030             if (b == 0) return (false, 0);
2031             return (true, a / b);
2032         }
2033     }
2034 
2035     /**
2036      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
2037      *
2038      * _Available since v3.4._
2039      */
2040     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
2041         unchecked {
2042             if (b == 0) return (false, 0);
2043             return (true, a % b);
2044         }
2045     }
2046 
2047     /**
2048      * @dev Returns the addition of two unsigned integers, reverting on
2049      * overflow.
2050      *
2051      * Counterpart to Solidity's `+` operator.
2052      *
2053      * Requirements:
2054      *
2055      * - Addition cannot overflow.
2056      */
2057     function add(uint256 a, uint256 b) internal pure returns (uint256) {
2058         return a + b;
2059     }
2060 
2061     /**
2062      * @dev Returns the subtraction of two unsigned integers, reverting on
2063      * overflow (when the result is negative).
2064      *
2065      * Counterpart to Solidity's `-` operator.
2066      *
2067      * Requirements:
2068      *
2069      * - Subtraction cannot overflow.
2070      */
2071     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
2072         return a - b;
2073     }
2074 
2075     /**
2076      * @dev Returns the multiplication of two unsigned integers, reverting on
2077      * overflow.
2078      *
2079      * Counterpart to Solidity's `*` operator.
2080      *
2081      * Requirements:
2082      *
2083      * - Multiplication cannot overflow.
2084      */
2085     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
2086         return a * b;
2087     }
2088 
2089     /**
2090      * @dev Returns the integer division of two unsigned integers, reverting on
2091      * division by zero. The result is rounded towards zero.
2092      *
2093      * Counterpart to Solidity's `/` operator.
2094      *
2095      * Requirements:
2096      *
2097      * - The divisor cannot be zero.
2098      */
2099     function div(uint256 a, uint256 b) internal pure returns (uint256) {
2100         return a / b;
2101     }
2102 
2103     /**
2104      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2105      * reverting when dividing by zero.
2106      *
2107      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2108      * opcode (which leaves remaining gas untouched) while Solidity uses an
2109      * invalid opcode to revert (consuming all remaining gas).
2110      *
2111      * Requirements:
2112      *
2113      * - The divisor cannot be zero.
2114      */
2115     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2116         return a % b;
2117     }
2118 
2119     /**
2120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2121      * overflow (when the result is negative).
2122      *
2123      * CAUTION: This function is deprecated because it requires allocating memory for the error
2124      * message unnecessarily. For custom revert reasons use {trySub}.
2125      *
2126      * Counterpart to Solidity's `-` operator.
2127      *
2128      * Requirements:
2129      *
2130      * - Subtraction cannot overflow.
2131      */
2132     function sub(
2133         uint256 a,
2134         uint256 b,
2135         string memory errorMessage
2136     ) internal pure returns (uint256) {
2137         unchecked {
2138             require(b <= a, errorMessage);
2139             return a - b;
2140         }
2141     }
2142 
2143     /**
2144      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2145      * division by zero. The result is rounded towards zero.
2146      *
2147      * Counterpart to Solidity's `/` operator. Note: this function uses a
2148      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2149      * uses an invalid opcode to revert (consuming all remaining gas).
2150      *
2151      * Requirements:
2152      *
2153      * - The divisor cannot be zero.
2154      */
2155     function div(
2156         uint256 a,
2157         uint256 b,
2158         string memory errorMessage
2159     ) internal pure returns (uint256) {
2160         unchecked {
2161             require(b > 0, errorMessage);
2162             return a / b;
2163         }
2164     }
2165 
2166     /**
2167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2168      * reverting with custom message when dividing by zero.
2169      *
2170      * CAUTION: This function is deprecated because it requires allocating memory for the error
2171      * message unnecessarily. For custom revert reasons use {tryMod}.
2172      *
2173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2174      * opcode (which leaves remaining gas untouched) while Solidity uses an
2175      * invalid opcode to revert (consuming all remaining gas).
2176      *
2177      * Requirements:
2178      *
2179      * - The divisor cannot be zero.
2180      */
2181     function mod(
2182         uint256 a,
2183         uint256 b,
2184         string memory errorMessage
2185     ) internal pure returns (uint256) {
2186         unchecked {
2187             require(b > 0, errorMessage);
2188             return a % b;
2189         }
2190     }
2191 }
2192 
2193 // File: @openzeppelin/contracts/utils/Context.sol
2194 
2195 
2196 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2197 
2198 pragma solidity ^0.8.0;
2199 
2200 /**
2201  * @dev Provides information about the current execution context, including the
2202  * sender of the transaction and its data. While these are generally available
2203  * via msg.sender and msg.data, they should not be accessed in such a direct
2204  * manner, since when dealing with meta-transactions the account sending and
2205  * paying for execution may not be the actual sender (as far as an application
2206  * is concerned).
2207  *
2208  * This contract is only required for intermediate, library-like contracts.
2209  */
2210 abstract contract Context {
2211     function _msgSender() internal view virtual returns (address) {
2212         return msg.sender;
2213     }
2214 
2215     function _msgData() internal view virtual returns (bytes calldata) {
2216         return msg.data;
2217     }
2218 }
2219 
2220 // File: @openzeppelin/contracts/security/Pausable.sol
2221 
2222 
2223 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
2224 
2225 pragma solidity ^0.8.0;
2226 
2227 
2228 /**
2229  * @dev Contract module which allows children to implement an emergency stop
2230  * mechanism that can be triggered by an authorized account.
2231  *
2232  * This module is used through inheritance. It will make available the
2233  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2234  * the functions of your contract. Note that they will not be pausable by
2235  * simply including this module, only once the modifiers are put in place.
2236  */
2237 abstract contract Pausable is Context {
2238     /**
2239      * @dev Emitted when the pause is triggered by `account`.
2240      */
2241     event Paused(address account);
2242 
2243     /**
2244      * @dev Emitted when the pause is lifted by `account`.
2245      */
2246     event Unpaused(address account);
2247 
2248     bool private _paused;
2249 
2250     /**
2251      * @dev Initializes the contract in unpaused state.
2252      */
2253     constructor() {
2254         _paused = false;
2255     }
2256 
2257     /**
2258      * @dev Modifier to make a function callable only when the contract is not paused.
2259      *
2260      * Requirements:
2261      *
2262      * - The contract must not be paused.
2263      */
2264     modifier whenNotPaused() {
2265         _requireNotPaused();
2266         _;
2267     }
2268 
2269     /**
2270      * @dev Modifier to make a function callable only when the contract is paused.
2271      *
2272      * Requirements:
2273      *
2274      * - The contract must be paused.
2275      */
2276     modifier whenPaused() {
2277         _requirePaused();
2278         _;
2279     }
2280 
2281     /**
2282      * @dev Returns true if the contract is paused, and false otherwise.
2283      */
2284     function paused() public view virtual returns (bool) {
2285         return _paused;
2286     }
2287 
2288     /**
2289      * @dev Throws if the contract is paused.
2290      */
2291     function _requireNotPaused() internal view virtual {
2292         require(!paused(), "Pausable: paused");
2293     }
2294 
2295     /**
2296      * @dev Throws if the contract is not paused.
2297      */
2298     function _requirePaused() internal view virtual {
2299         require(paused(), "Pausable: not paused");
2300     }
2301 
2302     /**
2303      * @dev Triggers stopped state.
2304      *
2305      * Requirements:
2306      *
2307      * - The contract must not be paused.
2308      */
2309     function _pause() internal virtual whenNotPaused {
2310         _paused = true;
2311         emit Paused(_msgSender());
2312     }
2313 
2314     /**
2315      * @dev Returns to normal state.
2316      *
2317      * Requirements:
2318      *
2319      * - The contract must be paused.
2320      */
2321     function _unpause() internal virtual whenPaused {
2322         _paused = false;
2323         emit Unpaused(_msgSender());
2324     }
2325 }
2326 
2327 // File: @openzeppelin/contracts/access/Ownable.sol
2328 
2329 
2330 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2331 
2332 pragma solidity ^0.8.0;
2333 
2334 
2335 /**
2336  * @dev Contract module which provides a basic access control mechanism, where
2337  * there is an account (an owner) that can be granted exclusive access to
2338  * specific functions.
2339  *
2340  * By default, the owner account will be the one that deploys the contract. This
2341  * can later be changed with {transferOwnership}.
2342  *
2343  * This module is used through inheritance. It will make available the modifier
2344  * `onlyOwner`, which can be applied to your functions to restrict their use to
2345  * the owner.
2346  */
2347 abstract contract Ownable is Context {
2348     address private _owner;
2349 
2350     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2351 
2352     /**
2353      * @dev Initializes the contract setting the deployer as the initial owner.
2354      */
2355     constructor() {
2356         _transferOwnership(_msgSender());
2357     }
2358 
2359     /**
2360      * @dev Throws if called by any account other than the owner.
2361      */
2362     modifier onlyOwner() {
2363         _checkOwner();
2364         _;
2365     }
2366 
2367     /**
2368      * @dev Returns the address of the current owner.
2369      */
2370     function owner() public view virtual returns (address) {
2371         return _owner;
2372     }
2373 
2374     /**
2375      * @dev Throws if the sender is not the owner.
2376      */
2377     function _checkOwner() internal view virtual {
2378         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2379     }
2380 
2381     /**
2382      * @dev Leaves the contract without owner. It will not be possible to call
2383      * `onlyOwner` functions anymore. Can only be called by the current owner.
2384      *
2385      * NOTE: Renouncing ownership will leave the contract without an owner,
2386      * thereby removing any functionality that is only available to the owner.
2387      */
2388     function renounceOwnership() public virtual onlyOwner {
2389         _transferOwnership(address(0));
2390     }
2391 
2392     /**
2393      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2394      * Can only be called by the current owner.
2395      */
2396     function transferOwnership(address newOwner) public virtual onlyOwner {
2397         require(newOwner != address(0), "Ownable: new owner is the zero address");
2398         _transferOwnership(newOwner);
2399     }
2400 
2401     /**
2402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2403      * Internal function without access restriction.
2404      */
2405     function _transferOwnership(address newOwner) internal virtual {
2406         address oldOwner = _owner;
2407         _owner = newOwner;
2408         emit OwnershipTransferred(oldOwner, newOwner);
2409     }
2410 }
2411 
2412 // File: contracts/DeasArt.sol
2413 
2414 
2415 pragma solidity ^0.8.9;
2416 
2417 
2418 
2419 
2420 
2421 
2422 
2423 
2424 
2425     struct StageConfig {
2426         uint256 maxPerWallet;
2427         uint256 price;
2428     }
2429 
2430 contract DesArtsNFT is ERC721A, Ownable, Pausable, ReentrancyGuard {
2431 
2432     uint256 private currentStage = 0;
2433 
2434     uint256 private constant RESERVE_STAGE = 0;
2435     uint256 private constant PRE_SALE_STAGE = 1;
2436     uint256 private constant PUBLIC_SALE_STAGE = 2;
2437     uint256 private constant CLOSED_SALE_STAGE = 3;
2438     uint256 private constant REVEAL_STAGE = 4;
2439 
2440     uint256 private constant MAX_TOTAL_SUPPLY = 8888;
2441     uint256 private constant MAX_RESERVE = 130;
2442 
2443     StageConfig private preSaleStageConfig;
2444     StageConfig private publicSaleStageConfig;
2445 
2446     bytes32 private privilegeRoot;
2447     bytes32 private ordinaryRoot;
2448 
2449     string private baseUriForClosed;
2450     string private baseUriForOpened;
2451 
2452     mapping(uint256 => mapping(address => uint256))
2453     private _stage_user_balances;
2454     mapping(address => bool) private _privilegeMinted;
2455 
2456     constructor(
2457         string memory _baseUriForClosed,
2458         string memory _baseUriForOpened,
2459         bytes32 _privilegeRoot,
2460         bytes32 _ordinaryRoot,
2461         StageConfig memory _preSaleStage,
2462         StageConfig memory _publicSaleStage
2463     ) Ownable() Pausable() ERC721A("DesArts", "DesArts") {
2464         baseUriForClosed = _baseUriForClosed;
2465         baseUriForOpened = _baseUriForOpened;
2466         privilegeRoot = _privilegeRoot;
2467         ordinaryRoot = _ordinaryRoot;
2468         preSaleStageConfig = _preSaleStage;
2469         publicSaleStageConfig = _publicSaleStage;
2470     }
2471 
2472     function withdraw() external onlyOwner whenNotPaused {
2473         address payable to = payable(_msgSender());
2474         Address.sendValue(to, address(this).balance);
2475     }
2476 
2477     function nextStage() external onlyOwner whenNotPaused {
2478         require(
2479             currentStage >= RESERVE_STAGE && currentStage < REVEAL_STAGE,
2480             "DesArtsNFT#nextStage: current stage illegal"
2481         );
2482         currentStage += 1;
2483     }
2484 
2485     function reserve(address[] memory _to, uint256 _quanlity)
2486     external
2487     onlyOwner
2488     whenNotPaused
2489     {
2490         require(currentStage == RESERVE_STAGE, "DesArtsNFT#reserve: Out of reserve period");
2491         require(
2492             _quanlity == _to.length,
2493             "DesArtsNFT#reserve: The address and quanlity mismatch."
2494         );
2495         require(
2496             totalSupply() + _quanlity <= MAX_RESERVE,
2497             "DesArtsNFT#reserve: Over reserve amount limit."
2498         );
2499         require(
2500             totalSupply() + _quanlity <= MAX_TOTAL_SUPPLY,
2501             "DesArtsNFT#reserve: Over total amount limit."
2502         );
2503 
2504         for (uint256 i = 0; i < _quanlity; i++) {
2505             _safeMint(_to[i], 1);
2506         }
2507     }
2508 
2509     function checkSaleStage(uint256 stage) internal pure {
2510         require(
2511             stage >= PRE_SALE_STAGE && stage <= PUBLIC_SALE_STAGE,
2512             "DesArtsNFT#checkSaleStage: Out of selling period"
2513         );
2514     }
2515 
2516     function batchMint(
2517         bytes32[] calldata _ordinaryProof,
2518         bytes32[] calldata _privilegeProof,
2519         uint256 _quantity
2520     ) external payable whenNotPaused nonReentrant {
2521         checkSaleStage(currentStage);
2522         require(
2523             _quantity + totalSupply() <= MAX_TOTAL_SUPPLY,
2524             "DesArtsNFT#batchMint: Quantity too big to exceed the max supply."
2525         );
2526 
2527         uint256 maxPerWallet = 0;
2528         if (currentStage == PRE_SALE_STAGE) {
2529             maxPerWallet = preSaleStageConfig.maxPerWallet;
2530         } else {
2531             maxPerWallet = publicSaleStageConfig.maxPerWallet;
2532         }
2533         require(
2534             _quantity + _stage_user_balances[currentStage][_msgSender()] <=
2535             maxPerWallet,
2536             "DesArtsNFT#batchMint: account hold number exceeds current stage per wallet threshold ."
2537         );
2538 
2539         uint256 fee = 0;
2540         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2541         if (_isPrivilege(leaf, _privilegeProof)) {
2542             require(_quantity == 1, "DesArtsNFT# You could mint only one.");
2543             _privilegeMinted[_msgSender()] = true;
2544         } else {
2545             if (
2546                 currentStage == PRE_SALE_STAGE
2547             ) {
2548                 require(
2549                     MerkleProof.verify(_ordinaryProof, ordinaryRoot, leaf),
2550                     "DesArtsNFT#batchMint: The buyer must be in WL."
2551                 );
2552                 fee = preSaleStageConfig.price * _quantity;
2553             } else {
2554                 fee = publicSaleStageConfig.price * _quantity;
2555             }
2556             _stage_user_balances[currentStage][_msgSender()] += _quantity;
2557         }
2558 
2559         require(
2560             msg.value == fee,
2561             "DesArtsNFT#batchMint: Transaction value did not equal the mint price."
2562         );
2563 
2564         _safeMint(_msgSender(), _quantity);
2565     }
2566 
2567     function _isPrivilege(bytes32 _leaf, bytes32[] memory _privilegeProof)
2568     internal
2569     view
2570     returns (bool)
2571     {
2572         return
2573         MerkleProof.verify(_privilegeProof, privilegeRoot, _leaf) &&
2574         !_privilegeMinted[_msgSender()];
2575     }
2576 
2577     function _baseURI() internal view virtual override returns (string memory) {
2578         return
2579         currentStage == REVEAL_STAGE ? baseUriForOpened : baseUriForClosed;
2580     }
2581 
2582     function tokenURI(uint256 tokenId)
2583     public
2584     view
2585     virtual
2586     override
2587     returns (string memory)
2588     {
2589         require(
2590             _exists(tokenId),
2591             "DesArtsNFT#tokenURI: URI query for nonexistent token"
2592         );
2593 
2594         string memory base = _baseURI();
2595         return
2596         bytes(base).length > 0
2597         ? string(
2598             abi.encodePacked(base, Strings.toString(tokenId + 1), ".json")
2599         )
2600         : "";
2601     }
2602 
2603     function setPrivilegeRoot(bytes32 _privilegeRoot) external onlyOwner {
2604         privilegeRoot = _privilegeRoot;
2605     }
2606 
2607     function setOrdinaryRoot(bytes32 _ordinaryRoot) external onlyOwner {
2608         ordinaryRoot = _ordinaryRoot;
2609     }
2610 
2611     function setBaseUriForClosed(string memory _baseUri) external onlyOwner {
2612         baseUriForOpened = _baseUri;
2613     }
2614 
2615     function setBaseUriForOpend(string memory _baseUri) external onlyOwner {
2616         baseUriForOpened = _baseUri;
2617     }
2618 
2619     function setStageConfig(uint256 stage, StageConfig calldata _stageInfo) external onlyOwner {
2620         checkSaleStage(stage);
2621         if (stage == PRE_SALE_STAGE) {
2622             preSaleStageConfig = _stageInfo;
2623         } else {
2624             publicSaleStageConfig = _stageInfo;
2625         }
2626     }
2627 
2628     function getStageConfig(uint256 stage) external view returns (StageConfig memory) {
2629         checkSaleStage(stage);
2630         if (stage == PRE_SALE_STAGE) {
2631             return preSaleStageConfig;
2632         } else {
2633             return publicSaleStageConfig;
2634         }
2635     }
2636 
2637     function getRoot() external view returns (bytes32, bytes32){
2638         return (privilegeRoot, ordinaryRoot);
2639     }
2640 
2641     function getCurrentStage() external view returns (uint256) {
2642         return currentStage;
2643     }
2644 
2645     function getMintPrice(bytes32[] calldata _privilegeProof)
2646     external
2647     view
2648     returns (uint256)
2649     {
2650         require(
2651             currentStage >= PRE_SALE_STAGE && currentStage <= PUBLIC_SALE_STAGE,
2652             "DesArtsNFT#getMintPrice: stage illegal"
2653         );
2654 
2655         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
2656         if (_isPrivilege(leaf, _privilegeProof)) {
2657             return 0;
2658         }
2659         if (currentStage == PRE_SALE_STAGE) {
2660             return preSaleStageConfig.price;
2661         } else {
2662             return publicSaleStageConfig.price;
2663         }
2664     }
2665 
2666     function getBalance() public view returns (uint256) {
2667         return address(this).balance;
2668     }
2669 
2670     function pause() public onlyOwner {
2671         _pause();
2672     }
2673 
2674     function unpause() public onlyOwner {
2675         _unpause();
2676     }
2677 
2678     function renounceOwnership() public override view onlyOwner {
2679         revert("SafeOwnable: ownership cannot be renounced");
2680     }
2681 }