1 // File: node_modules\erc721a\contracts\IERC721A.sol
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
286 // File: erc721a\contracts\ERC721A.sol
287 
288 
289 // ERC721A Contracts v4.2.3
290 // Creator: Chiru Labs
291 
292 pragma solidity ^0.8.4;
293 
294 /**
295  * @dev Interface of ERC721 token receiver.
296  */
297 interface ERC721A__IERC721Receiver {
298     function onERC721Received(
299         address operator,
300         address from,
301         uint256 tokenId,
302         bytes calldata data
303     ) external returns (bytes4);
304 }
305 
306 /**
307  * @title ERC721A
308  *
309  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
310  * Non-Fungible Token Standard, including the Metadata extension.
311  * Optimized for lower gas during batch mints.
312  *
313  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
314  * starting from `_startTokenId()`.
315  *
316  * Assumptions:
317  *
318  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
319  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
320  */
321 contract ERC721A is IERC721A {
322     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
323     struct TokenApprovalRef {
324         address value;
325     }
326 
327     // =============================================================
328     //                           CONSTANTS
329     // =============================================================
330 
331     // Mask of an entry in packed address data.
332     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
333 
334     // The bit position of `numberMinted` in packed address data.
335     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
336 
337     // The bit position of `numberBurned` in packed address data.
338     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
339 
340     // The bit position of `aux` in packed address data.
341     uint256 private constant _BITPOS_AUX = 192;
342 
343     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
344     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
345 
346     // The bit position of `startTimestamp` in packed ownership.
347     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
348 
349     // The bit mask of the `burned` bit in packed ownership.
350     uint256 private constant _BITMASK_BURNED = 1 << 224;
351 
352     // The bit position of the `nextInitialized` bit in packed ownership.
353     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
354 
355     // The bit mask of the `nextInitialized` bit in packed ownership.
356     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
357 
358     // The bit position of `extraData` in packed ownership.
359     uint256 private constant _BITPOS_EXTRA_DATA = 232;
360 
361     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
362     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
363 
364     // The mask of the lower 160 bits for addresses.
365     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
366 
367     // The maximum `quantity` that can be minted with {_mintERC2309}.
368     // This limit is to prevent overflows on the address data entries.
369     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
370     // is required to cause an overflow, which is unrealistic.
371     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
372 
373     // The `Transfer` event signature is given by:
374     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
375     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
376         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
377 
378     // =============================================================
379     //                            STORAGE
380     // =============================================================
381 
382     // The next token ID to be minted.
383     uint256 private _currentIndex;
384 
385     // The number of tokens burned.
386     uint256 private _burnCounter;
387 
388     // Token name
389     string private _name;
390 
391     // Token symbol
392     string private _symbol;
393 
394     // Mapping from token ID to ownership details
395     // An empty struct value does not necessarily mean the token is unowned.
396     // See {_packedOwnershipOf} implementation for details.
397     //
398     // Bits Layout:
399     // - [0..159]   `addr`
400     // - [160..223] `startTimestamp`
401     // - [224]      `burned`
402     // - [225]      `nextInitialized`
403     // - [232..255] `extraData`
404     mapping(uint256 => uint256) private _packedOwnerships;
405 
406     // Mapping owner address to address data.
407     //
408     // Bits Layout:
409     // - [0..63]    `balance`
410     // - [64..127]  `numberMinted`
411     // - [128..191] `numberBurned`
412     // - [192..255] `aux`
413     mapping(address => uint256) private _packedAddressData;
414 
415     // Mapping from token ID to approved address.
416     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
417 
418     // Mapping from owner to operator approvals
419     mapping(address => mapping(address => bool)) private _operatorApprovals;
420 
421     // =============================================================
422     //                          CONSTRUCTOR
423     // =============================================================
424 
425     constructor(string memory name_, string memory symbol_) {
426         _name = name_;
427         _symbol = symbol_;
428         _currentIndex = _startTokenId();
429     }
430 
431     // =============================================================
432     //                   TOKEN COUNTING OPERATIONS
433     // =============================================================
434 
435     /**
436      * @dev Returns the starting token ID.
437      * To change the starting token ID, please override this function.
438      */
439     function _startTokenId() internal view virtual returns (uint256) {
440         return 0;
441     }
442 
443     /**
444      * @dev Returns the next token ID to be minted.
445      */
446     function _nextTokenId() internal view virtual returns (uint256) {
447         return _currentIndex;
448     }
449 
450     /**
451      * @dev Returns the total number of tokens in existence.
452      * Burned tokens will reduce the count.
453      * To get the total number of tokens minted, please see {_totalMinted}.
454      */
455     function totalSupply() public view virtual override returns (uint256) {
456         // Counter underflow is impossible as _burnCounter cannot be incremented
457         // more than `_currentIndex - _startTokenId()` times.
458         unchecked {
459             return _currentIndex - _burnCounter - _startTokenId();
460         }
461     }
462 
463     /**
464      * @dev Returns the total amount of tokens minted in the contract.
465      */
466     function _totalMinted() internal view virtual returns (uint256) {
467         // Counter underflow is impossible as `_currentIndex` does not decrement,
468         // and it is initialized to `_startTokenId()`.
469         unchecked {
470             return _currentIndex - _startTokenId();
471         }
472     }
473 
474     /**
475      * @dev Returns the total number of tokens burned.
476      */
477     function _totalBurned() internal view virtual returns (uint256) {
478         return _burnCounter;
479     }
480 
481     // =============================================================
482     //                    ADDRESS DATA OPERATIONS
483     // =============================================================
484 
485     /**
486      * @dev Returns the number of tokens in `owner`'s account.
487      */
488     function balanceOf(address owner) public view virtual override returns (uint256) {
489         if (owner == address(0)) revert BalanceQueryForZeroAddress();
490         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
491     }
492 
493     /**
494      * Returns the number of tokens minted by `owner`.
495      */
496     function _numberMinted(address owner) internal view returns (uint256) {
497         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
498     }
499 
500     /**
501      * Returns the number of tokens burned by or on behalf of `owner`.
502      */
503     function _numberBurned(address owner) internal view returns (uint256) {
504         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
505     }
506 
507     /**
508      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
509      */
510     function _getAux(address owner) internal view returns (uint64) {
511         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
512     }
513 
514     /**
515      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
516      * If there are multiple variables, please pack them into a uint64.
517      */
518     function _setAux(address owner, uint64 aux) internal virtual {
519         uint256 packed = _packedAddressData[owner];
520         uint256 auxCasted;
521         // Cast `aux` with assembly to avoid redundant masking.
522         assembly {
523             auxCasted := aux
524         }
525         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
526         _packedAddressData[owner] = packed;
527     }
528 
529     // =============================================================
530     //                            IERC165
531     // =============================================================
532 
533     /**
534      * @dev Returns true if this contract implements the interface defined by
535      * `interfaceId`. See the corresponding
536      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
537      * to learn more about how these ids are created.
538      *
539      * This function call must use less than 30000 gas.
540      */
541     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
542         // The interface IDs are constants representing the first 4 bytes
543         // of the XOR of all function selectors in the interface.
544         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
545         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
546         return
547             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
548             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
549             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
550     }
551 
552     // =============================================================
553     //                        IERC721Metadata
554     // =============================================================
555 
556     /**
557      * @dev Returns the token collection name.
558      */
559     function name() public view virtual override returns (string memory) {
560         return _name;
561     }
562 
563     /**
564      * @dev Returns the token collection symbol.
565      */
566     function symbol() public view virtual override returns (string memory) {
567         return _symbol;
568     }
569 
570     /**
571      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
572      */
573     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
574         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
575 
576         string memory baseURI = _baseURI();
577         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
578     }
579 
580     /**
581      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
582      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
583      * by default, it can be overridden in child contracts.
584      */
585     function _baseURI() internal view virtual returns (string memory) {
586         return '';
587     }
588 
589     // =============================================================
590     //                     OWNERSHIPS OPERATIONS
591     // =============================================================
592 
593     /**
594      * @dev Returns the owner of the `tokenId` token.
595      *
596      * Requirements:
597      *
598      * - `tokenId` must exist.
599      */
600     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
601         return address(uint160(_packedOwnershipOf(tokenId)));
602     }
603 
604     /**
605      * @dev Gas spent here starts off proportional to the maximum mint batch size.
606      * It gradually moves to O(1) as tokens get transferred around over time.
607      */
608     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
609         return _unpackedOwnership(_packedOwnershipOf(tokenId));
610     }
611 
612     /**
613      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
614      */
615     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
616         return _unpackedOwnership(_packedOwnerships[index]);
617     }
618 
619     /**
620      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
621      */
622     function _initializeOwnershipAt(uint256 index) internal virtual {
623         if (_packedOwnerships[index] == 0) {
624             _packedOwnerships[index] = _packedOwnershipOf(index);
625         }
626     }
627 
628     /**
629      * Returns the packed ownership data of `tokenId`.
630      */
631     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
632         uint256 curr = tokenId;
633 
634         unchecked {
635             if (_startTokenId() <= curr)
636                 if (curr < _currentIndex) {
637                     uint256 packed = _packedOwnerships[curr];
638                     // If not burned.
639                     if (packed & _BITMASK_BURNED == 0) {
640                         // Invariant:
641                         // There will always be an initialized ownership slot
642                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
643                         // before an unintialized ownership slot
644                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
645                         // Hence, `curr` will not underflow.
646                         //
647                         // We can directly compare the packed value.
648                         // If the address is zero, packed will be zero.
649                         while (packed == 0) {
650                             packed = _packedOwnerships[--curr];
651                         }
652                         return packed;
653                     }
654                 }
655         }
656         revert OwnerQueryForNonexistentToken();
657     }
658 
659     /**
660      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
661      */
662     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
663         ownership.addr = address(uint160(packed));
664         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
665         ownership.burned = packed & _BITMASK_BURNED != 0;
666         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
667     }
668 
669     /**
670      * @dev Packs ownership data into a single uint256.
671      */
672     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
673         assembly {
674             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
675             owner := and(owner, _BITMASK_ADDRESS)
676             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
677             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
678         }
679     }
680 
681     /**
682      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
683      */
684     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
685         // For branchless setting of the `nextInitialized` flag.
686         assembly {
687             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
688             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
689         }
690     }
691 
692     // =============================================================
693     //                      APPROVAL OPERATIONS
694     // =============================================================
695 
696     /**
697      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
698      * The approval is cleared when the token is transferred.
699      *
700      * Only a single account can be approved at a time, so approving the
701      * zero address clears previous approvals.
702      *
703      * Requirements:
704      *
705      * - The caller must own the token or be an approved operator.
706      * - `tokenId` must exist.
707      *
708      * Emits an {Approval} event.
709      */
710     function approve(address to, uint256 tokenId) public payable virtual override {
711         address owner = ownerOf(tokenId);
712 
713         if (_msgSenderERC721A() != owner)
714             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
715                 revert ApprovalCallerNotOwnerNorApproved();
716             }
717 
718         _tokenApprovals[tokenId].value = to;
719         emit Approval(owner, to, tokenId);
720     }
721 
722     /**
723      * @dev Returns the account approved for `tokenId` token.
724      *
725      * Requirements:
726      *
727      * - `tokenId` must exist.
728      */
729     function getApproved(uint256 tokenId) public view virtual override returns (address) {
730         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
731 
732         return _tokenApprovals[tokenId].value;
733     }
734 
735     /**
736      * @dev Approve or remove `operator` as an operator for the caller.
737      * Operators can call {transferFrom} or {safeTransferFrom}
738      * for any token owned by the caller.
739      *
740      * Requirements:
741      *
742      * - The `operator` cannot be the caller.
743      *
744      * Emits an {ApprovalForAll} event.
745      */
746     function setApprovalForAll(address operator, bool approved) public virtual override {
747         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
748         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
749     }
750 
751     /**
752      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
753      *
754      * See {setApprovalForAll}.
755      */
756     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
757         return _operatorApprovals[owner][operator];
758     }
759 
760     /**
761      * @dev Returns whether `tokenId` exists.
762      *
763      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
764      *
765      * Tokens start existing when they are minted. See {_mint}.
766      */
767     function _exists(uint256 tokenId) internal view virtual returns (bool) {
768         return
769             _startTokenId() <= tokenId &&
770             tokenId < _currentIndex && // If within bounds,
771             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
772     }
773 
774     /**
775      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
776      */
777     function _isSenderApprovedOrOwner(
778         address approvedAddress,
779         address owner,
780         address msgSender
781     ) private pure returns (bool result) {
782         assembly {
783             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
784             owner := and(owner, _BITMASK_ADDRESS)
785             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
786             msgSender := and(msgSender, _BITMASK_ADDRESS)
787             // `msgSender == owner || msgSender == approvedAddress`.
788             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
789         }
790     }
791 
792     /**
793      * @dev Returns the storage slot and value for the approved address of `tokenId`.
794      */
795     function _getApprovedSlotAndAddress(uint256 tokenId)
796         private
797         view
798         returns (uint256 approvedAddressSlot, address approvedAddress)
799     {
800         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
801         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
802         assembly {
803             approvedAddressSlot := tokenApproval.slot
804             approvedAddress := sload(approvedAddressSlot)
805         }
806     }
807 
808     // =============================================================
809     //                      TRANSFER OPERATIONS
810     // =============================================================
811 
812     /**
813      * @dev Transfers `tokenId` from `from` to `to`.
814      *
815      * Requirements:
816      *
817      * - `from` cannot be the zero address.
818      * - `to` cannot be the zero address.
819      * - `tokenId` token must be owned by `from`.
820      * - If the caller is not `from`, it must be approved to move this token
821      * by either {approve} or {setApprovalForAll}.
822      *
823      * Emits a {Transfer} event.
824      */
825     function transferFrom(
826         address from,
827         address to,
828         uint256 tokenId
829     ) public payable virtual override {
830         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
831 
832         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
833 
834         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
835 
836         // The nested ifs save around 20+ gas over a compound boolean condition.
837         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
838             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
839 
840         if (to == address(0)) revert TransferToZeroAddress();
841 
842         _beforeTokenTransfers(from, to, tokenId, 1);
843 
844         // Clear approvals from the previous owner.
845         assembly {
846             if approvedAddress {
847                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
848                 sstore(approvedAddressSlot, 0)
849             }
850         }
851 
852         // Underflow of the sender's balance is impossible because we check for
853         // ownership above and the recipient's balance can't realistically overflow.
854         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
855         unchecked {
856             // We can directly increment and decrement the balances.
857             --_packedAddressData[from]; // Updates: `balance -= 1`.
858             ++_packedAddressData[to]; // Updates: `balance += 1`.
859 
860             // Updates:
861             // - `address` to the next owner.
862             // - `startTimestamp` to the timestamp of transfering.
863             // - `burned` to `false`.
864             // - `nextInitialized` to `true`.
865             _packedOwnerships[tokenId] = _packOwnershipData(
866                 to,
867                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
868             );
869 
870             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
871             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
872                 uint256 nextTokenId = tokenId + 1;
873                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
874                 if (_packedOwnerships[nextTokenId] == 0) {
875                     // If the next slot is within bounds.
876                     if (nextTokenId != _currentIndex) {
877                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
878                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
879                     }
880                 }
881             }
882         }
883 
884         emit Transfer(from, to, tokenId);
885         _afterTokenTransfers(from, to, tokenId, 1);
886     }
887 
888     /**
889      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
890      */
891     function safeTransferFrom(
892         address from,
893         address to,
894         uint256 tokenId
895     ) public payable virtual override {
896         safeTransferFrom(from, to, tokenId, '');
897     }
898 
899     /**
900      * @dev Safely transfers `tokenId` token from `from` to `to`.
901      *
902      * Requirements:
903      *
904      * - `from` cannot be the zero address.
905      * - `to` cannot be the zero address.
906      * - `tokenId` token must exist and be owned by `from`.
907      * - If the caller is not `from`, it must be approved to move this token
908      * by either {approve} or {setApprovalForAll}.
909      * - If `to` refers to a smart contract, it must implement
910      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
911      *
912      * Emits a {Transfer} event.
913      */
914     function safeTransferFrom(
915         address from,
916         address to,
917         uint256 tokenId,
918         bytes memory _data
919     ) public payable virtual override {
920         transferFrom(from, to, tokenId);
921         if (to.code.length != 0)
922             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
923                 revert TransferToNonERC721ReceiverImplementer();
924             }
925     }
926 
927     /**
928      * @dev Hook that is called before a set of serially-ordered token IDs
929      * are about to be transferred. This includes minting.
930      * And also called before burning one token.
931      *
932      * `startTokenId` - the first token ID to be transferred.
933      * `quantity` - the amount to be transferred.
934      *
935      * Calling conditions:
936      *
937      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
938      * transferred to `to`.
939      * - When `from` is zero, `tokenId` will be minted for `to`.
940      * - When `to` is zero, `tokenId` will be burned by `from`.
941      * - `from` and `to` are never both zero.
942      */
943     function _beforeTokenTransfers(
944         address from,
945         address to,
946         uint256 startTokenId,
947         uint256 quantity
948     ) internal virtual {}
949 
950     /**
951      * @dev Hook that is called after a set of serially-ordered token IDs
952      * have been transferred. This includes minting.
953      * And also called after one token has been burned.
954      *
955      * `startTokenId` - the first token ID to be transferred.
956      * `quantity` - the amount to be transferred.
957      *
958      * Calling conditions:
959      *
960      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
961      * transferred to `to`.
962      * - When `from` is zero, `tokenId` has been minted for `to`.
963      * - When `to` is zero, `tokenId` has been burned by `from`.
964      * - `from` and `to` are never both zero.
965      */
966     function _afterTokenTransfers(
967         address from,
968         address to,
969         uint256 startTokenId,
970         uint256 quantity
971     ) internal virtual {}
972 
973     /**
974      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
975      *
976      * `from` - Previous owner of the given token ID.
977      * `to` - Target address that will receive the token.
978      * `tokenId` - Token ID to be transferred.
979      * `_data` - Optional data to send along with the call.
980      *
981      * Returns whether the call correctly returned the expected magic value.
982      */
983     function _checkContractOnERC721Received(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) private returns (bool) {
989         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
990             bytes4 retval
991         ) {
992             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
993         } catch (bytes memory reason) {
994             if (reason.length == 0) {
995                 revert TransferToNonERC721ReceiverImplementer();
996             } else {
997                 assembly {
998                     revert(add(32, reason), mload(reason))
999                 }
1000             }
1001         }
1002     }
1003 
1004     // =============================================================
1005     //                        MINT OPERATIONS
1006     // =============================================================
1007 
1008     /**
1009      * @dev Mints `quantity` tokens and transfers them to `to`.
1010      *
1011      * Requirements:
1012      *
1013      * - `to` cannot be the zero address.
1014      * - `quantity` must be greater than 0.
1015      *
1016      * Emits a {Transfer} event for each mint.
1017      */
1018     function _mint(address to, uint256 quantity) internal virtual {
1019         uint256 startTokenId = _currentIndex;
1020         if (quantity == 0) revert MintZeroQuantity();
1021 
1022         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1023 
1024         // Overflows are incredibly unrealistic.
1025         // `balance` and `numberMinted` have a maximum limit of 2**64.
1026         // `tokenId` has a maximum limit of 2**256.
1027         unchecked {
1028             // Updates:
1029             // - `balance += quantity`.
1030             // - `numberMinted += quantity`.
1031             //
1032             // We can directly add to the `balance` and `numberMinted`.
1033             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1034 
1035             // Updates:
1036             // - `address` to the owner.
1037             // - `startTimestamp` to the timestamp of minting.
1038             // - `burned` to `false`.
1039             // - `nextInitialized` to `quantity == 1`.
1040             _packedOwnerships[startTokenId] = _packOwnershipData(
1041                 to,
1042                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1043             );
1044 
1045             uint256 toMasked;
1046             uint256 end = startTokenId + quantity;
1047 
1048             // Use assembly to loop and emit the `Transfer` event for gas savings.
1049             // The duplicated `log4` removes an extra check and reduces stack juggling.
1050             // The assembly, together with the surrounding Solidity code, have been
1051             // delicately arranged to nudge the compiler into producing optimized opcodes.
1052             assembly {
1053                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1054                 toMasked := and(to, _BITMASK_ADDRESS)
1055                 // Emit the `Transfer` event.
1056                 log4(
1057                     0, // Start of data (0, since no data).
1058                     0, // End of data (0, since no data).
1059                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1060                     0, // `address(0)`.
1061                     toMasked, // `to`.
1062                     startTokenId // `tokenId`.
1063                 )
1064 
1065                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1066                 // that overflows uint256 will make the loop run out of gas.
1067                 // The compiler will optimize the `iszero` away for performance.
1068                 for {
1069                     let tokenId := add(startTokenId, 1)
1070                 } iszero(eq(tokenId, end)) {
1071                     tokenId := add(tokenId, 1)
1072                 } {
1073                     // Emit the `Transfer` event. Similar to above.
1074                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1075                 }
1076             }
1077             if (toMasked == 0) revert MintToZeroAddress();
1078 
1079             _currentIndex = end;
1080         }
1081         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1082     }
1083 
1084     /**
1085      * @dev Mints `quantity` tokens and transfers them to `to`.
1086      *
1087      * This function is intended for efficient minting only during contract creation.
1088      *
1089      * It emits only one {ConsecutiveTransfer} as defined in
1090      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1091      * instead of a sequence of {Transfer} event(s).
1092      *
1093      * Calling this function outside of contract creation WILL make your contract
1094      * non-compliant with the ERC721 standard.
1095      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1096      * {ConsecutiveTransfer} event is only permissible during contract creation.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `quantity` must be greater than 0.
1102      *
1103      * Emits a {ConsecutiveTransfer} event.
1104      */
1105     function _mintERC2309(address to, uint256 quantity) internal virtual {
1106         uint256 startTokenId = _currentIndex;
1107         if (to == address(0)) revert MintToZeroAddress();
1108         if (quantity == 0) revert MintZeroQuantity();
1109         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1110 
1111         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1112 
1113         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1114         unchecked {
1115             // Updates:
1116             // - `balance += quantity`.
1117             // - `numberMinted += quantity`.
1118             //
1119             // We can directly add to the `balance` and `numberMinted`.
1120             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1121 
1122             // Updates:
1123             // - `address` to the owner.
1124             // - `startTimestamp` to the timestamp of minting.
1125             // - `burned` to `false`.
1126             // - `nextInitialized` to `quantity == 1`.
1127             _packedOwnerships[startTokenId] = _packOwnershipData(
1128                 to,
1129                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1130             );
1131 
1132             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1133 
1134             _currentIndex = startTokenId + quantity;
1135         }
1136         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1137     }
1138 
1139     /**
1140      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - If `to` refers to a smart contract, it must implement
1145      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1146      * - `quantity` must be greater than 0.
1147      *
1148      * See {_mint}.
1149      *
1150      * Emits a {Transfer} event for each mint.
1151      */
1152     function _safeMint(
1153         address to,
1154         uint256 quantity,
1155         bytes memory _data
1156     ) internal virtual {
1157         _mint(to, quantity);
1158 
1159         unchecked {
1160             if (to.code.length != 0) {
1161                 uint256 end = _currentIndex;
1162                 uint256 index = end - quantity;
1163                 do {
1164                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1165                         revert TransferToNonERC721ReceiverImplementer();
1166                     }
1167                 } while (index < end);
1168                 // Reentrancy protection.
1169                 if (_currentIndex != end) revert();
1170             }
1171         }
1172     }
1173 
1174     /**
1175      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1176      */
1177     function _safeMint(address to, uint256 quantity) internal virtual {
1178         _safeMint(to, quantity, '');
1179     }
1180 
1181     // =============================================================
1182     //                        BURN OPERATIONS
1183     // =============================================================
1184 
1185     /**
1186      * @dev Equivalent to `_burn(tokenId, false)`.
1187      */
1188     function _burn(uint256 tokenId) internal virtual {
1189         _burn(tokenId, false);
1190     }
1191 
1192     /**
1193      * @dev Destroys `tokenId`.
1194      * The approval is cleared when the token is burned.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1203         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1204 
1205         address from = address(uint160(prevOwnershipPacked));
1206 
1207         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1208 
1209         if (approvalCheck) {
1210             // The nested ifs save around 20+ gas over a compound boolean condition.
1211             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1212                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1213         }
1214 
1215         _beforeTokenTransfers(from, address(0), tokenId, 1);
1216 
1217         // Clear approvals from the previous owner.
1218         assembly {
1219             if approvedAddress {
1220                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1221                 sstore(approvedAddressSlot, 0)
1222             }
1223         }
1224 
1225         // Underflow of the sender's balance is impossible because we check for
1226         // ownership above and the recipient's balance can't realistically overflow.
1227         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1228         unchecked {
1229             // Updates:
1230             // - `balance -= 1`.
1231             // - `numberBurned += 1`.
1232             //
1233             // We can directly decrement the balance, and increment the number burned.
1234             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1235             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1236 
1237             // Updates:
1238             // - `address` to the last owner.
1239             // - `startTimestamp` to the timestamp of burning.
1240             // - `burned` to `true`.
1241             // - `nextInitialized` to `true`.
1242             _packedOwnerships[tokenId] = _packOwnershipData(
1243                 from,
1244                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1245             );
1246 
1247             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1248             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1249                 uint256 nextTokenId = tokenId + 1;
1250                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1251                 if (_packedOwnerships[nextTokenId] == 0) {
1252                     // If the next slot is within bounds.
1253                     if (nextTokenId != _currentIndex) {
1254                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1255                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1256                     }
1257                 }
1258             }
1259         }
1260 
1261         emit Transfer(from, address(0), tokenId);
1262         _afterTokenTransfers(from, address(0), tokenId, 1);
1263 
1264         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1265         unchecked {
1266             _burnCounter++;
1267         }
1268     }
1269 
1270     // =============================================================
1271     //                     EXTRA DATA OPERATIONS
1272     // =============================================================
1273 
1274     /**
1275      * @dev Directly sets the extra data for the ownership data `index`.
1276      */
1277     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1278         uint256 packed = _packedOwnerships[index];
1279         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1280         uint256 extraDataCasted;
1281         // Cast `extraData` with assembly to avoid redundant masking.
1282         assembly {
1283             extraDataCasted := extraData
1284         }
1285         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1286         _packedOwnerships[index] = packed;
1287     }
1288 
1289     /**
1290      * @dev Called during each token transfer to set the 24bit `extraData` field.
1291      * Intended to be overridden by the cosumer contract.
1292      *
1293      * `previousExtraData` - the value of `extraData` before transfer.
1294      *
1295      * Calling conditions:
1296      *
1297      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1298      * transferred to `to`.
1299      * - When `from` is zero, `tokenId` will be minted for `to`.
1300      * - When `to` is zero, `tokenId` will be burned by `from`.
1301      * - `from` and `to` are never both zero.
1302      */
1303     function _extraData(
1304         address from,
1305         address to,
1306         uint24 previousExtraData
1307     ) internal view virtual returns (uint24) {}
1308 
1309     /**
1310      * @dev Returns the next extra data for the packed ownership data.
1311      * The returned result is shifted into position.
1312      */
1313     function _nextExtraData(
1314         address from,
1315         address to,
1316         uint256 prevOwnershipPacked
1317     ) private view returns (uint256) {
1318         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1319         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1320     }
1321 
1322     // =============================================================
1323     //                       OTHER OPERATIONS
1324     // =============================================================
1325 
1326     /**
1327      * @dev Returns the message sender (defaults to `msg.sender`).
1328      *
1329      * If you are writing GSN compatible contracts, you need to override this function.
1330      */
1331     function _msgSenderERC721A() internal view virtual returns (address) {
1332         return msg.sender;
1333     }
1334 
1335     /**
1336      * @dev Converts a uint256 to its ASCII string decimal representation.
1337      */
1338     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1339         assembly {
1340             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1341             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1342             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1343             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1344             let m := add(mload(0x40), 0xa0)
1345             // Update the free memory pointer to allocate.
1346             mstore(0x40, m)
1347             // Assign the `str` to the end.
1348             str := sub(m, 0x20)
1349             // Zeroize the slot after the string.
1350             mstore(str, 0)
1351 
1352             // Cache the end of the memory to calculate the length later.
1353             let end := str
1354 
1355             // We write the string from rightmost digit to leftmost digit.
1356             // The following is essentially a do-while loop that also handles the zero case.
1357             // prettier-ignore
1358             for { let temp := value } 1 {} {
1359                 str := sub(str, 1)
1360                 // Write the character to the pointer.
1361                 // The ASCII index of the '0' character is 48.
1362                 mstore8(str, add(48, mod(temp, 10)))
1363                 // Keep dividing `temp` until zero.
1364                 temp := div(temp, 10)
1365                 // prettier-ignore
1366                 if iszero(temp) { break }
1367             }
1368 
1369             let length := sub(end, str)
1370             // Move the pointer 32 bytes leftwards to make room for the length.
1371             str := sub(str, 0x20)
1372             // Store the length.
1373             mstore(str, length)
1374         }
1375     }
1376 }
1377 
1378 // File: @openzeppelin\contracts\utils\Context.sol
1379 
1380 
1381 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1382 
1383 pragma solidity ^0.8.0;
1384 
1385 /**
1386  * @dev Provides information about the current execution context, including the
1387  * sender of the transaction and its data. While these are generally available
1388  * via msg.sender and msg.data, they should not be accessed in such a direct
1389  * manner, since when dealing with meta-transactions the account sending and
1390  * paying for execution may not be the actual sender (as far as an application
1391  * is concerned).
1392  *
1393  * This contract is only required for intermediate, library-like contracts.
1394  */
1395 abstract contract Context {
1396     function _msgSender() internal view virtual returns (address) {
1397         return msg.sender;
1398     }
1399 
1400     function _msgData() internal view virtual returns (bytes calldata) {
1401         return msg.data;
1402     }
1403 }
1404 
1405 // File: @openzeppelin\contracts\access\Ownable.sol
1406 
1407 
1408 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1409 
1410 pragma solidity ^0.8.0;
1411 
1412 /**
1413  * @dev Contract module which provides a basic access control mechanism, where
1414  * there is an account (an owner) that can be granted exclusive access to
1415  * specific functions.
1416  *
1417  * By default, the owner account will be the one that deploys the contract. This
1418  * can later be changed with {transferOwnership}.
1419  *
1420  * This module is used through inheritance. It will make available the modifier
1421  * `onlyOwner`, which can be applied to your functions to restrict their use to
1422  * the owner.
1423  */
1424 abstract contract Ownable is Context {
1425     address private _owner;
1426 
1427     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1428 
1429     /**
1430      * @dev Initializes the contract setting the deployer as the initial owner.
1431      */
1432     constructor() {
1433         _transferOwnership(_msgSender());
1434     }
1435 
1436     /**
1437      * @dev Throws if called by any account other than the owner.
1438      */
1439     modifier onlyOwner() {
1440         _checkOwner();
1441         _;
1442     }
1443 
1444     /**
1445      * @dev Returns the address of the current owner.
1446      */
1447     function owner() public view virtual returns (address) {
1448         return _owner;
1449     }
1450 
1451     /**
1452      * @dev Throws if the sender is not the owner.
1453      */
1454     function _checkOwner() internal view virtual {
1455         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1456     }
1457 
1458     /**
1459      * @dev Leaves the contract without owner. It will not be possible to call
1460      * `onlyOwner` functions anymore. Can only be called by the current owner.
1461      *
1462      * NOTE: Renouncing ownership will leave the contract without an owner,
1463      * thereby removing any functionality that is only available to the owner.
1464      */
1465     function renounceOwnership() public virtual onlyOwner {
1466         _transferOwnership(address(0));
1467     }
1468 
1469     /**
1470      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1471      * Can only be called by the current owner.
1472      */
1473     function transferOwnership(address newOwner) public virtual onlyOwner {
1474         require(newOwner != address(0), "Ownable: new owner is the zero address");
1475         _transferOwnership(newOwner);
1476     }
1477 
1478     /**
1479      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1480      * Internal function without access restriction.
1481      */
1482     function _transferOwnership(address newOwner) internal virtual {
1483         address oldOwner = _owner;
1484         _owner = newOwner;
1485         emit OwnershipTransferred(oldOwner, newOwner);
1486     }
1487 }
1488 
1489 // File: @openzeppelin\contracts\security\ReentrancyGuard.sol
1490 
1491 
1492 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1493 
1494 pragma solidity ^0.8.0;
1495 
1496 /**
1497  * @dev Contract module that helps prevent reentrant calls to a function.
1498  *
1499  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1500  * available, which can be applied to functions to make sure there are no nested
1501  * (reentrant) calls to them.
1502  *
1503  * Note that because there is a single `nonReentrant` guard, functions marked as
1504  * `nonReentrant` may not call one another. This can be worked around by making
1505  * those functions `private`, and then adding `external` `nonReentrant` entry
1506  * points to them.
1507  *
1508  * TIP: If you would like to learn more about reentrancy and alternative ways
1509  * to protect against it, check out our blog post
1510  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1511  */
1512 abstract contract ReentrancyGuard {
1513     // Booleans are more expensive than uint256 or any type that takes up a full
1514     // word because each write operation emits an extra SLOAD to first read the
1515     // slot's contents, replace the bits taken up by the boolean, and then write
1516     // back. This is the compiler's defense against contract upgrades and
1517     // pointer aliasing, and it cannot be disabled.
1518 
1519     // The values being non-zero value makes deployment a bit more expensive,
1520     // but in exchange the refund on every call to nonReentrant will be lower in
1521     // amount. Since refunds are capped to a percentage of the total
1522     // transaction's gas, it is best to keep them low in cases like this one, to
1523     // increase the likelihood of the full refund coming into effect.
1524     uint256 private constant _NOT_ENTERED = 1;
1525     uint256 private constant _ENTERED = 2;
1526 
1527     uint256 private _status;
1528 
1529     constructor() {
1530         _status = _NOT_ENTERED;
1531     }
1532 
1533     /**
1534      * @dev Prevents a contract from calling itself, directly or indirectly.
1535      * Calling a `nonReentrant` function from another `nonReentrant`
1536      * function is not supported. It is possible to prevent this from happening
1537      * by making the `nonReentrant` function external, and making it call a
1538      * `private` function that does the actual work.
1539      */
1540     modifier nonReentrant() {
1541         _nonReentrantBefore();
1542         _;
1543         _nonReentrantAfter();
1544     }
1545 
1546     function _nonReentrantBefore() private {
1547         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1548         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1549 
1550         // Any calls to nonReentrant after this point will fail
1551         _status = _ENTERED;
1552     }
1553 
1554     function _nonReentrantAfter() private {
1555         // By storing the original value once again, a refund is triggered (see
1556         // https://eips.ethereum.org/EIPS/eip-2200)
1557         _status = _NOT_ENTERED;
1558     }
1559 }
1560 
1561 // File: @openzeppelin\contracts\utils\cryptography\MerkleProof.sol
1562 
1563 
1564 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1565 
1566 pragma solidity ^0.8.0;
1567 
1568 /**
1569  * @dev These functions deal with verification of Merkle Tree proofs.
1570  *
1571  * The tree and the proofs can be generated using our
1572  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1573  * You will find a quickstart guide in the readme.
1574  *
1575  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1576  * hashing, or use a hash function other than keccak256 for hashing leaves.
1577  * This is because the concatenation of a sorted pair of internal nodes in
1578  * the merkle tree could be reinterpreted as a leaf value.
1579  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1580  * against this attack out of the box.
1581  */
1582 library MerkleProof {
1583     /**
1584      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1585      * defined by `root`. For this, a `proof` must be provided, containing
1586      * sibling hashes on the branch from the leaf to the root of the tree. Each
1587      * pair of leaves and each pair of pre-images are assumed to be sorted.
1588      */
1589     function verify(
1590         bytes32[] memory proof,
1591         bytes32 root,
1592         bytes32 leaf
1593     ) internal pure returns (bool) {
1594         return processProof(proof, leaf) == root;
1595     }
1596 
1597     /**
1598      * @dev Calldata version of {verify}
1599      *
1600      * _Available since v4.7._
1601      */
1602     function verifyCalldata(
1603         bytes32[] calldata proof,
1604         bytes32 root,
1605         bytes32 leaf
1606     ) internal pure returns (bool) {
1607         return processProofCalldata(proof, leaf) == root;
1608     }
1609 
1610     /**
1611      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1612      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1613      * hash matches the root of the tree. When processing the proof, the pairs
1614      * of leafs & pre-images are assumed to be sorted.
1615      *
1616      * _Available since v4.4._
1617      */
1618     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1619         bytes32 computedHash = leaf;
1620         for (uint256 i = 0; i < proof.length; i++) {
1621             computedHash = _hashPair(computedHash, proof[i]);
1622         }
1623         return computedHash;
1624     }
1625 
1626     /**
1627      * @dev Calldata version of {processProof}
1628      *
1629      * _Available since v4.7._
1630      */
1631     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1632         bytes32 computedHash = leaf;
1633         for (uint256 i = 0; i < proof.length; i++) {
1634             computedHash = _hashPair(computedHash, proof[i]);
1635         }
1636         return computedHash;
1637     }
1638 
1639     /**
1640      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1641      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1642      *
1643      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1644      *
1645      * _Available since v4.7._
1646      */
1647     function multiProofVerify(
1648         bytes32[] memory proof,
1649         bool[] memory proofFlags,
1650         bytes32 root,
1651         bytes32[] memory leaves
1652     ) internal pure returns (bool) {
1653         return processMultiProof(proof, proofFlags, leaves) == root;
1654     }
1655 
1656     /**
1657      * @dev Calldata version of {multiProofVerify}
1658      *
1659      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1660      *
1661      * _Available since v4.7._
1662      */
1663     function multiProofVerifyCalldata(
1664         bytes32[] calldata proof,
1665         bool[] calldata proofFlags,
1666         bytes32 root,
1667         bytes32[] memory leaves
1668     ) internal pure returns (bool) {
1669         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1670     }
1671 
1672     /**
1673      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1674      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1675      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1676      * respectively.
1677      *
1678      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1679      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1680      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1681      *
1682      * _Available since v4.7._
1683      */
1684     function processMultiProof(
1685         bytes32[] memory proof,
1686         bool[] memory proofFlags,
1687         bytes32[] memory leaves
1688     ) internal pure returns (bytes32 merkleRoot) {
1689         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1690         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1691         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1692         // the merkle tree.
1693         uint256 leavesLen = leaves.length;
1694         uint256 totalHashes = proofFlags.length;
1695 
1696         // Check proof validity.
1697         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1698 
1699         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1700         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1701         bytes32[] memory hashes = new bytes32[](totalHashes);
1702         uint256 leafPos = 0;
1703         uint256 hashPos = 0;
1704         uint256 proofPos = 0;
1705         // At each step, we compute the next hash using two values:
1706         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1707         //   get the next hash.
1708         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1709         //   `proof` array.
1710         for (uint256 i = 0; i < totalHashes; i++) {
1711             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1712             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1713             hashes[i] = _hashPair(a, b);
1714         }
1715 
1716         if (totalHashes > 0) {
1717             return hashes[totalHashes - 1];
1718         } else if (leavesLen > 0) {
1719             return leaves[0];
1720         } else {
1721             return proof[0];
1722         }
1723     }
1724 
1725     /**
1726      * @dev Calldata version of {processMultiProof}.
1727      *
1728      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1729      *
1730      * _Available since v4.7._
1731      */
1732     function processMultiProofCalldata(
1733         bytes32[] calldata proof,
1734         bool[] calldata proofFlags,
1735         bytes32[] memory leaves
1736     ) internal pure returns (bytes32 merkleRoot) {
1737         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1738         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1739         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1740         // the merkle tree.
1741         uint256 leavesLen = leaves.length;
1742         uint256 totalHashes = proofFlags.length;
1743 
1744         // Check proof validity.
1745         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1746 
1747         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1748         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1749         bytes32[] memory hashes = new bytes32[](totalHashes);
1750         uint256 leafPos = 0;
1751         uint256 hashPos = 0;
1752         uint256 proofPos = 0;
1753         // At each step, we compute the next hash using two values:
1754         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1755         //   get the next hash.
1756         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1757         //   `proof` array.
1758         for (uint256 i = 0; i < totalHashes; i++) {
1759             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1760             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1761             hashes[i] = _hashPair(a, b);
1762         }
1763 
1764         if (totalHashes > 0) {
1765             return hashes[totalHashes - 1];
1766         } else if (leavesLen > 0) {
1767             return leaves[0];
1768         } else {
1769             return proof[0];
1770         }
1771     }
1772 
1773     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1774         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1775     }
1776 
1777     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1778         /// @solidity memory-safe-assembly
1779         assembly {
1780             mstore(0x00, a)
1781             mstore(0x20, b)
1782             value := keccak256(0x00, 0x40)
1783         }
1784     }
1785 }
1786 
1787 // File: node_modules\operator-filter-registry\src\IOperatorFilterRegistry.sol
1788 
1789 
1790 pragma solidity ^0.8.13;
1791 
1792 interface IOperatorFilterRegistry {
1793     /**
1794      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1795      *         true if supplied registrant address is not registered.
1796      */
1797     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1798 
1799     /**
1800      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1801      */
1802     function register(address registrant) external;
1803 
1804     /**
1805      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1806      */
1807     function registerAndSubscribe(address registrant, address subscription) external;
1808 
1809     /**
1810      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1811      *         address without subscribing.
1812      */
1813     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1814 
1815     /**
1816      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1817      *         Note that this does not remove any filtered addresses or codeHashes.
1818      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1819      */
1820     function unregister(address addr) external;
1821 
1822     /**
1823      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1824      */
1825     function updateOperator(address registrant, address operator, bool filtered) external;
1826 
1827     /**
1828      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1829      */
1830     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1831 
1832     /**
1833      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1834      */
1835     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1836 
1837     /**
1838      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1839      */
1840     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1841 
1842     /**
1843      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1844      *         subscription if present.
1845      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1846      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1847      *         used.
1848      */
1849     function subscribe(address registrant, address registrantToSubscribe) external;
1850 
1851     /**
1852      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1853      */
1854     function unsubscribe(address registrant, bool copyExistingEntries) external;
1855 
1856     /**
1857      * @notice Get the subscription address of a given registrant, if any.
1858      */
1859     function subscriptionOf(address addr) external returns (address registrant);
1860 
1861     /**
1862      * @notice Get the set of addresses subscribed to a given registrant.
1863      *         Note that order is not guaranteed as updates are made.
1864      */
1865     function subscribers(address registrant) external returns (address[] memory);
1866 
1867     /**
1868      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1869      *         Note that order is not guaranteed as updates are made.
1870      */
1871     function subscriberAt(address registrant, uint256 index) external returns (address);
1872 
1873     /**
1874      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1875      */
1876     function copyEntriesOf(address registrant, address registrantToCopy) external;
1877 
1878     /**
1879      * @notice Returns true if operator is filtered by a given address or its subscription.
1880      */
1881     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1882 
1883     /**
1884      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1885      */
1886     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1887 
1888     /**
1889      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1890      */
1891     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1892 
1893     /**
1894      * @notice Returns a list of filtered operators for a given address or its subscription.
1895      */
1896     function filteredOperators(address addr) external returns (address[] memory);
1897 
1898     /**
1899      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1900      *         Note that order is not guaranteed as updates are made.
1901      */
1902     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1903 
1904     /**
1905      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1906      *         its subscription.
1907      *         Note that order is not guaranteed as updates are made.
1908      */
1909     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1910 
1911     /**
1912      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1913      *         its subscription.
1914      *         Note that order is not guaranteed as updates are made.
1915      */
1916     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1917 
1918     /**
1919      * @notice Returns true if an address has registered
1920      */
1921     function isRegistered(address addr) external returns (bool);
1922 
1923     /**
1924      * @dev Convenience method to compute the code hash of an arbitrary contract
1925      */
1926     function codeHashOf(address addr) external returns (bytes32);
1927 }
1928 
1929 // File: node_modules\operator-filter-registry\src\lib\Constants.sol
1930 
1931 
1932 pragma solidity ^0.8.17;
1933 
1934 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1935 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1936 
1937 // File: node_modules\operator-filter-registry\src\OperatorFilterer.sol
1938 
1939 
1940 pragma solidity ^0.8.13;
1941 
1942 
1943 /**
1944  * @title  OperatorFilterer
1945  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1946  *         registrant's entries in the OperatorFilterRegistry.
1947  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1948  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1949  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1950  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1951  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1952  *         will be locked to the options set during construction.
1953  */
1954 
1955 abstract contract OperatorFilterer {
1956     /// @dev Emitted when an operator is not allowed.
1957     error OperatorNotAllowed(address operator);
1958 
1959     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1960         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1961 
1962     /// @dev The constructor that is called when the contract is being deployed.
1963     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1964         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1965         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1966         // order for the modifier to filter addresses.
1967         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1968             if (subscribe) {
1969                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1970             } else {
1971                 if (subscriptionOrRegistrantToCopy != address(0)) {
1972                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1973                 } else {
1974                     OPERATOR_FILTER_REGISTRY.register(address(this));
1975                 }
1976             }
1977         }
1978     }
1979 
1980     /**
1981      * @dev A helper function to check if an operator is allowed.
1982      */
1983     modifier onlyAllowedOperator(address from) virtual {
1984         // Allow spending tokens from addresses with balance
1985         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1986         // from an EOA.
1987         if (from != msg.sender) {
1988             _checkFilterOperator(msg.sender);
1989         }
1990         _;
1991     }
1992 
1993     /**
1994      * @dev A helper function to check if an operator approval is allowed.
1995      */
1996     modifier onlyAllowedOperatorApproval(address operator) virtual {
1997         _checkFilterOperator(operator);
1998         _;
1999     }
2000 
2001     /**
2002      * @dev A helper function to check if an operator is allowed.
2003      */
2004     function _checkFilterOperator(address operator) internal view virtual {
2005         // Check registry code length to facilitate testing in environments without a deployed registry.
2006         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2007             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
2008             // may specify their own OperatorFilterRegistry implementations, which may behave differently
2009             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2010                 revert OperatorNotAllowed(operator);
2011             }
2012         }
2013     }
2014 }
2015 
2016 // File: operator-filter-registry\src\DefaultOperatorFilterer.sol
2017 
2018 
2019 pragma solidity ^0.8.13;
2020 
2021 
2022 /**
2023  * @title  DefaultOperatorFilterer
2024  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2025  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
2026  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2027  *         will be locked to the options set during construction.
2028  */
2029 
2030 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2031     /// @dev The constructor that is called when the contract is being deployed.
2032     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2033 }
2034 
2035 // File: contracts\Banksy.sol
2036 
2037 
2038 
2039 
2040 
2041 pragma solidity >=0.7.0 <0.9.0;
2042 contract WhoIsBanksy is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2043 
2044 
2045   string public baseURI;
2046   string public notRevealedUri;
2047   uint256 public cost = 0.0077 ether;
2048   uint256 public maxSupply = 999;
2049   uint256 public MaxperWallet = 3;
2050   uint256 public MaxperWalletWl = 3;
2051   bool public paused = false;
2052   bool public revealed = false;
2053   bool public preSale = true;
2054   bytes32 public merkleRoot;
2055 
2056   constructor() ERC721A("Who is Banksy", "ETH") {}
2057 
2058   // internal
2059   function _baseURI() internal view virtual override returns (string memory) {
2060     return baseURI;
2061   }
2062       function _startTokenId() internal view virtual override returns (uint256) {
2063         return 1;
2064     }
2065 
2066   // public
2067   /// @dev Public mint 
2068   function mint(uint256 tokens) public payable nonReentrant {
2069     require(!paused, "ETH: oops contract is paused");
2070     require(!preSale, "ETH: Sale Hasn't started yet");
2071     require(tokens <= MaxperWallet, "ETH: max mint amount per tx exceeded");
2072     require(totalSupply() + tokens <= maxSupply, "ETH: We Soldout");
2073     require(_numberMinted(_msgSenderERC721A()) + tokens <= MaxperWallet, "ETH: Max NFT Per Wallet exceeded");
2074     require(msg.value >= cost * tokens, "ETH: insufficient funds");
2075 
2076       _safeMint(_msgSenderERC721A(), tokens);
2077     
2078   }
2079 /// @dev presale mint for whitelisted
2080     function presalemint(uint256 tokens, bytes32[] calldata merkleProof) public payable nonReentrant {
2081     require(!paused, "ETH: oops contract is paused");
2082     require(preSale, "ETH: Presale Hasnt't started yet");
2083     require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "ETH: You are not Whitelisted");
2084     require(_numberMinted(_msgSenderERC721A()) + tokens <= MaxperWalletWl, "ETH: Max NFT Per Wallet exceeded");
2085     require(tokens <= MaxperWalletWl, "ETH: max mint per Tx exceeded");
2086     require(totalSupply() + tokens <= maxSupply, "ETH: Whitelist MaxSupply exceeded");
2087     require(msg.value >= cost * tokens, "ETH: insufficient funds");
2088 
2089       _safeMint(_msgSenderERC721A(), tokens);
2090     
2091   }
2092 
2093   /// @dev use it for giveaway and team mint
2094      function airdrop(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
2095     require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
2096 
2097       _safeMint(destination, _mintAmount);
2098   }
2099 
2100 /// @notice returns metadata link of tokenid
2101   function tokenURI(uint256 tokenId)
2102     public
2103     view
2104     virtual
2105     override
2106     returns (string memory)
2107   {
2108     require(
2109       _exists(tokenId),
2110       "ERC721AMetadata: URI query for nonexistent token"
2111     );
2112     
2113     if(revealed == false) {
2114         return notRevealedUri;
2115     }
2116 
2117     string memory currentBaseURI = _baseURI();
2118     return bytes(currentBaseURI).length > 0
2119         ? string(abi.encodePacked(currentBaseURI, _toString(tokenId), ".json"))
2120         : "";
2121   }
2122 
2123      /// @notice return the number minted by an address
2124     function numberMinted(address owner) public view returns (uint256) {
2125     return _numberMinted(owner);
2126   }
2127 
2128     /// @notice return the tokens owned by an address
2129       function tokensOfOwner(address owner) public view returns (uint256[] memory) {
2130         unchecked {
2131             uint256 tokenIdsIdx;
2132             address currOwnershipAddr;
2133             uint256 tokenIdsLength = balanceOf(owner);
2134             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2135             TokenOwnership memory ownership;
2136             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2137                 ownership = _ownershipAt(i);
2138                 if (ownership.burned) {
2139                     continue;
2140                 }
2141                 if (ownership.addr != address(0)) {
2142                     currOwnershipAddr = ownership.addr;
2143                 }
2144                 if (currOwnershipAddr == owner) {
2145                     tokenIds[tokenIdsIdx++] = i;
2146                 }
2147             }
2148             return tokenIds;
2149         }
2150     }
2151 
2152   //only owner
2153   function reveal(bool _state) public onlyOwner {
2154       revealed = _state;
2155   }
2156 
2157     /// @dev change the merkle root for the whitelist phase
2158   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2159         merkleRoot = _merkleRoot;
2160     }
2161 
2162   /// @dev change the public max per wallet
2163   function setMaxPerWallet(uint256 _limit) public onlyOwner {
2164     MaxperWallet = _limit;
2165   }
2166 
2167   /// @dev change the whitelist max per wallet
2168     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
2169     MaxperWalletWl = _limit;
2170   }
2171 
2172    /// @dev change the public price(amount need to be in wei)
2173   function setCost(uint256 _newCost) public onlyOwner {
2174     cost = _newCost;
2175   }
2176 
2177 
2178   /// @dev cut the supply if we dont sold out
2179     function setMaxsupply(uint256 _newsupply) public onlyOwner {
2180     maxSupply = _newsupply;
2181   }
2182 
2183  /// @dev set your baseuri
2184   function setBaseURI(string memory _newBaseURI) public onlyOwner {
2185     baseURI = _newBaseURI;
2186   }
2187 
2188    /// @dev set hidden uri
2189   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2190     notRevealedUri = _notRevealedURI;
2191   }
2192 
2193  /// @dev to pause and unpause your contract(use booleans true or false)
2194   function pause(bool _state) public onlyOwner {
2195     paused = _state;
2196   }
2197 
2198      /// @dev activate whitelist sale(use booleans true or false)
2199     function togglepreSale(bool _state) external onlyOwner {
2200         preSale = _state;
2201     }
2202   
2203   /// @dev withdraw funds from contract
2204   function withdraw() public payable onlyOwner nonReentrant {
2205       uint256 balance = address(this).balance;
2206       payable(0x51C14c89DB72fCf4350c48d8eB3e85C0578Af924).transfer(balance);
2207   }
2208 
2209       /// Opensea Royalties
2210 
2211     function transferFrom(
2212         address from,
2213         address to,
2214         uint256 tokenId
2215     ) public payable override onlyAllowedOperator(from) {
2216         super.transferFrom(from, to, tokenId);
2217     }
2218 
2219     function safeTransferFrom(
2220         address from,
2221         address to,
2222         uint256 tokenId
2223     ) public payable override onlyAllowedOperator(from) {
2224         super.safeTransferFrom(from, to, tokenId);
2225     }
2226 
2227     function safeTransferFrom(
2228         address from,
2229         address to,
2230         uint256 tokenId,
2231         bytes memory data
2232     ) public payable override onlyAllowedOperator(from) {
2233         super.safeTransferFrom(from, to, tokenId, data);
2234     }
2235 }