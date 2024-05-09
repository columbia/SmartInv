1 // Sources flattened with hardhat v2.12.3 https://hardhat.org
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
1381 // File operator-filter-registry/src/IOperatorFilterRegistry.sol@v1.3.1
1382 
1383 pragma solidity ^0.8.13;
1384 
1385 interface IOperatorFilterRegistry {
1386     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1387     function register(address registrant) external;
1388     function registerAndSubscribe(address registrant, address subscription) external;
1389     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1390     function unregister(address addr) external;
1391     function updateOperator(address registrant, address operator, bool filtered) external;
1392     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1393     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1394     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1395     function subscribe(address registrant, address registrantToSubscribe) external;
1396     function unsubscribe(address registrant, bool copyExistingEntries) external;
1397     function subscriptionOf(address addr) external returns (address registrant);
1398     function subscribers(address registrant) external returns (address[] memory);
1399     function subscriberAt(address registrant, uint256 index) external returns (address);
1400     function copyEntriesOf(address registrant, address registrantToCopy) external;
1401     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1402     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1403     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1404     function filteredOperators(address addr) external returns (address[] memory);
1405     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1406     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1407     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1408     function isRegistered(address addr) external returns (bool);
1409     function codeHashOf(address addr) external returns (bytes32);
1410 }
1411 
1412 
1413 // File operator-filter-registry/src/OperatorFilterer.sol@v1.3.1
1414 
1415 pragma solidity ^0.8.13;
1416 
1417 /**
1418  * @title  OperatorFilterer
1419  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1420  *         registrant's entries in the OperatorFilterRegistry.
1421  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1422  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1423  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1424  */
1425 abstract contract OperatorFilterer {
1426     error OperatorNotAllowed(address operator);
1427 
1428     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1429         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1430 
1431     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1432         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1433         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1434         // order for the modifier to filter addresses.
1435         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1436             if (subscribe) {
1437                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1438             } else {
1439                 if (subscriptionOrRegistrantToCopy != address(0)) {
1440                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1441                 } else {
1442                     OPERATOR_FILTER_REGISTRY.register(address(this));
1443                 }
1444             }
1445         }
1446     }
1447 
1448     modifier onlyAllowedOperator(address from) virtual {
1449         // Allow spending tokens from addresses with balance
1450         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1451         // from an EOA.
1452         if (from != msg.sender) {
1453             _checkFilterOperator(msg.sender);
1454         }
1455         _;
1456     }
1457 
1458     modifier onlyAllowedOperatorApproval(address operator) virtual {
1459         _checkFilterOperator(operator);
1460         _;
1461     }
1462 
1463     function _checkFilterOperator(address operator) internal view virtual {
1464         // Check registry code length to facilitate testing in environments without a deployed registry.
1465         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1466             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1467                 revert OperatorNotAllowed(operator);
1468             }
1469         }
1470     }
1471 }
1472 
1473 
1474 // File operator-filter-registry/src/DefaultOperatorFilterer.sol@v1.3.1
1475 
1476 pragma solidity ^0.8.13;
1477 
1478 /**
1479  * @title  DefaultOperatorFilterer
1480  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1481  */
1482 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1483     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1484 
1485     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1486 }
1487 
1488 
1489 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
1490 
1491 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1492 
1493 pragma solidity ^0.8.0;
1494 
1495 /**
1496  * @dev Provides information about the current execution context, including the
1497  * sender of the transaction and its data. While these are generally available
1498  * via msg.sender and msg.data, they should not be accessed in such a direct
1499  * manner, since when dealing with meta-transactions the account sending and
1500  * paying for execution may not be the actual sender (as far as an application
1501  * is concerned).
1502  *
1503  * This contract is only required for intermediate, library-like contracts.
1504  */
1505 abstract contract Context {
1506     function _msgSender() internal view virtual returns (address) {
1507         return msg.sender;
1508     }
1509 
1510     function _msgData() internal view virtual returns (bytes calldata) {
1511         return msg.data;
1512     }
1513 }
1514 
1515 
1516 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
1517 
1518 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1519 
1520 pragma solidity ^0.8.0;
1521 
1522 /**
1523  * @dev Contract module which provides a basic access control mechanism, where
1524  * there is an account (an owner) that can be granted exclusive access to
1525  * specific functions.
1526  *
1527  * By default, the owner account will be the one that deploys the contract. This
1528  * can later be changed with {transferOwnership}.
1529  *
1530  * This module is used through inheritance. It will make available the modifier
1531  * `onlyOwner`, which can be applied to your functions to restrict their use to
1532  * the owner.
1533  */
1534 abstract contract Ownable is Context {
1535     address private _owner;
1536 
1537     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1538 
1539     /**
1540      * @dev Initializes the contract setting the deployer as the initial owner.
1541      */
1542     constructor() {
1543         _transferOwnership(_msgSender());
1544     }
1545 
1546     /**
1547      * @dev Throws if called by any account other than the owner.
1548      */
1549     modifier onlyOwner() {
1550         _checkOwner();
1551         _;
1552     }
1553 
1554     /**
1555      * @dev Returns the address of the current owner.
1556      */
1557     function owner() public view virtual returns (address) {
1558         return _owner;
1559     }
1560 
1561     /**
1562      * @dev Throws if the sender is not the owner.
1563      */
1564     function _checkOwner() internal view virtual {
1565         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1566     }
1567 
1568     /**
1569      * @dev Leaves the contract without owner. It will not be possible to call
1570      * `onlyOwner` functions anymore. Can only be called by the current owner.
1571      *
1572      * NOTE: Renouncing ownership will leave the contract without an owner,
1573      * thereby removing any functionality that is only available to the owner.
1574      */
1575     function renounceOwnership() public virtual onlyOwner {
1576         _transferOwnership(address(0));
1577     }
1578 
1579     /**
1580      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1581      * Can only be called by the current owner.
1582      */
1583     function transferOwnership(address newOwner) public virtual onlyOwner {
1584         require(newOwner != address(0), "Ownable: new owner is the zero address");
1585         _transferOwnership(newOwner);
1586     }
1587 
1588     /**
1589      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1590      * Internal function without access restriction.
1591      */
1592     function _transferOwnership(address newOwner) internal virtual {
1593         address oldOwner = _owner;
1594         _owner = newOwner;
1595         emit OwnershipTransferred(oldOwner, newOwner);
1596     }
1597 }
1598 
1599 
1600 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.3
1601 
1602 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1603 
1604 pragma solidity ^0.8.0;
1605 
1606 /**
1607  * @dev Contract module that helps prevent reentrant calls to a function.
1608  *
1609  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1610  * available, which can be applied to functions to make sure there are no nested
1611  * (reentrant) calls to them.
1612  *
1613  * Note that because there is a single `nonReentrant` guard, functions marked as
1614  * `nonReentrant` may not call one another. This can be worked around by making
1615  * those functions `private`, and then adding `external` `nonReentrant` entry
1616  * points to them.
1617  *
1618  * TIP: If you would like to learn more about reentrancy and alternative ways
1619  * to protect against it, check out our blog post
1620  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1621  */
1622 abstract contract ReentrancyGuard {
1623     // Booleans are more expensive than uint256 or any type that takes up a full
1624     // word because each write operation emits an extra SLOAD to first read the
1625     // slot's contents, replace the bits taken up by the boolean, and then write
1626     // back. This is the compiler's defense against contract upgrades and
1627     // pointer aliasing, and it cannot be disabled.
1628 
1629     // The values being non-zero value makes deployment a bit more expensive,
1630     // but in exchange the refund on every call to nonReentrant will be lower in
1631     // amount. Since refunds are capped to a percentage of the total
1632     // transaction's gas, it is best to keep them low in cases like this one, to
1633     // increase the likelihood of the full refund coming into effect.
1634     uint256 private constant _NOT_ENTERED = 1;
1635     uint256 private constant _ENTERED = 2;
1636 
1637     uint256 private _status;
1638 
1639     constructor() {
1640         _status = _NOT_ENTERED;
1641     }
1642 
1643     /**
1644      * @dev Prevents a contract from calling itself, directly or indirectly.
1645      * Calling a `nonReentrant` function from another `nonReentrant`
1646      * function is not supported. It is possible to prevent this from happening
1647      * by making the `nonReentrant` function external, and making it call a
1648      * `private` function that does the actual work.
1649      */
1650     modifier nonReentrant() {
1651         // On the first call to nonReentrant, _notEntered will be true
1652         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1653 
1654         // Any calls to nonReentrant after this point will fail
1655         _status = _ENTERED;
1656 
1657         _;
1658 
1659         // By storing the original value once again, a refund is triggered (see
1660         // https://eips.ethereum.org/EIPS/eip-2200)
1661         _status = _NOT_ENTERED;
1662     }
1663 }
1664 
1665 
1666 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.7.3
1667 
1668 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1669 
1670 pragma solidity ^0.8.0;
1671 
1672 /**
1673  * @dev These functions deal with verification of Merkle Tree proofs.
1674  *
1675  * The proofs can be generated using the JavaScript library
1676  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1677  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1678  *
1679  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1680  *
1681  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1682  * hashing, or use a hash function other than keccak256 for hashing leaves.
1683  * This is because the concatenation of a sorted pair of internal nodes in
1684  * the merkle tree could be reinterpreted as a leaf value.
1685  */
1686 library MerkleProof {
1687     /**
1688      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1689      * defined by `root`. For this, a `proof` must be provided, containing
1690      * sibling hashes on the branch from the leaf to the root of the tree. Each
1691      * pair of leaves and each pair of pre-images are assumed to be sorted.
1692      */
1693     function verify(
1694         bytes32[] memory proof,
1695         bytes32 root,
1696         bytes32 leaf
1697     ) internal pure returns (bool) {
1698         return processProof(proof, leaf) == root;
1699     }
1700 
1701     /**
1702      * @dev Calldata version of {verify}
1703      *
1704      * _Available since v4.7._
1705      */
1706     function verifyCalldata(
1707         bytes32[] calldata proof,
1708         bytes32 root,
1709         bytes32 leaf
1710     ) internal pure returns (bool) {
1711         return processProofCalldata(proof, leaf) == root;
1712     }
1713 
1714     /**
1715      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1716      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1717      * hash matches the root of the tree. When processing the proof, the pairs
1718      * of leafs & pre-images are assumed to be sorted.
1719      *
1720      * _Available since v4.4._
1721      */
1722     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1723         bytes32 computedHash = leaf;
1724         for (uint256 i = 0; i < proof.length; i++) {
1725             computedHash = _hashPair(computedHash, proof[i]);
1726         }
1727         return computedHash;
1728     }
1729 
1730     /**
1731      * @dev Calldata version of {processProof}
1732      *
1733      * _Available since v4.7._
1734      */
1735     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1736         bytes32 computedHash = leaf;
1737         for (uint256 i = 0; i < proof.length; i++) {
1738             computedHash = _hashPair(computedHash, proof[i]);
1739         }
1740         return computedHash;
1741     }
1742 
1743     /**
1744      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1745      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1746      *
1747      * _Available since v4.7._
1748      */
1749     function multiProofVerify(
1750         bytes32[] memory proof,
1751         bool[] memory proofFlags,
1752         bytes32 root,
1753         bytes32[] memory leaves
1754     ) internal pure returns (bool) {
1755         return processMultiProof(proof, proofFlags, leaves) == root;
1756     }
1757 
1758     /**
1759      * @dev Calldata version of {multiProofVerify}
1760      *
1761      * _Available since v4.7._
1762      */
1763     function multiProofVerifyCalldata(
1764         bytes32[] calldata proof,
1765         bool[] calldata proofFlags,
1766         bytes32 root,
1767         bytes32[] memory leaves
1768     ) internal pure returns (bool) {
1769         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1770     }
1771 
1772     /**
1773      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1774      * consuming from one or the other at each step according to the instructions given by
1775      * `proofFlags`.
1776      *
1777      * _Available since v4.7._
1778      */
1779     function processMultiProof(
1780         bytes32[] memory proof,
1781         bool[] memory proofFlags,
1782         bytes32[] memory leaves
1783     ) internal pure returns (bytes32 merkleRoot) {
1784         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1785         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1786         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1787         // the merkle tree.
1788         uint256 leavesLen = leaves.length;
1789         uint256 totalHashes = proofFlags.length;
1790 
1791         // Check proof validity.
1792         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1793 
1794         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1795         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1796         bytes32[] memory hashes = new bytes32[](totalHashes);
1797         uint256 leafPos = 0;
1798         uint256 hashPos = 0;
1799         uint256 proofPos = 0;
1800         // At each step, we compute the next hash using two values:
1801         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1802         //   get the next hash.
1803         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1804         //   `proof` array.
1805         for (uint256 i = 0; i < totalHashes; i++) {
1806             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1807             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1808             hashes[i] = _hashPair(a, b);
1809         }
1810 
1811         if (totalHashes > 0) {
1812             return hashes[totalHashes - 1];
1813         } else if (leavesLen > 0) {
1814             return leaves[0];
1815         } else {
1816             return proof[0];
1817         }
1818     }
1819 
1820     /**
1821      * @dev Calldata version of {processMultiProof}
1822      *
1823      * _Available since v4.7._
1824      */
1825     function processMultiProofCalldata(
1826         bytes32[] calldata proof,
1827         bool[] calldata proofFlags,
1828         bytes32[] memory leaves
1829     ) internal pure returns (bytes32 merkleRoot) {
1830         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1831         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1832         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1833         // the merkle tree.
1834         uint256 leavesLen = leaves.length;
1835         uint256 totalHashes = proofFlags.length;
1836 
1837         // Check proof validity.
1838         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1839 
1840         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1841         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1842         bytes32[] memory hashes = new bytes32[](totalHashes);
1843         uint256 leafPos = 0;
1844         uint256 hashPos = 0;
1845         uint256 proofPos = 0;
1846         // At each step, we compute the next hash using two values:
1847         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1848         //   get the next hash.
1849         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1850         //   `proof` array.
1851         for (uint256 i = 0; i < totalHashes; i++) {
1852             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1853             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1854             hashes[i] = _hashPair(a, b);
1855         }
1856 
1857         if (totalHashes > 0) {
1858             return hashes[totalHashes - 1];
1859         } else if (leavesLen > 0) {
1860             return leaves[0];
1861         } else {
1862             return proof[0];
1863         }
1864     }
1865 
1866     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1867         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1868     }
1869 
1870     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1871         /// @solidity memory-safe-assembly
1872         assembly {
1873             mstore(0x00, a)
1874             mstore(0x20, b)
1875             value := keccak256(0x00, 0x40)
1876         }
1877     }
1878 }
1879 
1880 
1881 // File contracts/Camels.sol
1882 
1883 pragma solidity ^0.8.13;
1884 contract Camels is ERC721A, Ownable, DefaultOperatorFilterer {
1885 
1886 
1887     uint public constant maxFreePresaleMints = 3;
1888     uint public constant maxFreePublicMints = 1;
1889 
1890     mapping(address => uint) presaleMinted;
1891     mapping(address => uint) publicMinted;
1892 
1893     uint public constant MAX_SUPPLY = 8000;
1894 
1895     uint public constant PRICE_AFTER_FREE_LIMIT = 0.005 ether;
1896 
1897     bool public isPresaleActive = false;
1898     bool public isPublicActive = false;
1899 
1900     bytes32 private wlRoot;
1901 
1902     string private _customBaseURI;
1903 
1904     constructor(string memory initialBaseURI, bytes32 _wlRoot) ERC721A("Camels", "Camels") {
1905         setBaseTokenURI(initialBaseURI);
1906         wlRoot = _wlRoot;
1907     }
1908 
1909     function presaleMint(bytes32[] calldata _proof, uint256 quantity) external payable{
1910         require(isPresaleActive, "Presale is not active");
1911         require(MerkleProof.verify(_proof, wlRoot, keccak256(abi.encodePacked(msg.sender))), "Invalid proof");
1912         require(totalSupply() + quantity <= MAX_SUPPLY, "Supply exceeded");
1913 
1914         uint mintedCount = presaleMinted[msg.sender];
1915         uint remainingFreePresale = getRemainingFreePresaleMints(mintedCount);
1916 
1917         if(quantity > remainingFreePresale) {
1918             uint paidCount = quantity - remainingFreePresale;
1919             require(msg.value >= paidCount * PRICE_AFTER_FREE_LIMIT , "Not enough ether sent");
1920         }
1921         presaleMinted[msg.sender] += quantity;
1922         _mint(msg.sender, quantity);
1923     }
1924 
1925     function publicMint(uint256 quantity) external payable {
1926         require(isPublicActive, "Public mint is not active");
1927         require(totalSupply() + quantity <= MAX_SUPPLY, "Supply exceeded");
1928 
1929         uint mintedCount = publicMinted[msg.sender];
1930         uint remainingFreePublic = getRemainingFreePublicMints(mintedCount);
1931 
1932         if(quantity > remainingFreePublic) {
1933             uint paidCount = quantity - remainingFreePublic;
1934             require(msg.value >= paidCount * PRICE_AFTER_FREE_LIMIT , "Not enough ether sent");
1935         }
1936         publicMinted[msg.sender] += quantity;
1937         _mint(msg.sender, quantity);
1938     }
1939 
1940 
1941     function setBaseTokenURI(string memory baseURI) public onlyOwner {
1942         _customBaseURI = baseURI;
1943     }
1944 
1945     function withdrawFunds() external onlyOwner {
1946         require(payable(owner()).send(address(this).balance), "transfer failed");
1947     }
1948 
1949     function getRemainingFreePublicMints(uint256 mintedCount) internal pure returns (uint256) {
1950         return mintedCount > maxFreePublicMints ? 0 : maxFreePublicMints - mintedCount;
1951     }
1952 
1953     function getRemainingFreePresaleMints(uint256 mintedCount) internal pure returns (uint256) {
1954         return mintedCount > maxFreePresaleMints ? 0 : maxFreePresaleMints - mintedCount;
1955     }
1956 
1957     function setPresaleMint(bool _presaleActive) external onlyOwner {
1958         isPresaleActive = _presaleActive;
1959     }
1960 
1961     function setPublicMint(bool _publicActive) external onlyOwner {
1962         isPublicActive = _publicActive;
1963     }
1964 
1965     function getPresaleMinted() external view returns (uint) {
1966         return presaleMinted[msg.sender];
1967     }
1968 
1969     function getPublicMinted() external view returns (uint) {
1970         return publicMinted[msg.sender];
1971     }
1972 
1973     function _baseURI() internal view virtual override returns (string memory) {
1974         return _customBaseURI;
1975     }
1976 
1977     function setWlRoot(bytes32 _root) external onlyOwner {
1978         wlRoot = _root;
1979     }
1980 
1981     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1982         super.setApprovalForAll(operator, approved);
1983     }
1984 
1985     function approve(address operator, uint256 tokenId) public override payable onlyAllowedOperatorApproval(operator) {
1986         super.approve(operator, tokenId);
1987     }
1988 
1989     function transferFrom(address from, address to, uint256 tokenId) public override payable onlyAllowedOperator(from) {
1990         super.transferFrom(from, to, tokenId);
1991     }
1992 
1993     function safeTransferFrom(address from, address to, uint256 tokenId) public override payable onlyAllowedOperator(from) {
1994         super.safeTransferFrom(from, to, tokenId);
1995     }
1996 
1997     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1998     public
1999     override
2000     payable
2001     onlyAllowedOperator(from)
2002     {
2003         super.safeTransferFrom(from, to, tokenId, data);
2004     }
2005 }