1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /*
5                                        _..._                   
6    .-''-.                           .-'_..._''.                
7   //'` `\|                        .' .'      '.\    .          
8  '/'    '|                       / .'             .'|          
9 |'      '|                      . '             .'  |          
10 ||     /||                 __   | |            <    |          
11  \'. .'/||     _    _   .:--.'. | |             |   | ____     
12   `--'` ||    | '  / | / |   \ |. '             |   | \ .'     
13         ||   .' | .' | `" __ | | \ '.          .|   |/  .      
14         || />/  | /  |  .'.''| |  '. `._____.-'/|    /\  \     
15         ||//|   `'.  | / /   | |_   `-.______ / |   |  \  \    
16         |'/ '   .'|  '/\ \._,\ '/            `  '    \  \  \   
17         |/   `-'  `--'  `--'  `"               '------'  '---' 
18 */
19 
20 /*
21  * @dev Interface of ERC721A.
22  */
23 interface IERC721A {
24     /**
25      * The caller must own the token or be an approved operator.
26      */
27     error ApprovalCallerNotOwnerNorApproved();
28 
29     /**
30      * The token does not exist.
31      */
32     error ApprovalQueryForNonexistentToken();
33 
34     /**
35      * The caller cannot approve to their own address.
36      */
37     error ApproveToCaller();
38 
39     /**
40      * Cannot query the balance for the zero address.
41      */
42     error BalanceQueryForZeroAddress();
43 
44     /**
45      * Cannot mint to the zero address.
46      */
47     error MintToZeroAddress();
48 
49     /**
50      * The quantity of tokens minted must be more than zero.
51      */
52     error MintZeroQuantity();
53 
54     /**
55      * The token does not exist.
56      */
57     error OwnerQueryForNonexistentToken();
58 
59     /**
60      * The caller must own the token or be an approved operator.
61      */
62     error TransferCallerNotOwnerNorApproved();
63 
64     /**
65      * The token must be owned by `from`.
66      */
67     error TransferFromIncorrectOwner();
68 
69     /**
70      * Cannot safely transfer to a contract that does not implement the
71      * ERC721Receiver interface.
72      */
73     error TransferToNonERC721ReceiverImplementer();
74 
75     /**
76      * Cannot transfer to the zero address.
77      */
78     error TransferToZeroAddress();
79 
80     /**
81      * The token does not exist.
82      */
83     error URIQueryForNonexistentToken();
84 
85     /**
86      * The `quantity` minted with ERC2309 exceeds the safety limit.
87      */
88     error MintERC2309QuantityExceedsLimit();
89 
90     /**
91      * The `extraData` cannot be set on an unintialized ownership slot.
92      */
93     error OwnershipNotInitializedForExtraData();
94 
95     // =============================================================
96     //                            STRUCTS
97     // =============================================================
98 
99     struct TokenOwnership {
100         // The address of the owner.
101         address addr;
102         // Stores the start time of ownership with minimal overhead for tokenomics.
103         uint64 startTimestamp;
104         // Whether the token has been burned.
105         bool burned;
106         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
107         uint24 extraData;
108     }
109 
110     // =============================================================
111     //                         TOKEN COUNTERS
112     // =============================================================
113 
114     /**
115      * @dev Returns the total number of tokens in existence.
116      * Burned tokens will reduce the count.
117      * To get the total number of tokens minted, please see {_totalMinted}.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     // =============================================================
122     //                            IERC165
123     // =============================================================
124 
125     /**
126      * @dev Returns true if this contract implements the interface defined by
127      * `interfaceId`. See the corresponding
128      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
129      * to learn more about how these ids are created.
130      *
131      * This function call must use less than 30000 gas.
132      */
133     function supportsInterface(bytes4 interfaceId) external view returns (bool);
134 
135     // =============================================================
136     //                            IERC721
137     // =============================================================
138 
139     /**
140      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
141      */
142     event Transfer(
143         address indexed from,
144         address indexed to,
145         uint256 indexed tokenId
146     );
147 
148     /**
149      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
150      */
151     event Approval(
152         address indexed owner,
153         address indexed approved,
154         uint256 indexed tokenId
155     );
156 
157     /**
158      * @dev Emitted when `owner` enables or disables
159      * (`approved`) `operator` to manage all of its assets.
160      */
161     event ApprovalForAll(
162         address indexed owner,
163         address indexed operator,
164         bool approved
165     );
166 
167     /**
168      * @dev Returns the number of tokens in `owner`'s account.
169      */
170     function balanceOf(address owner) external view returns (uint256 balance);
171 
172     /**
173      * @dev Returns the owner of the `tokenId` token.
174      *
175      * Requirements:
176      *
177      * - `tokenId` must exist.
178      */
179     function ownerOf(uint256 tokenId) external view returns (address owner);
180 
181     /**
182      * @dev Safely transfers `tokenId` token from `from` to `to`,
183      * checking first that contract recipients are aware of the ERC721 protocol
184      * to prevent tokens from being forever locked.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must exist and be owned by `from`.
191      * - If the caller is not `from`, it must be have been allowed to move
192      * this token by either {approve} or {setApprovalForAll}.
193      * - If `to` refers to a smart contract, it must implement
194      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
195      *
196      * Emits a {Transfer} event.
197      */
198     function safeTransferFrom(
199         address from,
200         address to,
201         uint256 tokenId,
202         bytes calldata data
203     ) external;
204 
205     /**
206      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
207      */
208     function safeTransferFrom(
209         address from,
210         address to,
211         uint256 tokenId
212     ) external;
213 
214     /**
215      * @dev Transfers `tokenId` from `from` to `to`.
216      *
217      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
218      * whenever possible.
219      *
220      * Requirements:
221      *
222      * - `from` cannot be the zero address.
223      * - `to` cannot be the zero address.
224      * - `tokenId` token must be owned by `from`.
225      * - If the caller is not `from`, it must be approved to move this token
226      * by either {approve} or {setApprovalForAll}.
227      *
228      * Emits a {Transfer} event.
229      */
230     function transferFrom(
231         address from,
232         address to,
233         uint256 tokenId
234     ) external;
235 
236     /**
237      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
238      * The approval is cleared when the token is transferred.
239      *
240      * Only a single account can be approved at a time, so approving the
241      * zero address clears previous approvals.
242      *
243      * Requirements:
244      *
245      * - The caller must own the token or be an approved operator.
246      * - `tokenId` must exist.
247      *
248      * Emits an {Approval} event.
249      */
250     function approve(address to, uint256 tokenId) external;
251 
252     /**
253      * @dev Approve or remove `operator` as an operator for the caller.
254      * Operators can call {transferFrom} or {safeTransferFrom}
255      * for any token owned by the caller.
256      *
257      * Requirements:
258      *
259      * - The `operator` cannot be the caller.
260      *
261      * Emits an {ApprovalForAll} event.
262      */
263     function setApprovalForAll(address operator, bool _approved) external;
264 
265     /**
266      * @dev Returns the account approved for `tokenId` token.
267      *
268      * Requirements:
269      *
270      * - `tokenId` must exist.
271      */
272     function getApproved(uint256 tokenId)
273         external
274         view
275         returns (address operator);
276 
277     /**
278      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
279      *
280      * See {setApprovalForAll}.
281      */
282     function isApprovedForAll(address owner, address operator)
283         external
284         view
285         returns (bool);
286 
287     // =============================================================
288     //                        IERC721Metadata
289     // =============================================================
290 
291     /**
292      * @dev Returns the token collection name.
293      */
294     function name() external view returns (string memory);
295 
296     /**
297      * @dev Returns the token collection symbol.
298      */
299     function symbol() external view returns (string memory);
300 
301     /**
302      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
303      */
304     function tokenURI(uint256 tokenId) external view returns (string memory);
305 
306     // =============================================================
307     //                           IERC2309
308     // =============================================================
309 
310     /**
311      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
312      * (inclusive) is transferred from `from` to `to`, as defined in the
313      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
314      *
315      * See {_mintERC2309} for more details.
316      */
317     event ConsecutiveTransfer(
318         uint256 indexed fromTokenId,
319         uint256 toTokenId,
320         address indexed from,
321         address indexed to
322     );
323 }
324 
325 contract PixelQuacklings is IERC721A {
326     address private _owner;
327 
328     function owner() public view returns (address) {
329         return _owner;
330     }
331 
332     modifier onlyOwner() {
333         require(_owner == msg.sender);
334         _;
335     }
336 
337     uint256 public constant MAX_SUPPLY = 1337;
338     uint256 public MAX_FREE = 337;
339     uint256 public MAX_FREE_PER_WALLET = 1;
340     uint256 public COST = 0.002 ether;
341 
342     string private constant _name = "PixelQuacklings";
343     string private constant _symbol = "PQCK";
344     string private _baseURI = "bafybeifya4ntmfxd5tyiifc5r33wbw6psmuj4fzacwe5nmnqwsapfuli5i";
345 
346     constructor() {
347         _owner = msg.sender;
348     }
349 
350     function mint(uint256 amount) external payable {
351         address _caller = _msgSenderERC721A();
352 
353         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
354         require(amount * COST <= msg.value, "Value to Low");
355         require(amount <= 5, "max 5 per TX");
356 
357         _mint(_caller, amount);
358     }
359 
360     function freeMint() external {
361         address _caller = _msgSenderERC721A();
362         uint256 amount = 1;
363 
364         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
365         require(
366             amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET,
367             "Max per Wallet"
368         );
369 
370         _mint(_caller, amount);
371     }
372 
373     // Mask of an entry in packed address data.
374     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
375 
376     // The bit position of `numberMinted` in packed address data.
377     uint256 private constant BITPOS_NUMBER_MINTED = 64;
378 
379     // The bit position of `numberBurned` in packed address data.
380     uint256 private constant BITPOS_NUMBER_BURNED = 128;
381 
382     // The bit position of `aux` in packed address data.
383     uint256 private constant BITPOS_AUX = 192;
384 
385     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
386     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
387 
388     // The bit position of `startTimestamp` in packed ownership.
389     uint256 private constant BITPOS_START_TIMESTAMP = 160;
390 
391     // The bit mask of the `burned` bit in packed ownership.
392     uint256 private constant BITMASK_BURNED = 1 << 224;
393 
394     // The bit position of the `nextInitialized` bit in packed ownership.
395     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
396 
397     // The bit mask of the `nextInitialized` bit in packed ownership.
398     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
399 
400     // The tokenId of the next token to be minted.
401     uint256 private _currentIndex = 0;
402 
403     // The number of tokens burned.
404     // uint256 private _burnCounter;
405 
406     // Mapping from token ID to ownership details
407     // An empty struct value does not necessarily mean the token is unowned.
408     // See `_packedOwnershipOf` implementation for details.
409     //
410     // Bits Layout:
411     // - [0..159] `addr`
412     // - [160..223] `startTimestamp`
413     // - [224] `burned`
414     // - [225] `nextInitialized`
415     mapping(uint256 => uint256) private _packedOwnerships;
416 
417     // Mapping owner address to address data.
418     //
419     // Bits Layout:
420     // - [0..63] `balance`
421     // - [64..127] `numberMinted`
422     // - [128..191] `numberBurned`
423     // - [192..255] `aux`
424     mapping(address => uint256) private _packedAddressData;
425 
426     // Mapping from token ID to approved address.
427     mapping(uint256 => address) private _tokenApprovals;
428 
429     // Mapping from owner to operator approvals
430     mapping(address => mapping(address => bool)) private _operatorApprovals;
431 
432     function setData(string memory _base) external onlyOwner {
433         _baseURI = _base;
434     }
435 
436     function setConfig(
437         uint256 _MAX_FREE_PER_WALLET,
438         uint256 _COST,
439         uint256 _MAX_FREE
440     ) external onlyOwner {
441         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
442         COST = _COST;
443         MAX_FREE = _MAX_FREE;
444     }
445 
446     /**
447      * @dev Returns the starting token ID.
448      * To change the starting token ID, please override this function.
449      */
450     function _startTokenId() internal view virtual returns (uint256) {
451         return 0;
452     }
453 
454     /**
455      * @dev Returns the next token ID to be minted.
456      */
457     function _nextTokenId() internal view returns (uint256) {
458         return _currentIndex;
459     }
460 
461     /**
462      * @dev Returns the total number of tokens in existence.
463      * Burned tokens will reduce the count.
464      * To get the total number of tokens minted, please see `_totalMinted`.
465      */
466     function totalSupply() public view override returns (uint256) {
467         // Counter underflow is impossible as _burnCounter cannot be incremented
468         // more than `_currentIndex - _startTokenId()` times.
469         unchecked {
470             return _currentIndex - _startTokenId();
471         }
472     }
473 
474     /**
475      * @dev Returns the total amount of tokens minted in the contract.
476      */
477     function _totalMinted() internal view returns (uint256) {
478         // Counter underflow is impossible as _currentIndex does not decrement,
479         // and it is initialized to `_startTokenId()`
480         unchecked {
481             return _currentIndex - _startTokenId();
482         }
483     }
484 
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId)
489         public
490         view
491         virtual
492         override
493         returns (bool)
494     {
495         // The interface IDs are constants representing the first 4 bytes of the XOR of
496         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
497         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
498         return
499             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
500             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
501             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
502     }
503 
504     /**
505      * @dev See {IERC721-balanceOf}.
506      */
507     function balanceOf(address owner) public view override returns (uint256) {
508         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
509         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
510     }
511 
512     /**
513      * Returns the number of tokens minted by `owner`.
514      */
515     function _numberMinted(address owner) internal view returns (uint256) {
516         return
517             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
518             BITMASK_ADDRESS_DATA_ENTRY;
519     }
520 
521     /**
522      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
523      */
524     function _getAux(address owner) internal view returns (uint64) {
525         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
526     }
527 
528     /**
529      * Returns the packed ownership data of `tokenId`.
530      */
531     function _packedOwnershipOf(uint256 tokenId)
532         private
533         view
534         returns (uint256)
535     {
536         uint256 curr = tokenId;
537 
538         unchecked {
539             if (_startTokenId() <= curr)
540                 if (curr < _currentIndex) {
541                     uint256 packed = _packedOwnerships[curr];
542                     // If not burned.
543                     if (packed & BITMASK_BURNED == 0) {
544                         // Invariant:
545                         // There will always be an ownership that has an address and is not burned
546                         // before an ownership that does not have an address and is not burned.
547                         // Hence, curr will not underflow.
548                         //
549                         // We can directly compare the packed value.
550                         // If the address is zero, packed is zero.
551                         while (packed == 0) {
552                             packed = _packedOwnerships[--curr];
553                         }
554                         return packed;
555                     }
556                 }
557         }
558         revert OwnerQueryForNonexistentToken();
559     }
560 
561     /**
562      * Returns the unpacked `TokenOwnership` struct from `packed`.
563      */
564     function _unpackedOwnership(uint256 packed)
565         private
566         pure
567         returns (TokenOwnership memory ownership)
568     {
569         ownership.addr = address(uint160(packed));
570         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
571         ownership.burned = packed & BITMASK_BURNED != 0;
572     }
573 
574     /**
575      * Returns the unpacked `TokenOwnership` struct at `index`.
576      */
577     function _ownershipAt(uint256 index)
578         internal
579         view
580         returns (TokenOwnership memory)
581     {
582         return _unpackedOwnership(_packedOwnerships[index]);
583     }
584 
585     /**
586      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
587      */
588     function _initializeOwnershipAt(uint256 index) internal {
589         if (_packedOwnerships[index] == 0) {
590             _packedOwnerships[index] = _packedOwnershipOf(index);
591         }
592     }
593 
594     /**
595      * Gas spent here starts off proportional to the maximum mint batch size.
596      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
597      */
598     function _ownershipOf(uint256 tokenId)
599         internal
600         view
601         returns (TokenOwnership memory)
602     {
603         return _unpackedOwnership(_packedOwnershipOf(tokenId));
604     }
605 
606     /**
607      * @dev See {IERC721-ownerOf}.
608      */
609     function ownerOf(uint256 tokenId) public view override returns (address) {
610         return address(uint160(_packedOwnershipOf(tokenId)));
611     }
612 
613     /**
614      * @dev See {IERC721Metadata-name}.
615      */
616     function name() public view virtual override returns (string memory) {
617         return _name;
618     }
619 
620     /**
621      * @dev See {IERC721Metadata-symbol}.
622      */
623     function symbol() public view virtual override returns (string memory) {
624         return _symbol;
625     }
626 
627     function tokenURI(uint256 tokenId)
628         public
629         view
630         virtual
631         override
632         returns (string memory)
633     {
634         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
635         string memory baseURI = _baseURI;
636         return
637             bytes(baseURI).length != 0
638                 ? string(
639                     abi.encodePacked(
640                         "ipfs://",
641                         baseURI,
642                         "/",
643                         _toString(tokenId),
644                         ".json"
645                     )
646                 )
647                 : "";
648     }
649 
650     /**
651      * @dev Casts the address to uint256 without masking.
652      */
653     function _addressToUint256(address value)
654         private
655         pure
656         returns (uint256 result)
657     {
658         assembly {
659             result := value
660         }
661     }
662 
663     /**
664      * @dev Casts the boolean to uint256 without branching.
665      */
666     function _boolToUint256(bool value) private pure returns (uint256 result) {
667         assembly {
668             result := value
669         }
670     }
671 
672     /**
673      * @dev See {IERC721-approve}.
674      */
675     function approve(address to, uint256 tokenId) public override {
676         address owner = address(uint160(_packedOwnershipOf(tokenId)));
677         if (to == owner) revert();
678 
679         if (_msgSenderERC721A() != owner)
680             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
681                 revert ApprovalCallerNotOwnerNorApproved();
682             }
683 
684         _tokenApprovals[tokenId] = to;
685         emit Approval(owner, to, tokenId);
686     }
687 
688     /**
689      * @dev See {IERC721-getApproved}.
690      */
691     function getApproved(uint256 tokenId)
692         public
693         view
694         override
695         returns (address)
696     {
697         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
698 
699         return _tokenApprovals[tokenId];
700     }
701 
702     /**
703      * @dev See {IERC721-setApprovalForAll}.
704      */
705     function setApprovalForAll(address operator, bool approved)
706         public
707         virtual
708         override
709     {
710         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
711 
712         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
713         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
714     }
715 
716     /**
717      * @dev See {IERC721-isApprovedForAll}.
718      */
719     function isApprovedForAll(address owner, address operator)
720         public
721         view
722         virtual
723         override
724         returns (bool)
725     {
726         return _operatorApprovals[owner][operator];
727     }
728 
729     /**
730      * @dev See {IERC721-transferFrom}.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         _transfer(from, to, tokenId);
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         safeTransferFrom(from, to, tokenId, "");
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) public virtual override {
760         _transfer(from, to, tokenId);
761     }
762 
763     /**
764      * @dev Returns whether `tokenId` exists.
765      *
766      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
767      *
768      * Tokens start existing when they are minted (`_mint`),
769      */
770     function _exists(uint256 tokenId) internal view returns (bool) {
771         return _startTokenId() <= tokenId && tokenId < _currentIndex;
772     }
773 
774     /**
775      * @dev Mints `quantity` tokens and transfers them to `to`.
776      *
777      * Requirements:
778      *
779      * - `to` cannot be the zero address.
780      * - `quantity` must be greater than 0.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _mint(address to, uint256 quantity) internal {
785         uint256 startTokenId = _currentIndex;
786         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
787         if (quantity == 0) revert MintZeroQuantity();
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
798             _packedAddressData[to] +=
799                 quantity *
800                 ((1 << BITPOS_NUMBER_MINTED) | 1);
801 
802             // Updates:
803             // - `address` to the owner.
804             // - `startTimestamp` to the timestamp of minting.
805             // - `burned` to `false`.
806             // - `nextInitialized` to `quantity == 1`.
807             _packedOwnerships[startTokenId] =
808                 _addressToUint256(to) |
809                 (block.timestamp << BITPOS_START_TIMESTAMP) |
810                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
811 
812             uint256 updatedIndex = startTokenId;
813             uint256 end = updatedIndex + quantity;
814 
815             do {
816                 emit Transfer(address(0), to, updatedIndex++);
817             } while (updatedIndex < end);
818 
819             _currentIndex = updatedIndex;
820         }
821         _afterTokenTransfers(address(0), to, startTokenId, quantity);
822     }
823 
824     /**
825      * @dev Transfers `tokenId` from `from` to `to`.
826      *
827      * Requirements:
828      *
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must be owned by `from`.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _transfer(
835         address from,
836         address to,
837         uint256 tokenId
838     ) private {
839         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
840 
841         if (address(uint160(prevOwnershipPacked)) != from)
842             revert TransferFromIncorrectOwner();
843 
844         address approvedAddress = _tokenApprovals[tokenId];
845 
846         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
847             isApprovedForAll(from, _msgSenderERC721A()) ||
848             approvedAddress == _msgSenderERC721A());
849 
850         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
851 
852         // Clear approvals from the previous owner.
853         if (_addressToUint256(approvedAddress) != 0) {
854             delete _tokenApprovals[tokenId];
855         }
856 
857         // Underflow of the sender's balance is impossible because we check for
858         // ownership above and the recipient's balance can't realistically overflow.
859         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
860         unchecked {
861             // We can directly increment and decrement the balances.
862             --_packedAddressData[from]; // Updates: `balance -= 1`.
863             ++_packedAddressData[to]; // Updates: `balance += 1`.
864 
865             // Updates:
866             // - `address` to the next owner.
867             // - `startTimestamp` to the timestamp of transfering.
868             // - `burned` to `false`.
869             // - `nextInitialized` to `true`.
870             _packedOwnerships[tokenId] =
871                 _addressToUint256(to) |
872                 (block.timestamp << BITPOS_START_TIMESTAMP) |
873                 BITMASK_NEXT_INITIALIZED;
874 
875             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
876             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
877                 uint256 nextTokenId = tokenId + 1;
878                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
879                 if (_packedOwnerships[nextTokenId] == 0) {
880                     // If the next slot is within bounds.
881                     if (nextTokenId != _currentIndex) {
882                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
883                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
884                     }
885                 }
886             }
887         }
888 
889         emit Transfer(from, to, tokenId);
890         _afterTokenTransfers(from, to, tokenId, 1);
891     }
892 
893     /**
894      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
895      * minting.
896      * And also called after one token has been burned.
897      *
898      * startTokenId - the first token id to be transferred
899      * quantity - the amount to be transferred
900      *
901      * Calling conditions:
902      *
903      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
904      * transferred to `to`.
905      * - When `from` is zero, `tokenId` has been minted for `to`.
906      * - When `to` is zero, `tokenId` has been burned by `from`.
907      * - `from` and `to` are never both zero.
908      */
909     function _afterTokenTransfers(
910         address from,
911         address to,
912         uint256 startTokenId,
913         uint256 quantity
914     ) internal virtual {}
915 
916     /**
917      * @dev Returns the message sender (defaults to `msg.sender`).
918      *
919      * If you are writing GSN compatible contracts, you need to override this function.
920      */
921     function _msgSenderERC721A() internal view virtual returns (address) {
922         return msg.sender;
923     }
924 
925     /**
926      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
927      */
928     function _toString(uint256 value)
929         internal
930         pure
931         returns (string memory ptr)
932     {
933         assembly {
934             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
935             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
936             // We will need 1 32-byte word to store the length,
937             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
938             ptr := add(mload(0x40), 128)
939 
940             // Update the free memory pointer to allocate.
941             mstore(0x40, ptr)
942 
943             // Cache the end of the memory to calculate the length later.
944             let end := ptr
945 
946             // We write the string from the rightmost digit to the leftmost digit.
947             // The following is essentially a do-while loop that also handles the zero case.
948             // Costs a bit more than early returning for the zero case,
949             // but cheaper in terms of deployment and overall runtime costs.
950             for {
951                 // Initialize and perform the first pass without check.
952                 let temp := value
953                 // Move the pointer 1 byte leftwards to point to an empty character slot.
954                 ptr := sub(ptr, 1)
955                 // Write the character to the pointer. 48 is the ASCII index of '0'.
956                 mstore8(ptr, add(48, mod(temp, 10)))
957                 temp := div(temp, 10)
958             } temp {
959                 // Keep dividing `temp` until zero.
960                 temp := div(temp, 10)
961             } {
962                 // Body of the for loop.
963                 ptr := sub(ptr, 1)
964                 mstore8(ptr, add(48, mod(temp, 10)))
965             }
966 
967             let length := sub(end, ptr)
968             // Move the pointer 32 bytes leftwards to make room for the length.
969             ptr := sub(ptr, 32)
970             // Store the length.
971             mstore(ptr, length)
972         }
973     }
974 
975     function withdraw() external onlyOwner {
976         uint256 balance = address(this).balance;
977         payable(msg.sender).transfer(balance);
978     }
979 }