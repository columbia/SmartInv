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
288 contract GaGa is IERC721A { 
289 
290     address private immutable _owner;
291 
292     modifier onlyOwner() { 
293         require(_owner==msg.sender);
294         _; 
295     }
296 
297     uint256 public constant MAX_SUPPLY = 890;
298     uint256 public constant MAX_FREE_PER_WALLET = 1;
299     uint256 public COST = 0.001 ether;
300 
301     string private constant _name = "Gary Gansters #GAGA";
302     string private constant _symbol = "GAGA";
303     string private _contractURI = "";
304     string private _baseURI = "";
305 
306 
307     constructor() {
308         _owner = msg.sender;
309     }
310 
311     function mint(uint256 amount) external payable{
312         address _caller = _msgSenderERC721A();
313 
314         require(totalSupply() + amount <= MAX_SUPPLY, "Sold Out");
315         require(amount*COST <= msg.value, "Value to Low");
316 
317         _mint(_caller, amount);
318     }
319 
320     function freeMint() external{
321         address _caller = _msgSenderERC721A();
322         uint256 amount = MAX_FREE_PER_WALLET;
323 
324         require(totalSupply() + amount <= MAX_SUPPLY, "Freemint Sold Out");
325         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "AccLimit");
326 
327         _mint(_caller, amount);
328     }
329 
330     // Mask of an entry in packed address data.
331     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
332 
333     // The bit position of `numberMinted` in packed address data.
334     uint256 private constant BITPOS_NUMBER_MINTED = 64;
335 
336     // The bit position of `numberBurned` in packed address data.
337     uint256 private constant BITPOS_NUMBER_BURNED = 128;
338 
339     // The bit position of `aux` in packed address data.
340     uint256 private constant BITPOS_AUX = 192;
341 
342     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
343     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
344 
345     // The bit position of `startTimestamp` in packed ownership.
346     uint256 private constant BITPOS_START_TIMESTAMP = 160;
347 
348     // The bit mask of the `burned` bit in packed ownership.
349     uint256 private constant BITMASK_BURNED = 1 << 224;
350 
351     // The bit position of the `nextInitialized` bit in packed ownership.
352     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
353 
354     // The bit mask of the `nextInitialized` bit in packed ownership.
355     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
356 
357     // The tokenId of the next token to be minted.
358     uint256 private _currentIndex = 0;
359 
360     // The number of tokens burned.
361     // uint256 private _burnCounter;
362 
363 
364     // Mapping from token ID to ownership details
365     // An empty struct value does not necessarily mean the token is unowned.
366     // See `_packedOwnershipOf` implementation for details.
367     //
368     // Bits Layout:
369     // - [0..159] `addr`
370     // - [160..223] `startTimestamp`
371     // - [224] `burned`
372     // - [225] `nextInitialized`
373     mapping(uint256 => uint256) private _packedOwnerships;
374 
375     // Mapping owner address to address data.
376     //
377     // Bits Layout:
378     // - [0..63] `balance`
379     // - [64..127] `numberMinted`
380     // - [128..191] `numberBurned`
381     // - [192..255] `aux`
382     mapping(address => uint256) private _packedAddressData;
383 
384     // Mapping from token ID to approved address.
385     mapping(uint256 => address) private _tokenApprovals;
386 
387     // Mapping from owner to operator approvals
388     mapping(address => mapping(address => bool)) private _operatorApprovals;
389 
390 
391     function setData(string memory _contract, string memory _base) external onlyOwner{
392         _contractURI = _contract;
393         _baseURI = _base;
394     }
395 
396     function setCost(uint256 _new) external onlyOwner{
397         COST = _new;
398     }
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
485             auxCasted := aux
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
574     
575     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
576         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
577         string memory baseURI = _baseURI;
578         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
579     }
580 
581     function contractURI() public view returns (string memory) {
582         return string(abi.encodePacked("ipfs://", _contractURI));
583     }
584 
585     /**
586      * @dev Casts the address to uint256 without masking.
587      */
588     function _addressToUint256(address value) private pure returns (uint256 result) {
589         assembly {
590             result := value
591         }
592     }
593 
594     /**
595      * @dev Casts the boolean to uint256 without branching.
596      */
597     function _boolToUint256(bool value) private pure returns (uint256 result) {
598         assembly {
599             result := value
600         }
601     }
602 
603     /**
604      * @dev See {IERC721-approve}.
605      */
606     function approve(address to, uint256 tokenId) public override {
607         address owner = address(uint160(_packedOwnershipOf(tokenId)));
608         if (to == owner) revert();
609 
610         if (_msgSenderERC721A() != owner)
611             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
612                 revert ApprovalCallerNotOwnerNorApproved();
613             }
614 
615         _tokenApprovals[tokenId] = to;
616         emit Approval(owner, to, tokenId);
617     }
618 
619     /**
620      * @dev See {IERC721-getApproved}.
621      */
622     function getApproved(uint256 tokenId) public view override returns (address) {
623         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
624 
625         return _tokenApprovals[tokenId];
626     }
627 
628     /**
629      * @dev See {IERC721-setApprovalForAll}.
630      */
631     function setApprovalForAll(address operator, bool approved) public virtual override {
632         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
633 
634         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
635         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
636     }
637 
638     /**
639      * @dev See {IERC721-isApprovedForAll}.
640      */
641     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
642         return _operatorApprovals[owner][operator];
643     }
644 
645     /**
646      * @dev See {IERC721-transferFrom}.
647      */
648     function transferFrom(
649             address from,
650             address to,
651             uint256 tokenId
652             ) public virtual override {
653         _transfer(from, to, tokenId);
654     }
655 
656     /**
657      * @dev See {IERC721-safeTransferFrom}.
658      */
659     function safeTransferFrom(
660             address from,
661             address to,
662             uint256 tokenId
663             ) public virtual override {
664         safeTransferFrom(from, to, tokenId, '');
665     }
666 
667     /**
668      * @dev See {IERC721-safeTransferFrom}.
669      */
670     function safeTransferFrom(
671             address from,
672             address to,
673             uint256 tokenId,
674             bytes memory _data
675             ) public virtual override {
676         _transfer(from, to, tokenId);
677     }
678 
679     /**
680      * @dev Returns whether `tokenId` exists.
681      *
682      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
683      *
684      * Tokens start existing when they are minted (`_mint`),
685      */
686     function _exists(uint256 tokenId) internal view returns (bool) {
687         return
688             _startTokenId() <= tokenId &&
689             tokenId < _currentIndex;
690     }
691 
692     /**
693      * @dev Mints `quantity` tokens and transfers them to `to`.
694      *
695      * Requirements:
696      *
697      * - `to` cannot be the zero address.
698      * - `quantity` must be greater than 0.
699      *
700      * Emits a {Transfer} event.
701      */
702     function _mint(address to, uint256 quantity) internal {
703         uint256 startTokenId = _currentIndex;
704         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
705         if (quantity == 0) revert MintZeroQuantity();
706 
707 
708         // Overflows are incredibly unrealistic.
709         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
710         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
711         unchecked {
712             // Updates:
713             // - `balance += quantity`.
714             // - `numberMinted += quantity`.
715             //
716             // We can directly add to the balance and number minted.
717             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
718 
719             // Updates:
720             // - `address` to the owner.
721             // - `startTimestamp` to the timestamp of minting.
722             // - `burned` to `false`.
723             // - `nextInitialized` to `quantity == 1`.
724             _packedOwnerships[startTokenId] =
725                 _addressToUint256(to) |
726                 (block.timestamp << BITPOS_START_TIMESTAMP) |
727                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
728 
729             uint256 updatedIndex = startTokenId;
730             uint256 end = updatedIndex + quantity;
731 
732             do {
733                 emit Transfer(address(0), to, updatedIndex++);
734             } while (updatedIndex < end);
735 
736             _currentIndex = updatedIndex;
737         }
738         _afterTokenTransfers(address(0), to, startTokenId, quantity);
739     }
740 
741     /**
742      * @dev Transfers `tokenId` from `from` to `to`.
743      *
744      * Requirements:
745      *
746      * - `to` cannot be the zero address.
747      * - `tokenId` token must be owned by `from`.
748      *
749      * Emits a {Transfer} event.
750      */
751     function _transfer(
752             address from,
753             address to,
754             uint256 tokenId
755             ) private {
756 
757         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
758 
759         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
760 
761         address approvedAddress = _tokenApprovals[tokenId];
762 
763         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
764                 isApprovedForAll(from, _msgSenderERC721A()) ||
765                 approvedAddress == _msgSenderERC721A());
766 
767         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
768 
769         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
770 
771 
772         // Clear approvals from the previous owner.
773         if (_addressToUint256(approvedAddress) != 0) {
774             delete _tokenApprovals[tokenId];
775         }
776 
777         // Underflow of the sender's balance is impossible because we check for
778         // ownership above and the recipient's balance can't realistically overflow.
779         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
780         unchecked {
781             // We can directly increment and decrement the balances.
782             --_packedAddressData[from]; // Updates: `balance -= 1`.
783             ++_packedAddressData[to]; // Updates: `balance += 1`.
784 
785             // Updates:
786             // - `address` to the next owner.
787             // - `startTimestamp` to the timestamp of transfering.
788             // - `burned` to `false`.
789             // - `nextInitialized` to `true`.
790             _packedOwnerships[tokenId] =
791                 _addressToUint256(to) |
792                 (block.timestamp << BITPOS_START_TIMESTAMP) |
793                 BITMASK_NEXT_INITIALIZED;
794 
795             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
796             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
797                 uint256 nextTokenId = tokenId + 1;
798                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
799                 if (_packedOwnerships[nextTokenId] == 0) {
800                     // If the next slot is within bounds.
801                     if (nextTokenId != _currentIndex) {
802                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
803                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
804                     }
805                 }
806             }
807         }
808 
809         emit Transfer(from, to, tokenId);
810         _afterTokenTransfers(from, to, tokenId, 1);
811     }
812 
813 
814 
815 
816     /**
817      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
818      * minting.
819      * And also called after one token has been burned.
820      *
821      * startTokenId - the first token id to be transferred
822      * quantity - the amount to be transferred
823      *
824      * Calling conditions:
825      *
826      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
827      * transferred to `to`.
828      * - When `from` is zero, `tokenId` has been minted for `to`.
829      * - When `to` is zero, `tokenId` has been burned by `from`.
830      * - `from` and `to` are never both zero.
831      */
832     function _afterTokenTransfers(
833             address from,
834             address to,
835             uint256 startTokenId,
836             uint256 quantity
837             ) internal virtual {}
838 
839     /**
840      * @dev Returns the message sender (defaults to `msg.sender`).
841      *
842      * If you are writing GSN compatible contracts, you need to override this function.
843      */
844     function _msgSenderERC721A() internal view virtual returns (address) {
845         return msg.sender;
846     }
847 
848     /**
849      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
850      */
851     function _toString(uint256 value) internal pure returns (string memory ptr) {
852         assembly {
853             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
854             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
855             // We will need 1 32-byte word to store the length, 
856             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
857             ptr := add(mload(0x40), 128)
858 
859          // Update the free memory pointer to allocate.
860          mstore(0x40, ptr)
861 
862          // Cache the end of the memory to calculate the length later.
863          let end := ptr
864 
865          // We write the string from the rightmost digit to the leftmost digit.
866          // The following is essentially a do-while loop that also handles the zero case.
867          // Costs a bit more than early returning for the zero case,
868          // but cheaper in terms of deployment and overall runtime costs.
869          for { 
870              // Initialize and perform the first pass without check.
871              let temp := value
872                  // Move the pointer 1 byte leftwards to point to an empty character slot.
873                  ptr := sub(ptr, 1)
874                  // Write the character to the pointer. 48 is the ASCII index of '0'.
875                  mstore8(ptr, add(48, mod(temp, 10)))
876                  temp := div(temp, 10)
877          } temp { 
878              // Keep dividing `temp` until zero.
879         temp := div(temp, 10)
880          } { 
881              // Body of the for loop.
882         ptr := sub(ptr, 1)
883          mstore8(ptr, add(48, mod(temp, 10)))
884          }
885 
886      let length := sub(end, ptr)
887          // Move the pointer 32 bytes leftwards to make room for the length.
888          ptr := sub(ptr, 32)
889          // Store the length.
890          mstore(ptr, length)
891         }
892     }
893 
894     function withdraw() external onlyOwner {
895         uint256 balance = address(this).balance;
896         payable(msg.sender).transfer(balance);
897     }
898 }