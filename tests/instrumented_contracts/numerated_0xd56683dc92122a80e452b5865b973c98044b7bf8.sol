1 // SPDX-License-Identifier: MIT
2 
3 // File: erc721a/contracts/IERC721A.sol
4 
5 
6 // ERC721A Contracts v4.2.3
7 // Creator: Bored Kong Yacht Club
8 
9 pragma solidity ^0.8.4;
10 
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
288 // File: erc721a/contracts/ERC721A.sol
289 
290 
291 // ERC721A Contracts v4.2.3
292 // Creator: Chiru Labs
293 
294 pragma solidity ^0.8.4;
295 
296 
297 /**
298  * @dev Interface of ERC721 token receiver.
299  */
300 interface ERC721A__IERC721Receiver {
301     function onERC721Received(
302         address operator,
303         address from,
304         uint256 tokenId,
305         bytes calldata data
306     ) external returns (bytes4);
307 }
308 
309 /**
310  * @title ERC721A
311  *
312  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
313  * Non-Fungible Token Standard, including the Metadata extension.
314  * Optimized for lower gas during batch mints.
315  *
316  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
317  * starting from `_startTokenId()`.
318  *
319  * Assumptions:
320  *
321  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
322  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
323  */
324 contract ERC721A is IERC721A {
325     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
326     struct TokenApprovalRef {
327         address value;
328     }
329 
330     // =============================================================
331     //                           CONSTANTS
332     // =============================================================
333 
334     // Mask of an entry in packed address data.
335     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
336 
337     // The bit position of `numberMinted` in packed address data.
338     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
339 
340     // The bit position of `numberBurned` in packed address data.
341     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
342 
343     // The bit position of `aux` in packed address data.
344     uint256 private constant _BITPOS_AUX = 192;
345 
346     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
347     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
348 
349     // The bit position of `startTimestamp` in packed ownership.
350     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
351 
352     // The bit mask of the `burned` bit in packed ownership.
353     uint256 private constant _BITMASK_BURNED = 1 << 224;
354 
355     // The bit position of the `nextInitialized` bit in packed ownership.
356     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
357 
358     // The bit mask of the `nextInitialized` bit in packed ownership.
359     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
360 
361     // The bit position of `extraData` in packed ownership.
362     uint256 private constant _BITPOS_EXTRA_DATA = 232;
363 
364     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
365     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
366 
367     // The mask of the lower 160 bits for addresses.
368     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
369 
370     // The maximum `quantity` that can be minted with {_mintERC2309}.
371     // This limit is to prevent overflows on the address data entries.
372     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
373     // is required to cause an overflow, which is unrealistic.
374     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
375 
376     // The `Transfer` event signature is given by:
377     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
378     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
379         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
380 
381     // =============================================================
382     //                            STORAGE
383     // =============================================================
384 
385     // The next token ID to be minted.
386     uint256 private _currentIndex;
387 
388     // The number of tokens burned.
389     uint256 private _burnCounter;
390 
391     // Token name
392     string private _name;
393 
394     // Token symbol
395     string private _symbol;
396 
397     // Mapping from token ID to ownership details
398     // An empty struct value does not necessarily mean the token is unowned.
399     // See {_packedOwnershipOf} implementation for details.
400     //
401     // Bits Layout:
402     // - [0..159]   `addr`
403     // - [160..223] `startTimestamp`
404     // - [224]      `burned`
405     // - [225]      `nextInitialized`
406     // - [232..255] `extraData`
407     mapping(uint256 => uint256) private _packedOwnerships;
408 
409     // Mapping owner address to address data.
410     //
411     // Bits Layout:
412     // - [0..63]    `balance`
413     // - [64..127]  `numberMinted`
414     // - [128..191] `numberBurned`
415     // - [192..255] `aux`
416     mapping(address => uint256) private _packedAddressData;
417 
418     // Mapping from token ID to approved address.
419     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
420 
421     // Mapping from owner to operator approvals
422     mapping(address => mapping(address => bool)) private _operatorApprovals;
423 
424     // =============================================================
425     //                          CONSTRUCTOR
426     // =============================================================
427 
428     constructor(string memory name_, string memory symbol_) {
429         _name = name_;
430         _symbol = symbol_;
431         _currentIndex = _startTokenId();
432     }
433 
434     // =============================================================
435     //                   TOKEN COUNTING OPERATIONS
436     // =============================================================
437 
438     /**
439      * @dev Returns the starting token ID.
440      * To change the starting token ID, please override this function.
441      */
442     function _startTokenId() internal view virtual returns (uint256) {
443         return 0;
444     }
445 
446     /**
447      * @dev Returns the next token ID to be minted.
448      */
449     function _nextTokenId() internal view virtual returns (uint256) {
450         return _currentIndex;
451     }
452 
453     /**
454      * @dev Returns the total number of tokens in existence.
455      * Burned tokens will reduce the count.
456      * To get the total number of tokens minted, please see {_totalMinted}.
457      */
458     function totalSupply() public view virtual override returns (uint256) {
459         // Counter underflow is impossible as _burnCounter cannot be incremented
460         // more than `_currentIndex - _startTokenId()` times.
461         unchecked {
462             return _currentIndex - _burnCounter - _startTokenId();
463         }
464     }
465 
466     /**
467      * @dev Returns the total amount of tokens minted in the contract.
468      */
469     function _totalMinted() internal view virtual returns (uint256) {
470         // Counter underflow is impossible as `_currentIndex` does not decrement,
471         // and it is initialized to `_startTokenId()`.
472         unchecked {
473             return _currentIndex - _startTokenId();
474         }
475     }
476 
477     /**
478      * @dev Returns the total number of tokens burned.
479      */
480     function _totalBurned() internal view virtual returns (uint256) {
481         return _burnCounter;
482     }
483 
484     // =============================================================
485     //                    ADDRESS DATA OPERATIONS
486     // =============================================================
487 
488     /**
489      * @dev Returns the number of tokens in `owner`'s account.
490      */
491     function balanceOf(address owner) public view virtual override returns (uint256) {
492         if (owner == address(0)) revert BalanceQueryForZeroAddress();
493         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
494     }
495 
496     /**
497      * Returns the number of tokens minted by `owner`.
498      */
499     function _numberMinted(address owner) internal view returns (uint256) {
500         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
501     }
502 
503     /**
504      * Returns the number of tokens burned by or on behalf of `owner`.
505      */
506     function _numberBurned(address owner) internal view returns (uint256) {
507         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
508     }
509 
510     /**
511      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
512      */
513     function _getAux(address owner) internal view returns (uint64) {
514         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
515     }
516 
517     /**
518      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
519      * If there are multiple variables, please pack them into a uint64.
520      */
521     function _setAux(address owner, uint64 aux) internal virtual {
522         uint256 packed = _packedAddressData[owner];
523         uint256 auxCasted;
524         // Cast `aux` with assembly to avoid redundant masking.
525         assembly {
526             auxCasted := aux
527         }
528         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
529         _packedAddressData[owner] = packed;
530     }
531 
532     // =============================================================
533     //                            IERC165
534     // =============================================================
535 
536     /**
537      * @dev Returns true if this contract implements the interface defined by
538      * `interfaceId`. See the corresponding
539      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
540      * to learn more about how these ids are created.
541      *
542      * This function call must use less than 30000 gas.
543      */
544     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
545         // The interface IDs are constants representing the first 4 bytes
546         // of the XOR of all function selectors in the interface.
547         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
548         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
549         return
550             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
551             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
552             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
553     }
554 
555     // =============================================================
556     //                        IERC721Metadata
557     // =============================================================
558 
559     /**
560      * @dev Returns the token collection name.
561      */
562     function name() public view virtual override returns (string memory) {
563         return _name;
564     }
565 
566     /**
567      * @dev Returns the token collection symbol.
568      */
569     function symbol() public view virtual override returns (string memory) {
570         return _symbol;
571     }
572 
573     /**
574      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
575      */
576     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
577         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
578 
579         string memory baseURI = _baseURI();
580         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
581     }
582 
583     /**
584      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
585      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
586      * by default, it can be overridden in child contracts.
587      */
588     function _baseURI() internal view virtual returns (string memory) {
589         return '';
590     }
591 
592     // =============================================================
593     //                     OWNERSHIPS OPERATIONS
594     // =============================================================
595 
596     /**
597      * @dev Returns the owner of the `tokenId` token.
598      *
599      * Requirements:
600      *
601      * - `tokenId` must exist.
602      */
603     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
604         return address(uint160(_packedOwnershipOf(tokenId)));
605     }
606 
607     /**
608      * @dev Gas spent here starts off proportional to the maximum mint batch size.
609      * It gradually moves to O(1) as tokens get transferred around over time.
610      */
611     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
612         return _unpackedOwnership(_packedOwnershipOf(tokenId));
613     }
614 
615     /**
616      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
617      */
618     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
619         return _unpackedOwnership(_packedOwnerships[index]);
620     }
621 
622     /**
623      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
624      */
625     function _initializeOwnershipAt(uint256 index) internal virtual {
626         if (_packedOwnerships[index] == 0) {
627             _packedOwnerships[index] = _packedOwnershipOf(index);
628         }
629     }
630 
631     /**
632      * Returns the packed ownership data of `tokenId`.
633      */
634     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
635         uint256 curr = tokenId;
636 
637         unchecked {
638             if (_startTokenId() <= curr)
639                 if (curr < _currentIndex) {
640                     uint256 packed = _packedOwnerships[curr];
641                     // If not burned.
642                     if (packed & _BITMASK_BURNED == 0) {
643                         // Invariant:
644                         // There will always be an initialized ownership slot
645                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
646                         // before an unintialized ownership slot
647                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
648                         // Hence, `curr` will not underflow.
649                         //
650                         // We can directly compare the packed value.
651                         // If the address is zero, packed will be zero.
652                         while (packed == 0) {
653                             packed = _packedOwnerships[--curr];
654                         }
655                         return packed;
656                     }
657                 }
658         }
659         revert OwnerQueryForNonexistentToken();
660     }
661 
662     /**
663      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
664      */
665     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
666         ownership.addr = address(uint160(packed));
667         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
668         ownership.burned = packed & _BITMASK_BURNED != 0;
669         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
670     }
671 
672     /**
673      * @dev Packs ownership data into a single uint256.
674      */
675     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
676         assembly {
677             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
678             owner := and(owner, _BITMASK_ADDRESS)
679             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
680             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
681         }
682     }
683 
684     /**
685      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
686      */
687     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
688         // For branchless setting of the `nextInitialized` flag.
689         assembly {
690             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
691             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
692         }
693     }
694 
695     // =============================================================
696     //                      APPROVAL OPERATIONS
697     // =============================================================
698 
699     /**
700      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
701      * The approval is cleared when the token is transferred.
702      *
703      * Only a single account can be approved at a time, so approving the
704      * zero address clears previous approvals.
705      *
706      * Requirements:
707      *
708      * - The caller must own the token or be an approved operator.
709      * - `tokenId` must exist.
710      *
711      * Emits an {Approval} event.
712      */
713     function approve(address to, uint256 tokenId) public payable virtual override {
714         address owner = ownerOf(tokenId);
715 
716         if (_msgSenderERC721A() != owner)
717             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
718                 revert ApprovalCallerNotOwnerNorApproved();
719             }
720 
721         _tokenApprovals[tokenId].value = to;
722         emit Approval(owner, to, tokenId);
723     }
724 
725     /**
726      * @dev Returns the account approved for `tokenId` token.
727      *
728      * Requirements:
729      *
730      * - `tokenId` must exist.
731      */
732     function getApproved(uint256 tokenId) public view virtual override returns (address) {
733         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
734 
735         return _tokenApprovals[tokenId].value;
736     }
737 
738     /**
739      * @dev Approve or remove `operator` as an operator for the caller.
740      * Operators can call {transferFrom} or {safeTransferFrom}
741      * for any token owned by the caller.
742      *
743      * Requirements:
744      *
745      * - The `operator` cannot be the caller.
746      *
747      * Emits an {ApprovalForAll} event.
748      */
749     function setApprovalForAll(address operator, bool approved) public virtual override {
750         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
751         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
752     }
753 
754     /**
755      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
756      *
757      * See {setApprovalForAll}.
758      */
759     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
760         return _operatorApprovals[owner][operator];
761     }
762 
763     /**
764      * @dev Returns whether `tokenId` exists.
765      *
766      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
767      *
768      * Tokens start existing when they are minted. See {_mint}.
769      */
770     function _exists(uint256 tokenId) internal view virtual returns (bool) {
771         return
772             _startTokenId() <= tokenId &&
773             tokenId < _currentIndex && // If within bounds,
774             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
775     }
776 
777     /**
778      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
779      */
780     function _isSenderApprovedOrOwner(
781         address approvedAddress,
782         address owner,
783         address msgSender
784     ) private pure returns (bool result) {
785         assembly {
786             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
787             owner := and(owner, _BITMASK_ADDRESS)
788             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
789             msgSender := and(msgSender, _BITMASK_ADDRESS)
790             // `msgSender == owner || msgSender == approvedAddress`.
791             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
792         }
793     }
794 
795     /**
796      * @dev Returns the storage slot and value for the approved address of `tokenId`.
797      */
798     function _getApprovedSlotAndAddress(uint256 tokenId)
799         private
800         view
801         returns (uint256 approvedAddressSlot, address approvedAddress)
802     {
803         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
804         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
805         assembly {
806             approvedAddressSlot := tokenApproval.slot
807             approvedAddress := sload(approvedAddressSlot)
808         }
809     }
810 
811     // =============================================================
812     //                      TRANSFER OPERATIONS
813     // =============================================================
814 
815     /**
816      * @dev Transfers `tokenId` from `from` to `to`.
817      *
818      * Requirements:
819      *
820      * - `from` cannot be the zero address.
821      * - `to` cannot be the zero address.
822      * - `tokenId` token must be owned by `from`.
823      * - If the caller is not `from`, it must be approved to move this token
824      * by either {approve} or {setApprovalForAll}.
825      *
826      * Emits a {Transfer} event.
827      */
828     function transferFrom(
829         address from,
830         address to,
831         uint256 tokenId
832     ) public payable virtual override {
833         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
834 
835         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
836 
837         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
838 
839         // The nested ifs save around 20+ gas over a compound boolean condition.
840         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
841             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
842 
843         if (to == address(0)) revert TransferToZeroAddress();
844 
845         _beforeTokenTransfers(from, to, tokenId, 1);
846 
847         // Clear approvals from the previous owner.
848         assembly {
849             if approvedAddress {
850                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
851                 sstore(approvedAddressSlot, 0)
852             }
853         }
854 
855         // Underflow of the sender's balance is impossible because we check for
856         // ownership above and the recipient's balance can't realistically overflow.
857         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
858         unchecked {
859             // We can directly increment and decrement the balances.
860             --_packedAddressData[from]; // Updates: `balance -= 1`.
861             ++_packedAddressData[to]; // Updates: `balance += 1`.
862 
863             // Updates:
864             // - `address` to the next owner.
865             // - `startTimestamp` to the timestamp of transfering.
866             // - `burned` to `false`.
867             // - `nextInitialized` to `true`.
868             _packedOwnerships[tokenId] = _packOwnershipData(
869                 to,
870                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
871             );
872 
873             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
874             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
875                 uint256 nextTokenId = tokenId + 1;
876                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
877                 if (_packedOwnerships[nextTokenId] == 0) {
878                     // If the next slot is within bounds.
879                     if (nextTokenId != _currentIndex) {
880                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
881                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
882                     }
883                 }
884             }
885         }
886 
887         emit Transfer(from, to, tokenId);
888         _afterTokenTransfers(from, to, tokenId, 1);
889     }
890 
891     /**
892      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
893      */
894     function safeTransferFrom(
895         address from,
896         address to,
897         uint256 tokenId
898     ) public payable virtual override {
899         safeTransferFrom(from, to, tokenId, '');
900     }
901 
902     /**
903      * @dev Safely transfers `tokenId` token from `from` to `to`.
904      *
905      * Requirements:
906      *
907      * - `from` cannot be the zero address.
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must exist and be owned by `from`.
910      * - If the caller is not `from`, it must be approved to move this token
911      * by either {approve} or {setApprovalForAll}.
912      * - If `to` refers to a smart contract, it must implement
913      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) public payable virtual override {
923         transferFrom(from, to, tokenId);
924         if (to.code.length != 0)
925             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
926                 revert TransferToNonERC721ReceiverImplementer();
927             }
928     }
929 
930     /**
931      * @dev Hook that is called before a set of serially-ordered token IDs
932      * are about to be transferred. This includes minting.
933      * And also called before burning one token.
934      *
935      * `startTokenId` - the first token ID to be transferred.
936      * `quantity` - the amount to be transferred.
937      *
938      * Calling conditions:
939      *
940      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
941      * transferred to `to`.
942      * - When `from` is zero, `tokenId` will be minted for `to`.
943      * - When `to` is zero, `tokenId` will be burned by `from`.
944      * - `from` and `to` are never both zero.
945      */
946     function _beforeTokenTransfers(
947         address from,
948         address to,
949         uint256 startTokenId,
950         uint256 quantity
951     ) internal virtual {}
952 
953     /**
954      * @dev Hook that is called after a set of serially-ordered token IDs
955      * have been transferred. This includes minting.
956      * And also called after one token has been burned.
957      *
958      * `startTokenId` - the first token ID to be transferred.
959      * `quantity` - the amount to be transferred.
960      *
961      * Calling conditions:
962      *
963      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
964      * transferred to `to`.
965      * - When `from` is zero, `tokenId` has been minted for `to`.
966      * - When `to` is zero, `tokenId` has been burned by `from`.
967      * - `from` and `to` are never both zero.
968      */
969     function _afterTokenTransfers(
970         address from,
971         address to,
972         uint256 startTokenId,
973         uint256 quantity
974     ) internal virtual {}
975 
976     /**
977      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
978      *
979      * `from` - Previous owner of the given token ID.
980      * `to` - Target address that will receive the token.
981      * `tokenId` - Token ID to be transferred.
982      * `_data` - Optional data to send along with the call.
983      *
984      * Returns whether the call correctly returned the expected magic value.
985      */
986     function _checkContractOnERC721Received(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) private returns (bool) {
992         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
993             bytes4 retval
994         ) {
995             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
996         } catch (bytes memory reason) {
997             if (reason.length == 0) {
998                 revert TransferToNonERC721ReceiverImplementer();
999             } else {
1000                 assembly {
1001                     revert(add(32, reason), mload(reason))
1002                 }
1003             }
1004         }
1005     }
1006 
1007     // =============================================================
1008     //                        MINT OPERATIONS
1009     // =============================================================
1010 
1011     /**
1012      * @dev Mints `quantity` tokens and transfers them to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - `to` cannot be the zero address.
1017      * - `quantity` must be greater than 0.
1018      *
1019      * Emits a {Transfer} event for each mint.
1020      */
1021     function _mint(address to, uint256 quantity) internal virtual {
1022         uint256 startTokenId = _currentIndex;
1023         if (quantity == 0) revert MintZeroQuantity();
1024 
1025         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1026 
1027         // Overflows are incredibly unrealistic.
1028         // `balance` and `numberMinted` have a maximum limit of 2**64.
1029         // `tokenId` has a maximum limit of 2**256.
1030         unchecked {
1031             // Updates:
1032             // - `balance += quantity`.
1033             // - `numberMinted += quantity`.
1034             //
1035             // We can directly add to the `balance` and `numberMinted`.
1036             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1037 
1038             // Updates:
1039             // - `address` to the owner.
1040             // - `startTimestamp` to the timestamp of minting.
1041             // - `burned` to `false`.
1042             // - `nextInitialized` to `quantity == 1`.
1043             _packedOwnerships[startTokenId] = _packOwnershipData(
1044                 to,
1045                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1046             );
1047 
1048             uint256 toMasked;
1049             uint256 end = startTokenId + quantity;
1050 
1051             // Use assembly to loop and emit the `Transfer` event for gas savings.
1052             // The duplicated `log4` removes an extra check and reduces stack juggling.
1053             // The assembly, together with the surrounding Solidity code, have been
1054             // delicately arranged to nudge the compiler into producing optimized opcodes.
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
1068                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1069                 // that overflows uint256 will make the loop run out of gas.
1070                 // The compiler will optimize the `iszero` away for performance.
1071                 for {
1072                     let tokenId := add(startTokenId, 1)
1073                 } iszero(eq(tokenId, end)) {
1074                     tokenId := add(tokenId, 1)
1075                 } {
1076                     // Emit the `Transfer` event. Similar to above.
1077                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1078                 }
1079             }
1080             if (toMasked == 0) revert MintToZeroAddress();
1081 
1082             _currentIndex = end;
1083         }
1084         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1085     }
1086 
1087     /**
1088      * @dev Mints `quantity` tokens and transfers them to `to`.
1089      *
1090      * This function is intended for efficient minting only during contract creation.
1091      *
1092      * It emits only one {ConsecutiveTransfer} as defined in
1093      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1094      * instead of a sequence of {Transfer} event(s).
1095      *
1096      * Calling this function outside of contract creation WILL make your contract
1097      * non-compliant with the ERC721 standard.
1098      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1099      * {ConsecutiveTransfer} event is only permissible during contract creation.
1100      *
1101      * Requirements:
1102      *
1103      * - `to` cannot be the zero address.
1104      * - `quantity` must be greater than 0.
1105      *
1106      * Emits a {ConsecutiveTransfer} event.
1107      */
1108     function _mintERC2309(address to, uint256 quantity) internal virtual {
1109         uint256 startTokenId = _currentIndex;
1110         if (to == address(0)) revert MintToZeroAddress();
1111         if (quantity == 0) revert MintZeroQuantity();
1112         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1113 
1114         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1115 
1116         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1117         unchecked {
1118             // Updates:
1119             // - `balance += quantity`.
1120             // - `numberMinted += quantity`.
1121             //
1122             // We can directly add to the `balance` and `numberMinted`.
1123             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1124 
1125             // Updates:
1126             // - `address` to the owner.
1127             // - `startTimestamp` to the timestamp of minting.
1128             // - `burned` to `false`.
1129             // - `nextInitialized` to `quantity == 1`.
1130             _packedOwnerships[startTokenId] = _packOwnershipData(
1131                 to,
1132                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1133             );
1134 
1135             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1136 
1137             _currentIndex = startTokenId + quantity;
1138         }
1139         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1140     }
1141 
1142     /**
1143      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - If `to` refers to a smart contract, it must implement
1148      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1149      * - `quantity` must be greater than 0.
1150      *
1151      * See {_mint}.
1152      *
1153      * Emits a {Transfer} event for each mint.
1154      */
1155     function _safeMint(
1156         address to,
1157         uint256 quantity,
1158         bytes memory _data
1159     ) internal virtual {
1160         _mint(to, quantity);
1161 
1162         unchecked {
1163             if (to.code.length != 0) {
1164                 uint256 end = _currentIndex;
1165                 uint256 index = end - quantity;
1166                 do {
1167                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1168                         revert TransferToNonERC721ReceiverImplementer();
1169                     }
1170                 } while (index < end);
1171                 // Reentrancy protection.
1172                 if (_currentIndex != end) revert();
1173             }
1174         }
1175     }
1176 
1177     /**
1178      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1179      */
1180     function _safeMint(address to, uint256 quantity) internal virtual {
1181         _safeMint(to, quantity, '');
1182     }
1183 
1184     // =============================================================
1185     //                        BURN OPERATIONS
1186     // =============================================================
1187 
1188     /**
1189      * @dev Equivalent to `_burn(tokenId, false)`.
1190      */
1191     function _burn(uint256 tokenId) internal virtual {
1192         _burn(tokenId, false);
1193     }
1194 
1195     /**
1196      * @dev Destroys `tokenId`.
1197      * The approval is cleared when the token is burned.
1198      *
1199      * Requirements:
1200      *
1201      * - `tokenId` must exist.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1206         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1207 
1208         address from = address(uint160(prevOwnershipPacked));
1209 
1210         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1211 
1212         if (approvalCheck) {
1213             // The nested ifs save around 20+ gas over a compound boolean condition.
1214             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1215                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1216         }
1217 
1218         _beforeTokenTransfers(from, address(0), tokenId, 1);
1219 
1220         // Clear approvals from the previous owner.
1221         assembly {
1222             if approvedAddress {
1223                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1224                 sstore(approvedAddressSlot, 0)
1225             }
1226         }
1227 
1228         // Underflow of the sender's balance is impossible because we check for
1229         // ownership above and the recipient's balance can't realistically overflow.
1230         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1231         unchecked {
1232             // Updates:
1233             // - `balance -= 1`.
1234             // - `numberBurned += 1`.
1235             //
1236             // We can directly decrement the balance, and increment the number burned.
1237             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1238             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1239 
1240             // Updates:
1241             // - `address` to the last owner.
1242             // - `startTimestamp` to the timestamp of burning.
1243             // - `burned` to `true`.
1244             // - `nextInitialized` to `true`.
1245             _packedOwnerships[tokenId] = _packOwnershipData(
1246                 from,
1247                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1248             );
1249 
1250             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1251             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1252                 uint256 nextTokenId = tokenId + 1;
1253                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1254                 if (_packedOwnerships[nextTokenId] == 0) {
1255                     // If the next slot is within bounds.
1256                     if (nextTokenId != _currentIndex) {
1257                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1258                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1259                     }
1260                 }
1261             }
1262         }
1263 
1264         emit Transfer(from, address(0), tokenId);
1265         _afterTokenTransfers(from, address(0), tokenId, 1);
1266 
1267         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1268         unchecked {
1269             _burnCounter++;
1270         }
1271     }
1272 
1273     // =============================================================
1274     //                     EXTRA DATA OPERATIONS
1275     // =============================================================
1276 
1277     /**
1278      * @dev Directly sets the extra data for the ownership data `index`.
1279      */
1280     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1281         uint256 packed = _packedOwnerships[index];
1282         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1283         uint256 extraDataCasted;
1284         // Cast `extraData` with assembly to avoid redundant masking.
1285         assembly {
1286             extraDataCasted := extraData
1287         }
1288         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1289         _packedOwnerships[index] = packed;
1290     }
1291 
1292     /**
1293      * @dev Called during each token transfer to set the 24bit `extraData` field.
1294      * Intended to be overridden by the cosumer contract.
1295      *
1296      * `previousExtraData` - the value of `extraData` before transfer.
1297      *
1298      * Calling conditions:
1299      *
1300      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1301      * transferred to `to`.
1302      * - When `from` is zero, `tokenId` will be minted for `to`.
1303      * - When `to` is zero, `tokenId` will be burned by `from`.
1304      * - `from` and `to` are never both zero.
1305      */
1306     function _extraData(
1307         address from,
1308         address to,
1309         uint24 previousExtraData
1310     ) internal view virtual returns (uint24) {}
1311 
1312     /**
1313      * @dev Returns the next extra data for the packed ownership data.
1314      * The returned result is shifted into position.
1315      */
1316     function _nextExtraData(
1317         address from,
1318         address to,
1319         uint256 prevOwnershipPacked
1320     ) private view returns (uint256) {
1321         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1322         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1323     }
1324 
1325     // =============================================================
1326     //                       OTHER OPERATIONS
1327     // =============================================================
1328 
1329     /**
1330      * @dev Returns the message sender (defaults to `msg.sender`).
1331      *
1332      * If you are writing GSN compatible contracts, you need to override this function.
1333      */
1334     function _msgSenderERC721A() internal view virtual returns (address) {
1335         return msg.sender;
1336     }
1337 
1338     /**
1339      * @dev Converts a uint256 to its ASCII string decimal representation.
1340      */
1341     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1342         assembly {
1343             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1344             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1345             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1346             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1347             let m := add(mload(0x40), 0xa0)
1348             // Update the free memory pointer to allocate.
1349             mstore(0x40, m)
1350             // Assign the `str` to the end.
1351             str := sub(m, 0x20)
1352             // Zeroize the slot after the string.
1353             mstore(str, 0)
1354 
1355             // Cache the end of the memory to calculate the length later.
1356             let end := str
1357 
1358             // We write the string from rightmost digit to leftmost digit.
1359             // The following is essentially a do-while loop that also handles the zero case.
1360             // prettier-ignore
1361             for { let temp := value } 1 {} {
1362                 str := sub(str, 1)
1363                 // Write the character to the pointer.
1364                 // The ASCII index of the '0' character is 48.
1365                 mstore8(str, add(48, mod(temp, 10)))
1366                 // Keep dividing `temp` until zero.
1367                 temp := div(temp, 10)
1368                 // prettier-ignore
1369                 if iszero(temp) { break }
1370             }
1371 
1372             let length := sub(end, str)
1373             // Move the pointer 32 bytes leftwards to make room for the length.
1374             str := sub(str, 0x20)
1375             // Store the length.
1376             mstore(str, length)
1377         }
1378     }
1379 }
1380 
1381 // File: @openzeppelin/contracts/utils/Base64.sol
1382 
1383 
1384 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
1385 
1386 pragma solidity ^0.8.0;
1387 
1388 /**
1389  * @dev Provides a set of functions to operate with Base64 strings.
1390  *
1391  * _Available since v4.5._
1392  */
1393 library Base64 {
1394     /**
1395      * @dev Base64 Encoding/Decoding Table
1396      */
1397     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1398 
1399     /**
1400      * @dev Converts a `bytes` to its Bytes64 `string` representation.
1401      */
1402     function encode(bytes memory data) internal pure returns (string memory) {
1403         /**
1404          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
1405          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
1406          */
1407         if (data.length == 0) return "";
1408 
1409         // Loads the table into memory
1410         string memory table = _TABLE;
1411 
1412         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
1413         // and split into 4 numbers of 6 bits.
1414         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
1415         // - `data.length + 2`  -> Round up
1416         // - `/ 3`              -> Number of 3-bytes chunks
1417         // - `4 *`              -> 4 characters for each chunk
1418         string memory result = new string(4 * ((data.length + 2) / 3));
1419 
1420         /// @solidity memory-safe-assembly
1421         assembly {
1422             // Prepare the lookup table (skip the first "length" byte)
1423             let tablePtr := add(table, 1)
1424 
1425             // Prepare result pointer, jump over length
1426             let resultPtr := add(result, 32)
1427 
1428             // Run over the input, 3 bytes at a time
1429             for {
1430                 let dataPtr := data
1431                 let endPtr := add(data, mload(data))
1432             } lt(dataPtr, endPtr) {
1433 
1434             } {
1435                 // Advance 3 bytes
1436                 dataPtr := add(dataPtr, 3)
1437                 let input := mload(dataPtr)
1438 
1439                 // To write each character, shift the 3 bytes (18 bits) chunk
1440                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
1441                 // and apply logical AND with 0x3F which is the number of
1442                 // the previous character in the ASCII table prior to the Base64 Table
1443                 // The result is then added to the table to get the character to write,
1444                 // and finally write it in the result pointer but with a left shift
1445                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
1446 
1447                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
1448                 resultPtr := add(resultPtr, 1) // Advance
1449 
1450                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
1451                 resultPtr := add(resultPtr, 1) // Advance
1452 
1453                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
1454                 resultPtr := add(resultPtr, 1) // Advance
1455 
1456                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
1457                 resultPtr := add(resultPtr, 1) // Advance
1458             }
1459 
1460             // When data `bytes` is not exactly 3 bytes long
1461             // it is padded with `=` characters at the end
1462             switch mod(mload(data), 3)
1463             case 1 {
1464                 mstore8(sub(resultPtr, 1), 0x3d)
1465                 mstore8(sub(resultPtr, 2), 0x3d)
1466             }
1467             case 2 {
1468                 mstore8(sub(resultPtr, 1), 0x3d)
1469             }
1470         }
1471 
1472         return result;
1473     }
1474 }
1475 
1476 // File: @openzeppelin/contracts/utils/Context.sol
1477 
1478 
1479 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1480 
1481 pragma solidity ^0.8.0;
1482 
1483 /**
1484  * @dev Provides information about the current execution context, including the
1485  * sender of the transaction and its data. While these are generally available
1486  * via msg.sender and msg.data, they should not be accessed in such a direct
1487  * manner, since when dealing with meta-transactions the account sending and
1488  * paying for execution may not be the actual sender (as far as an application
1489  * is concerned).
1490  *
1491  * This contract is only required for intermediate, library-like contracts.
1492  */
1493 abstract contract Context {
1494     function _msgSender() internal view virtual returns (address) {
1495         return msg.sender;
1496     }
1497 
1498     function _msgData() internal view virtual returns (bytes calldata) {
1499         return msg.data;
1500     }
1501 }
1502 
1503 // File: @openzeppelin/contracts/access/Ownable.sol
1504 
1505 
1506 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1507 
1508 pragma solidity ^0.8.0;
1509 
1510 
1511 /**
1512  * @dev Contract module which provides a basic access control mechanism, where
1513  * there is an account (an owner) that can be granted exclusive access to
1514  * specific functions.
1515  *
1516  * By default, the owner account will be the one that deploys the contract. This
1517  * can later be changed with {transferOwnership}.
1518  *
1519  * This module is used through inheritance. It will make available the modifier
1520  * `onlyOwner`, which can be applied to your functions to restrict their use to
1521  * the owner.
1522  */
1523 abstract contract Ownable is Context {
1524     address private _owner;
1525 
1526     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1527 
1528     /**
1529      * @dev Initializes the contract setting the deployer as the initial owner.
1530      */
1531     constructor() {
1532         _transferOwnership(_msgSender());
1533     }
1534 
1535     /**
1536      * @dev Throws if called by any account other than the owner.
1537      */
1538     modifier onlyOwner() {
1539         _checkOwner();
1540         _;
1541     }
1542 
1543     /**
1544      * @dev Returns the address of the current owner.
1545      */
1546     function owner() public view virtual returns (address) {
1547         return _owner;
1548     }
1549 
1550     /**
1551      * @dev Throws if the sender is not the owner.
1552      */
1553     function _checkOwner() internal view virtual {
1554         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1555     }
1556 
1557     /**
1558      * @dev Leaves the contract without owner. It will not be possible to call
1559      * `onlyOwner` functions anymore. Can only be called by the current owner.
1560      *
1561      * NOTE: Renouncing ownership will leave the contract without an owner,
1562      * thereby removing any functionality that is only available to the owner.
1563      */
1564     function renounceOwnership() public virtual onlyOwner {
1565         _transferOwnership(address(0));
1566     }
1567 
1568     /**
1569      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1570      * Can only be called by the current owner.
1571      */
1572     function transferOwnership(address newOwner) public virtual onlyOwner {
1573         require(newOwner != address(0), "Ownable: new owner is the zero address");
1574         _transferOwnership(newOwner);
1575     }
1576 
1577     /**
1578      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1579      * Internal function without access restriction.
1580      */
1581     function _transferOwnership(address newOwner) internal virtual {
1582         address oldOwner = _owner;
1583         _owner = newOwner;
1584         emit OwnershipTransferred(oldOwner, newOwner);
1585     }
1586 }
1587 
1588 // File: contracts/BoredKongYachtClub.sol
1589 
1590 
1591 
1592 pragma solidity ^0.8.14;
1593 
1594 
1595 
1596 
1597 
1598 contract BoredKongYachtCLub is ERC721A, Ownable {
1599     enum SaleStatus{ PAUSED, PRESALE, PUBLIC }
1600 
1601     uint public constant COLLECTION_SIZE = 10000;
1602     uint public constant FIRSTXFREE = 1;
1603     uint public constant TOKENS_PER_TRAN_LIMIT = 50;
1604     uint public constant TOKENS_PER_PERSON_PUB_LIMIT = 500;
1605     
1606     
1607     uint public MINT_PRICE = 0.003 ether;
1608     SaleStatus public saleStatus = SaleStatus.PAUSED;
1609     
1610     string private _baseURL;
1611     string public preRevealURL = "ipfs://bafybeiconpq4coprumlgzrmxyuuansj7u6wphljvgug3jdg6xwzsj4utiy/";
1612     mapping(address => uint) private _mintedCount;
1613     
1614 
1615     constructor() ERC721A("Bored Kong Yacht CLub", "BKYC"){}
1616     
1617     
1618     
1619     
1620     /// @notice Reveal metadata for all the tokens
1621     function reveal(string calldata url) external onlyOwner {
1622         _baseURL = url;
1623     }
1624     
1625      /// @notice Set Pre Reveal URL
1626     function setPreRevealUrl(string calldata url) external onlyOwner {
1627         preRevealURL = url;
1628     }
1629     
1630 
1631     /// @dev override base uri. It will be combined with token ID
1632     function _baseURI() internal view override returns (string memory) {
1633         return _baseURL;
1634     }
1635 
1636     function _startTokenId() internal pure override returns (uint256) {
1637         return 1;
1638     }
1639 
1640     /// @notice Update current sale stage
1641     function setSaleStatus(SaleStatus status) external onlyOwner {
1642         saleStatus = status;
1643     }
1644 
1645     /// @notice Update public mint price
1646     function setPublicMintPrice(uint price) external onlyOwner {
1647         MINT_PRICE = price;
1648     }
1649 
1650     /// @notice Withdraw contract balance
1651     function withdraw() external onlyOwner {
1652         uint balance = address(this).balance;
1653         require(balance > 0, "No balance");
1654         payable(owner()).transfer(balance);
1655     }
1656 
1657     /// @notice Allows owner to mint tokens to a specified address
1658     function airdrop(address to, uint count) external onlyOwner {
1659         require(_totalMinted() + count <= COLLECTION_SIZE, "Request exceeds collection size");
1660         _safeMint(to, count);
1661     }
1662 
1663     /// @notice Get token URI. In case of delayed reveal we give user the json of the placeholer metadata.
1664     /// @param tokenId token ID
1665     function tokenURI(uint tokenId) public view override returns (string memory) {
1666         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1667         string memory baseURI = _baseURI();
1668 
1669         return bytes(baseURI).length > 0 
1670             ? string(abi.encodePacked(baseURI, "/", _toString(tokenId), ".json")) 
1671             : preRevealURL;
1672     }
1673     
1674     function calcTotal(uint count) public view returns(uint) {
1675         require(saleStatus != SaleStatus.PAUSED, "BoredKongYachtCLub: Sales are off");
1676 
1677         
1678         require(msg.sender != address(0));
1679         uint totalMintedCount = _mintedCount[msg.sender];
1680 
1681         if(FIRSTXFREE > totalMintedCount) {
1682             uint freeLeft = FIRSTXFREE - totalMintedCount;
1683             if(count > freeLeft) {
1684                 // just pay the difference
1685                 count -= freeLeft;
1686             }
1687             else {
1688                 count = 0;
1689             }
1690         }
1691 
1692         
1693         uint price = MINT_PRICE;
1694 
1695         return count * price;
1696     }
1697     
1698     
1699     
1700     /// @notice Mints specified amount of tokens
1701     /// @param count How many tokens to mint
1702     function mint(uint count) external payable {
1703         require(saleStatus != SaleStatus.PAUSED, "BoredKongYachtCLub: Sales are off");
1704         require(_totalMinted() + count <= COLLECTION_SIZE, "BoredKongYachtCLub: Number of requested tokens will exceed collection size");
1705         require(count <= TOKENS_PER_TRAN_LIMIT, "BoredKongYachtCLub: Number of requested tokens exceeds allowance (50)");
1706         require(_mintedCount[msg.sender] + count <= TOKENS_PER_PERSON_PUB_LIMIT, "BoredKongYachtCLub: Number of requested tokens exceeds allowance (500)");
1707         require(msg.value >= calcTotal(count), "BoredKongYachtClub: Ether value sent is not sufficient");
1708         _mintedCount[msg.sender] += count;
1709         _safeMint(msg.sender, count);
1710     }
1711 }