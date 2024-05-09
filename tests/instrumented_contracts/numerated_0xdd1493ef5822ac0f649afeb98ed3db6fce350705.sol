1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
3 
4 /*
5 
6     O or o
7                                                                  
8 */
9 
10 
11 //import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol";
12 
13 
14 /**
15  * @dev Interface of ERC721A.
16  */
17 interface IERC721A {
18     /**
19      * The caller must own the token or be an approved operator.
20      */
21     error ApprovalCallerNotOwnerNorApproved();
22 
23     /**
24      * The token does not exist.
25      */
26     error ApprovalQueryForNonexistentToken();
27 
28     /**
29      * The caller cannot approve to their own address.
30      */
31     error ApproveToCaller();
32 
33     /**
34      * Cannot query the balance for the zero address.
35      */
36     error BalanceQueryForZeroAddress();
37 
38     /**
39      * Cannot mint to the zero address.
40      */
41     error MintToZeroAddress();
42 
43     /**
44      * The quantity of tokens minted must be more than zero.
45      */
46     error MintZeroQuantity();
47 
48     /**
49      * The token does not exist.
50      */
51     error OwnerQueryForNonexistentToken();
52 
53     /**
54      * The caller must own the token or be an approved operator.
55      */
56     error TransferCallerNotOwnerNorApproved();
57 
58     /**
59      * The token must be owned by `from`.
60      */
61     error TransferFromIncorrectOwner();
62 
63     /**
64      * Cannot safely transfer to a contract that does not implement the
65      * ERC721Receiver interface.
66      */
67     error TransferToNonERC721ReceiverImplementer();
68 
69     /**
70      * Cannot transfer to the zero address.
71      */
72     error TransferToZeroAddress();
73 
74     /**
75      * The token does not exist.
76      */
77     error URIQueryForNonexistentToken();
78 
79     /**
80      * The `quantity` minted with ERC2309 exceeds the safety limit.
81      */
82     error MintERC2309QuantityExceedsLimit();
83 
84     /**
85      * The `extraData` cannot be set on an unintialized ownership slot.
86      */
87     error OwnershipNotInitializedForExtraData();
88 
89     // =============================================================
90     //                            STRUCTS
91     // =============================================================
92 
93     struct TokenOwnership {
94         // The address of the owner.
95         address addr;
96         // Stores the start time of ownership with minimal overhead for tokenomics.
97         uint64 startTimestamp;
98         // Whether the token has been burned.
99         bool burned;
100         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
101         uint24 extraData;
102     }
103 
104     // =============================================================
105     //                         TOKEN COUNTERS
106     // =============================================================
107 
108     /**
109      * @dev Returns the total number of tokens in existence.
110      * Burned tokens will reduce the count.
111      * To get the total number of tokens minted, please see {_totalMinted}.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     // =============================================================
116     //                            IERC165
117     // =============================================================
118 
119     /**
120      * @dev Returns true if this contract implements the interface defined by
121      * `interfaceId`. See the corresponding
122      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
123      * to learn more about how these ids are created.
124      *
125      * This function call must use less than 30000 gas.
126      */
127     function supportsInterface(bytes4 interfaceId) external view returns (bool);
128 
129     // =============================================================
130     //                            IERC721
131     // =============================================================
132 
133     /**
134      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
140      */
141     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables or disables
145      * (`approved`) `operator` to manage all of its assets.
146      */
147     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
148 
149     /**
150      * @dev Returns the number of tokens in `owner`'s account.
151      */
152     function balanceOf(address owner) external view returns (uint256 balance);
153 
154     /**
155      * @dev Returns the owner of the `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function ownerOf(uint256 tokenId) external view returns (address owner);
162 
163     /**
164      * @dev Safely transfers `tokenId` token from `from` to `to`,
165      * checking first that contract recipients are aware of the ERC721 protocol
166      * to prevent tokens from being forever locked.
167      *
168      * Requirements:
169      *
170      * - `from` cannot be the zero address.
171      * - `to` cannot be the zero address.
172      * - `tokenId` token must exist and be owned by `from`.
173      * - If the caller is not `from`, it must be have been allowed to move
174      * this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement
176      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177      *
178      * Emits a {Transfer} event.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId,
184         bytes calldata data
185     ) external;
186 
187     /**
188      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Transfers `tokenId` from `from` to `to`.
198      *
199      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
200      * whenever possible.
201      *
202      * Requirements:
203      *
204      * - `from` cannot be the zero address.
205      * - `to` cannot be the zero address.
206      * - `tokenId` token must be owned by `from`.
207      * - If the caller is not `from`, it must be approved to move this token
208      * by either {approve} or {setApprovalForAll}.
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
222      * Only a single account can be approved at a time, so approving the
223      * zero address clears previous approvals.
224      *
225      * Requirements:
226      *
227      * - The caller must own the token or be an approved operator.
228      * - `tokenId` must exist.
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address to, uint256 tokenId) external;
233 
234     /**
235      * @dev Approve or remove `operator` as an operator for the caller.
236      * Operators can call {transferFrom} or {safeTransferFrom}
237      * for any token owned by the caller.
238      *
239      * Requirements:
240      *
241      * - The `operator` cannot be the caller.
242      *
243      * Emits an {ApprovalForAll} event.
244      */
245     function setApprovalForAll(address operator, bool _approved) external;
246 
247     /**
248      * @dev Returns the account approved for `tokenId` token.
249      *
250      * Requirements:
251      *
252      * - `tokenId` must exist.
253      */
254     function getApproved(uint256 tokenId) external view returns (address operator);
255 
256     /**
257      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
258      *
259      * See {setApprovalForAll}.
260      */
261     function isApprovedForAll(address owner, address operator) external view returns (bool);
262 
263     // =============================================================
264     //                        IERC721Metadata
265     // =============================================================
266 
267     /**
268      * @dev Returns the token collection name.
269      */
270     function name() external view returns (string memory);
271 
272     /**
273      * @dev Returns the token collection symbol.
274      */
275     function symbol() external view returns (string memory);
276 
277     /**
278      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
279      */
280     function tokenURI(uint256 tokenId) external view returns (string memory);
281 
282     // =============================================================
283     //                           IERC2309
284     // =============================================================
285 
286     /**
287      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
288      * (inclusive) is transferred from `from` to `to`, as defined in the
289      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
290      *
291      * See {_mintERC2309} for more details.
292      */
293     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
294 }
295 
296 contract RuggedOrNugged is IERC721A { 
297 
298     address private _owner;
299     modifier onlyOwner() { 
300         require(_owner==msg.sender, "No!"); 
301         _; 
302     }
303 
304     bool public saleIsActive = true;
305     uint256 public constant MAX_SUPPLY = 666;
306     uint256 public constant MAX_PER_WALLET = 66;
307     uint256 public constant MAX_FREE_PER_WALLET = 1;
308     uint256 public constant COST = 0.00666 ether;
309 
310     string private constant _name = "RuggedOrNugged (666)";
311     string private constant _symbol = "RUGNUG";
312     string private _contractURI = "QmYgyEnbqXvkzPH17vEkknRqsUiQCo4ghrTtfgqRUKTDBx";
313     string private _baseURI = "QmTTxQV5nye9oPYMeJf9QNFnuyfwCtD1YuLautNKJAN94n";
314 
315     constructor() {
316         _owner = msg.sender;
317     }
318 
319     function mint(uint256 _amount) external payable{
320         address _caller = _msgSenderERC721A();
321 
322         require(saleIsActive, "NotActive");
323         require(totalSupply() + _amount <= MAX_SUPPLY, "SoldOut");
324         require(_amount + _numberMinted(msg.sender) <= MAX_PER_WALLET, "AccLimit");
325         require(msg.value >= _amount*COST, "More");
326         
327         _safeMint(_caller, _amount);
328     }
329 
330     function freeMint() external{
331         uint256 amount = MAX_FREE_PER_WALLET;
332         address _caller = _msgSenderERC721A();
333 
334         require(saleIsActive, "NotActive");
335         require(totalSupply() + amount <= (MAX_SUPPLY-55), "SoldOut");
336         require(amount + _numberMinted(msg.sender) <= MAX_FREE_PER_WALLET, "AccLimit");
337 
338         _safeMint(_caller, amount);
339     }
340 
341 
342     // Mask of an entry in packed address data.
343     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
344 
345     // The bit position of `numberMinted` in packed address data.
346     uint256 private constant BITPOS_NUMBER_MINTED = 64;
347 
348     // The bit position of `numberBurned` in packed address data.
349     uint256 private constant BITPOS_NUMBER_BURNED = 128;
350 
351     // The bit position of `aux` in packed address data.
352     uint256 private constant BITPOS_AUX = 192;
353 
354     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
355     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
356 
357     // The bit position of `startTimestamp` in packed ownership.
358     uint256 private constant BITPOS_START_TIMESTAMP = 160;
359 
360     // The bit mask of the `burned` bit in packed ownership.
361     uint256 private constant BITMASK_BURNED = 1 << 224;
362 
363     // The bit position of the `nextInitialized` bit in packed ownership.
364     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
365 
366     // The bit mask of the `nextInitialized` bit in packed ownership.
367     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
368 
369     // The tokenId of the next token to be minted.
370     uint256 private _currentIndex = 0;
371 
372     // The number of tokens burned.
373     // uint256 private _burnCounter;
374 
375 
376     // Mapping from token ID to ownership details
377     // An empty struct value does not necessarily mean the token is unowned.
378     // See `_packedOwnershipOf` implementation for details.
379     //
380     // Bits Layout:
381     // - [0..159] `addr`
382     // - [160..223] `startTimestamp`
383     // - [224] `burned`
384     // - [225] `nextInitialized`
385     mapping(uint256 => uint256) private _packedOwnerships;
386 
387     // Mapping owner address to address data.
388     //
389     // Bits Layout:
390     // - [0..63] `balance`
391     // - [64..127] `numberMinted`
392     // - [128..191] `numberBurned`
393     // - [192..255] `aux`
394     mapping(address => uint256) private _packedAddressData;
395 
396     // Mapping from token ID to approved address.
397     mapping(uint256 => address) private _tokenApprovals;
398 
399     // Mapping from owner to operator approvals
400     mapping(address => mapping(address => bool)) private _operatorApprovals;
401 
402 
403     function setSale(bool _saleIsActive) external onlyOwner{
404         saleIsActive = _saleIsActive;
405     }
406 
407     function setBaseURI(string memory _new) external onlyOwner{
408         _baseURI = _new;
409     }
410 
411     function setContractURI(string memory _new) external onlyOwner{
412         _contractURI = _new;
413     }
414    
415 
416 
417 
418 
419     /**
420      * @dev Returns the starting token ID. 
421      * To change the starting token ID, please override this function.
422      */
423     function _startTokenId() internal view virtual returns (uint256) {
424         return 0;
425     }
426 
427     /**
428      * @dev Returns the next token ID to be minted.
429      */
430     function _nextTokenId() internal view returns (uint256) {
431         return _currentIndex;
432     }
433 
434     /**
435      * @dev Returns the total number of tokens in existence.
436      * Burned tokens will reduce the count. 
437      * To get the total number of tokens minted, please see `_totalMinted`.
438      */
439     function totalSupply() public view override returns (uint256) {
440         // Counter underflow is impossible as _burnCounter cannot be incremented
441         // more than `_currentIndex - _startTokenId()` times.
442         unchecked {
443             return _currentIndex - _startTokenId();
444         }
445     }
446 
447     /**
448      * @dev Returns the total amount of tokens minted in the contract.
449      */
450     function _totalMinted() internal view returns (uint256) {
451         // Counter underflow is impossible as _currentIndex does not decrement,
452         // and it is initialized to `_startTokenId()`
453         unchecked {
454             return _currentIndex - _startTokenId();
455         }
456     }
457 
458 
459     /**
460      * @dev See {IERC165-supportsInterface}.
461      */
462     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
463         // The interface IDs are constants representing the first 4 bytes of the XOR of
464         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
465         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
466         return
467             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
468             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
469             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
470     }
471 
472     /**
473      * @dev See {IERC721-balanceOf}.
474      */
475     function balanceOf(address owner) public view override returns (uint256) {
476         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
477         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
478     }
479 
480     /**
481      * Returns the number of tokens minted by `owner`.
482      */
483     function _numberMinted(address owner) internal view returns (uint256) {
484         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
485     }
486 
487 
488 
489     /**
490      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
491      */
492     function _getAux(address owner) internal view returns (uint64) {
493         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
494     }
495 
496     /**
497      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
498      * If there are multiple variables, please pack them into a uint64.
499      */
500     function _setAux(address owner, uint64 aux) internal {
501         uint256 packed = _packedAddressData[owner];
502         uint256 auxCasted;
503         assembly { // Cast aux without masking.
504 auxCasted := aux
505         }
506         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
507         _packedAddressData[owner] = packed;
508     }
509 
510     /**
511      * Returns the packed ownership data of `tokenId`.
512      */
513     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
514         uint256 curr = tokenId;
515 
516         unchecked {
517             if (_startTokenId() <= curr)
518                 if (curr < _currentIndex) {
519                     uint256 packed = _packedOwnerships[curr];
520                     // If not burned.
521                     if (packed & BITMASK_BURNED == 0) {
522                         // Invariant:
523                         // There will always be an ownership that has an address and is not burned
524                         // before an ownership that does not have an address and is not burned.
525                         // Hence, curr will not underflow.
526                         //
527                         // We can directly compare the packed value.
528                         // If the address is zero, packed is zero.
529                         while (packed == 0) {
530                             packed = _packedOwnerships[--curr];
531                         }
532                         return packed;
533                     }
534                 }
535         }
536         revert OwnerQueryForNonexistentToken();
537     }
538 
539     /**
540      * Returns the unpacked `TokenOwnership` struct from `packed`.
541      */
542     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
543         ownership.addr = address(uint160(packed));
544         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
545         ownership.burned = packed & BITMASK_BURNED != 0;
546     }
547 
548     /**
549      * Returns the unpacked `TokenOwnership` struct at `index`.
550      */
551     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
552         return _unpackedOwnership(_packedOwnerships[index]);
553     }
554 
555     /**
556      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
557      */
558     function _initializeOwnershipAt(uint256 index) internal {
559         if (_packedOwnerships[index] == 0) {
560             _packedOwnerships[index] = _packedOwnershipOf(index);
561         }
562     }
563 
564     /**
565      * Gas spent here starts off proportional to the maximum mint batch size.
566      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
567      */
568     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
569         return _unpackedOwnership(_packedOwnershipOf(tokenId));
570     }
571 
572     /**
573      * @dev See {IERC721-ownerOf}.
574      */
575     function ownerOf(uint256 tokenId) public view override returns (address) {
576         return address(uint160(_packedOwnershipOf(tokenId)));
577     }
578 
579     /**
580      * @dev See {IERC721Metadata-name}.
581      */
582     function name() public view virtual override returns (string memory) {
583         return _name;
584     }
585 
586     /**
587      * @dev See {IERC721Metadata-symbol}.
588      */
589     function symbol() public view virtual override returns (string memory) {
590         return _symbol;
591     }
592 
593     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
594         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
595         string memory baseURI = _baseURI;
596         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
597     }
598 
599     function contractURI() public view returns (string memory) {
600         return string(abi.encodePacked("ipfs://", _contractURI));
601     }
602 
603     /**
604      * @dev Casts the address to uint256 without masking.
605      */
606     function _addressToUint256(address value) private pure returns (uint256 result) {
607         assembly {
608 result := value
609         }
610     }
611 
612     /**
613      * @dev Casts the boolean to uint256 without branching.
614      */
615     function _boolToUint256(bool value) private pure returns (uint256 result) {
616         assembly {
617 result := value
618         }
619     }
620 
621     /**
622      * @dev See {IERC721-approve}.
623      */
624     function approve(address to, uint256 tokenId) public override {
625         address owner = address(uint160(_packedOwnershipOf(tokenId)));
626         if (to == owner) revert();
627 
628         if (_msgSenderERC721A() != owner)
629             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
630                 revert ApprovalCallerNotOwnerNorApproved();
631             }
632 
633         _tokenApprovals[tokenId] = to;
634         emit Approval(owner, to, tokenId);
635     }
636 
637     /**
638      * @dev See {IERC721-getApproved}.
639      */
640     function getApproved(uint256 tokenId) public view override returns (address) {
641         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
642 
643         return _tokenApprovals[tokenId];
644     }
645 
646     /**
647      * @dev See {IERC721-setApprovalForAll}.
648      */
649     function setApprovalForAll(address operator, bool approved) public virtual override {
650         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
651 
652         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
653         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
654     }
655 
656     /**
657      * @dev See {IERC721-isApprovedForAll}.
658      */
659     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
660         return _operatorApprovals[owner][operator];
661     }
662 
663     /**
664      * @dev See {IERC721-transferFrom}.
665      */
666     function transferFrom(
667             address from,
668             address to,
669             uint256 tokenId
670             ) public virtual override {
671         _transfer(from, to, tokenId);
672     }
673 
674     /**
675      * @dev See {IERC721-safeTransferFrom}.
676      */
677     function safeTransferFrom(
678             address from,
679             address to,
680             uint256 tokenId
681             ) public virtual override {
682         safeTransferFrom(from, to, tokenId, '');
683     }
684 
685     /**
686      * @dev See {IERC721-safeTransferFrom}.
687      */
688     function safeTransferFrom(
689             address from,
690             address to,
691             uint256 tokenId,
692             bytes memory _data
693             ) public virtual override {
694         _transfer(from, to, tokenId);
695     }
696 
697     /**
698      * @dev Returns whether `tokenId` exists.
699      *
700      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
701      *
702      * Tokens start existing when they are minted (`_mint`),
703      */
704     function _exists(uint256 tokenId) internal view returns (bool) {
705         return
706             _startTokenId() <= tokenId &&
707             tokenId < _currentIndex;
708     }
709 
710     /**
711      * @dev Equivalent to `_safeMint(to, quantity, '')`.
712      */
713     function _safeMint(address to, uint256 quantity) internal {
714         _safeMint(to, quantity, '');
715     }
716 
717     /**
718      * @dev Safely mints `quantity` tokens and transfers them to `to`.
719      *
720      * Requirements:
721      *
722      * - If `to` refers to a smart contract, it must implement
723      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
724      * - `quantity` must be greater than 0.
725      *
726      * Emits a {Transfer} event.
727      */
728     function _safeMint(
729             address to,
730             uint256 quantity,
731             bytes memory _data
732             ) internal {
733         uint256 startTokenId = _currentIndex;
734         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
735         if (quantity == 0) revert MintZeroQuantity();
736 
737 
738         // Overflows are incredibly unrealistic.
739         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
740         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
741         unchecked {
742             // Updates:
743             // - `balance += quantity`.
744             // - `numberMinted += quantity`.
745             //
746             // We can directly add to the balance and number minted.
747             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
748 
749             // Updates:
750             // - `address` to the owner.
751             // - `startTimestamp` to the timestamp of minting.
752             // - `burned` to `false`.
753             // - `nextInitialized` to `quantity == 1`.
754             _packedOwnerships[startTokenId] =
755                 _addressToUint256(to) |
756                 (block.timestamp << BITPOS_START_TIMESTAMP) |
757                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
758 
759             uint256 updatedIndex = startTokenId;
760             uint256 end = updatedIndex + quantity;
761 
762             if (to.code.length != 0) {
763                 do {
764                     emit Transfer(address(0), to, updatedIndex);
765                 } while (updatedIndex < end);
766                 // Reentrancy protection
767                 if (_currentIndex != startTokenId) revert();
768             } else {
769                 do {
770                     emit Transfer(address(0), to, updatedIndex++);
771                 } while (updatedIndex < end);
772             }
773             _currentIndex = updatedIndex;
774         }
775         _afterTokenTransfers(address(0), to, startTokenId, quantity);
776     }
777 
778     /**
779      * @dev Mints `quantity` tokens and transfers them to `to`.
780      *
781      * Requirements:
782      *
783      * - `to` cannot be the zero address.
784      * - `quantity` must be greater than 0.
785      *
786      * Emits a {Transfer} event.
787      */
788     function _mint(address to, uint256 quantity) internal {
789         uint256 startTokenId = _currentIndex;
790         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
791         if (quantity == 0) revert MintZeroQuantity();
792 
793 
794         // Overflows are incredibly unrealistic.
795         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
796         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
797         unchecked {
798             // Updates:
799             // - `balance += quantity`.
800             // - `numberMinted += quantity`.
801             //
802             // We can directly add to the balance and number minted.
803             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
804 
805             // Updates:
806             // - `address` to the owner.
807             // - `startTimestamp` to the timestamp of minting.
808             // - `burned` to `false`.
809             // - `nextInitialized` to `quantity == 1`.
810             _packedOwnerships[startTokenId] =
811                 _addressToUint256(to) |
812                 (block.timestamp << BITPOS_START_TIMESTAMP) |
813                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
814 
815             uint256 updatedIndex = startTokenId;
816             uint256 end = updatedIndex + quantity;
817 
818             do {
819                 emit Transfer(address(0), to, updatedIndex++);
820             } while (updatedIndex < end);
821 
822             _currentIndex = updatedIndex;
823         }
824         _afterTokenTransfers(address(0), to, startTokenId, quantity);
825     }
826 
827     /**
828      * @dev Transfers `tokenId` from `from` to `to`.
829      *
830      * Requirements:
831      *
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must be owned by `from`.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _transfer(
838             address from,
839             address to,
840             uint256 tokenId
841             ) private {
842 
843         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
844 
845         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
846 
847         address approvedAddress = _tokenApprovals[tokenId];
848 
849         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
850                 isApprovedForAll(from, _msgSenderERC721A()) ||
851                 approvedAddress == _msgSenderERC721A());
852 
853         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
854 
855         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
856 
857 
858         // Clear approvals from the previous owner.
859         if (_addressToUint256(approvedAddress) != 0) {
860             delete _tokenApprovals[tokenId];
861         }
862 
863         // Underflow of the sender's balance is impossible because we check for
864         // ownership above and the recipient's balance can't realistically overflow.
865         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
866         unchecked {
867             // We can directly increment and decrement the balances.
868             --_packedAddressData[from]; // Updates: `balance -= 1`.
869             ++_packedAddressData[to]; // Updates: `balance += 1`.
870 
871             // Updates:
872             // - `address` to the next owner.
873             // - `startTimestamp` to the timestamp of transfering.
874             // - `burned` to `false`.
875             // - `nextInitialized` to `true`.
876             _packedOwnerships[tokenId] =
877                 _addressToUint256(to) |
878                 (block.timestamp << BITPOS_START_TIMESTAMP) |
879                 BITMASK_NEXT_INITIALIZED;
880 
881             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
882             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
883                 uint256 nextTokenId = tokenId + 1;
884                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
885                 if (_packedOwnerships[nextTokenId] == 0) {
886                     // If the next slot is within bounds.
887                     if (nextTokenId != _currentIndex) {
888                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
889                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
890                     }
891                 }
892             }
893         }
894 
895         emit Transfer(from, to, tokenId);
896         _afterTokenTransfers(from, to, tokenId, 1);
897     }
898 
899 
900 
901 
902     /**
903      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
904      * minting.
905      * And also called after one token has been burned.
906      *
907      * startTokenId - the first token id to be transferred
908      * quantity - the amount to be transferred
909      *
910      * Calling conditions:
911      *
912      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
913      * transferred to `to`.
914      * - When `from` is zero, `tokenId` has been minted for `to`.
915      * - When `to` is zero, `tokenId` has been burned by `from`.
916      * - `from` and `to` are never both zero.
917      */
918     function _afterTokenTransfers(
919             address from,
920             address to,
921             uint256 startTokenId,
922             uint256 quantity
923             ) internal virtual {}
924 
925     /**
926      * @dev Returns the message sender (defaults to `msg.sender`).
927      *
928      * If you are writing GSN compatible contracts, you need to override this function.
929      */
930     function _msgSenderERC721A() internal view virtual returns (address) {
931         return msg.sender;
932     }
933 
934     /**
935      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
936      */
937     function _toString(uint256 value) internal pure returns (string memory ptr) {
938         assembly {
939             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
940             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
941             // We will need 1 32-byte word to store the length, 
942             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
943 ptr := add(mload(0x40), 128)
944 
945          // Update the free memory pointer to allocate.
946          mstore(0x40, ptr)
947 
948          // Cache the end of the memory to calculate the length later.
949          let end := ptr
950 
951          // We write the string from the rightmost digit to the leftmost digit.
952          // The following is essentially a do-while loop that also handles the zero case.
953          // Costs a bit more than early returning for the zero case,
954          // but cheaper in terms of deployment and overall runtime costs.
955          for { 
956              // Initialize and perform the first pass without check.
957              let temp := value
958                  // Move the pointer 1 byte leftwards to point to an empty character slot.
959                  ptr := sub(ptr, 1)
960                  // Write the character to the pointer. 48 is the ASCII index of '0'.
961                  mstore8(ptr, add(48, mod(temp, 10)))
962                  temp := div(temp, 10)
963          } temp { 
964              // Keep dividing `temp` until zero.
965         temp := div(temp, 10)
966          } { 
967              // Body of the for loop.
968         ptr := sub(ptr, 1)
969          mstore8(ptr, add(48, mod(temp, 10)))
970          }
971 
972      let length := sub(end, ptr)
973          // Move the pointer 32 bytes leftwards to make room for the length.
974          ptr := sub(ptr, 32)
975          // Store the length.
976          mstore(ptr, length)
977         }
978     }
979 
980     
981 
982     function withdraw() external onlyOwner {
983         uint256 balance = address(this).balance;
984         payable(msg.sender).transfer(balance);
985     }
986 }