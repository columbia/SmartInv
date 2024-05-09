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
288 contract Dukcs is IERC721A { 
289     address private _owner;
290     function owner() public view returns(address){
291         return _owner;
292     }
293     modifier onlyOwner() { 
294         require(_owner==msg.sender);
295         _; 
296     }
297 
298     uint256 public constant MAX_SUPPLY = 1111;
299     uint256 public MAX_FREE = 777;
300     uint256 public MAX_FREE_PER_WALLET = 1;
301     uint256 public COST = 0.001 ether;
302 
303     string private constant _name = "Dukcs";
304     string private constant _symbol = "DUKC";
305     string public constant contractURI = "ipfs://QmfYkDgiasHJ999VbtYfWkGB9ebNADB5ePn74P6kj7txQC";
306     string private _baseURI = "QmfYkDgiasHJ999VbtYfWkGB9ebNADB5ePn74P6kj7txQC";
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
480      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
481      * If there are multiple variables, please pack them into a uint64.
482      */
483     function _setAux(address owner, uint64 aux) internal {
484         uint256 packed = _packedAddressData[owner];
485         uint256 auxCasted;
486         assembly { // Cast aux without masking.
487             auxCasted := aux
488         }
489         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
490         _packedAddressData[owner] = packed;
491     }
492 
493     /**
494      * Returns the packed ownership data of `tokenId`.
495      */
496     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
497         uint256 curr = tokenId;
498 
499         unchecked {
500             if (_startTokenId() <= curr)
501                 if (curr < _currentIndex) {
502                     uint256 packed = _packedOwnerships[curr];
503                     // If not burned.
504                     if (packed & BITMASK_BURNED == 0) {
505                         // Invariant:
506                         // There will always be an ownership that has an address and is not burned
507                         // before an ownership that does not have an address and is not burned.
508                         // Hence, curr will not underflow.
509                         //
510                         // We can directly compare the packed value.
511                         // If the address is zero, packed is zero.
512                         while (packed == 0) {
513                             packed = _packedOwnerships[--curr];
514                         }
515                         return packed;
516                     }
517                 }
518         }
519         revert OwnerQueryForNonexistentToken();
520     }
521 
522     /**
523      * Returns the unpacked `TokenOwnership` struct from `packed`.
524      */
525     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
526         ownership.addr = address(uint160(packed));
527         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
528         ownership.burned = packed & BITMASK_BURNED != 0;
529     }
530 
531     /**
532      * Returns the unpacked `TokenOwnership` struct at `index`.
533      */
534     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
535         return _unpackedOwnership(_packedOwnerships[index]);
536     }
537 
538     /**
539      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
540      */
541     function _initializeOwnershipAt(uint256 index) internal {
542         if (_packedOwnerships[index] == 0) {
543             _packedOwnerships[index] = _packedOwnershipOf(index);
544         }
545     }
546 
547     /**
548      * Gas spent here starts off proportional to the maximum mint batch size.
549      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
550      */
551     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
552         return _unpackedOwnership(_packedOwnershipOf(tokenId));
553     }
554 
555     /**
556      * @dev See {IERC721-ownerOf}.
557      */
558     function ownerOf(uint256 tokenId) public view override returns (address) {
559         return address(uint160(_packedOwnershipOf(tokenId)));
560     }
561 
562     /**
563      * @dev See {IERC721Metadata-name}.
564      */
565     function name() public view virtual override returns (string memory) {
566         return _name;
567     }
568 
569     /**
570      * @dev See {IERC721Metadata-symbol}.
571      */
572     function symbol() public view virtual override returns (string memory) {
573         return _symbol;
574     }
575 
576     
577     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
578         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
579         string memory baseURI = _baseURI;
580         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
581     }
582 
583     /*
584     function contractURI() public view returns (string memory) {
585         return string(abi.encodePacked("ipfs://", _contractURI));
586     }
587     */
588 
589     /**
590      * @dev Casts the address to uint256 without masking.
591      */
592     function _addressToUint256(address value) private pure returns (uint256 result) {
593         assembly {
594             result := value
595         }
596     }
597 
598     /**
599      * @dev Casts the boolean to uint256 without branching.
600      */
601     function _boolToUint256(bool value) private pure returns (uint256 result) {
602         assembly {
603             result := value
604         }
605     }
606 
607     /**
608      * @dev See {IERC721-approve}.
609      */
610     function approve(address to, uint256 tokenId) public override {
611         address owner = address(uint160(_packedOwnershipOf(tokenId)));
612         if (to == owner) revert();
613 
614         if (_msgSenderERC721A() != owner)
615             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
616                 revert ApprovalCallerNotOwnerNorApproved();
617             }
618 
619         _tokenApprovals[tokenId] = to;
620         emit Approval(owner, to, tokenId);
621     }
622 
623     /**
624      * @dev See {IERC721-getApproved}.
625      */
626     function getApproved(uint256 tokenId) public view override returns (address) {
627         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
628 
629         return _tokenApprovals[tokenId];
630     }
631 
632     /**
633      * @dev See {IERC721-setApprovalForAll}.
634      */
635     function setApprovalForAll(address operator, bool approved) public virtual override {
636         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
637 
638         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
639         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
640     }
641 
642     /**
643      * @dev See {IERC721-isApprovedForAll}.
644      */
645     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
646         return _operatorApprovals[owner][operator];
647     }
648 
649     /**
650      * @dev See {IERC721-transferFrom}.
651      */
652     function transferFrom(
653             address from,
654             address to,
655             uint256 tokenId
656             ) public virtual override {
657         _transfer(from, to, tokenId);
658     }
659 
660     /**
661      * @dev See {IERC721-safeTransferFrom}.
662      */
663     function safeTransferFrom(
664             address from,
665             address to,
666             uint256 tokenId
667             ) public virtual override {
668         safeTransferFrom(from, to, tokenId, '');
669     }
670 
671     /**
672      * @dev See {IERC721-safeTransferFrom}.
673      */
674     function safeTransferFrom(
675             address from,
676             address to,
677             uint256 tokenId,
678             bytes memory _data
679             ) public virtual override {
680         _transfer(from, to, tokenId);
681     }
682 
683     /**
684      * @dev Returns whether `tokenId` exists.
685      *
686      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
687      *
688      * Tokens start existing when they are minted (`_mint`),
689      */
690     function _exists(uint256 tokenId) internal view returns (bool) {
691         return
692             _startTokenId() <= tokenId &&
693             tokenId < _currentIndex;
694     }
695 
696     /**
697      * @dev Equivalent to `_safeMint(to, quantity, '')`.
698      */
699      /*
700     function _safeMint(address to, uint256 quantity) internal {
701         _safeMint(to, quantity, '');
702     }
703     */
704 
705     /**
706      * @dev Safely mints `quantity` tokens and transfers them to `to`.
707      *
708      * Requirements:
709      *
710      * - If `to` refers to a smart contract, it must implement
711      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
712      * - `quantity` must be greater than 0.
713      *
714      * Emits a {Transfer} event.
715      */
716      /*
717     function _safeMint(
718             address to,
719             uint256 quantity,
720             bytes memory _data
721             ) internal {
722         uint256 startTokenId = _currentIndex;
723         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
724         if (quantity == 0) revert MintZeroQuantity();
725 
726 
727         // Overflows are incredibly unrealistic.
728         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
729         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
730         unchecked {
731             // Updates:
732             // - `balance += quantity`.
733             // - `numberMinted += quantity`.
734             //
735             // We can directly add to the balance and number minted.
736             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
737 
738             // Updates:
739             // - `address` to the owner.
740             // - `startTimestamp` to the timestamp of minting.
741             // - `burned` to `false`.
742             // - `nextInitialized` to `quantity == 1`.
743             _packedOwnerships[startTokenId] =
744                 _addressToUint256(to) |
745                 (block.timestamp << BITPOS_START_TIMESTAMP) |
746                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
747 
748             uint256 updatedIndex = startTokenId;
749             uint256 end = updatedIndex + quantity;
750 
751             if (to.code.length != 0) {
752                 do {
753                     emit Transfer(address(0), to, updatedIndex);
754                 } while (updatedIndex < end);
755                 // Reentrancy protection
756                 if (_currentIndex != startTokenId) revert();
757             } else {
758                 do {
759                     emit Transfer(address(0), to, updatedIndex++);
760                 } while (updatedIndex < end);
761             }
762             _currentIndex = updatedIndex;
763         }
764         _afterTokenTransfers(address(0), to, startTokenId, quantity);
765     }
766     */
767 
768     /**
769      * @dev Mints `quantity` tokens and transfers them to `to`.
770      *
771      * Requirements:
772      *
773      * - `to` cannot be the zero address.
774      * - `quantity` must be greater than 0.
775      *
776      * Emits a {Transfer} event.
777      */
778     function _mint(address to, uint256 quantity) internal {
779         uint256 startTokenId = _currentIndex;
780         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
781         if (quantity == 0) revert MintZeroQuantity();
782 
783 
784         // Overflows are incredibly unrealistic.
785         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
786         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
787         unchecked {
788             // Updates:
789             // - `balance += quantity`.
790             // - `numberMinted += quantity`.
791             //
792             // We can directly add to the balance and number minted.
793             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
794 
795             // Updates:
796             // - `address` to the owner.
797             // - `startTimestamp` to the timestamp of minting.
798             // - `burned` to `false`.
799             // - `nextInitialized` to `quantity == 1`.
800             _packedOwnerships[startTokenId] =
801                 _addressToUint256(to) |
802                 (block.timestamp << BITPOS_START_TIMESTAMP) |
803                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
804 
805             uint256 updatedIndex = startTokenId;
806             uint256 end = updatedIndex + quantity;
807 
808             do {
809                 emit Transfer(address(0), to, updatedIndex++);
810             } while (updatedIndex < end);
811 
812             _currentIndex = updatedIndex;
813         }
814         _afterTokenTransfers(address(0), to, startTokenId, quantity);
815     }
816 
817     /**
818      * @dev Transfers `tokenId` from `from` to `to`.
819      *
820      * Requirements:
821      *
822      * - `to` cannot be the zero address.
823      * - `tokenId` token must be owned by `from`.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _transfer(
828             address from,
829             address to,
830             uint256 tokenId
831             ) private {
832 
833         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
834 
835         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
836 
837         address approvedAddress = _tokenApprovals[tokenId];
838 
839         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
840                 isApprovedForAll(from, _msgSenderERC721A()) ||
841                 approvedAddress == _msgSenderERC721A());
842 
843         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
844 
845         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
846 
847 
848         // Clear approvals from the previous owner.
849         if (_addressToUint256(approvedAddress) != 0) {
850             delete _tokenApprovals[tokenId];
851         }
852 
853         // Underflow of the sender's balance is impossible because we check for
854         // ownership above and the recipient's balance can't realistically overflow.
855         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
856         unchecked {
857             // We can directly increment and decrement the balances.
858             --_packedAddressData[from]; // Updates: `balance -= 1`.
859             ++_packedAddressData[to]; // Updates: `balance += 1`.
860 
861             // Updates:
862             // - `address` to the next owner.
863             // - `startTimestamp` to the timestamp of transfering.
864             // - `burned` to `false`.
865             // - `nextInitialized` to `true`.
866             _packedOwnerships[tokenId] =
867                 _addressToUint256(to) |
868                 (block.timestamp << BITPOS_START_TIMESTAMP) |
869                 BITMASK_NEXT_INITIALIZED;
870 
871             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
872             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
873                 uint256 nextTokenId = tokenId + 1;
874                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
875                 if (_packedOwnerships[nextTokenId] == 0) {
876                     // If the next slot is within bounds.
877                     if (nextTokenId != _currentIndex) {
878                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
879                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
880                     }
881                 }
882             }
883         }
884 
885         emit Transfer(from, to, tokenId);
886         _afterTokenTransfers(from, to, tokenId, 1);
887     }
888 
889 
890 
891 
892     /**
893      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
894      * minting.
895      * And also called after one token has been burned.
896      *
897      * startTokenId - the first token id to be transferred
898      * quantity - the amount to be transferred
899      *
900      * Calling conditions:
901      *
902      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
903      * transferred to `to`.
904      * - When `from` is zero, `tokenId` has been minted for `to`.
905      * - When `to` is zero, `tokenId` has been burned by `from`.
906      * - `from` and `to` are never both zero.
907      */
908     function _afterTokenTransfers(
909             address from,
910             address to,
911             uint256 startTokenId,
912             uint256 quantity
913             ) internal virtual {}
914 
915     /**
916      * @dev Returns the message sender (defaults to `msg.sender`).
917      *
918      * If you are writing GSN compatible contracts, you need to override this function.
919      */
920     function _msgSenderERC721A() internal view virtual returns (address) {
921         return msg.sender;
922     }
923 
924     /**
925      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
926      */
927     function _toString(uint256 value) internal pure returns (string memory ptr) {
928         assembly {
929             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
930             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
931             // We will need 1 32-byte word to store the length, 
932             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
933             ptr := add(mload(0x40), 128)
934 
935          // Update the free memory pointer to allocate.
936          mstore(0x40, ptr)
937 
938          // Cache the end of the memory to calculate the length later.
939          let end := ptr
940 
941          // We write the string from the rightmost digit to the leftmost digit.
942          // The following is essentially a do-while loop that also handles the zero case.
943          // Costs a bit more than early returning for the zero case,
944          // but cheaper in terms of deployment and overall runtime costs.
945          for { 
946              // Initialize and perform the first pass without check.
947              let temp := value
948                  // Move the pointer 1 byte leftwards to point to an empty character slot.
949                  ptr := sub(ptr, 1)
950                  // Write the character to the pointer. 48 is the ASCII index of '0'.
951                  mstore8(ptr, add(48, mod(temp, 10)))
952                  temp := div(temp, 10)
953          } temp { 
954              // Keep dividing `temp` until zero.
955         temp := div(temp, 10)
956          } { 
957              // Body of the for loop.
958         ptr := sub(ptr, 1)
959          mstore8(ptr, add(48, mod(temp, 10)))
960          }
961 
962      let length := sub(end, ptr)
963          // Move the pointer 32 bytes leftwards to make room for the length.
964          ptr := sub(ptr, 32)
965          // Store the length.
966          mstore(ptr, length)
967         }
968     }
969 
970     function withdraw() external onlyOwner {
971         uint256 balance = address(this).balance;
972         payable(msg.sender).transfer(balance);
973     }
974 }