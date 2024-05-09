1 // SPDX-License-Identifier: MIT     
2 
3 // ERC721A Contracts v3.3.0
4 // Creator: Chiru Labs
5 
6 pragma solidity ^0.8.4;
7 
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
263 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
264 
265 
266 // ERC721A Contracts v3.3.0
267 // Creator: Chiru Labs
268 
269 pragma solidity ^0.8.4;
270 
271 
272 /**
273  * @dev ERC721 token receiver interface.
274  */
275 interface ERC721A__IERC721Receiver {
276     function onERC721Received(
277         address operator,
278         address from,
279         uint256 tokenId,
280         bytes calldata data
281     ) external returns (bytes4);
282 }
283 
284 /**
285  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
286  * the Metadata extension. Built to optimize for lower gas during batch mints.
287  *
288  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
289  *
290  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
291  *
292  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
293  */
294 contract ERC721A is IERC721A {
295     // Mask of an entry in packed address data.
296     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
297 
298     // The bit position of `numberMinted` in packed address data.
299     uint256 private constant BITPOS_NUMBER_MINTED = 64;
300 
301     // The bit position of `numberBurned` in packed address data.
302     uint256 private constant BITPOS_NUMBER_BURNED = 128;
303 
304     // The bit position of `aux` in packed address data.
305     uint256 private constant BITPOS_AUX = 192;
306 
307     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
308     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
309 
310     // The bit position of `startTimestamp` in packed ownership.
311     uint256 private constant BITPOS_START_TIMESTAMP = 160;
312 
313     // The bit mask of the `burned` bit in packed ownership.
314     uint256 private constant BITMASK_BURNED = 1 << 224;
315     
316     // The bit position of the `nextInitialized` bit in packed ownership.
317     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
318 
319     // The bit mask of the `nextInitialized` bit in packed ownership.
320     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
321 
322     // The tokenId of the next token to be minted.
323     uint256 private _currentIndex;
324 
325     // The number of tokens burned.
326     uint256 private _burnCounter;
327 
328     // Token name
329     string private _name;
330 
331     // Token symbol
332     string private _symbol;
333 
334     // Mapping from token ID to ownership details
335     // An empty struct value does not necessarily mean the token is unowned.
336     // See `_packedOwnershipOf` implementation for details.
337     //
338     // Bits Layout:
339     // - [0..159]   `addr`
340     // - [160..223] `startTimestamp`
341     // - [224]      `burned`
342     // - [225]      `nextInitialized`
343     mapping(uint256 => uint256) private _packedOwnerships;
344 
345     // Mapping owner address to address data.
346     //
347     // Bits Layout:
348     // - [0..63]    `balance`
349     // - [64..127]  `numberMinted`
350     // - [128..191] `numberBurned`
351     // - [192..255] `aux`
352     mapping(address => uint256) private _packedAddressData;
353 
354     // Mapping from token ID to approved address.
355     mapping(uint256 => address) private _tokenApprovals;
356 
357     // Mapping from owner to operator approvals
358     mapping(address => mapping(address => bool)) private _operatorApprovals;
359 
360     constructor(string memory name_, string memory symbol_) {
361         _name = name_;
362         _symbol = symbol_;
363         _currentIndex = _startTokenId();
364     }
365 
366     /**
367      * @dev Returns the starting token ID. 
368      * To change the starting token ID, please override this function.
369      */
370     function _startTokenId() internal view virtual returns (uint256) {
371         return 0;
372     }
373 
374     /**
375      * @dev Returns the next token ID to be minted.
376      */
377     function _nextTokenId() internal view returns (uint256) {
378         return _currentIndex;
379     }
380 
381     /**
382      * @dev Returns the total number of tokens in existence.
383      * Burned tokens will reduce the count. 
384      * To get the total number of tokens minted, please see `_totalMinted`.
385      */
386     function totalSupply() public view override returns (uint256) {
387         // Counter underflow is impossible as _burnCounter cannot be incremented
388         // more than `_currentIndex - _startTokenId()` times.
389         unchecked {
390             return _currentIndex - _burnCounter - _startTokenId();
391         }
392     }
393 
394     /**
395      * @dev Returns the total amount of tokens minted in the contract.
396      */
397     function _totalMinted() internal view returns (uint256) {
398         // Counter underflow is impossible as _currentIndex does not decrement,
399         // and it is initialized to `_startTokenId()`
400         unchecked {
401             return _currentIndex - _startTokenId();
402         }
403     }
404 
405     /**
406      * @dev Returns the total number of tokens burned.
407      */
408     function _totalBurned() internal view returns (uint256) {
409         return _burnCounter;
410     }
411 
412     /**
413      * @dev See {IERC165-supportsInterface}.
414      */
415     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
416         // The interface IDs are constants representing the first 4 bytes of the XOR of
417         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
418         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
419         return
420             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
421             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
422             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
423     }
424 
425     /**
426      * @dev See {IERC721-balanceOf}.
427      */
428     function balanceOf(address owner) public view override returns (uint256) {
429         if (owner == address(0)) revert BalanceQueryForZeroAddress();
430         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
431     }
432 
433     /**
434      * Returns the number of tokens minted by `owner`.
435      */
436     function _numberMinted(address owner) internal view returns (uint256) {
437         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
438     }
439 
440     /**
441      * Returns the number of tokens burned by or on behalf of `owner`.
442      */
443     function _numberBurned(address owner) internal view returns (uint256) {
444         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
445     }
446 
447     /**
448      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
449      */
450     function _getAux(address owner) internal view returns (uint64) {
451         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
452     }
453 
454     /**
455      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
456      * If there are multiple variables, please pack them into a uint64.
457      */
458     function _setAux(address owner, uint64 aux) internal {
459         uint256 packed = _packedAddressData[owner];
460         uint256 auxCasted;
461         assembly { // Cast aux without masking.
462             auxCasted := aux
463         }
464         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
465         _packedAddressData[owner] = packed;
466     }
467 
468     /**
469      * Returns the packed ownership data of `tokenId`.
470      */
471     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
472         uint256 curr = tokenId;
473 
474         unchecked {
475             if (_startTokenId() <= curr)
476                 if (curr < _currentIndex) {
477                     uint256 packed = _packedOwnerships[curr];
478                     // If not burned.
479                     if (packed & BITMASK_BURNED == 0) {
480                         // Invariant:
481                         // There will always be an ownership that has an address and is not burned
482                         // before an ownership that does not have an address and is not burned.
483                         // Hence, curr will not underflow.
484                         //
485                         // We can directly compare the packed value.
486                         // If the address is zero, packed is zero.
487                         while (packed == 0) {
488                             packed = _packedOwnerships[--curr];
489                         }
490                         return packed;
491                     }
492                 }
493         }
494         revert OwnerQueryForNonexistentToken();
495     }
496 
497     /**
498      * Returns the unpacked `TokenOwnership` struct from `packed`.
499      */
500     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
501         ownership.addr = address(uint160(packed));
502         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
503         ownership.burned = packed & BITMASK_BURNED != 0;
504     }
505 
506     /**
507      * Returns the unpacked `TokenOwnership` struct at `index`.
508      */
509     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
510         return _unpackedOwnership(_packedOwnerships[index]);
511     }
512 
513     /**
514      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
515      */
516     function _initializeOwnershipAt(uint256 index) internal {
517         if (_packedOwnerships[index] == 0) {
518             _packedOwnerships[index] = _packedOwnershipOf(index);
519         }
520     }
521 
522     /**
523      * Gas spent here starts off proportional to the maximum mint batch size.
524      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
525      */
526     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
527         return _unpackedOwnership(_packedOwnershipOf(tokenId));
528     }
529 
530     /**
531      * @dev See {IERC721-ownerOf}.
532      */
533     function ownerOf(uint256 tokenId) public view override returns (address) {
534         return address(uint160(_packedOwnershipOf(tokenId)));
535     }
536 
537     /**
538      * @dev See {IERC721Metadata-name}.
539      */
540     function name() public view virtual override returns (string memory) {
541         return _name;
542     }
543 
544     /**
545      * @dev See {IERC721Metadata-symbol}.
546      */
547     function symbol() public view virtual override returns (string memory) {
548         return _symbol;
549     }
550 
551     /**
552      * @dev See {IERC721Metadata-tokenURI}.
553      */
554     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
555         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
556 
557         string memory baseURI = _baseURI();
558         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
559     }
560 
561     /**
562      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
563      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
564      * by default, can be overriden in child contracts.
565      */
566     function _baseURI() internal view virtual returns (string memory) {
567         return '';
568     }
569 
570     /**
571      * @dev Casts the address to uint256 without masking.
572      */
573     function _addressToUint256(address value) private pure returns (uint256 result) {
574         assembly {
575             result := value
576         }
577     }
578 
579     /**
580      * @dev Casts the boolean to uint256 without branching.
581      */
582     function _boolToUint256(bool value) private pure returns (uint256 result) {
583         assembly {
584             result := value
585         }
586     }
587 
588     /**
589      * @dev See {IERC721-approve}.
590      */
591     function approve(address to, uint256 tokenId) public override {
592         address owner = address(uint160(_packedOwnershipOf(tokenId)));
593         if (to == owner) revert ApprovalToCurrentOwner();
594 
595         if (_msgSenderERC721A() != owner)
596             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
597                 revert ApprovalCallerNotOwnerNorApproved();
598             }
599 
600         _tokenApprovals[tokenId] = to;
601         emit Approval(owner, to, tokenId);
602     }
603 
604     /**
605      * @dev See {IERC721-getApproved}.
606      */
607     function getApproved(uint256 tokenId) public view override returns (address) {
608         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
609 
610         return _tokenApprovals[tokenId];
611     }
612 
613     /**
614      * @dev See {IERC721-setApprovalForAll}.
615      */
616     function setApprovalForAll(address operator, bool approved) public virtual override {
617         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
618 
619         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
620         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
621     }
622 
623     /**
624      * @dev See {IERC721-isApprovedForAll}.
625      */
626     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
627         return _operatorApprovals[owner][operator];
628     }
629 
630     /**
631      * @dev See {IERC721-transferFrom}.
632      */
633     function transferFrom(
634         address from,
635         address to,
636         uint256 tokenId
637     ) public virtual override {
638         _transfer(from, to, tokenId);
639     }
640 
641     /**
642      * @dev See {IERC721-safeTransferFrom}.
643      */
644     function safeTransferFrom(
645         address from,
646         address to,
647         uint256 tokenId
648     ) public virtual override {
649         safeTransferFrom(from, to, tokenId, '');
650     }
651 
652     /**
653      * @dev See {IERC721-safeTransferFrom}.
654      */
655     function safeTransferFrom(
656         address from,
657         address to,
658         uint256 tokenId,
659         bytes memory _data
660     ) public virtual override {
661         _transfer(from, to, tokenId);
662         if (to.code.length != 0)
663             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
664                 revert TransferToNonERC721ReceiverImplementer();
665             }
666     }
667 
668     /**
669      * @dev Returns whether `tokenId` exists.
670      *
671      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
672      *
673      * Tokens start existing when they are minted (`_mint`),
674      */
675     function _exists(uint256 tokenId) internal view returns (bool) {
676         return
677             _startTokenId() <= tokenId &&
678             tokenId < _currentIndex && // If within bounds,
679             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
680     }
681 
682     /**
683      * @dev Equivalent to `_safeMint(to, quantity, '')`.
684      */
685     function _safeMint(address to, uint256 quantity) internal {
686         _safeMint(to, quantity, '');
687     }
688 
689     /**
690      * @dev Safely mints `quantity` tokens and transfers them to `to`.
691      *
692      * Requirements:
693      *
694      * - If `to` refers to a smart contract, it must implement
695      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
696      * - `quantity` must be greater than 0.
697      *
698      * Emits a {Transfer} event.
699      */
700     function _safeMint(
701         address to,
702         uint256 quantity,
703         bytes memory _data
704     ) internal {
705         uint256 startTokenId = _currentIndex;
706         if (to == address(0)) revert MintToZeroAddress();
707         if (quantity == 0) revert MintZeroQuantity();
708 
709         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
710 
711         // Overflows are incredibly unrealistic.
712         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
713         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
714         unchecked {
715             // Updates:
716             // - `balance += quantity`.
717             // - `numberMinted += quantity`.
718             //
719             // We can directly add to the balance and number minted.
720             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
721 
722             // Updates:
723             // - `address` to the owner.
724             // - `startTimestamp` to the timestamp of minting.
725             // - `burned` to `false`.
726             // - `nextInitialized` to `quantity == 1`.
727             _packedOwnerships[startTokenId] =
728                 _addressToUint256(to) |
729                 (block.timestamp << BITPOS_START_TIMESTAMP) |
730                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
731 
732             uint256 updatedIndex = startTokenId;
733             uint256 end = updatedIndex + quantity;
734 
735             if (to.code.length != 0) {
736                 do {
737                     emit Transfer(address(0), to, updatedIndex);
738                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
739                         revert TransferToNonERC721ReceiverImplementer();
740                     }
741                 } while (updatedIndex < end);
742                 // Reentrancy protection
743                 if (_currentIndex != startTokenId) revert();
744             } else {
745                 do {
746                     emit Transfer(address(0), to, updatedIndex++);
747                 } while (updatedIndex < end);
748             }
749             _currentIndex = updatedIndex;
750         }
751         _afterTokenTransfers(address(0), to, startTokenId, quantity);
752     }
753 
754     /**
755      * @dev Mints `quantity` tokens and transfers them to `to`.
756      *
757      * Requirements:
758      *
759      * - `to` cannot be the zero address.
760      * - `quantity` must be greater than 0.
761      *
762      * Emits a {Transfer} event.
763      */
764     function _mint(address to, uint256 quantity) internal {
765         uint256 startTokenId = _currentIndex;
766         if (to == address(0)) revert MintToZeroAddress();
767         if (quantity == 0) revert MintZeroQuantity();
768 
769         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
770 
771         // Overflows are incredibly unrealistic.
772         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
773         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
774         unchecked {
775             // Updates:
776             // - `balance += quantity`.
777             // - `numberMinted += quantity`.
778             //
779             // We can directly add to the balance and number minted.
780             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
781 
782             // Updates:
783             // - `address` to the owner.
784             // - `startTimestamp` to the timestamp of minting.
785             // - `burned` to `false`.
786             // - `nextInitialized` to `quantity == 1`.
787             _packedOwnerships[startTokenId] =
788                 _addressToUint256(to) |
789                 (block.timestamp << BITPOS_START_TIMESTAMP) |
790                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
791 
792             uint256 updatedIndex = startTokenId;
793             uint256 end = updatedIndex + quantity;
794 
795             do {
796                 emit Transfer(address(0), to, updatedIndex++);
797             } while (updatedIndex < end);
798 
799             _currentIndex = updatedIndex;
800         }
801         _afterTokenTransfers(address(0), to, startTokenId, quantity);
802     }
803 
804     /**
805      * @dev Transfers `tokenId` from `from` to `to`.
806      *
807      * Requirements:
808      *
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must be owned by `from`.
811      *
812      * Emits a {Transfer} event.
813      */
814     function _transfer(
815         address from,
816         address to,
817         uint256 tokenId
818     ) private {
819         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
820 
821         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
822 
823         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
824             isApprovedForAll(from, _msgSenderERC721A()) ||
825             getApproved(tokenId) == _msgSenderERC721A());
826 
827         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
828         if (to == address(0)) revert TransferToZeroAddress();
829 
830         _beforeTokenTransfers(from, to, tokenId, 1);
831 
832         // Clear approvals from the previous owner.
833         delete _tokenApprovals[tokenId];
834 
835         // Underflow of the sender's balance is impossible because we check for
836         // ownership above and the recipient's balance can't realistically overflow.
837         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
838         unchecked {
839             // We can directly increment and decrement the balances.
840             --_packedAddressData[from]; // Updates: `balance -= 1`.
841             ++_packedAddressData[to]; // Updates: `balance += 1`.
842 
843             // Updates:
844             // - `address` to the next owner.
845             // - `startTimestamp` to the timestamp of transfering.
846             // - `burned` to `false`.
847             // - `nextInitialized` to `true`.
848             _packedOwnerships[tokenId] =
849                 _addressToUint256(to) |
850                 (block.timestamp << BITPOS_START_TIMESTAMP) |
851                 BITMASK_NEXT_INITIALIZED;
852 
853             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
854             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
855                 uint256 nextTokenId = tokenId + 1;
856                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
857                 if (_packedOwnerships[nextTokenId] == 0) {
858                     // If the next slot is within bounds.
859                     if (nextTokenId != _currentIndex) {
860                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
861                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
862                     }
863                 }
864             }
865         }
866 
867         emit Transfer(from, to, tokenId);
868         _afterTokenTransfers(from, to, tokenId, 1);
869     }
870 
871     /**
872      * @dev Equivalent to `_burn(tokenId, false)`.
873      */
874     function _burn(uint256 tokenId) internal virtual {
875         _burn(tokenId, false);
876     }
877 
878     /**
879      * @dev Destroys `tokenId`.
880      * The approval is cleared when the token is burned.
881      *
882      * Requirements:
883      *
884      * - `tokenId` must exist.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
889         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
890 
891         address from = address(uint160(prevOwnershipPacked));
892 
893         if (approvalCheck) {
894             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
895                 isApprovedForAll(from, _msgSenderERC721A()) ||
896                 getApproved(tokenId) == _msgSenderERC721A());
897 
898             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
899         }
900 
901         _beforeTokenTransfers(from, address(0), tokenId, 1);
902 
903         // Clear approvals from the previous owner.
904         delete _tokenApprovals[tokenId];
905 
906         // Underflow of the sender's balance is impossible because we check for
907         // ownership above and the recipient's balance can't realistically overflow.
908         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
909         unchecked {
910             // Updates:
911             // - `balance -= 1`.
912             // - `numberBurned += 1`.
913             //
914             // We can directly decrement the balance, and increment the number burned.
915             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
916             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
917 
918             // Updates:
919             // - `address` to the last owner.
920             // - `startTimestamp` to the timestamp of burning.
921             // - `burned` to `true`.
922             // - `nextInitialized` to `true`.
923             _packedOwnerships[tokenId] =
924                 _addressToUint256(from) |
925                 (block.timestamp << BITPOS_START_TIMESTAMP) |
926                 BITMASK_BURNED | 
927                 BITMASK_NEXT_INITIALIZED;
928 
929             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
930             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
931                 uint256 nextTokenId = tokenId + 1;
932                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
933                 if (_packedOwnerships[nextTokenId] == 0) {
934                     // If the next slot is within bounds.
935                     if (nextTokenId != _currentIndex) {
936                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
937                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
938                     }
939                 }
940             }
941         }
942 
943         emit Transfer(from, address(0), tokenId);
944         _afterTokenTransfers(from, address(0), tokenId, 1);
945 
946         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
947         unchecked {
948             _burnCounter++;
949         }
950     }
951 
952     /**
953      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
954      *
955      * @param from address representing the previous owner of the given token ID
956      * @param to target address that will receive the tokens
957      * @param tokenId uint256 ID of the token to be transferred
958      * @param _data bytes optional data to send along with the call
959      * @return bool whether the call correctly returned the expected magic value
960      */
961     function _checkContractOnERC721Received(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) private returns (bool) {
967         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
968             bytes4 retval
969         ) {
970             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
971         } catch (bytes memory reason) {
972             if (reason.length == 0) {
973                 revert TransferToNonERC721ReceiverImplementer();
974             } else {
975                 assembly {
976                     revert(add(32, reason), mload(reason))
977                 }
978             }
979         }
980     }
981 
982     /**
983      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
984      * And also called before burning one token.
985      *
986      * startTokenId - the first token id to be transferred
987      * quantity - the amount to be transferred
988      *
989      * Calling conditions:
990      *
991      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
992      * transferred to `to`.
993      * - When `from` is zero, `tokenId` will be minted for `to`.
994      * - When `to` is zero, `tokenId` will be burned by `from`.
995      * - `from` and `to` are never both zero.
996      */
997     function _beforeTokenTransfers(
998         address from,
999         address to,
1000         uint256 startTokenId,
1001         uint256 quantity
1002     ) internal virtual {}
1003 
1004     /**
1005      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1006      * minting.
1007      * And also called after one token has been burned.
1008      *
1009      * startTokenId - the first token id to be transferred
1010      * quantity - the amount to be transferred
1011      *
1012      * Calling conditions:
1013      *
1014      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1015      * transferred to `to`.
1016      * - When `from` is zero, `tokenId` has been minted for `to`.
1017      * - When `to` is zero, `tokenId` has been burned by `from`.
1018      * - `from` and `to` are never both zero.
1019      */
1020     function _afterTokenTransfers(
1021         address from,
1022         address to,
1023         uint256 startTokenId,
1024         uint256 quantity
1025     ) internal virtual {}
1026 
1027     /**
1028      * @dev Returns the message sender (defaults to `msg.sender`).
1029      *
1030      * If you are writing GSN compatible contracts, you need to override this function.
1031      */
1032     function _msgSenderERC721A() internal view virtual returns (address) {
1033         return msg.sender;
1034     }
1035 
1036     /**
1037      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1038      */
1039     function _toString(uint256 value) internal pure returns (string memory ptr) {
1040         assembly {
1041             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1042             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1043             // We will need 1 32-byte word to store the length, 
1044             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1045             ptr := add(mload(0x40), 128)
1046             // Update the free memory pointer to allocate.
1047             mstore(0x40, ptr)
1048 
1049             // Cache the end of the memory to calculate the length later.
1050             let end := ptr
1051 
1052             // We write the string from the rightmost digit to the leftmost digit.
1053             // The following is essentially a do-while loop that also handles the zero case.
1054             // Costs a bit more than early returning for the zero case,
1055             // but cheaper in terms of deployment and overall runtime costs.
1056             for { 
1057                 // Initialize and perform the first pass without check.
1058                 let temp := value
1059                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1060                 ptr := sub(ptr, 1)
1061                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1062                 mstore8(ptr, add(48, mod(temp, 10)))
1063                 temp := div(temp, 10)
1064             } temp { 
1065                 // Keep dividing `temp` until zero.
1066                 temp := div(temp, 10)
1067             } { // Body of the for loop.
1068                 ptr := sub(ptr, 1)
1069                 mstore8(ptr, add(48, mod(temp, 10)))
1070             }
1071             
1072             let length := sub(end, ptr)
1073             // Move the pointer 32 bytes leftwards to make room for the length.
1074             ptr := sub(ptr, 32)
1075             // Store the length.
1076             mstore(ptr, length)
1077         }
1078     }
1079 }
1080 
1081 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1082 
1083 
1084 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1085 
1086 pragma solidity ^0.8.0;
1087 
1088 /**
1089  * @dev String operations.
1090  */
1091 library Strings {
1092     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1093     uint8 private constant _ADDRESS_LENGTH = 20;
1094 
1095     /**
1096      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1097      */
1098     function toString(uint256 value) internal pure returns (string memory) {
1099         // Inspired by OraclizeAPI's implementation - MIT licence
1100         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1101 
1102         if (value == 0) {
1103             return "0";
1104         }
1105         uint256 temp = value;
1106         uint256 digits;
1107         while (temp != 0) {
1108             digits++;
1109             temp /= 10;
1110         }
1111         bytes memory buffer = new bytes(digits);
1112         while (value != 0) {
1113             digits -= 1;
1114             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1115             value /= 10;
1116         }
1117         return string(buffer);
1118     }
1119 
1120     /**
1121      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1122      */
1123     function toHexString(uint256 value) internal pure returns (string memory) {
1124         if (value == 0) {
1125             return "0x00";
1126         }
1127         uint256 temp = value;
1128         uint256 length = 0;
1129         while (temp != 0) {
1130             length++;
1131             temp >>= 8;
1132         }
1133         return toHexString(value, length);
1134     }
1135 
1136     /**
1137      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1138      */
1139     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1140         bytes memory buffer = new bytes(2 * length + 2);
1141         buffer[0] = "0";
1142         buffer[1] = "x";
1143         for (uint256 i = 2 * length + 1; i > 1; --i) {
1144             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1145             value >>= 4;
1146         }
1147         require(value == 0, "Strings: hex length insufficient");
1148         return string(buffer);
1149     }
1150 
1151     /**
1152      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1153      */
1154     function toHexString(address addr) internal pure returns (string memory) {
1155         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1156     }
1157 }
1158 
1159 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1160 
1161 
1162 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1163 
1164 pragma solidity ^0.8.0;
1165 
1166 /**
1167  * @dev Provides information about the current execution context, including the
1168  * sender of the transaction and its data. While these are generally available
1169  * via msg.sender and msg.data, they should not be accessed in such a direct
1170  * manner, since when dealing with meta-transactions the account sending and
1171  * paying for execution may not be the actual sender (as far as an application
1172  * is concerned).
1173  *
1174  * This contract is only required for intermediate, library-like contracts.
1175  */
1176 abstract contract Context {
1177     function _msgSender() internal view virtual returns (address) {
1178         return msg.sender;
1179     }
1180 
1181     function _msgData() internal view virtual returns (bytes calldata) {
1182         return msg.data;
1183     }
1184 }
1185 
1186 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1187 
1188 
1189 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 
1194 /**
1195  * @dev Contract module which provides a basic access control mechanism, where
1196  * there is an account (an owner) that can be granted exclusive access to
1197  * specific functions.
1198  *
1199  * By default, the owner account will be the one that deploys the contract. This
1200  * can later be changed with {transferOwnership}.
1201  *
1202  * This module is used through inheritance. It will make available the modifier
1203  * `onlyOwner`, which can be applied to your functions to restrict their use to
1204  * the owner.
1205  */
1206 abstract contract Ownable is Context {
1207     address private _owner;
1208 
1209     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1210 
1211     /**
1212      * @dev Initializes the contract setting the deployer as the initial owner.
1213      */
1214     constructor() {
1215         _transferOwnership(_msgSender());
1216     }
1217 
1218     /**
1219      * @dev Returns the address of the current owner.
1220      */
1221     function owner() public view virtual returns (address) {
1222         return _owner;
1223     }
1224 
1225     /**
1226      * @dev Throws if called by any account other than the owner.
1227      */
1228     modifier onlyOwner() {
1229         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1230         _;
1231     }
1232 
1233     /**
1234      * @dev Leaves the contract without owner. It will not be possible to call
1235      * `onlyOwner` functions anymore. Can only be called by the current owner.
1236      *
1237      * NOTE: Renouncing ownership will leave the contract without an owner,
1238      * thereby removing any functionality that is only available to the owner.
1239      */
1240     function renounceOwnership() public virtual onlyOwner {
1241         _transferOwnership(address(0));
1242     }
1243 
1244     /**
1245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1246      * Can only be called by the current owner.
1247      */
1248     function transferOwnership(address newOwner) public virtual onlyOwner {
1249         require(newOwner != address(0), "Ownable: new owner is the zero address");
1250         _transferOwnership(newOwner);
1251     }
1252 
1253     /**
1254      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1255      * Internal function without access restriction.
1256      */
1257     function _transferOwnership(address newOwner) internal virtual {
1258         address oldOwner = _owner;
1259         _owner = newOwner;
1260         emit OwnershipTransferred(oldOwner, newOwner);
1261     }
1262 }
1263 
1264 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1265 
1266 
1267 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1268 
1269 pragma solidity ^0.8.1;
1270 
1271 /**
1272  * @dev Collection of functions related to the address type
1273  */
1274 library Address {
1275     /**
1276      * @dev Returns true if `account` is a contract.
1277      *
1278      * [IMPORTANT]
1279      * ====
1280      * It is unsafe to assume that an address for which this function returns
1281      * false is an externally-owned account (EOA) and not a contract.
1282      *
1283      * Among others, `isContract` will return false for the following
1284      * types of addresses:
1285      *
1286      *  - an externally-owned account
1287      *  - a contract in construction
1288      *  - an address where a contract will be created
1289      *  - an address where a contract lived, but was destroyed
1290      * ====
1291      *
1292      * [IMPORTANT]
1293      * ====
1294      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1295      *
1296      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1297      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1298      * constructor.
1299      * ====
1300      */
1301     function isContract(address account) internal view returns (bool) {
1302         // This method relies on extcodesize/address.code.length, which returns 0
1303         // for contracts in construction, since the code is only stored at the end
1304         // of the constructor execution.
1305 
1306         return account.code.length > 0;
1307     }
1308 
1309     /**
1310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1311      * `recipient`, forwarding all available gas and reverting on errors.
1312      *
1313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1315      * imposed by `transfer`, making them unable to receive funds via
1316      * `transfer`. {sendValue} removes this limitation.
1317      *
1318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1319      *
1320      * IMPORTANT: because control is transferred to `recipient`, care must be
1321      * taken to not create reentrancy vulnerabilities. Consider using
1322      * {ReentrancyGuard} or the
1323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1324      */
1325     function sendValue(address payable recipient, uint256 amount) internal {
1326         require(address(this).balance >= amount, "Address: insufficient balance");
1327 
1328         (bool success, ) = recipient.call{value: amount}("");
1329         require(success, "Address: unable to send value, recipient may have reverted");
1330     }
1331 
1332     /**
1333      * @dev Performs a Solidity function call using a low level `call`. A
1334      * plain `call` is an unsafe replacement for a function call: use this
1335      * function instead.
1336      *
1337      * If `target` reverts with a revert reason, it is bubbled up by this
1338      * function (like regular Solidity function calls).
1339      *
1340      * Returns the raw returned data. To convert to the expected return value,
1341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1342      *
1343      * Requirements:
1344      *
1345      * - `target` must be a contract.
1346      * - calling `target` with `data` must not revert.
1347      *
1348      * _Available since v3.1._
1349      */
1350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1351         return functionCall(target, data, "Address: low-level call failed");
1352     }
1353 
1354     /**
1355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1356      * `errorMessage` as a fallback revert reason when `target` reverts.
1357      *
1358      * _Available since v3.1._
1359      */
1360     function functionCall(
1361         address target,
1362         bytes memory data,
1363         string memory errorMessage
1364     ) internal returns (bytes memory) {
1365         return functionCallWithValue(target, data, 0, errorMessage);
1366     }
1367 
1368     /**
1369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1370      * but also transferring `value` wei to `target`.
1371      *
1372      * Requirements:
1373      *
1374      * - the calling contract must have an ETH balance of at least `value`.
1375      * - the called Solidity function must be `payable`.
1376      *
1377      * _Available since v3.1._
1378      */
1379     function functionCallWithValue(
1380         address target,
1381         bytes memory data,
1382         uint256 value
1383     ) internal returns (bytes memory) {
1384         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1385     }
1386 
1387     /**
1388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1389      * with `errorMessage` as a fallback revert reason when `target` reverts.
1390      *
1391      * _Available since v3.1._
1392      */
1393     function functionCallWithValue(
1394         address target,
1395         bytes memory data,
1396         uint256 value,
1397         string memory errorMessage
1398     ) internal returns (bytes memory) {
1399         require(address(this).balance >= value, "Address: insufficient balance for call");
1400         require(isContract(target), "Address: call to non-contract");
1401 
1402         (bool success, bytes memory returndata) = target.call{value: value}(data);
1403         return verifyCallResult(success, returndata, errorMessage);
1404     }
1405 
1406     /**
1407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1408      * but performing a static call.
1409      *
1410      * _Available since v3.3._
1411      */
1412     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1413         return functionStaticCall(target, data, "Address: low-level static call failed");
1414     }
1415 
1416     /**
1417      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1418      * but performing a static call.
1419      *
1420      * _Available since v3.3._
1421      */
1422     function functionStaticCall(
1423         address target,
1424         bytes memory data,
1425         string memory errorMessage
1426     ) internal view returns (bytes memory) {
1427         require(isContract(target), "Address: static call to non-contract");
1428 
1429         (bool success, bytes memory returndata) = target.staticcall(data);
1430         return verifyCallResult(success, returndata, errorMessage);
1431     }
1432 
1433     /**
1434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1435      * but performing a delegate call.
1436      *
1437      * _Available since v3.4._
1438      */
1439     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1440         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1441     }
1442 
1443     /**
1444      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1445      * but performing a delegate call.
1446      *
1447      * _Available since v3.4._
1448      */
1449     function functionDelegateCall(
1450         address target,
1451         bytes memory data,
1452         string memory errorMessage
1453     ) internal returns (bytes memory) {
1454         require(isContract(target), "Address: delegate call to non-contract");
1455 
1456         (bool success, bytes memory returndata) = target.delegatecall(data);
1457         return verifyCallResult(success, returndata, errorMessage);
1458     }
1459 
1460     /**
1461      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1462      * revert reason using the provided one.
1463      *
1464      * _Available since v4.3._
1465      */
1466     function verifyCallResult(
1467         bool success,
1468         bytes memory returndata,
1469         string memory errorMessage
1470     ) internal pure returns (bytes memory) {
1471         if (success) {
1472             return returndata;
1473         } else {
1474             // Look for revert reason and bubble it up if present
1475             if (returndata.length > 0) {
1476                 // The easiest way to bubble the revert reason is using memory via assembly
1477 
1478                 assembly {
1479                     let returndata_size := mload(returndata)
1480                     revert(add(32, returndata), returndata_size)
1481                 }
1482             } else {
1483                 revert(errorMessage);
1484             }
1485         }
1486     }
1487 }
1488 
1489 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1490 
1491 
1492 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1493 
1494 pragma solidity ^0.8.0;
1495 
1496 /**
1497  * @title ERC721 token receiver interface
1498  * @dev Interface for any contract that wants to support safeTransfers
1499  * from ERC721 asset contracts.
1500  */
1501 interface IERC721Receiver {
1502     /**
1503      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1504      * by `operator` from `from`, this function is called.
1505      *
1506      * It must return its Solidity selector to confirm the token transfer.
1507      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1508      *
1509      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1510      */
1511     function onERC721Received(
1512         address operator,
1513         address from,
1514         uint256 tokenId,
1515         bytes calldata data
1516     ) external returns (bytes4);
1517 }
1518 
1519 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1520 
1521 
1522 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1523 
1524 pragma solidity ^0.8.0;
1525 
1526 /**
1527  * @dev Interface of the ERC165 standard, as defined in the
1528  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1529  *
1530  * Implementers can declare support of contract interfaces, which can then be
1531  * queried by others ({ERC165Checker}).
1532  *
1533  * For an implementation, see {ERC165}.
1534  */
1535 interface IERC165 {
1536     /**
1537      * @dev Returns true if this contract implements the interface defined by
1538      * `interfaceId`. See the corresponding
1539      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1540      * to learn more about how these ids are created.
1541      *
1542      * This function call must use less than 30 000 gas.
1543      */
1544     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1545 }
1546 
1547 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1548 
1549 
1550 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1551 
1552 pragma solidity ^0.8.0;
1553 
1554 
1555 /**
1556  * @dev Implementation of the {IERC165} interface.
1557  *
1558  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1559  * for the additional interface id that will be supported. For example:
1560  *
1561  * ```solidity
1562  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1563  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1564  * }
1565  * ```
1566  *
1567  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1568  */
1569 abstract contract ERC165 is IERC165 {
1570     /**
1571      * @dev See {IERC165-supportsInterface}.
1572      */
1573     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1574         return interfaceId == type(IERC165).interfaceId;
1575     }
1576 }
1577 
1578 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1579 
1580 
1581 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1582 
1583 pragma solidity ^0.8.0;
1584 
1585 
1586 /**
1587  * @dev Required interface of an ERC721 compliant contract.
1588  */
1589 interface IERC721 is IERC165 {
1590     /**
1591      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1592      */
1593     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1594 
1595     /**
1596      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1597      */
1598     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1599 
1600     /**
1601      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1602      */
1603     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1604 
1605     /**
1606      * @dev Returns the number of tokens in ``owner``'s account.
1607      */
1608     function balanceOf(address owner) external view returns (uint256 balance);
1609 
1610     /**
1611      * @dev Returns the owner of the `tokenId` token.
1612      *
1613      * Requirements:
1614      *
1615      * - `tokenId` must exist.
1616      */
1617     function ownerOf(uint256 tokenId) external view returns (address owner);
1618 
1619     /**
1620      * @dev Safely transfers `tokenId` token from `from` to `to`.
1621      *
1622      * Requirements:
1623      *
1624      * - `from` cannot be the zero address.
1625      * - `to` cannot be the zero address.
1626      * - `tokenId` token must exist and be owned by `from`.
1627      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1628      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1629      *
1630      * Emits a {Transfer} event.
1631      */
1632     function safeTransferFrom(
1633         address from,
1634         address to,
1635         uint256 tokenId,
1636         bytes calldata data
1637     ) external;
1638 
1639     /**
1640      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1641      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1642      *
1643      * Requirements:
1644      *
1645      * - `from` cannot be the zero address.
1646      * - `to` cannot be the zero address.
1647      * - `tokenId` token must exist and be owned by `from`.
1648      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1649      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1650      *
1651      * Emits a {Transfer} event.
1652      */
1653     function safeTransferFrom(
1654         address from,
1655         address to,
1656         uint256 tokenId
1657     ) external;
1658 
1659     /**
1660      * @dev Transfers `tokenId` token from `from` to `to`.
1661      *
1662      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1663      *
1664      * Requirements:
1665      *
1666      * - `from` cannot be the zero address.
1667      * - `to` cannot be the zero address.
1668      * - `tokenId` token must be owned by `from`.
1669      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1670      *
1671      * Emits a {Transfer} event.
1672      */
1673     function transferFrom(
1674         address from,
1675         address to,
1676         uint256 tokenId
1677     ) external;
1678 
1679     /**
1680      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1681      * The approval is cleared when the token is transferred.
1682      *
1683      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1684      *
1685      * Requirements:
1686      *
1687      * - The caller must own the token or be an approved operator.
1688      * - `tokenId` must exist.
1689      *
1690      * Emits an {Approval} event.
1691      */
1692     function approve(address to, uint256 tokenId) external;
1693 
1694     /**
1695      * @dev Approve or remove `operator` as an operator for the caller.
1696      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1697      *
1698      * Requirements:
1699      *
1700      * - The `operator` cannot be the caller.
1701      *
1702      * Emits an {ApprovalForAll} event.
1703      */
1704     function setApprovalForAll(address operator, bool _approved) external;
1705 
1706     /**
1707      * @dev Returns the account approved for `tokenId` token.
1708      *
1709      * Requirements:
1710      *
1711      * - `tokenId` must exist.
1712      */
1713     function getApproved(uint256 tokenId) external view returns (address operator);
1714 
1715     /**
1716      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1717      *
1718      * See {setApprovalForAll}
1719      */
1720     function isApprovedForAll(address owner, address operator) external view returns (bool);
1721 }
1722 
1723 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1724 
1725 
1726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1727 
1728 pragma solidity ^0.8.0;
1729 
1730 
1731 /**
1732  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1733  * @dev See https://eips.ethereum.org/EIPS/eip-721
1734  */
1735 interface IERC721Metadata is IERC721 {
1736     /**
1737      * @dev Returns the token collection name.
1738      */
1739     function name() external view returns (string memory);
1740 
1741     /**
1742      * @dev Returns the token collection symbol.
1743      */
1744     function symbol() external view returns (string memory);
1745 
1746     /**
1747      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1748      */
1749     function tokenURI(uint256 tokenId) external view returns (string memory);
1750 }
1751 
1752 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1753 
1754 
1755 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1756 
1757 pragma solidity ^0.8.0;
1758 
1759 
1760 
1761 
1762 
1763 
1764 
1765 
1766 /**
1767  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1768  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1769  * {ERC721Enumerable}.
1770  */
1771 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1772     using Address for address;
1773     using Strings for uint256;
1774 
1775     // Token name
1776     string private _name;
1777 
1778     // Token symbol
1779     string private _symbol;
1780 
1781     // Mapping from token ID to owner address
1782     mapping(uint256 => address) private _owners;
1783 
1784     // Mapping owner address to token count
1785     mapping(address => uint256) private _balances;
1786 
1787     // Mapping from token ID to approved address
1788     mapping(uint256 => address) private _tokenApprovals;
1789 
1790     // Mapping from owner to operator approvals
1791     mapping(address => mapping(address => bool)) private _operatorApprovals;
1792 
1793     /**
1794      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1795      */
1796     constructor(string memory name_, string memory symbol_) {
1797         _name = name_;
1798         _symbol = symbol_;
1799     }
1800 
1801     /**
1802      * @dev See {IERC165-supportsInterface}.
1803      */
1804     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1805         return
1806             interfaceId == type(IERC721).interfaceId ||
1807             interfaceId == type(IERC721Metadata).interfaceId ||
1808             super.supportsInterface(interfaceId);
1809     }
1810 
1811     /**
1812      * @dev See {IERC721-balanceOf}.
1813      */
1814     function balanceOf(address owner) public view virtual override returns (uint256) {
1815         require(owner != address(0), "ERC721: address zero is not a valid owner");
1816         return _balances[owner];
1817     }
1818 
1819     /**
1820      * @dev See {IERC721-ownerOf}.
1821      */
1822     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1823         address owner = _owners[tokenId];
1824         require(owner != address(0), "ERC721: owner query for nonexistent token");
1825         return owner;
1826     }
1827 
1828     /**
1829      * @dev See {IERC721Metadata-name}.
1830      */
1831     function name() public view virtual override returns (string memory) {
1832         return _name;
1833     }
1834 
1835     /**
1836      * @dev See {IERC721Metadata-symbol}.
1837      */
1838     function symbol() public view virtual override returns (string memory) {
1839         return _symbol;
1840     }
1841 
1842     /**
1843      * @dev See {IERC721Metadata-tokenURI}.
1844      */
1845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1846         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1847 
1848         string memory baseURI = _baseURI();
1849         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1850     }
1851 
1852     /**
1853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1855      * by default, can be overridden in child contracts.
1856      */
1857     function _baseURI() internal view virtual returns (string memory) {
1858         return "";
1859     }
1860 
1861     /**
1862      * @dev See {IERC721-approve}.
1863      */
1864     function approve(address to, uint256 tokenId) public virtual override {
1865         address owner = ERC721.ownerOf(tokenId);
1866         require(to != owner, "ERC721: approval to current owner");
1867 
1868         require(
1869             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1870             "ERC721: approve caller is not owner nor approved for all"
1871         );
1872 
1873         _approve(to, tokenId);
1874     }
1875 
1876     /**
1877      * @dev See {IERC721-getApproved}.
1878      */
1879     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1880         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1881 
1882         return _tokenApprovals[tokenId];
1883     }
1884 
1885     /**
1886      * @dev See {IERC721-setApprovalForAll}.
1887      */
1888     function setApprovalForAll(address operator, bool approved) public virtual override {
1889         _setApprovalForAll(_msgSender(), operator, approved);
1890     }
1891 
1892     /**
1893      * @dev See {IERC721-isApprovedForAll}.
1894      */
1895     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1896         return _operatorApprovals[owner][operator];
1897     }
1898 
1899     /**
1900      * @dev See {IERC721-transferFrom}.
1901      */
1902     function transferFrom(
1903         address from,
1904         address to,
1905         uint256 tokenId
1906     ) public virtual override {
1907         //solhint-disable-next-line max-line-length
1908         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1909 
1910         _transfer(from, to, tokenId);
1911     }
1912 
1913     /**
1914      * @dev See {IERC721-safeTransferFrom}.
1915      */
1916     function safeTransferFrom(
1917         address from,
1918         address to,
1919         uint256 tokenId
1920     ) public virtual override {
1921         safeTransferFrom(from, to, tokenId, "");
1922     }
1923 
1924     /**
1925      * @dev See {IERC721-safeTransferFrom}.
1926      */
1927     function safeTransferFrom(
1928         address from,
1929         address to,
1930         uint256 tokenId,
1931         bytes memory data
1932     ) public virtual override {
1933         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1934         _safeTransfer(from, to, tokenId, data);
1935     }
1936 
1937     /**
1938      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1939      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1940      *
1941      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1942      *
1943      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1944      * implement alternative mechanisms to perform token transfer, such as signature-based.
1945      *
1946      * Requirements:
1947      *
1948      * - `from` cannot be the zero address.
1949      * - `to` cannot be the zero address.
1950      * - `tokenId` token must exist and be owned by `from`.
1951      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1952      *
1953      * Emits a {Transfer} event.
1954      */
1955     function _safeTransfer(
1956         address from,
1957         address to,
1958         uint256 tokenId,
1959         bytes memory data
1960     ) internal virtual {
1961         _transfer(from, to, tokenId);
1962         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1963     }
1964 
1965     /**
1966      * @dev Returns whether `tokenId` exists.
1967      *
1968      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1969      *
1970      * Tokens start existing when they are minted (`_mint`),
1971      * and stop existing when they are burned (`_burn`).
1972      */
1973     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1974         return _owners[tokenId] != address(0);
1975     }
1976 
1977     /**
1978      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1979      *
1980      * Requirements:
1981      *
1982      * - `tokenId` must exist.
1983      */
1984     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1985         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1986         address owner = ERC721.ownerOf(tokenId);
1987         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1988     }
1989 
1990     /**
1991      * @dev Safely mints `tokenId` and transfers it to `to`.
1992      *
1993      * Requirements:
1994      *
1995      * - `tokenId` must not exist.
1996      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1997      *
1998      * Emits a {Transfer} event.
1999      */
2000     function _safeMint(address to, uint256 tokenId) internal virtual {
2001         _safeMint(to, tokenId, "");
2002     }
2003 
2004     /**
2005      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2006      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2007      */
2008     function _safeMint(
2009         address to,
2010         uint256 tokenId,
2011         bytes memory data
2012     ) internal virtual {
2013         _mint(to, tokenId);
2014         require(
2015             _checkOnERC721Received(address(0), to, tokenId, data),
2016             "ERC721: transfer to non ERC721Receiver implementer"
2017         );
2018     }
2019 
2020     /**
2021      * @dev Mints `tokenId` and transfers it to `to`.
2022      *
2023      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2024      *
2025      * Requirements:
2026      *
2027      * - `tokenId` must not exist.
2028      * - `to` cannot be the zero address.
2029      *
2030      * Emits a {Transfer} event.
2031      */
2032     function _mint(address to, uint256 tokenId) internal virtual {
2033         require(to != address(0), "ERC721: mint to the zero address");
2034         require(!_exists(tokenId), "ERC721: token already minted");
2035 
2036         _beforeTokenTransfer(address(0), to, tokenId);
2037 
2038         _balances[to] += 1;
2039         _owners[tokenId] = to;
2040 
2041         emit Transfer(address(0), to, tokenId);
2042 
2043         _afterTokenTransfer(address(0), to, tokenId);
2044     }
2045 
2046     /**
2047      * @dev Destroys `tokenId`.
2048      * The approval is cleared when the token is burned.
2049      *
2050      * Requirements:
2051      *
2052      * - `tokenId` must exist.
2053      *
2054      * Emits a {Transfer} event.
2055      */
2056     function _burn(uint256 tokenId) internal virtual {
2057         address owner = ERC721.ownerOf(tokenId);
2058 
2059         _beforeTokenTransfer(owner, address(0), tokenId);
2060 
2061         // Clear approvals
2062         _approve(address(0), tokenId);
2063 
2064         _balances[owner] -= 1;
2065         delete _owners[tokenId];
2066 
2067         emit Transfer(owner, address(0), tokenId);
2068 
2069         _afterTokenTransfer(owner, address(0), tokenId);
2070     }
2071 
2072     /**
2073      * @dev Transfers `tokenId` from `from` to `to`.
2074      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2075      *
2076      * Requirements:
2077      *
2078      * - `to` cannot be the zero address.
2079      * - `tokenId` token must be owned by `from`.
2080      *
2081      * Emits a {Transfer} event.
2082      */
2083     function _transfer(
2084         address from,
2085         address to,
2086         uint256 tokenId
2087     ) internal virtual {
2088         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2089         require(to != address(0), "ERC721: transfer to the zero address");
2090 
2091         _beforeTokenTransfer(from, to, tokenId);
2092 
2093         // Clear approvals from the previous owner
2094         _approve(address(0), tokenId);
2095 
2096         _balances[from] -= 1;
2097         _balances[to] += 1;
2098         _owners[tokenId] = to;
2099 
2100         emit Transfer(from, to, tokenId);
2101 
2102         _afterTokenTransfer(from, to, tokenId);
2103     }
2104 
2105     /**
2106      * @dev Approve `to` to operate on `tokenId`
2107      *
2108      * Emits an {Approval} event.
2109      */
2110     function _approve(address to, uint256 tokenId) internal virtual {
2111         _tokenApprovals[tokenId] = to;
2112         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2113     }
2114 
2115     /**
2116      * @dev Approve `operator` to operate on all of `owner` tokens
2117      *
2118      * Emits an {ApprovalForAll} event.
2119      */
2120     function _setApprovalForAll(
2121         address owner,
2122         address operator,
2123         bool approved
2124     ) internal virtual {
2125         require(owner != operator, "ERC721: approve to caller");
2126         _operatorApprovals[owner][operator] = approved;
2127         emit ApprovalForAll(owner, operator, approved);
2128     }
2129 
2130     /**
2131      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2132      * The call is not executed if the target address is not a contract.
2133      *
2134      * @param from address representing the previous owner of the given token ID
2135      * @param to target address that will receive the tokens
2136      * @param tokenId uint256 ID of the token to be transferred
2137      * @param data bytes optional data to send along with the call
2138      * @return bool whether the call correctly returned the expected magic value
2139      */
2140     function _checkOnERC721Received(
2141         address from,
2142         address to,
2143         uint256 tokenId,
2144         bytes memory data
2145     ) private returns (bool) {
2146         if (to.isContract()) {
2147             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2148                 return retval == IERC721Receiver.onERC721Received.selector;
2149             } catch (bytes memory reason) {
2150                 if (reason.length == 0) {
2151                     revert("ERC721: transfer to non ERC721Receiver implementer");
2152                 } else {
2153                     assembly {
2154                         revert(add(32, reason), mload(reason))
2155                     }
2156                 }
2157             }
2158         } else {
2159             return true;
2160         }
2161     }
2162 
2163     /**
2164      * @dev Hook that is called before any token transfer. This includes minting
2165      * and burning.
2166      *
2167      * Calling conditions:
2168      *
2169      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2170      * transferred to `to`.
2171      * - When `from` is zero, `tokenId` will be minted for `to`.
2172      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2173      * - `from` and `to` are never both zero.
2174      *
2175      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2176      */
2177     function _beforeTokenTransfer(
2178         address from,
2179         address to,
2180         uint256 tokenId
2181     ) internal virtual {}
2182 
2183     /**
2184      * @dev Hook that is called after any transfer of tokens. This includes
2185      * minting and burning.
2186      *
2187      * Calling conditions:
2188      *
2189      * - when `from` and `to` are both non-zero.
2190      * - `from` and `to` are never both zero.
2191      *
2192      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2193      */
2194     function _afterTokenTransfer(
2195         address from,
2196         address to,
2197         uint256 tokenId
2198     ) internal virtual {}
2199 }
2200 
2201 
2202 pragma solidity ^0.8.0;
2203 
2204 
2205 contract Psychos is ERC721A, Ownable {
2206 
2207     using Strings for uint256;
2208     string private baseURI;
2209     uint256 public price = 0.0069 ether;
2210     uint256 public maxPerTx = 10;
2211     uint256 public maxFreePerWallet = 1;
2212     uint256 public totalFree = 7420;
2213     uint256 public maxSupply = 7420;
2214 
2215     bool public mintEnabled = false;
2216 
2217     mapping(address => uint256) private _mintedFreeAmount;
2218 
2219     constructor() ERC721A("Psychos", "PSY") {
2220         _safeMint(msg.sender, 1);
2221         setBaseURI("ipfs://bafybeidoe6cakjasvfciamqr7d6cmbrluas5gx23oczlhtw23i3tfvunzi/");
2222     }
2223 
2224     function mint(uint256 count) external payable {
2225         uint256 cost = price;
2226         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2227             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2228 
2229         if (isFree) {
2230             cost = 0;
2231         }
2232 
2233         require(msg.value >= count * cost, "Please send the exact amount.");
2234         require(totalSupply() + count < maxSupply + 1, "No more left.");
2235         require(mintEnabled, "Mint is not live yet.");
2236         require(count < maxPerTx + 1, "Max per TX reached.");
2237         require(tx.origin == msg.sender, "Contracts not allowed to mint.");
2238 
2239 
2240         if (isFree) {
2241             _mintedFreeAmount[msg.sender] += count;
2242         }
2243 
2244         _safeMint(msg.sender, count);
2245     }
2246 
2247     function _baseURI() internal view virtual override returns (string memory) {
2248         return baseURI;
2249     }
2250 
2251     function tokenURI(uint256 tokenId)
2252         public
2253         view
2254         virtual
2255         override
2256         returns (string memory)
2257     {
2258         require(
2259             _exists(tokenId),
2260             "ERC721Metadata: URI query for nonexistent token"
2261         );
2262         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2263     }
2264 
2265     function setBaseURI(string memory uri) public onlyOwner {
2266         baseURI = uri;
2267     }
2268 
2269     function setFreeAmount(uint256 amount) external onlyOwner {
2270         totalFree = amount;
2271     }
2272 
2273     function setPrice(uint256 _newPrice) external onlyOwner {
2274         price = _newPrice;
2275     }
2276 
2277     function flipSale() external onlyOwner {
2278         mintEnabled = !mintEnabled;
2279     }
2280 
2281     function withdraw() external onlyOwner {
2282         (bool success, ) = payable(msg.sender).call{
2283             value: address(this).balance
2284         }("");
2285         require(success, "Transfer failed.");
2286     }
2287 }