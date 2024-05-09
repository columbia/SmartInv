1 // File: IERC721A.sol
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
175     ) external;
176 
177     /**
178      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId
184     ) external;
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
206     ) external;
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
222     function approve(address to, uint256 tokenId) external;
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
286 // File: ERC721A.sol
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
711     function approve(address to, uint256 tokenId) public virtual override {
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
830     ) public virtual override {
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
896     ) public virtual override {
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
920     ) public virtual override {
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
1379 // File: extensions/IERC721AQueryable.sol
1380 
1381 
1382 // ERC721A Contracts v4.2.3
1383 // Creator: Chiru Labs
1384 
1385 pragma solidity ^0.8.4;
1386 
1387 
1388 /**
1389  * @dev Interface of ERC721AQueryable.
1390  */
1391 interface IERC721AQueryable is IERC721A {
1392     /**
1393      * Invalid query range (`start` >= `stop`).
1394      */
1395     error InvalidQueryRange();
1396 
1397     /**
1398      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1399      *
1400      * If the `tokenId` is out of bounds:
1401      *
1402      * - `addr = address(0)`
1403      * - `startTimestamp = 0`
1404      * - `burned = false`
1405      * - `extraData = 0`
1406      *
1407      * If the `tokenId` is burned:
1408      *
1409      * - `addr = <Address of owner before token was burned>`
1410      * - `startTimestamp = <Timestamp when token was burned>`
1411      * - `burned = true`
1412      * - `extraData = <Extra data when token was burned>`
1413      *
1414      * Otherwise:
1415      *
1416      * - `addr = <Address of owner>`
1417      * - `startTimestamp = <Timestamp of start of ownership>`
1418      * - `burned = false`
1419      * - `extraData = <Extra data at start of ownership>`
1420      */
1421     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1422 
1423     /**
1424      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1425      * See {ERC721AQueryable-explicitOwnershipOf}
1426      */
1427     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1428 
1429     /**
1430      * @dev Returns an array of token IDs owned by `owner`,
1431      * in the range [`start`, `stop`)
1432      * (i.e. `start <= tokenId < stop`).
1433      *
1434      * This function allows for tokens to be queried if the collection
1435      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1436      *
1437      * Requirements:
1438      *
1439      * - `start < stop`
1440      */
1441     function tokensOfOwnerIn(
1442         address owner,
1443         uint256 start,
1444         uint256 stop
1445     ) external view returns (uint256[] memory);
1446 
1447     /**
1448      * @dev Returns an array of token IDs owned by `owner`.
1449      *
1450      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1451      * It is meant to be called off-chain.
1452      *
1453      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1454      * multiple smaller scans if the collection is large enough to cause
1455      * an out-of-gas error (10K collections should be fine).
1456      */
1457     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1458 }
1459 
1460 // File: extensions/ERC721AQueryable.sol
1461 
1462 
1463 // ERC721A Contracts v4.2.3
1464 // Creator: Chiru Labs
1465 
1466 pragma solidity ^0.8.4;
1467 
1468 
1469 
1470 /**
1471  * @title ERC721AQueryable.
1472  *
1473  * @dev ERC721A subclass with convenience query functions.
1474  */
1475 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1476     /**
1477      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1478      *
1479      * If the `tokenId` is out of bounds:
1480      *
1481      * - `addr = address(0)`
1482      * - `startTimestamp = 0`
1483      * - `burned = false`
1484      * - `extraData = 0`
1485      *
1486      * If the `tokenId` is burned:
1487      *
1488      * - `addr = <Address of owner before token was burned>`
1489      * - `startTimestamp = <Timestamp when token was burned>`
1490      * - `burned = true`
1491      * - `extraData = <Extra data when token was burned>`
1492      *
1493      * Otherwise:
1494      *
1495      * - `addr = <Address of owner>`
1496      * - `startTimestamp = <Timestamp of start of ownership>`
1497      * - `burned = false`
1498      * - `extraData = <Extra data at start of ownership>`
1499      */
1500     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1501         TokenOwnership memory ownership;
1502         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1503             return ownership;
1504         }
1505         ownership = _ownershipAt(tokenId);
1506         if (ownership.burned) {
1507             return ownership;
1508         }
1509         return _ownershipOf(tokenId);
1510     }
1511 
1512     /**
1513      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1514      * See {ERC721AQueryable-explicitOwnershipOf}
1515      */
1516     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1517         external
1518         view
1519         virtual
1520         override
1521         returns (TokenOwnership[] memory)
1522     {
1523         unchecked {
1524             uint256 tokenIdsLength = tokenIds.length;
1525             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1526             for (uint256 i; i != tokenIdsLength; ++i) {
1527                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1528             }
1529             return ownerships;
1530         }
1531     }
1532 
1533     /**
1534      * @dev Returns an array of token IDs owned by `owner`,
1535      * in the range [`start`, `stop`)
1536      * (i.e. `start <= tokenId < stop`).
1537      *
1538      * This function allows for tokens to be queried if the collection
1539      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1540      *
1541      * Requirements:
1542      *
1543      * - `start < stop`
1544      */
1545     function tokensOfOwnerIn(
1546         address owner,
1547         uint256 start,
1548         uint256 stop
1549     ) external view virtual override returns (uint256[] memory) {
1550         unchecked {
1551             if (start >= stop) revert InvalidQueryRange();
1552             uint256 tokenIdsIdx;
1553             uint256 stopLimit = _nextTokenId();
1554             // Set `start = max(start, _startTokenId())`.
1555             if (start < _startTokenId()) {
1556                 start = _startTokenId();
1557             }
1558             // Set `stop = min(stop, stopLimit)`.
1559             if (stop > stopLimit) {
1560                 stop = stopLimit;
1561             }
1562             uint256 tokenIdsMaxLength = balanceOf(owner);
1563             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1564             // to cater for cases where `balanceOf(owner)` is too big.
1565             if (start < stop) {
1566                 uint256 rangeLength = stop - start;
1567                 if (rangeLength < tokenIdsMaxLength) {
1568                     tokenIdsMaxLength = rangeLength;
1569                 }
1570             } else {
1571                 tokenIdsMaxLength = 0;
1572             }
1573             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1574             if (tokenIdsMaxLength == 0) {
1575                 return tokenIds;
1576             }
1577             // We need to call `explicitOwnershipOf(start)`,
1578             // because the slot at `start` may not be initialized.
1579             TokenOwnership memory ownership = explicitOwnershipOf(start);
1580             address currOwnershipAddr;
1581             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1582             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1583             if (!ownership.burned) {
1584                 currOwnershipAddr = ownership.addr;
1585             }
1586             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1587                 ownership = _ownershipAt(i);
1588                 if (ownership.burned) {
1589                     continue;
1590                 }
1591                 if (ownership.addr != address(0)) {
1592                     currOwnershipAddr = ownership.addr;
1593                 }
1594                 if (currOwnershipAddr == owner) {
1595                     tokenIds[tokenIdsIdx++] = i;
1596                 }
1597             }
1598             // Downsize the array to fit.
1599             assembly {
1600                 mstore(tokenIds, tokenIdsIdx)
1601             }
1602             return tokenIds;
1603         }
1604     }
1605 
1606     /**
1607      * @dev Returns an array of token IDs owned by `owner`.
1608      *
1609      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1610      * It is meant to be called off-chain.
1611      *
1612      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1613      * multiple smaller scans if the collection is large enough to cause
1614      * an out-of-gas error (10K collections should be fine).
1615      */
1616     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1617         unchecked {
1618             uint256 tokenIdsIdx;
1619             address currOwnershipAddr;
1620             uint256 tokenIdsLength = balanceOf(owner);
1621             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1622             TokenOwnership memory ownership;
1623             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1624                 ownership = _ownershipAt(i);
1625                 if (ownership.burned) {
1626                     continue;
1627                 }
1628                 if (ownership.addr != address(0)) {
1629                     currOwnershipAddr = ownership.addr;
1630                 }
1631                 if (currOwnershipAddr == owner) {
1632                     tokenIds[tokenIdsIdx++] = i;
1633                 }
1634             }
1635             return tokenIds;
1636         }
1637     }
1638 }
1639 
1640 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1641 
1642 
1643 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1644 
1645 pragma solidity ^0.8.0;
1646 
1647 /**
1648  * @dev These functions deal with verification of Merkle Tree proofs.
1649  *
1650  * The tree and the proofs can be generated using our
1651  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1652  * You will find a quickstart guide in the readme.
1653  *
1654  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1655  * hashing, or use a hash function other than keccak256 for hashing leaves.
1656  * This is because the concatenation of a sorted pair of internal nodes in
1657  * the merkle tree could be reinterpreted as a leaf value.
1658  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1659  * against this attack out of the box.
1660  */
1661 library MerkleProof {
1662     /**
1663      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1664      * defined by `root`. For this, a `proof` must be provided, containing
1665      * sibling hashes on the branch from the leaf to the root of the tree. Each
1666      * pair of leaves and each pair of pre-images are assumed to be sorted.
1667      */
1668     function verify(
1669         bytes32[] memory proof,
1670         bytes32 root,
1671         bytes32 leaf
1672     ) internal pure returns (bool) {
1673         return processProof(proof, leaf) == root;
1674     }
1675 
1676     /**
1677      * @dev Calldata version of {verify}
1678      *
1679      * _Available since v4.7._
1680      */
1681     function verifyCalldata(
1682         bytes32[] calldata proof,
1683         bytes32 root,
1684         bytes32 leaf
1685     ) internal pure returns (bool) {
1686         return processProofCalldata(proof, leaf) == root;
1687     }
1688 
1689     /**
1690      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1691      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1692      * hash matches the root of the tree. When processing the proof, the pairs
1693      * of leafs & pre-images are assumed to be sorted.
1694      *
1695      * _Available since v4.4._
1696      */
1697     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1698         bytes32 computedHash = leaf;
1699         for (uint256 i = 0; i < proof.length; i++) {
1700             computedHash = _hashPair(computedHash, proof[i]);
1701         }
1702         return computedHash;
1703     }
1704 
1705     /**
1706      * @dev Calldata version of {processProof}
1707      *
1708      * _Available since v4.7._
1709      */
1710     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1711         bytes32 computedHash = leaf;
1712         for (uint256 i = 0; i < proof.length; i++) {
1713             computedHash = _hashPair(computedHash, proof[i]);
1714         }
1715         return computedHash;
1716     }
1717 
1718     /**
1719      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1720      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1721      *
1722      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1723      *
1724      * _Available since v4.7._
1725      */
1726     function multiProofVerify(
1727         bytes32[] memory proof,
1728         bool[] memory proofFlags,
1729         bytes32 root,
1730         bytes32[] memory leaves
1731     ) internal pure returns (bool) {
1732         return processMultiProof(proof, proofFlags, leaves) == root;
1733     }
1734 
1735     /**
1736      * @dev Calldata version of {multiProofVerify}
1737      *
1738      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1739      *
1740      * _Available since v4.7._
1741      */
1742     function multiProofVerifyCalldata(
1743         bytes32[] calldata proof,
1744         bool[] calldata proofFlags,
1745         bytes32 root,
1746         bytes32[] memory leaves
1747     ) internal pure returns (bool) {
1748         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1749     }
1750 
1751     /**
1752      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1753      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1754      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1755      * respectively.
1756      *
1757      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1758      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1759      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1760      *
1761      * _Available since v4.7._
1762      */
1763     function processMultiProof(
1764         bytes32[] memory proof,
1765         bool[] memory proofFlags,
1766         bytes32[] memory leaves
1767     ) internal pure returns (bytes32 merkleRoot) {
1768         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1769         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1770         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1771         // the merkle tree.
1772         uint256 leavesLen = leaves.length;
1773         uint256 totalHashes = proofFlags.length;
1774 
1775         // Check proof validity.
1776         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1777 
1778         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1779         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1780         bytes32[] memory hashes = new bytes32[](totalHashes);
1781         uint256 leafPos = 0;
1782         uint256 hashPos = 0;
1783         uint256 proofPos = 0;
1784         // At each step, we compute the next hash using two values:
1785         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1786         //   get the next hash.
1787         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1788         //   `proof` array.
1789         for (uint256 i = 0; i < totalHashes; i++) {
1790             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1791             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1792             hashes[i] = _hashPair(a, b);
1793         }
1794 
1795         if (totalHashes > 0) {
1796             return hashes[totalHashes - 1];
1797         } else if (leavesLen > 0) {
1798             return leaves[0];
1799         } else {
1800             return proof[0];
1801         }
1802     }
1803 
1804     /**
1805      * @dev Calldata version of {processMultiProof}.
1806      *
1807      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1808      *
1809      * _Available since v4.7._
1810      */
1811     function processMultiProofCalldata(
1812         bytes32[] calldata proof,
1813         bool[] calldata proofFlags,
1814         bytes32[] memory leaves
1815     ) internal pure returns (bytes32 merkleRoot) {
1816         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1817         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1818         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1819         // the merkle tree.
1820         uint256 leavesLen = leaves.length;
1821         uint256 totalHashes = proofFlags.length;
1822 
1823         // Check proof validity.
1824         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1825 
1826         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1827         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1828         bytes32[] memory hashes = new bytes32[](totalHashes);
1829         uint256 leafPos = 0;
1830         uint256 hashPos = 0;
1831         uint256 proofPos = 0;
1832         // At each step, we compute the next hash using two values:
1833         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1834         //   get the next hash.
1835         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1836         //   `proof` array.
1837         for (uint256 i = 0; i < totalHashes; i++) {
1838             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1839             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1840             hashes[i] = _hashPair(a, b);
1841         }
1842 
1843         if (totalHashes > 0) {
1844             return hashes[totalHashes - 1];
1845         } else if (leavesLen > 0) {
1846             return leaves[0];
1847         } else {
1848             return proof[0];
1849         }
1850     }
1851 
1852     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1853         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1854     }
1855 
1856     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1857         /// @solidity memory-safe-assembly
1858         assembly {
1859             mstore(0x00, a)
1860             mstore(0x20, b)
1861             value := keccak256(0x00, 0x40)
1862         }
1863     }
1864 }
1865 
1866 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1867 
1868 
1869 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1870 
1871 pragma solidity ^0.8.0;
1872 
1873 /**
1874  * @dev Contract module that helps prevent reentrant calls to a function.
1875  *
1876  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1877  * available, which can be applied to functions to make sure there are no nested
1878  * (reentrant) calls to them.
1879  *
1880  * Note that because there is a single `nonReentrant` guard, functions marked as
1881  * `nonReentrant` may not call one another. This can be worked around by making
1882  * those functions `private`, and then adding `external` `nonReentrant` entry
1883  * points to them.
1884  *
1885  * TIP: If you would like to learn more about reentrancy and alternative ways
1886  * to protect against it, check out our blog post
1887  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1888  */
1889 abstract contract ReentrancyGuard {
1890     // Booleans are more expensive than uint256 or any type that takes up a full
1891     // word because each write operation emits an extra SLOAD to first read the
1892     // slot's contents, replace the bits taken up by the boolean, and then write
1893     // back. This is the compiler's defense against contract upgrades and
1894     // pointer aliasing, and it cannot be disabled.
1895 
1896     // The values being non-zero value makes deployment a bit more expensive,
1897     // but in exchange the refund on every call to nonReentrant will be lower in
1898     // amount. Since refunds are capped to a percentage of the total
1899     // transaction's gas, it is best to keep them low in cases like this one, to
1900     // increase the likelihood of the full refund coming into effect.
1901     uint256 private constant _NOT_ENTERED = 1;
1902     uint256 private constant _ENTERED = 2;
1903 
1904     uint256 private _status;
1905 
1906     constructor() {
1907         _status = _NOT_ENTERED;
1908     }
1909 
1910     /**
1911      * @dev Prevents a contract from calling itself, directly or indirectly.
1912      * Calling a `nonReentrant` function from another `nonReentrant`
1913      * function is not supported. It is possible to prevent this from happening
1914      * by making the `nonReentrant` function external, and making it call a
1915      * `private` function that does the actual work.
1916      */
1917     modifier nonReentrant() {
1918         _nonReentrantBefore();
1919         _;
1920         _nonReentrantAfter();
1921     }
1922 
1923     function _nonReentrantBefore() private {
1924         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1925         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1926 
1927         // Any calls to nonReentrant after this point will fail
1928         _status = _ENTERED;
1929     }
1930 
1931     function _nonReentrantAfter() private {
1932         // By storing the original value once again, a refund is triggered (see
1933         // https://eips.ethereum.org/EIPS/eip-2200)
1934         _status = _NOT_ENTERED;
1935     }
1936 }
1937 
1938 // File: @openzeppelin/contracts/utils/Context.sol
1939 
1940 
1941 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1942 
1943 pragma solidity ^0.8.0;
1944 
1945 /**
1946  * @dev Provides information about the current execution context, including the
1947  * sender of the transaction and its data. While these are generally available
1948  * via msg.sender and msg.data, they should not be accessed in such a direct
1949  * manner, since when dealing with meta-transactions the account sending and
1950  * paying for execution may not be the actual sender (as far as an application
1951  * is concerned).
1952  *
1953  * This contract is only required for intermediate, library-like contracts.
1954  */
1955 abstract contract Context {
1956     function _msgSender() internal view virtual returns (address) {
1957         return msg.sender;
1958     }
1959 
1960     function _msgData() internal view virtual returns (bytes calldata) {
1961         return msg.data;
1962     }
1963 }
1964 
1965 // File: @openzeppelin/contracts/access/Ownable.sol
1966 
1967 
1968 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1969 
1970 pragma solidity ^0.8.0;
1971 
1972 
1973 /**
1974  * @dev Contract module which provides a basic access control mechanism, where
1975  * there is an account (an owner) that can be granted exclusive access to
1976  * specific functions.
1977  *
1978  * By default, the owner account will be the one that deploys the contract. This
1979  * can later be changed with {transferOwnership}.
1980  *
1981  * This module is used through inheritance. It will make available the modifier
1982  * `onlyOwner`, which can be applied to your functions to restrict their use to
1983  * the owner.
1984  */
1985 abstract contract Ownable is Context {
1986     address private _owner;
1987 
1988     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1989 
1990     /**
1991      * @dev Initializes the contract setting the deployer as the initial owner.
1992      */
1993     constructor() {
1994         _transferOwnership(_msgSender());
1995     }
1996 
1997     /**
1998      * @dev Throws if called by any account other than the owner.
1999      */
2000     modifier onlyOwner() {
2001         _checkOwner();
2002         _;
2003     }
2004 
2005     /**
2006      * @dev Returns the address of the current owner.
2007      */
2008     function owner() public view virtual returns (address) {
2009         return _owner;
2010     }
2011 
2012     /**
2013      * @dev Throws if the sender is not the owner.
2014      */
2015     function _checkOwner() internal view virtual {
2016         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2017     }
2018 
2019     /**
2020      * @dev Leaves the contract without owner. It will not be possible to call
2021      * `onlyOwner` functions anymore. Can only be called by the current owner.
2022      *
2023      * NOTE: Renouncing ownership will leave the contract without an owner,
2024      * thereby removing any functionality that is only available to the owner.
2025      */
2026     function renounceOwnership() public virtual onlyOwner {
2027         _transferOwnership(address(0));
2028     }
2029 
2030     /**
2031      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2032      * Can only be called by the current owner.
2033      */
2034     function transferOwnership(address newOwner) public virtual onlyOwner {
2035         require(newOwner != address(0), "Ownable: new owner is the zero address");
2036         _transferOwnership(newOwner);
2037     }
2038 
2039     /**
2040      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2041      * Internal function without access restriction.
2042      */
2043     function _transferOwnership(address newOwner) internal virtual {
2044         address oldOwner = _owner;
2045         _owner = newOwner;
2046         emit OwnershipTransferred(oldOwner, newOwner);
2047     }
2048 }
2049 
2050 // File: LuckyGreenWitch.sol
2051 
2052 //SPDX-License-Identifier: MIT
2053 pragma solidity ^0.8.17;
2054 
2055 // Lucky Green Witch project
2056 
2057 
2058 
2059 
2060 
2061 
2062 contract LuckyGreenWitch is ERC721A, Ownable, ReentrancyGuard, ERC721AQueryable {  
2063 
2064     string private _tokenBaseURI = '';
2065 
2066     uint64 private MAX_SUPPLY = 9000;
2067     uint64 private MAX_PER_WALLET = 11;
2068     uint64 private MAX_PER_MINT = 11;
2069     uint64 private MERKLE_RESERVED = 1000;
2070     bool public isOpen = false;
2071     bool public isShopOpen = false;
2072     string private _tokenWithAddonURI = '';
2073     uint private addonPurchasePrice = 0 ether;
2074 
2075     mapping(uint64 => uint64) public hasAddon;                  
2076     uint64[] private addonsAvailability;                        
2077     mapping(uint64 => string) private onIpfs;                   
2078     mapping(uint64 => uint) private witchDNA;    
2079 
2080     constructor() ERC721A("LuckyGreenWitch", "LGW") {
2081         _safeMint(_msgSender(), 22);  // reserved for owners   
2082         _safeMint(_msgSender(), 22);  // reserved for team  
2083         _safeMint(_msgSender(), 22);  // reserved for donors  
2084     }
2085 
2086     function mint(uint64 quantity) external {  
2087 
2088         require(isOpen, "Minting not open");
2089         require(msg.sender == tx.origin, "No bots");
2090         require(quantity < MAX_PER_MINT, "Too many per mint");
2091         require(quantity > 0, "Zero mint");
2092         require((_numberMinted(_msgSender()) + quantity) < MAX_PER_WALLET, "Too many per wallet");
2093         require((_totalMinted() + quantity) <= MAX_SUPPLY, "Out of Witches");
2094 
2095         _safeMint(_msgSender(), quantity);            
2096     }
2097 
2098     function tokenURI(uint256 _tokenId) public view override(ERC721A, IERC721A) returns (string memory) {
2099 
2100         if (hasAddon[uint64(_tokenId)] > 0) {
2101             string memory ipfsAddress = onIpfs[uint64(_tokenId)];
2102             if (bytes(ipfsAddress).length > 0) {
2103                 return ipfsAddress;
2104             } else {
2105                 return bytes(_tokenWithAddonURI).length != 0 ? string(abi.encodePacked(_tokenWithAddonURI, _toString(_tokenId))) : '';
2106             }
2107         }
2108 
2109         return super.tokenURI(_tokenId);
2110     }
2111 
2112     function setAddonURI(string memory _URI) public onlyOwner {
2113         _tokenWithAddonURI = _URI;
2114     }
2115 
2116     function setBaseURI(string memory _URI) public onlyOwner {
2117         _tokenBaseURI = _URI;
2118     }
2119 
2120     function _baseURI() internal view virtual override returns (string memory) {
2121         return _tokenBaseURI;
2122     }
2123 
2124     function _startTokenId() internal view virtual override returns (uint256) {
2125         return 1;
2126     }
2127 
2128     function putOnIpfs(uint64 _tokenId, string memory _address) public onlyOwner {
2129         require(_exists(_tokenId), "Token does not exist");
2130         require(hasAddon[_tokenId] != 0, "Token has no addon");
2131         onIpfs[_tokenId] = _address;
2132     }
2133 
2134     uint cntRnd = 100;
2135     function random(uint _l) private returns (uint256) {
2136         ++cntRnd;
2137         uint rnd = uint(keccak256(abi.encodePacked(cntRnd, block.difficulty, msg.sender)));
2138         return rnd % _l;
2139     }
2140 
2141     function withdraw() public onlyOwner {
2142         address payable to = payable(msg.sender);
2143         to.transfer(address(this).balance);
2144     }
2145 
2146     function setAddonPrice(uint256 _newPrice) public onlyOwner {
2147         addonPurchasePrice = _newPrice;
2148     }
2149 
2150     function decreaseMaxSupply(uint64 _maxSupply) public onlyOwner {
2151         require(_maxSupply <= 10000, "Cannot increase max supply");
2152         require(_maxSupply >= _totalMinted() , "Too small");
2153         MAX_SUPPLY = _maxSupply;
2154     }
2155 
2156     function setMaxMintAmount(uint64 _newMaxMintAmount) public onlyOwner {
2157         MAX_PER_MINT = _newMaxMintAmount;
2158     }
2159 
2160     function setMaxPerWallet(uint64 _newMaxPerWallet) public onlyOwner {
2161         MAX_PER_WALLET = _newMaxPerWallet;
2162     }
2163 
2164     function setIsOpen(bool _isOpen) external onlyOwner {
2165         isOpen = _isOpen;
2166     }
2167 
2168     function setIsShopOpen(bool _isShopOpen) external onlyOwner {
2169         isShopOpen = _isShopOpen;
2170     }
2171 
2172     event AddonPurchased(address indexed purchaser, uint64 indexed selectedAddonId, uint64 indexed _tokenId);
2173 
2174     function purchaseAddon(uint64 _tokenId) public payable nonReentrant {
2175 
2176         uint256 length = addonsAvailability.length;
2177         require(isShopOpen, "Shop is not open");
2178         require(msg.sender == tx.origin, "No bots");
2179         require(length > 0 , "Addons sold out");
2180         require(_exists(_tokenId), "Witch does not exist");
2181         require(hasAddon[_tokenId] == 0, "Witch already has addon");
2182         require(msg.value >= addonPurchasePrice , "Insufficient funds");
2183 
2184         uint256 rnd = random(length);
2185         addonPurchasePrice += 0.00666 ether;
2186 
2187         uint64 selectedAddonId = addonsAvailability[rnd];
2188 
2189         addonsAvailability[rnd] = addonsAvailability[length - 1];
2190         addonsAvailability.pop();
2191 
2192         hasAddon[_tokenId] = selectedAddonId;
2193         emit AddonPurchased(_msgSender(), selectedAddonId, _tokenId);
2194     }
2195 
2196     event AddonTransfered(uint64 indexed _tokenIdFrom, uint64 indexed _tokenIdTo);
2197 
2198     function transferAddon(uint64 _tokenIdFrom, uint64 _tokenIdTo) public nonReentrant {
2199         require(isShopOpen, "Not open to transfers");
2200         require(_exists(_tokenIdFrom), "Witch does not exist");
2201         require(_exists(_tokenIdTo), "Witch does not exist");
2202         require(hasAddon[_tokenIdFrom] != 0, "Witch has no addon");
2203         require(hasAddon[_tokenIdTo] == 0, "Witch already has addon");
2204 
2205         address tokenOwner = super.ownerOf(_tokenIdFrom);
2206         require (_msgSender() == tokenOwner, "Not owner");
2207 
2208         uint64 addonId = hasAddon[_tokenIdFrom];
2209         delete hasAddon[_tokenIdFrom];
2210         delete onIpfs[_tokenIdFrom];
2211         delete onIpfs[_tokenIdTo];
2212         hasAddon[_tokenIdTo] = addonId; 
2213         emit AddonTransfered(_tokenIdFrom, _tokenIdTo);
2214     }
2215 
2216     function getAddonPrice() public view returns (uint) {
2217         return addonPurchasePrice;
2218     }
2219 
2220     function setAddons(uint[] memory _addons) public onlyOwner {
2221         delete addonsAvailability;
2222         uint l = _addons.length;
2223         for (uint i = 0; i < l; i++){
2224             addonsAvailability.push(uint64(_addons[i]));
2225         }
2226     }   
2227 
2228     function getAddons() public view returns (uint64[] memory){
2229         return addonsAvailability;
2230     } 
2231 
2232     function setDNA(uint64 _tokenId) public {
2233 
2234         require(_exists(_tokenId), "Witch does not exist");
2235         require(witchDNA[_tokenId] == 0, "DNA exists");
2236 
2237         witchDNA[_tokenId] = random(1000000000000000);
2238     }   
2239 
2240     function getDNA(uint64 _tokenId) public view returns (uint) {
2241         return witchDNA[_tokenId];
2242     }  
2243    
2244     bytes32 public merkleRoot = 0x696d2a47d6f9de5197eda8dad4f27b1ced42aed75adc8fe38540f96c3c6f53de;
2245     
2246     mapping(address => bool) public claimed;
2247 
2248     function checkValidity(bytes32[] calldata _merkleProof) public view returns (bool){
2249         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2250         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Incorrect proof");
2251         return true;
2252     }
2253 
2254     function mintMerkle(bytes32[] calldata merkleProof) public {
2255         require(isOpen, "Minting not open");
2256         require(claimed[msg.sender] == false, "Already claimed");
2257         require((_totalMinted() + 1) <= MERKLE_RESERVED, "Out of Witches");
2258         claimed[msg.sender] = true;
2259         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2260         require(MerkleProof.verify(merkleProof, merkleRoot, leaf) == true, "Invalid merkle proof");
2261 
2262         _safeMint(_msgSender(), 1);            
2263     }
2264 
2265     function setMerkleRoot(bytes32 _root) external onlyOwner {
2266         merkleRoot = _root;
2267     }
2268 
2269     function setMerkleReserved(uint64 _maxM) public onlyOwner {
2270         require((MAX_SUPPLY + _maxM) <= 10000, "Cannot increase");
2271         MERKLE_RESERVED = _maxM;
2272     }
2273   
2274 }