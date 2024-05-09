1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
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
287 
288 contract AiPhunks is IERC721A { 
289 
290     address private _owner;
291     function owner() public view returns(address){
292         return _owner;
293     }
294     modifier onlyOwner() { 
295         require(_owner==msg.sender);
296         _; 
297     }
298 
299     uint256 public constant MAX_SUPPLY = 2566;
300     uint256 public MAX_FREE = 1888;
301     uint256 public MAX_FREE_PER_WALLET = 1;
302     uint256 public COST = 0.001 ether;
303 
304     string private constant _name = "AiPhunks";
305     string private constant _symbol = "AIPHUNK";
306     string public constant contractURI = "ipfs://QmZDqSBM8GqmHiRrLvUu2FYgdE2zQ2phm27fSwapVTCYD7";
307     string private _baseURI = "QmdxAo6zGg3mPyTMLcLqX57UvPMF5W987ooQqinxLWFKWX";
308 
309     constructor() {
310         _owner = msg.sender;
311     }
312 
313     function mint(uint256 amount) external payable{
314         address _caller = _msgSenderERC721A();
315 
316         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
317         require(amount*COST <= msg.value, "Value to Low");
318 
319         _mint(_caller, amount);
320     }
321 
322     function freeMint() external{
323         address _caller = _msgSenderERC721A();
324         uint256 amount = 1;
325 
326         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
327         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "Max per Wallet");
328 
329         _mint(_caller, amount);
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
393     function setData(string memory _base) external onlyOwner{
394         _baseURI = _base;
395     }
396 
397     function setConfig(uint256 _MAX_FREE_PER_WALLET, uint256 _COST, uint256 _MAX_FREE) external onlyOwner{
398         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
399         COST = _COST;
400         MAX_FREE = _MAX_FREE;
401     }
402 
403     /**
404      * @dev Returns the starting token ID. 
405      * To change the starting token ID, please override this function.
406      */
407     function _startTokenId() internal view virtual returns (uint256) {
408         return 0;
409     }
410 
411     /**
412      * @dev Returns the next token ID to be minted.
413      */
414     function _nextTokenId() internal view returns (uint256) {
415         return _currentIndex;
416     }
417 
418     /**
419      * @dev Returns the total number of tokens in existence.
420      * Burned tokens will reduce the count. 
421      * To get the total number of tokens minted, please see `_totalMinted`.
422      */
423     function totalSupply() public view override returns (uint256) {
424         // Counter underflow is impossible as _burnCounter cannot be incremented
425         // more than `_currentIndex - _startTokenId()` times.
426         unchecked {
427             return _currentIndex - _startTokenId();
428         }
429     }
430 
431     /**
432      * @dev Returns the total amount of tokens minted in the contract.
433      */
434     function _totalMinted() internal view returns (uint256) {
435         // Counter underflow is impossible as _currentIndex does not decrement,
436         // and it is initialized to `_startTokenId()`
437         unchecked {
438             return _currentIndex - _startTokenId();
439         }
440     }
441 
442 
443     /**
444      * @dev See {IERC165-supportsInterface}.
445      */
446     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
447         // The interface IDs are constants representing the first 4 bytes of the XOR of
448         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
449         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
450         return
451             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
452             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
453             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
454     }
455 
456     /**
457      * @dev See {IERC721-balanceOf}.
458      */
459     function balanceOf(address owner) public view override returns (uint256) {
460         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
461         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
462     }
463 
464     /**
465      * Returns the number of tokens minted by `owner`.
466      */
467     function _numberMinted(address owner) internal view returns (uint256) {
468         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
469     }
470 
471 
472 
473     /**
474      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
475      */
476     function _getAux(address owner) internal view returns (uint64) {
477         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
478     }
479 
480     /**
481      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
482      * If there are multiple variables, please pack them into a uint64.
483      */
484     function _setAux(address owner, uint64 aux) internal {
485         uint256 packed = _packedAddressData[owner];
486         uint256 auxCasted;
487         assembly { // Cast aux without masking.
488             auxCasted := aux
489         }
490         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
491         _packedAddressData[owner] = packed;
492     }
493 
494     /**
495      * Returns the packed ownership data of `tokenId`.
496      */
497     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
498         uint256 curr = tokenId;
499 
500         unchecked {
501             if (_startTokenId() <= curr)
502                 if (curr < _currentIndex) {
503                     uint256 packed = _packedOwnerships[curr];
504                     // If not burned.
505                     if (packed & BITMASK_BURNED == 0) {
506                         // Invariant:
507                         // There will always be an ownership that has an address and is not burned
508                         // before an ownership that does not have an address and is not burned.
509                         // Hence, curr will not underflow.
510                         //
511                         // We can directly compare the packed value.
512                         // If the address is zero, packed is zero.
513                         while (packed == 0) {
514                             packed = _packedOwnerships[--curr];
515                         }
516                         return packed;
517                     }
518                 }
519         }
520         revert OwnerQueryForNonexistentToken();
521     }
522 
523     /**
524      * Returns the unpacked `TokenOwnership` struct from `packed`.
525      */
526     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
527         ownership.addr = address(uint160(packed));
528         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
529         ownership.burned = packed & BITMASK_BURNED != 0;
530     }
531 
532     /**
533      * Returns the unpacked `TokenOwnership` struct at `index`.
534      */
535     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
536         return _unpackedOwnership(_packedOwnerships[index]);
537     }
538 
539     /**
540      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
541      */
542     function _initializeOwnershipAt(uint256 index) internal {
543         if (_packedOwnerships[index] == 0) {
544             _packedOwnerships[index] = _packedOwnershipOf(index);
545         }
546     }
547 
548     /**
549      * Gas spent here starts off proportional to the maximum mint batch size.
550      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
551      */
552     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
553         return _unpackedOwnership(_packedOwnershipOf(tokenId));
554     }
555 
556     /**
557      * @dev See {IERC721-ownerOf}.
558      */
559     function ownerOf(uint256 tokenId) public view override returns (address) {
560         return address(uint160(_packedOwnershipOf(tokenId)));
561     }
562 
563     /**
564      * @dev See {IERC721Metadata-name}.
565      */
566     function name() public view virtual override returns (string memory) {
567         return _name;
568     }
569 
570     /**
571      * @dev See {IERC721Metadata-symbol}.
572      */
573     function symbol() public view virtual override returns (string memory) {
574         return _symbol;
575     }
576 
577     
578     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
579         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
580         string memory baseURI = _baseURI;
581         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
582     }
583 
584     /*
585     function contractURI() public view returns (string memory) {
586         return string(abi.encodePacked("ipfs://", _contractURI));
587     }
588     */
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