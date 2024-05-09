1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-21
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity 0.8.17;
11 
12 
13 /**
14  * @dev Interface of ERC721A.
15  */
16 interface IERC721A {
17     /**
18      * The caller must own the token or be an approved operator.
19      */
20     error ApprovalCallerNotOwnerNorApproved();
21 
22     /**
23      * The token does not exist.
24      */
25     error ApprovalQueryForNonexistentToken();
26 
27     /**
28      * The caller cannot approve to their own address.
29      */
30     error ApproveToCaller();
31 
32     /**
33      * Cannot query the balance for the zero address.
34      */
35     error BalanceQueryForZeroAddress();
36 
37     /**
38      * Cannot mint to the zero address.
39      */
40     error MintToZeroAddress();
41 
42     /**
43      * The quantity of tokens minted must be more than zero.
44      */
45     error MintZeroQuantity();
46 
47     /**
48      * The token does not exist.
49      */
50     error OwnerQueryForNonexistentToken();
51 
52     /**
53      * The caller must own the token or be an approved operator.
54      */
55     error TransferCallerNotOwnerNorApproved();
56 
57     /**
58      * The token must be owned by `from`.
59      */
60     error TransferFromIncorrectOwner();
61 
62     /**
63      * Cannot safely transfer to a contract that does not implement the
64      * ERC721Receiver interface.
65      */
66     error TransferToNonERC721ReceiverImplementer();
67 
68     /**
69      * Cannot transfer to the zero address.
70      */
71     error TransferToZeroAddress();
72 
73     /**
74      * The token does not exist.
75      */
76     error URIQueryForNonexistentToken();
77 
78     /**
79      * The `quantity` minted with ERC2309 exceeds the safety limit.
80      */
81     error MintERC2309QuantityExceedsLimit();
82 
83     /**
84      * The `extraData` cannot be set on an unintialized ownership slot.
85      */
86     error OwnershipNotInitializedForExtraData();
87 
88     // =============================================================
89     //                            STRUCTS
90     // =============================================================
91 
92     struct TokenOwnership {
93         // The address of the owner.
94         address addr;
95         // Stores the start time of ownership with minimal overhead for tokenomics.
96         uint64 startTimestamp;
97         // Whether the token has been burned.
98         bool burned;
99         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
100         uint24 extraData;
101     }
102 
103     // =============================================================
104     //                         TOKEN COUNTERS
105     // =============================================================
106 
107     /**
108      * @dev Returns the total number of tokens in existence.
109      * Burned tokens will reduce the count.
110      * To get the total number of tokens minted, please see {_totalMinted}.
111      */
112     function totalSupply() external view returns (uint256);
113 
114     // =============================================================
115     //                            IERC165
116     // =============================================================
117 
118     /**
119      * @dev Returns true if this contract implements the interface defined by
120      * `interfaceId`. See the corresponding
121      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
122      * to learn more about how these ids are created.
123      *
124      * This function call must use less than 30000 gas.
125      */
126     function supportsInterface(bytes4 interfaceId) external view returns (bool);
127 
128     // =============================================================
129     //                            IERC721
130     // =============================================================
131 
132     /**
133      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
139      */
140     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables or disables
144      * (`approved`) `operator` to manage all of its assets.
145      */
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of tokens in `owner`'s account.
150      */
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function ownerOf(uint256 tokenId) external view returns (address owner);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`,
164      * checking first that contract recipients are aware of the ERC721 protocol
165      * to prevent tokens from being forever locked.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be have been allowed to move
173      * this token by either {approve} or {setApprovalForAll}.
174      * - If `to` refers to a smart contract, it must implement
175      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId,
183         bytes calldata data
184     ) external;
185 
186     /**
187      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId
193     ) external;
194 
195     /**
196      * @dev Transfers `tokenId` from `from` to `to`.
197      *
198      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
199      * whenever possible.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must be owned by `from`.
206      * - If the caller is not `from`, it must be approved to move this token
207      * by either {approve} or {setApprovalForAll}.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(
212         address from,
213         address to,
214         uint256 tokenId
215     ) external;
216 
217     /**
218      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
219      * The approval is cleared when the token is transferred.
220      *
221      * Only a single account can be approved at a time, so approving the
222      * zero address clears previous approvals.
223      *
224      * Requirements:
225      *
226      * - The caller must own the token or be an approved operator.
227      * - `tokenId` must exist.
228      *
229      * Emits an {Approval} event.
230      */
231     function approve(address to, uint256 tokenId) external;
232 
233     /**
234      * @dev Approve or remove `operator` as an operator for the caller.
235      * Operators can call {transferFrom} or {safeTransferFrom}
236      * for any token owned by the caller.
237      *
238      * Requirements:
239      *
240      * - The `operator` cannot be the caller.
241      *
242      * Emits an {ApprovalForAll} event.
243      */
244     function setApprovalForAll(address operator, bool _approved) external;
245 
246     /**
247      * @dev Returns the account approved for `tokenId` token.
248      *
249      * Requirements:
250      *
251      * - `tokenId` must exist.
252      */
253     function getApproved(uint256 tokenId) external view returns (address operator);
254 
255     /**
256      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
257      *
258      * See {setApprovalForAll}.
259      */
260     function isApprovedForAll(address owner, address operator) external view returns (bool);
261 
262     // =============================================================
263     //                        IERC721Metadata
264     // =============================================================
265 
266     /**
267      * @dev Returns the token collection name.
268      */
269     function name() external view returns (string memory);
270 
271     /**
272      * @dev Returns the token collection symbol.
273      */
274     function symbol() external view returns (string memory);
275 
276     /**
277      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
278      */
279     function tokenURI(uint256 tokenId) external view returns (string memory);
280 
281     // =============================================================
282     //                           IERC2309
283     // =============================================================
284 
285     /**
286      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
287      * (inclusive) is transferred from `from` to `to`, as defined in the
288      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
289      *
290      * See {_mintERC2309} for more details.
291      */
292     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
293 }
294 
295 
296 contract Clockz is IERC721A { 
297     address private _owner;
298 
299     modifier onlyOwner() { 
300         require(_owner==msg.sender);
301         _; 
302     }
303 
304     uint256 public constant MAX_SUPPLY = 360;
305     uint256 public constant MAX_FREE_PER_WALLET = 1;
306     uint256 public constant COST = 0.002 ether;
307 
308     string private constant _name = "Clockz";
309     string private constant _symbol = "CLOCKZ";
310     string private _contractURI = "";
311     string private _baseURI = "";
312 
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
329         uint256 amount = MAX_FREE_PER_WALLET;
330 
331         require(totalSupply() + amount <= MAX_SUPPLY - 66, "Freemint SoldOut");
332         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "AccLimit");
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
398     function setData(string memory _contract, string memory _base) external onlyOwner{
399         _contractURI = _contract;
400         _baseURI = _base;
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
481      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
482      * If there are multiple variables, please pack them into a uint64.
483      */
484     function _setAux(address owner, uint64 aux) internal {
485         uint256 packed = _packedAddressData[owner];
486         uint256 auxCasted;
487         assembly { // Cast aux without masking.
488             auxCasted := aux
489         }
490         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
491         _packedAddressData[owner] = packed;
492     }
493 
494     /**
495      * Returns the packed ownership data of `tokenId`.
496      */
497     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
498         uint256 curr = tokenId;
499 
500         unchecked {
501             if (_startTokenId() <= curr)
502                 if (curr < _currentIndex) {
503                     uint256 packed = _packedOwnerships[curr];
504                     // If not burned.
505                     if (packed & BITMASK_BURNED == 0) {
506                         // Invariant:
507                         // There will always be an ownership that has an address and is not burned
508                         // before an ownership that does not have an address and is not burned.
509                         // Hence, curr will not underflow.
510                         //
511                         // We can directly compare the packed value.
512                         // If the address is zero, packed is zero.
513                         while (packed == 0) {
514                             packed = _packedOwnerships[--curr];
515                         }
516                         return packed;
517                     }
518                 }
519         }
520         revert OwnerQueryForNonexistentToken();
521     }
522 
523     /**
524      * Returns the unpacked `TokenOwnership` struct from `packed`.
525      */
526     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
527         ownership.addr = address(uint160(packed));
528         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
529         ownership.burned = packed & BITMASK_BURNED != 0;
530     }
531 
532     /**
533      * Returns the unpacked `TokenOwnership` struct at `index`.
534      */
535     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
536         return _unpackedOwnership(_packedOwnerships[index]);
537     }
538 
539     /**
540      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
541      */
542     function _initializeOwnershipAt(uint256 index) internal {
543         if (_packedOwnerships[index] == 0) {
544             _packedOwnerships[index] = _packedOwnershipOf(index);
545         }
546     }
547 
548     /**
549      * Gas spent here starts off proportional to the maximum mint batch size.
550      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
551      */
552     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
553         return _unpackedOwnership(_packedOwnershipOf(tokenId));
554     }
555 
556     /**
557      * @dev See {IERC721-ownerOf}.
558      */
559     function ownerOf(uint256 tokenId) public view override returns (address) {
560         return address(uint160(_packedOwnershipOf(tokenId)));
561     }
562 
563     /**
564      * @dev See {IERC721Metadata-name}.
565      */
566     function name() public view virtual override returns (string memory) {
567         return _name;
568     }
569 
570     /**
571      * @dev See {IERC721Metadata-symbol}.
572      */
573     function symbol() public view virtual override returns (string memory) {
574         return _symbol;
575     }
576 
577     
578     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
579         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
580         string memory baseURI = _baseURI;
581         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
582     }
583 
584     function contractURI() public view returns (string memory) {
585         return string(abi.encodePacked("ipfs://", _contractURI));
586     }
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