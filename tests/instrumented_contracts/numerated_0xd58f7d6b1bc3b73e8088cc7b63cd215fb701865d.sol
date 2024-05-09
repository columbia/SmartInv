1 // SPDX-License-Identifier: MIT
2 // File: erc721a/contracts/IERC721A.sol
3 
4 
5 // ERC721A Contracts v4.2.3
6 // Creator: Chiru Labs
7 
8 pragma solidity ^0.8.4;
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
287 // File: erc721a/contracts/ERC721A.sol
288 
289 
290 // ERC721A Contracts v4.2.3
291 // Creator: Chiru Labs
292 
293 pragma solidity ^0.8.4;
294 
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
1380 // File: @openzeppelin/contracts/utils/Strings.sol
1381 
1382 
1383 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1384 
1385 pragma solidity ^0.8.0;
1386 
1387 /**
1388  * @dev String operations.
1389  */
1390 library Strings {
1391     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1392 
1393     /**
1394      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1395      */
1396     function toString(uint256 value) internal pure returns (string memory) {
1397         // Inspired by OraclizeAPI's implementation - MIT licence
1398         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1399 
1400         if (value == 0) {
1401             return "0";
1402         }
1403         uint256 temp = value;
1404         uint256 digits;
1405         while (temp != 0) {
1406             digits++;
1407             temp /= 10;
1408         }
1409         bytes memory buffer = new bytes(digits);
1410         while (value != 0) {
1411             digits -= 1;
1412             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1413             value /= 10;
1414         }
1415         return string(buffer);
1416     }
1417 
1418     /**
1419      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1420      */
1421     function toHexString(uint256 value) internal pure returns (string memory) {
1422         if (value == 0) {
1423             return "0x00";
1424         }
1425         uint256 temp = value;
1426         uint256 length = 0;
1427         while (temp != 0) {
1428             length++;
1429             temp >>= 8;
1430         }
1431         return toHexString(value, length);
1432     }
1433 
1434     /**
1435      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1436      */
1437     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1438         bytes memory buffer = new bytes(2 * length + 2);
1439         buffer[0] = "0";
1440         buffer[1] = "x";
1441         for (uint256 i = 2 * length + 1; i > 1; --i) {
1442             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1443             value >>= 4;
1444         }
1445         require(value == 0, "Strings: hex length insufficient");
1446         return string(buffer);
1447     }
1448 }
1449 
1450 // File: @openzeppelin/contracts/utils/Context.sol
1451 
1452 
1453 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1454 
1455 pragma solidity ^0.8.0;
1456 
1457 /**
1458  * @dev Provides information about the current execution context, including the
1459  * sender of the transaction and its data. While these are generally available
1460  * via msg.sender and msg.data, they should not be accessed in such a direct
1461  * manner, since when dealing with meta-transactions the account sending and
1462  * paying for execution may not be the actual sender (as far as an application
1463  * is concerned).
1464  *
1465  * This contract is only required for intermediate, library-like contracts.
1466  */
1467 abstract contract Context {
1468     function _msgSender() internal view virtual returns (address) {
1469         return msg.sender;
1470     }
1471 
1472     function _msgData() internal view virtual returns (bytes calldata) {
1473         return msg.data;
1474     }
1475 }
1476 
1477 // File: @openzeppelin/contracts/access/Ownable.sol
1478 
1479 
1480 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1481 
1482 pragma solidity ^0.8.0;
1483 
1484 
1485 /**
1486  * @dev Contract module which provides a basic access control mechanism, where
1487  * there is an account (an owner) that can be granted exclusive access to
1488  * specific functions.
1489  *
1490  * By default, the owner account will be the one that deploys the contract. This
1491  * can later be changed with {transferOwnership}.
1492  *
1493  * This module is used through inheritance. It will make available the modifier
1494  * `onlyOwner`, which can be applied to your functions to restrict their use to
1495  * the owner.
1496  */
1497 abstract contract Ownable is Context {
1498     address private _owner;
1499 
1500     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1501 
1502     /**
1503      * @dev Initializes the contract setting the deployer as the initial owner.
1504      */
1505     constructor() {
1506         _transferOwnership(_msgSender());
1507     }
1508 
1509     /**
1510      * @dev Returns the address of the current owner.
1511      */
1512     function owner() public view virtual returns (address) {
1513         return _owner;
1514     }
1515 
1516     /**
1517      * @dev Throws if called by any account other than the owner.
1518      */
1519     modifier onlyOwner() {
1520         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1521         _;
1522     }
1523 
1524     /**
1525      * @dev Leaves the contract without owner. It will not be possible to call
1526      * `onlyOwner` functions anymore. Can only be called by the current owner.
1527      *
1528      * NOTE: Renouncing ownership will leave the contract without an owner,
1529      * thereby removing any functionality that is only available to the owner.
1530      */
1531     function renounceOwnership() public virtual onlyOwner {
1532         _transferOwnership(address(0));
1533     }
1534 
1535     /**
1536      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1537      * Can only be called by the current owner.
1538      */
1539     function transferOwnership(address newOwner) public virtual onlyOwner {
1540         require(newOwner != address(0), "Ownable: new owner is the zero address");
1541         _transferOwnership(newOwner);
1542     }
1543 
1544     /**
1545      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1546      * Internal function without access restriction.
1547      */
1548     function _transferOwnership(address newOwner) internal virtual {
1549         address oldOwner = _owner;
1550         _owner = newOwner;
1551         emit OwnershipTransferred(oldOwner, newOwner);
1552     }
1553 }
1554 
1555 // File: contracts/BoneBoy.sol
1556 
1557 
1558 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1559 
1560 pragma solidity ^0.8.0;
1561 
1562 
1563 
1564 
1565 contract BoneBoy is ERC721A, Ownable {
1566 
1567     uint256 public constant MAX_SUPPLY = 2000000;
1568     uint256 public constant FREE_SUPPLY = 3;
1569     uint256 public constant PAID_SUPPLY = 10;
1570 
1571     uint256 private _flag;
1572     string private _defTokenURI = "https://ipfs.io/ipfs/QmW1aWcnHdQEhf8MULf1Pg4YH7gp8eoErggRJ9hGVvnVcb";
1573     string private _baseTokenURI = "";
1574 
1575     mapping(address => bool) private _hasMinted;
1576 
1577     event NewMint(address indexed msgSender, uint256 indexed mintQuantity);
1578 
1579     constructor() ERC721A("BoneBoy", "BBY") {
1580     }
1581 
1582     function _startTokenId() internal view override virtual returns (uint256) {
1583         return 1;
1584     }
1585 
1586     function transferOut(address _to) public onlyOwner {
1587         uint256 balance = address(this).balance;
1588         payable(_to).transfer(balance);
1589     }
1590 
1591     function changeTokenURIFlag(uint256 flag) external onlyOwner {
1592         _flag = flag;
1593     }
1594 
1595     function changeDefURI(string calldata _tokenURI) external onlyOwner {
1596         _defTokenURI = _tokenURI;
1597     }
1598 
1599     function changeURI(string calldata _tokenURI) external onlyOwner {
1600         _baseTokenURI = _tokenURI;
1601     }
1602 
1603     function _baseURI() internal view virtual override returns (string memory) {
1604         return _baseTokenURI;
1605     }
1606 
1607     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1608         if (_flag == 0) {
1609             return _defTokenURI;
1610         } else {
1611             require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1612             return string(abi.encodePacked(_baseTokenURI, Strings.toString(tokenId)));
1613         }
1614     }
1615 
1616     function mint(uint256 quantity) public payable {
1617         require(totalSupply() + quantity <= MAX_SUPPLY, "ERC721: Exceeds maximum supply");
1618         require(quantity == 1 || quantity == FREE_SUPPLY || quantity == PAID_SUPPLY || quantity == 100, "ERC721: Invalid quantity");
1619 
1620         if (quantity == 1 ) {
1621             require(msg.value >= 0.00005 ether, "ERC721: Insufficient payment");
1622             _safeMint(msg.sender,quantity);
1623         } else if (quantity == FREE_SUPPLY ) {
1624             _safeMint(msg.sender,quantity);
1625         } else if (quantity == 100 ) {
1626             require(msg.value >= 0.05 ether, "ERC721: Insufficient payment");
1627             _safeMint(msg.sender,quantity);
1628         } else {
1629             require(msg.value >= 0.0002 ether, "ERC721: Insufficient payment");
1630             _safeMint(msg.sender,quantity);
1631         }
1632         
1633         emit NewMint(msg.sender, quantity);
1634     }
1635 
1636 }