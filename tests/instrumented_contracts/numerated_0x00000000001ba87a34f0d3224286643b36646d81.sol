1 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
2 
3 
4 // ERC721A Contracts v4.2.2
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
286 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
287 
288 
289 // ERC721A Contracts v4.2.2
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
1066                 for {
1067                     let tokenId := add(startTokenId, 1)
1068                 } iszero(eq(tokenId, end)) {
1069                     tokenId := add(tokenId, 1)
1070                 } {
1071                     // Emit the `Transfer` event. Similar to above.
1072                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1073                 }
1074             }
1075             if (toMasked == 0) revert MintToZeroAddress();
1076 
1077             _currentIndex = end;
1078         }
1079         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1080     }
1081 
1082     /**
1083      * @dev Mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * This function is intended for efficient minting only during contract creation.
1086      *
1087      * It emits only one {ConsecutiveTransfer} as defined in
1088      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1089      * instead of a sequence of {Transfer} event(s).
1090      *
1091      * Calling this function outside of contract creation WILL make your contract
1092      * non-compliant with the ERC721 standard.
1093      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1094      * {ConsecutiveTransfer} event is only permissible during contract creation.
1095      *
1096      * Requirements:
1097      *
1098      * - `to` cannot be the zero address.
1099      * - `quantity` must be greater than 0.
1100      *
1101      * Emits a {ConsecutiveTransfer} event.
1102      */
1103     function _mintERC2309(address to, uint256 quantity) internal virtual {
1104         uint256 startTokenId = _currentIndex;
1105         if (to == address(0)) revert MintToZeroAddress();
1106         if (quantity == 0) revert MintZeroQuantity();
1107         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1108 
1109         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1110 
1111         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1112         unchecked {
1113             // Updates:
1114             // - `balance += quantity`.
1115             // - `numberMinted += quantity`.
1116             //
1117             // We can directly add to the `balance` and `numberMinted`.
1118             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1119 
1120             // Updates:
1121             // - `address` to the owner.
1122             // - `startTimestamp` to the timestamp of minting.
1123             // - `burned` to `false`.
1124             // - `nextInitialized` to `quantity == 1`.
1125             _packedOwnerships[startTokenId] = _packOwnershipData(
1126                 to,
1127                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1128             );
1129 
1130             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1131 
1132             _currentIndex = startTokenId + quantity;
1133         }
1134         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1135     }
1136 
1137     /**
1138      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1139      *
1140      * Requirements:
1141      *
1142      * - If `to` refers to a smart contract, it must implement
1143      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1144      * - `quantity` must be greater than 0.
1145      *
1146      * See {_mint}.
1147      *
1148      * Emits a {Transfer} event for each mint.
1149      */
1150     function _safeMint(
1151         address to,
1152         uint256 quantity,
1153         bytes memory _data
1154     ) internal virtual {
1155         _mint(to, quantity);
1156 
1157         unchecked {
1158             if (to.code.length != 0) {
1159                 uint256 end = _currentIndex;
1160                 uint256 index = end - quantity;
1161                 do {
1162                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1163                         revert TransferToNonERC721ReceiverImplementer();
1164                     }
1165                 } while (index < end);
1166                 // Reentrancy protection.
1167                 if (_currentIndex != end) revert();
1168             }
1169         }
1170     }
1171 
1172     /**
1173      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1174      */
1175     function _safeMint(address to, uint256 quantity) internal virtual {
1176         _safeMint(to, quantity, '');
1177     }
1178 
1179     // =============================================================
1180     //                        BURN OPERATIONS
1181     // =============================================================
1182 
1183     /**
1184      * @dev Equivalent to `_burn(tokenId, false)`.
1185      */
1186     function _burn(uint256 tokenId) internal virtual {
1187         _burn(tokenId, false);
1188     }
1189 
1190     /**
1191      * @dev Destroys `tokenId`.
1192      * The approval is cleared when the token is burned.
1193      *
1194      * Requirements:
1195      *
1196      * - `tokenId` must exist.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1201         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1202 
1203         address from = address(uint160(prevOwnershipPacked));
1204 
1205         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1206 
1207         if (approvalCheck) {
1208             // The nested ifs save around 20+ gas over a compound boolean condition.
1209             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1210                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1211         }
1212 
1213         _beforeTokenTransfers(from, address(0), tokenId, 1);
1214 
1215         // Clear approvals from the previous owner.
1216         assembly {
1217             if approvedAddress {
1218                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1219                 sstore(approvedAddressSlot, 0)
1220             }
1221         }
1222 
1223         // Underflow of the sender's balance is impossible because we check for
1224         // ownership above and the recipient's balance can't realistically overflow.
1225         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1226         unchecked {
1227             // Updates:
1228             // - `balance -= 1`.
1229             // - `numberBurned += 1`.
1230             //
1231             // We can directly decrement the balance, and increment the number burned.
1232             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1233             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1234 
1235             // Updates:
1236             // - `address` to the last owner.
1237             // - `startTimestamp` to the timestamp of burning.
1238             // - `burned` to `true`.
1239             // - `nextInitialized` to `true`.
1240             _packedOwnerships[tokenId] = _packOwnershipData(
1241                 from,
1242                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1243             );
1244 
1245             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1246             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1247                 uint256 nextTokenId = tokenId + 1;
1248                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1249                 if (_packedOwnerships[nextTokenId] == 0) {
1250                     // If the next slot is within bounds.
1251                     if (nextTokenId != _currentIndex) {
1252                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1253                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1254                     }
1255                 }
1256             }
1257         }
1258 
1259         emit Transfer(from, address(0), tokenId);
1260         _afterTokenTransfers(from, address(0), tokenId, 1);
1261 
1262         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1263         unchecked {
1264             _burnCounter++;
1265         }
1266     }
1267 
1268     // =============================================================
1269     //                     EXTRA DATA OPERATIONS
1270     // =============================================================
1271 
1272     /**
1273      * @dev Directly sets the extra data for the ownership data `index`.
1274      */
1275     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1276         uint256 packed = _packedOwnerships[index];
1277         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1278         uint256 extraDataCasted;
1279         // Cast `extraData` with assembly to avoid redundant masking.
1280         assembly {
1281             extraDataCasted := extraData
1282         }
1283         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1284         _packedOwnerships[index] = packed;
1285     }
1286 
1287     /**
1288      * @dev Called during each token transfer to set the 24bit `extraData` field.
1289      * Intended to be overridden by the cosumer contract.
1290      *
1291      * `previousExtraData` - the value of `extraData` before transfer.
1292      *
1293      * Calling conditions:
1294      *
1295      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1296      * transferred to `to`.
1297      * - When `from` is zero, `tokenId` will be minted for `to`.
1298      * - When `to` is zero, `tokenId` will be burned by `from`.
1299      * - `from` and `to` are never both zero.
1300      */
1301     function _extraData(
1302         address from,
1303         address to,
1304         uint24 previousExtraData
1305     ) internal view virtual returns (uint24) {}
1306 
1307     /**
1308      * @dev Returns the next extra data for the packed ownership data.
1309      * The returned result is shifted into position.
1310      */
1311     function _nextExtraData(
1312         address from,
1313         address to,
1314         uint256 prevOwnershipPacked
1315     ) private view returns (uint256) {
1316         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1317         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1318     }
1319 
1320     // =============================================================
1321     //                       OTHER OPERATIONS
1322     // =============================================================
1323 
1324     /**
1325      * @dev Returns the message sender (defaults to `msg.sender`).
1326      *
1327      * If you are writing GSN compatible contracts, you need to override this function.
1328      */
1329     function _msgSenderERC721A() internal view virtual returns (address) {
1330         return msg.sender;
1331     }
1332 
1333     /**
1334      * @dev Converts a uint256 to its ASCII string decimal representation.
1335      */
1336     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1337         assembly {
1338             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1339             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1340             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1341             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1342             let m := add(mload(0x40), 0xa0)
1343             // Update the free memory pointer to allocate.
1344             mstore(0x40, m)
1345             // Assign the `str` to the end.
1346             str := sub(m, 0x20)
1347             // Zeroize the slot after the string.
1348             mstore(str, 0)
1349 
1350             // Cache the end of the memory to calculate the length later.
1351             let end := str
1352 
1353             // We write the string from rightmost digit to leftmost digit.
1354             // The following is essentially a do-while loop that also handles the zero case.
1355             // prettier-ignore
1356             for { let temp := value } 1 {} {
1357                 str := sub(str, 1)
1358                 // Write the character to the pointer.
1359                 // The ASCII index of the '0' character is 48.
1360                 mstore8(str, add(48, mod(temp, 10)))
1361                 // Keep dividing `temp` until zero.
1362                 temp := div(temp, 10)
1363                 // prettier-ignore
1364                 if iszero(temp) { break }
1365             }
1366 
1367             let length := sub(end, str)
1368             // Move the pointer 32 bytes leftwards to make room for the length.
1369             str := sub(str, 0x20)
1370             // Store the length.
1371             mstore(str, length)
1372         }
1373     }
1374 }
1375 
1376 // File: @openzeppelin/contracts/utils/Strings.sol
1377 
1378 
1379 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1380 
1381 pragma solidity ^0.8.0;
1382 
1383 /**
1384  * @dev String operations.
1385  */
1386 library Strings {
1387     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1388     uint8 private constant _ADDRESS_LENGTH = 20;
1389 
1390     /**
1391      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1392      */
1393     function toString(uint256 value) internal pure returns (string memory) {
1394         // Inspired by OraclizeAPI's implementation - MIT licence
1395         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1396 
1397         if (value == 0) {
1398             return "0";
1399         }
1400         uint256 temp = value;
1401         uint256 digits;
1402         while (temp != 0) {
1403             digits++;
1404             temp /= 10;
1405         }
1406         bytes memory buffer = new bytes(digits);
1407         while (value != 0) {
1408             digits -= 1;
1409             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1410             value /= 10;
1411         }
1412         return string(buffer);
1413     }
1414 
1415     /**
1416      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1417      */
1418     function toHexString(uint256 value) internal pure returns (string memory) {
1419         if (value == 0) {
1420             return "0x00";
1421         }
1422         uint256 temp = value;
1423         uint256 length = 0;
1424         while (temp != 0) {
1425             length++;
1426             temp >>= 8;
1427         }
1428         return toHexString(value, length);
1429     }
1430 
1431     /**
1432      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1433      */
1434     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1435         bytes memory buffer = new bytes(2 * length + 2);
1436         buffer[0] = "0";
1437         buffer[1] = "x";
1438         for (uint256 i = 2 * length + 1; i > 1; --i) {
1439             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1440             value >>= 4;
1441         }
1442         require(value == 0, "Strings: hex length insufficient");
1443         return string(buffer);
1444     }
1445 
1446     /**
1447      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1448      */
1449     function toHexString(address addr) internal pure returns (string memory) {
1450         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1451     }
1452 }
1453 
1454 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1455 
1456 
1457 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
1458 
1459 pragma solidity ^0.8.0;
1460 
1461 
1462 /**
1463  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1464  *
1465  * These functions can be used to verify that a message was signed by the holder
1466  * of the private keys of a given address.
1467  */
1468 library ECDSA {
1469     enum RecoverError {
1470         NoError,
1471         InvalidSignature,
1472         InvalidSignatureLength,
1473         InvalidSignatureS,
1474         InvalidSignatureV
1475     }
1476 
1477     function _throwError(RecoverError error) private pure {
1478         if (error == RecoverError.NoError) {
1479             return; // no error: do nothing
1480         } else if (error == RecoverError.InvalidSignature) {
1481             revert("ECDSA: invalid signature");
1482         } else if (error == RecoverError.InvalidSignatureLength) {
1483             revert("ECDSA: invalid signature length");
1484         } else if (error == RecoverError.InvalidSignatureS) {
1485             revert("ECDSA: invalid signature 's' value");
1486         } else if (error == RecoverError.InvalidSignatureV) {
1487             revert("ECDSA: invalid signature 'v' value");
1488         }
1489     }
1490 
1491     /**
1492      * @dev Returns the address that signed a hashed message (`hash`) with
1493      * `signature` or error string. This address can then be used for verification purposes.
1494      *
1495      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1496      * this function rejects them by requiring the `s` value to be in the lower
1497      * half order, and the `v` value to be either 27 or 28.
1498      *
1499      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1500      * verification to be secure: it is possible to craft signatures that
1501      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1502      * this is by receiving a hash of the original message (which may otherwise
1503      * be too long), and then calling {toEthSignedMessageHash} on it.
1504      *
1505      * Documentation for signature generation:
1506      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1507      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1508      *
1509      * _Available since v4.3._
1510      */
1511     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1512         if (signature.length == 65) {
1513             bytes32 r;
1514             bytes32 s;
1515             uint8 v;
1516             // ecrecover takes the signature parameters, and the only way to get them
1517             // currently is to use assembly.
1518             /// @solidity memory-safe-assembly
1519             assembly {
1520                 r := mload(add(signature, 0x20))
1521                 s := mload(add(signature, 0x40))
1522                 v := byte(0, mload(add(signature, 0x60)))
1523             }
1524             return tryRecover(hash, v, r, s);
1525         } else {
1526             return (address(0), RecoverError.InvalidSignatureLength);
1527         }
1528     }
1529 
1530     /**
1531      * @dev Returns the address that signed a hashed message (`hash`) with
1532      * `signature`. This address can then be used for verification purposes.
1533      *
1534      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1535      * this function rejects them by requiring the `s` value to be in the lower
1536      * half order, and the `v` value to be either 27 or 28.
1537      *
1538      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1539      * verification to be secure: it is possible to craft signatures that
1540      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1541      * this is by receiving a hash of the original message (which may otherwise
1542      * be too long), and then calling {toEthSignedMessageHash} on it.
1543      */
1544     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1545         (address recovered, RecoverError error) = tryRecover(hash, signature);
1546         _throwError(error);
1547         return recovered;
1548     }
1549 
1550     /**
1551      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1552      *
1553      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1554      *
1555      * _Available since v4.3._
1556      */
1557     function tryRecover(
1558         bytes32 hash,
1559         bytes32 r,
1560         bytes32 vs
1561     ) internal pure returns (address, RecoverError) {
1562         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1563         uint8 v = uint8((uint256(vs) >> 255) + 27);
1564         return tryRecover(hash, v, r, s);
1565     }
1566 
1567     /**
1568      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1569      *
1570      * _Available since v4.2._
1571      */
1572     function recover(
1573         bytes32 hash,
1574         bytes32 r,
1575         bytes32 vs
1576     ) internal pure returns (address) {
1577         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1578         _throwError(error);
1579         return recovered;
1580     }
1581 
1582     /**
1583      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1584      * `r` and `s` signature fields separately.
1585      *
1586      * _Available since v4.3._
1587      */
1588     function tryRecover(
1589         bytes32 hash,
1590         uint8 v,
1591         bytes32 r,
1592         bytes32 s
1593     ) internal pure returns (address, RecoverError) {
1594         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1595         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1596         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1597         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1598         //
1599         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1600         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1601         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1602         // these malleable signatures as well.
1603         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1604             return (address(0), RecoverError.InvalidSignatureS);
1605         }
1606         if (v != 27 && v != 28) {
1607             return (address(0), RecoverError.InvalidSignatureV);
1608         }
1609 
1610         // If the signature is valid (and not malleable), return the signer address
1611         address signer = ecrecover(hash, v, r, s);
1612         if (signer == address(0)) {
1613             return (address(0), RecoverError.InvalidSignature);
1614         }
1615 
1616         return (signer, RecoverError.NoError);
1617     }
1618 
1619     /**
1620      * @dev Overload of {ECDSA-recover} that receives the `v`,
1621      * `r` and `s` signature fields separately.
1622      */
1623     function recover(
1624         bytes32 hash,
1625         uint8 v,
1626         bytes32 r,
1627         bytes32 s
1628     ) internal pure returns (address) {
1629         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1630         _throwError(error);
1631         return recovered;
1632     }
1633 
1634     /**
1635      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1636      * produces hash corresponding to the one signed with the
1637      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1638      * JSON-RPC method as part of EIP-191.
1639      *
1640      * See {recover}.
1641      */
1642     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1643         // 32 is the length in bytes of hash,
1644         // enforced by the type signature above
1645         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1646     }
1647 
1648     /**
1649      * @dev Returns an Ethereum Signed Message, created from `s`. This
1650      * produces hash corresponding to the one signed with the
1651      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1652      * JSON-RPC method as part of EIP-191.
1653      *
1654      * See {recover}.
1655      */
1656     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1657         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1658     }
1659 
1660     /**
1661      * @dev Returns an Ethereum Signed Typed Data, created from a
1662      * `domainSeparator` and a `structHash`. This produces hash corresponding
1663      * to the one signed with the
1664      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1665      * JSON-RPC method as part of EIP-712.
1666      *
1667      * See {recover}.
1668      */
1669     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1670         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1671     }
1672 }
1673 
1674 // File: @openzeppelin/contracts/utils/Context.sol
1675 
1676 
1677 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1678 
1679 pragma solidity ^0.8.0;
1680 
1681 /**
1682  * @dev Provides information about the current execution context, including the
1683  * sender of the transaction and its data. While these are generally available
1684  * via msg.sender and msg.data, they should not be accessed in such a direct
1685  * manner, since when dealing with meta-transactions the account sending and
1686  * paying for execution may not be the actual sender (as far as an application
1687  * is concerned).
1688  *
1689  * This contract is only required for intermediate, library-like contracts.
1690  */
1691 abstract contract Context {
1692     function _msgSender() internal view virtual returns (address) {
1693         return msg.sender;
1694     }
1695 
1696     function _msgData() internal view virtual returns (bytes calldata) {
1697         return msg.data;
1698     }
1699 }
1700 
1701 // File: @openzeppelin/contracts/access/Ownable.sol
1702 
1703 
1704 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1705 
1706 pragma solidity ^0.8.0;
1707 
1708 
1709 /**
1710  * @dev Contract module which provides a basic access control mechanism, where
1711  * there is an account (an owner) that can be granted exclusive access to
1712  * specific functions.
1713  *
1714  * By default, the owner account will be the one that deploys the contract. This
1715  * can later be changed with {transferOwnership}.
1716  *
1717  * This module is used through inheritance. It will make available the modifier
1718  * `onlyOwner`, which can be applied to your functions to restrict their use to
1719  * the owner.
1720  */
1721 abstract contract Ownable is Context {
1722     address private _owner;
1723 
1724     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1725 
1726     /**
1727      * @dev Initializes the contract setting the deployer as the initial owner.
1728      */
1729     constructor() {
1730         _transferOwnership(_msgSender());
1731     }
1732 
1733     /**
1734      * @dev Throws if called by any account other than the owner.
1735      */
1736     modifier onlyOwner() {
1737         _checkOwner();
1738         _;
1739     }
1740 
1741     /**
1742      * @dev Returns the address of the current owner.
1743      */
1744     function owner() public view virtual returns (address) {
1745         return _owner;
1746     }
1747 
1748     /**
1749      * @dev Throws if the sender is not the owner.
1750      */
1751     function _checkOwner() internal view virtual {
1752         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1753     }
1754 
1755     /**
1756      * @dev Leaves the contract without owner. It will not be possible to call
1757      * `onlyOwner` functions anymore. Can only be called by the current owner.
1758      *
1759      * NOTE: Renouncing ownership will leave the contract without an owner,
1760      * thereby removing any functionality that is only available to the owner.
1761      */
1762     function renounceOwnership() public virtual onlyOwner {
1763         _transferOwnership(address(0));
1764     }
1765 
1766     /**
1767      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1768      * Can only be called by the current owner.
1769      */
1770     function transferOwnership(address newOwner) public virtual onlyOwner {
1771         require(newOwner != address(0), "Ownable: new owner is the zero address");
1772         _transferOwnership(newOwner);
1773     }
1774 
1775     /**
1776      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1777      * Internal function without access restriction.
1778      */
1779     function _transferOwnership(address newOwner) internal virtual {
1780         address oldOwner = _owner;
1781         _owner = newOwner;
1782         emit OwnershipTransferred(oldOwner, newOwner);
1783     }
1784 }
1785 
1786 // File: contracts/dungeonized.sol
1787 
1788 //SPDX-License-Identifier: UNLICENSE
1789 pragma solidity ^0.8.7;
1790 
1791 
1792 
1793 
1794 
1795 /* 
1796     "Infinite" mints on founders
1797     2 maximum mints per wallet (whitelist and public)
1798     3333 NFTs maximum
1799 */
1800 
1801 contract Dungeonized is ERC721A, Ownable {
1802     using ECDSA for bytes32;
1803     using Strings for uint256;
1804 
1805     constructor(address _allowedSignerAddr, string memory baseUri) ERC721A("Dungeonized", "DGZD") {
1806         BASE_URI = baseUri;
1807         allowedSignerAddr = _allowedSignerAddr;
1808     }
1809 
1810     event RegularMint(uint256 _startTokenId, uint32 _mintCount);
1811     event FoundersMint(uint256 _startTokenId, uint32 _mintCount);
1812 
1813     string public BASE_URI;
1814     uint256 public RESERVE_AMOUNT = 25;
1815     uint256 public COLLECTION_CAP = 3333;
1816     uint256 public MAX_PUBLIC_MINTS_PER_WALLET = 2;
1817 
1818     bool public isReserveClaimed;
1819     bool public isPublicEnabled;
1820     bool public isWhitelistEnabled;
1821 
1822     address public allowedSignerAddr;
1823     mapping(uint32 => bool) usedNonces;
1824 
1825     mapping(address => uint32) publicMints;
1826     mapping(address => uint32) whitelistMints;
1827 
1828     /* Mint functions */
1829     function claimFounders(uint32 _nonce, uint32 _mintCount, bytes calldata _signature) external {
1830         require(_mintCount > 0, "CF1");
1831         require(!usedNonces[_nonce], "CF2");
1832         require(totalSupply() + _mintCount <= COLLECTION_CAP, "CF3");
1833 
1834         bytes32 hash = keccak256(abi.encodePacked('0xFF', msg.sender, _nonce, _mintCount));
1835         require(hash.recover(_signature) == allowedSignerAddr, "CF4");
1836 
1837         emit FoundersMint(_nextTokenId(), _mintCount);
1838         usedNonces[_nonce] = true;
1839         _mint(msg.sender, _mintCount);
1840     }
1841 
1842     function whitelistMint(uint32 _mintCount) external {
1843         require(isWhitelistEnabled, "CW1");
1844         require(_mintCount > 0, "CW2");
1845         require(totalSupply() + _mintCount <= COLLECTION_CAP, "CW3");
1846         require(whitelistMints[msg.sender] >= _mintCount, "CW4");
1847         unchecked {
1848             whitelistMints[msg.sender] -= _mintCount;
1849         }
1850         
1851         emit RegularMint(_nextTokenId(), _mintCount);
1852         _mint(msg.sender, _mintCount);
1853     }
1854 
1855     function mint(uint32 _mintCount) external {
1856         require(isPublicEnabled, "PM1");
1857         require(_mintCount > 0, "PM2");
1858         require(totalSupply() + _mintCount <= COLLECTION_CAP, "PM3");
1859         require(publicMints[msg.sender] + _mintCount <= MAX_PUBLIC_MINTS_PER_WALLET, "PM4");
1860 
1861         emit RegularMint(_nextTokenId(), _mintCount);
1862         publicMints[msg.sender] += _mintCount;
1863         _mint(msg.sender, _mintCount);
1864     }
1865 
1866     function reservesMint() onlyOwner external {
1867         require(!isReserveClaimed, "RM1");
1868         require(totalSupply() + RESERVE_AMOUNT <= COLLECTION_CAP, "RM2");
1869 
1870         isReserveClaimed = true;
1871         _mint(msg.sender, RESERVE_AMOUNT);
1872     }
1873 
1874     /* Utils */
1875     function wasNonceUsed(uint32 _nonce) external view returns (bool) {
1876         return usedNonces[_nonce];
1877     }
1878 
1879     /* NFT Metadata */
1880     function tokenURI(uint256 _tokenId) override public view returns (string memory) {
1881         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1882         return string(abi.encodePacked(BASE_URI, _tokenId.toString()));
1883     }
1884 
1885     /* Admin */
1886     function setBaseURI(string calldata _baseUri) onlyOwner external {
1887         BASE_URI = _baseUri;
1888     }
1889 
1890     function setSignerAddress(address _signerAddr) onlyOwner external {
1891         allowedSignerAddr = _signerAddr;
1892     }
1893 
1894     function setMintStatus(bool _publicEnabled, bool _whitelistEnabled) onlyOwner external {
1895         isPublicEnabled = _publicEnabled;
1896         isWhitelistEnabled = _whitelistEnabled;
1897     }
1898 
1899     function bulkSetWhitelist(uint32 _amount, address[] calldata _addresses) onlyOwner external {
1900         for(uint256 i = 0; i < _addresses.length; i++)
1901             whitelistMints[_addresses[i]] += _amount;
1902     }
1903 }