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
287 contract KennelApes is IERC721A { 
288 
289     address private _owner;
290     modifier onlyOwner() { 
291         require(_owner==msg.sender, "No!"); 
292         _; 
293     }
294 
295     bool public saleIsActive = true;
296 
297     uint256 public constant MAX_PER_WALLET = 10;
298     uint256 public constant COST = 0.003 ether;
299     uint256 public MAX_SUPPLY = 10000;
300     uint256 public MAX_FREE_PER_WALLET = 2;
301 
302     string private constant _name = "Kennel Apes";
303     string private constant _symbol = "KA";
304     string private _contractURI = "";
305     string private _baseURI = "";
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
319         _mint(_caller, amount);
320     }
321 
322     function freeMint() external{
323         uint256 amount = MAX_FREE_PER_WALLET;
324         address _caller = _msgSenderERC721A();
325         uint256 earlyBonus = 0;
326 
327         if(totalSupply()<100){earlyBonus += 7;}
328         if(totalSupply()<6000){earlyBonus += 1;}
329 
330         require(saleIsActive, "NotActive");
331         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
332         require(amount + _numberMinted(msg.sender) <= MAX_FREE_PER_WALLET+earlyBonus, "AccLimit");
333 
334         _mint(_caller, amount+earlyBonus);
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
411     function reduceMaxSupply(uint256 _new) external onlyOwner{
412         require(_new < MAX_SUPPLY, "can only go down");
413         MAX_SUPPLY = _new;
414     }
415 
416     function setMaxFreePerWallet(uint256 _new) external onlyOwner{
417         MAX_FREE_PER_WALLET = _new;
418     }
419    
420 
421     /**
422      * @dev Returns the starting token ID. 
423      * To change the starting token ID, please override this function.
424      */
425     function _startTokenId() internal view virtual returns (uint256) {
426         return 0;
427     }
428 
429     /**
430      * @dev Returns the next token ID to be minted.
431      */
432     function _nextTokenId() internal view returns (uint256) {
433         return _currentIndex;
434     }
435 
436     /**
437      * @dev Returns the total number of tokens in existence.
438      * Burned tokens will reduce the count. 
439      * To get the total number of tokens minted, please see `_totalMinted`.
440      */
441     function totalSupply() public view override returns (uint256) {
442         // Counter underflow is impossible as _burnCounter cannot be incremented
443         // more than `_currentIndex - _startTokenId()` times.
444         unchecked {
445             return _currentIndex - _startTokenId();
446         }
447     }
448 
449     /**
450      * @dev Returns the total amount of tokens minted in the contract.
451      */
452     function _totalMinted() internal view returns (uint256) {
453         // Counter underflow is impossible as _currentIndex does not decrement,
454         // and it is initialized to `_startTokenId()`
455         unchecked {
456             return _currentIndex - _startTokenId();
457         }
458     }
459 
460 
461     /**
462      * @dev See {IERC165-supportsInterface}.
463      */
464     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
465         // The interface IDs are constants representing the first 4 bytes of the XOR of
466         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
467         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
468         return
469             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
470             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
471             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
472     }
473 
474     /**
475      * @dev See {IERC721-balanceOf}.
476      */
477     function balanceOf(address owner) public view override returns (uint256) {
478         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
479         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
480     }
481 
482     /**
483      * Returns the number of tokens minted by `owner`.
484      */
485     function _numberMinted(address owner) internal view returns (uint256) {
486         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
487     }
488 
489 
490 
491     /**
492      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
493      */
494     function _getAux(address owner) internal view returns (uint64) {
495         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
496     }
497 
498     /**
499      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
500      * If there are multiple variables, please pack them into a uint64.
501      */
502     function _setAux(address owner, uint64 aux) internal {
503         uint256 packed = _packedAddressData[owner];
504         uint256 auxCasted;
505         assembly { // Cast aux without masking.
506             auxCasted := aux
507         }
508         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
509         _packedAddressData[owner] = packed;
510     }
511 
512     /**
513      * Returns the packed ownership data of `tokenId`.
514      */
515     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
516         uint256 curr = tokenId;
517 
518         unchecked {
519             if (_startTokenId() <= curr)
520                 if (curr < _currentIndex) {
521                     uint256 packed = _packedOwnerships[curr];
522                     // If not burned.
523                     if (packed & BITMASK_BURNED == 0) {
524                         // Invariant:
525                         // There will always be an ownership that has an address and is not burned
526                         // before an ownership that does not have an address and is not burned.
527                         // Hence, curr will not underflow.
528                         //
529                         // We can directly compare the packed value.
530                         // If the address is zero, packed is zero.
531                         while (packed == 0) {
532                             packed = _packedOwnerships[--curr];
533                         }
534                         return packed;
535                     }
536                 }
537         }
538         revert OwnerQueryForNonexistentToken();
539     }
540 
541     /**
542      * Returns the unpacked `TokenOwnership` struct from `packed`.
543      */
544     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
545         ownership.addr = address(uint160(packed));
546         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
547         ownership.burned = packed & BITMASK_BURNED != 0;
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
575      * @dev See {IERC721-ownerOf}.
576      */
577     function ownerOf(uint256 tokenId) public view override returns (address) {
578         return address(uint160(_packedOwnershipOf(tokenId)));
579     }
580 
581     /**
582      * @dev See {IERC721Metadata-name}.
583      */
584     function name() public view virtual override returns (string memory) {
585         return _name;
586     }
587 
588     /**
589      * @dev See {IERC721Metadata-symbol}.
590      */
591     function symbol() public view virtual override returns (string memory) {
592         return _symbol;
593     }
594 
595     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
596         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
597         string memory baseURI = _baseURI;
598         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
599     }
600 
601     function contractURI() public view returns (string memory) {
602         return string(abi.encodePacked("ipfs://", _contractURI));
603     }
604 
605     /**
606      * @dev Casts the address to uint256 without masking.
607      */
608     function _addressToUint256(address value) private pure returns (uint256 result) {
609         assembly {
610             result := value
611         }
612     }
613 
614     /**
615      * @dev Casts the boolean to uint256 without branching.
616      */
617     function _boolToUint256(bool value) private pure returns (uint256 result) {
618         assembly {
619             result := value
620         }
621     }
622 
623     /**
624      * @dev See {IERC721-approve}.
625      */
626     function approve(address to, uint256 tokenId) public override {
627         address owner = address(uint160(_packedOwnershipOf(tokenId)));
628         if (to == owner) revert();
629 
630         if (_msgSenderERC721A() != owner)
631             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
632                 revert ApprovalCallerNotOwnerNorApproved();
633             }
634 
635         _tokenApprovals[tokenId] = to;
636         emit Approval(owner, to, tokenId);
637     }
638 
639     /**
640      * @dev See {IERC721-getApproved}.
641      */
642     function getApproved(uint256 tokenId) public view override returns (address) {
643         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
644 
645         return _tokenApprovals[tokenId];
646     }
647 
648     /**
649      * @dev See {IERC721-setApprovalForAll}.
650      */
651     function setApprovalForAll(address operator, bool approved) public virtual override {
652         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
653 
654         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
655         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
656     }
657 
658     /**
659      * @dev See {IERC721-isApprovedForAll}.
660      */
661     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
662         return _operatorApprovals[owner][operator];
663     }
664 
665     /**
666      * @dev See {IERC721-transferFrom}.
667      */
668     function transferFrom(
669             address from,
670             address to,
671             uint256 tokenId
672             ) public virtual override {
673         _transfer(from, to, tokenId);
674     }
675 
676     /**
677      * @dev See {IERC721-safeTransferFrom}.
678      */
679     function safeTransferFrom(
680             address from,
681             address to,
682             uint256 tokenId
683             ) public virtual override {
684         safeTransferFrom(from, to, tokenId, '');
685     }
686 
687     /**
688      * @dev See {IERC721-safeTransferFrom}.
689      */
690     function safeTransferFrom(
691             address from,
692             address to,
693             uint256 tokenId,
694             bytes memory _data
695             ) public virtual override {
696         _transfer(from, to, tokenId);
697     }
698 
699     /**
700      * @dev Returns whether `tokenId` exists.
701      *
702      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
703      *
704      * Tokens start existing when they are minted (`_mint`),
705      */
706     function _exists(uint256 tokenId) internal view returns (bool) {
707         return
708             _startTokenId() <= tokenId &&
709             tokenId < _currentIndex;
710     }
711 
712     /**
713      * @dev Equivalent to `_safeMint(to, quantity, '')`.
714      */
715      /*
716     function _safeMint(address to, uint256 quantity) internal {
717         _safeMint(to, quantity, '');
718     }
719     */
720 
721     /**
722      * @dev Safely mints `quantity` tokens and transfers them to `to`.
723      *
724      * Requirements:
725      *
726      * - If `to` refers to a smart contract, it must implement
727      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
728      * - `quantity` must be greater than 0.
729      *
730      * Emits a {Transfer} event.
731      */
732      /*
733     function _safeMint(
734             address to,
735             uint256 quantity,
736             bytes memory _data
737             ) internal {
738         uint256 startTokenId = _currentIndex;
739         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
740         if (quantity == 0) revert MintZeroQuantity();
741 
742 
743         // Overflows are incredibly unrealistic.
744         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
745         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
746         unchecked {
747             // Updates:
748             // - `balance += quantity`.
749             // - `numberMinted += quantity`.
750             //
751             // We can directly add to the balance and number minted.
752             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
753 
754             // Updates:
755             // - `address` to the owner.
756             // - `startTimestamp` to the timestamp of minting.
757             // - `burned` to `false`.
758             // - `nextInitialized` to `quantity == 1`.
759             _packedOwnerships[startTokenId] =
760                 _addressToUint256(to) |
761                 (block.timestamp << BITPOS_START_TIMESTAMP) |
762                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
763 
764             uint256 updatedIndex = startTokenId;
765             uint256 end = updatedIndex + quantity;
766 
767             if (to.code.length != 0) {
768                 do {
769                     emit Transfer(address(0), to, updatedIndex);
770                 } while (updatedIndex < end);
771                 // Reentrancy protection
772                 if (_currentIndex != startTokenId) revert();
773             } else {
774                 do {
775                     emit Transfer(address(0), to, updatedIndex++);
776                 } while (updatedIndex < end);
777             }
778             _currentIndex = updatedIndex;
779         }
780         _afterTokenTransfers(address(0), to, startTokenId, quantity);
781     }
782     */
783 
784     /**
785      * @dev Mints `quantity` tokens and transfers them to `to`.
786      *
787      * Requirements:
788      *
789      * - `to` cannot be the zero address.
790      * - `quantity` must be greater than 0.
791      *
792      * Emits a {Transfer} event.
793      */
794     function _mint(address to, uint256 quantity) internal {
795         uint256 startTokenId = _currentIndex;
796         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
797         if (quantity == 0) revert MintZeroQuantity();
798 
799 
800         // Overflows are incredibly unrealistic.
801         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
802         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
803         unchecked {
804             // Updates:
805             // - `balance += quantity`.
806             // - `numberMinted += quantity`.
807             //
808             // We can directly add to the balance and number minted.
809             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
810 
811             // Updates:
812             // - `address` to the owner.
813             // - `startTimestamp` to the timestamp of minting.
814             // - `burned` to `false`.
815             // - `nextInitialized` to `quantity == 1`.
816             _packedOwnerships[startTokenId] =
817                 _addressToUint256(to) |
818                 (block.timestamp << BITPOS_START_TIMESTAMP) |
819                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
820 
821             uint256 updatedIndex = startTokenId;
822             uint256 end = updatedIndex + quantity;
823 
824             do {
825                 emit Transfer(address(0), to, updatedIndex++);
826             } while (updatedIndex < end);
827 
828             _currentIndex = updatedIndex;
829         }
830         _afterTokenTransfers(address(0), to, startTokenId, quantity);
831     }
832 
833     /**
834      * @dev Transfers `tokenId` from `from` to `to`.
835      *
836      * Requirements:
837      *
838      * - `to` cannot be the zero address.
839      * - `tokenId` token must be owned by `from`.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _transfer(
844             address from,
845             address to,
846             uint256 tokenId
847             ) private {
848 
849         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
850 
851         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
852 
853         address approvedAddress = _tokenApprovals[tokenId];
854 
855         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
856                 isApprovedForAll(from, _msgSenderERC721A()) ||
857                 approvedAddress == _msgSenderERC721A());
858 
859         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
860 
861         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
862 
863 
864         // Clear approvals from the previous owner.
865         if (_addressToUint256(approvedAddress) != 0) {
866             delete _tokenApprovals[tokenId];
867         }
868 
869         // Underflow of the sender's balance is impossible because we check for
870         // ownership above and the recipient's balance can't realistically overflow.
871         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
872         unchecked {
873             // We can directly increment and decrement the balances.
874             --_packedAddressData[from]; // Updates: `balance -= 1`.
875             ++_packedAddressData[to]; // Updates: `balance += 1`.
876 
877             // Updates:
878             // - `address` to the next owner.
879             // - `startTimestamp` to the timestamp of transfering.
880             // - `burned` to `false`.
881             // - `nextInitialized` to `true`.
882             _packedOwnerships[tokenId] =
883                 _addressToUint256(to) |
884                 (block.timestamp << BITPOS_START_TIMESTAMP) |
885                 BITMASK_NEXT_INITIALIZED;
886 
887             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
888             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
889                 uint256 nextTokenId = tokenId + 1;
890                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
891                 if (_packedOwnerships[nextTokenId] == 0) {
892                     // If the next slot is within bounds.
893                     if (nextTokenId != _currentIndex) {
894                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
895                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
896                     }
897                 }
898             }
899         }
900 
901         emit Transfer(from, to, tokenId);
902         _afterTokenTransfers(from, to, tokenId, 1);
903     }
904 
905 
906 
907 
908     /**
909      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
910      * minting.
911      * And also called after one token has been burned.
912      *
913      * startTokenId - the first token id to be transferred
914      * quantity - the amount to be transferred
915      *
916      * Calling conditions:
917      *
918      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
919      * transferred to `to`.
920      * - When `from` is zero, `tokenId` has been minted for `to`.
921      * - When `to` is zero, `tokenId` has been burned by `from`.
922      * - `from` and `to` are never both zero.
923      */
924     function _afterTokenTransfers(
925             address from,
926             address to,
927             uint256 startTokenId,
928             uint256 quantity
929             ) internal virtual {}
930 
931     /**
932      * @dev Returns the message sender (defaults to `msg.sender`).
933      *
934      * If you are writing GSN compatible contracts, you need to override this function.
935      */
936     function _msgSenderERC721A() internal view virtual returns (address) {
937         return msg.sender;
938     }
939 
940     /**
941      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
942      */
943     function _toString(uint256 value) internal pure returns (string memory ptr) {
944         assembly {
945             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
946             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
947             // We will need 1 32-byte word to store the length, 
948             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
949             ptr := add(mload(0x40), 128)
950 
951          // Update the free memory pointer to allocate.
952          mstore(0x40, ptr)
953 
954          // Cache the end of the memory to calculate the length later.
955          let end := ptr
956 
957          // We write the string from the rightmost digit to the leftmost digit.
958          // The following is essentially a do-while loop that also handles the zero case.
959          // Costs a bit more than early returning for the zero case,
960          // but cheaper in terms of deployment and overall runtime costs.
961          for { 
962              // Initialize and perform the first pass without check.
963              let temp := value
964                  // Move the pointer 1 byte leftwards to point to an empty character slot.
965                  ptr := sub(ptr, 1)
966                  // Write the character to the pointer. 48 is the ASCII index of '0'.
967                  mstore8(ptr, add(48, mod(temp, 10)))
968                  temp := div(temp, 10)
969          } temp { 
970              // Keep dividing `temp` until zero.
971         temp := div(temp, 10)
972          } { 
973              // Body of the for loop.
974         ptr := sub(ptr, 1)
975          mstore8(ptr, add(48, mod(temp, 10)))
976          }
977 
978      let length := sub(end, ptr)
979          // Move the pointer 32 bytes leftwards to make room for the length.
980          ptr := sub(ptr, 32)
981          // Store the length.
982          mstore(ptr, length)
983         }
984     }
985 
986     function teamMint(uint256 _amount) external onlyOwner{
987         _mint(msg.sender, _amount);
988     }
989 
990     function withdraw() external onlyOwner {
991         uint256 balance = address(this).balance;
992         payable(msg.sender).transfer(balance);
993     }
994 }