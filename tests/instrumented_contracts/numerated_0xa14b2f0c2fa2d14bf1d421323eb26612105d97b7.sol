1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 
5 // ██████  ██████  ███████ ██████  ███████ ███    ██ ██████  ██    ██ ███    ██ ██   ██ ███████     
6 //██    ██ ██   ██ ██      ██   ██ ██      ████   ██ ██   ██ ██    ██ ████   ██ ██  ██  ██          
7 //██    ██ ██████  █████   ██████  █████   ██ ██  ██ ██████  ██    ██ ██ ██  ██ █████   ███████     
8 //██    ██ ██      ██      ██      ██      ██  ██ ██ ██      ██    ██ ██  ██ ██ ██  ██       ██     
9 // ██████  ██      ███████ ██      ███████ ██   ████ ██       ██████  ██   ████ ██   ██ ███████    
10 
11 
12 
13 
14 /**
15  * @dev Interface of ERC721A.
16  */
17 interface IERC721A {
18     /**
19      * The caller must own the token or be an approved operator.
20      */
21     error ApprovalCallerNotOwnerNorApproved();
22 
23     /**
24      * The token does not exist.
25      */
26     error ApprovalQueryForNonexistentToken();
27 
28     /**
29      * The caller cannot approve to their own address.
30      */
31     error ApproveToCaller();
32 
33     /**
34      * Cannot query the balance for the zero address.
35      */
36     error BalanceQueryForZeroAddress();
37 
38     /**
39      * Cannot mint to the zero address.
40      */
41     error MintToZeroAddress();
42 
43     /**
44      * The quantity of tokens minted must be more than zero.
45      */
46     error MintZeroQuantity();
47 
48     /**
49      * The token does not exist.
50      */
51     error OwnerQueryForNonexistentToken();
52 
53     /**
54      * The caller must own the token or be an approved operator.
55      */
56     error TransferCallerNotOwnerNorApproved();
57 
58     /**
59      * The token must be owned by `from`.
60      */
61     error TransferFromIncorrectOwner();
62 
63     /**
64      * Cannot safely transfer to a contract that does not implement the
65      * ERC721Receiver interface.
66      */
67     error TransferToNonERC721ReceiverImplementer();
68 
69     /**
70      * Cannot transfer to the zero address.
71      */
72     error TransferToZeroAddress();
73 
74     /**
75      * The token does not exist.
76      */
77     error URIQueryForNonexistentToken();
78 
79     /**
80      * The `quantity` minted with ERC2309 exceeds the safety limit.
81      */
82     error MintERC2309QuantityExceedsLimit();
83 
84     /**
85      * The `extraData` cannot be set on an unintialized ownership slot.
86      */
87     error OwnershipNotInitializedForExtraData();
88 
89     // =============================================================
90     //                            STRUCTS
91     // =============================================================
92 
93     struct TokenOwnership {
94         // The address of the owner.
95         address addr;
96         // Stores the start time of ownership with minimal overhead for tokenomics.
97         uint64 startTimestamp;
98         // Whether the token has been burned.
99         bool burned;
100         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
101         uint24 extraData;
102     }
103 
104     // =============================================================
105     //                         TOKEN COUNTERS
106     // =============================================================
107 
108     /**
109      * @dev Returns the total number of tokens in existence.
110      * Burned tokens will reduce the count.
111      * To get the total number of tokens minted, please see {_totalMinted}.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     // =============================================================
116     //                            IERC165
117     // =============================================================
118 
119     /**
120      * @dev Returns true if this contract implements the interface defined by
121      * `interfaceId`. See the corresponding
122      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
123      * to learn more about how these ids are created.
124      *
125      * This function call must use less than 30000 gas.
126      */
127     function supportsInterface(bytes4 interfaceId) external view returns (bool);
128 
129     // =============================================================
130     //                            IERC721
131     // =============================================================
132 
133     /**
134      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
140      */
141     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables or disables
145      * (`approved`) `operator` to manage all of its assets.
146      */
147     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
148 
149     /**
150      * @dev Returns the number of tokens in `owner`'s account.
151      */
152     function balanceOf(address owner) external view returns (uint256 balance);
153 
154     /**
155      * @dev Returns the owner of the `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function ownerOf(uint256 tokenId) external view returns (address owner);
162 
163     /**
164      * @dev Safely transfers `tokenId` token from `from` to `to`,
165      * checking first that contract recipients are aware of the ERC721 protocol
166      * to prevent tokens from being forever locked.
167      *
168      * Requirements:
169      *
170      * - `from` cannot be the zero address.
171      * - `to` cannot be the zero address.
172      * - `tokenId` token must exist and be owned by `from`.
173      * - If the caller is not `from`, it must be have been allowed to move
174      * this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement
176      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177      *
178      * Emits a {Transfer} event.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId,
184         bytes calldata data
185     ) external;
186 
187     /**
188      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Transfers `tokenId` from `from` to `to`.
198      *
199      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
200      * whenever possible.
201      *
202      * Requirements:
203      *
204      * - `from` cannot be the zero address.
205      * - `to` cannot be the zero address.
206      * - `tokenId` token must be owned by `from`.
207      * - If the caller is not `from`, it must be approved to move this token
208      * by either {approve} or {setApprovalForAll}.
209      *
210      * Emits a {Transfer} event.
211      */
212     function transferFrom(
213         address from,
214         address to,
215         uint256 tokenId
216     ) external;
217 
218     /**
219      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
220      * The approval is cleared when the token is transferred.
221      *
222      * Only a single account can be approved at a time, so approving the
223      * zero address clears previous approvals.
224      *
225      * Requirements:
226      *
227      * - The caller must own the token or be an approved operator.
228      * - `tokenId` must exist.
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address to, uint256 tokenId) external;
233 
234     /**
235      * @dev Approve or remove `operator` as an operator for the caller.
236      * Operators can call {transferFrom} or {safeTransferFrom}
237      * for any token owned by the caller.
238      *
239      * Requirements:
240      *
241      * - The `operator` cannot be the caller.
242      *
243      * Emits an {ApprovalForAll} event.
244      */
245     function setApprovalForAll(address operator, bool _approved) external;
246 
247     /**
248      * @dev Returns the account approved for `tokenId` token.
249      *
250      * Requirements:
251      *
252      * - `tokenId` must exist.
253      */
254     function getApproved(uint256 tokenId) external view returns (address operator);
255 
256     /**
257      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
258      *
259      * See {setApprovalForAll}.
260      */
261     function isApprovedForAll(address owner, address operator) external view returns (bool);
262 
263     // =============================================================
264     //                        IERC721Metadata
265     // =============================================================
266 
267     /**
268      * @dev Returns the token collection name.
269      */
270     function name() external view returns (string memory);
271 
272     /**
273      * @dev Returns the token collection symbol.
274      */
275     function symbol() external view returns (string memory);
276 
277     /**
278      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
279      */
280     function tokenURI(uint256 tokenId) external view returns (string memory);
281 
282     // =============================================================
283     //                           IERC2309
284     // =============================================================
285 
286     /**
287      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
288      * (inclusive) is transferred from `from` to `to`, as defined in the
289      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
290      *
291      * See {_mintERC2309} for more details.
292      */
293     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
294 }
295 
296 
297 contract OpepenPunks is IERC721A { 
298     address private _owner;
299     function owner() public view returns(address){
300         return _owner;
301     }
302     modifier onlyOwner() { 
303         require(_owner==msg.sender);
304         _; 
305     }
306 
307     uint256 public constant MAX_SUPPLY = 4400;
308     uint256 public COST = 0.0025 ether;
309 
310     string private constant _name = "OpepenPunks";
311     string private constant _symbol = "OpepenPunk";
312     string public constant contractURI = "ipfs://QmWFGkfVZsWE1Nyg6LeWw2x7Heh8RUqWhKykNABNNJdveE";
313     string private _baseURI = "QmWFGkfVZsWE1Nyg6LeWw2x7Heh8RUqWhKykNABNNJdveE";
314 
315     constructor() {
316         _owner = msg.sender;
317     }
318 
319     function mint(uint256 amount) external payable{
320         address _caller = _msgSenderERC721A();
321         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
322         require(amount*COST <= msg.value, "Value to Low");
323         _mint(_caller, amount);
324     }
325 
326 
327     // Mask of an entry in packed address data.
328     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
329 
330     // The bit position of `numberMinted` in packed address data.
331     uint256 private constant BITPOS_NUMBER_MINTED = 64;
332 
333     // The bit position of `numberBurned` in packed address data.
334     uint256 private constant BITPOS_NUMBER_BURNED = 128;
335 
336     // The bit position of `aux` in packed address data.
337     uint256 private constant BITPOS_AUX = 192;
338 
339     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
340     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
341 
342     // The bit position of `startTimestamp` in packed ownership.
343     uint256 private constant BITPOS_START_TIMESTAMP = 160;
344 
345     // The bit mask of the `burned` bit in packed ownership.
346     uint256 private constant BITMASK_BURNED = 1 << 224;
347 
348     // The bit position of the `nextInitialized` bit in packed ownership.
349     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
350 
351     // The bit mask of the `nextInitialized` bit in packed ownership.
352     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
353 
354     // The tokenId of the next token to be minted.
355     uint256 private _currentIndex = 1;
356 
357     // The number of tokens burned.
358     // uint256 private _burnCounter;
359 
360 
361     // Mapping from token ID to ownership details
362     // An empty struct value does not necessarily mean the token is unowned.
363     // See `_packedOwnershipOf` implementation for details.
364     //
365     // Bits Layout:
366     // - [0..159] `addr`
367     // - [160..223] `startTimestamp`
368     // - [224] `burned`
369     // - [225] `nextInitialized`
370     mapping(uint256 => uint256) private _packedOwnerships;
371 
372     // Mapping owner address to address data.
373     //
374     // Bits Layout:
375     // - [0..63] `balance`
376     // - [64..127] `numberMinted`
377     // - [128..191] `numberBurned`
378     // - [192..255] `aux`
379     mapping(address => uint256) private _packedAddressData;
380 
381     // Mapping from token ID to approved address.
382     mapping(uint256 => address) private _tokenApprovals;
383 
384     // Mapping from owner to operator approvals
385     mapping(address => mapping(address => bool)) private _operatorApprovals;
386 
387 
388     function setData(string memory _base) external onlyOwner{
389         _baseURI = _base;
390     }
391 
392     function setConfig( uint256 _COST) external onlyOwner{
393         COST = _COST;
394     }
395 
396     /**
397      * @dev Returns the starting token ID. 
398      * To change the starting token ID, please override this function.
399      */
400     function _startTokenId() internal view virtual returns (uint256) {
401         return 0;
402     }
403 
404     /**
405      * @dev Returns the next token ID to be minted.
406      */
407     function _nextTokenId() internal view returns (uint256) {
408         return _currentIndex;
409     }
410 
411     /**
412      * @dev Returns the total number of tokens in existence.
413      * Burned tokens will reduce the count. 
414      * To get the total number of tokens minted, please see `_totalMinted`.
415      */
416     function totalSupply() public view override returns (uint256) {
417         // Counter underflow is impossible as _burnCounter cannot be incremented
418         // more than `_currentIndex - _startTokenId()` times.
419         unchecked {
420             return _currentIndex - _startTokenId();
421         }
422     }
423 
424     /**
425      * @dev Returns the total amount of tokens minted in the contract.
426      */
427     function _totalMinted() internal view returns (uint256) {
428         // Counter underflow is impossible as _currentIndex does not decrement,
429         // and it is initialized to `_startTokenId()`
430         unchecked {
431             return _currentIndex - _startTokenId();
432         }
433     }
434 
435 
436     /**
437      * @dev See {IERC165-supportsInterface}.
438      */
439     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
440         // The interface IDs are constants representing the first 4 bytes of the XOR of
441         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
442         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
443         return
444             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
445             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
446             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
447     }
448 
449     /**
450      * @dev See {IERC721-balanceOf}.
451      */
452     function balanceOf(address owner) public view override returns (uint256) {
453         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
454         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
455     }
456 
457     /**
458      * Returns the number of tokens minted by `owner`.
459      */
460     function _numberMinted(address owner) internal view returns (uint256) {
461         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
462     }
463 
464 
465 
466     /**
467      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
468      */
469     function _getAux(address owner) internal view returns (uint64) {
470         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
471     }
472 
473     /**
474      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
475      * If there are multiple variables, please pack them into a uint64.
476      */
477     function _setAux(address owner, uint64 aux) internal {
478         uint256 packed = _packedAddressData[owner];
479         uint256 auxCasted;
480         assembly { // Cast aux without masking.
481             auxCasted := aux
482         }
483         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
484         _packedAddressData[owner] = packed;
485     }
486 
487     /**
488      * Returns the packed ownership data of `tokenId`.
489      */
490     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
491         uint256 curr = tokenId;
492 
493         unchecked {
494             if (_startTokenId() <= curr)
495                 if (curr < _currentIndex) {
496                     uint256 packed = _packedOwnerships[curr];
497                     // If not burned.
498                     if (packed & BITMASK_BURNED == 0) {
499                         // Invariant:
500                         // There will always be an ownership that has an address and is not burned
501                         // before an ownership that does not have an address and is not burned.
502                         // Hence, curr will not underflow.
503                         //
504                         // We can directly compare the packed value.
505                         // If the address is zero, packed is zero.
506                         while (packed == 0) {
507                             packed = _packedOwnerships[--curr];
508                         }
509                         return packed;
510                     }
511                 }
512         }
513         revert OwnerQueryForNonexistentToken();
514     }
515 
516     /**
517      * Returns the unpacked `TokenOwnership` struct from `packed`.
518      */
519     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
520         ownership.addr = address(uint160(packed));
521         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
522         ownership.burned = packed & BITMASK_BURNED != 0;
523     }
524 
525     /**
526      * Returns the unpacked `TokenOwnership` struct at `index`.
527      */
528     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
529         return _unpackedOwnership(_packedOwnerships[index]);
530     }
531 
532     /**
533      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
534      */
535     function _initializeOwnershipAt(uint256 index) internal {
536         if (_packedOwnerships[index] == 0) {
537             _packedOwnerships[index] = _packedOwnershipOf(index);
538         }
539     }
540 
541     /**
542      * Gas spent here starts off proportional to the maximum mint batch size.
543      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
544      */
545     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
546         return _unpackedOwnership(_packedOwnershipOf(tokenId));
547     }
548 
549     /**
550      * @dev See {IERC721-ownerOf}.
551      */
552     function ownerOf(uint256 tokenId) public view override returns (address) {
553         return address(uint160(_packedOwnershipOf(tokenId)));
554     }
555 
556     /**
557      * @dev See {IERC721Metadata-name}.
558      */
559     function name() public view virtual override returns (string memory) {
560         return _name;
561     }
562 
563     /**
564      * @dev See {IERC721Metadata-symbol}.
565      */
566     function symbol() public view virtual override returns (string memory) {
567         return _symbol;
568     }
569 
570     
571     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
572         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
573         string memory baseURI = _baseURI;
574         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
575     }
576 
577     /*
578     function contractURI() public view returns (string memory) {
579         return string(abi.encodePacked("ipfs://", _contractURI));
580     }
581     */
582 
583     /**
584      * @dev Casts the address to uint256 without masking.
585      */
586     function _addressToUint256(address value) private pure returns (uint256 result) {
587         assembly {
588             result := value
589         }
590     }
591 
592     /**
593      * @dev Casts the boolean to uint256 without branching.
594      */
595     function _boolToUint256(bool value) private pure returns (uint256 result) {
596         assembly {
597             result := value
598         }
599     }
600 
601     /**
602      * @dev See {IERC721-approve}.
603      */
604     function approve(address to, uint256 tokenId) public override {
605         address owner = address(uint160(_packedOwnershipOf(tokenId)));
606         if (to == owner) revert();
607 
608         if (_msgSenderERC721A() != owner)
609             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
610                 revert ApprovalCallerNotOwnerNorApproved();
611             }
612 
613         _tokenApprovals[tokenId] = to;
614         emit Approval(owner, to, tokenId);
615     }
616 
617     /**
618      * @dev See {IERC721-getApproved}.
619      */
620     function getApproved(uint256 tokenId) public view override returns (address) {
621         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
622 
623         return _tokenApprovals[tokenId];
624     }
625 
626     /**
627      * @dev See {IERC721-setApprovalForAll}.
628      */
629     function setApprovalForAll(address operator, bool approved) public virtual override {
630         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
631 
632         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
633         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
634     }
635 
636     /**
637      * @dev See {IERC721-isApprovedForAll}.
638      */
639     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
640         return _operatorApprovals[owner][operator];
641     }
642 
643     /**
644      * @dev See {IERC721-transferFrom}.
645      */
646     function transferFrom(
647             address from,
648             address to,
649             uint256 tokenId
650             ) public virtual override {
651         _transfer(from, to, tokenId);
652     }
653 
654     /**
655      * @dev See {IERC721-safeTransferFrom}.
656      */
657     function safeTransferFrom(
658             address from,
659             address to,
660             uint256 tokenId
661             ) public virtual override {
662         safeTransferFrom(from, to, tokenId, '');
663     }
664 
665     /**
666      * @dev See {IERC721-safeTransferFrom}.
667      */
668     function safeTransferFrom(
669             address from,
670             address to,
671             uint256 tokenId,
672             bytes memory _data
673             ) public virtual override {
674         _transfer(from, to, tokenId);
675     }
676 
677     /**
678      * @dev Returns whether `tokenId` exists.
679      *
680      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
681      *
682      * Tokens start existing when they are minted (`_mint`),
683      */
684     function _exists(uint256 tokenId) internal view returns (bool) {
685         return
686             _startTokenId() <= tokenId &&
687             tokenId < _currentIndex;
688     }
689 
690     /**
691      * @dev Equivalent to `_safeMint(to, quantity, '')`.
692      */
693      /*
694     function _safeMint(address to, uint256 quantity) internal {
695         _safeMint(to, quantity, '');
696     }
697     */
698 
699     /**
700      * @dev Safely mints `quantity` tokens and transfers them to `to`.
701      *
702      * Requirements:
703      *
704      * - If `to` refers to a smart contract, it must implement
705      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
706      * - `quantity` must be greater than 0.
707      *
708      * Emits a {Transfer} event.
709      */
710      /*
711     function _safeMint(
712             address to,
713             uint256 quantity,
714             bytes memory _data
715             ) internal {
716         uint256 startTokenId = _currentIndex;
717         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
718         if (quantity == 0) revert MintZeroQuantity();
719 
720 
721         // Overflows are incredibly unrealistic.
722         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
723         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
724         unchecked {
725             // Updates:
726             // - `balance += quantity`.
727             // - `numberMinted += quantity`.
728             //
729             // We can directly add to the balance and number minted.
730             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
731 
732             // Updates:
733             // - `address` to the owner.
734             // - `startTimestamp` to the timestamp of minting.
735             // - `burned` to `false`.
736             // - `nextInitialized` to `quantity == 1`.
737             _packedOwnerships[startTokenId] =
738                 _addressToUint256(to) |
739                 (block.timestamp << BITPOS_START_TIMESTAMP) |
740                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
741 
742             uint256 updatedIndex = startTokenId;
743             uint256 end = updatedIndex + quantity;
744 
745             if (to.code.length != 0) {
746                 do {
747                     emit Transfer(address(0), to, updatedIndex);
748                 } while (updatedIndex < end);
749                 // Reentrancy protection
750                 if (_currentIndex != startTokenId) revert();
751             } else {
752                 do {
753                     emit Transfer(address(0), to, updatedIndex++);
754                 } while (updatedIndex < end);
755             }
756             _currentIndex = updatedIndex;
757         }
758         _afterTokenTransfers(address(0), to, startTokenId, quantity);
759     }
760     */
761 
762     /**
763      * @dev Mints `quantity` tokens and transfers them to `to`.
764      *
765      * Requirements:
766      *
767      * - `to` cannot be the zero address.
768      * - `quantity` must be greater than 0.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _mint(address to, uint256 quantity) internal {
773         uint256 startTokenId = _currentIndex;
774         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
775         if (quantity == 0) revert MintZeroQuantity();
776 
777 
778         // Overflows are incredibly unrealistic.
779         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
780         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
781         unchecked {
782             // Updates:
783             // - `balance += quantity`.
784             // - `numberMinted += quantity`.
785             //
786             // We can directly add to the balance and number minted.
787             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
788 
789             // Updates:
790             // - `address` to the owner.
791             // - `startTimestamp` to the timestamp of minting.
792             // - `burned` to `false`.
793             // - `nextInitialized` to `quantity == 1`.
794             _packedOwnerships[startTokenId] =
795                 _addressToUint256(to) |
796                 (block.timestamp << BITPOS_START_TIMESTAMP) |
797                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
798 
799             uint256 updatedIndex = startTokenId;
800             uint256 end = updatedIndex + quantity;
801 
802             do {
803                 emit Transfer(address(0), to, updatedIndex++);
804             } while (updatedIndex < end);
805 
806             _currentIndex = updatedIndex;
807         }
808         _afterTokenTransfers(address(0), to, startTokenId, quantity);
809     }
810 
811     /**
812      * @dev Transfers `tokenId` from `from` to `to`.
813      *
814      * Requirements:
815      *
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must be owned by `from`.
818      *
819      * Emits a {Transfer} event.
820      */
821     function _transfer(
822             address from,
823             address to,
824             uint256 tokenId
825             ) private {
826 
827         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
828 
829         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
830 
831         address approvedAddress = _tokenApprovals[tokenId];
832 
833         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
834                 isApprovedForAll(from, _msgSenderERC721A()) ||
835                 approvedAddress == _msgSenderERC721A());
836 
837         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
838 
839         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
840 
841 
842         // Clear approvals from the previous owner.
843         if (_addressToUint256(approvedAddress) != 0) {
844             delete _tokenApprovals[tokenId];
845         }
846 
847         // Underflow of the sender's balance is impossible because we check for
848         // ownership above and the recipient's balance can't realistically overflow.
849         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
850         unchecked {
851             // We can directly increment and decrement the balances.
852             --_packedAddressData[from]; // Updates: `balance -= 1`.
853             ++_packedAddressData[to]; // Updates: `balance += 1`.
854 
855             // Updates:
856             // - `address` to the next owner.
857             // - `startTimestamp` to the timestamp of transfering.
858             // - `burned` to `false`.
859             // - `nextInitialized` to `true`.
860             _packedOwnerships[tokenId] =
861                 _addressToUint256(to) |
862                 (block.timestamp << BITPOS_START_TIMESTAMP) |
863                 BITMASK_NEXT_INITIALIZED;
864 
865             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
866             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
867                 uint256 nextTokenId = tokenId + 1;
868                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
869                 if (_packedOwnerships[nextTokenId] == 0) {
870                     // If the next slot is within bounds.
871                     if (nextTokenId != _currentIndex) {
872                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
873                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
874                     }
875                 }
876             }
877         }
878 
879         emit Transfer(from, to, tokenId);
880         _afterTokenTransfers(from, to, tokenId, 1);
881     }
882 
883 
884 
885 
886     /**
887      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
888      * minting.
889      * And also called after one token has been burned.
890      *
891      * startTokenId - the first token id to be transferred
892      * quantity - the amount to be transferred
893      *
894      * Calling conditions:
895      *
896      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
897      * transferred to `to`.
898      * - When `from` is zero, `tokenId` has been minted for `to`.
899      * - When `to` is zero, `tokenId` has been burned by `from`.
900      * - `from` and `to` are never both zero.
901      */
902     function _afterTokenTransfers(
903             address from,
904             address to,
905             uint256 startTokenId,
906             uint256 quantity
907             ) internal virtual {}
908 
909     /**
910      * @dev Returns the message sender (defaults to `msg.sender`).
911      *
912      * If you are writing GSN compatible contracts, you need to override this function.
913      */
914     function _msgSenderERC721A() internal view virtual returns (address) {
915         return msg.sender;
916     }
917 
918     /**
919      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
920      */
921     function _toString(uint256 value) internal pure returns (string memory ptr) {
922         assembly {
923             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
924             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
925             // We will need 1 32-byte word to store the length, 
926             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
927             ptr := add(mload(0x40), 128)
928 
929          // Update the free memory pointer to allocate.
930          mstore(0x40, ptr)
931 
932          // Cache the end of the memory to calculate the length later.
933          let end := ptr
934 
935          // We write the string from the rightmost digit to the leftmost digit.
936          // The following is essentially a do-while loop that also handles the zero case.
937          // Costs a bit more than early returning for the zero case,
938          // but cheaper in terms of deployment and overall runtime costs.
939          for { 
940              // Initialize and perform the first pass without check.
941              let temp := value
942                  // Move the pointer 1 byte leftwards to point to an empty character slot.
943                  ptr := sub(ptr, 1)
944                  // Write the character to the pointer. 48 is the ASCII index of '0'.
945                  mstore8(ptr, add(48, mod(temp, 10)))
946                  temp := div(temp, 10)
947          } temp { 
948              // Keep dividing `temp` until zero.
949         temp := div(temp, 10)
950          } { 
951              // Body of the for loop.
952         ptr := sub(ptr, 1)
953          mstore8(ptr, add(48, mod(temp, 10)))
954          }
955 
956      let length := sub(end, ptr)
957          // Move the pointer 32 bytes leftwards to make room for the length.
958          ptr := sub(ptr, 32)
959          // Store the length.
960          mstore(ptr, length)
961         }
962     }
963 
964     function withdraw() external onlyOwner {
965         uint256 balance = address(this).balance;
966         payable(msg.sender).transfer(balance);
967     }
968 }