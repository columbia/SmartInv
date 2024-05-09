1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-21
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
292 contract Calvaria is IERC721A { 
293     address private _owner;
294 
295     modifier onlyOwner() { 
296         require(_owner==msg.sender);
297         _; 
298     }
299 
300     uint256 public constant MAX_SUPPLY = 999;
301     uint256 public constant MAX_FREE_PER_WALLET = 1;
302     uint256 public constant COST = 0.002 ether;
303 
304     string private constant _name = "Calvaria";
305     string private constant _symbol = "CalVar";
306     string private _contractURI = "";
307     string private _baseURI = "";
308 
309 
310     constructor() {
311         _owner = msg.sender;
312     }
313 
314     function mint(uint256 amount) external payable{
315         address _caller = _msgSenderERC721A();
316 
317         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
318         require(amount*COST <= msg.value, "Value to Low");
319 
320         _mint(_caller, amount);
321     }
322 
323     function freeMint() external{
324         address _caller = _msgSenderERC721A();
325         uint256 amount = MAX_FREE_PER_WALLET;
326 
327         require(totalSupply() + amount <= MAX_SUPPLY - 75, "Freemint SoldOut");
328         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "AccLimit");
329 
330         _mint(_caller, amount);
331     }
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
394     function setData(string memory _contract, string memory _base) external onlyOwner{
395         _contractURI = _contract;
396         _baseURI = _base;
397     }
398 
399     /**
400      * @dev Returns the starting token ID. 
401      * To change the starting token ID, please override this function.
402      */
403     function _startTokenId() internal view virtual returns (uint256) {
404         return 0;
405     }
406 
407     /**
408      * @dev Returns the next token ID to be minted.
409      */
410     function _nextTokenId() internal view returns (uint256) {
411         return _currentIndex;
412     }
413 
414     /**
415      * @dev Returns the total number of tokens in existence.
416      * Burned tokens will reduce the count. 
417      * To get the total number of tokens minted, please see `_totalMinted`.
418      */
419     function totalSupply() public view override returns (uint256) {
420         // Counter underflow is impossible as _burnCounter cannot be incremented
421         // more than `_currentIndex - _startTokenId()` times.
422         unchecked {
423             return _currentIndex - _startTokenId();
424         }
425     }
426 
427     /**
428      * @dev Returns the total amount of tokens minted in the contract.
429      */
430     function _totalMinted() internal view returns (uint256) {
431         // Counter underflow is impossible as _currentIndex does not decrement,
432         // and it is initialized to `_startTokenId()`
433         unchecked {
434             return _currentIndex - _startTokenId();
435         }
436     }
437 
438 
439     /**
440      * @dev See {IERC165-supportsInterface}.
441      */
442     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
443         // The interface IDs are constants representing the first 4 bytes of the XOR of
444         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
445         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
446         return
447             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
448             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
449             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
450     }
451 
452     /**
453      * @dev See {IERC721-balanceOf}.
454      */
455     function balanceOf(address owner) public view override returns (uint256) {
456         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
457         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
458     }
459 
460     /**
461      * Returns the number of tokens minted by `owner`.
462      */
463     function _numberMinted(address owner) internal view returns (uint256) {
464         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
465     }
466 
467 
468 
469     /**
470      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
471      */
472     function _getAux(address owner) internal view returns (uint64) {
473         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
474     }
475 
476     /**
477      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
478      * If there are multiple variables, please pack them into a uint64.
479      */
480     function _setAux(address owner, uint64 aux) internal {
481         uint256 packed = _packedAddressData[owner];
482         uint256 auxCasted;
483         assembly { // Cast aux without masking.
484             auxCasted := aux
485         }
486         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
487         _packedAddressData[owner] = packed;
488     }
489 
490     /**
491      * Returns the packed ownership data of `tokenId`.
492      */
493     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
494         uint256 curr = tokenId;
495 
496         unchecked {
497             if (_startTokenId() <= curr)
498                 if (curr < _currentIndex) {
499                     uint256 packed = _packedOwnerships[curr];
500                     // If not burned.
501                     if (packed & BITMASK_BURNED == 0) {
502                         // Invariant:
503                         // There will always be an ownership that has an address and is not burned
504                         // before an ownership that does not have an address and is not burned.
505                         // Hence, curr will not underflow.
506                         //
507                         // We can directly compare the packed value.
508                         // If the address is zero, packed is zero.
509                         while (packed == 0) {
510                             packed = _packedOwnerships[--curr];
511                         }
512                         return packed;
513                     }
514                 }
515         }
516         revert OwnerQueryForNonexistentToken();
517     }
518 
519     /**
520      * Returns the unpacked `TokenOwnership` struct from `packed`.
521      */
522     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
523         ownership.addr = address(uint160(packed));
524         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
525         ownership.burned = packed & BITMASK_BURNED != 0;
526     }
527 
528     /**
529      * Returns the unpacked `TokenOwnership` struct at `index`.
530      */
531     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
532         return _unpackedOwnership(_packedOwnerships[index]);
533     }
534 
535     /**
536      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
537      */
538     function _initializeOwnershipAt(uint256 index) internal {
539         if (_packedOwnerships[index] == 0) {
540             _packedOwnerships[index] = _packedOwnershipOf(index);
541         }
542     }
543 
544     /**
545      * Gas spent here starts off proportional to the maximum mint batch size.
546      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
547      */
548     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
549         return _unpackedOwnership(_packedOwnershipOf(tokenId));
550     }
551 
552     /**
553      * @dev See {IERC721-ownerOf}.
554      */
555     function ownerOf(uint256 tokenId) public view override returns (address) {
556         return address(uint160(_packedOwnershipOf(tokenId)));
557     }
558 
559     /**
560      * @dev See {IERC721Metadata-name}.
561      */
562     function name() public view virtual override returns (string memory) {
563         return _name;
564     }
565 
566     /**
567      * @dev See {IERC721Metadata-symbol}.
568      */
569     function symbol() public view virtual override returns (string memory) {
570         return _symbol;
571     }
572 
573     
574     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
575         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
576         string memory baseURI = _baseURI;
577         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
578     }
579 
580     function contractURI() public view returns (string memory) {
581         return string(abi.encodePacked("ipfs://", _contractURI));
582     }
583 
584     /**
585      * @dev Casts the address to uint256 without masking.
586      */
587     function _addressToUint256(address value) private pure returns (uint256 result) {
588         assembly {
589             result := value
590         }
591     }
592 
593     /**
594      * @dev Casts the boolean to uint256 without branching.
595      */
596     function _boolToUint256(bool value) private pure returns (uint256 result) {
597         assembly {
598             result := value
599         }
600     }
601 
602     /**
603      * @dev See {IERC721-approve}.
604      */
605     function approve(address to, uint256 tokenId) public override {
606         address owner = address(uint160(_packedOwnershipOf(tokenId)));
607         if (to == owner) revert();
608 
609         if (_msgSenderERC721A() != owner)
610             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
611                 revert ApprovalCallerNotOwnerNorApproved();
612             }
613 
614         _tokenApprovals[tokenId] = to;
615         emit Approval(owner, to, tokenId);
616     }
617 
618     /**
619      * @dev See {IERC721-getApproved}.
620      */
621     function getApproved(uint256 tokenId) public view override returns (address) {
622         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
623 
624         return _tokenApprovals[tokenId];
625     }
626 
627     /**
628      * @dev See {IERC721-setApprovalForAll}.
629      */
630     function setApprovalForAll(address operator, bool approved) public virtual override {
631         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
632 
633         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
634         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
635     }
636 
637     /**
638      * @dev See {IERC721-isApprovedForAll}.
639      */
640     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
641         return _operatorApprovals[owner][operator];
642     }
643 
644     /**
645      * @dev See {IERC721-transferFrom}.
646      */
647     function transferFrom(
648             address from,
649             address to,
650             uint256 tokenId
651             ) public virtual override {
652         _transfer(from, to, tokenId);
653     }
654 
655     /**
656      * @dev See {IERC721-safeTransferFrom}.
657      */
658     function safeTransferFrom(
659             address from,
660             address to,
661             uint256 tokenId
662             ) public virtual override {
663         safeTransferFrom(from, to, tokenId, '');
664     }
665 
666     /**
667      * @dev See {IERC721-safeTransferFrom}.
668      */
669     function safeTransferFrom(
670             address from,
671             address to,
672             uint256 tokenId,
673             bytes memory _data
674             ) public virtual override {
675         _transfer(from, to, tokenId);
676     }
677 
678     /**
679      * @dev Returns whether `tokenId` exists.
680      *
681      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
682      *
683      * Tokens start existing when they are minted (`_mint`),
684      */
685     function _exists(uint256 tokenId) internal view returns (bool) {
686         return
687             _startTokenId() <= tokenId &&
688             tokenId < _currentIndex;
689     }
690 
691     /**
692      * @dev Equivalent to `_safeMint(to, quantity, '')`.
693      */
694      /*
695     function _safeMint(address to, uint256 quantity) internal {
696         _safeMint(to, quantity, '');
697     }
698     */
699 
700     /**
701      * @dev Safely mints `quantity` tokens and transfers them to `to`.
702      *
703      * Requirements:
704      *
705      * - If `to` refers to a smart contract, it must implement
706      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
707      * - `quantity` must be greater than 0.
708      *
709      * Emits a {Transfer} event.
710      */
711      /*
712     function _safeMint(
713             address to,
714             uint256 quantity,
715             bytes memory _data
716             ) internal {
717         uint256 startTokenId = _currentIndex;
718         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
719         if (quantity == 0) revert MintZeroQuantity();
720 
721 
722         // Overflows are incredibly unrealistic.
723         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
724         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
725         unchecked {
726             // Updates:
727             // - `balance += quantity`.
728             // - `numberMinted += quantity`.
729             //
730             // We can directly add to the balance and number minted.
731             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
732 
733             // Updates:
734             // - `address` to the owner.
735             // - `startTimestamp` to the timestamp of minting.
736             // - `burned` to `false`.
737             // - `nextInitialized` to `quantity == 1`.
738             _packedOwnerships[startTokenId] =
739                 _addressToUint256(to) |
740                 (block.timestamp << BITPOS_START_TIMESTAMP) |
741                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
742 
743             uint256 updatedIndex = startTokenId;
744             uint256 end = updatedIndex + quantity;
745 
746             if (to.code.length != 0) {
747                 do {
748                     emit Transfer(address(0), to, updatedIndex);
749                 } while (updatedIndex < end);
750                 // Reentrancy protection
751                 if (_currentIndex != startTokenId) revert();
752             } else {
753                 do {
754                     emit Transfer(address(0), to, updatedIndex++);
755                 } while (updatedIndex < end);
756             }
757             _currentIndex = updatedIndex;
758         }
759         _afterTokenTransfers(address(0), to, startTokenId, quantity);
760     }
761     */
762 
763     /**
764      * @dev Mints `quantity` tokens and transfers them to `to`.
765      *
766      * Requirements:
767      *
768      * - `to` cannot be the zero address.
769      * - `quantity` must be greater than 0.
770      *
771      * Emits a {Transfer} event.
772      */
773     function _mint(address to, uint256 quantity) internal {
774         uint256 startTokenId = _currentIndex;
775         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
776         if (quantity == 0) revert MintZeroQuantity();
777 
778 
779         // Overflows are incredibly unrealistic.
780         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
781         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
782         unchecked {
783             // Updates:
784             // - `balance += quantity`.
785             // - `numberMinted += quantity`.
786             //
787             // We can directly add to the balance and number minted.
788             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
789 
790             // Updates:
791             // - `address` to the owner.
792             // - `startTimestamp` to the timestamp of minting.
793             // - `burned` to `false`.
794             // - `nextInitialized` to `quantity == 1`.
795             _packedOwnerships[startTokenId] =
796                 _addressToUint256(to) |
797                 (block.timestamp << BITPOS_START_TIMESTAMP) |
798                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
799 
800             uint256 updatedIndex = startTokenId;
801             uint256 end = updatedIndex + quantity;
802 
803             do {
804                 emit Transfer(address(0), to, updatedIndex++);
805             } while (updatedIndex < end);
806 
807             _currentIndex = updatedIndex;
808         }
809         _afterTokenTransfers(address(0), to, startTokenId, quantity);
810     }
811 
812     /**
813      * @dev Transfers `tokenId` from `from` to `to`.
814      *
815      * Requirements:
816      *
817      * - `to` cannot be the zero address.
818      * - `tokenId` token must be owned by `from`.
819      *
820      * Emits a {Transfer} event.
821      */
822     function _transfer(
823             address from,
824             address to,
825             uint256 tokenId
826             ) private {
827 
828         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
829 
830         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
831 
832         address approvedAddress = _tokenApprovals[tokenId];
833 
834         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
835                 isApprovedForAll(from, _msgSenderERC721A()) ||
836                 approvedAddress == _msgSenderERC721A());
837 
838         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
839 
840         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
841 
842 
843         // Clear approvals from the previous owner.
844         if (_addressToUint256(approvedAddress) != 0) {
845             delete _tokenApprovals[tokenId];
846         }
847 
848         // Underflow of the sender's balance is impossible because we check for
849         // ownership above and the recipient's balance can't realistically overflow.
850         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
851         unchecked {
852             // We can directly increment and decrement the balances.
853             --_packedAddressData[from]; // Updates: `balance -= 1`.
854             ++_packedAddressData[to]; // Updates: `balance += 1`.
855 
856             // Updates:
857             // - `address` to the next owner.
858             // - `startTimestamp` to the timestamp of transfering.
859             // - `burned` to `false`.
860             // - `nextInitialized` to `true`.
861             _packedOwnerships[tokenId] =
862                 _addressToUint256(to) |
863                 (block.timestamp << BITPOS_START_TIMESTAMP) |
864                 BITMASK_NEXT_INITIALIZED;
865 
866             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
867             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
868                 uint256 nextTokenId = tokenId + 1;
869                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
870                 if (_packedOwnerships[nextTokenId] == 0) {
871                     // If the next slot is within bounds.
872                     if (nextTokenId != _currentIndex) {
873                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
874                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
875                     }
876                 }
877             }
878         }
879 
880         emit Transfer(from, to, tokenId);
881         _afterTokenTransfers(from, to, tokenId, 1);
882     }
883 
884 
885 
886 
887     /**
888      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
889      * minting.
890      * And also called after one token has been burned.
891      *
892      * startTokenId - the first token id to be transferred
893      * quantity - the amount to be transferred
894      *
895      * Calling conditions:
896      *
897      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
898      * transferred to `to`.
899      * - When `from` is zero, `tokenId` has been minted for `to`.
900      * - When `to` is zero, `tokenId` has been burned by `from`.
901      * - `from` and `to` are never both zero.
902      */
903     function _afterTokenTransfers(
904             address from,
905             address to,
906             uint256 startTokenId,
907             uint256 quantity
908             ) internal virtual {}
909 
910     /**
911      * @dev Returns the message sender (defaults to `msg.sender`).
912      *
913      * If you are writing GSN compatible contracts, you need to override this function.
914      */
915     function _msgSenderERC721A() internal view virtual returns (address) {
916         return msg.sender;
917     }
918 
919     /**
920      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
921      */
922     function _toString(uint256 value) internal pure returns (string memory ptr) {
923         assembly {
924             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
925             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
926             // We will need 1 32-byte word to store the length, 
927             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
928             ptr := add(mload(0x40), 128)
929 
930          // Update the free memory pointer to allocate.
931          mstore(0x40, ptr)
932 
933          // Cache the end of the memory to calculate the length later.
934          let end := ptr
935 
936          // We write the string from the rightmost digit to the leftmost digit.
937          // The following is essentially a do-while loop that also handles the zero case.
938          // Costs a bit more than early returning for the zero case,
939          // but cheaper in terms of deployment and overall runtime costs.
940          for { 
941              // Initialize and perform the first pass without check.
942              let temp := value
943                  // Move the pointer 1 byte leftwards to point to an empty character slot.
944                  ptr := sub(ptr, 1)
945                  // Write the character to the pointer. 48 is the ASCII index of '0'.
946                  mstore8(ptr, add(48, mod(temp, 10)))
947                  temp := div(temp, 10)
948          } temp { 
949              // Keep dividing `temp` until zero.
950         temp := div(temp, 10)
951          } { 
952              // Body of the for loop.
953         ptr := sub(ptr, 1)
954          mstore8(ptr, add(48, mod(temp, 10)))
955          }
956 
957      let length := sub(end, ptr)
958          // Move the pointer 32 bytes leftwards to make room for the length.
959          ptr := sub(ptr, 32)
960          // Store the length.
961          mstore(ptr, length)
962         }
963     }
964 
965     function withdraw() external onlyOwner {
966         uint256 balance = address(this).balance;
967         payable(msg.sender).transfer(balance);
968     }
969 }