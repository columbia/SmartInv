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
287 contract Strokeskey is IERC721A { 
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
299     uint256 public constant MAX_SUPPLY = 720;
300     uint256 public MAX_FREE = 570;
301     uint256 public MAX_FREE_PER_WALLET = 1;
302     uint256 public COST = 0.001 ether;
303 
304     string private constant _name = "Strokeskey";
305     string private constant _symbol = "STROKESKEY";
306     string private _baseURI = "QmXcbdq3y1FPqVbAySX7uSU46qBEHXPQ7zJA8RXmjnK8ih";
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
317         require(amount <= 10, "max 10 per TX");
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
481      * Returns the packed ownership data of `tokenId`.
482      */
483     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
484         uint256 curr = tokenId;
485 
486         unchecked {
487             if (_startTokenId() <= curr)
488                 if (curr < _currentIndex) {
489                     uint256 packed = _packedOwnerships[curr];
490                     // If not burned.
491                     if (packed & BITMASK_BURNED == 0) {
492                         // Invariant:
493                         // There will always be an ownership that has an address and is not burned
494                         // before an ownership that does not have an address and is not burned.
495                         // Hence, curr will not underflow.
496                         //
497                         // We can directly compare the packed value.
498                         // If the address is zero, packed is zero.
499                         while (packed == 0) {
500                             packed = _packedOwnerships[--curr];
501                         }
502                         return packed;
503                     }
504                 }
505         }
506         revert OwnerQueryForNonexistentToken();
507     }
508 
509     /**
510      * Returns the unpacked `TokenOwnership` struct from `packed`.
511      */
512     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
513         ownership.addr = address(uint160(packed));
514         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
515         ownership.burned = packed & BITMASK_BURNED != 0;
516     }
517 
518     /**
519      * Returns the unpacked `TokenOwnership` struct at `index`.
520      */
521     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
522         return _unpackedOwnership(_packedOwnerships[index]);
523     }
524 
525     /**
526      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
527      */
528     function _initializeOwnershipAt(uint256 index) internal {
529         if (_packedOwnerships[index] == 0) {
530             _packedOwnerships[index] = _packedOwnershipOf(index);
531         }
532     }
533 
534     /**
535      * Gas spent here starts off proportional to the maximum mint batch size.
536      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
537      */
538     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
539         return _unpackedOwnership(_packedOwnershipOf(tokenId));
540     }
541 
542     /**
543      * @dev See {IERC721-ownerOf}.
544      */
545     function ownerOf(uint256 tokenId) public view override returns (address) {
546         return address(uint160(_packedOwnershipOf(tokenId)));
547     }
548 
549     /**
550      * @dev See {IERC721Metadata-name}.
551      */
552     function name() public view virtual override returns (string memory) {
553         return _name;
554     }
555 
556     /**
557      * @dev See {IERC721Metadata-symbol}.
558      */
559     function symbol() public view virtual override returns (string memory) {
560         return _symbol;
561     }
562 
563     
564     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
565         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
566         string memory baseURI = _baseURI;
567         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
568     }
569 
570     /**
571      * @dev Casts the address to uint256 without masking.
572      */
573     function _addressToUint256(address value) private pure returns (uint256 result) {
574         assembly {
575             result := value
576         }
577     }
578 
579     /**
580      * @dev Casts the boolean to uint256 without branching.
581      */
582     function _boolToUint256(bool value) private pure returns (uint256 result) {
583         assembly {
584             result := value
585         }
586     }
587 
588     /**
589      * @dev See {IERC721-approve}.
590      */
591     function approve(address to, uint256 tokenId) public override {
592         address owner = address(uint160(_packedOwnershipOf(tokenId)));
593         if (to == owner) revert();
594 
595         if (_msgSenderERC721A() != owner)
596             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
597                 revert ApprovalCallerNotOwnerNorApproved();
598             }
599 
600         _tokenApprovals[tokenId] = to;
601         emit Approval(owner, to, tokenId);
602     }
603 
604     /**
605      * @dev See {IERC721-getApproved}.
606      */
607     function getApproved(uint256 tokenId) public view override returns (address) {
608         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
609 
610         return _tokenApprovals[tokenId];
611     }
612 
613     /**
614      * @dev See {IERC721-setApprovalForAll}.
615      */
616     function setApprovalForAll(address operator, bool approved) public virtual override {
617         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
618 
619         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
620         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
621     }
622 
623     /**
624      * @dev See {IERC721-isApprovedForAll}.
625      */
626     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
627         return _operatorApprovals[owner][operator];
628     }
629 
630     /**
631      * @dev See {IERC721-transferFrom}.
632      */
633     function transferFrom(
634             address from,
635             address to,
636             uint256 tokenId
637             ) public virtual override {
638         _transfer(from, to, tokenId);
639     }
640 
641     /**
642      * @dev See {IERC721-safeTransferFrom}.
643      */
644     function safeTransferFrom(
645             address from,
646             address to,
647             uint256 tokenId
648             ) public virtual override {
649         safeTransferFrom(from, to, tokenId, '');
650     }
651 
652     /**
653      * @dev See {IERC721-safeTransferFrom}.
654      */
655     function safeTransferFrom(
656             address from,
657             address to,
658             uint256 tokenId,
659             bytes memory _data
660             ) public virtual override {
661         _transfer(from, to, tokenId);
662     }
663 
664     /**
665      * @dev Returns whether `tokenId` exists.
666      *
667      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
668      *
669      * Tokens start existing when they are minted (`_mint`),
670      */
671     function _exists(uint256 tokenId) internal view returns (bool) {
672         return
673             _startTokenId() <= tokenId &&
674             tokenId < _currentIndex;
675     }
676 
677   
678 
679     /**
680      * @dev Mints `quantity` tokens and transfers them to `to`.
681      *
682      * Requirements:
683      *
684      * - `to` cannot be the zero address.
685      * - `quantity` must be greater than 0.
686      *
687      * Emits a {Transfer} event.
688      */
689     function _mint(address to, uint256 quantity) internal {
690         uint256 startTokenId = _currentIndex;
691         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
692         if (quantity == 0) revert MintZeroQuantity();
693 
694 
695         // Overflows are incredibly unrealistic.
696         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
697         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
698         unchecked {
699             // Updates:
700             // - `balance += quantity`.
701             // - `numberMinted += quantity`.
702             //
703             // We can directly add to the balance and number minted.
704             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
705 
706             // Updates:
707             // - `address` to the owner.
708             // - `startTimestamp` to the timestamp of minting.
709             // - `burned` to `false`.
710             // - `nextInitialized` to `quantity == 1`.
711             _packedOwnerships[startTokenId] =
712                 _addressToUint256(to) |
713                 (block.timestamp << BITPOS_START_TIMESTAMP) |
714                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
715 
716             uint256 updatedIndex = startTokenId;
717             uint256 end = updatedIndex + quantity;
718 
719             do {
720                 emit Transfer(address(0), to, updatedIndex++);
721             } while (updatedIndex < end);
722 
723             _currentIndex = updatedIndex;
724         }
725         _afterTokenTransfers(address(0), to, startTokenId, quantity);
726     }
727 
728     /**
729      * @dev Transfers `tokenId` from `from` to `to`.
730      *
731      * Requirements:
732      *
733      * - `to` cannot be the zero address.
734      * - `tokenId` token must be owned by `from`.
735      *
736      * Emits a {Transfer} event.
737      */
738     function _transfer(
739             address from,
740             address to,
741             uint256 tokenId
742             ) private {
743 
744         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
745 
746         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
747 
748         address approvedAddress = _tokenApprovals[tokenId];
749 
750         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
751                 isApprovedForAll(from, _msgSenderERC721A()) ||
752                 approvedAddress == _msgSenderERC721A());
753 
754         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
755 
756 
757         // Clear approvals from the previous owner.
758         if (_addressToUint256(approvedAddress) != 0) {
759             delete _tokenApprovals[tokenId];
760         }
761 
762         // Underflow of the sender's balance is impossible because we check for
763         // ownership above and the recipient's balance can't realistically overflow.
764         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
765         unchecked {
766             // We can directly increment and decrement the balances.
767             --_packedAddressData[from]; // Updates: `balance -= 1`.
768             ++_packedAddressData[to]; // Updates: `balance += 1`.
769 
770             // Updates:
771             // - `address` to the next owner.
772             // - `startTimestamp` to the timestamp of transfering.
773             // - `burned` to `false`.
774             // - `nextInitialized` to `true`.
775             _packedOwnerships[tokenId] =
776                 _addressToUint256(to) |
777                 (block.timestamp << BITPOS_START_TIMESTAMP) |
778                 BITMASK_NEXT_INITIALIZED;
779 
780             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
781             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
782                 uint256 nextTokenId = tokenId + 1;
783                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
784                 if (_packedOwnerships[nextTokenId] == 0) {
785                     // If the next slot is within bounds.
786                     if (nextTokenId != _currentIndex) {
787                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
788                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
789                     }
790                 }
791             }
792         }
793 
794         emit Transfer(from, to, tokenId);
795         _afterTokenTransfers(from, to, tokenId, 1);
796     }
797 
798 
799 
800 
801     /**
802      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
803      * minting.
804      * And also called after one token has been burned.
805      *
806      * startTokenId - the first token id to be transferred
807      * quantity - the amount to be transferred
808      *
809      * Calling conditions:
810      *
811      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
812      * transferred to `to`.
813      * - When `from` is zero, `tokenId` has been minted for `to`.
814      * - When `to` is zero, `tokenId` has been burned by `from`.
815      * - `from` and `to` are never both zero.
816      */
817     function _afterTokenTransfers(
818             address from,
819             address to,
820             uint256 startTokenId,
821             uint256 quantity
822             ) internal virtual {}
823 
824     /**
825      * @dev Returns the message sender (defaults to `msg.sender`).
826      *
827      * If you are writing GSN compatible contracts, you need to override this function.
828      */
829     function _msgSenderERC721A() internal view virtual returns (address) {
830         return msg.sender;
831     }
832 
833     /**
834      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
835      */
836     function _toString(uint256 value) internal pure returns (string memory ptr) {
837         assembly {
838             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
839             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
840             // We will need 1 32-byte word to store the length, 
841             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
842             ptr := add(mload(0x40), 128)
843 
844          // Update the free memory pointer to allocate.
845          mstore(0x40, ptr)
846 
847          // Cache the end of the memory to calculate the length later.
848          let end := ptr
849 
850          // We write the string from the rightmost digit to the leftmost digit.
851          // The following is essentially a do-while loop that also handles the zero case.
852          // Costs a bit more than early returning for the zero case,
853          // but cheaper in terms of deployment and overall runtime costs.
854          for { 
855              // Initialize and perform the first pass without check.
856              let temp := value
857                  // Move the pointer 1 byte leftwards to point to an empty character slot.
858                  ptr := sub(ptr, 1)
859                  // Write the character to the pointer. 48 is the ASCII index of '0'.
860                  mstore8(ptr, add(48, mod(temp, 10)))
861                  temp := div(temp, 10)
862          } temp { 
863              // Keep dividing `temp` until zero.
864         temp := div(temp, 10)
865          } { 
866              // Body of the for loop.
867         ptr := sub(ptr, 1)
868          mstore8(ptr, add(48, mod(temp, 10)))
869          }
870 
871      let length := sub(end, ptr)
872          // Move the pointer 32 bytes leftwards to make room for the length.
873          ptr := sub(ptr, 32)
874          // Store the length.
875          mstore(ptr, length)
876         }
877     }
878 
879     function withdraw() external onlyOwner {
880         uint256 balance = address(this).balance;
881         payable(msg.sender).transfer(balance);
882     }
883 }