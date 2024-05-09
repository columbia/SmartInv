1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.20;
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
288 contract Bitflow is IERC721A { 
289 
290     address private _owner;
291     function owner() public view returns(address){
292         return _owner;
293     }
294 
295     uint256 public constant MAX_SUPPLY = 512;
296     uint256 public MAX_FREE_PER_WALLET = 1;
297     uint256 public COST = 0.002 ether;
298 
299     string private constant _name = "Bitflow";
300     string private constant _symbol = "BITFLOW";
301     string private _baseURI = "";
302 
303     constructor() {
304         _owner = msg.sender;
305     }
306 
307     function mint(uint256 amount) external payable{
308         address _caller = _msgSenderERC721A();
309 
310         require(totalSupply() + amount <= MAX_SUPPLY, "Sold Out");
311         require(amount*COST <= msg.value, "Value to Low");
312         require(amount <= 10, "Max 5 per TX");
313 
314         _mint(_caller, amount);
315     }
316 
317     function freeMint() external nob{
318         address _caller = _msgSenderERC721A();
319         uint256 amount = MAX_FREE_PER_WALLET;
320 
321         require(totalSupply() + amount <= MAX_FREE, "Freemint Sold Out");
322         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "Max per Wallet");
323 
324         _mint(_caller, amount);
325     }
326 
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
390     function setData(string memory _base) external onlyOwner{
391         _baseURI = _base;
392     }
393 
394     uint256 public MAX_FREE = 378;
395     function setConfig(uint256 _COST, uint256 _MAX_FREE, uint256 _MAX_FREE_PER_WALLET) external onlyOwner{
396         MAX_FREE = _MAX_FREE;
397         COST = _COST;
398         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
399     }
400 
401     /**
402      * @dev Returns the starting token ID. 
403      * To change the starting token ID, please override this function.
404      */
405     function _startTokenId() internal view virtual returns (uint256) {
406         return 0;
407     }
408 
409     /**
410      * @dev Returns the next token ID to be minted.
411      */
412     function _nextTokenId() internal view returns (uint256) {
413         return _currentIndex;
414     }
415 
416     /**
417      * @dev Returns the total number of tokens in existence.
418      * Burned tokens will reduce the count. 
419      * To get the total number of tokens minted, please see `_totalMinted`.
420      */
421     function totalSupply() public view override returns (uint256) {
422         // Counter underflow is impossible as _burnCounter cannot be incremented
423         // more than `_currentIndex - _startTokenId()` times.
424         unchecked {
425             return _currentIndex - _startTokenId();
426         }
427     }
428 
429     /**
430      * @dev Returns the total amount of tokens minted in the contract.
431      */
432     function _totalMinted() internal view returns (uint256) {
433         // Counter underflow is impossible as _currentIndex does not decrement,
434         // and it is initialized to `_startTokenId()`
435         unchecked {
436             return _currentIndex - _startTokenId();
437         }
438     }
439 
440 
441     /**
442      * @dev See {IERC165-supportsInterface}.
443      */
444     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
445         // The interface IDs are constants representing the first 4 bytes of the XOR of
446         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
447         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
448         return
449             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
450             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
451             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
452     }
453 
454     /**
455      * @dev See {IERC721-balanceOf}.
456      */
457     function balanceOf(address owner) public view override returns (uint256) {
458         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
459         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
460     }
461 
462     /**
463      * Returns the number of tokens minted by `owner`.
464      */
465     function _numberMinted(address owner) internal view returns (uint256) {
466         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
467     }
468 
469 
470 
471     /**
472      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
473      */
474     function _getAux(address owner) internal view returns (uint64) {
475         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
476     }
477 
478     /**
479      * Returns the packed ownership data of `tokenId`.
480      */
481     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
482         uint256 curr = tokenId;
483 
484         unchecked {
485             if (_startTokenId() <= curr)
486                 if (curr < _currentIndex) {
487                     uint256 packed = _packedOwnerships[curr];
488                     // If not burned.
489                     if (packed & BITMASK_BURNED == 0) {
490                         // Invariant:
491                         // There will always be an ownership that has an address and is not burned
492                         // before an ownership that does not have an address and is not burned.
493                         // Hence, curr will not underflow.
494                         //
495                         // We can directly compare the packed value.
496                         // If the address is zero, packed is zero.
497                         while (packed == 0) {
498                             packed = _packedOwnerships[--curr];
499                         }
500                         return packed;
501                     }
502                 }
503         }
504         revert OwnerQueryForNonexistentToken();
505     }
506 
507     /**
508      * Returns the unpacked `TokenOwnership` struct from `packed`.
509      */
510     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
511         ownership.addr = address(uint160(packed));
512         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
513         ownership.burned = packed & BITMASK_BURNED != 0;
514     }
515 
516     /**
517      * Returns the unpacked `TokenOwnership` struct at `index`.
518      */
519     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
520         return _unpackedOwnership(_packedOwnerships[index]);
521     }
522 
523     /**
524      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
525      */
526     function _initializeOwnershipAt(uint256 index) internal {
527         if (_packedOwnerships[index] == 0) {
528             _packedOwnerships[index] = _packedOwnershipOf(index);
529         }
530     }
531 
532     /**
533      * Gas spent here starts off proportional to the maximum mint batch size.
534      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
535      */
536     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
537         return _unpackedOwnership(_packedOwnershipOf(tokenId));
538     }
539 
540     /**
541      * @dev See {IERC721-ownerOf}.
542      */
543     function ownerOf(uint256 tokenId) public view override returns (address) {
544         return address(uint160(_packedOwnershipOf(tokenId)));
545     }
546 
547     /**
548      * @dev See {IERC721Metadata-name}.
549      */
550     function name() public view virtual override returns (string memory) {
551         return _name;
552     }
553 
554     /**
555      * @dev See {IERC721Metadata-symbol}.
556      */
557     function symbol() public view virtual override returns (string memory) {
558         return _symbol;
559     }
560 
561     
562     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
563         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
564         string memory baseURI = _baseURI;
565         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
566     }
567 
568     /**
569      * @dev Casts the address to uint256 without masking.
570      */
571     function _addressToUint256(address value) private pure returns (uint256 result) {
572         assembly {
573             result := value
574         }
575     }
576 
577     /**
578      * @dev Casts the boolean to uint256 without branching.
579      */
580     function _boolToUint256(bool value) private pure returns (uint256 result) {
581         assembly {
582             result := value
583         }
584     }
585 
586     /**
587      * @dev See {IERC721-approve}.
588      */
589     function approve(address to, uint256 tokenId) public override {
590         address owner = address(uint160(_packedOwnershipOf(tokenId)));
591         if (to == owner) revert();
592 
593         if (_msgSenderERC721A() != owner)
594             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
595                 revert ApprovalCallerNotOwnerNorApproved();
596             }
597 
598         _tokenApprovals[tokenId] = to;
599         emit Approval(owner, to, tokenId);
600     }
601 
602     /**
603      * @dev See {IERC721-getApproved}.
604      */
605     function getApproved(uint256 tokenId) public view override returns (address) {
606         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
607 
608         return _tokenApprovals[tokenId];
609     }
610 
611     /**
612      * @dev See {IERC721-setApprovalForAll}.
613      */
614     function setApprovalForAll(address operator, bool approved) public virtual override {
615         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
616 
617         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
618         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
619     }
620 
621     /**
622      * @dev See {IERC721-isApprovedForAll}.
623      */
624     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
625         return _operatorApprovals[owner][operator];
626     }
627 
628     /**
629      * @dev See {IERC721-transferFrom}.
630      */
631     function transferFrom(
632             address from,
633             address to,
634             uint256 tokenId
635             ) public virtual override {
636         _transfer(from, to, tokenId);
637     }
638 
639     /**
640      * @dev See {IERC721-safeTransferFrom}.
641      */
642     function safeTransferFrom(
643             address from,
644             address to,
645             uint256 tokenId
646             ) public virtual override {
647         safeTransferFrom(from, to, tokenId, '');
648     }
649 
650     /**
651      * @dev See {IERC721-safeTransferFrom}.
652      */
653     function safeTransferFrom(
654             address from,
655             address to,
656             uint256 tokenId,
657             bytes memory _data
658             ) public virtual override {
659         _transfer(from, to, tokenId);
660     }
661 
662     /**
663      * @dev Returns whether `tokenId` exists.
664      *
665      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
666      *
667      * Tokens start existing when they are minted (`_mint`),
668      */
669     function _exists(uint256 tokenId) internal view returns (bool) {
670         return
671             _startTokenId() <= tokenId &&
672             tokenId < _currentIndex;
673     }
674 
675   
676 
677     /**
678      * @dev Mints `quantity` tokens and transfers them to `to`.
679      *
680      * Requirements:
681      *
682      * - `to` cannot be the zero address.
683      * - `quantity` must be greater than 0.
684      *
685      * Emits a {Transfer} event.
686      */
687     function _mint(address to, uint256 quantity) internal {
688         uint256 startTokenId = _currentIndex;
689         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
690         if (quantity == 0) revert MintZeroQuantity();
691 
692 
693         // Overflows are incredibly unrealistic.
694         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
695         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
696         unchecked {
697             // Updates:
698             // - `balance += quantity`.
699             // - `numberMinted += quantity`.
700             //
701             // We can directly add to the balance and number minted.
702             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
703 
704             // Updates:
705             // - `address` to the owner.
706             // - `startTimestamp` to the timestamp of minting.
707             // - `burned` to `false`.
708             // - `nextInitialized` to `quantity == 1`.
709             _packedOwnerships[startTokenId] =
710                 _addressToUint256(to) |
711                 (block.timestamp << BITPOS_START_TIMESTAMP) |
712                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
713 
714             uint256 updatedIndex = startTokenId;
715             uint256 end = updatedIndex + quantity;
716 
717             do {
718                 emit Transfer(address(0), to, updatedIndex++);
719             } while (updatedIndex < end);
720 
721             _currentIndex = updatedIndex;
722         }
723         _afterTokenTransfers(address(0), to, startTokenId, quantity);
724     }
725 
726     /**
727      * @dev Transfers `tokenId` from `from` to `to`.
728      *
729      * Requirements:
730      *
731      * - `to` cannot be the zero address.
732      * - `tokenId` token must be owned by `from`.
733      *
734      * Emits a {Transfer} event.
735      */
736     function _transfer(
737             address from,
738             address to,
739             uint256 tokenId
740             ) private {
741 
742         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
743 
744         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
745 
746         address approvedAddress = _tokenApprovals[tokenId];
747 
748         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
749                 isApprovedForAll(from, _msgSenderERC721A()) ||
750                 approvedAddress == _msgSenderERC721A());
751 
752         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
753 
754 
755         // Clear approvals from the previous owner.
756         if (_addressToUint256(approvedAddress) != 0) {
757             delete _tokenApprovals[tokenId];
758         }
759 
760         // Underflow of the sender's balance is impossible because we check for
761         // ownership above and the recipient's balance can't realistically overflow.
762         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
763         unchecked {
764             // We can directly increment and decrement the balances.
765             --_packedAddressData[from]; // Updates: `balance -= 1`.
766             ++_packedAddressData[to]; // Updates: `balance += 1`.
767 
768             // Updates:
769             // - `address` to the next owner.
770             // - `startTimestamp` to the timestamp of transfering.
771             // - `burned` to `false`.
772             // - `nextInitialized` to `true`.
773             _packedOwnerships[tokenId] =
774                 _addressToUint256(to) |
775                 (block.timestamp << BITPOS_START_TIMESTAMP) |
776                 BITMASK_NEXT_INITIALIZED;
777 
778             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
779             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
780                 uint256 nextTokenId = tokenId + 1;
781                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
782                 if (_packedOwnerships[nextTokenId] == 0) {
783                     // If the next slot is within bounds.
784                     if (nextTokenId != _currentIndex) {
785                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
786                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
787                     }
788                 }
789             }
790         }
791 
792         emit Transfer(from, to, tokenId);
793         _afterTokenTransfers(from, to, tokenId, 1);
794     }
795 
796 
797 
798 
799     /**
800      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
801      * minting.
802      * And also called after one token has been burned.
803      *
804      * startTokenId - the first token id to be transferred
805      * quantity - the amount to be transferred
806      *
807      * Calling conditions:
808      *
809      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
810      * transferred to `to`.
811      * - When `from` is zero, `tokenId` has been minted for `to`.
812      * - When `to` is zero, `tokenId` has been burned by `from`.
813      * - `from` and `to` are never both zero.
814      */
815     function _afterTokenTransfers(
816             address from,
817             address to,
818             uint256 startTokenId,
819             uint256 quantity
820             ) internal virtual {}
821 
822     /**
823      * @dev Returns the message sender (defaults to `msg.sender`).
824      *
825      * If you are writing GSN compatible contracts, you need to override this function.
826      */
827     function _msgSenderERC721A() internal view virtual returns (address) {
828         return msg.sender;
829     }
830 
831     /**
832      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
833      */
834     function _toString(uint256 value) internal pure returns (string memory ptr) {
835         assembly {
836             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
837             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
838             // We will need 1 32-byte word to store the length, 
839             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
840             ptr := add(mload(0x40), 128)
841 
842          // Update the free memory pointer to allocate.
843          mstore(0x40, ptr)
844 
845          // Cache the end of the memory to calculate the length later.
846          let end := ptr
847 
848          // We write the string from the rightmost digit to the leftmost digit.
849          // The following is essentially a do-while loop that also handles the zero case.
850          // Costs a bit more than early returning for the zero case,
851          // but cheaper in terms of deployment and overall runtime costs.
852          for { 
853              // Initialize and perform the first pass without check.
854              let temp := value
855                  // Move the pointer 1 byte leftwards to point to an empty character slot.
856                  ptr := sub(ptr, 1)
857                  // Write the character to the pointer. 48 is the ASCII index of '0'.
858                  mstore8(ptr, add(48, mod(temp, 10)))
859                  temp := div(temp, 10)
860          } temp { 
861              // Keep dividing `temp` until zero.
862         temp := div(temp, 10)
863          } { 
864              // Body of the for loop.
865         ptr := sub(ptr, 1)
866          mstore8(ptr, add(48, mod(temp, 10)))
867          }
868 
869      let length := sub(end, ptr)
870          // Move the pointer 32 bytes leftwards to make room for the length.
871          ptr := sub(ptr, 32)
872          // Store the length.
873          mstore(ptr, length)
874         }
875     }
876 
877     modifier onlyOwner() { 
878         require(_owner==msg.sender, "not Owner");
879         _; 
880     }
881 
882     modifier nob() {
883         require(tx.origin==msg.sender, "no Script");
884         _;
885     }
886 
887     function withdraw() external onlyOwner {
888         uint256 balance = address(this).balance;
889         payable(msg.sender).transfer(balance);
890     }
891 }