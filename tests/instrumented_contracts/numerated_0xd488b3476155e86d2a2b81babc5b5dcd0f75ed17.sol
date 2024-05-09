1 // SPDX-License-Identifier: MIT
2 // Developed by GT
3 // File: erc721a/contracts/IERC721A.sol
4 
5 
6 // ERC721A Contracts v4.2.3
7 // Creator: Chiru Labs
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
1381 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1382 
1383 
1384 // ERC721A Contracts v4.2.3
1385 // Creator: Chiru Labs
1386 
1387 pragma solidity ^0.8.4;
1388 
1389 
1390 /**
1391  * @dev Interface of ERC721AQueryable.
1392  */
1393 interface IERC721AQueryable is IERC721A {
1394     /**
1395      * Invalid query range (`start` >= `stop`).
1396      */
1397     error InvalidQueryRange();
1398 
1399     /**
1400      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1401      *
1402      * If the `tokenId` is out of bounds:
1403      *
1404      * - `addr = address(0)`
1405      * - `startTimestamp = 0`
1406      * - `burned = false`
1407      * - `extraData = 0`
1408      *
1409      * If the `tokenId` is burned:
1410      *
1411      * - `addr = <Address of owner before token was burned>`
1412      * - `startTimestamp = <Timestamp when token was burned>`
1413      * - `burned = true`
1414      * - `extraData = <Extra data when token was burned>`
1415      *
1416      * Otherwise:
1417      *
1418      * - `addr = <Address of owner>`
1419      * - `startTimestamp = <Timestamp of start of ownership>`
1420      * - `burned = false`
1421      * - `extraData = <Extra data at start of ownership>`
1422      */
1423     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1424 
1425     /**
1426      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1427      * See {ERC721AQueryable-explicitOwnershipOf}
1428      */
1429     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1430 
1431     /**
1432      * @dev Returns an array of token IDs owned by `owner`,
1433      * in the range [`start`, `stop`)
1434      * (i.e. `start <= tokenId < stop`).
1435      *
1436      * This function allows for tokens to be queried if the collection
1437      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1438      *
1439      * Requirements:
1440      *
1441      * - `start < stop`
1442      */
1443     function tokensOfOwnerIn(
1444         address owner,
1445         uint256 start,
1446         uint256 stop
1447     ) external view returns (uint256[] memory);
1448 
1449     /**
1450      * @dev Returns an array of token IDs owned by `owner`.
1451      *
1452      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1453      * It is meant to be called off-chain.
1454      *
1455      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1456      * multiple smaller scans if the collection is large enough to cause
1457      * an out-of-gas error (10K collections should be fine).
1458      */
1459     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1460 }
1461 
1462 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1463 
1464 
1465 // ERC721A Contracts v4.2.3
1466 // Creator: Chiru Labs
1467 
1468 pragma solidity ^0.8.4;
1469 
1470 
1471 
1472 /**
1473  * @title ERC721AQueryable.
1474  *
1475  * @dev ERC721A subclass with convenience query functions.
1476  */
1477 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1478     /**
1479      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1480      *
1481      * If the `tokenId` is out of bounds:
1482      *
1483      * - `addr = address(0)`
1484      * - `startTimestamp = 0`
1485      * - `burned = false`
1486      * - `extraData = 0`
1487      *
1488      * If the `tokenId` is burned:
1489      *
1490      * - `addr = <Address of owner before token was burned>`
1491      * - `startTimestamp = <Timestamp when token was burned>`
1492      * - `burned = true`
1493      * - `extraData = <Extra data when token was burned>`
1494      *
1495      * Otherwise:
1496      *
1497      * - `addr = <Address of owner>`
1498      * - `startTimestamp = <Timestamp of start of ownership>`
1499      * - `burned = false`
1500      * - `extraData = <Extra data at start of ownership>`
1501      */
1502     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1503         TokenOwnership memory ownership;
1504         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1505             return ownership;
1506         }
1507         ownership = _ownershipAt(tokenId);
1508         if (ownership.burned) {
1509             return ownership;
1510         }
1511         return _ownershipOf(tokenId);
1512     }
1513 
1514     /**
1515      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1516      * See {ERC721AQueryable-explicitOwnershipOf}
1517      */
1518     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1519         external
1520         view
1521         virtual
1522         override
1523         returns (TokenOwnership[] memory)
1524     {
1525         unchecked {
1526             uint256 tokenIdsLength = tokenIds.length;
1527             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1528             for (uint256 i; i != tokenIdsLength; ++i) {
1529                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1530             }
1531             return ownerships;
1532         }
1533     }
1534 
1535     /**
1536      * @dev Returns an array of token IDs owned by `owner`,
1537      * in the range [`start`, `stop`)
1538      * (i.e. `start <= tokenId < stop`).
1539      *
1540      * This function allows for tokens to be queried if the collection
1541      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1542      *
1543      * Requirements:
1544      *
1545      * - `start < stop`
1546      */
1547     function tokensOfOwnerIn(
1548         address owner,
1549         uint256 start,
1550         uint256 stop
1551     ) external view virtual override returns (uint256[] memory) {
1552         unchecked {
1553             if (start >= stop) revert InvalidQueryRange();
1554             uint256 tokenIdsIdx;
1555             uint256 stopLimit = _nextTokenId();
1556             // Set `start = max(start, _startTokenId())`.
1557             if (start < _startTokenId()) {
1558                 start = _startTokenId();
1559             }
1560             // Set `stop = min(stop, stopLimit)`.
1561             if (stop > stopLimit) {
1562                 stop = stopLimit;
1563             }
1564             uint256 tokenIdsMaxLength = balanceOf(owner);
1565             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1566             // to cater for cases where `balanceOf(owner)` is too big.
1567             if (start < stop) {
1568                 uint256 rangeLength = stop - start;
1569                 if (rangeLength < tokenIdsMaxLength) {
1570                     tokenIdsMaxLength = rangeLength;
1571                 }
1572             } else {
1573                 tokenIdsMaxLength = 0;
1574             }
1575             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1576             if (tokenIdsMaxLength == 0) {
1577                 return tokenIds;
1578             }
1579             // We need to call `explicitOwnershipOf(start)`,
1580             // because the slot at `start` may not be initialized.
1581             TokenOwnership memory ownership = explicitOwnershipOf(start);
1582             address currOwnershipAddr;
1583             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1584             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1585             if (!ownership.burned) {
1586                 currOwnershipAddr = ownership.addr;
1587             }
1588             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1589                 ownership = _ownershipAt(i);
1590                 if (ownership.burned) {
1591                     continue;
1592                 }
1593                 if (ownership.addr != address(0)) {
1594                     currOwnershipAddr = ownership.addr;
1595                 }
1596                 if (currOwnershipAddr == owner) {
1597                     tokenIds[tokenIdsIdx++] = i;
1598                 }
1599             }
1600             // Downsize the array to fit.
1601             assembly {
1602                 mstore(tokenIds, tokenIdsIdx)
1603             }
1604             return tokenIds;
1605         }
1606     }
1607 
1608     /**
1609      * @dev Returns an array of token IDs owned by `owner`.
1610      *
1611      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1612      * It is meant to be called off-chain.
1613      *
1614      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1615      * multiple smaller scans if the collection is large enough to cause
1616      * an out-of-gas error (10K collections should be fine).
1617      */
1618     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1619         unchecked {
1620             uint256 tokenIdsIdx;
1621             address currOwnershipAddr;
1622             uint256 tokenIdsLength = balanceOf(owner);
1623             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1624             TokenOwnership memory ownership;
1625             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1626                 ownership = _ownershipAt(i);
1627                 if (ownership.burned) {
1628                     continue;
1629                 }
1630                 if (ownership.addr != address(0)) {
1631                     currOwnershipAddr = ownership.addr;
1632                 }
1633                 if (currOwnershipAddr == owner) {
1634                     tokenIds[tokenIdsIdx++] = i;
1635                 }
1636             }
1637             return tokenIds;
1638         }
1639     }
1640 }
1641 
1642 // File: @openzeppelin/contracts/utils/math/Math.sol
1643 
1644 
1645 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1646 
1647 pragma solidity ^0.8.0;
1648 
1649 /**
1650  * @dev Standard math utilities missing in the Solidity language.
1651  */
1652 library Math {
1653     enum Rounding {
1654         Down, // Toward negative infinity
1655         Up, // Toward infinity
1656         Zero // Toward zero
1657     }
1658 
1659     /**
1660      * @dev Returns the largest of two numbers.
1661      */
1662     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1663         return a > b ? a : b;
1664     }
1665 
1666     /**
1667      * @dev Returns the smallest of two numbers.
1668      */
1669     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1670         return a < b ? a : b;
1671     }
1672 
1673     /**
1674      * @dev Returns the average of two numbers. The result is rounded towards
1675      * zero.
1676      */
1677     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1678         // (a + b) / 2 can overflow.
1679         return (a & b) + (a ^ b) / 2;
1680     }
1681 
1682     /**
1683      * @dev Returns the ceiling of the division of two numbers.
1684      *
1685      * This differs from standard division with `/` in that it rounds up instead
1686      * of rounding down.
1687      */
1688     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1689         // (a + b - 1) / b can overflow on addition, so we distribute.
1690         return a == 0 ? 0 : (a - 1) / b + 1;
1691     }
1692 
1693     /**
1694      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1695      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1696      * with further edits by Uniswap Labs also under MIT license.
1697      */
1698     function mulDiv(
1699         uint256 x,
1700         uint256 y,
1701         uint256 denominator
1702     ) internal pure returns (uint256 result) {
1703         unchecked {
1704             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1705             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1706             // variables such that product = prod1 * 2^256 + prod0.
1707             uint256 prod0; // Least significant 256 bits of the product
1708             uint256 prod1; // Most significant 256 bits of the product
1709             assembly {
1710                 let mm := mulmod(x, y, not(0))
1711                 prod0 := mul(x, y)
1712                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1713             }
1714 
1715             // Handle non-overflow cases, 256 by 256 division.
1716             if (prod1 == 0) {
1717                 return prod0 / denominator;
1718             }
1719 
1720             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1721             require(denominator > prod1);
1722 
1723             ///////////////////////////////////////////////
1724             // 512 by 256 division.
1725             ///////////////////////////////////////////////
1726 
1727             // Make division exact by subtracting the remainder from [prod1 prod0].
1728             uint256 remainder;
1729             assembly {
1730                 // Compute remainder using mulmod.
1731                 remainder := mulmod(x, y, denominator)
1732 
1733                 // Subtract 256 bit number from 512 bit number.
1734                 prod1 := sub(prod1, gt(remainder, prod0))
1735                 prod0 := sub(prod0, remainder)
1736             }
1737 
1738             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1739             // See https://cs.stackexchange.com/q/138556/92363.
1740 
1741             // Does not overflow because the denominator cannot be zero at this stage in the function.
1742             uint256 twos = denominator & (~denominator + 1);
1743             assembly {
1744                 // Divide denominator by twos.
1745                 denominator := div(denominator, twos)
1746 
1747                 // Divide [prod1 prod0] by twos.
1748                 prod0 := div(prod0, twos)
1749 
1750                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1751                 twos := add(div(sub(0, twos), twos), 1)
1752             }
1753 
1754             // Shift in bits from prod1 into prod0.
1755             prod0 |= prod1 * twos;
1756 
1757             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1758             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1759             // four bits. That is, denominator * inv = 1 mod 2^4.
1760             uint256 inverse = (3 * denominator) ^ 2;
1761 
1762             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1763             // in modular arithmetic, doubling the correct bits in each step.
1764             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1765             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1766             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1767             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1768             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1769             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1770 
1771             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1772             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1773             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1774             // is no longer required.
1775             result = prod0 * inverse;
1776             return result;
1777         }
1778     }
1779 
1780     /**
1781      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1782      */
1783     function mulDiv(
1784         uint256 x,
1785         uint256 y,
1786         uint256 denominator,
1787         Rounding rounding
1788     ) internal pure returns (uint256) {
1789         uint256 result = mulDiv(x, y, denominator);
1790         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1791             result += 1;
1792         }
1793         return result;
1794     }
1795 
1796     /**
1797      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1798      *
1799      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1800      */
1801     function sqrt(uint256 a) internal pure returns (uint256) {
1802         if (a == 0) {
1803             return 0;
1804         }
1805 
1806         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1807         //
1808         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1809         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1810         //
1811         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1812         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1813         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1814         //
1815         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1816         uint256 result = 1 << (log2(a) >> 1);
1817 
1818         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1819         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1820         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1821         // into the expected uint128 result.
1822         unchecked {
1823             result = (result + a / result) >> 1;
1824             result = (result + a / result) >> 1;
1825             result = (result + a / result) >> 1;
1826             result = (result + a / result) >> 1;
1827             result = (result + a / result) >> 1;
1828             result = (result + a / result) >> 1;
1829             result = (result + a / result) >> 1;
1830             return min(result, a / result);
1831         }
1832     }
1833 
1834     /**
1835      * @notice Calculates sqrt(a), following the selected rounding direction.
1836      */
1837     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1838         unchecked {
1839             uint256 result = sqrt(a);
1840             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1841         }
1842     }
1843 
1844     /**
1845      * @dev Return the log in base 2, rounded down, of a positive value.
1846      * Returns 0 if given 0.
1847      */
1848     function log2(uint256 value) internal pure returns (uint256) {
1849         uint256 result = 0;
1850         unchecked {
1851             if (value >> 128 > 0) {
1852                 value >>= 128;
1853                 result += 128;
1854             }
1855             if (value >> 64 > 0) {
1856                 value >>= 64;
1857                 result += 64;
1858             }
1859             if (value >> 32 > 0) {
1860                 value >>= 32;
1861                 result += 32;
1862             }
1863             if (value >> 16 > 0) {
1864                 value >>= 16;
1865                 result += 16;
1866             }
1867             if (value >> 8 > 0) {
1868                 value >>= 8;
1869                 result += 8;
1870             }
1871             if (value >> 4 > 0) {
1872                 value >>= 4;
1873                 result += 4;
1874             }
1875             if (value >> 2 > 0) {
1876                 value >>= 2;
1877                 result += 2;
1878             }
1879             if (value >> 1 > 0) {
1880                 result += 1;
1881             }
1882         }
1883         return result;
1884     }
1885 
1886     /**
1887      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1888      * Returns 0 if given 0.
1889      */
1890     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1891         unchecked {
1892             uint256 result = log2(value);
1893             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1894         }
1895     }
1896 
1897     /**
1898      * @dev Return the log in base 10, rounded down, of a positive value.
1899      * Returns 0 if given 0.
1900      */
1901     function log10(uint256 value) internal pure returns (uint256) {
1902         uint256 result = 0;
1903         unchecked {
1904             if (value >= 10**64) {
1905                 value /= 10**64;
1906                 result += 64;
1907             }
1908             if (value >= 10**32) {
1909                 value /= 10**32;
1910                 result += 32;
1911             }
1912             if (value >= 10**16) {
1913                 value /= 10**16;
1914                 result += 16;
1915             }
1916             if (value >= 10**8) {
1917                 value /= 10**8;
1918                 result += 8;
1919             }
1920             if (value >= 10**4) {
1921                 value /= 10**4;
1922                 result += 4;
1923             }
1924             if (value >= 10**2) {
1925                 value /= 10**2;
1926                 result += 2;
1927             }
1928             if (value >= 10**1) {
1929                 result += 1;
1930             }
1931         }
1932         return result;
1933     }
1934 
1935     /**
1936      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1937      * Returns 0 if given 0.
1938      */
1939     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1940         unchecked {
1941             uint256 result = log10(value);
1942             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1943         }
1944     }
1945 
1946     /**
1947      * @dev Return the log in base 256, rounded down, of a positive value.
1948      * Returns 0 if given 0.
1949      *
1950      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1951      */
1952     function log256(uint256 value) internal pure returns (uint256) {
1953         uint256 result = 0;
1954         unchecked {
1955             if (value >> 128 > 0) {
1956                 value >>= 128;
1957                 result += 16;
1958             }
1959             if (value >> 64 > 0) {
1960                 value >>= 64;
1961                 result += 8;
1962             }
1963             if (value >> 32 > 0) {
1964                 value >>= 32;
1965                 result += 4;
1966             }
1967             if (value >> 16 > 0) {
1968                 value >>= 16;
1969                 result += 2;
1970             }
1971             if (value >> 8 > 0) {
1972                 result += 1;
1973             }
1974         }
1975         return result;
1976     }
1977 
1978     /**
1979      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1980      * Returns 0 if given 0.
1981      */
1982     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1983         unchecked {
1984             uint256 result = log256(value);
1985             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1986         }
1987     }
1988 }
1989 
1990 // File: @openzeppelin/contracts/utils/Strings.sol
1991 
1992 
1993 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1994 
1995 pragma solidity ^0.8.0;
1996 
1997 
1998 /**
1999  * @dev String operations.
2000  */
2001 library Strings {
2002     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2003     uint8 private constant _ADDRESS_LENGTH = 20;
2004 
2005     /**
2006      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2007      */
2008     function toString(uint256 value) internal pure returns (string memory) {
2009         unchecked {
2010             uint256 length = Math.log10(value) + 1;
2011             string memory buffer = new string(length);
2012             uint256 ptr;
2013             /// @solidity memory-safe-assembly
2014             assembly {
2015                 ptr := add(buffer, add(32, length))
2016             }
2017             while (true) {
2018                 ptr--;
2019                 /// @solidity memory-safe-assembly
2020                 assembly {
2021                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2022                 }
2023                 value /= 10;
2024                 if (value == 0) break;
2025             }
2026             return buffer;
2027         }
2028     }
2029 
2030     /**
2031      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2032      */
2033     function toHexString(uint256 value) internal pure returns (string memory) {
2034         unchecked {
2035             return toHexString(value, Math.log256(value) + 1);
2036         }
2037     }
2038 
2039     /**
2040      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2041      */
2042     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2043         bytes memory buffer = new bytes(2 * length + 2);
2044         buffer[0] = "0";
2045         buffer[1] = "x";
2046         for (uint256 i = 2 * length + 1; i > 1; --i) {
2047             buffer[i] = _SYMBOLS[value & 0xf];
2048             value >>= 4;
2049         }
2050         require(value == 0, "Strings: hex length insufficient");
2051         return string(buffer);
2052     }
2053 
2054     /**
2055      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2056      */
2057     function toHexString(address addr) internal pure returns (string memory) {
2058         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2059     }
2060 }
2061 
2062 // File: @openzeppelin/contracts/utils/Context.sol
2063 
2064 
2065 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2066 
2067 pragma solidity ^0.8.0;
2068 
2069 /**
2070  * @dev Provides information about the current execution context, including the
2071  * sender of the transaction and its data. While these are generally available
2072  * via msg.sender and msg.data, they should not be accessed in such a direct
2073  * manner, since when dealing with meta-transactions the account sending and
2074  * paying for execution may not be the actual sender (as far as an application
2075  * is concerned).
2076  *
2077  * This contract is only required for intermediate, library-like contracts.
2078  */
2079 abstract contract Context {
2080     function _msgSender() internal view virtual returns (address) {
2081         return msg.sender;
2082     }
2083 
2084     function _msgData() internal view virtual returns (bytes calldata) {
2085         return msg.data;
2086     }
2087 }
2088 
2089 // File: @openzeppelin/contracts/access/Ownable.sol
2090 
2091 
2092 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2093 
2094 pragma solidity ^0.8.0;
2095 
2096 
2097 /**
2098  * @dev Contract module which provides a basic access control mechanism, where
2099  * there is an account (an owner) that can be granted exclusive access to
2100  * specific functions.
2101  *
2102  * By default, the owner account will be the one that deploys the contract. This
2103  * can later be changed with {transferOwnership}.
2104  *
2105  * This module is used through inheritance. It will make available the modifier
2106  * `onlyOwner`, which can be applied to your functions to restrict their use to
2107  * the owner.
2108  */
2109 abstract contract Ownable is Context {
2110     address private _owner;
2111 
2112     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2113 
2114     /**
2115      * @dev Initializes the contract setting the deployer as the initial owner.
2116      */
2117     constructor() {
2118         _transferOwnership(_msgSender());
2119     }
2120 
2121     /**
2122      * @dev Throws if called by any account other than the owner.
2123      */
2124     modifier onlyOwner() {
2125         _checkOwner();
2126         _;
2127     }
2128 
2129     /**
2130      * @dev Returns the address of the current owner.
2131      */
2132     function owner() public view virtual returns (address) {
2133         return _owner;
2134     }
2135 
2136     /**
2137      * @dev Throws if the sender is not the owner.
2138      */
2139     function _checkOwner() internal view virtual {
2140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2141     }
2142 
2143     /**
2144      * @dev Leaves the contract without owner. It will not be possible to call
2145      * `onlyOwner` functions anymore. Can only be called by the current owner.
2146      *
2147      * NOTE: Renouncing ownership will leave the contract without an owner,
2148      * thereby removing any functionality that is only available to the owner.
2149      */
2150     function renounceOwnership() public virtual onlyOwner {
2151         _transferOwnership(address(0));
2152     }
2153 
2154     /**
2155      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2156      * Can only be called by the current owner.
2157      */
2158     function transferOwnership(address newOwner) public virtual onlyOwner {
2159         require(newOwner != address(0), "Ownable: new owner is the zero address");
2160         _transferOwnership(newOwner);
2161     }
2162 
2163     /**
2164      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2165      * Internal function without access restriction.
2166      */
2167     function _transferOwnership(address newOwner) internal virtual {
2168         address oldOwner = _owner;
2169         _owner = newOwner;
2170         emit OwnershipTransferred(oldOwner, newOwner);
2171     }
2172 }
2173 
2174 // File: SNAKES.sol
2175 
2176 
2177 pragma solidity ^0.8.4;
2178 
2179 
2180 
2181 
2182 
2183 
2184 contract SNAKES is ERC721AQueryable, Ownable {
2185   using Strings for uint256;
2186 
2187   uint256 public constant TOTAL_MAX_SUPPLY = 3300;
2188   uint256 public totalFreeMints = 800;
2189   uint256 public maxFreeMintPerWallet = 1;
2190   uint256 public maxPublicMintPerWallet = 15;
2191   uint256 public publicTokenPrice = .005 ether;
2192   string _contractURI;
2193 
2194   bool public saleStarted = false;
2195   uint256 public freeMintCount;
2196 
2197   mapping(address => uint256) public freeMintClaimed;
2198   
2199 
2200   string private _baseTokenURI;
2201 
2202   constructor() ERC721A("GAMETIME: SNAKES", "SNAKES") {}
2203 
2204   modifier callerIsUser() {
2205     require(tx.origin == msg.sender, 'SNAKES: The caller is another contract');
2206     _;
2207   }
2208 
2209   modifier underMaxSupply(uint256 _quantity) {
2210     require(
2211       _totalMinted() + _quantity <= TOTAL_MAX_SUPPLY,
2212       "SNAKES: Over max supply"
2213     );
2214     _;
2215   }
2216 
2217   function mint(uint256 _quantity) external payable callerIsUser underMaxSupply(_quantity) {
2218     require(balanceOf(msg.sender) < maxPublicMintPerWallet, "GAMETIME: Mint limit exceeded");
2219     require(saleStarted, "GAMETIME: Sale has not started");
2220     if (_totalMinted() < (TOTAL_MAX_SUPPLY)) {
2221       if (freeMintCount >= totalFreeMints) {
2222         require(msg.value >= _quantity * publicTokenPrice, "SNAKES: More ETH required");
2223         _mint(msg.sender, _quantity);
2224       } else if (freeMintClaimed[msg.sender] < maxFreeMintPerWallet) {
2225         uint256 _mintableFreeQuantity = maxFreeMintPerWallet - freeMintClaimed[msg.sender];
2226         if (_quantity <= _mintableFreeQuantity) {
2227           freeMintCount += _quantity;
2228           freeMintClaimed[msg.sender] += _quantity;
2229         } else {
2230           freeMintCount += _mintableFreeQuantity;
2231           freeMintClaimed[msg.sender] += _mintableFreeQuantity;
2232           require(
2233             msg.value >= (_quantity - _mintableFreeQuantity) * publicTokenPrice,
2234             "SNAKES: Not enough ETH"
2235           );
2236         }
2237         _mint(msg.sender, _quantity);
2238       } else {
2239         require(msg.value >= (_quantity * publicTokenPrice), "SNAKES: Not enough ETH");
2240         _mint(msg.sender, _quantity);
2241       }
2242     }
2243   }
2244 
2245   function _baseURI() internal view virtual override returns (string memory) {
2246     return _baseTokenURI;
2247   }
2248 
2249   function tokenURI(uint256 tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2250     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2251 
2252     string memory baseURI = _baseURI();
2253     return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2254   }
2255 
2256   function numberMinted(address owner) public view returns (uint256) {
2257     return _numberMinted(owner);
2258   }
2259 
2260   function _startTokenId() internal view virtual override returns (uint256) {
2261     return 1;
2262   }
2263 
2264   function ownerMint(uint256 _numberToMint) external onlyOwner underMaxSupply(_numberToMint) {
2265     _mint(msg.sender, _numberToMint);
2266   }
2267 
2268   function ownerMintToAddress(address _recipient, uint256 _numberToMint)
2269     external
2270     onlyOwner
2271     underMaxSupply(_numberToMint)
2272   {
2273     _mint(_recipient, _numberToMint);
2274   }
2275 
2276   function setFreeMintCount(uint256 _count) external onlyOwner {
2277     totalFreeMints = _count;
2278   }
2279 
2280   function setMaxFreeMintPerWallet(uint256 _count) external onlyOwner {
2281     maxFreeMintPerWallet = _count;
2282   }
2283 
2284   function setMaxPublicMintPerWallet(uint256 _count) external onlyOwner {
2285     maxPublicMintPerWallet = _count;
2286   }
2287 
2288   function setBaseURI(string calldata baseURI) external onlyOwner {
2289     _baseTokenURI = baseURI;
2290   }
2291 
2292   // Storefront metadata
2293   // https://docs.opensea.io/docs/contract-level-metadata
2294   function contractURI() public view returns (string memory) {
2295     return _contractURI;
2296   }
2297 
2298   function setContractURI(string memory _URI) external onlyOwner {
2299     _contractURI = _URI;
2300   }
2301 
2302   function withdrawFunds() external onlyOwner {
2303     (bool success, ) = msg.sender.call{ value: address(this).balance }("");
2304     require(success, "SNAKES: Transfer failed");
2305   }
2306 
2307   function withdrawFundsToAddress(address _address, uint256 amount) external onlyOwner {
2308     (bool success, ) = _address.call{ value: amount }("");
2309     require(success, "SNAKES: Transfer failed");
2310   }
2311 
2312   function flipSaleStarted() external onlyOwner {
2313     saleStarted = !saleStarted;
2314   }
2315 }