1 //==============#%%%%%%%%%%%+=======#%@%%%%%%@%%%@@@@%#%@%*=====%%%%%%%%%%%+=============+#%
2 //*==============+%%%%%%%%%%%=====*@%%%%%%%%%%%%%%%%%%*.-%@#===%%%%%%%%%%#=============+#%%%
3 //%%*==============#%%%%%%%%%#===%%%%%%%%%%%%%%%%%%%%%%#=+%@*=#%%%%%%%%%#============+#%%%%%
4 //%%%%#=============*%%%%%%%%%#*@%%%%%%%%%%%%%%%%%%%%%%%%+#@@*%%%%%%%%%*============#%%%%%%%
5 //%%%%%%#+===========+%%%%%%%@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@%%%%%%%+===========#%%%%%%%%%
6 //%%%%%%%%#+===========#%%%%@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%@@@%%%#===========#%%%%%%%%%%%
7 //%%%%%%%%%%#+==========+%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%*==========*%%%%%%%%%%%%%
8 //%%%%%%%%%%%%%+==========#%@@%%%%%%%%%%%%%%%%%@@%%%%@%%%%%%%%%%@@*=========*%%%%%%%%%%%%%%*
9 //#%%%%%%%%%%%%%%*=========#@%%%%%%%%%%%%@##+=-.#%%##@%%%%%%%%%%%%#=======*%%%%%%%%%%%%%*+==
10 //==*#%%%%%%%%%%%%%*========@%%%%%%%%%%%%=      =%-  +@%%%%%%%%%%%+=====*%%%%%%%%%%%%*+=====
11 //=====+#%%%%%%%%%%%%*======%%%%%%%%%%%@=.   .:: . . *@%%%%%%%%@*=====*%%%%%%%%%%%*+========
12 //========+*%%%%%%%%%%%*=====%@%%%%%%%%%-#*++#*%#=**--@@%%%%%@%*=+==*%%%%%%%%%%*+===========
13 //===========+*%%%%%%%%%%#=====+*%@@@@*=+#+=*%%%%+**==-@@@@%+==+%@#@@%%%%%%%#+==============
14 //===============*#%%%%%%%%#+=====*%@@==+@%#+++**%%*==:@@%*===*@*.=@@%@@@#+===============+*
15 //*++===============+#%%%%%%%#+====+%@- .:+%%%%%%%-::. @@+===*@+  %@@@%=@@===========+*#%%%%
16 //%%%%%#*+=============+*%%%%%%#+===*@*.   .*%%#+.    -@%==+*%@#  .==::%%=======+*#%%%%%%%%%
17 //%%%%%%%%%%#*+===========+*%%%%%%+==*%@%%%%%%%%%%%%%%@#++%@@@@= .+++#@*===+*#%%%%%%%%%%%%%%
18 //%%%%%%%%%%%%%%%%#*+=========*#%%%%*=+*@@+--------%@%++*@@%--*@%%@*+++*#%%%%%%%%%%%%%%%%%%%
19 //%%%%%%%%%%%%%%%%%%%%%#*++======+%@@@@@@@@@@@@@@@@@@@@@@%-+%#=:+@@#%%%%%%%%%%%%%%%%%%%##**+
20 //++***###%%%%%%%%%%%%%%%%%%%#*+*%@@@@%@*: .**-*+. .+%%%@@#-.*%%%@@%%%%%%%%%##**+++=========
21 //=============+++**###%%%%%%%@@@%=+@%=+*%%++%@%*+#%*+=+@@%%*-=@@%##**++====================
22 //===================-======+#@@***@@*====+*@%@%@*+=====%@*=#%@@*====-==-==-==-==-==========
23 //==========-==-==-==-==-==-+@@*+*#@@+=====+@%@%@+======*@@%%@@*+++++++++++++===============
24 //===+++++++*******######%%%@@+-==@@#======+@%@%@*======+@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
25 //%%%%%%%%%%%%%%%%%%%%%%%%%@@@*#%%@@+======+@%@%@*=======#@%=+++*##%%%%%%%%%%%%%%%%%%%%%%%%%
26 //%%%%%%%%%%%%%%%%%%%%%#**+%@+:.:%@%=======+@%@%@*=======+@@*+=========+**##%%%%%%%%%%%%%%%%
27 //%%%%%%%%%%%%%##**+=======#@#*%%@@*=======+@%@%@#========%@@%%#*+=============++**##%%%%%%%
28 //%%%%%%##*++=============+*@@@%%@%========+@%@%@#========*@@%%%%%%%*+==================++**
29 //**+=================+*#%%%%%@%@@*=========@%@%@#========+@@*=*%%%%%%%%#*+=================
30 //================+*#%%%%%%%%*=+@@%%%%%%%%%%@@@@@@%%%%%%%%%@@#===+#%%%%%%%%%#*+=============
31 //============+*#%%%%%%%%%#+====+#@@%%%%%%%%%%%%%%%%%%%%%%@@@*======+#%%%%%%%%%%%#+=========
32 //========+*#%%%%%%%%%%%*=======#@@@%%%%%%%%%%%%%%%%%%%%%@@@%%%*=======*#%%%%%%%%%%%%#*+====
33 //====+*#%%%%%%%%%%%%#+=======*%%@@%+++++++++@@@@++++++++%@@%%%%%+========*%%%%%%%%%%%%%%%#+
34 //=*#%%%%%%%%%%%%%%*========+%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%#=========+#%%%%%%%%%%%%%%
35 //%%%%%%%%%%%%%%#+=========#%%%%%@@%===++++*#@@@@########@@@=#%%%%%%#==========+#%%%%%%%%%%%
36 //%%%%%%%%%%%%*==========*%%%%%%%#@@********%@@%@#****###@@@==#%%%%%%%*===========*%%%%%%%%%
37 //%%%%%%%%%#+==========+%%%%%%%%+#@%======++%@%@@#******#@@@===*%%%%%%%%*===========+*%%%%%%
38 //%%%%%%%*============#%%%%%%%%==%@#---=====#@#@@#*++++++@@%====+%%%%%%%%%+============+#%%%
39 //%%%%#+============*%%%%%%%%%===%@@@@@@@@@@@@#@@@@@@@@@@@@#=====+%%%%%%%%%#+=============+#
40 //%%*=============+%%%%%%%%%%====@@@%%%%%%%%@@*@@@@@@@@@@@@#=======%%%%%%%%%%#==============
41 //+==============#%%%%%%%%%%=====@@@@@@@@@@@@@*@@@%%%%%%%@@#========#%%%%%%%%%%*============
42 //=============*%%%%%%%%%%#======*%%@@@@@@@@#*=*%%%%@@@@@@@%=========*%%%%%%%%%%%*==========
43 //===========+%%%%%%%%%%%#=========#%%%%%%%%========%%%%%%%%#=========*%%%%%%%%%%%%+========
44 //==========#%%%%%%%%%%%#=========+%%%%%%%%#========#%%%%%%%%+=========+%%%%%%%%%%%%#+======
45 //========*%%%%%%%%%%%%#==========#%%%%%%%%*========*%%%%%%%%%===========%%%%%%%%%%%%%#=====
46 
47 // SPDX-License-Identifier: MIT
48 pragma solidity 0.8.17;
49 
50 /*
51  * @dev Interface of ERC721A.
52  */
53 interface IERC721A {
54     /**
55      * The caller must own the token or be an approved operator.
56      */
57     error ApprovalCallerNotOwnerNorApproved();
58 
59     /**
60      * The token does not exist.
61      */
62     error ApprovalQueryForNonexistentToken();
63 
64     /**
65      * The caller cannot approve to their own address.
66      */
67     error ApproveToCaller();
68 
69     /**
70      * Cannot query the balance for the zero address.
71      */
72     error BalanceQueryForZeroAddress();
73 
74     /**
75      * Cannot mint to the zero address.
76      */
77     error MintToZeroAddress();
78 
79     /**
80      * The quantity of tokens minted must be more than zero.
81      */
82     error MintZeroQuantity();
83 
84     /**
85      * The token does not exist.
86      */
87     error OwnerQueryForNonexistentToken();
88 
89     /**
90      * The caller must own the token or be an approved operator.
91      */
92     error TransferCallerNotOwnerNorApproved();
93 
94     /**
95      * The token must be owned by `from`.
96      */
97     error TransferFromIncorrectOwner();
98 
99     /**
100      * Cannot safely transfer to a contract that does not implement the
101      * ERC721Receiver interface.
102      */
103     error TransferToNonERC721ReceiverImplementer();
104 
105     /**
106      * Cannot transfer to the zero address.
107      */
108     error TransferToZeroAddress();
109 
110     /**
111      * The token does not exist.
112      */
113     error URIQueryForNonexistentToken();
114 
115     /**
116      * The `quantity` minted with ERC2309 exceeds the safety limit.
117      */
118     error MintERC2309QuantityExceedsLimit();
119 
120     /**
121      * The `extraData` cannot be set on an unintialized ownership slot.
122      */
123     error OwnershipNotInitializedForExtraData();
124 
125     // =============================================================
126     //                            STRUCTS
127     // =============================================================
128 
129     struct TokenOwnership {
130         // The address of the owner.
131         address addr;
132         // Stores the start time of ownership with minimal overhead for tokenomics.
133         uint64 startTimestamp;
134         // Whether the token has been burned.
135         bool burned;
136         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
137         uint24 extraData;
138     }
139 
140     // =============================================================
141     //                         TOKEN COUNTERS
142     // =============================================================
143 
144     /**
145      * @dev Returns the total number of tokens in existence.
146      * Burned tokens will reduce the count.
147      * To get the total number of tokens minted, please see {_totalMinted}.
148      */
149     function totalSupply() external view returns (uint256);
150 
151     // =============================================================
152     //                            IERC165
153     // =============================================================
154 
155     /**
156      * @dev Returns true if this contract implements the interface defined by
157      * `interfaceId`. See the corresponding
158      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
159      * to learn more about how these ids are created.
160      *
161      * This function call must use less than 30000 gas.
162      */
163     function supportsInterface(bytes4 interfaceId) external view returns (bool);
164 
165     // =============================================================
166     //                            IERC721
167     // =============================================================
168 
169     /**
170      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
173 
174     /**
175      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
176      */
177     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
178 
179     /**
180      * @dev Emitted when `owner` enables or disables
181      * (`approved`) `operator` to manage all of its assets.
182      */
183     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
184 
185     /**
186      * @dev Returns the number of tokens in `owner`'s account.
187      */
188     function balanceOf(address owner) external view returns (uint256 balance);
189 
190     /**
191      * @dev Returns the owner of the `tokenId` token.
192      *
193      * Requirements:
194      *
195      * - `tokenId` must exist.
196      */
197     function ownerOf(uint256 tokenId) external view returns (address owner);
198 
199     /**
200      * @dev Safely transfers `tokenId` token from `from` to `to`,
201      * checking first that contract recipients are aware of the ERC721 protocol
202      * to prevent tokens from being forever locked.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must exist and be owned by `from`.
209      * - If the caller is not `from`, it must be have been allowed to move
210      * this token by either {approve} or {setApprovalForAll}.
211      * - If `to` refers to a smart contract, it must implement
212      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
213      *
214      * Emits a {Transfer} event.
215      */
216     function safeTransferFrom(
217         address from,
218         address to,
219         uint256 tokenId,
220         bytes calldata data
221     ) external;
222 
223     /**
224      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
225      */
226     function safeTransferFrom(
227         address from,
228         address to,
229         uint256 tokenId
230     ) external;
231 
232     /**
233      * @dev Transfers `tokenId` from `from` to `to`.
234      *
235      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
236      * whenever possible.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must be owned by `from`.
243      * - If the caller is not `from`, it must be approved to move this token
244      * by either {approve} or {setApprovalForAll}.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transferFrom(
249         address from,
250         address to,
251         uint256 tokenId
252     ) external;
253 
254     /**
255      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
256      * The approval is cleared when the token is transferred.
257      *
258      * Only a single account can be approved at a time, so approving the
259      * zero address clears previous approvals.
260      *
261      * Requirements:
262      *
263      * - The caller must own the token or be an approved operator.
264      * - `tokenId` must exist.
265      *
266      * Emits an {Approval} event.
267      */
268     function approve(address to, uint256 tokenId) external;
269 
270     /**
271      * @dev Approve or remove `operator` as an operator for the caller.
272      * Operators can call {transferFrom} or {safeTransferFrom}
273      * for any token owned by the caller.
274      *
275      * Requirements:
276      *
277      * - The `operator` cannot be the caller.
278      *
279      * Emits an {ApprovalForAll} event.
280      */
281     function setApprovalForAll(address operator, bool _approved) external;
282 
283     /**
284      * @dev Returns the account approved for `tokenId` token.
285      *
286      * Requirements:
287      *
288      * - `tokenId` must exist.
289      */
290     function getApproved(uint256 tokenId) external view returns (address operator);
291 
292     /**
293      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
294      *
295      * See {setApprovalForAll}.
296      */
297     function isApprovedForAll(address owner, address operator) external view returns (bool);
298 
299     // =============================================================
300     //                        IERC721Metadata
301     // =============================================================
302 
303     /**
304      * @dev Returns the token collection name.
305      */
306     function name() external view returns (string memory);
307 
308     /**
309      * @dev Returns the token collection symbol.
310      */
311     function symbol() external view returns (string memory);
312 
313     /**
314      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
315      */
316     function tokenURI(uint256 tokenId) external view returns (string memory);
317 
318     // =============================================================
319     //                           IERC2309
320     // =============================================================
321 
322     /**
323      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
324      * (inclusive) is transferred from `from` to `to`, as defined in the
325      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
326      *
327      * See {_mintERC2309} for more details.
328      */
329     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
330 }
331 
332 
333 contract NFT is IERC721A { 
334 
335     address private _owner;
336     function owner() public view returns(address){
337         return _owner;
338     }
339 
340     modifier onlyOwner() { 
341         require(_owner==msg.sender);
342         _; 
343     }
344 
345     uint256 public MAX_SUPPLY = 4444;
346     uint256 public MAX_FREE = 0;
347     uint256 public MAX_FREE_PER_WALLET = 0;
348     uint256 public COST = 0.003 ether;
349 
350     string private constant _name = "McDonaldsHero";
351     string private constant _symbol = "McDonaldsHero";
352     string private _baseURI = "bafybeiftli77m2ci3hla2iltabyeo4vocr2zlts77bdq7lvcqsaxmckbqa";
353 
354     constructor() {
355         _owner = msg.sender;
356     }
357 
358     function mint(uint256 amount) external payable{
359         address _caller = _msgSenderERC721A();
360 
361         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
362         require(amount*COST <= msg.value, "Value to Low");
363         require(amount + _numberMinted(_caller) <= 2, "Max per Wallet");
364 
365         _mint(_caller, amount);
366     }
367 
368     function freeMint() external{
369         address _caller = _msgSenderERC721A();
370         uint256 amount = 1;
371 
372         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
373         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "Max per Wallet");
374 
375         _mint(_caller, amount);
376     }
377 
378     // Mask of an entry in packed address data.
379     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
380 
381     // The bit position of `numberMinted` in packed address data.
382     uint256 private constant BITPOS_NUMBER_MINTED = 64;
383 
384     // The bit position of `numberBurned` in packed address data.
385     uint256 private constant BITPOS_NUMBER_BURNED = 128;
386 
387     // The bit position of `aux` in packed address data.
388     uint256 private constant BITPOS_AUX = 192;
389 
390     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
391     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
392 
393     // The bit position of `startTimestamp` in packed ownership.
394     uint256 private constant BITPOS_START_TIMESTAMP = 160;
395 
396     // The bit mask of the `burned` bit in packed ownership.
397     uint256 private constant BITMASK_BURNED = 1 << 224;
398 
399     // The bit position of the `nextInitialized` bit in packed ownership.
400     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
401 
402     // The bit mask of the `nextInitialized` bit in packed ownership.
403     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
404 
405     // The tokenId of the next token to be minted.
406     uint256 private _currentIndex = 0;
407 
408     // The number of tokens burned.
409     // uint256 private _burnCounter;
410 
411 
412     // Mapping from token ID to ownership details
413     // An empty struct value does not necessarily mean the token is unowned.
414     // See `_packedOwnershipOf` implementation for details.
415     //
416     // Bits Layout:
417     // - [0..159] `addr`
418     // - [160..223] `startTimestamp`
419     // - [224] `burned`
420     // - [225] `nextInitialized`
421     mapping(uint256 => uint256) private _packedOwnerships;
422 
423     // Mapping owner address to address data.
424     //
425     // Bits Layout:
426     // - [0..63] `balance`
427     // - [64..127] `numberMinted`
428     // - [128..191] `numberBurned`
429     // - [192..255] `aux`
430     mapping(address => uint256) private _packedAddressData;
431 
432     // Mapping from token ID to approved address.
433     mapping(uint256 => address) private _tokenApprovals;
434 
435     // Mapping from owner to operator approvals
436     mapping(address => mapping(address => bool)) private _operatorApprovals;
437 
438 
439     function setData(string memory _base) external onlyOwner{
440         _baseURI = _base;
441     }
442 
443     function setConfig(uint256 _MAX_FREE_PER_WALLET, uint256 _COST, uint256 _MAX_FREE, uint256 _MAX_SUPPLY) external onlyOwner{
444         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
445         COST = _COST;
446         MAX_FREE = _MAX_FREE;
447         MAX_SUPPLY = _MAX_SUPPLY;
448     }
449 
450     /**
451      * @dev Returns the starting token ID. 
452      * To change the starting token ID, please override this function.
453      */
454     function _startTokenId() internal view virtual returns (uint256) {
455         return 0;
456     }
457 
458     /**
459      * @dev Returns the next token ID to be minted.
460      */
461     function _nextTokenId() internal view returns (uint256) {
462         return _currentIndex;
463     }
464 
465     /**
466      * @dev Returns the total number of tokens in existence.
467      * Burned tokens will reduce the count. 
468      * To get the total number of tokens minted, please see `_totalMinted`.
469      */
470     function totalSupply() public view override returns (uint256) {
471         // Counter underflow is impossible as _burnCounter cannot be incremented
472         // more than `_currentIndex - _startTokenId()` times.
473         unchecked {
474             return _currentIndex - _startTokenId();
475         }
476     }
477 
478     /**
479      * @dev Returns the total amount of tokens minted in the contract.
480      */
481     function _totalMinted() internal view returns (uint256) {
482         // Counter underflow is impossible as _currentIndex does not decrement,
483         // and it is initialized to `_startTokenId()`
484         unchecked {
485             return _currentIndex - _startTokenId();
486         }
487     }
488 
489 
490     /**
491      * @dev See {IERC165-supportsInterface}.
492      */
493     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
494         // The interface IDs are constants representing the first 4 bytes of the XOR of
495         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
496         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
497         return
498             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
499             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
500             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
501     }
502 
503     /**
504      * @dev See {IERC721-balanceOf}.
505      */
506     function balanceOf(address owner) public view override returns (uint256) {
507         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
508         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
509     }
510 
511     /**
512      * Returns the number of tokens minted by `owner`.
513      */
514     function _numberMinted(address owner) internal view returns (uint256) {
515         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
516     }
517 
518 
519 
520     /**
521      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
522      */
523     function _getAux(address owner) internal view returns (uint64) {
524         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
525     }
526 
527     /**
528      * Returns the packed ownership data of `tokenId`.
529      */
530     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
531         uint256 curr = tokenId;
532 
533         unchecked {
534             if (_startTokenId() <= curr)
535                 if (curr < _currentIndex) {
536                     uint256 packed = _packedOwnerships[curr];
537                     // If not burned.
538                     if (packed & BITMASK_BURNED == 0) {
539                         // Invariant:
540                         // There will always be an ownership that has an address and is not burned
541                         // before an ownership that does not have an address and is not burned.
542                         // Hence, curr will not underflow.
543                         //
544                         // We can directly compare the packed value.
545                         // If the address is zero, packed is zero.
546                         while (packed == 0) {
547                             packed = _packedOwnerships[--curr];
548                         }
549                         return packed;
550                     }
551                 }
552         }
553         revert OwnerQueryForNonexistentToken();
554     }
555 
556     /**
557      * Returns the unpacked `TokenOwnership` struct from `packed`.
558      */
559     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
560         ownership.addr = address(uint160(packed));
561         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
562         ownership.burned = packed & BITMASK_BURNED != 0;
563     }
564 
565     /**
566      * Returns the unpacked `TokenOwnership` struct at `index`.
567      */
568     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
569         return _unpackedOwnership(_packedOwnerships[index]);
570     }
571 
572     /**
573      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
574      */
575     function _initializeOwnershipAt(uint256 index) internal {
576         if (_packedOwnerships[index] == 0) {
577             _packedOwnerships[index] = _packedOwnershipOf(index);
578         }
579     }
580 
581     /**
582      * Gas spent here starts off proportional to the maximum mint batch size.
583      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
584      */
585     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
586         return _unpackedOwnership(_packedOwnershipOf(tokenId));
587     }
588 
589     /**
590      * @dev See {IERC721-ownerOf}.
591      */
592     function ownerOf(uint256 tokenId) public view override returns (address) {
593         return address(uint160(_packedOwnershipOf(tokenId)));
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-name}.
598      */
599     function name() public view virtual override returns (string memory) {
600         return _name;
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-symbol}.
605      */
606     function symbol() public view virtual override returns (string memory) {
607         return _symbol;
608     }
609 
610     
611     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
612         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
613         string memory baseURI = _baseURI;
614         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId),".json")) : "";
615     }
616 
617     /**
618      * @dev Casts the address to uint256 without masking.
619      */
620     function _addressToUint256(address value) private pure returns (uint256 result) {
621         assembly {
622             result := value
623         }
624     }
625 
626     /**
627      * @dev Casts the boolean to uint256 without branching.
628      */
629     function _boolToUint256(bool value) private pure returns (uint256 result) {
630         assembly {
631             result := value
632         }
633     }
634 
635     /**
636      * @dev See {IERC721-approve}.
637      */
638     function approve(address to, uint256 tokenId) public override {
639         address owner = address(uint160(_packedOwnershipOf(tokenId)));
640         if (to == owner) revert();
641 
642         if (_msgSenderERC721A() != owner)
643             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
644                 revert ApprovalCallerNotOwnerNorApproved();
645             }
646 
647         _tokenApprovals[tokenId] = to;
648         emit Approval(owner, to, tokenId);
649     }
650 
651     /**
652      * @dev See {IERC721-getApproved}.
653      */
654     function getApproved(uint256 tokenId) public view override returns (address) {
655         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
656 
657         return _tokenApprovals[tokenId];
658     }
659 
660     /**
661      * @dev See {IERC721-setApprovalForAll}.
662      */
663     function setApprovalForAll(address operator, bool approved) public virtual override {
664         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
665 
666         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
667         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
668     }
669 
670     /**
671      * @dev See {IERC721-isApprovedForAll}.
672      */
673     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
674         return _operatorApprovals[owner][operator];
675     }
676 
677     /**
678      * @dev See {IERC721-transferFrom}.
679      */
680     function transferFrom(
681             address from,
682             address to,
683             uint256 tokenId
684             ) public virtual override {
685         _transfer(from, to, tokenId);
686     }
687 
688     /**
689      * @dev See {IERC721-safeTransferFrom}.
690      */
691     function safeTransferFrom(
692             address from,
693             address to,
694             uint256 tokenId
695             ) public virtual override {
696         safeTransferFrom(from, to, tokenId, '');
697     }
698 
699     /**
700      * @dev See {IERC721-safeTransferFrom}.
701      */
702     function safeTransferFrom(
703             address from,
704             address to,
705             uint256 tokenId,
706             bytes memory _data
707             ) public virtual override {
708         _transfer(from, to, tokenId);
709     }
710 
711     /**
712      * @dev Returns whether `tokenId` exists.
713      *
714      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
715      *
716      * Tokens start existing when they are minted (`_mint`),
717      */
718     function _exists(uint256 tokenId) internal view returns (bool) {
719         return
720             _startTokenId() <= tokenId &&
721             tokenId < _currentIndex;
722     }
723 
724   
725 
726     /**
727      * @dev Mints `quantity` tokens and transfers them to `to`.
728      *
729      * Requirements:
730      *
731      * - `to` cannot be the zero address.
732      * - `quantity` must be greater than 0.
733      *
734      * Emits a {Transfer} event.
735      */
736     function _mint(address to, uint256 quantity) internal {
737         uint256 startTokenId = _currentIndex;
738         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
739         if (quantity == 0) revert MintZeroQuantity();
740 
741 
742         // Overflows are incredibly unrealistic.
743         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
744         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
745         unchecked {
746             // Updates:
747             // - `balance += quantity`.
748             // - `numberMinted += quantity`.
749             //
750             // We can directly add to the balance and number minted.
751             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
752 
753             // Updates:
754             // - `address` to the owner.
755             // - `startTimestamp` to the timestamp of minting.
756             // - `burned` to `false`.
757             // - `nextInitialized` to `quantity == 1`.
758             _packedOwnerships[startTokenId] =
759                 _addressToUint256(to) |
760                 (block.timestamp << BITPOS_START_TIMESTAMP) |
761                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
762 
763             uint256 updatedIndex = startTokenId;
764             uint256 end = updatedIndex + quantity;
765 
766             do {
767                 emit Transfer(address(0), to, updatedIndex++);
768             } while (updatedIndex < end);
769 
770             _currentIndex = updatedIndex;
771         }
772         _afterTokenTransfers(address(0), to, startTokenId, quantity);
773     }
774 
775     /**
776      * @dev Transfers `tokenId` from `from` to `to`.
777      *
778      * Requirements:
779      *
780      * - `to` cannot be the zero address.
781      * - `tokenId` token must be owned by `from`.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _transfer(
786             address from,
787             address to,
788             uint256 tokenId
789             ) private {
790 
791         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
792 
793         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
794 
795         address approvedAddress = _tokenApprovals[tokenId];
796 
797         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
798                 isApprovedForAll(from, _msgSenderERC721A()) ||
799                 approvedAddress == _msgSenderERC721A());
800 
801         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
802 
803 
804         // Clear approvals from the previous owner.
805         if (_addressToUint256(approvedAddress) != 0) {
806             delete _tokenApprovals[tokenId];
807         }
808 
809         // Underflow of the sender's balance is impossible because we check for
810         // ownership above and the recipient's balance can't realistically overflow.
811         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
812         unchecked {
813             // We can directly increment and decrement the balances.
814             --_packedAddressData[from]; // Updates: `balance -= 1`.
815             ++_packedAddressData[to]; // Updates: `balance += 1`.
816 
817             // Updates:
818             // - `address` to the next owner.
819             // - `startTimestamp` to the timestamp of transfering.
820             // - `burned` to `false`.
821             // - `nextInitialized` to `true`.
822             _packedOwnerships[tokenId] =
823                 _addressToUint256(to) |
824                 (block.timestamp << BITPOS_START_TIMESTAMP) |
825                 BITMASK_NEXT_INITIALIZED;
826 
827             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
828             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
829                 uint256 nextTokenId = tokenId + 1;
830                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
831                 if (_packedOwnerships[nextTokenId] == 0) {
832                     // If the next slot is within bounds.
833                     if (nextTokenId != _currentIndex) {
834                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
835                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
836                     }
837                 }
838             }
839         }
840 
841         emit Transfer(from, to, tokenId);
842         _afterTokenTransfers(from, to, tokenId, 1);
843     }
844 
845 
846 
847 
848     /**
849      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
850      * minting.
851      * And also called after one token has been burned.
852      *
853      * startTokenId - the first token id to be transferred
854      * quantity - the amount to be transferred
855      *
856      * Calling conditions:
857      *
858      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
859      * transferred to `to`.
860      * - When `from` is zero, `tokenId` has been minted for `to`.
861      * - When `to` is zero, `tokenId` has been burned by `from`.
862      * - `from` and `to` are never both zero.
863      */
864     function _afterTokenTransfers(
865             address from,
866             address to,
867             uint256 startTokenId,
868             uint256 quantity
869             ) internal virtual {}
870 
871     /**
872      * @dev Returns the message sender (defaults to `msg.sender`).
873      *
874      * If you are writing GSN compatible contracts, you need to override this function.
875      */
876     function _msgSenderERC721A() internal view virtual returns (address) {
877         return msg.sender;
878     }
879 
880     /**
881      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
882      */
883     function _toString(uint256 value) internal pure returns (string memory ptr) {
884         assembly {
885             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
886             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
887             // We will need 1 32-byte word to store the length, 
888             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
889             ptr := add(mload(0x40), 128)
890 
891          // Update the free memory pointer to allocate.
892          mstore(0x40, ptr)
893 
894          // Cache the end of the memory to calculate the length later.
895          let end := ptr
896 
897          // We write the string from the rightmost digit to the leftmost digit.
898          // The following is essentially a do-while loop that also handles the zero case.
899          // Costs a bit more than early returning for the zero case,
900          // but cheaper in terms of deployment and overall runtime costs.
901          for { 
902              // Initialize and perform the first pass without check.
903              let temp := value
904                  // Move the pointer 1 byte leftwards to point to an empty character slot.
905                  ptr := sub(ptr, 1)
906                  // Write the character to the pointer. 48 is the ASCII index of '0'.
907                  mstore8(ptr, add(48, mod(temp, 10)))
908                  temp := div(temp, 10)
909          } temp { 
910              // Keep dividing `temp` until zero.
911         temp := div(temp, 10)
912          } { 
913              // Body of the for loop.
914         ptr := sub(ptr, 1)
915          mstore8(ptr, add(48, mod(temp, 10)))
916          }
917 
918      let length := sub(end, ptr)
919          // Move the pointer 32 bytes leftwards to make room for the length.
920          ptr := sub(ptr, 32)
921          // Store the length.
922          mstore(ptr, length)
923         }
924     }
925 
926     function withdraw() external onlyOwner {
927         uint256 balance = address(this).balance;
928         payable(msg.sender).transfer(balance);
929     }
930 }