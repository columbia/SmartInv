1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
3 
4 
5 /**
6  * @dev Interface of ERC721A.
7  */
8 interface IERC721A {
9     /**
10      * The caller must own the token or be an approved operator.
11      */
12     error ApprovalCallerNotOwnerNorApproved();
13 
14     /**
15      * The token does not exist.
16      */
17     error ApprovalQueryForNonexistentToken();
18 
19     /**
20      * The caller cannot approve to their own address.
21      */
22     error ApproveToCaller();
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
176     ) external;
177 
178     /**
179      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external;
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
207     ) external;
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
223     function approve(address to, uint256 tokenId) external;
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
287 contract TeenPunks is IERC721A { 
288 
289     address private _owner;
290     modifier onlyOwner() { 
291         require(_owner==msg.sender, "No!"); 
292         _; 
293     }
294 
295     bool public saleIsActive = true;
296 
297     uint256 public constant MAX_SUPPLY = 10000;
298     uint256 public constant MAX_FREE_PER_WALLET = 2;
299     uint256 public constant MAX_PER_WALLET = 10;
300     uint256 public constant COST = 0.002 ether;
301 
302     string private constant _name = "Teen Punks";
303     string private constant _symbol = "TEENPUNK";
304     string private _contractURI = "QmbFiCiQNtrrsmFR8gvjBJ9ssyTU1ph4FhE1cvt4U3bj1n";
305     string private _baseURI = "QmWBHPeTwq3HHDvoSg1wxeiGtUhY8EAN7pPwhk39eCbwjo";
306 
307     constructor() {
308         _owner = msg.sender;
309     }
310 
311     function mint(uint256 amount) external payable{
312         address _caller = _msgSenderERC721A();
313 
314         require(saleIsActive, "NotActive");
315         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
316         require(amount + _numberMinted(msg.sender) <= MAX_PER_WALLET+MAX_FREE_PER_WALLET, "AccLimit");
317         require(msg.value >= COST*amount, "Price");
318 
319         _safeMint(_caller, amount);
320     }
321 
322     function freeMint() external{
323         uint256 amount = MAX_FREE_PER_WALLET;
324         address _caller = _msgSenderERC721A();
325         uint256 earlyBonus = 0;
326         if(totalSupply()<5000){
327             earlyBonus += 2;
328         }
329 
330         require(saleIsActive, "NotActive");
331         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
332         require(amount + _numberMinted(msg.sender) <= MAX_FREE_PER_WALLET+earlyBonus, "AccLimit");
333 
334         _safeMint(_caller, amount+earlyBonus);
335     }
336 
337 
338     // Mask of an entry in packed address data.
339     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
340 
341     // The bit position of `numberMinted` in packed address data.
342     uint256 private constant BITPOS_NUMBER_MINTED = 64;
343 
344     // The bit position of `numberBurned` in packed address data.
345     uint256 private constant BITPOS_NUMBER_BURNED = 128;
346 
347     // The bit position of `aux` in packed address data.
348     uint256 private constant BITPOS_AUX = 192;
349 
350     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
351     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
352 
353     // The bit position of `startTimestamp` in packed ownership.
354     uint256 private constant BITPOS_START_TIMESTAMP = 160;
355 
356     // The bit mask of the `burned` bit in packed ownership.
357     uint256 private constant BITMASK_BURNED = 1 << 224;
358 
359     // The bit position of the `nextInitialized` bit in packed ownership.
360     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
361 
362     // The bit mask of the `nextInitialized` bit in packed ownership.
363     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
364 
365     // The tokenId of the next token to be minted.
366     uint256 private _currentIndex = 0;
367 
368     // The number of tokens burned.
369     // uint256 private _burnCounter;
370 
371 
372     // Mapping from token ID to ownership details
373     // An empty struct value does not necessarily mean the token is unowned.
374     // See `_packedOwnershipOf` implementation for details.
375     //
376     // Bits Layout:
377     // - [0..159] `addr`
378     // - [160..223] `startTimestamp`
379     // - [224] `burned`
380     // - [225] `nextInitialized`
381     mapping(uint256 => uint256) private _packedOwnerships;
382 
383     // Mapping owner address to address data.
384     //
385     // Bits Layout:
386     // - [0..63] `balance`
387     // - [64..127] `numberMinted`
388     // - [128..191] `numberBurned`
389     // - [192..255] `aux`
390     mapping(address => uint256) private _packedAddressData;
391 
392     // Mapping from token ID to approved address.
393     mapping(uint256 => address) private _tokenApprovals;
394 
395     // Mapping from owner to operator approvals
396     mapping(address => mapping(address => bool)) private _operatorApprovals;
397 
398 
399     function setSale(bool _saleIsActive) external onlyOwner{
400         saleIsActive = _saleIsActive;
401     }
402 
403     function setBaseURI(string memory _new) external onlyOwner{
404         _baseURI = _new;
405     }
406 
407     function setContractURI(string memory _new) external onlyOwner{
408         _contractURI = _new;
409     }
410    
411 
412     /**
413      * @dev Returns the starting token ID. 
414      * To change the starting token ID, please override this function.
415      */
416     function _startTokenId() internal view virtual returns (uint256) {
417         return 0;
418     }
419 
420     /**
421      * @dev Returns the next token ID to be minted.
422      */
423     function _nextTokenId() internal view returns (uint256) {
424         return _currentIndex;
425     }
426 
427     /**
428      * @dev Returns the total number of tokens in existence.
429      * Burned tokens will reduce the count. 
430      * To get the total number of tokens minted, please see `_totalMinted`.
431      */
432     function totalSupply() public view override returns (uint256) {
433         // Counter underflow is impossible as _burnCounter cannot be incremented
434         // more than `_currentIndex - _startTokenId()` times.
435         unchecked {
436             return _currentIndex - _startTokenId();
437         }
438     }
439 
440     /**
441      * @dev Returns the total amount of tokens minted in the contract.
442      */
443     function _totalMinted() internal view returns (uint256) {
444         // Counter underflow is impossible as _currentIndex does not decrement,
445         // and it is initialized to `_startTokenId()`
446         unchecked {
447             return _currentIndex - _startTokenId();
448         }
449     }
450 
451 
452     /**
453      * @dev See {IERC165-supportsInterface}.
454      */
455     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
456         // The interface IDs are constants representing the first 4 bytes of the XOR of
457         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
458         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
459         return
460             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
461             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
462             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
463     }
464 
465     /**
466      * @dev See {IERC721-balanceOf}.
467      */
468     function balanceOf(address owner) public view override returns (uint256) {
469         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
470         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
471     }
472 
473     /**
474      * Returns the number of tokens minted by `owner`.
475      */
476     function _numberMinted(address owner) internal view returns (uint256) {
477         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
478     }
479 
480 
481 
482     /**
483      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
484      */
485     function _getAux(address owner) internal view returns (uint64) {
486         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
487     }
488 
489     /**
490      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
491      * If there are multiple variables, please pack them into a uint64.
492      */
493     function _setAux(address owner, uint64 aux) internal {
494         uint256 packed = _packedAddressData[owner];
495         uint256 auxCasted;
496         assembly { // Cast aux without masking.
497             auxCasted := aux
498         }
499         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
500         _packedAddressData[owner] = packed;
501     }
502 
503     /**
504      * Returns the packed ownership data of `tokenId`.
505      */
506     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
507         uint256 curr = tokenId;
508 
509         unchecked {
510             if (_startTokenId() <= curr)
511                 if (curr < _currentIndex) {
512                     uint256 packed = _packedOwnerships[curr];
513                     // If not burned.
514                     if (packed & BITMASK_BURNED == 0) {
515                         // Invariant:
516                         // There will always be an ownership that has an address and is not burned
517                         // before an ownership that does not have an address and is not burned.
518                         // Hence, curr will not underflow.
519                         //
520                         // We can directly compare the packed value.
521                         // If the address is zero, packed is zero.
522                         while (packed == 0) {
523                             packed = _packedOwnerships[--curr];
524                         }
525                         return packed;
526                     }
527                 }
528         }
529         revert OwnerQueryForNonexistentToken();
530     }
531 
532     /**
533      * Returns the unpacked `TokenOwnership` struct from `packed`.
534      */
535     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
536         ownership.addr = address(uint160(packed));
537         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
538         ownership.burned = packed & BITMASK_BURNED != 0;
539     }
540 
541     /**
542      * Returns the unpacked `TokenOwnership` struct at `index`.
543      */
544     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
545         return _unpackedOwnership(_packedOwnerships[index]);
546     }
547 
548     /**
549      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
550      */
551     function _initializeOwnershipAt(uint256 index) internal {
552         if (_packedOwnerships[index] == 0) {
553             _packedOwnerships[index] = _packedOwnershipOf(index);
554         }
555     }
556 
557     /**
558      * Gas spent here starts off proportional to the maximum mint batch size.
559      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
560      */
561     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
562         return _unpackedOwnership(_packedOwnershipOf(tokenId));
563     }
564 
565     /**
566      * @dev See {IERC721-ownerOf}.
567      */
568     function ownerOf(uint256 tokenId) public view override returns (address) {
569         return address(uint160(_packedOwnershipOf(tokenId)));
570     }
571 
572     /**
573      * @dev See {IERC721Metadata-name}.
574      */
575     function name() public view virtual override returns (string memory) {
576         return _name;
577     }
578 
579     /**
580      * @dev See {IERC721Metadata-symbol}.
581      */
582     function symbol() public view virtual override returns (string memory) {
583         return _symbol;
584     }
585 
586     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
587         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
588         string memory baseURI = _baseURI;
589         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
590     }
591 
592     function contractURI() public view returns (string memory) {
593         return string(abi.encodePacked("ipfs://", _contractURI));
594     }
595 
596     /**
597      * @dev Casts the address to uint256 without masking.
598      */
599     function _addressToUint256(address value) private pure returns (uint256 result) {
600         assembly {
601             result := value
602         }
603     }
604 
605     /**
606      * @dev Casts the boolean to uint256 without branching.
607      */
608     function _boolToUint256(bool value) private pure returns (uint256 result) {
609         assembly {
610             result := value
611         }
612     }
613 
614     /**
615      * @dev See {IERC721-approve}.
616      */
617     function approve(address to, uint256 tokenId) public override {
618         address owner = address(uint160(_packedOwnershipOf(tokenId)));
619         if (to == owner) revert();
620 
621         if (_msgSenderERC721A() != owner)
622             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
623                 revert ApprovalCallerNotOwnerNorApproved();
624             }
625 
626         _tokenApprovals[tokenId] = to;
627         emit Approval(owner, to, tokenId);
628     }
629 
630     /**
631      * @dev See {IERC721-getApproved}.
632      */
633     function getApproved(uint256 tokenId) public view override returns (address) {
634         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
635 
636         return _tokenApprovals[tokenId];
637     }
638 
639     /**
640      * @dev See {IERC721-setApprovalForAll}.
641      */
642     function setApprovalForAll(address operator, bool approved) public virtual override {
643         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
644 
645         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
646         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
647     }
648 
649     /**
650      * @dev See {IERC721-isApprovedForAll}.
651      */
652     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
653         return _operatorApprovals[owner][operator];
654     }
655 
656     /**
657      * @dev See {IERC721-transferFrom}.
658      */
659     function transferFrom(
660             address from,
661             address to,
662             uint256 tokenId
663             ) public virtual override {
664         _transfer(from, to, tokenId);
665     }
666 
667     /**
668      * @dev See {IERC721-safeTransferFrom}.
669      */
670     function safeTransferFrom(
671             address from,
672             address to,
673             uint256 tokenId
674             ) public virtual override {
675         safeTransferFrom(from, to, tokenId, '');
676     }
677 
678     /**
679      * @dev See {IERC721-safeTransferFrom}.
680      */
681     function safeTransferFrom(
682             address from,
683             address to,
684             uint256 tokenId,
685             bytes memory _data
686             ) public virtual override {
687         _transfer(from, to, tokenId);
688     }
689 
690     /**
691      * @dev Returns whether `tokenId` exists.
692      *
693      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
694      *
695      * Tokens start existing when they are minted (`_mint`),
696      */
697     function _exists(uint256 tokenId) internal view returns (bool) {
698         return
699             _startTokenId() <= tokenId &&
700             tokenId < _currentIndex;
701     }
702 
703     /**
704      * @dev Equivalent to `_safeMint(to, quantity, '')`.
705      */
706     function _safeMint(address to, uint256 quantity) internal {
707         _safeMint(to, quantity, '');
708     }
709 
710     /**
711      * @dev Safely mints `quantity` tokens and transfers them to `to`.
712      *
713      * Requirements:
714      *
715      * - If `to` refers to a smart contract, it must implement
716      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
717      * - `quantity` must be greater than 0.
718      *
719      * Emits a {Transfer} event.
720      */
721     function _safeMint(
722             address to,
723             uint256 quantity,
724             bytes memory _data
725             ) internal {
726         uint256 startTokenId = _currentIndex;
727         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
728         if (quantity == 0) revert MintZeroQuantity();
729 
730 
731         // Overflows are incredibly unrealistic.
732         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
733         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
734         unchecked {
735             // Updates:
736             // - `balance += quantity`.
737             // - `numberMinted += quantity`.
738             //
739             // We can directly add to the balance and number minted.
740             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
741 
742             // Updates:
743             // - `address` to the owner.
744             // - `startTimestamp` to the timestamp of minting.
745             // - `burned` to `false`.
746             // - `nextInitialized` to `quantity == 1`.
747             _packedOwnerships[startTokenId] =
748                 _addressToUint256(to) |
749                 (block.timestamp << BITPOS_START_TIMESTAMP) |
750                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
751 
752             uint256 updatedIndex = startTokenId;
753             uint256 end = updatedIndex + quantity;
754 
755             if (to.code.length != 0) {
756                 do {
757                     emit Transfer(address(0), to, updatedIndex);
758                 } while (updatedIndex < end);
759                 // Reentrancy protection
760                 if (_currentIndex != startTokenId) revert();
761             } else {
762                 do {
763                     emit Transfer(address(0), to, updatedIndex++);
764                 } while (updatedIndex < end);
765             }
766             _currentIndex = updatedIndex;
767         }
768         _afterTokenTransfers(address(0), to, startTokenId, quantity);
769     }
770 
771     /**
772      * @dev Mints `quantity` tokens and transfers them to `to`.
773      *
774      * Requirements:
775      *
776      * - `to` cannot be the zero address.
777      * - `quantity` must be greater than 0.
778      *
779      * Emits a {Transfer} event.
780      */
781     function _mint(address to, uint256 quantity) internal {
782         uint256 startTokenId = _currentIndex;
783         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
784         if (quantity == 0) revert MintZeroQuantity();
785 
786 
787         // Overflows are incredibly unrealistic.
788         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
789         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
790         unchecked {
791             // Updates:
792             // - `balance += quantity`.
793             // - `numberMinted += quantity`.
794             //
795             // We can directly add to the balance and number minted.
796             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
797 
798             // Updates:
799             // - `address` to the owner.
800             // - `startTimestamp` to the timestamp of minting.
801             // - `burned` to `false`.
802             // - `nextInitialized` to `quantity == 1`.
803             _packedOwnerships[startTokenId] =
804                 _addressToUint256(to) |
805                 (block.timestamp << BITPOS_START_TIMESTAMP) |
806                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
807 
808             uint256 updatedIndex = startTokenId;
809             uint256 end = updatedIndex + quantity;
810 
811             do {
812                 emit Transfer(address(0), to, updatedIndex++);
813             } while (updatedIndex < end);
814 
815             _currentIndex = updatedIndex;
816         }
817         _afterTokenTransfers(address(0), to, startTokenId, quantity);
818     }
819 
820     /**
821      * @dev Transfers `tokenId` from `from` to `to`.
822      *
823      * Requirements:
824      *
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must be owned by `from`.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _transfer(
831             address from,
832             address to,
833             uint256 tokenId
834             ) private {
835 
836         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
837 
838         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
839 
840         address approvedAddress = _tokenApprovals[tokenId];
841 
842         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
843                 isApprovedForAll(from, _msgSenderERC721A()) ||
844                 approvedAddress == _msgSenderERC721A());
845 
846         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
847 
848         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
849 
850 
851         // Clear approvals from the previous owner.
852         if (_addressToUint256(approvedAddress) != 0) {
853             delete _tokenApprovals[tokenId];
854         }
855 
856         // Underflow of the sender's balance is impossible because we check for
857         // ownership above and the recipient's balance can't realistically overflow.
858         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
859         unchecked {
860             // We can directly increment and decrement the balances.
861             --_packedAddressData[from]; // Updates: `balance -= 1`.
862             ++_packedAddressData[to]; // Updates: `balance += 1`.
863 
864             // Updates:
865             // - `address` to the next owner.
866             // - `startTimestamp` to the timestamp of transfering.
867             // - `burned` to `false`.
868             // - `nextInitialized` to `true`.
869             _packedOwnerships[tokenId] =
870                 _addressToUint256(to) |
871                 (block.timestamp << BITPOS_START_TIMESTAMP) |
872                 BITMASK_NEXT_INITIALIZED;
873 
874             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
875             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
876                 uint256 nextTokenId = tokenId + 1;
877                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
878                 if (_packedOwnerships[nextTokenId] == 0) {
879                     // If the next slot is within bounds.
880                     if (nextTokenId != _currentIndex) {
881                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
882                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
883                     }
884                 }
885             }
886         }
887 
888         emit Transfer(from, to, tokenId);
889         _afterTokenTransfers(from, to, tokenId, 1);
890     }
891 
892 
893 
894 
895     /**
896      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
897      * minting.
898      * And also called after one token has been burned.
899      *
900      * startTokenId - the first token id to be transferred
901      * quantity - the amount to be transferred
902      *
903      * Calling conditions:
904      *
905      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
906      * transferred to `to`.
907      * - When `from` is zero, `tokenId` has been minted for `to`.
908      * - When `to` is zero, `tokenId` has been burned by `from`.
909      * - `from` and `to` are never both zero.
910      */
911     function _afterTokenTransfers(
912             address from,
913             address to,
914             uint256 startTokenId,
915             uint256 quantity
916             ) internal virtual {}
917 
918     /**
919      * @dev Returns the message sender (defaults to `msg.sender`).
920      *
921      * If you are writing GSN compatible contracts, you need to override this function.
922      */
923     function _msgSenderERC721A() internal view virtual returns (address) {
924         return msg.sender;
925     }
926 
927     /**
928      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
929      */
930     function _toString(uint256 value) internal pure returns (string memory ptr) {
931         assembly {
932             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
933             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
934             // We will need 1 32-byte word to store the length, 
935             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
936             ptr := add(mload(0x40), 128)
937 
938          // Update the free memory pointer to allocate.
939          mstore(0x40, ptr)
940 
941          // Cache the end of the memory to calculate the length later.
942          let end := ptr
943 
944          // We write the string from the rightmost digit to the leftmost digit.
945          // The following is essentially a do-while loop that also handles the zero case.
946          // Costs a bit more than early returning for the zero case,
947          // but cheaper in terms of deployment and overall runtime costs.
948          for { 
949              // Initialize and perform the first pass without check.
950              let temp := value
951                  // Move the pointer 1 byte leftwards to point to an empty character slot.
952                  ptr := sub(ptr, 1)
953                  // Write the character to the pointer. 48 is the ASCII index of '0'.
954                  mstore8(ptr, add(48, mod(temp, 10)))
955                  temp := div(temp, 10)
956          } temp { 
957              // Keep dividing `temp` until zero.
958         temp := div(temp, 10)
959          } { 
960              // Body of the for loop.
961         ptr := sub(ptr, 1)
962          mstore8(ptr, add(48, mod(temp, 10)))
963          }
964 
965      let length := sub(end, ptr)
966          // Move the pointer 32 bytes leftwards to make room for the length.
967          ptr := sub(ptr, 32)
968          // Store the length.
969          mstore(ptr, length)
970         }
971     }
972 
973     
974 
975     function withdraw() external onlyOwner {
976         uint256 balance = address(this).balance;
977         payable(msg.sender).transfer(balance);
978     }
979 }