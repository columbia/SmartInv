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
288 contract Powersnft is IERC721A { 
289     address private _owner;
290 
291     modifier onlyOwner() { 
292         require(_owner==msg.sender);
293         _; 
294     }
295 
296     uint256 public constant MAX_SUPPLY = 2500;
297     uint256 public constant MAX_FREE = 2100;
298     uint256 public constant MAX_FREE_PER_WALLET = 1;
299     uint256 public constant COST = 0.0025 ether;
300 
301     string private constant _name = "Powersnft";
302     string private constant _symbol = "POWERS";
303     string private _contractURI = "";
304     string private _baseURI = "";
305 
306 
307     constructor() {
308         _owner = msg.sender;
309     }
310 
311     function mint(uint256 amount) external payable{
312         address _caller = _msgSenderERC721A();
313 
314         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
315         require(amount*COST <= msg.value, "Value to Low");
316 
317         _mint(_caller, amount);
318     }
319 
320     function freeMint() external{
321         address _caller = _msgSenderERC721A();
322         uint256 amount = MAX_FREE_PER_WALLET;
323 
324         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
325         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "AccLimit");
326 
327         _mint(_caller, amount);
328     }
329 
330     // Mask of an entry in packed address data.
331     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
332 
333     // The bit position of `numberMinted` in packed address data.
334     uint256 private constant BITPOS_NUMBER_MINTED = 64;
335 
336     // The bit position of `numberBurned` in packed address data.
337     uint256 private constant BITPOS_NUMBER_BURNED = 128;
338 
339     // The bit position of `aux` in packed address data.
340     uint256 private constant BITPOS_AUX = 192;
341 
342     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
343     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
344 
345     // The bit position of `startTimestamp` in packed ownership.
346     uint256 private constant BITPOS_START_TIMESTAMP = 160;
347 
348     // The bit mask of the `burned` bit in packed ownership.
349     uint256 private constant BITMASK_BURNED = 1 << 224;
350 
351     // The bit position of the `nextInitialized` bit in packed ownership.
352     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
353 
354     // The bit mask of the `nextInitialized` bit in packed ownership.
355     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
356 
357     // The tokenId of the next token to be minted.
358     uint256 private _currentIndex = 0;
359 
360     // The number of tokens burned.
361     // uint256 private _burnCounter;
362 
363 
364     // Mapping from token ID to ownership details
365     // An empty struct value does not necessarily mean the token is unowned.
366     // See `_packedOwnershipOf` implementation for details.
367     //
368     // Bits Layout:
369     // - [0..159] `addr`
370     // - [160..223] `startTimestamp`
371     // - [224] `burned`
372     // - [225] `nextInitialized`
373     mapping(uint256 => uint256) private _packedOwnerships;
374 
375     // Mapping owner address to address data.
376     //
377     // Bits Layout:
378     // - [0..63] `balance`
379     // - [64..127] `numberMinted`
380     // - [128..191] `numberBurned`
381     // - [192..255] `aux`
382     mapping(address => uint256) private _packedAddressData;
383 
384     // Mapping from token ID to approved address.
385     mapping(uint256 => address) private _tokenApprovals;
386 
387     // Mapping from owner to operator approvals
388     mapping(address => mapping(address => bool)) private _operatorApprovals;
389 
390 
391     function setData(string memory _contract, string memory _base) external onlyOwner{
392         _contractURI = _contract;
393         _baseURI = _base;
394     }
395 
396     /**
397      * @dev Returns the starting token ID. 
398      * To change the starting token ID, please override this function.
399      */
400     function _startTokenId() internal view virtual returns (uint256) {
401         return 0;
402     }
403 
404     /**
405      * @dev Returns the next token ID to be minted.
406      */
407     function _nextTokenId() internal view returns (uint256) {
408         return _currentIndex;
409     }
410 
411     /**
412      * @dev Returns the total number of tokens in existence.
413      * Burned tokens will reduce the count. 
414      * To get the total number of tokens minted, please see `_totalMinted`.
415      */
416     function totalSupply() public view override returns (uint256) {
417         // Counter underflow is impossible as _burnCounter cannot be incremented
418         // more than `_currentIndex - _startTokenId()` times.
419         unchecked {
420             return _currentIndex - _startTokenId();
421         }
422     }
423 
424     /**
425      * @dev Returns the total amount of tokens minted in the contract.
426      */
427     function _totalMinted() internal view returns (uint256) {
428         // Counter underflow is impossible as _currentIndex does not decrement,
429         // and it is initialized to `_startTokenId()`
430         unchecked {
431             return _currentIndex - _startTokenId();
432         }
433     }
434 
435 
436     /**
437      * @dev See {IERC165-supportsInterface}.
438      */
439     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
440         // The interface IDs are constants representing the first 4 bytes of the XOR of
441         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
442         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
443         return
444             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
445             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
446             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
447     }
448 
449     /**
450      * @dev See {IERC721-balanceOf}.
451      */
452     function balanceOf(address owner) public view override returns (uint256) {
453         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
454         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
455     }
456 
457     /**
458      * Returns the number of tokens minted by `owner`.
459      */
460     function _numberMinted(address owner) internal view returns (uint256) {
461         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
462     }
463 
464 
465 
466     /**
467      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
468      */
469     function _getAux(address owner) internal view returns (uint64) {
470         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
471     }
472 
473     /**
474      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
475      * If there are multiple variables, please pack them into a uint64.
476      */
477     function _setAux(address owner, uint64 aux) internal {
478         uint256 packed = _packedAddressData[owner];
479         uint256 auxCasted;
480         assembly { // Cast aux without masking.
481             auxCasted := aux
482         }
483         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
484         _packedAddressData[owner] = packed;
485     }
486 
487     /**
488      * Returns the packed ownership data of `tokenId`.
489      */
490     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
491         uint256 curr = tokenId;
492 
493         unchecked {
494             if (_startTokenId() <= curr)
495                 if (curr < _currentIndex) {
496                     uint256 packed = _packedOwnerships[curr];
497                     // If not burned.
498                     if (packed & BITMASK_BURNED == 0) {
499                         // Invariant:
500                         // There will always be an ownership that has an address and is not burned
501                         // before an ownership that does not have an address and is not burned.
502                         // Hence, curr will not underflow.
503                         //
504                         // We can directly compare the packed value.
505                         // If the address is zero, packed is zero.
506                         while (packed == 0) {
507                             packed = _packedOwnerships[--curr];
508                         }
509                         return packed;
510                     }
511                 }
512         }
513         revert OwnerQueryForNonexistentToken();
514     }
515 
516     /**
517      * Returns the unpacked `TokenOwnership` struct from `packed`.
518      */
519     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
520         ownership.addr = address(uint160(packed));
521         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
522         ownership.burned = packed & BITMASK_BURNED != 0;
523     }
524 
525     /**
526      * Returns the unpacked `TokenOwnership` struct at `index`.
527      */
528     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
529         return _unpackedOwnership(_packedOwnerships[index]);
530     }
531 
532     /**
533      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
534      */
535     function _initializeOwnershipAt(uint256 index) internal {
536         if (_packedOwnerships[index] == 0) {
537             _packedOwnerships[index] = _packedOwnershipOf(index);
538         }
539     }
540 
541     /**
542      * Gas spent here starts off proportional to the maximum mint batch size.
543      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
544      */
545     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
546         return _unpackedOwnership(_packedOwnershipOf(tokenId));
547     }
548 
549     /**
550      * @dev See {IERC721-ownerOf}.
551      */
552     function ownerOf(uint256 tokenId) public view override returns (address) {
553         return address(uint160(_packedOwnershipOf(tokenId)));
554     }
555 
556     /**
557      * @dev See {IERC721Metadata-name}.
558      */
559     function name() public view virtual override returns (string memory) {
560         return _name;
561     }
562 
563     /**
564      * @dev See {IERC721Metadata-symbol}.
565      */
566     function symbol() public view virtual override returns (string memory) {
567         return _symbol;
568     }
569 
570     
571     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
572         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
573         string memory baseURI = _baseURI;
574         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
575     }
576 
577     function contractURI() public view returns (string memory) {
578         return string(abi.encodePacked("ipfs://", _contractURI));
579     }
580 
581     /**
582      * @dev Casts the address to uint256 without masking.
583      */
584     function _addressToUint256(address value) private pure returns (uint256 result) {
585         assembly {
586             result := value
587         }
588     }
589 
590     /**
591      * @dev Casts the boolean to uint256 without branching.
592      */
593     function _boolToUint256(bool value) private pure returns (uint256 result) {
594         assembly {
595             result := value
596         }
597     }
598 
599     /**
600      * @dev See {IERC721-approve}.
601      */
602     function approve(address to, uint256 tokenId) public override {
603         address owner = address(uint160(_packedOwnershipOf(tokenId)));
604         if (to == owner) revert();
605 
606         if (_msgSenderERC721A() != owner)
607             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
608                 revert ApprovalCallerNotOwnerNorApproved();
609             }
610 
611         _tokenApprovals[tokenId] = to;
612         emit Approval(owner, to, tokenId);
613     }
614 
615     /**
616      * @dev See {IERC721-getApproved}.
617      */
618     function getApproved(uint256 tokenId) public view override returns (address) {
619         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
620 
621         return _tokenApprovals[tokenId];
622     }
623 
624     /**
625      * @dev See {IERC721-setApprovalForAll}.
626      */
627     function setApprovalForAll(address operator, bool approved) public virtual override {
628         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
629 
630         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
631         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
632     }
633 
634     /**
635      * @dev See {IERC721-isApprovedForAll}.
636      */
637     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
638         return _operatorApprovals[owner][operator];
639     }
640 
641     /**
642      * @dev See {IERC721-transferFrom}.
643      */
644     function transferFrom(
645             address from,
646             address to,
647             uint256 tokenId
648             ) public virtual override {
649         _transfer(from, to, tokenId);
650     }
651 
652     /**
653      * @dev See {IERC721-safeTransferFrom}.
654      */
655     function safeTransferFrom(
656             address from,
657             address to,
658             uint256 tokenId
659             ) public virtual override {
660         safeTransferFrom(from, to, tokenId, '');
661     }
662 
663     /**
664      * @dev See {IERC721-safeTransferFrom}.
665      */
666     function safeTransferFrom(
667             address from,
668             address to,
669             uint256 tokenId,
670             bytes memory _data
671             ) public virtual override {
672         _transfer(from, to, tokenId);
673     }
674 
675     /**
676      * @dev Returns whether `tokenId` exists.
677      *
678      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
679      *
680      * Tokens start existing when they are minted (`_mint`),
681      */
682     function _exists(uint256 tokenId) internal view returns (bool) {
683         return
684             _startTokenId() <= tokenId &&
685             tokenId < _currentIndex;
686     }
687 
688     /**
689      * @dev Equivalent to `_safeMint(to, quantity, '')`.
690      */
691      /*
692     function _safeMint(address to, uint256 quantity) internal {
693         _safeMint(to, quantity, '');
694     }
695     */
696 
697     /**
698      * @dev Safely mints `quantity` tokens and transfers them to `to`.
699      *
700      * Requirements:
701      *
702      * - If `to` refers to a smart contract, it must implement
703      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
704      * - `quantity` must be greater than 0.
705      *
706      * Emits a {Transfer} event.
707      */
708      /*
709     function _safeMint(
710             address to,
711             uint256 quantity,
712             bytes memory _data
713             ) internal {
714         uint256 startTokenId = _currentIndex;
715         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
716         if (quantity == 0) revert MintZeroQuantity();
717 
718 
719         // Overflows are incredibly unrealistic.
720         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
721         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
722         unchecked {
723             // Updates:
724             // - `balance += quantity`.
725             // - `numberMinted += quantity`.
726             //
727             // We can directly add to the balance and number minted.
728             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
729 
730             // Updates:
731             // - `address` to the owner.
732             // - `startTimestamp` to the timestamp of minting.
733             // - `burned` to `false`.
734             // - `nextInitialized` to `quantity == 1`.
735             _packedOwnerships[startTokenId] =
736                 _addressToUint256(to) |
737                 (block.timestamp << BITPOS_START_TIMESTAMP) |
738                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
739 
740             uint256 updatedIndex = startTokenId;
741             uint256 end = updatedIndex + quantity;
742 
743             if (to.code.length != 0) {
744                 do {
745                     emit Transfer(address(0), to, updatedIndex);
746                 } while (updatedIndex < end);
747                 // Reentrancy protection
748                 if (_currentIndex != startTokenId) revert();
749             } else {
750                 do {
751                     emit Transfer(address(0), to, updatedIndex++);
752                 } while (updatedIndex < end);
753             }
754             _currentIndex = updatedIndex;
755         }
756         _afterTokenTransfers(address(0), to, startTokenId, quantity);
757     }
758     */
759 
760     /**
761      * @dev Mints `quantity` tokens and transfers them to `to`.
762      *
763      * Requirements:
764      *
765      * - `to` cannot be the zero address.
766      * - `quantity` must be greater than 0.
767      *
768      * Emits a {Transfer} event.
769      */
770     function _mint(address to, uint256 quantity) internal {
771         uint256 startTokenId = _currentIndex;
772         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
773         if (quantity == 0) revert MintZeroQuantity();
774 
775 
776         // Overflows are incredibly unrealistic.
777         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
778         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
779         unchecked {
780             // Updates:
781             // - `balance += quantity`.
782             // - `numberMinted += quantity`.
783             //
784             // We can directly add to the balance and number minted.
785             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
786 
787             // Updates:
788             // - `address` to the owner.
789             // - `startTimestamp` to the timestamp of minting.
790             // - `burned` to `false`.
791             // - `nextInitialized` to `quantity == 1`.
792             _packedOwnerships[startTokenId] =
793                 _addressToUint256(to) |
794                 (block.timestamp << BITPOS_START_TIMESTAMP) |
795                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
796 
797             uint256 updatedIndex = startTokenId;
798             uint256 end = updatedIndex + quantity;
799 
800             do {
801                 emit Transfer(address(0), to, updatedIndex++);
802             } while (updatedIndex < end);
803 
804             _currentIndex = updatedIndex;
805         }
806         _afterTokenTransfers(address(0), to, startTokenId, quantity);
807     }
808 
809     /**
810      * @dev Transfers `tokenId` from `from` to `to`.
811      *
812      * Requirements:
813      *
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must be owned by `from`.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _transfer(
820             address from,
821             address to,
822             uint256 tokenId
823             ) private {
824 
825         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
826 
827         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
828 
829         address approvedAddress = _tokenApprovals[tokenId];
830 
831         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
832                 isApprovedForAll(from, _msgSenderERC721A()) ||
833                 approvedAddress == _msgSenderERC721A());
834 
835         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
836 
837         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
838 
839 
840         // Clear approvals from the previous owner.
841         if (_addressToUint256(approvedAddress) != 0) {
842             delete _tokenApprovals[tokenId];
843         }
844 
845         // Underflow of the sender's balance is impossible because we check for
846         // ownership above and the recipient's balance can't realistically overflow.
847         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
848         unchecked {
849             // We can directly increment and decrement the balances.
850             --_packedAddressData[from]; // Updates: `balance -= 1`.
851             ++_packedAddressData[to]; // Updates: `balance += 1`.
852 
853             // Updates:
854             // - `address` to the next owner.
855             // - `startTimestamp` to the timestamp of transfering.
856             // - `burned` to `false`.
857             // - `nextInitialized` to `true`.
858             _packedOwnerships[tokenId] =
859                 _addressToUint256(to) |
860                 (block.timestamp << BITPOS_START_TIMESTAMP) |
861                 BITMASK_NEXT_INITIALIZED;
862 
863             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
864             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
865                 uint256 nextTokenId = tokenId + 1;
866                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
867                 if (_packedOwnerships[nextTokenId] == 0) {
868                     // If the next slot is within bounds.
869                     if (nextTokenId != _currentIndex) {
870                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
871                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
872                     }
873                 }
874             }
875         }
876 
877         emit Transfer(from, to, tokenId);
878         _afterTokenTransfers(from, to, tokenId, 1);
879     }
880 
881 
882 
883 
884     /**
885      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
886      * minting.
887      * And also called after one token has been burned.
888      *
889      * startTokenId - the first token id to be transferred
890      * quantity - the amount to be transferred
891      *
892      * Calling conditions:
893      *
894      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
895      * transferred to `to`.
896      * - When `from` is zero, `tokenId` has been minted for `to`.
897      * - When `to` is zero, `tokenId` has been burned by `from`.
898      * - `from` and `to` are never both zero.
899      */
900     function _afterTokenTransfers(
901             address from,
902             address to,
903             uint256 startTokenId,
904             uint256 quantity
905             ) internal virtual {}
906 
907     /**
908      * @dev Returns the message sender (defaults to `msg.sender`).
909      *
910      * If you are writing GSN compatible contracts, you need to override this function.
911      */
912     function _msgSenderERC721A() internal view virtual returns (address) {
913         return msg.sender;
914     }
915 
916     /**
917      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
918      */
919     function _toString(uint256 value) internal pure returns (string memory ptr) {
920         assembly {
921             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
922             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
923             // We will need 1 32-byte word to store the length, 
924             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
925             ptr := add(mload(0x40), 128)
926 
927          // Update the free memory pointer to allocate.
928          mstore(0x40, ptr)
929 
930          // Cache the end of the memory to calculate the length later.
931          let end := ptr
932 
933          // We write the string from the rightmost digit to the leftmost digit.
934          // The following is essentially a do-while loop that also handles the zero case.
935          // Costs a bit more than early returning for the zero case,
936          // but cheaper in terms of deployment and overall runtime costs.
937          for { 
938              // Initialize and perform the first pass without check.
939              let temp := value
940                  // Move the pointer 1 byte leftwards to point to an empty character slot.
941                  ptr := sub(ptr, 1)
942                  // Write the character to the pointer. 48 is the ASCII index of '0'.
943                  mstore8(ptr, add(48, mod(temp, 10)))
944                  temp := div(temp, 10)
945          } temp { 
946              // Keep dividing `temp` until zero.
947         temp := div(temp, 10)
948          } { 
949              // Body of the for loop.
950         ptr := sub(ptr, 1)
951          mstore8(ptr, add(48, mod(temp, 10)))
952          }
953 
954      let length := sub(end, ptr)
955          // Move the pointer 32 bytes leftwards to make room for the length.
956          ptr := sub(ptr, 32)
957          // Store the length.
958          mstore(ptr, length)
959         }
960     }
961 
962     function withdraw() external onlyOwner {
963         uint256 balance = address(this).balance;
964         payable(msg.sender).transfer(balance);
965     }
966 }