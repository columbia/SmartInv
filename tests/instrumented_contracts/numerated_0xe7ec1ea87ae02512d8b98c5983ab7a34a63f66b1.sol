1 // File: erc721a/contracts/IERC721A.sol
2 // SPDX-License-Identifier: MIT
3 
4 // ERC721A Contracts v4.2.3
5 
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
1379 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
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
1460 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
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
1640 // File: @openzeppelin/contracts/utils/math/Math.sol
1641 
1642 
1643 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1644 
1645 pragma solidity ^0.8.0;
1646 
1647 /**
1648  * @dev Standard math utilities missing in the Solidity language.
1649  */
1650 library Math {
1651     enum Rounding {
1652         Down, // Toward negative infinity
1653         Up, // Toward infinity
1654         Zero // Toward zero
1655     }
1656 
1657     /**
1658      * @dev Returns the largest of two numbers.
1659      */
1660     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1661         return a > b ? a : b;
1662     }
1663 
1664     /**
1665      * @dev Returns the smallest of two numbers.
1666      */
1667     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1668         return a < b ? a : b;
1669     }
1670 
1671     /**
1672      * @dev Returns the average of two numbers. The result is rounded towards
1673      * zero.
1674      */
1675     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1676         // (a + b) / 2 can overflow.
1677         return (a & b) + (a ^ b) / 2;
1678     }
1679 
1680     /**
1681      * @dev Returns the ceiling of the division of two numbers.
1682      *
1683      * This differs from standard division with `/` in that it rounds up instead
1684      * of rounding down.
1685      */
1686     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1687         // (a + b - 1) / b can overflow on addition, so we distribute.
1688         return a == 0 ? 0 : (a - 1) / b + 1;
1689     }
1690 
1691     /**
1692      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1693      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1694      * with further edits by Uniswap Labs also under MIT license.
1695      */
1696     function mulDiv(
1697         uint256 x,
1698         uint256 y,
1699         uint256 denominator
1700     ) internal pure returns (uint256 result) {
1701         unchecked {
1702             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1703             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1704             // variables such that product = prod1 * 2^256 + prod0.
1705             uint256 prod0; // Least significant 256 bits of the product
1706             uint256 prod1; // Most significant 256 bits of the product
1707             assembly {
1708                 let mm := mulmod(x, y, not(0))
1709                 prod0 := mul(x, y)
1710                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1711             }
1712 
1713             // Handle non-overflow cases, 256 by 256 division.
1714             if (prod1 == 0) {
1715                 return prod0 / denominator;
1716             }
1717 
1718             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1719             require(denominator > prod1);
1720 
1721             ///////////////////////////////////////////////
1722             // 512 by 256 division.
1723             ///////////////////////////////////////////////
1724 
1725             // Make division exact by subtracting the remainder from [prod1 prod0].
1726             uint256 remainder;
1727             assembly {
1728                 // Compute remainder using mulmod.
1729                 remainder := mulmod(x, y, denominator)
1730 
1731                 // Subtract 256 bit number from 512 bit number.
1732                 prod1 := sub(prod1, gt(remainder, prod0))
1733                 prod0 := sub(prod0, remainder)
1734             }
1735 
1736             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1737             // See https://cs.stackexchange.com/q/138556/92363.
1738 
1739             // Does not overflow because the denominator cannot be zero at this stage in the function.
1740             uint256 twos = denominator & (~denominator + 1);
1741             assembly {
1742                 // Divide denominator by twos.
1743                 denominator := div(denominator, twos)
1744 
1745                 // Divide [prod1 prod0] by twos.
1746                 prod0 := div(prod0, twos)
1747 
1748                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1749                 twos := add(div(sub(0, twos), twos), 1)
1750             }
1751 
1752             // Shift in bits from prod1 into prod0.
1753             prod0 |= prod1 * twos;
1754 
1755             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1756             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1757             // four bits. That is, denominator * inv = 1 mod 2^4.
1758             uint256 inverse = (3 * denominator) ^ 2;
1759 
1760             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1761             // in modular arithmetic, doubling the correct bits in each step.
1762             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1763             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1764             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1765             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1766             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1767             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1768 
1769             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1770             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1771             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1772             // is no longer required.
1773             result = prod0 * inverse;
1774             return result;
1775         }
1776     }
1777 
1778     /**
1779      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1780      */
1781     function mulDiv(
1782         uint256 x,
1783         uint256 y,
1784         uint256 denominator,
1785         Rounding rounding
1786     ) internal pure returns (uint256) {
1787         uint256 result = mulDiv(x, y, denominator);
1788         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1789             result += 1;
1790         }
1791         return result;
1792     }
1793 
1794     /**
1795      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1796      *
1797      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1798      */
1799     function sqrt(uint256 a) internal pure returns (uint256) {
1800         if (a == 0) {
1801             return 0;
1802         }
1803 
1804         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1805         //
1806         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1807         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1808         //
1809         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1810         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1811         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1812         //
1813         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1814         uint256 result = 1 << (log2(a) >> 1);
1815 
1816         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1817         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1818         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1819         // into the expected uint128 result.
1820         unchecked {
1821             result = (result + a / result) >> 1;
1822             result = (result + a / result) >> 1;
1823             result = (result + a / result) >> 1;
1824             result = (result + a / result) >> 1;
1825             result = (result + a / result) >> 1;
1826             result = (result + a / result) >> 1;
1827             result = (result + a / result) >> 1;
1828             return min(result, a / result);
1829         }
1830     }
1831 
1832     /**
1833      * @notice Calculates sqrt(a), following the selected rounding direction.
1834      */
1835     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1836         unchecked {
1837             uint256 result = sqrt(a);
1838             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1839         }
1840     }
1841 
1842     /**
1843      * @dev Return the log in base 2, rounded down, of a positive value.
1844      * Returns 0 if given 0.
1845      */
1846     function log2(uint256 value) internal pure returns (uint256) {
1847         uint256 result = 0;
1848         unchecked {
1849             if (value >> 128 > 0) {
1850                 value >>= 128;
1851                 result += 128;
1852             }
1853             if (value >> 64 > 0) {
1854                 value >>= 64;
1855                 result += 64;
1856             }
1857             if (value >> 32 > 0) {
1858                 value >>= 32;
1859                 result += 32;
1860             }
1861             if (value >> 16 > 0) {
1862                 value >>= 16;
1863                 result += 16;
1864             }
1865             if (value >> 8 > 0) {
1866                 value >>= 8;
1867                 result += 8;
1868             }
1869             if (value >> 4 > 0) {
1870                 value >>= 4;
1871                 result += 4;
1872             }
1873             if (value >> 2 > 0) {
1874                 value >>= 2;
1875                 result += 2;
1876             }
1877             if (value >> 1 > 0) {
1878                 result += 1;
1879             }
1880         }
1881         return result;
1882     }
1883 
1884     /**
1885      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1886      * Returns 0 if given 0.
1887      */
1888     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1889         unchecked {
1890             uint256 result = log2(value);
1891             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1892         }
1893     }
1894 
1895     /**
1896      * @dev Return the log in base 10, rounded down, of a positive value.
1897      * Returns 0 if given 0.
1898      */
1899     function log10(uint256 value) internal pure returns (uint256) {
1900         uint256 result = 0;
1901         unchecked {
1902             if (value >= 10**64) {
1903                 value /= 10**64;
1904                 result += 64;
1905             }
1906             if (value >= 10**32) {
1907                 value /= 10**32;
1908                 result += 32;
1909             }
1910             if (value >= 10**16) {
1911                 value /= 10**16;
1912                 result += 16;
1913             }
1914             if (value >= 10**8) {
1915                 value /= 10**8;
1916                 result += 8;
1917             }
1918             if (value >= 10**4) {
1919                 value /= 10**4;
1920                 result += 4;
1921             }
1922             if (value >= 10**2) {
1923                 value /= 10**2;
1924                 result += 2;
1925             }
1926             if (value >= 10**1) {
1927                 result += 1;
1928             }
1929         }
1930         return result;
1931     }
1932 
1933     /**
1934      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1935      * Returns 0 if given 0.
1936      */
1937     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1938         unchecked {
1939             uint256 result = log10(value);
1940             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1941         }
1942     }
1943 
1944     /**
1945      * @dev Return the log in base 256, rounded down, of a positive value.
1946      * Returns 0 if given 0.
1947      *
1948      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1949      */
1950     function log256(uint256 value) internal pure returns (uint256) {
1951         uint256 result = 0;
1952         unchecked {
1953             if (value >> 128 > 0) {
1954                 value >>= 128;
1955                 result += 16;
1956             }
1957             if (value >> 64 > 0) {
1958                 value >>= 64;
1959                 result += 8;
1960             }
1961             if (value >> 32 > 0) {
1962                 value >>= 32;
1963                 result += 4;
1964             }
1965             if (value >> 16 > 0) {
1966                 value >>= 16;
1967                 result += 2;
1968             }
1969             if (value >> 8 > 0) {
1970                 result += 1;
1971             }
1972         }
1973         return result;
1974     }
1975 
1976     /**
1977      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1978      * Returns 0 if given 0.
1979      */
1980     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1981         unchecked {
1982             uint256 result = log256(value);
1983             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1984         }
1985     }
1986 }
1987 
1988 // File: @openzeppelin/contracts/utils/Strings.sol
1989 
1990 
1991 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1992 
1993 pragma solidity ^0.8.0;
1994 
1995 
1996 /**
1997  * @dev String operations.
1998  */
1999 library Strings {
2000     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2001     uint8 private constant _ADDRESS_LENGTH = 20;
2002 
2003     /**
2004      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2005      */
2006     function toString(uint256 value) internal pure returns (string memory) {
2007         unchecked {
2008             uint256 length = Math.log10(value) + 1;
2009             string memory buffer = new string(length);
2010             uint256 ptr;
2011             /// @solidity memory-safe-assembly
2012             assembly {
2013                 ptr := add(buffer, add(32, length))
2014             }
2015             while (true) {
2016                 ptr--;
2017                 /// @solidity memory-safe-assembly
2018                 assembly {
2019                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2020                 }
2021                 value /= 10;
2022                 if (value == 0) break;
2023             }
2024             return buffer;
2025         }
2026     }
2027 
2028     /**
2029      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2030      */
2031     function toHexString(uint256 value) internal pure returns (string memory) {
2032         unchecked {
2033             return toHexString(value, Math.log256(value) + 1);
2034         }
2035     }
2036 
2037     /**
2038      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2039      */
2040     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2041         bytes memory buffer = new bytes(2 * length + 2);
2042         buffer[0] = "0";
2043         buffer[1] = "x";
2044         for (uint256 i = 2 * length + 1; i > 1; --i) {
2045             buffer[i] = _SYMBOLS[value & 0xf];
2046             value >>= 4;
2047         }
2048         require(value == 0, "Strings: hex length insufficient");
2049         return string(buffer);
2050     }
2051 
2052     /**
2053      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2054      */
2055     function toHexString(address addr) internal pure returns (string memory) {
2056         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2057     }
2058 }
2059 
2060 // File: @openzeppelin/contracts/utils/Context.sol
2061 
2062 
2063 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2064 
2065 pragma solidity ^0.8.0;
2066 
2067 /**
2068  * @dev Provides information about the current execution context, including the
2069  * sender of the transaction and its data. While these are generally available
2070  * via msg.sender and msg.data, they should not be accessed in such a direct
2071  * manner, since when dealing with meta-transactions the account sending and
2072  * paying for execution may not be the actual sender (as far as an application
2073  * is concerned).
2074  *
2075  * This contract is only required for intermediate, library-like contracts.
2076  */
2077 abstract contract Context {
2078     function _msgSender() internal view virtual returns (address) {
2079         return msg.sender;
2080     }
2081 
2082     function _msgData() internal view virtual returns (bytes calldata) {
2083         return msg.data;
2084     }
2085 }
2086 
2087 // File: @openzeppelin/contracts/access/Ownable.sol
2088 
2089 
2090 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2091 
2092 pragma solidity ^0.8.0;
2093 
2094 
2095 /**
2096  * @dev Contract module which provides a basic access control mechanism, where
2097  * there is an account (an owner) that can be granted exclusive access to
2098  * specific functions.
2099  *
2100  * By default, the owner account will be the one that deploys the contract. This
2101  * can later be changed with {transferOwnership}.
2102  *
2103  * This module is used through inheritance. It will make available the modifier
2104  * `onlyOwner`, which can be applied to your functions to restrict their use to
2105  * the owner.
2106  */
2107 abstract contract Ownable is Context {
2108     address private _owner;
2109 
2110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2111 
2112     /**
2113      * @dev Initializes the contract setting the deployer as the initial owner.
2114      */
2115     constructor() {
2116         _transferOwnership(_msgSender());
2117     }
2118 
2119     /**
2120      * @dev Throws if called by any account other than the owner.
2121      */
2122     modifier onlyOwner() {
2123         _checkOwner();
2124         _;
2125     }
2126 
2127     /**
2128      * @dev Returns the address of the current owner.
2129      */
2130     function owner() public view virtual returns (address) {
2131         return _owner;
2132     }
2133 
2134     /**
2135      * @dev Throws if the sender is not the owner.
2136      */
2137     function _checkOwner() internal view virtual {
2138         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2139     }
2140 
2141     /**
2142      * @dev Leaves the contract without owner. It will not be possible to call
2143      * `onlyOwner` functions anymore. Can only be called by the current owner.
2144      *
2145      * NOTE: Renouncing ownership will leave the contract without an owner,
2146      * thereby removing any functionality that is only available to the owner.
2147      */
2148     function renounceOwnership() public virtual onlyOwner {
2149         _transferOwnership(address(0));
2150     }
2151 
2152     /**
2153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2154      * Can only be called by the current owner.
2155      */
2156     function transferOwnership(address newOwner) public virtual onlyOwner {
2157         require(newOwner != address(0), "Ownable: new owner is the zero address");
2158         _transferOwnership(newOwner);
2159     }
2160 
2161     /**
2162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2163      * Internal function without access restriction.
2164      */
2165     function _transferOwnership(address newOwner) internal virtual {
2166         address oldOwner = _owner;
2167         _owner = newOwner;
2168         emit OwnershipTransferred(oldOwner, newOwner);
2169     }
2170 }
2171 
2172 // File: Jimz.sol
2173 
2174 
2175 pragma solidity ^0.8.4;
2176 
2177 
2178 
2179 
2180 
2181 
2182 contract Jimz is ERC721AQueryable, Ownable {
2183   using Strings for uint256;
2184   uint256 public MAX_SUPPLY = 6543;
2185   uint256 public MAX_FREE = 6543;
2186   uint256 public maxFreeMintPerWallet = 1;
2187   uint256 public maxPublicMintPerWallet = 20;
2188   uint256 public publicTokenPrice = .003 ether;
2189   string _contractURI;
2190 
2191   bool public saleStarted = false;
2192   uint256 public freeMintCount;
2193 
2194   mapping(address => uint256) public freeMintClaimed;
2195 
2196 
2197   string private _baseTokenURI;
2198 
2199   constructor() ERC721A("Jimz", "Jimz") {
2200   _baseTokenURI = "ipfs://bafybeifaletieylazuus4umy2n5wmahcauutlx3vce4sbzbi27sfm7gpyy/";
2201   }
2202 
2203   modifier callerIsUser() {
2204     require(tx.origin == msg.sender, 'Jimz: The caller is another contract');
2205     _;
2206   }
2207 
2208   modifier underMaxSupply(uint256 _quantity) {
2209     require(
2210       _totalMinted() + _quantity <= MAX_SUPPLY,
2211       "Too many Jimz be Jamming."
2212     );
2213     _;
2214   }
2215 
2216   function setTotalMaxSupply(uint256 _newSupply) external onlyOwner {
2217       MAX_SUPPLY = _newSupply;
2218   }
2219 
2220 
2221   function setPublicTokenPrice(uint256 _newPrice) external onlyOwner {
2222       publicTokenPrice = _newPrice;
2223   }
2224   function mint(uint256 _quantity) external payable callerIsUser underMaxSupply(_quantity) {
2225     require(balanceOf(msg.sender) < maxPublicMintPerWallet, "Not enough for Jimz to Jamz.");
2226     require(saleStarted, "Sale has not started");
2227     if (_totalMinted() < (MAX_SUPPLY)) {
2228       if (freeMintCount >= MAX_FREE) {
2229         require(msg.value >= _quantity * publicTokenPrice, "Insufficient Ethereum.");
2230         _mint(msg.sender, _quantity);
2231       } else if (freeMintClaimed[msg.sender] < maxFreeMintPerWallet) {
2232         uint256 _mintableFreeQuantity = maxFreeMintPerWallet - freeMintClaimed[msg.sender];
2233         if (_quantity <= _mintableFreeQuantity) {
2234           freeMintCount += _quantity;
2235           freeMintClaimed[msg.sender] += _quantity;
2236         } else {
2237           freeMintCount += _mintableFreeQuantity;
2238           freeMintClaimed[msg.sender] += _mintableFreeQuantity;
2239           require(
2240             msg.value >= (_quantity - _mintableFreeQuantity) * publicTokenPrice,
2241             "Insufficient Ethereum."
2242           );
2243         }
2244         _mint(msg.sender, _quantity);
2245       } else {
2246         require(msg.value >= (_quantity * publicTokenPrice), "Not Enough Ethereum For Jimz.");
2247         _mint(msg.sender, _quantity);
2248       }
2249     }
2250   }
2251 
2252   function _baseURI() internal view virtual override returns (string memory) {
2253     return _baseTokenURI;
2254   }
2255 
2256   function tokenURI(uint256 tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2257     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2258 
2259     string memory baseURI = _baseURI();
2260     return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2261   }
2262 
2263   function numberMinted(address owner) public view returns (uint256) {
2264     return _numberMinted(owner);
2265   }
2266 
2267   function _startTokenId() internal view virtual override returns (uint256) {
2268     return 1;
2269   }
2270 
2271   function ownerMint(uint256 _numberToMint) external onlyOwner underMaxSupply(_numberToMint) {
2272     _mint(msg.sender, _numberToMint);
2273   }
2274 
2275   function ownerMintToAddress(address _recipient, uint256 _numberToMint)
2276     external
2277     onlyOwner
2278     underMaxSupply(_numberToMint)
2279   {
2280     _mint(_recipient, _numberToMint);
2281   }
2282 
2283   function setFreeMintCount(uint256 _count) external onlyOwner {
2284     MAX_FREE = _count;
2285   }
2286 
2287   function setMaxFreeMintPerWallet(uint256 _count) external onlyOwner {
2288     maxFreeMintPerWallet = _count;
2289   }
2290 
2291   function setMaxPublicMintPerWallet(uint256 _count) external onlyOwner {
2292     maxPublicMintPerWallet = _count;
2293   }
2294 
2295   function setBaseURI(string calldata baseURI) external onlyOwner {
2296     _baseTokenURI = baseURI;
2297   }
2298 
2299   // Storefront metadata
2300   // https://docs.opensea.io/docs/contract-level-metadata
2301   function contractURI() public view returns (string memory) {
2302     return _contractURI;
2303   }
2304 
2305   function setContractURI(string memory _URI) external onlyOwner {
2306     _contractURI = _URI;
2307   }
2308 
2309   function withdrawFunds() external onlyOwner {
2310     (bool success, ) = msg.sender.call{ value: address(this).balance }("");
2311     require(success, "Transfer failed");
2312   }
2313 
2314   function withdrawFundsToAddress(address _address, uint256 amount) external onlyOwner {
2315     (bool success, ) = _address.call{ value: amount }("");
2316     require(success, "Transfer failed");
2317   }
2318 
2319   function flipSaleStarted() external onlyOwner {
2320     saleStarted = !saleStarted;
2321   }
2322 }