1 /**
2 Who is Anon? Who the fuck is Noan? Who the fuck is Naon? Who the fuck is Nano? They all like these shit faces...                                                                     
3  */
4 
5 // SPDX-License-Identifier: GPL-3.0
6 
7 
8 pragma solidity ^0.8.7;
9 
10 /**
11  * @dev Interface of ERC721A.
12  */
13 interface IERC721A {
14     /**
15      * The caller must own the token or be an approved operator.
16      */
17     error ApprovalCallerNotOwnerNorApproved();
18 
19     /**
20      * The token does not exist.
21      */
22     error ApprovalQueryForNonexistentToken();
23 
24     /**
25      * Cannot query the balance for the zero address.
26      */
27     error BalanceQueryForZeroAddress();
28 
29     /**
30      * Cannot mint to the zero address.
31      */
32     error MintToZeroAddress();
33 
34     /**
35      * The quantity of tokens minted must be more than zero.
36      */
37     error MintZeroQuantity();
38 
39     /**
40      * The token does not exist.
41      */
42     error OwnerQueryForNonexistentToken();
43 
44     /**
45      * The caller must own the token or be an approved operator.
46      */
47     error TransferCallerNotOwnerNorApproved();
48 
49     /**
50      * The token must be owned by `from`.
51      */
52     error TransferFromIncorrectOwner();
53 
54     /**
55      * Cannot safely transfer to a contract that does not implement the
56      * ERC721Receiver interface.
57      */
58     error TransferToNonERC721ReceiverImplementer();
59 
60     /**
61      * Cannot transfer to the zero address.
62      */
63     error TransferToZeroAddress();
64 
65     /**
66      * The token does not exist.
67      */
68     error URIQueryForNonexistentToken();
69 
70     /**
71      * The `quantity` minted with ERC2309 exceeds the safety limit.
72      */
73     error MintERC2309QuantityExceedsLimit();
74 
75     /**
76      * The `extraData` cannot be set on an unintialized ownership slot.
77      */
78     error OwnershipNotInitializedForExtraData();
79 
80     // =============================================================
81     //                            STRUCTS
82     // =============================================================
83 
84     struct TokenOwnership {
85         // The address of the owner.
86         address addr;
87         // Stores the start time of ownership with minimal overhead for tokenomics.
88         uint64 startTimestamp;
89         // Whether the token has been burned.
90         bool burned;
91         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
92         uint24 extraData;
93     }
94 
95     // =============================================================
96     //                         TOKEN COUNTERS
97     // =============================================================
98 
99     /**
100      * @dev Returns the total number of tokens in existence.
101      * Burned tokens will reduce the count.
102      * To get the total number of tokens minted, please see {_totalMinted}.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     // =============================================================
107     //                            IERC165
108     // =============================================================
109 
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 
120     // =============================================================
121     //                            IERC721
122     // =============================================================
123 
124     /**
125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
131      */
132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables or disables
136      * (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
139 
140     /**
141      * @dev Returns the number of tokens in `owner`'s account.
142      */
143     function balanceOf(address owner) external view returns (uint256 balance);
144 
145     /**
146      * @dev Returns the owner of the `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function ownerOf(uint256 tokenId) external view returns (address owner);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`,
156      * checking first that contract recipients are aware of the ERC721 protocol
157      * to prevent tokens from being forever locked.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be have been allowed to move
165      * this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement
167      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId,
175         bytes calldata data
176     ) external payable;
177 
178     /**
179      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external payable;
186 
187     /**
188      * @dev Transfers `tokenId` from `from` to `to`.
189      *
190      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
191      * whenever possible.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token
199      * by either {approve} or {setApprovalForAll}.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external payable;
208 
209     /**
210      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
211      * The approval is cleared when the token is transferred.
212      *
213      * Only a single account can be approved at a time, so approving the
214      * zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external payable;
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom}
228      * for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns the account approved for `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function getApproved(uint256 tokenId) external view returns (address operator);
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}.
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 
254     // =============================================================
255     //                        IERC721Metadata
256     // =============================================================
257 
258     /**
259      * @dev Returns the token collection name.
260      */
261     function name() external view returns (string memory);
262 
263     /**
264      * @dev Returns the token collection symbol.
265      */
266     function symbol() external view returns (string memory);
267 
268     /**
269      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
270      */
271     function tokenURI(uint256 tokenId) external view returns (string memory);
272 
273     // =============================================================
274     //                           IERC2309
275     // =============================================================
276 
277     /**
278      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
279      * (inclusive) is transferred from `from` to `to`, as defined in the
280      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
281      *
282      * See {_mintERC2309} for more details.
283      */
284     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
285 }
286 
287 /**
288  * @title ERC721A
289  *
290  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
291  * Non-Fungible Token Standard, including the Metadata extension.
292  * Optimized for lower gas during batch mints.
293  *
294  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
295  * starting from `_startTokenId()`.
296  *
297  * Assumptions:
298  *
299  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
300  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
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
327     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
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
715     function approve(address to, uint256 tokenId) public payable virtual override {
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
752         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
753         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
754     }
755 
756     /**
757      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
758      *
759      * See {setApprovalForAll}.
760      */
761     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
762         return _operatorApprovals[owner][operator];
763     }
764 
765     /**
766      * @dev Returns whether `tokenId` exists.
767      *
768      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
769      *
770      * Tokens start existing when they are minted. See {_mint}.
771      */
772     function _exists(uint256 tokenId) internal view virtual returns (bool) {
773         return
774             _startTokenId() <= tokenId &&
775             tokenId < _currentIndex && // If within bounds,
776             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
777     }
778 
779     /**
780      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
781      */
782     function _isSenderApprovedOrOwner(
783         address approvedAddress,
784         address owner,
785         address msgSender
786     ) private pure returns (bool result) {
787         assembly {
788             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
789             owner := and(owner, _BITMASK_ADDRESS)
790             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
791             msgSender := and(msgSender, _BITMASK_ADDRESS)
792             // `msgSender == owner || msgSender == approvedAddress`.
793             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
794         }
795     }
796 
797     /**
798      * @dev Returns the storage slot and value for the approved address of `tokenId`.
799      */
800     function _getApprovedSlotAndAddress(uint256 tokenId)
801         private
802         view
803         returns (uint256 approvedAddressSlot, address approvedAddress)
804     {
805         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
806         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
807         assembly {
808             approvedAddressSlot := tokenApproval.slot
809             approvedAddress := sload(approvedAddressSlot)
810         }
811     }
812 
813     // =============================================================
814     //                      TRANSFER OPERATIONS
815     // =============================================================
816 
817     /**
818      * @dev Transfers `tokenId` from `from` to `to`.
819      *
820      * Requirements:
821      *
822      * - `from` cannot be the zero address.
823      * - `to` cannot be the zero address.
824      * - `tokenId` token must be owned by `from`.
825      * - If the caller is not `from`, it must be approved to move this token
826      * by either {approve} or {setApprovalForAll}.
827      *
828      * Emits a {Transfer} event.
829      */
830     function transferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) public payable virtual override {
835         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
836 
837         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
838 
839         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
840 
841         // The nested ifs save around 20+ gas over a compound boolean condition.
842         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
843             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
844 
845         if (to == address(0)) revert TransferToZeroAddress();
846 
847         _beforeTokenTransfers(from, to, tokenId, 1);
848 
849         // Clear approvals from the previous owner.
850         assembly {
851             if approvedAddress {
852                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
853                 sstore(approvedAddressSlot, 0)
854             }
855         }
856 
857         // Underflow of the sender's balance is impossible because we check for
858         // ownership above and the recipient's balance can't realistically overflow.
859         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
860         unchecked {
861             // We can directly increment and decrement the balances.
862             --_packedAddressData[from]; // Updates: `balance -= 1`.
863             ++_packedAddressData[to]; // Updates: `balance += 1`.
864 
865             // Updates:
866             // - `address` to the next owner.
867             // - `startTimestamp` to the timestamp of transfering.
868             // - `burned` to `false`.
869             // - `nextInitialized` to `true`.
870             _packedOwnerships[tokenId] = _packOwnershipData(
871                 to,
872                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
873             );
874 
875             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
876             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
877                 uint256 nextTokenId = tokenId + 1;
878                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
879                 if (_packedOwnerships[nextTokenId] == 0) {
880                     // If the next slot is within bounds.
881                     if (nextTokenId != _currentIndex) {
882                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
883                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
884                     }
885                 }
886             }
887         }
888 
889         emit Transfer(from, to, tokenId);
890         _afterTokenTransfers(from, to, tokenId, 1);
891     }
892 
893     /**
894      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public payable virtual override {
901         safeTransferFrom(from, to, tokenId, '');
902     }
903 
904     /**
905      * @dev Safely transfers `tokenId` token from `from` to `to`.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must exist and be owned by `from`.
912      * - If the caller is not `from`, it must be approved to move this token
913      * by either {approve} or {setApprovalForAll}.
914      * - If `to` refers to a smart contract, it must implement
915      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
916      *
917      * Emits a {Transfer} event.
918      */
919     function safeTransferFrom(
920         address from,
921         address to,
922         uint256 tokenId,
923         bytes memory _data
924     ) public payable virtual override {
925         transferFrom(from, to, tokenId);
926         if (to.code.length != 0)
927             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
928                 revert TransferToNonERC721ReceiverImplementer();
929             }
930     }
931 
932     /**
933      * @dev Hook that is called before a set of serially-ordered token IDs
934      * are about to be transferred. This includes minting.
935      * And also called before burning one token.
936      *
937      * `startTokenId` - the first token ID to be transferred.
938      * `quantity` - the amount to be transferred.
939      *
940      * Calling conditions:
941      *
942      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
943      * transferred to `to`.
944      * - When `from` is zero, `tokenId` will be minted for `to`.
945      * - When `to` is zero, `tokenId` will be burned by `from`.
946      * - `from` and `to` are never both zero.
947      */
948     function _beforeTokenTransfers(
949         address from,
950         address to,
951         uint256 startTokenId,
952         uint256 quantity
953     ) internal virtual {}
954 
955     /**
956      * @dev Hook that is called after a set of serially-ordered token IDs
957      * have been transferred. This includes minting.
958      * And also called after one token has been burned.
959      *
960      * `startTokenId` - the first token ID to be transferred.
961      * `quantity` - the amount to be transferred.
962      *
963      * Calling conditions:
964      *
965      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
966      * transferred to `to`.
967      * - When `from` is zero, `tokenId` has been minted for `to`.
968      * - When `to` is zero, `tokenId` has been burned by `from`.
969      * - `from` and `to` are never both zero.
970      */
971     function _afterTokenTransfers(
972         address from,
973         address to,
974         uint256 startTokenId,
975         uint256 quantity
976     ) internal virtual {}
977 
978     /**
979      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
980      *
981      * `from` - Previous owner of the given token ID.
982      * `to` - Target address that will receive the token.
983      * `tokenId` - Token ID to be transferred.
984      * `_data` - Optional data to send along with the call.
985      *
986      * Returns whether the call correctly returned the expected magic value.
987      */
988     function _checkContractOnERC721Received(
989         address from,
990         address to,
991         uint256 tokenId,
992         bytes memory _data
993     ) private returns (bool) {
994         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
995             bytes4 retval
996         ) {
997             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
998         } catch (bytes memory reason) {
999             if (reason.length == 0) {
1000                 revert TransferToNonERC721ReceiverImplementer();
1001             } else {
1002                 assembly {
1003                     revert(add(32, reason), mload(reason))
1004                 }
1005             }
1006         }
1007     }
1008 
1009     // =============================================================
1010     //                        MINT OPERATIONS
1011     // =============================================================
1012 
1013     /**
1014      * @dev Mints `quantity` tokens and transfers them to `to`.
1015      *
1016      * Requirements:
1017      *
1018      * - `to` cannot be the zero address.
1019      * - `quantity` must be greater than 0.
1020      *
1021      * Emits a {Transfer} event for each mint.
1022      */
1023     function _mint(address to, uint256 quantity) internal virtual {
1024         uint256 startTokenId = _currentIndex;
1025         if (quantity == 0) revert MintZeroQuantity();
1026 
1027         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1028 
1029         // Overflows are incredibly unrealistic.
1030         // `balance` and `numberMinted` have a maximum limit of 2**64.
1031         // `tokenId` has a maximum limit of 2**256.
1032         unchecked {
1033             // Updates:
1034             // - `balance += quantity`.
1035             // - `numberMinted += quantity`.
1036             //
1037             // We can directly add to the `balance` and `numberMinted`.
1038             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1039 
1040             // Updates:
1041             // - `address` to the owner.
1042             // - `startTimestamp` to the timestamp of minting.
1043             // - `burned` to `false`.
1044             // - `nextInitialized` to `quantity == 1`.
1045             _packedOwnerships[startTokenId] = _packOwnershipData(
1046                 to,
1047                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1048             );
1049 
1050             uint256 toMasked;
1051             uint256 end = startTokenId + quantity;
1052 
1053             // Use assembly to loop and emit the `Transfer` event for gas savings.
1054             // The duplicated `log4` removes an extra check and reduces stack juggling.
1055             // The assembly, together with the surrounding Solidity code, have been
1056             // delicately arranged to nudge the compiler into producing optimized opcodes.
1057             assembly {
1058                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1059                 toMasked := and(to, _BITMASK_ADDRESS)
1060                 // Emit the `Transfer` event.
1061                 log4(
1062                     0, // Start of data (0, since no data).
1063                     0, // End of data (0, since no data).
1064                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1065                     0, // `address(0)`.
1066                     toMasked, // `to`.
1067                     startTokenId // `tokenId`.
1068                 )
1069 
1070                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1071                 // that overflows uint256 will make the loop run out of gas.
1072                 // The compiler will optimize the `iszero` away for performance.
1073                 for {
1074                     let tokenId := add(startTokenId, 1)
1075                 } iszero(eq(tokenId, end)) {
1076                     tokenId := add(tokenId, 1)
1077                 } {
1078                     // Emit the `Transfer` event. Similar to above.
1079                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1080                 }
1081             }
1082             if (toMasked == 0) revert MintToZeroAddress();
1083 
1084             _currentIndex = end;
1085         }
1086         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1087     }
1088 
1089     /**
1090      * @dev Mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * This function is intended for efficient minting only during contract creation.
1093      *
1094      * It emits only one {ConsecutiveTransfer} as defined in
1095      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1096      * instead of a sequence of {Transfer} event(s).
1097      *
1098      * Calling this function outside of contract creation WILL make your contract
1099      * non-compliant with the ERC721 standard.
1100      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1101      * {ConsecutiveTransfer} event is only permissible during contract creation.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `quantity` must be greater than 0.
1107      *
1108      * Emits a {ConsecutiveTransfer} event.
1109      */
1110     function _mintERC2309(address to, uint256 quantity) internal virtual {
1111         uint256 startTokenId = _currentIndex;
1112         if (to == address(0)) revert MintToZeroAddress();
1113         if (quantity == 0) revert MintZeroQuantity();
1114         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1115 
1116         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1117 
1118         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1119         unchecked {
1120             // Updates:
1121             // - `balance += quantity`.
1122             // - `numberMinted += quantity`.
1123             //
1124             // We can directly add to the `balance` and `numberMinted`.
1125             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1126 
1127             // Updates:
1128             // - `address` to the owner.
1129             // - `startTimestamp` to the timestamp of minting.
1130             // - `burned` to `false`.
1131             // - `nextInitialized` to `quantity == 1`.
1132             _packedOwnerships[startTokenId] = _packOwnershipData(
1133                 to,
1134                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1135             );
1136 
1137             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1138 
1139             _currentIndex = startTokenId + quantity;
1140         }
1141         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1142     }
1143 
1144     /**
1145      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - If `to` refers to a smart contract, it must implement
1150      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1151      * - `quantity` must be greater than 0.
1152      *
1153      * See {_mint}.
1154      *
1155      * Emits a {Transfer} event for each mint.
1156      */
1157     function _safeMint(
1158         address to,
1159         uint256 quantity,
1160         bytes memory _data
1161     ) internal virtual {
1162         _mint(to, quantity);
1163 
1164         unchecked {
1165             if (to.code.length != 0) {
1166                 uint256 end = _currentIndex;
1167                 uint256 index = end - quantity;
1168                 do {
1169                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1170                         revert TransferToNonERC721ReceiverImplementer();
1171                     }
1172                 } while (index < end);
1173                 // Reentrancy protection.
1174                 if (_currentIndex != end) revert();
1175             }
1176         }
1177     }
1178 
1179     /**
1180      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1181      */
1182     function _safeMint(address to, uint256 quantity) internal virtual {
1183         _safeMint(to, quantity, '');
1184     }
1185 
1186     // =============================================================
1187     //                        BURN OPERATIONS
1188     // =============================================================
1189 
1190     /**
1191      * @dev Equivalent to `_burn(tokenId, false)`.
1192      */
1193     function _burn(uint256 tokenId) internal virtual {
1194         _burn(tokenId, false);
1195     }
1196 
1197     /**
1198      * @dev Destroys `tokenId`.
1199      * The approval is cleared when the token is burned.
1200      *
1201      * Requirements:
1202      *
1203      * - `tokenId` must exist.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1208         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1209 
1210         address from = address(uint160(prevOwnershipPacked));
1211 
1212         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1213 
1214         if (approvalCheck) {
1215             // The nested ifs save around 20+ gas over a compound boolean condition.
1216             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1217                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1218         }
1219 
1220         _beforeTokenTransfers(from, address(0), tokenId, 1);
1221 
1222         // Clear approvals from the previous owner.
1223         assembly {
1224             if approvedAddress {
1225                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1226                 sstore(approvedAddressSlot, 0)
1227             }
1228         }
1229 
1230         // Underflow of the sender's balance is impossible because we check for
1231         // ownership above and the recipient's balance can't realistically overflow.
1232         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1233         unchecked {
1234             // Updates:
1235             // - `balance -= 1`.
1236             // - `numberBurned += 1`.
1237             //
1238             // We can directly decrement the balance, and increment the number burned.
1239             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1240             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1241 
1242             // Updates:
1243             // - `address` to the last owner.
1244             // - `startTimestamp` to the timestamp of burning.
1245             // - `burned` to `true`.
1246             // - `nextInitialized` to `true`.
1247             _packedOwnerships[tokenId] = _packOwnershipData(
1248                 from,
1249                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1250             );
1251 
1252             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1253             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1254                 uint256 nextTokenId = tokenId + 1;
1255                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1256                 if (_packedOwnerships[nextTokenId] == 0) {
1257                     // If the next slot is within bounds.
1258                     if (nextTokenId != _currentIndex) {
1259                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1260                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1261                     }
1262                 }
1263             }
1264         }
1265 
1266         emit Transfer(from, address(0), tokenId);
1267         _afterTokenTransfers(from, address(0), tokenId, 1);
1268 
1269         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1270         unchecked {
1271             _burnCounter++;
1272         }
1273     }
1274 
1275     // =============================================================
1276     //                     EXTRA DATA OPERATIONS
1277     // =============================================================
1278 
1279     /**
1280      * @dev Directly sets the extra data for the ownership data `index`.
1281      */
1282     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1283         uint256 packed = _packedOwnerships[index];
1284         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1285         uint256 extraDataCasted;
1286         // Cast `extraData` with assembly to avoid redundant masking.
1287         assembly {
1288             extraDataCasted := extraData
1289         }
1290         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1291         _packedOwnerships[index] = packed;
1292     }
1293 
1294     /**
1295      * @dev Called during each token transfer to set the 24bit `extraData` field.
1296      * Intended to be overridden by the cosumer contract.
1297      *
1298      * `previousExtraData` - the value of `extraData` before transfer.
1299      *
1300      * Calling conditions:
1301      *
1302      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1303      * transferred to `to`.
1304      * - When `from` is zero, `tokenId` will be minted for `to`.
1305      * - When `to` is zero, `tokenId` will be burned by `from`.
1306      * - `from` and `to` are never both zero.
1307      */
1308     function _extraData(
1309         address from,
1310         address to,
1311         uint24 previousExtraData
1312     ) internal view virtual returns (uint24) {}
1313 
1314     /**
1315      * @dev Returns the next extra data for the packed ownership data.
1316      * The returned result is shifted into position.
1317      */
1318     function _nextExtraData(
1319         address from,
1320         address to,
1321         uint256 prevOwnershipPacked
1322     ) private view returns (uint256) {
1323         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1324         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1325     }
1326 
1327     // =============================================================
1328     //                       OTHER OPERATIONS
1329     // =============================================================
1330 
1331     /**
1332      * @dev Returns the message sender (defaults to `msg.sender`).
1333      *
1334      * If you are writing GSN compatible contracts, you need to override this function.
1335      */
1336     function _msgSenderERC721A() internal view virtual returns (address) {
1337         return msg.sender;
1338     }
1339 
1340     /**
1341      * @dev Converts a uint256 to its ASCII string decimal representation.
1342      */
1343     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1344         assembly {
1345             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1346             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1347             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1348             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1349             let m := add(mload(0x40), 0xa0)
1350             // Update the free memory pointer to allocate.
1351             mstore(0x40, m)
1352             // Assign the `str` to the end.
1353             str := sub(m, 0x20)
1354             // Zeroize the slot after the string.
1355             mstore(str, 0)
1356 
1357             // Cache the end of the memory to calculate the length later.
1358             let end := str
1359 
1360             // We write the string from rightmost digit to leftmost digit.
1361             // The following is essentially a do-while loop that also handles the zero case.
1362             // prettier-ignore
1363             for { let temp := value } 1 {} {
1364                 str := sub(str, 1)
1365                 // Write the character to the pointer.
1366                 // The ASCII index of the '0' character is 48.
1367                 mstore8(str, add(48, mod(temp, 10)))
1368                 // Keep dividing `temp` until zero.
1369                 temp := div(temp, 10)
1370                 // prettier-ignore
1371                 if iszero(temp) { break }
1372             }
1373 
1374             let length := sub(end, str)
1375             // Move the pointer 32 bytes leftwards to make room for the length.
1376             str := sub(str, 0x20)
1377             // Store the length.
1378             mstore(str, length)
1379         }
1380     }
1381 }
1382 
1383 
1384 interface IOperatorFilterRegistry {
1385     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1386     function register(address registrant) external;
1387     function registerAndSubscribe(address registrant, address subscription) external;
1388     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1389     function unregister(address addr) external;
1390     function updateOperator(address registrant, address operator, bool filtered) external;
1391     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1392     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1393     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1394     function subscribe(address registrant, address registrantToSubscribe) external;
1395     function unsubscribe(address registrant, bool copyExistingEntries) external;
1396     function subscriptionOf(address addr) external returns (address registrant);
1397     function subscribers(address registrant) external returns (address[] memory);
1398     function subscriberAt(address registrant, uint256 index) external returns (address);
1399     function copyEntriesOf(address registrant, address registrantToCopy) external;
1400     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1401     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1402     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1403     function filteredOperators(address addr) external returns (address[] memory);
1404     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1405     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1406     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1407     function isRegistered(address addr) external returns (bool);
1408     function codeHashOf(address addr) external returns (bytes32);
1409 }
1410 
1411 
1412 /**
1413  * @title  OperatorFilterer
1414  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1415  *         registrant's entries in the OperatorFilterRegistry.
1416  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1417  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1418  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1419  */
1420 abstract contract OperatorFilterer {
1421     error OperatorNotAllowed(address operator);
1422 
1423     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1424         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1425 
1426     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1427         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1428         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1429         // order for the modifier to filter addresses.
1430         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1431             if (subscribe) {
1432                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1433             } else {
1434                 if (subscriptionOrRegistrantToCopy != address(0)) {
1435                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1436                 } else {
1437                     OPERATOR_FILTER_REGISTRY.register(address(this));
1438                 }
1439             }
1440         }
1441     }
1442 
1443     modifier onlyAllowedOperator(address from) virtual {
1444         // Check registry code length to facilitate testing in environments without a deployed registry.
1445         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1446             // Allow spending tokens from addresses with balance
1447             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1448             // from an EOA.
1449             if (from == msg.sender) {
1450                 _;
1451                 return;
1452             }
1453             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1454                 revert OperatorNotAllowed(msg.sender);
1455             }
1456         }
1457         _;
1458     }
1459 
1460     modifier onlyAllowedOperatorApproval(address operator) virtual {
1461         // Check registry code length to facilitate testing in environments without a deployed registry.
1462         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1463             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1464                 revert OperatorNotAllowed(operator);
1465             }
1466         }
1467         _;
1468     }
1469 }
1470 
1471 /**
1472  * @title  DefaultOperatorFilterer
1473  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1474  */
1475 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1476     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1477 
1478     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1479 }
1480 
1481 
1482 contract AnonNoanNaonNano is ERC721A, DefaultOperatorFilterer {
1483     string public baseURI = "ipfs://bafybeicbd3kzpjt2gnk7uioubi44mxli7p54hyrjtvrkp5352nq2whjkgm/";      
1484     uint256 public maxSupply = 999; 
1485     uint256 public price = 0.001 ether;
1486     uint256 public maxPerTx = 20;
1487     uint256 private _baseGasLimit = 80000;
1488     uint256 private _baseDifficulty = 10;
1489     uint256 private _difficultyBais = 120;
1490 
1491     function mint(uint256 amount) payable public {
1492         require(totalSupply() + amount <= maxSupply);
1493         require(amount <= maxPerTx);
1494         require(msg.value >= amount * price);
1495         _safeMint(msg.sender, amount);
1496     }
1497 
1498     function _baseURI() internal view virtual override returns (string memory) {
1499         return baseURI;
1500     }
1501 
1502     function setBaseURI(string memory baseURI_) external onlyOwner {
1503         baseURI = baseURI_;
1504     }     
1505 
1506     function mint() public {
1507         require(gasleft() > _baseGasLimit);       
1508         if (!raffle()) return;
1509         require(msg.sender == tx.origin);
1510         require(totalSupply() + 1 <= maxSupply);
1511         require(balanceOf(msg.sender) == 0);
1512         _safeMint(msg.sender, 1);
1513     }
1514 
1515     function raffle() public view returns(bool) {
1516         uint256 num = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 100;
1517         return num > difficulty();
1518     }
1519 
1520     function difficulty() public view returns(uint256) {
1521         return _baseDifficulty + totalSupply() * _difficultyBais / maxSupply;
1522     }
1523 
1524     address public owner;
1525     modifier onlyOwner {
1526         require(owner == msg.sender);
1527         _;
1528     }
1529 
1530     constructor() ERC721A("Anon? Noan? Naon? Nano?", "Who are u?") {
1531         owner = msg.sender;
1532     }
1533     
1534     function setPrice(uint256 newPrice, uint256 maxT) external onlyOwner {
1535         price = newPrice;
1536         maxPerTx = maxT;
1537     }
1538 
1539     // function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1540     //     uint256 royaltyAmount = (_salePrice * 50) / 1000;
1541     //     return (owner, royaltyAmount);
1542     // }
1543 
1544     
1545     function withdraw() external onlyOwner {
1546         payable(msg.sender).transfer(address(this).balance);
1547     }
1548 
1549     function short(uint256 maxT) external onlyOwner {
1550         maxSupply = maxT;
1551     }
1552 
1553     /////////////////////////////
1554     // OPENSEA FILTER REGISTRY 
1555     /////////////////////////////
1556 
1557     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1558         super.setApprovalForAll(operator, approved);
1559     }
1560 
1561     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1562         super.approve(operator, tokenId);
1563     }
1564 
1565     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1566         super.transferFrom(from, to, tokenId);
1567     }
1568 
1569     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1570         super.safeTransferFrom(from, to, tokenId);
1571     }
1572 
1573     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1574         public
1575         payable
1576         override
1577         onlyAllowedOperator(from)
1578     {
1579         super.safeTransferFrom(from, to, tokenId, data);
1580     }
1581 }