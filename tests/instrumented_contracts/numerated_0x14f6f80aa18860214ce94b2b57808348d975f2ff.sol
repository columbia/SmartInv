1 // SPDX-License-Identifier: MIT
2 // File: contracts/IERC721A.sol
3 
4 
5 // ERC721A Contracts v4.0.0
6 // Creator: Chiru Labs
7 
8 pragma solidity ^0.8.4;
9 
10 /**
11  * @dev Interface of an ERC721A compliant contract.
12  */
13 interface IERC721A {
14     /**
15      * The caller must own the token or be an approved operator.
16      */
17     error ApprovalCallerNotOwnerNorApproved();
18 
19     /**
20      * The token does not exist.
21      */
22     error ApprovalQueryForNonexistentToken();
23 
24     /**
25      * The caller cannot approve to their own address.
26      */
27     error ApproveToCaller();
28 
29     /**
30      * The caller cannot approve to the current owner.
31      */
32     error ApprovalToCurrentOwner();
33 
34     /**
35      * Cannot query the balance for the zero address.
36      */
37     error BalanceQueryForZeroAddress();
38 
39     /**
40      * Cannot mint to the zero address.
41      */
42     error MintToZeroAddress();
43 
44     /**
45      * The quantity of tokens minted must be more than zero.
46      */
47     error MintZeroQuantity();
48 
49     /**
50      * The token does not exist.
51      */
52     error OwnerQueryForNonexistentToken();
53 
54     /**
55      * The caller must own the token or be an approved operator.
56      */
57     error TransferCallerNotOwnerNorApproved();
58 
59     /**
60      * The token must be owned by `from`.
61      */
62     error TransferFromIncorrectOwner();
63 
64     /**
65      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
66      */
67     error TransferToNonERC721ReceiverImplementer();
68 
69     /**
70      * Cannot transfer to the zero address.
71      */
72     error TransferToZeroAddress();
73 
74     /**
75      * The token does not exist.
76      */
77     error URIQueryForNonexistentToken();
78 
79     struct TokenOwnership {
80         // The address of the owner.
81         address addr;
82         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
83         uint64 startTimestamp;
84         // Whether the token has been burned.
85         bool burned;
86     }
87 
88     /**
89      * @dev Returns the total amount of tokens stored by the contract.
90      *
91      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
92      */
93     function totalSupply() external view returns (uint256);
94 
95     // ==============================
96     //            IERC165
97     // ==============================
98 
99     /**
100      * @dev Returns true if this contract implements the interface defined by
101      * `interfaceId`. See the corresponding
102      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
103      * to learn more about how these ids are created.
104      *
105      * This function call must use less than 30 000 gas.
106      */
107     function supportsInterface(bytes4 interfaceId) external view returns (bool);
108 
109     // ==============================
110     //            IERC721
111     // ==============================
112 
113     /**
114      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
115      */
116     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
117 
118     /**
119      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
120      */
121     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
122 
123     /**
124      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
125      */
126     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
127 
128     /**
129      * @dev Returns the number of tokens in ``owner``'s account.
130      */
131     function balanceOf(address owner) external view returns (uint256 balance);
132 
133     /**
134      * @dev Returns the owner of the `tokenId` token.
135      *
136      * Requirements:
137      *
138      * - `tokenId` must exist.
139      */
140     function ownerOf(uint256 tokenId) external view returns (address owner);
141 
142     /**
143      * @dev Safely transfers `tokenId` token from `from` to `to`.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId,
159         bytes calldata data
160     ) external;
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
164      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId
180     ) external;
181 
182     /**
183      * @dev Transfers `tokenId` token from `from` to `to`.
184      *
185      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must be owned by `from`.
192      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transferFrom(
197         address from,
198         address to,
199         uint256 tokenId
200     ) external;
201 
202     /**
203      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
204      * The approval is cleared when the token is transferred.
205      *
206      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
207      *
208      * Requirements:
209      *
210      * - The caller must own the token or be an approved operator.
211      * - `tokenId` must exist.
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address to, uint256 tokenId) external;
216 
217     /**
218      * @dev Approve or remove `operator` as an operator for the caller.
219      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
220      *
221      * Requirements:
222      *
223      * - The `operator` cannot be the caller.
224      *
225      * Emits an {ApprovalForAll} event.
226      */
227     function setApprovalForAll(address operator, bool _approved) external;
228 
229     /**
230      * @dev Returns the account approved for `tokenId` token.
231      *
232      * Requirements:
233      *
234      * - `tokenId` must exist.
235      */
236     function getApproved(uint256 tokenId) external view returns (address operator);
237 
238     /**
239      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
240      *
241      * See {setApprovalForAll}
242      */
243     function isApprovedForAll(address owner, address operator) external view returns (bool);
244 
245     // ==============================
246     //        IERC721Metadata
247     // ==============================
248 
249     /**
250      * @dev Returns the token collection name.
251      */
252     function name() external view returns (string memory);
253 
254     /**
255      * @dev Returns the token collection symbol.
256      */
257     function symbol() external view returns (string memory);
258 
259     /**
260      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
261      */
262     function tokenURI(uint256 tokenId) external view returns (string memory);
263 }
264 // File: contracts/ERC721A.sol
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
1088 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1089 
1090 
1091 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1092 
1093 pragma solidity ^0.8.0;
1094 
1095 /**
1096  * @dev These functions deal with verification of Merkle Tree proofs.
1097  *
1098  * The proofs can be generated using the JavaScript library
1099  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1100  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1101  *
1102  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1103  *
1104  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1105  * hashing, or use a hash function other than keccak256 for hashing leaves.
1106  * This is because the concatenation of a sorted pair of internal nodes in
1107  * the merkle tree could be reinterpreted as a leaf value.
1108  */
1109 library MerkleProof {
1110     /**
1111      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1112      * defined by `root`. For this, a `proof` must be provided, containing
1113      * sibling hashes on the branch from the leaf to the root of the tree. Each
1114      * pair of leaves and each pair of pre-images are assumed to be sorted.
1115      */
1116     function verify(
1117         bytes32[] memory proof,
1118         bytes32 root,
1119         bytes32 leaf
1120     ) internal pure returns (bool) {
1121         return processProof(proof, leaf) == root;
1122     }
1123 
1124     /**
1125      * @dev Calldata version of {verify}
1126      *
1127      * _Available since v4.7._
1128      */
1129     function verifyCalldata(
1130         bytes32[] calldata proof,
1131         bytes32 root,
1132         bytes32 leaf
1133     ) internal pure returns (bool) {
1134         return processProofCalldata(proof, leaf) == root;
1135     }
1136 
1137     /**
1138      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1139      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1140      * hash matches the root of the tree. When processing the proof, the pairs
1141      * of leafs & pre-images are assumed to be sorted.
1142      *
1143      * _Available since v4.4._
1144      */
1145     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1146         bytes32 computedHash = leaf;
1147         for (uint256 i = 0; i < proof.length; i++) {
1148             computedHash = _hashPair(computedHash, proof[i]);
1149         }
1150         return computedHash;
1151     }
1152 
1153     /**
1154      * @dev Calldata version of {processProof}
1155      *
1156      * _Available since v4.7._
1157      */
1158     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1159         bytes32 computedHash = leaf;
1160         for (uint256 i = 0; i < proof.length; i++) {
1161             computedHash = _hashPair(computedHash, proof[i]);
1162         }
1163         return computedHash;
1164     }
1165 
1166     /**
1167      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1168      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1169      *
1170      * _Available since v4.7._
1171      */
1172     function multiProofVerify(
1173         bytes32[] memory proof,
1174         bool[] memory proofFlags,
1175         bytes32 root,
1176         bytes32[] memory leaves
1177     ) internal pure returns (bool) {
1178         return processMultiProof(proof, proofFlags, leaves) == root;
1179     }
1180 
1181     /**
1182      * @dev Calldata version of {multiProofVerify}
1183      *
1184      * _Available since v4.7._
1185      */
1186     function multiProofVerifyCalldata(
1187         bytes32[] calldata proof,
1188         bool[] calldata proofFlags,
1189         bytes32 root,
1190         bytes32[] memory leaves
1191     ) internal pure returns (bool) {
1192         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1193     }
1194 
1195     /**
1196      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1197      * consuming from one or the other at each step according to the instructions given by
1198      * `proofFlags`.
1199      *
1200      * _Available since v4.7._
1201      */
1202     function processMultiProof(
1203         bytes32[] memory proof,
1204         bool[] memory proofFlags,
1205         bytes32[] memory leaves
1206     ) internal pure returns (bytes32 merkleRoot) {
1207         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1208         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1209         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1210         // the merkle tree.
1211         uint256 leavesLen = leaves.length;
1212         uint256 totalHashes = proofFlags.length;
1213 
1214         // Check proof validity.
1215         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1216 
1217         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1218         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1219         bytes32[] memory hashes = new bytes32[](totalHashes);
1220         uint256 leafPos = 0;
1221         uint256 hashPos = 0;
1222         uint256 proofPos = 0;
1223         // At each step, we compute the next hash using two values:
1224         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1225         //   get the next hash.
1226         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1227         //   `proof` array.
1228         for (uint256 i = 0; i < totalHashes; i++) {
1229             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1230             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1231             hashes[i] = _hashPair(a, b);
1232         }
1233 
1234         if (totalHashes > 0) {
1235             return hashes[totalHashes - 1];
1236         } else if (leavesLen > 0) {
1237             return leaves[0];
1238         } else {
1239             return proof[0];
1240         }
1241     }
1242 
1243     /**
1244      * @dev Calldata version of {processMultiProof}
1245      *
1246      * _Available since v4.7._
1247      */
1248     function processMultiProofCalldata(
1249         bytes32[] calldata proof,
1250         bool[] calldata proofFlags,
1251         bytes32[] memory leaves
1252     ) internal pure returns (bytes32 merkleRoot) {
1253         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1254         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1255         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1256         // the merkle tree.
1257         uint256 leavesLen = leaves.length;
1258         uint256 totalHashes = proofFlags.length;
1259 
1260         // Check proof validity.
1261         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1262 
1263         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1264         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1265         bytes32[] memory hashes = new bytes32[](totalHashes);
1266         uint256 leafPos = 0;
1267         uint256 hashPos = 0;
1268         uint256 proofPos = 0;
1269         // At each step, we compute the next hash using two values:
1270         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1271         //   get the next hash.
1272         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1273         //   `proof` array.
1274         for (uint256 i = 0; i < totalHashes; i++) {
1275             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1276             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1277             hashes[i] = _hashPair(a, b);
1278         }
1279 
1280         if (totalHashes > 0) {
1281             return hashes[totalHashes - 1];
1282         } else if (leavesLen > 0) {
1283             return leaves[0];
1284         } else {
1285             return proof[0];
1286         }
1287     }
1288 
1289     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1290         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1291     }
1292 
1293     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1294         /// @solidity memory-safe-assembly
1295         assembly {
1296             mstore(0x00, a)
1297             mstore(0x20, b)
1298             value := keccak256(0x00, 0x40)
1299         }
1300     }
1301 }
1302 
1303 // File: @openzeppelin/contracts/utils/Strings.sol
1304 
1305 
1306 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1307 
1308 pragma solidity ^0.8.0;
1309 
1310 /**
1311  * @dev String operations.
1312  */
1313 library Strings {
1314     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1315     uint8 private constant _ADDRESS_LENGTH = 20;
1316 
1317     /**
1318      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1319      */
1320     function toString(uint256 value) internal pure returns (string memory) {
1321         // Inspired by OraclizeAPI's implementation - MIT licence
1322         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1323 
1324         if (value == 0) {
1325             return "0";
1326         }
1327         uint256 temp = value;
1328         uint256 digits;
1329         while (temp != 0) {
1330             digits++;
1331             temp /= 10;
1332         }
1333         bytes memory buffer = new bytes(digits);
1334         while (value != 0) {
1335             digits -= 1;
1336             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1337             value /= 10;
1338         }
1339         return string(buffer);
1340     }
1341 
1342     /**
1343      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1344      */
1345     function toHexString(uint256 value) internal pure returns (string memory) {
1346         if (value == 0) {
1347             return "0x00";
1348         }
1349         uint256 temp = value;
1350         uint256 length = 0;
1351         while (temp != 0) {
1352             length++;
1353             temp >>= 8;
1354         }
1355         return toHexString(value, length);
1356     }
1357 
1358     /**
1359      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1360      */
1361     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1362         bytes memory buffer = new bytes(2 * length + 2);
1363         buffer[0] = "0";
1364         buffer[1] = "x";
1365         for (uint256 i = 2 * length + 1; i > 1; --i) {
1366             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1367             value >>= 4;
1368         }
1369         require(value == 0, "Strings: hex length insufficient");
1370         return string(buffer);
1371     }
1372 
1373     /**
1374      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1375      */
1376     function toHexString(address addr) internal pure returns (string memory) {
1377         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1378     }
1379 }
1380 
1381 // File: @openzeppelin/contracts/utils/Context.sol
1382 
1383 
1384 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1385 
1386 pragma solidity ^0.8.0;
1387 
1388 /**
1389  * @dev Provides information about the current execution context, including the
1390  * sender of the transaction and its data. While these are generally available
1391  * via msg.sender and msg.data, they should not be accessed in such a direct
1392  * manner, since when dealing with meta-transactions the account sending and
1393  * paying for execution may not be the actual sender (as far as an application
1394  * is concerned).
1395  *
1396  * This contract is only required for intermediate, library-like contracts.
1397  */
1398 abstract contract Context {
1399     function _msgSender() internal view virtual returns (address) {
1400         return msg.sender;
1401     }
1402 
1403     function _msgData() internal view virtual returns (bytes calldata) {
1404         return msg.data;
1405     }
1406 }
1407 
1408 // File: @openzeppelin/contracts/access/Ownable.sol
1409 
1410 
1411 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
1437         _transferOwnership(_msgSender());
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
1463         _transferOwnership(address(0));
1464     }
1465 
1466     /**
1467      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1468      * Can only be called by the current owner.
1469      */
1470     function transferOwnership(address newOwner) public virtual onlyOwner {
1471         require(newOwner != address(0), "Ownable: new owner is the zero address");
1472         _transferOwnership(newOwner);
1473     }
1474 
1475     /**
1476      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1477      * Internal function without access restriction.
1478      */
1479     function _transferOwnership(address newOwner) internal virtual {
1480         address oldOwner = _owner;
1481         _owner = newOwner;
1482         emit OwnershipTransferred(oldOwner, newOwner);
1483     }
1484 }
1485 
1486 // File: contracts/VerbToy.sol
1487 
1488 
1489 pragma solidity ^0.8.0;
1490 
1491 
1492 
1493 
1494 interface iVerb {
1495     function ownerOf(uint256 tokenId) external view returns (address);
1496     }
1497 contract VerbToy is ERC721A, Ownable {
1498      iVerb public Verb;
1499 
1500     uint256 public MAX_SUPPLY = 7000;
1501 
1502     bool public isPresaleActive = false;
1503 
1504     bool _revealed = false;
1505 
1506     string private baseURI = "";
1507 
1508     bytes32 freemintRoot;
1509 
1510     struct UserPurchaseInfo {
1511         uint256 freeMinted;
1512     }
1513 
1514     mapping(address => UserPurchaseInfo) public userPurchase;
1515     mapping(address => uint256) addressBlockBought;
1516     mapping(uint256 => bool) public claimed;
1517     uint256[] public claimedIds;
1518     mapping(bytes32 => bool) public usedDigests;
1519 
1520     constructor(address VerbAddress) ERC721A("VerbToy", "VerbToy") {
1521           Verb = iVerb(VerbAddress);
1522     }
1523 
1524     modifier isSecured(uint8 mintType) {
1525         require(
1526             addressBlockBought[msg.sender] < block.timestamp,
1527             "CANNOT_MINT_ON_THE_SAME_BLOCK"
1528         );
1529         require(tx.origin == msg.sender, "CONTRACTS_NOT_ALLOWED_TO_MINT");
1530         if (mintType == 3) {
1531             require(isPresaleActive, "FREE_MINT_IS_NOT_YET_ACTIVE");
1532         }
1533 
1534         _;
1535     }
1536 
1537     modifier supplyMintLimit(uint256 numberOfTokens) {
1538         require(
1539             numberOfTokens + totalSupply() <= MAX_SUPPLY,
1540             "NOT_ENOUGH_SUPPLY"
1541         );
1542         _;
1543     }
1544 
1545     function mint(uint256[] memory tokenIds)
1546         external
1547         isSecured(3)
1548         supplyMintLimit(tokenIds.length)
1549     {
1550         for(uint256 id = 0; id < tokenIds.length; id++) {
1551             require(Verb.ownerOf(tokenIds[id]) == msg.sender, "MUST_OWN_ALL_TOKENS");
1552             require(claimed[tokenIds[id]] == false, "TOKEN_ALREADY_CLAIMED");
1553             claimed[tokenIds[id]] = true;
1554             claimedIds.push(tokenIds[id]);
1555         }
1556         addressBlockBought[msg.sender] = block.timestamp;
1557 
1558         uint256 bonus = 0;
1559         bonus = (tokenIds.length / 8) * 2;
1560         
1561         _mint(msg.sender, tokenIds.length + bonus);
1562     }
1563 
1564     function freeMint(
1565         bytes32[] memory proof,
1566         uint256 numberOfTokens,
1567         uint256 maxMint
1568     ) external isSecured(3) supplyMintLimit(numberOfTokens) {
1569         bytes32 leaf = keccak256(abi.encodePacked(msg.sender, maxMint));
1570         require(MerkleProof.verify(proof, freemintRoot, leaf), "PROOF_INVALID");
1571         require(
1572             userPurchase[msg.sender].freeMinted + numberOfTokens <= maxMint,
1573             "EXCEED_ALLOCATED_MINT_LIMIT"
1574         );
1575         addressBlockBought[msg.sender] = block.timestamp;
1576         userPurchase[msg.sender].freeMinted += numberOfTokens;
1577         _mint(msg.sender, numberOfTokens);
1578     }
1579 
1580     function devMint(address[] memory _addresses, uint256[] memory quantities)
1581         external
1582         onlyOwner
1583     {
1584         require(_addresses.length == quantities.length, "WRONG_PARAMETERS");
1585         uint256 totalTokens = 0;
1586         for (uint256 i = 0; i < quantities.length; i++) {
1587             totalTokens += quantities[i];
1588         }
1589         require(totalTokens + totalSupply() <= MAX_SUPPLY, "NOT_ENOUGH_SUPPLY");
1590         for (uint256 i = 0; i < _addresses.length; i++) {
1591             _safeMint(_addresses[i], quantities[i]);
1592         }
1593     }
1594 
1595     //Essential
1596     function setBaseURI(string calldata URI) external onlyOwner {
1597         baseURI = URI;
1598     }
1599 
1600     function reveal(bool revealed, string calldata _baseURI) public onlyOwner {
1601         _revealed = revealed;
1602         baseURI = _baseURI;
1603     }
1604 
1605     function setPreSaleStatus() external onlyOwner {
1606         isPresaleActive = !isPresaleActive;
1607     }
1608 
1609     function tokenURI(uint256 tokenId)
1610         public
1611         view
1612         virtual
1613         override
1614         returns (string memory)
1615     {
1616         if (_revealed) {
1617             return string(abi.encodePacked(baseURI, Strings.toString(tokenId)));
1618         } else {
1619             return string(abi.encodePacked(baseURI));
1620         }
1621     }
1622 
1623     function setFreeMintRoot(bytes32 _freemintRoot) external onlyOwner {
1624         freemintRoot = _freemintRoot;
1625     }
1626 
1627     function decreaseSupply(uint256 _maxSupply) external onlyOwner {
1628         require(_maxSupply < MAX_SUPPLY, "CANT_INCREASE_SUPPLY");
1629         MAX_SUPPLY = _maxSupply;
1630     }
1631 
1632     function getClaimed()
1633         public
1634         view
1635         returns (uint256[] memory)
1636     {
1637         return claimedIds;
1638     }
1639 }