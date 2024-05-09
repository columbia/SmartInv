1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /*
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
287 contract NFT is IERC721A { 
288 
289     address private _owner;
290     function owner() public view returns(address){
291         return _owner;
292     }
293 
294     modifier onlyOwner() { 
295         require(_owner==msg.sender);
296         _; 
297     }
298 
299     uint256 public MAX_SUPPLY = 2222;
300     uint256 public MAX_FREE = 0;
301     uint256 public MAX_FREE_PER_WALLET = 0;
302     uint256 public COST = 0.003 ether;
303 
304     string private constant _name = "Hidden Weirdo";
305     string private constant _symbol = "Hidden Weirdo";
306     string private _baseURI = "bafybeihlq4ufpijoavlbupi2e6lgmx4ikikjkuf23p5h4lg6ibj4oztfcm";
307 
308     constructor() {
309         _owner = msg.sender;
310     }
311 
312     function mint(uint256 amount) external payable{
313         address _caller = _msgSenderERC721A();
314 
315         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
316         require(amount*COST <= msg.value, "Value to Low");
317         require(amount + _numberMinted(_caller) <= 2, "Max per Wallet");
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
397     function setConfig(uint256 _MAX_FREE_PER_WALLET, uint256 _COST, uint256 _MAX_FREE, uint256 _MAX_SUPPLY) external onlyOwner{
398         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
399         COST = _COST;
400         MAX_FREE = _MAX_FREE;
401         MAX_SUPPLY = _MAX_SUPPLY;
402     }
403 
404     /**
405      * @dev Returns the starting token ID. 
406      * To change the starting token ID, please override this function.
407      */
408     function _startTokenId() internal view virtual returns (uint256) {
409         return 0;
410     }
411 
412     /**
413      * @dev Returns the next token ID to be minted.
414      */
415     function _nextTokenId() internal view returns (uint256) {
416         return _currentIndex;
417     }
418 
419     /**
420      * @dev Returns the total number of tokens in existence.
421      * Burned tokens will reduce the count. 
422      * To get the total number of tokens minted, please see `_totalMinted`.
423      */
424     function totalSupply() public view override returns (uint256) {
425         // Counter underflow is impossible as _burnCounter cannot be incremented
426         // more than `_currentIndex - _startTokenId()` times.
427         unchecked {
428             return _currentIndex - _startTokenId();
429         }
430     }
431 
432     /**
433      * @dev Returns the total amount of tokens minted in the contract.
434      */
435     function _totalMinted() internal view returns (uint256) {
436         // Counter underflow is impossible as _currentIndex does not decrement,
437         // and it is initialized to `_startTokenId()`
438         unchecked {
439             return _currentIndex - _startTokenId();
440         }
441     }
442 
443 
444     /**
445      * @dev See {IERC165-supportsInterface}.
446      */
447     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
448         // The interface IDs are constants representing the first 4 bytes of the XOR of
449         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
450         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
451         return
452             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
453             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
454             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
455     }
456 
457     /**
458      * @dev See {IERC721-balanceOf}.
459      */
460     function balanceOf(address owner) public view override returns (uint256) {
461         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
462         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
463     }
464 
465     /**
466      * Returns the number of tokens minted by `owner`.
467      */
468     function _numberMinted(address owner) internal view returns (uint256) {
469         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
470     }
471 
472 
473 
474     /**
475      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
476      */
477     function _getAux(address owner) internal view returns (uint64) {
478         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
479     }
480 
481     /**
482      * Returns the packed ownership data of `tokenId`.
483      */
484     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
485         uint256 curr = tokenId;
486 
487         unchecked {
488             if (_startTokenId() <= curr)
489                 if (curr < _currentIndex) {
490                     uint256 packed = _packedOwnerships[curr];
491                     // If not burned.
492                     if (packed & BITMASK_BURNED == 0) {
493                         // Invariant:
494                         // There will always be an ownership that has an address and is not burned
495                         // before an ownership that does not have an address and is not burned.
496                         // Hence, curr will not underflow.
497                         //
498                         // We can directly compare the packed value.
499                         // If the address is zero, packed is zero.
500                         while (packed == 0) {
501                             packed = _packedOwnerships[--curr];
502                         }
503                         return packed;
504                     }
505                 }
506         }
507         revert OwnerQueryForNonexistentToken();
508     }
509 
510     /**
511      * Returns the unpacked `TokenOwnership` struct from `packed`.
512      */
513     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
514         ownership.addr = address(uint160(packed));
515         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
516         ownership.burned = packed & BITMASK_BURNED != 0;
517     }
518 
519     /**
520      * Returns the unpacked `TokenOwnership` struct at `index`.
521      */
522     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
523         return _unpackedOwnership(_packedOwnerships[index]);
524     }
525 
526     /**
527      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
528      */
529     function _initializeOwnershipAt(uint256 index) internal {
530         if (_packedOwnerships[index] == 0) {
531             _packedOwnerships[index] = _packedOwnershipOf(index);
532         }
533     }
534 
535     /**
536      * Gas spent here starts off proportional to the maximum mint batch size.
537      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
538      */
539     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
540         return _unpackedOwnership(_packedOwnershipOf(tokenId));
541     }
542 
543     /**
544      * @dev See {IERC721-ownerOf}.
545      */
546     function ownerOf(uint256 tokenId) public view override returns (address) {
547         return address(uint160(_packedOwnershipOf(tokenId)));
548     }
549 
550     /**
551      * @dev See {IERC721Metadata-name}.
552      */
553     function name() public view virtual override returns (string memory) {
554         return _name;
555     }
556 
557     /**
558      * @dev See {IERC721Metadata-symbol}.
559      */
560     function symbol() public view virtual override returns (string memory) {
561         return _symbol;
562     }
563 
564     
565     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
566         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
567         string memory baseURI = _baseURI;
568         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId),".json")) : "";
569     }
570 
571     /**
572      * @dev Casts the address to uint256 without masking.
573      */
574     function _addressToUint256(address value) private pure returns (uint256 result) {
575         assembly {
576             result := value
577         }
578     }
579 
580     /**
581      * @dev Casts the boolean to uint256 without branching.
582      */
583     function _boolToUint256(bool value) private pure returns (uint256 result) {
584         assembly {
585             result := value
586         }
587     }
588 
589     /**
590      * @dev See {IERC721-approve}.
591      */
592     function approve(address to, uint256 tokenId) public override {
593         address owner = address(uint160(_packedOwnershipOf(tokenId)));
594         if (to == owner) revert();
595 
596         if (_msgSenderERC721A() != owner)
597             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
598                 revert ApprovalCallerNotOwnerNorApproved();
599             }
600 
601         _tokenApprovals[tokenId] = to;
602         emit Approval(owner, to, tokenId);
603     }
604 
605     /**
606      * @dev See {IERC721-getApproved}.
607      */
608     function getApproved(uint256 tokenId) public view override returns (address) {
609         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
610 
611         return _tokenApprovals[tokenId];
612     }
613 
614     /**
615      * @dev See {IERC721-setApprovalForAll}.
616      */
617     function setApprovalForAll(address operator, bool approved) public virtual override {
618         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
619 
620         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
621         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
622     }
623 
624     /**
625      * @dev See {IERC721-isApprovedForAll}.
626      */
627     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
628         return _operatorApprovals[owner][operator];
629     }
630 
631     /**
632      * @dev See {IERC721-transferFrom}.
633      */
634     function transferFrom(
635             address from,
636             address to,
637             uint256 tokenId
638             ) public virtual override {
639         _transfer(from, to, tokenId);
640     }
641 
642     /**
643      * @dev See {IERC721-safeTransferFrom}.
644      */
645     function safeTransferFrom(
646             address from,
647             address to,
648             uint256 tokenId
649             ) public virtual override {
650         safeTransferFrom(from, to, tokenId, '');
651     }
652 
653     /**
654      * @dev See {IERC721-safeTransferFrom}.
655      */
656     function safeTransferFrom(
657             address from,
658             address to,
659             uint256 tokenId,
660             bytes memory _data
661             ) public virtual override {
662         _transfer(from, to, tokenId);
663     }
664 
665     /**
666      * @dev Returns whether `tokenId` exists.
667      *
668      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
669      *
670      * Tokens start existing when they are minted (`_mint`),
671      */
672     function _exists(uint256 tokenId) internal view returns (bool) {
673         return
674             _startTokenId() <= tokenId &&
675             tokenId < _currentIndex;
676     }
677 
678   
679 
680     /**
681      * @dev Mints `quantity` tokens and transfers them to `to`.
682      *
683      * Requirements:
684      *
685      * - `to` cannot be the zero address.
686      * - `quantity` must be greater than 0.
687      *
688      * Emits a {Transfer} event.
689      */
690     function _mint(address to, uint256 quantity) internal {
691         uint256 startTokenId = _currentIndex;
692         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
693         if (quantity == 0) revert MintZeroQuantity();
694 
695 
696         // Overflows are incredibly unrealistic.
697         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
698         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
699         unchecked {
700             // Updates:
701             // - `balance += quantity`.
702             // - `numberMinted += quantity`.
703             //
704             // We can directly add to the balance and number minted.
705             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
706 
707             // Updates:
708             // - `address` to the owner.
709             // - `startTimestamp` to the timestamp of minting.
710             // - `burned` to `false`.
711             // - `nextInitialized` to `quantity == 1`.
712             _packedOwnerships[startTokenId] =
713                 _addressToUint256(to) |
714                 (block.timestamp << BITPOS_START_TIMESTAMP) |
715                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
716 
717             uint256 updatedIndex = startTokenId;
718             uint256 end = updatedIndex + quantity;
719 
720             do {
721                 emit Transfer(address(0), to, updatedIndex++);
722             } while (updatedIndex < end);
723 
724             _currentIndex = updatedIndex;
725         }
726         _afterTokenTransfers(address(0), to, startTokenId, quantity);
727     }
728 
729     /**
730      * @dev Transfers `tokenId` from `from` to `to`.
731      *
732      * Requirements:
733      *
734      * - `to` cannot be the zero address.
735      * - `tokenId` token must be owned by `from`.
736      *
737      * Emits a {Transfer} event.
738      */
739     function _transfer(
740             address from,
741             address to,
742             uint256 tokenId
743             ) private {
744 
745         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
746 
747         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
748 
749         address approvedAddress = _tokenApprovals[tokenId];
750 
751         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
752                 isApprovedForAll(from, _msgSenderERC721A()) ||
753                 approvedAddress == _msgSenderERC721A());
754 
755         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
756 
757 
758         // Clear approvals from the previous owner.
759         if (_addressToUint256(approvedAddress) != 0) {
760             delete _tokenApprovals[tokenId];
761         }
762 
763         // Underflow of the sender's balance is impossible because we check for
764         // ownership above and the recipient's balance can't realistically overflow.
765         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
766         unchecked {
767             // We can directly increment and decrement the balances.
768             --_packedAddressData[from]; // Updates: `balance -= 1`.
769             ++_packedAddressData[to]; // Updates: `balance += 1`.
770 
771             // Updates:
772             // - `address` to the next owner.
773             // - `startTimestamp` to the timestamp of transfering.
774             // - `burned` to `false`.
775             // - `nextInitialized` to `true`.
776             _packedOwnerships[tokenId] =
777                 _addressToUint256(to) |
778                 (block.timestamp << BITPOS_START_TIMESTAMP) |
779                 BITMASK_NEXT_INITIALIZED;
780 
781             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
782             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
783                 uint256 nextTokenId = tokenId + 1;
784                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
785                 if (_packedOwnerships[nextTokenId] == 0) {
786                     // If the next slot is within bounds.
787                     if (nextTokenId != _currentIndex) {
788                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
789                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
790                     }
791                 }
792             }
793         }
794 
795         emit Transfer(from, to, tokenId);
796         _afterTokenTransfers(from, to, tokenId, 1);
797     }
798 
799 
800 
801 
802     /**
803      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
804      * minting.
805      * And also called after one token has been burned.
806      *
807      * startTokenId - the first token id to be transferred
808      * quantity - the amount to be transferred
809      *
810      * Calling conditions:
811      *
812      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
813      * transferred to `to`.
814      * - When `from` is zero, `tokenId` has been minted for `to`.
815      * - When `to` is zero, `tokenId` has been burned by `from`.
816      * - `from` and `to` are never both zero.
817      */
818     function _afterTokenTransfers(
819             address from,
820             address to,
821             uint256 startTokenId,
822             uint256 quantity
823             ) internal virtual {}
824 
825     /**
826      * @dev Returns the message sender (defaults to `msg.sender`).
827      *
828      * If you are writing GSN compatible contracts, you need to override this function.
829      */
830     function _msgSenderERC721A() internal view virtual returns (address) {
831         return msg.sender;
832     }
833 
834     /**
835      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
836      */
837     function _toString(uint256 value) internal pure returns (string memory ptr) {
838         assembly {
839             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
840             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
841             // We will need 1 32-byte word to store the length, 
842             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
843             ptr := add(mload(0x40), 128)
844 
845          // Update the free memory pointer to allocate.
846          mstore(0x40, ptr)
847 
848          // Cache the end of the memory to calculate the length later.
849          let end := ptr
850 
851          // We write the string from the rightmost digit to the leftmost digit.
852          // The following is essentially a do-while loop that also handles the zero case.
853          // Costs a bit more than early returning for the zero case,
854          // but cheaper in terms of deployment and overall runtime costs.
855          for { 
856              // Initialize and perform the first pass without check.
857              let temp := value
858                  // Move the pointer 1 byte leftwards to point to an empty character slot.
859                  ptr := sub(ptr, 1)
860                  // Write the character to the pointer. 48 is the ASCII index of '0'.
861                  mstore8(ptr, add(48, mod(temp, 10)))
862                  temp := div(temp, 10)
863          } temp { 
864              // Keep dividing `temp` until zero.
865         temp := div(temp, 10)
866          } { 
867              // Body of the for loop.
868         ptr := sub(ptr, 1)
869          mstore8(ptr, add(48, mod(temp, 10)))
870          }
871 
872      let length := sub(end, ptr)
873          // Move the pointer 32 bytes leftwards to make room for the length.
874          ptr := sub(ptr, 32)
875          // Store the length.
876          mstore(ptr, length)
877         }
878     }
879 
880     function withdraw() external onlyOwner {
881         uint256 balance = address(this).balance;
882         payable(msg.sender).transfer(balance);
883     }
884 }