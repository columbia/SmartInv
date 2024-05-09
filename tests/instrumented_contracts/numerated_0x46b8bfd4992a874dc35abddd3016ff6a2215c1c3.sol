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
287 contract Smolrocks is IERC721A { 
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
299     uint256 public constant MAX_SUPPLY = 555;
300     uint256 public MAX_FREE = 300;
301     uint256 public MAX_FREE_PER_WALLET = 1;
302     uint256 public COST = 0.002 ether;
303 
304     string private constant _name = "Smolrocks";
305     string private constant _symbol = "Smolrocks";
306     string private _baseURI = "0x510D1ed047e784Fc9E37486379E81687Cb5D1D52";
307 
308     constructor() {
309         _owner = msg.sender;
310     }
311 
312     function mint(uint256 amount) external payable{
313         address _caller = _msgSenderERC721A();
314 
315         require(totalSupply() + amount <= MAX_SUPPLY, "Sold Out");
316         require(amount*COST <= msg.value, "Value to Low");
317 
318         _mint(_caller, amount);
319     }
320 
321     function freeMint() external{
322         address _caller = _msgSenderERC721A();
323         uint256 amount = 1;
324 
325         require(totalSupply() + amount <= MAX_FREE, "Freemint Sold Out");
326         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "Max per Wallet");
327 
328         _mint(_caller, amount);
329     }
330 
331     // Mask of an entry in packed address data.
332     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
333 
334     // The bit position of `numberMinted` in packed address data.
335     uint256 private constant BITPOS_NUMBER_MINTED = 64;
336 
337     // The bit position of `numberBurned` in packed address data.
338     uint256 private constant BITPOS_NUMBER_BURNED = 128;
339 
340     // The bit position of `aux` in packed address data.
341     uint256 private constant BITPOS_AUX = 192;
342 
343     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
344     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
345 
346     // The bit position of `startTimestamp` in packed ownership.
347     uint256 private constant BITPOS_START_TIMESTAMP = 160;
348 
349     // The bit mask of the `burned` bit in packed ownership.
350     uint256 private constant BITMASK_BURNED = 1 << 224;
351 
352     // The bit position of the `nextInitialized` bit in packed ownership.
353     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
354 
355     // The bit mask of the `nextInitialized` bit in packed ownership.
356     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
357 
358     // The tokenId of the next token to be minted.
359     uint256 private _currentIndex = 0;
360 
361     // The number of tokens burned.
362     // uint256 private _burnCounter;
363 
364 
365     // Mapping from token ID to ownership details
366     // An empty struct value does not necessarily mean the token is unowned.
367     // See `_packedOwnershipOf` implementation for details.
368     //
369     // Bits Layout:
370     // - [0..159] `addr`
371     // - [160..223] `startTimestamp`
372     // - [224] `burned`
373     // - [225] `nextInitialized`
374     mapping(uint256 => uint256) private _packedOwnerships;
375 
376     // Mapping owner address to address data.
377     //
378     // Bits Layout:
379     // - [0..63] `balance`
380     // - [64..127] `numberMinted`
381     // - [128..191] `numberBurned`
382     // - [192..255] `aux`
383     mapping(address => uint256) private _packedAddressData;
384 
385     // Mapping from token ID to approved address.
386     mapping(uint256 => address) private _tokenApprovals;
387 
388     // Mapping from owner to operator approvals
389     mapping(address => mapping(address => bool)) private _operatorApprovals;
390 
391 
392     function setData(string memory _base) external onlyOwner{
393         _baseURI = _base;
394     }
395 
396     function setConfig(uint256 _MAX_FREE_PER_WALLET, uint256 _COST, uint256 _MAX_FREE) external onlyOwner{
397         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
398         COST = _COST;
399         MAX_FREE = _MAX_FREE;
400     }
401 
402     /**
403      * @dev Returns the starting token ID. 
404      * To change the starting token ID, please override this function.
405      */
406     function _startTokenId() internal view virtual returns (uint256) {
407         return 0;
408     }
409 
410     /**
411      * @dev Returns the next token ID to be minted.
412      */
413     function _nextTokenId() internal view returns (uint256) {
414         return _currentIndex;
415     }
416 
417     /**
418      * @dev Returns the total number of tokens in existence.
419      * Burned tokens will reduce the count. 
420      * To get the total number of tokens minted, please see `_totalMinted`.
421      */
422     function totalSupply() public view override returns (uint256) {
423         // Counter underflow is impossible as _burnCounter cannot be incremented
424         // more than `_currentIndex - _startTokenId()` times.
425         unchecked {
426             return _currentIndex - _startTokenId();
427         }
428     }
429 
430     /**
431      * @dev Returns the total amount of tokens minted in the contract.
432      */
433     function _totalMinted() internal view returns (uint256) {
434         // Counter underflow is impossible as _currentIndex does not decrement,
435         // and it is initialized to `_startTokenId()`
436         unchecked {
437             return _currentIndex - _startTokenId();
438         }
439     }
440 
441 
442     /**
443      * @dev See {IERC165-supportsInterface}.
444      */
445     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
446         // The interface IDs are constants representing the first 4 bytes of the XOR of
447         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
448         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
449         return
450             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
451             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
452             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
453     }
454 
455     /**
456      * @dev See {IERC721-balanceOf}.
457      */
458     function balanceOf(address owner) public view override returns (uint256) {
459         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
460         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
461     }
462 
463     /**
464      * Returns the number of tokens minted by `owner`.
465      */
466     function _numberMinted(address owner) internal view returns (uint256) {
467         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
468     }
469 
470 
471 
472     /**
473      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
474      */
475     function _getAux(address owner) internal view returns (uint64) {
476         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
477     }
478 
479     /**
480      * Returns the packed ownership data of `tokenId`.
481      */
482     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
483         uint256 curr = tokenId;
484 
485         unchecked {
486             if (_startTokenId() <= curr)
487                 if (curr < _currentIndex) {
488                     uint256 packed = _packedOwnerships[curr];
489                     // If not burned.
490                     if (packed & BITMASK_BURNED == 0) {
491                         // Invariant:
492                         // There will always be an ownership that has an address and is not burned
493                         // before an ownership that does not have an address and is not burned.
494                         // Hence, curr will not underflow.
495                         //
496                         // We can directly compare the packed value.
497                         // If the address is zero, packed is zero.
498                         while (packed == 0) {
499                             packed = _packedOwnerships[--curr];
500                         }
501                         return packed;
502                     }
503                 }
504         }
505         revert OwnerQueryForNonexistentToken();
506     }
507 
508     /**
509      * Returns the unpacked `TokenOwnership` struct from `packed`.
510      */
511     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
512         ownership.addr = address(uint160(packed));
513         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
514         ownership.burned = packed & BITMASK_BURNED != 0;
515     }
516 
517     /**
518      * Returns the unpacked `TokenOwnership` struct at `index`.
519      */
520     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
521         return _unpackedOwnership(_packedOwnerships[index]);
522     }
523 
524     /**
525      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
526      */
527     function _initializeOwnershipAt(uint256 index) internal {
528         if (_packedOwnerships[index] == 0) {
529             _packedOwnerships[index] = _packedOwnershipOf(index);
530         }
531     }
532 
533     /**
534      * Gas spent here starts off proportional to the maximum mint batch size.
535      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
536      */
537     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
538         return _unpackedOwnership(_packedOwnershipOf(tokenId));
539     }
540 
541     /**
542      * @dev See {IERC721-ownerOf}.
543      */
544     function ownerOf(uint256 tokenId) public view override returns (address) {
545         return address(uint160(_packedOwnershipOf(tokenId)));
546     }
547 
548     /**
549      * @dev See {IERC721Metadata-name}.
550      */
551     function name() public view virtual override returns (string memory) {
552         return _name;
553     }
554 
555     /**
556      * @dev See {IERC721Metadata-symbol}.
557      */
558     function symbol() public view virtual override returns (string memory) {
559         return _symbol;
560     }
561 
562     
563     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
564         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
565         string memory baseURI = _baseURI;
566         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
567     }
568 
569     /**
570      * @dev Casts the address to uint256 without masking.
571      */
572     function _addressToUint256(address value) private pure returns (uint256 result) {
573         assembly {
574             result := value
575         }
576     }
577 
578     /**
579      * @dev Casts the boolean to uint256 without branching.
580      */
581     function _boolToUint256(bool value) private pure returns (uint256 result) {
582         assembly {
583             result := value
584         }
585     }
586 
587     /**
588      * @dev See {IERC721-approve}.
589      */
590     function approve(address to, uint256 tokenId) public override {
591         address owner = address(uint160(_packedOwnershipOf(tokenId)));
592         if (to == owner) revert();
593 
594         if (_msgSenderERC721A() != owner)
595             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
596                 revert ApprovalCallerNotOwnerNorApproved();
597             }
598 
599         _tokenApprovals[tokenId] = to;
600         emit Approval(owner, to, tokenId);
601     }
602 
603     /**
604      * @dev See {IERC721-getApproved}.
605      */
606     function getApproved(uint256 tokenId) public view override returns (address) {
607         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
608 
609         return _tokenApprovals[tokenId];
610     }
611 
612     /**
613      * @dev See {IERC721-setApprovalForAll}.
614      */
615     function setApprovalForAll(address operator, bool approved) public virtual override {
616         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
617 
618         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
619         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
620     }
621 
622     /**
623      * @dev See {IERC721-isApprovedForAll}.
624      */
625     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
626         return _operatorApprovals[owner][operator];
627     }
628 
629     /**
630      * @dev See {IERC721-transferFrom}.
631      */
632     function transferFrom(
633             address from,
634             address to,
635             uint256 tokenId
636             ) public virtual override {
637         _transfer(from, to, tokenId);
638     }
639 
640     /**
641      * @dev See {IERC721-safeTransferFrom}.
642      */
643     function safeTransferFrom(
644             address from,
645             address to,
646             uint256 tokenId
647             ) public virtual override {
648         safeTransferFrom(from, to, tokenId, '');
649     }
650 
651     /**
652      * @dev See {IERC721-safeTransferFrom}.
653      */
654     function safeTransferFrom(
655             address from,
656             address to,
657             uint256 tokenId,
658             bytes memory _data
659             ) public virtual override {
660         _transfer(from, to, tokenId);
661     }
662 
663     /**
664      * @dev Returns whether `tokenId` exists.
665      *
666      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
667      *
668      * Tokens start existing when they are minted (`_mint`),
669      */
670     function _exists(uint256 tokenId) internal view returns (bool) {
671         return
672             _startTokenId() <= tokenId &&
673             tokenId < _currentIndex;
674     }
675 
676   
677 
678     /**
679      * @dev Mints `quantity` tokens and transfers them to `to`.
680      *
681      * Requirements:
682      *
683      * - `to` cannot be the zero address.
684      * - `quantity` must be greater than 0.
685      *
686      * Emits a {Transfer} event.
687      */
688     function _mint(address to, uint256 quantity) internal {
689         uint256 startTokenId = _currentIndex;
690         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
691         if (quantity == 0) revert MintZeroQuantity();
692 
693 
694         // Overflows are incredibly unrealistic.
695         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
696         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
697         unchecked {
698             // Updates:
699             // - `balance += quantity`.
700             // - `numberMinted += quantity`.
701             //
702             // We can directly add to the balance and number minted.
703             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
704 
705             // Updates:
706             // - `address` to the owner.
707             // - `startTimestamp` to the timestamp of minting.
708             // - `burned` to `false`.
709             // - `nextInitialized` to `quantity == 1`.
710             _packedOwnerships[startTokenId] =
711                 _addressToUint256(to) |
712                 (block.timestamp << BITPOS_START_TIMESTAMP) |
713                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
714 
715             uint256 updatedIndex = startTokenId;
716             uint256 end = updatedIndex + quantity;
717 
718             do {
719                 emit Transfer(address(0), to, updatedIndex++);
720             } while (updatedIndex < end);
721 
722             _currentIndex = updatedIndex;
723         }
724         _afterTokenTransfers(address(0), to, startTokenId, quantity);
725     }
726 
727     /**
728      * @dev Transfers `tokenId` from `from` to `to`.
729      *
730      * Requirements:
731      *
732      * - `to` cannot be the zero address.
733      * - `tokenId` token must be owned by `from`.
734      *
735      * Emits a {Transfer} event.
736      */
737     function _transfer(
738             address from,
739             address to,
740             uint256 tokenId
741             ) private {
742 
743         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
744 
745         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
746 
747         address approvedAddress = _tokenApprovals[tokenId];
748 
749         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
750                 isApprovedForAll(from, _msgSenderERC721A()) ||
751                 approvedAddress == _msgSenderERC721A());
752 
753         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
754 
755 
756         // Clear approvals from the previous owner.
757         if (_addressToUint256(approvedAddress) != 0) {
758             delete _tokenApprovals[tokenId];
759         }
760 
761         // Underflow of the sender's balance is impossible because we check for
762         // ownership above and the recipient's balance can't realistically overflow.
763         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
764         unchecked {
765             // We can directly increment and decrement the balances.
766             --_packedAddressData[from]; // Updates: `balance -= 1`.
767             ++_packedAddressData[to]; // Updates: `balance += 1`.
768 
769             // Updates:
770             // - `address` to the next owner.
771             // - `startTimestamp` to the timestamp of transfering.
772             // - `burned` to `false`.
773             // - `nextInitialized` to `true`.
774             _packedOwnerships[tokenId] =
775                 _addressToUint256(to) |
776                 (block.timestamp << BITPOS_START_TIMESTAMP) |
777                 BITMASK_NEXT_INITIALIZED;
778 
779             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
780             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
781                 uint256 nextTokenId = tokenId + 1;
782                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
783                 if (_packedOwnerships[nextTokenId] == 0) {
784                     // If the next slot is within bounds.
785                     if (nextTokenId != _currentIndex) {
786                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
787                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
788                     }
789                 }
790             }
791         }
792 
793         emit Transfer(from, to, tokenId);
794         _afterTokenTransfers(from, to, tokenId, 1);
795     }
796 
797 
798 
799 
800     /**
801      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
802      * minting.
803      * And also called after one token has been burned.
804      *
805      * startTokenId - the first token id to be transferred
806      * quantity - the amount to be transferred
807      *
808      * Calling conditions:
809      *
810      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
811      * transferred to `to`.
812      * - When `from` is zero, `tokenId` has been minted for `to`.
813      * - When `to` is zero, `tokenId` has been burned by `from`.
814      * - `from` and `to` are never both zero.
815      */
816     function _afterTokenTransfers(
817             address from,
818             address to,
819             uint256 startTokenId,
820             uint256 quantity
821             ) internal virtual {}
822 
823     /**
824      * @dev Returns the message sender (defaults to `msg.sender`).
825      *
826      * If you are writing GSN compatible contracts, you need to override this function.
827      */
828     function _msgSenderERC721A() internal view virtual returns (address) {
829         return msg.sender;
830     }
831 
832     /**
833      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
834      */
835     function _toString(uint256 value) internal pure returns (string memory ptr) {
836         assembly {
837             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
838             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
839             // We will need 1 32-byte word to store the length, 
840             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
841             ptr := add(mload(0x40), 128)
842 
843          // Update the free memory pointer to allocate.
844          mstore(0x40, ptr)
845 
846          // Cache the end of the memory to calculate the length later.
847          let end := ptr
848 
849          // We write the string from the rightmost digit to the leftmost digit.
850          // The following is essentially a do-while loop that also handles the zero case.
851          // Costs a bit more than early returning for the zero case,
852          // but cheaper in terms of deployment and overall runtime costs.
853          for { 
854              // Initialize and perform the first pass without check.
855              let temp := value
856                  // Move the pointer 1 byte leftwards to point to an empty character slot.
857                  ptr := sub(ptr, 1)
858                  // Write the character to the pointer. 48 is the ASCII index of '0'.
859                  mstore8(ptr, add(48, mod(temp, 10)))
860                  temp := div(temp, 10)
861          } temp { 
862              // Keep dividing `temp` until zero.
863         temp := div(temp, 10)
864          } { 
865              // Body of the for loop.
866         ptr := sub(ptr, 1)
867          mstore8(ptr, add(48, mod(temp, 10)))
868          }
869 
870      let length := sub(end, ptr)
871          // Move the pointer 32 bytes leftwards to make room for the length.
872          ptr := sub(ptr, 32)
873          // Store the length.
874          mstore(ptr, length)
875         }
876     }
877 
878     function withdraw() external onlyOwner {
879         uint256 balance = address(this).balance;
880         payable(msg.sender).transfer(balance);
881     }
882 }