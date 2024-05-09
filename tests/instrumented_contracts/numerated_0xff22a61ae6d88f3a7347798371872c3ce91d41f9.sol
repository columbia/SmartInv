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
288 contract CryptoSmols is IERC721A { 
289     address private _owner;
290     function owner() public view returns(address){
291         return _owner;
292     }
293     modifier onlyOwner() { 
294         require(_owner==msg.sender);
295         _; 
296     }
297 
298     uint256 public constant MAX_SUPPLY = 1235;
299     uint256 public constant MAX_FREE = 761;
300     uint256 public MAX_FREE_PER_WALLET = 1;
301     uint256 public COST = 0.001 ether;
302 
303     string private constant _name = "CryptoSmols";
304     string private constant _symbol = "CRYPTOSMOL";
305     string public constant contractURI = "ipfs://QmXPanhBDeK2Y794uivpmRzzKHabHTEo8RZ8mAARW1YbJL";
306     string private _baseURI = "QmXPanhBDeK2Y794uivpmRzzKHabHTEo8RZ8mAARW1YbJL";
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
317 
318         _mint(_caller, amount);
319     }
320 
321     function freeMint() external{
322         address _caller = _msgSenderERC721A();
323         uint256 amount = 1;
324 
325         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
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
396     function setConfig(uint256 _MAX_FREE_PER_WALLET, uint256 _COST) external onlyOwner{
397         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
398         COST = _COST;
399     }
400 
401     /**
402      * @dev Returns the starting token ID. 
403      * To change the starting token ID, please override this function.
404      */
405     function _startTokenId() internal view virtual returns (uint256) {
406         return 0;
407     }
408 
409     /**
410      * @dev Returns the next token ID to be minted.
411      */
412     function _nextTokenId() internal view returns (uint256) {
413         return _currentIndex;
414     }
415 
416     /**
417      * @dev Returns the total number of tokens in existence.
418      * Burned tokens will reduce the count. 
419      * To get the total number of tokens minted, please see `_totalMinted`.
420      */
421     function totalSupply() public view override returns (uint256) {
422         // Counter underflow is impossible as _burnCounter cannot be incremented
423         // more than `_currentIndex - _startTokenId()` times.
424         unchecked {
425             return _currentIndex - _startTokenId();
426         }
427     }
428 
429     /**
430      * @dev Returns the total amount of tokens minted in the contract.
431      */
432     function _totalMinted() internal view returns (uint256) {
433         // Counter underflow is impossible as _currentIndex does not decrement,
434         // and it is initialized to `_startTokenId()`
435         unchecked {
436             return _currentIndex - _startTokenId();
437         }
438     }
439 
440 
441     /**
442      * @dev See {IERC165-supportsInterface}.
443      */
444     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
445         // The interface IDs are constants representing the first 4 bytes of the XOR of
446         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
447         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
448         return
449             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
450             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
451             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
452     }
453 
454     /**
455      * @dev See {IERC721-balanceOf}.
456      */
457     function balanceOf(address owner) public view override returns (uint256) {
458         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
459         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
460     }
461 
462     /**
463      * Returns the number of tokens minted by `owner`.
464      */
465     function _numberMinted(address owner) internal view returns (uint256) {
466         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
467     }
468 
469 
470 
471     /**
472      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
473      */
474     function _getAux(address owner) internal view returns (uint64) {
475         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
476     }
477 
478     /**
479      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
480      * If there are multiple variables, please pack them into a uint64.
481      */
482     function _setAux(address owner, uint64 aux) internal {
483         uint256 packed = _packedAddressData[owner];
484         uint256 auxCasted;
485         assembly { // Cast aux without masking.
486             auxCasted := aux
487         }
488         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
489         _packedAddressData[owner] = packed;
490     }
491 
492     /**
493      * Returns the packed ownership data of `tokenId`.
494      */
495     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
496         uint256 curr = tokenId;
497 
498         unchecked {
499             if (_startTokenId() <= curr)
500                 if (curr < _currentIndex) {
501                     uint256 packed = _packedOwnerships[curr];
502                     // If not burned.
503                     if (packed & BITMASK_BURNED == 0) {
504                         // Invariant:
505                         // There will always be an ownership that has an address and is not burned
506                         // before an ownership that does not have an address and is not burned.
507                         // Hence, curr will not underflow.
508                         //
509                         // We can directly compare the packed value.
510                         // If the address is zero, packed is zero.
511                         while (packed == 0) {
512                             packed = _packedOwnerships[--curr];
513                         }
514                         return packed;
515                     }
516                 }
517         }
518         revert OwnerQueryForNonexistentToken();
519     }
520 
521     /**
522      * Returns the unpacked `TokenOwnership` struct from `packed`.
523      */
524     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
525         ownership.addr = address(uint160(packed));
526         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
527         ownership.burned = packed & BITMASK_BURNED != 0;
528     }
529 
530     /**
531      * Returns the unpacked `TokenOwnership` struct at `index`.
532      */
533     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
534         return _unpackedOwnership(_packedOwnerships[index]);
535     }
536 
537     /**
538      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
539      */
540     function _initializeOwnershipAt(uint256 index) internal {
541         if (_packedOwnerships[index] == 0) {
542             _packedOwnerships[index] = _packedOwnershipOf(index);
543         }
544     }
545 
546     /**
547      * Gas spent here starts off proportional to the maximum mint batch size.
548      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
549      */
550     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
551         return _unpackedOwnership(_packedOwnershipOf(tokenId));
552     }
553 
554     /**
555      * @dev See {IERC721-ownerOf}.
556      */
557     function ownerOf(uint256 tokenId) public view override returns (address) {
558         return address(uint160(_packedOwnershipOf(tokenId)));
559     }
560 
561     /**
562      * @dev See {IERC721Metadata-name}.
563      */
564     function name() public view virtual override returns (string memory) {
565         return _name;
566     }
567 
568     /**
569      * @dev See {IERC721Metadata-symbol}.
570      */
571     function symbol() public view virtual override returns (string memory) {
572         return _symbol;
573     }
574 
575     
576     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
577         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
578         string memory baseURI = _baseURI;
579         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
580     }
581 
582     /*
583     function contractURI() public view returns (string memory) {
584         return string(abi.encodePacked("ipfs://", _contractURI));
585     }
586     */
587 
588     /**
589      * @dev Casts the address to uint256 without masking.
590      */
591     function _addressToUint256(address value) private pure returns (uint256 result) {
592         assembly {
593             result := value
594         }
595     }
596 
597     /**
598      * @dev Casts the boolean to uint256 without branching.
599      */
600     function _boolToUint256(bool value) private pure returns (uint256 result) {
601         assembly {
602             result := value
603         }
604     }
605 
606     /**
607      * @dev See {IERC721-approve}.
608      */
609     function approve(address to, uint256 tokenId) public override {
610         address owner = address(uint160(_packedOwnershipOf(tokenId)));
611         if (to == owner) revert();
612 
613         if (_msgSenderERC721A() != owner)
614             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
615                 revert ApprovalCallerNotOwnerNorApproved();
616             }
617 
618         _tokenApprovals[tokenId] = to;
619         emit Approval(owner, to, tokenId);
620     }
621 
622     /**
623      * @dev See {IERC721-getApproved}.
624      */
625     function getApproved(uint256 tokenId) public view override returns (address) {
626         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
627 
628         return _tokenApprovals[tokenId];
629     }
630 
631     /**
632      * @dev See {IERC721-setApprovalForAll}.
633      */
634     function setApprovalForAll(address operator, bool approved) public virtual override {
635         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
636 
637         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
638         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
639     }
640 
641     /**
642      * @dev See {IERC721-isApprovedForAll}.
643      */
644     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
645         return _operatorApprovals[owner][operator];
646     }
647 
648     /**
649      * @dev See {IERC721-transferFrom}.
650      */
651     function transferFrom(
652             address from,
653             address to,
654             uint256 tokenId
655             ) public virtual override {
656         _transfer(from, to, tokenId);
657     }
658 
659     /**
660      * @dev See {IERC721-safeTransferFrom}.
661      */
662     function safeTransferFrom(
663             address from,
664             address to,
665             uint256 tokenId
666             ) public virtual override {
667         safeTransferFrom(from, to, tokenId, '');
668     }
669 
670     /**
671      * @dev See {IERC721-safeTransferFrom}.
672      */
673     function safeTransferFrom(
674             address from,
675             address to,
676             uint256 tokenId,
677             bytes memory _data
678             ) public virtual override {
679         _transfer(from, to, tokenId);
680     }
681 
682     /**
683      * @dev Returns whether `tokenId` exists.
684      *
685      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
686      *
687      * Tokens start existing when they are minted (`_mint`),
688      */
689     function _exists(uint256 tokenId) internal view returns (bool) {
690         return
691             _startTokenId() <= tokenId &&
692             tokenId < _currentIndex;
693     }
694 
695     /**
696      * @dev Equivalent to `_safeMint(to, quantity, '')`.
697      */
698      /*
699     function _safeMint(address to, uint256 quantity) internal {
700         _safeMint(to, quantity, '');
701     }
702     */
703 
704     /**
705      * @dev Safely mints `quantity` tokens and transfers them to `to`.
706      *
707      * Requirements:
708      *
709      * - If `to` refers to a smart contract, it must implement
710      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
711      * - `quantity` must be greater than 0.
712      *
713      * Emits a {Transfer} event.
714      */
715      /*
716     function _safeMint(
717             address to,
718             uint256 quantity,
719             bytes memory _data
720             ) internal {
721         uint256 startTokenId = _currentIndex;
722         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
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
750             if (to.code.length != 0) {
751                 do {
752                     emit Transfer(address(0), to, updatedIndex);
753                 } while (updatedIndex < end);
754                 // Reentrancy protection
755                 if (_currentIndex != startTokenId) revert();
756             } else {
757                 do {
758                     emit Transfer(address(0), to, updatedIndex++);
759                 } while (updatedIndex < end);
760             }
761             _currentIndex = updatedIndex;
762         }
763         _afterTokenTransfers(address(0), to, startTokenId, quantity);
764     }
765     */
766 
767     /**
768      * @dev Mints `quantity` tokens and transfers them to `to`.
769      *
770      * Requirements:
771      *
772      * - `to` cannot be the zero address.
773      * - `quantity` must be greater than 0.
774      *
775      * Emits a {Transfer} event.
776      */
777     function _mint(address to, uint256 quantity) internal {
778         uint256 startTokenId = _currentIndex;
779         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
780         if (quantity == 0) revert MintZeroQuantity();
781 
782 
783         // Overflows are incredibly unrealistic.
784         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
785         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
786         unchecked {
787             // Updates:
788             // - `balance += quantity`.
789             // - `numberMinted += quantity`.
790             //
791             // We can directly add to the balance and number minted.
792             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
793 
794             // Updates:
795             // - `address` to the owner.
796             // - `startTimestamp` to the timestamp of minting.
797             // - `burned` to `false`.
798             // - `nextInitialized` to `quantity == 1`.
799             _packedOwnerships[startTokenId] =
800                 _addressToUint256(to) |
801                 (block.timestamp << BITPOS_START_TIMESTAMP) |
802                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
803 
804             uint256 updatedIndex = startTokenId;
805             uint256 end = updatedIndex + quantity;
806 
807             do {
808                 emit Transfer(address(0), to, updatedIndex++);
809             } while (updatedIndex < end);
810 
811             _currentIndex = updatedIndex;
812         }
813         _afterTokenTransfers(address(0), to, startTokenId, quantity);
814     }
815 
816     /**
817      * @dev Transfers `tokenId` from `from` to `to`.
818      *
819      * Requirements:
820      *
821      * - `to` cannot be the zero address.
822      * - `tokenId` token must be owned by `from`.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _transfer(
827             address from,
828             address to,
829             uint256 tokenId
830             ) private {
831 
832         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
833 
834         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
835 
836         address approvedAddress = _tokenApprovals[tokenId];
837 
838         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
839                 isApprovedForAll(from, _msgSenderERC721A()) ||
840                 approvedAddress == _msgSenderERC721A());
841 
842         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
843 
844         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
845 
846 
847         // Clear approvals from the previous owner.
848         if (_addressToUint256(approvedAddress) != 0) {
849             delete _tokenApprovals[tokenId];
850         }
851 
852         // Underflow of the sender's balance is impossible because we check for
853         // ownership above and the recipient's balance can't realistically overflow.
854         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
855         unchecked {
856             // We can directly increment and decrement the balances.
857             --_packedAddressData[from]; // Updates: `balance -= 1`.
858             ++_packedAddressData[to]; // Updates: `balance += 1`.
859 
860             // Updates:
861             // - `address` to the next owner.
862             // - `startTimestamp` to the timestamp of transfering.
863             // - `burned` to `false`.
864             // - `nextInitialized` to `true`.
865             _packedOwnerships[tokenId] =
866                 _addressToUint256(to) |
867                 (block.timestamp << BITPOS_START_TIMESTAMP) |
868                 BITMASK_NEXT_INITIALIZED;
869 
870             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
871             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
872                 uint256 nextTokenId = tokenId + 1;
873                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
874                 if (_packedOwnerships[nextTokenId] == 0) {
875                     // If the next slot is within bounds.
876                     if (nextTokenId != _currentIndex) {
877                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
878                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
879                     }
880                 }
881             }
882         }
883 
884         emit Transfer(from, to, tokenId);
885         _afterTokenTransfers(from, to, tokenId, 1);
886     }
887 
888 
889 
890 
891     /**
892      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
893      * minting.
894      * And also called after one token has been burned.
895      *
896      * startTokenId - the first token id to be transferred
897      * quantity - the amount to be transferred
898      *
899      * Calling conditions:
900      *
901      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
902      * transferred to `to`.
903      * - When `from` is zero, `tokenId` has been minted for `to`.
904      * - When `to` is zero, `tokenId` has been burned by `from`.
905      * - `from` and `to` are never both zero.
906      */
907     function _afterTokenTransfers(
908             address from,
909             address to,
910             uint256 startTokenId,
911             uint256 quantity
912             ) internal virtual {}
913 
914     /**
915      * @dev Returns the message sender (defaults to `msg.sender`).
916      *
917      * If you are writing GSN compatible contracts, you need to override this function.
918      */
919     function _msgSenderERC721A() internal view virtual returns (address) {
920         return msg.sender;
921     }
922 
923     /**
924      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
925      */
926     function _toString(uint256 value) internal pure returns (string memory ptr) {
927         assembly {
928             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
929             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
930             // We will need 1 32-byte word to store the length, 
931             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
932             ptr := add(mload(0x40), 128)
933 
934          // Update the free memory pointer to allocate.
935          mstore(0x40, ptr)
936 
937          // Cache the end of the memory to calculate the length later.
938          let end := ptr
939 
940          // We write the string from the rightmost digit to the leftmost digit.
941          // The following is essentially a do-while loop that also handles the zero case.
942          // Costs a bit more than early returning for the zero case,
943          // but cheaper in terms of deployment and overall runtime costs.
944          for { 
945              // Initialize and perform the first pass without check.
946              let temp := value
947                  // Move the pointer 1 byte leftwards to point to an empty character slot.
948                  ptr := sub(ptr, 1)
949                  // Write the character to the pointer. 48 is the ASCII index of '0'.
950                  mstore8(ptr, add(48, mod(temp, 10)))
951                  temp := div(temp, 10)
952          } temp { 
953              // Keep dividing `temp` until zero.
954         temp := div(temp, 10)
955          } { 
956              // Body of the for loop.
957         ptr := sub(ptr, 1)
958          mstore8(ptr, add(48, mod(temp, 10)))
959          }
960 
961      let length := sub(end, ptr)
962          // Move the pointer 32 bytes leftwards to make room for the length.
963          ptr := sub(ptr, 32)
964          // Store the length.
965          mstore(ptr, length)
966         }
967     }
968 
969     function withdraw() external onlyOwner {
970         uint256 balance = address(this).balance;
971         payable(msg.sender).transfer(balance);
972     }
973 }