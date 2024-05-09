1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
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
287 contract Freak is IERC721A { 
288 
289     address private _owner;
290     modifier onlyOwner() { 
291         require(_owner==msg.sender, "No!"); 
292         _; 
293     }
294 
295     uint256 public constant MAX_PER_WALLET = 10;
296     uint256 public constant COST = 0.002 ether;
297     uint256 public MAX_SUPPLY = 745;
298     uint256 public MAX_FREE_PER_WALLET = 1;
299 
300     string private constant _name = "Freak";
301     string private constant _symbol = "FREAK";
302     string private _contractURI = "QmXrHsTuCRkDHhwuRfu1UT2M77r7ckRNTKatfYj4ZEnEyc";
303     string private _baseURI = "QmNTcJwxmANDMYS2xfHKTjE2f9SfNmyx9wkmVst7QAYitw";
304 
305     constructor() {
306         _owner = msg.sender;
307     }
308 
309     function mint(uint256 amount) external payable{
310         address _caller = _msgSenderERC721A();
311 
312         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
313         require(amount + _numberMinted(msg.sender) <= MAX_PER_WALLET+MAX_FREE_PER_WALLET, "AccLimit");
314         require(msg.value >= COST*amount, "Price");
315 
316         _mint(_caller, amount);
317     }
318 
319     function freeMint() external{
320         uint256 amount = 1;
321         address _caller = _msgSenderERC721A();
322         require(totalSupply() + amount <= MAX_SUPPLY-66, "SoldOut");
323         require(amount + _numberMinted(msg.sender) <= MAX_FREE_PER_WALLET, "AccLimit");
324 
325         _mint(_caller, amount);
326     }
327 
328 
329     // Mask of an entry in packed address data.
330     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
331 
332     // The bit position of `numberMinted` in packed address data.
333     uint256 private constant BITPOS_NUMBER_MINTED = 64;
334 
335     // The bit position of `numberBurned` in packed address data.
336     uint256 private constant BITPOS_NUMBER_BURNED = 128;
337 
338     // The bit position of `aux` in packed address data.
339     uint256 private constant BITPOS_AUX = 192;
340 
341     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
342     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
343 
344     // The bit position of `startTimestamp` in packed ownership.
345     uint256 private constant BITPOS_START_TIMESTAMP = 160;
346 
347     // The bit mask of the `burned` bit in packed ownership.
348     uint256 private constant BITMASK_BURNED = 1 << 224;
349 
350     // The bit position of the `nextInitialized` bit in packed ownership.
351     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
352 
353     // The bit mask of the `nextInitialized` bit in packed ownership.
354     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
355 
356     // The tokenId of the next token to be minted.
357     uint256 private _currentIndex = 0;
358 
359     // The number of tokens burned.
360     // uint256 private _burnCounter;
361 
362 
363     // Mapping from token ID to ownership details
364     // An empty struct value does not necessarily mean the token is unowned.
365     // See `_packedOwnershipOf` implementation for details.
366     //
367     // Bits Layout:
368     // - [0..159] `addr`
369     // - [160..223] `startTimestamp`
370     // - [224] `burned`
371     // - [225] `nextInitialized`
372     mapping(uint256 => uint256) private _packedOwnerships;
373 
374     // Mapping owner address to address data.
375     //
376     // Bits Layout:
377     // - [0..63] `balance`
378     // - [64..127] `numberMinted`
379     // - [128..191] `numberBurned`
380     // - [192..255] `aux`
381     mapping(address => uint256) private _packedAddressData;
382 
383     // Mapping from token ID to approved address.
384     mapping(uint256 => address) private _tokenApprovals;
385 
386     // Mapping from owner to operator approvals
387     mapping(address => mapping(address => bool)) private _operatorApprovals;
388 
389 
390     function setBaseURI(string memory _new) external onlyOwner{
391         _baseURI = _new;
392     }
393 
394     function setContractURI(string memory _new) external onlyOwner{
395         _contractURI = _new;
396     }
397    
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
573     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
574         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
575         string memory baseURI = _baseURI;
576         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
577     }
578 
579     function contractURI() public view returns (string memory) {
580         return string(abi.encodePacked("ipfs://", _contractURI));
581     }
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
964     function teamMint(uint256 _amount) external onlyOwner{
965         _mint(msg.sender, _amount);
966     }
967 
968     function withdraw() external onlyOwner {
969         uint256 balance = address(this).balance;
970         payable(msg.sender).transfer(balance);
971     }
972 }