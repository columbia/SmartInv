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
1080 // File: contracts/Strings.sol
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
1149 // File: contracts/ReentrancyGuard.sol
1150 
1151 
1152 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1153 
1154 pragma solidity ^0.8.0;
1155 
1156 /**
1157  * @dev Contract module that helps prevent reentrant calls to a function.
1158  *
1159  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1160  * available, which can be applied to functions to make sure there are no nested
1161  * (reentrant) calls to them.
1162  *
1163  * Note that because there is a single `nonReentrant` guard, functions marked as
1164  * `nonReentrant` may not call one another. This can be worked around by making
1165  * those functions `private`, and then adding `external` `nonReentrant` entry
1166  * points to them.
1167  *
1168  * TIP: If you would like to learn more about reentrancy and alternative ways
1169  * to protect against it, check out our blog post
1170  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1171  */
1172 abstract contract ReentrancyGuard {
1173     // Booleans are more expensive than uint256 or any type that takes up a full
1174     // word because each write operation emits an extra SLOAD to first read the
1175     // slot's contents, replace the bits taken up by the boolean, and then write
1176     // back. This is the compiler's defense against contract upgrades and
1177     // pointer aliasing, and it cannot be disabled.
1178 
1179     // The values being non-zero value makes deployment a bit more expensive,
1180     // but in exchange the refund on every call to nonReentrant will be lower in
1181     // amount. Since refunds are capped to a percentage of the total
1182     // transaction's gas, it is best to keep them low in cases like this one, to
1183     // increase the likelihood of the full refund coming into effect.
1184     uint256 private constant _NOT_ENTERED = 1;
1185     uint256 private constant _ENTERED = 2;
1186 
1187     uint256 private _status;
1188 
1189     constructor() {
1190         _status = _NOT_ENTERED;
1191     }
1192 
1193     /**
1194      * @dev Prevents a contract from calling itself, directly or indirectly.
1195      * Calling a `nonReentrant` function from another `nonReentrant`
1196      * function is not supported. It is possible to prevent this from happening
1197      * by making the `nonReentrant` function external, and making it call a
1198      * `private` function that does the actual work.
1199      */
1200     modifier nonReentrant() {
1201         // On the first call to nonReentrant, _notEntered will be true
1202         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1203 
1204         // Any calls to nonReentrant after this point will fail
1205         _status = _ENTERED;
1206 
1207         _;
1208 
1209         // By storing the original value once again, a refund is triggered (see
1210         // https://eips.ethereum.org/EIPS/eip-2200)
1211         _status = _NOT_ENTERED;
1212     }
1213 }
1214 // File: contracts/Context.sol
1215 
1216 
1217 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1218 
1219 pragma solidity ^0.8.0;
1220 
1221 /**
1222  * @dev Provides information about the current execution context, including the
1223  * sender of the transaction and its data. While these are generally available
1224  * via msg.sender and msg.data, they should not be accessed in such a direct
1225  * manner, since when dealing with meta-transactions the account sending and
1226  * paying for execution may not be the actual sender (as far as an application
1227  * is concerned).
1228  *
1229  * This contract is only required for intermediate, library-like contracts.
1230  */
1231 abstract contract Context {
1232     function _msgSender() internal view virtual returns (address) {
1233         return msg.sender;
1234     }
1235 
1236     function _msgData() internal view virtual returns (bytes calldata) {
1237         return msg.data;
1238     }
1239 }
1240 // File: contracts/Ownable.sol
1241 
1242 
1243 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1244 
1245 pragma solidity ^0.8.0;
1246 
1247 
1248 /**
1249  * @dev Contract module which provides a basic access control mechanism, where
1250  * there is an account (an owner) that can be granted exclusive access to
1251  * specific functions.
1252  *
1253  * By default, the owner account will be the one that deploys the contract. This
1254  * can later be changed with {transferOwnership}.
1255  *
1256  * This module is used through inheritance. It will make available the modifier
1257  * `onlyOwner`, which can be applied to your functions to restrict their use to
1258  * the owner.
1259  */
1260 abstract contract Ownable is Context {
1261     address private _owner;
1262 
1263     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1264 
1265     /**
1266      * @dev Initializes the contract setting the deployer as the initial owner.
1267      */
1268     constructor() {
1269         _transferOwnership(_msgSender());
1270     }
1271 
1272     /**
1273      * @dev Returns the address of the current owner.
1274      */
1275     function owner() public view virtual returns (address) {
1276         return _owner;
1277     }
1278 
1279     /**
1280      * @dev Throws if called by any account other than the owner.
1281      */
1282     modifier onlyOwner() {
1283         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1284         _;
1285     }
1286 
1287     /**
1288      * @dev Leaves the contract without owner. It will not be possible to call
1289      * `onlyOwner` functions anymore. Can only be called by the current owner.
1290      *
1291      * NOTE: Renouncing ownership will leave the contract without an owner,
1292      * thereby removing any functionality that is only available to the owner.
1293      */
1294     function renounceOwnership() public virtual onlyOwner {
1295         _transferOwnership(address(0));
1296     }
1297 
1298     /**
1299      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1300      * Can only be called by the current owner.
1301      */
1302     function transferOwnership(address newOwner) public virtual onlyOwner {
1303         require(newOwner != address(0), "Ownable: new owner is the zero address");
1304         _transferOwnership(newOwner);
1305     }
1306 
1307     /**
1308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1309      * Internal function without access restriction.
1310      */
1311     function _transferOwnership(address newOwner) internal virtual {
1312         address oldOwner = _owner;
1313         _owner = newOwner;
1314         emit OwnershipTransferred(oldOwner, newOwner);
1315     }
1316 }
1317 // File: contracts/CNR.sol
1318 
1319 
1320 
1321 pragma solidity >=0.8.9 <0.9.0;
1322 
1323 
1324 
1325 
1326 
1327 contract CNR is ERC721A, Ownable, ReentrancyGuard {
1328   using Strings for uint256;
1329 
1330   string public uriPrefix = '';
1331   string public uriSuffix = '.json';
1332   string public hiddenMetadataUri;
1333 
1334   uint256 public cost = 0.0029 ether;
1335   uint256 public maxSupply = 10000;
1336   uint256 public maxMintAmount = 60;
1337   uint256 public maxPerTxn = 20;
1338   uint256 public maxFreeMintPerWalletAmount = 1;
1339 
1340   bool public revealed = true;
1341   bool public paused = true;
1342 
1343   constructor(
1344     string memory _tokenName,
1345     string memory _tokenSymbol,
1346     string memory _hiddenMetadataUri
1347   ) ERC721A(_tokenName, _tokenSymbol) {
1348     setHiddenMetadataUri(_hiddenMetadataUri);
1349   }
1350 
1351   modifier mintCompliance(uint256 _mintAmount) {
1352     require(!paused, "Minting phase not started.");
1353     require(totalSupply() + _mintAmount <= maxSupply, "All CNR minted.");
1354     require(_mintAmount > 0 && _mintAmount <= maxPerTxn, "20 max mints per txn.");
1355     require(tx.origin == msg.sender, "Calling from other contract is not allowed.");
1356     require(
1357       _mintAmount > 0 && numberMinted(msg.sender) + _mintAmount <= maxMintAmount,
1358        "Invalid mint amount or minted max amount already."
1359     );
1360     _;
1361   }
1362 
1363   modifier mintPriceCompliance(uint256 _mintAmount) {
1364     uint256 costToSubtract = 0;
1365     
1366     if (numberMinted(msg.sender) < maxFreeMintPerWalletAmount) {
1367       uint256 freeMintsLeft = maxFreeMintPerWalletAmount - numberMinted(msg.sender);
1368       costToSubtract = cost * freeMintsLeft;
1369     }
1370    
1371     require(msg.value >= cost * _mintAmount - costToSubtract, "Insufficient or incorrect funds.");
1372     _;
1373   }
1374 
1375   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1376     _safeMint(_msgSender(), _mintAmount);
1377   }
1378   
1379   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1380     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1381     _safeMint(_receiver, _mintAmount);
1382   }
1383 
1384   function _startTokenId() internal view virtual override returns (uint256) {
1385     return 1;
1386   }
1387 
1388   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1389     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1390 
1391     if (revealed == false) {
1392       return hiddenMetadataUri;
1393     }
1394 
1395     string memory currentBaseURI = _baseURI();
1396     return bytes(currentBaseURI).length > 0
1397         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1398         : '';
1399   }
1400 
1401   function setCost(uint256 _cost) public onlyOwner {
1402     cost = _cost;
1403   }
1404 
1405   function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1406     maxMintAmount = _maxMintAmount;
1407   }
1408 
1409   function setmaxFreeMintPerWalletAmount(uint256 _maxFreeMintPerWalletAmount) public onlyOwner {
1410     maxFreeMintPerWalletAmount = _maxFreeMintPerWalletAmount;
1411   }
1412 
1413   function setRevealed(bool _state) public onlyOwner {
1414     revealed = _state;
1415   }
1416 
1417    function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1418     hiddenMetadataUri = _hiddenMetadataUri;
1419   }
1420 
1421   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1422     uriPrefix = _uriPrefix;
1423   }
1424 
1425   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1426     uriSuffix = _uriSuffix;
1427   }
1428 
1429   function setPaused(bool _state) public onlyOwner {
1430     paused = _state;
1431   }
1432 
1433   function withdraw() public onlyOwner nonReentrant {
1434     uint256 core = address(this).balance * 4250 / 10000;
1435 
1436     (bool core1, ) = payable(0x6F48d7A2Ca89587b806B216B9cE4600549Da2cF5).call{value: core}('');
1437     require(core1);
1438 
1439     (bool core2, ) = payable(0x1FF5bb08DBb39Ad95920286bB8eEb65D15A6E1cc).call{value: core}('');
1440     require(core2);
1441 
1442     (bool freelance, ) = payable(0x2c3a1748C0dB5F073576cb6C84bC32607415077d).call{value: address(this).balance}('');
1443     require(freelance);
1444   }
1445 
1446   function numberMinted(address owner) public view returns (uint256) {
1447     return _numberMinted(owner);
1448   }
1449 
1450   function _baseURI() internal view virtual override returns (string memory) {
1451     return uriPrefix;
1452   }
1453 }