1 // File: erc721a/contracts/IERC721A.sol
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
263 
264 // File: erc721a/contracts/ERC721A.sol
265 
266 
267 // ERC721A Contracts v4.0.0
268 // Creator: Chiru Labs
269 
270 pragma solidity ^0.8.4;
271 
272 
273 /**
274  * @dev ERC721 token receiver interface.
275  */
276 interface ERC721A__IERC721Receiver {
277     function onERC721Received(
278         address operator,
279         address from,
280         uint256 tokenId,
281         bytes calldata data
282     ) external returns (bytes4);
283 }
284 
285 /**
286  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
287  * the Metadata extension. Built to optimize for lower gas during batch mints.
288  *
289  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
290  *
291  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
292  *
293  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
294  */
295 contract ERC721A is IERC721A {
296     // Mask of an entry in packed address data.
297     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
298 
299     // The bit position of `numberMinted` in packed address data.
300     uint256 private constant BITPOS_NUMBER_MINTED = 64;
301 
302     // The bit position of `numberBurned` in packed address data.
303     uint256 private constant BITPOS_NUMBER_BURNED = 128;
304 
305     // The bit position of `aux` in packed address data.
306     uint256 private constant BITPOS_AUX = 192;
307 
308     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
309     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
310 
311     // The bit position of `startTimestamp` in packed ownership.
312     uint256 private constant BITPOS_START_TIMESTAMP = 160;
313 
314     // The bit mask of the `burned` bit in packed ownership.
315     uint256 private constant BITMASK_BURNED = 1 << 224;
316     
317     // The bit position of the `nextInitialized` bit in packed ownership.
318     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
319 
320     // The bit mask of the `nextInitialized` bit in packed ownership.
321     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
322 
323     // The tokenId of the next token to be minted.
324     uint256 private _currentIndex;
325 
326     // The number of tokens burned.
327     uint256 private _burnCounter;
328 
329     // Token name
330     string private _name;
331 
332     // Token symbol
333     string private _symbol;
334 
335     // Mapping from token ID to ownership details
336     // An empty struct value does not necessarily mean the token is unowned.
337     // See `_packedOwnershipOf` implementation for details.
338     //
339     // Bits Layout:
340     // - [0..159]   `addr`
341     // - [160..223] `startTimestamp`
342     // - [224]      `burned`
343     // - [225]      `nextInitialized`
344     mapping(uint256 => uint256) private _packedOwnerships;
345 
346     // Mapping owner address to address data.
347     //
348     // Bits Layout:
349     // - [0..63]    `balance`
350     // - [64..127]  `numberMinted`
351     // - [128..191] `numberBurned`
352     // - [192..255] `aux`
353     mapping(address => uint256) private _packedAddressData;
354 
355     // Mapping from token ID to approved address.
356     mapping(uint256 => address) private _tokenApprovals;
357 
358     // Mapping from owner to operator approvals
359     mapping(address => mapping(address => bool)) private _operatorApprovals;
360 
361     constructor(string memory name_, string memory symbol_) {
362         _name = name_;
363         _symbol = symbol_;
364         _currentIndex = _startTokenId();
365     }
366 
367     /**
368      * @dev Returns the starting token ID. 
369      * To change the starting token ID, please override this function.
370      */
371     function _startTokenId() internal view virtual returns (uint256) {
372         return 0;
373     }
374 
375     /**
376      * @dev Returns the next token ID to be minted.
377      */
378     function _nextTokenId() internal view returns (uint256) {
379         return _currentIndex;
380     }
381 
382     /**
383      * @dev Returns the total number of tokens in existence.
384      * Burned tokens will reduce the count. 
385      * To get the total number of tokens minted, please see `_totalMinted`.
386      */
387     function totalSupply() public view override returns (uint256) {
388         // Counter underflow is impossible as _burnCounter cannot be incremented
389         // more than `_currentIndex - _startTokenId()` times.
390         unchecked {
391             return _currentIndex - _burnCounter - _startTokenId();
392         }
393     }
394 
395     /**
396      * @dev Returns the total amount of tokens minted in the contract.
397      */
398     function _totalMinted() internal view returns (uint256) {
399         // Counter underflow is impossible as _currentIndex does not decrement,
400         // and it is initialized to `_startTokenId()`
401         unchecked {
402             return _currentIndex - _startTokenId();
403         }
404     }
405 
406     /**
407      * @dev Returns the total number of tokens burned.
408      */
409     function _totalBurned() internal view returns (uint256) {
410         return _burnCounter;
411     }
412 
413     /**
414      * @dev See {IERC165-supportsInterface}.
415      */
416     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
417         // The interface IDs are constants representing the first 4 bytes of the XOR of
418         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
419         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
420         return
421             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
422             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
423             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
424     }
425 
426     /**
427      * @dev See {IERC721-balanceOf}.
428      */
429     function balanceOf(address owner) public view override returns (uint256) {
430         if (owner == address(0)) revert BalanceQueryForZeroAddress();
431         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
432     }
433 
434     /**
435      * Returns the number of tokens minted by `owner`.
436      */
437     function _numberMinted(address owner) internal view returns (uint256) {
438         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
439     }
440 
441     /**
442      * Returns the number of tokens burned by or on behalf of `owner`.
443      */
444     function _numberBurned(address owner) internal view returns (uint256) {
445         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
446     }
447 
448     /**
449      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
450      */
451     function _getAux(address owner) internal view returns (uint64) {
452         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
453     }
454 
455     /**
456      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
457      * If there are multiple variables, please pack them into a uint64.
458      */
459     function _setAux(address owner, uint64 aux) internal {
460         uint256 packed = _packedAddressData[owner];
461         uint256 auxCasted;
462         assembly { // Cast aux without masking.
463             auxCasted := aux
464         }
465         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
466         _packedAddressData[owner] = packed;
467     }
468 
469     /**
470      * Returns the packed ownership data of `tokenId`.
471      */
472     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
473         uint256 curr = tokenId;
474 
475         unchecked {
476             if (_startTokenId() <= curr)
477                 if (curr < _currentIndex) {
478                     uint256 packed = _packedOwnerships[curr];
479                     // If not burned.
480                     if (packed & BITMASK_BURNED == 0) {
481                         // Invariant:
482                         // There will always be an ownership that has an address and is not burned
483                         // before an ownership that does not have an address and is not burned.
484                         // Hence, curr will not underflow.
485                         //
486                         // We can directly compare the packed value.
487                         // If the address is zero, packed is zero.
488                         while (packed == 0) {
489                             packed = _packedOwnerships[--curr];
490                         }
491                         return packed;
492                     }
493                 }
494         }
495         revert OwnerQueryForNonexistentToken();
496     }
497 
498     /**
499      * Returns the unpacked `TokenOwnership` struct from `packed`.
500      */
501     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
502         ownership.addr = address(uint160(packed));
503         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
504         ownership.burned = packed & BITMASK_BURNED != 0;
505     }
506 
507     /**
508      * Returns the unpacked `TokenOwnership` struct at `index`.
509      */
510     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
511         return _unpackedOwnership(_packedOwnerships[index]);
512     }
513 
514     /**
515      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
516      */
517     function _initializeOwnershipAt(uint256 index) internal {
518         if (_packedOwnerships[index] == 0) {
519             _packedOwnerships[index] = _packedOwnershipOf(index);
520         }
521     }
522 
523     /**
524      * Gas spent here starts off proportional to the maximum mint batch size.
525      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
526      */
527     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
528         return _unpackedOwnership(_packedOwnershipOf(tokenId));
529     }
530 
531     /**
532      * @dev See {IERC721-ownerOf}.
533      */
534     function ownerOf(uint256 tokenId) public view override returns (address) {
535         return address(uint160(_packedOwnershipOf(tokenId)));
536     }
537 
538     /**
539      * @dev See {IERC721Metadata-name}.
540      */
541     function name() public view virtual override returns (string memory) {
542         return _name;
543     }
544 
545     /**
546      * @dev See {IERC721Metadata-symbol}.
547      */
548     function symbol() public view virtual override returns (string memory) {
549         return _symbol;
550     }
551 
552     /**
553      * @dev See {IERC721Metadata-tokenURI}.
554      */
555     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
556         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
557 
558         string memory baseURI = _baseURI();
559         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
560     }
561 
562     /**
563      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
564      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
565      * by default, can be overriden in child contracts.
566      */
567     function _baseURI() internal view virtual returns (string memory) {
568         return '';
569     }
570 
571     /**
572      * @dev Casts the address to uint256 without masking.
573      */
574     function _addressToUint256(address value) private pure returns (uint256 result) {
575         assembly {
576             result := value
577         }
578     }
579 
580     /**
581      * @dev Casts the boolean to uint256 without branching.
582      */
583     function _boolToUint256(bool value) private pure returns (uint256 result) {
584         assembly {
585             result := value
586         }
587     }
588 
589     /**
590      * @dev See {IERC721-approve}.
591      */
592     function approve(address to, uint256 tokenId) public override {
593         address owner = address(uint160(_packedOwnershipOf(tokenId)));
594         if (to == owner) revert ApprovalToCurrentOwner();
595 
596         if (_msgSenderERC721A() != owner)
597             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
598                 revert ApprovalCallerNotOwnerNorApproved();
599             }
600 
601         _tokenApprovals[tokenId] = to;
602         emit Approval(owner, to, tokenId);
603     }
604 
605     /**
606      * @dev See {IERC721-getApproved}.
607      */
608     function getApproved(uint256 tokenId) public view override returns (address) {
609         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
610 
611         return _tokenApprovals[tokenId];
612     }
613 
614     /**
615      * @dev See {IERC721-setApprovalForAll}.
616      */
617     function setApprovalForAll(address operator, bool approved) public virtual override {
618         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
619 
620         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
621         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
622     }
623 
624     /**
625      * @dev See {IERC721-isApprovedForAll}.
626      */
627     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
628         return _operatorApprovals[owner][operator];
629     }
630 
631     /**
632      * @dev See {IERC721-transferFrom}.
633      */
634     function transferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) public virtual override {
639         _transfer(from, to, tokenId);
640     }
641 
642     /**
643      * @dev See {IERC721-safeTransferFrom}.
644      */
645     function safeTransferFrom(
646         address from,
647         address to,
648         uint256 tokenId
649     ) public virtual override {
650         safeTransferFrom(from, to, tokenId, '');
651     }
652 
653     /**
654      * @dev See {IERC721-safeTransferFrom}.
655      */
656     function safeTransferFrom(
657         address from,
658         address to,
659         uint256 tokenId,
660         bytes memory _data
661     ) public virtual override {
662         _transfer(from, to, tokenId);
663         if (to.code.length != 0)
664             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
665                 revert TransferToNonERC721ReceiverImplementer();
666             }
667     }
668 
669     /**
670      * @dev Returns whether `tokenId` exists.
671      *
672      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
673      *
674      * Tokens start existing when they are minted (`_mint`),
675      */
676     function _exists(uint256 tokenId) internal view returns (bool) {
677         return
678             _startTokenId() <= tokenId &&
679             tokenId < _currentIndex && // If within bounds,
680             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
681     }
682 
683     /**
684      * @dev Equivalent to `_safeMint(to, quantity, '')`.
685      */
686     function _safeMint(address to, uint256 quantity) internal {
687         _safeMint(to, quantity, '');
688     }
689 
690     /**
691      * @dev Safely mints `quantity` tokens and transfers them to `to`.
692      *
693      * Requirements:
694      *
695      * - If `to` refers to a smart contract, it must implement
696      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
697      * - `quantity` must be greater than 0.
698      *
699      * Emits a {Transfer} event.
700      */
701     function _safeMint(
702         address to,
703         uint256 quantity,
704         bytes memory _data
705     ) internal {
706         uint256 startTokenId = _currentIndex;
707         if (to == address(0)) revert MintToZeroAddress();
708         if (quantity == 0) revert MintZeroQuantity();
709 
710         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
711 
712         // Overflows are incredibly unrealistic.
713         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
714         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
715         unchecked {
716             // Updates:
717             // - `balance += quantity`.
718             // - `numberMinted += quantity`.
719             //
720             // We can directly add to the balance and number minted.
721             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
722 
723             // Updates:
724             // - `address` to the owner.
725             // - `startTimestamp` to the timestamp of minting.
726             // - `burned` to `false`.
727             // - `nextInitialized` to `quantity == 1`.
728             _packedOwnerships[startTokenId] =
729                 _addressToUint256(to) |
730                 (block.timestamp << BITPOS_START_TIMESTAMP) |
731                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
732 
733             uint256 updatedIndex = startTokenId;
734             uint256 end = updatedIndex + quantity;
735 
736             if (to.code.length != 0) {
737                 do {
738                     emit Transfer(address(0), to, updatedIndex);
739                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
740                         revert TransferToNonERC721ReceiverImplementer();
741                     }
742                 } while (updatedIndex < end);
743                 // Reentrancy protection
744                 if (_currentIndex != startTokenId) revert();
745             } else {
746                 do {
747                     emit Transfer(address(0), to, updatedIndex++);
748                 } while (updatedIndex < end);
749             }
750             _currentIndex = updatedIndex;
751         }
752         _afterTokenTransfers(address(0), to, startTokenId, quantity);
753     }
754 
755     /**
756      * @dev Mints `quantity` tokens and transfers them to `to`.
757      *
758      * Requirements:
759      *
760      * - `to` cannot be the zero address.
761      * - `quantity` must be greater than 0.
762      *
763      * Emits a {Transfer} event.
764      */
765     function _mint(address to, uint256 quantity) internal {
766         uint256 startTokenId = _currentIndex;
767         if (to == address(0)) revert MintToZeroAddress();
768         if (quantity == 0) revert MintZeroQuantity();
769 
770         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
771 
772         // Overflows are incredibly unrealistic.
773         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
774         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
775         unchecked {
776             // Updates:
777             // - `balance += quantity`.
778             // - `numberMinted += quantity`.
779             //
780             // We can directly add to the balance and number minted.
781             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
782 
783             // Updates:
784             // - `address` to the owner.
785             // - `startTimestamp` to the timestamp of minting.
786             // - `burned` to `false`.
787             // - `nextInitialized` to `quantity == 1`.
788             _packedOwnerships[startTokenId] =
789                 _addressToUint256(to) |
790                 (block.timestamp << BITPOS_START_TIMESTAMP) |
791                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
792 
793             uint256 updatedIndex = startTokenId;
794             uint256 end = updatedIndex + quantity;
795 
796             do {
797                 emit Transfer(address(0), to, updatedIndex++);
798             } while (updatedIndex < end);
799 
800             _currentIndex = updatedIndex;
801         }
802         _afterTokenTransfers(address(0), to, startTokenId, quantity);
803     }
804 
805     /**
806      * @dev Transfers `tokenId` from `from` to `to`.
807      *
808      * Requirements:
809      *
810      * - `to` cannot be the zero address.
811      * - `tokenId` token must be owned by `from`.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _transfer(
816         address from,
817         address to,
818         uint256 tokenId
819     ) private {
820         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
821 
822         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
823 
824         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
825             isApprovedForAll(from, _msgSenderERC721A()) ||
826             getApproved(tokenId) == _msgSenderERC721A());
827 
828         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
829         if (to == address(0)) revert TransferToZeroAddress();
830 
831         _beforeTokenTransfers(from, to, tokenId, 1);
832 
833         // Clear approvals from the previous owner.
834         delete _tokenApprovals[tokenId];
835 
836         // Underflow of the sender's balance is impossible because we check for
837         // ownership above and the recipient's balance can't realistically overflow.
838         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
839         unchecked {
840             // We can directly increment and decrement the balances.
841             --_packedAddressData[from]; // Updates: `balance -= 1`.
842             ++_packedAddressData[to]; // Updates: `balance += 1`.
843 
844             // Updates:
845             // - `address` to the next owner.
846             // - `startTimestamp` to the timestamp of transfering.
847             // - `burned` to `false`.
848             // - `nextInitialized` to `true`.
849             _packedOwnerships[tokenId] =
850                 _addressToUint256(to) |
851                 (block.timestamp << BITPOS_START_TIMESTAMP) |
852                 BITMASK_NEXT_INITIALIZED;
853 
854             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
855             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
856                 uint256 nextTokenId = tokenId + 1;
857                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
858                 if (_packedOwnerships[nextTokenId] == 0) {
859                     // If the next slot is within bounds.
860                     if (nextTokenId != _currentIndex) {
861                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
862                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
863                     }
864                 }
865             }
866         }
867 
868         emit Transfer(from, to, tokenId);
869         _afterTokenTransfers(from, to, tokenId, 1);
870     }
871 
872     /**
873      * @dev Equivalent to `_burn(tokenId, false)`.
874      */
875     function _burn(uint256 tokenId) internal virtual {
876         _burn(tokenId, false);
877     }
878 
879     /**
880      * @dev Destroys `tokenId`.
881      * The approval is cleared when the token is burned.
882      *
883      * Requirements:
884      *
885      * - `tokenId` must exist.
886      *
887      * Emits a {Transfer} event.
888      */
889     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
890         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
891 
892         address from = address(uint160(prevOwnershipPacked));
893 
894         if (approvalCheck) {
895             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
896                 isApprovedForAll(from, _msgSenderERC721A()) ||
897                 getApproved(tokenId) == _msgSenderERC721A());
898 
899             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
900         }
901 
902         _beforeTokenTransfers(from, address(0), tokenId, 1);
903 
904         // Clear approvals from the previous owner.
905         delete _tokenApprovals[tokenId];
906 
907         // Underflow of the sender's balance is impossible because we check for
908         // ownership above and the recipient's balance can't realistically overflow.
909         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
910         unchecked {
911             // Updates:
912             // - `balance -= 1`.
913             // - `numberBurned += 1`.
914             //
915             // We can directly decrement the balance, and increment the number burned.
916             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
917             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
918 
919             // Updates:
920             // - `address` to the last owner.
921             // - `startTimestamp` to the timestamp of burning.
922             // - `burned` to `true`.
923             // - `nextInitialized` to `true`.
924             _packedOwnerships[tokenId] =
925                 _addressToUint256(from) |
926                 (block.timestamp << BITPOS_START_TIMESTAMP) |
927                 BITMASK_BURNED | 
928                 BITMASK_NEXT_INITIALIZED;
929 
930             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
931             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
932                 uint256 nextTokenId = tokenId + 1;
933                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
934                 if (_packedOwnerships[nextTokenId] == 0) {
935                     // If the next slot is within bounds.
936                     if (nextTokenId != _currentIndex) {
937                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
938                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
939                     }
940                 }
941             }
942         }
943 
944         emit Transfer(from, address(0), tokenId);
945         _afterTokenTransfers(from, address(0), tokenId, 1);
946 
947         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
948         unchecked {
949             _burnCounter++;
950         }
951     }
952 
953     /**
954      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
955      *
956      * @param from address representing the previous owner of the given token ID
957      * @param to target address that will receive the tokens
958      * @param tokenId uint256 ID of the token to be transferred
959      * @param _data bytes optional data to send along with the call
960      * @return bool whether the call correctly returned the expected magic value
961      */
962     function _checkContractOnERC721Received(
963         address from,
964         address to,
965         uint256 tokenId,
966         bytes memory _data
967     ) private returns (bool) {
968         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
969             bytes4 retval
970         ) {
971             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
972         } catch (bytes memory reason) {
973             if (reason.length == 0) {
974                 revert TransferToNonERC721ReceiverImplementer();
975             } else {
976                 assembly {
977                     revert(add(32, reason), mload(reason))
978                 }
979             }
980         }
981     }
982 
983     /**
984      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
985      * And also called before burning one token.
986      *
987      * startTokenId - the first token id to be transferred
988      * quantity - the amount to be transferred
989      *
990      * Calling conditions:
991      *
992      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
993      * transferred to `to`.
994      * - When `from` is zero, `tokenId` will be minted for `to`.
995      * - When `to` is zero, `tokenId` will be burned by `from`.
996      * - `from` and `to` are never both zero.
997      */
998     function _beforeTokenTransfers(
999         address from,
1000         address to,
1001         uint256 startTokenId,
1002         uint256 quantity
1003     ) internal virtual {}
1004 
1005     /**
1006      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1007      * minting.
1008      * And also called after one token has been burned.
1009      *
1010      * startTokenId - the first token id to be transferred
1011      * quantity - the amount to be transferred
1012      *
1013      * Calling conditions:
1014      *
1015      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1016      * transferred to `to`.
1017      * - When `from` is zero, `tokenId` has been minted for `to`.
1018      * - When `to` is zero, `tokenId` has been burned by `from`.
1019      * - `from` and `to` are never both zero.
1020      */
1021     function _afterTokenTransfers(
1022         address from,
1023         address to,
1024         uint256 startTokenId,
1025         uint256 quantity
1026     ) internal virtual {}
1027 
1028     /**
1029      * @dev Returns the message sender (defaults to `msg.sender`).
1030      *
1031      * If you are writing GSN compatible contracts, you need to override this function.
1032      */
1033     function _msgSenderERC721A() internal view virtual returns (address) {
1034         return msg.sender;
1035     }
1036 
1037     /**
1038      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1039      */
1040     function _toString(uint256 value) internal pure returns (string memory ptr) {
1041         assembly {
1042             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1043             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1044             // We will need 1 32-byte word to store the length, 
1045             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1046             ptr := add(mload(0x40), 128)
1047             // Update the free memory pointer to allocate.
1048             mstore(0x40, ptr)
1049 
1050             // Cache the end of the memory to calculate the length later.
1051             let end := ptr
1052 
1053             // We write the string from the rightmost digit to the leftmost digit.
1054             // The following is essentially a do-while loop that also handles the zero case.
1055             // Costs a bit more than early returning for the zero case,
1056             // but cheaper in terms of deployment and overall runtime costs.
1057             for { 
1058                 // Initialize and perform the first pass without check.
1059                 let temp := value
1060                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1061                 ptr := sub(ptr, 1)
1062                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1063                 mstore8(ptr, add(48, mod(temp, 10)))
1064                 temp := div(temp, 10)
1065             } temp { 
1066                 // Keep dividing `temp` until zero.
1067                 temp := div(temp, 10)
1068             } { // Body of the for loop.
1069                 ptr := sub(ptr, 1)
1070                 mstore8(ptr, add(48, mod(temp, 10)))
1071             }
1072             
1073             let length := sub(end, ptr)
1074             // Move the pointer 32 bytes leftwards to make room for the length.
1075             ptr := sub(ptr, 32)
1076             // Store the length.
1077             mstore(ptr, length)
1078         }
1079     }
1080 }
1081 
1082 // File: @openzeppelin/contracts/utils/Strings.sol
1083 
1084 
1085 
1086 pragma solidity ^0.8.0;
1087 
1088 /**
1089  * @dev String operations.
1090  */
1091 library Strings {
1092     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1093 
1094     /**
1095      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1096      */
1097     function toString(uint256 value) internal pure returns (string memory) {
1098         // Inspired by OraclizeAPI's implementation - MIT licence
1099         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1100 
1101         if (value == 0) {
1102             return "0";
1103         }
1104         uint256 temp = value;
1105         uint256 digits;
1106         while (temp != 0) {
1107             digits++;
1108             temp /= 10;
1109         }
1110         bytes memory buffer = new bytes(digits);
1111         while (value != 0) {
1112             digits -= 1;
1113             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1114             value /= 10;
1115         }
1116         return string(buffer);
1117     }
1118 
1119     /**
1120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1121      */
1122     function toHexString(uint256 value) internal pure returns (string memory) {
1123         if (value == 0) {
1124             return "0x00";
1125         }
1126         uint256 temp = value;
1127         uint256 length = 0;
1128         while (temp != 0) {
1129             length++;
1130             temp >>= 8;
1131         }
1132         return toHexString(value, length);
1133     }
1134 
1135     /**
1136      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1137      */
1138     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1139         bytes memory buffer = new bytes(2 * length + 2);
1140         buffer[0] = "0";
1141         buffer[1] = "x";
1142         for (uint256 i = 2 * length + 1; i > 1; --i) {
1143             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1144             value >>= 4;
1145         }
1146         require(value == 0, "Strings: hex length insufficient");
1147         return string(buffer);
1148     }
1149 }
1150 
1151 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
1152 
1153 
1154 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
1155 
1156 pragma solidity ^0.8.0;
1157 
1158 
1159 /**
1160  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1161  *
1162  * These functions can be used to verify that a message was signed by the holder
1163  * of the private keys of a given address.
1164  */
1165 library ECDSA {
1166     enum RecoverError {
1167         NoError,
1168         InvalidSignature,
1169         InvalidSignatureLength,
1170         InvalidSignatureS,
1171         InvalidSignatureV
1172     }
1173 
1174     function _throwError(RecoverError error) private pure {
1175         if (error == RecoverError.NoError) {
1176             return; // no error: do nothing
1177         } else if (error == RecoverError.InvalidSignature) {
1178             revert("ECDSA: invalid signature");
1179         } else if (error == RecoverError.InvalidSignatureLength) {
1180             revert("ECDSA: invalid signature length");
1181         } else if (error == RecoverError.InvalidSignatureS) {
1182             revert("ECDSA: invalid signature 's' value");
1183         } else if (error == RecoverError.InvalidSignatureV) {
1184             revert("ECDSA: invalid signature 'v' value");
1185         }
1186     }
1187 
1188     /**
1189      * @dev Returns the address that signed a hashed message (`hash`) with
1190      * `signature` or error string. This address can then be used for verification purposes.
1191      *
1192      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1193      * this function rejects them by requiring the `s` value to be in the lower
1194      * half order, and the `v` value to be either 27 or 28.
1195      *
1196      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1197      * verification to be secure: it is possible to craft signatures that
1198      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1199      * this is by receiving a hash of the original message (which may otherwise
1200      * be too long), and then calling {toEthSignedMessageHash} on it.
1201      *
1202      * Documentation for signature generation:
1203      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1204      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1205      *
1206      * _Available since v4.3._
1207      */
1208     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1209         // Check the signature length
1210         // - case 65: r,s,v signature (standard)
1211         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1212         if (signature.length == 65) {
1213             bytes32 r;
1214             bytes32 s;
1215             uint8 v;
1216             // ecrecover takes the signature parameters, and the only way to get them
1217             // currently is to use assembly.
1218             assembly {
1219                 r := mload(add(signature, 0x20))
1220                 s := mload(add(signature, 0x40))
1221                 v := byte(0, mload(add(signature, 0x60)))
1222             }
1223             return tryRecover(hash, v, r, s);
1224         } else if (signature.length == 64) {
1225             bytes32 r;
1226             bytes32 vs;
1227             // ecrecover takes the signature parameters, and the only way to get them
1228             // currently is to use assembly.
1229             assembly {
1230                 r := mload(add(signature, 0x20))
1231                 vs := mload(add(signature, 0x40))
1232             }
1233             return tryRecover(hash, r, vs);
1234         } else {
1235             return (address(0), RecoverError.InvalidSignatureLength);
1236         }
1237     }
1238 
1239     /**
1240      * @dev Returns the address that signed a hashed message (`hash`) with
1241      * `signature`. This address can then be used for verification purposes.
1242      *
1243      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1244      * this function rejects them by requiring the `s` value to be in the lower
1245      * half order, and the `v` value to be either 27 or 28.
1246      *
1247      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1248      * verification to be secure: it is possible to craft signatures that
1249      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1250      * this is by receiving a hash of the original message (which may otherwise
1251      * be too long), and then calling {toEthSignedMessageHash} on it.
1252      */
1253     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1254         (address recovered, RecoverError error) = tryRecover(hash, signature);
1255         _throwError(error);
1256         return recovered;
1257     }
1258 
1259     /**
1260      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1261      *
1262      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1263      *
1264      * _Available since v4.3._
1265      */
1266     function tryRecover(
1267         bytes32 hash,
1268         bytes32 r,
1269         bytes32 vs
1270     ) internal pure returns (address, RecoverError) {
1271         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1272         uint8 v = uint8((uint256(vs) >> 255) + 27);
1273         return tryRecover(hash, v, r, s);
1274     }
1275 
1276     /**
1277      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1278      *
1279      * _Available since v4.2._
1280      */
1281     function recover(
1282         bytes32 hash,
1283         bytes32 r,
1284         bytes32 vs
1285     ) internal pure returns (address) {
1286         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1287         _throwError(error);
1288         return recovered;
1289     }
1290 
1291     /**
1292      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1293      * `r` and `s` signature fields separately.
1294      *
1295      * _Available since v4.3._
1296      */
1297     function tryRecover(
1298         bytes32 hash,
1299         uint8 v,
1300         bytes32 r,
1301         bytes32 s
1302     ) internal pure returns (address, RecoverError) {
1303         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1304         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1305         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1306         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1307         //
1308         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1309         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1310         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1311         // these malleable signatures as well.
1312         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1313             return (address(0), RecoverError.InvalidSignatureS);
1314         }
1315         if (v != 27 && v != 28) {
1316             return (address(0), RecoverError.InvalidSignatureV);
1317         }
1318 
1319         // If the signature is valid (and not malleable), return the signer address
1320         address signer = ecrecover(hash, v, r, s);
1321         if (signer == address(0)) {
1322             return (address(0), RecoverError.InvalidSignature);
1323         }
1324 
1325         return (signer, RecoverError.NoError);
1326     }
1327 
1328     /**
1329      * @dev Overload of {ECDSA-recover} that receives the `v`,
1330      * `r` and `s` signature fields separately.
1331      */
1332     function recover(
1333         bytes32 hash,
1334         uint8 v,
1335         bytes32 r,
1336         bytes32 s
1337     ) internal pure returns (address) {
1338         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1339         _throwError(error);
1340         return recovered;
1341     }
1342 
1343     /**
1344      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1345      * produces hash corresponding to the one signed with the
1346      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1347      * JSON-RPC method as part of EIP-191.
1348      *
1349      * See {recover}.
1350      */
1351     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1352         // 32 is the length in bytes of hash,
1353         // enforced by the type signature above
1354         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1355     }
1356 
1357     /**
1358      * @dev Returns an Ethereum Signed Message, created from `s`. This
1359      * produces hash corresponding to the one signed with the
1360      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1361      * JSON-RPC method as part of EIP-191.
1362      *
1363      * See {recover}.
1364      */
1365     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1366         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1367     }
1368 
1369     /**
1370      * @dev Returns an Ethereum Signed Typed Data, created from a
1371      * `domainSeparator` and a `structHash`. This produces hash corresponding
1372      * to the one signed with the
1373      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1374      * JSON-RPC method as part of EIP-712.
1375      *
1376      * See {recover}.
1377      */
1378     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1379         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1380     }
1381 }
1382 
1383 // File: @openzeppelin/contracts/utils/Context.sol
1384 
1385 
1386 
1387 pragma solidity ^0.8.0;
1388 
1389 /**
1390  * @dev Provides information about the current execution context, including the
1391  * sender of the transaction and its data. While these are generally available
1392  * via msg.sender and msg.data, they should not be accessed in such a direct
1393  * manner, since when dealing with meta-transactions the account sending and
1394  * paying for execution may not be the actual sender (as far as an application
1395  * is concerned).
1396  *
1397  * This contract is only required for intermediate, library-like contracts.
1398  */
1399 abstract contract Context {
1400     function _msgSender() internal view virtual returns (address) {
1401         return msg.sender;
1402     }
1403 
1404     function _msgData() internal view virtual returns (bytes calldata) {
1405         return msg.data;
1406     }
1407 }
1408 
1409 // File: @openzeppelin/contracts/access/Ownable.sol
1410 
1411 
1412 
1413 pragma solidity ^0.8.0;
1414 
1415 
1416 /**
1417  * @dev Contract module which provides a basic access control mechanism, where
1418  * there is an account (an owner) that can be granted exclusive access to
1419  * specific functions.
1420  *
1421  * By default, the owner account will be the one that deploys the contract. This
1422  * can later be changed with {transferOwnership}.
1423  *
1424  * This module is used through inheritance. It will make available the modifier
1425  * `onlyOwner`, which can be applied to your functions to restrict their use to
1426  * the owner.
1427  */
1428 abstract contract Ownable is Context {
1429     address private _owner;
1430 
1431     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1432 
1433     /**
1434      * @dev Initializes the contract setting the deployer as the initial owner.
1435      */
1436     constructor() {
1437         _setOwner(_msgSender());
1438     }
1439 
1440     /**
1441      * @dev Returns the address of the current owner.
1442      */
1443     function owner() public view virtual returns (address) {
1444         return _owner;
1445     }
1446 
1447     /**
1448      * @dev Throws if called by any account other than the owner.
1449      */
1450     modifier onlyOwner() {
1451         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1452         _;
1453     }
1454 
1455     /**
1456      * @dev Leaves the contract without owner. It will not be possible to call
1457      * `onlyOwner` functions anymore. Can only be called by the current owner.
1458      *
1459      * NOTE: Renouncing ownership will leave the contract without an owner,
1460      * thereby removing any functionality that is only available to the owner.
1461      */
1462     function renounceOwnership() public virtual onlyOwner {
1463         _setOwner(address(0));
1464     }
1465 
1466     /**
1467      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1468      * Can only be called by the current owner.
1469      */
1470     function transferOwnership(address newOwner) public virtual onlyOwner {
1471         require(newOwner != address(0), "Ownable: new owner is the zero address");
1472         _setOwner(newOwner);
1473     }
1474 
1475     function _setOwner(address newOwner) private {
1476         address oldOwner = _owner;
1477         _owner = newOwner;
1478         emit OwnershipTransferred(oldOwner, newOwner);
1479     }
1480 }
1481 
1482 // File: TENSHI_AKUMA.sol
1483 
1484 
1485 pragma solidity 0.8.15;
1486 
1487 
1488 
1489 
1490 
1491 contract TenshiAkuma is ERC721A, Ownable {
1492     using Strings for uint256;
1493     using ECDSA for bytes32;
1494 
1495     address private adminSigner;
1496 
1497     string private _baseTokenURI;
1498 
1499     uint256 public constant MAX_SUPPLY = 3000;
1500     uint256 public constant RESERVE = 200;
1501     uint256 public constant MAX_FIRST_PREMINT = 2;
1502     uint256 public constant MAX_PREMINT = 8;
1503     uint256 public constant MAX_PUBLIC_MINT = 8;
1504 	uint256 public reserveMinted;
1505 
1506     bool public firstRoundActive;
1507 
1508     enum SalePhase {
1509         Locked,
1510         PreMint,
1511         PublicMint
1512     }
1513 
1514     SalePhase public phase = SalePhase.Locked;
1515 
1516     mapping(address => uint256) public firstPreMintCount;
1517     mapping(address => uint256) public totalPreMintCount;
1518     mapping(address => uint256) public publicMintCount;
1519 
1520     constructor(
1521         address signer,
1522         string memory uri
1523     ) ERC721A("Tenshi Akuma", "TA") {
1524         firstRoundActive = true;
1525         adminSigner = signer;
1526         _baseTokenURI = uri;
1527     }
1528 
1529     modifier callerIsUser() {
1530         require(tx.origin == msg.sender, "The caller is another contract");
1531         _;
1532     }
1533 
1534     function preMint(uint256 _quantity, bytes calldata signature)
1535         external
1536         callerIsUser
1537     {
1538         require(phase == SalePhase.PreMint, "Allowlist sale is not active");
1539         require(recoverSigner(signature) == adminSigner, "Not on allowlist");
1540 
1541         if (firstRoundActive) {
1542             require(
1543                 firstPreMintCount[msg.sender] + _quantity <= MAX_FIRST_PREMINT,
1544                 "Exceed first round limit"
1545             );
1546             firstPreMintCount[msg.sender] += _quantity;
1547         } else {
1548             require(
1549                 totalPreMintCount[msg.sender] + _quantity <= MAX_PREMINT,
1550                 "Exceed allowlist limit"
1551             );
1552         }
1553 
1554         totalPreMintCount[msg.sender] += _quantity;
1555         _safeMint(msg.sender, _quantity);
1556     }
1557 
1558     function publicMint(uint256 _quantity) external callerIsUser {
1559         require(phase == SalePhase.PublicMint, "Public sale has not started");
1560         require(publicMintCount[msg.sender] + _quantity <= MAX_PUBLIC_MINT, "Exceed mint limit");
1561         require(totalSupply() + _quantity <= MAX_SUPPLY, "Reach max supply");
1562 
1563         publicMintCount[msg.sender] += _quantity;
1564         _safeMint(msg.sender, _quantity);
1565     }
1566 
1567     // Reserve tokens for team 
1568     function reserveMint(uint256 _quantity) external onlyOwner {
1569         require(reserveMinted + _quantity <= RESERVE, "Exceed reserve supply");
1570 
1571         reserveMinted += _quantity;
1572         _safeMint(msg.sender, _quantity);
1573     }
1574 
1575     // Verify if signed by admin signer
1576     function recoverSigner(bytes calldata signature)
1577         internal
1578         view
1579         returns (address)
1580     {
1581         return
1582             keccak256(
1583                 abi.encodePacked(
1584                     "\x19Ethereum Signed Message:\n32",
1585                     bytes32(uint256(uint160(msg.sender)))
1586                 )
1587             ).recover(signature);
1588     }
1589 
1590     // Sale phase control
1591     function setPhase(SalePhase phase_) external onlyOwner {
1592         phase = phase_;
1593     }
1594 
1595     function togglePreMintLimit() external onlyOwner {
1596         firstRoundActive = !firstRoundActive;
1597     }
1598 
1599     function setSigner(address _signer) external onlyOwner {
1600         adminSigner = _signer;
1601     }
1602 
1603     // Metadata
1604     function _baseURI() internal view virtual override returns (string memory) {
1605         return _baseTokenURI;
1606     }
1607 
1608     function setBaseTokenURI(string calldata baseURI) external onlyOwner {
1609         _baseTokenURI = baseURI;
1610     }
1611 
1612     function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1613         require(_exists(_tokenId), "URI query for nonexistent token");
1614 
1615         uint256 trueId = _tokenId + 1;
1616         return string(abi.encodePacked(_baseTokenURI, trueId.toString(), ".json"));
1617     }
1618 }