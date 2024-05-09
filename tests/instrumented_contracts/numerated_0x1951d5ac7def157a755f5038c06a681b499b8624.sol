1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 
5 
6 // _   _       _                   _                   _____                               _____    _ _ _   _             
7 //| \ | |     | |                 (_)                 |  _  |                             |  ___|  | (_) | (_)            
8 //|  \| | __ _| | ____ _ _ __ ___  _  __ _  ___  ___  | | | |_ __   ___ _ __   ___ _ __   | |__  __| |_| |_ _  ___  _ __  
9 //| . ` |/ _` | |/ / _` | '_ ` _ \| |/ _` |/ _ \/ __| | | | | '_ \ / _ \ '_ \ / _ \ '_ \  |  __|/ _` | | __| |/ _ \| '_ \ 
10 //| |\  | (_| |   < (_| | | | | | | | (_| | (_) \__ \ \ \_/ / |_) |  __/ |_) |  __/ | | | | |__| (_| | | |_| | (_) | | | |
11 //\_| \_/\__,_|_|\_\__,_|_| |_| |_|_|\__, |\___/|___/  \___/| .__/ \___| .__/ \___|_| |_| \____/\__,_|_|\__|_|\___/|_| |_|
12 //                                    __/ |                 | |        | |                                                
13 //                                   |___/                  |_|        |_|                                                
14 //
15 
16 
17 
18 
19 
20 
21 /**
22  * @dev Interface of ERC721A.
23  */
24 interface IERC721A {
25     /**
26      * The caller must own the token or be an approved operator.
27      */
28     error ApprovalCallerNotOwnerNorApproved();
29 
30     /**
31      * The token does not exist.
32      */
33     error ApprovalQueryForNonexistentToken();
34 
35     /**
36      * The caller cannot approve to their own address.
37      */
38     error ApproveToCaller();
39 
40     /**
41      * Cannot query the balance for the zero address.
42      */
43     error BalanceQueryForZeroAddress();
44 
45     /**
46      * Cannot mint to the zero address.
47      */
48     error MintToZeroAddress();
49 
50     /**
51      * The quantity of tokens minted must be more than zero.
52      */
53     error MintZeroQuantity();
54 
55     /**
56      * The token does not exist.
57      */
58     error OwnerQueryForNonexistentToken();
59 
60     /**
61      * The caller must own the token or be an approved operator.
62      */
63     error TransferCallerNotOwnerNorApproved();
64 
65     /**
66      * The token must be owned by `from`.
67      */
68     error TransferFromIncorrectOwner();
69 
70     /**
71      * Cannot safely transfer to a contract that does not implement the
72      * ERC721Receiver interface.
73      */
74     error TransferToNonERC721ReceiverImplementer();
75 
76     /**
77      * Cannot transfer to the zero address.
78      */
79     error TransferToZeroAddress();
80 
81     /**
82      * The token does not exist.
83      */
84     error URIQueryForNonexistentToken();
85 
86     /**
87      * The `quantity` minted with ERC2309 exceeds the safety limit.
88      */
89     error MintERC2309QuantityExceedsLimit();
90 
91     /**
92      * The `extraData` cannot be set on an unintialized ownership slot.
93      */
94     error OwnershipNotInitializedForExtraData();
95 
96     // =============================================================
97     //                            STRUCTS
98     // =============================================================
99 
100     struct TokenOwnership {
101         // The address of the owner.
102         address addr;
103         // Stores the start time of ownership with minimal overhead for tokenomics.
104         uint64 startTimestamp;
105         // Whether the token has been burned.
106         bool burned;
107         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
108         uint24 extraData;
109     }
110 
111     // =============================================================
112     //                         TOKEN COUNTERS
113     // =============================================================
114 
115     /**
116      * @dev Returns the total number of tokens in existence.
117      * Burned tokens will reduce the count.
118      * To get the total number of tokens minted, please see {_totalMinted}.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     // =============================================================
123     //                            IERC165
124     // =============================================================
125 
126     /**
127      * @dev Returns true if this contract implements the interface defined by
128      * `interfaceId`. See the corresponding
129      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
130      * to learn more about how these ids are created.
131      *
132      * This function call must use less than 30000 gas.
133      */
134     function supportsInterface(bytes4 interfaceId) external view returns (bool);
135 
136     // =============================================================
137     //                            IERC721
138     // =============================================================
139 
140     /**
141      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
144 
145     /**
146      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
147      */
148     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
149 
150     /**
151      * @dev Emitted when `owner` enables or disables
152      * (`approved`) `operator` to manage all of its assets.
153      */
154     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
155 
156     /**
157      * @dev Returns the number of tokens in `owner`'s account.
158      */
159     function balanceOf(address owner) external view returns (uint256 balance);
160 
161     /**
162      * @dev Returns the owner of the `tokenId` token.
163      *
164      * Requirements:
165      *
166      * - `tokenId` must exist.
167      */
168     function ownerOf(uint256 tokenId) external view returns (address owner);
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`,
172      * checking first that contract recipients are aware of the ERC721 protocol
173      * to prevent tokens from being forever locked.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be have been allowed to move
181      * this token by either {approve} or {setApprovalForAll}.
182      * - If `to` refers to a smart contract, it must implement
183      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId,
191         bytes calldata data
192     ) external;
193 
194     /**
195      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
196      */
197     function safeTransferFrom(
198         address from,
199         address to,
200         uint256 tokenId
201     ) external;
202 
203     /**
204      * @dev Transfers `tokenId` from `from` to `to`.
205      *
206      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
207      * whenever possible.
208      *
209      * Requirements:
210      *
211      * - `from` cannot be the zero address.
212      * - `to` cannot be the zero address.
213      * - `tokenId` token must be owned by `from`.
214      * - If the caller is not `from`, it must be approved to move this token
215      * by either {approve} or {setApprovalForAll}.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(
220         address from,
221         address to,
222         uint256 tokenId
223     ) external;
224 
225     /**
226      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
227      * The approval is cleared when the token is transferred.
228      *
229      * Only a single account can be approved at a time, so approving the
230      * zero address clears previous approvals.
231      *
232      * Requirements:
233      *
234      * - The caller must own the token or be an approved operator.
235      * - `tokenId` must exist.
236      *
237      * Emits an {Approval} event.
238      */
239     function approve(address to, uint256 tokenId) external;
240 
241     /**
242      * @dev Approve or remove `operator` as an operator for the caller.
243      * Operators can call {transferFrom} or {safeTransferFrom}
244      * for any token owned by the caller.
245      *
246      * Requirements:
247      *
248      * - The `operator` cannot be the caller.
249      *
250      * Emits an {ApprovalForAll} event.
251      */
252     function setApprovalForAll(address operator, bool _approved) external;
253 
254     /**
255      * @dev Returns the account approved for `tokenId` token.
256      *
257      * Requirements:
258      *
259      * - `tokenId` must exist.
260      */
261     function getApproved(uint256 tokenId) external view returns (address operator);
262 
263     /**
264      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
265      *
266      * See {setApprovalForAll}.
267      */
268     function isApprovedForAll(address owner, address operator) external view returns (bool);
269 
270     // =============================================================
271     //                        IERC721Metadata
272     // =============================================================
273 
274     /**
275      * @dev Returns the token collection name.
276      */
277     function name() external view returns (string memory);
278 
279     /**
280      * @dev Returns the token collection symbol.
281      */
282     function symbol() external view returns (string memory);
283 
284     /**
285      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
286      */
287     function tokenURI(uint256 tokenId) external view returns (string memory);
288 
289     // =============================================================
290     //                           IERC2309
291     // =============================================================
292 
293     /**
294      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
295      * (inclusive) is transferred from `from` to `to`, as defined in the
296      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
297      *
298      * See {_mintERC2309} for more details.
299      */
300     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
301 }
302 
303 
304 contract NakamigosOpepenEdition is IERC721A { 
305     address private _owner;
306     function owner() public view returns(address){
307         return _owner;
308     }
309     modifier onlyOwner() { 
310         require(_owner==msg.sender);
311         _; 
312     }
313 
314     uint256 public constant MAX_SUPPLY = 3300;
315     uint256 public COST = 0.0025 ether;
316 
317     string private constant _name = "Nakamigos Opepen Edition";
318     string private constant _symbol = "Nakamigos Opepen";
319     string public constant contractURI = "ipfs://QmfMNzwswKMMmeYRV5NLMUBnqgF2K6YqXoa8wEnRoS73K4";
320     string private _baseURI = "QmfMNzwswKMMmeYRV5NLMUBnqgF2K6YqXoa8wEnRoS73K4";
321 
322     constructor() {
323         _owner = msg.sender;
324     }
325 
326     function mint(uint256 amount) external payable{
327         address _caller = _msgSenderERC721A();
328         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
329         require(amount*COST <= msg.value, "Value to Low");
330         _mint(_caller, amount);
331     }
332 
333 
334     // Mask of an entry in packed address data.
335     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
336 
337     // The bit position of `numberMinted` in packed address data.
338     uint256 private constant BITPOS_NUMBER_MINTED = 64;
339 
340     // The bit position of `numberBurned` in packed address data.
341     uint256 private constant BITPOS_NUMBER_BURNED = 128;
342 
343     // The bit position of `aux` in packed address data.
344     uint256 private constant BITPOS_AUX = 192;
345 
346     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
347     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
348 
349     // The bit position of `startTimestamp` in packed ownership.
350     uint256 private constant BITPOS_START_TIMESTAMP = 160;
351 
352     // The bit mask of the `burned` bit in packed ownership.
353     uint256 private constant BITMASK_BURNED = 1 << 224;
354 
355     // The bit position of the `nextInitialized` bit in packed ownership.
356     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
357 
358     // The bit mask of the `nextInitialized` bit in packed ownership.
359     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
360 
361     // The tokenId of the next token to be minted.
362     uint256 private _currentIndex = 1;
363 
364     // The number of tokens burned.
365     // uint256 private _burnCounter;
366 
367 
368     // Mapping from token ID to ownership details
369     // An empty struct value does not necessarily mean the token is unowned.
370     // See `_packedOwnershipOf` implementation for details.
371     //
372     // Bits Layout:
373     // - [0..159] `addr`
374     // - [160..223] `startTimestamp`
375     // - [224] `burned`
376     // - [225] `nextInitialized`
377     mapping(uint256 => uint256) private _packedOwnerships;
378 
379     // Mapping owner address to address data.
380     //
381     // Bits Layout:
382     // - [0..63] `balance`
383     // - [64..127] `numberMinted`
384     // - [128..191] `numberBurned`
385     // - [192..255] `aux`
386     mapping(address => uint256) private _packedAddressData;
387 
388     // Mapping from token ID to approved address.
389     mapping(uint256 => address) private _tokenApprovals;
390 
391     // Mapping from owner to operator approvals
392     mapping(address => mapping(address => bool)) private _operatorApprovals;
393 
394 
395     function setData(string memory _base) external onlyOwner{
396         _baseURI = _base;
397     }
398 
399     function setConfig( uint256 _COST) external onlyOwner{
400         COST = _COST;
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