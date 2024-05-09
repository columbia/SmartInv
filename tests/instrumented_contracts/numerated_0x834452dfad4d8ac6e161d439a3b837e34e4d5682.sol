1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 
5 
6 
7 /**
8  * @dev Interface of ERC721A.
9  */
10 interface IERC721A {
11     /**
12      * The caller must own the token or be an approved operator.
13      */
14     error ApprovalCallerNotOwnerNorApproved();
15 
16     /**
17      * The token does not exist.
18      */
19     error ApprovalQueryForNonexistentToken();
20 
21     /**
22      * The caller cannot approve to their own address.
23      */
24     error ApproveToCaller();
25 
26     /**
27      * Cannot query the balance for the zero address.
28      */
29     error BalanceQueryForZeroAddress();
30 
31     /**
32      * Cannot mint to the zero address.
33      */
34     error MintToZeroAddress();
35 
36     /**
37      * The quantity of tokens minted must be more than zero.
38      */
39     error MintZeroQuantity();
40 
41     /**
42      * The token does not exist.
43      */
44     error OwnerQueryForNonexistentToken();
45 
46     /**
47      * The caller must own the token or be an approved operator.
48      */
49     error TransferCallerNotOwnerNorApproved();
50 
51     /**
52      * The token must be owned by `from`.
53      */
54     error TransferFromIncorrectOwner();
55 
56     /**
57      * Cannot safely transfer to a contract that does not implement the
58      * ERC721Receiver interface.
59      */
60     error TransferToNonERC721ReceiverImplementer();
61 
62     /**
63      * Cannot transfer to the zero address.
64      */
65     error TransferToZeroAddress();
66 
67     /**
68      * The token does not exist.
69      */
70     error URIQueryForNonexistentToken();
71 
72     /**
73      * The `quantity` minted with ERC2309 exceeds the safety limit.
74      */
75     error MintERC2309QuantityExceedsLimit();
76 
77     /**
78      * The `extraData` cannot be set on an unintialized ownership slot.
79      */
80     error OwnershipNotInitializedForExtraData();
81 
82     // =============================================================
83     //                            STRUCTS
84     // =============================================================
85 
86     struct TokenOwnership {
87         // The address of the owner.
88         address addr;
89         // Stores the start time of ownership with minimal overhead for tokenomics.
90         uint64 startTimestamp;
91         // Whether the token has been burned.
92         bool burned;
93         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
94         uint24 extraData;
95     }
96 
97     // =============================================================
98     //                         TOKEN COUNTERS
99     // =============================================================
100 
101     /**
102      * @dev Returns the total number of tokens in existence.
103      * Burned tokens will reduce the count.
104      * To get the total number of tokens minted, please see {_totalMinted}.
105      */
106     function totalSupply() external view returns (uint256);
107 
108     // =============================================================
109     //                            IERC165
110     // =============================================================
111 
112     /**
113      * @dev Returns true if this contract implements the interface defined by
114      * `interfaceId`. See the corresponding
115      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
116      * to learn more about how these ids are created.
117      *
118      * This function call must use less than 30000 gas.
119      */
120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
121 
122     // =============================================================
123     //                            IERC721
124     // =============================================================
125 
126     /**
127      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
130 
131     /**
132      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
133      */
134     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables or disables
138      * (`approved`) `operator` to manage all of its assets.
139      */
140     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
141 
142     /**
143      * @dev Returns the number of tokens in `owner`'s account.
144      */
145     function balanceOf(address owner) external view returns (uint256 balance);
146 
147     /**
148      * @dev Returns the owner of the `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function ownerOf(uint256 tokenId) external view returns (address owner);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`,
158      * checking first that contract recipients are aware of the ERC721 protocol
159      * to prevent tokens from being forever locked.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be have been allowed to move
167      * this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement
169      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId,
177         bytes calldata data
178     ) external;
179 
180     /**
181      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) external;
188 
189     /**
190      * @dev Transfers `tokenId` from `from` to `to`.
191      *
192      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
193      * whenever possible.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token
201      * by either {approve} or {setApprovalForAll}.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
213      * The approval is cleared when the token is transferred.
214      *
215      * Only a single account can be approved at a time, so approving the
216      * zero address clears previous approvals.
217      *
218      * Requirements:
219      *
220      * - The caller must own the token or be an approved operator.
221      * - `tokenId` must exist.
222      *
223      * Emits an {Approval} event.
224      */
225     function approve(address to, uint256 tokenId) external;
226 
227     /**
228      * @dev Approve or remove `operator` as an operator for the caller.
229      * Operators can call {transferFrom} or {safeTransferFrom}
230      * for any token owned by the caller.
231      *
232      * Requirements:
233      *
234      * - The `operator` cannot be the caller.
235      *
236      * Emits an {ApprovalForAll} event.
237      */
238     function setApprovalForAll(address operator, bool _approved) external;
239 
240     /**
241      * @dev Returns the account approved for `tokenId` token.
242      *
243      * Requirements:
244      *
245      * - `tokenId` must exist.
246      */
247     function getApproved(uint256 tokenId) external view returns (address operator);
248 
249     /**
250      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
251      *
252      * See {setApprovalForAll}.
253      */
254     function isApprovedForAll(address owner, address operator) external view returns (bool);
255 
256     // =============================================================
257     //                        IERC721Metadata
258     // =============================================================
259 
260     /**
261      * @dev Returns the token collection name.
262      */
263     function name() external view returns (string memory);
264 
265     /**
266      * @dev Returns the token collection symbol.
267      */
268     function symbol() external view returns (string memory);
269 
270     /**
271      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
272      */
273     function tokenURI(uint256 tokenId) external view returns (string memory);
274 
275     // =============================================================
276     //                           IERC2309
277     // =============================================================
278 
279     /**
280      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
281      * (inclusive) is transferred from `from` to `to`, as defined in the
282      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
283      *
284      * See {_mintERC2309} for more details.
285      */
286     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
287 }
288 
289 
290 contract GPunkz is IERC721A { 
291     
292     address private _owner;
293 
294     modifier onlyOwner() { 
295         require(_owner==msg.sender);
296         _; 
297     }
298 
299     uint256 public MAX_SUPPLY = 666;
300     uint256 public MAX_FREE_PER_WALLET = 1;
301     uint256 public MAX_FREE = 333;
302     uint256 public COST = 0.001 ether;
303 
304     string private constant _name = "GPunkz";
305     string private constant _symbol = "GPUNKZ";
306     string private constant _baseURI = "Qma1Yi73M5RaxQSBTwgaVx5Fczy4wdMg2EBxhvZYDjG1Wm";
307     string private constant _contractURI = "Qma3gjFL53ovnLVVHGjwmajQjrboRGGxezEvGUJQX7aUnb";
308 
309 
310     constructor() {
311         _owner = msg.sender;
312         _mint(msg.sender, 3);
313     }
314 
315     function mint(uint256 amount) external payable{
316         address _caller = _msgSenderERC721A();
317 
318         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
319         require(amount*COST <= msg.value, "Value to Low");
320 
321         _mint(_caller, amount);
322     }
323 
324     function freeMint() external{
325         address _caller = _msgSenderERC721A();
326         uint256 amount = MAX_FREE_PER_WALLET;
327 
328         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
329         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "AccLimit");
330 
331         _mint(_caller, amount);
332     }
333 
334     // Mask of an entry in packed address data.
335     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
336 
337     // The bit position of `numberMinted` in packed address data.
338     uint256 private constant BITPOS_NUMBER_MINTED = 64;
339 
340     // The bit position of `numberBurned` in packed address data.
341     uint256 private constant BITPOS_NUMBER_BURNED = 128;
342 
343     // The bit position of `aux` in packed address data.
344     uint256 private constant BITPOS_AUX = 192;
345 
346     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
347     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
348 
349     // The bit position of `startTimestamp` in packed ownership.
350     uint256 private constant BITPOS_START_TIMESTAMP = 160;
351 
352     // The bit mask of the `burned` bit in packed ownership.
353     uint256 private constant BITMASK_BURNED = 1 << 224;
354 
355     // The bit position of the `nextInitialized` bit in packed ownership.
356     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
357 
358     // The bit mask of the `nextInitialized` bit in packed ownership.
359     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
360 
361     // The tokenId of the next token to be minted.
362     uint256 private _currentIndex = 0;
363 
364     // The number of tokens burned.
365     // uint256 private _burnCounter;
366 
367 
368     // Mapping from token ID to ownership details
369     // An empty struct value does not necessarily mean the token is unowned.
370     // See `_packedOwnershipOf` implementation for details.
371     //
372     // Bits Layout:
373     // - [0..159] `addr`
374     // - [160..223] `startTimestamp`
375     // - [224] `burned`
376     // - [225] `nextInitialized`
377     mapping(uint256 => uint256) private _packedOwnerships;
378 
379     // Mapping owner address to address data.
380     //
381     // Bits Layout:
382     // - [0..63] `balance`
383     // - [64..127] `numberMinted`
384     // - [128..191] `numberBurned`
385     // - [192..255] `aux`
386     mapping(address => uint256) private _packedAddressData;
387 
388     // Mapping from token ID to approved address.
389     mapping(uint256 => address) private _tokenApprovals;
390 
391     // Mapping from owner to operator approvals
392     mapping(address => mapping(address => bool)) private _operatorApprovals;
393 
394     /*
395     function setData(string memory _contract, string memory _base) external onlyOwner{
396         _contractURI = _contract;
397         _baseURI = _base;
398     }
399     */
400     
401 
402     function setData(uint256 _MAX_SUPPLY, uint256 _MAX_FREE, uint256 _COST) external onlyOwner{
403         MAX_SUPPLY = _MAX_SUPPLY;
404         MAX_FREE = _MAX_FREE;
405         COST = _COST;
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
593 
594     /**
595      * @dev Casts the address to uint256 without masking.
596      */
597     function _addressToUint256(address value) private pure returns (uint256 result) {
598         assembly {
599             result := value
600         }
601     }
602 
603     /**
604      * @dev Casts the boolean to uint256 without branching.
605      */
606     function _boolToUint256(bool value) private pure returns (uint256 result) {
607         assembly {
608             result := value
609         }
610     }
611 
612     /**
613      * @dev See {IERC721-approve}.
614      */
615     function approve(address to, uint256 tokenId) public override {
616         address owner = address(uint160(_packedOwnershipOf(tokenId)));
617         if (to == owner) revert();
618 
619         if (_msgSenderERC721A() != owner)
620             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
621                 revert ApprovalCallerNotOwnerNorApproved();
622             }
623 
624         _tokenApprovals[tokenId] = to;
625         emit Approval(owner, to, tokenId);
626     }
627 
628     /**
629      * @dev See {IERC721-getApproved}.
630      */
631     function getApproved(uint256 tokenId) public view override returns (address) {
632         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
633 
634         return _tokenApprovals[tokenId];
635     }
636 
637     /**
638      * @dev See {IERC721-setApprovalForAll}.
639      */
640     function setApprovalForAll(address operator, bool approved) public virtual override {
641         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
642 
643         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
644         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
645     }
646 
647     /**
648      * @dev See {IERC721-isApprovedForAll}.
649      */
650     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
651         return _operatorApprovals[owner][operator];
652     }
653 
654     /**
655      * @dev See {IERC721-transferFrom}.
656      */
657     function transferFrom(
658             address from,
659             address to,
660             uint256 tokenId
661             ) public virtual override {
662         _transfer(from, to, tokenId);
663     }
664 
665     /**
666      * @dev See {IERC721-safeTransferFrom}.
667      */
668     function safeTransferFrom(
669             address from,
670             address to,
671             uint256 tokenId
672             ) public virtual override {
673         safeTransferFrom(from, to, tokenId, '');
674     }
675 
676     /**
677      * @dev See {IERC721-safeTransferFrom}.
678      */
679     function safeTransferFrom(
680             address from,
681             address to,
682             uint256 tokenId,
683             bytes memory _data
684             ) public virtual override {
685         _transfer(from, to, tokenId);
686     }
687 
688     /**
689      * @dev Returns whether `tokenId` exists.
690      *
691      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
692      *
693      * Tokens start existing when they are minted (`_mint`),
694      */
695     function _exists(uint256 tokenId) internal view returns (bool) {
696         return
697             _startTokenId() <= tokenId &&
698             tokenId < _currentIndex;
699     }
700 
701     /**
702      * @dev Equivalent to `_safeMint(to, quantity, '')`.
703      */
704      /*
705     function _safeMint(address to, uint256 quantity) internal {
706         _safeMint(to, quantity, '');
707     }
708     */
709 
710     /**
711      * @dev Safely mints `quantity` tokens and transfers them to `to`.
712      *
713      * Requirements:
714      *
715      * - If `to` refers to a smart contract, it must implement
716      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
717      * - `quantity` must be greater than 0.
718      *
719      * Emits a {Transfer} event.
720      */
721      /*
722     function _safeMint(
723             address to,
724             uint256 quantity,
725             bytes memory _data
726             ) internal {
727         uint256 startTokenId = _currentIndex;
728         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
729         if (quantity == 0) revert MintZeroQuantity();
730 
731 
732         // Overflows are incredibly unrealistic.
733         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
734         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
735         unchecked {
736             // Updates:
737             // - `balance += quantity`.
738             // - `numberMinted += quantity`.
739             //
740             // We can directly add to the balance and number minted.
741             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
742 
743             // Updates:
744             // - `address` to the owner.
745             // - `startTimestamp` to the timestamp of minting.
746             // - `burned` to `false`.
747             // - `nextInitialized` to `quantity == 1`.
748             _packedOwnerships[startTokenId] =
749                 _addressToUint256(to) |
750                 (block.timestamp << BITPOS_START_TIMESTAMP) |
751                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
752 
753             uint256 updatedIndex = startTokenId;
754             uint256 end = updatedIndex + quantity;
755 
756             if (to.code.length != 0) {
757                 do {
758                     emit Transfer(address(0), to, updatedIndex);
759                 } while (updatedIndex < end);
760                 // Reentrancy protection
761                 if (_currentIndex != startTokenId) revert();
762             } else {
763                 do {
764                     emit Transfer(address(0), to, updatedIndex++);
765                 } while (updatedIndex < end);
766             }
767             _currentIndex = updatedIndex;
768         }
769         _afterTokenTransfers(address(0), to, startTokenId, quantity);
770     }
771     */
772 
773     /**
774      * @dev Mints `quantity` tokens and transfers them to `to`.
775      *
776      * Requirements:
777      *
778      * - `to` cannot be the zero address.
779      * - `quantity` must be greater than 0.
780      *
781      * Emits a {Transfer} event.
782      */
783     function _mint(address to, uint256 quantity) internal {
784         uint256 startTokenId = _currentIndex;
785         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
786         if (quantity == 0) revert MintZeroQuantity();
787 
788 
789         // Overflows are incredibly unrealistic.
790         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
791         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
792         unchecked {
793             // Updates:
794             // - `balance += quantity`.
795             // - `numberMinted += quantity`.
796             //
797             // We can directly add to the balance and number minted.
798             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
799 
800             // Updates:
801             // - `address` to the owner.
802             // - `startTimestamp` to the timestamp of minting.
803             // - `burned` to `false`.
804             // - `nextInitialized` to `quantity == 1`.
805             _packedOwnerships[startTokenId] =
806                 _addressToUint256(to) |
807                 (block.timestamp << BITPOS_START_TIMESTAMP) |
808                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
809 
810             uint256 updatedIndex = startTokenId;
811             uint256 end = updatedIndex + quantity;
812 
813             do {
814                 emit Transfer(address(0), to, updatedIndex++);
815             } while (updatedIndex < end);
816 
817             _currentIndex = updatedIndex;
818         }
819         _afterTokenTransfers(address(0), to, startTokenId, quantity);
820     }
821 
822     /**
823      * @dev Transfers `tokenId` from `from` to `to`.
824      *
825      * Requirements:
826      *
827      * - `to` cannot be the zero address.
828      * - `tokenId` token must be owned by `from`.
829      *
830      * Emits a {Transfer} event.
831      */
832     function _transfer(
833             address from,
834             address to,
835             uint256 tokenId
836             ) private {
837 
838         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
839 
840         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
841 
842         address approvedAddress = _tokenApprovals[tokenId];
843 
844         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
845                 isApprovedForAll(from, _msgSenderERC721A()) ||
846                 approvedAddress == _msgSenderERC721A());
847 
848         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
849 
850         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
851 
852 
853         // Clear approvals from the previous owner.
854         if (_addressToUint256(approvedAddress) != 0) {
855             delete _tokenApprovals[tokenId];
856         }
857 
858         // Underflow of the sender's balance is impossible because we check for
859         // ownership above and the recipient's balance can't realistically overflow.
860         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
861         unchecked {
862             // We can directly increment and decrement the balances.
863             --_packedAddressData[from]; // Updates: `balance -= 1`.
864             ++_packedAddressData[to]; // Updates: `balance += 1`.
865 
866             // Updates:
867             // - `address` to the next owner.
868             // - `startTimestamp` to the timestamp of transfering.
869             // - `burned` to `false`.
870             // - `nextInitialized` to `true`.
871             _packedOwnerships[tokenId] =
872                 _addressToUint256(to) |
873                 (block.timestamp << BITPOS_START_TIMESTAMP) |
874                 BITMASK_NEXT_INITIALIZED;
875 
876             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
877             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
878                 uint256 nextTokenId = tokenId + 1;
879                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
880                 if (_packedOwnerships[nextTokenId] == 0) {
881                     // If the next slot is within bounds.
882                     if (nextTokenId != _currentIndex) {
883                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
884                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
885                     }
886                 }
887             }
888         }
889 
890         emit Transfer(from, to, tokenId);
891         _afterTokenTransfers(from, to, tokenId, 1);
892     }
893 
894 
895 
896 
897     /**
898      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
899      * minting.
900      * And also called after one token has been burned.
901      *
902      * startTokenId - the first token id to be transferred
903      * quantity - the amount to be transferred
904      *
905      * Calling conditions:
906      *
907      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
908      * transferred to `to`.
909      * - When `from` is zero, `tokenId` has been minted for `to`.
910      * - When `to` is zero, `tokenId` has been burned by `from`.
911      * - `from` and `to` are never both zero.
912      */
913     function _afterTokenTransfers(
914             address from,
915             address to,
916             uint256 startTokenId,
917             uint256 quantity
918             ) internal virtual {}
919 
920     /**
921      * @dev Returns the message sender (defaults to `msg.sender`).
922      *
923      * If you are writing GSN compatible contracts, you need to override this function.
924      */
925     function _msgSenderERC721A() internal view virtual returns (address) {
926         return msg.sender;
927     }
928 
929     /**
930      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
931      */
932     function _toString(uint256 value) internal pure returns (string memory ptr) {
933         assembly {
934             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
935             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
936             // We will need 1 32-byte word to store the length, 
937             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
938             ptr := add(mload(0x40), 128)
939 
940          // Update the free memory pointer to allocate.
941          mstore(0x40, ptr)
942 
943          // Cache the end of the memory to calculate the length later.
944          let end := ptr
945 
946          // We write the string from the rightmost digit to the leftmost digit.
947          // The following is essentially a do-while loop that also handles the zero case.
948          // Costs a bit more than early returning for the zero case,
949          // but cheaper in terms of deployment and overall runtime costs.
950          for { 
951              // Initialize and perform the first pass without check.
952              let temp := value
953                  // Move the pointer 1 byte leftwards to point to an empty character slot.
954                  ptr := sub(ptr, 1)
955                  // Write the character to the pointer. 48 is the ASCII index of '0'.
956                  mstore8(ptr, add(48, mod(temp, 10)))
957                  temp := div(temp, 10)
958          } temp { 
959              // Keep dividing `temp` until zero.
960         temp := div(temp, 10)
961          } { 
962              // Body of the for loop.
963         ptr := sub(ptr, 1)
964          mstore8(ptr, add(48, mod(temp, 10)))
965          }
966 
967      let length := sub(end, ptr)
968          // Move the pointer 32 bytes leftwards to make room for the length.
969          ptr := sub(ptr, 32)
970          // Store the length.
971          mstore(ptr, length)
972         }
973     }
974 
975     function withdraw() external onlyOwner {
976         uint256 balance = address(this).balance;
977         payable(msg.sender).transfer(balance);
978     }
979 }