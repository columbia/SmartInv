1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /*
5     Pepe + Doge + Yacht + Club                                                            
6 */
7 
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
24      * The caller cannot approve to their own address.
25      */
26     error ApproveToCaller();
27 
28     /**
29      * Cannot query the balance for the zero address.
30      */
31     error BalanceQueryForZeroAddress();
32 
33     /**
34      * Cannot mint to the zero address.
35      */
36     error MintToZeroAddress();
37 
38     /**
39      * The quantity of tokens minted must be more than zero.
40      */
41     error MintZeroQuantity();
42 
43     /**
44      * The token does not exist.
45      */
46     error OwnerQueryForNonexistentToken();
47 
48     /**
49      * The caller must own the token or be an approved operator.
50      */
51     error TransferCallerNotOwnerNorApproved();
52 
53     /**
54      * The token must be owned by `from`.
55      */
56     error TransferFromIncorrectOwner();
57 
58     /**
59      * Cannot safely transfer to a contract that does not implement the
60      * ERC721Receiver interface.
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
84     // =============================================================
85     //                            STRUCTS
86     // =============================================================
87 
88     struct TokenOwnership {
89         // The address of the owner.
90         address addr;
91         // Stores the start time of ownership with minimal overhead for tokenomics.
92         uint64 startTimestamp;
93         // Whether the token has been burned.
94         bool burned;
95         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
96         uint24 extraData;
97     }
98 
99     // =============================================================
100     //                         TOKEN COUNTERS
101     // =============================================================
102 
103     /**
104      * @dev Returns the total number of tokens in existence.
105      * Burned tokens will reduce the count.
106      * To get the total number of tokens minted, please see {_totalMinted}.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     // =============================================================
111     //                            IERC165
112     // =============================================================
113 
114     /**
115      * @dev Returns true if this contract implements the interface defined by
116      * `interfaceId`. See the corresponding
117      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
118      * to learn more about how these ids are created.
119      *
120      * This function call must use less than 30000 gas.
121      */
122     function supportsInterface(bytes4 interfaceId) external view returns (bool);
123 
124     // =============================================================
125     //                            IERC721
126     // =============================================================
127 
128     /**
129      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
135      */
136     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables or disables
140      * (`approved`) `operator` to manage all of its assets.
141      */
142     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
143 
144     /**
145      * @dev Returns the number of tokens in `owner`'s account.
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
159      * @dev Safely transfers `tokenId` token from `from` to `to`,
160      * checking first that contract recipients are aware of the ERC721 protocol
161      * to prevent tokens from being forever locked.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be have been allowed to move
169      * this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement
171      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId,
179         bytes calldata data
180     ) external;
181 
182     /**
183      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Transfers `tokenId` from `from` to `to`.
193      *
194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
195      * whenever possible.
196      *
197      * Requirements:
198      *
199      * - `from` cannot be the zero address.
200      * - `to` cannot be the zero address.
201      * - `tokenId` token must be owned by `from`.
202      * - If the caller is not `from`, it must be approved to move this token
203      * by either {approve} or {setApprovalForAll}.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 tokenId
211     ) external;
212 
213     /**
214      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
215      * The approval is cleared when the token is transferred.
216      *
217      * Only a single account can be approved at a time, so approving the
218      * zero address clears previous approvals.
219      *
220      * Requirements:
221      *
222      * - The caller must own the token or be an approved operator.
223      * - `tokenId` must exist.
224      *
225      * Emits an {Approval} event.
226      */
227     function approve(address to, uint256 tokenId) external;
228 
229     /**
230      * @dev Approve or remove `operator` as an operator for the caller.
231      * Operators can call {transferFrom} or {safeTransferFrom}
232      * for any token owned by the caller.
233      *
234      * Requirements:
235      *
236      * - The `operator` cannot be the caller.
237      *
238      * Emits an {ApprovalForAll} event.
239      */
240     function setApprovalForAll(address operator, bool _approved) external;
241 
242     /**
243      * @dev Returns the account approved for `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function getApproved(uint256 tokenId) external view returns (address operator);
250 
251     /**
252      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
253      *
254      * See {setApprovalForAll}.
255      */
256     function isApprovedForAll(address owner, address operator) external view returns (bool);
257 
258     // =============================================================
259     //                        IERC721Metadata
260     // =============================================================
261 
262     /**
263      * @dev Returns the token collection name.
264      */
265     function name() external view returns (string memory);
266 
267     /**
268      * @dev Returns the token collection symbol.
269      */
270     function symbol() external view returns (string memory);
271 
272     /**
273      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
274      */
275     function tokenURI(uint256 tokenId) external view returns (string memory);
276 
277     // =============================================================
278     //                           IERC2309
279     // =============================================================
280 
281     /**
282      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
283      * (inclusive) is transferred from `from` to `to`, as defined in the
284      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
285      *
286      * See {_mintERC2309} for more details.
287      */
288     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
289 }
290 
291 
292 contract PDYC is IERC721A { 
293     address private immutable _owner;
294     modifier onlyOwner() { 
295         require(_owner==msg.sender);
296         _; 
297     }
298 
299     uint256 public constant MAX_SUPPLY = 10000;
300     uint256 public MAX_PER_WALLET = 10;
301     uint256 public MAX_PER_TX = 5;
302     uint256 public COST = 0.001 ether;
303 
304     string private constant _name = "Pepe Doge Yacht Club";
305     string private constant _symbol = "PDYC";
306     string private _contractURI = "";
307     string private _baseURI = "";
308 
309 
310     constructor() {
311         _owner = msg.sender;
312     }
313 
314     function mint(uint256 amount) external payable{
315         address _caller = _msgSenderERC721A();
316 
317         require(totalSupply() + amount <= MAX_SUPPLY, "Sold Out");
318         require(amount*COST <= msg.value, "More Cash needed");
319         require(amount <= MAX_PER_TX, "TX Limit");
320         require(amount + _numberMinted(_caller) <= MAX_PER_WALLET, "Wallet Limit");
321 
322         _mint(_caller, amount);
323     }
324 
325     // Mask of an entry in packed address data.
326     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
327 
328     // The bit position of `numberMinted` in packed address data.
329     uint256 private constant BITPOS_NUMBER_MINTED = 64;
330 
331     // The bit position of `numberBurned` in packed address data.
332     uint256 private constant BITPOS_NUMBER_BURNED = 128;
333 
334     // The bit position of `aux` in packed address data.
335     uint256 private constant BITPOS_AUX = 192;
336 
337     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
338     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
339 
340     // The bit position of `startTimestamp` in packed ownership.
341     uint256 private constant BITPOS_START_TIMESTAMP = 160;
342 
343     // The bit mask of the `burned` bit in packed ownership.
344     uint256 private constant BITMASK_BURNED = 1 << 224;
345 
346     // The bit position of the `nextInitialized` bit in packed ownership.
347     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
348 
349     // The bit mask of the `nextInitialized` bit in packed ownership.
350     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
351 
352     // The tokenId of the next token to be minted.
353     uint256 private _currentIndex = 0;
354 
355     // The number of tokens burned.
356     // uint256 private _burnCounter;
357 
358 
359     // Mapping from token ID to ownership details
360     // An empty struct value does not necessarily mean the token is unowned.
361     // See `_packedOwnershipOf` implementation for details.
362     //
363     // Bits Layout:
364     // - [0..159] `addr`
365     // - [160..223] `startTimestamp`
366     // - [224] `burned`
367     // - [225] `nextInitialized`
368     mapping(uint256 => uint256) private _packedOwnerships;
369 
370     // Mapping owner address to address data.
371     //
372     // Bits Layout:
373     // - [0..63] `balance`
374     // - [64..127] `numberMinted`
375     // - [128..191] `numberBurned`
376     // - [192..255] `aux`
377     mapping(address => uint256) private _packedAddressData;
378 
379     // Mapping from token ID to approved address.
380     mapping(uint256 => address) private _tokenApprovals;
381 
382     // Mapping from owner to operator approvals
383     mapping(address => mapping(address => bool)) private _operatorApprovals;
384 
385 
386     function setData(string memory _contract, string memory _base) external onlyOwner{
387         _contractURI = _contract;
388         _baseURI = _base;
389     }
390 
391     function setCost(uint256 _newCost) external onlyOwner{
392         COST = _newCost;
393     }
394 
395     /**
396      * @dev Returns the starting token ID. 
397      * To change the starting token ID, please override this function.
398      */
399     function _startTokenId() internal view virtual returns (uint256) {
400         return 0;
401     }
402 
403     /**
404      * @dev Returns the next token ID to be minted.
405      */
406     function _nextTokenId() internal view returns (uint256) {
407         return _currentIndex;
408     }
409 
410     /**
411      * @dev Returns the total number of tokens in existence.
412      * Burned tokens will reduce the count. 
413      * To get the total number of tokens minted, please see `_totalMinted`.
414      */
415     function totalSupply() public view override returns (uint256) {
416         // Counter underflow is impossible as _burnCounter cannot be incremented
417         // more than `_currentIndex - _startTokenId()` times.
418         unchecked {
419             return _currentIndex - _startTokenId();
420         }
421     }
422 
423     /**
424      * @dev Returns the total amount of tokens minted in the contract.
425      */
426     function _totalMinted() internal view returns (uint256) {
427         // Counter underflow is impossible as _currentIndex does not decrement,
428         // and it is initialized to `_startTokenId()`
429         unchecked {
430             return _currentIndex - _startTokenId();
431         }
432     }
433 
434 
435     /**
436      * @dev See {IERC165-supportsInterface}.
437      */
438     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
439         // The interface IDs are constants representing the first 4 bytes of the XOR of
440         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
441         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
442         return
443             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
444             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
445             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
446     }
447 
448     /**
449      * @dev See {IERC721-balanceOf}.
450      */
451     function balanceOf(address owner) public view override returns (uint256) {
452         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
453         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
454     }
455 
456     /**
457      * Returns the number of tokens minted by `owner`.
458      */
459     function _numberMinted(address owner) internal view returns (uint256) {
460         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
461     }
462 
463 
464 
465     /**
466      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
467      */
468     function _getAux(address owner) internal view returns (uint64) {
469         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
470     }
471 
472     /**
473      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
474      * If there are multiple variables, please pack them into a uint64.
475      */
476     function _setAux(address owner, uint64 aux) internal {
477         uint256 packed = _packedAddressData[owner];
478         uint256 auxCasted;
479         assembly { // Cast aux without masking.
480             auxCasted := aux
481         }
482         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
483         _packedAddressData[owner] = packed;
484     }
485 
486     /**
487      * Returns the packed ownership data of `tokenId`.
488      */
489     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
490         uint256 curr = tokenId;
491 
492         unchecked {
493             if (_startTokenId() <= curr)
494                 if (curr < _currentIndex) {
495                     uint256 packed = _packedOwnerships[curr];
496                     // If not burned.
497                     if (packed & BITMASK_BURNED == 0) {
498                         // Invariant:
499                         // There will always be an ownership that has an address and is not burned
500                         // before an ownership that does not have an address and is not burned.
501                         // Hence, curr will not underflow.
502                         //
503                         // We can directly compare the packed value.
504                         // If the address is zero, packed is zero.
505                         while (packed == 0) {
506                             packed = _packedOwnerships[--curr];
507                         }
508                         return packed;
509                     }
510                 }
511         }
512         revert OwnerQueryForNonexistentToken();
513     }
514 
515     /**
516      * Returns the unpacked `TokenOwnership` struct from `packed`.
517      */
518     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
519         ownership.addr = address(uint160(packed));
520         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
521         ownership.burned = packed & BITMASK_BURNED != 0;
522     }
523 
524     /**
525      * Returns the unpacked `TokenOwnership` struct at `index`.
526      */
527     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
528         return _unpackedOwnership(_packedOwnerships[index]);
529     }
530 
531     /**
532      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
533      */
534     function _initializeOwnershipAt(uint256 index) internal {
535         if (_packedOwnerships[index] == 0) {
536             _packedOwnerships[index] = _packedOwnershipOf(index);
537         }
538     }
539 
540     /**
541      * Gas spent here starts off proportional to the maximum mint batch size.
542      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
543      */
544     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
545         return _unpackedOwnership(_packedOwnershipOf(tokenId));
546     }
547 
548     /**
549      * @dev See {IERC721-ownerOf}.
550      */
551     function ownerOf(uint256 tokenId) public view override returns (address) {
552         return address(uint160(_packedOwnershipOf(tokenId)));
553     }
554 
555     /**
556      * @dev See {IERC721Metadata-name}.
557      */
558     function name() public view virtual override returns (string memory) {
559         return _name;
560     }
561 
562     /**
563      * @dev See {IERC721Metadata-symbol}.
564      */
565     function symbol() public view virtual override returns (string memory) {
566         return _symbol;
567     }
568 
569     
570     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
571         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
572         string memory baseURI = _baseURI;
573         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
574     }
575 
576     function contractURI() public view returns (string memory) {
577         return string(abi.encodePacked("ipfs://", _contractURI));
578     }
579 
580     /**
581      * @dev Casts the address to uint256 without masking.
582      */
583     function _addressToUint256(address value) private pure returns (uint256 result) {
584         assembly {
585             result := value
586         }
587     }
588 
589     /**
590      * @dev Casts the boolean to uint256 without branching.
591      */
592     function _boolToUint256(bool value) private pure returns (uint256 result) {
593         assembly {
594             result := value
595         }
596     }
597 
598     /**
599      * @dev See {IERC721-approve}.
600      */
601     function approve(address to, uint256 tokenId) public override {
602         address owner = address(uint160(_packedOwnershipOf(tokenId)));
603         if (to == owner) revert();
604 
605         if (_msgSenderERC721A() != owner)
606             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
607                 revert ApprovalCallerNotOwnerNorApproved();
608             }
609 
610         _tokenApprovals[tokenId] = to;
611         emit Approval(owner, to, tokenId);
612     }
613 
614     /**
615      * @dev See {IERC721-getApproved}.
616      */
617     function getApproved(uint256 tokenId) public view override returns (address) {
618         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
619 
620         return _tokenApprovals[tokenId];
621     }
622 
623     /**
624      * @dev See {IERC721-setApprovalForAll}.
625      */
626     function setApprovalForAll(address operator, bool approved) public virtual override {
627         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
628 
629         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
630         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
631     }
632 
633     /**
634      * @dev See {IERC721-isApprovedForAll}.
635      */
636     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
637         return _operatorApprovals[owner][operator];
638     }
639 
640     /**
641      * @dev See {IERC721-transferFrom}.
642      */
643     function transferFrom(
644             address from,
645             address to,
646             uint256 tokenId
647             ) public virtual override {
648         _transfer(from, to, tokenId);
649     }
650 
651     /**
652      * @dev See {IERC721-safeTransferFrom}.
653      */
654     function safeTransferFrom(
655             address from,
656             address to,
657             uint256 tokenId
658             ) public virtual override {
659         safeTransferFrom(from, to, tokenId, '');
660     }
661 
662     /**
663      * @dev See {IERC721-safeTransferFrom}.
664      */
665     function safeTransferFrom(
666             address from,
667             address to,
668             uint256 tokenId,
669             bytes memory _data
670             ) public virtual override {
671         _transfer(from, to, tokenId);
672     }
673 
674     /**
675      * @dev Returns whether `tokenId` exists.
676      *
677      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
678      *
679      * Tokens start existing when they are minted (`_mint`),
680      */
681     function _exists(uint256 tokenId) internal view returns (bool) {
682         return
683             _startTokenId() <= tokenId &&
684             tokenId < _currentIndex;
685     }
686 
687     /**
688      * @dev Equivalent to `_safeMint(to, quantity, '')`.
689      */
690      /*
691     function _safeMint(address to, uint256 quantity) internal {
692         _safeMint(to, quantity, '');
693     }
694     */
695 
696     /**
697      * @dev Safely mints `quantity` tokens and transfers them to `to`.
698      *
699      * Requirements:
700      *
701      * - If `to` refers to a smart contract, it must implement
702      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
703      * - `quantity` must be greater than 0.
704      *
705      * Emits a {Transfer} event.
706      */
707      /*
708     function _safeMint(
709             address to,
710             uint256 quantity,
711             bytes memory _data
712             ) internal {
713         uint256 startTokenId = _currentIndex;
714         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
715         if (quantity == 0) revert MintZeroQuantity();
716 
717 
718         // Overflows are incredibly unrealistic.
719         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
720         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
721         unchecked {
722             // Updates:
723             // - `balance += quantity`.
724             // - `numberMinted += quantity`.
725             //
726             // We can directly add to the balance and number minted.
727             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
728 
729             // Updates:
730             // - `address` to the owner.
731             // - `startTimestamp` to the timestamp of minting.
732             // - `burned` to `false`.
733             // - `nextInitialized` to `quantity == 1`.
734             _packedOwnerships[startTokenId] =
735                 _addressToUint256(to) |
736                 (block.timestamp << BITPOS_START_TIMESTAMP) |
737                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
738 
739             uint256 updatedIndex = startTokenId;
740             uint256 end = updatedIndex + quantity;
741 
742             if (to.code.length != 0) {
743                 do {
744                     emit Transfer(address(0), to, updatedIndex);
745                 } while (updatedIndex < end);
746                 // Reentrancy protection
747                 if (_currentIndex != startTokenId) revert();
748             } else {
749                 do {
750                     emit Transfer(address(0), to, updatedIndex++);
751                 } while (updatedIndex < end);
752             }
753             _currentIndex = updatedIndex;
754         }
755         _afterTokenTransfers(address(0), to, startTokenId, quantity);
756     }
757     */
758 
759     /**
760      * @dev Mints `quantity` tokens and transfers them to `to`.
761      *
762      * Requirements:
763      *
764      * - `to` cannot be the zero address.
765      * - `quantity` must be greater than 0.
766      *
767      * Emits a {Transfer} event.
768      */
769     function _mint(address to, uint256 quantity) internal {
770         uint256 startTokenId = _currentIndex;
771         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
772         if (quantity == 0) revert MintZeroQuantity();
773 
774 
775         // Overflows are incredibly unrealistic.
776         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
777         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
778         unchecked {
779             // Updates:
780             // - `balance += quantity`.
781             // - `numberMinted += quantity`.
782             //
783             // We can directly add to the balance and number minted.
784             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
785 
786             // Updates:
787             // - `address` to the owner.
788             // - `startTimestamp` to the timestamp of minting.
789             // - `burned` to `false`.
790             // - `nextInitialized` to `quantity == 1`.
791             _packedOwnerships[startTokenId] =
792                 _addressToUint256(to) |
793                 (block.timestamp << BITPOS_START_TIMESTAMP) |
794                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
795 
796             uint256 updatedIndex = startTokenId;
797             uint256 end = updatedIndex + quantity;
798 
799             do {
800                 emit Transfer(address(0), to, updatedIndex++);
801             } while (updatedIndex < end);
802 
803             _currentIndex = updatedIndex;
804         }
805         _afterTokenTransfers(address(0), to, startTokenId, quantity);
806     }
807 
808     /**
809      * @dev Transfers `tokenId` from `from` to `to`.
810      *
811      * Requirements:
812      *
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _transfer(
819             address from,
820             address to,
821             uint256 tokenId
822             ) private {
823 
824         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
825 
826         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
827 
828         address approvedAddress = _tokenApprovals[tokenId];
829 
830         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
831                 isApprovedForAll(from, _msgSenderERC721A()) ||
832                 approvedAddress == _msgSenderERC721A());
833 
834         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
835 
836         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
837 
838 
839         // Clear approvals from the previous owner.
840         if (_addressToUint256(approvedAddress) != 0) {
841             delete _tokenApprovals[tokenId];
842         }
843 
844         // Underflow of the sender's balance is impossible because we check for
845         // ownership above and the recipient's balance can't realistically overflow.
846         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
847         unchecked {
848             // We can directly increment and decrement the balances.
849             --_packedAddressData[from]; // Updates: `balance -= 1`.
850             ++_packedAddressData[to]; // Updates: `balance += 1`.
851 
852             // Updates:
853             // - `address` to the next owner.
854             // - `startTimestamp` to the timestamp of transfering.
855             // - `burned` to `false`.
856             // - `nextInitialized` to `true`.
857             _packedOwnerships[tokenId] =
858                 _addressToUint256(to) |
859                 (block.timestamp << BITPOS_START_TIMESTAMP) |
860                 BITMASK_NEXT_INITIALIZED;
861 
862             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
863             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
864                 uint256 nextTokenId = tokenId + 1;
865                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
866                 if (_packedOwnerships[nextTokenId] == 0) {
867                     // If the next slot is within bounds.
868                     if (nextTokenId != _currentIndex) {
869                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
870                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
871                     }
872                 }
873             }
874         }
875 
876         emit Transfer(from, to, tokenId);
877         _afterTokenTransfers(from, to, tokenId, 1);
878     }
879 
880 
881 
882 
883     /**
884      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
885      * minting.
886      * And also called after one token has been burned.
887      *
888      * startTokenId - the first token id to be transferred
889      * quantity - the amount to be transferred
890      *
891      * Calling conditions:
892      *
893      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
894      * transferred to `to`.
895      * - When `from` is zero, `tokenId` has been minted for `to`.
896      * - When `to` is zero, `tokenId` has been burned by `from`.
897      * - `from` and `to` are never both zero.
898      */
899     function _afterTokenTransfers(
900             address from,
901             address to,
902             uint256 startTokenId,
903             uint256 quantity
904             ) internal virtual {}
905 
906     /**
907      * @dev Returns the message sender (defaults to `msg.sender`).
908      *
909      * If you are writing GSN compatible contracts, you need to override this function.
910      */
911     function _msgSenderERC721A() internal view virtual returns (address) {
912         return msg.sender;
913     }
914 
915     /**
916      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
917      */
918     function _toString(uint256 value) internal pure returns (string memory ptr) {
919         assembly {
920             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
921             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
922             // We will need 1 32-byte word to store the length, 
923             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
924             ptr := add(mload(0x40), 128)
925 
926          // Update the free memory pointer to allocate.
927          mstore(0x40, ptr)
928 
929          // Cache the end of the memory to calculate the length later.
930          let end := ptr
931 
932          // We write the string from the rightmost digit to the leftmost digit.
933          // The following is essentially a do-while loop that also handles the zero case.
934          // Costs a bit more than early returning for the zero case,
935          // but cheaper in terms of deployment and overall runtime costs.
936          for { 
937              // Initialize and perform the first pass without check.
938              let temp := value
939                  // Move the pointer 1 byte leftwards to point to an empty character slot.
940                  ptr := sub(ptr, 1)
941                  // Write the character to the pointer. 48 is the ASCII index of '0'.
942                  mstore8(ptr, add(48, mod(temp, 10)))
943                  temp := div(temp, 10)
944          } temp { 
945              // Keep dividing `temp` until zero.
946         temp := div(temp, 10)
947          } { 
948              // Body of the for loop.
949         ptr := sub(ptr, 1)
950          mstore8(ptr, add(48, mod(temp, 10)))
951          }
952 
953      let length := sub(end, ptr)
954          // Move the pointer 32 bytes leftwards to make room for the length.
955          ptr := sub(ptr, 32)
956          // Store the length.
957          mstore(ptr, length)
958         }
959     }
960 
961     function withdraw() external onlyOwner {
962         uint256 balance = address(this).balance;
963         payable(msg.sender).transfer(balance);
964     }
965 }