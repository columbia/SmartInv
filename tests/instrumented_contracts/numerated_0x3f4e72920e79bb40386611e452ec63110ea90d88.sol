1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 
7 
8 // ERC721A Contracts v4.1.0
9 // Creator: Chiru Labs
10 
11 
12 
13 
14 // ERC721A Contracts v4.1.0
15 // Creator: Chiru Labs
16 
17 
18 
19 /**
20  * @dev Interface of an ERC721A compliant contract.
21  */
22 interface IERC721A {
23     /**
24      * The caller must own the token or be an approved operator.
25      */
26     error ApprovalCallerNotOwnerNorApproved();
27 
28     /**
29      * The token does not exist.
30      */
31     error ApprovalQueryForNonexistentToken();
32 
33     /**
34      * The caller cannot approve to their own address.
35      */
36     error ApproveToCaller();
37 
38     /**
39      * Cannot query the balance for the zero address.
40      */
41     error BalanceQueryForZeroAddress();
42 
43     /**
44      * Cannot mint to the zero address.
45      */
46     error MintToZeroAddress();
47 
48     /**
49      * The quantity of tokens minted must be more than zero.
50      */
51     error MintZeroQuantity();
52 
53     /**
54      * The token does not exist.
55      */
56     error OwnerQueryForNonexistentToken();
57 
58     /**
59      * The caller must own the token or be an approved operator.
60      */
61     error TransferCallerNotOwnerNorApproved();
62 
63     /**
64      * The token must be owned by `from`.
65      */
66     error TransferFromIncorrectOwner();
67 
68     /**
69      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
70      */
71     error TransferToNonERC721ReceiverImplementer();
72 
73     /**
74      * Cannot transfer to the zero address.
75      */
76     error TransferToZeroAddress();
77 
78     /**
79      * The token does not exist.
80      */
81     error URIQueryForNonexistentToken();
82 
83     /**
84      * The `quantity` minted with ERC2309 exceeds the safety limit.
85      */
86     error MintERC2309QuantityExceedsLimit();
87 
88     /**
89      * The `extraData` cannot be set on an unintialized ownership slot.
90      */
91     error OwnershipNotInitializedForExtraData();
92 
93     struct TokenOwnership {
94         // The address of the owner.
95         address addr;
96         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
97         uint64 startTimestamp;
98         // Whether the token has been burned.
99         bool burned;
100         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
101         uint24 extraData;
102     }
103 
104     /**
105      * @dev Returns the total amount of tokens stored by the contract.
106      *
107      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     // ==============================
112     //            IERC165
113     // ==============================
114 
115     /**
116      * @dev Returns true if this contract implements the interface defined by
117      * `interfaceId`. See the corresponding
118      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
119      * to learn more about how these ids are created.
120      *
121      * This function call must use less than 30 000 gas.
122      */
123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
124 
125     // ==============================
126     //            IERC721
127     // ==============================
128 
129     /**
130      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
131      */
132     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
136      */
137     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
138 
139     /**
140      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
141      */
142     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
143 
144     /**
145      * @dev Returns the number of tokens in ``owner``'s account.
146      */
147     function balanceOf(address owner) external view returns (uint256 balance);
148 
149     /**
150      * @dev Returns the owner of the `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function ownerOf(uint256 tokenId) external view returns (address owner);
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
167      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId,
175         bytes calldata data
176     ) external;
177 
178     /**
179      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
180      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
181      *
182      * Requirements:
183      *
184      * - `from` cannot be the zero address.
185      * - `to` cannot be the zero address.
186      * - `tokenId` token must exist and be owned by `from`.
187      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
188      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
189      *
190      * Emits a {Transfer} event.
191      */
192     function safeTransferFrom(
193         address from,
194         address to,
195         uint256 tokenId
196     ) external;
197 
198     /**
199      * @dev Transfers `tokenId` token from `from` to `to`.
200      *
201      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
202      *
203      * Requirements:
204      *
205      * - `from` cannot be the zero address.
206      * - `to` cannot be the zero address.
207      * - `tokenId` token must be owned by `from`.
208      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
209      *
210      * Emits a {Transfer} event.
211      */
212     function transferFrom(
213         address from,
214         address to,
215         uint256 tokenId
216     ) external;
217 
218     /**
219      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
220      * The approval is cleared when the token is transferred.
221      *
222      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
223      *
224      * Requirements:
225      *
226      * - The caller must own the token or be an approved operator.
227      * - `tokenId` must exist.
228      *
229      * Emits an {Approval} event.
230      */
231     function approve(address to, uint256 tokenId) external;
232 
233     /**
234      * @dev Approve or remove `operator` as an operator for the caller.
235      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
236      *
237      * Requirements:
238      *
239      * - The `operator` cannot be the caller.
240      *
241      * Emits an {ApprovalForAll} event.
242      */
243     function setApprovalForAll(address operator, bool _approved) external;
244 
245     /**
246      * @dev Returns the account approved for `tokenId` token.
247      *
248      * Requirements:
249      *
250      * - `tokenId` must exist.
251      */
252     function getApproved(uint256 tokenId) external view returns (address operator);
253 
254     /**
255      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
256      *
257      * See {setApprovalForAll}
258      */
259     function isApprovedForAll(address owner, address operator) external view returns (bool);
260 
261     // ==============================
262     //        IERC721Metadata
263     // ==============================
264 
265     /**
266      * @dev Returns the token collection name.
267      */
268     function name() external view returns (string memory);
269 
270     /**
271      * @dev Returns the token collection symbol.
272      */
273     function symbol() external view returns (string memory);
274 
275     /**
276      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
277      */
278     function tokenURI(uint256 tokenId) external view returns (string memory);
279 
280     // ==============================
281     //            IERC2309
282     // ==============================
283 
284     /**
285      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
286      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
287      */
288     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
289 }
290 
291 
292 
293 /**
294  * @dev ERC721 token receiver interface.
295  */
296 interface ERC721A__IERC721Receiver {
297     function onERC721Received(
298         address operator,
299         address from,
300         uint256 tokenId,
301         bytes calldata data
302     ) external returns (bytes4);
303 }
304 
305 /**
306  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
307  * including the Metadata extension. Built to optimize for lower gas during batch mints.
308  *
309  * Assumes serials are sequentially minted starting at `_startTokenId()`
310  * (defaults to 0, e.g. 0, 1, 2, 3..).
311  *
312  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
313  *
314  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
315  */
316 contract ERC721A is IERC721A {
317     // Mask of an entry in packed address data.
318     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
319 
320     // The bit position of `numberMinted` in packed address data.
321     uint256 private constant BITPOS_NUMBER_MINTED = 64;
322 
323     // The bit position of `numberBurned` in packed address data.
324     uint256 private constant BITPOS_NUMBER_BURNED = 128;
325 
326     // The bit position of `aux` in packed address data.
327     uint256 private constant BITPOS_AUX = 192;
328 
329     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
330     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
331 
332     // The bit position of `startTimestamp` in packed ownership.
333     uint256 private constant BITPOS_START_TIMESTAMP = 160;
334 
335     // The bit mask of the `burned` bit in packed ownership.
336     uint256 private constant BITMASK_BURNED = 1 << 224;
337 
338     // The bit position of the `nextInitialized` bit in packed ownership.
339     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
340 
341     // The bit mask of the `nextInitialized` bit in packed ownership.
342     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
343 
344     // The bit position of `extraData` in packed ownership.
345     uint256 private constant BITPOS_EXTRA_DATA = 232;
346 
347     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
348     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
349 
350     // The mask of the lower 160 bits for addresses.
351     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
352 
353     // The maximum `quantity` that can be minted with `_mintERC2309`.
354     // This limit is to prevent overflows on the address data entries.
355     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
356     // is required to cause an overflow, which is unrealistic.
357     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
358 
359     // The tokenId of the next token to be minted.
360     uint256 private _currentIndex;
361 
362     // The number of tokens burned.
363     uint256 private _burnCounter;
364 
365     // Token name
366     string private _name;
367 
368     // Token symbol
369     string private _symbol;
370 
371     string private _baseURI;
372 
373     // Mapping from token ID to ownership details
374     // An empty struct value does not necessarily mean the token is unowned.
375     // See `_packedOwnershipOf` implementation for details.
376     //
377     // Bits Layout:
378     // - [0..159]   `addr`
379     // - [160..223] `startTimestamp`
380     // - [224]      `burned`
381     // - [225]      `nextInitialized`
382     // - [232..255] `extraData`
383     mapping(uint256 => uint256) private _packedOwnerships;
384 
385     // Mapping owner address to address data.
386     //
387     // Bits Layout:
388     // - [0..63]    `balance`
389     // - [64..127]  `numberMinted`
390     // - [128..191] `numberBurned`
391     // - [192..255] `aux`
392     mapping(address => uint256) private _packedAddressData;
393 
394     // Mapping from token ID to approved address.
395     mapping(uint256 => address) private _tokenApprovals;
396 
397     // Mapping from owner to operator approvals
398     mapping(address => mapping(address => bool)) private _operatorApprovals;
399 
400     constructor(string memory name_, string memory symbol_ ) {
401         _name = name_;
402         _symbol = symbol_;
403         _currentIndex = _startTokenId();
404 
405         // _setBaseURI(baseURI_);
406     }
407 
408     /**
409      * @dev Returns the starting token ID.
410      * To change the starting token ID, please override this function.
411      */
412     function _startTokenId() internal view virtual returns (uint256) {
413         return 0;
414     }
415 
416     /**
417      * @dev Returns the next token ID to be minted.
418      */
419     function _nextTokenId() internal view returns (uint256) {
420         return _currentIndex;
421     }
422 
423     /**
424      * @dev Returns the total number of tokens in existence.
425      * Burned tokens will reduce the count.
426      * To get the total n`umber of tokens minted, please see `_totalMinted`.
427      */
428     function totalSupply() public view override returns (uint256) {
429         // Counter underflow is impossible as _burnCounter cannot be incremented
430         // more than `_currentIndex - _startTokenId()` times.
431         unchecked {
432             return _currentIndex - _burnCounter - _startTokenId();
433         }
434     }
435 
436     /**
437      * @dev Returns the total amount of tokens minted in the contract.
438      */
439     function _totalMinted() internal view returns (uint256) {
440         // Counter underflow is impossible as _currentIndex does not decrement,
441         // and it is initialized to `_startTokenId()`
442         unchecked {
443             return _currentIndex - _startTokenId();
444         }
445     }
446 
447     /**
448      * @dev Returns the total number of tokens burned.
449      */
450     function _totalBurned() internal view returns (uint256) {
451         return _burnCounter;
452     }
453 
454     /**
455      * @dev See {IERC165-supportsInterface}.
456      */
457     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
458         // The interface IDs are constants representing the first 4 bytes of the XOR of
459         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
460         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
461         return
462             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
463             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
464             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
465     }
466 
467     /**
468      * @dev See {IERC721-balanceOf}.
469      */
470     function balanceOf(address owner) public view override returns (uint256) {
471         if (owner == address(0)) revert BalanceQueryForZeroAddress();
472         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
473     }
474 
475     /**
476      * Returns the number of tokens minted by `owner`.
477      */
478     function _numberMinted(address owner) internal view returns (uint256) {
479         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
480     }
481 
482     /**
483      * Returns the number of tokens burned by or on behalf of `owner`.
484      */
485     function _numberBurned(address owner) internal view returns (uint256) {
486         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
487     }
488 
489     /**
490      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
491      */
492     function _getAux(address owner) internal view returns (uint64) {
493         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
494     }
495 
496     /**
497      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
498      * If there are multiple variables, please pack them into a uint64.
499      */
500     function _setAux(address owner, uint64 aux) internal {
501         uint256 packed = _packedAddressData[owner];
502         uint256 auxCasted;
503         // Cast `aux` with assembly to avoid redundant masking.
504         assembly {
505             auxCasted := aux
506         }
507         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
508         _packedAddressData[owner] = packed;
509     }
510 
511     /**
512      * Returns the packed ownership data of `tokenId`.
513      */
514     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
515         uint256 curr = tokenId;
516 
517         unchecked {
518             if (_startTokenId() <= curr)
519                 if (curr < _currentIndex) {
520                     uint256 packed = _packedOwnerships[curr];
521                     // If not burned.
522                     if (packed & BITMASK_BURNED == 0) {
523                         // Invariant:
524                         // There will always be an ownership that has an address and is not burned
525                         // before an ownership that does not have an address and is not burned.
526                         // Hence, curr will not underflow.
527                         //
528                         // We can directly compare the packed value.
529                         // If the address is zero, packed is zero.
530                         while (packed == 0) {
531                             packed = _packedOwnerships[--curr];
532                         }
533                         return packed;
534                     }
535                 }
536         }
537         revert OwnerQueryForNonexistentToken();
538     }
539 
540     /**
541      * Returns the unpacked `TokenOwnership` struct from `packed`.
542      */
543     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
544         ownership.addr = address(uint160(packed));
545         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
546         ownership.burned = packed & BITMASK_BURNED != 0;
547         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
548     }
549 
550     /**
551      * Returns the unpacked `TokenOwnership` struct at `index`.
552      */
553     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
554         return _unpackedOwnership(_packedOwnerships[index]);
555     }
556 
557     /**
558      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
559      */
560     function _initializeOwnershipAt(uint256 index) internal {
561         if (_packedOwnerships[index] == 0) {
562             _packedOwnerships[index] = _packedOwnershipOf(index);
563         }
564     }
565 
566     /**
567      * Gas spent here starts off proportional to the maximum mint batch size.
568      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
569      */
570     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
571         return _unpackedOwnership(_packedOwnershipOf(tokenId));
572     }
573 
574     /**
575      * @dev Packs ownership data into a single uint256.
576      */
577     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
578         assembly {
579             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
580             owner := and(owner, BITMASK_ADDRESS)
581             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
582             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
583         }
584     }
585 
586     /**
587      * @dev See {IERC721-ownerOf}.
588      */
589     function ownerOf(uint256 tokenId) public view override returns (address) {
590         return address(uint160(_packedOwnershipOf(tokenId)));
591     }
592 
593     /**
594      * @dev See {IERC721Metadata-name}.
595      */
596     function name() public view virtual override returns (string memory) {
597         return _name;
598     }
599 
600     /**
601      * @dev See {IERC721Metadata-symbol}.
602      */
603     function symbol() public view virtual override returns (string memory) {
604         return _symbol;
605     }
606 
607     /**
608      * @dev See {IERC721Metadata-tokenURI}.
609      */
610     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
611         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
612 
613         string memory baseURI_ = baseURI();
614         return bytes(baseURI_).length != 0 ? string(abi.encodePacked(baseURI_, "/",_toString(tokenId), ".json")) : '';
615     }
616 
617     /**
618      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
619      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
620      * by default, it can be overridden in child contracts.
621      */
622     function baseURI() internal view virtual returns (string memory) {
623         return _baseURI;
624     }
625 
626     function _setBaseURI(string memory baseURI_) internal virtual {
627         _baseURI = baseURI_;
628     }
629 
630     /**
631      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
632      */
633     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
634         // For branchless setting of the `nextInitialized` flag.
635         assembly {
636             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
637             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
638         }
639     }
640 
641     /**
642      * @dev See {IERC721-approve}.
643      */
644     function approve(address to, uint256 tokenId) public override {
645         address owner = ownerOf(tokenId);
646 
647         if (_msgSenderERC721A() != owner)
648             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
649                 revert ApprovalCallerNotOwnerNorApproved();
650             }
651 
652         _tokenApprovals[tokenId] = to;
653         emit Approval(owner, to, tokenId);
654     }
655 
656     /**
657      * @dev See {IERC721-getApproved}.
658      */
659     function getApproved(uint256 tokenId) public view override returns (address) {
660         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
661 
662         return _tokenApprovals[tokenId];
663     }
664 
665     /**
666      * @dev See {IERC721-setApprovalForAll}.
667      */
668     function setApprovalForAll(address operator, bool approved) public virtual override {
669         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
670 
671         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
672         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
673     }
674 
675     /**
676      * @dev See {IERC721-isApprovedForAll}.
677      */
678     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
679         return _operatorApprovals[owner][operator];
680     }
681 
682     /**
683      * @dev See {IERC721-safeTransferFrom}.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId
689     ) public virtual override {
690         safeTransferFrom(from, to, tokenId, '');
691     }
692 
693     /**
694      * @dev See {IERC721-safeTransferFrom}.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId,
700         bytes memory _data
701     ) public virtual override {
702         transferFrom(from, to, tokenId);
703         if (to.code.length != 0)
704             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
705                 revert TransferToNonERC721ReceiverImplementer();
706             }
707     }
708 
709     /**
710      * @dev Returns whether `tokenId` exists.
711      *
712      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
713      *
714      * Tokens start existing when they are minted (`_mint`),
715      */
716     function _exists(uint256 tokenId) internal view returns (bool) {
717         return
718             _startTokenId() <= tokenId &&
719             tokenId < _currentIndex && // If within bounds,
720             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
721     }
722 
723     /**
724      * @dev Equivalent to `_safeMint(to, quantity, '')`.
725      */
726     function _safeMint(address to, uint256 quantity) internal {
727         _safeMint(to, quantity, '');
728     }
729 
730     /**
731      * @dev Safely mints `quantity` tokens and transfers them to `to`.
732      *
733      * Requirements:
734      *
735      * - If `to` refers to a smart contract, it must implement
736      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
737      * - `quantity` must be greater than 0.
738      *
739      * See {_mint}.
740      *
741      * Emits a {Transfer} event for each mint.
742      */
743     function _safeMint(
744         address to,
745         uint256 quantity,
746         bytes memory _data
747     ) internal {
748         _mint(to, quantity);
749 
750         unchecked {
751             if (to.code.length != 0) {
752                 uint256 end = _currentIndex;
753                 uint256 index = end - quantity;
754                 do {
755                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
756                         revert TransferToNonERC721ReceiverImplementer();
757                     }
758                 } while (index < end);
759                 // Reentrancy protection.
760                 if (_currentIndex != end) revert();
761             }
762         }
763     }
764 
765     /**
766      * @dev Mints `quantity` tokens and transfers them to `to`.
767      *
768      * Requirements:
769      *
770      * - `to` cannot be the zero address.
771      * - `quantity` must be greater than 0.
772      *
773      * Emits a {Transfer} event for each mint.
774      */
775     function _mint(address to, uint256 quantity) internal {
776         uint256 startTokenId = _currentIndex;
777         if (to == address(0)) revert MintToZeroAddress();
778         if (quantity == 0) revert MintZeroQuantity();
779 
780         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
781 
782         // Overflows are incredibly unrealistic.
783         // `balance` and `numberMinted` have a maximum limit of 2**64.
784         // `tokenId` has a maximum limit of 2**256.
785         unchecked {
786             // Updates:
787             // - `balance += quantity`.
788             // - `numberMinted += quantity`.
789             //
790             // We can directly add to the `balance` and `numberMinted`.
791             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
792 
793             // Updates:
794             // - `address` to the owner.
795             // - `startTimestamp` to the timestamp of minting.
796             // - `burned` to `false`.
797             // - `nextInitialized` to `quantity == 1`.
798             _packedOwnerships[startTokenId] = _packOwnershipData(
799                 to,
800                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
801             );
802 
803             uint256 tokenId = startTokenId;
804             uint256 end = startTokenId + quantity;
805             do {
806                 emit Transfer(address(0), to, tokenId++);
807             } while (tokenId < end);
808 
809             _currentIndex = end;
810         }
811         _afterTokenTransfers(address(0), to, startTokenId, quantity);
812     }
813 
814     /**
815      * @dev Mints `quantity` tokens and transfers them to `to`.
816      *
817      * This function is intended for efficient minting only during contract creation.
818      *
819      * It emits only one {ConsecutiveTransfer} as defined in
820      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
821      * instead of a sequence of {Transfer} event(s).
822      *
823      * Calling this function outside of contract creation WILL make your contract
824      * non-compliant with the ERC721 standard.
825      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
826      * {ConsecutiveTransfer} event is only permissible during contract creation.
827      *
828      * Requirements:
829      *
830      * - `to` cannot be the zero address.
831      * - `quantity` must be greater than 0.
832      *
833      * Emits a {ConsecutiveTransfer} event.
834      */
835     function _mintERC2309(address to, uint256 quantity) internal {
836         uint256 startTokenId = _currentIndex;
837         if (to == address(0)) revert MintToZeroAddress();
838         if (quantity == 0) revert MintZeroQuantity();
839         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
840 
841         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
842 
843         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
844         unchecked {
845             // Updates:
846             // - `balance += quantity`.
847             // - `numberMinted += quantity`.
848             //
849             // We can directly add to the `balance` and `numberMinted`.
850             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
851 
852             // Updates:
853             // - `address` to the owner.
854             // - `startTimestamp` to the timestamp of minting.
855             // - `burned` to `false`.
856             // - `nextInitialized` to `quantity == 1`.
857             _packedOwnerships[startTokenId] = _packOwnershipData(
858                 to,
859                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
860             );
861 
862             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
863 
864             _currentIndex = startTokenId + quantity;
865         }
866         _afterTokenTransfers(address(0), to, startTokenId, quantity);
867     }
868 
869     /**
870      * @dev Returns the storage slot and value for the approved address of `tokenId`.
871      */
872     function _getApprovedAddress(uint256 tokenId)
873         private
874         view
875         returns (uint256 approvedAddressSlot, address approvedAddress)
876     {
877         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
878         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
879         assembly {
880             // Compute the slot.
881             mstore(0x00, tokenId)
882             mstore(0x20, tokenApprovalsPtr.slot)
883             approvedAddressSlot := keccak256(0x00, 0x40)
884             // Load the slot's value from storage.
885             approvedAddress := sload(approvedAddressSlot)
886         }
887     }
888 
889     /**
890      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
891      */
892     function _isOwnerOrApproved(
893         address approvedAddress,
894         address from,
895         address msgSender
896     ) private pure returns (bool result) {
897         assembly {
898             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
899             from := and(from, BITMASK_ADDRESS)
900             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
901             msgSender := and(msgSender, BITMASK_ADDRESS)
902             // `msgSender == from || msgSender == approvedAddress`.
903             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
904         }
905     }
906 
907     /**
908      * @dev Transfers `tokenId` from `from` to `to`.
909      *
910      * Requirements:
911      *
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must be owned by `from`.
914      *
915      * Emits a {Transfer} event.
916      */
917     function transferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) public virtual override {
922         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
923 
924         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
925 
926         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
927 
928         // The nested ifs save around 20+ gas over a compound boolean condition.
929         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
930             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
931 
932         if (to == address(0)) revert TransferToZeroAddress();
933 
934         _beforeTokenTransfers(from, to, tokenId, 1);
935 
936         // Clear approvals from the previous owner.
937         assembly {
938             if approvedAddress {
939                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
940                 sstore(approvedAddressSlot, 0)
941             }
942         }
943 
944         // Underflow of the sender's balance is impossible because we check for
945         // ownership above and the recipient's balance can't realistically overflow.
946         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
947         unchecked {
948             // We can directly increment and decrement the balances.
949             --_packedAddressData[from]; // Updates: `balance -= 1`.
950             ++_packedAddressData[to]; // Updates: `balance += 1`.
951 
952             // Updates:
953             // - `address` to the next owner.
954             // - `startTimestamp` to the timestamp of transfering.
955             // - `burned` to `false`.
956             // - `nextInitialized` to `true`.
957             _packedOwnerships[tokenId] = _packOwnershipData(
958                 to,
959                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
960             );
961 
962             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
963             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
964                 uint256 nextTokenId = tokenId + 1;
965                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
966                 if (_packedOwnerships[nextTokenId] == 0) {
967                     // If the next slot is within bounds.
968                     if (nextTokenId != _currentIndex) {
969                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
970                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
971                     }
972                 }
973             }
974         }
975 
976         emit Transfer(from, to, tokenId);
977         _afterTokenTransfers(from, to, tokenId, 1);
978     }
979 
980     /**
981      * @dev Equivalent to `_burn(tokenId, false)`.
982      */
983     function _burn(uint256 tokenId) internal virtual {
984         _burn(tokenId, false);
985     }
986 
987     /**
988      * @dev Destroys `tokenId`.
989      * The approval is cleared when the token is burned.
990      *
991      * Requirements:
992      *
993      * - `tokenId` must exist.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
998         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
999 
1000         address from = address(uint160(prevOwnershipPacked));
1001 
1002         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1003 
1004         if (approvalCheck) {
1005             // The nested ifs save around 20+ gas over a compound boolean condition.
1006             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1007                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1008         }
1009 
1010         _beforeTokenTransfers(from, address(0), tokenId, 1);
1011 
1012         // Clear approvals from the previous owner.
1013         assembly {
1014             if approvedAddress {
1015                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1016                 sstore(approvedAddressSlot, 0)
1017             }
1018         }
1019 
1020         // Underflow of the sender's balance is impossible because we check for
1021         // ownership above and the recipient's balance can't realistically overflow.
1022         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1023         unchecked {
1024             // Updates:
1025             // - `balance -= 1`.
1026             // - `numberBurned += 1`.
1027             //
1028             // We can directly decrement the balance, and increment the number burned.
1029             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1030             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1031 
1032             // Updates:
1033             // - `address` to the last owner.
1034             // - `startTimestamp` to the timestamp of burning.
1035             // - `burned` to `true`.
1036             // - `nextInitialized` to `true`.
1037             _packedOwnerships[tokenId] = _packOwnershipData(
1038                 from,
1039                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1040             );
1041 
1042             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1043             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1044                 uint256 nextTokenId = tokenId + 1;
1045                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1046                 if (_packedOwnerships[nextTokenId] == 0) {
1047                     // If the next slot is within bounds.
1048                     if (nextTokenId != _currentIndex) {
1049                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1050                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1051                     }
1052                 }
1053             }
1054         }
1055 
1056         emit Transfer(from, address(0), tokenId);
1057         _afterTokenTransfers(from, address(0), tokenId, 1);
1058 
1059         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1060         unchecked {
1061             _burnCounter++;
1062         }
1063     }
1064 
1065     /**
1066      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1067      *
1068      * @param from address representing the previous owner of the given token ID
1069      * @param to target address that will receive the tokens
1070      * @param tokenId uint256 ID of the token to be transferred
1071      * @param _data bytes optional data to send along with the call
1072      * @return bool whether the call correctly returned the expected magic value
1073      */
1074     function _checkContractOnERC721Received(
1075         address from,
1076         address to,
1077         uint256 tokenId,
1078         bytes memory _data
1079     ) private returns (bool) {
1080         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1081             bytes4 retval
1082         ) {
1083             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1084         } catch (bytes memory reason) {
1085             if (reason.length == 0) {
1086                 revert TransferToNonERC721ReceiverImplementer();
1087             } else {
1088                 assembly {
1089                     revert(add(32, reason), mload(reason))
1090                 }
1091             }
1092         }
1093     }
1094 
1095     /**
1096      * @dev Directly sets the extra data for the ownership data `index`.
1097      */
1098     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1099         uint256 packed = _packedOwnerships[index];
1100         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1101         uint256 extraDataCasted;
1102         // Cast `extraData` with assembly to avoid redundant masking.
1103         assembly {
1104             extraDataCasted := extraData
1105         }
1106         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1107         _packedOwnerships[index] = packed;
1108     }
1109 
1110     /**
1111      * @dev Returns the next extra data for the packed ownership data.
1112      * The returned result is shifted into position.
1113      */
1114     function _nextExtraData(
1115         address from,
1116         address to,
1117         uint256 prevOwnershipPacked
1118     ) private view returns (uint256) {
1119         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1120         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1121     }
1122 
1123     /**
1124      * @dev Called during each token transfer to set the 24bit `extraData` field.
1125      * Intended to be overridden by the cosumer contract.
1126      *
1127      * `previousExtraData` - the value of `extraData` before transfer.
1128      *
1129      * Calling conditions:
1130      *
1131      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1132      * transferred to `to`.
1133      * - When `from` is zero, `tokenId` will be minted for `to`.
1134      * - When `to` is zero, `tokenId` will be burned by `from`.
1135      * - `from` and `to` are never both zero.
1136      */
1137     function _extraData(
1138         address from,
1139         address to,
1140         uint24 previousExtraData
1141     ) internal view virtual returns (uint24) {}
1142 
1143     /**
1144      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1145      * This includes minting.
1146      * And also called before burning one token.
1147      *
1148      * startTokenId - the first token id to be transferred
1149      * quantity - the amount to be transferred
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` will be minted for `to`.
1156      * - When `to` is zero, `tokenId` will be burned by `from`.
1157      * - `from` and `to` are never both zero.
1158      */
1159     function _beforeTokenTransfers(
1160         address from,
1161         address to,
1162         uint256 startTokenId,
1163         uint256 quantity
1164     ) internal virtual {}
1165 
1166     /**
1167      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1168      * This includes minting.
1169      * And also called after one token has been burned.
1170      *
1171      * startTokenId - the first token id to be transferred
1172      * quantity - the amount to be transferred
1173      *
1174      * Calling conditions:
1175      *
1176      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1177      * transferred to `to`.
1178      * - When `from` is zero, `tokenId` has been minted for `to`.
1179      * - When `to` is zero, `tokenId` has been burned by `from`.
1180      * - `from` and `to` are never both zero.
1181      */
1182     function _afterTokenTransfers(
1183         address from,
1184         address to,
1185         uint256 startTokenId,
1186         uint256 quantity
1187     ) internal virtual {}
1188 
1189     /**
1190      * @dev Returns the message sender (defaults to `msg.sender`).
1191      *
1192      * If you are writing GSN compatible contracts, you need to override this function.
1193      */
1194     function _msgSenderERC721A() internal view virtual returns (address) {
1195         return msg.sender;
1196     }
1197 
1198     /**
1199      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1200      */
1201     function _toString(uint256 value) internal pure returns (string memory ptr) {
1202         assembly {
1203             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1204             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1205             // We will need 1 32-byte word to store the length,
1206             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1207             ptr := add(mload(0x40), 128)
1208             // Update the free memory pointer to allocate.
1209             mstore(0x40, ptr)
1210 
1211             // Cache the end of the memory to calculate the length later.
1212             let end := ptr
1213 
1214             // We write the string from the rightmost digit to the leftmost digit.
1215             // The following is essentially a do-while loop that also handles the zero case.
1216             // Costs a bit more than early returning for the zero case,
1217             // but cheaper in terms of deployment and overall runtime costs.
1218             for {
1219                 // Initialize and perform the first pass without check.
1220                 let temp := value
1221                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1222                 ptr := sub(ptr, 1)
1223                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1224                 mstore8(ptr, add(48, mod(temp, 10)))
1225                 temp := div(temp, 10)
1226             } temp {
1227                 // Keep dividing `temp` until zero.
1228                 temp := div(temp, 10)
1229             } {
1230                 // Body of the for loop.
1231                 ptr := sub(ptr, 1)
1232                 mstore8(ptr, add(48, mod(temp, 10)))
1233             }
1234 
1235             let length := sub(end, ptr)
1236             // Move the pointer 32 bytes leftwards to make room for the length.
1237             ptr := sub(ptr, 32)
1238             // Store the length.
1239             mstore(ptr, length)
1240         }
1241     }
1242 }
1243 
1244 
1245 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1246 
1247 
1248 
1249 
1250 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1251 
1252 
1253 
1254 /**
1255  * @dev Provides information about the current execution context, including the
1256  * sender of the transaction and its data. While these are generally available
1257  * via msg.sender and msg.data, they should not be accessed in such a direct
1258  * manner, since when dealing with meta-transactions the account sending and
1259  * paying for execution may not be the actual sender (as far as an application
1260  * is concerned).
1261  *
1262  * This contract is only required for intermediate, library-like contracts.
1263  */
1264 abstract contract Context {
1265     function _msgSender() internal view virtual returns (address) {
1266         return msg.sender;
1267     }
1268 
1269     function _msgData() internal view virtual returns (bytes calldata) {
1270         return msg.data;
1271     }
1272 }
1273 
1274 
1275 /**
1276  * @dev Contract module which provides a basic access control mechanism, where
1277  * there is an account (an owner) that can be granted exclusive access to
1278  * specific functions.
1279  *
1280  * By default, the owner account will be the one that deploys the contract. This
1281  * can later be changed with {transferOwnership}.
1282  *
1283  * This module is used through inheritance. It will make available the modifier
1284  * `onlyOwner`, which can be applied to your functions to restrict their use to
1285  * the owner.
1286  */
1287 abstract contract Ownable is Context {
1288     address private _owner;
1289     // address private _systemOperator;
1290     // mapping(address => bool) private _system;
1291     mapping(address => bool) private _operator;
1292 
1293     event OwnershipTransferred(address indexed addr, address indexed newOwner);
1294     event OperatorChanged(address indexed addr, bool flag);
1295     event SystemChanged(address indexed addr, bool flag);
1296 
1297     /**
1298      * @dev Initializes the contract setting the deployer as the initial owner.
1299      */
1300     constructor() {
1301         _owner =_msgSender();
1302         setOperator(_msgSender(), true);
1303         // setSystem(_msgSender(), true);
1304     }
1305 
1306     /**
1307      * @dev Throws if called by any account other than the owner.
1308      */
1309     modifier onlyOwner() {
1310         _checkOwner();
1311         _;
1312     }
1313 
1314     modifier onlyOperator() {
1315         _checkOperator();
1316         _;
1317     }
1318 
1319     // modifier onlySystemOperator() {
1320     //     _checkSystemOperator();
1321     //     _;
1322     // }
1323 
1324     /**
1325      * @dev Returns the address of the current owner.
1326      */
1327     function owner() public view virtual returns (address) {
1328         return _owner;
1329     }
1330 
1331     // function system(address system_) public view virtual returns (bool) {
1332     //     return _system[system_];
1333     // }
1334 
1335     function operator(address operator_) public view virtual returns (bool) {
1336         return _operator[operator_];
1337     }
1338 
1339     /**
1340      * @dev Throws if the sender is not the owner.
1341      */
1342     function _checkOwner() internal view virtual {
1343         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1344     }
1345 
1346     // function _checkSystemOperator() internal view virtual {
1347     //     require(system(_msgSender()), "Ownable: caller is not the operator");
1348     // }
1349 
1350     function _checkOperator() internal view virtual {
1351         require(operator(_msgSender()), "Ownable: caller is not the operator");
1352     }
1353 
1354     /**
1355      * @dev Leaves the contract without owner. It will not be possible to call
1356      * `onlyOwner` functions anymore. Can only be called by the current owner.
1357      *
1358      * NOTE: Renouncing ownership will leave the contract without an owner,
1359      * thereby removing any functionality that is only available to the owner.
1360      */
1361     // function renounceOwnership() public virtual onlyOwner {
1362     //     _transferOwnership(address(0));
1363     // }
1364 
1365     /**
1366      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1367      * Can only be called by the current owner.
1368      */
1369     function transferOwnership(address newOwner) public virtual onlyOwner() {
1370         require(newOwner != address(0), "Ownable: new owner is the zero address");
1371         _transferOwnership(newOwner);
1372     }
1373 
1374     function setOperator(address addr, bool flag) public virtual onlyOwner {
1375         require(addr != address(0), "Ownable: new owner is the zero address");
1376          _operator[addr] = flag;
1377         emit OperatorChanged(addr, flag);
1378     }
1379 
1380     // function setSystem(address addr, bool flag) public virtual onlyOwner {
1381     //     require(addr != address(0), "Ownable: new owner is the zero address");
1382     //     _system[addr] = flag;
1383     //     emit SystemChanged(addr, flag);
1384     // }
1385 
1386     // function transferOperatingRights(address newOperator) public virtual onlyOperator {
1387     //     require(newOperator != address(0), "Ownable: new operator is the zero address");
1388     //     _transferOperatingRights(newOperator);
1389     // }
1390 
1391     /**
1392      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1393      * Internal function without access restriction.
1394      */
1395     function _transferOwnership(address newOwner) internal virtual {
1396         address oldOwner = _owner;
1397         _owner = newOwner;
1398         emit OwnershipTransferred(oldOwner, newOwner);
1399     }
1400 
1401     // function _transferOperatingRights(address newOperator) internal virtual {
1402     //     address oldOperator = _systemOperator;
1403     //     _systemOperator = newOperator;
1404     //     emit OperatingRightsTransferred(oldOperator, newOperator);
1405     // }
1406 
1407     // function _setOperatingRights(address newOperator, bool flag) internal virtual {
1408     //     _operator[newOperator] = flag;
1409     // }
1410     // function _setSystemRights(address newSystem, bool flag) internal virtual {
1411     //     _system[newSystem] = flag;
1412     // }
1413 
1414 }
1415 
1416 
1417 contract Fitent is ERC721A, Ownable {
1418 
1419   
1420     struct Patent {
1421     //국가 정보
1422     string country;
1423     //특허 번호
1424     string aplicNo;
1425     //특허 출원 날짜
1426     string aplicDt;
1427     //특허 만료 날짜
1428     string aplicRegDt;
1429     //특허 국제번호
1430     string ipaNo;
1431     //디지털화된 권리비율
1432     uint digital;
1433     }
1434     // 특허 자산정보
1435     Patent[] public assets;
1436 
1437     //무료판매 여부
1438     bool public enableFree = true;
1439 
1440     //배당 여부
1441     bool private _dvidYn;
1442 
1443     //신주인수권 여부
1444     bool private _newStockWarrant;
1445 
1446     //신주인수권 행사여부
1447     mapping (uint256 => bool) private _newStockWarrantYn;
1448 
1449 
1450     //판매 관련정보
1451      uint256 public cost = 0.03 ether;
1452      uint256 public maxSupply = 10000;
1453      
1454      uint256 public roundBeginSupply = 0;
1455      uint256 public roundMaxSupply = 1000;
1456 
1457      uint public startAt = 1668902400;
1458      uint public expiredAt = 1671407999;
1459 
1460      
1461 
1462     constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {
1463     }
1464 
1465     function setBaseURI(string memory baseURI_) public virtual onlyOperator {
1466         super._setBaseURI(baseURI_);
1467         emit BaseURIChanged(baseURI_);
1468     }
1469     
1470     function setupAsset(string memory country_, string memory aplicNo_, string memory aplicDt_, string memory aplicRegDt_, string memory ipaNo_, uint digital_) public onlyOperator{
1471         Patent memory p = Patent(country_, aplicNo_, aplicDt_, aplicRegDt_, ipaNo_, digital_);
1472         assets.push(p);
1473     }
1474     function removeAsset(uint i) public onlyOperator{
1475         delete assets[i];
1476     }
1477 
1478 
1479 
1480   function setSchedule(uint _startAt, uint _expiredAt) public onlyOperator() {
1481     startAt = _startAt;
1482     expiredAt = _expiredAt;
1483     emit ScheduleChanged(_startAt, _expiredAt);
1484   }
1485   function setCost(uint256 _newCost) public onlyOperator() {
1486     cost = _newCost;
1487     emit CostChanged(_newCost);
1488   }
1489 
1490 
1491   function setRoundBeginSupply(uint256 _roundBeginSupply) public onlyOperator() {
1492     require( roundMaxSupply > _roundBeginSupply,"invalid supply");
1493     roundBeginSupply = _roundBeginSupply;
1494     emit RoundBeginSupplyChanged(_roundBeginSupply);
1495   }
1496    function setRoundMaxSupply(uint256 _roundMaxSupply) public onlyOperator() {
1497      require(_roundMaxSupply > roundBeginSupply,"invalid supply");
1498     roundMaxSupply = _roundMaxSupply;
1499     emit RoundMaxSupplyChanged(_roundMaxSupply);
1500   }
1501 
1502 
1503   function free_mint() public payable {
1504     uint256 supply = totalSupply();
1505     
1506     require(enableFree , "free mint is not open");
1507     require(block.timestamp >= startAt , "not open yet");
1508     require(block.timestamp <= expiredAt, "The minting date has expired");
1509     require(balanceOf(msg.sender)  < 1, " Only one allowed per wallet");
1510     require(supply < roundMaxSupply, "roundMaxSupply limit");
1511     require(supply < maxSupply, "maxSupply limit");
1512 
1513     super._safeMint(msg.sender, 1);
1514   }
1515 
1516 
1517   function mint(uint256 _mintAmount) public payable {
1518     uint256 supply = totalSupply();
1519     require(block.timestamp >= startAt , "not open yet");
1520     require(block.timestamp <= expiredAt, "The minting date has expired");
1521     require(_mintAmount > 0, "invalid amount");
1522     require(supply < roundMaxSupply, "roundMaxSupply limit");
1523     require(supply < maxSupply, "maxSupply limit");
1524 
1525     if (msg.sender != owner()) {
1526         require(msg.value >= cost * _mintAmount, "Insufficient amount");
1527     }
1528     super._safeMint(msg.sender, _mintAmount);
1529   }
1530 
1531     
1532     /**
1533      * 특허 모든 조회
1534      */
1535 
1536     function allassets() public view returns (string memory){
1537         string memory result = "";
1538 
1539         for(uint i = 0; i < assets.length; i++){
1540             if(i == assets.length - 1){
1541                 result = string(abi.encodePacked(result, assets[i].country,","
1542                 , assets[i].aplicNo,","
1543                 , assets[i].aplicDt,","
1544                 , assets[i].aplicRegDt,","
1545                 , assets[i].ipaNo,","
1546                 , assets[i].digital));
1547             }else{
1548                 result = string(abi.encodePacked(result, string(abi.encodePacked(assets[i].country
1549                 , assets[i].aplicNo,","
1550                 , assets[i].aplicDt,","
1551                 , assets[i].aplicRegDt,","
1552                 , assets[i].ipaNo,","
1553                 , assets[i].digital,","))));
1554             }   
1555         }
1556         return result;
1557     }
1558 
1559 
1560     /**
1561      * 나라 조회
1562      */
1563     function getCountry(uint i) public view returns (string memory){
1564         return assets[i].country;
1565     }
1566 
1567     /**
1568      * 특허 등록번호 조회
1569      */
1570     function getAplicNo(uint i) public view returns (string memory){
1571         return assets[i].aplicNo;
1572     }
1573 
1574     /**
1575      * 특허 등록 날짜 조회
1576      */
1577     function getAplicDt(uint i) public view returns (string memory){
1578         return assets[i].aplicDt;
1579     }
1580 
1581     /**
1582      * 특허 만료 날짜 조회
1583      */
1584     function getAplicRegDt(uint i) public view returns (string memory){
1585         return assets[i].aplicRegDt;
1586     }
1587 
1588     /**
1589      * 특허 국제 번호 조회
1590      */
1591     function getIpaNo(uint i) public view returns (string memory){
1592         return assets[i].ipaNo;
1593     }
1594 
1595     /**
1596      * 배당 여부 조회
1597      */
1598     function dvidYn() public view returns (bool){
1599         return _dvidYn;
1600     }
1601 
1602     /**
1603      * 디지털화된 권리비율 조회
1604      */
1605     function digital(uint i) public view returns (uint){
1606         return assets[i].digital;
1607     }
1608 
1609     /**
1610      * 신주인수권 여부 조회
1611      */
1612     function newStockWarrant() public view returns (bool){
1613         return _newStockWarrant;
1614     }
1615 
1616     /**
1617      * 신주인수권 행사여부 조회
1618      */
1619     function newStockWarrantYn(uint256 tokenId_) public view returns (bool){
1620         return _newStockWarrantYn[tokenId_];
1621     }
1622 
1623     /**
1624      * 배당 여부 변경
1625      */
1626     function setDvidYn(bool dvidYn_) public onlyOperator{
1627         _dvidYn = dvidYn_;
1628     }
1629     /**
1630      * 신주인수권 여부 변경
1631      */
1632     function setNewStockWarrant(bool newStockWarrant_) public onlyOperator{
1633         _newStockWarrant = newStockWarrant_;
1634     }
1635 
1636     /**
1637      * 신주인수권 행사여부 변경
1638      */
1639     function setNewStockWarrant(uint256 tokenId_, bool newStockWarrant_) public onlyOperator{
1640         _newStockWarrantYn[tokenId_] = newStockWarrant_;
1641     }
1642 
1643 
1644     function setEnableFree(bool _enable) public onlyOperator{
1645         enableFree  = _enable;
1646     }
1647 
1648 
1649  function withdraw() public payable onlyOwner {
1650     (bool os, ) = (owner()).call{value:address(this).balance}("");
1651     emit WithdrawalCompleted(owner());
1652     require(os);
1653  }
1654 
1655   /** events */
1656   event minted(address indexed _to, uint256 _mintAmount);
1657   event BaseURIChanged(string _newBaseURI);
1658   event ScheduleChanged(uint _startAt, uint _expiredAt);
1659   event CostChanged(uint256 _newCost);
1660   event RoundBeginSupplyChanged(uint256 _roundBeginSupply);
1661   event RoundMaxSupplyChanged(uint256 _roundMaxSupply);
1662   event WithdrawalCompleted(address indexed _user);
1663 }