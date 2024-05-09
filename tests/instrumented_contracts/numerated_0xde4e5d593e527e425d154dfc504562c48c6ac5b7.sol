1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 // ERC721A Contracts v4.2.3
5 // Creator: Chiru Labs
6 
7 // ERC721A Contracts v4.2.3
8 // Creator: Chiru Labs
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
288  * @dev Interface of ERC721 token receiver.
289  */
290 interface ERC721A__IERC721Receiver {
291     function onERC721Received(
292         address operator,
293         address from,
294         uint256 tokenId,
295         bytes calldata data
296     ) external returns (bytes4);
297 }
298 
299 /**
300  * @title ERC721A
301  *
302  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
303  * Non-Fungible Token Standard, including the Metadata extension.
304  * Optimized for lower gas during batch mints.
305  *
306  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
307  * starting from `_startTokenId()`.
308  *
309  * Assumptions:
310  *
311  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
312  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
313  */
314 contract ERC721A is IERC721A {
315     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
316     struct TokenApprovalRef {
317         address value;
318     }
319 
320     // =============================================================
321     //                           CONSTANTS
322     // =============================================================
323 
324     // Mask of an entry in packed address data.
325     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
326 
327     // The bit position of `numberMinted` in packed address data.
328     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
329 
330     // The bit position of `numberBurned` in packed address data.
331     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
332 
333     // The bit position of `aux` in packed address data.
334     uint256 private constant _BITPOS_AUX = 192;
335 
336     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
337     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
338 
339     // The bit position of `startTimestamp` in packed ownership.
340     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
341 
342     // The bit mask of the `burned` bit in packed ownership.
343     uint256 private constant _BITMASK_BURNED = 1 << 224;
344 
345     // The bit position of the `nextInitialized` bit in packed ownership.
346     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
347 
348     // The bit mask of the `nextInitialized` bit in packed ownership.
349     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
350 
351     // The bit position of `extraData` in packed ownership.
352     uint256 private constant _BITPOS_EXTRA_DATA = 232;
353 
354     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
355     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
356 
357     // The mask of the lower 160 bits for addresses.
358     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
359 
360     // The maximum `quantity` that can be minted with {_mintERC2309}.
361     // This limit is to prevent overflows on the address data entries.
362     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
363     // is required to cause an overflow, which is unrealistic.
364     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
365 
366     // The `Transfer` event signature is given by:
367     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
368     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
369         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
370 
371     // =============================================================
372     //                            STORAGE
373     // =============================================================
374 
375     // The next token ID to be minted.
376     uint256 private _currentIndex;
377 
378     // The number of tokens burned.
379     uint256 private _burnCounter;
380 
381     // Token name
382     string private _name;
383 
384     // Token symbol
385     string private _symbol;
386 
387     // Mapping from token ID to ownership details
388     // An empty struct value does not necessarily mean the token is unowned.
389     // See {_packedOwnershipOf} implementation for details.
390     //
391     // Bits Layout:
392     // - [0..159]   `addr`
393     // - [160..223] `startTimestamp`
394     // - [224]      `burned`
395     // - [225]      `nextInitialized`
396     // - [232..255] `extraData`
397     mapping(uint256 => uint256) private _packedOwnerships;
398 
399     // Mapping owner address to address data.
400     //
401     // Bits Layout:
402     // - [0..63]    `balance`
403     // - [64..127]  `numberMinted`
404     // - [128..191] `numberBurned`
405     // - [192..255] `aux`
406     mapping(address => uint256) private _packedAddressData;
407 
408     // Mapping from token ID to approved address.
409     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
410 
411     // Mapping from owner to operator approvals
412     mapping(address => mapping(address => bool)) private _operatorApprovals;
413 
414     // =============================================================
415     //                          CONSTRUCTOR
416     // =============================================================
417 
418     constructor(string memory name_, string memory symbol_) {
419         _name = name_;
420         _symbol = symbol_;
421         _currentIndex = _startTokenId();
422     }
423 
424     // =============================================================
425     //                   TOKEN COUNTING OPERATIONS
426     // =============================================================
427 
428     /**
429      * @dev Returns the starting token ID.
430      * To change the starting token ID, please override this function.
431      */
432     function _startTokenId() internal view virtual returns (uint256) {
433         return 0;
434     }
435 
436     /**
437      * @dev Returns the next token ID to be minted.
438      */
439     function _nextTokenId() internal view virtual returns (uint256) {
440         return _currentIndex;
441     }
442 
443     /**
444      * @dev Returns the total number of tokens in existence.
445      * Burned tokens will reduce the count.
446      * To get the total number of tokens minted, please see {_totalMinted}.
447      */
448     function totalSupply() public view virtual override returns (uint256) {
449         // Counter underflow is impossible as _burnCounter cannot be incremented
450         // more than `_currentIndex - _startTokenId()` times.
451         unchecked {
452             return _currentIndex - _burnCounter - _startTokenId();
453         }
454     }
455 
456     /**
457      * @dev Returns the total amount of tokens minted in the contract.
458      */
459     function _totalMinted() internal view virtual returns (uint256) {
460         // Counter underflow is impossible as `_currentIndex` does not decrement,
461         // and it is initialized to `_startTokenId()`.
462         unchecked {
463             return _currentIndex - _startTokenId();
464         }
465     }
466 
467     /**
468      * @dev Returns the total number of tokens burned.
469      */
470     function _totalBurned() internal view virtual returns (uint256) {
471         return _burnCounter;
472     }
473 
474     // =============================================================
475     //                    ADDRESS DATA OPERATIONS
476     // =============================================================
477 
478     /**
479      * @dev Returns the number of tokens in `owner`'s account.
480      */
481     function balanceOf(address owner) public view virtual override returns (uint256) {
482         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
483         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
484     }
485 
486     /**
487      * Returns the number of tokens minted by `owner`.
488      */
489     function _numberMinted(address owner) internal view returns (uint256) {
490         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
491     }
492 
493     /**
494      * Returns the number of tokens burned by or on behalf of `owner`.
495      */
496     function _numberBurned(address owner) internal view returns (uint256) {
497         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
498     }
499 
500     /**
501      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
502      */
503     function _getAux(address owner) internal view returns (uint64) {
504         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
505     }
506 
507     /**
508      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
509      * If there are multiple variables, please pack them into a uint64.
510      */
511     function _setAux(address owner, uint64 aux) internal virtual {
512         uint256 packed = _packedAddressData[owner];
513         uint256 auxCasted;
514         // Cast `aux` with assembly to avoid redundant masking.
515         assembly {
516             auxCasted := aux
517         }
518         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
519         _packedAddressData[owner] = packed;
520     }
521 
522     // =============================================================
523     //                            IERC165
524     // =============================================================
525 
526     /**
527      * @dev Returns true if this contract implements the interface defined by
528      * `interfaceId`. See the corresponding
529      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
530      * to learn more about how these ids are created.
531      *
532      * This function call must use less than 30000 gas.
533      */
534     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
535         // The interface IDs are constants representing the first 4 bytes
536         // of the XOR of all function selectors in the interface.
537         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
538         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
539         return
540             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
541             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
542             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
543     }
544 
545     // =============================================================
546     //                        IERC721Metadata
547     // =============================================================
548 
549     /**
550      * @dev Returns the token collection name.
551      */
552     function name() public view virtual override returns (string memory) {
553         return _name;
554     }
555 
556     /**
557      * @dev Returns the token collection symbol.
558      */
559     function symbol() public view virtual override returns (string memory) {
560         return _symbol;
561     }
562 
563     /**
564      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
565      */
566     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
567         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
568 
569         string memory baseURI = _baseURI();
570         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
571     }
572 
573     /**
574      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
575      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
576      * by default, it can be overridden in child contracts.
577      */
578     function _baseURI() internal view virtual returns (string memory) {
579         return '';
580     }
581 
582     // =============================================================
583     //                     OWNERSHIPS OPERATIONS
584     // =============================================================
585 
586     /**
587      * @dev Returns the owner of the `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
594         return address(uint160(_packedOwnershipOf(tokenId)));
595     }
596 
597     /**
598      * @dev Gas spent here starts off proportional to the maximum mint batch size.
599      * It gradually moves to O(1) as tokens get transferred around over time.
600      */
601     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
602         return _unpackedOwnership(_packedOwnershipOf(tokenId));
603     }
604 
605     /**
606      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
607      */
608     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
609         return _unpackedOwnership(_packedOwnerships[index]);
610     }
611 
612     /**
613      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
614      */
615     function _initializeOwnershipAt(uint256 index) internal virtual {
616         if (_packedOwnerships[index] == 0) {
617             _packedOwnerships[index] = _packedOwnershipOf(index);
618         }
619     }
620 
621     /**
622      * Returns the packed ownership data of `tokenId`.
623      */
624     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
625         if (_startTokenId() <= tokenId) {
626             packed = _packedOwnerships[tokenId];
627             // If not burned.
628             if (packed & _BITMASK_BURNED == 0) {
629                 // If the data at the starting slot does not exist, start the scan.
630                 if (packed == 0) {
631                     if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
632                     // Invariant:
633                     // There will always be an initialized ownership slot
634                     // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
635                     // before an unintialized ownership slot
636                     // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
637                     // Hence, `tokenId` will not underflow.
638                     //
639                     // We can directly compare the packed value.
640                     // If the address is zero, packed will be zero.
641                     for (;;) {
642                         unchecked {
643                             packed = _packedOwnerships[--tokenId];
644                         }
645                         if (packed == 0) continue;
646                         return packed;
647                     }
648                 }
649                 // Otherwise, the data exists and is not burned. We can skip the scan.
650                 // This is possible because we have already achieved the target condition.
651                 // This saves 2143 gas on transfers of initialized tokens.
652                 return packed;
653             }
654         }
655         _revert(OwnerQueryForNonexistentToken.selector);
656     }
657 
658     /**
659      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
660      */
661     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
662         ownership.addr = address(uint160(packed));
663         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
664         ownership.burned = packed & _BITMASK_BURNED != 0;
665         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
666     }
667 
668     /**
669      * @dev Packs ownership data into a single uint256.
670      */
671     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
672         assembly {
673             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
674             owner := and(owner, _BITMASK_ADDRESS)
675             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
676             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
677         }
678     }
679 
680     /**
681      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
682      */
683     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
684         // For branchless setting of the `nextInitialized` flag.
685         assembly {
686             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
687             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
688         }
689     }
690 
691     // =============================================================
692     //                      APPROVAL OPERATIONS
693     // =============================================================
694 
695     /**
696      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
697      *
698      * Requirements:
699      *
700      * - The caller must own the token or be an approved operator.
701      */
702     function approve(address to, uint256 tokenId) public payable virtual override {
703         _approve(to, tokenId, true);
704     }
705 
706     /**
707      * @dev Returns the account approved for `tokenId` token.
708      *
709      * Requirements:
710      *
711      * - `tokenId` must exist.
712      */
713     function getApproved(uint256 tokenId) public view virtual override returns (address) {
714         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
715 
716         return _tokenApprovals[tokenId].value;
717     }
718 
719     /**
720      * @dev Approve or remove `operator` as an operator for the caller.
721      * Operators can call {transferFrom} or {safeTransferFrom}
722      * for any token owned by the caller.
723      *
724      * Requirements:
725      *
726      * - The `operator` cannot be the caller.
727      *
728      * Emits an {ApprovalForAll} event.
729      */
730     function setApprovalForAll(address operator, bool approved) public virtual override {
731         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
732         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
733     }
734 
735     /**
736      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
737      *
738      * See {setApprovalForAll}.
739      */
740     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
741         return _operatorApprovals[owner][operator];
742     }
743 
744     /**
745      * @dev Returns whether `tokenId` exists.
746      *
747      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
748      *
749      * Tokens start existing when they are minted. See {_mint}.
750      */
751     function _exists(uint256 tokenId) internal view virtual returns (bool) {
752         return
753             _startTokenId() <= tokenId &&
754             tokenId < _currentIndex && // If within bounds,
755             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
756     }
757 
758     /**
759      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
760      */
761     function _isSenderApprovedOrOwner(
762         address approvedAddress,
763         address owner,
764         address msgSender
765     ) private pure returns (bool result) {
766         assembly {
767             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
768             owner := and(owner, _BITMASK_ADDRESS)
769             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
770             msgSender := and(msgSender, _BITMASK_ADDRESS)
771             // `msgSender == owner || msgSender == approvedAddress`.
772             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
773         }
774     }
775 
776     /**
777      * @dev Returns the storage slot and value for the approved address of `tokenId`.
778      */
779     function _getApprovedSlotAndAddress(uint256 tokenId)
780         private
781         view
782         returns (uint256 approvedAddressSlot, address approvedAddress)
783     {
784         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
785         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
786         assembly {
787             approvedAddressSlot := tokenApproval.slot
788             approvedAddress := sload(approvedAddressSlot)
789         }
790     }
791 
792     // =============================================================
793     //                      TRANSFER OPERATIONS
794     // =============================================================
795 
796     /**
797      * @dev Transfers `tokenId` from `from` to `to`.
798      *
799      * Requirements:
800      *
801      * - `from` cannot be the zero address.
802      * - `to` cannot be the zero address.
803      * - `tokenId` token must be owned by `from`.
804      * - If the caller is not `from`, it must be approved to move this token
805      * by either {approve} or {setApprovalForAll}.
806      *
807      * Emits a {Transfer} event.
808      */
809     function transferFrom(
810         address from,
811         address to,
812         uint256 tokenId
813     ) public payable virtual override {
814         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
815 
816         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
817         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
818 
819         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
820 
821         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
822 
823         // The nested ifs save around 20+ gas over a compound boolean condition.
824         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
825             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
826 
827         _beforeTokenTransfers(from, to, tokenId, 1);
828 
829         // Clear approvals from the previous owner.
830         assembly {
831             if approvedAddress {
832                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
833                 sstore(approvedAddressSlot, 0)
834             }
835         }
836 
837         // Underflow of the sender's balance is impossible because we check for
838         // ownership above and the recipient's balance can't realistically overflow.
839         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
840         unchecked {
841             // We can directly increment and decrement the balances.
842             --_packedAddressData[from]; // Updates: `balance -= 1`.
843             ++_packedAddressData[to]; // Updates: `balance += 1`.
844 
845             // Updates:
846             // - `address` to the next owner.
847             // - `startTimestamp` to the timestamp of transfering.
848             // - `burned` to `false`.
849             // - `nextInitialized` to `true`.
850             _packedOwnerships[tokenId] = _packOwnershipData(
851                 to,
852                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
853             );
854 
855             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
856             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
857                 uint256 nextTokenId = tokenId + 1;
858                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
859                 if (_packedOwnerships[nextTokenId] == 0) {
860                     // If the next slot is within bounds.
861                     if (nextTokenId != _currentIndex) {
862                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
863                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
864                     }
865                 }
866             }
867         }
868 
869         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
870         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
871         assembly {
872             // Emit the `Transfer` event.
873             log4(
874                 0, // Start of data (0, since no data).
875                 0, // End of data (0, since no data).
876                 _TRANSFER_EVENT_SIGNATURE, // Signature.
877                 from, // `from`.
878                 toMasked, // `to`.
879                 tokenId // `tokenId`.
880             )
881         }
882         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
883 
884         _afterTokenTransfers(from, to, tokenId, 1);
885     }
886 
887     /**
888      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
889      */
890     function safeTransferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public payable virtual override {
895         safeTransferFrom(from, to, tokenId, '');
896     }
897 
898     /**
899      * @dev Safely transfers `tokenId` token from `from` to `to`.
900      *
901      * Requirements:
902      *
903      * - `from` cannot be the zero address.
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must exist and be owned by `from`.
906      * - If the caller is not `from`, it must be approved to move this token
907      * by either {approve} or {setApprovalForAll}.
908      * - If `to` refers to a smart contract, it must implement
909      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
910      *
911      * Emits a {Transfer} event.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) public payable virtual override {
919         transferFrom(from, to, tokenId);
920         if (to.code.length != 0)
921             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
922                 _revert(TransferToNonERC721ReceiverImplementer.selector);
923             }
924     }
925 
926     /**
927      * @dev Hook that is called before a set of serially-ordered token IDs
928      * are about to be transferred. This includes minting.
929      * And also called before burning one token.
930      *
931      * `startTokenId` - the first token ID to be transferred.
932      * `quantity` - the amount to be transferred.
933      *
934      * Calling conditions:
935      *
936      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
937      * transferred to `to`.
938      * - When `from` is zero, `tokenId` will be minted for `to`.
939      * - When `to` is zero, `tokenId` will be burned by `from`.
940      * - `from` and `to` are never both zero.
941      */
942     function _beforeTokenTransfers(
943         address from,
944         address to,
945         uint256 startTokenId,
946         uint256 quantity
947     ) internal virtual {}
948 
949     /**
950      * @dev Hook that is called after a set of serially-ordered token IDs
951      * have been transferred. This includes minting.
952      * And also called after one token has been burned.
953      *
954      * `startTokenId` - the first token ID to be transferred.
955      * `quantity` - the amount to be transferred.
956      *
957      * Calling conditions:
958      *
959      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
960      * transferred to `to`.
961      * - When `from` is zero, `tokenId` has been minted for `to`.
962      * - When `to` is zero, `tokenId` has been burned by `from`.
963      * - `from` and `to` are never both zero.
964      */
965     function _afterTokenTransfers(
966         address from,
967         address to,
968         uint256 startTokenId,
969         uint256 quantity
970     ) internal virtual {}
971 
972     /**
973      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
974      *
975      * `from` - Previous owner of the given token ID.
976      * `to` - Target address that will receive the token.
977      * `tokenId` - Token ID to be transferred.
978      * `_data` - Optional data to send along with the call.
979      *
980      * Returns whether the call correctly returned the expected magic value.
981      */
982     function _checkContractOnERC721Received(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory _data
987     ) private returns (bool) {
988         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
989             bytes4 retval
990         ) {
991             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
992         } catch (bytes memory reason) {
993             if (reason.length == 0) {
994                 _revert(TransferToNonERC721ReceiverImplementer.selector);
995             }
996             assembly {
997                 revert(add(32, reason), mload(reason))
998             }
999         }
1000     }
1001 
1002     // =============================================================
1003     //                        MINT OPERATIONS
1004     // =============================================================
1005 
1006     /**
1007      * @dev Mints `quantity` tokens and transfers them to `to`.
1008      *
1009      * Requirements:
1010      *
1011      * - `to` cannot be the zero address.
1012      * - `quantity` must be greater than 0.
1013      *
1014      * Emits a {Transfer} event for each mint.
1015      */
1016     function _mint(address to, uint256 quantity) internal virtual {
1017         uint256 startTokenId = _currentIndex;
1018         if (quantity == 0) _revert(MintZeroQuantity.selector);
1019 
1020         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1021 
1022         // Overflows are incredibly unrealistic.
1023         // `balance` and `numberMinted` have a maximum limit of 2**64.
1024         // `tokenId` has a maximum limit of 2**256.
1025         unchecked {
1026             // Updates:
1027             // - `address` to the owner.
1028             // - `startTimestamp` to the timestamp of minting.
1029             // - `burned` to `false`.
1030             // - `nextInitialized` to `quantity == 1`.
1031             _packedOwnerships[startTokenId] = _packOwnershipData(
1032                 to,
1033                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1034             );
1035 
1036             // Updates:
1037             // - `balance += quantity`.
1038             // - `numberMinted += quantity`.
1039             //
1040             // We can directly add to the `balance` and `numberMinted`.
1041             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1042 
1043             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1044             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1045 
1046             if (toMasked == 0) _revert(MintToZeroAddress.selector);
1047 
1048             uint256 end = startTokenId + quantity;
1049             uint256 tokenId = startTokenId;
1050 
1051             do {
1052                 assembly {
1053                     // Emit the `Transfer` event.
1054                     log4(
1055                         0, // Start of data (0, since no data).
1056                         0, // End of data (0, since no data).
1057                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1058                         0, // `address(0)`.
1059                         toMasked, // `to`.
1060                         tokenId // `tokenId`.
1061                     )
1062                 }
1063                 // The `!=` check ensures that large values of `quantity`
1064                 // that overflows uint256 will make the loop run out of gas.
1065             } while (++tokenId != end);
1066 
1067             _currentIndex = end;
1068         }
1069         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1070     }
1071 
1072     /**
1073      * @dev Mints `quantity` tokens and transfers them to `to`.
1074      *
1075      * This function is intended for efficient minting only during contract creation.
1076      *
1077      * It emits only one {ConsecutiveTransfer} as defined in
1078      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1079      * instead of a sequence of {Transfer} event(s).
1080      *
1081      * Calling this function outside of contract creation WILL make your contract
1082      * non-compliant with the ERC721 standard.
1083      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1084      * {ConsecutiveTransfer} event is only permissible during contract creation.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {ConsecutiveTransfer} event.
1092      */
1093     function _mintERC2309(address to, uint256 quantity) internal virtual {
1094         uint256 startTokenId = _currentIndex;
1095         if (to == address(0)) _revert(MintToZeroAddress.selector);
1096         if (quantity == 0) _revert(MintZeroQuantity.selector);
1097         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
1098 
1099         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1100 
1101         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1102         unchecked {
1103             // Updates:
1104             // - `balance += quantity`.
1105             // - `numberMinted += quantity`.
1106             //
1107             // We can directly add to the `balance` and `numberMinted`.
1108             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1109 
1110             // Updates:
1111             // - `address` to the owner.
1112             // - `startTimestamp` to the timestamp of minting.
1113             // - `burned` to `false`.
1114             // - `nextInitialized` to `quantity == 1`.
1115             _packedOwnerships[startTokenId] = _packOwnershipData(
1116                 to,
1117                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1118             );
1119 
1120             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1121 
1122             _currentIndex = startTokenId + quantity;
1123         }
1124         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1125     }
1126 
1127     /**
1128      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1129      *
1130      * Requirements:
1131      *
1132      * - If `to` refers to a smart contract, it must implement
1133      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1134      * - `quantity` must be greater than 0.
1135      *
1136      * See {_mint}.
1137      *
1138      * Emits a {Transfer} event for each mint.
1139      */
1140     function _safeMint(
1141         address to,
1142         uint256 quantity,
1143         bytes memory _data
1144     ) internal virtual {
1145         _mint(to, quantity);
1146 
1147         unchecked {
1148             if (to.code.length != 0) {
1149                 uint256 end = _currentIndex;
1150                 uint256 index = end - quantity;
1151                 do {
1152                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1153                         _revert(TransferToNonERC721ReceiverImplementer.selector);
1154                     }
1155                 } while (index < end);
1156                 // Reentrancy protection.
1157                 if (_currentIndex != end) _revert(bytes4(0));
1158             }
1159         }
1160     }
1161 
1162     /**
1163      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1164      */
1165     function _safeMint(address to, uint256 quantity) internal virtual {
1166         _safeMint(to, quantity, '');
1167     }
1168 
1169     // =============================================================
1170     //                       APPROVAL OPERATIONS
1171     // =============================================================
1172 
1173     /**
1174      * @dev Equivalent to `_approve(to, tokenId, false)`.
1175      */
1176     function _approve(address to, uint256 tokenId) internal virtual {
1177         _approve(to, tokenId, false);
1178     }
1179 
1180     /**
1181      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1182      * The approval is cleared when the token is transferred.
1183      *
1184      * Only a single account can be approved at a time, so approving the
1185      * zero address clears previous approvals.
1186      *
1187      * Requirements:
1188      *
1189      * - `tokenId` must exist.
1190      *
1191      * Emits an {Approval} event.
1192      */
1193     function _approve(
1194         address to,
1195         uint256 tokenId,
1196         bool approvalCheck
1197     ) internal virtual {
1198         address owner = ownerOf(tokenId);
1199 
1200         if (approvalCheck && _msgSenderERC721A() != owner)
1201             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1202                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
1203             }
1204 
1205         _tokenApprovals[tokenId].value = to;
1206         emit Approval(owner, to, tokenId);
1207     }
1208 
1209     // =============================================================
1210     //                        BURN OPERATIONS
1211     // =============================================================
1212 
1213     /**
1214      * @dev Equivalent to `_burn(tokenId, false)`.
1215      */
1216     function _burn(uint256 tokenId) internal virtual {
1217         _burn(tokenId, false);
1218     }
1219 
1220     /**
1221      * @dev Destroys `tokenId`.
1222      * The approval is cleared when the token is burned.
1223      *
1224      * Requirements:
1225      *
1226      * - `tokenId` must exist.
1227      *
1228      * Emits a {Transfer} event.
1229      */
1230     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1231         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1232 
1233         address from = address(uint160(prevOwnershipPacked));
1234 
1235         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1236 
1237         if (approvalCheck) {
1238             // The nested ifs save around 20+ gas over a compound boolean condition.
1239             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1240                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1241         }
1242 
1243         _beforeTokenTransfers(from, address(0), tokenId, 1);
1244 
1245         // Clear approvals from the previous owner.
1246         assembly {
1247             if approvedAddress {
1248                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1249                 sstore(approvedAddressSlot, 0)
1250             }
1251         }
1252 
1253         // Underflow of the sender's balance is impossible because we check for
1254         // ownership above and the recipient's balance can't realistically overflow.
1255         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1256         unchecked {
1257             // Updates:
1258             // - `balance -= 1`.
1259             // - `numberBurned += 1`.
1260             //
1261             // We can directly decrement the balance, and increment the number burned.
1262             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1263             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1264 
1265             // Updates:
1266             // - `address` to the last owner.
1267             // - `startTimestamp` to the timestamp of burning.
1268             // - `burned` to `true`.
1269             // - `nextInitialized` to `true`.
1270             _packedOwnerships[tokenId] = _packOwnershipData(
1271                 from,
1272                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1273             );
1274 
1275             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1276             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1277                 uint256 nextTokenId = tokenId + 1;
1278                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1279                 if (_packedOwnerships[nextTokenId] == 0) {
1280                     // If the next slot is within bounds.
1281                     if (nextTokenId != _currentIndex) {
1282                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1283                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1284                     }
1285                 }
1286             }
1287         }
1288 
1289         emit Transfer(from, address(0), tokenId);
1290         _afterTokenTransfers(from, address(0), tokenId, 1);
1291 
1292         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1293         unchecked {
1294             _burnCounter++;
1295         }
1296     }
1297 
1298     // =============================================================
1299     //                     EXTRA DATA OPERATIONS
1300     // =============================================================
1301 
1302     /**
1303      * @dev Directly sets the extra data for the ownership data `index`.
1304      */
1305     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1306         uint256 packed = _packedOwnerships[index];
1307         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
1308         uint256 extraDataCasted;
1309         // Cast `extraData` with assembly to avoid redundant masking.
1310         assembly {
1311             extraDataCasted := extraData
1312         }
1313         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1314         _packedOwnerships[index] = packed;
1315     }
1316 
1317     /**
1318      * @dev Called during each token transfer to set the 24bit `extraData` field.
1319      * Intended to be overridden by the cosumer contract.
1320      *
1321      * `previousExtraData` - the value of `extraData` before transfer.
1322      *
1323      * Calling conditions:
1324      *
1325      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1326      * transferred to `to`.
1327      * - When `from` is zero, `tokenId` will be minted for `to`.
1328      * - When `to` is zero, `tokenId` will be burned by `from`.
1329      * - `from` and `to` are never both zero.
1330      */
1331     function _extraData(
1332         address from,
1333         address to,
1334         uint24 previousExtraData
1335     ) internal view virtual returns (uint24) {}
1336 
1337     /**
1338      * @dev Returns the next extra data for the packed ownership data.
1339      * The returned result is shifted into position.
1340      */
1341     function _nextExtraData(
1342         address from,
1343         address to,
1344         uint256 prevOwnershipPacked
1345     ) private view returns (uint256) {
1346         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1347         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1348     }
1349 
1350     // =============================================================
1351     //                       OTHER OPERATIONS
1352     // =============================================================
1353 
1354     /**
1355      * @dev Returns the message sender (defaults to `msg.sender`).
1356      *
1357      * If you are writing GSN compatible contracts, you need to override this function.
1358      */
1359     function _msgSenderERC721A() internal view virtual returns (address) {
1360         return msg.sender;
1361     }
1362 
1363     /**
1364      * @dev Converts a uint256 to its ASCII string decimal representation.
1365      */
1366     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1367         assembly {
1368             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1369             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1370             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1371             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1372             let m := add(mload(0x40), 0xa0)
1373             // Update the free memory pointer to allocate.
1374             mstore(0x40, m)
1375             // Assign the `str` to the end.
1376             str := sub(m, 0x20)
1377             // Zeroize the slot after the string.
1378             mstore(str, 0)
1379 
1380             // Cache the end of the memory to calculate the length later.
1381             let end := str
1382 
1383             // We write the string from rightmost digit to leftmost digit.
1384             // The following is essentially a do-while loop that also handles the zero case.
1385             // prettier-ignore
1386             for { let temp := value } 1 {} {
1387                 str := sub(str, 1)
1388                 // Write the character to the pointer.
1389                 // The ASCII index of the '0' character is 48.
1390                 mstore8(str, add(48, mod(temp, 10)))
1391                 // Keep dividing `temp` until zero.
1392                 temp := div(temp, 10)
1393                 // prettier-ignore
1394                 if iszero(temp) { break }
1395             }
1396 
1397             let length := sub(end, str)
1398             // Move the pointer 32 bytes leftwards to make room for the length.
1399             str := sub(str, 0x20)
1400             // Store the length.
1401             mstore(str, length)
1402         }
1403     }
1404 
1405     /**
1406      * @dev For more efficient reverts.
1407      */
1408     function _revert(bytes4 errorSelector) internal pure {
1409         assembly {
1410             mstore(0x00, errorSelector)
1411             revert(0x00, 0x04)
1412         }
1413     }
1414 }
1415 
1416 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
1417 /// mandatory on-chain royalty enforcement in order for new collections to
1418 /// receive royalties.
1419 /// For more information, see:
1420 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
1421 abstract contract OperatorFilterer {
1422     /// @dev The default OpenSea operator blocklist subscription.
1423     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1424 
1425     /// @dev The OpenSea operator filter registry.
1426     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
1427 
1428     /// @dev Registers the current contract to OpenSea's operator filter,
1429     /// and subscribe to the default OpenSea operator blocklist.
1430     /// Note: Will not revert nor update existing settings for repeated registration.
1431     function _registerForOperatorFiltering() internal virtual {
1432         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
1433     }
1434 
1435     /// @dev Registers the current contract to OpenSea's operator filter.
1436     /// Note: Will not revert nor update existing settings for repeated registration.
1437     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe)
1438         internal
1439         virtual
1440     {
1441         /// @solidity memory-safe-assembly
1442         assembly {
1443             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
1444 
1445             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
1446             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
1447 
1448             for {} iszero(subscribe) {} {
1449                 if iszero(subscriptionOrRegistrantToCopy) {
1450                     functionSelector := 0x4420e486 // `register(address)`.
1451                     break
1452                 }
1453                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
1454                 break
1455             }
1456             // Store the function selector.
1457             mstore(0x00, shl(224, functionSelector))
1458             // Store the `address(this)`.
1459             mstore(0x04, address())
1460             // Store the `subscriptionOrRegistrantToCopy`.
1461             mstore(0x24, subscriptionOrRegistrantToCopy)
1462             // Register into the registry.
1463             pop(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x00))
1464             // Restore the part of the free memory pointer that was overwritten,
1465             // which is guaranteed to be zero, because of Solidity's memory size limits.
1466             mstore(0x24, 0)
1467         }
1468     }
1469 
1470     /// @dev Modifier to guard a function and revert if the caller is a blocked operator.
1471     modifier onlyAllowedOperator(address from) virtual {
1472         if (from != msg.sender) {
1473             if (!_isPriorityOperator(msg.sender)) {
1474                 if (_operatorFilteringEnabled()) _revertIfBlocked(msg.sender);
1475             }
1476         }
1477         _;
1478     }
1479 
1480     /// @dev Modifier to guard a function from approving a blocked operator..
1481     modifier onlyAllowedOperatorApproval(address operator) virtual {
1482         if (!_isPriorityOperator(operator)) {
1483             if (_operatorFilteringEnabled()) _revertIfBlocked(operator);
1484         }
1485         _;
1486     }
1487 
1488     /// @dev Helper function that reverts if the `operator` is blocked by the registry.
1489     function _revertIfBlocked(address operator) private view {
1490         /// @solidity memory-safe-assembly
1491         assembly {
1492             // Store the function selector of `isOperatorAllowed(address,address)`,
1493             // shifted left by 6 bytes, which is enough for 8tb of memory.
1494             // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
1495             mstore(0x00, 0xc6171134001122334455)
1496             // Store the `address(this)`.
1497             mstore(0x1a, address())
1498             // Store the `operator`.
1499             mstore(0x3a, operator)
1500 
1501             // `isOperatorAllowed` always returns true if it does not revert.
1502             if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
1503                 // Bubble up the revert if the staticcall reverts.
1504                 returndatacopy(0x00, 0x00, returndatasize())
1505                 revert(0x00, returndatasize())
1506             }
1507 
1508             // We'll skip checking if `from` is inside the blacklist.
1509             // Even though that can block transferring out of wrapper contracts,
1510             // we don't want tokens to be stuck.
1511 
1512             // Restore the part of the free memory pointer that was overwritten,
1513             // which is guaranteed to be zero, if less than 8tb of memory is used.
1514             mstore(0x3a, 0)
1515         }
1516     }
1517 
1518     /// @dev For deriving contracts to override, so that operator filtering
1519     /// can be turned on / off.
1520     /// Returns true by default.
1521     function _operatorFilteringEnabled() internal view virtual returns (bool) {
1522         return true;
1523     }
1524 
1525     /// @dev For deriving contracts to override, so that preferred marketplaces can
1526     /// skip operator filtering, helping users save gas.
1527     /// Returns false for all inputs by default.
1528     function _isPriorityOperator(address) internal view virtual returns (bool) {
1529         return false;
1530     }
1531 }
1532 
1533 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1534 
1535 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1536 
1537 /**
1538  * @dev Provides information about the current execution context, including the
1539  * sender of the transaction and its data. While these are generally available
1540  * via msg.sender and msg.data, they should not be accessed in such a direct
1541  * manner, since when dealing with meta-transactions the account sending and
1542  * paying for execution may not be the actual sender (as far as an application
1543  * is concerned).
1544  *
1545  * This contract is only required for intermediate, library-like contracts.
1546  */
1547 abstract contract Context {
1548     function _msgSender() internal view virtual returns (address) {
1549         return msg.sender;
1550     }
1551 
1552     function _msgData() internal view virtual returns (bytes calldata) {
1553         return msg.data;
1554     }
1555 }
1556 
1557 /**
1558  * @dev Contract module which provides a basic access control mechanism, where
1559  * there is an account (an owner) that can be granted exclusive access to
1560  * specific functions.
1561  *
1562  * By default, the owner account will be the one that deploys the contract. This
1563  * can later be changed with {transferOwnership}.
1564  *
1565  * This module is used through inheritance. It will make available the modifier
1566  * `onlyOwner`, which can be applied to your functions to restrict their use to
1567  * the owner.
1568  */
1569 abstract contract Ownable is Context {
1570     address private _owner;
1571 
1572     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1573 
1574     /**
1575      * @dev Initializes the contract setting the deployer as the initial owner.
1576      */
1577     constructor() {
1578         _transferOwnership(_msgSender());
1579     }
1580 
1581     /**
1582      * @dev Throws if called by any account other than the owner.
1583      */
1584     modifier onlyOwner() {
1585         _checkOwner();
1586         _;
1587     }
1588 
1589     /**
1590      * @dev Returns the address of the current owner.
1591      */
1592     function owner() public view virtual returns (address) {
1593         return _owner;
1594     }
1595 
1596     /**
1597      * @dev Throws if the sender is not the owner.
1598      */
1599     function _checkOwner() internal view virtual {
1600         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1601     }
1602 
1603     /**
1604      * @dev Leaves the contract without owner. It will not be possible to call
1605      * `onlyOwner` functions anymore. Can only be called by the current owner.
1606      *
1607      * NOTE: Renouncing ownership will leave the contract without an owner,
1608      * thereby removing any functionality that is only available to the owner.
1609      */
1610     function renounceOwnership() public virtual onlyOwner {
1611         _transferOwnership(address(0));
1612     }
1613 
1614     /**
1615      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1616      * Can only be called by the current owner.
1617      */
1618     function transferOwnership(address newOwner) public virtual onlyOwner {
1619         require(newOwner != address(0), "Ownable: new owner is the zero address");
1620         _transferOwnership(newOwner);
1621     }
1622 
1623     /**
1624      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1625      * Internal function without access restriction.
1626      */
1627     function _transferOwnership(address newOwner) internal virtual {
1628         address oldOwner = _owner;
1629         _owner = newOwner;
1630         emit OwnershipTransferred(oldOwner, newOwner);
1631     }
1632 }
1633 
1634 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1635 
1636 /**
1637  * @dev Contract module that helps prevent reentrant calls to a function.
1638  *
1639  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1640  * available, which can be applied to functions to make sure there are no nested
1641  * (reentrant) calls to them.
1642  *
1643  * Note that because there is a single `nonReentrant` guard, functions marked as
1644  * `nonReentrant` may not call one another. This can be worked around by making
1645  * those functions `private`, and then adding `external` `nonReentrant` entry
1646  * points to them.
1647  *
1648  * TIP: If you would like to learn more about reentrancy and alternative ways
1649  * to protect against it, check out our blog post
1650  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1651  */
1652 abstract contract ReentrancyGuard {
1653     // Booleans are more expensive than uint256 or any type that takes up a full
1654     // word because each write operation emits an extra SLOAD to first read the
1655     // slot's contents, replace the bits taken up by the boolean, and then write
1656     // back. This is the compiler's defense against contract upgrades and
1657     // pointer aliasing, and it cannot be disabled.
1658 
1659     // The values being non-zero value makes deployment a bit more expensive,
1660     // but in exchange the refund on every call to nonReentrant will be lower in
1661     // amount. Since refunds are capped to a percentage of the total
1662     // transaction's gas, it is best to keep them low in cases like this one, to
1663     // increase the likelihood of the full refund coming into effect.
1664     uint256 private constant _NOT_ENTERED = 1;
1665     uint256 private constant _ENTERED = 2;
1666 
1667     uint256 private _status;
1668 
1669     constructor() {
1670         _status = _NOT_ENTERED;
1671     }
1672 
1673     /**
1674      * @dev Prevents a contract from calling itself, directly or indirectly.
1675      * Calling a `nonReentrant` function from another `nonReentrant`
1676      * function is not supported. It is possible to prevent this from happening
1677      * by making the `nonReentrant` function external, and making it call a
1678      * `private` function that does the actual work.
1679      */
1680     modifier nonReentrant() {
1681         _nonReentrantBefore();
1682         _;
1683         _nonReentrantAfter();
1684     }
1685 
1686     function _nonReentrantBefore() private {
1687         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1688         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1689 
1690         // Any calls to nonReentrant after this point will fail
1691         _status = _ENTERED;
1692     }
1693 
1694     function _nonReentrantAfter() private {
1695         // By storing the original value once again, a refund is triggered (see
1696         // https://eips.ethereum.org/EIPS/eip-2200)
1697         _status = _NOT_ENTERED;
1698     }
1699 
1700     /**
1701      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1702      * `nonReentrant` function in the call stack.
1703      */
1704     function _reentrancyGuardEntered() internal view returns (bool) {
1705         return _status == _ENTERED;
1706     }
1707 }
1708 
1709 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1710 
1711 /**
1712  * @dev Collection of functions related to the address type
1713  */
1714 library Address {
1715     /**
1716      * @dev Returns true if `account` is a contract.
1717      *
1718      * [IMPORTANT]
1719      * ====
1720      * It is unsafe to assume that an address for which this function returns
1721      * false is an externally-owned account (EOA) and not a contract.
1722      *
1723      * Among others, `isContract` will return false for the following
1724      * types of addresses:
1725      *
1726      *  - an externally-owned account
1727      *  - a contract in construction
1728      *  - an address where a contract will be created
1729      *  - an address where a contract lived, but was destroyed
1730      *
1731      * Furthermore, `isContract` will also return true if the target contract within
1732      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
1733      * which only has an effect at the end of a transaction.
1734      * ====
1735      *
1736      * [IMPORTANT]
1737      * ====
1738      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1739      *
1740      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1741      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1742      * constructor.
1743      * ====
1744      */
1745     function isContract(address account) internal view returns (bool) {
1746         // This method relies on extcodesize/address.code.length, which returns 0
1747         // for contracts in construction, since the code is only stored at the end
1748         // of the constructor execution.
1749 
1750         return account.code.length > 0;
1751     }
1752 
1753     /**
1754      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1755      * `recipient`, forwarding all available gas and reverting on errors.
1756      *
1757      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1758      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1759      * imposed by `transfer`, making them unable to receive funds via
1760      * `transfer`. {sendValue} removes this limitation.
1761      *
1762      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1763      *
1764      * IMPORTANT: because control is transferred to `recipient`, care must be
1765      * taken to not create reentrancy vulnerabilities. Consider using
1766      * {ReentrancyGuard} or the
1767      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1768      */
1769     function sendValue(address payable recipient, uint256 amount) internal {
1770         require(address(this).balance >= amount, "Address: insufficient balance");
1771 
1772         (bool success, ) = recipient.call{value: amount}("");
1773         require(success, "Address: unable to send value, recipient may have reverted");
1774     }
1775 
1776     /**
1777      * @dev Performs a Solidity function call using a low level `call`. A
1778      * plain `call` is an unsafe replacement for a function call: use this
1779      * function instead.
1780      *
1781      * If `target` reverts with a revert reason, it is bubbled up by this
1782      * function (like regular Solidity function calls).
1783      *
1784      * Returns the raw returned data. To convert to the expected return value,
1785      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1786      *
1787      * Requirements:
1788      *
1789      * - `target` must be a contract.
1790      * - calling `target` with `data` must not revert.
1791      *
1792      * _Available since v3.1._
1793      */
1794     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1795         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1796     }
1797 
1798     /**
1799      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1800      * `errorMessage` as a fallback revert reason when `target` reverts.
1801      *
1802      * _Available since v3.1._
1803      */
1804     function functionCall(
1805         address target,
1806         bytes memory data,
1807         string memory errorMessage
1808     ) internal returns (bytes memory) {
1809         return functionCallWithValue(target, data, 0, errorMessage);
1810     }
1811 
1812     /**
1813      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1814      * but also transferring `value` wei to `target`.
1815      *
1816      * Requirements:
1817      *
1818      * - the calling contract must have an ETH balance of at least `value`.
1819      * - the called Solidity function must be `payable`.
1820      *
1821      * _Available since v3.1._
1822      */
1823     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1824         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1825     }
1826 
1827     /**
1828      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1829      * with `errorMessage` as a fallback revert reason when `target` reverts.
1830      *
1831      * _Available since v3.1._
1832      */
1833     function functionCallWithValue(
1834         address target,
1835         bytes memory data,
1836         uint256 value,
1837         string memory errorMessage
1838     ) internal returns (bytes memory) {
1839         require(address(this).balance >= value, "Address: insufficient balance for call");
1840         (bool success, bytes memory returndata) = target.call{value: value}(data);
1841         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1842     }
1843 
1844     /**
1845      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1846      * but performing a static call.
1847      *
1848      * _Available since v3.3._
1849      */
1850     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1851         return functionStaticCall(target, data, "Address: low-level static call failed");
1852     }
1853 
1854     /**
1855      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1856      * but performing a static call.
1857      *
1858      * _Available since v3.3._
1859      */
1860     function functionStaticCall(
1861         address target,
1862         bytes memory data,
1863         string memory errorMessage
1864     ) internal view returns (bytes memory) {
1865         (bool success, bytes memory returndata) = target.staticcall(data);
1866         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1867     }
1868 
1869     /**
1870      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1871      * but performing a delegate call.
1872      *
1873      * _Available since v3.4._
1874      */
1875     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1876         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1877     }
1878 
1879     /**
1880      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1881      * but performing a delegate call.
1882      *
1883      * _Available since v3.4._
1884      */
1885     function functionDelegateCall(
1886         address target,
1887         bytes memory data,
1888         string memory errorMessage
1889     ) internal returns (bytes memory) {
1890         (bool success, bytes memory returndata) = target.delegatecall(data);
1891         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1892     }
1893 
1894     /**
1895      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1896      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1897      *
1898      * _Available since v4.8._
1899      */
1900     function verifyCallResultFromTarget(
1901         address target,
1902         bool success,
1903         bytes memory returndata,
1904         string memory errorMessage
1905     ) internal view returns (bytes memory) {
1906         if (success) {
1907             if (returndata.length == 0) {
1908                 // only check isContract if the call was successful and the return data is empty
1909                 // otherwise we already know that it was a contract
1910                 require(isContract(target), "Address: call to non-contract");
1911             }
1912             return returndata;
1913         } else {
1914             _revert(returndata, errorMessage);
1915         }
1916     }
1917 
1918     /**
1919      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1920      * revert reason or using the provided one.
1921      *
1922      * _Available since v4.3._
1923      */
1924     function verifyCallResult(
1925         bool success,
1926         bytes memory returndata,
1927         string memory errorMessage
1928     ) internal pure returns (bytes memory) {
1929         if (success) {
1930             return returndata;
1931         } else {
1932             _revert(returndata, errorMessage);
1933         }
1934     }
1935 
1936     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1937         // Look for revert reason and bubble it up if present
1938         if (returndata.length > 0) {
1939             // The easiest way to bubble the revert reason is using memory via assembly
1940             /// @solidity memory-safe-assembly
1941             assembly {
1942                 let returndata_size := mload(returndata)
1943                 revert(add(32, returndata), returndata_size)
1944             }
1945         } else {
1946             revert(errorMessage);
1947         }
1948     }
1949 }
1950 
1951 interface IWETH {
1952     function balanceOf(address user) external view returns (uint256);
1953 
1954     function withdraw(uint256 wad) external;
1955 
1956     function deposit() external payable;
1957 
1958     function transfer(address dst, uint256 wad) external returns (bool);
1959 }
1960 
1961 interface IEthOrdinalsMetadata {
1962     function tokenURI(uint256 tokenId) external view returns (string memory);
1963 
1964     function baseURI() external view returns (string memory);
1965 }
1966 
1967 contract EthOrdinals is ERC721A, OperatorFilterer, Ownable, ReentrancyGuard {
1968     bool public operatorFilteringEnabled;
1969     bool public saleOpen;
1970     uint256 public mintableSupply;
1971     IEthOrdinalsMetadata public metadataContract;
1972 
1973     constructor(address metadataContract_, uint256 mintableSupply_)
1974         ERC721A("ETH Ordinals", "EO")
1975     {
1976         _registerForOperatorFiltering();
1977         operatorFilteringEnabled = true;
1978         mintableSupply = mintableSupply_;
1979         metadataContract = IEthOrdinalsMetadata(metadataContract_);
1980     }
1981 
1982     function mint() public payable {
1983         require(saleOpen, "Sale Not Open");
1984         require(_totalMinted() + 1 <= mintableSupply, "Sold Out");
1985         require(_getAux(msg.sender) == 0, "Max 1 Per Wallet");
1986         require(tx.origin == msg.sender, "EOA Only");
1987         _setAux(msg.sender, 1);
1988         _mint(msg.sender, 1);
1989     }
1990 
1991     function freeMinted(address address_) public view returns (bool) {
1992         return _getAux(address_) == 1;
1993     }
1994 
1995     function mintAsAdmin(address recipient, uint256 quantity) public onlyOwner {
1996         require(_totalMinted() + quantity <= mintableSupply, "Max Supply Hit");
1997         _mint(recipient, quantity);
1998     }
1999 
2000     function tokenURI(uint256 tokenId)
2001         public
2002         view
2003         virtual
2004         override(ERC721A)
2005         returns (string memory)
2006     {
2007         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2008         return metadataContract.tokenURI(tokenId);
2009     }
2010 
2011     function toggleSale() public onlyOwner {
2012         saleOpen = !saleOpen;
2013     }
2014 
2015     function setMintableSupply(uint256 mintableSupply_) public onlyOwner {
2016         mintableSupply = mintableSupply_;
2017     }
2018 
2019     function _baseURI() internal view virtual override returns (string memory) {
2020         return metadataContract.baseURI();
2021     }
2022 
2023     function repeatRegistration() public {
2024         _registerForOperatorFiltering();
2025     }
2026 
2027     function setApprovalForAll(address operator, bool approved)
2028         public
2029         override
2030         onlyAllowedOperatorApproval(operator)
2031     {
2032         super.setApprovalForAll(operator, approved);
2033     }
2034 
2035     function approve(address operator, uint256 tokenId)
2036         public
2037         payable
2038         override
2039         onlyAllowedOperatorApproval(operator)
2040     {
2041         super.approve(operator, tokenId);
2042     }
2043 
2044     function transferFrom(
2045         address from,
2046         address to,
2047         uint256 tokenId
2048     ) public payable override onlyAllowedOperator(from) {
2049         super.transferFrom(from, to, tokenId);
2050     }
2051 
2052     function safeTransferFrom(
2053         address from,
2054         address to,
2055         uint256 tokenId
2056     ) public payable override onlyAllowedOperator(from) {
2057         super.safeTransferFrom(from, to, tokenId);
2058     }
2059 
2060     function safeTransferFrom(
2061         address from,
2062         address to,
2063         uint256 tokenId,
2064         bytes memory data
2065     ) public payable override onlyAllowedOperator(from) {
2066         super.safeTransferFrom(from, to, tokenId, data);
2067     }
2068 
2069     function setOperatorFilteringEnabled(bool value) public onlyOwner {
2070         operatorFilteringEnabled = value;
2071     }
2072 
2073     function _operatorFilteringEnabled()
2074         internal
2075         view
2076         virtual
2077         override
2078         returns (bool)
2079     {
2080         return operatorFilteringEnabled;
2081     }
2082 
2083     function changeMetadataContract(address metadataContract_)
2084         public
2085         onlyOwner
2086     {
2087         metadataContract = IEthOrdinalsMetadata(metadataContract_);
2088     }
2089 
2090     function withdrawWeth() public nonReentrant {
2091         IWETH wrappedEther = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
2092         uint256 balance = wrappedEther.balanceOf(address(this));
2093         if (balance > 0) {
2094             wrappedEther.withdraw(balance);
2095         }
2096         _withdraw();
2097     }
2098 
2099     function withdraw() public nonReentrant {
2100         _withdraw();
2101     }
2102 
2103     function _withdraw() internal {
2104         uint256 balance = address(this).balance;
2105         Address.sendValue(
2106             payable(address(0xa4e96F19B0dA586A50136036b1B96982a603C65E)),
2107             (balance * 60) / 100
2108         );
2109         Address.sendValue(
2110             payable(address(0xa645Ffd68a6D623C5486cbd866ADED48B2bCbA18)),
2111             (balance * 40) / 100
2112         );
2113     }
2114 
2115     receive() external payable {}
2116 }