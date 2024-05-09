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
288 contract Opunks is IERC721A { 
289 
290     address private _owner;
291     function owner() public view returns(address){
292         return _owner;
293     }
294 
295     uint256 public constant MAX_SUPPLY = 444;
296     uint256 public MAX_FREE_PER_WALLET = 1;
297     uint256 public COST = 0.001 ether;
298 
299     string private constant _name = "Opunks";
300     string private constant _symbol = "OPUNKS";
301     string private _baseURI = "QmQBKe8ESCM7MgybREuhJjvoxjAggvCSXsBW32M6B96AEC";
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
312 
313         _mint(_caller, amount);
314     }
315 
316     function freeMint() external nob{
317         address _caller = _msgSenderERC721A();
318         uint256 amount = MAX_FREE_PER_WALLET;
319 
320         require(totalSupply() + amount <= MAX_FREE, "Freemint Sold Out");
321         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "Max per Wallet");
322 
323         _mint(_caller, amount);
324     }
325 
326 
327 
328     // Mask of an entry in packed address data.
329     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
330 
331     // The bit position of `numberMinted` in packed address data.
332     uint256 private constant BITPOS_NUMBER_MINTED = 64;
333 
334     // The bit position of `numberBurned` in packed address data.
335     uint256 private constant BITPOS_NUMBER_BURNED = 128;
336 
337     // The bit position of `aux` in packed address data.
338     uint256 private constant BITPOS_AUX = 192;
339 
340     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
341     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
342 
343     // The bit position of `startTimestamp` in packed ownership.
344     uint256 private constant BITPOS_START_TIMESTAMP = 160;
345 
346     // The bit mask of the `burned` bit in packed ownership.
347     uint256 private constant BITMASK_BURNED = 1 << 224;
348 
349     // The bit position of the `nextInitialized` bit in packed ownership.
350     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
351 
352     // The bit mask of the `nextInitialized` bit in packed ownership.
353     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
354 
355     // The tokenId of the next token to be minted.
356     uint256 private _currentIndex = 0;
357 
358     // The number of tokens burned.
359     // uint256 private _burnCounter;
360 
361 
362     // Mapping from token ID to ownership details
363     // An empty struct value does not necessarily mean the token is unowned.
364     // See `_packedOwnershipOf` implementation for details.
365     //
366     // Bits Layout:
367     // - [0..159] `addr`
368     // - [160..223] `startTimestamp`
369     // - [224] `burned`
370     // - [225] `nextInitialized`
371     mapping(uint256 => uint256) private _packedOwnerships;
372 
373     // Mapping owner address to address data.
374     //
375     // Bits Layout:
376     // - [0..63] `balance`
377     // - [64..127] `numberMinted`
378     // - [128..191] `numberBurned`
379     // - [192..255] `aux`
380     mapping(address => uint256) private _packedAddressData;
381 
382     // Mapping from token ID to approved address.
383     mapping(uint256 => address) private _tokenApprovals;
384 
385     // Mapping from owner to operator approvals
386     mapping(address => mapping(address => bool)) private _operatorApprovals;
387 
388 
389     function setData(string memory _base) external onlyOwner{
390         _baseURI = _base;
391     }
392 
393     uint256 public MAX_FREE = 321;
394     function setConfig(uint256 _COST, uint256 _MAX_FREE, uint256 _MAX_FREE_PER_WALLET) external onlyOwner{
395         MAX_FREE = _MAX_FREE;
396         COST = _COST;
397         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
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
478      * Returns the packed ownership data of `tokenId`.
479      */
480     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
481         uint256 curr = tokenId;
482 
483         unchecked {
484             if (_startTokenId() <= curr)
485                 if (curr < _currentIndex) {
486                     uint256 packed = _packedOwnerships[curr];
487                     // If not burned.
488                     if (packed & BITMASK_BURNED == 0) {
489                         // Invariant:
490                         // There will always be an ownership that has an address and is not burned
491                         // before an ownership that does not have an address and is not burned.
492                         // Hence, curr will not underflow.
493                         //
494                         // We can directly compare the packed value.
495                         // If the address is zero, packed is zero.
496                         while (packed == 0) {
497                             packed = _packedOwnerships[--curr];
498                         }
499                         return packed;
500                     }
501                 }
502         }
503         revert OwnerQueryForNonexistentToken();
504     }
505 
506     /**
507      * Returns the unpacked `TokenOwnership` struct from `packed`.
508      */
509     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
510         ownership.addr = address(uint160(packed));
511         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
512         ownership.burned = packed & BITMASK_BURNED != 0;
513     }
514 
515     /**
516      * Returns the unpacked `TokenOwnership` struct at `index`.
517      */
518     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
519         return _unpackedOwnership(_packedOwnerships[index]);
520     }
521 
522     /**
523      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
524      */
525     function _initializeOwnershipAt(uint256 index) internal {
526         if (_packedOwnerships[index] == 0) {
527             _packedOwnerships[index] = _packedOwnershipOf(index);
528         }
529     }
530 
531     /**
532      * Gas spent here starts off proportional to the maximum mint batch size.
533      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
534      */
535     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
536         return _unpackedOwnership(_packedOwnershipOf(tokenId));
537     }
538 
539     /**
540      * @dev See {IERC721-ownerOf}.
541      */
542     function ownerOf(uint256 tokenId) public view override returns (address) {
543         return address(uint160(_packedOwnershipOf(tokenId)));
544     }
545 
546     /**
547      * @dev See {IERC721Metadata-name}.
548      */
549     function name() public view virtual override returns (string memory) {
550         return _name;
551     }
552 
553     /**
554      * @dev See {IERC721Metadata-symbol}.
555      */
556     function symbol() public view virtual override returns (string memory) {
557         return _symbol;
558     }
559 
560     
561     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
562         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
563         string memory baseURI = _baseURI;
564         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
565     }
566 
567     /**
568      * @dev Casts the address to uint256 without masking.
569      */
570     function _addressToUint256(address value) private pure returns (uint256 result) {
571         assembly {
572             result := value
573         }
574     }
575 
576     /**
577      * @dev Casts the boolean to uint256 without branching.
578      */
579     function _boolToUint256(bool value) private pure returns (uint256 result) {
580         assembly {
581             result := value
582         }
583     }
584 
585     /**
586      * @dev See {IERC721-approve}.
587      */
588     function approve(address to, uint256 tokenId) public override {
589         address owner = address(uint160(_packedOwnershipOf(tokenId)));
590         if (to == owner) revert();
591 
592         if (_msgSenderERC721A() != owner)
593             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
594                 revert ApprovalCallerNotOwnerNorApproved();
595             }
596 
597         _tokenApprovals[tokenId] = to;
598         emit Approval(owner, to, tokenId);
599     }
600 
601     /**
602      * @dev See {IERC721-getApproved}.
603      */
604     function getApproved(uint256 tokenId) public view override returns (address) {
605         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
606 
607         return _tokenApprovals[tokenId];
608     }
609 
610     /**
611      * @dev See {IERC721-setApprovalForAll}.
612      */
613     function setApprovalForAll(address operator, bool approved) public virtual override {
614         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
615 
616         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
617         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
618     }
619 
620     /**
621      * @dev See {IERC721-isApprovedForAll}.
622      */
623     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
624         return _operatorApprovals[owner][operator];
625     }
626 
627     /**
628      * @dev See {IERC721-transferFrom}.
629      */
630     function transferFrom(
631             address from,
632             address to,
633             uint256 tokenId
634             ) public virtual override {
635         _transfer(from, to, tokenId);
636     }
637 
638     /**
639      * @dev See {IERC721-safeTransferFrom}.
640      */
641     function safeTransferFrom(
642             address from,
643             address to,
644             uint256 tokenId
645             ) public virtual override {
646         safeTransferFrom(from, to, tokenId, '');
647     }
648 
649     /**
650      * @dev See {IERC721-safeTransferFrom}.
651      */
652     function safeTransferFrom(
653             address from,
654             address to,
655             uint256 tokenId,
656             bytes memory _data
657             ) public virtual override {
658         _transfer(from, to, tokenId);
659     }
660 
661     /**
662      * @dev Returns whether `tokenId` exists.
663      *
664      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
665      *
666      * Tokens start existing when they are minted (`_mint`),
667      */
668     function _exists(uint256 tokenId) internal view returns (bool) {
669         return
670             _startTokenId() <= tokenId &&
671             tokenId < _currentIndex;
672     }
673 
674   
675 
676     /**
677      * @dev Mints `quantity` tokens and transfers them to `to`.
678      *
679      * Requirements:
680      *
681      * - `to` cannot be the zero address.
682      * - `quantity` must be greater than 0.
683      *
684      * Emits a {Transfer} event.
685      */
686     function _mint(address to, uint256 quantity) internal {
687         uint256 startTokenId = _currentIndex;
688         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
689         if (quantity == 0) revert MintZeroQuantity();
690 
691 
692         // Overflows are incredibly unrealistic.
693         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
694         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
695         unchecked {
696             // Updates:
697             // - `balance += quantity`.
698             // - `numberMinted += quantity`.
699             //
700             // We can directly add to the balance and number minted.
701             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
702 
703             // Updates:
704             // - `address` to the owner.
705             // - `startTimestamp` to the timestamp of minting.
706             // - `burned` to `false`.
707             // - `nextInitialized` to `quantity == 1`.
708             _packedOwnerships[startTokenId] =
709                 _addressToUint256(to) |
710                 (block.timestamp << BITPOS_START_TIMESTAMP) |
711                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
712 
713             uint256 updatedIndex = startTokenId;
714             uint256 end = updatedIndex + quantity;
715 
716             do {
717                 emit Transfer(address(0), to, updatedIndex++);
718             } while (updatedIndex < end);
719 
720             _currentIndex = updatedIndex;
721         }
722         _afterTokenTransfers(address(0), to, startTokenId, quantity);
723     }
724 
725     /**
726      * @dev Transfers `tokenId` from `from` to `to`.
727      *
728      * Requirements:
729      *
730      * - `to` cannot be the zero address.
731      * - `tokenId` token must be owned by `from`.
732      *
733      * Emits a {Transfer} event.
734      */
735     function _transfer(
736             address from,
737             address to,
738             uint256 tokenId
739             ) private {
740 
741         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
742 
743         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
744 
745         address approvedAddress = _tokenApprovals[tokenId];
746 
747         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
748                 isApprovedForAll(from, _msgSenderERC721A()) ||
749                 approvedAddress == _msgSenderERC721A());
750 
751         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
752 
753 
754         // Clear approvals from the previous owner.
755         if (_addressToUint256(approvedAddress) != 0) {
756             delete _tokenApprovals[tokenId];
757         }
758 
759         // Underflow of the sender's balance is impossible because we check for
760         // ownership above and the recipient's balance can't realistically overflow.
761         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
762         unchecked {
763             // We can directly increment and decrement the balances.
764             --_packedAddressData[from]; // Updates: `balance -= 1`.
765             ++_packedAddressData[to]; // Updates: `balance += 1`.
766 
767             // Updates:
768             // - `address` to the next owner.
769             // - `startTimestamp` to the timestamp of transfering.
770             // - `burned` to `false`.
771             // - `nextInitialized` to `true`.
772             _packedOwnerships[tokenId] =
773                 _addressToUint256(to) |
774                 (block.timestamp << BITPOS_START_TIMESTAMP) |
775                 BITMASK_NEXT_INITIALIZED;
776 
777             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
778             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
779                 uint256 nextTokenId = tokenId + 1;
780                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
781                 if (_packedOwnerships[nextTokenId] == 0) {
782                     // If the next slot is within bounds.
783                     if (nextTokenId != _currentIndex) {
784                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
785                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
786                     }
787                 }
788             }
789         }
790 
791         emit Transfer(from, to, tokenId);
792         _afterTokenTransfers(from, to, tokenId, 1);
793     }
794 
795 
796 
797 
798     /**
799      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
800      * minting.
801      * And also called after one token has been burned.
802      *
803      * startTokenId - the first token id to be transferred
804      * quantity - the amount to be transferred
805      *
806      * Calling conditions:
807      *
808      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
809      * transferred to `to`.
810      * - When `from` is zero, `tokenId` has been minted for `to`.
811      * - When `to` is zero, `tokenId` has been burned by `from`.
812      * - `from` and `to` are never both zero.
813      */
814     function _afterTokenTransfers(
815             address from,
816             address to,
817             uint256 startTokenId,
818             uint256 quantity
819             ) internal virtual {}
820 
821     /**
822      * @dev Returns the message sender (defaults to `msg.sender`).
823      *
824      * If you are writing GSN compatible contracts, you need to override this function.
825      */
826     function _msgSenderERC721A() internal view virtual returns (address) {
827         return msg.sender;
828     }
829 
830     /**
831      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
832      */
833     function _toString(uint256 value) internal pure returns (string memory ptr) {
834         assembly {
835             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
836             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
837             // We will need 1 32-byte word to store the length, 
838             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
839             ptr := add(mload(0x40), 128)
840 
841          // Update the free memory pointer to allocate.
842          mstore(0x40, ptr)
843 
844          // Cache the end of the memory to calculate the length later.
845          let end := ptr
846 
847          // We write the string from the rightmost digit to the leftmost digit.
848          // The following is essentially a do-while loop that also handles the zero case.
849          // Costs a bit more than early returning for the zero case,
850          // but cheaper in terms of deployment and overall runtime costs.
851          for { 
852              // Initialize and perform the first pass without check.
853              let temp := value
854                  // Move the pointer 1 byte leftwards to point to an empty character slot.
855                  ptr := sub(ptr, 1)
856                  // Write the character to the pointer. 48 is the ASCII index of '0'.
857                  mstore8(ptr, add(48, mod(temp, 10)))
858                  temp := div(temp, 10)
859          } temp { 
860              // Keep dividing `temp` until zero.
861         temp := div(temp, 10)
862          } { 
863              // Body of the for loop.
864         ptr := sub(ptr, 1)
865          mstore8(ptr, add(48, mod(temp, 10)))
866          }
867 
868      let length := sub(end, ptr)
869          // Move the pointer 32 bytes leftwards to make room for the length.
870          ptr := sub(ptr, 32)
871          // Store the length.
872          mstore(ptr, length)
873         }
874     }
875 
876     modifier onlyOwner() { 
877         require(_owner==msg.sender, "not Owner");
878         _; 
879     }
880 
881     modifier nob() {
882         require(tx.origin==msg.sender, "no Script");
883         _;
884     }
885 
886     function withdraw() external onlyOwner {
887         uint256 balance = address(this).balance;
888         payable(msg.sender).transfer(balance);
889     }
890 }