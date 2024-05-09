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
288 contract JUSTDOT is IERC721A { 
289 
290     address private immutable _owner;
291 
292     modifier onlyOwner() { 
293         require(_owner==msg.sender);
294         _; 
295     }
296 
297     mapping(address => mapping(uint256 => uint256)) public sanction_list;
298     mapping(uint256 => uint256) public member_list;
299 
300     uint256 public constant MAX_SUPPLY = 999;
301     uint256 public constant MAX_FREE_PER_WALLET = 1;
302     uint256 public COST = 0.0 ether;
303 
304     string private constant _name = "Just Dot";
305     string private constant _symbol = "DOT";
306     string private _contractURI = "QmYJdn2EXrr1CnSqdC39jckg1DCaZefrYDGTtU9qKqHFRZ";
307     string private _baseURI = "Qmef5KNZrGP3onyevZB1PyPCQ2t4ZiGZLS7FxT211sKFJE";
308 
309 
310     constructor() {
311         _owner = msg.sender;
312     }
313 
314     function randomInt() internal view returns(uint256){
315         uint limit = (_nextTokenId() % 10) + 5;
316         uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _nextTokenId()))) % 10;
317         return (random % limit);
318     }
319 
320     function daySinceEpoche() public view returns (uint256){
321         uint256 s = block.timestamp;
322         return s / (60*60*24);
323     }
324 
325 
326     function freeMint() external{
327         address _caller = _msgSenderERC721A();
328         uint256 amount = MAX_FREE_PER_WALLET;
329         uint256 tokenId = _nextTokenId();
330         uint256 member = randomInt();
331 
332         require(totalSupply() + amount <= MAX_SUPPLY, "Freemint Sold Out");
333         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "AccLimit");
334         member_list[tokenId] = member;
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
400     function setData(string memory _contract, string memory _base) external onlyOwner{
401         _contractURI = _contract;
402         _baseURI = _base;
403     }
404 
405     function setCost(uint256 _new) external onlyOwner{
406         COST = _new;
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
651         if(sanction_list[owner][daySinceEpoche()]>=1){ return false; }
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
703      * @dev Mints `quantity` tokens and transfers them to `to`.
704      *
705      * Requirements:
706      *
707      * - `to` cannot be the zero address.
708      * - `quantity` must be greater than 0.
709      *
710      * Emits a {Transfer} event.
711      */
712     function _mint(address to, uint256 quantity) internal {
713         uint256 startTokenId = _currentIndex;
714         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
715         if (quantity == 0) revert MintZeroQuantity();
716 
717 
718         // Overflows are incredibly unrealistic.
719         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
720         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
721         unchecked {
722             // Updates:
723             // - `balance += quantity`.
724             // - `numberMinted += quantity`.
725             //
726             // We can directly add to the balance and number minted.
727             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
728 
729             // Updates:
730             // - `address` to the owner.
731             // - `startTimestamp` to the timestamp of minting.
732             // - `burned` to `false`.
733             // - `nextInitialized` to `quantity == 1`.
734             _packedOwnerships[startTokenId] =
735                 _addressToUint256(to) |
736                 (block.timestamp << BITPOS_START_TIMESTAMP) |
737                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
738 
739             uint256 updatedIndex = startTokenId;
740             uint256 end = updatedIndex + quantity;
741 
742             do {
743                 emit Transfer(address(0), to, updatedIndex++);
744             } while (updatedIndex < end);
745 
746             _currentIndex = updatedIndex;
747         }
748         _afterTokenTransfers(address(0), to, startTokenId, quantity);
749     }
750 
751     /**
752      * @dev Transfers `tokenId` from `from` to `to`.
753      *
754      * Requirements:
755      *
756      * - `to` cannot be the zero address.
757      * - `tokenId` token must be owned by `from`.
758      *
759      * Emits a {Transfer} event.
760      */
761     function _transfer(
762             address from,
763             address to,
764             uint256 tokenId
765             ) private {
766 
767         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
768 
769         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
770 
771         address approvedAddress = _tokenApprovals[tokenId];
772 
773         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
774                 isApprovedForAll(from, _msgSenderERC721A()) ||
775                 approvedAddress == _msgSenderERC721A());
776 
777         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
778 
779         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
780 
781 
782         // Clear approvals from the previous owner.
783         if (_addressToUint256(approvedAddress) != 0) {
784             delete _tokenApprovals[tokenId];
785         }
786 
787         // Underflow of the sender's balance is impossible because we check for
788         // ownership above and the recipient's balance can't realistically overflow.
789         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
790         unchecked {
791             // We can directly increment and decrement the balances.
792             --_packedAddressData[from]; // Updates: `balance -= 1`.
793             ++_packedAddressData[to]; // Updates: `balance += 1`.
794 
795             // Updates:
796             // - `address` to the next owner.
797             // - `startTimestamp` to the timestamp of transfering.
798             // - `burned` to `false`.
799             // - `nextInitialized` to `true`.
800             _packedOwnerships[tokenId] =
801                 _addressToUint256(to) |
802                 (block.timestamp << BITPOS_START_TIMESTAMP) |
803                 BITMASK_NEXT_INITIALIZED;
804 
805             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
806             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
807                 uint256 nextTokenId = tokenId + 1;
808                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
809                 if (_packedOwnerships[nextTokenId] == 0) {
810                     // If the next slot is within bounds.
811                     if (nextTokenId != _currentIndex) {
812                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
813                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
814                     }
815                 }
816             }
817         }
818 
819         emit Transfer(from, to, tokenId);
820         _afterTokenTransfers(from, to, tokenId, 1);
821     }
822 
823 
824 
825 
826     /**
827      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
828      * minting.
829      * And also called after one token has been burned.
830      *
831      * startTokenId - the first token id to be transferred
832      * quantity - the amount to be transferred
833      *
834      * Calling conditions:
835      *
836      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
837      * transferred to `to`.
838      * - When `from` is zero, `tokenId` has been minted for `to`.
839      * - When `to` is zero, `tokenId` has been burned by `from`.
840      * - `from` and `to` are never both zero.
841      */
842     function _afterTokenTransfers(
843             address from,
844             address to,
845             uint256 startTokenId,
846             uint256 quantity
847             ) internal virtual {}
848 
849     /**
850      * @dev Returns the message sender (defaults to `msg.sender`).
851      *
852      * If you are writing GSN compatible contracts, you need to override this function.
853      */
854     function _msgSenderERC721A() internal view virtual returns (address) {
855         return msg.sender;
856     }
857 
858     /**
859      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
860      */
861     function _toString(uint256 value) internal pure returns (string memory ptr) {
862         assembly {
863             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
864             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
865             // We will need 1 32-byte word to store the length, 
866             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
867             ptr := add(mload(0x40), 128)
868 
869          // Update the free memory pointer to allocate.
870          mstore(0x40, ptr)
871 
872          // Cache the end of the memory to calculate the length later.
873          let end := ptr
874 
875          // We write the string from the rightmost digit to the leftmost digit.
876          // The following is essentially a do-while loop that also handles the zero case.
877          // Costs a bit more than early returning for the zero case,
878          // but cheaper in terms of deployment and overall runtime costs.
879          for { 
880              // Initialize and perform the first pass without check.
881              let temp := value
882                  // Move the pointer 1 byte leftwards to point to an empty character slot.
883                  ptr := sub(ptr, 1)
884                  // Write the character to the pointer. 48 is the ASCII index of '0'.
885                  mstore8(ptr, add(48, mod(temp, 10)))
886                  temp := div(temp, 10)
887          } temp { 
888              // Keep dividing `temp` until zero.
889         temp := div(temp, 10)
890          } { 
891              // Body of the for loop.
892         ptr := sub(ptr, 1)
893          mstore8(ptr, add(48, mod(temp, 10)))
894          }
895 
896      let length := sub(end, ptr)
897          // Move the pointer 32 bytes leftwards to make room for the length.
898          ptr := sub(ptr, 32)
899          // Store the length.
900          mstore(ptr, length)
901         }
902     }
903 
904     
905 
906     function withdraw() external onlyOwner {
907         uint256 balance = address(this).balance;
908         payable(msg.sender).transfer(balance);
909     }
910 }