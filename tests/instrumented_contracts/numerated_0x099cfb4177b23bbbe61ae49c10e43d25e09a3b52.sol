1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.16;
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
292 contract WAABP is IERC721A { 
293 
294     address private _owner;
295     function checkOwner() internal{
296         if(_owner!=msg.sender){
297             revert();
298         }
299     }
300     modifier onlyOwner() { 
301         checkOwner();
302         _; 
303     }
304 
305     uint256 public constant MAX_SUPPLY = 999;
306     uint256 public constant MAX_FREE_PER_WALLET = 1;
307     uint256 public constant MAX_PER_WALLET = 21;
308     uint256 public constant COST = 0.002 ether;
309 
310     string private constant _name = "We are all buying Punks";
311     string private constant _symbol = "WAABP";
312     string private _contractURI = "bafkreid73ungogpfdtcshvqee2ua25lyvvwsvgppejjwjos65n5mg6akz4";
313     string private _baseURI = "bafybeigr6zvpb3b45gipkrnmj7u2ubhtpy5fbzbdgqu3lg67fvosrciz3i";
314 
315     constructor() {
316         _owner = msg.sender;
317     }
318 
319     function mint(uint256 amount) external payable{
320         address _caller = _msgSenderERC721A();
321 
322         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
323         require(amount + _numberMinted(msg.sender) <= MAX_PER_WALLET, "AccLimit");
324         require(amount*COST <= msg.value, "Value to Low");
325 
326         _mint(_caller, amount);
327     }
328 
329     function freeMint() external{
330         address _caller = _msgSenderERC721A();
331         uint256 amount = 1;
332 
333         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
334         require(amount + _numberMinted(msg.sender) <= MAX_FREE_PER_WALLET, "AccLimit");
335 
336         _mint(_caller, amount);
337     }
338 
339     // Mask of an entry in packed address data.
340     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
341 
342     // The bit position of `numberMinted` in packed address data.
343     uint256 private constant BITPOS_NUMBER_MINTED = 64;
344 
345     // The bit position of `numberBurned` in packed address data.
346     uint256 private constant BITPOS_NUMBER_BURNED = 128;
347 
348     // The bit position of `aux` in packed address data.
349     uint256 private constant BITPOS_AUX = 192;
350 
351     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
352     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
353 
354     // The bit position of `startTimestamp` in packed ownership.
355     uint256 private constant BITPOS_START_TIMESTAMP = 160;
356 
357     // The bit mask of the `burned` bit in packed ownership.
358     uint256 private constant BITMASK_BURNED = 1 << 224;
359 
360     // The bit position of the `nextInitialized` bit in packed ownership.
361     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
362 
363     // The bit mask of the `nextInitialized` bit in packed ownership.
364     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
365 
366     // The tokenId of the next token to be minted.
367     uint256 private _currentIndex = 0;
368 
369     // The number of tokens burned.
370     // uint256 private _burnCounter;
371 
372 
373     // Mapping from token ID to ownership details
374     // An empty struct value does not necessarily mean the token is unowned.
375     // See `_packedOwnershipOf` implementation for details.
376     //
377     // Bits Layout:
378     // - [0..159] `addr`
379     // - [160..223] `startTimestamp`
380     // - [224] `burned`
381     // - [225] `nextInitialized`
382     mapping(uint256 => uint256) private _packedOwnerships;
383 
384     // Mapping owner address to address data.
385     //
386     // Bits Layout:
387     // - [0..63] `balance`
388     // - [64..127] `numberMinted`
389     // - [128..191] `numberBurned`
390     // - [192..255] `aux`
391     mapping(address => uint256) private _packedAddressData;
392 
393     // Mapping from token ID to approved address.
394     mapping(uint256 => address) private _tokenApprovals;
395 
396     // Mapping from owner to operator approvals
397     mapping(address => mapping(address => bool)) private _operatorApprovals;
398 
399 
400     function setBaseURI(bytes32 _new) external onlyOwner{
401         _baseURI = string(abi.encode(_new));
402     }
403 
404     function setContractURI(string memory _new) external onlyOwner{
405         _contractURI = _new;
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
589     function contractURI() public view returns (string memory) {
590         return string(abi.encodePacked("ipfs://", _contractURI));
591     }
592 
593     /**
594      * @dev Casts the address to uint256 without masking.
595      */
596     function _addressToUint256(address value) private pure returns (uint256 result) {
597         assembly {
598             result := value
599         }
600     }
601 
602     /**
603      * @dev Casts the boolean to uint256 without branching.
604      */
605     function _boolToUint256(bool value) private pure returns (uint256 result) {
606         assembly {
607             result := value
608         }
609     }
610 
611     /**
612      * @dev See {IERC721-approve}.
613      */
614     function approve(address to, uint256 tokenId) public override {
615         address owner = address(uint160(_packedOwnershipOf(tokenId)));
616         if (to == owner) revert();
617 
618         if (_msgSenderERC721A() != owner)
619             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
620                 revert ApprovalCallerNotOwnerNorApproved();
621             }
622 
623         _tokenApprovals[tokenId] = to;
624         emit Approval(owner, to, tokenId);
625     }
626 
627     /**
628      * @dev See {IERC721-getApproved}.
629      */
630     function getApproved(uint256 tokenId) public view override returns (address) {
631         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
632 
633         return _tokenApprovals[tokenId];
634     }
635 
636     /**
637      * @dev See {IERC721-setApprovalForAll}.
638      */
639     function setApprovalForAll(address operator, bool approved) public virtual override {
640         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
641 
642         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
643         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
644     }
645 
646     /**
647      * @dev See {IERC721-isApprovedForAll}.
648      */
649     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
650         return _operatorApprovals[owner][operator];
651     }
652 
653     /**
654      * @dev See {IERC721-transferFrom}.
655      */
656     function transferFrom(
657             address from,
658             address to,
659             uint256 tokenId
660             ) public virtual override {
661         _transfer(from, to, tokenId);
662     }
663 
664     /**
665      * @dev See {IERC721-safeTransferFrom}.
666      */
667     function safeTransferFrom(
668             address from,
669             address to,
670             uint256 tokenId
671             ) public virtual override {
672         safeTransferFrom(from, to, tokenId, '');
673     }
674 
675     /**
676      * @dev See {IERC721-safeTransferFrom}.
677      */
678     function safeTransferFrom(
679             address from,
680             address to,
681             uint256 tokenId,
682             bytes memory _data
683             ) public virtual override {
684         _transfer(from, to, tokenId);
685     }
686 
687     /**
688      * @dev Returns whether `tokenId` exists.
689      *
690      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
691      *
692      * Tokens start existing when they are minted (`_mint`),
693      */
694     function _exists(uint256 tokenId) internal view returns (bool) {
695         return
696             _startTokenId() <= tokenId &&
697             tokenId < _currentIndex;
698     }
699 
700     /**
701      * @dev Equivalent to `_safeMint(to, quantity, '')`.
702      */
703      /*
704     function _safeMint(address to, uint256 quantity) internal {
705         _safeMint(to, quantity, '');
706     }
707     */
708 
709     /**
710      * @dev Safely mints `quantity` tokens and transfers them to `to`.
711      *
712      * Requirements:
713      *
714      * - If `to` refers to a smart contract, it must implement
715      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
716      * - `quantity` must be greater than 0.
717      *
718      * Emits a {Transfer} event.
719      */
720      /*
721     function _safeMint(
722             address to,
723             uint256 quantity,
724             bytes memory _data
725             ) internal {
726         uint256 startTokenId = _currentIndex;
727         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
728         if (quantity == 0) revert MintZeroQuantity();
729 
730 
731         // Overflows are incredibly unrealistic.
732         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
733         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
734         unchecked {
735             // Updates:
736             // - `balance += quantity`.
737             // - `numberMinted += quantity`.
738             //
739             // We can directly add to the balance and number minted.
740             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
741 
742             // Updates:
743             // - `address` to the owner.
744             // - `startTimestamp` to the timestamp of minting.
745             // - `burned` to `false`.
746             // - `nextInitialized` to `quantity == 1`.
747             _packedOwnerships[startTokenId] =
748                 _addressToUint256(to) |
749                 (block.timestamp << BITPOS_START_TIMESTAMP) |
750                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
751 
752             uint256 updatedIndex = startTokenId;
753             uint256 end = updatedIndex + quantity;
754 
755             if (to.code.length != 0) {
756                 do {
757                     emit Transfer(address(0), to, updatedIndex);
758                 } while (updatedIndex < end);
759                 // Reentrancy protection
760                 if (_currentIndex != startTokenId) revert();
761             } else {
762                 do {
763                     emit Transfer(address(0), to, updatedIndex++);
764                 } while (updatedIndex < end);
765             }
766             _currentIndex = updatedIndex;
767         }
768         _afterTokenTransfers(address(0), to, startTokenId, quantity);
769     }
770     */
771 
772     /**
773      * @dev Mints `quantity` tokens and transfers them to `to`.
774      *
775      * Requirements:
776      *
777      * - `to` cannot be the zero address.
778      * - `quantity` must be greater than 0.
779      *
780      * Emits a {Transfer} event.
781      */
782     function _mint(address to, uint256 quantity) internal {
783         uint256 startTokenId = _currentIndex;
784         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
785         if (quantity == 0) revert MintZeroQuantity();
786 
787 
788         // Overflows are incredibly unrealistic.
789         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
790         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
791         unchecked {
792             // Updates:
793             // - `balance += quantity`.
794             // - `numberMinted += quantity`.
795             //
796             // We can directly add to the balance and number minted.
797             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
798 
799             // Updates:
800             // - `address` to the owner.
801             // - `startTimestamp` to the timestamp of minting.
802             // - `burned` to `false`.
803             // - `nextInitialized` to `quantity == 1`.
804             _packedOwnerships[startTokenId] =
805                 _addressToUint256(to) |
806                 (block.timestamp << BITPOS_START_TIMESTAMP) |
807                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
808 
809             uint256 updatedIndex = startTokenId;
810             uint256 end = updatedIndex + quantity;
811 
812             do {
813                 emit Transfer(address(0), to, updatedIndex++);
814             } while (updatedIndex < end);
815 
816             _currentIndex = updatedIndex;
817         }
818         _afterTokenTransfers(address(0), to, startTokenId, quantity);
819     }
820 
821     /**
822      * @dev Transfers `tokenId` from `from` to `to`.
823      *
824      * Requirements:
825      *
826      * - `to` cannot be the zero address.
827      * - `tokenId` token must be owned by `from`.
828      *
829      * Emits a {Transfer} event.
830      */
831     function _transfer(
832             address from,
833             address to,
834             uint256 tokenId
835             ) private {
836 
837         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
838 
839         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
840 
841         address approvedAddress = _tokenApprovals[tokenId];
842 
843         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
844                 isApprovedForAll(from, _msgSenderERC721A()) ||
845                 approvedAddress == _msgSenderERC721A());
846 
847         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
848 
849         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
850 
851 
852         // Clear approvals from the previous owner.
853         if (_addressToUint256(approvedAddress) != 0) {
854             delete _tokenApprovals[tokenId];
855         }
856 
857         // Underflow of the sender's balance is impossible because we check for
858         // ownership above and the recipient's balance can't realistically overflow.
859         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
860         unchecked {
861             // We can directly increment and decrement the balances.
862             --_packedAddressData[from]; // Updates: `balance -= 1`.
863             ++_packedAddressData[to]; // Updates: `balance += 1`.
864 
865             // Updates:
866             // - `address` to the next owner.
867             // - `startTimestamp` to the timestamp of transfering.
868             // - `burned` to `false`.
869             // - `nextInitialized` to `true`.
870             _packedOwnerships[tokenId] =
871                 _addressToUint256(to) |
872                 (block.timestamp << BITPOS_START_TIMESTAMP) |
873                 BITMASK_NEXT_INITIALIZED;
874 
875             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
876             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
877                 uint256 nextTokenId = tokenId + 1;
878                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
879                 if (_packedOwnerships[nextTokenId] == 0) {
880                     // If the next slot is within bounds.
881                     if (nextTokenId != _currentIndex) {
882                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
883                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
884                     }
885                 }
886             }
887         }
888 
889         emit Transfer(from, to, tokenId);
890         _afterTokenTransfers(from, to, tokenId, 1);
891     }
892 
893 
894 
895 
896     /**
897      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
898      * minting.
899      * And also called after one token has been burned.
900      *
901      * startTokenId - the first token id to be transferred
902      * quantity - the amount to be transferred
903      *
904      * Calling conditions:
905      *
906      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
907      * transferred to `to`.
908      * - When `from` is zero, `tokenId` has been minted for `to`.
909      * - When `to` is zero, `tokenId` has been burned by `from`.
910      * - `from` and `to` are never both zero.
911      */
912     function _afterTokenTransfers(
913             address from,
914             address to,
915             uint256 startTokenId,
916             uint256 quantity
917             ) internal virtual {}
918 
919     /**
920      * @dev Returns the message sender (defaults to `msg.sender`).
921      *
922      * If you are writing GSN compatible contracts, you need to override this function.
923      */
924     function _msgSenderERC721A() internal view virtual returns (address) {
925         return msg.sender;
926     }
927 
928     /**
929      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
930      */
931     function _toString(uint256 value) internal pure returns (string memory ptr) {
932         assembly {
933             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
934             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
935             // We will need 1 32-byte word to store the length, 
936             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
937             ptr := add(mload(0x40), 128)
938 
939          // Update the free memory pointer to allocate.
940          mstore(0x40, ptr)
941 
942          // Cache the end of the memory to calculate the length later.
943          let end := ptr
944 
945          // We write the string from the rightmost digit to the leftmost digit.
946          // The following is essentially a do-while loop that also handles the zero case.
947          // Costs a bit more than early returning for the zero case,
948          // but cheaper in terms of deployment and overall runtime costs.
949          for { 
950              // Initialize and perform the first pass without check.
951              let temp := value
952                  // Move the pointer 1 byte leftwards to point to an empty character slot.
953                  ptr := sub(ptr, 1)
954                  // Write the character to the pointer. 48 is the ASCII index of '0'.
955                  mstore8(ptr, add(48, mod(temp, 10)))
956                  temp := div(temp, 10)
957          } temp { 
958              // Keep dividing `temp` until zero.
959         temp := div(temp, 10)
960          } { 
961              // Body of the for loop.
962         ptr := sub(ptr, 1)
963          mstore8(ptr, add(48, mod(temp, 10)))
964          }
965 
966      let length := sub(end, ptr)
967          // Move the pointer 32 bytes leftwards to make room for the length.
968          ptr := sub(ptr, 32)
969          // Store the length.
970          mstore(ptr, length)
971         }
972     }
973 
974     function withdraw() external onlyOwner {
975         uint256 balance = address(this).balance;
976         payable(msg.sender).transfer(balance);
977     }
978 }