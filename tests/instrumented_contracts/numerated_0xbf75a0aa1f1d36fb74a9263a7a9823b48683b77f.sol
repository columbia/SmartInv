1 /**
2  *Submitted for verification at Etherscan.io on 2023-10-05
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.20;
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
292 contract Rockd is IERC721A { 
293 
294     address private _owner;
295     function owner() public view returns(address){
296         return _owner;
297     }
298 
299     uint256 public constant MAX_SUPPLY = 420;
300     uint256 public MAX_FREE_PER_WALLET = 1;
301     uint256 public COST = 0.001 ether;
302 
303     string private constant _name = "Rockd";
304     string private constant _symbol = "Rockd";
305     string private _baseURI = "QmYCAMSZmibw3eUVhnVfbNMG5yanRowFshcYzYprzwwa4a";
306 
307     constructor() {
308         _owner = msg.sender;
309     }
310 
311     function mint(uint256 amount) external payable{
312         address _caller = _msgSenderERC721A();
313 
314         require(totalSupply() + amount <= MAX_SUPPLY, "Sold Out");
315         require(amount*COST <= msg.value, "Value to Low");
316         require(amount <= 10, "Max 5 per TX");
317 
318         _mint(_caller, amount);
319     }
320 
321     function freeMint() external nob{
322         address _caller = _msgSenderERC721A();
323         uint256 amount = MAX_FREE_PER_WALLET;
324 
325         require(totalSupply() + amount <= MAX_FREE, "Freemint Sold Out");
326         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "Max per Wallet");
327 
328         _mint(_caller, amount);
329     }
330 
331 
332 
333     // Mask of an entry in packed address data.
334     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
335 
336     // The bit position of `numberMinted` in packed address data.
337     uint256 private constant BITPOS_NUMBER_MINTED = 64;
338 
339     // The bit position of `numberBurned` in packed address data.
340     uint256 private constant BITPOS_NUMBER_BURNED = 128;
341 
342     // The bit position of `aux` in packed address data.
343     uint256 private constant BITPOS_AUX = 192;
344 
345     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
346     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
347 
348     // The bit position of `startTimestamp` in packed ownership.
349     uint256 private constant BITPOS_START_TIMESTAMP = 160;
350 
351     // The bit mask of the `burned` bit in packed ownership.
352     uint256 private constant BITMASK_BURNED = 1 << 224;
353 
354     // The bit position of the `nextInitialized` bit in packed ownership.
355     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
356 
357     // The bit mask of the `nextInitialized` bit in packed ownership.
358     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
359 
360     // The tokenId of the next token to be minted.
361     uint256 private _currentIndex = 0;
362 
363     // The number of tokens burned.
364     // uint256 private _burnCounter;
365 
366 
367     // Mapping from token ID to ownership details
368     // An empty struct value does not necessarily mean the token is unowned.
369     // See `_packedOwnershipOf` implementation for details.
370     //
371     // Bits Layout:
372     // - [0..159] `addr`
373     // - [160..223] `startTimestamp`
374     // - [224] `burned`
375     // - [225] `nextInitialized`
376     mapping(uint256 => uint256) private _packedOwnerships;
377 
378     // Mapping owner address to address data.
379     //
380     // Bits Layout:
381     // - [0..63] `balance`
382     // - [64..127] `numberMinted`
383     // - [128..191] `numberBurned`
384     // - [192..255] `aux`
385     mapping(address => uint256) private _packedAddressData;
386 
387     // Mapping from token ID to approved address.
388     mapping(uint256 => address) private _tokenApprovals;
389 
390     // Mapping from owner to operator approvals
391     mapping(address => mapping(address => bool)) private _operatorApprovals;
392 
393 
394     function setData(string memory _base) external onlyOwner{
395         _baseURI = _base;
396     }
397 
398     uint256 public MAX_FREE = 345;
399     function setConfig(uint256 _COST, uint256 _MAX_FREE, uint256 _MAX_FREE_PER_WALLET) external onlyOwner{
400         MAX_FREE = _MAX_FREE;
401         COST = _COST;
402         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
403     }
404 
405     /**
406      * @dev Returns the starting token ID. 
407      * To change the starting token ID, please override this function.
408      */
409     function _startTokenId() internal view virtual returns (uint256) {
410         return 0;
411     }
412 
413     /**
414      * @dev Returns the next token ID to be minted.
415      */
416     function _nextTokenId() internal view returns (uint256) {
417         return _currentIndex;
418     }
419 
420     /**
421      * @dev Returns the total number of tokens in existence.
422      * Burned tokens will reduce the count. 
423      * To get the total number of tokens minted, please see `_totalMinted`.
424      */
425     function totalSupply() public view override returns (uint256) {
426         // Counter underflow is impossible as _burnCounter cannot be incremented
427         // more than `_currentIndex - _startTokenId()` times.
428         unchecked {
429             return _currentIndex - _startTokenId();
430         }
431     }
432 
433     /**
434      * @dev Returns the total amount of tokens minted in the contract.
435      */
436     function _totalMinted() internal view returns (uint256) {
437         // Counter underflow is impossible as _currentIndex does not decrement,
438         // and it is initialized to `_startTokenId()`
439         unchecked {
440             return _currentIndex - _startTokenId();
441         }
442     }
443 
444 
445     /**
446      * @dev See {IERC165-supportsInterface}.
447      */
448     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
449         // The interface IDs are constants representing the first 4 bytes of the XOR of
450         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
451         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
452         return
453             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
454             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
455             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
456     }
457 
458     /**
459      * @dev See {IERC721-balanceOf}.
460      */
461     function balanceOf(address owner) public view override returns (uint256) {
462         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
463         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
464     }
465 
466     /**
467      * Returns the number of tokens minted by `owner`.
468      */
469     function _numberMinted(address owner) internal view returns (uint256) {
470         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
471     }
472 
473 
474 
475     /**
476      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
477      */
478     function _getAux(address owner) internal view returns (uint64) {
479         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
480     }
481 
482     /**
483      * Returns the packed ownership data of `tokenId`.
484      */
485     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
486         uint256 curr = tokenId;
487 
488         unchecked {
489             if (_startTokenId() <= curr)
490                 if (curr < _currentIndex) {
491                     uint256 packed = _packedOwnerships[curr];
492                     // If not burned.
493                     if (packed & BITMASK_BURNED == 0) {
494                         // Invariant:
495                         // There will always be an ownership that has an address and is not burned
496                         // before an ownership that does not have an address and is not burned.
497                         // Hence, curr will not underflow.
498                         //
499                         // We can directly compare the packed value.
500                         // If the address is zero, packed is zero.
501                         while (packed == 0) {
502                             packed = _packedOwnerships[--curr];
503                         }
504                         return packed;
505                     }
506                 }
507         }
508         revert OwnerQueryForNonexistentToken();
509     }
510 
511     /**
512      * Returns the unpacked `TokenOwnership` struct from `packed`.
513      */
514     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
515         ownership.addr = address(uint160(packed));
516         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
517         ownership.burned = packed & BITMASK_BURNED != 0;
518     }
519 
520     /**
521      * Returns the unpacked `TokenOwnership` struct at `index`.
522      */
523     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
524         return _unpackedOwnership(_packedOwnerships[index]);
525     }
526 
527     /**
528      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
529      */
530     function _initializeOwnershipAt(uint256 index) internal {
531         if (_packedOwnerships[index] == 0) {
532             _packedOwnerships[index] = _packedOwnershipOf(index);
533         }
534     }
535 
536     /**
537      * Gas spent here starts off proportional to the maximum mint batch size.
538      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
539      */
540     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
541         return _unpackedOwnership(_packedOwnershipOf(tokenId));
542     }
543 
544     /**
545      * @dev See {IERC721-ownerOf}.
546      */
547     function ownerOf(uint256 tokenId) public view override returns (address) {
548         return address(uint160(_packedOwnershipOf(tokenId)));
549     }
550 
551     /**
552      * @dev See {IERC721Metadata-name}.
553      */
554     function name() public view virtual override returns (string memory) {
555         return _name;
556     }
557 
558     /**
559      * @dev See {IERC721Metadata-symbol}.
560      */
561     function symbol() public view virtual override returns (string memory) {
562         return _symbol;
563     }
564 
565     
566     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
567         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
568         string memory baseURI = _baseURI;
569         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
570     }
571 
572     /**
573      * @dev Casts the address to uint256 without masking.
574      */
575     function _addressToUint256(address value) private pure returns (uint256 result) {
576         assembly {
577             result := value
578         }
579     }
580 
581     /**
582      * @dev Casts the boolean to uint256 without branching.
583      */
584     function _boolToUint256(bool value) private pure returns (uint256 result) {
585         assembly {
586             result := value
587         }
588     }
589 
590     /**
591      * @dev See {IERC721-approve}.
592      */
593     function approve(address to, uint256 tokenId) public override {
594         address owner = address(uint160(_packedOwnershipOf(tokenId)));
595         if (to == owner) revert();
596 
597         if (_msgSenderERC721A() != owner)
598             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
599                 revert ApprovalCallerNotOwnerNorApproved();
600             }
601 
602         _tokenApprovals[tokenId] = to;
603         emit Approval(owner, to, tokenId);
604     }
605 
606     /**
607      * @dev See {IERC721-getApproved}.
608      */
609     function getApproved(uint256 tokenId) public view override returns (address) {
610         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
611 
612         return _tokenApprovals[tokenId];
613     }
614 
615     /**
616      * @dev See {IERC721-setApprovalForAll}.
617      */
618     function setApprovalForAll(address operator, bool approved) public virtual override {
619         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
620 
621         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
622         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
623     }
624 
625     /**
626      * @dev See {IERC721-isApprovedForAll}.
627      */
628     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
629         return _operatorApprovals[owner][operator];
630     }
631 
632     /**
633      * @dev See {IERC721-transferFrom}.
634      */
635     function transferFrom(
636             address from,
637             address to,
638             uint256 tokenId
639             ) public virtual override {
640         _transfer(from, to, tokenId);
641     }
642 
643     /**
644      * @dev See {IERC721-safeTransferFrom}.
645      */
646     function safeTransferFrom(
647             address from,
648             address to,
649             uint256 tokenId
650             ) public virtual override {
651         safeTransferFrom(from, to, tokenId, '');
652     }
653 
654     /**
655      * @dev See {IERC721-safeTransferFrom}.
656      */
657     function safeTransferFrom(
658             address from,
659             address to,
660             uint256 tokenId,
661             bytes memory _data
662             ) public virtual override {
663         _transfer(from, to, tokenId);
664     }
665 
666     /**
667      * @dev Returns whether `tokenId` exists.
668      *
669      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
670      *
671      * Tokens start existing when they are minted (`_mint`),
672      */
673     function _exists(uint256 tokenId) internal view returns (bool) {
674         return
675             _startTokenId() <= tokenId &&
676             tokenId < _currentIndex;
677     }
678 
679   
680 
681     /**
682      * @dev Mints `quantity` tokens and transfers them to `to`.
683      *
684      * Requirements:
685      *
686      * - `to` cannot be the zero address.
687      * - `quantity` must be greater than 0.
688      *
689      * Emits a {Transfer} event.
690      */
691     function _mint(address to, uint256 quantity) internal {
692         uint256 startTokenId = _currentIndex;
693         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
694         if (quantity == 0) revert MintZeroQuantity();
695 
696 
697         // Overflows are incredibly unrealistic.
698         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
699         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
700         unchecked {
701             // Updates:
702             // - `balance += quantity`.
703             // - `numberMinted += quantity`.
704             //
705             // We can directly add to the balance and number minted.
706             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
707 
708             // Updates:
709             // - `address` to the owner.
710             // - `startTimestamp` to the timestamp of minting.
711             // - `burned` to `false`.
712             // - `nextInitialized` to `quantity == 1`.
713             _packedOwnerships[startTokenId] =
714                 _addressToUint256(to) |
715                 (block.timestamp << BITPOS_START_TIMESTAMP) |
716                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
717 
718             uint256 updatedIndex = startTokenId;
719             uint256 end = updatedIndex + quantity;
720 
721             do {
722                 emit Transfer(address(0), to, updatedIndex++);
723             } while (updatedIndex < end);
724 
725             _currentIndex = updatedIndex;
726         }
727         _afterTokenTransfers(address(0), to, startTokenId, quantity);
728     }
729 
730     /**
731      * @dev Transfers `tokenId` from `from` to `to`.
732      *
733      * Requirements:
734      *
735      * - `to` cannot be the zero address.
736      * - `tokenId` token must be owned by `from`.
737      *
738      * Emits a {Transfer} event.
739      */
740     function _transfer(
741             address from,
742             address to,
743             uint256 tokenId
744             ) private {
745 
746         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
747 
748         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
749 
750         address approvedAddress = _tokenApprovals[tokenId];
751 
752         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
753                 isApprovedForAll(from, _msgSenderERC721A()) ||
754                 approvedAddress == _msgSenderERC721A());
755 
756         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
757 
758 
759         // Clear approvals from the previous owner.
760         if (_addressToUint256(approvedAddress) != 0) {
761             delete _tokenApprovals[tokenId];
762         }
763 
764         // Underflow of the sender's balance is impossible because we check for
765         // ownership above and the recipient's balance can't realistically overflow.
766         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
767         unchecked {
768             // We can directly increment and decrement the balances.
769             --_packedAddressData[from]; // Updates: `balance -= 1`.
770             ++_packedAddressData[to]; // Updates: `balance += 1`.
771 
772             // Updates:
773             // - `address` to the next owner.
774             // - `startTimestamp` to the timestamp of transfering.
775             // - `burned` to `false`.
776             // - `nextInitialized` to `true`.
777             _packedOwnerships[tokenId] =
778                 _addressToUint256(to) |
779                 (block.timestamp << BITPOS_START_TIMESTAMP) |
780                 BITMASK_NEXT_INITIALIZED;
781 
782             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
783             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
784                 uint256 nextTokenId = tokenId + 1;
785                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
786                 if (_packedOwnerships[nextTokenId] == 0) {
787                     // If the next slot is within bounds.
788                     if (nextTokenId != _currentIndex) {
789                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
790                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
791                     }
792                 }
793             }
794         }
795 
796         emit Transfer(from, to, tokenId);
797         _afterTokenTransfers(from, to, tokenId, 1);
798     }
799 
800 
801 
802 
803     /**
804      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
805      * minting.
806      * And also called after one token has been burned.
807      *
808      * startTokenId - the first token id to be transferred
809      * quantity - the amount to be transferred
810      *
811      * Calling conditions:
812      *
813      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
814      * transferred to `to`.
815      * - When `from` is zero, `tokenId` has been minted for `to`.
816      * - When `to` is zero, `tokenId` has been burned by `from`.
817      * - `from` and `to` are never both zero.
818      */
819     function _afterTokenTransfers(
820             address from,
821             address to,
822             uint256 startTokenId,
823             uint256 quantity
824             ) internal virtual {}
825 
826     /**
827      * @dev Returns the message sender (defaults to `msg.sender`).
828      *
829      * If you are writing GSN compatible contracts, you need to override this function.
830      */
831     function _msgSenderERC721A() internal view virtual returns (address) {
832         return msg.sender;
833     }
834 
835     /**
836      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
837      */
838     function _toString(uint256 value) internal pure returns (string memory ptr) {
839         assembly {
840             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
841             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
842             // We will need 1 32-byte word to store the length, 
843             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
844             ptr := add(mload(0x40), 128)
845 
846          // Update the free memory pointer to allocate.
847          mstore(0x40, ptr)
848 
849          // Cache the end of the memory to calculate the length later.
850          let end := ptr
851 
852          // We write the string from the rightmost digit to the leftmost digit.
853          // The following is essentially a do-while loop that also handles the zero case.
854          // Costs a bit more than early returning for the zero case,
855          // but cheaper in terms of deployment and overall runtime costs.
856          for { 
857              // Initialize and perform the first pass without check.
858              let temp := value
859                  // Move the pointer 1 byte leftwards to point to an empty character slot.
860                  ptr := sub(ptr, 1)
861                  // Write the character to the pointer. 48 is the ASCII index of '0'.
862                  mstore8(ptr, add(48, mod(temp, 10)))
863                  temp := div(temp, 10)
864          } temp { 
865              // Keep dividing `temp` until zero.
866         temp := div(temp, 10)
867          } { 
868              // Body of the for loop.
869         ptr := sub(ptr, 1)
870          mstore8(ptr, add(48, mod(temp, 10)))
871          }
872 
873      let length := sub(end, ptr)
874          // Move the pointer 32 bytes leftwards to make room for the length.
875          ptr := sub(ptr, 32)
876          // Store the length.
877          mstore(ptr, length)
878         }
879     }
880 
881     modifier onlyOwner() { 
882         require(_owner==msg.sender, "not Owner");
883         _; 
884     }
885 
886     modifier nob() {
887         require(tx.origin==msg.sender, "no Script");
888         _;
889     }
890 
891     function withdraw() external onlyOwner {
892         uint256 balance = address(this).balance;
893         payable(msg.sender).transfer(balance);
894     }
895 }