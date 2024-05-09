1 // File: contracts/IERC721A.sol
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
263 // File: contracts/ERC721A.sol
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
1087 // File: @openzeppelin/contracts/utils/Strings.sol
1088 
1089 
1090 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1091 
1092 pragma solidity ^0.8.0;
1093 
1094 /**
1095  * @dev String operations.
1096  */
1097 library Strings {
1098     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1099 
1100     /**
1101      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1102      */
1103     function toString(uint256 value) internal pure returns (string memory) {
1104         // Inspired by OraclizeAPI's implementation - MIT licence
1105         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1106 
1107         if (value == 0) {
1108             return "0";
1109         }
1110         uint256 temp = value;
1111         uint256 digits;
1112         while (temp != 0) {
1113             digits++;
1114             temp /= 10;
1115         }
1116         bytes memory buffer = new bytes(digits);
1117         while (value != 0) {
1118             digits -= 1;
1119             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1120             value /= 10;
1121         }
1122         return string(buffer);
1123     }
1124 
1125     /**
1126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1127      */
1128     function toHexString(uint256 value) internal pure returns (string memory) {
1129         if (value == 0) {
1130             return "0x00";
1131         }
1132         uint256 temp = value;
1133         uint256 length = 0;
1134         while (temp != 0) {
1135             length++;
1136             temp >>= 8;
1137         }
1138         return toHexString(value, length);
1139     }
1140 
1141     /**
1142      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1143      */
1144     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1145         bytes memory buffer = new bytes(2 * length + 2);
1146         buffer[0] = "0";
1147         buffer[1] = "x";
1148         for (uint256 i = 2 * length + 1; i > 1; --i) {
1149             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1150             value >>= 4;
1151         }
1152         require(value == 0, "Strings: hex length insufficient");
1153         return string(buffer);
1154     }
1155 }
1156 
1157 // File: @openzeppelin/contracts/utils/Context.sol
1158 
1159 
1160 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1161 
1162 pragma solidity ^0.8.0;
1163 
1164 /**
1165  * @dev Provides information about the current execution context, including the
1166  * sender of the transaction and its data. While these are generally available
1167  * via msg.sender and msg.data, they should not be accessed in such a direct
1168  * manner, since when dealing with meta-transactions the account sending and
1169  * paying for execution may not be the actual sender (as far as an application
1170  * is concerned).
1171  *
1172  * This contract is only required for intermediate, library-like contracts.
1173  */
1174 abstract contract Context {
1175     function _msgSender() internal view virtual returns (address) {
1176         return msg.sender;
1177     }
1178 
1179     function _msgData() internal view virtual returns (bytes calldata) {
1180         return msg.data;
1181     }
1182 }
1183 
1184 // File: @openzeppelin/contracts/access/Ownable.sol
1185 
1186 
1187 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1188 
1189 pragma solidity ^0.8.0;
1190 
1191 
1192 /**
1193  * @dev Contract module which provides a basic access control mechanism, where
1194  * there is an account (an owner) that can be granted exclusive access to
1195  * specific functions.
1196  *
1197  * By default, the owner account will be the one that deploys the contract. This
1198  * can later be changed with {transferOwnership}.
1199  *
1200  * This module is used through inheritance. It will make available the modifier
1201  * `onlyOwner`, which can be applied to your functions to restrict their use to
1202  * the owner.
1203  */
1204 abstract contract Ownable is Context {
1205     address private _owner;
1206 
1207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1208 
1209     /**
1210      * @dev Initializes the contract setting the deployer as the initial owner.
1211      */
1212     constructor() {
1213         _transferOwnership(_msgSender());
1214     }
1215 
1216     /**
1217      * @dev Returns the address of the current owner.
1218      */
1219     function owner() public view virtual returns (address) {
1220         return _owner;
1221     }
1222 
1223     /**
1224      * @dev Throws if called by any account other than the owner.
1225      */
1226     modifier onlyOwner() {
1227         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1228         _;
1229     }
1230 
1231     /**
1232      * @dev Leaves the contract without owner. It will not be possible to call
1233      * `onlyOwner` functions anymore. Can only be called by the current owner.
1234      *
1235      * NOTE: Renouncing ownership will leave the contract without an owner,
1236      * thereby removing any functionality that is only available to the owner.
1237      */
1238     function renounceOwnership() public virtual onlyOwner {
1239         _transferOwnership(address(0));
1240     }
1241 
1242     /**
1243      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1244      * Can only be called by the current owner.
1245      */
1246     function transferOwnership(address newOwner) public virtual onlyOwner {
1247         require(newOwner != address(0), "Ownable: new owner is the zero address");
1248         _transferOwnership(newOwner);
1249     }
1250 
1251     /**
1252      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1253      * Internal function without access restriction.
1254      */
1255     function _transferOwnership(address newOwner) internal virtual {
1256         address oldOwner = _owner;
1257         _owner = newOwner;
1258         emit OwnershipTransferred(oldOwner, newOwner);
1259     }
1260 }
1261 
1262 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1263 
1264 
1265 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1266 
1267 pragma solidity ^0.8.0;
1268 
1269 /**
1270  * @dev These functions deal with verification of Merkle Trees proofs.
1271  *
1272  * The proofs can be generated using the JavaScript library
1273  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1274  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1275  *
1276  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1277  *
1278  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1279  * hashing, or use a hash function other than keccak256 for hashing leaves.
1280  * This is because the concatenation of a sorted pair of internal nodes in
1281  * the merkle tree could be reinterpreted as a leaf value.
1282  */
1283 library MerkleProof {
1284     /**
1285      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1286      * defined by `root`. For this, a `proof` must be provided, containing
1287      * sibling hashes on the branch from the leaf to the root of the tree. Each
1288      * pair of leaves and each pair of pre-images are assumed to be sorted.
1289      */
1290     function verify(
1291         bytes32[] memory proof,
1292         bytes32 root,
1293         bytes32 leaf
1294     ) internal pure returns (bool) {
1295         return processProof(proof, leaf) == root;
1296     }
1297 
1298     /**
1299      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1300      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1301      * hash matches the root of the tree. When processing the proof, the pairs
1302      * of leafs & pre-images are assumed to be sorted.
1303      *
1304      * _Available since v4.4._
1305      */
1306     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1307         bytes32 computedHash = leaf;
1308         for (uint256 i = 0; i < proof.length; i++) {
1309             bytes32 proofElement = proof[i];
1310             if (computedHash <= proofElement) {
1311                 // Hash(current computed hash + current element of the proof)
1312                 computedHash = _efficientHash(computedHash, proofElement);
1313             } else {
1314                 // Hash(current element of the proof + current computed hash)
1315                 computedHash = _efficientHash(proofElement, computedHash);
1316             }
1317         }
1318         return computedHash;
1319     }
1320 
1321     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1322         assembly {
1323             mstore(0x00, a)
1324             mstore(0x20, b)
1325             value := keccak256(0x00, 0x40)
1326         }
1327     }
1328 }
1329 
1330 // File: contracts/Enfants.sol
1331 
1332 
1333 pragma solidity ^0.8.13;
1334 
1335 
1336 
1337 
1338 
1339 contract EnfantsTerribles is ERC721A, Ownable {
1340 
1341     using Strings for uint;
1342 
1343     enum Step {
1344         StandBy,
1345         WhitelistSale,
1346         PublicSale,
1347         SoldOut,
1348         Reveal
1349     }
1350 
1351     string public baseURI;
1352     string public notRevealedURI;
1353 
1354     Step public sellingStep;
1355 
1356     uint private constant MAX_SUPPLY = 7777;
1357     uint private constant MAX_TEAM = 777;
1358     uint private constant MAX_TX = 3;
1359 
1360     bool private isRevealed = false;
1361 
1362     uint public price = 0.0084 ether;
1363 
1364     bytes32 public merkleRoot;
1365 
1366     mapping(address => uint) public FreeMintCount;
1367 
1368     constructor(string memory _baseURI, bytes32 _merkleRoot) ERC721A("Enfants", "Enfants Terribles")
1369     {
1370         baseURI = _baseURI;
1371         merkleRoot = _merkleRoot;
1372     }
1373 
1374     modifier isNotContract() {
1375         require(tx.origin == msg.sender, "Reentrancy Guard is watching");
1376         _;
1377     }
1378 
1379     function teamMint(address _to, uint _quantity) external payable onlyOwner {
1380         require(totalSupply() + _quantity <= MAX_TEAM, "NFT can't be minted anymore");
1381         _safeMint(_to,  _quantity);
1382     }
1383 
1384     function whitelistMint(address _account, uint _quantity, bytes32[] calldata _proof) external payable isNotContract {
1385         uint payCount = _quantity;
1386         require(sellingStep == Step.WhitelistSale, "Whitelist Mint is not activated");
1387         require(isWhiteListed(msg.sender, _proof), "Not whitelisted");
1388         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be minted anymore");
1389         require(_quantity <= MAX_TX, "Exceeded Max per TX");
1390         if(FreeMintCount[msg.sender] < 1){
1391 		    if (_quantity >1) { payCount = _quantity - 1; }
1392             else{ payCount = 0; }
1393 		FreeMintCount[msg.sender] = 1;
1394 		}
1395 		require(msg.value >= payCount * price, "Incorrect amount of ETH");
1396         _safeMint(_account, _quantity);
1397     }
1398 
1399     function publicMint(address _account, uint _quantity) external payable isNotContract {
1400         uint payCount = _quantity;
1401         require(sellingStep == Step.PublicSale, "Only those Whitelisted can mint now");
1402         require(totalSupply() + _quantity <= MAX_SUPPLY, "NFT can't be minted anymore");
1403         require(_quantity <= MAX_TX, "Exceeded Max per TX");
1404         if(FreeMintCount[msg.sender] < 1){
1405 		    if (_quantity >1) { payCount = _quantity - 1; }
1406             else{ payCount = 0; }
1407 		FreeMintCount[msg.sender] = 1;
1408 		}
1409 		require(msg.value >= payCount * price, "Incorrect amount of ETH");
1410         _safeMint(_account, _quantity);
1411     }
1412 
1413     function setBaseUri(string memory _newBaseURI) external onlyOwner {
1414         baseURI = _newBaseURI;
1415     }
1416 
1417     function setStep(uint _step) external onlyOwner {
1418         sellingStep = Step(_step);
1419         sellingStep == Step.Reveal;
1420     }
1421 
1422     function revealCollection() external onlyOwner {
1423         isRevealed = true;
1424     }
1425 
1426     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1427         require(_exists(_tokenId), "URI query for nonexistent token");
1428         if(isRevealed == true) {
1429             return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
1430         }
1431         else {
1432             return string(abi.encodePacked(baseURI, notRevealedURI));
1433         }
1434     }
1435 
1436    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1437         merkleRoot = _merkleRoot;
1438     }
1439 
1440     function isWhiteListed(address _account, bytes32[] calldata _proof) internal view returns(bool) {
1441         return _verify(leaf(_account), _proof);
1442     }
1443 
1444     function leaf(address _account) internal pure returns(bytes32) {
1445         return keccak256(abi.encodePacked(_account));
1446     }
1447 
1448     function _verify(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
1449         return MerkleProof.verify(_proof, merkleRoot, _leaf);
1450     }
1451     
1452     function withdraw(uint amount) public onlyOwner {
1453         payable(msg.sender).transfer(amount);
1454     }
1455 }