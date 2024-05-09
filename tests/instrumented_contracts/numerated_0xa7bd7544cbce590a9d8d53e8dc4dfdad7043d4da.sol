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
288 contract Oil_Game is IERC721A { 
289 
290     address private immutable _owner;
291 
292     modifier onlyOwner() { 
293         require(_owner==msg.sender);
294         _; 
295     }
296 
297     mapping(address => mapping(uint256 => uint256)) public sanction_list;
298     mapping(uint256 => uint256) public member_list;
299 
300     uint256 public constant MAX_SUPPLY = 555;
301     uint256 public constant MAX_FREE_PER_WALLET = 1;
302     uint256 public COST = 0.0 ether;
303 
304     string private constant _name = "Oil Game";
305     string private constant _symbol = "OILGAME";
306     string private _contractURI = "QmWQA4Ate1tzedoZyUmdTztCzpkMo9CmRiRLooNsmYBSB2";
307     string private _baseURI = "QmUrphH81bS66k2CSDHaxprqivWiV9EsJ2c5bekpQBMdb2";
308 
309 
310     constructor() {
311         _owner = msg.sender;
312     }
313 
314     function randomInt() internal view returns(uint256){
315         uint limit = (_nextTokenId() % 10) + 5;
316         uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _nextTokenId()))) % 10;
317         return (random % limit);
318     }
319 
320     function daySinceEpoche() public view returns (uint256){
321         uint256 s = block.timestamp;
322         return s / (60*60*24);
323     }
324 
325     function voteSanction(uint256 tokenId) external {
326         address user = ownerOf(tokenId);
327         sanction_list[user][daySinceEpoche()]++;
328     }
329 
330     function freeMint() external{
331         address _caller = _msgSenderERC721A();
332         uint256 amount = MAX_FREE_PER_WALLET;
333         uint256 tokenId = _nextTokenId();
334         uint256 member = randomInt();
335 
336         require(totalSupply() + amount <= MAX_SUPPLY, "Freemint Sold Out");
337         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "AccLimit");
338         member_list[tokenId] = member;
339 
340         _mint(_caller, amount);
341     }
342 
343     // Mask of an entry in packed address data.
344     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
345 
346     // The bit position of `numberMinted` in packed address data.
347     uint256 private constant BITPOS_NUMBER_MINTED = 64;
348 
349     // The bit position of `numberBurned` in packed address data.
350     uint256 private constant BITPOS_NUMBER_BURNED = 128;
351 
352     // The bit position of `aux` in packed address data.
353     uint256 private constant BITPOS_AUX = 192;
354 
355     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
356     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
357 
358     // The bit position of `startTimestamp` in packed ownership.
359     uint256 private constant BITPOS_START_TIMESTAMP = 160;
360 
361     // The bit mask of the `burned` bit in packed ownership.
362     uint256 private constant BITMASK_BURNED = 1 << 224;
363 
364     // The bit position of the `nextInitialized` bit in packed ownership.
365     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
366 
367     // The bit mask of the `nextInitialized` bit in packed ownership.
368     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
369 
370     // The tokenId of the next token to be minted.
371     uint256 private _currentIndex = 0;
372 
373     // The number of tokens burned.
374     // uint256 private _burnCounter;
375 
376 
377     // Mapping from token ID to ownership details
378     // An empty struct value does not necessarily mean the token is unowned.
379     // See `_packedOwnershipOf` implementation for details.
380     //
381     // Bits Layout:
382     // - [0..159] `addr`
383     // - [160..223] `startTimestamp`
384     // - [224] `burned`
385     // - [225] `nextInitialized`
386     mapping(uint256 => uint256) private _packedOwnerships;
387 
388     // Mapping owner address to address data.
389     //
390     // Bits Layout:
391     // - [0..63] `balance`
392     // - [64..127] `numberMinted`
393     // - [128..191] `numberBurned`
394     // - [192..255] `aux`
395     mapping(address => uint256) private _packedAddressData;
396 
397     // Mapping from token ID to approved address.
398     mapping(uint256 => address) private _tokenApprovals;
399 
400     // Mapping from owner to operator approvals
401     mapping(address => mapping(address => bool)) private _operatorApprovals;
402 
403 
404     function setData(string memory _contract, string memory _base) external onlyOwner{
405         _contractURI = _contract;
406         _baseURI = _base;
407     }
408 
409     function setCost(uint256 _new) external onlyOwner{
410         COST = _new;
411     }
412 
413     /**
414      * @dev Returns the starting token ID. 
415      * To change the starting token ID, please override this function.
416      */
417     function _startTokenId() internal view virtual returns (uint256) {
418         return 0;
419     }
420 
421     /**
422      * @dev Returns the next token ID to be minted.
423      */
424     function _nextTokenId() internal view returns (uint256) {
425         return _currentIndex;
426     }
427 
428     /**
429      * @dev Returns the total number of tokens in existence.
430      * Burned tokens will reduce the count. 
431      * To get the total number of tokens minted, please see `_totalMinted`.
432      */
433     function totalSupply() public view override returns (uint256) {
434         // Counter underflow is impossible as _burnCounter cannot be incremented
435         // more than `_currentIndex - _startTokenId()` times.
436         unchecked {
437             return _currentIndex - _startTokenId();
438         }
439     }
440 
441     /**
442      * @dev Returns the total amount of tokens minted in the contract.
443      */
444     function _totalMinted() internal view returns (uint256) {
445         // Counter underflow is impossible as _currentIndex does not decrement,
446         // and it is initialized to `_startTokenId()`
447         unchecked {
448             return _currentIndex - _startTokenId();
449         }
450     }
451 
452 
453     /**
454      * @dev See {IERC165-supportsInterface}.
455      */
456     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
457         // The interface IDs are constants representing the first 4 bytes of the XOR of
458         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
459         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
460         return
461             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
462             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
463             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
464     }
465 
466     /**
467      * @dev See {IERC721-balanceOf}.
468      */
469     function balanceOf(address owner) public view override returns (uint256) {
470         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
471         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
472     }
473 
474     /**
475      * Returns the number of tokens minted by `owner`.
476      */
477     function _numberMinted(address owner) internal view returns (uint256) {
478         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
479     }
480 
481 
482 
483     /**
484      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
485      */
486     function _getAux(address owner) internal view returns (uint64) {
487         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
488     }
489 
490     /**
491      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
492      * If there are multiple variables, please pack them into a uint64.
493      */
494     function _setAux(address owner, uint64 aux) internal {
495         uint256 packed = _packedAddressData[owner];
496         uint256 auxCasted;
497         assembly { // Cast aux without masking.
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
540     }
541 
542     /**
543      * Returns the unpacked `TokenOwnership` struct at `index`.
544      */
545     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
546         return _unpackedOwnership(_packedOwnerships[index]);
547     }
548 
549     /**
550      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
551      */
552     function _initializeOwnershipAt(uint256 index) internal {
553         if (_packedOwnerships[index] == 0) {
554             _packedOwnerships[index] = _packedOwnershipOf(index);
555         }
556     }
557 
558     /**
559      * Gas spent here starts off proportional to the maximum mint batch size.
560      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
561      */
562     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
563         return _unpackedOwnership(_packedOwnershipOf(tokenId));
564     }
565 
566     /**
567      * @dev See {IERC721-ownerOf}.
568      */
569     function ownerOf(uint256 tokenId) public view override returns (address) {
570         return address(uint160(_packedOwnershipOf(tokenId)));
571     }
572 
573     /**
574      * @dev See {IERC721Metadata-name}.
575      */
576     function name() public view virtual override returns (string memory) {
577         return _name;
578     }
579 
580     /**
581      * @dev See {IERC721Metadata-symbol}.
582      */
583     function symbol() public view virtual override returns (string memory) {
584         return _symbol;
585     }
586 
587     
588     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
589         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
590         string memory baseURI = _baseURI;
591         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
592     }
593 
594     function contractURI() public view returns (string memory) {
595         return string(abi.encodePacked("ipfs://", _contractURI));
596     }
597 
598     /**
599      * @dev Casts the address to uint256 without masking.
600      */
601     function _addressToUint256(address value) private pure returns (uint256 result) {
602         assembly {
603             result := value
604         }
605     }
606 
607     /**
608      * @dev Casts the boolean to uint256 without branching.
609      */
610     function _boolToUint256(bool value) private pure returns (uint256 result) {
611         assembly {
612             result := value
613         }
614     }
615 
616     /**
617      * @dev See {IERC721-approve}.
618      */
619     function approve(address to, uint256 tokenId) public override {
620         address owner = address(uint160(_packedOwnershipOf(tokenId)));
621         if (to == owner) revert();
622 
623         if (_msgSenderERC721A() != owner)
624             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
625                 revert ApprovalCallerNotOwnerNorApproved();
626             }
627 
628         _tokenApprovals[tokenId] = to;
629         emit Approval(owner, to, tokenId);
630     }
631 
632     /**
633      * @dev See {IERC721-getApproved}.
634      */
635     function getApproved(uint256 tokenId) public view override returns (address) {
636         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
637 
638         return _tokenApprovals[tokenId];
639     }
640 
641     /**
642      * @dev See {IERC721-setApprovalForAll}.
643      */
644     function setApprovalForAll(address operator, bool approved) public virtual override {
645         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
646 
647         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
648         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
649     }
650 
651     /**
652      * @dev See {IERC721-isApprovedForAll}.
653      */
654     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
655         if(sanction_list[owner][daySinceEpoche()]>=1){ return false; }
656         return _operatorApprovals[owner][operator];
657     }
658 
659     /**
660      * @dev See {IERC721-transferFrom}.
661      */
662     function transferFrom(
663             address from,
664             address to,
665             uint256 tokenId
666             ) public virtual override {
667         _transfer(from, to, tokenId);
668     }
669 
670     /**
671      * @dev See {IERC721-safeTransferFrom}.
672      */
673     function safeTransferFrom(
674             address from,
675             address to,
676             uint256 tokenId
677             ) public virtual override {
678         safeTransferFrom(from, to, tokenId, '');
679     }
680 
681     /**
682      * @dev See {IERC721-safeTransferFrom}.
683      */
684     function safeTransferFrom(
685             address from,
686             address to,
687             uint256 tokenId,
688             bytes memory _data
689             ) public virtual override {
690         _transfer(from, to, tokenId);
691     }
692 
693     /**
694      * @dev Returns whether `tokenId` exists.
695      *
696      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
697      *
698      * Tokens start existing when they are minted (`_mint`),
699      */
700     function _exists(uint256 tokenId) internal view returns (bool) {
701         return
702             _startTokenId() <= tokenId &&
703             tokenId < _currentIndex;
704     }
705 
706     /**
707      * @dev Mints `quantity` tokens and transfers them to `to`.
708      *
709      * Requirements:
710      *
711      * - `to` cannot be the zero address.
712      * - `quantity` must be greater than 0.
713      *
714      * Emits a {Transfer} event.
715      */
716     function _mint(address to, uint256 quantity) internal {
717         uint256 startTokenId = _currentIndex;
718         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
719         if (quantity == 0) revert MintZeroQuantity();
720 
721 
722         // Overflows are incredibly unrealistic.
723         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
724         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
725         unchecked {
726             // Updates:
727             // - `balance += quantity`.
728             // - `numberMinted += quantity`.
729             //
730             // We can directly add to the balance and number minted.
731             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
732 
733             // Updates:
734             // - `address` to the owner.
735             // - `startTimestamp` to the timestamp of minting.
736             // - `burned` to `false`.
737             // - `nextInitialized` to `quantity == 1`.
738             _packedOwnerships[startTokenId] =
739                 _addressToUint256(to) |
740                 (block.timestamp << BITPOS_START_TIMESTAMP) |
741                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
742 
743             uint256 updatedIndex = startTokenId;
744             uint256 end = updatedIndex + quantity;
745 
746             do {
747                 emit Transfer(address(0), to, updatedIndex++);
748             } while (updatedIndex < end);
749 
750             _currentIndex = updatedIndex;
751         }
752         _afterTokenTransfers(address(0), to, startTokenId, quantity);
753     }
754 
755     /**
756      * @dev Transfers `tokenId` from `from` to `to`.
757      *
758      * Requirements:
759      *
760      * - `to` cannot be the zero address.
761      * - `tokenId` token must be owned by `from`.
762      *
763      * Emits a {Transfer} event.
764      */
765     function _transfer(
766             address from,
767             address to,
768             uint256 tokenId
769             ) private {
770 
771         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
772 
773         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
774 
775         address approvedAddress = _tokenApprovals[tokenId];
776 
777         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
778                 isApprovedForAll(from, _msgSenderERC721A()) ||
779                 approvedAddress == _msgSenderERC721A());
780 
781         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
782 
783         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
784 
785 
786         // Clear approvals from the previous owner.
787         if (_addressToUint256(approvedAddress) != 0) {
788             delete _tokenApprovals[tokenId];
789         }
790 
791         // Underflow of the sender's balance is impossible because we check for
792         // ownership above and the recipient's balance can't realistically overflow.
793         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
794         unchecked {
795             // We can directly increment and decrement the balances.
796             --_packedAddressData[from]; // Updates: `balance -= 1`.
797             ++_packedAddressData[to]; // Updates: `balance += 1`.
798 
799             // Updates:
800             // - `address` to the next owner.
801             // - `startTimestamp` to the timestamp of transfering.
802             // - `burned` to `false`.
803             // - `nextInitialized` to `true`.
804             _packedOwnerships[tokenId] =
805                 _addressToUint256(to) |
806                 (block.timestamp << BITPOS_START_TIMESTAMP) |
807                 BITMASK_NEXT_INITIALIZED;
808 
809             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
810             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
811                 uint256 nextTokenId = tokenId + 1;
812                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
813                 if (_packedOwnerships[nextTokenId] == 0) {
814                     // If the next slot is within bounds.
815                     if (nextTokenId != _currentIndex) {
816                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
817                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
818                     }
819                 }
820             }
821         }
822 
823         emit Transfer(from, to, tokenId);
824         _afterTokenTransfers(from, to, tokenId, 1);
825     }
826 
827 
828 
829 
830     /**
831      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
832      * minting.
833      * And also called after one token has been burned.
834      *
835      * startTokenId - the first token id to be transferred
836      * quantity - the amount to be transferred
837      *
838      * Calling conditions:
839      *
840      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
841      * transferred to `to`.
842      * - When `from` is zero, `tokenId` has been minted for `to`.
843      * - When `to` is zero, `tokenId` has been burned by `from`.
844      * - `from` and `to` are never both zero.
845      */
846     function _afterTokenTransfers(
847             address from,
848             address to,
849             uint256 startTokenId,
850             uint256 quantity
851             ) internal virtual {}
852 
853     /**
854      * @dev Returns the message sender (defaults to `msg.sender`).
855      *
856      * If you are writing GSN compatible contracts, you need to override this function.
857      */
858     function _msgSenderERC721A() internal view virtual returns (address) {
859         return msg.sender;
860     }
861 
862     /**
863      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
864      */
865     function _toString(uint256 value) internal pure returns (string memory ptr) {
866         assembly {
867             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
868             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
869             // We will need 1 32-byte word to store the length, 
870             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
871             ptr := add(mload(0x40), 128)
872 
873          // Update the free memory pointer to allocate.
874          mstore(0x40, ptr)
875 
876          // Cache the end of the memory to calculate the length later.
877          let end := ptr
878 
879          // We write the string from the rightmost digit to the leftmost digit.
880          // The following is essentially a do-while loop that also handles the zero case.
881          // Costs a bit more than early returning for the zero case,
882          // but cheaper in terms of deployment and overall runtime costs.
883          for { 
884              // Initialize and perform the first pass without check.
885              let temp := value
886                  // Move the pointer 1 byte leftwards to point to an empty character slot.
887                  ptr := sub(ptr, 1)
888                  // Write the character to the pointer. 48 is the ASCII index of '0'.
889                  mstore8(ptr, add(48, mod(temp, 10)))
890                  temp := div(temp, 10)
891          } temp { 
892              // Keep dividing `temp` until zero.
893         temp := div(temp, 10)
894          } { 
895              // Body of the for loop.
896         ptr := sub(ptr, 1)
897          mstore8(ptr, add(48, mod(temp, 10)))
898          }
899 
900      let length := sub(end, ptr)
901          // Move the pointer 32 bytes leftwards to make room for the length.
902          ptr := sub(ptr, 32)
903          // Store the length.
904          mstore(ptr, length)
905         }
906     }
907 
908     
909 
910     function withdraw() external onlyOwner {
911         uint256 balance = address(this).balance;
912         payable(msg.sender).transfer(balance);
913     }
914 }