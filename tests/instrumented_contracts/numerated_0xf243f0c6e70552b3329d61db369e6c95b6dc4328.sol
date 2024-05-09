1 // Sources flattened with hardhat v2.12.4 https://hardhat.org
2 
3 // File erc721a/contracts/IERC721A.sol@v4.2.3
4 
5 // SPDX-License-Identifier: MIT
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
288 
289 // File erc721a/contracts/ERC721A.sol@v4.2.3
290 
291 // ERC721A Contracts v4.2.3
292 // Creator: Chiru Labs
293 
294 pragma solidity ^0.8.4;
295 
296 /**
297  * @dev Interface of ERC721 token receiver.
298  */
299 interface ERC721A__IERC721Receiver {
300     function onERC721Received(
301         address operator,
302         address from,
303         uint256 tokenId,
304         bytes calldata data
305     ) external returns (bytes4);
306 }
307 
308 /**
309  * @title ERC721A
310  *
311  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
312  * Non-Fungible Token Standard, including the Metadata extension.
313  * Optimized for lower gas during batch mints.
314  *
315  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
316  * starting from `_startTokenId()`.
317  *
318  * Assumptions:
319  *
320  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
321  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
322  */
323 contract ERC721A is IERC721A {
324     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
325     struct TokenApprovalRef {
326         address value;
327     }
328 
329     // =============================================================
330     //                           CONSTANTS
331     // =============================================================
332 
333     // Mask of an entry in packed address data.
334     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
335 
336     // The bit position of `numberMinted` in packed address data.
337     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
338 
339     // The bit position of `numberBurned` in packed address data.
340     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
341 
342     // The bit position of `aux` in packed address data.
343     uint256 private constant _BITPOS_AUX = 192;
344 
345     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
346     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
347 
348     // The bit position of `startTimestamp` in packed ownership.
349     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
350 
351     // The bit mask of the `burned` bit in packed ownership.
352     uint256 private constant _BITMASK_BURNED = 1 << 224;
353 
354     // The bit position of the `nextInitialized` bit in packed ownership.
355     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
356 
357     // The bit mask of the `nextInitialized` bit in packed ownership.
358     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
359 
360     // The bit position of `extraData` in packed ownership.
361     uint256 private constant _BITPOS_EXTRA_DATA = 232;
362 
363     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
364     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
365 
366     // The mask of the lower 160 bits for addresses.
367     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
368 
369     // The maximum `quantity` that can be minted with {_mintERC2309}.
370     // This limit is to prevent overflows on the address data entries.
371     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
372     // is required to cause an overflow, which is unrealistic.
373     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
374 
375     // The `Transfer` event signature is given by:
376     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
377     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
378         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
379 
380     // =============================================================
381     //                            STORAGE
382     // =============================================================
383 
384     // The next token ID to be minted.
385     uint256 private _currentIndex;
386 
387     // The number of tokens burned.
388     uint256 private _burnCounter;
389 
390     // Token name
391     string private _name;
392 
393     // Token symbol
394     string private _symbol;
395 
396     // Mapping from token ID to ownership details
397     // An empty struct value does not necessarily mean the token is unowned.
398     // See {_packedOwnershipOf} implementation for details.
399     //
400     // Bits Layout:
401     // - [0..159]   `addr`
402     // - [160..223] `startTimestamp`
403     // - [224]      `burned`
404     // - [225]      `nextInitialized`
405     // - [232..255] `extraData`
406     mapping(uint256 => uint256) private _packedOwnerships;
407 
408     // Mapping owner address to address data.
409     //
410     // Bits Layout:
411     // - [0..63]    `balance`
412     // - [64..127]  `numberMinted`
413     // - [128..191] `numberBurned`
414     // - [192..255] `aux`
415     mapping(address => uint256) private _packedAddressData;
416 
417     // Mapping from token ID to approved address.
418     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
419 
420     // Mapping from owner to operator approvals
421     mapping(address => mapping(address => bool)) private _operatorApprovals;
422 
423     // =============================================================
424     //                          CONSTRUCTOR
425     // =============================================================
426 
427     constructor(string memory name_, string memory symbol_) {
428         _name = name_;
429         _symbol = symbol_;
430         _currentIndex = _startTokenId();
431     }
432 
433     // =============================================================
434     //                   TOKEN COUNTING OPERATIONS
435     // =============================================================
436 
437     /**
438      * @dev Returns the starting token ID.
439      * To change the starting token ID, please override this function.
440      */
441     function _startTokenId() internal view virtual returns (uint256) {
442         return 0;
443     }
444 
445     /**
446      * @dev Returns the next token ID to be minted.
447      */
448     function _nextTokenId() internal view virtual returns (uint256) {
449         return _currentIndex;
450     }
451 
452     /**
453      * @dev Returns the total number of tokens in existence.
454      * Burned tokens will reduce the count.
455      * To get the total number of tokens minted, please see {_totalMinted}.
456      */
457     function totalSupply() public view virtual override returns (uint256) {
458         // Counter underflow is impossible as _burnCounter cannot be incremented
459         // more than `_currentIndex - _startTokenId()` times.
460         unchecked {
461             return _currentIndex - _burnCounter - _startTokenId();
462         }
463     }
464 
465     /**
466      * @dev Returns the total amount of tokens minted in the contract.
467      */
468     function _totalMinted() internal view virtual returns (uint256) {
469         // Counter underflow is impossible as `_currentIndex` does not decrement,
470         // and it is initialized to `_startTokenId()`.
471         unchecked {
472             return _currentIndex - _startTokenId();
473         }
474     }
475 
476     /**
477      * @dev Returns the total number of tokens burned.
478      */
479     function _totalBurned() internal view virtual returns (uint256) {
480         return _burnCounter;
481     }
482 
483     // =============================================================
484     //                    ADDRESS DATA OPERATIONS
485     // =============================================================
486 
487     /**
488      * @dev Returns the number of tokens in `owner`'s account.
489      */
490     function balanceOf(address owner) public view virtual override returns (uint256) {
491         if (owner == address(0)) revert BalanceQueryForZeroAddress();
492         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
493     }
494 
495     /**
496      * Returns the number of tokens minted by `owner`.
497      */
498     function _numberMinted(address owner) internal view returns (uint256) {
499         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
500     }
501 
502     /**
503      * Returns the number of tokens burned by or on behalf of `owner`.
504      */
505     function _numberBurned(address owner) internal view returns (uint256) {
506         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
507     }
508 
509     /**
510      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
511      */
512     function _getAux(address owner) internal view returns (uint64) {
513         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
514     }
515 
516     /**
517      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
518      * If there are multiple variables, please pack them into a uint64.
519      */
520     function _setAux(address owner, uint64 aux) internal virtual {
521         uint256 packed = _packedAddressData[owner];
522         uint256 auxCasted;
523         // Cast `aux` with assembly to avoid redundant masking.
524         assembly {
525             auxCasted := aux
526         }
527         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
528         _packedAddressData[owner] = packed;
529     }
530 
531     // =============================================================
532     //                            IERC165
533     // =============================================================
534 
535     /**
536      * @dev Returns true if this contract implements the interface defined by
537      * `interfaceId`. See the corresponding
538      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
539      * to learn more about how these ids are created.
540      *
541      * This function call must use less than 30000 gas.
542      */
543     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544         // The interface IDs are constants representing the first 4 bytes
545         // of the XOR of all function selectors in the interface.
546         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
547         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
548         return
549             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
550             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
551             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
552     }
553 
554     // =============================================================
555     //                        IERC721Metadata
556     // =============================================================
557 
558     /**
559      * @dev Returns the token collection name.
560      */
561     function name() public view virtual override returns (string memory) {
562         return _name;
563     }
564 
565     /**
566      * @dev Returns the token collection symbol.
567      */
568     function symbol() public view virtual override returns (string memory) {
569         return _symbol;
570     }
571 
572     /**
573      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
574      */
575     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
576         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
577 
578         string memory baseURI = _baseURI();
579         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
580     }
581 
582     /**
583      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
584      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
585      * by default, it can be overridden in child contracts.
586      */
587     function _baseURI() internal view virtual returns (string memory) {
588         return '';
589     }
590 
591     // =============================================================
592     //                     OWNERSHIPS OPERATIONS
593     // =============================================================
594 
595     /**
596      * @dev Returns the owner of the `tokenId` token.
597      *
598      * Requirements:
599      *
600      * - `tokenId` must exist.
601      */
602     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
603         return address(uint160(_packedOwnershipOf(tokenId)));
604     }
605 
606     /**
607      * @dev Gas spent here starts off proportional to the maximum mint batch size.
608      * It gradually moves to O(1) as tokens get transferred around over time.
609      */
610     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
611         return _unpackedOwnership(_packedOwnershipOf(tokenId));
612     }
613 
614     /**
615      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
616      */
617     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
618         return _unpackedOwnership(_packedOwnerships[index]);
619     }
620 
621     /**
622      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
623      */
624     function _initializeOwnershipAt(uint256 index) internal virtual {
625         if (_packedOwnerships[index] == 0) {
626             _packedOwnerships[index] = _packedOwnershipOf(index);
627         }
628     }
629 
630     /**
631      * Returns the packed ownership data of `tokenId`.
632      */
633     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
634         uint256 curr = tokenId;
635 
636         unchecked {
637             if (_startTokenId() <= curr)
638                 if (curr < _currentIndex) {
639                     uint256 packed = _packedOwnerships[curr];
640                     // If not burned.
641                     if (packed & _BITMASK_BURNED == 0) {
642                         // Invariant:
643                         // There will always be an initialized ownership slot
644                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
645                         // before an unintialized ownership slot
646                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
647                         // Hence, `curr` will not underflow.
648                         //
649                         // We can directly compare the packed value.
650                         // If the address is zero, packed will be zero.
651                         while (packed == 0) {
652                             packed = _packedOwnerships[--curr];
653                         }
654                         return packed;
655                     }
656                 }
657         }
658         revert OwnerQueryForNonexistentToken();
659     }
660 
661     /**
662      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
663      */
664     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
665         ownership.addr = address(uint160(packed));
666         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
667         ownership.burned = packed & _BITMASK_BURNED != 0;
668         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
669     }
670 
671     /**
672      * @dev Packs ownership data into a single uint256.
673      */
674     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
675         assembly {
676             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
677             owner := and(owner, _BITMASK_ADDRESS)
678             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
679             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
680         }
681     }
682 
683     /**
684      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
685      */
686     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
687         // For branchless setting of the `nextInitialized` flag.
688         assembly {
689             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
690             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
691         }
692     }
693 
694     // =============================================================
695     //                      APPROVAL OPERATIONS
696     // =============================================================
697 
698     /**
699      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
700      * The approval is cleared when the token is transferred.
701      *
702      * Only a single account can be approved at a time, so approving the
703      * zero address clears previous approvals.
704      *
705      * Requirements:
706      *
707      * - The caller must own the token or be an approved operator.
708      * - `tokenId` must exist.
709      *
710      * Emits an {Approval} event.
711      */
712     function approve(address to, uint256 tokenId) public payable virtual override {
713         address owner = ownerOf(tokenId);
714 
715         if (_msgSenderERC721A() != owner)
716             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
717                 revert ApprovalCallerNotOwnerNorApproved();
718             }
719 
720         _tokenApprovals[tokenId].value = to;
721         emit Approval(owner, to, tokenId);
722     }
723 
724     /**
725      * @dev Returns the account approved for `tokenId` token.
726      *
727      * Requirements:
728      *
729      * - `tokenId` must exist.
730      */
731     function getApproved(uint256 tokenId) public view virtual override returns (address) {
732         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
733 
734         return _tokenApprovals[tokenId].value;
735     }
736 
737     /**
738      * @dev Approve or remove `operator` as an operator for the caller.
739      * Operators can call {transferFrom} or {safeTransferFrom}
740      * for any token owned by the caller.
741      *
742      * Requirements:
743      *
744      * - The `operator` cannot be the caller.
745      *
746      * Emits an {ApprovalForAll} event.
747      */
748     function setApprovalForAll(address operator, bool approved) public virtual override {
749         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
750         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
751     }
752 
753     /**
754      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
755      *
756      * See {setApprovalForAll}.
757      */
758     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
759         return _operatorApprovals[owner][operator];
760     }
761 
762     /**
763      * @dev Returns whether `tokenId` exists.
764      *
765      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
766      *
767      * Tokens start existing when they are minted. See {_mint}.
768      */
769     function _exists(uint256 tokenId) internal view virtual returns (bool) {
770         return
771             _startTokenId() <= tokenId &&
772             tokenId < _currentIndex && // If within bounds,
773             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
774     }
775 
776     /**
777      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
778      */
779     function _isSenderApprovedOrOwner(
780         address approvedAddress,
781         address owner,
782         address msgSender
783     ) private pure returns (bool result) {
784         assembly {
785             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
786             owner := and(owner, _BITMASK_ADDRESS)
787             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
788             msgSender := and(msgSender, _BITMASK_ADDRESS)
789             // `msgSender == owner || msgSender == approvedAddress`.
790             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
791         }
792     }
793 
794     /**
795      * @dev Returns the storage slot and value for the approved address of `tokenId`.
796      */
797     function _getApprovedSlotAndAddress(uint256 tokenId)
798         private
799         view
800         returns (uint256 approvedAddressSlot, address approvedAddress)
801     {
802         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
803         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
804         assembly {
805             approvedAddressSlot := tokenApproval.slot
806             approvedAddress := sload(approvedAddressSlot)
807         }
808     }
809 
810     // =============================================================
811     //                      TRANSFER OPERATIONS
812     // =============================================================
813 
814     /**
815      * @dev Transfers `tokenId` from `from` to `to`.
816      *
817      * Requirements:
818      *
819      * - `from` cannot be the zero address.
820      * - `to` cannot be the zero address.
821      * - `tokenId` token must be owned by `from`.
822      * - If the caller is not `from`, it must be approved to move this token
823      * by either {approve} or {setApprovalForAll}.
824      *
825      * Emits a {Transfer} event.
826      */
827     function transferFrom(
828         address from,
829         address to,
830         uint256 tokenId
831     ) public payable virtual override {
832         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
833 
834         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
835 
836         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
837 
838         // The nested ifs save around 20+ gas over a compound boolean condition.
839         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
840             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
841 
842         if (to == address(0)) revert TransferToZeroAddress();
843 
844         _beforeTokenTransfers(from, to, tokenId, 1);
845 
846         // Clear approvals from the previous owner.
847         assembly {
848             if approvedAddress {
849                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
850                 sstore(approvedAddressSlot, 0)
851             }
852         }
853 
854         // Underflow of the sender's balance is impossible because we check for
855         // ownership above and the recipient's balance can't realistically overflow.
856         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
857         unchecked {
858             // We can directly increment and decrement the balances.
859             --_packedAddressData[from]; // Updates: `balance -= 1`.
860             ++_packedAddressData[to]; // Updates: `balance += 1`.
861 
862             // Updates:
863             // - `address` to the next owner.
864             // - `startTimestamp` to the timestamp of transfering.
865             // - `burned` to `false`.
866             // - `nextInitialized` to `true`.
867             _packedOwnerships[tokenId] = _packOwnershipData(
868                 to,
869                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
870             );
871 
872             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
873             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
874                 uint256 nextTokenId = tokenId + 1;
875                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
876                 if (_packedOwnerships[nextTokenId] == 0) {
877                     // If the next slot is within bounds.
878                     if (nextTokenId != _currentIndex) {
879                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
880                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
881                     }
882                 }
883             }
884         }
885 
886         emit Transfer(from, to, tokenId);
887         _afterTokenTransfers(from, to, tokenId, 1);
888     }
889 
890     /**
891      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
892      */
893     function safeTransferFrom(
894         address from,
895         address to,
896         uint256 tokenId
897     ) public payable virtual override {
898         safeTransferFrom(from, to, tokenId, '');
899     }
900 
901     /**
902      * @dev Safely transfers `tokenId` token from `from` to `to`.
903      *
904      * Requirements:
905      *
906      * - `from` cannot be the zero address.
907      * - `to` cannot be the zero address.
908      * - `tokenId` token must exist and be owned by `from`.
909      * - If the caller is not `from`, it must be approved to move this token
910      * by either {approve} or {setApprovalForAll}.
911      * - If `to` refers to a smart contract, it must implement
912      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
913      *
914      * Emits a {Transfer} event.
915      */
916     function safeTransferFrom(
917         address from,
918         address to,
919         uint256 tokenId,
920         bytes memory _data
921     ) public payable virtual override {
922         transferFrom(from, to, tokenId);
923         if (to.code.length != 0)
924             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
925                 revert TransferToNonERC721ReceiverImplementer();
926             }
927     }
928 
929     /**
930      * @dev Hook that is called before a set of serially-ordered token IDs
931      * are about to be transferred. This includes minting.
932      * And also called before burning one token.
933      *
934      * `startTokenId` - the first token ID to be transferred.
935      * `quantity` - the amount to be transferred.
936      *
937      * Calling conditions:
938      *
939      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
940      * transferred to `to`.
941      * - When `from` is zero, `tokenId` will be minted for `to`.
942      * - When `to` is zero, `tokenId` will be burned by `from`.
943      * - `from` and `to` are never both zero.
944      */
945     function _beforeTokenTransfers(
946         address from,
947         address to,
948         uint256 startTokenId,
949         uint256 quantity
950     ) internal virtual {}
951 
952     /**
953      * @dev Hook that is called after a set of serially-ordered token IDs
954      * have been transferred. This includes minting.
955      * And also called after one token has been burned.
956      *
957      * `startTokenId` - the first token ID to be transferred.
958      * `quantity` - the amount to be transferred.
959      *
960      * Calling conditions:
961      *
962      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
963      * transferred to `to`.
964      * - When `from` is zero, `tokenId` has been minted for `to`.
965      * - When `to` is zero, `tokenId` has been burned by `from`.
966      * - `from` and `to` are never both zero.
967      */
968     function _afterTokenTransfers(
969         address from,
970         address to,
971         uint256 startTokenId,
972         uint256 quantity
973     ) internal virtual {}
974 
975     /**
976      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
977      *
978      * `from` - Previous owner of the given token ID.
979      * `to` - Target address that will receive the token.
980      * `tokenId` - Token ID to be transferred.
981      * `_data` - Optional data to send along with the call.
982      *
983      * Returns whether the call correctly returned the expected magic value.
984      */
985     function _checkContractOnERC721Received(
986         address from,
987         address to,
988         uint256 tokenId,
989         bytes memory _data
990     ) private returns (bool) {
991         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
992             bytes4 retval
993         ) {
994             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
995         } catch (bytes memory reason) {
996             if (reason.length == 0) {
997                 revert TransferToNonERC721ReceiverImplementer();
998             } else {
999                 assembly {
1000                     revert(add(32, reason), mload(reason))
1001                 }
1002             }
1003         }
1004     }
1005 
1006     // =============================================================
1007     //                        MINT OPERATIONS
1008     // =============================================================
1009 
1010     /**
1011      * @dev Mints `quantity` tokens and transfers them to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - `to` cannot be the zero address.
1016      * - `quantity` must be greater than 0.
1017      *
1018      * Emits a {Transfer} event for each mint.
1019      */
1020     function _mint(address to, uint256 quantity) internal virtual {
1021         uint256 startTokenId = _currentIndex;
1022         if (quantity == 0) revert MintZeroQuantity();
1023 
1024         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1025 
1026         // Overflows are incredibly unrealistic.
1027         // `balance` and `numberMinted` have a maximum limit of 2**64.
1028         // `tokenId` has a maximum limit of 2**256.
1029         unchecked {
1030             // Updates:
1031             // - `balance += quantity`.
1032             // - `numberMinted += quantity`.
1033             //
1034             // We can directly add to the `balance` and `numberMinted`.
1035             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1036 
1037             // Updates:
1038             // - `address` to the owner.
1039             // - `startTimestamp` to the timestamp of minting.
1040             // - `burned` to `false`.
1041             // - `nextInitialized` to `quantity == 1`.
1042             _packedOwnerships[startTokenId] = _packOwnershipData(
1043                 to,
1044                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1045             );
1046 
1047             uint256 toMasked;
1048             uint256 end = startTokenId + quantity;
1049 
1050             // Use assembly to loop and emit the `Transfer` event for gas savings.
1051             // The duplicated `log4` removes an extra check and reduces stack juggling.
1052             // The assembly, together with the surrounding Solidity code, have been
1053             // delicately arranged to nudge the compiler into producing optimized opcodes.
1054             assembly {
1055                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1056                 toMasked := and(to, _BITMASK_ADDRESS)
1057                 // Emit the `Transfer` event.
1058                 log4(
1059                     0, // Start of data (0, since no data).
1060                     0, // End of data (0, since no data).
1061                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1062                     0, // `address(0)`.
1063                     toMasked, // `to`.
1064                     startTokenId // `tokenId`.
1065                 )
1066 
1067                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1068                 // that overflows uint256 will make the loop run out of gas.
1069                 // The compiler will optimize the `iszero` away for performance.
1070                 for {
1071                     let tokenId := add(startTokenId, 1)
1072                 } iszero(eq(tokenId, end)) {
1073                     tokenId := add(tokenId, 1)
1074                 } {
1075                     // Emit the `Transfer` event. Similar to above.
1076                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1077                 }
1078             }
1079             if (toMasked == 0) revert MintToZeroAddress();
1080 
1081             _currentIndex = end;
1082         }
1083         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1084     }
1085 
1086     /**
1087      * @dev Mints `quantity` tokens and transfers them to `to`.
1088      *
1089      * This function is intended for efficient minting only during contract creation.
1090      *
1091      * It emits only one {ConsecutiveTransfer} as defined in
1092      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1093      * instead of a sequence of {Transfer} event(s).
1094      *
1095      * Calling this function outside of contract creation WILL make your contract
1096      * non-compliant with the ERC721 standard.
1097      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1098      * {ConsecutiveTransfer} event is only permissible during contract creation.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `quantity` must be greater than 0.
1104      *
1105      * Emits a {ConsecutiveTransfer} event.
1106      */
1107     function _mintERC2309(address to, uint256 quantity) internal virtual {
1108         uint256 startTokenId = _currentIndex;
1109         if (to == address(0)) revert MintToZeroAddress();
1110         if (quantity == 0) revert MintZeroQuantity();
1111         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1112 
1113         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1114 
1115         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1116         unchecked {
1117             // Updates:
1118             // - `balance += quantity`.
1119             // - `numberMinted += quantity`.
1120             //
1121             // We can directly add to the `balance` and `numberMinted`.
1122             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1123 
1124             // Updates:
1125             // - `address` to the owner.
1126             // - `startTimestamp` to the timestamp of minting.
1127             // - `burned` to `false`.
1128             // - `nextInitialized` to `quantity == 1`.
1129             _packedOwnerships[startTokenId] = _packOwnershipData(
1130                 to,
1131                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1132             );
1133 
1134             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1135 
1136             _currentIndex = startTokenId + quantity;
1137         }
1138         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1139     }
1140 
1141     /**
1142      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1143      *
1144      * Requirements:
1145      *
1146      * - If `to` refers to a smart contract, it must implement
1147      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1148      * - `quantity` must be greater than 0.
1149      *
1150      * See {_mint}.
1151      *
1152      * Emits a {Transfer} event for each mint.
1153      */
1154     function _safeMint(
1155         address to,
1156         uint256 quantity,
1157         bytes memory _data
1158     ) internal virtual {
1159         _mint(to, quantity);
1160 
1161         unchecked {
1162             if (to.code.length != 0) {
1163                 uint256 end = _currentIndex;
1164                 uint256 index = end - quantity;
1165                 do {
1166                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1167                         revert TransferToNonERC721ReceiverImplementer();
1168                     }
1169                 } while (index < end);
1170                 // Reentrancy protection.
1171                 if (_currentIndex != end) revert();
1172             }
1173         }
1174     }
1175 
1176     /**
1177      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1178      */
1179     function _safeMint(address to, uint256 quantity) internal virtual {
1180         _safeMint(to, quantity, '');
1181     }
1182 
1183     // =============================================================
1184     //                        BURN OPERATIONS
1185     // =============================================================
1186 
1187     /**
1188      * @dev Equivalent to `_burn(tokenId, false)`.
1189      */
1190     function _burn(uint256 tokenId) internal virtual {
1191         _burn(tokenId, false);
1192     }
1193 
1194     /**
1195      * @dev Destroys `tokenId`.
1196      * The approval is cleared when the token is burned.
1197      *
1198      * Requirements:
1199      *
1200      * - `tokenId` must exist.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1205         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1206 
1207         address from = address(uint160(prevOwnershipPacked));
1208 
1209         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1210 
1211         if (approvalCheck) {
1212             // The nested ifs save around 20+ gas over a compound boolean condition.
1213             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1214                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1215         }
1216 
1217         _beforeTokenTransfers(from, address(0), tokenId, 1);
1218 
1219         // Clear approvals from the previous owner.
1220         assembly {
1221             if approvedAddress {
1222                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1223                 sstore(approvedAddressSlot, 0)
1224             }
1225         }
1226 
1227         // Underflow of the sender's balance is impossible because we check for
1228         // ownership above and the recipient's balance can't realistically overflow.
1229         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1230         unchecked {
1231             // Updates:
1232             // - `balance -= 1`.
1233             // - `numberBurned += 1`.
1234             //
1235             // We can directly decrement the balance, and increment the number burned.
1236             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1237             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1238 
1239             // Updates:
1240             // - `address` to the last owner.
1241             // - `startTimestamp` to the timestamp of burning.
1242             // - `burned` to `true`.
1243             // - `nextInitialized` to `true`.
1244             _packedOwnerships[tokenId] = _packOwnershipData(
1245                 from,
1246                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1247             );
1248 
1249             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1250             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1251                 uint256 nextTokenId = tokenId + 1;
1252                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1253                 if (_packedOwnerships[nextTokenId] == 0) {
1254                     // If the next slot is within bounds.
1255                     if (nextTokenId != _currentIndex) {
1256                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1257                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1258                     }
1259                 }
1260             }
1261         }
1262 
1263         emit Transfer(from, address(0), tokenId);
1264         _afterTokenTransfers(from, address(0), tokenId, 1);
1265 
1266         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1267         unchecked {
1268             _burnCounter++;
1269         }
1270     }
1271 
1272     // =============================================================
1273     //                     EXTRA DATA OPERATIONS
1274     // =============================================================
1275 
1276     /**
1277      * @dev Directly sets the extra data for the ownership data `index`.
1278      */
1279     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1280         uint256 packed = _packedOwnerships[index];
1281         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1282         uint256 extraDataCasted;
1283         // Cast `extraData` with assembly to avoid redundant masking.
1284         assembly {
1285             extraDataCasted := extraData
1286         }
1287         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1288         _packedOwnerships[index] = packed;
1289     }
1290 
1291     /**
1292      * @dev Called during each token transfer to set the 24bit `extraData` field.
1293      * Intended to be overridden by the cosumer contract.
1294      *
1295      * `previousExtraData` - the value of `extraData` before transfer.
1296      *
1297      * Calling conditions:
1298      *
1299      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1300      * transferred to `to`.
1301      * - When `from` is zero, `tokenId` will be minted for `to`.
1302      * - When `to` is zero, `tokenId` will be burned by `from`.
1303      * - `from` and `to` are never both zero.
1304      */
1305     function _extraData(
1306         address from,
1307         address to,
1308         uint24 previousExtraData
1309     ) internal view virtual returns (uint24) {}
1310 
1311     /**
1312      * @dev Returns the next extra data for the packed ownership data.
1313      * The returned result is shifted into position.
1314      */
1315     function _nextExtraData(
1316         address from,
1317         address to,
1318         uint256 prevOwnershipPacked
1319     ) private view returns (uint256) {
1320         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1321         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1322     }
1323 
1324     // =============================================================
1325     //                       OTHER OPERATIONS
1326     // =============================================================
1327 
1328     /**
1329      * @dev Returns the message sender (defaults to `msg.sender`).
1330      *
1331      * If you are writing GSN compatible contracts, you need to override this function.
1332      */
1333     function _msgSenderERC721A() internal view virtual returns (address) {
1334         return msg.sender;
1335     }
1336 
1337     /**
1338      * @dev Converts a uint256 to its ASCII string decimal representation.
1339      */
1340     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1341         assembly {
1342             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1343             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1344             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1345             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1346             let m := add(mload(0x40), 0xa0)
1347             // Update the free memory pointer to allocate.
1348             mstore(0x40, m)
1349             // Assign the `str` to the end.
1350             str := sub(m, 0x20)
1351             // Zeroize the slot after the string.
1352             mstore(str, 0)
1353 
1354             // Cache the end of the memory to calculate the length later.
1355             let end := str
1356 
1357             // We write the string from rightmost digit to leftmost digit.
1358             // The following is essentially a do-while loop that also handles the zero case.
1359             // prettier-ignore
1360             for { let temp := value } 1 {} {
1361                 str := sub(str, 1)
1362                 // Write the character to the pointer.
1363                 // The ASCII index of the '0' character is 48.
1364                 mstore8(str, add(48, mod(temp, 10)))
1365                 // Keep dividing `temp` until zero.
1366                 temp := div(temp, 10)
1367                 // prettier-ignore
1368                 if iszero(temp) { break }
1369             }
1370 
1371             let length := sub(end, str)
1372             // Move the pointer 32 bytes leftwards to make room for the length.
1373             str := sub(str, 0x20)
1374             // Store the length.
1375             mstore(str, length)
1376         }
1377     }
1378 }
1379 
1380 
1381 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
1382 
1383 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1384 
1385 pragma solidity ^0.8.0;
1386 
1387 /**
1388  * @dev Provides information about the current execution context, including the
1389  * sender of the transaction and its data. While these are generally available
1390  * via msg.sender and msg.data, they should not be accessed in such a direct
1391  * manner, since when dealing with meta-transactions the account sending and
1392  * paying for execution may not be the actual sender (as far as an application
1393  * is concerned).
1394  *
1395  * This contract is only required for intermediate, library-like contracts.
1396  */
1397 abstract contract Context {
1398     function _msgSender() internal view virtual returns (address) {
1399         return msg.sender;
1400     }
1401 
1402     function _msgData() internal view virtual returns (bytes calldata) {
1403         return msg.data;
1404     }
1405 }
1406 
1407 
1408 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
1409 
1410 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1411 
1412 pragma solidity ^0.8.0;
1413 
1414 /**
1415  * @dev Contract module which provides a basic access control mechanism, where
1416  * there is an account (an owner) that can be granted exclusive access to
1417  * specific functions.
1418  *
1419  * By default, the owner account will be the one that deploys the contract. This
1420  * can later be changed with {transferOwnership}.
1421  *
1422  * This module is used through inheritance. It will make available the modifier
1423  * `onlyOwner`, which can be applied to your functions to restrict their use to
1424  * the owner.
1425  */
1426 abstract contract Ownable is Context {
1427     address private _owner;
1428 
1429     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1430 
1431     /**
1432      * @dev Initializes the contract setting the deployer as the initial owner.
1433      */
1434     constructor() {
1435         _transferOwnership(_msgSender());
1436     }
1437 
1438     /**
1439      * @dev Throws if called by any account other than the owner.
1440      */
1441     modifier onlyOwner() {
1442         _checkOwner();
1443         _;
1444     }
1445 
1446     /**
1447      * @dev Returns the address of the current owner.
1448      */
1449     function owner() public view virtual returns (address) {
1450         return _owner;
1451     }
1452 
1453     /**
1454      * @dev Throws if the sender is not the owner.
1455      */
1456     function _checkOwner() internal view virtual {
1457         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1458     }
1459 
1460     /**
1461      * @dev Leaves the contract without owner. It will not be possible to call
1462      * `onlyOwner` functions anymore. Can only be called by the current owner.
1463      *
1464      * NOTE: Renouncing ownership will leave the contract without an owner,
1465      * thereby removing any functionality that is only available to the owner.
1466      */
1467     function renounceOwnership() public virtual onlyOwner {
1468         _transferOwnership(address(0));
1469     }
1470 
1471     /**
1472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1473      * Can only be called by the current owner.
1474      */
1475     function transferOwnership(address newOwner) public virtual onlyOwner {
1476         require(newOwner != address(0), "Ownable: new owner is the zero address");
1477         _transferOwnership(newOwner);
1478     }
1479 
1480     /**
1481      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1482      * Internal function without access restriction.
1483      */
1484     function _transferOwnership(address newOwner) internal virtual {
1485         address oldOwner = _owner;
1486         _owner = newOwner;
1487         emit OwnershipTransferred(oldOwner, newOwner);
1488     }
1489 }
1490 
1491 
1492 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
1493 
1494 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1495 
1496 pragma solidity ^0.8.0;
1497 
1498 /**
1499  * @dev Standard math utilities missing in the Solidity language.
1500  */
1501 library Math {
1502     enum Rounding {
1503         Down, // Toward negative infinity
1504         Up, // Toward infinity
1505         Zero // Toward zero
1506     }
1507 
1508     /**
1509      * @dev Returns the largest of two numbers.
1510      */
1511     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1512         return a > b ? a : b;
1513     }
1514 
1515     /**
1516      * @dev Returns the smallest of two numbers.
1517      */
1518     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1519         return a < b ? a : b;
1520     }
1521 
1522     /**
1523      * @dev Returns the average of two numbers. The result is rounded towards
1524      * zero.
1525      */
1526     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1527         // (a + b) / 2 can overflow.
1528         return (a & b) + (a ^ b) / 2;
1529     }
1530 
1531     /**
1532      * @dev Returns the ceiling of the division of two numbers.
1533      *
1534      * This differs from standard division with `/` in that it rounds up instead
1535      * of rounding down.
1536      */
1537     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1538         // (a + b - 1) / b can overflow on addition, so we distribute.
1539         return a == 0 ? 0 : (a - 1) / b + 1;
1540     }
1541 
1542     /**
1543      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1544      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1545      * with further edits by Uniswap Labs also under MIT license.
1546      */
1547     function mulDiv(
1548         uint256 x,
1549         uint256 y,
1550         uint256 denominator
1551     ) internal pure returns (uint256 result) {
1552         unchecked {
1553             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1554             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1555             // variables such that product = prod1 * 2^256 + prod0.
1556             uint256 prod0; // Least significant 256 bits of the product
1557             uint256 prod1; // Most significant 256 bits of the product
1558             assembly {
1559                 let mm := mulmod(x, y, not(0))
1560                 prod0 := mul(x, y)
1561                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1562             }
1563 
1564             // Handle non-overflow cases, 256 by 256 division.
1565             if (prod1 == 0) {
1566                 return prod0 / denominator;
1567             }
1568 
1569             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1570             require(denominator > prod1);
1571 
1572             ///////////////////////////////////////////////
1573             // 512 by 256 division.
1574             ///////////////////////////////////////////////
1575 
1576             // Make division exact by subtracting the remainder from [prod1 prod0].
1577             uint256 remainder;
1578             assembly {
1579                 // Compute remainder using mulmod.
1580                 remainder := mulmod(x, y, denominator)
1581 
1582                 // Subtract 256 bit number from 512 bit number.
1583                 prod1 := sub(prod1, gt(remainder, prod0))
1584                 prod0 := sub(prod0, remainder)
1585             }
1586 
1587             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1588             // See https://cs.stackexchange.com/q/138556/92363.
1589 
1590             // Does not overflow because the denominator cannot be zero at this stage in the function.
1591             uint256 twos = denominator & (~denominator + 1);
1592             assembly {
1593                 // Divide denominator by twos.
1594                 denominator := div(denominator, twos)
1595 
1596                 // Divide [prod1 prod0] by twos.
1597                 prod0 := div(prod0, twos)
1598 
1599                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1600                 twos := add(div(sub(0, twos), twos), 1)
1601             }
1602 
1603             // Shift in bits from prod1 into prod0.
1604             prod0 |= prod1 * twos;
1605 
1606             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1607             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1608             // four bits. That is, denominator * inv = 1 mod 2^4.
1609             uint256 inverse = (3 * denominator) ^ 2;
1610 
1611             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1612             // in modular arithmetic, doubling the correct bits in each step.
1613             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1614             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1615             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1616             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1617             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1618             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1619 
1620             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1621             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1622             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1623             // is no longer required.
1624             result = prod0 * inverse;
1625             return result;
1626         }
1627     }
1628 
1629     /**
1630      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1631      */
1632     function mulDiv(
1633         uint256 x,
1634         uint256 y,
1635         uint256 denominator,
1636         Rounding rounding
1637     ) internal pure returns (uint256) {
1638         uint256 result = mulDiv(x, y, denominator);
1639         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1640             result += 1;
1641         }
1642         return result;
1643     }
1644 
1645     /**
1646      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1647      *
1648      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1649      */
1650     function sqrt(uint256 a) internal pure returns (uint256) {
1651         if (a == 0) {
1652             return 0;
1653         }
1654 
1655         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1656         //
1657         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1658         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1659         //
1660         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1661         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1662         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1663         //
1664         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1665         uint256 result = 1 << (log2(a) >> 1);
1666 
1667         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1668         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1669         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1670         // into the expected uint128 result.
1671         unchecked {
1672             result = (result + a / result) >> 1;
1673             result = (result + a / result) >> 1;
1674             result = (result + a / result) >> 1;
1675             result = (result + a / result) >> 1;
1676             result = (result + a / result) >> 1;
1677             result = (result + a / result) >> 1;
1678             result = (result + a / result) >> 1;
1679             return min(result, a / result);
1680         }
1681     }
1682 
1683     /**
1684      * @notice Calculates sqrt(a), following the selected rounding direction.
1685      */
1686     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1687         unchecked {
1688             uint256 result = sqrt(a);
1689             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1690         }
1691     }
1692 
1693     /**
1694      * @dev Return the log in base 2, rounded down, of a positive value.
1695      * Returns 0 if given 0.
1696      */
1697     function log2(uint256 value) internal pure returns (uint256) {
1698         uint256 result = 0;
1699         unchecked {
1700             if (value >> 128 > 0) {
1701                 value >>= 128;
1702                 result += 128;
1703             }
1704             if (value >> 64 > 0) {
1705                 value >>= 64;
1706                 result += 64;
1707             }
1708             if (value >> 32 > 0) {
1709                 value >>= 32;
1710                 result += 32;
1711             }
1712             if (value >> 16 > 0) {
1713                 value >>= 16;
1714                 result += 16;
1715             }
1716             if (value >> 8 > 0) {
1717                 value >>= 8;
1718                 result += 8;
1719             }
1720             if (value >> 4 > 0) {
1721                 value >>= 4;
1722                 result += 4;
1723             }
1724             if (value >> 2 > 0) {
1725                 value >>= 2;
1726                 result += 2;
1727             }
1728             if (value >> 1 > 0) {
1729                 result += 1;
1730             }
1731         }
1732         return result;
1733     }
1734 
1735     /**
1736      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1737      * Returns 0 if given 0.
1738      */
1739     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1740         unchecked {
1741             uint256 result = log2(value);
1742             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1743         }
1744     }
1745 
1746     /**
1747      * @dev Return the log in base 10, rounded down, of a positive value.
1748      * Returns 0 if given 0.
1749      */
1750     function log10(uint256 value) internal pure returns (uint256) {
1751         uint256 result = 0;
1752         unchecked {
1753             if (value >= 10**64) {
1754                 value /= 10**64;
1755                 result += 64;
1756             }
1757             if (value >= 10**32) {
1758                 value /= 10**32;
1759                 result += 32;
1760             }
1761             if (value >= 10**16) {
1762                 value /= 10**16;
1763                 result += 16;
1764             }
1765             if (value >= 10**8) {
1766                 value /= 10**8;
1767                 result += 8;
1768             }
1769             if (value >= 10**4) {
1770                 value /= 10**4;
1771                 result += 4;
1772             }
1773             if (value >= 10**2) {
1774                 value /= 10**2;
1775                 result += 2;
1776             }
1777             if (value >= 10**1) {
1778                 result += 1;
1779             }
1780         }
1781         return result;
1782     }
1783 
1784     /**
1785      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1786      * Returns 0 if given 0.
1787      */
1788     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1789         unchecked {
1790             uint256 result = log10(value);
1791             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1792         }
1793     }
1794 
1795     /**
1796      * @dev Return the log in base 256, rounded down, of a positive value.
1797      * Returns 0 if given 0.
1798      *
1799      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1800      */
1801     function log256(uint256 value) internal pure returns (uint256) {
1802         uint256 result = 0;
1803         unchecked {
1804             if (value >> 128 > 0) {
1805                 value >>= 128;
1806                 result += 16;
1807             }
1808             if (value >> 64 > 0) {
1809                 value >>= 64;
1810                 result += 8;
1811             }
1812             if (value >> 32 > 0) {
1813                 value >>= 32;
1814                 result += 4;
1815             }
1816             if (value >> 16 > 0) {
1817                 value >>= 16;
1818                 result += 2;
1819             }
1820             if (value >> 8 > 0) {
1821                 result += 1;
1822             }
1823         }
1824         return result;
1825     }
1826 
1827     /**
1828      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1829      * Returns 0 if given 0.
1830      */
1831     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1832         unchecked {
1833             uint256 result = log256(value);
1834             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1835         }
1836     }
1837 }
1838 
1839 
1840 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
1841 
1842 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1843 
1844 pragma solidity ^0.8.0;
1845 
1846 /**
1847  * @dev String operations.
1848  */
1849 library Strings {
1850     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1851     uint8 private constant _ADDRESS_LENGTH = 20;
1852 
1853     /**
1854      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1855      */
1856     function toString(uint256 value) internal pure returns (string memory) {
1857         unchecked {
1858             uint256 length = Math.log10(value) + 1;
1859             string memory buffer = new string(length);
1860             uint256 ptr;
1861             /// @solidity memory-safe-assembly
1862             assembly {
1863                 ptr := add(buffer, add(32, length))
1864             }
1865             while (true) {
1866                 ptr--;
1867                 /// @solidity memory-safe-assembly
1868                 assembly {
1869                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1870                 }
1871                 value /= 10;
1872                 if (value == 0) break;
1873             }
1874             return buffer;
1875         }
1876     }
1877 
1878     /**
1879      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1880      */
1881     function toHexString(uint256 value) internal pure returns (string memory) {
1882         unchecked {
1883             return toHexString(value, Math.log256(value) + 1);
1884         }
1885     }
1886 
1887     /**
1888      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1889      */
1890     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1891         bytes memory buffer = new bytes(2 * length + 2);
1892         buffer[0] = "0";
1893         buffer[1] = "x";
1894         for (uint256 i = 2 * length + 1; i > 1; --i) {
1895             buffer[i] = _SYMBOLS[value & 0xf];
1896             value >>= 4;
1897         }
1898         require(value == 0, "Strings: hex length insufficient");
1899         return string(buffer);
1900     }
1901 
1902     /**
1903      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1904      */
1905     function toHexString(address addr) internal pure returns (string memory) {
1906         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1907     }
1908 }
1909 
1910 
1911 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.8.0
1912 
1913 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1914 
1915 pragma solidity ^0.8.0;
1916 
1917 /**
1918  * @dev These functions deal with verification of Merkle Tree proofs.
1919  *
1920  * The tree and the proofs can be generated using our
1921  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1922  * You will find a quickstart guide in the readme.
1923  *
1924  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1925  * hashing, or use a hash function other than keccak256 for hashing leaves.
1926  * This is because the concatenation of a sorted pair of internal nodes in
1927  * the merkle tree could be reinterpreted as a leaf value.
1928  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1929  * against this attack out of the box.
1930  */
1931 library MerkleProof {
1932     /**
1933      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1934      * defined by `root`. For this, a `proof` must be provided, containing
1935      * sibling hashes on the branch from the leaf to the root of the tree. Each
1936      * pair of leaves and each pair of pre-images are assumed to be sorted.
1937      */
1938     function verify(
1939         bytes32[] memory proof,
1940         bytes32 root,
1941         bytes32 leaf
1942     ) internal pure returns (bool) {
1943         return processProof(proof, leaf) == root;
1944     }
1945 
1946     /**
1947      * @dev Calldata version of {verify}
1948      *
1949      * _Available since v4.7._
1950      */
1951     function verifyCalldata(
1952         bytes32[] calldata proof,
1953         bytes32 root,
1954         bytes32 leaf
1955     ) internal pure returns (bool) {
1956         return processProofCalldata(proof, leaf) == root;
1957     }
1958 
1959     /**
1960      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1961      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1962      * hash matches the root of the tree. When processing the proof, the pairs
1963      * of leafs & pre-images are assumed to be sorted.
1964      *
1965      * _Available since v4.4._
1966      */
1967     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1968         bytes32 computedHash = leaf;
1969         for (uint256 i = 0; i < proof.length; i++) {
1970             computedHash = _hashPair(computedHash, proof[i]);
1971         }
1972         return computedHash;
1973     }
1974 
1975     /**
1976      * @dev Calldata version of {processProof}
1977      *
1978      * _Available since v4.7._
1979      */
1980     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1981         bytes32 computedHash = leaf;
1982         for (uint256 i = 0; i < proof.length; i++) {
1983             computedHash = _hashPair(computedHash, proof[i]);
1984         }
1985         return computedHash;
1986     }
1987 
1988     /**
1989      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1990      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1991      *
1992      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1993      *
1994      * _Available since v4.7._
1995      */
1996     function multiProofVerify(
1997         bytes32[] memory proof,
1998         bool[] memory proofFlags,
1999         bytes32 root,
2000         bytes32[] memory leaves
2001     ) internal pure returns (bool) {
2002         return processMultiProof(proof, proofFlags, leaves) == root;
2003     }
2004 
2005     /**
2006      * @dev Calldata version of {multiProofVerify}
2007      *
2008      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2009      *
2010      * _Available since v4.7._
2011      */
2012     function multiProofVerifyCalldata(
2013         bytes32[] calldata proof,
2014         bool[] calldata proofFlags,
2015         bytes32 root,
2016         bytes32[] memory leaves
2017     ) internal pure returns (bool) {
2018         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
2019     }
2020 
2021     /**
2022      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
2023      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
2024      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
2025      * respectively.
2026      *
2027      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
2028      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
2029      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
2030      *
2031      * _Available since v4.7._
2032      */
2033     function processMultiProof(
2034         bytes32[] memory proof,
2035         bool[] memory proofFlags,
2036         bytes32[] memory leaves
2037     ) internal pure returns (bytes32 merkleRoot) {
2038         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2039         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2040         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2041         // the merkle tree.
2042         uint256 leavesLen = leaves.length;
2043         uint256 totalHashes = proofFlags.length;
2044 
2045         // Check proof validity.
2046         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2047 
2048         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2049         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2050         bytes32[] memory hashes = new bytes32[](totalHashes);
2051         uint256 leafPos = 0;
2052         uint256 hashPos = 0;
2053         uint256 proofPos = 0;
2054         // At each step, we compute the next hash using two values:
2055         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2056         //   get the next hash.
2057         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2058         //   `proof` array.
2059         for (uint256 i = 0; i < totalHashes; i++) {
2060             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2061             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2062             hashes[i] = _hashPair(a, b);
2063         }
2064 
2065         if (totalHashes > 0) {
2066             return hashes[totalHashes - 1];
2067         } else if (leavesLen > 0) {
2068             return leaves[0];
2069         } else {
2070             return proof[0];
2071         }
2072     }
2073 
2074     /**
2075      * @dev Calldata version of {processMultiProof}.
2076      *
2077      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
2078      *
2079      * _Available since v4.7._
2080      */
2081     function processMultiProofCalldata(
2082         bytes32[] calldata proof,
2083         bool[] calldata proofFlags,
2084         bytes32[] memory leaves
2085     ) internal pure returns (bytes32 merkleRoot) {
2086         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2087         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
2088         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2089         // the merkle tree.
2090         uint256 leavesLen = leaves.length;
2091         uint256 totalHashes = proofFlags.length;
2092 
2093         // Check proof validity.
2094         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
2095 
2096         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2097         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2098         bytes32[] memory hashes = new bytes32[](totalHashes);
2099         uint256 leafPos = 0;
2100         uint256 hashPos = 0;
2101         uint256 proofPos = 0;
2102         // At each step, we compute the next hash using two values:
2103         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2104         //   get the next hash.
2105         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2106         //   `proof` array.
2107         for (uint256 i = 0; i < totalHashes; i++) {
2108             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
2109             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
2110             hashes[i] = _hashPair(a, b);
2111         }
2112 
2113         if (totalHashes > 0) {
2114             return hashes[totalHashes - 1];
2115         } else if (leavesLen > 0) {
2116             return leaves[0];
2117         } else {
2118             return proof[0];
2119         }
2120     }
2121 
2122     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2123         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2124     }
2125 
2126     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2127         /// @solidity memory-safe-assembly
2128         assembly {
2129             mstore(0x00, a)
2130             mstore(0x20, b)
2131             value := keccak256(0x00, 0x40)
2132         }
2133     }
2134 }
2135 
2136 
2137 // File contracts/ExceedRookieClass.sol
2138 
2139 pragma solidity ^0.8.11;
2140 
2141 
2142 
2143 
2144 contract ExceedRookieClass is ERC721A, Ownable {
2145     uint256 private NFT_TYPE_UNCOMMON = 1;
2146     uint256 private NFT_TYPE_RARE = 2;
2147     uint256 private NFT_TYPE_LEGENDARY = 3;
2148 
2149     /**
2150      * @notice A mapping between token id and the token type, tokens with the same type will have the same URI
2151      */
2152     mapping(uint256 => uint256) private _tokenIdsToTokenTypes;
2153 
2154     string baseUri;
2155 
2156     struct TokenType {
2157         uint256 id;
2158         uint256 price;
2159         uint256 maxSupply;
2160         uint256 totalMinted;
2161     }
2162 
2163     TokenType public uncommonTokenType = TokenType(NFT_TYPE_UNCOMMON, 0 ether, 2000, 0);
2164     TokenType public rareTokenType = TokenType(NFT_TYPE_RARE, 0 ether, 1000, 0);
2165     TokenType public legendaryTokenType = TokenType(NFT_TYPE_LEGENDARY, 0 ether, 333, 0);
2166 
2167     bool public isPublicSale = false;
2168     bool public isOGFinish = false;
2169 
2170 
2171     uint256 public MAX_SUPPLY = 3333;
2172     uint256 public maxAllowedTokensPerWallet = 3;
2173 
2174     bytes32 private ogWhitelistMerkleRoot = 0x86e5a310094f98e04b49ef75c05b0f49744aa999551c710a38b78225b8bb9a4b;
2175     bytes32 private generalWhitelistMerkleRoot = 0xd1be75abf44c0140e8c62da24e82ae924d096e334f3d573b79664d456afac87f;
2176 
2177     constructor(string memory baseUri_) ERC721A("Exceed Rookie Class", "EXC") {
2178         baseUri = baseUri_;
2179     }
2180 
2181     modifier saleIsOpen() {
2182         require(totalSupply() <= MAX_SUPPLY, "Sale has ended.");
2183         _;
2184     }
2185 
2186     modifier onlyAuthorized() {
2187         require(owner() == msg.sender);
2188         _;
2189     }
2190 
2191     function setBaseUri(string memory uri) external onlyOwner {
2192         baseUri = uri;
2193     }
2194 
2195     function setOgWhitelistMerkleRoot(bytes32 merkleRootHash) external onlyOwner{
2196         ogWhitelistMerkleRoot = merkleRootHash;
2197     }
2198 
2199     function setGeneralWhitelistMerkleRoot(bytes32 merkleRootHash) external onlyOwner{
2200         generalWhitelistMerkleRoot = merkleRootHash;
2201     }
2202 
2203     function toggleSale() public onlyAuthorized {
2204         isPublicSale = !isPublicSale;
2205     }
2206 
2207     function setOGFinish() public onlyAuthorized {
2208         isOGFinish = true;
2209     }
2210 
2211     function setMaximumAllowedTokensPerWallet(uint256 _count) public onlyAuthorized {
2212         maxAllowedTokensPerWallet = _count;
2213     }
2214 
2215     function setMaxMintSupply(uint256 maxMintSupply) external onlyAuthorized {
2216         MAX_SUPPLY = maxMintSupply;
2217     }
2218 
2219     function totalSupply() public view override returns (uint256) {
2220         return uncommonTokenType.totalMinted + rareTokenType.totalMinted + legendaryTokenType.totalMinted;
2221     }
2222 
2223     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2224         require(_exists(_tokenId), "Token Id Non-existent");
2225 
2226         uint256 tokenType = _tokenIdsToTokenTypes[_tokenId];
2227         return bytes(baseUri).length > 0 ? string(abi.encodePacked(baseUri, "/", Strings.toString(tokenType), ".json")) : "";
2228     }
2229 
2230     function mint(uint256 _count, uint256 tokenType, bytes32[] calldata merkleProof) public payable saleIsOpen {
2231         uint256 mintIndexBeforeMint = totalSupply();
2232 
2233         if (msg.sender != owner()) {
2234             require(balanceOf(msg.sender) + _count <= maxAllowedTokensPerWallet, "Exceeds maximum tokens allowed per wallet");
2235             require(mintIndexBeforeMint + _count <= MAX_SUPPLY, "Total supply exceeded.");
2236 
2237             if (!isPublicSale) {
2238                 if ( mintIndexBeforeMint  + _count <= 333 && !isOGFinish) {
2239                     require(_verifyAddressInOgWhiteList(merkleProof, msg.sender), "NFT:Sender is not OG whitelisted");
2240                 } else {
2241                     require(_verifyAddressInGeneralWhiteList(merkleProof, msg.sender), "NFT:Sender is not whitelisted");
2242                 }
2243             }
2244 
2245             if (tokenType == uncommonTokenType.id) {
2246                 require(uncommonTokenType.totalMinted + _count <= uncommonTokenType.maxSupply, "Total uncommon supply exceeded.");
2247             } else if (tokenType == rareTokenType.id) {
2248                 require(rareTokenType.totalMinted + _count <= rareTokenType.maxSupply, "Total rare supply exceeded.");
2249             } else if (tokenType == legendaryTokenType.id) {
2250                 require(legendaryTokenType.totalMinted + _count <= legendaryTokenType.maxSupply, "Total legendary supply exceeded.");
2251             }
2252         }
2253 
2254         _safeMint(msg.sender, _count);
2255 
2256         // update total after mint
2257         if (tokenType == uncommonTokenType.id) {
2258             uncommonTokenType.totalMinted += _count;
2259         } else if (tokenType == rareTokenType.id) {
2260             rareTokenType.totalMinted += _count;
2261         } else if (tokenType == legendaryTokenType.id) {
2262             legendaryTokenType.totalMinted += _count;
2263         }
2264 
2265         // update the mapping bwtween token id and token type
2266         uint256 totalSupplyAfterMint = totalSupply();
2267         for (uint256 i = mintIndexBeforeMint; i < totalSupplyAfterMint; i++){
2268             _setTokenIdToTokenType(i, tokenType);
2269         }
2270     }
2271 
2272     function withdraw() external onlyAuthorized {
2273         uint256 balance = address(this).balance;
2274         address payable to = payable(msg.sender);
2275         to.transfer(balance);
2276     }
2277 
2278     function _setTokenIdToTokenType(uint256 tokenId, uint256 tokenType) internal {
2279         require(_exists(tokenId), "token type mapping set of nonexistent token");
2280         _tokenIdsToTokenTypes[tokenId] = tokenType;
2281     }
2282 
2283     /**
2284      * @notice Verify OG whitelist merkle proof of the address
2285      */
2286     function _verifyAddressInOgWhiteList(bytes32[] calldata merkleProof, address toAddress) private view returns (bool) {
2287         bytes32 leaf = keccak256(abi.encodePacked(toAddress));
2288         return MerkleProof.verify(merkleProof, ogWhitelistMerkleRoot, leaf);
2289     }
2290 
2291     /**
2292      * @notice Verify general whitelist merkle proof of the address
2293      */
2294     function _verifyAddressInGeneralWhiteList(bytes32[] calldata merkleProof, address toAddress) private view returns (bool) {
2295         bytes32 leaf = keccak256(abi.encodePacked(toAddress));
2296         return MerkleProof.verify(merkleProof, generalWhitelistMerkleRoot, leaf);
2297     }
2298 }