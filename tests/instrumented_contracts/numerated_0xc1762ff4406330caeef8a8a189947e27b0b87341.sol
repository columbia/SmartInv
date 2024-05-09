1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
3 
4 /*
5     Yepee
6 */
7 
8 /**
9  * @dev Interface of ERC721A.
10  */
11 interface IERC721A {
12     /**
13      * The caller must own the token or be an approved operator.
14      */
15     error ApprovalCallerNotOwnerNorApproved();
16 
17     /**
18      * The token does not exist.
19      */
20     error ApprovalQueryForNonexistentToken();
21 
22     /**
23      * The caller cannot approve to their own address.
24      */
25     error ApproveToCaller();
26 
27     /**
28      * Cannot query the balance for the zero address.
29      */
30     error BalanceQueryForZeroAddress();
31 
32     /**
33      * Cannot mint to the zero address.
34      */
35     error MintToZeroAddress();
36 
37     /**
38      * The quantity of tokens minted must be more than zero.
39      */
40     error MintZeroQuantity();
41 
42     /**
43      * The token does not exist.
44      */
45     error OwnerQueryForNonexistentToken();
46 
47     /**
48      * The caller must own the token or be an approved operator.
49      */
50     error TransferCallerNotOwnerNorApproved();
51 
52     /**
53      * The token must be owned by `from`.
54      */
55     error TransferFromIncorrectOwner();
56 
57     /**
58      * Cannot safely transfer to a contract that does not implement the
59      * ERC721Receiver interface.
60      */
61     error TransferToNonERC721ReceiverImplementer();
62 
63     /**
64      * Cannot transfer to the zero address.
65      */
66     error TransferToZeroAddress();
67 
68     /**
69      * The token does not exist.
70      */
71     error URIQueryForNonexistentToken();
72 
73     /**
74      * The `quantity` minted with ERC2309 exceeds the safety limit.
75      */
76     error MintERC2309QuantityExceedsLimit();
77 
78     /**
79      * The `extraData` cannot be set on an unintialized ownership slot.
80      */
81     error OwnershipNotInitializedForExtraData();
82 
83     // =============================================================
84     //                            STRUCTS
85     // =============================================================
86 
87     struct TokenOwnership {
88         // The address of the owner.
89         address addr;
90         // Stores the start time of ownership with minimal overhead for tokenomics.
91         uint64 startTimestamp;
92         // Whether the token has been burned.
93         bool burned;
94         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
95         uint24 extraData;
96     }
97 
98     // =============================================================
99     //                         TOKEN COUNTERS
100     // =============================================================
101 
102     /**
103      * @dev Returns the total number of tokens in existence.
104      * Burned tokens will reduce the count.
105      * To get the total number of tokens minted, please see {_totalMinted}.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     // =============================================================
110     //                            IERC165
111     // =============================================================
112 
113     /**
114      * @dev Returns true if this contract implements the interface defined by
115      * `interfaceId`. See the corresponding
116      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
117      * to learn more about how these ids are created.
118      *
119      * This function call must use less than 30000 gas.
120      */
121     function supportsInterface(bytes4 interfaceId) external view returns (bool);
122 
123     // =============================================================
124     //                            IERC721
125     // =============================================================
126 
127     /**
128      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
134      */
135     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables or disables
139      * (`approved`) `operator` to manage all of its assets.
140      */
141     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
142 
143     /**
144      * @dev Returns the number of tokens in `owner`'s account.
145      */
146     function balanceOf(address owner) external view returns (uint256 balance);
147 
148     /**
149      * @dev Returns the owner of the `tokenId` token.
150      *
151      * Requirements:
152      *
153      * - `tokenId` must exist.
154      */
155     function ownerOf(uint256 tokenId) external view returns (address owner);
156 
157     /**
158      * @dev Safely transfers `tokenId` token from `from` to `to`,
159      * checking first that contract recipients are aware of the ERC721 protocol
160      * to prevent tokens from being forever locked.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must be have been allowed to move
168      * this token by either {approve} or {setApprovalForAll}.
169      * - If `to` refers to a smart contract, it must implement
170      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes calldata data
179     ) external;
180 
181     /**
182      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId
188     ) external;
189 
190     /**
191      * @dev Transfers `tokenId` from `from` to `to`.
192      *
193      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
194      * whenever possible.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must be owned by `from`.
201      * - If the caller is not `from`, it must be approved to move this token
202      * by either {approve} or {setApprovalForAll}.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transferFrom(
207         address from,
208         address to,
209         uint256 tokenId
210     ) external;
211 
212     /**
213      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
214      * The approval is cleared when the token is transferred.
215      *
216      * Only a single account can be approved at a time, so approving the
217      * zero address clears previous approvals.
218      *
219      * Requirements:
220      *
221      * - The caller must own the token or be an approved operator.
222      * - `tokenId` must exist.
223      *
224      * Emits an {Approval} event.
225      */
226     function approve(address to, uint256 tokenId) external;
227 
228     /**
229      * @dev Approve or remove `operator` as an operator for the caller.
230      * Operators can call {transferFrom} or {safeTransferFrom}
231      * for any token owned by the caller.
232      *
233      * Requirements:
234      *
235      * - The `operator` cannot be the caller.
236      *
237      * Emits an {ApprovalForAll} event.
238      */
239     function setApprovalForAll(address operator, bool _approved) external;
240 
241     /**
242      * @dev Returns the account approved for `tokenId` token.
243      *
244      * Requirements:
245      *
246      * - `tokenId` must exist.
247      */
248     function getApproved(uint256 tokenId) external view returns (address operator);
249 
250     /**
251      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
252      *
253      * See {setApprovalForAll}.
254      */
255     function isApprovedForAll(address owner, address operator) external view returns (bool);
256 
257     // =============================================================
258     //                        IERC721Metadata
259     // =============================================================
260 
261     /**
262      * @dev Returns the token collection name.
263      */
264     function name() external view returns (string memory);
265 
266     /**
267      * @dev Returns the token collection symbol.
268      */
269     function symbol() external view returns (string memory);
270 
271     /**
272      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
273      */
274     function tokenURI(uint256 tokenId) external view returns (string memory);
275 
276     // =============================================================
277     //                           IERC2309
278     // =============================================================
279 
280     /**
281      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
282      * (inclusive) is transferred from `from` to `to`, as defined in the
283      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
284      *
285      * See {_mintERC2309} for more details.
286      */
287     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
288 }
289 
290 contract AAYC is IERC721A { 
291 
292     address private _owner;
293     modifier onlyOwner() { 
294         require(_owner==msg.sender, "No!"); 
295         _; 
296     }
297 
298     bool public saleIsActive = false;
299     uint256 public constant RESERVE = 100;
300     uint256 public constant MAX_SUPPLY = 10000;
301     uint256 public MAX_PER_WALLET = 10;
302     uint256 public MAX_FREE_PER_WALLET = 2;
303     uint256 public EARLY_MINTER_BONUS = 0;
304     uint256 public COST = 0.004 ether;
305 
306     string private constant _name = "Ape Art Yacht Club";
307     string private constant _symbol = "AAYC";
308     string private _contractURI = "";
309     string private _baseURI = "";
310 
311     constructor() {
312         _owner = msg.sender;
313     }
314 
315     function teamMint(uint256 _amount) external{
316         address _caller = _msgSenderERC721A();
317 
318         require(totalSupply() + _amount <= MAX_SUPPLY, "SoldOut");
319         require(_amount + _numberMinted(msg.sender) <= RESERVE, "AccLimit");
320         
321         _safeMint(_caller, _amount);
322     }
323 
324     function freeMint() external{
325         uint256 amount = MAX_FREE_PER_WALLET;
326         address _caller = _msgSenderERC721A();
327 
328         if(totalSupply()<5000){
329             amount += EARLY_MINTER_BONUS;
330         }
331 
332         require(saleIsActive, "NotActive");
333         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
334         require(amount + _numberMinted(msg.sender) <= MAX_FREE_PER_WALLET+EARLY_MINTER_BONUS, "AccLimit");
335 
336         _safeMint(_caller, amount);
337     }
338 
339     function mint(uint256 _amount) external payable{
340         address _caller = _msgSenderERC721A();
341 
342         require(saleIsActive, "NotActive");
343         require(totalSupply() + _amount <= MAX_SUPPLY, "SoldOut");
344         require(_amount + _numberMinted(msg.sender) <= MAX_PER_WALLET + MAX_FREE_PER_WALLET, "AccLimit");
345         require(msg.value >= _amount*COST, "More");
346         
347         _safeMint(_caller, _amount);
348     }
349 
350 
351 
352 
353     // Mask of an entry in packed address data.
354     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
355 
356     // The bit position of `numberMinted` in packed address data.
357     uint256 private constant BITPOS_NUMBER_MINTED = 64;
358 
359     // The bit position of `numberBurned` in packed address data.
360     uint256 private constant BITPOS_NUMBER_BURNED = 128;
361 
362     // The bit position of `aux` in packed address data.
363     uint256 private constant BITPOS_AUX = 192;
364 
365     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
366     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
367 
368     // The bit position of `startTimestamp` in packed ownership.
369     uint256 private constant BITPOS_START_TIMESTAMP = 160;
370 
371     // The bit mask of the `burned` bit in packed ownership.
372     uint256 private constant BITMASK_BURNED = 1 << 224;
373 
374     // The bit position of the `nextInitialized` bit in packed ownership.
375     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
376 
377     // The bit mask of the `nextInitialized` bit in packed ownership.
378     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
379 
380     // The tokenId of the next token to be minted.
381     uint256 private _currentIndex = 0;
382 
383     // The number of tokens burned.
384     // uint256 private _burnCounter;
385 
386 
387     // Mapping from token ID to ownership details
388     // An empty struct value does not necessarily mean the token is unowned.
389     // See `_packedOwnershipOf` implementation for details.
390     //
391     // Bits Layout:
392     // - [0..159] `addr`
393     // - [160..223] `startTimestamp`
394     // - [224] `burned`
395     // - [225] `nextInitialized`
396     mapping(uint256 => uint256) private _packedOwnerships;
397 
398     // Mapping owner address to address data.
399     //
400     // Bits Layout:
401     // - [0..63] `balance`
402     // - [64..127] `numberMinted`
403     // - [128..191] `numberBurned`
404     // - [192..255] `aux`
405     mapping(address => uint256) private _packedAddressData;
406 
407     // Mapping from token ID to approved address.
408     mapping(uint256 => address) private _tokenApprovals;
409 
410     // Mapping from owner to operator approvals
411     mapping(address => mapping(address => bool)) private _operatorApprovals;
412 
413 
414     function setSale(bool _saleIsActive) external onlyOwner{
415         saleIsActive = _saleIsActive;
416     }
417 
418     function setBaseURI(string memory _new) external onlyOwner{
419         _baseURI = _new;
420     }
421 
422     function setContractURI(string memory _new) external onlyOwner{
423         _contractURI = _new;
424     }
425    
426     function setMaxFreePerWallet(uint256 _new) external onlyOwner{
427         MAX_FREE_PER_WALLET = _new;
428     }
429 
430     function setMaxPerWallet(uint256 _new) external onlyOwner{
431         MAX_PER_WALLET = _new;
432     }
433 
434     function setEarlyMinterBonus(uint256 _new) external onlyOwner{
435         EARLY_MINTER_BONUS = _new;
436     }
437 
438     function setPrice(uint256 _new) external onlyOwner{
439         COST = _new;
440     }
441 
442 
443 
444     /**
445      * @dev Returns the starting token ID. 
446      * To change the starting token ID, please override this function.
447      */
448     function _startTokenId() internal view virtual returns (uint256) {
449         return 0;
450     }
451 
452     /**
453      * @dev Returns the next token ID to be minted.
454      */
455     function _nextTokenId() internal view returns (uint256) {
456         return _currentIndex;
457     }
458 
459     /**
460      * @dev Returns the total number of tokens in existence.
461      * Burned tokens will reduce the count. 
462      * To get the total number of tokens minted, please see `_totalMinted`.
463      */
464     function totalSupply() public view override returns (uint256) {
465         // Counter underflow is impossible as _burnCounter cannot be incremented
466         // more than `_currentIndex - _startTokenId()` times.
467         unchecked {
468             return _currentIndex - _startTokenId();
469         }
470     }
471 
472     /**
473      * @dev Returns the total amount of tokens minted in the contract.
474      */
475     function _totalMinted() internal view returns (uint256) {
476         // Counter underflow is impossible as _currentIndex does not decrement,
477         // and it is initialized to `_startTokenId()`
478         unchecked {
479             return _currentIndex - _startTokenId();
480         }
481     }
482 
483 
484     /**
485      * @dev See {IERC165-supportsInterface}.
486      */
487     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
488         // The interface IDs are constants representing the first 4 bytes of the XOR of
489         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
490         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
491         return
492             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
493             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
494             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
495     }
496 
497     /**
498      * @dev See {IERC721-balanceOf}.
499      */
500     function balanceOf(address owner) public view override returns (uint256) {
501         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
502         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
503     }
504 
505     /**
506      * Returns the number of tokens minted by `owner`.
507      */
508     function _numberMinted(address owner) internal view returns (uint256) {
509         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
510     }
511 
512 
513 
514     /**
515      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
516      */
517     function _getAux(address owner) internal view returns (uint64) {
518         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
519     }
520 
521     /**
522      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
523      * If there are multiple variables, please pack them into a uint64.
524      */
525     function _setAux(address owner, uint64 aux) internal {
526         uint256 packed = _packedAddressData[owner];
527         uint256 auxCasted;
528         assembly { // Cast aux without masking.
529 auxCasted := aux
530         }
531         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
532         _packedAddressData[owner] = packed;
533     }
534 
535     /**
536      * Returns the packed ownership data of `tokenId`.
537      */
538     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
539         uint256 curr = tokenId;
540 
541         unchecked {
542             if (_startTokenId() <= curr)
543                 if (curr < _currentIndex) {
544                     uint256 packed = _packedOwnerships[curr];
545                     // If not burned.
546                     if (packed & BITMASK_BURNED == 0) {
547                         // Invariant:
548                         // There will always be an ownership that has an address and is not burned
549                         // before an ownership that does not have an address and is not burned.
550                         // Hence, curr will not underflow.
551                         //
552                         // We can directly compare the packed value.
553                         // If the address is zero, packed is zero.
554                         while (packed == 0) {
555                             packed = _packedOwnerships[--curr];
556                         }
557                         return packed;
558                     }
559                 }
560         }
561         revert OwnerQueryForNonexistentToken();
562     }
563 
564     /**
565      * Returns the unpacked `TokenOwnership` struct from `packed`.
566      */
567     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
568         ownership.addr = address(uint160(packed));
569         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
570         ownership.burned = packed & BITMASK_BURNED != 0;
571     }
572 
573     /**
574      * Returns the unpacked `TokenOwnership` struct at `index`.
575      */
576     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
577         return _unpackedOwnership(_packedOwnerships[index]);
578     }
579 
580     /**
581      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
582      */
583     function _initializeOwnershipAt(uint256 index) internal {
584         if (_packedOwnerships[index] == 0) {
585             _packedOwnerships[index] = _packedOwnershipOf(index);
586         }
587     }
588 
589     /**
590      * Gas spent here starts off proportional to the maximum mint batch size.
591      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
592      */
593     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
594         return _unpackedOwnership(_packedOwnershipOf(tokenId));
595     }
596 
597     /**
598      * @dev See {IERC721-ownerOf}.
599      */
600     function ownerOf(uint256 tokenId) public view override returns (address) {
601         return address(uint160(_packedOwnershipOf(tokenId)));
602     }
603 
604     /**
605      * @dev See {IERC721Metadata-name}.
606      */
607     function name() public view virtual override returns (string memory) {
608         return _name;
609     }
610 
611     /**
612      * @dev See {IERC721Metadata-symbol}.
613      */
614     function symbol() public view virtual override returns (string memory) {
615         return _symbol;
616     }
617 
618     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
619         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
620         string memory baseURI = _baseURI;
621         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
622     }
623 
624     function contractURI() public view returns (string memory) {
625         return string(abi.encodePacked("ipfs://", _contractURI));
626     }
627 
628     /**
629      * @dev Casts the address to uint256 without masking.
630      */
631     function _addressToUint256(address value) private pure returns (uint256 result) {
632         assembly {
633 result := value
634         }
635     }
636 
637     /**
638      * @dev Casts the boolean to uint256 without branching.
639      */
640     function _boolToUint256(bool value) private pure returns (uint256 result) {
641         assembly {
642 result := value
643         }
644     }
645 
646     /**
647      * @dev See {IERC721-approve}.
648      */
649     function approve(address to, uint256 tokenId) public override {
650         address owner = address(uint160(_packedOwnershipOf(tokenId)));
651         if (to == owner) revert();
652 
653         if (_msgSenderERC721A() != owner)
654             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
655                 revert ApprovalCallerNotOwnerNorApproved();
656             }
657 
658         _tokenApprovals[tokenId] = to;
659         emit Approval(owner, to, tokenId);
660     }
661 
662     /**
663      * @dev See {IERC721-getApproved}.
664      */
665     function getApproved(uint256 tokenId) public view override returns (address) {
666         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
667 
668         return _tokenApprovals[tokenId];
669     }
670 
671     /**
672      * @dev See {IERC721-setApprovalForAll}.
673      */
674     function setApprovalForAll(address operator, bool approved) public virtual override {
675         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
676 
677         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
678         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
679     }
680 
681     /**
682      * @dev See {IERC721-isApprovedForAll}.
683      */
684     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
685         return _operatorApprovals[owner][operator];
686     }
687 
688     /**
689      * @dev See {IERC721-transferFrom}.
690      */
691     function transferFrom(
692             address from,
693             address to,
694             uint256 tokenId
695             ) public virtual override {
696         _transfer(from, to, tokenId);
697     }
698 
699     /**
700      * @dev See {IERC721-safeTransferFrom}.
701      */
702     function safeTransferFrom(
703             address from,
704             address to,
705             uint256 tokenId
706             ) public virtual override {
707         safeTransferFrom(from, to, tokenId, '');
708     }
709 
710     /**
711      * @dev See {IERC721-safeTransferFrom}.
712      */
713     function safeTransferFrom(
714             address from,
715             address to,
716             uint256 tokenId,
717             bytes memory _data
718             ) public virtual override {
719         _transfer(from, to, tokenId);
720     }
721 
722     /**
723      * @dev Returns whether `tokenId` exists.
724      *
725      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
726      *
727      * Tokens start existing when they are minted (`_mint`),
728      */
729     function _exists(uint256 tokenId) internal view returns (bool) {
730         return
731             _startTokenId() <= tokenId &&
732             tokenId < _currentIndex;
733     }
734 
735     /**
736      * @dev Equivalent to `_safeMint(to, quantity, '')`.
737      */
738     function _safeMint(address to, uint256 quantity) internal {
739         _safeMint(to, quantity, '');
740     }
741 
742     /**
743      * @dev Safely mints `quantity` tokens and transfers them to `to`.
744      *
745      * Requirements:
746      *
747      * - If `to` refers to a smart contract, it must implement
748      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
749      * - `quantity` must be greater than 0.
750      *
751      * Emits a {Transfer} event.
752      */
753     function _safeMint(
754             address to,
755             uint256 quantity,
756             bytes memory _data
757             ) internal {
758         uint256 startTokenId = _currentIndex;
759         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
760         if (quantity == 0) revert MintZeroQuantity();
761 
762 
763         // Overflows are incredibly unrealistic.
764         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
765         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
766         unchecked {
767             // Updates:
768             // - `balance += quantity`.
769             // - `numberMinted += quantity`.
770             //
771             // We can directly add to the balance and number minted.
772             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
773 
774             // Updates:
775             // - `address` to the owner.
776             // - `startTimestamp` to the timestamp of minting.
777             // - `burned` to `false`.
778             // - `nextInitialized` to `quantity == 1`.
779             _packedOwnerships[startTokenId] =
780                 _addressToUint256(to) |
781                 (block.timestamp << BITPOS_START_TIMESTAMP) |
782                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
783 
784             uint256 updatedIndex = startTokenId;
785             uint256 end = updatedIndex + quantity;
786 
787             if (to.code.length != 0) {
788                 do {
789                     emit Transfer(address(0), to, updatedIndex);
790                 } while (updatedIndex < end);
791                 // Reentrancy protection
792                 if (_currentIndex != startTokenId) revert();
793             } else {
794                 do {
795                     emit Transfer(address(0), to, updatedIndex++);
796                 } while (updatedIndex < end);
797             }
798             _currentIndex = updatedIndex;
799         }
800         _afterTokenTransfers(address(0), to, startTokenId, quantity);
801     }
802 
803     /**
804      * @dev Mints `quantity` tokens and transfers them to `to`.
805      *
806      * Requirements:
807      *
808      * - `to` cannot be the zero address.
809      * - `quantity` must be greater than 0.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _mint(address to, uint256 quantity) internal {
814         uint256 startTokenId = _currentIndex;
815         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
816         if (quantity == 0) revert MintZeroQuantity();
817 
818 
819         // Overflows are incredibly unrealistic.
820         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
821         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
822         unchecked {
823             // Updates:
824             // - `balance += quantity`.
825             // - `numberMinted += quantity`.
826             //
827             // We can directly add to the balance and number minted.
828             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
829 
830             // Updates:
831             // - `address` to the owner.
832             // - `startTimestamp` to the timestamp of minting.
833             // - `burned` to `false`.
834             // - `nextInitialized` to `quantity == 1`.
835             _packedOwnerships[startTokenId] =
836                 _addressToUint256(to) |
837                 (block.timestamp << BITPOS_START_TIMESTAMP) |
838                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
839 
840             uint256 updatedIndex = startTokenId;
841             uint256 end = updatedIndex + quantity;
842 
843             do {
844                 emit Transfer(address(0), to, updatedIndex++);
845             } while (updatedIndex < end);
846 
847             _currentIndex = updatedIndex;
848         }
849         _afterTokenTransfers(address(0), to, startTokenId, quantity);
850     }
851 
852     /**
853      * @dev Transfers `tokenId` from `from` to `to`.
854      *
855      * Requirements:
856      *
857      * - `to` cannot be the zero address.
858      * - `tokenId` token must be owned by `from`.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _transfer(
863             address from,
864             address to,
865             uint256 tokenId
866             ) private {
867 
868         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
869 
870         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
871 
872         address approvedAddress = _tokenApprovals[tokenId];
873 
874         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
875                 isApprovedForAll(from, _msgSenderERC721A()) ||
876                 approvedAddress == _msgSenderERC721A());
877 
878         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
879 
880         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
881 
882 
883         // Clear approvals from the previous owner.
884         if (_addressToUint256(approvedAddress) != 0) {
885             delete _tokenApprovals[tokenId];
886         }
887 
888         // Underflow of the sender's balance is impossible because we check for
889         // ownership above and the recipient's balance can't realistically overflow.
890         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
891         unchecked {
892             // We can directly increment and decrement the balances.
893             --_packedAddressData[from]; // Updates: `balance -= 1`.
894             ++_packedAddressData[to]; // Updates: `balance += 1`.
895 
896             // Updates:
897             // - `address` to the next owner.
898             // - `startTimestamp` to the timestamp of transfering.
899             // - `burned` to `false`.
900             // - `nextInitialized` to `true`.
901             _packedOwnerships[tokenId] =
902                 _addressToUint256(to) |
903                 (block.timestamp << BITPOS_START_TIMESTAMP) |
904                 BITMASK_NEXT_INITIALIZED;
905 
906             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
907             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
908                 uint256 nextTokenId = tokenId + 1;
909                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
910                 if (_packedOwnerships[nextTokenId] == 0) {
911                     // If the next slot is within bounds.
912                     if (nextTokenId != _currentIndex) {
913                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
914                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
915                     }
916                 }
917             }
918         }
919 
920         emit Transfer(from, to, tokenId);
921         _afterTokenTransfers(from, to, tokenId, 1);
922     }
923 
924 
925 
926 
927     /**
928      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
929      * minting.
930      * And also called after one token has been burned.
931      *
932      * startTokenId - the first token id to be transferred
933      * quantity - the amount to be transferred
934      *
935      * Calling conditions:
936      *
937      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
938      * transferred to `to`.
939      * - When `from` is zero, `tokenId` has been minted for `to`.
940      * - When `to` is zero, `tokenId` has been burned by `from`.
941      * - `from` and `to` are never both zero.
942      */
943     function _afterTokenTransfers(
944             address from,
945             address to,
946             uint256 startTokenId,
947             uint256 quantity
948             ) internal virtual {}
949 
950     /**
951      * @dev Returns the message sender (defaults to `msg.sender`).
952      *
953      * If you are writing GSN compatible contracts, you need to override this function.
954      */
955     function _msgSenderERC721A() internal view virtual returns (address) {
956         return msg.sender;
957     }
958 
959     /**
960      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
961      */
962     function _toString(uint256 value) internal pure returns (string memory ptr) {
963         assembly {
964             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
965             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
966             // We will need 1 32-byte word to store the length, 
967             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
968 ptr := add(mload(0x40), 128)
969 
970          // Update the free memory pointer to allocate.
971          mstore(0x40, ptr)
972 
973          // Cache the end of the memory to calculate the length later.
974          let end := ptr
975 
976          // We write the string from the rightmost digit to the leftmost digit.
977          // The following is essentially a do-while loop that also handles the zero case.
978          // Costs a bit more than early returning for the zero case,
979          // but cheaper in terms of deployment and overall runtime costs.
980          for { 
981              // Initialize and perform the first pass without check.
982              let temp := value
983                  // Move the pointer 1 byte leftwards to point to an empty character slot.
984                  ptr := sub(ptr, 1)
985                  // Write the character to the pointer. 48 is the ASCII index of '0'.
986                  mstore8(ptr, add(48, mod(temp, 10)))
987                  temp := div(temp, 10)
988          } temp { 
989              // Keep dividing `temp` until zero.
990         temp := div(temp, 10)
991          } { 
992              // Body of the for loop.
993         ptr := sub(ptr, 1)
994          mstore8(ptr, add(48, mod(temp, 10)))
995          }
996 
997      let length := sub(end, ptr)
998          // Move the pointer 32 bytes leftwards to make room for the length.
999          ptr := sub(ptr, 32)
1000          // Store the length.
1001          mstore(ptr, length)
1002         }
1003     }    
1004 
1005     function withdraw() external onlyOwner {
1006         uint256 balance = address(this).balance;
1007         payable(msg.sender).transfer(balance);
1008     }
1009 }