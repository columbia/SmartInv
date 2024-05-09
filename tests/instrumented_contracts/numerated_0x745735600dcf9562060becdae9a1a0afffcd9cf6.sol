1 // File: IERC721A.sol
2 
3 
4 // ERC721A Contracts v4.0.0
5 // Creator: Chiru Labs
6 
7 pragma solidity ^0.8.4;
8 
9 /**
10  * @dev Interface of an ERC721A compliant contract.
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
29      * The caller cannot approve to the current owner.
30      */
31     error ApprovalToCurrentOwner();
32 
33     /**
34      * Cannot query the balance for the zero address.
35      */
36     error BalanceQueryForZeroAddress();
37 
38     /**
39      * Cannot mint to the zero address.
40      */
41     error MintToZeroAddress();
42 
43     /**
44      * The quantity of tokens minted must be more than zero.
45      */
46     error MintZeroQuantity();
47 
48     /**
49      * The token does not exist.
50      */
51     error OwnerQueryForNonexistentToken();
52 
53     /**
54      * The caller must own the token or be an approved operator.
55      */
56     error TransferCallerNotOwnerNorApproved();
57 
58     /**
59      * The token must be owned by `from`.
60      */
61     error TransferFromIncorrectOwner();
62 
63     /**
64      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
65      */
66     error TransferToNonERC721ReceiverImplementer();
67 
68     /**
69      * Cannot transfer to the zero address.
70      */
71     error TransferToZeroAddress();
72 
73     /**
74      * The token does not exist.
75      */
76     error URIQueryForNonexistentToken();
77 
78     struct TokenOwnership {
79         // The address of the owner.
80         address addr;
81         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
82         uint64 startTimestamp;
83         // Whether the token has been burned.
84         bool burned;
85     }
86 
87     /**
88      * @dev Returns the total amount of tokens stored by the contract.
89      *
90      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
91      */
92     function totalSupply() external view returns (uint256);
93 
94     // ==============================
95     //            IERC165
96     // ==============================
97 
98     /**
99      * @dev Returns true if this contract implements the interface defined by
100      * `interfaceId`. See the corresponding
101      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
102      * to learn more about how these ids are created.
103      *
104      * This function call must use less than 30 000 gas.
105      */
106     function supportsInterface(bytes4 interfaceId) external view returns (bool);
107 
108     // ==============================
109     //            IERC721
110     // ==============================
111 
112     /**
113      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
119      */
120     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
124      */
125     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
126 
127     /**
128      * @dev Returns the number of tokens in ``owner``'s account.
129      */
130     function balanceOf(address owner) external view returns (uint256 balance);
131 
132     /**
133      * @dev Returns the owner of the `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function ownerOf(uint256 tokenId) external view returns (address owner);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`.
143      *
144      * Requirements:
145      *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148      * - `tokenId` token must exist and be owned by `from`.
149      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151      *
152      * Emits a {Transfer} event.
153      */
154     function safeTransferFrom(
155         address from,
156         address to,
157         uint256 tokenId,
158         bytes calldata data
159     ) external;
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
163      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external;
180 
181     /**
182      * @dev Transfers `tokenId` token from `from` to `to`.
183      *
184      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external;
200 
201     /**
202      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
203      * The approval is cleared when the token is transferred.
204      *
205      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
206      *
207      * Requirements:
208      *
209      * - The caller must own the token or be an approved operator.
210      * - `tokenId` must exist.
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address to, uint256 tokenId) external;
215 
216     /**
217      * @dev Approve or remove `operator` as an operator for the caller.
218      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
219      *
220      * Requirements:
221      *
222      * - The `operator` cannot be the caller.
223      *
224      * Emits an {ApprovalForAll} event.
225      */
226     function setApprovalForAll(address operator, bool _approved) external;
227 
228     /**
229      * @dev Returns the account approved for `tokenId` token.
230      *
231      * Requirements:
232      *
233      * - `tokenId` must exist.
234      */
235     function getApproved(uint256 tokenId) external view returns (address operator);
236 
237     /**
238      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
239      *
240      * See {setApprovalForAll}
241      */
242     function isApprovedForAll(address owner, address operator) external view returns (bool);
243 
244     // ==============================
245     //        IERC721Metadata
246     // ==============================
247 
248     /**
249      * @dev Returns the token collection name.
250      */
251     function name() external view returns (string memory);
252 
253     /**
254      * @dev Returns the token collection symbol.
255      */
256     function symbol() external view returns (string memory);
257 
258     /**
259      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
260      */
261     function tokenURI(uint256 tokenId) external view returns (string memory);
262 }
263 // File: ERC721A.sol
264 
265 
266 // ERC721A Contracts v4.0.0
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
429         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
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
706         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
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
766         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
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
823         address approvedAddress = _tokenApprovals[tokenId];
824 
825         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
826             isApprovedForAll(from, _msgSenderERC721A()) ||
827             approvedAddress == _msgSenderERC721A());
828 
829         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
830         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
831 
832         _beforeTokenTransfers(from, to, tokenId, 1);
833 
834         // Clear approvals from the previous owner.
835         if (_addressToUint256(approvedAddress) != 0) {
836             delete _tokenApprovals[tokenId];
837         }
838 
839         // Underflow of the sender's balance is impossible because we check for
840         // ownership above and the recipient's balance can't realistically overflow.
841         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
842         unchecked {
843             // We can directly increment and decrement the balances.
844             --_packedAddressData[from]; // Updates: `balance -= 1`.
845             ++_packedAddressData[to]; // Updates: `balance += 1`.
846 
847             // Updates:
848             // - `address` to the next owner.
849             // - `startTimestamp` to the timestamp of transfering.
850             // - `burned` to `false`.
851             // - `nextInitialized` to `true`.
852             _packedOwnerships[tokenId] =
853                 _addressToUint256(to) |
854                 (block.timestamp << BITPOS_START_TIMESTAMP) |
855                 BITMASK_NEXT_INITIALIZED;
856 
857             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
858             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
859                 uint256 nextTokenId = tokenId + 1;
860                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
861                 if (_packedOwnerships[nextTokenId] == 0) {
862                     // If the next slot is within bounds.
863                     if (nextTokenId != _currentIndex) {
864                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
865                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
866                     }
867                 }
868             }
869         }
870 
871         emit Transfer(from, to, tokenId);
872         _afterTokenTransfers(from, to, tokenId, 1);
873     }
874 
875     /**
876      * @dev Equivalent to `_burn(tokenId, false)`.
877      */
878     function _burn(uint256 tokenId) internal virtual {
879         _burn(tokenId, false);
880     }
881 
882     /**
883      * @dev Destroys `tokenId`.
884      * The approval is cleared when the token is burned.
885      *
886      * Requirements:
887      *
888      * - `tokenId` must exist.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
893         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
894 
895         address from = address(uint160(prevOwnershipPacked));
896         address approvedAddress = _tokenApprovals[tokenId];
897 
898         if (approvalCheck) {
899             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
900                 isApprovedForAll(from, _msgSenderERC721A()) ||
901                 approvedAddress == _msgSenderERC721A());
902 
903             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
904         }
905 
906         _beforeTokenTransfers(from, address(0), tokenId, 1);
907 
908         // Clear approvals from the previous owner.
909         if (_addressToUint256(approvedAddress) != 0) {
910             delete _tokenApprovals[tokenId];
911         }
912 
913         // Underflow of the sender's balance is impossible because we check for
914         // ownership above and the recipient's balance can't realistically overflow.
915         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
916         unchecked {
917             // Updates:
918             // - `balance -= 1`.
919             // - `numberBurned += 1`.
920             //
921             // We can directly decrement the balance, and increment the number burned.
922             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
923             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
924 
925             // Updates:
926             // - `address` to the last owner.
927             // - `startTimestamp` to the timestamp of burning.
928             // - `burned` to `true`.
929             // - `nextInitialized` to `true`.
930             _packedOwnerships[tokenId] =
931                 _addressToUint256(from) |
932                 (block.timestamp << BITPOS_START_TIMESTAMP) |
933                 BITMASK_BURNED |
934                 BITMASK_NEXT_INITIALIZED;
935 
936             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
937             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
938                 uint256 nextTokenId = tokenId + 1;
939                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
940                 if (_packedOwnerships[nextTokenId] == 0) {
941                     // If the next slot is within bounds.
942                     if (nextTokenId != _currentIndex) {
943                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
944                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
945                     }
946                 }
947             }
948         }
949 
950         emit Transfer(from, address(0), tokenId);
951         _afterTokenTransfers(from, address(0), tokenId, 1);
952 
953         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
954         unchecked {
955             _burnCounter++;
956         }
957     }
958 
959     /**
960      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
961      *
962      * @param from address representing the previous owner of the given token ID
963      * @param to target address that will receive the tokens
964      * @param tokenId uint256 ID of the token to be transferred
965      * @param _data bytes optional data to send along with the call
966      * @return bool whether the call correctly returned the expected magic value
967      */
968     function _checkContractOnERC721Received(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) private returns (bool) {
974         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
975             bytes4 retval
976         ) {
977             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
978         } catch (bytes memory reason) {
979             if (reason.length == 0) {
980                 revert TransferToNonERC721ReceiverImplementer();
981             } else {
982                 assembly {
983                     revert(add(32, reason), mload(reason))
984                 }
985             }
986         }
987     }
988 
989     /**
990      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
991      * And also called before burning one token.
992      *
993      * startTokenId - the first token id to be transferred
994      * quantity - the amount to be transferred
995      *
996      * Calling conditions:
997      *
998      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
999      * transferred to `to`.
1000      * - When `from` is zero, `tokenId` will be minted for `to`.
1001      * - When `to` is zero, `tokenId` will be burned by `from`.
1002      * - `from` and `to` are never both zero.
1003      */
1004     function _beforeTokenTransfers(
1005         address from,
1006         address to,
1007         uint256 startTokenId,
1008         uint256 quantity
1009     ) internal virtual {}
1010 
1011     /**
1012      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1013      * minting.
1014      * And also called after one token has been burned.
1015      *
1016      * startTokenId - the first token id to be transferred
1017      * quantity - the amount to be transferred
1018      *
1019      * Calling conditions:
1020      *
1021      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1022      * transferred to `to`.
1023      * - When `from` is zero, `tokenId` has been minted for `to`.
1024      * - When `to` is zero, `tokenId` has been burned by `from`.
1025      * - `from` and `to` are never both zero.
1026      */
1027     function _afterTokenTransfers(
1028         address from,
1029         address to,
1030         uint256 startTokenId,
1031         uint256 quantity
1032     ) internal virtual {}
1033 
1034     /**
1035      * @dev Returns the message sender (defaults to `msg.sender`).
1036      *
1037      * If you are writing GSN compatible contracts, you need to override this function.
1038      */
1039     function _msgSenderERC721A() internal view virtual returns (address) {
1040         return msg.sender;
1041     }
1042 
1043     /**
1044      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1045      */
1046     function _toString(uint256 value) internal pure returns (string memory ptr) {
1047         assembly {
1048             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1049             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1050             // We will need 1 32-byte word to store the length,
1051             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1052             ptr := add(mload(0x40), 128)
1053             // Update the free memory pointer to allocate.
1054             mstore(0x40, ptr)
1055 
1056             // Cache the end of the memory to calculate the length later.
1057             let end := ptr
1058 
1059             // We write the string from the rightmost digit to the leftmost digit.
1060             // The following is essentially a do-while loop that also handles the zero case.
1061             // Costs a bit more than early returning for the zero case,
1062             // but cheaper in terms of deployment and overall runtime costs.
1063             for {
1064                 // Initialize and perform the first pass without check.
1065                 let temp := value
1066                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1067                 ptr := sub(ptr, 1)
1068                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1069                 mstore8(ptr, add(48, mod(temp, 10)))
1070                 temp := div(temp, 10)
1071             } temp {
1072                 // Keep dividing `temp` until zero.
1073                 temp := div(temp, 10)
1074             } { // Body of the for loop.
1075                 ptr := sub(ptr, 1)
1076                 mstore8(ptr, add(48, mod(temp, 10)))
1077             }
1078 
1079             let length := sub(end, ptr)
1080             // Move the pointer 32 bytes leftwards to make room for the length.
1081             ptr := sub(ptr, 32)
1082             // Store the length.
1083             mstore(ptr, length)
1084         }
1085     }
1086 }
1087 // File: @openzeppelin/contracts@4.5.0/utils/Context.sol
1088 
1089 
1090 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1091 
1092 pragma solidity ^0.8.0;
1093 
1094 /**
1095  * @dev Provides information about the current execution context, including the
1096  * sender of the transaction and its data. While these are generally available
1097  * via msg.sender and msg.data, they should not be accessed in such a direct
1098  * manner, since when dealing with meta-transactions the account sending and
1099  * paying for execution may not be the actual sender (as far as an application
1100  * is concerned).
1101  *
1102  * This contract is only required for intermediate, library-like contracts.
1103  */
1104 abstract contract Context {
1105     function _msgSender() internal view virtual returns (address) {
1106         return msg.sender;
1107     }
1108 
1109     function _msgData() internal view virtual returns (bytes calldata) {
1110         return msg.data;
1111     }
1112 }
1113 
1114 // File: @openzeppelin/contracts@4.5.0/access/Ownable.sol
1115 
1116 
1117 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1118 
1119 pragma solidity ^0.8.0;
1120 
1121 
1122 /**
1123  * @dev Contract module which provides a basic access control mechanism, where
1124  * there is an account (an owner) that can be granted exclusive access to
1125  * specific functions.
1126  *
1127  * By default, the owner account will be the one that deploys the contract. This
1128  * can later be changed with {transferOwnership}.
1129  *
1130  * This module is used through inheritance. It will make available the modifier
1131  * `onlyOwner`, which can be applied to your functions to restrict their use to
1132  * the owner.
1133  */
1134 abstract contract Ownable is Context {
1135     address private _owner;
1136 
1137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1138 
1139     /**
1140      * @dev Initializes the contract setting the deployer as the initial owner.
1141      */
1142     constructor() {
1143         _transferOwnership(_msgSender());
1144     }
1145 
1146     /**
1147      * @dev Returns the address of the current owner.
1148      */
1149     function owner() public view virtual returns (address) {
1150         return _owner;
1151     }
1152 
1153     /**
1154      * @dev Throws if called by any account other than the owner.
1155      */
1156     modifier onlyOwner() {
1157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1158         _;
1159     }
1160 
1161     /**
1162      * @dev Leaves the contract without owner. It will not be possible to call
1163      * `onlyOwner` functions anymore. Can only be called by the current owner.
1164      *
1165      * NOTE: Renouncing ownership will leave the contract without an owner,
1166      * thereby removing any functionality that is only available to the owner.
1167      */
1168     function renounceOwnership() public virtual onlyOwner {
1169         _transferOwnership(address(0));
1170     }
1171 
1172     /**
1173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1174      * Can only be called by the current owner.
1175      */
1176     function transferOwnership(address newOwner) public virtual onlyOwner {
1177         require(newOwner != address(0), "Ownable: new owner is the zero address");
1178         _transferOwnership(newOwner);
1179     }
1180 
1181     /**
1182      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1183      * Internal function without access restriction.
1184      */
1185     function _transferOwnership(address newOwner) internal virtual {
1186         address oldOwner = _owner;
1187         _owner = newOwner;
1188         emit OwnershipTransferred(oldOwner, newOwner);
1189     }
1190 }
1191 
1192 // File: KikoBakes.sol
1193 
1194 /*
1195 
1196 
1197 ██╗░░██╗██╗██╗░░██╗░█████╗░  ██████╗░░█████╗░██╗░░██╗███████╗░██████╗░█████╗░██╗
1198 ██║░██╔╝██║██║░██╔╝██╔══██╗  ██╔══██╗██╔══██╗██║░██╔╝██╔════╝██╔════╝██╔══██╗██║
1199 █████═╝░██║█████═╝░██║░░██║  ██████╦╝███████║█████═╝░█████╗░░╚█████╗░╚═╝███╔╝██║
1200 ██╔═██╗░██║██╔═██╗░██║░░██║  ██╔══██╗██╔══██║██╔═██╗░██╔══╝░░░╚═══██╗░░░╚══╝░╚═╝
1201 ██║░╚██╗██║██║░╚██╗╚█████╔╝  ██████╦╝██║░░██║██║░╚██╗███████╗██████╔╝░░░██╗░░██╗
1202 ╚═╝░░╚═╝╚═╝╚═╝░░╚═╝░╚════╝░  ╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝╚═════╝░░░░╚═╝░░╚═╝
1203 
1204 no. no i don't. sorry if it tastes like cardboard!
1205 
1206 */
1207 
1208 
1209 pragma solidity ^0.8.11;
1210 
1211 
1212 
1213 contract KikoBakes is ERC721A, Ownable {
1214     // metadata
1215     string public baseURI = "https://bearmarketbakery.s3.us-east-2.amazonaws.com/fortunecrackers/md/";
1216     bool public metadataFrozen = false;
1217 
1218     // constants and values
1219     uint256 public constant MAX_SUPPLY_HARDCAP = 100000;
1220     uint256 public perWalletLimit = 2;
1221     uint256 public maxSupplySoftcap = 10000;
1222     uint256 public mintPrice = 0;
1223 
1224     // sale settings
1225     bool public mintPaused = true;
1226 
1227     /**
1228      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection
1229      */
1230     constructor()
1231         ERC721A("Kiko Bakes", "YUM")
1232     {
1233     }
1234 
1235     /**
1236      * ------------ CONFIG ------------
1237      */
1238 
1239     /**
1240      * @dev Gets base metadata URI
1241      */
1242     function _baseURI() internal view override returns (string memory) {
1243         return baseURI;
1244     }
1245 
1246     /**
1247      * @dev Sets base metadata URI, callable by owner
1248      */
1249     function setBaseUri(string memory _uri) external onlyOwner {
1250         require(!metadataFrozen);
1251         baseURI = _uri;
1252     }
1253 
1254     /**
1255      * @dev Sets mint price, callable by owner
1256      */
1257     function setMintPrice(uint256 newPriceInWei) external onlyOwner {
1258         mintPrice = newPriceInWei;
1259     }
1260 
1261     /**
1262      * @dev Sets per wallet limit, callable by owner
1263      */
1264     function setPerWalletLimit(uint256 newLimit) external onlyOwner {
1265         perWalletLimit = newLimit;
1266     }
1267 
1268     /**
1269      * @dev Adds to supply softcap, callable by owner
1270      */
1271     function addSupply(uint256 supplyToAdd) external onlyOwner {
1272         require(supplyToAdd > 0);
1273         require(maxSupplySoftcap + supplyToAdd <= MAX_SUPPLY_HARDCAP);
1274         maxSupplySoftcap += supplyToAdd;
1275     }
1276 
1277 
1278     /**
1279      * @dev Freezes metadata
1280      */
1281     function freezeMetadata() external onlyOwner {
1282         require(!metadataFrozen);
1283         metadataFrozen = true;
1284     }
1285 
1286     /**
1287      * @dev Pause/unpause sale or presale
1288      */
1289     function togglePauseMinting() external onlyOwner {
1290         mintPaused = !mintPaused;
1291     }
1292 
1293     /**
1294      * ------------ MINTING ------------
1295      */
1296 
1297     /**
1298      * @dev Owner minting
1299      */
1300     function airdropOwner(address[] calldata addrs, uint256[] calldata counts) external onlyOwner {
1301         for (uint256 i=0; i<addrs.length; i++) {
1302             _mint(addrs[i], counts[i]);
1303             _setAux(addrs[i], uint64(_getAux(addrs[i]) + counts[i]));
1304         }
1305         require(totalSupply() <= maxSupplySoftcap, "Supply exceeded");
1306     }
1307 
1308     /**
1309      * @dev Public minting during public sale
1310      */
1311     function mint(uint256 count) public payable {
1312         require(count > 0, "Count can't be 0");
1313         require(count + _numberMinted(msg.sender) - _getAux(msg.sender) <= perWalletLimit, "Limit exceeded");
1314         require(!mintPaused, "Minting is currently paused");
1315         require(msg.value == count * mintPrice, "Wrong ETH value");
1316 
1317         require(totalSupply() + count <= maxSupplySoftcap, "Supply exceeded");
1318 
1319         _mint(msg.sender, count);
1320     }
1321 
1322     /**
1323      * @dev Returns number of NFTs minted by addr
1324      */
1325     function numberMinted(address addr) public view returns (uint256) {
1326         return _numberMinted(addr);
1327     }
1328 }