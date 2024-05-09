1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.16;
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
292 contract RareApepePunks is IERC721A { 
293 
294     address private _owner;
295     modifier onlyOwner() { 
296         require(_owner==msg.sender, "No!"); 
297         _; 
298     }
299 
300     bool public saleIsActive = true;
301     uint256 public constant MAX_SUPPLY = 2222;
302     uint256 public constant MAX_FREE_PER_WALLET = 2;
303     uint256 public constant MAX_PER_WALLET = 10;
304     uint256 public constant COST = 0.002 ether;
305 
306     string private constant _name = "Rare Apepe Punks";
307     string private constant _symbol = "RAPEPUNK";
308     string private _contractURI = "QmZcJyrTYBFjKyuJj4KovJ9FyFaoiVATzNf4aJ11facy1t";
309     string private _baseURI = "QmVgUha3j7kDozwtNib9csbSb4AruMfT5wDoAEBf8dAzGL";
310 
311     constructor() {
312         _owner = msg.sender;
313     }
314 
315     function freeMint() external{
316         address _caller = _msgSenderERC721A();
317         uint256 amount = 1;
318 
319         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
320         require(amount + _numberMinted(msg.sender) <= MAX_FREE_PER_WALLET, "AccLimit");
321 
322         _mint(_caller, amount);
323     }
324 
325     function mint(uint256 amount) external payable{
326         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
327         require(amount + _numberMinted(msg.sender) <= MAX_PER_WALLET+MAX_FREE_PER_WALLET, "AccLimit");
328         require(amount*COST <= msg.value, "Value to low");
329         _mint(msg.sender, amount);
330     }
331 
332     // Mask of an entry in packed address data.
333     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
334 
335     // The bit position of `numberMinted` in packed address data.
336     uint256 private constant BITPOS_NUMBER_MINTED = 64;
337 
338     // The bit position of `numberBurned` in packed address data.
339     uint256 private constant BITPOS_NUMBER_BURNED = 128;
340 
341     // The bit position of `aux` in packed address data.
342     uint256 private constant BITPOS_AUX = 192;
343 
344     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
345     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
346 
347     // The bit position of `startTimestamp` in packed ownership.
348     uint256 private constant BITPOS_START_TIMESTAMP = 160;
349 
350     // The bit mask of the `burned` bit in packed ownership.
351     uint256 private constant BITMASK_BURNED = 1 << 224;
352 
353     // The bit position of the `nextInitialized` bit in packed ownership.
354     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
355 
356     // The bit mask of the `nextInitialized` bit in packed ownership.
357     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
358 
359     // The tokenId of the next token to be minted.
360     uint256 private _currentIndex = 0;
361 
362     // The number of tokens burned.
363     // uint256 private _burnCounter;
364 
365 
366     // Mapping from token ID to ownership details
367     // An empty struct value does not necessarily mean the token is unowned.
368     // See `_packedOwnershipOf` implementation for details.
369     //
370     // Bits Layout:
371     // - [0..159] `addr`
372     // - [160..223] `startTimestamp`
373     // - [224] `burned`
374     // - [225] `nextInitialized`
375     mapping(uint256 => uint256) private _packedOwnerships;
376 
377     // Mapping owner address to address data.
378     //
379     // Bits Layout:
380     // - [0..63] `balance`
381     // - [64..127] `numberMinted`
382     // - [128..191] `numberBurned`
383     // - [192..255] `aux`
384     mapping(address => uint256) private _packedAddressData;
385 
386     // Mapping from token ID to approved address.
387     mapping(uint256 => address) private _tokenApprovals;
388 
389     // Mapping from owner to operator approvals
390     mapping(address => mapping(address => bool)) private _operatorApprovals;
391 
392    
393     function setSale(bool _saleIsActive) external onlyOwner{
394         saleIsActive = _saleIsActive;
395     }
396 
397     function setBaseURI(string memory _new) external onlyOwner{
398         _baseURI = _new;
399     }
400 
401     function setContractURI(string memory _new) external onlyOwner{
402         _contractURI = _new;
403     }
404 
405     /**
406      * @dev Returns the starting token ID. 
407      * To change the starting token ID, please override this function.
408      */
409     function _startTokenId() internal view virtual returns (uint256) {
410         return 0;
411     }
412 
413     /**
414      * @dev Returns the next token ID to be minted.
415      */
416     function _nextTokenId() internal view returns (uint256) {
417         return _currentIndex;
418     }
419 
420     /**
421      * @dev Returns the total number of tokens in existence.
422      * Burned tokens will reduce the count. 
423      * To get the total number of tokens minted, please see `_totalMinted`.
424      */
425     function totalSupply() public view override returns (uint256) {
426         // Counter underflow is impossible as _burnCounter cannot be incremented
427         // more than `_currentIndex - _startTokenId()` times.
428         unchecked {
429             return _currentIndex - _startTokenId();
430         }
431     }
432 
433     /**
434      * @dev Returns the total amount of tokens minted in the contract.
435      */
436     function _totalMinted() internal view returns (uint256) {
437         // Counter underflow is impossible as _currentIndex does not decrement,
438         // and it is initialized to `_startTokenId()`
439         unchecked {
440             return _currentIndex - _startTokenId();
441         }
442     }
443 
444 
445     /**
446      * @dev See {IERC165-supportsInterface}.
447      */
448     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
449         // The interface IDs are constants representing the first 4 bytes of the XOR of
450         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
451         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
452         return
453             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
454             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
455             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
456     }
457 
458     /**
459      * @dev See {IERC721-balanceOf}.
460      */
461     function balanceOf(address owner) public view override returns (uint256) {
462         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
463         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
464     }
465 
466     /**
467      * Returns the number of tokens minted by `owner`.
468      */
469     function _numberMinted(address owner) internal view returns (uint256) {
470         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
471     }
472 
473 
474 
475     /**
476      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
477      */
478     function _getAux(address owner) internal view returns (uint64) {
479         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
480     }
481 
482     /**
483      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
484      * If there are multiple variables, please pack them into a uint64.
485      */
486     function _setAux(address owner, uint64 aux) internal {
487         uint256 packed = _packedAddressData[owner];
488         uint256 auxCasted;
489         assembly { // Cast aux without masking.
490             auxCasted := aux
491         }
492         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
493         _packedAddressData[owner] = packed;
494     }
495 
496     /**
497      * Returns the packed ownership data of `tokenId`.
498      */
499     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
500         uint256 curr = tokenId;
501 
502         unchecked {
503             if (_startTokenId() <= curr)
504                 if (curr < _currentIndex) {
505                     uint256 packed = _packedOwnerships[curr];
506                     // If not burned.
507                     if (packed & BITMASK_BURNED == 0) {
508                         // Invariant:
509                         // There will always be an ownership that has an address and is not burned
510                         // before an ownership that does not have an address and is not burned.
511                         // Hence, curr will not underflow.
512                         //
513                         // We can directly compare the packed value.
514                         // If the address is zero, packed is zero.
515                         while (packed == 0) {
516                             packed = _packedOwnerships[--curr];
517                         }
518                         return packed;
519                     }
520                 }
521         }
522         revert OwnerQueryForNonexistentToken();
523     }
524 
525     /**
526      * Returns the unpacked `TokenOwnership` struct from `packed`.
527      */
528     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
529         ownership.addr = address(uint160(packed));
530         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
531         ownership.burned = packed & BITMASK_BURNED != 0;
532     }
533 
534     /**
535      * Returns the unpacked `TokenOwnership` struct at `index`.
536      */
537     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
538         return _unpackedOwnership(_packedOwnerships[index]);
539     }
540 
541     /**
542      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
543      */
544     function _initializeOwnershipAt(uint256 index) internal {
545         if (_packedOwnerships[index] == 0) {
546             _packedOwnerships[index] = _packedOwnershipOf(index);
547         }
548     }
549 
550     /**
551      * Gas spent here starts off proportional to the maximum mint batch size.
552      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
553      */
554     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
555         return _unpackedOwnership(_packedOwnershipOf(tokenId));
556     }
557 
558     /**
559      * @dev See {IERC721-ownerOf}.
560      */
561     function ownerOf(uint256 tokenId) public view override returns (address) {
562         return address(uint160(_packedOwnershipOf(tokenId)));
563     }
564 
565     /**
566      * @dev See {IERC721Metadata-name}.
567      */
568     function name() public view virtual override returns (string memory) {
569         return _name;
570     }
571 
572     /**
573      * @dev See {IERC721Metadata-symbol}.
574      */
575     function symbol() public view virtual override returns (string memory) {
576         return _symbol;
577     }
578 
579     
580     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
581         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
582         string memory baseURI = _baseURI;
583         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
584     }
585 
586     function contractURI() public view returns (string memory) {
587         return string(abi.encodePacked("ipfs://", _contractURI));
588     }
589 
590     /**
591      * @dev Casts the address to uint256 without masking.
592      */
593     function _addressToUint256(address value) private pure returns (uint256 result) {
594         assembly {
595             result := value
596         }
597     }
598 
599     /**
600      * @dev Casts the boolean to uint256 without branching.
601      */
602     function _boolToUint256(bool value) private pure returns (uint256 result) {
603         assembly {
604             result := value
605         }
606     }
607 
608     /**
609      * @dev See {IERC721-approve}.
610      */
611     function approve(address to, uint256 tokenId) public override {
612         address owner = address(uint160(_packedOwnershipOf(tokenId)));
613         if (to == owner) revert();
614 
615         if (_msgSenderERC721A() != owner)
616             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
617                 revert ApprovalCallerNotOwnerNorApproved();
618             }
619 
620         _tokenApprovals[tokenId] = to;
621         emit Approval(owner, to, tokenId);
622     }
623 
624     /**
625      * @dev See {IERC721-getApproved}.
626      */
627     function getApproved(uint256 tokenId) public view override returns (address) {
628         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
629 
630         return _tokenApprovals[tokenId];
631     }
632 
633     /**
634      * @dev See {IERC721-setApprovalForAll}.
635      */
636     function setApprovalForAll(address operator, bool approved) public virtual override {
637         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
638 
639         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
640         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
641     }
642 
643     /**
644      * @dev See {IERC721-isApprovedForAll}.
645      */
646     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
647         return _operatorApprovals[owner][operator];
648     }
649 
650     /**
651      * @dev See {IERC721-transferFrom}.
652      */
653     function transferFrom(
654             address from,
655             address to,
656             uint256 tokenId
657             ) public virtual override {
658         _transfer(from, to, tokenId);
659     }
660 
661     /**
662      * @dev See {IERC721-safeTransferFrom}.
663      */
664     function safeTransferFrom(
665             address from,
666             address to,
667             uint256 tokenId
668             ) public virtual override {
669         safeTransferFrom(from, to, tokenId, '');
670     }
671 
672     /**
673      * @dev See {IERC721-safeTransferFrom}.
674      */
675     function safeTransferFrom(
676             address from,
677             address to,
678             uint256 tokenId,
679             bytes memory _data
680             ) public virtual override {
681         _transfer(from, to, tokenId);
682     }
683 
684     /**
685      * @dev Returns whether `tokenId` exists.
686      *
687      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
688      *
689      * Tokens start existing when they are minted (`_mint`),
690      */
691     function _exists(uint256 tokenId) internal view returns (bool) {
692         return
693             _startTokenId() <= tokenId &&
694             tokenId < _currentIndex;
695     }
696 
697     /**
698      * @dev Equivalent to `_safeMint(to, quantity, '')`.
699      */
700      /*
701     function _safeMint(address to, uint256 quantity) internal {
702         _safeMint(to, quantity, '');
703     }
704     */
705 
706     /**
707      * @dev Safely mints `quantity` tokens and transfers them to `to`.
708      *
709      * Requirements:
710      *
711      * - If `to` refers to a smart contract, it must implement
712      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
713      * - `quantity` must be greater than 0.
714      *
715      * Emits a {Transfer} event.
716      */
717      /*
718     function _safeMint(
719             address to,
720             uint256 quantity,
721             bytes memory _data
722             ) internal {
723         uint256 startTokenId = _currentIndex;
724         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
725         if (quantity == 0) revert MintZeroQuantity();
726 
727 
728         // Overflows are incredibly unrealistic.
729         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
730         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
731         unchecked {
732             // Updates:
733             // - `balance += quantity`.
734             // - `numberMinted += quantity`.
735             //
736             // We can directly add to the balance and number minted.
737             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
738 
739             // Updates:
740             // - `address` to the owner.
741             // - `startTimestamp` to the timestamp of minting.
742             // - `burned` to `false`.
743             // - `nextInitialized` to `quantity == 1`.
744             _packedOwnerships[startTokenId] =
745                 _addressToUint256(to) |
746                 (block.timestamp << BITPOS_START_TIMESTAMP) |
747                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
748 
749             uint256 updatedIndex = startTokenId;
750             uint256 end = updatedIndex + quantity;
751 
752             if (to.code.length != 0) {
753                 do {
754                     emit Transfer(address(0), to, updatedIndex);
755                 } while (updatedIndex < end);
756                 // Reentrancy protection
757                 if (_currentIndex != startTokenId) revert();
758             } else {
759                 do {
760                     emit Transfer(address(0), to, updatedIndex++);
761                 } while (updatedIndex < end);
762             }
763             _currentIndex = updatedIndex;
764         }
765         _afterTokenTransfers(address(0), to, startTokenId, quantity);
766     }
767     */
768 
769     /**
770      * @dev Mints `quantity` tokens and transfers them to `to`.
771      *
772      * Requirements:
773      *
774      * - `to` cannot be the zero address.
775      * - `quantity` must be greater than 0.
776      *
777      * Emits a {Transfer} event.
778      */
779     function _mint(address to, uint256 quantity) internal {
780         uint256 startTokenId = _currentIndex;
781         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
782         if (quantity == 0) revert MintZeroQuantity();
783 
784 
785         // Overflows are incredibly unrealistic.
786         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
787         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
788         unchecked {
789             // Updates:
790             // - `balance += quantity`.
791             // - `numberMinted += quantity`.
792             //
793             // We can directly add to the balance and number minted.
794             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
795 
796             // Updates:
797             // - `address` to the owner.
798             // - `startTimestamp` to the timestamp of minting.
799             // - `burned` to `false`.
800             // - `nextInitialized` to `quantity == 1`.
801             _packedOwnerships[startTokenId] =
802                 _addressToUint256(to) |
803                 (block.timestamp << BITPOS_START_TIMESTAMP) |
804                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
805 
806             uint256 updatedIndex = startTokenId;
807             uint256 end = updatedIndex + quantity;
808 
809             do {
810                 emit Transfer(address(0), to, updatedIndex++);
811             } while (updatedIndex < end);
812 
813             _currentIndex = updatedIndex;
814         }
815         _afterTokenTransfers(address(0), to, startTokenId, quantity);
816     }
817 
818     /**
819      * @dev Transfers `tokenId` from `from` to `to`.
820      *
821      * Requirements:
822      *
823      * - `to` cannot be the zero address.
824      * - `tokenId` token must be owned by `from`.
825      *
826      * Emits a {Transfer} event.
827      */
828     function _transfer(
829             address from,
830             address to,
831             uint256 tokenId
832             ) private {
833 
834         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
835 
836         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
837 
838         address approvedAddress = _tokenApprovals[tokenId];
839 
840         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
841                 isApprovedForAll(from, _msgSenderERC721A()) ||
842                 approvedAddress == _msgSenderERC721A());
843 
844         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
845 
846         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
847 
848 
849         // Clear approvals from the previous owner.
850         if (_addressToUint256(approvedAddress) != 0) {
851             delete _tokenApprovals[tokenId];
852         }
853 
854         // Underflow of the sender's balance is impossible because we check for
855         // ownership above and the recipient's balance can't realistically overflow.
856         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
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
867             _packedOwnerships[tokenId] =
868                 _addressToUint256(to) |
869                 (block.timestamp << BITPOS_START_TIMESTAMP) |
870                 BITMASK_NEXT_INITIALIZED;
871 
872             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
873             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
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
890 
891 
892 
893     /**
894      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
895      * minting.
896      * And also called after one token has been burned.
897      *
898      * startTokenId - the first token id to be transferred
899      * quantity - the amount to be transferred
900      *
901      * Calling conditions:
902      *
903      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
904      * transferred to `to`.
905      * - When `from` is zero, `tokenId` has been minted for `to`.
906      * - When `to` is zero, `tokenId` has been burned by `from`.
907      * - `from` and `to` are never both zero.
908      */
909     function _afterTokenTransfers(
910             address from,
911             address to,
912             uint256 startTokenId,
913             uint256 quantity
914             ) internal virtual {}
915 
916     /**
917      * @dev Returns the message sender (defaults to `msg.sender`).
918      *
919      * If you are writing GSN compatible contracts, you need to override this function.
920      */
921     function _msgSenderERC721A() internal view virtual returns (address) {
922         return msg.sender;
923     }
924 
925     /**
926      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
927      */
928     function _toString(uint256 value) internal pure returns (string memory ptr) {
929         assembly {
930             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
931             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
932             // We will need 1 32-byte word to store the length, 
933             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
934             ptr := add(mload(0x40), 128)
935 
936          // Update the free memory pointer to allocate.
937          mstore(0x40, ptr)
938 
939          // Cache the end of the memory to calculate the length later.
940          let end := ptr
941 
942          // We write the string from the rightmost digit to the leftmost digit.
943          // The following is essentially a do-while loop that also handles the zero case.
944          // Costs a bit more than early returning for the zero case,
945          // but cheaper in terms of deployment and overall runtime costs.
946          for { 
947              // Initialize and perform the first pass without check.
948              let temp := value
949                  // Move the pointer 1 byte leftwards to point to an empty character slot.
950                  ptr := sub(ptr, 1)
951                  // Write the character to the pointer. 48 is the ASCII index of '0'.
952                  mstore8(ptr, add(48, mod(temp, 10)))
953                  temp := div(temp, 10)
954          } temp { 
955              // Keep dividing `temp` until zero.
956         temp := div(temp, 10)
957          } { 
958              // Body of the for loop.
959         ptr := sub(ptr, 1)
960          mstore8(ptr, add(48, mod(temp, 10)))
961          }
962 
963      let length := sub(end, ptr)
964          // Move the pointer 32 bytes leftwards to make room for the length.
965          ptr := sub(ptr, 32)
966          // Store the length.
967          mstore(ptr, length)
968         }
969     }
970 
971     function withdraw() external onlyOwner {
972         uint256 balance = address(this).balance;
973         payable(msg.sender).transfer(balance);
974     }
975 }