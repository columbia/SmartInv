1 // File: IERC721A.sol
2 
3 
4 // ERC721A Contracts v3.3.0
5 // Creator: Chiru Labs
6 
7 pragma solidity ^0.8.7;
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
266 // ERC721A Contracts v3.3.0
267 // Creator: Chiru Labs
268 
269 pragma solidity ^0.8.7;
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
363         _currentIndex = 1;
364     }
365 
366     /**
367      * @dev Returns the starting token ID. 
368      * To change the starting token ID, please override this function.
369      */
370     function _startTokenId() internal view virtual returns (uint256) {
371         return 1;
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
1080 // File: @openzeppelin/contracts/utils/Strings.sol
1081 
1082 
1083 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1084 
1085 pragma solidity ^0.8.0;
1086 
1087 /**
1088  * @dev String operations.
1089  */
1090 library Strings {
1091     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1092 
1093     /**
1094      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1095      */
1096     function toString(uint256 value) internal pure returns (string memory) {
1097         // Inspired by OraclizeAPI's implementation - MIT licence
1098         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1099 
1100         if (value == 0) {
1101             return "0";
1102         }
1103         uint256 temp = value;
1104         uint256 digits;
1105         while (temp != 0) {
1106             digits++;
1107             temp /= 10;
1108         }
1109         bytes memory buffer = new bytes(digits);
1110         while (value != 0) {
1111             digits -= 1;
1112             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1113             value /= 10;
1114         }
1115         return string(buffer);
1116     }
1117 
1118     /**
1119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1120      */
1121     function toHexString(uint256 value) internal pure returns (string memory) {
1122         if (value == 0) {
1123             return "0x00";
1124         }
1125         uint256 temp = value;
1126         uint256 length = 0;
1127         while (temp != 0) {
1128             length++;
1129             temp >>= 8;
1130         }
1131         return toHexString(value, length);
1132     }
1133 
1134     /**
1135      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1136      */
1137     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1138         bytes memory buffer = new bytes(2 * length + 2);
1139         buffer[0] = "0";
1140         buffer[1] = "x";
1141         for (uint256 i = 2 * length + 1; i > 1; --i) {
1142             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1143             value >>= 4;
1144         }
1145         require(value == 0, "Strings: hex length insufficient");
1146         return string(buffer);
1147     }
1148 }
1149 
1150 // File: @openzeppelin/contracts/utils/Address.sol
1151 
1152 
1153 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1154 
1155 pragma solidity ^0.8.1;
1156 
1157 /**
1158  * @dev Collection of functions related to the address type
1159  */
1160 library Address {
1161     /**
1162      * @dev Returns true if `account` is a contract.
1163      *
1164      * [IMPORTANT]
1165      * ====
1166      * It is unsafe to assume that an address for which this function returns
1167      * false is an externally-owned account (EOA) and not a contract.
1168      *
1169      * Among others, `isContract` will return false for the following
1170      * types of addresses:
1171      *
1172      *  - an externally-owned account
1173      *  - a contract in construction
1174      *  - an address where a contract will be created
1175      *  - an address where a contract lived, but was destroyed
1176      * ====
1177      *
1178      * [IMPORTANT]
1179      * ====
1180      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1181      *
1182      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1183      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1184      * constructor.
1185      * ====
1186      */
1187     function isContract(address account) internal view returns (bool) {
1188         // This method relies on extcodesize/address.code.length, which returns 0
1189         // for contracts in construction, since the code is only stored at the end
1190         // of the constructor execution.
1191 
1192         return account.code.length > 0;
1193     }
1194 
1195     /**
1196      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1197      * `recipient`, forwarding all available gas and reverting on errors.
1198      *
1199      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1200      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1201      * imposed by `transfer`, making them unable to receive funds via
1202      * `transfer`. {sendValue} removes this limitation.
1203      *
1204      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1205      *
1206      * IMPORTANT: because control is transferred to `recipient`, care must be
1207      * taken to not create reentrancy vulnerabilities. Consider using
1208      * {ReentrancyGuard} or the
1209      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1210      */
1211     function sendValue(address payable recipient, uint256 amount) internal {
1212         require(address(this).balance >= amount, "Address: insufficient balance");
1213 
1214         (bool success, ) = recipient.call{value: amount}("");
1215         require(success, "Address: unable to send value, recipient may have reverted");
1216     }
1217 
1218     /**
1219      * @dev Performs a Solidity function call using a low level `call`. A
1220      * plain `call` is an unsafe replacement for a function call: use this
1221      * function instead.
1222      *
1223      * If `target` reverts with a revert reason, it is bubbled up by this
1224      * function (like regular Solidity function calls).
1225      *
1226      * Returns the raw returned data. To convert to the expected return value,
1227      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1228      *
1229      * Requirements:
1230      *
1231      * - `target` must be a contract.
1232      * - calling `target` with `data` must not revert.
1233      *
1234      * _Available since v3.1._
1235      */
1236     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1237         return functionCall(target, data, "Address: low-level call failed");
1238     }
1239 
1240     /**
1241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1242      * `errorMessage` as a fallback revert reason when `target` reverts.
1243      *
1244      * _Available since v3.1._
1245      */
1246     function functionCall(
1247         address target,
1248         bytes memory data,
1249         string memory errorMessage
1250     ) internal returns (bytes memory) {
1251         return functionCallWithValue(target, data, 0, errorMessage);
1252     }
1253 
1254     /**
1255      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1256      * but also transferring `value` wei to `target`.
1257      *
1258      * Requirements:
1259      *
1260      * - the calling contract must have an ETH balance of at least `value`.
1261      * - the called Solidity function must be `payable`.
1262      *
1263      * _Available since v3.1._
1264      */
1265     function functionCallWithValue(
1266         address target,
1267         bytes memory data,
1268         uint256 value
1269     ) internal returns (bytes memory) {
1270         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1271     }
1272 
1273     /**
1274      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1275      * with `errorMessage` as a fallback revert reason when `target` reverts.
1276      *
1277      * _Available since v3.1._
1278      */
1279     function functionCallWithValue(
1280         address target,
1281         bytes memory data,
1282         uint256 value,
1283         string memory errorMessage
1284     ) internal returns (bytes memory) {
1285         require(address(this).balance >= value, "Address: insufficient balance for call");
1286         require(isContract(target), "Address: call to non-contract");
1287 
1288         (bool success, bytes memory returndata) = target.call{value: value}(data);
1289         return verifyCallResult(success, returndata, errorMessage);
1290     }
1291 
1292     /**
1293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1294      * but performing a static call.
1295      *
1296      * _Available since v3.3._
1297      */
1298     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1299         return functionStaticCall(target, data, "Address: low-level static call failed");
1300     }
1301 
1302     /**
1303      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1304      * but performing a static call.
1305      *
1306      * _Available since v3.3._
1307      */
1308     function functionStaticCall(
1309         address target,
1310         bytes memory data,
1311         string memory errorMessage
1312     ) internal view returns (bytes memory) {
1313         require(isContract(target), "Address: static call to non-contract");
1314 
1315         (bool success, bytes memory returndata) = target.staticcall(data);
1316         return verifyCallResult(success, returndata, errorMessage);
1317     }
1318 
1319     /**
1320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1321      * but performing a delegate call.
1322      *
1323      * _Available since v3.4._
1324      */
1325     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1326         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1327     }
1328 
1329     /**
1330      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1331      * but performing a delegate call.
1332      *
1333      * _Available since v3.4._
1334      */
1335     function functionDelegateCall(
1336         address target,
1337         bytes memory data,
1338         string memory errorMessage
1339     ) internal returns (bytes memory) {
1340         require(isContract(target), "Address: delegate call to non-contract");
1341 
1342         (bool success, bytes memory returndata) = target.delegatecall(data);
1343         return verifyCallResult(success, returndata, errorMessage);
1344     }
1345 
1346     /**
1347      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1348      * revert reason using the provided one.
1349      *
1350      * _Available since v4.3._
1351      */
1352     function verifyCallResult(
1353         bool success,
1354         bytes memory returndata,
1355         string memory errorMessage
1356     ) internal pure returns (bytes memory) {
1357         if (success) {
1358             return returndata;
1359         } else {
1360             // Look for revert reason and bubble it up if present
1361             if (returndata.length > 0) {
1362                 // The easiest way to bubble the revert reason is using memory via assembly
1363 
1364                 assembly {
1365                     let returndata_size := mload(returndata)
1366                     revert(add(32, returndata), returndata_size)
1367                 }
1368             } else {
1369                 revert(errorMessage);
1370             }
1371         }
1372     }
1373 }
1374 
1375 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1376 
1377 
1378 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1379 
1380 pragma solidity ^0.8.0;
1381 
1382 /**
1383  * @dev Interface of the ERC20 standard as defined in the EIP.
1384  */
1385 interface IERC20 {
1386     /**
1387      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1388      * another (`to`).
1389      *
1390      * Note that `value` may be zero.
1391      */
1392     event Transfer(address indexed from, address indexed to, uint256 value);
1393 
1394     /**
1395      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1396      * a call to {approve}. `value` is the new allowance.
1397      */
1398     event Approval(address indexed owner, address indexed spender, uint256 value);
1399 
1400     /**
1401      * @dev Returns the amount of tokens in existence.
1402      */
1403     function totalSupply() external view returns (uint256);
1404 
1405     /**
1406      * @dev Returns the amount of tokens owned by `account`.
1407      */
1408     function balanceOf(address account) external view returns (uint256);
1409 
1410     /**
1411      * @dev Moves `amount` tokens from the caller's account to `to`.
1412      *
1413      * Returns a boolean value indicating whether the operation succeeded.
1414      *
1415      * Emits a {Transfer} event.
1416      */
1417     function transfer(address to, uint256 amount) external returns (bool);
1418 
1419     /**
1420      * @dev Returns the remaining number of tokens that `spender` will be
1421      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1422      * zero by default.
1423      *
1424      * This value changes when {approve} or {transferFrom} are called.
1425      */
1426     function allowance(address owner, address spender) external view returns (uint256);
1427 
1428     /**
1429      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1430      *
1431      * Returns a boolean value indicating whether the operation succeeded.
1432      *
1433      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1434      * that someone may use both the old and the new allowance by unfortunate
1435      * transaction ordering. One possible solution to mitigate this race
1436      * condition is to first reduce the spender's allowance to 0 and set the
1437      * desired value afterwards:
1438      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1439      *
1440      * Emits an {Approval} event.
1441      */
1442     function approve(address spender, uint256 amount) external returns (bool);
1443 
1444     /**
1445      * @dev Moves `amount` tokens from `from` to `to` using the
1446      * allowance mechanism. `amount` is then deducted from the caller's
1447      * allowance.
1448      *
1449      * Returns a boolean value indicating whether the operation succeeded.
1450      *
1451      * Emits a {Transfer} event.
1452      */
1453     function transferFrom(
1454         address from,
1455         address to,
1456         uint256 amount
1457     ) external returns (bool);
1458 }
1459 
1460 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1461 
1462 
1463 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
1464 
1465 pragma solidity ^0.8.0;
1466 
1467 
1468 
1469 /**
1470  * @title SafeERC20
1471  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1472  * contract returns false). Tokens that return no value (and instead revert or
1473  * throw on failure) are also supported, non-reverting calls are assumed to be
1474  * successful.
1475  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1476  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1477  */
1478 library SafeERC20 {
1479     using Address for address;
1480 
1481     function safeTransfer(
1482         IERC20 token,
1483         address to,
1484         uint256 value
1485     ) internal {
1486         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1487     }
1488 
1489     function safeTransferFrom(
1490         IERC20 token,
1491         address from,
1492         address to,
1493         uint256 value
1494     ) internal {
1495         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1496     }
1497 
1498     /**
1499      * @dev Deprecated. This function has issues similar to the ones found in
1500      * {IERC20-approve}, and its usage is discouraged.
1501      *
1502      * Whenever possible, use {safeIncreaseAllowance} and
1503      * {safeDecreaseAllowance} instead.
1504      */
1505     function safeApprove(
1506         IERC20 token,
1507         address spender,
1508         uint256 value
1509     ) internal {
1510         // safeApprove should only be called when setting an initial allowance,
1511         // or when resetting it to zero. To increase and decrease it, use
1512         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1513         require(
1514             (value == 0) || (token.allowance(address(this), spender) == 0),
1515             "SafeERC20: approve from non-zero to non-zero allowance"
1516         );
1517         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1518     }
1519 
1520     function safeIncreaseAllowance(
1521         IERC20 token,
1522         address spender,
1523         uint256 value
1524     ) internal {
1525         uint256 newAllowance = token.allowance(address(this), spender) + value;
1526         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1527     }
1528 
1529     function safeDecreaseAllowance(
1530         IERC20 token,
1531         address spender,
1532         uint256 value
1533     ) internal {
1534         unchecked {
1535             uint256 oldAllowance = token.allowance(address(this), spender);
1536             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1537             uint256 newAllowance = oldAllowance - value;
1538             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1539         }
1540     }
1541 
1542     /**
1543      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1544      * on the return value: the return value is optional (but if data is returned, it must not be false).
1545      * @param token The token targeted by the call.
1546      * @param data The call data (encoded using abi.encode or one of its variants).
1547      */
1548     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1549         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1550         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1551         // the target address contains contract code and also asserts for success in the low-level call.
1552 
1553         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1554         if (returndata.length > 0) {
1555             // Return data is optional
1556             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1557         }
1558     }
1559 }
1560 
1561 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1562 
1563 
1564 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1565 
1566 pragma solidity ^0.8.0;
1567 
1568 /**
1569  * @dev These functions deal with verification of Merkle Trees proofs.
1570  *
1571  * The proofs can be generated using the JavaScript library
1572  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1573  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1574  *
1575  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1576  *
1577  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1578  * hashing, or use a hash function other than keccak256 for hashing leaves.
1579  * This is because the concatenation of a sorted pair of internal nodes in
1580  * the merkle tree could be reinterpreted as a leaf value.
1581  */
1582 library MerkleProof {
1583     /**
1584      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1585      * defined by `root`. For this, a `proof` must be provided, containing
1586      * sibling hashes on the branch from the leaf to the root of the tree. Each
1587      * pair of leaves and each pair of pre-images are assumed to be sorted.
1588      */
1589     function verify(
1590         bytes32[] memory proof,
1591         bytes32 root,
1592         bytes32 leaf
1593     ) internal pure returns (bool) {
1594         return processProof(proof, leaf) == root;
1595     }
1596 
1597     /**
1598      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1599      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1600      * hash matches the root of the tree. When processing the proof, the pairs
1601      * of leafs & pre-images are assumed to be sorted.
1602      *
1603      * _Available since v4.4._
1604      */
1605     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1606         bytes32 computedHash = leaf;
1607         for (uint256 i = 0; i < proof.length; i++) {
1608             bytes32 proofElement = proof[i];
1609             if (computedHash <= proofElement) {
1610                 // Hash(current computed hash + current element of the proof)
1611                 computedHash = _efficientHash(computedHash, proofElement);
1612             } else {
1613                 // Hash(current element of the proof + current computed hash)
1614                 computedHash = _efficientHash(proofElement, computedHash);
1615             }
1616         }
1617         return computedHash;
1618     }
1619 
1620     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1621         assembly {
1622             mstore(0x00, a)
1623             mstore(0x20, b)
1624             value := keccak256(0x00, 0x40)
1625         }
1626     }
1627 }
1628 
1629 // File: @openzeppelin/contracts/utils/Context.sol
1630 
1631 
1632 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1633 
1634 pragma solidity ^0.8.0;
1635 
1636 /**
1637  * @dev Provides information about the current execution context, including the
1638  * sender of the transaction and its data. While these are generally available
1639  * via msg.sender and msg.data, they should not be accessed in such a direct
1640  * manner, since when dealing with meta-transactions the account sending and
1641  * paying for execution may not be the actual sender (as far as an application
1642  * is concerned).
1643  *
1644  * This contract is only required for intermediate, library-like contracts.
1645  */
1646 abstract contract Context {
1647     function _msgSender() internal view virtual returns (address) {
1648         return msg.sender;
1649     }
1650 
1651     function _msgData() internal view virtual returns (bytes calldata) {
1652         return msg.data;
1653     }
1654 }
1655 
1656 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
1657 
1658 
1659 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
1660 
1661 pragma solidity ^0.8.0;
1662 
1663 
1664 
1665 
1666 /**
1667  * @title PaymentSplitter
1668  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1669  * that the Ether will be split in this way, since it is handled transparently by the contract.
1670  *
1671  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1672  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1673  * an amount proportional to the percentage of total shares they were assigned.
1674  *
1675  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1676  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1677  * function.
1678  *
1679  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1680  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1681  * to run tests before sending real value to this contract.
1682  */
1683 contract PaymentSplitter is Context {
1684     event PayeeAdded(address account, uint256 shares);
1685     event PaymentReleased(address to, uint256 amount);
1686     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1687     event PaymentReceived(address from, uint256 amount);
1688 
1689     uint256 private _totalShares;
1690     uint256 private _totalReleased;
1691 
1692     mapping(address => uint256) private _shares;
1693     mapping(address => uint256) private _released;
1694     address[] private _payees;
1695 
1696     mapping(IERC20 => uint256) private _erc20TotalReleased;
1697     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1698 
1699     /**
1700      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1701      * the matching position in the `shares` array.
1702      *
1703      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1704      * duplicates in `payees`.
1705      */
1706     constructor(address[] memory payees, uint256[] memory shares_) payable {
1707         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1708         require(payees.length > 0, "PaymentSplitter: no payees");
1709 
1710         for (uint256 i = 0; i < payees.length; i++) {
1711             _addPayee(payees[i], shares_[i]);
1712         }
1713     }
1714 
1715     /**
1716      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1717      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1718      * reliability of the events, and not the actual splitting of Ether.
1719      *
1720      * To learn more about this see the Solidity documentation for
1721      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1722      * functions].
1723      */
1724     receive() external payable virtual {
1725         emit PaymentReceived(_msgSender(), msg.value);
1726     }
1727 
1728     /**
1729      * @dev Getter for the total shares held by payees.
1730      */
1731     function totalShares() public view returns (uint256) {
1732         return _totalShares;
1733     }
1734 
1735     /**
1736      * @dev Getter for the total amount of Ether already released.
1737      */
1738     function totalReleased() public view returns (uint256) {
1739         return _totalReleased;
1740     }
1741 
1742     /**
1743      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1744      * contract.
1745      */
1746     function totalReleased(IERC20 token) public view returns (uint256) {
1747         return _erc20TotalReleased[token];
1748     }
1749 
1750     /**
1751      * @dev Getter for the amount of shares held by an account.
1752      */
1753     function shares(address account) public view returns (uint256) {
1754         return _shares[account];
1755     }
1756 
1757     /**
1758      * @dev Getter for the amount of Ether already released to a payee.
1759      */
1760     function released(address account) public view returns (uint256) {
1761         return _released[account];
1762     }
1763 
1764     /**
1765      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1766      * IERC20 contract.
1767      */
1768     function released(IERC20 token, address account) public view returns (uint256) {
1769         return _erc20Released[token][account];
1770     }
1771 
1772     /**
1773      * @dev Getter for the address of the payee number `index`.
1774      */
1775     function payee(uint256 index) public view returns (address) {
1776         return _payees[index];
1777     }
1778 
1779     /**
1780      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1781      * total shares and their previous withdrawals.
1782      */
1783     function release(address payable account) public virtual {
1784         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1785 
1786         uint256 totalReceived = address(this).balance + totalReleased();
1787         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1788 
1789         require(payment != 0, "PaymentSplitter: account is not due payment");
1790 
1791         _released[account] += payment;
1792         _totalReleased += payment;
1793 
1794         Address.sendValue(account, payment);
1795         emit PaymentReleased(account, payment);
1796     }
1797 
1798     /**
1799      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1800      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1801      * contract.
1802      */
1803     function release(IERC20 token, address account) public virtual {
1804         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1805 
1806         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1807         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1808 
1809         require(payment != 0, "PaymentSplitter: account is not due payment");
1810 
1811         _erc20Released[token][account] += payment;
1812         _erc20TotalReleased[token] += payment;
1813 
1814         SafeERC20.safeTransfer(token, account, payment);
1815         emit ERC20PaymentReleased(token, account, payment);
1816     }
1817 
1818     /**
1819      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1820      * already released amounts.
1821      */
1822     function _pendingPayment(
1823         address account,
1824         uint256 totalReceived,
1825         uint256 alreadyReleased
1826     ) private view returns (uint256) {
1827         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1828     }
1829 
1830     /**
1831      * @dev Add a new payee to the contract.
1832      * @param account The address of the payee to add.
1833      * @param shares_ The number of shares owned by the payee.
1834      */
1835     function _addPayee(address account, uint256 shares_) private {
1836         require(account != address(0), "PaymentSplitter: account is the zero address");
1837         require(shares_ > 0, "PaymentSplitter: shares are 0");
1838         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1839 
1840         _payees.push(account);
1841         _shares[account] = shares_;
1842         _totalShares = _totalShares + shares_;
1843         emit PayeeAdded(account, shares_);
1844     }
1845 }
1846 
1847 // File: @openzeppelin/contracts/access/Ownable.sol
1848 
1849 
1850 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1851 
1852 pragma solidity ^0.8.0;
1853 
1854 
1855 /**
1856  * @dev Contract module which provides a basic access control mechanism, where
1857  * there is an account (an owner) that can be granted exclusive access to
1858  * specific functions.
1859  *
1860  * By default, the owner account will be the one that deploys the contract. This
1861  * can later be changed with {transferOwnership}.
1862  *
1863  * This module is used through inheritance. It will make available the modifier
1864  * `onlyOwner`, which can be applied to your functions to restrict their use to
1865  * the owner.
1866  */
1867 abstract contract Ownable is Context {
1868     address private _owner;
1869 
1870     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1871 
1872     /**
1873      * @dev Initializes the contract setting the deployer as the initial owner.
1874      */
1875     constructor() {
1876         _transferOwnership(_msgSender());
1877     }
1878 
1879     /**
1880      * @dev Returns the address of the current owner.
1881      */
1882     function owner() public view virtual returns (address) {
1883         return _owner;
1884     }
1885 
1886     /**
1887      * @dev Throws if called by any account other than the owner.
1888      */
1889     modifier onlyOwner() {
1890         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1891         _;
1892     }
1893 
1894     /**
1895      * @dev Leaves the contract without owner. It will not be possible to call
1896      * `onlyOwner` functions anymore. Can only be called by the current owner.
1897      *
1898      * NOTE: Renouncing ownership will leave the contract without an owner,
1899      * thereby removing any functionality that is only available to the owner.
1900      */
1901     function renounceOwnership() public virtual onlyOwner {
1902         _transferOwnership(address(0));
1903     }
1904 
1905     /**
1906      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1907      * Can only be called by the current owner.
1908      */
1909     function transferOwnership(address newOwner) public virtual onlyOwner {
1910         require(newOwner != address(0), "Ownable: new owner is the zero address");
1911         _transferOwnership(newOwner);
1912     }
1913 
1914     /**
1915      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1916      * Internal function without access restriction.
1917      */
1918     function _transferOwnership(address newOwner) internal virtual {
1919         address oldOwner = _owner;
1920         _owner = newOwner;
1921         emit OwnershipTransferred(oldOwner, newOwner);
1922     }
1923 }
1924 
1925 // File: Bears.sol
1926 
1927 
1928 pragma solidity ^0.8.7;
1929 
1930 //@author Abderrahman JAIZE
1931 //@BEARS
1932 
1933 
1934 contract Bears is Ownable, ERC721A, PaymentSplitter {
1935 
1936     using Strings for uint;
1937 
1938     enum Step {
1939         Before,
1940         Mint,
1941         SoldOut
1942     }
1943 
1944     string public baseURI;
1945 
1946     Step public sellingStep;
1947 
1948     uint private constant MAX_SUPPLY = 10000;
1949     uint private constant MAX_PUBLIC = 10000;
1950 
1951     uint public publicSalePrice = 0 ether;
1952 
1953     uint public FreeMinAmount = 10 ; 
1954 
1955     bytes32 public merkleRoot;
1956 
1957     uint private teamLength;
1958 
1959     constructor(address[] memory _team, uint[] memory _teamShares, bytes32 _merkleRoot, string memory _baseURI) ERC721A("Mutant Okay Bearz", "MOB")
1960     PaymentSplitter(_team, _teamShares) {
1961         merkleRoot = _merkleRoot;
1962         baseURI = _baseURI;
1963         teamLength = _team.length;
1964     }
1965 
1966     modifier callerIsUser() {
1967         require(tx.origin == msg.sender, "The caller is another contract");
1968         _;
1969     }
1970 
1971     function MutantMint(address _account, uint _quantity) external payable callerIsUser {
1972         uint price = publicSalePrice;
1973         require(_quantity < FreeMinAmount+1, "quantity is not right"); 
1974         require(sellingStep == Step.Mint, "Public sale is not activated");
1975         require(totalSupply() + _quantity <= MAX_PUBLIC, "Max supply exceeded");
1976         require(msg.value >= price * _quantity, "Not enought funds");
1977         _safeMint(_account, _quantity);
1978     }
1979     /*
1980     function setSaleStartTime() external onlyOwner {
1981         saleStartTime = 0.02 ether;
1982     }
1983     */
1984     function setPublicSalePrice() external onlyOwner {
1985         publicSalePrice = 0.0069 ether;
1986     }
1987 
1988     function setFreeMinAmount(uint _FreeMinAmount) external onlyOwner {
1989         FreeMinAmount = _FreeMinAmount;
1990     }
1991 
1992     function setBaseUri(string memory _baseURI) external onlyOwner {
1993         baseURI = _baseURI;
1994     }
1995 
1996     function currentTime() internal view returns(uint) {
1997         return block.timestamp;
1998     }
1999 
2000     function setStep(uint _step) external onlyOwner {
2001         sellingStep = Step(_step);
2002     }
2003 
2004     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
2005         require(_exists(_tokenId), "URI query for nonexistent token");
2006 
2007         return string(abi.encodePacked(baseURI, _tokenId.toString(), ".json"));
2008     }
2009 
2010     //Whitelist
2011     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
2012         merkleRoot = _merkleRoot;
2013     }
2014 
2015     function isWhiteListed(address _account, bytes32[] calldata _proof) internal view returns(bool) {
2016         return _verify(leaf(_account), _proof);
2017     }
2018 
2019     function leaf(address _account) internal pure returns(bytes32) {
2020         return keccak256(abi.encodePacked(_account));
2021     }
2022 
2023     function _verify(bytes32 _leaf, bytes32[] memory _proof) internal view returns(bool) {
2024         return MerkleProof.verify(_proof, merkleRoot, _leaf);
2025     }
2026 
2027     //ReleaseALL
2028     function releaseAll() external {
2029         for(uint i = 0 ; i < teamLength ; i++) {
2030             release(payable(payee(i)));
2031         }
2032     }
2033 
2034     receive() override external payable {
2035         revert('Only if you mint');
2036     }
2037 
2038 }