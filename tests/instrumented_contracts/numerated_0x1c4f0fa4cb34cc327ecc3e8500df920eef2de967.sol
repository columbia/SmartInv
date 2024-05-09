1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /*
5  __________
6 |  __  __  |
7 | |  ||  | |
8 | |  ||  | |
9 | |__||__| |---%^,
10 |  __  __()|  / >_/ ESCAPE THE MATRIX!!!
11 | |  ||  | +__/>
12 | |  ||  | |  >
13 | |__||__| | /|
14 |__________| | \
15 
16 */
17 
18 /*
19  * @dev Interface of ERC721A.
20  */
21 interface IERC721A {
22     /**
23      * The caller must own the token or be an approved operator.
24      */
25     error ApprovalCallerNotOwnerNorApproved();
26 
27     /**
28      * The token does not exist.
29      */
30     error ApprovalQueryForNonexistentToken();
31 
32     /**
33      * The caller cannot approve to their own address.
34      */
35     error ApproveToCaller();
36 
37     /**
38      * Cannot query the balance for the zero address.
39      */
40     error BalanceQueryForZeroAddress();
41 
42     /**
43      * Cannot mint to the zero address.
44      */
45     error MintToZeroAddress();
46 
47     /**
48      * The quantity of tokens minted must be more than zero.
49      */
50     error MintZeroQuantity();
51 
52     /**
53      * The token does not exist.
54      */
55     error OwnerQueryForNonexistentToken();
56 
57     /**
58      * The caller must own the token or be an approved operator.
59      */
60     error TransferCallerNotOwnerNorApproved();
61 
62     /**
63      * The token must be owned by `from`.
64      */
65     error TransferFromIncorrectOwner();
66 
67     /**
68      * Cannot safely transfer to a contract that does not implement the
69      * ERC721Receiver interface.
70      */
71     error TransferToNonERC721ReceiverImplementer();
72 
73     /**
74      * Cannot transfer to the zero address.
75      */
76     error TransferToZeroAddress();
77 
78     /**
79      * The token does not exist.
80      */
81     error URIQueryForNonexistentToken();
82 
83     /**
84      * The `quantity` minted with ERC2309 exceeds the safety limit.
85      */
86     error MintERC2309QuantityExceedsLimit();
87 
88     /**
89      * The `extraData` cannot be set on an unintialized ownership slot.
90      */
91     error OwnershipNotInitializedForExtraData();
92 
93     // =============================================================
94     //                            STRUCTS
95     // =============================================================
96 
97     struct TokenOwnership {
98         // The address of the owner.
99         address addr;
100         // Stores the start time of ownership with minimal overhead for tokenomics.
101         uint64 startTimestamp;
102         // Whether the token has been burned.
103         bool burned;
104         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
105         uint24 extraData;
106     }
107 
108     // =============================================================
109     //                         TOKEN COUNTERS
110     // =============================================================
111 
112     /**
113      * @dev Returns the total number of tokens in existence.
114      * Burned tokens will reduce the count.
115      * To get the total number of tokens minted, please see {_totalMinted}.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     // =============================================================
120     //                            IERC165
121     // =============================================================
122 
123     /**
124      * @dev Returns true if this contract implements the interface defined by
125      * `interfaceId`. See the corresponding
126      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
127      * to learn more about how these ids are created.
128      *
129      * This function call must use less than 30000 gas.
130      */
131     function supportsInterface(bytes4 interfaceId) external view returns (bool);
132 
133     // =============================================================
134     //                            IERC721
135     // =============================================================
136 
137     /**
138      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
139      */
140     event Transfer(
141         address indexed from,
142         address indexed to,
143         uint256 indexed tokenId
144     );
145 
146     /**
147      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
148      */
149     event Approval(
150         address indexed owner,
151         address indexed approved,
152         uint256 indexed tokenId
153     );
154 
155     /**
156      * @dev Emitted when `owner` enables or disables
157      * (`approved`) `operator` to manage all of its assets.
158      */
159     event ApprovalForAll(
160         address indexed owner,
161         address indexed operator,
162         bool approved
163     );
164 
165     /**
166      * @dev Returns the number of tokens in `owner`'s account.
167      */
168     function balanceOf(address owner) external view returns (uint256 balance);
169 
170     /**
171      * @dev Returns the owner of the `tokenId` token.
172      *
173      * Requirements:
174      *
175      * - `tokenId` must exist.
176      */
177     function ownerOf(uint256 tokenId) external view returns (address owner);
178 
179     /**
180      * @dev Safely transfers `tokenId` token from `from` to `to`,
181      * checking first that contract recipients are aware of the ERC721 protocol
182      * to prevent tokens from being forever locked.
183      *
184      * Requirements:
185      *
186      * - `from` cannot be the zero address.
187      * - `to` cannot be the zero address.
188      * - `tokenId` token must exist and be owned by `from`.
189      * - If the caller is not `from`, it must be have been allowed to move
190      * this token by either {approve} or {setApprovalForAll}.
191      * - If `to` refers to a smart contract, it must implement
192      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
193      *
194      * Emits a {Transfer} event.
195      */
196     function safeTransferFrom(
197         address from,
198         address to,
199         uint256 tokenId,
200         bytes calldata data
201     ) external;
202 
203     /**
204      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
205      */
206     function safeTransferFrom(
207         address from,
208         address to,
209         uint256 tokenId
210     ) external;
211 
212     /**
213      * @dev Transfers `tokenId` from `from` to `to`.
214      *
215      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
216      * whenever possible.
217      *
218      * Requirements:
219      *
220      * - `from` cannot be the zero address.
221      * - `to` cannot be the zero address.
222      * - `tokenId` token must be owned by `from`.
223      * - If the caller is not `from`, it must be approved to move this token
224      * by either {approve} or {setApprovalForAll}.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transferFrom(
229         address from,
230         address to,
231         uint256 tokenId
232     ) external;
233 
234     /**
235      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
236      * The approval is cleared when the token is transferred.
237      *
238      * Only a single account can be approved at a time, so approving the
239      * zero address clears previous approvals.
240      *
241      * Requirements:
242      *
243      * - The caller must own the token or be an approved operator.
244      * - `tokenId` must exist.
245      *
246      * Emits an {Approval} event.
247      */
248     function approve(address to, uint256 tokenId) external;
249 
250     /**
251      * @dev Approve or remove `operator` as an operator for the caller.
252      * Operators can call {transferFrom} or {safeTransferFrom}
253      * for any token owned by the caller.
254      *
255      * Requirements:
256      *
257      * - The `operator` cannot be the caller.
258      *
259      * Emits an {ApprovalForAll} event.
260      */
261     function setApprovalForAll(address operator, bool _approved) external;
262 
263     /**
264      * @dev Returns the account approved for `tokenId` token.
265      *
266      * Requirements:
267      *
268      * - `tokenId` must exist.
269      */
270     function getApproved(uint256 tokenId)
271         external
272         view
273         returns (address operator);
274 
275     /**
276      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
277      *
278      * See {setApprovalForAll}.
279      */
280     function isApprovedForAll(address owner, address operator)
281         external
282         view
283         returns (bool);
284 
285     // =============================================================
286     //                        IERC721Metadata
287     // =============================================================
288 
289     /**
290      * @dev Returns the token collection name.
291      */
292     function name() external view returns (string memory);
293 
294     /**
295      * @dev Returns the token collection symbol.
296      */
297     function symbol() external view returns (string memory);
298 
299     /**
300      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
301      */
302     function tokenURI(uint256 tokenId) external view returns (string memory);
303 
304     // =============================================================
305     //                           IERC2309
306     // =============================================================
307 
308     /**
309      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
310      * (inclusive) is transferred from `from` to `to`, as defined in the
311      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
312      *
313      * See {_mintERC2309} for more details.
314      */
315     event ConsecutiveTransfer(
316         uint256 indexed fromTokenId,
317         uint256 toTokenId,
318         address indexed from,
319         address indexed to
320     );
321 }
322 
323 contract ETM is IERC721A {
324     address private _owner;
325 
326     function owner() public view returns (address) {
327         return _owner;
328     }
329 
330     modifier onlyOwner() {
331         require(_owner == msg.sender);
332         _;
333     }
334 
335     uint256 public constant MAX_SUPPLY = 999;
336     uint256 public MAX_FREE = 888;
337     uint256 public MAX_FREE_PER_WALLET = 1;
338     uint256 public COST = 0.004 ether;
339 
340     string private constant _name = "EscapeTheMatrix";
341     string private constant _symbol = "ETM";
342     string private _baseURI = "bafybeicfennbdlkldkja3tbqkoyuyj46paziupgclez2rxjlfzd44lspm4";
343 
344     constructor() {
345         _owner = msg.sender;
346     }
347 
348     function mint(uint256 amount) external payable {
349         address _caller = _msgSenderERC721A();
350 
351         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
352         require(amount * COST <= msg.value, "Value to Low");
353         require(amount <= 5, "max 5 per TX");
354 
355         _mint(_caller, amount);
356     }
357 
358     function freeMint() external {
359         address _caller = _msgSenderERC721A();
360         uint256 amount = 1;
361 
362         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
363         require(
364             amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET,
365             "Max per Wallet"
366         );
367 
368         _mint(_caller, amount);
369     }
370 
371     // Mask of an entry in packed address data.
372     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
373 
374     // The bit position of `numberMinted` in packed address data.
375     uint256 private constant BITPOS_NUMBER_MINTED = 64;
376 
377     // The bit position of `numberBurned` in packed address data.
378     uint256 private constant BITPOS_NUMBER_BURNED = 128;
379 
380     // The bit position of `aux` in packed address data.
381     uint256 private constant BITPOS_AUX = 192;
382 
383     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
384     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
385 
386     // The bit position of `startTimestamp` in packed ownership.
387     uint256 private constant BITPOS_START_TIMESTAMP = 160;
388 
389     // The bit mask of the `burned` bit in packed ownership.
390     uint256 private constant BITMASK_BURNED = 1 << 224;
391 
392     // The bit position of the `nextInitialized` bit in packed ownership.
393     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
394 
395     // The bit mask of the `nextInitialized` bit in packed ownership.
396     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
397 
398     // The tokenId of the next token to be minted.
399     uint256 private _currentIndex = 0;
400 
401     // The number of tokens burned.
402     // uint256 private _burnCounter;
403 
404     // Mapping from token ID to ownership details
405     // An empty struct value does not necessarily mean the token is unowned.
406     // See `_packedOwnershipOf` implementation for details.
407     //
408     // Bits Layout:
409     // - [0..159] `addr`
410     // - [160..223] `startTimestamp`
411     // - [224] `burned`
412     // - [225] `nextInitialized`
413     mapping(uint256 => uint256) private _packedOwnerships;
414 
415     // Mapping owner address to address data.
416     //
417     // Bits Layout:
418     // - [0..63] `balance`
419     // - [64..127] `numberMinted`
420     // - [128..191] `numberBurned`
421     // - [192..255] `aux`
422     mapping(address => uint256) private _packedAddressData;
423 
424     // Mapping from token ID to approved address.
425     mapping(uint256 => address) private _tokenApprovals;
426 
427     // Mapping from owner to operator approvals
428     mapping(address => mapping(address => bool)) private _operatorApprovals;
429 
430     function setData(string memory _base) external onlyOwner {
431         _baseURI = _base;
432     }
433 
434     function setConfig(
435         uint256 _MAX_FREE_PER_WALLET,
436         uint256 _COST,
437         uint256 _MAX_FREE
438     ) external onlyOwner {
439         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
440         COST = _COST;
441         MAX_FREE = _MAX_FREE;
442     }
443 
444     /**
445      * @dev Returns the starting token ID.
446      * To change the starting token ID, please override this function.
447      */
448     function _startTokenId() internal view virtual returns (uint256) {
449         return 0;
450     }
451 
452     /**
453      * @dev Returns the next token ID to be minted.
454      */
455     function _nextTokenId() internal view returns (uint256) {
456         return _currentIndex;
457     }
458 
459     /**
460      * @dev Returns the total number of tokens in existence.
461      * Burned tokens will reduce the count.
462      * To get the total number of tokens minted, please see `_totalMinted`.
463      */
464     function totalSupply() public view override returns (uint256) {
465         // Counter underflow is impossible as _burnCounter cannot be incremented
466         // more than `_currentIndex - _startTokenId()` times.
467         unchecked {
468             return _currentIndex - _startTokenId();
469         }
470     }
471 
472     /**
473      * @dev Returns the total amount of tokens minted in the contract.
474      */
475     function _totalMinted() internal view returns (uint256) {
476         // Counter underflow is impossible as _currentIndex does not decrement,
477         // and it is initialized to `_startTokenId()`
478         unchecked {
479             return _currentIndex - _startTokenId();
480         }
481     }
482 
483     /**
484      * @dev See {IERC165-supportsInterface}.
485      */
486     function supportsInterface(bytes4 interfaceId)
487         public
488         view
489         virtual
490         override
491         returns (bool)
492     {
493         // The interface IDs are constants representing the first 4 bytes of the XOR of
494         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
495         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
496         return
497             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
498             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
499             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
500     }
501 
502     /**
503      * @dev See {IERC721-balanceOf}.
504      */
505     function balanceOf(address owner) public view override returns (uint256) {
506         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
507         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
508     }
509 
510     /**
511      * Returns the number of tokens minted by `owner`.
512      */
513     function _numberMinted(address owner) internal view returns (uint256) {
514         return
515             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
516             BITMASK_ADDRESS_DATA_ENTRY;
517     }
518 
519     /**
520      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
521      */
522     function _getAux(address owner) internal view returns (uint64) {
523         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
524     }
525 
526     /**
527      * Returns the packed ownership data of `tokenId`.
528      */
529     function _packedOwnershipOf(uint256 tokenId)
530         private
531         view
532         returns (uint256)
533     {
534         uint256 curr = tokenId;
535 
536         unchecked {
537             if (_startTokenId() <= curr)
538                 if (curr < _currentIndex) {
539                     uint256 packed = _packedOwnerships[curr];
540                     // If not burned.
541                     if (packed & BITMASK_BURNED == 0) {
542                         // Invariant:
543                         // There will always be an ownership that has an address and is not burned
544                         // before an ownership that does not have an address and is not burned.
545                         // Hence, curr will not underflow.
546                         //
547                         // We can directly compare the packed value.
548                         // If the address is zero, packed is zero.
549                         while (packed == 0) {
550                             packed = _packedOwnerships[--curr];
551                         }
552                         return packed;
553                     }
554                 }
555         }
556         revert OwnerQueryForNonexistentToken();
557     }
558 
559     /**
560      * Returns the unpacked `TokenOwnership` struct from `packed`.
561      */
562     function _unpackedOwnership(uint256 packed)
563         private
564         pure
565         returns (TokenOwnership memory ownership)
566     {
567         ownership.addr = address(uint160(packed));
568         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
569         ownership.burned = packed & BITMASK_BURNED != 0;
570     }
571 
572     /**
573      * Returns the unpacked `TokenOwnership` struct at `index`.
574      */
575     function _ownershipAt(uint256 index)
576         internal
577         view
578         returns (TokenOwnership memory)
579     {
580         return _unpackedOwnership(_packedOwnerships[index]);
581     }
582 
583     /**
584      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
585      */
586     function _initializeOwnershipAt(uint256 index) internal {
587         if (_packedOwnerships[index] == 0) {
588             _packedOwnerships[index] = _packedOwnershipOf(index);
589         }
590     }
591 
592     /**
593      * Gas spent here starts off proportional to the maximum mint batch size.
594      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
595      */
596     function _ownershipOf(uint256 tokenId)
597         internal
598         view
599         returns (TokenOwnership memory)
600     {
601         return _unpackedOwnership(_packedOwnershipOf(tokenId));
602     }
603 
604     /**
605      * @dev See {IERC721-ownerOf}.
606      */
607     function ownerOf(uint256 tokenId) public view override returns (address) {
608         return address(uint160(_packedOwnershipOf(tokenId)));
609     }
610 
611     /**
612      * @dev See {IERC721Metadata-name}.
613      */
614     function name() public view virtual override returns (string memory) {
615         return _name;
616     }
617 
618     /**
619      * @dev See {IERC721Metadata-symbol}.
620      */
621     function symbol() public view virtual override returns (string memory) {
622         return _symbol;
623     }
624 
625     function tokenURI(uint256 tokenId)
626         public
627         view
628         virtual
629         override
630         returns (string memory)
631     {
632         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
633         string memory baseURI = _baseURI;
634         return
635             bytes(baseURI).length != 0
636                 ? string(
637                     abi.encodePacked(
638                         "ipfs://",
639                         baseURI,
640                         "/",
641                         _toString(tokenId),
642                         ".json"
643                     )
644                 )
645                 : "";
646     }
647 
648     /**
649      * @dev Casts the address to uint256 without masking.
650      */
651     function _addressToUint256(address value)
652         private
653         pure
654         returns (uint256 result)
655     {
656         assembly {
657             result := value
658         }
659     }
660 
661     /**
662      * @dev Casts the boolean to uint256 without branching.
663      */
664     function _boolToUint256(bool value) private pure returns (uint256 result) {
665         assembly {
666             result := value
667         }
668     }
669 
670     /**
671      * @dev See {IERC721-approve}.
672      */
673     function approve(address to, uint256 tokenId) public override {
674         address owner = address(uint160(_packedOwnershipOf(tokenId)));
675         if (to == owner) revert();
676 
677         if (_msgSenderERC721A() != owner)
678             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
679                 revert ApprovalCallerNotOwnerNorApproved();
680             }
681 
682         _tokenApprovals[tokenId] = to;
683         emit Approval(owner, to, tokenId);
684     }
685 
686     /**
687      * @dev See {IERC721-getApproved}.
688      */
689     function getApproved(uint256 tokenId)
690         public
691         view
692         override
693         returns (address)
694     {
695         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
696 
697         return _tokenApprovals[tokenId];
698     }
699 
700     /**
701      * @dev See {IERC721-setApprovalForAll}.
702      */
703     function setApprovalForAll(address operator, bool approved)
704         public
705         virtual
706         override
707     {
708         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
709 
710         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
711         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
712     }
713 
714     /**
715      * @dev See {IERC721-isApprovedForAll}.
716      */
717     function isApprovedForAll(address owner, address operator)
718         public
719         view
720         virtual
721         override
722         returns (bool)
723     {
724         return _operatorApprovals[owner][operator];
725     }
726 
727     /**
728      * @dev See {IERC721-transferFrom}.
729      */
730     function transferFrom(
731         address from,
732         address to,
733         uint256 tokenId
734     ) public virtual override {
735         _transfer(from, to, tokenId);
736     }
737 
738     /**
739      * @dev See {IERC721-safeTransferFrom}.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         safeTransferFrom(from, to, tokenId, "");
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes memory _data
757     ) public virtual override {
758         _transfer(from, to, tokenId);
759     }
760 
761     /**
762      * @dev Returns whether `tokenId` exists.
763      *
764      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
765      *
766      * Tokens start existing when they are minted (`_mint`),
767      */
768     function _exists(uint256 tokenId) internal view returns (bool) {
769         return _startTokenId() <= tokenId && tokenId < _currentIndex;
770     }
771 
772     /**
773      * @dev Mints `quantity` tokens and transfers them to `to`.
774      *
775      * Requirements:
776      *
777      * - `to` cannot be the zero address.
778      * - `quantity` must be greater than 0.
779      *
780      * Emits a {Transfer} event.
781      */
782     function _mint(address to, uint256 quantity) internal {
783         uint256 startTokenId = _currentIndex;
784         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
785         if (quantity == 0) revert MintZeroQuantity();
786 
787         // Overflows are incredibly unrealistic.
788         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
789         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
790         unchecked {
791             // Updates:
792             // - `balance += quantity`.
793             // - `numberMinted += quantity`.
794             //
795             // We can directly add to the balance and number minted.
796             _packedAddressData[to] +=
797                 quantity *
798                 ((1 << BITPOS_NUMBER_MINTED) | 1);
799 
800             // Updates:
801             // - `address` to the owner.
802             // - `startTimestamp` to the timestamp of minting.
803             // - `burned` to `false`.
804             // - `nextInitialized` to `quantity == 1`.
805             _packedOwnerships[startTokenId] =
806                 _addressToUint256(to) |
807                 (block.timestamp << BITPOS_START_TIMESTAMP) |
808                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
809 
810             uint256 updatedIndex = startTokenId;
811             uint256 end = updatedIndex + quantity;
812 
813             do {
814                 emit Transfer(address(0), to, updatedIndex++);
815             } while (updatedIndex < end);
816 
817             _currentIndex = updatedIndex;
818         }
819         _afterTokenTransfers(address(0), to, startTokenId, quantity);
820     }
821 
822     /**
823      * @dev Transfers `tokenId` from `from` to `to`.
824      *
825      * Requirements:
826      *
827      * - `to` cannot be the zero address.
828      * - `tokenId` token must be owned by `from`.
829      *
830      * Emits a {Transfer} event.
831      */
832     function _transfer(
833         address from,
834         address to,
835         uint256 tokenId
836     ) private {
837         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
838 
839         if (address(uint160(prevOwnershipPacked)) != from)
840             revert TransferFromIncorrectOwner();
841 
842         address approvedAddress = _tokenApprovals[tokenId];
843 
844         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
845             isApprovedForAll(from, _msgSenderERC721A()) ||
846             approvedAddress == _msgSenderERC721A());
847 
848         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
849 
850         // Clear approvals from the previous owner.
851         if (_addressToUint256(approvedAddress) != 0) {
852             delete _tokenApprovals[tokenId];
853         }
854 
855         // Underflow of the sender's balance is impossible because we check for
856         // ownership above and the recipient's balance can't realistically overflow.
857         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
858         unchecked {
859             // We can directly increment and decrement the balances.
860             --_packedAddressData[from]; // Updates: `balance -= 1`.
861             ++_packedAddressData[to]; // Updates: `balance += 1`.
862 
863             // Updates:
864             // - `address` to the next owner.
865             // - `startTimestamp` to the timestamp of transfering.
866             // - `burned` to `false`.
867             // - `nextInitialized` to `true`.
868             _packedOwnerships[tokenId] =
869                 _addressToUint256(to) |
870                 (block.timestamp << BITPOS_START_TIMESTAMP) |
871                 BITMASK_NEXT_INITIALIZED;
872 
873             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
874             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
875                 uint256 nextTokenId = tokenId + 1;
876                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
877                 if (_packedOwnerships[nextTokenId] == 0) {
878                     // If the next slot is within bounds.
879                     if (nextTokenId != _currentIndex) {
880                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
881                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
882                     }
883                 }
884             }
885         }
886 
887         emit Transfer(from, to, tokenId);
888         _afterTokenTransfers(from, to, tokenId, 1);
889     }
890 
891     /**
892      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
893      * minting.
894      * And also called after one token has been burned.
895      *
896      * startTokenId - the first token id to be transferred
897      * quantity - the amount to be transferred
898      *
899      * Calling conditions:
900      *
901      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
902      * transferred to `to`.
903      * - When `from` is zero, `tokenId` has been minted for `to`.
904      * - When `to` is zero, `tokenId` has been burned by `from`.
905      * - `from` and `to` are never both zero.
906      */
907     function _afterTokenTransfers(
908         address from,
909         address to,
910         uint256 startTokenId,
911         uint256 quantity
912     ) internal virtual {}
913 
914     /**
915      * @dev Returns the message sender (defaults to `msg.sender`).
916      *
917      * If you are writing GSN compatible contracts, you need to override this function.
918      */
919     function _msgSenderERC721A() internal view virtual returns (address) {
920         return msg.sender;
921     }
922 
923     /**
924      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
925      */
926     function _toString(uint256 value)
927         internal
928         pure
929         returns (string memory ptr)
930     {
931         assembly {
932             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
933             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
934             // We will need 1 32-byte word to store the length,
935             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
936             ptr := add(mload(0x40), 128)
937 
938             // Update the free memory pointer to allocate.
939             mstore(0x40, ptr)
940 
941             // Cache the end of the memory to calculate the length later.
942             let end := ptr
943 
944             // We write the string from the rightmost digit to the leftmost digit.
945             // The following is essentially a do-while loop that also handles the zero case.
946             // Costs a bit more than early returning for the zero case,
947             // but cheaper in terms of deployment and overall runtime costs.
948             for {
949                 // Initialize and perform the first pass without check.
950                 let temp := value
951                 // Move the pointer 1 byte leftwards to point to an empty character slot.
952                 ptr := sub(ptr, 1)
953                 // Write the character to the pointer. 48 is the ASCII index of '0'.
954                 mstore8(ptr, add(48, mod(temp, 10)))
955                 temp := div(temp, 10)
956             } temp {
957                 // Keep dividing `temp` until zero.
958                 temp := div(temp, 10)
959             } {
960                 // Body of the for loop.
961                 ptr := sub(ptr, 1)
962                 mstore8(ptr, add(48, mod(temp, 10)))
963             }
964 
965             let length := sub(end, ptr)
966             // Move the pointer 32 bytes leftwards to make room for the length.
967             ptr := sub(ptr, 32)
968             // Store the length.
969             mstore(ptr, length)
970         }
971     }
972 
973     function withdraw() external onlyOwner {
974         uint256 balance = address(this).balance;
975         payable(msg.sender).transfer(balance);
976     }
977 }