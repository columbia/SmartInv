1 // SPDX-License-Identifier: MIT
2 // ERC721A Contracts v4.0.0
3 // Creator: Chiru Labs
4 
5 pragma solidity ^0.8.4;
6 
7 /**
8  * @dev Interface of an ERC721A compliant contract.
9  */
10 
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
91     function totalSupply() external view returns (uint256);
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
264 /**
265  * @dev ERC721 token receiver interface.
266  */
267 
268 interface ERC721A__IERC721Receiver {
269     function onERC721Received(
270         address operator,
271         address from,
272         uint256 tokenId,
273         bytes calldata data
274     ) external returns (bytes4);
275 }
276 
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
288 
289 contract ERC721A is IERC721A {
290     // Mask of an entry in packed address data.
291     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
292 
293     // The bit position of `numberMinted` in packed address data.
294     uint256 private constant BITPOS_NUMBER_MINTED = 64;
295 
296     // The bit position of `numberBurned` in packed address data.
297     uint256 private constant BITPOS_NUMBER_BURNED = 128;
298 
299     // The bit position of `aux` in packed address data.
300     uint256 private constant BITPOS_AUX = 192;
301 
302     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
303     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
304 
305     // The bit position of `startTimestamp` in packed ownership.
306     uint256 private constant BITPOS_START_TIMESTAMP = 160;
307 
308     // The bit mask of the `burned` bit in packed ownership.
309     uint256 private constant BITMASK_BURNED = 1 << 224;
310     
311     // The bit position of the `nextInitialized` bit in packed ownership.
312     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
313 
314     // The bit mask of the `nextInitialized` bit in packed ownership.
315     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
316 
317     // The tokenId of the next token to be minted.
318     uint256 private _currentIndex;
319 
320     // The number of tokens burned.
321     uint256 private _burnCounter;
322 
323     // Token name
324     string private _name;
325 
326     // Token symbol
327     string private _symbol;
328 
329     // Mapping from token ID to ownership details
330     // An empty struct value does not necessarily mean the token is unowned.
331     // See `_packedOwnershipOf` implementation for details.
332     //
333     // Bits Layout:
334     // - [0..159]   `addr`
335     // - [160..223] `startTimestamp`
336     // - [224]      `burned`
337     // - [225]      `nextInitialized`
338     mapping(uint256 => uint256) private _packedOwnerships;
339 
340     // Mapping owner address to address data.
341     //
342     // Bits Layout:
343     // - [0..63]    `balance`
344     // - [64..127]  `numberMinted`
345     // - [128..191] `numberBurned`
346     // - [192..255] `aux`
347     mapping(address => uint256) private _packedAddressData;
348 
349     // Mapping from token ID to approved address.
350     mapping(uint256 => address) private _tokenApprovals;
351 
352     // Mapping from owner to operator approvals
353     mapping(address => mapping(address => bool)) private _operatorApprovals;
354 
355     constructor(string memory name_, string memory symbol_) {
356         _name = name_;
357         _symbol = symbol_;
358         _currentIndex = _startTokenId();
359     }
360 
361     /**
362      * @dev Returns the starting token ID. 
363      * To change the starting token ID, please override this function.
364      */
365     function _startTokenId() internal view virtual returns (uint256) {
366         return 0;
367     }
368 
369     /**
370      * @dev Returns the next token ID to be minted.
371      */
372     function _nextTokenId() internal view returns (uint256) {
373         return _currentIndex;
374     }
375 
376     /**
377      * @dev Returns the total number of tokens in existence.
378      * Burned tokens will reduce the count. 
379      * To get the total number of tokens minted, please see `_totalMinted`.
380      */
381     function totalSupply() public view override returns (uint256) {
382         // Counter underflow is impossible as _burnCounter cannot be incremented
383         // more than `_currentIndex - _startTokenId()` times.
384         unchecked {
385             return _currentIndex - _burnCounter - _startTokenId();
386         }
387     }
388 
389     /**
390      * @dev Returns the total amount of tokens minted in the contract.
391      */
392     function _totalMinted() internal view returns (uint256) {
393         // Counter underflow is impossible as _currentIndex does not decrement,
394         // and it is initialized to `_startTokenId()`
395         unchecked {
396             return _currentIndex - _startTokenId();
397         }
398     }
399 
400     /**
401      * @dev Returns the total number of tokens burned.
402      */
403     function _totalBurned() internal view returns (uint256) {
404         return _burnCounter;
405     }
406 
407     /**
408      * @dev See {IERC165-supportsInterface}.
409      */
410     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
411         // The interface IDs are constants representing the first 4 bytes of the XOR of
412         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
413         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
414         return
415             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
416             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
417             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
418     }
419 
420     /**
421      * @dev See {IERC721-balanceOf}.
422      */
423     function balanceOf(address owner) public view override returns (uint256) {
424         if (owner == address(0)) revert BalanceQueryForZeroAddress();
425         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
426     }
427 
428     /**
429      * Returns the number of tokens minted by `owner`.
430      */
431     function _numberMinted(address owner) internal view returns (uint256) {
432         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
433     }
434 
435     /**
436      * Returns the number of tokens burned by or on behalf of `owner`.
437      */
438     function _numberBurned(address owner) internal view returns (uint256) {
439         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
440     }
441 
442     /**
443      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
444      */
445     function _getAux(address owner) internal view returns (uint64) {
446         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
447     }
448 
449     /**
450      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
451      * If there are multiple variables, please pack them into a uint64.
452      */
453     function _setAux(address owner, uint64 aux) internal {
454         uint256 packed = _packedAddressData[owner];
455         uint256 auxCasted;
456         assembly { // Cast aux without masking.
457             auxCasted := aux
458         }
459         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
460         _packedAddressData[owner] = packed;
461     }
462 
463     /**
464      * Returns the packed ownership data of `tokenId`.
465      */
466     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
467         uint256 curr = tokenId;
468 
469         unchecked {
470             if (_startTokenId() <= curr)
471                 if (curr < _currentIndex) {
472                     uint256 packed = _packedOwnerships[curr];
473                     // If not burned.
474                     if (packed & BITMASK_BURNED == 0) {
475                         // Invariant:
476                         // There will always be an ownership that has an address and is not burned
477                         // before an ownership that does not have an address and is not burned.
478                         // Hence, curr will not underflow.
479                         //
480                         // We can directly compare the packed value.
481                         // If the address is zero, packed is zero.
482                         while (packed == 0) {
483                             packed = _packedOwnerships[--curr];
484                         }
485                         return packed;
486                     }
487                 }
488         }
489         revert OwnerQueryForNonexistentToken();
490     }
491 
492     /**
493      * Returns the unpacked `TokenOwnership` struct from `packed`.
494      */
495     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
496         ownership.addr = address(uint160(packed));
497         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
498         ownership.burned = packed & BITMASK_BURNED != 0;
499     }
500 
501     /**
502      * Returns the unpacked `TokenOwnership` struct at `index`.
503      */
504     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
505         return _unpackedOwnership(_packedOwnerships[index]);
506     }
507 
508     /**
509      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
510      */
511     function _initializeOwnershipAt(uint256 index) internal {
512         if (_packedOwnerships[index] == 0) {
513             _packedOwnerships[index] = _packedOwnershipOf(index);
514         }
515     }
516 
517     /**
518      * Gas spent here starts off proportional to the maximum mint batch size.
519      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
520      */
521     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
522         return _unpackedOwnership(_packedOwnershipOf(tokenId));
523     }
524 
525     /**
526      * @dev See {IERC721-ownerOf}.
527      */
528     function ownerOf(uint256 tokenId) public view override returns (address) {
529         return address(uint160(_packedOwnershipOf(tokenId)));
530     }
531 
532     /**
533      * @dev See {IERC721Metadata-name}.
534      */
535     function name() public view virtual override returns (string memory) {
536         return _name;
537     }
538 
539     /**
540      * @dev See {IERC721Metadata-symbol}.
541      */
542     function symbol() public view virtual override returns (string memory) {
543         return _symbol;
544     }
545 
546     /**
547      * @dev See {IERC721Metadata-tokenURI}.
548      */
549     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
550         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
551 
552         string memory baseURI = _baseURI();
553         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
554     }
555 
556     /**
557      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
558      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
559      * by default, can be overriden in child contracts.
560      */
561     function _baseURI() internal view virtual returns (string memory) {
562         return '';
563     }
564 
565     /**
566      * @dev Casts the address to uint256 without masking.
567      */
568     function _addressToUint256(address value) private pure returns (uint256 result) {
569         assembly {
570             result := value
571         }
572     }
573 
574     /**
575      * @dev Casts the boolean to uint256 without branching.
576      */
577     function _boolToUint256(bool value) private pure returns (uint256 result) {
578         assembly {
579             result := value
580         }
581     }
582 
583     /**
584      * @dev See {IERC721-approve}.
585      */
586     function approve(address to, uint256 tokenId) public override {
587         address owner = address(uint160(_packedOwnershipOf(tokenId)));
588         if (to == owner) revert ApprovalToCurrentOwner();
589 
590         if (_msgSenderERC721A() != owner)
591             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
592                 revert ApprovalCallerNotOwnerNorApproved();
593             }
594 
595         _tokenApprovals[tokenId] = to;
596         emit Approval(owner, to, tokenId);
597     }
598 
599     /**
600      * @dev See {IERC721-getApproved}.
601      */
602     function getApproved(uint256 tokenId) public view override returns (address) {
603         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
604 
605         return _tokenApprovals[tokenId];
606     }
607 
608     /**
609      * @dev See {IERC721-setApprovalForAll}.
610      */
611     function setApprovalForAll(address operator, bool approved) public virtual override {
612         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
613 
614         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
615         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
616     }
617 
618     /**
619      * @dev See {IERC721-isApprovedForAll}.
620      */
621     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
622         return _operatorApprovals[owner][operator];
623     }
624 
625     /**
626      * @dev See {IERC721-transferFrom}.
627      */
628     function transferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) public virtual override {
633         _transfer(from, to, tokenId);
634     }
635 
636     /**
637      * @dev See {IERC721-safeTransferFrom}.
638      */
639     function safeTransferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) public virtual override {
644         safeTransferFrom(from, to, tokenId, '');
645     }
646 
647     /**
648      * @dev See {IERC721-safeTransferFrom}.
649      */
650     function safeTransferFrom(
651         address from,
652         address to,
653         uint256 tokenId,
654         bytes memory _data
655     ) public virtual override {
656         _transfer(from, to, tokenId);
657         if (to.code.length != 0)
658             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
659                 revert TransferToNonERC721ReceiverImplementer();
660             }
661     }
662 
663     /**
664      * @dev Returns whether `tokenId` exists.
665      *
666      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
667      *
668      * Tokens start existing when they are minted (`_mint`),
669      */
670     function _exists(uint256 tokenId) internal view returns (bool) {
671         return
672             _startTokenId() <= tokenId &&
673             tokenId < _currentIndex && // If within bounds,
674             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
675     }
676 
677     /**
678      * @dev Equivalent to `_safeMint(to, quantity, '')`.
679      */
680     function _safeMint(address to, uint256 quantity) internal {
681         _safeMint(to, quantity, '');
682     }
683 
684     /**
685      * @dev Safely mints `quantity` tokens and transfers them to `to`.
686      *
687      * Requirements:
688      *
689      * - If `to` refers to a smart contract, it must implement
690      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
691      * - `quantity` must be greater than 0.
692      *
693      * Emits a {Transfer} event.
694      */
695     function _safeMint(
696         address to,
697         uint256 quantity,
698         bytes memory _data
699     ) internal {
700         uint256 startTokenId = _currentIndex;
701         if (to == address(0)) revert MintToZeroAddress();
702         if (quantity == 0) revert MintZeroQuantity();
703 
704         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
705 
706         // Overflows are incredibly unrealistic.
707         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
708         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
709         unchecked {
710             // Updates:
711             // - `balance += quantity`.
712             // - `numberMinted += quantity`.
713             //
714             // We can directly add to the balance and number minted.
715             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
716 
717             // Updates:
718             // - `address` to the owner.
719             // - `startTimestamp` to the timestamp of minting.
720             // - `burned` to `false`.
721             // - `nextInitialized` to `quantity == 1`.
722             _packedOwnerships[startTokenId] =
723                 _addressToUint256(to) |
724                 (block.timestamp << BITPOS_START_TIMESTAMP) |
725                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
726 
727             uint256 updatedIndex = startTokenId;
728             uint256 end = updatedIndex + quantity;
729 
730             if (to.code.length != 0) {
731                 do {
732                     emit Transfer(address(0), to, updatedIndex);
733                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
734                         revert TransferToNonERC721ReceiverImplementer();
735                     }
736                 } while (updatedIndex < end);
737                 // Reentrancy protection
738                 if (_currentIndex != startTokenId) revert();
739             } else {
740                 do {
741                     emit Transfer(address(0), to, updatedIndex++);
742                 } while (updatedIndex < end);
743             }
744             _currentIndex = updatedIndex;
745         }
746         _afterTokenTransfers(address(0), to, startTokenId, quantity);
747     }
748 
749     /**
750      * @dev Mints `quantity` tokens and transfers them to `to`.
751      *
752      * Requirements:
753      *
754      * - `to` cannot be the zero address.
755      * - `quantity` must be greater than 0.
756      *
757      * Emits a {Transfer} event.
758      */
759     function _mint(address to, uint256 quantity) internal {
760         uint256 startTokenId = _currentIndex;
761         if (to == address(0)) revert MintToZeroAddress();
762         if (quantity == 0) revert MintZeroQuantity();
763 
764         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
765 
766         // Overflows are incredibly unrealistic.
767         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
768         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
769         unchecked {
770             // Updates:
771             // - `balance += quantity`.
772             // - `numberMinted += quantity`.
773             //
774             // We can directly add to the balance and number minted.
775             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
776 
777             // Updates:
778             // - `address` to the owner.
779             // - `startTimestamp` to the timestamp of minting.
780             // - `burned` to `false`.
781             // - `nextInitialized` to `quantity == 1`.
782             _packedOwnerships[startTokenId] =
783                 _addressToUint256(to) |
784                 (block.timestamp << BITPOS_START_TIMESTAMP) |
785                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
786 
787             uint256 updatedIndex = startTokenId;
788             uint256 end = updatedIndex + quantity;
789 
790             do {
791                 emit Transfer(address(0), to, updatedIndex++);
792             } while (updatedIndex < end);
793 
794             _currentIndex = updatedIndex;
795         }
796         _afterTokenTransfers(address(0), to, startTokenId, quantity);
797     }
798 
799     /**
800      * @dev Transfers `tokenId` from `from` to `to`.
801      *
802      * Requirements:
803      *
804      * - `to` cannot be the zero address.
805      * - `tokenId` token must be owned by `from`.
806      *
807      * Emits a {Transfer} event.
808      */
809     function _transfer(
810         address from,
811         address to,
812         uint256 tokenId
813     ) private {
814         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
815 
816         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
817 
818         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
819             isApprovedForAll(from, _msgSenderERC721A()) ||
820             getApproved(tokenId) == _msgSenderERC721A());
821 
822         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
823         if (to == address(0)) revert TransferToZeroAddress();
824 
825         _beforeTokenTransfers(from, to, tokenId, 1);
826 
827         // Clear approvals from the previous owner.
828         delete _tokenApprovals[tokenId];
829 
830         // Underflow of the sender's balance is impossible because we check for
831         // ownership above and the recipient's balance can't realistically overflow.
832         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
833         unchecked {
834             // We can directly increment and decrement the balances.
835             --_packedAddressData[from]; // Updates: `balance -= 1`.
836             ++_packedAddressData[to]; // Updates: `balance += 1`.
837 
838             // Updates:
839             // - `address` to the next owner.
840             // - `startTimestamp` to the timestamp of transfering.
841             // - `burned` to `false`.
842             // - `nextInitialized` to `true`.
843             _packedOwnerships[tokenId] =
844                 _addressToUint256(to) |
845                 (block.timestamp << BITPOS_START_TIMESTAMP) |
846                 BITMASK_NEXT_INITIALIZED;
847 
848             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
849             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
850                 uint256 nextTokenId = tokenId + 1;
851                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
852                 if (_packedOwnerships[nextTokenId] == 0) {
853                     // If the next slot is within bounds.
854                     if (nextTokenId != _currentIndex) {
855                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
856                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
857                     }
858                 }
859             }
860         }
861 
862         emit Transfer(from, to, tokenId);
863         _afterTokenTransfers(from, to, tokenId, 1);
864     }
865 
866     /**
867      * @dev Equivalent to `_burn(tokenId, false)`.
868      */
869     function _burn(uint256 tokenId) internal virtual {
870         _burn(tokenId, false);
871     }
872 
873     /**
874      * @dev Destroys `tokenId`.
875      * The approval is cleared when the token is burned.
876      *
877      * Requirements:
878      *
879      * - `tokenId` must exist.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
884         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
885 
886         address from = address(uint160(prevOwnershipPacked));
887 
888         if (approvalCheck) {
889             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
890                 isApprovedForAll(from, _msgSenderERC721A()) ||
891                 getApproved(tokenId) == _msgSenderERC721A());
892 
893             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
894         }
895 
896         _beforeTokenTransfers(from, address(0), tokenId, 1);
897 
898         // Clear approvals from the previous owner.
899         delete _tokenApprovals[tokenId];
900 
901         // Underflow of the sender's balance is impossible because we check for
902         // ownership above and the recipient's balance can't realistically overflow.
903         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
904         unchecked {
905             // Updates:
906             // - `balance -= 1`.
907             // - `numberBurned += 1`.
908             //
909             // We can directly decrement the balance, and increment the number burned.
910             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
911             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
912 
913             // Updates:
914             // - `address` to the last owner.
915             // - `startTimestamp` to the timestamp of burning.
916             // - `burned` to `true`.
917             // - `nextInitialized` to `true`.
918             _packedOwnerships[tokenId] =
919                 _addressToUint256(from) |
920                 (block.timestamp << BITPOS_START_TIMESTAMP) |
921                 BITMASK_BURNED | 
922                 BITMASK_NEXT_INITIALIZED;
923 
924             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
925             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
926                 uint256 nextTokenId = tokenId + 1;
927                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
928                 if (_packedOwnerships[nextTokenId] == 0) {
929                     // If the next slot is within bounds.
930                     if (nextTokenId != _currentIndex) {
931                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
932                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
933                     }
934                 }
935             }
936         }
937 
938         emit Transfer(from, address(0), tokenId);
939         _afterTokenTransfers(from, address(0), tokenId, 1);
940 
941         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
942         unchecked {
943             _burnCounter++;
944         }
945     }
946 
947     /**
948      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
949      *
950      * @param from address representing the previous owner of the given token ID
951      * @param to target address that will receive the tokens
952      * @param tokenId uint256 ID of the token to be transferred
953      * @param _data bytes optional data to send along with the call
954      * @return bool whether the call correctly returned the expected magic value
955      */
956     function _checkContractOnERC721Received(
957         address from,
958         address to,
959         uint256 tokenId,
960         bytes memory _data
961     ) private returns (bool) {
962         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
963             bytes4 retval
964         ) {
965             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
966         } catch (bytes memory reason) {
967             if (reason.length == 0) {
968                 revert TransferToNonERC721ReceiverImplementer();
969             } else {
970                 assembly {
971                     revert(add(32, reason), mload(reason))
972                 }
973             }
974         }
975     }
976 
977     /**
978      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
979      * And also called before burning one token.
980      *
981      * startTokenId - the first token id to be transferred
982      * quantity - the amount to be transferred
983      *
984      * Calling conditions:
985      *
986      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
987      * transferred to `to`.
988      * - When `from` is zero, `tokenId` will be minted for `to`.
989      * - When `to` is zero, `tokenId` will be burned by `from`.
990      * - `from` and `to` are never both zero.
991      */
992     function _beforeTokenTransfers(
993         address from,
994         address to,
995         uint256 startTokenId,
996         uint256 quantity
997     ) internal virtual {}
998 
999     /**
1000      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1001      * minting.
1002      * And also called after one token has been burned.
1003      *
1004      * startTokenId - the first token id to be transferred
1005      * quantity - the amount to be transferred
1006      *
1007      * Calling conditions:
1008      *
1009      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1010      * transferred to `to`.
1011      * - When `from` is zero, `tokenId` has been minted for `to`.
1012      * - When `to` is zero, `tokenId` has been burned by `from`.
1013      * - `from` and `to` are never both zero.
1014      */
1015     function _afterTokenTransfers(
1016         address from,
1017         address to,
1018         uint256 startTokenId,
1019         uint256 quantity
1020     ) internal virtual {}
1021 
1022     /**
1023      * @dev Returns the message sender (defaults to `msg.sender`).
1024      *
1025      * If you are writing GSN compatible contracts, you need to override this function.
1026      */
1027     function _msgSenderERC721A() internal view virtual returns (address) {
1028         return msg.sender;
1029     }
1030 
1031     /**
1032      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1033      */
1034     function _toString(uint256 value) internal pure returns (string memory ptr) {
1035         assembly {
1036             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1037             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1038             // We will need 1 32-byte word to store the length, 
1039             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1040             ptr := add(mload(0x40), 128)
1041             // Update the free memory pointer to allocate.
1042             mstore(0x40, ptr)
1043 
1044             // Cache the end of the memory to calculate the length later.
1045             let end := ptr
1046 
1047             // We write the string from the rightmost digit to the leftmost digit.
1048             // The following is essentially a do-while loop that also handles the zero case.
1049             // Costs a bit more than early returning for the zero case,
1050             // but cheaper in terms of deployment and overall runtime costs.
1051             for { 
1052                 // Initialize and perform the first pass without check.
1053                 let temp := value
1054                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1055                 ptr := sub(ptr, 1)
1056                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1057                 mstore8(ptr, add(48, mod(temp, 10)))
1058                 temp := div(temp, 10)
1059             } temp { 
1060                 // Keep dividing `temp` until zero.
1061                 temp := div(temp, 10)
1062             } { // Body of the for loop.
1063                 ptr := sub(ptr, 1)
1064                 mstore8(ptr, add(48, mod(temp, 10)))
1065             }
1066             
1067             let length := sub(end, ptr)
1068             // Move the pointer 32 bytes leftwards to make room for the length.
1069             ptr := sub(ptr, 32)
1070             // Store the length.
1071             mstore(ptr, length)
1072         }
1073     }
1074 }
1075 
1076 
1077 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1078 
1079 /**
1080  * @dev String operations.
1081  */
1082 
1083 library Strings {
1084     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1085     uint8 private constant _ADDRESS_LENGTH = 20;
1086 
1087     /**
1088      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1089      */
1090     function toString(uint256 value) internal pure returns (string memory) {
1091         // Inspired by OraclizeAPI's implementation - MIT licence
1092         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1093 
1094         if (value == 0) {
1095             return "0";
1096         }
1097         uint256 temp = value;
1098         uint256 digits;
1099         while (temp != 0) {
1100             digits++;
1101             temp /= 10;
1102         }
1103         bytes memory buffer = new bytes(digits);
1104         while (value != 0) {
1105             digits -= 1;
1106             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1107             value /= 10;
1108         }
1109         return string(buffer);
1110     }
1111 
1112     /**
1113      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1114      */
1115     function toHexString(uint256 value) internal pure returns (string memory) {
1116         if (value == 0) {
1117             return "0x00";
1118         }
1119         uint256 temp = value;
1120         uint256 length = 0;
1121         while (temp != 0) {
1122             length++;
1123             temp >>= 8;
1124         }
1125         return toHexString(value, length);
1126     }
1127 
1128     /**
1129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1130      */
1131     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1132         bytes memory buffer = new bytes(2 * length + 2);
1133         buffer[0] = "0";
1134         buffer[1] = "x";
1135         for (uint256 i = 2 * length + 1; i > 1; --i) {
1136             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1137             value >>= 4;
1138         }
1139         require(value == 0, "Strings: hex length insufficient");
1140         return string(buffer);
1141     }
1142 
1143     /**
1144      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1145      */
1146     function toHexString(address addr) internal pure returns (string memory) {
1147         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1148     }
1149 }
1150 
1151 
1152 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1153 
1154 /**
1155  * @dev Provides information about the current execution context, including the
1156  * sender of the transaction and its data. While these are generally available
1157  * via msg.sender and msg.data, they should not be accessed in such a direct
1158  * manner, since when dealing with meta-transactions the account sending and
1159  * paying for execution may not be the actual sender (as far as an application
1160  * is concerned).
1161  *
1162  * This contract is only required for intermediate, library-like contracts.
1163  */
1164 
1165 abstract contract Context {
1166     function _msgSender() internal view virtual returns (address) {
1167         return msg.sender;
1168     }
1169 
1170     function _msgData() internal view virtual returns (bytes calldata) {
1171         return msg.data;
1172     }
1173 }
1174 
1175 
1176 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1177 
1178 /**
1179  * @dev Contract module which provides a basic access control mechanism, where
1180  * there is an account (an owner) that can be granted exclusive access to
1181  * specific functions.
1182  *
1183  * By default, the owner account will be the one that deploys the contract. This
1184  * can later be changed with {transferOwnership}.
1185  *
1186  * This module is used through inheritance. It will make available the modifier
1187  * `onlyOwner`, which can be applied to your functions to restrict their use to
1188  * the owner.
1189  */
1190 
1191 abstract contract Ownable is Context {
1192     address private _owner;
1193 
1194     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1195 
1196     /**
1197      * @dev Initializes the contract setting the deployer as the initial owner.
1198      */
1199     constructor() {
1200         _transferOwnership(_msgSender());
1201     }
1202 
1203     /**
1204      * @dev Returns the address of the current owner.
1205      */
1206     function owner() public view virtual returns (address) {
1207         return _owner;
1208     }
1209 
1210     /**
1211      * @dev Throws if called by any account other than the owner.
1212      */
1213     modifier onlyOwner() {
1214         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1215         _;
1216     }
1217 
1218     /**
1219      * @dev Leaves the contract without owner. It will not be possible to call
1220      * `onlyOwner` functions anymore. Can only be called by the current owner.
1221      *
1222      * NOTE: Renouncing ownership will leave the contract without an owner,
1223      * thereby removing any functionality that is only available to the owner.
1224      */
1225     function renounceOwnership() public virtual onlyOwner {
1226         _transferOwnership(address(0));
1227     }
1228 
1229     /**
1230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1231      * Can only be called by the current owner.
1232      */
1233     function transferOwnership(address newOwner) public virtual onlyOwner {
1234         require(newOwner != address(0), "Ownable: new owner is the zero address");
1235         _transferOwnership(newOwner);
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Internal function without access restriction.
1241      */
1242     function _transferOwnership(address newOwner) internal virtual {
1243         address oldOwner = _owner;
1244         _owner = newOwner;
1245         emit OwnershipTransferred(oldOwner, newOwner);
1246     }
1247 }
1248 
1249 
1250 contract BeyondTheBoundary is ERC721A, Ownable {
1251 
1252     string public baseURI = "ipfs://QmSPmEqpmRa7t8FxkgYYdX6neZV4nwwQ21oo5qot4xUmhH/";
1253     string public contractURI = "ipfs://QmRLtq59Dr9v7NkGQNy9qnBqujapqdc896LMiqL1SQknvg";
1254     uint256 public constant MAX_SUPPLY = 250;
1255     uint256 public constant publicPrice = 5000000000000000;
1256     bool public unpaused = false;
1257 
1258     constructor() ERC721A("Beyond The Boundary", "BeyondTheBoundary") {}
1259 
1260     modifier callerIsUser() {
1261     require(tx.origin == msg.sender, "The caller is another contract");
1262     _;
1263   }
1264 
1265     function devMint() external onlyOwner {
1266         _safeMint(0x3E66467AC3b49CF71853fAf2A1F0F715c61cAd66, 1);
1267     }
1268 
1269     function publicMint() external payable callerIsUser {
1270         address _minter = _msgSender();
1271         require(unpaused, "Sale currently paused");
1272         require(minted(_minter) < 3, "Exceeds max per wallet");
1273         require(msg.value >= publicPrice, "Need to send more ETH.");
1274 
1275         _safeMint(_minter, 1);
1276         refundIfOver(publicPrice);
1277     }
1278 
1279     function refundIfOver(uint256 price) private {
1280         require(msg.value >= price, "Need to send more ETH.");
1281         if (msg.value > price) {
1282             payable(msg.sender).transfer(msg.value - price);
1283         }
1284     }
1285 
1286     // Override token counter to start at 1 instead of 0
1287     function _startTokenId() internal override view virtual returns (uint256) {
1288         return 1;
1289     }
1290 
1291     function minted(address _owner) public view returns (uint256) {
1292         return _numberMinted(_owner);
1293     }
1294 
1295     function withdraw() external onlyOwner {
1296         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1297         require(success, "Transfer failed.");
1298     }
1299 
1300     function toggleMint() external onlyOwner {
1301         unpaused = !unpaused;
1302     }
1303 
1304     function setBaseURI(string memory _baseURI) external onlyOwner {
1305         baseURI = _baseURI;
1306     }
1307 
1308     function setContractURI(string memory _contractURI) external onlyOwner {
1309         contractURI = _contractURI;
1310     }
1311 
1312     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1313         require(_exists(_tokenId), "Token does not exist.");
1314         return bytes(baseURI).length > 0 ? string(
1315             abi.encodePacked(
1316               baseURI,
1317               Strings.toString(_tokenId),
1318               ".json"
1319             )
1320         ) : "";
1321     }
1322 }