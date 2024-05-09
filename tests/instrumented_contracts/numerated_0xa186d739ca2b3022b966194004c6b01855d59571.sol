1 // Dependency file: erc721a/contracts/IERC721A.sol
2 
3 // SPDX-License-Identifier: MIT
4 // ERC721A Contracts v4.2.3
5 // Creator: Chiru Labs
6 
7 // pragma solidity ^0.8.4;
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
286 
287 // Dependency file: erc721a/contracts/ERC721A.sol
288 
289 // ERC721A Contracts v4.2.3
290 // Creator: Chiru Labs
291 
292 // pragma solidity ^0.8.4;
293 
294 // import '/Users/rico/workspace/blockchain/attic/node_modules/erc721a/contracts/IERC721A.sol';
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
1381 // Dependency file: @openzeppelin/contracts/utils/introspection/IERC165.sol
1382 
1383 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1384 
1385 // pragma solidity ^0.8.0;
1386 
1387 /**
1388  * @dev Interface of the ERC165 standard, as defined in the
1389  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1390  *
1391  * Implementers can declare support of contract interfaces, which can then be
1392  * queried by others ({ERC165Checker}).
1393  *
1394  * For an implementation, see {ERC165}.
1395  */
1396 interface IERC165 {
1397     /**
1398      * @dev Returns true if this contract implements the interface defined by
1399      * `interfaceId`. See the corresponding
1400      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1401      * to learn more about how these ids are created.
1402      *
1403      * This function call must use less than 30 000 gas.
1404      */
1405     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1406 }
1407 
1408 
1409 // Dependency file: @openzeppelin/contracts/token/ERC721/IERC721.sol
1410 
1411 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1412 
1413 // pragma solidity ^0.8.0;
1414 
1415 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
1416 
1417 /**
1418  * @dev Required interface of an ERC721 compliant contract.
1419  */
1420 interface IERC721 is IERC165 {
1421     /**
1422      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1423      */
1424     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1425 
1426     /**
1427      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1428      */
1429     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1430 
1431     /**
1432      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1433      */
1434     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1435 
1436     /**
1437      * @dev Returns the number of tokens in ``owner``'s account.
1438      */
1439     function balanceOf(address owner) external view returns (uint256 balance);
1440 
1441     /**
1442      * @dev Returns the owner of the `tokenId` token.
1443      *
1444      * Requirements:
1445      *
1446      * - `tokenId` must exist.
1447      */
1448     function ownerOf(uint256 tokenId) external view returns (address owner);
1449 
1450     /**
1451      * @dev Safely transfers `tokenId` token from `from` to `to`.
1452      *
1453      * Requirements:
1454      *
1455      * - `from` cannot be the zero address.
1456      * - `to` cannot be the zero address.
1457      * - `tokenId` token must exist and be owned by `from`.
1458      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1459      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1460      *
1461      * Emits a {Transfer} event.
1462      */
1463     function safeTransferFrom(
1464         address from,
1465         address to,
1466         uint256 tokenId,
1467         bytes calldata data
1468     ) external;
1469 
1470     /**
1471      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1472      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1473      *
1474      * Requirements:
1475      *
1476      * - `from` cannot be the zero address.
1477      * - `to` cannot be the zero address.
1478      * - `tokenId` token must exist and be owned by `from`.
1479      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1480      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1481      *
1482      * Emits a {Transfer} event.
1483      */
1484     function safeTransferFrom(
1485         address from,
1486         address to,
1487         uint256 tokenId
1488     ) external;
1489 
1490     /**
1491      * @dev Transfers `tokenId` token from `from` to `to`.
1492      *
1493      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1494      *
1495      * Requirements:
1496      *
1497      * - `from` cannot be the zero address.
1498      * - `to` cannot be the zero address.
1499      * - `tokenId` token must be owned by `from`.
1500      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1501      *
1502      * Emits a {Transfer} event.
1503      */
1504     function transferFrom(
1505         address from,
1506         address to,
1507         uint256 tokenId
1508     ) external;
1509 
1510     /**
1511      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1512      * The approval is cleared when the token is transferred.
1513      *
1514      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1515      *
1516      * Requirements:
1517      *
1518      * - The caller must own the token or be an approved operator.
1519      * - `tokenId` must exist.
1520      *
1521      * Emits an {Approval} event.
1522      */
1523     function approve(address to, uint256 tokenId) external;
1524 
1525     /**
1526      * @dev Approve or remove `operator` as an operator for the caller.
1527      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1528      *
1529      * Requirements:
1530      *
1531      * - The `operator` cannot be the caller.
1532      *
1533      * Emits an {ApprovalForAll} event.
1534      */
1535     function setApprovalForAll(address operator, bool _approved) external;
1536 
1537     /**
1538      * @dev Returns the account approved for `tokenId` token.
1539      *
1540      * Requirements:
1541      *
1542      * - `tokenId` must exist.
1543      */
1544     function getApproved(uint256 tokenId) external view returns (address operator);
1545 
1546     /**
1547      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1548      *
1549      * See {setApprovalForAll}
1550      */
1551     function isApprovedForAll(address owner, address operator) external view returns (bool);
1552 }
1553 
1554 
1555 // Dependency file: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1556 
1557 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1558 
1559 // pragma solidity ^0.8.0;
1560 
1561 /**
1562  * @title ERC721 token receiver interface
1563  * @dev Interface for any contract that wants to support safeTransfers
1564  * from ERC721 asset contracts.
1565  */
1566 interface IERC721Receiver {
1567     /**
1568      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1569      * by `operator` from `from`, this function is called.
1570      *
1571      * It must return its Solidity selector to confirm the token transfer.
1572      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1573      *
1574      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1575      */
1576     function onERC721Received(
1577         address operator,
1578         address from,
1579         uint256 tokenId,
1580         bytes calldata data
1581     ) external returns (bytes4);
1582 }
1583 
1584 
1585 // Dependency file: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1586 
1587 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1588 
1589 // pragma solidity ^0.8.0;
1590 
1591 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
1592 
1593 /**
1594  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1595  * @dev See https://eips.ethereum.org/EIPS/eip-721
1596  */
1597 interface IERC721Metadata is IERC721 {
1598     /**
1599      * @dev Returns the token collection name.
1600      */
1601     function name() external view returns (string memory);
1602 
1603     /**
1604      * @dev Returns the token collection symbol.
1605      */
1606     function symbol() external view returns (string memory);
1607 
1608     /**
1609      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1610      */
1611     function tokenURI(uint256 tokenId) external view returns (string memory);
1612 }
1613 
1614 
1615 // Dependency file: @openzeppelin/contracts/utils/Address.sol
1616 
1617 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1618 
1619 // pragma solidity ^0.8.1;
1620 
1621 /**
1622  * @dev Collection of functions related to the address type
1623  */
1624 library Address {
1625     /**
1626      * @dev Returns true if `account` is a contract.
1627      *
1628      * [IMPORTANT]
1629      * ====
1630      * It is unsafe to assume that an address for which this function returns
1631      * false is an externally-owned account (EOA) and not a contract.
1632      *
1633      * Among others, `isContract` will return false for the following
1634      * types of addresses:
1635      *
1636      *  - an externally-owned account
1637      *  - a contract in construction
1638      *  - an address where a contract will be created
1639      *  - an address where a contract lived, but was destroyed
1640      * ====
1641      *
1642      * [IMPORTANT]
1643      * ====
1644      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1645      *
1646      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1647      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1648      * constructor.
1649      * ====
1650      */
1651     function isContract(address account) internal view returns (bool) {
1652         // This method relies on extcodesize/address.code.length, which returns 0
1653         // for contracts in construction, since the code is only stored at the end
1654         // of the constructor execution.
1655 
1656         return account.code.length > 0;
1657     }
1658 
1659     /**
1660      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1661      * `recipient`, forwarding all available gas and reverting on errors.
1662      *
1663      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1664      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1665      * imposed by `transfer`, making them unable to receive funds via
1666      * `transfer`. {sendValue} removes this limitation.
1667      *
1668      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1669      *
1670      * IMPORTANT: because control is transferred to `recipient`, care must be
1671      * taken to not create reentrancy vulnerabilities. Consider using
1672      * {ReentrancyGuard} or the
1673      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1674      */
1675     function sendValue(address payable recipient, uint256 amount) internal {
1676         require(address(this).balance >= amount, "Address: insufficient balance");
1677 
1678         (bool success, ) = recipient.call{value: amount}("");
1679         require(success, "Address: unable to send value, recipient may have reverted");
1680     }
1681 
1682     /**
1683      * @dev Performs a Solidity function call using a low level `call`. A
1684      * plain `call` is an unsafe replacement for a function call: use this
1685      * function instead.
1686      *
1687      * If `target` reverts with a revert reason, it is bubbled up by this
1688      * function (like regular Solidity function calls).
1689      *
1690      * Returns the raw returned data. To convert to the expected return value,
1691      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1692      *
1693      * Requirements:
1694      *
1695      * - `target` must be a contract.
1696      * - calling `target` with `data` must not revert.
1697      *
1698      * _Available since v3.1._
1699      */
1700     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1701         return functionCall(target, data, "Address: low-level call failed");
1702     }
1703 
1704     /**
1705      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1706      * `errorMessage` as a fallback revert reason when `target` reverts.
1707      *
1708      * _Available since v3.1._
1709      */
1710     function functionCall(
1711         address target,
1712         bytes memory data,
1713         string memory errorMessage
1714     ) internal returns (bytes memory) {
1715         return functionCallWithValue(target, data, 0, errorMessage);
1716     }
1717 
1718     /**
1719      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1720      * but also transferring `value` wei to `target`.
1721      *
1722      * Requirements:
1723      *
1724      * - the calling contract must have an ETH balance of at least `value`.
1725      * - the called Solidity function must be `payable`.
1726      *
1727      * _Available since v3.1._
1728      */
1729     function functionCallWithValue(
1730         address target,
1731         bytes memory data,
1732         uint256 value
1733     ) internal returns (bytes memory) {
1734         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1735     }
1736 
1737     /**
1738      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1739      * with `errorMessage` as a fallback revert reason when `target` reverts.
1740      *
1741      * _Available since v3.1._
1742      */
1743     function functionCallWithValue(
1744         address target,
1745         bytes memory data,
1746         uint256 value,
1747         string memory errorMessage
1748     ) internal returns (bytes memory) {
1749         require(address(this).balance >= value, "Address: insufficient balance for call");
1750         require(isContract(target), "Address: call to non-contract");
1751 
1752         (bool success, bytes memory returndata) = target.call{value: value}(data);
1753         return verifyCallResult(success, returndata, errorMessage);
1754     }
1755 
1756     /**
1757      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1758      * but performing a static call.
1759      *
1760      * _Available since v3.3._
1761      */
1762     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1763         return functionStaticCall(target, data, "Address: low-level static call failed");
1764     }
1765 
1766     /**
1767      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1768      * but performing a static call.
1769      *
1770      * _Available since v3.3._
1771      */
1772     function functionStaticCall(
1773         address target,
1774         bytes memory data,
1775         string memory errorMessage
1776     ) internal view returns (bytes memory) {
1777         require(isContract(target), "Address: static call to non-contract");
1778 
1779         (bool success, bytes memory returndata) = target.staticcall(data);
1780         return verifyCallResult(success, returndata, errorMessage);
1781     }
1782 
1783     /**
1784      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1785      * but performing a delegate call.
1786      *
1787      * _Available since v3.4._
1788      */
1789     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1790         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1791     }
1792 
1793     /**
1794      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1795      * but performing a delegate call.
1796      *
1797      * _Available since v3.4._
1798      */
1799     function functionDelegateCall(
1800         address target,
1801         bytes memory data,
1802         string memory errorMessage
1803     ) internal returns (bytes memory) {
1804         require(isContract(target), "Address: delegate call to non-contract");
1805 
1806         (bool success, bytes memory returndata) = target.delegatecall(data);
1807         return verifyCallResult(success, returndata, errorMessage);
1808     }
1809 
1810     /**
1811      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1812      * revert reason using the provided one.
1813      *
1814      * _Available since v4.3._
1815      */
1816     function verifyCallResult(
1817         bool success,
1818         bytes memory returndata,
1819         string memory errorMessage
1820     ) internal pure returns (bytes memory) {
1821         if (success) {
1822             return returndata;
1823         } else {
1824             // Look for revert reason and bubble it up if present
1825             if (returndata.length > 0) {
1826                 // The easiest way to bubble the revert reason is using memory via assembly
1827                 /// @solidity memory-safe-assembly
1828                 assembly {
1829                     let returndata_size := mload(returndata)
1830                     revert(add(32, returndata), returndata_size)
1831                 }
1832             } else {
1833                 revert(errorMessage);
1834             }
1835         }
1836     }
1837 }
1838 
1839 
1840 // Dependency file: @openzeppelin/contracts/utils/Context.sol
1841 
1842 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1843 
1844 // pragma solidity ^0.8.0;
1845 
1846 /**
1847  * @dev Provides information about the current execution context, including the
1848  * sender of the transaction and its data. While these are generally available
1849  * via msg.sender and msg.data, they should not be accessed in such a direct
1850  * manner, since when dealing with meta-transactions the account sending and
1851  * paying for execution may not be the actual sender (as far as an application
1852  * is concerned).
1853  *
1854  * This contract is only required for intermediate, library-like contracts.
1855  */
1856 abstract contract Context {
1857     function _msgSender() internal view virtual returns (address) {
1858         return msg.sender;
1859     }
1860 
1861     function _msgData() internal view virtual returns (bytes calldata) {
1862         return msg.data;
1863     }
1864 }
1865 
1866 
1867 // Dependency file: @openzeppelin/contracts/utils/Strings.sol
1868 
1869 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1870 
1871 // pragma solidity ^0.8.0;
1872 
1873 /**
1874  * @dev String operations.
1875  */
1876 library Strings {
1877     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1878     uint8 private constant _ADDRESS_LENGTH = 20;
1879 
1880     /**
1881      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1882      */
1883     function toString(uint256 value) internal pure returns (string memory) {
1884         // Inspired by OraclizeAPI's implementation - MIT licence
1885         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1886 
1887         if (value == 0) {
1888             return "0";
1889         }
1890         uint256 temp = value;
1891         uint256 digits;
1892         while (temp != 0) {
1893             digits++;
1894             temp /= 10;
1895         }
1896         bytes memory buffer = new bytes(digits);
1897         while (value != 0) {
1898             digits -= 1;
1899             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1900             value /= 10;
1901         }
1902         return string(buffer);
1903     }
1904 
1905     /**
1906      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1907      */
1908     function toHexString(uint256 value) internal pure returns (string memory) {
1909         if (value == 0) {
1910             return "0x00";
1911         }
1912         uint256 temp = value;
1913         uint256 length = 0;
1914         while (temp != 0) {
1915             length++;
1916             temp >>= 8;
1917         }
1918         return toHexString(value, length);
1919     }
1920 
1921     /**
1922      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1923      */
1924     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1925         bytes memory buffer = new bytes(2 * length + 2);
1926         buffer[0] = "0";
1927         buffer[1] = "x";
1928         for (uint256 i = 2 * length + 1; i > 1; --i) {
1929             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1930             value >>= 4;
1931         }
1932         require(value == 0, "Strings: hex length insufficient");
1933         return string(buffer);
1934     }
1935 
1936     /**
1937      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1938      */
1939     function toHexString(address addr) internal pure returns (string memory) {
1940         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1941     }
1942 }
1943 
1944 
1945 // Dependency file: @openzeppelin/contracts/utils/introspection/ERC165.sol
1946 
1947 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1948 
1949 // pragma solidity ^0.8.0;
1950 
1951 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
1952 
1953 /**
1954  * @dev Implementation of the {IERC165} interface.
1955  *
1956  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1957  * for the additional interface id that will be supported. For example:
1958  *
1959  * ```solidity
1960  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1961  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1962  * }
1963  * ```
1964  *
1965  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1966  */
1967 abstract contract ERC165 is IERC165 {
1968     /**
1969      * @dev See {IERC165-supportsInterface}.
1970      */
1971     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1972         return interfaceId == type(IERC165).interfaceId;
1973     }
1974 }
1975 
1976 
1977 // Dependency file: @openzeppelin/contracts/token/ERC721/ERC721.sol
1978 
1979 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1980 
1981 // pragma solidity ^0.8.0;
1982 
1983 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
1984 // import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
1985 // import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
1986 // import "@openzeppelin/contracts/utils/Address.sol";
1987 // import "@openzeppelin/contracts/utils/Context.sol";
1988 // import "@openzeppelin/contracts/utils/Strings.sol";
1989 // import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
1990 
1991 /**
1992  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1993  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1994  * {ERC721Enumerable}.
1995  */
1996 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1997     using Address for address;
1998     using Strings for uint256;
1999 
2000     // Token name
2001     string private _name;
2002 
2003     // Token symbol
2004     string private _symbol;
2005 
2006     // Mapping from token ID to owner address
2007     mapping(uint256 => address) private _owners;
2008 
2009     // Mapping owner address to token count
2010     mapping(address => uint256) private _balances;
2011 
2012     // Mapping from token ID to approved address
2013     mapping(uint256 => address) private _tokenApprovals;
2014 
2015     // Mapping from owner to operator approvals
2016     mapping(address => mapping(address => bool)) private _operatorApprovals;
2017 
2018     /**
2019      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2020      */
2021     constructor(string memory name_, string memory symbol_) {
2022         _name = name_;
2023         _symbol = symbol_;
2024     }
2025 
2026     /**
2027      * @dev See {IERC165-supportsInterface}.
2028      */
2029     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
2030         return
2031             interfaceId == type(IERC721).interfaceId ||
2032             interfaceId == type(IERC721Metadata).interfaceId ||
2033             super.supportsInterface(interfaceId);
2034     }
2035 
2036     /**
2037      * @dev See {IERC721-balanceOf}.
2038      */
2039     function balanceOf(address owner) public view virtual override returns (uint256) {
2040         require(owner != address(0), "ERC721: address zero is not a valid owner");
2041         return _balances[owner];
2042     }
2043 
2044     /**
2045      * @dev See {IERC721-ownerOf}.
2046      */
2047     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2048         address owner = _owners[tokenId];
2049         require(owner != address(0), "ERC721: invalid token ID");
2050         return owner;
2051     }
2052 
2053     /**
2054      * @dev See {IERC721Metadata-name}.
2055      */
2056     function name() public view virtual override returns (string memory) {
2057         return _name;
2058     }
2059 
2060     /**
2061      * @dev See {IERC721Metadata-symbol}.
2062      */
2063     function symbol() public view virtual override returns (string memory) {
2064         return _symbol;
2065     }
2066 
2067     /**
2068      * @dev See {IERC721Metadata-tokenURI}.
2069      */
2070     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2071         _requireMinted(tokenId);
2072 
2073         string memory baseURI = _baseURI();
2074         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2075     }
2076 
2077     /**
2078      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2079      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2080      * by default, can be overridden in child contracts.
2081      */
2082     function _baseURI() internal view virtual returns (string memory) {
2083         return "";
2084     }
2085 
2086     /**
2087      * @dev See {IERC721-approve}.
2088      */
2089     function approve(address to, uint256 tokenId) public virtual override {
2090         address owner = ERC721.ownerOf(tokenId);
2091         require(to != owner, "ERC721: approval to current owner");
2092 
2093         require(
2094             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2095             "ERC721: approve caller is not token owner nor approved for all"
2096         );
2097 
2098         _approve(to, tokenId);
2099     }
2100 
2101     /**
2102      * @dev See {IERC721-getApproved}.
2103      */
2104     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2105         _requireMinted(tokenId);
2106 
2107         return _tokenApprovals[tokenId];
2108     }
2109 
2110     /**
2111      * @dev See {IERC721-setApprovalForAll}.
2112      */
2113     function setApprovalForAll(address operator, bool approved) public virtual override {
2114         _setApprovalForAll(_msgSender(), operator, approved);
2115     }
2116 
2117     /**
2118      * @dev See {IERC721-isApprovedForAll}.
2119      */
2120     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2121         return _operatorApprovals[owner][operator];
2122     }
2123 
2124     /**
2125      * @dev See {IERC721-transferFrom}.
2126      */
2127     function transferFrom(
2128         address from,
2129         address to,
2130         uint256 tokenId
2131     ) public virtual override {
2132         //solhint-disable-next-line max-line-length
2133         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2134 
2135         _transfer(from, to, tokenId);
2136     }
2137 
2138     /**
2139      * @dev See {IERC721-safeTransferFrom}.
2140      */
2141     function safeTransferFrom(
2142         address from,
2143         address to,
2144         uint256 tokenId
2145     ) public virtual override {
2146         safeTransferFrom(from, to, tokenId, "");
2147     }
2148 
2149     /**
2150      * @dev See {IERC721-safeTransferFrom}.
2151      */
2152     function safeTransferFrom(
2153         address from,
2154         address to,
2155         uint256 tokenId,
2156         bytes memory data
2157     ) public virtual override {
2158         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
2159         _safeTransfer(from, to, tokenId, data);
2160     }
2161 
2162     /**
2163      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2164      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2165      *
2166      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2167      *
2168      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2169      * implement alternative mechanisms to perform token transfer, such as signature-based.
2170      *
2171      * Requirements:
2172      *
2173      * - `from` cannot be the zero address.
2174      * - `to` cannot be the zero address.
2175      * - `tokenId` token must exist and be owned by `from`.
2176      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2177      *
2178      * Emits a {Transfer} event.
2179      */
2180     function _safeTransfer(
2181         address from,
2182         address to,
2183         uint256 tokenId,
2184         bytes memory data
2185     ) internal virtual {
2186         _transfer(from, to, tokenId);
2187         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
2188     }
2189 
2190     /**
2191      * @dev Returns whether `tokenId` exists.
2192      *
2193      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2194      *
2195      * Tokens start existing when they are minted (`_mint`),
2196      * and stop existing when they are burned (`_burn`).
2197      */
2198     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2199         return _owners[tokenId] != address(0);
2200     }
2201 
2202     /**
2203      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2204      *
2205      * Requirements:
2206      *
2207      * - `tokenId` must exist.
2208      */
2209     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2210         address owner = ERC721.ownerOf(tokenId);
2211         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2212     }
2213 
2214     /**
2215      * @dev Safely mints `tokenId` and transfers it to `to`.
2216      *
2217      * Requirements:
2218      *
2219      * - `tokenId` must not exist.
2220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2221      *
2222      * Emits a {Transfer} event.
2223      */
2224     function _safeMint(address to, uint256 tokenId) internal virtual {
2225         _safeMint(to, tokenId, "");
2226     }
2227 
2228     /**
2229      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2230      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2231      */
2232     function _safeMint(
2233         address to,
2234         uint256 tokenId,
2235         bytes memory data
2236     ) internal virtual {
2237         _mint(to, tokenId);
2238         require(
2239             _checkOnERC721Received(address(0), to, tokenId, data),
2240             "ERC721: transfer to non ERC721Receiver implementer"
2241         );
2242     }
2243 
2244     /**
2245      * @dev Mints `tokenId` and transfers it to `to`.
2246      *
2247      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2248      *
2249      * Requirements:
2250      *
2251      * - `tokenId` must not exist.
2252      * - `to` cannot be the zero address.
2253      *
2254      * Emits a {Transfer} event.
2255      */
2256     function _mint(address to, uint256 tokenId) internal virtual {
2257         require(to != address(0), "ERC721: mint to the zero address");
2258         require(!_exists(tokenId), "ERC721: token already minted");
2259 
2260         _beforeTokenTransfer(address(0), to, tokenId);
2261 
2262         _balances[to] += 1;
2263         _owners[tokenId] = to;
2264 
2265         emit Transfer(address(0), to, tokenId);
2266 
2267         _afterTokenTransfer(address(0), to, tokenId);
2268     }
2269 
2270     /**
2271      * @dev Destroys `tokenId`.
2272      * The approval is cleared when the token is burned.
2273      *
2274      * Requirements:
2275      *
2276      * - `tokenId` must exist.
2277      *
2278      * Emits a {Transfer} event.
2279      */
2280     function _burn(uint256 tokenId) internal virtual {
2281         address owner = ERC721.ownerOf(tokenId);
2282 
2283         _beforeTokenTransfer(owner, address(0), tokenId);
2284 
2285         // Clear approvals
2286         _approve(address(0), tokenId);
2287 
2288         _balances[owner] -= 1;
2289         delete _owners[tokenId];
2290 
2291         emit Transfer(owner, address(0), tokenId);
2292 
2293         _afterTokenTransfer(owner, address(0), tokenId);
2294     }
2295 
2296     /**
2297      * @dev Transfers `tokenId` from `from` to `to`.
2298      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2299      *
2300      * Requirements:
2301      *
2302      * - `to` cannot be the zero address.
2303      * - `tokenId` token must be owned by `from`.
2304      *
2305      * Emits a {Transfer} event.
2306      */
2307     function _transfer(
2308         address from,
2309         address to,
2310         uint256 tokenId
2311     ) internal virtual {
2312         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2313         require(to != address(0), "ERC721: transfer to the zero address");
2314 
2315         _beforeTokenTransfer(from, to, tokenId);
2316 
2317         // Clear approvals from the previous owner
2318         _approve(address(0), tokenId);
2319 
2320         _balances[from] -= 1;
2321         _balances[to] += 1;
2322         _owners[tokenId] = to;
2323 
2324         emit Transfer(from, to, tokenId);
2325 
2326         _afterTokenTransfer(from, to, tokenId);
2327     }
2328 
2329     /**
2330      * @dev Approve `to` to operate on `tokenId`
2331      *
2332      * Emits an {Approval} event.
2333      */
2334     function _approve(address to, uint256 tokenId) internal virtual {
2335         _tokenApprovals[tokenId] = to;
2336         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2337     }
2338 
2339     /**
2340      * @dev Approve `operator` to operate on all of `owner` tokens
2341      *
2342      * Emits an {ApprovalForAll} event.
2343      */
2344     function _setApprovalForAll(
2345         address owner,
2346         address operator,
2347         bool approved
2348     ) internal virtual {
2349         require(owner != operator, "ERC721: approve to caller");
2350         _operatorApprovals[owner][operator] = approved;
2351         emit ApprovalForAll(owner, operator, approved);
2352     }
2353 
2354     /**
2355      * @dev Reverts if the `tokenId` has not been minted yet.
2356      */
2357     function _requireMinted(uint256 tokenId) internal view virtual {
2358         require(_exists(tokenId), "ERC721: invalid token ID");
2359     }
2360 
2361     /**
2362      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2363      * The call is not executed if the target address is not a contract.
2364      *
2365      * @param from address representing the previous owner of the given token ID
2366      * @param to target address that will receive the tokens
2367      * @param tokenId uint256 ID of the token to be transferred
2368      * @param data bytes optional data to send along with the call
2369      * @return bool whether the call correctly returned the expected magic value
2370      */
2371     function _checkOnERC721Received(
2372         address from,
2373         address to,
2374         uint256 tokenId,
2375         bytes memory data
2376     ) private returns (bool) {
2377         if (to.isContract()) {
2378             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2379                 return retval == IERC721Receiver.onERC721Received.selector;
2380             } catch (bytes memory reason) {
2381                 if (reason.length == 0) {
2382                     revert("ERC721: transfer to non ERC721Receiver implementer");
2383                 } else {
2384                     /// @solidity memory-safe-assembly
2385                     assembly {
2386                         revert(add(32, reason), mload(reason))
2387                     }
2388                 }
2389             }
2390         } else {
2391             return true;
2392         }
2393     }
2394 
2395     /**
2396      * @dev Hook that is called before any token transfer. This includes minting
2397      * and burning.
2398      *
2399      * Calling conditions:
2400      *
2401      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2402      * transferred to `to`.
2403      * - When `from` is zero, `tokenId` will be minted for `to`.
2404      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2405      * - `from` and `to` are never both zero.
2406      *
2407      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2408      */
2409     function _beforeTokenTransfer(
2410         address from,
2411         address to,
2412         uint256 tokenId
2413     ) internal virtual {}
2414 
2415     /**
2416      * @dev Hook that is called after any transfer of tokens. This includes
2417      * minting and burning.
2418      *
2419      * Calling conditions:
2420      *
2421      * - when `from` and `to` are both non-zero.
2422      * - `from` and `to` are never both zero.
2423      *
2424      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2425      */
2426     function _afterTokenTransfer(
2427         address from,
2428         address to,
2429         uint256 tokenId
2430     ) internal virtual {}
2431 }
2432 
2433 
2434 // Dependency file: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
2435 
2436 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
2437 
2438 // pragma solidity ^0.8.0;
2439 
2440 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
2441 
2442 /**
2443  * @dev Required interface of an ERC1155 compliant contract, as defined in the
2444  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
2445  *
2446  * _Available since v3.1._
2447  */
2448 interface IERC1155 is IERC165 {
2449     /**
2450      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
2451      */
2452     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
2453 
2454     /**
2455      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
2456      * transfers.
2457      */
2458     event TransferBatch(
2459         address indexed operator,
2460         address indexed from,
2461         address indexed to,
2462         uint256[] ids,
2463         uint256[] values
2464     );
2465 
2466     /**
2467      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
2468      * `approved`.
2469      */
2470     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
2471 
2472     /**
2473      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
2474      *
2475      * If an {URI} event was emitted for `id`, the standard
2476      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
2477      * returned by {IERC1155MetadataURI-uri}.
2478      */
2479     event URI(string value, uint256 indexed id);
2480 
2481     /**
2482      * @dev Returns the amount of tokens of token type `id` owned by `account`.
2483      *
2484      * Requirements:
2485      *
2486      * - `account` cannot be the zero address.
2487      */
2488     function balanceOf(address account, uint256 id) external view returns (uint256);
2489 
2490     /**
2491      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
2492      *
2493      * Requirements:
2494      *
2495      * - `accounts` and `ids` must have the same length.
2496      */
2497     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
2498         external
2499         view
2500         returns (uint256[] memory);
2501 
2502     /**
2503      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
2504      *
2505      * Emits an {ApprovalForAll} event.
2506      *
2507      * Requirements:
2508      *
2509      * - `operator` cannot be the caller.
2510      */
2511     function setApprovalForAll(address operator, bool approved) external;
2512 
2513     /**
2514      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
2515      *
2516      * See {setApprovalForAll}.
2517      */
2518     function isApprovedForAll(address account, address operator) external view returns (bool);
2519 
2520     /**
2521      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
2522      *
2523      * Emits a {TransferSingle} event.
2524      *
2525      * Requirements:
2526      *
2527      * - `to` cannot be the zero address.
2528      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
2529      * - `from` must have a balance of tokens of type `id` of at least `amount`.
2530      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
2531      * acceptance magic value.
2532      */
2533     function safeTransferFrom(
2534         address from,
2535         address to,
2536         uint256 id,
2537         uint256 amount,
2538         bytes calldata data
2539     ) external;
2540 
2541     /**
2542      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
2543      *
2544      * Emits a {TransferBatch} event.
2545      *
2546      * Requirements:
2547      *
2548      * - `ids` and `amounts` must have the same length.
2549      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
2550      * acceptance magic value.
2551      */
2552     function safeBatchTransferFrom(
2553         address from,
2554         address to,
2555         uint256[] calldata ids,
2556         uint256[] calldata amounts,
2557         bytes calldata data
2558     ) external;
2559 }
2560 
2561 
2562 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
2563 
2564 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2565 
2566 // pragma solidity ^0.8.0;
2567 
2568 // import "@openzeppelin/contracts/utils/Context.sol";
2569 
2570 /**
2571  * @dev Contract module which provides a basic access control mechanism, where
2572  * there is an account (an owner) that can be granted exclusive access to
2573  * specific functions.
2574  *
2575  * By default, the owner account will be the one that deploys the contract. This
2576  * can later be changed with {transferOwnership}.
2577  *
2578  * This module is used through inheritance. It will make available the modifier
2579  * `onlyOwner`, which can be applied to your functions to restrict their use to
2580  * the owner.
2581  */
2582 abstract contract Ownable is Context {
2583     address private _owner;
2584 
2585     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2586 
2587     /**
2588      * @dev Initializes the contract setting the deployer as the initial owner.
2589      */
2590     constructor() {
2591         _transferOwnership(_msgSender());
2592     }
2593 
2594     /**
2595      * @dev Throws if called by any account other than the owner.
2596      */
2597     modifier onlyOwner() {
2598         _checkOwner();
2599         _;
2600     }
2601 
2602     /**
2603      * @dev Returns the address of the current owner.
2604      */
2605     function owner() public view virtual returns (address) {
2606         return _owner;
2607     }
2608 
2609     /**
2610      * @dev Throws if the sender is not the owner.
2611      */
2612     function _checkOwner() internal view virtual {
2613         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2614     }
2615 
2616     /**
2617      * @dev Leaves the contract without owner. It will not be possible to call
2618      * `onlyOwner` functions anymore. Can only be called by the current owner.
2619      *
2620      * NOTE: Renouncing ownership will leave the contract without an owner,
2621      * thereby removing any functionality that is only available to the owner.
2622      */
2623     function renounceOwnership() public virtual onlyOwner {
2624         _transferOwnership(address(0));
2625     }
2626 
2627     /**
2628      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2629      * Can only be called by the current owner.
2630      */
2631     function transferOwnership(address newOwner) public virtual onlyOwner {
2632         require(newOwner != address(0), "Ownable: new owner is the zero address");
2633         _transferOwnership(newOwner);
2634     }
2635 
2636     /**
2637      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2638      * Internal function without access restriction.
2639      */
2640     function _transferOwnership(address newOwner) internal virtual {
2641         address oldOwner = _owner;
2642         _owner = newOwner;
2643         emit OwnershipTransferred(oldOwner, newOwner);
2644     }
2645 }
2646 
2647 
2648 // Root file: contracts/core/token/NFTPass.sol
2649 
2650 pragma solidity ^0.8.9;
2651 
2652 // import "erc721a/contracts/ERC721A.sol";
2653 // import "erc721a/contracts/IERC721A.sol";
2654 // import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
2655 // import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
2656 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
2657 // import "@openzeppelin/contracts/access/Ownable.sol";
2658 
2659 error NotWhiteListed();
2660 error InvalidPrice();
2661 error InvalidQuantity();
2662 error InvalidPassType();
2663 error FreeMintUsed();
2664 error WithdrawFailed();
2665 error MintingNotStarted();
2666 error MintingFinished();
2667 error OnlyOneFreeMintAllowed();
2668 
2669 contract NFTPass is ERC721A, Ownable {
2670 
2671     uint256 public constant MINT_START = 1666530000;
2672     event NFTWhiteListed(address indexed nft);
2673     event NFTPassPurchased(address indexed buyer, uint256 indexed quantity, uint256 price);
2674     event OwnerWithdrawn(uint256 amount);
2675     event OwnerMinting(uint256 quantity);
2676 
2677     enum NFTPassType { ERC721, ERC1155, ERC721A }
2678     // baseURI for the token metadata
2679     string public metadataURI;
2680     // whitelist for early adopter passes
2681     mapping(address => bool) public eapWhitelist ;
2682     uint256 public price = 0.03 ether;
2683 
2684     // for any whitelist wallet address, max number of passes they can mint is 1
2685     mapping(address => bool) public whitelistMinted;
2686 
2687     constructor(string memory name_, string memory symbol_, string memory baseUrl_) ERC721A(name_, symbol_) {
2688         metadataURI = baseUrl_;
2689         // Genesis Critterz
2690         eapWhitelist[0x8ffb9b504d497e4000967391e70D542b8cC6748A] = true;
2691         // Staked Critterz
2692         eapWhitelist[0x47f75E8dD28dF8d6E7c39ccda47026b0DCa99043] = true;
2693         // Critterz Plots
2694         eapWhitelist[0x3D7F0F28e1d42082e3de70ec4c9d1D59a07AFFb9] = true;
2695         // Staked Plot
2696         eapWhitelist[0xB81Cf242671eDAE57754B1a061F62Af08B32926A] = true;
2697         // CryptoMaids
2698         eapWhitelist[0x5703A3245FF6FAD37fa2a2500F0739d4F6a234E7] = true;
2699         // Mimic Shhans - THE SHHAN
2700         eapWhitelist[0xF75FD01D2262b07D92dcA7f19bD6A3457060d7db] = true;
2701         // Astro Baby Club
2702         eapWhitelist[0x6D5213b085d472273b625857ae0a11ecf2ce7f37] = true;
2703     }
2704 
2705     function contractURI() public pure returns (string memory) {
2706         return "https://metadata.atticc.xyz/my-metadata";
2707     }
2708 
2709     /**
2710      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2711      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2712      * by default, it can be overridden in child contracts.
2713      */
2714     function _baseURI() internal view virtual override returns (string memory) {
2715         return metadataURI;
2716     }
2717 
2718     function _startTokenId() internal view virtual override returns (uint256) {
2719         return 1;
2720     }
2721 
2722     function checkNFTWhitelist(address nftAddress) public view returns (bool) {
2723         return eapWhitelist[nftAddress];
2724     }
2725 
2726     function checkUserMinted(address wallet) public view returns (bool) {
2727         return whitelistMinted[wallet];
2728     }
2729 
2730     function _checkHolder721(address nftAddress, address wallet) private view returns (bool)  {
2731         return IERC721(nftAddress).balanceOf(wallet) > 0;
2732     }
2733 
2734     function _checkHolder1155(address nftAddress, uint256 tokenId, address wallet) private view returns (bool) { 
2735         return IERC1155(nftAddress).balanceOf(wallet, tokenId) > 0;
2736     }
2737 
2738     function _checkHolder721A(address nftAddress, address wallet) private view returns (bool) { 
2739         return IERC721A(nftAddress).balanceOf(wallet) > 0;
2740     }
2741 
2742     function _mintingStarted() private view returns (bool) {
2743         return block.timestamp >= MINT_START;
2744     }
2745 
2746     function checkWhitelist(address nftPass, uint256 tokenId, NFTPassType passType) public view returns (bool) {
2747         if (!checkNFTWhitelist(nftPass)) {
2748             return false;
2749         }
2750         if (passType == NFTPassType.ERC721) {
2751             return _checkHolder721(nftPass, msg.sender);
2752         } else if (passType == NFTPassType.ERC1155) {
2753             return _checkHolder1155(nftPass, tokenId, msg.sender);
2754         } else if (passType == NFTPassType.ERC721A) {
2755             return _checkHolder721A(nftPass, msg.sender);
2756         } 
2757         revert InvalidPassType();
2758     }
2759 
2760     function setPrice(uint256 newPrice) external onlyOwner {
2761         price = newPrice;
2762     }
2763 
2764     function inviteCommunity(address communityAddr) external onlyOwner {
2765        eapWhitelist[communityAddr] = true;
2766     }
2767 
2768     function withdraw() external onlyOwner {
2769         uint256 balance = address(this).balance;
2770         (bool success, ) = owner().call{value: balance}("");
2771         if (!success) revert WithdrawFailed();
2772         emit OwnerWithdrawn(balance);
2773     }
2774 
2775     /**
2776      * @dev Mints NFTPasses for the given wallet address and transfer to the sender
2777      *
2778      * Requirements:
2779      *
2780      * - `quantity is required if it mints multiple tokens`.
2781      *
2782      * Emits a {Transfer} event.
2783      */
2784     function mint(address nftPass, uint256 tokenId, NFTPassType passType, uint256 quantity) external payable {
2785         if (totalSupply() + quantity > 5555) {
2786             revert MintingFinished();
2787         }
2788         // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
2789         // if (!_mintingStarted()) revert MintingNotStarted();
2790         bool isWhitelisted;
2791         if (msg.sender == owner()) {
2792             emit OwnerMinting(quantity);
2793         } else if ( price > 0 ether && msg.value >= price * quantity) {
2794             // this is a purchase of a pass
2795             emit NFTPassPurchased(msg.sender, quantity, msg.value);
2796         } else {
2797             // // every whitelisted user can only do one free mint
2798             if (quantity > 1) {
2799                 revert InvalidQuantity();
2800             }
2801             // check if the user has already minted a pass for free
2802             if (checkUserMinted(msg.sender)) {
2803                 revert OnlyOneFreeMintAllowed();
2804             }
2805             // check the nft that user holds is whitelisted
2806             if (!checkWhitelist(nftPass, tokenId, passType)) {
2807                 revert NotWhiteListed();
2808             }
2809             isWhitelisted = true;
2810         }
2811         _mint(msg.sender, quantity);
2812         if (isWhitelisted) {
2813             whitelistMinted[msg.sender] = true;
2814         }
2815     }
2816 }