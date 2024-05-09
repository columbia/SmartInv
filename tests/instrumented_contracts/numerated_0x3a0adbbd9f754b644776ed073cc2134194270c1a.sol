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
296 contract EpoX is IERC721A { 
297     address private _owner;
298 
299     modifier onlyOwner() { 
300         require(_owner==msg.sender);
301         _; 
302     }
303 
304     uint256 public constant MAX_SUPPLY = 837;
305     uint256 public constant MAX_FREE = 770;
306     uint256 public constant MAX_FREE_PER_WALLET = 1;
307     uint256 public constant COST = 0.0025 ether;
308 
309     string private constant _name = "EpoX";
310     string private constant _symbol = "EPOX";
311     string private _contractURI = "QmbXE5RF7yTywRtYzG9aYEhfcAq9Ju6kwG3PoA6hZFLTv8";
312     string private _baseURI = "QmeDN31Seq8sKA6LcXu8SzwcqVrcYMuBLrBLr6Pz9cnZx5";
313 
314 
315     constructor() {
316         _owner = msg.sender;
317     }
318 
319     function mint(uint256 amount) external payable{
320         address _caller = _msgSenderERC721A();
321 
322         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
323         require(amount*COST <= msg.value, "Value to Low");
324 
325         _mint(_caller, amount);
326     }
327 
328     function freeMint() external{
329         address _caller = _msgSenderERC721A();
330         uint256 amount = MAX_FREE_PER_WALLET;
331 
332         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
333         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "AccLimit");
334 
335         _mint(_caller, amount);
336     }
337 
338     // Mask of an entry in packed address data.
339     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
340 
341     // The bit position of `numberMinted` in packed address data.
342     uint256 private constant BITPOS_NUMBER_MINTED = 64;
343 
344     // The bit position of `numberBurned` in packed address data.
345     uint256 private constant BITPOS_NUMBER_BURNED = 128;
346 
347     // The bit position of `aux` in packed address data.
348     uint256 private constant BITPOS_AUX = 192;
349 
350     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
351     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
352 
353     // The bit position of `startTimestamp` in packed ownership.
354     uint256 private constant BITPOS_START_TIMESTAMP = 160;
355 
356     // The bit mask of the `burned` bit in packed ownership.
357     uint256 private constant BITMASK_BURNED = 1 << 224;
358 
359     // The bit position of the `nextInitialized` bit in packed ownership.
360     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
361 
362     // The bit mask of the `nextInitialized` bit in packed ownership.
363     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
364 
365     // The tokenId of the next token to be minted.
366     uint256 private _currentIndex = 0;
367 
368     // The number of tokens burned.
369     // uint256 private _burnCounter;
370 
371 
372     // Mapping from token ID to ownership details
373     // An empty struct value does not necessarily mean the token is unowned.
374     // See `_packedOwnershipOf` implementation for details.
375     //
376     // Bits Layout:
377     // - [0..159] `addr`
378     // - [160..223] `startTimestamp`
379     // - [224] `burned`
380     // - [225] `nextInitialized`
381     mapping(uint256 => uint256) private _packedOwnerships;
382 
383     // Mapping owner address to address data.
384     //
385     // Bits Layout:
386     // - [0..63] `balance`
387     // - [64..127] `numberMinted`
388     // - [128..191] `numberBurned`
389     // - [192..255] `aux`
390     mapping(address => uint256) private _packedAddressData;
391 
392     // Mapping from token ID to approved address.
393     mapping(uint256 => address) private _tokenApprovals;
394 
395     // Mapping from owner to operator approvals
396     mapping(address => mapping(address => bool)) private _operatorApprovals;
397 
398 
399     function setData(string memory _contract, string memory _base) external onlyOwner{
400         _contractURI = _contract;
401         _baseURI = _base;
402     }
403 
404     /**
405      * @dev Returns the starting token ID. 
406      * To change the starting token ID, please override this function.
407      */
408     function _startTokenId() internal view virtual returns (uint256) {
409         return 0;
410     }
411 
412     /**
413      * @dev Returns the next token ID to be minted.
414      */
415     function _nextTokenId() internal view returns (uint256) {
416         return _currentIndex;
417     }
418 
419     /**
420      * @dev Returns the total number of tokens in existence.
421      * Burned tokens will reduce the count. 
422      * To get the total number of tokens minted, please see `_totalMinted`.
423      */
424     function totalSupply() public view override returns (uint256) {
425         // Counter underflow is impossible as _burnCounter cannot be incremented
426         // more than `_currentIndex - _startTokenId()` times.
427         unchecked {
428             return _currentIndex - _startTokenId();
429         }
430     }
431 
432     /**
433      * @dev Returns the total amount of tokens minted in the contract.
434      */
435     function _totalMinted() internal view returns (uint256) {
436         // Counter underflow is impossible as _currentIndex does not decrement,
437         // and it is initialized to `_startTokenId()`
438         unchecked {
439             return _currentIndex - _startTokenId();
440         }
441     }
442 
443 
444     /**
445      * @dev See {IERC165-supportsInterface}.
446      */
447     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
448         // The interface IDs are constants representing the first 4 bytes of the XOR of
449         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
450         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
451         return
452             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
453             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
454             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
455     }
456 
457     /**
458      * @dev See {IERC721-balanceOf}.
459      */
460     function balanceOf(address owner) public view override returns (uint256) {
461         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
462         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
463     }
464 
465     /**
466      * Returns the number of tokens minted by `owner`.
467      */
468     function _numberMinted(address owner) internal view returns (uint256) {
469         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
470     }
471 
472 
473 
474     /**
475      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
476      */
477     function _getAux(address owner) internal view returns (uint64) {
478         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
479     }
480 
481     /**
482      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
483      * If there are multiple variables, please pack them into a uint64.
484      */
485     function _setAux(address owner, uint64 aux) internal {
486         uint256 packed = _packedAddressData[owner];
487         uint256 auxCasted;
488         assembly { // Cast aux without masking.
489             auxCasted := aux
490         }
491         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
492         _packedAddressData[owner] = packed;
493     }
494 
495     /**
496      * Returns the packed ownership data of `tokenId`.
497      */
498     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
499         uint256 curr = tokenId;
500 
501         unchecked {
502             if (_startTokenId() <= curr)
503                 if (curr < _currentIndex) {
504                     uint256 packed = _packedOwnerships[curr];
505                     // If not burned.
506                     if (packed & BITMASK_BURNED == 0) {
507                         // Invariant:
508                         // There will always be an ownership that has an address and is not burned
509                         // before an ownership that does not have an address and is not burned.
510                         // Hence, curr will not underflow.
511                         //
512                         // We can directly compare the packed value.
513                         // If the address is zero, packed is zero.
514                         while (packed == 0) {
515                             packed = _packedOwnerships[--curr];
516                         }
517                         return packed;
518                     }
519                 }
520         }
521         revert OwnerQueryForNonexistentToken();
522     }
523 
524     /**
525      * Returns the unpacked `TokenOwnership` struct from `packed`.
526      */
527     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
528         ownership.addr = address(uint160(packed));
529         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
530         ownership.burned = packed & BITMASK_BURNED != 0;
531     }
532 
533     /**
534      * Returns the unpacked `TokenOwnership` struct at `index`.
535      */
536     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
537         return _unpackedOwnership(_packedOwnerships[index]);
538     }
539 
540     /**
541      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
542      */
543     function _initializeOwnershipAt(uint256 index) internal {
544         if (_packedOwnerships[index] == 0) {
545             _packedOwnerships[index] = _packedOwnershipOf(index);
546         }
547     }
548 
549     /**
550      * Gas spent here starts off proportional to the maximum mint batch size.
551      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
552      */
553     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
554         return _unpackedOwnership(_packedOwnershipOf(tokenId));
555     }
556 
557     /**
558      * @dev See {IERC721-ownerOf}.
559      */
560     function ownerOf(uint256 tokenId) public view override returns (address) {
561         return address(uint160(_packedOwnershipOf(tokenId)));
562     }
563 
564     /**
565      * @dev See {IERC721Metadata-name}.
566      */
567     function name() public view virtual override returns (string memory) {
568         return _name;
569     }
570 
571     /**
572      * @dev See {IERC721Metadata-symbol}.
573      */
574     function symbol() public view virtual override returns (string memory) {
575         return _symbol;
576     }
577 
578     
579     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
580         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
581         string memory baseURI = _baseURI;
582         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
583     }
584 
585     function contractURI() public view returns (string memory) {
586         return string(abi.encodePacked("ipfs://", _contractURI));
587     }
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