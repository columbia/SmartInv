1 // Sources flattened with hardhat v2.10.2 https://hardhat.org
2 
3 // File erc721a/contracts/IERC721A.sol@v4.1.0
4 
5 // ERC721A Contracts v4.1.0
6 // Creator: Chiru Labs
7 
8 pragma solidity ^0.8.4;
9 
10 /**
11  * @dev Interface of an ERC721A compliant contract.
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
25      * The caller cannot approve to their own address.
26      */
27     error ApproveToCaller();
28 
29     /**
30      * Cannot query the balance for the zero address.
31      */
32     error BalanceQueryForZeroAddress();
33 
34     /**
35      * Cannot mint to the zero address.
36      */
37     error MintToZeroAddress();
38 
39     /**
40      * The quantity of tokens minted must be more than zero.
41      */
42     error MintZeroQuantity();
43 
44     /**
45      * The token does not exist.
46      */
47     error OwnerQueryForNonexistentToken();
48 
49     /**
50      * The caller must own the token or be an approved operator.
51      */
52     error TransferCallerNotOwnerNorApproved();
53 
54     /**
55      * The token must be owned by `from`.
56      */
57     error TransferFromIncorrectOwner();
58 
59     /**
60      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
61      */
62     error TransferToNonERC721ReceiverImplementer();
63 
64     /**
65      * Cannot transfer to the zero address.
66      */
67     error TransferToZeroAddress();
68 
69     /**
70      * The token does not exist.
71      */
72     error URIQueryForNonexistentToken();
73 
74     /**
75      * The `quantity` minted with ERC2309 exceeds the safety limit.
76      */
77     error MintERC2309QuantityExceedsLimit();
78 
79     /**
80      * The `extraData` cannot be set on an unintialized ownership slot.
81      */
82     error OwnershipNotInitializedForExtraData();
83 
84     struct TokenOwnership {
85         // The address of the owner.
86         address addr;
87         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
88         uint64 startTimestamp;
89         // Whether the token has been burned.
90         bool burned;
91         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
92         uint24 extraData;
93     }
94 
95     /**
96      * @dev Returns the total amount of tokens stored by the contract.
97      *
98      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     // ==============================
103     //            IERC165
104     // ==============================
105 
106     /**
107      * @dev Returns true if this contract implements the interface defined by
108      * `interfaceId`. See the corresponding
109      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
110      * to learn more about how these ids are created.
111      *
112      * This function call must use less than 30 000 gas.
113      */
114     function supportsInterface(bytes4 interfaceId) external view returns (bool);
115 
116     // ==============================
117     //            IERC721
118     // ==============================
119 
120     /**
121      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
124 
125     /**
126      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
127      */
128     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
132      */
133     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
134 
135     /**
136      * @dev Returns the number of tokens in ``owner``'s account.
137      */
138     function balanceOf(address owner) external view returns (uint256 balance);
139 
140     /**
141      * @dev Returns the owner of the `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function ownerOf(uint256 tokenId) external view returns (address owner);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId,
166         bytes calldata data
167     ) external;
168 
169     /**
170      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
171      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
179      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) external;
188 
189     /**
190      * @dev Transfers `tokenId` token from `from` to `to`.
191      *
192      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must be owned by `from`.
199      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external;
208 
209     /**
210      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
211      * The approval is cleared when the token is transferred.
212      *
213      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
214      *
215      * Requirements:
216      *
217      * - The caller must own the token or be an approved operator.
218      * - `tokenId` must exist.
219      *
220      * Emits an {Approval} event.
221      */
222     function approve(address to, uint256 tokenId) external;
223 
224     /**
225      * @dev Approve or remove `operator` as an operator for the caller.
226      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
227      *
228      * Requirements:
229      *
230      * - The `operator` cannot be the caller.
231      *
232      * Emits an {ApprovalForAll} event.
233      */
234     function setApprovalForAll(address operator, bool _approved) external;
235 
236     /**
237      * @dev Returns the account approved for `tokenId` token.
238      *
239      * Requirements:
240      *
241      * - `tokenId` must exist.
242      */
243     function getApproved(uint256 tokenId) external view returns (address operator);
244 
245     /**
246      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
247      *
248      * See {setApprovalForAll}
249      */
250     function isApprovedForAll(address owner, address operator) external view returns (bool);
251 
252     // ==============================
253     //        IERC721Metadata
254     // ==============================
255 
256     /**
257      * @dev Returns the token collection name.
258      */
259     function name() external view returns (string memory);
260 
261     /**
262      * @dev Returns the token collection symbol.
263      */
264     function symbol() external view returns (string memory);
265 
266     /**
267      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
268      */
269     function tokenURI(uint256 tokenId) external view returns (string memory);
270 
271     // ==============================
272     //            IERC2309
273     // ==============================
274 
275     /**
276      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
277      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
278      */
279     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
280 }
281 
282 
283 // File erc721a/contracts/ERC721A.sol@v4.1.0
284 
285 // ERC721A Contracts v4.1.0
286 // Creator: Chiru Labs
287 
288 pragma solidity ^0.8.4;
289 
290 /**
291  * @dev ERC721 token receiver interface.
292  */
293 interface ERC721A__IERC721Receiver {
294     function onERC721Received(
295         address operator,
296         address from,
297         uint256 tokenId,
298         bytes calldata data
299     ) external returns (bytes4);
300 }
301 
302 /**
303  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
304  * including the Metadata extension. Built to optimize for lower gas during batch mints.
305  *
306  * Assumes serials are sequentially minted starting at `_startTokenId()`
307  * (defaults to 0, e.g. 0, 1, 2, 3..).
308  *
309  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
310  *
311  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
312  */
313 contract ERC721A is IERC721A {
314     // Mask of an entry in packed address data.
315     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
316 
317     // The bit position of `numberMinted` in packed address data.
318     uint256 private constant BITPOS_NUMBER_MINTED = 64;
319 
320     // The bit position of `numberBurned` in packed address data.
321     uint256 private constant BITPOS_NUMBER_BURNED = 128;
322 
323     // The bit position of `aux` in packed address data.
324     uint256 private constant BITPOS_AUX = 192;
325 
326     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
327     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
328 
329     // The bit position of `startTimestamp` in packed ownership.
330     uint256 private constant BITPOS_START_TIMESTAMP = 160;
331 
332     // The bit mask of the `burned` bit in packed ownership.
333     uint256 private constant BITMASK_BURNED = 1 << 224;
334 
335     // The bit position of the `nextInitialized` bit in packed ownership.
336     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
337 
338     // The bit mask of the `nextInitialized` bit in packed ownership.
339     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
340 
341     // The bit position of `extraData` in packed ownership.
342     uint256 private constant BITPOS_EXTRA_DATA = 232;
343 
344     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
345     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
346 
347     // The mask of the lower 160 bits for addresses.
348     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
349 
350     // The maximum `quantity` that can be minted with `_mintERC2309`.
351     // This limit is to prevent overflows on the address data entries.
352     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
353     // is required to cause an overflow, which is unrealistic.
354     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
355 
356     // The tokenId of the next token to be minted.
357     uint256 private _currentIndex;
358 
359     // The number of tokens burned.
360     uint256 private _burnCounter;
361 
362     // Token name
363     string private _name;
364 
365     // Token symbol
366     string private _symbol;
367 
368     // Mapping from token ID to ownership details
369     // An empty struct value does not necessarily mean the token is unowned.
370     // See `_packedOwnershipOf` implementation for details.
371     //
372     // Bits Layout:
373     // - [0..159]   `addr`
374     // - [160..223] `startTimestamp`
375     // - [224]      `burned`
376     // - [225]      `nextInitialized`
377     // - [232..255] `extraData`
378     mapping(uint256 => uint256) private _packedOwnerships;
379 
380     // Mapping owner address to address data.
381     //
382     // Bits Layout:
383     // - [0..63]    `balance`
384     // - [64..127]  `numberMinted`
385     // - [128..191] `numberBurned`
386     // - [192..255] `aux`
387     mapping(address => uint256) private _packedAddressData;
388 
389     // Mapping from token ID to approved address.
390     mapping(uint256 => address) private _tokenApprovals;
391 
392     // Mapping from owner to operator approvals
393     mapping(address => mapping(address => bool)) private _operatorApprovals;
394 
395     constructor(string memory name_, string memory symbol_) {
396         _name = name_;
397         _symbol = symbol_;
398         _currentIndex = _startTokenId();
399     }
400 
401     /**
402      * @dev Returns the starting token ID.
403      * To change the starting token ID, please override this function.
404      */
405     function _startTokenId() internal view virtual returns (uint256) {
406         return 0;
407     }
408 
409     /**
410      * @dev Returns the next token ID to be minted.
411      */
412     function _nextTokenId() internal view returns (uint256) {
413         return _currentIndex;
414     }
415 
416     /**
417      * @dev Returns the total number of tokens in existence.
418      * Burned tokens will reduce the count.
419      * To get the total number of tokens minted, please see `_totalMinted`.
420      */
421     function totalSupply() public view override returns (uint256) {
422         // Counter underflow is impossible as _burnCounter cannot be incremented
423         // more than `_currentIndex - _startTokenId()` times.
424         unchecked {
425             return _currentIndex - _burnCounter - _startTokenId();
426         }
427     }
428 
429     /**
430      * @dev Returns the total amount of tokens minted in the contract.
431      */
432     function _totalMinted() internal view returns (uint256) {
433         // Counter underflow is impossible as _currentIndex does not decrement,
434         // and it is initialized to `_startTokenId()`
435         unchecked {
436             return _currentIndex - _startTokenId();
437         }
438     }
439 
440     /**
441      * @dev Returns the total number of tokens burned.
442      */
443     function _totalBurned() internal view returns (uint256) {
444         return _burnCounter;
445     }
446 
447     /**
448      * @dev See {IERC165-supportsInterface}.
449      */
450     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
451         // The interface IDs are constants representing the first 4 bytes of the XOR of
452         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
453         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
454         return
455             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
456             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
457             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
458     }
459 
460     /**
461      * @dev See {IERC721-balanceOf}.
462      */
463     function balanceOf(address owner) public view override returns (uint256) {
464         if (owner == address(0)) revert BalanceQueryForZeroAddress();
465         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
466     }
467 
468     /**
469      * Returns the number of tokens minted by `owner`.
470      */
471     function _numberMinted(address owner) internal view returns (uint256) {
472         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
473     }
474 
475     /**
476      * Returns the number of tokens burned by or on behalf of `owner`.
477      */
478     function _numberBurned(address owner) internal view returns (uint256) {
479         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
480     }
481 
482     /**
483      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
484      */
485     function _getAux(address owner) internal view returns (uint64) {
486         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
487     }
488 
489     /**
490      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
491      * If there are multiple variables, please pack them into a uint64.
492      */
493     function _setAux(address owner, uint64 aux) internal {
494         uint256 packed = _packedAddressData[owner];
495         uint256 auxCasted;
496         // Cast `aux` with assembly to avoid redundant masking.
497         assembly {
498             auxCasted := aux
499         }
500         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
501         _packedAddressData[owner] = packed;
502     }
503 
504     /**
505      * Returns the packed ownership data of `tokenId`.
506      */
507     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
508         uint256 curr = tokenId;
509 
510         unchecked {
511             if (_startTokenId() <= curr)
512                 if (curr < _currentIndex) {
513                     uint256 packed = _packedOwnerships[curr];
514                     // If not burned.
515                     if (packed & BITMASK_BURNED == 0) {
516                         // Invariant:
517                         // There will always be an ownership that has an address and is not burned
518                         // before an ownership that does not have an address and is not burned.
519                         // Hence, curr will not underflow.
520                         //
521                         // We can directly compare the packed value.
522                         // If the address is zero, packed is zero.
523                         while (packed == 0) {
524                             packed = _packedOwnerships[--curr];
525                         }
526                         return packed;
527                     }
528                 }
529         }
530         revert OwnerQueryForNonexistentToken();
531     }
532 
533     /**
534      * Returns the unpacked `TokenOwnership` struct from `packed`.
535      */
536     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
537         ownership.addr = address(uint160(packed));
538         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
539         ownership.burned = packed & BITMASK_BURNED != 0;
540         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
541     }
542 
543     /**
544      * Returns the unpacked `TokenOwnership` struct at `index`.
545      */
546     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
547         return _unpackedOwnership(_packedOwnerships[index]);
548     }
549 
550     /**
551      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
552      */
553     function _initializeOwnershipAt(uint256 index) internal {
554         if (_packedOwnerships[index] == 0) {
555             _packedOwnerships[index] = _packedOwnershipOf(index);
556         }
557     }
558 
559     /**
560      * Gas spent here starts off proportional to the maximum mint batch size.
561      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
562      */
563     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
564         return _unpackedOwnership(_packedOwnershipOf(tokenId));
565     }
566 
567     /**
568      * @dev Packs ownership data into a single uint256.
569      */
570     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
571         assembly {
572             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
573             owner := and(owner, BITMASK_ADDRESS)
574             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
575             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
576         }
577     }
578 
579     /**
580      * @dev See {IERC721-ownerOf}.
581      */
582     function ownerOf(uint256 tokenId) public view override returns (address) {
583         return address(uint160(_packedOwnershipOf(tokenId)));
584     }
585 
586     /**
587      * @dev See {IERC721Metadata-name}.
588      */
589     function name() public view virtual override returns (string memory) {
590         return _name;
591     }
592 
593     /**
594      * @dev See {IERC721Metadata-symbol}.
595      */
596     function symbol() public view virtual override returns (string memory) {
597         return _symbol;
598     }
599 
600     /**
601      * @dev See {IERC721Metadata-tokenURI}.
602      */
603     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
604         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
605 
606         string memory baseURI = _baseURI();
607         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
608     }
609 
610     /**
611      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
612      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
613      * by default, it can be overridden in child contracts.
614      */
615     function _baseURI() internal view virtual returns (string memory) {
616         return '';
617     }
618 
619     /**
620      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
621      */
622     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
623         // For branchless setting of the `nextInitialized` flag.
624         assembly {
625             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
626             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
627         }
628     }
629 
630     /**
631      * @dev See {IERC721-approve}.
632      */
633     function approve(address to, uint256 tokenId) public override {
634         address owner = ownerOf(tokenId);
635 
636         if (_msgSenderERC721A() != owner)
637             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
638                 revert ApprovalCallerNotOwnerNorApproved();
639             }
640 
641         _tokenApprovals[tokenId] = to;
642         emit Approval(owner, to, tokenId);
643     }
644 
645     /**
646      * @dev See {IERC721-getApproved}.
647      */
648     function getApproved(uint256 tokenId) public view override returns (address) {
649         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
650 
651         return _tokenApprovals[tokenId];
652     }
653 
654     /**
655      * @dev See {IERC721-setApprovalForAll}.
656      */
657     function setApprovalForAll(address operator, bool approved) public virtual override {
658         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
659 
660         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
661         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
662     }
663 
664     /**
665      * @dev See {IERC721-isApprovedForAll}.
666      */
667     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
668         return _operatorApprovals[owner][operator];
669     }
670 
671     /**
672      * @dev See {IERC721-safeTransferFrom}.
673      */
674     function safeTransferFrom(
675         address from,
676         address to,
677         uint256 tokenId
678     ) public virtual override {
679         safeTransferFrom(from, to, tokenId, '');
680     }
681 
682     /**
683      * @dev See {IERC721-safeTransferFrom}.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId,
689         bytes memory _data
690     ) public virtual override {
691         transferFrom(from, to, tokenId);
692         if (to.code.length != 0)
693             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
694                 revert TransferToNonERC721ReceiverImplementer();
695             }
696     }
697 
698     /**
699      * @dev Returns whether `tokenId` exists.
700      *
701      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
702      *
703      * Tokens start existing when they are minted (`_mint`),
704      */
705     function _exists(uint256 tokenId) internal view returns (bool) {
706         return
707             _startTokenId() <= tokenId &&
708             tokenId < _currentIndex && // If within bounds,
709             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
710     }
711 
712     /**
713      * @dev Equivalent to `_safeMint(to, quantity, '')`.
714      */
715     function _safeMint(address to, uint256 quantity) internal {
716         _safeMint(to, quantity, '');
717     }
718 
719     /**
720      * @dev Safely mints `quantity` tokens and transfers them to `to`.
721      *
722      * Requirements:
723      *
724      * - If `to` refers to a smart contract, it must implement
725      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
726      * - `quantity` must be greater than 0.
727      *
728      * See {_mint}.
729      *
730      * Emits a {Transfer} event for each mint.
731      */
732     function _safeMint(
733         address to,
734         uint256 quantity,
735         bytes memory _data
736     ) internal {
737         _mint(to, quantity);
738 
739         unchecked {
740             if (to.code.length != 0) {
741                 uint256 end = _currentIndex;
742                 uint256 index = end - quantity;
743                 do {
744                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
745                         revert TransferToNonERC721ReceiverImplementer();
746                     }
747                 } while (index < end);
748                 // Reentrancy protection.
749                 if (_currentIndex != end) revert();
750             }
751         }
752     }
753 
754     /**
755      * @dev Mints `quantity` tokens and transfers them to `to`.
756      *
757      * Requirements:
758      *
759      * - `to` cannot be the zero address.
760      * - `quantity` must be greater than 0.
761      *
762      * Emits a {Transfer} event for each mint.
763      */
764     function _mint(address to, uint256 quantity) internal {
765         uint256 startTokenId = _currentIndex;
766         if (to == address(0)) revert MintToZeroAddress();
767         if (quantity == 0) revert MintZeroQuantity();
768 
769         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
770 
771         // Overflows are incredibly unrealistic.
772         // `balance` and `numberMinted` have a maximum limit of 2**64.
773         // `tokenId` has a maximum limit of 2**256.
774         unchecked {
775             // Updates:
776             // - `balance += quantity`.
777             // - `numberMinted += quantity`.
778             //
779             // We can directly add to the `balance` and `numberMinted`.
780             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
781 
782             // Updates:
783             // - `address` to the owner.
784             // - `startTimestamp` to the timestamp of minting.
785             // - `burned` to `false`.
786             // - `nextInitialized` to `quantity == 1`.
787             _packedOwnerships[startTokenId] = _packOwnershipData(
788                 to,
789                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
790             );
791 
792             uint256 tokenId = startTokenId;
793             uint256 end = startTokenId + quantity;
794             do {
795                 emit Transfer(address(0), to, tokenId++);
796             } while (tokenId < end);
797 
798             _currentIndex = end;
799         }
800         _afterTokenTransfers(address(0), to, startTokenId, quantity);
801     }
802 
803     /**
804      * @dev Mints `quantity` tokens and transfers them to `to`.
805      *
806      * This function is intended for efficient minting only during contract creation.
807      *
808      * It emits only one {ConsecutiveTransfer} as defined in
809      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
810      * instead of a sequence of {Transfer} event(s).
811      *
812      * Calling this function outside of contract creation WILL make your contract
813      * non-compliant with the ERC721 standard.
814      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
815      * {ConsecutiveTransfer} event is only permissible during contract creation.
816      *
817      * Requirements:
818      *
819      * - `to` cannot be the zero address.
820      * - `quantity` must be greater than 0.
821      *
822      * Emits a {ConsecutiveTransfer} event.
823      */
824     function _mintERC2309(address to, uint256 quantity) internal {
825         uint256 startTokenId = _currentIndex;
826         if (to == address(0)) revert MintToZeroAddress();
827         if (quantity == 0) revert MintZeroQuantity();
828         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
829 
830         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
831 
832         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
833         unchecked {
834             // Updates:
835             // - `balance += quantity`.
836             // - `numberMinted += quantity`.
837             //
838             // We can directly add to the `balance` and `numberMinted`.
839             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
840 
841             // Updates:
842             // - `address` to the owner.
843             // - `startTimestamp` to the timestamp of minting.
844             // - `burned` to `false`.
845             // - `nextInitialized` to `quantity == 1`.
846             _packedOwnerships[startTokenId] = _packOwnershipData(
847                 to,
848                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
849             );
850 
851             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
852 
853             _currentIndex = startTokenId + quantity;
854         }
855         _afterTokenTransfers(address(0), to, startTokenId, quantity);
856     }
857 
858     /**
859      * @dev Returns the storage slot and value for the approved address of `tokenId`.
860      */
861     function _getApprovedAddress(uint256 tokenId)
862         private
863         view
864         returns (uint256 approvedAddressSlot, address approvedAddress)
865     {
866         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
867         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
868         assembly {
869             // Compute the slot.
870             mstore(0x00, tokenId)
871             mstore(0x20, tokenApprovalsPtr.slot)
872             approvedAddressSlot := keccak256(0x00, 0x40)
873             // Load the slot's value from storage.
874             approvedAddress := sload(approvedAddressSlot)
875         }
876     }
877 
878     /**
879      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
880      */
881     function _isOwnerOrApproved(
882         address approvedAddress,
883         address from,
884         address msgSender
885     ) private pure returns (bool result) {
886         assembly {
887             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
888             from := and(from, BITMASK_ADDRESS)
889             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
890             msgSender := and(msgSender, BITMASK_ADDRESS)
891             // `msgSender == from || msgSender == approvedAddress`.
892             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
893         }
894     }
895 
896     /**
897      * @dev Transfers `tokenId` from `from` to `to`.
898      *
899      * Requirements:
900      *
901      * - `to` cannot be the zero address.
902      * - `tokenId` token must be owned by `from`.
903      *
904      * Emits a {Transfer} event.
905      */
906     function transferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
912 
913         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
914 
915         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
916 
917         // The nested ifs save around 20+ gas over a compound boolean condition.
918         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
919             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
920 
921         if (to == address(0)) revert TransferToZeroAddress();
922 
923         _beforeTokenTransfers(from, to, tokenId, 1);
924 
925         // Clear approvals from the previous owner.
926         assembly {
927             if approvedAddress {
928                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
929                 sstore(approvedAddressSlot, 0)
930             }
931         }
932 
933         // Underflow of the sender's balance is impossible because we check for
934         // ownership above and the recipient's balance can't realistically overflow.
935         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
936         unchecked {
937             // We can directly increment and decrement the balances.
938             --_packedAddressData[from]; // Updates: `balance -= 1`.
939             ++_packedAddressData[to]; // Updates: `balance += 1`.
940 
941             // Updates:
942             // - `address` to the next owner.
943             // - `startTimestamp` to the timestamp of transfering.
944             // - `burned` to `false`.
945             // - `nextInitialized` to `true`.
946             _packedOwnerships[tokenId] = _packOwnershipData(
947                 to,
948                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
949             );
950 
951             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
952             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
953                 uint256 nextTokenId = tokenId + 1;
954                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
955                 if (_packedOwnerships[nextTokenId] == 0) {
956                     // If the next slot is within bounds.
957                     if (nextTokenId != _currentIndex) {
958                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
959                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
960                     }
961                 }
962             }
963         }
964 
965         emit Transfer(from, to, tokenId);
966         _afterTokenTransfers(from, to, tokenId, 1);
967     }
968 
969     /**
970      * @dev Equivalent to `_burn(tokenId, false)`.
971      */
972     function _burn(uint256 tokenId) internal virtual {
973         _burn(tokenId, false);
974     }
975 
976     /**
977      * @dev Destroys `tokenId`.
978      * The approval is cleared when the token is burned.
979      *
980      * Requirements:
981      *
982      * - `tokenId` must exist.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
987         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
988 
989         address from = address(uint160(prevOwnershipPacked));
990 
991         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
992 
993         if (approvalCheck) {
994             // The nested ifs save around 20+ gas over a compound boolean condition.
995             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
996                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
997         }
998 
999         _beforeTokenTransfers(from, address(0), tokenId, 1);
1000 
1001         // Clear approvals from the previous owner.
1002         assembly {
1003             if approvedAddress {
1004                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1005                 sstore(approvedAddressSlot, 0)
1006             }
1007         }
1008 
1009         // Underflow of the sender's balance is impossible because we check for
1010         // ownership above and the recipient's balance can't realistically overflow.
1011         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1012         unchecked {
1013             // Updates:
1014             // - `balance -= 1`.
1015             // - `numberBurned += 1`.
1016             //
1017             // We can directly decrement the balance, and increment the number burned.
1018             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1019             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1020 
1021             // Updates:
1022             // - `address` to the last owner.
1023             // - `startTimestamp` to the timestamp of burning.
1024             // - `burned` to `true`.
1025             // - `nextInitialized` to `true`.
1026             _packedOwnerships[tokenId] = _packOwnershipData(
1027                 from,
1028                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1029             );
1030 
1031             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1032             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1033                 uint256 nextTokenId = tokenId + 1;
1034                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1035                 if (_packedOwnerships[nextTokenId] == 0) {
1036                     // If the next slot is within bounds.
1037                     if (nextTokenId != _currentIndex) {
1038                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1039                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1040                     }
1041                 }
1042             }
1043         }
1044 
1045         emit Transfer(from, address(0), tokenId);
1046         _afterTokenTransfers(from, address(0), tokenId, 1);
1047 
1048         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1049         unchecked {
1050             _burnCounter++;
1051         }
1052     }
1053 
1054     /**
1055      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1056      *
1057      * @param from address representing the previous owner of the given token ID
1058      * @param to target address that will receive the tokens
1059      * @param tokenId uint256 ID of the token to be transferred
1060      * @param _data bytes optional data to send along with the call
1061      * @return bool whether the call correctly returned the expected magic value
1062      */
1063     function _checkContractOnERC721Received(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) private returns (bool) {
1069         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1070             bytes4 retval
1071         ) {
1072             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1073         } catch (bytes memory reason) {
1074             if (reason.length == 0) {
1075                 revert TransferToNonERC721ReceiverImplementer();
1076             } else {
1077                 assembly {
1078                     revert(add(32, reason), mload(reason))
1079                 }
1080             }
1081         }
1082     }
1083 
1084     /**
1085      * @dev Directly sets the extra data for the ownership data `index`.
1086      */
1087     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1088         uint256 packed = _packedOwnerships[index];
1089         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1090         uint256 extraDataCasted;
1091         // Cast `extraData` with assembly to avoid redundant masking.
1092         assembly {
1093             extraDataCasted := extraData
1094         }
1095         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1096         _packedOwnerships[index] = packed;
1097     }
1098 
1099     /**
1100      * @dev Returns the next extra data for the packed ownership data.
1101      * The returned result is shifted into position.
1102      */
1103     function _nextExtraData(
1104         address from,
1105         address to,
1106         uint256 prevOwnershipPacked
1107     ) private view returns (uint256) {
1108         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1109         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1110     }
1111 
1112     /**
1113      * @dev Called during each token transfer to set the 24bit `extraData` field.
1114      * Intended to be overridden by the cosumer contract.
1115      *
1116      * `previousExtraData` - the value of `extraData` before transfer.
1117      *
1118      * Calling conditions:
1119      *
1120      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1121      * transferred to `to`.
1122      * - When `from` is zero, `tokenId` will be minted for `to`.
1123      * - When `to` is zero, `tokenId` will be burned by `from`.
1124      * - `from` and `to` are never both zero.
1125      */
1126     function _extraData(
1127         address from,
1128         address to,
1129         uint24 previousExtraData
1130     ) internal view virtual returns (uint24) {}
1131 
1132     /**
1133      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1134      * This includes minting.
1135      * And also called before burning one token.
1136      *
1137      * startTokenId - the first token id to be transferred
1138      * quantity - the amount to be transferred
1139      *
1140      * Calling conditions:
1141      *
1142      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1143      * transferred to `to`.
1144      * - When `from` is zero, `tokenId` will be minted for `to`.
1145      * - When `to` is zero, `tokenId` will be burned by `from`.
1146      * - `from` and `to` are never both zero.
1147      */
1148     function _beforeTokenTransfers(
1149         address from,
1150         address to,
1151         uint256 startTokenId,
1152         uint256 quantity
1153     ) internal virtual {}
1154 
1155     /**
1156      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1157      * This includes minting.
1158      * And also called after one token has been burned.
1159      *
1160      * startTokenId - the first token id to be transferred
1161      * quantity - the amount to be transferred
1162      *
1163      * Calling conditions:
1164      *
1165      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1166      * transferred to `to`.
1167      * - When `from` is zero, `tokenId` has been minted for `to`.
1168      * - When `to` is zero, `tokenId` has been burned by `from`.
1169      * - `from` and `to` are never both zero.
1170      */
1171     function _afterTokenTransfers(
1172         address from,
1173         address to,
1174         uint256 startTokenId,
1175         uint256 quantity
1176     ) internal virtual {}
1177 
1178     /**
1179      * @dev Returns the message sender (defaults to `msg.sender`).
1180      *
1181      * If you are writing GSN compatible contracts, you need to override this function.
1182      */
1183     function _msgSenderERC721A() internal view virtual returns (address) {
1184         return msg.sender;
1185     }
1186 
1187     /**
1188      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1189      */
1190     function _toString(uint256 value) internal pure returns (string memory ptr) {
1191         assembly {
1192             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1193             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1194             // We will need 1 32-byte word to store the length,
1195             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1196             ptr := add(mload(0x40), 128)
1197             // Update the free memory pointer to allocate.
1198             mstore(0x40, ptr)
1199 
1200             // Cache the end of the memory to calculate the length later.
1201             let end := ptr
1202 
1203             // We write the string from the rightmost digit to the leftmost digit.
1204             // The following is essentially a do-while loop that also handles the zero case.
1205             // Costs a bit more than early returning for the zero case,
1206             // but cheaper in terms of deployment and overall runtime costs.
1207             for {
1208                 // Initialize and perform the first pass without check.
1209                 let temp := value
1210                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1211                 ptr := sub(ptr, 1)
1212                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1213                 mstore8(ptr, add(48, mod(temp, 10)))
1214                 temp := div(temp, 10)
1215             } temp {
1216                 // Keep dividing `temp` until zero.
1217                 temp := div(temp, 10)
1218             } {
1219                 // Body of the for loop.
1220                 ptr := sub(ptr, 1)
1221                 mstore8(ptr, add(48, mod(temp, 10)))
1222             }
1223 
1224             let length := sub(end, ptr)
1225             // Move the pointer 32 bytes leftwards to make room for the length.
1226             ptr := sub(ptr, 32)
1227             // Store the length.
1228             mstore(ptr, length)
1229         }
1230     }
1231 }
1232 
1233 
1234 // File erc721a/contracts/extensions/IERC721AQueryable.sol@v4.1.0
1235 
1236 // ERC721A Contracts v4.1.0
1237 // Creator: Chiru Labs
1238 
1239 pragma solidity ^0.8.4;
1240 
1241 /**
1242  * @dev Interface of an ERC721AQueryable compliant contract.
1243  */
1244 interface IERC721AQueryable is IERC721A {
1245     /**
1246      * Invalid query range (`start` >= `stop`).
1247      */
1248     error InvalidQueryRange();
1249 
1250     /**
1251      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1252      *
1253      * If the `tokenId` is out of bounds:
1254      *   - `addr` = `address(0)`
1255      *   - `startTimestamp` = `0`
1256      *   - `burned` = `false`
1257      *
1258      * If the `tokenId` is burned:
1259      *   - `addr` = `<Address of owner before token was burned>`
1260      *   - `startTimestamp` = `<Timestamp when token was burned>`
1261      *   - `burned = `true`
1262      *
1263      * Otherwise:
1264      *   - `addr` = `<Address of owner>`
1265      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1266      *   - `burned = `false`
1267      */
1268     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1269 
1270     /**
1271      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1272      * See {ERC721AQueryable-explicitOwnershipOf}
1273      */
1274     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1275 
1276     /**
1277      * @dev Returns an array of token IDs owned by `owner`,
1278      * in the range [`start`, `stop`)
1279      * (i.e. `start <= tokenId < stop`).
1280      *
1281      * This function allows for tokens to be queried if the collection
1282      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1283      *
1284      * Requirements:
1285      *
1286      * - `start` < `stop`
1287      */
1288     function tokensOfOwnerIn(
1289         address owner,
1290         uint256 start,
1291         uint256 stop
1292     ) external view returns (uint256[] memory);
1293 
1294     /**
1295      * @dev Returns an array of token IDs owned by `owner`.
1296      *
1297      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1298      * It is meant to be called off-chain.
1299      *
1300      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1301      * multiple smaller scans if the collection is large enough to cause
1302      * an out-of-gas error (10K pfp collections should be fine).
1303      */
1304     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1305 }
1306 
1307 
1308 // File erc721a/contracts/extensions/ERC721AQueryable.sol@v4.1.0
1309 
1310 // ERC721A Contracts v4.1.0
1311 // Creator: Chiru Labs
1312 
1313 pragma solidity ^0.8.4;
1314 
1315 
1316 /**
1317  * @title ERC721A Queryable
1318  * @dev ERC721A subclass with convenience query functions.
1319  */
1320 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1321     /**
1322      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1323      *
1324      * If the `tokenId` is out of bounds:
1325      *   - `addr` = `address(0)`
1326      *   - `startTimestamp` = `0`
1327      *   - `burned` = `false`
1328      *   - `extraData` = `0`
1329      *
1330      * If the `tokenId` is burned:
1331      *   - `addr` = `<Address of owner before token was burned>`
1332      *   - `startTimestamp` = `<Timestamp when token was burned>`
1333      *   - `burned = `true`
1334      *   - `extraData` = `<Extra data when token was burned>`
1335      *
1336      * Otherwise:
1337      *   - `addr` = `<Address of owner>`
1338      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1339      *   - `burned = `false`
1340      *   - `extraData` = `<Extra data at start of ownership>`
1341      */
1342     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1343         TokenOwnership memory ownership;
1344         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1345             return ownership;
1346         }
1347         ownership = _ownershipAt(tokenId);
1348         if (ownership.burned) {
1349             return ownership;
1350         }
1351         return _ownershipOf(tokenId);
1352     }
1353 
1354     /**
1355      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1356      * See {ERC721AQueryable-explicitOwnershipOf}
1357      */
1358     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1359         unchecked {
1360             uint256 tokenIdsLength = tokenIds.length;
1361             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1362             for (uint256 i; i != tokenIdsLength; ++i) {
1363                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1364             }
1365             return ownerships;
1366         }
1367     }
1368 
1369     /**
1370      * @dev Returns an array of token IDs owned by `owner`,
1371      * in the range [`start`, `stop`)
1372      * (i.e. `start <= tokenId < stop`).
1373      *
1374      * This function allows for tokens to be queried if the collection
1375      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1376      *
1377      * Requirements:
1378      *
1379      * - `start` < `stop`
1380      */
1381     function tokensOfOwnerIn(
1382         address owner,
1383         uint256 start,
1384         uint256 stop
1385     ) external view override returns (uint256[] memory) {
1386         unchecked {
1387             if (start >= stop) revert InvalidQueryRange();
1388             uint256 tokenIdsIdx;
1389             uint256 stopLimit = _nextTokenId();
1390             // Set `start = max(start, _startTokenId())`.
1391             if (start < _startTokenId()) {
1392                 start = _startTokenId();
1393             }
1394             // Set `stop = min(stop, stopLimit)`.
1395             if (stop > stopLimit) {
1396                 stop = stopLimit;
1397             }
1398             uint256 tokenIdsMaxLength = balanceOf(owner);
1399             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1400             // to cater for cases where `balanceOf(owner)` is too big.
1401             if (start < stop) {
1402                 uint256 rangeLength = stop - start;
1403                 if (rangeLength < tokenIdsMaxLength) {
1404                     tokenIdsMaxLength = rangeLength;
1405                 }
1406             } else {
1407                 tokenIdsMaxLength = 0;
1408             }
1409             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1410             if (tokenIdsMaxLength == 0) {
1411                 return tokenIds;
1412             }
1413             // We need to call `explicitOwnershipOf(start)`,
1414             // because the slot at `start` may not be initialized.
1415             TokenOwnership memory ownership = explicitOwnershipOf(start);
1416             address currOwnershipAddr;
1417             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1418             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1419             if (!ownership.burned) {
1420                 currOwnershipAddr = ownership.addr;
1421             }
1422             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1423                 ownership = _ownershipAt(i);
1424                 if (ownership.burned) {
1425                     continue;
1426                 }
1427                 if (ownership.addr != address(0)) {
1428                     currOwnershipAddr = ownership.addr;
1429                 }
1430                 if (currOwnershipAddr == owner) {
1431                     tokenIds[tokenIdsIdx++] = i;
1432                 }
1433             }
1434             // Downsize the array to fit.
1435             assembly {
1436                 mstore(tokenIds, tokenIdsIdx)
1437             }
1438             return tokenIds;
1439         }
1440     }
1441 
1442     /**
1443      * @dev Returns an array of token IDs owned by `owner`.
1444      *
1445      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1446      * It is meant to be called off-chain.
1447      *
1448      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1449      * multiple smaller scans if the collection is large enough to cause
1450      * an out-of-gas error (10K pfp collections should be fine).
1451      */
1452     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1453         unchecked {
1454             uint256 tokenIdsIdx;
1455             address currOwnershipAddr;
1456             uint256 tokenIdsLength = balanceOf(owner);
1457             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1458             TokenOwnership memory ownership;
1459             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1460                 ownership = _ownershipAt(i);
1461                 if (ownership.burned) {
1462                     continue;
1463                 }
1464                 if (ownership.addr != address(0)) {
1465                     currOwnershipAddr = ownership.addr;
1466                 }
1467                 if (currOwnershipAddr == owner) {
1468                     tokenIds[tokenIdsIdx++] = i;
1469                 }
1470             }
1471             return tokenIds;
1472         }
1473     }
1474 }
1475 
1476 
1477 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.7.3
1478 
1479 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1480 
1481 pragma solidity ^0.8.0;
1482 
1483 /**
1484  * @dev These functions deal with verification of Merkle Tree proofs.
1485  *
1486  * The proofs can be generated using the JavaScript library
1487  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1488  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1489  *
1490  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1491  *
1492  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1493  * hashing, or use a hash function other than keccak256 for hashing leaves.
1494  * This is because the concatenation of a sorted pair of internal nodes in
1495  * the merkle tree could be reinterpreted as a leaf value.
1496  */
1497 library MerkleProof {
1498     /**
1499      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1500      * defined by `root`. For this, a `proof` must be provided, containing
1501      * sibling hashes on the branch from the leaf to the root of the tree. Each
1502      * pair of leaves and each pair of pre-images are assumed to be sorted.
1503      */
1504     function verify(
1505         bytes32[] memory proof,
1506         bytes32 root,
1507         bytes32 leaf
1508     ) internal pure returns (bool) {
1509         return processProof(proof, leaf) == root;
1510     }
1511 
1512     /**
1513      * @dev Calldata version of {verify}
1514      *
1515      * _Available since v4.7._
1516      */
1517     function verifyCalldata(
1518         bytes32[] calldata proof,
1519         bytes32 root,
1520         bytes32 leaf
1521     ) internal pure returns (bool) {
1522         return processProofCalldata(proof, leaf) == root;
1523     }
1524 
1525     /**
1526      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1527      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1528      * hash matches the root of the tree. When processing the proof, the pairs
1529      * of leafs & pre-images are assumed to be sorted.
1530      *
1531      * _Available since v4.4._
1532      */
1533     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1534         bytes32 computedHash = leaf;
1535         for (uint256 i = 0; i < proof.length; i++) {
1536             computedHash = _hashPair(computedHash, proof[i]);
1537         }
1538         return computedHash;
1539     }
1540 
1541     /**
1542      * @dev Calldata version of {processProof}
1543      *
1544      * _Available since v4.7._
1545      */
1546     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1547         bytes32 computedHash = leaf;
1548         for (uint256 i = 0; i < proof.length; i++) {
1549             computedHash = _hashPair(computedHash, proof[i]);
1550         }
1551         return computedHash;
1552     }
1553 
1554     /**
1555      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1556      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1557      *
1558      * _Available since v4.7._
1559      */
1560     function multiProofVerify(
1561         bytes32[] memory proof,
1562         bool[] memory proofFlags,
1563         bytes32 root,
1564         bytes32[] memory leaves
1565     ) internal pure returns (bool) {
1566         return processMultiProof(proof, proofFlags, leaves) == root;
1567     }
1568 
1569     /**
1570      * @dev Calldata version of {multiProofVerify}
1571      *
1572      * _Available since v4.7._
1573      */
1574     function multiProofVerifyCalldata(
1575         bytes32[] calldata proof,
1576         bool[] calldata proofFlags,
1577         bytes32 root,
1578         bytes32[] memory leaves
1579     ) internal pure returns (bool) {
1580         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1581     }
1582 
1583     /**
1584      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1585      * consuming from one or the other at each step according to the instructions given by
1586      * `proofFlags`.
1587      *
1588      * _Available since v4.7._
1589      */
1590     function processMultiProof(
1591         bytes32[] memory proof,
1592         bool[] memory proofFlags,
1593         bytes32[] memory leaves
1594     ) internal pure returns (bytes32 merkleRoot) {
1595         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1596         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1597         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1598         // the merkle tree.
1599         uint256 leavesLen = leaves.length;
1600         uint256 totalHashes = proofFlags.length;
1601 
1602         // Check proof validity.
1603         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1604 
1605         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1606         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1607         bytes32[] memory hashes = new bytes32[](totalHashes);
1608         uint256 leafPos = 0;
1609         uint256 hashPos = 0;
1610         uint256 proofPos = 0;
1611         // At each step, we compute the next hash using two values:
1612         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1613         //   get the next hash.
1614         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1615         //   `proof` array.
1616         for (uint256 i = 0; i < totalHashes; i++) {
1617             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1618             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1619             hashes[i] = _hashPair(a, b);
1620         }
1621 
1622         if (totalHashes > 0) {
1623             return hashes[totalHashes - 1];
1624         } else if (leavesLen > 0) {
1625             return leaves[0];
1626         } else {
1627             return proof[0];
1628         }
1629     }
1630 
1631     /**
1632      * @dev Calldata version of {processMultiProof}
1633      *
1634      * _Available since v4.7._
1635      */
1636     function processMultiProofCalldata(
1637         bytes32[] calldata proof,
1638         bool[] calldata proofFlags,
1639         bytes32[] memory leaves
1640     ) internal pure returns (bytes32 merkleRoot) {
1641         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1642         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1643         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1644         // the merkle tree.
1645         uint256 leavesLen = leaves.length;
1646         uint256 totalHashes = proofFlags.length;
1647 
1648         // Check proof validity.
1649         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1650 
1651         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1652         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1653         bytes32[] memory hashes = new bytes32[](totalHashes);
1654         uint256 leafPos = 0;
1655         uint256 hashPos = 0;
1656         uint256 proofPos = 0;
1657         // At each step, we compute the next hash using two values:
1658         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1659         //   get the next hash.
1660         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1661         //   `proof` array.
1662         for (uint256 i = 0; i < totalHashes; i++) {
1663             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1664             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1665             hashes[i] = _hashPair(a, b);
1666         }
1667 
1668         if (totalHashes > 0) {
1669             return hashes[totalHashes - 1];
1670         } else if (leavesLen > 0) {
1671             return leaves[0];
1672         } else {
1673             return proof[0];
1674         }
1675     }
1676 
1677     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1678         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1679     }
1680 
1681     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1682         /// @solidity memory-safe-assembly
1683         assembly {
1684             mstore(0x00, a)
1685             mstore(0x20, b)
1686             value := keccak256(0x00, 0x40)
1687         }
1688     }
1689 }
1690 
1691 
1692 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.7.3
1693 
1694 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1695 
1696 pragma solidity ^0.8.0;
1697 
1698 /**
1699  * @dev External interface of AccessControl declared to support ERC165 detection.
1700  */
1701 interface IAccessControl {
1702     /**
1703      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1704      *
1705      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1706      * {RoleAdminChanged} not being emitted signaling this.
1707      *
1708      * _Available since v3.1._
1709      */
1710     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1711 
1712     /**
1713      * @dev Emitted when `account` is granted `role`.
1714      *
1715      * `sender` is the account that originated the contract call, an admin role
1716      * bearer except when using {AccessControl-_setupRole}.
1717      */
1718     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1719 
1720     /**
1721      * @dev Emitted when `account` is revoked `role`.
1722      *
1723      * `sender` is the account that originated the contract call:
1724      *   - if using `revokeRole`, it is the admin role bearer
1725      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1726      */
1727     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1728 
1729     /**
1730      * @dev Returns `true` if `account` has been granted `role`.
1731      */
1732     function hasRole(bytes32 role, address account) external view returns (bool);
1733 
1734     /**
1735      * @dev Returns the admin role that controls `role`. See {grantRole} and
1736      * {revokeRole}.
1737      *
1738      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1739      */
1740     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1741 
1742     /**
1743      * @dev Grants `role` to `account`.
1744      *
1745      * If `account` had not been already granted `role`, emits a {RoleGranted}
1746      * event.
1747      *
1748      * Requirements:
1749      *
1750      * - the caller must have ``role``'s admin role.
1751      */
1752     function grantRole(bytes32 role, address account) external;
1753 
1754     /**
1755      * @dev Revokes `role` from `account`.
1756      *
1757      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1758      *
1759      * Requirements:
1760      *
1761      * - the caller must have ``role``'s admin role.
1762      */
1763     function revokeRole(bytes32 role, address account) external;
1764 
1765     /**
1766      * @dev Revokes `role` from the calling account.
1767      *
1768      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1769      * purpose is to provide a mechanism for accounts to lose their privileges
1770      * if they are compromised (such as when a trusted device is misplaced).
1771      *
1772      * If the calling account had been granted `role`, emits a {RoleRevoked}
1773      * event.
1774      *
1775      * Requirements:
1776      *
1777      * - the caller must be `account`.
1778      */
1779     function renounceRole(bytes32 role, address account) external;
1780 }
1781 
1782 
1783 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
1784 
1785 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1786 
1787 pragma solidity ^0.8.0;
1788 
1789 /**
1790  * @dev Provides information about the current execution context, including the
1791  * sender of the transaction and its data. While these are generally available
1792  * via msg.sender and msg.data, they should not be accessed in such a direct
1793  * manner, since when dealing with meta-transactions the account sending and
1794  * paying for execution may not be the actual sender (as far as an application
1795  * is concerned).
1796  *
1797  * This contract is only required for intermediate, library-like contracts.
1798  */
1799 abstract contract Context {
1800     function _msgSender() internal view virtual returns (address) {
1801         return msg.sender;
1802     }
1803 
1804     function _msgData() internal view virtual returns (bytes calldata) {
1805         return msg.data;
1806     }
1807 }
1808 
1809 
1810 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.3
1811 
1812 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1813 
1814 pragma solidity ^0.8.0;
1815 
1816 /**
1817  * @dev String operations.
1818  */
1819 library Strings {
1820     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1821     uint8 private constant _ADDRESS_LENGTH = 20;
1822 
1823     /**
1824      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1825      */
1826     function toString(uint256 value) internal pure returns (string memory) {
1827         // Inspired by OraclizeAPI's implementation - MIT licence
1828         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1829 
1830         if (value == 0) {
1831             return "0";
1832         }
1833         uint256 temp = value;
1834         uint256 digits;
1835         while (temp != 0) {
1836             digits++;
1837             temp /= 10;
1838         }
1839         bytes memory buffer = new bytes(digits);
1840         while (value != 0) {
1841             digits -= 1;
1842             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1843             value /= 10;
1844         }
1845         return string(buffer);
1846     }
1847 
1848     /**
1849      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1850      */
1851     function toHexString(uint256 value) internal pure returns (string memory) {
1852         if (value == 0) {
1853             return "0x00";
1854         }
1855         uint256 temp = value;
1856         uint256 length = 0;
1857         while (temp != 0) {
1858             length++;
1859             temp >>= 8;
1860         }
1861         return toHexString(value, length);
1862     }
1863 
1864     /**
1865      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1866      */
1867     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1868         bytes memory buffer = new bytes(2 * length + 2);
1869         buffer[0] = "0";
1870         buffer[1] = "x";
1871         for (uint256 i = 2 * length + 1; i > 1; --i) {
1872             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1873             value >>= 4;
1874         }
1875         require(value == 0, "Strings: hex length insufficient");
1876         return string(buffer);
1877     }
1878 
1879     /**
1880      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1881      */
1882     function toHexString(address addr) internal pure returns (string memory) {
1883         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1884     }
1885 }
1886 
1887 
1888 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.3
1889 
1890 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1891 
1892 pragma solidity ^0.8.0;
1893 
1894 /**
1895  * @dev Interface of the ERC165 standard, as defined in the
1896  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1897  *
1898  * Implementers can declare support of contract interfaces, which can then be
1899  * queried by others ({ERC165Checker}).
1900  *
1901  * For an implementation, see {ERC165}.
1902  */
1903 interface IERC165 {
1904     /**
1905      * @dev Returns true if this contract implements the interface defined by
1906      * `interfaceId`. See the corresponding
1907      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1908      * to learn more about how these ids are created.
1909      *
1910      * This function call must use less than 30 000 gas.
1911      */
1912     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1913 }
1914 
1915 
1916 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.3
1917 
1918 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1919 
1920 pragma solidity ^0.8.0;
1921 
1922 /**
1923  * @dev Implementation of the {IERC165} interface.
1924  *
1925  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1926  * for the additional interface id that will be supported. For example:
1927  *
1928  * ```solidity
1929  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1930  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1931  * }
1932  * ```
1933  *
1934  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1935  */
1936 abstract contract ERC165 is IERC165 {
1937     /**
1938      * @dev See {IERC165-supportsInterface}.
1939      */
1940     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1941         return interfaceId == type(IERC165).interfaceId;
1942     }
1943 }
1944 
1945 
1946 // File @openzeppelin/contracts/access/AccessControl.sol@v4.7.3
1947 
1948 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1949 
1950 pragma solidity ^0.8.0;
1951 
1952 
1953 
1954 
1955 /**
1956  * @dev Contract module that allows children to implement role-based access
1957  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1958  * members except through off-chain means by accessing the contract event logs. Some
1959  * applications may benefit from on-chain enumerability, for those cases see
1960  * {AccessControlEnumerable}.
1961  *
1962  * Roles are referred to by their `bytes32` identifier. These should be exposed
1963  * in the external API and be unique. The best way to achieve this is by
1964  * using `public constant` hash digests:
1965  *
1966  * ```
1967  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1968  * ```
1969  *
1970  * Roles can be used to represent a set of permissions. To restrict access to a
1971  * function call, use {hasRole}:
1972  *
1973  * ```
1974  * function foo() public {
1975  *     require(hasRole(MY_ROLE, msg.sender));
1976  *     ...
1977  * }
1978  * ```
1979  *
1980  * Roles can be granted and revoked dynamically via the {grantRole} and
1981  * {revokeRole} functions. Each role has an associated admin role, and only
1982  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1983  *
1984  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1985  * that only accounts with this role will be able to grant or revoke other
1986  * roles. More complex role relationships can be created by using
1987  * {_setRoleAdmin}.
1988  *
1989  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1990  * grant and revoke this role. Extra precautions should be taken to secure
1991  * accounts that have been granted it.
1992  */
1993 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1994     struct RoleData {
1995         mapping(address => bool) members;
1996         bytes32 adminRole;
1997     }
1998 
1999     mapping(bytes32 => RoleData) private _roles;
2000 
2001     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
2002 
2003     /**
2004      * @dev Modifier that checks that an account has a specific role. Reverts
2005      * with a standardized message including the required role.
2006      *
2007      * The format of the revert reason is given by the following regular expression:
2008      *
2009      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2010      *
2011      * _Available since v4.1._
2012      */
2013     modifier onlyRole(bytes32 role) {
2014         _checkRole(role);
2015         _;
2016     }
2017 
2018     /**
2019      * @dev See {IERC165-supportsInterface}.
2020      */
2021     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2022         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
2023     }
2024 
2025     /**
2026      * @dev Returns `true` if `account` has been granted `role`.
2027      */
2028     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
2029         return _roles[role].members[account];
2030     }
2031 
2032     /**
2033      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
2034      * Overriding this function changes the behavior of the {onlyRole} modifier.
2035      *
2036      * Format of the revert message is described in {_checkRole}.
2037      *
2038      * _Available since v4.6._
2039      */
2040     function _checkRole(bytes32 role) internal view virtual {
2041         _checkRole(role, _msgSender());
2042     }
2043 
2044     /**
2045      * @dev Revert with a standard message if `account` is missing `role`.
2046      *
2047      * The format of the revert reason is given by the following regular expression:
2048      *
2049      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
2050      */
2051     function _checkRole(bytes32 role, address account) internal view virtual {
2052         if (!hasRole(role, account)) {
2053             revert(
2054                 string(
2055                     abi.encodePacked(
2056                         "AccessControl: account ",
2057                         Strings.toHexString(uint160(account), 20),
2058                         " is missing role ",
2059                         Strings.toHexString(uint256(role), 32)
2060                     )
2061                 )
2062             );
2063         }
2064     }
2065 
2066     /**
2067      * @dev Returns the admin role that controls `role`. See {grantRole} and
2068      * {revokeRole}.
2069      *
2070      * To change a role's admin, use {_setRoleAdmin}.
2071      */
2072     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
2073         return _roles[role].adminRole;
2074     }
2075 
2076     /**
2077      * @dev Grants `role` to `account`.
2078      *
2079      * If `account` had not been already granted `role`, emits a {RoleGranted}
2080      * event.
2081      *
2082      * Requirements:
2083      *
2084      * - the caller must have ``role``'s admin role.
2085      *
2086      * May emit a {RoleGranted} event.
2087      */
2088     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2089         _grantRole(role, account);
2090     }
2091 
2092     /**
2093      * @dev Revokes `role` from `account`.
2094      *
2095      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2096      *
2097      * Requirements:
2098      *
2099      * - the caller must have ``role``'s admin role.
2100      *
2101      * May emit a {RoleRevoked} event.
2102      */
2103     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
2104         _revokeRole(role, account);
2105     }
2106 
2107     /**
2108      * @dev Revokes `role` from the calling account.
2109      *
2110      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2111      * purpose is to provide a mechanism for accounts to lose their privileges
2112      * if they are compromised (such as when a trusted device is misplaced).
2113      *
2114      * If the calling account had been revoked `role`, emits a {RoleRevoked}
2115      * event.
2116      *
2117      * Requirements:
2118      *
2119      * - the caller must be `account`.
2120      *
2121      * May emit a {RoleRevoked} event.
2122      */
2123     function renounceRole(bytes32 role, address account) public virtual override {
2124         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2125 
2126         _revokeRole(role, account);
2127     }
2128 
2129     /**
2130      * @dev Grants `role` to `account`.
2131      *
2132      * If `account` had not been already granted `role`, emits a {RoleGranted}
2133      * event. Note that unlike {grantRole}, this function doesn't perform any
2134      * checks on the calling account.
2135      *
2136      * May emit a {RoleGranted} event.
2137      *
2138      * [WARNING]
2139      * ====
2140      * This function should only be called from the constructor when setting
2141      * up the initial roles for the system.
2142      *
2143      * Using this function in any other way is effectively circumventing the admin
2144      * system imposed by {AccessControl}.
2145      * ====
2146      *
2147      * NOTE: This function is deprecated in favor of {_grantRole}.
2148      */
2149     function _setupRole(bytes32 role, address account) internal virtual {
2150         _grantRole(role, account);
2151     }
2152 
2153     /**
2154      * @dev Sets `adminRole` as ``role``'s admin role.
2155      *
2156      * Emits a {RoleAdminChanged} event.
2157      */
2158     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2159         bytes32 previousAdminRole = getRoleAdmin(role);
2160         _roles[role].adminRole = adminRole;
2161         emit RoleAdminChanged(role, previousAdminRole, adminRole);
2162     }
2163 
2164     /**
2165      * @dev Grants `role` to `account`.
2166      *
2167      * Internal function without access restriction.
2168      *
2169      * May emit a {RoleGranted} event.
2170      */
2171     function _grantRole(bytes32 role, address account) internal virtual {
2172         if (!hasRole(role, account)) {
2173             _roles[role].members[account] = true;
2174             emit RoleGranted(role, account, _msgSender());
2175         }
2176     }
2177 
2178     /**
2179      * @dev Revokes `role` from `account`.
2180      *
2181      * Internal function without access restriction.
2182      *
2183      * May emit a {RoleRevoked} event.
2184      */
2185     function _revokeRole(bytes32 role, address account) internal virtual {
2186         if (hasRole(role, account)) {
2187             _roles[role].members[account] = false;
2188             emit RoleRevoked(role, account, _msgSender());
2189         }
2190     }
2191 }
2192 
2193 
2194 // File contracts/IERC173.sol
2195 
2196 pragma solidity ^0.8.0;
2197 
2198 /// @title ERC-173 Contract Ownership Standard
2199 ///  Note: the ERC-165 identifier for this interface is 0x7f5828d0
2200 interface IERC173 is IERC165 {
2201     /// @dev This emits when ownership of a contract changes.    
2202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2203 
2204     /// @notice Get the address of the owner    
2205     /// @return The address of the owner.
2206     function owner() view external returns(address);
2207 	
2208     /// @notice Set the address of the new owner of the contract
2209     /// @dev Set _newOwner to address(0) to renounce any ownership.
2210     /// @param _newOwner The address of the new owner of the contract    
2211     function transferOwnership(address _newOwner) external;	
2212 }
2213 
2214 
2215 // File @chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol@v0.4.1
2216 
2217 pragma solidity ^0.8.0;
2218 
2219 interface LinkTokenInterface {
2220   function allowance(address owner, address spender) external view returns (uint256 remaining);
2221 
2222   function approve(address spender, uint256 value) external returns (bool success);
2223 
2224   function balanceOf(address owner) external view returns (uint256 balance);
2225 
2226   function decimals() external view returns (uint8 decimalPlaces);
2227 
2228   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
2229 
2230   function increaseApproval(address spender, uint256 subtractedValue) external;
2231 
2232   function name() external view returns (string memory tokenName);
2233 
2234   function symbol() external view returns (string memory tokenSymbol);
2235 
2236   function totalSupply() external view returns (uint256 totalTokensIssued);
2237 
2238   function transfer(address to, uint256 value) external returns (bool success);
2239 
2240   function transferAndCall(
2241     address to,
2242     uint256 value,
2243     bytes calldata data
2244   ) external returns (bool success);
2245 
2246   function transferFrom(
2247     address from,
2248     address to,
2249     uint256 value
2250   ) external returns (bool success);
2251 }
2252 
2253 
2254 // File @chainlink/contracts/src/v0.8/VRFRequestIDBase.sol@v0.4.1
2255 
2256 pragma solidity ^0.8.0;
2257 
2258 contract VRFRequestIDBase {
2259   /**
2260    * @notice returns the seed which is actually input to the VRF coordinator
2261    *
2262    * @dev To prevent repetition of VRF output due to repetition of the
2263    * @dev user-supplied seed, that seed is combined in a hash with the
2264    * @dev user-specific nonce, and the address of the consuming contract. The
2265    * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
2266    * @dev the final seed, but the nonce does protect against repetition in
2267    * @dev requests which are included in a single block.
2268    *
2269    * @param _userSeed VRF seed input provided by user
2270    * @param _requester Address of the requesting contract
2271    * @param _nonce User-specific nonce at the time of the request
2272    */
2273   function makeVRFInputSeed(
2274     bytes32 _keyHash,
2275     uint256 _userSeed,
2276     address _requester,
2277     uint256 _nonce
2278   ) internal pure returns (uint256) {
2279     return uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
2280   }
2281 
2282   /**
2283    * @notice Returns the id for this request
2284    * @param _keyHash The serviceAgreement ID to be used for this request
2285    * @param _vRFInputSeed The seed to be passed directly to the VRF
2286    * @return The id for this request
2287    *
2288    * @dev Note that _vRFInputSeed is not the seed passed by the consuming
2289    * @dev contract, but the one generated by makeVRFInputSeed
2290    */
2291   function makeRequestId(bytes32 _keyHash, uint256 _vRFInputSeed) internal pure returns (bytes32) {
2292     return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
2293   }
2294 }
2295 
2296 
2297 // File @chainlink/contracts/src/v0.8/VRFConsumerBase.sol@v0.4.1
2298 
2299 pragma solidity ^0.8.0;
2300 
2301 /** ****************************************************************************
2302  * @notice Interface for contracts using VRF randomness
2303  * *****************************************************************************
2304  * @dev PURPOSE
2305  *
2306  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
2307  * @dev to Vera the verifier in such a way that Vera can be sure he's not
2308  * @dev making his output up to suit himself. Reggie provides Vera a public key
2309  * @dev to which he knows the secret key. Each time Vera provides a seed to
2310  * @dev Reggie, he gives back a value which is computed completely
2311  * @dev deterministically from the seed and the secret key.
2312  *
2313  * @dev Reggie provides a proof by which Vera can verify that the output was
2314  * @dev correctly computed once Reggie tells it to her, but without that proof,
2315  * @dev the output is indistinguishable to her from a uniform random sample
2316  * @dev from the output space.
2317  *
2318  * @dev The purpose of this contract is to make it easy for unrelated contracts
2319  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
2320  * @dev simple access to a verifiable source of randomness.
2321  * *****************************************************************************
2322  * @dev USAGE
2323  *
2324  * @dev Calling contracts must inherit from VRFConsumerBase, and can
2325  * @dev initialize VRFConsumerBase's attributes in their constructor as
2326  * @dev shown:
2327  *
2328  * @dev   contract VRFConsumer {
2329  * @dev     constructor(<other arguments>, address _vrfCoordinator, address _link)
2330  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
2331  * @dev         <initialization with other arguments goes here>
2332  * @dev       }
2333  * @dev   }
2334  *
2335  * @dev The oracle will have given you an ID for the VRF keypair they have
2336  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
2337  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
2338  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
2339  * @dev want to generate randomness from.
2340  *
2341  * @dev Once the VRFCoordinator has received and validated the oracle's response
2342  * @dev to your request, it will call your contract's fulfillRandomness method.
2343  *
2344  * @dev The randomness argument to fulfillRandomness is the actual random value
2345  * @dev generated from your seed.
2346  *
2347  * @dev The requestId argument is generated from the keyHash and the seed by
2348  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
2349  * @dev requests open, you can use the requestId to track which seed is
2350  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
2351  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
2352  * @dev if your contract could have multiple requests in flight simultaneously.)
2353  *
2354  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
2355  * @dev differ. (Which is critical to making unpredictable randomness! See the
2356  * @dev next section.)
2357  *
2358  * *****************************************************************************
2359  * @dev SECURITY CONSIDERATIONS
2360  *
2361  * @dev A method with the ability to call your fulfillRandomness method directly
2362  * @dev could spoof a VRF response with any random value, so it's critical that
2363  * @dev it cannot be directly called by anything other than this base contract
2364  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
2365  *
2366  * @dev For your users to trust that your contract's random behavior is free
2367  * @dev from malicious interference, it's best if you can write it so that all
2368  * @dev behaviors implied by a VRF response are executed *during* your
2369  * @dev fulfillRandomness method. If your contract must store the response (or
2370  * @dev anything derived from it) and use it later, you must ensure that any
2371  * @dev user-significant behavior which depends on that stored value cannot be
2372  * @dev manipulated by a subsequent VRF request.
2373  *
2374  * @dev Similarly, both miners and the VRF oracle itself have some influence
2375  * @dev over the order in which VRF responses appear on the blockchain, so if
2376  * @dev your contract could have multiple VRF requests in flight simultaneously,
2377  * @dev you must ensure that the order in which the VRF responses arrive cannot
2378  * @dev be used to manipulate your contract's user-significant behavior.
2379  *
2380  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
2381  * @dev block in which the request is made, user-provided seeds have no impact
2382  * @dev on its economic security properties. They are only included for API
2383  * @dev compatability with previous versions of this contract.
2384  *
2385  * @dev Since the block hash of the block which contains the requestRandomness
2386  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
2387  * @dev miner could, in principle, fork the blockchain to evict the block
2388  * @dev containing the request, forcing the request to be included in a
2389  * @dev different block with a different hash, and therefore a different input
2390  * @dev to the VRF. However, such an attack would incur a substantial economic
2391  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
2392  * @dev until it calls responds to a request.
2393  */
2394 abstract contract VRFConsumerBase is VRFRequestIDBase {
2395   /**
2396    * @notice fulfillRandomness handles the VRF response. Your contract must
2397    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
2398    * @notice principles to keep in mind when implementing your fulfillRandomness
2399    * @notice method.
2400    *
2401    * @dev VRFConsumerBase expects its subcontracts to have a method with this
2402    * @dev signature, and will call it once it has verified the proof
2403    * @dev associated with the randomness. (It is triggered via a call to
2404    * @dev rawFulfillRandomness, below.)
2405    *
2406    * @param requestId The Id initially returned by requestRandomness
2407    * @param randomness the VRF output
2408    */
2409   function fulfillRandomness(bytes32 requestId, uint256 randomness) internal virtual;
2410 
2411   /**
2412    * @dev In order to keep backwards compatibility we have kept the user
2413    * seed field around. We remove the use of it because given that the blockhash
2414    * enters later, it overrides whatever randomness the used seed provides.
2415    * Given that it adds no security, and can easily lead to misunderstandings,
2416    * we have removed it from usage and can now provide a simpler API.
2417    */
2418   uint256 private constant USER_SEED_PLACEHOLDER = 0;
2419 
2420   /**
2421    * @notice requestRandomness initiates a request for VRF output given _seed
2422    *
2423    * @dev The fulfillRandomness method receives the output, once it's provided
2424    * @dev by the Oracle, and verified by the vrfCoordinator.
2425    *
2426    * @dev The _keyHash must already be registered with the VRFCoordinator, and
2427    * @dev the _fee must exceed the fee specified during registration of the
2428    * @dev _keyHash.
2429    *
2430    * @dev The _seed parameter is vestigial, and is kept only for API
2431    * @dev compatibility with older versions. It can't *hurt* to mix in some of
2432    * @dev your own randomness, here, but it's not necessary because the VRF
2433    * @dev oracle will mix the hash of the block containing your request into the
2434    * @dev VRF seed it ultimately uses.
2435    *
2436    * @param _keyHash ID of public key against which randomness is generated
2437    * @param _fee The amount of LINK to send with the request
2438    *
2439    * @return requestId unique ID for this request
2440    *
2441    * @dev The returned requestId can be used to distinguish responses to
2442    * @dev concurrent requests. It is passed as the first argument to
2443    * @dev fulfillRandomness.
2444    */
2445   function requestRandomness(bytes32 _keyHash, uint256 _fee) internal returns (bytes32 requestId) {
2446     LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, USER_SEED_PLACEHOLDER));
2447     // This is the seed passed to VRFCoordinator. The oracle will mix this with
2448     // the hash of the block containing this request to obtain the seed/input
2449     // which is finally passed to the VRF cryptographic machinery.
2450     uint256 vRFSeed = makeVRFInputSeed(_keyHash, USER_SEED_PLACEHOLDER, address(this), nonces[_keyHash]);
2451     // nonces[_keyHash] must stay in sync with
2452     // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
2453     // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
2454     // This provides protection against the user repeating their input seed,
2455     // which would result in a predictable/duplicate output, if multiple such
2456     // requests appeared in the same block.
2457     nonces[_keyHash] = nonces[_keyHash] + 1;
2458     return makeRequestId(_keyHash, vRFSeed);
2459   }
2460 
2461   LinkTokenInterface internal immutable LINK;
2462   address private immutable vrfCoordinator;
2463 
2464   // Nonces for each VRF key from which randomness has been requested.
2465   //
2466   // Must stay in sync with VRFCoordinator[_keyHash][this]
2467   mapping(bytes32 => uint256) /* keyHash */ /* nonce */
2468     private nonces;
2469 
2470   /**
2471    * @param _vrfCoordinator address of VRFCoordinator contract
2472    * @param _link address of LINK token contract
2473    *
2474    * @dev https://docs.chain.link/docs/link-token-contracts
2475    */
2476   constructor(address _vrfCoordinator, address _link) {
2477     vrfCoordinator = _vrfCoordinator;
2478     LINK = LinkTokenInterface(_link);
2479   }
2480 
2481   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
2482   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
2483   // the origin of the call
2484   function rawFulfillRandomness(bytes32 requestId, uint256 randomness) external {
2485     require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
2486     fulfillRandomness(requestId, randomness);
2487   }
2488 }
2489 
2490 
2491 // File contracts/NFT.sol
2492 
2493 pragma solidity ^0.8.0;
2494 
2495 // import { console } from "hardhat/console.sol";
2496 
2497 
2498 
2499 
2500 
2501 
2502 
2503 contract WeAbove is ERC721A, ERC721AQueryable, AccessControl, IERC173, VRFConsumerBase {
2504   enum PremintType { WHITELIST, RAFFLE }
2505 
2506   address private _manager;
2507 
2508   uint256 public constant hash = 0xf2960a5d44695dd345242ca8547fbc8c574915416be9578959ee384fcb38cd6b;
2509   uint256 public constant maxSupply = 8751;
2510   uint256 public constant maxMintPerWhitelistAddress = 3;
2511   uint256 public constant maxMintPerAddress = 2;
2512   uint256 public premintDuration = 3 hours;
2513   uint256 public raffleStart = 1 hours;
2514   uint256 public mintPrice = 0.15 ether;
2515 
2516   uint256 public startTimestamp;
2517   bytes32 public root;
2518   bytes32 public raffleRoot;
2519   mapping(address => uint256) public mintsPerAddress;
2520 
2521   uint256 public seed;
2522   bool public isRevealed;
2523 
2524   event SetBaseURI(string newURI);
2525   event SetStartTimestamp(uint256 ts);
2526   event SetRoot(bytes32 indexed oldRoot, bytes32 indexed newRoot);
2527   event SetRaffleRoot(bytes32 indexed oldRoot, bytes32 indexed newRoot);
2528   event RequestSeed(bytes32 requestId);
2529   event SetSeed(uint256 seed);
2530 
2531   error PriceNotMet();
2532   error MaxSupplyReached();
2533   error MaxMintPerAddressReached();
2534   error InvalidMerkleProof();
2535   error AlreadyUsedProof();
2536   error NotPremintPeriod();
2537   error NotRafflePremintPeriod();
2538   error NotPublicMintPeriod();
2539   error AlreadyRevealed();
2540   error NotEnoughLink();
2541   error InvalidPremintType();
2542 
2543   string private _uri;
2544 
2545   bytes32 public vrfKeyHash;
2546   uint256 public vrfFee;
2547 
2548   constructor(
2549     address admin,
2550     address manager,
2551     string memory uri,
2552     address vrfCoordinator,
2553     address link,
2554     bytes32 keyHash,
2555     uint256 fee
2556   ) ERC721A("WeAbove", "WeAbove") VRFConsumerBase(vrfCoordinator, link) {
2557     _setupRole(DEFAULT_ADMIN_ROLE, admin);
2558     _setManager(manager);
2559     _setURI(uri);
2560 
2561     vrfKeyHash = keyHash;
2562     vrfFee = fee;
2563   }
2564 
2565   function setVRFParameters(bytes32 keyHash, uint256 fee) external onlyRole(DEFAULT_ADMIN_ROLE) {
2566     vrfKeyHash = keyHash;
2567     vrfFee = fee;
2568   }
2569 
2570   function _setManager(address manager) private {
2571     address old = manager;
2572     _manager = manager;
2573     emit OwnershipTransferred(old, manager);
2574   }
2575 
2576   function owner() view override external returns(address) {
2577     return _manager;
2578   }
2579 
2580   function transferOwnership(address newOwner) external override onlyRole(DEFAULT_ADMIN_ROLE) {
2581     _setManager(newOwner);
2582   }
2583 
2584   function setRoot(bytes32 _root) external onlyRole(DEFAULT_ADMIN_ROLE) {
2585     bytes32 old = root;
2586     root = _root;
2587     emit SetRoot(old, _root);
2588   }
2589 
2590   function setRaffleRoot(bytes32 _raffleRoot) external onlyRole(DEFAULT_ADMIN_ROLE) {
2591     bytes32 old = raffleRoot;
2592     raffleRoot = _raffleRoot;
2593     emit SetRaffleRoot(old, _raffleRoot);
2594   }
2595 
2596   function setStartTimestamp(uint256 _startTimestamp) external onlyRole(DEFAULT_ADMIN_ROLE) {
2597     startTimestamp = _startTimestamp;
2598     emit SetStartTimestamp(_startTimestamp);
2599   }
2600 
2601   function _canPremint() view private returns(bool) {
2602     uint256 ts = startTimestamp;
2603     return ts > 0 && block.timestamp >= ts && block.timestamp < ts + premintDuration;
2604   }
2605 
2606   function _canPubliclyMint() view private returns(bool) {
2607     uint256 ts = startTimestamp;
2608     return ts > 0 && block.timestamp >= ts + premintDuration;
2609   }
2610 
2611   function premint(
2612     address to,
2613     uint256 amount,
2614     PremintType premintType,
2615     bytes32[] calldata proof
2616   ) payable external {
2617     if (!_canPremint()) revert NotPremintPeriod();
2618 
2619     bytes32 rootToUse;
2620     uint256 maxQuantity;
2621     if (premintType == PremintType.WHITELIST) {
2622       rootToUse = root;
2623       maxQuantity = maxMintPerWhitelistAddress;
2624     }
2625     else if (premintType == PremintType.RAFFLE) {
2626       // no need to check upper bound because _canPremint() already does it
2627       if (block.timestamp < startTimestamp + raffleStart) revert NotRafflePremintPeriod();
2628 
2629       rootToUse = raffleRoot;
2630       maxQuantity = maxMintPerAddress;
2631     } else revert InvalidPremintType();
2632 
2633     bytes32 leaf = keccak256(abi.encodePacked(to));
2634     if (!MerkleProof.verifyCalldata(proof, rootToUse, leaf)) revert InvalidMerkleProof();
2635 
2636     _tryMint(to, amount, maxQuantity);
2637   }
2638 
2639   function _tryMint(address to, uint256 quantity, uint256 maxQuantity) private {
2640     if (mintsPerAddress[to] + quantity > maxQuantity) revert MaxMintPerAddressReached();
2641     if (totalSupply() + quantity > maxSupply) revert MaxSupplyReached();
2642     if (msg.value != quantity * mintPrice) revert PriceNotMet();
2643 
2644     mintsPerAddress[to] += quantity;
2645 
2646     _mint(to, quantity);
2647   }
2648 
2649   function mint(uint256 quantity) external payable {
2650     if (!_canPubliclyMint()) revert NotPublicMintPeriod();
2651     _tryMint(msg.sender, quantity, maxMintPerAddress);
2652   }
2653 
2654   function _setURI(string memory newURI) private {
2655     _uri = newURI;
2656     emit SetBaseURI(newURI);
2657   }
2658 
2659   function reveal() external onlyRole(DEFAULT_ADMIN_ROLE) returns (bytes32) {
2660     if (isRevealed) revert AlreadyRevealed();
2661     if (LINK.balanceOf(address(this)) < vrfFee) revert NotEnoughLink();
2662     isRevealed = true;
2663     bytes32 requestId = requestRandomness(vrfKeyHash, vrfFee);
2664     emit RequestSeed(requestId);
2665     return requestId;
2666   }
2667 
2668   function fulfillRandomness(bytes32, uint256 randomness) internal override {
2669     seed = randomness;
2670     emit SetSeed(randomness);
2671   }
2672 
2673   function setURI(string memory newURI) external onlyRole(DEFAULT_ADMIN_ROLE) {
2674     _setURI(newURI);
2675   }
2676 
2677   function withdraw(address to) external onlyRole(DEFAULT_ADMIN_ROLE) {
2678     payable(to).transfer(address(this).balance);
2679   }
2680 
2681   function _baseURI() internal view override returns (string memory) {
2682     return _uri;
2683   }
2684 
2685   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, AccessControl, IERC165) returns (bool) {
2686     return super.supportsInterface(interfaceId);
2687   }
2688 }