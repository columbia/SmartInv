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
1380 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1381 
1382 
1383 // ERC721A Contracts v4.2.3
1384 // Creator: Chiru Labs
1385 
1386 pragma solidity ^0.8.4;
1387 
1388 
1389 /**
1390  * @dev Interface of ERC721AQueryable.
1391  */
1392 interface IERC721AQueryable is IERC721A {
1393     /**
1394      * Invalid query range (`start` >= `stop`).
1395      */
1396     error InvalidQueryRange();
1397 
1398     /**
1399      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1400      *
1401      * If the `tokenId` is out of bounds:
1402      *
1403      * - `addr = address(0)`
1404      * - `startTimestamp = 0`
1405      * - `burned = false`
1406      * - `extraData = 0`
1407      *
1408      * If the `tokenId` is burned:
1409      *
1410      * - `addr = <Address of owner before token was burned>`
1411      * - `startTimestamp = <Timestamp when token was burned>`
1412      * - `burned = true`
1413      * - `extraData = <Extra data when token was burned>`
1414      *
1415      * Otherwise:
1416      *
1417      * - `addr = <Address of owner>`
1418      * - `startTimestamp = <Timestamp of start of ownership>`
1419      * - `burned = false`
1420      * - `extraData = <Extra data at start of ownership>`
1421      */
1422     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1423 
1424     /**
1425      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1426      * See {ERC721AQueryable-explicitOwnershipOf}
1427      */
1428     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1429 
1430     /**
1431      * @dev Returns an array of token IDs owned by `owner`,
1432      * in the range [`start`, `stop`)
1433      * (i.e. `start <= tokenId < stop`).
1434      *
1435      * This function allows for tokens to be queried if the collection
1436      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1437      *
1438      * Requirements:
1439      *
1440      * - `start < stop`
1441      */
1442     function tokensOfOwnerIn(
1443         address owner,
1444         uint256 start,
1445         uint256 stop
1446     ) external view returns (uint256[] memory);
1447 
1448     /**
1449      * @dev Returns an array of token IDs owned by `owner`.
1450      *
1451      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1452      * It is meant to be called off-chain.
1453      *
1454      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1455      * multiple smaller scans if the collection is large enough to cause
1456      * an out-of-gas error (10K collections should be fine).
1457      */
1458     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1459 }
1460 
1461 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1462 
1463 
1464 // ERC721A Contracts v4.2.3
1465 // Creator: Chiru Labs
1466 
1467 pragma solidity ^0.8.4;
1468 
1469 
1470 
1471 /**
1472  * @title ERC721AQueryable.
1473  *
1474  * @dev ERC721A subclass with convenience query functions.
1475  */
1476 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1477     /**
1478      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1479      *
1480      * If the `tokenId` is out of bounds:
1481      *
1482      * - `addr = address(0)`
1483      * - `startTimestamp = 0`
1484      * - `burned = false`
1485      * - `extraData = 0`
1486      *
1487      * If the `tokenId` is burned:
1488      *
1489      * - `addr = <Address of owner before token was burned>`
1490      * - `startTimestamp = <Timestamp when token was burned>`
1491      * - `burned = true`
1492      * - `extraData = <Extra data when token was burned>`
1493      *
1494      * Otherwise:
1495      *
1496      * - `addr = <Address of owner>`
1497      * - `startTimestamp = <Timestamp of start of ownership>`
1498      * - `burned = false`
1499      * - `extraData = <Extra data at start of ownership>`
1500      */
1501     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1502         TokenOwnership memory ownership;
1503         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1504             return ownership;
1505         }
1506         ownership = _ownershipAt(tokenId);
1507         if (ownership.burned) {
1508             return ownership;
1509         }
1510         return _ownershipOf(tokenId);
1511     }
1512 
1513     /**
1514      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1515      * See {ERC721AQueryable-explicitOwnershipOf}
1516      */
1517     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1518         external
1519         view
1520         virtual
1521         override
1522         returns (TokenOwnership[] memory)
1523     {
1524         unchecked {
1525             uint256 tokenIdsLength = tokenIds.length;
1526             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1527             for (uint256 i; i != tokenIdsLength; ++i) {
1528                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1529             }
1530             return ownerships;
1531         }
1532     }
1533 
1534     /**
1535      * @dev Returns an array of token IDs owned by `owner`,
1536      * in the range [`start`, `stop`)
1537      * (i.e. `start <= tokenId < stop`).
1538      *
1539      * This function allows for tokens to be queried if the collection
1540      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1541      *
1542      * Requirements:
1543      *
1544      * - `start < stop`
1545      */
1546     function tokensOfOwnerIn(
1547         address owner,
1548         uint256 start,
1549         uint256 stop
1550     ) external view virtual override returns (uint256[] memory) {
1551         unchecked {
1552             if (start >= stop) revert InvalidQueryRange();
1553             uint256 tokenIdsIdx;
1554             uint256 stopLimit = _nextTokenId();
1555             // Set `start = max(start, _startTokenId())`.
1556             if (start < _startTokenId()) {
1557                 start = _startTokenId();
1558             }
1559             // Set `stop = min(stop, stopLimit)`.
1560             if (stop > stopLimit) {
1561                 stop = stopLimit;
1562             }
1563             uint256 tokenIdsMaxLength = balanceOf(owner);
1564             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1565             // to cater for cases where `balanceOf(owner)` is too big.
1566             if (start < stop) {
1567                 uint256 rangeLength = stop - start;
1568                 if (rangeLength < tokenIdsMaxLength) {
1569                     tokenIdsMaxLength = rangeLength;
1570                 }
1571             } else {
1572                 tokenIdsMaxLength = 0;
1573             }
1574             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1575             if (tokenIdsMaxLength == 0) {
1576                 return tokenIds;
1577             }
1578             // We need to call `explicitOwnershipOf(start)`,
1579             // because the slot at `start` may not be initialized.
1580             TokenOwnership memory ownership = explicitOwnershipOf(start);
1581             address currOwnershipAddr;
1582             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1583             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1584             if (!ownership.burned) {
1585                 currOwnershipAddr = ownership.addr;
1586             }
1587             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1588                 ownership = _ownershipAt(i);
1589                 if (ownership.burned) {
1590                     continue;
1591                 }
1592                 if (ownership.addr != address(0)) {
1593                     currOwnershipAddr = ownership.addr;
1594                 }
1595                 if (currOwnershipAddr == owner) {
1596                     tokenIds[tokenIdsIdx++] = i;
1597                 }
1598             }
1599             // Downsize the array to fit.
1600             assembly {
1601                 mstore(tokenIds, tokenIdsIdx)
1602             }
1603             return tokenIds;
1604         }
1605     }
1606 
1607     /**
1608      * @dev Returns an array of token IDs owned by `owner`.
1609      *
1610      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1611      * It is meant to be called off-chain.
1612      *
1613      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1614      * multiple smaller scans if the collection is large enough to cause
1615      * an out-of-gas error (10K collections should be fine).
1616      */
1617     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1618         unchecked {
1619             uint256 tokenIdsIdx;
1620             address currOwnershipAddr;
1621             uint256 tokenIdsLength = balanceOf(owner);
1622             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1623             TokenOwnership memory ownership;
1624             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1625                 ownership = _ownershipAt(i);
1626                 if (ownership.burned) {
1627                     continue;
1628                 }
1629                 if (ownership.addr != address(0)) {
1630                     currOwnershipAddr = ownership.addr;
1631                 }
1632                 if (currOwnershipAddr == owner) {
1633                     tokenIds[tokenIdsIdx++] = i;
1634                 }
1635             }
1636             return tokenIds;
1637         }
1638     }
1639 }
1640 
1641 // File: @openzeppelin/contracts/utils/math/Math.sol
1642 
1643 
1644 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1645 
1646 pragma solidity ^0.8.0;
1647 
1648 /**
1649  * @dev Standard math utilities missing in the Solidity language.
1650  */
1651 library Math {
1652     enum Rounding {
1653         Down, // Toward negative infinity
1654         Up, // Toward infinity
1655         Zero // Toward zero
1656     }
1657 
1658     /**
1659      * @dev Returns the largest of two numbers.
1660      */
1661     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1662         return a > b ? a : b;
1663     }
1664 
1665     /**
1666      * @dev Returns the smallest of two numbers.
1667      */
1668     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1669         return a < b ? a : b;
1670     }
1671 
1672     /**
1673      * @dev Returns the average of two numbers. The result is rounded towards
1674      * zero.
1675      */
1676     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1677         // (a + b) / 2 can overflow.
1678         return (a & b) + (a ^ b) / 2;
1679     }
1680 
1681     /**
1682      * @dev Returns the ceiling of the division of two numbers.
1683      *
1684      * This differs from standard division with `/` in that it rounds up instead
1685      * of rounding down.
1686      */
1687     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1688         // (a + b - 1) / b can overflow on addition, so we distribute.
1689         return a == 0 ? 0 : (a - 1) / b + 1;
1690     }
1691 
1692     /**
1693      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1694      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1695      * with further edits by Uniswap Labs also under MIT license.
1696      */
1697     function mulDiv(
1698         uint256 x,
1699         uint256 y,
1700         uint256 denominator
1701     ) internal pure returns (uint256 result) {
1702         unchecked {
1703             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1704             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1705             // variables such that product = prod1 * 2^256 + prod0.
1706             uint256 prod0; // Least significant 256 bits of the product
1707             uint256 prod1; // Most significant 256 bits of the product
1708             assembly {
1709                 let mm := mulmod(x, y, not(0))
1710                 prod0 := mul(x, y)
1711                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1712             }
1713 
1714             // Handle non-overflow cases, 256 by 256 division.
1715             if (prod1 == 0) {
1716                 return prod0 / denominator;
1717             }
1718 
1719             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1720             require(denominator > prod1);
1721 
1722             ///////////////////////////////////////////////
1723             // 512 by 256 division.
1724             ///////////////////////////////////////////////
1725 
1726             // Make division exact by subtracting the remainder from [prod1 prod0].
1727             uint256 remainder;
1728             assembly {
1729                 // Compute remainder using mulmod.
1730                 remainder := mulmod(x, y, denominator)
1731 
1732                 // Subtract 256 bit number from 512 bit number.
1733                 prod1 := sub(prod1, gt(remainder, prod0))
1734                 prod0 := sub(prod0, remainder)
1735             }
1736 
1737             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1738             // See https://cs.stackexchange.com/q/138556/92363.
1739 
1740             // Does not overflow because the denominator cannot be zero at this stage in the function.
1741             uint256 twos = denominator & (~denominator + 1);
1742             assembly {
1743                 // Divide denominator by twos.
1744                 denominator := div(denominator, twos)
1745 
1746                 // Divide [prod1 prod0] by twos.
1747                 prod0 := div(prod0, twos)
1748 
1749                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1750                 twos := add(div(sub(0, twos), twos), 1)
1751             }
1752 
1753             // Shift in bits from prod1 into prod0.
1754             prod0 |= prod1 * twos;
1755 
1756             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1757             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1758             // four bits. That is, denominator * inv = 1 mod 2^4.
1759             uint256 inverse = (3 * denominator) ^ 2;
1760 
1761             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1762             // in modular arithmetic, doubling the correct bits in each step.
1763             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1764             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1765             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1766             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1767             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1768             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1769 
1770             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1771             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1772             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1773             // is no longer required.
1774             result = prod0 * inverse;
1775             return result;
1776         }
1777     }
1778 
1779     /**
1780      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1781      */
1782     function mulDiv(
1783         uint256 x,
1784         uint256 y,
1785         uint256 denominator,
1786         Rounding rounding
1787     ) internal pure returns (uint256) {
1788         uint256 result = mulDiv(x, y, denominator);
1789         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1790             result += 1;
1791         }
1792         return result;
1793     }
1794 
1795     /**
1796      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1797      *
1798      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1799      */
1800     function sqrt(uint256 a) internal pure returns (uint256) {
1801         if (a == 0) {
1802             return 0;
1803         }
1804 
1805         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1806         //
1807         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1808         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1809         //
1810         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1811         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1812         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1813         //
1814         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1815         uint256 result = 1 << (log2(a) >> 1);
1816 
1817         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1818         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1819         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1820         // into the expected uint128 result.
1821         unchecked {
1822             result = (result + a / result) >> 1;
1823             result = (result + a / result) >> 1;
1824             result = (result + a / result) >> 1;
1825             result = (result + a / result) >> 1;
1826             result = (result + a / result) >> 1;
1827             result = (result + a / result) >> 1;
1828             result = (result + a / result) >> 1;
1829             return min(result, a / result);
1830         }
1831     }
1832 
1833     /**
1834      * @notice Calculates sqrt(a), following the selected rounding direction.
1835      */
1836     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1837         unchecked {
1838             uint256 result = sqrt(a);
1839             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1840         }
1841     }
1842 
1843     /**
1844      * @dev Return the log in base 2, rounded down, of a positive value.
1845      * Returns 0 if given 0.
1846      */
1847     function log2(uint256 value) internal pure returns (uint256) {
1848         uint256 result = 0;
1849         unchecked {
1850             if (value >> 128 > 0) {
1851                 value >>= 128;
1852                 result += 128;
1853             }
1854             if (value >> 64 > 0) {
1855                 value >>= 64;
1856                 result += 64;
1857             }
1858             if (value >> 32 > 0) {
1859                 value >>= 32;
1860                 result += 32;
1861             }
1862             if (value >> 16 > 0) {
1863                 value >>= 16;
1864                 result += 16;
1865             }
1866             if (value >> 8 > 0) {
1867                 value >>= 8;
1868                 result += 8;
1869             }
1870             if (value >> 4 > 0) {
1871                 value >>= 4;
1872                 result += 4;
1873             }
1874             if (value >> 2 > 0) {
1875                 value >>= 2;
1876                 result += 2;
1877             }
1878             if (value >> 1 > 0) {
1879                 result += 1;
1880             }
1881         }
1882         return result;
1883     }
1884 
1885     /**
1886      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1887      * Returns 0 if given 0.
1888      */
1889     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1890         unchecked {
1891             uint256 result = log2(value);
1892             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1893         }
1894     }
1895 
1896     /**
1897      * @dev Return the log in base 10, rounded down, of a positive value.
1898      * Returns 0 if given 0.
1899      */
1900     function log10(uint256 value) internal pure returns (uint256) {
1901         uint256 result = 0;
1902         unchecked {
1903             if (value >= 10**64) {
1904                 value /= 10**64;
1905                 result += 64;
1906             }
1907             if (value >= 10**32) {
1908                 value /= 10**32;
1909                 result += 32;
1910             }
1911             if (value >= 10**16) {
1912                 value /= 10**16;
1913                 result += 16;
1914             }
1915             if (value >= 10**8) {
1916                 value /= 10**8;
1917                 result += 8;
1918             }
1919             if (value >= 10**4) {
1920                 value /= 10**4;
1921                 result += 4;
1922             }
1923             if (value >= 10**2) {
1924                 value /= 10**2;
1925                 result += 2;
1926             }
1927             if (value >= 10**1) {
1928                 result += 1;
1929             }
1930         }
1931         return result;
1932     }
1933 
1934     /**
1935      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1936      * Returns 0 if given 0.
1937      */
1938     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1939         unchecked {
1940             uint256 result = log10(value);
1941             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1942         }
1943     }
1944 
1945     /**
1946      * @dev Return the log in base 256, rounded down, of a positive value.
1947      * Returns 0 if given 0.
1948      *
1949      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1950      */
1951     function log256(uint256 value) internal pure returns (uint256) {
1952         uint256 result = 0;
1953         unchecked {
1954             if (value >> 128 > 0) {
1955                 value >>= 128;
1956                 result += 16;
1957             }
1958             if (value >> 64 > 0) {
1959                 value >>= 64;
1960                 result += 8;
1961             }
1962             if (value >> 32 > 0) {
1963                 value >>= 32;
1964                 result += 4;
1965             }
1966             if (value >> 16 > 0) {
1967                 value >>= 16;
1968                 result += 2;
1969             }
1970             if (value >> 8 > 0) {
1971                 result += 1;
1972             }
1973         }
1974         return result;
1975     }
1976 
1977     /**
1978      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1979      * Returns 0 if given 0.
1980      */
1981     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1982         unchecked {
1983             uint256 result = log256(value);
1984             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1985         }
1986     }
1987 }
1988 
1989 // File: @openzeppelin/contracts/utils/Strings.sol
1990 
1991 
1992 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1993 
1994 pragma solidity ^0.8.0;
1995 
1996 
1997 /**
1998  * @dev String operations.
1999  */
2000 library Strings {
2001     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2002     uint8 private constant _ADDRESS_LENGTH = 20;
2003 
2004     /**
2005      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2006      */
2007     function toString(uint256 value) internal pure returns (string memory) {
2008         unchecked {
2009             uint256 length = Math.log10(value) + 1;
2010             string memory buffer = new string(length);
2011             uint256 ptr;
2012             /// @solidity memory-safe-assembly
2013             assembly {
2014                 ptr := add(buffer, add(32, length))
2015             }
2016             while (true) {
2017                 ptr--;
2018                 /// @solidity memory-safe-assembly
2019                 assembly {
2020                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2021                 }
2022                 value /= 10;
2023                 if (value == 0) break;
2024             }
2025             return buffer;
2026         }
2027     }
2028 
2029     /**
2030      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2031      */
2032     function toHexString(uint256 value) internal pure returns (string memory) {
2033         unchecked {
2034             return toHexString(value, Math.log256(value) + 1);
2035         }
2036     }
2037 
2038     /**
2039      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2040      */
2041     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2042         bytes memory buffer = new bytes(2 * length + 2);
2043         buffer[0] = "0";
2044         buffer[1] = "x";
2045         for (uint256 i = 2 * length + 1; i > 1; --i) {
2046             buffer[i] = _SYMBOLS[value & 0xf];
2047             value >>= 4;
2048         }
2049         require(value == 0, "Strings: hex length insufficient");
2050         return string(buffer);
2051     }
2052 
2053     /**
2054      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2055      */
2056     function toHexString(address addr) internal pure returns (string memory) {
2057         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2058     }
2059 }
2060 
2061 // File: @openzeppelin/contracts/utils/Context.sol
2062 
2063 
2064 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2065 
2066 pragma solidity ^0.8.0;
2067 
2068 /**
2069  * @dev Provides information about the current execution context, including the
2070  * sender of the transaction and its data. While these are generally available
2071  * via msg.sender and msg.data, they should not be accessed in such a direct
2072  * manner, since when dealing with meta-transactions the account sending and
2073  * paying for execution may not be the actual sender (as far as an application
2074  * is concerned).
2075  *
2076  * This contract is only required for intermediate, library-like contracts.
2077  */
2078 abstract contract Context {
2079     function _msgSender() internal view virtual returns (address) {
2080         return msg.sender;
2081     }
2082 
2083     function _msgData() internal view virtual returns (bytes calldata) {
2084         return msg.data;
2085     }
2086 }
2087 
2088 // File: @openzeppelin/contracts/access/Ownable.sol
2089 
2090 
2091 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2092 
2093 pragma solidity ^0.8.0;
2094 
2095 
2096 /**
2097  * @dev Contract module which provides a basic access control mechanism, where
2098  * there is an account (an owner) that can be granted exclusive access to
2099  * specific functions.
2100  *
2101  * By default, the owner account will be the one that deploys the contract. This
2102  * can later be changed with {transferOwnership}.
2103  *
2104  * This module is used through inheritance. It will make available the modifier
2105  * `onlyOwner`, which can be applied to your functions to restrict their use to
2106  * the owner.
2107  */
2108 abstract contract Ownable is Context {
2109     address private _owner;
2110 
2111     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2112 
2113     /**
2114      * @dev Initializes the contract setting the deployer as the initial owner.
2115      */
2116     constructor() {
2117         _transferOwnership(_msgSender());
2118     }
2119 
2120     /**
2121      * @dev Throws if called by any account other than the owner.
2122      */
2123     modifier onlyOwner() {
2124         _checkOwner();
2125         _;
2126     }
2127 
2128     /**
2129      * @dev Returns the address of the current owner.
2130      */
2131     function owner() public view virtual returns (address) {
2132         return _owner;
2133     }
2134 
2135     /**
2136      * @dev Throws if the sender is not the owner.
2137      */
2138     function _checkOwner() internal view virtual {
2139         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2140     }
2141 
2142     /**
2143      * @dev Leaves the contract without owner. It will not be possible to call
2144      * `onlyOwner` functions anymore. Can only be called by the current owner.
2145      *
2146      * NOTE: Renouncing ownership will leave the contract without an owner,
2147      * thereby removing any functionality that is only available to the owner.
2148      */
2149     function renounceOwnership() public virtual onlyOwner {
2150         _transferOwnership(address(0));
2151     }
2152 
2153     /**
2154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2155      * Can only be called by the current owner.
2156      */
2157     function transferOwnership(address newOwner) public virtual onlyOwner {
2158         require(newOwner != address(0), "Ownable: new owner is the zero address");
2159         _transferOwnership(newOwner);
2160     }
2161 
2162     /**
2163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2164      * Internal function without access restriction.
2165      */
2166     function _transferOwnership(address newOwner) internal virtual {
2167         address oldOwner = _owner;
2168         _owner = newOwner;
2169         emit OwnershipTransferred(oldOwner, newOwner);
2170     }
2171 }
2172 
2173 // File: PunkRocks.sol
2174 
2175 
2176 pragma solidity ^0.8.4;
2177 
2178 
2179 
2180 
2181 
2182 
2183 contract PunkRocks is ERC721AQueryable, Ownable {
2184   using Strings for uint256;
2185 
2186   uint256 public TOTAL_MAX_SUPPLY = 2222;
2187   uint256 public totalFreeMints = 2222;
2188   uint256 public maxFreeMintPerWallet = 1;
2189   uint256 public maxPublicMintPerWallet = 5;
2190   uint256 public publicTokenPrice = .002 ether;
2191   string _contractURI;
2192 
2193   bool public saleStarted = false;
2194   uint256 public freeMintCount;
2195 
2196   mapping(address => uint256) public freeMintClaimed;
2197   
2198 
2199   string private _baseTokenURI;
2200 
2201   constructor() ERC721A("Punk Rocks", "PUNKROCK") {}
2202 
2203   modifier callerIsUser() {
2204     require(tx.origin == msg.sender, 'Punk Rocks: The caller is another contract');
2205     _;
2206   }
2207 
2208   modifier underMaxSupply(uint256 _quantity) {
2209     require(
2210       _totalMinted() + _quantity <= TOTAL_MAX_SUPPLY,
2211       "Punk Rocks Over max supply"
2212     );
2213     _;
2214   }
2215 
2216   function setTotalMaxSupply(uint256 _newSupply) external onlyOwner {
2217       TOTAL_MAX_SUPPLY = _newSupply;
2218   }
2219 
2220 
2221   function setPublicTokenPrice(uint256 _newPrice) external onlyOwner {
2222       publicTokenPrice = _newPrice;
2223   }
2224   function mint(uint256 _quantity) external payable callerIsUser underMaxSupply(_quantity) {
2225     require(balanceOf(msg.sender) < maxPublicMintPerWallet, "Punk Rocks: Mint limit exceeded");
2226     require(saleStarted, "Punk Rocks: Sale has not started");
2227     if (_totalMinted() < (TOTAL_MAX_SUPPLY)) {
2228       if (freeMintCount >= totalFreeMints) {
2229         require(msg.value >= _quantity * publicTokenPrice, "Punk Rocks: More ETH required");
2230         _mint(msg.sender, _quantity);
2231       } else if (freeMintClaimed[msg.sender] < maxFreeMintPerWallet) {
2232         uint256 _mintableFreeQuantity = maxFreeMintPerWallet - freeMintClaimed[msg.sender];
2233         if (_quantity <= _mintableFreeQuantity) {
2234           freeMintCount += _quantity;
2235           freeMintClaimed[msg.sender] += _quantity;
2236         } else {
2237           freeMintCount += _mintableFreeQuantity;
2238           freeMintClaimed[msg.sender] += _mintableFreeQuantity;
2239           require(
2240             msg.value >= (_quantity - _mintableFreeQuantity) * publicTokenPrice,
2241             "Punk Rocks: Not enough ETH"
2242           );
2243         }
2244         _mint(msg.sender, _quantity);
2245       } else {
2246         require(msg.value >= (_quantity * publicTokenPrice), "Punk Rocks: Not enough ETH");
2247         _mint(msg.sender, _quantity);
2248       }
2249     }
2250   }
2251 
2252   function _baseURI() internal view virtual override returns (string memory) {
2253     return _baseTokenURI;
2254   }
2255 
2256   function tokenURI(uint256 tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
2257     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2258 
2259     string memory baseURI = _baseURI();
2260     return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2261   }
2262 
2263   function numberMinted(address owner) public view returns (uint256) {
2264     return _numberMinted(owner);
2265   }
2266 
2267   function _startTokenId() internal view virtual override returns (uint256) {
2268     return 1;
2269   }
2270 
2271   function ownerMint(uint256 _numberToMint) external onlyOwner underMaxSupply(_numberToMint) {
2272     _mint(msg.sender, _numberToMint);
2273   }
2274 
2275   function ownerMintToAddress(address _recipient, uint256 _numberToMint)
2276     external
2277     onlyOwner
2278     underMaxSupply(_numberToMint)
2279   {
2280     _mint(_recipient, _numberToMint);
2281   }
2282 
2283   function setFreeMintCount(uint256 _count) external onlyOwner {
2284     totalFreeMints = _count;
2285   }
2286 
2287   function setMaxFreeMintPerWallet(uint256 _count) external onlyOwner {
2288     maxFreeMintPerWallet = _count;
2289   }
2290 
2291   function setMaxPublicMintPerWallet(uint256 _count) external onlyOwner {
2292     maxPublicMintPerWallet = _count;
2293   }
2294 
2295   function setBaseURI(string calldata baseURI) external onlyOwner {
2296     _baseTokenURI = baseURI;
2297   }
2298 
2299   // Storefront metadata
2300   // https://docs.opensea.io/docs/contract-level-metadata
2301   function contractURI() public view returns (string memory) {
2302     return _contractURI;
2303   }
2304 
2305   function setContractURI(string memory _URI) external onlyOwner {
2306     _contractURI = _URI;
2307   }
2308 
2309   function withdrawFunds() external onlyOwner {
2310     (bool success, ) = msg.sender.call{ value: address(this).balance }("");
2311     require(success, "Punk Rocks: Transfer failed");
2312   }
2313 
2314   function withdrawFundsToAddress(address _address, uint256 amount) external onlyOwner {
2315     (bool success, ) = _address.call{ value: amount }("");
2316     require(success, "Punk Rocks: Transfer failed");
2317   }
2318 
2319   function flipSaleStarted() external onlyOwner {
2320     saleStarted = !saleStarted;
2321   }
2322 }