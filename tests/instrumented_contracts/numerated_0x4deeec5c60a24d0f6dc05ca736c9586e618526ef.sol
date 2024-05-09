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
1561 // File: node_modules\operator-filter-registry\src\IOperatorFilterRegistry.sol
1562 
1563 
1564 pragma solidity ^0.8.13;
1565 
1566 interface IOperatorFilterRegistry {
1567     /**
1568      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1569      *         true if supplied registrant address is not registered.
1570      */
1571     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1572 
1573     /**
1574      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1575      */
1576     function register(address registrant) external;
1577 
1578     /**
1579      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1580      */
1581     function registerAndSubscribe(address registrant, address subscription) external;
1582 
1583     /**
1584      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1585      *         address without subscribing.
1586      */
1587     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1588 
1589     /**
1590      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1591      *         Note that this does not remove any filtered addresses or codeHashes.
1592      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1593      */
1594     function unregister(address addr) external;
1595 
1596     /**
1597      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1598      */
1599     function updateOperator(address registrant, address operator, bool filtered) external;
1600 
1601     /**
1602      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1603      */
1604     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1605 
1606     /**
1607      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1608      */
1609     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1610 
1611     /**
1612      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1613      */
1614     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1615 
1616     /**
1617      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1618      *         subscription if present.
1619      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1620      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1621      *         used.
1622      */
1623     function subscribe(address registrant, address registrantToSubscribe) external;
1624 
1625     /**
1626      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1627      */
1628     function unsubscribe(address registrant, bool copyExistingEntries) external;
1629 
1630     /**
1631      * @notice Get the subscription address of a given registrant, if any.
1632      */
1633     function subscriptionOf(address addr) external returns (address registrant);
1634 
1635     /**
1636      * @notice Get the set of addresses subscribed to a given registrant.
1637      *         Note that order is not guaranteed as updates are made.
1638      */
1639     function subscribers(address registrant) external returns (address[] memory);
1640 
1641     /**
1642      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1643      *         Note that order is not guaranteed as updates are made.
1644      */
1645     function subscriberAt(address registrant, uint256 index) external returns (address);
1646 
1647     /**
1648      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1649      */
1650     function copyEntriesOf(address registrant, address registrantToCopy) external;
1651 
1652     /**
1653      * @notice Returns true if operator is filtered by a given address or its subscription.
1654      */
1655     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1656 
1657     /**
1658      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1659      */
1660     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1661 
1662     /**
1663      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1664      */
1665     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1666 
1667     /**
1668      * @notice Returns a list of filtered operators for a given address or its subscription.
1669      */
1670     function filteredOperators(address addr) external returns (address[] memory);
1671 
1672     /**
1673      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1674      *         Note that order is not guaranteed as updates are made.
1675      */
1676     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1677 
1678     /**
1679      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1680      *         its subscription.
1681      *         Note that order is not guaranteed as updates are made.
1682      */
1683     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1684 
1685     /**
1686      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1687      *         its subscription.
1688      *         Note that order is not guaranteed as updates are made.
1689      */
1690     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1691 
1692     /**
1693      * @notice Returns true if an address has registered
1694      */
1695     function isRegistered(address addr) external returns (bool);
1696 
1697     /**
1698      * @dev Convenience method to compute the code hash of an arbitrary contract
1699      */
1700     function codeHashOf(address addr) external returns (bytes32);
1701 }
1702 
1703 // File: node_modules\operator-filter-registry\src\lib\Constants.sol
1704 
1705 
1706 pragma solidity ^0.8.17;
1707 
1708 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1709 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1710 
1711 // File: node_modules\operator-filter-registry\src\OperatorFilterer.sol
1712 
1713 
1714 pragma solidity ^0.8.13;
1715 
1716 
1717 /**
1718  * @title  OperatorFilterer
1719  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1720  *         registrant's entries in the OperatorFilterRegistry.
1721  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1722  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1723  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1724  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1725  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1726  *         will be locked to the options set during construction.
1727  */
1728 
1729 abstract contract OperatorFilterer {
1730     /// @dev Emitted when an operator is not allowed.
1731     error OperatorNotAllowed(address operator);
1732 
1733     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1734         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1735 
1736     /// @dev The constructor that is called when the contract is being deployed.
1737     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1738         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1739         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1740         // order for the modifier to filter addresses.
1741         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1742             if (subscribe) {
1743                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1744             } else {
1745                 if (subscriptionOrRegistrantToCopy != address(0)) {
1746                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1747                 } else {
1748                     OPERATOR_FILTER_REGISTRY.register(address(this));
1749                 }
1750             }
1751         }
1752     }
1753 
1754     /**
1755      * @dev A helper function to check if an operator is allowed.
1756      */
1757     modifier onlyAllowedOperator(address from) virtual {
1758         // Allow spending tokens from addresses with balance
1759         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1760         // from an EOA.
1761         if (from != msg.sender) {
1762             _checkFilterOperator(msg.sender);
1763         }
1764         _;
1765     }
1766 
1767     /**
1768      * @dev A helper function to check if an operator approval is allowed.
1769      */
1770     modifier onlyAllowedOperatorApproval(address operator) virtual {
1771         _checkFilterOperator(operator);
1772         _;
1773     }
1774 
1775     /**
1776      * @dev A helper function to check if an operator is allowed.
1777      */
1778     function _checkFilterOperator(address operator) internal view virtual {
1779         // Check registry code length to facilitate testing in environments without a deployed registry.
1780         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1781             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1782             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1783             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1784                 revert OperatorNotAllowed(operator);
1785             }
1786         }
1787     }
1788 }
1789 
1790 // File: operator-filter-registry\src\DefaultOperatorFilterer.sol
1791 
1792 
1793 pragma solidity ^0.8.13;
1794 
1795 
1796 /**
1797  * @title  DefaultOperatorFilterer
1798  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1799  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1800  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1801  *         will be locked to the options set during construction.
1802  */
1803 
1804 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1805     /// @dev The constructor that is called when the contract is being deployed.
1806     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1807 }
1808 
1809 // File: contracts\BanksyV2.sol
1810 
1811 
1812 
1813 
1814 
1815 pragma solidity >=0.7.0 <0.9.0;
1816 interface BanksyV1 {
1817     function balanceOf(address owner) external view returns (uint256 balance);
1818 }
1819 
1820 contract WhoIsBanksyV2 is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
1821 
1822 
1823 
1824   string public baseURI;
1825   string public notRevealedUri;
1826   uint256 public cost = 0.0033 ether;
1827   uint256 public maxSupply = 999;
1828   uint256 public MaxperWallet = 3;
1829   uint256 public MaxperWalletWl = 1;
1830   bool public paused = true;
1831   bool public revealed = false;
1832   bool public preSale = true;
1833   address public BanksyAddress = 0x2a05aE518D4d94656d014d95C9bBfc206155153b;
1834   BanksyV1 public BanksyNFT;
1835   mapping (address => uint256) public PublicMintofUser;
1836   mapping (address => uint256) public FreeMintofUser;
1837 
1838   constructor() ERC721A("Who is BanksyV2", "ETH") {
1839       BanksyNFT = BanksyV1(BanksyAddress);
1840   }
1841 
1842   // internal
1843   function _baseURI() internal view virtual override returns (string memory) {
1844     return baseURI;
1845   }
1846       function _startTokenId() internal view virtual override returns (uint256) {
1847         return 1;
1848     }
1849 
1850   // public
1851   /// @dev Public mint 
1852   function mint(uint256 tokens) public payable nonReentrant {
1853     require(!paused, "ETH: oops contract is paused");
1854     require(!preSale, "ETH: Sale Hasn't started yet");
1855     require(tokens <= MaxperWallet, "ETH: max mint amount per tx exceeded");
1856     require(totalSupply() + tokens <= maxSupply, "ETH: We Soldout");
1857     require(PublicMintofUser[_msgSenderERC721A()] + tokens <= MaxperWallet, "ETH: Max NFT Per Wallet exceeded");
1858     require(msg.value >= cost * tokens, "ETH: insufficient funds");
1859 
1860     PublicMintofUser[_msgSenderERC721A()] += tokens;
1861 
1862       _safeMint(_msgSenderERC721A(), tokens);
1863   }
1864 
1865 /// @dev presale mint for whitelisted
1866     function presalemint() public payable nonReentrant {
1867     require(!paused, "ETH: oops contract is paused");
1868     require(preSale, "ETH: Presale Hasnt't started yet");
1869     require(FreeMintofUser[_msgSenderERC721A()] + 1 <= MaxperWalletWl, "ETH: Max NFT Per Wallet exceeded");
1870     require(totalSupply() + 1 <= maxSupply, "ETH: Whitelist MaxSupply exceeded");
1871     require(BanksyNFT.balanceOf(_msgSenderERC721A()) > 1, "You dont have any nfts");
1872 
1873         FreeMintofUser[_msgSenderERC721A()] += 1;
1874       _safeMint(_msgSenderERC721A(), 1);
1875     
1876   }
1877 
1878   /// @dev use it for giveaway and team mint
1879      function airdrop(uint256 _mintAmount, address destination) public onlyOwner nonReentrant {
1880     require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
1881 
1882       _safeMint(destination, _mintAmount);
1883   }
1884 
1885 /// @notice returns metadata link of tokenid
1886   function tokenURI(uint256 tokenId)
1887     public
1888     view
1889     virtual
1890     override
1891     returns (string memory)
1892   {
1893     require(
1894       _exists(tokenId),
1895       "ERC721AMetadata: URI query for nonexistent token"
1896     );
1897     
1898     if(revealed == false) {
1899         return notRevealedUri;
1900     }
1901 
1902     string memory currentBaseURI = _baseURI();
1903     return bytes(currentBaseURI).length > 0
1904         ? string(abi.encodePacked(currentBaseURI, _toString(tokenId), ".json"))
1905         : "";
1906   }
1907 
1908      /// @notice return the number minted by an address
1909     function numberMinted(address owner) public view returns (uint256) {
1910     return _numberMinted(owner);
1911   }
1912 
1913     /// @notice return the tokens owned by an address
1914       function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1915         unchecked {
1916             uint256 tokenIdsIdx;
1917             address currOwnershipAddr;
1918             uint256 tokenIdsLength = balanceOf(owner);
1919             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1920             TokenOwnership memory ownership;
1921             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1922                 ownership = _ownershipAt(i);
1923                 if (ownership.burned) {
1924                     continue;
1925                 }
1926                 if (ownership.addr != address(0)) {
1927                     currOwnershipAddr = ownership.addr;
1928                 }
1929                 if (currOwnershipAddr == owner) {
1930                     tokenIds[tokenIdsIdx++] = i;
1931                 }
1932             }
1933             return tokenIds;
1934         }
1935     }
1936 
1937   //only owner
1938   function reveal(bool _state) public onlyOwner {
1939       revealed = _state;
1940   }
1941 
1942 
1943   /// @dev change the public max per wallet
1944   function setMaxPerWallet(uint256 _limit) public onlyOwner {
1945     MaxperWallet = _limit;
1946   }
1947 
1948   /// @dev change the whitelist max per wallet
1949     function setWlMaxPerWallet(uint256 _limit) public onlyOwner {
1950     MaxperWalletWl = _limit;
1951   }
1952 
1953    /// @dev change the public price(amount need to be in wei)
1954   function setCost(uint256 _newCost) public onlyOwner {
1955     cost = _newCost;
1956   }
1957 
1958 
1959   /// @dev cut the supply if we dont sold out
1960     function setMaxsupply(uint256 _newsupply) public onlyOwner {
1961     maxSupply = _newsupply;
1962   }
1963 
1964  /// @dev set your baseuri
1965   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1966     baseURI = _newBaseURI;
1967   }
1968 
1969    /// @dev set hidden uri
1970   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1971     notRevealedUri = _notRevealedURI;
1972   }
1973 
1974  /// @dev to pause and unpause your contract(use booleans true or false)
1975   function pause(bool _state) public onlyOwner {
1976     paused = _state;
1977   }
1978 
1979      /// @dev activate whitelist sale(use booleans true or false)
1980     function togglepreSale(bool _state) external onlyOwner {
1981         preSale = _state;
1982     }
1983   
1984   /// @dev withdraw funds from contract
1985   function withdraw() public payable onlyOwner nonReentrant {
1986       uint256 balance = address(this).balance;
1987       payable(0x51C14c89DB72fCf4350c48d8eB3e85C0578Af924).transfer(balance);
1988   }
1989 
1990       /// Opensea Royalties
1991 
1992     function transferFrom(
1993         address from,
1994         address to,
1995         uint256 tokenId
1996     ) public payable override onlyAllowedOperator(from) {
1997         super.transferFrom(from, to, tokenId);
1998     }
1999 
2000     function safeTransferFrom(
2001         address from,
2002         address to,
2003         uint256 tokenId
2004     ) public payable override onlyAllowedOperator(from) {
2005         super.safeTransferFrom(from, to, tokenId);
2006     }
2007 
2008     function safeTransferFrom(
2009         address from,
2010         address to,
2011         uint256 tokenId,
2012         bytes memory data
2013     ) public payable override onlyAllowedOperator(from) {
2014         super.safeTransferFrom(from, to, tokenId, data);
2015     }
2016 }