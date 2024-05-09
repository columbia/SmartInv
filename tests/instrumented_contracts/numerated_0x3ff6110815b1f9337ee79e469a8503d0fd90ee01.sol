1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-27
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
292 contract DuckPunks is IERC721A { 
293 
294     address private _owner;
295     function owner() public view returns(address){
296         return _owner;
297     }
298 
299     modifier onlyOwner() { 
300         require(_owner==msg.sender);
301         _; 
302     }
303 
304     uint256 public constant MAX_SUPPLY = 2000;
305     uint256 public MAX_FREE = 1666;
306     uint256 public MAX_FREE_PER_WALLET = 1;
307     uint256 public COST = 0.001 ether;
308 
309     string private constant _name = "DuckPunks";
310     string private constant _symbol = "DUCKPUNK";
311     string public constant contractURI = "ipfs://QmSyjW3sKLcLvJoJZXjRcwGMP3hGa8Fn4Vn3uroLYhNbqV";
312     string private _baseURI = "QmSyjW3sKLcLvJoJZXjRcwGMP3hGa8Fn4Vn3uroLYhNbqV";
313 
314     constructor() {
315         _owner = msg.sender;
316     }
317 
318     function mint(uint256 amount) external payable{
319         address _caller = _msgSenderERC721A();
320 
321         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
322         require(amount*COST <= msg.value, "Value to Low");
323 
324         _mint(_caller, amount);
325     }
326 
327     function freeMint() external{
328         address _caller = _msgSenderERC721A();
329         uint256 amount = 1;
330 
331         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
332         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "Max per Wallet");
333 
334         _mint(_caller, amount);
335     }
336 
337     // Mask of an entry in packed address data.
338     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
339 
340     // The bit position of `numberMinted` in packed address data.
341     uint256 private constant BITPOS_NUMBER_MINTED = 64;
342 
343     // The bit position of `numberBurned` in packed address data.
344     uint256 private constant BITPOS_NUMBER_BURNED = 128;
345 
346     // The bit position of `aux` in packed address data.
347     uint256 private constant BITPOS_AUX = 192;
348 
349     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
350     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
351 
352     // The bit position of `startTimestamp` in packed ownership.
353     uint256 private constant BITPOS_START_TIMESTAMP = 160;
354 
355     // The bit mask of the `burned` bit in packed ownership.
356     uint256 private constant BITMASK_BURNED = 1 << 224;
357 
358     // The bit position of the `nextInitialized` bit in packed ownership.
359     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
360 
361     // The bit mask of the `nextInitialized` bit in packed ownership.
362     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
363 
364     // The tokenId of the next token to be minted.
365     uint256 private _currentIndex = 0;
366 
367     // The number of tokens burned.
368     // uint256 private _burnCounter;
369 
370 
371     // Mapping from token ID to ownership details
372     // An empty struct value does not necessarily mean the token is unowned.
373     // See `_packedOwnershipOf` implementation for details.
374     //
375     // Bits Layout:
376     // - [0..159] `addr`
377     // - [160..223] `startTimestamp`
378     // - [224] `burned`
379     // - [225] `nextInitialized`
380     mapping(uint256 => uint256) private _packedOwnerships;
381 
382     // Mapping owner address to address data.
383     //
384     // Bits Layout:
385     // - [0..63] `balance`
386     // - [64..127] `numberMinted`
387     // - [128..191] `numberBurned`
388     // - [192..255] `aux`
389     mapping(address => uint256) private _packedAddressData;
390 
391     // Mapping from token ID to approved address.
392     mapping(uint256 => address) private _tokenApprovals;
393 
394     // Mapping from owner to operator approvals
395     mapping(address => mapping(address => bool)) private _operatorApprovals;
396 
397 
398     function setData(string memory _base) external onlyOwner{
399         _baseURI = _base;
400     }
401 
402     function setConfig(uint256 _MAX_FREE_PER_WALLET, uint256 _COST, uint256 _MAX_FREE) external onlyOwner{
403         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
404         COST = _COST;
405         MAX_FREE = _MAX_FREE;
406     }
407 
408     /**
409      * @dev Returns the starting token ID. 
410      * To change the starting token ID, please override this function.
411      */
412     function _startTokenId() internal view virtual returns (uint256) {
413         return 0;
414     }
415 
416     /**
417      * @dev Returns the next token ID to be minted.
418      */
419     function _nextTokenId() internal view returns (uint256) {
420         return _currentIndex;
421     }
422 
423     /**
424      * @dev Returns the total number of tokens in existence.
425      * Burned tokens will reduce the count. 
426      * To get the total number of tokens minted, please see `_totalMinted`.
427      */
428     function totalSupply() public view override returns (uint256) {
429         // Counter underflow is impossible as _burnCounter cannot be incremented
430         // more than `_currentIndex - _startTokenId()` times.
431         unchecked {
432             return _currentIndex - _startTokenId();
433         }
434     }
435 
436     /**
437      * @dev Returns the total amount of tokens minted in the contract.
438      */
439     function _totalMinted() internal view returns (uint256) {
440         // Counter underflow is impossible as _currentIndex does not decrement,
441         // and it is initialized to `_startTokenId()`
442         unchecked {
443             return _currentIndex - _startTokenId();
444         }
445     }
446 
447 
448     /**
449      * @dev See {IERC165-supportsInterface}.
450      */
451     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
452         // The interface IDs are constants representing the first 4 bytes of the XOR of
453         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
454         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
455         return
456             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
457             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
458             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
459     }
460 
461     /**
462      * @dev See {IERC721-balanceOf}.
463      */
464     function balanceOf(address owner) public view override returns (uint256) {
465         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
466         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
467     }
468 
469     /**
470      * Returns the number of tokens minted by `owner`.
471      */
472     function _numberMinted(address owner) internal view returns (uint256) {
473         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
474     }
475 
476 
477 
478     /**
479      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
480      */
481     function _getAux(address owner) internal view returns (uint64) {
482         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
483     }
484 
485     /**
486      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
487      * If there are multiple variables, please pack them into a uint64.
488      */
489     function _setAux(address owner, uint64 aux) internal {
490         uint256 packed = _packedAddressData[owner];
491         uint256 auxCasted;
492         assembly { // Cast aux without masking.
493             auxCasted := aux
494         }
495         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
496         _packedAddressData[owner] = packed;
497     }
498 
499     /**
500      * Returns the packed ownership data of `tokenId`.
501      */
502     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
503         uint256 curr = tokenId;
504 
505         unchecked {
506             if (_startTokenId() <= curr)
507                 if (curr < _currentIndex) {
508                     uint256 packed = _packedOwnerships[curr];
509                     // If not burned.
510                     if (packed & BITMASK_BURNED == 0) {
511                         // Invariant:
512                         // There will always be an ownership that has an address and is not burned
513                         // before an ownership that does not have an address and is not burned.
514                         // Hence, curr will not underflow.
515                         //
516                         // We can directly compare the packed value.
517                         // If the address is zero, packed is zero.
518                         while (packed == 0) {
519                             packed = _packedOwnerships[--curr];
520                         }
521                         return packed;
522                     }
523                 }
524         }
525         revert OwnerQueryForNonexistentToken();
526     }
527 
528     /**
529      * Returns the unpacked `TokenOwnership` struct from `packed`.
530      */
531     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
532         ownership.addr = address(uint160(packed));
533         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
534         ownership.burned = packed & BITMASK_BURNED != 0;
535     }
536 
537     /**
538      * Returns the unpacked `TokenOwnership` struct at `index`.
539      */
540     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
541         return _unpackedOwnership(_packedOwnerships[index]);
542     }
543 
544     /**
545      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
546      */
547     function _initializeOwnershipAt(uint256 index) internal {
548         if (_packedOwnerships[index] == 0) {
549             _packedOwnerships[index] = _packedOwnershipOf(index);
550         }
551     }
552 
553     /**
554      * Gas spent here starts off proportional to the maximum mint batch size.
555      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
556      */
557     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
558         return _unpackedOwnership(_packedOwnershipOf(tokenId));
559     }
560 
561     /**
562      * @dev See {IERC721-ownerOf}.
563      */
564     function ownerOf(uint256 tokenId) public view override returns (address) {
565         return address(uint160(_packedOwnershipOf(tokenId)));
566     }
567 
568     /**
569      * @dev See {IERC721Metadata-name}.
570      */
571     function name() public view virtual override returns (string memory) {
572         return _name;
573     }
574 
575     /**
576      * @dev See {IERC721Metadata-symbol}.
577      */
578     function symbol() public view virtual override returns (string memory) {
579         return _symbol;
580     }
581 
582     
583     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
584         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
585         string memory baseURI = _baseURI;
586         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
587     }
588 
589     /*
590     function contractURI() public view returns (string memory) {
591         return string(abi.encodePacked("ipfs://", _contractURI));
592     }
593     */
594 
595     /**
596      * @dev Casts the address to uint256 without masking.
597      */
598     function _addressToUint256(address value) private pure returns (uint256 result) {
599         assembly {
600             result := value
601         }
602     }
603 
604     /**
605      * @dev Casts the boolean to uint256 without branching.
606      */
607     function _boolToUint256(bool value) private pure returns (uint256 result) {
608         assembly {
609             result := value
610         }
611     }
612 
613     /**
614      * @dev See {IERC721-approve}.
615      */
616     function approve(address to, uint256 tokenId) public override {
617         address owner = address(uint160(_packedOwnershipOf(tokenId)));
618         if (to == owner) revert();
619 
620         if (_msgSenderERC721A() != owner)
621             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
622                 revert ApprovalCallerNotOwnerNorApproved();
623             }
624 
625         _tokenApprovals[tokenId] = to;
626         emit Approval(owner, to, tokenId);
627     }
628 
629     /**
630      * @dev See {IERC721-getApproved}.
631      */
632     function getApproved(uint256 tokenId) public view override returns (address) {
633         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
634 
635         return _tokenApprovals[tokenId];
636     }
637 
638     /**
639      * @dev See {IERC721-setApprovalForAll}.
640      */
641     function setApprovalForAll(address operator, bool approved) public virtual override {
642         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
643 
644         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
645         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
646     }
647 
648     /**
649      * @dev See {IERC721-isApprovedForAll}.
650      */
651     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
652         return _operatorApprovals[owner][operator];
653     }
654 
655     /**
656      * @dev See {IERC721-transferFrom}.
657      */
658     function transferFrom(
659             address from,
660             address to,
661             uint256 tokenId
662             ) public virtual override {
663         _transfer(from, to, tokenId);
664     }
665 
666     /**
667      * @dev See {IERC721-safeTransferFrom}.
668      */
669     function safeTransferFrom(
670             address from,
671             address to,
672             uint256 tokenId
673             ) public virtual override {
674         safeTransferFrom(from, to, tokenId, '');
675     }
676 
677     /**
678      * @dev See {IERC721-safeTransferFrom}.
679      */
680     function safeTransferFrom(
681             address from,
682             address to,
683             uint256 tokenId,
684             bytes memory _data
685             ) public virtual override {
686         _transfer(from, to, tokenId);
687     }
688 
689     /**
690      * @dev Returns whether `tokenId` exists.
691      *
692      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
693      *
694      * Tokens start existing when they are minted (`_mint`),
695      */
696     function _exists(uint256 tokenId) internal view returns (bool) {
697         return
698             _startTokenId() <= tokenId &&
699             tokenId < _currentIndex;
700     }
701 
702     /**
703      * @dev Equivalent to `_safeMint(to, quantity, '')`.
704      */
705      /*
706     function _safeMint(address to, uint256 quantity) internal {
707         _safeMint(to, quantity, '');
708     }
709     */
710 
711     /**
712      * @dev Safely mints `quantity` tokens and transfers them to `to`.
713      *
714      * Requirements:
715      *
716      * - If `to` refers to a smart contract, it must implement
717      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
718      * - `quantity` must be greater than 0.
719      *
720      * Emits a {Transfer} event.
721      */
722      /*
723     function _safeMint(
724             address to,
725             uint256 quantity,
726             bytes memory _data
727             ) internal {
728         uint256 startTokenId = _currentIndex;
729         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
730         if (quantity == 0) revert MintZeroQuantity();
731 
732 
733         // Overflows are incredibly unrealistic.
734         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
735         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
736         unchecked {
737             // Updates:
738             // - `balance += quantity`.
739             // - `numberMinted += quantity`.
740             //
741             // We can directly add to the balance and number minted.
742             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
743 
744             // Updates:
745             // - `address` to the owner.
746             // - `startTimestamp` to the timestamp of minting.
747             // - `burned` to `false`.
748             // - `nextInitialized` to `quantity == 1`.
749             _packedOwnerships[startTokenId] =
750                 _addressToUint256(to) |
751                 (block.timestamp << BITPOS_START_TIMESTAMP) |
752                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
753 
754             uint256 updatedIndex = startTokenId;
755             uint256 end = updatedIndex + quantity;
756 
757             if (to.code.length != 0) {
758                 do {
759                     emit Transfer(address(0), to, updatedIndex);
760                 } while (updatedIndex < end);
761                 // Reentrancy protection
762                 if (_currentIndex != startTokenId) revert();
763             } else {
764                 do {
765                     emit Transfer(address(0), to, updatedIndex++);
766                 } while (updatedIndex < end);
767             }
768             _currentIndex = updatedIndex;
769         }
770         _afterTokenTransfers(address(0), to, startTokenId, quantity);
771     }
772     */
773 
774     /**
775      * @dev Mints `quantity` tokens and transfers them to `to`.
776      *
777      * Requirements:
778      *
779      * - `to` cannot be the zero address.
780      * - `quantity` must be greater than 0.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _mint(address to, uint256 quantity) internal {
785         uint256 startTokenId = _currentIndex;
786         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
787         if (quantity == 0) revert MintZeroQuantity();
788 
789 
790         // Overflows are incredibly unrealistic.
791         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
792         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
793         unchecked {
794             // Updates:
795             // - `balance += quantity`.
796             // - `numberMinted += quantity`.
797             //
798             // We can directly add to the balance and number minted.
799             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
800 
801             // Updates:
802             // - `address` to the owner.
803             // - `startTimestamp` to the timestamp of minting.
804             // - `burned` to `false`.
805             // - `nextInitialized` to `quantity == 1`.
806             _packedOwnerships[startTokenId] =
807                 _addressToUint256(to) |
808                 (block.timestamp << BITPOS_START_TIMESTAMP) |
809                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
810 
811             uint256 updatedIndex = startTokenId;
812             uint256 end = updatedIndex + quantity;
813 
814             do {
815                 emit Transfer(address(0), to, updatedIndex++);
816             } while (updatedIndex < end);
817 
818             _currentIndex = updatedIndex;
819         }
820         _afterTokenTransfers(address(0), to, startTokenId, quantity);
821     }
822 
823     /**
824      * @dev Transfers `tokenId` from `from` to `to`.
825      *
826      * Requirements:
827      *
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must be owned by `from`.
830      *
831      * Emits a {Transfer} event.
832      */
833     function _transfer(
834             address from,
835             address to,
836             uint256 tokenId
837             ) private {
838 
839         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
840 
841         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
842 
843         address approvedAddress = _tokenApprovals[tokenId];
844 
845         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
846                 isApprovedForAll(from, _msgSenderERC721A()) ||
847                 approvedAddress == _msgSenderERC721A());
848 
849         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
850 
851         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
852 
853 
854         // Clear approvals from the previous owner.
855         if (_addressToUint256(approvedAddress) != 0) {
856             delete _tokenApprovals[tokenId];
857         }
858 
859         // Underflow of the sender's balance is impossible because we check for
860         // ownership above and the recipient's balance can't realistically overflow.
861         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
862         unchecked {
863             // We can directly increment and decrement the balances.
864             --_packedAddressData[from]; // Updates: `balance -= 1`.
865             ++_packedAddressData[to]; // Updates: `balance += 1`.
866 
867             // Updates:
868             // - `address` to the next owner.
869             // - `startTimestamp` to the timestamp of transfering.
870             // - `burned` to `false`.
871             // - `nextInitialized` to `true`.
872             _packedOwnerships[tokenId] =
873                 _addressToUint256(to) |
874                 (block.timestamp << BITPOS_START_TIMESTAMP) |
875                 BITMASK_NEXT_INITIALIZED;
876 
877             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
878             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
879                 uint256 nextTokenId = tokenId + 1;
880                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
881                 if (_packedOwnerships[nextTokenId] == 0) {
882                     // If the next slot is within bounds.
883                     if (nextTokenId != _currentIndex) {
884                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
885                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
886                     }
887                 }
888             }
889         }
890 
891         emit Transfer(from, to, tokenId);
892         _afterTokenTransfers(from, to, tokenId, 1);
893     }
894 
895 
896 
897 
898     /**
899      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
900      * minting.
901      * And also called after one token has been burned.
902      *
903      * startTokenId - the first token id to be transferred
904      * quantity - the amount to be transferred
905      *
906      * Calling conditions:
907      *
908      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
909      * transferred to `to`.
910      * - When `from` is zero, `tokenId` has been minted for `to`.
911      * - When `to` is zero, `tokenId` has been burned by `from`.
912      * - `from` and `to` are never both zero.
913      */
914     function _afterTokenTransfers(
915             address from,
916             address to,
917             uint256 startTokenId,
918             uint256 quantity
919             ) internal virtual {}
920 
921     /**
922      * @dev Returns the message sender (defaults to `msg.sender`).
923      *
924      * If you are writing GSN compatible contracts, you need to override this function.
925      */
926     function _msgSenderERC721A() internal view virtual returns (address) {
927         return msg.sender;
928     }
929 
930     /**
931      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
932      */
933     function _toString(uint256 value) internal pure returns (string memory ptr) {
934         assembly {
935             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
936             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
937             // We will need 1 32-byte word to store the length, 
938             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
939             ptr := add(mload(0x40), 128)
940 
941          // Update the free memory pointer to allocate.
942          mstore(0x40, ptr)
943 
944          // Cache the end of the memory to calculate the length later.
945          let end := ptr
946 
947          // We write the string from the rightmost digit to the leftmost digit.
948          // The following is essentially a do-while loop that also handles the zero case.
949          // Costs a bit more than early returning for the zero case,
950          // but cheaper in terms of deployment and overall runtime costs.
951          for { 
952              // Initialize and perform the first pass without check.
953              let temp := value
954                  // Move the pointer 1 byte leftwards to point to an empty character slot.
955                  ptr := sub(ptr, 1)
956                  // Write the character to the pointer. 48 is the ASCII index of '0'.
957                  mstore8(ptr, add(48, mod(temp, 10)))
958                  temp := div(temp, 10)
959          } temp { 
960              // Keep dividing `temp` until zero.
961         temp := div(temp, 10)
962          } { 
963              // Body of the for loop.
964         ptr := sub(ptr, 1)
965          mstore8(ptr, add(48, mod(temp, 10)))
966          }
967 
968      let length := sub(end, ptr)
969          // Move the pointer 32 bytes leftwards to make room for the length.
970          ptr := sub(ptr, 32)
971          // Store the length.
972          mstore(ptr, length)
973         }
974     }
975 
976     function withdraw() external onlyOwner {
977         uint256 balance = address(this).balance;
978         payable(msg.sender).transfer(balance);
979     }
980 }