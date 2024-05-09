1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /*
5 
6 Hi,
7 
8  ,ggg, ,ggggggg,                                        
9 dP""Y8,8P"""""Y8b                         I8            
10 Yb, `8dP'     `88                         I8            
11  `"  88'       88                      88888888         
12      88        88                         I8            
13      88        88    ,ggggg,    ,ggggg,   I8     ,g,    
14      88        88   dP"  "Y8gggdP"  "Y8gggI8    ,8'8,   
15      88        88  i8'    ,8I i8'    ,8I ,I8,  ,8'  Yb  
16      88        Y8,,d8,   ,d8',d8,   ,d8',d88b,,8'_   8) 
17      88        `Y8P"Y8888P"  P"Y8888P"  8P""Y8P' "YY8P8P
18 
19     Twitter: 
20     Mission: Save the World!
21     Supply: 1777
22 
23 */
24 
25 
26 /**
27  * @dev Interface of ERC721A.
28  */
29 interface IERC721A {
30     /**
31      * The caller must own the token or be an approved operator.
32      */
33     error ApprovalCallerNotOwnerNorApproved();
34 
35     /**
36      * The token does not exist.
37      */
38     error ApprovalQueryForNonexistentToken();
39 
40     /**
41      * The caller cannot approve to their own address.
42      */
43     error ApproveToCaller();
44 
45     /**
46      * Cannot query the balance for the zero address.
47      */
48     error BalanceQueryForZeroAddress();
49 
50     /**
51      * Cannot mint to the zero address.
52      */
53     error MintToZeroAddress();
54 
55     /**
56      * The quantity of tokens minted must be more than zero.
57      */
58     error MintZeroQuantity();
59 
60     /**
61      * The token does not exist.
62      */
63     error OwnerQueryForNonexistentToken();
64 
65     /**
66      * The caller must own the token or be an approved operator.
67      */
68     error TransferCallerNotOwnerNorApproved();
69 
70     /**
71      * The token must be owned by `from`.
72      */
73     error TransferFromIncorrectOwner();
74 
75     /**
76      * Cannot safely transfer to a contract that does not implement the
77      * ERC721Receiver interface.
78      */
79     error TransferToNonERC721ReceiverImplementer();
80 
81     /**
82      * Cannot transfer to the zero address.
83      */
84     error TransferToZeroAddress();
85 
86     /**
87      * The token does not exist.
88      */
89     error URIQueryForNonexistentToken();
90 
91     /**
92      * The `quantity` minted with ERC2309 exceeds the safety limit.
93      */
94     error MintERC2309QuantityExceedsLimit();
95 
96     /**
97      * The `extraData` cannot be set on an unintialized ownership slot.
98      */
99     error OwnershipNotInitializedForExtraData();
100 
101     // =============================================================
102     //                            STRUCTS
103     // =============================================================
104 
105     struct TokenOwnership {
106         // The address of the owner.
107         address addr;
108         // Stores the start time of ownership with minimal overhead for tokenomics.
109         uint64 startTimestamp;
110         // Whether the token has been burned.
111         bool burned;
112         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
113         uint24 extraData;
114     }
115 
116     // =============================================================
117     //                         TOKEN COUNTERS
118     // =============================================================
119 
120     /**
121      * @dev Returns the total number of tokens in existence.
122      * Burned tokens will reduce the count.
123      * To get the total number of tokens minted, please see {_totalMinted}.
124      */
125     function totalSupply() external view returns (uint256);
126 
127     // =============================================================
128     //                            IERC165
129     // =============================================================
130 
131     /**
132      * @dev Returns true if this contract implements the interface defined by
133      * `interfaceId`. See the corresponding
134      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
135      * to learn more about how these ids are created.
136      *
137      * This function call must use less than 30000 gas.
138      */
139     function supportsInterface(bytes4 interfaceId) external view returns (bool);
140 
141     // =============================================================
142     //                            IERC721
143     // =============================================================
144 
145     /**
146      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
147      */
148     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
149 
150     /**
151      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
152      */
153     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
154 
155     /**
156      * @dev Emitted when `owner` enables or disables
157      * (`approved`) `operator` to manage all of its assets.
158      */
159     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
160 
161     /**
162      * @dev Returns the number of tokens in `owner`'s account.
163      */
164     function balanceOf(address owner) external view returns (uint256 balance);
165 
166     /**
167      * @dev Returns the owner of the `tokenId` token.
168      *
169      * Requirements:
170      *
171      * - `tokenId` must exist.
172      */
173     function ownerOf(uint256 tokenId) external view returns (address owner);
174 
175     /**
176      * @dev Safely transfers `tokenId` token from `from` to `to`,
177      * checking first that contract recipients are aware of the ERC721 protocol
178      * to prevent tokens from being forever locked.
179      *
180      * Requirements:
181      *
182      * - `from` cannot be the zero address.
183      * - `to` cannot be the zero address.
184      * - `tokenId` token must exist and be owned by `from`.
185      * - If the caller is not `from`, it must be have been allowed to move
186      * this token by either {approve} or {setApprovalForAll}.
187      * - If `to` refers to a smart contract, it must implement
188      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
189      *
190      * Emits a {Transfer} event.
191      */
192     function safeTransferFrom(
193         address from,
194         address to,
195         uint256 tokenId,
196         bytes calldata data
197     ) external;
198 
199     /**
200      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
201      */
202     function safeTransferFrom(
203         address from,
204         address to,
205         uint256 tokenId
206     ) external;
207 
208     /**
209      * @dev Transfers `tokenId` from `from` to `to`.
210      *
211      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
212      * whenever possible.
213      *
214      * Requirements:
215      *
216      * - `from` cannot be the zero address.
217      * - `to` cannot be the zero address.
218      * - `tokenId` token must be owned by `from`.
219      * - If the caller is not `from`, it must be approved to move this token
220      * by either {approve} or {setApprovalForAll}.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(
225         address from,
226         address to,
227         uint256 tokenId
228     ) external;
229 
230     /**
231      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
232      * The approval is cleared when the token is transferred.
233      *
234      * Only a single account can be approved at a time, so approving the
235      * zero address clears previous approvals.
236      *
237      * Requirements:
238      *
239      * - The caller must own the token or be an approved operator.
240      * - `tokenId` must exist.
241      *
242      * Emits an {Approval} event.
243      */
244     function approve(address to, uint256 tokenId) external;
245 
246     /**
247      * @dev Approve or remove `operator` as an operator for the caller.
248      * Operators can call {transferFrom} or {safeTransferFrom}
249      * for any token owned by the caller.
250      *
251      * Requirements:
252      *
253      * - The `operator` cannot be the caller.
254      *
255      * Emits an {ApprovalForAll} event.
256      */
257     function setApprovalForAll(address operator, bool _approved) external;
258 
259     /**
260      * @dev Returns the account approved for `tokenId` token.
261      *
262      * Requirements:
263      *
264      * - `tokenId` must exist.
265      */
266     function getApproved(uint256 tokenId) external view returns (address operator);
267 
268     /**
269      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
270      *
271      * See {setApprovalForAll}.
272      */
273     function isApprovedForAll(address owner, address operator) external view returns (bool);
274 
275     // =============================================================
276     //                        IERC721Metadata
277     // =============================================================
278 
279     /**
280      * @dev Returns the token collection name.
281      */
282     function name() external view returns (string memory);
283 
284     /**
285      * @dev Returns the token collection symbol.
286      */
287     function symbol() external view returns (string memory);
288 
289     /**
290      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
291      */
292     function tokenURI(uint256 tokenId) external view returns (string memory);
293 
294     // =============================================================
295     //                           IERC2309
296     // =============================================================
297 
298     /**
299      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
300      * (inclusive) is transferred from `from` to `to`, as defined in the
301      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
302      *
303      * See {_mintERC2309} for more details.
304      */
305     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
306 }
307 
308 
309 contract Noots is IERC721A { 
310 
311     address private _owner;
312     function owner() public view returns(address){
313         return _owner;
314     }
315 
316     modifier onlyOwner() { 
317         require(_owner==msg.sender);
318         _; 
319     }
320 
321     uint256 public constant MAX_SUPPLY = 1777;
322     uint256 public MAX_FREE = 1777;
323     uint256 public MAX_FREE_PER_WALLET = 1;
324     uint256 public COST = 0.001 ether;
325 
326     string private constant _name = "Noots";
327     string private constant _symbol = "NOOT";
328     string private _baseURI = "0xc0E31f8DAe42813E957D4E05c04684afEe9d78Eb";
329 
330     constructor() {
331         _owner = msg.sender;
332     }
333 
334     function mint(uint256 amount) external payable{
335         address _caller = _msgSenderERC721A();
336 
337         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
338         require(amount*COST <= msg.value, "Value to Low");
339 
340         _mint(_caller, amount);
341     }
342 
343     function freeMint() external{
344         address _caller = _msgSenderERC721A();
345         uint256 amount = 1;
346 
347         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
348         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "Max per Wallet");
349 
350         _mint(_caller, amount);
351     }
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
414     function setData(string memory _base) external onlyOwner{
415         _baseURI = _base;
416     }
417 
418     function setConfig(uint256 _MAX_FREE_PER_WALLET, uint256 _COST, uint256 _MAX_FREE) external onlyOwner{
419         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
420         COST = _COST;
421         MAX_FREE = _MAX_FREE;
422     }
423 
424     /**
425      * @dev Returns the starting token ID. 
426      * To change the starting token ID, please override this function.
427      */
428     function _startTokenId() internal view virtual returns (uint256) {
429         return 0;
430     }
431 
432     /**
433      * @dev Returns the next token ID to be minted.
434      */
435     function _nextTokenId() internal view returns (uint256) {
436         return _currentIndex;
437     }
438 
439     /**
440      * @dev Returns the total number of tokens in existence.
441      * Burned tokens will reduce the count. 
442      * To get the total number of tokens minted, please see `_totalMinted`.
443      */
444     function totalSupply() public view override returns (uint256) {
445         // Counter underflow is impossible as _burnCounter cannot be incremented
446         // more than `_currentIndex - _startTokenId()` times.
447         unchecked {
448             return _currentIndex - _startTokenId();
449         }
450     }
451 
452     /**
453      * @dev Returns the total amount of tokens minted in the contract.
454      */
455     function _totalMinted() internal view returns (uint256) {
456         // Counter underflow is impossible as _currentIndex does not decrement,
457         // and it is initialized to `_startTokenId()`
458         unchecked {
459             return _currentIndex - _startTokenId();
460         }
461     }
462 
463 
464     /**
465      * @dev See {IERC165-supportsInterface}.
466      */
467     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
468         // The interface IDs are constants representing the first 4 bytes of the XOR of
469         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
470         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
471         return
472             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
473             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
474             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
475     }
476 
477     /**
478      * @dev See {IERC721-balanceOf}.
479      */
480     function balanceOf(address owner) public view override returns (uint256) {
481         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
482         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
483     }
484 
485     /**
486      * Returns the number of tokens minted by `owner`.
487      */
488     function _numberMinted(address owner) internal view returns (uint256) {
489         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
490     }
491 
492 
493 
494     /**
495      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
496      */
497     function _getAux(address owner) internal view returns (uint64) {
498         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
499     }
500 
501     /**
502      * Returns the packed ownership data of `tokenId`.
503      */
504     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
505         uint256 curr = tokenId;
506 
507         unchecked {
508             if (_startTokenId() <= curr)
509                 if (curr < _currentIndex) {
510                     uint256 packed = _packedOwnerships[curr];
511                     // If not burned.
512                     if (packed & BITMASK_BURNED == 0) {
513                         // Invariant:
514                         // There will always be an ownership that has an address and is not burned
515                         // before an ownership that does not have an address and is not burned.
516                         // Hence, curr will not underflow.
517                         //
518                         // We can directly compare the packed value.
519                         // If the address is zero, packed is zero.
520                         while (packed == 0) {
521                             packed = _packedOwnerships[--curr];
522                         }
523                         return packed;
524                     }
525                 }
526         }
527         revert OwnerQueryForNonexistentToken();
528     }
529 
530     /**
531      * Returns the unpacked `TokenOwnership` struct from `packed`.
532      */
533     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
534         ownership.addr = address(uint160(packed));
535         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
536         ownership.burned = packed & BITMASK_BURNED != 0;
537     }
538 
539     /**
540      * Returns the unpacked `TokenOwnership` struct at `index`.
541      */
542     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
543         return _unpackedOwnership(_packedOwnerships[index]);
544     }
545 
546     /**
547      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
548      */
549     function _initializeOwnershipAt(uint256 index) internal {
550         if (_packedOwnerships[index] == 0) {
551             _packedOwnerships[index] = _packedOwnershipOf(index);
552         }
553     }
554 
555     /**
556      * Gas spent here starts off proportional to the maximum mint batch size.
557      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
558      */
559     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
560         return _unpackedOwnership(_packedOwnershipOf(tokenId));
561     }
562 
563     /**
564      * @dev See {IERC721-ownerOf}.
565      */
566     function ownerOf(uint256 tokenId) public view override returns (address) {
567         return address(uint160(_packedOwnershipOf(tokenId)));
568     }
569 
570     /**
571      * @dev See {IERC721Metadata-name}.
572      */
573     function name() public view virtual override returns (string memory) {
574         return _name;
575     }
576 
577     /**
578      * @dev See {IERC721Metadata-symbol}.
579      */
580     function symbol() public view virtual override returns (string memory) {
581         return _symbol;
582     }
583 
584     
585     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
586         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
587         string memory baseURI = _baseURI;
588         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
589     }
590 
591     /**
592      * @dev Casts the address to uint256 without masking.
593      */
594     function _addressToUint256(address value) private pure returns (uint256 result) {
595         assembly {
596             result := value
597         }
598     }
599 
600     /**
601      * @dev Casts the boolean to uint256 without branching.
602      */
603     function _boolToUint256(bool value) private pure returns (uint256 result) {
604         assembly {
605             result := value
606         }
607     }
608 
609     /**
610      * @dev See {IERC721-approve}.
611      */
612     function approve(address to, uint256 tokenId) public override {
613         address owner = address(uint160(_packedOwnershipOf(tokenId)));
614         if (to == owner) revert();
615 
616         if (_msgSenderERC721A() != owner)
617             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
618                 revert ApprovalCallerNotOwnerNorApproved();
619             }
620 
621         _tokenApprovals[tokenId] = to;
622         emit Approval(owner, to, tokenId);
623     }
624 
625     /**
626      * @dev See {IERC721-getApproved}.
627      */
628     function getApproved(uint256 tokenId) public view override returns (address) {
629         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
630 
631         return _tokenApprovals[tokenId];
632     }
633 
634     /**
635      * @dev See {IERC721-setApprovalForAll}.
636      */
637     function setApprovalForAll(address operator, bool approved) public virtual override {
638         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
639 
640         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
641         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
642     }
643 
644     /**
645      * @dev See {IERC721-isApprovedForAll}.
646      */
647     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
648         return _operatorApprovals[owner][operator];
649     }
650 
651     /**
652      * @dev See {IERC721-transferFrom}.
653      */
654     function transferFrom(
655             address from,
656             address to,
657             uint256 tokenId
658             ) public virtual override {
659         _transfer(from, to, tokenId);
660     }
661 
662     /**
663      * @dev See {IERC721-safeTransferFrom}.
664      */
665     function safeTransferFrom(
666             address from,
667             address to,
668             uint256 tokenId
669             ) public virtual override {
670         safeTransferFrom(from, to, tokenId, '');
671     }
672 
673     /**
674      * @dev See {IERC721-safeTransferFrom}.
675      */
676     function safeTransferFrom(
677             address from,
678             address to,
679             uint256 tokenId,
680             bytes memory _data
681             ) public virtual override {
682         _transfer(from, to, tokenId);
683     }
684 
685     /**
686      * @dev Returns whether `tokenId` exists.
687      *
688      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
689      *
690      * Tokens start existing when they are minted (`_mint`),
691      */
692     function _exists(uint256 tokenId) internal view returns (bool) {
693         return
694             _startTokenId() <= tokenId &&
695             tokenId < _currentIndex;
696     }
697 
698   
699 
700     /**
701      * @dev Mints `quantity` tokens and transfers them to `to`.
702      *
703      * Requirements:
704      *
705      * - `to` cannot be the zero address.
706      * - `quantity` must be greater than 0.
707      *
708      * Emits a {Transfer} event.
709      */
710     function _mint(address to, uint256 quantity) internal {
711         uint256 startTokenId = _currentIndex;
712         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
713         if (quantity == 0) revert MintZeroQuantity();
714 
715 
716         // Overflows are incredibly unrealistic.
717         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
718         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
719         unchecked {
720             // Updates:
721             // - `balance += quantity`.
722             // - `numberMinted += quantity`.
723             //
724             // We can directly add to the balance and number minted.
725             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
726 
727             // Updates:
728             // - `address` to the owner.
729             // - `startTimestamp` to the timestamp of minting.
730             // - `burned` to `false`.
731             // - `nextInitialized` to `quantity == 1`.
732             _packedOwnerships[startTokenId] =
733                 _addressToUint256(to) |
734                 (block.timestamp << BITPOS_START_TIMESTAMP) |
735                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
736 
737             uint256 updatedIndex = startTokenId;
738             uint256 end = updatedIndex + quantity;
739 
740             do {
741                 emit Transfer(address(0), to, updatedIndex++);
742             } while (updatedIndex < end);
743 
744             _currentIndex = updatedIndex;
745         }
746         _afterTokenTransfers(address(0), to, startTokenId, quantity);
747     }
748 
749     /**
750      * @dev Transfers `tokenId` from `from` to `to`.
751      *
752      * Requirements:
753      *
754      * - `to` cannot be the zero address.
755      * - `tokenId` token must be owned by `from`.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _transfer(
760             address from,
761             address to,
762             uint256 tokenId
763             ) private {
764 
765         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
766 
767         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
768 
769         address approvedAddress = _tokenApprovals[tokenId];
770 
771         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
772                 isApprovedForAll(from, _msgSenderERC721A()) ||
773                 approvedAddress == _msgSenderERC721A());
774 
775         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
776 
777 
778         // Clear approvals from the previous owner.
779         if (_addressToUint256(approvedAddress) != 0) {
780             delete _tokenApprovals[tokenId];
781         }
782 
783         // Underflow of the sender's balance is impossible because we check for
784         // ownership above and the recipient's balance can't realistically overflow.
785         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
786         unchecked {
787             // We can directly increment and decrement the balances.
788             --_packedAddressData[from]; // Updates: `balance -= 1`.
789             ++_packedAddressData[to]; // Updates: `balance += 1`.
790 
791             // Updates:
792             // - `address` to the next owner.
793             // - `startTimestamp` to the timestamp of transfering.
794             // - `burned` to `false`.
795             // - `nextInitialized` to `true`.
796             _packedOwnerships[tokenId] =
797                 _addressToUint256(to) |
798                 (block.timestamp << BITPOS_START_TIMESTAMP) |
799                 BITMASK_NEXT_INITIALIZED;
800 
801             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
802             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
803                 uint256 nextTokenId = tokenId + 1;
804                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
805                 if (_packedOwnerships[nextTokenId] == 0) {
806                     // If the next slot is within bounds.
807                     if (nextTokenId != _currentIndex) {
808                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
809                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
810                     }
811                 }
812             }
813         }
814 
815         emit Transfer(from, to, tokenId);
816         _afterTokenTransfers(from, to, tokenId, 1);
817     }
818 
819 
820 
821 
822     /**
823      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
824      * minting.
825      * And also called after one token has been burned.
826      *
827      * startTokenId - the first token id to be transferred
828      * quantity - the amount to be transferred
829      *
830      * Calling conditions:
831      *
832      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
833      * transferred to `to`.
834      * - When `from` is zero, `tokenId` has been minted for `to`.
835      * - When `to` is zero, `tokenId` has been burned by `from`.
836      * - `from` and `to` are never both zero.
837      */
838     function _afterTokenTransfers(
839             address from,
840             address to,
841             uint256 startTokenId,
842             uint256 quantity
843             ) internal virtual {}
844 
845     /**
846      * @dev Returns the message sender (defaults to `msg.sender`).
847      *
848      * If you are writing GSN compatible contracts, you need to override this function.
849      */
850     function _msgSenderERC721A() internal view virtual returns (address) {
851         return msg.sender;
852     }
853 
854     /**
855      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
856      */
857     function _toString(uint256 value) internal pure returns (string memory ptr) {
858         assembly {
859             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
860             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
861             // We will need 1 32-byte word to store the length, 
862             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
863             ptr := add(mload(0x40), 128)
864 
865          // Update the free memory pointer to allocate.
866          mstore(0x40, ptr)
867 
868          // Cache the end of the memory to calculate the length later.
869          let end := ptr
870 
871          // We write the string from the rightmost digit to the leftmost digit.
872          // The following is essentially a do-while loop that also handles the zero case.
873          // Costs a bit more than early returning for the zero case,
874          // but cheaper in terms of deployment and overall runtime costs.
875          for { 
876              // Initialize and perform the first pass without check.
877              let temp := value
878                  // Move the pointer 1 byte leftwards to point to an empty character slot.
879                  ptr := sub(ptr, 1)
880                  // Write the character to the pointer. 48 is the ASCII index of '0'.
881                  mstore8(ptr, add(48, mod(temp, 10)))
882                  temp := div(temp, 10)
883          } temp { 
884              // Keep dividing `temp` until zero.
885         temp := div(temp, 10)
886          } { 
887              // Body of the for loop.
888         ptr := sub(ptr, 1)
889          mstore8(ptr, add(48, mod(temp, 10)))
890          }
891 
892      let length := sub(end, ptr)
893          // Move the pointer 32 bytes leftwards to make room for the length.
894          ptr := sub(ptr, 32)
895          // Store the length.
896          mstore(ptr, length)
897         }
898     }
899 
900     function withdraw() external onlyOwner {
901         uint256 balance = address(this).balance;
902         payable(msg.sender).transfer(balance);
903     }
904 }