1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.7;
3 
4 
5 
6 // ERC721A Contracts v3.3.0
7 // Creator: Chiru Labs
8 /**
9  * @dev Interface of an ERC721A compliant contract.
10  */
11 interface IERC721A {
12     /**
13      * The caller must own the token or be an approved operator.
14      */
15     error ApprovalCallerNotOwnerNorApproved();
16 
17     /**
18      * The token does not exist.
19      */
20     error ApprovalQueryForNonexistentToken();
21 
22     /**
23      * The caller cannot approve to their own address.
24      */
25     error ApproveToCaller();
26 
27     /**
28      * The caller cannot approve to the current owner.
29      */
30     error ApprovalToCurrentOwner();
31 
32     /**
33      * Cannot query the balance for the zero address.
34      */
35     error BalanceQueryForZeroAddress();
36 
37     /**
38      * Cannot mint to the zero address.
39      */
40     error MintToZeroAddress();
41 
42     /**
43      * The quantity of tokens minted must be more than zero.
44      */
45     error MintZeroQuantity();
46 
47     /**
48      * The token does not exist.
49      */
50     error OwnerQueryForNonexistentToken();
51 
52     /**
53      * The caller must own the token or be an approved operator.
54      */
55     error TransferCallerNotOwnerNorApproved();
56 
57     /**
58      * The token must be owned by `from`.
59      */
60     error TransferFromIncorrectOwner();
61 
62     /**
63      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
64      */
65     error TransferToNonERC721ReceiverImplementer();
66 
67     /**
68      * Cannot transfer to the zero address.
69      */
70     error TransferToZeroAddress();
71 
72     /**
73      * The token does not exist.
74      */
75     error URIQueryForNonexistentToken();
76 
77     struct TokenOwnership {
78         // The address of the owner.
79         address addr;
80         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
81         uint64 startTimestamp;
82         // Whether the token has been burned.
83         bool burned;
84     }
85 
86     /**
87      * @dev Returns the total amount of tokens stored by the contract.
88      *
89      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
90      */
91     //function totalSupply() external view returns (uint256);
92 
93     // ==============================
94     //            IERC165
95     // ==============================
96 
97     /**
98      * @dev Returns true if this contract implements the interface defined by
99      * `interfaceId`. See the corresponding
100      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
101      * to learn more about how these ids are created.
102      *
103      * This function call must use less than 30 000 gas.
104      */
105     function supportsInterface(bytes4 interfaceId) external view returns (bool);
106 
107     // ==============================
108     //            IERC721
109     // ==============================
110 
111     /**
112      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
115 
116     /**
117      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
118      */
119     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
120 
121     /**
122      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
123      */
124     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
125 
126     /**
127      * @dev Returns the number of tokens in ``owner``'s account.
128      */
129     function balanceOf(address owner) external view returns (uint256 balance);
130 
131     /**
132      * @dev Returns the owner of the `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function ownerOf(uint256 tokenId) external view returns (address owner);
139 
140     /**
141      * @dev Safely transfers `tokenId` token from `from` to `to`.
142      *
143      * Requirements:
144      *
145      * - `from` cannot be the zero address.
146      * - `to` cannot be the zero address.
147      * - `tokenId` token must exist and be owned by `from`.
148      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
150      *
151      * Emits a {Transfer} event.
152      */
153     function safeTransferFrom(
154         address from,
155         address to,
156         uint256 tokenId,
157         bytes calldata data
158     ) external;
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
162      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId
178     ) external;
179 
180     /**
181      * @dev Transfers `tokenId` token from `from` to `to`.
182      *
183      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must be owned by `from`.
190      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address from,
196         address to,
197         uint256 tokenId
198     ) external;
199 
200     /**
201      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
202      * The approval is cleared when the token is transferred.
203      *
204      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
205      *
206      * Requirements:
207      *
208      * - The caller must own the token or be an approved operator.
209      * - `tokenId` must exist.
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address to, uint256 tokenId) external;
214 
215     /**
216      * @dev Approve or remove `operator` as an operator for the caller.
217      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
218      *
219      * Requirements:
220      *
221      * - The `operator` cannot be the caller.
222      *
223      * Emits an {ApprovalForAll} event.
224      */
225     function setApprovalForAll(address operator, bool _approved) external;
226 
227     /**
228      * @dev Returns the account approved for `tokenId` token.
229      *
230      * Requirements:
231      *
232      * - `tokenId` must exist.
233      */
234     function getApproved(uint256 tokenId) external view returns (address operator);
235 
236     /**
237      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
238      *
239      * See {setApprovalForAll}
240      */
241     function isApprovedForAll(address owner, address operator) external view returns (bool);
242 
243     // ==============================
244     //        IERC721Metadata
245     // ==============================
246 
247     /**
248      * @dev Returns the token collection name.
249      */
250     function name() external view returns (string memory);
251 
252     /**
253      * @dev Returns the token collection symbol.
254      */
255     function symbol() external view returns (string memory);
256 
257     /**
258      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
259      */
260     function tokenURI(uint256 tokenId) external view returns (string memory);
261 }
262 
263 
264 // ERC721A Contracts v3.3.0
265 // Creator: Chiru Labs
266 /**
267  * @dev ERC721 token receiver interface.
268  */
269 interface ERC721A__IERC721Receiver {
270     function onERC721Received(
271         address operator,
272         address from,
273         uint256 tokenId,
274         bytes calldata data
275     ) external returns (bytes4);
276 }
277 
278 /**
279  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
280  * the Metadata extension. Built to optimize for lower gas during batch mints.
281  *
282  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
283  *
284  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
285  *
286  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
287  */
288 contract ERC721A is IERC721A {
289     // Mask of an entry in packed address data.
290     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
291 
292     // The bit position of `numberMinted` in packed address data.
293     uint256 private constant BITPOS_NUMBER_MINTED = 64;
294 
295     // The bit position of `numberBurned` in packed address data.
296     uint256 private constant BITPOS_NUMBER_BURNED = 128;
297 
298     // The bit position of `aux` in packed address data.
299     uint256 private constant BITPOS_AUX = 192;
300 
301     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
302     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
303 
304     // The bit position of `startTimestamp` in packed ownership.
305     uint256 private constant BITPOS_START_TIMESTAMP = 160;
306 
307     // The bit mask of the `burned` bit in packed ownership.
308     uint256 private constant BITMASK_BURNED = 1 << 224;
309     
310     // The bit position of the `nextInitialized` bit in packed ownership.
311     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
312 
313     // The bit mask of the `nextInitialized` bit in packed ownership.
314     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
315 
316     // The tokenId of the next token to be minted.
317     uint256 private _currentIndex;
318 
319     // The number of tokens burned.
320     uint256 private _burnCounter;
321 
322     // Token name
323     string private _name;
324 
325     // Token symbol
326     string private _symbol;
327 
328     // Mapping from token ID to ownership details
329     // An empty struct value does not necessarily mean the token is unowned.
330     // See `_packedOwnershipOf` implementation for details.
331     //
332     // Bits Layout:
333     // - [0..159]   `addr`
334     // - [160..223] `startTimestamp`
335     // - [224]      `burned`
336     // - [225]      `nextInitialized`
337     mapping(uint256 => uint256) private _packedOwnerships;
338 
339     // Mapping owner address to address data.
340     //
341     // Bits Layout:
342     // - [0..63]    `balance`
343     // - [64..127]  `numberMinted`
344     // - [128..191] `numberBurned`
345     // - [192..255] `aux`
346     mapping(address => uint256) private _packedAddressData;
347 
348     // Mapping from token ID to approved address.
349     mapping(uint256 => address) private _tokenApprovals;
350 
351     // Mapping from owner to operator approvals
352     mapping(address => mapping(address => bool)) private _operatorApprovals;
353 
354     constructor(string memory name_, string memory symbol_) {
355         _name = name_;
356         _symbol = symbol_;
357         _currentIndex = _startTokenId();
358     }
359 
360     /**
361      * @dev Returns the starting token ID. 
362      * To change the starting token ID, please override this function.
363      */
364     function _startTokenId() internal view virtual returns (uint256) {
365         return 0;
366     }
367 
368     /**
369      * @dev Returns the next token ID to be minted.
370      */
371     function _nextTokenId() internal view returns (uint256) {
372         return _currentIndex;
373     }
374 
375     /**
376      * @dev Returns the total number of tokens in existence.
377      * Burned tokens will reduce the count. 
378      * To get the total number of tokens minted, please see `_totalMinted`.
379      */
380     function totalSupply() public view virtual returns (uint256) {
381         // Counter underflow is impossible as _burnCounter cannot be incremented
382         // more than `_currentIndex - _startTokenId()` times.
383         unchecked {
384             return _currentIndex - _burnCounter - _startTokenId();
385         }
386     }
387 
388     /**
389      * @dev Returns the total amount of tokens minted in the contract.
390      */
391     function _totalMinted() internal view returns (uint256) {
392         // Counter underflow is impossible as _currentIndex does not decrement,
393         // and it is initialized to `_startTokenId()`
394         unchecked {
395             return _currentIndex - _startTokenId();
396         }
397     }
398 
399     /**
400      * @dev Returns the total number of tokens burned.
401      */
402     function _totalBurned() internal view returns (uint256) {
403         return _burnCounter;
404     }
405 
406     /**
407      * @dev See {IERC165-supportsInterface}.
408      */
409     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
410         // The interface IDs are constants representing the first 4 bytes of the XOR of
411         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
412         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
413         return
414             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
415             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
416             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
417     }
418 
419     /**
420      * @dev See {IERC721-balanceOf}.
421      */
422     function balanceOf(address owner) public view override returns (uint256) {
423         if (owner == address(0)) revert BalanceQueryForZeroAddress();
424         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
425     }
426 
427     /**
428      * Returns the number of tokens minted by `owner`.
429      */
430     function _numberMinted(address owner) internal view returns (uint256) {
431         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
432     }
433 
434     /**
435      * Returns the number of tokens burned by or on behalf of `owner`.
436      */
437     function _numberBurned(address owner) internal view returns (uint256) {
438         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
439     }
440 
441     /**
442      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
443      */
444     function _getAux(address owner) internal view returns (uint64) {
445         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
446     }
447 
448     /**
449      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
450      * If there are multiple variables, please pack them into a uint64.
451      */
452     function _setAux(address owner, uint64 aux) internal {
453         uint256 packed = _packedAddressData[owner];
454         uint256 auxCasted;
455         assembly { // Cast aux without masking.
456             auxCasted := aux
457         }
458         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
459         _packedAddressData[owner] = packed;
460     }
461 
462     /**
463      * Returns the packed ownership data of `tokenId`.
464      */
465     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
466         uint256 curr = tokenId;
467 
468         unchecked {
469             if (_startTokenId() <= curr)
470                 if (curr < _currentIndex) {
471                     uint256 packed = _packedOwnerships[curr];
472                     // If not burned.
473                     if (packed & BITMASK_BURNED == 0) {
474                         // Invariant:
475                         // There will always be an ownership that has an address and is not burned
476                         // before an ownership that does not have an address and is not burned.
477                         // Hence, curr will not underflow.
478                         //
479                         // We can directly compare the packed value.
480                         // If the address is zero, packed is zero.
481                         while (packed == 0) {
482                             packed = _packedOwnerships[--curr];
483                         }
484                         return packed;
485                     }
486                 }
487         }
488         revert OwnerQueryForNonexistentToken();
489     }
490 
491     /**
492      * Returns the unpacked `TokenOwnership` struct from `packed`.
493      */
494     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
495         ownership.addr = address(uint160(packed));
496         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
497         ownership.burned = packed & BITMASK_BURNED != 0;
498     }
499 
500     /**
501      * Returns the unpacked `TokenOwnership` struct at `index`.
502      */
503     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
504         return _unpackedOwnership(_packedOwnerships[index]);
505     }
506 
507     /**
508      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
509      */
510     function _initializeOwnershipAt(uint256 index) internal {
511         if (_packedOwnerships[index] == 0) {
512             _packedOwnerships[index] = _packedOwnershipOf(index);
513         }
514     }
515 
516     /**
517      * Gas spent here starts off proportional to the maximum mint batch size.
518      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
519      */
520     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
521         return _unpackedOwnership(_packedOwnershipOf(tokenId));
522     }
523 
524     /**
525      * @dev See {IERC721-ownerOf}.
526      */
527     function ownerOf(uint256 tokenId) public view override returns (address) {
528         return address(uint160(_packedOwnershipOf(tokenId)));
529     }
530 
531     /**
532      * @dev See {IERC721Metadata-name}.
533      */
534     function name() public view virtual override returns (string memory) {
535         return _name;
536     }
537 
538     /**
539      * @dev See {IERC721Metadata-symbol}.
540      */
541     function symbol() public view virtual override returns (string memory) {
542         return _symbol;
543     }
544 
545     /**
546      * @dev See {IERC721Metadata-tokenURI}.
547      */
548     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
549         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
550 
551         string memory baseURI = _baseURI();
552         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
553     }
554 
555     /**
556      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
557      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
558      * by default, can be overriden in child contracts.
559      */
560     function _baseURI() internal view virtual returns (string memory) {
561         return '';
562     }
563 
564     /**
565      * @dev Casts the address to uint256 without masking.
566      */
567     function _addressToUint256(address value) private pure returns (uint256 result) {
568         assembly {
569             result := value
570         }
571     }
572 
573     /**
574      * @dev Casts the boolean to uint256 without branching.
575      */
576     function _boolToUint256(bool value) private pure returns (uint256 result) {
577         assembly {
578             result := value
579         }
580     }
581 
582     /**
583      * @dev See {IERC721-approve}.
584      */
585     function approve(address to, uint256 tokenId) public override {
586         address owner = address(uint160(_packedOwnershipOf(tokenId)));
587         if (to == owner) revert ApprovalToCurrentOwner();
588 
589         if (_msgSenderERC721A() != owner)
590             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
591                 revert ApprovalCallerNotOwnerNorApproved();
592             }
593 
594         _tokenApprovals[tokenId] = to;
595         emit Approval(owner, to, tokenId);
596     }
597 
598     /**
599      * @dev See {IERC721-getApproved}.
600      */
601     function getApproved(uint256 tokenId) public view override returns (address) {
602         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
603 
604         return _tokenApprovals[tokenId];
605     }
606 
607     /**
608      * @dev See {IERC721-setApprovalForAll}.
609      */
610     function setApprovalForAll(address operator, bool approved) public virtual override {
611         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
612 
613         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
614         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
615     }
616 
617     /**
618      * @dev See {IERC721-isApprovedForAll}.
619      */
620     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
621         return _operatorApprovals[owner][operator];
622     }
623 
624     /**
625      * @dev See {IERC721-transferFrom}.
626      */
627     function transferFrom(
628         address from,
629         address to,
630         uint256 tokenId
631     ) public virtual override {
632         _transfer(from, to, tokenId);
633     }
634 
635     /**
636      * @dev See {IERC721-safeTransferFrom}.
637      */
638     function safeTransferFrom(
639         address from,
640         address to,
641         uint256 tokenId
642     ) public virtual override {
643         safeTransferFrom(from, to, tokenId, '');
644     }
645 
646     /**
647      * @dev See {IERC721-safeTransferFrom}.
648      */
649     function safeTransferFrom(
650         address from,
651         address to,
652         uint256 tokenId,
653         bytes memory _data
654     ) public virtual override {
655         _transfer(from, to, tokenId);
656         if (to.code.length != 0)
657             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
658                 revert TransferToNonERC721ReceiverImplementer();
659             }
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
672             tokenId < _currentIndex && // If within bounds,
673             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
674     }
675 
676     /**
677      * @dev Equivalent to `_safeMint(to, quantity, '')`.
678      */
679     function _safeMint(address to, uint256 quantity) internal {
680         _safeMint(to, quantity, '');
681     }
682 
683     /**
684      * @dev Safely mints `quantity` tokens and transfers them to `to`.
685      *
686      * Requirements:
687      *
688      * - If `to` refers to a smart contract, it must implement
689      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
690      * - `quantity` must be greater than 0.
691      *
692      * Emits a {Transfer} event.
693      */
694     function _safeMint(
695         address to,
696         uint256 quantity,
697         bytes memory _data
698     ) internal {
699         uint256 startTokenId = _currentIndex;
700         if (to == address(0)) revert MintToZeroAddress();
701         if (quantity == 0) revert MintZeroQuantity();
702 
703         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
704 
705         // Overflows are incredibly unrealistic.
706         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
707         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
708         unchecked {
709             // Updates:
710             // - `balance += quantity`.
711             // - `numberMinted += quantity`.
712             //
713             // We can directly add to the balance and number minted.
714             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
715 
716             // Updates:
717             // - `address` to the owner.
718             // - `startTimestamp` to the timestamp of minting.
719             // - `burned` to `false`.
720             // - `nextInitialized` to `quantity == 1`.
721             _packedOwnerships[startTokenId] =
722                 _addressToUint256(to) |
723                 (block.timestamp << BITPOS_START_TIMESTAMP) |
724                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
725 
726             uint256 updatedIndex = startTokenId;
727             uint256 end = updatedIndex + quantity;
728 
729             if (to.code.length != 0) {
730                 do {
731                     emit Transfer(address(0), to, updatedIndex);
732                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
733                         revert TransferToNonERC721ReceiverImplementer();
734                     }
735                 } while (updatedIndex < end);
736                 // Reentrancy protection
737                 if (_currentIndex != startTokenId) revert();
738             } else {
739                 do {
740                     emit Transfer(address(0), to, updatedIndex++);
741                 } while (updatedIndex < end);
742             }
743             _currentIndex = updatedIndex;
744         }
745         _afterTokenTransfers(address(0), to, startTokenId, quantity);
746     }
747 
748     /**
749      * @dev Mints `quantity` tokens and transfers them to `to`.
750      *
751      * Requirements:
752      *
753      * - `to` cannot be the zero address.
754      * - `quantity` must be greater than 0.
755      *
756      * Emits a {Transfer} event.
757      */
758     function _mint(address to, uint256 quantity) internal {
759         uint256 startTokenId = _currentIndex;
760         if (to == address(0)) revert MintToZeroAddress();
761         if (quantity == 0) revert MintZeroQuantity();
762 
763         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
764 
765         // Overflows are incredibly unrealistic.
766         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
767         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
768         unchecked {
769             // Updates:
770             // - `balance += quantity`.
771             // - `numberMinted += quantity`.
772             //
773             // We can directly add to the balance and number minted.
774             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
775 
776             // Updates:
777             // - `address` to the owner.
778             // - `startTimestamp` to the timestamp of minting.
779             // - `burned` to `false`.
780             // - `nextInitialized` to `quantity == 1`.
781             _packedOwnerships[startTokenId] =
782                 _addressToUint256(to) |
783                 (block.timestamp << BITPOS_START_TIMESTAMP) |
784                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
785 
786             uint256 updatedIndex = startTokenId;
787             uint256 end = updatedIndex + quantity;
788 
789             do {
790                 emit Transfer(address(0), to, updatedIndex++);
791             } while (updatedIndex < end);
792 
793             _currentIndex = updatedIndex;
794         }
795         _afterTokenTransfers(address(0), to, startTokenId, quantity);
796     }
797 
798     /**
799      * @dev Transfers `tokenId` from `from` to `to`.
800      *
801      * Requirements:
802      *
803      * - `to` cannot be the zero address.
804      * - `tokenId` token must be owned by `from`.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _transfer(
809         address from,
810         address to,
811         uint256 tokenId
812     ) private {
813         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
814 
815         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
816 
817         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
818             isApprovedForAll(from, _msgSenderERC721A()) ||
819             getApproved(tokenId) == _msgSenderERC721A());
820 
821         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
822         if (to == address(0)) revert TransferToZeroAddress();
823 
824         _beforeTokenTransfers(from, to, tokenId, 1);
825 
826         // Clear approvals from the previous owner.
827         delete _tokenApprovals[tokenId];
828 
829         // Underflow of the sender's balance is impossible because we check for
830         // ownership above and the recipient's balance can't realistically overflow.
831         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
832         unchecked {
833             // We can directly increment and decrement the balances.
834             --_packedAddressData[from]; // Updates: `balance -= 1`.
835             ++_packedAddressData[to]; // Updates: `balance += 1`.
836 
837             // Updates:
838             // - `address` to the next owner.
839             // - `startTimestamp` to the timestamp of transfering.
840             // - `burned` to `false`.
841             // - `nextInitialized` to `true`.
842             _packedOwnerships[tokenId] =
843                 _addressToUint256(to) |
844                 (block.timestamp << BITPOS_START_TIMESTAMP) |
845                 BITMASK_NEXT_INITIALIZED;
846 
847             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
848             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
849                 uint256 nextTokenId = tokenId + 1;
850                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
851                 if (_packedOwnerships[nextTokenId] == 0) {
852                     // If the next slot is within bounds.
853                     if (nextTokenId != _currentIndex) {
854                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
855                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
856                     }
857                 }
858             }
859         }
860 
861         emit Transfer(from, to, tokenId);
862         _afterTokenTransfers(from, to, tokenId, 1);
863     }
864 
865     /**
866      * @dev Equivalent to `_burn(tokenId, false)`.
867      */
868     function _burn(uint256 tokenId) internal virtual {
869         _burn(tokenId, false);
870     }
871 
872     /**
873      * @dev Destroys `tokenId`.
874      * The approval is cleared when the token is burned.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must exist.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
883         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
884 
885         address from = address(uint160(prevOwnershipPacked));
886 
887         if (approvalCheck) {
888             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
889                 isApprovedForAll(from, _msgSenderERC721A()) ||
890                 getApproved(tokenId) == _msgSenderERC721A());
891 
892             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
893         }
894 
895         _beforeTokenTransfers(from, address(0), tokenId, 1);
896 
897         // Clear approvals from the previous owner.
898         delete _tokenApprovals[tokenId];
899 
900         // Underflow of the sender's balance is impossible because we check for
901         // ownership above and the recipient's balance can't realistically overflow.
902         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
903         unchecked {
904             // Updates:
905             // - `balance -= 1`.
906             // - `numberBurned += 1`.
907             //
908             // We can directly decrement the balance, and increment the number burned.
909             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
910             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
911 
912             // Updates:
913             // - `address` to the last owner.
914             // - `startTimestamp` to the timestamp of burning.
915             // - `burned` to `true`.
916             // - `nextInitialized` to `true`.
917             _packedOwnerships[tokenId] =
918                 _addressToUint256(from) |
919                 (block.timestamp << BITPOS_START_TIMESTAMP) |
920                 BITMASK_BURNED | 
921                 BITMASK_NEXT_INITIALIZED;
922 
923             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
924             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
925                 uint256 nextTokenId = tokenId + 1;
926                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
927                 if (_packedOwnerships[nextTokenId] == 0) {
928                     // If the next slot is within bounds.
929                     if (nextTokenId != _currentIndex) {
930                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
931                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
932                     }
933                 }
934             }
935         }
936 
937         emit Transfer(from, address(0), tokenId);
938         _afterTokenTransfers(from, address(0), tokenId, 1);
939 
940         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
941         unchecked {
942             _burnCounter++;
943         }
944     }
945 
946     /**
947      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
948      *
949      * @param from address representing the previous owner of the given token ID
950      * @param to target address that will receive the tokens
951      * @param tokenId uint256 ID of the token to be transferred
952      * @param _data bytes optional data to send along with the call
953      * @return bool whether the call correctly returned the expected magic value
954      */
955     function _checkContractOnERC721Received(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) private returns (bool) {
961         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
962             bytes4 retval
963         ) {
964             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
965         } catch (bytes memory reason) {
966             if (reason.length == 0) {
967                 revert TransferToNonERC721ReceiverImplementer();
968             } else {
969                 assembly {
970                     revert(add(32, reason), mload(reason))
971                 }
972             }
973         }
974     }
975 
976     /**
977      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
978      * And also called before burning one token.
979      *
980      * startTokenId - the first token id to be transferred
981      * quantity - the amount to be transferred
982      *
983      * Calling conditions:
984      *
985      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
986      * transferred to `to`.
987      * - When `from` is zero, `tokenId` will be minted for `to`.
988      * - When `to` is zero, `tokenId` will be burned by `from`.
989      * - `from` and `to` are never both zero.
990      */
991     function _beforeTokenTransfers(
992         address from,
993         address to,
994         uint256 startTokenId,
995         uint256 quantity
996     ) internal virtual {}
997 
998     /**
999      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1000      * minting.
1001      * And also called after one token has been burned.
1002      *
1003      * startTokenId - the first token id to be transferred
1004      * quantity - the amount to be transferred
1005      *
1006      * Calling conditions:
1007      *
1008      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1009      * transferred to `to`.
1010      * - When `from` is zero, `tokenId` has been minted for `to`.
1011      * - When `to` is zero, `tokenId` has been burned by `from`.
1012      * - `from` and `to` are never both zero.
1013      */
1014     function _afterTokenTransfers(
1015         address from,
1016         address to,
1017         uint256 startTokenId,
1018         uint256 quantity
1019     ) internal virtual {}
1020 
1021     /**
1022      * @dev Returns the message sender (defaults to `msg.sender`).
1023      *
1024      * If you are writing GSN compatible contracts, you need to override this function.
1025      */
1026     function _msgSenderERC721A() internal view virtual returns (address) {
1027         return msg.sender;
1028     }
1029 
1030     /**
1031      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1032      */
1033     function _toString(uint256 value) internal pure returns (string memory ptr) {
1034         assembly {
1035             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1036             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1037             // We will need 1 32-byte word to store the length, 
1038             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1039             ptr := add(mload(0x40), 128)
1040             // Update the free memory pointer to allocate.
1041             mstore(0x40, ptr)
1042 
1043             // Cache the end of the memory to calculate the length later.
1044             let end := ptr
1045 
1046             // We write the string from the rightmost digit to the leftmost digit.
1047             // The following is essentially a do-while loop that also handles the zero case.
1048             // Costs a bit more than early returning for the zero case,
1049             // but cheaper in terms of deployment and overall runtime costs.
1050             for { 
1051                 // Initialize and perform the first pass without check.
1052                 let temp := value
1053                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1054                 ptr := sub(ptr, 1)
1055                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1056                 mstore8(ptr, add(48, mod(temp, 10)))
1057                 temp := div(temp, 10)
1058             } temp { 
1059                 // Keep dividing `temp` until zero.
1060                 temp := div(temp, 10)
1061             } { // Body of the for loop.
1062                 ptr := sub(ptr, 1)
1063                 mstore8(ptr, add(48, mod(temp, 10)))
1064             }
1065             
1066             let length := sub(end, ptr)
1067             // Move the pointer 32 bytes leftwards to make room for the length.
1068             ptr := sub(ptr, 32)
1069             // Store the length.
1070             mstore(ptr, length)
1071         }
1072     }
1073 }
1074 
1075 
1076 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1077 /**
1078  * @dev Provides information about the current execution context, including the
1079  * sender of the transaction and its data. While these are generally available
1080  * via msg.sender and msg.data, they should not be accessed in such a direct
1081  * manner, since when dealing with meta-transactions the account sending and
1082  * paying for execution may not be the actual sender (as far as an application
1083  * is concerned).
1084  *
1085  * This contract is only required for intermediate, library-like contracts.
1086  */
1087 abstract contract Context {
1088     function _msgSender() internal view virtual returns (address) {
1089         return msg.sender;
1090     }
1091 
1092     function _msgData() internal view virtual returns (bytes calldata) {
1093         return msg.data;
1094     }
1095 }
1096 
1097 
1098 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1099 /**
1100  * @dev Contract module which provides a basic access control mechanism, where
1101  * there is an account (an owner) that can be granted exclusive access to
1102  * specific functions.
1103  *
1104  * By default, the owner account will be the one that deploys the contract. This
1105  * can later be changed with {transferOwnership}.
1106  *
1107  * This module is used through inheritance. It will make available the modifier
1108  * `onlyOwner`, which can be applied to your functions to restrict their use to
1109  * the owner.
1110  */
1111 abstract contract Ownable is Context {
1112     address private _owner;
1113 
1114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1115 
1116     /**
1117      * @dev Initializes the contract setting the deployer as the initial owner.
1118      */
1119     constructor() {
1120         _transferOwnership(_msgSender());
1121     }
1122 
1123     /**
1124      * @dev Returns the address of the current owner.
1125      */
1126     function owner() public view virtual returns (address) {
1127         return _owner;
1128     }
1129 
1130     /**
1131      * @dev Throws if called by any account other than the owner.
1132      */
1133     modifier onlyOwner() {
1134         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1135         _;
1136     }
1137 
1138     /**
1139      * @dev Leaves the contract without owner. It will not be possible to call
1140      * `onlyOwner` functions anymore. Can only be called by the current owner.
1141      *
1142      * NOTE: Renouncing ownership will leave the contract without an owner,
1143      * thereby removing any functionality that is only available to the owner.
1144      */
1145     function renounceOwnership() public virtual onlyOwner {
1146         _transferOwnership(address(0));
1147     }
1148 
1149     /**
1150      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1151      * Can only be called by the current owner.
1152      */
1153     function transferOwnership(address newOwner) public virtual onlyOwner {
1154         require(newOwner != address(0), "Ownable: new owner is the zero address");
1155         _transferOwnership(newOwner);
1156     }
1157 
1158     /**
1159      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1160      * Internal function without access restriction.
1161      */
1162     function _transferOwnership(address newOwner) internal virtual {
1163         address oldOwner = _owner;
1164         _owner = newOwner;
1165         emit OwnershipTransferred(oldOwner, newOwner);
1166     }
1167 }
1168 
1169 
1170 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1171 /**
1172  * @dev String operations.
1173  */
1174 library Strings {
1175     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1176 
1177     /**
1178      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1179      */
1180     function toString(uint256 value) internal pure returns (string memory) {
1181         // Inspired by OraclizeAPI's implementation - MIT licence
1182         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1183 
1184         if (value == 0) {
1185             return "0";
1186         }
1187         uint256 temp = value;
1188         uint256 digits;
1189         while (temp != 0) {
1190             digits++;
1191             temp /= 10;
1192         }
1193         bytes memory buffer = new bytes(digits);
1194         while (value != 0) {
1195             digits -= 1;
1196             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1197             value /= 10;
1198         }
1199         return string(buffer);
1200     }
1201 
1202     /**
1203      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1204      */
1205     function toHexString(uint256 value) internal pure returns (string memory) {
1206         if (value == 0) {
1207             return "0x00";
1208         }
1209         uint256 temp = value;
1210         uint256 length = 0;
1211         while (temp != 0) {
1212             length++;
1213             temp >>= 8;
1214         }
1215         return toHexString(value, length);
1216     }
1217 
1218     /**
1219      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1220      */
1221     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1222         bytes memory buffer = new bytes(2 * length + 2);
1223         buffer[0] = "0";
1224         buffer[1] = "x";
1225         for (uint256 i = 2 * length + 1; i > 1; --i) {
1226             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1227             value >>= 4;
1228         }
1229         require(value == 0, "Strings: hex length insufficient");
1230         return string(buffer);
1231     }
1232 }
1233 
1234 
1235 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
1236 /**
1237  * @dev Collection of functions related to the address type
1238  */
1239 library Address {
1240     /**
1241      * @dev Returns true if `account` is a contract.
1242      *
1243      * [IMPORTANT]
1244      * ====
1245      * It is unsafe to assume that an address for which this function returns
1246      * false is an externally-owned account (EOA) and not a contract.
1247      *
1248      * Among others, `isContract` will return false for the following
1249      * types of addresses:
1250      *
1251      *  - an externally-owned account
1252      *  - a contract in construction
1253      *  - an address where a contract will be created
1254      *  - an address where a contract lived, but was destroyed
1255      * ====
1256      *
1257      * [IMPORTANT]
1258      * ====
1259      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1260      *
1261      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1262      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1263      * constructor.
1264      * ====
1265      */
1266     function isContract(address account) internal view returns (bool) {
1267         // This method relies on extcodesize/address.code.length, which returns 0
1268         // for contracts in construction, since the code is only stored at the end
1269         // of the constructor execution.
1270 
1271         return account.code.length > 0;
1272     }
1273 
1274     /**
1275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1276      * `recipient`, forwarding all available gas and reverting on errors.
1277      *
1278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1280      * imposed by `transfer`, making them unable to receive funds via
1281      * `transfer`. {sendValue} removes this limitation.
1282      *
1283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1284      *
1285      * IMPORTANT: because control is transferred to `recipient`, care must be
1286      * taken to not create reentrancy vulnerabilities. Consider using
1287      * {ReentrancyGuard} or the
1288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1289      */
1290     function sendValue(address payable recipient, uint256 amount) internal {
1291         require(address(this).balance >= amount, "Address: insufficient balance");
1292 
1293         (bool success, ) = recipient.call{value: amount}("");
1294         require(success, "Address: unable to send value, recipient may have reverted");
1295     }
1296 
1297     /**
1298      * @dev Performs a Solidity function call using a low level `call`. A
1299      * plain `call` is an unsafe replacement for a function call: use this
1300      * function instead.
1301      *
1302      * If `target` reverts with a revert reason, it is bubbled up by this
1303      * function (like regular Solidity function calls).
1304      *
1305      * Returns the raw returned data. To convert to the expected return value,
1306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1307      *
1308      * Requirements:
1309      *
1310      * - `target` must be a contract.
1311      * - calling `target` with `data` must not revert.
1312      *
1313      * _Available since v3.1._
1314      */
1315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1316         return functionCall(target, data, "Address: low-level call failed");
1317     }
1318 
1319     /**
1320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1321      * `errorMessage` as a fallback revert reason when `target` reverts.
1322      *
1323      * _Available since v3.1._
1324      */
1325     function functionCall(
1326         address target,
1327         bytes memory data,
1328         string memory errorMessage
1329     ) internal returns (bytes memory) {
1330         return functionCallWithValue(target, data, 0, errorMessage);
1331     }
1332 
1333     /**
1334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1335      * but also transferring `value` wei to `target`.
1336      *
1337      * Requirements:
1338      *
1339      * - the calling contract must have an ETH balance of at least `value`.
1340      * - the called Solidity function must be `payable`.
1341      *
1342      * _Available since v3.1._
1343      */
1344     function functionCallWithValue(
1345         address target,
1346         bytes memory data,
1347         uint256 value
1348     ) internal returns (bytes memory) {
1349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1350     }
1351 
1352     /**
1353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1354      * with `errorMessage` as a fallback revert reason when `target` reverts.
1355      *
1356      * _Available since v3.1._
1357      */
1358     function functionCallWithValue(
1359         address target,
1360         bytes memory data,
1361         uint256 value,
1362         string memory errorMessage
1363     ) internal returns (bytes memory) {
1364         require(address(this).balance >= value, "Address: insufficient balance for call");
1365         require(isContract(target), "Address: call to non-contract");
1366 
1367         (bool success, bytes memory returndata) = target.call{value: value}(data);
1368         return verifyCallResult(success, returndata, errorMessage);
1369     }
1370 
1371     /**
1372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1373      * but performing a static call.
1374      *
1375      * _Available since v3.3._
1376      */
1377     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1378         return functionStaticCall(target, data, "Address: low-level static call failed");
1379     }
1380 
1381     /**
1382      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1383      * but performing a static call.
1384      *
1385      * _Available since v3.3._
1386      */
1387     function functionStaticCall(
1388         address target,
1389         bytes memory data,
1390         string memory errorMessage
1391     ) internal view returns (bytes memory) {
1392         require(isContract(target), "Address: static call to non-contract");
1393 
1394         (bool success, bytes memory returndata) = target.staticcall(data);
1395         return verifyCallResult(success, returndata, errorMessage);
1396     }
1397 
1398     /**
1399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1400      * but performing a delegate call.
1401      *
1402      * _Available since v3.4._
1403      */
1404     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1405         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1406     }
1407 
1408     /**
1409      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1410      * but performing a delegate call.
1411      *
1412      * _Available since v3.4._
1413      */
1414     function functionDelegateCall(
1415         address target,
1416         bytes memory data,
1417         string memory errorMessage
1418     ) internal returns (bytes memory) {
1419         require(isContract(target), "Address: delegate call to non-contract");
1420 
1421         (bool success, bytes memory returndata) = target.delegatecall(data);
1422         return verifyCallResult(success, returndata, errorMessage);
1423     }
1424 
1425     /**
1426      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1427      * revert reason using the provided one.
1428      *
1429      * _Available since v4.3._
1430      */
1431     function verifyCallResult(
1432         bool success,
1433         bytes memory returndata,
1434         string memory errorMessage
1435     ) internal pure returns (bytes memory) {
1436         if (success) {
1437             return returndata;
1438         } else {
1439             // Look for revert reason and bubble it up if present
1440             if (returndata.length > 0) {
1441                 // The easiest way to bubble the revert reason is using memory via assembly
1442 
1443                 assembly {
1444                     let returndata_size := mload(returndata)
1445                     revert(add(32, returndata), returndata_size)
1446                 }
1447             } else {
1448                 revert(errorMessage);
1449             }
1450         }
1451     }
1452 }
1453 
1454 
1455 contract TrippinApeYachtClub is ERC721A, Ownable {
1456     using Address for address;
1457     using Strings for uint256;
1458 
1459     uint256 private maxTokens;
1460 
1461     mapping(uint256 => string) private customTokensURIs;
1462 
1463     bool private _saleEnabled = false;
1464 
1465     bool private _freeMintEnabled = false;
1466 
1467     uint256 private _maxMintForUser;
1468 
1469     uint256 private _maxFreeMints;
1470 
1471     uint256 private _currentFreeMints;
1472     
1473     string private _contractURI;
1474     string  private _baseTokenURI;
1475 
1476     address private serverAddress = address(0);
1477     
1478     mapping(bytes => bool) private signatureUsed;
1479 
1480     uint256 price = 1 ether;
1481 
1482     mapping (address => uint256) freeMints;
1483 
1484     
1485     constructor(uint256 maxTokens_, bool saleEnabled_, bool freeMintEnabled_, string memory baseURI_, uint256 maxMintForUser_, uint256 maxFreeMints_, uint256 price_) ERC721A("TrippinApeYachtClub","TAYC") {
1486         maxTokens = maxTokens_;
1487 
1488         _saleEnabled = saleEnabled_;
1489 
1490         _freeMintEnabled = freeMintEnabled_;
1491 
1492         _baseTokenURI = baseURI_;
1493 
1494         _maxMintForUser = maxMintForUser_;
1495 
1496         _maxFreeMints = maxFreeMints_;
1497 
1498         price = price_;
1499     }
1500 
1501     function setServerAddress(address target) external onlyOwner {
1502         serverAddress = target;
1503     }
1504 
1505     function setMaxTokens(uint256 _maxTokens) external onlyOwner {
1506         maxTokens = _maxTokens;
1507     }
1508 
1509     function setMaxMintForUser(uint256 maxMintForUser_) external onlyOwner {
1510         _maxMintForUser = maxMintForUser_;
1511     }
1512 
1513     function setMaxFreeMints(uint256 maxFreeMints_) external onlyOwner {
1514         _maxFreeMints = maxFreeMints_;
1515     }
1516 
1517     function getMaxTokens()  external view returns(uint256) {
1518         return maxTokens;
1519     }
1520     
1521     function hasFreeMint(address target) public view returns(bool){
1522         return _freeMintEnabled && freeMints[target] < _maxMintForUser && _currentFreeMints < _maxFreeMints;
1523     }
1524     
1525     function freeMintEnabled() external view returns(bool){
1526         return _freeMintEnabled;
1527     }
1528     
1529     function freeMintOn() external onlyOwner{
1530         _freeMintEnabled = true;
1531     }
1532     
1533     function freeMintOff() external onlyOwner{
1534         _freeMintEnabled = false;
1535     }
1536     
1537     function saleEnabled() external view returns(bool){
1538         return _saleEnabled;
1539     }
1540     
1541     function saleOn() external onlyOwner{
1542         _saleEnabled = true;
1543     }
1544     
1545     function saleOff() external onlyOwner{
1546         _saleEnabled = false;
1547     }
1548 
1549     function totalSupply() public view override returns(uint256) {
1550         return maxTokens;
1551     }
1552     
1553     function setPrice(uint256 price_) external onlyOwner {
1554         price = price_;
1555     }
1556 
1557 
1558     function mintAdmin(address _to, uint256 count) external onlyOwner {
1559         require(tokensAvailable() >= count, "Max tokens reached");
1560         _safeMint(_to, count);
1561     }
1562     
1563 
1564     function mint(uint256 count) external payable {
1565         require(_saleEnabled, "Sale off");
1566         require(msg.value >= count*price, "Insufficient value to mint");
1567         require(tokensAvailable() >= count, "Max tokens reached");
1568         _safeMint(msg.sender, count);
1569     }
1570 
1571 
1572     function freeMint(uint256 count) external {
1573         require(_freeMintEnabled, "Free mint off");
1574         require(freeMints[msg.sender] + count <= _maxMintForUser, "You have max tokens");
1575         require(_currentFreeMints + count <= _maxFreeMints, "You have max tokens");
1576         _safeMint(msg.sender, count);
1577         freeMints[msg.sender] += count;
1578         _currentFreeMints += count;
1579     }
1580     
1581 
1582     function mintServer(uint256 count, string memory salt, bytes memory signature) external payable {
1583         bytes32 message = prefixed(keccak256(abi.encodePacked(msg.value, msg.sender, count, salt)));
1584         require(recoverSigner(message, signature) == serverAddress, "Error");
1585         signatureUsed[signature] = true;
1586         _safeMint(msg.sender, count);
1587     }
1588 
1589     function mintServer(uint256 count, string memory uri, string memory salt, bytes memory signature) external payable {
1590         bytes32 message = prefixed(keccak256(abi.encodePacked(msg.value, msg.sender, count, uri, salt)));
1591         require(recoverSigner(message, signature) == serverAddress, "Error");
1592         signatureUsed[signature] = true;
1593         for (uint256 i; i < count; i++) {
1594             customTokensURIs[_totalMinted() + i] = uri;
1595         }
1596         _safeMint(msg.sender, count);
1597     }
1598 
1599 
1600     function burn(uint256 tokenId) external {
1601         require(ownerOf(tokenId) == msg.sender || msg.sender == owner(), "You dont have this token");
1602         _burn(tokenId, false);
1603     }
1604 
1605 
1606     function splitSignature(bytes memory sig) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
1607         require(sig.length == 65);
1608         assembly {
1609             // first 32 bytes, after the length prefix
1610             r := mload(add(sig, 32))
1611             // second 32 bytes
1612             s := mload(add(sig, 64))
1613             // final byte (first byte of the next 32 bytes)
1614             v := byte(0, mload(add(sig, 96)))
1615         }
1616         return (v, r, s);
1617     }
1618 
1619 
1620     function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address) {
1621         (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);
1622         return ecrecover(message, v, r, s);
1623     }
1624     
1625     function prefixed(bytes32 hash) internal pure returns (bytes32) {
1626         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1627     }
1628 
1629     function setTokenURI(uint256 token, string memory uri) external onlyOwner {
1630         customTokensURIs[token] = uri;
1631     }
1632 
1633     function contractURI() public view returns (string memory) {
1634     	return _contractURI;
1635     }
1636     
1637     function withdraw() external onlyOwner
1638     {
1639         Address.sendValue(payable(msg.sender), address(this).balance);
1640     }
1641 
1642     function tokensAvailable() public view returns (uint256) {
1643         return maxTokens - _totalMinted();
1644     }
1645 
1646     function _baseURI() internal view override  returns (string memory) {
1647         return _baseTokenURI;
1648     }
1649 
1650     function setBaseURI(string memory uri) external onlyOwner {
1651         _baseTokenURI = uri;
1652     }
1653     
1654     function setContractURI(string memory uri) external onlyOwner {
1655         _contractURI = uri;
1656     }
1657     
1658     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1659         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1660         if(bytes(customTokensURIs[tokenId]).length != 0) return customTokensURIs[tokenId];
1661         string memory baseURI = _baseURI();
1662         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1663     }
1664 
1665     function URI(uint256 tokenId) external view virtual returns (string memory) {
1666         return tokenURI(tokenId);
1667     }
1668 }