1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-20
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.17;
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
292 contract Dead is IERC721A { 
293 
294     address private immutable _owner;
295 
296     modifier onlyOwner() { 
297         require(_owner==msg.sender);
298         _; 
299     }
300 
301     mapping(address => mapping(uint256 => uint256)) public sanction_list;
302     mapping(uint256 => uint256) public member_list;
303 
304     uint256 public constant MAX_SUPPLY = 555;
305     uint256 public constant MAX_FREE_PER_WALLET = 1;
306     uint256 public COST = 0.0 ether;
307 
308     string private constant _name = "Dead";
309     string private constant _symbol = "Dead";
310     string private _contractURI = "QmTZbX5viNEVZtL59Hdmw1cAWknURw2V9iDUM3mGKv4zC8";
311     string private _baseURI = "QmYMqFKbxhrEtPwoLVqYNp9B4oabGPFmNpSFsrNT58i69b";
312 
313 
314     constructor() {
315         _owner = msg.sender;
316     }
317 
318     function randomInt() internal view returns(uint256){
319         uint limit = (_nextTokenId() % 10) + 5;
320         uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _nextTokenId()))) % 10;
321         return (random % limit);
322     }
323 
324     function daySinceEpoche() public view returns (uint256){
325         uint256 s = block.timestamp;
326         return s / (60*60*24);
327     }
328 
329     function voteSanction(uint256 tokenId) external {
330         address user = ownerOf(tokenId);
331         sanction_list[user][daySinceEpoche()]++;
332     }
333 
334     function freeMint() external{
335         address _caller = _msgSenderERC721A();
336         uint256 amount = MAX_FREE_PER_WALLET;
337         uint256 tokenId = _nextTokenId();
338         uint256 member = randomInt();
339 
340         require(totalSupply() + amount <= MAX_SUPPLY, "Freemint Sold Out");
341         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "AccLimit");
342         member_list[tokenId] = member;
343 
344         _mint(_caller, amount);
345     }
346 
347     // Mask of an entry in packed address data.
348     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
349 
350     // The bit position of `numberMinted` in packed address data.
351     uint256 private constant BITPOS_NUMBER_MINTED = 64;
352 
353     // The bit position of `numberBurned` in packed address data.
354     uint256 private constant BITPOS_NUMBER_BURNED = 128;
355 
356     // The bit position of `aux` in packed address data.
357     uint256 private constant BITPOS_AUX = 192;
358 
359     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
360     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
361 
362     // The bit position of `startTimestamp` in packed ownership.
363     uint256 private constant BITPOS_START_TIMESTAMP = 160;
364 
365     // The bit mask of the `burned` bit in packed ownership.
366     uint256 private constant BITMASK_BURNED = 1 << 224;
367 
368     // The bit position of the `nextInitialized` bit in packed ownership.
369     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
370 
371     // The bit mask of the `nextInitialized` bit in packed ownership.
372     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
373 
374     // The tokenId of the next token to be minted.
375     uint256 private _currentIndex = 0;
376 
377     // The number of tokens burned.
378     // uint256 private _burnCounter;
379 
380 
381     // Mapping from token ID to ownership details
382     // An empty struct value does not necessarily mean the token is unowned.
383     // See `_packedOwnershipOf` implementation for details.
384     //
385     // Bits Layout:
386     // - [0..159] `addr`
387     // - [160..223] `startTimestamp`
388     // - [224] `burned`
389     // - [225] `nextInitialized`
390     mapping(uint256 => uint256) private _packedOwnerships;
391 
392     // Mapping owner address to address data.
393     //
394     // Bits Layout:
395     // - [0..63] `balance`
396     // - [64..127] `numberMinted`
397     // - [128..191] `numberBurned`
398     // - [192..255] `aux`
399     mapping(address => uint256) private _packedAddressData;
400 
401     // Mapping from token ID to approved address.
402     mapping(uint256 => address) private _tokenApprovals;
403 
404     // Mapping from owner to operator approvals
405     mapping(address => mapping(address => bool)) private _operatorApprovals;
406 
407 
408     function setData(string memory _contract, string memory _base) external onlyOwner{
409         _contractURI = _contract;
410         _baseURI = _base;
411     }
412 
413     function setCost(uint256 _new) external onlyOwner{
414         COST = _new;
415     }
416 
417     /**
418      * @dev Returns the starting token ID. 
419      * To change the starting token ID, please override this function.
420      */
421     function _startTokenId() internal view virtual returns (uint256) {
422         return 0;
423     }
424 
425     /**
426      * @dev Returns the next token ID to be minted.
427      */
428     function _nextTokenId() internal view returns (uint256) {
429         return _currentIndex;
430     }
431 
432     /**
433      * @dev Returns the total number of tokens in existence.
434      * Burned tokens will reduce the count. 
435      * To get the total number of tokens minted, please see `_totalMinted`.
436      */
437     function totalSupply() public view override returns (uint256) {
438         // Counter underflow is impossible as _burnCounter cannot be incremented
439         // more than `_currentIndex - _startTokenId()` times.
440         unchecked {
441             return _currentIndex - _startTokenId();
442         }
443     }
444 
445     /**
446      * @dev Returns the total amount of tokens minted in the contract.
447      */
448     function _totalMinted() internal view returns (uint256) {
449         // Counter underflow is impossible as _currentIndex does not decrement,
450         // and it is initialized to `_startTokenId()`
451         unchecked {
452             return _currentIndex - _startTokenId();
453         }
454     }
455 
456 
457     /**
458      * @dev See {IERC165-supportsInterface}.
459      */
460     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
461         // The interface IDs are constants representing the first 4 bytes of the XOR of
462         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
463         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
464         return
465             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
466             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
467             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
468     }
469 
470     /**
471      * @dev See {IERC721-balanceOf}.
472      */
473     function balanceOf(address owner) public view override returns (uint256) {
474         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
475         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
476     }
477 
478     /**
479      * Returns the number of tokens minted by `owner`.
480      */
481     function _numberMinted(address owner) internal view returns (uint256) {
482         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
483     }
484 
485 
486 
487     /**
488      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
489      */
490     function _getAux(address owner) internal view returns (uint64) {
491         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
492     }
493 
494     /**
495      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
496      * If there are multiple variables, please pack them into a uint64.
497      */
498     function _setAux(address owner, uint64 aux) internal {
499         uint256 packed = _packedAddressData[owner];
500         uint256 auxCasted;
501         assembly { // Cast aux without masking.
502             auxCasted := aux
503         }
504         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
505         _packedAddressData[owner] = packed;
506     }
507 
508     /**
509      * Returns the packed ownership data of `tokenId`.
510      */
511     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
512         uint256 curr = tokenId;
513 
514         unchecked {
515             if (_startTokenId() <= curr)
516                 if (curr < _currentIndex) {
517                     uint256 packed = _packedOwnerships[curr];
518                     // If not burned.
519                     if (packed & BITMASK_BURNED == 0) {
520                         // Invariant:
521                         // There will always be an ownership that has an address and is not burned
522                         // before an ownership that does not have an address and is not burned.
523                         // Hence, curr will not underflow.
524                         //
525                         // We can directly compare the packed value.
526                         // If the address is zero, packed is zero.
527                         while (packed == 0) {
528                             packed = _packedOwnerships[--curr];
529                         }
530                         return packed;
531                     }
532                 }
533         }
534         revert OwnerQueryForNonexistentToken();
535     }
536 
537     /**
538      * Returns the unpacked `TokenOwnership` struct from `packed`.
539      */
540     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
541         ownership.addr = address(uint160(packed));
542         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
543         ownership.burned = packed & BITMASK_BURNED != 0;
544     }
545 
546     /**
547      * Returns the unpacked `TokenOwnership` struct at `index`.
548      */
549     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
550         return _unpackedOwnership(_packedOwnerships[index]);
551     }
552 
553     /**
554      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
555      */
556     function _initializeOwnershipAt(uint256 index) internal {
557         if (_packedOwnerships[index] == 0) {
558             _packedOwnerships[index] = _packedOwnershipOf(index);
559         }
560     }
561 
562     /**
563      * Gas spent here starts off proportional to the maximum mint batch size.
564      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
565      */
566     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
567         return _unpackedOwnership(_packedOwnershipOf(tokenId));
568     }
569 
570     /**
571      * @dev See {IERC721-ownerOf}.
572      */
573     function ownerOf(uint256 tokenId) public view override returns (address) {
574         return address(uint160(_packedOwnershipOf(tokenId)));
575     }
576 
577     /**
578      * @dev See {IERC721Metadata-name}.
579      */
580     function name() public view virtual override returns (string memory) {
581         return _name;
582     }
583 
584     /**
585      * @dev See {IERC721Metadata-symbol}.
586      */
587     function symbol() public view virtual override returns (string memory) {
588         return _symbol;
589     }
590 
591     
592     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
593         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
594         string memory baseURI = _baseURI;
595         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
596     }
597 
598     function contractURI() public view returns (string memory) {
599         return string(abi.encodePacked("ipfs://", _contractURI));
600     }
601 
602     /**
603      * @dev Casts the address to uint256 without masking.
604      */
605     function _addressToUint256(address value) private pure returns (uint256 result) {
606         assembly {
607             result := value
608         }
609     }
610 
611     /**
612      * @dev Casts the boolean to uint256 without branching.
613      */
614     function _boolToUint256(bool value) private pure returns (uint256 result) {
615         assembly {
616             result := value
617         }
618     }
619 
620     /**
621      * @dev See {IERC721-approve}.
622      */
623     function approve(address to, uint256 tokenId) public override {
624         address owner = address(uint160(_packedOwnershipOf(tokenId)));
625         if (to == owner) revert();
626 
627         if (_msgSenderERC721A() != owner)
628             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
629                 revert ApprovalCallerNotOwnerNorApproved();
630             }
631 
632         _tokenApprovals[tokenId] = to;
633         emit Approval(owner, to, tokenId);
634     }
635 
636     /**
637      * @dev See {IERC721-getApproved}.
638      */
639     function getApproved(uint256 tokenId) public view override returns (address) {
640         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
641 
642         return _tokenApprovals[tokenId];
643     }
644 
645     /**
646      * @dev See {IERC721-setApprovalForAll}.
647      */
648     function setApprovalForAll(address operator, bool approved) public virtual override {
649         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
650 
651         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
652         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
653     }
654 
655     /**
656      * @dev See {IERC721-isApprovedForAll}.
657      */
658     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
659         if(sanction_list[owner][daySinceEpoche()]>=1){ return false; }
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
711      * @dev Mints `quantity` tokens and transfers them to `to`.
712      *
713      * Requirements:
714      *
715      * - `to` cannot be the zero address.
716      * - `quantity` must be greater than 0.
717      *
718      * Emits a {Transfer} event.
719      */
720     function _mint(address to, uint256 quantity) internal {
721         uint256 startTokenId = _currentIndex;
722         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
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
750             do {
751                 emit Transfer(address(0), to, updatedIndex++);
752             } while (updatedIndex < end);
753 
754             _currentIndex = updatedIndex;
755         }
756         _afterTokenTransfers(address(0), to, startTokenId, quantity);
757     }
758 
759     /**
760      * @dev Transfers `tokenId` from `from` to `to`.
761      *
762      * Requirements:
763      *
764      * - `to` cannot be the zero address.
765      * - `tokenId` token must be owned by `from`.
766      *
767      * Emits a {Transfer} event.
768      */
769     function _transfer(
770             address from,
771             address to,
772             uint256 tokenId
773             ) private {
774 
775         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
776 
777         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
778 
779         address approvedAddress = _tokenApprovals[tokenId];
780 
781         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
782                 isApprovedForAll(from, _msgSenderERC721A()) ||
783                 approvedAddress == _msgSenderERC721A());
784 
785         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
786 
787         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
788 
789 
790         // Clear approvals from the previous owner.
791         if (_addressToUint256(approvedAddress) != 0) {
792             delete _tokenApprovals[tokenId];
793         }
794 
795         // Underflow of the sender's balance is impossible because we check for
796         // ownership above and the recipient's balance can't realistically overflow.
797         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
798         unchecked {
799             // We can directly increment and decrement the balances.
800             --_packedAddressData[from]; // Updates: `balance -= 1`.
801             ++_packedAddressData[to]; // Updates: `balance += 1`.
802 
803             // Updates:
804             // - `address` to the next owner.
805             // - `startTimestamp` to the timestamp of transfering.
806             // - `burned` to `false`.
807             // - `nextInitialized` to `true`.
808             _packedOwnerships[tokenId] =
809                 _addressToUint256(to) |
810                 (block.timestamp << BITPOS_START_TIMESTAMP) |
811                 BITMASK_NEXT_INITIALIZED;
812 
813             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
814             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
815                 uint256 nextTokenId = tokenId + 1;
816                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
817                 if (_packedOwnerships[nextTokenId] == 0) {
818                     // If the next slot is within bounds.
819                     if (nextTokenId != _currentIndex) {
820                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
821                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
822                     }
823                 }
824             }
825         }
826 
827         emit Transfer(from, to, tokenId);
828         _afterTokenTransfers(from, to, tokenId, 1);
829     }
830 
831 
832 
833 
834     /**
835      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
836      * minting.
837      * And also called after one token has been burned.
838      *
839      * startTokenId - the first token id to be transferred
840      * quantity - the amount to be transferred
841      *
842      * Calling conditions:
843      *
844      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
845      * transferred to `to`.
846      * - When `from` is zero, `tokenId` has been minted for `to`.
847      * - When `to` is zero, `tokenId` has been burned by `from`.
848      * - `from` and `to` are never both zero.
849      */
850     function _afterTokenTransfers(
851             address from,
852             address to,
853             uint256 startTokenId,
854             uint256 quantity
855             ) internal virtual {}
856 
857     /**
858      * @dev Returns the message sender (defaults to `msg.sender`).
859      *
860      * If you are writing GSN compatible contracts, you need to override this function.
861      */
862     function _msgSenderERC721A() internal view virtual returns (address) {
863         return msg.sender;
864     }
865 
866     /**
867      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
868      */
869     function _toString(uint256 value) internal pure returns (string memory ptr) {
870         assembly {
871             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
872             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
873             // We will need 1 32-byte word to store the length, 
874             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
875             ptr := add(mload(0x40), 128)
876 
877          // Update the free memory pointer to allocate.
878          mstore(0x40, ptr)
879 
880          // Cache the end of the memory to calculate the length later.
881          let end := ptr
882 
883          // We write the string from the rightmost digit to the leftmost digit.
884          // The following is essentially a do-while loop that also handles the zero case.
885          // Costs a bit more than early returning for the zero case,
886          // but cheaper in terms of deployment and overall runtime costs.
887          for { 
888              // Initialize and perform the first pass without check.
889              let temp := value
890                  // Move the pointer 1 byte leftwards to point to an empty character slot.
891                  ptr := sub(ptr, 1)
892                  // Write the character to the pointer. 48 is the ASCII index of '0'.
893                  mstore8(ptr, add(48, mod(temp, 10)))
894                  temp := div(temp, 10)
895          } temp { 
896              // Keep dividing `temp` until zero.
897         temp := div(temp, 10)
898          } { 
899              // Body of the for loop.
900         ptr := sub(ptr, 1)
901          mstore8(ptr, add(48, mod(temp, 10)))
902          }
903 
904      let length := sub(end, ptr)
905          // Move the pointer 32 bytes leftwards to make room for the length.
906          ptr := sub(ptr, 32)
907          // Store the length.
908          mstore(ptr, length)
909         }
910     }
911 
912     
913 
914     function withdraw() external onlyOwner {
915         uint256 balance = address(this).balance;
916         payable(msg.sender).transfer(balance);
917     }
918 }