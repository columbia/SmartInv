1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-19
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-09-16
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-08-21
11 */
12 
13 // SPDX-License-Identifier: MIT
14 pragma solidity 0.8.17;
15 
16 
17 /**
18  * @dev Interface of ERC721A.
19  */
20 interface IERC721A {
21     /**
22      * The caller must own the token or be an approved operator.
23      */
24     error ApprovalCallerNotOwnerNorApproved();
25 
26     /**
27      * The token does not exist.
28      */
29     error ApprovalQueryForNonexistentToken();
30 
31     /**
32      * The caller cannot approve to their own address.
33      */
34     error ApproveToCaller();
35 
36     /**
37      * Cannot query the balance for the zero address.
38      */
39     error BalanceQueryForZeroAddress();
40 
41     /**
42      * Cannot mint to the zero address.
43      */
44     error MintToZeroAddress();
45 
46     /**
47      * The quantity of tokens minted must be more than zero.
48      */
49     error MintZeroQuantity();
50 
51     /**
52      * The token does not exist.
53      */
54     error OwnerQueryForNonexistentToken();
55 
56     /**
57      * The caller must own the token or be an approved operator.
58      */
59     error TransferCallerNotOwnerNorApproved();
60 
61     /**
62      * The token must be owned by `from`.
63      */
64     error TransferFromIncorrectOwner();
65 
66     /**
67      * Cannot safely transfer to a contract that does not implement the
68      * ERC721Receiver interface.
69      */
70     error TransferToNonERC721ReceiverImplementer();
71 
72     /**
73      * Cannot transfer to the zero address.
74      */
75     error TransferToZeroAddress();
76 
77     /**
78      * The token does not exist.
79      */
80     error URIQueryForNonexistentToken();
81 
82     /**
83      * The `quantity` minted with ERC2309 exceeds the safety limit.
84      */
85     error MintERC2309QuantityExceedsLimit();
86 
87     /**
88      * The `extraData` cannot be set on an unintialized ownership slot.
89      */
90     error OwnershipNotInitializedForExtraData();
91 
92     // =============================================================
93     //                            STRUCTS
94     // =============================================================
95 
96     struct TokenOwnership {
97         // The address of the owner.
98         address addr;
99         // Stores the start time of ownership with minimal overhead for tokenomics.
100         uint64 startTimestamp;
101         // Whether the token has been burned.
102         bool burned;
103         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
104         uint24 extraData;
105     }
106 
107     // =============================================================
108     //                         TOKEN COUNTERS
109     // =============================================================
110 
111     /**
112      * @dev Returns the total number of tokens in existence.
113      * Burned tokens will reduce the count.
114      * To get the total number of tokens minted, please see {_totalMinted}.
115      */
116     function totalSupply() external view returns (uint256);
117 
118     // =============================================================
119     //                            IERC165
120     // =============================================================
121 
122     /**
123      * @dev Returns true if this contract implements the interface defined by
124      * `interfaceId`. See the corresponding
125      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
126      * to learn more about how these ids are created.
127      *
128      * This function call must use less than 30000 gas.
129      */
130     function supportsInterface(bytes4 interfaceId) external view returns (bool);
131 
132     // =============================================================
133     //                            IERC721
134     // =============================================================
135 
136     /**
137      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
143      */
144     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
145 
146     /**
147      * @dev Emitted when `owner` enables or disables
148      * (`approved`) `operator` to manage all of its assets.
149      */
150     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
151 
152     /**
153      * @dev Returns the number of tokens in `owner`'s account.
154      */
155     function balanceOf(address owner) external view returns (uint256 balance);
156 
157     /**
158      * @dev Returns the owner of the `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function ownerOf(uint256 tokenId) external view returns (address owner);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`,
168      * checking first that contract recipients are aware of the ERC721 protocol
169      * to prevent tokens from being forever locked.
170      *
171      * Requirements:
172      *
173      * - `from` cannot be the zero address.
174      * - `to` cannot be the zero address.
175      * - `tokenId` token must exist and be owned by `from`.
176      * - If the caller is not `from`, it must be have been allowed to move
177      * this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement
179      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
180      *
181      * Emits a {Transfer} event.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId,
187         bytes calldata data
188     ) external;
189 
190     /**
191      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
192      */
193     function safeTransferFrom(
194         address from,
195         address to,
196         uint256 tokenId
197     ) external;
198 
199     /**
200      * @dev Transfers `tokenId` from `from` to `to`.
201      *
202      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
203      * whenever possible.
204      *
205      * Requirements:
206      *
207      * - `from` cannot be the zero address.
208      * - `to` cannot be the zero address.
209      * - `tokenId` token must be owned by `from`.
210      * - If the caller is not `from`, it must be approved to move this token
211      * by either {approve} or {setApprovalForAll}.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(
216         address from,
217         address to,
218         uint256 tokenId
219     ) external;
220 
221     /**
222      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
223      * The approval is cleared when the token is transferred.
224      *
225      * Only a single account can be approved at a time, so approving the
226      * zero address clears previous approvals.
227      *
228      * Requirements:
229      *
230      * - The caller must own the token or be an approved operator.
231      * - `tokenId` must exist.
232      *
233      * Emits an {Approval} event.
234      */
235     function approve(address to, uint256 tokenId) external;
236 
237     /**
238      * @dev Approve or remove `operator` as an operator for the caller.
239      * Operators can call {transferFrom} or {safeTransferFrom}
240      * for any token owned by the caller.
241      *
242      * Requirements:
243      *
244      * - The `operator` cannot be the caller.
245      *
246      * Emits an {ApprovalForAll} event.
247      */
248     function setApprovalForAll(address operator, bool _approved) external;
249 
250     /**
251      * @dev Returns the account approved for `tokenId` token.
252      *
253      * Requirements:
254      *
255      * - `tokenId` must exist.
256      */
257     function getApproved(uint256 tokenId) external view returns (address operator);
258 
259     /**
260      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
261      *
262      * See {setApprovalForAll}.
263      */
264     function isApprovedForAll(address owner, address operator) external view returns (bool);
265 
266     // =============================================================
267     //                        IERC721Metadata
268     // =============================================================
269 
270     /**
271      * @dev Returns the token collection name.
272      */
273     function name() external view returns (string memory);
274 
275     /**
276      * @dev Returns the token collection symbol.
277      */
278     function symbol() external view returns (string memory);
279 
280     /**
281      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
282      */
283     function tokenURI(uint256 tokenId) external view returns (string memory);
284 
285     // =============================================================
286     //                           IERC2309
287     // =============================================================
288 
289     /**
290      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
291      * (inclusive) is transferred from `from` to `to`, as defined in the
292      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
293      *
294      * See {_mintERC2309} for more details.
295      */
296     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
297 }
298 
299 
300 contract PNKZ is IERC721A { 
301     address private _owner;
302     function owner() public view returns(address){
303         return _owner;
304     }
305     modifier onlyOwner() { 
306         require(_owner==msg.sender);
307         _; 
308     }
309 
310     uint256 public constant MAX_SUPPLY = 2222;
311     uint256 public constant MAX_FREE = 1700;
312     uint256 public MAX_FREE_PER_WALLET = 1;
313     uint256 public COST = 0.001 ether;
314 
315     string private constant _name = "PNKZ";
316     string private constant _symbol = "PNKZ";
317     string public constant contractURI = "ipfs://QmVXZrdgEp9L25r661FgSvyA9ktAkH4D6Ef4ogV12dqac3";
318     string private _baseURI = "QmeYfscBXSe1SMWCoieAvtXwiQwqUi1SW8ziNbYP9Rp1yM";
319 
320     constructor() {
321         _owner = msg.sender;
322         _mint(msg.sender, 1);
323     }
324 
325     function mint(uint256 amount) external payable{
326         address _caller = _msgSenderERC721A();
327 
328         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
329         require(amount*COST <= msg.value, "Value to Low");
330 
331         _mint(_caller, amount);
332     }
333 
334     function freeMint() external{
335         address _caller = _msgSenderERC721A();
336         uint256 amount = 1;
337 
338         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
339         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "Max per Wallet");
340 
341         _mint(_caller, amount);
342     }
343 
344     // Mask of an entry in packed address data.
345     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
346 
347     // The bit position of `numberMinted` in packed address data.
348     uint256 private constant BITPOS_NUMBER_MINTED = 64;
349 
350     // The bit position of `numberBurned` in packed address data.
351     uint256 private constant BITPOS_NUMBER_BURNED = 128;
352 
353     // The bit position of `aux` in packed address data.
354     uint256 private constant BITPOS_AUX = 192;
355 
356     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
357     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
358 
359     // The bit position of `startTimestamp` in packed ownership.
360     uint256 private constant BITPOS_START_TIMESTAMP = 160;
361 
362     // The bit mask of the `burned` bit in packed ownership.
363     uint256 private constant BITMASK_BURNED = 1 << 224;
364 
365     // The bit position of the `nextInitialized` bit in packed ownership.
366     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
367 
368     // The bit mask of the `nextInitialized` bit in packed ownership.
369     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
370 
371     // The tokenId of the next token to be minted.
372     uint256 private _currentIndex = 0;
373 
374     // The number of tokens burned.
375     // uint256 private _burnCounter;
376 
377 
378     // Mapping from token ID to ownership details
379     // An empty struct value does not necessarily mean the token is unowned.
380     // See `_packedOwnershipOf` implementation for details.
381     //
382     // Bits Layout:
383     // - [0..159] `addr`
384     // - [160..223] `startTimestamp`
385     // - [224] `burned`
386     // - [225] `nextInitialized`
387     mapping(uint256 => uint256) private _packedOwnerships;
388 
389     // Mapping owner address to address data.
390     //
391     // Bits Layout:
392     // - [0..63] `balance`
393     // - [64..127] `numberMinted`
394     // - [128..191] `numberBurned`
395     // - [192..255] `aux`
396     mapping(address => uint256) private _packedAddressData;
397 
398     // Mapping from token ID to approved address.
399     mapping(uint256 => address) private _tokenApprovals;
400 
401     // Mapping from owner to operator approvals
402     mapping(address => mapping(address => bool)) private _operatorApprovals;
403 
404 
405     function setData(string memory _base) external onlyOwner{
406         _baseURI = _base;
407     }
408 
409     function setConfig(uint256 _MAX_FREE_PER_WALLET, uint256 _COST) external onlyOwner{
410         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
411         COST = _COST;
412     }
413 
414     /**
415      * @dev Returns the starting token ID. 
416      * To change the starting token ID, please override this function.
417      */
418     function _startTokenId() internal view virtual returns (uint256) {
419         return 0;
420     }
421 
422     /**
423      * @dev Returns the next token ID to be minted.
424      */
425     function _nextTokenId() internal view returns (uint256) {
426         return _currentIndex;
427     }
428 
429     /**
430      * @dev Returns the total number of tokens in existence.
431      * Burned tokens will reduce the count. 
432      * To get the total number of tokens minted, please see `_totalMinted`.
433      */
434     function totalSupply() public view override returns (uint256) {
435         // Counter underflow is impossible as _burnCounter cannot be incremented
436         // more than `_currentIndex - _startTokenId()` times.
437         unchecked {
438             return _currentIndex - _startTokenId();
439         }
440     }
441 
442     /**
443      * @dev Returns the total amount of tokens minted in the contract.
444      */
445     function _totalMinted() internal view returns (uint256) {
446         // Counter underflow is impossible as _currentIndex does not decrement,
447         // and it is initialized to `_startTokenId()`
448         unchecked {
449             return _currentIndex - _startTokenId();
450         }
451     }
452 
453 
454     /**
455      * @dev See {IERC165-supportsInterface}.
456      */
457     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
458         // The interface IDs are constants representing the first 4 bytes of the XOR of
459         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
460         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
461         return
462             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
463             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
464             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
465     }
466 
467     /**
468      * @dev See {IERC721-balanceOf}.
469      */
470     function balanceOf(address owner) public view override returns (uint256) {
471         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
472         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
473     }
474 
475     /**
476      * Returns the number of tokens minted by `owner`.
477      */
478     function _numberMinted(address owner) internal view returns (uint256) {
479         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
480     }
481 
482 
483 
484     /**
485      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
486      */
487     function _getAux(address owner) internal view returns (uint64) {
488         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
489     }
490 
491     /**
492      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
493      * If there are multiple variables, please pack them into a uint64.
494      */
495     function _setAux(address owner, uint64 aux) internal {
496         uint256 packed = _packedAddressData[owner];
497         uint256 auxCasted;
498         assembly { // Cast aux without masking.
499             auxCasted := aux
500         }
501         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
502         _packedAddressData[owner] = packed;
503     }
504 
505     /**
506      * Returns the packed ownership data of `tokenId`.
507      */
508     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
509         uint256 curr = tokenId;
510 
511         unchecked {
512             if (_startTokenId() <= curr)
513                 if (curr < _currentIndex) {
514                     uint256 packed = _packedOwnerships[curr];
515                     // If not burned.
516                     if (packed & BITMASK_BURNED == 0) {
517                         // Invariant:
518                         // There will always be an ownership that has an address and is not burned
519                         // before an ownership that does not have an address and is not burned.
520                         // Hence, curr will not underflow.
521                         //
522                         // We can directly compare the packed value.
523                         // If the address is zero, packed is zero.
524                         while (packed == 0) {
525                             packed = _packedOwnerships[--curr];
526                         }
527                         return packed;
528                     }
529                 }
530         }
531         revert OwnerQueryForNonexistentToken();
532     }
533 
534     /**
535      * Returns the unpacked `TokenOwnership` struct from `packed`.
536      */
537     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
538         ownership.addr = address(uint160(packed));
539         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
540         ownership.burned = packed & BITMASK_BURNED != 0;
541     }
542 
543     /**
544      * Returns the unpacked `TokenOwnership` struct at `index`.
545      */
546     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
547         return _unpackedOwnership(_packedOwnerships[index]);
548     }
549 
550     /**
551      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
552      */
553     function _initializeOwnershipAt(uint256 index) internal {
554         if (_packedOwnerships[index] == 0) {
555             _packedOwnerships[index] = _packedOwnershipOf(index);
556         }
557     }
558 
559     /**
560      * Gas spent here starts off proportional to the maximum mint batch size.
561      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
562      */
563     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
564         return _unpackedOwnership(_packedOwnershipOf(tokenId));
565     }
566 
567     /**
568      * @dev See {IERC721-ownerOf}.
569      */
570     function ownerOf(uint256 tokenId) public view override returns (address) {
571         return address(uint160(_packedOwnershipOf(tokenId)));
572     }
573 
574     /**
575      * @dev See {IERC721Metadata-name}.
576      */
577     function name() public view virtual override returns (string memory) {
578         return _name;
579     }
580 
581     /**
582      * @dev See {IERC721Metadata-symbol}.
583      */
584     function symbol() public view virtual override returns (string memory) {
585         return _symbol;
586     }
587 
588     
589     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
590         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
591         string memory baseURI = _baseURI;
592         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
593     }
594 
595     /*
596     function contractURI() public view returns (string memory) {
597         return string(abi.encodePacked("ipfs://", _contractURI));
598     }
599     */
600 
601     /**
602      * @dev Casts the address to uint256 without masking.
603      */
604     function _addressToUint256(address value) private pure returns (uint256 result) {
605         assembly {
606             result := value
607         }
608     }
609 
610     /**
611      * @dev Casts the boolean to uint256 without branching.
612      */
613     function _boolToUint256(bool value) private pure returns (uint256 result) {
614         assembly {
615             result := value
616         }
617     }
618 
619     /**
620      * @dev See {IERC721-approve}.
621      */
622     function approve(address to, uint256 tokenId) public override {
623         address owner = address(uint160(_packedOwnershipOf(tokenId)));
624         if (to == owner) revert();
625 
626         if (_msgSenderERC721A() != owner)
627             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
628                 revert ApprovalCallerNotOwnerNorApproved();
629             }
630 
631         _tokenApprovals[tokenId] = to;
632         emit Approval(owner, to, tokenId);
633     }
634 
635     /**
636      * @dev See {IERC721-getApproved}.
637      */
638     function getApproved(uint256 tokenId) public view override returns (address) {
639         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
640 
641         return _tokenApprovals[tokenId];
642     }
643 
644     /**
645      * @dev See {IERC721-setApprovalForAll}.
646      */
647     function setApprovalForAll(address operator, bool approved) public virtual override {
648         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
649 
650         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
651         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
652     }
653 
654     /**
655      * @dev See {IERC721-isApprovedForAll}.
656      */
657     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
658         return _operatorApprovals[owner][operator];
659     }
660 
661     /**
662      * @dev See {IERC721-transferFrom}.
663      */
664     function transferFrom(
665             address from,
666             address to,
667             uint256 tokenId
668             ) public virtual override {
669         _transfer(from, to, tokenId);
670     }
671 
672     /**
673      * @dev See {IERC721-safeTransferFrom}.
674      */
675     function safeTransferFrom(
676             address from,
677             address to,
678             uint256 tokenId
679             ) public virtual override {
680         safeTransferFrom(from, to, tokenId, '');
681     }
682 
683     /**
684      * @dev See {IERC721-safeTransferFrom}.
685      */
686     function safeTransferFrom(
687             address from,
688             address to,
689             uint256 tokenId,
690             bytes memory _data
691             ) public virtual override {
692         _transfer(from, to, tokenId);
693     }
694 
695     /**
696      * @dev Returns whether `tokenId` exists.
697      *
698      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
699      *
700      * Tokens start existing when they are minted (`_mint`),
701      */
702     function _exists(uint256 tokenId) internal view returns (bool) {
703         return
704             _startTokenId() <= tokenId &&
705             tokenId < _currentIndex;
706     }
707 
708     /**
709      * @dev Equivalent to `_safeMint(to, quantity, '')`.
710      */
711      /*
712     function _safeMint(address to, uint256 quantity) internal {
713         _safeMint(to, quantity, '');
714     }
715     */
716 
717     /**
718      * @dev Safely mints `quantity` tokens and transfers them to `to`.
719      *
720      * Requirements:
721      *
722      * - If `to` refers to a smart contract, it must implement
723      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
724      * - `quantity` must be greater than 0.
725      *
726      * Emits a {Transfer} event.
727      */
728      /*
729     function _safeMint(
730             address to,
731             uint256 quantity,
732             bytes memory _data
733             ) internal {
734         uint256 startTokenId = _currentIndex;
735         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
736         if (quantity == 0) revert MintZeroQuantity();
737 
738 
739         // Overflows are incredibly unrealistic.
740         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
741         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
742         unchecked {
743             // Updates:
744             // - `balance += quantity`.
745             // - `numberMinted += quantity`.
746             //
747             // We can directly add to the balance and number minted.
748             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
749 
750             // Updates:
751             // - `address` to the owner.
752             // - `startTimestamp` to the timestamp of minting.
753             // - `burned` to `false`.
754             // - `nextInitialized` to `quantity == 1`.
755             _packedOwnerships[startTokenId] =
756                 _addressToUint256(to) |
757                 (block.timestamp << BITPOS_START_TIMESTAMP) |
758                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
759 
760             uint256 updatedIndex = startTokenId;
761             uint256 end = updatedIndex + quantity;
762 
763             if (to.code.length != 0) {
764                 do {
765                     emit Transfer(address(0), to, updatedIndex);
766                 } while (updatedIndex < end);
767                 // Reentrancy protection
768                 if (_currentIndex != startTokenId) revert();
769             } else {
770                 do {
771                     emit Transfer(address(0), to, updatedIndex++);
772                 } while (updatedIndex < end);
773             }
774             _currentIndex = updatedIndex;
775         }
776         _afterTokenTransfers(address(0), to, startTokenId, quantity);
777     }
778     */
779 
780     /**
781      * @dev Mints `quantity` tokens and transfers them to `to`.
782      *
783      * Requirements:
784      *
785      * - `to` cannot be the zero address.
786      * - `quantity` must be greater than 0.
787      *
788      * Emits a {Transfer} event.
789      */
790     function _mint(address to, uint256 quantity) internal {
791         uint256 startTokenId = _currentIndex;
792         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
793         if (quantity == 0) revert MintZeroQuantity();
794 
795 
796         // Overflows are incredibly unrealistic.
797         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
798         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
799         unchecked {
800             // Updates:
801             // - `balance += quantity`.
802             // - `numberMinted += quantity`.
803             //
804             // We can directly add to the balance and number minted.
805             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
806 
807             // Updates:
808             // - `address` to the owner.
809             // - `startTimestamp` to the timestamp of minting.
810             // - `burned` to `false`.
811             // - `nextInitialized` to `quantity == 1`.
812             _packedOwnerships[startTokenId] =
813                 _addressToUint256(to) |
814                 (block.timestamp << BITPOS_START_TIMESTAMP) |
815                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
816 
817             uint256 updatedIndex = startTokenId;
818             uint256 end = updatedIndex + quantity;
819 
820             do {
821                 emit Transfer(address(0), to, updatedIndex++);
822             } while (updatedIndex < end);
823 
824             _currentIndex = updatedIndex;
825         }
826         _afterTokenTransfers(address(0), to, startTokenId, quantity);
827     }
828 
829     /**
830      * @dev Transfers `tokenId` from `from` to `to`.
831      *
832      * Requirements:
833      *
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must be owned by `from`.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _transfer(
840             address from,
841             address to,
842             uint256 tokenId
843             ) private {
844 
845         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
846 
847         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
848 
849         address approvedAddress = _tokenApprovals[tokenId];
850 
851         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
852                 isApprovedForAll(from, _msgSenderERC721A()) ||
853                 approvedAddress == _msgSenderERC721A());
854 
855         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
856 
857         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
858 
859 
860         // Clear approvals from the previous owner.
861         if (_addressToUint256(approvedAddress) != 0) {
862             delete _tokenApprovals[tokenId];
863         }
864 
865         // Underflow of the sender's balance is impossible because we check for
866         // ownership above and the recipient's balance can't realistically overflow.
867         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
868         unchecked {
869             // We can directly increment and decrement the balances.
870             --_packedAddressData[from]; // Updates: `balance -= 1`.
871             ++_packedAddressData[to]; // Updates: `balance += 1`.
872 
873             // Updates:
874             // - `address` to the next owner.
875             // - `startTimestamp` to the timestamp of transfering.
876             // - `burned` to `false`.
877             // - `nextInitialized` to `true`.
878             _packedOwnerships[tokenId] =
879                 _addressToUint256(to) |
880                 (block.timestamp << BITPOS_START_TIMESTAMP) |
881                 BITMASK_NEXT_INITIALIZED;
882 
883             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
884             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
885                 uint256 nextTokenId = tokenId + 1;
886                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
887                 if (_packedOwnerships[nextTokenId] == 0) {
888                     // If the next slot is within bounds.
889                     if (nextTokenId != _currentIndex) {
890                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
891                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
892                     }
893                 }
894             }
895         }
896 
897         emit Transfer(from, to, tokenId);
898         _afterTokenTransfers(from, to, tokenId, 1);
899     }
900 
901 
902 
903 
904     /**
905      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
906      * minting.
907      * And also called after one token has been burned.
908      *
909      * startTokenId - the first token id to be transferred
910      * quantity - the amount to be transferred
911      *
912      * Calling conditions:
913      *
914      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
915      * transferred to `to`.
916      * - When `from` is zero, `tokenId` has been minted for `to`.
917      * - When `to` is zero, `tokenId` has been burned by `from`.
918      * - `from` and `to` are never both zero.
919      */
920     function _afterTokenTransfers(
921             address from,
922             address to,
923             uint256 startTokenId,
924             uint256 quantity
925             ) internal virtual {}
926 
927     /**
928      * @dev Returns the message sender (defaults to `msg.sender`).
929      *
930      * If you are writing GSN compatible contracts, you need to override this function.
931      */
932     function _msgSenderERC721A() internal view virtual returns (address) {
933         return msg.sender;
934     }
935 
936     /**
937      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
938      */
939     function _toString(uint256 value) internal pure returns (string memory ptr) {
940         assembly {
941             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
942             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
943             // We will need 1 32-byte word to store the length, 
944             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
945             ptr := add(mload(0x40), 128)
946 
947          // Update the free memory pointer to allocate.
948          mstore(0x40, ptr)
949 
950          // Cache the end of the memory to calculate the length later.
951          let end := ptr
952 
953          // We write the string from the rightmost digit to the leftmost digit.
954          // The following is essentially a do-while loop that also handles the zero case.
955          // Costs a bit more than early returning for the zero case,
956          // but cheaper in terms of deployment and overall runtime costs.
957          for { 
958              // Initialize and perform the first pass without check.
959              let temp := value
960                  // Move the pointer 1 byte leftwards to point to an empty character slot.
961                  ptr := sub(ptr, 1)
962                  // Write the character to the pointer. 48 is the ASCII index of '0'.
963                  mstore8(ptr, add(48, mod(temp, 10)))
964                  temp := div(temp, 10)
965          } temp { 
966              // Keep dividing `temp` until zero.
967         temp := div(temp, 10)
968          } { 
969              // Body of the for loop.
970         ptr := sub(ptr, 1)
971          mstore8(ptr, add(48, mod(temp, 10)))
972          }
973 
974      let length := sub(end, ptr)
975          // Move the pointer 32 bytes leftwards to make room for the length.
976          ptr := sub(ptr, 32)
977          // Store the length.
978          mstore(ptr, length)
979         }
980     }
981 
982     function withdraw() external onlyOwner {
983         uint256 balance = address(this).balance;
984         payable(msg.sender).transfer(balance);
985     }
986 }