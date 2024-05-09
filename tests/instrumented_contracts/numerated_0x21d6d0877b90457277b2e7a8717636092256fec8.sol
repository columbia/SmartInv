1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.17;
7 
8 
9 /**
10  * @dev Interface of ERC721A.
11  */
12 interface IERC721A {
13     /**
14      * The caller must own the token or be an approved operator.
15      */
16     error ApprovalCallerNotOwnerNorApproved();
17 
18     /**
19      * The token does not exist.
20      */
21     error ApprovalQueryForNonexistentToken();
22 
23     /**
24      * The caller cannot approve to their own address.
25      */
26     error ApproveToCaller();
27 
28     /**
29      * Cannot query the balance for the zero address.
30      */
31     error BalanceQueryForZeroAddress();
32 
33     /**
34      * Cannot mint to the zero address.
35      */
36     error MintToZeroAddress();
37 
38     /**
39      * The quantity of tokens minted must be more than zero.
40      */
41     error MintZeroQuantity();
42 
43     /**
44      * The token does not exist.
45      */
46     error OwnerQueryForNonexistentToken();
47 
48     /**
49      * The caller must own the token or be an approved operator.
50      */
51     error TransferCallerNotOwnerNorApproved();
52 
53     /**
54      * The token must be owned by `from`.
55      */
56     error TransferFromIncorrectOwner();
57 
58     /**
59      * Cannot safely transfer to a contract that does not implement the
60      * ERC721Receiver interface.
61      */
62     error TransferToNonERC721ReceiverImplementer();
63 
64     /**
65      * Cannot transfer to the zero address.
66      */
67     error TransferToZeroAddress();
68 
69     /**
70      * The token does not exist.
71      */
72     error URIQueryForNonexistentToken();
73 
74     /**
75      * The `quantity` minted with ERC2309 exceeds the safety limit.
76      */
77     error MintERC2309QuantityExceedsLimit();
78 
79     /**
80      * The `extraData` cannot be set on an unintialized ownership slot.
81      */
82     error OwnershipNotInitializedForExtraData();
83 
84     // =============================================================
85     //                            STRUCTS
86     // =============================================================
87 
88     struct TokenOwnership {
89         // The address of the owner.
90         address addr;
91         // Stores the start time of ownership with minimal overhead for tokenomics.
92         uint64 startTimestamp;
93         // Whether the token has been burned.
94         bool burned;
95         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
96         uint24 extraData;
97     }
98 
99     // =============================================================
100     //                         TOKEN COUNTERS
101     // =============================================================
102 
103     /**
104      * @dev Returns the total number of tokens in existence.
105      * Burned tokens will reduce the count.
106      * To get the total number of tokens minted, please see {_totalMinted}.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     // =============================================================
111     //                            IERC165
112     // =============================================================
113 
114     /**
115      * @dev Returns true if this contract implements the interface defined by
116      * `interfaceId`. See the corresponding
117      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
118      * to learn more about how these ids are created.
119      *
120      * This function call must use less than 30000 gas.
121      */
122     function supportsInterface(bytes4 interfaceId) external view returns (bool);
123 
124     // =============================================================
125     //                            IERC721
126     // =============================================================
127 
128     /**
129      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
135      */
136     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables or disables
140      * (`approved`) `operator` to manage all of its assets.
141      */
142     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
143 
144     /**
145      * @dev Returns the number of tokens in `owner`'s account.
146      */
147     function balanceOf(address owner) external view returns (uint256 balance);
148 
149     /**
150      * @dev Returns the owner of the `tokenId` token.
151      *
152      * Requirements:
153      *
154      * - `tokenId` must exist.
155      */
156     function ownerOf(uint256 tokenId) external view returns (address owner);
157 
158     /**
159      * @dev Safely transfers `tokenId` token from `from` to `to`,
160      * checking first that contract recipients are aware of the ERC721 protocol
161      * to prevent tokens from being forever locked.
162      *
163      * Requirements:
164      *
165      * - `from` cannot be the zero address.
166      * - `to` cannot be the zero address.
167      * - `tokenId` token must exist and be owned by `from`.
168      * - If the caller is not `from`, it must be have been allowed to move
169      * this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement
171      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId,
179         bytes calldata data
180     ) external;
181 
182     /**
183      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Transfers `tokenId` from `from` to `to`.
193      *
194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
195      * whenever possible.
196      *
197      * Requirements:
198      *
199      * - `from` cannot be the zero address.
200      * - `to` cannot be the zero address.
201      * - `tokenId` token must be owned by `from`.
202      * - If the caller is not `from`, it must be approved to move this token
203      * by either {approve} or {setApprovalForAll}.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 tokenId
211     ) external;
212 
213     /**
214      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
215      * The approval is cleared when the token is transferred.
216      *
217      * Only a single account can be approved at a time, so approving the
218      * zero address clears previous approvals.
219      *
220      * Requirements:
221      *
222      * - The caller must own the token or be an approved operator.
223      * - `tokenId` must exist.
224      *
225      * Emits an {Approval} event.
226      */
227     function approve(address to, uint256 tokenId) external;
228 
229     /**
230      * @dev Approve or remove `operator` as an operator for the caller.
231      * Operators can call {transferFrom} or {safeTransferFrom}
232      * for any token owned by the caller.
233      *
234      * Requirements:
235      *
236      * - The `operator` cannot be the caller.
237      *
238      * Emits an {ApprovalForAll} event.
239      */
240     function setApprovalForAll(address operator, bool _approved) external;
241 
242     /**
243      * @dev Returns the account approved for `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function getApproved(uint256 tokenId) external view returns (address operator);
250 
251     /**
252      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
253      *
254      * See {setApprovalForAll}.
255      */
256     function isApprovedForAll(address owner, address operator) external view returns (bool);
257 
258     // =============================================================
259     //                        IERC721Metadata
260     // =============================================================
261 
262     /**
263      * @dev Returns the token collection name.
264      */
265     function name() external view returns (string memory);
266 
267     /**
268      * @dev Returns the token collection symbol.
269      */
270     function symbol() external view returns (string memory);
271 
272     /**
273      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
274      */
275     function tokenURI(uint256 tokenId) external view returns (string memory);
276 
277     // =============================================================
278     //                           IERC2309
279     // =============================================================
280 
281     /**
282      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
283      * (inclusive) is transferred from `from` to `to`, as defined in the
284      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
285      *
286      * See {_mintERC2309} for more details.
287      */
288     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
289 }
290 
291 
292 contract CDP is IERC721A { 
293     address private _owner;
294     function owner() public view returns(address){
295         return _owner;
296     }
297 
298     modifier onlyOwner() { 
299         require(_owner==msg.sender);
300         _; 
301     }
302 
303     uint256 public constant MAX_SUPPLY = 2000;
304     uint256 public MAX_FREE = 1444;
305     uint256 public MAX_FREE_PER_WALLET = 1;
306     uint256 public COST = 0.001 ether;
307 
308     string private constant _name = "Cryptodickpunks";
309     string private constant _symbol = "CDP";
310     string public constant contractURI = "ipfs://QmULR4TzRr9arUE2XeVpfwN9YwPwzCMjpTbFeVLmSnbb66";
311     string private _baseURI = "QmefbGce8CLvSj6hXcb1XAN9QPCf3F3rQssyB4QgG8nsEt";
312 
313     constructor() {
314         _owner = msg.sender;
315     }
316 
317     function mint(uint256 amount) external payable{
318         address _caller = _msgSenderERC721A();
319 
320         require(totalSupply() + amount <= MAX_SUPPLY, "SoldOut");
321         require(amount*COST <= msg.value, "Value to Low");
322 
323         _mint(_caller, amount);
324     }
325 
326     function freeMint() external{
327         address _caller = _msgSenderERC721A();
328         uint256 amount = 1;
329 
330         require(totalSupply() + amount <= MAX_FREE, "Freemint SoldOut");
331         require(amount + _numberMinted(_caller) <= MAX_FREE_PER_WALLET, "Max per Wallet");
332 
333         _mint(_caller, amount);
334     }
335 
336     // Mask of an entry in packed address data.
337     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
338 
339     // The bit position of `numberMinted` in packed address data.
340     uint256 private constant BITPOS_NUMBER_MINTED = 64;
341 
342     // The bit position of `numberBurned` in packed address data.
343     uint256 private constant BITPOS_NUMBER_BURNED = 128;
344 
345     // The bit position of `aux` in packed address data.
346     uint256 private constant BITPOS_AUX = 192;
347 
348     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
349     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
350 
351     // The bit position of `startTimestamp` in packed ownership.
352     uint256 private constant BITPOS_START_TIMESTAMP = 160;
353 
354     // The bit mask of the `burned` bit in packed ownership.
355     uint256 private constant BITMASK_BURNED = 1 << 224;
356 
357     // The bit position of the `nextInitialized` bit in packed ownership.
358     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
359 
360     // The bit mask of the `nextInitialized` bit in packed ownership.
361     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
362 
363     // The tokenId of the next token to be minted.
364     uint256 private _currentIndex = 0;
365 
366     // The number of tokens burned.
367     // uint256 private _burnCounter;
368 
369 
370     // Mapping from token ID to ownership details
371     // An empty struct value does not necessarily mean the token is unowned.
372     // See `_packedOwnershipOf` implementation for details.
373     //
374     // Bits Layout:
375     // - [0..159] `addr`
376     // - [160..223] `startTimestamp`
377     // - [224] `burned`
378     // - [225] `nextInitialized`
379     mapping(uint256 => uint256) private _packedOwnerships;
380 
381     // Mapping owner address to address data.
382     //
383     // Bits Layout:
384     // - [0..63] `balance`
385     // - [64..127] `numberMinted`
386     // - [128..191] `numberBurned`
387     // - [192..255] `aux`
388     mapping(address => uint256) private _packedAddressData;
389 
390     // Mapping from token ID to approved address.
391     mapping(uint256 => address) private _tokenApprovals;
392 
393     // Mapping from owner to operator approvals
394     mapping(address => mapping(address => bool)) private _operatorApprovals;
395 
396 
397     function setData(string memory _base) external onlyOwner{
398         _baseURI = _base;
399     }
400 
401     function setConfig(uint256 _MAX_FREE_PER_WALLET, uint256 _COST, uint256 _MAX_FREE) external onlyOwner{
402         MAX_FREE_PER_WALLET = _MAX_FREE_PER_WALLET;
403         COST = _COST;
404         MAX_FREE = _MAX_FREE;
405     }
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
581     
582     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
583         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
584         string memory baseURI = _baseURI;
585         return bytes(baseURI).length != 0 ? string(abi.encodePacked("ipfs://", baseURI, "/", _toString(tokenId), ".json")) : "";
586     }
587 
588     /*
589     function contractURI() public view returns (string memory) {
590         return string(abi.encodePacked("ipfs://", _contractURI));
591     }
592     */
593 
594     /**
595      * @dev Casts the address to uint256 without masking.
596      */
597     function _addressToUint256(address value) private pure returns (uint256 result) {
598         assembly {
599             result := value
600         }
601     }
602 
603     /**
604      * @dev Casts the boolean to uint256 without branching.
605      */
606     function _boolToUint256(bool value) private pure returns (uint256 result) {
607         assembly {
608             result := value
609         }
610     }
611 
612     /**
613      * @dev See {IERC721-approve}.
614      */
615     function approve(address to, uint256 tokenId) public override {
616         address owner = address(uint160(_packedOwnershipOf(tokenId)));
617         if (to == owner) revert();
618 
619         if (_msgSenderERC721A() != owner)
620             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
621                 revert ApprovalCallerNotOwnerNorApproved();
622             }
623 
624         _tokenApprovals[tokenId] = to;
625         emit Approval(owner, to, tokenId);
626     }
627 
628     /**
629      * @dev See {IERC721-getApproved}.
630      */
631     function getApproved(uint256 tokenId) public view override returns (address) {
632         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
633 
634         return _tokenApprovals[tokenId];
635     }
636 
637     /**
638      * @dev See {IERC721-setApprovalForAll}.
639      */
640     function setApprovalForAll(address operator, bool approved) public virtual override {
641         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
642 
643         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
644         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
645     }
646 
647     /**
648      * @dev See {IERC721-isApprovedForAll}.
649      */
650     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
651         return _operatorApprovals[owner][operator];
652     }
653 
654     /**
655      * @dev See {IERC721-transferFrom}.
656      */
657     function transferFrom(
658             address from,
659             address to,
660             uint256 tokenId
661             ) public virtual override {
662         _transfer(from, to, tokenId);
663     }
664 
665     /**
666      * @dev See {IERC721-safeTransferFrom}.
667      */
668     function safeTransferFrom(
669             address from,
670             address to,
671             uint256 tokenId
672             ) public virtual override {
673         safeTransferFrom(from, to, tokenId, '');
674     }
675 
676     /**
677      * @dev See {IERC721-safeTransferFrom}.
678      */
679     function safeTransferFrom(
680             address from,
681             address to,
682             uint256 tokenId,
683             bytes memory _data
684             ) public virtual override {
685         _transfer(from, to, tokenId);
686     }
687 
688     /**
689      * @dev Returns whether `tokenId` exists.
690      *
691      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
692      *
693      * Tokens start existing when they are minted (`_mint`),
694      */
695     function _exists(uint256 tokenId) internal view returns (bool) {
696         return
697             _startTokenId() <= tokenId &&
698             tokenId < _currentIndex;
699     }
700 
701     /**
702      * @dev Equivalent to `_safeMint(to, quantity, '')`.
703      */
704      /*
705     function _safeMint(address to, uint256 quantity) internal {
706         _safeMint(to, quantity, '');
707     }
708     */
709 
710     /**
711      * @dev Safely mints `quantity` tokens and transfers them to `to`.
712      *
713      * Requirements:
714      *
715      * - If `to` refers to a smart contract, it must implement
716      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
717      * - `quantity` must be greater than 0.
718      *
719      * Emits a {Transfer} event.
720      */
721      /*
722     function _safeMint(
723             address to,
724             uint256 quantity,
725             bytes memory _data
726             ) internal {
727         uint256 startTokenId = _currentIndex;
728         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
729         if (quantity == 0) revert MintZeroQuantity();
730 
731 
732         // Overflows are incredibly unrealistic.
733         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
734         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
735         unchecked {
736             // Updates:
737             // - `balance += quantity`.
738             // - `numberMinted += quantity`.
739             //
740             // We can directly add to the balance and number minted.
741             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
742 
743             // Updates:
744             // - `address` to the owner.
745             // - `startTimestamp` to the timestamp of minting.
746             // - `burned` to `false`.
747             // - `nextInitialized` to `quantity == 1`.
748             _packedOwnerships[startTokenId] =
749                 _addressToUint256(to) |
750                 (block.timestamp << BITPOS_START_TIMESTAMP) |
751                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
752 
753             uint256 updatedIndex = startTokenId;
754             uint256 end = updatedIndex + quantity;
755 
756             if (to.code.length != 0) {
757                 do {
758                     emit Transfer(address(0), to, updatedIndex);
759                 } while (updatedIndex < end);
760                 // Reentrancy protection
761                 if (_currentIndex != startTokenId) revert();
762             } else {
763                 do {
764                     emit Transfer(address(0), to, updatedIndex++);
765                 } while (updatedIndex < end);
766             }
767             _currentIndex = updatedIndex;
768         }
769         _afterTokenTransfers(address(0), to, startTokenId, quantity);
770     }
771     */
772 
773     /**
774      * @dev Mints `quantity` tokens and transfers them to `to`.
775      *
776      * Requirements:
777      *
778      * - `to` cannot be the zero address.
779      * - `quantity` must be greater than 0.
780      *
781      * Emits a {Transfer} event.
782      */
783     function _mint(address to, uint256 quantity) internal {
784         uint256 startTokenId = _currentIndex;
785         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
786         if (quantity == 0) revert MintZeroQuantity();
787 
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
798             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
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
833             address from,
834             address to,
835             uint256 tokenId
836             ) private {
837 
838         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
839 
840         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
841 
842         address approvedAddress = _tokenApprovals[tokenId];
843 
844         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
845                 isApprovedForAll(from, _msgSenderERC721A()) ||
846                 approvedAddress == _msgSenderERC721A());
847 
848         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
849 
850         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
851 
852 
853         // Clear approvals from the previous owner.
854         if (_addressToUint256(approvedAddress) != 0) {
855             delete _tokenApprovals[tokenId];
856         }
857 
858         // Underflow of the sender's balance is impossible because we check for
859         // ownership above and the recipient's balance can't realistically overflow.
860         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
861         unchecked {
862             // We can directly increment and decrement the balances.
863             --_packedAddressData[from]; // Updates: `balance -= 1`.
864             ++_packedAddressData[to]; // Updates: `balance += 1`.
865 
866             // Updates:
867             // - `address` to the next owner.
868             // - `startTimestamp` to the timestamp of transfering.
869             // - `burned` to `false`.
870             // - `nextInitialized` to `true`.
871             _packedOwnerships[tokenId] =
872                 _addressToUint256(to) |
873                 (block.timestamp << BITPOS_START_TIMESTAMP) |
874                 BITMASK_NEXT_INITIALIZED;
875 
876             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
877             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
878                 uint256 nextTokenId = tokenId + 1;
879                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
880                 if (_packedOwnerships[nextTokenId] == 0) {
881                     // If the next slot is within bounds.
882                     if (nextTokenId != _currentIndex) {
883                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
884                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
885                     }
886                 }
887             }
888         }
889 
890         emit Transfer(from, to, tokenId);
891         _afterTokenTransfers(from, to, tokenId, 1);
892     }
893 
894 
895 
896 
897     /**
898      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
899      * minting.
900      * And also called after one token has been burned.
901      *
902      * startTokenId - the first token id to be transferred
903      * quantity - the amount to be transferred
904      *
905      * Calling conditions:
906      *
907      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
908      * transferred to `to`.
909      * - When `from` is zero, `tokenId` has been minted for `to`.
910      * - When `to` is zero, `tokenId` has been burned by `from`.
911      * - `from` and `to` are never both zero.
912      */
913     function _afterTokenTransfers(
914             address from,
915             address to,
916             uint256 startTokenId,
917             uint256 quantity
918             ) internal virtual {}
919 
920     /**
921      * @dev Returns the message sender (defaults to `msg.sender`).
922      *
923      * If you are writing GSN compatible contracts, you need to override this function.
924      */
925     function _msgSenderERC721A() internal view virtual returns (address) {
926         return msg.sender;
927     }
928 
929     /**
930      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
931      */
932     function _toString(uint256 value) internal pure returns (string memory ptr) {
933         assembly {
934             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
935             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
936             // We will need 1 32-byte word to store the length, 
937             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
938             ptr := add(mload(0x40), 128)
939 
940          // Update the free memory pointer to allocate.
941          mstore(0x40, ptr)
942 
943          // Cache the end of the memory to calculate the length later.
944          let end := ptr
945 
946          // We write the string from the rightmost digit to the leftmost digit.
947          // The following is essentially a do-while loop that also handles the zero case.
948          // Costs a bit more than early returning for the zero case,
949          // but cheaper in terms of deployment and overall runtime costs.
950          for { 
951              // Initialize and perform the first pass without check.
952              let temp := value
953                  // Move the pointer 1 byte leftwards to point to an empty character slot.
954                  ptr := sub(ptr, 1)
955                  // Write the character to the pointer. 48 is the ASCII index of '0'.
956                  mstore8(ptr, add(48, mod(temp, 10)))
957                  temp := div(temp, 10)
958          } temp { 
959              // Keep dividing `temp` until zero.
960         temp := div(temp, 10)
961          } { 
962              // Body of the for loop.
963         ptr := sub(ptr, 1)
964          mstore8(ptr, add(48, mod(temp, 10)))
965          }
966 
967      let length := sub(end, ptr)
968          // Move the pointer 32 bytes leftwards to make room for the length.
969          ptr := sub(ptr, 32)
970          // Store the length.
971          mstore(ptr, length)
972         }
973     }
974 
975     function withdraw() external onlyOwner {
976         uint256 balance = address(this).balance;
977         payable(msg.sender).transfer(balance);
978     }
979 }