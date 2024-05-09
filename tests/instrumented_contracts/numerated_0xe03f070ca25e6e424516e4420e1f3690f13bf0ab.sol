1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-19
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-09-16
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-08-21
11 */
12 
13 // SPDX-License-Identifier: MIT
14 pragma solidity 0.8.17;
15 
16 
17 /**
18  * @dev Interface of ERC721A.
19  */
20 interface IERC721A {
21     /**
22      * The caller must own the token or be an approved operator.
23      */
24     error ApprovalCallerNotOwnerNorApproved();
25 
26     /**
27      * The token does not exist.
28      */
29     error ApprovalQueryForNonexistentToken();
30 
31     /**
32      * The caller cannot approve to their own address.
33      */
34     error ApproveToCaller();
35 
36     /**
37      * Cannot query the balance for the zero address.
38      */
39     error BalanceQueryForZeroAddress();
40 
41     /**
42      * Cannot mint to the zero address.
43      */
44     error MintToZeroAddress();
45 
46     /**
47      * The quantity of tokens minted must be more than zero.
48      */
49     error MintZeroQuantity();
50 
51     /**
52      * The token does not exist.
53      */
54     error OwnerQueryForNonexistentToken();
55 
56     /**
57      * The caller must own the token or be an approved operator.
58      */
59     error TransferCallerNotOwnerNorApproved();
60 
61     /**
62      * The token must be owned by `from`.
63      */
64     error TransferFromIncorrectOwner();
65 
66     /**
67      * Cannot safely transfer to a contract that does not implement the
68      * ERC721Receiver interface.
69      */
70     error TransferToNonERC721ReceiverImplementer();
71 
72     /**
73      * Cannot transfer to the zero address.
74      */
75     error TransferToZeroAddress();
76 
77     /**
78      * The token does not exist.
79      */
80     error URIQueryForNonexistentToken();
81 
82     /**
83      * The `quantity` minted with ERC2309 exceeds the safety limit.
84      */
85     error MintERC2309QuantityExceedsLimit();
86 
87     /**
88      * The `extraData` cannot be set on an unintialized ownership slot.
89      */
90     error OwnershipNotInitializedForExtraData();
91 
92     // =============================================================
93     //                            STRUCTS
94     // =============================================================
95 
96     struct TokenOwnership {
97         // The address of the owner.
98         address addr;
99         // Stores the start time of ownership with minimal overhead for tokenomics.
100         uint64 startTimestamp;
101         // Whether the token has been burned.
102         bool burned;
103         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
104         uint24 extraData;
105     }
106 
107     // =============================================================
108     //                         TOKEN COUNTERS
109     // =============================================================
110 
111     /**
112      * @dev Returns the total number of tokens in existence.
113      * Burned tokens will reduce the count.
114      * To get the total number of tokens minted, please see {_totalMinted}.
115      */
116     function totalSupply() external view returns (uint256);
117 
118     // =============================================================
119     //                            IERC165
120     // =============================================================
121 
122     /**
123      * @dev Returns true if this contract implements the interface defined by
124      * `interfaceId`. See the corresponding
125      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
126      * to learn more about how these ids are created.
127      *
128      * This function call must use less than 30000 gas.
129      */
130     function supportsInterface(bytes4 interfaceId) external view returns (bool);
131 
132     // =============================================================
133     //                            IERC721
134     // =============================================================
135 
136     /**
137      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
143      */
144     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables or disables
148      * (`approved`) `operator` to manage all of its assets.
149      */
150     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
151 
152     /**
153      * @dev Returns the number of tokens in `owner`'s account.
154      */
155     function balanceOf(address owner) external view returns (uint256 balance);
156 
157     /**
158      * @dev Returns the owner of the `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function ownerOf(uint256 tokenId) external view returns (address owner);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`,
168      * checking first that contract recipients are aware of the ERC721 protocol
169      * to prevent tokens from being forever locked.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be have been allowed to move
177      * this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement
179      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId,
187         bytes calldata data
188     ) external;
189 
190     /**
191      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
192      */
193     function safeTransferFrom(
194         address from,
195         address to,
196         uint256 tokenId
197     ) external;
198 
199     /**
200      * @dev Transfers `tokenId` from `from` to `to`.
201      *
202      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
203      * whenever possible.
204      *
205      * Requirements:
206      *
207      * - `from` cannot be the zero address.
208      * - `to` cannot be the zero address.
209      * - `tokenId` token must be owned by `from`.
210      * - If the caller is not `from`, it must be approved to move this token
211      * by either {approve} or {setApprovalForAll}.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(
216         address from,
217         address to,
218         uint256 tokenId
219     ) external;
220 
221     /**
222      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
223      * The approval is cleared when the token is transferred.
224      *
225      * Only a single account can be approved at a time, so approving the
226      * zero address clears previous approvals.
227      *
228      * Requirements:
229      *
230      * - The caller must own the token or be an approved operator.
231      * - `tokenId` must exist.
232      *
233      * Emits an {Approval} event.
234      */
235     function approve(address to, uint256 tokenId) external;
236 
237     /**
238      * @dev Approve or remove `operator` as an operator for the caller.
239      * Operators can call {transferFrom} or {safeTransferFrom}
240      * for any token owned by the caller.
241      *
242      * Requirements:
243      *
244      * - The `operator` cannot be the caller.
245      *
246      * Emits an {ApprovalForAll} event.
247      */
248     function setApprovalForAll(address operator, bool _approved) external;
249 
250     /**
251      * @dev Returns the account approved for `tokenId` token.
252      *
253      * Requirements:
254      *
255      * - `tokenId` must exist.
256      */
257     function getApproved(uint256 tokenId) external view returns (address operator);
258 
259     /**
260      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
261      *
262      * See {setApprovalForAll}.
263      */
264     function isApprovedForAll(address owner, address operator) external view returns (bool);
265 
266     // =============================================================
267     //                        IERC721Metadata
268     // =============================================================
269 
270     /**
271      * @dev Returns the token collection name.
272      */
273     function name() external view returns (string memory);
274 
275     /**
276      * @dev Returns the token collection symbol.
277      */
278     function symbol() external view returns (string memory);
279 
280     /**
281      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
282      */
283     function tokenURI(uint256 tokenId) external view returns (string memory);
284 
285     // =============================================================
286     //                           IERC2309
287     // =============================================================
288 
289     /**
290      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
291      * (inclusive) is transferred from `from` to `to`, as defined in the
292      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
293      *
294      * See {_mintERC2309} for more details.
295      */
296     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
297 }
298 
299 
300 contract CubeApes is IERC721A { 
301     address private _owner;
302 
303     modifier onlyOwner() { 
304         require(_owner==msg.sender);
305         _; 
306     }
307 
308     uint256 public constant MAX_SUPPLY = 3333;
309     uint256 public constant MAX_FREE = 2800;
310     uint256 public constant MAX_FREE_PER_WALLET = 1;
311     uint256 public constant COST = 0.001 ether;
312 
313     string private constant _name = "Cube Apes";
314     string private constant _symbol = "CUBEAPE";
315     string private _contractURI = "";
316     string private _baseURI = "";
317 
318 
319     constructor() {
320         _owner = msg.sender;
321         _mint(msg.sender, 10);
322     }
323 
324     function mint(uint256 amount) external payable{
325         address _caller = _msgSenderERC721A();
326 
327         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
328         require(amount*COST <= msg.value, "Value to Low");
329 
330         _mint(_caller, amount);
331     }
332 
333     function freeMint() external{
334         address _caller = _msgSenderERC721A();
335         uint256 amount = MAX_FREE_PER_WALLET;
336 
337         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
338         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "AccLimit");
339 
340         _mint(_caller, amount);
341     }
342 
343     // Mask of an entry in packed address data.
344     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
345 
346     // The bit position of `numberMinted` in packed address data.
347     uint256 private constant BITPOS_NUMBER_MINTED = 64;
348 
349     // The bit position of `numberBurned` in packed address data.
350     uint256 private constant BITPOS_NUMBER_BURNED = 128;
351 
352     // The bit position of `aux` in packed address data.
353     uint256 private constant BITPOS_AUX = 192;
354 
355     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
356     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
357 
358     // The bit position of `startTimestamp` in packed ownership.
359     uint256 private constant BITPOS_START_TIMESTAMP = 160;
360 
361     // The bit mask of the `burned` bit in packed ownership.
362     uint256 private constant BITMASK_BURNED = 1 << 224;
363 
364     // The bit position of the `nextInitialized` bit in packed ownership.
365     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
366 
367     // The bit mask of the `nextInitialized` bit in packed ownership.
368     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
369 
370     // The tokenId of the next token to be minted.
371     uint256 private _currentIndex = 0;
372 
373     // The number of tokens burned.
374     // uint256 private _burnCounter;
375 
376 
377     // Mapping from token ID to ownership details
378     // An empty struct value does not necessarily mean the token is unowned.
379     // See `_packedOwnershipOf` implementation for details.
380     //
381     // Bits Layout:
382     // - [0..159] `addr`
383     // - [160..223] `startTimestamp`
384     // - [224] `burned`
385     // - [225] `nextInitialized`
386     mapping(uint256 => uint256) private _packedOwnerships;
387 
388     // Mapping owner address to address data.
389     //
390     // Bits Layout:
391     // - [0..63] `balance`
392     // - [64..127] `numberMinted`
393     // - [128..191] `numberBurned`
394     // - [192..255] `aux`
395     mapping(address => uint256) private _packedAddressData;
396 
397     // Mapping from token ID to approved address.
398     mapping(uint256 => address) private _tokenApprovals;
399 
400     // Mapping from owner to operator approvals
401     mapping(address => mapping(address => bool)) private _operatorApprovals;
402 
403 
404     function setData(string memory _contract, string memory _base) external onlyOwner{
405         _contractURI = _contract;
406         _baseURI = _base;
407     }
408 
409     /**
410      * @dev Returns the starting token ID. 
411      * To change the starting token ID, please override this function.
412      */
413     function _startTokenId() internal view virtual returns (uint256) {
414         return 0;
415     }
416 
417     /**
418      * @dev Returns the next token ID to be minted.
419      */
420     function _nextTokenId() internal view returns (uint256) {
421         return _currentIndex;
422     }
423 
424     /**
425      * @dev Returns the total number of tokens in existence.
426      * Burned tokens will reduce the count. 
427      * To get the total number of tokens minted, please see `_totalMinted`.
428      */
429     function totalSupply() public view override returns (uint256) {
430         // Counter underflow is impossible as _burnCounter cannot be incremented
431         // more than `_currentIndex - _startTokenId()` times.
432         unchecked {
433             return _currentIndex - _startTokenId();
434         }
435     }
436 
437     /**
438      * @dev Returns the total amount of tokens minted in the contract.
439      */
440     function _totalMinted() internal view returns (uint256) {
441         // Counter underflow is impossible as _currentIndex does not decrement,
442         // and it is initialized to `_startTokenId()`
443         unchecked {
444             return _currentIndex - _startTokenId();
445         }
446     }
447 
448 
449     /**
450      * @dev See {IERC165-supportsInterface}.
451      */
452     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
453         // The interface IDs are constants representing the first 4 bytes of the XOR of
454         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
455         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
456         return
457             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
458             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
459             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
460     }
461 
462     /**
463      * @dev See {IERC721-balanceOf}.
464      */
465     function balanceOf(address owner) public view override returns (uint256) {
466         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
467         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
468     }
469 
470     /**
471      * Returns the number of tokens minted by `owner`.
472      */
473     function _numberMinted(address owner) internal view returns (uint256) {
474         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
475     }
476 
477 
478 
479     /**
480      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
481      */
482     function _getAux(address owner) internal view returns (uint64) {
483         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
484     }
485 
486     /**
487      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
488      * If there are multiple variables, please pack them into a uint64.
489      */
490     function _setAux(address owner, uint64 aux) internal {
491         uint256 packed = _packedAddressData[owner];
492         uint256 auxCasted;
493         assembly { // Cast aux without masking.
494             auxCasted := aux
495         }
496         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
497         _packedAddressData[owner] = packed;
498     }
499 
500     /**
501      * Returns the packed ownership data of `tokenId`.
502      */
503     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
504         uint256 curr = tokenId;
505 
506         unchecked {
507             if (_startTokenId() <= curr)
508                 if (curr < _currentIndex) {
509                     uint256 packed = _packedOwnerships[curr];
510                     // If not burned.
511                     if (packed & BITMASK_BURNED == 0) {
512                         // Invariant:
513                         // There will always be an ownership that has an address and is not burned
514                         // before an ownership that does not have an address and is not burned.
515                         // Hence, curr will not underflow.
516                         //
517                         // We can directly compare the packed value.
518                         // If the address is zero, packed is zero.
519                         while (packed == 0) {
520                             packed = _packedOwnerships[--curr];
521                         }
522                         return packed;
523                     }
524                 }
525         }
526         revert OwnerQueryForNonexistentToken();
527     }
528 
529     /**
530      * Returns the unpacked `TokenOwnership` struct from `packed`.
531      */
532     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
533         ownership.addr = address(uint160(packed));
534         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
535         ownership.burned = packed & BITMASK_BURNED != 0;
536     }
537 
538     /**
539      * Returns the unpacked `TokenOwnership` struct at `index`.
540      */
541     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
542         return _unpackedOwnership(_packedOwnerships[index]);
543     }
544 
545     /**
546      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
547      */
548     function _initializeOwnershipAt(uint256 index) internal {
549         if (_packedOwnerships[index] == 0) {
550             _packedOwnerships[index] = _packedOwnershipOf(index);
551         }
552     }
553 
554     /**
555      * Gas spent here starts off proportional to the maximum mint batch size.
556      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
557      */
558     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
559         return _unpackedOwnership(_packedOwnershipOf(tokenId));
560     }
561 
562     /**
563      * @dev See {IERC721-ownerOf}.
564      */
565     function ownerOf(uint256 tokenId) public view override returns (address) {
566         return address(uint160(_packedOwnershipOf(tokenId)));
567     }
568 
569     /**
570      * @dev See {IERC721Metadata-name}.
571      */
572     function name() public view virtual override returns (string memory) {
573         return _name;
574     }
575 
576     /**
577      * @dev See {IERC721Metadata-symbol}.
578      */
579     function symbol() public view virtual override returns (string memory) {
580         return _symbol;
581     }
582 
583     
584     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
585         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
586         string memory baseURI = _baseURI;
587         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
588     }
589 
590     function contractURI() public view returns (string memory) {
591         return string(abi.encodePacked("ipfs://", _contractURI));
592     }
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