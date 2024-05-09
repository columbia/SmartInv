1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /**
5  * @dev Interface of ERC721A.
6  */
7 interface IERC721A {
8     /**
9      * The caller must own the token or be an approved operator.
10      */
11     error ApprovalCallerNotOwnerNorApproved();
12 
13     /**
14      * The token does not exist.
15      */
16     error ApprovalQueryForNonexistentToken();
17 
18     /**
19      * The caller cannot approve to their own address.
20      */
21     error ApproveToCaller();
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
175     ) external;
176 
177     /**
178      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId
184     ) external;
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
206     ) external;
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
222     function approve(address to, uint256 tokenId) external;
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
287 contract CryptoRunks is IERC721A { 
288     address private _owner;
289     function owner() public view returns(address){
290         return _owner;
291     }
292 
293     modifier onlyOwner() { 
294         require(_owner==msg.sender);
295         _; 
296     }
297 
298     uint256 public constant MAX_SUPPLY = 2000;
299     uint256 public MAX_FREE = 1555;
300     uint256 public MAX_FREE_PER_WALLET = 1;
301     uint256 public COST = 0.001 ether;
302 
303     string private constant _name = "CryptoRunks";
304     string private constant _symbol = "CR";
305     string private _baseURI = "bafybeihyc2abribm5zea24oqxhulgdcuclqnbiqpywt6sibk3td6fgmskq";
306 
307     constructor() {
308         _owner = msg.sender;
309     }
310 
311     function mint(uint256 amount) external payable{
312         address _caller = _msgSenderERC721A();
313 
314         require(totalSupply() + amount <= MAX_SUPPLY, "Sold Out");
315         require(amount*COST <= msg.value, "Too Low");
316 
317         _mint(_caller, amount);
318     }
319 
320     function freeMint() external{
321         address _caller = _msgSenderERC721A();
322         uint256 amount = 1;
323 
324         require(totalSupply() + amount <= MAX_FREE, "Freemint Sold Out");
325         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "Max 1 per Wallet");
326 
327         _mint(_caller, amount);
328     }
329 
330     // Mask of an entry in packed address data.
331     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
332 
333     // The bit position of `numberMinted` in packed address data.
334     uint256 private constant BITPOS_NUMBER_MINTED = 64;
335 
336     // The bit position of `numberBurned` in packed address data.
337     uint256 private constant BITPOS_NUMBER_BURNED = 128;
338 
339     // The bit position of `aux` in packed address data.
340     uint256 private constant BITPOS_AUX = 192;
341 
342     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
343     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
344 
345     // The bit position of `startTimestamp` in packed ownership.
346     uint256 private constant BITPOS_START_TIMESTAMP = 160;
347 
348     // The bit mask of the `burned` bit in packed ownership.
349     uint256 private constant BITMASK_BURNED = 1 << 224;
350 
351     // The bit position of the `nextInitialized` bit in packed ownership.
352     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
353 
354     // The bit mask of the `nextInitialized` bit in packed ownership.
355     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
356 
357     // The tokenId of the next token to be minted.
358     uint256 private _currentIndex = 0;
359 
360     // The number of tokens burned.
361     // uint256 private _burnCounter;
362 
363 
364     // Mapping from token ID to ownership details
365     // An empty struct value does not necessarily mean the token is unowned.
366     // See `_packedOwnershipOf` implementation for details.
367     //
368     // Bits Layout:
369     // - [0..159] `addr`
370     // - [160..223] `startTimestamp`
371     // - [224] `burned`
372     // - [225] `nextInitialized`
373     mapping(uint256 => uint256) private _packedOwnerships;
374 
375     // Mapping owner address to address data.
376     //
377     // Bits Layout:
378     // - [0..63] `balance`
379     // - [64..127] `numberMinted`
380     // - [128..191] `numberBurned`
381     // - [192..255] `aux`
382     mapping(address => uint256) private _packedAddressData;
383 
384     // Mapping from token ID to approved address.
385     mapping(uint256 => address) private _tokenApprovals;
386 
387     // Mapping from owner to operator approvals
388     mapping(address => mapping(address => bool)) private _operatorApprovals;
389 
390 
391     function setData(string memory _base) external onlyOwner{
392         _baseURI = _base;
393     }
394 
395     function setConfig(uint256 _MAX_FREE, uint256 _MAX_FREE_PER_WALLET, uint256 _COST) external onlyOwner{
396         MAX_FREE = _MAX_FREE;
397         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
398         COST = _COST;
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
425             return _currentIndex - _startTokenId();
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
440 
441     /**
442      * @dev See {IERC165-supportsInterface}.
443      */
444     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
445         // The interface IDs are constants representing the first 4 bytes of the XOR of
446         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
447         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
448         return
449             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
450             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
451             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
452     }
453 
454     /**
455      * @dev See {IERC721-balanceOf}.
456      */
457     function balanceOf(address owner) public view override returns (uint256) {
458         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
459         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
460     }
461 
462     /**
463      * Returns the number of tokens minted by `owner`.
464      */
465     function _numberMinted(address owner) internal view returns (uint256) {
466         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
467     }
468 
469 
470 
471     /**
472      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
473      */
474     function _getAux(address owner) internal view returns (uint64) {
475         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
476     }
477 
478     /**
479      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
480      * If there are multiple variables, please pack them into a uint64.
481      */
482     function _setAux(address owner, uint64 aux) internal {
483         uint256 packed = _packedAddressData[owner];
484         uint256 auxCasted;
485         assembly { // Cast aux without masking.
486             auxCasted := aux
487         }
488         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
489         _packedAddressData[owner] = packed;
490     }
491 
492     /**
493      * Returns the packed ownership data of `tokenId`.
494      */
495     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
496         uint256 curr = tokenId;
497 
498         unchecked {
499             if (_startTokenId() <= curr)
500                 if (curr < _currentIndex) {
501                     uint256 packed = _packedOwnerships[curr];
502                     // If not burned.
503                     if (packed & BITMASK_BURNED == 0) {
504                         // Invariant:
505                         // There will always be an ownership that has an address and is not burned
506                         // before an ownership that does not have an address and is not burned.
507                         // Hence, curr will not underflow.
508                         //
509                         // We can directly compare the packed value.
510                         // If the address is zero, packed is zero.
511                         while (packed == 0) {
512                             packed = _packedOwnerships[--curr];
513                         }
514                         return packed;
515                     }
516                 }
517         }
518         revert OwnerQueryForNonexistentToken();
519     }
520 
521     /**
522      * Returns the unpacked `TokenOwnership` struct from `packed`.
523      */
524     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
525         ownership.addr = address(uint160(packed));
526         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
527         ownership.burned = packed & BITMASK_BURNED != 0;
528     }
529 
530     /**
531      * Returns the unpacked `TokenOwnership` struct at `index`.
532      */
533     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
534         return _unpackedOwnership(_packedOwnerships[index]);
535     }
536 
537     /**
538      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
539      */
540     function _initializeOwnershipAt(uint256 index) internal {
541         if (_packedOwnerships[index] == 0) {
542             _packedOwnerships[index] = _packedOwnershipOf(index);
543         }
544     }
545 
546     /**
547      * Gas spent here starts off proportional to the maximum mint batch size.
548      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
549      */
550     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
551         return _unpackedOwnership(_packedOwnershipOf(tokenId));
552     }
553 
554     /**
555      * @dev See {IERC721-ownerOf}.
556      */
557     function ownerOf(uint256 tokenId) public view override returns (address) {
558         return address(uint160(_packedOwnershipOf(tokenId)));
559     }
560 
561     /**
562      * @dev See {IERC721Metadata-name}.
563      */
564     function name() public view virtual override returns (string memory) {
565         return _name;
566     }
567 
568     /**
569      * @dev See {IERC721Metadata-symbol}.
570      */
571     function symbol() public view virtual override returns (string memory) {
572         return _symbol;
573     }
574 
575     
576     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
577         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
578         string memory baseURI = _baseURI;
579         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
580     }
581 
582     /*
583     function contractURI() public view returns (string memory) {
584         return string(abi.encodePacked("ipfs://", _contractURI));
585     }
586     */
587 
588     /**
589      * @dev Casts the address to uint256 without masking.
590      */
591     function _addressToUint256(address value) private pure returns (uint256 result) {
592         assembly {
593             result := value
594         }
595     }
596 
597     /**
598      * @dev Casts the boolean to uint256 without branching.
599      */
600     function _boolToUint256(bool value) private pure returns (uint256 result) {
601         assembly {
602             result := value
603         }
604     }
605 
606     /**
607      * @dev See {IERC721-approve}.
608      */
609     function approve(address to, uint256 tokenId) public override {
610         address owner = address(uint160(_packedOwnershipOf(tokenId)));
611         if (to == owner) revert();
612 
613         if (_msgSenderERC721A() != owner)
614             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
615                 revert ApprovalCallerNotOwnerNorApproved();
616             }
617 
618         _tokenApprovals[tokenId] = to;
619         emit Approval(owner, to, tokenId);
620     }
621 
622     /**
623      * @dev See {IERC721-getApproved}.
624      */
625     function getApproved(uint256 tokenId) public view override returns (address) {
626         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
627 
628         return _tokenApprovals[tokenId];
629     }
630 
631     /**
632      * @dev See {IERC721-setApprovalForAll}.
633      */
634     function setApprovalForAll(address operator, bool approved) public virtual override {
635         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
636 
637         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
638         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
639     }
640 
641     /**
642      * @dev See {IERC721-isApprovedForAll}.
643      */
644     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
645         return _operatorApprovals[owner][operator];
646     }
647 
648     /**
649      * @dev See {IERC721-transferFrom}.
650      */
651     function transferFrom(
652             address from,
653             address to,
654             uint256 tokenId
655             ) public virtual override {
656         _transfer(from, to, tokenId);
657     }
658 
659     /**
660      * @dev See {IERC721-safeTransferFrom}.
661      */
662     function safeTransferFrom(
663             address from,
664             address to,
665             uint256 tokenId
666             ) public virtual override {
667         safeTransferFrom(from, to, tokenId, '');
668     }
669 
670     /**
671      * @dev See {IERC721-safeTransferFrom}.
672      */
673     function safeTransferFrom(
674             address from,
675             address to,
676             uint256 tokenId,
677             bytes memory _data
678             ) public virtual override {
679         _transfer(from, to, tokenId);
680     }
681 
682     /**
683      * @dev Returns whether `tokenId` exists.
684      *
685      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
686      *
687      * Tokens start existing when they are minted (`_mint`),
688      */
689     function _exists(uint256 tokenId) internal view returns (bool) {
690         return
691             _startTokenId() <= tokenId &&
692             tokenId < _currentIndex;
693     }
694 
695     /**
696      * @dev Equivalent to `_safeMint(to, quantity, '')`.
697      */
698      /*
699     function _safeMint(address to, uint256 quantity) internal {
700         _safeMint(to, quantity, '');
701     }
702     */
703 
704     /**
705      * @dev Safely mints `quantity` tokens and transfers them to `to`.
706      *
707      * Requirements:
708      *
709      * - If `to` refers to a smart contract, it must implement
710      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
711      * - `quantity` must be greater than 0.
712      *
713      * Emits a {Transfer} event.
714      */
715      /*
716     function _safeMint(
717             address to,
718             uint256 quantity,
719             bytes memory _data
720             ) internal {
721         uint256 startTokenId = _currentIndex;
722         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
723         if (quantity == 0) revert MintZeroQuantity();
724 
725 
726         // Overflows are incredibly unrealistic.
727         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
728         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
729         unchecked {
730             // Updates:
731             // - `balance += quantity`.
732             // - `numberMinted += quantity`.
733             //
734             // We can directly add to the balance and number minted.
735             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
736 
737             // Updates:
738             // - `address` to the owner.
739             // - `startTimestamp` to the timestamp of minting.
740             // - `burned` to `false`.
741             // - `nextInitialized` to `quantity == 1`.
742             _packedOwnerships[startTokenId] =
743                 _addressToUint256(to) |
744                 (block.timestamp << BITPOS_START_TIMESTAMP) |
745                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
746 
747             uint256 updatedIndex = startTokenId;
748             uint256 end = updatedIndex + quantity;
749 
750             if (to.code.length != 0) {
751                 do {
752                     emit Transfer(address(0), to, updatedIndex);
753                 } while (updatedIndex < end);
754                 // Reentrancy protection
755                 if (_currentIndex != startTokenId) revert();
756             } else {
757                 do {
758                     emit Transfer(address(0), to, updatedIndex++);
759                 } while (updatedIndex < end);
760             }
761             _currentIndex = updatedIndex;
762         }
763         _afterTokenTransfers(address(0), to, startTokenId, quantity);
764     }
765     */
766 
767     /**
768      * @dev Mints `quantity` tokens and transfers them to `to`.
769      *
770      * Requirements:
771      *
772      * - `to` cannot be the zero address.
773      * - `quantity` must be greater than 0.
774      *
775      * Emits a {Transfer} event.
776      */
777     function _mint(address to, uint256 quantity) internal {
778         uint256 startTokenId = _currentIndex;
779         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
780         if (quantity == 0) revert MintZeroQuantity();
781 
782 
783         // Overflows are incredibly unrealistic.
784         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
785         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
786         unchecked {
787             // Updates:
788             // - `balance += quantity`.
789             // - `numberMinted += quantity`.
790             //
791             // We can directly add to the balance and number minted.
792             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
793 
794             // Updates:
795             // - `address` to the owner.
796             // - `startTimestamp` to the timestamp of minting.
797             // - `burned` to `false`.
798             // - `nextInitialized` to `quantity == 1`.
799             _packedOwnerships[startTokenId] =
800                 _addressToUint256(to) |
801                 (block.timestamp << BITPOS_START_TIMESTAMP) |
802                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
803 
804             uint256 updatedIndex = startTokenId;
805             uint256 end = updatedIndex + quantity;
806 
807             do {
808                 emit Transfer(address(0), to, updatedIndex++);
809             } while (updatedIndex < end);
810 
811             _currentIndex = updatedIndex;
812         }
813         _afterTokenTransfers(address(0), to, startTokenId, quantity);
814     }
815 
816     /**
817      * @dev Transfers `tokenId` from `from` to `to`.
818      *
819      * Requirements:
820      *
821      * - `to` cannot be the zero address.
822      * - `tokenId` token must be owned by `from`.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _transfer(
827             address from,
828             address to,
829             uint256 tokenId
830             ) private {
831 
832         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
833 
834         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
835 
836         address approvedAddress = _tokenApprovals[tokenId];
837 
838         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
839                 isApprovedForAll(from, _msgSenderERC721A()) ||
840                 approvedAddress == _msgSenderERC721A());
841 
842         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
843 
844         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
845 
846 
847         // Clear approvals from the previous owner.
848         if (_addressToUint256(approvedAddress) != 0) {
849             delete _tokenApprovals[tokenId];
850         }
851 
852         // Underflow of the sender's balance is impossible because we check for
853         // ownership above and the recipient's balance can't realistically overflow.
854         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
855         unchecked {
856             // We can directly increment and decrement the balances.
857             --_packedAddressData[from]; // Updates: `balance -= 1`.
858             ++_packedAddressData[to]; // Updates: `balance += 1`.
859 
860             // Updates:
861             // - `address` to the next owner.
862             // - `startTimestamp` to the timestamp of transfering.
863             // - `burned` to `false`.
864             // - `nextInitialized` to `true`.
865             _packedOwnerships[tokenId] =
866                 _addressToUint256(to) |
867                 (block.timestamp << BITPOS_START_TIMESTAMP) |
868                 BITMASK_NEXT_INITIALIZED;
869 
870             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
871             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
872                 uint256 nextTokenId = tokenId + 1;
873                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
874                 if (_packedOwnerships[nextTokenId] == 0) {
875                     // If the next slot is within bounds.
876                     if (nextTokenId != _currentIndex) {
877                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
878                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
879                     }
880                 }
881             }
882         }
883 
884         emit Transfer(from, to, tokenId);
885         _afterTokenTransfers(from, to, tokenId, 1);
886     }
887 
888 
889 
890 
891     /**
892      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
893      * minting.
894      * And also called after one token has been burned.
895      *
896      * startTokenId - the first token id to be transferred
897      * quantity - the amount to be transferred
898      *
899      * Calling conditions:
900      *
901      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
902      * transferred to `to`.
903      * - When `from` is zero, `tokenId` has been minted for `to`.
904      * - When `to` is zero, `tokenId` has been burned by `from`.
905      * - `from` and `to` are never both zero.
906      */
907     function _afterTokenTransfers(
908             address from,
909             address to,
910             uint256 startTokenId,
911             uint256 quantity
912             ) internal virtual {}
913 
914     /**
915      * @dev Returns the message sender (defaults to `msg.sender`).
916      *
917      * If you are writing GSN compatible contracts, you need to override this function.
918      */
919     function _msgSenderERC721A() internal view virtual returns (address) {
920         return msg.sender;
921     }
922 
923     /**
924      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
925      */
926     function _toString(uint256 value) internal pure returns (string memory ptr) {
927         assembly {
928             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
929             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
930             // We will need 1 32-byte word to store the length, 
931             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
932             ptr := add(mload(0x40), 128)
933 
934          // Update the free memory pointer to allocate.
935          mstore(0x40, ptr)
936 
937          // Cache the end of the memory to calculate the length later.
938          let end := ptr
939 
940          // We write the string from the rightmost digit to the leftmost digit.
941          // The following is essentially a do-while loop that also handles the zero case.
942          // Costs a bit more than early returning for the zero case,
943          // but cheaper in terms of deployment and overall runtime costs.
944          for { 
945              // Initialize and perform the first pass without check.
946              let temp := value
947                  // Move the pointer 1 byte leftwards to point to an empty character slot.
948                  ptr := sub(ptr, 1)
949                  // Write the character to the pointer. 48 is the ASCII index of '0'.
950                  mstore8(ptr, add(48, mod(temp, 10)))
951                  temp := div(temp, 10)
952          } temp { 
953              // Keep dividing `temp` until zero.
954         temp := div(temp, 10)
955          } { 
956              // Body of the for loop.
957         ptr := sub(ptr, 1)
958          mstore8(ptr, add(48, mod(temp, 10)))
959          }
960 
961      let length := sub(end, ptr)
962          // Move the pointer 32 bytes leftwards to make room for the length.
963          ptr := sub(ptr, 32)
964          // Store the length.
965          mstore(ptr, length)
966         }
967     }
968 
969     function withdraw() external onlyOwner {
970         uint256 balance = address(this).balance;
971         payable(msg.sender).transfer(balance);
972     }
973 }