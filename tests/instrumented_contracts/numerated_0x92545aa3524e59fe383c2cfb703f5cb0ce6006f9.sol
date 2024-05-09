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
1082 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1083 
1084 
1085 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1086 
1087 pragma solidity ^0.8.0;
1088 
1089 /**
1090  * @dev Contract module that helps prevent reentrant calls to a function.
1091  *
1092  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1093  * available, which can be applied to functions to make sure there are no nested
1094  * (reentrant) calls to them.
1095  *
1096  * Note that because there is a single `nonReentrant` guard, functions marked as
1097  * `nonReentrant` may not call one another. This can be worked around by making
1098  * those functions `private`, and then adding `external` `nonReentrant` entry
1099  * points to them.
1100  *
1101  * TIP: If you would like to learn more about reentrancy and alternative ways
1102  * to protect against it, check out our blog post
1103  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1104  */
1105 abstract contract ReentrancyGuard {
1106     // Booleans are more expensive than uint256 or any type that takes up a full
1107     // word because each write operation emits an extra SLOAD to first read the
1108     // slot's contents, replace the bits taken up by the boolean, and then write
1109     // back. This is the compiler's defense against contract upgrades and
1110     // pointer aliasing, and it cannot be disabled.
1111 
1112     // The values being non-zero value makes deployment a bit more expensive,
1113     // but in exchange the refund on every call to nonReentrant will be lower in
1114     // amount. Since refunds are capped to a percentage of the total
1115     // transaction's gas, it is best to keep them low in cases like this one, to
1116     // increase the likelihood of the full refund coming into effect.
1117     uint256 private constant _NOT_ENTERED = 1;
1118     uint256 private constant _ENTERED = 2;
1119 
1120     uint256 private _status;
1121 
1122     constructor() {
1123         _status = _NOT_ENTERED;
1124     }
1125 
1126     /**
1127      * @dev Prevents a contract from calling itself, directly or indirectly.
1128      * Calling a `nonReentrant` function from another `nonReentrant`
1129      * function is not supported. It is possible to prevent this from happening
1130      * by making the `nonReentrant` function external, and making it call a
1131      * `private` function that does the actual work.
1132      */
1133     modifier nonReentrant() {
1134         // On the first call to nonReentrant, _notEntered will be true
1135         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1136 
1137         // Any calls to nonReentrant after this point will fail
1138         _status = _ENTERED;
1139 
1140         _;
1141 
1142         // By storing the original value once again, a refund is triggered (see
1143         // https://eips.ethereum.org/EIPS/eip-2200)
1144         _status = _NOT_ENTERED;
1145     }
1146 }
1147 
1148 // File: @openzeppelin/contracts/utils/Context.sol
1149 
1150 
1151 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1152 
1153 pragma solidity ^0.8.0;
1154 
1155 /**
1156  * @dev Provides information about the current execution context, including the
1157  * sender of the transaction and its data. While these are generally available
1158  * via msg.sender and msg.data, they should not be accessed in such a direct
1159  * manner, since when dealing with meta-transactions the account sending and
1160  * paying for execution may not be the actual sender (as far as an application
1161  * is concerned).
1162  *
1163  * This contract is only required for intermediate, library-like contracts.
1164  */
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
1175 // File: @openzeppelin/contracts/access/Ownable.sol
1176 
1177 
1178 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1179 
1180 pragma solidity ^0.8.0;
1181 
1182 
1183 /**
1184  * @dev Contract module which provides a basic access control mechanism, where
1185  * there is an account (an owner) that can be granted exclusive access to
1186  * specific functions.
1187  *
1188  * By default, the owner account will be the one that deploys the contract. This
1189  * can later be changed with {transferOwnership}.
1190  *
1191  * This module is used through inheritance. It will make available the modifier
1192  * `onlyOwner`, which can be applied to your functions to restrict their use to
1193  * the owner.
1194  */
1195 abstract contract Ownable is Context {
1196     address private _owner;
1197 
1198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1199 
1200     /**
1201      * @dev Initializes the contract setting the deployer as the initial owner.
1202      */
1203     constructor() {
1204         _transferOwnership(_msgSender());
1205     }
1206 
1207     /**
1208      * @dev Returns the address of the current owner.
1209      */
1210     function owner() public view virtual returns (address) {
1211         return _owner;
1212     }
1213 
1214     /**
1215      * @dev Throws if called by any account other than the owner.
1216      */
1217     modifier onlyOwner() {
1218         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1219         _;
1220     }
1221 
1222     /**
1223      * @dev Leaves the contract without owner. It will not be possible to call
1224      * `onlyOwner` functions anymore. Can only be called by the current owner.
1225      *
1226      * NOTE: Renouncing ownership will leave the contract without an owner,
1227      * thereby removing any functionality that is only available to the owner.
1228      */
1229     function renounceOwnership() public virtual onlyOwner {
1230         _transferOwnership(address(0));
1231     }
1232 
1233     /**
1234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1235      * Can only be called by the current owner.
1236      */
1237     function transferOwnership(address newOwner) public virtual onlyOwner {
1238         require(newOwner != address(0), "Ownable: new owner is the zero address");
1239         _transferOwnership(newOwner);
1240     }
1241 
1242     /**
1243      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1244      * Internal function without access restriction.
1245      */
1246     function _transferOwnership(address newOwner) internal virtual {
1247         address oldOwner = _owner;
1248         _owner = newOwner;
1249         emit OwnershipTransferred(oldOwner, newOwner);
1250     }
1251 }
1252 
1253 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1254 
1255 
1256 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 /**
1261  * @dev Interface of the ERC165 standard, as defined in the
1262  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1263  *
1264  * Implementers can declare support of contract interfaces, which can then be
1265  * queried by others ({ERC165Checker}).
1266  *
1267  * For an implementation, see {ERC165}.
1268  */
1269 interface IERC165 {
1270     /**
1271      * @dev Returns true if this contract implements the interface defined by
1272      * `interfaceId`. See the corresponding
1273      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1274      * to learn more about how these ids are created.
1275      *
1276      * This function call must use less than 30 000 gas.
1277      */
1278     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1279 }
1280 
1281 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1282 
1283 
1284 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 
1289 /**
1290  * @dev Implementation of the {IERC165} interface.
1291  *
1292  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1293  * for the additional interface id that will be supported. For example:
1294  *
1295  * ```solidity
1296  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1297  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1298  * }
1299  * ```
1300  *
1301  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1302  */
1303 abstract contract ERC165 is IERC165 {
1304     /**
1305      * @dev See {IERC165-supportsInterface}.
1306      */
1307     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1308         return interfaceId == type(IERC165).interfaceId;
1309     }
1310 }
1311 
1312 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1313 
1314 
1315 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1316 
1317 pragma solidity ^0.8.0;
1318 
1319 
1320 /**
1321  * @dev Interface for the NFT Royalty Standard.
1322  *
1323  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1324  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1325  *
1326  * _Available since v4.5._
1327  */
1328 interface IERC2981 is IERC165 {
1329     /**
1330      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1331      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1332      */
1333     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1334         external
1335         view
1336         returns (address receiver, uint256 royaltyAmount);
1337 }
1338 
1339 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1340 
1341 
1342 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1343 
1344 pragma solidity ^0.8.0;
1345 
1346 
1347 
1348 /**
1349  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1350  *
1351  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1352  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1353  *
1354  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1355  * fee is specified in basis points by default.
1356  *
1357  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1358  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1359  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1360  *
1361  * _Available since v4.5._
1362  */
1363 abstract contract ERC2981 is IERC2981, ERC165 {
1364     struct RoyaltyInfo {
1365         address receiver;
1366         uint96 royaltyFraction;
1367     }
1368 
1369     RoyaltyInfo private _defaultRoyaltyInfo;
1370     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1371 
1372     /**
1373      * @dev See {IERC165-supportsInterface}.
1374      */
1375     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1376         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1377     }
1378 
1379     /**
1380      * @inheritdoc IERC2981
1381      */
1382     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1383         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1384 
1385         if (royalty.receiver == address(0)) {
1386             royalty = _defaultRoyaltyInfo;
1387         }
1388 
1389         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1390 
1391         return (royalty.receiver, royaltyAmount);
1392     }
1393 
1394     /**
1395      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1396      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1397      * override.
1398      */
1399     function _feeDenominator() internal pure virtual returns (uint96) {
1400         return 10000;
1401     }
1402 
1403     /**
1404      * @dev Sets the royalty information that all ids in this contract will default to.
1405      *
1406      * Requirements:
1407      *
1408      * - `receiver` cannot be the zero address.
1409      * - `feeNumerator` cannot be greater than the fee denominator.
1410      */
1411     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1412         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1413         require(receiver != address(0), "ERC2981: invalid receiver");
1414 
1415         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1416     }
1417 
1418     /**
1419      * @dev Removes default royalty information.
1420      */
1421     function _deleteDefaultRoyalty() internal virtual {
1422         delete _defaultRoyaltyInfo;
1423     }
1424 
1425     /**
1426      * @dev Sets the royalty information for a specific token id, overriding the global default.
1427      *
1428      * Requirements:
1429      *
1430      * - `receiver` cannot be the zero address.
1431      * - `feeNumerator` cannot be greater than the fee denominator.
1432      */
1433     function _setTokenRoyalty(
1434         uint256 tokenId,
1435         address receiver,
1436         uint96 feeNumerator
1437     ) internal virtual {
1438         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1439         require(receiver != address(0), "ERC2981: Invalid parameters");
1440 
1441         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1442     }
1443 
1444     /**
1445      * @dev Resets royalty information for the token id back to the global default.
1446      */
1447     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1448         delete _tokenRoyaltyInfo[tokenId];
1449     }
1450 }
1451 
1452 // File: contracts/MotherFuckerNFTees.sol
1453 
1454 //SPDX-License-Identifier: MIT
1455 
1456 pragma solidity ^0.8.0;
1457 
1458 
1459 
1460 
1461 
1462 contract MotherFuckerNFTees is Ownable, ERC721A, ERC2981, ReentrancyGuard {
1463     uint96 public ROYALTY_PERCENTAGE = 600;
1464 
1465     uint256 public MAX_FREE_PER_WALLET = 1;
1466     uint256 public MAX_SUPPLY = 5000;
1467     uint256 public MAX_TX_PER_WALLET = 5;
1468     uint256 public SALE_PRICE = 0.003 ether;
1469 
1470     bool public IS_SALE_ACTIVE = false;
1471     string internal baseURI = "";
1472 
1473     modifier isUser() {
1474         require(tx.origin == msg.sender, "The caller is another contract");
1475         _;
1476     }
1477 
1478     constructor() ERC721A("MotherFuckerNFTees", "MFN") {
1479         _setDefaultRoyalty(owner(), ROYALTY_PERCENTAGE);
1480     }
1481 
1482     function setIsSaleActive(bool isActive) external virtual onlyOwner {
1483         IS_SALE_ACTIVE = isActive;
1484     }
1485 
1486     function withdraw() external onlyOwner nonReentrant {
1487         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1488 
1489         require(success, "Transfer failed.");
1490     }
1491 
1492     function getNumberMinted(address addr) external view virtual returns (uint256){
1493 
1494         return _numberMinted(addr);
1495     }
1496 
1497     function setBaseURI(string memory newURI) external virtual onlyOwner {
1498         baseURI = newURI;
1499     }
1500 
1501     function _baseURI() internal view virtual override returns (string memory) {
1502         return baseURI;
1503     }
1504 
1505     function supportsInterface(bytes4 interfaceId)
1506         public
1507         view
1508         virtual
1509         override(ERC721A, ERC2981)
1510         returns (bool)
1511     {
1512         return
1513             ERC721A.supportsInterface(interfaceId) ||
1514             ERC2981.supportsInterface(interfaceId) ||
1515             super.supportsInterface(interfaceId);
1516     }
1517 
1518     function privateMint(address buyerAddress, uint256 quantity)
1519         external
1520         onlyOwner
1521         nonReentrant
1522     {
1523         require(totalSupply() + quantity <= MAX_SUPPLY, "Max supply reached");
1524 
1525         _mint(buyerAddress, quantity);
1526     }
1527 
1528     function mint(uint256 quantity)
1529         public
1530         payable
1531         virtual
1532         nonReentrant
1533         isUser
1534     {
1535         uint256 salePrice;
1536 
1537         require(IS_SALE_ACTIVE, "Mint not active");
1538 
1539         require(totalSupply() + quantity <= MAX_SUPPLY, "Max supply reached");
1540 
1541         if (_numberMinted(msg.sender) > 0) {
1542             salePrice = SALE_PRICE * (quantity);
1543         } else {
1544             salePrice = SALE_PRICE * (quantity - MAX_FREE_PER_WALLET);
1545         }
1546 
1547         require(msg.value >= salePrice, "Insufficient funds");
1548 
1549         require(
1550             _numberMinted(msg.sender) + quantity <= MAX_TX_PER_WALLET,
1551             "Exceeded tx limit"
1552         );
1553 
1554         _mint(msg.sender, quantity);
1555     }
1556 }