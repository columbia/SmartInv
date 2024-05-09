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
126     event Transfer(
127         address indexed from,
128         address indexed to,
129         uint256 indexed tokenId
130     );
131 
132     /**
133      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
134      */
135     event Approval(
136         address indexed owner,
137         address indexed approved,
138         uint256 indexed tokenId
139     );
140 
141     /**
142      * @dev Emitted when `owner` enables or disables
143      * (`approved`) `operator` to manage all of its assets.
144      */
145     event ApprovalForAll(
146         address indexed owner,
147         address indexed operator,
148         bool approved
149     );
150 
151     /**
152      * @dev Returns the number of tokens in `owner`'s account.
153      */
154     function balanceOf(address owner) external view returns (uint256 balance);
155 
156     /**
157      * @dev Returns the owner of the `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function ownerOf(uint256 tokenId) external view returns (address owner);
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`,
167      * checking first that contract recipients are aware of the ERC721 protocol
168      * to prevent tokens from being forever locked.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must exist and be owned by `from`.
175      * - If the caller is not `from`, it must be have been allowed to move
176      * this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement
178      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId,
186         bytes calldata data
187     ) external;
188 
189     /**
190      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
191      */
192     function safeTransferFrom(
193         address from,
194         address to,
195         uint256 tokenId
196     ) external;
197 
198     /**
199      * @dev Transfers `tokenId` from `from` to `to`.
200      *
201      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
202      * whenever possible.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must be owned by `from`.
209      * - If the caller is not `from`, it must be approved to move this token
210      * by either {approve} or {setApprovalForAll}.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external;
219 
220     /**
221      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
222      * The approval is cleared when the token is transferred.
223      *
224      * Only a single account can be approved at a time, so approving the
225      * zero address clears previous approvals.
226      *
227      * Requirements:
228      *
229      * - The caller must own the token or be an approved operator.
230      * - `tokenId` must exist.
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address to, uint256 tokenId) external;
235 
236     /**
237      * @dev Approve or remove `operator` as an operator for the caller.
238      * Operators can call {transferFrom} or {safeTransferFrom}
239      * for any token owned by the caller.
240      *
241      * Requirements:
242      *
243      * - The `operator` cannot be the caller.
244      *
245      * Emits an {ApprovalForAll} event.
246      */
247     function setApprovalForAll(address operator, bool _approved) external;
248 
249     /**
250      * @dev Returns the account approved for `tokenId` token.
251      *
252      * Requirements:
253      *
254      * - `tokenId` must exist.
255      */
256     function getApproved(uint256 tokenId)
257         external
258         view
259         returns (address operator);
260 
261     /**
262      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
263      *
264      * See {setApprovalForAll}.
265      */
266     function isApprovedForAll(address owner, address operator)
267         external
268         view
269         returns (bool);
270 
271     // =============================================================
272     //                        IERC721Metadata
273     // =============================================================
274 
275     /**
276      * @dev Returns the token collection name.
277      */
278     function name() external view returns (string memory);
279 
280     /**
281      * @dev Returns the token collection symbol.
282      */
283     function symbol() external view returns (string memory);
284 
285     /**
286      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
287      */
288     function tokenURI(uint256 tokenId) external view returns (string memory);
289 
290     // =============================================================
291     //                           IERC2309
292     // =============================================================
293 
294     /**
295      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
296      * (inclusive) is transferred from `from` to `to`, as defined in the
297      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
298      *
299      * See {_mintERC2309} for more details.
300      */
301     event ConsecutiveTransfer(
302         uint256 indexed fromTokenId,
303         uint256 toTokenId,
304         address indexed from,
305         address indexed to
306     );
307 }
308 
309 contract Daruma is IERC721A {
310     address private _owner;
311 
312     function owner() public view returns (address) {
313         return _owner;
314     }
315 
316     modifier onlyOwner() {
317         require(_owner == msg.sender);
318         _;
319     }
320 
321     uint256 public constant MAX_SUPPLY = 1500;
322     uint256 public MAX_FREE = 1500;
323     uint256 public MAX_FREE_PER_WALLET = 1;
324     uint256 public COST = 0.001 ether;
325 
326     string private constant _name = "DarumaPix";
327     string private constant _symbol = "DARUMA";
328     string private _baseURI = "bafybeibpzq2o5tleqajzrlzxawk62gvps4qajcuiha66vpx5bwk6fxaugm";
329 
330     constructor() {
331         _owner = msg.sender;
332     }
333 
334     function mint(uint256 amount) external payable {
335         address _caller = _msgSenderERC721A();
336 
337         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
338         require(amount * COST <= msg.value, "Value to Low");
339         require(amount <= 5, "max 5 per TX");
340 
341         _mint(_caller, amount);
342     }
343 
344     function freeMint() external {
345         address _caller = _msgSenderERC721A();
346         uint256 amount = 1;
347 
348         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
349         require(
350             amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET,
351             "Max per Wallet"
352         );
353 
354         _mint(_caller, amount);
355     }
356 
357     // Mask of an entry in packed address data.
358     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
359 
360     // The bit position of `numberMinted` in packed address data.
361     uint256 private constant BITPOS_NUMBER_MINTED = 64;
362 
363     // The bit position of `numberBurned` in packed address data.
364     uint256 private constant BITPOS_NUMBER_BURNED = 128;
365 
366     // The bit position of `aux` in packed address data.
367     uint256 private constant BITPOS_AUX = 192;
368 
369     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
370     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
371 
372     // The bit position of `startTimestamp` in packed ownership.
373     uint256 private constant BITPOS_START_TIMESTAMP = 160;
374 
375     // The bit mask of the `burned` bit in packed ownership.
376     uint256 private constant BITMASK_BURNED = 1 << 224;
377 
378     // The bit position of the `nextInitialized` bit in packed ownership.
379     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
380 
381     // The bit mask of the `nextInitialized` bit in packed ownership.
382     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
383 
384     // The tokenId of the next token to be minted.
385     uint256 private _currentIndex = 0;
386 
387     // The number of tokens burned.
388     // uint256 private _burnCounter;
389 
390     // Mapping from token ID to ownership details
391     // An empty struct value does not necessarily mean the token is unowned.
392     // See `_packedOwnershipOf` implementation for details.
393     //
394     // Bits Layout:
395     // - [0..159] `addr`
396     // - [160..223] `startTimestamp`
397     // - [224] `burned`
398     // - [225] `nextInitialized`
399     mapping(uint256 => uint256) private _packedOwnerships;
400 
401     // Mapping owner address to address data.
402     //
403     // Bits Layout:
404     // - [0..63] `balance`
405     // - [64..127] `numberMinted`
406     // - [128..191] `numberBurned`
407     // - [192..255] `aux`
408     mapping(address => uint256) private _packedAddressData;
409 
410     // Mapping from token ID to approved address.
411     mapping(uint256 => address) private _tokenApprovals;
412 
413     // Mapping from owner to operator approvals
414     mapping(address => mapping(address => bool)) private _operatorApprovals;
415 
416     function setData(string memory _base) external onlyOwner {
417         _baseURI = _base;
418     }
419 
420     function setConfig(
421         uint256 _MAX_FREE_PER_WALLET,
422         uint256 _COST,
423         uint256 _MAX_FREE
424     ) external onlyOwner {
425         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
426         COST = _COST;
427         MAX_FREE = _MAX_FREE;
428     }
429 
430     /**
431      * @dev Returns the starting token ID.
432      * To change the starting token ID, please override this function.
433      */
434     function _startTokenId() internal view virtual returns (uint256) {
435         return 0;
436     }
437 
438     /**
439      * @dev Returns the next token ID to be minted.
440      */
441     function _nextTokenId() internal view returns (uint256) {
442         return _currentIndex;
443     }
444 
445     /**
446      * @dev Returns the total number of tokens in existence.
447      * Burned tokens will reduce the count.
448      * To get the total number of tokens minted, please see `_totalMinted`.
449      */
450     function totalSupply() public view override returns (uint256) {
451         // Counter underflow is impossible as _burnCounter cannot be incremented
452         // more than `_currentIndex - _startTokenId()` times.
453         unchecked {
454             return _currentIndex - _startTokenId();
455         }
456     }
457 
458     /**
459      * @dev Returns the total amount of tokens minted in the contract.
460      */
461     function _totalMinted() internal view returns (uint256) {
462         // Counter underflow is impossible as _currentIndex does not decrement,
463         // and it is initialized to `_startTokenId()`
464         unchecked {
465             return _currentIndex - _startTokenId();
466         }
467     }
468 
469     /**
470      * @dev See {IERC165-supportsInterface}.
471      */
472     function supportsInterface(bytes4 interfaceId)
473         public
474         view
475         virtual
476         override
477         returns (bool)
478     {
479         // The interface IDs are constants representing the first 4 bytes of the XOR of
480         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
481         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
482         return
483             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
484             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
485             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
486     }
487 
488     /**
489      * @dev See {IERC721-balanceOf}.
490      */
491     function balanceOf(address owner) public view override returns (uint256) {
492         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
493         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
494     }
495 
496     /**
497      * Returns the number of tokens minted by `owner`.
498      */
499     function _numberMinted(address owner) internal view returns (uint256) {
500         return
501             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
502             BITMASK_ADDRESS_DATA_ENTRY;
503     }
504 
505     /**
506      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
507      */
508     function _getAux(address owner) internal view returns (uint64) {
509         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
510     }
511 
512     /**
513      * Returns the packed ownership data of `tokenId`.
514      */
515     function _packedOwnershipOf(uint256 tokenId)
516         private
517         view
518         returns (uint256)
519     {
520         uint256 curr = tokenId;
521 
522         unchecked {
523             if (_startTokenId() <= curr)
524                 if (curr < _currentIndex) {
525                     uint256 packed = _packedOwnerships[curr];
526                     // If not burned.
527                     if (packed & BITMASK_BURNED == 0) {
528                         // Invariant:
529                         // There will always be an ownership that has an address and is not burned
530                         // before an ownership that does not have an address and is not burned.
531                         // Hence, curr will not underflow.
532                         //
533                         // We can directly compare the packed value.
534                         // If the address is zero, packed is zero.
535                         while (packed == 0) {
536                             packed = _packedOwnerships[--curr];
537                         }
538                         return packed;
539                     }
540                 }
541         }
542         revert OwnerQueryForNonexistentToken();
543     }
544 
545     /**
546      * Returns the unpacked `TokenOwnership` struct from `packed`.
547      */
548     function _unpackedOwnership(uint256 packed)
549         private
550         pure
551         returns (TokenOwnership memory ownership)
552     {
553         ownership.addr = address(uint160(packed));
554         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
555         ownership.burned = packed & BITMASK_BURNED != 0;
556     }
557 
558     /**
559      * Returns the unpacked `TokenOwnership` struct at `index`.
560      */
561     function _ownershipAt(uint256 index)
562         internal
563         view
564         returns (TokenOwnership memory)
565     {
566         return _unpackedOwnership(_packedOwnerships[index]);
567     }
568 
569     /**
570      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
571      */
572     function _initializeOwnershipAt(uint256 index) internal {
573         if (_packedOwnerships[index] == 0) {
574             _packedOwnerships[index] = _packedOwnershipOf(index);
575         }
576     }
577 
578     /**
579      * Gas spent here starts off proportional to the maximum mint batch size.
580      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
581      */
582     function _ownershipOf(uint256 tokenId)
583         internal
584         view
585         returns (TokenOwnership memory)
586     {
587         return _unpackedOwnership(_packedOwnershipOf(tokenId));
588     }
589 
590     /**
591      * @dev See {IERC721-ownerOf}.
592      */
593     function ownerOf(uint256 tokenId) public view override returns (address) {
594         return address(uint160(_packedOwnershipOf(tokenId)));
595     }
596 
597     /**
598      * @dev See {IERC721Metadata-name}.
599      */
600     function name() public view virtual override returns (string memory) {
601         return _name;
602     }
603 
604     /**
605      * @dev See {IERC721Metadata-symbol}.
606      */
607     function symbol() public view virtual override returns (string memory) {
608         return _symbol;
609     }
610 
611     function tokenURI(uint256 tokenId)
612         public
613         view
614         virtual
615         override
616         returns (string memory)
617     {
618         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
619         string memory baseURI = _baseURI;
620         return
621             bytes(baseURI).length != 0
622                 ? string(
623                     abi.encodePacked(
624                         "ipfs://",
625                         baseURI,
626                         "/",
627                         _toString(tokenId),
628                         ".json"
629                     )
630                 )
631                 : "";
632     }
633 
634     /**
635      * @dev Casts the address to uint256 without masking.
636      */
637     function _addressToUint256(address value)
638         private
639         pure
640         returns (uint256 result)
641     {
642         assembly {
643             result := value
644         }
645     }
646 
647     /**
648      * @dev Casts the boolean to uint256 without branching.
649      */
650     function _boolToUint256(bool value) private pure returns (uint256 result) {
651         assembly {
652             result := value
653         }
654     }
655 
656     /**
657      * @dev See {IERC721-approve}.
658      */
659     function approve(address to, uint256 tokenId) public override {
660         address owner = address(uint160(_packedOwnershipOf(tokenId)));
661         if (to == owner) revert();
662 
663         if (_msgSenderERC721A() != owner)
664             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
665                 revert ApprovalCallerNotOwnerNorApproved();
666             }
667 
668         _tokenApprovals[tokenId] = to;
669         emit Approval(owner, to, tokenId);
670     }
671 
672     /**
673      * @dev See {IERC721-getApproved}.
674      */
675     function getApproved(uint256 tokenId)
676         public
677         view
678         override
679         returns (address)
680     {
681         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
682 
683         return _tokenApprovals[tokenId];
684     }
685 
686     /**
687      * @dev See {IERC721-setApprovalForAll}.
688      */
689     function setApprovalForAll(address operator, bool approved)
690         public
691         virtual
692         override
693     {
694         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
695 
696         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
697         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
698     }
699 
700     /**
701      * @dev See {IERC721-isApprovedForAll}.
702      */
703     function isApprovedForAll(address owner, address operator)
704         public
705         view
706         virtual
707         override
708         returns (bool)
709     {
710         return _operatorApprovals[owner][operator];
711     }
712 
713     /**
714      * @dev See {IERC721-transferFrom}.
715      */
716     function transferFrom(
717         address from,
718         address to,
719         uint256 tokenId
720     ) public virtual override {
721         _transfer(from, to, tokenId);
722     }
723 
724     /**
725      * @dev See {IERC721-safeTransferFrom}.
726      */
727     function safeTransferFrom(
728         address from,
729         address to,
730         uint256 tokenId
731     ) public virtual override {
732         safeTransferFrom(from, to, tokenId, "");
733     }
734 
735     /**
736      * @dev See {IERC721-safeTransferFrom}.
737      */
738     function safeTransferFrom(
739         address from,
740         address to,
741         uint256 tokenId,
742         bytes memory _data
743     ) public virtual override {
744         _transfer(from, to, tokenId);
745     }
746 
747     /**
748      * @dev Returns whether `tokenId` exists.
749      *
750      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
751      *
752      * Tokens start existing when they are minted (`_mint`),
753      */
754     function _exists(uint256 tokenId) internal view returns (bool) {
755         return _startTokenId() <= tokenId && tokenId < _currentIndex;
756     }
757 
758     /**
759      * @dev Mints `quantity` tokens and transfers them to `to`.
760      *
761      * Requirements:
762      *
763      * - `to` cannot be the zero address.
764      * - `quantity` must be greater than 0.
765      *
766      * Emits a {Transfer} event.
767      */
768     function _mint(address to, uint256 quantity) internal {
769         uint256 startTokenId = _currentIndex;
770         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
771         if (quantity == 0) revert MintZeroQuantity();
772 
773         // Overflows are incredibly unrealistic.
774         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
775         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
776         unchecked {
777             // Updates:
778             // - `balance += quantity`.
779             // - `numberMinted += quantity`.
780             //
781             // We can directly add to the balance and number minted.
782             _packedAddressData[to] +=
783                 quantity *
784                 ((1 << BITPOS_NUMBER_MINTED) | 1);
785 
786             // Updates:
787             // - `address` to the owner.
788             // - `startTimestamp` to the timestamp of minting.
789             // - `burned` to `false`.
790             // - `nextInitialized` to `quantity == 1`.
791             _packedOwnerships[startTokenId] =
792                 _addressToUint256(to) |
793                 (block.timestamp << BITPOS_START_TIMESTAMP) |
794                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
795 
796             uint256 updatedIndex = startTokenId;
797             uint256 end = updatedIndex + quantity;
798 
799             do {
800                 emit Transfer(address(0), to, updatedIndex++);
801             } while (updatedIndex < end);
802 
803             _currentIndex = updatedIndex;
804         }
805         _afterTokenTransfers(address(0), to, startTokenId, quantity);
806     }
807 
808     /**
809      * @dev Transfers `tokenId` from `from` to `to`.
810      *
811      * Requirements:
812      *
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _transfer(
819         address from,
820         address to,
821         uint256 tokenId
822     ) private {
823         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
824 
825         if (address(uint160(prevOwnershipPacked)) != from)
826             revert TransferFromIncorrectOwner();
827 
828         address approvedAddress = _tokenApprovals[tokenId];
829 
830         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
831             isApprovedForAll(from, _msgSenderERC721A()) ||
832             approvedAddress == _msgSenderERC721A());
833 
834         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
835 
836         // Clear approvals from the previous owner.
837         if (_addressToUint256(approvedAddress) != 0) {
838             delete _tokenApprovals[tokenId];
839         }
840 
841         // Underflow of the sender's balance is impossible because we check for
842         // ownership above and the recipient's balance can't realistically overflow.
843         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
844         unchecked {
845             // We can directly increment and decrement the balances.
846             --_packedAddressData[from]; // Updates: `balance -= 1`.
847             ++_packedAddressData[to]; // Updates: `balance += 1`.
848 
849             // Updates:
850             // - `address` to the next owner.
851             // - `startTimestamp` to the timestamp of transfering.
852             // - `burned` to `false`.
853             // - `nextInitialized` to `true`.
854             _packedOwnerships[tokenId] =
855                 _addressToUint256(to) |
856                 (block.timestamp << BITPOS_START_TIMESTAMP) |
857                 BITMASK_NEXT_INITIALIZED;
858 
859             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
860             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
861                 uint256 nextTokenId = tokenId + 1;
862                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
863                 if (_packedOwnerships[nextTokenId] == 0) {
864                     // If the next slot is within bounds.
865                     if (nextTokenId != _currentIndex) {
866                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
867                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
868                     }
869                 }
870             }
871         }
872 
873         emit Transfer(from, to, tokenId);
874         _afterTokenTransfers(from, to, tokenId, 1);
875     }
876 
877     /**
878      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
879      * minting.
880      * And also called after one token has been burned.
881      *
882      * startTokenId - the first token id to be transferred
883      * quantity - the amount to be transferred
884      *
885      * Calling conditions:
886      *
887      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
888      * transferred to `to`.
889      * - When `from` is zero, `tokenId` has been minted for `to`.
890      * - When `to` is zero, `tokenId` has been burned by `from`.
891      * - `from` and `to` are never both zero.
892      */
893     function _afterTokenTransfers(
894         address from,
895         address to,
896         uint256 startTokenId,
897         uint256 quantity
898     ) internal virtual {}
899 
900     /**
901      * @dev Returns the message sender (defaults to `msg.sender`).
902      *
903      * If you are writing GSN compatible contracts, you need to override this function.
904      */
905     function _msgSenderERC721A() internal view virtual returns (address) {
906         return msg.sender;
907     }
908 
909     /**
910      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
911      */
912     function _toString(uint256 value)
913         internal
914         pure
915         returns (string memory ptr)
916     {
917         assembly {
918             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
919             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
920             // We will need 1 32-byte word to store the length,
921             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
922             ptr := add(mload(0x40), 128)
923 
924             // Update the free memory pointer to allocate.
925             mstore(0x40, ptr)
926 
927             // Cache the end of the memory to calculate the length later.
928             let end := ptr
929 
930             // We write the string from the rightmost digit to the leftmost digit.
931             // The following is essentially a do-while loop that also handles the zero case.
932             // Costs a bit more than early returning for the zero case,
933             // but cheaper in terms of deployment and overall runtime costs.
934             for {
935                 // Initialize and perform the first pass without check.
936                 let temp := value
937                 // Move the pointer 1 byte leftwards to point to an empty character slot.
938                 ptr := sub(ptr, 1)
939                 // Write the character to the pointer. 48 is the ASCII index of '0'.
940                 mstore8(ptr, add(48, mod(temp, 10)))
941                 temp := div(temp, 10)
942             } temp {
943                 // Keep dividing `temp` until zero.
944                 temp := div(temp, 10)
945             } {
946                 // Body of the for loop.
947                 ptr := sub(ptr, 1)
948                 mstore8(ptr, add(48, mod(temp, 10)))
949             }
950 
951             let length := sub(end, ptr)
952             // Move the pointer 32 bytes leftwards to make room for the length.
953             ptr := sub(ptr, 32)
954             // Store the length.
955             mstore(ptr, length)
956         }
957     }
958 
959     function withdraw() external onlyOwner {
960         uint256 balance = address(this).balance;
961         payable(msg.sender).transfer(balance);
962     }
963 }