1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //     ____             __       __   ___    __         __                  __     ___________   _____    __    ______
5 //    / __ \____ ______/ /____  / /  /   |  / /_  _____/ /__________ ______/ /_   / ____/  _/ | / /   |  / /   / ____/
6 //   / /_/ / __ `/ ___/ __/ _ \/ /  / /| | / __ \/ ___/ __/ ___/ __ `/ ___/ __/  / /_   / //  |/ / /| | / /   / __/   
7 //  / ____/ /_/ (__  ) /_/  __/ /  / ___ |/ /_/ (__  ) /_/ /  / /_/ / /__/ /_   / __/ _/ // /|  / ___ |/ /___/ /___   
8 // /_/    \__,_/____/\__/\___/_/  /_/  |_/_.___/____/\__/_/   \__,_/\___/\__/  /_/   /___/_/ |_/_/  |_/_____/_____/   
9 //                                                                                                                    
10 //
11 //*********************************************************************//
12 //*********************************************************************//
13 
14 // SPDX-License-Identifier: GPL-3.0
15 pragma solidity ^0.8.7;
16 
17 /**
18  * @dev Interface of ERC721A.
19  */
20 interface IERC721A {
21     /**
22      * The caller must own the token or be an approved operator.
23      */
24     error ApprovalCallerNotOwnerNorApproved();
25 
26     /**
27      * The token does not exist.
28      */
29     error ApprovalQueryForNonexistentToken();
30 
31     /**
32      * The caller cannot approve to their own address.
33      */
34     error ApproveToCaller();
35 
36     /**
37      * Cannot query the balance for the zero address.
38      */
39     error BalanceQueryForZeroAddress();
40 
41     /**
42      * Cannot mint to the zero address.
43      */
44     error MintToZeroAddress();
45 
46     /**
47      * The quantity of tokens minted must be more than zero.
48      */
49     error MintZeroQuantity();
50 
51     /**
52      * The token does not exist.
53      */
54     error OwnerQueryForNonexistentToken();
55 
56     /**
57      * The caller must own the token or be an approved operator.
58      */
59     error TransferCallerNotOwnerNorApproved();
60 
61     /**
62      * The token must be owned by `from`.
63      */
64     error TransferFromIncorrectOwner();
65 
66     /**
67      * Cannot safely transfer to a contract that does not implement the
68      * ERC721Receiver interface.
69      */
70     error TransferToNonERC721ReceiverImplementer();
71 
72     /**
73      * Cannot transfer to the zero address.
74      */
75     error TransferToZeroAddress();
76 
77     /**
78      * The token does not exist.
79      */
80     error URIQueryForNonexistentToken();
81 
82     /**
83      * The `quantity` minted with ERC2309 exceeds the safety limit.
84      */
85     error MintERC2309QuantityExceedsLimit();
86 
87     /**
88      * The `extraData` cannot be set on an unintialized ownership slot.
89      */
90     error OwnershipNotInitializedForExtraData();
91 
92     // =============================================================
93     //                            STRUCTS
94     // =============================================================
95 
96     struct TokenOwnership {
97         // The address of the owner.
98         address addr;
99         // Stores the start time of ownership with minimal overhead for tokenomics.
100         uint64 startTimestamp;
101         // Whether the token has been burned.
102         bool burned;
103         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
104         uint24 extraData;
105     }
106 
107     // =============================================================
108     //                         TOKEN COUNTERS
109     // =============================================================
110 
111     /**
112      * @dev Returns the total number of tokens in existence.
113      * Burned tokens will reduce the count.
114      * To get the total number of tokens minted, please see {_totalMinted}.
115      */
116     function totalSupply() external view returns (uint256);
117 
118     // =============================================================
119     //                            IERC165
120     // =============================================================
121 
122     /**
123      * @dev Returns true if this contract implements the interface defined by
124      * `interfaceId`. See the corresponding
125      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
126      * to learn more about how these ids are created.
127      *
128      * This function call must use less than 30000 gas.
129      */
130     function supportsInterface(bytes4 interfaceId) external view returns (bool);
131 
132     // =============================================================
133     //                            IERC721
134     // =============================================================
135 
136     /**
137      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
143      */
144     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables or disables
148      * (`approved`) `operator` to manage all of its assets.
149      */
150     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
151 
152     /**
153      * @dev Returns the number of tokens in `owner`'s account.
154      */
155     function balanceOf(address owner) external view returns (uint256 balance);
156 
157     /**
158      * @dev Returns the owner of the `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function ownerOf(uint256 tokenId) external view returns (address owner);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`,
168      * checking first that contract recipients are aware of the ERC721 protocol
169      * to prevent tokens from being forever locked.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be have been allowed to move
177      * this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement
179      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId,
187         bytes calldata data
188     ) external;
189 
190     /**
191      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
192      */
193     function safeTransferFrom(
194         address from,
195         address to,
196         uint256 tokenId
197     ) external;
198 
199     /**
200      * @dev Transfers `tokenId` from `from` to `to`.
201      *
202      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
203      * whenever possible.
204      *
205      * Requirements:
206      *
207      * - `from` cannot be the zero address.
208      * - `to` cannot be the zero address.
209      * - `tokenId` token must be owned by `from`.
210      * - If the caller is not `from`, it must be approved to move this token
211      * by either {approve} or {setApprovalForAll}.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(
216         address from,
217         address to,
218         uint256 tokenId
219     ) external;
220 
221     /**
222      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
223      * The approval is cleared when the token is transferred.
224      *
225      * Only a single account can be approved at a time, so approving the
226      * zero address clears previous approvals.
227      *
228      * Requirements:
229      *
230      * - The caller must own the token or be an approved operator.
231      * - `tokenId` must exist.
232      *
233      * Emits an {Approval} event.
234      */
235     function approve(address to, uint256 tokenId) external;
236 
237     /**
238      * @dev Approve or remove `operator` as an operator for the caller.
239      * Operators can call {transferFrom} or {safeTransferFrom}
240      * for any token owned by the caller.
241      *
242      * Requirements:
243      *
244      * - The `operator` cannot be the caller.
245      *
246      * Emits an {ApprovalForAll} event.
247      */
248     function setApprovalForAll(address operator, bool _approved) external;
249 
250     /**
251      * @dev Returns the account approved for `tokenId` token.
252      *
253      * Requirements:
254      *
255      * - `tokenId` must exist.
256      */
257     function getApproved(uint256 tokenId) external view returns (address operator);
258 
259     /**
260      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
261      *
262      * See {setApprovalForAll}.
263      */
264     function isApprovedForAll(address owner, address operator) external view returns (bool);
265 
266     // =============================================================
267     //                        IERC721Metadata
268     // =============================================================
269 
270     /**
271      * @dev Returns the token collection name.
272      */
273     function name() external view returns (string memory);
274 
275     /**
276      * @dev Returns the token collection symbol.
277      */
278     function symbol() external view returns (string memory);
279 
280     /**
281      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
282      */
283     function tokenURI(uint256 tokenId) external view returns (string memory);
284 
285     // =============================================================
286     //                           IERC2309
287     // =============================================================
288 
289     /**
290      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
291      * (inclusive) is transferred from `from` to `to`, as defined in the
292      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
293      *
294      * See {_mintERC2309} for more details.
295      */
296     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
297 }
298 
299 /**
300  * @dev Interface of ERC721 token receiver.
301  */
302 interface ERC721A__IERC721Receiver {
303     function onERC721Received(
304         address operator,
305         address from,
306         uint256 tokenId,
307         bytes calldata data
308     ) external returns (bytes4);
309 }
310 
311 /**
312  * @title ERC721A
313  *
314  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
315  * Non-Fungible Token Standard, including the Metadata extension.
316  * Optimized for lower gas during batch mints.
317  *
318  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
319  * starting from `_startTokenId()`.
320  *
321  * Assumptions:
322  *
323  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
324  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
325  */
326 contract ERC721A is IERC721A {
327     // Reference type for token approval.
328     struct TokenApprovalRef {
329         address value;
330     }
331 
332     // =============================================================
333     //                           CONSTANTS
334     // =============================================================
335 
336     // Mask of an entry in packed address data.
337     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
338 
339     // The bit position of `numberMinted` in packed address data.
340     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
341 
342     // The bit position of `numberBurned` in packed address data.
343     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
344 
345     // The bit position of `aux` in packed address data.
346     uint256 private constant _BITPOS_AUX = 192;
347 
348     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
349     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
350 
351     // The bit position of `startTimestamp` in packed ownership.
352     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
353 
354     // The bit mask of the `burned` bit in packed ownership.
355     uint256 private constant _BITMASK_BURNED = 1 << 224;
356 
357     // The bit position of the `nextInitialized` bit in packed ownership.
358     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
359 
360     // The bit mask of the `nextInitialized` bit in packed ownership.
361     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
362 
363     // The bit position of `extraData` in packed ownership.
364     uint256 private constant _BITPOS_EXTRA_DATA = 232;
365 
366     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
367     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
368 
369     // The mask of the lower 160 bits for addresses.
370     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
371 
372     // The maximum `quantity` that can be minted with {_mintERC2309}.
373     // This limit is to prevent overflows on the address data entries.
374     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
375     // is required to cause an overflow, which is unrealistic.
376     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
377 
378     // The `Transfer` event signature is given by:
379     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
380     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
381         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
382 
383     // =============================================================
384     //                            STORAGE
385     // =============================================================
386 
387     // The next token ID to be minted.
388     uint256 private _currentIndex;
389 
390     // The number of tokens burned.
391     uint256 private _burnCounter;
392 
393     // Token name
394     string private _name;
395 
396     // Token symbol
397     string private _symbol;
398 
399     // Mapping from token ID to ownership details
400     // An empty struct value does not necessarily mean the token is unowned.
401     // See {_packedOwnershipOf} implementation for details.
402     //
403     // Bits Layout:
404     // - [0..159]   `addr`
405     // - [160..223] `startTimestamp`
406     // - [224]      `burned`
407     // - [225]      `nextInitialized`
408     // - [232..255] `extraData`
409     mapping(uint256 => uint256) private _packedOwnerships;
410 
411     // Mapping owner address to address data.
412     //
413     // Bits Layout:
414     // - [0..63]    `balance`
415     // - [64..127]  `numberMinted`
416     // - [128..191] `numberBurned`
417     // - [192..255] `aux`
418     mapping(address => uint256) private _packedAddressData;
419 
420     // Mapping from token ID to approved address.
421     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
422 
423     // Mapping from owner to operator approvals
424     mapping(address => mapping(address => bool)) private _operatorApprovals;
425 
426     // =============================================================
427     //                          CONSTRUCTOR
428     // =============================================================
429 
430     constructor(string memory name_, string memory symbol_) {
431         _name = name_;
432         _symbol = symbol_;
433         _currentIndex = _startTokenId();
434     }
435 
436     // =============================================================
437     //                   TOKEN COUNTING OPERATIONS
438     // =============================================================
439 
440     /**
441      * @dev Returns the starting token ID.
442      * To change the starting token ID, please override this function.
443      */
444     function _startTokenId() internal view virtual returns (uint256) {
445         return 0;
446     }
447 
448     /**
449      * @dev Returns the next token ID to be minted.
450      */
451     function _nextTokenId() internal view virtual returns (uint256) {
452         return _currentIndex;
453     }
454 
455     /**
456      * @dev Returns the total number of tokens in existence.
457      * Burned tokens will reduce the count.
458      * To get the total number of tokens minted, please see {_totalMinted}.
459      */
460     function totalSupply() public view virtual override returns (uint256) {
461         // Counter underflow is impossible as _burnCounter cannot be incremented
462         // more than `_currentIndex - _startTokenId()` times.
463         unchecked {
464             return _currentIndex - _burnCounter - _startTokenId();
465         }
466     }
467 
468     /**
469      * @dev Returns the total amount of tokens minted in the contract.
470      */
471     function _totalMinted() internal view virtual returns (uint256) {
472         // Counter underflow is impossible as `_currentIndex` does not decrement,
473         // and it is initialized to `_startTokenId()`.
474         unchecked {
475             return _currentIndex - _startTokenId();
476         }
477     }
478 
479     /**
480      * @dev Returns the total number of tokens burned.
481      */
482     function _totalBurned() internal view virtual returns (uint256) {
483         return _burnCounter;
484     }
485 
486     // =============================================================
487     //                    ADDRESS DATA OPERATIONS
488     // =============================================================
489 
490     /**
491      * @dev Returns the number of tokens in `owner`'s account.
492      */
493     function balanceOf(address owner) public view virtual override returns (uint256) {
494         if (owner == address(0)) revert BalanceQueryForZeroAddress();
495         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
496     }
497 
498     /**
499      * Returns the number of tokens minted by `owner`.
500      */
501     function _numberMinted(address owner) internal view returns (uint256) {
502         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
503     }
504 
505     /**
506      * Returns the number of tokens burned by or on behalf of `owner`.
507      */
508     function _numberBurned(address owner) internal view returns (uint256) {
509         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
510     }
511 
512     /**
513      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
514      */
515     function _getAux(address owner) internal view returns (uint64) {
516         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
517     }
518 
519     /**
520      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
521      * If there are multiple variables, please pack them into a uint64.
522      */
523     function _setAux(address owner, uint64 aux) internal virtual {
524         uint256 packed = _packedAddressData[owner];
525         uint256 auxCasted;
526         // Cast `aux` with assembly to avoid redundant masking.
527         assembly {
528             auxCasted := aux
529         }
530         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
531         _packedAddressData[owner] = packed;
532     }
533 
534     // =============================================================
535     //                            IERC165
536     // =============================================================
537 
538     /**
539      * @dev Returns true if this contract implements the interface defined by
540      * `interfaceId`. See the corresponding
541      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
542      * to learn more about how these ids are created.
543      *
544      * This function call must use less than 30000 gas.
545      */
546     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547         // The interface IDs are constants representing the first 4 bytes
548         // of the XOR of all function selectors in the interface.
549         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
550         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
551         return
552             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
553             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
554             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
555     }
556 
557     // =============================================================
558     //                        IERC721Metadata
559     // =============================================================
560 
561     /**
562      * @dev Returns the token collection name.
563      */
564     function name() public view virtual override returns (string memory) {
565         return _name;
566     }
567 
568     /**
569      * @dev Returns the token collection symbol.
570      */
571     function symbol() public view virtual override returns (string memory) {
572         return _symbol;
573     }
574 
575     /**
576      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
577      */
578     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
579         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
580 
581         string memory baseURI = _baseURI();
582         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
583     }
584 
585     /**
586      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
587      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
588      * by default, it can be overridden in child contracts.
589      */
590     function _baseURI() internal view virtual returns (string memory) {
591         return '';
592     }
593 
594     // =============================================================
595     //                     OWNERSHIPS OPERATIONS
596     // =============================================================
597 
598     /**
599      * @dev Returns the owner of the `tokenId` token.
600      *
601      * Requirements:
602      *
603      * - `tokenId` must exist.
604      */
605     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
606         return address(uint160(_packedOwnershipOf(tokenId)));
607     }
608 
609     /**
610      * @dev Gas spent here starts off proportional to the maximum mint batch size.
611      * It gradually moves to O(1) as tokens get transferred around over time.
612      */
613     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
614         return _unpackedOwnership(_packedOwnershipOf(tokenId));
615     }
616 
617     /**
618      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
619      */
620     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
621         return _unpackedOwnership(_packedOwnerships[index]);
622     }
623 
624     /**
625      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
626      */
627     function _initializeOwnershipAt(uint256 index) internal virtual {
628         if (_packedOwnerships[index] == 0) {
629             _packedOwnerships[index] = _packedOwnershipOf(index);
630         }
631     }
632 
633     /**
634      * Returns the packed ownership data of `tokenId`.
635      */
636     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
637         uint256 curr = tokenId;
638 
639         unchecked {
640             if (_startTokenId() <= curr)
641                 if (curr < _currentIndex) {
642                     uint256 packed = _packedOwnerships[curr];
643                     // If not burned.
644                     if (packed & _BITMASK_BURNED == 0) {
645                         // Invariant:
646                         // There will always be an initialized ownership slot
647                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
648                         // before an unintialized ownership slot
649                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
650                         // Hence, `curr` will not underflow.
651                         //
652                         // We can directly compare the packed value.
653                         // If the address is zero, packed will be zero.
654                         while (packed == 0) {
655                             packed = _packedOwnerships[--curr];
656                         }
657                         return packed;
658                     }
659                 }
660         }
661         revert OwnerQueryForNonexistentToken();
662     }
663 
664     /**
665      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
666      */
667     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
668         ownership.addr = address(uint160(packed));
669         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
670         ownership.burned = packed & _BITMASK_BURNED != 0;
671         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
672     }
673 
674     /**
675      * @dev Packs ownership data into a single uint256.
676      */
677     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
678         assembly {
679             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
680             owner := and(owner, _BITMASK_ADDRESS)
681             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
682             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
683         }
684     }
685 
686     /**
687      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
688      */
689     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
690         // For branchless setting of the `nextInitialized` flag.
691         assembly {
692             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
693             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
694         }
695     }
696 
697     // =============================================================
698     //                      APPROVAL OPERATIONS
699     // =============================================================
700 
701     /**
702      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
703      * The approval is cleared when the token is transferred.
704      *
705      * Only a single account can be approved at a time, so approving the
706      * zero address clears previous approvals.
707      *
708      * Requirements:
709      *
710      * - The caller must own the token or be an approved operator.
711      * - `tokenId` must exist.
712      *
713      * Emits an {Approval} event.
714      */
715     function approve(address to, uint256 tokenId) public virtual override {
716         address owner = ownerOf(tokenId);
717 
718         if (_msgSenderERC721A() != owner)
719             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
720                 revert ApprovalCallerNotOwnerNorApproved();
721             }
722 
723         _tokenApprovals[tokenId].value = to;
724         emit Approval(owner, to, tokenId);
725     }
726 
727     /**
728      * @dev Returns the account approved for `tokenId` token.
729      *
730      * Requirements:
731      *
732      * - `tokenId` must exist.
733      */
734     function getApproved(uint256 tokenId) public view virtual override returns (address) {
735         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
736 
737         return _tokenApprovals[tokenId].value;
738     }
739 
740     /**
741      * @dev Approve or remove `operator` as an operator for the caller.
742      * Operators can call {transferFrom} or {safeTransferFrom}
743      * for any token owned by the caller.
744      *
745      * Requirements:
746      *
747      * - The `operator` cannot be the caller.
748      *
749      * Emits an {ApprovalForAll} event.
750      */
751     function setApprovalForAll(address operator, bool approved) public virtual override {
752         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
753 
754         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
755         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
756     }
757 
758     /**
759      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
760      *
761      * See {setApprovalForAll}.
762      */
763     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
764         return _operatorApprovals[owner][operator];
765     }
766 
767     /**
768      * @dev Returns whether `tokenId` exists.
769      *
770      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
771      *
772      * Tokens start existing when they are minted. See {_mint}.
773      */
774     function _exists(uint256 tokenId) internal view virtual returns (bool) {
775         return
776             _startTokenId() <= tokenId &&
777             tokenId < _currentIndex && // If within bounds,
778             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
779     }
780 
781     /**
782      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
783      */
784     function _isSenderApprovedOrOwner(
785         address approvedAddress,
786         address owner,
787         address msgSender
788     ) private pure returns (bool result) {
789         assembly {
790             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
791             owner := and(owner, _BITMASK_ADDRESS)
792             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
793             msgSender := and(msgSender, _BITMASK_ADDRESS)
794             // `msgSender == owner || msgSender == approvedAddress`.
795             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
796         }
797     }
798 
799     /**
800      * @dev Returns the storage slot and value for the approved address of `tokenId`.
801      */
802     function _getApprovedSlotAndAddress(uint256 tokenId)
803         private
804         view
805         returns (uint256 approvedAddressSlot, address approvedAddress)
806     {
807         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
808         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
809         assembly {
810             approvedAddressSlot := tokenApproval.slot
811             approvedAddress := sload(approvedAddressSlot)
812         }
813     }
814 
815     // =============================================================
816     //                      TRANSFER OPERATIONS
817     // =============================================================
818 
819     /**
820      * @dev Transfers `tokenId` from `from` to `to`.
821      *
822      * Requirements:
823      *
824      * - `from` cannot be the zero address.
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must be owned by `from`.
827      * - If the caller is not `from`, it must be approved to move this token
828      * by either {approve} or {setApprovalForAll}.
829      *
830      * Emits a {Transfer} event.
831      */
832     function transferFrom(
833         address from,
834         address to,
835         uint256 tokenId
836     ) public virtual override {
837         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
838 
839         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
840 
841         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
842 
843         // The nested ifs save around 20+ gas over a compound boolean condition.
844         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
845             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
846 
847         if (to == address(0)) revert TransferToZeroAddress();
848 
849         _beforeTokenTransfers(from, to, tokenId, 1);
850 
851         // Clear approvals from the previous owner.
852         assembly {
853             if approvedAddress {
854                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
855                 sstore(approvedAddressSlot, 0)
856             }
857         }
858 
859         // Underflow of the sender's balance is impossible because we check for
860         // ownership above and the recipient's balance can't realistically overflow.
861         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
862         unchecked {
863             // We can directly increment and decrement the balances.
864             --_packedAddressData[from]; // Updates: `balance -= 1`.
865             ++_packedAddressData[to]; // Updates: `balance += 1`.
866 
867             // Updates:
868             // - `address` to the next owner.
869             // - `startTimestamp` to the timestamp of transfering.
870             // - `burned` to `false`.
871             // - `nextInitialized` to `true`.
872             _packedOwnerships[tokenId] = _packOwnershipData(
873                 to,
874                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
875             );
876 
877             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
878             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
879                 uint256 nextTokenId = tokenId + 1;
880                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
881                 if (_packedOwnerships[nextTokenId] == 0) {
882                     // If the next slot is within bounds.
883                     if (nextTokenId != _currentIndex) {
884                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
885                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
886                     }
887                 }
888             }
889         }
890 
891         emit Transfer(from, to, tokenId);
892         _afterTokenTransfers(from, to, tokenId, 1);
893     }
894 
895     /**
896      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) public virtual override {
903         safeTransferFrom(from, to, tokenId, '');
904     }
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
926     ) public virtual override {
927         transferFrom(from, to, tokenId);
928         if (to.code.length != 0)
929             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
930                 revert TransferToNonERC721ReceiverImplementer();
931             }
932     }
933 
934     /**
935      * @dev Hook that is called before a set of serially-ordered token IDs
936      * are about to be transferred. This includes minting.
937      * And also called before burning one token.
938      *
939      * `startTokenId` - the first token ID to be transferred.
940      * `quantity` - the amount to be transferred.
941      *
942      * Calling conditions:
943      *
944      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
945      * transferred to `to`.
946      * - When `from` is zero, `tokenId` will be minted for `to`.
947      * - When `to` is zero, `tokenId` will be burned by `from`.
948      * - `from` and `to` are never both zero.
949      */
950     function _beforeTokenTransfers(
951         address from,
952         address to,
953         uint256 startTokenId,
954         uint256 quantity
955     ) internal virtual {}
956 
957     /**
958      * @dev Hook that is called after a set of serially-ordered token IDs
959      * have been transferred. This includes minting.
960      * And also called after one token has been burned.
961      *
962      * `startTokenId` - the first token ID to be transferred.
963      * `quantity` - the amount to be transferred.
964      *
965      * Calling conditions:
966      *
967      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
968      * transferred to `to`.
969      * - When `from` is zero, `tokenId` has been minted for `to`.
970      * - When `to` is zero, `tokenId` has been burned by `from`.
971      * - `from` and `to` are never both zero.
972      */
973     function _afterTokenTransfers(
974         address from,
975         address to,
976         uint256 startTokenId,
977         uint256 quantity
978     ) internal virtual {}
979 
980     /**
981      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
982      *
983      * `from` - Previous owner of the given token ID.
984      * `to` - Target address that will receive the token.
985      * `tokenId` - Token ID to be transferred.
986      * `_data` - Optional data to send along with the call.
987      *
988      * Returns whether the call correctly returned the expected magic value.
989      */
990     function _checkContractOnERC721Received(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) private returns (bool) {
996         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
997             bytes4 retval
998         ) {
999             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1000         } catch (bytes memory reason) {
1001             if (reason.length == 0) {
1002                 revert TransferToNonERC721ReceiverImplementer();
1003             } else {
1004                 assembly {
1005                     revert(add(32, reason), mload(reason))
1006                 }
1007             }
1008         }
1009     }
1010 
1011     // =============================================================
1012     //                        MINT OPERATIONS
1013     // =============================================================
1014 
1015     /**
1016      * @dev Mints `quantity` tokens and transfers them to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `quantity` must be greater than 0.
1022      *
1023      * Emits a {Transfer} event for each mint.
1024      */
1025     function _mint(address to, uint256 quantity) internal virtual {
1026         uint256 startTokenId = _currentIndex;
1027         if (quantity == 0) revert MintZeroQuantity();
1028 
1029         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1030 
1031         // Overflows are incredibly unrealistic.
1032         // `balance` and `numberMinted` have a maximum limit of 2**64.
1033         // `tokenId` has a maximum limit of 2**256.
1034         unchecked {
1035             // Updates:
1036             // - `balance += quantity`.
1037             // - `numberMinted += quantity`.
1038             //
1039             // We can directly add to the `balance` and `numberMinted`.
1040             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1041 
1042             // Updates:
1043             // - `address` to the owner.
1044             // - `startTimestamp` to the timestamp of minting.
1045             // - `burned` to `false`.
1046             // - `nextInitialized` to `quantity == 1`.
1047             _packedOwnerships[startTokenId] = _packOwnershipData(
1048                 to,
1049                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1050             );
1051 
1052             uint256 toMasked;
1053             uint256 end = startTokenId + quantity;
1054 
1055             // Use assembly to loop and emit the `Transfer` event for gas savings.
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
1339     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1340         assembly {
1341             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1342             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1343             // We will need 1 32-byte word to store the length,
1344             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1345             ptr := add(mload(0x40), 128)
1346             // Update the free memory pointer to allocate.
1347             mstore(0x40, ptr)
1348 
1349             // Cache the end of the memory to calculate the length later.
1350             let end := ptr
1351 
1352             // We write the string from the rightmost digit to the leftmost digit.
1353             // The following is essentially a do-while loop that also handles the zero case.
1354             // Costs a bit more than early returning for the zero case,
1355             // but cheaper in terms of deployment and overall runtime costs.
1356             for {
1357                 // Initialize and perform the first pass without check.
1358                 let temp := value
1359                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1360                 ptr := sub(ptr, 1)
1361                 // Write the character to the pointer.
1362                 // The ASCII index of the '0' character is 48.
1363                 mstore8(ptr, add(48, mod(temp, 10)))
1364                 temp := div(temp, 10)
1365             } temp {
1366                 // Keep dividing `temp` until zero.
1367                 temp := div(temp, 10)
1368             } {
1369                 // Body of the for loop.
1370                 ptr := sub(ptr, 1)
1371                 mstore8(ptr, add(48, mod(temp, 10)))
1372             }
1373 
1374             let length := sub(end, ptr)
1375             // Move the pointer 32 bytes leftwards to make room for the length.
1376             ptr := sub(ptr, 32)
1377             // Store the length.
1378             mstore(ptr, length)
1379         }
1380     }
1381 }
1382 
1383 
1384 contract PastelAbstractPre is ERC721A {
1385     uint256 public immutable maxSupply = 333; 
1386     uint256 private price = 0.005 ether;
1387     uint256 private maxPerTx = 5;
1388     uint256 private maxFree;
1389 
1390     function mint(uint256 qty) external payable {
1391         require(totalSupply() + qty  <= maxSupply);
1392         require(qty <= maxPerTx);
1393         require(msg.value >= price * qty);
1394         _safeMint(msg.sender, qty);
1395     }
1396     
1397     address public owner;
1398     modifier onlyOwner {
1399         require(owner == msg.sender);
1400         _;
1401     }
1402 
1403     constructor() ERC721A("Pastel Abstract Previos By Naon", "PAP") {
1404         owner = msg.sender;
1405         maxFree = 100;
1406     }
1407     
1408     function setPrice(uint256 newPrice, uint256 maxT) external onlyOwner {
1409         price = newPrice;
1410         maxPerTx = maxT;
1411     }
1412 
1413     function freeMint() external {
1414         require(msg.sender == tx.origin);
1415         require (totalSupply() + 1  < maxFree);
1416         _safeMint(msg.sender, 1);
1417     }
1418 
1419     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1420         return string(abi.encodePacked("ipfs://QmesUGwoqKJ9TjjJ8o3rNX3U3piUGSo4Ewq2hG8pWVMZxi/", _toString(tokenId)));
1421     }
1422     
1423     function withdraw() external onlyOwner {
1424         payable(msg.sender).transfer(address(this).balance);
1425     }
1426 }