1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
3 
4 
5 
6 /**
7  * @dev Interface of ERC721A.
8  */
9 interface IERC721A {
10     /**
11      * The caller must own the token or be an approved operator.
12      */
13     error ApprovalCallerNotOwnerNorApproved();
14 
15     /**
16      * The token does not exist.
17      */
18     error ApprovalQueryForNonexistentToken();
19 
20     /**
21      * The caller cannot approve to their own address.
22      */
23     error ApproveToCaller();
24 
25     /**
26      * Cannot query the balance for the zero address.
27      */
28     error BalanceQueryForZeroAddress();
29 
30     /**
31      * Cannot mint to the zero address.
32      */
33     error MintToZeroAddress();
34 
35     /**
36      * The quantity of tokens minted must be more than zero.
37      */
38     error MintZeroQuantity();
39 
40     /**
41      * The token does not exist.
42      */
43     error OwnerQueryForNonexistentToken();
44 
45     /**
46      * The caller must own the token or be an approved operator.
47      */
48     error TransferCallerNotOwnerNorApproved();
49 
50     /**
51      * The token must be owned by `from`.
52      */
53     error TransferFromIncorrectOwner();
54 
55     /**
56      * Cannot safely transfer to a contract that does not implement the
57      * ERC721Receiver interface.
58      */
59     error TransferToNonERC721ReceiverImplementer();
60 
61     /**
62      * Cannot transfer to the zero address.
63      */
64     error TransferToZeroAddress();
65 
66     /**
67      * The token does not exist.
68      */
69     error URIQueryForNonexistentToken();
70 
71     /**
72      * The `quantity` minted with ERC2309 exceeds the safety limit.
73      */
74     error MintERC2309QuantityExceedsLimit();
75 
76     /**
77      * The `extraData` cannot be set on an unintialized ownership slot.
78      */
79     error OwnershipNotInitializedForExtraData();
80 
81     // =============================================================
82     //                            STRUCTS
83     // =============================================================
84 
85     struct TokenOwnership {
86         // The address of the owner.
87         address addr;
88         // Stores the start time of ownership with minimal overhead for tokenomics.
89         uint64 startTimestamp;
90         // Whether the token has been burned.
91         bool burned;
92         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
93         uint24 extraData;
94     }
95 
96     // =============================================================
97     //                         TOKEN COUNTERS
98     // =============================================================
99 
100     /**
101      * @dev Returns the total number of tokens in existence.
102      * Burned tokens will reduce the count.
103      * To get the total number of tokens minted, please see {_totalMinted}.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     // =============================================================
108     //                            IERC165
109     // =============================================================
110 
111     /**
112      * @dev Returns true if this contract implements the interface defined by
113      * `interfaceId`. See the corresponding
114      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
115      * to learn more about how these ids are created.
116      *
117      * This function call must use less than 30000 gas.
118      */
119     function supportsInterface(bytes4 interfaceId) external view returns (bool);
120 
121     // =============================================================
122     //                            IERC721
123     // =============================================================
124 
125     /**
126      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
132      */
133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables or disables
137      * (`approved`) `operator` to manage all of its assets.
138      */
139     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
140 
141     /**
142      * @dev Returns the number of tokens in `owner`'s account.
143      */
144     function balanceOf(address owner) external view returns (uint256 balance);
145 
146     /**
147      * @dev Returns the owner of the `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function ownerOf(uint256 tokenId) external view returns (address owner);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`,
157      * checking first that contract recipients are aware of the ERC721 protocol
158      * to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be have been allowed to move
166      * this token by either {approve} or {setApprovalForAll}.
167      * - If `to` refers to a smart contract, it must implement
168      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId,
176         bytes calldata data
177     ) external;
178 
179     /**
180      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external;
187 
188     /**
189      * @dev Transfers `tokenId` from `from` to `to`.
190      *
191      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
192      * whenever possible.
193      *
194      * Requirements:
195      *
196      * - `from` cannot be the zero address.
197      * - `to` cannot be the zero address.
198      * - `tokenId` token must be owned by `from`.
199      * - If the caller is not `from`, it must be approved to move this token
200      * by either {approve} or {setApprovalForAll}.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external;
209 
210     /**
211      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
212      * The approval is cleared when the token is transferred.
213      *
214      * Only a single account can be approved at a time, so approving the
215      * zero address clears previous approvals.
216      *
217      * Requirements:
218      *
219      * - The caller must own the token or be an approved operator.
220      * - `tokenId` must exist.
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address to, uint256 tokenId) external;
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom}
229      * for any token owned by the caller.
230      *
231      * Requirements:
232      *
233      * - The `operator` cannot be the caller.
234      *
235      * Emits an {ApprovalForAll} event.
236      */
237     function setApprovalForAll(address operator, bool _approved) external;
238 
239     /**
240      * @dev Returns the account approved for `tokenId` token.
241      *
242      * Requirements:
243      *
244      * - `tokenId` must exist.
245      */
246     function getApproved(uint256 tokenId) external view returns (address operator);
247 
248     /**
249      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
250      *
251      * See {setApprovalForAll}.
252      */
253     function isApprovedForAll(address owner, address operator) external view returns (bool);
254 
255     // =============================================================
256     //                        IERC721Metadata
257     // =============================================================
258 
259     /**
260      * @dev Returns the token collection name.
261      */
262     function name() external view returns (string memory);
263 
264     /**
265      * @dev Returns the token collection symbol.
266      */
267     function symbol() external view returns (string memory);
268 
269     /**
270      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
271      */
272     function tokenURI(uint256 tokenId) external view returns (string memory);
273 
274     // =============================================================
275     //                           IERC2309
276     // =============================================================
277 
278     /**
279      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
280      * (inclusive) is transferred from `from` to `to`, as defined in the
281      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
282      *
283      * See {_mintERC2309} for more details.
284      */
285     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
286 }
287 
288 contract Capes666 is IERC721A { 
289 
290     address private _owner;
291     modifier onlyOwner() { 
292         require(_owner==msg.sender, "No!"); 
293         _; 
294     }
295 
296     bool public saleIsActive = true;
297     uint256 public constant MAX_SUPPLY = 666;
298     uint256 public constant MAX_PER_WALLET = 1;
299     uint256 public constant COST = 0.0 ether;
300 
301     string private constant _name = "Capes 666";
302     string private constant _symbol = "CAPES666";
303     string private _contractURI = "QmPidorWQJAM747sZmq7rB6YwQudNrw3hE4Ve4KmHRCwmP";
304     string private _baseURI = "QmZE92aK4ky9QhhRzFLPY3wCQrYBcm29QXqoqFrDts6rT8";
305 
306     constructor() {
307         _owner = msg.sender;
308     }
309 
310     function mint(uint256 _amount) external payable{
311         address _caller = _msgSenderERC721A();
312 
313         require(saleIsActive, "NotActive");
314         require(totalSupply() + _amount <= MAX_SUPPLY, "SoldOut");
315         require(_amount + _numberMinted(msg.sender) <= MAX_PER_WALLET, "AccLimit");
316         
317         _safeMint(_caller, _amount);
318     }
319 
320 
321 
322 
323     // Mask of an entry in packed address data.
324     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
325 
326     // The bit position of `numberMinted` in packed address data.
327     uint256 private constant BITPOS_NUMBER_MINTED = 64;
328 
329     // The bit position of `numberBurned` in packed address data.
330     uint256 private constant BITPOS_NUMBER_BURNED = 128;
331 
332     // The bit position of `aux` in packed address data.
333     uint256 private constant BITPOS_AUX = 192;
334 
335     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
336     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
337 
338     // The bit position of `startTimestamp` in packed ownership.
339     uint256 private constant BITPOS_START_TIMESTAMP = 160;
340 
341     // The bit mask of the `burned` bit in packed ownership.
342     uint256 private constant BITMASK_BURNED = 1 << 224;
343 
344     // The bit position of the `nextInitialized` bit in packed ownership.
345     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
346 
347     // The bit mask of the `nextInitialized` bit in packed ownership.
348     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
349 
350     // The tokenId of the next token to be minted.
351     uint256 private _currentIndex = 0;
352 
353     // The number of tokens burned.
354     // uint256 private _burnCounter;
355 
356 
357     // Mapping from token ID to ownership details
358     // An empty struct value does not necessarily mean the token is unowned.
359     // See `_packedOwnershipOf` implementation for details.
360     //
361     // Bits Layout:
362     // - [0..159] `addr`
363     // - [160..223] `startTimestamp`
364     // - [224] `burned`
365     // - [225] `nextInitialized`
366     mapping(uint256 => uint256) private _packedOwnerships;
367 
368     // Mapping owner address to address data.
369     //
370     // Bits Layout:
371     // - [0..63] `balance`
372     // - [64..127] `numberMinted`
373     // - [128..191] `numberBurned`
374     // - [192..255] `aux`
375     mapping(address => uint256) private _packedAddressData;
376 
377     // Mapping from token ID to approved address.
378     mapping(uint256 => address) private _tokenApprovals;
379 
380     // Mapping from owner to operator approvals
381     mapping(address => mapping(address => bool)) private _operatorApprovals;
382 
383 
384     function setSale(bool _saleIsActive) external onlyOwner{
385         saleIsActive = _saleIsActive;
386     }
387 
388     function setBaseURI(string memory _new) external onlyOwner{
389         _baseURI = _new;
390     }
391 
392     function setContractURI(string memory _new) external onlyOwner{
393         _contractURI = _new;
394     }
395    
396 
397 
398 
399 
400     /**
401      * @dev Returns the starting token ID. 
402      * To change the starting token ID, please override this function.
403      */
404     function _startTokenId() internal view virtual returns (uint256) {
405         return 0;
406     }
407 
408     /**
409      * @dev Returns the next token ID to be minted.
410      */
411     function _nextTokenId() internal view returns (uint256) {
412         return _currentIndex;
413     }
414 
415     /**
416      * @dev Returns the total number of tokens in existence.
417      * Burned tokens will reduce the count. 
418      * To get the total number of tokens minted, please see `_totalMinted`.
419      */
420     function totalSupply() public view override returns (uint256) {
421         // Counter underflow is impossible as _burnCounter cannot be incremented
422         // more than `_currentIndex - _startTokenId()` times.
423         unchecked {
424             return _currentIndex - _startTokenId();
425         }
426     }
427 
428     /**
429      * @dev Returns the total amount of tokens minted in the contract.
430      */
431     function _totalMinted() internal view returns (uint256) {
432         // Counter underflow is impossible as _currentIndex does not decrement,
433         // and it is initialized to `_startTokenId()`
434         unchecked {
435             return _currentIndex - _startTokenId();
436         }
437     }
438 
439 
440     /**
441      * @dev See {IERC165-supportsInterface}.
442      */
443     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
444         // The interface IDs are constants representing the first 4 bytes of the XOR of
445         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
446         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
447         return
448             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
449             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
450             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
451     }
452 
453     /**
454      * @dev See {IERC721-balanceOf}.
455      */
456     function balanceOf(address owner) public view override returns (uint256) {
457         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
458         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
459     }
460 
461     /**
462      * Returns the number of tokens minted by `owner`.
463      */
464     function _numberMinted(address owner) internal view returns (uint256) {
465         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
466     }
467 
468 
469 
470     /**
471      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
472      */
473     function _getAux(address owner) internal view returns (uint64) {
474         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
475     }
476 
477     /**
478      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
479      * If there are multiple variables, please pack them into a uint64.
480      */
481     function _setAux(address owner, uint64 aux) internal {
482         uint256 packed = _packedAddressData[owner];
483         uint256 auxCasted;
484         assembly { // Cast aux without masking.
485 auxCasted := aux
486         }
487         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
488         _packedAddressData[owner] = packed;
489     }
490 
491     /**
492      * Returns the packed ownership data of `tokenId`.
493      */
494     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
495         uint256 curr = tokenId;
496 
497         unchecked {
498             if (_startTokenId() <= curr)
499                 if (curr < _currentIndex) {
500                     uint256 packed = _packedOwnerships[curr];
501                     // If not burned.
502                     if (packed & BITMASK_BURNED == 0) {
503                         // Invariant:
504                         // There will always be an ownership that has an address and is not burned
505                         // before an ownership that does not have an address and is not burned.
506                         // Hence, curr will not underflow.
507                         //
508                         // We can directly compare the packed value.
509                         // If the address is zero, packed is zero.
510                         while (packed == 0) {
511                             packed = _packedOwnerships[--curr];
512                         }
513                         return packed;
514                     }
515                 }
516         }
517         revert OwnerQueryForNonexistentToken();
518     }
519 
520     /**
521      * Returns the unpacked `TokenOwnership` struct from `packed`.
522      */
523     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
524         ownership.addr = address(uint160(packed));
525         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
526         ownership.burned = packed & BITMASK_BURNED != 0;
527     }
528 
529     /**
530      * Returns the unpacked `TokenOwnership` struct at `index`.
531      */
532     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
533         return _unpackedOwnership(_packedOwnerships[index]);
534     }
535 
536     /**
537      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
538      */
539     function _initializeOwnershipAt(uint256 index) internal {
540         if (_packedOwnerships[index] == 0) {
541             _packedOwnerships[index] = _packedOwnershipOf(index);
542         }
543     }
544 
545     /**
546      * Gas spent here starts off proportional to the maximum mint batch size.
547      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
548      */
549     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
550         return _unpackedOwnership(_packedOwnershipOf(tokenId));
551     }
552 
553     /**
554      * @dev See {IERC721-ownerOf}.
555      */
556     function ownerOf(uint256 tokenId) public view override returns (address) {
557         return address(uint160(_packedOwnershipOf(tokenId)));
558     }
559 
560     /**
561      * @dev See {IERC721Metadata-name}.
562      */
563     function name() public view virtual override returns (string memory) {
564         return _name;
565     }
566 
567     /**
568      * @dev See {IERC721Metadata-symbol}.
569      */
570     function symbol() public view virtual override returns (string memory) {
571         return _symbol;
572     }
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
589 result := value
590         }
591     }
592 
593     /**
594      * @dev Casts the boolean to uint256 without branching.
595      */
596     function _boolToUint256(bool value) private pure returns (uint256 result) {
597         assembly {
598 result := value
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
694     function _safeMint(address to, uint256 quantity) internal {
695         _safeMint(to, quantity, '');
696     }
697 
698     /**
699      * @dev Safely mints `quantity` tokens and transfers them to `to`.
700      *
701      * Requirements:
702      *
703      * - If `to` refers to a smart contract, it must implement
704      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
705      * - `quantity` must be greater than 0.
706      *
707      * Emits a {Transfer} event.
708      */
709     function _safeMint(
710             address to,
711             uint256 quantity,
712             bytes memory _data
713             ) internal {
714         uint256 startTokenId = _currentIndex;
715         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
716         if (quantity == 0) revert MintZeroQuantity();
717 
718 
719         // Overflows are incredibly unrealistic.
720         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
721         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
722         unchecked {
723             // Updates:
724             // - `balance += quantity`.
725             // - `numberMinted += quantity`.
726             //
727             // We can directly add to the balance and number minted.
728             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
729 
730             // Updates:
731             // - `address` to the owner.
732             // - `startTimestamp` to the timestamp of minting.
733             // - `burned` to `false`.
734             // - `nextInitialized` to `quantity == 1`.
735             _packedOwnerships[startTokenId] =
736                 _addressToUint256(to) |
737                 (block.timestamp << BITPOS_START_TIMESTAMP) |
738                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
739 
740             uint256 updatedIndex = startTokenId;
741             uint256 end = updatedIndex + quantity;
742 
743             if (to.code.length != 0) {
744                 do {
745                     emit Transfer(address(0), to, updatedIndex);
746                 } while (updatedIndex < end);
747                 // Reentrancy protection
748                 if (_currentIndex != startTokenId) revert();
749             } else {
750                 do {
751                     emit Transfer(address(0), to, updatedIndex++);
752                 } while (updatedIndex < end);
753             }
754             _currentIndex = updatedIndex;
755         }
756         _afterTokenTransfers(address(0), to, startTokenId, quantity);
757     }
758 
759     /**
760      * @dev Mints `quantity` tokens and transfers them to `to`.
761      *
762      * Requirements:
763      *
764      * - `to` cannot be the zero address.
765      * - `quantity` must be greater than 0.
766      *
767      * Emits a {Transfer} event.
768      */
769     function _mint(address to, uint256 quantity) internal {
770         uint256 startTokenId = _currentIndex;
771         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
772         if (quantity == 0) revert MintZeroQuantity();
773 
774 
775         // Overflows are incredibly unrealistic.
776         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
777         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
778         unchecked {
779             // Updates:
780             // - `balance += quantity`.
781             // - `numberMinted += quantity`.
782             //
783             // We can directly add to the balance and number minted.
784             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
785 
786             // Updates:
787             // - `address` to the owner.
788             // - `startTimestamp` to the timestamp of minting.
789             // - `burned` to `false`.
790             // - `nextInitialized` to `quantity == 1`.
791             _packedOwnerships[startTokenId] =
792                 _addressToUint256(to) |
793                 (block.timestamp << BITPOS_START_TIMESTAMP) |
794                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
795 
796             uint256 updatedIndex = startTokenId;
797             uint256 end = updatedIndex + quantity;
798 
799             do {
800                 emit Transfer(address(0), to, updatedIndex++);
801             } while (updatedIndex < end);
802 
803             _currentIndex = updatedIndex;
804         }
805         _afterTokenTransfers(address(0), to, startTokenId, quantity);
806     }
807 
808     /**
809      * @dev Transfers `tokenId` from `from` to `to`.
810      *
811      * Requirements:
812      *
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _transfer(
819             address from,
820             address to,
821             uint256 tokenId
822             ) private {
823 
824         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
825 
826         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
827 
828         address approvedAddress = _tokenApprovals[tokenId];
829 
830         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
831                 isApprovedForAll(from, _msgSenderERC721A()) ||
832                 approvedAddress == _msgSenderERC721A());
833 
834         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
835 
836         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
837 
838 
839         // Clear approvals from the previous owner.
840         if (_addressToUint256(approvedAddress) != 0) {
841             delete _tokenApprovals[tokenId];
842         }
843 
844         // Underflow of the sender's balance is impossible because we check for
845         // ownership above and the recipient's balance can't realistically overflow.
846         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
847         unchecked {
848             // We can directly increment and decrement the balances.
849             --_packedAddressData[from]; // Updates: `balance -= 1`.
850             ++_packedAddressData[to]; // Updates: `balance += 1`.
851 
852             // Updates:
853             // - `address` to the next owner.
854             // - `startTimestamp` to the timestamp of transfering.
855             // - `burned` to `false`.
856             // - `nextInitialized` to `true`.
857             _packedOwnerships[tokenId] =
858                 _addressToUint256(to) |
859                 (block.timestamp << BITPOS_START_TIMESTAMP) |
860                 BITMASK_NEXT_INITIALIZED;
861 
862             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
863             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
864                 uint256 nextTokenId = tokenId + 1;
865                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
866                 if (_packedOwnerships[nextTokenId] == 0) {
867                     // If the next slot is within bounds.
868                     if (nextTokenId != _currentIndex) {
869                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
870                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
871                     }
872                 }
873             }
874         }
875 
876         emit Transfer(from, to, tokenId);
877         _afterTokenTransfers(from, to, tokenId, 1);
878     }
879 
880 
881 
882 
883     /**
884      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
885      * minting.
886      * And also called after one token has been burned.
887      *
888      * startTokenId - the first token id to be transferred
889      * quantity - the amount to be transferred
890      *
891      * Calling conditions:
892      *
893      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
894      * transferred to `to`.
895      * - When `from` is zero, `tokenId` has been minted for `to`.
896      * - When `to` is zero, `tokenId` has been burned by `from`.
897      * - `from` and `to` are never both zero.
898      */
899     function _afterTokenTransfers(
900             address from,
901             address to,
902             uint256 startTokenId,
903             uint256 quantity
904             ) internal virtual {}
905 
906     /**
907      * @dev Returns the message sender (defaults to `msg.sender`).
908      *
909      * If you are writing GSN compatible contracts, you need to override this function.
910      */
911     function _msgSenderERC721A() internal view virtual returns (address) {
912         return msg.sender;
913     }
914 
915     /**
916      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
917      */
918     function _toString(uint256 value) internal pure returns (string memory ptr) {
919         assembly {
920             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
921             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
922             // We will need 1 32-byte word to store the length, 
923             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
924 ptr := add(mload(0x40), 128)
925 
926          // Update the free memory pointer to allocate.
927          mstore(0x40, ptr)
928 
929          // Cache the end of the memory to calculate the length later.
930          let end := ptr
931 
932          // We write the string from the rightmost digit to the leftmost digit.
933          // The following is essentially a do-while loop that also handles the zero case.
934          // Costs a bit more than early returning for the zero case,
935          // but cheaper in terms of deployment and overall runtime costs.
936          for { 
937              // Initialize and perform the first pass without check.
938              let temp := value
939                  // Move the pointer 1 byte leftwards to point to an empty character slot.
940                  ptr := sub(ptr, 1)
941                  // Write the character to the pointer. 48 is the ASCII index of '0'.
942                  mstore8(ptr, add(48, mod(temp, 10)))
943                  temp := div(temp, 10)
944          } temp { 
945              // Keep dividing `temp` until zero.
946         temp := div(temp, 10)
947          } { 
948              // Body of the for loop.
949         ptr := sub(ptr, 1)
950          mstore8(ptr, add(48, mod(temp, 10)))
951          }
952 
953      let length := sub(end, ptr)
954          // Move the pointer 32 bytes leftwards to make room for the length.
955          ptr := sub(ptr, 32)
956          // Store the length.
957          mstore(ptr, length)
958         }
959     }
960 
961     
962 
963     function withdraw() external onlyOwner {
964         uint256 balance = address(this).balance;
965         payable(msg.sender).transfer(balance);
966     }
967 }