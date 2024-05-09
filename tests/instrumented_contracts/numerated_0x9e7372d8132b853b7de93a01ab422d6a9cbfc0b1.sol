1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: erc721a/contracts/IERC721A.sol
5 
6 
7 // ERC721A Contracts v4.2.3
8 // Creator: Chiru Labs
9 
10 pragma solidity ^0.8.4;
11 
12 /**
13  * @dev Interface of ERC721A.
14  */
15 interface IERC721A {
16     /**
17      * The caller must own the token or be an approved operator.
18      */
19     error ApprovalCallerNotOwnerNorApproved();
20 
21     /**
22      * The token does not exist.
23      */
24     error ApprovalQueryForNonexistentToken();
25 
26     /**
27      * Cannot query the balance for the zero address.
28      */
29     error BalanceQueryForZeroAddress();
30 
31     /**
32      * Cannot mint to the zero address.
33      */
34     error MintToZeroAddress();
35 
36     /**
37      * The quantity of tokens minted must be more than zero.
38      */
39     error MintZeroQuantity();
40 
41     /**
42      * The token does not exist.
43      */
44     error OwnerQueryForNonexistentToken();
45 
46     /**
47      * The caller must own the token or be an approved operator.
48      */
49     error TransferCallerNotOwnerNorApproved();
50 
51     /**
52      * The token must be owned by `from`.
53      */
54     error TransferFromIncorrectOwner();
55 
56     /**
57      * Cannot safely transfer to a contract that does not implement the
58      * ERC721Receiver interface.
59      */
60     error TransferToNonERC721ReceiverImplementer();
61 
62     /**
63      * Cannot transfer to the zero address.
64      */
65     error TransferToZeroAddress();
66 
67     /**
68      * The token does not exist.
69      */
70     error URIQueryForNonexistentToken();
71 
72     /**
73      * The `quantity` minted with ERC2309 exceeds the safety limit.
74      */
75     error MintERC2309QuantityExceedsLimit();
76 
77     /**
78      * The `extraData` cannot be set on an unintialized ownership slot.
79      */
80     error OwnershipNotInitializedForExtraData();
81 
82     // =============================================================
83     //                            STRUCTS
84     // =============================================================
85 
86     struct TokenOwnership {
87         // The address of the owner.
88         address addr;
89         // Stores the start time of ownership with minimal overhead for tokenomics.
90         uint64 startTimestamp;
91         // Whether the token has been burned.
92         bool burned;
93         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
94         uint24 extraData;
95     }
96 
97     // =============================================================
98     //                         TOKEN COUNTERS
99     // =============================================================
100 
101     /**
102      * @dev Returns the total number of tokens in existence.
103      * Burned tokens will reduce the count.
104      * To get the total number of tokens minted, please see {_totalMinted}.
105      */
106     function totalSupply() external view returns (uint256);
107 
108     // =============================================================
109     //                            IERC165
110     // =============================================================
111 
112     /**
113      * @dev Returns true if this contract implements the interface defined by
114      * `interfaceId`. See the corresponding
115      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
116      * to learn more about how these ids are created.
117      *
118      * This function call must use less than 30000 gas.
119      */
120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
121 
122     // =============================================================
123     //                            IERC721
124     // =============================================================
125 
126     /**
127      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
130 
131     /**
132      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
133      */
134     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables or disables
138      * (`approved`) `operator` to manage all of its assets.
139      */
140     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
141 
142     /**
143      * @dev Returns the number of tokens in `owner`'s account.
144      */
145     function balanceOf(address owner) external view returns (uint256 balance);
146 
147     /**
148      * @dev Returns the owner of the `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function ownerOf(uint256 tokenId) external view returns (address owner);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`,
158      * checking first that contract recipients are aware of the ERC721 protocol
159      * to prevent tokens from being forever locked.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be have been allowed to move
167      * this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement
169      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId,
177         bytes calldata data
178     ) external payable;
179 
180     /**
181      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) external payable;
188 
189     /**
190      * @dev Transfers `tokenId` from `from` to `to`.
191      *
192      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
193      * whenever possible.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token
201      * by either {approve} or {setApprovalForAll}.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external payable;
210 
211     /**
212      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
213      * The approval is cleared when the token is transferred.
214      *
215      * Only a single account can be approved at a time, so approving the
216      * zero address clears previous approvals.
217      *
218      * Requirements:
219      *
220      * - The caller must own the token or be an approved operator.
221      * - `tokenId` must exist.
222      *
223      * Emits an {Approval} event.
224      */
225     function approve(address to, uint256 tokenId) external payable;
226 
227     /**
228      * @dev Approve or remove `operator` as an operator for the caller.
229      * Operators can call {transferFrom} or {safeTransferFrom}
230      * for any token owned by the caller.
231      *
232      * Requirements:
233      *
234      * - The `operator` cannot be the caller.
235      *
236      * Emits an {ApprovalForAll} event.
237      */
238     function setApprovalForAll(address operator, bool _approved) external;
239 
240     /**
241      * @dev Returns the account approved for `tokenId` token.
242      *
243      * Requirements:
244      *
245      * - `tokenId` must exist.
246      */
247     function getApproved(uint256 tokenId) external view returns (address operator);
248 
249     /**
250      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
251      *
252      * See {setApprovalForAll}.
253      */
254     function isApprovedForAll(address owner, address operator) external view returns (bool);
255 
256     // =============================================================
257     //                        IERC721Metadata
258     // =============================================================
259 
260     /**
261      * @dev Returns the token collection name.
262      */
263     function name() external view returns (string memory);
264 
265     /**
266      * @dev Returns the token collection symbol.
267      */
268     function symbol() external view returns (string memory);
269 
270     /**
271      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
272      */
273     function tokenURI(uint256 tokenId) external view returns (string memory);
274 
275     // =============================================================
276     //                           IERC2309
277     // =============================================================
278 
279     /**
280      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
281      * (inclusive) is transferred from `from` to `to`, as defined in the
282      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
283      *
284      * See {_mintERC2309} for more details.
285      */
286     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
287 }
288 
289 // File: erc721a/contracts/ERC721A.sol
290 
291 
292 // ERC721A Contracts v4.2.3
293 // Creator: Chiru Labs
294 
295 pragma solidity ^0.8.4;
296 
297 
298 /**
299  * @dev Interface of ERC721 token receiver.
300  */
301 interface ERC721A__IERC721Receiver {
302     function onERC721Received(
303         address operator,
304         address from,
305         uint256 tokenId,
306         bytes calldata data
307     ) external returns (bytes4);
308 }
309 
310 /**
311  * @title ERC721A
312  *
313  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
314  * Non-Fungible Token Standard, including the Metadata extension.
315  * Optimized for lower gas during batch mints.
316  *
317  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
318  * starting from `_startTokenId()`.
319  *
320  * Assumptions:
321  *
322  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
323  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
324  */
325 contract ERC721A is IERC721A {
326     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
327     struct TokenApprovalRef {
328         address value;
329     }
330 
331     // =============================================================
332     //                           CONSTANTS
333     // =============================================================
334 
335     // Mask of an entry in packed address data.
336     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
337 
338     // The bit position of `numberMinted` in packed address data.
339     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
340 
341     // The bit position of `numberBurned` in packed address data.
342     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
343 
344     // The bit position of `aux` in packed address data.
345     uint256 private constant _BITPOS_AUX = 192;
346 
347     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
348     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
349 
350     // The bit position of `startTimestamp` in packed ownership.
351     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
352 
353     // The bit mask of the `burned` bit in packed ownership.
354     uint256 private constant _BITMASK_BURNED = 1 << 224;
355 
356     // The bit position of the `nextInitialized` bit in packed ownership.
357     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
358 
359     // The bit mask of the `nextInitialized` bit in packed ownership.
360     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
361 
362     // The bit position of `extraData` in packed ownership.
363     uint256 private constant _BITPOS_EXTRA_DATA = 232;
364 
365     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
366     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
367 
368     // The mask of the lower 160 bits for addresses.
369     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
370 
371     // The maximum `quantity` that can be minted with {_mintERC2309}.
372     // This limit is to prevent overflows on the address data entries.
373     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
374     // is required to cause an overflow, which is unrealistic.
375     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
376 
377     // The `Transfer` event signature is given by:
378     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
379     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
380         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
381 
382     // =============================================================
383     //                            STORAGE
384     // =============================================================
385 
386     // The next token ID to be minted.
387     uint256 private _currentIndex;
388 
389     // The number of tokens burned.
390     uint256 private _burnCounter;
391 
392     // Token name
393     string private _name;
394 
395     // Token symbol
396     string private _symbol;
397 
398     // Mapping from token ID to ownership details
399     // An empty struct value does not necessarily mean the token is unowned.
400     // See {_packedOwnershipOf} implementation for details.
401     //
402     // Bits Layout:
403     // - [0..159]   `addr`
404     // - [160..223] `startTimestamp`
405     // - [224]      `burned`
406     // - [225]      `nextInitialized`
407     // - [232..255] `extraData`
408     mapping(uint256 => uint256) private _packedOwnerships;
409 
410     // Mapping owner address to address data.
411     //
412     // Bits Layout:
413     // - [0..63]    `balance`
414     // - [64..127]  `numberMinted`
415     // - [128..191] `numberBurned`
416     // - [192..255] `aux`
417     mapping(address => uint256) private _packedAddressData;
418 
419     // Mapping from token ID to approved address.
420     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
421 
422     // Mapping from owner to operator approvals
423     mapping(address => mapping(address => bool)) private _operatorApprovals;
424 
425     // =============================================================
426     //                          CONSTRUCTOR
427     // =============================================================
428 
429     constructor(string memory name_, string memory symbol_) {
430         _name = name_;
431         _symbol = symbol_;
432         _currentIndex = _startTokenId();
433     }
434 
435     // =============================================================
436     //                   TOKEN COUNTING OPERATIONS
437     // =============================================================
438 
439     /**
440      * @dev Returns the starting token ID.
441      * To change the starting token ID, please override this function.
442      */
443     function _startTokenId() internal view virtual returns (uint256) {
444         return 0;
445     }
446 
447     /**
448      * @dev Returns the next token ID to be minted.
449      */
450     function _nextTokenId() internal view virtual returns (uint256) {
451         return _currentIndex;
452     }
453 
454     /**
455      * @dev Returns the total number of tokens in existence.
456      * Burned tokens will reduce the count.
457      * To get the total number of tokens minted, please see {_totalMinted}.
458      */
459     function totalSupply() public view virtual override returns (uint256) {
460         // Counter underflow is impossible as _burnCounter cannot be incremented
461         // more than `_currentIndex - _startTokenId()` times.
462         unchecked {
463             return _currentIndex - _burnCounter - _startTokenId();
464         }
465     }
466 
467     /**
468      * @dev Returns the total amount of tokens minted in the contract.
469      */
470     function _totalMinted() internal view virtual returns (uint256) {
471         // Counter underflow is impossible as `_currentIndex` does not decrement,
472         // and it is initialized to `_startTokenId()`.
473         unchecked {
474             return _currentIndex - _startTokenId();
475         }
476     }
477 
478     /**
479      * @dev Returns the total number of tokens burned.
480      */
481     function _totalBurned() internal view virtual returns (uint256) {
482         return _burnCounter;
483     }
484 
485     // =============================================================
486     //                    ADDRESS DATA OPERATIONS
487     // =============================================================
488 
489     /**
490      * @dev Returns the number of tokens in `owner`'s account.
491      */
492     function balanceOf(address owner) public view virtual override returns (uint256) {
493         if (owner == address(0)) revert BalanceQueryForZeroAddress();
494         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
495     }
496 
497     /**
498      * Returns the number of tokens minted by `owner`.
499      */
500     function _numberMinted(address owner) internal view returns (uint256) {
501         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
502     }
503 
504     /**
505      * Returns the number of tokens burned by or on behalf of `owner`.
506      */
507     function _numberBurned(address owner) internal view returns (uint256) {
508         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
509     }
510 
511     /**
512      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
513      */
514     function _getAux(address owner) internal view returns (uint64) {
515         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
516     }
517 
518     /**
519      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
520      * If there are multiple variables, please pack them into a uint64.
521      */
522     function _setAux(address owner, uint64 aux) internal virtual {
523         uint256 packed = _packedAddressData[owner];
524         uint256 auxCasted;
525         // Cast `aux` with assembly to avoid redundant masking.
526         assembly {
527             auxCasted := aux
528         }
529         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
530         _packedAddressData[owner] = packed;
531     }
532 
533     // =============================================================
534     //                            IERC165
535     // =============================================================
536 
537     /**
538      * @dev Returns true if this contract implements the interface defined by
539      * `interfaceId`. See the corresponding
540      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
541      * to learn more about how these ids are created.
542      *
543      * This function call must use less than 30000 gas.
544      */
545     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
546         // The interface IDs are constants representing the first 4 bytes
547         // of the XOR of all function selectors in the interface.
548         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
549         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
550         return
551             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
552             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
553             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
554     }
555 
556     // =============================================================
557     //                        IERC721Metadata
558     // =============================================================
559 
560     /**
561      * @dev Returns the token collection name.
562      */
563     function name() public view virtual override returns (string memory) {
564         return _name;
565     }
566 
567     /**
568      * @dev Returns the token collection symbol.
569      */
570     function symbol() public view virtual override returns (string memory) {
571         return _symbol;
572     }
573 
574     /**
575      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
576      */
577     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
578         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
579 
580         string memory baseURI = _baseURI();
581         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
582     }
583 
584     /**
585      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
586      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
587      * by default, it can be overridden in child contracts.
588      */
589     function _baseURI() internal view virtual returns (string memory) {
590         return '';
591     }
592 
593     // =============================================================
594     //                     OWNERSHIPS OPERATIONS
595     // =============================================================
596 
597     /**
598      * @dev Returns the owner of the `tokenId` token.
599      *
600      * Requirements:
601      *
602      * - `tokenId` must exist.
603      */
604     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
605         return address(uint160(_packedOwnershipOf(tokenId)));
606     }
607 
608     /**
609      * @dev Gas spent here starts off proportional to the maximum mint batch size.
610      * It gradually moves to O(1) as tokens get transferred around over time.
611      */
612     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
613         return _unpackedOwnership(_packedOwnershipOf(tokenId));
614     }
615 
616     /**
617      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
618      */
619     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
620         return _unpackedOwnership(_packedOwnerships[index]);
621     }
622 
623     /**
624      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
625      */
626     function _initializeOwnershipAt(uint256 index) internal virtual {
627         if (_packedOwnerships[index] == 0) {
628             _packedOwnerships[index] = _packedOwnershipOf(index);
629         }
630     }
631 
632     /**
633      * Returns the packed ownership data of `tokenId`.
634      */
635     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
636         uint256 curr = tokenId;
637 
638         unchecked {
639             if (_startTokenId() <= curr)
640                 if (curr < _currentIndex) {
641                     uint256 packed = _packedOwnerships[curr];
642                     // If not burned.
643                     if (packed & _BITMASK_BURNED == 0) {
644                         // Invariant:
645                         // There will always be an initialized ownership slot
646                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
647                         // before an unintialized ownership slot
648                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
649                         // Hence, `curr` will not underflow.
650                         //
651                         // We can directly compare the packed value.
652                         // If the address is zero, packed will be zero.
653                         while (packed == 0) {
654                             packed = _packedOwnerships[--curr];
655                         }
656                         return packed;
657                     }
658                 }
659         }
660         revert OwnerQueryForNonexistentToken();
661     }
662 
663     /**
664      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
665      */
666     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
667         ownership.addr = address(uint160(packed));
668         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
669         ownership.burned = packed & _BITMASK_BURNED != 0;
670         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
671     }
672 
673     /**
674      * @dev Packs ownership data into a single uint256.
675      */
676     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
677         assembly {
678             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
679             owner := and(owner, _BITMASK_ADDRESS)
680             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
681             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
682         }
683     }
684 
685     /**
686      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
687      */
688     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
689         // For branchless setting of the `nextInitialized` flag.
690         assembly {
691             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
692             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
693         }
694     }
695 
696     // =============================================================
697     //                      APPROVAL OPERATIONS
698     // =============================================================
699 
700     /**
701      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
702      * The approval is cleared when the token is transferred.
703      *
704      * Only a single account can be approved at a time, so approving the
705      * zero address clears previous approvals.
706      *
707      * Requirements:
708      *
709      * - The caller must own the token or be an approved operator.
710      * - `tokenId` must exist.
711      *
712      * Emits an {Approval} event.
713      */
714     function approve(address to, uint256 tokenId) public payable virtual override {
715         address owner = ownerOf(tokenId);
716 
717         if (_msgSenderERC721A() != owner)
718             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
719                 revert ApprovalCallerNotOwnerNorApproved();
720             }
721 
722         _tokenApprovals[tokenId].value = to;
723         emit Approval(owner, to, tokenId);
724     }
725 
726     /**
727      * @dev Returns the account approved for `tokenId` token.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must exist.
732      */
733     function getApproved(uint256 tokenId) public view virtual override returns (address) {
734         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
735 
736         return _tokenApprovals[tokenId].value;
737     }
738 
739     /**
740      * @dev Approve or remove `operator` as an operator for the caller.
741      * Operators can call {transferFrom} or {safeTransferFrom}
742      * for any token owned by the caller.
743      *
744      * Requirements:
745      *
746      * - The `operator` cannot be the caller.
747      *
748      * Emits an {ApprovalForAll} event.
749      */
750     function setApprovalForAll(address operator, bool approved) public virtual override {
751         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
752         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
753     }
754 
755     /**
756      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
757      *
758      * See {setApprovalForAll}.
759      */
760     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
761         return _operatorApprovals[owner][operator];
762     }
763 
764     /**
765      * @dev Returns whether `tokenId` exists.
766      *
767      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
768      *
769      * Tokens start existing when they are minted. See {_mint}.
770      */
771     function _exists(uint256 tokenId) internal view virtual returns (bool) {
772         return
773             _startTokenId() <= tokenId &&
774             tokenId < _currentIndex && // If within bounds,
775             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
776     }
777 
778     /**
779      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
780      */
781     function _isSenderApprovedOrOwner(
782         address approvedAddress,
783         address owner,
784         address msgSender
785     ) private pure returns (bool result) {
786         assembly {
787             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
788             owner := and(owner, _BITMASK_ADDRESS)
789             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
790             msgSender := and(msgSender, _BITMASK_ADDRESS)
791             // `msgSender == owner || msgSender == approvedAddress`.
792             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
793         }
794     }
795 
796     /**
797      * @dev Returns the storage slot and value for the approved address of `tokenId`.
798      */
799     function _getApprovedSlotAndAddress(uint256 tokenId)
800         private
801         view
802         returns (uint256 approvedAddressSlot, address approvedAddress)
803     {
804         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
805         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
806         assembly {
807             approvedAddressSlot := tokenApproval.slot
808             approvedAddress := sload(approvedAddressSlot)
809         }
810     }
811 
812     // =============================================================
813     //                      TRANSFER OPERATIONS
814     // =============================================================
815 
816     /**
817      * @dev Transfers `tokenId` from `from` to `to`.
818      *
819      * Requirements:
820      *
821      * - `from` cannot be the zero address.
822      * - `to` cannot be the zero address.
823      * - `tokenId` token must be owned by `from`.
824      * - If the caller is not `from`, it must be approved to move this token
825      * by either {approve} or {setApprovalForAll}.
826      *
827      * Emits a {Transfer} event.
828      */
829     function transferFrom(
830         address from,
831         address to,
832         uint256 tokenId
833     ) public payable virtual override {
834         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
835 
836         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
837 
838         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
839 
840         // The nested ifs save around 20+ gas over a compound boolean condition.
841         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
842             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
843 
844         if (to == address(0)) revert TransferToZeroAddress();
845 
846         _beforeTokenTransfers(from, to, tokenId, 1);
847 
848         // Clear approvals from the previous owner.
849         assembly {
850             if approvedAddress {
851                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
852                 sstore(approvedAddressSlot, 0)
853             }
854         }
855 
856         // Underflow of the sender's balance is impossible because we check for
857         // ownership above and the recipient's balance can't realistically overflow.
858         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
859         unchecked {
860             // We can directly increment and decrement the balances.
861             --_packedAddressData[from]; // Updates: `balance -= 1`.
862             ++_packedAddressData[to]; // Updates: `balance += 1`.
863 
864             // Updates:
865             // - `address` to the next owner.
866             // - `startTimestamp` to the timestamp of transfering.
867             // - `burned` to `false`.
868             // - `nextInitialized` to `true`.
869             _packedOwnerships[tokenId] = _packOwnershipData(
870                 to,
871                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
872             );
873 
874             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
875             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
876                 uint256 nextTokenId = tokenId + 1;
877                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
878                 if (_packedOwnerships[nextTokenId] == 0) {
879                     // If the next slot is within bounds.
880                     if (nextTokenId != _currentIndex) {
881                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
882                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
883                     }
884                 }
885             }
886         }
887 
888         emit Transfer(from, to, tokenId);
889         _afterTokenTransfers(from, to, tokenId, 1);
890     }
891 
892     /**
893      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) public payable virtual override {
900         safeTransferFrom(from, to, tokenId, '');
901     }
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`.
905      *
906      * Requirements:
907      *
908      * - `from` cannot be the zero address.
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must exist and be owned by `from`.
911      * - If the caller is not `from`, it must be approved to move this token
912      * by either {approve} or {setApprovalForAll}.
913      * - If `to` refers to a smart contract, it must implement
914      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
915      *
916      * Emits a {Transfer} event.
917      */
918     function safeTransferFrom(
919         address from,
920         address to,
921         uint256 tokenId,
922         bytes memory _data
923     ) public payable virtual override {
924         transferFrom(from, to, tokenId);
925         if (to.code.length != 0)
926             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
927                 revert TransferToNonERC721ReceiverImplementer();
928             }
929     }
930 
931     /**
932      * @dev Hook that is called before a set of serially-ordered token IDs
933      * are about to be transferred. This includes minting.
934      * And also called before burning one token.
935      *
936      * `startTokenId` - the first token ID to be transferred.
937      * `quantity` - the amount to be transferred.
938      *
939      * Calling conditions:
940      *
941      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
942      * transferred to `to`.
943      * - When `from` is zero, `tokenId` will be minted for `to`.
944      * - When `to` is zero, `tokenId` will be burned by `from`.
945      * - `from` and `to` are never both zero.
946      */
947     function _beforeTokenTransfers(
948         address from,
949         address to,
950         uint256 startTokenId,
951         uint256 quantity
952     ) internal virtual {}
953 
954     /**
955      * @dev Hook that is called after a set of serially-ordered token IDs
956      * have been transferred. This includes minting.
957      * And also called after one token has been burned.
958      *
959      * `startTokenId` - the first token ID to be transferred.
960      * `quantity` - the amount to be transferred.
961      *
962      * Calling conditions:
963      *
964      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
965      * transferred to `to`.
966      * - When `from` is zero, `tokenId` has been minted for `to`.
967      * - When `to` is zero, `tokenId` has been burned by `from`.
968      * - `from` and `to` are never both zero.
969      */
970     function _afterTokenTransfers(
971         address from,
972         address to,
973         uint256 startTokenId,
974         uint256 quantity
975     ) internal virtual {}
976 
977     /**
978      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
979      *
980      * `from` - Previous owner of the given token ID.
981      * `to` - Target address that will receive the token.
982      * `tokenId` - Token ID to be transferred.
983      * `_data` - Optional data to send along with the call.
984      *
985      * Returns whether the call correctly returned the expected magic value.
986      */
987     function _checkContractOnERC721Received(
988         address from,
989         address to,
990         uint256 tokenId,
991         bytes memory _data
992     ) private returns (bool) {
993         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
994             bytes4 retval
995         ) {
996             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
997         } catch (bytes memory reason) {
998             if (reason.length == 0) {
999                 revert TransferToNonERC721ReceiverImplementer();
1000             } else {
1001                 assembly {
1002                     revert(add(32, reason), mload(reason))
1003                 }
1004             }
1005         }
1006     }
1007 
1008     // =============================================================
1009     //                        MINT OPERATIONS
1010     // =============================================================
1011 
1012     /**
1013      * @dev Mints `quantity` tokens and transfers them to `to`.
1014      *
1015      * Requirements:
1016      *
1017      * - `to` cannot be the zero address.
1018      * - `quantity` must be greater than 0.
1019      *
1020      * Emits a {Transfer} event for each mint.
1021      */
1022     function _mint(address to, uint256 quantity) internal virtual {
1023         uint256 startTokenId = _currentIndex;
1024         if (quantity == 0) revert MintZeroQuantity();
1025 
1026         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1027 
1028         // Overflows are incredibly unrealistic.
1029         // `balance` and `numberMinted` have a maximum limit of 2**64.
1030         // `tokenId` has a maximum limit of 2**256.
1031         unchecked {
1032             // Updates:
1033             // - `balance += quantity`.
1034             // - `numberMinted += quantity`.
1035             //
1036             // We can directly add to the `balance` and `numberMinted`.
1037             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1038 
1039             // Updates:
1040             // - `address` to the owner.
1041             // - `startTimestamp` to the timestamp of minting.
1042             // - `burned` to `false`.
1043             // - `nextInitialized` to `quantity == 1`.
1044             _packedOwnerships[startTokenId] = _packOwnershipData(
1045                 to,
1046                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1047             );
1048 
1049             uint256 toMasked;
1050             uint256 end = startTokenId + quantity;
1051 
1052             // Use assembly to loop and emit the `Transfer` event for gas savings.
1053             // The duplicated `log4` removes an extra check and reduces stack juggling.
1054             // The assembly, together with the surrounding Solidity code, have been
1055             // delicately arranged to nudge the compiler into producing optimized opcodes.
1056             assembly {
1057                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1058                 toMasked := and(to, _BITMASK_ADDRESS)
1059                 // Emit the `Transfer` event.
1060                 log4(
1061                     0, // Start of data (0, since no data).
1062                     0, // End of data (0, since no data).
1063                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1064                     0, // `address(0)`.
1065                     toMasked, // `to`.
1066                     startTokenId // `tokenId`.
1067                 )
1068 
1069                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1070                 // that overflows uint256 will make the loop run out of gas.
1071                 // The compiler will optimize the `iszero` away for performance.
1072                 for {
1073                     let tokenId := add(startTokenId, 1)
1074                 } iszero(eq(tokenId, end)) {
1075                     tokenId := add(tokenId, 1)
1076                 } {
1077                     // Emit the `Transfer` event. Similar to above.
1078                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1079                 }
1080             }
1081             if (toMasked == 0) revert MintToZeroAddress();
1082 
1083             _currentIndex = end;
1084         }
1085         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1086     }
1087 
1088     /**
1089      * @dev Mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * This function is intended for efficient minting only during contract creation.
1092      *
1093      * It emits only one {ConsecutiveTransfer} as defined in
1094      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1095      * instead of a sequence of {Transfer} event(s).
1096      *
1097      * Calling this function outside of contract creation WILL make your contract
1098      * non-compliant with the ERC721 standard.
1099      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1100      * {ConsecutiveTransfer} event is only permissible during contract creation.
1101      *
1102      * Requirements:
1103      *
1104      * - `to` cannot be the zero address.
1105      * - `quantity` must be greater than 0.
1106      *
1107      * Emits a {ConsecutiveTransfer} event.
1108      */
1109     function _mintERC2309(address to, uint256 quantity) internal virtual {
1110         uint256 startTokenId = _currentIndex;
1111         if (to == address(0)) revert MintToZeroAddress();
1112         if (quantity == 0) revert MintZeroQuantity();
1113         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1114 
1115         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1116 
1117         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1118         unchecked {
1119             // Updates:
1120             // - `balance += quantity`.
1121             // - `numberMinted += quantity`.
1122             //
1123             // We can directly add to the `balance` and `numberMinted`.
1124             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1125 
1126             // Updates:
1127             // - `address` to the owner.
1128             // - `startTimestamp` to the timestamp of minting.
1129             // - `burned` to `false`.
1130             // - `nextInitialized` to `quantity == 1`.
1131             _packedOwnerships[startTokenId] = _packOwnershipData(
1132                 to,
1133                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1134             );
1135 
1136             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1137 
1138             _currentIndex = startTokenId + quantity;
1139         }
1140         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1141     }
1142 
1143     /**
1144      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - If `to` refers to a smart contract, it must implement
1149      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1150      * - `quantity` must be greater than 0.
1151      *
1152      * See {_mint}.
1153      *
1154      * Emits a {Transfer} event for each mint.
1155      */
1156     function _safeMint(
1157         address to,
1158         uint256 quantity,
1159         bytes memory _data
1160     ) internal virtual {
1161         _mint(to, quantity);
1162 
1163         unchecked {
1164             if (to.code.length != 0) {
1165                 uint256 end = _currentIndex;
1166                 uint256 index = end - quantity;
1167                 do {
1168                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1169                         revert TransferToNonERC721ReceiverImplementer();
1170                     }
1171                 } while (index < end);
1172                 // Reentrancy protection.
1173                 if (_currentIndex != end) revert();
1174             }
1175         }
1176     }
1177 
1178     /**
1179      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1180      */
1181     function _safeMint(address to, uint256 quantity) internal virtual {
1182         _safeMint(to, quantity, '');
1183     }
1184 
1185     // =============================================================
1186     //                        BURN OPERATIONS
1187     // =============================================================
1188 
1189     /**
1190      * @dev Equivalent to `_burn(tokenId, false)`.
1191      */
1192     function _burn(uint256 tokenId) internal virtual {
1193         _burn(tokenId, false);
1194     }
1195 
1196     /**
1197      * @dev Destroys `tokenId`.
1198      * The approval is cleared when the token is burned.
1199      *
1200      * Requirements:
1201      *
1202      * - `tokenId` must exist.
1203      *
1204      * Emits a {Transfer} event.
1205      */
1206     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1207         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1208 
1209         address from = address(uint160(prevOwnershipPacked));
1210 
1211         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1212 
1213         if (approvalCheck) {
1214             // The nested ifs save around 20+ gas over a compound boolean condition.
1215             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1216                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1217         }
1218 
1219         _beforeTokenTransfers(from, address(0), tokenId, 1);
1220 
1221         // Clear approvals from the previous owner.
1222         assembly {
1223             if approvedAddress {
1224                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1225                 sstore(approvedAddressSlot, 0)
1226             }
1227         }
1228 
1229         // Underflow of the sender's balance is impossible because we check for
1230         // ownership above and the recipient's balance can't realistically overflow.
1231         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1232         unchecked {
1233             // Updates:
1234             // - `balance -= 1`.
1235             // - `numberBurned += 1`.
1236             //
1237             // We can directly decrement the balance, and increment the number burned.
1238             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1239             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1240 
1241             // Updates:
1242             // - `address` to the last owner.
1243             // - `startTimestamp` to the timestamp of burning.
1244             // - `burned` to `true`.
1245             // - `nextInitialized` to `true`.
1246             _packedOwnerships[tokenId] = _packOwnershipData(
1247                 from,
1248                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1249             );
1250 
1251             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1252             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1253                 uint256 nextTokenId = tokenId + 1;
1254                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1255                 if (_packedOwnerships[nextTokenId] == 0) {
1256                     // If the next slot is within bounds.
1257                     if (nextTokenId != _currentIndex) {
1258                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1259                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1260                     }
1261                 }
1262             }
1263         }
1264 
1265         emit Transfer(from, address(0), tokenId);
1266         _afterTokenTransfers(from, address(0), tokenId, 1);
1267 
1268         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1269         unchecked {
1270             _burnCounter++;
1271         }
1272     }
1273 
1274     // =============================================================
1275     //                     EXTRA DATA OPERATIONS
1276     // =============================================================
1277 
1278     /**
1279      * @dev Directly sets the extra data for the ownership data `index`.
1280      */
1281     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1282         uint256 packed = _packedOwnerships[index];
1283         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1284         uint256 extraDataCasted;
1285         // Cast `extraData` with assembly to avoid redundant masking.
1286         assembly {
1287             extraDataCasted := extraData
1288         }
1289         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1290         _packedOwnerships[index] = packed;
1291     }
1292 
1293     /**
1294      * @dev Called during each token transfer to set the 24bit `extraData` field.
1295      * Intended to be overridden by the cosumer contract.
1296      *
1297      * `previousExtraData` - the value of `extraData` before transfer.
1298      *
1299      * Calling conditions:
1300      *
1301      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1302      * transferred to `to`.
1303      * - When `from` is zero, `tokenId` will be minted for `to`.
1304      * - When `to` is zero, `tokenId` will be burned by `from`.
1305      * - `from` and `to` are never both zero.
1306      */
1307     function _extraData(
1308         address from,
1309         address to,
1310         uint24 previousExtraData
1311     ) internal view virtual returns (uint24) {}
1312 
1313     /**
1314      * @dev Returns the next extra data for the packed ownership data.
1315      * The returned result is shifted into position.
1316      */
1317     function _nextExtraData(
1318         address from,
1319         address to,
1320         uint256 prevOwnershipPacked
1321     ) private view returns (uint256) {
1322         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1323         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1324     }
1325 
1326     // =============================================================
1327     //                       OTHER OPERATIONS
1328     // =============================================================
1329 
1330     /**
1331      * @dev Returns the message sender (defaults to `msg.sender`).
1332      *
1333      * If you are writing GSN compatible contracts, you need to override this function.
1334      */
1335     function _msgSenderERC721A() internal view virtual returns (address) {
1336         return msg.sender;
1337     }
1338 
1339     /**
1340      * @dev Converts a uint256 to its ASCII string decimal representation.
1341      */
1342     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1343         assembly {
1344             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1345             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1346             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1347             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1348             let m := add(mload(0x40), 0xa0)
1349             // Update the free memory pointer to allocate.
1350             mstore(0x40, m)
1351             // Assign the `str` to the end.
1352             str := sub(m, 0x20)
1353             // Zeroize the slot after the string.
1354             mstore(str, 0)
1355 
1356             // Cache the end of the memory to calculate the length later.
1357             let end := str
1358 
1359             // We write the string from rightmost digit to leftmost digit.
1360             // The following is essentially a do-while loop that also handles the zero case.
1361             // prettier-ignore
1362             for { let temp := value } 1 {} {
1363                 str := sub(str, 1)
1364                 // Write the character to the pointer.
1365                 // The ASCII index of the '0' character is 48.
1366                 mstore8(str, add(48, mod(temp, 10)))
1367                 // Keep dividing `temp` until zero.
1368                 temp := div(temp, 10)
1369                 // prettier-ignore
1370                 if iszero(temp) { break }
1371             }
1372 
1373             let length := sub(end, str)
1374             // Move the pointer 32 bytes leftwards to make room for the length.
1375             str := sub(str, 0x20)
1376             // Store the length.
1377             mstore(str, length)
1378         }
1379     }
1380 }
1381 
1382 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1383 
1384 
1385 // ERC721A Contracts v4.2.3
1386 // Creator: Chiru Labs
1387 
1388 pragma solidity ^0.8.4;
1389 
1390 
1391 /**
1392  * @dev Interface of ERC721AQueryable.
1393  */
1394 interface IERC721AQueryable is IERC721A {
1395     /**
1396      * Invalid query range (`start` >= `stop`).
1397      */
1398     error InvalidQueryRange();
1399 
1400     /**
1401      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1402      *
1403      * If the `tokenId` is out of bounds:
1404      *
1405      * - `addr = address(0)`
1406      * - `startTimestamp = 0`
1407      * - `burned = false`
1408      * - `extraData = 0`
1409      *
1410      * If the `tokenId` is burned:
1411      *
1412      * - `addr = <Address of owner before token was burned>`
1413      * - `startTimestamp = <Timestamp when token was burned>`
1414      * - `burned = true`
1415      * - `extraData = <Extra data when token was burned>`
1416      *
1417      * Otherwise:
1418      *
1419      * - `addr = <Address of owner>`
1420      * - `startTimestamp = <Timestamp of start of ownership>`
1421      * - `burned = false`
1422      * - `extraData = <Extra data at start of ownership>`
1423      */
1424     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1425 
1426     /**
1427      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1428      * See {ERC721AQueryable-explicitOwnershipOf}
1429      */
1430     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1431 
1432     /**
1433      * @dev Returns an array of token IDs owned by `owner`,
1434      * in the range [`start`, `stop`)
1435      * (i.e. `start <= tokenId < stop`).
1436      *
1437      * This function allows for tokens to be queried if the collection
1438      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1439      *
1440      * Requirements:
1441      *
1442      * - `start < stop`
1443      */
1444     function tokensOfOwnerIn(
1445         address owner,
1446         uint256 start,
1447         uint256 stop
1448     ) external view returns (uint256[] memory);
1449 
1450     /**
1451      * @dev Returns an array of token IDs owned by `owner`.
1452      *
1453      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1454      * It is meant to be called off-chain.
1455      *
1456      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1457      * multiple smaller scans if the collection is large enough to cause
1458      * an out-of-gas error (10K collections should be fine).
1459      */
1460     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1461 }
1462 
1463 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1464 
1465 
1466 // ERC721A Contracts v4.2.3
1467 // Creator: Chiru Labs
1468 
1469 pragma solidity ^0.8.4;
1470 
1471 
1472 
1473 /**
1474  * @title ERC721AQueryable.
1475  *
1476  * @dev ERC721A subclass with convenience query functions.
1477  */
1478 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1479     /**
1480      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1481      *
1482      * If the `tokenId` is out of bounds:
1483      *
1484      * - `addr = address(0)`
1485      * - `startTimestamp = 0`
1486      * - `burned = false`
1487      * - `extraData = 0`
1488      *
1489      * If the `tokenId` is burned:
1490      *
1491      * - `addr = <Address of owner before token was burned>`
1492      * - `startTimestamp = <Timestamp when token was burned>`
1493      * - `burned = true`
1494      * - `extraData = <Extra data when token was burned>`
1495      *
1496      * Otherwise:
1497      *
1498      * - `addr = <Address of owner>`
1499      * - `startTimestamp = <Timestamp of start of ownership>`
1500      * - `burned = false`
1501      * - `extraData = <Extra data at start of ownership>`
1502      */
1503     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1504         TokenOwnership memory ownership;
1505         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1506             return ownership;
1507         }
1508         ownership = _ownershipAt(tokenId);
1509         if (ownership.burned) {
1510             return ownership;
1511         }
1512         return _ownershipOf(tokenId);
1513     }
1514 
1515     /**
1516      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1517      * See {ERC721AQueryable-explicitOwnershipOf}
1518      */
1519     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1520         external
1521         view
1522         virtual
1523         override
1524         returns (TokenOwnership[] memory)
1525     {
1526         unchecked {
1527             uint256 tokenIdsLength = tokenIds.length;
1528             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1529             for (uint256 i; i != tokenIdsLength; ++i) {
1530                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1531             }
1532             return ownerships;
1533         }
1534     }
1535 
1536     /**
1537      * @dev Returns an array of token IDs owned by `owner`,
1538      * in the range [`start`, `stop`)
1539      * (i.e. `start <= tokenId < stop`).
1540      *
1541      * This function allows for tokens to be queried if the collection
1542      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1543      *
1544      * Requirements:
1545      *
1546      * - `start < stop`
1547      */
1548     function tokensOfOwnerIn(
1549         address owner,
1550         uint256 start,
1551         uint256 stop
1552     ) external view virtual override returns (uint256[] memory) {
1553         unchecked {
1554             if (start >= stop) revert InvalidQueryRange();
1555             uint256 tokenIdsIdx;
1556             uint256 stopLimit = _nextTokenId();
1557             // Set `start = max(start, _startTokenId())`.
1558             if (start < _startTokenId()) {
1559                 start = _startTokenId();
1560             }
1561             // Set `stop = min(stop, stopLimit)`.
1562             if (stop > stopLimit) {
1563                 stop = stopLimit;
1564             }
1565             uint256 tokenIdsMaxLength = balanceOf(owner);
1566             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1567             // to cater for cases where `balanceOf(owner)` is too big.
1568             if (start < stop) {
1569                 uint256 rangeLength = stop - start;
1570                 if (rangeLength < tokenIdsMaxLength) {
1571                     tokenIdsMaxLength = rangeLength;
1572                 }
1573             } else {
1574                 tokenIdsMaxLength = 0;
1575             }
1576             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1577             if (tokenIdsMaxLength == 0) {
1578                 return tokenIds;
1579             }
1580             // We need to call `explicitOwnershipOf(start)`,
1581             // because the slot at `start` may not be initialized.
1582             TokenOwnership memory ownership = explicitOwnershipOf(start);
1583             address currOwnershipAddr;
1584             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1585             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1586             if (!ownership.burned) {
1587                 currOwnershipAddr = ownership.addr;
1588             }
1589             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1590                 ownership = _ownershipAt(i);
1591                 if (ownership.burned) {
1592                     continue;
1593                 }
1594                 if (ownership.addr != address(0)) {
1595                     currOwnershipAddr = ownership.addr;
1596                 }
1597                 if (currOwnershipAddr == owner) {
1598                     tokenIds[tokenIdsIdx++] = i;
1599                 }
1600             }
1601             // Downsize the array to fit.
1602             assembly {
1603                 mstore(tokenIds, tokenIdsIdx)
1604             }
1605             return tokenIds;
1606         }
1607     }
1608 
1609     /**
1610      * @dev Returns an array of token IDs owned by `owner`.
1611      *
1612      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1613      * It is meant to be called off-chain.
1614      *
1615      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1616      * multiple smaller scans if the collection is large enough to cause
1617      * an out-of-gas error (10K collections should be fine).
1618      */
1619     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1620         unchecked {
1621             uint256 tokenIdsIdx;
1622             address currOwnershipAddr;
1623             uint256 tokenIdsLength = balanceOf(owner);
1624             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1625             TokenOwnership memory ownership;
1626             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1627                 ownership = _ownershipAt(i);
1628                 if (ownership.burned) {
1629                     continue;
1630                 }
1631                 if (ownership.addr != address(0)) {
1632                     currOwnershipAddr = ownership.addr;
1633                 }
1634                 if (currOwnershipAddr == owner) {
1635                     tokenIds[tokenIdsIdx++] = i;
1636                 }
1637             }
1638             return tokenIds;
1639         }
1640     }
1641 }
1642 
1643 // File: @openzeppelin/contracts/utils/math/Math.sol
1644 
1645 
1646 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1647 
1648 pragma solidity ^0.8.0;
1649 
1650 /**
1651  * @dev Standard math utilities missing in the Solidity language.
1652  */
1653 library Math {
1654     enum Rounding {
1655         Down, // Toward negative infinity
1656         Up, // Toward infinity
1657         Zero // Toward zero
1658     }
1659 
1660     /**
1661      * @dev Returns the largest of two numbers.
1662      */
1663     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1664         return a > b ? a : b;
1665     }
1666 
1667     /**
1668      * @dev Returns the smallest of two numbers.
1669      */
1670     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1671         return a < b ? a : b;
1672     }
1673 
1674     /**
1675      * @dev Returns the average of two numbers. The result is rounded towards
1676      * zero.
1677      */
1678     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1679         // (a + b) / 2 can overflow.
1680         return (a & b) + (a ^ b) / 2;
1681     }
1682 
1683     /**
1684      * @dev Returns the ceiling of the division of two numbers.
1685      *
1686      * This differs from standard division with `/` in that it rounds up instead
1687      * of rounding down.
1688      */
1689     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1690         // (a + b - 1) / b can overflow on addition, so we distribute.
1691         return a == 0 ? 0 : (a - 1) / b + 1;
1692     }
1693 
1694     /**
1695      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1696      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1697      * with further edits by Uniswap Labs also under MIT license.
1698      */
1699     function mulDiv(
1700         uint256 x,
1701         uint256 y,
1702         uint256 denominator
1703     ) internal pure returns (uint256 result) {
1704         unchecked {
1705             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1706             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1707             // variables such that product = prod1 * 2^256 + prod0.
1708             uint256 prod0; // Least significant 256 bits of the product
1709             uint256 prod1; // Most significant 256 bits of the product
1710             assembly {
1711                 let mm := mulmod(x, y, not(0))
1712                 prod0 := mul(x, y)
1713                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1714             }
1715 
1716             // Handle non-overflow cases, 256 by 256 division.
1717             if (prod1 == 0) {
1718                 return prod0 / denominator;
1719             }
1720 
1721             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1722             require(denominator > prod1);
1723 
1724             ///////////////////////////////////////////////
1725             // 512 by 256 division.
1726             ///////////////////////////////////////////////
1727 
1728             // Make division exact by subtracting the remainder from [prod1 prod0].
1729             uint256 remainder;
1730             assembly {
1731                 // Compute remainder using mulmod.
1732                 remainder := mulmod(x, y, denominator)
1733 
1734                 // Subtract 256 bit number from 512 bit number.
1735                 prod1 := sub(prod1, gt(remainder, prod0))
1736                 prod0 := sub(prod0, remainder)
1737             }
1738 
1739             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1740             // See https://cs.stackexchange.com/q/138556/92363.
1741 
1742             // Does not overflow because the denominator cannot be zero at this stage in the function.
1743             uint256 twos = denominator & (~denominator + 1);
1744             assembly {
1745                 // Divide denominator by twos.
1746                 denominator := div(denominator, twos)
1747 
1748                 // Divide [prod1 prod0] by twos.
1749                 prod0 := div(prod0, twos)
1750 
1751                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1752                 twos := add(div(sub(0, twos), twos), 1)
1753             }
1754 
1755             // Shift in bits from prod1 into prod0.
1756             prod0 |= prod1 * twos;
1757 
1758             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1759             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1760             // four bits. That is, denominator * inv = 1 mod 2^4.
1761             uint256 inverse = (3 * denominator) ^ 2;
1762 
1763             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1764             // in modular arithmetic, doubling the correct bits in each step.
1765             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1766             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1767             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1768             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1769             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1770             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1771 
1772             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1773             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1774             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1775             // is no longer required.
1776             result = prod0 * inverse;
1777             return result;
1778         }
1779     }
1780 
1781     /**
1782      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1783      */
1784     function mulDiv(
1785         uint256 x,
1786         uint256 y,
1787         uint256 denominator,
1788         Rounding rounding
1789     ) internal pure returns (uint256) {
1790         uint256 result = mulDiv(x, y, denominator);
1791         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1792             result += 1;
1793         }
1794         return result;
1795     }
1796 
1797     /**
1798      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1799      *
1800      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1801      */
1802     function sqrt(uint256 a) internal pure returns (uint256) {
1803         if (a == 0) {
1804             return 0;
1805         }
1806 
1807         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1808         //
1809         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1810         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1811         //
1812         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1813         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1814         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1815         //
1816         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1817         uint256 result = 1 << (log2(a) >> 1);
1818 
1819         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1820         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1821         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1822         // into the expected uint128 result.
1823         unchecked {
1824             result = (result + a / result) >> 1;
1825             result = (result + a / result) >> 1;
1826             result = (result + a / result) >> 1;
1827             result = (result + a / result) >> 1;
1828             result = (result + a / result) >> 1;
1829             result = (result + a / result) >> 1;
1830             result = (result + a / result) >> 1;
1831             return min(result, a / result);
1832         }
1833     }
1834 
1835     /**
1836      * @notice Calculates sqrt(a), following the selected rounding direction.
1837      */
1838     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1839         unchecked {
1840             uint256 result = sqrt(a);
1841             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1842         }
1843     }
1844 
1845     /**
1846      * @dev Return the log in base 2, rounded down, of a positive value.
1847      * Returns 0 if given 0.
1848      */
1849     function log2(uint256 value) internal pure returns (uint256) {
1850         uint256 result = 0;
1851         unchecked {
1852             if (value >> 128 > 0) {
1853                 value >>= 128;
1854                 result += 128;
1855             }
1856             if (value >> 64 > 0) {
1857                 value >>= 64;
1858                 result += 64;
1859             }
1860             if (value >> 32 > 0) {
1861                 value >>= 32;
1862                 result += 32;
1863             }
1864             if (value >> 16 > 0) {
1865                 value >>= 16;
1866                 result += 16;
1867             }
1868             if (value >> 8 > 0) {
1869                 value >>= 8;
1870                 result += 8;
1871             }
1872             if (value >> 4 > 0) {
1873                 value >>= 4;
1874                 result += 4;
1875             }
1876             if (value >> 2 > 0) {
1877                 value >>= 2;
1878                 result += 2;
1879             }
1880             if (value >> 1 > 0) {
1881                 result += 1;
1882             }
1883         }
1884         return result;
1885     }
1886 
1887     /**
1888      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1889      * Returns 0 if given 0.
1890      */
1891     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1892         unchecked {
1893             uint256 result = log2(value);
1894             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1895         }
1896     }
1897 
1898     /**
1899      * @dev Return the log in base 10, rounded down, of a positive value.
1900      * Returns 0 if given 0.
1901      */
1902     function log10(uint256 value) internal pure returns (uint256) {
1903         uint256 result = 0;
1904         unchecked {
1905             if (value >= 10**64) {
1906                 value /= 10**64;
1907                 result += 64;
1908             }
1909             if (value >= 10**32) {
1910                 value /= 10**32;
1911                 result += 32;
1912             }
1913             if (value >= 10**16) {
1914                 value /= 10**16;
1915                 result += 16;
1916             }
1917             if (value >= 10**8) {
1918                 value /= 10**8;
1919                 result += 8;
1920             }
1921             if (value >= 10**4) {
1922                 value /= 10**4;
1923                 result += 4;
1924             }
1925             if (value >= 10**2) {
1926                 value /= 10**2;
1927                 result += 2;
1928             }
1929             if (value >= 10**1) {
1930                 result += 1;
1931             }
1932         }
1933         return result;
1934     }
1935 
1936     /**
1937      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1938      * Returns 0 if given 0.
1939      */
1940     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1941         unchecked {
1942             uint256 result = log10(value);
1943             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1944         }
1945     }
1946 
1947     /**
1948      * @dev Return the log in base 256, rounded down, of a positive value.
1949      * Returns 0 if given 0.
1950      *
1951      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1952      */
1953     function log256(uint256 value) internal pure returns (uint256) {
1954         uint256 result = 0;
1955         unchecked {
1956             if (value >> 128 > 0) {
1957                 value >>= 128;
1958                 result += 16;
1959             }
1960             if (value >> 64 > 0) {
1961                 value >>= 64;
1962                 result += 8;
1963             }
1964             if (value >> 32 > 0) {
1965                 value >>= 32;
1966                 result += 4;
1967             }
1968             if (value >> 16 > 0) {
1969                 value >>= 16;
1970                 result += 2;
1971             }
1972             if (value >> 8 > 0) {
1973                 result += 1;
1974             }
1975         }
1976         return result;
1977     }
1978 
1979     /**
1980      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1981      * Returns 0 if given 0.
1982      */
1983     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1984         unchecked {
1985             uint256 result = log256(value);
1986             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1987         }
1988     }
1989 }
1990 
1991 // File: @openzeppelin/contracts/utils/Strings.sol
1992 
1993 
1994 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1995 
1996 pragma solidity ^0.8.0;
1997 
1998 
1999 /**
2000  * @dev String operations.
2001  */
2002 library Strings {
2003     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2004     uint8 private constant _ADDRESS_LENGTH = 20;
2005 
2006     /**
2007      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2008      */
2009     function toString(uint256 value) internal pure returns (string memory) {
2010         unchecked {
2011             uint256 length = Math.log10(value) + 1;
2012             string memory buffer = new string(length);
2013             uint256 ptr;
2014             /// @solidity memory-safe-assembly
2015             assembly {
2016                 ptr := add(buffer, add(32, length))
2017             }
2018             while (true) {
2019                 ptr--;
2020                 /// @solidity memory-safe-assembly
2021                 assembly {
2022                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2023                 }
2024                 value /= 10;
2025                 if (value == 0) break;
2026             }
2027             return buffer;
2028         }
2029     }
2030 
2031     /**
2032      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2033      */
2034     function toHexString(uint256 value) internal pure returns (string memory) {
2035         unchecked {
2036             return toHexString(value, Math.log256(value) + 1);
2037         }
2038     }
2039 
2040     /**
2041      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2042      */
2043     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2044         bytes memory buffer = new bytes(2 * length + 2);
2045         buffer[0] = "0";
2046         buffer[1] = "x";
2047         for (uint256 i = 2 * length + 1; i > 1; --i) {
2048             buffer[i] = _SYMBOLS[value & 0xf];
2049             value >>= 4;
2050         }
2051         require(value == 0, "Strings: hex length insufficient");
2052         return string(buffer);
2053     }
2054 
2055     /**
2056      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2057      */
2058     function toHexString(address addr) internal pure returns (string memory) {
2059         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2060     }
2061 }
2062 
2063 // File: @openzeppelin/contracts/utils/Context.sol
2064 
2065 
2066 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2067 
2068 pragma solidity ^0.8.0;
2069 
2070 /**
2071  * @dev Provides information about the current execution context, including the
2072  * sender of the transaction and its data. While these are generally available
2073  * via msg.sender and msg.data, they should not be accessed in such a direct
2074  * manner, since when dealing with meta-transactions the account sending and
2075  * paying for execution may not be the actual sender (as far as an application
2076  * is concerned).
2077  *
2078  * This contract is only required for intermediate, library-like contracts.
2079  */
2080 abstract contract Context {
2081     function _msgSender() internal view virtual returns (address) {
2082         return msg.sender;
2083     }
2084 
2085     function _msgData() internal view virtual returns (bytes calldata) {
2086         return msg.data;
2087     }
2088 }
2089 
2090 // File: @openzeppelin/contracts/access/Ownable.sol
2091 
2092 
2093 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2094 
2095 pragma solidity ^0.8.0;
2096 
2097 
2098 /**
2099  * @dev Contract module which provides a basic access control mechanism, where
2100  * there is an account (an owner) that can be granted exclusive access to
2101  * specific functions.
2102  *
2103  * By default, the owner account will be the one that deploys the contract. This
2104  * can later be changed with {transferOwnership}.
2105  *
2106  * This module is used through inheritance. It will make available the modifier
2107  * `onlyOwner`, which can be applied to your functions to restrict their use to
2108  * the owner.
2109  */
2110 abstract contract Ownable is Context {
2111     address private _owner;
2112 
2113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2114 
2115     /**
2116      * @dev Initializes the contract setting the deployer as the initial owner.
2117      */
2118     constructor() {
2119         _transferOwnership(_msgSender());
2120     }
2121 
2122     /**
2123      * @dev Throws if called by any account other than the owner.
2124      */
2125     modifier onlyOwner() {
2126         _checkOwner();
2127         _;
2128     }
2129 
2130     /**
2131      * @dev Returns the address of the current owner.
2132      */
2133     function owner() public view virtual returns (address) {
2134         return _owner;
2135     }
2136 
2137     /**
2138      * @dev Throws if the sender is not the owner.
2139      */
2140     function _checkOwner() internal view virtual {
2141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2142     }
2143 
2144     /**
2145      * @dev Leaves the contract without owner. It will not be possible to call
2146      * `onlyOwner` functions anymore. Can only be called by the current owner.
2147      *
2148      * NOTE: Renouncing ownership will leave the contract without an owner,
2149      * thereby removing any functionality that is only available to the owner.
2150      */
2151     function renounceOwnership() public virtual onlyOwner {
2152         _transferOwnership(address(0));
2153     }
2154 
2155     /**
2156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2157      * Can only be called by the current owner.
2158      */
2159     function transferOwnership(address newOwner) public virtual onlyOwner {
2160         require(newOwner != address(0), "Ownable: new owner is the zero address");
2161         _transferOwnership(newOwner);
2162     }
2163 
2164     /**
2165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2166      * Internal function without access restriction.
2167      */
2168     function _transferOwnership(address newOwner) internal virtual {
2169         address oldOwner = _owner;
2170         _owner = newOwner;
2171         emit OwnershipTransferred(oldOwner, newOwner);
2172     }
2173 }
2174 
2175 // File: RATSCII.sol
2176 
2177 
2178 pragma solidity ^0.8.4;
2179 
2180 
2181 
2182 
2183 
2184 
2185 contract RATSCII is ERC721AQueryable, Ownable {
2186   using Strings for uint256;
2187 
2188   uint256 public constant TOTAL_MAX_SUPPLY = 8880;
2189   uint256 public totalFreeMints = 2222;
2190   uint256 public maxFreeMintPerWallet = 1;
2191   uint256 public maxPublicMintPerWallet = 8;
2192   uint256 public publicTokenPrice = .002 ether;
2193   string _contractURI;
2194 
2195   bool public saleStarted = false;
2196   uint256 public freeMintCount;
2197 
2198   mapping(address => uint256) public freeMintClaimed;
2199   
2200 
2201   string private _baseTokenURI;
2202 
2203   constructor() ERC721A("RATSCII", "RATSCIICII") {}
2204 
2205   modifier callerIsUser() {
2206     require(tx.origin == msg.sender, 'RATS: The caller is another contract');
2207     _;
2208   }
2209 
2210   modifier underMaxSupply(uint256 _quantity) {
2211     require(
2212       _totalMinted() + _quantity <= TOTAL_MAX_SUPPLY,
2213       "RATSCII: Purchase exceeds max supply"
2214     );
2215     _;
2216   }
2217 
2218   function mint(uint256 _quantity) external payable callerIsUser underMaxSupply(_quantity) {
2219     require(balanceOf(msg.sender) < maxPublicMintPerWallet, "RATSCII: Mint limit exceeded");
2220     require(saleStarted, "RATSCII: Sale has not begun");
2221     if (_totalMinted() < (TOTAL_MAX_SUPPLY)) {
2222       if (freeMintCount >= totalFreeMints) {
2223         require(msg.value >= _quantity * publicTokenPrice, "RATSCII: Send more ETH!");
2224         _mint(msg.sender, _quantity);
2225       } else if (freeMintClaimed[msg.sender] < maxFreeMintPerWallet) {
2226         uint256 _mintableFreeQuantity = maxFreeMintPerWallet - freeMintClaimed[msg.sender];
2227         if (_quantity <= _mintableFreeQuantity) {
2228           freeMintCount += _quantity;
2229           freeMintClaimed[msg.sender] += _quantity;
2230         } else {
2231           freeMintCount += _mintableFreeQuantity;
2232           freeMintClaimed[msg.sender] += _mintableFreeQuantity;
2233           require(
2234             msg.value >= (_quantity - _mintableFreeQuantity) * publicTokenPrice,
2235             "RATSCII: Insufficient ETH"
2236           );
2237         }
2238         _mint(msg.sender, _quantity);
2239       } else {
2240         require(msg.value >= (_quantity * publicTokenPrice), "RATSCII: Insufficient ETH");
2241         _mint(msg.sender, _quantity);
2242       }
2243     }
2244   }
2245 
2246   function _baseURI() internal view virtual override returns (string memory) {
2247     return _baseTokenURI;
2248   }
2249 
2250   function tokenURI(uint256 tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2251     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2252 
2253     string memory baseURI = _baseURI();
2254     return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2255   }
2256 
2257   function numberMinted(address owner) public view returns (uint256) {
2258     return _numberMinted(owner);
2259   }
2260 
2261   function _startTokenId() internal view virtual override returns (uint256) {
2262     return 1;
2263   }
2264 
2265   function ownerMint(uint256 _numberToMint) external onlyOwner underMaxSupply(_numberToMint) {
2266     _mint(msg.sender, _numberToMint);
2267   }
2268 
2269   function ownerMintToAddress(address _recipient, uint256 _numberToMint)
2270     external
2271     onlyOwner
2272     underMaxSupply(_numberToMint)
2273   {
2274     _mint(_recipient, _numberToMint);
2275   }
2276 
2277   function setFreeMintCount(uint256 _count) external onlyOwner {
2278     totalFreeMints = _count;
2279   }
2280 
2281   function setMaxFreeMintPerWallet(uint256 _count) external onlyOwner {
2282     maxFreeMintPerWallet = _count;
2283   }
2284 
2285   function setMaxPublicMintPerWallet(uint256 _count) external onlyOwner {
2286     maxPublicMintPerWallet = _count;
2287   }
2288 
2289   function setBaseURI(string calldata baseURI) external onlyOwner {
2290     _baseTokenURI = baseURI;
2291   }
2292 
2293   // Storefront metadata
2294   // https://docs.opensea.io/docs/contract-level-metadata
2295   function contractURI() public view returns (string memory) {
2296     return _contractURI;
2297   }
2298 
2299   function setContractURI(string memory _URI) external onlyOwner {
2300     _contractURI = _URI;
2301   }
2302 
2303   function withdrawFunds() external onlyOwner {
2304     (bool success, ) = msg.sender.call{ value: address(this).balance }("");
2305     require(success, "RATSCII: Transfer failed.");
2306   }
2307 
2308   function withdrawFundsToAddress(address _address, uint256 amount) external onlyOwner {
2309     (bool success, ) = _address.call{ value: amount }("");
2310     require(success, "RATSCII: Transfer failed.");
2311   }
2312 
2313   function flipSaleStarted() external onlyOwner {
2314     saleStarted = !saleStarted;
2315   }
2316 }