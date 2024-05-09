1 // File: https://github.com/chiru-labs/ERC721A/blob/v4.0.0/contracts/IERC721A.sol
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
264 // File: https://github.com/chiru-labs/ERC721A/blob/v4.0.0/contracts/ERC721A.sol
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
1082 // File: https://github.com/chiru-labs/ERC721A/blob/v4.0.0/contracts/extensions/IERC721AQueryable.sol
1083 
1084 
1085 // ERC721A Contracts v4.0.0
1086 // Creator: Chiru Labs
1087 
1088 pragma solidity ^0.8.4;
1089 
1090 
1091 /**
1092  * @dev Interface of an ERC721AQueryable compliant contract.
1093  */
1094 interface IERC721AQueryable is IERC721A {
1095     /**
1096      * Invalid query range (`start` >= `stop`).
1097      */
1098     error InvalidQueryRange();
1099 
1100     /**
1101      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1102      *
1103      * If the `tokenId` is out of bounds:
1104      *   - `addr` = `address(0)`
1105      *   - `startTimestamp` = `0`
1106      *   - `burned` = `false`
1107      *
1108      * If the `tokenId` is burned:
1109      *   - `addr` = `<Address of owner before token was burned>`
1110      *   - `startTimestamp` = `<Timestamp when token was burned>`
1111      *   - `burned = `true`
1112      *
1113      * Otherwise:
1114      *   - `addr` = `<Address of owner>`
1115      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1116      *   - `burned = `false`
1117      */
1118     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1119 
1120     /**
1121      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1122      * See {ERC721AQueryable-explicitOwnershipOf}
1123      */
1124     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1125 
1126     /**
1127      * @dev Returns an array of token IDs owned by `owner`,
1128      * in the range [`start`, `stop`)
1129      * (i.e. `start <= tokenId < stop`).
1130      *
1131      * This function allows for tokens to be queried if the collection
1132      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1133      *
1134      * Requirements:
1135      *
1136      * - `start` < `stop`
1137      */
1138     function tokensOfOwnerIn(
1139         address owner,
1140         uint256 start,
1141         uint256 stop
1142     ) external view returns (uint256[] memory);
1143 
1144     /**
1145      * @dev Returns an array of token IDs owned by `owner`.
1146      *
1147      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1148      * It is meant to be called off-chain.
1149      *
1150      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1151      * multiple smaller scans if the collection is large enough to cause
1152      * an out-of-gas error (10K pfp collections should be fine).
1153      */
1154     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1155 }
1156 
1157 // File: https://github.com/chiru-labs/ERC721A/blob/v4.0.0/contracts/extensions/ERC721AQueryable.sol
1158 
1159 
1160 // ERC721A Contracts v4.0.0
1161 // Creator: Chiru Labs
1162 
1163 pragma solidity ^0.8.4;
1164 
1165 
1166 
1167 /**
1168  * @title ERC721A Queryable
1169  * @dev ERC721A subclass with convenience query functions.
1170  */
1171 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1172     /**
1173      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1174      *
1175      * If the `tokenId` is out of bounds:
1176      *   - `addr` = `address(0)`
1177      *   - `startTimestamp` = `0`
1178      *   - `burned` = `false`
1179      *
1180      * If the `tokenId` is burned:
1181      *   - `addr` = `<Address of owner before token was burned>`
1182      *   - `startTimestamp` = `<Timestamp when token was burned>`
1183      *   - `burned = `true`
1184      *
1185      * Otherwise:
1186      *   - `addr` = `<Address of owner>`
1187      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1188      *   - `burned = `false`
1189      */
1190     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1191         TokenOwnership memory ownership;
1192         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1193             return ownership;
1194         }
1195         ownership = _ownershipAt(tokenId);
1196         if (ownership.burned) {
1197             return ownership;
1198         }
1199         return _ownershipOf(tokenId);
1200     }
1201 
1202     /**
1203      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1204      * See {ERC721AQueryable-explicitOwnershipOf}
1205      */
1206     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1207         unchecked {
1208             uint256 tokenIdsLength = tokenIds.length;
1209             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1210             for (uint256 i; i != tokenIdsLength; ++i) {
1211                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1212             }
1213             return ownerships;
1214         }
1215     }
1216 
1217     /**
1218      * @dev Returns an array of token IDs owned by `owner`,
1219      * in the range [`start`, `stop`)
1220      * (i.e. `start <= tokenId < stop`).
1221      *
1222      * This function allows for tokens to be queried if the collection
1223      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1224      *
1225      * Requirements:
1226      *
1227      * - `start` < `stop`
1228      */
1229     function tokensOfOwnerIn(
1230         address owner,
1231         uint256 start,
1232         uint256 stop
1233     ) external view override returns (uint256[] memory) {
1234         unchecked {
1235             if (start >= stop) revert InvalidQueryRange();
1236             uint256 tokenIdsIdx;
1237             uint256 stopLimit = _nextTokenId();
1238             // Set `start = max(start, _startTokenId())`.
1239             if (start < _startTokenId()) {
1240                 start = _startTokenId();
1241             }
1242             // Set `stop = min(stop, stopLimit)`.
1243             if (stop > stopLimit) {
1244                 stop = stopLimit;
1245             }
1246             uint256 tokenIdsMaxLength = balanceOf(owner);
1247             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1248             // to cater for cases where `balanceOf(owner)` is too big.
1249             if (start < stop) {
1250                 uint256 rangeLength = stop - start;
1251                 if (rangeLength < tokenIdsMaxLength) {
1252                     tokenIdsMaxLength = rangeLength;
1253                 }
1254             } else {
1255                 tokenIdsMaxLength = 0;
1256             }
1257             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1258             if (tokenIdsMaxLength == 0) {
1259                 return tokenIds;
1260             }
1261             // We need to call `explicitOwnershipOf(start)`,
1262             // because the slot at `start` may not be initialized.
1263             TokenOwnership memory ownership = explicitOwnershipOf(start);
1264             address currOwnershipAddr;
1265             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1266             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1267             if (!ownership.burned) {
1268                 currOwnershipAddr = ownership.addr;
1269             }
1270             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1271                 ownership = _ownershipAt(i);
1272                 if (ownership.burned) {
1273                     continue;
1274                 }
1275                 if (ownership.addr != address(0)) {
1276                     currOwnershipAddr = ownership.addr;
1277                 }
1278                 if (currOwnershipAddr == owner) {
1279                     tokenIds[tokenIdsIdx++] = i;
1280                 }
1281             }
1282             // Downsize the array to fit.
1283             assembly {
1284                 mstore(tokenIds, tokenIdsIdx)
1285             }
1286             return tokenIds;
1287         }
1288     }
1289 
1290     /**
1291      * @dev Returns an array of token IDs owned by `owner`.
1292      *
1293      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1294      * It is meant to be called off-chain.
1295      *
1296      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1297      * multiple smaller scans if the collection is large enough to cause
1298      * an out-of-gas error (10K pfp collections should be fine).
1299      */
1300     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1301         unchecked {
1302             uint256 tokenIdsIdx;
1303             address currOwnershipAddr;
1304             uint256 tokenIdsLength = balanceOf(owner);
1305             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1306             TokenOwnership memory ownership;
1307             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1308                 ownership = _ownershipAt(i);
1309                 if (ownership.burned) {
1310                     continue;
1311                 }
1312                 if (ownership.addr != address(0)) {
1313                     currOwnershipAddr = ownership.addr;
1314                 }
1315                 if (currOwnershipAddr == owner) {
1316                     tokenIds[tokenIdsIdx++] = i;
1317                 }
1318             }
1319             return tokenIds;
1320         }
1321     }
1322 }
1323 
1324 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1325 
1326 
1327 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1328 
1329 pragma solidity ^0.8.0;
1330 
1331 /**
1332  * @dev Interface of the ERC165 standard, as defined in the
1333  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1334  *
1335  * Implementers can declare support of contract interfaces, which can then be
1336  * queried by others ({ERC165Checker}).
1337  *
1338  * For an implementation, see {ERC165}.
1339  */
1340 interface IERC165 {
1341     /**
1342      * @dev Returns true if this contract implements the interface defined by
1343      * `interfaceId`. See the corresponding
1344      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1345      * to learn more about how these ids are created.
1346      *
1347      * This function call must use less than 30 000 gas.
1348      */
1349     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1350 }
1351 
1352 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1353 
1354 
1355 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1356 
1357 pragma solidity ^0.8.0;
1358 
1359 
1360 /**
1361  * @dev Required interface of an ERC721 compliant contract.
1362  */
1363 interface IERC721 is IERC165 {
1364     /**
1365      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1366      */
1367     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1368 
1369     /**
1370      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1371      */
1372     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1373 
1374     /**
1375      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1376      */
1377     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1378 
1379     /**
1380      * @dev Returns the number of tokens in ``owner``'s account.
1381      */
1382     function balanceOf(address owner) external view returns (uint256 balance);
1383 
1384     /**
1385      * @dev Returns the owner of the `tokenId` token.
1386      *
1387      * Requirements:
1388      *
1389      * - `tokenId` must exist.
1390      */
1391     function ownerOf(uint256 tokenId) external view returns (address owner);
1392 
1393     /**
1394      * @dev Safely transfers `tokenId` token from `from` to `to`.
1395      *
1396      * Requirements:
1397      *
1398      * - `from` cannot be the zero address.
1399      * - `to` cannot be the zero address.
1400      * - `tokenId` token must exist and be owned by `from`.
1401      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1402      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1403      *
1404      * Emits a {Transfer} event.
1405      */
1406     function safeTransferFrom(
1407         address from,
1408         address to,
1409         uint256 tokenId,
1410         bytes calldata data
1411     ) external;
1412 
1413     /**
1414      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1415      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1416      *
1417      * Requirements:
1418      *
1419      * - `from` cannot be the zero address.
1420      * - `to` cannot be the zero address.
1421      * - `tokenId` token must exist and be owned by `from`.
1422      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1423      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1424      *
1425      * Emits a {Transfer} event.
1426      */
1427     function safeTransferFrom(
1428         address from,
1429         address to,
1430         uint256 tokenId
1431     ) external;
1432 
1433     /**
1434      * @dev Transfers `tokenId` token from `from` to `to`.
1435      *
1436      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1437      *
1438      * Requirements:
1439      *
1440      * - `from` cannot be the zero address.
1441      * - `to` cannot be the zero address.
1442      * - `tokenId` token must be owned by `from`.
1443      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1444      *
1445      * Emits a {Transfer} event.
1446      */
1447     function transferFrom(
1448         address from,
1449         address to,
1450         uint256 tokenId
1451     ) external;
1452 
1453     /**
1454      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1455      * The approval is cleared when the token is transferred.
1456      *
1457      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1458      *
1459      * Requirements:
1460      *
1461      * - The caller must own the token or be an approved operator.
1462      * - `tokenId` must exist.
1463      *
1464      * Emits an {Approval} event.
1465      */
1466     function approve(address to, uint256 tokenId) external;
1467 
1468     /**
1469      * @dev Approve or remove `operator` as an operator for the caller.
1470      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1471      *
1472      * Requirements:
1473      *
1474      * - The `operator` cannot be the caller.
1475      *
1476      * Emits an {ApprovalForAll} event.
1477      */
1478     function setApprovalForAll(address operator, bool _approved) external;
1479 
1480     /**
1481      * @dev Returns the account approved for `tokenId` token.
1482      *
1483      * Requirements:
1484      *
1485      * - `tokenId` must exist.
1486      */
1487     function getApproved(uint256 tokenId) external view returns (address operator);
1488 
1489     /**
1490      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1491      *
1492      * See {setApprovalForAll}
1493      */
1494     function isApprovedForAll(address owner, address operator) external view returns (bool);
1495 }
1496 
1497 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1498 
1499 
1500 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1501 
1502 pragma solidity ^0.8.0;
1503 
1504 
1505 /**
1506  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1507  * @dev See https://eips.ethereum.org/EIPS/eip-721
1508  */
1509 interface IERC721Metadata is IERC721 {
1510     /**
1511      * @dev Returns the token collection name.
1512      */
1513     function name() external view returns (string memory);
1514 
1515     /**
1516      * @dev Returns the token collection symbol.
1517      */
1518     function symbol() external view returns (string memory);
1519 
1520     /**
1521      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1522      */
1523     function tokenURI(uint256 tokenId) external view returns (string memory);
1524 }
1525 
1526 // File: @openzeppelin/contracts/utils/Context.sol
1527 
1528 
1529 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1530 
1531 pragma solidity ^0.8.0;
1532 
1533 /**
1534  * @dev Provides information about the current execution context, including the
1535  * sender of the transaction and its data. While these are generally available
1536  * via msg.sender and msg.data, they should not be accessed in such a direct
1537  * manner, since when dealing with meta-transactions the account sending and
1538  * paying for execution may not be the actual sender (as far as an application
1539  * is concerned).
1540  *
1541  * This contract is only required for intermediate, library-like contracts.
1542  */
1543 abstract contract Context {
1544     function _msgSender() internal view virtual returns (address) {
1545         return msg.sender;
1546     }
1547 
1548     function _msgData() internal view virtual returns (bytes calldata) {
1549         return msg.data;
1550     }
1551 }
1552 
1553 // File: @openzeppelin/contracts/access/Ownable.sol
1554 
1555 
1556 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1557 
1558 pragma solidity ^0.8.0;
1559 
1560 
1561 /**
1562  * @dev Contract module which provides a basic access control mechanism, where
1563  * there is an account (an owner) that can be granted exclusive access to
1564  * specific functions.
1565  *
1566  * By default, the owner account will be the one that deploys the contract. This
1567  * can later be changed with {transferOwnership}.
1568  *
1569  * This module is used through inheritance. It will make available the modifier
1570  * `onlyOwner`, which can be applied to your functions to restrict their use to
1571  * the owner.
1572  */
1573 abstract contract Ownable is Context {
1574     address private _owner;
1575 
1576     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1577 
1578     /**
1579      * @dev Initializes the contract setting the deployer as the initial owner.
1580      */
1581     constructor() {
1582         _transferOwnership(_msgSender());
1583     }
1584 
1585     /**
1586      * @dev Returns the address of the current owner.
1587      */
1588     function owner() public view virtual returns (address) {
1589         return _owner;
1590     }
1591 
1592     /**
1593      * @dev Throws if called by any account other than the owner.
1594      */
1595     modifier onlyOwner() {
1596         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1597         _;
1598     }
1599 
1600     /**
1601      * @dev Leaves the contract without owner. It will not be possible to call
1602      * `onlyOwner` functions anymore. Can only be called by the current owner.
1603      *
1604      * NOTE: Renouncing ownership will leave the contract without an owner,
1605      * thereby removing any functionality that is only available to the owner.
1606      */
1607     function renounceOwnership() public virtual onlyOwner {
1608         _transferOwnership(address(0));
1609     }
1610 
1611     /**
1612      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1613      * Can only be called by the current owner.
1614      */
1615     function transferOwnership(address newOwner) public virtual onlyOwner {
1616         require(newOwner != address(0), "Ownable: new owner is the zero address");
1617         _transferOwnership(newOwner);
1618     }
1619 
1620     /**
1621      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1622      * Internal function without access restriction.
1623      */
1624     function _transferOwnership(address newOwner) internal virtual {
1625         address oldOwner = _owner;
1626         _owner = newOwner;
1627         emit OwnershipTransferred(oldOwner, newOwner);
1628     }
1629 }
1630 
1631 // File: GoblinGame.sol
1632 
1633 
1634 pragma solidity 0.8.14;
1635 
1636 
1637 
1638 
1639 interface IDuel {
1640     function isDead(uint256 id) external view returns (bool);
1641 
1642     function tokenTiers(uint256 id) external view returns (uint256);
1643 }
1644 
1645 contract GoblinGame is ERC721AQueryable, Ownable {
1646     IDuel public duel;
1647 
1648     string internal _baseTokenURI;
1649     string internal _unrevealedURI;
1650 
1651     uint256 internal _reserved;
1652 
1653     bool public revealed;
1654     bool public mintActive;
1655 
1656     mapping(address => bool) public minted;
1657 
1658     uint256 public constant MAX_RESERVED_AMOUNT = 500;
1659     uint256 public constant MAX_TOTAL_SUPPLY = 9999;
1660 
1661     constructor(string memory unrevealedURI) ERC721A("GoblinGame", "GOBLIN") {
1662         _unrevealedURI = unrevealedURI;
1663     }
1664 
1665     // URI FUNCTIONS
1666 
1667     function _baseURI() internal view virtual override returns (string memory) {
1668         return _baseTokenURI;
1669     }
1670 
1671     function tokenURI(uint256 tokenId) public view virtual override(IERC721A, ERC721A) returns (string memory) {
1672         if (!revealed) {
1673             return _unrevealedURI;
1674         }
1675 
1676         string memory baseURI = _baseURI();
1677         if (address(duel) == address(0)) {
1678             return string(abi.encodePacked(baseURI, _toString(tokenId), "-0"));
1679         }
1680 
1681         if (duel.isDead(tokenId)) {
1682             return _unrevealedURI;
1683         }
1684 
1685         uint256 level = duel.tokenTiers(tokenId);
1686         return string(abi.encodePacked(baseURI, _toString(tokenId), "-", _toString(level)));
1687     }
1688 
1689     // OWNER FUNCTIONS
1690 
1691     function setBaseURI(string calldata baseURI) external onlyOwner {
1692         _baseTokenURI = baseURI;
1693     }
1694 
1695     function setUnrevealedURI(string calldata unrevealedURI) external onlyOwner {
1696         _unrevealedURI = unrevealedURI;
1697     }
1698 
1699     function setDuel(address _duel) external onlyOwner {
1700         duel = IDuel(_duel);
1701     }
1702 
1703     function flipMintStatus() public onlyOwner {
1704         mintActive = !mintActive;
1705     }
1706 
1707     function flipReveal() public onlyOwner {
1708         revealed = !revealed;
1709     }
1710 
1711     function withdraw() external onlyOwner {
1712         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1713         require(success, "Withdraw failed");
1714     }
1715 
1716     // MINTING FUNCTIONS
1717 
1718     function mint() external payable {
1719         require(mintActive, "Public mint not active");
1720         require(msg.sender == tx.origin, "Caller not allowed");
1721         require(!minted[msg.sender], "Wallet already minted one");
1722         require(totalSupply() < MAX_TOTAL_SUPPLY, "Would exceed max supply");
1723 
1724         _safeMint(msg.sender, 1);
1725         minted[msg.sender] = true;
1726     }
1727 
1728     // reserves 'amount' NFTs minted directly to a specified wallet
1729     function reserve(address to, uint256 amount) external onlyOwner {
1730         require(_reserved + amount <= MAX_RESERVED_AMOUNT, "Would exceed max reserved amount");
1731         require(amount + totalSupply() <= MAX_TOTAL_SUPPLY, "Would exceed max supply");
1732         
1733         _safeMint(to, amount);
1734         _reserved += amount;
1735     }
1736 }