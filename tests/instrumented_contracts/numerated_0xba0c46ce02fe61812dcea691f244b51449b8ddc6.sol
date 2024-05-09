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
287 contract NOT_AI is IERC721A { 
288 
289     address private _owner;
290     modifier onlyOwner() { 
291         require(_owner==msg.sender, "No!"); 
292         _; 
293     }
294 
295     bool public saleIsActive = true;
296 
297     uint256 public constant MAX_SUPPLY = 550;
298     uint256 public constant MAX_FREE_PER_WALLET = 1;
299     uint256 public constant COST = 0.01 ether;
300 
301     string private constant _name = "NOT_AI";
302     string private constant _symbol = "NOT_AI";
303     string private _contractURI = "";
304     string private _baseURI = "";
305 
306     constructor() {
307         _owner = msg.sender;
308     }
309 
310     function freeMint() external{
311         uint256 amount = MAX_FREE_PER_WALLET;
312         address _caller = _msgSenderERC721A();
313 
314         require(saleIsActive, "NotActive");
315         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
316         require(amount + _numberMinted(msg.sender) <= MAX_FREE_PER_WALLET, "AccLimit");
317 
318         _safeMint(_caller, amount);
319     }
320 
321     function mint() external payable{
322         uint256 amount = MAX_FREE_PER_WALLET;
323         address _caller = _msgSenderERC721A();
324 
325         require(saleIsActive, "NotActive");
326         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
327         require(amount * COST >= msg.value, "AccLimit");
328 
329         _safeMint(_caller, amount);
330     }
331 
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
394     function setSale(bool _saleIsActive) external onlyOwner{
395         saleIsActive = _saleIsActive;
396     }
397 
398     function setBaseURI(string memory _new) external onlyOwner{
399         _baseURI = _new;
400     }
401 
402     function setContractURI(string memory _new) external onlyOwner{
403         _contractURI = _new;
404     }
405    
406 
407     /**
408      * @dev Returns the starting token ID. 
409      * To change the starting token ID, please override this function.
410      */
411     function _startTokenId() internal view virtual returns (uint256) {
412         return 0;
413     }
414 
415     /**
416      * @dev Returns the next token ID to be minted.
417      */
418     function _nextTokenId() internal view returns (uint256) {
419         return _currentIndex;
420     }
421 
422     /**
423      * @dev Returns the total number of tokens in existence.
424      * Burned tokens will reduce the count. 
425      * To get the total number of tokens minted, please see `_totalMinted`.
426      */
427     function totalSupply() public view override returns (uint256) {
428         // Counter underflow is impossible as _burnCounter cannot be incremented
429         // more than `_currentIndex - _startTokenId()` times.
430         unchecked {
431             return _currentIndex - _startTokenId();
432         }
433     }
434 
435     /**
436      * @dev Returns the total amount of tokens minted in the contract.
437      */
438     function _totalMinted() internal view returns (uint256) {
439         // Counter underflow is impossible as _currentIndex does not decrement,
440         // and it is initialized to `_startTokenId()`
441         unchecked {
442             return _currentIndex - _startTokenId();
443         }
444     }
445 
446 
447     /**
448      * @dev See {IERC165-supportsInterface}.
449      */
450     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
451         // The interface IDs are constants representing the first 4 bytes of the XOR of
452         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
453         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
454         return
455             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
456             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
457             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
458     }
459 
460     /**
461      * @dev See {IERC721-balanceOf}.
462      */
463     function balanceOf(address owner) public view override returns (uint256) {
464         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
465         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
466     }
467 
468     /**
469      * Returns the number of tokens minted by `owner`.
470      */
471     function _numberMinted(address owner) internal view returns (uint256) {
472         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
473     }
474 
475 
476 
477     /**
478      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
479      */
480     function _getAux(address owner) internal view returns (uint64) {
481         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
482     }
483 
484     /**
485      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
486      * If there are multiple variables, please pack them into a uint64.
487      */
488     function _setAux(address owner, uint64 aux) internal {
489         uint256 packed = _packedAddressData[owner];
490         uint256 auxCasted;
491         assembly { // Cast aux without masking.
492             auxCasted := aux
493         }
494         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
495         _packedAddressData[owner] = packed;
496     }
497 
498     /**
499      * Returns the packed ownership data of `tokenId`.
500      */
501     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
502         uint256 curr = tokenId;
503 
504         unchecked {
505             if (_startTokenId() <= curr)
506                 if (curr < _currentIndex) {
507                     uint256 packed = _packedOwnerships[curr];
508                     // If not burned.
509                     if (packed & BITMASK_BURNED == 0) {
510                         // Invariant:
511                         // There will always be an ownership that has an address and is not burned
512                         // before an ownership that does not have an address and is not burned.
513                         // Hence, curr will not underflow.
514                         //
515                         // We can directly compare the packed value.
516                         // If the address is zero, packed is zero.
517                         while (packed == 0) {
518                             packed = _packedOwnerships[--curr];
519                         }
520                         return packed;
521                     }
522                 }
523         }
524         revert OwnerQueryForNonexistentToken();
525     }
526 
527     /**
528      * Returns the unpacked `TokenOwnership` struct from `packed`.
529      */
530     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
531         ownership.addr = address(uint160(packed));
532         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
533         ownership.burned = packed & BITMASK_BURNED != 0;
534     }
535 
536     /**
537      * Returns the unpacked `TokenOwnership` struct at `index`.
538      */
539     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
540         return _unpackedOwnership(_packedOwnerships[index]);
541     }
542 
543     /**
544      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
545      */
546     function _initializeOwnershipAt(uint256 index) internal {
547         if (_packedOwnerships[index] == 0) {
548             _packedOwnerships[index] = _packedOwnershipOf(index);
549         }
550     }
551 
552     /**
553      * Gas spent here starts off proportional to the maximum mint batch size.
554      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
555      */
556     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
557         return _unpackedOwnership(_packedOwnershipOf(tokenId));
558     }
559 
560     /**
561      * @dev See {IERC721-ownerOf}.
562      */
563     function ownerOf(uint256 tokenId) public view override returns (address) {
564         return address(uint160(_packedOwnershipOf(tokenId)));
565     }
566 
567     /**
568      * @dev See {IERC721Metadata-name}.
569      */
570     function name() public view virtual override returns (string memory) {
571         return _name;
572     }
573 
574     /**
575      * @dev See {IERC721Metadata-symbol}.
576      */
577     function symbol() public view virtual override returns (string memory) {
578         return _symbol;
579     }
580 
581     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
582         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
583         string memory baseURI = _baseURI;
584         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
585     }
586 
587     function contractURI() public view returns (string memory) {
588         return string(abi.encodePacked("ipfs://", _contractURI));
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
698     /**
699      * @dev Equivalent to `_safeMint(to, quantity, '')`.
700      */
701     function _safeMint(address to, uint256 quantity) internal {
702         _safeMint(to, quantity, '');
703     }
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
716     function _safeMint(
717             address to,
718             uint256 quantity,
719             bytes memory _data
720             ) internal {
721         uint256 startTokenId = _currentIndex;
722         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
723         if (quantity == 0) revert MintZeroQuantity();
724 
725 
726         // Overflows are incredibly unrealistic.
727         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
728         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
729         unchecked {
730             // Updates:
731             // - `balance += quantity`.
732             // - `numberMinted += quantity`.
733             //
734             // We can directly add to the balance and number minted.
735             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
736 
737             // Updates:
738             // - `address` to the owner.
739             // - `startTimestamp` to the timestamp of minting.
740             // - `burned` to `false`.
741             // - `nextInitialized` to `quantity == 1`.
742             _packedOwnerships[startTokenId] =
743                 _addressToUint256(to) |
744                 (block.timestamp << BITPOS_START_TIMESTAMP) |
745                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
746 
747             uint256 updatedIndex = startTokenId;
748             uint256 end = updatedIndex + quantity;
749 
750             if (to.code.length != 0) {
751                 do {
752                     emit Transfer(address(0), to, updatedIndex);
753                 } while (updatedIndex < end);
754                 // Reentrancy protection
755                 if (_currentIndex != startTokenId) revert();
756             } else {
757                 do {
758                     emit Transfer(address(0), to, updatedIndex++);
759                 } while (updatedIndex < end);
760             }
761             _currentIndex = updatedIndex;
762         }
763         _afterTokenTransfers(address(0), to, startTokenId, quantity);
764     }
765 
766     /**
767      * @dev Mints `quantity` tokens and transfers them to `to`.
768      *
769      * Requirements:
770      *
771      * - `to` cannot be the zero address.
772      * - `quantity` must be greater than 0.
773      *
774      * Emits a {Transfer} event.
775      */
776     function _mint(address to, uint256 quantity) internal {
777         uint256 startTokenId = _currentIndex;
778         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
779         if (quantity == 0) revert MintZeroQuantity();
780 
781 
782         // Overflows are incredibly unrealistic.
783         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
784         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
785         unchecked {
786             // Updates:
787             // - `balance += quantity`.
788             // - `numberMinted += quantity`.
789             //
790             // We can directly add to the balance and number minted.
791             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
792 
793             // Updates:
794             // - `address` to the owner.
795             // - `startTimestamp` to the timestamp of minting.
796             // - `burned` to `false`.
797             // - `nextInitialized` to `quantity == 1`.
798             _packedOwnerships[startTokenId] =
799                 _addressToUint256(to) |
800                 (block.timestamp << BITPOS_START_TIMESTAMP) |
801                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
802 
803             uint256 updatedIndex = startTokenId;
804             uint256 end = updatedIndex + quantity;
805 
806             do {
807                 emit Transfer(address(0), to, updatedIndex++);
808             } while (updatedIndex < end);
809 
810             _currentIndex = updatedIndex;
811         }
812         _afterTokenTransfers(address(0), to, startTokenId, quantity);
813     }
814 
815     /**
816      * @dev Transfers `tokenId` from `from` to `to`.
817      *
818      * Requirements:
819      *
820      * - `to` cannot be the zero address.
821      * - `tokenId` token must be owned by `from`.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _transfer(
826             address from,
827             address to,
828             uint256 tokenId
829             ) private {
830 
831         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
832 
833         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
834 
835         address approvedAddress = _tokenApprovals[tokenId];
836 
837         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
838                 isApprovedForAll(from, _msgSenderERC721A()) ||
839                 approvedAddress == _msgSenderERC721A());
840 
841         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
842 
843         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
844 
845 
846         // Clear approvals from the previous owner.
847         if (_addressToUint256(approvedAddress) != 0) {
848             delete _tokenApprovals[tokenId];
849         }
850 
851         // Underflow of the sender's balance is impossible because we check for
852         // ownership above and the recipient's balance can't realistically overflow.
853         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
854         unchecked {
855             // We can directly increment and decrement the balances.
856             --_packedAddressData[from]; // Updates: `balance -= 1`.
857             ++_packedAddressData[to]; // Updates: `balance += 1`.
858 
859             // Updates:
860             // - `address` to the next owner.
861             // - `startTimestamp` to the timestamp of transfering.
862             // - `burned` to `false`.
863             // - `nextInitialized` to `true`.
864             _packedOwnerships[tokenId] =
865                 _addressToUint256(to) |
866                 (block.timestamp << BITPOS_START_TIMESTAMP) |
867                 BITMASK_NEXT_INITIALIZED;
868 
869             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
870             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
871                 uint256 nextTokenId = tokenId + 1;
872                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
873                 if (_packedOwnerships[nextTokenId] == 0) {
874                     // If the next slot is within bounds.
875                     if (nextTokenId != _currentIndex) {
876                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
877                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
878                     }
879                 }
880             }
881         }
882 
883         emit Transfer(from, to, tokenId);
884         _afterTokenTransfers(from, to, tokenId, 1);
885     }
886 
887 
888 
889 
890     /**
891      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
892      * minting.
893      * And also called after one token has been burned.
894      *
895      * startTokenId - the first token id to be transferred
896      * quantity - the amount to be transferred
897      *
898      * Calling conditions:
899      *
900      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
901      * transferred to `to`.
902      * - When `from` is zero, `tokenId` has been minted for `to`.
903      * - When `to` is zero, `tokenId` has been burned by `from`.
904      * - `from` and `to` are never both zero.
905      */
906     function _afterTokenTransfers(
907             address from,
908             address to,
909             uint256 startTokenId,
910             uint256 quantity
911             ) internal virtual {}
912 
913     /**
914      * @dev Returns the message sender (defaults to `msg.sender`).
915      *
916      * If you are writing GSN compatible contracts, you need to override this function.
917      */
918     function _msgSenderERC721A() internal view virtual returns (address) {
919         return msg.sender;
920     }
921 
922     /**
923      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
924      */
925     function _toString(uint256 value) internal pure returns (string memory ptr) {
926         assembly {
927             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
928             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
929             // We will need 1 32-byte word to store the length, 
930             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
931             ptr := add(mload(0x40), 128)
932 
933          // Update the free memory pointer to allocate.
934          mstore(0x40, ptr)
935 
936          // Cache the end of the memory to calculate the length later.
937          let end := ptr
938 
939          // We write the string from the rightmost digit to the leftmost digit.
940          // The following is essentially a do-while loop that also handles the zero case.
941          // Costs a bit more than early returning for the zero case,
942          // but cheaper in terms of deployment and overall runtime costs.
943          for { 
944              // Initialize and perform the first pass without check.
945              let temp := value
946                  // Move the pointer 1 byte leftwards to point to an empty character slot.
947                  ptr := sub(ptr, 1)
948                  // Write the character to the pointer. 48 is the ASCII index of '0'.
949                  mstore8(ptr, add(48, mod(temp, 10)))
950                  temp := div(temp, 10)
951          } temp { 
952              // Keep dividing `temp` until zero.
953         temp := div(temp, 10)
954          } { 
955              // Body of the for loop.
956         ptr := sub(ptr, 1)
957          mstore8(ptr, add(48, mod(temp, 10)))
958          }
959 
960      let length := sub(end, ptr)
961          // Move the pointer 32 bytes leftwards to make room for the length.
962          ptr := sub(ptr, 32)
963          // Store the length.
964          mstore(ptr, length)
965         }
966     }
967 
968     
969 
970     function withdraw() external onlyOwner {
971         uint256 balance = address(this).balance;
972         payable(msg.sender).transfer(balance);
973     }
974 }