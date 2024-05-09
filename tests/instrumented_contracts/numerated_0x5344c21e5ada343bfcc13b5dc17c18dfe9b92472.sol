1 // SPDX-License-Identifier: MIT     
2 // ERC721A Contracts v3.3.0
3 // Creator: Chiru Labs
4 
5 // Art handcrafted by Eebandlee
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
267 // ERC721A Contracts v3.3.0
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
1082 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1083 
1084 
1085 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1086 
1087 pragma solidity ^0.8.0;
1088 
1089 /**
1090  * @dev String operations.
1091  */
1092 library Strings {
1093     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1094     uint8 private constant _ADDRESS_LENGTH = 20;
1095 
1096     /**
1097      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1098      */
1099     function toString(uint256 value) internal pure returns (string memory) {
1100         // Inspired by OraclizeAPI's implementation - MIT licence
1101         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1102 
1103         if (value == 0) {
1104             return "0";
1105         }
1106         uint256 temp = value;
1107         uint256 digits;
1108         while (temp != 0) {
1109             digits++;
1110             temp /= 10;
1111         }
1112         bytes memory buffer = new bytes(digits);
1113         while (value != 0) {
1114             digits -= 1;
1115             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1116             value /= 10;
1117         }
1118         return string(buffer);
1119     }
1120 
1121     /**
1122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1123      */
1124     function toHexString(uint256 value) internal pure returns (string memory) {
1125         if (value == 0) {
1126             return "0x00";
1127         }
1128         uint256 temp = value;
1129         uint256 length = 0;
1130         while (temp != 0) {
1131             length++;
1132             temp >>= 8;
1133         }
1134         return toHexString(value, length);
1135     }
1136 
1137     /**
1138      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1139      */
1140     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1141         bytes memory buffer = new bytes(2 * length + 2);
1142         buffer[0] = "0";
1143         buffer[1] = "x";
1144         for (uint256 i = 2 * length + 1; i > 1; --i) {
1145             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1146             value >>= 4;
1147         }
1148         require(value == 0, "Strings: hex length insufficient");
1149         return string(buffer);
1150     }
1151 
1152     /**
1153      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1154      */
1155     function toHexString(address addr) internal pure returns (string memory) {
1156         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1157     }
1158 }
1159 
1160 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1161 
1162 
1163 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1164 
1165 pragma solidity ^0.8.0;
1166 
1167 /**
1168  * @dev Provides information about the current execution context, including the
1169  * sender of the transaction and its data. While these are generally available
1170  * via msg.sender and msg.data, they should not be accessed in such a direct
1171  * manner, since when dealing with meta-transactions the account sending and
1172  * paying for execution may not be the actual sender (as far as an application
1173  * is concerned).
1174  *
1175  * This contract is only required for intermediate, library-like contracts.
1176  */
1177 abstract contract Context {
1178     function _msgSender() internal view virtual returns (address) {
1179         return msg.sender;
1180     }
1181 
1182     function _msgData() internal view virtual returns (bytes calldata) {
1183         return msg.data;
1184     }
1185 }
1186 
1187 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1188 
1189 
1190 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 
1195 /**
1196  * @dev Contract module which provides a basic access control mechanism, where
1197  * there is an account (an owner) that can be granted exclusive access to
1198  * specific functions.
1199  *
1200  * By default, the owner account will be the one that deploys the contract. This
1201  * can later be changed with {transferOwnership}.
1202  *
1203  * This module is used through inheritance. It will make available the modifier
1204  * `onlyOwner`, which can be applied to your functions to restrict their use to
1205  * the owner.
1206  */
1207 abstract contract Ownable is Context {
1208     address private _owner;
1209 
1210     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1211 
1212     /**
1213      * @dev Initializes the contract setting the deployer as the initial owner.
1214      */
1215     constructor() {
1216         _transferOwnership(_msgSender());
1217     }
1218 
1219     /**
1220      * @dev Returns the address of the current owner.
1221      */
1222     function owner() public view virtual returns (address) {
1223         return _owner;
1224     }
1225 
1226     /**
1227      * @dev Throws if called by any account other than the owner.
1228      */
1229     modifier onlyOwner() {
1230         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1231         _;
1232     }
1233 
1234     /**
1235      * @dev Leaves the contract without owner. It will not be possible to call
1236      * `onlyOwner` functions anymore. Can only be called by the current owner.
1237      *
1238      * NOTE: Renouncing ownership will leave the contract without an owner,
1239      * thereby removing any functionality that is only available to the owner.
1240      */
1241     function renounceOwnership() public virtual onlyOwner {
1242         _transferOwnership(address(0));
1243     }
1244 
1245     /**
1246      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1247      * Can only be called by the current owner.
1248      */
1249     function transferOwnership(address newOwner) public virtual onlyOwner {
1250         require(newOwner != address(0), "Ownable: new owner is the zero address");
1251         _transferOwnership(newOwner);
1252     }
1253 
1254     /**
1255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1256      * Internal function without access restriction.
1257      */
1258     function _transferOwnership(address newOwner) internal virtual {
1259         address oldOwner = _owner;
1260         _owner = newOwner;
1261         emit OwnershipTransferred(oldOwner, newOwner);
1262     }
1263 }
1264 
1265 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1266 
1267 
1268 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1269 
1270 pragma solidity ^0.8.1;
1271 
1272 /**
1273  * @dev Collection of functions related to the address type
1274  */
1275 library Address {
1276     /**
1277      * @dev Returns true if `account` is a contract.
1278      *
1279      * [IMPORTANT]
1280      * ====
1281      * It is unsafe to assume that an address for which this function returns
1282      * false is an externally-owned account (EOA) and not a contract.
1283      *
1284      * Among others, `isContract` will return false for the following
1285      * types of addresses:
1286      *
1287      *  - an externally-owned account
1288      *  - a contract in construction
1289      *  - an address where a contract will be created
1290      *  - an address where a contract lived, but was destroyed
1291      * ====
1292      *
1293      * [IMPORTANT]
1294      * ====
1295      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1296      *
1297      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1298      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1299      * constructor.
1300      * ====
1301      */
1302     function isContract(address account) internal view returns (bool) {
1303         // This method relies on extcodesize/address.code.length, which returns 0
1304         // for contracts in construction, since the code is only stored at the end
1305         // of the constructor execution.
1306 
1307         return account.code.length > 0;
1308     }
1309 
1310     /**
1311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1312      * `recipient`, forwarding all available gas and reverting on errors.
1313      *
1314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1316      * imposed by `transfer`, making them unable to receive funds via
1317      * `transfer`. {sendValue} removes this limitation.
1318      *
1319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1320      *
1321      * IMPORTANT: because control is transferred to `recipient`, care must be
1322      * taken to not create reentrancy vulnerabilities. Consider using
1323      * {ReentrancyGuard} or the
1324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1325      */
1326     function sendValue(address payable recipient, uint256 amount) internal {
1327         require(address(this).balance >= amount, "Address: insufficient balance");
1328 
1329         (bool success, ) = recipient.call{value: amount}("");
1330         require(success, "Address: unable to send value, recipient may have reverted");
1331     }
1332 
1333     /**
1334      * @dev Performs a Solidity function call using a low level `call`. A
1335      * plain `call` is an unsafe replacement for a function call: use this
1336      * function instead.
1337      *
1338      * If `target` reverts with a revert reason, it is bubbled up by this
1339      * function (like regular Solidity function calls).
1340      *
1341      * Returns the raw returned data. To convert to the expected return value,
1342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1343      *
1344      * Requirements:
1345      *
1346      * - `target` must be a contract.
1347      * - calling `target` with `data` must not revert.
1348      *
1349      * _Available since v3.1._
1350      */
1351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1352         return functionCall(target, data, "Address: low-level call failed");
1353     }
1354 
1355     /**
1356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1357      * `errorMessage` as a fallback revert reason when `target` reverts.
1358      *
1359      * _Available since v3.1._
1360      */
1361     function functionCall(
1362         address target,
1363         bytes memory data,
1364         string memory errorMessage
1365     ) internal returns (bytes memory) {
1366         return functionCallWithValue(target, data, 0, errorMessage);
1367     }
1368 
1369     /**
1370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1371      * but also transferring `value` wei to `target`.
1372      *
1373      * Requirements:
1374      *
1375      * - the calling contract must have an ETH balance of at least `value`.
1376      * - the called Solidity function must be `payable`.
1377      *
1378      * _Available since v3.1._
1379      */
1380     function functionCallWithValue(
1381         address target,
1382         bytes memory data,
1383         uint256 value
1384     ) internal returns (bytes memory) {
1385         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1386     }
1387 
1388     /**
1389      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1390      * with `errorMessage` as a fallback revert reason when `target` reverts.
1391      *
1392      * _Available since v3.1._
1393      */
1394     function functionCallWithValue(
1395         address target,
1396         bytes memory data,
1397         uint256 value,
1398         string memory errorMessage
1399     ) internal returns (bytes memory) {
1400         require(address(this).balance >= value, "Address: insufficient balance for call");
1401         require(isContract(target), "Address: call to non-contract");
1402 
1403         (bool success, bytes memory returndata) = target.call{value: value}(data);
1404         return verifyCallResult(success, returndata, errorMessage);
1405     }
1406 
1407     /**
1408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1409      * but performing a static call.
1410      *
1411      * _Available since v3.3._
1412      */
1413     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1414         return functionStaticCall(target, data, "Address: low-level static call failed");
1415     }
1416 
1417     /**
1418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1419      * but performing a static call.
1420      *
1421      * _Available since v3.3._
1422      */
1423     function functionStaticCall(
1424         address target,
1425         bytes memory data,
1426         string memory errorMessage
1427     ) internal view returns (bytes memory) {
1428         require(isContract(target), "Address: static call to non-contract");
1429 
1430         (bool success, bytes memory returndata) = target.staticcall(data);
1431         return verifyCallResult(success, returndata, errorMessage);
1432     }
1433 
1434     /**
1435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1436      * but performing a delegate call.
1437      *
1438      * _Available since v3.4._
1439      */
1440     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1441         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1442     }
1443 
1444     /**
1445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1446      * but performing a delegate call.
1447      *
1448      * _Available since v3.4._
1449      */
1450     function functionDelegateCall(
1451         address target,
1452         bytes memory data,
1453         string memory errorMessage
1454     ) internal returns (bytes memory) {
1455         require(isContract(target), "Address: delegate call to non-contract");
1456 
1457         (bool success, bytes memory returndata) = target.delegatecall(data);
1458         return verifyCallResult(success, returndata, errorMessage);
1459     }
1460 
1461     /**
1462      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1463      * revert reason using the provided one.
1464      *
1465      * _Available since v4.3._
1466      */
1467     function verifyCallResult(
1468         bool success,
1469         bytes memory returndata,
1470         string memory errorMessage
1471     ) internal pure returns (bytes memory) {
1472         if (success) {
1473             return returndata;
1474         } else {
1475             // Look for revert reason and bubble it up if present
1476             if (returndata.length > 0) {
1477                 // The easiest way to bubble the revert reason is using memory via assembly
1478 
1479                 assembly {
1480                     let returndata_size := mload(returndata)
1481                     revert(add(32, returndata), returndata_size)
1482                 }
1483             } else {
1484                 revert(errorMessage);
1485             }
1486         }
1487     }
1488 }
1489 
1490 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1491 
1492 
1493 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1494 
1495 pragma solidity ^0.8.0;
1496 
1497 /**
1498  * @title ERC721 token receiver interface
1499  * @dev Interface for any contract that wants to support safeTransfers
1500  * from ERC721 asset contracts.
1501  */
1502 interface IERC721Receiver {
1503     /**
1504      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1505      * by `operator` from `from`, this function is called.
1506      *
1507      * It must return its Solidity selector to confirm the token transfer.
1508      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1509      *
1510      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1511      */
1512     function onERC721Received(
1513         address operator,
1514         address from,
1515         uint256 tokenId,
1516         bytes calldata data
1517     ) external returns (bytes4);
1518 }
1519 
1520 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1521 
1522 
1523 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1524 
1525 pragma solidity ^0.8.0;
1526 
1527 /**
1528  * @dev Interface of the ERC165 standard, as defined in the
1529  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1530  *
1531  * Implementers can declare support of contract interfaces, which can then be
1532  * queried by others ({ERC165Checker}).
1533  *
1534  * For an implementation, see {ERC165}.
1535  */
1536 interface IERC165 {
1537     /**
1538      * @dev Returns true if this contract implements the interface defined by
1539      * `interfaceId`. See the corresponding
1540      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1541      * to learn more about how these ids are created.
1542      *
1543      * This function call must use less than 30 000 gas.
1544      */
1545     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1546 }
1547 
1548 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1549 
1550 
1551 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1552 
1553 pragma solidity ^0.8.0;
1554 
1555 
1556 /**
1557  * @dev Implementation of the {IERC165} interface.
1558  *
1559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1560  * for the additional interface id that will be supported. For example:
1561  *
1562  * ```solidity
1563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1565  * }
1566  * ```
1567  *
1568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1569  */
1570 abstract contract ERC165 is IERC165 {
1571     /**
1572      * @dev See {IERC165-supportsInterface}.
1573      */
1574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1575         return interfaceId == type(IERC165).interfaceId;
1576     }
1577 }
1578 
1579 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1580 
1581 
1582 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1583 
1584 pragma solidity ^0.8.0;
1585 
1586 
1587 /**
1588  * @dev Required interface of an ERC721 compliant contract.
1589  */
1590 interface IERC721 is IERC165 {
1591     /**
1592      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1593      */
1594     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1595 
1596     /**
1597      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1598      */
1599     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1600 
1601     /**
1602      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1603      */
1604     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1605 
1606     /**
1607      * @dev Returns the number of tokens in ``owner``'s account.
1608      */
1609     function balanceOf(address owner) external view returns (uint256 balance);
1610 
1611     /**
1612      * @dev Returns the owner of the `tokenId` token.
1613      *
1614      * Requirements:
1615      *
1616      * - `tokenId` must exist.
1617      */
1618     function ownerOf(uint256 tokenId) external view returns (address owner);
1619 
1620     /**
1621      * @dev Safely transfers `tokenId` token from `from` to `to`.
1622      *
1623      * Requirements:
1624      *
1625      * - `from` cannot be the zero address.
1626      * - `to` cannot be the zero address.
1627      * - `tokenId` token must exist and be owned by `from`.
1628      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1630      *
1631      * Emits a {Transfer} event.
1632      */
1633     function safeTransferFrom(
1634         address from,
1635         address to,
1636         uint256 tokenId,
1637         bytes calldata data
1638     ) external;
1639 
1640     /**
1641      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1642      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1643      *
1644      * Requirements:
1645      *
1646      * - `from` cannot be the zero address.
1647      * - `to` cannot be the zero address.
1648      * - `tokenId` token must exist and be owned by `from`.
1649      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1650      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1651      *
1652      * Emits a {Transfer} event.
1653      */
1654     function safeTransferFrom(
1655         address from,
1656         address to,
1657         uint256 tokenId
1658     ) external;
1659 
1660     /**
1661      * @dev Transfers `tokenId` token from `from` to `to`.
1662      *
1663      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1664      *
1665      * Requirements:
1666      *
1667      * - `from` cannot be the zero address.
1668      * - `to` cannot be the zero address.
1669      * - `tokenId` token must be owned by `from`.
1670      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1671      *
1672      * Emits a {Transfer} event.
1673      */
1674     function transferFrom(
1675         address from,
1676         address to,
1677         uint256 tokenId
1678     ) external;
1679 
1680     /**
1681      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1682      * The approval is cleared when the token is transferred.
1683      *
1684      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1685      *
1686      * Requirements:
1687      *
1688      * - The caller must own the token or be an approved operator.
1689      * - `tokenId` must exist.
1690      *
1691      * Emits an {Approval} event.
1692      */
1693     function approve(address to, uint256 tokenId) external;
1694 
1695     /**
1696      * @dev Approve or remove `operator` as an operator for the caller.
1697      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1698      *
1699      * Requirements:
1700      *
1701      * - The `operator` cannot be the caller.
1702      *
1703      * Emits an {ApprovalForAll} event.
1704      */
1705     function setApprovalForAll(address operator, bool _approved) external;
1706 
1707     /**
1708      * @dev Returns the account approved for `tokenId` token.
1709      *
1710      * Requirements:
1711      *
1712      * - `tokenId` must exist.
1713      */
1714     function getApproved(uint256 tokenId) external view returns (address operator);
1715 
1716     /**
1717      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1718      *
1719      * See {setApprovalForAll}
1720      */
1721     function isApprovedForAll(address owner, address operator) external view returns (bool);
1722 }
1723 
1724 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1725 
1726 
1727 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1728 
1729 pragma solidity ^0.8.0;
1730 
1731 
1732 /**
1733  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1734  * @dev See https://eips.ethereum.org/EIPS/eip-721
1735  */
1736 interface IERC721Metadata is IERC721 {
1737     /**
1738      * @dev Returns the token collection name.
1739      */
1740     function name() external view returns (string memory);
1741 
1742     /**
1743      * @dev Returns the token collection symbol.
1744      */
1745     function symbol() external view returns (string memory);
1746 
1747     /**
1748      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1749      */
1750     function tokenURI(uint256 tokenId) external view returns (string memory);
1751 }
1752 
1753 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1754 
1755 
1756 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1757 
1758 pragma solidity ^0.8.0;
1759 
1760 
1761 
1762 
1763 
1764 
1765 
1766 
1767 /**
1768  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1769  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1770  * {ERC721Enumerable}.
1771  */
1772 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1773     using Address for address;
1774     using Strings for uint256;
1775 
1776     // Token name
1777     string private _name;
1778 
1779     // Token symbol
1780     string private _symbol;
1781 
1782     // Mapping from token ID to owner address
1783     mapping(uint256 => address) private _owners;
1784 
1785     // Mapping owner address to token count
1786     mapping(address => uint256) private _balances;
1787 
1788     // Mapping from token ID to approved address
1789     mapping(uint256 => address) private _tokenApprovals;
1790 
1791     // Mapping from owner to operator approvals
1792     mapping(address => mapping(address => bool)) private _operatorApprovals;
1793 
1794     /**
1795      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1796      */
1797     constructor(string memory name_, string memory symbol_) {
1798         _name = name_;
1799         _symbol = symbol_;
1800     }
1801 
1802     /**
1803      * @dev See {IERC165-supportsInterface}.
1804      */
1805     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1806         return
1807             interfaceId == type(IERC721).interfaceId ||
1808             interfaceId == type(IERC721Metadata).interfaceId ||
1809             super.supportsInterface(interfaceId);
1810     }
1811 
1812     /**
1813      * @dev See {IERC721-balanceOf}.
1814      */
1815     function balanceOf(address owner) public view virtual override returns (uint256) {
1816         require(owner != address(0), "ERC721: address zero is not a valid owner");
1817         return _balances[owner];
1818     }
1819 
1820     /**
1821      * @dev See {IERC721-ownerOf}.
1822      */
1823     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1824         address owner = _owners[tokenId];
1825         require(owner != address(0), "ERC721: owner query for nonexistent token");
1826         return owner;
1827     }
1828 
1829     /**
1830      * @dev See {IERC721Metadata-name}.
1831      */
1832     function name() public view virtual override returns (string memory) {
1833         return _name;
1834     }
1835 
1836     /**
1837      * @dev See {IERC721Metadata-symbol}.
1838      */
1839     function symbol() public view virtual override returns (string memory) {
1840         return _symbol;
1841     }
1842 
1843     /**
1844      * @dev See {IERC721Metadata-tokenURI}.
1845      */
1846     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1847         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1848 
1849         string memory baseURI = _baseURI();
1850         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1851     }
1852 
1853     /**
1854      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1855      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1856      * by default, can be overridden in child contracts.
1857      */
1858     function _baseURI() internal view virtual returns (string memory) {
1859         return "";
1860     }
1861 
1862     /**
1863      * @dev See {IERC721-approve}.
1864      */
1865     function approve(address to, uint256 tokenId) public virtual override {
1866         address owner = ERC721.ownerOf(tokenId);
1867         require(to != owner, "ERC721: approval to current owner");
1868 
1869         require(
1870             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1871             "ERC721: approve caller is not owner nor approved for all"
1872         );
1873 
1874         _approve(to, tokenId);
1875     }
1876 
1877     /**
1878      * @dev See {IERC721-getApproved}.
1879      */
1880     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1881         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1882 
1883         return _tokenApprovals[tokenId];
1884     }
1885 
1886     /**
1887      * @dev See {IERC721-setApprovalForAll}.
1888      */
1889     function setApprovalForAll(address operator, bool approved) public virtual override {
1890         _setApprovalForAll(_msgSender(), operator, approved);
1891     }
1892 
1893     /**
1894      * @dev See {IERC721-isApprovedForAll}.
1895      */
1896     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1897         return _operatorApprovals[owner][operator];
1898     }
1899 
1900     /**
1901      * @dev See {IERC721-transferFrom}.
1902      */
1903     function transferFrom(
1904         address from,
1905         address to,
1906         uint256 tokenId
1907     ) public virtual override {
1908         //solhint-disable-next-line max-line-length
1909         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1910 
1911         _transfer(from, to, tokenId);
1912     }
1913 
1914     /**
1915      * @dev See {IERC721-safeTransferFrom}.
1916      */
1917     function safeTransferFrom(
1918         address from,
1919         address to,
1920         uint256 tokenId
1921     ) public virtual override {
1922         safeTransferFrom(from, to, tokenId, "");
1923     }
1924 
1925     /**
1926      * @dev See {IERC721-safeTransferFrom}.
1927      */
1928     function safeTransferFrom(
1929         address from,
1930         address to,
1931         uint256 tokenId,
1932         bytes memory data
1933     ) public virtual override {
1934         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1935         _safeTransfer(from, to, tokenId, data);
1936     }
1937 
1938     /**
1939      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1940      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1941      *
1942      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1943      *
1944      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1945      * implement alternative mechanisms to perform token transfer, such as signature-based.
1946      *
1947      * Requirements:
1948      *
1949      * - `from` cannot be the zero address.
1950      * - `to` cannot be the zero address.
1951      * - `tokenId` token must exist and be owned by `from`.
1952      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1953      *
1954      * Emits a {Transfer} event.
1955      */
1956     function _safeTransfer(
1957         address from,
1958         address to,
1959         uint256 tokenId,
1960         bytes memory data
1961     ) internal virtual {
1962         _transfer(from, to, tokenId);
1963         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1964     }
1965 
1966     /**
1967      * @dev Returns whether `tokenId` exists.
1968      *
1969      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1970      *
1971      * Tokens start existing when they are minted (`_mint`),
1972      * and stop existing when they are burned (`_burn`).
1973      */
1974     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1975         return _owners[tokenId] != address(0);
1976     }
1977 
1978     /**
1979      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1980      *
1981      * Requirements:
1982      *
1983      * - `tokenId` must exist.
1984      */
1985     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1986         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1987         address owner = ERC721.ownerOf(tokenId);
1988         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1989     }
1990 
1991     /**
1992      * @dev Safely mints `tokenId` and transfers it to `to`.
1993      *
1994      * Requirements:
1995      *
1996      * - `tokenId` must not exist.
1997      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1998      *
1999      * Emits a {Transfer} event.
2000      */
2001     function _safeMint(address to, uint256 tokenId) internal virtual {
2002         _safeMint(to, tokenId, "");
2003     }
2004 
2005     /**
2006      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2007      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2008      */
2009     function _safeMint(
2010         address to,
2011         uint256 tokenId,
2012         bytes memory data
2013     ) internal virtual {
2014         _mint(to, tokenId);
2015         require(
2016             _checkOnERC721Received(address(0), to, tokenId, data),
2017             "ERC721: transfer to non ERC721Receiver implementer"
2018         );
2019     }
2020 
2021     /**
2022      * @dev Mints `tokenId` and transfers it to `to`.
2023      *
2024      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2025      *
2026      * Requirements:
2027      *
2028      * - `tokenId` must not exist.
2029      * - `to` cannot be the zero address.
2030      *
2031      * Emits a {Transfer} event.
2032      */
2033     function _mint(address to, uint256 tokenId) internal virtual {
2034         require(to != address(0), "ERC721: mint to the zero address");
2035         require(!_exists(tokenId), "ERC721: token already minted");
2036 
2037         _beforeTokenTransfer(address(0), to, tokenId);
2038 
2039         _balances[to] += 1;
2040         _owners[tokenId] = to;
2041 
2042         emit Transfer(address(0), to, tokenId);
2043 
2044         _afterTokenTransfer(address(0), to, tokenId);
2045     }
2046 
2047     /**
2048      * @dev Destroys `tokenId`.
2049      * The approval is cleared when the token is burned.
2050      *
2051      * Requirements:
2052      *
2053      * - `tokenId` must exist.
2054      *
2055      * Emits a {Transfer} event.
2056      */
2057     function _burn(uint256 tokenId) internal virtual {
2058         address owner = ERC721.ownerOf(tokenId);
2059 
2060         _beforeTokenTransfer(owner, address(0), tokenId);
2061 
2062         // Clear approvals
2063         _approve(address(0), tokenId);
2064 
2065         _balances[owner] -= 1;
2066         delete _owners[tokenId];
2067 
2068         emit Transfer(owner, address(0), tokenId);
2069 
2070         _afterTokenTransfer(owner, address(0), tokenId);
2071     }
2072 
2073     /**
2074      * @dev Transfers `tokenId` from `from` to `to`.
2075      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2076      *
2077      * Requirements:
2078      *
2079      * - `to` cannot be the zero address.
2080      * - `tokenId` token must be owned by `from`.
2081      *
2082      * Emits a {Transfer} event.
2083      */
2084     function _transfer(
2085         address from,
2086         address to,
2087         uint256 tokenId
2088     ) internal virtual {
2089         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2090         require(to != address(0), "ERC721: transfer to the zero address");
2091 
2092         _beforeTokenTransfer(from, to, tokenId);
2093 
2094         // Clear approvals from the previous owner
2095         _approve(address(0), tokenId);
2096 
2097         _balances[from] -= 1;
2098         _balances[to] += 1;
2099         _owners[tokenId] = to;
2100 
2101         emit Transfer(from, to, tokenId);
2102 
2103         _afterTokenTransfer(from, to, tokenId);
2104     }
2105 
2106     /**
2107      * @dev Approve `to` to operate on `tokenId`
2108      *
2109      * Emits an {Approval} event.
2110      */
2111     function _approve(address to, uint256 tokenId) internal virtual {
2112         _tokenApprovals[tokenId] = to;
2113         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2114     }
2115 
2116     /**
2117      * @dev Approve `operator` to operate on all of `owner` tokens
2118      *
2119      * Emits an {ApprovalForAll} event.
2120      */
2121     function _setApprovalForAll(
2122         address owner,
2123         address operator,
2124         bool approved
2125     ) internal virtual {
2126         require(owner != operator, "ERC721: approve to caller");
2127         _operatorApprovals[owner][operator] = approved;
2128         emit ApprovalForAll(owner, operator, approved);
2129     }
2130 
2131     /**
2132      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2133      * The call is not executed if the target address is not a contract.
2134      *
2135      * @param from address representing the previous owner of the given token ID
2136      * @param to target address that will receive the tokens
2137      * @param tokenId uint256 ID of the token to be transferred
2138      * @param data bytes optional data to send along with the call
2139      * @return bool whether the call correctly returned the expected magic value
2140      */
2141     function _checkOnERC721Received(
2142         address from,
2143         address to,
2144         uint256 tokenId,
2145         bytes memory data
2146     ) private returns (bool) {
2147         if (to.isContract()) {
2148             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2149                 return retval == IERC721Receiver.onERC721Received.selector;
2150             } catch (bytes memory reason) {
2151                 if (reason.length == 0) {
2152                     revert("ERC721: transfer to non ERC721Receiver implementer");
2153                 } else {
2154                     assembly {
2155                         revert(add(32, reason), mload(reason))
2156                     }
2157                 }
2158             }
2159         } else {
2160             return true;
2161         }
2162     }
2163 
2164     /**
2165      * @dev Hook that is called before any token transfer. This includes minting
2166      * and burning.
2167      *
2168      * Calling conditions:
2169      *
2170      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2171      * transferred to `to`.
2172      * - When `from` is zero, `tokenId` will be minted for `to`.
2173      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2174      * - `from` and `to` are never both zero.
2175      *
2176      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2177      */
2178     function _beforeTokenTransfer(
2179         address from,
2180         address to,
2181         uint256 tokenId
2182     ) internal virtual {}
2183 
2184     /**
2185      * @dev Hook that is called after any transfer of tokens. This includes
2186      * minting and burning.
2187      *
2188      * Calling conditions:
2189      *
2190      * - when `from` and `to` are both non-zero.
2191      * - `from` and `to` are never both zero.
2192      *
2193      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2194      */
2195     function _afterTokenTransfer(
2196         address from,
2197         address to,
2198         uint256 tokenId
2199     ) internal virtual {}
2200 }
2201 
2202 
2203 pragma solidity ^0.8.0;
2204 
2205 
2206 contract XX4MIG05 is ERC721A, Ownable {
2207 
2208     using Strings for uint256;
2209     string private baseURI;
2210     uint256 public price = 0.004 ether;
2211     uint256 public maxPerTx = 10;
2212     uint256 public maxFreePerWallet = 1;
2213     uint256 public totalFree = 5000;
2214     uint256 public maxSupply = 5000;
2215 
2216     bool public mintEnabled = false;
2217 
2218     mapping(address => uint256) private _mintedFreeAmount;
2219 
2220     constructor() ERC721A("XX4MIG05", "AMIGO") {
2221         _safeMint(msg.sender, 1);
2222         setBaseURI("ipfs://bafybeiamo5hxiqyyj4yegnizjcdtjsdxykmhzzfd4fhwosantfhrjj5mb4/");
2223     }
2224 
2225     function mint(uint256 count) external payable {
2226         uint256 cost = price;
2227         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2228             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2229 
2230         if (isFree) {
2231             cost = 0;
2232         }
2233 
2234         require(msg.value >= count * cost, "Please send the exact amount.");
2235         require(totalSupply() + count < maxSupply + 1, "No more left.");
2236         require(mintEnabled, "Mint is not live yet.");
2237         require(count < maxPerTx + 1, "Max per TX reached.");
2238         require(tx.origin == msg.sender, "Contracts not allowed to mint.");
2239 
2240 
2241         if (isFree) {
2242             _mintedFreeAmount[msg.sender] += count;
2243         }
2244 
2245         _safeMint(msg.sender, count);
2246     }
2247 
2248     function _baseURI() internal view virtual override returns (string memory) {
2249         return baseURI;
2250     }
2251 
2252     function tokenURI(uint256 tokenId)
2253         public
2254         view
2255         virtual
2256         override
2257         returns (string memory)
2258     {
2259         require(
2260             _exists(tokenId),
2261             "ERC721Metadata: URI query for nonexistent token"
2262         );
2263         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2264     }
2265 
2266     function setBaseURI(string memory uri) public onlyOwner {
2267         baseURI = uri;
2268     }
2269 
2270     function setFreeAmount(uint256 amount) external onlyOwner {
2271         totalFree = amount;
2272     }
2273 
2274     function setPrice(uint256 _newPrice) external onlyOwner {
2275         price = _newPrice;
2276     }
2277 
2278     function flipSale() external onlyOwner {
2279         mintEnabled = !mintEnabled;
2280     }
2281 
2282     function withdraw() external onlyOwner {
2283         (bool success, ) = payable(msg.sender).call{
2284             value: address(this).balance
2285         }("");
2286         require(success, "Transfer failed.");
2287     }
2288 }