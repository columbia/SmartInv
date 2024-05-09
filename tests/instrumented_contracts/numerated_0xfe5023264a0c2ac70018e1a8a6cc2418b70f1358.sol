1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 /**
5  * @dev Interface of an ERC721A compliant contract.
6  */
7 interface IERC721A {
8     /**
9      * The caller must own the token or be an approved operator.
10      */
11     error ApprovalCallerNotOwnerNorApproved();
12 
13     /**
14      * The token does not exist.
15      */
16     error ApprovalQueryForNonexistentToken();
17 
18     /**
19      * The caller cannot approve to their own address.
20      */
21     error ApproveToCaller();
22 
23     /**
24      * The caller cannot approve to the current owner.
25      */
26     error ApprovalToCurrentOwner();
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
59      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
60      */
61     error TransferToNonERC721ReceiverImplementer();
62 
63     /**
64      * Cannot transfer to the zero address.
65      */
66     error TransferToZeroAddress();
67 
68     /**
69      * The token does not exist.
70      */
71     error URIQueryForNonexistentToken();
72 
73     struct TokenOwnership {
74         // The address of the owner.
75         address addr;
76         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
77         uint64 startTimestamp;
78         // Whether the token has been burned.
79         bool burned;
80     }
81 
82     /**
83      * @dev Returns the total amount of tokens stored by the contract.
84      *
85      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
86      */
87     //function totalSupply() external view returns (uint256);
88 
89     // ==============================
90     //            IERC165
91     // ==============================
92 
93     /**
94      * @dev Returns true if this contract implements the interface defined by
95      * `interfaceId`. See the corresponding
96      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
97      * to learn more about how these ids are created.
98      *
99      * This function call must use less than 30 000 gas.
100      */
101     function supportsInterface(bytes4 interfaceId) external view returns (bool);
102 
103     // ==============================
104     //            IERC721
105     // ==============================
106 
107     /**
108      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
111 
112     /**
113      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
114      */
115     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
119      */
120     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
121 
122     /**
123      * @dev Returns the number of tokens in ``owner``'s account.
124      */
125     function balanceOf(address owner) external view returns (uint256 balance);
126 
127     /**
128      * @dev Returns the owner of the `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function ownerOf(uint256 tokenId) external view returns (address owner);
135 
136     /**
137      * @dev Safely transfers `tokenId` token from `from` to `to`.
138      *
139      * Requirements:
140      *
141      * - `from` cannot be the zero address.
142      * - `to` cannot be the zero address.
143      * - `tokenId` token must exist and be owned by `from`.
144      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
146      *
147      * Emits a {Transfer} event.
148      */
149     function safeTransferFrom(
150         address from,
151         address to,
152         uint256 tokenId,
153         bytes calldata data
154     ) external;
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
158      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId
174     ) external;
175 
176     /**
177      * @dev Transfers `tokenId` token from `from` to `to`.
178      *
179      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
198      * The approval is cleared when the token is transferred.
199      *
200      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
201      *
202      * Requirements:
203      *
204      * - The caller must own the token or be an approved operator.
205      * - `tokenId` must exist.
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address to, uint256 tokenId) external;
210 
211     /**
212      * @dev Approve or remove `operator` as an operator for the caller.
213      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
214      *
215      * Requirements:
216      *
217      * - The `operator` cannot be the caller.
218      *
219      * Emits an {ApprovalForAll} event.
220      */
221     function setApprovalForAll(address operator, bool _approved) external;
222 
223     /**
224      * @dev Returns the account approved for `tokenId` token.
225      *
226      * Requirements:
227      *
228      * - `tokenId` must exist.
229      */
230     function getApproved(uint256 tokenId) external view returns (address operator);
231 
232     /**
233      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
234      *
235      * See {setApprovalForAll}
236      */
237     function isApprovedForAll(address owner, address operator) external view returns (bool);
238 
239     // ==============================
240     //        IERC721Metadata
241     // ==============================
242 
243     /**
244      * @dev Returns the token collection name.
245      */
246     function name() external view returns (string memory);
247 
248     /**
249      * @dev Returns the token collection symbol.
250      */
251     function symbol() external view returns (string memory);
252 
253     /**
254      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
255      */
256     function tokenURI(uint256 tokenId) external view returns (string memory);
257 }
258 
259 
260 // ERC721A Contracts v3.3.0
261 // Creator: Chiru Labs
262 /**
263  * @dev ERC721 token receiver interface.
264  */
265 interface ERC721A__IERC721Receiver {
266     function onERC721Received(
267         address operator,
268         address from,
269         uint256 tokenId,
270         bytes calldata data
271     ) external returns (bytes4);
272 }
273 
274 /**
275  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
276  * the Metadata extension. Built to optimize for lower gas during batch mints.
277  *
278  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
279  *
280  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
281  *
282  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
283  */
284 contract ERC721A is IERC721A {
285     // Mask of an entry in packed address data.
286     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
287 
288     // The bit position of `numberMinted` in packed address data.
289     uint256 private constant BITPOS_NUMBER_MINTED = 64;
290 
291     // The bit position of `numberBurned` in packed address data.
292     uint256 private constant BITPOS_NUMBER_BURNED = 128;
293 
294     // The bit position of `aux` in packed address data.
295     uint256 private constant BITPOS_AUX = 192;
296 
297     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
298     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
299 
300     // The bit position of `startTimestamp` in packed ownership.
301     uint256 private constant BITPOS_START_TIMESTAMP = 160;
302 
303     // The bit mask of the `burned` bit in packed ownership.
304     uint256 private constant BITMASK_BURNED = 1 << 224;
305     
306     // The bit position of the `nextInitialized` bit in packed ownership.
307     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
308 
309     // The bit mask of the `nextInitialized` bit in packed ownership.
310     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
311 
312     // The tokenId of the next token to be minted.
313     uint256 private _currentIndex;
314 
315     // The number of tokens burned.
316     uint256 private _burnCounter;
317 
318     // Token name
319     string private _name;
320 
321     // Token symbol
322     string private _symbol;
323 
324     // Mapping from token ID to ownership details
325     // An empty struct value does not necessarily mean the token is unowned.
326     // See `_packedOwnershipOf` implementation for details.
327     //
328     // Bits Layout:
329     // - [0..159]   `addr`
330     // - [160..223] `startTimestamp`
331     // - [224]      `burned`
332     // - [225]      `nextInitialized`
333     mapping(uint256 => uint256) private _packedOwnerships;
334 
335     // Mapping owner address to address data.
336     //
337     // Bits Layout:
338     // - [0..63]    `balance`
339     // - [64..127]  `numberMinted`
340     // - [128..191] `numberBurned`
341     // - [192..255] `aux`
342     mapping(address => uint256) private _packedAddressData;
343 
344     // Mapping from token ID to approved address.
345     mapping(uint256 => address) private _tokenApprovals;
346 
347     // Mapping from owner to operator approvals
348     mapping(address => mapping(address => bool)) private _operatorApprovals;
349 
350     constructor(string memory name_, string memory symbol_) {
351         _name = name_;
352         _symbol = symbol_;
353         _currentIndex = _startTokenId();
354     }
355     
356     function _setName(string memory name_) internal {
357         _name = name_;
358     }
359     
360     function _setSymbol(string memory symbol_) internal {
361         _symbol = symbol_;
362     }
363 
364     /**
365      * @dev Returns the starting token ID. 
366      * To change the starting token ID, please override this function.
367      */
368     function _startTokenId() internal view virtual returns (uint256) {
369         return 0;
370     }
371 
372     /**
373      * @dev Returns the next token ID to be minted.
374      */
375     function _nextTokenId() internal view returns (uint256) {
376         return _currentIndex;
377     }
378 
379     /**
380      * @dev Returns the total number of tokens in existence.
381      * Burned tokens will reduce the count. 
382      * To get the total number of tokens minted, please see `_totalMinted`.
383      */
384     function totalSupply() public view virtual returns (uint256) {
385         // Counter underflow is impossible as _burnCounter cannot be incremented
386         // more than `_currentIndex - _startTokenId()` times.
387         unchecked {
388             return _currentIndex - _burnCounter - _startTokenId();
389         }
390     }
391 
392     /**
393      * @dev Returns the total amount of tokens minted in the contract.
394      */
395     function _totalMinted() internal view returns (uint256) {
396         // Counter underflow is impossible as _currentIndex does not decrement,
397         // and it is initialized to `_startTokenId()`
398         unchecked {
399             return _currentIndex - _startTokenId();
400         }
401     }
402 
403     /**
404      * @dev Returns the total number of tokens burned.
405      */
406     function _totalBurned() internal view returns (uint256) {
407         return _burnCounter;
408     }
409 
410     /**
411      * @dev See {IERC165-supportsInterface}.
412      */
413     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
414         // The interface IDs are constants representing the first 4 bytes of the XOR of
415         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
416         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
417         return
418             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
419             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
420             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
421     }
422 
423     /**
424      * @dev See {IERC721-balanceOf}.
425      */
426     function balanceOf(address owner) public view override returns (uint256) {
427         if (owner == address(0)) revert BalanceQueryForZeroAddress();
428         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
429     }
430 
431     /**
432      * Returns the number of tokens minted by `owner`.
433      */
434     function _numberMinted(address owner) internal view returns (uint256) {
435         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
436     }
437 
438     /**
439      * Returns the number of tokens burned by or on behalf of `owner`.
440      */
441     function _numberBurned(address owner) internal view returns (uint256) {
442         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
443     }
444 
445     /**
446      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
447      */
448     function _getAux(address owner) internal view returns (uint64) {
449         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
450     }
451 
452     /**
453      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
454      * If there are multiple variables, please pack them into a uint64.
455      */
456     function _setAux(address owner, uint64 aux) internal {
457         uint256 packed = _packedAddressData[owner];
458         uint256 auxCasted;
459         assembly { // Cast aux without masking.
460             auxCasted := aux
461         }
462         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
463         _packedAddressData[owner] = packed;
464     }
465 
466     /**
467      * Returns the packed ownership data of `tokenId`.
468      */
469     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
470         uint256 curr = tokenId;
471 
472         unchecked {
473             if (_startTokenId() <= curr)
474                 if (curr < _currentIndex) {
475                     uint256 packed = _packedOwnerships[curr];
476                     // If not burned.
477                     if (packed & BITMASK_BURNED == 0) {
478                         // Invariant:
479                         // There will always be an ownership that has an address and is not burned
480                         // before an ownership that does not have an address and is not burned.
481                         // Hence, curr will not underflow.
482                         //
483                         // We can directly compare the packed value.
484                         // If the address is zero, packed is zero.
485                         while (packed == 0) {
486                             packed = _packedOwnerships[--curr];
487                         }
488                         return packed;
489                     }
490                 }
491         }
492         revert OwnerQueryForNonexistentToken();
493     }
494 
495     /**
496      * Returns the unpacked `TokenOwnership` struct from `packed`.
497      */
498     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
499         ownership.addr = address(uint160(packed));
500         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
501         ownership.burned = packed & BITMASK_BURNED != 0;
502     }
503 
504     /**
505      * Returns the unpacked `TokenOwnership` struct at `index`.
506      */
507     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
508         return _unpackedOwnership(_packedOwnerships[index]);
509     }
510 
511     /**
512      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
513      */
514     function _initializeOwnershipAt(uint256 index) internal {
515         if (_packedOwnerships[index] == 0) {
516             _packedOwnerships[index] = _packedOwnershipOf(index);
517         }
518     }
519 
520     /**
521      * Gas spent here starts off proportional to the maximum mint batch size.
522      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
523      */
524     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
525         return _unpackedOwnership(_packedOwnershipOf(tokenId));
526     }
527 
528     /**
529      * @dev See {IERC721-ownerOf}.
530      */
531     function ownerOf(uint256 tokenId) public view override returns (address) {
532         return address(uint160(_packedOwnershipOf(tokenId)));
533     }
534 
535     /**
536      * @dev See {IERC721Metadata-name}.
537      */
538     function name() public view virtual override returns (string memory) {
539         return _name;
540     }
541 
542     /**
543      * @dev See {IERC721Metadata-symbol}.
544      */
545     function symbol() public view virtual override returns (string memory) {
546         return _symbol;
547     }
548 
549     /**
550      * @dev See {IERC721Metadata-tokenURI}.
551      */
552     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
553         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
554 
555         string memory baseURI = _baseURI();
556         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
557     }
558 
559     /**
560      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
561      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
562      * by default, can be overriden in child contracts.
563      */
564     function _baseURI() internal view virtual returns (string memory) {
565         return '';
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
591         if (to == owner) revert ApprovalToCurrentOwner();
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
632         address from,
633         address to,
634         uint256 tokenId
635     ) public virtual override {
636         _transfer(from, to, tokenId);
637     }
638 
639     /**
640      * @dev See {IERC721-safeTransferFrom}.
641      */
642     function safeTransferFrom(
643         address from,
644         address to,
645         uint256 tokenId
646     ) public virtual override {
647         safeTransferFrom(from, to, tokenId, '');
648     }
649 
650     /**
651      * @dev See {IERC721-safeTransferFrom}.
652      */
653     function safeTransferFrom(
654         address from,
655         address to,
656         uint256 tokenId,
657         bytes memory _data
658     ) public virtual override {
659         _transfer(from, to, tokenId);
660         if (to.code.length != 0)
661             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
662                 revert TransferToNonERC721ReceiverImplementer();
663             }
664     }
665 
666     /**
667      * @dev Returns whether `tokenId` exists.
668      *
669      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
670      *
671      * Tokens start existing when they are minted (`_mint`),
672      */
673     function _exists(uint256 tokenId) internal view returns (bool) {
674         return
675             _startTokenId() <= tokenId &&
676             tokenId < _currentIndex && // If within bounds,
677             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
678     }
679 
680     /**
681      * @dev Equivalent to `_safeMint(to, quantity, '')`.
682      */
683     function _safeMint(address to, uint256 quantity) internal {
684         _safeMint(to, quantity, '');
685     }
686 
687     /**
688      * @dev Safely mints `quantity` tokens and transfers them to `to`.
689      *
690      * Requirements:
691      *
692      * - If `to` refers to a smart contract, it must implement
693      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
694      * - `quantity` must be greater than 0.
695      *
696      * Emits a {Transfer} event.
697      */
698     function _safeMint(
699         address to,
700         uint256 quantity,
701         bytes memory _data
702     ) internal {
703         uint256 startTokenId = _currentIndex;
704         if (to == address(0)) revert MintToZeroAddress();
705         if (quantity == 0) revert MintZeroQuantity();
706 
707         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
708 
709         // Overflows are incredibly unrealistic.
710         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
711         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
712         unchecked {
713             // Updates:
714             // - `balance += quantity`.
715             // - `numberMinted += quantity`.
716             //
717             // We can directly add to the balance and number minted.
718             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
719 
720             // Updates:
721             // - `address` to the owner.
722             // - `startTimestamp` to the timestamp of minting.
723             // - `burned` to `false`.
724             // - `nextInitialized` to `quantity == 1`.
725             _packedOwnerships[startTokenId] =
726                 _addressToUint256(to) |
727                 (block.timestamp << BITPOS_START_TIMESTAMP) |
728                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
729 
730             uint256 updatedIndex = startTokenId;
731             uint256 end = updatedIndex + quantity;
732 
733             if (to.code.length != 0) {
734                 do {
735                     emit Transfer(address(0), to, updatedIndex);
736                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
737                         revert TransferToNonERC721ReceiverImplementer();
738                     }
739                 } while (updatedIndex < end);
740                 // Reentrancy protection
741                 if (_currentIndex != startTokenId) revert();
742             } else {
743                 do {
744                     emit Transfer(address(0), to, updatedIndex++);
745                 } while (updatedIndex < end);
746             }
747             _currentIndex = updatedIndex;
748         }
749         _afterTokenTransfers(address(0), to, startTokenId, quantity);
750     }
751 
752     /**
753      * @dev Mints `quantity` tokens and transfers them to `to`.
754      *
755      * Requirements:
756      *
757      * - `to` cannot be the zero address.
758      * - `quantity` must be greater than 0.
759      *
760      * Emits a {Transfer} event.
761      */
762     function _mint(address to, uint256 quantity) internal {
763         uint256 startTokenId = _currentIndex;
764         if (to == address(0)) revert MintToZeroAddress();
765         if (quantity == 0) revert MintZeroQuantity();
766 
767         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
768 
769         // Overflows are incredibly unrealistic.
770         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
771         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
772         unchecked {
773             // Updates:
774             // - `balance += quantity`.
775             // - `numberMinted += quantity`.
776             //
777             // We can directly add to the balance and number minted.
778             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
779 
780             // Updates:
781             // - `address` to the owner.
782             // - `startTimestamp` to the timestamp of minting.
783             // - `burned` to `false`.
784             // - `nextInitialized` to `quantity == 1`.
785             _packedOwnerships[startTokenId] =
786                 _addressToUint256(to) |
787                 (block.timestamp << BITPOS_START_TIMESTAMP) |
788                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
789 
790             uint256 updatedIndex = startTokenId;
791             uint256 end = updatedIndex + quantity;
792 
793             do {
794                 emit Transfer(address(0), to, updatedIndex++);
795             } while (updatedIndex < end);
796 
797             _currentIndex = updatedIndex;
798         }
799         _afterTokenTransfers(address(0), to, startTokenId, quantity);
800     }
801 
802     /**
803      * @dev Transfers `tokenId` from `from` to `to`.
804      *
805      * Requirements:
806      *
807      * - `to` cannot be the zero address.
808      * - `tokenId` token must be owned by `from`.
809      *
810      * Emits a {Transfer} event.
811      */
812     function _transfer(
813         address from,
814         address to,
815         uint256 tokenId
816     ) private {
817         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
818 
819         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
820 
821         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
822             isApprovedForAll(from, _msgSenderERC721A()) ||
823             getApproved(tokenId) == _msgSenderERC721A());
824 
825         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
826         if (to == address(0)) revert TransferToZeroAddress();
827 
828         _beforeTokenTransfers(from, to, tokenId, 1);
829 
830         // Clear approvals from the previous owner.
831         delete _tokenApprovals[tokenId];
832 
833         // Underflow of the sender's balance is impossible because we check for
834         // ownership above and the recipient's balance can't realistically overflow.
835         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
836         unchecked {
837             // We can directly increment and decrement the balances.
838             --_packedAddressData[from]; // Updates: `balance -= 1`.
839             ++_packedAddressData[to]; // Updates: `balance += 1`.
840 
841             // Updates:
842             // - `address` to the next owner.
843             // - `startTimestamp` to the timestamp of transfering.
844             // - `burned` to `false`.
845             // - `nextInitialized` to `true`.
846             _packedOwnerships[tokenId] =
847                 _addressToUint256(to) |
848                 (block.timestamp << BITPOS_START_TIMESTAMP) |
849                 BITMASK_NEXT_INITIALIZED;
850 
851             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
852             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
853                 uint256 nextTokenId = tokenId + 1;
854                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
855                 if (_packedOwnerships[nextTokenId] == 0) {
856                     // If the next slot is within bounds.
857                     if (nextTokenId != _currentIndex) {
858                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
859                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
860                     }
861                 }
862             }
863         }
864 
865         emit Transfer(from, to, tokenId);
866         _afterTokenTransfers(from, to, tokenId, 1);
867     }
868 
869     /**
870      * @dev Equivalent to `_burn(tokenId, false)`.
871      */
872     function _burn(uint256 tokenId) internal virtual {
873         _burn(tokenId, false);
874     }
875 
876     /**
877      * @dev Destroys `tokenId`.
878      * The approval is cleared when the token is burned.
879      *
880      * Requirements:
881      *
882      * - `tokenId` must exist.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
887         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
888 
889         address from = address(uint160(prevOwnershipPacked));
890 
891         if (approvalCheck) {
892             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
893                 isApprovedForAll(from, _msgSenderERC721A()) ||
894                 getApproved(tokenId) == _msgSenderERC721A());
895 
896             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
897         }
898 
899         _beforeTokenTransfers(from, address(0), tokenId, 1);
900 
901         // Clear approvals from the previous owner.
902         delete _tokenApprovals[tokenId];
903 
904         // Underflow of the sender's balance is impossible because we check for
905         // ownership above and the recipient's balance can't realistically overflow.
906         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
907         unchecked {
908             // Updates:
909             // - `balance -= 1`.
910             // - `numberBurned += 1`.
911             //
912             // We can directly decrement the balance, and increment the number burned.
913             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
914             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
915 
916             // Updates:
917             // - `address` to the last owner.
918             // - `startTimestamp` to the timestamp of burning.
919             // - `burned` to `true`.
920             // - `nextInitialized` to `true`.
921             _packedOwnerships[tokenId] =
922                 _addressToUint256(from) |
923                 (block.timestamp << BITPOS_START_TIMESTAMP) |
924                 BITMASK_BURNED | 
925                 BITMASK_NEXT_INITIALIZED;
926 
927             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
928             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
929                 uint256 nextTokenId = tokenId + 1;
930                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
931                 if (_packedOwnerships[nextTokenId] == 0) {
932                     // If the next slot is within bounds.
933                     if (nextTokenId != _currentIndex) {
934                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
935                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
936                     }
937                 }
938             }
939         }
940 
941         emit Transfer(from, address(0), tokenId);
942         _afterTokenTransfers(from, address(0), tokenId, 1);
943 
944         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
945         unchecked {
946             _burnCounter++;
947         }
948     }
949 
950     /**
951      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
952      *
953      * @param from address representing the previous owner of the given token ID
954      * @param to target address that will receive the tokens
955      * @param tokenId uint256 ID of the token to be transferred
956      * @param _data bytes optional data to send along with the call
957      * @return bool whether the call correctly returned the expected magic value
958      */
959     function _checkContractOnERC721Received(
960         address from,
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) private returns (bool) {
965         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
966             bytes4 retval
967         ) {
968             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
969         } catch (bytes memory reason) {
970             if (reason.length == 0) {
971                 revert TransferToNonERC721ReceiverImplementer();
972             } else {
973                 assembly {
974                     revert(add(32, reason), mload(reason))
975                 }
976             }
977         }
978     }
979 
980     /**
981      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
982      * And also called before burning one token.
983      *
984      * startTokenId - the first token id to be transferred
985      * quantity - the amount to be transferred
986      *
987      * Calling conditions:
988      *
989      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
990      * transferred to `to`.
991      * - When `from` is zero, `tokenId` will be minted for `to`.
992      * - When `to` is zero, `tokenId` will be burned by `from`.
993      * - `from` and `to` are never both zero.
994      */
995     function _beforeTokenTransfers(
996         address from,
997         address to,
998         uint256 startTokenId,
999         uint256 quantity
1000     ) internal virtual {}
1001 
1002     /**
1003      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1004      * minting.
1005      * And also called after one token has been burned.
1006      *
1007      * startTokenId - the first token id to be transferred
1008      * quantity - the amount to be transferred
1009      *
1010      * Calling conditions:
1011      *
1012      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1013      * transferred to `to`.
1014      * - When `from` is zero, `tokenId` has been minted for `to`.
1015      * - When `to` is zero, `tokenId` has been burned by `from`.
1016      * - `from` and `to` are never both zero.
1017      */
1018     function _afterTokenTransfers(
1019         address from,
1020         address to,
1021         uint256 startTokenId,
1022         uint256 quantity
1023     ) internal virtual {}
1024 
1025     /**
1026      * @dev Returns the message sender (defaults to `msg.sender`).
1027      *
1028      * If you are writing GSN compatible contracts, you need to override this function.
1029      */
1030     function _msgSenderERC721A() internal view virtual returns (address) {
1031         return msg.sender;
1032     }
1033 
1034     /**
1035      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1036      */
1037     function _toString(uint256 value) internal pure returns (string memory ptr) {
1038         assembly {
1039             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1040             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1041             // We will need 1 32-byte word to store the length, 
1042             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1043             ptr := add(mload(0x40), 128)
1044             // Update the free memory pointer to allocate.
1045             mstore(0x40, ptr)
1046 
1047             // Cache the end of the memory to calculate the length later.
1048             let end := ptr
1049 
1050             // We write the string from the rightmost digit to the leftmost digit.
1051             // The following is essentially a do-while loop that also handles the zero case.
1052             // Costs a bit more than early returning for the zero case,
1053             // but cheaper in terms of deployment and overall runtime costs.
1054             for { 
1055                 // Initialize and perform the first pass without check.
1056                 let temp := value
1057                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1058                 ptr := sub(ptr, 1)
1059                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1060                 mstore8(ptr, add(48, mod(temp, 10)))
1061                 temp := div(temp, 10)
1062             } temp { 
1063                 // Keep dividing `temp` until zero.
1064                 temp := div(temp, 10)
1065             } { // Body of the for loop.
1066                 ptr := sub(ptr, 1)
1067                 mstore8(ptr, add(48, mod(temp, 10)))
1068             }
1069             
1070             let length := sub(end, ptr)
1071             // Move the pointer 32 bytes leftwards to make room for the length.
1072             ptr := sub(ptr, 32)
1073             // Store the length.
1074             mstore(ptr, length)
1075         }
1076     }
1077 }
1078 
1079 
1080 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1081 /**
1082  * @dev Provides information about the current execution context, including the
1083  * sender of the transaction and its data. While these are generally available
1084  * via msg.sender and msg.data, they should not be accessed in such a direct
1085  * manner, since when dealing with meta-transactions the account sending and
1086  * paying for execution may not be the actual sender (as far as an application
1087  * is concerned).
1088  *
1089  * This contract is only required for intermediate, library-like contracts.
1090  */
1091 abstract contract Context {
1092     function _msgSender() internal view virtual returns (address) {
1093         return msg.sender;
1094     }
1095 
1096     function _msgData() internal view virtual returns (bytes calldata) {
1097         return msg.data;
1098     }
1099 }
1100 
1101 
1102 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1103 /**
1104  * @dev Contract module which provides a basic access control mechanism, where
1105  * there is an account (an owner) that can be granted exclusive access to
1106  * specific functions.
1107  *
1108  * By default, the owner account will be the one that deploys the contract. This
1109  * can later be changed with {transferOwnership}.
1110  *
1111  * This module is used through inheritance. It will make available the modifier
1112  * `onlyOwner`, which can be applied to your functions to restrict their use to
1113  * the owner.
1114  */
1115 abstract contract Ownable is Context {
1116     address private _owner;
1117 
1118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1119 
1120     /**
1121      * @dev Initializes the contract setting the deployer as the initial owner.
1122      */
1123     constructor() {
1124         _transferOwnership(_msgSender());
1125     }
1126 
1127     /**
1128      * @dev Returns the address of the current owner.
1129      */
1130     function owner() public view virtual returns (address) {
1131         return _owner;
1132     }
1133 
1134     /**
1135      * @dev Throws if called by any account other than the owner.
1136      */
1137     modifier onlyOwner() {
1138         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1139         _;
1140     }
1141 
1142     /**
1143      * @dev Leaves the contract without owner. It will not be possible to call
1144      * `onlyOwner` functions anymore. Can only be called by the current owner.
1145      *
1146      * NOTE: Renouncing ownership will leave the contract without an owner,
1147      * thereby removing any functionality that is only available to the owner.
1148      */
1149     function renounceOwnership() public virtual onlyOwner {
1150         _transferOwnership(address(0));
1151     }
1152 
1153     /**
1154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1155      * Can only be called by the current owner.
1156      */
1157     function transferOwnership(address newOwner) public virtual onlyOwner {
1158         require(newOwner != address(0), "Ownable: new owner is the zero address");
1159         _transferOwnership(newOwner);
1160     }
1161 
1162     /**
1163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1164      * Internal function without access restriction.
1165      */
1166     function _transferOwnership(address newOwner) internal virtual {
1167         address oldOwner = _owner;
1168         _owner = newOwner;
1169         emit OwnershipTransferred(oldOwner, newOwner);
1170     }
1171 }
1172 
1173 
1174 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1175 /**
1176  * @dev String operations.
1177  */
1178 library Strings {
1179     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1180 
1181     /**
1182      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1183      */
1184     function toString(uint256 value) internal pure returns (string memory) {
1185         // Inspired by OraclizeAPI's implementation - MIT licence
1186         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1187 
1188         if (value == 0) {
1189             return "0";
1190         }
1191         uint256 temp = value;
1192         uint256 digits;
1193         while (temp != 0) {
1194             digits++;
1195             temp /= 10;
1196         }
1197         bytes memory buffer = new bytes(digits);
1198         while (value != 0) {
1199             digits -= 1;
1200             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1201             value /= 10;
1202         }
1203         return string(buffer);
1204     }
1205 
1206     /**
1207      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1208      */
1209     function toHexString(uint256 value) internal pure returns (string memory) {
1210         if (value == 0) {
1211             return "0x00";
1212         }
1213         uint256 temp = value;
1214         uint256 length = 0;
1215         while (temp != 0) {
1216             length++;
1217             temp >>= 8;
1218         }
1219         return toHexString(value, length);
1220     }
1221 
1222     /**
1223      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1224      */
1225     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1226         bytes memory buffer = new bytes(2 * length + 2);
1227         buffer[0] = "0";
1228         buffer[1] = "x";
1229         for (uint256 i = 2 * length + 1; i > 1; --i) {
1230             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1231             value >>= 4;
1232         }
1233         require(value == 0, "Strings: hex length insufficient");
1234         return string(buffer);
1235     }
1236 }
1237 
1238 
1239 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
1240 /**
1241  * @dev Collection of functions related to the address type
1242  */
1243 library Address {
1244     /**
1245      * @dev Returns true if `account` is a contract.
1246      *
1247      * [IMPORTANT]
1248      * ====
1249      * It is unsafe to assume that an address for which this function returns
1250      * false is an externally-owned account (EOA) and not a contract.
1251      *
1252      * Among others, `isContract` will return false for the following
1253      * types of addresses:
1254      *
1255      *  - an externally-owned account
1256      *  - a contract in construction
1257      *  - an address where a contract will be created
1258      *  - an address where a contract lived, but was destroyed
1259      * ====
1260      *
1261      * [IMPORTANT]
1262      * ====
1263      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1264      *
1265      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1266      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1267      * constructor.
1268      * ====
1269      */
1270     function isContract(address account) internal view returns (bool) {
1271         // This method relies on extcodesize/address.code.length, which returns 0
1272         // for contracts in construction, since the code is only stored at the end
1273         // of the constructor execution.
1274 
1275         return account.code.length > 0;
1276     }
1277 
1278     /**
1279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1280      * `recipient`, forwarding all available gas and reverting on errors.
1281      *
1282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1284      * imposed by `transfer`, making them unable to receive funds via
1285      * `transfer`. {sendValue} removes this limitation.
1286      *
1287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1288      *
1289      * IMPORTANT: because control is transferred to `recipient`, care must be
1290      * taken to not create reentrancy vulnerabilities. Consider using
1291      * {ReentrancyGuard} or the
1292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1293      */
1294     function sendValue(address payable recipient, uint256 amount) internal {
1295         require(address(this).balance >= amount, "Address: insufficient balance");
1296 
1297         (bool success, ) = recipient.call{value: amount}("");
1298         require(success, "Address: unable to send value, recipient may have reverted");
1299     }
1300 
1301     /**
1302      * @dev Performs a Solidity function call using a low level `call`. A
1303      * plain `call` is an unsafe replacement for a function call: use this
1304      * function instead.
1305      *
1306      * If `target` reverts with a revert reason, it is bubbled up by this
1307      * function (like regular Solidity function calls).
1308      *
1309      * Returns the raw returned data. To convert to the expected return value,
1310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1311      *
1312      * Requirements:
1313      *
1314      * - `target` must be a contract.
1315      * - calling `target` with `data` must not revert.
1316      *
1317      * _Available since v3.1._
1318      */
1319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1320         return functionCall(target, data, "Address: low-level call failed");
1321     }
1322 
1323     /**
1324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1325      * `errorMessage` as a fallback revert reason when `target` reverts.
1326      *
1327      * _Available since v3.1._
1328      */
1329     function functionCall(
1330         address target,
1331         bytes memory data,
1332         string memory errorMessage
1333     ) internal returns (bytes memory) {
1334         return functionCallWithValue(target, data, 0, errorMessage);
1335     }
1336 
1337     /**
1338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1339      * but also transferring `value` wei to `target`.
1340      *
1341      * Requirements:
1342      *
1343      * - the calling contract must have an ETH balance of at least `value`.
1344      * - the called Solidity function must be `payable`.
1345      *
1346      * _Available since v3.1._
1347      */
1348     function functionCallWithValue(
1349         address target,
1350         bytes memory data,
1351         uint256 value
1352     ) internal returns (bytes memory) {
1353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1354     }
1355 
1356     /**
1357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1358      * with `errorMessage` as a fallback revert reason when `target` reverts.
1359      *
1360      * _Available since v3.1._
1361      */
1362     function functionCallWithValue(
1363         address target,
1364         bytes memory data,
1365         uint256 value,
1366         string memory errorMessage
1367     ) internal returns (bytes memory) {
1368         require(address(this).balance >= value, "Address: insufficient balance for call");
1369         require(isContract(target), "Address: call to non-contract");
1370 
1371         (bool success, bytes memory returndata) = target.call{value: value}(data);
1372         return verifyCallResult(success, returndata, errorMessage);
1373     }
1374 
1375     /**
1376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1377      * but performing a static call.
1378      *
1379      * _Available since v3.3._
1380      */
1381     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1382         return functionStaticCall(target, data, "Address: low-level static call failed");
1383     }
1384 
1385     /**
1386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1387      * but performing a static call.
1388      *
1389      * _Available since v3.3._
1390      */
1391     function functionStaticCall(
1392         address target,
1393         bytes memory data,
1394         string memory errorMessage
1395     ) internal view returns (bytes memory) {
1396         require(isContract(target), "Address: static call to non-contract");
1397 
1398         (bool success, bytes memory returndata) = target.staticcall(data);
1399         return verifyCallResult(success, returndata, errorMessage);
1400     }
1401 
1402     /**
1403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1404      * but performing a delegate call.
1405      *
1406      * _Available since v3.4._
1407      */
1408     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1409         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1410     }
1411 
1412     /**
1413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1414      * but performing a delegate call.
1415      *
1416      * _Available since v3.4._
1417      */
1418     function functionDelegateCall(
1419         address target,
1420         bytes memory data,
1421         string memory errorMessage
1422     ) internal returns (bytes memory) {
1423         require(isContract(target), "Address: delegate call to non-contract");
1424 
1425         (bool success, bytes memory returndata) = target.delegatecall(data);
1426         return verifyCallResult(success, returndata, errorMessage);
1427     }
1428 
1429     /**
1430      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1431      * revert reason using the provided one.
1432      *
1433      * _Available since v4.3._
1434      */
1435     function verifyCallResult(
1436         bool success,
1437         bytes memory returndata,
1438         string memory errorMessage
1439     ) internal pure returns (bytes memory) {
1440         if (success) {
1441             return returndata;
1442         } else {
1443             // Look for revert reason and bubble it up if present
1444             if (returndata.length > 0) {
1445                 // The easiest way to bubble the revert reason is using memory via assembly
1446 
1447                 assembly {
1448                     let returndata_size := mload(returndata)
1449                     revert(add(32, returndata), returndata_size)
1450                 }
1451             } else {
1452                 revert(errorMessage);
1453             }
1454         }
1455     }
1456 }
1457 
1458 
1459 //(/|  |^ )(\*)(.+|) \s+\n \n\n
1460 contract Moonapez is ERC721A, Ownable {
1461     using Address for address;
1462     using Strings for uint256;
1463 
1464     uint256 private maxTokens;
1465     uint256 private _maxFreeMints;
1466 
1467     uint256 private _currentFreeMints;
1468 
1469     bool private _saleEnabled = false;
1470     bool private _freeMintEnabled = false;
1471     
1472     string private _contractURI;
1473     string  private _baseTokenURI;
1474 
1475     uint256 price = 1 ether;
1476 
1477     mapping (address => uint256) freeMints;
1478 
1479     
1480     constructor(uint256 maxTokens_, bool saleEnabled_, bool freeMintEnabled_, string memory baseURI_, uint256 maxFreeMints_, uint256 price_) ERC721A("Moonapez","Moonapez") {
1481         maxTokens = maxTokens_;
1482         _saleEnabled = saleEnabled_;
1483         _freeMintEnabled = freeMintEnabled_;
1484         _baseTokenURI = baseURI_;
1485         _maxFreeMints = maxFreeMints_;
1486         price = price_;
1487     }
1488     
1489 
1490     function hasFreeMint(address target) public view returns(bool){
1491         return _freeMintEnabled && freeMints[target] < 1 && _currentFreeMints < _maxFreeMints;
1492     }
1493     
1494     function freeMintEnabled() external view returns(bool){
1495         return _freeMintEnabled;
1496     }
1497 
1498     function freeMintSet(bool v) external onlyOwner {
1499         _freeMintEnabled = v;
1500     }
1501     
1502 
1503     function saleEnabled() external view returns(bool){
1504         return _saleEnabled;
1505     }
1506 
1507     function saleSet(bool v) external onlyOwner {
1508         _saleEnabled = v;
1509     }
1510 
1511 
1512     function getMaxTokens()  external view returns(uint256) {
1513         return maxTokens;
1514     }
1515 
1516 
1517     function totalSupply() public view override returns(uint256) {
1518         return _totalMinted();
1519     }
1520     
1521     
1522     function setPrice(uint256 price_) external onlyOwner {
1523         price = price_;
1524     }
1525 
1526     function setMaxTokens(uint256 _maxTokens) external onlyOwner {
1527         maxTokens = _maxTokens;
1528     }
1529 
1530     function setMaxFreeMints(uint256 maxFreeMints_) external onlyOwner {
1531         _maxFreeMints = maxFreeMints_;
1532     }
1533 
1534 
1535     function mints(address _to, uint256 amount) external onlyOwner {
1536         require(tokensAvailable() >= amount, "Max tokens reached");
1537         _safeMint(_to, amount);
1538     }
1539     
1540 
1541     function claim(uint256 amount) external payable {
1542         require(_saleEnabled, "Sale off");
1543         require(msg.value >= amount*price, "Insufficient value to mint");
1544         require(tokensAvailable() >= amount, "Max tokens reached");
1545         _safeMint(msg.sender, amount);
1546     }
1547 
1548 
1549     function mint() external {
1550         require(_freeMintEnabled, "Free mint off");
1551         require(freeMints[msg.sender] < 1, "You reached max free tokens");
1552         require(_currentFreeMints < _maxFreeMints, "You reached max free tokens");
1553         _safeMint(msg.sender, 1);
1554         freeMints[msg.sender] += 1;
1555         _currentFreeMints += 1;
1556     }
1557     
1558 
1559     function contractURI() public view returns (string memory) {
1560     	return _contractURI;
1561     }
1562     
1563     function withdraw() external onlyOwner
1564     {
1565         Address.sendValue(payable(msg.sender), address(this).balance);
1566     }
1567 
1568     function tokensAvailable() public view returns (uint256) {
1569         return maxTokens - _totalMinted();
1570     }
1571 
1572     function currentFreeMints() public view returns (uint256) {
1573         return _maxFreeMints - _currentFreeMints;
1574     }
1575 
1576     function _baseURI() internal view override  returns (string memory) {
1577         return _baseTokenURI;
1578     }
1579 
1580     function setBaseURI(string memory uri) external onlyOwner {
1581         _baseTokenURI = uri;
1582     }
1583     
1584     function setContractURI(string memory uri) external onlyOwner {
1585         _contractURI = uri;
1586     }
1587     
1588     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1589         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1590         string memory baseURI = _baseURI();
1591         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1592     }
1593 
1594     function URI(uint256 tokenId) external view virtual returns (string memory) {
1595         return tokenURI(tokenId);
1596     }
1597 }