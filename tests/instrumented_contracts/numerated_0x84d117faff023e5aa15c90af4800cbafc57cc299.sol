1 // SPDX-License-Identifier: MIT
2 // ERC721A Contracts v4.2.2
3 // Creator: Chiru Labs
4 
5 pragma solidity ^0.8.4;
6 
7 /**
8  * @dev Interface of ERC721A.
9  */
10 interface IERC721A {
11     /**
12      * The caller must own the token or be an approved operator.
13      */
14     error ApprovalCallerNotOwnerNorApproved();
15 
16     /**
17      * The token does not exist.
18      */
19     error ApprovalQueryForNonexistentToken();
20 
21     /**
22      * The caller cannot approve to their own address.
23      */
24     error ApproveToCaller();
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
178     ) external;
179 
180     /**
181      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) external;
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
209     ) external;
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
225     function approve(address to, uint256 tokenId) external;
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
292 // ERC721A Contracts v4.2.2
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
326     // Reference type for token approval.
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
714     function approve(address to, uint256 tokenId) public virtual override {
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
751         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
752 
753         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
754         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
755     }
756 
757     /**
758      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
759      *
760      * See {setApprovalForAll}.
761      */
762     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
763         return _operatorApprovals[owner][operator];
764     }
765 
766     /**
767      * @dev Returns whether `tokenId` exists.
768      *
769      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
770      *
771      * Tokens start existing when they are minted. See {_mint}.
772      */
773     function _exists(uint256 tokenId) internal view virtual returns (bool) {
774         return
775             _startTokenId() <= tokenId &&
776             tokenId < _currentIndex && // If within bounds,
777             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
778     }
779 
780     /**
781      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
782      */
783     function _isSenderApprovedOrOwner(
784         address approvedAddress,
785         address owner,
786         address msgSender
787     ) private pure returns (bool result) {
788         assembly {
789             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
790             owner := and(owner, _BITMASK_ADDRESS)
791             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
792             msgSender := and(msgSender, _BITMASK_ADDRESS)
793             // `msgSender == owner || msgSender == approvedAddress`.
794             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
795         }
796     }
797 
798     /**
799      * @dev Returns the storage slot and value for the approved address of `tokenId`.
800      */
801     function _getApprovedSlotAndAddress(uint256 tokenId)
802         private
803         view
804         returns (uint256 approvedAddressSlot, address approvedAddress)
805     {
806         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
807         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
808         assembly {
809             approvedAddressSlot := tokenApproval.slot
810             approvedAddress := sload(approvedAddressSlot)
811         }
812     }
813 
814     // =============================================================
815     //                      TRANSFER OPERATIONS
816     // =============================================================
817 
818     /**
819      * @dev Transfers `tokenId` from `from` to `to`.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must be owned by `from`.
826      * - If the caller is not `from`, it must be approved to move this token
827      * by either {approve} or {setApprovalForAll}.
828      *
829      * Emits a {Transfer} event.
830      */
831     function transferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) public virtual override {
836         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
837 
838         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
839 
840         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
841 
842         // The nested ifs save around 20+ gas over a compound boolean condition.
843         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
844             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
845 
846         if (to == address(0)) revert TransferToZeroAddress();
847 
848         _beforeTokenTransfers(from, to, tokenId, 1);
849 
850         // Clear approvals from the previous owner.
851         assembly {
852             if approvedAddress {
853                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
854                 sstore(approvedAddressSlot, 0)
855             }
856         }
857 
858         // Underflow of the sender's balance is impossible because we check for
859         // ownership above and the recipient's balance can't realistically overflow.
860         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
861         unchecked {
862             // We can directly increment and decrement the balances.
863             --_packedAddressData[from]; // Updates: `balance -= 1`.
864             ++_packedAddressData[to]; // Updates: `balance += 1`.
865 
866             // Updates:
867             // - `address` to the next owner.
868             // - `startTimestamp` to the timestamp of transfering.
869             // - `burned` to `false`.
870             // - `nextInitialized` to `true`.
871             _packedOwnerships[tokenId] = _packOwnershipData(
872                 to,
873                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
874             );
875 
876             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
877             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
878                 uint256 nextTokenId = tokenId + 1;
879                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
880                 if (_packedOwnerships[nextTokenId] == 0) {
881                     // If the next slot is within bounds.
882                     if (nextTokenId != _currentIndex) {
883                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
884                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
885                     }
886                 }
887             }
888         }
889 
890         emit Transfer(from, to, tokenId);
891         _afterTokenTransfers(from, to, tokenId, 1);
892     }
893 
894     /**
895      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
896      */
897     function safeTransferFrom(
898         address from,
899         address to,
900         uint256 tokenId
901     ) public virtual override {
902         safeTransferFrom(from, to, tokenId, '');
903     }
904 
905     /**
906      * @dev Safely transfers `tokenId` token from `from` to `to`.
907      *
908      * Requirements:
909      *
910      * - `from` cannot be the zero address.
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must exist and be owned by `from`.
913      * - If the caller is not `from`, it must be approved to move this token
914      * by either {approve} or {setApprovalForAll}.
915      * - If `to` refers to a smart contract, it must implement
916      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes memory _data
925     ) public virtual override {
926         transferFrom(from, to, tokenId);
927         if (to.code.length != 0)
928             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
929                 revert TransferToNonERC721ReceiverImplementer();
930             }
931     }
932 
933     /**
934      * @dev Hook that is called before a set of serially-ordered token IDs
935      * are about to be transferred. This includes minting.
936      * And also called before burning one token.
937      *
938      * `startTokenId` - the first token ID to be transferred.
939      * `quantity` - the amount to be transferred.
940      *
941      * Calling conditions:
942      *
943      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
944      * transferred to `to`.
945      * - When `from` is zero, `tokenId` will be minted for `to`.
946      * - When `to` is zero, `tokenId` will be burned by `from`.
947      * - `from` and `to` are never both zero.
948      */
949     function _beforeTokenTransfers(
950         address from,
951         address to,
952         uint256 startTokenId,
953         uint256 quantity
954     ) internal virtual {}
955 
956     /**
957      * @dev Hook that is called after a set of serially-ordered token IDs
958      * have been transferred. This includes minting.
959      * And also called after one token has been burned.
960      *
961      * `startTokenId` - the first token ID to be transferred.
962      * `quantity` - the amount to be transferred.
963      *
964      * Calling conditions:
965      *
966      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
967      * transferred to `to`.
968      * - When `from` is zero, `tokenId` has been minted for `to`.
969      * - When `to` is zero, `tokenId` has been burned by `from`.
970      * - `from` and `to` are never both zero.
971      */
972     function _afterTokenTransfers(
973         address from,
974         address to,
975         uint256 startTokenId,
976         uint256 quantity
977     ) internal virtual {}
978 
979     /**
980      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
981      *
982      * `from` - Previous owner of the given token ID.
983      * `to` - Target address that will receive the token.
984      * `tokenId` - Token ID to be transferred.
985      * `_data` - Optional data to send along with the call.
986      *
987      * Returns whether the call correctly returned the expected magic value.
988      */
989     function _checkContractOnERC721Received(
990         address from,
991         address to,
992         uint256 tokenId,
993         bytes memory _data
994     ) private returns (bool) {
995         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
996             bytes4 retval
997         ) {
998             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
999         } catch (bytes memory reason) {
1000             if (reason.length == 0) {
1001                 revert TransferToNonERC721ReceiverImplementer();
1002             } else {
1003                 assembly {
1004                     revert(add(32, reason), mload(reason))
1005                 }
1006             }
1007         }
1008     }
1009 
1010     // =============================================================
1011     //                        MINT OPERATIONS
1012     // =============================================================
1013 
1014     /**
1015      * @dev Mints `quantity` tokens and transfers them to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `quantity` must be greater than 0.
1021      *
1022      * Emits a {Transfer} event for each mint.
1023      */
1024     function _mint(address to, uint256 quantity) internal virtual {
1025         uint256 startTokenId = _currentIndex;
1026         if (quantity == 0) revert MintZeroQuantity();
1027 
1028         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1029 
1030         // Overflows are incredibly unrealistic.
1031         // `balance` and `numberMinted` have a maximum limit of 2**64.
1032         // `tokenId` has a maximum limit of 2**256.
1033         unchecked {
1034             // Updates:
1035             // - `balance += quantity`.
1036             // - `numberMinted += quantity`.
1037             //
1038             // We can directly add to the `balance` and `numberMinted`.
1039             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1040 
1041             // Updates:
1042             // - `address` to the owner.
1043             // - `startTimestamp` to the timestamp of minting.
1044             // - `burned` to `false`.
1045             // - `nextInitialized` to `quantity == 1`.
1046             _packedOwnerships[startTokenId] = _packOwnershipData(
1047                 to,
1048                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1049             );
1050 
1051             uint256 toMasked;
1052             uint256 end = startTokenId + quantity;
1053 
1054             // Use assembly to loop and emit the `Transfer` event for gas savings.
1055             assembly {
1056                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1057                 toMasked := and(to, _BITMASK_ADDRESS)
1058                 // Emit the `Transfer` event.
1059                 log4(
1060                     0, // Start of data (0, since no data).
1061                     0, // End of data (0, since no data).
1062                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1063                     0, // `address(0)`.
1064                     toMasked, // `to`.
1065                     startTokenId // `tokenId`.
1066                 )
1067 
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
1340             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1341             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1342             // We will need 1 32-byte word to store the length,
1343             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1344             str := add(mload(0x40), 0x80)
1345             // Update the free memory pointer to allocate.
1346             mstore(0x40, str)
1347 
1348             // Cache the end of the memory to calculate the length later.
1349             let end := str
1350 
1351             // We write the string from rightmost digit to leftmost digit.
1352             // The following is essentially a do-while loop that also handles the zero case.
1353             // prettier-ignore
1354             for { let temp := value } 1 {} {
1355                 str := sub(str, 1)
1356                 // Write the character to the pointer.
1357                 // The ASCII index of the '0' character is 48.
1358                 mstore8(str, add(48, mod(temp, 10)))
1359                 // Keep dividing `temp` until zero.
1360                 temp := div(temp, 10)
1361                 // prettier-ignore
1362                 if iszero(temp) { break }
1363             }
1364 
1365             let length := sub(end, str)
1366             // Move the pointer 32 bytes leftwards to make room for the length.
1367             str := sub(str, 0x20)
1368             // Store the length.
1369             mstore(str, length)
1370         }
1371     }
1372 }
1373 
1374 // File: @openzeppelin/contracts/utils/Address.sol
1375 
1376 
1377 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1378 
1379 pragma solidity ^0.8.1;
1380 
1381 /**
1382  * @dev Collection of functions related to the address type
1383  */
1384 library Address {
1385     /**
1386      * @dev Returns true if `account` is a contract.
1387      *
1388      * [IMPORTANT]
1389      * ====
1390      * It is unsafe to assume that an address for which this function returns
1391      * false is an externally-owned account (EOA) and not a contract.
1392      *
1393      * Among others, `isContract` will return false for the following
1394      * types of addresses:
1395      *
1396      *  - an externally-owned account
1397      *  - a contract in construction
1398      *  - an address where a contract will be created
1399      *  - an address where a contract lived, but was destroyed
1400      * ====
1401      *
1402      * [IMPORTANT]
1403      * ====
1404      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1405      *
1406      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1407      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1408      * constructor.
1409      * ====
1410      */
1411     function isContract(address account) internal view returns (bool) {
1412         // This method relies on extcodesize/address.code.length, which returns 0
1413         // for contracts in construction, since the code is only stored at the end
1414         // of the constructor execution.
1415 
1416         return account.code.length > 0;
1417     }
1418 
1419     /**
1420      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1421      * `recipient`, forwarding all available gas and reverting on errors.
1422      *
1423      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1424      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1425      * imposed by `transfer`, making them unable to receive funds via
1426      * `transfer`. {sendValue} removes this limitation.
1427      *
1428      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1429      *
1430      * IMPORTANT: because control is transferred to `recipient`, care must be
1431      * taken to not create reentrancy vulnerabilities. Consider using
1432      * {ReentrancyGuard} or the
1433      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1434      */
1435     function sendValue(address payable recipient, uint256 amount) internal {
1436         require(address(this).balance >= amount, "Address: insufficient balance");
1437 
1438         (bool success, ) = recipient.call{value: amount}("");
1439         require(success, "Address: unable to send value, recipient may have reverted");
1440     }
1441 
1442     /**
1443      * @dev Performs a Solidity function call using a low level `call`. A
1444      * plain `call` is an unsafe replacement for a function call: use this
1445      * function instead.
1446      *
1447      * If `target` reverts with a revert reason, it is bubbled up by this
1448      * function (like regular Solidity function calls).
1449      *
1450      * Returns the raw returned data. To convert to the expected return value,
1451      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1452      *
1453      * Requirements:
1454      *
1455      * - `target` must be a contract.
1456      * - calling `target` with `data` must not revert.
1457      *
1458      * _Available since v3.1._
1459      */
1460     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1461         return functionCall(target, data, "Address: low-level call failed");
1462     }
1463 
1464     /**
1465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1466      * `errorMessage` as a fallback revert reason when `target` reverts.
1467      *
1468      * _Available since v3.1._
1469      */
1470     function functionCall(
1471         address target,
1472         bytes memory data,
1473         string memory errorMessage
1474     ) internal returns (bytes memory) {
1475         return functionCallWithValue(target, data, 0, errorMessage);
1476     }
1477 
1478     /**
1479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1480      * but also transferring `value` wei to `target`.
1481      *
1482      * Requirements:
1483      *
1484      * - the calling contract must have an ETH balance of at least `value`.
1485      * - the called Solidity function must be `payable`.
1486      *
1487      * _Available since v3.1._
1488      */
1489     function functionCallWithValue(
1490         address target,
1491         bytes memory data,
1492         uint256 value
1493     ) internal returns (bytes memory) {
1494         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1495     }
1496 
1497     /**
1498      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1499      * with `errorMessage` as a fallback revert reason when `target` reverts.
1500      *
1501      * _Available since v3.1._
1502      */
1503     function functionCallWithValue(
1504         address target,
1505         bytes memory data,
1506         uint256 value,
1507         string memory errorMessage
1508     ) internal returns (bytes memory) {
1509         require(address(this).balance >= value, "Address: insufficient balance for call");
1510         require(isContract(target), "Address: call to non-contract");
1511 
1512         (bool success, bytes memory returndata) = target.call{value: value}(data);
1513         return verifyCallResult(success, returndata, errorMessage);
1514     }
1515 
1516     /**
1517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1518      * but performing a static call.
1519      *
1520      * _Available since v3.3._
1521      */
1522     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1523         return functionStaticCall(target, data, "Address: low-level static call failed");
1524     }
1525 
1526     /**
1527      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1528      * but performing a static call.
1529      *
1530      * _Available since v3.3._
1531      */
1532     function functionStaticCall(
1533         address target,
1534         bytes memory data,
1535         string memory errorMessage
1536     ) internal view returns (bytes memory) {
1537         require(isContract(target), "Address: static call to non-contract");
1538 
1539         (bool success, bytes memory returndata) = target.staticcall(data);
1540         return verifyCallResult(success, returndata, errorMessage);
1541     }
1542 
1543     /**
1544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1545      * but performing a delegate call.
1546      *
1547      * _Available since v3.4._
1548      */
1549     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1550         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1551     }
1552 
1553     /**
1554      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1555      * but performing a delegate call.
1556      *
1557      * _Available since v3.4._
1558      */
1559     function functionDelegateCall(
1560         address target,
1561         bytes memory data,
1562         string memory errorMessage
1563     ) internal returns (bytes memory) {
1564         require(isContract(target), "Address: delegate call to non-contract");
1565 
1566         (bool success, bytes memory returndata) = target.delegatecall(data);
1567         return verifyCallResult(success, returndata, errorMessage);
1568     }
1569 
1570     /**
1571      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1572      * revert reason using the provided one.
1573      *
1574      * _Available since v4.3._
1575      */
1576     function verifyCallResult(
1577         bool success,
1578         bytes memory returndata,
1579         string memory errorMessage
1580     ) internal pure returns (bytes memory) {
1581         if (success) {
1582             return returndata;
1583         } else {
1584             // Look for revert reason and bubble it up if present
1585             if (returndata.length > 0) {
1586                 // The easiest way to bubble the revert reason is using memory via assembly
1587                 /// @solidity memory-safe-assembly
1588                 assembly {
1589                     let returndata_size := mload(returndata)
1590                     revert(add(32, returndata), returndata_size)
1591                 }
1592             } else {
1593                 revert(errorMessage);
1594             }
1595         }
1596     }
1597 }
1598 
1599 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1600 
1601 
1602 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1603 
1604 pragma solidity ^0.8.0;
1605 
1606 /**
1607  * @title ERC721 token receiver interface
1608  * @dev Interface for any contract that wants to support safeTransfers
1609  * from ERC721 asset contracts.
1610  */
1611 interface IERC721Receiver {
1612     /**
1613      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1614      * by `operator` from `from`, this function is called.
1615      *
1616      * It must return its Solidity selector to confirm the token transfer.
1617      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1618      *
1619      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1620      */
1621     function onERC721Received(
1622         address operator,
1623         address from,
1624         uint256 tokenId,
1625         bytes calldata data
1626     ) external returns (bytes4);
1627 }
1628 
1629 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1630 
1631 
1632 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1633 
1634 pragma solidity ^0.8.0;
1635 
1636 /**
1637  * @dev Interface of the ERC165 standard, as defined in the
1638  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1639  *
1640  * Implementers can declare support of contract interfaces, which can then be
1641  * queried by others ({ERC165Checker}).
1642  *
1643  * For an implementation, see {ERC165}.
1644  */
1645 interface IERC165 {
1646     /**
1647      * @dev Returns true if this contract implements the interface defined by
1648      * `interfaceId`. See the corresponding
1649      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1650      * to learn more about how these ids are created.
1651      *
1652      * This function call must use less than 30 000 gas.
1653      */
1654     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1655 }
1656 
1657 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1658 
1659 
1660 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1661 
1662 pragma solidity ^0.8.0;
1663 
1664 
1665 /**
1666  * @dev Interface for the NFT Royalty Standard.
1667  *
1668  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1669  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1670  *
1671  * _Available since v4.5._
1672  */
1673 interface IERC2981 is IERC165 {
1674     /**
1675      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1676      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1677      */
1678     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1679         external
1680         view
1681         returns (address receiver, uint256 royaltyAmount);
1682 }
1683 
1684 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1685 
1686 
1687 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1688 
1689 pragma solidity ^0.8.0;
1690 
1691 
1692 /**
1693  * @dev Implementation of the {IERC165} interface.
1694  *
1695  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1696  * for the additional interface id that will be supported. For example:
1697  *
1698  * ```solidity
1699  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1700  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1701  * }
1702  * ```
1703  *
1704  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1705  */
1706 abstract contract ERC165 is IERC165 {
1707     /**
1708      * @dev See {IERC165-supportsInterface}.
1709      */
1710     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1711         return interfaceId == type(IERC165).interfaceId;
1712     }
1713 }
1714 
1715 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1716 
1717 
1718 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1719 
1720 pragma solidity ^0.8.0;
1721 
1722 
1723 
1724 /**
1725  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1726  *
1727  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1728  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1729  *
1730  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1731  * fee is specified in basis points by default.
1732  *
1733  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1734  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1735  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1736  *
1737  * _Available since v4.5._
1738  */
1739 abstract contract ERC2981 is IERC2981, ERC165 {
1740     struct RoyaltyInfo {
1741         address receiver;
1742         uint96 royaltyFraction;
1743     }
1744 
1745     RoyaltyInfo private _defaultRoyaltyInfo;
1746     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1747 
1748     /**
1749      * @dev See {IERC165-supportsInterface}.
1750      */
1751     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1752         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1753     }
1754 
1755     /**
1756      * @inheritdoc IERC2981
1757      */
1758     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1759         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1760 
1761         if (royalty.receiver == address(0)) {
1762             royalty = _defaultRoyaltyInfo;
1763         }
1764 
1765         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1766 
1767         return (royalty.receiver, royaltyAmount);
1768     }
1769 
1770     /**
1771      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1772      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1773      * override.
1774      */
1775     function _feeDenominator() internal pure virtual returns (uint96) {
1776         return 10000;
1777     }
1778 
1779     /**
1780      * @dev Sets the royalty information that all ids in this contract will default to.
1781      *
1782      * Requirements:
1783      *
1784      * - `receiver` cannot be the zero address.
1785      * - `feeNumerator` cannot be greater than the fee denominator.
1786      */
1787     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1788         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1789         require(receiver != address(0), "ERC2981: invalid receiver");
1790 
1791         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1792     }
1793 
1794     /**
1795      * @dev Removes default royalty information.
1796      */
1797     function _deleteDefaultRoyalty() internal virtual {
1798         delete _defaultRoyaltyInfo;
1799     }
1800 
1801     /**
1802      * @dev Sets the royalty information for a specific token id, overriding the global default.
1803      *
1804      * Requirements:
1805      *
1806      * - `receiver` cannot be the zero address.
1807      * - `feeNumerator` cannot be greater than the fee denominator.
1808      */
1809     function _setTokenRoyalty(
1810         uint256 tokenId,
1811         address receiver,
1812         uint96 feeNumerator
1813     ) internal virtual {
1814         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1815         require(receiver != address(0), "ERC2981: Invalid parameters");
1816 
1817         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1818     }
1819 
1820     /**
1821      * @dev Resets royalty information for the token id back to the global default.
1822      */
1823     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1824         delete _tokenRoyaltyInfo[tokenId];
1825     }
1826 }
1827 
1828 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1829 
1830 
1831 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1832 
1833 pragma solidity ^0.8.0;
1834 
1835 
1836 /**
1837  * @dev Required interface of an ERC721 compliant contract.
1838  */
1839 interface IERC721 is IERC165 {
1840     /**
1841      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1842      */
1843     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1844 
1845     /**
1846      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1847      */
1848     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1849 
1850     /**
1851      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1852      */
1853     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1854 
1855     /**
1856      * @dev Returns the number of tokens in ``owner``'s account.
1857      */
1858     function balanceOf(address owner) external view returns (uint256 balance);
1859 
1860     /**
1861      * @dev Returns the owner of the `tokenId` token.
1862      *
1863      * Requirements:
1864      *
1865      * - `tokenId` must exist.
1866      */
1867     function ownerOf(uint256 tokenId) external view returns (address owner);
1868 
1869     /**
1870      * @dev Safely transfers `tokenId` token from `from` to `to`.
1871      *
1872      * Requirements:
1873      *
1874      * - `from` cannot be the zero address.
1875      * - `to` cannot be the zero address.
1876      * - `tokenId` token must exist and be owned by `from`.
1877      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1878      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1879      *
1880      * Emits a {Transfer} event.
1881      */
1882     function safeTransferFrom(
1883         address from,
1884         address to,
1885         uint256 tokenId,
1886         bytes calldata data
1887     ) external;
1888 
1889     /**
1890      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1891      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1892      *
1893      * Requirements:
1894      *
1895      * - `from` cannot be the zero address.
1896      * - `to` cannot be the zero address.
1897      * - `tokenId` token must exist and be owned by `from`.
1898      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1900      *
1901      * Emits a {Transfer} event.
1902      */
1903     function safeTransferFrom(
1904         address from,
1905         address to,
1906         uint256 tokenId
1907     ) external;
1908 
1909     /**
1910      * @dev Transfers `tokenId` token from `from` to `to`.
1911      *
1912      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1913      *
1914      * Requirements:
1915      *
1916      * - `from` cannot be the zero address.
1917      * - `to` cannot be the zero address.
1918      * - `tokenId` token must be owned by `from`.
1919      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1920      *
1921      * Emits a {Transfer} event.
1922      */
1923     function transferFrom(
1924         address from,
1925         address to,
1926         uint256 tokenId
1927     ) external;
1928 
1929     /**
1930      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1931      * The approval is cleared when the token is transferred.
1932      *
1933      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1934      *
1935      * Requirements:
1936      *
1937      * - The caller must own the token or be an approved operator.
1938      * - `tokenId` must exist.
1939      *
1940      * Emits an {Approval} event.
1941      */
1942     function approve(address to, uint256 tokenId) external;
1943 
1944     /**
1945      * @dev Approve or remove `operator` as an operator for the caller.
1946      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1947      *
1948      * Requirements:
1949      *
1950      * - The `operator` cannot be the caller.
1951      *
1952      * Emits an {ApprovalForAll} event.
1953      */
1954     function setApprovalForAll(address operator, bool _approved) external;
1955 
1956     /**
1957      * @dev Returns the account approved for `tokenId` token.
1958      *
1959      * Requirements:
1960      *
1961      * - `tokenId` must exist.
1962      */
1963     function getApproved(uint256 tokenId) external view returns (address operator);
1964 
1965     /**
1966      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1967      *
1968      * See {setApprovalForAll}
1969      */
1970     function isApprovedForAll(address owner, address operator) external view returns (bool);
1971 }
1972 
1973 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1974 
1975 
1976 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1977 
1978 pragma solidity ^0.8.0;
1979 
1980 
1981 /**
1982  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1983  * @dev See https://eips.ethereum.org/EIPS/eip-721
1984  */
1985 interface IERC721Metadata is IERC721 {
1986     /**
1987      * @dev Returns the token collection name.
1988      */
1989     function name() external view returns (string memory);
1990 
1991     /**
1992      * @dev Returns the token collection symbol.
1993      */
1994     function symbol() external view returns (string memory);
1995 
1996     /**
1997      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1998      */
1999     function tokenURI(uint256 tokenId) external view returns (string memory);
2000 }
2001 
2002 // File: @openzeppelin/contracts/utils/Strings.sol
2003 
2004 
2005 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
2006 
2007 pragma solidity ^0.8.0;
2008 
2009 /**
2010  * @dev String operations.
2011  */
2012 library Strings {
2013     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2014     uint8 private constant _ADDRESS_LENGTH = 20;
2015 
2016     /**
2017      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2018      */
2019     function toString(uint256 value) internal pure returns (string memory) {
2020         // Inspired by OraclizeAPI's implementation - MIT licence
2021         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2022 
2023         if (value == 0) {
2024             return "0";
2025         }
2026         uint256 temp = value;
2027         uint256 digits;
2028         while (temp != 0) {
2029             digits++;
2030             temp /= 10;
2031         }
2032         bytes memory buffer = new bytes(digits);
2033         while (value != 0) {
2034             digits -= 1;
2035             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2036             value /= 10;
2037         }
2038         return string(buffer);
2039     }
2040 
2041     /**
2042      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2043      */
2044     function toHexString(uint256 value) internal pure returns (string memory) {
2045         if (value == 0) {
2046             return "0x00";
2047         }
2048         uint256 temp = value;
2049         uint256 length = 0;
2050         while (temp != 0) {
2051             length++;
2052             temp >>= 8;
2053         }
2054         return toHexString(value, length);
2055     }
2056 
2057     /**
2058      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2059      */
2060     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2061         bytes memory buffer = new bytes(2 * length + 2);
2062         buffer[0] = "0";
2063         buffer[1] = "x";
2064         for (uint256 i = 2 * length + 1; i > 1; --i) {
2065             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2066             value >>= 4;
2067         }
2068         require(value == 0, "Strings: hex length insufficient");
2069         return string(buffer);
2070     }
2071 
2072     /**
2073      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2074      */
2075     function toHexString(address addr) internal pure returns (string memory) {
2076         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2077     }
2078 }
2079 
2080 // File: @openzeppelin/contracts/utils/Context.sol
2081 
2082 
2083 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2084 
2085 pragma solidity ^0.8.0;
2086 
2087 /**
2088  * @dev Provides information about the current execution context, including the
2089  * sender of the transaction and its data. While these are generally available
2090  * via msg.sender and msg.data, they should not be accessed in such a direct
2091  * manner, since when dealing with meta-transactions the account sending and
2092  * paying for execution may not be the actual sender (as far as an application
2093  * is concerned).
2094  *
2095  * This contract is only required for intermediate, library-like contracts.
2096  */
2097 abstract contract Context {
2098     function _msgSender() internal view virtual returns (address) {
2099         return msg.sender;
2100     }
2101 
2102     function _msgData() internal view virtual returns (bytes calldata) {
2103         return msg.data;
2104     }
2105 }
2106 
2107 // File: @openzeppelin/contracts/security/Pausable.sol
2108 
2109 
2110 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
2111 
2112 pragma solidity ^0.8.0;
2113 
2114 
2115 /**
2116  * @dev Contract module which allows children to implement an emergency stop
2117  * mechanism that can be triggered by an authorized account.
2118  *
2119  * This module is used through inheritance. It will make available the
2120  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2121  * the functions of your contract. Note that they will not be pausable by
2122  * simply including this module, only once the modifiers are put in place.
2123  */
2124 abstract contract Pausable is Context {
2125     /**
2126      * @dev Emitted when the pause is triggered by `account`.
2127      */
2128     event Paused(address account);
2129 
2130     /**
2131      * @dev Emitted when the pause is lifted by `account`.
2132      */
2133     event Unpaused(address account);
2134 
2135     bool private _paused;
2136 
2137     /**
2138      * @dev Initializes the contract in unpaused state.
2139      */
2140     constructor() {
2141         _paused = false;
2142     }
2143 
2144     /**
2145      * @dev Modifier to make a function callable only when the contract is not paused.
2146      *
2147      * Requirements:
2148      *
2149      * - The contract must not be paused.
2150      */
2151     modifier whenNotPaused() {
2152         _requireNotPaused();
2153         _;
2154     }
2155 
2156     /**
2157      * @dev Modifier to make a function callable only when the contract is paused.
2158      *
2159      * Requirements:
2160      *
2161      * - The contract must be paused.
2162      */
2163     modifier whenPaused() {
2164         _requirePaused();
2165         _;
2166     }
2167 
2168     /**
2169      * @dev Returns true if the contract is paused, and false otherwise.
2170      */
2171     function paused() public view virtual returns (bool) {
2172         return _paused;
2173     }
2174 
2175     /**
2176      * @dev Throws if the contract is paused.
2177      */
2178     function _requireNotPaused() internal view virtual {
2179         require(!paused(), "Pausable: paused");
2180     }
2181 
2182     /**
2183      * @dev Throws if the contract is not paused.
2184      */
2185     function _requirePaused() internal view virtual {
2186         require(paused(), "Pausable: not paused");
2187     }
2188 
2189     /**
2190      * @dev Triggers stopped state.
2191      *
2192      * Requirements:
2193      *
2194      * - The contract must not be paused.
2195      */
2196     function _pause() internal virtual whenNotPaused {
2197         _paused = true;
2198         emit Paused(_msgSender());
2199     }
2200 
2201     /**
2202      * @dev Returns to normal state.
2203      *
2204      * Requirements:
2205      *
2206      * - The contract must be paused.
2207      */
2208     function _unpause() internal virtual whenPaused {
2209         _paused = false;
2210         emit Unpaused(_msgSender());
2211     }
2212 }
2213 
2214 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
2215 
2216 
2217 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
2218 
2219 pragma solidity ^0.8.0;
2220 
2221 
2222 
2223 
2224 
2225 
2226 
2227 
2228 /**
2229  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2230  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2231  * {ERC721Enumerable}.
2232  */
2233 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2234     using Address for address;
2235     using Strings for uint256;
2236 
2237     // Token name
2238     string private _name;
2239 
2240     // Token symbol
2241     string private _symbol;
2242 
2243     // Mapping from token ID to owner address
2244     mapping(uint256 => address) private _owners;
2245 
2246     // Mapping owner address to token count
2247     mapping(address => uint256) private _balances;
2248 
2249     // Mapping from token ID to approved address
2250     mapping(uint256 => address) private _tokenApprovals;
2251 
2252     // Mapping from owner to operator approvals
2253     mapping(address => mapping(address => bool)) private _operatorApprovals;
2254 
2255     /**
2256      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2257      */
2258     constructor(string memory name_, string memory symbol_) {
2259         _name = name_;
2260         _symbol = symbol_;
2261     }
2262 
2263     /**
2264      * @dev See {IERC165-supportsInterface}.
2265      */
2266     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2267         return
2268             interfaceId == type(IERC721).interfaceId ||
2269             interfaceId == type(IERC721Metadata).interfaceId ||
2270             super.supportsInterface(interfaceId);
2271     }
2272 
2273     /**
2274      * @dev See {IERC721-balanceOf}.
2275      */
2276     function balanceOf(address owner) public view virtual override returns (uint256) {
2277         require(owner != address(0), "ERC721: address zero is not a valid owner");
2278         return _balances[owner];
2279     }
2280 
2281     /**
2282      * @dev See {IERC721-ownerOf}.
2283      */
2284     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2285         address owner = _owners[tokenId];
2286         require(owner != address(0), "ERC721: invalid token ID");
2287         return owner;
2288     }
2289 
2290     /**
2291      * @dev See {IERC721Metadata-name}.
2292      */
2293     function name() public view virtual override returns (string memory) {
2294         return _name;
2295     }
2296 
2297     /**
2298      * @dev See {IERC721Metadata-symbol}.
2299      */
2300     function symbol() public view virtual override returns (string memory) {
2301         return _symbol;
2302     }
2303 
2304     /**
2305      * @dev See {IERC721Metadata-tokenURI}.
2306      */
2307     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2308         _requireMinted(tokenId);
2309 
2310         string memory baseURI = _baseURI();
2311         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2312     }
2313 
2314     /**
2315      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2316      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2317      * by default, can be overridden in child contracts.
2318      */
2319     function _baseURI() internal view virtual returns (string memory) {
2320         return "";
2321     }
2322 
2323     /**
2324      * @dev See {IERC721-approve}.
2325      */
2326     function approve(address to, uint256 tokenId) public virtual override {
2327         address owner = ERC721.ownerOf(tokenId);
2328         require(to != owner, "ERC721: approval to current owner");
2329 
2330         require(
2331             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2332             "ERC721: approve caller is not token owner nor approved for all"
2333         );
2334 
2335         _approve(to, tokenId);
2336     }
2337 
2338     /**
2339      * @dev See {IERC721-getApproved}.
2340      */
2341     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2342         _requireMinted(tokenId);
2343 
2344         return _tokenApprovals[tokenId];
2345     }
2346 
2347     /**
2348      * @dev See {IERC721-setApprovalForAll}.
2349      */
2350     function setApprovalForAll(address operator, bool approved) public virtual override {
2351         _setApprovalForAll(_msgSender(), operator, approved);
2352     }
2353 
2354     /**
2355      * @dev See {IERC721-isApprovedForAll}.
2356      */
2357     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2358         return _operatorApprovals[owner][operator];
2359     }
2360 
2361     /**
2362      * @dev See {IERC721-transferFrom}.
2363      */
2364     function transferFrom(
2365         address from,
2366         address to,
2367         uint256 tokenId
2368     ) public virtual override {
2369         //solhint-disable-next-line max-line-length
2370         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2371 
2372         _transfer(from, to, tokenId);
2373     }
2374 
2375     /**
2376      * @dev See {IERC721-safeTransferFrom}.
2377      */
2378     function safeTransferFrom(
2379         address from,
2380         address to,
2381         uint256 tokenId
2382     ) public virtual override {
2383         safeTransferFrom(from, to, tokenId, "");
2384     }
2385 
2386     /**
2387      * @dev See {IERC721-safeTransferFrom}.
2388      */
2389     function safeTransferFrom(
2390         address from,
2391         address to,
2392         uint256 tokenId,
2393         bytes memory data
2394     ) public virtual override {
2395         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2396         _safeTransfer(from, to, tokenId, data);
2397     }
2398 
2399     /**
2400      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2401      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2402      *
2403      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2404      *
2405      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2406      * implement alternative mechanisms to perform token transfer, such as signature-based.
2407      *
2408      * Requirements:
2409      *
2410      * - `from` cannot be the zero address.
2411      * - `to` cannot be the zero address.
2412      * - `tokenId` token must exist and be owned by `from`.
2413      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2414      *
2415      * Emits a {Transfer} event.
2416      */
2417     function _safeTransfer(
2418         address from,
2419         address to,
2420         uint256 tokenId,
2421         bytes memory data
2422     ) internal virtual {
2423         _transfer(from, to, tokenId);
2424         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2425     }
2426 
2427     /**
2428      * @dev Returns whether `tokenId` exists.
2429      *
2430      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2431      *
2432      * Tokens start existing when they are minted (`_mint`),
2433      * and stop existing when they are burned (`_burn`).
2434      */
2435     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2436         return _owners[tokenId] != address(0);
2437     }
2438 
2439     /**
2440      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2441      *
2442      * Requirements:
2443      *
2444      * - `tokenId` must exist.
2445      */
2446     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2447         address owner = ERC721.ownerOf(tokenId);
2448         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2449     }
2450 
2451     /**
2452      * @dev Safely mints `tokenId` and transfers it to `to`.
2453      *
2454      * Requirements:
2455      *
2456      * - `tokenId` must not exist.
2457      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2458      *
2459      * Emits a {Transfer} event.
2460      */
2461     function _safeMint(address to, uint256 tokenId) internal virtual {
2462         _safeMint(to, tokenId, "");
2463     }
2464 
2465     /**
2466      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2467      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2468      */
2469     function _safeMint(
2470         address to,
2471         uint256 tokenId,
2472         bytes memory data
2473     ) internal virtual {
2474         _mint(to, tokenId);
2475         require(
2476             _checkOnERC721Received(address(0), to, tokenId, data),
2477             "ERC721: transfer to non ERC721Receiver implementer"
2478         );
2479     }
2480 
2481     /**
2482      * @dev Mints `tokenId` and transfers it to `to`.
2483      *
2484      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2485      *
2486      * Requirements:
2487      *
2488      * - `tokenId` must not exist.
2489      * - `to` cannot be the zero address.
2490      *
2491      * Emits a {Transfer} event.
2492      */
2493     function _mint(address to, uint256 tokenId) internal virtual {
2494         require(to != address(0), "ERC721: mint to the zero address");
2495         require(!_exists(tokenId), "ERC721: token already minted");
2496 
2497         _beforeTokenTransfer(address(0), to, tokenId);
2498 
2499         _balances[to] += 1;
2500         _owners[tokenId] = to;
2501 
2502         emit Transfer(address(0), to, tokenId);
2503 
2504         _afterTokenTransfer(address(0), to, tokenId);
2505     }
2506 
2507     /**
2508      * @dev Destroys `tokenId`.
2509      * The approval is cleared when the token is burned.
2510      *
2511      * Requirements:
2512      *
2513      * - `tokenId` must exist.
2514      *
2515      * Emits a {Transfer} event.
2516      */
2517     function _burn(uint256 tokenId) internal virtual {
2518         address owner = ERC721.ownerOf(tokenId);
2519 
2520         _beforeTokenTransfer(owner, address(0), tokenId);
2521 
2522         // Clear approvals
2523         _approve(address(0), tokenId);
2524 
2525         _balances[owner] -= 1;
2526         delete _owners[tokenId];
2527 
2528         emit Transfer(owner, address(0), tokenId);
2529 
2530         _afterTokenTransfer(owner, address(0), tokenId);
2531     }
2532 
2533     /**
2534      * @dev Transfers `tokenId` from `from` to `to`.
2535      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2536      *
2537      * Requirements:
2538      *
2539      * - `to` cannot be the zero address.
2540      * - `tokenId` token must be owned by `from`.
2541      *
2542      * Emits a {Transfer} event.
2543      */
2544     function _transfer(
2545         address from,
2546         address to,
2547         uint256 tokenId
2548     ) internal virtual {
2549         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2550         require(to != address(0), "ERC721: transfer to the zero address");
2551 
2552         _beforeTokenTransfer(from, to, tokenId);
2553 
2554         // Clear approvals from the previous owner
2555         _approve(address(0), tokenId);
2556 
2557         _balances[from] -= 1;
2558         _balances[to] += 1;
2559         _owners[tokenId] = to;
2560 
2561         emit Transfer(from, to, tokenId);
2562 
2563         _afterTokenTransfer(from, to, tokenId);
2564     }
2565 
2566     /**
2567      * @dev Approve `to` to operate on `tokenId`
2568      *
2569      * Emits an {Approval} event.
2570      */
2571     function _approve(address to, uint256 tokenId) internal virtual {
2572         _tokenApprovals[tokenId] = to;
2573         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2574     }
2575 
2576     /**
2577      * @dev Approve `operator` to operate on all of `owner` tokens
2578      *
2579      * Emits an {ApprovalForAll} event.
2580      */
2581     function _setApprovalForAll(
2582         address owner,
2583         address operator,
2584         bool approved
2585     ) internal virtual {
2586         require(owner != operator, "ERC721: approve to caller");
2587         _operatorApprovals[owner][operator] = approved;
2588         emit ApprovalForAll(owner, operator, approved);
2589     }
2590 
2591     /**
2592      * @dev Reverts if the `tokenId` has not been minted yet.
2593      */
2594     function _requireMinted(uint256 tokenId) internal view virtual {
2595         require(_exists(tokenId), "ERC721: invalid token ID");
2596     }
2597 
2598     /**
2599      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2600      * The call is not executed if the target address is not a contract.
2601      *
2602      * @param from address representing the previous owner of the given token ID
2603      * @param to target address that will receive the tokens
2604      * @param tokenId uint256 ID of the token to be transferred
2605      * @param data bytes optional data to send along with the call
2606      * @return bool whether the call correctly returned the expected magic value
2607      */
2608     function _checkOnERC721Received(
2609         address from,
2610         address to,
2611         uint256 tokenId,
2612         bytes memory data
2613     ) private returns (bool) {
2614         if (to.isContract()) {
2615             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2616                 return retval == IERC721Receiver.onERC721Received.selector;
2617             } catch (bytes memory reason) {
2618                 if (reason.length == 0) {
2619                     revert("ERC721: transfer to non ERC721Receiver implementer");
2620                 } else {
2621                     /// @solidity memory-safe-assembly
2622                     assembly {
2623                         revert(add(32, reason), mload(reason))
2624                     }
2625                 }
2626             }
2627         } else {
2628             return true;
2629         }
2630     }
2631 
2632     /**
2633      * @dev Hook that is called before any token transfer. This includes minting
2634      * and burning.
2635      *
2636      * Calling conditions:
2637      *
2638      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2639      * transferred to `to`.
2640      * - When `from` is zero, `tokenId` will be minted for `to`.
2641      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2642      * - `from` and `to` are never both zero.
2643      *
2644      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2645      */
2646     function _beforeTokenTransfer(
2647         address from,
2648         address to,
2649         uint256 tokenId
2650     ) internal virtual {}
2651 
2652     /**
2653      * @dev Hook that is called after any transfer of tokens. This includes
2654      * minting and burning.
2655      *
2656      * Calling conditions:
2657      *
2658      * - when `from` and `to` are both non-zero.
2659      * - `from` and `to` are never both zero.
2660      *
2661      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2662      */
2663     function _afterTokenTransfer(
2664         address from,
2665         address to,
2666         uint256 tokenId
2667     ) internal virtual {}
2668 }
2669 
2670 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
2671 
2672 
2673 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
2674 
2675 pragma solidity ^0.8.0;
2676 
2677 
2678 
2679 /**
2680  * @dev ERC721 token with pausable token transfers, minting and burning.
2681  *
2682  * Useful for scenarios such as preventing trades until the end of an evaluation
2683  * period, or having an emergency switch for freezing all token transfers in the
2684  * event of a large bug.
2685  */
2686 abstract contract ERC721Pausable is ERC721, Pausable {
2687     /**
2688      * @dev See {ERC721-_beforeTokenTransfer}.
2689      *
2690      * Requirements:
2691      *
2692      * - the contract must not be paused.
2693      */
2694     function _beforeTokenTransfer(
2695         address from,
2696         address to,
2697         uint256 tokenId
2698     ) internal virtual override {
2699         super._beforeTokenTransfer(from, to, tokenId);
2700 
2701         require(!paused(), "ERC721Pausable: token transfer while paused");
2702     }
2703 }
2704 
2705 // File: @openzeppelin/contracts/access/Ownable.sol
2706 
2707 
2708 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2709 
2710 pragma solidity ^0.8.0;
2711 
2712 
2713 /**
2714  * @dev Contract module which provides a basic access control mechanism, where
2715  * there is an account (an owner) that can be granted exclusive access to
2716  * specific functions.
2717  *
2718  * By default, the owner account will be the one that deploys the contract. This
2719  * can later be changed with {transferOwnership}.
2720  *
2721  * This module is used through inheritance. It will make available the modifier
2722  * `onlyOwner`, which can be applied to your functions to restrict their use to
2723  * the owner.
2724  */
2725 abstract contract Ownable is Context {
2726     address private _owner;
2727 
2728     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2729 
2730     /**
2731      * @dev Initializes the contract setting the deployer as the initial owner.
2732      */
2733     constructor() {
2734         _transferOwnership(_msgSender());
2735     }
2736 
2737     /**
2738      * @dev Throws if called by any account other than the owner.
2739      */
2740     modifier onlyOwner() {
2741         _checkOwner();
2742         _;
2743     }
2744 
2745     /**
2746      * @dev Returns the address of the current owner.
2747      */
2748     function owner() public view virtual returns (address) {
2749         return _owner;
2750     }
2751 
2752     /**
2753      * @dev Throws if the sender is not the owner.
2754      */
2755     function _checkOwner() internal view virtual {
2756         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2757     }
2758 
2759     /**
2760      * @dev Leaves the contract without owner. It will not be possible to call
2761      * `onlyOwner` functions anymore. Can only be called by the current owner.
2762      *
2763      * NOTE: Renouncing ownership will leave the contract without an owner,
2764      * thereby removing any functionality that is only available to the owner.
2765      */
2766     function renounceOwnership() public virtual onlyOwner {
2767         _transferOwnership(address(0));
2768     }
2769 
2770     /**
2771      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2772      * Can only be called by the current owner.
2773      */
2774     function transferOwnership(address newOwner) public virtual onlyOwner {
2775         require(newOwner != address(0), "Ownable: new owner is the zero address");
2776         _transferOwnership(newOwner);
2777     }
2778 
2779     /**
2780      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2781      * Internal function without access restriction.
2782      */
2783     function _transferOwnership(address newOwner) internal virtual {
2784         address oldOwner = _owner;
2785         _owner = newOwner;
2786         emit OwnershipTransferred(oldOwner, newOwner);
2787     }
2788 }
2789 
2790 pragma solidity ^0.8.9;
2791 
2792 contract CLAP is ERC721A, ERC2981 , Ownable, Pausable {
2793     using Strings for uint256;
2794 
2795     string public baseURI = "";
2796     string internal revealUri = "ipfs://QmVfmXKWfAne9fXgvtg6JdqHMMteufBmZdMFg9TomiLBR3";
2797     string internal lockedUri = "ipfs://QmWmSerJ3UB7R99KKm9ur5GgN4SE8Wwa2P1p7JSaorgCVt";
2798     string internal extension = ".json";
2799 
2800     bool internal isRevealed = false;
2801     bool public presale = true;
2802 
2803     uint256 public preCost = 0.05 ether;
2804     uint256 public publicCost = 0.1 ether;
2805     uint256 public publicMaxPerTx = 1;
2806 
2807     uint96 public royaltyFee = 1000;    //1000 = 10%
2808     uint96 public maxSupply = 1000;
2809     address public royaltyAddress = 0x9110bd3C7497E8eb12ac4923664d55Fb3BC549a8;
2810 
2811     mapping(address => uint256) public preMintLists;
2812     mapping(string => bool) internal lockLists;
2813 
2814     constructor(
2815         string memory _name,
2816         string memory _symbol
2817     ) ERC721A(_name, _symbol) {
2818         _setDefaultRoyalty(royaltyAddress, royaltyFee);
2819     }
2820 
2821     modifier callerIsUser() {
2822         require(tx.origin == msg.sender, "The caller is another contract");
2823         _;
2824     }
2825 
2826     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2827         require(_exists(_tokenId), "URI query for nonexistent token");
2828         if(lockLists[Strings.toString(_tokenId)] == true) {
2829             return lockedUri;
2830         }
2831         if(isRevealed == false) {
2832             return revealUri;
2833         }
2834         return string(abi.encodePacked(baseURI, Strings.toString(_tokenId), extension));
2835     }
2836     function _startTokenId() internal view virtual override returns (uint256) {
2837             return 1;
2838     }
2839 
2840     function publicMint(uint256 _mintAmount) public payable whenNotPaused callerIsUser {
2841         uint256 cost = publicCost * _mintAmount;
2842         mintCheck(_mintAmount, cost);
2843         require(!presale, "Presale is active.");
2844         require(
2845             _mintAmount <= publicMaxPerTx,
2846             "Mint amount over"
2847         );
2848         _safeMint(msg.sender, _mintAmount);
2849     }
2850 
2851     function preMint(uint256 _mintAmount) public payable whenNotPaused callerIsUser {
2852         uint256 cost = preCost * _mintAmount;
2853         mintCheck(_mintAmount,  cost);
2854         require(presale, "Presale is not active.");
2855         require(
2856             preMintLists[msg.sender] >= _mintAmount,
2857             "You don't have Mint List"
2858         );
2859         preMintLists[msg.sender] -= _mintAmount;
2860         _safeMint(msg.sender, _mintAmount);
2861     }
2862 
2863     function mintCheck(
2864         uint256 _mintAmount,
2865         uint256 cost
2866     ) private view {
2867         require(_mintAmount > 0, "Mint amount cannot be zero");
2868         require(
2869             totalSupply() + _mintAmount <= maxSupply,
2870             "MAXSUPPLY over"
2871         );
2872         require(msg.value >= cost, "Not enough funds");
2873     }
2874 
2875     function ownerMint(address _address, uint256 count) public onlyOwner {
2876        _safeMint(_address, count);
2877     }
2878 
2879     function bulkMint(address[] memory _toList, uint256[] memory _count) public onlyOwner  {
2880         for (uint256 i = 0; i < _toList.length; i++) {
2881             ownerMint(_toList[i], _count[i]);
2882         }
2883     }
2884 
2885     function setPresale(bool _state) public onlyOwner {
2886         presale = _state;
2887     }
2888 
2889     function setPreCost(uint256 _preCost) public onlyOwner {
2890         preCost = _preCost;
2891     }
2892 
2893     function setPublicCost(uint256 _publicCost) public onlyOwner {
2894         publicCost = _publicCost;
2895     }
2896 
2897     function getCurrentCost() public view returns (uint256) {
2898         if (presale) {
2899             return preCost;
2900         } else {
2901             return publicCost;
2902         }
2903     }
2904 
2905     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2906         baseURI = _newBaseURI;
2907     }
2908 
2909     function _getExtension() internal view returns (string memory) {
2910         return extension;
2911     }
2912 
2913     function setExtension(string memory value) external onlyOwner {
2914         extension = value;
2915     }
2916 
2917     function pause() public onlyOwner {
2918         _pause();
2919     }
2920 
2921     function unpause() public onlyOwner {
2922         _unpause();
2923     }
2924 
2925     function withdraw() external onlyOwner {
2926         Address.sendValue(payable(royaltyAddress), address(this).balance);
2927     }
2928 
2929     function pushMultiPreMintList(address[] memory list, uint256[] memory maxMint) public virtual onlyOwner {
2930         for (uint256 i = 0; i < list.length; i++) {
2931             preMintLists[list[i]] = maxMint[i];
2932         }
2933     }
2934 
2935     function getRegisteredCount(address _address) external view returns (uint256) {
2936         return preMintLists[_address];
2937     }
2938 
2939     function setRoyaltyFee(uint96 _feeNumerator) external onlyOwner {
2940         royaltyFee = _feeNumerator;
2941         _setDefaultRoyalty(royaltyAddress, royaltyFee);
2942     }
2943 
2944     function setRoyaltyAddress(address _royaltyAddress) external onlyOwner {
2945         royaltyAddress = _royaltyAddress;
2946         _setDefaultRoyalty(royaltyAddress, royaltyFee);
2947     }
2948 
2949     function setMaxSupply(uint96 _maxSupplyNumerator) external onlyOwner {
2950         maxSupply = _maxSupplyNumerator;
2951     }
2952 
2953     function setPublicMaxPerTx(uint256 _publicMaxPerTx) external onlyOwner {
2954         publicMaxPerTx = _publicMaxPerTx;
2955     }
2956 
2957     function setHiddenBaseURI(string memory _uri_) external virtual onlyOwner {
2958         revealUri = _uri_;
2959     }
2960 
2961     function setLockedURI(string memory _uri_) external virtual onlyOwner {
2962         lockedUri = _uri_;
2963     }
2964 
2965     function setReveal(bool bool_) external virtual onlyOwner {
2966         isRevealed = bool_;
2967     }
2968 
2969     function setLockList(string memory _tokenId, bool _bool) public virtual onlyOwner {
2970         lockLists[_tokenId] = _bool;
2971     }
2972 
2973     function getLockList(string memory _tokenId) public view virtual returns (bool) {
2974         return lockLists[_tokenId];
2975     }
2976 
2977     function _beforeTokenTransfers(
2978         address from,
2979         address to,
2980         uint256 startTokenId,
2981         uint256 quantity
2982     ) internal view override {
2983         if(to != address(0)){
2984             for (uint256 i = startTokenId; i < startTokenId + quantity; i++) {
2985                 require(lockLists[Strings.toString(i)] != true, "This token is locked");
2986             }
2987         }
2988     }
2989 
2990     function burn(uint256 tokenId) external virtual {
2991         _burn(tokenId, true);
2992     }
2993 
2994     function ownerBurn(uint256 tokenId) external virtual onlyOwner {
2995         _burn(tokenId, false);
2996     }
2997 
2998     function supportsInterface(
2999         bytes4 interfaceId
3000     ) public view virtual override(ERC721A, ERC2981) returns (bool) {
3001         return
3002             ERC721A.supportsInterface(interfaceId) ||
3003             ERC2981.supportsInterface(interfaceId);
3004     }
3005 }