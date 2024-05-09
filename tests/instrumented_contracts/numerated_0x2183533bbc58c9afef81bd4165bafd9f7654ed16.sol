1 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
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
264 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
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
430         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
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
707         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
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
767         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
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
824         address approvedAddress = _tokenApprovals[tokenId];
825 
826         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
827             isApprovedForAll(from, _msgSenderERC721A()) ||
828             approvedAddress == _msgSenderERC721A());
829 
830         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
831         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
832 
833         _beforeTokenTransfers(from, to, tokenId, 1);
834 
835         // Clear approvals from the previous owner.
836         if (_addressToUint256(approvedAddress) != 0) {
837             delete _tokenApprovals[tokenId];
838         }
839 
840         // Underflow of the sender's balance is impossible because we check for
841         // ownership above and the recipient's balance can't realistically overflow.
842         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
843         unchecked {
844             // We can directly increment and decrement the balances.
845             --_packedAddressData[from]; // Updates: `balance -= 1`.
846             ++_packedAddressData[to]; // Updates: `balance += 1`.
847 
848             // Updates:
849             // - `address` to the next owner.
850             // - `startTimestamp` to the timestamp of transfering.
851             // - `burned` to `false`.
852             // - `nextInitialized` to `true`.
853             _packedOwnerships[tokenId] =
854                 _addressToUint256(to) |
855                 (block.timestamp << BITPOS_START_TIMESTAMP) |
856                 BITMASK_NEXT_INITIALIZED;
857 
858             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
859             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
860                 uint256 nextTokenId = tokenId + 1;
861                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
862                 if (_packedOwnerships[nextTokenId] == 0) {
863                     // If the next slot is within bounds.
864                     if (nextTokenId != _currentIndex) {
865                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
866                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
867                     }
868                 }
869             }
870         }
871 
872         emit Transfer(from, to, tokenId);
873         _afterTokenTransfers(from, to, tokenId, 1);
874     }
875 
876     /**
877      * @dev Equivalent to `_burn(tokenId, false)`.
878      */
879     function _burn(uint256 tokenId) internal virtual {
880         _burn(tokenId, false);
881     }
882 
883     /**
884      * @dev Destroys `tokenId`.
885      * The approval is cleared when the token is burned.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
894         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
895 
896         address from = address(uint160(prevOwnershipPacked));
897         address approvedAddress = _tokenApprovals[tokenId];
898 
899         if (approvalCheck) {
900             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
901                 isApprovedForAll(from, _msgSenderERC721A()) ||
902                 approvedAddress == _msgSenderERC721A());
903 
904             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
905         }
906 
907         _beforeTokenTransfers(from, address(0), tokenId, 1);
908 
909         // Clear approvals from the previous owner.
910         if (_addressToUint256(approvedAddress) != 0) {
911             delete _tokenApprovals[tokenId];
912         }
913 
914         // Underflow of the sender's balance is impossible because we check for
915         // ownership above and the recipient's balance can't realistically overflow.
916         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
917         unchecked {
918             // Updates:
919             // - `balance -= 1`.
920             // - `numberBurned += 1`.
921             //
922             // We can directly decrement the balance, and increment the number burned.
923             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
924             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
925 
926             // Updates:
927             // - `address` to the last owner.
928             // - `startTimestamp` to the timestamp of burning.
929             // - `burned` to `true`.
930             // - `nextInitialized` to `true`.
931             _packedOwnerships[tokenId] =
932                 _addressToUint256(from) |
933                 (block.timestamp << BITPOS_START_TIMESTAMP) |
934                 BITMASK_BURNED |
935                 BITMASK_NEXT_INITIALIZED;
936 
937             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
938             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
939                 uint256 nextTokenId = tokenId + 1;
940                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
941                 if (_packedOwnerships[nextTokenId] == 0) {
942                     // If the next slot is within bounds.
943                     if (nextTokenId != _currentIndex) {
944                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
945                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
946                     }
947                 }
948             }
949         }
950 
951         emit Transfer(from, address(0), tokenId);
952         _afterTokenTransfers(from, address(0), tokenId, 1);
953 
954         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
955         unchecked {
956             _burnCounter++;
957         }
958     }
959 
960     /**
961      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
962      *
963      * @param from address representing the previous owner of the given token ID
964      * @param to target address that will receive the tokens
965      * @param tokenId uint256 ID of the token to be transferred
966      * @param _data bytes optional data to send along with the call
967      * @return bool whether the call correctly returned the expected magic value
968      */
969     function _checkContractOnERC721Received(
970         address from,
971         address to,
972         uint256 tokenId,
973         bytes memory _data
974     ) private returns (bool) {
975         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
976             bytes4 retval
977         ) {
978             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
979         } catch (bytes memory reason) {
980             if (reason.length == 0) {
981                 revert TransferToNonERC721ReceiverImplementer();
982             } else {
983                 assembly {
984                     revert(add(32, reason), mload(reason))
985                 }
986             }
987         }
988     }
989 
990     /**
991      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
992      * And also called before burning one token.
993      *
994      * startTokenId - the first token id to be transferred
995      * quantity - the amount to be transferred
996      *
997      * Calling conditions:
998      *
999      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1000      * transferred to `to`.
1001      * - When `from` is zero, `tokenId` will be minted for `to`.
1002      * - When `to` is zero, `tokenId` will be burned by `from`.
1003      * - `from` and `to` are never both zero.
1004      */
1005     function _beforeTokenTransfers(
1006         address from,
1007         address to,
1008         uint256 startTokenId,
1009         uint256 quantity
1010     ) internal virtual {}
1011 
1012     /**
1013      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1014      * minting.
1015      * And also called after one token has been burned.
1016      *
1017      * startTokenId - the first token id to be transferred
1018      * quantity - the amount to be transferred
1019      *
1020      * Calling conditions:
1021      *
1022      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1023      * transferred to `to`.
1024      * - When `from` is zero, `tokenId` has been minted for `to`.
1025      * - When `to` is zero, `tokenId` has been burned by `from`.
1026      * - `from` and `to` are never both zero.
1027      */
1028     function _afterTokenTransfers(
1029         address from,
1030         address to,
1031         uint256 startTokenId,
1032         uint256 quantity
1033     ) internal virtual {}
1034 
1035     /**
1036      * @dev Returns the message sender (defaults to `msg.sender`).
1037      *
1038      * If you are writing GSN compatible contracts, you need to override this function.
1039      */
1040     function _msgSenderERC721A() internal view virtual returns (address) {
1041         return msg.sender;
1042     }
1043 
1044     /**
1045      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1046      */
1047     function _toString(uint256 value) internal pure returns (string memory ptr) {
1048         assembly {
1049             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1050             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1051             // We will need 1 32-byte word to store the length,
1052             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1053             ptr := add(mload(0x40), 128)
1054             // Update the free memory pointer to allocate.
1055             mstore(0x40, ptr)
1056 
1057             // Cache the end of the memory to calculate the length later.
1058             let end := ptr
1059 
1060             // We write the string from the rightmost digit to the leftmost digit.
1061             // The following is essentially a do-while loop that also handles the zero case.
1062             // Costs a bit more than early returning for the zero case,
1063             // but cheaper in terms of deployment and overall runtime costs.
1064             for {
1065                 // Initialize and perform the first pass without check.
1066                 let temp := value
1067                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1068                 ptr := sub(ptr, 1)
1069                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1070                 mstore8(ptr, add(48, mod(temp, 10)))
1071                 temp := div(temp, 10)
1072             } temp {
1073                 // Keep dividing `temp` until zero.
1074                 temp := div(temp, 10)
1075             } { // Body of the for loop.
1076                 ptr := sub(ptr, 1)
1077                 mstore8(ptr, add(48, mod(temp, 10)))
1078             }
1079 
1080             let length := sub(end, ptr)
1081             // Move the pointer 32 bytes leftwards to make room for the length.
1082             ptr := sub(ptr, 32)
1083             // Store the length.
1084             mstore(ptr, length)
1085         }
1086     }
1087 }
1088 
1089 // File: @openzeppelin/contracts/utils/Strings.sol
1090 
1091 
1092 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 /**
1097  * @dev String operations.
1098  */
1099 library Strings {
1100     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1101 
1102     /**
1103      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1104      */
1105     function toString(uint256 value) internal pure returns (string memory) {
1106         // Inspired by OraclizeAPI's implementation - MIT licence
1107         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1108 
1109         if (value == 0) {
1110             return "0";
1111         }
1112         uint256 temp = value;
1113         uint256 digits;
1114         while (temp != 0) {
1115             digits++;
1116             temp /= 10;
1117         }
1118         bytes memory buffer = new bytes(digits);
1119         while (value != 0) {
1120             digits -= 1;
1121             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1122             value /= 10;
1123         }
1124         return string(buffer);
1125     }
1126 
1127     /**
1128      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1129      */
1130     function toHexString(uint256 value) internal pure returns (string memory) {
1131         if (value == 0) {
1132             return "0x00";
1133         }
1134         uint256 temp = value;
1135         uint256 length = 0;
1136         while (temp != 0) {
1137             length++;
1138             temp >>= 8;
1139         }
1140         return toHexString(value, length);
1141     }
1142 
1143     /**
1144      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1145      */
1146     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1147         bytes memory buffer = new bytes(2 * length + 2);
1148         buffer[0] = "0";
1149         buffer[1] = "x";
1150         for (uint256 i = 2 * length + 1; i > 1; --i) {
1151             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1152             value >>= 4;
1153         }
1154         require(value == 0, "Strings: hex length insufficient");
1155         return string(buffer);
1156     }
1157 }
1158 
1159 // File: @openzeppelin/contracts/utils/Context.sol
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
1186 // File: @openzeppelin/contracts/access/Ownable.sol
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
1264 // File: MakeItMakeSense.sol
1265 
1266 
1267 pragma solidity 0.8.14;
1268 
1269 
1270 
1271 
1272 contract MakeItMakeSense is ERC721A, Ownable {
1273     using Strings for uint256;
1274 
1275     string internal _baseTokenURI;
1276 
1277     uint256 internal _reserved;
1278 
1279     bool public mintActive = true;
1280 
1281     mapping(address => bool) public minted;
1282 
1283     uint256 public constant MAX_SUPPLY = 5295;
1284     uint256 public constant MAX_RESERVED_AMOUNT = 500;
1285 
1286     constructor(string memory baseURI) ERC721A("MakeItMakeSense", "MIMS") {
1287         _baseTokenURI = baseURI;
1288     }
1289 
1290     function _baseURI() internal view virtual override returns (string memory) {
1291         return _baseTokenURI;
1292     }
1293 
1294     function setBaseURI(string memory URI) public onlyOwner {
1295         _baseTokenURI = URI;
1296     }
1297 
1298     function flipMintStatus() public onlyOwner {
1299         mintActive = !mintActive;
1300     }
1301 
1302     function mint(uint256 amount) external payable {
1303         require(mintActive, "Mint not active");
1304         require(totalSupply() + amount <= MAX_SUPPLY, "Would exceed maximum supply of tokens");
1305         require(!minted[msg.sender], "Wallet already minted one");
1306 
1307         _safeMint(msg.sender, amount);
1308         minted[msg.sender] = true;
1309     }
1310 
1311     function reserve(address to, uint256 amount) external onlyOwner {
1312         require(_reserved + amount <= MAX_RESERVED_AMOUNT, "Would exceed max reserved amount");
1313         require(totalSupply() + amount <= MAX_SUPPLY, "Would exceed max supply");
1314 
1315         _safeMint(to, amount);
1316         _reserved += amount;
1317     }
1318 
1319     function withdraw(address recipient) external onlyOwner {
1320         (bool success, ) = recipient.call{value: address(this).balance}("");
1321         require(success, "Withdraw failed");
1322     }
1323 }